-- Copyright (c) 2004 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Alien Glyphs 2

rooms_wide=3
rooms_high=1

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
            set_stone( "st-rock1", i-1, line)
        elseif c =="B" then
            set_stone( "st-glass", i-1, line)
        elseif c =="C" then
            set_stone( "st-rock3", i-1, line)
        elseif c =="E" then
            set_stone( "st-marble", i-1, line)
        elseif c =="K" then
            set_stone( "st-blue-sand", i-1, line)
        elseif c =="G" then
            set_stone( "st-greenbrown", i-1, line)
        elseif c =="1" then
            set_stone("st-switch",i-1,line,{action="callback",target="funcc1",name="s1"})
        elseif c =="2" then
            set_stone("st-switch",i-1,line,{action="callback",target="funcc2",name="s2"})
        elseif c =="3" then
            set_stone("st-switch",i-1,line,{action="callback",target="funcc3",name="s3"})
        elseif c =="4" then
            set_stone("st-switch",i-1,line,{action="callback",target="funcc4",name="s4"})
        elseif c =="5" then
            set_stone("st-switch",i-1,line,{action="callback",target="funcc5",name="s5"})
        elseif c =="6" then
            set_stone("st-switch",i-1,line,{action="callback",target="funcc6",name="s6"})
        elseif c =="7" then
            set_stone("st-switch",i-1,line,{action="callback",target="funcc7",name="s7"})
        elseif c =="8" then
            set_stone("st-switch",i-1,line,{action="callback",target="funcc8",name="s8"})
        elseif c =="9" then
            set_stone("st-switch",i-1,line,{action="callback",target="funcc9",name="s9"})
        elseif c =="0" then
            set_stone("st-switch",i-1,line,{action="callback",target="funcc10",name="s10"})
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
        elseif c=="y" then
            set_actor("ac-whiteball", i-1,line+.5, {player=1})
        elseif c == "g" then
            draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
        elseif c=="+" then
            set_stone( "st-wood", i-1, line)
        elseif c=="=" then
            set_floor("fl-space",i-1,line)
        elseif c=="Q" then
            doorv( i-1,line, {name="door1"})
        end
    end	
end

renderLine(00,"##########################################################")
renderLine(01,"#o#                                                      #")
renderLine(02,"# #                                 B         B          #")
renderLine(03,"# #                 BB      B       B   BBBBB B   B      #")
renderLine(04,"# #         B   BB  BBBBB   B  CBBBBB   BBBBB BBCBBC BBC #")
renderLine(05,"# #     B B BCB BBBCBBCCBCBBBEECBBCCBCCECCCCB BECCBCGCBC #")
renderLine(06,"# Q zABCBECGBCEKCCGEBBCCEGKKCEECGGEEBKKGCCCCE CEEGEEGGKE #")
renderLine(07,"# #              A   A A   A  A  A A  A  ABC    A A  A B #")
renderLine(08,"# #                                                      #")
renderLine(09,"# #                                           1234567890 #")
renderLine(10,"# #                                                      #")
renderLine(11,"#o#                                                      #")
renderLine(12,"##########################################################")

--               B    
-- B             B    
-- B B B B C C C B   B
-- B C C B C C C B G E
-- E G G K E E E C G E
-- A   A     A B      

-- 5 4 8 9 6 3 0 1 7 2

oxyd_shuffle()

ff1=0
function funcc1()
    if ff1==0 then
        ff1=1
    elseif ff1==1 then
        ff1=0
    end
    funcc11()
end

ff2=0
function funcc2()
    if ff2==0 then
        ff2=1
    elseif ff2==1 then
        ff2=0
    end
    funcc11()
end

ff3=0
function funcc3()
    if ff3==0 then
        ff3=1
    elseif ff3==1 then
        ff3=0
    end
    funcc11()
end

ff4=0
function funcc4()
    if ff4==0 then
        ff4=1
    elseif ff4==1 then
        ff4=0
    end
    funcc11()
end

ff5=0
function funcc5()
    if ff5==0 then
        ff5=1
    elseif ff5==1 then
        ff5=0
    end
    funcc11()
end

ff6=0
function funcc6()
    if ff6==0 then
        ff6=1
    elseif ff6==1 then
        ff6=0
    end
    funcc11()
end

ff7=0
function funcc7()
    if ff7==0 then
        ff7=1
    elseif ff7==1 then
        ff7=0
    end
    funcc11()
end

ff8=0
function funcc8()
    if ff8==0 then
        ff8=1
    elseif ff8==1 then
        ff8=0
    end
    funcc11()
end

ff9=0
function funcc9()
    if ff9==0 then
        ff9=1
    elseif ff9==1 then
        ff9=0
    end
    funcc11()
end

ff10=0
function funcc10()
    if ff10==0 then
        ff10=1
    elseif ff10==1 then
        ff10=0
    end
    funcc11()
end

fff1=0
fff2=0
fff3=0
fff4=0
fff5=0
fff6=0
fff7=0
fff8=0
fff9=0
fff10=0
ff11=1
dooropen=0
function funcc11()
    if ff11==1 then
        if ff5==1 then
            fff1=1
        end
        ff11=ff11+1
    elseif ff11==2 then
        if ff4==1 then
            fff2=1
        end
        ff11=ff11+1
    elseif ff11==3 then
        if ff8==1 then
            fff3=1
        end
        ff11=ff11+1
    elseif ff11==4 then
        if ff9==1 then
            fff4=1
        end
        ff11=ff11+1
    elseif ff11==5 then
        if ff6==1 then
            fff5=1
        end
        ff11=ff11+1
    elseif ff11==6 then
        if ff3==1 then
            fff6=1
        end
        ff11=ff11+1
    elseif ff11==7 then
        if ff10==1 then
            fff7=1
        end
        ff11=ff11+1
    elseif ff11==8 then
        if ff1==1 then
            fff8=1
        end
        ff11=ff11+1
    elseif ff11==9 then
        if ff7==1 then
            fff9=1
        end
        ff11=ff11+1
    elseif ff11==10 then
        if ff2==1 then
            fff10=1
        end
        ff11=ff11+1
    end
    ff1=0
    ff2=0
    ff3=0
    ff4=0
    ff5=0
    ff6=0
    ff7=0
    ff8=0
    ff9=0
    ff10=0

    if fff1+fff2+fff3+fff4+fff5+fff6+fff7+fff8+fff9+fff10==10 then
        print ("Ok")
        if dooropen==0 then
            print ("OkOk")
            SendMessage("door1","open")
            dooropen=1
        end
    else
        if dooropen==1 then
            SendMessage("door1","close")
            dooropen=0
        end
        if ff11==11 then
            fff1=0
            fff2=0
            fff3=0
            fff4=0
            fff5=0
            fff6=0
            fff7=0
            fff8=0
            fff9=0
            fff10=0
            SendMessage("s1","off")
            SendMessage("s2","off")
            SendMessage("s3","off")
            SendMessage("s4","off")
            SendMessage("s5","off")
            SendMessage("s6","off")
            SendMessage("s7","off")
            SendMessage("s8","off")
            SendMessage("s9","off")
            SendMessage("s10","off")
            ff11=1
        end
    end
end

display.SetFollowMode(display.FOLLOW_SCROLLING)