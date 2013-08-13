require_relative './lib/semantria'

$consumer_key = 'd2fcfafb-40ea-4e2d-9446-d355c1e0fab3'
$consumer_secret = '85b632d2-c68a-49f3-8b98-1ee8b0a364da'

class SessionCallbackHandler < CallbackHandler
  def onRequest(sender, args)
  end

  def onResponse(sender, args)
  end

  def onError(sender, args)
    print 'Error: ', args, "\n"
  end

  def onDocsAutoResponse(sender, args)
  end

  def onCollsAutoResponse(sender, args)
  end
end

class CommitAnalyzer

  attr_reader :session, :commits, :results, :filename

  def initialize(commits,filename='/tmp/results.json')
    @session = Session.new($consumer_key, $consumer_secret, 'TestApp', true)
    callback = SessionCallbackHandler.new()
    @session.setCallbackHandler(callback)
    @commits = commits
    @filename = filename
  end

  def run
    upload_commits
    wait_for_upload
    print_results
    write_results(filename)
    scores
  end

  def upload_commits
    # Initializes new session with the keys and app name.
    # We also will use compression.
    # Initialize session callback handlers
    commits.each do |commit|

      message = commit.map(&:message).join
      # Semantria limits maximum size for text per document to 8192 characters
      message.slice!(8192, message.length)
      # Creates a sample document which need to be processed on Semantria
      # Unique document ID
      # Source text which need to be processed
      doc = {'id' => rand(10 ** 10).to_s.rjust(10, '0'), 'text' => message}
      # Queues document for processing on Semantria service
      status = session.queueDocument(doc)
      # Check status from Semantria service
      if status == 202
        print 'Document ', doc['id'], ' queued successfully.', "\r\n"
      end
    end
  end

  def wait_for_upload
    length = commits.length
    @results = []

    while results.length < length
      print 'Please wait 10 sec for documents ...', "\r\n"
      # As Semantria isn't real-time solution you need to wait some time before getting of the processed results
      # In real application here can be implemented two separate jobs, one for queuing of source data another one for retreiving
      # Wait ten seconds while Semantria process queued document
      sleep(10)
      # Requests processed results from Semantria service
      status = session.getProcessedDocuments()
      # Check status from Semantria service
      status.is_a? Array and status.each do |object|
        @results.push(object)
      end
      print status.length, ' documents received successfully.', "\r\n"
    end
  end

  def print_results
    results.each do |result|
      # Printing of document sentiment score
      print 'Document ', result['id'], ' Sentiment score: ', result['sentiment_score'], "\r\n"

      # Printing of document themes
      print 'Document themes:', "\r\n"
      result['themes'].nil? or result['themes'].each do |theme|
        print '  ', theme['title'], ' (sentiment: ', theme['sentiment_score'], ")", "\r\n"
      end

      # Printing of document entities
      print 'Entities:', "\r\n"
      result['entities'].nil? or result['entities'].each do |entity|
        print '  ', entity['title'], ' : ', entity['entity_type'], ' (sentiment: ', entity['sentiment_score'], ')', "\r\n"
      end

      print "\r\n"
    end
  end

  def write_results(filename)
    File.open(filename,'w') do |f|
      f << results.to_json
    end
  end

  def load_from_cache
    @results = JSON.parse(File.read(filename))
  end

  def scores
    @scores ||= results.map do |result|
      result['sentiment_score']
    end
  end

end
