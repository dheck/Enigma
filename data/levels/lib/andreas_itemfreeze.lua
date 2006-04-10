
-- andreas_itemfreeze, a lua-library for Enigma
-- Copyright (C) 2006 Andreas Lochmann
-- Licensed under GPL v2.0 or above
--
-- Version 1/2
--
-- Usage:
--
--  Set an st-itemfreeze only via
--      set_itemfreeze(x, y)
--  never via set_stone! There is no real "st-itemfreeze" defined!
--  Instead, when using ant.lua, you can use the following parent:
--      stones["..."] = cell{parent={{parent_itemfreeze, "it-to-freeze"}}}
--  with "it-to-freeze" being the item to freeze into the stone.
--  For an empty itemfreezer, just use
--      stones["..."] = cell{parent={{parent_itemfreeze, ""}}}
--  Don't forget the empty quotation marks here! 
--  You can also put the item to freeze into the st-itemfreeze 
--  before or after the st-itemfreeze, you don't have to use
--  the first parent. The item will be frozen properly, as soon
--  as the st-itemfreeze is moved.
--
--  In addition, always put
--      itemfreeze_init(x,y,0.01)
--  somewhere into your code. It puts the necessary st-timer
--  to position (x,y) (choose as you like). The timer-interval
--  should be 0.01 or not much more. Alternatively, you can put
--  the timerstone yourself, the callback-function is called
--  "itemfreeze_timer_callback".
--
--
-- What does an itemfreeze-stone do?
--
--  When pushed over most item, this item gets "frozen" into
--  the stone and further moves with it. Thus, you can "push"
--  frozen items, like mail-pipes or bombs.
--
--  You can free a frozen item in three ways: Shatter the item-
--  freeze-stone with a nearby explosion (e.g. bombs, dynamite,
--  puller items, laser-destroyable items like umbrellas), 
--  melt it with fire (this will result in fl-water and the
--  frozen item might start burning), or push the itemfreeze-
--  stone over the defreezer-item (momentarily, this is it-pin).
--  This way the frozen item will come free and it-pin will
--  be frozen.
--  
--  Non-freezable items are it-laserbeam, it-explosion1, 2 and 3,
--  it-debris, it-burnable (!), it-burnable_ignited, and
--  it-burnable_burning. Freezable items in particular include
--  it-smashed, it-springboard, it-abyss (!), it-burnable_ash and
--  it-burnable_fireproof, so you can take a little bit of
--  it-burnable_fireproof to another location or contaminate
--  your itemfreezer with some unusable ash or it-smashed.
--
--  The itemfreeze-stone stems from st-glass_move, so it is
--  transparent for lasers. Frozen items might be changed or
--  ignited by lasers. But the stones are not passable via
--  it-cherry, because they base upon st-glass_move and not
--  st-glass.
--
--  When pushed over a burning dynamite, the dynamite will stop
--  burning. It will start again to burn, when you push the
--  frozen dynamite into a laser beam, but stop again, when you
--  push it again. This behaviour might be changed in future
--  versions. However, you can use a frozen dynamite to block
--  a laser beam for a short time, as the hollow from the dynamite
--  will be removed automatically (you can turn this feature off).
--  You can also use this to break a line of burning dynamites
--  before they ignite something more dangerous.
--
--  This technique doesn't work with it-blackbomb, as they explode
--  instantly when any stone is pushed over them. In oxyd1-compa-
--  tibility-mode, this is true for the st-itemfreeze, but not
--  for st-wood. Note that in standard-mode, a shogun-stone doesn't
--  ignite a bomb either, but this behaviour might be changed in
--  future versions of Enigma.
--
--  A third usage for the itemfreeze-stone is the following:
--  When pushed over water, it "freezes" the water and leaves a
--  line of ice behind it. In a similar way, a shattered item-
--  freeze-stone makes the adjacent floortiles to ice, except
--  for fl-abyss, which keeps to be abyss. So in contrast to
--  st-wood you can use it to create ways over water, but not
--  over abyss. And you can use them to distribute ice over
--  a level to make it more difficult while at the same time
--  freeing some way.
--
--  When an itemfreeze-stone is adjacent to fire, it will soon
--  melt and leave fl-water. It also removes any it-burnable,
--  it-burnable_ignited and it-burnable_burning below it. So it
--  might be used to block fire, even on a floor full of
--  it-burnable.
--
--
-- Options:
--
--  During the game, you can change the following variables
--  to further control the way the itemfreeze-stones are handled:
--
--  itemfreeze_option:  (default 5)
--    Handles what happens when a filled st-itemfreeze is
--    pushed over a second item
--    1 : Simply forget the new item.
--    2 : Simply forget the old item, freeze the new one.
--    3 : Switch positions.
--    4 : Free the old item, freeze the new one.
--    5 : Save the new item internally and overrun it without freezing it.
--    When the item "itemfreeze_defreezing_item" is overrun,
--    and option 5 is activated, then option 4 is used instead.
--
--  itemfreeze_test_for_explosion:  (default 1)
--  itemfreeze_test_for_fire:  (default 0)
--  itemfreeze_test_for_existence:  (default 0)
--    Set to one/zero to activate/deactivate checking for explosions
--    respectively fire. Deactivation might heighten the performance.
--    If your st-itemfreeze might disappear in another way than
--    melting or shattering (e.g. by it-seed), you should activate
--    itemfreeze_test_for_existence to avoid crashs, but this again
--    might result in a worse performance.
--
--  itemfreeze_melt_on_damage:  (default 20)
--    If fire is detected near st-itemfreeze, it increases
--    a damage-counter for this stone. If the counter equals
--    or exceeds itemfreeze_melt_on_damage, the stone melts.
--    So you can change the speed of melting by changing this
--    option. Note: Fire inside an st-itemfreeze melts it at once.
--
--  itemfreeze_remove_hollow:  (default 1)
--    If an explosion type 2 happens inside an st-itemfreeze,
--    it doesn't leave an it-hollow behind. This way, a freezed
--    dynamite can be used to block a laser for a short time.
--    But it isn't consequent relative to the normal behaviour,
--    so you might want to deactivate this feature by setting
--    itemfreeze_remove_hollow to zero.
--
--
-- Further comments:
--
--  To heighten performance, only every 5th cycle is checked for
--  explosions or fire. You can change this via itemfreeze_fire_interval.
--


