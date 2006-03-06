-- Prison Yard
-- A level for Enigma
--
-- Copyright (c) 2003 Nat Pryce
-- Licensed under the GPL version 2.

enigma.ConserveLevel = FALSE
WALL = "st-rock5"

create_world( 20, 25 )
draw_checkerboard_floor( "fl-rough-blue", "fl-rough-red", 
                         0, 0, level_width, level_height )
draw_border( WALL )
draw_border( WALL, 2, 2, level_width-4, level_height-4 )

set_stone( "st-rotator-left", 3, 2 )
set_stone( "st-rotator-left", level_width-3, 3 )
set_stone( "st-rotator-left", level_width-4, level_height-3 )
set_stone( "st-rotator-left", 2, level_height-4 )

oxyd( 1, 1 )
set_stone( WALL, 1, 2 )
set_stone( "st-scissors", level_width-5, 0 )
set_stone( "st-oneway_white-n", level_width-5, 2 )
draw_floor( "fl-gradient", {3,1}, {1,0}, level_width-6, 
            {type=FLAT_FORCE_W} )

oxyd( 1, level_height-2 )
set_stone( WALL, 2, level_height-2 )
set_stone( "st-scissors", 0, 4 )
set_stone( "st-oneway_white-w", 2, 4)
draw_floor( "fl-gradient", {1,3}, {0,1}, level_height-6, 
            {type=FLAT_FORCE_S} )

oxyd( level_width-2, level_height-2 )
set_stone( WALL, level_width-2, level_height-3 )
set_stone( "st-scissors", 4, level_height-1 )
set_stone( "st-oneway_white-s", 4, level_height-3 )
draw_floor( "fl-gradient", {3,level_height-2}, {1,0}, level_width-6,
            {type=FLAT_FORCE_E} )

oxyd( level_width-2, 1 )
set_stone( WALL, level_width-3, 1 )
set_stone( "st-scissors", level_width-1, level_height-5 )
set_stone( "st-oneway_white", level_width-3, level_height-5,
           {orientation=EAST} )
draw_floor( "fl-gradient", {level_width-2,3}, {0,1}, level_height-5,
            {type=FLAT_FORCE_N} )


bolder1 = set_stone( "st-bolder-e", 3, 3)
ball1 = set_actor( "ac-whiteball", 3.5, 5.5, 
                   {player=1,controllers=0} )
if options.Difficulty == 1 then -- easy
    AddRubberBand( ball1, bolder1, 10, 1 )
else
    killer1 = set_actor( "ac-killerball", 3.5, 5, {controllers=0} )
    AddRubberBand( killer1, bolder1, 20, 0.5 )
    AddRubberBand( ball1, killer1, 10, 0.5 )
end

bolder2 = set_stone( "st-bolder-s", level_width-4, 3)
ball2 = set_actor( "ac-whiteball", level_width-5.5, 3.5, 
                   {player=1,controllers=0} )
if options.Difficulty == 1 then -- easy
    AddRubberBand( ball2, bolder2, 10, 1 )
else
    killer2 = set_actor( "ac-killerball", level_width-5, 3.5, {controllers=0} )
    AddRubberBand( killer2, bolder2, 20, 0.5 )
    AddRubberBand( ball2, killer2, 10, 0.5 )
end

bolder3 = set_stone( "st-bolder-w", level_width-4, level_height-4)
ball3 = set_actor( "ac-whiteball", level_width-3.5, level_height-5.5, 
                   {player=1,controllers=0} )
if options.Difficulty == 1 then -- easy
    AddRubberBand( ball3, bolder3, 10, 1 )
else
    killer3 = set_actor( "ac-killerball", level_width-3.5, level_height-5, {controllers=0} )
    AddRubberBand( killer3, bolder3, 20, 0.5 )
    AddRubberBand( ball3, killer3, 10, 0.5 )
end

bolder4 = set_stone( "st-bolder-n", 3, level_height-4)
ball4 = set_actor( "ac-whiteball", 5.5, level_height-3.5, 
                   {player=1,controllers=0} )
if options.Difficulty == 1 then -- easy
    AddRubberBand( ball4, bolder4, 10, 1 )
else
    killer4 = set_actor( "ac-killerball", 5, level_height-3.5, {controllers=0} )
    AddRubberBand( killer4, bolder4, 20, 0.5 )
    AddRubberBand( ball4, killer4, 10, 0.5 )
end

set_actor( "ac-blackball", level_width/2, 8, 
           {player=0,controllers=1} )

















