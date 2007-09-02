/*
 * Copyright (C) 2002,2003,2004,2005 Daniel Heck
 * Copyright (C) 2007 Ronald Lamprecht
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
#include "laser.hh"
#include "player.hh"
#include "sound.hh"
#include "options.hh"
#include "server.hh"
#include "lua.hh"
#include "client.hh"
#include "main.hh"
#include "stones_internal.hh"

#include <iostream>
#include <algorithm>
#include <functional>
#include <map>
#include <numeric>



// remove comment from define below to switch on verbose messaging
// note: VERBOSE_MESSAGES is defined in multiple source files!
// #define VERBOSE_MESSAGES

using namespace std;
using namespace world;
using namespace ecl;

#include "world_internal.hh"

// Size of one time step -- do not change!
const double ActorTimeStep = 0.0025;


/* -------------------- Auxiliary functions -------------------- */

namespace {

/*! Find an already existing contact point in the ContactList that is
  similar to the second argument. */
    bool has_nearby_contact (const Contact *ca, int ca_count, const Contact &c)
    {
        double posdelta = 0.2;
        double normaldelta = 0.1;
        for (int i=0; i<ca_count; ++i) {
            if (length (ca[i].pos - c.pos) < posdelta
                && length (ca[i].normal - c.normal) < normaldelta)
                return true;
        }
        return false;
    }
}


/* -------------------- ActorInfo -------------------- */

ActorInfo::ActorInfo() : pos(), gridpos(), field(NULL), vel(), forceacc(),
        charge(0), mass(1), radius(1),
        grabbed(false), ignore_contacts (false), force(),
//        grabbed(false), ignore_contacts (false), last_pos(), force(),
        contacts (&contacts_a[0]), last_contacts (&contacts_b[0]),
        contacts_count (0), last_contacts_count (0) {
}

/* -------------------- Messages -------------------- */

Message::Message ()
{
}
 
Message::Message (const std::string &message_,
                  const enigma::Value &value_,
                  GridPos from_)
: message (message_),
  value (value_),
  gridpos (from_)
{
}


/* -------------------- Signals -------------------- */

namespace
{

    void emit_signal (const Signal *s, int value)
    {
        Object *src = s->source;
        Object *dst = GetObject(s->destloc);

#if defined(VERBOSE_MESSAGES)
        src->warning("emit_from: msg='%s'", // dest=%i/%i obj=%p",
                     s->message.c_str()
//                      destloc.pos.x, destloc.pos.y,
//                      dst);
                     );
#endif
        if (GridObject *go = dynamic_cast<GridObject*>(src))
            SendMessage (dst, Message (s->message, value, go->get_pos()));
        else
            SendMessage (dst, Message (s->message, value));
    }

    void emit_from (const SignalList &sl, Object *source, int value)
    {
        size_t size = sl.size();
        for (unsigned i=0; i<size; ++i) {
            if (sl[i].source == source)
                emit_signal (&sl[i], value);
        }
//         // signals may have side effects. To minimize them
//         //   1. collect all targets and then
//         //   2. emit signals to targets

//         vector<Object*> targets;

//         for (unsigned i=0; i<size; ++i) {
//             if (m_signals[i].get_source() == source)
//                 target.push_back (m_signals[i]);

//             for (unsigned i=0; i<size; ++i)
//                 if (GetObject(m_signals[i].get_target_loc()) == targets[i])
//                     m_signals[i].emit_from (source, value);
//         }
    }

    bool emit_by_index (const SignalList &sl, Object *source, int signalidx, int value) 
    {
        size_t size      = sl.size();
        int    signalcnt = 0;
        for (unsigned i=0; i<size; ++i) {
            if (sl[i].source == source) {
                if (signalcnt == signalidx) {
                    emit_signal (&sl[i], value);
                    return true;
                }
                signalcnt += 1;
            }
        }
        return false;
    }

    Object *find_single_destination (const SignalList &sl, Object *src)
    {
        Object *found = 0;
        size_t  size  = sl.size();

        for (unsigned i = 0; i<size; ++i) {
            if (sl[i].source == src) {
                if (Object *candidate = GetObject(sl[i].destloc)) {
                    if (!found)
                        found = candidate;
                    else if (candidate != found)
                        return 0;   // multiple targets
                }
            }
        }
        return found;
    }
}


/* -------------------- RubberBandData -------------------- */

RubberBandData::RubberBandData () {
    strength = 1;
    length = 2;
    minlength = 0;
}

RubberBandData::RubberBandData (const RubberBandData &x) {
    strength  = x.strength;
    length    = x.length;
    minlength = x.minlength;
}

/* -------------------- RubberBand -------------------- */

RubberBand::RubberBand (Actor *a1, Actor *a2, const RubberBandData &d)
: actor(a1), actor2(a2), stone(0),
  model(display::AddRubber(get_p1(),get_p2())),
  data (d)
{
    ASSERT(actor, XLevelRuntime, "RubberBand: no actor defined");
    ASSERT(d.length >= 0, XLevelRuntime, "RubberBand: length negative");
}

RubberBand::RubberBand (Actor *a1, Stone *st, const RubberBandData &d)
: actor(a1), actor2(0), stone(st), model(0),
  data (d)
{
    ASSERT(actor, XLevelRuntime, "RubberBand: no actor defined");
    ASSERT(d.length >= 0, XLevelRuntime, "RubberBand: length negative");
    model = display::AddRubber(get_p1(), get_p2());
}

RubberBand::~RubberBand() {
    model.kill();
}

void RubberBand::apply_forces ()
{
    V2 v = get_p2()-get_p1();
    double vv = ecl::length(v);

    if (vv > data.length) {
        V2 force = v * data.strength*(vv-data.length)/vv;
        force /= 6;
        actor->add_force(force);
        if (actor2)
            actor2->add_force(-force);
    } 
    else if (vv < data.minlength) {
        V2 force = v * data.strength * (vv-data.minlength) / vv;
        force /= 6;
        actor->add_force(force);
        if (actor2)
            actor2->add_force(-force);
    }

}

V2 RubberBand::get_p1() const
{
    return V2(actor->get_pos()[0], actor->get_pos()[1]);
}

V2 RubberBand::get_p2() const
{
    if (!stone)
        return V2(actor2->get_pos()[0], actor2->get_pos()[1]);
    else
        return stone->get_pos().center();
}

void RubberBand::tick (double /* dtime */) 
{
    model.update_first (get_p1());
    model.update_second (get_p2());
}


/* -------------------- Field -------------------- */

Field::Field()
{
    floor=0;
    item=0;
    stone=0;
}

Field::~Field()
{
    DisposeObject(floor);
    DisposeObject(item);
    DisposeObject(stone);
}


/* -------------------- StoneContact -------------------- */

//StoneContact::StoneContact(Actor *a, GridPos p,
//                           const V2 &cp, const V2 &n)
//: actor(a), stonepos(p),
//  response(STONE_PASS),
//  contact_point(cp),
//  normal(n),
//  is_collision(false),
//  ignore (false),
//  new_collision(false),
//  is_contact(true)
//{}

StoneContact::StoneContact() : is_collision (false), ignore (false), new_collision (false),
  is_contact (false), outerCorner (false) {
}

DirectionBits
world::contact_faces(const StoneContact &sc)
{
    using namespace enigma;

    int dirs = NODIRBIT;

    if (sc.normal[0] < 0)
        dirs |= WESTBIT;
    else if (sc.normal[0] > 0)
        dirs |= EASTBIT;
    if (sc.normal[1] < 0)
        dirs |= NORTHBIT;
    else if (sc.normal[1] > 0)
        dirs |= SOUTHBIT;

    return DirectionBits(dirs);
}

Direction
world::contact_face(const StoneContact &sc)
{
    using namespace enigma;
    if (sc.normal == V2(-1,0))
        return WEST;
    else if (sc.normal == V2(1,0))
        return EAST;
    else if (sc.normal == V2(0,-1))
        return NORTH;
    else if (sc.normal == V2(0,1))
        return SOUTH;
    else
        return NODIR;
}


/* -------------------- Global variables -------------------- */

namespace
{
    auto_ptr<World> level;
}

enigma::Timer  world::GameTimer;
bool           world::TrackMessages;
Actor         *world::CurrentCollisionActor = 0;



/* -------------------- Layer implementation -------------------- */

template <class T>
T *Layer<T>::get(GridPos p) {
    if (Field *f=level->get_field(p))
        return raw_get(*f);
    else
        return defaultval;
}

template <class T>
T *Layer<T>::yield(GridPos p) {
    if (Field *f=level->get_field(p)) {
        T *x = raw_get(*f);
        if (x) {
            raw_set(*f, 0);
            x->removal(p);
        }
        return x;
    } else
        return defaultval;
}

template <class T>
void Layer<T>::set(GridPos p, T *x) {
    if (x) {
        if (Field *f=level->get_field(p)) {
            if (T *old = raw_get (*f)) {
                old->removal(p);
                dispose (old);
            }
            raw_set(*f, x);
            x->creation(p);
        }
        else
            dispose(x);
    }
}




/* -------------------- World -------------------- */

const double World::contact_e = 0.02;  // epsilon distant limit for contacts

World::World(int ww, int hh) 
: fields(ww,hh),
  preparing_level(true),
  leftmost_actor (NULL), rightmost_actor (NULL)
{
    w = ww;
    h = hh;

    scrambleIntensity = server::GetDifficulty() == DIFFICULTY_EASY ? 3 : 10;
}

World::~World()
{
    fields = FieldArray(0,0);
    for_each(actorlist.begin(), actorlist.end(), mem_fun(&Actor::dispose));
    delete_sequence (m_rubberbands.begin(), m_rubberbands.end());
}

bool World::is_border (GridPos p) {
    return(p.x==0 || p.y==0 || p.x==w-1 || p.y==h-1);
}

void World::remove (ForceField *ff)
{
    ForceList::iterator i=find (forces.begin(), forces.end(), ff);
    if (i != forces.end())
        forces.erase(i);
}

Object *World::get_named (const string &name)
{
    ecl::Dict<Object*>::iterator found = m_objnames.find(name);
    if (found != m_objnames.end()) 
        return found->second;
    Log << "Did not find named object: " << name << '\n';
    return 0;
}

void World::name_object (Object *obj, const std::string &name)
{
    m_objnames.insert(name, obj); // [name] = obj;
    obj->set_attrib("name", name);
}

