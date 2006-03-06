-- MetaPuzzles -- the Enigma Level
-- (c) 2002 Petr Machata/ant_39
-- Licensed under GPL v2.0 or above

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

floortile = "fl-rough"
bordertile = "st-brick"
walltile = "st-glass"
flbridge = "fl-wood"

levelw = 20+19
levelh = 13

waterx0 = 5
waterw0 = 8

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

create_world(levelw, levelh)
fill_floor(floortile)

draw_border(bordertile)


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- the generator

x0 = 1
y0 = 1
x1 = 11
y1 = 4
sid = 0
sw = {}
sws = {}
barx = 27
abyssw = 34-barx-1

function proceed()
   function isstone(arr, x, y)
      if ((x>=1)and(y>=1)and(x<=4)and(y<=4)) then
         if sws[(x-1)*4+y] == 1 then
	    return 1
         else
	    return 0
         end
      else
	return 0
      end
   end

   for x=1,4 do
      for y=1,4 do
	 if (isstone(sarr, x, y)==1) then -- sarr[x..","..y]==1 then
	    --look around where are other stones
	    up   = isstone(sws, x, y-1)
	    down = isstone(sws, x, y+1)
	    left = isstone(sws, x-1, y)
	    right= isstone(sws, x+1, y)
	    --and convert this information to puzzle stone
	    dostring("puz = PUZ_"..up..right..down..left)
	    puzzle(x1+x, y1+y, puz)
         end
      end
   end
end

for x=1,4 do
   for y=1,4 do
      sid = sid+1
      set_stone("st-switch", x0+2*x, y0+2*y, {action="callback", target="sw"..sid})
      func = "function sw"..sid.."() k="..sid.."; if sws[k]==0 then sws[k]=1 else sws[k]=0 end end"
      dostring(func)
      sws[sid] = 0
   end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- the abyss

fill_floor("fl-metal", x0+1, y0+1, 9, 9)
fill_floor("fl-floor_001", x1+1, y1+1, 4, 4)
fill_floor("fl-metal", x1+1, y1+5, 4, 2)
fill_floor("fl-abyss",  barx+1, 1, abyssw, level_height-2)

draw_stones(walltile, {x1+1, y1+5}, {1, 0}, 4);

-- Keep the marble in safe distance from the "generator" \dh\
set_stone("st-switch", x1+2, y1+6, {action="callback", target="proceed"})

fill_floor("fl-normal", 34, 1, 2, level_height-2)
set_stones(bordertile, {{34, 1}, {34, 5}, {34, 7}, {34, 11}})
draw_stones(bordertile, {35, 1}, {0, 1}, 2)
draw_stones(bordertile, {35, 4}, {0, 1}, 2)
draw_stones(bordertile, {35, 7}, {0, 1}, 2)
draw_stones(bordertile, {35, 10}, {0, 1}, 2)
fill_floor("fl-normal", barx, 1, 1, level_height-2)
set_stones(bordertile, {{barx, 1}, {barx, 5}, {barx, 7}, {barx, 11}})
set_item("it-trigger", 34, 3, {action="openclose", target="bridge1"})
set_item("it-trigger", 34, 9, {action="openclose", target="bridge2"})
set_floor("fl-normal", barx+1,  1)
set_floor("fl-normal", barx+1, 11)
set_item("it-spring1", barx+1,  1)
set_item("it-hammer", barx+1, 11)
set_floor("fl-bridge", barx+1,  2, {name="bridge1"})
set_floor("fl-bridge", barx+1, 10, {name="bridge2"})
fill_floor("fl-normal", barx+2, 6, abyssw-2, 1)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- oxyd stones and stuff

oxyd_default_flavor="d"
oxyd (level_width-2,1)
set_stones("st-stone_break", {{level_width-3,1},{level_width-3,2},{level_width-2,2}})
oxyd (level_width-2,level_height-2)
set_stones("st-stone_break", {{level_width-3,level_height-2},{level_width-3,level_height-3},{level_width-2,level_height-3}})
oxyd_shuffle()
set_actor("ac-blackball", 1.5, 5.5)















