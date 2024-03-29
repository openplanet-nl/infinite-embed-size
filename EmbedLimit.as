// The editor embed limit is an (artificial) limit in how big a map's embedded items can be in
// total. Bypassing this is only required when saving the map, loading maps with this is always
// possible even without the patch applied.

IPatch@ CreateEmbedLimitPatch()
{
#if LINUX
	return null;
#else
	return PatternPatch(
#if TMNEXT
		// Next, 64 bit
		"76 08 C7 00 01 00 00 00 EB 2D",
		"EB"
#elif MP41
		// Maniaplanet 4.1, 64 bit
		"81 FB 00 A0 0F 00 76",
		"81 FB 00 A0 0F 00 EB"
#elif TURBO
		// Turbo, 32 bit
		"83 C4 10 3B ?? ?? ?? ?? ?? 76",
		"83 C4 10 3B ?? ?? ?? ?? ?? EB"
#else
		// Other, 32 bit
		"81 FE 00 A0 0F 00 76 08 C7",
		"81 FE 00 A0 0F 00 EB"
#endif
	);
#endif
}
