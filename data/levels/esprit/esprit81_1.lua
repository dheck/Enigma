-- A level for Enigma
-- Copyright: 	(C) 2003 Sven Siggelkow
-- License: 	GPL v2.0 or above

-- ESPRIT #081



levelw = 39

levelh = 21

create_world(levelw, levelh)

display.SetFollowMode(display.FOLLOW_SCROLLING)

oxyd_default_flavor = "a"

set_actor("ac-blackball", 1.5,1.5)

fill_floor("fl-leaves",0,0,levelw,levelh)



function renderLine( line, pattern)

    for i=1, strlen(pattern) do

      local c = strsub( pattern, i, i)

      if c ==   "#" then

         set_stone("st-brick", i-1,line)

      elseif c=="." then

         set_item("it-extralife",i-1,line)

      elseif c=="~" then

         set_item("it-crack0",i-1,line)

      elseif c=="1" then

	 set_stone("st-fourswitch", i-1,line, {action="callback", target="s1"})

      elseif c=="2" then

	 set_stone("st-fourswitch", i-1,line, {action="callback", target="s2"})

      elseif c=="3" then

	 set_stone("st-fourswitch", i-1,line, {action="callback", target="s3"})

      elseif c=="4" then

	 set_stone("st-fourswitch", i-1,line, {action="callback", target="s4"})

      elseif c=="5" then

	 set_stone("st-fourswitch", i-1,line, {action="callback", target="s5"})

      elseif c=="6" then

	 set_stone("st-fourswitch", i-1,line, {action="callback", target="s6"})

      elseif c=="7" then

	 set_stone("st-fourswitch", i-1,line, {action="callback", target="s7"})

      elseif c=="8" then

	 set_stone("st-fourswitch", i-1,line, {action="callback", target="s8"})

      elseif c=="9" then

	 set_stone("st-fourswitch", i-1,line, {action="callback", target="s9"})

      elseif c=="0" then

	 set_stone("st-fourswitch", i-1,line, {action="callback", target="s0"})

      elseif c=="A" then

	 set_stone("st-fourswitch", i-1,line, {action="callback", target="sA"})

      elseif c=="B" then

	 set_stone("st-fourswitch", i-1,line, {action="callback", target="sB"})

      elseif c=="C" then

	 set_stone("st-fourswitch", i-1,line, {action="callback", target="sC"})

      elseif c=="D" then

	 set_stone("st-fourswitch", i-1,line, {action="callback", target="sD"})

      elseif c=="E" then

	 set_stone("st-fourswitch", i-1,line, {action="callback", target="sE"})

      elseif c=="<" then

         set_stone("st-oneway_black-w",i-1,line)

      elseif c==">" then

         set_stone("st-oneway_black-e",i-1,line)

      elseif c=="v" then

         set_stone("st-oneway_black-s",i-1,line)

      elseif c=="^" then

         set_stone("st-oneway_black-n",i-1,line)

      elseif c=="O" then

	 oxyd(i-1,line)         

        end

    end  

end

--               012345678901234567890123456789012345678

renderLine(00 , "#######################################")

renderLine(01 , "#     ##     ##         ##     ##     #")

renderLine(02 , "#     ##     ##         ##     ##     #")

renderLine(03 , "#  1  ><  2  ><    3    ><  4  ><  5~ #")

renderLine(04 , "#     ##     ##         ##  ~  ##     #")  

renderLine(05 , "#     O#  ~  #O         #O     ##     #")

renderLine(06 , "###v######v########v########v######v###")

renderLine(07 , "###^######^########^########^######^###")

renderLine(08 , "#     ##     ##         ##     ##     #")

renderLine(09 , "#  ~  ## ~   ##         ##     ##     #")

renderLine(10 , "#  6  ><  7  ><    8    ><  9~ ><  0  #")

renderLine(11 , "#     ##     ##         ##     ##   ~ #")

renderLine(12 , "#     ##     O#         O#     ##     #") 

renderLine(13 , "###v######v########v########v######v###")

renderLine(14 , "###^######^########^########^######^###")

renderLine(15 , "#    .##     #O         ##     ##     #")

renderLine(16 , "#     ## ~   ##   ~     ##     ##     #")

renderLine(17 , "#  A  ><  B  ><    C    ><  D  ><  E  #")  

renderLine(18 , "#     ##     ##         ##   ~ ##     #")

renderLine(19 , "#     O#     ##         ##.    #O     #")

renderLine(20 , "#######################################")

--               012345678901234567890123456789012345678

                               

-- var        1 2 3 4 5 6 7 8 9 0 A B C D E 

local flag = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

-- I          1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 





function s1()                               

