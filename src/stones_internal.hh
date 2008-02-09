/*
 * Copyright (C) 2002,2003,2004 Daniel Heck
 *
 * This program is free software; you can redistribute it and/ or
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
#ifndef STONES_INTERNAL_HH_INCLUDED
#define STONES_INTERNAL_HH_INCLUDED

#include "world.hh"

#define DECL_TRAITS                                              \
        static StoneTraits traits;                               \
        const StoneTraits &get_traits() const { return traits; }

#define DECL_TRAITS_ARRAY(n, subtype_expr)                                      \
        static StoneTraits traits[n];                                            \
        const StoneTraits &get_traits() const { return traits[subtype_expr]; }

#define DEF_TRAITS(classname, name, id)         \
    StoneTraits classname::traits = { name, id, stf_none, material_stone, 1.0, MOVABLE_PERSISTENT }

#define DEF_TRAITSM(classname, name, id, movable)         \
    StoneTraits classname::traits = { name, id, stf_none, material_stone, 1.0, movable }



namespace enigma {

    void Init_simple();
    void Init_complex();


/* -------------------- Auxiliary Functions -------------------- */

    Direction get_push_direction (const StoneContact &sc);

    /* Move a stone (by sending an impulse) Called when actor hits a
       stone. */
    bool maybe_push_stone (const StoneContact &sc);

/* -------------------- YieldedGridStone -------------------- */

    // allows to completely remove a Stone and its model
    // for a short time
    //
    // - "delays" animation
    //
    // @@@ FIXME: alarms have to be disabled as well

    class YieldedGridStone {
        Stone   *stone;
        display::Model *model;

        YieldedGridStone(const YieldedGridStone&);
        YieldedGridStone& operator = (const YieldedGridStone&);
    public:

        YieldedGridStone(Stone *st);
        ~YieldedGridStone();

        void set_stone(enigma::GridPos pos);
        void dispose();
    };

/* -------------------- OnOffStone -------------------- */

    /*! Base class for all stones that can be on and off.  Understands
      the messages "on", "off", and "onoff".  Whenever the "on"
      attribute changes, the object's init_model() method is invoked */
    class OnOffStone : public Stone {
    protected:
        OnOffStone(const char *kind) 
        : Stone (kind) 
        { 
            setAttr("on", 0.0); 
        }

        bool is_on() const { 
            return getAttr("on") == 1; 
        }

        virtual void set_on(bool newon) {
            if (newon != is_on()) {
                setAttr("on", enigma::Value(newon));
                init_model();
                notify_onoff(newon);
            }
        }

        virtual void notify_onoff(bool /*on*/) {}

        virtual Value message(const Message &m)
        {
            const std::string &msg = m.message;
            if (m.message == "onoff") {
                set_on(!is_on());
                return Value(); 
            } else if (m.message == "signal") {
                set_on (to_int(m.value) != 0);
                return Value(); 
            } else if (m.message == "on") {
                set_on(true);
                return Value(); 
            } else if (m.message == "off") {
                set_on(false);
                return Value();
            }
            return Object::message(m); 
        }
    };

} // namespace enigma

#endif
