--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 20
levelh = 13

create_world(levelw, levelh)
draw_border("st-fakeoxyd")
fill_floor("fl-dunes")

oxyd (2,3)
oxyd (4,5)
oxyd (6,9)
oxyd (15,5)
oxyd (13,7)
oxyd (17,7)
oxyd_shuffle()

set_stones("st-death", {{4,3},{6,3},{8,3},{2,5},{6,5},{8,5},{2,7}})
set_stones("st-death", {{4,7},{6,7},{8,7},{2,9},{4,9},{8,9}})
set_stones("st-death", {{11,3},{13,3},{15,3},{17,3},{11,5},{13,5},{17,5}})
set_stones("st-death", {{11,7},{15,7},{11,9},{13,9},{15,9},{17,9}})

set_item("it-hollow", 3,3)
set_item("it-hollow", 5,3)
set_item("it-hollow", 7,3)
set_item("it-hollow", 3,4)
set_item("it-hollow", 5,4)
set_item("it-hollow", 7,4)
set_item("it-hollow", 3,5)
set_item("it-hollow", 5,5)
set_item("it-hollow", 7,5)
set_item("it-hollow", 3,6)
set_item("it-hollow", 5,6)
set_item("it-hollow", 7,6)
set_item("it-hollow", 3,7)
set_item("it-hollow", 5,7)
set_item("it-hollow", 7,7)
set_item("it-hollow", 3,8)
set_item("it-hollow", 5,8)
set_item("it-hollow", 7,8)
set_item("it-hollow", 3,9)
set_item("it-hollow", 5,9)
set_item("it-hollow", 7,9)
set_item("it-hollow", 11,4)
set_item("it-hollow", 12,4)
set_item("it-hollow", 13,4)
set_item("it-hollow", 14,4)
set_item("it-hollow", 15,4)
set_item("it-hollow", 16,4)
set_item("it-hollow", 17,4)
set_item("it-hollow", 11,6)
set_item("it-hollow", 12,6)
set_item("it-hollow", 13,6)
set_item("it-hollow", 14,6)
set_item("it-hollow", 15,6)
set_item("it-hollow", 16,6)
set_item("it-hollow", 17,6)
set_item("it-hollow", 11,8)
set_item("it-hollow", 12,8)
set_item("it-hollow", 13,8)
set_item("it-hollow", 14,8)
set_item("it-hollow", 15,8)
set_item("it-hollow", 16,8)
set_item("it-hollow", 17,8)

set_item( "it-hollow", 2,4, {name="h1"})
set_item( "it-hollow", 4,4, {name="h2"})
set_item( "it-hollow",6,4, {name="h3"})
set_item( "it-hollow",8,4, {name="h4"})
set_item( "it-hollow", 2,6, {name="h5"})
set_item( "it-hollow", 4,6, {name="h6"})
set_item( "it-hollow",6,6, {name="h7"})
set_item( "it-hollow",8,6, {name="h8"})
set_item( "it-hollow", 2,8, {name="h9"})
set_item( "it-hollow", 4,8, {name="h10"})
set_item( "it-hollow",6,8, {name="h11"})
set_item( "it-hollow",8,8, {name="h12"})
set_item( "it-hollow", 12,3, {name="h13"})
set_item( "it-hollow", 14,3, {name="h14"})
set_item( "it-hollow",16,3, {name="h15"})
set_item( "it-hollow",12,5, {name="h16"})
set_item( "it-hollow", 14,5, {name="h17"})
set_item( "it-hollow", 16,5, {name="h18"})
set_item( "it-hollow",12,7, {name="h19"})
set_item( "it-hollow",14,7, {name="h20"})
set_item( "it-hollow", 16,7, {name="h21"})
set_item( "it-hollow", 12,9, {name="h22"})
set_item( "it-hollow",14,9, {name="h23"})
set_item( "it-hollow",16,9, {name="h24"})

set_stone( "st-timer", 4, 12, {action="callback", target="th1"})
set_stone( "st-timer", 5, 12, {action="callback", target="th2"})
set_stone( "st-timer", 9, 12, {action="callback", target="th3"})
set_stone( "st-timer", 10, 12, {action="callback", target="th4"})
set_stone( "st-timer", 14, 12, {action="callback", target="th5"})
set_stone( "st-timer", 15, 12, {action="callback", target="th6"})

timer = 0

function th1()
    if timer == 0 or timer == 1 then
        SendMessage("h1", "trigger")
        SendMessage("h5", "trigger")
        SendMessage("h9", "trigger")
        SendMessage("h13", "trigger")
    end
end

function th2()
    if timer == 1 or timer==2 then
        SendMessage("h2", "trigger")
        SendMessage("h6", "trigger")
        SendMessage("h10", "trigger")
        SendMessage("h16", "trigger")
    end
end

function th3()
    if timer == 2 or timer==3 then
        SendMessage("h3", "trigger")
        SendMessage("h7", "trigger")
        SendMessage("h11", "trigger")
        SendMessage("h19", "trigger")
    end
end

function th4()
    if timer == 3 or timer==4 then
        SendMessage("h4", "trigger")
        SendMessage("h8", "trigger")
        SendMessage("h12", "trigger")
        SendMessage("h22", "trigger")
    end
end

function th5()
    if timer == 0 then
        SendMessage("h14", "trigger")
        SendMessage("h15", "trigger")
    end
    if timer == 1 then
        SendMessage("h14", "trigger")
        SendMessage("h15", "trigger")
        SendMessage("h17", "trigger")
        SendMessage("h18", "trigger")
    end
    if timer == 2 then
        SendMessage("h17", "trigger")
        SendMessage("h18", "trigger")
    end
end

function th6()
    if timer == 2 then
        SendMessage("h20", "trigger")
        SendMessage("h21", "trigger")
    end
    if timer == 3 then
        SendMessage("h20", "trigger")
        SendMessage("h21", "trigger")
        SendMessage("h23", "trigger")
        SendMessage("h24", "trigger")
    end
    if timer == 4 then
        SendMessage("h23", "trigger")
        SendMessage("h24", "trigger")
    end
    timer = timer + 1
    if timer == 5 then
        timer = 0
    end
end

set_actor("ac-blackball", 10,6.5)











