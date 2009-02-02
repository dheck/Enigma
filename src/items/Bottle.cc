/*
 * Copyright (C) 2002,2003,2004 Daniel Heck
 * Copyright (C) 2009 Ronald Lamprecht
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

#include "items/Bottle.hh"
//#include "errors.hh"
//#include "main.hh"
#include "world.hh"

namespace enigma {

    Bottle::Bottle(int initState) : Item() {
        state = initState;
    }

    std::string Bottle::getClass() const {
        return "it_bottle";
    }
    
    Value Bottle::message(const Message &m) {
        if (state == BROKEN && m.message == "_brush" && enigma_server::GameCompatibility == GAMET_ENIGMA) {
            if (isDisplayable()) {
                KillItem(this->get_pos());
                return Value();
            }
        }
        return Item::message(m);
    }
    
    void Bottle::on_stonehit(Stone *) {
        if (state == IDLE) {
            sound_event("shatter");
            state = BROKEN;
            init_model();
        }
    }
    
    bool Bottle::actor_hit(Actor *a) {
        if (state == BROKEN) {
            ActorInfo &ai = * a->get_actorinfo();
            if (!ai.grabbed && a->is_on_floor()) {
                SendMessage(a, "_shatter");
            }
            return false;
        } else
            return Item::actor_hit(a);
    }
    
    ItemAction Bottle::activate(Actor *a, GridPos) {
        if (state == IDLE) {
            SendMessage(a, "_booze");
        }
        return ITEM_DROP;
    }
    
    int Bottle::traitsIdx() const {
        return state;
    }

    ItemTraits Bottle::traits[2] = {
        {"it_bottle_idle",  it_bottle_idle, itf_none, 0.0},
        {"it_bottle_broken",  it_bottle_idle, itf_static | itf_indestructible, 0.0},
    };

    BOOT_REGISTER_START
        BootRegister(new Bottle(0), "it_bottle");
        BootRegister(new Bottle(0), "it_bottle_idle");
        BootRegister(new Bottle(1), "it_bottle_broken");
    BOOT_REGISTER_END

} // namespace enigma
