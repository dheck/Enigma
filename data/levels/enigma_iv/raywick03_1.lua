-- Block The Way

-- Created by Ray Wick

--




LAND_FLOOR = "fl-wood"

SOFT_FLOOR = "fl-hay"

SAND_FLOOR = "fl-sand"

WATER_FLOOR = "fl-water"

WALL = "st-rock4"


function color_block( color, x, y)

       stone = format( "st-%s4", color)

       set_stone( stone, x, y)

end

level = {

    "!!!!!!!!!!!!!!!!!!!!!!###`",

    "!++++++++++++++++++++!@B#`",

    "!+x x x x x kx x x x+! +#`",

    "!+ ~~~~~~~~~~~~~~~~ +! 3#`",

    "!+x~~~~~~~~~~~~~~~~x+! +#`",

    "!+ ~~~~~~~~~~~~~~~~ +4 D#`",

    "!K-~~~~~~~~m~~~~~~~ +t  V>",

    "!L*~~~~~~~~Y~~~~~~~ +A @#`",

    "!@-~~~~~~~~M~~~~~~~ +2  V<",

    "!+ ~~~~~~~~~~~~~~~~ +! E#`",

    "!+x~~~~~~~~~~~~~~~~x+! +#`",

    "!+ ~~~~~~~~~~~~~~~~ +! 1#`",

    "!+x x x x x  x x x xs! +#`",

    "!+s++++++++++++++++++!@C#`",

    "!!!!!!!!!!!!!!!!!!!!!!###`"

}


cells = {}

cells["!"] = function( x, y )

--    set_floor( LAND_FLOOR, x, y )

    set_stone( "st-stoneimpulse", x, y )

end

cells["1"] = function( x, y )

    set_stone( "st-stoneimpulse", x, y, {name="imp1"} )

end

cells["2"] = function( x, y )

    set_stone( "st-stoneimpulse", x, y, {name="imp2"} )

end

cells["3"] = function( x, y )

    set_stone( "st-stoneimpulse", x, y, {name="imp3"} )

end

cells["4"] = function( x, y )

    set_stone( "st-stoneimpulse", x, y, {name="imp4"} )

end

cells["#"] = function( x, y )

    set_stone( WALL, x, y )

end

cells["*"] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

    set_actor( "ac-blackball", x+0.5, y+0.5 )

--    set_item( "it-yinyang", x, y+0.5 )

end

cells["."] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

    set_actor( "ac-whiteball", x+0.5, y+0.5 )

    set_item( "it-yinyang", x, y+0.5 )

end

cells["@"] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

    oxyd(x,y)

end

cells["+"] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

    set_stone( "st-wood", x, y )

end

cells["~"] = function( x, y )

    set_floor( WATER_FLOOR, x, y )

end

cells["`"] = function( x, y )

    set_floor( SOFT_FLOOR, x, y )

end

cells["<"] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

    set_stone( "st-oneway-w", x, y)

end

cells[">"] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

    set_stone( "st-oneway-e", x, y)

end

cells["-"] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

    set_item( "it-dynamite", x, y )

end

cells["s"] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

    set_item( "it-blackbomb", x, y )

    set_stone( "st-wood", x, y )

end

cells["x"] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

    set_item( "it-blackbomb", x, y )

end

cells[" "] = function( x, y )

    set_floor( LAND_FLOOR, x,y )

end

cells["K"] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

    set_stone( "st-key_a", x, y, {target="laser1", action="onoff" })

end

cells["L"] = function( x, y )

    set_floor( SOFT_FLOOR, x, y )

    set_attrib(laser(x, y, FALSE, EAST), "name", "laser1")

end

cells["m"] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

    set_stone( "st-pmirror", x, y, {movable=1, transparent=0, orientation=4 })

end

cells["M"] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

    set_stone( "st-pmirror", x, y, {movable=1, transparent=0, orientation=2 })

end

cells["Y"] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

    set_stone( "st-3mirror", x, y, {movable=1, transparent=1, orientation=2 })

end

cells["t"] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

    set_item("it-trigger", x, y, {action="on", target="laser1"})

end

cells["A"] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

    set_item("it-trigger", x, y, {invisible=0, action="trigger", target="imp1"})

end

cells["B"] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

    set_item("it-trigger", x, y, {invisible=0, action="trigger", target="imp2"})

end

cells["C"] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

    set_item("it-trigger", x, y, {invisible=0, action="trigger", target="imp3"})

end

cells["D"] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

    set_item("it-trigger", x, y, {invisible=0, action="trigger", target="imp4"})

end

cells["E"] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

    set_item("it-trigger", x, y, {action="on", target="laser1"})

end

cells["V"] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

    color_block( "black", x, y)

end

cells["W"] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

    color_block( "white", x, y)

end

cells["X"] = function( x, y )

    set_stone( "st-bombs", x, y )

end

cells["k"] = function( x, y )

    set_floor( LAND_FLOOR, x, y )

--    set_stone( "st-wood", x, y )

    set_item( "it-key_a", x, y )

end



create_world( 58, 37 )

fill_floor(SAND_FLOOR, 0, 0, 58, 37 )

draw_border( "st-rock2" )

for y,line in pairs(level) do

    for x = 1,strlen(line) do

        cell = strchar(strbyte(line,x))

        cells[cell]( x+17, y+10 )

    end

end

oxyd(5,5)

oxyd(5,31)

oxyd(52,5)

oxyd(52,31)

oxyd_shuffle()

oxyd_shuffle()

















