IPatch@ g_patch;

void Main()
{
	@g_patch = PatternPatch(
#if MANIA64
#if TMNEXT
		"76 08 C7 00 01 00 00 00 EB 2C",
		"EB"
#elif MP41
		"81 FB 00 A0 0F 00 76",
		"81 FB 00 A0 0F 00 EB"
#endif
#elif TURBO
		"83 C4 10 3B ?? ?? ?? ?? ?? 76",
		"83 C4 10 3B ?? ?? ?? ?? ?? EB"
#else
		"81 FE 00 A0 0F 00 76 08 C7",
		"81 FE 00 A0 0F 00 EB"
#endif
	);

	while (true) {
		yield();
	}
}

void OnDestroyed()
{
	if (g_patch.IsApplied()) {
		g_patch.Revert();
	}
}

void RenderMenu()
{
	if (UI::MenuItem("\\$fc9" + Icons::Archive + "\\$z Infinite embed size", "", g_patch.IsApplied())) {
		if (g_patch.IsApplied()) {
			g_patch.Revert();
		} else {
			g_patch.Apply();
		}
	}
}
