/*
 * Copyright (C) 2004,2005 Daniel Heck
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
#include "server.hh"

#include "actors.hh"
#include "client.hh"
#include "lua.hh"
#include "main.hh"
#include "nls.hh"
#include "options.hh"
#include "player.hh"
#include "player.hh"
#include "world.hh"

#include "enet/enet.h"

#ifdef WIN32
// SendMessage is a Syscall on Windows, so we simply undefine it to use this
// name for one of the methods
#undef SendMessage
#endif

#include <cctype>

using namespace enigma::server;
using namespace world;
using namespace std;

namespace enigma_server
{
    enum ServerState {
        sv_idle,
        sv_waiting_for_clients,
        sv_running,
        sv_paused,
        sv_restart_level,
        sv_finished,
    };

    class Server {
    public:


    private:

        static Server *instance;
    };

    void PrepareLevel();

}




/* -------------------- Global variables -------------------- */

levels::LevelPack   *server::CurrentLevelPack = 0;
unsigned             server::CurrentLevel     = 0;

bool           server::CreatingPreview = false;

bool server::NoCollisions = false;

double   server::LevelTime;
bool     server::ConserveLevel;
bool     server::TwoPlayerGame;
bool     server::SingleComputerGame;
bool     server::AllowTogglePlayer;
bool     server::ShowMoves;
GameType server::GameCompatibility;
double   server::Brittleness;
double   server::SlopeForce;
double   server::FlatForce;
double   server::FrictionFactor;
double   server::IceFriction;
double   server::ElectricForce;
double   server::BumperForce;
double   server::WaterSinkSpeed;
double   server::SwampSinkSpeed;
double   server::MagnetForce;
double   server::MagnetRange;
double   server::WormholeForce;
double   server::WormholeRange;
double   server::HoleForce;


/* -------------------- Local variables -------------------- */

namespace
{
    ServerState        state               = sv_idle;
    double             time_accu           = 0;
    double             current_state_dtime = 0;
    levels::LevelPack *levelpack           = 0;
    int                 move_counter; // counts movements of stones
    ENetAddress        network_address;
    ENetHost           *network_host       = 0;
}

void load_level (size_t ilevel)
{
    if (levelpack) {
        server::PrepareLevel();

        // first set default compatibility mode
        // (may be overidden by load_level (from Lua))
        const levels::LevelInfo &info = levelpack->get_info(ilevel);
        server::GameCompatibility = info.type;
        
        // clear inventory before level load and give us 2 extralives
        player::NewGame();

        try {
            levelpack->load_level (ilevel);
            server::CurrentLevel = static_cast<unsigned> (ilevel);
            game::ResetGameTimer();

            world::InitWorld();
            if (!CreatingPreview) {
                player::LevelLoaded();
                client::Msg_LevelLoaded(ilevel);
            }
        }
        catch (levels::XLevelLoading &err) {
            client::Msg_Error (_("Server Error: could not load level '")
                               + info.filename + "'\n"
                               + err.what());
            state = sv_idle;
        }
    }
    else {
        // XXX server error: no level pack selected
        state = sv_idle;
    }
}

void server::RaiseError (const std::string &msg)
{
    throw levels::XLevelLoading (msg);
}

void gametick(double dtime)
{
    const double timestep = 0.01; // 10ms

    server::LevelTime += dtime;

    time_accu += dtime;
    if (time_accu > 1.0) {
        fprintf (stderr, "Whoa, system overload!\n");
        time_accu = 1.0;
    }
    player::Tick (time_accu);
    for (;time_accu >= timestep; time_accu -= timestep) {
        world::Tick (timestep);
        if (lua::CallFunc (lua::LevelState(), "Tick", timestep, NULL) != 0) {
            throw enigma_levels::XLevelRuntime (string("Calling 'Tick' failed:\n")
                                                + lua::LastError(lua::LevelState()));
        }
    }
    world::TickFinished ();
}


/* -------------------- Functions -------------------- */

void server::Init()
{
}

void server::Shutdown()
{
    lua::ShutdownLevel();
    if (network_host != 0)
        enet_host_destroy (network_host);
}


void server::InitNewGame()
{
    PrepareLevel();
}

bool server::NetworkStart()
{
    return true;
}



