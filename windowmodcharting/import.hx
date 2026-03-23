#if !macro
import windowmodcharting.backend.window.WindowFuncs;
import windowmodcharting.backend.window.WindowNative;
import windowmodcharting.backend.window.WindowNativeGL;
import windowmodcharting.backend.WindowDanceScaleMode;

import windowmodcharting.engineImplementation.ConductorImplementation;

import windowmodcharting.framework.WindowModifierTween;

import windowmodcharting.modifiers.modifiers.math.*;
import windowmodcharting.modifiers.modifiers.*;

import windowmodcharting.modifiers.WindowModifierBase;
import windowmodcharting.modifiers.WindowModifierCallback;
import windowmodcharting.modifiers.WindowModResult;

import windowmodcharting.WindowModManager;

import haxe.PosInfos;

import lime.app.Application;

import flixel.FlxBasic;
import flixel.FlxG;

#if !WM_DONT_CHANGE_FLX_SCALE_MODE
import flixel.system.scaleModes.BaseScaleMode;
#end
#end