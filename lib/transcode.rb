
# Transcode a video file to .avi using streamio-ffmpeg

def transcode(path)
  outfile = File.basename(path[0], '.*')
  m = FFMPEG::Movie.new(path[0])
  unless File.exist?(outfile + '.avi')
    m.transcode(outfile + '.avi') {|progress| puts progress}
    puts "#{outfile}.avi saved."
    menu
  else
    puts 'file already has existence.'
    menu
  end
end