void World::unname (Object *obj)
{
    ASSERT(obj, XLevelRuntime, "unname: no object given");
    if (Value v = obj->getAttr("name")) {
        m_objnames.remove(v.to_string());
        obj->set_attrib("name", "");
    }
}

void World::add_actor (Actor *a)
{
    add_actor (a, a->get_pos());
}

void World::add_actor (Actor *a, const V2 &pos)
{
    actorlist.push_back(a);
    a->m_actorinfo.pos = pos;
    a->m_actorinfo.gridpos = GridPos(pos);
    a->m_actorinfo.field = get_field(a->m_actorinfo.gridpos);
    
    // Insert the actor as new rightmost_actor and (maybe) sort.
    // This makes use of did_move_actor. See version 1.1, rev.549
    // for explicit code without did_move_actor.

    Actor *oldright = rightmost_actor;

    a->left = oldright; // might be NULL
    a->right = NULL;
    rightmost_actor = a;
    if(leftmost_actor == NULL)
        leftmost_actor = a;
    if(oldright != NULL) {
        oldright->right = a;
        did_move_actor(a);
    }
    
    if (!preparing_level) {
        // if game is already running, call on_creation() from here
        a->on_creation(pos);
    }
}

Actor * World::yield_actor(Actor *a) {
    ActorList::iterator i = find(actorlist.begin(), actorlist.end(), a);
    if (i != actorlist.end()) {
        actorlist.erase(i);
        
        if (a->left == NULL)
            leftmost_actor = a->right;
        else
            a->left->right = a->right;
        
        if (a->right == NULL)
            rightmost_actor = a->left;
        else
            a->right->left = a->left;    

        a->left = NULL;
        a->right = NULL;
        
        GrabActor(a);
        return a;
    }
    return NULL;
}

void World::exchange_actors(Actor *a1, Actor *a2) {
    // Exchange actor positions and sort via did_move_actor.
    // A version without did_move_actor is in version 1.1, rev.549.
    ecl::V2 oldpos_a1 = a1->get_actorinfo()->pos;
    a1->get_actorinfo()->pos = a2->get_actorinfo()->pos;
    did_move_actor(a1);
    a2->get_actorinfo()->pos = oldpos_a1;
    did_move_actor(a2);
}


void World::tick (double dtime)
{
    // dtime is always 0.01 (cf. server.cc)

    move_actors (dtime);
    handle_delayed_impulses (dtime);
    tick_sound_dampings();

    // Tell floors and items about new stones.
    for (unsigned i=0; i<changed_stones.size(); ++i)
        stone_change(changed_stones[i]);
    changed_stones.clear();

    m_mouseforce.tick (dtime);
    for_each (forces.begin(), forces.end(),
              bind2nd(mem_fun(&ForceField::tick), dtime));

    GameTimer.tick(dtime);

    lasers::RecalcLightNow();   // recalculate laser beams if necessary
}

/* ---------- Puzzle scrambling -------------------- */

void World::add_scramble(GridPos p, Direction dir)
{
    scrambles.push_back(Scramble(p, dir, scrambleIntensity));
}

void World::scramble_puzzles()
{
    while (!scrambles.empty()) {
        list<Scramble>::iterator i = scrambles.begin();
        list<Scramble>::iterator e = scrambles.end();

        for (; i != e; ++i) {
            Stone *puzz = GetStone(i->pos);
            if (puzz && i->intensity) {
                SendMessage(puzz, "scramble", Value(double(i->dir)));
                --i->intensity;
            }
            else {
                fprintf(stderr, "no stone found for scramble at %i/%i\n", i->pos.x, i->pos.y);
                i->intensity = 0;
            }
        }

        scrambles.remove_if(mem_fun_ref(&Scramble::expired));
    }
}

//----------------------------------------------------------------------
// Physics simulation
//----------------------------------------------------------------------


/* -------------------- Force calculation -------------------- */

#ifndef M_PI
#define M_PI 3.1415926535
#endif

void World::add_mouseforce (Actor *a, Floor *floor, V2 &mforce)
{
    if (a->get_controllers() != 0) {
        V2 f = floor->process_mouseforce(a, m_mouseforce.get_force(a));
        if (a->is_drunken()) {
            // rotate mouse force by random angle
            double maxangle = M_PI * 0.7;
            double angle = DoubleRand (-maxangle, maxangle);
            f = V2(f[0]*cos(angle) - f[1]*sin(angle),
                   f[0]*sin(angle) + f[1]*cos(angle));
        }
        mforce += f;
    }
}

/*! Calculate the total force on an actor A at time TIME.  The
  actor's current position X and velocity V are also passed.  [Note
  that the position and velocity entries in ActorInfo will be updated
  only after a *successful* time step, so they cannot be used
  here.] */
V2 World::get_local_force (Actor *a)
{
    V2 f;

    if (a->is_on_floor()) {
        if (Floor *floor = a->m_actorinfo.field->floor) {
            // Constant force
            m_flatforce.add_force(a, f);

            // Mouse force
            add_mouseforce (a, floor, f);

            // Friction
            double friction = floor->get_friction();
            if (a->has_spikes())
                friction += 7.0;

            V2 v = a->get_vel();
            double vv=length(v);
            if (vv > 0) {
                V2 frictionf = v * (server::FrictionFactor*friction);
                frictionf /= vv;
                frictionf *= pow(vv, 0.8);
                f -= frictionf;
            }

            floor->add_force(a, f);
        }

        if (Item *item = a->m_actorinfo.field->item) 
            item->add_force(a, f);
    }

    return f;
}

/* Global forces are calculated less often than local ones, namely
   only once every four time steps, cf. move_actors().  They are used
   for forces that are more time consuming to calculate, i.e.,
   actor-actor interactions and external force fields. */
V2 World::get_global_force (Actor *a)
{
    V2 f;
    // Electrostatic forces between actors.
    if (double q = get_charge(a)) {
        for (ActorList::iterator i=actorlist.begin();
             i != actorlist.end(); ++i)
        {
            Actor *a2 = *i;
            if (a2 == a) continue;
            if (double q2 = get_charge(a2)) {
                V2 distv = a->get_pos_force() - a2->get_pos_force();
                if (double dist = distv.normalize())
                    f += server::ElectricForce * q * q2 / (dist) * distv;
            }
        }
    }

    // All other force fields.
    for (ForceList::iterator i=forces.begin(); i != forces.end(); ++i) 
        (*i)->add_force(a, f);

    return f;
}

/* -------------------- Collision handling -------------------- */

/* Determine whether an actor is in contact with a stone at position
   `p'.  The result is returned in `c'.  Three situations can occur:

   1) There is no stone at `p'. In this case, `is_contact' is set to
      false and nothing else is done.

   2) The stone and the actor are in contact. In this case, `c' is
      filled with the contact information and `is_contact'p is set to
      true.

   3) The stone and the actor are _not_ in contact.  In this case, `c'
      is filled is filled with information about the closest feature
      on the stone and `is_contact' is set to false. 
*/

/**
 * Examine a possible contact of an actor with stone at a given grid position. Joins
 * of outer corners have to be announced. All other cases are handeled.
 * @arg a  the actor that may cause a contact
 * @arg p  the grid position
 * @arg c  the contact info to be filled
 * @arg winFacesActorStone  the faces of a Window stone on the actors grid position
 * @arg isRounded  defaults to true and can be set to false for a join of the
 *         relevant outer edge
 * @arg st  stone at gridposition if already known
 */
