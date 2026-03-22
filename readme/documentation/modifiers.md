# List of modifiers

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

## Beat

- `BeatX`
- `BeatY`

## Drunk

- `DrunkX`
- `DrunkY`

## Visible

- `Visible`
    > when using the `Visible` modifier of the value is set to 0 or less than 1, the window will become invisible and lose focus (plus, the icon will disappear from the operating system's taskbar, which is cool); setting it to 1 will make the window visible again and attempt to regain focus automatically by calling `lime.app.Application.current.window.focus()`. It is recommended to disable `flixel.FlxG.autoPause` or its equivalent to prevent the game from pausing when using the modifier.