
-- andreas_ghosts, a lua-library for Enigma
-- Copyright (C) 2006 Andreas Lochmann
-- Licensed under GPL v2.0 or above
--
-- Version 1/3
--
--
-- What is this?
--
--  With a "ghost" I mean an actor that's moving along predefined
--  ways ("rails") with possibly random behavior when choosing which
--  rail to follow. In terms of Esprit, these actors have been called
--  "spermbirds". Too avoid further confusion with future additions
--  of these very special actors (they have own images) to Enigma,
--  I call my version of them "ghosts". Take a look at the level
--  "Pac Marble" (andreas22) to see them doing their job.
--
--
-- Usage:
--
--  You have to set up four different kinds of objects:
--
--    (1) the ghosts themselves,
--    (2) the rails, which define the allowed ways for the ghosts,
--    (3) the timer-stone,
--    (4) if you use a level editor, correct the slope force.
--
--  (1)  You can create a ghost via
--
--    ghosts_set_ghost(x,y,actor,rail,alg,attribs)
--
--  with x,y the position of the ghost, actor the type of actor
--  to be used (e.g. "ac-rotor" or "ac-blackball"), rail the number
--  of the rail the ghost might use, alg defining the algorithm to
--  be used (see below) and attribs a table of further attributes
--  for the actor. A typical example would be:
--
--    ghosts_set_ghost(12,13,"ac-top", 1, ghosts_direction_intelligent,
--                                     {range=0, force=5, gohome=FALSE})
--
--  You may use this as a parent for ant.lua, too:
--
--    actors["..."]=cell{parent={{ghosts_set_ghost,"ac-top",1,
--              ghosts_direction_intelligent,{range=0,force=5,gohome=FALSE}}}}
--
--  Remark 1: If you use a top or rotor, remember to set "gohome=FALSE",
--            otherwise the ghost will move unsteady or not at all.
--            Also reduce the range and/or force to sensible values.
--            If you use a marble, you should set "mouseforce=0".
--  Remark 2: Ghosts may not have arbitrary names! The name of a
--            ghost is determined as "ghost_X" with X the number of
--            the ghost, determined in the order of definition.
--  Remark 3: To each of the coordinates the value 0.5 will be added.
--            So, if you transform a set_actor-call, please subtract
--            0.5 from each coordinate.
--
--  (2)  Each ghost may move along paths, called rails. Several ghosts
--  may use the same rails, but each ghost only one rail; different
--  rails may cross. You can define a single floor tile as part of a
--  rail with
--
--    ghosts_set_rail(x,y,rail,floorkind)
--
--  with x,y the position of the floor, rail the rail-number that's
--  also used in the definition of the ghosts and floorkind the kind
--  of floor to be set at x,y. Instead of setting the floorkind with
--  ghosts_set_rail you can set it independently and use an empty
--  string '""' for floorkind, to suppress setting of a new floor.
--  You can use this as a parent for ant.lua, e.g.:
--
--    cells["..."]=cell{parent={{ghosts_set_rail,1,"fl-gray"}}}
--
--  To define a larger area as rail, you can use
--
--    ghosts_set_railarea(x1,y1,x2,y2,rail,floorkind)
--
--  which works analogously to ghosts_set_rail, with x1..x2, y1..y2
--  the rectangular area to be set as rail.
--
--  Remark 1: The movement of a ghost is done via flat gradients,
--            which alter the floor, while the old floor will be
--            reconstructed later. This might look strange when
--            another floor than "fl-metal" or "fl-gray" is used.
--  Remark 2: In the standard settings, rail-floors with walls on
--            them will be totally ignored as if they would not
--            belong to the rail at all. This way you can define
--            the whole area of a level as rail without having
--            to worry about walls, and the ghosts will ignore
--            movable stones instead of bump into them.
--            Yet, this behaviour can be unsatisfying, e.g. when
--            a ghost is expected to go through a grate, an open
--            door or a hollow stone. You can alter this by setting
--
--              ghosts_check_for_walls = 0
--
--            (or = 1 to switch it on again). Notice that a
--            ghost in this setting will bump into walls on its
--            way, which might look stupid. However, the ghost
--            will then reorient and search another way, so there
--            is no need to worry when switching this off.
--  Remark 3: Multiple rails have not been tested yet.
--            Keep lots of bug-spray in reach.
--
--  (3)  You have to set up a timer stone which calls the function
--  ghosts_timercallback in appropriate intervals (e.g. 0.1 seconds).
--  You can do this with the function
--
--    ghosts_init(x,y)
--
--  with a nice position x,y for the timer-stone.
--
--  (4)  The movements of the ghosts work via gradients and
--  thus need correctly set up slope forces. The library initially
--  sets it to 13, which works quite well. Editors like BlackBallEd
--  sometimes redefine this to other values. The code then needs
--  cleaning. You can also use
--
--    enigma.SlopeForce = ...
--
--  to slow the ghosts down or to speed them up. Bear in mind,
--  that too fast ghosts have problems in narrow labyrinths.
--  Yet, in an open area heightening the slope force can be
--  very sensible.
--
--
-- Moving algorithms:
--
--  In the current version of the library, there are four
--  algorithms that can be used in the definition of a ghost:
--
--           ghosts_direction_left : Always turn left at crossings
--          ghosts_direction_right : Always turn right at crossings
--         ghosts_direction_random : Choose ways randomly
--    ghosts_direction_intelligent : Choose rarely used ways
--
--  In the definition, you can also use "nil", then the
--  standard (ghosts_direction_intelligent) will be used.
--  But you might be interested to program an own algorithm
--  to decide the new directions by yourself. For this, you have
--  to define a function of the form
--
--    function my_own_algorithm(rail,posx,posy,oldx,oldy)
--
--  which takes the rail-number, the actual position and the old
--  position (which might be identical with the actual one). It
--  should return a single numerical value giving the direction:
--
--    0 : No possible direction found
--    1 : Go North (up)
--    2 : Go South (down)
--    3 : Go West (left)
--    4 : Go East (right)
--
--  Then define your ghost using this function:
--
--    ghosts_set_ghost(12,13,"ac-rotor", 1, my_own_algorithm,
--                               {range=0, force=5, gohome=FALSE})
--
--  Take a look at the four predefined functions to get a notion
--  of how to do this in a sensible way and which helper functions
--  you might find useful.
--
--
-- Global options:
--
--  There are four options that can be changed:
--
--  (a) ghosts_timerinterval  (default 0.1)
--        Defines the callback interval used by ghosts_init.
--  (b) ghosts_waiting_constant  (default 5)
--        When a ghost can't find a ways, it will repeat it after
--        this number of callback intervals. This number also is
--        used to give the ghost enough time to reach the next
--        adjacent floor tile before redefining its way.
--  (c) ghosts_check_for_walls  (default 1, set to 0 for false)
--        Sets whether ghosts shall ignore walls or not.
--        See section (2), remark 2 for a detailed description.
--  (d) ghosts_marker_i_max  (default 10000)
--        The intelligent direction algorithm uses counters to
--        count the number of times a floor tile has been visited.
--        To avoid an overflow of these counters, their maximum
--        is set to this constant, beyond which the intelligent
--        algorithm will turn into the random one. However, it's
--        improbable to reach this maximum during normal play.
--
--  For normal level-building purposes, only constant (c) should
--  be of interest.
--
--
-- Problem solving:
--
--  The ghost bumps into walls, moves unsteady, changes speed!
--
--    You probably forgot to set "gohome = FALSE".
--
--  The ghost bumps into walls, but moves with constant speed!
--
--    You probably switched ghosts_check_for_walls off, but didn't
--    remove the rail below static walls. The ghost thinks it can
--    go there, bumps into the wall and reorients -- very often.
--
--  The ghost doesn't move at all!
--
--    Have you set up the rail correctly, with the same rail number
--    as the ghost? 
--
--    Have you set "gohome = FALSE"? In combination with a high
--    force-value this might also make the ghosts stop completely.
--
--    Possibly you use a rotor or top as ghost with activated range
--    and force. It then is attracted by your marble; stronger than
--    its gradient. Decrease the force or even better the range of
--    the ghost or turn the range off completely.
--
--    Maybe you renamed the ghost afterwards? This won't work.
--    Please use the predefined name of the ghost.
--
--  The ghost moves too fast or too slow!
--
--    Correct the slope force, c.f. section (4).
--
--  The ghost doesn't react on gradients/space/ice I put into the level!
--
--    The ghosts set up their own gradients they are surfing on,
--    and restore the old floor later. Thus there is no way to
--    make them react on any other floor; sorry.
--
--  I use marbles as ghosts and they react on the mouse movements!
--
--    If you don't want it this way, put "mouseforce = 0" into
--    the attribs.
--
--  The ghost moves somewhat... strange?
--
--    There are many things that can act on the ghosts, like magnets,
--    electricity, wormholes, interactions with other ghosts or actors
--    or the different attraction algorithms of tops and rotors that
--    can be accessed via the attacknearest-option. All of these aren't
--    tested and may lead to unpredictable behaviour of the ghosts.
--    Sorry if this disturbs your level idea.
--



