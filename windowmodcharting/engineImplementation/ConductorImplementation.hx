package windowmodcharting.engineImplementation;

#if (WM_ENGINE == "PYSCH" && WM_ENGINE_VERSION <= "0.6")
import Conductor;
#elseif (WM_ENGINE == "PYSCH" && WM_ENGINE_VERSION >= "0.7")
import backend.Conductor;
#elseif (WM_ENGINE == "CODENAME")
import funkin.backend.system.Conductor;
#elseif (WM_ENGINE == "ALE_PSYCH")
import utils.Conductor;
#elseif (WM_ENGINE == "V_SLICE")
import funkin.Conductor;
#else
#if !WM_CUSTOM_CONDUCTOR
#error "[\x1b[38;5;1mERROR\x1b[0m | windowmodcharting.engineImplementation.ConductorImplementation] Can't find a supported Conductor implementation for this project!\nDefine WM_ENGINE or WM_CUSTOM_CONDUCTOR and assign the expected type to \"ConductorImplementation.custom_songPosition\" and \"ConductorImplementation.custom_crochet\"."
#end
#end

/**
 * Static variables to get the current song position and crochet
 * 
 * There is default implementations for certain engines,
 * but you can also assign your own implementation to 
 * ``ConductorImplementation.custom_songPosition`` and 
 * ``ConductorImplementation.custom_crochet``.
 * 
 * A compilation error or runtime error will be thrown if the implementation is not found.
 */
class ConductorImplementation
{
	public static var custom_songPosition:Null<Void->Float> = null;
	public static var custom_crochet:Null<Void->Float> = null;

	private static var songPosition(get, never):Null<Float>;
	private static var crochet(get, never):Null<Float>;

	public static function get_songPosition():Null<Float>
	{
		#if (WM_ENGINE == "PYSCH" || WM_ENGINE == "CODENAME" || WM_ENGINE == "ALE_PSYCH")
		return Conductor.songPosition;
        #elseif (WM_ENGINE == "V_SLICE")
        return Conductor?.instance?.songPosition;
		#elseif WM_CUSTOM_CONDUCTOR
		if (custom_songPosition == null)
			throw "[custom_songPosition] is null, assign the expected type to \"ConductorImplementation.custom_songPosition\".";
		return custom_songPosition();
		#end
	}

	public static function get_crochet():Null<Float>
	{
		#if (WM_ENGINE == "PYSCH" || WM_ENGINE == "CODENAME" || WM_ENGINE == "ALE_PSYCH")
		return Conductor.crochet;
        #elseif (WM_ENGINE == "V_SLICE")
        return Conductor?.instance?.beatLengthMs;
		#elseif WM_CUSTOM_CONDUCTOR
		if (custom_crochet == null)
			throw "[custom_crochet] is null, assign the expected type to \"ConductorImplementation.custom_crochet\".";
		return custom_crochet();
		#end
	}
}