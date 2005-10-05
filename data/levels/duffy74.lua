-- Copyright (c) 2004 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Confetti

levelw=58
levelh=37

create_world( levelw, levelh)

fill_floor("fl-leaves", 0,0,levelw,levelh)

done_with_setup = 0

function renderLine( line, pattern)
   for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c =="#" then
	 set_stone( "st-glass", i-1, line)
      elseif c == "o" then
	 if done_with_setup== 0 then
	    oxyd( i-1, line)
	 end
      elseif c == "!" then
	 abyss(i-1,line)
	 --fill_floor("fl-water", i-1,line, 1,1)
      elseif c == " " then
	 enigma.KillStone(i-1,line)
      elseif c=="z" then
	 if done_with_setup==0 then
	    set_actor("ac-blackball", i-.5,line+.5, {player=0})
	 end
      elseif c=="+" then
	 set_stone( "st-wood", i-1, line)
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
	 set_stone( "st-glass", i-1, line)
      end
   end
end

for i=0, 60 do
   for j=0, 40 do
      xxx=random(13)
      if xxx==1 or xxx==2 or xxx==3 then
	 set_floor("fl-leaves",i,j)
      end
      if xxx==4 or xxx==5  or xxx==6 then
	 set_floor("fl-bluegreen",i,j)
      end
      if xxx==7 or xxx==8 or xxx==9 then 
	 set_floor("fl-sand",i,j)
      end
      if xxx==10 or xxx==11 or xxx==12 then
	 set_floor("fl-wood",i,j)
      end
      if xxx==13 then
	 set_floor("fl-inverse",i,j)
      end
   end
end

set_floor("fl-leaves",29,18)

through=0
swap=0
function funcc()
   
      myline18 = gsub(myline18, "z", " ")
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
      myline13 = gsub(myline13,"#", "B")
      myline14 = gsub(myline14, "#", "B")
      myline15 = gsub(myline15, "#", "B")
      myline16 = gsub(myline16, "#", "B")
      myline17 = gsub(myline17, "#", "B")
      myline18 = gsub(myline18, "#", "B")
      myline19 = gsub(myline19, "#", "B")
      myline20 = gsub(myline20, "#", "B")
      myline21 = gsub(myline21, "#", "B")
      myline22 = gsub(myline22, "#", "B")
      myline23 = gsub(myline23, "#", "B")
      myline24 = gsub(myline24, "#", "B")
      myline25 = gsub(myline25, "#", "B")
      myline26 = gsub(myline26, "#", "B")
      myline27 = gsub(myline27, "#", "B")
      myline28 = gsub(myline28, "#", "B")
      myline29 = gsub(myline29, "#", "B")
      myline30 = gsub(myline30, "#", "B")
      myline31 = gsub(myline31, "#", "B")
      myline32 = gsub(myline32, "#", "B")
      myline33 = gsub(myline33, "#", "B")
      myline34 = gsub(myline34, "#", "B")
      myline35 = gsub(myline35, "#", "B")
      myline36 = gsub(myline36, "#", "B")

      swap = 1


      myline0 = gsub(myline0, " ", "#")
      myline1 = gsub(myline1, " ", "#")
      myline2 = gsub(myline2, " ", "#")
      myline3 = gsub(myline3, " ", "#")
      myline4 = gsub(myline4, " ", "#")
      myline5 = gsub(myline5, " ", "#")
      myline6 = gsub(myline6, " ", "#")
      myline7 = gsub(myline7, " ", "#")
      myline8 = gsub(myline8, " ", "#")
      myline9 = gsub(myline9, " ", "#")
      myline10 = gsub(myline10, " ", "#")
      myline11 = gsub(myline11, " ", "#")
      myline12 = gsub(myline12, " ", "#")
      myline13 = gsub(myline13," ", "#")
      myline14 = gsub(myline14, " ", "#")
      myline15 = gsub(myline15, " ", "#")
      myline16 = gsub(myline16, " ", "#")
      myline17 = gsub(myline17, " ", "#")
      myline18 = gsub(myline18, " ", "#")
      myline19 = gsub(myline19, " ", "#")
      myline20 = gsub(myline20, " ", "#")
      myline21 = gsub(myline21, " ", "#")
      myline22 = gsub(myline22, " ", "#")
      myline23 = gsub(myline23, " ", "#")
      myline24 = gsub(myline24, " ", "#")
      myline25 = gsub(myline25, " ", "#")
      myline26 = gsub(myline26, " ", "#")
      myline27 = gsub(myline27, " ", "#")
      myline28 = gsub(myline28, " ", "#")
      myline29 = gsub(myline29, " ", "#")
      myline30 = gsub(myline30, " ", "#")
      myline31 = gsub(myline31, " ", "#")
      myline32 = gsub(myline32, " ", "#")
      myline33 = gsub(myline33, " ", "#")
      myline34 = gsub(myline34, " ", "#")
      myline35 = gsub(myline35, " ", "#")
      myline36 = gsub(myline36, " ", "#")


      myline0 = gsub(myline0, "B", " ")
      myline1 = gsub(myline1, "B", " ")
      myline2 = gsub(myline2, "B", " ")
      myline3 = gsub(myline3, "B", " ")
      myline4 = gsub(myline4, "B", " ")
      myline5 = gsub(myline5, "B", " ")
      myline6 = gsub(myline6, "B", " ")
      myline7 = gsub(myline7, "B", " ")
      myline8 = gsub(myline8, "B", " ")
      myline9 = gsub(myline9, "B", " ")
      myline10 = gsub(myline10, "B", " ")
      myline11 = gsub(myline11, "B", " ")
      myline12 = gsub(myline12, "B", " ")
      myline13 = gsub(myline13,"B", " ")
      myline14 = gsub(myline14, "B", " ")
      myline15 = gsub(myline15, "B", " ")
      myline16 = gsub(myline16, "B", " ")
      myline17 = gsub(myline17, "B", " ")
      myline18 = gsub(myline18, "B", " ")
      myline19 = gsub(myline19, "B", " ")
      myline20 = gsub(myline20, "B", " ")
      myline21 = gsub(myline21, "B", " ")
      myline22 = gsub(myline22, "B", " ")
      myline23 = gsub(myline23, "B", " ")
      myline24 = gsub(myline24, "B", " ")
      myline25 = gsub(myline25, "B", " ")
      myline26 = gsub(myline26, "B", " ")
      myline27 = gsub(myline27, "B", " ")
      myline28 = gsub(myline28, "B", " ")
      myline29 = gsub(myline29, "B", " ")
      myline30 = gsub(myline30, "B", " ")
      myline31 = gsub(myline31, "B", " ")
      myline32 = gsub(myline32, "B", " ")
      myline33 = gsub(myline33, "B", " ")
      myline34 = gsub(myline34, "B", " ")
      myline35 = gsub(myline35, "B", " ")
      myline36 = gsub(myline36, "B", " ")
      swap = 0

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
   renderLine(13, myline13)
   renderLine(14, myline14)
   renderLine(15, myline15)
   renderLine(16, myline16)
   renderLine(17, myline17)
   renderLine(18, myline18)
   renderLine(19, myline19)
   renderLine(20, myline20)
   renderLine(21, myline21)
   renderLine(22, myline22)
   renderLine(23, myline23)
   renderLine(24, myline24)
   renderLine(25, myline25)
   renderLine(26, myline26)
   renderLine(27, myline27)
   renderLine(28, myline28)
   renderLine(29, myline29)
   renderLine(30, myline30)
   renderLine(31, myline31)
   renderLine(32, myline32)
   renderLine(33, myline33)
   renderLine(34, myline34)
   renderLine(35, myline35)
   renderLine(36, myline36)
   if through==1 then
      through=0
   end
   through=through+1
