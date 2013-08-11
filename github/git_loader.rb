require 'git'

class GitLoader

  MAX_COMMITS = 10000
  COMMIT_GROUP_SIZE = 40

  Commit = Struct.new(:name,:message)

  attr_accessor :repo

  def initialize(path, sections=4)
    @repo = Git.open(path)
    @repo.checkout('master')
    @sections = sections
  end

  def commits
    repo.log(MAX_COMMITS)
  end

  def parsed_commits
    commits.to_a.reverse.take(200).map { |c| Commit.new(c.author.name,c.message) }
  end

  # returns an array of commits grouped by size
  def grouped_commits
    parsed_commits.each_slice(group_size).to_a
  end

  def group_size
    [(parsed_commits.count/@sections.to_f).floor,1].max
  end

end
