-- libpuzzle, a library for enigma
-- Copyright (C) 2005, 2006 Raoul Bourquin
-- Licensed under GPL v2.0 or above
-- Version 0.97

-- This is a lua-library to make it really easy to set up random puzzles.

-- Use this lib this as showed:
-- Save the .lua in /PFAD/TO/ENIGMA/data/levels/lib/libpuzzle.lua
-- On the beginning of your level, just include:
-- Require("levels/lib/libpuzzle.lua")
-- Now you can use every function here, but usually you would just call "puzzle(YOUR OPTIONS)"
-- But you can influence the puzzle() by setting the values in the WORLD section manually to different values.

-----------------------------------
-- User's Reference with Example --
-----------------------------------
--Example to generate an shuffled Ring with 8 Stones (the red ones) at the Position 4/5:
--puzzle({{1,1,1},{1,0,1},{1,1,1}},2,4,"red","yes")

-- in [], this are the values from the example above.

--original_atrix: this is the abstract definition of the puzzle:
--###
--# # this ring has the matrix: {{1,1,1},{1,0,1},{1,1,1}}
--###
--The format is: {row1, row2, row3, ...}
--where row1 is:{stone1, stone2, ston3, ...}
--Pseudo Pieces:
--If you want to set a pseudo piece, you set a "2" in the matrix. This piece will not appear in the level. But it will
--influence the others in this way, that where a pseusdo piece is, the "normal" pieces around it will have connections.
--This is the way to generate open clusters.
--[{{1,1,1},{1,0,1},{1,1,1}}]

--xtopleftcorner/ytopleftcorner or xcorner/ycorner: the absolute coordinates of the top left corner of your puzzle-matrix.
--It's not required that this is really a stone. 
--[2 and 4]

--puzzle_kind: this string describes if we use the blue or the red puzzle stones
--the values are: "blue" for blue and "red" for red ! 
--["red"]

--shuffle: this string says, if the puzzle must be shuffled or not.
--the values are "yes" and "no".
--["yes"]

--now, the syntax for a puzzle is:
--puzzle(original_matrix, xtopleftcorner, ytopleftcorner, puzzle_kind, shuffle)

--if you want to configure the lib for a level, may be change the shuffle algorithm, use the variables in the WORLD section... 

-- it's easy, isn't it ?

-------------------------------------
-- Programmer's Variable Reference --
-------------------------------------
--List of the main globals:
--DON'T change this values directly!
--matrix:  original_matrix
--matrix:  matrix
--matrix:  teile_matrix
--array:   teile={}
--array:   shuffled_pieces={}
--matrix:  stone_coordinates={{},{}}
--array:   xpermutations={}
--array:   ypermutations={}

--original_matrix: This matrix contains the original values, given in puzzle()
--in acts as a backup, it is never changed or used.
--just after calling puzzle() the values will be written in matrix.

