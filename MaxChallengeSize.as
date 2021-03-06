// Max challenge size is the the maximum filesize that maps will be loaded for and played by a
// server. This does not impact anything on clients.

IntPtr GetMaxChallengeSizePtr()
{
#if TMNEXT
	// Next, 64 bit

#if LINUX
	string pattern = "48 8D 0D ?? ?? ?? ?? 3B 01 76 0B";
	int patternOffset = 3;
#else
	string pattern = "3B ?? ?? ?? ?? ?? 77 0F 33 C0";
	int patternOffset = 2;
#endif

	auto ptr = Dev::FindPattern(pattern);
	if (ptr == 0) {
		warn("Unable to find max challenge size pointer!");
		return 0;
	}

	int ptrOffset = Dev::ReadInt32(ptr + patternOffset);
	return ptr + patternOffset + 4 + ptrOffset;

#else
	warn("Max challenge size not implemented on this game yet");
	return 0;
#endif
}
