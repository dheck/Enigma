-- Caterpillar
-- A level for Enigma
--
-- Copyright (c) 2003 Nat Pryce
-- Licensed under the GPL version 2.

enigma.ConserveLevel = FALSE

send_message = SendMessage

-----------------------------------------------------------------------------
-- Snake functions

STRENGTH = 50

snake_end = nil

function snake_attach( actor )
    AddRubberBand( snake_end, actor, STRENGTH, 1 )
    snake_end = actor
end

function start_snake( x, y )
    snake_end = set_actor( "ac-blackball", x, y )
end

-----------------------------------------------------------------------------
-- Scenery constructors

function trigger( x, y, callback )
    set_item( "it-trigger", x, y, {action="callback", target=callback} )
end

function whiteball_start( x, y )
    set_stone( "st-white4", x, y )
    return set_actor( "ac-whiteball", x+0.5, y+0.5,
                      {player=0,controllers=0} )
end

function create_westward_shed( x, y, width, callback_name, door_type )
    fill_floor( "fl-water", x, y-1, width+1, 5 )
    fill_floor( "fl-samba", x, y, width, 3 )
    draw_border( "st-rock1", x, y, width, 3 )
    set_stone( door_type or "st-white4", x, y+1 )
    trigger( x+width-3, y+1, callback_name )
    return whiteball_start( x+width-2, y+1 )
end

function create_eastward_shed( x, y, width, callback_name, door_type )
    fill_floor( "fl-water", x-1, y-1, width+1, 5 )
    fill_floor( "fl-samba", x, y, width, 3 )
    draw_border( "st-rock1", x, y, width, 3 )
    set_stone( door_type or "st-white4", x+width-1, y+1 )
    trigger( x+2, y+1, callback_name )
    return whiteball_start( x+1, y+1 )
end

function create_northward_shed( x, y, height, callback_name, door_type )
    fill_floor( "fl-water", x-1, y, 5, height+1 )
    fill_floor( "fl-samba", x, y, 3, height )
    draw_border( "st-rock1", x, y, 3, height )
    set_stone( door_type or "st-white4", x+1, y )
    trigger( x+1, y+height-3, callback_name )
    return whiteball_start( x+1, y+height-2 )
end

function create_southward_shed( x, y, height, callback_name, door_type )
    fill_floor( "fl-water", x-1, y-1, 5, height+1 )
    fill_floor( "fl-samba", x, y, 3, height )
    draw_border( "st-rock1", x, y, 3, height )
    set_stone( door_type or "st-white4", x+1, y+height-1 )
    trigger( x+1, y+2, callback_name )
    return whiteball_start( x+1, y+1 )
end

function oxyd_chamber( x )
    local y = 27
    
    draw_stones( "st-rock1", {x, y}, {0,1}, 7 )
    set_stone( "st-oneway_white-s", x+1, y )
    oxyd( x+1, y+2 )
    set_stone( "st-rock1", x+1, y+3 )
    oxyd( x+1, y+4 )
    set_stone( "st-oneway_white-n", x+1, y+6 )
    draw_stones( "st-rock1", {x+2, y}, {0,1}, 7 )
end


-----------------------------------------------------------------------------
-- The world
-----------------------------------------------------------------------------

create_world( 39, 37 )

fill_floor( "fl-leaves", 0, 0, 39, 25 )
draw_border( "st-rock1", 0, 0, 39, 25 )

start_snake( 12.5, 21.5 )

ball_1 = create_southward_shed( 32, 15, 4, "attach_ball_1", "st-grate1" )
function attach_ball_1()
    if ball_1 then
        snake_attach(ball_1)
        ball_1 = nil
    end
end

ball_2 = create_southward_shed( 11, 4, 4, "attach_ball_2" )
function attach_ball_2()
    if ball_2 then
        snake_attach(ball_2)
        ball_2 = nil
    end
end

ball_3 = create_northward_shed( 2, 18, 5, "attach_ball_3" )
function attach_ball_3()
    if ball_3 then
        snake_attach(ball_3)
        ball_3 = nil
    end
end

ball_4 = create_westward_shed( 4, 7, 6, "attach_ball_4" )
function attach_ball_4()
    if ball_4 then
        snake_attach(ball_4)
        ball_4 = nil
    end
end

ball_5 = create_southward_shed( 34, 2, 7, "attach_ball_5" )
function attach_ball_5()
    if ball_5 then
        snake_attach(ball_5)
        ball_5 = nil
    end
end

ball_6 = create_westward_shed( 25, 4, 8, "attach_ball_6" )
function attach_ball_6()
    if ball_6 then
        snake_attach(ball_6)
        ball_6 = nil
    end
end

ball_7 = create_westward_shed( 8, 15, 9, "attach_ball_7" )
function attach_ball_7()
    if ball_7 then
        snake_attach(ball_7)
        ball_7 = nil
    end
end

ball_8 = create_eastward_shed( 22, 20, 10, "attach_ball_8" )
function attach_ball_8()
    if ball_8 then
        snake_attach(ball_8)
        send_message("door", "open")
        ball_8 = nil
    end
end


draw_border( "st-rock1", 0, 24, 39,13 )
draw_checkerboard_floor( "fl-red", "fl-white", 0, 24, 39, 13 ) 

set_stone( "st-door", 12, 24, {type="h", name="door"} )

set_stone( "st-scissors", 6, 30 )

oxyd_chamber( 22 )
oxyd_chamber( 26 )
oxyd_chamber( 30 )
oxyd_chamber( 34 )

