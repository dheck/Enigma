-- A level library for Enigma
-- Filename:    ralf_pento1.lua
-- Copyright: 	(C) Dec 2004 Ralf Westram
-- Contact: 	amgine@reallysoft.de
-- License: 	GPL v2.0 or above

if dofile(enigma.FindDataFile("levels/ralf.lua")) == nil then error("can't load 'ralf.lua'"); end

flip = {}
mirrorx = {}
mirrory = {}
rot = {}

for x=0,4 do
   for y=0,4 do
      local i = y*5+x
      flip[i] = x*5+y
      rot[i] = x*5+(4-y)
      mirrorx[i] = y*5+(4-x)
      mirrory[i] = (4-y)*5+x
   end
end

oxydpos={}
oxydc=0
area={}
areac=0
areaminx = 100
areaminy = 100
field={}
fieldc=0

function picked_up(name)
   local item = enigma.GetNamedObject(name)
   if (item) then
      local x,y = enigma.GetPos(item);
      local itemthere = enigma.GetItem(x,y)
      if (itemthere==nil) then
         return 1
      end
   end
   return 0
end

function dumpstate(state,where)
   if (state==nil) then error("state==nil") end
   local s = ""
   for i=0,24 do
      if (state[i]==1) then
         s = s..'1';
      else
         s = s..'0';
      end
   end
   print(where.." '"..s.."'");
end

function weight(state)
   local w = 0
   local j = 1
   for i=0,24 do
      if (state[i]==1) then w = w+j end
      j = j+j
   end
   return w
end

function getstate()
   local state = {}
   local i
   for i=0,24 do
      local pos = area[i]
      local st = enigma.GetStone(pos.x,pos.y);
      if (st == nil) then state[i] = 0 else state[i] = 1 end
   end
   return state;
end

function buildstate(stateid)
   local state = {}
   local j = 1   
   local i
   for i=0,24 do j=j+j end
   for i=0,24 do
      j = floor(j/2)
      if stateid >= j then
         state[i] = 1
         stateid = stateid-j
      else
         state[i] = 0
      end
   end
   --dumpstate(state,"buildstate")
   return state
end

function statesEqual(s1,s2)
   if ((s1 == nil) or (s2 == nil)) then
      if (s1 == s2) then return 1 end
      return 0
   end
   for i=0,24 do
      if (s1[i]~=s2[i]) then return 0 end
   end
   return 1
end

function upleftstate(state)
   local i=0
   while (state[i]==0) do i = i+1 end
   local up = floor(i/5);
   i=0
   while (state[flip[i]]==0) do i = i+1 end
   local left = floor(i/5);
   return up,left
end

function shiftstate(state,shift)
   if (shift==0) then
      return state
   end
   local newstate = {}
   local i = shift
   local j=0
   while (i<25) do
      newstate[j] = state[i]
      j=j+1
      i=i+1
   end
   while (j<25) do
      newstate[j] = 0
      j=j+1
   end
   if (newstate==nil) then error("newstate==nil") end
   return newstate
end

function shiftedstate(state)
   local up,left = upleftstate(state)
   local shift = up*5+left
   return shiftstate(state,shift)
end

bit27 = 2^27
bit13 = 2^13

function centeredstate(state)
   state = reversestate(shiftedstate(reversestate(state),0))
   local beststate = nil
   local bestdiff = bit27
   local up,left = upleftstate(state)

   up,left = floor(up/2) , floor(left/2)

   return shiftstate(state,up*5+left)
end

function reversestate(state)
   for i=0,12 do
      local j = 24-i
      state[i],state[j] = state[j],state[i]
   end
   return state
end
function mirrorxstate(state)
   local newstate = {}
   for i=0,24 do
      newstate[mirrorx[i]] = state[i]
   end
   return newstate
end
function mirrorystate(state)
   local newstate = {}
   for i=0,24 do
      newstate[mirrory[i]] = state[i]
   end
   return newstate
end
function rotstate(state)
   local newstate = {}
   for i=0,24 do
      newstate[rot[i]] = state[i]
   end
   return newstate
end

function simplestmirror(s)
   local w  = weight(s)
   local s1 = shiftedstate(mirrorxstate(s))
   local w1 = weight(s1)
   local s2 = shiftedstate(mirrorystate(s))
   local w2 = weight(s2)
   local s3 = shiftedstate(mirrorystate(s1))
   local w3 = weight(s3)
   if (w1<w) then w = w1 s = s1 end
   if (w2<w) then w = w2 s = s2 end      
   if (w3<w) then w = w3 s = s3 end      
   return w,s
