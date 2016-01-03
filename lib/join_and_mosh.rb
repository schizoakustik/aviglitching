def join_and_mosh(path1, path2, filename1, filename2)
 	a1 = AviGlitch.open path1								# New AviGlitch instance from 1st file
	a2 = AviGlitch.open path2								# New AviGlitch instance from 2nd file
  print "|* ok, 1st file. keep (a)ll frames/just the (1)st? "
  a1frames = gets.chomp
	a = []
  if a1frames == "a" or a1frames == ""
    a = a1.frames
    a1frames = "all_frames"
   elsif a1frames == "1"
    a = a1.frames[0, 1]
    a1frames = "1st_frame"
  end
   #Glitching thread
  t1 = Thread.new{
    a.concat(a2.frames)
  	p = AviGlitch.open a
  	q = []
    # Keep first keyframe
  	q = p.frames[0, 1]
    # To hell with the rest
  	p.remove_all_keyframes!
    # Tack the rest of the (all now non-key)frames to the end of q
  	q.concat(p.frames)
  	o = AviGlitch.open q
  	# Check to see if file exists, increment filename
  	out_path = "#{filename1}_[#{a1frames}]_#{filename2}_mosh_"
  	files = Dir.glob("#{out_path}*.avi")
  	if files.any?
      	@outfile = files.last
      else
      	@outfile = "#{out_path}01.avi"
    end
    if File.exists?(@outfile)
     	b = File.basename(@outfile, ".avi")
  	  b = b.next!
  	  @outfile = "#{b}.avi"
  	end
  	o.output @outfile
  }
  #Progress thread
  t2 = Thread.new{
    progress = '|* plz wait, joining & moshing'
    while t1.status
      progress << "."
      print "\r"
      print progress
      $stdout.flush
      sleep 1.2
    end
    show_file(path1, "j")
  } 
  t1.join
  t2.join
end