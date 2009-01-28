/*
 * Copyright (C) 2002,2003,2004 Daniel Heck
 * Copyright (C) 2007,2008 Ronald Lamprecht
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

#include "items.hh"

#include "errors.hh"
#include "main.hh"
#include "display.hh"
#include "player.hh"
#include "client.hh"
#include "SoundEffectManager.hh"
#include "server.hh"
#include "world.hh"
#include "Inventory.hh"
#include "ItemHolder.hh"
#include "lev/Proxy.hh"
#include "items/GlassesItem.hh"

#include "ecl_util.hh"

#include <algorithm>
#include <cmath>
#include <iostream>


using namespace std;

using enigma::GridPos;
using enigma::Value;
using enigma::DoubleRand;
using ecl::V2;


namespace enigma {

/* -------------------- Item implementation -------------------- */

Item::Item()
{}

void Item::kill() {
    KillItem(get_pos());
}

void Item::replace(std::string kind)
{
    Item *newitem = MakeItem(kind.c_str());
    transferName(newitem);          // TODO check where transfer of identity is better
    setup_successor(newitem);           // hook for subclasses
    SetItem (get_pos(), newitem);
}

void Item::transform(std::string kind) {
    Item *newitem = MakeItem(kind.c_str());
    transferIdentity(newitem);          // subclasses may hook this call
    SetItem(get_pos(), newitem);
}

const char *Item::get_kind() const
{
    return get_traits().name;
}

string Item::get_inventory_model()
{
    return get_kind();
}

void Item::init_model()
{
    const ItemTraits &tr = get_traits();
    if (tr.flags & itf_invisible)
        set_model("invisible");
    else if (tr.flags & itf_animation)
        set_anim(tr.name);
    else
        set_model(tr.name);
}

void Item::stone_change (Stone * /*st*/) {
}

void Item::on_stonehit (Stone * /*st*/) {
}

void Item::processLight(Direction d) {
    if (get_traits().flags & itf_inflammable) {
        replace("it-explosion1");
    } else
        GridObject::processLight(d);
}

double Item::getFriction(ecl::V2 pos, double defaultFriction, Actor *a) {
    return defaultFriction;
}

ecl::V2 Item::calcMouseforce(Actor *a, ecl::V2 mouseForce, ecl::V2 floorForce) {
    return floorForce;
}

void Item::on_drop (Actor * /*a*/) {
}

void Item::drop (Actor *a, GridPos p) {
    SetItem (p, this);
    on_drop(a);
}


void Item::on_pickup (Actor * /*a*/) {
}

bool Item::can_drop_at (GridPos p) {
    return GetItem(p) == 0;
}

ItemAction Item::activate(Actor* /*a*/, GridPos /*p*/) {
    return ITEM_DROP;
}

bool Item::isStatic() const {
    return get_traits().flags & itf_static;
}

void Item::add_force(Actor *, V2 &) {
}

bool Item::actor_hit(Actor *actor)
{
    const ItemTraits &tr = get_traits();
    if (isStatic())
        return false;
    else {
        double radius = 0.3;
        if (tr.radius != 0.0)
            radius = tr.radius;
        return length(actor->get_pos()-get_pos().center()) < radius;
    }
}

/* -------------------- Various simple items -------------------- */

namespace
{
    DEF_ITEM(Odometer,  "it-odometer", it_odometer);
}

/* -------------------- DummyItem -------------------- */
    class Dummyitem : public Item {
        CLONEOBJ(Dummyitem);
        DECL_ITEMTRAITS;

        void on_pickup(Actor *) {
            int code = getAttr("code");
            fprintf(stderr, "Picked up item 0x%x\n", code);
        }
        void on_drop(Actor *) {
            int code = getAttr("code");
            fprintf(stderr, "Dropped item 0x%x\n", code);
        }
    public:
        Dummyitem() {}
    };
    DEF_ITEMTRAITSF(Dummyitem, "it-dummy", it_dummy, itf_fireproof);

/* -------------------- Booze -------------------- */

namespace
{
    class Booze : public Item {
	CLONEOBJ(Booze);
        DECL_ITEMTRAITS;
    public:
	Booze() {
	}
    private:
	ItemAction activate(Actor *a, GridPos) {
	    SendMessage(a, "_booze");
	    return ITEM_DROP;
	}
    void on_stonehit(Stone *) {
        sound_event("shatter");
        replace("it-booze-broken");
    }
    };
    DEF_ITEMTRAITS(Booze, "it-booze", it_booze);
}

