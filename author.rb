class Author
  attr_reader :name, :channel, :track, :strategy

  Duration = 64
  NoteLength = 32

  def initialize(name, channel, strategy)
    @name = name
    @channel = channel
    @track = Track.new
    @strategy = strategy
  end

  def play(scale)
    note = determine_note(scale)
    puts name, note
    track.addNote(channel, note, duration, note_length)
  end

  private

  def determine_note(scale)
    "#{strategy.get_note(scale)}2"
  end

  def duration
    Duration
  end

  def note_length
    NoteLength
  end
end