end

function simplifystate(s)
   local w1,s1 = simplestmirror(shiftedstate(s));
   local w2,s2 = simplestmirror(shiftedstate(rotstate(s1)));
   if (w1<w2) then
      return s1
   end
   return s2
end

function setrealoxyds()
   for i=0,11 do
      local pos = oxydpos[i]
      kill_stone(pos.x,pos.y)
      oxyd(pos.x,pos.y)
   end
   oxyd_shuffle()
end
function oxydlater(x,y)
   set_stone(wallstone,x,y);
   oxydpos[oxydc] = { x=x, y=y }
   oxydc = oxydc+1
end
function storearea(x,y)
   area[areac] = { x=x, y=y }
   if (x<areaminx) then areaminx = x end
   if (y<areaminy) then areaminy = y end
   areac = areac+1
end
function storefield(x,y)
   field[fieldc] = { x=x, y=y }
   fieldc = fieldc+1
end

thorspos = {}
function sethammer(x,y)
   local h = set_item("it-hammer",x,y)
   enigma.NameObject(h,"thors")
   thorspos = { x=x, y=y }
end

function pentocells(doctext)
   local cells = {}
   
   local allowed_to_play = 0
   if (enigma.IsSolved("ralf_pento1")) then
      allowed_to_play = 1
   end

   cells["!"] = cell{floor="fl-space"}
   cells[" "] = cell{floor=normalfloor}
   cells["@"] = cell{floor=normalfloor,parent={storefield}}
   cells["R"] = cell{floor=rotfloor,parent={storearea}}
   cells["#"] = cell{parent=cells[" "],stone=wallstone}
   cells["a"] = cell{parent=cells[" "],actor={"ac-blackball", {player=0}}}
   cells["o"] = cell{parent={oxydlater}}

   if (allowed_to_play==1) then
      cells["d"] = cell{parent=cells[" "],item={"it-document", {text=doctext,name="doc"}}}
      cells["1"] = cell{parent=cells[" "],stone={"st-switch",{action="callback",target="sw_spawn",name="soundhere"}}}
      cells["2"] = cell{parent=cells[" "],stone={"st-switch",{action="callback",target="sw_rot"}}}
      cells["3"] = cell{parent=cells[" "],stone={"st-switch",{action="callback",target="sw_kill"}}}
      cells["H"] = cell{floor=normalfloor,parent={sethammer}}
      cells["T"] = cell{parent=cells[" "],stone={face="st-timer",attr={action="callback", target="tick",interval=1.0}}}
   else
      cells["d"] = cell{parent=cells[" "],item={"it-document", {text="You have to solve 'Pentomino I' before you are allowed to play here."}}}
      cells["1"] = cells["#"]
      cells["2"] = cells["#"]
      cells["3"] = cells["#"]
      cells["H"] = cells["#"]
      cells["T"] = cells["#"]
   end
   cells["S"] = cell{floor="fl-samba", parent={setsoundstone}}

   return cells
end

pento_id = {
   31,47,79,103,
   110,167,1063,1126,
   1249,1250,1252,2274
}

soundstone = nil
function setsoundstone(x,y)
   set_stone(wallstone,x,y,{name="soundstone"})
   soundstone=enigma.GetNamedObject("soundstone");
end
function do_sound(sound)
   enigma.EmitSound(soundstone,sound);
end

spawned={} -- key = pento_id; val=0/1
unspawned={} -- val = pento_id-index 
for i=1,12 do
   unspawned[i]=i
   spawned[pento_id[i]]=0
end

function dumpspawned()
   local n = getn(unspawned)
   local u = ""
   local ui = ""
   for i=1,n do
      ui = ui..unspawned[i].." "
      u = u..pento_id[unspawned[i]].." "
   end
   --print("unspawned:           "..ui)
   --print("pento_id[unspawned]: "..u)
end

function spawnstate(state,id)
   local i
   local puzzlestone={}
   for i=0,24 do
      if (state[i]==1) then
         local pos = area[i];
         add_multicell(pos.x,pos.y,puzzlestone)
      end
   end
   render_puzzles(puzzlestone)
   for i=0,24 do
      if (state[i]==1) then
         local pos = area[i];
         local st = enigma.GetStone(pos.x,pos.y)
         set_attrib(st, "pento", "p"..id)
      end
   end
end
function unspawnstate(state)
   for i=0,24 do
      if (state[i]==1) then
         local pos = area[i]
         kill_stone(pos.x,pos.y)
      end
   end
end


