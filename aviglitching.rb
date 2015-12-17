require 'yaml'
require 'tk'
require 'aviglitch'
require_relative 'change_options'
require_relative 'menu'
require_relative 'frame_repeater'
require_relative 'join_and_mosh'

def open_file(mode)
  Dir.chdir(@config[:starting_dir])
  if mode == "f"
    path = Tk::getOpenFile
    # Check if subdirectory exists, either create it or just go there
    new_dir = File.basename(path, ".avi")
    if Dir.exist?(new_dir)
      Dir.chdir(new_dir)
    else
      Dir.mkdir(new_dir)
      Dir.chdir(new_dir)
    end
    frame_repeater(path)
  elsif mode == "j"
    path1 = Tk::getOpenFile
    filename1 = File.basename(path1, ".avi")        # Get filename from path
    path2 = Tk::getOpenFile
    filename2 = File.basename(path2, ".avi")        # Get filename from path
    new_dir = "#{File.basename(path1, ".avi")}_mosh"
    # Check if subdirectory exists, eithr create it or just go there
    if Dir.exist?(new_dir)
      Dir.chdir(new_dir)
    else
      Dir.mkdir(new_dir)
      Dir.chdir(new_dir)
    end
  end
  join_and_mosh(path1, path2, filename1, filename2)
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