end

-- Floor:  " "
-- Border: "#"
-- Oxyd:   "o"
 
myline0 ="mooommmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm"
myline1 ="o#### # #   #              #      #   #   #   #          m"
myline2 ="o#oo# #   #### ########### ####h#   #   # # # # ######## m"
myline3 ="o#oo#   # #    #   # #   #    # ######### # # # #        m"
myline4 ="m####h# # # #### # # # # #### #        #    #   # #######m"
myline5 ="m     # # # #    #     #    # ######## ########## #   #  m"
myline6 ="m # # # # # # ############# #        #          #   #   #m"
myline7 ="m # # ### # # #           # ######## ########## #######  m"
myline8 ="m # #   # # # # ######### # # # #             h       ## m"
myline9 ="m # ### # # # # #     # # # # # ######### ########### #  m"
myline10="m # # # # # # # # # # # # # # # #   #   # #   # #   # # #m"
myline11="m # #   # # # # # # # # # # # # # # # # # # # #   # # #  m"
myline12="m # ####### # # # # # # # # # #   #   # # # # ##### # ## m"
myline13="m # # #   # # # # # # # # # # ######### # # #       #  # m"
myline14="m # # # #     # # # # # # # #       #   # # ########## # m"
myline15="m # # # ####### # # # # # # ###### #### #        #     # m"
myline16="m # # # #       # # # # # #           # ######## # ##### m"
myline17="m # #   # ####### # # # # # ######### #    #   # #     # m"
myline18="m # ##### #     # # # # #   #z#     # ## ### # # # ##### m"
myline19="m # # h # # ##### # ### ##### ##### #  # # # # # #   #   m"
myline20="m # # # # # #     #   #           # ## # # # # ##### # # m"
myline21="m # # # # # # ############# ##### #  #   #   # #   # ### m"
myline22="m ### # # # # #   #   #   #   # # ## ### ##### ### # #   m"
myline23="m     #   # # # #   #   # # #   # #    #       # # # # ##m"
myline24="m#### ##### # # ################# # ## ##### # # # # #   m"
myline25="m     #   # # #           #       #  #     # ### # # ### m"
myline26="m ##### # # # ########### # ##### ## ##### # #   # # #   m"
myline27="m     # # # #  #        # #     # #  #   # # # # # # # ##m"
myline28="m#### # # # ## # ###### # # ### # # ## # # #   # # # #   m"
myline29="m     # #      # #      # #   # # #    # # ##### # # ### m"
myline30="m ##### ###### # # ###### ### # # #### ### #   # # #   # m"
myline31="m     #      # # #            # #        # # # # # # ### m"
myline32="m#### # ###### ########################### # # # # # #   m"
myline33="m     # #                                  # # # # # #hhhm"
myline34="m ##### #################################### # ### # #hAhm"
myline35="m                                            #     # #hhhm"
myline36="mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm"

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
   renderLine(13, myline13)
   renderLine(14, myline14)
   renderLine(15, myline15)
   renderLine(16, myline16)
   renderLine(17, myline17)
   renderLine(18, myline18)
   renderLine(19, myline19)
   renderLine(20, myline20)
   renderLine(21, myline21)
   renderLine(22, myline22)
   renderLine(23, myline23)
   renderLine(24, myline24)
   renderLine(25, myline25)
   renderLine(26, myline26)
   renderLine(27, myline27)
   renderLine(28, myline28)
   renderLine(29, myline29)
   renderLine(30, myline30)
   renderLine(31, myline31)
   renderLine(32, myline32)
   renderLine(33, myline33)
   renderLine(34, myline34)
   renderLine(35, myline35)
   renderLine(36, myline36)

oxyd_shuffle()
done_with_setup = 1

display.SetFollowMode(display.FOLLOW_SCROLLING)
