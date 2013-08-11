class SentimentalCommitGroup

  attr_accessor :commits, :sentiment

  def initialize(sentiment, commits)
    @sentiment = sentiment
    @commits = commits
  end

  def authors
    @commits.map do |c|
      c.name
    end
  end

end
