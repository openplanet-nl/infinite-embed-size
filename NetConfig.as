IntPtr GetNetConfigPtr()
{
	auto client = GetApp().Network.Client;
	auto clientMember = Reflection::TypeOf(client).GetMember("TCPSendingNodTotal");
	if (clientMember is null) {
		warn("Unable to find CNetClient member!");
		return 0;
	}

#if MANIA64
	return Dev::GetOffsetUint64(client, clientMember.Offset + 4);
#else
	return Dev::GetOffsetUint32(client, clientMember.Offset + 4);
#endif
}

IntSize GetNetConfigTcpLimitOffset()
{
#if TMNEXT
	return 0x38;
#else
	return 0;
#endif
}
