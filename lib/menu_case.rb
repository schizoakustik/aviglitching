
def menu
  puts "|* avi glitching"
  puts "|* menu: (f)rame repeater | (j)oin & mosh | (o)ptions | (q)uit"
  menu = gets.chomp
  case menu
  when "f"
    open_file("f")
  when "j"
    open_file("j")
  when "o"
    change_options
  when "q"
    exit
  else
    puts "|* that's not on the menu"
    menu
  end
end

menu