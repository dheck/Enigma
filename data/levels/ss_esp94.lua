-- A level for Enigma
-- Copyright: 	(C) 2003 Sven Siggelkow
-- License: 	GPL v2.0 or above

-- ESPRIT #94



levelw = 20

levelh = 13



create_world(levelw, levelh)

oxyd_default_flavor = "d"

set_actor("ac-blackball", 9.5,6.5)



fill_floor("fl-samba", 0,0, levelw,levelh)



function renderLine( line, pattern)

    for i=1, strlen(pattern) do

      local c = strsub( pattern, i, i)

      if c ==   "#" then

         set_stone("st-rock1", i-1,line)

      elseif c ==">" then

         set_stone("st-oneway_black-e",i-1,line)

         set_item("it-blocker", i-1,line)   -- to prevent placing a seed

      elseif c =="<" then

         set_stone("st-oneway_black-w",i-1,line)

         set_item("it-blocker", i-1,line)

      elseif c =="x" then

         set_stone("st-rock1_move", i-1,line)

         set_item("it-seed", i-1,line)         

      elseif c =="a" then

         set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="s1"})

      elseif c =="b" then

         set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="s2"})

      elseif c =="c" then

         set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="s3"})

      elseif c =="d" then

         set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="s4"})

      elseif c =="e" then

         set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="s5"})

      elseif c =="f" then

         set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="s6"})

      elseif c =="g" then

         set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="s7"})

      elseif c =="h" then

         set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="s8"})

      elseif c =="i" then

         set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="s9"})

      elseif c =="j" then

         set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="s10"})

      elseif c =="k" then

         set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="s11"})

      elseif c =="l" then

         set_item("it-trigger", i-1,line, {invisible=1,action="callback", target="s12"})

      elseif c =="w" then                                                               

         set_item("it-wormhole",i-1,line, {name="warp",targetx="2.5",targety="3.5",strength=0})

      elseif c=="O" then                                                               

	 oxyd(i-1,line) 

        end

    end  

end

--               01234567890123456789

renderLine(00 , "####################")

renderLine(01 , "#     >      <     #")

renderLine(02 , "O     >      <     O")

renderLine(03 , "# axg >      < dxj #")

renderLine(04 , "#######      #######")  

renderLine(05 , "#     >      <     #")

renderLine(06 , "O     >   w  <     O")

renderLine(07 , "# bxh >      < exk #")

renderLine(08 , "#######      #######")

renderLine(09 , "#     >      <     #")

renderLine(10 , "O     >      <     O")

renderLine(11 , "# cxi >      < fxl #")

renderLine(12 , "####################") 

--               01234567890123456789



function s1() s(1) end

function s2() s(2) end

function s3() s(3) end

function s4() s(4) end

function s5() s(5) end

function s6() s(6) end

function s7() s(7) end

function s8() s(8) end

function s9() s(9) end

function s10() s(10) end

function s11() s(11) end

function s12() s(12) end



local flags = {0,0,0,0,0,0,0,0,0,0,0,0}

x = 2.5

y = 3.5





function s(num)

%flags[num]=1-%flags[num]

status=0

for i=1,12 do

  status = status + %flags[i]*(2^i)

  end

if     status == 0 then

	xalt = x

	yalt = y

	x = 2.5 

	y = 3.5

elseif status == 2 then

	xalt = x

	yalt = y

	x = 2.5 

	y = 7.5

elseif status == 6 then

	xalt = x

	yalt = y

	x = 2.5 

	y = 11.5

elseif status == 14 then

	xalt = x

	yalt = y

	x = 15.5 

	y = 3.5

elseif status == 30 then

	xalt = x

	yalt = y

	x = 15.5 

	y = 7.5

elseif status == 62 then

	xalt = x

	yalt = y

	x = 15.5 

	y = 11.5

elseif status == 126 then

	xalt = x

	yalt = y

	x = 4.5 

	y = 3.5

elseif status == 254 then

	xalt = x

	yalt = y

	x = 4.5 

	y = 7.5

elseif status == 510 then

	xalt = x

	yalt = y

	x = 4.5 

	y = 11.5

elseif status == 1022 then

	xalt = x

	yalt = y

	x = 17.5 

	y = 3.5

elseif status == 2046 then

	xalt = x

	yalt = y

	x = 17.5 

	y = 7.5

elseif status == 4094 then

	xalt = x

	yalt = y

	x = 17.5 

	y = 11.5

elseif status == 8190 then

	xalt = x

	yalt = y

	x = 2.5 

	y = 1.5

	document(2,1,"If you haven't won, you've lost!") 

else

	x=xalt

	y=yalt	

end	

set_attribs(enigma.GetNamedObject("warp"), {targetx=x, targety=y})



end

