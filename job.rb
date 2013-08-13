require_relative 'song'
require_relative 'section'
require_relative 'Lead'
require_relative 'Rythm'

class Job
  attr_accessor :repo

  def initialize(repo)
    @repo = repo
    @musicians_roles = {}
    @roles = [Lead, Rythm]
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
    # TODO: create cache dir if it doesn't exist
    @sentitment_file ||= "./cache/#{sanitized_repo}.json"
  end

  def sanitized_repo
    repo.gsub(/\W/,'')
  end

  def output
    # TODO: create midifiles dir if it doesn't exist
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

      # turn authors into musician
      section.commits.each do |commit|
        musician = assign_musician(commit.name, @song)

        # make sure they are playing in the correct scale
        @song.play_drums
        @song.play_backing_track
        musician.play(commit, section.scale)
      end

      @musicians_roles.values.each do |m|
        m.change_section
      end
      @song.backing.change_section
      @song.drummer.change_section
    end
    puts @musicians_roles.keys.uniq
  end

  # assign an author a musician's role.
  def assign_musician(name, song)
    unless @musicians_roles.has_key?(name)
      musician = pick_role.new(name, song)
      musician.track = song.next_track
      @musicians_roles[name] = musician
    end
    @musicians_roles[name]
  end

  # return the class of one of the roles at random
  def pick_role
    @roles.shuffle.first
  end

end
