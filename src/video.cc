/*
 * Copyright (C) 2002,2004 Daniel Heck
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
 */

/*
 * This file contains the code for initializing the video hardware and
 * for various visual effects in the widest sense.  This includes
 *
 * a) managing and rendering the mouse cursor,
 * b) changing between windowed and fullscreen mode,
 * c) fading between different screen using one of a number of
 *    predefined effects.
 *
 * The code in this file is independent of the game.  For game-specific
 * display code, refer to file display.cc
 */

#include "enigma.hh"
#include "video.hh"
#include "texture.hh"
#include "lua.hh"
#include "options.hh"
#include "main.hh"
#include "ecl.hh"
#include "SDL.h"
#include <GL/gl.h>
#include <GL/glu.h>
#include <cassert>
#include <cstdio>
#include <fstream>
#include <sstream>
#include "config.h"

using namespace std;
using namespace ecl;
using namespace video;
using namespace enigma;

namespace {

std::string gCaption;
bool gInitialized = false;
ecl::Screen *gScreen = NULL;
SDL_Surface *gSdlScreen = NULL;

}


/* -------------------- Local Variables -------------------- */
namespace
{
    Surface     *back_buffer  = 0;

    /*! List of available video modes. */
    video::VMInfo video_modes[] = {
        { 
            VM_640x480, 640, 480,            // id, w, h
            32, VTS_32,                      // tilesize, tiletype
            "640x480", "VGA", "4:3",         // name, fsname, fs only
            "models-32.lua", "gfx32/",       // initscript, dir
            Rect (0, 0, 640, 480),           // display area
            0, 0,                            // menu background image offsets 
            120, 78, 4, "-120x78",           // thumbnail size/extension
            Rect (0, 0, 640, 416),           // game area
            Rect (0, 416, 640, 64),          // statusbar area
            Rect (10, 428, 117, 43),         // time area
            Rect (100, 422, 28, 43),         // modes area
            Rect (100, 425, 30, 43),         // moves area
            Rect (188, 433, 490, 52),        // inventory area
            Rect (180, 436, 444, 35),        // text area
            0,                               // statusbar coffsety
            true, true,                      // available window, fullscreen
            "-0-","-0-"                      // fallback modes window, fullscreen
        },
        { 
            VM_640x512, 640, 512,            // id, w, h
            32, VTS_32,                      // tilesize, tiletype
            "640x512", "640x512", "5:4",     // name, fsname, fs only
            "models-32.lua", "gfx32/",       // initscript, dir
            Rect (0, 0, 640, 480),           // display area
            0, 0,                            // menu background image offsets 
            120, 78, 4, "-120x78",           // thumbnail size/extension
            Rect (0, 0, 640, 416),           // game area
            Rect (0, 416, 640, 64),          // statusbar area
            Rect (15, 420, 110, 40),         // time area
            Rect (100, 420, 31, 40),         // modes area
            Rect (100, 420, 30, 40),         // moves area
            Rect (200, 433, 490, 52),        // inventory area
            Rect (150, 434, 475, 35),        // text area
            0,                               // statusbar coffsety
            false, false,                    // 640x512 is deprecated!
            "-0-","-0-"                      // fallback modes window, fullscreen
        },
        { 
            VM_800x600, 800, 600,            // id, w, h
            40, VTS_40,                      // tilesize, tiletype
            "800x600", "SVGA", "4:3",        // name, fsname, fs only
            "models-40.lua", "gfx40/",       // initscript, dir
            Rect (0, 0, 800, 600),           // display area
            0, 0,                            // menu background image offsets 
            120, 78, 4, "-120x78",           // thumbnail size/extension
            Rect (0, 0, 800, 520),           // game area
            Rect (0, 520, 800, 80),          // statusbar area
            Rect (16, 540, 140, 40),         // time area
            Rect (140, 530, 31, 40),         // modes area
            Rect (140, 540, 30, 40),         // moves area
            Rect (235, 539, 610, 46),        // inventory area
            Rect (225, 547, 555, 39),        // text area
            0,                               // statusbar coffsety
            true, true,                      // available window, fullscreen
            "-2-0-","-2-0-"                  // fallback modes window, fullscreen
        },
        { 
            VM_1024x768, 1024, 768,          // id, w, h
            48, VTS_48,                      // tilesize, tiletype
            "1024x768", "XGA", "4:3",        // name, fsname, fs only
            "models-48.lua", "gfx48/",       // initscript, dir
            Rect (32, 0, 960, 720),          // display area
            -128, -96,                       // menu background image offsets 
            120, 78, 4, "-120x78",           // thumbnail size/extension
            Rect (32, 0, 960, 624),          // game area
            Rect (32, 624, 960, 96),         // statusbar area
            Rect (50, 640, 170, 60),         // time area
            Rect (198, 634, 34, 60),         // modes area
            Rect (185, 640, 30, 60),         // moves area
            Rect (314, 650, 710, 46),        // inventory area
            Rect (302, 655, 666, 40),        // text area
            0,                               // statusbar coffsety
            true, true,                      // available window, fullscreen
            "-3-2-0-","-3-2-0-"              // fallback modes window, fullscreen
        },
        { 
            VM_960x720, 960, 720,            // id, w, h
            48, VTS_48,                      // tilesize, tiletype
            "960x720", "960x720", "4:3",     // name, fsname, fs only
            "models-48.lua", "gfx48/",       // initscript, dir
            Rect (0, 0, 960, 720),           // display area
            -192, -144,                      // menu background image offsets 
            120, 78, 4, "-120x78",           // thumbnail size/extension
            Rect (0, 0, 960, 624),           // game area
            Rect (0, 624, 960, 96),          // statusbar area
            Rect (18, 640, 170, 60),         // time area
            Rect (166, 636, 34, 60),         // modes area
            Rect (153, 640, 30, 60),         // moves area
            Rect (282, 650, 710, 46),        // inventory area
            Rect (270, 656, 666, 40),        // text area
            0,                               // statusbar coffsety
            true, true,                      // available window, fullscreen
            "-4-2-0-","-4-2-0-"              // fallback modes window, fullscreen
        },
        { 
            VM_1280x720, 1280, 720,          // id, w, h
            48, VTS_48,                      // tilesize, tiletype
            "1280x720", "HD720", "16:10",    // name, fsname, fs only
            "models-48.lua", "gfx48/",       // initscript, dir
            Rect (160, 0, 960, 720),         // display area
            -192, -96,                       // menu background image offsets 
            120, 78, 4, "-120x78",           // thumbnail size/extension
            Rect (160, 0, 960, 624),         // game area
            Rect (160, 624, 960, 96),        // statusbar area
            Rect (178, 640, 170, 60),        // time area
            Rect (313, 640, 30, 60),         // modes area
            Rect (313, 640, 30, 60),         // moves area
            Rect (400, 650, 710, 46),        // inventory area
            Rect (388, 654, 710, 40),        // text area
            0,                               // statusbar coffsety
            false, true,                     // available window, fullscreen
            "-0-","-5-0-"                    // fallback modes window, fullscreen
        },
        { 
            VM_1280x960, 1280, 960,          // id, w, h
            64, VTS_64,                      // tilesize, tiletype
            "1280x960", "1280x960", "4:3",   // name, fsname, fs only
            "models-64.lua", "gfx64/",       // initscript, dir
            Rect (0, 0, 1280, 960),          // display area
            -400, -90,                       // menu background image offsets 
            160, 104, 5, "-160x104",         // thumbnail size/extension
            Rect (0, 0, 1280, 832),          // game area
            Rect (0, 832, 1280, 128),        // statusbar area
            Rect (24, 857, 227, 80),         // time area //TODO
            Rect (204, 853, 40, 80),         // modes area //TODO
            Rect (204, 853, 40, 80),         // moves area //TODO
            Rect (376, 867, 947, 61),        // inventory area //TODO
            Rect (360, 884, 888, 53),        // text area //TODO
            1,                               // statusbar coffsety
            true, true,                      // available window, fullscreen
            "-6-4-2-0-","-6-4-2-0-"          // fallback modes window, fullscreen
        },
        { 
            VM_1440x960, 1440, 960,          // id, w, h
            64, VTS_64,                      // tilesize, tiletype
            "1440x960", "1440x960", "3:2",   // name, fsname, fs only
            "models-64.lua", "gfx64/",       // initscript, dir
            Rect (80, 0, 1280, 960),         // display area
            -400, -90,                       // menu background image offsets 
            160, 104, 5, "-160x104",         // thumbnail size/extension
            Rect (80, 0, 1280, 832),         // game area
            Rect (80, 832, 1280, 128),       // statusbar area
            Rect (104, 853, 227, 80),        // time area //TODO
            Rect (284, 853, 40, 80),         // modes area //TODO
            Rect (284, 853, 40, 80),         // moves area //TODO
            Rect (480, 867, 947, 61),        // inventory area //TODO
            Rect (384, 873, 947, 53),        // text area //TODO
            0,                               // statusbar coffsety
            false, true,                     // available window, fullscreen
            "-0-","-7-0-"                    // fallback modes window, fullscreen
        },
        { 
            VM_1280x1024, 1280, 1024,        // id, w, h
            64, VTS_64,                      // tilesize, tiletype
            "1280x1024", "SXGA", "5:4",      // name, fsname, fs only
            "models-64.lua", "gfx64/",       // initscript, dir
            Rect (0, 0, 1280, 960),          // display area
            -400, -26,                       // menu background image offsets 
            160, 104, 5, "-160x104",         // thumbnail size/extension
            Rect (0, 0, 1280, 832),          // game area
            Rect (0, 832, 1280, 128),        // statusbar area
            Rect (18, 640, 170, 60),         // time area //TODO
            Rect (153, 640, 30, 60),         // modes area //TODO
            Rect (153, 640, 30, 60),         // moves area //TODO
            Rect (324, 650, 710, 46),        // inventory area //TODO
            Rect (360, 655, 888, 40),        // text area //TODO
            0,                               // statusbar coffsety
            false, true,                     // available window, fullscreen
            "-0-","-8-0-"                    // fallback modes window, fullscreen
        },
        { 
            VM_1680x1050, 1680, 1050,        // id, w, h
            64, VTS_64,                      // tilesize, tiletype
            "1680x1050", "WSXGA+", "16:10",  // name, fsname, fs only
            "models-64.lua", "gfx64/",       // initscript, dir
            Rect (200, 0, 1280, 960),        // display area
            -0, -0,                          // menu background image offsets 
            160, 104, 5, "-160x104",         // thumbnail size/extension
            Rect (200, 0, 1280, 832),        // game area
            Rect (200, 832, 1280, 128),      // statusbar area
            Rect (224, 853, 227, 80),        // time area //TODO
            Rect (404, 853, 40, 80),         // modes area //TODO
            Rect (404, 853, 40, 80),         // moves area //TODO
            Rect (600, 867, 947, 61),        // inventory area //TODO
            Rect (504, 873, 947, 53),        // text area //TODO
            0,                               // statusbar coffsety
            false, true,                     // available window, fullscreen
            "-0-","-9-0-"                    // fallback modes window, fullscreen
        },
        { 
            VM_320x240, 320, 240,            // id, w, h
            16, VTS_16,                      // tilesize, tiletype
            "320x240", "CGA", "4:3",         // name, fsname, fs only
            "models-16.lua", "gfx16/",       // initscript, dir
            Rect (0, 0, 320, 240),           // display area
            0, 0,                            // menu background image offsets 
            60, 39, 2, "-60x39",             // thumbnail size/extension
            Rect (0, 0, 320, 208),           // game area
            Rect (0, 208, 320, 32),          // statusbar area
            Rect (3, 212, 65, 21),           // time area
            Rect (52, 210, 14, 21),          // modes area
            Rect (50, 220, 15, 21),          // moves area
            Rect (94, 216, 245, 26),         // inventory area
            Rect (90, 217, 222, 17),         // text area
            0,                               // statusbar coffsety
            true, true,                      // available window, fullscreen
            "-10-0-","-10-0-"                // fallback modes window, fullscreen
        }
    };