void server::PrepareLevel()
{
    state = sv_waiting_for_clients;

    server::NoCollisions = false;

    server::LevelTime         = 0.0;
    server::ConserveLevel     = true;
    server::TwoPlayerGame     = false;
    server::SingleComputerGame= true;
    server::AllowTogglePlayer = true;
    server::ShowMoves         = false;
    server::Brittleness       = 0.5;
    server::SlopeForce        = 25.0;
    server::FlatForce         = 0.0;
    server::FrictionFactor    = 1.0;
    server::IceFriction       = 1.0;
    server::ElectricForce     = 15.0;
    server::BumperForce       = 200.0;
    server::WaterSinkSpeed    = 1000;
    server::SwampSinkSpeed    = 4;
    server::MagnetForce       = 30;
    server::MagnetRange       = 10;
    server::WormholeForce     = 30;
    server::WormholeRange     = 10;
    server::HoleForce         = 1.0;

    move_counter = 0;

    world::PrepareLevel ();
    player::PrepareLevel();

    /* Restart the Lua environment so symbol definitions from
       different levels do not get in each other's way.*/
    lua::ShutdownLevel();
    lua_State *L = lua::InitLevel();
    if (lua::DoSysFile(L, "compat.lua") != lua::NO_LUAERROR) {
        throw levels::XLevelLoading("While processing 'compat.lua':\n"+lua::LastError(L));
    }
    if (lua::DoSysFile(L, "init.lua") != lua::NO_LUAERROR) {
        throw levels::XLevelLoading("While processing 'init.lua':\n"+lua::LastError(L));
    }

}

void server::RestartLevel() 
{
    if (state == sv_running || state == sv_finished) {
        state = sv_restart_level;
        current_state_dtime = 0;
    }
}

void server::Msg_RestartGame() 
{
    if (state == sv_running || state == sv_finished) {
        state = sv_restart_level;
        current_state_dtime = 0;
    }
}

void server::FinishLevel()
{
    if (state == sv_running) {
        state = sv_finished;
        current_state_dtime = 0;
        player::LevelFinished(); // remove player-controlled actors
        client::Msg_Command("level_finished");
    }
    else {
        // XXX server internal error: should only be called while game is running
    }
}


void server::Tick (double dtime) 
{
    switch (state) {
    case sv_idle:
        break;
    case sv_paused:
        break;
    case sv_waiting_for_clients:
        break;
    case sv_running: 
        gametick (dtime);
        break;
    case sv_restart_level:
        current_state_dtime += dtime;
        if (current_state_dtime >= 1.0) {
            load_level(CurrentLevel);
        } else {
            gametick(dtime);
        }
        break;
    case sv_finished:
        current_state_dtime += dtime;
        if (current_state_dtime <= 2.5)
            gametick(dtime);
        else {
            client::Msg_AdvanceLevel (levels::advance_normal);
            state = sv_waiting_for_clients;
        }
        break;
    }
}

void server::Msg_SetLevelPack (const std::string &name)
{
    levelpack = levels::FindLevelPack (name);
    server::CurrentLevelPack = levelpack;
    if (levelpack == 0) {
        // XXX server error: invalid level pack
    }
}

void server::Msg_LoadLevel (size_t ilevel)
{
    load_level(ilevel);
}


void server::Msg_StartGame()
{
    if (state == sv_waiting_for_clients) {
        time_accu = 0;
        state = sv_running;
    }
    else {
        // Warning << "server: Received unexpected StartGame message.\n";
        // XXX discard message if not waiting for it?
    }
}

namespace enigma_server {
    using levels::LevelInfo;

    class GlobalLevelIter {     // iterates repeatedly through ALL levels
        size_t levelnr, packnr;
        size_t levels, packs;

    public:
        GlobalLevelIter(LevelPack *lp, size_t ilevel)
            : levelnr(ilevel),
              packnr(0),
              levels(lp->size()),
              packs(enigma_levels::LevelPacks.size())
        {
            while (packnr<packs && enigma_levels::LevelPacks[packnr] != lp)
                ++packnr;
        }

        GlobalLevelIter& operator++() {
            if (levelnr<(levels-1))
                ++levelnr;
            else {
                levelnr  = 0;
                packnr = (packnr+1)%packs;
                levels = enigma_levels::LevelPacks[packnr]->size();
            }
            return *this;
        }

        LevelPack *getPack() const {
            return enigma_levels::LevelPacks[packnr];
        }
        size_t getLevel() const { return levelnr; }

