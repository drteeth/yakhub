require_relative 'musician'

class Lead < Musician
  def instrument
    puts "creating instrument for lead."
    rand(128)#Instrument::Lead1Square
  end

  def octave
    rand(2)+2
  end
end
