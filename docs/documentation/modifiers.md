# List of modifiers

> [!WARNING]
> Using Z or Scale modifiers is not recommended since it will lag the game! 

## Movement

- `MoveX`
- `MoveY`
- `MoveZ`

## Scale

- `ScaleX`
- `ScaleY`
- `Scale`

## Alpha

- `Alpha`

## Visible

- `Visible`
    > when using the `Visible` modifier of the value is set to 0 or less than 1, the window will become invisible and lose focus (plus, the icon will disappear from the operating system's taskbar, which is cool); setting it to 1 will make the window visible again and attempt to regain focus automatically by calling `lime.app.Application.current.window.focus()`. It is recommended to disable `flixel.FlxG.autoPause` or its equivalent to prevent the game from pausing when using the modifier.

## Beat

- `BeatX`
- `BeatY`
- `BeatZ`
- `BeatScale`
- `BeatScaleX`
- `BeatScaleY`

### Beat sub values:

* `speed` - Default: 1
* `mult` - Default: 1
* `offset` - Default: 0
* `alternate` - Default: 1
* `fAccelTime` - Default: 0.2
* `fTotalTime` - Default: 0.5

## Bounce

- `BounceX`
- `BounceY`
- `BounceZ`
- `BounceScale`
- `BounceScaleX`
- `BounceScaleY`

- `TanBounceX`
- `TanBounceY`
- `TanBounceZ`
- `TanBounceScale`
- `TanBounceScaleX`
- `TanBounceScaleY`

### Bounce sub values:

* `speed` - Default: 1
* `useAlt` - Default: 0

## Drunk

- `DrunkX`
- `DrunkY`
- `DrunkZ`
- `DrunkScale`
- `DrunkScaleX`
- `DrunkScaleY`

- `TanDrunkX`
- `TanDrunkY`
- `TanDrunkZ`
- `TanDrunkScale`
- `TanDrunkScaleX`
- `TanDrunkScaleY`

### Drunk sub values:

* `speed` - Default: 1
* `size` - Default: 1
* `desync` - Default: 1
* `offset` - Default: 1
* `useAlt` - Default: 0
* `timertype` - Default: 0

## Sine

- `SineX`
- `SineY`
- `SineZ`
- `SineScale`
- `SineScaleX`
- `SineScaleY`

### Sine sub values:

* `speed` - Default: 1

## Tornado

- `TornadoX`
- `TornadoY`
- `TornadoZ`
- `TornadoScale`
- `TornadoScaleX`
- `TornadoScaleY`

- `TanTornadoX`
- `TanTornadoY`
- `TanTornadoZ`
- `TanTornadoScale`
- `TanTornadoScaleX`
- `TanTornadoScaleY`

### Tornado sub values:

* `speed` - Default: 1
* `offset` - Default: 0

## Shake

- `Shake`