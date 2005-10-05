-- Copyright (c) 2003 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Alien Glyphs

levelw=100
levelh=50

create_world( levelw, levelh)

fill_floor("fl-bluegreen", 0,0,levelw,levelh)

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
        local c = strsub( pattern, i, i)
        if c =="#" then
            set_stone( "st-greenbrown", i-1, line)
        elseif c =="w" then
            set_stone( "st-glass", i-1, line)
        elseif c == "o" then
            oxyd( i-1, line)
        elseif c=="z" then
            set_actor("ac-blackball", i-.5,line+.5)
        elseif c=="a" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc1"})
        elseif c=="b" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc2"})
        elseif c=="c" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc3"})
        elseif c=="d" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc4"})
        elseif c=="e" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc5"})
        elseif c=="f" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc6"})
        elseif c=="g" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc7"})
        elseif c=="h" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc8"})
        elseif c=="i" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc9"})
        elseif c=="j" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc10"})
        elseif c=="k" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc11"})
        elseif c=="l" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc12"})
        elseif c=="m" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc13"})
        elseif c=="n" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc14"})
        elseif c=="O" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc15"})
        elseif c=="p" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc16"})
        elseif c=="q" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc17"})
        elseif c=="r" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc18"})
        elseif c=="s" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc19"})
        elseif c=="t" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc20"})
        elseif c=="u" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc21"})
        elseif c=="v" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc22"})
        elseif c=="W" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc23"})
        elseif c=="x" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc24"})
        elseif c=="y" then
            set_item("it-trigger", i-1,line, {action="callback", target="funcc25"})
        elseif c=="G" then
            doorh( i-1,line, {name="door1"})
        elseif c=="H" then
            doorh( i-1,line, {name="door2"})
        elseif c=="C" then
            set_item("it-coin1", i-1,line,{value=0})
        elseif c=="D" then
            set_item("it-coin1", i-1,line)
        elseif c=="E" then
            set_item("it-coin2", i-1,line)
        elseif c=="F" then
            set_stone("st-switch", i-1,line, {action="callback",target="funcc26"})
        end
    end	
end

-- Floor:  " "
-- Border: "#"
-- Oxyd:   "o"

renderLine(00,"#############################################################################")
renderLine(01,"#                  #                  #                  #                  #")
renderLine(02,"#                  #                  #                  #                  #")
renderLine(03,"#      ##  #       #       #  #       #      #           #      ooooo       #")
renderLine(04,"#      #  ##       #       ## #       #      # ##        #      o   o       #")
renderLine(05,"#       #  #       #      ## ##       #       #  #       #      o   o       #")
renderLine(06,"#      # ##        #         #        #       # ##       #      o   o       #")
renderLine(07,"#      ### #       #      # ##        #      # ##        #      ooooo       #")
renderLine(08,"#                  #                  #                  #                  #")
renderLine(09,"#                  #                  #                  #                  #")
renderLine(10,"#        #         #        #         #        #         #       # #        #")
renderLine(11,"#        #         #        #         #        #         #       # #        #")
renderLine(12,"###### ##### ############ ##### ############ ##### ############# # # ########")
renderLine(13,"#        #         #        #         #        #         #       # #        #")
renderLine(14,"#        #         #        #         #        #         #       # #        #")
renderLine(15,"#                  #                  #                  #                  #")
renderLine(16,"#      ## #        #        #         #       # #        #       # ##       #")
renderLine(17,"#       ## #       #      #  ##       #      ##  #       #      ####        #")
renderLine(18,"#      ####        #        ###       #       # #        #      ##  #       #")
renderLine(19,"#      ## ##       #       ## #       #      # ###       #       ####       #")
renderLine(20,"#       ##         #      #  #        #      # #         #       #          #")
renderLine(21,"#                  #                  #                  #                  #")
renderLine(22,"#       # #        #       # #        #       # #        #        #         #")
renderLine(23,"#       # #        #       # #        #       # #        #        #         #")
renderLine(24,"####### # # ############## # # ############## # # #############G#####H##########################")
renderLine(25,"#       # #        #       # #        #       # #        #        #    abcde                   #")
renderLine(26,"#       # #        #       # #        #       # #        #        #    fghij#                  #")
renderLine(27,"#                                                        #             klmnO#     CDECDECD     #")
renderLine(28,"#                  #                  #     wwwwwww            wwwwwww pqrst#     ECDECDEC     #")
renderLine(29,"#         ##       #       ## #       #     w     w    #####   w     w uvWxy#     DECDECDE     #")
renderLine(30,"#      ####      #####    ####      #####   w     w            w     w      #     CDECDECD     #")
renderLine(31,"#      # ###       #      ###         #                #####   w     w      #     ECDECDEC     #")
renderLine(32,"#       ## #       #       ####       #     w     w            w     w      #     DECDECDE     #")
renderLine(33,"#      #   #                #   z           w     w      #     w     w      #     CDECDECD     #")
renderLine(34,"#                  #                  #     wwwwwww      #     wwwwwww      #                  #")
renderLine(35,"#                  #                  #                  #                 F#                  #")
renderLine(36,"################################################################################################")

