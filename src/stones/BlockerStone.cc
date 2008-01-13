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

#include "stones/BlockerStone.hh"
#include "errors.hh"
#include "server.hh"
//#include "main.hh"

namespace enigma {
    
    BlockerStone::BlockerStone(bool solid) : Stone (solid ? "st_blocker" : "st_blocker_new") {
        state = solid ? SOLID : GROWING; 
    }

    Value BlockerStone::message(const Message &m) {
        if (m.message == "_trigger") {
            setIState(SHRINKING);    // same as "open" -- no toggle to avoid race condition of boulders
            return Value();
        }
        return Stone::message(m);
    }
    
    void BlockerStone::toggleState() {
        if (state == SHRINKING) {  // revert shrinking for door like behaviour
            setIState(GROWING);
        }
        else {
            setIState(SHRINKING);
        }
    }
    
    int BlockerStone::externalState() const {
        return 0;   // always closed -- it_blocker is open
    }
    
    void BlockerStone::setState(int extState) {
        if (extState == 1) {    // -> open (shrink)
            setIState(SHRINKING);
        }
        else {          // value == 0 -> close (grow)
            if (state == SHRINKING)
                setIState(GROWING);
        }
    }
    
    void BlockerStone::init_model() {
        switch (state) {
            case SOLID:
                set_model("st-blocker");
                break;
            case SHRINKING:
                set_anim("st-blocker-shrinking");
                break;
            case GROWING:
                set_anim("st-blocker-growing");
                break;
        }
    }

    void BlockerStone::animcb() {
        switch (state) {
            case SHRINKING: {
                Item *it = MakeItem("it_blocker_new");
                SetItem(get_pos(), it);
                transferIdentity(it);
                KillStone(get_pos());
                break;
            }
            case GROWING:
                setIState(SOLID);
                break;
            default :
                ASSERT(false, XLevelRuntime, "BlockerStone: animcb called with inconsistent state");
                break;
        }
    }
    
    StoneResponse BlockerStone::collision_response(const StoneContact &sc) {
        return (server::GameCompatibility == GAMET_PEROXYD && state == GROWING || state == SHRINKING)
                ? STONE_PASS : STONE_REBOUND;
    }

    void BlockerStone::actor_contact(Actor *a) {
        if ((state == GROWING && server::GameCompatibility != GAMET_PEROXYD) ||
                (state == SOLID && server::GameCompatibility == GAMET_PEROXYD)) {
            SendMessage(a, "shatter");
        }
    }
    void BlockerStone::actor_inside(Actor *a) {
        if ((state == GROWING && server::GameCompatibility != GAMET_PEROXYD) ||
                (state == SOLID && server::GameCompatibility == GAMET_PEROXYD)) {
            SendMessage(a, "shatter");
        }
    }
    
    void BlockerStone::setIState(iState newState) {
        if (state != newState) {
            if (state == GROWING && newState == SHRINKING) {
                state = SHRINKING;
                get_model()->reverse();
            }
            else if (state == SHRINKING && newState == GROWING) {
                state = GROWING;
                get_model()->reverse();
            }
            else {
                state = newState;
                init_model();
                if (newState == SOLID) {
                    Object::set_attrib("kind", "st_blocker");
                }
            }
        }
    }
    
    DEF_TRAITSM(BlockerStone, "INVALID", st_INVALID, MOVABLE_BREAKABLE);
    
    BOOT_REGISTER_START
        BootRegister(new BlockerStone(true), "st_blocker");
        BootRegister(new BlockerStone(false), "st_blocker_new");
    BOOT_REGISTER_END

} // namespace enigma
