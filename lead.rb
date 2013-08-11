require_relative 'musician'

class Lead < Musician
  def instrument
    Instrument::Lead1Square
  end

  def octave
    3
  end
end