    VideoModes current_video_mode = VM_None;
}

/* -------------------- Auxiliary functions -------------------- */

namespace
{
    bool vm_available (int w, int h, int &bpp, bool fullscreen)
    {
        Uint32 flags = SDL_HWSURFACE;
        if (fullscreen)
            flags |= SDL_FULLSCREEN;

        int newbpp = SDL_VideoModeOK (w, h, bpp, flags);
        if (newbpp != 0) {
            bpp = newbpp;
            return true;
        }
        return false;
    }

}


/* -------------------- MouseCursor -------------------- */

namespace {

struct MouseCursor {
    Texture tex;
    int x, y;
    int hotx, hoty;    // Coordinates of hotspot inside cursor image
    int visible;
};

MouseCursor cursor;

/** This function is installed as an event filter by MouseInit. It
intercepts mouse motions, which are used to update the position of the mouse
cursor (but passed on to the event queue) */
int mouseEventFilter(const SDL_Event *e)
{
    if (e->type == SDL_MOUSEMOTION) {
        cursor.x = e->motion.x; 
        cursor.y = e->motion.y;
    }
    return 1;
}

} // namespace

void video::SetMouseCursor(ecl::Surface *s, int hotx, int hoty) {
    if (cursor.tex.id != 0)
        glDeleteTextures(1, &cursor.tex.id);
    CreateTexture(s, &cursor.tex);
    delete s;
    cursor.hotx   = hotx;
    cursor.hoty   = hoty;
}

