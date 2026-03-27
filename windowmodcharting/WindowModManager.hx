package windowmodcharting;

@:noCompletion
enum WMLogLevel
{
	INFO;
	WARNING;
	ERROR;
	DEBUG;
}

/**
 * Data structure for prepared mods
 */
typedef WinPreparedMod =
{
	tag:String,
	modifierName:String,
	instance:WindowModifierBase
}

/**
 * Data structure for scheduled events
 */
typedef WinScheduledEvent =
{
	beat:Float,
	callback:Void->Void,
	executed:Bool
}

/**
 * Base of WindowModcharting, manages window mods and tweens,
 * also manages the game window. There is only one instance of this class.
 */
@:access(ConductorImplementation)
class WindowModManager extends FlxBasic
{
	private var preparedMods:Map<String, WinPreparedMod>;
	private var customMods:Map<String, ()->WindowModifierCallback>;
	private var customModsFactories:Map<String, Void->WindowModifierBase>;
	private var activeTweens:Array<WindowModifierTween>;
	private var scheduledEvents:Array<WinScheduledEvent>;

	private var baseX:Int = 0;
	private var baseY:Int = 0;
	private var baseAlpha:Float = 1.0;
	private var baseWidth:Int = 0;
	private var baseHeight:Int = 0;

	private var baseResizable:Bool = false;
	private var baseFullscreen:Bool = false;
	private var baseMaximized:Bool = false;

	#if !WM_DONT_CHANGE_FLX_SCALE_MODE
	private var previousFlxScaleMode:BaseScaleMode = null;
	#end

	private var lastX:Int = 0;
	private var lastY:Int = 0;
	private var lastAlpha:Float = 1.0;
	private var lastScaleX:Float = 1.0;
	private var lastScaleY:Float = 1.0;

	private var lastCutLeft:Int = 0;
	private var lastCutTop:Int = 0;
	private var lastCutRight:Int = 0;
	private var lastCutBottom:Int = 0;

	private var paused:Bool = false;

	/**
	 * Creates a new instance of WindowModManager and starts it
	 */
	public function new()
	{
		super();

		preparedMods = new Map();
		customMods = new Map();
		customModsFactories = new Map();
		activeTweens = [];
		scheduledEvents = [];

		#if (!desktop)
		return;
		#end

		final win = Application.current.window;

		#if (desktop && !WM_DONT_RESIZE_ON_START)
		WindowFuncs.resizeGame(win.width, win.height, true, 1);
		#end

		baseX = win.x;
		baseY = win.y;
		baseWidth = win.width;
		baseHeight = win.height;
		baseAlpha = win.opacity;

		baseResizable = win.resizable;
		baseFullscreen = win.fullscreen;
		baseMaximized = win.maximized;

		#if desktop
		#if !WM_DISABLE_EXIT_FULLSCREEN_ON_START
		if (win.fullscreen)
			win.fullscreen = false;
		#end

		#if !WM_DISABLE_SET_NOT_RESIZABLE_ON_START
		if (win.resizable)
			win.resizable = false;
		#end

		#if !WM_DISABLE_SET_NOT_MAXIMIZED_ON_START
		if (win.maximized)
			win.maximized = false;
		#end
		#end

		lastX = baseX;
		lastY = baseY;

		#if !WM_DONT_CHANGE_FLX_SCALE_MODE
		previousFlxScaleMode = FlxG.scaleMode;
		FlxG.scaleMode = new WindowDanceScaleMode(baseWidth, baseHeight);
		#end

		log("WindowModManager initialized!", INFO);
	}

	// Public API ////////////////////////////////////////

