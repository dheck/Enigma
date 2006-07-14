-- Copyright (c) 2003 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Control Panel

levelw=77
levelh=13

create_world( levelw, levelh)

fill_floor("fl-metal", 0,0,levelw,levelh)

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
        local c = strsub( pattern, i, i)
        if c =="#" then
            set_stone( "st-greenbrown", i-1, line)
        elseif c == "o" then
            oxyd( i-1, line)
        elseif c == "P" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser1"})
        elseif c == "Q" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser2"})
        elseif c == "R" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser3"})
        elseif c == "S" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser4"})
        elseif c == "T" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser5"})
        elseif c == "U" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser6"})
        elseif c == "V" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser7"})
        elseif c == "<" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser8"})
        elseif c == "X" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser9"})
        elseif c == "Y" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser10"})
        elseif c == "a" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser11"})
        elseif c == "b" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser12"})
        elseif c == "c" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser13"})
        elseif c == "d" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser14"})
        elseif c == "e" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser15"})
        elseif c == "f" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser16"})
        elseif c == "g" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser17"})
        elseif c == "h" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser18"})
        elseif c == "i" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser19"})
        elseif c == "j" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser20"})
        elseif c == "k" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser21"})
        elseif c == "l" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser22"})
        elseif c == "m" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser23"})
        elseif c == "n" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser24"})
        elseif c == "`" then
            set_item("it-trigger", i-1,line, {action="onoff",target="laser25"})
        elseif c == "z" then	
            set_actor("ac-blackball", i-.5,line+.5)
        elseif c == "p" then
            set_attrib(laser(i-1,line, TRUE, EAST), "name", "laser1")
        elseif c == "q" then
            set_attrib(laser(i-1,line, TRUE, SOUTH), "name", "laser2")
        elseif c == "r" then
            set_attrib(laser(i-1,line, TRUE, EAST), "name", "laser3")
        elseif c == "s" then
            set_attrib(laser(i-1,line, TRUE, EAST), "name", "laser4")
        elseif c == "t" then
            set_attrib(laser(i-1,line, TRUE, EAST), "name", "laser5")
        elseif c == "u" then
            set_attrib(laser(i-1,line, TRUE, EAST), "name", "laser6")
        elseif c == "v" then
            set_attrib(laser(i-1,line, TRUE, EAST), "name", "laser7")
        elseif c == "," then
            set_attrib(laser(i-1,line, TRUE, EAST), "name", "laser8")
        elseif c == "x" then
            set_attrib(laser(i-1,line, TRUE, EAST), "name", "laser9")
        elseif c == "y" then
            set_attrib(laser(i-1,line, TRUE, EAST), "name", "laser10")
        elseif c == "A" then
            set_attrib(laser(i-1,line, FALSE, SOUTH), "name", "laser11")
        elseif c == "B" then
            set_attrib(laser(i-1,line, FALSE, SOUTH), "name", "laser12")
        elseif c == "C" then
            set_attrib(laser(i-1,line, FALSE, SOUTH), "name", "laser13")
        elseif c == "D" then
            set_attrib(laser(i-1,line, FALSE, SOUTH), "name", "laser14")
        elseif c == "E" then
            set_attrib(laser(i-1,line, FALSE, SOUTH), "name", "laser15")
        elseif c == "F" then
            set_attrib(laser(i-1,line, FALSE, SOUTH), "name", "laser16")
        elseif c == "G" then
            set_attrib(laser(i-1,line, FALSE, SOUTH), "name", "laser17")
        elseif c == "H" then
            set_attrib(laser(i-1,line, FALSE, SOUTH), "name", "laser18")
        elseif c == "I" then
            set_attrib(laser(i-1,line, FALSE, SOUTH), "name", "laser19")
        elseif c == "J" then
            set_attrib(laser(i-1,line, FALSE, SOUTH), "name", "laser20")
        elseif c == "K" then
            set_attrib(laser(i-1,line, FALSE, SOUTH), "name", "laser21")
        elseif c == "L" then
            set_attrib(laser(i-1,line, FALSE, SOUTH), "name", "laser22")
        elseif c == "M" then
            set_attrib(laser(i-1,line, FALSE, SOUTH), "name", "laser23")
        elseif c == "N" then
            set_attrib(laser(i-1,line, FALSE, SOUTH), "name", "laser24")
        elseif c == "~" then
            set_attrib(laser(i-1,line, FALSE, SOUTH), "name", "laser25")
        elseif c == "+" then
            set_stone("st-wood", i-1, line)
        elseif c == "*" then
            set_stone("st-brownie", i-1, line)
        elseif c == "w" then
            draw_stones("st-glass", {i-1,line},{1,0}, 1)
        elseif c == "/" then
            mirrorp(i-1,line,FALSE,FALSE, 4)
        elseif c == ";" then
            mirrorp(i-1,line,FALSE,FALSE, 2)
        elseif c == "?" then
            mirrorp(i-1,line,FALSE,TRUE, 4)
        elseif c == ":" then
            mirrorp(i-1,line,FALSE,TRUE, 2)
        elseif c == "/" then
            mirrorp(i-1,line,FALSE,FALSE, 4)
        elseif c == ";" then
            mirrorp(i-1,line,FALSE,FALSE, 2)
        elseif c == "?" then
            mirrorp(i-1,line,FALSE,TRUE, 4)
        elseif c == ":" then
            mirrorp(i-1,line,FALSE,TRUE, 2)
        elseif c == "|" then
            draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
        elseif c == "0" then
            abyss(i-1,line)
            draw_stones("st-glass", {i-1,line},{1,1}, 1)
        elseif c == "1" then
            fill_floor("fl-leaves", i-1,line,1,1)
            draw_stones("st-glass", {i-1,line},{1,0}, 1)
        elseif c == "2" then
            fill_floor("fl-sand", i-1,line,1,1)
            draw_stones("st-glass", {i-1,line},{1,0}, 1)
        elseif c == "3" then
            fill_floor("fl-bluegreen", i-1,line,1,1)
            draw_stones("st-glass", {i-1,line},{1,0}, 1)
        elseif c == "4" then
            fill_floor("fl-inverse", i-1,line, 1,1)
            draw_stones("st-glass", {i-1,line},{1,0}, 1)
        elseif c == "@" then
            document(i-1,line,"01011-00100-01...")
        elseif c == "Z" then
            document(i-1,line,"The left-most room is important!")
        elseif c == "!" then
            document(i-1,line,"This is the control panel.")

        end
    end
end

-- Floor:  " "
-- Border: "#"
-- Oxyd:   "o"

renderLine(00, "#############################################################################")
renderLine(01, "#                  #                  #       w/w        w                 ;#")
renderLine(02, "#  0          w    #     021422133    #       www        #                y?#")
renderLine(03, "#            www   #     3       2    #                  #                x?#")
renderLine(04, "#  1    @    w#w   #   * 3 aPbQR 3 *  #                  #                ,?#")
renderLine(05, "#           wwww   #   * 1 cdSef 1 *  #                  #                v?#")
renderLine(06, "#o 2        w##w   |   *   gThij   *  |                 o#                u?#")
renderLine(07, "#          wwwww   #   * 2 kUVlm 2 *  #                  #                t?#")
renderLine(08, "#  3       w###w   #   * 3 <XnY` 3 *  #                  #                s?#")
renderLine(09, "#         wwwwww   #     3   z   2    #                  #                r?#")
renderLine(10, "#  4      w####w   #     321422130    #                  # ABCDEFGHIJKLMN~q #")
renderLine(11, "#         wwwwww   #                  #                  #p::::::::::::::::/#")
renderLine(12, "#############################################################################")

oxyd_shuffle()