void video::HideMouse() {
    cursor.visible--;
}

void video::ShowMouse() {
    cursor.visible++;
}

void video::DrawMouse() {
    if (cursor.visible > 0)
        blit(cursor.tex, cursor.x-cursor.hotx, cursor.y-cursor.hoty);
}

int video::Mousex() {
    return cursor.x;
}

int video::Mousey() {
    return cursor.y;
}

void video::MouseInit() {
    SDL_GetMouseState(&cursor.x, &cursor.y);
    SDL_SetEventFilter(mouseEventFilter);
}

void video::MouseShutdown() {
    if (cursor.tex.id != 0)
        glDeleteTextures(1, &cursor.tex.id);
    cursor.tex.id = 0;
}

/* -------------------- Input grabbing -------------------- */


TempInputGrab::TempInputGrab (bool onoff)
{
    old_onoff = SetInputGrab (onoff);
}

TempInputGrab::~TempInputGrab()
{
    SetInputGrab (old_onoff);
}

bool video::GetInputGrab()
{
    return SDL_WM_GrabInput (SDL_GRAB_QUERY) == SDL_GRAB_ON;
}

bool video::SetInputGrab (bool onoff)
{
    bool old_onoff = GetInputGrab (); 
    if (onoff) {
        Screen *screen = GetScreen();
        SDL_WarpMouse (screen->width()/2, screen->height()/2);
        SDL_Event e;
        while (SDL_PollEvent(&e)) {
            ;                   // swallow mouse motion event
        }
        SDL_WM_GrabInput (SDL_GRAB_ON);
    }
    else
        SDL_WM_GrabInput (SDL_GRAB_OFF);
    return old_onoff;
}


