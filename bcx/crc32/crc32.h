//
// CRC32.DLL, version 2
//
// DLL header file
//
// Copyright (c) 1997, 1999 G. Adam Stanislav
// All Rights Reserved.
//

UINT WINAPI Crc32(
	UINT oldCrc,
	UINT aByte);

UINT WINAPI InitCrc32(
	void);

UINT WINAPI FinishCrc32(
	UINT oldCrc);

UINT WINAPI ArrayCrc32(
	BYTE *arrayPtr,
	UINT arraySize);

UINT WINAPI PartialCrc32(
	UINT oldCrc,
	BYTE *arrayPtr,
	UINT arraySize);

void WINAPI AboutCrc32(
	HWND hwnd);