-- ## # 
--  ####
--    ##
-- ###  
--    # 

-- # #  
--  ####
--  #   
-- #### 
-- # ###

oxyd_shuffle()

f1=0
ff1=0
function funcc1()
if ff1==0 then
    if f1==1 then
       enigma.KillStone(64,29)
f1=0
    elseif f1==0 then
	set_stone( "st-greenbrown", 64, 29)
f1=1
     end
ff1=1
  elseif ff1==1 then
ff1=0
end
end

f2=0
ff2=0
function funcc2()
if ff2==0 then
    if f2==1 then
       enigma.KillStone(65,29)
f2=0
    elseif f2==0 then
	set_stone( "st-greenbrown", 65, 29)
f2=1
     end
ff2=1
  elseif ff2==1 then
ff2=0
end
end

f3=0
ff3=0
function funcc3()
if ff3==0 then
    if f3==1 then
       enigma.KillStone(66,29)
f3=0
    elseif f3==0 then
	set_stone( "st-greenbrown", 66, 29)
f3=1
     end
ff3=1
 elseif ff3==1 then
ff3=0
end
end

f4=0
ff4=0
function funcc4()
if ff4==0 then
   if f4==1 then
       enigma.KillStone(67,29)
f4=0
    elseif f4==0 then
	set_stone( "st-greenbrown", 67, 29)
f4=1
     end
ff4=1
  elseif ff4==1 then
ff4=0
end
end

f5=0
ff5=0
function funcc5()
if ff5==0 then
    if f5==1 then
       enigma.KillStone(68,29)
f5=0
   elseif f5==0 then
	set_stone( "st-greenbrown", 68, 29)
f5=1
     end
ff5=1
  elseif ff5==1 then
ff5=0
end
end

f6=0
ff6=0
function funcc6()
if ff6==0 then
    if f6==1 then
       enigma.KillStone(64,30)
f6=0
   elseif f6==0 then
	set_stone( "st-greenbrown", 64, 30)
f6=1
     end
ff6=1
  elseif ff6==1 then
ff6=0
end
end

f7=0
ff7=0
function funcc7()
if ff7==0 then
    if f7==1 then
       enigma.KillStone(65,30)
f7=0
   elseif f7==0 then
	set_stone( "st-greenbrown", 65, 30)
f7=1
     end
ff7=1
  elseif ff7==1 then
ff7=0
end
end

f8=0
ff8=0
function funcc8()
if ff8==0 then
    if f8==1 then
       enigma.KillStone(66,30)
f8=0
   elseif f8==0 then
	set_stone( "st-greenbrown", 66, 30)
f8=1
     end
ff8=1
  elseif ff8==1 then
ff8=0
end
end

f9=0
ff9=0
function funcc9()
if ff9==0 then
    if f9==1 then
       enigma.KillStone(67,30)
f9=0
   elseif f9==0 then
	set_stone( "st-greenbrown", 67, 30)
f9=1
     end
ff9=1
  elseif ff9==1 then
ff9=0
end
end

f10=0
ff10=0
function funcc10()
if ff10==0 then
    if f10==1 then
       enigma.KillStone(68,30)
f10=0
   elseif f10==0 then
	set_stone( "st-greenbrown", 68, 30)
f10=1
     end
ff10=1
  elseif ff10==1 then
ff10=0
end
end

f11=0
ff11=0
function funcc11()
if ff11==0 then
    if f11==1 then
       enigma.KillStone(64,31)
f11=0
   elseif f11==0 then
	set_stone( "st-greenbrown", 64, 31)
f11=1
     end
ff11=1
  elseif ff11==1 then
ff11=0
end
end

f12=0
ff12=0
function funcc12()
if ff12==0 then
    if f12==1 then
       enigma.KillStone(65,31)
f12=0
   elseif f12==0 then
	set_stone( "st-greenbrown", 65, 31)
f12=1
     end
ff12=1
  elseif ff12==1 then
ff12=0
end
end

f13=0
ff13=0
function funcc13()
if ff13==0 then
    if f13==1 then
       enigma.KillStone(66,31)
f13=0
   elseif f13==0 then
	set_stone( "st-greenbrown", 66, 31)
