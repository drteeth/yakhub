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
    @commits ||= parse_commits.map {|c| Commit.new(c.author.name,c.message)}
  end

  def parse_commits
    repo.log(MAX_COMMITS).to_a.reverse
  end

end
