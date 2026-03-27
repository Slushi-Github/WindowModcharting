package windowmodcharting.modifiers.modifiers;

import flixel.math.FlxMath;

class WindowModifier_Shake extends WindowModifierBase
{
    public function new()
    {
        super("shake");
    }

    override private function applyMod(result:WindowModResult, beat:Float):Void
    {
        result.x += shakeMath(value);
        result.y += shakeMath(value);
    }

    private static function shakeMath(value:Float):Float
    {
        return FlxMath.fastSin(0.1) * (value * FlxG.random.int(1, 20));
    }
}