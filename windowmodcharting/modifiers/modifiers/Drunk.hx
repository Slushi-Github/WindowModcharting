package windowmodcharting.modifiers.modifiers;

class WinModBaseDrunk extends WindowModifierBase
{
	override private function initDefaults():Void
	{
		setSubValue("speed", 1.0);
		setSubValue("size", 1.0);
		setSubValue("desync", 1.0);
		setSubValue("offset", 1.0);
		setSubValue("useAlt", 0.0);
		setSubValue("timertype", 0.0);
	}
}

class WindowModifier_DrunkX extends WinModBaseDrunk
{
	public function new()
	{
		super("drunkX");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.x += Math_Drunk.getMath(value, beat, subValues);
	}
}

class WindowModifier_DrunkY extends WinModBaseDrunk
{
	public function new()
	{
		super("drunkY");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.y += Math_Drunk.getMath(value, beat, subValues);
	}
}

class WindowModifier_DrunkZ extends WinModBaseDrunk
{
	public function new()
	{
		super("drunkZ");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.z += Math_Drunk.getMath(value, beat, subValues);
	}
}

class WindowModifier_DrunkScale extends WinModBaseDrunk
{
	public function new()
	{
		super("drunkScale");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleX += Math_Drunk.getMath(value, beat, subValues);
		result.scaleY += Math_Drunk.getMath(value, beat, subValues);	
	}
}

class WindowModifier_DrunkScaleX extends WinModBaseDrunk
{
	public function new()
	{
		super("drunkScaleX");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleX += Math_Drunk.getMath(value, beat, subValues);
	}
}

class WindowModifier_DrunkScaleY extends WinModBaseDrunk
{
	public function new()
	{
		super("drunkScaleY");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleY += Math_Drunk.getMath(value, beat, subValues);
	}
}

