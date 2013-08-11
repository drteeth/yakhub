class Section

  ScaleIntervals = {
    major: [0,2,4,5,7,9,11],
    minor: [0,2,3,5,7,9,11],
  }

  def initialize(sentiment, track, commits)
    @scale = create_scale(sentiment)
  end

  def create_scale(sentiment)
    intervals = if sentiment > 0
      ScaleIntervals.first
    else
      ScaleIntervals.last
    end
    Scale.new(@key, intervals)
  end

end
