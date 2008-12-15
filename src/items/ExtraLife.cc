/*
 * Copyright (C) 2002,2003,2004 Daniel Heck
 * Copyright (C) 2008 Ronald Lamprecht
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

#include "items/ExtraLife.hh"
//#include "errors.hh"
//#include "main.hh"
//#include "server.hh"
#include "player.hh"
#include "world.hh"

namespace enigma {

    ExtraLife::ExtraLife(bool isNew) : Item() {
        if (isNew) {
            objFlags |= ALL_DIRECTIONS;
        }
    }
    
    std::string ExtraLife::get_inventory_model() {
        if (player::CurrentPlayer()==0)
            return "inv-blackball";
        else
            return "inv-whiteball";
    }

    void ExtraLife::on_creation(GridPos p) {
        if ((objFlags & ALL_DIRECTIONS) == ALL_DIRECTIONS) {
            // a new transformed extralife
            GameTimer.set_alarm(this, 0.2, false);
        } else {
            updateCurrentLightDirs();
            activatePhoto();
        }
        Item::on_creation(p);
    }
    
    void ExtraLife::on_removal(GridPos p) {
        GameTimer.remove_alarm(this);
        objFlags &= ~ALL_DIRECTIONS;
        Item::on_removal(p);
    }
    
    void ExtraLife::lightDirChanged(DirectionBits oldDirs, DirectionBits newDirs) {
        if (added_dirs(oldDirs, newDirs) != 0) {
            sound_event ("itemtransform");
            replace("it_glasses");
        }
    }
    
    void  ExtraLife::setup_successor(Item *newitem) {
        newitem->setState(server::ExtralifeGlasses);
    }
    
    void ExtraLife::alarm() {
            DirectionBits db = updateCurrentLightDirs();
            activatePhoto();        
    }

    DEF_ITEMTRAITS(ExtraLife, "it_extralife", it_extralife);

    BOOT_REGISTER_START
        BootRegister(new ExtraLife(false), "it_extralife");
        BootRegister(new ExtraLife(true), "it_extralife_new");
    BOOT_REGISTER_END

} // namespace enigma
