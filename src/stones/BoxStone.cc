/*
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

#include "stones/BoxStone.hh"
#include "errors.hh"
//#include "main.hh"

namespace enigma {
    BoxStone::BoxStone(int subtyp, int initState) : Stone() {
        objFlags |= (subtyp << 25);
        if (subtyp == ROCK)
            objFlags |= OBJBIT_BLOCKFIRE;
        state = initState;
    }
    
    BoxStone* BoxStone::clone() {
        if ((BoxStoneTyp)((objFlags & OBJBIT_SUBTYP) >> 25) == WOOD) { 
             // When st_wood is created it randomly becomes st_wood1 or st_wood2.
             if (IntegerRand(0, 1) == 0)
                return new BoxStone(WOOD1, state);
            else
                return new BoxStone(WOOD2, state);
        } else {
            return new BoxStone(*this);
        }
    }
    
    void BoxStone::dispose() {
        delete this;
    }
    
    std::string BoxStone::getClass() const {
        return "st_box";
    }
    
    const char *BoxStone::get_kind() const {
        BoxStoneTyp typ = (BoxStoneTyp)((objFlags & OBJBIT_SUBTYP) >> 25);
        switch (typ) {
            case WOOD:
                return "st_box_wood";
            case WOOD1:
                return "st_box_wood_h";
            case WOOD2:
                return "st_box_wood_v";
            case HAY:
                return "st_box_hay";
            case ROCK:
                return "st_box_rock";
        }
    }

    Value BoxStone::getAttr(const std::string &key) const {
        if (key == "flavor") {
            BoxStoneTyp typ = (BoxStoneTyp)((objFlags & OBJBIT_SUBTYP) >> 25);
            switch (typ) {
                case WOOD:
                case WOOD1:
                case WOOD2:
                    return "wood";
                case HAY:
                    return "hay";
                case ROCK:
                    return "rock";
            }
        }
        return Stone::getAttr(key);
    }
    

    Value BoxStone::message(const Message &m) {
        if (m.message == "fire" && !(objFlags & OBJBIT_BLOCKFIRE)) {
            KillStone(get_pos());
            return true;  // allow fire to spread
        } else if (m.message == "heat") {
            return (objFlags & OBJBIT_BLOCKFIRE) != 0;  // block fire
        } else if (m.message == "_fall") {
            maybe_fall_or_stopfire();
            return Value();
        }
        return Stone::message(m);
    }

    void BoxStone::setState(int extState) {
        // no external states
    }
    
    void BoxStone::init_model() {
        BoxStoneTyp typ = (BoxStoneTyp)((objFlags & OBJBIT_SUBTYP) >> 25);
        switch (typ) {
            case WOOD:
                ASSERT(false, XLevelRuntime, "Wood stone init model state error");
            case WOOD1:
                if (state == GROWING)
                    set_anim("st-wood-growing");
                else
                    set_model("st-wood1");
                break;
            case WOOD2:
                if (state == GROWING)
                    set_anim("st-wood-growing");
                else
                    set_model("st-wood2");
                break;
            case HAY:
                if (state == GROWING)
                    set_anim("st-wood-growing");
                else
                    set_model("st-flhay"); break;
                break;
            case ROCK:
                set_model("st-flrock"); break;
        }
    }
    
    void BoxStone::animcb() {
        state = IDLE;
        init_model();
        maybe_fall_or_stopfire(); // instantly builds a bridge on fl_swamp etc
    }

    bool BoxStone::allowsSpreading(Direction dir, bool isFlood) const {
        return isFlood;
    }
    
    void BoxStone::actor_hit(const StoneContact &sc) {
        if (state == GROWING)
            SendMessage(sc.actor, "_shatter");
        else
            Stone::actor_hit(sc);
    }
    
    void BoxStone::actor_inside(Actor *a) {
        if (state == GROWING)
            SendMessage(a, "_shatter");
    }
    
    void BoxStone::actor_contact(Actor *a) {
        if (state == GROWING)
            SendMessage(a, "_shatter");
    }
    
    void BoxStone::on_move() {
        // in oxyd1 only fall when moving
        Stone::on_move();
        maybe_fall_or_stopfire(true);
    }
    
    void BoxStone::on_floor_change() {
        // other oxyds versions: fall everytime the floor changes
        maybe_fall_or_stopfire(false, true);
    }
    
    void BoxStone::maybe_fall_or_stopfire(bool onMove, bool onFloorChange) {
        BoxStoneTyp typ = (BoxStoneTyp)((objFlags & OBJBIT_SUBTYP) >> 25);
        GridPos p = get_pos();
        if (server::GameCompatibility != GAMET_ENIGMA && IsLevelBorder(p))
            return;
        if (Floor *oldfl = GetFloor(p)) {
            const std::string &k = oldfl->get_kind();
            if (objFlags & OBJBIT_BLOCKFIRE)
                SendMessage(oldfl, "stopfire");
            if (k == "fl_abyss" || k == "fl_water" || k == "fl_swamp") {
                if (onMove)
                    // just mark - can not kill stone yet - this will be done on floor change event
                    state = FALLING;  // keep the stone from moving any longer
                else if ((server::GameCompatibility != GAMET_OXYD1) || state == FALLING || !onFloorChange) {
                    state = FALLEN;
                    Floor *newfl = MakeFloor((typ == HAY) ? "fl_hay_framed" : ((typ == ROCK) ? "fl_rock_framed" : ((typ == WOOD1) ? "fl_wood_framed_h" : "fl_wood_framed_v")));
                    transferIdentity(newfl);
                    if (k == "fl_water") {
                        newfl->setAttr("interval", oldfl->getAttr("interval"));
                        newfl->setAttr("state", oldfl->getAttr("state"));
                    }
                    SetFloor(p, newfl); 
                    KillStone(p);
                }
            }
        }
    }
    
    int BoxStone::traitsIdx() const {
        return (state == IDLE) ? 0 : 1;
    }

    StoneTraits BoxStone::traits[2] = {
        {"st_box", st_box, stf_none, material_stone, 1.0, MOVABLE_STANDARD},
        {"st_box_wood_growing", st_box_wood_growing, stf_none, material_stone, 1.0, MOVABLE_PERSISTENT},
    };

    BOOT_REGISTER_START
        BootRegister(new BoxStone(0), "st_box");
        BootRegister(new BoxStone(0), "st_box_wood");
        BootRegister(new BoxStone(0, 1), "st_box_wood_growing");
        BootRegister(new BoxStone(1), "st_box_wood_h");
        BootRegister(new BoxStone(2), "st_box_wood_v");
        BootRegister(new BoxStone(3), "st_box_hay");
        BootRegister(new BoxStone(3, 1), "st_box_hay_growing");
        BootRegister(new BoxStone(4), "st_box_rock");
    BOOT_REGISTER_END

} // namespace enigma
