#ifndef TEXTURE_HH_INCLUDED
#define TEXTURE_HH_INCLUDED

#include <ecl_video.hh>

namespace enigma {

struct Texture {
    GLuint id;
    int width, height;
    bool alpha;
};

extern Texture dummyTexture;
    
void CreateTexture(ecl::Surface *s, Texture *tex);
const Texture &GetTexture(const char *name, const char *ext = ".png");

void blit(const Texture &tex, int x, int y);

} // namespace enigma

#endif
