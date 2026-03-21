package windowmodcharting.modifiers.modifiers;

@:keep
class WindowModifier_MoveX extends WindowModifierBase
{
	public function new()
	{
		super("moveX");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.x = value;
	}
}

@:keep
class WindowModifier_MoveY extends WindowModifierBase
{
	public function new()
	{
		super("moveY");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.y = value;
	}
}

@:keep
class WindowModifier_MoveZ extends WindowModifierBase
{
	public function new()
	{
		super("moveZ");
	}

	override private function initDefaults():Void
	{
		subValues.set("strength", 0.05);
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		var s = 1.0 - value * getSubValue("strength");
		s = s <= 0 ? 0.001 : s;
		result.scaleX *= s;
		result.scaleY *= s;
		result.z = value;
	}
}