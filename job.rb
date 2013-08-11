class Job
  attr_accessor :repo

  def initialize(repo)
    @repo = repo
  end

  def load_commits
    @commits = GitLoader.new(job.repo).commits
  end

  def analyze_sentiments
    analyzer = CommitAnalyzer.new(@commits, sentitment_file)
    analyzer.run unless has_sentiments?
    @sentiments = analyzer.scores
  end

  def has_sentiments?
    File.exists? sentitment_file
  end

  def sentitment_file
    @sentitment_file ||= "./cache/#{sanitized_repo}.json"
  end

  def sanitized_repo
    repo.gsub(/\W/,'')
  end

  def output
    @output ||= "./midifiles/#{sanitized_repo}.mid"
  end

  # returns an array of commits grouped by size
  def sections
    unless @groups
      @groups = []
      parsed_commits.each_slice(group_size).to_a.each_with_index do |commits,i|
        Section.new(sentitment: @scores[i], commits:commits)
      end
    end
    @groups
  end

  def write_output(path=output)
    File.open(path, 'wb') do |f|
      f.write(file.toBytes)
    end
  end

  def create_song(key='c')
    song = Song.new(key)
    sections do |section|
      section.track = song.create_track
      section.channel = 0
      song.add_section(section)

      authors = group.authors.map do |name|
        Author.new(name, section.channel, song.strategy, section.track)
      end

      section.commits.each do |commit|
        a.play(scale)
      end
    end
  end

  private

  def group_size
    [(parsed_commits.count/@sections.to_f).floor,1].max
  end
end
