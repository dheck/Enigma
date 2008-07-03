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

#include "stones/ScissorsStone.hh"
//#include "main.hh"

namespace enigma {
    ScissorsStone::ScissorsStone() : Stone () {
    }

    std::string ScissorsStone::getClass() const {
        return "st_scissors";
    }
        
    void ScissorsStone::init_model() {
        set_model("st-scissors");
    }
    
    void ScissorsStone::animcb() {
        set_model("st-scissors");
    }
    
    void ScissorsStone::actor_hit(const StoneContact &sc) {
        sound_event("scissors");
        set_anim("st-scissors-snip");
        if (SendMessage(sc.actor, "disconnect").to_bool())
            performAction(false);
    }

    DEF_TRAITS(ScissorsStone, "st_scissors", st_scissors);
        
    BOOT_REGISTER_START
        BootRegister(new ScissorsStone(), "st_scissors");
    BOOT_REGISTER_END

} // namespace enigma
