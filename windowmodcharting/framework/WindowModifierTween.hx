package windowmodcharting.framework;

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

	public function new(mod:WindowModifierBase, propertyName:String, startValue:Float, endValue:Float, duration:Float, startBeat:Float, ease:Float->Float)
	{
		this.mod = mod;
		this.propertyName = propertyName;
		this.startValue = startValue;
		this.endValue = endValue;
		this.duration = duration;
		this.startBeat = startBeat;
		this.ease = ease;
	}

	public function update(currentBeat:Float):Void
	{
		if (!active || finished)
			return;

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
	}
}