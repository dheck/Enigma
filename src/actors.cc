/*
 * Copyright (C) 2002,2003,2004,2005 Daniel Heck
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

#include "errors.hh"
#include "enigma.hh"
#include "player.hh"
#include "SoundEffectManager.hh"
#include "server.hh"
#include "world.hh"
//#include "main.hh"

#include <iostream>
#include <set>

using namespace std;
using namespace enigma;
//using namespace world;
using ecl::V2;

#include "actors_internal.hh"

namespace enigma {

const double Actor::max_radius = 24.0/64;


/* -------------------- ActorsInRangeIterator -------------------- */

ActorsInRangeIterator::ActorsInRangeIterator(Actor *center, double range, 
        unsigned type_mask) : centerActor (center), previousActor (center),
        dir (WEST), rangeDist (range), typeMask (type_mask) {
    xCenter = center->m_actorinfo.pos[0];
}

Actor * ActorsInRangeIterator::next() {
    bool ready = false;
    while(!ready) {
        if (previousActor != NULL) {
            if (dir == WEST) {
                previousActor = previousActor->left;
            } else {
                previousActor = previousActor->right;
            }
        }
        if (dir == WEST && (previousActor == NULL 
                || xCenter - previousActor->m_actorinfo.pos[0] > rangeDist)) {
            previousActor = centerActor->right;
            dir = EAST;
        }
        if (dir == EAST && (previousActor == NULL
                || previousActor->m_actorinfo.pos[0] - xCenter > rangeDist)) {
            ready = true;
            previousActor = NULL;
            continue;
        }
        unsigned id_mask = previousActor->get_traits().id_mask;
        if (id_mask & typeMask) {
            if (length(previousActor->m_actorinfo.pos - centerActor->m_actorinfo.pos) 
                    < rangeDist) {
                ready = true;
            }
        }
    }
    return previousActor;
}


/* -------------------- Helper functions -------------------- */


#define DECL_TRAITS \
        static ActorTraits traits; \
        const ActorTraits &get_traits() const { return traits; } \


/* -------------------- Actor -------------------- */

Actor::Actor (const ActorTraits &tr)
: StateObject(tr.name),
  m_actorinfo(),
  m_sprite(),
  startingpos(), 
  respawnpos(), use_respawnpos(false),
  spikes(false), controllers (0), left (NULL), right (NULL)
{
    setAttr("mouseforce", 0.0);

    // copy default properties to dynamic properties
    m_actorinfo.mass = tr.default_mass;
    m_actorinfo.radius = tr.radius;

    ASSERT(m_actorinfo.radius <= get_max_radius(), XLevelRuntime, "Actor: radius of actor too large");
}

void Actor::on_collision (Actor *) 
{
}

ActorInfo *Actor::get_actorinfo() { 
    return &m_actorinfo; 
}

const ActorInfo &Actor::get_actorinfo() const {
    return m_actorinfo; 
}

const ecl::V2 &Actor::get_pos() const
{
    return m_actorinfo.pos;
}


const ecl::V2 &Actor::get_pos_force() const{
    return m_actorinfo.pos_force;
}


double Actor::get_max_radius() {
    return max_radius;
}

void Actor::think(double /*dtime*/) {
    if (m_actorinfo.field) {
        Floor *fl = m_actorinfo.field->floor;
        Item *it = m_actorinfo.field->item;
        bool item_covers_floor = (it && it->covers_floor(m_actorinfo.pos, this));
        if (!item_covers_floor && fl && this->is_on_floor())
            fl->actor_contact(this);
    }
}

void Actor::set_respawnpos(const V2& p)
{
    respawnpos     = p;
    use_respawnpos = true;
}

void Actor::remove_respawnpos() {
    use_respawnpos = false;
}

void Actor::find_respawnpos() {
    V2& what_pos = use_respawnpos ? respawnpos : startingpos;
    FreeRespawnLocationFinder unblocked(what_pos, *this);
    what_pos = unblocked.get_position();
}

const V2& Actor::get_respawnpos() const {
    return use_respawnpos ? respawnpos : startingpos;
}

const V2 &Actor::get_startpos() const {
    return startingpos;
}

void Actor::respawn() {
    V2 p =(use_respawnpos) ? respawnpos : startingpos;
    warp (p);
    on_respawn(p);
}

