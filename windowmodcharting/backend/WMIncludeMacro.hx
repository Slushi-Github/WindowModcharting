package windowmodcharting.backend;

#if macro
import haxe.macro.*;
import haxe.macro.Expr;

/**
 * A Macro containing Modifier classes, avoiding the problem of Haxe DCE
 */
class WMIncludeMacro
{
    public static function includeModifiers()
    {
        for (inc in [
            "windowmodcharting.modifiers.modifiers.math",
            "windowmodcharting.modifiers.modifiers"
        ]) {
            Compiler.include(inc);
        }
    }
}
#end