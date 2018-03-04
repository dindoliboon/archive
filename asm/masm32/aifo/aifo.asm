; #########################################################################

    .386
    .model flat, stdcall
    option casemap :none   ; case sensitive

; #########################################################################

    include \masm32\include\windows.inc

    include \masm32\include\user32.inc
    include \masm32\include\kernel32.inc
    include \masm32\include\masm32.inc
    include \masm32\include\vfw32.inc

    includelib \masm32\lib\user32.lib
    includelib \masm32\lib\kernel32.lib
    includelib \masm32\lib\masm32.lib
    includelib \masm32\lib\vfw32.lib

; #########################################################################

SNDFMT_UNKNOWN equ 0000h
SNDFMT_ADPCM equ 0002h
SNDFMT_IEEE_FLOAT equ 0003h
SNDFMT_VSELP equ 0004h
SNDFMT_IBM_CVSD equ 0005h
SNDFMT_ALAW equ 0006h
SNDFMT_MULAW equ 0007h
SNDFMT_DTS equ 0008h
SNDFMT_OKI_ADPCM equ 0010h
SNDFMT_DVI_ADPCM equ 0011h
SNDFMT_MEDIASPACE_ADPCM equ 0012h
SNDFMT_SIERRA_ADPCM equ 0013h
SNDFMT_G723_ADPCM equ 0014h
SNDFMT_DIGISTD equ 0015h
SNDFMT_DIGIFIX equ 0016h
SNDFMT_DIALOGIC_OKI_ADPCM equ 0017h
SNDFMT_MEDIAVISION_ADPCM equ 0018h
SNDFMT_CU_CODEC equ 0019h
SNDFMT_YAMAHA_ADPCM equ 0020h
SNDFMT_SONARC equ 0021h
SNDFMT_DSPGROUP_TRUESPEECH equ 0022h
SNDFMT_ECHOSC1 equ 0023h
SNDFMT_AUDIOFILE_AF36 equ 0024h
SNDFMT_APTX equ 0025h
SNDFMT_AUDIOFILE_AF10 equ 0026h
SNDFMT_PROSODY_1612 equ 0027h
SNDFMT_LRC equ 0028h
SNDFMT_DOLBY_AC2 equ 0030h
SNDFMT_GSM610 equ 0031h
SNDFMT_MSNAUDIO equ 0032h
SNDFMT_ANTEX_ADPCME equ 0033h
SNDFMT_CONTROL_RES_VQLPC equ 0034h
SNDFMT_DIGIREAL equ 0035h
SNDFMT_DIGIADPCM equ 0036h
SNDFMT_CONTROL_RES_CR10 equ 0037h
SNDFMT_NMS_VBXADPCM equ 0038h
SNDFMT_CS_IMAADPCM equ 0039h
SNDFMT_ECHOSC3 equ 003Ah
SNDFMT_ROCKWELL_ADPCM equ 003Bh
SNDFMT_ROCKWELL_DIGITALK equ 003Ch
SNDFMT_XEBEC equ 003Dh
SNDFMT_G721_ADPCM equ 0040h
SNDFMT_G728_CELP equ 0041h
SNDFMT_MSG723 equ 0042h
SNDFMT_MPEG equ 0050h
SNDFMT_RT24 equ 0052h
SNDFMT_PAC equ 0053h
SNDFMT_MPEGLAYER3 equ 0055h
SNDFMT_LUCENT_G723 equ 0059h
SNDFMT_CIRRUS equ 0060h
SNDFMT_ESPCM equ 0061h
SNDFMT_VOXWARE equ 0062h
SNDFMT_CANOPUS_ATRAC equ 0063h
SNDFMT_G726_ADPCM equ 0064h
SNDFMT_G722_ADPCM equ 0065h
SNDFMT_DSAT_DISPLAY equ 0067h
SNDFMT_VOXWARE_BYTE_ALIGNED equ 0069h
SNDFMT_VOXWARE_AC8 equ 0070h
SNDFMT_VOXWARE_AC10 equ 0071h
SNDFMT_VOXWARE_AC16 equ 0072h
SNDFMT_VOXWARE_AC20 equ 0073h
SNDFMT_VOXWARE_RT24 equ 0074h
SNDFMT_VOXWARE_RT29 equ 0075h
SNDFMT_VOXWARE_RT29HW equ 0076h
SNDFMT_VOXWARE_VR12 equ 0077h
SNDFMT_VOXWARE_VR18 equ 0078h
SNDFMT_VOXWARE_TQ40 equ 0079h
SNDFMT_SOFTSOUND equ 0080h
SNDFMT_VOXWARE_TQ60 equ 0081h
SNDFMT_MSRT24 equ 0082h
SNDFMT_G729A equ 0083h
SNDFMT_MVI_MVI2 equ 0084h
SNDFMT_DF_G726 equ 0085h
SNDFMT_DF_GSM610 equ 0086h
SNDFMT_ISIAUDIO equ 0088h
SNDFMT_ONLIVE equ 0089h
SNDFMT_SBC24 equ 0091h
SNDFMT_DOLBY_AC3_SPDIF equ 0092h
SNDFMT_MEDIASONIC_G723 equ 0093h
SNDFMT_PROSODY_8KBPS equ 0094h
SNDFMT_ZYXEL_ADPCM equ 0097h
SNDFMT_PHILIPS_LPCBB equ 0098h
SNDFMT_PACKED equ 0099h
SNDFMT_MALDEN_PHONYTALK equ 00A0h
SNDFMT_RHETOREX_ADPCM equ 0100h
SNDFMT_IRAT equ 0101h
SNDFMT_VIVO_G723 equ 0111h
SNDFMT_VIVO_SIREN equ 0112h
SNDFMT_DIGITAL_G723 equ 0123h
SNDFMT_SANYO_LD_ADPCM equ 0125h
SNDFMT_SIPROLAB_ACEPLNET equ 0130h
SNDFMT_SIPROLAB_ACELP4800 equ 0131h
SNDFMT_SIPROLAB_ACELP8V3 equ 0132h
SNDFMT_SIPROLAB_G729 equ 0133h
SNDFMT_SIPROLAB_G729A equ 0134h
SNDFMT_SIPROLAB_KELVIN equ 0135h
SNDFMT_G726ADPCM equ 0140h
SNDFMT_QUALCOMM_PUREVOICE equ 0150h
SNDFMT_QUALCOMM_HALFRATE equ 0151h
SNDFMT_TUBGSM equ 0155h
SNDFMT_MSAUDIO1 equ 0160h
SNDFMT_CREATIVE_ADPCM equ 0200h
SNDFMT_CREATIVE_FASTSPEECH8 equ 0202h
SNDFMT_CREATIVE_FASTSPEECH10 equ 0203h
SNDFMT_UHER_ADPCM equ 0210h
SNDFMT_QUARTERDECK equ 0220h
SNDFMT_ILINK_VC equ 0230h
SNDFMT_RAW_SPORT equ 0240h
SNDFMT_IPI_HSX equ 0250h
SNDFMT_IPI_RPELP equ 0251h
SNDFMT_CS2 equ 0260h
SNDFMT_SONY_SCX equ 0270h
SNDFMT_FM_TOWNS_SND equ 0300h
SNDFMT_BTV_DIGITAL equ 0400h
SNDFMT_QDESIGN_MUSIC equ 0450h
SNDFMT_VME_VMPCM equ 0680h
SNDFMT_TPC equ 0681h
SNDFMT_OLIGSM equ 1000h
SNDFMT_OLIADPCM equ 1001h
SNDFMT_OLICELP equ 1002h
SNDFMT_OLISBC equ 1003h
SNDFMT_OLIOPR equ 1004h
SNDFMT_LH_CODEC equ 1100h
SNDFMT_NORRIS equ 1400h
SNDFMT_SOUNDSPACE_MUSICOMPRESS equ 1500h
SNDFMT_DVM equ 2000h


AVI_MAIN STRUCT
    dwMicroSecPerFrame    DWORD ?
    dwMaxBytesPerSec      DWORD ?
    dwPaddingGranularity  DWORD ?
    dwFlags               DWORD ?
    dwTotalFrames         DWORD ?
    dwInitialFrames       DWORD ?
    dwStreams             DWORD ?
    dwSuggestedBufferSize DWORD ?
    dwWidth               DWORD ?
    dwHeight              DWORD ?
    dwReserved            DWORD 4
AVI_MAIN ENDS

AVI_STREAM STRUCT
    fccType               DWORD ?
    fccHandler            DWORD ?
    dwFlags               DWORD ?
    wPriority             WORD  ?
    wLanguage             WORD  ?
    dwInitialFrames       DWORD ?
    dwScale               DWORD ?
    dwRate                DWORD ?
    dwStart               DWORD ?
    dwLength              DWORD ?
    dwSuggestedBufferSize DWORD ?
    dwQuality             DWORD ?
    dwSampleSize          DWORD ?
    rcFrame               SMALL_RECT <>