void Actor::add_force (const ecl::V2 &f) {
    m_actorinfo.forceacc += f;
}

void Actor::init() {
    m_sprite = display::AddSprite(get_pos());
}

void Actor::on_creation(const ecl::V2 &p) 
{
    set_model(get_kind());
    m_sprite.move (p);
    move ();
}

void Actor::on_respawn (const ecl::V2 &/*pos*/) {
}

void Actor::warp(const ecl::V2 &newpos) {
    m_actorinfo.pos = newpos;
    DidMoveActor(this);
    m_actorinfo.vel = V2();
    m_sprite.move (newpos);
    move ();
    // notify rubberbands that may now exceed max/min limits
    ObjectList olist = getAttr("rubbers");   // a private deletion resistant copy
    for (ObjectList::iterator itr = olist.begin(); itr != olist.end(); ++itr)
        SendMessage(*itr, "_recheck");
}

void Actor::move () 
{
    if (m_actorinfo.field) {
        if (m_actorinfo.gridpos != last_gridpos) {
            // Actor entered a new field -> notify floor and item objects
            if (Floor *fl = m_actorinfo.field->floor)
                fl->actor_enter (this);
            if (Item *it = m_actorinfo.field->item)
                it->actor_enter (this);

            if (const Field *of = GetField(last_gridpos)) {
                if (Floor *fl = of->floor)
                    fl->actor_leave (this);
                if (Item *it = of->item)
                    it->actor_leave (this);
            }
        }

        Item *it = m_actorinfo.field->item;
        if (it && it->actor_hit(this))
            player::PickupItem (this, m_actorinfo.gridpos);

        if (Stone *st = m_actorinfo.field->stone)
            st->actor_inside (this);
    }
    last_gridpos = m_actorinfo.gridpos;
}

void Actor::move_screen () {
    m_sprite.move (m_actorinfo.pos);
}

void Actor::set_model(const string &name) {
    m_sprite.replace_model (display::MakeModel(name));
}

void Actor::animcb () {
}


void Actor::hide() {
    m_sprite.hide();
}

void Actor::show() {
    m_sprite.show();
}

void Actor::set_anim (const string &modelname) {
    set_model(modelname.c_str());
    get_sprite().set_callback (this);
}

bool Actor::can_move() const { 
    if (Stone *st = GetStone (get_gridpos())) {
        if (!server::NoCollisions || !(get_traits().id_mask &
                        (1<<ac_whiteball | 1<<ac_blackball | 1<<ac_meditation)))
            return !st->is_sticky(this);
    }
    return true;
}

Value Actor::message(const Message &m) {
    if (m.message == "_init") {
        startingpos = get_pos();
        return Value();
    } else if (m.message == "_freeze") {
        m_actorinfo.frozen_vel = m_actorinfo.vel;
        m_actorinfo.vel = ecl::V2();
    } else if (m.message == "_revive") {
        m_actorinfo.vel = m_actorinfo.frozen_vel;        
    }
    return StateObject::message(m);
}

bool Actor::sound_event (const char *name, double vol) {
    return sound::EmitSoundEvent (name, get_pos(), getVolume(name, this, vol));
}

void Actor::setAttr(const string& key, const Value &val)
{
    if (key == "controllers")
        controllers = to_int (val);
    else if (key == "mouseforce") 
        mouseforce = to_double (val);
    Object::setAttr(key, val);
}

    double Actor::squareDistance(const Object *other) const {
        const Actor *a = dynamic_cast<const Actor *>(other);
        if (a != NULL)
            return ecl::square(get_pos() - a->get_pos());
        else
            return other->squareDistance(this);
    }

    bool Actor::isSouthOrEastOf(const Object *other) const {
        const Actor *a = dynamic_cast<const Actor *>(other);
        if (a != NULL)
            return (get_pos()[1] > - a->get_pos()[1]) || ((get_pos()[1] ==  a->get_pos()[1]) && (get_pos()[0] > - a->get_pos()[0]));
        else
            return !(other->isSouthOrEastOf(this));
    }

/* -------------------- RotorBase -------------------- */

