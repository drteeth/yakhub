class Musician
  attr_accessor :track
  attr_reader :scale, :key, :channel, :octave, :song

  Duration = 44
  NoteLength = 0

  def initialize(name, song)
    @name = name
    @channel = song.next_channel
    @track = song.next_track
    @track.instrument(@channel, instrument)
    @octave = 2
  end

  def play(commit, scale)
    note = determine_note(scale)
    track.addNote(@channel, note, duration, note_length)
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
