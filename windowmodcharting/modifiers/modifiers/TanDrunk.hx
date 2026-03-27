package windowmodcharting.modifiers.modifiers;

class WinModBaseTanDrunk extends WindowModifierBase
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

class WindowModifier_TanDrunkX extends WinModBaseTanDrunk
{
	public function new()
	{
		super("tanDrunkX");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.x += Math_TanDrunk.getMath(value, beat, subValues);
	}
}

class WindowModifier_TanDrunkY extends WinModBaseTanDrunk
{
	public function new()
	{
		super("tanDrunkY");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.y += Math_TanDrunk.getMath(value, beat, subValues);
	}
}

class WindowModifier_TanDrunkZ extends WinModBaseTanDrunk
{
	public function new()
	{
		super("tanDrunkZ");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.z += Math_TanDrunk.getMath(value, beat, subValues);
	}
}

class WindowModifier_TanDrunkScale extends WinModBaseTanDrunk
{
	public function new()
	{
		super("tanDrunkScale");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleX += Math_TanDrunk.getMath(value, beat, subValues);
		result.scaleY += Math_TanDrunk.getMath(value, beat, subValues);	
	}
}

class WindowModifier_TanDrunkScaleX extends WinModBaseTanDrunk
{
	public function new()
	{
		super("tanDrunkScaleX");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleX += Math_TanDrunk.getMath(value, beat, subValues);
	}
}

class WindowModifier_TanDrunkScaleY extends WinModBaseTanDrunk
{
	public function new()
	{
		super("tanDrunkScaleY");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleY += Math_TanDrunk.getMath(value, beat, subValues);
	}
}

