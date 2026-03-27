package windowmodcharting.modifiers.modifiers.math;

import flixel.math.FlxMath;

@:access(ConductorImplementation)
class Math_TanTornado
{
	public static function getMath(value:Float, beat:Float, subValues:Map<String, Float>):Float
	{
		var offset = subValues.get('offset');
		var columnPhaseShift = Math.PI / 3;
		var phaseShift = (offset / 135) * subValues.get('speed') * 0.2;
		var returnToZeroOffset = (-Math.cos(-columnPhaseShift) + 1) / 2 * 3;
		var offset = (-Math.cos((phaseShift - columnPhaseShift)) + 1) / 2 * 3 - returnToZeroOffset;

		return offset * value; 
	}
}