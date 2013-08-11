class Drummer < Musician

  def initialize(*args)
    super
    @channel = 10
    @ticks = 0
  end

  def instrument
    # doesn't matter cuz we're using channel 10
    Instrument::AcousticGrandPiano
  end

  def play
    # kick on the 1
    # hh on the 2
    # snare on the 3
    # hh on the 4
    @ticks += 1
    if @ticks % 1
      # ...
    end
  end

end
