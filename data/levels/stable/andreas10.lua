-- Moure-Switches, a level for Enigma
-- Copyright (C) 2005 Andreas Lochmann
-- Licensed under GPL v2.0 or above 
-- Created with the help of BBE 1.05

Require("levels/lib/ant.lua")
function file_oxyd(x,y,f)
    oxyd_default_flavor=f
    oxyd(x,y)
end
levelh=13
levelw=20
enigma.FlatForce=30
enigma.SlopeForce=30
enigma.ElectricForce=30
cells={}
items={}
actors={}
stones={}
actors[" "]=cell{}
stones[" "]=cell{}
cells[" "]=cell{}
items[" "]=cell{}
stones["!"]=cell{stone="st-rock4"}
stones["$"]=cell{parent={{file_oxyd,"d"}}}
cells["!"]=cell{floor="fl-space"}
cells["$"]=cell{floor="fl-himalaya"}
  -- the following four floor-types will be permuted!
cells["%"]=cell{floor="fl-sahara"}
cells["&"]=cell{floor="fl-red"}
cells["'"]=cell{floor="fl-bluegray"}
cells["("]=cell{floor="fl-tigris"}
  --
function ac_blackball(x,y)
n=""
p=0
f=0
 if (x==10) and (y==7) then
  n="ac10x7"
  p=0
  mf=1,66666666666667
 end
set_actor("ac-blackball",x+0.5,y+0.5,{player=p,name=n,mouseforce=mf})
end
actors["!"]=cell{parent={{ac_blackball}}}
level={"!!!!!!!!!!!!!!!!!!!!",
       "!!!!!!!!!!!!!!!!!!!!",
       "!!!!!!!!!!!!!!!!!!!!",
       "$$$$$$$$$$$$$$$$$$$$",
       "$$$$$$$$$$$$$$$$$$$$",
       "$$$$$$$$$$$$$$$$$$$$",
       "$$$$$$$$$$$$$$$$$$$$",
       "$$$$$$$$$$$$$$$$$$$$",
       "$$$$$$$$$$$$$$$$$$$$",
       "$$$$$$$$$$$$$$$$$$$$",
       "!!!!!!!!!!!!!!!!!!!!",
       "!!!!!!!!!!!!!!!!!!!!",
       "!!!!!!!!!!!!!!!!!!!!"}
   acmap={"                    ",
          "                    ",
          "                    ",
          "                    ",
          "                    ",
          "                    ",
          "          !         ",
          "                    ",
          "                    ",
          "                    ",
          "                    ",
          "                    ",
          "                    "}
  itmap={"                    ",
         "                    ",
         "                    ",
         "                    ",
         "                    ",
         "                    ",
         "                    ",
         "                    ",
         "                    ",
         "                    ",
         "                    ",
         "                    ",
         "                    "}
 stmap={"                    ",
        "                    ",
        "                    ",
        "!!$!!$!!$!!$!!$!!$!!",
        "!                  !",
        "!                  !",
        "!                  !",
        "!                  !",
        "!                  !",
        "!!$!!$!!$!!$!!$!!$!!",
        "                    ",
        "                    ",
        "                    "}
create_world_by_map(level)
draw_map(0,0,stmap,stones)
draw_map(0,0,itmap,items)
draw_map(0,0,acmap,actors)

sup = {}
sdw = {}
tup = {}
tdw = {}
killall=0

function fup1() fup(1) end
function fup2() fup(2) end
function fup3() fup(3) end
function fup4() fup(4) end
function fup5() fup(5) end
function fup6() fup(6) end
function fup7() fup(7) end
function fup8() fup(8) end
function fup9() fup(9) end
function fup10() fup(10) end
function fup11() fup(11) end
function fup12() fup(12) end
function fup13() fup(13) end
function fup14() fup(14) end
function fup15() fup(15) end
function fup16() fup(16) end
function fup17() fup(17) end
function fup18() fup(18) end

function fdw1() fdw(1) end
function fdw2() fdw(2) end
function fdw3() fdw(3) end
function fdw4() fdw(4) end
function fdw5() fdw(5) end
function fdw6() fdw(6) end
function fdw7() fdw(7) end
function fdw8() fdw(8) end
function fdw9() fdw(9) end
function fdw10() fdw(10) end
function fdw11() fdw(11) end
function fdw12() fdw(12) end
function fdw13() fdw(13) end
function fdw14() fdw(14) end
function fdw15() fdw(15) end
function fdw16() fdw(16) end
function fdw17() fdw(17) end
function fdw18() fdw(18) end

function wup1() wup(1) end
function wup2() wup(2) end
function wup3() wup(3) end
function wup4() wup(4) end
function wup5() wup(5) end
function wup6() wup(6) end
function wup7() wup(7) end
function wup8() wup(8) end
function wup9() wup(9) end
function wup10() wup(10) end
function wup11() wup(11) end
function wup12() wup(12) end
function wup13() wup(13) end
function wup14() wup(14) end
function wup15() wup(15) end
function wup16() wup(16) end
function wup17() wup(17) end
function wup18() wup(18) end

