package windowmodcharting.backend.window;

/**
 * A class containing functions that can be used to modify the window
 */
@:access(windowmodcharting.WindowModManager)
class WindowFuncs
{
	/**
	 * Moves the window to the specified location
	 * On Linux, the window will be clamped to the screen size
	 * On other platforms, the window will be moved to the specified location
	 * 
	 * @returns The amount of the window that was cut off by the edges of the screen
	 */
	public static function moveWindow(targetX:Null<Int> = 0, targetY:Null<Int> = 0, ?baseW:Int, ?baseH:Int):
		{
			cutLeft:Int,
			cutTop:Int,
			cutRight:Int,
			cutBottom:Int
		}
	{
		final window = Application.current.window;
		final zero = {
			cutLeft: 0,
			cutTop: 0,
			cutRight: 0,
			cutBottom: 0
		};

		#if (!desktop)
		return zero;
		#end

		if (targetX == null)
			targetX = window.x;
		if (targetY == null)
			targetY = window.y;

		#if linux
		try
		{
			final bounds = window.display.bounds;
			final screenW = bounds.width;
			final screenH = bounds.height;
			final refW = baseW != null ? baseW : window.width;
			final refH = baseH != null ? baseH : window.height;

			final clampedX = Std.int(Math.max(0, targetX));
			final clampedY = Std.int(Math.max(0, targetY));
			final cutLeft = clampedX - targetX;
			final cutTop = clampedY - targetY;
			final cutRight = Std.int(Math.max(0, (targetX + refW) - screenW));
			final cutBottom = Std.int(Math.max(0, (targetY + refH) - screenH));

			if (window.x != clampedX || window.y != clampedY)
			{
				window.x = clampedX;
				window.y = clampedY;
			}

			return {
				cutLeft: cutLeft,
				cutTop: cutTop,
				cutRight: cutRight,
				cutBottom: cutBottom
			};
		}
		catch (e)
		{
			WindowModManager.log('moveWindow: could not get display bounds, falling back. Error: $e', ERROR);
			window.x = targetX;
			window.y = targetY;
			return zero;
		}
		#else
		if (window.x != targetX || window.y != targetY)
		{
			window.x = targetX;
			window.y = targetY;
		}
		return zero;
		#end
	}

	public static function setWindowVisible(show:Null<Bool>):Void
	{
		#if (desktop)
		if (show == null) return;
		Application.current.window.visible = show;
		#end
	}

	/**
	 * Sets the title of the window, only for internal use on Windows
	 * @param windowTitle 
	 */
	public static function defineWindowTitle(windowTitle:String):Void
	{
		#if (windows && desktop)
		WindowNative.defineWindowTitle(windowTitle);
		#end
	}

	public static function setWindowOpacity(opacity:Null<Float>):Void
	{
		if (opacity == null || opacity < 0.0 || opacity > 1.0)
			return;

		#if (desktop)
		Application.current.window.opacity = opacity;
		#end
	}

	public static function getWindowAlpha():Float
	{
		return Application.current.window.opacity;
	}

	public static function focusWindow():Void
	{
		Application.current.window.focus();
	}
}