void World::find_contact_with_stone(Actor *a, GridPos p, StoneContact &c,
        DirectionBits winFacesActorStone, bool isRounded, Stone *st) {
            
    c.is_contact = false;
    c.faces = NODIRBIT;
    c.outerCorner = false;
    bool isInnerContact = false;

    Stone *stone = (st != NULL) ? st : world::GetStone(p);
    if (!stone)
        return;

    bool isWindow = stone->get_traits().id == st_window;
    DirectionBits wsides;
    if (isWindow) {
        wsides = dynamic_cast<stones::ConnectiveStone *>(stone)->get_connections();
    }
    
    const ActorInfo &ai = *a->get_actorinfo();
    double r = ai.radius;

    int x = p.x, y = p.y;

    double ax = ai.pos[0];
    double ay = ai.pos[1];
//    const double contact_e = 0.02;
    const double erad_const = 2.0/32;      // edge radius
    const double erad_window_const = 1.5/32; // edge radius for window - the windows glass
                                             // is 3/32 thick - needs to less than minimal
                                             // actor radius!
    double cdist = isWindow ? erad_window_const : erad_const;
    double erad = isRounded ? cdist : 0.0;

    // Inner bounce of a window stone
    if ((ax >= x) && (ax < x+1) && (ay >= y) && (ay < y+1) ) {
        if (isWindow) {
            // preparations for inner corners of a window stone:
            // 8 inner corners can cause bounces if they are not joined with a 
            // neighbour window face:
            // .1....2.
            // 8......3
            // ..    ..
            // ..    ..
            // ..    ..
            // ..    ..
            // 7......4
            // .6....5.
            // the actor can hit just one of the corners - get the candidate first:
            int xcorner = (ax >= x+0.5);
            int ycorner = (ay >= y+0.5);
            
            // get the neighbour window that might eliminate the corner by a join
            int xoff_neighbour = (ax < x+erad_window_const) ? -1 : (ax > x+1-erad_window_const); 
            int yoff_neighbour = (ay < y+erad_window_const) ? -1 : (ay > y+1-erad_window_const);
                        
            // get the candidate face of the window
            DirectionBits face = NODIRBIT;  
            if      (!xcorner && yoff_neighbour) face = WESTBIT;
            else if ( xcorner && yoff_neighbour) face = EASTBIT;
            else if (!ycorner && xoff_neighbour) face = NORTHBIT;
            else if ( ycorner && xoff_neighbour) face = SOUTHBIT;
            
            // the faces that the neighbour window owns
            stones::ConnectiveStone * neighbour = dynamic_cast<stones::ConnectiveStone *>
                    (world::GetStone(GridPos(x+xoff_neighbour, y+yoff_neighbour)));
            DirectionBits face_neighbour = (neighbour) ? neighbour->get_connections() : NODIRBIT;
            
            
            if ((winFacesActorStone&face) && !(face_neighbour&face)) {
                // contact to an inner corner of a window stone
                // same code as external corner below
                double cx[2] = {cdist, -cdist};
        
                V2 corner(x+xcorner+cx[xcorner], y+ycorner+cx[ycorner]);
                V2 b=V2(ax,ay) - corner;
                
                // fix 45 degree collisions that may require precision
                if (abs(abs(b[0]) - abs(b[1])) < 1.0e-7) {
                    b[1] = (b[1] >= 0) ? abs(b[0]) : -abs(b[0]);
                }
        
                c.is_contact    = (length(b)-r-cdist < contact_e);
                c.normal        = normalize(b);
                c.faces = face;
                c.contact_point = corner + c.normal*cdist;
                isInnerContact = true;
            
            // all straight contacts to inner window faces including the corners that are joined    
            } else if ((winFacesActorStone&SOUTHBIT) && (ay > y+1-2*erad_window_const-r-contact_e)) {
                c.contact_point = V2(ax, y+1-2*erad_window_const);
                c.normal        = V2(0,-1);
                c.faces = SOUTHBIT;
                c.is_contact = true;
                isInnerContact = true;
            } else if ((winFacesActorStone&NORTHBIT) && (ay <= y+2*erad_window_const+r+contact_e)) {
                c.contact_point = V2(ax, y+2*erad_window_const);
                c.normal        = V2(0,+1);
                c.faces = NORTHBIT;
                c.is_contact = true;
                isInnerContact = true;
            } else if ((winFacesActorStone&WESTBIT) && (ax <= x+2*erad_window_const+r+contact_e)) {
                c.contact_point = V2(x+2*erad_window_const, ay);
                c.normal        = V2(+1, 0);
                c.faces = WESTBIT;
                c.is_contact = true;
                isInnerContact = true;
            } else if ((winFacesActorStone&EASTBIT) && (ax > x+1-2*erad_window_const-r-contact_e)) {
                c.contact_point = V2(x+1-2*erad_window_const, ay);
                c.normal        = V2(-1,0);
                c.faces = EASTBIT;
                c.is_contact = true;
                isInnerContact = true;
            }
        }
        // ignore all inner collisions of other stones
    }
    // Closest feature == north or south face of the stone?
    else if (ax>=x+erad && ax<x+1-erad && (!isWindow || ((ay>y+1)&&(wsides&SOUTHBIT)) ||
            ((ay<y)&&(wsides&NORTHBIT)) || (ax<=x+erad_window_const) || (ax>=x+1-erad_window_const))) {
        // the last two terms are straight reflections on rectangular window sides due
        // to a join with the neighbour stone
        
        double dist = r+5;

        // south
        if (ay>y+1) {
            c.contact_point = V2(ax, y+1);
            c.normal        = V2(0, +1);
            c.faces = SOUTHBIT;
            dist            = ay-(y+1);
        }
        // north
        else if (ay<y) {
            c.contact_point = V2(ax, y);
            c.normal        = V2(0,-1);
            c.faces = NORTHBIT;
            dist            = y-ay;
        }
        c.is_contact = (dist-r < contact_e);
        
        if (isWindow && (((ay>y+1)&&!(wsides&SOUTHBIT)) || ((ay<y)&&!(wsides&NORTHBIT)))) {
            // actor did hit joined part of end face
            if (ax<=x+erad_window_const) c.faces = WESTBIT;
            else c.faces = EASTBIT;
        }
    }
    // Closest feature == west or east face of the stone?
    else if (ay>=y+erad && ay<y+1-erad && (!isWindow || ((ax>x+1)&&(wsides&EASTBIT)) ||
            ((ax<x)&&(wsides&WESTBIT)) || (ay<=y+erad_window_const) || (ay>=y+1-erad_window_const))) {
        double dist=r+5;
        if (ax>x+1) { // east
            c.contact_point = V2(x+1, ay);
            c.normal        = V2(+1, 0);
            c.faces = EASTBIT;
            dist            = ax-(x+1);
        }
        else if (ax<x) { // west
            c.contact_point = V2(x, ay);
            c.normal        = V2(-1, 0);
            c.faces = WESTBIT;
            dist            = x-ax;
        }
    	c.is_contact = (dist-r < contact_e);
        if (isWindow && (((ax>x+1)&&!(wsides&EASTBIT)) || ((ax<x)&&!(wsides&WESTBIT)))) {
            // actor did hit joined part of end face
            if (ay<=y+erad_window_const) c.faces = NORTHBIT;
            else c.faces = SOUTHBIT;
        }
    }
    // Closest feature == any of the four corners
    else if (!isWindow || !(
            ((ax > x+cdist) && (ax < x+0.5) && (wsides&WESTBIT) && (winFacesActorStone&WESTBIT)) ||
            ((ax >= x+0.5) && (ax < x+1-cdist) && (wsides&EASTBIT) && (winFacesActorStone&EASTBIT)) ||
            ((ay > y+cdist) && (ay < y+0.5) && (wsides&NORTHBIT) && (winFacesActorStone&NORTHBIT)) ||
            ((ay >= y+0.5) && (ay < y+1-cdist) && (wsides&SOUTHBIT) && (winFacesActorStone&SOUTHBIT)))) {
        // the 4 terms exclude collisions from inner corners of windows if they are joined
        // with a window stone face on the grid of the actor itself
        int xcorner=(ax >= x+0.5);
        int ycorner=(ay >= y+0.5);
        double cx[2] = {cdist, -cdist};

        V2 corner(x+xcorner+cx[xcorner], y+ycorner+cx[ycorner]);
        V2 b=V2(ax,ay) - corner;
        
        // fix 45 degree collisions that may require precision
        if (abs(abs(b[0]) - abs(b[1])) < 1.0e-7) {
            b[1] = (b[1] >= 0) ? abs(b[0]) : -abs(b[0]);
        }

        c.is_contact    = (length(b)-r-cdist < contact_e);
        c.normal        = normalize(b);
        c.contact_point = corner + c.normal*cdist;
        if (!isWindow) {
            if (abs(b[0]) >= abs(b[1])) {
                if (b[0] < 0) c.faces = DirectionBits(c.faces | WESTBIT);
                else c.faces = DirectionBits(c.faces | EASTBIT);
            } else if (abs(b[1]) >= abs(b[0])) {
                if (b[1] < 0) c.faces = DirectionBits(c.faces | NORTHBIT);
                else c.faces = DirectionBits(c.faces | SOUTHBIT);
            }
        } else {
            if (!xcorner && (b[0]>0 || (!ycorner&&!(wsides&NORTHBIT)) || 
                    (ycorner&&!(wsides&SOUTHBIT)) || (abs(b[0]) >= abs(b[1])))) 
                c.faces = DirectionBits(c.faces | WESTBIT);
            if (xcorner && (b[0]<0 || (!ycorner&&!(wsides&NORTHBIT)) || 
                    (ycorner&&!(wsides&SOUTHBIT)) || (abs(b[0]) >= abs(b[1])))) 
                c.faces = DirectionBits(c.faces | EASTBIT);
            if (ycorner && (b[1]<0 || (!xcorner&&!(wsides&WESTBIT)) || 
                    (xcorner&&!(wsides&EASTBIT)) || (abs(b[1]) >= abs(b[0])))) 
                c.faces = DirectionBits(c.faces | SOUTHBIT);
            if (!ycorner && (b[1]>0 || (!xcorner&&!(wsides&WESTBIT)) || 
                    (xcorner&&!(wsides&EASTBIT)) || (abs(b[1]) >= abs(b[0])))) 
                c.faces = DirectionBits(c.faces | NORTHBIT);
        }
        c.outerCorner = true;
    }

    if (c.is_contact) {
        // treat this as a collision only if actor not inside the stone
        // and velocity towards stone
        if (!isInnerContact && ax >= x && ax < x+1 && ay >= y && ay < y+1)
            c.is_collision = false;
        else
            c.is_collision  = c.normal*ai.vel < 0;

        c.ignore   = false;
        c.actor    = a;
        c.stonepos = p;
        c.stoneid  = stone->get_traits().id;
        c.response = stone->collision_response(c);
        c.sound    = stone->collision_sound();
    }
}

/**
 * Examines all contacts of an actor that is the edge of a grid in a distance to touch
 * any stone on the three adjacent grid positions.
 * @arg a   the actor that causes contacts
 * @arg p0  the grid position that is diagonal to the actors grid at the give edge
 * @arg c0  the contact info for p0 initialized with a normal pointing to the actors grid
 * @arg p1  one of the grid positions that is a side neighbour to the actors grid at the give edge
 * @arg c1  the contact info for p1 initialized with a normal pointing to the actors grid
 * @arg p2  one of the grid positions that is a side neighbour to the actors grid at the give edge
 * @arg c2  the contact info for p0 initialized with a normal pointing to the actors grid
 * @arg winFacesActorStone  the faces of a Window stone on the actors grid position that
 *          could cause joins with others Window stones faces on the examined positions.
 *          Just inner corners of Window faces are affected.
 */
void World::find_contact_with_edge(Actor *a, GridPos p0, GridPos p1, GridPos p2, 
        StoneContact &c0, StoneContact &c1, StoneContact &c2, DirectionBits winFacesActorStone) {
    Stone *s0 = world::GetStone(p0);
    Stone *s1 = world::GetStone(p1);
    Stone *s2 = world::GetStone(p2);
    if (s0 != NULL) c0.response = s0->collision_response(c0);
    if (s1 != NULL) c1.response = s1->collision_response(c1);
    if (s2 != NULL) c2.response = s2->collision_response(c2);
    
    if (s1 && s2 && c1.response==STONE_REBOUND && c2.response==STONE_REBOUND) {
        // a real edge bounce - no rounded edges
        find_contact_with_stone(a, p1, c1, winFacesActorStone, false, s1);  // collision with both straight neighbours
        find_contact_with_stone(a, p2, c2, winFacesActorStone, false, s2);  // collision with both straight neighbours
    } else if (s0 && s1 && c0.response==STONE_REBOUND && c1.response==STONE_REBOUND) {
        // join stones to a block without rounded edges
        find_contact_with_stone(a, p1, c1, winFacesActorStone, false, s1);  // collision with straight neighbour only
        find_contact_with_stone(a, p2, c2, winFacesActorStone, true, s2);   // register contact without collision
    } else if (s0 && s2 && c0.response==STONE_REBOUND && c2.response==STONE_REBOUND) {
        // join stones to a block without rounded edges
        find_contact_with_stone(a, p2, c2, winFacesActorStone, false, s2);  // contact with straight neighbour only
        find_contact_with_stone(a, p1, c1, winFacesActorStone, true, s1);   // register contact without collision
    } else {
        // register single stone collisions and contacts
        if (s0) find_contact_with_stone(a, p0, c0, winFacesActorStone, true, s0);
        if (s1) find_contact_with_stone(a, p1, c1, winFacesActorStone, true, s1);
        if (s2) find_contact_with_stone(a, p2, c2, winFacesActorStone, true, s2);
    }
}

