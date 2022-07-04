[Setting name="Enable editor embed limit patch"]
bool Setting_EmbedLimitPatch = true;

[Setting name="Maximum size in megabytes" min="4" max="64"]
uint Setting_MaximumSize = 12;

IPatch@ g_patchEmbedLimit;

IntPtr g_ptrMaxChallengeSize = 0;
IntPtr g_ptrNetConfig = 0;

void Main()
{
	@g_patchEmbedLimit = CreateEmbedLimitPatch();
	g_ptrMaxChallengeSize = GetMaxChallengeSizePtr();
	g_ptrNetConfig = GetNetConfigPtr();

	ApplySettings();
}

void ApplySettings()
{
	if (Setting_EmbedLimitPatch && !g_patchEmbedLimit.IsApplied()) {
		g_patchEmbedLimit.Apply();
	} else if (!Setting_EmbedLimitPatch && g_patchEmbedLimit.IsApplied()) {
		g_patchEmbedLimit.Revert();
	}

	uint maxBytes = Setting_MaximumSize * 1024 * 1024;

	if (g_ptrMaxChallengeSize != 0) {
		// Substract 0xC00 to match Nadeo's amounts
		Dev::Write(g_ptrMaxChallengeSize, uint(maxBytes - 0xC00));
	}

	if (g_ptrNetConfig != 0) {
		IntSize offset = GetNetConfigTcpLimitOffset();
		if (offset == 0) {
			warn("This game doesn't support the net config patch yet");
			trace("Todo: " + Text::FormatPointer(g_ptrNetConfig));
		} else {
			Dev::Write(g_ptrNetConfig + offset, uint(maxBytes));
		}
	}
}

void OnSettingsChanged()
{
	ApplySettings();
}

void OnDestroyed()
{
	if (g_patchEmbedLimit !is null && g_patchEmbedLimit.IsApplied()) {
		g_patchEmbedLimit.Revert();
	}
}

void RenderMenu()
{
	if (g_patchEmbedLimit is null) {
		return;
	}

	if (UI::MenuItem("\\$fc9" + Icons::Archive + "\\$z Infinite embed size", "", Setting_EmbedLimitPatch)) {
		Setting_EmbedLimitPatch = !Setting_EmbedLimitPatch;
		ApplySettings();
	}
}
