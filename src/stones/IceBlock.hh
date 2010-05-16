/*
 * Copyright (C) 2009,2010 Ronald Lamprecht
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
#ifndef ICESTONE_HH
#define ICESTONE_HH

#include "stones.hh"
#include "stones_internal.hh"

namespace enigma {

    /** 
     * 
     * 
     */
    class IceBlock : public Stone {
        CLONEOBJ(IceBlock);
        DECL_TRAITS;
        
    private:
        enum iState {
            IDLE,           ///< 
            BREAKING,       ///< 
            MELTING         ///< 
        };
    public:
        IceBlock();

        // Object interface
        virtual std::string getClass() const;
        virtual Value message(const Message &m);
        
        // StateObject interface
        virtual void setState(int extState);

        // GridObject interface
        virtual void init_model();
        
        // ModelCallback interface
        virtual void animcb();
        
        // Stone interface
        virtual bool is_transparent(Direction d) const;
        virtual bool is_removable() const;
        virtual bool is_movable() const;
        virtual bool on_move(const GridPos &origin);
        
    private:
        void setCheckedFloor(const GridPos &p, std::string kind) const;
    };

} // namespace enigma

#endif
