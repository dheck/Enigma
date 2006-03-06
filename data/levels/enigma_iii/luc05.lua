-- Dance with the Death, a level for Enigma
-- Copyright (C) 2005 Lukas Schueller
-- licensed under GPL v2.0 or above
-- Contact: Lucky_Luc@web.de
--------------------------------------------
-- List of floor tiles
floors = {
"fl-metal",
"fl-lightgray",
"fl-darkgray",
"fl-brick",
"fl-gravel",
"fl-leaves"
}
-------------------------------------------
enigma.ConserveLevel = FALSE
CreateWorld(58,37)
--------------------------------------------
--environment
draw_border("st-rock2")
fill_floor("fl-metal",0,0,58,37)
for i=1, 45 do
  fill_floor(floors[random(getn(floors))],random(52),random(31),random(4,10),random(4,10))
end
--------------------------------------------
--oxyd stones
oxyd(0,1)
oxyd(57,1)
oxyd(0,35)
oxyd(57,35)
oxyd_shuffle()
--------------------------------------------
--actors (connected with a rubberband)
local ball = set_actor("ac-blackball",58/2,37/2-4,{player=0})
local kill = set_actor("ac-killerball",58/2,37/2+4,{controllers=0})
AddRubberBand(kill,ball,15,0)
display.SetFollowMode(display.FOLLOW_SCROLLING)




