--------------------------------------
--  Global variables and constants  --
--------------------------------------


-- direct options --

itemfreeze_option = 5
itemfreeze_test_for_explosion = 1
itemfreeze_test_for_fire = 0
itemfreeze_test_for_existence = 0
itemfreeze_melt_on_damage = 20
itemfreeze_remove_hollow = 1

-- shouldn't-be-changed-options --

itemfreeze_parentstone = "st-glass_move"
itemfreeze_parentfloor = "fl-ice"
itemfreeze_meltingfloor = "fl-water"
itemfreeze_defreezing_item = "it-pin"   -- e.g. "it-coffee", "it-spoon"
itemfreeze_fire_interval = 5

-- global variables --

itemfreeze_totalnumber = 0
itemfreeze_fire_countdown = 0

-- itemfreeze-tables --

itemfreeze_pos_x = {}
itemfreeze_pos_y = {}
itemfreeze_stone = {}
itemfreeze_itemkind = {}
itemfreeze_saveditem_kind = {}
itemfreeze_saveditem_pos_x = {}
itemfreeze_saveditem_pos_y = {}
itemfreeze_savedfloor = {}
itemfreeze_destroyed = {}
itemfreeze_damaged = {}


---------------------------------------------------
--  Destructive functions (shattering, melting)  --
---------------------------------------------------


function itemfreeze_remove_burnables(pos_x, pos_y)
  local myitem = enigma.GetItem(pos_x, pos_y)
  if myitem ~= nil then
    local kind = enigma.GetKind(myitem)
    if (kind == "it-burnable") or (kind == "it-burnable_ignited") 
             or (kind == "it-burnable_burning") then
      kill_item(pos_x, pos_y)
    end
  end
end

function itemfreeze_shatter_ice(pos_x, pos_y)
  local myfloor = enigma.GetFloor(pos_x, pos_y)
  if myfloor ~= nil then
    local kind = enigma.GetKind(myfloor)
    if (kind ~= "fl-abyss") then   -- and (kind ~= "fl-water") then
      set_floor(itemfreeze_parentfloor, pos_x, pos_y)
    end
  end
  itemfreeze_remove_burnables(pos_x, pos_y)
end

