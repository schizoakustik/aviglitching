def get_variables(path)
	print "|* last buffer frame: "
	last_buffer_frame = gets.to_i
	print "|* frame to repeat: "
	frame_to_repeat = gets.to_i
	print "|* trailing frames: "
	trailing_frames = gets.to_i
	print "|* x * "
	repetitions = gets.to_i
	# New AviGlitch instance with frames from path
	a = AviGlitch.open path
	repeat_frames(a, last_buffer_frame, frame_to_repeat, trailing_frames, repetitions, path)
end

def repeat_frames(a, l, f, t, r, path)
	#Glitching thread
	t1 = Thread.new{
		filename = File.basename(path, ".avi")
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
	  show_file(path)
	  #restarting(path)
	}	
	t1.join
	t2.join
end

# Ask to show video
def show_file(path)
	print "\n|* alright! view file? Y/n: "
	view_file = gets.chomp
	if view_file == "y" or view_file == ""
		t3 = Thread.new{
			`vlc --qt-minimal-view --quiet #{@outfile}`
		}
		t3.join
		restarting(path)
	else
		restarting(path)
	end
end

def restarting(path)
	# Restarting options
	print "\n|* go again with same file? Y/n: "
	go_again = gets.chomp
	if go_again == "y" or go_again == ""
		get_variables(path)
	else
		print "|* so another file then? Y/n: "
		open_another = gets.chomp
		if open_another == "y" or open_another == ""
			open_file
		elsif open_another == "q"
			exit			
		else
			menu
		end
	end
end