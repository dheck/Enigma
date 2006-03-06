-- Copyright (c) 2003 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Little Bit of Everything

levelw=100
levelh=60

create_world( levelw, levelh)
enigma.TwoPlayerGame = TRUE

fill_floor("fl-rough", 0,0,levelw,levelh)

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
        local c = strsub( pattern, i, i)
        if c =="#" then
            set_stone( "st-greenbrown", i-1, line)
        elseif c =="w" then
            set_stone( "st-glass", i-1, line)
        elseif c =="m" then
            set_stone( "st-brick", i-1, line)
        elseif c =="B" then
            set_stone( "st-brownie", i-1, line)
        elseif c =="R" then
            set_stone( "st-rock6", i-1, line)
        elseif c =="x" then
            set_stone( "st-rock5", i-1, line)
        elseif c =="n" then
            set_stone( "st-rock4", i-1, line)
        elseif c =="v" then
            set_stone( "st-rock3", i-1, line)
        elseif c ==";" then
            set_stone( "st-rock2", i-1, line)
        elseif c =="/" then
            set_stone( "st-rock1", i-1, line)
        elseif c =="H" then
            set_stone( "st-bluegray", i-1, line)
        elseif c=="t" then
            set_stone( "st-actorimpulse",i-1,line)
        elseif c == "o" then
            oxyd( i-1, line)
        elseif c == "!" then
            abyss(i-1,line)
            --			fill_floor("fl-water", i-1,line, 1,1)
        elseif c=="+" then
            set_stone( "st-wood", i-1, line)
        elseif c == "=" then
            fill_floor("fl-space", i-1,line, 1,1)
        elseif c=="z" then
            set_actor("ac-blackball", i-.5,line+.5)
--            set_item("it-yinyang",i-1,line)
        elseif c=="y" then
            set_actor("ac-whiteball", i-.5,line+.5)
--            set_item("it-yinyang",i-1,line)
        elseif c == "d" then --1-d
            set_floor("fl-gradient",  i-1,  line, {type=1})
        elseif c == "u" then --2-u
            set_floor("fl-gradient",  i-1,  line, {type=2})
        elseif c == "r" then --3-r
            set_floor("fl-gradient",  i-1,  line, {type=3})
        elseif c == "l" then --4-l
            set_floor("fl-gradient",  i-1,  line, {type=4})
        elseif c == "1" then --ur
            set_floor("fl-gradient",  i-1,  line, {type=11})
        elseif c == "3" then --dl
            set_floor("fl-gradient",  i-1,  line, {type=9})
        elseif c == "7" then --dr
            set_floor("fl-gradient",  i-1,  line, {type=12})
        elseif c == "9" then --ul
            set_floor("fl-gradient",  i-1,  line, {type=10})
        elseif c=="S" then
            set_stone("st-oneway-s", i-1, line)
        elseif c=="N" then
            set_stone("st-oneway-n", i-1, line)
        elseif c=="E" then
            set_stone("st-oneway-e", i-1, line)
	elseif c=="W" then
            set_stone("st-oneway-w", i-1, line)
        elseif c=="g" then
            draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
        elseif c == "X" then
            draw_stones("st-yinyang1", { i-1,line}, {0,1},1)
        elseif c=="a" then
            set_floor("fl-bridge", i-1,line, {name="bridge1", type="x"})
        elseif c=="b" then
            set_floor("fl-bridge", i-1,line, {name="bridge2", type="x"})
        elseif c=="c" then
            set_floor("fl-bridge", i-1,line, {name="bridge3", type="x"})
        elseif c=="D" then
            set_floor("fl-bridge", i-1,line, {name="bridge4", type="x"})
        elseif c=="e" then
            set_floor("fl-bridge", i-1,line, {name="bridge5", type="x"})
        elseif c=="f" then
            set_floor("fl-bridge", i-1,line, {name="bridge6", type="x"})
        elseif c=="G" then
            set_floor("fl-bridge", i-1,line, {name="bridge7", type="x"})
        elseif c=="h" then
            set_floor("fl-bridge", i-1,line, {name="bridge8", type="x"})
        elseif c=="i" then
            set_floor("fl-bridge", i-1,line, {name="bridge9", type="x"})
        elseif c=="j" then
            set_floor("fl-bridge", i-1,line, {name="bridge10", type="x"})
	elseif c=="`" then
            set_item("it-wormhole", i-1, line, {strength=1,targetx="59.5",targety="22.5", name="ww1"})
	elseif c=="@" then
            set_item("it-wormhole", i-1, line, {strength=1,targetx="40.5",targety="26.5", name="ww2"})
	elseif c=="~" then
            set_item("it-wormhole", i-1, line, {strength=1,targetx="2.5",targety="14.5", name="ww3"})
	elseif c=="$" then
            set_item("it-wormhole", i-1, line, {strength=1,targetx="10",targety="42.5", name="ww4"})
	elseif c=="%" then
            set_item("it-wormhole", i-1, line, {strength=1,targetx="74.5",targety="46.5", name="ww5"})
	elseif c=="^" then
            set_item("it-wormhole", i-1, line, {strength=1,targetx="71.5",targety="6.5", name="ww6"})
	elseif c=="&" then
            set_item("it-wormhole", i-1, line, {strength=1,targetx="49",targety="30.5", name="ww7"})
	elseif c=="8" then
            set_item("it-wormhole", i-1, line, {strength=1,targetx="48.5",targety="40.5", name="ww8"})
	elseif c=="p" then
            set_item("it-wormhole", i-1, line, {strength=7,targetx="71.5",targety="6.5"})
	elseif c=="0" then
            set_item("it-wormhole", i-1, line, {strength=8,targetx="59.5",targety="15.5"})
	elseif c=="q" then
            set_item("it-wormhole", i-1, line, {strength=1,targetx="37.5",targety="25.5"})
        elseif c=="V" then
            set_stone("st-switch", i-1,line, {action="callback",target="funcc"})
        elseif c=="F" then
            set_item("it-trigger", i-1,line, {action="callback", target="changewormholes"})
        end
    end	
