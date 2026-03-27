package windowmodcharting.modifiers.modifiers.math;

import flixel.math.FlxMath;

@:access(ConductorImplementation)
class Math_Bounce
{
    public static function getMath(value:Float, beat:Float, subValues:Map<String, Float>):Float
    {
        var speed:Float = subValues.get("speed");
		var usesAlt:Bool = (subValues.get("useAlt") >= 0.5);

		var mathToUse:Float = 0.0;

		if (!usesAlt)
			mathToUse = Math.abs(FlxMath.fastSin(0.005 * (speed * 2)));
		else
			mathToUse = Math.abs(FlxMath.fastCos(0.005 * (speed * 2)));

		return value * mathToUse;
    }
}