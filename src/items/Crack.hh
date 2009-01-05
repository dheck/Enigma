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
#ifndef CRACKITEM_HH
#define CRACKITEM_HH

#include "items.hh"

//#include "enigma.hh"

namespace enigma {
    /**
     */

    class Crack : public Item {
        CLONEOBJ(Crack);
        DECL_ITEMTRAITS_ARRAY(4, traitsIdx());

    private:
        enum iState {
            INVISIBLE  = -1,       ///< 
            SMALL      =  0,       ///< 
            MEDIUM     =  1,       ///< 
            LARGE      =  2,       ///<
            DISSOLVING =  3        ///<  
        };

    public:
        Crack(int type);
        
        // Object interface
        virtual std::string getClass() const;
        virtual Value message (const Message &m);

        // StateObject interface
        virtual int maxState() const;
        virtual int minState() const;
        virtual void toggleState();
//        virtual void setState(int extState);

        // GridObject interface
        virtual void init_model();
        
        // ModelCallback interface
        virtual void animcb();
        
        // Item interface
        virtual void actor_enter(Actor *a);
        
    private:
        void crack();
        void spread();
        int traitsIdx() const;
    };
   
} // namespace enigma

#endif
