-- Laser Splitting, a level for Enigma
-- Copyright (C) 2006 Lukas Schueller
-- Licensed under GPL v2.0 or above
-------------------------------------------------
CreateWorld(20,13)
draw_checkerboard_floor("fl-tigris","fl-bluegray",0,0,20,13)
function writeLine( line, cells)
  for i=1, strlen(cells) do
    local c = strsub(cells,i,i)
    if(c =="#") then
      set_stone("st-wood_001",i-1,line)
    elseif(c =="z") then
      set_stone("st-laserswitch",i-1,line)
    elseif(c =="e") then
      set_stone("st-laser-e",i-1,line)
    elseif(c =="*") then
      set_stone("st-switch",i-1,line)
    elseif(c =="x") then
      set_stone("st-grate1",i-1,line)
    elseif(c =="s") then
      set_stone("st-laser-s",i-1,line)
    elseif(c =="b") then
      set_stone("st-door_b",i-1,line)
    elseif(c =="/") then
      set_stone("st-mirror-p\\m",i-1,line)
    elseif(c =="<") then
      set_stone("st-mirror-3>m",i-1,line)
    elseif(c =="o")  then
      oxyd(i-1,line)
    elseif(c =="0") then
      set_actor("ac-blackball",i-0.5,line+0.5,{player="0"})
    end
  end
end
writeLine(00,"#############*####o#")
writeLine(01,"#        /x/#    bb#")
writeLine(02,"# ####z##  x# /  #b#")
writeLine(03,"# ##zz#zzs x# <  #b#")
writeLine(04,"# #z0      x# /  #b#")
writeLine(05,"# #z < <<  x# <  #b#")
writeLine(06,"# z#  <    x# // #b#")
writeLine(07,"# #z < #z# x# <  #b#")
writeLine(08,"# #z < z#  x# /  #b#")
writeLine(09,"#/ e   #   x# <  #b#")
writeLine(10,"#x            /  #b#")
writeLine(11,"#/xxxxxxxx x#    #b#")
writeLine(12,"##################o#")
SetAttrib(enigma.GetStone(3,9),"init",FALSE)
SetAttrib(enigma.GetStone(9,3),"init",FALSE)
Signal ("st(13 0)","st(3 9)")
Signal ("st(13 0)","st(9 3)")
Signal ("st(8 3)","st(17 1)")
Signal ("st(7 3)","st(18 1)")
Signal ("st(6 2)","st(18 2)")
Signal ("st(5 3)","st(18 3)")
Signal ("st(4 3)","st(18 4)")
Signal ("st(3 4)","st(18 5)")
Signal ("st(3 5)","st(18 6)")
Signal ("st(2 6)","st(18 7)")
Signal ("st(3 7)","st(18 8)")
Signal ("st(3 8)","st(18 9)")
Signal ("st(8 7)","st(18 10)")
Signal ("st(7 8)","st(18 11)")
oxyd_shuffle()


