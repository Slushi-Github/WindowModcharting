package windowmodcharting.backend.window;

@:buildXml('
<target id="haxe">
    <lib name="-ldl" if="linux"/>
</target>
')
@:cppFileCode('
#if defined(HX_LINUX)
#include <dlfcn.h>
#include <iostream>

typedef void* (*fn_SDL_GL_GetProcAddress)(const char*);
typedef void  (*fn_glEnable)(unsigned int);
typedef void  (*fn_glDisable)(unsigned int);
typedef void  (*fn_glScissor)(int, int, int, int);

// Cached proc pointers — resolved once on first call
static fn_SDL_GL_GetProcAddress wgl_getProc  = nullptr;
static fn_glEnable               wgl_enable   = nullptr;
static fn_glDisable              wgl_disable  = nullptr;
static fn_glScissor              wgl_scissor  = nullptr;
static bool                      wgl_ready    = false;

static bool wgl_init() {
    if (wgl_ready) return true;

    wgl_getProc = (fn_SDL_GL_GetProcAddress) dlsym(RTLD_DEFAULT, "SDL_GL_GetProcAddress");
    if (!wgl_getProc) return false;

    wgl_enable  = (fn_glEnable)  wgl_getProc("glEnable");
    wgl_disable = (fn_glDisable) wgl_getProc("glDisable");
    wgl_scissor = (fn_glScissor) wgl_getProc("glScissor");

    wgl_ready = wgl_enable && wgl_disable && wgl_scissor;

    if (wgl_ready) 
        std::cerr << "[\x1b[38;5;7mINFO\x1b[0m | windowmodcharting.backend.window.WindowNativeGL] OpenGL extensions loaded from lime.ndll" << std::endl;

    return wgl_ready;
}
#endif
')
/**
 * A class for OpenGL windowing
 */
class WindowNativeGL
{
	// GL_SCISSOR_TEST = 0x0C11
	static inline final GL_SCISSOR_TEST:Int = 0x0C11;

	@:functionCode('
        #if defined(HX_LINUX)
        if (!wgl_init()) return;
        wgl_enable(0x0C11);
        // GL scissor Y is bottom-up, so flip: y = totalH - cutTop - visibleH
        wgl_scissor(cutLeft, totalH - cutTop - visibleH, visibleW, visibleH);
        #endif
    ')
	public static function scissor(cutLeft:Int, cutTop:Int, visibleW:Int, visibleH:Int, totalH:Int):Void
	{
	}

	@:functionCode('
        #if defined(HX_LINUX)
        if (!wgl_init()) return;
        wgl_disable(0x0C11);
        #endif
    ')
	public static function clearScissor():Void
	{
	}
}