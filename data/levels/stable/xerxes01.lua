-- Encased, a level for Enigma
-- Copyright (C) 2005 Xerxes M. Dynatos
-- Licensed under GPL v2.0 or above 
-- Enigma Level Version: 3

levelw=39
levelh=13
clear=0
CLEAR_OXYD = 0

create_world( levelw, levelh)

fill_floor("fl-metal2", 0,0,levelw,levelh)

function renderLine( line, pattern)
	for i=1, strlen(pattern) do
		local c = strsub( pattern, i, i)
		if c =="#" then
			set_stone( "st-blue-sand", i-1, line)

		elseif c == "1" then
			--oxyd( i-1, line)
			set_stone("st-oxyd", i-1, line, {name="o1", color="0"})

		elseif c == "2" then
			--oxyd( i-1, line)
			set_stone("st-oxyd", i-1, line, {name="o2", color="0"})

		elseif c == "3" then
			--oxyd( i-1, line)
			set_stone("st-oxyd", i-1, line, {name="o3", color="1"})

		elseif c == "4" then
			--oxyd( i-1, line)
			set_stone("st-oxyd", i-1, line, {name="o4", color="1"})

		elseif c == "5" then
			--oxyd( i-1, line)
			set_stone("st-oxyd", i-1, line, {name="o5", color="2"})

		elseif c == "6" then
			--oxyd( i-1, line)
			set_stone("st-oxyd", i-1, line, {name="o6", color="2"})

		elseif c == "7" then
			--oxyd( i-1, line)
			set_stone("st-oxyd", i-1, line, {name="o7", color="3"})

		elseif c == "8" then
			--oxyd( i-1, line)
			set_stone("st-oxyd", i-1, line, {name="o8", color="3"})

		elseif c == "9" then
			--oxyd( i-1, line)
			set_stone("st-oxyd", i-1, line, {name="o9", color="4"})

		elseif c == "0" then
			--oxyd( i-1, line)
			set_stone("st-oxyd", i-1, line, {name="o0", color="4"})

		elseif c == "z" then
			set_actor("ac-blackball", i-.5,line+.5)
			set_floor("fl-sand", i-1, line)

		elseif c == "T" then
			set_stone("st-timer", i-1, line, {invisible=1,loop=9999, action="callback", target="funcTimer", interval=1})
			--set_stone( "st-blue-sand", i-1, line)

		elseif c == "S" then
			set_floor("fl-sand", i-1, line)

		end
	end	
end


-- Floor:  " "
-- Border: "#"
-- Oxyd:   "o"
--             01234567890123456789012345678901234567890
renderLine(00,"#######################################")
renderLine(01,"#1####################2##############3#")
renderLine(02,"#######################################")
renderLine(03,"#########z#############################")
renderLine(04,"#######################################")
renderLine(05,"#4############5###################6####")
renderLine(06,"#######################################")
renderLine(07,"#######################################")
renderLine(08,"#######################################")
renderLine(09,"#########################7#############")
renderLine(10,"###############8#######################")
renderLine(11,"#9################################0####")
renderLine(12,"######################################T")

oxyd_shuffle()


function funcTimer()

if clear==0 then
clearLevelExcept(levelw,levelh,38,12)

-- Floor:  " "
-- Border: "#"
-- Oxyd:   "o"
--             01234567890123456789012345678901234567890
renderLine(00,"                                       ")
renderLine(01,"  S      S           S S            S  ")
renderLine(02," SS                  SSS            SS ")
renderLine(03,"         S                             ")
renderLine(04,"                                 SSS   ")
renderLine(05,"  SS        SS                   S S   ")
renderLine(06,"         S                       SSS   ")
renderLine(07,"                                       ")
renderLine(08,"                                       ")
renderLine(09,"                         S S           ")
renderLine(10," SS             SS               SSS   ")
renderLine(11,"  SS                                   ")
renderLine(12,"                                       ")

clear=clear+1
elseif clear==1 then

clearLevelExcept(levelw,levelh,38,12)
fill_floor("fl-metal2", 0,0,levelw,levelh)

-- Floor:  " "
-- Border: "#"
-- Oxyd:   "o"
--             01234567890123456789012345678901234567890
renderLine(00,"#######################################")
renderLine(01,"#  ###### ###########   ############  #")
renderLine(02,"#  ##################   ############  #")
renderLine(03,"######### #############################")
renderLine(04,"#################################   ###")
renderLine(05,"#   ########   ##################   ###")
renderLine(06,"######### #######################   ###")
renderLine(07,"#######################################")
renderLine(08,"#######################################")
renderLine(09,"#########################   ###########")
renderLine(10,"#  ############   ###############   ###")
renderLine(11,"#   ############################## ####")
renderLine(12,"###################################### ")

clear=clear+1

elseif clear==2 then
clearLevelExcept(levelw,levelh,38,12)
fill_floor("fl-metal2", 0,0,levelw,levelh)
-- Floor:  " "
-- Border: "#"
-- Oxyd:   "o"
--             01234567890123456789012345678901234567890 
renderLine(00,"                                       ")
renderLine(01,"                                       ")
renderLine(02,"                                       ")
renderLine(03,"         S                             ")
renderLine(04,"                                       ")
renderLine(05,"                                       ")
renderLine(06,"                                       ")
renderLine(07,"                                       ")
renderLine(08,"                                       ")
renderLine(09,"                                       ")
renderLine(10,"                                       ")
renderLine(11,"                                       ")
renderLine(12,"                                       ")

clear=clear+1
elseif clear==3 then
clearLevelExcept(levelw,levelh,38,12)
fill_floor("fl-metal2", 0,0,levelw,levelh)
-- Floor:  " "
-- Border: "#"
-- Oxyd:   "o"
--             01234567890123456789012345678901234567890
renderLine(00,"#######################################")
renderLine(01,"# #################### ############## #")
renderLine(02,"#######################################")
renderLine(03,"######### #############################")
renderLine(04,"#######################################")
renderLine(05,"# ############ ################### ####")
renderLine(06,"#######################################")
renderLine(07,"#######################################")
renderLine(08,"#######################################")
renderLine(09,"######################### #############")
renderLine(10,"############### #######################")
renderLine(11,"# ################################ ####")
renderLine(12,"###################################### ")
clear=0
end
end




function isoxyd(x, y)
  local st = enigma.GetStone(x, y)
  if (st ~= nil) and
    (enigma.GetKind(st) == "st-oxyd") then
    return 1
  else
    return 0
  end
end

function oxyd_Clear(x, y)
  if (isoxyd(x, y) == 0) or
    (CLEAR_OXYD == 1) then
    enigma.KillStone(x,y)
  end
  enigma.KillItem(x,y)
end 

function clearLevel(w, h)
  for y = 0, (h or level_height) - 1 do
    for x = 0, (w or level_width) - 1 do
      oxyd_Clear(x, y)
    end
  end
end

function clearLevelExcept(w, h, ex, ey)
  for y = 0, (h or level_height) - 1 do
    for x = 0, (w or level_width) - 1 do
      if (x == ex) and (y == ey) then
      else
	oxyd_Clear(x, y)
      end
    end
  end
end

display.SetFollowMode(display.FOLLOW_SCROLLING)




















