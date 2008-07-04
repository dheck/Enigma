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

#include "errors.hh"
#include "laser.hh"
#include "server.hh"
#include "player.hh"
#include "client.hh"
#include "main.hh"
#include "Inventory.hh"

#include "stones_internal.hh"

using namespace std;

namespace enigma {


/* -------------------- SimpleStoneTraits -------------------- */

namespace
{
    /*! This class stores some atrributes for SimpleStones.  Only one
      instance is created for each type of SimpleStone. */

    struct SimpleStoneTraits {
        string sound;           // collision sound
        bool   hollow;          // whether stone is hollow
        bool   glass;           // whether it's a glass stone

        // static list of all allocated SimpleStoneTraits (never freed yet)
        static vector<SimpleStoneTraits*> simple_stone_traits;

        SimpleStoneTraits(const string& sound_, bool hollow_, bool glass_)
        : sound(sound_) , hollow(hollow_) , glass(glass_)
        {}

    public:
        SimpleStoneTraits() {}

//         static void clear() {
//             vector<SimpleStoneTraits*>::iterator i = simple_stone_traits.begin();
//             vector<SimpleStoneTraits*>::iterator e = simple_stone_traits.end();
//             for (; i != e; ++e)
//                 delete simple_stone_traits[i];
//             simple_stone_traits.clear();
//         }

        static const SimpleStoneTraits* Register(const string& sound_, bool hollow_, bool glass_) {
            simple_stone_traits.push_back(new SimpleStoneTraits(sound_, hollow_, glass_));
            return simple_stone_traits.back();
        }
    };

    vector<SimpleStoneTraits*> SimpleStoneTraits::simple_stone_traits;
}


/* -------------------- SimpleStone -------------------- */

namespace
{
    class SimpleStone : public Stone {
    public:
        SimpleStone(const string &knd, const string & snd, 
                    bool hollow, bool is_glass)
        : Stone(knd.c_str()), 
          traits(SimpleStoneTraits::Register(snd, hollow, is_glass)),
          sunglasses(false)
        {}
    private:
        SimpleStone(const SimpleStone& other)
        : Stone(other.get_kind()), traits(other.traits),
          sunglasses(false)
        {}

        Stone *clone() { return new SimpleStone(*this); }
        void dispose() { delete this; }

        const char *collision_sound() {
            return traits->sound.c_str();
        }

        /** Different kinds of glassstones:
         *  Stone:                 visible:     invisible:   lasertransparent:
         *  st-glass               -            pass         Y
         *  st-glass1              -            pass         Y
         *  st-glass1_hole         pass         pass         Y
         *  st-glass2              -            pass         N
         *  st-glass2_hole         pass         pass         Y
         *  st-glass3              -            -            Y
         */
        StoneResponse collision_response(const StoneContact &sc) {
            if (traits->hollow)
                return STONE_PASS;
            if (sc.actor->is_invisible() && ((traits->glass && !is_kind("st-glass3")) || is_kind("st-beads")) )
                return STONE_PASS;
            return Stone::collision_response(sc);
        }

        bool is_sticky (const Actor *actor) const {
            if (traits->glass || is_kind("st-beads"))
                return !actor->is_invisible();
            return Stone::is_sticky(actor);
        }

        bool is_floating() const {
            return traits->hollow;
        }

        bool is_transparent (Direction dir) const {
            if (traits->hollow || (traits->glass && !is_kind("st-glass2")) )
                return true;
            return Stone::is_transparent(dir);
        }

        virtual Value message(const Message &m)
        {
            if (traits->hollow && m.message == "_glasses") {
                if (to_int(m.value) & 2) {  // hollow
                    if (!sunglasses) {
                        sunglasses = true;
                        set_model( "invisible");
                    }
                }
                else {
                    if (sunglasses) {
                        sunglasses = false;
                        set_model (this->get_kind());
                    }
                }
                return Value();
            }
            return Stone::message(m);
        }

        const SimpleStoneTraits *traits; // owned by simple_stone_traits
        bool sunglasses; // seen through glasses
    };
}


/* -------------------- SimpleStoneMovable -------------------- */

namespace
{
    class SimpleStoneMovable : public Stone {
    public:
        SimpleStoneMovable(const string &knd, const string & snd, bool is_glass)
        : Stone (knd.c_str()), 
          traits(SimpleStoneTraits::Register(snd, false, is_glass))
        {}

    private:
        SimpleStoneMovable(const SimpleStoneMovable& other)
        : Stone (other.get_kind()), 
          traits (other.traits)
        {}

        Stone *clone() { return new SimpleStoneMovable(*this); }
        void dispose() { delete this; }

        const char *collision_sound() {
            return traits->sound.c_str();
        }

        /** Different kinds of movable glassstones:
         *  Stone:                 visible:     invisible:   lasertransparent:
         *  st-glass_move          push         pass         Y
         *  st-glass1_move         push         push         Y
         *  st-glass2_move         push         push         N
         */
        StoneResponse collision_response(const StoneContact &sc) {
            if (traits->glass && sc.actor->is_invisible() && is_kind("st-glass_move"))
                return STONE_PASS;
            return Stone::collision_response(sc);
        }

        bool is_sticky (const Actor *actor) const {
            if (traits->glass)
                return !actor->is_invisible();
            return Stone::is_sticky(actor);
        }

        bool is_transparent (Direction dir) const {
            if (traits->glass && !is_kind("st-glass2_move"))
                return true;
            return Stone::is_transparent(dir);
        }

        const SimpleStoneTraits *traits; // owned by simple_stone_traits

        const StoneTraits &get_traits() const
        {
            static StoneTraits simple_stone_movable_traits = {
                "INVALID", st_INVALID, stf_none, material_stone, 1.0,
                MOVABLE_STANDARD
            };
            return simple_stone_movable_traits;
        }    
    };
}


/* -------------------- DummyStone -------------------- */

namespace
{
    /*! Used for debugging; Prints its own oxyd code when hit. */
    class DummyStone : public Stone {
        CLONEOBJ(DummyStone);
    public:
        DummyStone() : Stone("st-dummy") {}
    private:

        StoneResponse collision_response(const StoneContact &/*sc*/) {
            static int lastCode = -1;
            int        code     = getAttr("code");
            if (code != lastCode) {
                fprintf(stderr, "Collision with stone 0x%02x\n", code);
                lastCode = code;
            }
            return STONE_REBOUND;
        }
    };
}


/* -------------------- EasyModeStone -------------------- */

/** \page st-easymode Easy-Mode Stone

In easy game mode this stone converts the floor at its
position to fl-normal.
In normal game mode the stone kills any item at its position.
Then in both modes it kills itself.

E.g. it can be used to hide water-barriers or to insert helper
items that make the level easier in easy game mode.

\subsection easye Example
\verbatim
set_stone("st-easymode", 10,10)
\endverbatim

\ref it-easymode
*/

namespace
{
    class EasyModeStone : public Stone {
        CLONEOBJ(EasyModeStone);
        DECL_TRAITS;

