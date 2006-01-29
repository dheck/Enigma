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

#include "gui/widgets.hh"
#include "sound.hh"
#include "video.hh"
#include "options.hh"
#include "nls.hh"
#include "ecl.hh"
#include <cassert>
#include <algorithm>
#include <iostream>

using namespace enigma::gui;
using namespace ecl;
using namespace std;

#define SCREEN ecl::Screen::get_instance()

/* -------------------- Widget -------------------- */

Widget::Widget(Container *parent)
: area(), m_parent(parent), m_listener(0)
{}

void Widget::invalidate() {
    if (m_parent)
        m_parent->invalidate_area(get_area());
}
void Widget::invalidate_area(const ecl::Rect& r) {
    if (m_parent)
        m_parent->invalidate_area(r);
}

void Widget::reconfigure()
{
    if (m_parent)
        m_parent->reconfigure_child(this);
}

void Widget::invoke_listener() {
    if (m_listener)
        m_listener->on_action(this);
}

void Widget::move(int x, int y) { 
    area.x = x; area.y = y; 
}

void Widget::resize (int w, int h) { 
    area.w = w; area.h = h; 
}

/* -------------------- Image -------------------- */

void Image::draw (ecl::GC &gc, const ecl::Rect &/*r*/) {
    if (ecl::Surface *s = enigma::GetImage(imgname.c_str()))
        blit(gc, get_x(), get_y(), s);
}


/* -------------------- AreaManager -------------------- */

AreaManager::AreaManager(Container *c)
    : top_container(c)
{
    assert(top_container->get_parent() == 0); // otherwise it's not the top_container
}

void AreaManager::invalidate_area(const ecl::Rect &r) {
    dirtyrects.add(r);
}

void AreaManager::invalidate_all() {
    dirtyrects.clear();
    dirtyrects.push_back(SCREEN->size());
}

void AreaManager::refresh() {
    if (!dirtyrects.empty()) {
        video::HideMouse();
        GC gc(SCREEN->get_surface());
        for (RectList::iterator i = dirtyrects.begin(); i!=dirtyrects.end(); ++i) {
            top_container->draw(gc, *i);
            SCREEN->update_rect(*i);
        }
        video::ShowMouse();
        dirtyrects.clear();
    }
}

/* -------------------- Container -------------------- */

Container::Container()
    : managed_by(0)
{
}
Container::~Container() {
    clear();
    delete managed_by;
}

AreaManager *Container::getAreaManager() {
    if (Container *p = get_parent()) {
        assert(!managed_by);
        return p->getAreaManager();
    }

    if (!managed_by) {
        managed_by = new AreaManager(this);
    }
    return managed_by;
}

void Container::invalidate_area(const ecl::Rect &r) { getAreaManager()->invalidate_area(r); }
void Container::invalidate_all() { getAreaManager()->invalidate_all(); }
void Container::refresh() { getAreaManager()->refresh(); }

void Container::clear() {
    delete_sequence(m_widgets.begin(), m_widgets.end());
    m_widgets.clear();
}

void Container::add_child (Widget *w) {
    if (w && w != this) {
        m_widgets.push_back(w);
        w->set_parent(this);
//         w->move (get_x() + w->get_x(),
//                  get_y() + w->get_y());
    }
}


void Container::draw (ecl::GC& gc, const ecl::Rect &r) {
    for (iterator i=begin(); i!=end(); ++i) {
        Widget *w = *i;
        Rect rr = intersect(r, w->get_area());
        clip(gc, rr);
        w->draw(gc,rr);
    }
}

void Container::reconfigure_child (Widget *)
{
}


Widget * Container::find_widget(int x, int y) {
    for (iterator i=begin(); i!=end(); ++i) {
        Widget *w = *i;
        if (w->get_area().contains(x,y)) {
            Container *c = dynamic_cast<Container *> (w);
            if (c) {
                w = c->find_widget (x, y);
                return w ? w : c;
            }
            return w;
        }
    }
    return 0;
}

