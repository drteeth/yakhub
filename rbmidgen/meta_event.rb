class MetaEvent

  SEQUENCE       = 0x00
  TEXT           = 0x01
  COPYRIGHT      = 0x02
  TRACK_NAME     = 0x03
  INSTRUMENT     = 0x04
  LYRIC          = 0x05
  MARKER         = 0x06
  CUE_POINT      = 0x07
  CHANNEL_PREFIX = 0x20
  END_OF_TRACK   = 0x2f
  TEMPO          = 0x51
  SMPTE          = 0x54
  TIME_SIG       = 0x58
  KEY_SIG        = 0x59
  SEQ_EVENT      = 0x7f

  def initialize(params={})
    setTime(params.fetch(:time))
    setType(params.fetch(:type))
    setData(params.fetch(:data))
  end

  def setTime(ticks)
    @time = Util.translateTickTime(ticks || 0)
  end

  def setType(t)
    @type = t
  end

  def setData(d)
    @data = d
  end

  def toBytes
    if !@type || !@data || !@time
      raise "Type or data for meta-event not specified."
    end

    byteArray = []
    byteArray << @time

    # TODO check
    byteArray << OxFF
    byteArray << type

    # If data is an array, we assume that it contains several bytes. We
    # apend them to byteArray.
    if @data.is_a?(Array)
      byteArray << @data.length
      byteArray << @data
    elsif @data != nil
      byteArray << 1
      byteArray << @data
    end

    byteArray.flatten
  end
end
