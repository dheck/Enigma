-- Copyright (c) 2003 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Tilt Maze

levelw=40
levelh=30

create_world( levelw, levelh)

fill_floor("fl-normal", 0,0,levelw,levelh)

enigma.SlopeForce=10
--enigma.FrictionFactor=.5

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
        local c = strsub( pattern, i, i)
        if c =="#" then
            set_stone( "st-greenbrown", i-1, line)
        elseif c =="%" then
            set_stone( "st-greenbrown", i-1, line)
            --			set_floor("fl-rough_slow",i-1,line)
        elseif c =="X" then
            set_stone( "st-death", i-1, line)
        elseif c == "o" then
            oxyd( i-1, line)
        elseif c == "*" then
            set_stone( "st-brownie", i-1, line)
        elseif c == "!" then
            abyss(i-1,line)
        elseif c=="z" then
            set_actor("ac-blackball", i-.5,line+.5)
            --			set_floor("fl-rough_slow",i-1,line)
        elseif c == "g" then
            draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
        elseif c=="+" then
            set_stone( "st-wood", i-1, line)
        elseif c=="=" then
            set_floor("fl-space",i-1,line)
        elseif c=="x" then
            --			set_floor("fl-rough_slow",i-1,line)
        elseif c=="i" then
            set_floor("fl-ice_001",i-1,line)
        elseif c=="1" then
            set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc1"})
        elseif c=="2" then
            set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc2"})
        elseif c=="3" then
            set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc3"})
        elseif c=="4" then
            set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc4"})
        elseif c=="5" then
            set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc5"})
        elseif c=="6" then
            set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc6"})
        elseif c=="7" then
            set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc7"})
        elseif c=="8" then
            set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc8"})
        elseif c=="9" then
            set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc9"})
        elseif c=="0" then
            set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc10"})
            set_actor("ac-whiteball", i-.5,line+.5, {mouseforce=0})
        elseif c==" " then
            yy=line-7
            xx=(i-1)-16
            while yy>1 do
                yy=yy-3
            end
            while yy<-1 do
                yy=yy+3
            end
            while xx>1 do
                xx=xx-3
            end
            while xx<-1 do
                xx=xx+3
            end
            if xx==-1 and yy==1 then
                set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc1"})
            elseif xx==0 and yy==1 then
                set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc2"})
            elseif xx==1 and yy==1 then
                set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc3"})
            elseif xx==-1 and yy==0 then
                set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc4"})
            elseif xx==0 and yy==0 then
                set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc5"})
            elseif xx==1 and yy==0 then
                set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc6"})
            elseif xx==-1 and yy==-1 then
                set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc7"})
            elseif xx==0 and yy==-1 then
                set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc8"})
            elseif xx==1 and yy==-1 then
                set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc9"})
            end
        elseif c=="a" then
            set_item("it-trigger", i-1,line, {action="callback", target="funccdir1"})
            --			set_floor("fl-rough_slow",i-1,line)
        elseif c=="b" then
            set_item("it-trigger", i-1,line, {action="callback", target="funccdir2"})
            --			set_floor("fl-rough_slow",i-1,line)
        elseif c=="c" then
            set_item("it-trigger", i-1,line, {action="callback", target="funccdir3"})
            --			set_floor("fl-rough_slow",i-1,line)
        elseif c=="d" then
            set_item("it-trigger", i-1,line, {action="callback", target="funccdir4"})
            --			set_floor("fl-rough_slow",i-1,line)
        elseif c=="e" then
            set_item("it-trigger", i-1,line, {action="callback", target="funccdir5"})
            --			set_floor("fl-rough_slow",i-1,line)
        elseif c == "d" then --1-d
            set_floor("fl-gradient",  i-1,  line, {type=21})
        elseif c == "u" then --2-u
            set_floor("fl-gradient",  i-1,  line, {type=22})
        elseif c == "r" then --3-r
            set_floor("fl-gradient",  i-1,  line, {type=23})
        elseif c == "l" then --4-l
            set_floor("fl-gradient",  i-1,  line, {type=24})
        elseif c=="L" then
            set_stone("st-oneway-w", i-1,line)
            set_floor("fl-gradient",  i-1,  line, {type=24})
        elseif c=="y" then
            set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="funcc11"})
            set_actor("ac-whiteball", i-.5,line+.5, {player=0,mouseforce=1})
            set_floor("fl-gradient",  i-1,  line, {type=24})
        elseif c=="A" then
            --  		   set_item("it-vortex-open", i-1, line, {targetx="16.5",targety="8.5", name="V1"})
            --			set_floor("fl-space",i-1,line)
            --			abyss(i-1,line)
            if difficult then
                set_floor("fl-water",i-1,line)
            else
                set_stone ("st-actorimpulse", i-1, line)
            end
        end
    end	
