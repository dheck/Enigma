-- A sokoban clone for Enigma
-- Name    : Mas Microban 109
-- Filename: mmic_109.lua
--
-- Taken from Mas Microban
-- Copyright: David W Skinner
-- Email    : sasquatch@bentonrea.com
-- Website  : http://users.bentonrea.com/~sasquatch/sokoban/
-- With friendly permission from David W Skinner.
--
-- Converted to enigma format by Ralf Westram (amgine@reallysoft.de)


dofile(enigma.FindDataFile("levels/ralf_sokoban.lua"))

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

level={
  "!#####!!!!",
  "!# . #####",
  "!#o oo o #",
  "!# .. . .#",
  "##o   .o #",
  "# o.   o##",
  "#. . .. #!",
  "#@o oo o#!",
  "##### . #!",
  "!!!!#####!",
}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

psymm = 1
play_sokoban(level,1241)

