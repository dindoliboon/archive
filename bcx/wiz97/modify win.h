// replace existing PROPSHEETPAGE and PROPSHEETHEADER structures
// with new structures!!!

typedef struct _PROPSHEETPAGE {
	DWORD dwSize;
	DWORD dwFlags;
	HINSTANCE hInstance;
	union {
		LPCTSTR pszTemplate;
		LPCDLGTEMPLATE pResource;
	};
	union {
		HICON hIcon;
		LPCTSTR pszIcon;
	};
	LPCTSTR pszTitle;
	DLGPROC pfnDlgProc;
	LPARAM lParam;
	LPFNPSPCALLBACK pfnCallback;
	UINT *pcRefParent;

        LPCSTR pszHeaderTitle;    // this is displayed in the header
        LPCSTR pszHeaderSubTitle; //

} PROPSHEETPAGE,*LPPROPSHEETPAGE;



typedef struct _PROPSHEETHEADER {
	DWORD dwSize;
	DWORD dwFlags;
	HWND hwndParent;
	HINSTANCE hInstance;
	union {
		HICON hIcon;
		LPCTSTR pszIcon;
	};
	LPCTSTR pszCaption;
	UINT nPages;
	union {
		UINT nStartPage;
		LPCTSTR pStartPage;
	};
	union {
		LPCPROPSHEETPAGE ppsp;
		HPROPSHEETPAGE *phpage;
	};
	PFNPROPSHEETCALLBACK pfnCallback;

        union {
            HBITMAP hbmWatermark;
            LPCSTR pszbmWatermark;
        };
        HPALETTE hplWatermark;
        union {
            HBITMAP hbmHeader;     // Header  bitmap shares the palette with watermark
            LPCSTR pszbmHeader;
        };
} PROPSHEETHEADER,*LPPROPSHEETHEADER;