end

--renderLine(00,"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
--renderLine(01,"%exxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxe%")
--renderLine(02,"%xzax#############################xaxx%")
--renderLine(03,"%xdxb#78#789A89A8978978A789A#A789#dxbx%")
--renderLine(04,"%xxcx#45#456A564564A6456456A#6456#xcxx%")
--renderLine(05,"%x####123123#A############3123#23####x%")
--renderLine(06,"%x#A8978A78A#897897A9789A#97A9#89789#x%")
--renderLine(07,"%x#45########A ###4#64564#A456#AA4AA#x%")
--renderLine(08,"%x#12#12A123#  Ly# #AA#31########1###x%")
--renderLine(09,"%x#78978#789##A###7#97#97A97897A#789#x%")
--renderLine(10,"%x#A56A564A64564564#64#64A64A645#4#6#x%")
--renderLine(11,"%x################A#3A#31231A312#A#3#x%")
--renderLine(12,"%x#78978#A897A97897#97########A89789#x%")
--renderLine(13,"%x#4A#A5645A4A64##4#A4#A45645########x%")
--renderLine(14,"%x#12#A23A2A1231#31#31#31A312312312A#x%")
--renderLine(15,"%x#A8############A7#97 97######8A789#x%")
--renderLine(16,"%x#4564564o#AA64#64#64564A6456#####6#x%")
--renderLine(17,"%x##2#######1231A31#A#####3A23123123#x%")
--renderLine(18,"%x#o8#A8978978A789A#A7897#9#######8A#x%")
--renderLine(19,"%x####45A4A#########64A64#645645A####x%")
--renderLine(20,"%xxax#12A1##A2312AA231#31#AAAAA23#xaxx%")
--renderLine(21,"%xdxb#A89789789A89789A#978978978A#dxbx%")
--renderLine(22,"%xxcx#############################xcxx%")
--renderLine(23,"%xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxe%")
--renderLine(24,"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")

--renderLine(00,"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
--renderLine(01,"%exxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxe%")
--renderLine(02,"%xzax#############################xaxx%")
--renderLine(03,"%xdxb#  #      A       A   A#A   #dxbx%")
--renderLine(04,"%xxcx#  #   A      A       A#    #xcxx%")
--renderLine(05,"%x####      #A############    #  ####x%")
--renderLine(06,"%x#A    A  A#      A    A#  A #     #x%")
--renderLine(07,"%x#  ########A ### #     #A   #AA AA#x%")
--renderLine(08,"%x#  #  A   #  Ly# #A #  ######## ###x%")
--renderLine(09,"%x#     #   ##A### #  #  A     A#   #x%")
--renderLine(10,"%x#A  A   A        #  #  A  A   # # #x%")
--renderLine(11,"%x################A# A#     A   #A# #x%")
--renderLine(12,"%x#     #A   A     #  ########A     #x%")
--renderLine(13,"%x# A#A    A A  ## #  #A     ########x%")
--renderLine(14,"%x#  #A  A A    #  #A #  A         A#x%")
--renderLine(15,"%x#A ############A #  A  ###### A   #x%")
--renderLine(16,"%x#       o#AA  #  #     A    ##### #x%")
--renderLine(17,"%x## #######    A  #A##### A        #x%")
--renderLine(18,"%x#o #A       A   A#A    # ####### A#x%")
--renderLine(19,"%x####  A A#########  A  #      A####x%")
--renderLine(20,"%xxax#  A ##A    AA   #  #AAAAA  #xaxx%")
--renderLine(21,"%xdxb#A        A     A#         A#dxbx%")
--renderLine(22,"%xxcx#############################xcxx%")
--renderLine(23,"%xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxe%")
--renderLine(24,"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")

renderLine(00,"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
renderLine(01,"%xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx%")
renderLine(02,"%xzax#############################xaxx%")
renderLine(03,"%xdxb#A #      A       A   A#A  A#dxbx%")
renderLine(04,"%xxcx#  #   A      A       A#    #xcxx%")
renderLine(05,"%x####      #A############    #  ####x%")
renderLine(06,"%x#A    A  A#      A    A#  A #     #x%")
renderLine(07,"%x#  ########A ### #     #A   #AA AA#x%")
renderLine(08,"%x#  #  A   #  Ly# #A #  ######## ###x%")
renderLine(09,"%x#     #   ##A### #  #  A     A#   #x%")
renderLine(10,"%x#A  A   A      A #  #  A  A   #A# #x%")
renderLine(11,"%x#   #   #   A    # A#A    A       #x%")
renderLine(12,"%x################A#  ###############x%")
renderLine(13,"%x#A   A     A     #  #A   A   A    #x%")
renderLine(14,"%x#  #    A     #  #A #  A   A   A A#x%")
renderLine(15,"%x# A############A #  A  ###### AA  #x%")
renderLine(16,"%x#       o#AA A#  #     A   A##### #x%")
renderLine(17,"%x## #######    A  #A##### A        #x%")
renderLine(18,"%x#o #A      A    A#A   A# ####### A#x%")
renderLine(19,"%x####  AAA#########  A  #      A####x%")
renderLine(20,"%xxax#  A   A    AAA  #  #AAAAA  #xaxx%")
renderLine(21,"%xdxb#A   A    A     A#A        A#dxbx%")
renderLine(22,"%xxcx#############################xcxx%")
renderLine(23,"%xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx%")
renderLine(24,"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")

oxyd_shuffle()

prev=1
cur=1
direc=0
prevdirec=0
chosendir=0

prebx=15
preby=8

bx=15
by=8


f1=0
f2=0
f3=0
f4=0
f5=0
f6=0
f7=0
f8=0
f9=0
f10=0
f11=0

function funccdir1()
   chosendir=1
      	set_floor("fl-gradient",  bx, by , {type=22})
end

function funccdir2()
   chosendir=2
      	set_floor("fl-gradient",  bx, by , {type=23})
end

function funccdir3()
   chosendir=3
      	set_floor("fl-gradient",  bx, by , {type=21})
end

function funccdir4()
   chosendir=4
      	set_floor("fl-gradient",  bx, by , {type=24})
end

function funccdir5()
   chosendir=5
      	set_floor("fl-normal",  bx, by)
end

function funcc1()
   if f1==0 then
      cur=1
      f1=1
      dcheck()
   else
      f1=0
   end
end

function funcc2()
   if f2==0 then
      cur=2
      f2=1
      dcheck()
   else
      f2=0
   end
end

function funcc3()
   if f3==0 then
      cur=3
      f3=1
      dcheck()
   else
      f3=0
   end
end

function funcc4()
   if f4==0 then
      cur=4
      f4=1
      dcheck()
   else
      f4=0
   end
end

function funcc5()
   if f5==0 then
      cur=5
      f5=1
      dcheck()
   else
      f5=0
   end
end

function funcc6()
   if f6==0 then
      cur=6
      f6=1
      dcheck()
   else
      f6=0
   end
end

function funcc7()
   if f7==0 then
      cur=7
      f7=1
      dcheck()
   else
      f7=0
   end
end

function funcc8()
   if f8==0 then
      cur=8
      f8=1
      dcheck()
   else
      f8=0
   end
end

function funcc9()
   if f9==0 then
      cur=9
      f9=1
      dcheck()
   else
      f9=0
   end
end

f10=0

function funcc10()
if f10==0 then
   prev=1
--   cur=1
   bx=14
   by=6
   f1=0
   f2=0
   f3=0
   f4=0
   f5=0
   f6=0
   f7=0
   f8=0
   f9=0
else
f10=0
end
end

function funcc11()
        set_floor("fl-normal",  prebx,  preby)
--   set_floor("fl-gradient",  18,  6, {type=24})
if f10==0 then
   prev=1
--   cur=2
   bx=15
   by=8
   f1=0
   f2=0
   f3=0
   f4=0
   f5=0
   f6=0
   f7=0
   f8=0
   f9=0
chosendir=5
else
f10=0
end
end


function dcheck()

if cur==2 and prev==1 then
direc=2
elseif cur==3 and prev==2 then
direc=2
elseif cur==1 and prev==3 then
direc=2
elseif cur==5 and prev==4 then
direc=2
elseif cur==6 and prev==5 then
direc=2
elseif cur==4 and prev==6 then
direc=2
elseif cur==8 and prev==7 then
direc=2
elseif cur==9 and prev==8 then
direc=2
elseif cur==7 and prev==9 then
direc=2

elseif cur==1 and prev==2 then
direc=4
elseif cur==2 and prev==3 then
direc=4
elseif cur==3 and prev==1 then
direc=4
elseif cur==4 and prev==5 then
direc=4
elseif cur==5 and prev==6 then
direc=4
elseif cur==6 and prev==4 then
direc=4
elseif cur==7 and prev==8 then
direc=4
elseif cur==8 and prev==9 then
direc=4
elseif cur==9 and prev==7 then
direc=4

elseif cur==4 and prev==1 then
direc=1
elseif cur==5 and prev==2 then
direc=1
elseif cur==6 and prev==3 then
direc=1
elseif cur==7 and prev==4 then
direc=1
elseif cur==8 and prev==5 then
direc=1
elseif cur==9 and prev==6 then
direc=1
elseif cur==1 and prev==7 then
direc=1
elseif cur==2 and prev==8 then
direc=1
elseif cur==3 and prev==9 then
direc=1

elseif cur==1 and prev==4 then
direc=3
elseif cur==2 and prev==5 then
direc=3
elseif cur==3 and prev==6 then
direc=3
elseif cur==4 and prev==7 then
direc=3
elseif cur==5 and prev==8 then
direc=3
elseif cur==6 and prev==9 then
direc=3
elseif cur==7 and prev==1 then
direc=3
elseif cur==8 and prev==2 then
direc=3
elseif cur==9 and prev==3 then
direc=3

-- renderLine(03,"!#         1231231#!")
-- renderLine(04,"!#       ##7897897#!")
-- renderLine(05,"!#   z   ##4564564#!")
-- renderLine(06,"!#       ##1231231#!")
-- renderLine(07,"!#       ##7897897#!")
-- renderLine(08,"!#       ##4564564#!")
-- renderLine(09,"!#       ##1231231#!")

elseif cur==5 and prev==1 then
direc=5
elseif cur==6 and prev==2 then
direc=5
elseif cur==4 and prev==3 then
direc=5
elseif cur==2 and prev==7 then
direc=5
elseif cur==3 and prev==8 then
direc=5
elseif cur==1 and prev==9 then
direc=5
elseif cur==8 and prev==4 then
direc=5
elseif cur==9 and prev==5 then
direc=5
elseif cur==7 and prev==6 then
direc=5

-- renderLine(03,"!#         1231231#!")
-- renderLine(04,"!#       ##7897897#!")
-- renderLine(05,"!#   z   ##4564564#!")
-- renderLine(06,"!#       ##1231231#!")
-- renderLine(07,"!#       ##7897897#!")
-- renderLine(08,"!#       ##4564564#!")
-- renderLine(09,"!#       ##1231231#!")

elseif cur==1 and prev==6 then
direc=6
elseif cur==3 and prev==5 then
direc=6
elseif cur==2 and prev==4 then
direc=6
elseif cur==4 and prev==9 then
direc=6
elseif cur==6 and prev==8 then
direc=6
elseif cur==5 and prev==7 then
direc=6
elseif cur==7 and prev==3 then
direc=6
elseif cur==9 and prev==2 then
direc=6
elseif cur==8 and prev==1 then
direc=6

-- renderLine(03,"!#         1231231#!")
-- renderLine(04,"!#       ##7897897#!")
-- renderLine(05,"!#   z   ##4564564#!")
-- renderLine(06,"!#       ##1231231#!")
-- renderLine(07,"!#       ##7897897#!")
-- renderLine(08,"!#       ##4564564#!")
-- renderLine(09,"!#       ##1231231#!")

elseif cur==1 and prev==5 then
direc=7
elseif cur==2 and prev==6 then
direc=7
elseif cur==3 and prev==4 then
direc=7
elseif cur==4 and prev==8 then
direc=7
elseif cur==5 and prev==9 then
direc=7
elseif cur==6 and prev==7 then
direc=7
elseif cur==7 and prev==2 then
direc=7
elseif cur==8 and prev==3 then
direc=7
elseif cur==9 and prev==1 then
direc=7

-- renderLine(03,"!#         1231231#!")
-- renderLine(04,"!#       ##7897897#!")
-- renderLine(05,"!#   z   ##4564564#!")
-- renderLine(06,"!#       ##1231231#!")
-- renderLine(07,"!#       ##7897897#!")
-- renderLine(08,"!#       ##4564564#!")
-- renderLine(09,"!#       ##1231231#!")

elseif cur==4 and prev==2 then
direc=8
elseif cur==5 and prev==3 then
direc=8
elseif cur==6 and prev==1 then
direc=8
elseif cur==7 and prev==5 then
direc=8
elseif cur==8 and prev==6 then
direc=8
elseif cur==9 and prev==4 then
direc=8
elseif cur==1 and prev==8 then
direc=8
elseif cur==2 and prev==9 then
direc=8
elseif cur==3 and prev==7 then
direc=8

end

   if direc==1 then
      by=by-1
   elseif direc==2 then
      bx=bx+1
   elseif direc==3 then
      by=by+1
   elseif direc==4 then
      bx=bx-1
   elseif direc==5 then
      bx=bx+1
      by=by-1
   elseif direc==6 then
      bx=bx+1
      by=by+1
   elseif direc==7 then
      bx=bx-1
      by=by+1
   elseif direc==8 then
      bx=bx-1
      by=by-1
   end

if chosendir==1 then
      	set_floor("fl-gradient",  bx, by , {type=22})
  elseif chosendir==2 then
        set_floor("fl-gradient",  bx,  by, {type=23})
   elseif chosendir==3 then
      	set_floor("fl-gradient",  bx,  by, {type=21})
   elseif chosendir==4 then
      	set_floor("fl-gradient",  bx,  by, {type=24})
   elseif chosendir==5 then
        set_floor("fl-normal",  bx,  by)
     end

--   if direc==1 then
--      	set_floor("fl-gradient",  bx, by , {type=2})
--  elseif direc==2 then
--        set_floor("fl-gradient",  bx,  by, {type=3})
--   elseif direc==3 then
--      	set_floor("fl-gradient",  bx,  by, {type=1})
--   elseif direc==4 then
--      	set_floor("fl-gradient",  bx,  by, {type=4})
--     end
--if direc>4 then
--   if prevdirec==1 then
--      	set_floor("fl-gradient",  bx, by , {type=2})
--  elseif prevdirec==2 then
--        set_floor("fl-gradient",  bx,  by, {type=3})
--   elseif prevdirec==3 then
--      	set_floor("fl-gradient",  bx,  by, {type=1})
--   elseif prevdirec==4 then
--      	set_floor("fl-gradient",  bx,  by, {type=4})
--     end
     --  end

set_floor("fl-normal",  prebx,  preby)

set_floor("fl-gradient",  16,  8, {type=24})

prebx=bx
preby=by

prev=cur

prevdirec=direc
end

function timer_callback()
set_floor("fl-gradient",  15,  8, {type=24})
set_floor("fl-gradient",  16,  8, {type=24})
end

set_stone("st-timer", 39,0, {loop=1, action="callback", target="timer_callback", interval=0.1})















