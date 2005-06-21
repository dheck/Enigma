-- Copyright (c) 2004 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Alien Glyphs 3

rooms_wide=3
rooms_high=3

levelw=1+(19*rooms_wide)
levelh=1+(12*rooms_high)

create_world( levelw, levelh)

fill_floor("fl-bluegreen", 0,0,levelw,levelh)

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
        local c = strsub( pattern, i, i)
        if c =="#" then
            set_stone( "st-greenbrown", i-1, line)
        elseif c =="A" then
            set_stone( "st-blue-sand", i-1, line)
        elseif c =="B" then
            set_stone( "st-yellow", i-1, line)
        elseif c =="C" then
            set_stone( "st-marble", i-1, line)
        elseif c =="D" then
            set_stone( "st-rock1", i-1, line)
        elseif c =="E" then
            set_stone( "st-rock4", i-1, line)
        elseif c =="F" then
            set_stone( "st-rock5", i-1, line)
        elseif c =="G" then
            set_stone( "st-rock6", i-1, line)
        elseif c =="H" then
            set_stone( "st-rock2", i-1, line)
        elseif c =="I" then
            set_stone( "st-rock3", i-1, line)
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
        elseif c == "g" then
            draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
        elseif c=="+" then
            set_stone( "st-wood", i-1, line)
        elseif c=="=" then
            set_floor("fl-space",i-1,line)
        elseif c=="1" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc1"})
        elseif c=="2" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc2"})
        elseif c=="3" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc3"})
        elseif c=="4" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc4"})
        elseif c=="5" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc5"})
        elseif c=="6" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc6"})
        elseif c=="7" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc7"})
        elseif c=="8" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc8"})
        elseif c=="9" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc9"})
        elseif c=="P" then
            doorv( i-1,line, {name="door1"})
        elseif c=="Q" then
            doorv( i-1,line, {name="door2"})
        elseif c=="R" then
            doorh( i-1,line, {name="door3"})
        elseif c=="S" then
            doorh( i-1,line, {name="door4"})
        elseif c=="T" then
            doorh( i-1,line, {name="door5"})
        elseif c=="U" then
            doorh( i-1,line, {name="door6"})
        elseif c=="V" then
            doorv( i-1,line, {name="door7"})
        elseif c=="W" then
            doorv( i-1,line, {name="door8"})
        end
    end	
end

renderLine(00,"##########################################################")
renderLine(01,"#     #      #     #     #      #     #     #      #     #")
renderLine(02,"#  A     BB     C  #  F     II     H  #  D     GG     H  #")
renderLine(03,"#     #      #     #     #      #     #     #      #     #")
renderLine(04,"### #####  ##### ##### #####  ##### ##### #####  ##### ###")
renderLine(05,"#     #      #     #     #      #     #     #      #     #")
renderLine(06,"#  D     EE     F     D     BB     H     B     FF     F  #")
renderLine(07,"#     #      #     #     #      #     #     #      #     #")
renderLine(08,"### #####  ##### ##### #####  ##### ##### #####  ##### ###")
renderLine(09,"#     #      #     #     #      #     #     #      #     #")
renderLine(10,"#  G     HH     I  #  C     CC     E  #  G     AA     B  #")
renderLine(11,"#     #      #     #     #      #     #     #      #     #")
renderLine(12,"#########  #################  #################  #########")
renderLine(13,"#     #      #     #     #      #     #     #      #     #")
renderLine(14,"#  I     II     D  #  o  P      Q  o  #  H     BB     G  #")
renderLine(15,"#     #      #     #     #      #     #     #      #     #")
renderLine(16,"### #####  ##### #####R#####  #####S##### #####  ##### ###")
renderLine(17,"#     #      #     #     #      #     #     #      #     #")
renderLine(18,"#  H     GG     G            z           A     CC     E  #")
renderLine(19,"#     #      #     #     #      #     #     #      #     #")
renderLine(20,"### #####  ##### #####T#####  #####U##### #####  ##### ###")
renderLine(21,"#     #      #     #     #      #     #     #      #     #")
renderLine(22,"#  C     FF     G  #  o  V      W  o  #  E     HH     D  #")
renderLine(23,"#     #      #     #     #      #     #     #      #     #")
renderLine(24,"#########  #################  #################  #########")
renderLine(25,"#     #      #     #     #      #     #     #      #     #")
renderLine(26,"#  C     II     G  #  G     HH     E  #  A     AA     A  #")
renderLine(27,"#     #      #     #     #      #     #    1#     2#    3#")
renderLine(28,"### #####  ##### ##### #####  ##### ##### #####  ##### ###")
renderLine(29,"#     #      #     #     #      #     #     #      #     #")
renderLine(30,"#  G     GG     E     A     FF     I     A     AA     A  #")
renderLine(31,"#     #      #     #     #      #     #    4#     5#    6#")
renderLine(32,"### #####  ##### ##### #####  ##### ##### #####  ##### ###")
renderLine(33,"#     #      #     #     #      #     #     #      #     #")
renderLine(34,"#  I     CC     D  #  A     BB     H  #  A     AA     A  #")
renderLine(35,"#     #      #     #     #      #     #    7#     8#    9#")
renderLine(36,"##########################################################")

