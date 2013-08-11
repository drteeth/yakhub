class Song

  def initialize(key, file=MidiFile.new)
    @key = key
    @file = file
  end

  def add_section(sentiment)
    Section.new(sentiment).tap do |s|
      s.track = create_track
      @sections << s
    end
  end

  def create_track
    # don't actually create a track for now
    @track ||= @file.addTrack
  end

  def strategy
    @strategy ||= PlayRandom.new
  end
end