--------------------------------------
--  Global constants and variables  --
--------------------------------------


ghosts_timerinterval = 0.1
ghosts_waiting_constant = 5  -- corresponds to half a second
ghosts_check_for_walls = 1
ghosts_marker_i_max = 10000

enigma.SlopeForce = 13

ghosts_counter = 0
ghosts_rail = {}
ghosts_savedfloor = {}
ghosts_ghost_rail = {}
ghosts_ghost_x = {}
ghosts_ghost_y = {}
ghosts_waiting = {}
ghosts_possible = {}
ghosts_algorithm = {}
ghosts_marker_i = {}
ghosts_floor_x = {}
ghosts_floor_y = {}


-----------------------
--  Helper routines  --
-----------------------


function ghosts_index(rail,x,y)
  return tostring(rail)..";"..tostring(x)..";"..tostring(y)
end

function ghosts_adjacent(posx,posy,dir)
  if dir == 0 then  return posx, posy      end
  if dir == 1 then  return posx, posy - 1  end
  if dir == 2 then  return posx, posy + 1  end
  if dir == 3 then  return posx - 1, posy  end
  if dir == 4 then  return posx + 1, posy  end
end

function ghosts_load_possible_directions(rail,posx,posy)
  -- Test whether the four adjacent floors are allowed destinations
  local j
  for j=1,4 do
    if ghosts_rail[ghosts_index(rail,ghosts_adjacent(posx,posy,j))] == 1 then
      ghosts_possible[j] = 1
    else
      ghosts_possible[j] = 0
    end
    if ghosts_check_for_walls == 1 then
      if enigma.GetStone(ghosts_adjacent(posx,posy,j)) ~= nil then
        ghosts_possible[j] = 0
      end
    end
  end 
