/*
 * Copyright (C) 2007 Andreas Lochmann
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

#include "stones/ThiefStone.hh"
#include "errors.hh"
#include "Inventory.hh"
#include "items/GlassesItem.hh"
#include "player.hh"
#include "world.hh"
//#include "main.hh"

namespace enigma {
    ThiefStone::ThiefStone() : Stone(), victimId (0), bag (NULL) {
        
    }
    
    ThiefStone::~ThiefStone() {
        if (bag != NULL)
            delete bag;
    }

    std::string ThiefStone::getClass() const {
        return "st_thief";
    }
    
    Value ThiefStone::message(const Message &m) {
        if (m.message == "signal" && server::GameCompatibility != GAMET_ENIGMA) {
            performAction(!m.value.to_bool());  // inverse signal multiplier
            return Value();
        } else if (m.message == "_capture" && state == IDLE && isDisplayable()) {            
            // add items on grid pos that can be picked up to our bag
            Item * it =  GetItem(get_pos());
            if (it != NULL && !(it->get_traits().flags & itf_static) && bag != NULL) {
                dynamic_cast<ItemHolder *>(bag)->add_item(YieldItem(get_pos()));
            }
            // drop bag if pos is not occupied by a static item
            if (GetItem(get_pos()) == NULL) {
                SetItem(get_pos(), bag);
                bag = NULL;
            }
            state = CAPTURED;
            init_model();
            return true;
        }
        return Stone::message(m);
    }
   
    void ThiefStone::setState(int extState) {
        // block all state writes
    }
    
    void ThiefStone::init_model() {
        switch (state) {
            case IDLE:
                set_model("st_thief"); 
                break;
            case EMERGING:
                set_anim("st_thief_emerge");
                break;
            case RETREATING:
                set_anim("st_thief_retreat");
                break;
            case CAPTURED:
                set_anim("st_thief_captured");
                break;
        }
    }
    
    void ThiefStone::animcb() {
        switch (state) {
            case EMERGING:
                doSteal();
                state = RETREATING;
                init_model();
                break;
            case RETREATING:
                state = IDLE;
                init_model();
                break;
            case CAPTURED:
                KillStone(get_pos());
                break;
            default:
                ASSERT(0, XLevelRuntime, "ThiefStone: animcb called with inconsistent state");
        }
    }

    const char *ThiefStone::collision_sound() {
        return "cloth";
    }
    
    void ThiefStone::actor_touch(const StoneContact &sc) {
        actor_hit(sc);   // even a slight touch should steal from the actor:
    }
    
    void ThiefStone::actor_hit(const StoneContact &sc) {
        if (state == IDLE) {
            state = EMERGING;
            victimId = sc.actor->getId();
            init_model();
        }
    }

    void ThiefStone::doSteal() {
        // the actor that hit the thief may no longer exist!
        if (Actor *victim = dynamic_cast<Actor *>(Object::getObject(victimId))) {
            if (Value owner = victim->getAttr("owner")) {
                if (!(victim->has_shield())) {
                    enigma::Inventory *inv = player::GetInventory(owner);
                    if (inv && inv->size() > 0) {
                        if (bag == NULL) {
                            bag = MakeItem("it-bag");
                            bag->setOwnerPos(get_pos());
                        }
                        int i = IntegerRand(0, int (inv->size()-1));
                        dynamic_cast<ItemHolder *>(bag)->add_item(inv->yield_item(i));
                        Glasses::updateGlasses();
                        player::RedrawInventory(inv);
                        sound_event("thief");
                    }
                }
            }
        }
    }
    
    DEF_TRAITSM(ThiefStone, "st_thief", st_thief, MOVABLE_BREAKABLE);
    
    BOOT_REGISTER_START
        BootRegister(new ThiefStone(), "st_thief");
    BOOT_REGISTER_END

} // namespace enigma