flag[1] = flag[1] + 1

if flag[1] == 4 then flag[1] = 0 end 

if flag[1] == 0 then

    set_stone("st-oneway_black-w", 7,3)

    set_stone("st-oneway_black-n", 3,7)

 elseif flag[1] == 1 then

    set_stone("st-oneway_black-e", 7,3)

    set_stone("st-oneway_black-n", 3,7)

 elseif flag[1] == 2 then

    set_stone("st-oneway_black-w", 7,3)

    set_stone("st-oneway_black-s", 3,7)

 elseif flag[1] == 3 then

    set_stone("st-oneway_black-w", 7,3)

    set_stone("st-oneway_black-n", 3,7)

 end

end                              

 

function s2()                               

flag[2] = flag[2] + 1

if flag[2] == 4 then flag[2] = 0 end

if flag[2] == 0 then

    set_stone("st-oneway_black-w", 14,3)

    set_stone("st-oneway_black-n", 10,7)

    set_stone("st-oneway_black-e", 6 ,3)

 elseif flag[2] == 1 then

    set_stone("st-oneway_black-e", 14,3)

    set_stone("st-oneway_black-n", 10,7)

    set_stone("st-oneway_black-e", 6 ,3)

 elseif flag[2] == 2 then

    set_stone("st-oneway_black-w", 14,3)

    set_stone("st-oneway_black-s", 10,7)

    set_stone("st-oneway_black-e", 6 ,3)

 elseif flag[2] == 3 then

    set_stone("st-oneway_black-w", 14,3)

    set_stone("st-oneway_black-n", 10,7)

    set_stone("st-oneway_black-w", 6 ,3)   

 end

end 



function s3()                               

flag[3] = flag[3] + 1

if flag[3] == 4 then flag[3] = 0 end

if flag[3] == 0 then

    set_stone("st-oneway_black-w", 25,3)

    set_stone("st-oneway_black-n", 19,7)

    set_stone("st-oneway_black-e", 13,3)

 elseif flag[3] == 1 then

    set_stone("st-oneway_black-e", 25,3)

    set_stone("st-oneway_black-n", 19,7)

    set_stone("st-oneway_black-e", 13,3)

 elseif flag[3] == 2 then

    set_stone("st-oneway_black-w", 25,3)

    set_stone("st-oneway_black-s", 19,7)

    set_stone("st-oneway_black-e", 13,3)

 elseif flag[3] == 3 then

    set_stone("st-oneway_black-w", 25,3)

    set_stone("st-oneway_black-n", 19,7)

    set_stone("st-oneway_black-w", 13,3)   

 end

end 



function s4()                               

flag[4] = flag[4] + 1

if flag[4] == 4 then flag[4] = 0 end

if flag[4] == 0 then

    set_stone("st-oneway_black-w", 32,3)

    set_stone("st-oneway_black-n", 28,7)

    set_stone("st-oneway_black-e", 24,3)

 elseif flag[4] == 1 then

    set_stone("st-oneway_black-e", 32,3)   

    set_stone("st-oneway_black-n", 28,7)   

    set_stone("st-oneway_black-e", 24,3)   

 elseif flag[4] == 2 then

    set_stone("st-oneway_black-w", 32,3)

    set_stone("st-oneway_black-s", 28,7)

    set_stone("st-oneway_black-e", 24,3)

 elseif flag[4] == 3 then

    set_stone("st-oneway_black-w", 32,3)

    set_stone("st-oneway_black-n", 28,7)

    set_stone("st-oneway_black-w", 24,3)   

 end

end 



function s5()                               

flag[5] = flag[5] + 1

if flag[5] == 4 then flag[5] = 0 end

if flag[5] == 0 then

    set_stone("st-oneway_black-n", 35,7)

    set_stone("st-oneway_black-e", 31,3)

 elseif flag[5] == 1 then

    set_stone("st-oneway_black-n", 35,7)

    set_stone("st-oneway_black-e", 31,3)

 elseif flag[5] == 2 then

    set_stone("st-oneway_black-s", 35,7)

    set_stone("st-oneway_black-e", 31,3)

 elseif flag[5] == 3 then

    set_stone("st-oneway_black-n", 35,7)

    set_stone("st-oneway_black-w", 31,3)   

 end

end 



function s6()                               

flag[6] = flag[6] + 1

if flag[6] == 4 then flag[6] = 0 end

