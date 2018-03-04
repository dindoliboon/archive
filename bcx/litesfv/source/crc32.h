/* /////////////////////////////////////////////////////////////////////////
  > crc32.h 2.0 11:55 AM 8/15/2001                      CRC-32 Header File <
  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

  Prototypes to crc32.lib, version 2.

  Copyright (c) 1997, 1999 G. Adam Stanislav
  All Rights Reserved.

  /////////////////////////////////////////////////////////////////////// */

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

void WINAPI InitTable();

/* /////////////////////////////////////////////////////////////////////////
  > 36 lines for LRC 1.2                                CRC-32 Header File <
  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ */
