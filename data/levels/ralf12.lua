-- A level for Enigma
-- Name:        -- puzzle meditation --
-- Filename:    ralf12.lua
-- Copyright: 	(C) Jun 2003 Ralf Westram
-- Contact: 	amgine@reallysoft.de
-- License: 	GPL v2.0 or above

dofile(enigma.FindDataFile("levels/ralf.lua"))

--debug_mode()

level={
   "!!#!@@########@@!#!!",
   "!!+!@@  ....  @@!+!!",
   "#+++U   ****   U+++#",
   "!!+#  $$++*+$$  #+!!",
   "@@T   $ ++++     T@@",
   "@@.  *++    ++*  .@@",
   "#.b.***+ bb +***.b.#",
   "@@.  *++    ++*  .@@",
   "@@T     ++++ $   T@@",
   "!!+#  $$+*++$$  #+!!",
   "#+++U   ****   U+++#",
   "!!+!@@  ....  @@!+!!",
   "!!#!@@########@@!#!!",
}

state={}
group={1,2,2,1,3,4,5,5,6,6,3,4,7,8,8,7} -- trigger->target
count={0,0,0,0,0,0,0,0} -- how many triggers of each group are active (2 exist per group)

triggers=0
targets=0

function trigger_group(num)
   SendMessage("target"..num, "openclose")
end

function trigger(num)
   local newstate = 1-state[num]
   local offset = 1
   if (newstate==0) then offset=-1 end

   local g = group[num]
   if (count[g]==2) then
      trigger_group(g) -- deactivate target
   end
   count[g] = count[g]+offset
   if (count[g]==2) then
      trigger_group(g) -- activate target
   elseif (count[g]>2 or count[g]<0) then
      error("group count overflow")
   end

   state[num] = newstate
end

function set_trigger(x,y)
   triggers = triggers + 1
   state[triggers] = 0
   local funcn = "trig_"..triggers
   dostring(funcn.." = function() trigger("..triggers..") end")
   set_item("it-trigger",x,y,{action="callback",target=funcn});
end
function set_target(x,y,t)
   targets = targets + 1
   set_stone("st-door_b",x,y,{name="target"..targets,type="v"});
end
function set_targetv(x,y) set_target(x,y,"v") end
function set_targeth(x,y) set_target(x,y,"h") end

cells={}

cells[" "] = cell{floor="fl-hay"}
cells["!"] = cell{floor="fl-abyss"}
cells["#"] = cell{parent=cells[" "],stone="st-brick"}
cells["b"] = cell{parent=cells[" "],actor={"ac-whiteball-small", {player=0, essential=1}}}
cells["."] = cell{parent={cells[" "],set_trigger}}
cells["T"] = cell{parent={cells[" "],set_targeth}}
cells["U"] = cell{parent={cells[" "],set_targetv}}
cells["o"] = cell{oxyd}

cells["w"] = cell{parent=cells[" "], item="it-magicwand"}

puzzles1 = {}
puzzles2 = {}
bigbricks = {}

cells["*"]=cell{parent={{add_multicell, puzzles1}}}
cells["+"]=cell{parent={{add_multicell, puzzles2}}}
cells["@"]=cell{parent={{add_multicell, bigbricks}}}

if (difficult) then
   cells["$"]=cells["+"]
else
   cells["$"]=cells[" "]
end

rs_create_world(level,cells)

render_puzzles(puzzles1)
render_puzzles(puzzles2, puzzle2)
render_puzzles(bigbricks, bigbrick)

function scrambleDiff(x,y,d) if (difficult) then enigma.AddScramble(x,y,d) end end
function scrambleEasy(x,y,d) if (not difficult) then enigma.AddScramble(x,y,d) end end
function scrambleBoth(x,y,d) enigma.AddScramble(x,y,d) end

-- tiles in corners:
enigma.SetScrambleIntensity(30)

scrambleBoth(2,3,"n")
scrambleBoth(3,2,"w")

scrambleBoth(2,9,"s")
scrambleBoth(3,10,"w")

scrambleBoth(17,3,"n")
scrambleBoth(16,2,"e")

scrambleBoth(17,9,"s")
scrambleBoth(16,10,"e")

-- tile(s) in center:
--  north
scrambleEasy(8,3,"e")
scrambleBoth(8,4,"n")
scrambleEasy(8,4,"e")
scrambleBoth(9,4,"n")
scrambleBoth(11,4,"w")
scrambleBoth(11,4,"n")

-- west
scrambleEasy(7,5,"s")
scrambleBoth(7,5,"w")
scrambleBoth(7,7,"n")
scrambleBoth(7,7,"w")

-- east
scrambleBoth(12,5,"s")
scrambleBoth(12,5,"e")
scrambleEasy(12,7,"n")
scrambleBoth(12,7,"e")

-- south
scrambleBoth(8,8,"s")
scrambleBoth(8,8,"e")
scrambleBoth(10,8,"s")
scrambleEasy(11,8,"w")
scrambleBoth(11,8,"s")
scrambleEasy(11,9,"w")

-- outer corners
scrambleDiff(13,3,"w")
scrambleDiff(6,3,"e")
scrambleDiff(6,3,"s")
scrambleDiff(6,9,"e")
scrambleDiff(13,9,"w")
scrambleDiff(13,9,"n")

oxyd_shuffle()

-- Added hollows (dh)

set_item("it-hollow", 2, 2)
set_item("it-hollow", 2, 10)
set_item("it-hollow", 17, 2)
set_item("it-hollow", 17, 10)