        virtual Value message(const Message &m) {
            if (m.message == "_init") {
                if (server::GetDifficulty() == DIFFICULTY_EASY) {
                    SetFloor (get_pos(), MakeFloor ("fl-normal"));
                } else {
                    KillItem (get_pos());
                }
                KillStone (get_pos());
                return Value();
            }
            return Stone::message(m);
        }
    public:
        EasyModeStone() 
        {}
    };
    DEF_TRAITSM(EasyModeStone, "st-easymode", st_easymode, MOVABLE_BREAKABLE);
}


/* -------------------- Grates -------------------- */

namespace
{
    class GrateBase : public Stone {
    public:
        GrateBase(const char *kind) : Stone(kind) {}
    private:
        bool is_floating() const { return true; }
        bool is_transparent (Direction) const { return true; }

        virtual StoneResponse collision_response(const StoneContact &sc) {
            if (server::GameCompatibility == GAMET_OXYD1) {
                return STONE_PASS;
            }
            // tested with per.oxyd
            return sc.actor->is_on_floor() ? STONE_PASS : STONE_REBOUND;
        }
    };

    class Grate1 : public GrateBase {
        CLONEOBJ(Grate1);
    public:
        Grate1() : GrateBase("st-grate1") {}
    };

    class Grate2 : public GrateBase {
        CLONEOBJ(Grate2);
    public:
        Grate2() : GrateBase("st-grate2") {}
    };

    /*! Horses and small marbles can move through this stone, but
      normal marbles can't. */
    class Grate3 : public GrateBase {
        CLONEOBJ(Grate3);
    public:
        Grate3() : GrateBase("st-grate3") {}

        StoneResponse collision_response(const StoneContact &sc) {
            ActorID id = get_id(sc.actor);
            if (id == ac_horse || id == ac_meditation || id == ac_killerball)
                return STONE_PASS;
            else
                return STONE_REBOUND;
        }
    };
}


/* -------------------- Chameleon Stone -------------------- */

namespace
{
    class ChameleonStone : public Stone {
        CLONEOBJ(ChameleonStone);
        DECL_TRAITS;

        Value message(const Message &m) {
            if (m.message == "_model_reanimated") {
                init_model();
            }
            return Stone::message(m);
        }
        
        void init_model() {
            string modelname = "fl-gray";
            if (Floor *fl = GetFloor(get_pos()))
                modelname = fl->get_kind();
            set_model(modelname);
        }

        bool is_floating() const 
        { return true; }

        StoneResponse collision_response(const StoneContact &)
        { return STONE_PASS; }

    public:
        ChameleonStone() 
        {}
    };
    DEF_TRAITS(ChameleonStone, "st-chameleon", st_chameleon);
}


/* -------------------- SwapStone -------------------- */

namespace
{
    class SwapStone : public Stone, public TimeHandler {
        DECL_TRAITS;    
    public:
        SwapStone();
        ~SwapStone();
    private:
        // Object interface
        SwapStone *clone();
        void       dispose();

        // GridObject interface
        void init_model();
        void on_removal(GridPos p);

        // Stone interface
        void on_impulse (const Impulse &impulse);
        bool is_removable() const { return state == IDLE; }
        void actor_hit (const StoneContact &sc);

        // TimeHandler interface
        void alarm();

        // Variables :
        enum State { IDLE, COME, GO } state;
        YieldedGridStone *in_exchange_with;
        Direction         move_dir;
    };
    DEF_TRAITSM(SwapStone, "st-swap", st_swap, MOVABLE_IRREGULAR);
}

SwapStone::SwapStone()
: state(IDLE),
  in_exchange_with(0),
  move_dir(NODIR)
{}

SwapStone::~SwapStone() {
    GameTimer.remove_alarm(this);
}

SwapStone *SwapStone::clone() {
    SwapStone *other        = new SwapStone(*this);
    other->in_exchange_with = 0;
    return other;
}

void SwapStone::dispose() {
    if (state == COME && in_exchange_with != 0) {
        in_exchange_with->dispose();
        delete in_exchange_with;
    }
    delete this;
}

void SwapStone::on_removal(GridPos p) {
    if (state == COME) {
        GameTimer.remove_alarm(this);
        GridPos oldPos = move(get_pos(), reverse(move_dir));
        SwapStone *other = dynamic_cast<SwapStone *>(GetStone(oldPos));
        if (other != NULL) {
            other->state = IDLE;
            other->init_model();
        }
    }
    GridObject::on_removal(p);
}

/* Animation finished; put the "swapped" stone to its new position. */
void SwapStone::alarm()
{
    GridPos oldPos = move(get_pos(), reverse(move_dir));

    // Set the swapped stone (this also kills the old (inactive) swap stone)
    in_exchange_with->set_stone(oldPos);
    delete in_exchange_with;
    in_exchange_with = 0;

    state = IDLE;
    init_model();
//    sound_event ("moveslow");
}

void SwapStone::on_impulse(const Impulse& impulse) 
{
    if (state == IDLE) {
        GridPos oldp = get_pos();
        GridPos newp = move(oldp, impulse.dir);

        // never swap beyond the world and for non enigma modes do not swap to
        // border as well.
        if (IsInsideLevel(newp) &&
                (server::GameCompatibility == GAMET_ENIGMA || !IsLevelBorder(newp))) {
            Stone *other = GetStone(newp);
            if (other && other->is_removable()) {
                SwapStone *newStone = new SwapStone;
                newStone->state            = COME;
                newStone->in_exchange_with = new YieldedGridStone(other); // yields 'other'
                newStone->move_dir         = impulse.dir;

                GameTimer.set_alarm(newStone, 0.1, false);

                SetStone(newp, newStone);

                state    = GO;
                move_dir = impulse.dir;
                init_model();

                sound_event ("moveslow");
                server::IncMoveCounter(1);
            }
        }
    }
}

void SwapStone::actor_hit(const StoneContact &sc) {
    Direction dir = get_push_direction (sc);
    if (dir != NODIR) {
        send_impulse(get_pos(), dir);
    }
}

void SwapStone::init_model() {
    static const char *models_come[] = { "st-swap-w", "st-swap-s", "st-swap-e", "st-swap-n" };
    static const char *models_go[] =   { "st-swap-e", "st-swap-n", "st-swap-w", "st-swap-s" };

    const char *model = 0;
    switch (state) {
    case IDLE: model = "st-swap"; break;
    case COME: model = models_come[move_dir]; break;
    case GO:   model = models_go[move_dir]; break;
    }

    set_model(model);
}


/* -------------------- BlockStone -------------------- */

namespace
{
    class BlockStone : public Stone {
        CLONEOBJ(BlockStone);
        DECL_TRAITS;
    public:
        BlockStone()
        {}
    private:
        V2 get_center() const {
            return get_pos().center();
        }