Surface* video::BackBuffer() {
    if (back_buffer==0) {
        back_buffer= Duplicate(gScreen->get_surface());
    }
    return back_buffer;
}

const video::VMInfo *video::GetInfo (VideoModes vm)
{
    return &video_modes[vm];
}

const video::VMInfo *video::GetInfo ()
{
    return GetInfo (current_video_mode);
}

void video::SetThumbInfo(int width, int height, std::string extension) {
    video_modes[current_video_mode].thumbw = width;
    video_modes[current_video_mode].thumbh = height;
    video_modes[current_video_mode].thumbsext = extension;
}

int video::GetNumAvailableModes(bool isFullscreen) {
    int avail = 0;
    for (int i = VM_None + 1; i < VM_COUNT; i++)
        if (isFullscreen ? video_modes[i].f_available : video_modes[i].w_available)
            avail++;
            
    return avail;
}

VideoModes video::GetVideoMode(int number, bool isFullscreen) {
    int avail = 0;
    for (int i = VM_None + 1; i < VM_COUNT; i++)
        if (isFullscreen ? video_modes[i].f_available : video_modes[i].w_available) {
            if (avail == number)
                return static_cast<video::VideoModes>(i);
            else
                avail++;
        }
    return VM_None;
}

VideoModes video::GetBestUserMode(bool isFullscreen, int seq) {
    std::string modes = app.prefs->getString(isFullscreen ? "VideoModesFullscreen" : "VideoModesWindow");
    if (modes.length() > 1) {
        std::istringstream ms(modes);
        int m = VM_None;
        ms.ignore();  // leading '-'
        while (ms && seq > 0) {
            ms >> std::dec >> m;
            ms.ignore();
            if (m <= VM_COUNT && ((!isFullscreen && video_modes[m].w_available) ||
                    (isFullscreen && video_modes[m].f_available))) {
                if (seq == 1) {
                    return static_cast<video::VideoModes>(m);
                }
                --seq; 
            }
        }
    }
    return VM_None;
}


