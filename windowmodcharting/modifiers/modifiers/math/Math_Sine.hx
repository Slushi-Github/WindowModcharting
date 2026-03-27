package windowmodcharting.modifiers.modifiers.math;

import flixel.math.FlxMath;

@:access(ConductorImplementation)
class Math_Sine
{
	public static function getMath(value:Float, beat:Float, subValues:Map<String, Float>):Float
	{
		@:privateAccess
		return value * (FlxMath.fastSin(((ConductorImplementation.songPosition * 0.001) +
			0.2 * (10 / WindowFuncs.getScreenSize().height)) * (subValues.get('speed')* 0.2)) * 0.5);
	}
}