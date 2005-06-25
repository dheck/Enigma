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
 */
#include "player.hh"
#include "display.hh"
#include "sound.hh"
#include "client.hh"
#include "server.hh"
#include "world.hh"
#include "main.hh"

#include "ecl_util.hh"

#include <algorithm>
#include <iostream>
#include <cassert>

using namespace std;
using namespace enigma::player;

namespace
{
    class PlayerInfo {
    public:
        PlayerInfo();

        string          name;
        Inventory       inventory;
        vector<Actor*>  actors;
        bool            out_of_lives;
        double          dead_dtime; // number of seconds the player is already dead
        bool            inhibit_pickup;
    };

    typedef vector<PlayerInfo> PlayerList;

    struct RespawnInfo {
        RespawnInfo (Actor *a, double t)
        : actor(a), time_left(t)
        {}

        Actor *actor;           // The actor to respawn
        double time_left;       // Time left before respawning
    };


    struct LevelLocalData {
        // Functions
        LevelLocalData() {}

        void respawn_dead_actors(double dtime);
        void resurrect_actor (Actor *a);
        bool remove_extralife (Actor *a);

        // Variables
        vector<RespawnInfo> respawn_list;
    };
}

/* -------------------- Auxiliary functions -------------------- */
namespace
{
    void UpdateInventory (Inventory *inv)
    {
        if (inv == GetInventory (CurrentPlayer())) {
            std::vector<std::string> modelnames;
            for (int i=0; i<inv->size(); ++i) {
                world::Item *it = inv->get_item(i);
                modelnames.push_back(it->get_inventory_model());
            }
            STATUSBAR->set_inventory (modelnames);
        }
    }
}

/* -------------------- PlayerInfo -------------------- */

PlayerInfo::PlayerInfo ()
: name(),
  inventory(),
  actors(),
  out_of_lives(false),
  dead_dtime(0),
  inhibit_pickup(false)
{}

/* -------------------- LevelLocalData -------------------- */


void LevelLocalData::respawn_dead_actors(double dtime) 
{
    for (unsigned i=0; i<respawn_list.size(); ) {
        RespawnInfo &info = respawn_list[i];

        info.time_left -= dtime;
        if (info.time_left < 0) {
            info.actor->respawn();
            respawn_list.erase(respawn_list.begin()+i);
            continue;           // don't increment i
        }
        ++i;
    }
}

void LevelLocalData::resurrect_actor (Actor *a) 
{
    const double RESPAWN_TIME = 1.5;

//    a->find_respawnpos();
    world::SendMessage(a, "resurrect");
    remove_extralife(a);
    respawn_list.push_back(RespawnInfo(a, RESPAWN_TIME));
}

bool LevelLocalData::remove_extralife (Actor *a) 
{
    Inventory *inv = player::GetInventory(a);
    int        idx = inv->find("it-extralife");

    if (idx == -1) // no extralife found
        return false;

    delete inv->yield_item(idx);
    return true;
}


/* -------------------- Local variables -------------------- */

namespace
{
    LevelLocalData leveldat;
    PlayerList     players;     // this currently has always size 2
    unsigned       icurrent_player = 0;
}




/* -------------------- Inventory -------------------- */

unsigned const Inventory::max_items = 12;

Inventory::Inventory() : m_items()
{}

Inventory::~Inventory() {
    clear();
}

void Inventory::clear() {
    ecl::delete_sequence(m_items.begin(), m_items.end());
    m_items.clear();
}

Item * Inventory::get_item(int idx) const {
    return idx >= size() ? 0 : m_items[idx];
}

Item * Inventory::yield_item(int idx) {
    if (0 <= idx && idx < size()) {
        Item *it = m_items[idx];
        m_items.erase(m_items.begin()+ idx);
        redraw();
        return it;
    }
    return 0;
}

Item * Inventory::yield_first() {
    return yield_item(0);
}

Item * Inventory::remove_item(Item *wanted) {
    vector<Item*>::iterator e = m_items.end();
    for (vector<Item*>::iterator i = m_items.begin(); i != e; ++i) {
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
        holder->add_item(i);
    }
    else {
        m_items.insert(m_items.begin(), i);
        redraw();
    }
}