Widget * Container::find_adjacent_widget(Widget *from, int x, int y) {
    // valid values for x/y : 1/0, -1/0, 0/1, 0/-1
    assert(from && x>=-1 && x<=1 && y>=-1 && y<=1 && abs(x+y) == 1);

    if (!from) return 0;

    int       best_distance = INT_MAX;
    Widget   *best_widget   = 0;
    ecl::Rect  farea         = from->get_area();

    for (iterator i=begin(); i!=end(); ++i) {
        Widget   *w        = *i;
        ecl::Rect  warea    = w->get_area();
        bool      adjacent = true;
        int       distance = 0;

        if (x) { // check for y-overlap
            if (farea.y>(warea.y+warea.h-1) || warea.y>(farea.y+farea.h-1)) {
                adjacent = false;
            }
            else {
                distance = (warea.x-farea.x)*x;
            }
        }
        else { // check for x-overlap
            if (farea.x>(warea.x+warea.h-1) || warea.x>(farea.x+farea.h-1)) {
                adjacent = false;
            }
            else {
                distance = (warea.y-farea.y)*y;
            }
        }

        if (adjacent && distance>0 && distance<best_distance) {
            best_distance = distance;
            best_widget   = w;
        }
    }

    return best_widget;
}

void Container::move (int x, int y) {
    Rect a = get_area();
    a.x = x;
    a.y = y;
    this->set_area (a);

    int dx = x-get_x();
    int dy = y-get_y();

    for (iterator i=begin(); i!=end(); ++i) {
        Widget *w = *i;
        w->move(dx + w->get_x(), dy+w->get_y());
    }
}

ecl::Rect Container::boundingbox() {
    if (!m_widgets.empty()) {
        iterator i=begin();
        Rect bbox=(*i)->get_area();
        for (++i; i!=end(); ++i)
            bbox = ecl::boundingbox(bbox, (*i)->get_area());
        return bbox;
    } else
        return get_area();
}


/* -------------------- List -------------------- */

List::List (int spacing) 
: m_spacing(spacing),
  has_default_size (false),
  defaultw (0),
  defaulth (0),
  m_halign (HALIGN_LEFT),
  m_valign (VALIGN_TOP)
{}

void List::set_spacing (int pixels)
{
    m_spacing = pixels;
}

int List::get_spacing () const
{
    return m_spacing;
}

int List::calc_minimum_height() const
{
    int sum=0;
    const WidgetList &wl = m_widgets;
    if (!wl.empty()) {
        sum = (wl.size() - 1) * m_spacing;
        for (WidgetList::const_iterator i=wl.begin(); i!=wl.end(); ++i) {
            int nw, nh;
            get_size (*i, nw, nh);
            sum += nh;
        }
    }
    return sum;
}

int List::calc_minimum_width () const
{
    int sum=0;
    const WidgetList &wl = m_widgets;
    if (!wl.empty()) {
        sum = (wl.size() - 1) * m_spacing;
        for (WidgetList::const_iterator i=wl.begin(); i!=wl.end(); ++i) {
            int nw, nh;
            get_size (*i, nw, nh);
            sum += nw;
        }
    }
    return sum;
}

void List::set_default_size (int w, int h)
{
    has_default_size = true;
    defaultw = w;
    defaulth = h;
}


void List::get_size (const Widget *widget, int &w, int &h) const 
{
    if (has_default_size)
        w = defaultw, h = defaulth;
    else
        widget->naturalsize (w, h);
}

void List::resize (int w, int h)
{
    Container::resize (w, h);
    recalc();
}

void List::move (int x, int y)
{
    Container::move (x, y);
//    recalc();
}

void List::reconfigure_child (Widget *w)
{
    Container::reconfigure_child (w);
    recalc();
    invalidate();
}

void List::add_back (Widget *w, ExpansionMode m)
{
    add_child (w);
    m_expansionmodes.push_back (m);
    recalc();
}