function itemfreeze_shatter(j)
  if itemfreeze_destroyed[j] == 0 then
    itemfreeze_destroyed[j] = 1
    local pos_x = itemfreeze_pos_x[j]
    local pos_y = itemfreeze_pos_y[j]
    local mystone = enigma.GetNamedObject("st-itemfreeze_"..tostring(j))
    if mystone ~= nil then
      enigma.EmitSound(mystone, "whitebomb")
      kill_stone(pos_x, pos_y)
    end
    if itemfreeze_savedfloor[j] ~= "" then
      set_floor(itemfreeze_savedfloor[j], pos_x, pos_y)
    end
    itemfreeze_shatter_ice(pos_x + 1, pos_y)
    itemfreeze_shatter_ice(pos_x - 1, pos_y)
    itemfreeze_shatter_ice(pos_x, pos_y + 1)
    itemfreeze_shatter_ice(pos_x, pos_y - 1)
    itemfreeze_shatter_ice(pos_x, pos_y)
    -- Maybe remove it-hollow or it-explosion2
    -- With this little hack we can use a freezed dynamite
    -- to block the laser for a short period of time:
    if itemfreeze_remove_hollow == 1 then
      local myitem = enigma.GetItem(pos_x, pos_y)
      if myitem ~= nil then
        local kind = enigma.GetKind(myitem)
        if (kind == "it-hollow") or (kind == "it-tinyhollow") then
          kill_item(pos_x, pos_y)
        end
        if (kind == "it-explosion2") then
          set_item("it-explosion1", pos_x, pos_y)
        end
      end
    end
  end
end

function itemfreeze_melt(j, damage)
  if itemfreeze_destroyed[j] == 0 then
    if damage == nil then
      damage = itemfreeze_melt_on_damage
    end
    itemfreeze_damaged[j] = itemfreeze_damaged[j] + damage
    if itemfreeze_damaged[j] >= itemfreeze_melt_on_damage then
      itemfreeze_destroyed[j] = 1
      --if itemfreeze_stone[j] ~= nil then
      --  enigma.EmitSound(itemfreeze_stone[j], "")
      --end
      local pos_x = itemfreeze_pos_x[j]
      local pos_y = itemfreeze_pos_y[j]
      kill_stone(pos_x, pos_y)
      if itemfreeze_savedfloor[j] ~= "" then
        set_floor(itemfreeze_savedfloor[j], pos_x, pos_y)
      end
      local myfloor = enigma.GetFloor(pos_x, pos_y)
      if myfloor ~= nil then
        local kind = enigma.GetKind(myfloor)
        if kind ~= "fl-abyss" then
          set_floor(itemfreeze_meltingfloor, pos_x, pos_y)
        end
      end
      itemfreeze_remove_burnables(pos_x, pos_y)
    end
  end
end


------------------------------------------------------------------
--  Timer callback and subfunctions, the heart of this library  --
------------------------------------------------------------------


