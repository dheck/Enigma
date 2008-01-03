/*
 * Copyright (C) 2002,2003,2004 Daniel Heck
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

#include "stones/OxydStone.hh"
#include "errors.hh"
#include "main.hh"
#include "server.hh"
#include "world.hh"
#include "lev/Proxy.hh"

namespace enigma {
 
    OxydStone::InstanceVector OxydStone::levelOxyds;
    bool OxydStone::isInit = false;
    std::vector<unsigned short> OxydStone::colorsUsageCount;
    unsigned short OxydStone::shuffledFakeCount;
    unsigned short OxydStone::shuffledFartCount;
    unsigned short OxydStone::shuffledBoldCount;
    bool OxydStone::oddUnshuffledColor;
    
    std::vector<unsigned short> OxydStone::randomOxydIds;
    std::vector<uint32_t> OxydStone::groupsMembers;
    std::vector<uint32_t> OxydStone::groupsSharedMembers;
    std::list<OxydStone::Rule> OxydStone::singleRulesMin;
    std::list<OxydStone::Rule> OxydStone::singleRulesMax;
    std::list<OxydStone::Rule> OxydStone::pairRulesMin;
    std::list<OxydStone::Rule> OxydStone::pairRulesMax;
    std::list<OxydStone::ShuffleFrame> OxydStone::shuffleStack;
    unsigned int OxydStone::logBadFrameCount;
    
    unsigned short OxydStone::numColorsAvailable() {
        return COLORCOUNT;  // may dependent on enigma compatibility in future!
    }
    
    void OxydStone::addShuffleRule(RuleType type, unsigned short limit, Value group1, Value group2) {
        Rule r;
        
        if (shuffleStack.size() == 0)
            shuffleStack.push_back(ShuffleFrame());
                
        ShuffleFrame &base = shuffleStack.front();
        
        r.groupId1 = groupId(group1);
        r.groupId2 = groupId(group2);
        r.ruleId = base.rulesLimit.size();
        
        base.rulesLimit.push_back(limit);
        
        ASSERT(groupsMembers[r.groupId1] != 0, XLevelRuntime, "Oxyd shuffle rule for an empty group");
        
        switch (type) {
            case RULE_SINGLE_MIN:
                singleRulesMin.push_back(r);
                break;
            case RULE_SINGLE_MAX:
                singleRulesMax.push_back(r);
                break;
            case RULE_PAIR_MIN:
                ASSERT(groupsMembers[r.groupId2] != 0, XLevelRuntime, "Oxyd shuffle rule for an empty group");
                pairRulesMin.push_back(r);
                break;
            case RULE_PAIR_MAX:
                ASSERT(groupsMembers[r.groupId2] != 0, XLevelRuntime, "Oxyd shuffle rule for an empty group");
                pairRulesMax.push_back(r);
                break;
        }
    }
        
    unsigned short OxydStone::groupId(Value v) {
        ASSERT(levelOxyds.size() < 32, XLevelRuntime, "Oxyd shuffle rule - error more than 32 oxyds");
        
        ObjectList objects = v;
        uint32_t groupOxydMask = 0;
        int count = 0;
        for (ObjectList::iterator i = objects.begin(); i != objects.end(); ++i) {
            for(unsigned short j = 0; j < levelOxyds.size(); ++j) {
                if ((*i) == levelOxyds[j]) {
                    groupOxydMask |= 1 << j;
                    count++;
                    break;
                }
            }
        }
        ASSERT(count == objects.size(), XLevelRuntime, "Oxyd shuffle rule - group member identification error");
        for(unsigned short j = 0; j < groupsMembers.size(); ++j) {
            if (groupOxydMask == groupsMembers[j])
                return j;
        }
        groupsMembers.push_back(groupOxydMask);
        return groupsMembers.size() - 1;
    }
    
    void OxydStone::initColors() {
        if (isInit)
            return;  // we are already initialized!
            
        unsigned short numColors = numColorsAvailable();
        colorsUsageCount = std::vector<unsigned short>(numColors);
        std::vector<unsigned short>colorsUsageCountNoShuffle(numColors);
        shuffledFakeCount = 0;
        shuffledFartCount = 0;
        shuffledBoldCount = 0;
        oddUnshuffledColor = false;
        
        InstanceVector autocoloredOxyds;
        size_t  isize = levelOxyds.size();
        // count color usage
        for (size_t i=0; i<isize; ++i) {
            int color = levelOxyds[i]->getAttr("color");
            bool declineShuffle = to_bool(levelOxyds[i]->getAttr("noshuffle"));
            if (color >= 0 && color < numColors) {
                colorsUsageCount[color]++;
                if (declineShuffle) colorsUsageCountNoShuffle[color]++;
            } else {
                switch (color) {
                    case AUTO:
                        ASSERT(!declineShuffle, XLevelRuntime, "Oxyd init colors - autocolored oxyd declined shuffle");
                        autocoloredOxyds.push_back(levelOxyds[i]);
                        break;
                    case FAKE:
                        if (!declineShuffle) shuffledFakeCount++;
                        break;
                    case FART:
                        if (!declineShuffle) shuffledFartCount++;
                        break;
                    case BOLD:
                        if (!declineShuffle) shuffledBoldCount++;
                        break;
                }
            }
        }
        bool onlyPairs = true;
        // fill up unpaired oxyds with auto colored oxyds
        for (int i = 0; i < numColors; i++) {
            if (colorsUsageCount[i] % 2 == 1) {
                if (autocoloredOxyds.size() > 0) {
                    autocoloredOxyds.back()->set_attrib("color", i);
                    autocoloredOxyds.pop_back();
                    colorsUsageCount[i]++;
                } else if (onlyPairs) {
                    onlyPairs = false;
                    break;
                } else {
                    ASSERT(server::AllowSingleOxyds, XLevelRuntime, "Oxyd init colors - too many unpaired oxyds with given color");
                }
            }
            if (colorsUsageCountNoShuffle[i] % 2 == 1) {
                oddUnshuffledColor = true;
            }
        }
        // colors for remaining auto colored oxyds
        Object *lastObject = NULL;     // keep reference of last colored oxyd
        unsigned short lastColor;
        if (autocoloredOxyds.size() % 2 == 1)   
            onlyPairs = false;  // we will color pairs - one oxyd remains 
        int dc = 0;
        while (autocoloredOxyds.size() > 0) {
            int c = (dc/2) % numColors;
            if (colorsUsageCount[c] <= 2*(dc/2/numColors) + 1) {
                lastColor = c;
                lastObject = autocoloredOxyds.back();
                lastObject->set_attrib("color", c);
                autocoloredOxyds.pop_back();
                colorsUsageCount[c]++;
            }
            dc++;
        }
        // substitute odd oxyd with a fake one
        if (!onlyPairs && lastObject != NULL) {
            lastObject->set_attrib("color", FAKE);
            colorsUsageCount[lastColor]--;
            shuffledFakeCount++;
        } else {
            ASSERT(onlyPairs || server::AllowSingleOxyds, XLevelRuntime, "Oxyd init colors - too many unpaired oxyds with given color");
        }
        
        isInit = true;
    }
    
    void OxydStone::shuffleColors(LogType logFlag) {
        initColors();
        
        unsigned short numColors = numColorsAvailable();
        bool onlyPairs = true;
        for (int i = 0; i < numColors; i++) {
            if (colorsUsageCount[i] != 0 && colorsUsageCount[i] != 2) {
                onlyPairs = false;
                break;
            }
        }
        
        if (shuffleStack.size() > 0  && onlyPairs && levelOxyds.size() < 32)
            fairShuffleColors(logFlag);
        else
            simpleShuffleColors();
    }
    
    void OxydStone::simpleShuffleColors() {
        
        std::vector<size_t> closedOxyds;
        size_t  isize = levelOxyds.size();
        for (size_t i=0; i<isize; ++i) {
            OxydStone *candidate = levelOxyds[i];
            if (candidate->iState == CLOSED && !to_bool(candidate->getAttr("noshuffle"))) {
                closedOxyds.push_back(i);
            }
        }
    
        unsigned size = closedOxyds.size();
        if (size>1) {
            for (unsigned i = 0; i<size; ++i) {
                unsigned a = IntegerRand(0, static_cast<int> (size-2));
                if (a >= i) ++a;        // make a always different from j
    
                OxydStone *o1 = levelOxyds[closedOxyds[i]];
                OxydStone *o2 = levelOxyds[closedOxyds[a]];
    
                Value icolor = o1->getAttr("color"); 
    
                o1->set_attrib("color", o2->getAttr("color"));
                o2->set_attrib("color", icolor);
            }
        }
    }
    
    void OxydStone::fairShuffleColors(LogType logFlag) {        
        unsigned short numOxyds = levelOxyds.size();
        
        // generate sequence of oxyds for randomness of distribution
        // the sequence contains even noshuffle pseudo oxyds as they are masked out
        // by the freeOxydMask prior being selected anywhere
        randomOxydIds = std::vector<unsigned short>(levelOxyds.size());
        for (int i = 0; i < randomOxydIds.size(); i++)
            randomOxydIds[i] = i;
        for (int i = 0; i < randomOxydIds.size() - 1; i++) {
            int j = IntegerRand(i, randomOxydIds.size() - 1);  // use enigma's internal rand!
            unsigned short t = randomOxydIds[i];
            randomOxydIds[i] = randomOxydIds[j];
            randomOxydIds[j] = t;
        }
        
        if (groupsSharedMembers.size() == 0) {
            // first shuffle call for given rules - initialize base frame
            
            // prepare exclusion of noshuffle pseudo oxyds
            uint32_t noshufflePseudoMask = 0; 
            for (int i = 0; i < numOxyds; i++) {
                OxydStone *candidate = levelOxyds[i];
                if ((int)candidate->getAttr("color") < AUTO && 
                        to_bool(candidate->getAttr("noshuffle")))
                    noshufflePseudoMask |= 1 << i;
            }
            
            // evaluate all group members that are shared with another group
            for (int i = 0; i < groupsMembers.size(); i++) {
                uint32_t shared = 0;
                for (int j = 0; j < groupsMembers.size(); j++) {
                    if (i != j)
                        shared |= (groupsMembers[i] & groupsMembers[j]);
                }
                groupsSharedMembers.push_back(shared & ~noshufflePseudoMask);
            }
            
            // init oxyd pair candidates
            uint32_t all = (((uint32_t)1 << (levelOxyds.size())) - 1)   // a 1 for every oxyd
                                & ~noshufflePseudoMask;
            ShuffleFrame &base = shuffleStack.front();
            for (int i = 0; i < numOxyds; i++) {
                uint32_t candidates = all & ~(1 << i);   // exclude itself
                base.oxydsCandidatesMask.push_back(candidates);   
                base.oxydsCandidatesCount.push_back(countOxyds(candidates));
            }
            base.freeOxydsMask = all;
            base.freePseudoCount = shuffledFakeCount + shuffledFartCount + shuffledBoldCount;
            base.freePairsCount = 0;
            for (int i = 0; i < numColorsAvailable(); i++) {
                base.freePairsCount += colorsUsageCount[i];
            }
            base.freePairsCount /= 2;
            base.selOxyd1Mask = 0;  // no oxyd assigned in this frame
            base.selOxyd2Mask = 0;
            base.openedOxydIndex = 0;
            base.fixedcolorOxydIndex = 0;
        }
        
        // make a copy of the base frame as the base frame should not be modified
        ShuffleFrame &top = shuffleStack.back();
        ShuffleFrame second = top;
                
        // remove not CLOSED pseudo oxyds
        uint32_t notClosedPseudoMask = 0; 
        for (int i = 0; i < numOxyds; i++) {
            OxydStone *candidate = levelOxyds[i];
            if ((int)candidate->getAttr("color") < AUTO && candidate->iState != CLOSED)
                notClosedPseudoMask |= 1 << i;
        }
        second.freeOxydsMask &= ~notClosedPseudoMask;
        for (int i = 0; i < numOxyds; i++) {
            second.oxydsCandidatesMask[i] &= ~notClosedPseudoMask;   
            second.oxydsCandidatesCount[i] = countOxyds(second.oxydsCandidatesMask[i]);
        }
        
        shuffleStack.push_back(second);
        
//        log_shuffle_basis();
//        log_shuffle_stack();
        logBadFrameCount = 0;
        
        if (logFlag == NOTHING) logFlag = SOLUTION;
        
        int result = evaluateTopFrame(logFlag);
        shuffleStack.pop_back();         // remove the copy
                
        if (server::LevelStatus >= lev::STATUS_TEST) {
            if (logFlag >= COUNT)
                Log << "Fair Shuffle found " << result << " distributions -  bad frames " << logBadFrameCount << "\n";
            else if (logFlag == SOLUTION)
                Log << "Fair Shuffle bad frames " << logBadFrameCount << "\n";
        }
        
        ASSERT(result > 0, XLevelRuntime, "Oxyd shuffle colors - no fair solution exists for given rules");
    }
    
    int OxydStone::evaluateTopFrame(LogType logFlag) {
        unsigned short numOxyds = levelOxyds.size();
        ShuffleFrame &top = shuffleStack.back();
        int solutionsCount = 0;
//        log_shuffle_stack();
                
        // postprocess frame for chosen oxyds
        if (top.selOxyd1Mask != 0) {   // skip for base frame
            
            // check that a chosen oxyd pair with both oxyds of given unchangeable color do 
            // not mismatch in color - refuse on mismatch. Note that any iState beside
            // CLOSED shows the color and thus makes a color change impossible
            if (top.selOxyd2Mask != 0) {
                OxydStone *o1 = levelOxyds[oxydId(top.selOxyd1Mask)];
                OxydStone *o2 = levelOxyds[oxydId(top.selOxyd2Mask)];
                if ((to_bool(o1->getAttr("noshuffle")) || o1->iState != CLOSED) &&
                        (to_bool(o2->getAttr("noshuffle")) || o2->iState != CLOSED) &&
                        (int)(o1->getAttr("color")) >= 0 &&  (int)(o2->getAttr("color")) >= 0 &&
                        o1->getAttr("color") != o2->getAttr("color")) {
                    logBadFrameCount++;
                    return 0;
                }
            }
            
            // remove chosen oxyds from list of disposable oxyds  
            top.freeOxydsMask &= ~top.selOxyd1Mask & ~top.selOxyd2Mask;
            
            // reduce free counts
            if (top.selOxyd2Mask != 0)
                top.freePairsCount--;
            else
                top.freePseudoCount--;
            
            // remove chosen oxyds from oxyd pair candidate lists
            uint32_t imask = 1;
            for (int i = 0; i < numOxyds; i++, imask <<= 1) {
                // need only to update oxyds that still need to be distributed
                if (top.freeOxydsMask & imask) {
                    if (top.oxydsCandidatesMask[i] & top.selOxyd1Mask) top.oxydsCandidatesCount[i]--;
                    if (top.oxydsCandidatesMask[i] & top.selOxyd2Mask) top.oxydsCandidatesCount[i]--;
                    top.oxydsCandidatesMask[i] &= top.freeOxydsMask;
                }
            }
            
            // reduce limits for affected rules
            if (top.selOxyd2Mask != 0) {   // pseudooxyds can not affect rules 
                for (std::list<Rule>::iterator itr = singleRulesMin.begin();
                        itr != singleRulesMin.end(); ++itr) {
                    uint32_t groupOxydMask = groupsMembers[(*itr).groupId1];
                    if (groupOxydMask & top.selOxyd1Mask && groupOxydMask & top.selOxyd2Mask)
                        top.rulesLimit[(*itr).ruleId]--;
                }
                for (std::list<Rule>::iterator itr = singleRulesMax.begin();
                        itr != singleRulesMax.end(); ++itr) {
                    uint32_t groupOxydMask = groupsMembers[(*itr).groupId1];
                    if (groupOxydMask & top.selOxyd1Mask && groupOxydMask & top.selOxyd2Mask)
                        top.rulesLimit[(*itr).ruleId]--;
                }
                for (std::list<Rule>::iterator itr = pairRulesMin.begin();
                        itr != pairRulesMin.end(); ++itr) {
                    uint32_t group1_oxyds = groupsMembers[(*itr).groupId1];
                    uint32_t group2_oxyds = groupsMembers[(*itr).groupId2];
                    if ((group1_oxyds & top.selOxyd1Mask && group2_oxyds & top.selOxyd2Mask) ||
                            (group1_oxyds & top.selOxyd2Mask && group2_oxyds & top.selOxyd1Mask))
                        top.rulesLimit[(*itr).ruleId]--;
                }
                for (std::list<Rule>::iterator itr = pairRulesMax.begin();
                        itr != pairRulesMax.end(); ++itr) {
                    uint32_t group1_oxyds = groupsMembers[(*itr).groupId1];
                    uint32_t group2_oxyds = groupsMembers[(*itr).groupId2];
                    if ((group1_oxyds & top.selOxyd1Mask && group2_oxyds & top.selOxyd2Mask) ||
                            (group1_oxyds & top.selOxyd2Mask && group2_oxyds & top.selOxyd1Mask))
                        top.rulesLimit[(*itr).ruleId]--;
                }
                
            }
        }
        
        // reduce pair candidates due to max rules
        
        // single group rules
        for (std::list<Rule>::iterator itr = singleRulesMax.begin();
                itr != singleRulesMax.end(); ++itr) {
            if (top.rulesLimit[(*itr).ruleId] == 0) {
                uint32_t hot_group_oxyds = groupsMembers[(*itr).groupId1] & top.freeOxydsMask;
                for (int j = 0; j < numOxyds; j++) {
                    if (hot_group_oxyds & (1 << j)) {
                        // eliminate group mates from list of candidates
                        top.oxydsCandidatesMask[j] &= ~groupsMembers[(*itr).groupId1];
                        top.oxydsCandidatesCount[j] = countOxyds(top.oxydsCandidatesMask[j]);
                    }
                }
                top.rulesLimit[(*itr).ruleId] = -1;  // mark rule as fulfilled
            }
        }
        // pair group rules
        for (std::list<Rule>::iterator itr = pairRulesMax.begin();
                itr != pairRulesMax.end(); ++itr) {
            if (top.rulesLimit[(*itr).ruleId] == 0) {
                uint32_t hot_group_oxyds1 = groupsMembers[(*itr).groupId1] & top.freeOxydsMask;
                uint32_t hot_group_oxyds2 = groupsMembers[(*itr).groupId2] & top.freeOxydsMask;
                for (int j = 0; j < numOxyds; j++) {
                    if (hot_group_oxyds1 & (1 << j)) {
                        // eliminate pair group oxyds from list of candidates
                        top.oxydsCandidatesMask[j] &= ~groupsMembers[(*itr).groupId2];
                        top.oxydsCandidatesCount[j] = countOxyds(top.oxydsCandidatesMask[j]);
                    }
                    // no else as a single oxyd can be in both groups
                    if (hot_group_oxyds2 & (1 << j)) {  
                        // eliminate pair group oxyds from list of candidates
                        top.oxydsCandidatesMask[j] &= ~groupsMembers[(*itr).groupId1];
                        top.oxydsCandidatesCount[j] = countOxyds(top.oxydsCandidatesMask[j]);
                    }
                }
                top.rulesLimit[(*itr).ruleId] = -1;  // mark rule as fulfilled
            }
        }


        // check if we have a free oxyd without any possibility to assign it
        if (top.freePseudoCount == 0) {
            for (int j = 0; j < numOxyds; j++) {
                if (top.freeOxydsMask & (1 << j)) {
                    if (top.oxydsCandidatesCount[j] == 0) {
                        logBadFrameCount++;
                        return 0;
                    }
                }
            }
        }
        
        // check if we are ready
        if (top.freeOxydsMask == 0) {
            // final complete min rules check
            for (std::list<Rule>::iterator itr = singleRulesMin.begin();
                    itr != singleRulesMin.end(); ++itr) {
                if (top.rulesLimit[(*itr).ruleId] > 0) {
                    // min rule not fulfilled - sorry we do not have a solution
                    logBadFrameCount++;
                    return 0;
                }
            }
            for (std::list<Rule>::iterator itr = pairRulesMin.begin();
                    itr != pairRulesMin.end(); ++itr) {
                if (top.rulesLimit[(*itr).ruleId] > 0) {
                    // min rule not fulfilled - sorry we do not have a solution
                    logBadFrameCount++;
                    return 0;
                }
            }
            
            // now it is official - we have a legal distribution
//            log_shuffle_stack();
            colorShuffleDistribtion(logFlag);
            return 1;
        }
        
        // quick partial check for min rules that can obviously not be fulfilled
        for (std::list<Rule>::iterator itr = singleRulesMin.begin();
                itr != singleRulesMin.end(); ++itr) {
            if (top.rulesLimit[(*itr).ruleId] * 2 > countOxyds(top.freeOxydsMask & groupsMembers[(*itr).groupId1])) {
                logBadFrameCount++;
                return 0;
            }
        }
        for (std::list<Rule>::iterator itr = pairRulesMin.begin();
                itr != pairRulesMin.end(); ++itr) {
            if ((top.rulesLimit[(*itr).ruleId] > countOxyds(top.freeOxydsMask & groupsMembers[(*itr).groupId1])) ||
                    (top.rulesLimit[(*itr).ruleId] > countOxyds(top.freeOxydsMask & groupsMembers[(*itr).groupId2]))) {
                logBadFrameCount++;
                return 0;
            }
        }
        
        
        // assign next oxyds
        ShuffleFrame next = top;
        next.selOxyd1Mask = 0;
        next.selOxyd2Mask = 0;

        // opened oxyd pairs first
        for (;next.openedOxydIndex < numOxyds; next.openedOxydIndex++) {
            if (levelOxyds[next.openedOxydIndex]->iState == OPEN_PAIR) {
                int c = levelOxyds[next.openedOxydIndex]->getAttr("color");
                for (int i = next.openedOxydIndex+1; i < numOxyds; i++) {
                    if (levelOxyds[i]->getAttr("color") == c) {
                        next.selOxyd1Mask = 1 << next.openedOxydIndex;
                        next.selOxyd2Mask = 1 << i;
                        next.openedOxydIndex++;
                        shuffleStack.push_back(next);    // add copy of next frame
                        int result = evaluateTopFrame(logFlag);
                        shuffleStack.pop_back();         // remove the copy
                        return result;
                    }
                }
            }
        }
        
        // pairs of noshuffle standard oxyds and other not closed oxyds including a possible blinking oxyd
        // it is essential to select known pairs first
        for (;next.fixedcolorOxydIndex < numOxyds; next.fixedcolorOxydIndex++) {
            OxydStone *candidate1 = levelOxyds[next.fixedcolorOxydIndex];
            int color1 = candidate1->getAttr("color");
            if ((int)candidate1->getAttr("color") > AUTO && (
                    to_bool(candidate1->getAttr("noshuffle")) || candidate1->iState == OPENING ||
                    candidate1->iState == CLOSING || candidate1->iState == OPEN_SINGLE )) {
                for (int i = next.fixedcolorOxydIndex+1; i < numOxyds; i++) {
                    OxydStone *candidate2 = levelOxyds[i];
                    if (candidate2->getAttr("color") == color1 && (
                            to_bool(candidate2->getAttr("noshuffle")) || candidate2->iState == OPENING ||
                            candidate2->iState == CLOSING || candidate2->iState == OPEN_SINGLE)) {
                        next.selOxyd1Mask = 1 << next.fixedcolorOxydIndex;
                        next.selOxyd2Mask = 1 << i;
                        if ((next.selOxyd2Mask & next.oxydsCandidatesMask[next.fixedcolorOxydIndex]) == 0)
                            return 0;   // Oops - a rule contradiction
                        next.fixedcolorOxydIndex++;
                        shuffleStack.push_back(next);    // add copy of next frame
                        int result = evaluateTopFrame(logFlag);
                        shuffleStack.pop_back();         // remove the copy
                        return result;
                    }
                }
            }
        }
        
        
        // fast handling of oxyd pairs mandatory due to min rules 
        // bypass on existing noshuffles, bypass on COUNT & ALL solutions
        if (logFlag < COUNT && !oddUnshuffledColor) {
            for (std::list<Rule>::iterator itr = singleRulesMin.begin();
                    itr != singleRulesMin.end(); ++itr) {
                // rule not yet fulfilled and group is disjoint in remaining members to all other groups 
                if ((top.rulesLimit[(*itr).ruleId] > 0) && 
                        ((groupsSharedMembers[(*itr).groupId1] & top.freeOxydsMask) == 0)) {
                    // we can assign a random pair in this group
                    next.selOxyd1Mask = randomMember(groupsMembers[(*itr).groupId1] & top.freeOxydsMask);
                    next.selOxyd2Mask = randomMember(groupsMembers[(*itr).groupId1] & top.freeOxydsMask
                            & ~next.selOxyd1Mask);
                    shuffleStack.push_back(next);    // add copy of next frame
                    int result = evaluateTopFrame(logFlag);
                    shuffleStack.pop_back();         // remove the copy
                    return result;
                }
            }
            for (std::list<Rule>::iterator itr = pairRulesMin.begin();
                    itr != pairRulesMin.end(); ++itr) {
                // rule not yet fulfilled and groups are disjoint in remaining members to all other groups 
                if ((top.rulesLimit[(*itr).ruleId] > 0) && 
                        ((groupsSharedMembers[(*itr).groupId1] & top.freeOxydsMask) == 0) &&
                        ((groupsSharedMembers[(*itr).groupId2] & top.freeOxydsMask) == 0) ) {
                    // we can assign a random pair between these groups
                    next.selOxyd1Mask = randomMember(groupsMembers[(*itr).groupId1] & top.freeOxydsMask);
                    next.selOxyd2Mask = randomMember(groupsMembers[(*itr).groupId2] & top.freeOxydsMask);
                    shuffleStack.push_back(next);    // add copy of next frame
                    int result = evaluateTopFrame(logFlag);
                    shuffleStack.pop_back();         // remove the copy
                    return result;
                }
            }
        }
        
        
        
        // unrestricted assignment of a new pair or a single pseudo
        
        // search oxyd with lowest degree of freedom for pair candidates
        unsigned short minFreeOxydId = numOxyds;  // impossible id 
        for (int i = 0; i < numOxyds; i++) {
            unsigned short j = randomOxydIds[i];
            if (next.freeOxydsMask & (1 << j)) {
                if (minFreeOxydId == numOxyds)
                    minFreeOxydId = j;
                else if (next.oxydsCandidatesCount[j] < next.oxydsCandidatesCount[minFreeOxydId])
                    minFreeOxydId = j;
            }
        }
        // try to assign all pair candidates to this oxyd 
        if (next.freePairsCount > 0 && next.oxydsCandidatesCount[minFreeOxydId] > 0) {
            next.selOxyd1Mask = 1 << minFreeOxydId;
            uint32_t candidates = next.oxydsCandidatesMask[minFreeOxydId];
            // check all candidates in random sequence
            for (int i = 0; i < numOxyds; i++) {
                unsigned short j = randomOxydIds[i];
                if (candidates & (1 << j)) {
                    next.selOxyd2Mask = 1 << j;
                    shuffleStack.push_back(next);    // add copy of next frame
                    int result = evaluateTopFrame(logFlag);
                    shuffleStack.pop_back();         // remove the copy
                    if (result > 0 && logFlag < COUNT)  // found solution - finish
                        return result;
                    // sum solutions
                    solutionsCount += result;
                }
            }
        }
        
        // try to assign a single pseudo oxyd
        // check that minFreeOxydId is not a noshuffle standard oxyd that can not
        // be recolored to a pseudo!
        OxydStone *pseudocandidate = levelOxyds[minFreeOxydId];
        if (next.freePseudoCount > 0 && ((int)pseudocandidate->getAttr("color") < AUTO || 
                (!(to_bool(pseudocandidate->getAttr("noshuffle"))) &&
                pseudocandidate->iState == CLOSED))) {
            next.selOxyd1Mask = 1 << minFreeOxydId;
            next.selOxyd2Mask = 0;
            shuffleStack.push_back(next);    // add copy of next frame
            int result = evaluateTopFrame(logFlag);
            shuffleStack.pop_back();         // remove the copy
            if (result > 0 && logFlag < COUNT)  // found solution - finish
                return result;
            // sum solutions
            solutionsCount += result;
        }
        
        return solutionsCount;
    }
    
    void OxydStone::colorShuffleDistribtion(LogType logFlag) {
        if (logFlag == COUNT)
            return;
            
        unsigned short numColors = numColorsAvailable();
        std::vector<unsigned short> colorsRemainCount = colorsUsageCount;
        unsigned short remainFakeCount = shuffledFakeCount;
        unsigned short remainFartCount = shuffledFartCount;
        unsigned short remainBoldCount = shuffledBoldCount;
        
        // distribute colors of pairs with noshuffle, open, blinking oxyds and the pseudooxyds
        for (std::list<ShuffleFrame>::iterator itr = shuffleStack.begin(); itr != shuffleStack.end(); ++itr) {
            (*itr).isColored = false;
            if ((*itr).selOxyd1Mask != 0) {
                if ((*itr).selOxyd2Mask == 0) {
                    // a single oxyd -- it must be a pseudo
                    OxydStone *oxyd = levelOxyds[oxydId((*itr).selOxyd1Mask)];
                    ASSERT(remainFakeCount + remainFartCount + remainBoldCount > 0, XLevelRuntime, "Oxyd shuffle - to few pseudo colors");
                    int i = IntegerRand(1, remainFakeCount + remainFartCount + remainBoldCount);  // use enigma's internal rand!
                    if (i <= remainFakeCount) {
                        remainFakeCount--;
                        oxyd->set_attrib("color", FAKE);
                    } else if ( i <= remainFakeCount + remainFartCount) {
                        remainFartCount--;
                        oxyd->set_attrib("color", FART);
                    } else {
                        remainBoldCount--;
                        oxyd->set_attrib("color", BOLD);
                    }
                    (*itr).isColored = true;
                } else {
                    // check if one of the pairs oxyds determines the color
                    OxydStone *oxyd1 = levelOxyds[oxydId((*itr).selOxyd1Mask)];
                    OxydStone *oxyd2 = levelOxyds[oxydId((*itr).selOxyd2Mask)];
                    int c = AUTO;
                    if (oxyd1->iState == OPEN_PAIR) {
                        // a pair of opened oxyds - we need not to recolor
                        // but we need to register the used color
                        c = oxyd1->getAttr("color");
                        colorsRemainCount[c] -= 2;                        
                        (*itr).isColored = true;
                    }
                    else if (to_bool(oxyd1->getAttr("noshuffle")) || oxyd1->iState != CLOSED) {
                        // a standard oxyd (pseudo is impossible) that requires a color
                        c = oxyd1->getAttr("color");
                        oxyd2->set_attrib("color", c);
                        colorsRemainCount[c] -= 2;
                        (*itr).isColored = true;
                    }
                    else if (to_bool(oxyd2->getAttr("noshuffle")) || oxyd2->iState != CLOSED) {
                        c = oxyd2->getAttr("color");
                        oxyd1->set_attrib("color", c);
                        colorsRemainCount[c] -= 2;
                        (*itr).isColored = true;
                    }
                }
            }
        }
        
        // distribute free colorable oxyd pairs
        
        // shuffle remaining colors
        std::vector<unsigned short> colorPairs;
        for (int c = 0; c < numColors; c++) {
            for (int i = 0; i < colorsRemainCount[c] / 2; i++) {
                colorPairs.push_back(c);
            }
        }
        for (int i = 0; i < (int)colorPairs.size() - 1; i++) {  // cast is essential for sub.!
            int j = IntegerRand(i, colorPairs.size() - 1);  // use enigma's internal rand!
            unsigned short t = colorPairs[i];
            colorPairs[i] = colorPairs[j];
            colorPairs[j] = t;
        }
        // color the remaining pairs on the stack
        int ci = 0;
        for (std::list<ShuffleFrame>::iterator itr = shuffleStack.begin(); itr != shuffleStack.end(); ++itr) {
            if (!(*itr).isColored && (*itr).selOxyd1Mask != 0) {
                levelOxyds[oxydId((*itr).selOxyd1Mask)]->set_attrib("color", colorPairs[ci]);
                levelOxyds[oxydId((*itr).selOxyd2Mask)]->set_attrib("color", colorPairs[ci]);
                ci++;
            }
        }
         
        
        if (logFlag > NOTHING &&  server::LevelStatus >= lev::STATUS_TEST) {
            Log << "Shuffle solution found: ";
            int depth = 0;
            for (std::list<ShuffleFrame>::iterator itr = shuffleStack.begin(); itr != shuffleStack.end(); ++itr, depth++) {
                if ((*itr).selOxyd2Mask != 0)
                    Log << ecl::strf("(%d-%d),", oxydId((*itr).selOxyd1Mask), oxydId((*itr).selOxyd2Mask));
                else if ((*itr).selOxyd1Mask != 0)
                    Log << ecl::strf("(%d),", oxydId((*itr).selOxyd1Mask));
            }
            Log << std::endl;
        }
    }
    
    unsigned short OxydStone::countOxyds(uint32_t members) {
        unsigned short numOxyds = levelOxyds.size();
        unsigned short result = 0;
        for (int j = 0; j < numOxyds; j++) {
            if (members & 1)
                result++;
            members = members >> 1;
        }
        return result;
    }
    
    uint32_t OxydStone::randomMember(uint32_t members) {
        ASSERT(members != 0, XLevelRuntime, "Oxyd shuffle - random member out of no selection");
        
        unsigned short numOxyds = levelOxyds.size();
        for (int i = 0; i < numOxyds; i++) {
            uint32_t candidate = (1 << randomOxydIds[i]);
            if (members & candidate) {
                return candidate;
            }
        }
        ASSERT(false, XLevelRuntime, "Oxyd shuffle - random member no candidate found");
        return 0;
    }
    
    unsigned short OxydStone::oxydId(uint32_t mask) {
        unsigned short numOxyds = levelOxyds.size();
        for (unsigned short i = 0; i < numOxyds; i++) {
            if (mask == 1)
                return i;
            mask >>= 1;
        }
        ASSERT(false, XLevelRuntime, "Oxyd shuffle - oxydId attempt to convert bad mask");
    }
    
    void OxydStone::log_shuffle_basis() {
        Log << "Oxyd Shuffle basis data\n";
        for (int i=0; i < groupsMembers.size(); i++)
            Log << ecl::strf("Group %d - %X\n", i, groupsMembers[i]);
        for (int i=0; i < groupsSharedMembers.size(); i++)
            Log << ecl::strf("Group shared members %d - %X\n", i, groupsSharedMembers[i]);
        for (std::list<Rule>::iterator itr = singleRulesMin.begin();
                itr != singleRulesMin.end(); ++itr)
            Log << ecl::strf("Single Min Rule - id %d - group %d\n", (*itr).ruleId, (*itr).groupId1); 
        for (std::list<Rule>::iterator itr = singleRulesMax.begin();
                itr != singleRulesMax.end(); ++itr)
            Log << ecl::strf("Single Max Rule - id %d - group %d\n", (*itr).ruleId, (*itr).groupId1); 
        for (std::list<Rule>::iterator itr = pairRulesMin.begin();
                itr != pairRulesMin.end(); ++itr)
            Log << ecl::strf("Pair Min Rule - id %d - group %d - group %d\n", (*itr).ruleId, (*itr).groupId1, (*itr).groupId2); 
        for (std::list<Rule>::iterator itr = pairRulesMax.begin();
                itr != pairRulesMax.end(); ++itr)
            Log << ecl::strf("Pair Max Rule - id %d - group %d - group %d\n", (*itr).ruleId, (*itr).groupId1, (*itr).groupId2);
        for (int i=0; i < randomOxydIds.size(); i++)
            Log << ecl::strf("Sequence %d - oxyd %d\n", i, randomOxydIds[i]);  
    }
    
    void OxydStone::log_shuffle_stack() {
        int depth = 0;
        for (std::list<ShuffleFrame>::iterator itr = shuffleStack.begin(); itr != shuffleStack.end(); ++itr, depth++) {
            Log << ecl::strf("Stack frame %d -- freeOxydsMask %X - %X %X - pseudo %d - pair %d\n", depth, (*itr).freeOxydsMask, (*itr).selOxyd1Mask, (*itr).selOxyd2Mask, (*itr).freePseudoCount, (*itr).freePairsCount);
            for (int i=0; i < (*itr).oxydsCandidatesMask.size(); i++)
                 Log << ecl::strf("Oxyd %d - candidates %X - num %d\n", i, 
                        (*itr).oxydsCandidatesMask[i], (*itr).oxydsCandidatesCount[i]);
            for (int i=0; i < (*itr).rulesLimit.size(); i++)
                 Log << ecl::strf("Rule %d - limit %d\n", i, (*itr).rulesLimit[i]);
        }
    }
    
    void OxydStone::invalidateShuffle() {
        shuffleStack.clear();
        groupsMembers.clear();
        groupsSharedMembers.clear();
        singleRulesMin.clear();
        singleRulesMax.clear();
        pairRulesMin.clear();
        pairRulesMax.clear();
        colorsUsageCount.clear();
        isInit = false;
    }
    
    // Instance Methods
    
    OxydStone::OxydStone() : PhotoStone("st-oxyd"), iState (CLOSED) {
        set_attrib("flavor", "b");
        set_attrib("color", AUTO);
    }
    
    OxydStone * OxydStone::clone() { 
        OxydStone *o = new OxydStone(*this); 
        levelOxyds.push_back(o);
        invalidateShuffle();
        return o;
    }
    
    void OxydStone::dispose() {
        levelOxyds.erase(find(levelOxyds.begin(), levelOxyds.end(), this));
        invalidateShuffle();
        delete this;
    }
    
    Value OxydStone::message(const Message &m) {
        if (m.message == "closeall") {
            closeAllStandardOxyds();
            return Value();
        }
        else if (m.message == "shuffle") {
            shuffleColors();
            return Value();
        }
        else if (m.message == "trigger" || m.message == "spitter") {
            tryOpen();
            return Value();
        }
        else if (m.message == "signal" && m.value != 0) {
            tryOpen();
            return Value();
        }
        else if (m.message == "init") {
            initColors();
            return Value();
        }
        return PhotoStone::message(m);
    }
    
    void OxydStone::set_attrib(const string& key, const Value &val) {
        if (key == "color") 
            ASSERT(iState == CLOSED, XLevelRuntime, "OxydStone error - recoloring of an not closed stone");
        else if (key == "flavor") {
            ASSERT(iState == CLOSED, XLevelRuntime, "OxydStone error - reflavoring of an not closed stone");
        }
        
        Object::set_attrib(key, val);   // do value checking
        
        if (key == "flavor" && IsInsideLevel(get_pos()))
            set_model(string("st-oxyd")+(std::string)val);
    }
    
    Value OxydStone::getAttr(const string &key) const {
        // TODO "state" 0=CLOSE || CLOSING; 1 = other iState values
        return PhotoStone::getAttr(key);
    }
    
    void OxydStone::actor_hit(const StoneContact &/*sc*/) {
        tryOpen();
    }
    
    bool OxydStone::is_removable() const {
        return !getAttr("static").to_bool();
    }
    
    void OxydStone::animcb() {
        if (iState == CLOSING)
            set_iState(CLOSED);
        else if (iState == OPENING)
            set_iState(OPEN_SINGLE);
        else if (iState == OPEN_PAIR)     // end of opening anim for second oxyd in a pair
            set_iState(OPEN_PAIR);      // set the right model
        else if (iState == OPEN_SINGLE)   // pseudo animation
            set_iState(CLOSING);
    }
    
    void OxydStone::on_creation (GridPos) {
        string flavor(getDefaultedAttr("flavor", "a"));
        set_model(string("st-oxyd") + flavor);
        photo_activate();
    }
    
    void OxydStone::on_removal(GridPos p) {
        photo_deactivate();
        kill_model (p);
    }
    
    void OxydStone::tryOpen() {
        bool isSingleOpened = false;
        OxydStone *pairCandidate = NULL;
        
        initColors();
        
        // check for a blocking pseudo
        for (InstanceVector::iterator itr = levelOxyds.begin(); itr != levelOxyds.end(); ++itr) {
            if ((*itr)->iState != CLOSED && (int)((*itr)->getAttr("color")) < AUTO) {
                // a pseudo is blocking any opening of other oxyds
                // this is necessary as the bold reshuffle can take place only after
                // finishing its closing animation!
                return;
            }
            if ((*itr)->iState == OPEN_SINGLE || (*itr)->iState == OPENING) {
                // remember a standard colored pair candidate
                isSingleOpened = true;
                pairCandidate = *itr;
            }
        }
        
        Value mycolor = getAttr("color");    
        if ((int)mycolor < AUTO) {
            // pseudo open
            if (isSingleOpened) {
                // a standard single oxyd is open - close it
                pairCandidate->set_iState(CLOSING);
            }
            // open FART and BOLD, keep FAKE closed
            if ((int)mycolor <= FART)
                set_iState(OPENING);
        }
        else if (iState == CLOSED || iState == CLOSING) {
            // standard colored oxyd open
            
            if (isSingleOpened) {
                bool can_open;
    
                if (server::GameCompatibility != GAMET_ENIGMA) {
                    // If colors match and stone (*i) is already blinking,
                    // open both stones. Close one of them otherwise.
                    // (This is the Oxyd behaviour; it doesn't work with
                    // some Enigma levels.)
                    can_open = (mycolor == pairCandidate->getAttr("color") && pairCandidate->iState==OPEN_SINGLE);
                }
                else 
                    can_open = (mycolor == pairCandidate->getAttr("color"));
    
                if (can_open) {
                    set_iState(OPEN_PAIR);
                    pairCandidate->set_iState(OPEN_PAIR);
                } else {
                    pairCandidate->set_iState(CLOSING);
                    set_iState(OPENING);
                }
            }
            else {
                // no blinking stone? -> make this one blink
                set_iState(OPENING);
            }
        }
    }
    
    void OxydStone::closeAllStandardOxyds() {
        for (unsigned i=0; i<levelOxyds.size(); ++i)
            if ((int)(levelOxyds[i]->getAttr("color")) >= AUTO)
                levelOxyds[i]->set_iState(CLOSING);
    }
    
    void OxydStone::set_iState(State newState) {
        string flavor(getDefaultedAttr("flavor","a"));
        string color(getDefaultedAttr("color", 0));
    
        string basemodelname = string("st-oxyd") + flavor;
        string modelname = basemodelname + color;
    
        State oldState = iState;
        iState = newState;
    
        switch (newState) {
            case CLOSED:
                if ((int)getAttr("color") == BOLD)
                    shuffleColors();    // shuffle all closed oxyds including itself
                    
                set_model(string("st-oxyd")+flavor);
                break;
        
            case OPEN_SINGLE:
                if ((int)getAttr("color") <= FART) {
                    set_anim(basemodelname + "-pseudo" + color);
                    if ((int)getAttr("color") == FART) {
                        closeAllStandardOxyds();
                        sound_event("fart");
                    } else if ((int)getAttr("color") == BOLD) {
                        sound_event("shuffle");
                    }
                } else
                    set_model(modelname + "-blink");
                break;
        
            case OPEN_PAIR:
                if (oldState == CLOSED) {
                    sound_event("oxydopen");
                    sound_event("oxydopened");
                    set_anim(modelname+"-opening");
                } else {
                    set_model(modelname + "-open");
                }
                // If this was the last closed oxyd stone, finish the level
                if (find_if(levelOxyds.begin(),levelOxyds.end(),not_open)
                        == levelOxyds.end()) {
                    server::FinishLevel();
                }
                break;
        
            case OPENING:
                sound_event("oxydopen");
                if (oldState == CLOSED)
                    set_anim(modelname + "-opening");
                else if (oldState == CLOSING)
                    get_model()->reverse();
        
                break;
        
            case CLOSING:
                if (oldState == CLOSED || oldState==CLOSING) {
                    iState = oldState;
                    return;
                }
        
                sound_event("oxydclose");
                if (oldState == OPENING)
                    get_model()->reverse();
                else if (oldState == OPEN_SINGLE || oldState == OPEN_PAIR) {
                    set_anim(modelname + "-closing");
                }
                break;
        }
    }
    

    BOOT_REGISTER_START
        BootRegister(new OxydStone);
    BOOT_REGISTER_END

} // namespace enigma