	/**
	 * Registers a custom modifier factory so it can later be
	 * instantiated by name via prepareMod().
	 *
	 * @param name        The modifier name to use in prepareMod()
	 * @param applyFunc   The function that applies the modifier logic.
	 *                    Receives (result, beat, modInstance).
	 * @param defaultSubs Optional map of default sub-values (e.g. ["speed" => 1.0])
	 */
	public function registerCustomMod(
		name:String,
		applyFunc:(result:WindowModResult, beat:Float, mod:WindowModifierBase)->Void,
		?defaultSubs:Map<String, Float>
	):Void
	{
		#if !desktop
		return;
		#end

		if (name == null || name == "" || applyFunc == null) {
			log('Invalid parameters for registerCustomMod()', ERROR);
			return;
		}
		else if (customMods.exists(name)) {
			log('Custom mod "$name" already registered', WARNING);
			return;
		}

		customMods.set(name, function() {
			final instance = new WindowModifierCallback(name, applyFunc);
			if (defaultSubs != null)
				for (k => v in defaultSubs)
					instance.setSubValue(k, v);
			return instance;
		});
		log('Custom mod "$name" registered', DEBUG);
	}

	/**
	 * Registers a custom modifier factory so it can later be
	 * instantiated by name via prepareMod().
	 * 
	 * ```haxe
	 * registerCustomModFactory("MyMod", () -> new MyMod());
	 * ```
	 *
	 * @param name        The modifier name to use in prepareMod()
	 * @param modFactory  The function that creates the modifier instance
	 */
	public function registerCustomModFactory(name:String, modFactory:Void->WindowModifierBase):Void
	{
		#if !desktop
		return;
		#end

		if (name == null || name == "" || modFactory == null) {
			log('Invalid parameters for registerCustomModFactory()', ERROR);
			return;
		}
		else if (customModsFactories.exists(name)) {
			log('Custom mod factory "$name" already registered', WARNING);
			return;
		}

		customModsFactories.set(name, modFactory);
		log('Custom mod class "$name" registered', DEBUG);
	}

	/**
	 * Prepares a modifier for later use.
	 * 
	 * ```haxe
	 * prepareMod("myModTag", "MyMod");
	 * ```
	 * 
	 * @param tag         The tag to use for the prepared modifier
	 * @param modifier    The name of the modifier to prepare
	 */
	public function prepareMod(tag:String, modifier:String):Void
	{
		#if !desktop
		return;
		#end

		if (tag == null || tag == "" || modifier == "") {
			log('Invalid parameters for prepareMod()', ERROR);
			return;
		}
		else if (preparedMods.exists(tag)) {
			log('Mod "$tag" already prepared', WARNING);
			return;
		}

		// Check for custom modifiers
		if (customMods.exists(modifier))
		{
			final instance = customMods.get(modifier)();
			if (instance == null)
				return;
			preparedMods.set(tag, {tag: tag, modifierName: modifier, instance: instance});
			log('Custom mod "$modifier" prepared as "$tag"', DEBUG);
			return;
		}

		if (customModsFactories.exists(modifier))
		{
			final instance = customModsFactories.get(modifier)();
			if (instance == null)
				return;
			preparedMods.set(tag, {tag: tag, modifierName: modifier, instance: instance});
			log('Custom mod factory "$modifier" prepared as "$tag"', DEBUG);
			return;
		}

		// Check for built-in modifiers
		final modClass = resolveClass(modifier);
		if (modClass == null)
		{
			log('WindowMod "$modifier" not found.. It couldn\'t be found either if it\'s a custom modifier', ERROR);
			return;
		}
		preparedMods.set(tag, {tag: tag, modifierName: modifier, instance: Type.createInstance(modClass, [])});
		log('WindowMod "$modifier" prepared as "$tag"', DEBUG);
	}

	/**
	 * Sets the value of a prepared mod at a specific beat
	 * 
	 * ```haxe
	 * setMod(1.0, {myModTag: 1.0});
	 * ```
	 * 
	 * @param beat The beat to set to
	 * @param props The mods with values to set
	 */
	public function setMod(beat:Float, props:Dynamic):Void
	{
		#if !desktop
		return;
		#end

		if (props == null)
			return;

		scheduleEvent(beat, function()
		{
			for (field in Reflect.fields(props))
			{
				if (!preparedMods.exists(field))
					continue;
				final mod = preparedMods.get(field).instance;
				mod.value = Reflect.field(props, field);
				mod.markDirty();
			}
		});
		log('Added set for [' + Reflect.fields(props).join(", ") + '] at beat $beat', DEBUG);
	}