function itemfreeze_look_for_item(j, old_x, old_y)
  local olditem = enigma.GetItem(old_x, old_y)
  local oldkind = ""
  if olditem ~= nil  then  oldkind = enigma.GetKind(olditem)  end
  local newitem = enigma.GetItem(itemfreeze_pos_x[j], itemfreeze_pos_y[j])
  local newkind = ""
  if newitem ~= nil  then  newkind = enigma.GetKind(newitem)  end
  local mykind = itemfreeze_itemkind[j]
  local explosion = 0
  -- First, replace some itemkinds if necessary:
  if oldkind == "it-laserbeam"          then  oldkind = ""                   end
  if oldkind == "it-explosion1"         then  oldkind = ""   explosion = 1   end
  if oldkind == "it-explosion2"         then  oldkind = ""   explosion = 2   end
  if oldkind == "it-explosion3"         then  oldkind = ""   explosion = 3   end
  if oldkind == "it-debris"             then  oldkind = ""   explosion = -1  end
  if oldkind == "it-dynamite_burning"   then  oldkind = "it-dynamite"        end
  if oldkind == "it-blackbomb_burning"  then  oldkind = "it-blackbomb"       end
  if oldkind == "it-dynamite-burning"   then  oldkind = "it-dynamite"        end
  if oldkind == "it-blackbomb-burning"  then  oldkind = "it-blackbomb"       end
  if oldkind == "it-burnable"           then  oldkind = ""                   end
  if oldkind == "it-burnable_ignited"   then  oldkind = ""   explosion = -2  end
  if oldkind == "it-burnable_burning"   then  oldkind = ""   explosion = -2  end
  -- And again for the other item:
  if newkind == "it-laserbeam"          then  newkind = ""                   end
  if newkind == "it-explosion1"         then  newkind = ""   explosion = 1   end
  if newkind == "it-explosion2"         then  newkind = ""   explosion = 2   end
  if newkind == "it-explosion3"         then  newkind = ""   explosion = 3   end
  if newkind == "it-debris"             then  newkind = ""   explosion = -1  end
  if newkind == "it-dynamite_burning"   then  newkind = "it-dynamite"        end
  if newkind == "it-blackbomb_burning"  then  newkind = "it-blackbomb"       end
  if newkind == "it-dynamite-burning"   then  newkind = "it-dynamite"        end
  if newkind == "it-blackbomb-burning"  then  newkind = "it-blackbomb"       end
  if newkind == "it-burnable"           then  newkind = ""                   end
  if newkind == "it-burnable_ignited"   then  newkind = ""   explosion = -2  end
  if newkind == "it-burnable_burning"   then  newkind = ""   explosion = -2  end
  -- Now test whether the saved item kind has changed:
  if mykind ~= oldkind then
    -- the actual one (oldkind) is primary!
    itemfreeze_itemkind[j] = oldkind
    mykind = oldkind
  end
  -- Now we test for and move items:
  if mykind == "" then
    if newkind ~= "" then
      -- In this case there is an item to freeze into the stone.
      itemfreeze_itemkind[j] = newkind
      kill_item(itemfreeze_pos_x[j], itemfreeze_pos_y[j])
      set_item(itemfreeze_itemkind[j], itemfreeze_pos_x[j], itemfreeze_pos_y[j])
    end
  else   -- this means: mykind ~= ""
    -- There already is an item frozen into the stone.
    if newkind == "" then
      -- Just move the old item here.
      -- In particular, this removes *any* item that has been ignored above:
      -- e.g. it-laserbeam, it-explosions and also it-debris!
      set_item(mykind, itemfreeze_pos_x[j], itemfreeze_pos_y[j])
      kill_item(enigma.GetPos(olditem))
    else
      -- at this point, we have olditem ~= nil, newitem ~= nil, but
      -- they might be identical.
      --if newitem == olditem then
      if (itemfreeze_pos_x[j] == old_x) and (itemfreeze_pos_y[j] == old_y) then
        -- Ah, it's just the old one. Forget it.
        -- Note: For this, we compared the item-positions,
        --       comparing the items themselves doesn't work in lua 5!
      else
        -- Okay, now we're in trouble. Several possiblities:
        --  (1) Kill the new one, hold the old, and move it.
        --  (2) Kill the old one, hold the new, and don't need to move it.
        --  (3) Keep the new one, hold the old => Switch positions.
        --  (4) Keep the old one, hold the new => Don't switch positions.
        --  (5) Save the new one and overrun it.
        if itemfreeze_option == 1 then
          kill_item(enigma.GetPos(olditem))
          kill_item(enigma.GetPos(newitem))
          set_item(mykind, itemfreeze_pos_x[j], itemfreeze_pos_y[j])
        elseif itemfreeze_option == 2 then
          itemfreeze_itemkind[j] = newkind
          kill_item(enigma.GetPos(olditem))
        elseif itemfreeze_option == 3 then
          kill_item(enigma.GetPos(olditem))
          kill_item(enigma.GetPos(newitem))
          set_item(mykind, itemfreeze_pos_x[j], itemfreeze_pos_y[j])
          set_item(newkind, old_x, old_y)
        elseif (itemfreeze_option == 4) or (newkind == itemfreeze_defreezing_item) then
          itemfreeze_itemkind[j] = newkind
        elseif itemfreeze_option == 5 then
          if itemfreeze_saveditem_kind[j] == "" then
            -- there is no item saved yet, which means, we got it the easy way:
            itemfreeze_saveditem_kind[j] = newkind
            itemfreeze_saveditem_pos_x[j] = itemfreeze_pos_x[j]
            itemfreeze_saveditem_pos_y[j] = itemfreeze_pos_y[j]
            kill_item(enigma.GetPos(olditem))
            kill_item(enigma.GetPos(newitem))
            set_item(mykind, itemfreeze_pos_x[j], itemfreeze_pos_y[j])
            -- restauration will take place later...
          else
            -- there is already an item saved, which complicates things...
            kill_item(itemfreeze_saveditem_pos_x[j], itemfreeze_saveditem_pos_y[j])
            set_item(itemfreeze_saveditem_kind[j], itemfreeze_saveditem_pos_x[j],
              itemfreeze_saveditem_pos_y[j])
            itemfreeze_saveditem_kind[j] = newkind
            itemfreeze_saveditem_pos_x[j] = itemfreeze_pos_x[j]
            itemfreeze_saveditem_pos_y[j] = itemfreeze_pos_y[j]
            kill_item(itemfreeze_pos_x[j], itemfreeze_pos_y[j])
            set_item(mykind, itemfreeze_pos_x[j], itemfreeze_pos_y[j])
          end        
        end
      end 
    end
  end   
  -- Maybe restauration of a saved item?
  if itemfreeze_option == 5 then
    if not (itemfreeze_saveditem_kind[j] == "") then
      if enigma.GetItem(itemfreeze_saveditem_pos_x[j], itemfreeze_saveditem_pos_y[j])
           == nil then
        set_item(itemfreeze_saveditem_kind[j], itemfreeze_saveditem_pos_x[j],
           itemfreeze_saveditem_pos_y[j])
        itemfreeze_saveditem_kind[j] = ""
      end
    end
  end
  -- Finally, deal with maybe-happened explosions and fire below our stone:
  if explosion ~= 0 then
    if (explosion == -1) or (explosion == 3) then
      -- it-debris (-1): Only put an abyss below our stone.
      -- it-*bomb (3): Do the same, and later shatter.
      itemfreeze_savedfloor[j] = "fl-abyss"
    end
    if explosion > 0 then  -- BOOM!
      itemfreeze_shatter(j)
    end
    if explosion == -2 then  -- Fire!
      itemfreeze_melt(j)
    end
  end
  -- Note, that after this point the st-itemfreeze-stone might
  -- have disappeared!
