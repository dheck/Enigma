-- Copyright (c) 2004 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Listen Carefully

levelw=40
levelh=30

create_world( levelw, levelh)
enigma.ConserveLevel=FALSE

f1=(random(4))-1
f2=(random(4))-1
f3=(random(4))-1
f4=(random(4))-1
f5=(random(4))-1
f6=(random(4))-1
f7=(random(4))-1
f8=(random(4))-1
f9=(random(4))-1
f10=(random(4))-1
f11=(random(4))-1
f12=(random(4))-1
f13=(random(4))-1
f14=(random(4))-1
f15=(random(4))-1
f16=(random(4))-1
f17=(random(4))-1
f18=(random(4))-1
f19=(random(4))-1
f20=(random(4))-1
f21=(random(4))-1

fill_floor("fl-leaves", 0,0,levelw,levelh)

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
        local c = strsub( pattern, i, i)
        if c =="#" then
            set_stone( "st-greenbrown", i-1, line)
        elseif c =="w" then
            set_stone( "st-glass",i-1, line)
        elseif c =="T" then
            set_stone( "st-thief", i-1, line)
            set_floor("fl-space",i-1,line)
        elseif c =="_" then
            set_stone( "st-thief", i-1, line)
        elseif c =="<" then
            draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
            set_item("it-crack2",i-1,line)
        elseif c =="V" then
            abyss(i-1,line)
            draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
        elseif c ==":" then
            set_item("it-crack3",i-1,line)
        elseif c == "o" then
            oxyd( i-1, line)
        elseif c == "*" then
            set_stone( "st-brownie", i-1, line)
        elseif c == "!" then
            abyss(i-1,line)
        elseif c == "~" then
            set_floor("fl-water",i-1,line)
        elseif c=="z" then
            set_actor("ac-blackball", i-.5,line+.5, {player=0})
        elseif c == "g" then
            draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
        elseif c == "?" then
            draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
            abyss(i-1,line)
        elseif c=="+" then
            set_stone( "st-wood", i-1, line)
        elseif c=="=" then
            set_floor("fl-space",i-1,line)
        elseif c=="S" then
            set_attrib(laser(i-1,line, TRUE, SOUTH), "name", "laser")
        elseif c=="a" then
            doorh( i-1,line, {name="door1"})
        elseif c=="b" then
            doorh( i-1,line, {name="door2"})
        elseif c=="c" then
            doorh( i-1,line, {name="door3"})
        elseif c=="d" then
            doorh( i-1,line, {name="door4"})
        elseif c=="e" then
            doorh( i-1,line, {name="door5"})
        elseif c=="f" then
            doorh( i-1,line, {name="door6"})
        elseif c=="G" then
            doorh( i-1,line, {name="door7"})
        elseif c=="h" then
            doorh( i-1,line, {name="door8"})
        elseif c=="i" then
            doorh( i-1,line, {name="door9"})
        elseif c=="j" then
            doorh( i-1,line, {name="door10"})
        elseif c=="k" then
            doorh( i-1,line, {name="door11"})
        elseif c=="l" then
            doorh( i-1,line, {name="door12"})
        elseif c=="m" then
            doorh( i-1,line, {name="door13"})
        elseif c=="n" then
            doorh( i-1,line, {name="door14"})
        elseif c=="`" then
            doorh( i-1,line, {name="door15"})
        elseif c=="p" then
            doorh( i-1,line, {name="door16"})
        elseif c=="q" then
            doorh( i-1,line, {name="door17"})
        elseif c=="r" then
            doorh( i-1,line, {name="door18"})
        elseif c=="s" then
            doorh( i-1,line, {name="door19"})
        elseif c=="t" then
            doorh( i-1,line, {name="door20"})
        elseif c=="u" then
            doorh( i-1,line, {name="door21"})
        elseif c=="v" then
            doorv( i-1,line, {name="door22"})
        elseif c=="A" then
            set_stone("st-fourswitch", i-1,line, {action="callback", target="funcc1"})
        elseif c=="B" then
            set_stone("st-fourswitch", i-1,line, {action="callback", target="funcc2"})
        elseif c=="C" then
            set_stone("st-fourswitch", i-1,line, {action="callback", target="funcc3"})
        elseif c=="D" then
            set_stone("st-fourswitch", i-1,line, {action="callback", target="funcc4"})
        elseif c=="E" then
            set_stone("st-fourswitch", i-1,line, {action="callback", target="funcc5"})
        elseif c=="F" then
            set_stone("st-fourswitch", i-1,line, {action="callback", target="funcc6"})
        elseif c=="%" then
            set_stone("st-fourswitch", i-1,line, {action="callback", target="funcc7"})
        elseif c=="H" then
            set_stone("st-fourswitch", i-1,line, {action="callback", target="funcc8"})
        elseif c=="I" then
            set_stone("st-fourswitch", i-1,line, {action="callback", target="funcc9"})
        elseif c=="J" then
            set_stone("st-fourswitch", i-1,line, {action="callback", target="funcc10"})
        elseif c=="K" then
            set_stone("st-fourswitch", i-1,line, {action="callback", target="funcc11"})
        elseif c=="L" then
            set_stone("st-fourswitch", i-1,line, {action="callback", target="funcc12"})
        elseif c=="M" then
            set_stone("st-fourswitch", i-1,line, {action="callback", target="funcc13"})
        elseif c=="N" then
            set_stone("st-fourswitch", i-1,line, {action="callback", target="funcc14"})
        elseif c=="$" then
            set_stone("st-fourswitch", i-1,line, {action="callback", target="funcc15"})
        elseif c=="P" then
            set_stone("st-fourswitch", i-1,line, {action="callback", target="funcc16"})
        elseif c=="Q" then
            set_stone("st-fourswitch", i-1,line, {action="callback", target="funcc17"})
        elseif c=="R" then
            set_stone("st-fourswitch", i-1,line, {action="callback", target="funcc18"})
        elseif c=="^" then
            set_stone("st-fourswitch", i-1,line, {action="callback", target="funcc19"})
        elseif c=="&" then
            set_stone("st-fourswitch", i-1,line, {action="callback", target="funcc20"})
        elseif c=="U" then
            set_stone("st-fourswitch", i-1,line, {action="callback", target="funcc21"})
        elseif c==";" then
            mirrorp(i-1,line,FALSE,FALSE, 2)
        elseif c=="/" then
            mirrorp(i-1,line,FALSE,FALSE, 4)
        elseif c=="X" then
            set_stone("st-laserswitch",i-1,line,{action="openclose",target="door22"})
        elseif c==">" then
            set_stone("st-oneway", i-1,line, {orientation=enigma.EAST})
        end
    end
