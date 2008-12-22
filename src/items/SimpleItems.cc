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

#include "items/SimpleItems.hh"
//#include "errors.hh"
//#include "main.hh"
//#include "player.hh"
#include "world.hh"

namespace enigma {

/* -------------------- Banana -------------------- */

    Banana::Banana() {
    }
    
    void Banana::processLight(Direction d) {
        sound_event("itemtransform");
        transform("it_cherry");
    }

    void Banana::on_stonehit(Stone *) {
        transform("it_squashed");
    }

    DEF_ITEMTRAITS(Banana, "it_banana", it_banana);


/* -------------------- Brush -------------------- */
   
    Brush::Brush() {
    }
    
    ItemAction Brush::activate(Actor *a, GridPos p) {
        if (Item *it = GetItem(p))
            SendMessage (it, "_brush");
        return ITEM_DROP;
    }
    
    DEF_ITEMTRAITSF(Brush, "it_brush", it_brush, itf_inflammable);

/* -------------------- Cherry -------------------- */

    Cherry::Cherry() {
    }
    
    ItemAction Cherry::activate(Actor *actor, GridPos p) {
        SendMessage(actor, "_invisibility");
        return ITEM_KILL;
    }

    void Cherry::on_stonehit(Stone *) {
        transform("it_squashed");
    }

    DEF_ITEMTRAITS(Cherry, "it_cherry", it_cherry);

/* -------------------- Death Item  -------------------- */
    
    DeathItem::DeathItem() {
    }
    
    void DeathItem::animcb() { 
        set_model("it_death"); 
        state = 0;
     }

    bool DeathItem::actor_hit(Actor *a) {
        ActorInfo &ai = * a->get_actorinfo();
        if (!ai.grabbed) {
            SendMessage(a, "_shatter");
            if (state == 0) {
                state = 1;
                set_anim("it_death_anim");
            }
        }
        return false;
    }
    
    DEF_ITEMTRAITSF(DeathItem, "it_death", it_death, itf_static | itf_indestructible);

/* -------------------- Squashed Cherry -------------------- */

    Squashed::Squashed() {
    }
    
    Value Squashed::message (const Message &m) {
        if (enigma_server::GameCompatibility == GAMET_ENIGMA) {
            if (m.message == "_brush") {
                KillItem(this->get_pos());
                return Value();
            }
        }
        return Item::message(m);
    }

    DEF_ITEMTRAITSF(Squashed, "it_squashed", it_squashed, itf_static);


    BOOT_REGISTER_START
        BootRegister(new Banana(), "it_banana");
        BootRegister(new Brush(), "it_brush");
        BootRegister(new Cherry(), "it_cherry");
        BootRegister(new DeathItem(), "it_death");
        BootRegister(new Floppy(), "it_floppy");
        BootRegister(new MagicWand(), "it_magicwand");
        BootRegister(new Key(), "it_key");
        BootRegister(new Squashed(), "it_squashed");
        BootRegister(new Wrench(), "it_wrench");
    BOOT_REGISTER_END

} // namespace enigma
