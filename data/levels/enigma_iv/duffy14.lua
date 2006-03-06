-- Copyright (c) 2003 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Slinky-Racing

levelw=200
levelh=60
enigma.ConserveLevel = FALSE		-- dh

create_world( levelw, levelh)
--enigma.SetCompatibility("")

fill_floor("fl-bluegreen", 0,0,levelw,levelh)

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
        local c = strsub( pattern, i, i)
        if c =="#" then
            set_stone( "st-greenbrown", i-1, line)
        elseif c == "o" then
            oxyd( i-1, line)
        elseif c == "~" then
            set_floor ("fl-water", i-1,line)
        elseif c == "!" then
            if difficult then
                set_floor ("fl-water", i-1,line)
            else
                set_floor ("fl-bluegreen", i-1, line)
            end
        elseif c == "a" then
            set_item("it-trigger", i-1,line, {action="openclose",target="door1"})
        elseif c == "A" then
            set_stone("st-door", i-1, line , {name="door1", type="v"})
        elseif c == "s" then
            set_stone("st-stoneimpulse", i-1,line)
        elseif c == "D" then --1-d
            set_floor("fl-gradient",  i-1,  line, {type=1})
        elseif c == "U" then --2-u
            set_floor("fl-gradient",  i-1,  line, {type=2})
        elseif c == "R" then --3-r
            set_floor("fl-gradient",  i-1,  line, {type=3})
        elseif c == "L" then --4-l
            set_floor("fl-gradient",  i-1,  line, {type=4})
        elseif c == "1" then --ur
            set_floor("fl-gradient",  i-1,  line, {type=11})
        elseif c == "3" then --dl
            set_floor("fl-gradient",  i-1,  line, {type=9})
        elseif c == "7" then --dr
            set_floor("fl-gradient",  i-1,  line, {type=12})
        elseif c == "9" then --ul
            set_floor("fl-gradient",  i-1,  line, {type=10})
        elseif c=="z" then
            set_actor("ac-blackball", i,line+1)
        elseif c=="b" then
            set_item( "it-blackbomb", i-1,line)
        elseif c=="+" then
            set_stone( "st-wood", i-1, line)
        elseif c=="g" then
            draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
        elseif c == "y" then
--             if difficult then
--                 dynamite(i-1,line)
--             else
--                 set_item ("")
--             end
        end
    end	
end

-- Floor:  " "
-- Border: "#"
-- Oxyd:   "o"

renderLine(00,"#######################################")
renderLine(01,"#      ~ +  !    !        +           #")--RenderLine(01,"#    bb!b+  !    !        +           #")
renderLine(02,"# +ssssssss ! ssss       ssss  3D1    #")
renderLine(03,"#g#     +bsbb sbbsssssssssbbs 3DDD1   #")--RenderLine(03,"#g#  b  +bs   sbbsssssssssbbs 3DDD1   #")
renderLine(04,"# y   sssgsssssbbbbbbbbbbbbbs3DDDD11  #")
renderLine(05,"#~~ssss sbbbbbbbsssssssssbbbssssssLL1 #")
renderLine(06,"#  s    ssssbbmbs       sbmbbbbbosLLL1#")
renderLine(07,"#  +g      sbbbbs       sbbbbbbbbsLLLL#")
renderLine(08,"# # #     ssbbsss   !   sbbbbbbbosLLL7#")
renderLine(09,"# ###     sbbbs     !   ssssssssssLL7 #")
renderLine(10,"# z #     sssss     !   !      9UU77  #")
renderLine(11,"#   #              ~~        !! 9U7   #")
renderLine(12,"#######################################")

oxyd_shuffle()
set_item( "it-blackbomb", 10,3)
set_item( "it-blackbomb", 12,4)
set_item( "it-magnet",14 ,6 , {name="magnet1"})
set_item( "it-magnet",26 ,6 , {name="magnet2"})
set_item( "it-trigger", 1, 9, {action="on", target="magnet1"})
set_item( "it-trigger", 1, 8, {action="on", target="magnet2"})














