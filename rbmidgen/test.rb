require_relative 'midi_file'
require_relative 'track'

file = MidiFile.new
track = Track.new
track2 = Track.new
file.addTrack(track)
file.addTrack(track2)

# channel, note, duration, time
track2.addNote(4, 'g4', 64)
track2.addNote(4, 'a4', 64)
track2.addNote(4, 'b4', 64)
track2.addNote(4, 'c5', 64)
track.addNote(0, 'c4', 64)
track.addNote(0, 'd4', 64)
track.addNote(0, 'e4', 64)
track.addNote(0, 'f4', 64)

File.open('test2.mid', 'wb') do |f|
  f.write(file.toBytes)
end