int video::GetModeNumber(VideoModes mode, bool isFullscreen) {
    int avail = 0;
    for (int i = VM_None + 1; i < mode; i++)
        if (isFullscreen ? video_modes[i].f_available : video_modes[i].w_available)
            avail++;
    return avail;
}


bool video::ModeAvailable (VideoModes vm)
{
    const VMInfo *vminfo = GetInfo (vm);
    string fname;
    return (vminfo->w_available && app.systemFS->findFile (vminfo->initscript, fname));
}


bool InitVideoMode(int w, int h, int bpp, bool fullscreen)
{
    static bool firstInit = true;
    
#ifndef MACOSX
    if (firstInit) {
        // Set the caption icon -- due to SDL doc it has to be set before first SDL_SetVideoMode() !!
        // In praxis this SetIcon does not work for Linux, nor is it necessary for OSX.
        // Just XP with selected "WindowsXP Design" needs this SetIcon.
        // See video::Init() for icon set for Linux and other Windows versions
        // Mac icon is set via Makefile 
        firstInit = false;
        std::string iconpath;
        ecl::Surface *es = NULL;
        if (app.resourceFS->findFile("gfx/enigma_marble.png", iconpath)) { // cannot use ecl::findImageFile !
            es = ecl::LoadImage(iconpath.c_str());
            if (es) {
                SDL_WM_SetIcon(es->get_surface(), NULL);
            }
        }
    }
#endif

    SDL_WM_SetCaption(gCaption.c_str(), 0);

    Uint32 flags = SDL_HWSURFACE | SDL_OPENGL;
    if (fullscreen)
        flags |= SDL_FULLSCREEN;

    // Try to initialize vide mode, return error code on failure
    bpp = SDL_VideoModeOK (w, h, bpp, flags);
    if (bpp == 0)
        return false;
    gSdlScreen = SDL_SetVideoMode(w, h, bpp, flags);
    if (gSdlScreen == NULL)
        return false;

    // Video mode could be set
    gScreen = new Screen(gSdlScreen);

    glClearColor(255, 0, 0, 0);
    glClearDepth(1.0f);
    glViewport(0, 0, w, h);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0, w, h, 0, 1, -1);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glEnable(GL_TEXTURE_2D);

    gInitialized = true;

    // Hack to hide the cursor after switching between
    // window/fullscreen mode.
    SDL_ShowCursor(SDL_ENABLE);
    SDL_ShowCursor(SDL_DISABLE);

    SDL_EnableKeyRepeat(SDL_DEFAULT_REPEAT_DELAY / 2,
            SDL_DEFAULT_REPEAT_INTERVAL / 2);

    return true;
}

void video::Init() 
{
    static bool isInit = false;
    static int bpp_default = 16;
    int bpp = bpp_default; //options::BitsPerPixel;

    
    if (!isInit) {
        assert (NUMENTRIES(video_modes) == VM_COUNT);
        isInit = true;
        for (int i = VM_None + 1; i < VM_COUNT; i++) {
            bpp = bpp_default;
            if (video_modes[i].w_available && !vm_available(video_modes[i].width, video_modes[i].height, bpp, false)) {
                video_modes[i].w_available = false;
                Log << "Video mode " << video_modes[i].width << " x " << video_modes[i].height << " window not available\n";
            }
            if (bpp != bpp_default)
                Log << "Video mode " << video_modes[i].width << " x " << video_modes[i].height << " window available with bpp " << bpp << "\n";
            bpp = bpp_default;
            if (video_modes[i].f_available && !vm_available(video_modes[i].width, video_modes[i].height, bpp, true)) {
                video_modes[i].f_available = false;
                Log << "Video mode " << video_modes[i].width << " x " << video_modes[i].height << " fullscreen not available\n";
            }
            if (bpp != bpp_default)
                Log << "Video mode " << video_modes[i].width << " x " << video_modes[i].height << " fullscreen available with bpp " << bpp << "\n";
        }
    }

    bool isFullScreen = app.prefs->getBool("FullScreen");
    int vidmode = -1;
    if (app.prefs->getString("VideoModesFullscreen").empty()) {
        // initialize from 1.0 mode if never set before
        vidmode = app.prefs->getInt("VideoMode");
        app.prefs->setProperty("VideoModesFullscreen", video_modes[vidmode].fallback_fullscreen);
        app.prefs->setProperty("VideoModesWindow", video_modes[vidmode].fallback_window);
    }
    vidmode = video::GetBestUserMode(isFullScreen);
    
    int oldvidmode = vidmode;

    assert(bpp==16 || bpp==32);
    int fallback_sequence = 1;
    while (true) {
        VMInfo *vminfo     = &video_modes[vidmode];
        int     w          = vminfo->width;
        int     h          = vminfo->height;

        if (ModeAvailable (static_cast<VideoModes> (vidmode))
            && vm_available (w, h, bpp, isFullScreen)
            && InitVideoMode(w, h, bpp, isFullScreen)) 
        {
            // Success!
            break;
        }

        // Video mode not available? Try the next fallback video mode
        vidmode =  video::GetBestUserMode(isFullScreen, ++fallback_sequence); 
        if (vidmode == VM_None) {
            // Give up :-(
            fprintf(stderr, "Couldn't open screen: %s\n", SDL_GetError());
            exit(1);
        }
    }

    current_video_mode = static_cast<VideoModes>(vidmode);
    app.selectedVideoMode = current_video_mode;

    // Set the caption icon -- this position after SDL_SetVideoMode() contradicts SDL doc!!
    // But it proves to be the only working position for Linux.
    // It works for Windows besides XP with selected "WindowsXP Design", too.
    // Mac icon is set via Makefile 
#ifndef MACOSX
    Surface *icn = enigma::GetImage("enigma_marble");
    if(icn)
        SDL_WM_SetIcon(icn->get_surface(), NULL);
#endif

    MouseInit();
}

