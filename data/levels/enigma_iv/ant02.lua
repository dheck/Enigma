-- GO! -- the Enigma Level
-- (c) 2002 Petr Machata/ant_39
-- Licensed under GPL v2.0 or above
-- 2003-01-10 -- final glass block replaced by vertical door
-- 2003-01-25 -- enigma.ConserveLevel=FALSE added
-- 2003-06-28 -- fixes due to changes in Enigma: the bridge moves slower

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
enigma.ConserveLevel=FALSE                  -- \dh\

floortile = "fl-bluegray"
bordertile = "st-rock1"
walltile = "st-glass"
flbridge = "fl-wood"

levelw = 20
levelh = 13

waterx0 = 5
waterw0 = 8

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

swc = 0;

function sw1()
    if (swc == 0) then
        SendMessage("bolder01","direction",EAST);
        swc = 1
    end
end

function sw2()
   if (swc == 1) then
       SendMessage("bolder01","direction",WEST);
       swc = 2
   end
end

function sw3()
   if (swc == 2) then
       SendMessage("bolder02","direction",EAST);
      swc = 3
   end
end

function sw4()
   if (swc == 3) then
       SendMessage("bolder02","direction",WEST);
      swc = 4
   end
end

function sw5()
   if (swc == 4) then
      SendMessage("doorA", "close")
      swc = 5
   end
end

-- 20x13 --> +19, +12

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

create_world(levelw, levelh)
fill_floor(floortile)

draw_border(bordertile)
draw_stones(bordertile, {1,level_height-3}, { 1,0}, level_width-2)
draw_stones(bordertile, {1,2}, {1,0}, level_width-2)
set_stone(bordertile, 5,9)
draw_stones(walltile, {2,3}, {0,1}, 1)
draw_stones(walltile, {2,5}, {0,1}, level_height-8)
draw_stones(walltile, {level_width-3,3}, {0,1}, 3)
draw_stones(walltile, {level_width-3,7}, {0,1}, level_height-10)
draw_floor("fl-water", {level_width-4,3}, {0,1}, level_height-6)
set_stone("st-bolder-n", 2, 11, {name="bolder01"})
set_stone("st-bolder-s", 2, 1, {name="bolder02"})
set_item("it-trigger", 2, 4, {action="callback", target="sw1"})
set_item("it-trigger", level_width-2, level_height-2, {action="callback", target="sw2"})
set_item("it-trigger", 1, level_height-2, {action="callback", target="sw3"})
set_item("it-trigger", level_width-2, 1, {action="callback", target="sw4"})
set_item("it-trigger", 1, 1, {action="callback", target="sw5"})
set_stone(walltile, 3,6)
set_stone(walltile, 4,6)
set_stone("st-wood", 5,6)
set_stone("st-door", level_width-3, 6, {name="doorA", type="v"})
SendMessage("doorA", "open")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- bridges
cenbridge = 1
cunbridge = 2

function enbridge()
   set_floor(flbridge, waterx0+cenbridge, 5)
   set_floor(flbridge, waterx0+waterw0+1-cenbridge, 7)
   cenbridge = cenbridge + 1
   if (cenbridge>waterw0) then
      cenbridge = 1
   end
end

function unbridge()
   set_floor("fl-water", waterx0+cunbridge, 5)
   set_floor("fl-water", waterx0+waterw0+1-cunbridge, 7)
   cunbridge = cunbridge + 1
   if (cunbridge>waterw0) then
      cunbridge = 1
   end
end

fill_floor("fl-water", waterx0+1, 3, waterw0, level_height-6)
set_stone("st-timer", 0, 2,              {action="callback", target="enbridge", interval=0.4});
set_stone("st-timer", 0, level_height-3, {action="callback", target="unbridge", interval=0.4});
draw_floor(flbridge, {waterx0+1,5}, {1,0}, waterw0);
draw_floor(flbridge, {waterx0+1,7}, {1,0}, waterw0);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

oxyd (level_width-2,3)
oxyd (level_width-2,level_height-4)
oxyd_shuffle()
set_actor("ac-blackball", 1.5, 5.5)

enigma.ConserveLevel=FALSE















