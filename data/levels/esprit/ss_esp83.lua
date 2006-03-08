-- A level for Enigma
-- Copyright: 	(C) 2003 Sven Siggelkow
-- License: 	GPL v2.0 or above
-- ESPRIT #083

levelw = 20
levelh = 13
create_world(levelw, levelh)
oxyd_default_flavor = "a"
set_actor("ac-blackball", 15.5,6.5)
fill_floor("fl-black",0,0,levelw,levelh)

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c ==   "#" then
         set_stone("st-blocker", i-1,line)
      elseif c=="s" then
         set_stone("st-switch_black", i-1,line)
      elseif c=="1" then
         set_stone("st-switch_black", i-1,line,{name="s1s", target="s1", action="callback"})
      elseif c=="2" then
         set_stone("st-switch_black", i-1,line,{name="s2s", target="s2", action="callback"})
      elseif c=="3" then
         set_stone("st-switch_black", i-1,line,{target="s3", action="callback"})
      elseif c=="4" then
         set_stone("st-switch_black", i-1,line,{target="s4", action="callback"})
      elseif c=="5" then
         set_stone("st-switch_black", i-1,line,{name="s5s", target="s5", action="callback"})
      elseif c=="6" then
         set_stone("st-switch_black", i-1,line,{name="s6s", target="s6", action="callback"})
      elseif c=="7" then
         set_stone("st-switch_black", i-1,line,{target="s7", action="callback"})
      elseif c=="8" then
         set_stone("st-switch_black", i-1,line,{target="s8", action="callback"})
      elseif c=="9" then
         set_stone("st-switch_black", i-1,line,{name="s9s", target="s9", action="callback"})
      elseif c=="A" then
         set_stone("st-switch_black", i-1,line,{target="sA", action="callback"})
      elseif c=="B" then
         set_stone("st-switch_black", i-1,line,{target="sB", action="callback"})
      elseif c=="C" then
         set_stone("st-switch_black", i-1,line,{target="sC", action="callback"})
      elseif c=="D" then
         set_stone("st-switch_black", i-1,line,{target="sD", action="callback"})
      elseif c=="E" then
         set_stone("st-switch_black", i-1,line,{target="sE", action="callback"})
      elseif c==">" then
         set_stone("st-oneway_black-e", i-1,line)
      elseif c=="|" then
         set_stone("st-oneway_black-s", i-1,line)
      elseif c=="T" then
         set_stone("st-oneway_black-e", i-1,line)
         --set_item("it-trigger", i-1,line, {action="callback", target="sT"})
      elseif c=="a" then
          set_stone("st-oneway_black-s", i-1,line,{name="a"})
      elseif c=="b" then
         set_stone("st-oneway_black-e", i-1,line,{name="b"})
      elseif c=="f" then
         set_stone("st-oneway_black-e", i-1,line,{name="f"})
      elseif c=="h" then
         set_stone("st-oneway_black-e", i-1,line,{name="h"})
      elseif c=="o" then
         set_stone("st-oneway_black-s", i-1,line,{name="o"})
      elseif c=="p" then
         set_stone("st-oneway_black-s", i-1,line,{name="p"})
      elseif c=="c" then
         set_stone("st-oneway_black-e", i-1,line,{name="c"})
      elseif c=="d" then
         set_stone("st-oneway_black-e", i-1,line,{name="d"})
      elseif c=="e" then
         set_stone("st-oneway_black-e", i-1,line,{name="e"})
      elseif c=="l" then
         set_stone("st-oneway_black-s", i-1,line,{name="l"})
      elseif c=="n" then
         set_stone("st-oneway_black-s", i-1,line,{name="n"})
      elseif c =="w" then                                                               
         set_item("it-wormhole",i-1,line, {name="warp",targetx="18.5",targety="6.5",strength=0})
      elseif c=="O" then
	 oxyd(i-1,line)         
        end
    end  
end
--               01234567890123456789
renderLine(00 , "####################")
renderLine(01 , "####################")
renderLine(02 , "#    f > > c b   # O")
renderLine(03 , "#    1|s|2o3|s   # #")
renderLine(04 , "#    T > d > >   # O")  
renderLine(05 , "#    s|4|5p6|7   # #")
renderLine(06 , "#w   > e > > >   # #")
renderLine(07 , "#    8|s|9as|s   # #")
renderLine(08 , "#    h > > > >   # O")
renderLine(09 , "#    A|B|ClDnE   # #")
renderLine(10 , "#    > > > > >   # O")
renderLine(11 , "####################")
renderLine(12 , "####################") 
--               01234567890123456789

oxyd_shuffle()

-- direction   | > > > > > > | | | |
-- oneway #    a b c d e f h l n o p
local flags = {0,0,0,0,0,0,0,0,0,0,0}
-- i           1 2 3 4 5 6 7 8 9 0 1