end

function ghosts_calculate_original_direction(posx,posy,oldx,oldy)
  local originaldirection = 0
  if (posx == oldx) and (posy == oldy - 1) then  originaldirection = 2  end
  if (posx == oldx) and (posy == oldy + 1) then  originaldirection = 1  end
  if (posy == oldy) and (posx == oldx - 1) then  originaldirection = 4  end
  if (posy == oldy) and (posx == oldx + 1) then  originaldirection = 3  end
  return originaldirection
end

function ghosts_turn_left(dir)
  local newdir = 0
  if dir == 1 then  newdir = 4  end
  if dir == 2 then  newdir = 3  end
  if dir == 3 then  newdir = 1  end
  if dir == 4 then  newdir = 2  end
  return newdir
end

function ghosts_turn_right(dir)
  local newdir = 0
  if dir == 1 then  newdir = 3  end
  if dir == 2 then  newdir = 4  end
  if dir == 3 then  newdir = 2  end
  if dir == 4 then  newdir = 1  end
  return newdir
end

function ghosts_increase_marker_i(rail,posx,posy)
  local gcount = ghosts_marker_i[ghosts_index(rail,posx,posy)]
  if gcount == nil then
    ghosts_marker_i[ghosts_index(rail,posx,posy)] = 1
  else
    if gcount < ghosts_marker_i_max then
      ghosts_marker_i[ghosts_index(rail,posx,posy)] = gcount + 1
    end
  end
end

function ghosts_floor_kind(actual, posx, posy, g)
  local kind = actual
  -- Is there any ghost who saved this floor apart from g?
  for j = 1,ghosts_counter do
    if (ghosts_floor_x[j] == posx) and (ghosts_floor_y[j] == posy) and (j ~= g) then
      kind = ghosts_savedfloor[j]
    end
  end
  if kind == nil then kind = actual end
  return kind
end

function ghosts_gradient(dir)
  --if dir == 1 then return "fl-gradient2" end
  --if dir == 2 then return "fl-gradient1" end
  --if dir == 3 then return "fl-gradient4" end
  --if dir == 4 then return "fl-gradient3" end
  return "fl-gradient"..tostring(dir+12)
end

---------------------------------
--  Several moving algorithms  --
---------------------------------

  -- 1 : Go North (up)
  -- 2 : Go South (down)
  -- 3 : Go West (left)
  -- 4 : Go East (right)