if flag[6] == 0 then

    set_stone("st-oneway_black-n", 3,6 )

    set_stone("st-oneway_black-w", 7,10)

    set_stone("st-oneway_black-n", 3,14)

 elseif flag[6] == 1 then

    set_stone("st-oneway_black-s", 3,6 )

    set_stone("st-oneway_black-e", 7,10)

    set_stone("st-oneway_black-n", 3,14)

 elseif flag[6] == 2 then

    set_stone("st-oneway_black-s", 3,6 )

    set_stone("st-oneway_black-w", 7,10)

    set_stone("st-oneway_black-s", 3,14)

 elseif flag[6] == 3 then

    set_stone("st-oneway_black-s", 3,6 )

    set_stone("st-oneway_black-w", 7,10)

    set_stone("st-oneway_black-n", 3,14)

 end

end 



function s7()                               

flag[7] = flag[7] + 1

if flag[7] == 4 then flag[7] = 0 end

if flag[7] == 0 then

    set_stone("st-oneway_black-n", 10,6 )

    set_stone("st-oneway_black-w", 14,10)

    set_stone("st-oneway_black-n", 10,14)

    set_stone("st-oneway_black-e",  6,10)

 elseif flag[7] == 1 then

    set_stone("st-oneway_black-s", 10,6 )

    set_stone("st-oneway_black-e", 14,10)

    set_stone("st-oneway_black-n", 10,14)

    set_stone("st-oneway_black-e",  6,10)

 elseif flag[7] == 2 then

    set_stone("st-oneway_black-s", 10,6 )

    set_stone("st-oneway_black-w", 14,10)

    set_stone("st-oneway_black-s", 10,14)

    set_stone("st-oneway_black-e",  6,10)

 elseif flag[7] == 3 then

    set_stone("st-oneway_black-s", 10,6 )

    set_stone("st-oneway_black-w", 14,10)

    set_stone("st-oneway_black-n", 10,14)

    set_stone("st-oneway_black-w",  6,10)   

 end

end 



function s8()                               

flag[8] = flag[8] + 1

if flag[8] == 4 then flag[8] = 0 end

if flag[8] == 0 then

    set_stone("st-oneway_black-n", 19,6 )

    set_stone("st-oneway_black-w", 25,10)

    set_stone("st-oneway_black-n", 19,14)

    set_stone("st-oneway_black-e", 13,10)

 elseif flag[8] == 1 then

    set_stone("st-oneway_black-s", 19,6 )

    set_stone("st-oneway_black-e", 25,10)

    set_stone("st-oneway_black-n", 19,14)

    set_stone("st-oneway_black-e", 13,10)

 elseif flag[8] == 2 then

    set_stone("st-oneway_black-s", 19,6 )

    set_stone("st-oneway_black-w", 25,10)

    set_stone("st-oneway_black-s", 19,14)

    set_stone("st-oneway_black-e", 13,10)

 elseif flag[8] == 3 then

    set_stone("st-oneway_black-s", 19,6 )

    set_stone("st-oneway_black-w", 25,10)

    set_stone("st-oneway_black-n", 19,14)

    set_stone("st-oneway_black-w", 13,10)   

 end

end 



function s9()                               

flag[9] = flag[9] + 1

if flag[9] == 4 then flag[9] = 0 end

if flag[9] == 0 then

    set_stone("st-oneway_black-n", 28, 6)

    set_stone("st-oneway_black-w", 32,10)

    set_stone("st-oneway_black-n", 28,14)

    set_stone("st-oneway_black-e", 24,10)

 elseif flag[9] == 1 then

    set_stone("st-oneway_black-s", 28, 6)

    set_stone("st-oneway_black-e", 32,10)

    set_stone("st-oneway_black-n", 28,14)

    set_stone("st-oneway_black-e", 24,10)

 elseif flag[9] == 2 then

    set_stone("st-oneway_black-s", 28, 6)

    set_stone("st-oneway_black-w", 32,10)

    set_stone("st-oneway_black-s", 28,14)

    set_stone("st-oneway_black-e", 24,10)

 elseif flag[9] == 3 then

    set_stone("st-oneway_black-s", 28, 6)

    set_stone("st-oneway_black-w", 32,10)

    set_stone("st-oneway_black-n", 28,14)

    set_stone("st-oneway_black-w", 24,10)   

 end

end 



function s0()                               

flag[10] = flag[10] + 1

if flag[10] == 4 then flag[10] = 0 end

if flag[10] == 0 then

    set_stone("st-oneway_black-n", 35, 6)

    set_stone("st-oneway_black-n", 35,14)

    set_stone("st-oneway_black-e", 31,10)

 elseif flag[10] == 1 then

    set_stone("st-oneway_black-s", 35, 6)

    set_stone("st-oneway_black-n", 35,14)

    set_stone("st-oneway_black-e", 31,10)

 elseif flag[10] == 2 then

    set_stone("st-oneway_black-s", 35, 6)

    set_stone("st-oneway_black-s", 35,14)

    set_stone("st-oneway_black-e", 31,10)

 elseif flag[10] == 3 then

    set_stone("st-oneway_black-s", 35, 6)

    set_stone("st-oneway_black-n", 35,14)

    set_stone("st-oneway_black-w", 31,10)   

 end

