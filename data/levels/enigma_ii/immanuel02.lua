-- Door Maze
-- (c) 2003 by Immanuel Herrmann
-- Licensed under GPL v2.0 or above


levelw = 20
levelh = 13

create_world(levelw, levelh)
enigma.ConserveLevel = FALSE

oxyd_default_flavor = "a"

fill_floor("fl-bluegray", 0, 0, levelw, levelh)

zaehler = 1

function tuer(x, y, ri)
  set_floor( "fl-bluegreen", x, y)
  set_stone( "st-bolder", x, y, {direction=ri, name="tuer"..strsub("dcbae",zaehler, zaehler)})
  zaehler = zaehler + 1
end


function kabel(x, y, co)
  set_stone( "st-puzzle", x, y, {connections = co})
end




function renderLine( y, pattern)
    for x=0, strlen(pattern) - 1 do
        local c = strsub( pattern, x + 1, x + 1)
        if c =="#" then
            set_stone( "st-rock2", x, y)
        elseif c == "o" then
            oxyd( x, y)
        elseif c == "s" then
            set_actor("ac-blackball", x+0.5, y+0.5)

        elseif c == "-" then
            kabel(x, y, 6)
        elseif c == "|" then
            kabel(x, y, 11)
        elseif c == "`" then
            kabel(x, y, 13)
        elseif c == "'" then
            kabel(x, y, 10)
        elseif c == "," then
            kabel(x, y, 7)
        elseif c == "." then
            kabel(x, y, 4)
        elseif c == "+" then
            kabel(x, y, 16)
        elseif c == ":" then
            set_stone( "st-puzzle", x, y, {connections = 1})
            --set_stone("st-grate1", x, y)
        elseif c == "~" then
            set_stone("st-grate1", x, y)

        elseif (c >= "A" and c <= "E") or (c >= "a" and c <= "e") then
            set_item("it-trigger", x, y, {action="callback", target="tt"..c})
        elseif c == "t" then
            set_floor( "fl-bluegreen", x, y)
        elseif c == "^" then
            tuer(x, y, NORTH)
        elseif c == ">" then
            tuer(x, y, EAST)
        elseif c == "v" then
            tuer(x, y, SOUTH)
        elseif c == "<" then
            tuer(x, y, WEST)
        elseif c == "" then
            set_stone( "", x, y)
        elseif c == "" then
            set_stone( "", x, y)
        elseif c == "" then
            set_stone( "", x, y)
        end
    end
end

renderLine( 0, "####,------.########")
renderLine( 1, "#   D#     |      C.")
renderLine( 2, "# ## # # # `:.## ##|")
renderLine( 3, ",ao,:-:-:-t<t'o#   |")
renderLine( 4, "| #|s,:. # # ,t>t-:'")
renderLine( 5, "| e: t | B #E: # # #")
renderLine( 6, "|,+'#v#|,'  ||#,t<t.")
renderLine( 7, "|dt  t `+b# || : # |")
renderLine( 8, "|#v# `:-'c-:+' |   |")
renderLine( 9, "| t  #      :  |###|")
renderLine(10, "|~`---------'##|   |")
renderLine(11, "|     ~        : #A'")
renderLine(12, "`--------------'####")

--renderLine( 0, ",------------------.")
--renderLine( 1, "|   D------.      C|")
--renderLine( 2, "| ## #     `:.## ,'|")
--renderLine( 3, "`ao,:-:-:-t<t'o# : |")
--renderLine( 4, "# #|s,:. # # ,t>t' |")
--renderLine( 5, "# e: t | B #E: ,:-:'")
--renderLine( 6, "#,+'#v#|,'  ||#`t<t.")
--renderLine( 7, "#dt  t `+b# ||   # |")
--renderLine( 8, "##v# `:-'c-:+' #   |")
--renderLine( 9, "# t  #      :  ####|")
--renderLine(10, "# `---------'##   #|")
--renderLine(11, "#               # A'")
--renderLine(12, "####################")





function tuer_bewegen(tnr, ri)
   SendMessage("tuer"..tnr, "direction", ri);
end


-- Grossbuchstabe bewegt nach west / nord...

function ttA()
  tuer_bewegen("a", WEST)
end
function tta()
  tuer_bewegen("a", EAST)
end
function ttB()
  tuer_bewegen("b", NORTH)
end
function ttb()
  tuer_bewegen("b", SOUTH)
end
function ttC()
  tuer_bewegen("c", WEST)
end
function ttc()
  tuer_bewegen("c", EAST)
end
function ttD()
  tuer_bewegen("d", WEST)
end
function ttd()
  tuer_bewegen("d", EAST)
end
function ttE()
  tuer_bewegen("e", NORTH)
end
function tte()
  tuer_bewegen("e", SOUTH)
end