AVI_STREAM ENDS

    print MACRO Quoted_Text:VARARG
    LOCAL Txt
    .data
        Txt db Quoted_Text,0
    .code
        invoke StdOut,ADDR Txt
    ENDM

    newline MACRO
    LOCAL nl
    .data
        nl db 13, 10,0
    .code
        invoke StdOut,addr nl
    ENDM

    cls MACRO
        invoke ClearScreen
    ENDM

    MKFOURCC MACRO ch0, ch1, ch2, ch3
        xor eax, eax
        mov ah,  ch3
        shl eax, 8

        mov ah,  ch2
        shl eax, 8

        mov ah,  ch1
        mov al,  ch0
    ENDM

    GETPOS MACRO hFile
        invoke _llseek, hFile, 1, FILE_CURRENT
        invoke _llseek, hFile, -1, FILE_CURRENT
    ENDM

    MAKEMIN MACRO a
        mov eax, a
        sub eax, a
        sub eax, a
    ENDM

    Main   PROTO

; #########################################################################

    .data
        dwDiv    dd 1000
        szAudCod db "[%04ld] ",0
        szVidCod db "[%hs] %hs", 0
        szVid    db "%hs", 0
        szDim    db "%ld x %ld pixels", 0
        szDec    db "%ld", 0
        szFPS    db "%hs fps", 0
        szSec    db "%hs seconds", 0
        szKhz    db "%hs kHz", 0
        szKbs    db "%hs kb/s", 0
        szChan   db "%ld", 0
        szStereo db "(Stereo)", 0
        szMono   db "(Mono)", 0
        sz3IVX   db "3ivx MPEG4-based", 0
        szABYR   db "Kensington", 0
        szAEMI   db "Array VideoONE MPEG1-I Capture", 0
        szAFLC   db "Autodesk Animator for FLC", 0
        szAFLI   db "Autodesk Animator for FLI", 0
        szAMPG   db "Array VideoONE MPEG", 0
        szANIM   db "Intel RDX", 0
        szAP41   db "AngelPotion Hacked MS MP43", 0
        szASV1   db "Asus Video 1", 0
        szASV2   db "Asus Video 2", 0
        szASVX   db "Asus Video 2.0", 0
        szAUR2   db "AuraVision Aura 2: YUV 422", 0
        szAURA   db "AuraVision Aura 1: YUV 411", 0
        szBINK   db "Bink Video", 0
        szBT20   db "Brooktree MediaStream Prosumer Video", 0
        szBTCV   db "Brooktree Composite Video", 0
        szBW10   db "Data Translation Broadway MPEG Capture", 0
        szCC12   db "AuraVision Aura 2: Intel YUV12", 0
        szCDVC   db "Canopus DV", 0
        szCFCC   db "DPS Perception", 0
        szCGDI   db "Microsoft Camcorder Video", 0
        szCHAM   db "Winnov Caviara Cham", 0
        szCJPG   db "Creative Labs WebCam JPEG", 0
        szCLJR   db "Proprietary YUV 4 pixels/DWORD", 0
        szCMYK   db "Colorgraph Common Data Format in Printing", 0
        szCPLA   db "Weitek 4:2:0 YUV Planar", 0
        szCRAM   db "Microsoft Video 1", 0
        szCVID   db "Radius (org. Supermac) Cinepak", 0
        szCWLT   db "Microsoft Color WLT DIB", 0
        szCYUV   db "Creative Labs YUV", 0
        szCYUY   db "ATI Technologies YUV Compression", 0
        szD261   db "Digital Equipment H.261", 0
        szD263   db "Digital Equipment H.263", 0
        szDIV3   db "DivX ;-) MPEG-4 Slow Motion", 0
        szDIV4   db "DivX ;-) MPEG-4 Fast Motion", 0
        szDIVX   db "OpenDivX", 0
        szDMB1   db "Matrox Rainbow Runner", 0
        szDMB2   db "Paradigm MJPEG", 0
        szDUCK   db "The Duck TrueMotion 1.0", 0
        szDVE2   db "InSoft DVE-2 Video Conferencing", 0
        szDVSD   db "Pinnacle Systems miroVideo DV300 SW", 0
        szDVX1   db "Lucent DVX1000SP Video Decoder", 0
        szDVX2   db "Lucent DVX2000S Video Decoder", 0
        szDVX3   db "Lucent DVX3000S Video Decoder", 0
        szDXTC   db "Microsoft DirectX Texture Compression", 0
        szDXT1   db "Microsoft DirectX Compressed Texture 1", 0
        szDXT2   db "Microsoft DirectX Compressed Texture 2", 0
        szDXT3   db "Microsoft DirectX Compressed Texture 3", 0
        szDXT4   db "Microsoft DirectX Compressed Texture 4", 0
        szDXT5   db "Microsoft DirectX Compressed Texture 5", 0
        szESCP   db "Eidos Technologies Escape", 0
        szFLJP   db "D-Vision Field Encoded Motion JPEG /w LSI", 0
        szFRWA   db "SoftLab-Nsk Forward Motion JPEG /w Alpha", 0
        szFRWD   db "SoftLab-Nsk Forward Motion JPEG", 0
        szFVF1   db "Iterated Systems Fractal Video Frame", 0
        szGWLT   db "Microsoft Greyscale WLT DIB", 0
        szH260   db "Intel Video Conferencing H.260", 0
        szH261   db "Intel Video Conferencing H.261", 0
        szH262   db "Intel Video Conferencing H.262", 0
        szH263   db "Intel Video Conferencing H.263", 0
        szH264   db "Intel Video Conferencing H.264", 0
        szH265   db "Intel Video Conferencing H.265", 0
        szH266   db "Intel Video Conferencing H.266", 0
        szH267   db "Intel Video Conferencing H.267", 0
        szH268   db "Intel Video Conferencing H.268", 0
        szH269   db "Intel Video Conferencing H.269", 0
        szHFYU   db "Huffman Lossless Codec", 0
        szHMCR   db "Rendition Motion Compensation CR", 0
        szHMRR   db "Rendition Motion Compensation RR", 0
        szI263   db "Intel ITU H.263", 0
        szI420   db "Intel Indeo 4.2", 0
        szIAN    db "Intel Indeo Video 4 RDX", 0
        szICLB   db "InSoft CellB Video Conferencing", 0
        szIF09   db "Intel Intel Intermediate YUV9", 0
        szIGOR   db "Power DVD", 0
        szIJPG   db "Intergraph JPEG", 0
        szILVC   db "Intel Layered Video", 0
        szILVR   db "Intel nITU-T's H.263+", 0
        szIPDV   db "I-O Data Device Giga AVI DV", 0
        szIR21   db "Intel Indeo 2.1", 0
        szIRAW   db "Intel YUV uncompressed", 0
        szIV30   db "Intel Indeo Video 3.0", 0
        szIV31   db "Intel Indeo Video 3.1", 0
        szIV32   db "Intel Indeo Video 3.2", 0
        szIV33   db "Intel Indeo Video 3.3", 0
        szIV34   db "Intel Indeo Video 3.4", 0
        szIV35   db "Intel Indeo Video 3.5", 0
        szIV36   db "Intel Indeo Video 3.6", 0
        szIV37   db "Intel Indeo Video 3.7", 0
        szIV38   db "Intel Indeo Video 3.8", 0
        szIV39   db "Intel Indeo Video 3.9", 0
        szIV40   db "Intel Indeo Video 4.0", 0
        szIV41   db "Intel Indeo Video 4.1", 0
        szIV42   db "Intel Indeo Video 4.2", 0
        szIV43   db "Intel Indeo Video 4.3", 0
        szIV44   db "Intel Indeo Video 4.4", 0
        szIV45   db "Intel Indeo Video 4.5", 0
        szIV46   db "Intel Indeo Video 4.6", 0
        szIV47   db "Intel Indeo Video 4.7", 0
        szIV48   db "Intel Indeo Video 4.8", 0
        szIV49   db "Intel Indeo Video 4.9", 0
        szIV50   db "Intel Indeo Video 5.0", 0
        szIV51   db "Intel Indeo Video 5.0", 0
        szJBYR   db "Kensington", 0
        szJPEG   db "Microsoft Still Image JPEG DIB", 0
        szJPGL   db "JPEG Light", 0
        szKMVC   db "Karl Morton's VC", 0
        szLEAD   db "Lead Technologies Video", 0
        szLJPG   db "Lead Technologies MJPEG", 0
        szM261   db "Microsoft H.261", 0
        szM263   db "Microsoft H.263", 0
        szMC12   db "ATI Motion Compensation 12", 0
        szMCAM   db "ATI Motion Compensation AM", 0
        szMJPG   db "IBM Motion JPEG", 0
        szMP42   db "Microsoft MPEG-4 v2", 0
        szMP43   db "Microsoft MPEG-4 v3", 0
        szMPEG   db "Chromatic MPEG 1 Video I Frame", 0
        szMPG4   db "Microsoft MPEG-4 v1", 0
        szMPGI   db "Sigma Designs Editable MPEG", 0
        szMRCA   db "FAST Multimedia MR", 0
        szMRLE   db "Microsoft Run Length Encoding", 0
        szMSVC   db "Microsoft Video 1", 0
        szMWV1   db "Aware Motion Wavelets", 0
        szNAVI   db "SMR MPEG-4", 0
        szNTN1   db "Nogatech Video Compression 1", 0
        szNVS1   db "GeForce 2 GTS Pro Texture Format 1", 0
        szNVS2   db "GeForce 2 GTS Pro Texture Format 2", 0
        szNVS3   db "GeForce 2 GTS Pro Texture Format 3", 0
        szNVS4   db "GeForce 2 GTS Pro Texture Format 4", 0
        szNVS5   db "GeForce 2 GTS Pro Texture Format 5", 0
        szNVT1   db "GeForce 2 GTS Pro Texture Format 1", 0
        szNVT2   db "GeForce 2 GTS Pro Texture Format 2", 0
        szNVT3   db "GeForce 2 GTS Pro Texture Format 3", 0
        szNVT4   db "GeForce 2 GTS Pro Texture Format 4", 0
        szNVT5   db "GeForce 2 GTS Pro Texture Format 5", 0
        szPDVC   db "I-O Data Video Capture", 0
        szPGVV   db "Radius Video Vision", 0
        szPHMO   db "IBM Photomotion", 0
        szPIM1   db "Pinnacle Systems", 0
        szPIMJ   db "Pegasus Imaging Lossless JPEG", 0
        szPVEZ   db "Horizons Technology PowerEZ", 0
        szPVMM   db "PacketVideo MPEG-4", 0
        szPVW2   db "Pegasus Wavelet Compression", 0
        szQPEG   db "Q-Team QPEG", 0
        szQPEQ   db "Q-Team QPEG 1.1", 0
        szRGBT   db "Computer Concepts RGBT", 0
        szRLE4   db "Microsoft Run Length Encoded 4", 0
        szRLE8   db "Microsoft Run Length Encoded 8", 0
        szRT21   db "Intel Indeo 2.1", 0
        szRV20   db "RealVideo 8", 0
        szRV30   db "RealVideo G2", 0
        szRVX    db "Intel RDX", 0
        szS422   db "VideoCap C210", 0
        szSDCC   db "Sun Communications Digital Camera", 0
        szSFMC   db "Crystal Net SFM", 0
        szSMSC   db "Radius SMSC", 0
        szSMSD   db "Radius SMSD", 0
        szSMSV   db "WorldConnect Wavelet Video", 0
        szSPIG   db "Radius Spigot", 0
        szSPLC   db "Splash Studios ACM Audio", 0
        szSQZ2   db "Microsoft Vxtreme V2", 0
        szSTVA   db "ST CMOS Imager Data Bayer", 0
        szSTVB   db "ST CMOS Imager Data Nudged Bayer", 0
        szSTVC   db "ST CMOS Imager Data Bunched", 0
        szSTVX   db "ST CMOS Imager Data+", 0
        szSTVY   db "ST CMOS Imager Data+ /w Correction", 0
        szSV10   db "Sorenson Video R1", 0
        szSVQ1   db "Sorenson Video", 0
        szTLMS   db "TeraLogic Motion Intraframe", 0
        szTLST   db "TeraLogic Motion Intraframe", 0
        szTM20   db "The Duck TrueMotion 2.0", 0
        szTM2X   db "The Duck TrueMotion 2X", 0
        szTMIC   db "TeraLogic Motion Intraframe 2", 0
        szTMOT   db "Horizons Technology True Motion", 0
        szTR20   db "The Duck TrueMotion RT 2.0", 0
        szTSCC   db "TechSmith Screen Capture", 0
        szTV10   db "Tecomac Low-Bit Rate", 0
        szTY0N   db "Trident Microsystems 0n", 0
        szTY2C   db "Trident Microsystems 2C", 0
        szTY2N   db "Trident Microsystems 2N", 0
        szUCOD   db "eMajix.com ClearVideo", 0
        szULTI   db "IBM Ultimotion", 0
        szUYVY   db "Microsoft UYVY 4:2:2 byte ordering", 0
        szV261   db "Lucent VX2000S", 0
        szV422   db "Vitec 24 bit YUV 4:2:2 (CCIR 601)", 0
        szV655   db "Vitec 16 bit YUV 4:2:2", 0
        szVCR1   db "ATI VCR 1.0", 0
        szVCR2   db "ATI VCR 2.0", 0
        szVCR3   db "ATI VCR 3.0", 0
        szVCR4   db "ATI VCR 4.0", 0
        szVCR5   db "ATI VCR 5.0", 0
        szVCR6   db "ATI VCR 6.0", 0
        szVCR7   db "ATI VCR 7.0", 0
        szVCR8   db "ATI VCR 8.0", 0
        szVCR9   db "ATI VCR 9.0", 0
        szVDCT   db "Vitec Multimedia Video Maker Pro DIB", 0
        szVDOM   db "VDONet VDOWave", 0
        szVDOW   db "VDONet VDOLive H.263", 0
        szVDTZ   db "Darim Vision VideoTizer YUV", 0
        szVGPX   db "Alaris", 0
        szVIDS   db "Vitec YUV 4:2:2 CCIR for V422", 0
        szVIVO   db "Vivo H.263 Video", 0
        szVIXL   db "Miro Computer Products Vixl", 0
        szVLV1   db "Videologic VLCAP.DRV", 0
        szVP30   db "On2 VP3.0", 0
        szVP31   db "On2 VP3.1", 0
        szVX1K   db "Lucent VX1000S", 0
        szVX2K   db "Lucent VX2000S", 0
        szVXSP   db "Lucent VX1000SP", 0
        szWBVC   db "Winbond Electronics W9960", 0
        szWHAM   db "Microsoft Video 1", 0
        szWINX   db "Winnov Software Compression for Videum", 0
        szWJPG   db "Winbond JPEG for AverMedia USB TV-Tuner", 0
        szWNV1   db "Winnov Hardware Compression", 0
        szX263   db "Xirlink X263", 0
        szXLV0   db "NetXL XL Video Decoder", 0
        szXMPG   db "Xing MPEG Editable I Frame", 0
        szY211   db "Microsoft YUV 2:1:1 Packed", 0
        szY411   db "Microsoft YUV 4:1:1 Packed", 0
        szY41B   db "Weitek YUV 4:1:1 Planar", 0
        szY41P   db "Brooktree PC1 4:1:1", 0
        szY41T   db "Brooktree PC1 4:1:1 with transparency", 0
        szY42B   db "Weitek YUV 4:2:2 Planar", 0
        szY42T   db "Brooktree PCI 4:2:2 with transparency", 0
        szY8     db "Grayscale video", 0
        szYC12   db "Intel YUV12", 0
        szYU92   db "Intel YUV92", 0
        szYUV8   db "Winnov Caviar YUV8", 0
        szYUV9   db "Intel YUV9", 0
        szYUY2   db "Microsoft YUYV 4:2:2 byte ordering packed", 0
        szYUYV   db "Canopus BI_YUYV Compressor", 0
        szYV12   db "Weitek YVU12 Planar", 0
        szYVU9   db "Intel YVU9 Planar", 0
        szYVYU   db "Microsoft YVYU 4:2:2 byte ordering", 0
        szZLIB   db "ZLIB Lossless", 0
        szZPEG   db "Metheus Video Zipper", 0
        szUNKN   db "Unknown Format",0

        sz0002   db "Microsoft ADPCM", 0
        sz0003   db "Microsoft IEEE_FLOAT", 0
        sz0004   db "Compaq VSELP", 0
        sz0005   db "IBM CVSD", 0
        sz0006   db "Microsoft ALAW", 0
        sz0007   db "Microsoft MULAW", 0
        sz0008   db "Microsoft DTS", 0
        sz0010   db "OKI ADPCM", 0
        sz0011   db "Intel DVI_ADPCM", 0
        sz0012   db "Video Logic ADPCM", 0
        sz0013   db "Sierra ADPCM", 0
        sz0014   db "Antex G723 ADPCM", 0
        sz0015   db "DSP Digi STD", 0
        sz0016   db "DSP Digi FIX", 0
        sz0017   db "Dialogic ADPCM", 0
        sz0018   db "Media Vision ADPCM", 0
        sz0019   db "Crystal CODEC", 0
        sz0020   db "Yamaha ADPCM", 0
        sz0021   db "Speech Sonarc", 0
        sz0022   db "DSP Group True Speech", 0
        sz0023   db "Echo SC1", 0
        sz0024   db "Virtual Music AF36", 0
        sz0025   db "APT X", 0
        sz0026   db "Virtual Music AF10", 0
        sz0027   db "Aculab Prosody 1612", 0
        sz0028   db "Merging LRC", 0
        sz0030   db "Dolby AC2", 0
        sz0031   db "Microsoft GSM610", 0
        sz0032   db "MSN Audio", 0
        sz0033   db "Antex ADPCME", 0
        sz0034   db "Control Resources VQLPC", 0
        sz0035   db "DSP REAL", 0
        sz0036   db "DSP ADPCM", 0
        sz0037   db "Control Resources CR10", 0
        sz0038   db "Natural VBXADPCM", 0
        sz0039   db "Crystal IMAADPCM", 0
        sz003A   db "Echo SC3", 0
        sz003B   db "Rockwell ADPCM", 0
        sz003C   db "Rockwell DigiTalk", 0
        sz003D   db "Xebec", 0
        sz0040   db "Antex G721 ADPCM", 0
        sz0041   db "Antex G728 Celp", 0
        sz0042   db "Microsoft MSG723", 0
        sz0050   db "Microsoft MPEG", 0
        sz0052   db "InSoft RT24", 0
        sz0053   db "InSoft PAC", 0
        sz0055   db "ISO/MPEG Layer-3", 0
        sz0059   db "Lucent G723", 0
        sz0060   db "Cirrus", 0
        sz0061   db "ESS ESPCM", 0
        sz0062   db "Voxware", 0
        sz0063   db "Canopus ATRAC", 0
        sz0064   db "APICOM G726 ADPCM", 0
        sz0065   db "APICOM G722 ADPCM", 0
        sz0067   db "Microsoft DSAT Display", 0
        sz0069   db "Voxware Byte Aligned", 0
        sz0070   db "Voxware AC8", 0
        sz0071   db "Voxware AC10", 0
        sz0072   db "Voxware AC16", 0
        sz0073   db "Voxware AC20", 0
        sz0074   db "Voxware RT24", 0
        sz0075   db "Voxware RT29", 0
        sz0076   db "Voxware RT29HW", 0
        sz0077   db "Voxware VR12", 0
        sz0078   db "Voxware VR18", 0
        sz0079   db "Voxware TQ40", 0
        sz0080   db "Softsound", 0
        sz0081   db "Voxware TQ60", 0
        sz0082   db "Microsoft MSRT24", 0
        sz0083   db "AT&T G729A", 0
        sz0084   db "Motion MVI2", 0
        sz0085   db "DataFusion G726", 0
        sz0086   db "DataFusion GSM610", 0
        sz0088   db "Iterated ISIAUDIO", 0
        sz0089   db "OnLive!", 0
        sz0091   db "Siemens SBC24", 0
        sz0092   db "Sonic Foundry Dolby AC3", 0
        sz0093   db "MediaSonic G723", 0
        sz0094   db "Aculab Prosody", 0
        sz0097   db "ZyXEL ADPCM", 0
        sz0098   db "Philips LPCBB", 0
        sz0099   db "Studer Packed", 0
        sz00A0   db "Malden PhonyTalk", 0
        sz0100   db "Rhetorex ADPCM", 0
        sz0101   db "BeCubed IRAT", 0
        sz0111   db "VIVO G723", 0
        sz0112   db "VIVO SIREN", 0
        sz0123   db "Digital G723", 0
        sz0125   db "Sanyo LD ADPCM", 0
        sz0130   db "Sipro Lab Acelpnet", 0
        sz0131   db "Sipro Lab Acelp 4800", 0
        sz0132   db "Sipro Lab Acelp 8 v3", 0
        sz0133   db "Sipro Lab G729", 0
        sz0134   db "Sipro Lab G729A", 0
        sz0135   db "Sipro Lab Kelvin", 0
        sz0140   db "Dictaphone G726", 0
        sz0150   db "Qualcomm Pure Voice", 0
        sz0151   db "Qualcomm Half Rate", 0
        sz0155   db "Ring Zero TUBGSM", 0
        sz0160   db "Microsoft Audio 1", 0
        sz0200   db "Creative ADPCM", 0
        sz0202   db "Creative FastSpeech 8", 0
        sz0203   db "Creative FastSpeech 10", 0
        sz0210   db "UHER ADPCM", 0
        sz0220   db "QuarterDeck", 0
        sz0230   db "I-link VC", 0
        sz0240   db "Aureal Sport", 0
        sz0250   db "Interactive HSX", 0
        sz0251   db "Interactive RPELP", 0
        sz0260   db "Consistent CS2", 0
        sz0270   db "Sony SCX", 0
        sz0300   db "Fujitsu Towns Snd", 0
        sz0400   db "Brooktree Digital", 0
        sz0450   db "QDesign Music", 0
        sz0680   db "AT&T VME_VMPCM", 0
        sz0681   db "AT&T TPC", 0
        sz1000   db "Ing OLIGSM", 0
        sz1001   db "Ing OLIADPCM", 0
        sz1002   db "Ing OLICELP", 0
        sz1003   db "Ing OLISBC", 0
        sz1004   db "Ing OLIOPR", 0
        sz1100   db "Lernout & Hauspie", 0
        sz1400   db "Norris", 0
        sz1500   db "AT&T Sound Space", 0
        sz2000   db "Fast Multimedia DVM", 0

    .code