end

-- Floor:  " "
-- Border: "#"
-- Oxyd:   "o"

renderLine(00,";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;")
renderLine(01,";ggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg;")
renderLine(02,";g;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;g;")
renderLine(03,";g;   ;;       ;   ;        ;                 ;            p         ;    ;g;")
renderLine(04,";g;            ;      ;;    ;                 ;           ;;;;;;     ;    ;g;")
renderLine(05,";g;    p ;         ;          p;              ;                ; ;;;;;    ;g;")
renderLine(06,";g;  ;;    ;;  ;   p     ;  ;  ;       p      ;                ;   p      ;g;")
renderLine(07,";g;      ;     ;     ;;  ;  ;  ;              ;                ; ;;;;;    ;g;")
renderLine(08,";g; q    ;  p  ;   ;     ;                                ;;;;;;     ;    ;g;")
renderLine(09,";g;o     ;         ;     ;                                 p         ;    ;g;")
renderLine(10,";g;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;g;")
renderLine(11,";ggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg;")
renderLine(12,"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxBBBBBBBBBBBBBBBBBBBwwwwwwwwwwwwwwwwwwww")
renderLine(13,"x   lllrrrrllrll   xog g g g g g g g gBo                 w                 0w")
renderLine(14,"x   lllrrrrllrll   xggggggggggggggggggBggggggggggggggggg w    w        0    w")
renderLine(15,"x   lllrrrrllrll   xg                gBg              qg w    w             w")
renderLine(16,"xxxxxxxxxxxxxxxxxxuxg gggggggggggggg gBg ggggggggggggg g wo   w    0        w")
renderLine(17,"x rrrlllrrrrll1x   xg g            g gBg g           g g wwwwww        0   0w")
renderLine(18,"xuxxxxxxxxxxxxlxdxxxg g gggggggggg g gBg g ggggg ggg g g w           0      w")
renderLine(19,"xdx lllrrllrll7xdx  g g            g gBg g g   g g g g g w***** w0        0 w")
renderLine(20,"xux xxxxxxxxxxxxdxdxg gggggggggggggg gBg g ggg g g ggg g w    * w  0    0   w")
renderLine(21,"xdx llllllllllll7xdxg                gBg gg  g g g     g w    * w     0   0 w")
renderLine(22,"xuxxxxxxxxxxxxxxxx xggggggggggggggggggBgg gggg g ggggggg w    * w 0   q     w")
renderLine(23,"x lrlrlrlrlrlrlrlr xg g g g g g g g g B g      g         w    * w   0    0  w")
renderLine(24,"########################SS#############RRRRRRddddddRRRRRRwwwwwwwwwwwwwwwwwwww")
renderLine(25,"#oX X X Xa   #                 #rrrrr #     R======R     m                  m")
renderLine(26,"#XX X X Xb z #                 #rrrr9u#     RddddddR     m mmmmmmmmmmmmmmmm m")
renderLine(27,"#   X X Xc   #                 #rrr9uu#     R======R     m mq             m m")
renderLine(28,"#XXXX X XD   #                 #rr9uuu#     RddddddR     m mmmmmmmmmmmmmo m m")
renderLine(29,"#     X Xe   #                 #r9uuuu#     R      R     m                m m")
renderLine(30,"##########   E  V              g9uuuuu#     R      R=====mmmmmmmmmmmmmmmmmm m")
renderLine(31,"#     X Xf   #                 #g######     R      R=====m                  m")
renderLine(32,"#XXXX X XG   #                        #     RRRRRRRR=====m mmmmmmmmmmmmmmmmmm")
renderLine(33,"#   X X Xh   #                        #     lllll ====H==m                  m")
renderLine(34,"#XX X X Xi y #                        #     lllll ====H==mmmmmmmmmmmmmmmmmm m")
renderLine(35,"#oX X X Xj   #                        #     lllll ====H==                   m")
renderLine(36,"####################                  #HHHHHHHHHHHHHHHHHHmmmmmmmmmmmmmmmmmmmm")
renderLine(37,"/qddddddddddddddddq#                  #   v       v      v        t   t     t")
renderLine(38,"/r3dddddddddddddd1l#                  # v vvvvvvv vv vvv vtt tt t t t   ttt t")
renderLine(39,"/rr7uuuuuuuuuuuu9ll#                  # v v  v     v   v v t  t t ttttt t t t")
renderLine(40,"/rrl3dddddddddd1rll#                  # v v vv v v v vvv v tttt t    t  t t t")
renderLine(41,"/rrlr7uuuuuuuu9lrll#                  # v      vvv v v   v    t tttt t tt   t") 
renderLine(42,"/rrlrl        rlrll#                  # vvvvvv     v v vvv tt t t t    t  ttt")
renderLine(43,"/rrlr1dddddddd3lrll#                  #      vvvvvvv v   v t  t t t tttt tt t")
renderLine(44,"/rrl9uuuuuuuuuu7rll#                  #vvvvv   v   v vvo v t tt t ttt     t t")
renderLine(45,"/rr1dddddddddddd3ll#                  #      v   v   v   v t  t     ttttt   t")
renderLine(46,"or9uuuuuuuuuuuuuu7l#                  #vvvvvvvvvvvvvvvSvvv tt tttt tt t     t")
renderLine(47,"/quuuuuuuuuuuuuuuuq#    q`@~$%^&8q    W                  W ot       t       t")
renderLine(48,"///////////////////####################vvvvvvvvvvvvvvvvvvvttttttttttttttttttt")