namespace
{
    /*! The base class for rotors and spinning tops. */
    class RotorBase : public Actor {
    public:
        void   setAttr (const string& key, const Value &val);
    protected:
        RotorBase(const ActorTraits &tr);
    private:
        // Actor interface.
        void think (double dtime);
        bool is_dead() const { return false; }
//         bool is_flying() const { return true; }
        bool is_flying() const { return false; }
//        bool is_on_floor() const { return false; } we need friction!

	void on_collision (Actor *a) {
	    SendMessage(a, "shatter");
	}

        double range;
        double force;
        bool   gohome;
        bool   attacknearest;
        double prefercurrent;
        bool   attackCurrentOnly;
        double timeKeepAttackStrategy;
    };
}

RotorBase::RotorBase(const ActorTraits &tr)
: Actor(tr), attackCurrentOnly(false), timeKeepAttackStrategy(0)
{
    setAttr("range", 5.0);
    setAttr("force", 10.0);
    setAttr("gohome", 1.0);
    setAttr("attacknearest", 1.0);
    setAttr("prefercurrent", 0.0);
}

void RotorBase::setAttr(const string& key, const Value &val)
{
    if (key == "range")
        range = to_double(val);
    else if (key == "force") 
        force = to_double(val);
    else if (key == "gohome") 
        gohome = (to_int(val) != 0);
    else if (key == "attacknearest") 
        attacknearest = (to_int(val) != 0);
    else if (key == "prefercurrent") 
        prefercurrent = to_double(val);
    Actor::setAttr(key, val);
}

void RotorBase::think (double dtime)
{
    double cforce = force/6;

    Actor *target = 0;
    V2     target_vec;
    timeKeepAttackStrategy  -= dtime;
    if (timeKeepAttackStrategy < 0) {
        timeKeepAttackStrategy = enigma::DoubleRand(0.8, 1.6);
        attackCurrentOnly = (enigma::DoubleRand(0.0, 1.0) < prefercurrent);
    }

    ActorsInRangeIterator air_it = ActorsInRangeIterator(this, range,
            1<<ac_whiteball | 1<<ac_blackball | 1<<ac_meditation);
    Actor *a;
    while((a = air_it.next()) != NULL) {
        if (a->is_movable() && !a->is_invisible()) {
            V2 v = a->get_pos() - get_pos();
            if (attacknearest && !attackCurrentOnly ||
                    attackCurrentOnly && a == player::GetMainActor(
                    player::CurrentPlayer())) {
                if (!target || (length(v) < length(target_vec))) {
                    target = a;
                    target_vec = v;
                }
            } else if (!attackCurrentOnly) {            
                target = a;
                target_vec += normalize(v);
            }
        }
    }

    if (!target && gohome) { 
        // no actors focussed -> return to start position
        target_vec = get_respawnpos()-get_pos();
    }

    double target_dist = length(target_vec);

    if (target_dist > 0.2)
        target_vec.normalize();
    add_force (target_vec * cforce);

    Actor::think(dtime);
}


/* -------------------- Rotor -------------------- */
namespace
{
    class Rotor : public RotorBase {
        CLONEACTOR(Rotor);
        DECL_TRAITS;
   public:
        Rotor() : RotorBase (traits)
        {
        }
    };
}

ActorTraits Rotor::traits = {
    "ac-rotor",                 // name
    ac_rotor,                   // id
    1<<ac_rotor,                // id_mask
    22.0f/64,                   // radius
    0.8f                        // mass
};


/* -------------------- Spinning top -------------------- */
namespace
{
    class Top : public RotorBase {
        CLONEACTOR(Top);
        DECL_TRAITS;
    public:
        Top() : RotorBase (traits)
        {
        }
    };
}

ActorTraits Top::traits = {
    "ac-top",                   // name
    ac_top,                     // id
    1<<ac_top,                  // id_mask
    16.0f/64,                   // radius
    0.8f                        // mass
};

/* -------------------- Bug -------------------- */

namespace
{
    class Bug : public Actor {
        CLONEACTOR(Bug);
        DECL_TRAITS;
    public:
        Bug() : Actor(traits) {}
        bool is_flying() const { return false; }
        bool is_dead() const { return false; }
        int get_id() const { return ac_bug; }
    };
}

ActorTraits Bug::traits = {
    "ac-bug",                   // name
    ac_bug,                     // id
    1<<ac_bug,                  // id_mask
    12.0f/64,                   // radius
    0.7f                        // mass
};


/* -------------------- Horse -------------------- */

