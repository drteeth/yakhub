require_relative 'musician'

class Backing < Musician

  def channel
    15
  end

  def instrument
    Instrument::RockOrgan
  end

  def play(commit, scale)
    unless @playing
      root = "#{scale.note_by_degree(1)}3"
      third = "#{scale.note_by_degree(3)}4"
      fifth = "#{scale.note_by_degree(5)}3"

      track.addNoteOn(@channel, root)
      track.addNoteOn(@channel, third)
      track.addNoteOn(@channel, fifth)

      track.addNoteOff(@channel, root, @duration, note_length)
      track.addNoteOff(@channel, third)
      track.addNoteOff(@channel, fifth)
      @playing = true
    end
  end

  def change_section
    @playing = false
  end

  def set_duration(duration)
    @duration = duration
  end

end
