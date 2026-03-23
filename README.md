<div align="center">
  <!-- <img src="readme/logo.png" alt="WindowModcharting Logo" width="300"> -->
  <h1>WindowModcharting</h1>
  <h2 align="center"><em><strong>"What if the window could have modcharts too?"</strong></em></h2>
</div>

**WindowModcharting** is a framework for creating modcharts via events for the game window, inspired by [**Modcharting Tools**](https://github.com/EdwhakKB/FNF-Modcharting-Tools).

> [!IMPORTANT]
> This library is still in development and is in beta, so there may be some bugs, instability and many changes constantly!

This library makes the following easy:

- Quickly modifying the position and scale of the window.
- An event system based on the game music's beats.
- Making animations and transitions between events.

All through a simple and easy-to-use API.

Additionally, this library has **experimental support** for Linux! Normally, in desktop environments like GNOME or KDE Plasma, the game window cannot go outside the screen, but with WindowModcharting you can simulate it by bridging Linux and Windows support without breaking effects! (Idea inspired by [*Rhythm Doctor Multi Window Plugin for Linux*](https://github.com/chocolateimage/rd-multiwindow-linux)). With an implementation based directly on OpenGL to tweak the game content without as much lag (You need to be using OpenFL in your project to use it, otherwise see below).

If you were hoping to find things like modifying the color of the window border here, sorry but there is no safe equivalent on Linux so it is not included in WindowModcharting, save yourself the time of asking about that. I prefer cross-platform support between Linux, Windows and even MacOS, so I prefer to go for things that can be done across all 3 systems.

-----

# Installation

This project is made for projects based on Friday Night Funkin' (FNF) engines, but could work in others as long as they use Lime and HaxeFlixel.

Get and install the library (Not alvailable for now, but will be soon):

```bash
haxelib install window-modcharting
```

Or from GitHub:

```bash
haxelib git window-modcharting https://github.com/Slushi-Github/WindowModcharting.git
```

First in your `project.xml` you must define the following:

```xml
<define name="WM_ENGINE" value="YOUR_ENGINE"/>

<define name="WM_ENGINE_VERSION" value="YOUR_ENGINE_VERSION"/>
```

Replacing `YOUR_ENGINE` and `YOUR_ENGINE_VERSION` with the name and version of your engine which you can find [here](readme/documentation/supportedEngines.md).

If you are on Linux, you need to install the following packages:

```bash
sudo apt install libxcb1-dev libx11-xcb-dev
```

Now include the library in your project:

```xml
<haxelib name="window-modcharting"/>
```

Can't find your engine in the list? Or is it not based on FNF? Don't worry, here's the custom implementation:

The only thing that depends on FNF is the `Conductor`. Let's tell WindowModcharting that we will use our own `Conductor`:

First define the following in your `project.xml`:

```xml
<define name="WM_CUSTOM_CONDUCTOR"/>
```

Now you can include the library in your project as shown earlier.

And then in your `Main.hx` preferably put the following:

```haxe
import windowmodcharting.engineImplementation.ConductorImplementation;

ConductorImplementation.custom_songPosition = () -> YOUR_CONDUCTOR.equivalentSongPosition;

ConductorImplementation.custom_crochet = () -> YOUR_CONDUCTOR.equivalentCrochet;
```

In case your `Conductor` or equivalent has those methods inside an instance that hasn't been declared yet in `Main.hx`, you'll need to find where it's convenient for you to declare them for WindowModcharting — as long as it's before creating the `WindowModManager` you won't have any problems.

About `WindowModManager`: this is the base object of WindowModcharting, containing all the methods that let you create modcharts. Let's add it to your PlayState (or also to an HScript if your engine supports it):

```haxe
import windowmodcharting.WindowModManager;

var windowMod:WindowModManager = null;

windowMod = new WindowModManager();
add(windowMod);
```

It doesn't really matter when you create and add the object to your state, but preferably it should be after the notes and receptors have been created (If you have [FunkinModchart](https://github.com/theoo-h/FunkinModchart) or [Modcharting Tools](https://github.com/EdwhakKB/FNF-Modcharting-Tools) implemented, I'd recommend putting the WindowModcharting stuff after you add either of them). Or in general after most of the game setup to avoid issues.

One more thing: since we never pass something like our `PlayState` (or equivalent) to WindowModcharting, we need to manually call some functions where our game pauses and resumes in our state to tell WindowModcharting to restore the window position and scale when paused and update it when resumed:

Wherever the pause function of your PlayState starts, call the following function on `windowMod` (Preferably check first that it's not null!):

```haxe
windowMod.pauseWindow();
```

Now, wherever the resume function of your PlayState starts, call the following function on `windowMod` (Also preferably check first that it's not null!):

```haxe
windowMod.resumeWindow();
```

And that's it, now you can start creating modcharts!

# Usage

After adding the `WindowModManager` to your state, you can create modcharts in the following way, for example from an HScript or further into your PlayState:

### Add a modifier:

```haxe
windowMod.prepareMod("MyTag", "MyModifier");
```

`"MyTag"` is the tag that will be given to the modifier you are creating, and `"MyModifier"` is the class name of the modifier you are creating. All modifiers start with the prefix "WindowModifier_" — including it or not is optional, but it is recommended to only write what comes after the "_".

The list of available modifiers can be found [here](readme/documentation/modifiers.md).

### Add a custom modifier:

You can create your own modifiers without modifying the source code of WindowModcharting!:

```haxe
windowMod.registerCustomMod(
    "bouncy",
    function(result, beat, mod) {
        // Each bounce lasts one beat, offset controllable via subValues
        final offset = mod.getSubValue("offset");
        final t = ((beat + offset) % 1.0); // 0..1 within the beat

        // Squash & stretch: flattens at the bottom, stretches going up
        final squash = Math.sin(t * Math.PI); // 0->1->0
        result.y      =  mod.value * (1 - squash); // drops when squash is 0
        result.scaleY = 1 - (squash * 0.3);         // squashes at the peak
        result.scaleX = 1 + (squash * 0.15);         // widens at the same time
    },
    ["offset" => 0.0]
);
```

The first parameter is the name of the modifier, the second is the function that will be called, and the third is an array of initial sub-values. For initialize and use the modifier use `windowMod.prepareMod` as usual.

### Events:

Set a value:

```haxe
windowMod.setMod(9, {
    MyTag: 4
});
```

The `9` is the beat at which you want to set the value, `MyTag` is the tag of the modifier you want to set the value for, and `4` is the value you want to set. You can add as many modifiers as you want separated by commas.

Set multiple values via transitions:

```haxe
windowMod.easeMod(9, 4, FlxEase.linear, {
    MyTag: 0,
});
```

The `9` is the beat at which the event will occur, `4` is the duration of the transition (in beats!), `FlxEase.linear` is the transition curve, and the rest is the same as `setMod`.

Modify sub-values of a modifier:

Set a value:
```haxe
windowMod.setModSubValue("MyTag", 15, {
    effect1: 0.3
});
```

`"MyTag"` is the tag of the modifier whose sub-value you want to modify, `15` is the beat at which the event will occur, and the rest is the same as the previous methods but you must put the tag of the sub-value you want to modify.

Modify multiple sub-values of a modifier via transitions:
```haxe
windowMod.easeModSubValue("MyTag", 15, 4, FlxEase.linear, {
    effect1: 6
});
```

`"MyTag"` is the tag of the modifier whose sub-value you want to modify, and the rest is the same as `easeMod` but you must put the tag of the sub-value you want to modify.

And that's it, that's how simply you can create modcharts for the game window!

# Advanced defines

There are some defines you can put in your `project.xml` to customize the behavior of WindowModcharting at runtime:

- `WM_DONT_RESIZE_ON_START`: Does not resize the window at the start of `WindowModManager`, useful if for some reason you do something with the window before your state is fully created.

- `WM_DONT_RESIZE_ON_END`: Does not resize the window when destroying `WindowModManager`, useful if for some reason you do something with the window after your state is destroyed.

- `WM_DISABLE_EXIT_FULLSCREEN_ON_START`: Does not disable the window's fullscreen mode at the start of `WindowModManager`, but this could cause issues since WindowModcharting will no longer check whether the window is still in full-screen mode.

- `WM_DISABLE_RESIZABLE_ON_START`: Does not make the window resizable at the start of `WindowModManager`.

- `WM_DONT_CHANGE_FLX_SCALE_MODE`: When `WindowModManager` is created it changes the HaxeFlixel scale mode to a custom one to make the game always have the same scale and size regardless of the game window size. If for some reason you want to disable this, add it to your `project.xml`.

- `WM_FORCE_DEBUG`: Force debug messages to be output to the console even when you are not compiling in debug mode.

- `WM_NO_LOGS`: Disable logging completely, useful if you don't want to see any logs at all.

- `WM_NO_INFO_LOGS`: Disable just info logs completely.

- `WM_NO_WARNING_LOGS`: Disable just warning logs completely.

**Linux only:**

- `WM_DISBALE_GL_SCISSOR`: Disables clipping the game content using OpenGL (Untested). If you are not using OpenFL, this will be treated as if it were already defined.

# Credits

- [Modcharting Tools](https://github.com/EdwhakKB/FNF-Modcharting-Tools): Where I got my inspiration and base for creating WindowModcharting.

- [Rhythm Doctor Multi Window Plugin for Linux](https://github.com/chocolateimage/rd-multiwindow-linux): Inspiration for Linux support to be able to move the game window *"outside"* the screen.

## Special thanks

- [@Nezumieepy](https://github.com/Nezumieepy): Tested the library with X11 on the following Linux desktop environments:
    * KDE Plasma 6.
    * I3wm.
    * LXQT.

    (Thanks so much!) 

# License and more information

This project is released under the [MIT license](./LICENSE.md)

See the [TODO list](./TODO.md) for future features.

See the [CHANGELOG](./CHANGELOG.md) for changes in the past.

This was originally inspired by the modcharts system I use for my game OffBeat ([a VSRG game for Nintendo Switch](https://youtu.be/e2W7iYMqzCg)).

I tried to create this project more than 2 years ago but I didn't understand anything about the style back then. Now I understand it, and now it seems I pulled it off, and all under the excuse of <font color="#5e0051">a̵̢͑͆̚ ̶̲͚͗̎̚F̸̲̓N̴̝̿͌F̵͚̜͉̾̕'̴̫̒̕ ̸̭͒m̷̧̖̒ǫ̸͈̩̽̈́̕d̴͎̫̰̆̂͝</font>...
