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
')
/**
 * A native window wrapper
 */
@:access(windowmodcharting.WindowModManager)
class WindowNative
{
	@:functionCode('
        #ifdef HX_WINDOWS
        wn_windowTitle = windowTitle;
        #endif
    ')
	public static function defineWindowTitle(windowTitle:String):Void
	{
	}
}