        void on_floor_change() {
            if (Floor *fl=GetFloor(get_pos())) {
                const string &k = fl->get_kind();
                if (k=="fl-water" || k=="fl-abyss" || k == "fl-swamp") {
                    client::Msg_Sparkle (get_center());
                    KillStone(get_pos());
                }
            }
        }
    };
    DEF_TRAITSM(BlockStone, "st-block", st_block, MOVABLE_STANDARD);
    
};



// -----------------------
//      BreakableStone
// -----------------------
// base class for Stone_break, Break_Bolder, Break_acwhite and Break_acblack
//
// breakable stones can be destroyed using
// hammer, laser, dynamite, bombs or bombstones

namespace 
{
    class BreakableStone : public Stone {
    public:
        BreakableStone(const char *kind) : Stone(kind), state(IDLE) {}
        BreakableStone() : state(IDLE) {}
    protected:
        void break_me() {
            if (state == IDLE) {
                state = BREAK;
                sound_event ("stonedestroy");
                set_anim(get_break_anim());
            }
        }
        
        virtual Value message(const Message &m) {
            if (m.message =="ignite" || m.message == "_explosion" || m.message == "_bombstone") {
                break_me();
                return Value();
            }
            return Stone::message(m);
        }
    private:
        const char *collision_sound() { return "stone"; }

        void actor_hit(const StoneContact &sc) {
            if (may_be_broken_by(sc.actor))
                break_me();
        }
        void processLight(Direction d) {
            break_me();
        }
        void animcb() {
            KillStone(get_pos());
        }

        virtual string get_break_anim() const  {
            return string(get_kind())+"-anim";
        }
        virtual bool may_be_broken_by(Actor *a) const = 0;

        // variables:

        enum State { IDLE, BREAK };
        State state;
    };
}

//----------------------------------------
// Stone_break
//----------------------------------------

/** \page st-stone_break Breakable Stone

This stone can be destroyed by an actor having a
hammer and by laser, dynamite, bombs and bombstones.

\subsection stone_breake Example
\verbatim
set_stone("st-stone_break", 10,10)
\endverbatim

\image html st-stone_break.png
*/
namespace
{
    class Stone_break : public BreakableStone {
        CLONEOBJ(Stone_break);
        DECL_TRAITS;
    public:
        Stone_break(const char *kind) : BreakableStone(kind) { }
    private:
        bool may_be_broken_by(Actor *a) const {
            return player::WieldedItemIs (a, "it_hammer");
        }
    };
    DEF_TRAITSM(Stone_break, "INVALID", st_INVALID, MOVABLE_BREAKABLE);
    
    class LaserBreakable : public BreakableStone {
        CLONEOBJ (LaserBreakable);
        DECL_TRAITS;

        void actor_hit(const StoneContact &) {
        }
        bool may_be_broken_by(Actor *) const {
            return false;
        }
    public:
        LaserBreakable()
        {}
    };
    DEF_TRAITSM(LaserBreakable, "st-laserbreak", st_laserbreak, MOVABLE_BREAKABLE);
}


//----------------------------------------
// Break_bolder
//----------------------------------------

/** \page st-break_bolder Breakable Stone

This stone can be destroyed by an actor having a hammer and by laser,
dynamite, bombs and bombstones, bolder

\subsection break_bolder Example
\verbatim
set_stone("st-break_bolder", 10,10)
\endverbatim

\image html st-break_bolder.png
*/
namespace
{
    class Break_bolder : public BreakableStone {
        CLONEOBJ(Break_bolder);
        DECL_TRAITS;
    public:
        Break_bolder()
        {}
    private:
        bool may_be_broken_by(Actor *a) const {
            return player::WieldedItemIs (a, "it_hammer");
        }
        virtual Value message(const Message &m) {
            if (m.message == "_trigger") {
                break_me();
                return Value();
            }
            return BreakableStone::message(m);
        }
    };
    DEF_TRAITSM(Break_bolder, "st-break_bolder", st_break_bolder, MOVABLE_BREAKABLE);
}

//----------------------------------------
// Stone_movebreak
//----------------------------------------

/** \page st-rock3_movebreak Breakable Movable Stone

This stone can be destroyed by an actor having a
hammer and by laser, dynamite, bombs and bombstones.

\subsection stone_breake Example
\verbatim
set_stone("st-rock3_movebreak", 10,10)
\endverbatim

\image html st-rock3.png
*/
namespace
{
    class Stone_movebreak : public BreakableStone {
        CLONEOBJ(Stone_movebreak);
        DECL_TRAITS;
    public:
        Stone_movebreak()
        {}

        void processLight(Direction d) {
        }

        string get_break_anim() const  {
            return "st-rock3_break-anim";
        }
        bool may_be_broken_by(Actor *a) const {
            return player::WieldedItemIs (a, "it_hammer");
        }

        void actor_hit(const StoneContact &sc) {
            if (may_be_broken_by(sc.actor))
                break_me();
//             else
//                 maybe_push_stone (sc);
        }
        void on_impulse(const Impulse& impulse) {
            move_stone(impulse.dir);
        }

