class MidiEvent

  # event codes
  NOTE_OFF           = 0x80
  NOTE_ON            = 0x90
  AFTER_TOUCH        = 0xA0
  CONTROLLER         = 0xB0
  PROGRAM_CHANGE     = 0xC0
  CHANNEL_AFTERTOUCH = 0xD0
  PITCH_BEND         = 0xE0

  def initialize(params)
    if params && params[:type] && params[:channel] && params[:param1]
      setTime(params[:time])
      setType(params[:type])
      setChannel(params[:channel])
      setParam1(params[:param1])
      setParam2(params[:param2])
    end
  end

  def setTime(ticks)
    @time = Util.translateTickTime(ticks || 0)
  end

  def setType(type)
    if type < MidiEvent::NOTE_OFF || type > MidiEvent::PITCH_BEND
      raise "Trying to set an unknown event: #{type}"
    end

    @type = type
  end

  def setChannel(channel)
    if channel < 0 || channel > 15
      raise "Channel is out of bounds."
    end

    @channel = channel;
  end

  def setParam1(p)
    @param1 = p
  end

  def setParam2(p)
    @param2 = p
  end

  def toBytes
    byteArray = []
    typeChannelByte = @type | (@channel & 0xF)

    byteArray << @time
    byteArray << typeChannelByte
    byteArray << @param1

    # Some events don't have a second parameter
    byteArray << @param2 if @param2
    byteArray
  end
end
