-- Double Play, a level for Enigma
-- Copyright (C) 2005 JuSt
-- Licensed under GPL v2.0 or above

Require("levels/lib/ant.lua")

--debug_mode ()

multiplayer_mode()

function file_oxyd(x,y,f)
    oxyd_default_flavor=f
    oxyd(x,y)
end

function func1()
  SendMessage("door1","openclose")
  SendMessage("door2","openclose")
end

levelh=13
levelw=58

enigma.FlatForce=30
enigma.SlopeForce=30
enigma.ElectricForce=30

cells={}
items={}
actors={}
stones={}
puzzles2={}
puzzles1={}

actors[" "]=cell{}
stones[" "]=cell{}
cells[" "]=cell{}
items[" "]=cell{}

cells["!"]=cell{floor="fl-bluegray"}
cells["#"]=cell{floor="fl-normal"}
cells["$"]=cell{floor="fl-abyss"}
cells["~"]=cell{floor="fl-water"}
cells["="]=cell{floor={"fl-bridge", {name="bridge"}}}

stones["!"]=cell{stone="st-blue-sand"}
stones["-"]=cell{stone="st-oneway_white-e"}
stones["."]=cell{stone="st-oneway_black-e"}
stones["/"]=cell{stone="st-pull"}
stones["0"]=cell{stone="st-wood"}
stones["c"]=cell{stone="st-stoneimpulse"}
stones["d"]=cell{stone="st-swap"}
stones["3"]=cell{stone="st-grate1"}
stones["4"]=cell{stone="st-glass"}
stones["5"]=cell{stone={"st-laser-e", {name="laser"}}}
stones["6"]=cell{stone="st-mirror-3v"}
stones["7"]=cell{stone="st-mirror-p\\"}
stones["8"]=cell{stone="st-mirror-p/t"}
stones["9"]=cell{stone="st-mirror-3<t"}
stones[":"]=cell{stone="st-mirror-3^t"}
stones[";"]=cell{stone="st-mirror-p/"}
stones["<"]=cell{stone={"st-laserswitch", {action="callback", target="func1"}}}
stones["a"]=cell{stone={"st-door-v", {name="door1"}}}
stones["b"]=cell{stone={"st-door-v", {name="door2"}}}
stones["e"]=cell{stone={"st-door-v", {name="door3"}}}
stones["f"]=cell{stone={"st-door-v", {name="door4"}}}
stones[">"]=cell{parent={{file_oxyd,"d"}}}
stones["#"]=cell{stone="st-mail-n"}
stones["@"]=cell{stone="st-mail-s"}
stones["A"]=cell{stone={"st-key_b", {action="openclose", target="door4"}}}
stones["B"]=cell{stone={"st-key_a", {action="openclose", target="door3"}}}
stones["?"]=cell{parent={{add_multicell, puzzles2}}}
stones["*"]=cell{stone={"st-coinslot", {action="openclose", target="bridge"}}}

items["!"]=cell{item="it-key_a"}
items["#"]=cell{item="it-key_b"}
items["$"]=cell{item={"it-burnable", {name="feuer"}}}
items["%"]=cell{item={"it-trigger", {action="ignite", target="feuer"}}}
items["+"]=cell{item={"it-burnable"}}
items["*"]=cell{item={"it-coin2"}}


level = {"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",
         "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",
         "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",
         "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",
         "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",
         "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!$!!!!!!!!",
         "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",
         "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!~~~~~~~~~~~!!!!!!!!",
         "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!~!!!!!!!!!!!!!!!!!",
         "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!~!!!!!!!!!!!!!!!!!",
         "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!~~~~~~~!!!!!!!!!",
         "!!!!!!!!!!!!!!!!!!!=!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",
         "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"}

acmap = {"                                                          ",
         " 1                                                        ",
         "                                                          ",
         "                                                          ",
         "                                                          ",
         "                                                          ",
         "                                                          ",
         "                                                          ",
         "                                                          ",
         "                                                          ",
         "                                                          ",
         " 2                                                        ",
         "                                                          "}

itmap = {"                                                          ",
         "                                       ++++++++++         ",
         " *                                     +++++++$%+         ",
         "                                   #   ++++++++++         ",
         "                                       ++++++++++         ",
         "                                       ++++++++++         ",
         "                                                          ",
         "                                                          ",
         "                                !                         ",
         "                                                          ",
         "                                                          ",
         "                                                          ",
         "                                                          "}

stmap = {"!!!!!!!!!!!!!!!!!!!!*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!>>>>!",
         "!         -     !!            a3333333   0 0 0 0 !  e    !",
         "!         !     !! !          !3333333! 0 0 0 0 0!  !!!!A!",
         "!         !     !! !4444849444!3333333!  0 0 0 0 !       !",
         "!   ???   !      ! !4444444444!3333333! 0 0 0 0 0!       !",
         "!   ???   !     03 !54644444;<!3333333!  0 0 0 0         !",
         "!!!!!?!!!!!!!!!!cc!!!!4!4!4!4!!!!!!!!!!!!!!!!!!!!!!!!!#@!!",
         "!   ???   !    0c0 !4444444444!3333333!                  !",
         "!   ???   ! /  000 !4444444444!3333333!      0   !       !",
         "!         !        !447494:494!3333333!   0    0 !       !",
         "!         !     d  !          !3333333!  0       !  !!!!B!",
         "!         .                   b3333333           !  f    !",
         "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!>>>>!"}


function scrambling (map, char)
  randomseed(enigma.GetTicks())
  numstones = 0
  xpos = {}
  ypos = {}
  nam  = {}
  typ  = {}
  con  = {}
  -- First, lets collect the puzzelstones named <char> in the map <map>
  for i = 1, levelh do
    local line = map[i]
    for j = 1, strlen(line) do
      local c = strsub(line,j,j)
      if c == char then
        if enigma.GetStone(j - 1, i - 1) ~= nil then
          numstones = numstones + 1
          xpos[numstones] = j - 1
          ypos[numstones] = i - 1
          nam[numstones] = enigma.GetKind(enigma.GetStone(xpos[numstones], ypos[numstones]))
          con[numstones] = enigma.GetAttrib(enigma.GetStone(xpos[numstones], ypos[numstones]),"connections")
          typ[numstones] = enigma.GetAttrib(enigma.GetStone(xpos[numstones], ypos[numstones]),"oxyd")
        end
      end
    end
  end
  -- and now, lets shuffle them
  for i = 1, numstones do
    ok = 0
    repeat
      xx = random(numstones)
      if nam[xx] ~= "" then
        kill_stone(xpos[i], ypos[i])
        set_stone(nam[xx], xpos[i], ypos[i], {connections=con[xx], oxyd=typ[xx]})
        nam[xx] = ""
        ok = 1
      end
    until ok == 1
  end
end

create_world_by_map(level)
draw_map(0,0,stmap,stones)
draw_map(0,0,itmap,items)
draw_map(0,0,acmap,actors)

render_puzzles(puzzles2, puzzle2)

scrambling (stmap, "?")

oxyd_shuffle()

SendMessage("laser","on")






