void Inventory::redraw() 
{
    UpdateInventory (this);
}

void Inventory::rotate(int dir) 
{
    if (!m_items.empty()) {
	if (dir==1)
	    std::rotate(m_items.begin(), m_items.begin()+1, m_items.end());
	else
	    std::rotate(m_items.begin(), m_items.end()-1, m_items.end());

        redraw();
    }
}

void Inventory::activate_first() 
{
    if (!m_items.empty()) {
        Item *it = m_items[0];
        Actor *ac = 0;
        GridPos p;
        bool can_drop_item = false;
        if (!players[icurrent_player].actors.empty()) {
            ac = players[icurrent_player].actors[0];
            p = GridPos(ac->get_pos());
            can_drop_item = ac->can_drop_items();
        }

        switch (it->activate(ac, p)) {
        case world::ITEM_DROP:
            // only drop if no item underneath and actor allows it
            if (it->can_drop_at(p) && can_drop_item) {
                remove_item(it);
                redraw();
                it->drop(ac, p);
            }
            break;
        case world::ITEM_KILL:
            remove_item(it);
            redraw();
            break;
        case world::ITEM_KEEP:
            break;
        }
    }
}

int Inventory::find(const string& kind, int start_idx) const 
{
    int size_ = size();
    for (int i = start_idx; i<size_; ++i) {
        if (get_item(i)->is_kind(kind))
            return i;
    }
    return -1;
}


/* -------------------- Functions -------------------- */

void player::NewGame () 
{
    int nplayers = 2;           // Always prepare for two players

    players.clear();
    players.resize(nplayers);

    for (int i=0; i<nplayers; ++i) {
        Inventory *inv = GetInventory(i);

        inv->add_item (world::MakeItem (world::it_extralife));
        inv->add_item (world::MakeItem (world::it_extralife));
    }
}

void player::AddYinYang ()
{
    for (unsigned i=0; i<players.size(); ++i) {
        Inventory *inv = GetInventory (i);
        if (inv->find ("it-yinyang") == -1) 
            inv->add_item (world::MakeItem (world::it_yinyang));
    }
}

void player::LevelLoaded()
{
    if (server::TwoPlayerGame && server::SingleComputerGame)
        AddYinYang();
    Inventory *inv = GetInventory (icurrent_player);
    assert (inv);
    inv->redraw();
}

void player::NewWorld() 
{
    // Clear up the inventories of all players: keep only extra lifes.
    for (unsigned iplayer=0; iplayer<players.size(); ++iplayer)
    {
        Inventory *inv = GetInventory(iplayer);
        int nextralifes=0;
        for (int i=0; i<inv->size(); ++i)
            if (get_id (inv->get_item(i)) == world::it_extralife)
                nextralifes += 1;
        inv->clear();
        for (int i=0; i<nextralifes; ++i)
            inv->add_item (world::MakeItem (world::it_extralife));

        players[iplayer].actors.clear();
    }

    SetCurrentPlayer(0);
    leveldat = LevelLocalData();
}

void player::LevelFinished() 
{
    for (unsigned i=0; i<players.size(); ++i) {
        for (unsigned j=0; j<players[i].actors.size(); ++j) {
            Actor *a = players[i].actors[j];
            world::SendMessage(a, "disappear");
        }
    }
}

Inventory * player::GetInventory (int iplayer) {
    return &players[iplayer].inventory;
}

Inventory * player::GetInventory (Actor *a) {
    if (const Value *v = a->get_attrib("player"))
        return GetInventory(to_int(*v));
    return 0;
}

Item * player::wielded_item (Actor *a) {
    if (player::Inventory *inv = player::GetInventory(a))
        return inv->get_item(0);
    return 0;
}

bool player::wielded_item_is(Actor *a, const string &kind) {
    if (player::Inventory *inv = GetInventory(a))
        if (Item *it = inv->get_item(0))
            return it->is_kind(kind);
    return false;
}


int player::CurrentPlayer() {
    return icurrent_player;
}

bool player::IsCurrentPlayer(Actor *a) {
    return static_cast<int>(icurrent_player) == a->int_attrib("player");
}