/* -------------------- Broken Booze -------------------- */
namespace
{
    class BrokenBooze : public Item {
        CLONEOBJ(BrokenBooze);
        DECL_ITEMTRAITS;

        bool actor_hit(Actor *a) {
            ActorInfo &ai = * a->get_actorinfo();
            if (!ai.grabbed && a->is_on_floor()) {
                SendMessage(a, "_shatter");
            }
            return false;
        }

        virtual Value message (const Message &m) {
            if (enigma_server::GameCompatibility == GAMET_ENIGMA) {
                if (m.message == "_brush") {
                    KillItem(this->get_pos());
                    return Value();
                }
            }
            return Item::message(m);
        }

    public:
        BrokenBooze() {}
    };

    DEF_ITEMTRAITSF(BrokenBooze, "it-booze-broken", it_booze_broken, itf_static | itf_indestructible);
}

/* -------------------- Explosion -------------------- */
namespace
{
    class Explosion : public Item {
    public:
        Explosion ()
        {}

    private:
        void init_model() {set_anim("expl");}
        bool actor_hit(Actor *actor) {
            SendMessage(actor, "_shatter");
            return false;
        }
    };

    // Explode but do nothing else.
    class Explosion1 : public Explosion {
        CLONEOBJ(Explosion1);
        DECL_ITEMTRAITS;

        void animcb() {
            kill();
        }
    public:
        Explosion1()
        {}
    };
    DEF_ITEMTRAITSF(Explosion1, "it-explosion1", it_explosion1, itf_static |
                itf_animation | itf_indestructible | itf_norespawn | itf_fireproof);

    // Explode and leave a hole in the ground.
    class Explosion2 : public Explosion {
        CLONEOBJ(Explosion2);
        DECL_ITEMTRAITS;

        void animcb() {
            if (Floor *fl = GetFloor(get_pos()))
                if (fl->is_destructible())
                    replace("it_meditation_hollow");
                else
                    kill();
        }
    public:
        Explosion2()
        {}
    };
    DEF_ITEMTRAITSF(Explosion2, "it-explosion2", it_explosion2, itf_static |
                itf_animation | itf_indestructible | itf_norespawn | itf_fireproof);


    // Explode and shatter the floor.
    class Explosion3 : public Explosion {
        CLONEOBJ(Explosion3);
        DECL_ITEMTRAITS;

        void animcb() {
            if (Floor *fl = GetFloor(get_pos()))
                if (fl->is_destructible())
                    replace("it-debris");
                else
                    kill();
        }
    public:
        Explosion3()
        {}
    };
    DEF_ITEMTRAITSF(Explosion3, "it-explosion3", it_explosion3, itf_static |
                itf_animation | itf_indestructible | itf_norespawn | itf_fireproof);
}


/* -------------------- Dynamite -------------------- */
namespace
{
    class Dynamite : public Item {
        CLONEOBJ(Dynamite);
        DECL_ITEMTRAITS;
    public:
        Dynamite() : state(IDLE) {}
    private:
        enum State { IDLE, BURNING };
        State state;

        void change_state(State newstate) {
            if (newstate==BURNING && state==IDLE) {
                state = BURNING;
                set_anim("it-dynamite-burning");
            }
        }

        virtual bool isStatic() const {
            return state == BURNING;  // burning dynamite cannot be picked up
        }

        void explode () {
            GridPos p = get_pos();
            SendExplosionEffect(p, EXPLOSION_DYNAMITE);
            sound_event ("dynamite");
            //SetItem(p, it_explosion2);
            Floor *fl = GetFloor(p);
            string model = fl->get_kind();
            // SetItem(p, it_explosion2) only used by it-dynamite?
            // If Yes, the following block could be places in the explosion class:
            if (model == "fl_space") {
                // In space, an it-dynamite explodes to an it-sherd:
                // HOT FIX
                //replace(it_sherd);
                replace("it-hollow");
            } else if (model == "fl_ice") {
                // In ice, an it-dynamite explodes to an it-crack2:
                replace("it_crack_m");
            } else {
                SetItem(p, MakeItem("it-explosion2"));
            }
        }

