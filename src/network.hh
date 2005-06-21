/*
 * Copyright (C) 2002,2004 Daniel Heck
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
 * 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
 *
 * $Id: network.hh,v 1.2 2004/05/22 13:04:30 dheck Exp $
 */

#ifndef NETWORK_HH
#define NETWORK_HH

#include "px/pxfwd.hh"
#include "SDL_types.h"
#include <iosfwd>

namespace network
{
    using px::Buffer;

    class Socket {
    public:
        virtual ~Socket() {}
        virtual int     send (const void* data, int len) = 0;
        virtual Buffer* recv() = 0;
        virtual int     close() = 0;
    };

    class MemorySocket : public Socket {
    public:
        MemorySocket();
        ~MemorySocket();

        void set_target (MemorySocket* target);
	
        // Socket interface.
        int     send (const void* data, int len);
        Buffer* recv();
        int     close();
    private:
        MemorySocket*   _target;   // the other end of the communication link
        Buffer*         _recvbuf;  // buffer returned by last call to `recv'
        Buffer*         _pendingbuf; // buffer for collecting incoming data
    };

/* -------------------- Functions -------------------- */

    void Init();
}

#endif
