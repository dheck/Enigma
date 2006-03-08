-- A level for Enigma
-- Copyright: 	(C) 2003 Sven Siggelkow
-- License: 	GPL v2.0 or above
-- ESPRIT #097

levelw = 21
levelh = 13
create_world(levelw, levelh)
oxyd_default_flavor = "a"
set_actor("ac-blackball", 10,6.5)
fill_floor("fl-stone",0,0,levelw,levelh)

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c ==   "#" then
         set_stone("st-door_b", i-1,line)
      elseif c =="t" then                                                               
         set_stone("st-timer", i-1,line)
      elseif c=="1" then
         set_stone("st-timer", i-1,line, {action="callback", target="s1", interval=0.5})
      elseif c=="2" then
         set_stone("st-timer", i-1,line, {action="callback", target="s2", interval=2.5})
      elseif c=="3" then
         set_stone("st-timer", i-1,line, {action="callback", target="s3", interval=3})
      elseif c=="4" then
         set_stone("st-timer", i-1,line, {action="callback", target="s4", interval=1})
      elseif c=="5" then
         set_stone("st-timer", i-1,line, {action="callback", target="s5", interval=0.8333})
      elseif c=="a" then
         set_stone("st-door_c", i-1, line, {name="a"})
      elseif c=="b" then
         set_stone("st-door_c", i-1, line, {name="b"})
      elseif c=="c" then
         set_stone("st-door_c", i-1, line, {name="c"})
      elseif c=="d" then
         set_stone("st-door_c", i-1, line, {name="d"})
      elseif c=="e" then
         set_stone("st-door_c", i-1, line, {name="e"})
      elseif c=="f" then
         set_stone("st-door_c", i-1, line, {name="f"})
      elseif c=="g" then
         set_stone("st-door_c", i-1, line, {name="g"})
      elseif c=="h" then
         set_stone("st-door_c", i-1, line, {name="h"})
      elseif c=="i" then
         set_stone("st-door_c", i-1, line, {name="i"})
      elseif c=="j" then
         set_stone("st-door_c", i-1, line, {name="j"})
      elseif c=="k" then
         set_stone("st-door_c", i-1, line, {name="k"})
      elseif c=="l" then
         set_stone("st-door_c", i-1, line, {name="l"})
      elseif c=="m" then
         set_stone("st-door_c", i-1, line, {name="m"})
      elseif c=="n" then
         set_stone("st-door_c", i-1, line, {name="n"})
      elseif c=="o" then
         set_stone("st-door_c", i-1, line, {name="o"})
      elseif c=="p" then
         set_stone("st-door_c", i-1, line, {name="p"})
      elseif c=="q" then
         set_stone("st-door_c", i-1, line, {name="q"})
      elseif c=="O" then                                                                        
	 oxyd(i-1,line)         
        end
    end  
end
--               01234567890123456789 
renderLine(00 , "12345ttttttttttttttt")
renderLine(01 , "####################")
renderLine(02 , "#O #   #    #   # O#")
renderLine(03 , "#  o   p    j   a  #")
renderLine(04 , "##e#######l###f##b##")  
renderLine(05 , "#  #   #    #   #  #")
renderLine(06 , "#O # O g    m O # O#")
renderLine(07 , "#  #   #    #   #  #")
renderLine(08 , "##q#######n###h##k##")
renderLine(09 , "#  i   d    c   #  #")
renderLine(10 , "#O #   #    #   # O#")
renderLine(11 , "####################")
renderLine(12 , "tttttttttttttttttttt") 
--               01234567890123456789 

oxyd_shuffle()

--double door  b e h
local flags = {0,0,0}
-- i           1 2 3

function s1()
    SendMessage("a", "openclose")
    SendMessage("b", "openclose")
    SendMessage("c", "openclose")
    SendMessage("d", "openclose")
end

function s2()
    SendMessage("f", "openclose")
    SendMessage("g", "openclose")
    SendMessage("h", "openclose")
    SendMessage("i", "openclose")
end

function s3()
    SendMessage("h", "openclose")
    SendMessage("j", "openclose")
    SendMessage("k", "openclose")
end

function s4()
    SendMessage("l", "openclose")
    SendMessage("m", "openclose")
    SendMessage("n", "openclose")
end

function s5()
    SendMessage("e", "openclose")
    SendMessage("o", "openclose")
    SendMessage("p", "openclose")
    SendMessage("q", "openclose")
end