        virtual Value message(const Message &m) {
            if (m.message == "ignite" || m.message == "_explosion" || m.message == "_bombstone") {
                change_state(BURNING);
                return Value();
            } else if (m.message == "explode") { // currently unused in c++ code
                explode();
                return Value();
            } else if (m.message == "heat") {  // used by fire-system
                change_state(BURNING);
                return true;  // caught message -> no fire!
            }
            return Item::message(m);
        }
        void animcb() { explode(); }
        void processLight(Direction d) {
            change_state(BURNING);
        }
        void on_drop(Actor *) { change_state(BURNING); }
    };
    DEF_ITEMTRAITSF(Dynamite, "it-dynamite", it_dynamite,
                itf_indestructible | itf_fireproof);
}

// ----------------------------
//      BombBase
// ----------------------------
// base class for BlackBomb and WhiteBomb

namespace
{
    class BombBase : public Item {
    public:
        BombBase (bool burning = false)
        : m_burning(burning)
        {}

    protected:
        virtual Value message(const Message &m) {
            if (m.message == "ignite"  || m.message == "_explosion") {
                burn();
                return Value();
            } else if (m.message == "explode" ) {
                explode();
                return Value();
            } else if (m.message == "heat") {  // used by fire-system
                burn();
                return true;  // caught message -> no fire!
            }
            return Item::message(m);
        }

    private:
        // Variables
        bool m_burning;

        // Private methods
        virtual void explode() = 0;

        void init_model() {
            if (m_burning)
                set_anim(burn_anim());
            else
                Item::init_model();
        }

        void burn() {
            if (!m_burning) {
                m_burning = true;
                init_model();
            }
        }

        void animcb() { explode (); }

        void processLight(Direction d) {
            explode();
        }

        void on_stonehit(Stone *st) {
            switch (server::GameCompatibility) {
            case GAMET_OXYD1:
            case GAMET_OXYDMAGNUM:
                if (!st->is_kind("st-wood?"))
                    // st-wood does not cause bombs to explode
                    explode();
                break;
            default :
                explode();
                break;
            }
        }

        virtual const char *burn_anim() const = 0;
    };
}

/* -------------------- Black Bomb -------------------- */

/** \page it-blackbomb Black Bomb

When black bombs explode, they destroy the floor tile underneath them.

\image html it-blackbomb.png
*/

namespace
{
    class BlackBomb : public BombBase  {
        CLONEOBJ(BlackBomb);
        DECL_ITEMTRAITS;
    public:
        BlackBomb (bool burning=false)
        : BombBase(burning)
        {}
    private:
        const char *burn_anim() const { return "it-blackbomb-burning"; }
        void explode() {
            GridPos p = get_pos();
            sound_event ("blackbomb");
            replace("it-explosion3");
            SendExplosionEffect(p, EXPLOSION_BLACKBOMB);  // may kill the bomb by another explosion1 set by brake
        }
    };
    DEF_ITEMTRAITSF(BlackBomb, "it-blackbomb", it_blackbomb,
                itf_static | itf_indestructible | itf_fireproof);

    class BlackBombBurning : public BlackBomb {
        CLONEOBJ(BlackBombBurning);
        DECL_ITEMTRAITS;
    public:
        BlackBombBurning() : BlackBomb(true) {}
    };
    DEF_ITEMTRAITSF(BlackBombBurning, "it-blackbomb_burning",
                it_blackbomb_burning,
                itf_static | itf_indestructible | itf_norespawn | itf_fireproof);
}


/* -------------------- White bomb -------------------- */

/*! When a white bombs explode, they destroy the floor tile underneath
them and neighboring floors. */

namespace
{
    class WhiteBomb : public BombBase  {
        CLONEOBJ(WhiteBomb);
        DECL_ITEMTRAITS;

        const char *burn_anim() const { return "it-whitebomb-burning"; }
        void explode() {
            GridPos p = get_pos();
            sound_event ("whitebomb");
            replace("it-explosion3");
            SendExplosionEffect(p, EXPLOSION_WHITEBOMB); // may kill the bomb by another explosion1 set by brake
        }

    public:
        WhiteBomb()
        {}
    };
    DEF_ITEMTRAITSF(WhiteBomb, "it-whitebomb", it_whitebomb,
                itf_static | itf_indestructible | itf_fireproof);
}

/* -------------------- Debris -------------------- */
namespace
{
    class Debris : public Item {
        CLONEOBJ(Debris);
        DECL_ITEMTRAITS;

