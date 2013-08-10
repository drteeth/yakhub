require 'httparty'

# require protaudio19
require 'popen4'


MOODS = %w{ energetic organic sweet inspirational sentimental moody quirky heavy campy edgy }


def get_track(mood)
  h = HTTParty.get("http://girthmusic.com/api/tracks.json?page=1&emotions%5B%5D=#{mood}")

  tracks = h["tracks"]
  uri = tracks[rand(tracks.length)]["public_path_to_file"]
end

def play_song(uri,duration=10)
  mplayer = "/usr/bin/mplayer \"#{uri}\""
  @pid, @stdin, @stdout, @stderr = Open4.popen4(mplayer)
  sleep duration
end

def stop_song
  @stdin.puts "quit" if @pid
end

mood = MOODS[2]
uri = get_track(mood)
play_song(uri)
stop_song

mood = MOODS[0]
uri = get_track(mood)
play_song(uri)
stop_song

mood = MOODS[9]
uri = get_track(mood)
play_song(uri)
stop_song
