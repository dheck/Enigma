-- Magritte
-- A level for Enigma
-- Copyright (c) 2002 Nat Pryce
-- License: GPL v2.0 or above

dofile( enigma.FindDataFile("levels/natmaze.lua") )


maze = new_kruskal_maze( 12, 12 )
startx, starty = random(maze.width-2), random(maze.height-2)
offsetx = 2
offsety = 2
cell_side = 5
cell_gap = 1
last_trigger = nil


function cell_to_level( cellx, celly )
    local x = offsetx + cellx * cell_side + (cellx-1) * cell_gap
    local y = offsety + celly * cell_side + (celly-1) * cell_gap
    return x, y
end

function at_corner( x, y )
    return x == 0 and y == 0
        or x == 0 and y == maze.height - 1
        or x == maze.width-1 and y == 0
        or x == maze.width-1 and y == maze.height-1
end

function at_start( x, y )
    return x == startx and y == starty
end

random_stones = {
    "st-grate1",
    "st-fakeoxyd",
    "st-brownie",
    "st-glass",
    "st-chameleon",
    "st-greenbrown",
    "st-greenbrown_hole",
    "st-greenbrown_move",
    "st-invisible"
}

random_floors = {
    "fl-rough",
    "fl-leaves",
    "fl-gray",
    "fl-dunes",
    "fl-sand",
}

function draw_cell( cellx, celly )
    local x,y = cell_to_level( cellx, celly )
    
    fill_floor( "fl-wood", x, y, cell_side, cell_side )
    fill_floor( random_element(random_floors),
                x+1, y+1, cell_side-2, cell_side-2 )
    
    if not at_corner(cellx,celly) and not at_start(cellx,celly) then
        if random() < 0.5 then
            set_stone( random_element(random_stones), x+2, y+2 )
        end
    end
end

function draw_cells()
    for celly = 0,maze.height-1 do
        for cellx = 0,maze.width-1 do
            draw_cell( cellx, celly )
        end
    end
end

function draw_link( cellx, celly, test_link, x, y )
    if test_link( maze, cellx, celly ) then
        set_floor( "fl-wood", x, y )
    else
        set_floor( "fl-water", x, y )
    end
end

function draw_links_for_cell( cellx, celly )
    local x,y = cell_to_level( cellx, celly )
    local offset = cell_side/2 + 1
    
    x = x + 2
    y = y + 2
    
    draw_link( cellx, celly, maze.can_go_north, x, y-3 )
    draw_link( cellx, celly, maze.can_go_south, x, y+3 )
    draw_link( cellx, celly, maze.can_go_west, x-3, y )
    draw_link( cellx, celly, maze.can_go_east, x+3, y )
end

function draw_links()
    for celly = 0,maze.height-1 do
        for cellx = 0,maze.width-1 do
            draw_links_for_cell( cellx, celly )
        end
    end
end



last_regenerate_id = nil

function regenerate_maze( trigger_pressed, id )
    if trigger_pressed == 1 and id ~= last_regenerate_id then
        maze = new_kruskal_maze( maze.width, maze.height )
        draw_links()
        last_regenerate_id = id
    end
end

function trigger_callback_1( trigger_pressed )
    regenerate_maze( trigger_pressed, 1 )
end
function trigger_callback_2( trigger_pressed )
    regenerate_maze( trigger_pressed, 2 )
end
function trigger_callback_3( trigger_pressed )
    regenerate_maze( trigger_pressed, 3 )
end
function trigger_callback_4( trigger_pressed )
    regenerate_maze( trigger_pressed, 4 )
end


function set_oxyd( cellx, celly, callback )
    local x,y = cell_to_level( cellx, celly )
    oxyd(x+2,y+2)
    
    set_regenerate_trigger( x, y+cell_side/2, callback )
    set_regenerate_trigger( x+cell_side/2, y, callback )
    set_regenerate_trigger( x+cell_side-1, y+cell_side/2, callback )
    set_regenerate_trigger( x+cell_side/2, y+cell_side-1, callback )
end

function set_regenerate_trigger( x, y, callback )
    set_item( "it-trigger", x, y, 
              {target=callback, action="callback"} )
end


create_world( maze.width*cell_side + (maze.width-1)*cell_gap + 2*offsetx + 2,
              maze.height*cell_side + (maze.height-1)*cell_gap + 2*offsety )

fill_floor( "fl-water")
draw_cells()
draw_links()

set_oxyd( 0, 0, "trigger_callback_1" )
set_oxyd( 0, maze.height-1, "trigger_callback_2" )
set_oxyd( maze.width-1, 0, "trigger_callback_3" )
set_oxyd( maze.width-1, maze.height-1, "trigger_callback_4" )


actorx, actory = cell_to_level( startx, starty )
set_actor( "ac-blackball", actorx + 2.5, actory + 2.5 )
display.SetFollowMode(display.FOLLOW_SCROLLING)


