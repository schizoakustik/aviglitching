def menu  
  puts "|* menu: (g)litch | (o)ptions | (q)uit"
  menu = gets.chomp
  if menu == "g"
    open_file
  elsif menu == "o"
    change_options
  elsif menu == "q"
    exit
  else
    puts "|* that's not on the menu"
    menu
  end
end