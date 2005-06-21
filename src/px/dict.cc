#include "dict.hh"

unsigned 
px::hash(const std::string &key)
{
    unsigned h=0, g;
    for (const char *p=key.c_str(); *p; ++p)
    {
    	h = (h<<4) + *p;
	g = h & 0xf0000000;
    	if (g != 0) {
	    h = h ^ (g>>24);
	    h = h ^ g;
	}
    }
    return h;
}
