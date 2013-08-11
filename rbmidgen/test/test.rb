require_relative '../midi_file'
require_relative '../track'

file = MidiFile.new
track = file.addTrack(track)

track.addNote(0, 'c4', 128)

File.open('ruby.mid', 'wb') do |f|
  f.write(file.toBytes)
end