    private:
        FreezeStatusBits get_freeze_bits() { return FREEZEBIT_NO_STONE; }
    };
    DEF_TRAITSM(Stone_movebreak, "st-rock3_movebreak", st_movebreak, MOVABLE_IRREGULAR);
}

//----------------------------------------
// Break_acwhite
//----------------------------------------

/** \page st-break_acwhite Breakable Stone

This stone can be destroyed by actor (whiteball) having a
hammer and by laser, dynamite, bombs and bombstones.

\subsection break_acwhite Example
\verbatim
set_stone("st-break_acwhite", 10,10)
\endverbatim

\image html st-break_acwhite.png
*/
namespace
{
    class Break_acwhite : public BreakableStone {
        CLONEOBJ(Break_acwhite);
        DECL_TRAITS;
    public:
        Break_acwhite()
        {}
    private:
        bool may_be_broken_by(Actor *a) const {
            Value color = a->getAttr("color");
            return color && color == WHITE &&
                player::WieldedItemIs (a, "it_hammer");
        }
    };
    DEF_TRAITSM(Break_acwhite, "st-break_acwhite", st_break_acwhite, MOVABLE_BREAKABLE);
}

//----------------------------------------
// Break_acblack
//----------------------------------------

/** \page st-break_acblack Breakable Stone

This stone can be destroyed by actor (blackball) having a
hammer.

\subsection break_acblack Example
\verbatim
set_stone("st-break_acblack", 10,10)
\endverbatim

\image html st-break_acblack.png
*/
namespace
{
    class Break_acblack : public BreakableStone {
        CLONEOBJ(Break_acblack);
        DECL_TRAITS;
    public:
        Break_acblack()
        {}
    private:
        bool may_be_broken_by(Actor *a) const {
            Value color = a->getAttr("color");
            return color && color == BLACK &&
                player::WieldedItemIs (a, "it_hammer");
        }
    };
    DEF_TRAITSM(Break_acblack, "st-break_acblack", st_break_acblack, MOVABLE_BREAKABLE);
}

/* -------------------- BrickMagic -------------------- */

/** \page st-brick_magic Magic Brick Stone

This stone does initially look like a "st-brick". If touched by the
actor, having a magic wand, it turns into a "st-glass" stone and
allows lasers to go through it.

\subsection brick_magicke Example
\verbatim
set_stone("st-brick_magic", 10,10)
\endverbatim

\image html st-brick.png
*/
namespace
{
    class BrickMagic : public Stone {
        CLONEOBJ(BrickMagic);
        const char *collision_sound() {return "stone";}
    public:
        BrickMagic() : Stone("st-brick_magic") {}
    private:
        void actor_hit(const StoneContact &sc) {
            if (player::WieldedItemIs (sc.actor, "it-magicwand")) {
                sound_event ("stonepaint");
                ReplaceStone (get_pos(), MakeStone("st-glass"));
            }
        }
    };
}

/* -------------------- Stonebrush -------------------- */

/** \page st-stonebrush Brush Stone

This stone is initially invisible. If touched by an actor
having a brush it turns into a "st-rock4".

\subsection stonebrushe Example
\verbatim
set_stone("st-stonebrush", 10,10)
\endverbatim

\image html st-rock4.png
*/
namespace
{
    class Stonebrush : public Stone {
        CLONEOBJ(Stonebrush);
        const char *collision_sound() {return "stone";}
    public:
        Stonebrush() : Stone("st-stonebrush"), state(INVISIBLE) {}
    private:
        enum State { INVISIBLE, BRUSH } state;

        void actor_hit(const StoneContact &sc) {
            if( state == INVISIBLE) {
                if (player::WieldedItemIs (sc.actor, "it_brush")) {
                    sound_event ("stonepaint");
                    state = BRUSH;
                    if (server::GameCompatibility == GAMET_PEROXYD) {
                        set_model("st-likeoxydc-open");
                    }
                    else {
                        set_model("st-rock4");
                    }
                }
            }
        }
    };
}

//----------------------------------------
// Break_invisible
//----------------------------------------

/** \page st-break_invisible Brush Stone

This stone is initially invisible. If touched by an actor having a
brush it turns into a "st_stone_break".  This stone can be destroyed
by an actor having a hammer.

\subsection break_invisible Example
\verbatim
set_stone("st-break_invisible", 10,10)
\endverbatim

\image html st-stone_break.png
*/
namespace
{
    class Break_invisible : public Stone {
        CLONEOBJ(Break_invisible);
        DECL_TRAITS;
        const char *collision_sound() {return "stone";}
    public:
        Break_invisible() : state(INVISIBLE) {}
    private:
        enum State { INVISIBLE, BRUSH, DESTROY };
        State state;
        void actor_hit(const StoneContact &sc) {
            if (state == INVISIBLE) {
                if (player::WieldedItemIs (sc.actor, "it_brush")) {
                    sound_event ("stonepaint");
                    state = BRUSH;
                    set_model("st-stone_break");
                }
            }
            else if (state == BRUSH) {
                if (player::WieldedItemIs (sc.actor, "it_hammer")) {
                    sound_event ("stonedestroy");
                    state = DESTROY;
                    set_anim("st-stone_break-anim");
                }
            }
        }
        void animcb() {
            if (state == DESTROY)
                KillStone(get_pos());
        }
    };
    DEF_TRAITSM(Break_invisible, "st-break_invisible", st_break_invisible,
                MOVABLE_BREAKABLE);
}

//----------------------------------------
// Invisible Magic
//----------------------------------------

/** \page st-invisible_magic Magic Invisible Stone

This stone is initially invisible, and laserlight can pass through.
If touched by an actor having a magic wand, it will mutate into a
"st-greenbrown" and laserlight is blocked.

\subsection invisible_magice Example
\verbatim
set_stone("st-invisible_magic", 10,10)
\endverbatim

\image html st-greenbrown.png
*/
namespace
{
    class InvisibleMagic : public Stone {
        CLONEOBJ(InvisibleMagic);
        const char *collision_sound() {return "cloth";}
    public:
        InvisibleMagic() : Stone("st-invisible_magic"), state(INVISIBLE) {}
    private:
        enum State { INVISIBLE, STONE } state;

        void actor_hit(const StoneContact &sc) {
            if (state == INVISIBLE) {
                if (player::WieldedItemIs (sc.actor, "it-magicwand")) {
                    sound_event ("stonepaint");
                    state = STONE;
                    set_model("st-greenbrown");
                    MaybeRecalcLight(get_pos());
                }
            }
        }
        bool is_transparent (Direction) const { return state==INVISIBLE; }
    };
}

/* -------------------- Wooden stone -------------------- */

/** \page st-wood Wooden Stone

This stone is movable.  If moved into abyss, water or swamp it builds
a wooden plank.

\subsection woode Example
\verbatim
set_stone("st-wood", 10,10)
\endverbatim

Note: There are two flavors of st-wood which may be specified
by using st-wood1 or st-wood2, and two related kinds: st-flrock,
which creates the unburnable fl-rock and denies fire under it, and 
the burnable st-hay, which leaves the burnable but stable fl-hay
behind.

\image html st-wood.png
*/
namespace
{
    class WoodenStone : public Stone {
        CLONEOBJ(WoodenStone);
        DECL_TRAITS;
    public:
        WoodenStone(const char *kind, const char *floorkind_, bool blockfire_ = false) :
            Stone(kind), floorkind(floorkind_), blockfire(blockfire_) {}

    private:
        const char *floorkind;
        bool blockfire;

        void maybe_fall_or_stopfire() {
            GridPos p = get_pos();
            if (IsLevelBorder(p))
                return;
            if (Floor *fl = GetFloor(p)) {
                const string &k = fl->get_kind();
                if(blockfire)
                    SendMessage(fl, "stopfire");
                if (k == "fl-abyss" || k == "fl-water" || k == "fl-swamp") {
                    SetFloor(p, MakeFloor(floorkind));
                    KillStone(p);
                }
            }
        }