        bool actor_hit(Actor *a) {
            SendMessage(a, "_fall");
            return false;
        }
        void animcb() {
            GridPos p = get_pos();
            SetFloor(p, MakeFloor("fl_abyss"));
            KillItem(p);
        }
    public:
        Debris() {}
    };
    DEF_ITEMTRAITSF(Debris, "it-debris", it_debris,
                itf_static | itf_animation | itf_indestructible | itf_fireproof);
}


/* -------------------- Burning floor -------------------- */

namespace
{
    /* Used for animations and interfaces of fire. Study    */
    /* floors.hh and floors.cc for the fire implementation. */

    class Burnable : public Item {
        CLONEOBJ(Burnable);
        DECL_ITEMTRAITS_ARRAY(6, state);
    public:
        static void setup() {
            RegisterItem (new Burnable(IDLE));
            RegisterItem (new Burnable(IGNITE));
            RegisterItem (new Burnable(BURNING));
            RegisterItem (new Burnable(FIREPROOF));
            RegisterItem (new Burnable(ASH));
            RegisterItem (new Burnable(OIL));
        }
    private:
        enum State { IDLE, IGNITE, BURNING, FIREPROOF, ASH, OIL };
        Burnable (State initstate) {
            state = initstate;
        }
        State state;

        virtual Value message(const Message &m);
        void animcb();
        bool actor_hit(Actor *a);
        void init_model();
    };

    ItemTraits Burnable::traits[6] = {
        {"it-burnable",           it_burnable,           itf_static, 0.0},
        {"it-burnable_ignited",   it_burnable_ignited,
             itf_static | itf_animation | itf_fireproof, 0.0},
        {"it-burnable_burning",   it_burnable_burning,
             itf_static | itf_animation | itf_fireproof, 0.0},
        {"it-burnable_fireproof", it_burnable_fireproof,
             itf_static | itf_fireproof, 0.0},
        {"it-burnable_ash",       it_burnable_ash,
             itf_static | itf_fireproof, 0.0},
        {"it-burnable_oil",       it_burnable_oil,       itf_static, 0.0},
    };
}

Value Burnable::message(const Message &m) {
    if (m.message == "extinguish") {   // stop / never start burning
        state = FIREPROOF;
        init_model();
        return Value();
    } else if (m.message == "_brush" && (state == ASH || state == FIREPROOF)) {
        kill();   // The brush cleans the floor
        return Value();
    } else if (Floor *fl = GetFloor(get_pos())) {
        if (m.message == "ignite" || m.message == "_explosion")
            return SendMessage(fl, "ignite");
    }
    return Item::message(m);
}

void Burnable::animcb() {
    if(Floor *fl = GetFloor(get_pos()))
        fl->on_burnable_animcb(state == IGNITE);
}

bool Burnable::actor_hit(Actor *a) {
    if (state == IGNITE || state == BURNING)
        SendMessage(a, "_shatter");
    return false;
}

void Burnable::init_model() {
    if(state == OIL) {
        string mymodel = "it-burnable_oil";
        mymodel = mymodel + ecl::strf("%d", IntegerRand(1, 4));
        set_model(mymodel.c_str());
    } else
        Item::init_model();
}


/* -------------------- Flags -------------------- */

namespace
{
    /*! Flags can be used to set a new respawn point for the black or
      white marble. */
    class FlagBlack : public Item {
        CLONEOBJ(FlagBlack);
        DECL_ITEMTRAITS;

        void on_drop(Actor *) {
            player::SetRespawnPositions(get_pos(), true);
        }
        void on_pickup(Actor *) {
            player::RemoveRespawnPositions(true);
        }

    public:
        FlagBlack() {}
    };
    DEF_ITEMTRAITS(FlagBlack, "it-flagblack", it_flagblack);

    class FlagWhite : public Item {
        CLONEOBJ(FlagWhite);
        DECL_ITEMTRAITS;

        void on_drop(Actor *) {
            player::SetRespawnPositions(get_pos(), false);
        }
        void on_pickup(Actor *) {
            player::RemoveRespawnPositions(false);
        }

    public:
        FlagWhite()
        {}
    };

    DEF_ITEMTRAITS(FlagWhite, "it-flagwhite", it_flagwhite);
}


