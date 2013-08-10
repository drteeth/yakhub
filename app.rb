require 'pry'
require_relative 'semantria/commit_analyzer'
require_relative 'github/git_loader'
require_relative 'rbmidgen/rbmidgen'

require_relative 'scale'
require_relative 'play_degree'
require_relative 'author'

repo = './ember.js'
loader = GitLoader.new(repo)
commits = loader.grouped_commits

response = "#{repo}.json"
analyzer = CommitAnalyzer.new(commits, response)
unless File.exists?(response)
  analyzer.run
end
scores = analyzer.load_scores(response).scores

ScaleIntervals = {
  major: [0,2,4,5,7,9,11],
  minor: [0,2,3,5,7,9,11],
}

def sentiment_to_scale(key, sentiment)
  intervals = ScaleIntervals.values.shuffle.first
  Scale.new(key, intervals)
end

def key_algo(key)
  n = Scale::AllNotes
  i = (n.index(key)+1) % n.count
  n[i]
end

def next_channel
  @last_channel ||= 0
  @last_channel += 1
  @last_channel % 16
end

file = MidiFile.new
commits.each_with_index do |commit_group, i|
  key ||= 'c'
  scale = sentiment_to_scale(key, scores[i])

  authors = {}
  commit_group.each_with_index do |commit,j|
    author_name = commit.name
    a = if authors.has_key?(author_name)
      authors[author_name]
    else
      strategy = PlayDegree.new(i+1)
      channel = next_channel
      author = Author.new(author_name, channel, strategy)
      authors[author_name] = author
      file.addTrack(author.track)
      author
    end
    a.play(scale)
  end
end

File.open('test2.mid', 'wb') do |f|
  f.write(file.toBytes)
end