function ghosts_direction_left(rail,posx,posy,oldx,oldy)
  -- Calculate original direction (posx/posy -> oldx/oldy)
  local originaldirection = ghosts_calculate_original_direction(posx,posy,oldx,oldy)
  -- Load possible directions
  ghosts_load_possible_directions(rail,posx,posy)
  -- Are we still at the same position? Set origdir = random => dir = random
  if (posx == oldx) and (posy == oldy) then
    originaldirection = random(1,4)
  end
  -- Turn left till there is a possible way
  local dir = ghosts_turn_left(originaldirection)    
  local j
  for j = 1,3 do
    if ghosts_possible[dir] ~= 1 then
      dir = ghosts_turn_left(dir)
    end
  end
  -- Maybe there is no way out?
  if (dir == originaldirection) and (ghosts_possible[dir] ~= 1) then
    dir = 0
  end
  return dir
end

function ghosts_direction_right(rail,posx,posy,oldx,oldy)
  -- Calculate original direction (posx/posy -> oldx/oldy)
  local originaldirection = ghosts_calculate_original_direction(posx,posy,oldx,oldy)
  -- Load possible directions
  ghosts_load_possible_directions(rail,posx,posy)
  -- Are we still at the same position? -> dir = random
  if (posx == oldx) and (posy == oldy) then
    originaldirection = random(1,4)
  end
  -- Turn left till there is a possible way
  local dir = ghosts_turn_right(originaldirection)    
  local j
  for j = 1,3 do
    if ghosts_possible[dir] ~= 1 then
      dir = ghosts_turn_right(dir)
    end
  end
  -- Maybe there is no way out?
  if (dir == originaldirection) and (ghosts_possible[dir] ~= 1) then
    dir = 0
  end
  return dir
end

function ghosts_direction_random(rail,posx,posy,oldx,oldy)
  -- Calculate original direction (posx/posy -> oldx/oldy)
  local originaldirection = ghosts_calculate_original_direction(posx,posy,oldx,oldy)
  -- Load possible directions
  ghosts_load_possible_directions(rail,posx,posy)
  -- Choose one of them at random  
  local direction = 0
  local j
  for j=1,100 do
    -- Try to find a good direction 100 times, then give up.
    if direction == 0 then
      direction = random(1,4)
      if ghosts_possible[direction] ~= 1 then
        direction = 0
      end
      if direction == originaldirection then
        direction = 0
      end
    end
  end  
  return direction
end

function ghosts_direction_intelligent(rail,posx,posy,oldx,oldy)
  -- Calculate original direction (posx/posy -> oldx/oldy)
  local originaldirection = ghosts_calculate_original_direction(posx,posy,oldx,oldy)
  -- Load possible directions with counters
  ghosts_load_possible_directions(rail, posx, posy)
  -- Save the corresponding markers in ghosts_possible
  local j
  local m
  for j=1,4 do
    m = ghosts_marker_i[ghosts_index(rail,ghosts_adjacent(posx,posy,j))]
    if m == nil then
      ghosts_marker_i[ghosts_index(rail,ghosts_adjacent(posx,posy,j))] = 1
      m = 1
    end
    if ghosts_possible[j] > 0 then
      ghosts_possible[j] = m
    end
  end
  -- Remove directions with highest counters and original direction
  if originaldirection > 0 then
    ghosts_possible[originaldirection] = 0
  end
  local min = 0
  for j = 1,4 do
    if (min == 0) or ((min > ghosts_possible[j]) and (ghosts_possible[j] > 0))
      then min = ghosts_possible[j] end
  end
  for j = 1,4 do
    if min < ghosts_possible[j] then ghosts_possible[j] = 0 end
  end
  -- Choose one of the (hopefully) remaining directions at random  
  local direction = 0
  for j=1,100 do
    -- Like in the random algorithm:
    if direction == 0 then
      direction = random(1,4)
      if ghosts_possible[direction] == 0 then
        direction = 0
      end
      if direction == originaldirection then
        direction = 0
      end
    end
  end  
  return direction
end


-------------------------------
--  Timer callback function  --
-------------------------------


