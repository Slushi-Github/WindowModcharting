package windowmodcharting.modifiers.modifiers;

class WinModBaseTanTornado extends WindowModifierBase
{
	override private function initDefaults():Void
	{
		setSubValue("speed", 1.0);
		setSubValue("offset", 0.0);
	}
}

class WindowModifier_TanTornadoX extends WinModBaseTanTornado
{
	public function new()
	{
		super("tanTornadoX");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.x += Math_TanTornado.getMath(value, beat, subValues);
	}
}

class WindowModifier_TanTornadoY extends WinModBaseTanTornado
{
	public function new()
	{
		super("tanTornadoY");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.y += Math_TanTornado.getMath(value, beat, subValues);
	}
}

class WindowModifier_TanTornadoZ extends WinModBaseTanTornado
{
	public function new()
	{
		super("tanTornadoZ");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.z += Math_TanTornado.getMath(value, beat, subValues);
	}
}

class WindowModifier_TanTornadoScale extends WinModBaseTanTornado
{
	public function new()
	{
		super("tanTornadoScale");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleX += Math_TanTornado.getMath(value, beat, subValues);
		result.scaleY += Math_TanTornado.getMath(value, beat, subValues);	
	}
}

class WindowModifier_TanTornadoScaleX extends WinModBaseTanTornado
{
	public function new()
	{
		super("tanTornadoScaleX");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleX += Math_TanTornado.getMath(value, beat, subValues);
	}
}

class WindowModifier_TanTornadoScaleY extends WinModBaseTanTornado
{
	public function new()
	{
		super("tanTornadoScaleY");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleY += Math_TanTornado.getMath(value, beat, subValues);
	}
}