namespace
{
    class Horse : public Actor {
        CLONEACTOR(Horse);
        DECL_TRAITS;
 
        int get_id() const { return ac_horse; }
        bool is_flying() const { return false; }
        bool is_dead() const { return false; }

        void think (double dtime);

        // Private methods
        void update_target ();

        // Variables
        int m_targetidx;
        V2 m_target;
   public:
        Horse();
    };
}

ActorTraits Horse::traits = {
    "ac-horse",                 // name
    ac_horse,                   // id
    1<<ac_horse,                // id_mask
    24.0f/64,                   // radius
    1.2f                        // mass
};

Horse::Horse() 
: Actor(traits),
  m_targetidx(-1),
  m_target()
{
    setAttr("force", Value(10.0));
}
 
void Horse::think (double /* dtime */) 
{
    double force = getAttr("force");
    update_target ();
    if (m_targetidx != -1) {
        add_force (normalize(m_target - get_pos()) * force);
    }
}

void Horse::update_target () {
    V2 newPos;
    if (m_targetidx == -1) {
        // no target defined so far
        if (getDestinationByIndex(0, newPos)) {
            m_target = newPos;
            m_targetidx = 0;
        }
    } 
    else if (length(m_target - get_pos()) < 0.2) {
        // target reached or? try next one
        if (getDestinationByIndex(++m_targetidx, newPos)) {
            m_target = newPos;
        } else
            m_targetidx = -1;     // failed -> start anew
    } 
}



/* -------------------- CannonBall -------------------- */

namespace
{
    class CannonBall : public Actor {
        CLONEACTOR(CannonBall);
        DECL_TRAITS;
    public:
        CannonBall();
        bool is_flying() const { return true; }
        bool is_dead() const { return false; }
        bool is_on_floor() const { return false; }
        void on_creation(const ecl::V2 &p);
        bool can_move() const { return true; }

        void animcb();
    };
}

ActorTraits CannonBall::traits = {
    "ac-cannonball",            // name
    ac_cannonball,              // id
    1<<ac_cannonball,           // id_mask
    24.0/64,                    // radius
    1.0                         // mass
};

CannonBall::CannonBall()
: Actor(traits)
{
    get_actorinfo()->ignore_contacts = true;
}

void CannonBall::animcb() 
{
    const GridPos &p = get_gridpos();

    if (Stone *st = GetStone (p)) {
        SendMessage (st, "_spitter");
    }
    else if (Item *it = GetItem(p)) {
        if (!has_flags(it, itf_indestructible))
            SetItem (p, MakeItem("it-explosion3"));
    }
    else if (Floor *fl = GetFloor(p)) {
        if (fl->is_destructible())
            SetItem (p, MakeItem("it-explosion3"));
    }
    KillActor (this);
}

void CannonBall::on_creation(const ecl::V2 &p) 
{
    Actor::on_creation(p);

    display::SpriteHandle &sprite = get_sprite();
    sprite.kill();
    sprite = display::AddEffect(p, "ac-cannonball");
    sprite.set_callback(this);
}


/* -------------------- BasicBall -------------------- */
namespace
{
    /*! The base class for all marbles. */
    class BasicBall : public Actor {
    protected:
        BasicBall(const ActorTraits &tr);

        enum State {
            NO_STATE,
            NORMAL,
            SHATTERING,
            BUBBLING,
            FALLING,            // falling into abyss
            JUMPING,
            DEAD,               // marble is dead
            RESURRECTED,        // has been resurrected; about to respawn
            APPEARING,          // appearing when level starts/after respawn
            DISAPPEARING,       // disappearing when level finished
            FALLING_VORTEX,     // falling into vortex
            RISING_VORTEX,      // appear in vortex
            JUMP_VORTEX,        // jump out of vortex (here player controls actor)
        };

        enum HaloState {
            NOHALO, HALOBLINK, HALONORMAL
        };

        void sink (double dtime);
        void disable_shield();
        void change_state_noshield (State newstate);
        void change_state(State newstate);

        // Model management
        void update_model();
        void set_sink_model(const string &m);
        void set_shine_model (bool shinep);
        void update_halo();
        virtual void hide();

        /* ---------- Actor interface ---------- */
        
        virtual void think (double dtime);
        virtual void move_screen ();