/**
 * Examines all contacts of an actor with a Window stone on the grid position of the
 * actor.
 * @arg a   the actor that causes contacts
 * @arg p   the grid position of the actor and the Window stone
 * @arg c0  a contact info for a east or west contact. The normal has no need of being intialized
 * @arg c1  a contact info for a noth or south contact. The normal has no need of being intialized
 * @arg winFacesActorStone  the faces of a Window stone on the actors grid position
 */
void World::find_contact_with_window(Actor *a, GridPos p, StoneContact &c0, StoneContact &c1,
        DirectionBits winFacesActorStone) {
    if (winFacesActorStone != NODIRBIT) {
        // as the actor cannot contact opposite face at the same time
        // we reuse the contact structure for optimization
        if (winFacesActorStone&WESTBIT) 
            find_contact_with_stone(a, p, c0, WESTBIT);
        if ((winFacesActorStone&EASTBIT) && c0.is_contact == false)
            find_contact_with_stone(a, p, c0, EASTBIT);
        if (winFacesActorStone&SOUTHBIT) 
            find_contact_with_stone(a, p, c1, SOUTHBIT);
        if ((winFacesActorStone&NORTHBIT) && c1.is_contact == false)
            find_contact_with_stone(a, p, c1, NORTHBIT);
    }
    
}

/**
 * Examins all contacts of an actor with stones on and around it.
 * @arg a   the actor that causes contacts
 * @arg c0  an uninitialized contact info that will be filled with possible contact data
 * @arg c1  an uninitialized contact info that will be filled with possible contact data
 * @arg c2  an uninitialized contact info that will be filled with possible contact data
 */
void World::find_stone_contacts(Actor *a, StoneContact &c0, StoneContact &c1,
        StoneContact &c2) {
    // time critical routine that is performance optimized
    
    c0.is_contact = false;
    c1.is_contact = false;
    c2.is_contact = false;
    c0.actor = a;
    c1.actor = a;
    c2.actor = a;
    
    ActorInfo &ai = *a->get_actorinfo();
    double re = ai.radius + contact_e;
    GridPos g = GridPos(round_down<int>(ai.pos[0]), round_down<int>(ai.pos[1]));
    double x = ai.pos[0];
    double y = ai.pos[1];
    
    // info about a Window stone on the Gridpos of the actor that may cause
    // contacts within the grid
    stones::ConnectiveStone * actorWinStone = dynamic_cast<stones::ConnectiveStone *>(world::GetStone(g));
    DirectionBits winFacesActorStone = (actorWinStone) ? actorWinStone->get_connections() : NODIRBIT;
    
    // distinguish 9 squares within gridpos that may cause contacts
    // low cost reduction of cases that need to be examined in detail:
    // - within the edges no inner contacts to a Window are possible
    // - middle parts can contact to a Window on the grid and one stone aside
    // - the center part can contact two faces of a Window on the grid
    // the contact info is prepared with normal vectors that allow quick checks
    // with stone faces
    if (y - g.y < re) {
        // upper grid part
        if (x - g.x < re) {
            // upper left edge
            if (c1.is_contact)
                // inner west window contact - just look for north adjacent stone contact 
                find_contact_with_stone(a, GridPos(g.x, g.y - 1), c0, winFacesActorStone);
            else if (c2.is_contact)
                // inner north window contact - just look for west adjacent stone contact 
                find_contact_with_stone(a, GridPos(g.x - 1, g.y), c0, winFacesActorStone);
            else {
                c0.normal = V2(+1, +1);  // no need of normalization - just direction
                c1.normal = V2(0, +1);
                c2.normal = V2(+1, 0);
                c0.contact_point = c1.contact_point = c2.contact_point = V2(g.x, g.y);
                find_contact_with_edge(a, GridPos(g.x - 1, g.y - 1), GridPos(g.x, g.y - 1),
                        GridPos(g.x - 1, g.y), c0, c1, c2, winFacesActorStone);
            }
        } else if (-x + (g.x + 1) < re) {
            // upper right edge
            find_contact_with_window(a, GridPos(g.x, g.y), c1, c2, winFacesActorStone);
            if (c1.is_contact)
                // inner east window contact - just look for north adjacent stone contact 
                find_contact_with_stone(a, GridPos(g.x, g.y - 1), c0, winFacesActorStone);
            else if (c2.is_contact)
                // inner north window contact - just look for east adjacent stone contact 
                find_contact_with_stone(a, GridPos(g.x + 1, g.y), c0, winFacesActorStone);
            else {
                c0.normal = V2(-1, +1);  // no need of normalization - just direction
                c1.normal = V2(0, +1);
                c2.normal = V2(-1, 0);
                c0.contact_point = c1.contact_point = c2.contact_point = V2(g.x+1, g.y);
                find_contact_with_edge(a, GridPos(g.x + 1, g.y -1), GridPos(g.x, g.y - 1),
                        GridPos(g.x + 1, g.y), c0, c1, c2, winFacesActorStone);
            }
        } else {
            // upper middle part
            find_contact_with_window(a, GridPos(g.x, g.y), c1, c2, winFacesActorStone);
            if (!c2.is_contact)
                // only hit adjacent stone if no inner window is in front
                find_contact_with_stone(a, GridPos(g.x, g.y - 1), c0, winFacesActorStone);
        }
    } else if (-y + (g.y +1) < re) {
        // lower grid part
        if (x - g.x < re) {
            // lower left edge
            if (c1.is_contact)
                // inner west window contact - just look for south adjacent stone contact 
                find_contact_with_stone(a, GridPos(g.x, g.y + 1), c0, winFacesActorStone);
            else if (c2.is_contact)
                // inner south window contact - just look for west adjacent stone contact 
                find_contact_with_stone(a, GridPos(g.x - 1, g.y), c0, winFacesActorStone);
            else {
                c0.normal = V2(+1, -1);  // no need of normalization - just direction
                c1.normal = V2(0, -1);
                c2.normal = V2(+1, 0);
                c0.contact_point = c1.contact_point = c2.contact_point = V2(g.x, g.y+1);
                find_contact_with_edge(a, GridPos(g.x - 1, g.y + 1), GridPos(g.x, g.y + 1),
                        GridPos(g.x - 1, g.y), c0, c1, c2, winFacesActorStone);
            }
        } else if (-x + (g.x + 1) < re) {
            // lower right edge
            if (c1.is_contact)
                // inner east window contact - just look for south adjacent stone contact 
                find_contact_with_stone(a, GridPos(g.x, g.y + 1), c0, winFacesActorStone);
            else if (c2.is_contact)
                // inner south window contact - just look for east adjacent stone contact 
                find_contact_with_stone(a, GridPos(g.x + 1, g.y), c0, winFacesActorStone);
            else {
                c0.normal = V2(-1, -1);  // no need of normalization - just direction
                c1.normal = V2(0, -1);
                c2.normal = V2(-1, 0);
                c0.contact_point = c1.contact_point = c2.contact_point = V2(g.x+1, g.y+1);
                find_contact_with_edge(a, GridPos(g.x + 1, g.y + 1), GridPos(g.x, g.y +1),
                        GridPos(g.x + 1, g.y), c0, c1, c2, winFacesActorStone);
            }
        } else {
            // lower middle part
            find_contact_with_window(a, GridPos(g.x, g.y), c1, c2, winFacesActorStone);
            if (!c2.is_contact)
                // only hit adjacent stone if no inner window is in front
                find_contact_with_stone(a, GridPos(g.x, g.y + 1), c0, winFacesActorStone);
        }
    } else {
        // middle grid part
        if (x - g.x < re) {
            // left middle part
            find_contact_with_window(a, GridPos(g.x, g.y), c1, c2, winFacesActorStone);
            if (!c1.is_contact)
                // only hit adjacent stone if no inner window is in front
                find_contact_with_stone(a, GridPos(g.x - 1, g.y), c0, winFacesActorStone);
        } else if (-x + (g.x + 1) < re) {
            // right middle part
            find_contact_with_window(a, GridPos(g.x, g.y), c1, c2, winFacesActorStone);
            if (!c1.is_contact)
                // only hit adjacent stone if no inner window is in front
                find_contact_with_stone(a, GridPos(g.x + 1, g.y), c0, winFacesActorStone);
        } else {
            // actor in center of grid - just inner window contacts
            find_contact_with_window(a, GridPos(g.x, g.y), c0, c1, winFacesActorStone);
        }
    }
}

/*! This function is called for every contact between an actor and a
  stone.  It handles: (1) informing stones about contacts, (2)
  collision response, (3) updating the actor's contact list.  Note
  that a stone may kill itself during a call to actor_hit() or
  actor_contact() so we must not refer to it after having called these
  functions.  (Incidentally, this is why StoneContact only contains a
  'stonepos' and no 'stone' entry.) */
