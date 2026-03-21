package windowmodcharting.backend;

import flixel.system.scaleModes.BaseScaleMode;
import flixel.math.FlxPoint;
import flixel.FlxG;

/**
 * A custom FlxScaleMode, it mantains the game size 
 * independent of the window size
 */
class WindowDanceScaleMode extends BaseScaleMode
{
	private var fixedGameW:Int;
	private var fixedGameH:Int;

	public function new(gameW:Int, gameH:Int)
	{
		super();
		fixedGameW = gameW;
		fixedGameH = gameH;
	}

	override public function onMeasure(Width:Int, Height:Int):Void
	{
		gameSize.set(fixedGameW, fixedGameH);
		scale.set(1.0, 1.0);
		FlxG.game.scaleX = 1.0;
		FlxG.game.scaleY = 1.0;
		updateGamePosition();
	}
}