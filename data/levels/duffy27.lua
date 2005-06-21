-- Copyright (c) 2003 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Island of Safety

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
        elseif c == "o" then
            oxyd( i-1, line)
            abyss(i-1,line)
        elseif c == "!" then
            abyss(i-1,line)
            --	           	fill_floor("fl-water", i-1,line, 1,1)
        elseif c=="z" then
            set_actor("ac-blackball", i-1,line)
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
        elseif c == "G" then
            set_stone("st-door_a",i-1,line,{name="gate7"})
        elseif c == "H" then
            set_stone("st-door_a",i-1,line,{name="gate8"})	
	end
    end	
end

-- Floor:  " "
-- Border: "#"
-- Oxyd:   "o"

renderLine(00,"!!!!@@@@@@@@@@@@!!!!")
renderLine(01,"!!!!############!!!!")
renderLine(02,"!!!oA          Bo!!!")
renderLine(03,"!!!!#          #!!!!")
renderLine(04,"!!!!#          #!!!!")
renderLine(05,"!!!oH          Co!!!")
renderLine(06,"!!!!#          #!!!!")
renderLine(07,"!!!!#     z    #!!!!")
renderLine(08,"!!!oG          Do!!!")
renderLine(09,"!!!!#          #!!!!")
renderLine(10,"!!!!#          #!!!!")
renderLine(11,"!!!oF          Eo!!!")
renderLine(12,"!!!!############!!!!")

oxyd_shuffle()

set_stone( "st-timer", 21, 0, {action="callback", target="timer_handler",interval=1})

gatenum=0

mytimer=-1
function timer_handler()
    mytimer=mytimer+1
    if mytimer==0 then
        fill_floor("fl-wood", 4,0, 1,1)
	xcor=random(1,10)
	ycor=random(1,10)
	stnum=random(1,4)
        if stnum==1 then
            xx=4+xcor
            yy=12-ycor
            stnpr=1
        elseif stnum==2 then
            xx=15-xcor
            yy=12-ycor
            stnpr=3
        elseif stnum==3 then
            xx=15-xcor
            yy=1+ycor
            stnpr=9
        elseif stnum==4 then
            xx=4+xcor
            yy=1+ycor
            stnpr=7
        end
	if xcor==10 then
            xcor=0
	end
	if ycor==10 then
            ycor=0
	end
	randcorx=random(5,14)
	randcory=random(2,11)
	document(randcorx,randcory,stnpr..xcor..ycor)
    elseif mytimer==1 then
	fill_floor("fl-wood", 5,0, 1,1)
    elseif mytimer==2 then
	fill_floor("fl-wood", 6,0, 1,1)
    elseif mytimer==3 then
	fill_floor("fl-wood", 7,0, 1,1)
    elseif mytimer==4 then
	fill_floor("fl-wood", 8,0, 1,1)
    elseif mytimer==5 then
	fill_floor("fl-wood", 9,0, 1,1)
    elseif mytimer==6 then
	fill_floor("fl-wood", 10,0, 1,1)
    elseif mytimer==7 then
	fill_floor("fl-wood", 11,0, 1,1)
    elseif mytimer==8 then
	fill_floor("fl-wood", 12,0, 1,1)
    elseif mytimer==9 then
	fill_floor("fl-wood", 13,0, 1,1)
    elseif mytimer==10 then
	fill_floor("fl-wood", 14,0, 1,1)
    elseif mytimer==11 then
	fill_floor("fl-wood", 15,0, 1,1)
    elseif mytimer==12 then
        for a=5,14 do
            for b=2,11 do
                if a<xx or a>xx then
                    aaa=1
                elseif a==xx then
                    aaa=0
                end
                if b<yy or b>yy then
                    bbb=1
                elseif b==yy then
                    bbb=0
                end
                if aaa==1 or bbb==1 then
                    fill_floor("fl-abyss", a,b, 1,1)
                end
            end
        end	
    elseif mytimer==13 then   	
        fill_floor("fl-ice_001", 4,0, 12,1)
        fill_floor("fl-hay", 5,2, 10,10)
        mytimer=-1
        if gatenum==0 then
            SendMessage("gate1", "openclose")
        elseif gatenum==1 then
            SendMessage("gate1", "openclose")
            SendMessage("gate2", "openclose")
        elseif gatenum==2 then
            SendMessage("gate2", "openclose")
            SendMessage("gate3", "openclose")
        elseif gatenum==3 then
            SendMessage("gate3", "openclose")
            SendMessage("gate4", "openclose")
        elseif gatenum==4 then
            SendMessage("gate4", "openclose")
            SendMessage("gate5", "openclose")
        elseif gatenum==5 then
            SendMessage("gate5", "openclose")
            SendMessage("gate6", "openclose")
        elseif gatenum==6 then
            SendMessage("gate6", "openclose")
            SendMessage("gate7", "openclose")
        elseif gatenum==7 then
            SendMessage("gate7", "openclose")
            SendMessage("gate8", "openclose")
        elseif gatenum==8 then
            SendMessage("gate8", "openclose")
            SendMessage("gate1", "openclose")
        end
        gatenum=gatenum+1
        if gatenum==9 then
            gatenum=1
        end
    end
end