	/**
	 * Eases the value of a prepared mod at a specific beat
	 * 
	 * ```haxe
	 * easeMod(1.0, 3.0, ease.linear, {myModTag: 1.0});
	 * ```
	 * 
	 * @param beat The beat to ease to
	 * @param duration The duration of the ease in beats
	 * @param easeFunc The ease function
	 * @param props The mods with values to ease
	 */
	public function easeMod(beat:Float, duration:Null<Float>, easeFunc:Float->Float, props:Dynamic, ?options:WinTweenOptions):Void
	{
		#if !desktop
		return;
		#end

		if (duration == null || duration < 0 || easeFunc == null || props == null)
			return;

		scheduleEvent(beat, function()
		{
			for (field in Reflect.fields(props))
			{
				if (!preparedMods.exists(field))
					continue;
				final mod = preparedMods.get(field).instance;
				activeTweens.push(new WindowModifierTween(mod, "value", mod.value, Reflect.field(props, field), duration, beat, easeFunc, options));
			}
		});
		log('Added ease for [' + Reflect.fields(props).join(", ") + '] at beat $beat.', DEBUG);
	}

	/**
	 * Sets the sub value of a prepared mod at a specific beat
	 * 
	 * ```haxe
	 * setModSubValue("myModTag", 1.0, {speed: 1.0});
	 * ```
	 * @param tag The tag of the prepared mod
	 * @param beat The beat to set to
	 * @param props The sub values with values to set
	 */
	public function setModSubValue(tag:String, beat:Float, props:Dynamic):Void
	{
		#if !desktop
		return;
		#end

		if (tag == null || tag == "" || props == null)
			return;

		scheduleEvent(beat, function()
		{
			if (!preparedMods.exists(tag))
				return;
			final mod = preparedMods.get(tag).instance;
			for (field in Reflect.fields(props))
				mod.setSubValue(field, Reflect.field(props, field));
			mod.markDirty();
		});
		log('Added sub value for [' + Reflect.fields(props).join(", ") + '] at beat $beat.', DEBUG);
	}

	/**
	 * Eases the sub value of a prepared mod at a specific beat
	 * 
	 * ```haxe
	 * easeModSubValue("myModTag", 1.0, 3.0, ease.linear, {speed: 1.0});
	 * ```
	 * 
	 * @param tag The tag of the prepared mod
	 * @param beat The beat to ease to
	 * @param duration The duration of the ease in beats
	 * @param easeFunc The ease function
	 * @param props The sub values with values to ease
	 */
	public function easeModSubValue(tag:String, beat:Float, duration:Null<Float>, easeFunc:Float->Float, props:Dynamic, ?options:WinTweenOptions):Void
	{
		#if !desktop
		return;
		#end

		if (tag == null || tag == "" || duration == null || duration < 0 || easeFunc == null || props == null)
			return;

		scheduleEvent(beat, function()
		{
			if (!preparedMods.exists(tag))
				return;
			final mod = preparedMods.get(tag).instance;
			for (field in Reflect.fields(props))
				activeTweens.push(new WindowModifierTween(mod, field, mod.getSubValue(field), Reflect.field(props, field), duration, beat, easeFunc, options));
			log('Added ease for sub value for [' + Reflect.fields(props).join(", ") + '] at beat $beat.', DEBUG);
		});
	}

	/**
	 * Remove a prepared mod
	 * @param tag The tag of the prepared mod
	 */
	public function removeMod(tag:String):Void
	{
		preparedMods.remove(tag);
	}

	/**
	 * Call this when the game is paused.
	 * Restores the window to its default state (size, position, scale mode)
	 * without losing the current modchart state.
	 */
	public function pauseWindow():Void
	{
		#if !desktop
		return;
		#end

		if (paused)
			return;
		paused = true;

		final win = Application.current.window;
		win.x = baseX;
		win.y = baseY;
		win.opacity = baseAlpha;
		win.resizable = baseResizable;
		win.fullscreen = baseFullscreen;
		win.maximized = baseMaximized;
		win.resize(baseWidth, baseHeight);

		#if (linux && openfl && !WM_DISBALE_GL_SCISSOR)
		WindowNativeGL.clearScissor();
		#end

		#if !WM_DONT_CHANGE_FLX_SCALE_MODE
		if (previousFlxScaleMode != null)
			FlxG.scaleMode = previousFlxScaleMode;
		#end

		log("Window paused, restored to default state", DEBUG);
	}