void List::set_alignment (HAlignment halign, VAlignment valign)
{
    if (halign != m_halign || valign != m_valign) {
        m_halign = halign;
        m_valign = valign;
        recalc();
    }
}




/* -------------------- HList -------------------- */

void HList::recalc()
{
    int targetw = this->get_w(); // The available space
    int naturalw= calc_minimum_width();
    int excessw = targetw - naturalw;

    int num_expand = std::count (m_expansionmodes.begin(),
                                 m_expansionmodes.end(),
                                 List::EXPAND);

    WidgetList::iterator i = m_widgets.begin(),
        end = m_widgets.end();
    int x = get_x(), y = get_y();
    size_t j = 0;

    if (num_expand == 0 && excessw > 0) {
        switch (m_halign) {
        case HALIGN_CENTER:
            x += excessw / 2;
            excessw = 0;
            break;
        default:
            break;
        }
    }

    for (; i != end; ++i, ++j) {
        int w, h;
        List::get_size (*i, w, h);

        if (excessw > 0 && m_expansionmodes[j] == List::EXPAND) {
            w += excessw / num_expand;
            excessw -= excessw / num_expand;
            num_expand -= 1;
        }
        (*i)->move (x, y);
        (*i)->resize (w, get_h());
        x += w + get_spacing();
    }
}


/* -------------------- Label -------------------- */

Label::Label (const std::string &text,
              HAlignment halign, 
              VAlignment valign)
: m_text (text),
  m_font(enigma::GetFont("menufont")),
  m_halign(halign),
  m_valign(valign)
{}


void Label::set_text (const std::string &text) {
    if (text != m_text) {
        m_text = text;
        reconfigure();
        invalidate();
    }
}

void Label::set_font (ecl::Font *font) {
    if (m_font != font) {
        m_font = font;
        reconfigure();
        invalidate();
    }
}

void Label::draw (ecl::GC &gc, const ecl::Rect &) 
{
    Font *f = m_font;
    int w, h;
    naturalsize (w, h);

    int x = get_x(), y=get_y();
    switch (m_halign) {
    case HALIGN_LEFT: break;
    case HALIGN_RIGHT: x += get_w() - w; break;
    case HALIGN_CENTER: x += (get_w()-w)/2; break;
    }
    switch (m_valign) {
    case VALIGN_TOP: break;
    case VALIGN_BOTTOM: y += get_h() - h; break;
    case VALIGN_CENTER: y += (get_h()-h)/2; break;
    }
    // translate if not an empty string
    f->render (gc, x, y, m_text == "" ? "" : _(m_text.c_str()));
}

void Label::set_alignment (HAlignment halign, VAlignment valign) {
    if (halign != m_halign || valign != m_valign) {
        m_halign = halign;
        m_valign = valign;
        invalidate();
    }
}

void Label::naturalsize (int &w, int &h) const
{
    h = m_font->get_height();
    // width of translation if not an empty string
    w = m_font->get_width (m_text == "" ? "" : _(m_text.c_str()));
}


/* -------------------- Button -------------------- */

Button::Button() : m_activep (false) {
}

void Button::activate() 
{
    sound::SoundEvent ("menuswitch");
    m_activep = true;
    invalidate();
}

void Button::deactivate() {
    m_activep = false;
    invalidate();
}

