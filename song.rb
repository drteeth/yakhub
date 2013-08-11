class Song

  attr_accessor :key
  attr_reader :background

  def initialize(key, file=MidiFile.new)
    @key = key
    @file = file
    @sections = []
    @background
    @next_track = 0
    @next_channel = 0
  end

  def add_section(section)
    @sections << section
    section.key = key
  end

  def next_track
    t = @file.addTrack
    @next_track += 1
    t
  end

  def next_channel
    c = @next_channel

    # leave the drum and backing channels open.
    while c != 10 && c != 15
      c = @next_channel
    end

    @next_channel += 1
    c % 16
  end

  def strategy
    @strategy ||= PlayRandom.new
  end

  def to_bytes
    @file.toBytes
  end

  def play_drums
    puts 'play_drums'
  end

  def play_backing_track
    puts 'play_backing_track'
  end

  def background
    # # track.setInstrument(2, 46)
    # track_one = Track.new
    # track_three = Track.new
    # track_five = Track.new
    # track_one.setInstrument(1, 95)
    # track_three.setInstrument(1, 95)
    # track_five.setInstrument(1, 95)
    # file.addTrack(track)
    # file.addTrack(track_one)
    # file.addTrack(track_three)
    # file.addTrack(track_five)
    # root = "#{scale.note_by_degree(1)}2"
    # third = "#{scale.note_by_degree(3)}3"
    # fifth = "#{scale.note_by_degree(5)}2"
    # # full_duration = commit_group.count * duration

    # track_one.addNote(1, root, full_duration)
    # track_three.addNote(1, third, full_duration)
    # track_five.addNote(1, fifth, full_duration)

    # duration = Author::Duration
  end
end