	/**
	 * Call this when the game is resumed from pause.
	 * Restores the window dance scale mode so modchart resumes normally.
	 */
	public function resumeWindow():Void
	{
		#if (!desktop)
		return;
		#end

		if (!paused)
			return;
		paused = false;

		// Force all last* values dirty so applyToWindow
		// resizes and repositions correctly on the next frame
		lastCutLeft = -1;
		lastCutTop = -1;
		lastCutRight = -1;
		lastCutBottom = -1;
		lastScaleX = -1;
		lastScaleY = -1;
		lastAlpha = -1;

		final win = Application.current.window;
		win.resizable = false;
		win.fullscreen = false;
		win.maximized = false;

		#if !WM_DONT_CHANGE_FLX_SCALE_MODE
		FlxG.scaleMode = new WindowDanceScaleMode(baseWidth, baseHeight);
		#end

		log("Window resumed, modchart scale mode restored", DEBUG);
	}

	//////////////////////////////////////////////////////

	private function getCurrentBeat():Float
	{
		@:privateAccess
		return ConductorImplementation.songPosition / ConductorImplementation.crochet;
	}

	override public function update(elapsed:Float):Void
	{
		#if (!desktop)
		return;
		#end

		super.update(elapsed);

		if (!active || paused)
			return;

		WindowFuncs.defineWindowTitle(Application.current.window.title);

		final beat = getCurrentBeat();

		var i = 0;
		while (i < scheduledEvents.length)
		{
			var ev = scheduledEvents[i];
			if (ev == null || ev.executed)
			{
				scheduledEvents.splice(i, 1);
				continue;
			}
			if (ev != null && beat >= ev.beat)
			{
				ev.callback();
				ev.executed = true;
				scheduledEvents.splice(i, 1);
				continue;
			}
			break;
		}

		for (tween in activeTweens)
			if (tween != null && tween.active)
				tween.update(beat);

		activeTweens = activeTweens.filter(t -> !t.finished);

		applyToWindow(beat);
	}

	private function applyToWindow(beat:Float):Void
	{
		#if !desktop
		return;
		#end

		var combined:WindowModResult = {
			x: 0,
			y: 0,
			alpha: 1,
			scaleX: 1,
			scaleY: 1,
			z: 0
		};

		for (tag in preparedMods.keys())
		{
			final r = preparedMods.get(tag).instance.calculate(beat);
			combined.x += r.x;
			combined.y += r.y;
			combined.alpha *= r.alpha;
			combined.scaleX *= r.scaleX;
			combined.scaleY *= r.scaleY;
			combined.z += r.z;
		}

		final win = Application.current.window;

		if (lastAlpha != combined.alpha)
			WindowFuncs.setWindowOpacity(combined.alpha);
		lastAlpha = combined.alpha;

		final targetW = Std.int(baseWidth * combined.scaleX);
		final targetH = Std.int(baseHeight * combined.scaleY);

		final centerOffsetX = Std.int((baseWidth - targetW) / 2);
		final centerOffsetY = Std.int((baseHeight - targetH) / 2);

		final targetX = baseX + Std.int(combined.x) + centerOffsetX;
		final targetY = baseY + Std.int(combined.y) + centerOffsetY;

		final cut = WindowFuncs.moveWindow(targetX, targetY, targetW, targetH);
		lastX = targetX;
		lastY = targetY;

		final visibleW = targetW - cut.cutLeft - cut.cutRight;
		final visibleH = targetH - cut.cutTop - cut.cutBottom;

		#if linux
		#if (openfl && !WM_DISBALE_GL_SCISSOR)
		if (visibleW > 0 && visibleH > 0)
			WindowNativeGL.scissor(cut.cutLeft, cut.cutTop, visibleW, visibleH, targetH);
		else
			WindowNativeGL.clearScissor();
		#end

		final xChanged = cut.cutLeft != lastCutLeft || cut.cutRight != lastCutRight;
		final yChanged = Math.abs(cut.cutTop - lastCutTop) > 2 || Math.abs(cut.cutBottom - lastCutBottom) > 2;
		final scaleChanged = combined.scaleX != lastScaleX || combined.scaleY != lastScaleY;

		if ((xChanged || yChanged || scaleChanged) && visibleW > 0 && visibleH > 0)
		{
			win.resize(visibleW, visibleH);
			lastCutLeft = cut.cutLeft;
			lastCutTop = cut.cutTop;
			lastCutRight = cut.cutRight;
			lastCutBottom = cut.cutBottom;
			lastScaleX = combined.scaleX;
			lastScaleY = combined.scaleY;
		}
		#else
		if (visibleW > 0 && visibleH > 0 && (win.width != visibleW || win.height != visibleH))
		{
			win.resize(visibleW, visibleH);
			lastScaleX = combined.scaleX;
			lastScaleY = combined.scaleY;
		}
		#end
	}

