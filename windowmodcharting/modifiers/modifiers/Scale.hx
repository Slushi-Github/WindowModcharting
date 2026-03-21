package windowmodcharting.modifiers.modifiers;

@:keep
class WindowModifier_Scale extends WindowModifierBase
{
	public function new()
	{
		super("scale");
		value = 1.0;
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		final s = value <= 0 ? 0.001 : value;
		result.scaleX = s;
		result.scaleY = s;
	}
}

class WindowModifier_ScaleX extends WindowModifierBase
{
	public function new()
	{
		super("scaleX");
		value = 1.0;
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleX = value <= 0 ? 0.001 : value;
	}
}

@:keep
class WindowModifier_ScaleY extends WindowModifierBase
{
	public function new()
	{
		super("scaleY");
		value = 1.0;
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleY = value <= 0 ? 0.001 : value;
	}
}