void player::SetCurrentPlayer(unsigned iplayer) 
{
    if (iplayer >= players.size())
        Log << ecl::strf("SetCurrentPlayer: no such player %d\n", iplayer);
    else {
        icurrent_player = iplayer;
        UpdateInventory (GetInventory(iplayer));
    }
}

unsigned player::NumberOfRealPlayers() {
    unsigned real_players = 0;

    for (unsigned i=0; i<players.size(); ++i) {
        if (!players[i].actors.empty()) {
            ++real_players;
        }
    }

    return real_players;
}

/*! Sets respawn positions for black or white actors. */
void player::SetRespawnPositions(GridPos pos, bool black) {
    ecl::V2 center = pos.center();

    for (unsigned i=0; i<players.size(); ++i) {
        vector<Actor *> &al = players[i].actors;

        for (unsigned j=0; j<al.size(); ++j) {
            const Value *val = al[j]->get_attrib(black ? "blackball" : "whiteball");
            if (val) {
                al[j]->set_respawnpos(center);
            }
        }
    }
}

/*! Remove respawn positions for black or white actors */
void player::RemoveRespawnPositions(bool black) {
    for (unsigned i=0; i<players.size(); ++i) {
        vector<Actor *> &al = players[i].actors;

        for (unsigned j=0; j<al.size(); ++j) {
            const Value *val = al[j]->get_attrib(black ? "blackball" : "whiteball");
            if (val) {
                al[j]->remove_respawnpos();
            }
        }
    }
}

void player::Suicide() 
{
    for (unsigned i=0; i<players.size(); ++i) {
        vector<Actor *> &al = players[i].actors;
        for (unsigned j=0; j<al.size(); ++j) {
            world::SendMessage(al[j], "suicide");
        }
    }
}

Actor *player::ReplaceActor (unsigned iplayer, Actor *old, Actor *a)
{
    if (iplayer >= players.size())
        server::RaiseError ("Invalid actor number");

    vector<Actor *> &al = players[iplayer].actors;
    for (unsigned i=0; i<al.size(); ++i) {
        if (al[i] == old) {
            al[i] = a;
            return old;
        }
    }
    return 0;
}


void player::AddActor (unsigned iplayer, Actor *a) 
{
    if (iplayer >= players.size())
        server::RaiseError ("Invalid actor number");

    world::ReleaseActor(a);
    players[iplayer].actors.push_back(a);

    if (players[iplayer].actors.size() == 1) {
        // the ``main actor'' was set
        client::Msg_PlayerPosition (iplayer, a->get_pos());
    }
}

void player::SwapPlayers() {
    if (NumberOfRealPlayers() >= 2) {
        SetCurrentPlayer(1-icurrent_player);
    }
}

static bool has_extralive(unsigned pl) {
    return players[pl].inventory.find("it-extralife") != -1;
}

static bool resurrect_actor (unsigned pl, Actor *a) 
{
    assert(server::ConserveLevel); // no resurrection otherwise!

    bool has_life = has_extralive(pl);
    if (has_life)
        leveldat.resurrect_actor(a); // = resurrect with delay
    else
        players[pl].out_of_lives = true;
    return has_life;
}

