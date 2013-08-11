require_relative 'song'
require_relative 'section'

class Job
  attr_accessor :repo

  def initialize(repo)
    @repo = repo
  end

  def load_commits
    loader = GitLoader.new(repo)
    @commit_groups = loader.grouped_commits
  end

  def analyze_sentiments
    analyzer = CommitAnalyzer.new(@commit_groups, sentitment_file)
    if has_sentiments?
      analyzer.load_from_cache
    else
      analyzer.run
    end
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
      @commit_groups.each_with_index do |commits,i|
        @groups << Section.new(@sentiments[i], commits)
      end
    end
    @groups
  end

  def write_output(path=output)
    File.open(path, 'wb') do |f|
      f.write(@song.to_bytes)
    end
  end

  def create_song(key='c')
    @song = Song.new(key)
    sections.each do |section|
      section.channel = 0
      @song.add_section(section)

      authors = section.commits.map do |commit|
        a = Author.new(commit.name, section.channel, @song.strategy, section.track)
        a.play(section.scale)
      end
    end
  end
end