-- I I H
--      
-- E B A
--      
-- C F B

oxyd_shuffle()

function typechange(x,y,newtype)
    if newtype==1 then
        set_stone( "st-blue-sand", x, y)
    elseif newtype ==2 then
        set_stone( "st-yellow", x, y)
    elseif newtype ==3 then
        set_stone( "st-marble", x, y)
    elseif newtype ==4 then
        set_stone( "st-rock1", x, y)
    elseif newtype ==5 then
        set_stone( "st-rock4", x, y)
    elseif newtype ==6 then
        set_stone( "st-rock5", x, y)
    elseif newtype ==7 then
        set_stone( "st-rock6", x, y)
    elseif newtype ==8 then
        set_stone( "st-rock2", x, y)
    elseif newtype ==9 then
        set_stone( "st-rock3", x, y)
    end
end

ff1=0
type1=1
function funcc1()
    if ff1==0 then
        type1=type1+1
        if type1==10 then
            type1=1
        end
        typechange(41,26,type1)
        ff1=1
    elseif ff1==1 then
        ff1=0
    end
    funcc10()
end


ff2=0
type2=1
function funcc2()
    if ff2==0 then
        type2=type2+1
        if type2==10 then
            type2=1
        end
        typechange(47,26,type2)
        typechange(48,26,type2)
        ff2=1
    elseif ff2==1 then
        ff2=0
    end
    funcc10()
end

ff3=0
type3=1
function funcc3()
    if ff3==0 then
        type3=type3+1
        if type3==10 then
            type3=1
        end
        typechange(54,26,type3)
        ff3=1
    elseif ff3==1 then
        ff3=0
    end
    funcc10()
end

ff4=0
type4=1
function funcc4()
    if ff4==0 then
        type4=type4+1
        if type4==10 then
            type4=1
        end
        typechange(41,30,type4)
        ff4=1
    elseif ff4==1 then
        ff4=0
    end
    funcc10()
end

ff5=0
type5=1
function funcc5()
    if ff5==0 then
        type5=type5+1
        if type5==10 then
            type5=1
        end
        typechange(47,30,type5)
        typechange(48,30,type5)
        ff5=1
    elseif ff5==1 then
        ff5=0
    end
    funcc10()
end

ff6=0
type6=1
function funcc6()
    if ff6==0 then
        type6=type6+1
        if type6==10 then
            type6=1
        end
        typechange(54,30,type6)
        ff6=1
    elseif ff6==1 then
        ff6=0
    end
    funcc10()
end

ff7=0
type7=1
function funcc7()
    if ff7==0 then
        type7=type7+1
        if type7==10 then
            type7=1
        end
        typechange(41,34,type7)
        ff7=1
    elseif ff7==1 then
        ff7=0
    end
    funcc10()
end

ff8=0
type8=1
function funcc8()
    if ff8==0 then
        type8=type8+1
        if type8==10 then
            type8=1
        end
        typechange(47,34,type8)
        typechange(48,34,type8)
        ff8=1
    elseif ff8==1 then
        ff8=0
    end
    funcc10()
end

ff9=0
type9=1
function funcc9()
    if ff9==0 then
        type9=type9+1
        if type9==10 then
            type9=1
        end
        typechange(54,34,type9)
        ff9=1
    elseif ff9==1 then
        ff9=0
    end
    funcc10()
end

-- I I H
--      
-- E B A
--      
-- C F B

doorsopen=0
ff10=0
function funcc10()
    if ff10==0 then
        if doorsopen==1 then
            SendMessage("door1","close")
            SendMessage("door2","close")
            SendMessage("door3","close")
            SendMessage("door4","close")
            SendMessage("door5","close")
            SendMessage("door6","close")
            SendMessage("door7","close")
            SendMessage("door8","close")
            doorsopen=0
        end
        if type1==9 and type2==9 and type3==8 and type4==5 and type5==2 and type6==1 and type7==3 and type8==6 and type9==2 then
            if doorsopen==0 then
                SendMessage("door1","open")
                SendMessage("door2","open")
                SendMessage("door3","open")
                SendMessage("door4","open")
                SendMessage("door5","open")
                SendMessage("door6","open")
                SendMessage("door7","open")
                SendMessage("door8","open")
                doorsopen=1
            end
        end
        ff10=1
    elseif ff10==1 then
        ff10=0
    end
end