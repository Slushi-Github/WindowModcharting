package windowmodcharting.modifiers.modifiers;

class WinModBaseBounce extends WindowModifierBase
{
	override private function initDefaults():Void
	{
		setSubValue("speed", 1.0);
		setSubValue("useAlt", 0.0);
	}
}

class WindowModifier_BounceX extends WinModBaseBounce
{
	public function new()
	{
		super("bounceX");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.x += Math_Bounce.getMath(value, beat, subValues);
	}
}

class WindowModifier_BounceY extends WinModBaseBounce
{
	public function new()
	{
		super("bounceY");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.y += Math_Bounce.getMath(value, beat, subValues);
	}
}

class WindowModifier_BounceZ extends WinModBaseBounce
{
	public function new()
	{
		super("bounceZ");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.z += Math_Bounce.getMath(value, beat, subValues);
	}
}

class WindowModifier_BounceScale extends WinModBaseBounce
{
	public function new()
	{
		super("bounceScale");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleX += Math_Bounce.getMath(value, beat, subValues);
		result.scaleY += Math_Bounce.getMath(value, beat, subValues);	
	}
}

class WindowModifier_BounceScaleX extends WinModBaseBounce
{
	public function new()
	{
		super("bounceScaleX");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleX += Math_Bounce.getMath(value, beat, subValues);
	}
}

class WindowModifier_BounceScaleY extends WinModBaseBounce
{
	public function new()
	{
		super("bounceScaleY");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleY += Math_Bounce.getMath(value, beat, subValues);
	}
}