void video::Shutdown() 
{
    SDL_SetEventFilter(0);
    SDL_WM_GrabInput(SDL_GRAB_OFF);
    delete gScreen;
    delete back_buffer;
    back_buffer = 0;
}

void video::ChangeVideoMode()
{
    Shutdown();
    Init();
}

ecl::Screen * video::GetScreen() {
    return gScreen;
}

VideoModes video::GetVideoMode() {
    return current_video_mode;
}


// void Video_SDL::toggle_fullscreen() 
// {
// }


bool video::IsFullScreen()
{
    if (SDL_Surface *s = gSdlScreen)
        return (s->flags & SDL_FULLSCREEN) != 0; 
    return false;
}

int video::GetColorDepth() {
    return gSdlScreen->format->BitsPerPixel;
}

bool video::SetFullscreen(bool on) 
{
    bool is_fullscreen = IsFullScreen();
    if ((on && video_modes[current_video_mode].f_available) || 
            (!on && video_modes[current_video_mode].w_available)) {

        if (on != is_fullscreen)
            SDL_WM_ToggleFullScreen(gSdlScreen);

        is_fullscreen = IsFullScreen();
        if (on == is_fullscreen)
            app.prefs->setProperty("FullScreen", is_fullscreen);
    }
    return is_fullscreen;
}

bool video::ToggleFullscreen() 
{
    return SetFullscreen (!IsFullScreen());
}

void video::SetWindowCaption(const char *str) 
{
    gCaption = str;
    if (gInitialized)
        SDL_WM_SetCaption(str, 0);
}

const string& video::GetWindowCaption() 
{
    return gCaption;
}

void video::Screenshot (const std::string &fname) 
{
    // auto-create the directory if necessary
    string directory;
    if (ecl::split_path(fname, &directory, 0) && !ecl::FolderExists(directory)) {
        ecl::FolderCreate(directory);
    }

    ecl::SavePNG (ecl::Grab(gScreen->get_surface(), video_modes[current_video_mode].area), fname);
    enigma::Log << "Wrote screenshot to '" << fname << "\n";
}

/* -------------------- Special Effects -------------------- */

void video::FX_Fade(FadeMode mode) 
{
    Surface *d = gScreen->get_surface();
    const double fadesec = 0.6;
    double v = 255/fadesec;

    ecl::Surface *buffer = Duplicate(d);
    double dt;

    double a = mode==FADEIN ? 0 : 255;

    GC gc (d);
    
    while (true) {
        Uint32 otime = SDL_GetTicks();

        box(gc, d->size());
        buffer->set_alpha(int(a));
        blit(gc, 0,0,buffer);
        gScreen->update_all();
        gScreen->flush_updates();

        dt = (SDL_GetTicks()-otime)/1000.0;
        if (mode==FADEIN && (a+=v*dt) > 255)
            break;
        else if (mode==FADEOUT && (a-=v*dt) < 0)
            break;
    }

    if (mode==FADEIN) {
        buffer->set_alpha(255);
        blit(gc, 0,0,buffer);
    } else
        box (gc, d->size());
    gScreen->update_all();
    gScreen->flush_updates();
    delete buffer;
}

