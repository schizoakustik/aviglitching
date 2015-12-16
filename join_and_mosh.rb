require 'yaml'
require 'tk'
require 'aviglitch'
require_relative 'change_options'
require_relative 'menu'

@config = YAML::load_file("config.yml")

puts "|* avi_joiner && keyframe_remover"
puts "|* current working directory: "
  puts "|* [#{@config[:starting_dir]}]"

def open_files
  Dir.chdir(@config[:starting_dir])
	path1 = Tk::getOpenFile
	filename1 = File.basename(path1, ".avi")				# Get filename from path
  path2 = Tk::getOpenFile
	filename2 = File.basename(path2, ".avi")				# Get filename from path
  new_dir = "#{File.basename(path1, ".avi")}_mosh"
  # Check if subdirectory exists, eithr create it or just go there
  if Dir.exist?(new_dir)
    Dir.chdir(new_dir)
  else
    Dir.mkdir(new_dir)
    Dir.chdir(new_dir)
  end
  join(path1, path2, filename1, filename2)
end

def join(path1, path2, filename1, filename2)
	a1 = AviGlitch.open path1								# New AviGlitch instance from 1st file
	a2 = AviGlitch.open path2								# New AviGlitch instance from 2nd file
  print "|* ok, 1st file. keep all frames/just the 1st? A/1: "
  a1frames = gets.chomp
	a = []
  if a1frames == "a" or a1frames == ""
    a = a1.frames
    a1frames = "all_frames"
   elsif a1frames == "1"
    a = a1.frames[0, 1]
    a1frames = "1st_frame"
  end
  a.concat(a2.frames)
	p = AviGlitch.open a
	remove_keyframes(p, filename1, filename2, a1frames)
end

def remove_keyframes(p, filename1, filename2, a1frames)
	#a = AviGlitch.open path 								# New AviGlitch instance from path
	q = []
	q = p.frames[0, 1]										# Keep first keyframe
	# a.glitch :keyframe do |f|     						# To touch key frames, pass the symbol :keyframe.
		# nil                        						# Returning nil in glitch method's yield block
	# end                           						# offers to remove the frame.
	p.remove_all_keyframes!
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
	puts "#{@outfile} created"
	show_file
end

# Ask to show video
def show_file
  print "\n|* alright! view file? Y/n: "
  view_file = gets.chomp
  if view_file == "y" or view_file == ""
    t3 = Thread.new{
      `vlc --qt-minimal-view --quiet #{@outfile}`
    }
    t3.join
    restarting
  else
    restarting
  end
end

def restarting
	print "go again with other files? Y/n: "
	go_again = gets.chomp
	if go_again == "y" or go_again == ""
		open_files()
	else
    menu()
	end
end

menu