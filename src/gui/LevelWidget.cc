/*
 * Copyright (C) 2002,2003,2004,2005,2006 Daniel Heck
 * Copyright (C) 2006,2007                Ronald Lamprecht
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
 
#include "gui/LevelWidget.hh"
#include "gui/LevelMenu.hh"
#include "gui/LevelInspector.hh"

#include "ecl.hh"
#include "main.hh"
#include "nls.hh"
#include "options.hh"
#include "SoundEffectManager.hh"
#include "StateManager.hh"
#include "video.hh"
#include "file.hh"
#include "lev/Proxy.hh"
#include <cassert>

using namespace ecl;
using namespace std;


namespace enigma { namespace gui {
    /* -------------------- LevelWidget -------------------- */
    
    LevelWidget::LevelWidget(bool withScoreIcons, bool withEditBorder) : 
            displayScoreIcons (withScoreIcons), displayEditBorder (withEditBorder),
            width (0), height (0), m_areas(),
            listener(0), isInvalidateUptodate (true), lastUpdate (0)
    {
        const video::VMInfo &vminfo = *video::GetInfo();
        const int vshrink = vminfo.width < 640 ? 1 : 0;
    
        buttonw = vminfo.thumbw + (vshrink?13:27);  // min should be +30 for all modes but 640x480
        buttonh = vminfo.thumbh + (vshrink?14:28);
        curIndex = lev::Index::getCurrentIndex();
        iselected = curIndex->getCurrentPosition();
        ifirst = curIndex->getScreenFirstPosition();
        preview_cache = LevelPreviewCache::instance();
        scoreMgr = lev::ScoreManager::instance();
        img_link        = enigma::GetTexture("ic-link");
        img_copy        = enigma::GetTexture("ic-copy");
        img_feather     = enigma::GetTexture("ic-feather");
        img_easy        = enigma::GetTexture("completed-easy");
        img_hard        = enigma::GetTexture("completed");
        img_obsolete    = enigma::GetTexture(("ic-obsolete" + vminfo.thumbsext).c_str());
        img_outdated    = enigma::GetTexture(("ic-outdated" + vminfo.thumbsext).c_str());
        img_unavailable = enigma::GetTexture("unavailable");
        img_par         = enigma::GetTexture("par");
        img_wrEasy      = enigma::GetTexture("ic-wr-easy");
        img_wrDifficult = enigma::GetTexture("ic-wr-difficult");
        img_border      = enigma::GetTexture(("thumbborder" + vminfo.thumbsext).c_str());
        img_editborder  = enigma::GetTexture(("editborder" + vminfo.thumbsext).c_str());
        thumbmode       = (vminfo.thumbw == 160) ? 2 : ((vminfo.thumbw == 120) ? 1 : 0);
    }
    
    void LevelWidget::syncFromIndexMgr() {
        if (curIndex != lev::Index::getCurrentIndex()) {
            curIndex = lev::Index::getCurrentIndex();
            iselected = curIndex->getCurrentPosition();
            ifirst = curIndex->getScreenFirstPosition();
            invalidate();
            sound::EmitSoundEvent ("menumove");
        } else if (iselected != curIndex->getCurrentPosition()) {
            sound::EmitSoundEvent ("menumove");            
        }
        // repair ifirst on boot and screen resolution changes
        set_selected(curIndex->getScreenFirstPosition(), 
                curIndex->getCurrentPosition());
    }

    void LevelWidget::syncToIndexMgr() {
        curIndex->setCurrentPosition(iselected);
        curIndex->setScreenFirstPosition(ifirst);
    }
        
    void LevelWidget::realize(const ecl::Rect &area_) {
        Widget::realize(area_);
        width = area_.w / buttonw;
        height = area_.h / buttonh;
    }
    
    void LevelWidget::trigger_action() {
        if (listener) {
            listener->on_action(this);
        }
    }
        
    void LevelWidget::scroll_up(int nlines) 
    {
        int newFirst = ifirst;
        int newSelected = iselected;
        for (; nlines; --nlines) {
            if (newFirst+width*height >= curIndex->size())
                break;
            newFirst += width;
            if (newSelected < newFirst)
                newSelected += width;
        }
        set_selected(newFirst, newSelected);
    }
    
    void LevelWidget::scroll_down(int nlines) 
    {
        int newFirst = ifirst;
        int newSelected = iselected;
        for (; nlines; --nlines) {
            if (newFirst == 0) { 
                break;
            } else if (newFirst < width) {
                newFirst = 0;
                if (newSelected >= width*height)
                    newSelected = width*height - 1;                
            } else {
                newFirst -= width;
                if (newSelected >= newFirst+width*height)
                    newSelected -= width;
            }
        }
        set_selected(newFirst, newSelected);
    }
    
    void LevelWidget::page_up() {
        set_selected((ifirst >= width*height ? ifirst - width*height : 0), 
                (iselected >= width*height ? iselected - width*height : 0));
        syncToIndexMgr();
    }
    
    void LevelWidget::page_down() 
    {
        int s = lev::Index::getCurrentIndex()->size() - 1;  // last position
        int lastPageFirst = (s >= width*height ? (s / width - height + 1) * width : 0);
    
        // make sure last page is shown as a whole
        int first = std::min<int> (lastPageFirst, ifirst + width*height);
        //    set_selected (first, s-1);
        set_selected(first, iselected + width*height);
        syncToIndexMgr();
    }
    
    void LevelWidget::start() { 
        set_selected(0,0); 
        syncToIndexMgr();
    }
    
    void LevelWidget::end() {
        int s = lev::Index::getCurrentIndex()->size() - 1;  // last position
        int lastPageFirst = (s >= width*height ? (s / width - height + 1) * width : 0);
        set_selected(lastPageFirst, s);
        syncToIndexMgr();
    }
    
    void LevelWidget::set_current(int newsel)
    {
        set_selected(ifirst, newsel);
    }
    
    void LevelWidget::set_selected(int newfirst, int newsel)
    {
        int numlevels = curIndex->size();
        newsel = Clamp<int> (newsel, 0, numlevels-1);
        if (newsel < 0) newsel = 0;
    
        if (newsel < newfirst)
            newfirst = (newsel/width)*width;
        if (newsel >= newfirst+width*height)
            newfirst = (newsel/width-height+1)*width;
    
        newfirst = ecl::Clamp<int>(newfirst, 0, numlevels-1);
        if (newfirst < 0) newfirst = 0;
    
        size_t oldsel = iselected;
        if (newfirst != ifirst) {
            ifirst    = newfirst;
            iselected = newsel;
    
            if (!m_areas.empty()) {
                sound::EmitSoundEvent ("menumove");
                if (oldsel != newsel) 
                    sound::EmitSoundEvent ("menuswitch");
                invalidate();
            }
        }
        else if (newsel != iselected) {
            iselected = newsel;
    
            if (!m_areas.empty()) {
                sound::EmitSoundEvent ("menuswitch");
                invalidate_area(m_areas[oldsel-ifirst]); // old selection
                invalidate_area(m_areas[iselected-ifirst]); // new selection
            }
        }
    }
                
    int LevelWidget::thumb_off(int small, int medium, int large) {
    	return (thumbmode == 2) ? large : ((thumbmode == 1) ? medium : small);
    }

    bool LevelWidget::draw_level_preview(int x, int y, int borderWidth,
            lev::Proxy *proxy, bool selected, bool isCross, bool locked,
            bool allowGeneration, bool &didGenerate) { 
        // Draw button with level preview
    
        Surface *img = preview_cache->getPreview(proxy, allowGeneration, didGenerate);
        if (img == NULL)
            return false;
   
        if (selected) {
            blit (displayEditBorder ? img_editborder : img_border, x - borderWidth, y - borderWidth);
// OPENGL            blit (gc, x, y, img);
        } else {
// OPENGL            img->set_alpha (127);
            glColor3f(0.5, 0.5, 0.5);
// OPENGL            blit (img, x, y);
            glColor3f(1, 1, 1);
// OPENGL            img->set_alpha(255);
        }

        // Shade unavailable levels
        if (locked)
            blit(img_unavailable, x, y);
    
        if (displayScoreIcons) {
            // Draw solved/changed icons on top of level preview
            // Easy/difficult mode and solved status:
            //   None: Level not beaten - no easy mode available
            //   Feather: Level not beaten - easy mode available
            //   Feather + Gold: Level beaten in normal mode - easy available
            //   Silver: Level beaten in easy mode (normal mode available)
            //   Gold: Level beaten in normal mode - easy not availabe
            //   Silver + Gold: Level beaten in all modes - easy available
            Texture useAsEasy = ecl::dummyTexture;
            Texture useAsDifficult = ecl::dummyTexture;
            if (proxy->hasEasyMode()) {
                useAsEasy = img_feather;
                if (scoreMgr->isSolved(proxy, DIFFICULTY_EASY))
                    useAsEasy = img_easy;
            }
            if (scoreMgr->isSolved(proxy, DIFFICULTY_HARD))
                useAsDifficult = img_hard;
            
            if (app.state->getInt("Difficulty") == DIFFICULTY_HARD) {
                // draw golden medal over silber medal
                blit(useAsEasy, x+thumb_off(3,3,24), y);
                blit(useAsDifficult, x+thumb_off(8,8,29), y);
            }
            else {
                // draw silver medal over golden medal
                blit (useAsDifficult, x+thumb_off(8,8,29), y);
                blit (useAsEasy, x+thumb_off(3,3,24), y);
            }
        
            // Add warning sign if level has been changed since player solved it
            if (scoreMgr->isObsolete(proxy, app.state->getInt("Difficulty")))
                blit(img_obsolete, x-2, y-2);
            else if (scoreMgr->isOutdated(proxy, app.state->getInt("Difficulty")))
                blit(img_outdated, x-2, y-2);
        
            // Add icon if worldrecord or par
            if (scoreMgr->bestScoreReached(proxy, app.state->getInt("Difficulty"))) {
                blit((app.state->getInt("Difficulty") != DIFFICULTY_HARD &&
                                proxy->hasEasyMode()) ? img_wrEasy : img_wrDifficult, 
                        x+thumb_off(5,35,59), y+thumb_off(2,5,20));
            } else if (scoreMgr->parScoreReached(proxy, app.state->getInt("Difficulty"))){
                blit(img_par, x+thumb_off(33,33,55), y+thumb_off(12,12,12));
            }
        } else {
            // Draw solved/changed icons on top of level preview
            if (isCross) 
                blit (img_link, x+4, y+4);
            else
                blit (img_copy, x+4, y+4);
        }
        return true;
    }
    
    void LevelWidget::draw(const ecl::Rect &r) {
        const video::VMInfo &vminfo = *video::GetInfo();
        const int imgw = vminfo.thumbw;       // Size of the preview images
        const int imgh = vminfo.thumbh;
        const int bwidth = vminfo.thumbborder_width;
    
        const int hgap = Max(0, (get_w() - width*buttonw) / (width));
        const int vgap = Max(0, (get_h() - height*buttonh)/ (height-1));
    
        unsigned i=ifirst;          // level index
        bool allowGeneration = true;
    
        for (int y=0; y<height; y++) {
            for (int x=0; x<width; x++, i++) {
                if (i >= curIndex->size())
                    goto done_painting;
    
                int xpos = get_x() + hgap/2 + x*(buttonw + hgap);
                int ypos = get_y() + y*(buttonh + vgap);
    
                Rect buttonarea(xpos, ypos, buttonw, buttonh);
                if (!(r.overlaps(buttonarea) || r.w == 0))
                    continue;       // r.w==0 if repainting whole screen
    
                if( (i-ifirst) >= m_areas.size()) {
                    m_areas.push_back(buttonarea);
                    pending_redraws.push_back(false);
                } else {
                    m_areas[(i-ifirst)] = buttonarea;
                }
                // Draw level preview
                lev::Proxy *levelProxy = curIndex->getProxy(i);
                int imgx = xpos + (buttonw-imgw)/2;
                int imgy = ypos + bwidth;
                if (levelProxy != NULL) {
                    bool didGenerate;
                    bool didDraw = draw_level_preview(imgx, imgy, bwidth, levelProxy, 
                            i == iselected, !curIndex->isSource(levelProxy), 
                            !curIndex->mayPlayLevel(i+1),
                            allowGeneration, didGenerate);
                    if (didGenerate) {
                        // do not generate more than 1 preview from level source
                        // per draw call
                        allowGeneration = false;
                    }
                    if (didDraw) {
                        pending_redraws[(i-ifirst)] = false;
                    } else {
                        // the button is not drawn - mark it to be drawn on
                        // a future tick
                        pending_redraws[(i-ifirst)] = true;
                        isInvalidateUptodate = false;
                    }
                }
                // Draw level name
                Font    *smallfnt = enigma::GetFont("levelmenu");
                Font    *altsmallfnt = enigma::GetFont("smallalternative");;
                std::string caption = levelProxy->getTitle();
                smallfnt->render(
                          xpos + buttonw/2 - ecl::Min(smallfnt->get_width(caption.c_str(), altsmallfnt)/2, (buttonw+hgap)/2),
                          imgy + imgh + 2,
                          caption, altsmallfnt, buttonw + hgap);
            }
        }
        done_painting:
        m_areas.resize(i-ifirst); // Remove unused areas (if any) from the list
        return;
    }
    
    void LevelWidget::tick(double time) {
        if (!isInvalidateUptodate) {
            // invalidate just 1 button for redraw
            bool isFirst = true;
            for (int i = 0; i < pending_redraws.size(); i++) {
                if (pending_redraws[i] == true) {
                    if (isFirst) {
                        invalidate_area(m_areas[i]);
                        isInvalidateUptodate = true;
                        isFirst = false;
                    } else {
                        isInvalidateUptodate = false;
                        return;
                    }
                }
            }
        }
    }
    
    bool LevelWidget::on_event(const SDL_Event &e) {
        bool handled = Widget::on_event(e);
    
        switch (e.type) {
            case SDL_MOUSEMOTION:
                if (get_area().contains(e.motion.x, e.motion.y)) {
                    int newsel=iselected;
                    for (unsigned i=0; i<m_areas.size(); ++i)
                        if (m_areas[i].contains(e.motion.x, e.motion.y))
                        {
                            newsel = ifirst+i;
                            break;
                        }
                    set_current(newsel);
                    handled = true;
                }
                break;
            case SDL_MOUSEBUTTONDOWN:
                if (get_area().contains(e.button.x, e.button.y))
                    handled = handle_mousedown (&e);
                break;
            case SDL_KEYDOWN:
                handled = handle_keydown (&e);
                break;
        }
        syncToIndexMgr();
        return handled;
    }
    
    bool LevelWidget::handle_mousedown(const SDL_Event *e) {
        switch (e->button.button) {
            case SDL_BUTTON_LEFT:
                for (unsigned i=0; i<m_areas.size(); ++i)
                    if (m_areas[i].contains(e->button.x, e->button.y))
                    {
                        sound::EmitSoundEvent ("menuok");
                        iselected = ifirst+i;
                        syncToIndexMgr();
                        if (SDL_GetModState() & KMOD_CTRL && !(SDL_GetModState() & KMOD_SHIFT)) {
                            // control key pressed - level inspector
                            LevelInspector m(curIndex->getProxy(iselected));
                            m.manage();
                            get_parent()->draw_all();
                        } else {
                            // no control key - start level
                            trigger_action();
                        }
                        return true;
                    }
                break;
            case SDL_BUTTON_RIGHT: 
                for (unsigned i=0; i<m_areas.size(); ++i)
                    if (m_areas[i].contains(e->button.x, e->button.y))
                    {
                        sound::EmitSoundEvent ("menuok");
                        iselected = ifirst+i;
                        syncToIndexMgr();
                        LevelInspector m(curIndex->getProxy(iselected));
                        m.manage();
                        get_parent()->draw_all();
                        return true;
                    }
                break;
            case 4: scroll_down(1); return true;
            case 5: scroll_up(1); return true;
        }
        return false;
    }
    
    bool LevelWidget::handle_keydown(const SDL_Event *e) {
        switch (e->key.keysym.sym) {
            case SDLK_t:
                // Generate new level preview for current level
                preview_cache->updatePreview(curIndex->getProxy(iselected));
                invalidate();
                break;
            
            case SDLK_LEFT:  
                if (!(SDL_GetModState() & KMOD_ALT)) {
                    set_current (iselected>1 ? iselected-1 : 0); 
                    break;
                } else
                    return false;
            case SDLK_RIGHT:
                if (!(SDL_GetModState() & KMOD_ALT)) {
                     set_current (iselected+1);
                     break;
                } else
                    return false;
            case SDLK_DOWN:  set_current (iselected+width); break;
            case SDLK_UP:    set_current (iselected>width ? iselected-width : 0); break;
            case SDLK_PAGEDOWN: page_down(); break;
            case SDLK_PAGEUP: page_up(); break;
            case SDLK_HOME: start(); break;
            case SDLK_END: end(); break;
        
            case SDLK_RETURN:
                trigger_action();
                break;
        
            default:
                return false;           // key not handled
        }
        return true;
    }
}} // namespace enigma::gui
