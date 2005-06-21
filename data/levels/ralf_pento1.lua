-- A level for Enigma
-- Name:        Pentomino I
-- Filename:    ralf_pento1.lua
-- Copyright: 	(C) Dec 2004 Ralf Westram
-- Contact: 	amgine@reallysoft.de
-- License: 	GPL v2.0 or above

if dofile(enigma.FindDataFile("levels/ralf_pento.lua")) == nil then error("can't load 'ralf_pento.lua'"); end

level={
   "###o###o####o###o###",
   "#                  #",
   "#                  #",
   "#          ggggggg #",
   "o  @@@@@   gGGGGGg o",
   "#  @@@@@   gGGGGGg #",
   "T  @@a@@   gGGGGGgdS",
   "#  @@@@@   gGGGGGg #",
   "o  @@@@@   gGGGGGg o",
   "#          ggggggg #",
   "#                  #",
   "#                  #",
   "###o###o####o###o###",
}

areafloor="fl-leaves"
normalfloor="fl-samba"
wallstone="st-blue-sand"

glassfloor="fl-bluegreen"
glassstone="st-glass"

glass={}
glassc=0

function setglass(x,y)
   glass[glassc] = { x=x, y=y }
   glassc = glassc+1
   set_stone(glassstone,x,y)
end

cells={}
cells["!"] = cell{floor="fl-space"}
cells[" "] = cell{floor=normalfloor}
cells["@"] = cell{floor=areafloor, parent={storearea}}
cells["#"] = cell{parent=cells[" "],stone=wallstone}
cells["a"] = cell{parent=cells["@"],actor={"ac-blackball", {player=0}}}
cells["o"] = cell{parent={oxydlater}}
cells["d"] = cell{parent=cells[" "],item={"it-document", {text="Five form twelve!",name="doc"}}}
cells["T"] = cell{parent=cells[" "],stone={face="st-timer",attr={action="callback", target="tick1",interval=0.25}}}
cells["G"] = cell{floor=glassfloor,parent={setglass}}
cells["g"] = cell{floor=normalfloor,stone="st-glass"}
cells["S"] = cell{floor="fl-samba", parent={setsoundstone}}

rs_create_world(level,cells)
enigma.ConserveLevel=FALSE

known = {}
seen = {}

for i=1,12 do
   known[pento_id[i]] = 1
end

pento_state=0
-- 0 = docwait
-- 1 = shift phase
-- 2 = fall phase

boxes=0

function xy2area(x,y)
   x = x-areaminx
   y = y-areaminy
   if (x<0 or x>4) then return -1 end
   if (y<0 or y>4) then return -1 end
   return y*5+x
end

function boxpos(i)
   local x,y = enigma.GetPos(enigma.GetNamedObject("box"..i));
   return xy2area(x,y);
end

--function getstate()
--   local state = {}
--   local i
--   for i=0,24 do state[i] = 0 end
--   for i=1,5 do
--      local ai = boxpos(i);
--      if (ai>=0) then state[ai] = 1 end
--   end
   
--   --dumpstate(state,"getstate");
--   return state;
--end

state_shown = nil
function showstate(state,mode)
   local i
   local puzzlestone = {}
   for i=0,24 do
      if (state[i]==1) then
         local pos = glass[i];
         kill_stone(pos.x,pos.y);
         if (mode==0) then
            set_stone("st-glass",pos.x,pos.y)
         else
            add_multicell(pos.x,pos.y,puzzlestone);
         end
      end
   end
   if (mode==1) then
      render_puzzles(puzzlestone)
   elseif (mode==2) then
      render_puzzles(puzzlestone,puzzle2)
   end
   state_shown = state
end
function wipestate()
   if (state_shown) then
      showstate(state_shown, 0);
      state_shown=nil
   end
end
function refreshstate(state,repeated,sound)
   wipestate()
   local mode = {1,2}
   showstate(state,mode[repeated+1])
   do_sound(sound);
end

function seedsat(poss)
   local sz = getn(poss)
   local i
   for i=1,sz do
      local pos = area[poss[i]]
      set_stone("st-wood-growing",pos.x, pos.y,{name="box"..i})
      boxes = boxes+1
   end
end

function seedem()
   boxes=0
   seedsat({1,7,13,17,21});
end

dropboxes=0
dropbox={}

function putfloors(fl)
   if (dropboxes==0) then
      for b=1,5 do
         local bx = enigma.GetNamedObject("box"..b)
         local x,y = enigma.GetPos(bx)
         set_floor(fl,x,y)
         --SendMessage(bx,"fall")
         dropbox[b] = { x=x, y=y }
      end
      dropboxes=5
   else
      for b=1,5 do
         local pos = dropbox[b]
         set_floor(fl,pos.x,pos.y);
      end
   end
end

function showfakeoxyd(w)
   local i=1
   while (pento_id[i]~=w) do i=i+1 end
   local pos = oxydpos[i-1]
   if (pos==nil) then
      print("w="..w.." i="..i)
   end
   kill_stone(pos.x,pos.y)
   set_stone("st-fakeoxyd",pos.x,pos.y)
end

function showstate4oxyd()
   local wantedstate = -1
   for i=0,11 do
      local pos = oxydpos[i]
      local ox = enigma.GetStone(pos.x,pos.y)
      if (ox==nil) then error("expected stone at "..pos.x.."/"..pos.y) end
      local kind = enigma.GetKind(ox,"kind")
      if (kind=="st-fakeoxyd") then
         local blinking = get_attrib(ox,"blinking")
         if (blinking>0) then
            wantedstate = i
         end
      elseif (kind=="st-oxyd") then
         print("stone at "..pos.x.."/"..pos.y.." is "..kind);
      end
   end

   if (wantedstate>=0) then
      local id = pento_id[wantedstate+1]
      local state = buildstate(id)
      if ((state_shown==nil) or (statesEqual(seen[id],state_shown)==0)) then
         refreshstate(seen[id],0,"stonetransform")         
      end
   end
end

laststate=nil
got=0

function tick1()
   --if (pento_state~=1) then
      --print("pento_state="..pento_state)
   --end
   if (pento_state==0) then
      if (picked_up("doc")==1) then
         seedem()
         pento_state = pento_state+1
      end
   elseif (pento_state==1) then
      local s = getstate()
      if (statesEqual(s,laststate)==0) then
         laststate=s
         local s1 = simplifystate(s)
         local w = weight(s1)
         if (known[w]==1) then
            if (seen[w]==nil) then
               s = centeredstate(s)
               refreshstate(s, 0,"stonetransform")
               seen[w] = s
               showfakeoxyd(w)
               got = got+1
               if (got==12) then
                  setrealoxyds();
                  do_sound("oxydopened");
                  pento_state=10
               end
            else
               refreshstate(seen[w], 1, "fart")
            end
            pento_state = pento_state+1
         end
      else
         showstate4oxyd()
      end
   elseif (pento_state==2) then
      putfloors("fl-abyss")
      pento_state = pento_state+1
   elseif (pento_state<6) then
      pento_state = pento_state+1
   elseif (pento_state==6) then
      putfloors(areafloor);
      dropboxes=0
      pento_state = pento_state+1
   elseif (pento_state<9) then
      pento_state = pento_state+1
   elseif (pento_state==9) then
      seedem();
      pento_state = 1
   else
      -- wait for user to finish level
      showstate4oxyd()
   end
end

