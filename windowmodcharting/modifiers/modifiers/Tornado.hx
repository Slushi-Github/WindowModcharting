package windowmodcharting.modifiers.modifiers;

class WinModBaseTornado extends WindowModifierBase
{
	override private function initDefaults():Void
	{
		setSubValue("speed", 1.0);
		setSubValue("offset", 0.0);
	}
}

class WindowModifier_TornadoX extends WinModBaseTornado
{
	public function new()
	{
		super("tornadoX");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.x += Math_Tornado.getMath(value, beat, subValues);
	}
}

class WindowModifier_TornadoY extends WinModBaseTornado
{
	public function new()
	{
		super("tornadoY");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.y += Math_Tornado.getMath(value, beat, subValues);
	}
}

class WindowModifier_TornadoZ extends WinModBaseTornado
{
	public function new()
	{
		super("tornadoZ");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.z += Math_Tornado.getMath(value, beat, subValues);
	}
}

class WindowModifier_TornadoScale extends WinModBaseTornado
{
	public function new()
	{
		super("tornadoScale");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleX += Math_Tornado.getMath(value, beat, subValues);
		result.scaleY += Math_Tornado.getMath(value, beat, subValues);	
	}
}

class WindowModifier_TornadoScaleX extends WinModBaseTornado
{
	public function new()
	{
		super("tornadoScaleX");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleX += Math_Tornado.getMath(value, beat, subValues);
	}
}

class WindowModifier_TornadoScaleY extends WinModBaseTornado
{
	public function new()
	{
		super("tornadoScaleY");
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		result.scaleY += Math_Tornado.getMath(value, beat, subValues);
	}
}

