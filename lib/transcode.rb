
def transcode(file)
  outfile = File.basename(file, '.*')
  m = FFMPEG::Movie.new(file)
  m.transcode(outfile + '.avi')
  puts "#{outfile}.avi saved."
  menu
end
