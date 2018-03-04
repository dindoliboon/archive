//
// aPLib compression library  -  the smaller the better :)
//
// DLL header file
//
// Copyright (c) 1998-2000 by Joergen Ibsen / Jibz
// All Rights Reserved.
//

UINT WINAPI _aP_pack(
	unsigned char *source,
	unsigned char *destination,
	unsigned int length,
	unsigned char *workmem,
	int (__cdecl *callback) (unsigned int, unsigned int));

UINT WINAPI _aP_workmem_size(
	unsigned int inputsize);

UINT WINAPI _aP_depack_asm(
	unsigned char *source,
	unsigned char *destination);

UINT WINAPI _aP_depack_asm_fast(
	unsigned char *source,
	unsigned char *destination);
