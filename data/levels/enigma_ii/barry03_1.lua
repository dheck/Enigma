-- A level for Enigma
-- Name: 	Tool-Time
-- Filename: 	barry03.lua
-- Copyright: 	(c) Dec 2003 Barry Mead
-- Contact: 	bmead15@cox.net
-- License: 	GPL v2.0
-- Written by:  Barry and Lori Mead
Require("levels/lib/ant.lua")
      --debug_mode()
      cells={}
      cells[" "]=cell{floor="fl-black"}
      cells["~"]=cell{floor="fl-abyss"}
      cells["`"]=cell{floor="fl-space"}
      cells[":"]=cell{parent=cells[" "], stone="st-chameleon", item="it-seed"}
      cells[";"]=cell{parent=cells[" "], stone="st-chameleon", item="it-brush"}
      cells["h"]=cell{parent=cells[" "], stone="st-chameleon", item="it-hammer"}
      cells["f"]=cell{parent=cells["`"], stone="st-chameleon", item="it-floppy"}
      cells["G"]=cell{stone="st-grate1"}
      cells["g"]=cell{stone="st-knight"}
      cells["B"]=cell{stone="st-stone_break"}
      cells["V"]=cell{stone="st-break_invisible"}
      cells["v"]=cell{stone="st-stonebrush"}
      cells["I"]=cell{stone={"st-door-v-open", {name="doorA"}}}
      cells["S"]=cell{item={"it-trigger", {action="openclose",  target="doorA"}}}
      cells["i"]=cell{stone={"st-door-v", {name="doorB"}}}
      cells["7"]=cell{stone={"st-door-h", {name="doorC"}}}
      cells["-"]=cell{stone={"st-door-h", {name="doorD"}}}
      cells["m"]=cell{stone={"st-coinslot", {action="open", target="doorD"}}}
      cells["F"]=cell{stone={"st-floppy", {action="openclose", target="doorC"}}}
      cells["#"]=cell{stone="st-rock1"}
      cells["C"]=cell{item="it-coffee"}
      cells["n"]=cell{item={"it-document", {text="Make a Sword, & Umbrella"}}}
      cells["1"]=cell{item={"it-coin4"}}
      cells["2"]=cell{item={"it-coin1"}}
      cells["T"]=cell{stone="st-rock1_hole"}
      cells["t"]=cell{stone= {"st-switch",{action="callback", target="s1"}}}
      cells["L"]=cell{stone={"st-laser", {on=FALSE, dir=SOUTH, name="laser1"}}}
      cells["l"]=cell{item={"it-trigger", {action="onoff",  target="laser1"}}}
      cells["x"]=cell{item={"it-trigger", {action="close",  target="doorA"}}}
      cells["o"]=cell{item={"it-trigger", {action="open",   target="doorA"}}}
      cells["$"]=cell{item={"it-trigger", {action="openclose", target="doorB"}}}
      cells["d"]=cell{stone="st-oneway-s"}

     

      level = {
        --01234567890123456789012345678901234567890
         "#######################################",--0
         "#0  v        v#0#m G              ~~~;#",--1
         "#vv v    v   v#-#  G    ggggg     ~0~ #",--2
         "#   v    v   v     G    gBBBg     ~~~ #",--3
         "# vvv    v   vvvvvvG    gB0Bg         #",--4
         "#        v        vG    gBBBg         #",--5
         "#vvvvvvvvv  vvvvvvvG    ggggg         #",--6
         "#           v    0vG                  #",--7
         "#vvvvv vvvvvv vv vvG   VVV     ########",--8
         "#0     v       v   G   V0V     #     ##",--9
         "#  vvvvv vvvvvvv $ G   VVV     #d### ##",--10
         "#        v         G           I xgBo0#",--11
         "#vvvvvvvvvVvvvvvvvv#T##################",--12
         "#           ``````f#n   v        L    #",--13
         "#           ``````0#vvv v             #",--14
         "#           ########    v             #",--15
         "#####              # vvvv     O      l#",--16
         "# 1 #      ggggg   #                  #",--17
         "# 2 #      ggggg   #vv                #",--18
         "# 2 i      gg0gg   #0V       BBB      #",--19
         "#####      ggggg   #vv       B0B      #",--20
         "#          ggggg   #         BBB      #",--21
         "##7#F              #               ##d#",--22
         "#0 0#                             h#~C#",--23
         "#########T##########################T##",--24
         "#                  #     #0           #",--21
         "#0                 TV   :#t           #",--25
         "#######################################" --26
        --01234567890123456789012345678901234567890
      }
      oxyd_default_flavor = "b"
      set_default_parent(cells[" "])
      create_world_by_map(level)
      oxyd_shuffle()
      i = 0


function s1()
i = 1 - i
if i == 1 then
    set_stone("st-oneway-n", 37, 22)
 else
    set_stone("st-oneway-s", 37, 22)
 end
end
