end

renderLine(00,"***************TTTT*###################")
renderLine(01,"*o           v ===T*gggggggggggggggggg#")
renderLine(02,"*o     #S#/w;# TT=T*g                g#")
renderLine(03,"*o     #a#n#`#  T=T*g                g#")
renderLine(04,"*o     #b#m#p# TT=T*g                g#")
renderLine(05,"*o     #c#l#q# T==T*g                g#")
renderLine(06,"*o     #d#k#r# _z__*g                g#")
renderLine(07,"*o     #e#j#s# ___g*g                g#")
renderLine(08,"*o     #f#i#t#    g*?!!!!            g#")
renderLine(09,"*o     #G#h#u#    g*g  >!            g#")
renderLine(10,"*o     #;w/#w#    g*   >:            g#")
renderLine(11,"*ogggggoggggg#ggg g*g  >!            g#")
renderLine(12,"************w*******?!!!!            g#")
renderLine(13,"#ggggggggggw;w;w<<<gg                g#")
renderLine(14,"#g         wwwww                     g#")
renderLine(15,"#g A  N  $    !                      g#")
renderLine(16,"#g B  M  P  ! !                      g#")
renderLine(17,"#g C  L  Q  ! !                      g#")
renderLine(18,"#g D  K  R  ! !                      g#")
renderLine(19,"#g E  J  ^  ! !                      g#")
renderLine(20,"#g F  I  &  ! !                      g#")
renderLine(21,"#g %  H  U  ! !                      g#")
renderLine(22,"#g          ! !                      g#")
renderLine(23,"#gggggggggggVggggggggggggggggggggggggg#")
renderLine(24,"##############X########################")

oxyd_shuffle()

ff1=-1
function funcc1()
    ff1=ff1+1
    if ff1==4 then
        ff1=0
    end
    if ff1==f1 then
        SendMessage("door1","open")
    else
        SendMessage("door1","close")
    end
end

ff2=-1
function funcc2()
    ff2=ff2+1
    if ff2==4 then
        ff2=0
    end
    if ff2==f2 then
        SendMessage("door2","open")
    else
        SendMessage("door2","close")
    end
end

ff3=-1
function funcc3()
    ff3=ff3+1
    if ff3==4 then
        ff3=0
    end
    if ff3==f3 then
        SendMessage("door3","open")
    else
        SendMessage("door3","close")
    end
