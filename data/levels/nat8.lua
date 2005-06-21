-- Flood Gates
-- A level for Enigma
-- Copyright (c) 2002 Nat Pryce
-- License: GPL v2.0 or above
enigma.ConserveLevel=FALSE                  -- \dh\


level = {
"##########################~############$",
"#::::::::::::::::::::::::A~#::::::::::# ",
"#:#########################b::::::::::# ",
"#::::::::::::::::::::::::::B::::::*:::# ",
"###:#######################a::::::::::# ",
"#  :  ~~~~~~~~~~~~~~~~~~~~~#::::::::::# ",
"#  :  ====~~~=====~~~==    c########### ",
"###:####~=~~~=~~~=~~~=~# ###::::::::::# ",
"#::::::#~=====~~~=====~# #:=========2:# ",
"#::::::#~~~~~~~~~~~~~~~# #:=::::::::::# ",
"#::::::################# #:====:=====:# ",
"#::::::C:::::::::::::::# #::::=:=:::=:# ",
"#D####################:# #:====:=:===:# ",
"#:#::::::::::::::::::#:# #:=::::=:=:::# ",
"#:#:fff::::::::::::::#-# #:======:===:# ",
"#:#:f2f::::::::::::::&%& #::::::::::=:# ",
"#:#:fff::::::::::::::#-#+###########&-# ",
"#:#::::::::::::::::::#:::::::::::::-%-# ",
"#:####F############# ### ###########&## ",
"#:d1#~~~==           #3#              # ",
"#:###~~~=~############g#############+## ",
"#:#~~~~~=~# :::::::::::#ih :::::::::::# ",
"#:#~===~=~# :         :### :         :# ",
"#:#~=~=~=~# : :::::::::#   :   ::::: :# ",
"#:#~=~=~=~# : :  #######   :###I###: :# ",
"e:e~=~=~=~# : : :: + ::::  :#4:::5#: :# ",
"e:e~=~=~=~# : : :# # #  :  :#:::::#: :# ",
"e:e~=~=~=~# : : :# # #  :  :#::3::#: :# ",
"e:e~=~=~=~# : :::# # #  :  :#:::::#: :# ",
"e:e~=~=~=~# :    #+#+#  :  :#5:::4#: :# ",
"e:e~=~===~# :::::^:+:^:::  :#######: :# ",
"e:E~=~~~~~#      #:::#     ::::::::: :# ",
"#:## ##############G#################H# ",
"#:   #1:::::::::::::::::::::::::::::::@ ",
"#:###################################:# ",
"#:::::::::::::::::::::::::::::::::::::@ ",
"####################################### ",
}

channels = {} -- cells along which water can flow
flows = {}    -- cells onto which water will flow next tick
doors = {}    -- mapping from door names to cell identifiers

-- what can be on a channel cell
WATER = 0
CHANNEL = 1
BRIDGE = 2
GATE = 3


function set_channel( x, y, type )
    set_channel_cell( cell(x,y), type )
end

function set_channel_cell( cell, type )
    channels[cell] = type
end

function canal( x, y )
    set_floor( "fl-rough", x, y )
    set_channel( x, y, CHANNEL )
end

function water( x, y )
    set_floor( "fl-water", x, y )
    set_channel( x, y, WATER )
end

function gate_v( x, y, name )
    canal( x, y )
    doorv( x, y, {name=name} )
    
    cell_id = cell(x,y)
    doors[name] = cell_id
    set_channel( x, y, GATE )
end

function gate_h( x, y, name )
    canal( x, y )
    doorh( x, y, {name=name} )
    
    cell_id = cell(x,y)
    doors[name] = cell_id
    set_channel( x, y, GATE )
end

function open_lockgate( name )
    send_message( name, "open" )
    set_channel_cell( doors[name], CHANNEL )
    if is_next_to_water( doors[name] ) then
        tinsert( flows, doors[name] )
    end
end

function lockgate_type( name, factory_func )
    local gate_type = strupper(name)
    local switch_type = strlower(name)
    local callback_name = "open_gate_" .. gate_type
    local callback = function()
        open_lockgate( %gate_type )
    end
    
    setglobal( callback_name, callback )
    types[gate_type] = function( x, y )
        %factory_func( x, y, %gate_type )
    end
end

function switch_type( name )
    local gate_type = strupper(name)
    local switch_type = strlower(name)
    local callback_name = "open_gate_" .. gate_type
    
    types[switch_type] = function( x, y )
        set_stone( "st-switch", x, y,
                  {action="callback", target=%callback_name} )
    end
