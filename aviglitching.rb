require 'yaml'
require 'tk'
require 'aviglitch'
require 'streamio-ffmpeg'
files = Dir.glob("lib/*.rb") { |file| 
  require_relative file
  }

def open_file(mode)
  Dir.chdir(@config[:starting_dir])
    paths = []
    paths << Tk::getOpenFile
    # Check if subdirectory exists, either create it or just go there
    new_dir = File.basename(paths[0], ".*")
    if Dir.exist?(new_dir)
      Dir.chdir(new_dir)
    elsif new_dir == ""
      puts "not sure why u changed yr mind but ok"
      menu
    else
      Dir.mkdir(new_dir)
      Dir.chdir(new_dir)
    end
  case mode
  when "f"
    frame_repeater(paths)
  when "j"
    paths.push(Tk::getOpenFile)
    join_and_mosh(paths)
  when "t"
    transcode(paths)
  end
end

# Ask to show video
def show_file(path, mode)
  print "\n|* alright! view file? Y/n: "
  view_file = gets.chomp
  if view_file == "y" or view_file == ""
    t3 = Thread.new{
      `vlc --qt-minimal-view --quiet #{@outfile}`
    }
    t3.join
    restarting(path, mode)
  else
    restarting(path, mode)
  end
end

def restarting(path, mode)
  # Restarting options
  if mode == "f"
    print "\n|* go again with same file? Y/n: "
    go_again = gets.chomp
    if go_again == "y" or go_again == ""
      frame_repeater(path)
    else
      print "|* so another file then? Y/n: "
      open_another = gets.chomp
      if open_another == "y" or open_another == ""
        open_file(mode)
      elsif open_another == "q"
        exit      
      else
        menu
      end
    end
  elsif mode == "j"
    print "\n|* go again with other files? Y/n: "
    go_again = gets.chomp
    if go_again == "y" or go_again == ""
      open_file(mode)
    else
      menu
    end
  end
end

if File.exists?("config.yml")
  @config = YAML::load_file("config.yml")
else
  @config = { :starting_dir => "" }
end

puts "|* avi glitching"
puts "|* current working directory: "
if @config[:starting_dir] != ""
  puts "|* [#{@config[:starting_dir]}]"
else
  puts "[none. press (enter) to select one]"
  gets
  change_wd
end

menu