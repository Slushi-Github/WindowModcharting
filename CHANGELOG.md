# CHANGELOG

## v0.2.2

- Added the optional `options` parameter (`WinTweenOptions`) to `easeMod()` and
  `easeModSubValue()`, allowing you to hook into the tween lifecycle via `onStart`,
  `onUpdate` and `onComplete` callbacks, similar to HaxeFlixel FlxTween's `TweenOptions`. All
  callbacks receive the `WindowModifierTween` instance as their only argument.
  This parameter is optional and omitting it preserves the previous behavior.

- added many new modifiers, check the [modifiers list](./docs/documentation/modifiers.md) for more information.

- Added Conductor native implementation for [Plus Engine](https://github.com/Psych-Plus-Team/FNF-PlusEngine).

## v0.2.0

- Added `registerCustomModFactory()` to register custom modifiers by passing a factory
  function (`Void->WindowModifierBase`) instead of an inline callback, useful for
  complex modifiers organized as their own class.

- `WindowModManager` now tracks and restores the maximized state of the window
  on start, pause, resume and destroy.

- Added `WM_DISABLE_SET_NOT_MAXIMIZED_ON_START` define to prevent the manager from
  un-maximizing the window on start.

- Added `WM_DISABLE_SET_NOT_RESIZABLE_ON_START` define (renamed from
  `WM_DISABLE_RESIZABLE_ON_START`).

- Added `WM_DISABLE_SET_RESIZABLE_ON_DESTROY`, `WM_DISABLE_SET_FULLSCREEN_ON_DESTROY`
  and `WM_DISABLE_SET_MAXIMIZED_ON_DESTROY` defines to control which window properties
  are restored when `WindowModManager` is destroyed.

- Renamed define `WM_DONT_RESIZE_ON_END` to `WM_DONT_RESIZE_ON_DESTROY` for consistency.

- `prepareMod()` and `registerCustomMod()` now validate their parameters and log
  an error if they are null or empty, and warn if the tag or name is already registered.

## v0.1.5

- Added support for custom modifiers without editing the library.

- The `WindowModManager` now checks at the start if the window is in full-screen mode and disables it if it is, same with if it is resizable.

- Added `WM_DISABLE_RESIZABLE_ON_START` define to disable the window's ability to be resized at the start of `WindowModManager`.

- Added `WM_NO_INFO_LOGS`, `WM_NO_WARN_LOGS` to disable specific log types.

## v0.1.2 (Hotfix)

- Removed functions on C++ to change the visibility of the window on Windows, they are now handled by Lime directly.

## v0.1.2

- Added `Alpha` modifier for the window, now you can change the alpha of the window using directly `lime.app.Application.current.window.opacity`, allowing work on Linux and Windows at the same time. The C++ code related to those functions has been removed.

- Added `Visible` modifier for the window, now you can change the visibility of the window using directly `lime.app.Application.current.window.visible`, when using the `Visible` modifier of the value is set to 0 or less than 1, the window will become invisible and lose focus (plus, the icon will disappear from the operating system's taskbar, which is cool); setting it to 1 will make the window visible again and attempt to regain focus automatically by calling `lime.app.Application.current.window.focus()`. It is recommended to disable `flixel.FlxG.autoPause` or its equivalent to prevent the game from pausing when using the modifier.

- It has been implemented so that when the target is not `desktop`, the library will do nothing, thereby avoiding issues when the build runs on a phone or a console.

- It has been implemented so that when `WindowModManager` starts, it checks whether the window is in full-screen mode; if it is, it automatically disables it before starting. You can use `WM_DISABLE_EXIT_FULLSCREEN_ON_START` to prevent this, but this could cause issues since the library will no longer check whether the window is still in full-screen mode.

- Fixed some typos on the README.