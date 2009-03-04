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

#include "stones/QuakeStone.hh"
#include "player.hh"
#include "world.hh"
//#include "main.hh"

namespace enigma {
    QuakeStone::QuakeStone() {
    }
    
    std::string QuakeStone::getClass() const {
        return "st_quake";
    }
    
    Value QuakeStone::message(const Message &m) {
        if (m.message == "toggle" || (m.message == "signal" && m.value != 0) ||
                (m.message == "_trigger" && m.value.to_bool())) {
            setState(ACTIVE);
            return Value();
        } else if (m.message == "ignite" || m.message == "_explosion") { 
            setState(BREAKING);
            return Value();
        }
        return Stone::message(m);
    }

    int QuakeStone::maxState() const {
        return BREAKING;
    }
    
    int QuakeStone::externalState() const {
        return (state == ACTIVEBREAKING) ? BREAKING : state;
    }
    
    void QuakeStone::setState(int extState) {
        if (state == extState)
            return;
            
        if ((state == IDLE && extState == 2) || (state == ACTIVEBREAKING && extState == 0)) {
            state = BREAKING;
            if (isDisplayable()) {
                fart();
                sound_event("stonedestroy");
            }
        } else if (state == IDLE && extState == ACTIVE) {
            state = ACTIVE;
            if (isDisplayable())            
                fart();
        } else if (state == ACTIVE && extState == IDLE) {
            state = IDLE;
        } else if (state == ACTIVE && extState == BREAKING) {
            state = ACTIVEBREAKING;
        } else
            return;
        
        if (isDisplayable())
            init_model();
    }
    
    void QuakeStone::init_model() {
        switch (state) {
            case IDLE:     set_model("st_quake"); break;
            case ACTIVEBREAKING:
            case ACTIVE:   set_anim("st_quaking"); break;
            case BREAKING: set_anim("st_quakebreak_anim"); break;
        }
    }
    
    void QuakeStone::processLight(Direction d) {
        setState(BREAKING);
    }

    void QuakeStone::animcb() {
        if (state == ACTIVE || state == ACTIVEBREAKING)
            setState(IDLE);
        else if (state == BREAKING)
            KillStone(get_pos());
    }

    void QuakeStone::actor_hit(const StoneContact &sc) {
        if (player::WieldedItemIs(sc.actor, "it_hammer"))
            setState(BREAKING);
        else
            setState(ACTIVE);
    }
    
    void QuakeStone::fart() {
        Object *ox = GetObjectTemplate("st_oxyd");
        SendMessage(ox, "closeall");
        sound_event("fart");
    }
    
        
    DEF_TRAITSM(QuakeStone, "st_quake", st_quake, MOVABLE_BREAKABLE);
    
    BOOT_REGISTER_START
        BootRegister(new QuakeStone(), "st_quake");
    BOOT_REGISTER_END

} // namespace enigma
