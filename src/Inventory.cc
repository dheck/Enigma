/*
 * Copyright (C) 2006 Daniel Heck
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
#include "Inventory.hh"
#include "items.hh"
#include "ecl_util.hh"
#include <algorithm>

using enigma::Inventory;
using world::Item;

typedef std::vector<Item*> ItemList;

/** The maximum number of items that may be stored in an inventory.
    For compatibility with Oxyd this should be always 12. */
unsigned const Inventory::max_items = 12;


Inventory::Inventory() : m_items()
{}


Inventory::~Inventory() 
{
    clear();
}


size_t Inventory::size() const
{ 
    return m_items.size(); 
}


void Inventory::clear() 
{
    ecl::delete_sequence(m_items.begin(), m_items.end());
    m_items.clear();
}


Item * Inventory::get_item (size_t idx) const 
{
    return idx >= size() ? 0 : m_items[idx];
}


Item * Inventory::yield_item (size_t idx) 
{
    if (idx < size()) {
        Item *it = m_items[idx];
        m_items.erase(m_items.begin()+ idx);
        return it;
    }
    return 0;
}


Item * Inventory::yield_first() 
{
    return yield_item(0);
}


Item * Inventory::remove_item(Item *wanted) 
{
    ItemList::iterator e = m_items.end();
    for (ItemList::iterator i = m_items.begin(); i != e; ++i) {
        if (*i == wanted) {
            m_items.erase(i);
            return wanted;
        }
    }
    return 0;
}


bool Inventory::is_full() const 
{
    ItemHolder *holder = dynamic_cast<ItemHolder*>(get_item(0));
    if (holder)
        return holder->is_full(); 
    return m_items.size() == max_items; 
}


void Inventory::add_item(Item *i) 
{
    ItemHolder *holder = dynamic_cast<ItemHolder*>(get_item(0));
    if (holder && !holder->is_full()) {
        // first item is a bag and not full
        holder->add_item (i);
    }
    else {
        m_items.insert (m_items.begin(), i);
    }
}


void Inventory::rotate_left () 
{
    if (!m_items.empty())
        std::rotate(m_items.begin(), m_items.begin()+1, m_items.end());
}


void Inventory::rotate_right () 
{
    if (!m_items.empty())
        std::rotate(m_items.begin(), m_items.end()-1, m_items.end());
}


int Inventory::find(const std::string& kind, size_t start_idx) const 
{
    size_t size_ = size();
    for (size_t i = start_idx; i<size_; ++i) {
        if (get_item(i)->is_kind(kind))
            return static_cast<int> (i);
    }
    return -1;
}
