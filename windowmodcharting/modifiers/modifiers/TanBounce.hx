package windowmodcharting.modifiers.modifiers;

class WinModBaseTanBounce extends WindowModifierBase
{
	override private function initDefaults():Void
	{
		setSubValue("speed", 1.0);
		setSubValue("useAlt", 0.0);
	}
}

class WindowModifier_TanBounceX extends WinModBaseTanBounce
{
	public function new()
	{
		super("tanBounceX");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.x += Math_TanBounce.getMath(value, beat, subValues);
	}
}

class WindowModifier_TanBounceY extends WinModBaseTanBounce
{
	public function new()
	{
		super("tanBounceY");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.y += Math_TanBounce.getMath(value, beat, subValues);
	}
}

class WindowModifier_TanBounceZ extends WinModBaseTanBounce
{
	public function new()
	{
		super("tanBounceZ");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.z += Math_TanBounce.getMath(value, beat, subValues);
	}
}

class WindowModifier_TanBounceScale extends WinModBaseTanBounce
{
	public function new()
	{
		super("tanBounceScale");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleX += Math_TanBounce.getMath(value, beat, subValues);
		result.scaleY += Math_TanBounce.getMath(value, beat, subValues);	
	}
}

class WindowModifier_TanBounceScaleX extends WinModBaseTanBounce
{
	public function new()
	{
		super("tanBounceScaleX");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleX += Math_TanBounce.getMath(value, beat, subValues);
	}
}

class WindowModifier_TanBounceScaleY extends WinModBaseTanBounce
{
	public function new()
	{
		super("tanBounceScaleY");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleY += Math_TanBounce.getMath(value, beat, subValues);
	}
}

