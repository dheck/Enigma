/*
 * Copyright (C) 2006 Ronald Lamprecht
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

#include "errors.hh"
#include "gui/LevelInspector.hh"
#include "main.hh"
#include "enigma.hh"
#include "nls.hh"
#include "video.hh"
#include "ecl_util.hh"
#include "gui/MonospacedLabel.hh"
#include "gui/LevelPreviewCache.hh"
#include "gui/ScreenshotViewer.hh"
#include "lev/RatingManager.hh"
#include "lev/ScoreManager.hh"
#include "StateManager.hh"


#include <vector>

using namespace ecl;
using namespace enigma;

namespace enigma { namespace gui {

    class IntelligenceButton : public ValueButton {
        int get_value() const     { 
            return theRatingMgr->getIntelligence(theLevel);
        }
        void set_value(int value) { 
            theRatingMgr->setIntelligence(theLevel, value);
        }
    
        string get_text(int value) const  {
            return strf("%d", value);
        }
    public:
        IntelligenceButton(lev::Proxy  *aLevel) : ValueButton(0, 5), 
                theLevel (aLevel) {
            theRatingMgr = lev::RatingManager::instance();
            init();
        }
    private:
        lev::RatingManager *theRatingMgr;
        lev::Proxy *theLevel;        
    };
    
    class DexterityButton : public ValueButton {
        int get_value() const     { 
            return theRatingMgr->getDexterity(theLevel);
        }
        void set_value(int value) { 
            theRatingMgr->setDexterity(theLevel, value);
        }
    
        string get_text(int value) const  {
            return strf("%d", value);
        }
    public:
        DexterityButton(lev::Proxy  *aLevel) : ValueButton(0, 5), 
                theLevel (aLevel) {
            theRatingMgr = lev::RatingManager::instance();
            init();
        }
    private:
        lev::RatingManager *theRatingMgr;
        lev::Proxy *theLevel;        
    };
    
    class PatienceButton : public ValueButton {
        int get_value() const     { 
            return theRatingMgr->getPatience(theLevel);
        }
        void set_value(int value) { 
            theRatingMgr->setPatience(theLevel, value);
        }
    
        string get_text(int value) const  {
            return strf("%d", value);
        }
    public:
        PatienceButton(lev::Proxy  *aLevel) : ValueButton(0, 5), 
                theLevel (aLevel) {
            theRatingMgr = lev::RatingManager::instance();
            init();
        }
    private:
        lev::RatingManager *theRatingMgr;
        lev::Proxy *theLevel;        
    };
    
    class KnowledgeButton : public ValueButton {
        int get_value() const     { 
            return theRatingMgr->getKnowledge(theLevel);
        }
        void set_value(int value) { 
            theRatingMgr->setKnowledge(theLevel, value);
        }
    
        string get_text(int value) const  {
            return strf("%d", value);
        }
    public:
        KnowledgeButton(lev::Proxy  *aLevel) : ValueButton(0, 6), 
                theLevel (aLevel) {
            theRatingMgr = lev::RatingManager::instance();
            init();
        }
    private:
        lev::RatingManager *theRatingMgr;
        lev::Proxy *theLevel;        
    };
    
    class SpeedButton : public ValueButton {
        int get_value() const     { 
            return theRatingMgr->getSpeed(theLevel);
        }
        void set_value(int value) { 
            theRatingMgr->setSpeed(theLevel, value);
        }
    
        string get_text(int value) const  {
            return strf("%d", value);
        }
    public:
        SpeedButton(lev::Proxy  *aLevel) : ValueButton(0, 5), 
                theLevel (aLevel) {
            theRatingMgr = lev::RatingManager::instance();
            init();
        }
    private:
        lev::RatingManager *theRatingMgr;
        lev::Proxy *theLevel;        
    };
    
//     class RatingButton : public ValueButton {
//         int get_value() const     { 
//             return theRatingMgr->getSpeed(theLevel);
//         }
//         void set_value(int value) { 
//             theRatingMgr->setSpeed(theLevel, value);
//         }
//     
//         string get_text(int value) const  {
//             return strf("%d", value);
//         }
//     public:
//         RatingButton(lev::Proxy  *aLevel) : ValueButton(0, 5), 
//                 theLevel (aLevel) {
//             theRatingMgr = lev::RatingManager::instance();
//             init();
//         }
//     private:
//         lev::RatingManager *theRatingMgr;
//         lev::Proxy *theLevel;        
//     };
    
LevelInspector::LevelInspector(lev::Proxy *aLevel):
        levelProxy(aLevel), annotation (new TextField()),
        back (new StaticTextButton(N_("Ok"), this)),
        screenshot (new StaticTextButton(N_("Screenshot"), this))
    {
        previewImage = LevelPreviewCache::instance()->getPreview(aLevel);
        const video::VMInfo *vminfo = video::GetInfo();
        vspacing = vminfo->height < 500 ? 2 :(vminfo->height < 650 ? 3 : 4);
        vmargin = vminfo->height < 500 ? 10 :(vminfo->height < 650 ?  20 : 30);
        hmargin = vminfo->width < 660 ? 10 : (vminfo->width < 900 ? 20 : 30);
        bool highres = vminfo->height > 650 ? true : false;
    
        add(back, Rect(vminfo->width-130-2*hmargin,vminfo->height-50,130,35));
        add(screenshot, Rect(vminfo->width-260-3*hmargin,vminfo->height-50,130,35));
    
        try {
            aLevel->loadMetadata(true);
        }
        catch (XLevelLoading &err) {
            std::vector<string> lines;
            std::string errmsg = _("Server Error: could not load level '")
                                   + aLevel->getNormLevelPath() + "'\n"
                                   + err.what();
            ecl::split_copy (errmsg, '\n', back_inserter(lines));
            int x     = 60;
            int y     = 60;
            int yskip = 25;
            for (unsigned i=0; i<lines.size(); ++i) {
                add(new Label(lines[i], HALIGN_LEFT), Rect(x, y, vminfo->width-80,yskip));
                y += yskip;
            }
            return;
        }
    
        std::string tmp, tmp2;
        lev::RatingManager *theRatingMgr = lev::RatingManager::instance();
        lev::ScoreManager  *theScoreMgr = lev::ScoreManager::instance();
        withEasy = aLevel->hasEasymode();
        ecl::Font *menufont = enigma::GetFont("menufont");
        levelPathString = 
                (levelProxy->getNormPathType() == lev::Proxy::pt_resource) ?
                levelProxy->getAbsLevelPath() : levelProxy->getNormLevelPath();
        // substitute all backslashes by slashes
        for (std::string::size_type slpos = levelPathString.find('\\');
                slpos != std::string::npos; slpos = levelPathString.find('\\')) 
            levelPathString.replace(slpos, 1, 1, '/');
        BuildVList authorT(this, Rect(hmargin,vmargin,110,25), vspacing);
        authorT.add(new Label(N_("Level: "), HALIGN_RIGHT));
        authorT.add(new Label((""), HALIGN_RIGHT)); // subtitle
        authorT.add(new Label(N_("Author: "), HALIGN_RIGHT));
        authorT.add(new Label(N_("Contact: "), HALIGN_RIGHT));
        authorT.add(new Label(N_("Homepage: "), HALIGN_RIGHT));
        
        BuildVList author(this, Rect(hmargin+110+10,vmargin,
                vminfo->width-(hmargin+110+10)-10-(vminfo->thumbw+10)-hmargin,25), vspacing);
        tmp = levelProxy->getTitle();
        tmp2 = levelProxy->getLocalizedString("title");
        if (tmp != tmp2)
            tmp = tmp + "  --  " + tmp2;
        author.add(new Label( tmp, HALIGN_LEFT));
        tmp = levelProxy->getLocalizedString("subtitle");
        if (tmp == "subtitle")
            tmp = "";
        author.add(new Label(tmp, HALIGN_LEFT)); // subtitle
        author.add(new Label(levelProxy->getAuthor(), HALIGN_LEFT));
        
        BuildVList address(this, Rect(hmargin+110+10,vmargin+3*(25+vspacing),
                vminfo->width-(hmargin+110+10)-hmargin,25), vspacing);
        address.add(new Label(levelProxy->getContact(), HALIGN_LEFT));
        address.add(new Label(levelProxy->getHomepage(), HALIGN_LEFT));
        
        BuildVList ratingPubT(this, Rect(hmargin+65,vmargin+5*25+4*vspacing+16, 130,25), 2);
        ratingPubT.add(new Label(N_("Public Ratings"), HALIGN_CENTER));
        BuildVList ratingPubST(this, Rect(hmargin,vmargin+6*25+5*vspacing+16, 130,25), 2);
        ratingPubST.add(new Label(N_("Intelligence: "), HALIGN_RIGHT));
        ratingPubST.add(new Label(N_("Dexterity: "), HALIGN_RIGHT));
        ratingPubST.add(new Label(N_("Patience: "), HALIGN_RIGHT));
        ratingPubST.add(new Label(N_("Knowledge: "), HALIGN_RIGHT));
        ratingPubST.add(new Label(N_("Speed: "), HALIGN_RIGHT));
        if (highres) ratingPubST.add(new Label(N_("Difficulty: "), HALIGN_RIGHT));

        
        BuildVList ratingPub(this, Rect(hmargin+130+15,vmargin+6*25+5*vspacing+16, 30,25), 2);
        if (WizardMode) {
            ratingPub.add(new IntelligenceButton(aLevel));
            ratingPub.add(new DexterityButton(aLevel));
            ratingPub.add(new PatienceButton(aLevel));
            ratingPub.add(new KnowledgeButton(aLevel));
            ratingPub.add(new SpeedButton(aLevel));
            if (highres) ratingPub.add(new MonospacedLabel(ratingToString(theRatingMgr->getDifficulty(aLevel)).c_str(),'8', " 0123456789", HALIGN_CENTER));
        } else {
            ratingPub.add(new MonospacedLabel(ratingToString(theRatingMgr->getIntelligence(aLevel)).c_str(),'8', " 0123456789", HALIGN_CENTER));
            ratingPub.add(new MonospacedLabel(ratingToString(theRatingMgr->getDexterity(aLevel)).c_str(),'8', " 0123456789", HALIGN_CENTER));
            ratingPub.add(new MonospacedLabel(ratingToString(theRatingMgr->getPatience(aLevel)).c_str(),'8', " 0123456789", HALIGN_CENTER));
            ratingPub.add(new MonospacedLabel(ratingToString(theRatingMgr->getKnowledge(aLevel)).c_str(),'8', " 0123456789", HALIGN_CENTER));
            ratingPub.add(new MonospacedLabel(ratingToString(theRatingMgr->getSpeed(aLevel)).c_str(),'8', " 0123456789", HALIGN_CENTER));
            if (highres) ratingPub.add(new MonospacedLabel(ratingToString(theRatingMgr->getDifficulty(aLevel)).c_str(),'8', " 0123456789", HALIGN_CENTER));
        }
        
        BuildVList scoresT(this, Rect(vminfo->width/2-100-20,vmargin+5*25+4*vspacing+16,100,25), 2);
        scoresT.add(new Label(N_("Scores"), HALIGN_RIGHT));

        BuildVList scoresST(this, Rect(vminfo->width/2-100-20,vmargin+6*25+5*vspacing+16,100,25), 2);
        scoresST.add(new Label(N_("You: "), HALIGN_RIGHT));
        scoresST.add(new Label(N_("World: "), HALIGN_RIGHT));
// TRANSLATORS: PAR = professional average rate - an expression used by golfers
        scoresST.add(new Label(N_("PAR: "), HALIGN_RIGHT));
        scoresST.add(new Label(N_("Author: "), HALIGN_RIGHT));
        scoresST.add(new Label(N_("Solved %: "), HALIGN_RIGHT));
        if (highres) scoresST.add(new Label(N_("Solved #: "), HALIGN_RIGHT));
    
        BuildVList scores(this, Rect(vminfo->width/2-15+(withEasy?0:20),
                vmargin+6*25+5*vspacing+16,(withEasy?117:54),25), 2);
        scores.add(new MonospacedLabel(scoreToString(theScoreMgr->getBestUserScore(aLevel, DIFFICULTY_EASY),
            theScoreMgr->getBestUserScore(aLevel, DIFFICULTY_HARD),aLevel,true).c_str(),'8', " 0123456789", HALIGN_CENTER));
        scores.add(new MonospacedLabel(scoreToString(theRatingMgr->getBestScoreEasy(aLevel),
            theRatingMgr->getBestScoreDifficult(aLevel),aLevel,true).c_str(),'8', " 0123456789", HALIGN_CENTER));
        scores.add(new MonospacedLabel(scoreToString(theRatingMgr->getParScoreEasy(aLevel),
            theRatingMgr->getParScoreDifficult(aLevel),aLevel,true).c_str(),'8', " 0123456789", HALIGN_CENTER));
        scores.add(new MonospacedLabel(scoreToString(aLevel->getEasyScore(),
            aLevel->getDifficultScore(),aLevel,true).c_str(),'8', " 0123456789", HALIGN_CENTER));
        scores.add(new MonospacedLabel(withEasy ? (theRatingMgr->getPcSolvedEasy(aLevel) + 
            " /" + theRatingMgr->getPcSolvedDifficult(aLevel) + " ").c_str() :
            (theRatingMgr->getPcSolvedDifficult(aLevel) + " ").c_str(),
            '8', " 0123456789", HALIGN_CENTER));
        if (highres) scores.add(new MonospacedLabel(withEasy ? (ecl::strf("%5d", theRatingMgr->getNumSolvedEasy(aLevel)) + 
            " /" + ecl::strf("%5d", theRatingMgr->getNumSolvedDifficult(aLevel)) + " ").c_str() :
            (ecl::strf("%5d", theRatingMgr->getNumSolvedDifficult(aLevel)) + " ").c_str(),
            '8', " 0123456789", HALIGN_CENTER));        
        
        BuildVList versionT(this, Rect(vminfo->width-100/2-90-2*hmargin,vmargin+5*25+4*vspacing+16,100,25), 2);
        versionT.add(new Label(N_("Version"), HALIGN_CENTER));
        BuildVList versionST(this, Rect(vminfo->width-110-90-2*hmargin,vmargin+6*25+5*vspacing+16,110,25), 2);
        if (highres || aLevel->getLevelStatus() == lev::STATUS_RELEASED)
            versionST.add(new Label(N_("Score: "), HALIGN_RIGHT));
        else
            versionST.add(new Label(N_("Status: "), HALIGN_RIGHT));
        versionST.add(new Label(N_("Release: "), HALIGN_RIGHT));
        versionST.add(new Label(N_("Revision: "), HALIGN_RIGHT));
        if (highres)
            versionST.add(new Label(N_("Status: "), HALIGN_RIGHT));
        versionST.add(new Label(N_("Control: "), HALIGN_RIGHT));
        versionST.add(new Label(N_("Target: "), HALIGN_RIGHT));

        BuildVList version(this, Rect(vminfo->width-80-2*hmargin,vmargin+6*25+5*vspacing+16,80+2*hmargin,25), 2);
        if (highres || aLevel->getLevelStatus() == lev::STATUS_RELEASED)
            version.add(new MonospacedLabel(ecl::strf("%6d", aLevel->getScoreVersion()).c_str(),
                    '8', " 0123456789", HALIGN_LEFT));
        else if (aLevel->getLevelStatus() == lev::STATUS_STABLE)
            version.add(new Label(N_("stable"), HALIGN_LEFT));
        else if (aLevel->getLevelStatus() == lev::STATUS_TEST)
            version.add(new Label(N_("test"), HALIGN_LEFT));
        else if (aLevel->getLevelStatus() == lev::STATUS_EXPERIMENTAL)
            version.add(new Label(N_("experimental"), HALIGN_LEFT));
        else
            version.add(new Label(N_("unknown"), HALIGN_LEFT));
        
        version.add(new MonospacedLabel(ecl::strf("%6d", aLevel->getReleaseVersion()).c_str(),
                '8', " 0123456789", HALIGN_LEFT));
        version.add(new MonospacedLabel(ecl::strf("%6d", aLevel->getRevisionNumber()).c_str(),
                '8', " 0123456789", HALIGN_LEFT));
        if (highres)
            if (aLevel->getLevelStatus() == lev::STATUS_RELEASED)
                version.add(new Label(N_("released"), HALIGN_LEFT));
            else if (aLevel->getLevelStatus() == lev::STATUS_STABLE)
                version.add(new Label(N_("stable"), HALIGN_LEFT));
            else if (aLevel->getLevelStatus() == lev::STATUS_TEST)
                version.add(new Label(N_("test"), HALIGN_LEFT));
            else if (aLevel->getLevelStatus() == lev::STATUS_EXPERIMENTAL)
                version.add(new Label(N_("experimental"), HALIGN_LEFT));
            else
                version.add(new Label(N_("unknown"), HALIGN_LEFT));
        
        switch (aLevel->getControl()) {
            case lev::force:
                version.add(new Label(N_("force"), HALIGN_LEFT));
                break;
            case lev::balance:
                version.add(new Label(N_("balance"), HALIGN_LEFT));
                break;
            case lev::key:
                version.add(new Label(N_("key"), HALIGN_LEFT));
                break;
            default:
                version.add(new Label(N_("unknown"), HALIGN_LEFT));
                break;
        }
#if 0
        // fake gettext to register the following strings for I18N
        _("time")
        _("pushes")
        _("moves")
#endif
        version.add(new Label(aLevel->getScoreTarget().c_str(), HALIGN_LEFT));
        
        int bestScoreHolderLines = 0;
        int creditsLines = 0;
        int dedicationLines = 0;
        int levelPathLines = 0;
        int annotationLines = 0; 
        int compatibilityLines = 0; 
        int vnext = vmargin+ (highres?12:11)*25+(highres?10:9)*vspacing+2*16;
        int textwidth = vminfo->width-3*hmargin-110-10;
        dispatchBottomLines(bestScoreHolderLines, creditsLines, dedicationLines,
                levelPathLines, annotationLines, compatibilityLines,
                (vminfo->height-(vnext)-60)/27, textwidth);
        if (bestScoreHolderLines == 1) {
            add(new Label(N_("World Record Holders: "), HALIGN_RIGHT),Rect(hmargin,vnext,200,25));
            std::string holders;
            if (withEasy) {
                holders = theRatingMgr->getBestScoreEasyHolder(aLevel);
                if (holders.empty())
                    holders = "  - ";
                holders += " / ";
            }
            if (theRatingMgr->getBestScoreDifficultHolder(aLevel).empty())
                holders += " -";
            else
                holders += theRatingMgr->getBestScoreDifficultHolder(aLevel);
            add(new Label(holders, HALIGN_LEFT), Rect(hmargin+200+10,vnext,textwidth-90,25));
            vnext += 25 + vspacing;
        }
        if (creditsLines >= 1) {
            add(new Label(N_("Credits: "), HALIGN_RIGHT),Rect(hmargin,vnext,110,25));
            std::string creditsString = levelProxy->getCredits(true);
            for (int i = 0; i< creditsLines; i++) {
                std::string::size_type breakPos = breakString(menufont, creditsString, 
                        " ", textwidth);
                add(new Label(creditsString.substr(0,breakPos), HALIGN_LEFT), Rect(hmargin+110+10,vnext,textwidth,25));
                creditsString = creditsString.substr(breakPos);
                vnext += (25 + vspacing);
            }
        }
        if (dedicationLines >= 1) {
            add(new Label(N_("Dedication: "), HALIGN_RIGHT),Rect(hmargin,vnext,110,25));
            std::string dedicationString = levelProxy->getDedication(true);
            for (int i = 0; i< dedicationLines; i++) {
                std::string::size_type breakPos = breakString( menufont, dedicationString, 
                        " ", textwidth);
                add(new Label(dedicationString.substr(0,breakPos), HALIGN_LEFT), Rect(hmargin+110+10,vnext,textwidth,25));
                dedicationString = dedicationString.substr(breakPos);
                vnext += (25 + vspacing);
            }
        }
        if (levelPathLines >= 1) {
            add(new Label(N_("Level Path: "), HALIGN_RIGHT),Rect(hmargin,vnext,110,25));
            std::string workString = levelPathString;
            for (int i = 0; i< levelPathLines - 1; i++) {
                std::string::size_type breakPos = breakString(menufont, workString, 
                        "/", textwidth);
                add(new Label(workString.substr(0,breakPos), HALIGN_LEFT), Rect(hmargin+110+10,vnext,textwidth,25));
                workString = workString.substr(breakPos);
                vnext += (25 + vspacing);
            }
            // show as much as possible from last line
            if (menufont->get_width(workString.c_str()) > textwidth) {
                // show the filename at the end - skip leading parts if necessary
                add(new Label(workString, HALIGN_RIGHT), Rect(hmargin+110+10,vnext,textwidth,25));
            } else {
                // display up to the last character
                add(new Label(workString, HALIGN_LEFT), Rect(hmargin+110+10,vnext,textwidth,25));
            }
            vnext += (25 + vspacing);
        }
        if (compatibilityLines >= 1) {
            add(new Label(N_("Compatibility: "), HALIGN_RIGHT),Rect(hmargin,vnext,110,25));
            std::string compString = ecl::strf("Enigma v%.2f  /  ", levelProxy->getEnigmaCompatibility()) +
                    GetGameTypeName(levelProxy->getEngineCompatibility());
            add(new Label(compString , HALIGN_LEFT),Rect(hmargin+110+10, vnext, textwidth, 25));
            vnext += (25 + vspacing)*compatibilityLines;
        }
        if (annotationLines >= 1) {
            add(new Label(N_("Annotation: "), HALIGN_RIGHT),Rect(hmargin,vnext,110,25));
            annotation->set_text(app.state->getAnnotation(levelProxy->getId()));
            add(annotation, Rect(hmargin+110+10, vnext, textwidth, 25));
            vnext += (25 + vspacing)*annotationLines;
        }
        add(new Label(N_("Rating: "), HALIGN_RIGHT),Rect(hmargin,vnext,110,25));
//         add(new RatingButton(aLevel),Rect(hmargin+110+10,vnext,40,25));
        add(new Label(N_("Average: "), HALIGN_RIGHT),Rect(hmargin+110+10+40+20,vnext,105,25));
        add(new Label(theRatingMgr->getAverageRating(aLevel), HALIGN_RIGHT),Rect(hmargin+110+10+40+20+105+10,vnext,25,25));
    }
    
    LevelInspector::~LevelInspector () {
    }
    
    bool LevelInspector::on_event (const SDL_Event &e) {
        return false;
    }
    
    void LevelInspector::on_action(gui::Widget *w) {
        if (w == back) {
            // save annotation - but avoid to save unnecessary empty annotations
            if (!annotation->getText().empty() || 
                    !app.state->getAnnotation(levelProxy->getId()).empty()) {
                app.state->setAnnotation(levelProxy->getId(), annotation->getText());
            }
            Menu::quit();
        } else if (w == screenshot) {
            ScreenshotViewer m(levelProxy);
            m.manage();
            invalidate_all();
        }
    }
    
    void LevelInspector::draw_background(ecl::GC &gc) {
        const video::VMInfo *vminfo = video::GetInfo();
        video::SetCaption (("Enigma - Level Inspector"));
        blit(gc, 0,0, enigma::GetImage("menu_bg", ".jpg"));
        blit(gc, vminfo->width-vminfo->thumbw-10-hmargin, vmargin, previewImage);
        Surface *img_hard = enigma::GetImage("completed");
        if (withEasy) {
            Surface *img_easy = enigma::GetImage("completed-easy");
            blit (gc, vminfo->width/2-4, vmargin+5*25+4*vspacing+16, img_easy);
            blit (gc, vminfo->width/2-4+63, vmargin+5*25+4*vspacing+16, img_hard);
        } else {
            blit (gc, vminfo->width/2-4+20, vmargin+5*25+4*vspacing+16, img_hard);
        }
    }
    
    void LevelInspector::tick(double dtime) {
    }

    std::string LevelInspector::ratingToString(int value) {
        if (value == 0) {
            // no rating available
            return "   ";
        } else {
            return ecl::strf("%3d", value);
        }
    }
    
    std::string LevelInspector::scoreToString(int easy, int difficult, 
            lev::Proxy *aLevel, bool constLengthForCenteredClipping) {
        if (withEasy) {
            if (!constLengthForCenteredClipping)
                return scoreToString(easy, aLevel) + " / " + 
                        scoreToString(difficult, aLevel);
            else
                if (aLevel->getScoreUnit() == lev::duration)
                    //
                    return (easy >= 0 ? "-  " : ":  ") + 
                            scoreToString(easy, aLevel) + " / " + 
                            scoreToString(difficult, aLevel) +
                            (difficult >= 0 ? "  -" : "  :") ;
                else
                    return (easy >= 0 ? "-  " : "   ") + 
                            scoreToString(easy, aLevel) + " / " + 
                            scoreToString(difficult, aLevel) +
                            (difficult >= 0 ? "  -" : "   ") ;
        } else {
            return scoreToString(difficult, aLevel);
        }
    }
    
    std::string LevelInspector::scoreToString(int score, lev::Proxy *aLevel) {
        if (aLevel->getScoreUnit() == lev::duration) 
            if (score >= 0 && score <= (99*60+59))
                return ecl::strf("%2d:%02d", score/60, score%60);
            else
                return "  -  ";
        else
            if (score >= 0 && score <= 9999)
                return ecl::strf("%4d", score);
            else
                return "   -";
    }
    
    void LevelInspector::dispatchBottomLines(int &bestScoreHolderLines, 
            int &creditsLines, int &dedicationLines, int &levelPathLines,
            int &annotationLines, int &compatibilityLines, int numLines, int width) {
        enum botType {holder, credits, dedication, path, annotation, compatibility};
        const int sequenceSize = 13;
        botType sequence[sequenceSize] = {credits, dedication, annotation, path,
                holder, annotation, path, credits, dedication, annotation,  credits,
                compatibility, annotation};
        int j = 0;
        std::string creditsString = levelProxy->getCredits(true);
        std::string dedicationString = levelProxy->getDedication(true);
        std::string pathWorkString = levelPathString;
        ecl::Font *menufont = enigma::GetFont("menufont");
        for (int i = 0; i<numLines; i++) {
            bool assigned = false;
            do {
                switch (sequence[j++]) {
                    case holder: 
                        bestScoreHolderLines++;
                        assigned = true;
                        break;
                    case credits: 
                        if (!(creditsString.empty())) {
                            creditsLines++;
                            creditsString = creditsString.substr(breakString(menufont,
                                    creditsString, " ", width));
                            assigned = true;
                        }
                        break;
                    case dedication: 
                        if (!(dedicationString.empty())) {
                            dedicationLines++;
                            dedicationString = dedicationString.substr(breakString(menufont,
                                    dedicationString, " ", width));
                            assigned = true;
                        }
                        break;
                    case path: 
                        if (!(pathWorkString.empty())) {
                            levelPathLines++;
                            pathWorkString = pathWorkString.substr(breakString(menufont,
                                    pathWorkString, "/", width));
                            assigned = true;
                        }
                        break;
                    case annotation: 
                        annotationLines++;
                        assigned = true;
                        break;
                    case compatibility: 
                        compatibilityLines++;
                        assigned = true;
                        break;
                }
                
            } while (!assigned && j < sequenceSize);
            if (j == sequenceSize)
                return;
        }
    }
    
}} // namespace enigma::lev