void World::handle_stone_contact (StoneContact &sc) 
{
    Actor     *a           = sc.actor;
    ActorInfo &ai          = *a->get_actorinfo();
    double     restitution = 1.0; //0.85;

    if (server::NoCollisions && (sc.stoneid != st_borderstone) && 
                a->get_traits().id_mask & (1<<ac_whiteball | 1<<ac_blackball | 1<<ac_meditation))
        return;

    Contact contact (sc.contact_point, sc.normal);
    
    if (sc.is_contact && sc.response == STONE_REBOUND) {
        ASSERT(ai.contacts_count < MAX_CONTACTS, XLevelRuntime, 
                ecl::strf("Enigma Error - insufficient contacts: %d",
                ai.contacts_count).c_str());
        ai.contacts[ai.contacts_count++] = contact;
    }
    
    if (sc.is_collision) {
        if (!sc.ignore && sc.response == STONE_REBOUND) {
            bool slow_collision = length (ai.vel) < 0.3;
            if (!has_nearby_contact(ai.last_contacts, ai.last_contacts_count, 
                    contact)) {
                if (Stone *stone = world::GetStone(sc.stonepos)) {
                    CurrentCollisionActor = a;
                    if (slow_collision) stone->actor_touch(sc);
                    else stone->actor_hit(sc);
                    CurrentCollisionActor = 0;

                    if (!slow_collision) {
                        client::Msg_Sparkle (sc.contact_point);
                        double volume = std::max (0.25, length(ai.vel)/8);
                        volume = std::min (1.0, volume);
                        volume = getVolume(sc.sound.c_str(), a, volume);
                        sound::EmitSoundEvent (sc.sound.c_str(), sc.contact_point, volume);
                    }
                }
            }

            // remove collision forces components from actor-actor collisions 
            // in direction of stone
            double normal_component = sc.normal * ai.collforce;
            if (normal_component < 0) {
                ai.collforce -= normal_component * sc.normal;
            }

            double dt = ActorTimeStep;
            ai.collforce -= (1 + restitution)*(ai.vel*sc.normal)*sc.normal / dt * ai.mass;
        }
    }
    else if (sc.is_contact) {
        if (Stone *stone = world::GetStone(sc.stonepos))
            stone->actor_contact(sc.actor);
    }
}

namespace {
    struct ActorEntry {
        double pos;
        size_t idx;

        ActorEntry () { pos = 0; idx = 0; }
        ActorEntry (double pos_, size_t idx_) { pos = pos_; idx = idx_; }

        bool operator < (const ActorEntry &x) const {
            return pos < x.pos;
        }
    };
};

void World::handle_actor_contacts () {
    // For each actor, search for possible collisions with other actors.
    // If there is a good chance for a collision, call handle_actor_contact.
    Actor *a = leftmost_actor;
    while (a != NULL) {
        Actor *candidate = a->right;
        double actingradius = a->m_actorinfo.radius + Actor::max_radius;
        double max_x = a->m_actorinfo.pos[0] + actingradius;
        while (candidate != NULL && candidate->m_actorinfo.pos[0] <= max_x) {
            double ydist = candidate->m_actorinfo.pos[1] - a->m_actorinfo.pos[1];
            ydist = (ydist < 0) ? -ydist : ydist;
            if (ydist <= actingradius) {
                handle_actor_contact(a, candidate);
            }
            candidate = candidate->right;
        }
        a = a->right;
    }
}

void World::handle_actor_contact(Actor *actor1, Actor *actor2)
{
    // Calculate if there is a collision between actor1 and actor2.

    ActorInfo &a1 = *actor1->get_actorinfo();
    ActorInfo &a2 = *actor2->get_actorinfo();

    if (a1.ignore_contacts || a2.ignore_contacts)
        return;

    V2 n = a1.pos - a2.pos; // normal to contact surface
    // fix 45 degree collisions that may require precision
    //   ignore central overlapping marbles in this correction
    if (abs(abs(n[0]) - abs(n[1])) < 1.0e-7 && abs(n[1]) > 1.0e-5) {
        n[1] = (n[1] >= 0) ? abs(n[0]) : -abs(n[0]);
    }
    double dist = n.normalize();
    double overlap = a1.radius + a2.radius - dist;
    if (overlap > 0 && !a1.grabbed && !a2.grabbed) {
        double relspeed = (a2.vel-a1.vel)*n;

        if (relspeed < 0)   // not moving towards each other
            return;

        actor1->on_collision (actor2);
        actor2->on_collision (actor1);

        bool reboundp = (actor1->is_movable() && actor2->is_movable() &&
                         (actor1->is_on_floor() == actor2->is_on_floor()));

        if (reboundp) {
            Contact contact (a2.pos + n*a2.radius, -n);
            ASSERT(a2.contacts_count < MAX_CONTACTS, XLevelRuntime, 
                    ecl::strf("Enigma Error - insufficient contacts: %d",
                    a2.contacts_count).c_str());
            a2.contacts[a2.contacts_count++] = contact;
            contact.normal = n;
            ASSERT(a1.contacts_count < MAX_CONTACTS, XLevelRuntime, 
                    ecl::strf("Enigma Error - insufficient contacts: %d",
                    a1.contacts_count).c_str());
            a1.contacts[a1.contacts_count++] = contact;            

            double restitution = 1.0; //0.95;

            // Calculate doubled reduced mass:
            double dmu = a1.mass;
            if (a1.mass != a2.mass)
                dmu = 2*a1.mass*a2.mass / (a1.mass + a2.mass);

            V2 force = (restitution * dmu * relspeed / ActorTimeStep) * n;
            a1.collforce += force;
            a2.collforce -= force;

            if (!has_nearby_contact (a1.last_contacts, a1.last_contacts_count, 
                    contact)) {
                double volume = length (force) * ActorTimeStep;
                volume = std::min(1.0, volume);
                if (volume > 0.4) {
                    volume = getVolume("ballcollision", NULL, volume);
                    sound::EmitSoundEvent ("ballcollision", contact.pos, volume);
                }
            }
        }
    }
}

void World::handle_stone_contacts (unsigned actoridx) 
{
    // Three contact structures are used to store info about contact candidates.
    // No more than two stone contacts per actor are possible, but it is more
    // efficient to provide three structures for candidates and to check afterwards.
    
    static StoneContact contacts[3];   // recycle structures for efficiency

    Actor *actor = actorlist[actoridx];

    if (actor->m_actorinfo.ignore_contacts)     // used by the cannonball for example
        return;

    // Find contacts without any sideeffects
    find_stone_contacts(actor, contacts[0], contacts[1], contacts[2]);
    
    // Handle contacts with stones - forces and stone hit, touch callback
    if (contacts[0].is_contact)
        handle_stone_contact(contacts[0]);
    if (contacts[1].is_contact)
        handle_stone_contact(contacts[1]);
    if (contacts[2].is_contact)
        handle_stone_contact(contacts[2]);
}

/* -------------------- Actor Motion -------------------- */

void World::move_actors (double dtime) 
{
    const double dt = ActorTimeStep;

    static double rest_time = 0;
    rest_time += dtime;

    size_t nactors = actorlist.size();
    for (unsigned i=0; i<nactors; ++i) {
        Actor *a = actorlist[i];
        ActorInfo &ai = *a->get_actorinfo();
        // extrapolate actor position for better accuracy of forces
        if (!ai.grabbed)
            ai.pos_force = ai.pos + dtime*0.4 * ai.vel;
        else
            ai.pos_force = ai.pos;
    }
    vector<V2> global_forces (nactors);
    for (unsigned i=0; i<nactors; ++i) {
        Actor *a = actorlist[i];
        global_forces[i] = get_global_force (a);
    }

    while (rest_time > 0) {
        for (unsigned i=0; i<nactors; ++i) {
            Actor *a = actorlist[i];
            ActorInfo &ai = *a->get_actorinfo();

            // the "6" is a historical accident, don't change it!
            ai.force     = ai.forceacc * 6;
            ai.force += global_forces[i]; 
            ai.force += get_local_force (a);

            ai.forceacc  = V2();
            ai.collforce = V2();
//            ai.last_pos  = ai.pos;
            // swap contacts and clear contacts
            ai.last_contacts = ai.contacts;
            ai.last_contacts_count = ai.contacts_count;
            ai.contacts = ai.contacts_a;
            ai.contacts_count = 0;
        }
        
        handle_actor_contacts();
        for (unsigned i=0; i<nactors; ++i) {
            Actor     *a  = actorlist[i];
            ActorInfo &ai = * a->get_actorinfo();
            if (!ai.grabbed)
                handle_stone_contacts(i);
        }

        for (unsigned i=0; i<nactors; ++i) {
            Actor     *a  = actorlist[i];
            ActorInfo &ai = * a->get_actorinfo();
            double dtime = dt;

            if (!a->can_move()) {
                if (length(ai.force) > 30)
                    client::Msg_Sparkle (ai.pos);
                ai.vel = V2();
            } else if (!a->is_dead() && a->is_movable() && !ai.grabbed) {
                advance_actor(a, dtime);
            }
            a->move();         // 'move' nevertheless, to pick up items etc
            a->think(dtime); 
        }
        for_each (m_rubberbands.begin(), m_rubberbands.end(), 
                  mem_fun(&RubberBand::apply_forces));

        rest_time -= dt;
    }
}

/* This function performs one step in the numerical integration of an
   actor's equation of motion.  TIME ist the current absolute time and
   H the size of the integration step. */
void World::advance_actor (Actor *a, double &dtime)
{
    const double MAXVEL = 70;  // 70 grids/s  < min_actor_radius/timestep !

    ActorInfo &ai = *a->get_actorinfo();
    V2 oldPos = ai.pos;
    V2 force = ai.force;

    // If the actor is currently in contact with other objects, remove
    // the force components in the direction of these objects.
    for (unsigned i=0; i<ai.contacts_count; ++i)
    {
        const V2 &normal = ai.contacts[i].normal;
        double normal_component = normal * force;
        if (normal_component < 0) {
            force -= normal_component * normal;
        }
    }
    force += ai.collforce;

    ai.vel += dtime * force / ai.mass;
    // Limit maximum velocity
    double q = length(ai.vel) / MAXVEL;
    if (q > 1)
        ai.vel /= q;

    ai.pos += dtime * ai.vel;
    // avoid actors outside of world
    if (ai.pos[0] < 0) ai.pos[0] = 0.0;
    if (ai.pos[0] >= w) ai.pos[0] = w - 1e-12;
    if (ai.pos[1] < 0) ai.pos[1] = 0.0;
    if (ai.pos[1] >= h) ai.pos[1] = h - 1e-12;
    
    // disallow direct diagonal grid moves
    GridPos oldGridPos(oldPos);
    GridPos newGridPos(ai.pos);
    if (oldGridPos.x != newGridPos.x && oldGridPos.y != newGridPos.y) {
        // split diagonal grid move in the middle of the path over the missed grid
        V2 newPos = ai.pos;
        V2 midPos;
        V2 corner(0.5 + (newGridPos.x + oldGridPos.x)/2.0, 0.5 + (newGridPos.y + oldGridPos.y)/2.0);
        double tx = (corner[1] - oldPos[1])/ai.vel[1];
        double ty = (corner[0] - oldPos[0])/ai.vel[0];
        double mid_t = (tx + ty)/2;
        midPos[0] = (oldPos[0] + ai.vel[0]* tx + corner[0])/2.0;
        midPos[1] = (oldPos[1] + ai.vel[1]* ty + corner[1])/2.0;
        // detect moves directly on the first diagonal of a grid
        if (midPos == corner && ((midPos[0] == oldGridPos.x && midPos[1] == oldGridPos.y) ||
                ((midPos[0] == oldGridPos.x + 1) && (midPos[1] == oldGridPos.y + 1)))) {
            // as the edge belongs to either old or new position we would never hit an
            // adjacent grid and thus would pass the diagonal unchecked.
            // we disturb the movement with a random minimal temporarily correcture
            midPos += (0.5 - IntegerRand(0,1)) * V2(1e-10, -1e-10); 
        }
        ai.pos = midPos;
        did_move_actor(a);
        a->move();         // 'move' nevertheless, to pick up items etc
        a->think(mid_t);   // partial time
        dtime -= mid_t;    // rest time
        if (!a->is_dead() && a->is_movable() && !ai.grabbed && ai.pos == midPos) {
            ai.pos = newPos;
        } else {
            // something happend - do not continue old move
            return;
        }
    }

    did_move_actor(a);
}