void Button::draw(ecl::GC &gc, const ecl::Rect &r) {
    const int borderw = 4;

    ecl::Surface *s = enigma::GetImage (m_activep ? "buttonhl" : "button");

    if (s) {                    // Ugly, but hey, it works
        set_color (gc, 0,0,0);
        Rect srcrect (0,0,borderw, borderw);
        Rect area = get_area();

        // background
        box (gc, smaller(area, borderw));

        // corners
        blit (gc, area.x, area.y, s, srcrect);
        srcrect.x += s->width()-borderw;
        blit (gc, area.x+area.w-borderw, area.y, s, srcrect);
        srcrect.x = 0;
        srcrect.y += s->height()-borderw;
        blit (gc, area.x, area.y+area.h-borderw, s, srcrect);
        srcrect.x += s->width()-borderw;
        blit (gc, area.x+area.w-borderw, area.y+area.h-borderw, s, srcrect);

        // horizontal borders
        {
            int tilew = s->width() - 2*borderw;
            int ntiles = (area.w - 2*borderw) / tilew;
            int x = area.x + borderw;
            for (int i=0; i<ntiles; ++i) {
                blit (gc, x, area.y, s, Rect (borderw, 0, tilew, borderw));
                blit (gc, x, area.y+area.h-borderw, s,
                      Rect (borderw, s->height()-borderw, tilew, borderw));
                x += tilew;
            }
            int restw = (area.w - 2*borderw) - tilew*ntiles;
            blit (gc, x, area.y, s, Rect (borderw, 0, restw, borderw));
            blit (gc, x, area.y+area.h-borderw, s,
                  Rect (borderw, s->height()-borderw, restw, borderw));
        }
        // vertical borders
        {
            int tileh = s->height() - 2*borderw;
            int ntiles = (area.h - 2*borderw) / tileh;
            int y = area.y + borderw;
            for (int i=0; i<ntiles; ++i) {
                blit (gc, area.x, y, s, Rect (0, borderw, borderw, tileh));
                blit (gc, area.x+area.w-borderw, y, s,
                      Rect (s->width()-borderw, borderw, borderw, tileh));
                y += tileh;
            }
            int resth = (area.h - 2*borderw) - tileh*ntiles;
            blit (gc, area.x, y, s, Rect (0, borderw, borderw, resth));
            blit (gc, area.x+area.w-borderw, y, s,
                  Rect (s->width()-borderw, borderw, borderw, resth));
        }
    }
    else {
        set_color (gc, 0,0,0);
        box (gc, r);
        set_color (gc, 160,160,160);
        frame (gc, r);
        frame (gc, smaller(r, 1));
    }
}


/* -------------------- PushButton -------------------- */

PushButton::PushButton() : m_pressedp (false) {
}

bool PushButton::on_event(const SDL_Event &e) {
    bool was_pressed = m_pressedp;

    switch (e.type) {
    case SDL_KEYDOWN:
        if (e.key.keysym.sym != SDLK_RETURN &&
            e.key.keysym.sym != SDLK_SPACE) break;
        // fall-through
    case SDL_MOUSEBUTTONDOWN:
        m_pressedp = true;
        break;

    case SDL_KEYUP:
        if (e.key.keysym.sym != SDLK_RETURN &&
            e.key.keysym.sym != SDLK_SPACE) break;
        // fall-through
    case SDL_MOUSEBUTTONUP:
        m_pressedp = false;
        break;
    }

    bool changed = (was_pressed != m_pressedp);
    if (changed) {
        invalidate();
        if (!m_pressedp) {
            sound::SoundEvent ("menuok");
            invoke_listener();
        }
    }

    return changed;
}

void PushButton::deactivate() {
    m_pressedp = false;
    invalidate();
    Button::deactivate();
}


/* -------------------- TextButton -------------------- */

ecl::Font *TextButton::menufont = 0;
ecl::Font *TextButton::menufont_pressed = 0;

TextButton::TextButton(ActionListener *al) {
    if (menufont == 0) {
        menufont = enigma::GetFont("menufont");
        menufont_pressed = enigma::GetFont("menufontsel");
    }
    set_listener(al);
}

void TextButton::draw(ecl::GC &gc, const ecl::Rect &r) {
    Button::draw(gc,r);
    Font   *f    = is_pressed() ? menufont_pressed : menufont;
    string  text = get_text();
    int     h    = f->get_height();
    int     w    = f->get_width(text.c_str());
    int     x    = get_x() + (get_w()-w)/2;
    int     y    = get_y() + (get_h()-h)/2;

    f->render (gc, x, y, text.c_str());
}


/* -------------------- StaticTextButton -------------------- */

StaticTextButton::StaticTextButton(const string &t, ActionListener *al)
    : TextButton(al),
      text(t)
{
}

