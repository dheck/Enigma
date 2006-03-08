--
-- A level for Enigma
--
-- Copyright (c) 2003 Siegfried Fennig
-- Licensed under the GPL version 2.

levelw = 20
levelh = 37

create_world(levelw, levelh)
draw_border("st-rock1")
fill_floor("fl-normal")

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c == "r" then
         set_stone("st-rock1",i-1,line)
      elseif c == "1" then
         set_floor("fl-gradient",  i-1,  line, {type=1})
      elseif c == "2" then
         set_floor("fl-gradient",  i-1,  line, {type=2})
      elseif c == "3" then
         set_floor("fl-gradient",  i-1,  line, {type=21})
      elseif c == "4" then
         set_floor("fl-gradient",  i-1,  line, {type=22})
      elseif c == "a" then
         set_actor("ac-blackball", i-1,line+.5)
        end
    end
end
--              01234567890123456789
renderLine(00, "                    ")
renderLine(01, " rrrrrr333333rrrrrr ")
renderLine(02, " rr rrr333333rrr rr ")
renderLine(03, " r r rr333333rr r r ")
renderLine(04, " rr rrr111111rrr rr ")
renderLine(05, " rrrr          rrrr ")
renderLine(06, " 22222r222222r22222 ")
renderLine(07, " 44444r444444r44444 ")
renderLine(08, " 44444r444444r44444 ")
renderLine(09, " 44444r444444r44444 ")
renderLine(10, " 44444r444444r44444 ")
renderLine(11, " 44444r444444r44444 ")
renderLine(12, " 33333r333333r33333 ")
renderLine(13, " 33333r333333r33333 ")
renderLine(14, " 33333r333333r33333 ")
renderLine(15, " 33333r333333r33333 ")
renderLine(16, " 33333r333333r33333 ")
renderLine(17, " 33333r333333r33333 ")
renderLine(18, " 11111r111111r11111 ")
renderLine(19, "      r   a  r      ")
renderLine(20, " 22222r222222r22222 ")
renderLine(21, " 44444r444444r44444 ")
renderLine(22, " 44444r444444r44444 ")
renderLine(23, " 44444r444444r44444 ")
renderLine(24, " 44444r444444r44444 ")
renderLine(25, " 44444r444444r44444 ")
renderLine(26, " 44444r444444r44444 ")
renderLine(27, " 33333r      r33333 ")
renderLine(28, " 33333r      r33333 ")
renderLine(29, " 33333rrrrrrrr33333 ")
renderLine(30, " 33333rrr  rrr33333 ")
renderLine(31, " 33333rr rr rr33333 ")
renderLine(32, " 33333rrr  rrr33333 ")
renderLine(33, " 11111rrrrrrrr11111 ")
renderLine(34, "                    ")
renderLine(35, " 222222222222222222 ")
renderLine(36, "                    ")
--              01234567890123456789

set_stone("st-oxyd", 3, 2,{color="0", flavor="d", name="ox1"})
set_stone("st-oxyd", 3, 4,{color="1", flavor="d", name="ox2"})
set_stone("st-oxyd", 2, 3,{color="2", flavor="d", name="ox3"})
set_stone("st-oxyd", 4, 3,{color="3", flavor="d", name="ox4"})
set_stone("st-oxyd",16, 2,{color="4", flavor="d", name="ox5"})
set_stone("st-oxyd",16, 4,{color="6", flavor="d", name="ox6"})
set_stone("st-oxyd",15, 3,{color="5", flavor="d", name="ox7"})
set_stone("st-oxyd",17, 3,{color="0", flavor="d", name="ox8"})
set_stone("st-oxyd", 9,30,{color="1", flavor="d", name="ox9"})
set_stone("st-oxyd",10,30,{color="2", flavor="d", name="ox10"})
set_stone("st-oxyd", 9,32,{color="3", flavor="d", name="ox11"})
set_stone("st-oxyd",10,32,{color="5", flavor="d", name="ox12"})
set_stone("st-oxyd", 8,31,{color="6", flavor="d", name="ox13"})
set_stone("st-oxyd",11,31,{color="4", flavor="d", name="ox14"})

hitcounter = 0

set_stone( "st-fourswitch", 8, 3, {action="callback", target="func1"})

function func1()
    oxa=enigma.GetNamedObject("ox4")
    oxb=enigma.GetNamedObject("ox2")
    oxc=enigma.GetNamedObject("ox3")
    oxd=enigma.GetNamedObject("ox1")
        if hitcounter == 0 then
    SendMessage(oxa, "trigger")
    end
        if hitcounter == 1 then
    SendMessage(oxb, "trigger")
    end
        if hitcounter == 2 then
    SendMessage(oxc, "trigger")
    end
        if hitcounter == 3 then
    SendMessage(oxd, "trigger")
    end
    hitcounter = hitcounter + 1
    if hitcounter ==  4 then
        hitcounter = 0
    end
end

set_stone( "st-fourswitch",11, 3, {action="callback", target="func2"})

function func2()
    oxa=enigma.GetNamedObject("ox8")
    oxb=enigma.GetNamedObject("ox6")
    oxc=enigma.GetNamedObject("ox7")
    oxd=enigma.GetNamedObject("ox5")
        if hitcounter == 0 then
    SendMessage(oxa, "trigger")
    end
        if hitcounter == 1 then
    SendMessage(oxb, "trigger")
    end
        if hitcounter == 2 then
    SendMessage(oxc, "trigger")
    end
        if hitcounter == 3 then
    SendMessage(oxd, "trigger")
    end
    hitcounter = hitcounter + 1
    if hitcounter ==  4 then
        hitcounter = 0
    end
end

set_stone( "st-fourswitch", 3,34, {action="callback", target="func3"})

function func3()
    oxa=enigma.GetNamedObject("ox14")
    oxb=enigma.GetNamedObject("ox11")
    oxc=enigma.GetNamedObject("ox13")
    oxd=enigma.GetNamedObject("ox9")
        if hitcounter == 0 then
    SendMessage(oxa, "trigger")
    end
        if hitcounter == 1 then
    SendMessage(oxb, "trigger")
    end
        if hitcounter == 2 then
    SendMessage(oxc, "trigger")
    end
        if hitcounter == 3 then
    SendMessage(oxd, "trigger")
    end
    hitcounter = hitcounter + 1
    if hitcounter ==  4 then
        hitcounter = 0
    end
end

set_stone( "st-fourswitch",16,34, {action="callback", target="func4"})

function func4()
    oxa=enigma.GetNamedObject("ox14")
    oxb=enigma.GetNamedObject("ox12")
    oxc=enigma.GetNamedObject("ox13")
    oxd=enigma.GetNamedObject("ox10")
        if hitcounter == 0 then
    SendMessage(oxa, "trigger")
    end
        if hitcounter == 1 then
    SendMessage(oxb, "trigger")
    end
        if hitcounter == 2 then
    SendMessage(oxc, "trigger")
    end
        if hitcounter == 3 then
    SendMessage(oxd, "trigger")
    end
    hitcounter = hitcounter + 1
    if hitcounter ==  4 then
        hitcounter = 0
    end
end










