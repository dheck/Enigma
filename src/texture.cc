#include "texture.hh"
#include "main.hh"
#include <map>
#include <string>

using namespace enigma;

namespace {
typedef std::map<std::string, Texture> TextureCache;
TextureCache textureCache;
}

Texture enigma::dummyTexture = {0, 0, 0, false};

void enigma::CreateTexture(ecl::Surface *s, Texture *tex) {
    GLuint texid;
    glGenTextures(1, &texid);
    glBindTexture(GL_TEXTURE_2D, texid);

    GLenum err = glGetError();
    if (err != 0)
        fprintf(stderr, "Could not create texture.\n");

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, s->width(), s->height(), 0, 
            GL_BGRA, GL_UNSIGNED_BYTE, s->scanline_pointer(0));

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    tex->id = texid;
    tex->width = s->width();
    tex->height = s->height();
    tex->alpha = (s->get_surface()->flags & SDL_SRCALPHA) != 0;
}




const Texture &enigma::GetTexture(const char *name, const char *ext) {
    std::string filename;
    if (!app.resourceFS->findImageFile (string(name) + ext, filename)) 
        return dummyTexture;

    TextureCache::iterator it = textureCache.find(filename);
    if (it == textureCache.end()) {
        ecl::Surface *img = ecl::LoadImage(filename.c_str());
        if (img == NULL)
            return dummyTexture;
        Texture tex;
        CreateTexture(img, &tex);
        it = textureCache.insert(make_pair(filename, tex)).first;
    }
    return it->second;
}

void enigma::blit(const Texture &tex, int x, int y) {
    glEnable(GL_TEXTURE_2D);
    if (tex.alpha) {
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glEnable(GL_BLEND);
    } else
        glDisable(GL_BLEND);
    glBindTexture(GL_TEXTURE_2D, tex.id);
    glBegin(GL_QUADS);
    glTexCoord2f(0,0); glVertex3f(x, y, 0);
    glTexCoord2f(1,0); glVertex3f(x + tex.width, y, 0);
    glTexCoord2f(1,1); glVertex3f(x + tex.width, y + tex.height, 0);
    glTexCoord2f(0,1); glVertex3f(x, y + tex.height, 0);
    glEnd();
    glDisable(GL_TEXTURE_2D);
}
