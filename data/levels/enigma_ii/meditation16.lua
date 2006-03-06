-- Siegfried Fennig 09.01.2003 Rev. 0

levelw = 58
levelh = 37

create_world(levelw, levelh)
fill_floor("fl-abyss", 0, 0, levelw,levelh)
fill_floor("fl-normal",21,15,16, 7)

draw_floor("fl-gradient", {21,14}, {1,0},16, {type=1})
draw_floor("fl-gradient", {20,15}, {0,1}, 7, {type=3})
draw_floor("fl-gradient", {21,22}, {1,0},16, {type=2})
draw_floor("fl-gradient", {37,15}, {0,1}, 7, {type=4})
draw_floor("fl-gradient", {20,14}, {1,0}, 1, {type=5})
draw_floor("fl-gradient", {37,14}, {1,0}, 1, {type=6})
draw_floor("fl-gradient", {20,22}, {1,0}, 1, {type=7})
draw_floor("fl-gradient", {37,22}, {1,0}, 1, {type=8})

draw_stones("st-invisible", {18,11}, {1,0},22)
draw_stones("st-invisible", {18,25}, {1,0},22)
draw_stones("st-invisible", {18,12}, {0,1},13)
draw_stones("st-invisible", {39,12}, {0,1},13)

set_item("it-hollow", 24,19)
set_item("it-hollow", 27,17)
set_item("it-hollow", 30,19)
set_item("it-hollow", 33,17)

function basis( x, y)
       set_floor("fl-gradient",   x+1, y,      {type=2})
       set_floor("fl-gradient",   x, y+1,      {type=4})
       set_floor("fl-gradient",   x+2, y+1,    {type=3})
       set_floor("fl-gradient",   x, y,        {type=12})
       set_floor("fl-gradient",   x+2, y,      {type=10})
       set_floor("fl-gradient",   x, y+2,      {type=11})
       set_floor("fl-gradient",   x+2, y+2,    {type=9})
       set_floor("fl-gradient",   x+1, y+2,    {type=1})
end

basis (23,18)
basis (26,16)
basis (29,18)
basis (32,16)

set_actor("ac-whiteball-small", 24.5, 17.5, {player=0, mouseforce=1, essential=1})
set_actor("ac-whiteball-small", 27.5, 19.5, {player=0, mouseforce=1, essential=1})
set_actor("ac-whiteball-small", 30.5, 17.5, {player=0, mouseforce=1, essential=1})
set_actor("ac-whiteball-small", 33.5, 19.5, {player=0, mouseforce=1, essential=1})













