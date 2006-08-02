/*
 * Copyright (C) 2006 Ronald Lamprecht
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
 */

#include "lev/VolatileIndex.hh"
#include "errors.hh"
#include "main.hh"
#include "options.hh"
#include "oxyd.hh"



namespace enigma { namespace lev {

    int VolatileIndex::levelCount = 0;
    
    VolatileIndex::VolatileIndex(std::string anIndexName, std::string aGroupName,
            const std::vector<string> levelpaths) {
        for (unsigned i=0; i<levelpaths.size(); i++) {
            levelCount++;
            Proxy * aProxy = Proxy::registerLevel(levelpaths[i], "#commandline",
                    ecl::strf("_%d",levelCount), ecl::strf("Level %d", i), "unknown", 0, 0, false, GAMET_ENIGMA,
                    STATUS_UNKNOWN); 
            proxies.push_back(aProxy);
            try {
                aProxy->loadMetadata();
            }
            catch (XLevelLoading &err) {
                Log << "Level load error on '" << levelpaths[i] << "\n";
            }
        }
        indexName = anIndexName;
        indexGroup = aGroupName;
    }
    
    VolatileIndex::~VolatileIndex() {}
    
    void VolatileIndex::appendProxy(Proxy * newLevel) {
        proxies.push_back(newLevel);
    }
    
    void VolatileIndex::clear() {
        proxies.clear();
    }
}} // namespace enigma::lev
