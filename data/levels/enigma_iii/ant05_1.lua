-- The Turtle -- the Enigma Level
-- (c) 2002 Petr Machata/ant_39
-- Licensed under GPL v2.0 or above
-- 2003-02-10 -- keeping up to date with latest additions to ant.lua

Require("levels/lib/ant.lua")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- turtle state
ingame = nil

-- command constants
command_clean = -1
command_north = enigma.NORTH
command_south = enigma.SOUTH
command_west  = enigma.WEST
command_east  = enigma.EAST

--work
command=command_clean

--pad center
cent = {}; function set_pad_center(x, y) cent.x, cent.y = x, y end

--magic stone position
mags = {}; function set_magic_stone(x, y) mags.x, mags.y = x, y end

--table to translate current command to stone properties
--x, y is current direction indicator position - floor
--face is face of stone in buffer
--params is the direction of the bolder (ignored otherwise)
function new_command(flx0, fly0, face0, params0)
   ret = {}
   ret.face = face0
   ret.par = params0
   ret.x = flx0
   ret.y = fly0
   return ret
end

buftable = {}

--command selection via the trigger "gamepad"
function setcommand(newcmd)
   local flx0, fly0 = buftable[newcmd].x, buftable[newcmd].y
   local clx0, cly0 = buftable[command].x, buftable[command].y

   if (not(ingame)) then
      if ((clx0 or cly0) ~= nil) then set_floor("fl-sand",   clx0, cly0); end
      if ((flx0 or fly0) ~= nil) then set_floor("fl-normal", flx0, fly0); end
      command = newcmd
   end
end

function commandnorth() setcommand(command_north); end
function commandsouth() setcommand(command_south); end
function commandeast()  setcommand(command_east);  end
function commandwest()  setcommand(command_west);  end
function commandclean() setcommand(command_clean); end

--magic stones eyecandy
function magic_stone(face)
   enigma.KillStone(mags.x, mags.y)
   set_stone(face, mags.x, mags.y)
end

function draw_magic()    magic_stone("st-magic") end
function erase_magic()   magic_stone("st-rock1") end
function invalid_magic() magic_stone("st-death") end

--bufferworks
first_free_element = function (buf,i) return buf[i].command ~= command_clean end
first_command = function (buf,i) return buf[i].command == command_clean end

function buffer_create(buf)
   local ret = {}
   ret.n = 0
   return ret
end

function buffer_add_item(buf, x,y)
   buf.n = buf.n+1
   buf[buf.n] = {}
   buf[buf.n].x = x
   buf[buf.n].y = y
   buf[buf.n].command = command_clean
end

function draw_buffer(buf, tab)
   for i=1,buffer_items.n do
      local x, y, cmd = buf[i].x, buf[i].y, buf[i].command
      local tab = tab[cmd]

      enigma.KillStone(x, y)
      set_stone(tab.face, x, y, {direction=tab.par})
   end
end

function buffer_generic_test(buf,test)
   local i=1
   while test(buf,i) do
      i=i+1
      if (not(buf[i])) then
	 return nil
      end
   end
   return i
end

function buffer_push_command(buf)
   local i = buffer_generic_test(buf, first_free_element)

   if (i) then
      buf[i].command = command
   end
end

function buffer_pop_command(buf)
   local i = buffer_generic_test(buf, first_command)

   if (i) then
      local ret = buf[i].command
      buf[i].command = command_clean
      return ret
   else
      return nil
   end
end

function buffer_clear_commands(buf)
   for i=1,buf.n do
      buf[i].command = command_clean
   end
end

-- wrappers to be called by enigma and map drawing function
function additem(x,y)
   buffer_add_item(buffer_items, x, y)
end

buffer_items = buffer_create()

function addcommand()
   if (not(ingame)) then
      buffer_push_command(buffer_items)
      draw_buffer(buffer_items, buftable)
      commandclean()
   end
end

function clearbuffer()
   ingame = nil
   buffer_clear_commands(buffer_items)
   draw_buffer(buffer_items, buftable)
   erase_magic()
end

counter = 0
function boldercommand(startcommand)
   if (startcommand==1) then
      counter = 0
   end

   if (mod(counter,2) == 0) then --trigger works twice: upon enter and upon leave
      local cmd = buffer_pop_command(buffer_items)

      if (cmd) then
         SendMessage("bolder1", "direction", buftable[cmd].par)
         draw_buffer(buffer_items, buftable)
         draw_magic()
      else
         invalid_magic()
      end
   end

   counter = counter + 1
end

function startbolder()
   if (not(ingame)) then
      ingame = 1
      boldercommand(1)
   end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- and finally, the map itself
cells={}
cells[" "]=cell{floor={face="fl-sand"}}
cells["#"]=cell{stone="st-rock1"}
cells["x"]=cell{stone="st-grate1"}
cells["!"]=cell{{cells["x"], additem}}
cells["a"]=cell{stone={"st-switch", {action="callback", target="addcommand" }}}
cells["b"]=cell{stone={"st-switch", {action="callback", target="startbolder"}}}
cells["c"]=cell{stone={"st-switch", {action="callback", target="clearbuffer"}}}
cells["d"]=cell{item= {"it-trigger",{action="callback", target="commandwest"}}}
cells["e"]=cell{item= {"it-trigger",{action="callback", target="commandnorth"}}}
cells["f"]=cell{item= {"it-trigger",{action="callback", target="commandeast"}}}
cells["g"]=cell{item= {"it-trigger",{action="callback", target="commandsouth"}}}
cells["+"]=cell{{{document, "Welcome to the control room. Use the triggers and switches to plan the movement of the turtle. The switches are, clockwise: Add, Run and Restart."}}}
cells["*"]=cell{parent=set_pad_center, actor={"ac-blackball", {player=0}}}
cells["~"]=cell{parent={cells["#"], set_magic_stone}}
cells["<"]=cell{stone={"st-bolder-w",  {name="bolder1"}}}
cells["t"]=cell{item= {"it-trigger", {action="callback", target="boldercommand"}}}
cells["0"]=oxyd

level = {
   "########0########0##",
   "#!!!!!#t      t   t#",
   "#!!!!!# t      t tt#",
   "#####a#t  t  t  #  #",
   "#    +# t  t    #  #",
   "#  e  ###t    t #  #",
   "# d*f   b<   t    t#",
   "#  g  ###t  t   #  #",
   "#     #t   t    #  #",
   "#####c# t    t  #  #",
   "#!!!!!#t       t tt#",
   "#!!!!!#t      t   t#",
   "######~#0########0##",
}


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- init

oxyd_default_flavor = "a"
set_default_parent(cells[" "])
create_world_by_map(level)

buftable [command_clean] = new_command(nil,  nil,  "st-grate1", NODIR)
buftable [command_north] = new_command(cent.x, cent.y-2, "st-bolder", NORTH)
buftable [command_south] = new_command(cent.x, cent.y+2, "st-bolder", SOUTH)
buftable [command_east]  = new_command(cent.x+2, cent.y, "st-bolder", EAST )
buftable [command_west]  = new_command(cent.x-2, cent.y, "st-bolder", WEST )

clearbuffer()
oxyd_shuffle()

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- enough :)
















