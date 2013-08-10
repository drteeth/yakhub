require_relative 'commit_analyzer'
require_relative '../github/git_loader'
require 'pry'

loader = GitLoader.new( File.join(File.dirname(__FILE__),'../'))
commits = loader.grouped_commits

analyzer = CommitAnalyzer.new(commits)
scores =  analyzer.run

puts scores
