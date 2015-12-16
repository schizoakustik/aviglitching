def menu
  puts "|* avi glitching"
  puts "|* menu: (f)rame repeater | (j)oin & mosh | (o)ptions | (q)uit"
  menu = gets.chomp
  if menu == "f"
    open_file("f")
  elsif menu == "j"
    open_file("j")
  elsif menu == "o"
    change_options
  elsif menu == "q"
    exit
  else
    puts "|* that's not on the menu"
    menu
  end
end