void World::did_move_actor(Actor *a) {
    a->m_actorinfo.gridpos = GridPos(a->m_actorinfo.pos);
    a->m_actorinfo.field = get_field(a->m_actorinfo.gridpos);
    
    double ax = a->m_actorinfo.pos[0];
    Actor *old_left = a->left;
    Actor *old_right = a->right;
    Actor *new_left = old_left;
    Actor *new_right = old_right;
    // find new position in actor list
    while (new_left != NULL && new_left->m_actorinfo.pos[0] > ax) {
        new_left = new_left->left;
    };
    while (new_right != NULL && new_right->m_actorinfo.pos[0] < ax) {
        new_right = new_right->right;
    };
    if (new_left != old_left || new_right != old_right) {
        // remove from old position
        if (old_left == NULL) {
            leftmost_actor = old_right;
            old_right->left = NULL;
        } else if (old_right == NULL) {
            rightmost_actor = old_left;
            old_left->right = NULL;
        } else {
            old_left->right = old_right;
            old_right->left = old_left;
        }
        // insert at new position
        if (new_left != old_left) {
            // did move to left side
            if (new_left == NULL) {
                a->left = NULL;
                a->right = leftmost_actor;
                leftmost_actor->left = a;
                leftmost_actor = a;
            } else {
                a->left = new_left;
                a->right = new_left->right;
                new_left->right = a;
                a->right->left = a;
            }
        } else if (new_right != old_right) {
            // did move to right side
            if (new_right == NULL) {
                a->right = NULL;
                a->left = rightmost_actor;
                rightmost_actor->right = a;
                rightmost_actor = a;
            } else {
                a->right = new_right;
                a->left = new_right->left;
                new_right->left = a;
                a->left->right = a;
            }
        }
    }
    
}

void World::handle_delayed_impulses (double dtime)
{
    // Handle delayed impulses
    ImpulseList::iterator i = delayed_impulses.begin(),
        end = delayed_impulses.end();
    while (i != end) {
        // shall the impulse take effect now ?
        if (i->tick(dtime)) {
            i->mark_referenced(true);
            if (Stone *st = GetStone(i->destination()))
                i->send_impulse(st);  // may delete stones and revoke delayed impuleses!
            i = delayed_impulses.erase(i);
        }
        else
            ++i;
    }
}

void World::revoke_delayed_impulses(const Stone *target) {
    // Revokes delayed impulses to and from target
    ImpulseList::iterator i = delayed_impulses.begin(),
        end = delayed_impulses.end();
    while (i != end) {
        if (i->is_receiver(target) || i->is_sender(target)) {
            if (i->is_referenced()) {
                i->mark_obsolete();
                ++i;
            } else {
                i = delayed_impulses.erase(i);
            }
        } else {
            ++i;
        }
    }
}

void World::tick_sound_dampings ()
{
    // See sound.hh and sound.cc for details.
    static int counter = 0;
    ++counter;

    if (counter > 9) {
        counter = 0;
        SoundDampingList::iterator i = level->sound_dampings.begin(),
            end = level->sound_dampings.end();
        int count = 0;
        while (i != end) {
            if(i->tick()) // return true if damping entry should be deleted
                i = level->sound_dampings.erase(i);
            else
                ++i;
        }
    }
}

void World::stone_change(GridPos p) 
{
    if (const Field *f = GetField (p)) {
        Stone *st = f->stone;
        if (st)
            st->on_floor_change();

        if (Item *it = f->item)
            it->stone_change(st);

        if (Floor *fl = f->floor)
            fl->stone_change(st);

        lasers::MaybeRecalcLight(p);
    }
}




/* -------------------- Functions -------------------- */

void world::Resize (int w, int h)
{
    level.reset (new World(w,h));
    display::NewWorld(w, h);
}

void world::PrepareLevel ()
{
    GameTimer.clear();
    CurrentCollisionActor = 0;
    Resize (20, 13);
}

bool world::InitWorld()
{
    level->scramble_puzzles();

    lasers::RecalcLight();
    lasers::RecalcLightNow();    // recalculate laser beams if necessary

    bool seen_player0 = false;

    for (ActorList::iterator i=level->actorlist.begin();
         i != level->actorlist.end(); ++i)
    {
        Actor *a = *i;
        a->on_creation(a->get_actorinfo()->pos);
        a->message ("init", Value());

        if (Value v = a->getAttr("player")) {
            int iplayer = v;
            player::AddActor(iplayer, a);
            if (iplayer == 0) seen_player0 = true;
        } else {
            player::AddUnassignedActor(a);
        }
    }

    level->changed_stones.clear();

    if (!seen_player0) 
        throw XLevelLoading("Error: No player 0 defined!");

    world::BroadcastMessage("init", Value(),
        GridLayerBits(GRID_ITEMS_BIT | GRID_STONES_BIT | GRID_FLOOR_BIT));

    server::InitMoveCounter();
    STATUSBAR->show_move_counter (server::ShowMoves);

    display::FocusReferencePoint();

    level->preparing_level = false;

    return true;
}

void world::SetMouseForce(V2 f)
{
    level->m_mouseforce.add_force(f);
}

void world::NameObject(Object *obj, const std::string &name)
{
    string old_name;
    if (Value v = obj->getAttr("name")) {
        old_name = v.to_string();
        obj->warning("name '%s' overwritten by '%s'",
                     old_name.c_str(), name.c_str());
        UnnameObject(obj);
    }
    level->name_object (obj, name);
}

void world::UnnameObject(Object *obj)
{
    level->unname(obj);
}

void world::TransferObjectName (Object *source, Object *target)
{
    if (Value v = source->getAttr("name")) {
        string name(v);
        UnnameObject(source);
        if (Value v = target->getAttr("name")) {
            target->warning("name '%s' overwritten by '%s'",
                            v.to_string().c_str(), name.c_str());
            UnnameObject(target);
        }
        NameObject(target, name);
    }
}

Object * world::GetNamedObject (const std::string &name)
{
    return level->get_named (name);
}

bool world::IsLevelBorder(GridPos p)
{
    return level->is_border(p);
}

bool world::IsInsideLevel(GridPos p)
{
    return level->contains(p);
}


/* -------------------- Force fields -------------------- */

void world::AddForceField(ForceField *ff)
{
    level->forces.push_back(ff);
}

void world::RemoveForceField(ForceField *ff) {
    level->remove (ff);
}

void world::SetConstantForce (V2 force) {
    level->m_flatforce.set_force(force);
}



/* -------------------- Rubber bands -------------------- */

void world::AddRubberBand (Actor *a, Stone *st, const RubberBandData &d)
{
    level->m_rubberbands.push_back(new RubberBand (a, st, d));
}

void world::AddRubberBand (Actor *a, Actor *a2, const RubberBandData &d)
{
    RubberBandData rbd (d);
    rbd.length = ecl::Max (d.length, get_radius(a) + get_radius(a2));
    level->m_rubberbands.push_back(new RubberBand (a, a2, rbd));
}

bool world::KillRubberBands (Actor *a)
{
    bool didKill = false;
    for (unsigned i=0; i<level->m_rubberbands.size(); ) {
        RubberBand &r = *level->m_rubberbands[i];
        if (r.get_actor() == a || r.get_actor2() == a) {
            delete &r;
            level->m_rubberbands.erase(level->m_rubberbands.begin()+i);
            didKill = true;
            continue;       // don't increment i
        }
        ++i;
    }
    return didKill;
}


void world::KillRubberBand (Actor *a, Stone *st)
{
    ASSERT(a, XLevelRuntime, "KillRubberBand: no actor attached");
    for (unsigned i=0; i<level->m_rubberbands.size(); ) {
        RubberBand &r = *level->m_rubberbands[i];
        if (r.get_actor() == a && r.get_stone() != 0)
            if (r.get_stone()==st || st==0) {
                delete &r;
                level->m_rubberbands.erase(level->m_rubberbands.begin()+i);
                continue;       // don't increment i
            }
        ++i;
    }
}

void world::KillRubberBand (Actor *a, Actor *a2)
{
    ASSERT(a, XLevelRuntime, "KillRubberBand: no actor attached");
    for (unsigned i=0; i<level->m_rubberbands.size(); ) {
        RubberBand &r = *level->m_rubberbands[i];
        if (r.get_actor() == a && r.get_actor2() != 0)
            if (r.get_actor2()==a2 || a2==0) {
                delete &r;
                level->m_rubberbands.erase(level->m_rubberbands.begin()+i);
                continue;       // don't increment i
            }
        ++i;
    }
}

void world::KillRubberBands (Stone *st)
{
   for (unsigned i=0; i<level->m_rubberbands.size(); ) {
        RubberBand &r = *level->m_rubberbands[i];
        if (r.get_stone() != 0 && r.get_stone()==st) {
            delete &r;
            level->m_rubberbands.erase(level->m_rubberbands.begin()+i);
            continue;       // don't increment i
        }
        ++i;
    }
}

void world::GiveRubberBands (Stone *st, vector<Rubber_Band_Info> &rubs) {
   for (unsigned i=0; i<level->m_rubberbands.size(); ) {
        RubberBand &r = *level->m_rubberbands[i];
        if (r.get_stone() == st) {
            Rubber_Band_Info rbi;
            rbi.act = r.get_actor();
            rbi.data = r.get_data();
            rubs.push_back(rbi);
        }
        ++i;
    }
}

