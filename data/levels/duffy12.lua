-- Copyright (c) 2003 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Just a Maze?

-- 2003-06-24: [ant]: changes in AddConstantForce

levelw = 100
levelh = 100

create_world(levelw, levelh)

fill_floor("fl-hay")

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
        local c = strsub( pattern, i, i)
        if c =="#" then
            set_stone( "st-greenbrown", i-1, line)
        elseif c == "o" then
            oxyd( i-1, line)
        elseif c == "K" then
            set_stone("st-key_a", i-1, line, {action="openclose", target="door1"})
        elseif c == "j" then
            set_stone("st-door", i-1, line , {name="door1", type="h"})
        elseif c == "n" then
            set_item("it-key_b", i-1 ,line)
        elseif c == "N" then
            set_stone("st-key_b", i-1, line, {action="openclose", target="door4"})
        elseif c == "p" then
            set_stone("st-door", i-1, line , {name="door4", type="v"})
        elseif c == "k" then
            set_item("it-key_a", i-1 ,line)
        elseif c == "v" then
            set_stone("st-door", i-1, line , {name="door2", type="h"})
        elseif c == "w" then
            set_item("it-trigger", i-1,line, {action="close", target="door2"})
        elseif c == "x" then
            set_stone("st-door", i-1, line , {name="door3", type="h"})
        elseif c == "y" then
            set_item("it-trigger", i-1,line, {action="close", target="door3"})
        elseif c == "a" then
            set_item("it-trigger", i-1,line, {action="off", target="laser1"})
        elseif c == "U" then
            set_stone("st-door", i-1, line , {name="door5", type="h"})
        elseif c == "u" then
            set_item("it-trigger", i-1,line, {action="close", target="door5"})

        elseif c == "l" then
            set_attrib( laser( i-1 , line, TRUE, WEST), "name", "laser1")
        elseif c == "d" then
            set_stone("st-death",i-1,line)
        elseif c == "1" then
            oneway(i-1,line, enigma.NORTH)
        elseif c == "z" then
            set_actor("ac-blackball", i-1,line)	
        elseif c == "s" then
            set_item("it-spring1",i-1,line)
        elseif c == "i" then
            set_stone("st-invisible",i-1,line)
        elseif c == "@" then
            document(i-1,line,"It isn't as easy as it looks.")
        end
    end
end

-- Floor:  " "
-- Border: "#"
-- Oxyd:   "o"

renderLine(00, "###################################d###########")
renderLine(01, "#        #   # s           d               d###")
renderLine(02, "## ## #### # # ####        #                ###")
renderLine(03, "## ## #    # # #          ### ############  ###")
renderLine(04, "## ## # #### # #          l     #        ## ###")
renderLine(05, "## ## #   #  # #                # ###### ## ###")
renderLine(06, "## ## ### # ## #aaaaaaaaaaa###### ##   # ##   #")
renderLine(07, "## ## ### #  # #d######### #o   # ## #   ##   #")
renderLine(08, "## ## ### i    ###########d#### # ## ### ##   #")
renderLine(09, "## ## ### ######                # #   ## ##   #")
renderLine(10, "## ## ###1###### ################ ### ## #d  o#")
renderLine(11, "## ## ### #      #                ### ## ######")
renderLine(12, "## ## ### #  ##### ############## ### ##     ##")
renderLine(13, "## ## ###1#  # @   #              ### ###### ##")
renderLine(14, "## ##o#o# #  #     # #### ########### #### # ##")
renderLine(15, "## #### # #  #  z  #    #                  # ##")
renderLine(16, "## ###       #     ## # #################### ##")
renderLine(17, "##   ##      #     ## #              i       ##")
renderLine(18, "####     oo  ######## #########################")
renderLine(19, "# n####  oo  #     ## #                      ##")
renderLine(20, "# ##o#       # ### ## # #################### ##")
renderLine(21, "#  # ##      #   # ## #               #      ##")
renderLine(22, "# ## ## #u#U#### # ## ############### # #######")
renderLine(23, "#  #    #o#  #   # ##                 #      ##")
renderLine(24, "# ########## # ### ## ############### ###### ##")
renderLine(25, "#        #   #   # ##               # #      ##")
renderLine(26, "######## # ### ### ################## # #######")
renderLine(27, "#        #     ##  #k                 #      ##")
renderLine(28, "######## ########j########################## ##")
renderLine(29, "# #    #   # p  # ##        #         #      ##")
renderLine(30, "# # ## ### # ## # ## ###### # ####### # #######")
renderLine(31, "# #  #     # ## # ## #      # #     # #      ##")
renderLine(32, "# ## ####### ## # ## # ###### # ### # ###### ##")
renderLine(33, "# #  #     # ## # ## #      # # #   # #      ##")
renderLine(34, "# # ## ##### ## # ## # #### # # # ### # #######")
renderLine(35, "# # #  #N  # ## # ## #   K# # # # #   #      ##")
renderLine(36, "#     #### # ## # ## # #### # # # # ###### # ##")
renderLine(37, "# ### #    # ##   ## #      # # # #        # ##")
renderLine(38, "# # ### #### ####### # ###### # ############ ##")
renderLine(39, "#                    #        #              ##")
renderLine(40, "###############################################")

oxyd_shuffle()

mytimer = 0
gravity=0
totgravity=0
function timer_handler()
    if mytimer==0 then
        SendMessage("door2", "open")
   	SendMessage("door3", "open")
	SendMessage("door5", "open")
    end
    mytimer = mytimer + 1
    if gravity<20 then
	if mytimer==20 then
	    gravity=gravity+1
	end
    elseif gravity>7 then
	if mytimer==30 then
	    gravity=gravity+1
	end
    end

    totgravity = totgravity+gravity
    enigma.AddConstantForce(0,totgravity)
end

set_stone( "st-timer", 0, 0, {action="callback", target="timer_handler"})

