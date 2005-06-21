-- Arcoculture -- the Enigma Level
-- (c) 2003 Petr Machata/ant_39
-- Licensed under GPL v2.0 or above
-- 2003-01-13
-- 2003-06-24 -- changes in AddConstantForce

dofile(enigma.FindDataFile("levels/ant.lua"))
dofile(enigma.FindDataFile("levels/natmaze.lua"))

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- i took base for this cell_to_level and render_cell from Nat Pryce's natmaze.lua maps

mazecellsize = 3
mazebasesize = 2
mazebranchsize = 2
originx = 2
originy = 2
mazew=8
mazeh=5

abyssfloor=cell{floor={face="fl-abyss"}}
solidfloor =cell{parent={{randomfloor,{cell{floor={face="fl-metal"}},cell{floor={face="fl-tigris"}},0.15}}}}
borderstone=cell{parent={abyssfloor, {randomfloor,{cell{stone={face="st-rock2"}},cell{stone={face="st-rock5"}},0.15}}}}

function cell_to_level( cellx, celly )
   return originx + cellx * mazecellsize, originy + celly * mazecellsize
end

function render_cell(maze, cellx, celly)
   x,y = cell_to_level(cellx, celly)

   for xx=0,mazebasesize-1 do
      for yy=0,mazebasesize-1 do
	 solidfloor(x+xx, y+yy)
      end
   end

   if maze:can_go_south(cellx,celly) then
      for i=mazebasesize,mazecellsize do
	 for j=0,mazebranchsize-1 do
	    solidfloor(x+j, y+mazecellsize-i+1)
	 end
      end
   end

   if maze:can_go_east(cellx,celly) then
      for i=mazebasesize,mazecellsize do
	 for j=0,mazebranchsize-1 do
	    solidfloor(x+mazecellsize-i+1, y+j)
	 end
      end
   end
end

forces = {
   {0, 1},
   {1, 0},
   {0, -1},
   {-1, 0}
}
ticktim = 1.7
force = 13
curforce = nil

function tick()
   if (not(curforce)) then
      curforce = 1
   end

   if (curforce == getn(forces)) then
      curforce = 1
   else
      curforce = curforce +1
   end

   local lforce = forces[curforce]
   enigma.AddConstantForce(lforce[1]*force,lforce[2]*force)
end


function place_oxyd_stone(func, x,y)
   oxyd(x, y)
   func(x-1, y)
   func(x, y-1)
   func(x+1, y)
   func(x, y+1)
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
cells={}

cells["w"]=cell{floor={face="fl-wood"}}
cells["~"]=cell{parent={cells["w"]},stone={face="st-timer", attr={action="callback", target="tick", interval=ticktim}}}

cells["O"]=cell{parent=cells["w"],actor={face="ac-blackball", attr={player=0}}}

map = {
   "wwwww",
   "wwwww",
   "ww~ww",
   "wwwww",
   "Owwww",
}
platformw, platformh = get_map_size(map)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
maze0 = new_kruskal_maze(mazew, mazeh)

create_world(mazew*3+originx*2-1, mazeh*3+originy*2-1)
fill_world_func(abyssfloor)

draw_border_func(borderstone)
render_maze(maze0, render_cell)
draw_map(originx, originy, map)--25

place_oxyd_stone(solidfloor, originx-1, originy-1)
place_oxyd_stone(solidfloor, originx+mazew*3-1, originy-1)
place_oxyd_stone(solidfloor, originx-1, originy+mazeh*3-1)
place_oxyd_stone(solidfloor, originx+mazew*3-1, originy+mazeh*3-1)

oxyd_shuffle()
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
display.SetFollowMode(display.FOLLOW_SCROLLING)
