-- Copyright (c) 2003 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Puzzling Controls

levelw=25
levelh=15

create_world( levelw, levelh)

fill_floor("fl-hay", 0,0,levelw,levelh)

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
        local c = strsub( pattern, i, i)
        if c =="#" then
            set_stone( "st-greenbrown", i-1, line)
        elseif c =="@" then
            set_stone( "st-glass", i-1, line)
            fill_floor("fl-ice_001", i-1,line, 1,1)
        elseif c == "g" then
            set_stone("st-oxyd", i-1, line,{color="0",name="o1"})
        elseif c == "h" then
            set_stone("st-oxyd", i-1, line,{color="0",name="o2"})
        elseif c == "i" then
            set_stone("st-oxyd", i-1, line,{color="1",name="o3"})
        elseif c == "j" then
            set_stone("st-oxyd", i-1, line,{color="1",name="o4"})
        elseif c == "k" then
            set_stone("st-oxyd", i-1, line,{color="2",name="o5"})
        elseif c == "l" then
            set_stone("st-oxyd", i-1, line,{color="2",name="o6"})
        elseif c == "m" then
            set_stone("st-oxyd", i-1, line,{color="3",name="o7"})
        elseif c == "n" then
            set_stone("st-oxyd", i-1, line,{color="3",name="o8"})
        elseif c == "p" then
            set_stone("st-oxyd", i-1, line,{color="4",name="o9"})
        elseif c == "q" then
            set_stone("st-oxyd", i-1, line,{color="4",name="o10"})
        elseif c == "r" then
            set_stone("st-oxyd", i-1, line,{color="5",name="o11"})
        elseif c == "s" then
            set_stone("st-oxyd", i-1, line,{color="5",name="o12"})
        elseif c == "t" then
            set_stone("st-oxyd", i-1, line,{color="6",name="o13"})
        elseif c == "u" then
            set_stone("st-oxyd", i-1, line,{color="6",name="o14"})
        elseif c == "v" then
            set_stone("st-oxyd", i-1, line,{color="7",name="o15"})
        elseif c == "w" then
            set_stone("st-oxyd", i-1, line,{color="7",name="o16"})
        elseif c == "!" then
            abyss(i-1,line)
            --	           	fill_floor("fl-water", i-1,line, 1,1)
        elseif c=="z" then
            set_actor("ac-blackball", i-.5,line+.5)
        elseif c == "A" then
            set_stone("st-door_a",i-1,line,{name="gate1"})
        elseif c == "B" then
            set_stone("st-door_a",i-1,line,{name="gate2"})
        elseif c == "C" then
            set_stone("st-door_a",i-1,line,{name="gate3"})
        elseif c == "D" then
            set_stone("st-door_a",i-1,line,{name="gate4"})
        elseif c == "E" then
            set_stone("st-door_a",i-1,line,{name="gate5"})
        elseif c == "F" then
            set_stone("st-door_a",i-1,line,{name="gate6"})
        elseif c=="a" then
            set_item("it-trigger", i-1,line, {action="openclose", target="gate1"})
        elseif c=="b" then
            set_item("it-trigger", i-1,line, {action="openclose", target="gate2"})
        elseif c=="c" then
            set_item("it-trigger", i-1,line, {action="openclose", target="gate3"})
        elseif c=="d" then
            set_item("it-trigger", i-1,line, {action="openclose", target="gate4"})
        elseif c=="e" then
            set_item("it-trigger", i-1,line, {action="openclose", target="gate5"})
        elseif c=="f" then
            set_item("it-trigger", i-1,line, {action="openclose", target="gate6"})
        elseif c=="1" then
            set_stone("st-switch", i-1,line, {action="callback",target="funccU"})
        elseif c=="2" then
            set_stone("st-switch", i-1,line, {action="callback",target="funccR"})
        elseif c=="3" then
            set_stone("st-switch", i-1,line, {action="callback",target="funccD"})
        elseif c=="4" then
            set_stone("st-switch", i-1,line, {action="callback",target="funccL"})
        elseif c=="5" then
            set_stone("st-switch", i-1,line, {action="callback",target="funccP"})
        elseif c=="R" then
            set_stone("st-switch", i-1,line, {action="callback",target="funccX"})
        elseif c=="G" then
            set_stone("st-switch", i-1,line, {action="callback",target="funccU2"})
        elseif c=="H" then
            set_stone("st-switch", i-1,line, {action="callback",target="funccR2"})
        elseif c=="I" then
            set_stone("st-switch", i-1,line, {action="callback",target="funccD2"})
        elseif c=="J" then
            set_stone("st-switch", i-1,line, {action="callback",target="funccL2"})
        elseif c=="K" then
            set_stone("st-switch", i-1,line, {action="callback",target="funccP2"})
        elseif c == "=" then
            puzzle(i-1,line,PUZ_0101)
        elseif c == "$" then
            puzzle(i-1,line,PUZ_1010)
        elseif c == "`" then
            puzzle(i-1,line,PUZ_0011)
        elseif c == "/" then
            puzzle(i-1,line,PUZ_0110)
        elseif c == "%" then
            puzzle(i-1,line,PUZ_1001)
        elseif c == "L" then
            puzzle(i-1,line,PUZ_1100)
	end
    end	