static void CheckDeadActors() 
{
    bool           toggle_player    = false;
    const unsigned NO_PLAYER        = UINT_MAX;
    unsigned       toggle_to_player = NO_PLAYER;
    bool           new_game         = false; // complete restart (new lives)
    bool           reset_level      = false; // reset items etc.

    if (server::ConserveLevel) {
        // to live means to be not dead and to be able to move
        for (unsigned pl = 0; pl<players.size(); ++pl) {
            vector<Actor*>& actors = players[pl].actors;
            bool                     has_living_actor = false;
            int                      dead_essentials = 0;

            for (size_t i=0; i<actors.size(); ++i) {
                Actor *a = actors[i];

                if (!a->is_dead() || resurrect_actor(pl, a)) {
                    if (a->get_mouseforce() != 0.0)
                        has_living_actor = true;
                }
                else {
                    // player is dead and could not resurrect
                    int essential = a->int_attrib("essential");
                    if (essential>0) {
                        dead_essentials++;
                        if (dead_essentials >= essential)
                            new_game = true;
                    }
                }
            }

            if (has_living_actor) {
                if (toggle_to_player == NO_PLAYER)
                    toggle_to_player = pl;
            }
            else {
                if (pl == icurrent_player)
                    toggle_player = true;
            }
        }

        // if no_living_player -> toggle_player is true and toggle_to_player is NO_PLAYER
        // => new_game is set to true below
    }
    else {                  // ConserveLevel == false
        for (unsigned pl = 0; pl<players.size(); ++pl) {
            vector<Actor*>& actors         = players[pl].actors;
            bool            has_living_actor = false;
            for (size_t i = 0; i<actors.size(); ++i) {
                Actor *a = actors[i];
                if (a->is_dead()) {
                    if (has_extralive(pl)) {
                        leveldat.remove_extralife(a);
                        reset_level = true;
                    }
                    else {
                        players[pl].out_of_lives = true;
                        if (pl == icurrent_player)
                            toggle_player = true;
                    }
                    break;
                }
                else
                    has_living_actor = true;

            }

            if (has_living_actor) {
                if (toggle_to_player == NO_PLAYER)
                    toggle_to_player = pl;
            }
        }
    }

    if (reset_level) {
        server::RestartLevel(); // should restart w/o scrolling
    }
    else if (new_game) {
        server::Msg_RestartGame();
    }
    else if (toggle_player) {
        if (toggle_to_player == NO_PLAYER)
            server::Msg_RestartGame();
        else
            SetCurrentPlayer(toggle_to_player);
    }

}

Actor *player::GetMainActor (unsigned iplayer) 
{
    vector<Actor *> &actors = players[iplayer].actors;
    return actors.empty() ? 0 : actors[0];
}

void player::Tick(double dtime) 
{
    STATUSBAR->set_counter (server::GetMoveCounter());


    // Tell clients about position of main actor for stereo sound and
    // screen position
    for (unsigned iplayer = 0; iplayer < players.size(); ++iplayer) {
        if (Actor *ac = GetMainActor(iplayer))
            client::Msg_PlayerPosition (iplayer, ac->get_pos());
    }

    // Respawn actors that have been dead for a certain amount of time
    leveldat.respawn_dead_actors(dtime);

    // Update the respawn list or restart the game when all actors are
    // dead and no extra lifes are left.
    CheckDeadActors();
}

void player::InhibitPickup(bool flag) {
    players[icurrent_player].inhibit_pickup = flag;
}

/*! Return pointer to inventory if actor may pick up items, 0
   otherwise. */
Inventory *player::MayPickup(Actor *a) 
{
    int iplayer=-1;
    a->int_attrib("player", &iplayer);
    if (iplayer < 0 || (unsigned)iplayer >= players.size()) {
        //        cerr << "PickupItem: illegal 'player' entry\n";
        return 0;
    }

    Inventory *inv = GetInventory(iplayer);
    bool dont_pickup = players[iplayer].inhibit_pickup 
        || a->is_flying()
        || inv->is_full();

    return dont_pickup ? 0 : inv;
}

void player::PickupItem(Actor *a, GridPos p) 
{
    if (Inventory *inv = MayPickup(a)) {
        if (Item *item = world::YieldItem(p)) {
            item->on_pickup(a);
            inv->add_item(item);
            sound::SoundEvent ("pickup", p.center());
        }
    }
}

void player::PickupStoneAsItem (Actor *a, enigma::GridPos p) 
{
    if (Inventory *inv = MayPickup(a)) 
    {
        if (world::Stone *stone = world::YieldStone(p)) 
        {
            string kind = stone->get_kind();
            if (kind[0] == 's') 
                kind[0] = 'i';

            if (Item *item = world::MakeItem(kind.c_str())) {
                world::DisposeObject (stone);
                inv->add_item(item);
                sound::SoundEvent ("pickup", p.center());
            }
        }
    }
}

void player::ActivateItem() {
    Inventory &inv = players[icurrent_player].inventory;
    inv.activate_first();
}

void player::RotateInventory(int dir) 
{
    sound::SoundEvent ("invrotate", ecl::V2());
    Inventory &inv = players[icurrent_player].inventory;
    inv.rotate(dir);
}