        virtual Value message(const Message &m) {
            if (m.message == "fire" && !blockfire) {
                KillStone(get_pos());
                return true;  // allow fire to spread
            } else if (m.message == "heat" && blockfire) {
                return true;  // block fire
            } else if (m.message == "fall") {
                maybe_fall_or_stopfire();
                return Value();
            }
            return Stone::message(m);
        }

        // in oxyd1 only fall when moving
        void on_move() {
            Stone::on_move();
            if (server::GameCompatibility == GAMET_OXYD1)
                maybe_fall_or_stopfire();
        }

        // other oxyds versions: fall everytime the floor changes
        void on_floor_change() {
            if (server::GameCompatibility != GAMET_OXYD1)
                maybe_fall_or_stopfire();
        }
    };
    DEF_TRAITSM(WoodenStone, "INVALID", st_INVALID, MOVABLE_STANDARD);

    /*! When st-wood is created it randomly becomes st-wood1 or
      st-wood2. */
    class RandomWoodenStone : public Stone {
    public:
        RandomWoodenStone() : Stone("st-wood") {}
    private:
        Stone *clone() {
            if(IntegerRand(0, 1) == 0)
                return new WoodenStone("st-wood1", "fl-stwood1");
            else
                return new WoodenStone("st-wood2", "fl-stwood2");
        }
        void dispose() {delete this;}
    };
}

//----------------------------------------
// Growing stones used by it-seed
//----------------------------------------
namespace
{
    class WoodenStone_Growing : public Stone {
        CLONEOBJ(WoodenStone_Growing);
        DECL_TRAITS;
    public:
        WoodenStone_Growing()
        {}
    private:
        void init_model() { set_anim("st-wood-growing"); }
        void animcb() {
            Stone *st = MakeStone ("st-wood");
            ReplaceStone (get_pos(), st);
            SendMessage(st, "fall"); // instantly builds a bridge on fl-swamp etc
        }
        void actor_contact(Actor *a) {SendMessage(a, "shatter");}
        void actor_inside(Actor *a) {SendMessage(a, "shatter");}
        void actor_hit(const StoneContact &sc) {SendMessage(sc.actor, "shatter");}

        FreezeStatusBits get_freeze_bits() { return FREEZEBIT_STANDARD; }
    };
    DEF_TRAITS(WoodenStone_Growing, "st-wood-growing", st_wood_growing);
    
    class GreenbrownStone_Growing : public Stone {
        CLONEOBJ(GreenbrownStone_Growing);
        DECL_TRAITS;
    public:
        GreenbrownStone_Growing()
        {}
    private:
        void init_model() { set_anim("st-greenbrown-growing"); }
        void animcb() {
            Stone *st = MakeStone("st-greenbrown");
            ReplaceStone(get_pos(), st);
        }
        void actor_contact(Actor *a) {SendMessage(a, "shatter");}
        void actor_inside(Actor *a) {SendMessage(a, "shatter");}
        void actor_hit(const StoneContact &sc) {SendMessage(sc.actor, "shatter");}
    };
    DEF_TRAITS(GreenbrownStone_Growing, "st-greenbrown-growing", st_greenbrown_growing);

    class VolcanoStone_Growing : public Stone {
        CLONEOBJ(VolcanoStone_Growing);
        DECL_TRAITS;
    public:
        VolcanoStone_Growing()
        {}
    private:
        void init_model() { set_anim("st-volcano-growing"); }
        void animcb() {
            Stone *st = MakeStone("st-volcano_active");
            ReplaceStone(get_pos(), st);
        }
        void actor_contact(Actor *a) {SendMessage(a, "shatter");}
        void actor_inside(Actor *a) {SendMessage(a, "shatter");}
        void actor_hit(const StoneContact &sc) {SendMessage(sc.actor, "shatter");}

        FreezeStatusBits get_freeze_bits() { return FREEZEBIT_NO_STONE; }
    };
    DEF_TRAITS(VolcanoStone_Growing, "st-volcano-growing", st_volcano_growing);
}



/* -------------------- FartStone -------------------- */

/** \page st-fart Fart Stone

The fart stone has the unpleasant habit of "blowing off" when
triggered (by actor contact or signal) and will close all oxyd stones.

\subsection fartm Messages

- \b trigger: as usual

*/

namespace
{
    class FartStone : public Stone {
        CLONEOBJ(FartStone);
        DECL_TRAITS;

        enum State { IDLE, FARTING, BREAKING };
        State state;
        bool rememberBreaking;  // set true if an explosion or break-message
                                // or such occured while farting

        void change_state(State newstate);
        void animcb();
        void actor_hit(const StoneContact &sc);
        virtual Value message(const Message &m);

        void processLight(Direction d) {
            change_state(BREAKING);
        }
    public:
        FartStone() : state(IDLE), rememberBreaking(false) 
        {}
    };
    DEF_TRAITSM(FartStone, "st-fart", st_fart, MOVABLE_BREAKABLE);
}

void FartStone::change_state(State newstate) 
{
    if (state == newstate)
        return;

    switch (newstate) {
    case IDLE:
        state = IDLE;
        init_model();
        if (rememberBreaking)
            change_state(BREAKING);
        break;
    case FARTING:
    case BREAKING:
        if (state == IDLE) {
            Object *ox = GetObjectTemplate("st_oxyd");
            SendMessage(ox, "closeall");
            sound_event("fart");
            if (newstate == BREAKING) {
                sound_event ("stonedestroy");
                set_anim ("st-fartbreak-anim");
            }
            else
                set_anim("st-farting");
            state = newstate;
        } else if (state == FARTING && newstate == BREAKING)
            rememberBreaking = true;
        break;
    }
}

void FartStone::animcb() 
{
    if (state == FARTING)
        change_state(IDLE);
    else if (state == BREAKING)
        KillStone(get_pos());
}

void FartStone::actor_hit(const StoneContact &sc) 
{
    if (player::WieldedItemIs (sc.actor, "it_hammer"))
        change_state(BREAKING);
    else
        change_state(FARTING);
}
Value FartStone::message(const Message &m) 
{
    if (m.message == "toggle" || (m.message == "signal" && m.value != 0) ||
            (m.message == "_trigger" && m.value.to_bool())) {
        change_state(FARTING);
        return Value();
    } else if (m.message == "ignite" || m.message == "_explosion") { 
        change_state(BREAKING);
        return Value();
    }
    return Stone::message(m);
}


/* -------------------- Thief -------------------- */
namespace
{
    /*! Steals one item from the player's inventory when hit. */
    class ThiefStone : public Stone {
        CLONEOBJ(ThiefStone);
        DECL_TRAITS;

        enum State { IDLE, EMERGING, RETREATING, CAPTURED } state;
        Actor *m_affected_actor;
        Item * bag;
    public:
        ThiefStone();
        virtual ~ThiefStone();
    private:
        void steal_from_player();