function wdw1() wdw(1) end
function wdw2() wdw(2) end
function wdw3() wdw(3) end
function wdw4() wdw(4) end
function wdw5() wdw(5) end
function wdw6() wdw(6) end
function wdw7() wdw(7) end
function wdw8() wdw(8) end
function wdw9() wdw(9) end
function wdw10() wdw(10) end
function wdw11() wdw(11) end
function wdw12() wdw(12) end
function wdw13() wdw(13) end
function wdw14() wdw(14) end
function wdw15() wdw(15) end
function wdw16() wdw(16) end
function wdw17() wdw(17) end
function wdw18() wdw(18) end

function fup(i)
  if killall == 1 then
    kill_stone(i,4)
  end
  if killall == 0 then
    sup[i] = sup[i] + 1
    if sup[i] == 5 then sup[i] = 1 end
    killall = 1
    for j = 1,18 do
      if not(sup[j] == tup[j]) then killall = 0 end
      if not(sdw[j] == tdw[j]) then killall = 0 end
    end
  end
end

function fdw(i)
  if killall == 1 then
    kill_stone(i,8)
  end
  if killall == 0 then
    sdw[i] = sdw[i] + 1
    if sdw[i] == 5 then sdw[i] = 1 end
    killall = 1
    for j = 1,18 do
      if not(sup[j] == tup[j]) then killall = 0 end
      if not(sdw[j] == tdw[j]) then killall = 0 end
    end
  end
end

function wup(i)
    kill_stone(i,5)
    set_stone("st-switch", i,7,{action="callback", target="wdw"..tostring(i), on=1})
    --fourswitch = enigma.GetNamedObject("dw("..tostring(i)..")")
    --if random(1,2)==1 then
    --  SendMessage(fourswitch, "turn", NORTH)
    --end
    oxyd_closeall()
    oxyd_shuffle()
end

function wdw(i)
    kill_stone(i,7)
    set_stone("st-switch", i,5,{action="callback", target="wup"..tostring(i), on=0})
    --fourswitch = enigma.GetNamedObject("up("..tostring(i)..")")
    --if random(1,2)==1 then
    --  SendMessage(fourswitch, "turn", NORTH)
    --end
    oxyd_closeall()
    oxyd_shuffle()    
end

for i=1,18 do
    set_stone("st-fourswitch",i,4,{name="up("..tostring(i)..")", action="callback", target="fup"..tostring(i)})
    set_stone("st-fourswitch",i,8,{name="dw("..tostring(i)..")", action="callback", target="fdw"..tostring(i)})
    set_stone("st-switch", i,5,{action="callback", target="wup"..tostring(i), on=0})
    set_stone("st-switch", i,7,{action="callback", target="wdw"..tostring(i), on=1})    
end

randomseed( enigma.GetTicks() )

for i=1,18 do
    -- rows 4,6 and 8 doesn't mean anything!    
    for j=4,8 do
      random_number = random(1,4)
      if random_number == 1 then  set_floor("fl-sahara",   i, j, {name = "fl1"} )  end
      if random_number == 2 then  set_floor("fl-red",      i, j, {name = "fl2"} )  end
      if random_number == 3 then  set_floor("fl-bluegray", i, j, {name = "fl3"} )  end
      if random_number == 4 then  set_floor("fl-tigris",   i, j, {name = "fl4"} )  end
    end
    -- upper row
    random_number = random(1,4)
    if random_number == 1 then  set_floor("fl-sahara",   i, 5, {name = "fl1"} )  end
    if random_number == 2 then  set_floor("fl-red",      i, 5, {name = "fl2"} )  end
    if random_number == 3 then  set_floor("fl-bluegray", i, 5, {name = "fl3"} )  end
    if random_number == 4 then  set_floor("fl-tigris",   i, 5, {name = "fl4"} )  end
    sup[i] = 1
    tup[i] = random_number
    -- lower row
    random_number = random(1,4)
    if random_number == 1 then  set_floor("fl-sahara",   i, 7, {name = "fl1"} )  end
    if random_number == 2 then  set_floor("fl-red",      i, 7, {name = "fl2"} )  end
    if random_number == 3 then  set_floor("fl-bluegray", i, 7, {name = "fl3"} )  end
    if random_number == 4 then  set_floor("fl-tigris",   i, 7, {name = "fl4"} )  end
    sdw[i] = 1
    tdw[i] = random_number
end

if not difficult then
  set_item("it-pin", 3, 6)
end

set_item("it-document", 16, 6,
   {text="Our full attention should deserve:           Air and Fire, Water, Earth."})

secondhint = 0
function timercallback()
  if secondhint == 0 then
    secondhint = 1
    set_item("it-document", 16, 6,
      {text="And if your tries grow out of bound,           then shame on you, eyes to the ground!"})
  end
end

set_stone("st-timer", 1, 1, {interval=360.0, action="callback", target="timercallback", invisible=TRUE})

oxyd_shuffle()


