function ghosts_timercallback()
  if ghosts_counter > 0 then
    local g
    for g = 1, ghosts_counter do
      local myactor = enigma.GetNamedObject("ghost_"..tostring(g))
      if myactor ~= nil then
        local posx, posy = enigma.GetPos(myactor)
        local rail = ghosts_ghost_rail[g]
        local oldx = ghosts_ghost_x[g]
        local oldy = ghosts_ghost_y[g]

        -- Are we still at the same position?

        if (oldx == posx) and (oldy == posy) then
          -- Should we wait some more time?
          if ghosts_waiting[g] > 0 then
            -- Wait some more...
            ghosts_waiting[g] = ghosts_waiting[g] - 1
          end
          -- If we waited a too long time, increase the marker.
          -- We'll also delete the original direction now, but
          -- create a new gradient later.
          if ghosts_waiting[g] == 0 then
            ghosts_increase_marker_i(rail, posx, posy)
            ghosts_ghost_x[g] = posx
            ghosts_ghost_y[g] = posy
          end
        else
          -- Create a new gradient without further waiting!
          ghosts_waiting[g] = 0
          -- And increase the local counter.
          ghosts_increase_marker_i(rail, posx, posy)
        end

        -- Shall we restore the old floor?

        local oldfloorx = ghosts_floor_x[g]
        local oldfloory = ghosts_floor_y[g]
        if (oldfloorx ~= posx) or (oldfloory ~= posy) then
          -- Restore the old floor:
          if ghosts_savedfloor[g] == "" then
            ghosts_savedfloor[g] = "fl-normal"
          end
          -- Why not oldx/oldy? Because the actor could have
          -- been bumped onto another field - this would shuffle
          -- the floor-tiles!
          set_floor(ghosts_savedfloor[g], oldfloorx, oldfloory)
        end

        -- Should we create some gradient where we are?

        local dir = 0
        if ghosts_waiting[g] == 0 then
          -- Calculate new direction
          if ghosts_rail[ghosts_index(rail,posx,posy)] == nil then
            -- Oh, that's not good: the actor lost his way.
            -- Maybe we can get it back onto the rail where it came from?            
            if ghosts_rail[ghosts_index(rail,oldx,oldy)] ~= nil then
              dir = ghosts_calculate_original_direction(posx,posy,oldx,oldy)
            end
            if dir == 0 then
              -- Last chance!
              dir = ghosts_direction_random(rail,posx,posy,oldx,oldy)
            end
            if dir == 0 then
              -- No way back? Then just deactivate it:
              ghosts_waiting[g] = -1
            end            
          else
            dir = ghosts_algorithm[g](rail, posx, posy, oldx, oldy)
          end
          -- Any good idea? Then draw the gradient!
          if dir ~= 0 then
            local newfloor = ghosts_gradient(dir)
            if (posx ~= oldfloorx) or (posy ~= oldfloory) 
               or (ghosts_savedfloor[g] == "") then
              local myfloor = enigma.GetFloor(posx,posy)
              if myfloor ~= nil then
                -- Save the old floor kind.
                -- But take care: There might already be a ghost
                -- here, who changed the floor kind!
                ghosts_savedfloor[g] = ghosts_floor_kind(enigma.GetKind(myfloor),posx,posy,g)
                ghosts_floor_x[g] = posx
                ghosts_floor_y[g] = posy
              end
            end
            set_floor(newfloor,posx,posy)
            ghosts_ghost_x[g] = posx
            ghosts_ghost_y[g] = posy
            ghosts_waiting[g] = ghosts_waiting_constant
          else
            -- No direction? Propably a dead-end. Wait some time
            -- and forget where you came from.
            ghosts_ghost_x[g] = posx
            ghosts_ghost_y[g] = posy
            ghosts_waiting[g] = ghosts_waiting_constant
          end
        end

      end
    end
  end
end


-------------------------------------------------
--  Initialization, Setup and ant.lua-parents  --
-------------------------------------------------


function ghosts_init(x,y)
  set_stone("st-timer", x, y, {interval = ghosts_timerinterval,
     action = "callback", target = "ghosts_timercallback"})
end

function ghosts_set_ghost(x,y,actor,rail,alg,attribs)  -- Sets up a ghost
  if alg == nil then  alg = ghosts_direction_intelligent  end
  ghosts_counter = ghosts_counter + 1
  local n = "ghost_"..tostring(ghosts_counter)
  ghosts_ghost_rail[ghosts_counter] = rail
  ghosts_ghost_x[ghosts_counter] = x
  ghosts_ghost_y[ghosts_counter] = y
  ghosts_waiting[ghosts_counter] = 0
  ghosts_savedfloor[ghosts_counter] = ""
  ghosts_algorithm[ghosts_counter] = alg
  local newghost = set_actor(actor,x+0.5,y+0.5,{name=n})
  set_attribs(newghost,attribs)
  if GetAttrib(newghost,"name") ~= n then
    error("Ghosts may not have arbitrary names!")
  end
end

function ghosts_set_rail(x,y,rail,floorkind)  -- This is a parent for a ghost-rail
  if rail == "" then  rail = 0  end
  ghosts_rail[ghosts_index(rail,x,y)] = 1
  if floorkind ~= "" then
    set_floor(floorkind, x, y)
  end
end

function ghosts_set_railarea(x1,y1,x2,y2,rail,floorkind)
  local i,j
  for i=x1,x2 do
    for j=y1,y2 do
      ghosts_set_rail(i,j,rail,floorkind)
    end
  end
end






