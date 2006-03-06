-- Copyright (c) 2004 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Fire Safety

levelw=21
levelh=13

create_world( levelw, levelh)
enigma.ConserveLevel=FALSE

fill_floor("fl-wood", 0,0,levelw,levelh)

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
        local c = strsub( pattern, i, i)
        if c =="#" then
            set_stone( "st-greenbrown", i-1, line)
        elseif c == "o" then
            oxyd( i-1, line)
        elseif c == "*" then
            set_stone( "st-brownie", i-1, line)
        elseif c == "!" then
            abyss(i-1,line)
        elseif c == "~" then
            set_floor("fl-water",i-1,line)
        elseif c=="z" then
            set_actor("ac-blackball", i-1,line+.5, {player=0})
            set_item("it-burnable",i-1,line)
        elseif c == "g" then
            draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
            set_item("it-burnable_fireproof",i-1,line)
        elseif c=="+" then
            set_stone( "st-wood", i-1, line)
            set_item("it-burnable",i-1,line)
        elseif c=="=" then
            set_floor("fl-space",i-1,line)
        elseif c=="a" then
            set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc1"})
        elseif c=="b" then
            set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc2"})
        elseif c=="c" then
            set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc3"})
        elseif c=="d" then
            set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc4"})
        elseif c=="t" then
            set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc5"})
        elseif c=="u" then
            set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc5"})
        elseif c=="v" then
            set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc5"})
        elseif c=="w" then
            set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc5"})
        elseif c=="q" then
            set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc5"})
        elseif c=="A" then
            set_item("it-burnable",i-1,line,{name="b1"})
        elseif c=="B" then
            set_item("it-burnable",i-1,line,{name="b2"})
        elseif c=="C" then
            set_item("it-burnable",i-1,line,{name="b3"})
        elseif c=="D" then
            set_item("it-burnable",i-1,line,{name="b4"})
        elseif c=="T" then
            set_item("it-burnable",i-1,line,{name="b5"})
        elseif c=="U" then
            set_item("it-burnable",i-1,line,{name="b6"})
        elseif c=="V" then
            set_item("it-burnable",i-1,line,{name="b7"})
        elseif c=="W" then
            set_item("it-burnable",i-1,line,{name="b8"})
        elseif c=="P" then
            set_item("it-burnable",i-1,line,{name="b9"})
        elseif c=="Q" then
            set_item("it-burnable",i-1,line,{name="b10"})
        elseif c=="R" then
            set_item("it-burnable",i-1,line,{name="b11"})
        elseif c=="S" then
            set_item("it-burnable",i-1,line,{name="b12"})
        elseif c=="F" then
            set_item("it-extinguisher", i-1,line, {load=1})
        elseif c=="f" then
            set_item("it-extinguisher", i-1,line, {load=2})
        elseif c==" " then
            set_item("it-burnable",i-1,line)
        elseif c=="r" then
            set_item("it-odometer",i-1,line)
        end
    end	
end

renderLine(00,"######o######o######")
renderLine(01,"#Tt ##A##PQ##B## uU#")
renderLine(02,"#tt  #g#qqqq#g#  uu#")
renderLine(03,"#  + # #    # # +  #")
renderLine(04,"#    #a#    #b#    #")
renderLine(05,"#                  #")
renderLine(06,"#r        z       f#")
renderLine(07,"#                  #")
renderLine(08,"#    #c#    #d#    #")
renderLine(09,"#  + # #    # # +  #")
renderLine(10,"#vv  #g#qqqq#g#  ww#")
renderLine(11,"#Vv ##C##RS##D## wW#")
renderLine(12,"######o######o######")

oxyd_shuffle()

ff1=0
ff2=0
ff3=0
ff4=0
ff5=0

function funcc1()
    if ff1==0 and ff2==1 and ff3==1 and ff4==1 then
        SendMessage("b1","ignite")
        abyss(6,1)
    end
    ff1=1
end

function funcc2()
    if ff1==1 and ff2==0 and ff3==1 and ff4==1 then
        SendMessage("b2","ignite")
        abyss(13,1)
    end
    ff2=1
end

function funcc3()
    if ff1==1 and ff2==1 and ff3==0 and ff4==1 then
        SendMessage("b3","ignite")
        abyss(6,11)
    end
    ff3=1
end

function funcc4()
    if ff1==1 and ff2==1 and ff3==1 and ff4==0 then
        SendMessage("b4","ignite")
        abyss(13,11)
    end
    ff4=1
end

function funcc5()
    if ff5==0 then
        SendMessage("b5","ignite")
        SendMessage("b6","ignite")
        SendMessage("b7","ignite")
        SendMessage("b8","ignite")
        SendMessage("b9","ignite")
        SendMessage("b10","ignite")
        SendMessage("b11","ignite")
        SendMessage("b12","ignite")
        ff5=1
    end
end














