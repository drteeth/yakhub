require_relative 'midi_event'
require_relative 'util'

class Track
  attr_reader :events

  START_BYTES      = [0x4d, 0x54, 0x72, 0x6b]
  END_BYTES        = [0x00, 0xFF, 0x2F, 0x00]
  DEFAULT_VOLUME   = 127

  def initialize(config={})
    @events = config.fetch(:events, [])
  end

  def addEvent(event)
    events << event
  end

  def noteOn(channel, pitch, time=0, velocity=DEFAULT_VOLUME)
    events << MidiEvent.new({
      type: MidiEvent::NOTE_ON,
      channel: channel,
      param1: Util.ensureMidiPitch(pitch),
      param2: velocity,
      time: time,
    })
    self
  end

  def noteOff(channel, pitch, time=0, velocity=DEFAULT_VOLUME)
    events << MidiEvent.new({
      type: MidiEvent::NOTE_OFF,
      channel: channel,
      param1: Util.ensureMidiPitch(pitch),
      param2: velocity,
      time: time,
    })
    self
  end

  def note(channel, pitch, dur, time=0)
    puts "#{channel}, #{pitch}, #{dur}, #{time}"
    noteOn(channel, pitch, time, DEFAULT_VOLUME)
    noteOff(channel, pitch, dur, DEFAULT_VOLUME) if dur
    self
  end

  def instrument(channel, instrument, time=0)
    events << MidiEvent.new({
      type: MidiEvent::PROGRAM_CHANGE,
      channel: channel,
      param1: instrument,
      time: time,
    })
    self
  end

  def tempo(bpm, time=0)
    events << MetaEvent.new({
      type: MetaEvent::TEMPO,
      data: Util.mpqnFromBpm(bpm),
      time: time,
    })
    self
  end

  def toBytes
    trackLength = 0
    eventBytes = []
    startBytes = Track::START_BYTES
    endBytes   = Track::END_BYTES

    events.each do |event|
      bytes = event.toBytes
      trackLength += bytes.count
      eventBytes << bytes
    end
    # Add the end-of-track bytes to the sum of bytes for the track, since
    # they are counted (unlike the start-of-track ones).
    trackLength += endBytes.length
    # Makes sure that track length will fill up 4 bytes with 0s in case
    # the length is less than that (the usual case).
    lengthBytes = Util.str2Bytes(trackLength.to_s(16), 4)
    startBytes + lengthBytes + eventBytes + endBytes
  end

  alias_method :addNoteOn, :noteOn
  alias_method :addNoteOff, :noteOff
  alias_method :addNote, :note
  alias_method :setInstrument, :instrument
  alias_method :setTempo, :tempo
end
