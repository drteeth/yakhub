require_relative 'musician'
require_relative 'instrument'

class Rythm < Musician
  def instrument
    Instrument::Marimba
  end
end