        void on_creation(const ecl::V2 &p);
        void on_respawn (const ecl::V2 &/*pos*/)
        {
            change_state(APPEARING);
        }

        bool is_dead() const;
        bool is_movable() const;
        bool is_flying() const { return state == JUMPING; }
        bool is_on_floor() const;
        bool is_drunken() const { return m_drunk_rest_time>0; }
        bool is_invisible() const { return m_invisible_rest_time>0; }

        bool can_drop_items() const;
        bool can_pickup_items() const;
        bool has_shield() const;

        bool can_be_warped() const { return state==NORMAL; }

        // Object interface.
        virtual Value message(const Message &m);

        // ModelCallback interface.
        void animcb();

        /* ---------- Variables ---------- */

        State state;            // The marble's current state

        static const int minSinkDepth = 0; // normal level
        int maxSinkDepth;       // actor dies at this depth
        double sinkDepth;       // how deep actor has sunk
        int    sinkModel;       // current model
        bool   lastshinep;

        double vortex_normal_time; // while jumping out of vortex: time at normal level

        display::SpriteHandle m_halosprite;
        double                m_shield_rest_time;
        static const double   SHIELD_TIME;
        HaloState             m_halostate;

        double m_drunk_rest_time;
        double m_invisible_rest_time;
    };

    const double BasicBall::SHIELD_TIME = 10.0;
}

BasicBall::BasicBall(const ActorTraits &tr)
: Actor                 (tr),
  state                 (NO_STATE),
  maxSinkDepth          (7),
  sinkDepth             (minSinkDepth),
  sinkModel             (-1),
  lastshinep            (false),
  vortex_normal_time    (0),
  m_halosprite          (),
  m_shield_rest_time    (0),
  m_halostate           (NOHALO),
  m_drunk_rest_time     (0),
  m_invisible_rest_time (0)
{
}

void BasicBall::on_creation(const ecl::V2 &p) 
{
    Actor::on_creation(p);
    if (server::CreatingPreview)
        change_state(NORMAL);
    else
        change_state(APPEARING);
}


void BasicBall::move_screen ()
{
    update_model();
    update_halo();
    Actor::move_screen();
}

bool BasicBall::is_movable() const 
{
    return (state!=DEAD && state!=RESURRECTED && state!=APPEARING && state!=DISAPPEARING); 
}

bool BasicBall::is_dead() const {
    return state == DEAD;
}

bool BasicBall::is_on_floor() const {
    return state == NORMAL || state == JUMP_VORTEX || state==APPEARING;
}

bool BasicBall::can_drop_items() const {
    return state == NORMAL || state == JUMP_VORTEX || state==JUMPING;
}

bool BasicBall::can_pickup_items() const {
    return state == NORMAL || state == JUMP_VORTEX;
}

void BasicBall::change_state_noshield (State newstate) 
{
    if (!has_shield())
        change_state(newstate);
}

Value BasicBall::message(const Message &m) 
{
    bool handled = false;
    switch (state) {
        case NORMAL:
            if (m.message == "shatter") {
                change_state_noshield(SHATTERING);
                handled = true;
            } else if (m.message == "suicide") {
                change_state(SHATTERING);
                handled = true;
            } else if (m.message == "laserhit") {
                change_state_noshield(SHATTERING);
                handled = true;
            } else if (m.message == "fall") {
                change_state_noshield(FALLING);
                handled = true;
            } else if (m.message == "_fallvortex") {
                change_state(FALLING_VORTEX);
                handled = true;
            } else if (m.message == "jump") {
                change_state(JUMPING);
                handled = true;
            } else if (m.message == "appear") {
                change_state(APPEARING);
                handled = true;
            } else if (m.message == "disappear") {
                change_state(DISAPPEARING);
                handled = true;
            }
            break;
        case JUMPING:
            if (m.message == "shatter") {
                change_state_noshield(SHATTERING);
                handled = true;
            } else if (m.message == "disappear") {
                change_state(DISAPPEARING);
                handled = true;
            }
            break;
        case SHATTERING:
            if (m.message == "_levelfinish") {
                change_state(DEAD);
                handled = true;
            }
            break;
        case DEAD:
            if (m.message == "resurrect") {
                change_state(RESURRECTED);
                handled = true;
            }
            break;
        case FALLING_VORTEX:
            if (m.message == "rise") {
                change_state(RISING_VORTEX); // vortex->vortex teleportation
            } else if (m.message == "appear") {
                change_state(APPEARING); // vortex->non-vortex teleportation
                handled = true;
            }
            break;
        case JUMP_VORTEX:
            if (m.message == "laserhit") {
                change_state(SHATTERING);
                handled = true;
            }
            break;
        case APPEARING:
            // ugly hack
            if (m.message == "_init") {
                Actor::message (m);
                handled = true;
            } else if (m.message == "shatter") {
                change_state (SHATTERING);
                handled = true;
            }
    	    break;
        default:
            break;
    }

    // Shield, booze and invisibility can be activated in all states except DEAD

    if (state != DEAD) {
        if (m.message == "shield") {
            m_shield_rest_time += SHIELD_TIME;
            update_halo();
            handled = true;
        }
        else if (m.message == "_invisibility") {
            m_invisible_rest_time += 8.0;
            handled = true;
        }
        else if (m.message == "booze") {
            m_drunk_rest_time += 5.0; // Drunken for 5 more seconds
            handled = true;
        }
    }

    return handled ? Value() : Actor::message(m);
}