end

function itemfreeze_look_for_floor(j, old_x, old_y)
  if not (itemfreeze_savedfloor[j] == "") then
    set_floor(itemfreeze_savedfloor[j], old_x, old_y)
  end
  local newfloor = enigma.GetKind(enigma.GetFloor(
      itemfreeze_pos_x[j], itemfreeze_pos_y[j]))
  if newfloor == "fl-water" then
    itemfreeze_savedfloor[j] = itemfreeze_parentfloor  -- this is fl-ice
    set_floor(itemfreeze_parentfloor, itemfreeze_pos_x[j], itemfreeze_pos_y[j])
  else
    itemfreeze_savedfloor[j] = newfloor
    set_floor(itemfreeze_parentfloor, itemfreeze_pos_x[j], itemfreeze_pos_y[j])
  end
end

function itemfreeze_look_for_explosion(j, x, y)
  if (x >= 0) and (y >= 0) and (itemfreeze_destroyed[j] == 0) then
    local myitem = enigma.GetItem(x, y)
    if myitem ~= nil then
      local kind = enigma.GetKind(myitem)
      if (kind == "it-explosion1") or (kind == "it-explosion2")
              or (kind == "it-explosion3") then
        itemfreeze_shatter(j)
      end
    end
  end
end

function itemfreeze_look_for_fire(j, x, y, damage)
  if (x >= 0) and (y >= 0) and (itemfreeze_destroyed[j] == 0) then
    local myitem = enigma.GetItem(x, y)
    if myitem ~= nil then
      local kind = enigma.GetKind(myitem)
      if (kind == "it-burnable_burning") or (kind == "it-burnable_ignited") then
        itemfreeze_melt(j, damage)
      end
    end
  end
end

