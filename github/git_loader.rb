require 'git'

# Usage:
#
# loader = GitLoader.new(path)
# loader.grouped_commits
class GitLoader

  MAX_COMMITS = 10000
  COMMIT_GROUP_SIZE = 40

  Commit = Struct.new(:name,:message)

  attr_accessor :repo, :group_size

  def initialize(path,group_size = COMMIT_GROUP_SIZE)
    @repo = Git.open(path)
    @repo.checkout('master')
    @group_size = group_size
  end

  def commits
    repo.log(MAX_COMMITS)
  end

  def parsed_commits
    commits.to_a.reverse.map { |c| Commit.new(c.author.name,c.message) }
  end

  # returns an array of commits grouped by size
  def grouped_commits
    parsed_commits.each_slice(group_size).to_a
  end

end
