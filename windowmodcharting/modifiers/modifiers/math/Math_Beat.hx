package windowmodcharting.modifiers.modifiers.math;

import flixel.math.FlxMath;

class Math_Beat
{
	public static function getMath(value:Float, beat:Float, subValues:Map<String, Float>):Float
	{
		var speed:Float = subValues.get("speed");
		var mult:Float = subValues.get("mult");
		var offset:Float = subValues.get("offset");
		var alternate:Bool = (subValues.get("alternate") >= 0.5);

		var mathToUse:Float = 0.0;

		var fAccelTime = subValues.get("fAccelTime");
		var fTotalTime = subValues.get("fTotalTime");

		var time = (beat + offset) * speed;
		var posMult = mult * 2; 
		var fBeat = time + fAccelTime;

		var bEvenBeat = (Math.floor(fBeat) % 2) != 0;

		if (fBeat < 0)
			return 0;

		fBeat -= Math.floor(fBeat);
		fBeat += 1;
		fBeat -= Math.floor(fBeat);

		if (fBeat >= fTotalTime)
			return 0;

		var fAmount:Float;
		if (fBeat < fAccelTime)
		{
			fAmount = FlxMath.remapToRange(fBeat, 0.0, fAccelTime, 0.0, 1.0);
			fAmount *= fAmount;
		}
		else
			/* fBeat < fTotalTime */ {
			fAmount = FlxMath.remapToRange(fBeat, fAccelTime, fTotalTime, 1.0, 0.0);
			fAmount = 1 - (1 - fAmount) * (1 - fAmount);
		}

		if (bEvenBeat && alternate)
			fAmount *= -1;

		mathToUse = FlxMath.fastSin((0.01 * posMult) + (Math.PI / 2.0));

		var fShift = 20.0 * fAmount * mathToUse;
		return fShift * value;
	}
}