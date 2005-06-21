-- When Gravity Fails
-- A level for Enigma
-- (c) 2003 Nat Pryce
-- Licensed under GPL v2.0 or above
-- 2003-06-24: [ant]: changes in AddConstantForce

dofile(enigma.FindDataFile("levels/natmaze.lua"))

-----------------------------------------------------------------------------
LEVEL_WIDTH = 39
LEVEL_HEIGHT = 25
MAZE_WIDTH = 14
MAZE_HEIGHT = 12
MAZE_X = 6
MAZE_Y = 1
MAZE_CELL_WIDTH = 2
MAZE_CELL_HEIGHT = 2

function cellx_to_level( cellx )
    return MAZE_X + cellx*MAZE_CELL_WIDTH
end

function celly_to_level( celly )
    return MAZE_Y + celly*MAZE_CELL_HEIGHT
end

function cell_to_level( cellx, celly )
    return cellx_to_level(cellx), celly_to_level(celly)
end

function maze_floor( x, y, w, h )
    w = w or 1
    h = h or 1
    fill_floor( "fl-samba", x, y, w, h )
end

function maze_wall( x, y )
    set_stone( "st-rock2", x, y );
end

function render_cell( maze, cellx, celly )
    local x,y = cell_to_level(cellx, celly)
    
    maze_floor( x, y, 2, 2 )
    if not maze:can_go_east(cellx,celly) then
        maze_wall(x+1,y);
    end
    if not maze:can_go_south(cellx,celly) then
        maze_wall(x,y+1);
    end
    maze_wall(x+1,y+1);
end

function draw_maze( maze )
    render_maze( maze, render_cell )
    draw_stones( "st-rock2", {MAZE_X-1, MAZE_Y-1}, {1,0}, 
                 MAZE_WIDTH*MAZE_CELL_WIDTH + 1 )
    draw_stones( "st-rock2", {MAZE_X-1, MAZE_Y}, {0,1}, 
                 MAZE_HEIGHT*MAZE_CELL_HEIGHT )
end

function set_stone_in_cell( st_type, cellx, celly, offsetx, offsety, attribs )
    x, y = cell_to_level(cellx,celly)
    x = x + offsetx
    y = y + offsety
    
    set_stone( st_type, x, y, attribs or {} )
end

function create_oxyd_platforms()
    for celly = 2, MAZE_HEIGHT-1, 3 do
        west_oxyd_platform( celly )
        east_oxyd_platform( celly )
    end
    oxyd_shuffle()
end

function west_oxyd_platform( cell_y )
    x = 1
    y = celly_to_level( cell_y-1 ) - 1
    
    oxyd_platform(x,y)
    maze_floor( x+3, y+1 )
    maze_gateway( x+4, y+1 )
end

function east_oxyd_platform( cell_y )
    x = level_width - 4
    y = celly_to_level( cell_y-1 ) - 1
    
    oxyd_platform(x,y)
    maze_floor( x-1, y+1 )
    maze_gateway( x-2, y+1 )
end

function oxyd_platform( x, y )
    maze_floor( x, y, 3, 3 )
    oxyd( x+1, y+1 )
end

function maze_gateway( x, y )
    set_stone( "st-grate1", x, y )
    maze_floor( x, y )
end

-----------------------------------------------------------------------------

TIMER_INTERVAL = 0.1
LOOP_DURATION = 60.0
TICK_ANGLE_DELTA = 360.0 * TIMER_INTERVAL/LOOP_DURATION
GRAVITY = 20.0

angle = 90.0
gravity_x = 0
gravity_y = 0

function spin_gravity()
    angle = mod( angle + TICK_ANGLE_DELTA, 360.0 )
    set_gravity()
end

function set_gravity()
    gravity_x = cos(angle) * GRAVITY
    gravity_y = sin(angle) * GRAVITY
    enigma.AddConstantForce( gravity_x, gravity_y )
end

-----------------------------------------------------------------------------

create_world(39,25)

fill_floor("fl-abyss")
draw_maze( new_kruskal_maze(MAZE_WIDTH, MAZE_HEIGHT) )
create_oxyd_platforms()

mid_x, mid_y = cell_to_level( MAZE_WIDTH/2 - 1, MAZE_HEIGHT / 2 - 1 )
set_stone( "st-timer", mid_x+1, mid_y+1,
           {target="spin_gravity", action="callback",
            name="timer", interval=0.1} )

set_actor("ac-blackball", MAZE_X+0.5, MAZE_Y+0.5)

set_gravity()

