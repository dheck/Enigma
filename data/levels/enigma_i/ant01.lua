-- Puzzle Hacker
-- (c) 2002 Petr Machata/ant_39
-- Licensed under GPL v2.0 or above

levelw = 20
levelh = 25

create_world(levelw, levelh)

fill_floor("fl-gray")

for i = 0, 100 do
        x0 = random(level_width)
        y0 = random(level_height)
        set_floor ("fl-normal",  x0, y0)
end

draw_border("st-marble")
draw_stones("st-marble", { 0,12},{ 1, 0},20)
draw_stones("st-grate2", { 1, 1},{ 1, 0},18)
draw_stones("st-grate2", { 1, 1},{ 0, 1},11)
draw_stones("st-grate2", { 1,11},{ 1, 0}, 9)
draw_stones("st-grate2", { 9, 6},{ 0, 1}, 5)


--abyss across the lower room
x0 = 10
y0 = 12

for i = y0, level_height do
        abyss(x0, i)
end

--balcony
set_stone  ("st-grate1", x0+0, y0+0)
fill_floor ("fl-abyss",  x0-2, y0+0, 5, 4)
fill_floor ("fl-gray",   x0-1, y0+0, 3, 3)
set_floor  ("fl-bridge", x0-1, y0+3, {name="bridge01"})

--grass in the upper room
fill_floor("fl-leaves",  13, 6, 3, 5)

--vertical walls in the upper room
draw_stones("st-marble", { 9, 6},{ 0, 1},6)
draw_stones("st-marble", {11, 6},{ 0, 1},6)
set_stone  ("st-grate1",   9,  7)
set_stone  ("st-grate1",  11,  7)

--grass in the lower room
fill_floor("fl-leaves",  2, 14, 5, 9)
fill_floor("fl-leaves",  7, 17, 2, 6)
fill_floor("fl-leaves", 12, 17, 4, 6)
fill_floor("fl-leaves", 14, 14, 2, 3)
fill_floor("fl-leaves", 16, 19, 2, 4)

set_stone("st-switch", 13, 21, {action="openclose", target="bridge01"})

--door
draw_stones("st-marble", { 17, 6},{ 0, 1},12)
set_stone("st-door",    18,  6, {name="door01", type="h"})
set_stone("st-door",    18,  7, {name="door02", type="h"})
set_stone("st-door",    18,  8, {name="door03", type="h"})
set_stone("st-door",    18,  9, {name="door04", type="h"})
set_stone("st-door",    18, 10, {name="door05", type="h"})
set_stone("st-door",    18, 11, {name="door06", type="h"})
set_stone("st-door",    18, 12, {name="door07", type="h"})
set_stone("st-door",    18, 13, {name="door08", type="h"})
set_stone("st-door",    18, 14, {name="door09", type="h"})
set_stone("st-door",    18, 15, {name="door10", type="h"})
set_stone("st-door",    18, 16, {name="door11", type="h"})
set_stone("st-door",    18, 17, {name="door12", type="h"})

--triggers
x0 = 2
y0 = 6

set_item ("it-trigger", x0+0, y0+0, {action="openclose", target="door01"})
set_item ("it-trigger", x0+0, y0+2, {action="openclose", target="door02"})
set_item ("it-trigger", x0+0, y0+4, {action="openclose", target="door03"})
set_item ("it-trigger", x0+2, y0+0, {action="openclose", target="door04"})
set_item ("it-trigger", x0+2, y0+2, {action="openclose", target="door05"})
set_item ("it-trigger", x0+2, y0+4, {action="openclose", target="door06"})
set_item ("it-trigger", x0+4, y0+0, {action="openclose", target="door07"})
set_item ("it-trigger", x0+4, y0+2, {action="openclose", target="door08"})
set_item ("it-trigger", x0+4, y0+4, {action="openclose", target="door09"})
set_item ("it-trigger", x0+6, y0+0, {action="openclose", target="door10"})
set_item ("it-trigger", x0+6, y0+2, {action="openclose", target="door11"})
set_item ("it-trigger", x0+6, y0+4, {action="openclose", target="door12"})

--PUZZLES

--two
x0 = 14
y0 = 2
puzzle( x0+0, y0+0, PUZ_0100)
puzzle( x0+1, y0+0, PUZ_0001)

--four
x0 = 2
y0 = 4
puzzle( x0+0, y0+0, PUZ_0100)
puzzle( x0+1, y0+0, PUZ_0101)
puzzle( x0+2, y0+0, PUZ_1001)
puzzle( x0+2, y0-1, PUZ_0010)

--five
x0 = 15
y0 = 3
puzzle( x0+0, y0+0, PUZ_0100)
puzzle( x0+1, y0+0, PUZ_0101)
puzzle( x0+2, y0+0, PUZ_1001)
puzzle( x0+2, y0-1, PUZ_0110)
puzzle( x0+3, y0-1, PUZ_0001)

--seven
x0 = 10
y0 = 3
puzzle( x0+0, y0+0, PUZ_0100)
puzzle( x0+1, y0+0, PUZ_1001)
puzzle( x0+1, y0-1, PUZ_0110)
puzzle( x0+2, y0-1, PUZ_0101)
puzzle( x0+3, y0-1, PUZ_0011)
puzzle( x0+3, y0+0, PUZ_1100)
puzzle( x0+4, y0+0, PUZ_0001)

--eight
x0 = 6
y0 = 4
puzzle( x0+0, y0+0, PUZ_0100)
puzzle( x0+1, y0+0, PUZ_0101)
puzzle( x0+2, y0+0, PUZ_0101)
puzzle( x0+3, y0+0, PUZ_0101)
puzzle( x0+4, y0+0, PUZ_0101)
puzzle( x0+5, y0+0, PUZ_0101)
puzzle( x0+6, y0+0, PUZ_1001)
puzzle( x0+6, y0-1, PUZ_0010)

--nine
x0 = 3
y0 = 3
puzzle( x0+0, y0+0, PUZ_1000)
puzzle( x0+0, y0-1, PUZ_0110)
puzzle( x0+1, y0-1, PUZ_0101)
puzzle( x0+2, y0-1, PUZ_0101)
puzzle( x0+3, y0-1, PUZ_0101)
puzzle( x0+4, y0-1, PUZ_0011)
puzzle( x0+4, y0+0, PUZ_1100)
puzzle( x0+5, y0+0, PUZ_0101)
puzzle( x0+6, y0+0, PUZ_0001)


-- OXYD stones
oxyd ( 2,14)
oxyd ( 6,14)
oxyd ( 2,22)
oxyd ( 8,22)
oxyd_shuffle()

-- and actor...
set_actor("ac-blackball", 2.5, 2.5)















