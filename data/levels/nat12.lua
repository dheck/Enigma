-- Simon Says
-- A level for Enigma
--
-- Copyright (c) 2003 Nat Pryce
-- Licensed under the GPL version 2.


function send_message( obj_name, message, arg )
    obj = enigma.GetNamedObject( obj_name )
    if obj == nil then
        error( "trying to send message " .. message .. 
               " to nonexistant object named " .. obj_name )
    else
        SendMessage( obj, message, arg )
    end
end

function name( prefix, index )
    return prefix .. tostring(index)
end

function draw_room( x, y, width, height, floor )
    fill_floor( floor, x, y, width, height )
    draw_border( "st-rock6", x, y, width, height )
end



---------------------------------------------------------------
-- Functions to create and control items in the level

DOOR_COUNT = 16
LIGHT_COUNT = 8
BLOCKAGE_COUNT = 8

function door( i )
    return name("door",i)
end

function light( i )
    return name("light",i)
end

function open_doors()
    for i = 1,DOOR_COUNT do
        send_message( door(i), "open" )
    end
end

function close_doors()
    for i = 1,DOOR_COUNT do
        send_message( door(i), "close" )
    end
end

function open_blockage( i )
    send_message( name("blocka",i), "open" )
    send_message( name("blockb",i), "open" )
end

function close_all_blockages()
    for i = 1,BLOCKAGE_COUNT do
        send_message( name("blocka",i), "close" )
        send_message( name("blockb",i), "close" )
    end
end

function flash_light( i )
    send_message( light(i), "trigger" )
end

function start_timer()
    send_message( "timer", "on" )
end

function stop_timer()
    send_message( "timer", "off" )
end


---------------------------------------------------------------
-- Functions to manage the sequence

SEQUENCE_START_SIZE = 1
SEQUENCE_SIZE_STEP = 1

STATE_WAITING = 1
STATE_SHOW = 2
STATE_MATCH = 3

state = STATE_WAITING
sequence = {}   -- The sequence the player is trying to match
current = 1     -- The current item being matched or shown
sequence_id = 1 -- The current index of the sequence

function sequence_index()
    return sequence_id
end

function all_sequences_complete()
    return sequence_index() == LASER_COUNT
end

function sequence_size()
    return getn(sequence)
end

function sequence_is_complete()
    return current > sequence_size()
end

function current_sequence_item()
    return sequence[current]
end

function step_to_next_sequence_item()
    assert( not sequence_is_complete() )
    current = current + 1
end

function create_first_sequence()
    create_sequence( SEQUENCE_START_SIZE )
    sequence_id = 1
end

function create_next_sequence()
    create_sequence( sequence_size() + SEQUENCE_SIZE_STEP )
    sequence_id = sequence_id + 1
end

function create_sequence( size )
    sequence = {}
    
    for n = 1,size do
        next_element = random( 1, LIGHT_COUNT )
        
        while getn(sequence) > 0 and 
              next_element == sequence[getn(sequence)] 
        do
            next_element = random( 1, LIGHT_COUNT )
        end
        
        tinsert( sequence, next_element )
    end
    
    current = size + 1
end

function rewind_to_start_of_sequence()
    current = 1
end

---------------------------------------------------------------
-- Sequence playback

function show_sequence( trigger )
    if sequence_is_complete() and trigger == 1 then
        close_doors()
        start_sequence_playback()
    end
end

function timer_callback()
    if sequence_is_complete() then
        open_doors()
        stop_timer()
        rewind_to_start_of_sequence()
    else
        flash_current_light()
        step_to_next_sequence_item()
    end
end

function start_sequence_playback()
    rewind_to_start_of_sequence()
    start_timer()
end

function flash_current_light()
    flash_light( current_sequence_item() )
end

---------------------------------------------------------------

function switch1() switch(1) end
function switch2() switch(2) end
function switch3() switch(3) end
function switch4() switch(4) end
function switch5() switch(5) end
function switch6() switch(6) end
function switch7() switch(7) end
function switch8() switch(8) end

function switch( i )
    if not sequence_is_complete() then
        if i == current_sequence_item() then
            flash_light( i )
            step_to_next_sequence_item()
            if sequence_is_complete() then
                finish_sequence()
            end
        else
            start_level()
        end
    end
