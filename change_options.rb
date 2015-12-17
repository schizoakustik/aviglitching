def change_wd
  dir = Tk::chooseDirectory
  config = { :starting_dir => dir }
  File.open("config.yml", "w") { |f| f.puts config.to_yaml }
  @config = YAML::load_file("config.yml")
  puts "new working directory is #{dir}"
  menu
end

def change_options
  puts "|* options menu: (c)hange working directory | back to (m)enu"
  options_menu = gets.chomp
  if options_menu == "c"
    change_wd
  elsif options_menu == "m"
    menu
  else
    puts "|* i don't know what to do with that information"
    change_options
  end
end