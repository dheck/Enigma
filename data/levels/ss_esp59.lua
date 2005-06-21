-- A level for Enigma
-- Copyright: 	(C) 2003 Sven Siggelkow
-- License: 	GPL v2.0 or above
-- ESPRIT #059

levelw = 20
levelh = 13

create_world(levelw, levelh)
oxyd_default_flavor = "b"
set_actor("ac-blackball", 1.5,1.5)
fill_floor("fl-abyss_fake", 0,0, levelw,levelh)

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c ==   "#" then
         set_stone("st-invisible", i-1,line)
      elseif c =="b" then
         set_stone("st-actorimpulse_invisible",i-1,line)
      elseif c =="m" then
         set_stone("st-rock3_move",i-1,line)
         document(i-1,line,"Watch out!!")
      elseif c =="c" then
         set_item("it-crack0", i-1,line)
      elseif c=="O" then                                                               
	 oxyd(i-1,line) 
        end
    end  
end
--               01234567890123456789
renderLine(00 , "########b###########")
renderLine(01 , "#    #     O   c  O#")
renderLine(02 , "#  c #c            #")
renderLine(03 , "#    b  bm##b###b c#")
renderLine(04 , "#c   b    # c    c b")  
renderLine(05 , "##b  #    #        #")
renderLine(06 , "#  c #    #bbbb    #")
renderLine(07 , "b    #O            #")
renderLine(08 , "#   b#####b   b#b  #")
renderLine(09 , "#  c   c    c #    #")
renderLine(10 , "#    b    c   b c  #")
renderLine(11 , "#O   #O       #   O#")
renderLine(12 , "##########b#########") 
--               01234567890123456789

oxyd_shuffle()