bool world::HasRubberBand (Actor *a, Stone *st)
{
    for (unsigned i=0; i<level->m_rubberbands.size(); ++i) {
        RubberBand &r = *level->m_rubberbands[i];
        if (r.get_actor() == a && r.get_stone() == st)
            return true;
    }
    return false;
}

 
/* -------------------- Signals -------------------- */

void world::AddSignal (const GridLoc &srcloc, 
                       const GridLoc &dstloc, 
                       const string &msg)
{
#if defined(VERBOSE_MESSAGES)
    fprintf(stderr, "AddSignal src=%i/%i dest=%i/%i msg='%s'\n",
            srcloc.pos.x, srcloc.pos.y, dstloc.pos.x, dstloc.pos.y, msg.c_str());
#endif // VERBOSE_MESSAGES

    if (Object *src = GetObject(srcloc)) {
        src->set_attrib("action", "signal");
        level->m_signals.push_back (Signal (src, dstloc, msg));
    }
    else {
        Log << "AddSignal: Invalid signal source\n";
    }
}

bool world::HaveSignals (Object *src) 
{
    SignalList::const_iterator i=level->m_signals.begin(),
        end = level->m_signals.end();
    for (; i != end; ++i) 
        if (i->source == src) 
            return true;
    return false;
}


bool world::EmitSignalByIndex (Object *src, int signalidx, int value) 
{
    return emit_by_index (level->m_signals, src, signalidx, value);
}

bool world::GetSignalTargetPos (Object *src, GridPos &pos, int signalidx) 
{
    SignalList::const_iterator i = level->m_signals.begin(),
        end = level->m_signals.end();
    int idx = 0;
    for (; i != end; ++i) {
        if (i->source == src) {
            if (idx == signalidx) {
                pos = i->destloc.pos;
                return true;
            }
            idx += 1;
        }
    }
    return false;
}


Value world::SendMessage(Object *o, const std::string &msg) 
{
    return SendMessage (o, Message (msg, Value()));
}

Value world::SendMessage(Object *o, const std::string &msg, const Value& value)
{
    return SendMessage (o, Message (msg, value));
}

Value world::SendMessage (Object *o, const Message &m)
{
    if (o) {
        if (TrackMessages)
            o->warning("will be sent message '%s' (with Value)", m.message.c_str());
        return o->on_message(m);
    }
    else if (TrackMessages) {
        fprintf(stderr, "Sending message '%s' to NULL-object\n", m.message.c_str());
        return Value();
    }
    return Value();
}


void world::BroadcastMessage (const std::string& msg, 
                              const Value& value, 
                              GridLayerBits grids)
{
    int  width     = level->w;
    int  height    = level->h;
    bool to_floors = (grids & GRID_FLOOR_BIT) != 0;
    bool to_items  = (grids & GRID_ITEMS_BIT) != 0;
    bool to_stones = (grids & GRID_STONES_BIT) != 0;

    for (int y = 0; y<height; ++y) {
        for (int x = 0; x<width; ++x) {
            GridPos p(x, y);
            Field *f = level->get_field(p);
            if (to_floors && f->floor) SendMessage (f->floor, msg, value);
            if (to_items && f->item)  SendMessage (f->item,  msg, value);
            if (to_stones && f->stone) SendMessage (f->stone, msg, value);
        }
    }
}


void world::PerformAction (Object *o, bool onoff) 
{
    string action = "idle";
    string target(o->getAttr("target"));

    if (Value v = o->getAttr("action")) action = v.to_string();

#if defined(VERBOSE_MESSAGES)
    o->warning("PerformAction action=%s target=%s", action.c_str(), target.c_str());
#endif // VERBOSE_MESSAGES

    if (action == "callback") {
        if (lua::CallFunc(lua::LevelState(), target.c_str(), Value(onoff), o) != 0) {
            throw XLevelRuntime(string("callback '")+target+"' failed:\n"+lua::LastError(lua::LevelState()));
        }
    }
    else if (action == "signal") {
        emit_from (level->m_signals, o, onoff);
    }
    else if (Object *t = GetNamedObject(target)) {
        if (GridObject *go = dynamic_cast<GridObject*>(o))
            SendMessage (t, Message (action, Value(onoff), go->get_pos()));
        else
            SendMessage (t, Message (action, Value(onoff)));
    }
    else if (action != "idle") {
        fprintf (stderr, "Unknown target '%s' for action '%s'\n",
                 target.c_str(), action.c_str());
    }
}


namespace
{
    void explosion (GridPos p, ItemID explosion_item)
    {
        if (Stone *stone = GetStone(p))
            SendMessage(stone, "expl");
        if (Item  *item  = GetItem(p)) {
            if (has_flags(item, itf_indestructible))
                SendMessage(item, "expl");
            else
                SetItem(p, explosion_item);
        }
        else
            SetItem(p, explosion_item);
        if (Floor *floor = GetFloor(p))
            SendMessage(floor, "expl");
    }
}

void world::SendExplosionEffect(GridPos center, ExplosionType type) 
{
    const int AFFECTED_FIELDS       = 8;

    for (int a = 0; a<AFFECTED_FIELDS; ++a) {
        GridPos  dest            = get_neighbour (center, a+1);
        Item    *item            = GetItem (dest);
        Stone   *stone           = GetStone (dest);
        Floor   *floor           = GetFloor (dest);
        bool     direct_neighbor = a<4;

        switch (type) {
        case EXPLOSION_DYNAMITE:
            if (stone) SendMessage(stone, "ignite");
            if (item) SendMessage(item, "ignite");
            if (floor) SendMessage(floor, "ignite");
            break;

        case EXPLOSION_BLACKBOMB:
            if (direct_neighbor) {
                explosion (dest, it_explosion1);
            } else {
                // Note: should not ignite in non-enigma-mode!
                if (stone) SendMessage(stone, "ignite");
                if (item) SendMessage(item, "ignite");
                if (floor) SendMessage(floor, "ignite");
            }
            break;

        case EXPLOSION_WHITEBOMB:
            // Note: at least in oxyd1 only direct neighbors
            // explode, and the others not even ignite
            explosion (dest, it_explosion3);            
            break;

        case EXPLOSION_BOMBSTONE:
            if (direct_neighbor) {
                if (stone) SendMessage(stone, "bombstone");
                if (item) SendMessage(item, "bombstone");
                if (floor) SendMessage(floor, "bombstone");
            }
            break;

        case EXPLOSION_SPITTER:
            // TODO: spitter explosions
            break;
        }
    }
}

Object *world::GetObject (const GridLoc &l)
{
    switch (l.layer) {
    case GRID_FLOOR:  return GetFloor(l.pos);
    case GRID_ITEMS:  return GetItem(l.pos);
    case GRID_STONES: return GetStone(l.pos);
    default: return 0;
    }
}

const Field *world::GetField (GridPos p)
{
    return level->get_field(p);
}


/* -------------------- Floor manipulation -------------------- */

void world::KillFloor(GridPos p) 
{
    level->fl_layer.kill(p);
}

Floor *world::GetFloor(GridPos p) 
{
    return level->fl_layer.get(p);
}

void world::SetFloor(GridPos p, Floor* fl) 
{
    level->fl_layer.set(p,fl);
    if (!level->preparing_level)
        if (Stone *st = GetStone(p))
            st->on_floor_change();
}


/* -------------------- Stone manipulation -------------------- */

Stone * world::GetStone(GridPos p) {
    if (Field *f = level->get_field (p))
        return f->stone;
    else
        return level->st_layer.get(p);
}

void world::KillStone(GridPos p) {
    level->st_layer.kill(p);
    level->changed_stones.push_back(p);
}

Stone * world::YieldStone(GridPos p) {
    Stone *st = level->st_layer.yield(p);
    level->changed_stones.push_back(p);
    return st;
}

void world::SetStone(GridPos p, Stone* st) {
    level->st_layer.set(p,st);
    level->changed_stones.push_back(p);
}

void world::ReplaceStone (GridPos p, Stone* st) {
    Stone *old = level->st_layer.get(p);
    if (old) {
        TransferObjectName(old, st);
        level->st_layer.kill(p);
    }
    SetStone(p, st);
}

void world::MoveStone (GridPos oldPos, GridPos newPos) {
    SetStone(newPos, YieldStone(oldPos));
}

void world::SetScrambleIntensity (int intensity) {
    level->scrambleIntensity = intensity;
}

void world::AddScramble(GridPos p, Direction d) {
    level->add_scramble(p, d);
}


/* -------------------- Item manipulation -------------------- */

void world::KillItem(GridPos p) 
{
    lasers::MaybeRecalcLight(p);
    level->it_layer.kill(p);
}

Item *world::GetItem(GridPos p) {
    return level->it_layer.get(p);
}

Item *world::YieldItem(GridPos p) {
    lasers::MaybeRecalcLight(p);
    return level->it_layer.yield(p);
}

void world::SetItem (GridPos p, Item* it) 
{
    lasers::MaybeRecalcLight(p);
    level->it_layer.set(p,it);
}

void world::SetItem (GridPos p, ItemID id) 
{
    SetItem (p, MakeItem (id));
}


/* -------------------- Actor manipulation -------------------- */

void world::AddActor(double x, double y, Actor* a) 
{
    level->add_actor (a, V2(x, y));
}

void world::AddActor (Actor *a)
{
    level->add_actor (a);
}

void  world::DidMoveActor(Actor *a) {
    level->did_move_actor(a);
}

Actor * world::YieldActor(Actor *a) 
{
    return level->yield_actor(a);
}

void world::KillActor (Actor *a) {
    delete YieldActor (a);
}

void world::WarpActor(Actor *a, double newx, double newy, bool keep_velocity)
{
    V2 newpos = V2(newx, newy);
    ASSERT(IsInsideLevel(GridPos(newpos)), XLevelRuntime,
        "WarpActor: Tried to warp actor out of level grid. (And hyperspace travel is not implemented yet, sorry.)");
    if (!keep_velocity)
        a->get_actorinfo()->vel = V2();
    a->warp(newpos);
}

void world::FastRespawnActor(Actor *a, bool keep_velocity) {
    a->find_respawnpos();
    const V2& p = a->get_respawnpos();
    WarpActor(a, p[0], p[1], keep_velocity);
}


void world::RespawnActor(Actor *a) {
    a->find_respawnpos();
    a->respawn();
}

