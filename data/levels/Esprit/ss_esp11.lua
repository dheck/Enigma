-- A level for Enigma
-- Copyright: 	(C) 2003 Sven Siggelkow
-- License: 	GPL v2.0 or above
-- ESPRIT #011

levelw = 20
levelh = 109
create_world(levelw, levelh)
enigma.SlopeForce = 70
oxyd_default_flavor = "b"       -- Default flavor for oxyd stones.

set_actor("ac-blackball", 10.5,6.5, {player=0})

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
      local c = strsub( pattern, i, i)
      if c ==   "W" then
         set_stone("st-greenbrown",i-1,line)
      elseif c=="h" then
         set_stone("st-greenbrown_hole",i-1,line)
         set_floor("fl-normal",  i-1,  line) 
      elseif c=="g" then
	 set_stone("st-grate2",  i-1,  line)
	 set_floor("fl-gradient",  i-1,  line, {type=19})         
      elseif c=="G" then
	 set_stone("st-grate2",  i-1,  line)
	 set_floor("fl-gradient",  i-1,  line, {type=20})  
      elseif c=="r" then                                 
	 set_stone("st-grate2",  i-1,  line)             
	 set_floor("fl-gradient",  i-1,  line, {type=13})
      elseif c=="R" then                                 
	 set_stone("st-grate2",  i-1,  line)             
	 set_floor("fl-gradient",  i-1,  line, {type=14})
      elseif c=="s" then                                 
	 set_stone("st-grate2",  i-1,  line)             
	 set_floor("fl-gradient",  i-1,  line, {type=5})
      elseif c=="S" then                                 
	 set_stone("st-grate2",  i-1,  line)             
	 set_floor("fl-gradient",  i-1,  line, {type=8})
      elseif c=="t" then                                 
	 set_stone("st-grate2",  i-1,  line)             
	 set_floor("fl-gradient",  i-1,  line, {type=9})
      elseif c=="T" then                                 
	 set_stone("st-grate2",  i-1,  line)             
	 set_floor("fl-gradient",  i-1,  line, {type=12})	 
      elseif c=="D" then
         set_stone("st-death",i-1,line)
      elseif c=="1" then
	 set_floor("fl-gradient",  i-1,  line, {type=19})         
      elseif c=="2" then
	 set_floor("fl-gradient",  i-1,  line, {type=20})   
      elseif c=="3" then
	 set_floor("fl-gradient",  i-1,  line, {type=13})   
      elseif c=="4" then
	 set_floor("fl-gradient",  i-1,  line, {type=14})         
      elseif c=="5" then
         set_floor("fl-gradient",  i-1,  line, {type=5})   
      elseif c=="6" then
         set_floor("fl-gradient",  i-1,  line, {type=6})   	
      elseif c=="7" then
         set_floor("fl-gradient",  i-1,  line, {type=7})         
      elseif c=="8" then
         set_floor("fl-gradient",  i-1,  line, {type=8})   
      elseif c=="9" then                                 
         set_floor("fl-gradient",  i-1,  line, {type=15}) 
      elseif c=="0" then                                 
         set_floor("fl-gradient",  i-1,  line, {type=16}) 
      elseif c=="a" then
         set_floor("fl-gradient",  i-1,  line, {type=12})   
      elseif c=="b" then
         set_floor("fl-gradient",  i-1,  line, {type=10})         
      elseif c=="c" then
         set_floor("fl-gradient",  i-1,  line, {type=11})   
      elseif c=="d" then
         set_floor("fl-gradient",  i-1,  line, {type=9})   		 	 	 
      elseif c=="O" then
	 oxyd(i-1,line)
      elseif c==" " then
	 set_floor("fl-normal",   i-1,  line) 
      elseif c=="." then
	 set_floor("fl-abyss",   i-1,  line) 	 
      elseif c=="x" then                    
	 set_floor("fl-woven",   i-1,  line)
      elseif c=="X" then    
         set_item("it-crack1", i-1,  line)           
	 set_floor("fl-woven",   i-1,  line)
      elseif c=="Y" then       
         set_item("it-crack2", i-1,  line)           
	 set_floor("fl-woven",   i-1,  line)	 
      elseif c=="Z" then     
         set_item("it-crack3", i-1,  line)             
	 set_floor("fl-woven",   i-1,  line)	 
        end
    end  
