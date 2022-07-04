IntPtr GetMaxChallengeSizePtr()
{
#if TMNEXT
	// Next, 64 bit

#if LINUX
	string pattern = "48 8D 0D ?? ?? ?? ?? 3B 01 76 0B";
	int patternOffset = 3;
#else
	string pattern = "3B ?? ?? ?? ?? ?? 77 0F";
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