f13=1
     end
ff13=1
  elseif ff13==1 then
ff13=0
end
end

f14=0
ff14=0
function funcc14()
if ff14==0 then
    if f14==1 then
       enigma.KillStone(67,31)
f14=0
   elseif f14==0 then
	set_stone( "st-greenbrown", 67, 31)
f14=1
     end
ff14=1
  elseif ff14==1 then
ff14=0
end
end

f15=0
ff15=0
function funcc15()
if ff15==0 then
    if f15==1 then
       enigma.KillStone(68,31)
f15=0
   elseif f15==0 then
	set_stone( "st-greenbrown", 68, 31)
f15=1
     end
ff15=1
  elseif ff15==1 then
ff15=0
end
end

f16=0
ff16=0
function funcc16()
if ff16==0 then
    if f16==1 then
       enigma.KillStone(64,32)
f16=0
   elseif f16==0 then
	set_stone( "st-greenbrown", 64, 32)
f16=1
     end
ff16=1
  elseif ff16==1 then
ff16=0
end
end

f17=0
ff17=0
function funcc17()
if ff17==0 then
    if f17==1 then
       enigma.KillStone(65,32)
f17=0
   elseif f17==0 then
	set_stone( "st-greenbrown", 65, 32)
f17=1
     end
ff17=1
  elseif ff17==1 then
ff17=0
end
end

f18=0
ff18=0
function funcc18()
if ff18==0 then
    if f18==1 then
       enigma.KillStone(66,32)
f18=0
   elseif f18==0 then
	set_stone( "st-greenbrown", 66, 32)
f18=1
     end
ff18=1
  elseif ff18==1 then
ff18=0
end
end

f19=0
ff19=0
function funcc19()
if ff19==0 then
    if f19==1 then
       enigma.KillStone(67,32)
f19=0
   elseif f19==0 then
	set_stone( "st-greenbrown", 67, 32)
f19=1
     end
ff19=1
  elseif ff19==1 then
ff19=0
end
end

f20=0
ff20=0
function funcc20()
if ff20==0 then
    if f20==1 then
       enigma.KillStone(68,32)
f20=0
   elseif f20==0 then
	set_stone( "st-greenbrown", 68, 32)
f20=1
     end
ff20=1
  elseif ff20==1 then
ff20=0
end
end

f21=0
ff21=0
function funcc21()
if ff21==0 then
    if f21==1 then
       enigma.KillStone(64,33)
f21=0
   elseif f21==0 then
	set_stone( "st-greenbrown", 64, 33)
f21=1
     end
ff21=1
  elseif ff21==1 then
ff21=0
end
end

f22=0
ff22=0
function funcc22()
if ff22==0 then
    if f22==1 then
       enigma.KillStone(65,33)
f22=0
   elseif f22==0 then
	set_stone( "st-greenbrown", 65, 33)
f22=1
     end
ff22=1
  elseif ff22==1 then
ff22=0
end
end

f23=0
ff23=0
function funcc23()
if ff23==0 then
    if f23==1 then
       enigma.KillStone(66,33)
f23=0
   elseif f23==0 then
	set_stone( "st-greenbrown", 66, 33)
f23=1
     end
ff23=1
  elseif ff23==1 then
ff23=0
end
end

f24=0
ff24=0
function funcc24()
if ff24==0 then
    if f24==1 then
       enigma.KillStone(67,33)
f24=0
   elseif f24==0 then
	set_stone( "st-greenbrown", 67, 33)
f24=1
     end
ff24=1
  elseif ff24==1 then
ff24=0
end
end

f25=0
ff25=0
function funcc25()
if ff25==0 then
    if f25==1 then
       enigma.KillStone(68,33)
f25=0
   elseif f25==0 then
	set_stone( "st-greenbrown", 68, 33)
f25=1
     end
ff25=1
  elseif ff25==1 then
ff25=0
end
end

-- # #  
--  ####
--  #   
-- #### 
--   ###
-- 1,0,1,0,0
-- 0,1,1,1,1
-- 0,1,0,0,0
-- 1,1,1,1,0
-- 0,0,1,1,1
function funcc26()
    if  f1==1 and f2==0 and f3==1 and f4==0 and f5==0 
        and  f6==0 and f7==1 and f8==1 and f9==1 and f10==1 
        and f11==0 and f12==1 and f13==0 and f14==0 and f15==0 
        and f16==1 and f17==1 and f18==1 and f19==1 and f20==0 
        and f21==1 and f22==0 and f23==1 and f24==1 and f25==1 
    then
        SendMessage("door1", "openclose")
	SendMessage("door2", "openclose")
    end
end