void StaticTextButton::set_text(const std::string &t) {
    if (t != text) {
        text = t;
        invalidate();
    }
}

string StaticTextButton::get_text() const {
    return _(text.c_str());   // translate
}

/* -------------------- UntranslatedStaticTextButton -------------------- */

UntranslatedStaticTextButton::UntranslatedStaticTextButton(const string &t, 
        ActionListener *al)
    : StaticTextButton(t, al)
{
}


string UntranslatedStaticTextButton::get_text() const {
    return StaticTextButton::text;
}


/* -------------------- Buttons for Options -------------------- */

BoolOptionButton::BoolOptionButton(const char    *option_name,
                                   const string&  true_text, const string& false_text,
                                   ActionListener *al)
    : TextButton(al),
      optionName(option_name),
      trueText(true_text),
      falseText(false_text)
{
}

bool BoolOptionButton::toggle() {
    bool newval = !enigma_options::GetBool(optionName);
    enigma_options::SetOption(optionName, newval);
    invalidate();
    return newval;
}

void BoolOptionButton::on_action(Widget *) {
    toggle();
}

string BoolOptionButton::get_text() const {
    return enigma_options::GetBool(optionName) ? _(trueText.c_str()) : _(falseText.c_str());
}
    

/* -------------------- ValueButton -------------------- */

ValueButton::ValueButton(int min_value_, int max_value_)
: TextButton(this),
  min_value(min_value_),
  max_value(max_value_)
{
}

void ValueButton::init() {
    update_value(-1, get_value()); // fixes wrong values (e.g. from .enimarc)
}

bool ValueButton::inc_value(int offset) {
    int old_value = get_value();
    return update_value(old_value, old_value+offset);
}

string ValueButton::get_text() const {
    return get_text(get_value());
}

bool ValueButton::update_value(int old_value, int new_value) {
    new_value = Clamp(new_value, min_value, max_value);
    if (new_value != old_value) {
        set_value(new_value);
        invalidate();
        return true;
    }
    return false;
}

bool ValueButton::on_event (const SDL_Event &e) {
    // handles button movement and
    bool handled = PushButton::on_event(e);

    if (e.type == SDL_KEYDOWN) {
        bool keyhandled   = true;
        bool changed = false;

        switch (e.key.keysym.sym) {
        case SDLK_PAGEUP: changed = inc_value(1); break;
        case SDLK_PAGEDOWN:  changed = inc_value(-1); break;
        default : keyhandled = false; break;
        }

        if (keyhandled) {
            handled = true;
            sound::SoundEvent (changed ? "menuswitch" : "menustop");
        }
    }
    return handled;
}

void ValueButton::on_action(Widget *) {
    if (!inc_value(1))
        update_value(get_value(), min_value);
}


/* -------------------- ImageButton -------------------- */

ImageButton::ImageButton(const string &unselected,
                         const string &selected,
                         ActionListener *al)
: fname_sel(selected), fname_unsel(unselected)
{
    set_listener(al);
}

void ImageButton::draw(ecl::GC &gc, const ecl::Rect &r) {
    Button::draw(gc, r);
    string &fname = is_pressed() ? fname_sel : fname_unsel;

    if (Surface *s = enigma::GetImage(fname.c_str())) {
        int w=s->width();
        int h=s->height();
        int x = get_x() + (get_w()-w)/2;
        int y = get_y() + (get_h()-h)/2;
        blit(gc, x, y, s);
    }
}


/* -------------------- Menu -------------------- */

Menu::Menu()
: active_widget(0), quitp(false), abortp(false) {
}

void Menu::add(Widget *w) {
    Container::add_child(w); 
}

void Menu::add(Widget *w, ecl::Rect r) {
    w->move (r.x, r.y);
    w->resize (r.w, r.h);
    add(w);
}


void Menu::quit() {
    quitp=true;
}

void Menu::abort() {
    abortp=true;
}