--   switch #     1 2 5 6 9
local switches = {0,0,0,0,0}
-- i              1 2 3 4 5

function s1() -- 1->5
    %switches[1] = 1 - %switches[1]  -- store switch state, because this switch will be switched!
    if %switches[3] == 0 then 
        SendMessage("s5s", "on", 1)  -- Schalter umlegen.
    else
        SendMessage("s5s", "off", 0)
    end
    s5()
end

function s2() -- 2->a
%switches[2] = 1 - %switches[2]
%flags[1] = 1 - %flags[1]
if %flags[1] == 0 then
	set_stone("st-oneway_black-s", 10,7)
    else
	set_stone("st-oneway_black-n", 10,7)
end
end

function s3() -- 3->p
%flags[11] = 1 - %flags[11]
if %flags[11] == 0 then
	set_stone("st-oneway_black-s", 10,5)
    else
	set_stone("st-oneway_black-n", 10,5)
end
end

function s4() -- 4->h
%flags[7] = 1 - %flags[7]
if %flags[7] == 0 then
	set_stone("st-oneway_black-e", 5,8)
    else
	set_stone("st-oneway_black-w", 5,8)
end
end

function s5() -- 5->b
%switches[3] = 1 - %switches[3]
%flags[2] = 1 - %flags[2]
if %flags[2] == 0 then
	set_stone("st-oneway_black-e", 13,2)
    else
	set_stone("st-oneway_black-w", 13,2)
end
end


function s6() -- 6->c
%switches[4] = 1 - %switches[4]
%flags[3] = 1 - %flags[3]
if %flags[3] == 0 then
	set_stone("st-oneway_black-e", 11,2)
    else
	set_stone("st-oneway_black-w", 11,2)
end
end

function s7() -- 7->9
if %switches[5] == 0 then SendMessage( "s9s", "on", 1)  -- Schalter umlegen.
	else SendMessage("s9s", "off", 0)
	end
s9()	
end

function s8() -- 8->d
%flags[4] = 1 - %flags[4]
if %flags[4] == 0 then
	set_stone("st-oneway_black-e", 9,4)
    else
	set_stone("st-oneway_black-w", 9,4)
end
end

function s9() -- 9->l + 6
    %switches[5] = 1 - %switches[5]
    %flags[8] = 1 - %flags[8]
    if %flags[8] == 0 then
        set_stone("st-oneway_black-s", 10,9)
    else
	set_stone("st-oneway_black-n", 10,9)
    end
    if %switches[4] == 0 then SendMessage("s6s", "on", 1)  -- Schalter umlegen.
    else SendMessage("s6s", "off", 0)
    end
s6()	
end

function sA() -- A->h + 2
    %flags[7] = 1 - %flags[7]
    if %flags[7] == 0 then
	set_stone("st-oneway_black-e", 5,8)
    else
	set_stone("st-oneway_black-w", 5,8)
    end
    if %switches[2] == 0 then SendMessage("s2s", "on", 1)  -- Schalter umlegen.
    else SendMessage( "s2s", "off", 0)
    end
    s2()	
end

function sB() -- B->f + e + 1
    %flags[5] = 1 - %flags[5]
    %flags[6] = 1 - %flags[6]
    if %flags[6] == 0 then
	set_stone("st-oneway_black-e", 5,2)
    else
	set_stone("st-oneway_black-w", 5,2)
    end
    if %flags[5] == 0 then
	set_stone("st-oneway_black-e", 7,6)
    else
	set_stone("st-oneway_black-w", 7,6)
    end
    if %switches[1] == 0 then SendMessage( "s1s", "on", 1)  -- Schalter umlegen.
    else SendMessage( "s1s", "off", 0)
    end
    s1()
end

function sC() -- C->d
%flags[4] = 1 - %flags[4]
if %flags[4] == 0 then
	set_stone("st-oneway_black-e", 9,4)
    else
	set_stone("st-oneway_black-w", 9,4)
end
end

function sD() -- D->n
    %flags[9] = 1 - %flags[9]
    if %flags[9] == 0 then
	set_stone("st-oneway_black-s", 12,9)
    else
	set_stone("st-oneway_black-n", 12,9)
    end
end

function sE() -- E->a + b
%flags[1] = 1 - %flags[1]
%flags[2] = 1 - %flags[2]
if %flags[1] == 0 then
	set_stone("st-oneway_black-s", 10,7)
    else
	set_stone("st-oneway_black-n", 10,7)
end
if %flags[2] == 0 then
	set_stone("st-oneway_black-e", 13,2)
    else
	set_stone("st-oneway_black-w", 13,2)
end
end

--function sT()
--%flags[10] = 1 - %flags[10]
--if %flags[10] == 0 then
--	set_stone("st-oneway_black-s", 10,3)
--    else
--	set_stone("st-oneway_black-n", 10,3)
--end
--end