end

function finish_sequence()
    open_blockage( sequence_index() )
    create_next_sequence()
    open_doors()
end

---------------------------------------------------------------


function start_level()
    stop_timer()
    close_all_blockages()
    oxyd_closeall()
    create_first_sequence()
    open_doors()
end



---------------------------------------------------------------
-- Create the world

randomseed( enigma.GetTicks() )

create_world( 20, 13 )

fill_floor( "fl-leaves")
draw_room( 1, 1, 11, 11, "fl-samba" )

set_stone( "st-door_a", 4, 4, {name=door(1)} )
set_stone( "st-door_a", 5, 4, {name=door(2)} )
set_stone( "st-door_a", 6, 4, {name=door(3)} )
set_stone( "st-door_a", 7, 4, {name=door(4)} )
set_stone( "st-door_a", 8, 4, {name=door(5)} )
set_stone( "st-door_a", 4, 5, {name=door(6)} )
set_stone( "st-door_a", 8, 5, {name=door(7)} )
set_stone( "st-door_a", 4, 6, {name=door(8)} )
set_stone( "st-door_a", 8, 6, {name=door(9)} )
set_stone( "st-door_a", 4, 7, {name=door(10)} )
set_stone( "st-door_a", 8, 7, {name=door(11)} )
set_stone( "st-door_a", 4, 8, {name=door(12)} )
set_stone( "st-door_a", 5, 8, {name=door(13)} )
set_stone( "st-door_a", 6, 8, {name=door(14)} )
set_stone( "st-door_a", 7, 8, {name=door(15)} )
set_stone( "st-door_a", 8, 8, {name=door(16)} )

set_item( "it-trigger", 6, 6, 
          {action="callback", target="show_sequence"} )

set_stone( "st-fart", 1,  1,  {name=light(1)} )
set_stone( "st-fart", 6,  1,  {name=light(2)} )
set_stone( "st-fart", 11, 1,  {name=light(3)} )
set_stone( "st-fart", 1,  6,  {name=light(4)} )
set_stone( "st-fart", 11, 6,  {name=light(5)} )
set_stone( "st-fart", 1,  11, {name=light(6)} )
set_stone( "st-fart", 6,  11, {name=light(7)} )
set_stone( "st-fart", 11, 11, {name=light(8)} )

set_stone( "st-switch", 2, 2, 
           {action="callback", target="switch1"} )
set_stone( "st-switch", 6, 2, 
           {action="callback", target="switch2"} )
set_stone( "st-switch", 10, 2, 
           {action="callback", target="switch3"} )
set_stone( "st-switch", 2, 6, 
           {action="callback", target="switch4"} )
set_stone( "st-switch", 10, 6, 
           {action="callback", target="switch5"} )
set_stone( "st-switch", 2, 10, 
           {action="callback", target="switch6"} )
set_stone( "st-switch", 6, 10, 
           {action="callback", target="switch7"} )
set_stone( "st-switch", 10, 10, 
           {action="callback", target="switch8"} )

set_stone( "st-timer", 18, 6, { name="timer", 
                                action="callback", 
                                target="timer_callback", 
                                interval=1 } )


oxyd( 18, 1 )
oxyd( 18, 11 )

set_stone( "st-laser", 16, 6, {on=TRUE, dir=WEST } )

mirror3( 13, 6, FALSE, FALSE, 4 )

mirrorp( 13,  1, FALSE, FALSE, 4 )
mirrorp( 13, 11, FALSE, FALSE, 2 )


for id = 1,4 do
    ya = 6 + id
    yb = 6 - id
    
    set_stone( "st-door_b", 13, ya, {name=name("blocka",id)} )
    set_stone( "st-door_b", 13, yb, {name=name("blockb",id)} )
end

for i=1,4 do
    id = 4+i
    x = 13+i

    set_stone( "st-door_b", x, 1,  {name=name("blocka",id)} )
    set_stone( "st-door_b", x, 11, {name=name("blockb",id)} )
end


set_actor( "ac-blackball", 3.5, 6.5 )

start_level()
