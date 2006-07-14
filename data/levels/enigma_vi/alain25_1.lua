-- Pauli, a meditation level for Enigma
-- Copyright (C) 2006 Alain Busser + Raoul Bourquin
-- Licensed under GPL v2.0 or above 

levelw = 20
levelh = 13

nhol=8

create_world(levelw, levelh)
oxyd_default_flavor = "a"
display.SetFollowMode(display.FOLLOW_SCROLLING)
fill_floor("fl-leaves", 0,0, level_width,level_height)
draw_border("st-rock1")

function renderLine( line, pattern)
	for i=1, strlen(pattern) do
		local c = strsub( pattern, i, i)
		if c =="#" then
			set_item("it-hollow", i-1, line)
		elseif c=="*" then
			set_item("it-trigger",i-1,line,{invisible=1,action="callback",target="mix"})
                        --set_floor("fl-leavesb",i-1,line)
                        circle(i-1,line)
  		elseif c=="z" then
			set_actor("ac-whiteball-small", i-.5,line+.5, {player=0})
		end
	end	
end

function mix()
	for i=0,3 do
		for j=0,2 do
			for k=0,3 do
				enigma.KillItem(5*i+j+1,k+1)
				enigma.KillItem(5*i+j+1,k+8)
			end
		end
	end
	spade()
end

function spade()
	holi[1]=random(4)-1
	holj[1]=random(3)-1
	holk[1]=random(4)-1
	holl[1]=random(2)-1
	for n=2,nhol do
		for m=1,1 do
			ii=random(4)-1
			jj=random(3)-1
			kk=random(4)-1
			ll=random(2)-1
			vazy=1
			for p=1,n do
				if holi[p]==ii and holj[p]==jj and holk[p]==kk and holl[p]==ll then
					vazy=0
				end
				if vazy==0 then
					m=m-1
				end
			end
		end
		holi[n]=ii
		holj[n]=jj
		holk[n]=kk
		holl[n]=ll
	end
	for n=1,nhol do
		set_item("it-hollow",5*holi[n]+holj[n]+1,holk[n]+7*holl[n]+1)
	end
end

--draw the green circles:
function circle(x,y)
 t=random(1,4)
 if t==1 then
  xk=x
  yk=y
 elseif t==2 then
  xk=x-1
  yk=y
 elseif t==3 then
  xk=x-1
  yk=y-1
 elseif t==4 then
  xk=x
  yk=y-1
 end
 
 if difficult then
  set_floor("fl-leavesd1",xk,yk)
  set_floor("fl-leavesd3",xk+1,yk)
  set_floor("fl-leavesd2",xk,yk+1)
  set_floor("fl-leavesd4",xk+1,yk+1)
 else
  set_floor("fl-leavesc4",xk,yk)
  set_floor("fl-leavesc2",xk+1,yk)
  set_floor("fl-leavesc3",xk,yk+1)
  set_floor("fl-leavesc1",xk+1,yk+1)
 end
end

--               01234567890123456789
renderLine(00 , "                    ")
renderLine(01 , "    *    *    *     ")
renderLine(02 , "                    ")
renderLine(03 , "    *    *    *     ")
renderLine(04 , "                    ")  
renderLine(05 , "  *  z  *   *  z  * ")
renderLine(06 , " *  z z       z z   ")
renderLine(07 , "  *  z  *   *  z  * ")
renderLine(08 , "                    ")
renderLine(09 , "     *    *    *    ")
renderLine(10 , "                    ")
renderLine(11 , "     *    *    *    ")
renderLine(12 , "                    ")
--               012345678901234567890

holi={}
holj={}
holk={}
holl={}
mix()
oxyd_shuffle()



