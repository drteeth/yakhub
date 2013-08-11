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
      puts @duration
      root = "#{scale.note_by_degree(1)}2"
      third = "#{scale.note_by_degree(3)}3"
      fifth = "#{scale.note_by_degree(5)}2"

      # binding.pry
      track.addNoteOn(@channel, root, @duration, note_length)
      track.addNoteOn(@channel, third, @duration, note_length)
      track.addNoteOn(@channel, fifth, @duration, note_length)

      track.addNoteOff(@channel, root, @duration, note_length)
      track.addNoteOff(@channel, third, @duration, note_length)
      track.addNoteOff(@channel, fifth, @duration, note_length)
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
