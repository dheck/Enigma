-- A level for Enigma
-- Copyright: 	(C) 2003 Sven Siggelkow
-- License: 	GPL v2.0 or above
-- ESPRIT #049

levelw = 182
levelh = 13
create_world(levelw, levelh)
oxyd_default_flavor = "a"
display.SetFollowMode(display.FOLLOW_SCROLLING)
set_actor("ac-blackball", 178.5,6.5)
fill_floor("fl-bluegray",0,0,levelw,levelh)



function renderLine( line, pattern)
    for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c ==   "#" then
         set_stone("st-rock3", i-1,line)
      elseif c =="-" then
         set_stone("st-rock3_break",i-1,line)
      elseif c=="M" then
	 set_stone("st-rock3_move",i-1,line)
      elseif c=="H" then
	 set_stone("st-rock3_hole",i-1,line)
      elseif c=="h" then
	 set_stone("st-rock3_hole",i-1,line)
	 set_item("it-crack0",i-1,line)
      elseif c=="c" then
	 set_item("it-crack1",i-1,line)
      elseif c=="e" then
	 set_item("it-crack0",i-1,line)
      elseif c=="d" then
	 set_item("it-crack3",i-1,line)
      elseif c=="0" then
	 set_stone("st-door_c", i-1,line,{name="door0"})
      elseif c=="9" then
	 set_stone("st-door_c", i-1,line)
      elseif c == "K" then
         set_stone("st-coinslot", i-1,line, {action="openclose", target="door0"})
      elseif c =="g" then
         set_stone("st-grate2",i-1,line)
      elseif c =="!" then
         set_stone("st-grate2",i-1,line)
	 set_item("it-hammer", i-1,line)
      elseif c=="a" then
         set_stone("st-rock3_hole",i-1,line)	
      	 set_item("it-coin1", i-1,line)
      elseif c=="b" then	
	 set_stone("st-rock3_hole",i-1,line)
	 set_item("it-coin4", i-1,line)
      elseif c =="i" then
         set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="s1"})
      elseif c =="j" then
         set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="s2"})
      elseif c =="k" then
         set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="s3"})
      elseif c =="l" then
         set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="s4"})
      elseif c =="m" then
         set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="s5"})
      elseif c =="n" then
         set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="s6"})
      elseif c=="." then
         set_item("it-hill",i-1,line)
      elseif c=="o" then
         set_item("it-hollow",i-1,line)
      elseif c=="w" then
	 set_stone("st-glass1",i-1,line)
      elseif c =="Z" then
         set_item("it-wormhole",i-1,line, {targetx="175.5",targety="6.5",strength=0})
         set_stone("st-glass", i-1,line)
      elseif c =="Y" then
         set_stone("st-glass", i-1,line)
         set_item("it-wormhole",i-1,line, {targetx="6.5",targety="6.5",strength=0})
      elseif c =="X" then
         set_item("it-wormhole",i-1,line, {targetx="23.5",targety="11.5",strength=0})
      elseif c =="W" then
         set_item("it-wormhole",i-1,line, {targetx="13.5",targety="5.5",strength=0})         
      elseif c=="S" then
         set_stone("st-switch", i-1,line,{target="s0", action="callback"})
      elseif c=="1" then
	 set_stone("st-door_c", i-1,line,{name="door1"})
      elseif c=="2" then
	 set_stone("st-door_c", i-1,line,{name="door2"})        
      elseif c=="3" then
	 set_stone("st-door_c", i-1,line,{name="door3"})
      elseif c=="4" then
	 set_stone("st-door_c", i-1,line,{name="door4"})        
      elseif c=="5" then
	 set_stone("st-door_c", i-1,line,{name="door5"})
      elseif c=="6" then
	 set_stone("st-door_c", i-1,line,{name="door6"})        
      elseif c=="f" then
         set_stone("st-fourswitch", i-1,line,{target="s7", action="callback"})
      elseif c=="O" then
	 oxyd(i-1,line)         
        end
    end  
end
--               01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
renderLine(00 , "##################################f#############f##############f#########f################f###########################################################################################")
renderLine(01 , "#       w               ww 1  .o  o...   o   .   .   oo.    o.  o  ..  .  .  ooo    .   o  .        oi  #-----#---------#################H MHHHHHHHHHHb9ggg9       #   # c M e       #")
renderLine(02 , "#       w wwwwwwwwwwwww ww ###f######f##########f#################f#######f###############f###########  #-##-##-#########-----##--------#H HHHHHHHHHHHH9g!g9    e dMe  # e #e        #")
renderLine(03 , "# O     w w           w ww 2 o..o    o.o.      ..o.       ..      ..o     o.       .    .  o      .  j  #-#---------#####-#-#-##-######-#H HHHHHHHHHHHH9ggg0 d     # c #   #       O #")
renderLine(04 , "#       w w wwwwwwwww w ww ########f######f###f###########f#####f#f######f########f####f##############  #-#-#-#####-#####-#-#-##--#####-#H HHHHHHHHHHHH99K99     c #   H   # e       #")
renderLine(05 , "# O     w w w       w w ww 3               ..o.          .....................oooooooooooo           k  ###-#-----#-------#-#-###-#-----#H HHHHHHHHHHHH            H c He  #       O #")  
renderLine(06 , "S    Z  w w wwwwwww w wXwW ####f#f##########f########f#########f##############f#############f#########  --#-###############-#-###-#####-#H HHHHHHHHHHHH          c #c  # c M    Y    #")
renderLine(07 , "# O     w w         w wwww 4      ..   oo            o.o                  o   ..       oo    .       l  #-#-##-----########-#-###-#-----#H HHHHHHHHHHaH           e#   #  e#e      O #")
renderLine(08 , "#       w wwwwwwwwwww wwww ###########f##########f################f#########f########f################  #-#-##-###-#########--###-#-#####H HHHHHHHHHHHH        d   #  c#   H e       #")
renderLine(09 , "# O     w               ww 5           .       ...    .oo.        .   o   o o                        m  #-#----###-------###-####-#----##H HHHHHHHHHHHH           c# e H ceh       O #")
renderLine(10 , "#       wwwwwwwwwwwwwwwwww ####f########f##############f#########f####f#######f#########f#############  #-#############--#---------#-#---H HHHHHHHHHHHH            He dM   #         #")
renderLine(11 , "#                       ww 6               .o.         ooo   ...      o.       o.         ...        n  #---------------###########--####H aHHHHHHHHHHH            #   #  c#e        #")
renderLine(12 , "##################################f#########f#######f########f###############f######f#################################################################################################") 
--               01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901

door = 0

function s0() -- "opens" the wormholes
enigma.KillStone(5, 6)
enigma.KillStone(176, 6)
end

function s1() sx(1) end
function s2() sx(2) end
function s3() sx(3) end
function s4() sx(4) end
function s5() sx(5) end
function s6() sx(6) end

function sx(x) -- opens all doors, var door stores next door approaching
    door=x
    for i=1,6 do
        SendMessage("door"..i, "open")
    end
end
 
function s7() -- if any fourswitch is touched only the next door approaching will be closed
    SendMessage("door"..door, "close")
end










