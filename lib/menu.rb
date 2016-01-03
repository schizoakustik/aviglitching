
# Aviglitching menu

def menu
  puts "|* this is menu"
  puts "|* menu: (f)rame repeater | (j)oin & mosh | (t)ranscode file to avi | (o)ptions | (q)uit"
  menu = gets.chomp
  case menu
  when "f"
    open_file("f")
  when "j"
    open_file("j")
  when "t"
    open_file("t")
  when "o"
    change_options
  when "q"
    exit
  else
    puts "|* that's not on the menu"
    menu
  end
end
