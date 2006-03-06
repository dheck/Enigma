-- Walk the Plank
-- A level for Enigma
-- Copyright (c) 2002 Nat Pryce
-- License: GPL v2.0 or above


function island( left, top, width, height )
    fill_floor( "fl-sand", left, top, width, height )
    fill_floor( "fl-leaves", left+1, top+1, width-2, height-2 )
end

function stipple( setter, type, left, top, width, height, attrs )
    if attrs == nil then
        attrs = {}
    end
    for y = top, top+height-1 do
        for x = left, left+width-1 do
            if mod(x,2) == mod(y,2) then
                setter( type, x, y, attrs )
            end
        end
    end
end


screen_width = 20
screen_height = 13

screens_x = 5
screens_y = 3

create_world( (screens_x-1)*(screen_width-1) + screen_width,
              (screens_y-1)*(screen_height-1) + screen_height )
draw_border( "st-greenbrown" )

fill_floor( "fl-water")

-------------------------------------------------------------------------------
-- An easter egg for curious players

island( 4, 16, 5, 5 )
document( 6, 18, "Here lies Black Ball the pirate, marooned in the year 1802 after travelling in the wrong direction.")

-------------------------------------------------------------------------------
-- Starting screen

island( 20, 13, 7, screen_height-2 )
stipple( set_stone, "st-wood", 21, 14, 5, screen_height-4 )

start_x = 23.5
start_y = 18.5



-------------------------------------------------------------------------------
-- Ferry terminal

ferry_movement = nil
ferry_start = 45
ferry_end = 80
ferry_width = 4
ferry_height = 3
ferry_x = ferry_start
ferry_y = 17
ferry_floor = "fl-samba"

function ferry_move_right()
    fill_floor( "fl-water", ferry_x, ferry_y, 1, ferry_height )
    fill_floor( ferry_floor, ferry_x+ferry_width, ferry_y, 1, ferry_height )
    
    ferry_x = ferry_x + 1
    if ferry_x == ferry_end then
        ferry_movement = ferry_move_left
    end
end

function ferry_move_left()
    fill_floor( "fl-water", ferry_x+ferry_width-1, ferry_y, 1, ferry_height )
    fill_floor( ferry_floor, ferry_x-1, ferry_y, 1, ferry_height )
    
    ferry_x = ferry_x - 1
    if ferry_x == ferry_start then
        ferry_movement = ferry_move_right
    end
end

function move_ferry()
    ferry_movement()
end

function start_ferry()
    if not ferry_movement then
        ferry_movement = ferry_move_right
        SendMessage( "timer", "on" )
        SendMessage( "laser_timer1", "on" )
        SendMessage( "laser_timer2", "on" )
    end
end

island( 40, 16, 5, 5 )

set_stone( "st-timer", 42, 18,
           {target="move_ferry", action="callback",
            name="timer", interval=0.75} )
SendMessage( "timer", "off" )
set_item( "it-trigger", 44, 18, 
          {target="start_ferry", action="callback"} )

fill_floor( ferry_floor, ferry_x, ferry_y, ferry_width, ferry_height )
document( ferry_x+2, ferry_y+1, "To cure sea sickness hold a large bank note between your teeth and lean over the side")


-------------------------------------------------------------------------------
-- Ferry journey

set_stone( "st-fakeoxyd", 60, ferry_y )
set_stone( "st-fakeoxyd", 60, ferry_y+1 )
set_stone( "st-fakeoxyd", 63, ferry_y+2 )
set_stone( "st-fakeoxyd", 63, ferry_y+1 )
set_stone( "st-fakeoxyd", 66, ferry_y+1 )
set_stone( "st-fakeoxyd", 66, ferry_y )
set_stone( "st-fakeoxyd", 68, ferry_y+1 )
set_stone( "st-fakeoxyd", 68, ferry_y+2 )

set_stone( "st-fakeoxyd", 70, ferry_y )
set_stone( "st-fakeoxyd", 70, ferry_y+1 )

set_stone( "st-fakeoxyd", 72, ferry_y+1 )
set_stone( "st-fakeoxyd", 72, ferry_y+2 )

set_stone( "st-fakeoxyd", 74, ferry_y )
set_stone( "st-fakeoxyd", 74, ferry_y+1 )


set_stone( "st-fakeoxyd", 76, ferry_y )
set_stone( "st-fakeoxyd", 76, ferry_y+2 )

set_stone( "st-laser", 73, ferry_y-2, {name="laser1",dir=SOUTH,on=1} )
set_stone( "st-timer", 73, ferry_y+4, 
           {action="onoff",target="laser1",interval="1.75",
            name="laser_timer1"} )

set_stone( "st-laser", 75, ferry_y+4, {name="laser2",dir=NORTH,on=0} )
set_stone( "st-timer", 75, ferry_y-2, 
           {action="onoff",target="laser2",interval="1.75",
            name="laser_timer2"} )

