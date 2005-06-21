-- A level for Enigma
-- Name:	What's the Problem?
-- Copyright: 	(C) 2003 Sven Siggelkow
-- License: 	GPL v2.0 or above

levelw = 20
levelh = 13
create_world(levelw, levelh)

if (difficult) then -- hard
  fill_floor("fl-dunes")
else                            -- easy
  fill_floor("fl-concrete")
end

local laser=laser(12,3, FALSE, SOUTH)
function renderLine( line, pattern)
    for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c ==   "#" then
         set_stone("st-greenbrown",i-1,line)
      elseif c=="t" then               
         set_stone("st-door-v",i-1,line, {name="door1"})
      elseif c=="b" then               
         set_stone("st-door-h",i-1,line, {name="door2"})
      elseif c=="a" then                
         set_floor("fl-water",i-2,line)
         set_floor("fl-water",i-1,line)
         set_floor("fl-water",i-1,line+1)
      elseif c=="." then                
         set_item("it-extralife",i-1,line)
      elseif c=="-" then                
         set_item("it-hstrip",i-1,line)
      elseif c=="|" then                
         set_item("it-vstrip",i-1,line)
      elseif c=="i" then                
         set_floor("fl-ice_001",i-1,line)
      elseif c=="F" then                
         set_stone("st-fakeoxyd",i-1,line)
      elseif c=="I" then                
         set_stone("st-actorimpulse_invisible",i-1,line)
         set_floor("fl-ice_001",i-1,line)
      elseif c=="c" then                
         set_stone("st-actorimpulse_invisible",i-1,line)
         --set_floor("fl-ice_001",i-1,line)
      elseif c=="h" then                
         hollow(i-1,line)
         set_floor("fl-ice_001",i-1,line)
      elseif c=="k" then
	   set_stone("st-knight",i-1,line)
      elseif c=="<" then
	   set_stone("st-oneway-w",i-1,line)
      elseif c=="v" then
	   set_stone("st-oneway-s",i-1,line)
      elseif c=="g" then
	   set_stone("st-grate1",i-1,line)
      elseif c=="w" then
	   set_stone("st-swap",i-1,line)
      elseif c=="W" then
	   set_stone("st-brownie",i-1,line)
      elseif c=="D" then                
         document(i-1,line,"Alfred Nobel says: This is definitely a meditation landscape!")
      elseif c=="d" then
         dynamite(i-1,line)
      elseif c=="1" then
	 set_stone("st-switch",i-1,line, {action="openclose", target="door1"})
      elseif c=="2" then
	 set_stone("st-switch",i-1,line, {action="openclose", target="door2"})
      elseif c=="3" then
	 set_stone("st-switch",i-1,line, {action="callback", target="s1"})
      elseif c=="x" then
         set_actor("ac-whiteball-small", i,line+1, {player=0})
      elseif c=="O" then                                                                        
	 oxyd(i-1,line)      
        end
    end
end
--              01234567890123456789
renderLine(00, "##################I#")
renderLine(01, "F c2dD <#iiiiiiiiii3")
renderLine(02, "# c#b#vv#g########i#")
renderLine(03, "#         W      #i#")
renderLine(04, "#                #h#")  
renderLine(05, "#                #i#")
renderLine(06, "###   x   w  x   #i#")
renderLine(07, "#.t              #i#")
renderLine(08, "###      kk      #i#")
renderLine(09, "#       OFk      #i#")
renderLine(10, "#|a      kk    ##IiI")
renderLine(11, "#1-            #FiiI")
renderLine(12, "##################II")
--              01234567890123456789

function s1()
 SendMessage(%laser, "onoff")
end