//----------------------------------------
// Bridge item (for Oxyd compatibility)
//
// Floor tiles seem to be static in Oxyd and cannot change dynamically
// or be animated.  For this reason, every bridge floor in Oxyd has to
// be combined with a bridge "item" that receives the signals, shows
// the animation and sets or removes the floor.
//----------------------------------------
namespace
{
    class OxydBridge : public Item {
        CLONEOBJ(OxydBridge);
        DECL_ITEMTRAITS;

        virtual Value message(const Message &m) {
            if (m.message == "signal") {
                int ival = m.value;
                Floor *floor = GetFloor (get_pos());
                if (ival > 0)
                    SendMessage (floor, "close");
                else
                    SendMessage (floor, "open");
                return Value();
            }
            return Item::message(m);
        }
    public:
        OxydBridge() {}
    };
    DEF_ITEMTRAITSF(OxydBridge, "it-bridge-oxyd", it_bridge_oxyd,
                itf_static | itf_indestructible | itf_invisible | itf_fireproof);

    class OxydBridgeActive : public OxydBridge {
        CLONEOBJ(OxydBridgeActive);
        DECL_ITEMTRAITS;

        void on_creation (GridPos p) {
            Floor *floor = GetFloor (p);
            SendMessage (floor, "close");
        }
    public:
        OxydBridgeActive() {}
    };
    DEF_ITEMTRAITSF(OxydBridgeActive, "it-bridge-oxyd_active", it_bridge_oxyd_active,
                itf_static | itf_indestructible | itf_invisible | itf_fireproof);
}


/* -------------------- EasyKillStone -------------------- */

/*
This item is never visible during the game.  Its only purpose is to
modify the level if the difficulty mode is set to easy *before* the
game starts.

In easy game mode this item removes the stone at its position.  Then
in both modes it kills itself.

E.g. it can be used to hide walls in easy game mode.

\ref st-easymode
*/

namespace
{
    class EasyKillStone : public Item {
        CLONEOBJ(EasyKillStone);
        DECL_ITEMTRAITS;

        virtual Value message(const Message &m);
    public:
        EasyKillStone() {}
    };
    DEF_ITEMTRAITSF(EasyKillStone, "it-easykillstone",
                it_easykillstone, itf_invisible | itf_fireproof);
}

Value EasyKillStone::message(const Message &m)
{
    if (m.message == "_init") {
        // does not work in on_creation() because items are created
        // before stones are created.
        if (server::GetDifficulty() == DIFFICULTY_EASY) {
            if (Stone *st = GetStone (get_pos())) {
                if (st->is_kind ("st_death") ||
                    st->is_kind ("st_flash") ||
                    st->is_kind ("st_thief"))
                {
                    SetStone (get_pos(), MakeStone ("st_flat"));
                }
                else
                    KillStone(get_pos());
            }
        }
        kill();
        return Value();
    }
    return Item::message(m);
}

/* -------------------- EasyKeepStone -------------------- */
namespace
{
    class EasyKeepStone : public Item {
        CLONEOBJ(EasyKeepStone);
        DECL_ITEMTRAITS;

        virtual Value message(const Message &m) {
            if (m.message == "_init") {
                // does not work in on_creation() because items are created
                // before stones are created.
                if (server::GetDifficulty() == DIFFICULTY_HARD)
                    KillStone(get_pos());
                kill();
                return Value();
            }
            return Item::message(m);
        }
    public:
        EasyKeepStone() {}
    };
    DEF_ITEMTRAITSF(EasyKeepStone, "it-easykeepstone", it_easykeepstone,
                itf_invisible | itf_fireproof);
}

/* -------------------- SingleKillStone -------------------- */
namespace
{
    class OnePKillStone : public Item {
        CLONEOBJ (OnePKillStone);
        DECL_ITEMTRAITS;

        virtual Value message (const Message &m) {
            if (m.message == "_init") {
                if (server::SingleComputerGame)
                    KillStone (get_pos());
                kill();
                return Value();
            }
            return Item::message(m);
        }
    public:
        OnePKillStone () {}
    };
    DEF_ITEMTRAITSF(OnePKillStone, "it-1pkillstone", it_1pkillstone,
                itf_invisible | itf_fireproof);

    class TwoPKillStone : public Item {
        CLONEOBJ (TwoPKillStone);
        DECL_ITEMTRAITS;