end

function trigger_type( name )
    local gate_type = strupper(name)
    local switch_type = strlower(name)
    local callback_name = "open_gate_" .. gate_type
    
    types[switch_type] = function( x, y )
        set_item( "it-trigger", x, y,
                  {action="callback", target=%callback_name} )
    end
end

function tick()
    local new_flows = {}
    
    for i,flow in flows do
        channel_type = channels[flow]
        if can_flow( flow ) then
            if channels[flow] == CHANNEL then
               set_floor( "fl-water", cell_x(flow), cell_y(flow) )
            end
            tinsert( new_flows, north(flow) )
            tinsert( new_flows, south(flow) )
            tinsert( new_flows, east(flow) )
            tinsert( new_flows, west(flow) )
            channels[flow] = WATER
        end
     end
     
     flows = new_flows
end

function can_flow( flow )
    return channels[flow] == CHANNEL or channels[flow] == BRIDGE
end

function is_next_to_water( cell )
    return channels[north(cell)] == WATER
        or channels[south(cell)] == WATER
        or channels[west(cell)] == WATER
        or channels[east(cell)] == WATER
end

function cell( x, y )
    return y * level_width + x
end

function cell_x( id )
    return mod( id, level_width )
end
function cell_y( id )
    return (id - cell_x(id)) / level_width
end

function cell_str( id )
    return "" .. id
end

function north( id )
    return id - level_width
end

function south( id )
    return id + level_width
end

function west( id )
    return id - 1
end

function east( id )
    return id + 1
end

function send_message( obj_name, message )
    --print( "sending message " .. message .. " to " .. obj_name )
    obj = enigma.GetNamedObject( obj_name )
    SendMessage( obj, message )
end

-------------------------------------------------------------------------------

types = {}
types[" "] = function( x, y )
   -- just the default floor
end
types["-"] = function( x, y )
    canal(x,y)
    set_stone( "st-invisible", x, y )
end
types[":"] = function( x, y )
    canal( x, y )
end
types["~"] = function( x, y )
    water( x, y )
end
types["@"] = function( x, y )
    set_floor( "fl-abyss",  x, y )
    set_stone( "st-grate1", x, y )
end
types["#"] = function( x, y )
    set_stone( "st-greenbrown", x, y )
end
types["="] = function( x, y )
    set_floor( "fl-normal", x, y )
    set_channel( x, y, BRIDGE )
end
types["^"] = function( x, y )
    canal( x, y )
    set_stone( "st-grate1", x, y )
end
types["&"] = function( x, y )
    set_floor( "fl-normal", x, y )
    set_stone( "st-grate1", x, y )
end
types["%"] = function( x, y )
    set_floor( "fl-normal", x, y )
    set_stone( "st-grate1", x, y )
    set_channel( x, y, BRIDGE )
end
types["*"] = function( x, y )
    set_floor( "fl-normal", x, y )
    set_actor( "ac-blackball", x+0.5, y+0.5 )
end
types["+"] = function( x, y )
    set_stone( "st-wood", x, y )
end
types["x"] = function( x, y )
    canal( x, y )
    set_stone( "st-wood", x, y )
end
types["$"] = function( x, y )
    set_stone( "st-timer", x, y,
               {interval=0.1, action="callback", target="tick"} )
end
lockgate_type( "A", gate_v )
switch_type( "a" )
lockgate_type( "B", gate_v )
switch_type( "b" )
lockgate_type( "C", gate_v )
switch_type( "c" )
lockgate_type( "D", gate_h )
trigger_type( "d" )
lockgate_type(  "E", gate_v )
switch_type( "e" )
lockgate_type( "F", gate_h )
trigger_type( "f" )
lockgate_type( "G", gate_h )
trigger_type( "g" )
lockgate_type( "H", gate_h )
trigger_type( "h" )
lockgate_type( "I", gate_h )
switch_type( "i" )

for color=0,9 do
    types[""..color] = function( x, y )
        set_stone( "st-oxyd", x, y, {flavor="a", color=""..%color} )
    end
end


-------------------------------------------------------------------------------

create_world( strlen(level[1]), getn(level) )
fill_floor( "fl-leaves")
for y,line in level do
    for x = 1,strlen(line) do
        local type = strchar(strbyte(line,x))
        types[type]( x-1, y-1 )
    end
end
