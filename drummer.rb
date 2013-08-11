require_relative 'musician'
require_relative 'percussion'

class Drummer < Musician

  Drums = [
    Percussion::BassDrum1,
    Percussion::ClosedHiHat,
    Percussion::SnareDrum1,
    Percussion::ClosedHiHat,
  ]

  def initialize(name, song)
    super
    @ticks = 0
    @octave = 2
  end

  def channel
    9
  end

  def instrument
    # doesn't matter cuz we're using channel 10
    Instrument::AcousticGrandPiano
  end

  def play(commit, scale)
    note = Drums[@ticks % 4]
    track.addNote(@channel, note, 0, note_length)
    @ticks += 1
  end

end
