# encoding: US-ASCII
class MidiFile

  HDR_CHUNKID     = "MThd"             # File magic cookie
  HDR_CHUNK_SIZE  = "\x00\x00\x00\x06" # Header length for SMF
  HDR_TYPE0       = "\x00\x00"         # Midi Type 0 id
  HDR_TYPE1       = "\x00\x01"         # Midi Type 1 id
  HDR_SPEED       = "\x00\x80"         # Defaults to 128 ticks per beat

  attr_reader :tracks

  def initialize(config={})
    @tracks = config.fetch(:tracks,[])
  end

  def addTrack(track)
    if track
      tracks << track
      self
    else
      track = Track.new
      tracks << track
      track
    end
  end

  def toBytes
    track_count = tracks.count.to_s(16)
    # prepare the file header
    bytes = MidiFile::HDR_CHUNKID + MidiFile::HDR_CHUNK_SIZE + MidiFile::HDR_TYPE0
    puts bytes.encoding

    # add the number of tracks (2 bytes)
    bytes += Util.codes2Str(Util.str2Bytes(track_count, 2))
    # add the number of ticks per beat (currently hardcoded)
    bytes += MidiFile::HDR_SPEED
    # iterate over the tracks, converting to bytes too
    tracks.each do |track|
      bs = track.toBytes
      bytes += Util.codes2Str(bs)
    end

    bytes
  end
end
