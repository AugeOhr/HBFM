#pragma BEGINDUMP
#include "SET_COMPILE_HMG_UNICODE.ch"
#ifndef COMPILE_HMG_UNICODE
   #define COMPILE_HMG_UNICODE   // Force to compile in UNICODE
#endif
#include "HMG_UNICODE.h"
#include <windows.h>
#include "hbapi.h"
#include "hpdf.h"
#include <tchar.h>


//        HMG_IsFuncDLL ( pLibDLL | cLibName, cFuncName ) ---> Boolean
HB_FUNC ( HMG_ISFUNCDLL )
{
   HMODULE hModule = NULL;
   BOOL bRelease;

   if ( HB_ISCHAR (1) )
   {  hModule = LoadLibrary ((TCHAR *) HMG_parc (1));
      bRelease = TRUE;
   }
   else
   {  hModule = hb_libHandle (hb_param (1, HB_IT_ANY));
      bRelease = FALSE;
   }

   CHAR * cFuncName = (CHAR *) hb_parc (2);

   hb_retl (GetProcAddress (hModule, cFuncName) ? TRUE : FALSE);

   if (bRelease && hModule)
      FreeLibrary (hModule);
}

HB_FUNC ( _HMG_HPDF_DRAWTEXT )
{
   HDC    hDC   = (HDC)     HMG_parnl (1);
   HFONT  hFont = (HFONT)   HMG_parnl (2);
   COLORREF RGBcolor = (COLORREF) hb_parni (3);
   TCHAR *cText = (TCHAR *) HMG_parc  (4);
   RECT rect = {0,0,0,0};
   rect.right  = hb_parni (5);
   rect.bottom = hb_parni (6);
   UINT nAlign = (UINT) hb_parni (7);


   SetGraphicsMode (hDC, GM_ADVANCED);

   SelectObject (hDC, hFont);
   SetTextColor (hDC, RGBcolor);
// SetBkColor (hDC, RGB (255,255,255));
   SetBkMode (hDC, TRANSPARENT);

   DrawText (hDC, cText, -1, &rect, DT_NOCLIP | DT_WORDBREAK | /*DT_EXTERNALLEADING |*/ DT_NOPREFIX | nAlign);
}


HB_FUNC ( _HMG_HPDF_CREATEFONT )
{
   HFONT hFont ;
   int bold = FW_NORMAL;
   int italic = 0;
   int underline = 0;
   int strikeout = 0;

   if ( hb_parl (4) )
      bold = FW_BOLD;

   if ( hb_parl (5) )
      italic = 1;

   if ( hb_parl (6) )
      underline = 1;

   if ( hb_parl (7) )
      strikeout = 1;

   HDC hDC = (HDC) HMG_parnl (1);
   TCHAR *FontName = (TCHAR *) HMG_parc (2);
   INT FontSize = hb_parni (3);

   SetGraphicsMode (hDC, GM_ADVANCED);

   FontSize = FontSize * GetDeviceCaps (hDC, LOGPIXELSY) / 72;   // Size of font in logic points

   hFont = CreateFont (0-FontSize, 0, 0, 0, bold, italic, underline, strikeout,
           DEFAULT_CHARSET, OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH | FF_DONTCARE, FontName);

   HMG_retnl ((LONG_PTR) hFont );
}


extern HPDF_Doc hb_HPDF_Doc_par (int);

HB_FUNC ( _HPDF_LOADRAWBITMAP )
{
    char       *FileName;
    HPDF_Doc    hpdf_Doc;
    HPDF_Image  image;
    UINT        nWidth, nHeight;

    hpdf_Doc = (HPDF_Doc) hb_HPDF_Doc_par (1);
    FileName = (char *)   hb_parc (2);
    nWidth   = (UINT)     hb_parni (3);
    nHeight  = (UINT)     hb_parni (4);

    image = HPDF_LoadRawImageFromFile (hpdf_Doc, FileName, nWidth, nHeight, HPDF_CS_DEVICE_RGB);

    if (image == NULL)
        hb_retnl((LONG) HPDF_GetError (hpdf_Doc));
    else
        hb_retptr ((void *) image); // Return image (void* ptr)
}