void video::FX_Fly (Surface *newscr, int originx, int originy) 
{
    double rest_time = 0.5;

    double velx = -originx / rest_time;
    double vely = -originy / rest_time;

    double origx = originx;
    double origy = originy;

    Screen *scr = gScreen;
    GC scrgc(scr->get_surface());

    while (rest_time > 0)
    {
        Uint32 otime = SDL_GetTicks();

        Rect r(static_cast<int>(origx),
               static_cast<int>(origy),
               scr->width(), scr->height());
        blit (scrgc, r.x, r.y, newscr);

        scr->update_rect(r);
        scr->flush_updates();

        double dt = (SDL_GetTicks()-otime)/1000.0;
        if (dt > rest_time)
            dt = rest_time;
        rest_time -= dt;
        origx += velx * dt;
        origy += vely * dt;
    }
}

namespace
{
    class Effect_Push : public TransitionEffect {
    public:
        Effect_Push(ecl::Surface *newscr, int originx, int originy);
        void tick (double dtime);
        bool finished() const;
    private:
        double rest_time;
        ecl::Surface *newscr;
        std::auto_ptr<ecl::Surface > oldscr;
        int originx, originy;
        double velx, vely;
        double accx, accy;
        double x, y;
        double t;
    };
}

Effect_Push::Effect_Push(ecl::Surface *newscr_, int originx_, int originy_)
: rest_time (0.7),
  newscr (newscr_),
  oldscr (Duplicate(gScreen->get_surface())),
  originx (originx_),
  originy (originy_),
  velx (-2 * originx / rest_time),
  vely (-2 * originy / rest_time),
  accx (-0.5*velx/rest_time),
  accy (-0.5*vely/rest_time),
  x (originx),
  y (originy),
  t (0)
{
}

void Effect_Push::tick (double dtime)
{
    Screen *scr = gScreen;
    GC scrgc(scr->get_surface());

    if (rest_time > 0) {
        if (dtime > rest_time)
            dtime = rest_time;
        rest_time -= dtime;
        t+=dtime;

        x = (accx*t + velx)*t + originx;
        y = (accy*t + vely)*t + originy;

        blit (scrgc, (int)x-originx, (int)y, oldscr.get());
        blit (scrgc, (int)x, (int)y-originy, oldscr.get());
        blit (scrgc, (int)x-originx, (int)y-originy, oldscr.get());

        blit (scrgc, (int)x, (int) y, newscr);

        scr->update_all();
        scr->flush_updates();
    }
    else {
        blit(scrgc, 0,0, newscr);
        scr->update_all();
        scr->flush_updates();
    }
}

bool Effect_Push::finished() const
{
    return rest_time <= 0;
}




TransitionEffect *
video::MakeEffect (TransitionModes tm, ecl::Surface *newscr)
{
    int scrw = gScreen->width();
    int scrh = gScreen->height();

    switch (tm) {
    case TM_PUSH_RANDOM: {
        int xo=0, yo=0;
        while (xo==0 && yo==0) {
            xo = enigma::IntegerRand(-1, 1, false)*scrw;
            yo = enigma::IntegerRand(-1, 1, false)*scrh;
        }
        return new Effect_Push(newscr, xo, yo);
    }
    case TM_PUSH_N: return new Effect_Push (newscr, 0, -scrh);
    case TM_PUSH_S: return new Effect_Push (newscr, 0, +scrh);
    case TM_PUSH_E: return new Effect_Push (newscr, +scrw, 0);
    case TM_PUSH_W: return new Effect_Push (newscr, -scrw, 0);
    default:
        return 0;
    };
}


void video::ShowScreen (TransitionModes tm, Surface *newscr) {
    int scrw = gScreen->width();
    int scrh = gScreen->height();

    switch (tm) {
    case TM_RANDOM:
	break;
    case TM_FADEOUTIN:
	break;
    case TM_SQUARES:
	break;
    case TM_FLY_N: FX_Fly (newscr, 0, -scrh); break;
    case TM_FLY_S: FX_Fly (newscr, 0, +scrh); break;
    case TM_FLY_E: FX_Fly (newscr, +scrw, 0); break;
    case TM_FLY_W: FX_Fly (newscr, -scrw, 0); break;

    default:
        break;
    }
}