void BasicBall::set_sink_model(const string &m)
{
    int modelnum = ecl::round_down<int>(sinkDepth);

    if (!has_shield() && modelnum != sinkModel) {
        ASSERT(modelnum >= minSinkDepth && modelnum < maxSinkDepth, XLevelRuntime,
            "BasicBall: set_sink_model called though modelnum incorrect");

        string img = m+"-sink";
        img.append(1, static_cast<char>('0'+modelnum));
        set_model(img);

        sinkModel = modelnum;
    }
}

void BasicBall::set_shine_model (bool shinep)
{
    if (shinep != lastshinep) {
        string modelname = get_kind();
        if (shinep)
            set_model (modelname + "-shine");
        else
            set_model (modelname);
        lastshinep = shinep;
    }
}

void BasicBall::update_model()
{
    if (m_invisible_rest_time > 0)
        get_sprite().hide();
    else 
        get_sprite().show();

    switch (state) {
    case NORMAL:
        if (sinkDepth > minSinkDepth && sinkDepth < maxSinkDepth) {
            set_sink_model(get_kind());
        }
        else {
            ActorInfo *ai = get_actorinfo();
            int xpos = ecl::round_nearest<int> (ai->pos[0] * 32.0);
            int ypos = ecl::round_nearest<int> (ai->pos[1] * 32.0);

            bool shinep = ((xpos + ypos) % 2) != 0;
            set_shine_model (shinep);
        }
        break;
    default:
        break;
    }
}

void BasicBall::sink (double dtime)
{
    double sink_speed  = 0.0;
    double raise_speed = 0.0;   // at this velocity don't sink; above: raise

    Floor *fl = m_actorinfo.field->floor;
    Item *it = m_actorinfo.field->item;
    if (!(it != NULL && it->covers_floor(get_pos(), this)) && fl != NULL)
        fl->get_sink_speed (sink_speed, raise_speed);
    
    if (sink_speed == 0.0 || has_shield()) {
        sinkDepth = minSinkDepth;
        sinkModel = -1;
    }
    else {
        ActorInfo *ai = get_actorinfo();
        double sinkSpeed = sink_speed * (1 - length(ai->vel) / raise_speed);
        sinkDepth += sinkSpeed*dtime;

        if (sinkDepth >= maxSinkDepth) {
            set_model(string(get_kind())+"-sunk");
            ai->vel = V2();     // stop!
            sound_event ("swamp");
            change_state(BUBBLING);
        }
        else {
            if (sinkDepth < minSinkDepth) 
                sinkDepth = minSinkDepth;
        }
    }
}

void BasicBall::think (double dtime) 
{
    if (m_invisible_rest_time > 0)
        m_invisible_rest_time -= dtime;

    // Update protection shield
    if (m_shield_rest_time > 0) 
        m_shield_rest_time -= dtime;

    switch (state) {
    case NORMAL: 
        if (m_drunk_rest_time > 0) 
            m_drunk_rest_time -= dtime;
        sink (dtime);
        break;
    case JUMP_VORTEX:
        vortex_normal_time += dtime;
        if (vortex_normal_time > 0.025) // same time as appear animation
            if (vortex_normal_time > dtime) // ensure min. one tick in state JUMP_VORTEX!
                change_state(JUMPING); // end of short control over actor
        break;
    default:

        break;
    }

    Actor::think(dtime);
}