Actor *FindActorByID (ActorID id)
{
    ActorList::iterator i = level->actorlist.begin(),
        end = level->actorlist.end();
    for (; i != end; ++i) {
        Actor *a = *i;
        if (get_id(a) == id)
            return a;
    }
    return 0;
}

unsigned world::CountActorsOfKind (ActorID id) 
{
    unsigned count = 0;
    ActorList::iterator i = level->actorlist.begin(),
        end = level->actorlist.end();
    for (; i != end; ++i) {
        Actor *a = *i;
        if (get_id(a) == id)
            ++count;
    }
    return count;
}

Actor *world::FindOtherMarble(Actor *thisMarble) 
{
    if (!thisMarble) 
        return 0;

    switch (get_id(thisMarble)) {
    case ac_blackball: return FindActorByID (ac_whiteball);
    case ac_whiteball: return FindActorByID (ac_blackball);
    default:
        return 0;
    }
}

bool world::ExchangeMarbles(Actor *marble1) {
    Actor *marble2 = FindOtherMarble(marble1);
    if (marble2) {
        level->exchange_actors(marble1, marble2);
        return true;
    }
    return false;
}


void world::GrabActor(Actor *a)
{
    a->get_actorinfo()->grabbed = true;
}

void world::ReleaseActor(Actor *a)
{
    a->get_actorinfo()->grabbed = false;
}

bool world::GetActorsInRange (ecl::V2 center, double range,
                              vector<Actor*>& actors)
{
    ActorList &al = level->actorlist;
    for (ActorList::iterator i=al.begin(); i!=al.end(); ++i) {
        Actor *a = *i;
        if (length(a->get_pos() - center) < range)
            actors.push_back(a);
    }
    return !actors.empty();
}

bool world::GetActorsInsideField (const GridPos& pos, vector<Actor*>& actors)
{
    ActorList &al = level->actorlist;
    for (ActorList::iterator i=al.begin(); i!=al.end(); ++i) {
        Actor *a = *i;
        if (a->get_gridpos() == pos)
            actors.push_back(a);
    }
    return !actors.empty();
}

void world::ShatterActorsInsideField (const GridPos &p)
{
    vector<Actor *> actors;
    GetActorsInsideField (p, actors);
    vector<Actor *>::iterator i=actors.begin(),
        end = actors.end();
    for (; i != end; ++i) 
        SendMessage(*i, "shatter");
}


/* -------------------- Functions -------------------- */

void world::addDelayedImpulse (const Impulse& impulse, double delay, 
                               const Stone *estimated_receiver) 
{
    // @@@ FIXME: is a special handling necessary if several impulses hit same destination ?

    level->delayed_impulses.push_back(DelayedImpulse(impulse, delay, estimated_receiver));
}

void world::revokeDelayedImpulses(const Stone *target) {
    // Any stone may call this function on deletion.
    // When the repository shuts down no world is existing thus check
    // world first.
    if (level.get() != NULL) 
        level->revoke_delayed_impulses(target);
}

float world::getVolume(const char *name, Object *obj, float def_volume)
{
    // See sound.hh and sound.cc for details.
    SoundDampingList::iterator i = level->sound_dampings.begin(),
        end = level->sound_dampings.end();
    while (i != end) {
        if (i->is_equal(name, obj))
            return i->get_volume(def_volume);
        ++i;
    }
    // No entry found for this object. Create a new one.
    level->sound_dampings.push_back(sound::SoundDamping(name, obj));
    return def_volume;
}

void world::Tick(double dtime) {
    level->tick (dtime);
}

void world::TickFinished () {
    for (unsigned i=0; i<level->actorlist.size(); ++i) {
        level->actorlist[i]->move_screen();
    }

    // 
    for (unsigned i=0; i<level->m_rubberbands.size();++i) 
        level->m_rubberbands[i]->tick (0.0);
}

void world::Init()
{
    InitActors();
    lasers::Init();
    InitItems();
    stones::Init();
    InitFloors();
}

void world::Shutdown()
{
    level.reset();
    Repos_Shutdown();
}


/* -------------------- Object repository -------------------- */
namespace
{
    class ObjectRepos : public ecl::Nocopy {
    public:
        ObjectRepos();
        ~ObjectRepos();
        void add_templ(Object *o);
        void add_templ (const string &name, Object *o);
        bool has_templ(const string &name);
        Object *make(const string &name);
        Object *get_template(const string &name);

        void dump_info();
    private:
        typedef std::map<string, Object*> ObjectMap;
        ObjectMap objmap;           // repository of object templates
        int stonecount, floorcount, itemcount;
    };
}

ObjectRepos::ObjectRepos() {
    stonecount = floorcount = itemcount = 0;
}

ObjectRepos::~ObjectRepos()
{
    ecl::delete_map(objmap.begin(), objmap.end());
}


void ObjectRepos::add_templ (const string &kind, Object *o)
{
    if (has_templ(kind))
        enigma::Log << "add_templ: redefinition of object `" <<kind<< "'.\n";
    else
        objmap[kind] = o;
}

void ObjectRepos::add_templ (Object *o) {
    string kind = o->get_kind();
    if (has_templ(kind))
        enigma::Log << "add_templ: redefinition of object `" <<kind<< "'.\n";
    else
        objmap[kind] = o;
}

bool ObjectRepos::has_templ(const string &name) {
    return objmap.find(name) != objmap.end();
}

Object * ObjectRepos::make(const string &name) {
    ObjectMap::iterator i=objmap.find(name);
    if (i==objmap.end())
        return 0;
    else
        return i->second->clone();
}

Object * ObjectRepos::get_template(const string &name) {
    if (objmap.find (name) != objmap.end())
        return objmap[name];
    else
        return 0;
}

/* Generate a list of all available objects and their attributes. */
void ObjectRepos::dump_info() 
{
    ObjectMap::iterator iter = objmap.begin();
    for (; iter != objmap.end(); ++iter) {
        cout << iter->first << "( ";
        Object *obj = iter->second;
        const Object::AttribMap &a = obj->get_attribs();
        for (Object::AttribMap::const_iterator j=a.begin(); j!=a.end(); ++j)
        {
            if (j->first != "kind")
                cout << j->first << " ";
        }
        cout << ")\n";
    }
}


namespace
{
    ObjectRepos *repos;
    vector<Actor *> actor_repos(ac_COUNT);
    vector<Stone *> stone_repos(st_COUNT);
    vector<Item *> item_repos(it_COUNT);
}

void world::Register (const string &kind, Object *obj) {
    if (!repos)
        repos = new ObjectRepos;
    if (kind.empty())
        repos->add_templ(obj->get_kind(), obj);
    else
        repos->add_templ(kind, obj);
}


void world::Register (Object *obj) {
    Register (obj->get_kind(), obj);
}

void world::Register (const string &kind, Floor *obj)
{
    Object *o = obj;
    Register(kind, o);
}

void world::Register (const string &kind, Stone *obj) {
    Object *o = obj;
    Register(kind, o);
}

void world::RegisterStone (Stone *stone) 
{
    Register(static_cast<Object*>(stone));
    StoneID id = get_id(stone);
    ASSERT (id != st_INVALID, XLevelRuntime,
        "RegisterStone: trying to register with invalid ID");
    stone_repos[id] = stone;
}

void world::RegisterActor (Actor *actor) 
{
    Register(static_cast<Object*>(actor));
    ActorID id = get_id(actor);
    ASSERT (id != ac_INVALID, XLevelRuntime,
        "RegisterActor: trying to register with invalid ID");
    actor_repos[id] = actor;
}

void world::Repos_Shutdown() {
    delete repos;
}

Object * world::MakeObject(const char *kind) {
    static Object *last_templ = 0;
    static string last_kind;

    if (last_kind != kind) {
        last_kind = kind;
        last_templ = repos->get_template(kind);
    }

    Object *o = 0;
    if (last_templ)
        o=last_templ->clone();
    if (!o)
        fprintf(stderr, "MakeObject: unkown object name `%s'\n",kind);
    return o;
}

Object * world::GetObjectTemplate(const std::string &kind) {
    if (!repos->has_templ(kind)) {
        cerr << "GetObjectTemplate: unkown object name `" <<kind<< "'.\n";
        return 0;
    } else
        return repos->get_template(kind);
}

Floor* world::MakeFloor(const char *kind) {
    return dynamic_cast<Floor*>(MakeObject(kind));
}

Stone * world::MakeStone (const char *kind) {
    return dynamic_cast<Stone*>(MakeObject(kind));
}

Actor * world::MakeActor (const char *kind) {
    return dynamic_cast<Actor*>(MakeObject(kind));
}

Actor *world::MakeActor (ActorID id) 
{
    if (Actor *ac = actor_repos[id])
        return ac->clone();
    else
        ASSERT(0, XLevelRuntime, "MakeActor: no actor for ID defined");
    return 0;
}

Stone *world::MakeStone (StoneID id) 
{
    if (Stone *st = stone_repos[id])
        return st->clone();
    else
        ASSERT(0, XLevelRuntime, "MakeStone: no stone for ID defined");
    return 0;
}


void world::DisposeObject(Object *o) {
    if (o != 0) {
        UnnameObject(o);
        o->dispose();
    }
}

void world::DefineSimpleFloor(const std::string &kind, double friction,
                              double mousefactor, bool burnable,
                              const std::string &firetransform)
{
    Register(new Floor(kind.c_str(), friction, mousefactor,
             flf_default, burnable ? flft_burnable : flft_default,
             firetransform.c_str(), ""));
}

void world::DumpObjectInfo() {
    repos->dump_info();
}

/* ------------------- Item repository ------------------- */

void world::Register (const string &kind, Item *obj) 
{
    Object *o = obj;
    world::Register(kind, o);
}

void world::RegisterItem (Item *item) 
{
    Register(static_cast<Object*>(item));
    ItemID id = get_id(item);
    ASSERT(id != it_INVALID, XLevelRuntime,
        "RegisterItem: trying to register with invalid ID");
    item_repos[id] = item;
}

Item *world::MakeItem (ItemID id) 
{
    if (Item *it = item_repos[id])
        return it->clone();
    else
        ASSERT(0, XLevelRuntime, "MakeItem: no item for ID defined");
    return 0;
}

Item * world::MakeItem(const char *kind) {
    return dynamic_cast<Item*>(MakeObject(kind));
}

