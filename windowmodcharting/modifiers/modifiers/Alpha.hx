package windowmodcharting.modifiers.modifiers;

class WindowModifier_Alpha extends WindowModifierBase
{
	public function new()
	{
		super("alpha");
        value = 1.0;
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
        result.alpha *= value;
	}
}