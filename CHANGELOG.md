# CHANGELOG

## v0.1.2

- Added `Alpha` modifier for the window, now you can change the alpha of the window using directly `lime.app.Application.current.window.opacity`, allowing work on Linux and Windows at the same time. The C++ code related to those functions has been removed.

- Added `Visible` modifier for the window, now you can change the visibility of the window using directly `lime.app.Application.current.window.visible`, when using the `Visible` modifier of the value is set to 0 or less than 1, the window will become invisible and lose focus (plus, the icon will disappear from the operating system's taskbar, which is cool); setting it to 1 will make the window visible again and attempt to regain focus automatically by calling `lime.app.Application.current.window.focus()`. It is recommended to disable `flixel.FlxG.autoPause` or its equivalent to prevent the game from pausing when using the modifier.

- It has been implemented so that when the target is not `desktop`, the library will do nothing, thereby avoiding issues when the build runs on a phone or a console.

- It has been implemented so that when `WindowModManager` starts, it checks whether the window is in full-screen mode; if it is, it automatically disables it before starting. You can use `WM_DISABLE_EXIT_FULLSCREEN_ON_START` to prevent this, but this could cause issues since the library will no longer check whether the window is still in full-screen mode.

- Fixed some typos on the README.