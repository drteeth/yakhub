class Musician
  attr_accessor :track
  attr_reader :key, :channel, :octave, :song

  Duration = 64
  NoteLength = 64

  def initialize(name, song, track=nil)
    @song = song
    @name = name
    @channel = channel
    @track = track || song.next_track
    @track.instrument(@channel, instrument)
    @octave = 2
  end

  def play(commit, scale)
    note = determine_note(scale)
    track.addNote(@channel, note, duration, note_length)
  end

  def channel
    song.next_channel
  end
  def duration
    Duration
  end

  def note_length
    NoteLength
  end

  def change_section
  end

  def change_scale(scale)
    @scale = scale
  end

  def change_key(key)
    @key = key
  end

  def instrument
    raise "implement me"
  end

  def strategy
    @strategy ||= PlayRandom.new
  end

  def determine_note(scale)
    "#{strategy.get_note(scale)}#{octave}"
  end

end
