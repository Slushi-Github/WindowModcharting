package windowmodcharting.modifiers.modifiers;

@:keep
class WindowModifier_BeatX extends WindowModifierBase
{
	public function new()
	{
		super("beatX");
	}

	override private function initDefaults():Void
	{
		subValues.set("accelTime", 0.2);
		subValues.set("totalTime", 0.5);
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.x += value * Math_Beat.getMath(beat, getSubValue("accelTime"), getSubValue("totalTime"));
	}
}

@:keep
class WindowModifier_BeatY extends WindowModifierBase
{
	public function new()
	{
		super("beatY");
	}

	override private function initDefaults():Void
	{
		subValues.set("accelTime", 0.2);
		subValues.set("totalTime", 0.5);
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.y += value * Math_Beat.getMath(beat, getSubValue("accelTime"), getSubValue("totalTime"));
	}
}