function itemfreeze_timercallback()
  if itemfreeze_totalnumber > 0 then
    local j
    for j = 1, itemfreeze_totalnumber do
      -- Check for existence of the stone
      if itemfreeze_test_for_existence ~= 0 then
        if itemfreeze_destroyed[j] == 0 then
          itemfreeze_stone[j] = enigma.GetNamedObject("st-itemfreeze_"..tostring(j))
          if itemfreeze_stone[j] == nil then
            itemfreeze_destroyed[j] = 1
          end
        end
      end
      -- Check items and floors, has the stone moved?
      if itemfreeze_destroyed[j] == 0 then
        local current_stone = itemfreeze_stone[j]
        local old_x = itemfreeze_pos_x[j]
        local old_y = itemfreeze_pos_y[j]
        itemfreeze_pos_x[j], itemfreeze_pos_y[j] = enigma.GetPos(current_stone)
        --if (enigma.GetStone(itemfreeze_pos_x[j], itemfreeze_pos_y[j])
        --    ~= itemfreeze_stone[j]) then -- this doesn't work in lua 5!
        if (old_x ~= itemfreeze_pos_x[j]) or (old_y ~= itemfreeze_pos_y[j]) then
          -- Obviously, this stone has moved!
          enigma.EmitSound(current_stone, "ballcollision")
          itemfreeze_look_for_floor(j, old_x, old_y)
          itemfreeze_look_for_item(j, old_x, old_y)
        end  
      end
    end
    -- Now the pyrotechniques:
    if itemfreeze_fire_countdown == 0 then
      local j
      for j = 1, itemfreeze_totalnumber do
        if itemfreeze_destroyed[j] == 0 then
          -- Check for nearby explosions
          if itemfreeze_test_for_explosion == 1 then
            itemfreeze_look_for_explosion(j, itemfreeze_pos_x[j], itemfreeze_pos_y[j])
            itemfreeze_look_for_explosion(j, itemfreeze_pos_x[j] + 1, itemfreeze_pos_y[j])
            itemfreeze_look_for_explosion(j, itemfreeze_pos_x[j] - 1, itemfreeze_pos_y[j])
            itemfreeze_look_for_explosion(j, itemfreeze_pos_x[j], itemfreeze_pos_y[j] + 1)
            itemfreeze_look_for_explosion(j, itemfreeze_pos_x[j], itemfreeze_pos_y[j] - 1)
          end
          -- Check for nearby fire
          if itemfreeze_test_for_fire == 1 then
            itemfreeze_look_for_fire(j, itemfreeze_pos_x[j], itemfreeze_pos_y[j], 
                   itemfreeze_melt_on_damage)  -- Immediately destroy if fire is inside!
            itemfreeze_look_for_fire(j, itemfreeze_pos_x[j] + 1, itemfreeze_pos_y[j], 1)
            itemfreeze_look_for_fire(j, itemfreeze_pos_x[j] - 1, itemfreeze_pos_y[j], 1)
            itemfreeze_look_for_fire(j, itemfreeze_pos_x[j], itemfreeze_pos_y[j] + 1, 1)
            itemfreeze_look_for_fire(j, itemfreeze_pos_x[j], itemfreeze_pos_y[j] - 1, 1)
          end
        end
      end
      -- Next cycle:
      itemfreeze_fire_countdown = itemfreeze_fire_interval
    else
      itemfreeze_fire_countdown = itemfreeze_fire_countdown - 1
    end
  end
end


---------------------------
--  Interface functions  --
---------------------------


function itemfreeze_rotate_option()
  if itemfreeze_option == 5 then
    itemfreeze_option = 1
  else
    itemfreeze_option = itemfreeze_option + 1
  end
  -- The following was for debugging-reasons:
  --set_item("it-document", 2, 2,
  --  {text = "itemfreeze_option = "..tostring(itemfreeze_option)})
  --set_item("it-document", 2, 2, {text = "Laser: "..enigma.GetKind(enigma.GetItem(16,3))})
  --set_item("it-document", 2, 2, {text = "Nr 1: "..itemfreeze_itemkind[1]})
end

function set_itemfreeze(posx, posy)
  itemfreeze_totalnumber = itemfreeze_totalnumber + 1
  local newstone = set_stone(itemfreeze_parentstone, posx, posy,
    { name="st-itemfreeze_"..tostring(itemfreeze_totalnumber) })
  itemfreeze_savedfloor[itemfreeze_totalnumber] = ""
  itemfreeze_pos_x[itemfreeze_totalnumber] = posx
  itemfreeze_pos_y[itemfreeze_totalnumber] = posy  
  itemfreeze_stone[itemfreeze_totalnumber] = newstone
  itemfreeze_itemkind[itemfreeze_totalnumber] = ""
  itemfreeze_saveditem_kind[itemfreeze_totalnumber] = ""
  itemfreeze_saveditem_pos_x[itemfreeze_totalnumber] = 0
  itemfreeze_saveditem_pos_y[itemfreeze_totalnumber] = 0
  itemfreeze_destroyed[itemfreeze_totalnumber] = 0
  itemfreeze_damaged[itemfreeze_totalnumber] = 0
  itemfreeze_look_for_floor(itemfreeze_totalnumber, posx, posy)
  itemfreeze_look_for_item(itemfreeze_totalnumber, posx, posy)
end

function itemfreeze_init(timer_x, timer_y, timer_interval)
  set_stone("st-timer", timer_x, timer_y, { action="callback",
    target="itemfreeze_timercallback", interval=timer_interval, invisible=FALSE })
end

function parent_itemfreeze(x,y,itemkind)  -- This is a parent for use with ant.lua
  if itemkind ~= "" then
    set_item(itemkind, x, y)
  end
  set_itemfreeze(x, y)
end





