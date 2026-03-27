package windowmodcharting.modifiers.modifiers.math;

import flixel.math.FlxMath;

@:access(ConductorImplementation)
class Math_TanDrunk
{
	public static function getMath(value:Float, beat:Float, subValues:Map<String, Float>):Float
	{
		@:privateAccess
		var time:Float = (subValues.get('timertype') >= 0.5 ? beat : ConductorImplementation.songPosition * 0.001);
		time *= subValues.get('speed') / 2.0;
		time += subValues.get('offset');

		var usesAlt:Bool = (subValues.get("useAlt") >= 0.5);
		var screenHeight:Float = WindowFuncs.getScreenSize().height;
		var drunk_desync:Float = subValues.get("desync") * 0.2;
		var returnValue:Float = 0.0;
		var mult:Float = subValues.get("size") / 2;
		if (!usesAlt)
			returnValue = value * (Math.tan((time) + drunk_desync +
				0.45 * (10.0 / screenHeight) * mult)) * 0.5;
		else
			returnValue = value * (1 / Math.sin((time) + drunk_desync
				+ 0.45 * (10.0 / screenHeight) * mult)) * 0.5;

		return returnValue;
	}
}