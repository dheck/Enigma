-- 2003-06-28 -- [ant]: fixes due to changes in enigma:
--   + unnecessary Dynamite remove
--   + changed pathway 'cdefghiJ'
--   + changed hammer/stone_break puzzle, as laser destroys stone_break

--        a   b   c   d   e   f   g   h   i   j   k
targets={"b","b","b","b","b","b","h","b","b","h","v"}

floors={}
stones={}
items={}

floors[" "]={"water"}
floors["%"]={"wood"}

stones["#"]={"rock1"}
stones["&"]={"grate1"}
stones["@"]={"wood"}

floors["!"]={"wood"}
stones["!"]={"bolder", {direction=SOUTH}}

floors["'"]={"wood"}
stones["'"]={"puzzle",{connections=PUZ_1000}}

floors[","]={"wood"}
stones[","]={"puzzle",{connections=PUZ_0010}}

stones["v"]={"oneway",{orientation=SOUTH}}

stones[">"]={"laser", {direction=EAST, on=1, name="laser"}}
stones[")"]={"switch", {target="laser", action="onoff", on=1}}
stones["="]={"pmirror", {movable=1, transparent=0, orientation=2}}

stones["~"]={"glass"}
stones["-"]={"oxyd"}

stones["1"]={"stoneimpulse",{name="impulse1"}}
stones["2"]={"stoneimpulse",{name="impulse2"}}
stones["3"]={"stoneimpulse",{name="impulse3"}}

stones[";"]={"stoneimpulse"}
stones["}"]={"bombs"}

items["s"]={"seed"}
items["("]={"spring1"}

	for tgt, kind in targets do
	local C=format("%c", tgt+64)
	local c=format("%c", tgt+96)
	
		if tgt <= 2 then
		items[C]={"trigger", { action="callback", target="tr"..tgt }}
		else
		items[C]={"trigger", { action="openclose", target="tgt"..tgt}}
		end
	
		if kind == "b" then
		floors[c]={"bridge", { name="tgt"..tgt, type="a"}}
		else
		stones[c]={"door", {type=kind, name="tgt"..tgt}}
		end
	end

stones["|"]={"timer", {target="pulse", action="callback", interval=3}}
items["+"]={"blackbomb"}
--items["k"]={"blackbomb"}

stones["?"]={"stone_break"}
items["/"]={"hammer"}

level = {
"###########         ",
"#.........#!        ",
"#.........#,        ",
"#........A %%%      ",
"#.....*...a%%%      ",
"#.........b%%%      ",
"####.....B %%%%%%   ",
"#..########%'%%%%%  ",
"1........2#%%G   c  ",
"#@.#v###@####g#  d  ",
"#..;@........@#  e  ",
"#..#@@........3  fh ",
"|..#;##########   i ",	-- screen boundary
"#.CDE#..&....}#   J ",
"#.FHI#K@@.....####j#",
"########...........#",
"#..)#/.#.###########",
"#..>(?.k.~&=......&#",
"#....?####.........#",
"#..................#",
"###########........#",
"          #........#",
"          #~~~~~~~##",
"          #-~-~-~-# ",
"          ##-###-## ",
}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function pulse()
    SendMessage("impulse1", "trigger")
    SendMessage("impulse2", "trigger")
    SendMessage("impulse3", "trigger")
end

p1=0
p2=0

function check_buttons()
    if p1 > 0 and p2 > 0 then
	SendMessage("tgt1", "close")
	SendMessage("tgt2", "close")
    else
	SendMessage("tgt1", "open")
	SendMessage("tgt2", "open")
    end
end

function tr1(q)	p1=q	check_buttons()	end
function tr2(q)	p2=q	check_buttons()	end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function puzzle_box(x, y, w, h)
draw_stones("st-puzzle", {x, y}, {1, 0}, w, { connections=PUZ_0101} )
draw_stones("st-puzzle", {x, y+h}, {1, 0}, w, { connections=PUZ_0101} )

draw_stones("st-puzzle", {x, y}, {0, 1}, h, { connections=PUZ_1010} )
draw_stones("st-puzzle", {x+w, y}, {0, 1}, h, { connections=PUZ_1010} )

puzzle(x, y, PUZ_0110)		-- TL
puzzle(x+w, y, PUZ_0011)	-- TR
puzzle(x, y+h, PUZ_1100)	-- BL
puzzle(x+w, y+h, PUZ_1001)	-- BR
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

create_world( strlen(level[1]), getn(level) )
fill_floor("fl-leaves")
	
for y,line in level do
    y=y-1
    for x = 0, level_width-1 do
        local cell = strchar(strbyte(line,x+1))
        local asc=ascii(cell)
        
        if floors[cell] then
            set_floor("fl-"..floors[cell][1], x, y, floors[cell][2])
        end
        
        if stones[cell]=="oxyd" then
            oxyd(x, y)
        elseif stones[cell] then
            set_stone("st-"..stones[cell][1], x, y, stones[cell][2])
        end

        if items[cell] then
            set_item("it-"..items[cell][1], x, y, items[cell][2])
        end
        
        if cell == "*" then
            set_actor("ac-blackball", x+0.5, y+0.5)
        end
    end
    y=y+1
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

puzzle_box(1, 1, 3, 3 )
puzzle(3, 1, PUZ_0000)	-- holes
puzzle(3, 4, PUZ_0000)

oxyd_shuffle()
