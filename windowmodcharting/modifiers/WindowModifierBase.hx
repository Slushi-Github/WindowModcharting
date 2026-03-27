package windowmodcharting.modifiers;

/**
 * Base class and structure for window modifiers
 */
class WindowModifierBase
{
	public var name:String;
	public var value:Float = 0;
	public var subValues:Map<String, Float>;

	private var dirty:Bool = true;
	private var lastBeat:Float = -999;
	private var cachedResult:WindowModResult;

	public function new(name:String)
	{
		this.name = name;
		this.subValues = new Map();
		initDefaults();
	}

	/**
	 * Set default values for the modifier
	 */
	@:noCompletion
	private function initDefaults():Void
	{
	}

	/**
	 * Calculate the math for the modifier
	 * @param beat The current beat
	 * @return WindowModResult The calculated result
	 */
	@:noCompletion
	public function calculate(beat:Float):WindowModResult
	{
		if (!dirty && beat == lastBeat && cachedResult != null)
			return cachedResult;

		var result:WindowModResult = {
			x: 0,
			y: 0,
			alpha: 1,
			scaleX: 1,
			scaleY: 1,
			z: 0
		};

		applyMod(result, beat);

		cachedResult = result;
		lastBeat = beat;
		dirty = false;
		return result;
	}

	/**
	 * Here is where the magic happens, apply the modifier
	 * @param result 
	 * @param beat 
	 */
	private function applyMod(result:WindowModResult, beat:Float):Void
	{
	}

	@:noCompletion
	public function markDirty():Void
	{
		dirty = true;
	}

	public function getSubValue(name:String):Float
	{
		return subValues.exists(name) ? subValues.get(name) : 0;
	}

	public function setSubValue(name:String, value:Float):Void
	{
		subValues.set(name, value);
		markDirty();
	}
}