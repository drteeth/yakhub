class Author
  attr_reader :name, :channel, :track, :strategy

  Duration = 44
  NoteLength = 0

  def initialize(name, channel, strategy, track=Track.new)
    @name = name
    @channel = channel
    @track = track
    @strategy = strategy
  end

  def play(scale)
    note = determine_note(scale)
    track.addNote(channel, note, duration, note_length)
  end

  private

  def determine_note(scale)
    "#{strategy.get_note(scale)}5"
  end

  def duration
    Duration
  end

  def note_length
    NoteLength
  end
end