end 



function sA()                               

flag[11] = flag[11] + 1

if flag[11] == 4 then flag[11] = 0 end

if flag[11] == 0 then

    set_stone("st-oneway_black-n",  3,13)

    set_stone("st-oneway_black-w",  7,17)

 elseif flag[11] == 1 then

    set_stone("st-oneway_black-s",  3,13)

    set_stone("st-oneway_black-e",  7,17)

 elseif flag[11] == 2 then

    set_stone("st-oneway_black-s",  3,13)

    set_stone("st-oneway_black-w",  7,17)

 elseif flag[11] == 3 then

    set_stone("st-oneway_black-s",  3,13)

    set_stone("st-oneway_black-w",  7,17)

 end

end 



function sB()                               

flag[12] = flag[12] + 1

if flag[12] == 4 then flag[12] = 0 end

if flag[12] == 0 then

    set_stone("st-oneway_black-n", 10,13)

    set_stone("st-oneway_black-w", 14,17)

    set_stone("st-oneway_black-e",  6,17)

 elseif flag[12] == 1 then

    set_stone("st-oneway_black-s", 10,13)

    set_stone("st-oneway_black-e", 14,17)

    set_stone("st-oneway_black-e",  6,17)

 elseif flag[12] == 2 then

    set_stone("st-oneway_black-s", 10,13)

    set_stone("st-oneway_black-w", 14,17)

    set_stone("st-oneway_black-e",  6,17)

 elseif flag[12] == 3 then

    set_stone("st-oneway_black-s", 10,13)

    set_stone("st-oneway_black-w", 14,17)

    set_stone("st-oneway_black-w",  6,17)   

 end

end 



function sC()                               

flag[13] = flag[13] + 1

if flag[13] == 4 then flag[13] = 0 end

if flag[13] == 0 then

    set_stone("st-oneway_black-n", 19,13)

    set_stone("st-oneway_black-w", 25,17)

    set_stone("st-oneway_black-e", 13,17)

 elseif flag[13] == 1 then

    set_stone("st-oneway_black-s", 19,13)

    set_stone("st-oneway_black-e", 25,17)

    set_stone("st-oneway_black-e", 13,17)

 elseif flag[13] == 2 then

    set_stone("st-oneway_black-s", 19,13)

    set_stone("st-oneway_black-w", 25,17)

    set_stone("st-oneway_black-e", 13,17)

 elseif flag[13] == 3 then

    set_stone("st-oneway_black-s", 19,13)

    set_stone("st-oneway_black-w", 25,17)

    set_stone("st-oneway_black-w", 13,17)   

 end

end 



function sD()                               

flag[14] = flag[14] + 1

if flag[14] == 4 then flag[14] = 0 end

if flag[14] == 0 then

    set_stone("st-oneway_black-n", 28,13)

    set_stone("st-oneway_black-w", 32,17)

    set_stone("st-oneway_black-e", 24,17)

 elseif flag[14] == 1 then

    set_stone("st-oneway_black-s", 28,13)

    set_stone("st-oneway_black-e", 32,17)

    set_stone("st-oneway_black-e", 24,17)

 elseif flag[14] == 2 then

    set_stone("st-oneway_black-s", 28,13)

    set_stone("st-oneway_black-w", 32,17)

    set_stone("st-oneway_black-e", 24,17)

 elseif flag[14] == 3 then

    set_stone("st-oneway_black-s", 28,13)

    set_stone("st-oneway_black-w", 32,17)

    set_stone("st-oneway_black-w", 24,17)   

 end

end 



function sE()                               

flag[15] = flag[15] + 1

if flag[15] == 4 then flag[15] = 0 end

if flag[15] == 0 then

    set_stone("st-oneway_black-n", 35,13)

    set_stone("st-oneway_black-e", 31,17)

 elseif flag[15] == 1 then

    set_stone("st-oneway_black-s", 35,13)

    set_stone("st-oneway_black-e", 31,17)

 elseif flag[15] == 2 then

    set_stone("st-oneway_black-s", 35,13)

    set_stone("st-oneway_black-e", 31,17)

 elseif flag[15] == 3 then        

    set_stone("st-oneway_black-s", 35,13)

    set_stone("st-oneway_black-w", 31,17)   

 end

end 





oxyd_shuffle()