void BasicBall::animcb()
{
    string kind=get_kind();

    switch (state) {
    case SHATTERING:
        set_model(kind+"-shattered");
        change_state(DEAD);
        break;
    case BUBBLING:
        set_model("invisible");
        change_state(DEAD);
        break;
    case FALLING:
        set_model(kind+"-fallen"); // invisible
        if (get_id (this) == ac_meditation)
            sound_event ("shattersmall");
        else
            sound_event ("shatter");
        change_state(DEAD);
        break;
    case JUMPING:
        set_model(kind);
        change_state(NORMAL);
        break;
    case APPEARING:
        set_model(kind);
        change_state(NORMAL);
        break;
    case DISAPPEARING:
        set_model("ring-anim");
        break;
    case FALLING_VORTEX: {
        set_model(kind+"-fallen"); // invisible
        break;
    }
    case RISING_VORTEX: {
        set_model(kind);
        if (Item *it = GetItem(get_gridpos())) {
            ItemID id = get_id(it);
            if (id == it_vortex_open || id == it_vortex_closed) 
                SendMessage(it, "_passed"); // closes some vortex
        }
        change_state(JUMP_VORTEX);
        break;
    }
    default:
        break;
    }
}

void BasicBall::change_state(State newstate) {
    if (newstate == state)
        return;

    string kind     = get_kind();
    State  oldstate = state;
    
    if (oldstate == JUMPING) {
        // notify objects on grid about the landing - used by it_trigger
        SendMessage(GetStone(get_gridpos()), "_jumping", false);
        SendMessage(GetItem(get_gridpos()), "_jumping", false);
        SendMessage(GetFloor(get_gridpos()), "_jumping", false);
    }

    // Whatever happened to the ball, the sink depth
    // should be returned to zero.
    sinkDepth = minSinkDepth;
    sinkModel = -1;

    state = newstate;
    switch (newstate) {
    case NORMAL:
        if (oldstate == APPEARING) {
            ActorInfo *ai = get_actorinfo();
            ai->forceacc = V2();
        }
        ReleaseActor(this);
        break;

    case SHATTERING:
        if (get_id (this) == ac_meditation)
            sound_event ("shattersmall");
        else
            sound_event ("shatter");
        GrabActor(this);
        set_anim (kind+"-shatter");
        break;

    case BUBBLING:
        GrabActor(this);
//         sound::PlaySound("drown");
        set_anim ("ac-drowned");
        break;
    case FALLING:
    case FALLING_VORTEX:
        GrabActor(this);
        set_anim(kind+"-fall");
        break;
    case DEAD: 
        disable_shield();
        m_drunk_rest_time = 0;
        m_invisible_rest_time = 0;
        break;
    case JUMPING:
        sound_event ("jump");
        set_anim(kind+"-jump");
        // notify objects on grid about the jumping - used by it_trigger
        SendMessage(GetFloor(get_gridpos()), "_jumping", true);
        SendMessage(GetItem(get_gridpos()), "_jumping", true);
        SendMessage(GetStone(get_gridpos()), "_jumping", true);
        break;
    case APPEARING:
    case RISING_VORTEX:
        set_anim(kind+"-appear");
        GrabActor(this);
        break;
    case JUMP_VORTEX:
        ASSERT(oldstate == RISING_VORTEX, XLevelRuntime,
            "BasicBall: change to state JUMP_VORTEX but not RISING_VORTEX");
        vortex_normal_time = 0;
        set_model(kind);
        ReleaseActor(this);
        break;
    case DISAPPEARING:
        GrabActor(this);
        disable_shield();
        set_anim(kind+"-disappear");
        break;
    case RESURRECTED:
        disable_shield();
        sinkDepth = minSinkDepth;
	break;
    default:
        break;
    }
}

void BasicBall::disable_shield() {
    if (has_shield()) {
        m_shield_rest_time = 0;
        update_halo();
    }
}

bool BasicBall::has_shield() const {
    return m_shield_rest_time > 0;
}

