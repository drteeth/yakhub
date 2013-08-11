class Song

  attr_accessor :key

  def initialize(key, file=MidiFile.new)
    @key = key
    @file = file
    @sections = []
  end

  def add_section(section)
    @sections << section
    section.key = key
    section.track = create_track
  end

  def create_track
    # don't actually create a track for now
    @track ||= @file.addTrack
  end

  def strategy
    @strategy ||= PlayRandom.new
  end

  def to_bytes
    @file.toBytes
  end
end
