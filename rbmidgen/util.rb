class Util

  MIDI_LETTER_PITCHES = { a:21, b:23, c:12, d:14, e:16, f:17, g:19 }

  def self.midi_pitch_from_note(n)
    matches = /([a-g])(#+|b+)?([0-9]+)$/i.match(n)
    note = matches[1].downcase.to_sym
    accidental = matches[2] || ''
    octave = matches[3].to_i
    (12 * octave) + MIDI_LETTER_PITCHES[note] + (accidental[0]=='#'?1:-1) * accidental.length
  end

  def self.ensureMidiPitch(p)
    not_int = /[^0-9]/
    if p.is_a?(Fixnum) || !not_int =~ p
      # numeric pitch
      p.to_i
    else
      # assume it's a note name
      Util.midi_pitch_from_note(p)
    end
  end

  def self.mpqnFromBpm(bpm)
    mpqn = (60000000 / bpm.to_f).floor
    ret=[]

    begin
      ret.unshift(mpqn & 0xFF)
      mpqn >>= 8
    end while(mpqn)

    while (ret.length < 3) do
      ret << 0
    end

    ret
  end

  def self.bpmFromMpqn(mpqn)
    m = mpqn
    if mpqn[0]
      m = 0
      i = 0
      while l >= 0 do
        i += 1
        l -= 1
        m |= mpqn[i] << l
      end
    end

    (60000000 / mpqn.to_f).floor
  end

  # Converts an array of bytes to a string of hexadecimal characters. Prepares
  # it to be converted into a base64 string.
  #
  # @param byteArray {Array} array of bytes that will be converted to a string
  # @returns hexadecimal string
  def self.codes2Str(byteArray)
    byteArray.flatten.map {|b| b.chr }.join
  end

  # Converts a String of hexadecimal values to an array of bytes. It can also
  # add remaining "0" nibbles in order to have enough bytes in the array as the
  # |finalBytes| parameter.
  #
  # @param str {String} string of hexadecimal values e.g. "097B8A"
  # @param finalBytes {Integer} Optional. The desired number of bytes that the returned array should contain
  # @returns array of nibbles.
  def self.str2Bytes (str, finalBytes)
    if finalBytes
      while ((str.length / 2) < finalBytes) do
        str = "0" + str
      end
    end

    bytes = []

    i = str.length - 1
    while i >= 0 do
      chars = if i == 0 then str[i] else str[i-1] + str[i] end
      i -= 2
      bytes.unshift(chars.to_i(16))
    end

    bytes
  end

  # Translates number of ticks to MIDI timestamp format, returning an array of
  # bytes with the time values. Midi has a very particular time to express time,
  # take a good look at the spec before ever touching this function.
  #
  # @param ticks {Integer} Number of ticks to be translated
  # @returns Array of bytes that form the MIDI time value
  def self.translateTickTime(ticks)
    buffer = ticks & 0x7F

    while (ticks = ticks >> 7) > 0
      buffer <<= 8
      buffer |= ((ticks & 0x7F) | 0x80)
    end

    bList = []
    while (true) do
      bList << (buffer & 0xff)
      if (buffer & 0x80) > 0
        buffer >>= 8
      else
        break
      end
    end
    bList
  end
end
