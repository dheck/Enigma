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

#include "items/Crack.hh"
#include "errors.hh"
//#include "main.hh"
#include "world.hh"

namespace enigma {

    Crack::Crack(int type, bool isWater) {
        state = type;
        if (isWater)
            objFlags |= OBJBIT_TYP;
    }
    
    std::string Crack::getClass() const {
        return "it_crack";
    }
    
    void Crack::setAttr(const string& key, const Value &val) {
        if (key == "flavor") {
            std::string flavor = val.to_string();
            ASSERT(flavor == "abyss" || flavor == "water", XLevelRuntime, "Crack illegal flavor value");
            if (flavor == "water")
                objFlags |= OBJBIT_TYP;
            else
                objFlags &= ~OBJBIT_TYP;
            if (isDisplayable()) {
                init_model();    // need to redisplay after attribute set
            }
            return;
        }
        Item::setAttr(key, val);
    }
    
    Value Crack::getAttr(const std::string &key) const {
        if (key == "flavor") {
            return objFlags & OBJBIT_TYP ? "water" : "abyss";
        }
        return Item::getAttr(key);
    }

    Value Crack::message(const Message &m) {
        if (m.message == "crack" || m.message == "ignite" ) {
            crack();
            return Value();
        } else if (m.message == "heat" || m.message == "_explosion" || m.message == "_cannonball") {
            sound_event("crack");
            replace("it_debris");
            return true;
        }
        return Item::message(m);
    }
    
    int Crack::maxState() const {
        return DISSOLVING;
    }
    
    int Crack::minState() const {
        return INVISIBLE;
    }
    
    void Crack::toggleState() {
        if (state < DISSOLVING)
            setState(state + 1);
    }
    
    void Crack::init_model() {
        switch (state) {
            case INVISIBLE :
                set_model("invisible"); break;
            case SMALL :
            case MEDIUM :
            case LARGE :
                set_model(ecl::strf("it_crack_%s%d", objFlags & OBJBIT_TYP ? "water" : "abyss", state + 1)); break;
            case DISSOLVING :
                sound_event ("floordestroy");
                set_anim(ecl::strf("it_crack_%s_anim", objFlags & OBJBIT_TYP ? "water" : "abyss"));
        }
    }
    
    void Crack::actor_enter(Actor *a) {
        if (a->is_on_floor()) {
            crack();
            if (state < DISSOLVING) {
                for (Direction d = NORTH; d != NODIR; d = previous(d)) {
                    GridPos p = move(get_pos(), d);
                    if (Floor *fl = GetFloor(p)) {
                        if (fl->is_destructible()) {
                            if (Item *it = GetItem(p)) {
                                if (!(objFlags & OBJBIT_TYP))
                                    SendMessage(it, "crack");
                            } else {
                                double spreading = getDefaultedAttr("spreading", server::CrackSpreading); 
                                if (DoubleRand(0, 0.9999) < spreading) {
                                    Item *it = MakeItem("it_crack_i");
                                    it->setAttr("flavor", getAttr("flavor"));
                                    if (Value v = getAttr("fragility"))
                                        it->setAttr("fragility", v);
                                    if (Value v = getAttr("spreading"))
                                        it->setAttr("spreading", v);
                                    SetItem(p, it);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    void Crack::animcb() {
        GridPos p= get_pos();
        SetFloor(p, MakeFloor(objFlags & OBJBIT_TYP ? "fl_water" :"fl_abyss"));
        KillItem(p);
    }
    
    void Crack::crack() {
        Floor *fl = GetFloor(get_pos());
        if (fl != NULL && fl->is_destructible()) {
            Value v = fl->getAttr("fragility");
            double fragility = getDefaultedAttr("fragility", v ? v : Value(server::Fragility));
            double spreading = getDefaultedAttr("spreading", server::CrackSpreading); 
            if (((state == INVISIBLE) && (DoubleRand(0, 0.9999) < spreading)) || (DoubleRand(0, 0.9999) < fragility)) {
                toggleState();
                sound_event("crack");
            }
        }
    }
        
    int Crack::traitsIdx() const {
        return state < DISSOLVING ? state + 1 : 3;
    }
    
    ItemTraits Crack::traits[4] = {
        {"it_crack_i",  it_crack_i,  itf_static | itf_fireproof | itf_indestructible, 0.0},
        {"it_crack_s",  it_crack_s,  itf_static | itf_fireproof | itf_indestructible, 0.0},
        {"it_crack_m",  it_crack_m,  itf_static | itf_fireproof | itf_indestructible, 0.0},
        {"it_crack_l",  it_crack_l,  itf_static | itf_fireproof | itf_indestructible, 0.0},
    };

    BOOT_REGISTER_START
        BootRegister(new Crack(0),  "it_crack");
        BootRegister(new Crack(-1), "it_crack_i");
        BootRegister(new Crack(0),  "it_crack_s");
        BootRegister(new Crack(0, true),  "it_crack_s_water");
        BootRegister(new Crack(1),  "it_crack_m");
        BootRegister(new Crack(1, true),  "it_crack_m_water");
        BootRegister(new Crack(2),  "it_crack_l");
    BOOT_REGISTER_END

} // namespace enigma