end
--               01234567890123456789
renderLine(00 , "WWWWWWWWWWWWWWWWWWWW")
renderLine(01 , "W                  W")
renderLine(02 , "W        O         W")
renderLine(03 , "W                  W")
renderLine(04 , "W    O        O    W")  
renderLine(05 , "W                  W")
renderLine(06 , "W                  W")
renderLine(07 , "W                  W")
renderLine(08 , "W                  W")
renderLine(09 , "W     O      O     W")
renderLine(10 , "W                  W")
renderLine(11 , "W                  W")
renderLine(12 , "WWWWWWWWWhhWWWWWWWWW")
renderLine(13 , "xxxxxxxxW12Wxxxxxxxx")
renderLine(14 , "xxxxxxxxW12Wxxxxxxxx")
renderLine(15 , "xxxxxxxxW12Wxxxxxxxx")
renderLine(16 , "xxxxxxxxW12Wxxxxxxxx")
renderLine(17 , "xxxxxxxxW12Wxxxxxxxx")
renderLine(18 , "xxxxxxxxW12Wxxxxxxxx")
renderLine(19 , "xxxxZxxxW12Wxxxxxxxx")
renderLine(20 , "xxxxxxxxW12Wxxxxxxxx")
renderLine(21 , "xxxxxxxxW12Wxxxxxxxx")
renderLine(22 , "xXxYxZxYW12WxxZxXZxX")
renderLine(23 , "........W12W........")
renderLine(24 , "........W12W........")
renderLine(25 , "........W12W........")
renderLine(26 , "........W12W........")
renderLine(27 , "........W12W........")
renderLine(28 , "........W12W........")
renderLine(29 , "........W12W........")
renderLine(30 , "........W12W........")
renderLine(31 , "........W12W........")
renderLine(32 , "........W12W........")
renderLine(33 , "........W12W........")
renderLine(34 , "........W12W........")
renderLine(35 , "........W12W........")
renderLine(36 , "........WgGW........")
renderLine(37 , "........WgGW........")
renderLine(38 , "........WgGW........")
renderLine(39 , "........WgGW........")
renderLine(40 , "........WgGW........")
renderLine(41 , "WWWWWWWWWgGW........")
renderLine(42 , "WsrrrrrrrtGW........")
renderLine(43 , "WgTRRRRRRRSW........")
renderLine(44 , "WgGWWWWWWWWW........")
renderLine(45 , "WgGW................")
renderLine(46 , "W12W................")
renderLine(47 , "W12W................")
renderLine(48 , "W12WWWWWWWWWWWWWWWWW")
renderLine(49 , "W1c9999999999999996W")
renderLine(50 , "W7000000000000000b2W")
renderLine(51 , "WWWWWWWWWWWWWWWWW12W")
renderLine(52 , "................W12W")
renderLine(53 , "................W12W")
renderLine(54 , "................W12W")
renderLine(55 , "................W12W")
renderLine(56 , "................W12W")
renderLine(57 , "................W12W")
renderLine(58 , "................W12W")
renderLine(59 , "................W12W")
renderLine(60 , "................W12W")
renderLine(61 , "................W12W")
renderLine(62 , "................W12W")
renderLine(63 , "................W12W")
renderLine(64 , "................W12W")
renderLine(65 , "WWWWWWWWWWWWWWWWW12W")
renderLine(66 , "W5333333333333333d2W")
renderLine(67 , "W1a4444444444444448W")
renderLine(68 , "W12WWWWWWWWWWWWWWWWW")
renderLine(69 , "W12W................")
renderLine(70 , "W12W................")
renderLine(71 , "W12W................")
renderLine(72 , "W12W................")
renderLine(73 , "W12W................")
renderLine(74 , "W12W................")
renderLine(75 , "W12W................")
renderLine(76 , "W12W................")
renderLine(77 , "W12W................")
renderLine(78 , "W12W................")
renderLine(79 , "W12W................")
renderLine(80 , "W12W................")
renderLine(81 , "W12W................")
renderLine(82 , "W12W................")
renderLine(83 , "W12W................")
renderLine(84 , "W12W................")

renderLine(85 , "W12W................")
renderLine(86 , "W12W................")
renderLine(87 , "W12W................")
renderLine(88 , "W12W................")
renderLine(89 , "W12W................")
renderLine(90 , "W12W................")
renderLine(91 , "W12W................")
renderLine(92 , "W12W................")
renderLine(93 , "W12W................")
renderLine(94 , "W12W................")
renderLine(95 , "W12W................")
renderLine(96 , "W12WWWWWWWWWWWWWWWWW")
renderLine(97 , "W12W               W")
renderLine(98 , "W12W               W")
renderLine(99 , "W12W               W")
renderLine(100, "W12W               W")
renderLine(101, "W12W               W")
renderLine(102, "W12W           O   W")
renderLine(103, "W12W               W")
renderLine(104, "W12                W")
renderLine(105, "W12                W")
renderLine(106, "W12W               W")
renderLine(107, "W12W               W")
renderLine(108, "WDDWWWWWWWWWWWWWWWWW")
--               01234567890123456789
oxyd_shuffle()
