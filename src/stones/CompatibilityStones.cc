/*
 * Copyright (C) 2002,2003,2004 Daniel Heck
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *  
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 *
 */

#include "stones/CompatibilityStones.hh"
#include "errors.hh"
//#include "main.hh"

namespace enigma {

/* -------------------- Oxyd compatibility stones -------------------- */

    /* I have no idea what these stones are _really_ supposed to do;
       they seemingly do not appear in the landscape and they create
       normal floor tiles on creation.  Other than that... who
       knows... */

    Peroxyd_0xb8::Peroxyd_0xb8() {
    }

    void Peroxyd_0xb8::on_creation (GridPos p) {
        SetFloor(p, MakeFloor("fl_metal_7n"));
        KillStone(p);
    }

    DEF_TRAITSM(Peroxyd_0xb8, "st-peroxyd-0xb8", st_peroxyd_0xb8, MOVABLE_BREAKABLE);


    Peroxyd_0xb9::Peroxyd_0xb9() {
    }

    void Peroxyd_0xb9::on_creation (GridPos p) {
        SetFloor(p, MakeFloor("fl_metal_7n"));
        KillStone(p);
    }

    DEF_TRAITSM(Peroxyd_0xb9, "st-peroxyd-0xb9", st_peroxyd_0xb9, MOVABLE_BREAKABLE);

  
    Oxyd_0x18::Oxyd_0x18() {
    }
        
    void Oxyd_0x18::on_creation (GridPos p) {
        KillStone(p);
    }

    DEF_TRAITSM(Oxyd_0x18, "st-oxyd-0x18", st_oxyd_0x18, MOVABLE_BREAKABLE);
    
    BOOT_REGISTER_START
        BootRegister(new Peroxyd_0xb8(), "st-peroxyd-0xb8");
        BootRegister(new Peroxyd_0xb9(), "st-peroxyd-0xb9");
        BootRegister(new Oxyd_0x18(), "st-oxyd-0x18");
    BOOT_REGISTER_END

} // namespace enigma