void BasicBall::update_halo() {
    HaloState newstate = m_halostate;

    if (m_shield_rest_time <= 0)
        newstate = NOHALO;
    else if (m_shield_rest_time <= 3.0)
        newstate = HALOBLINK;
    else
        newstate = HALONORMAL;

    if (newstate != m_halostate) {
        double radius = get_actorinfo()->radius;
        string halokind;
    
        // Determine which halomodel has to be used:
        if (radius == 19.0/64) { // Halo for normal balls
            halokind = "halo";
        } else if (radius == 13.0f/64) { // Halo for small balls
            halokind = "halo-small";
        }

        if (m_halostate == NOHALO){
            m_halosprite = display::AddSprite (get_pos(), halokind.c_str());
        }
        switch (newstate) {
        case NOHALO:
            // remove halo
            m_halosprite.kill();
            m_halosprite = display::SpriteHandle();
            break;
        case HALOBLINK:
            // blink for the last 3 seconds
            m_halosprite.replace_model (display::MakeModel (halokind+"-blink"));
            break;
        case HALONORMAL:
            m_halosprite.replace_model (display::MakeModel (halokind));
            break;
        }
        m_halostate = newstate;
    } else if (m_halostate != NOHALO) {
        m_halosprite.move (get_pos());
    }
}

void BasicBall::hide() {
    Actor::hide();
    disable_shield();
}

//----------------------------------------
// Balls of different sorts
//----------------------------------------

namespace
{
    class BlackBall : public BasicBall {
        CLONEACTOR(BlackBall);
        DECL_TRAITS;
    public:
        BlackBall() : BasicBall(traits)
        {
            setAttr("mouseforce", Value(1.0));
            setAttr("color", Value(0.0));
            setAttr("player", Value(0.0));
            setAttr("controllers", Value(1.0));
        }
    };

    class WhiteBall : public BasicBall {
        CLONEACTOR(WhiteBall);
        DECL_TRAITS;
    public:
        WhiteBall() : BasicBall(traits)
        {
            setAttr("mouseforce", Value(1.0));
            setAttr("color", Value(1.0));
            setAttr("player", Value(1.0));
            setAttr("controllers", Value(2.0));
        }
    };

    class WhiteBall_Small : public BasicBall {
        CLONEACTOR(WhiteBall_Small);
        DECL_TRAITS;
    public:
        WhiteBall_Small() : BasicBall(traits)
        {
            setAttr("mouseforce", Value(1.0));
            setAttr("color", Value(1.0));
            setAttr("controllers", Value(3.0));
            maxSinkDepth = 4;
        }
    };

    class Killerball : public Actor {
        CLONEACTOR(Killerball);
        DECL_TRAITS;
    public:

        Killerball() : Actor (traits)
        {
            setAttr("mouseforce", Value(2.0));
            setAttr("color", Value(1.0));
            setAttr("controllers", Value(3.0));
        }
        bool is_dead() const { return false; }

	void on_collision(Actor *a) {
	    SendMessage(a, "shatter");
	}
    };
}

ActorTraits BlackBall::traits = {
    "ac-blackball",             // name
    ac_blackball,               // id
    1<<ac_blackball,            // id_mask
    19.0/64,                    // radius
    1.0                         // mass
};

ActorTraits WhiteBall::traits = {
    "ac-whiteball",             // name
    ac_whiteball,               // id
    1<<ac_whiteball,            // id_mask
    19.0/64,                    // radius
    1.0                         // mass
};

ActorTraits WhiteBall_Small::traits = {
    "ac-whiteball-small",       // name
    ac_meditation,              // id
    1<<ac_meditation,           // id_mask
    13.0f/64,                   // radius
    0.7f                        // mass
};

ActorTraits Killerball::traits = {
    "ac-killerball",            // name
    ac_killerball,              // id
    1<<ac_killerball,           // id_mask
    13.0f/64,                   // radius
    0.7f                        // mass
};


/* -------------------- Functions -------------------- */

void InitActors () 
{
    RegisterActor (new Bug);
    RegisterActor (new Horse);
    RegisterActor (new Rotor);
    RegisterActor (new Top);
    RegisterActor (new BlackBall);
    RegisterActor (new WhiteBall);
    RegisterActor (new WhiteBall_Small);
    RegisterActor (new Killerball);
    RegisterActor (new CannonBall);
}

} // namespace enigma