        void actor_hit(const StoneContact &sc);
        // even a slight touch should steal from the actor: 
        void actor_touch(const StoneContact &sc) { actor_hit(sc); }
        void animcb();
        virtual Value message(const Message &m);        

        const char *collision_sound() { return "cloth"; }
        int affected_player;
    };
    DEF_TRAITSM(ThiefStone, "st-thief", st_thief, MOVABLE_BREAKABLE);
}

ThiefStone::ThiefStone() 
: state(IDLE), m_affected_actor (0), affected_player (-1), bag(NULL) {}

ThiefStone::~ThiefStone() {
    if (bag != NULL)
        delete bag;
}

void ThiefStone::actor_hit(const StoneContact &sc) {
    ActorID id = get_id(sc.actor);
    if (state == IDLE) {
        set_anim("st-thief-emerge");
        state = EMERGING;
        m_affected_actor = sc.actor;
        affected_player = m_affected_actor->getDefaultedAttr("player", -1);
    }
}

void ThiefStone::animcb() {
    switch (state) {
    case EMERGING:
        steal_from_player();
        state = RETREATING;
        set_anim("st-thief-retreat");
        break;
    case RETREATING:
        state = IDLE;
        init_model();
        break;
    case CAPTURED:
        KillStone(get_pos());
        break;
    default:
        ASSERT(0, XLevelRuntime, "ThiefStone: animcb called with inconsistent state");
    }
}

void ThiefStone::steal_from_player() 
{
    // the actor that hit the thief may no longer exist!
    if (m_affected_actor && affected_player >= 0 &&
            player::HasActor(affected_player, m_affected_actor) && 
            !m_affected_actor->has_shield()) {
        enigma::Inventory *inv = player::GetInventory(m_affected_actor);
        if (inv && inv->size() > 0) {
            if (bag == NULL) {
                bag = MakeItem(it_bag);
                bag->setOwnerPos(get_pos());
            }
            int i = IntegerRand (0, int (inv->size()-1));
            dynamic_cast<ItemHolder *>(bag)->add_item(inv->yield_item(i));
            player::RedrawInventory (inv);
            sound_event("thief");
        }
    }
}

Value ThiefStone::message(const Message &m) {
    if(m.message == "signal" && server::GameCompatibility != GAMET_ENIGMA) {
        performAction(!m.value.to_bool());  // inverse signal multiplier
        return Value();
    } else if (m.message == "_capture" && state == IDLE) {
        state = CAPTURED;
        Item * it =  GetItem(get_pos());
        
        // add items on grid pos that can be picked up to our bag
        if (it != NULL && !(it->get_traits().flags & itf_static) && bag != NULL) {
            dynamic_cast<ItemHolder *>(bag)->add_item(YieldItem(get_pos()));
        }
        // drop bag if pos is not occupied by a static item
        if (GetItem(get_pos()) == NULL)
            SetItem(get_pos(), bag);
        bag = NULL;
        set_anim(string(get_kind()) + "-captured");
        return true;
    }
    return Stone::message(m);
}

//----------------------------------------
// FakeOxydStone
//----------------------------------------

/** \page st-fakeoxyd Fake Oxyd Stone

These stones look like real Oxyd stones, but they only blink a little
when touched and do not open or have other special abilities.

\image html st-fakeoxyd-blink_0001.png
*/
namespace
{
    class FakeOxydStone : public Stone {
        CLONEOBJ(FakeOxydStone);
    public:
        FakeOxydStone() : Stone("st-fakeoxyd"), state(IDLE) {
            setAttr("blinking", 0.0);
        }
    private:
        enum State { IDLE, BLINKING } state;
        void actor_hit(const StoneContact &/*sc*/) {
            if (state == IDLE) {
                set_anim("st-fakeoxyd-blink");
                sound_event ("fakeoxyd");
                state = BLINKING;
                setAttr("blinking", 1.0);
            }
        }
        const char *collision_sound() {
            return "metal";
        }
        void animcb() {
            set_model("st-fakeoxyd");
            state = IDLE;
            setAttr("blinking", 0.0);
        }
    };
}


/* -------------------- Black Stones -------------------- */
namespace
{
    class BlackWhiteStone : public Stone {
        CLONEOBJ(BlackWhiteStone);
        DECL_TRAITS_ARRAY(8, m_type);
        int m_type;

        BlackWhiteStone(int type) : m_type(type)
        {}

        StoneResponse collision_response(const StoneContact &sc) {
            Value accolor = sc.actor->getAttr("color"); 
            if (m_type < 4) {
                return (accolor && accolor == BLACK) ? 
                    STONE_PASS : STONE_REBOUND;
            }
            else {
                return (accolor && accolor == WHITE) ? 
                    STONE_PASS : STONE_REBOUND;
            }
        }

        virtual Value message(const Message &m) {
            if (m.message == "signal" || m.message == "_trigger") {
                // toggle between black and white stone
                m_type = (m_type + 4) % 8;
                init_model();
                return Value();
            }
            return Stone::message(m);
        }

        bool is_floating() const { return true; }
        bool is_transparent (Direction) const { return true; }

    public:
        static void setup() {
            for (int i=0; i<8; ++i)
                RegisterStone (new BlackWhiteStone(i));
        }
    };

    StoneTraits BlackWhiteStone::traits[8] = {
        {"st-black1", st_black1, stf_transparent, material_stone, MOVABLE_PERSISTENT},
        {"st-black2", st_black2, stf_transparent, material_stone, MOVABLE_PERSISTENT},
        {"st-black3", st_black3, stf_transparent, material_stone, MOVABLE_PERSISTENT},
        {"st-black4", st_black4, stf_transparent, material_stone, MOVABLE_PERSISTENT},
        {"st-white1", st_white1, stf_transparent, material_stone, MOVABLE_PERSISTENT},
        {"st-white2", st_white2, stf_transparent, material_stone, MOVABLE_PERSISTENT},
        {"st-white3", st_white3, stf_transparent, material_stone, MOVABLE_PERSISTENT},
        {"st-white4", st_white4, stf_transparent, material_stone, MOVABLE_PERSISTENT},
    };

}


/* -------------------- YinYang stones -------------------- */
namespace
{
    class YinYangStone : public Stone {
    public:
        YinYangStone(const char *kind) : Stone(kind)
        {}

    protected:
        void turn_white(const char *stonename = "st-white1") {
            sound_event("yinyang");
            ReplaceStone (get_pos(), MakeStone(stonename));
        }
        void turn_black(const char *stonename = "st-black1") {
            sound_event("yinyang");
            ReplaceStone (get_pos(), MakeStone(stonename));
        }
        
