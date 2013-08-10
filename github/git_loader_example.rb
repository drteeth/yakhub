require_relative 'git_loader'

loader = GitLoader.new( File.join(File.dirname(__FILE__),'../'))
puts loader.grouped_commits
