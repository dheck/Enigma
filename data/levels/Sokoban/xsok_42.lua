-- A sokoban clone for Enigma
-- Name    : Sokoban 42
-- Filename: xsok_42.lua
--
-- Taken from Sokoban
-- Copyright: Thinking Rabbit
--
-- Converted to enigma format by Ralf Westram (amgine@reallysoft.de)


dofile(enigma.FindDataFile("levels/ralf_sokoban.lua"))

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

level={
  "!!!!!########!!!!!",
  "!!####      ######",
  "!!#    ## o o   @#",
  "!!# ## ##o#o o o##",
  "### ......#  oo ##",
  "#   ......#  #   #",
  "# # ......#o  o  #",
  "# #o...... oo# o #",
  "#   ### ###o  o ##",
  "###  o  o  o  o #!",
  "!!#  o  o  o  o #!",
  "!!######   ######!",
  "!!!!!!!#####!!!!!!",
}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

play_sokoban(level,768)