oxyd_shuffle()

set_floor("fl-gradient",  1,  37, {type=9})
set_floor("fl-gradient",  1,  47, {type=10})
set_floor("fl-gradient",  18,  37, {type=11})
set_floor("fl-gradient",  18,  47, {type=12})


through=0
function funcc()
    if through==1 then
	through=0
    end
    if through==0 then
	SendMessage("bridge1", "openclose")
	SendMessage("bridge2", "openclose")
	SendMessage("bridge3", "openclose")
	SendMessage("bridge4", "openclose")
	SendMessage("bridge5", "openclose")
	SendMessage("bridge6", "openclose")
	SendMessage("bridge7", "openclose")
	SendMessage("bridge8", "openclose")
	SendMessage("bridge9", "openclose")
	SendMessage("bridge10", "openclose")
    end
    through=through+1
end

--through2=0
--function changewormholes()
--if through2==1 then
--through2=0
--end
--if through2==0 then
--rrr= random(1,8)
--if rrr==1 then
--tx=59.5
--ty=22.5
--end
--if rrr==2 then
--tx=41.5
--ty=26.5
--end
--if rrr==3 then
--tx=2.5
--ty=14.5
--end
--if rrr==4 then
--tx=10
--ty=42.5
--end
--if rrr==5 then
--tx=76.5
--ty=46.5
--end
--if rrr==6 then
--tx=71.5
--ty=6.5
--end
--if rrr==7 then
--tx=49
--ty=30.5
--end
--if rrr==8 then
--tx=48.5
--ty=41.5
--end
--	   SetAttrib(ww1, "targetx", tx)
--	   SetAttrib(ww1, "targety", ty)
--	   SetAttrib(ww2, "targetx", tx)
--	   SetAttrib(ww2, "targety", ty)
--         set_item("it-wormhole", 26+w1, 47, {strength=1,targetx="59.5",targety="22.5"})
--	   set_item("it-wormhole", 26+w2, 47, {strength=1,targetx="41.5",targety="26.5"})
--	   set_item("it-wormhole", 26+w3, 47, {strength=1,targetx="2.5",targety="14.5"})
--	   set_item("it-wormhole", 26+w4, 47, {strength=1,targetx="10",targety="42.5"})
--	   set_item("it-wormhole", 26+w5, 47, {strength=1,targetx="76.5",targety="46.5"})
--	   set_item("it-wormhole", 26+w6, 47, {strength=1,targetx="71.5",targety="6.5"})
--	   set_item("it-wormhole", 26+w7, 47, {strength=1,targetx="49",targety="30.5"})
--	   set_item("it-wormhole", 26+w8, 47, {strength=1,targetx="48.5",targety="41.5"})
--end	  
--end
















