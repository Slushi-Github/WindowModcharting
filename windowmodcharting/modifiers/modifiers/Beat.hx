package windowmodcharting.modifiers.modifiers;

class WinModBaseBeat extends WindowModifierBase
{
	override private function initDefaults():Void
	{
		setSubValue("speed", 1.0);
		setSubValue("mult", 1.0);
		setSubValue("offset", 0.0);
		setSubValue("alternate", 1.0);
		setSubValue("fAccelTime", 0.2);
		setSubValue("fTotalTime", 0.5);
	}
}

class WindowModifier_BeatX extends WinModBaseBeat
{
	public function new()
	{
		super("beatX");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.x += Math_Beat.getMath(value, beat, subValues);
	}
}

class WindowModifier_BeatY extends WinModBaseBeat
{
	public function new()
	{
		super("beatY");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.y += Math_Beat.getMath(value, beat, subValues);
	}
}

class WindowModifier_BeatZ extends WinModBaseBeat
{
	public function new()
	{
		super("beatZ");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.z += Math_Beat.getMath(value, beat, subValues);
	}
}

class WindowModifier_BeatScale extends WinModBaseBeat
{
	public function new()
	{
		super("beatScale");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleX += Math_Beat.getMath(value, beat, subValues);
		result.scaleY += Math_Beat.getMath(value, beat, subValues);
	}
}

class WindowModifier_BeatScaleX extends WinModBaseBeat
{
	public function new()
	{
		super("beatScaleX");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleX += Math_Beat.getMath(value, beat, subValues);
	}
}

class WindowModifier_BeatScaleY extends WinModBaseBeat
{
	public function new()
	{
		super("beatScaleY");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleY += Math_Beat.getMath(value, beat, subValues);
	}
}

