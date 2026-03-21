package windowmodcharting.modifiers.modifiers.math;

class Math_Drunk
{
	public static function getMath(value:Float, beat:Float, subValues:Map<String, Float>):Float
	{
		return value * Math.sin(beat * subValues.get("speed")) * 30;
	}
}