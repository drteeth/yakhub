require_relative 'musician'
require_relative 'percussion'

class Drummer < Musician

  Drums = [

  ]

  def initialize(name, song)
    super
    @ticks = 0
    @octave = 2
    @pattern = 0
  end

  def channel
    9
  end

  def instrument
    # doesn't matter cuz we're using channel 10
    Instrument::AcousticGrandPiano
  end

  def play(commit, scale)
    pattern = patterns[@pattern]
    note = pattern[@ticks % 4]
    track.addNote(@channel, note, 0, note_length)
    @ticks += 1
  end

  def patterns
    @patterns ||= [
      [
        Percussion::BassDrum1,
        Percussion::ClosedHiHat,
        Percussion::SnareDrum1,
        Percussion::ClosedHiHat,
      ],
      [
        Percussion::BassDrum1,
        Percussion::RideCymbal1,
        Percussion::SnareDrum1,
        Percussion::RideCymbal1,
      ],
    ]
  end

  def change_section
    @pattern = (@pattern + 1) % patterns.count
  end

end
