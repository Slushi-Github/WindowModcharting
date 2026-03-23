package windowmodcharting.modifiers;

/**
 * A modifier that delegates applyMod to a user-provided callback function.
 * This allows defining custom modifiers at runtime or in source code
 * without subclassing WindowModifierBase manually.
 *
 * The callback receives the result, the current beat, and the modifier
 * instance itself so you can access `value` and `subValues`.
 */
class WindowModifierCallback extends WindowModifierBase
{
	private var _applyFunc:(result:WindowModResult, beat:Float, mod:WindowModifierBase)->Void;

	public function new(name:String, applyFunc:(WindowModResult->Float->WindowModifierBase->Void))
	{
		_applyFunc = applyFunc;
		super(name);
	}

	override private function applyMod(result:WindowModResult, beat:Float):Void
	{
		if (_applyFunc != null)
			_applyFunc(result, beat, this);
	}
}