        FreezeStatusBits get_freeze_bits() { return FREEZEBIT_HOLLOW; }
    };

    class YinYangStone1 : public YinYangStone {
        CLONEOBJ(YinYangStone1);
    public:
        YinYangStone1() : YinYangStone("st-yinyang1") {}

    private:
        void actor_hit(const StoneContact &sc) {
            Value color = sc.actor->getAttr("color");
            if      (color && color == BLACK) turn_white();
            else if (color && color == WHITE) turn_black();
        }
    };

    class YinYangStone2 : public YinYangStone {
        CLONEOBJ(YinYangStone2);
    public:
        YinYangStone2() : YinYangStone("st-yinyang2") {}
    private:
        void actor_hit(const StoneContact &sc) {
            Value color = sc.actor->getAttr("color");
            if      (color && color == BLACK) turn_black();
            else if (color && color == WHITE) turn_white();
        }
    };


    /*! A Per.Oxyd compatible YinYang stone that must be activated
      with a magic wand or a brush. */
    class YinYangStone3 : public YinYangStone {
        CLONEOBJ(YinYangStone3);
    public:
        YinYangStone3() : YinYangStone("st-yinyang3") {}
    private:
        void actor_hit(const StoneContact &sc) {
            if (player::WieldedItemIs (sc.actor, "it-magicwand") ||
                player::WieldedItemIs (sc.actor, "it_brush"))
            {
                Value color = sc.actor->getAttr("color");
                if      (color && color == BLACK) 
                    turn_white("st-white4");
                else if (color && color == WHITE) 
                    turn_black("st-black4");
            }
        }
    };
}


/* -------------------- BombStone -------------------- */

namespace
{
    /*! This stone add a bomb to the player's inventory when touched. */
    class BombStone : public Stone {
        CLONEOBJ(BombStone);
        DECL_TRAITS;
        const char *collision_sound() {return "stone";}
    public:
        BombStone(const char* kind_, const char* itemkind_) :
            Stone(kind_), state(IDLE), itemkind(itemkind_) {}
    private:
        enum State { IDLE, BREAK };
        State state;
        const char* itemkind;
        void actor_hit (const StoneContact &sc);
        void change_state (State newstate);
        void animcb();
        virtual Value message(const Message &m);
    };
}
DEF_TRAITSM(BombStone, "INVALID", st_INVALID, MOVABLE_BREAKABLE);
    
void BombStone::change_state (State newstate) 
{
    if (state == IDLE && newstate==BREAK) {
        string model = get_kind();
        state = newstate;
        sound_event ("stonedestroy");
        set_anim(model + "-anim");
    }
}

void BombStone::animcb() 
{
    ASSERT(state == BREAK, XLevelRuntime, "BombStone: animcb called with inconsistent state");
    GridPos p = get_pos();
    SendExplosionEffect(p, EXPLOSION_BOMBSTONE);
    KillStone(p);
    if(Item *it = GetItem(get_pos())) {
        SendMessage(it, "ignite");
    } else
        SetItem(p, it_explosion1);
}

Value BombStone::message(const Message &m) 
{
    if (m.message =="_explosion" || m.message =="_bombstone") {
        change_state(BREAK);
        return Value();
    }
    return Stone::message(m);
}

void BombStone::actor_hit(const StoneContact &sc) 
{
    if (enigma::Inventory *inv = player::GetInventory(sc.actor)) {
        if (!inv->is_full()) {
            Item *it = MakeItem(itemkind);
            inv->add_item(it);
            player::RedrawInventory (inv);
        }
    }
}


/* -------------------- MagicStone -------------------- */
namespace
{
    class MagicStone : public Stone {
        CLONEOBJ(MagicStone);
        DECL_TRAITS;
        void actor_hit(const StoneContact &sc) {
            if (sc.actor->getAttr("player") && 
                sc.actor->get_vel() * sc.normal < -4)
            {
                KillStone(get_pos());
                client::Msg_ShowText ("We don't sell books..", false, 2.0);
            }
        }
    public:
        MagicStone()
        {}
    };
    DEF_TRAITSM(MagicStone, "st-magic", st_magic, MOVABLE_BREAKABLE);
}


/* -------------------- Brake stone -------------------- */

/** \page st-brake Brake

Blocks bolder stones and other movable stones.  Can be picked up.

\image html st-brake.png
*/

namespace
{
    class BrakeStone : public Stone {
        CLONEOBJ(BrakeStone);
        DECL_TRAITS;
    public:
        BrakeStone()
        {}

        void on_creation (GridPos p) {
            Stone::on_creation(p);

            Item    *it = GetItem(p);
            if (it && it->is_kind("it_blocker")) {
                KillItem(p);
//                sound_event ("explosion1");
            }
        }

        StoneResponse collision_response(const StoneContact &/*sc*/) {
            return STONE_PASS;
        }

        void actor_inside(Actor *a) {
            const double BRAKE_RADIUS = 0.3;
            GridPos      p            = get_pos();
            double       dist         = length(a->get_pos() - p.center());

            if (dist < BRAKE_RADIUS) {
                player::PickupStoneAsItem(a, p);
            }
        }

        void explode() {
            GridPos p = get_pos();
            KillStone(p);
            SetItem(p, it_explosion1);
        }

        void processLight(Direction d) {
            explode();
        }

        virtual Value message(const Message &m) {
            if (m.message == "_explosion") {
                explode();
                return Value();
            }
            return Stone::message(m);
        }

        bool is_sticky(const Actor *) const 
        { return false; }
    };
    DEF_TRAITSM(BrakeStone, "st-brake", st_brake, MOVABLE_BREAKABLE);
}


/* -------------------- Disco stones -------------------- */
namespace
{
    class DiscoStone : public Stone {
        CLONEOBJ(DiscoStone);
    public:
        DiscoStone(const char *kind) : Stone(kind) {}

        StoneResponse collision_response(const StoneContact &) {
            return STONE_PASS;
        }

        virtual void lighten() {}
        virtual void darken() {}
    protected:
        static void visit_lighten(GridPos p) {
            if (DiscoStone *st = dynamic_cast<DiscoStone*>(GetStone(p)))
                st->lighten();
        }
        static void visit_darken(GridPos p) {
            if (DiscoStone *st = dynamic_cast<DiscoStone*>(GetStone(p)))
                st->darken();
        }

    private:
        bool is_floating() const { return true; }

