package windowmodcharting.modifiers.modifiers;

@:keep
class WindowModifier_DrunkX extends WindowModifierBase
{
	public function new()
	{
		super("drunkX");
	}

	override private function initDefaults():Void
	{
		subValues.set("speed", 1.0);
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.x = Math_Drunk.getMath(value, beat, subValues);
	}
}

@:keep
class WindowModifier_DrunkY extends WindowModifierBase
{
	public function new()
	{
		super("drunkY");
	}

	override private function initDefaults():Void
	{
		subValues.set("speed", 1.0);
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.y = Math_Drunk.getMath(value, beat, subValues);
	}
}