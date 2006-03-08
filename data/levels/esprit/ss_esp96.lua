-- A level for Enigma
-- Copyright: 	(C) 2003 Sven Siggelkow
-- License: 	GPL v2.0 or above
-- ESPRIT #096

levelw = 39
levelh = 25
create_world(levelw, levelh)
oxyd_default_flavor = "b"
set_actor("ac-blackball", 28.5,19.5)
fill_floor("fl-abyss",0,0,levelw,levelh)
fill_floor("fl-normal",0,0,20,13)

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c ==   "#" then
         set_stone("st-rock1", i-1,line)
      elseif c=="-" then
         set_floor("fl-wood", i-1,line)
      elseif c=="." then
         set_item("it-tinyhill",i-1,line)
         set_floor("fl-wood", i-1,line)      
      elseif c=="o" then
         set_item("it-tinyhollow",i-1,line)
         set_floor("fl-wood", i-1,line)       
      elseif c=="*" then
         set_item("it-hill",i-1,line)
         set_floor("fl-wood", i-1,line)      
      elseif c=="0" then
         set_item("it-hollow",i-1,line)
         set_floor("fl-wood", i-1,line)   
      elseif c=="f" then
         set_item("it-flagblack",i-1,line)   
         set_floor("fl-wood", i-1,line)          
      elseif c=="P" then
         set_item("it-coffee",i-1,line) 
         set_floor("fl-wood", i-1,line)      
      elseif c=="V" then
         set_item("it-wormhole",i-1,line,{targetx=18.5,targety=2.5,strength=0}) 
         set_floor("fl-wood", i-1,line)                           
      elseif c=="k" then
         set_stone("st-blocker",i-1,line,{name="blocker"}) 
         set_floor("fl-wood", i-1,line)             
      elseif c=="h" then
         set_stone("st-rock1_hole",i-1,line) 
         set_floor("fl-wood", i-1,line)         
      elseif c=="W" then
         set_stone("st-door_c", i-1,line,{name="doorw"}) 
         set_item("it-spade",i-1,line)
         set_floor("fl-normal", i-1,line)       
      elseif c=="X" then
         set_stone("st-door_c", i-1,line,{name="doorx"}) 
         document(i-1,line,"It's easier with a shovel!")
         set_floor("fl-normal", i-1,line)   
      elseif c=="Y" then
         set_stone("st-door_c", i-1,line,{name="doory"}) 
         set_item("it-key_a",i-1,line)
         set_floor("fl-normal", i-1,line)   
      elseif c=="Z" then
         set_stone("st-door_c", i-1,line,{name="doorz"}) 
         set_item("it-coffee",i-1,line)
         set_floor("fl-normal", i-1,line)      
      elseif c=="K" then
         set_stone("st-key_a",i-1,line, {action="openclose", target="blocker"}) 
      elseif c == "w" then
         set_stone("st-timeswitch",i-1,line, {action="callback", target="s1"})
      elseif c == "x" then
         set_stone("st-timeswitch",i-1,line, {action="callback", target="s2"})
      elseif c == "y" then
         set_stone("st-timeswitch",i-1,line, {action="callback", target="s3"})
      elseif c == "z" then
         set_stone("st-timeswitch",i-1,line, {action="callback", target="s4"})         
      elseif c == "D" then
         set_stone("st-death",i-1,line)
      elseif c == "S" then
         set_floor("fl-swamp",i-1,line)         
      elseif c == "F" then
         set_stone("st-fourswitch",i-1,line)         
      elseif c=="1" then
	 set_floor("fl-gradient",  i-1,  line, {type=3})         
      elseif c=="2" then
	 set_floor("fl-gradient",  i-1,  line, {type=4})   
      elseif c=="3" then
	 set_floor("fl-gradient",  i-1,  line, {type=1})   
      elseif c=="4" then
	 set_floor("fl-gradient",  i-1,  line, {type=2})         
      elseif c=="a" then
         set_floor("fl-gradient",  i-1,  line, {type=12})   
      elseif c=="b" then
         set_floor("fl-gradient",  i-1,  line, {type=10})         
      elseif c=="c" then
         set_floor("fl-gradient",  i-1,  line, {type=11})   
      elseif c=="d" then
         set_floor("fl-gradient",  i-1,  line, {type=9})   
      elseif c=="O" then
	 oxyd(i-1,line)         
        end
    end  
end
--               012345678901234567890123456789012345678
renderLine(00 , "#######################################")
renderLine(01 , "#                  #                  #")
renderLine(02 , "#  X  W  Y  Z   K  # F  V---o--o- --- #")
renderLine(03 , "#                  #            - - o #")
renderLine(04 , "#                  k--o-**0o-o  --o - #")  
renderLine(05 , "#                  #         0      o #")
renderLine(06 , "#                  #         oP--   - #")
renderLine(07 , "#    z             #       ---  --o-- #")
renderLine(08 , "#                  #       o          #")
renderLine(09 , "#  x   y           #       .-o        #")
renderLine(10 , "#                  #         f        #")
renderLine(11 , "#    w             #        -o        #")
renderLine(12 , "#DDDDDDDDDDDDDDDDDD#########h##########") 
                                                        
renderLine(13 , "Da4444444444444444b#0       -         #")
renderLine(14 , "D2O44444444444444O1#0       - ----    #")
renderLine(15 , "D22a444444444444b11#0       - .  -    #")
renderLine(16 , "D222a4444444444b111h0   ----- -  -    #")
renderLine(17 , "D2222a44444444b1111#0   .     .  -    #")  
renderLine(18 , "D22222SSSSSSSS11111#0   -     -  -    #")
renderLine(19 , "D2222c33333333d1111#0   ------.  -    #")
renderLine(20 , "D222c3333333333d111#0            .-.- #")
renderLine(21 , "D22c333333333333d11#0               - #")
renderLine(22 , "D2O33333333333333O1#00000000--.--o--- #")
renderLine(23 , "Dc3333333333333333d#0                 #")
renderLine(24 , "#DDDDDDDDDDDDDDDDDD####################")
--               012345678901234567890123456789012345678
                               
function s1() sx(1) end                               
function s2() sx(2) end 
function s3() sx(3) end 
function s4() sx(4) end                               

local flag = {0,0,0,0,}
x = 0

function sx(num)
    %flag[num] = 1-%flag[num]
    if (%flag[1]+%flag[2]+%flag[3]+%flag[4]==4) then
        -- open, if all timeswitches are on   
        x = x+1
        if x == 5 then x = 1 end
        SendMessage("doorw", "close") 
        SendMessage("doorx", "close")
        SendMessage("doory", "close")
        SendMessage("doorz", "close")
        if x == 1 then
            SendMessage("doorw", "open") 
        elseif x == 2 then
            SendMessage("doorx", "open")
        elseif x == 3 then
            SendMessage("doory", "open")
        elseif x == 4 then
            SendMessage("doorz", "open")
        end          
    end
end
                               
oxyd_shuffle()