        virtual Value message (const Message &m) {
            if (m.message == "_init") {
                if (!server::SingleComputerGame)
                    KillStone (get_pos());
                kill();
                return Value();
            }
            return Item::message(m);
        }
    public:
        TwoPKillStone () {}
    };
    DEF_ITEMTRAITSF(TwoPKillStone, "it-2pkillstone", it_2pkillstone,
                itf_invisible | itf_fireproof);
}


/* -------------------- it-surprise -------------------- */
namespace
{

    class SurpriseItem : public Item {
        CLONEOBJ(SurpriseItem);
        DECL_ITEMTRAITS;

        void on_drop (Actor *) {
            static char *items[] = {
                "it_umbrella",
                "it_spring_keep",
                "it-dynamite",
                "it_coffee",
                "it_hammer"
            };
            replace(items[enigma::IntegerRand (0, 4)]);
        }
    public:
        SurpriseItem() {
        }
    };
    DEF_ITEMTRAITS(SurpriseItem, "it-surprise", it_surprise);
}

/* -------------------- Drop -------------------- */

namespace
{
    Actor *replace_actor (Actor *olda, Actor *newa)
    {
        ActorInfo *info = newa->get_actorinfo();
        info->pos = olda->get_pos();
        info->vel = olda->get_vel();

        if (Value v = olda->getAttr("owner")) {
            player::ReplaceActor((int)v, olda, newa);
        }

        AddActor (newa);
        if (!YieldActor (olda)) {
            enigma::Log << "Strange: could not remove old actor\n";
        }
        olda->hide();
        newa->show();
        return olda;
    }

    class DropCallback : public enigma::TimeHandler {
        Actor *rotor;
        Actor *old;
    public:
        DropCallback (Actor *rotor_, Actor *old_)
        : rotor (rotor_), old (old_)
        {}

        // TimerHandler interface
        virtual void alarm()
        {
            replace_actor (rotor, old);

            delete rotor;
            delete this;
        }
    };

    class Drop : public Item {
        CLONEOBJ (Drop);
        DECL_ITEMTRAITS;

        ItemAction activate(Actor *a, GridPos)
        {
            const double ROTOR_LIFETIME = 5.0;

            int     iplayer = a->getAttr("owner");
            ActorID id      = get_id (a);

            if (id == ac_marble_black || id == ac_marble_white) {
                // Kill ALL rubberbands connected with the actor:
                SendMessage(a, "disconnect");
                Actor *rotor = MakeActor("ac_rotor");
                rotor->setAttr("adhesion", 1.0);
                rotor->setAttr("controllers", iplayer+1);
                rotor->setAttr("owner", iplayer);
                rotor->setAttr("gohome", false);
                rotor->setAttr("essential", a->getAttr("essential"));
                std::string essId;
                if (Value v = a->getAttr("essential_id")) {
                    essId = v.to_string();
                } else {
                    essId = a->get_traits().name;
                }
                rotor->setAttr("essential_id", Value(essId));

                replace_actor (a, rotor);

                GameTimer.set_alarm (new DropCallback (rotor, a),
                                            ROTOR_LIFETIME,
                                            false);
            }
            return ITEM_KILL;	       // remove from inventory
        }

    public:
        Drop() {}
    };
    DEF_ITEMTRAITS(Drop, "it-drop", it_drop);
}

/* -------------------- Functions -------------------- */

void InitItems()
{
    RegisterItem (new BlackBomb);
    RegisterItem (new BlackBombBurning);
    RegisterItem (new Booze);
    RegisterItem (new BrokenBooze);
    Burnable::setup();
    RegisterItem (new Debris);
    RegisterItem (new Drop);
    RegisterItem (new Dummyitem);
    RegisterItem (new Dynamite);
    RegisterItem (new EasyKillStone);
    RegisterItem (new EasyKeepStone);
    RegisterItem (new Explosion1);
    RegisterItem (new Explosion2);
    RegisterItem (new Explosion3);
    RegisterItem (new FlagBlack);
    RegisterItem (new FlagWhite);
    RegisterItem (new Odometer);
    RegisterItem (new OnePKillStone);
    RegisterItem (new OxydBridge);
    RegisterItem (new OxydBridgeActive);
    RegisterItem (new SurpriseItem);
    RegisterItem (new TwoPKillStone);
    RegisterItem (new WhiteBomb);
}

} // namespace enigma
