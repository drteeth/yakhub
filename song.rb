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
  def background
    # track.setInstrument(2, 46)
    track_one = Track.new
    track_three = Track.new
    track_five = Track.new
    track_one.setInstrument(1, 95)
    track_three.setInstrument(1, 95)
    track_five.setInstrument(1, 95)
    file.addTrack(track)
    file.addTrack(track_one)
    file.addTrack(track_three)
    file.addTrack(track_five)
    root = "#{scale.note_by_degree(1)}2"
    third = "#{scale.note_by_degree(3)}3"
    fifth = "#{scale.note_by_degree(5)}2"
    # full_duration = commit_group.count * duration

    track_one.addNote(1, root, full_duration)
    track_three.addNote(1, third, full_duration)
    track_five.addNote(1, fifth, full_duration)

# duration = Author::Duration
  end
end
