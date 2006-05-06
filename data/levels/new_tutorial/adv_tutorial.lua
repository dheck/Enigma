-- Copyright (c) 2004 Jacob Scott
-- License: GPL v2.0 or above

rooms_wide=6
rooms_high=4

levelw=1+(19*rooms_wide)+1
levelh=1+(12*rooms_high)

create_world( levelw, levelh)

oxyd_default_flavor="a"

fill_floor("fl-leaves", 0,0,levelw,levelh)

function renderLine( line, pattern)
	for i=1, strlen(pattern) do
		local c = strsub( pattern, i, i)
		if c =="#" then
			set_stone( "st-rock1", i-1, line)
		elseif c =="Z" then
			set_stone( "st-rock1", i-1, line)
		   set_floor("fl-hay",i-1,line)
		elseif c =="^" then
			set_stone( "st-window", i-1, line)
		elseif c =="0" then
			set_stone( "st-knight", i-1, line)
		elseif c =="|" then
		   mirrorp(i-1,line,TRUE,FALSE,3)
		elseif c =="r" then
			set_stone( "st-brownie", i-1, line)
		   set_actor("ac-rotor", i-.5,line+.5, {controllers=0,gohome=FALSE,force=20,range=8})
		elseif c =="X" then
			set_stone( "st-death", i-1, line)
		elseif c =="_" then
			set_stone( "st-actorimpulse", i-1, line)
			set_floor("fl-hay",i-1,line)
		elseif c =="`" then
			set_stone( "st-rock6", i-1, line)
		elseif c =="." then
			set_stone( "st-rock3_break", i-1, line)
		elseif c =="Q" then
			set_stone( "st-rock1", i-1, line)
			set_floor("fl-inverse",i-1,line)
		elseif c =="%" then
			set_stone( "st-block", i-1, line)
		elseif c =="b" then
			set_stone( "st-black4", i-1, line)
		elseif c == "o" then
			oxyd( i-1, line)
		elseif c == "*" then
			set_stone( "st-brownie", i-1, line)
                elseif c == "!" then
			abyss(i-1,line)
		elseif c == "~" then
		   set_floor("fl-water",i-1,line)
		elseif c=="z" then
		   set_actor("ac-blackball", i-1,line+.5, {player=0})
		elseif c=="w" then
		   set_actor("ac-whiteball-small", i-.5,line+.5, {controllers=0})
		   set_floor("fl-hay",i-1,line)
		elseif c=="T" then
		   set_actor("ac-top", i-.5,line+.5, {controllers=0,force=10,range=7})
		elseif c == "g" then
			draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
		elseif c=="+" then
			set_stone( "st-wood", i-1, line)
		elseif c=="=" then
			set_floor("fl-space",i-1,line)
		elseif c=="m" then
			set_floor("fl-metal",i-1,line)
		elseif c=="q" then
			set_floor("fl-inverse",i-1,line)
		elseif c=="i" then
			set_floor("fl-ice_001",i-1,line)
		elseif c=="h" then
			set_floor("fl-hay",i-1,line)
		elseif c=="y" then
			set_floor("fl-sand",i-1,line)
		elseif c=="Y" then
			fill_floor("fl-hay",i-1,line-1,21,13)
		elseif c=="O" then
			set_item("it-extralife",i-1,line)
		elseif c=="," then
			set_item("it-dynamite",i-1,line)
		elseif c==";" then
			set_item("it-dynamite",i-1,line)
			set_floor("fl-ice_001",i-1,line)
		elseif c=="?" then
			set_item("it-spade",i-1,line)
		elseif c==":" then
			set_item("it-magicwand",i-1,line)
		elseif c=="p" then
			set_item("it-coin1",i-1,line)
		elseif c=="v" then
			set_item("it-spoon",i-1,line)
			set_floor("fl-hay",i-1,line)
		elseif c=="<" then
		   set_stone("st-oneway_white", i-1,line, {orientation=enigma.WEST})
		   set_floor("fl-hay",i-1,line)
		elseif c=="S" then
		   set_stone("st-oneway_black", i-1,line, {orientation=enigma.NORTH})
		   set_floor("fl-hay",i-1,line)
		elseif c=="@" then
		   set_stone("st-oneway", i-1,line, {orientation=enigma.SOUTH})
		   set_floor("fl-hay",i-1,line)
		elseif c=="-" then
		   set_stone("st-oneway_white", i-1,line, {orientation=enigma.SOUTH})
		   set_floor("fl-hay",i-1,line)
		elseif c=="5" then
		   doorv(i-1,line,{name="d1"})
		elseif c=="$" then
		   doorh(i-1,line,{name="d2"})
		elseif c==">" then
		   doorh(i-1,line,{name="d3"})
		elseif c=="j" then
		   doorh(i-1,line,{name="d4"})
		   set_floor("fl-hay",i-1,line)
		elseif c=="k" then
		   doorh(i-1,line,{name="d5"})
		   set_floor("fl-hay",i-1,line)
		elseif c=="l" then
		   doorh(i-1,line,{name="d6"})
		elseif c=="'" then
		   set_floor("fl-bridge",i-1,line,{name="b1"})
		elseif c=="&" then
		   set_stone("st-switch",i-1,line,{action="openclose",target="d3"})
		elseif c=="e" then
		   set_item("it-trigger",i-1,line,{action="openclose",target="d4"})
		   set_floor("fl-hay",i-1,line)
		elseif c=="f" then
		   set_item("it-trigger",i-1,line,{action="openclose",target="d5"})
		   set_floor("fl-hay",i-1,line)
		elseif c=="n" then
		   set_item("it-trigger",i-1,line,{action="openclose",target="d6"})
		   set_floor("fl-hay",i-1,line)
		elseif c=="U" then
		   draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
		   set_item("it-trigger",i-1,line,{invisible=1,action="callback",target="funcc2"})
		   set_floor("fl-hay",i-1,line)
		elseif c=="s" then
		   set_item("it-trigger",i-1,line,{invisible=1,action="callback",target="funcc1"})
		elseif c=="t" then
		   set_stone("st-laserswitch",i-1,line,{action="openclose",target="b1"})
		elseif c=="a" then
			set_attrib(laser(i-1,line, FALSE, WEST), "name", "l1")
		elseif c=="u" then
			set_stone("st-bolder", i-1,line, {direction=NORTH})
		elseif c=="c" then
			set_stone("st-bolder", i-1,line, {direction=EAST})
		elseif c=="d" then
			set_stone("st-bolder", i-1,line, {direction=SOUTH})
        elseif c == "2" then
            set_floor("fl-gradient",  i-1,  line, {type=1})
        elseif c == "8" then
            set_floor("fl-gradient",  i-1,  line, {type=2})
        elseif c == "6" then
            set_floor("fl-gradient",  i-1,  line, {type=3})
        elseif c == "4" then
            set_floor("fl-gradient",  i-1,  line, {type=4})
        elseif c == "1" then
            set_floor("fl-gradient",  i-1,  line, {type=11})
        elseif c == "3" then
            set_floor("fl-gradient",  i-1,  line, {type=9})
        elseif c == "7" then
            set_floor("fl-gradient",  i-1,  line, {type=12})
        elseif c == "9" then
            set_floor("fl-gradient",  i-1,  line, {type=10})
		elseif c=="A" then
		   document(i-1,line,"Welcome to Enigma!  This tutorial I (Jacob Scott) made will help you learn how to play.")
		elseif c=="B" then
		   document(i-1,line,"You control the black ball.  To pick up an object, just roll over it.  You can bounce off most walls (try it), but avoid the blue floor near the bottom of the room (actually, try falling into it and then restarting the level with the 'Esc' key).  While these messages are being displayed, don't click any buttons or push any keys or the message will stop.")
		elseif c=="C" then
		   document(i-1,line,"This is pretty self-explanatory.")
		elseif c=="D" then
		   document(i-1,line,"Enigma is full of puzzles of various types.  In the next room, you will encounter your first one.")
		elseif c=="E" then
		   document(i-1,line,"You can't walk on water!  Try pushing the blocks into the water to get to the other side.")
		elseif c=="F" then
		   document(i-1,line,"Notice that you can't push a row of two or more blocks.  Also, blocks can't be on the same squares as grates but you can.")
		elseif c=="G" then
		   document(i-1,line,"There are different types of blocks here.  Those black blocks sink when they fall into water.  The tan blocks don't sink but don't form bridges either.")
		elseif c=="H" then
		   document(i-1,line,"That thing is a top -- it will destroy your ball if they touch.  Also, as long as you are close enough to it, the top will chase you.  If you die, you will restart at the beginning of the level (if you have any balls left).  Try to find a way to get past and into the next room (you can use the blocks in the center of the room as barricades).")
		elseif c=="I" then
		   document(i-1,line,"Good job!  Notice that the top can't go beneath that block with a black outline -- you're safe.")
		elseif c=="J" then
		   document(i-1,line,"Those are different types of floors.  Try going over them.")
		elseif c=="K" then
		   document(i-1,line,"The grayish floors are slopes.  The white floor is inverse-floor (you will see).")
		elseif c=="L" then
		   document(i-1,line,"Watch what happens when you go over those triggers.  See if you can get the extra ball.")
		elseif c=="M" then
		   document(i-1,line,"That's dynamite.  Try dropping some next to that yellowish wall (and moving out of the way).")
		elseif c=="N" then
		   document(i-1,line,"Try using the spade on the holes caused by the dynamite.")
		elseif c=="P" then
		   document(i-1,line,"Those things are boulders -- try moving one of the tan blocks.  Don't fall into the water or abyss (the black floor).")
		elseif c=="R" then
		   document(i-1,line,"Take the magic wand and hit a boulder.  Try to let the row of three boulders pass the large column.")
	elseif c=="U" then
		   document(i-1,line,"Hit it hard enough!")
		   set_floor("fl-hay",i-1,line)
		elseif c=="V" then
		   document(i-1,line,"It appears to be a simple room, but you're getting an extra ball anyway.  Maybe there is a reason....")
		elseif c=="W" then
		   document(i-1,line,"Try to get the laser beam to hit that black stone, but don't get hit by it!  Use the mirrors to direct the beam.")
		elseif c=="x" then
		   set_stone("st-fart",i-1,line)
	     end
	end	
     end

