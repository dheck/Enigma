-- Maze module: maze generator and renderer for Enigma
-- 
-- Copyright (c) 2002 Nat Pryce
-- License: GPL v2.0 or above

function remove_random_element( table )
    return tremove( table, random( 1, getn(table) ) )
end

function random_element( table )
    return table[random( 1, getn(table) )]
end


-------------------------------------------------------------------------------
-- Maze objects


-- These constants conflict with those defined in init.lua; commented
-- them out for now (dh).

-- NORTH = 1
-- SOUTH = 2
-- WEST = 3
-- EAST = 4

function maze_coords_to_cell( maze, x, y )
    return y*maze.width + x
end

function maze_can_go_south( maze, x, y )
    return y < (maze.height-1) and maze.linky[maze_coords_to_cell(maze,x,y)]
end

function maze_can_go_north( maze, x, y )
    return y > 0 and maze_can_go_south(maze,x,y-1)
end

function maze_can_go_east( maze, x, y )
    return x < (maze.width-1) and maze.linkx[maze_coords_to_cell(maze,x,y)]
end

function maze_can_go_west( maze, x, y )
    return x > 0 and maze_can_go_east( maze, x-1, y )
end

function maze_link_south( maze, x, y )
    assert( maze_contains_cell( maze, x, y+1 ) )
    maze.linky[maze_coords_to_cell(maze,x,y)] = 1
end

function maze_link_north( maze, x, y )
    assert( maze_contains_cell( maze, x, y-1 ) )
    maze_link_south( maze, x, y-1 )
end

function maze_link_east( maze, x, y )
    assert( maze_contains_cell( maze, x+1, y ) )
    maze.linkx[maze_coords_to_cell(maze,x,y)] = 1
end

function maze_link_west( maze, x, y )
    assert( maze_contains_cell( maze, x-1, y ) )
    maze_link_east( maze, x-1, y )
end

function maze_contains_cell( maze, x, y )
    return x >= 0 and x < maze.width and y >= 0 and y < maze.height
end

function new_maze( width, height )
    local maze = {}
    
    maze.width = width
    maze.height = height
    maze.linkx = {}
    maze.linky = {}
    
    maze.contains_cell = maze_contains_cell
    maze.coords_to_cell = maze_coords_to_cell
    maze.can_go_north = maze_can_go_north
    maze.can_go_south = maze_can_go_south
    maze.can_go_west = maze_can_go_west
    maze.can_go_east = maze_can_go_east
    maze.link_north = maze_link_north
    maze.link_south = maze_link_south
    maze.link_west = maze_link_west
    maze.link_east = maze_link_east
    
    return maze
end


-------------------------------------------------------------------------------
-- Maze generator based on Kruskal's minimum spanning tree algorithm

function new_kruskal_maze( width, height )
    local maze = new_maze(width,height)
    local walls = maze_walls( maze )
    local zones = {}
    local zone_count = width*height
    
    randomseed( enigma.GetTicks() )
    
    while zone_count > 1 do
        wall = remove_random_element( walls )
        local x1 = wall.cellx
        local y1 = wall.celly
        local x2, y2
        
        if wall.side == SOUTH then
            x2 = wall.cellx
            y2 = wall.celly+1
        else -- wall.side == EAST
            x2 = wall.cellx+1
            y2 = wall.celly
        end
        
        cell1 = maze:coords_to_cell(x1,y1)
        cell2 = maze:coords_to_cell(x2,y2)
        zone1 = find_zone( zones, cell1 )
        zone2 = find_zone( zones, cell2 )
        
        if zone1 ~= zone2 then
            if wall.side == SOUTH then
                maze:link_south( x1, y1 )
            else -- wall.side == EAST
                maze:link_east( x1, y1 )
            end
            
            union_zones( zones, cell1, cell2 )
            zone_count = zone_count - 1
        end
    end
    
    return maze
end


function maze_walls( maze )
    walls = {}
    for y = 0, maze.height-1 do
        for x = 0, maze.width-1 do
            if y < maze.height-1 then
                tinsert( walls, {cellx=x,celly=y,side=SOUTH} )
            end
            if x < maze.width-1 then
                tinsert( walls, {cellx=x,celly=y,side=EAST} )
            end
        end
    end
    
    return walls
end



-- Union-find algorithm for merging "zones" of the maze.  Each zone is
-- a tree of cells identified by the cell at the root of the tree.  A root
-- cell is represented by a nil reference in the zones table indexed by the
-- cell number.

function find_zone( zones, cell )
    if zones[cell] == nil then
        return cell
    else
        zones[cell] = find_zone( zones, zones[cell] )
        return zones[cell]
    end
end

function union_zones( zones, cell1, cell2 )
    zones[find_zone(zones,cell2)] = find_zone(zones,cell1)
end



-------------------------------------------------------------------------------
-- Maze renderers


function render_maze( maze, cell_renderer )
    for cellx = 0, maze.width-1 do
        for celly = 0, maze.height-1 do
            cell_renderer( maze, cellx, celly )
        end
    end
end

function tight_maze( maze, maze_floor, wall_floor, wall_stone )
    local originx = 1
    local originy = 1
    
    function cell_to_level( cellx, celly )
        return %originx + cellx * 2, %originy + celly * 2
    end
    
    function draw_maze_border( maze, stone )
        width = maze.width*2
        height = maze.height*2
        
        draw_stones( stone, {0,0}, {1,0}, width )
        draw_stones( stone, {0,height-1},{1,0}, width )
        draw_stones( stone, {0,0}, {0,1}, height )
        draw_stones( stone, {width-1,0},{0,1}, height )
    end
    
    function render_cell( maze, cellx, celly )
        local x, y = cell_to_level( cellx, celly )
        
        if %wall_stone then 
            set_stone( %wall_stone, x+1, y+1 )
        end
        if %maze_floor then
            set_floor( %maze_floor, x, y )
        end
        if maze:can_go_south(cellx,celly) then
            if %maze_floor then
                set_floor( %maze_floor, x, y+1 )
            end
        else
            if %wall_stone then
                set_stone( %wall_stone, x, y+1 )
            end
        end
        if maze:can_go_east(cellx,celly) then
            if %maze_floor then
                set_floor( %maze_floor, x+1, y )
            end
        else
            if %wall_stone then
                set_stone( %wall_stone, x+1, y )
            end
        end
    end
    
    create_world( maze.width*2 + 1, maze.height*2 + 1 )
    if wall_stone then
        draw_border( wall_stone )
    end
    if wall_floor then
        fill_floor( wall_floor)
    else
        fill_floor( maze_floor)
    end
    render_maze( maze, render_cell )
    
    oxyd(1,0)
    oxyd(2*maze.width-1,2*maze.height)
    oxyd(1,2*maze.height)
    oxyd(2*maze.width-1,0)

    local actorx, actory = cell_to_level( random(maze.width)-1, 
                                          random(maze.height)-1 )
    set_actor( "ac-blackball", actorx + 0.5, actory + 0.5,
               { player=0 } )
end

