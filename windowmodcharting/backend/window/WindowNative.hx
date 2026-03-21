package windowmodcharting.backend.window;

@:buildXml('
<target id="haxe">
    <lib name="dwmapi.lib" if="windows"/>
    <lib name="shell32.lib" if="windows"/>
    <lib name="gdi32.lib" if="windows"/>
    <lib name="advapi32.lib" if="windows"/>
    <lib name="-ldl" if="linux"/>
    <lib name="-lxcb" if="linux"/>
    <lib name="-lX11" if="linux"/>
    <lib name="-lX11-xcb" if="linux"/>
</target>
')
@:cppFileCode('
// Windows /////
#ifdef HX_WINDOWS
#include <Windows.h>
#include <windowsx.h>
#include <dwmapi.h>
#include <winuser.h>
#include <Shlobj.h>
#include <string>

#pragma comment(lib, "Dwmapi")
#pragma comment(lib, "user32.lib")
#pragma comment(lib, "Shell32.lib")
#pragma comment(lib, "gdi32.lib")

static std::string wn_windowTitle = "Not Set";

static HWND wn_getMainWindow() {
    HWND hwnd = GetForegroundWindow();
    char buf[256];
    GetWindowTextA(hwnd, buf, sizeof(buf));
    if (wn_windowTitle == buf) return hwnd;
    return FindWindowA(NULL, wn_windowTitle.c_str());
}
#endif

// Linux X11 /////
#ifdef HX_LINUX
#include <dlfcn.h>
#include <SDL2/SDL_syswm.h>
#include <xcb/xcb.h>
#include <X11/Xlib.h>
#include <X11/Xlib-xcb.h>
#include <cstring>

typedef SDL_Window* (*fn_SDL_GetWindowFromID)(Uint32);
typedef SDL_bool    (*fn_SDL_GetWindowWMInfo)(SDL_Window*, SDL_SysWMinfo*);

static xcb_connection_t* wn_conn = nullptr;
static xcb_window_t      wn_xwin = 0;

static xcb_atom_t wn_getAtom(xcb_connection_t* conn, const char* name) {
    xcb_intern_atom_cookie_t c = xcb_intern_atom(conn, 0, strlen(name), name);
    xcb_intern_atom_reply_t* r = xcb_intern_atom_reply(conn, c, nullptr);
    xcb_atom_t atom = r->atom;
    free(r);
    return atom;
}

static void wn_init(int windowId) {
    if (wn_conn != nullptr) return;

    // Get SDL functions from SDL2 library loaded with dlopen (from lime.ndll!)
    fn_SDL_GetWindowFromID pGetWindowFromID = (fn_SDL_GetWindowFromID) dlsym(RTLD_DEFAULT, "SDL_GetWindowFromID");
    fn_SDL_GetWindowWMInfo pGetWindowWMInfo = (fn_SDL_GetWindowWMInfo) dlsym(RTLD_DEFAULT, "SDL_GetWindowWMInfo");
    if (!pGetWindowFromID || !pGetWindowWMInfo) return;

    SDL_Window* win = pGetWindowFromID((Uint32)windowId);
    if (!win) return;

    SDL_SysWMinfo info;
    SDL_VERSION(&info.version);
    if (!pGetWindowWMInfo(win, &info)) return;
    if (info.subsystem != SDL_SYSWM_X11) return;

    wn_conn = XGetXCBConnection(info.info.x11.display);
    wn_xwin = (xcb_window_t)info.info.x11.window;
}

static void wn_setOpacity(float alpha) {
    if (!wn_conn || !wn_xwin) return;
    uint32_t opacity = (uint32_t)(alpha * (float)0xFFFFFFFF);
    xcb_atom_t atom = wn_getAtom(wn_conn, "_NET_WM_WINDOW_OPACITY");
    xcb_change_property(wn_conn, XCB_PROP_MODE_REPLACE, wn_xwin,
        atom, XCB_ATOM_CARDINAL, 32, 1, &opacity);
    xcb_flush(wn_conn);
}

static float wn_getOpacity() {
    if (!wn_conn || !wn_xwin) return 1.0f;
    xcb_atom_t atom = wn_getAtom(wn_conn, "_NET_WM_WINDOW_OPACITY");
    xcb_get_property_cookie_t c = xcb_get_property(wn_conn, 0, wn_xwin,
        atom, XCB_ATOM_CARDINAL, 0, 1);
    xcb_get_property_reply_t* r = xcb_get_property_reply(wn_conn, c, nullptr);
    if (!r || xcb_get_property_value_length(r) == 0) { free(r); return 1.0f; }
    uint32_t raw = *(uint32_t*)xcb_get_property_value(r);
    free(r);
    return (float)raw / (float)0xFFFFFFFF;
}

static void wn_setDecorations(bool show) {
    if (!wn_conn || !wn_xwin) return;
    struct { uint32_t flags; uint32_t functions; uint32_t decorations; int32_t input_mode; uint32_t status; } hints = {2, 0, (uint32_t)show, 0, 0};
    xcb_atom_t atom = wn_getAtom(wn_conn, "_MOTIF_WM_HINTS");
    xcb_change_property(wn_conn, XCB_PROP_MODE_REPLACE, wn_xwin,
        atom, atom, 32, 5, &hints);
    xcb_flush(wn_conn);
}
#endif
')
/**
 * A native window wrapper
 */
@:access(windowmodcharting.WindowModManager)
class WindowNative
{
	/**
	 * Prepare the window for backend usage on Linux
	 */
    @:deprecated("This function is unstable. Please don't use it!")
	public static function LinuxInit():Void
	{
		#if (cpp && linux && desktop)
		final window = Application.current.window;
		untyped __cpp__('wn_init({0})', window.id);
		WindowModManager.log("Native SDL window prepared for Linux!", WMLogLevel.INFO);
		#end
	}

	@:functionCode('
        #ifdef HX_WINDOWS
        wn_windowTitle = windowTitle;
        #endif
    ')
	public static function defineWindowTitle(windowTitle:String):Void
	{
	}

	@:functionCode('
        #ifdef HX_WINDOWS
        ShowWindow(wn_getMainWindow(), show ? SW_SHOW : SW_HIDE);
        #endif
    ')
	public static function setWindowVisible(show:Bool):Void
	{
	}

	@:functionCode('
        #ifdef HX_WINDOWS
        HWND hwnd = wn_getMainWindow();
        SetWindowLong(hwnd, GWL_EXSTYLE, GetWindowLong(hwnd, GWL_EXSTYLE) | WS_EX_LAYERED);
        float a = alpha < 0 ? 0 : (alpha > 1 ? 1 : alpha);
        SetLayeredWindowAttributes(hwnd, 0, (BYTE)(a * 255), LWA_ALPHA);
        #endif
        #ifdef HX_LINUX
        float a = alpha < 0 ? 0 : (alpha > 1 ? 1 : (float)alpha);
        wn_setOpacity(a);
        #endif
    ')
	public static function setWindowAlpha(alpha:Float):Void
	{
	}

	@:functionCode('
        #ifdef HX_WINDOWS
        HWND hwnd = wn_getMainWindow();
        DWORD exStyle = GetWindowLong(hwnd, GWL_EXSTYLE);
        if (exStyle & WS_EX_LAYERED) {
            BYTE a; DWORD flags;
            GetLayeredWindowAttributes(hwnd, NULL, &a, &flags);
            return (float)a / 255.0f;
        }
        return 1.0f;
        #endif
        #ifdef HX_LINUX
        return wn_getOpacity();
        #endif
        return 1.0f;
    ')
	public static function getWindowAlpha():Float
	{
		return 1.0;
	}
}