renderLine(00,"#############################################################################~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
renderLine(01,"#                                     #              000                    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
renderLine(02,"#                     #    t    #     #              000                    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
renderLine(03,"#            |        #         #     #              000                    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
renderLine(04,"#           yyyy                      #      X       000                  !!#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
renderLine(05,"#          yy~~y          ###         #     ppp      000                !!!!#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
renderLine(06,"#        yyy~~~y        |             '    XpppX     000              !!!!!!#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
renderLine(07,"#    |   y~~~~~y                      #     ppp      000            !!!!!!!!#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
renderLine(08,"#        y~~~~~y                   a  #      X       000          !!!!!!!!!!#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
renderLine(09,"#        yy~~yyy             W        #              000        !!!!!!!!!!!!#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
renderLine(10,"#         yyyy                        #              000      !!!!!!!!!!!!!!#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
renderLine(11,"#                                     #              000    !!!!!!!!!!!!!!!!#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
renderLine(12,"#################################l########################!!!!!!!!!!!!!!!!!!####################~~~~~~~~~~~~~~~~~~~")
renderLine(13,"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ZkZhhY                   #!!!!!!!!!!!!!!!!!!#x                x#~~~~~~~~~~~~~~~~~~~")
renderLine(14,"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ZZZZjZhh                    #!!!!!!!!!!!!!!!!!!#       o  o       #~~~~~~~~~~~~~~~~~~~")
renderLine(15,"~~~~~~~~~~~~~~~Z_ZZZZZ~~~~~ZZZhhhhhhh               n    #!!!!!!!!!!!!!!!!!!#     o      o     #~~~~~~~~~~~~~~~~~~~")
renderLine(16,"~~~~~~~~~~~~~~~Zhhhhh_~~~ZZZhhhhhhhhh                    #!!!!!!!!!!!!!!!!!!#   o          o   #~~~~~~~~~~~~~~~~~~~")
renderLine(17,"~~~~~~~~~~~~~~~ZhZZZhZ~ZZZhhhhhhhhhhh           g        #!!!!!!!!!!!!!!!!!!# o              o #~~~~~~~~~~~~~~~~~~~")
renderLine(18,"~~~~~~~~~~~~~~~ZhZ~ZhZZZhhhhhhhhhhhhh          Urs       #!!!!!!!!!!!!!!!!!!#                  #~~~~~~~~~~~~~~~~~~~")
renderLine(19,"~~~~~~~~~~~~~~~Z-Z~Zh4<hhhhhhhhhhhhhh           g        #!!!!!!!!!!!!!!!!!!# o              o #~~~~~~~~~~~~~~~~~~~")
renderLine(20,"~~~~~~~~~~~~~~~Z2Z~ZSZZhhhhhhhhhhhhhh                    #!!!!!!!!!!!!!!!!!!    o          o   #~~~~~~~~~~~~~~~~~~~")
renderLine(21,"~~~~~ZZZZZZZZZZ_2Z~_w4hhhhhhhhhhhhhhh     O              #!!!!!!!!!!!!!!!!!!#     o      o     #~~~~~~~~~~~~~~~~~~~")
renderLine(22,"~~~~~Z34444444447ZZZZZvhhhhhhhhhhhhhh        V           #!!!!!!!!!!!!!!!!!!#       o  o       #~~~~~~~~~~~~~~~~~~~")
renderLine(23,"~~~~~Z2_ZZZZZZZZZZh444hhhhhhhhhhhhhhh                    #!!!!!!!!!!!!!!!!!!#x                x#~~~~~~~~~~~~~~~~~~~")
renderLine(24,"~~~~~Z2Z~~~~~~~~~Zh###>############################################################################################")
renderLine(25,"~~~~~Z2Z~~~~~~~~~Zh#                  #         X        #      ~~~~    G%~~               #!!!#                  #")
renderLine(26,"~~~~~Z2Z~~~~~~~~~Zh#                  #                  #      ~~~~     %~~               #!!!#                  #")
renderLine(27,"~~~~~Z2_ZZZZZZ~~~Z!#                  #                  # +    ~~~~  *g %~~               #!!!#mmmmmmmmm#        #")
renderLine(28,"~~~~~Z9666661Z~~~Z!#       A          #      X           #   +  ~~~~  +* %~~      ```      #!!!#mmmmmmmmm#        #")
renderLine(29,"~~~~~ZZZZZZ_2Z~~~Z@#             #    #      X           #      ~~~~     %~~     ``!``     #####      J  #        #")
renderLine(30,"~~~~~~~~~~~Z2Z~~~Zf#         z   #       C   X        D  b   +  ~~~~ F   %~~   H `!!!`     T   b I       #iiiiiiii#")
renderLine(31,"~~~ZZZ~~~~~Z2Z~~~ZZ#             #    #            X     #  +   ~~~~     %~~     ``!``     #####         #iiiiiiii#")
renderLine(32,"~~~ZeZ~~~~~Z2Z~~~~~#                  #            X     #      ~~~~  +* %~~      ```      #!!!#         #iiiiiiii#")
renderLine(33,"~~~Z8_ZZZZZ_2Z~~~~~#  B               #            X     # E    ~~~~  *g %~~               #!!!###########iiiiiiii#")
renderLine(34,"~~~Z944444447Z~~~~~#                  #                  #      ~~~~     %~~               #!!!#X     ===         #")
renderLine(35,"~~~ZZZZZZZZZZZ~~~~~#                  #       X          #      ~~~~     %~~               #!!!#X     ===         #")
renderLine(36,"~~~~~~~~~~~~~~~~~~~###~~~~~~######################################################################   ##############")
renderLine(37,"~~~~~~~~~~~~~~~~~~~#O#~~~~~~#         # :       cccd  d  #      ....  i;iiii#O#                #      66  44      #")
renderLine(38,"~~~~~~~~~~~~~~~~~~~# #~~~~~~#      &  #    R    cccdP d  #      ....  iiii;i# #                #   K  66  44      #")
renderLine(39,"~~~~~~~~~~~~~~~~~~~# #~~~~~~#         #!!!!!!   cccd  d  #  ?   ....  iiiiii#$#                #      66  44      #")
renderLine(40,"~~~~~~~~~~~~~~~~~~~#^#~~~~~~#         #!!!!!!      d  *  #      ....  i;iiii#         ##  #    ##############     #")
renderLine(41,"~~~~~~~~~~~~~~~~~~~#    ++                !!!!!!!! d     #      ....        #  #          #    #qqqqqqq  qqq#22222#")
renderLine(42,"~~~~~~~~~~~~~~~~~~~#   *+g*           #   !!!!!ccc*d          g .... M      5    #    *        qqqqqqqq  qqq#22222#")
renderLine(43,"~~~~~~~~~~~~~~~~~~~#    ++            #    *      ~d     #      ....     ,  #  #   #           #qqqqqqq  qqq#88888#")
renderLine(44,"~~~~~~~~~~~~~~~~~~~#                  #    u      ~d     #      ....   ,    #    ####     L    #qqqqqqq  qqq#22222#")
renderLine(45,"~~~~~~~~~~~~~~~~~~~#                  #    u      ~*     #   N  ....        #  #     #         #qqqqqqq  qqq#88888#")
renderLine(46,"~~~~~~~~~~~~~~~~~~~#                  #    u      ~~     #      ....     ,  #          #       #qqqqqqq  qqq#88888#")
renderLine(47,"~~~~~~~~~~~~~~~~~~~#                  #    u      ~~     #      ....        #    #   #         #qqqqqqq  qqq      #")
renderLine(48,"~~~~~~~~~~~~~~~~~~~#############################################################################QQQQQQQ##QQQ#######")

oxyd_shuffle()

document(50,9,"Many objects change when hit with a laser beam.  Try hitting some of the coins with the laser beam.  Also, try hitting a block over a coin.  Those stones to your right are knights -- you need to fight (hit) them with a sword (in the front of your inventory) to get past.")

document(67,3,"Do you have any umbrellas?  Each one will give you approximately ten seconds of protection from danger (such as falling).")

document(79,22,"Those black stones are fart stones -- they reset all progress made with the oxyd stones.  The other stones are the oxyd stones.  Match them up to win!")

document(35,31,"This area at the bottom of the screen is your inventory -- when you pick things up, they go here (there is a maximum of twelve).  To scroll through the inventory, use the right mouse button or the 'tab' key.  To drop or use an object, click the left mouse button.  Some objects, such as documents (like this one), can't be dropped but are instead used.  Those two balls in your inventory are your extra lives -- if you die in this level, you will restart at the beginning of the level if you have any balls left (and you will lose one of the balls).")

document(25,21,"Naturally, you're supposed to go through those closed gates at the top of the screen.                         Try going down that slope near the bottom of the room to see what's to the left.                                                         Don't bother with that trigger below the abyss yet.                                 If you could hit that small white ball through the one-way blocks (with the arrows), it might roll down and stop on that trigger.                  You will need to go in with it but you can't go through the white one-way block.                            Take the spoon and use it once the white ball is through (hit it hard).")

document(33,45,"The stone in the top-right of the room is a switch.  Hit it -- it is probably useful.  In this case the switch opens and closes a door (Do you remember a door that you weren't able to open?).  The bluish line is a window -- bridge the water before you do anything with it.")

set_stone( "st-rock1", 25, 40)

set_item("it-trigger",81,45,{action="openclose",target="d2"})

set_item("it-trigger",88,39,{action="openclose",target="d1"})

set_stone("st-switch",35,9,{action="onoff",target="l1"})

fill_floor("fl-red",106,25,8,3)

set_item("it-hollow",115,0,{essential=1})
ff1=0
function funcc1()
if ff1==0 and ff2==1 then
   document(22,24,"That was a rotor (similar to a top).  Some levels have many rotors and tops to make them difficult.                            However, maybe this rotor has a purpose; maybe you could get it on that trigger near where the spoon was.                      It might be convenient to close the gate.")
ff1=1
end
end

ff2=0
function funcc2()
if ff2==0 then
ff2=1
elseif ff2==1 then
ff2=0
end
end