end

ff4=-1
function funcc4()
    ff4=ff4+1
    if ff4==4 then
        ff4=0
    end
    if ff4==f4 then
        SendMessage("door4","open")
    else
        SendMessage("door4","close")
    end
end

ff5=-1
function funcc5()
    ff5=ff5+1
    if ff5==4 then
        ff5=0
    end
    if ff5==f5 then
        SendMessage("door5","open")
    else
        SendMessage("door5","close")
    end
end

ff6=-1
function funcc6()
    ff6=ff6+1
    if ff6==4 then
        ff6=0
    end
    if ff6==f6 then
        SendMessage("door6","open")
    else
        SendMessage("door6","close")
    end
end

ff7=-1
function funcc7()
    ff7=ff7+1
    if ff7==4 then
        ff7=0
    end
    if ff7==f7 then
        SendMessage("door7","open")
    else
        SendMessage("door7","close")
    end
end

ff8=-1
function funcc8()
    ff8=ff8+1
    if ff8==4 then
        ff8=0
    end
    if ff8==f8 then
        SendMessage("door8","open")
    else
        SendMessage("door8","close")
    end
end

ff9=-1
function funcc9()
    ff9=ff9+1
    if ff9==4 then
        ff9=0
    end
    if ff9==f9 then
        SendMessage("door9","open")
    else
        SendMessage("door9","close")
    end
end

ff10=-1
function funcc10()
    ff10=ff10+1
    if ff10==4 then
        ff10=0
    end
    if ff10==f10 then
        SendMessage("door10","open")
    else
        SendMessage("door10","close")
    end
end

ff11=-1
function funcc11()
    ff11=ff11+1
    if ff11==4 then
        ff11=0
    end
    if ff11==f11 then
        SendMessage("door11","open")
    else
        SendMessage("door11","close")
    end
end

ff12=-1
function funcc12()
    ff12=ff12+1
    if ff12==4 then
        ff12=0
    end
    if ff12==f12 then
        SendMessage("door12","open")
    else
        SendMessage("door12","close")
    end
end

ff13=-1
function funcc13()
    ff13=ff13+1
    if ff13==4 then
        ff13=0
    end
    if ff13==f13 then
        SendMessage("door13","open")
    else
        SendMessage("door13","close")
    end
end

ff14=-1
function funcc14()
    ff14=ff14+1
    if ff14==4 then
        ff14=0
    end
    if ff14==f14 then
        SendMessage("door14","open")
    else
        SendMessage("door14","close")
    end
end

ff15=-1
function funcc15()
    ff15=ff15+1
    if ff15==4 then
        ff15=0
    end
    if ff15==f15 then
        SendMessage("door15","open")
    else
        SendMessage("door15","close")
    end
end

ff16=-1
function funcc16()
    ff16=ff16+1
    if ff16==4 then
        ff16=0
    end
    if ff16==f16 then
        SendMessage("door16","open")
    else
        SendMessage("door16","close")
    end
end

ff17=-1
function funcc17()
    ff17=ff17+1
    if ff17==4 then
        ff17=0
    end
    if ff17==f17 then
        SendMessage("door17","open")
    else
        SendMessage("door17","close")
    end
end

ff18=-1
function funcc18()
    ff18=ff18+1
    if ff18==4 then
        ff18=0
    end
    if ff18==f18 then
        SendMessage("door18","open")
    else
        SendMessage("door18","close")
    end
end

ff19=-1
function funcc19()
    ff19=ff19+1
    if ff19==4 then
        ff19=0
    end
    if ff19==f19 then
        SendMessage("door19","open")
    else
        SendMessage("door19","close")
    end
end

ff20=-1
function funcc20()
    ff20=ff20+1
    if ff20==4 then
        ff20=0
    end
    if ff20==f20 then
        SendMessage("door20","open")
    else
        SendMessage("door20","close")
    end
end

ff21=-1
function funcc21()
    ff21=ff21+1
    if ff21==4 then
        ff21=0
    end
    if ff21==f21 then
        SendMessage("door21","open")
    else
        SendMessage("door21","close")
    end
end

funcc1()
funcc2()
funcc3()
funcc4()
funcc5()
funcc6()
funcc7()
funcc8()
funcc9()
funcc10()
funcc11()
funcc12()
funcc13()
funcc14()
funcc15()
funcc16()
funcc17()
funcc18()
funcc19()
funcc20()
funcc21()














