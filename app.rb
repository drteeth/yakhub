require 'pry'

require_relative 'semantria/commit_analyzer'
require_relative 'github/git_loader'
require_relative 'rbmidgen/rbmidgen'

require_relative 'scale'
require_relative 'play_degree'
require_relative 'play_random'
require_relative 'author'

repo = ARGV[0] || './'

job = Job.new(repo)
job.load_commits
job.analyze_sentiments
job.create_song
job.write_output
