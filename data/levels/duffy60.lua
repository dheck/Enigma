-- Copyright (c) 2003 Jacob Scott
-- License: GPL v2.0 or above
-- Enigma Level: Automatic Transmission

levelw=20
levelh=13

create_world( levelw, levelh)

fill_floor("fl-leaves", 0,0,levelw,levelh)

function renderLine( line, pattern)
    for i=1, strlen(pattern) do
        local c = strsub( pattern, i, i)
        if c =="#" then
            set_stone( "st-greenbrown", i-1, line)
        elseif c == "o" then
            oxyd( i-1, line)
        elseif c == "&" then
            set_floor("fl-water",i-1,line)
            oxyd( i-1, line)
        elseif c == "*" then
            set_stone( "st-brownie", i-1, line)
        elseif c == "%" then
            set_stone( "st-block", i-1, line)
        elseif c == "!" then
            abyss(i-1,line)
        elseif c == "~" then
            set_floor("fl-water",i-1,line)
        elseif c=="z" then
            set_actor("ac-blackball", i-1,line+.5)
        elseif c == "g" then
            draw_stones("st-grate1",{i-1,line}, {1,1}, 1)
        elseif c=="+" then
            set_stone( "st-wood", i-1, line)
        elseif c=="=" then
            set_floor("fl-space",i-1,line)
        elseif c=="L" then
            set_stone( "st-rotator-right", i-1, line)
        elseif c=="R" then
            set_stone( "st-rotator-left", i-1, line)
        elseif c=="l" then
            set_stone( "st-rotator_move-right", i-1, line)
        elseif c=="r" then
            set_stone( "st-rotator_move-left", i-1, line)
        elseif c=="$" then
            set_stone( "st-rotator-left", i-1, line)
            abyss(i-1,line)
        elseif c=="B" then
            set_stone( "st-blocker", i-1, line)
        elseif c=="I" then
            set_item("it-wrench",i-1,line)
        elseif c == "N" then
            set_stone("st-bolder-n", i-1,line)
        elseif c == "E" then
            set_stone("st-bolder-e", i-1,line)
        elseif c == "S" then
            set_stone("st-bolder-s", i-1,line)
        elseif c == "W" then
            set_stone("st-bolder-w", i-1,line)
        elseif c == "@" then
            document(i-1,line,"The block near the top-left can move.")
        end
    end	
end

renderLine(00,"!o!!!!!!!!!!!$!!!!!!")
renderLine(01,"! BBr             @!")
renderLine(02,"!!!!    R        R !")
renderLine(03,"!R    R ~~~        !")
renderLine(04,"!       ~&~       R!")
renderLine(05,"!       ~~~     R  !")
renderLine(06,"! R       z        $")
renderLine(07,"$             R  ! !")
renderLine(08,"!      R  !       L!")
renderLine(09,"!            R   %W!")
renderLine(10,"!  Rv           %~ !")
renderLine(11,"!I          R  RN !!")
renderLine(12,"!!!!!!!!!!!!!!!!!$!!")
