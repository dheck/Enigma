/*
 * Copyright (C) 2002,2003,2004 Daniel Heck
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
 * $Id: oxyd.hh,v 1.10 2004/05/22 13:04:30 dheck Exp $
 */
#ifndef ENIGMA_OXYD_HH
#define ENIGMA_OXYD_HH

#include "oxydlib/OxydVersion.h"

namespace oxyd
{
    void Init();
    void Shutdown();

    bool FoundOxyd (OxydLib::OxydVersion ver);

    /* Toggle used soundset */
    void ChangeSoundset(int sound_set, int default_sound_set);
}

#endif