start:
    invoke Main

    invoke ExitProcess, 0

; #########################################################################

Main proc
    LOCAL szBuffer[256] :BYTE
    LOCAL clBuffer[128] :BYTE
    LOCAL dwBuffer      :DWORD
    LOCAL hFile         :DWORD
    LOCAL am            :AVI_MAIN
    LOCAL as            :AVI_STREAM
    LOCAL vs            :AVI_STREAM
    LOCAL szTitle1[5]   :BYTE
    LOCAL szTitle2[5]   :BYTE
    LOCAL dwLast        :DWORD
    LOCAL dwOffset      :DWORD
    LOCAL dwTmp         :DWORD
    LOCAL wf            :WAVEFORMATEX
    LOCAL x :QWORD
    LOCAL y :QWORD
 
    invoke GetCL, 1, addr clBuffer
    .if eax != 1
        print "Usage:", 13, 10
        print "    avinfo.exe filename.avi", 13, 10
        ret
    .else
        invoke CreateFile, addr clBuffer, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_ARCHIVE, NULL
        mov hFile, eax
        .if eax == INVALID_HANDLE_VALUE
            print "Usage:", 13, 10
            print "    avinfo.exe filename.avi", 13, 10
            ret
        .endif
        invoke CloseHandle, hFile
    .endif

    invoke _lopen, addr clBuffer, OF_READ
    mov hFile, eax

    ; riff (size) 'avi '
    invoke _llseek, hFile, 32, FILE_CURRENT
    invoke _lread, hFile, addr am, sizeof am
    invoke _llseek, hFile, 88, FILE_BEGIN

    mov dwLast, 0
    mov dwBuffer, 1

    GETPOS hFile
    mov dwOffset, eax