--shuffled_pieces: this array keeps the mixed descriptions. 
--[no values, it's random!]

--stone_coordinates: this 2D Array keeps the coordinates of the stones.
--Format: {{X-Values},{Y-Values}}
--{{x-first-stone, xsecond-stone, ...},{y-first-stone, y-second-stone, ...}}
--[{{2,3,4,2,4,2,3,4},{4,4,4,5,5,6,6,6}}]

--teile: this array keeps all strings that describes the different stones used. 
--[{"es","ew","sw","ns","ns","ne","ew","nw"}]

--teile_matrix: this matrix stores the teile at their places.
--neede to shuffle with permutation.

--anz:stones: the number of stones needed.

--TODO:
-->clear the variables, locals, globals...use same names for same local vars, eg. temp,tmp...(half done)
-->release libpuzzle 1.0


----------------------------
--BEGINN OF LIBPUZZLE CODE--
---------------------------------------------------------------
--WORLD SECTION:
--This are global variables. They determine the exact behavior of the puzzle function.
--This values, you can use to configure the lib in your level.
--Just set the variable to the desired value, before you call puzzle().
--Then, your values will be kept until you change them again!

--must we shuffle the pieces or not ?
--1 means true, 0 means false.
--overwrite this in your level to get already solved puzzles.
must_shuffle=1

--which method to shuffle:
--"random" or "permutation"
--not yet used
shuffle_method="permutation"

--with how many permutations we shuffle:
--for bigger puzzles, take bigger values!
--this value is just the base, the real value (num_perm_todo) is calculated this way:
--num_perm_todo=num_perm+random(1,num_perm)
num_perm=10

--this value varies the real num_perm_todo
--without that, you would get everytime the same result, when you shuffle a one-line puzzle...
--do not calculate this value here, calc it in the wrapper function puzzle()
--num_perm_to_add=random(1,num_perm)

--is it allowed to generate "open" clusters ?
--yes=1 no=0
--not yet used, probably this will never be used...
open_cluster=1 

--Default value for the kind of puzzles:
--only used, if nothing given as parameter of puzzle()
art="2"

---------------------------------------------------------------
--HELPERFUNCTIONS:
---------------------------------------------------------------
--Determine the length of an array:
function arraydim(array)
 local i=1
 local array_length=0

 while array[i]~=nil do
  i=i+1
 end

 array_length=i-1
 return array_length
end

--copy a matrix a to a matrix b:
function copy_matrix(matrix1,matrix2)

 local matrix2={}
 local matrdim1=arraydim(matrix1)
 local matcdim1=arraydim(matrix1[1])
 local i=1
 local j=1

 for i=1,matrdim1 do
  matrix2[i]={}
  for j=1,matcdim1 do
   matrix2[i][j]=matrix1[i][j]
  end
 end

 return matrix2
end

--rewrite a matrix:
--DANGER, this changes the matrix in irrevocably!
--there will be a loss of information!
function rewrite_matrix(matrix)

 local rdim1=arraydim(matrix)
 local cdim1=arraydim(matrix[1])
 local i=1
 local j=1

 for i=1,rdim1 do
  for j=1,cdim1 do
   if matrix[i][j]==2 then
    matrix[i][j]=0
   end
  end
 end
 return matrix
end

---------------------------------------------------------------
--WRAPPER:
--The "normal" User of libpuzzle would call this function only.
function puzzle(original_matrix, xtopleftcorner, ytopleftcorner, puzzle_kind, shuffle)

 --make a copy of the original Matrix to work on.
 --this way there are no problem when changing the matrix and recalling puzzle() without regenerating the original matrix.
 matrix=copy_matrix(original_matrix,matrix)

 --argument parser:
 if puzzle_kind ~= nil then
  if puzzle_kind=="blue" then
   art=""
  elseif puzzle_kind=="red" then
   art="2"
  end
 end

 if shuffle ~= nil then
  if shuffle=="yes" then
   must_shuffle=1
  elseif shuffle=="no" then
   must_shuffle=0
  end
 end

 --call the matrix2places to get the real locations of the puzzlestones:
 matrix2places(matrix, xtopleftcorner, ytopleftcorner)

 --call the which_piece to determine the pieces we will need:
 which_piece(matrix)

 --shuffle the pieces?
 if must_shuffle==1 then
   --which method to shuffle?
   if shuffle_method=="random" then
     puzzle_shuffle(teile)
   elseif shuffle_method=="permutation" then
     --determine the number of permutations to use:
     num_perm_to_add=random(1,num_perm)
     num_perm_todo=num_perm+num_perm_to_add
     --cal the shuffle main method:
     shuffle_pieces_with_permutations(matrix,teile,num_perm_todo)
   end
 elseif must_shuffle==0 then
  --to get a shuffled_pieces array (Only necessary because of the arrayname). But the pieces are NOT shuffled.
  shuffled_pieces=teile
 end

 --draw the puzzle
 draw_pieces(stone_coordinates, shuffled_pieces, art)

 return 0
end

---------------------------------------------------------------
--INPUT_PARSER:

--Determine the real coordinates of the stones
function matrix2places(matrix,xcorner,ycorner)

 --new global:
 stone_coordinates={{},{}}

 local i,j
 local counter=1

 local rdim=arraydim(matrix)
 local cdim=arraydim(matrix[1])

  for i=1,rdim do
   for j=1,cdim do
    if matrix[i][j]==1 then
     stone_coordinates[1][counter]=xcorner+j-1
     stone_coordinates[2][counter]=ycorner+i-1
     counter=counter+1
    end
   end
  end

 --number of stones:
 anz_stones=arraydim(stone_coordinates[1])

 return stone_coordinates,anz_stones
end

---------------------------------------------------------------
--Determine the kind of the stones
function which_piece(matrix)

 --new global:
 teile={}

 local rdim=arraydim(matrix)
 local cdim=arraydim(matrix[1])
 local i,j
 local oben=""
 local links=""
 local unten=""
 local rechts=""
 local counter=1

 for i=1,rdim do
  for j=1,cdim do
   if matrix[i][j]==1 then

      if i==1 then
       oben=""
       if rdim>1 then
        unten=tests(matrix,j,i)
       end 
      elseif i==rdim then
       unten=""
       if rdim>1 then
        oben=testn(matrix,j,i) 
       end
      else
       oben=testn(matrix,j,i) 
       unten=tests(matrix,j,i) 
      end 
 
      if j==1 then
       links=""
       if cdim>1 then
        rechts=teste(matrix,j,i) 
       end
      elseif j==cdim then
       rechts=""
       if cdim>1 then
        links=testw(matrix,j,i) 
       end
      else
       rechts=teste(matrix,j,i) 
       links=testw(matrix,j,i) 
      end  

      -- To get a valid Stone if no neighbours were present, we define it as the (untunneled) cross ("nesw")
      if oben=="" and rechts=="" and unten=="" and links=="" then
       oben="n"
       rechts="e"
       unten="s"
       links="w"
      end

      teile[counter]=oben..rechts..unten..links
      counter=counter+1
   end
  end
 end

 --call the rewrite_matrix, because from now on, we wont have the disturbing "pseudo_pieces":
 --we ONLY use them to get a "special" teile Array, which will produce an "open" puzzle cluster.
 rewrite_matrix(matrix)

 return teile
end

---------------------------------------------------------------
--Helperfunction for testing the required connection of a puzzlestone:
function testn(matrix,posx,posy)
 if matrix[posy-1][posx]==1 or matrix[posy-1][posx]==2 then
  return "n"
 else
  return ""
 end
end

function teste(matrix,posx,posy)
 if matrix[posy][posx+1]==1 or matrix[posy][posx+1]==2 then
  return "e"
 else
  return ""
 end
end

function tests(matrix,posx,posy)
 if matrix[posy+1][posx]==1 or matrix[posy+1][posx]==2 then
  return "s"
 else 
  return ""
 end
end

function testw(matrix,posx,posy)
 if matrix[posy][posx-1]==1 or matrix[posy][posx-1]==2 then
  return "w"
 else
  return ""
 end
end

---------------------------------------------------------------
--RANDOM SHUFFLE
--shuffle the array teile, this is the classical method.
--it's not guaranted to get a solvable puzzle every time!
function puzzle_shuffle(teile)
 
 shuffled_pieces={}

 local restteile={}
 local anz=anz_stones
 local zyklen=anz
 local i,j,k
 local counter=1
 local aktteil

 for i=1,zyklen do

  --shuffle pieces:
  t=random(1,anz)
  
  aktteil=teile[t]
  shuffled_pieces[counter]=aktteil
  counter=counter+1

  --prepare the teile array for next cycle
  local restteile={}
  local schogse=0

  --copy the teile array, mark the piece we just have used with "0"
  for k=1,anz do
   if teile[k]==aktteil and schogse==0 then
    restteile[k]="0"
    schogse=1
   else
    restteile[k]=teile[k]
   end
  end

  --clear teile array:
  teile={}
  local t=1

  for j=1,anz do
   if restteile[j]~="0" then
    teile[t]=restteile[j]
    t=t+1
   end 
  end
  
  --we have used one piece:
  anz=anz-1
 end

end
---------------------------------------------------------------
--PERMUTATION-SHUFFLE:
--here you will get a solvable Puzzle EVERY time!
function analyzerow(matrix,row)

 --new global:
 xpermutations={}

 --Zählcountereter zum durchlaufen der Reihe:
 local counter = 1

 --Counter to count the number of Permutations:
 local perm_counter = 0
 local local_counter
 local local_length
 local array=matrix[row]
 local length=arraydim(array)

 while counter<=length do

  --If MatrixPlatz is zero, do nothing
  if array[counter]==0 then

   counter=counter+1

  --Get the length of the Ones-Sequenz
  else
   
   local_counter = 0
   local_length = 0

   --Schaue wie lang eine Reihe ist:
   while array[counter+local_counter]==1 do
    local_counter=local_counter+1
    local_length = local_length +1
   end
   
   --big IF, is it a Permutation or not?
   if local_length >= 2 then

    --Yes, increase the number of Permutations by 1:
    perm_counter = perm_counter + 1

    --add an array to the permutation-array:
    xpermutations[perm_counter]={}

    --start
    xpermutations[perm_counter][1]={}
    --end
    xpermutations[perm_counter][2]={}

    --set the beginning:
    --ROW value 
    xpermutations[perm_counter][1][1]=row
    --COL value
    xpermutations[perm_counter][1][2]=counter

    --set end:
    --ROW value
    xpermutations[perm_counter][2][1]=row
    --COL value
    xpermutations[perm_counter][2][2]=counter+local_length-1

   end
   
   --jump just after the sequence of "1":
   counter=counter+local_length

  end
 end

end

--------------------------------------------------------------------
function analyzecol(matrix,col)

 --new global:
 ypermutations={}

 --Zählcountereter zum durchlaufen der Reihe:
 local counter = 1

 --countereter der die anz Permutationen zählt:
 local perm_counter = 0
 local local_counter
 local local_length
 local length=arraydim(matrix)
 local array={}

 --make a valid array
 for i=1,length do
  array[i]=matrix[i][col]
 end

 while counter<=length do
  
  --Wenn der MatrixPlatz null ist, tue nichts
  if array[counter]==0 then

   counter=counter+1

  --Finde heraus, wie lang die Einsen-Sequenz ist
  else
   
   local_counter = 0
   local_length = 0

   --Schaue wie lang eine Reihe ist:
   while array[counter+local_counter]==1 do
    local_counter=local_counter+1
    local_length = local_length +1
   end
   
   --grosse IF entscheidung:
   if local_length >= 2 then

    --erhöhe die anzahl der gefundenen Permutationen um 1:
    perm_counter = perm_counter + 1

    --verlängere den Permutationsarray um einen nuenen array:
    ypermutations[perm_counter]={}

    --anfang
    ypermutations[perm_counter][1]={}
    --ende
    ypermutations[perm_counter][2]={}

    --setze anfang:
    --Reihenwert des Anfangs
    ypermutations[perm_counter][1][1]=counter
    --Spaltenwert des Anfangs
    ypermutations[perm_counter][1][2]=col

    --setze ende:
    --Reihenwert des endes
    ypermutations[perm_counter][2][1]=counter+local_length-1
    --Spaltenwert des endes
    ypermutations[perm_counter][2][2]=col

   end
   
   --springe gerade nach die einersequenz:
   counter=counter+local_length

  end
 end
 
end

--------------------------------------------------------------------------
function find_all_permutations(matrix)

 permutations={}
 number_of_permutations=1

 local rdim=arraydim(matrix)
 local cdim=arraydim(matrix[1])
 local i,j,k

 --search all permutations:
  --the x ones:
  for i=1,rdim do

   analyzerow(matrix,i)

   local temp=arraydim(xpermutations)

   --write the permutations to the global store:
   for k=1,temp do
    permutations[number_of_permutations]=xpermutations[k]
    number_of_permutations=number_of_permutations+1
   end
  end

  --the y ones:
  for i=1,cdim do

   analyzecol(matrix,i)
   local temp=arraydim(ypermutations)

   --write the permutations to the global store:
   for k=1,temp do
    permutations[number_of_permutations]=ypermutations[k]
    number_of_permutations=number_of_permutations+1
   end
  end

  --Because counter has initial value 1, we have count one permutation to much:
  number_of_permutations=number_of_permutations-1

  return permutations
end

--------------------------------------------------------------------------
function use_permutation(teile_matrix,permutations,n)

 local p=permutations[n]
 local rbeg=p[1][1]
 local cbeg=p[1][2]
 local rend=p[2][1]
 local cend=p[2][2]

 local temp = teile_matrix[rend][cend]

 if rbeg==rend then
  --horizontal
  local t=1

  while cend-t>=cbeg do
   teile_matrix[rbeg][cend-t+1]=teile_matrix[rbeg][cend-t]
   t=t+1
  end
  teile_matrix[rbeg][cbeg]=temp

 elseif cbeg==cend then
  --vertical
  local t=1

  while rend-t>=rbeg do
   teile_matrix[rend-t+1][cbeg]=teile_matrix[rend-t][cbeg]
   t=t+1
  end
  teile_matrix[rbeg][cbeg]=temp

 end

 return teile_matrix
end
--------------------------------------------------------------------------
function teile2teile_matrix(matrix,teile)

 --teile_matrix=matrix, but this seems not to work. So we call a function:
 teile_matrix=copy_matrix(matrix,teile_matrix)
 
 local rdim=arraydim(matrix)
 local cdim=arraydim(matrix[1])
 local i,j,t=1,1,1

 for i=1,rdim do
  for j=1,cdim do
   if matrix[i][j]==0 then
    teile_matrix[i][j]="--"
   else
    teile_matrix[i][j]=teile[t]
    t=t+1
   end
  end
 end

 return teile_matrix
end

--------------------------------------------------------------------------
function teile_matrix2teile(teile_matrix)

 --new global:
 shuffled_pieces={}

 local rdim=arraydim(teile_matrix)
 local cdim=arraydim(teile_matrix[1])
 local i,j,t=1,1,1
 
 for i=1,rdim do
  for j=1,cdim do
   if teile_matrix[i][j]=="--" then
    --do nothing
   else
    --write the found piece to the shuffled_pieces array:
    shuffled_pieces[t]=teile_matrix[i][j]
    t=t+1
   end
  end
 end

 return shuffled_pieces
end

--------------------------------------------------------------------------
--Main Function of the Permutation-Shuffle branch:
function shuffle_pieces_with_permutations(matrix,teile,num_perm_todo)

 --Search all Permutations:
 find_all_permutations(matrix)

 --Convert the teile to teile_matrix:
 teile2teile_matrix(matrix,teile)

 local i,t
 local num_perms=arraydim(permutations)

 --to catch the error, if num_perms<1:
 if num_perms>0 then
  for i=0,num_perm_todo do
   --if there were no permutations, this produces an error:
   t=random(1,num_perms)
   use_permutation(teile_matrix,permutations,t)
  end
 end
 
 --Convert the teile_matrix back to teile:
 teile_matrix2teile(teile_matrix,teile)

 return shuffled_pieces
end

---------------------------------------------------------------
--OUTPUT:

--Draw the Puzzlestones:
function draw_pieces(stone_coordinates,shuffled_pieces,art)

 local i
 local anz=anz_stones

  for i=1,anz do
  set_stone("st-puzzle"..art.."-"..shuffled_pieces[i], stone_coordinates[1][i], stone_coordinates[2][i])
 end
end

---------------------------------------------------------------
--END OF LIBPUZZLE CODE --
--------------------------