        virtual Value message(const Message &m) {
            if (m.message == "signal") {
                int ival = m.value;
                if (ival > 0)
                    lighten();
                else
                    darken();
                return Value();
            } else if (m.message == "lighten") {
                lighten();
                return Value();
            } else if (m.message == "darken") {
                darken();
                return Value();
            }
            return Stone::message(m);
        }
    };
    class DiscoLight : public DiscoStone {
        CLONEOBJ(DiscoLight);
        virtual void darken() {
            GridPos p = get_pos();
            SetStone (p, MakeStone("st-disco-medium"));
            visit_darken (move(p, NORTH));
            visit_darken (move(p, EAST));
            visit_darken (move(p, SOUTH));
            visit_darken (move(p, WEST));
        }
    public:
        DiscoLight() : DiscoStone("st-disco-light") {}
    };
    class DiscoMedium : public DiscoStone {
        CLONEOBJ(DiscoMedium);
    public:
        DiscoMedium() : DiscoStone("st-disco-medium") {}
        virtual void lighten() {
            GridPos p = get_pos();
            SetStone (p, MakeStone("st-disco-light"));
            visit_lighten (move(p, NORTH));
            visit_lighten (move(p, EAST));
            visit_lighten (move(p, SOUTH));
            visit_lighten (move(p, WEST));
        }
        virtual void darken() {
            GridPos p = get_pos();
            SetStone (p, MakeStone("st-disco-dark"));
            visit_darken (move(p, NORTH));
            visit_darken (move(p, EAST));
            visit_darken (move(p, SOUTH));
            visit_darken (move(p, WEST));
        }
    };

    class DiscoDark : public DiscoStone {
        CLONEOBJ(DiscoDark);
        virtual void lighten() {
            GridPos p = get_pos();
            SetStone (p, MakeStone("st-disco-medium"));
            visit_lighten (move(p, NORTH));
            visit_lighten (move(p, EAST));
            visit_lighten (move(p, SOUTH));
            visit_lighten (move(p, WEST));
        }
        virtual void darken() {}
    public:
        DiscoDark() : DiscoStone("st-disco-dark") {}
    };
}

/* -------------------- Fire breakable stones -------------------- */

/* These stones mimic the behaviour of the plain-looking stones in
   Oxyd. */
namespace
{
    class Stone_firebreak : public Stone {
        CLONEOBJ(Stone_firebreak);
        DECL_TRAITS;

        const char *collision_sound() {return "stone";}

        void break_me() {
            sound_event("stonedestroy");
            ReplaceStone(get_pos(), MakeStone("st-plain_breaking"));
        }

        virtual Value message(const Message &m) {
            if (m.message =="heat" || m.message == "fire") {
                break_me();
                return true;
            }
            return Stone::message(m);
        }

        void actor_hit(const StoneContact &sc) {
            if (player::WieldedItemIs(sc.actor, "it_brush")) {
                sound_event("stonepaint");
                ReplaceStone(get_pos(), MakeStone("st-plain"));
            } else
                Stone::actor_hit(sc);
        }

    public:
        Stone_firebreak()
        {}
    };
    DEF_TRAITSM(Stone_firebreak, "st-firebreak", st_firebreak, MOVABLE_BREAKABLE);

    class Stone_movefirebreak : public Stone {
        CLONEOBJ(Stone_movefirebreak);
        DECL_TRAITS;

        void break_me() {
            sound_event("stonedestroy");
            ReplaceStone(get_pos(), MakeStone("st-plain_breaking"));
        }

        virtual Value message(const Message &m) {
            if (m.message =="fire") {
                break_me();
                return Value();
            }
            return Stone::message(m);
        }

        void actor_hit(const StoneContact &sc) {
            if (player::WieldedItemIs(sc.actor, "it_brush")) {
                sound_event("stonepaint");
                ReplaceStone(get_pos(), MakeStone("st-plain_move"));
            } else
                Stone::actor_hit(sc);
        }

        void on_move() {
            GridPos p = get_pos();
            if (Floor *fl = GetFloor (p)) {
                if (fl->is_kind("fl-abyss")) {
                    ReplaceStone (p, MakeStone("st-plain_falling"));
                }
                else if (fl->is_kind("fl-swamp") || fl->is_kind("fl-water")) {
                    sound_event ("drown");
                    client::Msg_Sparkle (p.center());
                    KillStone (p);
                }
            }
        }

    public:
        Stone_movefirebreak() : Stone("st-firebreak") { }
        
    private:
        FreezeStatusBits get_freeze_bits() { return FREEZEBIT_NO_STONE; }        
    };
    DEF_TRAITSM(Stone_movefirebreak, "st-firebreak_move", st_firebreak_move,
                MOVABLE_IRREGULAR);
}


/* -------------------- Functions -------------------- */

void DefineSimpleStone(const std::string &kind, 
                              const std::string &sound,
                              int hollow, int glass)
{
    Register(new SimpleStone(kind, sound, hollow != 0, glass != 0));
}

void DefineSimpleStoneMovable(const std::string &kind, 
                                     const std::string &sound, 
                                     int glass)
{
    Register(new SimpleStoneMovable(kind, sound, glass != 0));
}

void Init_simple()
{
    BlackWhiteStone::setup();

    Register(new BlockStone);
    Register(new BombStone("st-bombs", "it-blackbomb"));
    //Register(new BombStone("st-dynamite", "it-dynamite"));
    //Register(new BombStone("st-whitebombs", "it-whitebomb"));
    Register(new BrakeStone);

    Register(new Break_acblack);
    Register(new Break_acwhite);
    Register(new Break_bolder);
    Register(new Break_invisible);

    Register(new BrickMagic);

    RegisterStone (new ChameleonStone);

    Register(new DiscoLight);
    Register(new DiscoMedium);
    Register(new DiscoDark);
    Register(new DummyStone);
    RegisterStone (new EasyModeStone);
    Register(new FakeOxydStone);
    Register(new FartStone);
    Register(new Grate1);
    Register(new Grate2);
    Register(new Grate3);
    Register(new InvisibleMagic);
    Register(new LaserBreakable);
    Register(new MagicStone);
    Register(new Stone_break("st-stone_break"));
    Register(new Stone_break("st-rock3_break"));
    Register(new Stone_break("st-break_gray"));
    Register(new Stone_movebreak);
    Register(new Stonebrush);
    Register(new SwapStone);

    Register(new ThiefStone);

    Register(new RandomWoodenStone); // random flavor
    Register(new WoodenStone("st-wood1", "fl-stwood1")); // horizontal planks
    Register(new WoodenStone("st-wood2", "fl-stwood2")); // vertical planks
    Register(new WoodenStone("st-flrock", "fl-rock", true));
    Register(new WoodenStone("st-flhay", "fl-hay"));
    Register(new WoodenStone_Growing);
    Register(new GreenbrownStone_Growing);
    Register(new VolcanoStone_Growing);

    Register(new YinYangStone1);
    Register(new YinYangStone2);
    Register(new YinYangStone3);

    Register(new Stone_firebreak);
    Register(new Stone_movefirebreak);
}

} // namespace enigma
