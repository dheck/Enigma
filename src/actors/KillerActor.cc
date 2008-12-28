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

#include "actors/KillerActor.hh"
//#include "errors.hh"
//#include "main.hh"
#include "world.hh"

namespace enigma {

/* -------------------- Killer  -------------------- */

    Killer::Killer() : Actor (traits) {
        setAttr("adhesion", Value(2.0));
        setAttr("color", Value(WHITE));
        setAttr("controllers", Value(3));
    }

    std::string Killer::getClass() const {
        return "ac_killer";
    }

    const char *Killer::get_kind() const {
        return "ac_killer";
    }

    bool Killer::is_dead() const {
        return false;
    }

    void Killer::on_collision(Actor *a) {
        SendMessage(a, "_shatter");
    }
    
    ActorTraits Killer::traits = {"ac_killer", ac_killer, 1<<ac_killer, 13.0/64, 0.7};
    
    BOOT_REGISTER_START
        BootRegister(new Killer(), "ac_killer");
    BOOT_REGISTER_END

} // namespace enigma

