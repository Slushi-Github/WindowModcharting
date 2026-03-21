package windowmodcharting.modifiers.modifiers.math;

class Math_Beat
{
	public static function getMath(beat:Float, accelTime:Float, totalTime:Float):Float
	{
		var fBeat = beat + accelTime;
		var bEvenBeat = (Math.floor(fBeat) % 2) != 0;
		if (fBeat < 0)
			return 0;
		fBeat -= Math.floor(fBeat);
		fBeat += 1;
		fBeat -= Math.floor(fBeat);
		if (fBeat >= totalTime)
			return 0;
		var fAmount:Float;
		if (fBeat < accelTime)
		{
			fAmount = (fBeat / accelTime);
			fAmount *= fAmount;
		}
		else
		{
			fAmount = 1 - ((fBeat - accelTime) / (totalTime - accelTime));
			fAmount = 1 - (1 - fAmount) * (1 - fAmount);
		}
		if (bEvenBeat)
			fAmount *= -1;
		return 20.0 * fAmount;
	}
}