@@:
    ; list all parent sections (LIST, avih, JUNK, idx1)
    invoke _lread, hFile, addr szTitle1, 4
    invoke _lread, hFile, addr dwBuffer, 4
    invoke _lread, hFile, addr szTitle2, 4

    mov eax, dwBuffer
    .if eax == dwLast || eax == 0
        jmp @F
    .else
        invoke lcase, addr szTitle1
        MKFOURCC szTitle1[0], szTitle1[1], szTitle1[2], szTitle1[3]
        .if eax == 1953720684	; list
            invoke lcase, addr szTitle2
            MKFOURCC szTitle2[0], szTitle2[1], szTitle2[2], szTitle2[3]
            .if eax == 1819440243	;strl
                mov dwTmp, 8

                invoke _llseek, hFile, 8, FILE_CURRENT
                invoke _lread, hFile, addr szTitle1, 4
                invoke _llseek, hFile, -4, FILE_CURRENT

                invoke lcase, addr szTitle1
                MKFOURCC szTitle1[0], szTitle1[1], szTitle1[2], szTitle1[3]
                .if eax == 1935960438		; video
                    invoke _lread, hFile, addr vs, sizeof vs
                    add dwTmp, sizeof vs
                .elseif eax == 1935963489	; audio
                    invoke _lread, hFile, addr as, sizeof as
                    invoke _llseek, hFile, 8, FILE_CURRENT
                    invoke _lread, hFile, addr wf, sizeof wf
                    add dwTmp, sizeof as
                    add dwTmp, sizeof wf
                    add dwTmp, 8
                .endif

                MAKEMIN dwTmp
                invoke _llseek, hFile, eax, FILE_CURRENT
            .endif
        .endif

        sub dwBuffer, 4
        invoke _llseek, hFile, dwBuffer, FILE_CURRENT
        mov dwOffset, eax
    .endif

    ; seek back to beginning of structure when all work is done
    invoke _llseek, hFile, dwOffset, FILE_BEGIN

    mov eax, dwBuffer
    .if eax == dwLast
        jmp @F
    .else
        mov dwLast, eax
        jmp @B
    .endif
