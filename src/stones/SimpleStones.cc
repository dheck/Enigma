/*
 * Copyright (C) 2002,2003,2004 Daniel Heck
 * Copyright (C) 2008 Andreas Lochmann
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

#include "stones/SimpleStones.hh"
#include "errors.hh"
//#include "main.hh"
#include "world.hh"

namespace enigma {

/* -------------------- Flash stone -------------------- */

    FlashStone::FlashStone() : Stone ("st_flash") {
    }
    
    std::string FlashStone::getClass() const {
        return "st_flash";
    }
        
    void FlashStone::actor_hit(const StoneContact &sc) {
        if (Actor *other = FindOtherMarble(sc.actor)) {
            other->add_force (distortedVelocity(sc.actor->get_vel(), 20));
        }
    }
    
    BOOT_REGISTER_START
        BootRegister(new FlashStone(), "st_flash");
    BOOT_REGISTER_END

} // namespace enigma

