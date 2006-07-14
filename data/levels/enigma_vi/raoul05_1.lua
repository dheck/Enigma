-- Oxyd-Puzzle, a level for Enigma
-- Copyright (C) 2005,2006 Raoul Bourquin
-- Licensed under GPL v2.0 or above 

-- GENERAL --
Require("levels/lib/libpuzzle.lua")
levelw = 20
levelh = 13
create_world(levelw, levelh)
enigma.ConserveLevel = FALSE

-- STONES --
function renderLine( line, pattern)
	for i=1, strlen(pattern) do
		local c = strsub( pattern, i, i)
  		if c=="x" then
                   set_floor("fl-metal",i-1,line)
                   set_stone("st-glass1_hole",i-1,line)
                elseif c=="#" then
                   set_floor("fl-metal",i-1,line)
                   set_stone("st-glass2",i-1,line)
                elseif c==" " then
                   set_floor("fl-metal",i-1,line)
		end
	end	
end

renderLine(00 , "####################")
renderLine(01 , "#  x   xx   xx   x #")
renderLine(02 , "#  x   xx   xx   x #")
renderLine(03 , "#  x   xx   xx   x #")
renderLine(04 , "#  xxxxxxxxxxxxxxx #")
renderLine(05 , "#                  #")
renderLine(06 , "#                  #")
renderLine(07 , "#                  #")
renderLine(08 , "# xxxxxxxxxxxxxxx  #")
renderLine(09 , "# x   xx   xx   x  #")
renderLine(10 , "# x   xx   xx   x  #")
renderLine(11 , "# x   xx   xx   x  #")
renderLine(12 , "####################")

set_stone("st-switch_black", 5, 5, {action="callback",target="wrap1",name="sw1"})
set_stone("st-switch_black", 4, 7, {action="callback",target="wrap4",name="sw4"})

set_stone("st-switch_black", 10, 5, {action="callback",target="wrap2",name="sw2"})
set_stone("st-switch_black", 9, 7, {action="callback",target="wrap5",name="sw5"})

set_stone("st-switch_black", 15, 5, {action="callback",target="wrap3",name="sw3"})
set_stone("st-switch_black", 14, 7, {action="callback",target="wrap6",name="sw6"})

-- ACTORS --
set_actor("ac-blackball", 2.5,6.5, {player=0})

-- OXYD --
onemal=0
oxyd_default_flavor = "b"

--RANDOM TILES FOR UPPER ROW:
tiles={{{1,1,0},{0,1,0},{0,1,1}},{{0,1,1},{0,1,0},{1,1,0}},{{0,1,1},{1,1,0},{1,0,0}},{{1,1,0},{0,1,1},{0,0,1}},{{0,1,0},{1,1,1},{0,1,0}},{{1,1,1},{0,1,0},{0,1,0}},{{0,1,0},{0,1,0},{1,1,1}},{{1,1,1},{1,0,0},{1,0,0}},{{1,1,1},{0,0,1},{0,0,1}},{{0,1,0},{1,1,1},{1,0,0}},{{0,1,0},{1,1,1},{0,0,1}},{{1,1,0},{0,1,1},{0,1,0}},{{0,1,1},{1,1,0},{0,1,0}}}
chosen_tiles_up={}	
leftcorners={{4,1},{9,1},{14,1}}

--chose tiles:
ct=1
for t=1,3 do
 local r=random(1,13)
 local f=tiles[r] 
 chosen_tiles_up[ct]=f
 ct=ct+1
end

--Draw black stones:
for fields=1,3 do
 for i=1,3 do
  for j=1,3 do
   if chosen_tiles_up[fields][i][j]==0 then
    set_stone("st-glass2_hole",leftcorners[fields][1]+j-1,leftcorners[fields][2]+i-1)
   end
  end
 end
end

--RANDOM TILES FOR LOWER ROW:
tiles={{{1,1,0},{0,1,0},{0,1,1}},{{0,1,1},{0,1,0},{1,1,0}},{{1,0,0},{1,1,0},{0,1,1}},{{0,0,1},{0,1,1},{1,1,0}},{{0,1,0},{1,1,1},{0,1,0}},{{1,1,1},{0,1,0},{0,1,0}},{{0,1,0},{0,1,0},{1,1,1}},{{1,0,0},{1,0,0},{1,1,1}},{{0,0,1},{0,0,1},{1,1,1}},{{1,0,0},{1,1,1},{0,1,0}},{{0,0,1},{1,1,1},{0,1,0}},{{1,1,0},{0,1,1},{0,1,0}},{{0,1,1},{1,1,0},{0,1,0}}}
chosen_tiles_lo={}
leftcorners={{3,9},{8,9},{13,9}}

--chose tiles:
ct=1
for t=1,3 do
 local r=random(1,13)
 local f=tiles[r] 
 chosen_tiles_lo[ct]=f
 ct=ct+1
end

--Draw black stones:
for fields=1,3 do
 for i=1,3 do
  for j=1,3 do
   if chosen_tiles_lo[fields][i][j]==0 then
    set_stone("st-glass2_hole",leftcorners[fields][1]+j-1,leftcorners[fields][2]+i-1)
   end
  end
 end
end

--set the oxyds
function set_oxyd()
 if onemal==0 then
 onemal=1
  for o=0,2 do
   oxyd(5+o*5,0)
  end
  for o=0,2 do
   oxyd(4+o*5,12)
  end
  oxyd_shuffle()
 end
end

--test if all puzzles set, if yes, set the oxyds
da={0,0,0,0,0,0}

function do_test()
 ist=0
 for l=1,6 do
  ist=ist+da[l]
 end
 if ist==6 then
  da={0,0,0,0,0,0}
  set_oxyd()
 end
end

--Wrap-Funktionen
function wrap1()
 puzzle(chosen_tiles_up[1],4,1,"red")
 da[1]=1
 do_test()
end

function wrap2()
 puzzle(chosen_tiles_up[2],9,1,"red")
 da[2]=1
 do_test()
end

function wrap3()
 puzzle(chosen_tiles_up[3],14,1,"red")
 da[3]=1
 do_test()
end

function wrap4()
 puzzle(chosen_tiles_lo[1],3,9,"red")
 da[4]=1
 do_test()
end

function wrap5()
 puzzle(chosen_tiles_lo[2],8,9,"red")
 da[5]=1
 do_test()
end

function wrap6()
 puzzle(chosen_tiles_lo[3],13,9,"red")
 da[6]=1
 do_test()
end













