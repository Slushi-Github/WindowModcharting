package windowmodcharting.modifiers.modifiers;

class WinModBaseSine extends WindowModifierBase
{
	override private function initDefaults():Void
	{
		setSubValue("speed", 1.0);
	}
}

class WindowModifier_SineX extends WinModBaseSine
{
	public function new()
	{
		super("sineX");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.x += Math_Sine.getMath(value, beat, subValues);
	}
}

class WindowModifier_SineY extends WinModBaseSine
{
	public function new()
	{
		super("sineY");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.y += Math_Sine.getMath(value, beat, subValues);
	}
}

class WindowModifier_SineZ extends WinModBaseSine
{
	public function new()
	{
		super("sineZ");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.z += Math_Sine.getMath(value, beat, subValues);
	}
}

class WindowModifier_SineScale extends WinModBaseSine
{
	public function new()
	{
		super("sineScale");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleX += Math_Sine.getMath(value, beat, subValues);
		result.scaleY += Math_Sine.getMath(value, beat, subValues);	
	}
}

class WindowModifier_SineScaleX extends WinModBaseSine
{
	public function new()
	{
		super("sineScaleX");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleX += Math_Sine.getMath(value, beat, subValues);
	}
}

class WindowModifier_SineScaleY extends WinModBaseSine
{
	public function new()
	{
		super("sineScaleY");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleY += Math_Sine.getMath(value, beat, subValues);
	}
}

