-- The Exchange
-- Created by Ray Wick
--


LAND_FLOOR = "fl-marble"
MARBLE_FLOOR = "fl-marble"
WATER_FLOOR = "fl-water"
MARBLE = "st-marble"
GLASS = "st-glass"

function color_block( color, x, y)
       stone = format( "st-%s4", color)
       set_stone( stone, x, y)
end
level = {
    "                                                          ",
    "                                              GGGGGGGGGV  ",
    "                                              GMGGMMGGMV  ",
    "                                              GGMMGGMMGV  ",
    " GGggggggggggggggggggggggggggggggggggggggggggggggggggggg  ",
    " GMg   GGGG                                   GGGGGGMGbg  ",
    " GMg   GMGG                                   GGGGGMGGGg  ",
    " GMg   GGMG                                   GGGGMGGGGg  ",
    " GMg   GGGG                                   GGGMGGGGGg  ",
    " GG>                                          GGGGGGGGGg  ",
    "   g                                                   W  ",
    "   g                ggggggggggggggggggg^gggggggggggggggg  ",
    "   g+++++++++++++++++++++++++A++++++++g^++++++gggggggggg  ",
    "   gGGGGGGGGGGGGGGc+G                SgGGGGGG;g@@@@@@@@g  ",
    "   gGGGGGGGGGGGGGGG+ %                gGGGGGGGgggggggggg  ",
    "   gGGGGGGGGGGGGGGG+                  g                g  ",
    "   gGGGGGGGGGGGGGGG+                  g                g  ",
    "   gGGGGGGGGGGGGGGG+                GGg              GGg  ",
    "C  ~2GGGMGGGGGGGGG3+         L *    GYV              GY1 D",
    "   gGGGGGMGGGGGGGGG+                GGg              GGg  ",
    "   gGGGGGGGGGGGGGGG+                  g                g  ",
    "   gGGGGGGGGGGGGGGG+                  g                g  ",
    "   gGGGGGGGGGGGGGGG+ %                gGGGGGGGgggggggggg  ",
    "   gGGGGGGGGGGGGGGG+G                agGGGGGGdg@@@@@@@@g  ",
    "   g+++++++++++++++++++++++++B++++++++gv++++++gggggggggg  ",
    "   g                gggggggggggggggggggvgggggggggggggggg  ",
    "   g                                                   W  ",
    " GG>                                          GGGGGGGGGg  ",
    " GMg   GGGG                                   GGGMGGGGGg  ",
    " GMg   GGMG                 .                 GGGGMGGGGg  ",
    " GMg   GMGG                                   GGGGGMGGGg  ",
    " GMg   GGGG                                   GGGGGGMGGg  ",
    " GGggggggggggggggggggggggggggggggggggggggggggggggggggggg  ",
    "                                              GsMMGGMMGV  ",
    "                                              GMGGMMGGMV  ",
    "                                              GGGGGGGGGV  ",
    "                                                          "
}

cells = {}
cells["*"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_actor( "ac-blackball", x+0.5, y+0.5 )
--    set_item( "it-yinyang", x, y+0.5 )
end
cells[";"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
--    set_actor( "ac-blackball", x+0.5, y+0.5 )
    set_stone( "st-grate1", x, y )
    set_item( "it-yinyang", x, y )
end
cells["."] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_actor( "ac-whiteball", x+0.5, y+0.5 )
    set_item( "it-yinyang", x, y )
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
cells["<"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_stone( "st-oneway-w", x, y)
end
cells[">"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_stone( "st-oneway-e", x, y)
end
cells["^"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_stone( "st-oneway-n", x, y)
end
cells["v"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_stone( "st-oneway-s", x, y)
end
cells["%"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_stone( "st-swap", x, y )
end
cells["1"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    doorv(x, y, {name="door1"} )
end
cells["2"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    doorv(x, y, {name="door2"} )
end
cells["3"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    doorv(x, y, {name="door3"} )
end
cells["A"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_stone( "st-key_a", x, y, {action="openclose", target="door1"})
end
cells["B"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_stone( "st-key_b", x, y, {action="openclose", target="door2"})
end
cells["C"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_stone( "st-key_c", x, y, {action="openclose", target="door3"})
end
cells["D"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_stone( "st-floppy", x, y, {target="laser1", action="onoff" })
end
cells["G"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_stone( "st-grate1", x, y )
end
cells["L"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_attrib(laser(x, y, FALSE, WEST), "name", "laser1")
end
cells["M"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_stone( "st-pmirror", x, y, {movable=0, transparent=0, orientation=1 })
end
cells["S"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_stone( "st-grate1", x, y )
    set_item( "it-seed", x, y )
end
cells["V"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    color_block( "black", x, y)
end
cells["W"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    color_block( "white", x, y)
end
cells["Y"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_stone( "st-yinyang1", x, y )
end
cells["a"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_stone( "st-grate1", x, y )
    set_item( "it-key_a", x, y )
end
cells["b"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_stone( "st-grate1", x, y )
    set_item( "it-key_b", x, y )
end
cells["c"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_stone( "st-grate1", x, y )
    set_item( "it-key_c", x, y )
end
cells["d"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_stone( "st-grate1", x, y )
    set_item( "it-floppy", x, y )
end
cells["g"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_stone( GLASS, x, y )
end
cells["s"] = function( x, y )
    set_floor( LAND_FLOOR, x, y )
    set_stone( "st-grate1", x, y )
    set_item( "it-spring1", x, y )
end
cells[" "] = function( x, y )
--     set_floor( LAND_FLOOR, x,y )
end

create_world( 58, 37 )
fill_floor(MARBLE_FLOOR, 0, 0, 58, 37 )
draw_border( MARBLE )
for y,line in pairs(level) do
    for x = 1,strlen(line) do
        cell = strchar(strbyte(line,x))
        cells[cell]( x-1, y-1 )
    end
end
oxyd_shuffle()
















