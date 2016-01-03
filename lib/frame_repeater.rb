
# Repeat a number of frames in a video.

def frame_repeater(path)
	print "|* last buffer frame: "
	l = gets.to_i
	print "|* frame to repeat: "
	f = gets.to_i
	print "|* trailing frames: "
	t = gets.to_i
	print "|* x * "
	r = gets.to_i
	# New AviGlitch instance with frames from path
	a = AviGlitch.open path[0]
	#Glitching thread
	t1 = Thread.new{
		filename = File.basename(path[0], ".avi")
		# Get last frame of a
		last_frame = a.frames.size
		# Save non-iframes to d
		d = []
		a.frames.each_with_index do |f, i|
			d.push(i) if f.is_deltaframe?
		end
		# Keep first keyframe, start effect at last_buffer_frame
		q = a.frames[0, l]
		# Add frame_to_repeat and any trailing_frames to x
		x = a.frames[d[f], t];
		# Repeat frame_to_repeat + any trailing_frames * times and add to the buffer
		# Stop if the number of repetitions exceed total frame count
		q.concat(x * r)
   	# Add the rest of a to y and stick it to the end of q
		# if last_frame - l > r
		y = a.frames[d[l + 1], last_frame]
		q.concat(y)
		# New AviGlitch instance using the frames
		o = AviGlitch.open q
		@outfile = "#{filename}_0-#{l}_#{f}-#{t}_#{r}.avi"
		o.output @outfile
	}
	#Progress thread
	t2 = Thread.new{
		progress = '|* plz wait, repeating frames'
		while t1.status
			progress << "."
	    # move the cursor to the beginning of the line with \r
	    print "\r"
	    # puts add \n to the end of string, use print instead
	    print progress #+ " #{r / 100} %"
	    # force the output to appear immediately when using print
	    # by default when \n is printed to the standard output, the buffer is flushed.
	    $stdout.flush
	    sleep 1.2
	  end
	  show_file(path, "f")
	  #restarting(path)
	}	
	t1.join
	t2.join
end