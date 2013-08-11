require_relative 'backing'
require_relative 'drummer'

class Song

  attr_accessor :key
  attr_reader :background, :backing, :drummer

  def initialize(key, file=MidiFile.new)
    @key = key
    @file = file
    @sections = []
    background
    @next_channel = 0
    @track = @file.addTrack
    @backing = Backing.new('backing', self, @file.addTrack)
    @drummer = Drummer.new('drummer', self, @file.addTrack)
  end

  def add_section(section)
    @sections << section
    section.key = key
  end

  def next_track
    @track
  end

  def next_channel
    c = @next_channel
    available = [0,1,2,3,4,5,6,7,8,10,11,12,13,14]
    # leave the drum and backing channels open.
    current = available[c % available.count]
    @next_channel += 1
    current
  end

  def strategy
    @strategy ||= PlayRandom.new
  end

  def to_bytes
    @file.toBytes
  end

  def play_drums
    @drummer.play(nil, current_section.scale)
  end

  def play_backing_track
    @backing.set_duration(current_section.commits.count*Musician::Duration)
    @backing.play(nil, current_section.scale)
  end

  def current_section
    @sections.last
  end

end