HB_FUNC ( _HMG_HPDF_SAVEBITMAPBITS )
{
   HBITMAP hBitmap  = (HBITMAP) HMG_parnl (1);
   TCHAR  *FileName = (TCHAR*)  HMG_parc  (2);
   HGLOBAL hBits;
   LPBYTE  lp_Bits, _R, _B;
   BYTE aux;
   DWORD nBytes_Bits;
   HDC memDC;
   BITMAPINFO BI;
   BITMAP bm;
   HANDLE  hFile;
   DWORD nBytes_Written;
   INT y, x;

   GetObject(hBitmap, sizeof(BITMAP), (LPBYTE)&bm);

   BI.bmiHeader.biSize          = sizeof(BITMAPINFOHEADER);
   BI.bmiHeader.biWidth         = bm.bmWidth;
   BI.bmiHeader.biHeight        = - bm.bmHeight;
   BI.bmiHeader.biPlanes        = 1;
   BI.bmiHeader.biBitCount      = 24;
   BI.bmiHeader.biCompression   = BI_RGB;
   BI.bmiHeader.biSizeImage     = 0;
   BI.bmiHeader.biXPelsPerMeter = 0;
   BI.bmiHeader.biYPelsPerMeter = 0;
   BI.bmiHeader.biClrUsed       = 0;
   BI.bmiHeader.biClrImportant  = 0;

   bm.bmWidthBytes = (bm.bmWidth * BI.bmiHeader.biBitCount + 31) / 32 * 4;
   nBytes_Bits  = (DWORD)(bm.bmWidthBytes * labs(bm.bmHeight));

   hBits = GlobalAlloc (GHND, (DWORD) nBytes_Bits);
   if (hBits == NULL)
       return;
   else
      lp_Bits = (LPBYTE) GlobalLock (hBits);

   memDC = CreateCompatibleDC(NULL);
   GetDIBits (memDC, hBitmap, 0, bm.bmHeight, (LPVOID) lp_Bits, &BI, DIB_RGB_COLORS);

   hFile = CreateFile (FileName, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN, NULL);

   for (y = 0; y < bm.bmHeight; y++)
   {
#define RBG_SWAP
#ifdef RBG_SWAP
      for (x=0; x < bm.bmWidth; x++)
      {
         _R = (LPBYTE)(lp_Bits + (LONG)(y) * bm.bmWidthBytes + x*3 + 0);
      // _G = (LPBYTE)(lp_Bits + (LONG)(y) * bm.bmWidthBytes + x*3 + 1);
         _B = (LPBYTE)(lp_Bits + (LONG)(y) * bm.bmWidthBytes + x*3 + 2);

         aux  = *_R;
         *_R = *_B;
         *_B = aux;
      }
#endif
      WriteFile (hFile, (LPBYTE)(lp_Bits + (LONG)(y) * bm.bmWidthBytes),  (bm.bmWidth * 3),  &nBytes_Written, NULL);
   }

   CloseHandle (hFile);

   DeleteDC (memDC);
   GlobalUnlock (hBits);
   GlobalFree (hBits);
}

/*-------------------------------------------------------------------------
   The following Functions are taken from the graphics library Bos Taurus.
   Bos Taurus, (c) 2012 by Dr. Claudio Soto <srvet@adinet.com.uy>
---------------------------------------------------------------------------*/

//*********************************************************************************************************************
// _bt_LoadFileFromResources (FileName, TypeResource) ---> Return hGlobalAlloc
//*********************************************************************************************************************
HGLOBAL _bt_HPDF_LoadFileFromResources (TCHAR * FileName, TCHAR * TypeResource)
{
   HRSRC     hResourceData;
   HGLOBAL   hGlobalAlloc,  hGlobalResource;
   LPVOID    lpGlobalAlloc, lpGlobalResource;
   DWORD     nFileSize;

   hResourceData = FindResource (NULL, FileName, TypeResource);
   if (hResourceData == NULL)
       return NULL;

   hGlobalResource = LoadResource (NULL, hResourceData);
   if (hGlobalResource == NULL)
       return NULL;

   lpGlobalResource  = LockResource (hGlobalResource);
   if (lpGlobalResource == NULL)
       return NULL;

   nFileSize = SizeofResource (NULL, hResourceData);

   hGlobalAlloc = GlobalAlloc (GHND, nFileSize);
   if (hGlobalAlloc == NULL)
   {   FreeResource (hGlobalResource);
       return NULL;
   }

   lpGlobalAlloc = GlobalLock (hGlobalAlloc);
   memcpy (lpGlobalAlloc, lpGlobalResource, nFileSize);
   GlobalUnlock (hGlobalAlloc);

   FreeResource (hGlobalResource);

   return hGlobalAlloc;
}