SendMessage( "laser_timer1", "off" )
SendMessage( "laser_timer2", "off" )



-------------------------------------------------------------------------------
-- Final Destination

count = 0
function on_trigger( on )
    if on == 1 then
        count = count + 1
        if count == 4 then
            SendMessage( "door1", "open" )
            SendMessage( "door2", "open" )
            SendMessage( "door3", "open" )
        end
    else
        count = count - 1
        SendMessage( "door1", "close" )
        SendMessage( "door2", "close" )
        SendMessage( "door3", "close" )
    end
end

function trigger( x, y )
    set_item("it-trigger", x, y, {action="callback", target="on_trigger"} )
end


fill_floor( "fl-gray", 84, 11, 11, screen_height+2 )
set_floor( "fl-gray", 83, ferry_y-1 )
set_floor( "fl-gray", 83, ferry_y+ferry_height )

draw_stones( "st-greenbrown", {84,12}, {1,0}, 11 )
draw_stones( "st-greenbrown", {84,24}, {1,0}, 11 )

doorh( 86, 12, {name="door1"} )
doorh( 86, 24, {name="door2"} )

set_stone( "st-brick", 86, 17 )
set_stone( "st-brick", 86, 16 )
set_stone( "st-brick", 85, 17 )
doorv( 85, 18, {name="door4"} )
set_item( "it-trigger", 84, 18, {target="door4",action="open"} )
set_item( "it-trigger", 87, 18, {target="door4",action="close"} )
set_stone( "st-brick", 85, 19 )
set_stone( "st-brick", 86, 19)
set_stone( "st-brick", 86, 20 )

set_stone( "st-brick", 87, 16 )
set_stone( "st-brick", 87, 15 )

set_stone( "st-brick", 87, 20 )
set_stone( "st-brick", 87, 21 )

draw_stones( "st-brick", {87,14}, {1,0}, 5 )
draw_stones( "st-brick", {87,22}, {1,0}, 5 )

set_stone( "st-brick", 91, 15 )
set_stone( "st-brick", 91, 16 )

set_stone( "st-brick", 91, 20 )
set_stone( "st-brick", 91, 21 )

set_stone( "st-brick", 92, 16 )
set_stone( "st-brick", 92, 17 )
doorv( 92, 18, {name="door3"} )
set_stone( "st-brick", 92, 19 )
set_stone( "st-brick", 92, 20 )

set_stone( "st-brick", 88, 18 )
set_stone( "st-brick", 89, 16 )
set_stone( "st-brick", 89, 20 )

trigger( 89, 17 )
trigger( 89, 19 )
trigger( 90, 16 )
trigger( 90, 20 )

set_stone( "st-brownie", 89, 18 )
set_stone( "st-brownie", 90, 18 )
set_stone( "st-brownie", 88, 16 )
set_stone( "st-brownie", 88, 20 )

fill_floor( "fl-plank", 87, 15, 5, 7 )
set_floor( "fl-plank", 85, 18 )
set_floor( "fl-plank", 86, 18 )
set_floor( "fl-plank", 92, 18 )

-------------------------------------------------------------------------------
-- Harbour walls

draw_floor( "fl-gray",   {39,11}, {1,0}, 46 )
set_floor( "fl-gray", 39, 10 )
set_floor( "fl-gray", 39, 9 )
draw_floor( "fl-leaves", {40,10}, {1,0}, 56 )
draw_floor( "fl-sand",   {40,9},  {1,0}, 56 )
set_stone( "st-wood", 39, 11 )
set_stone( "st-wood", 39, 10 )

draw_floor( "fl-gray", {39,25}, {1,0}, 46 )
set_floor( "fl-gray", 39, 26 )
set_floor( "fl-gray", 39, 27 )
draw_floor( "fl-leaves", {40,26}, {1,0}, 56 )
draw_floor( "fl-sand",   {40,27}, {1,0}, 56 )
set_stone( "st-wood", 39, 25 )
set_stone( "st-wood", 39, 26 )

-------------------------------------------------------------------------------
-- Place the Oxyds

oxyd(37,12)
oxyd(94,13)

oxyd(37,24)
oxyd(94,23)


-------------------------------------------------------------------------------
-- The starting point

set_actor( "ac-blackball", start_x, start_y )



-------------------------------------------------------------------------------
-- For testing: comment out the set_actor line above and uncomment one of these

-- To test the ferry start
--set_actor( "ac-blackball", 43.5, 18.5 )
--set_stone( "st-wood", 45, 18 )

-- To test the final destination
--set_actor( "ac-blackball", 84.5, 18.5 )
--fill_floor( ferry_floor, ferry_end, ferry_y, ferry_width, ferry_height )





