        const levels::LevelInfo& getInfo() const {
            return getPack()->get_info(getLevel());
        }
    };

    void Msg_Jumpto(LevelPack *lp, size_t ilevel) {
        CurrentLevelPack = lp;
        CurrentLevel = static_cast<unsigned> (ilevel); // XXX

        Msg_SetLevelPack (lp->get_name());
        Msg_LoadLevel (ilevel);

        Msg_Command("restart");
    }

    void Msg_Command_jumpto(const string& dest) {
        // global level jump
        // e.g.:  dest = "7,33" -> jump to level #33 of 7th levelpack
        // note: pack and level counter start at 1 (not at 0)

        size_t comma = dest.find_first_of(',');
        string error;

        if (comma != string::npos) {
            int packnr = atoi(dest.c_str())-1;
            int packs  = static_cast<int> (enigma_levels::LevelPacks.size());
            int ilevel = atoi(dest.c_str()+comma+1)-1;

            if (packnr >= 0 && packnr < packs) {
                LevelPack *lp = enigma_levels::LevelPacks[packnr];

                if (ilevel >= 0 && static_cast<unsigned>(ilevel) < lp->size()) {
                    Msg_Jumpto(lp, ilevel);
                }
                else
                    error = ecl::strf("Illegal level %i (1-%i)", ilevel+1, lp->size());
            }
            else error = ecl::strf("Illegal level pack %i (1-%i)", packnr+1, packs);
        }
        else error = "Syntax: jumpto pack,level";

        if (!error.empty()) client::Msg_ShowText(error, false, 2);
    }

    void Msg_Command_find(const string& text) {
        struct LowerCaseString {
            string low;
            LowerCaseString(const string& s) : low(s) {
                for (string::iterator i = low.begin(); i != low.end(); ++i)
                    *i = tolower(*i);
            }
            bool containedBy(LowerCaseString other) const {
                return other.low.find(low) != string::npos;
            }
        };

        LowerCaseString  lowtext(text);
        GlobalLevelIter  liter(CurrentLevelPack, CurrentLevel);
        const LevelInfo *start = &liter.getInfo();
        ++liter;

        for (const LevelInfo *info = &liter.getInfo();
             info != start;
             info = &(++liter).getInfo())
        {
            if (lowtext.containedBy(info->filename) ||
                lowtext.containedBy(info->name) ||
                lowtext.containedBy(info->author))
            {
                Msg_Jumpto(liter.getPack(), liter.getLevel());
                info = start = 0;
                break;
            }
        }

        if (start)
            client::Msg_ShowText(string("Couldn't find '")+text+'\'', false, 2);
    }
};