bool Menu::manage() {
    draw_all();
    quitp=abortp=false;
    while (!(quitp || abortp)) {
        SCREEN->flush_updates();
        SDL_Event e;
        while (SDL_PollEvent(&e)) {
            handle_event(e);
        }
        refresh();
        SDL_Delay(10);
        if(active_widget) active_widget->tick(0.01);
        tick (0.01);
    }
    sound::SoundEvent ("menuexit");
    return !abortp;
}

void Menu::goto_adjacent_widget(int xdir, int ydir) {
    Widget *next_widget = 0;
    if (active_widget) {
        next_widget = find_adjacent_widget(active_widget, xdir, ydir);
    }
    else { // no active_widget yet
        if ((xdir+ydir)>0) { // take first
            next_widget = *begin();
        }
        else { // take last
            iterator e = end();
            for (iterator i = begin(); i != e; ++i) {
                next_widget = *i;
            }
        }
    }

    if (next_widget) {
        switch_active_widget(next_widget);
    }
    else { // no more widgets into that direction found
        sound::SoundEvent ("menustop");
    }
}

void Menu::handle_event(const SDL_Event &e) 
{
    if (e.type == SDL_KEYDOWN && 
        e.key.keysym.sym == SDLK_RETURN && 
        e.key.keysym.mod & KMOD_ALT)
    {
        video::ToggleFullscreen();
        return;
    }

    if (on_event(e))
        return;

    switch (e.type) {
    case SDL_QUIT:
        abort();
        break;
    case SDL_MOUSEMOTION:
        track_active_widget( e.motion.x, e.motion.y );
        break;
    case SDL_KEYDOWN:
        if (!active_widget || !active_widget->on_event(e)) {
            // if not handled by active_widget
            switch (e.key.keysym.sym) {
            case SDLK_ESCAPE:
                abort();
                break;
            case SDLK_DOWN:  goto_adjacent_widget( 0,  1); break;
            case SDLK_UP:    goto_adjacent_widget( 0, -1); break;
            case SDLK_RIGHT: goto_adjacent_widget( 1,  0); break;
            case SDLK_LEFT:  goto_adjacent_widget(-1,  0); break;
            default:
                break;
            }
        }

        break;
    case SDL_MOUSEBUTTONDOWN:
    case SDL_MOUSEBUTTONUP:
        track_active_widget( e.button.x, e.button.y );
        if (active_widget) active_widget->on_event(e);
        break;
    case SDL_VIDEOEXPOSE:
        draw_all();
        break;
    default:
        if (active_widget) active_widget->on_event(e);
    }
}

void Menu::switch_active_widget(Widget *to_activate) {
    if (to_activate != active_widget) {
        if (active_widget)
            active_widget->deactivate();
        if (to_activate)
            to_activate->activate();
        active_widget = to_activate;
    }
}

void Menu::track_active_widget( int x, int y ) {
    switch_active_widget(find_widget(x, y));
}


void Menu::center() {
    if (m_widgets.size() > 0) {
        using std::min;
        using std::max;

        Rect a = m_widgets[0]->get_area();
        for (unsigned i=1; i<m_widgets.size(); ++i)
        {
            Rect r = m_widgets[i]->get_area();
            a.x = min(r.x, a.x);
            a.y = min(r.y, a.y);
            a.w += max(0, r.x+r.w-a.x-a.w);
            a.h += max(0, r.y+r.h-a.y-a.h);
        }
        Rect c=ecl::center(SCREEN->size(), a);
        int dx = c.x-a.x;
        int dy = c.y-a.y;

        for (unsigned i=0; i<m_widgets.size(); ++i) {
            Rect r = m_widgets[i]->get_area();
            r.x += dx;
            r.y += dy;

            m_widgets[i]->move (r.x, r.y);
            m_widgets[i]->resize (r.w, r.h);
        }
    }
}

void Menu::draw_all() {
    invalidate_all();
    refresh();
}

void Menu::draw (ecl::GC &gc, const ecl::Rect &r)
{
    clip(gc, r);
    draw_background(gc);
    Container::draw(gc,r);
}

