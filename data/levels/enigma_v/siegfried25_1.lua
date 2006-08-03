--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

enigma.ConserveLevel=FALSE                  -- \dh\

levelw = 20
levelh = 13

create_world(levelw, levelh)
draw_border("st-rock5")
fill_floor("fl-rough")

oxyd (18, 1)
oxyd ( 1,11)
fakeoxyd(18,11)

draw_stones( "st-rock5", { 1, 9}, {1,0}, 8)
draw_stones( "st-rock5", {10, 9}, {1,0}, 2)
draw_stones( "st-rock5", {13, 9}, {1,0}, 3)
draw_stones( "st-rock5", {17, 9}, {1,0}, 2)
draw_stones( "st-rock5", { 9, 1}, {0,1},10)

set_item("it-coin1",10, 3)
set_item("it-coin1",10, 4)
set_item("it-coin1",10, 5)
set_item("it-coin1",10, 6)
set_item("it-coin1",10, 7)

set_stone("st-coinslot",12, 3, {action="callback", target="ms1"})
set_stone("st-coinslot",14, 3, {action="callback", target="ms2"})
set_stone("st-coinslot",16, 3, {action="callback", target="ms3"})
set_stone("st-coinslot",12, 5, {action="callback", target="ms4"})
set_stone("st-coinslot",14, 5, {action="callback", target="ms5"})
set_stone("st-coinslot",16, 5, {action="callback", target="ms6"})
set_stone("st-coinslot",12, 7, {action="callback", target="ms7"})
set_stone("st-coinslot",14, 7, {action="callback", target="ms8"})
set_stone("st-coinslot",16, 7, {action="callback", target="ms9"})
set_stone("st-coinslot",16, 9, {action="openclose", target="door1"})
set_stone("st-door",12, 9, {name="door1", type="h"})
set_stone("st-coinslot",10,10, {action="onoff", target="laser1"})

set_attrib (mirrorp ( 3, 3, 1, 0,1), "name", "mirror01")
set_attrib (mirrorp ( 5, 3, 1, 0,1), "name", "mirror02")
set_attrib (mirrorp ( 7, 3, 1, 0,1), "name", "mirror03")
set_attrib (mirrorp ( 3, 5, 1, 0,1), "name", "mirror04")
set_attrib (mirrorp ( 5, 5, 1, 0,1), "name", "mirror05")
set_attrib (mirrorp ( 7, 5, 1, 0,1), "name", "mirror06")
set_attrib (mirrorp ( 3, 7, 1, 0,1), "name", "mirror07")
set_attrib (mirrorp ( 5, 7, 1, 0,1), "name", "mirror08")
set_attrib (mirrorp ( 7, 7, 1, 0,1), "name", "mirror09")
set_attrib (mirrorp ( 7, 1, 1, 0,1), "name", "mirror10")

set_stone( "st-timer", 0, 0, {action="callback", target="t_h1"})
set_stone( "st-timer",19, 0, {action="callback", target="t_h2"})

set_attrib(laser(  1, 3, FALSE, EAST), "name", "laser1")
set_stone( "st-laserswitch", 1, 1, {action="open", target="door2"})
set_stone("st-door", 9,11, {name="door2", type="v"})

function ms1()
       SendMessage("mirror01", "trigger")
end

function ms2()
       SendMessage("mirror02", "trigger")
end

function ms3()
       SendMessage("mirror03", "trigger")
end

function ms4()
       SendMessage("mirror04", "trigger")
end

function ms5()
       SendMessage("mirror05", "trigger")
end

function ms6()
       SendMessage("mirror06", "trigger")
end

function ms7()
       SendMessage("mirror07", "trigger")
end

function ms8()
       SendMessage("mirror08", "trigger")
end

function ms9()
       SendMessage("mirror09", "trigger")
end

timer = 0

function t_h1()
    if timer == 1 then
        SendMessage("mirror01", "turn")
        SendMessage("mirror02", "turn")
        SendMessage("mirror03", "turn")
        SendMessage("mirror04", "turn")
        SendMessage("mirror05", "turn")
        SendMessage("mirror06", "turn")
        SendMessage("mirror07", "turn")
        SendMessage("mirror08", "turn")
    end
end

function t_h2()
    if timer == 1 then
        SendMessage("mirror09", "turn")
        SendMessage("mirror10", "turn")
    end
    timer = timer + 1
    if timer ==  2 then
        timer = 0
    end
end

set_actor("ac-blackball",18.5, 8.5)

















