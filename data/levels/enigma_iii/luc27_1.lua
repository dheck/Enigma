-- Changing Positions, a level for Enigma
-- Copyright (C) 2006 Lukas Schueller
-- Licensed under GPL v2.0 or above
------------------------------
done=0
function change_grates()
  if(done == 0) then
    writeLine(03,"      k   x   k")
    writeLine(04,"      k   x   k")
    writeLine(05,"      k   x   k")
    writeLine(06,"      k   x   k")
    writeLine(07,"      k   x   k")
    writeLine(08,"      k   x   k")
    writeLine(09,"      k   x   k")
    done=1
  end
end
function writeLine( line, cells)
  for i=1, strlen(cells) do
    local c = strsub(cells,i,i)
    if(c =="#") then
      set_stone("st-rock8",i-1,line)
    elseif(c =="~") then
      set_floor("fl-water",i-1,line)
    elseif(c =="+") then
      set_stone("st-wood",i-1,line)
    elseif(c =="*") then
      set_stone("st-brownie",i-1,line)
    elseif(c =="x") then
      set_stone("st-grate1",i-1,line)
    elseif(c =="s") then
      set_stone("st-switch",i-1,line,{action="callback",target="change_grates"})
    elseif(c =="A") then
      set_stone("st-door",i-1,line,{name="doora",type="v"})
    elseif(c =="B") then
      set_stone("st-door",i-1,line,{name="doorb",type="v"})
    elseif(c =="C") then
      set_stone("st-door",i-1,line,{name="doorc",type="v"})
    elseif(c =="D") then
      set_stone("st-door",i-1,line,{name="doord",type="v"})
    elseif(c =="E") then
      set_stone("st-door",i-1,line,{name="doore",type="v"})
    elseif(c =="F") then
      set_stone("st-door",i-1,line,{name="doorf",type="v"})
    elseif(c =="G") then
      set_stone("st-door",i-1,line,{name="doorg",type="v"})
    elseif(c =="H") then
      set_stone("st-door",i-1,line,{name="doorh",type="v"})
    elseif(c =="I") then
      set_stone("st-door",i-1,line,{name="doori",type="v"})
    elseif(c =="J") then
      set_stone("st-door",i-1,line,{name="doorj",type="v"})
    elseif(c =="a") then
      set_item("it-trigger",i-1,line,{action="openclose",target="doora"})
    elseif(c =="b") then
      set_item("it-trigger",i-1,line,{action="openclose",target="doorb"})
    elseif(c =="c") then
      set_item("it-trigger",i-1,line,{action="openclose",target="doorc"})
    elseif(c =="d") then
      set_item("it-trigger",i-1,line,{action="openclose",target="doord"})
    elseif(c =="e") then
      set_item("it-trigger",i-1,line,{action="openclose",target="doore"})
    elseif(c =="f") then
      set_item("it-trigger",i-1,line,{action="openclose",target="doorf"})
    elseif(c =="g") then
      set_item("it-trigger",i-1,line,{action="openclose",target="doorg"})
    elseif(c =="h") then
      set_item("it-trigger",i-1,line,{action="openclose",target="doorh"})
    elseif(c =="i") then
      set_item("it-trigger",i-1,line,{action="openclose",target="doori"})
    elseif(c =="j") then
      set_item("it-trigger",i-1,line,{action="openclose",target="doorj"})
    elseif(c =="k") then
      kill_stone(i-1,line)
    elseif(c =="o")  then
      oxyd(i-1,line)
    elseif(c =="0") then
      set_actor("ac-blackball",i-0.5,line+0.5,{player="0"})
    end
  end
end

CreateWorld(20,13)
fill_floor("fl-sand",0,0,20,13)
----------------------------------
--Environment
writeLine(00,"####################")
writeLine(01,"##########oABCDE ###")
writeLine(02,"################~###")
writeLine(03,"###ab#x   0   x#~###")
writeLine(04,"###cd x ++ ** x~~###")
writeLine(05,"###e #x++   **x~~###")
writeLine(06,"##s  #x ++ ** x~ ###")
writeLine(07,"### f#x++   **x~~###")
writeLine(08,"###gh x ++ ** x~~###")
writeLine(09,"###ij#x       x#~###")
writeLine(10,"################~###")
writeLine(11,"##########oFGHIJ ###")
writeLine(12,"####################")
enigma.ConserveLevel = FALSE