	/**
	 * Get a class by name, used to resolve mods
	 * @param name The name of the class
	 * @return Class<WindowModifierBase>
	 */
	private function resolveClass(name:String):Class<WindowModifierBase>
	{
		var c = Type.resolveClass(Constants.MODIFIER_CLASS_PATH + Constants.MODIFIER_CLASS_PREFIX + name);
		if (c == null)
			c = Type.resolveClass(Constants.MODIFIER_CLASS_PATH + name);
		return cast c;
	}

	private function scheduleEvent(beat:Float, cb:Void->Void):Void
	{
		#if !desktop
		return;
		#end

		scheduledEvents.push({beat: beat, callback: cb, executed: false});
		scheduledEvents.sort((a, b) -> a.beat < b.beat ? -1 : a.beat > b.beat ? 1 : 0);
	}

	public function clearScheduled():Void
	{
		scheduledEvents = [];
	}

	public function clear():Void
	{
		preparedMods.clear();
		customMods.clear();
		customModsFactories.clear();
		activeTweens = [];
		scheduledEvents = [];
	}

	override public function destroy():Void
	{
		clear();
		super.destroy();

		final win = Application.current.window;

		#if (desktop)
		#if !WM_DONT_RESIZE_ON_DESTROY
		win.resize(baseWidth, baseHeight);
		#end

		win.x = baseX;
		win.y = baseY;
		win.opacity = baseAlpha;

		#if !WM_DISABLE_SET_RESIZABLE_ON_DESTROY
		win.resizable = baseResizable;
		#end

		#if !WM_DISABLE_SET_FULLSCREEN_ON_DESTROY
		win.fullscreen = baseFullscreen;
		#end

		#if !WM_DISABLE_SET_MAXIMIZED_ON_DESTROY
		win.maximized = baseMaximized;
		#end
		#end

		#if (linux && desktop && openfl && !WM_DISBALE_GL_SCISSOR)
		WindowNativeGL.clearScissor();
		#end

		#if !WM_DONT_CHANGE_FLX_SCALE_MODE
		if (previousFlxScaleMode != null)
			FlxG.scaleMode = previousFlxScaleMode;
		#end
	}

	private static function log(msg:Dynamic, type:WMLogLevel = WMLogLevel.INFO, ?pos:PosInfos):Void
	{
		#if WM_NO_LOGS
		return;
		#end

		#if WM_NO_INFO_LOGS
		if (type == WMLogLevel.INFO)
			return;
		#end

		#if WM_NO_WARNING_LOGS
		if (type == WMLogLevel.WARNING)
			return;
		#end

		#if (!debug || !WM_FORCE_DEBUG)
		if (type == WMLogLevel.DEBUG)
			return;
		#end

		final finalLogLevel:String = switch (type)
		{
			case INFO: "\x1b[38;5;7m" + Std.string(type) + "\x1b[0m";
			case WARNING: "\x1b[38;5;3m" + Std.string(type) + "\x1b[0m";
			case ERROR: "\x1b[38;5;1m" + Std.string(type) + "\x1b[0m";
			case DEBUG: "\x1b[38;5;5m" + Std.string(type) + "\x1b[0m";
		}

		Sys.println("[" + finalLogLevel + " | " + pos.className + "/" + pos.methodName + ":" + pos.lineNumber + "] " + Std.string(msg));
	}
}