end

-- Floor:  " "
-- Border: "#"
-- Oxyd:   "o"

renderLine(00,"/======`############")
renderLine(01,"$a#     #ghij#  G  #")
renderLine(02,"$       #klmn# J#H #")
renderLine(03,"$      b#pqrs#  I  #")
renderLine(04,"$       #tuvw#K    #")
renderLine(05,"$   c   ##########F#")
renderLine(06,"$       #        #E#")
renderLine(07,"$  d    # z  1   #D#")
renderLine(08,"$       #        #C#")
renderLine(09,"$     e #  4 5 2 #B#")
renderLine(10,"$       #        #A#")
renderLine(11,"$ f     #R   3     #")
renderLine(12,"L======%############")
renderLine(13,"####################")

oxyd_shuffle()

xx=4
yy=6
xx2=10
yy2=2

direc=0
mv=0

function funccU()
    if yy<2 then
        if xx==7 then
            yy=11
            move()
        end
    else
        if xx<2 or xx>2 or yy<2 or yy>1 then
            yy=yy-1
            move()
        end
    end
end

function funccR()
    if xx<7 then
        if xx<1 or xx>1 or yy<1 or yy>1 then
            xx=xx+1
            move()
        end
    end
end

function funccD()
    if yy>10 then
        if xx==7 then
            yy=1
            move()
        end
    else
        yy=yy+1
        move()
    end
end

function funccL()
    if xx>1 then
        if xx<3 or xx>3 or yy<1 or yy>1 then
            xx=xx-1
            move()
        end
    end
end

pla=0
function funccP()
    if direc==0 then
        placx=xx
        placy=yy-1
    elseif direc==1 then
        placx=xx+1
        placy=yy
    elseif direc==2 then
        placx=xx
        placy=yy+1
    elseif direc==3 then
        placx=xx-1
        placy=yy
    end
    if pla<6 then
        if placx>0 and placx<8 and placy>0 and placy<12 then
            if placx<2 or placx>2 or placy<1 or placy>1 then
                set_stone( "st-rock1", placx, placy)
                pla=pla+1
            end
        end
    end
end

function funccX()
    for i=1,7 do
        for j=1,11 do
            if i<2 or i>2 or j<1 or j>1 then
                enigma.KillStone(i,j)
            end
        end
    end
    pla=0
    xx=4
    yy=6
    direc=0
end

function move()
    if direc<3 then
        direc=direc+1
    else
        direc=0
    end
end

function funccU2()
    if mv==0 then
        if yy2>1 then
            yy2=yy2-1
            move2()
        end
    elseif mv==1 then
        if yy2>2 then
            yy2=yy2-2
            move2()
        end
    end
end

function funccR2()
    if mv==0 then
        if xx2<12 then
            xx2=xx2+1
            move2()
        end
    elseif mv==1 then
        if xx2<11 then
            xx2=xx2+2
            move2()
        end
    end
end

function funccD2()
    if mv==0 then
        if yy2<4 then
            yy2=yy2+1
            move2()
        end
    elseif mv==1 then
        if yy2<3 then
            yy2=yy2+2
            move2()
        end
    end
end

function funccL2()
    if mv==0 then
        if xx2>9 then
            xx2=xx2-1
            move2()
        end
    elseif mv==1 then
        if xx2>10 then
            xx2=xx2-2
            move2()
        end
    end
end

function move2()
    if mv==0 then
        mv=1
    elseif mv==1 then
        mv=0
    end
end

function funccP2()
    if yy2==1 then
        if xx2==9 then
            ox="o1"
        elseif xx2==10 then
            ox="o2"
        elseif xx2==11 then
            ox="o3"
        elseif xx2==12 then
            ox="o4"
        end
    elseif yy2==2 then
        if xx2==9 then
            ox="o5"
        elseif xx2==10 then
            ox="o6"
        elseif xx2==11 then
            ox="o7"
        elseif xx2==12 then
            ox="o8"
        end
    elseif yy2==3 then
        if xx2==9 then
            ox="o9"
        elseif xx2==10 then
            ox="o10"
        elseif xx2==11 then
            ox="o11"
        elseif xx2==12 then
            ox="o12"
        end
    elseif yy2==4 then
        if xx2==9 then
            ox="o13"
        elseif xx2==10 then
            ox="o14"
        elseif xx2==11 then
            ox="o15"
        elseif xx2==12 then
            ox="o16"
        end
    end
    SendMessage(ox, "trigger")
end