void server::Msg_Command (const string &cmd)
{
    // ------------------------------ normal commands
    if (cmd == "invrotate") {
        player::RotateInventory();
    }
    else if (cmd == "suicide") {
        player::Suicide();
    }
    else if (cmd == "restart") {
        player::Suicide();
        server::RestartLevel();
    }
    else if (cmd == "abort") {
        client::Msg_Command(cmd);
    }

    // ------------------------------ cheats
    else if (cmd == "god") {
        SendMessage (player::GetMainActor (player::CurrentPlayer()),
                     "shield");
        client::Msg_Command("cheater");
    }
    else if (cmd == "collision") {
        server::NoCollisions = !server::NoCollisions;
        if (server::NoCollisions)
            client::Msg_ShowText ("collision handling disabled", false, 2);
        else
            client::Msg_ShowText ("collision handling enabled", false, 2);
        client::Msg_Command("cheater");
    }

    // ------------------------------ quick options
    else if (cmd == "easy") {
        if (options::GetInt("Difficulty") == DIFFICULTY_HARD) {
            Level level (server::CurrentLevelPack, server::CurrentLevel);
            if (level.get_info().has_easymode) {
                client::Msg_ShowText("Restarting in easy mode", false, 2);
                options::SetOption("Difficulty", DIFFICULTY_EASY);
                server::Msg_Command("restart");
            }
            else
                client::Msg_ShowText("No easymode available.", false, 2);
        }
        else
            client::Msg_ShowText("Already in easy mode.", false, 2);
    }
    else if (cmd == "noeasy") {
        if (options::GetInt("Difficulty") == DIFFICULTY_EASY) {
            Level level (server::CurrentLevelPack, server::CurrentLevel);
            options::SetOption("Difficulty", DIFFICULTY_HARD);
            if (level.get_info().has_easymode) {
                client::Msg_ShowText("Restarting in normal mode", false, 2);
                server::Msg_Command("restart");
            }
            else {
                client::Msg_ShowText("No difference between easy and normal.", false, 2);
            }
        }
        else
            client::Msg_ShowText("Already in normal mode.", false, 2);
    }
    else if (cmd == "time") {
        if (options::GetBool("TimeHunting") == false) {
            client::Msg_ShowText("Restarting in time-hunt mode", false, 2);
            options::SetOption("TimeHunting", true);
            server::Msg_Command("restart");
        }
        else
            client::Msg_ShowText("Already in time-hunt mode.", false, 2);
    }
    else if (cmd == "notime") {
        if (options::GetBool("TimeHunting")) {
            client::Msg_ShowText("Switched to easy-going mode", false, 2);
            options::SetOption("TimeHunting", false);
            client::Msg_Command("easy_going");
        }
        else
            client::Msg_ShowText("Already in easy-going mode.", false, 2);
    }
    else if (cmd == "info") {
        const LevelInfo &info = CurrentLevelPack->get_info(CurrentLevel);
        string infotext       = 
            ecl::strf("Level #%i of '", CurrentLevel+1) + CurrentLevelPack->get_name()
            + "' (" + info.filename + ".lua)  -  \"" + info.name + "\" by " + info.author
            + ecl::strf(" (rev=%i)", info.revision);

        client::Msg_ShowText(infotext, true);
    }
    else if (cmd.substr(0, 5) == "find ") { // global level-jump
        string args = cmd.substr(5);
        server::Msg_Command_find(args);
    }
    else if (cmd.substr(0, 7) == "jumpto ") { // global level-jump
        string args = cmd.substr(7);
        server::Msg_Command_jumpto(args);
    }
    else if (cmd == "help") {
        client::Msg_ShowText("suicide, restart, abort, easy, noeasy, time, notime, jumpto, find, info", true);
    }
    else if (cmd == "cheats") {
        client::Msg_ShowText("god, collision  -- Be aware: you'll get no medals!", true);
    }

    else {
        enigma::Log << "Warning: Server received unknown command '" << cmd << "'\n";
    }
}


void server::Msg_Pause (bool onoff) {
    if (onoff && state == sv_running)
        state = sv_paused;
    else if (!onoff && state == sv_paused)
        state = sv_running;
}

void server::Msg_Panic (bool onoff) {
    if (onoff && state == sv_running)
        state = sv_idle;
    else if (!onoff && state == sv_idle)
        state = sv_running;
}

void server::Msg_MouseForce (const ecl::V2 &f) {
    world::SetMouseForce (f);
}


void server::SetCompatibility(const char *version) {
    static const char *versionName[GAMET_COUNT+1] = {
        "enigma", // same indices as enum GameType
        "oxyd1",
        "per.oxyd",
        "oxyd.extra",
        "oxyd.magnum",
        0
    };

    GameType type = GAMET_UNKNOWN;
    for (int v = 0; v<GAMET_COUNT; ++v) {
        if (0 == strcmp(version, versionName[v])) {
            type = GameType(v);
            break;
        }
    }

    if (type == GAMET_UNKNOWN) {
        fprintf(stderr, "Invalid compatibility mode '%s' (ignored. using enigma behavior)\n", version);
        fprintf(stderr, "Valid modes:");
        for (int v = 0; v<GAMET_COUNT; ++v)
            fprintf(stderr, " %s", versionName[v]);
        fprintf(stderr, "\n");
        type = GAMET_ENIGMA;
    }

    GameCompatibility = type;
}


enigma::Difficulty server::GetDifficulty()
{
    int i= options::GetInt ("Difficulty");
    if (i == DIFFICULTY_EASY)
        return DIFFICULTY_EASY;
    else
        return DIFFICULTY_HARD;
}

void server::InitMoveCounter() 
{
    move_counter = 0;
}

int server::IncMoveCounter(int increment) 
{
    move_counter += increment; 
    return move_counter;
}

int server::GetMoveCounter() 
{
    return move_counter;
}

void server::Msg_ActivateItem()
{
    player::ActivateFirstItem();
}
