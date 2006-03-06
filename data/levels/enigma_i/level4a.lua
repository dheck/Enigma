--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 39
levelh = 13

create_world( levelw, levelh)

fill_floor("fl-leaves", 0,0,levelw,levelh)
draw_border( "st-greenbrown")

oxyd( 1, 1)
oxyd( 18, 1)
oxyd( 1, 6)
oxyd( 5, 6)
oxyd( 14, 6)
oxyd( 18, 6)
oxyd( 1, 11)
oxyd( 18, 11)
oxyd( 5, 2)
oxyd( 14, 2)
oxyd( 5, 10)
oxyd( 14, 10)

oxyd_shuffle()

set_stone( "st-timer", 20, 1, {action="callback", target="timer_handler1"})
set_stone( "st-timer", 20, 2, {action="callback", target="timer_handler2"})
set_stone( "st-timer", 20, 3, {action="callback", target="timer_handler3"})
set_stone( "st-timer", 20, 4, {action="callback", target="timer_handler4"})

mytimer = 0

function timer_handler1()
    doora=enigma.GetNamedObject("door1")
    doorb=enigma.GetNamedObject("door4")
    doorc=enigma.GetNamedObject("door7")
    doord=enigma.GetNamedObject("door10")
    if mytimer == 0 then
        SendMessage(doora, "openclose")
        SendMessage(doorb, "openclose")
    end
    if mytimer == 1 then
        SendMessage(doorc, "openclose")
        SendMessage(doord, "openclose")
    end
end
function timer_handler2()
    doora=enigma.GetNamedObject("door13")
    doorb=enigma.GetNamedObject("door16")
    doorc=enigma.GetNamedObject("door2")
    doord=enigma.GetNamedObject("door5")
    if mytimer == 0 then
        SendMessage(doora, "openclose")
        SendMessage(doorb, "openclose")
    end
    if mytimer == 1 then
        SendMessage(doorc, "openclose")
        SendMessage(doord, "openclose")
    end
end
function timer_handler3()
    doora=enigma.GetNamedObject("door8")
    doorb=enigma.GetNamedObject("door11")
    doorc=enigma.GetNamedObject("door14")
    doord=enigma.GetNamedObject("door3")
    if mytimer == 0 then
        SendMessage(doora, "openclose")
        SendMessage(doorb, "openclose")
    end
    if mytimer == 1 then
        SendMessage(doorc, "openclose")
        SendMessage(doord, "openclose")
    end
end
function timer_handler4()
    doora=enigma.GetNamedObject("door6")
    doorb=enigma.GetNamedObject("door9")
    doorc=enigma.GetNamedObject("door12")
    doord=enigma.GetNamedObject("door15")
    if mytimer == 0 then
        SendMessage(doora, "openclose")
        SendMessage(doorb, "openclose")
    end
    if mytimer == 1 then
        SendMessage(doorc, "openclose")
        SendMessage(doord, "openclose")
    end
    mytimer = mytimer + 1
    if mytimer == 2 then
        mytimer = 0
    end
end

doorv(3,2,  {name="door1"})
doorv(7,2,  {name="door2"})
doorv(12,2, {name="door3"})
doorv(16,2, {name="door4"})
doorv(7,6,  {name="door5"})
doorv(12,6, {name="door6"})
doorh(17,8, {name="door7"})
doorv(7,10, {name="door8"})
doorv(12,10,{name="door9"})
doorh(2,4, {name="door10"})
doorh(9,4, {name="door11"})
doorh(14,4,{name="door12"})
doorh(17,4,{name="door13"})
doorh(2,8, {name="door14"})
doorh(10,8,{name="door15"})
doorh(14,8,{name="door16"})

draw_stones("st-greenbrown", {19,1}, {0,1},11)
draw_stones("st-greenbrown", {4,4}, {1,0},5)
draw_stones("st-greenbrown", {10,4}, {1,0},4)
draw_stones("st-greenbrown", {15,4}, {1,0},2)
draw_stones("st-greenbrown", {4,8}, {1,0},6)
draw_stones("st-greenbrown", {11,8}, {1,0},3)
draw_stones("st-greenbrown", {15,8}, {1,0},2)
draw_stones("st-greenbrown", {3,3}, {0,1},9)
draw_stones("st-greenbrown", {16,3}, {0,1},9)
set_stones("st-greenbrown", {{3,1},{7,1},{12,1},{16,1},{1,4},
                            {18,4},{7,5},{12,5},{1,8}})
set_stones("st-greenbrown", {{7,3},{7,7},{7,9},{12,3},{12,7},
                            {7,11},{12,11},{12,9},{18,8}})

set_actor("ac-blackball", 9.5, 6.5)