//*********************************************************************************************************************
// _bt_LoadFileFromDisk (FileName) ---> Return hGlobalAlloc
//*********************************************************************************************************************
HGLOBAL _bt_HPDF_LoadFileFromDisk (TCHAR * FileName)
{
   HGLOBAL   hGlobalAlloc;
   LPVOID    lpGlobalAlloc;
   HANDLE    hFile;
   DWORD     nFileSize;
   DWORD     nReadByte;

   hFile = CreateFile (FileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
   if (hFile == INVALID_HANDLE_VALUE)
       return NULL;

   nFileSize = GetFileSize (hFile, NULL);
   if (nFileSize == INVALID_FILE_SIZE)
   {   CloseHandle (hFile);
       return NULL;
   }

   hGlobalAlloc = GlobalAlloc (GHND, nFileSize);
   if (hGlobalAlloc == NULL)
   {   CloseHandle (hFile);
       return NULL;
   }
   lpGlobalAlloc = GlobalLock (hGlobalAlloc);
   ReadFile (hFile, lpGlobalAlloc, nFileSize, &nReadByte, NULL);
   GlobalUnlock (hGlobalAlloc);

   CloseHandle (hFile);

   return hGlobalAlloc;
}


//*******************************************************************************************************
//* _HPDF_LOAD_PNG (hPDF_Doc, cFileName) ---> return Pointer   // load PNG image from Resourse or Disk
//*******************************************************************************************************

/*
typedef void*         HPDF_HANDLE;
typedef HPDF_HANDLE   HPDF_Image;   // void* ptr
typedef HPDF_HANDLE   HPDF_Doc;     // void* ptr
HPDF_LoadPngImageFromFile () ---> return image = void* ptr
HPDF_LoadPngImageFromMem  () ---> return image = void* ptr
*/

extern HPDF_Doc hb_HPDF_Doc_par (int);

HB_FUNC (_HPDF_LOAD_PNG)
{
    TCHAR       *FileName;
    HGLOBAL     hGlobalAlloc;
    LPVOID      lpGlobalAlloc;
    UINT        nSizeGlobalAlloc;
    HPDF_Doc    hpdf_Doc;
    HPDF_Image  image;

    hpdf_Doc  = (HPDF_Doc) hb_HPDF_Doc_par (1);
    FileName  = (TCHAR *)  HMG_parc (2);

    hGlobalAlloc = _bt_HPDF_LoadFileFromResources (FileName, _TEXT("PNG"));

 // if fail: find in disk
    if (hGlobalAlloc == NULL)
        hGlobalAlloc = _bt_HPDF_LoadFileFromDisk (FileName);

    if (hGlobalAlloc == NULL)
    {    hb_ret();  // return Nil
         return;
    }

    nSizeGlobalAlloc = (UINT) GlobalSize(hGlobalAlloc);
    lpGlobalAlloc = GlobalLock (hGlobalAlloc);
        image = HPDF_LoadPngImageFromMem  (hpdf_Doc, (BYTE*)lpGlobalAlloc, nSizeGlobalAlloc);
    GlobalUnlock (hGlobalAlloc);
    GlobalFree (hGlobalAlloc);

    if (image == NULL)
    {   hb_ret();  // return Nil
        return;
    }

    hb_retptr ((void *) image); // return image (void* ptr)
}


//*******************************************************************************************************
//* _HPDF_LOAD_JPG (hPDF_Doc, cFileName) ---> return Pointer   // load PNG image from Resourse or Disk
//*******************************************************************************************************

HB_FUNC (_HPDF_LOAD_JPG)
{
    TCHAR       *FileName;
    HGLOBAL     hGlobalAlloc;
    LPVOID      lpGlobalAlloc;
    UINT        nSizeGlobalAlloc;
    HPDF_Doc    hpdf_Doc;
    HPDF_Image  image;

    hpdf_Doc  = (HPDF_Doc) hb_HPDF_Doc_par (1);
    FileName  = (TCHAR *)  HMG_parc (2);

    hGlobalAlloc = _bt_HPDF_LoadFileFromResources (FileName, _TEXT("JPG"));

 // if fail: find in disk
    if (hGlobalAlloc == NULL)
        hGlobalAlloc = _bt_HPDF_LoadFileFromDisk (FileName);

    if (hGlobalAlloc == NULL)
    {    hb_ret();  // return Nil
         return;
    }

    nSizeGlobalAlloc = (UINT) GlobalSize(hGlobalAlloc);
    lpGlobalAlloc = GlobalLock (hGlobalAlloc);
        image = HPDF_LoadJpegImageFromMem (hpdf_Doc, (BYTE*)lpGlobalAlloc, nSizeGlobalAlloc);
    GlobalUnlock (hGlobalAlloc);
    GlobalFree (hGlobalAlloc);

    if (image == NULL)
    {   hb_ret();  // return Nil
        return;
    }

    hb_retptr ((void *) image); // return image (void* ptr)
}

#pragma ENDDUMP