@@:
    invoke _lclose, hFile

    cls
    cls

    print "            ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿", 13, 10
    print "            ³ Video Codec :                                                   ³", 13, 10
    print "            ³ Dimensions  :                                                   ³", 13, 10
    print "            ³ Length      :                                                   ³", 13, 10
    print "  Ü         ³ Frames      :                                                   ³", 13, 10
    print " Û Û Ü Ü ß  ³ Frame Rate  :                                                   ³", 13, 10
    print " ÛßÛ ßÜß Û  ³ Streams     :                                                   ³", 13, 10
    print "            ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ", 13, 10, 13, 10
    print " ÜÜÜ       ÜÜ                Ü       ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿", 13, 10
    print "  Û  ÜÜÜ  ÛÜ  ÜßÜ ÛÜÜ  Ü Ü  ÛÜß ÛÜÜ  ³                                        ³", 13, 10
    print " ÜÛÜ Û  Û Û   ßÜß Û   Û Û Û ßÜÜ Û    ³ Avg Data Rate :                        ³", 13, 10
    print "                                     ³ Sample Rate   :                        ³", 13, 10
    print "                       Version 0.01  ³ Channels      :                        ³", 13, 10
    print "                                     ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ", 13, 10, 13, 10
    print "> "
    invoke StdOut, addr clBuffer
    print 13, 10

    invoke wsprintf, addr szBuffer, addr szDim, am.dwWidth, am.dwHeight
    invoke locate, 28, 2
    invoke StdOut, addr szBuffer

    invoke wsprintf, addr szBuffer, addr szDec, am.dwTotalFrames
    invoke locate, 28, 4
    invoke StdOut, addr szBuffer

    invoke wsprintf, addr szBuffer, addr szDec, am.dwStreams
    invoke locate, 28, 6
    invoke StdOut, addr szBuffer

    invoke wsprintf, addr szTitle1, addr szVid, addr vs.fccHandler
    invoke lcase, addr szTitle1
    MKFOURCC szTitle1[0],szTitle1[1], szTitle1[2], szTitle1[3]

    .if eax == 2021026099
        mov eax, offset sz3IVX
    .elseif eax == 1920557665
        mov eax, offset szABYR
    .elseif eax == 1768777057
        mov eax, offset szAEMI
    .elseif eax == 1668048481
        mov eax, offset szAFLC
    .elseif eax == 1768711777
        mov eax, offset szAFLI
    .elseif eax == 1735421281
        mov eax, offset szAMPG
    .elseif eax == 1835626081
        mov eax, offset szANIM
    .elseif eax == 825520225
        mov eax, offset szAP41
    .elseif eax == 829846369
        mov eax, offset szASV1
    .elseif eax == 846623585
        mov eax, offset szASV2
    .elseif eax == 2021028705
        mov eax, offset szASVX
    .elseif eax == 846361953
        mov eax, offset szAUR2
    .elseif eax == 1634891105
        mov eax, offset szAURA
    .elseif eax == 1802398050
        mov eax, offset szBINK
    .elseif eax == 808612962
        mov eax, offset szBT20
    .elseif eax == 1986229346
        mov eax, offset szBTCV
    .elseif eax == 808548194
        mov eax, offset szBW10
    .elseif eax == 842097507
        mov eax, offset szCC12
    .elseif eax == 1668703331
        mov eax, offset szCDVC
    .elseif eax == 1667458659
        mov eax, offset szCFCC
    .elseif eax == 1768187747
        mov eax, offset szCGDI
    .elseif eax == 1835100259
        mov eax, offset szCHAM
    .elseif eax == 1735420515
        mov eax, offset szCJPG
    .elseif eax == 1919577187
        mov eax, offset szCLJR
    .elseif eax == 1803119971
        mov eax, offset szCMYK
    .elseif eax == 1634496611
        mov eax, offset szCPLA
    .elseif eax == 1835102819
        mov eax, offset szCRAM
    .elseif eax == 1684633187
        mov eax, offset szCVID
    .elseif eax == 1953265507
        mov eax, offset szCWLT
    .elseif eax == 1987410275
        mov eax, offset szCYUV
    .elseif eax == 2037741923
        mov eax, offset szCYUY
    .elseif eax == 825635428
        mov eax, offset szD261
    .elseif eax == 859189860
        mov eax, offset szD263
    .elseif eax == 863398244
        mov eax, offset szDIV3
    .elseif eax == 880175460
        mov eax, offset szDIV4
    .elseif eax == 2021026148
        mov eax, offset szDIVX
    .elseif eax == 828534116
        mov eax, offset szDMB1
    .elseif eax == 845311332
        mov eax, offset szDMB2
    .elseif eax == 1801680228
        mov eax, offset szDUCK
    .elseif eax == 845510244
        mov eax, offset szDVE2
    .elseif eax == 1685288548
        mov eax, offset szDVSD
    .elseif eax == 829978212
        mov eax, offset szDVX1
    .elseif eax == 846755428
        mov eax, offset szDVX2
    .elseif eax == 863532644
        mov eax, offset szDVX3
    .elseif eax == 1668577380
        mov eax, offset szDXTC
    .elseif eax == 829716580
        mov eax, offset szDXT1
    .elseif eax == 846493796
        mov eax, offset szDXT2
    .elseif eax == 863271012
        mov eax, offset szDXT3
    .elseif eax == 880048228
        mov eax, offset szDXT4
    .elseif eax == 896825444
        mov eax, offset szDXT5
    .elseif eax == 1885565797
        mov eax, offset szESCP
    .elseif eax == 1886022758
        mov eax, offset szFLJP
    .elseif eax == 1635218022
        mov eax, offset szFRWA
    .elseif eax == 1685549670
        mov eax, offset szFRWD
    .elseif eax == 828798566
        mov eax, offset szFVF1
    .elseif eax == 1953265511
        mov eax, offset szGWLT
    .elseif eax == 808858216
        mov eax, offset szH260
    .elseif eax == 825635432
        mov eax, offset szH261
    .elseif eax == 842412648
        mov eax, offset szH262
    .elseif eax == 859189864
        mov eax, offset szH263
    .elseif eax == 875967080
        mov eax, offset szH264
    .elseif eax == 892744296
        mov eax, offset szH265
    .elseif eax == 909521512
        mov eax, offset szH266
    .elseif eax == 926298728
        mov eax, offset szH267
    .elseif eax == 943075944
        mov eax, offset szH268
    .elseif eax == 959853160
        mov eax, offset szH269
    .elseif eax == 1970890344
        mov eax, offset szHFYU
    .elseif eax == 1919118696
        mov eax, offset szHMCR
    .elseif eax == 1920101736
        mov eax, offset szHMRR
    .elseif eax == 859189865
        mov eax, offset szI263
    .elseif eax == 808596585
        mov eax, offset szI420
    .elseif eax == 544104809
        mov eax, offset szIAN 
    .elseif eax == 1651270505
        mov eax, offset szICLB
    .elseif eax == 959473257
        mov eax, offset szIF09
    .elseif eax == 1919903593
        mov eax, offset szIGOR
    .elseif eax == 1735420521
        mov eax, offset szIJPG
    .elseif eax == 1668705385
        mov eax, offset szILVC
    .elseif eax == 1920363625
        mov eax, offset szILVR
    .elseif eax == 1986293865
        mov eax, offset szIPDV
    .elseif eax == 825389673
        mov eax, offset szIR21
    .elseif eax == 2002874985
        mov eax, offset szIRAW
    .elseif eax == 808679017
        mov eax, offset szIV30
    .elseif eax == 825456233
        mov eax, offset szIV31
    .elseif eax == 842233449
        mov eax, offset szIV32
    .elseif eax == 859010665
        mov eax, offset szIV33
    .elseif eax == 875787881
        mov eax, offset szIV34
    .elseif eax == 892565097
        mov eax, offset szIV35
    .elseif eax == 909342313
        mov eax, offset szIV36
    .elseif eax == 926119529
        mov eax, offset szIV37
    .elseif eax == 942896745
        mov eax, offset szIV38
    .elseif eax == 959673961
        mov eax, offset szIV39
    .elseif eax == 808744553
        mov eax, offset szIV40
    .elseif eax == 825521769
        mov eax, offset szIV41
    .elseif eax == 842298985
        mov eax, offset szIV42
    .elseif eax == 859076201
        mov eax, offset szIV43
    .elseif eax == 875853417
        mov eax, offset szIV44
    .elseif eax == 892630633
        mov eax, offset szIV45
    .elseif eax == 909407849
        mov eax, offset szIV46
    .elseif eax == 926185065
        mov eax, offset szIV47
    .elseif eax == 942962281
        mov eax, offset szIV48
    .elseif eax == 959739497
        mov eax, offset szIV49
    .elseif eax == 808810089
        mov eax, offset szIV50
    .elseif eax == 825587305
        mov eax, offset szIV51
    .elseif eax == 1920557674
        mov eax, offset szJBYR
    .elseif eax == 1734701162
        mov eax, offset szJPEG
    .elseif eax == 1818718314
        mov eax, offset szJPGL
    .elseif eax == 1668705643
        mov eax, offset szKMVC
    .elseif eax == 1684104556
        mov eax, offset szLEAD
    .elseif eax == 1735420524
        mov eax, offset szLJPG
    .elseif eax == 825635437
        mov eax, offset szM261
    .elseif eax == 859189869
        mov eax, offset szM263
    .elseif eax == 842097517
        mov eax, offset szMC12
    .elseif eax == 1835098989
        mov eax, offset szMCAM
    .elseif eax == 1735420525
        mov eax, offset szMJPG
    .elseif eax == 842297453
        mov eax, offset szMP42
    .elseif eax == 859074669
        mov eax, offset szMP43
    .elseif eax == 1734701165
        mov eax, offset szMPEG
    .elseif eax == 879194221
        mov eax, offset szMPG4
    .elseif eax == 1768386669
        mov eax, offset szMPGI
    .elseif eax == 1633907309
        mov eax, offset szMRCA
    .elseif eax == 1701605997
        mov eax, offset szMRLE
    .elseif eax == 1668707181
        mov eax, offset szMSVC
    .elseif eax == 829847405
        mov eax, offset szMWV1
    .elseif eax == 1769365870
        mov eax, offset szNAVI
    .elseif eax == 829322350
        mov eax, offset szNTN1
    .elseif eax == 829650542
        mov eax, offset szNVS1
    .elseif eax == 846427758
        mov eax, offset szNVS2
    .elseif eax == 863204974
        mov eax, offset szNVS3
    .elseif eax == 879982190
        mov eax, offset szNVS4
    .elseif eax == 896759406
        mov eax, offset szNVS5
    .elseif eax == 829716078
        mov eax, offset szNVT1
    .elseif eax == 846493294
        mov eax, offset szNVT2
    .elseif eax == 863270510
        mov eax, offset szNVT3
    .elseif eax == 880047726
        mov eax, offset szNVT4
    .elseif eax == 896824942
        mov eax, offset szNVT5
    .elseif eax == 1668703344
        mov eax, offset szPDVC
    .elseif eax == 1987471216
        mov eax, offset szPGVV
    .elseif eax == 1869441136
        mov eax, offset szPHMO
    .elseif eax == 829254000
        mov eax, offset szPIM1
    .elseif eax == 1785555312
        mov eax, offset szPIMJ
    .elseif eax == 2053469808
        mov eax, offset szPVEZ
    .elseif eax == 1835890288
        mov eax, offset szPVMM
    .elseif eax == 846689904
        mov eax, offset szPVW2
    .elseif eax == 1734701169
        mov eax, offset szQPEG
    .elseif eax == 1902473329
        mov eax, offset szQPEQ
    .elseif eax == 1952606066
        mov eax, offset szRGBT
    .elseif eax == 879062130
        mov eax, offset szRLE4
    .elseif eax == 946170994
        mov eax, offset szRLE8
    .elseif eax == 825390194
        mov eax, offset szRT21
    .elseif eax == 808613490
        mov eax, offset szRV20
    .elseif eax == 808679026
        mov eax, offset szRV30
    .elseif eax == 544765554
        mov eax, offset szRVX 
    .elseif eax == 842151027
        mov eax, offset szS422
    .elseif eax == 1667458163
        mov eax, offset szSDCC
    .elseif eax == 1668114035
        mov eax, offset szSFMC
    .elseif eax == 1668509043
        mov eax, offset szSMSC
    .elseif eax == 1685286259
        mov eax, offset szSMSD
    .elseif eax == 1987276147
        mov eax, offset szSMSV
    .elseif eax == 1734963315
        mov eax, offset szSPIG
    .elseif eax == 1668051059
        mov eax, offset szSPLC
    .elseif eax == 846885235
        mov eax, offset szSQZ2
    .elseif eax == 1635153011
        mov eax, offset szSTVA
    .elseif eax == 1651930227
        mov eax, offset szSTVB
    .elseif eax == 1668707443
        mov eax, offset szSTVC
    .elseif eax == 2021028979
        mov eax, offset szSTVX
    .elseif eax == 2037806195
        mov eax, offset szSTVY
    .elseif eax == 808547955
        mov eax, offset szSV10
    .elseif eax == 829519475
        mov eax, offset szSVQ1
    .elseif eax == 1936551028
        mov eax, offset szTLMS
    .elseif eax == 1953721460
        mov eax, offset szTLST
    .elseif eax == 808611188
        mov eax, offset szTM20
    .elseif eax == 2016570740
        mov eax, offset szTM2X
    .elseif eax == 1667853684
        mov eax, offset szTMIC
    .elseif eax == 1953459572
        mov eax, offset szTMOT
    .elseif eax == 808612468
        mov eax, offset szTR20
    .elseif eax == 1667462004
        mov eax, offset szTSCC
    .elseif eax == 808547956
        mov eax, offset szTV10
    .elseif eax == 1848670580
        mov eax, offset szTY0N
    .elseif eax == 1664252276
        mov eax, offset szTY2C
    .elseif eax == 1848801652
        mov eax, offset szTY2N
    .elseif eax == 1685021557
        mov eax, offset szUCOD
    .elseif eax == 1769237621
        mov eax, offset szULTI
    .elseif eax == 2037807477
        mov eax, offset szUYVY
    .elseif eax == 825635446
        mov eax, offset szV261
    .elseif eax == 842151030
        mov eax, offset szV422
    .elseif eax == 892679798
        mov eax, offset szV655
    .elseif eax == 829580150
        mov eax, offset szVCR1
    .elseif eax == 846357366
        mov eax, offset szVCR2
    .elseif eax == 863134582
        mov eax, offset szVCR3
    .elseif eax == 879911798
        mov eax, offset szVCR4
    .elseif eax == 896689014
        mov eax, offset szVCR5
    .elseif eax == 913466230
        mov eax, offset szVCR6
    .elseif eax == 930243446
        mov eax, offset szVCR7
    .elseif eax == 947020662
        mov eax, offset szVCR8
    .elseif eax == 963797878
        mov eax, offset szVCR9
    .elseif eax == 1952670838
        mov eax, offset szVDCT
    .elseif eax == 1836016758
        mov eax, offset szVDOM
    .elseif eax == 2003788918
        mov eax, offset szVDOW
    .elseif eax == 2054448246
        mov eax, offset szVDTZ
    .elseif eax == 2020632438
        mov eax, offset szVGPX
    .elseif eax == 1935960438
        mov eax, offset szVIDS
    .elseif eax == 1870031222
        mov eax, offset szVIVO
    .elseif eax == 1819830646
        mov eax, offset szVIXL
    .elseif eax == 829844598
        mov eax, offset szVLV1
    .elseif eax == 808677494
        mov eax, offset szVP30
    .elseif eax == 825454710
        mov eax, offset szVP31
    .elseif eax == 1798404214
        mov eax, offset szVX1K
    .elseif eax == 1798469750
        mov eax, offset szVX2K
    .elseif eax == 1886615670
        mov eax, offset szVXSP
    .elseif eax == 1668702839
        mov eax, offset szWBVC
    .elseif eax == 1835100279
        mov eax, offset szWHAM
    .elseif eax == 2020501879
        mov eax, offset szWINX
    .elseif eax == 1735420535
        mov eax, offset szWJPG
    .elseif eax == 829845111
        mov eax, offset szWNV1
    .elseif eax == 859189880
        mov eax, offset szX263
    .elseif eax == 813067384
        mov eax, offset szXLV0
    .elseif eax == 1735421304
        mov eax, offset szXMPG
    .elseif eax == 825307769
        mov eax, offset szY211
    .elseif eax == 825308281
        mov eax, offset szY411
    .elseif eax == 1647391865
        mov eax, offset szY41B
    .elseif eax == 1882272889
        mov eax, offset szY41P
    .elseif eax == 1949381753
        mov eax, offset szY41T
    .elseif eax == 1647457401
        mov eax, offset szY42B
    .elseif eax == 1949447289
        mov eax, offset szY42T
    .elseif eax == 538982521
        mov eax, offset szY8  
    .elseif eax == 842097529
        mov eax, offset szYC12
    .elseif eax == 842626425
        mov eax, offset szYU92
    .elseif eax == 947287417
        mov eax, offset szYUV8
    .elseif eax == 964064633
        mov eax, offset szYUV9
    .elseif eax == 846820729
        mov eax, offset szYUY2
    .elseif eax == 1987671417
        mov eax, offset szYUYV
    .elseif eax == 842102393
        mov eax, offset szYV12
    .elseif eax == 963999353
        mov eax, offset szYVU9
    .elseif eax == 1970894457
        mov eax, offset szYVYU
    .elseif eax == 1651076218
        mov eax, offset szZLIB
    .elseif eax == 1734701178
        mov eax, offset szZPEG
    .elseif eax == 543517810
        mov eax, offset szMRLE
    .else
        mov eax, offset szUNKN
    .endif

    invoke wsprintf, addr szBuffer, addr szVidCod, addr vs.fccHandler, eax
    invoke locate, 28, 1
    invoke StdOut, addr szBuffer

    .if wf.wFormatTag == SNDFMT_ADPCM
        mov eax, offset sz0002
    .elseif wf.wFormatTag == SNDFMT_IEEE_FLOAT
        mov eax, offset sz0003
    .elseif wf.wFormatTag == SNDFMT_VSELP
        mov eax, offset sz0004
    .elseif wf.wFormatTag == SNDFMT_IBM_CVSD
        mov eax, offset sz0005
    .elseif wf.wFormatTag == SNDFMT_ALAW
        mov eax, offset sz0006
    .elseif wf.wFormatTag == SNDFMT_MULAW
        mov eax, offset sz0007
    .elseif wf.wFormatTag == SNDFMT_DTS
        mov eax, offset sz0008
    .elseif wf.wFormatTag == SNDFMT_OKI_ADPCM
        mov eax, offset sz0010
    .elseif wf.wFormatTag == SNDFMT_DVI_ADPCM
        mov eax, offset sz0011
    .elseif wf.wFormatTag == SNDFMT_MEDIASPACE_ADPCM
        mov eax, offset sz0012
    .elseif wf.wFormatTag == SNDFMT_SIERRA_ADPCM
        mov eax, offset sz0013
    .elseif wf.wFormatTag == SNDFMT_G723_ADPCM
        mov eax, offset sz0014
    .elseif wf.wFormatTag == SNDFMT_DIGISTD
        mov eax, offset sz0015
    .elseif wf.wFormatTag == SNDFMT_DIGIFIX
        mov eax, offset sz0016
    .elseif wf.wFormatTag == SNDFMT_DIALOGIC_OKI_ADPCM
        mov eax, offset sz0017
    .elseif wf.wFormatTag == SNDFMT_MEDIAVISION_ADPCM
        mov eax, offset sz0018
    .elseif wf.wFormatTag == SNDFMT_CU_CODEC
        mov eax, offset sz0019
    .elseif wf.wFormatTag == SNDFMT_YAMAHA_ADPCM
        mov eax, offset sz0020
    .elseif wf.wFormatTag == SNDFMT_SONARC
        mov eax, offset sz0021
    .elseif wf.wFormatTag == SNDFMT_DSPGROUP_TRUESPEECH
        mov eax, offset sz0022
    .elseif wf.wFormatTag == SNDFMT_ECHOSC1
        mov eax, offset sz0023
    .elseif wf.wFormatTag == SNDFMT_AUDIOFILE_AF36
        mov eax, offset sz0024
    .elseif wf.wFormatTag == SNDFMT_APTX
        mov eax, offset sz0025
    .elseif wf.wFormatTag == SNDFMT_AUDIOFILE_AF10
        mov eax, offset sz0026
    .elseif wf.wFormatTag == SNDFMT_PROSODY_1612
        mov eax, offset sz0027
    .elseif wf.wFormatTag == SNDFMT_LRC
        mov eax, offset sz0028
    .elseif wf.wFormatTag == SNDFMT_DOLBY_AC2
        mov eax, offset sz0030
    .elseif wf.wFormatTag == SNDFMT_GSM610
        mov eax, offset sz0031
    .elseif wf.wFormatTag == SNDFMT_MSNAUDIO
        mov eax, offset sz0032
    .elseif wf.wFormatTag == SNDFMT_ANTEX_ADPCME
        mov eax, offset sz0033
    .elseif wf.wFormatTag == SNDFMT_CONTROL_RES_VQLPC
        mov eax, offset sz0034
    .elseif wf.wFormatTag == SNDFMT_DIGIREAL
        mov eax, offset sz0035
    .elseif wf.wFormatTag == SNDFMT_DIGIADPCM
        mov eax, offset sz0036
    .elseif wf.wFormatTag == SNDFMT_CONTROL_RES_CR10
        mov eax, offset sz0037
    .elseif wf.wFormatTag == SNDFMT_NMS_VBXADPCM
        mov eax, offset sz0038
    .elseif wf.wFormatTag == SNDFMT_CS_IMAADPCM
        mov eax, offset sz0039
    .elseif wf.wFormatTag == SNDFMT_ECHOSC3
        mov eax, offset sz003A
    .elseif wf.wFormatTag == SNDFMT_ROCKWELL_ADPCM
        mov eax, offset sz003B
    .elseif wf.wFormatTag == SNDFMT_ROCKWELL_DIGITALK
        mov eax, offset sz003C
    .elseif wf.wFormatTag == SNDFMT_XEBEC
        mov eax, offset sz003D
    .elseif wf.wFormatTag == SNDFMT_G721_ADPCM
        mov eax, offset sz0040
    .elseif wf.wFormatTag == SNDFMT_G728_CELP
        mov eax, offset sz0041
    .elseif wf.wFormatTag == SNDFMT_MSG723
        mov eax, offset sz0042
    .elseif wf.wFormatTag == SNDFMT_MPEG
        mov eax, offset sz0050
    .elseif wf.wFormatTag == SNDFMT_RT24
        mov eax, offset sz0052
    .elseif wf.wFormatTag == SNDFMT_PAC
        mov eax, offset sz0053
    .elseif wf.wFormatTag == SNDFMT_MPEGLAYER3
        mov eax, offset sz0055
    .elseif wf.wFormatTag == SNDFMT_LUCENT_G723
        mov eax, offset sz0059
    .elseif wf.wFormatTag == SNDFMT_CIRRUS
        mov eax, offset sz0060
    .elseif wf.wFormatTag == SNDFMT_ESPCM
        mov eax, offset sz0061
    .elseif wf.wFormatTag == SNDFMT_VOXWARE
        mov eax, offset sz0062
    .elseif wf.wFormatTag == SNDFMT_CANOPUS_ATRAC
        mov eax, offset sz0063
    .elseif wf.wFormatTag == SNDFMT_G726_ADPCM
        mov eax, offset sz0064
    .elseif wf.wFormatTag == SNDFMT_G722_ADPCM
        mov eax, offset sz0065
    .elseif wf.wFormatTag == SNDFMT_DSAT_DISPLAY
        mov eax, offset sz0067
    .elseif wf.wFormatTag == SNDFMT_VOXWARE_BYTE_ALIGNED
        mov eax, offset sz0069
    .elseif wf.wFormatTag == SNDFMT_VOXWARE_AC8
        mov eax, offset sz0070
    .elseif wf.wFormatTag == SNDFMT_VOXWARE_AC10
        mov eax, offset sz0071
    .elseif wf.wFormatTag == SNDFMT_VOXWARE_AC16
        mov eax, offset sz0072
    .elseif wf.wFormatTag == SNDFMT_VOXWARE_AC20
        mov eax, offset sz0073
    .elseif wf.wFormatTag == SNDFMT_VOXWARE_RT24
        mov eax, offset sz0074
    .elseif wf.wFormatTag == SNDFMT_VOXWARE_RT29
        mov eax, offset sz0075
    .elseif wf.wFormatTag == SNDFMT_VOXWARE_RT29HW
        mov eax, offset sz0076
    .elseif wf.wFormatTag == SNDFMT_VOXWARE_VR12
        mov eax, offset sz0077
    .elseif wf.wFormatTag == SNDFMT_VOXWARE_VR18
        mov eax, offset sz0078
    .elseif wf.wFormatTag == SNDFMT_VOXWARE_TQ40
        mov eax, offset sz0079
    .elseif wf.wFormatTag == SNDFMT_SOFTSOUND
        mov eax, offset sz0080
    .elseif wf.wFormatTag == SNDFMT_VOXWARE_TQ60
        mov eax, offset sz0081
    .elseif wf.wFormatTag == SNDFMT_MSRT24
        mov eax, offset sz0082
    .elseif wf.wFormatTag == SNDFMT_G729A
        mov eax, offset sz0083
    .elseif wf.wFormatTag == SNDFMT_MVI_MVI2
        mov eax, offset sz0084
    .elseif wf.wFormatTag == SNDFMT_DF_G726
        mov eax, offset sz0085
    .elseif wf.wFormatTag == SNDFMT_DF_GSM610
        mov eax, offset sz0086
    .elseif wf.wFormatTag == SNDFMT_ISIAUDIO
        mov eax, offset sz0088
    .elseif wf.wFormatTag == SNDFMT_ONLIVE
        mov eax, offset sz0089
    .elseif wf.wFormatTag == SNDFMT_SBC24
        mov eax, offset sz0091
    .elseif wf.wFormatTag == SNDFMT_DOLBY_AC3_SPDIF
        mov eax, offset sz0092
    .elseif wf.wFormatTag == SNDFMT_MEDIASONIC_G723
        mov eax, offset sz0093
    .elseif wf.wFormatTag == SNDFMT_PROSODY_8KBPS
        mov eax, offset sz0094
    .elseif wf.wFormatTag == SNDFMT_ZYXEL_ADPCM
        mov eax, offset sz0097
    .elseif wf.wFormatTag == SNDFMT_PHILIPS_LPCBB
        mov eax, offset sz0098
    .elseif wf.wFormatTag == SNDFMT_PACKED
        mov eax, offset sz0099
    .elseif wf.wFormatTag == SNDFMT_MALDEN_PHONYTALK
        mov eax, offset sz00A0
    .elseif wf.wFormatTag == SNDFMT_RHETOREX_ADPCM
        mov eax, offset sz0100
    .elseif wf.wFormatTag == SNDFMT_IRAT
        mov eax, offset sz0101
    .elseif wf.wFormatTag == SNDFMT_VIVO_G723
        mov eax, offset sz0111
    .elseif wf.wFormatTag == SNDFMT_VIVO_SIREN
        mov eax, offset sz0112
    .elseif wf.wFormatTag == SNDFMT_DIGITAL_G723
        mov eax, offset sz0123
    .elseif wf.wFormatTag == SNDFMT_SANYO_LD_ADPCM
        mov eax, offset sz0125
    .elseif wf.wFormatTag == SNDFMT_SIPROLAB_ACEPLNET
        mov eax, offset sz0130
    .elseif wf.wFormatTag == SNDFMT_SIPROLAB_ACELP4800
        mov eax, offset sz0131
    .elseif wf.wFormatTag == SNDFMT_SIPROLAB_ACELP8V3
        mov eax, offset sz0132
    .elseif wf.wFormatTag == SNDFMT_SIPROLAB_G729
        mov eax, offset sz0133
    .elseif wf.wFormatTag == SNDFMT_SIPROLAB_G729A
        mov eax, offset sz0134
    .elseif wf.wFormatTag == SNDFMT_SIPROLAB_KELVIN
        mov eax, offset sz0135
    .elseif wf.wFormatTag == SNDFMT_G726ADPCM
        mov eax, offset sz0140
    .elseif wf.wFormatTag == SNDFMT_QUALCOMM_PUREVOICE
        mov eax, offset sz0150
    .elseif wf.wFormatTag == SNDFMT_QUALCOMM_HALFRATE
        mov eax, offset sz0151
    .elseif wf.wFormatTag == SNDFMT_TUBGSM
        mov eax, offset sz0155
    .elseif wf.wFormatTag == SNDFMT_MSAUDIO1
        mov eax, offset sz0160
    .elseif wf.wFormatTag == SNDFMT_CREATIVE_ADPCM
        mov eax, offset sz0200
    .elseif wf.wFormatTag == SNDFMT_CREATIVE_FASTSPEECH8
        mov eax, offset sz0202
    .elseif wf.wFormatTag == SNDFMT_CREATIVE_FASTSPEECH10
        mov eax, offset sz0203
    .elseif wf.wFormatTag == SNDFMT_UHER_ADPCM
        mov eax, offset sz0210
    .elseif wf.wFormatTag == SNDFMT_QUARTERDECK
        mov eax, offset sz0220
    .elseif wf.wFormatTag == SNDFMT_ILINK_VC
        mov eax, offset sz0230
    .elseif wf.wFormatTag == SNDFMT_RAW_SPORT
        mov eax, offset sz0240
    .elseif wf.wFormatTag == SNDFMT_IPI_HSX
        mov eax, offset sz0250
    .elseif wf.wFormatTag == SNDFMT_IPI_RPELP
        mov eax, offset sz0251
    .elseif wf.wFormatTag == SNDFMT_CS2
        mov eax, offset sz0260
    .elseif wf.wFormatTag == SNDFMT_SONY_SCX
        mov eax, offset sz0270
    .elseif wf.wFormatTag == SNDFMT_FM_TOWNS_SND
        mov eax, offset sz0300
    .elseif wf.wFormatTag == SNDFMT_BTV_DIGITAL
        mov eax, offset sz0400
    .elseif wf.wFormatTag == SNDFMT_QDESIGN_MUSIC
        mov eax, offset sz0450
    .elseif wf.wFormatTag == SNDFMT_VME_VMPCM
        mov eax, offset sz0680
    .elseif wf.wFormatTag == SNDFMT_TPC
        mov eax, offset sz0681
    .elseif wf.wFormatTag == SNDFMT_OLIGSM
        mov eax, offset sz1000
    .elseif wf.wFormatTag == SNDFMT_OLIADPCM
        mov eax, offset sz1001
    .elseif wf.wFormatTag == SNDFMT_OLICELP
        mov eax, offset sz1002
    .elseif wf.wFormatTag == SNDFMT_OLISBC
        mov eax, offset sz1003
    .elseif wf.wFormatTag == SNDFMT_OLIOPR
        mov eax, offset sz1004
    .elseif wf.wFormatTag == SNDFMT_LH_CODEC
        mov eax, offset sz1100
    .elseif wf.wFormatTag == SNDFMT_NORRIS
        mov eax, offset sz1400
    .elseif wf.wFormatTag == SNDFMT_SOUNDSPACE_MUSICOMPRESS
        mov eax, offset sz1500
    .elseif wf.wFormatTag == SNDFMT_DVM
        mov eax, offset sz2000
    .else
        mov eax, offset szUNKN
    .endif

    invoke wsprintf, addr szBuffer, addr szVid, eax
    invoke locate, 46, 10
    invoke StdOut, addr szBuffer

    fild  wf.wFormatTag
    fistp x

    invoke wsprintf, addr szBuffer, addr szAudCod, x
    invoke locate, 39, 10
    invoke StdOut, addr szBuffer

    ; frame rate
    fld  vs.dwRate
    fdiv vs.dwScale
    fstp x

    ; length
    fld   am.dwTotalFrames
    fdiv  vs.dwRate
    fimul vs.dwScale
    fstp  y

    invoke FloatToStr, y, addr szBuffer
    invoke wsprintf, addr szBuffer, addr szSec, addr szBuffer
    invoke locate, 28, 3
    invoke StdOut, addr szBuffer

    invoke FloatToStr, x, addr szBuffer
    invoke wsprintf, addr szBuffer, addr szFPS, addr szBuffer
    invoke locate, 28, 5
    invoke StdOut, addr szBuffer

    ; frame rate
    fld  wf.nAvgBytesPerSec
    fdiv dwDiv
    fstp x

    invoke FloatToStr, x, addr szBuffer
    invoke wsprintf, addr szBuffer, addr szKbs, addr szBuffer
    invoke locate, 55, 11
    invoke StdOut, addr szBuffer

    ; frame rate
    fld  wf.nSamplesPerSec
    fdiv dwDiv
    fstp x

    invoke FloatToStr, x, addr szBuffer
    invoke wsprintf, addr szBuffer, addr szKhz, addr szBuffer
    invoke locate, 55, 12
    invoke StdOut, addr szBuffer

    fild  wf.nChannels
    fistp x
    .if wf.nChannels == 2
        mov eax, offset szStereo
    .else
        mov eax, offset szMono
    .endif
    invoke wsprintf, addr szBuffer, addr szVid, eax
    invoke locate, 57, 13
    invoke StdOut, addr szBuffer

    invoke wsprintf, addr szBuffer, addr szChan, x
    invoke locate, 55, 13
    invoke StdOut, addr szBuffer

    invoke locate, 0, 17
    ret

Main endp

; #########################################################################

end start
