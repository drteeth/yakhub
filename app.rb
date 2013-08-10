
Duration = 64
NoteLength = 32
Intervals = {
  major: [0,2,4,5,7,9,11],
  minor: [0,2,3,5,7,9,11],
}

class Scale
  attr_reader :notes

  AllNotes = %w(a a# b c c# d d# e f f# g g#)

  def initialize(key, intervals)
    root = AllNotes.index(key)
    @notes = intervals.map do |i|
      nindex = (i + root) % AllNotes.count
      AllNotes[nindex]
    end
  end

  def note_by_degree(degree)
    notes[degree-1]
  end

end

class PlayDegree

  def initialize(degree)
    @degree = degree
  end

  def get_note(scale)
    scale.note_by_degree(@degree)
  end

end

class Random

  def get_note(scale)
    scale.notes.shuffle.first
  end

end

class Author
  attr_reader :name, :channel, :track, :commits

  def initialize(name, channel, strategy)
    @name = name
    @channel = channel
    @track = Track.new
    @commits = []
    @strategy = strategy
  end

  def play_segment(first, last, scale)
    @scale = scale
    commits[first,last].each do |c|
      play_commit(c)
    end
  end

  private

  def play_commit(commit)
    note = determine_note(commit)
    track.addNote(channel, note, duration, note_length)
  end

  def determine_note(commit)
    strategy.get_note(scale)
  end

  def duration
    Duration
  end

  def note_length
    NoteLength
  end
end

# each author has a track/channel
# mux authors => channel

# start with a constant duration

# sentiment =>