function spawn()
   local n=getn(unspawned)
   if (n==0) then
      do_sound("fart")
      return 0
   end

   local i=random(1,n)
   local stateid=pento_id[unspawned[i]]

   if spawned[stateid]==1 then
      error("ID "..stateid.." already spawned")
   end

   spawned[stateid] = 1
   tremove(unspawned,i)

   local state = buildstate(stateid)
   if (random(2)==1) then state = rotstate(state) end
   if (random(2)==1) then state = mirrorxstate(state) end
   if (random(2)==1) then state = mirrorystate(state) end

   spawnstate(centeredstate(state),stateid)
   return 1
end

function unspawn_stateid(stateid)
   local ididx = -1
   for i=1,12 do if pento_id[i] == stateid then ididx = i end end
   if (ididx==-1) then
      error("could not find stateid="..stateid)
   end

   local n = getn(unspawned)
   tinsert(unspawned,ididx)
   spawned[stateid] = 0
end

function unspawn(state,stateid)
   unspawnstate(state)
   unspawn_stateid(stateid)
end


function sw_spawn()
   local state = getstate()
   local w = weight(state)
   if (w == 0) then
      spawn()
   else
      local simple = simplifystate(state)
      local ws = weight(simple)
      if (spawned[ws]==1) then
         unspawn(state,ws)
         spawn()
         do_sound("stonetransform")
      else
         do_sound("fart")
      end
   end
end

function sw_rot()
   local state = getstate()
   local w = weight(state)
   if (w>0) then
      local simple = simplifystate(state)
      local ws = weight(simple)
      if (spawned[ws]==1) then
         unspawnstate(state)
         local retry = 5
         local unwanted = weight(shiftedstate(state))
         while (retry>0) do
            retry=retry-1
            local r = random(3)
            if (r==1) then state = mirrorxstate(state)
            elseif (r==2) then state = mirrorystate(state)
            else state = rotstate(state)
            end
            state=shiftedstate(state)
            if (weight(state)~=unwanted) then
               retry=0
            end
         end
         spawnstate(centeredstate(state),ws)
         do_sound("stonetransform")
      else
         do_sound("fart")
      end
   end
end

function hammer(x,y)
   local st = enigma.GetStone(x,y)
   if ((st ~= nil) and (enigma.GetKind(st)=="st-puzzle")) then
      local name = get_attrib(st,"pento")
      if ((name ~= nil) and (strsub(name,1,1)=="p")) then
         local id = tonumber(strsub(name,2))
         if (id ~= nil) then
            unspawn_stateid(id)

            local xmin,ymin = x-5,y-5
            local xmax,ymax = x+5,y+5

            if (xmin<0) then xmin = 0 end
            if (ymin<0) then ymin = 0 end
            if (xmax>=worldw) then xmax = worldw end
            if (ymax>=worldh) then ymax = worldh end

            for x=xmin,xmax do
               for y=ymin,ymax do
                  st = enigma.GetStone(x,y)
                  if ((st ~= nil) and (enigma.GetKind(st)=="st-puzzle")) then
                     local name2 = get_attrib(st,"pento")
                     if (name2==name) then
                        kill_stone(x,y)
                        set_item("it-explosion1",x,y)
                     end
                  end
               end
            end
            return 1
         end
      end
   end
   return 0
end

function sw_kill()
   if (picked_up("thors")==1) then
      local it = enigma.GetItem(thorspos.x,thorspos.y)
      if (it==nil) then
         document(thorspos.x,thorspos.y,"Drop the hammer!")
      end
   else
      local x,y = enigma.GetPos(enigma.GetNamedObject("thors"))
      local count = hammer(x-1,y)
      count = count + hammer(x+1,y)
      count = count + hammer(x,y-1)
      count = count + hammer(x,y+1)
      if (count>0) then
         do_sound("whitebomb")
      end
   end
end

oxydsset=0
areaset=0

function tick()
   if (areaset==0 and picked_up("doc")==1) then
      for i=0,59 do
         local pos = field[i]
         set_floor(areafloor,pos.x,pos.y)
      end
      areaset=1
   end
   if (oxydsset==0 and getn(unspawned)==0) then
      local i
      for i=0,59 do
         local pos = field[i]
         local st = enigma.GetStone(pos.x,pos.y)
         if (st==nil) then return end
      end
      setrealoxyds();
      oxydsset=1
   end
end

function early_check()
   if (oxydc~=12) then error("expected to have 12 oxyds") end
   if (fieldc~=60) then error("expected to have 60 greens") end
end

