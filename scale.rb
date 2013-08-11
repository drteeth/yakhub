class Scale
  attr_reader :notes, :key

  AllNotes = %w(a a# b c c# d d# e f f# g g#)

  def initialize(key, intervals)
    root = AllNotes.index(key)
    @key = key
    @notes = intervals.map do |i|
      nindex = (i + root) % AllNotes.count
      AllNotes[nindex]
    end
  end

  def note_by_degree(degree)
    notes[degree-1]
  end

end
