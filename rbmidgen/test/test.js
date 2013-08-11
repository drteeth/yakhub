var fs = require('fs');
var Midi = require('jsmidgen');

var file = new Midi.File();
var track = file.addTrack(track);

track.addNote(0, 'c4', 128);

fs.writeFileSync('node.mid', file.toBytes(), 'binary');
