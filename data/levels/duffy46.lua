-- Copyright (c) 2003 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: No Jumping Necessary

levelw=39
levelh=13

create_world( levelw, levelh)

fill_floor("fl-hay", 0,0,levelw,levelh)
enigma.ConserveLevel=FALSE
enigma.Brittleness=0

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
        local c = strsub( pattern, i, i)
        if c =="#" then
            set_stone( "st-greenbrown", i-1, line)
            abyss(i-1,line)
        elseif c =="X" then
            set_stone( "st-death", i-1, line)
        elseif c =="%" then
            set_stone( "st-actorimpulse", i-1, line)
        elseif c == "o" then
            set_stone("st-oxyd", i-1, line,{color="0"})
            abyss(i-1,line)
        elseif c == "*" then
            set_stone( "st-brownie", i-1, line)
        elseif c == "!" then
            abyss(i-1,line)
            --			fill_floor("fl-water", i-1,line, 1,1)
        elseif c == "~" then
            --			abyss(i-1,line)
            fill_floor("fl-water", i-1,line, 1,1)
        elseif c == " " then
            abyss(i-1,line)
        elseif c=="z" then
            set_actor("ac-blackball", i,line+1, {name="ac0"})
        elseif c == "g" then
            draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
        elseif c=="+" then
            set_stone( "st-wood", i-1, line)
        elseif c=="=" then
            set_floor("fl-space",i-1,line)
        elseif c == "b" then
            yy1( "black",  i-1, line)
        elseif c == "d" then --1-d
            set_floor("fl-gradient",  i-1,  line, {type=1})
        elseif c == "u" then --2-u
            set_floor("fl-gradient",  i-1,  line, {type=2})
        elseif c == "r" then --3-r
            set_floor("fl-gradient",  i-1,  line, {type=3})
        elseif c == "l" then --4-l
            set_floor("fl-gradient",  i-1,  line, {type=4})
        elseif c == "1" then --ur
            set_floor("fl-gradient",  i-1,  line, {type=11})
        elseif c == "3" then --dl
            set_floor("fl-gradient",  i-1,  line, {type=9})
        elseif c == "7" then --dr
            set_floor("fl-gradient",  i-1,  line, {type=12})
        elseif c == "9" then --ul
            set_floor("fl-gradient",  i-1,  line, {type=10})
        elseif c=="A" then
            set_item("it-crack3",i-1,line)
        elseif c=="B" then
            set_item("it-crack2",i-1,line)
        elseif c=="C" then
            set_item("it-crack1",i-1,line)
        elseif c == "D" then
            set_item("it-key_a",i-1,line)
        elseif c == "f" then
            set_item("it-floppy",i-1,line)
        elseif c=="M" then
            set_stone("st-floppy", i-1,line, {action="callback", target="funcc1"})
            abyss(i-1,line)
        elseif c=="N" then
            set_stone("st-key_a", i-1,line, {action="callback", target="funcc2"})
            abyss(i-1,line)
        elseif c=="O" then
            set_stone("st-key_a", i-1,line, {action="callback", target="funcc3"})
            abyss(i-1,line)
        elseif c=="P" then
            set_stone("st-key_a", i-1,line, {action="callback", target="funcc4"})
            abyss(i-1,line)
        elseif c=="Q" then
            set_stone("st-key_a", i-1,line, {action="callback", target="funcc5"})
            abyss(i-1,line)
        elseif c=="R" then
            set_stone("st-key_a", i-1,line, {action="callback", target="funcc6"})
            abyss(i-1,line)
        elseif c=="S" then
            set_stone("st-key_a", i-1,line, {action="callback", target="funcc7"})
            abyss(i-1,line)
        elseif c=="T" then
            set_stone("st-floppy", i-1,line, {action="callback", target="funcc8"})
            abyss(i-1,line)
        elseif c=="U" then
            set_stone("st-key_a", i-1,line, {action="callback", target="funcc9"})
            abyss(i-1,line)
        elseif c=="F" then
            set_floor("fl-bridge",i-1,line,{name="bridge1"})
        elseif c=="G" then
            set_floor("fl-bridge",i-1,line,{name="bridge2"})
        elseif c=="H" then
            set_floor("fl-bridge",i-1,line,{name="bridge3"})
        elseif c=="I" then
            set_floor("fl-bridge",i-1,line,{name="bridge4"})
        elseif c=="J" then
            set_floor("fl-bridge",i-1,line,{name="bridge5"})
        elseif c=="K" then
            set_floor("fl-bridge",i-1,line,{name="bridge6"})
        elseif c=="L" then
            set_floor("fl-bridge",i-1,line,{name="bridge7"})
        elseif c=="x" then
            set_floor("fl-hay",i-1,line)
        end
    end	
end

function yy1( color, x, y)
    stone = format( "st-%s4", color)
    set_stone( stone, x, y)
end

renderLine(00,"#######################################")
renderLine(01,"#                  #       o        o #")
renderLine(02,"# AADAAAxzxx fAAxx #oAAAxAAABBxxxAAAA #")
renderLine(03,"# A     xxxxAA  xx # A  x     A     A #")
renderLine(04,"# xxAAA A       xxI# A  AAAxxAA AAA A #")
renderLine(05,"# xxA A AfAAAA  HAJ#xx   A B  o AoA A #")
renderLine(06,"# A A D    A ADAGAKLxx AAA xBBo A A A #")
renderLine(07,"# A DAAAxxxx  UAFAM#xx A o B    A Axx #")
renderLine(08,"# D A   xxxxAA xxxN# AAA   xxAAAx  xx #")
renderLine(09,"# A A      A D xxxO# A   Axx A AxA xx #")
renderLine(10,"# AAxxAAADAA AAxxxP# AAAAA   AAA AAA  #")
renderLine(11,"#             TSRQ # o       o    o   #")
renderLine(12,"#######################################")

oxyd_shuffle()

ff1=0
function funcc1()
    ff1 = 1-ff1
    funcc10()
end

ff2=0
function funcc2()
    ff2 = 1-ff2
    funcc10()
end

ff3=0
function funcc3()
    ff3 = 1-ff3
   funcc10()
end

ff4=0
function funcc4()
    ff4 = 1-ff4
    funcc10()
end

ff5=0
function funcc5()
    ff5 = 1-ff5
    funcc10()
end

ff6=0
function funcc6()
    ff6 = 1-ff6
    funcc10()
end

ff7=0
function funcc7()
    ff7 = 1-ff7
    funcc10()
end

ff8=0
function funcc8()
    ff8 = 1-ff8
    funcc10()
end

ff9=0
function funcc9()
    ff9 = 1-ff9
    funcc10()
end

ff10=0
function funcc10()
    local msg = nil
    if ff1==1 and ff2==1 and ff3==1 and ff4==1 and ff5==1 and ff6==1 and ff7==1 and ff8==1 and ff9==1 and ff10==0 then
        ff10=1
        msg = "close"
    elseif ff10==1 then
        ff10=0
        msg = "open"
    end
    if msg then
        SendMessage("bridge1", msg)
        SendMessage("bridge2", msg)
        SendMessage("bridge3", msg)
        SendMessage("bridge4", msg)
        SendMessage("bridge5", msg)
        SendMessage("bridge6", msg)
        SendMessage("bridge7", msg)
    end
end