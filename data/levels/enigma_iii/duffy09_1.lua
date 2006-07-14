-- Copyright (c) 2003 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Double-Maze

levelw=80
levelh=40

create_world( levelw, levelh)

fill_floor("fl-leaves", 0,0,levelw,levelh)

done_with_setup = 0

function renderLine( line, pattern)
	for i=1, strlen(pattern) do
		local c = strsub( pattern, i, i)
		if c =="#" then
			set_stone( "st-glass", i-1, line)
		elseif c == "o" then
			if done_with_setup == 0 then
			   oxyd( i-1, line)
			end
                elseif c == "!" then
			abyss(i-1,line)
--			fill_floor("fl-water", i-1,line, 1,1)
		elseif c=="z" then
			set_actor("ac-blackball", i-.5,line+.5)
		elseif c=="+" then
			set_stone( "st-wood", i-1, line)
		elseif c=="1" then
			doorv( i-1,line, {name="door1"})
		elseif c=="W" then
			set_attrib(laser(i-1,line, FALSE, WEST), "name", "laser")
		elseif c=="L" then
			set_stone("st-key_a", i-1,line, {action="on", target="laser"})
		elseif c=="k" then
			set_item("it-key_a", i-1,line)
		elseif c=="`" then
			mirrorp(i-1,line,FALSE,TRUE, 2)
		elseif c=="/" then
			mirrorp(i-1,line,FALSE,TRUE, 4)
		elseif c=="B" then
			set_stone("st-bombs", i-1,line)
		elseif c=="g" then
			draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
		elseif c=="A" then
           if done_with_setup==0 then
              set_stone("st-switch", i-1,line, {action="callback",target="funcc"})
           end
		elseif c=="h" then
     		   	draw_stones("st-grate2",{i-1,line}, {1,1}, 1)
		elseif c=="m" then
		        set_stone("st-marble",i-1,line)
		end
	end	
end

through=0
swap=0
function funcc()
   
--   handle = openfile("c:/users/Jacob/lualog.txt", "a")
--   write(handle, "myline started as ")
--   write(handle, myline)
--   write(handle, "\n")
   
--   if swap == 0 then
      myline0 = gsub(myline0, "#", "B")
      myline1 = gsub(myline1, "#", "B")
      myline2 = gsub(myline2, "#", "B")
      myline3 = gsub(myline3, "#", "B")
      myline4 = gsub(myline4, "#", "B")
      myline5 = gsub(myline5, "#", "B")
      myline6 = gsub(myline6, "#", "B")
      myline7 = gsub(myline7, "#", "B")
      myline8 = gsub(myline8, "#", "B")
      myline9 = gsub(myline9, "#", "B")
      myline10 = gsub(myline10, "#", "B")
      myline11 = gsub(myline11, "#", "B")
      myline12 = gsub(myline12, "#", "B")
      swap = 1
--   else
      myline0 = gsub(myline0, "g", "#")
      myline1 = gsub(myline1, "g", "#")
      myline2 = gsub(myline2, "g", "#")
      myline3 = gsub(myline3, "g", "#")
      myline4 = gsub(myline4, "g", "#")
      myline5 = gsub(myline5, "g", "#")
      myline6 = gsub(myline6, "g", "#")
      myline7 = gsub(myline7, "g", "#")
      myline8 = gsub(myline8, "g", "#")
      myline9 = gsub(myline9, "g", "#")
      myline10 = gsub(myline10, "g", "#")
      myline11 = gsub(myline11, "g", "#")
      myline12 = gsub(myline12, "g", "#")

      myline0 = gsub(myline0, "B", "g")
      myline1 = gsub(myline1, "B", "g")
      myline2 = gsub(myline2, "B", "g")
      myline3 = gsub(myline3, "B", "g")
      myline4 = gsub(myline4, "B", "g")
      myline5 = gsub(myline5, "B", "g")
      myline6 = gsub(myline6, "B", "g")
      myline7 = gsub(myline7, "B", "g")
      myline8 = gsub(myline8, "B", "g")
      myline9 = gsub(myline9, "B", "g")
      myline10 = gsub(myline10, "B", "g")
      myline11 = gsub(myline11, "B", "g")
      myline12 = gsub(myline12, "B", "g")
      swap = 0
--   end

   
--   write(handle, "myline is now ")
--   write(handle, myline)
--   write(handle, "\n")
--   flush(handle)
--   closefile(handle)

   renderLine(00, myline0)
   renderLine(01, myline1)
   renderLine(02, myline2)
   renderLine(03, myline3)
   renderLine(04, myline4)
   renderLine(05, myline5)
   renderLine(06, myline6)
   renderLine(07, myline7)
   renderLine(08, myline8)
   renderLine(09, myline9)
   renderLine(10, myline10)
   renderLine(11, myline11)
   renderLine(12, myline12)

    if through==1 then
	through=0
    end
--    if through==0 then
--	for i=1, strlen(pattern) do
--	    local c = strsub( pattern, i, i)
--	    if c =="#" then
--		set_stone("st-greenbrown",i-1,line)
--	    end
--	end		
--    end
    through=through+1
end

-- Floor:  " "
-- Border: "#"
-- Oxyd:   "o"
 
myline0= "mommmmommmmmmmmmmomm"
myline1= "mh###ggg########gg#o"
myline2= "mggg#g#gg##gggghg##m"
myline3= "m#gg#h####ghhhg###go"
myline4= "m###ghgg#gghAhgg#ggm"
myline5= "m#g###gg#g#hhhg##h#m"
myline6= "m#gggg#ggggg#ggggg#m"
myline7= "m######g#######g#g#m"
myline8= "mg#gg#gg#g#gggg####m"
myline9= "m####ggggg#g#g##gggm"
myline10="mg#g###g###h#ghgg#gm"
myline11="o##ggh#ggggg###gg#hm"
myline12="mmmmmommmmmmmmmmmmom"

--myline0=  "mmmmmmmmmmmmmmmmmmmm")
--myline1=  "m                  m")
--myline2=  "m########## ####   m")
--myline3=  "m#        # #  ### m")
--myline4=  "m#    ### # #   #  m")
--myline5=  "m# #### # ###   ## m")
--myline6=  "m# #    #    ggg # m")
--myline7=  "m# #### ###z gAg # m")
--myline8=  "m#   ###  ###ggg # m")
--myline9=  "m#     ###       # m")
--myline10= "m######  ######### m")
--myline11= "m     #            m")
--myline12= "mmmmmmmmmmmmmmmmmmmm")
   renderLine(00, myline0)
   renderLine(01, myline1)
   renderLine(02, myline2)
   renderLine(03, myline3)
   renderLine(04, myline4)
   renderLine(05, myline5)
   renderLine(06, myline6)
   renderLine(07, myline7)
   renderLine(08, myline8)
   renderLine(09, myline9)
   renderLine(10, myline10)
   renderLine(11, myline11)
   renderLine(12, myline12)

oxyd_shuffle()
done_with_setup = 1

set_actor("ac-blackball", 9.5,6.5)
















