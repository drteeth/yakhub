class Section

  attr_accessor :key, :track, :channel, :commits

  ScaleIntervals = {
    major: [0,2,4,5,7,9,11],
    minor: [0,2,3,5,7,9,11],
  }

  def initialize(sentiment, commits)
    @sentiment = sentiment
    @commits = commits
  end

  def scale
    unless @scale
      intervals = if @sentiment > 0
        ScaleIntervals.values.first
      else
        ScaleIntervals.values.last
      end
      @scale = Scale.new(@key, intervals)
    end
    @scale
  end

end
