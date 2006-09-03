/*
 * Copyright (C) 2005 Ronald Lamprecht
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

#ifndef ENIGMA_UTF8TOXML_HH
#define ENIGMA_UTF8TOXML_HH

#include <iostream>
#include <xercesc/util/XMLString.hpp>


namespace enigma
{
    /**
     * Transcoding utility for utf-8 strings to XMLCh strings
     * Provides a simple interface for the memory management paradigm shift
     * even though not terribly efficient. Make sure all Utf8toXML objects
     * exist only temporarily, f.e. 
     * <code>DOMNode::setNodeValue(Utf8ToXML(char *toTranscode).x_str())</code> or
     * <code>XMLString::replicate(Utf8ToXML(char *toTranscode).x_str())</code>
     * Xerces should be initialized before using this class and all objects
     * should be deleted before terminating.
     */
    class Utf8ToXML {
    public :
        /**
         * Makes a transcoding to XML.
         *
         * @param toTranscode utf-8 coded string
         */
        Utf8ToXML(const char * const toTranscode);
        /**
         * Makes a transcoding to the local code page.
         *
         * @param toTranscode utf-8 coded string
         */
        Utf8ToXML(const std::string * const toTranscode);
        /**
         * Makes a transcoding to the local code page.
         *
         * @param toTranscode utf-8 coded string
         */
        Utf8ToXML(const std::string toTranscode);
        ~Utf8ToXML();

        /**
         * Returns the XML string. It remains owner of
         * the string.
         */
        const XMLCh * x_str() const;

    private :
        /**
         * A XML copy. We are the owner.
         */
        XMLCh * xmlString;
        void init(const char * const toTranscode);
    };
} //namespace enigma
#endif

