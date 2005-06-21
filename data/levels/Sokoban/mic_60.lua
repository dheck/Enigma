-- A sokoban clone for Enigma
-- Name    : Microban 60
-- Filename: mic_60.lua
--
-- Taken from Microban
-- Copyright: David W Skinner
-- Email    : sasquatch@bentonrea.com
-- Website  : http://users.bentonrea.com/~sasquatch/sokoban/
-- With friendly permission from David W Skinner.
--
-- Converted to enigma format by Ralf Westram (amgine@reallysoft.de)


dofile(enigma.FindDataFile("levels/ralf_sokoban.lua"))

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

level={
  "!#########",
  "!#       #",
  "##@##### #",
  "#  #   # #",
  "#  #   o.#",
  "#  ##o##.#",
  "##o##  #.#",
  "#   o  #.#",
  "#   #  ###",
  "########!!",
}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

play_sokoban(level,868)

document(xlo+6,ylo+8,"In Sokoban you have to shift ALL available stones onto the target triggers.")

