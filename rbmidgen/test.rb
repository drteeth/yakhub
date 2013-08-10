require_relative 'midi_file'
require_relative 'track'

file = MidiFile.new
track = Track.new
file.addTrack(track)

# channel, note, duration, time
track.addNote(0, 'c4', 64)
track.addNote(0, 'd4', 64)
track.addNote(0, 'e4', 64, 64)
track.addNote(0, 'f4', 64, 64)
track.addNote(0, 'g4', 64, 64)
track.addNote(0, 'a4', 64)
track.addNote(0, 'b4', 64)
track.addNote(0, 'c5', 64)

File.open('test2.mid', 'wb') do |f|
  f.write(file.toBytes)
end
