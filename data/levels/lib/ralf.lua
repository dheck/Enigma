-- Helper functions for ralfXX.lua
-- Filename: 	ralf.lua
-- Copyright: 	(c) Feb 2003 Ralf Westram
-- Contact: 	amgine@reallysoft.de
-- License: 	GPL v2.0 or above

Require("levels/lib/ant.lua")
-- Thanks to ant

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- draw maps of maps (metamaps)
-- * each cell in a metamap refers to a normal map (here: basemap)
--
-- example:
-- metacells = {}
-- metacells["0"] = cell{parent={{draw_metamap_oriented, basemap, cells,0,0,0}}}
-- metacells["1"] = cell{parent={{draw_metamap_oriented, basemap, cells,1,0,0}}}
--
-- use draw_map() or draw_map_oriented() to draw the metamap
--
function draw_metamap_oriented(x,y,bmap,cells,flipx, flipy,rotate)
   local bmapw,bmaph = get_map_size(bmap)
   if (bmapw~=bmaph) then
      print("warning: [ralf.lua]: draw_metamap_oriented() prefers quadratic maps!")
   end
   draw_map_oriented(x*bmapw+1,y*bmaph+1,bmap,bmapw,bmaph,cells,flipx,flipy,rotate)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- a modified version of ant's draw_map()
-- it allows to change the orientation of whats drawn
--
-- x0/y0 = left upper corner coordinates
-- map   = map to draw
-- width/height = size of map
-- cellfuncs = what to draw
-- flipx == 1 -> flip horizontally
-- flipy == 1 -> flip vertically
-- rot == 0 -> rotate   0 degrees clockwise
-- rot == 1 -> rotate  90 degrees clockwise
-- rot == 2 -> rotate 180 degrees clockwise
-- rot == 3 -> rotate 270 degrees clockwise
--
function draw_map_oriented(x0, y0, map, width, height, cellfuncs, flipx, flipy,rotate)
   local funcs = cellfuncs or cells or {}; --we hope that if nil is passed, global cells is defined.

   while (rotate > 3) do rotate = rotate-4 end
   while (rotate < 0) do rotate = rotate+4 end

   for y,str in pairs(map) do
      for x = 1,width do
         local key = strsub(str, (x-1)*CELL_KEY_WIDTH+1, x*CELL_KEY_WIDTH)
         local func = funcs[key]
         local ftype = type(func)

         if (ftype == "function") then
            local xr = x0;
            local yr = y0;

            if ((flipx == 1) or (flipy == 1)) then -- draw flipped
               if (rotate ~= 0) then
                  error("Warning [ralf.lua]: rotate and flip do not work together at the moment (rotation is ignored)")
               end
               if (flipx==1) then
                  xr = xr + width - x
               else
                  xr = xr + x -1
               end
               if (flipy==1) then
                  yr = yr + height - y
               else
                  yr = yr + y -1
               end
            else -- draw rotated
               if (rotate==0) then
                  xr = xr + (x-1)
                  yr = yr + (y-1)
               elseif (rotate==1) then
                  xr = xr + (width-1) - (y-1)
                  yr = yr + (x-1)
               elseif (rotate==2) then
                  xr = xr + (width-1) - (x-1)
                  yr = yr + (height-1) - (y-1)
               elseif (rotate==3) then
                  xr = xr + (y-1)
                  yr = yr + (height-1) - (x-1)
               end
            end

            func(xr,yr)

         elseif (ftype == "nil") then
            print("warning: [ralf.lua]: function doesn't exist for map element '"..key.."'.")
         else
            print("warning: [ralf.lua]: cell element '"..key.."' is not a function, it's "..ftype..".")
         end
      end
   end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- general world drawing function
-- (works also with maps smaller than 20 x 13 ; outside filled with abyss)
--
-- map, mapcells        see draw_map()
-- floorcell            used to draw the floor
-- abysscell            used to draw the space outside the level (if nil -> "fl-abyss" is used)
-- bordercell           used to draw the border (if nil -> no border)
--
-- sets some global variables:
--
-- mapw/maph            real size of map
-- worldw/worldh        same including border
-- xlo/ylo              left/upper corner coordinates (of map!)

preferred_width,preferred_height = 20,13

function rs_init_world(map, bordercell)
   mapw,maph = get_map_size(map)

   if (bordercell) then
      worldw,worldh   = mapw+2,maph+2
   else
      worldw,worldh   = mapw,maph
   end

   local rworldw,rworldh = worldw,worldh
   if rworldw<preferred_width  then rworldw=preferred_width  end
   if rworldh<preferred_height then rworldh=preferred_height end

   xlo = floor((rworldw-mapw-1)/2)+1
   ylo = floor((rworldh-maph-1)/2)+1

   --print("xlo="..xlo.." ylo="..ylo)

   local oxyd_flavor = oxyd_default_flavor
   create_world(rworldw, rworldh)
   oxyd_default_flavor = oxyd_flavor
end

function rs_create_world(map,mapcells,floorcell,abysscell,bordercell)
   floorcell = floorcell or cells[" "] or cell{floor={face="fl-normal"}}
   abysscell = abysscell or cell{floor={face="fl-abyss"}}

   rs_init_world(map,bordercell)

   fill_world_func(abysscell)
   fill_world_func(floorcell,xlo,ylo,mapw,maph)
   if (bordercell) then
      draw_border_func(bordercell,xlo-1,ylo-1,worldw,worldh)
   end
   draw_map(xlo,ylo,map,mapcells)
end

