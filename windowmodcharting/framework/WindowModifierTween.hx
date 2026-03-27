package windowmodcharting.framework;

/**
 * Options object for WindowModifierTween, similar to FlxTween's TweenOptions
 */
typedef WinTweenOptions =
{
	?onStart:WindowModifierTween->Void,
	?onUpdate:WindowModifierTween->Void,
	?onComplete:WindowModifierTween->Void
}

/**
 * Tween for a WindowModifier
 */
class WindowModifierTween
{
	public var mod:WindowModifierBase;
	public var propertyName:String;
	public var startValue:Float;
	public var endValue:Float;
	public var duration:Float;
	public var startBeat:Float;
	public var ease:Float->Float;
	public var active:Bool = true;
	public var finished:Bool = false;

	private var options:WinTweenOptions;
	private var started:Bool = false;

	public function new(mod:WindowModifierBase, propertyName:String, startValue:Float, endValue:Float, duration:Float, startBeat:Float, ease:Float->Float, ?options:WinTweenOptions)
	{
		this.mod = mod;
		this.propertyName = propertyName;
		this.startValue = startValue;
		this.endValue = endValue;
		this.duration = duration;
		this.startBeat = startBeat;
		this.ease = ease;
		this.options = options ?? {};
	}

	public function update(currentBeat:Float):Void
	{
		if (!active || finished)
			return;

		if (!started)
		{
			started = true;
			if (options.onStart != null)
				options.onStart(this);
		}

		var elapsed = currentBeat - startBeat;
		if (elapsed >= duration)
		{
			elapsed = duration;
			finished = true;
		}

		var t = elapsed / duration;
		var current = startValue + (endValue - startValue) * ease(t);

		if (propertyName == "value")
			mod.value = current;
		else
			mod.setSubValue(propertyName, current);

		mod.markDirty();

		if (options.onUpdate != null)
			options.onUpdate(this);

		if (finished && options.onComplete != null)
			options.onComplete(this);
	}
}