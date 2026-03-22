package windowmodcharting.modifiers.modifiers;

class WindowModifier_Visible extends WindowModifierBase
{
    private var lastVisible:Bool = true;

    public function new()
    {
        super("visible");
        value = 1.0;
    }

    override private function applyMod(result:WindowModResult, beat:Float):Void
{
    final isVisible = value >= 1.0;
    if (isVisible != lastVisible)
    {
        WindowFuncs.setWindowVisible(isVisible);
        if (isVisible)
            WindowFuncs.focusWindow();
        lastVisible = isVisible;
    }
}
}