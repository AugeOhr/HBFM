
#pragma BEGINDUMP

#include <windows.h>
#include <ShObjIdl.h>
#include <hbapi.h>

#include "dbt.h"
#include "hbapiitm.h"
#include "hbapifs.h"
#include "hbwapi.h"

#include <mgdefs.h>


ITaskbarList3* TBL_SetProgressState(HWND hWnd, TBPFLAG state)
{
   ITaskbarList3* m_pTaskBarlist;
   HRESULT hr;

#if defined(__cplusplus)
   if((hr = CoCreateInstance( CLSID_TaskbarList, 0, CLSCTX_ALL, IID_ITaskbarList3, ( void ** ) &m_pTaskBarlist ) )==S_OK)
#else
   if((hr = CoCreateInstance( &CLSID_TaskbarList, 0, CLSCTX_ALL, &IID_ITaskbarList3, ( void ** ) &m_pTaskBarlist ) )==S_OK)
#endif
   {
      if( (signed) state != -1 )
#if defined(__cplusplus) && !defined(CINTERFACE)
         m_pTaskBarlist->SetProgressState( hWnd, state );
#else
         m_pTaskBarlist->lpVtbl->SetProgressState( m_pTaskBarlist, hWnd, state );
#endif
      return m_pTaskBarlist;
   }

   return NULL;
}

#ifndef _WIN64
   #define GETHWND ( HWND ) hb_parnl( 1 )
#else
   #define GETHWND ( HWND ) hb_parnll( 1 )
#endif

HB_FUNC( TBL_RESET )
{
   TBL_SetProgressState(GETHWND,TBPF_NOPROGRESS);
}

HB_FUNC( TBL_PROCESSING )
{
   TBL_SetProgressState(GETHWND,TBPF_INDETERMINATE);
}

HB_FUNC( TBL_SETPROGRESS )
{
   TBL_SetProgressState(GETHWND,TBPF_NORMAL);
}

HB_FUNC( TBL_SETVALUE )
{
   HWND hWnd = GETHWND;
   ULONGLONG n = hb_parnll( 2 );
   ULONGLONG m = hb_parnll( 3 );
   ITaskbarList3* m_pTaskBarlist = TBL_SetProgressState( GETHWND, (TBPFLAG) -1 );

   if( m_pTaskBarlist )
   {
#if defined(__cplusplus) && !defined(CINTERFACE)
      m_pTaskBarlist->SetProgressValue( hWnd, n, m );
#else
      m_pTaskBarlist->lpVtbl->SetProgressValue( m_pTaskBarlist, hWnd, n, m );
#endif
   }
}

HB_FUNC( TBL_SETERROR )
{
   TBL_SetProgressState( GETHWND, TBPF_ERROR );
}

HB_FUNC( TBL_SETPAUSE )
{
   TBL_SetProgressState( GETHWND, TBPF_PAUSED );
}

#ifndef __XHARBOUR__
   #define ISBYREF( n )          HB_ISBYREF( n )
   #define ISNIL( n )            HB_ISNIL( n )
#endif

HB_FUNC(BMP_FILL)
{
   HWND hWnd;
   HDC  hDC;
   RECT rect;
   HBRUSH hbrush;
   PAINTSTRUCT ps;

   hWnd   = (HWND)    hb_parnl (1);
   GetClientRect(hWnd, &rect);
   hbrush = CreateSolidBrush( (COLORREF) RGB(hb_parvni(2, 1),
                                             hb_parvni(2, 2),
                                             hb_parvni(2, 3)) );
   hDC = BeginPaint (hWnd, &ps);
   FillRect(hDC,&rect,(HBRUSH) hbrush );
   ReleaseDC(hWnd, hDC);
}

/*
   Harbour MiniGUI 1.4 Extended (Build 47)
   added by Grigory Filatov
 */
HB_FUNC( DRAGQUERYFILES )
{
   HDROP hDrop  = ( HDROP ) hb_parnl( 1 );
   int   iFiles = DragQueryFile( hDrop, 0xFFFFFFFF, 0, 0 );
   int   i;
   char  bBuffer[ 250 ];

   hb_reta( iFiles );

   for( i = 0; i < iFiles; i++ )
   {
      DragQueryFile( hDrop, i, ( char * ) bBuffer, 249 );
      hb_storvc( ( char * ) bBuffer, -1, i + 1 );
   }
}

HB_FUNC ( SHELLFILEOPERATION )
{
   SHFILEOPSTRUCT sh;

   sh.hwnd   = (HWND) hb_parnl(1);
   sh.pFrom  = hb_parc(2);
   sh.pTo    = hb_parc(3);
   sh.wFunc  = hb_parnl(4);
   sh.fFlags = hb_parnl(5);
   sh.hNameMappings = 0;
   sh.lpszProgressTitle = NULL;

   hb_retnl( SHFileOperation (&sh) );
}


HB_FUNC( PAINTBKGND )
{
    HWND hwnd;
    HBRUSH brush;
    RECT recClie;
    HDC hdc;

    hwnd  = (HWND) hb_parnl (1);
    hdc   = GetDC (hwnd);

    GetClientRect(hwnd, &recClie);

    if ((hb_pcount() > 1) && (!HB_ISNIL(2)))
    { brush = CreateSolidBrush( RGB(hb_parvni(2, 1),
                                    hb_parvni(2, 2),
                                    hb_parvni(2, 3)) );
      FillRect(hdc, &recClie, brush);
      DeleteObject(brush);
    }
    else
    { brush = (HBRUSH)( COLOR_BTNFACE + 1 );
      FillRect(hdc, &recClie, brush);
    }

    ReleaseDC(hwnd, hdc);
}

HB_FUNC (DEVICECHANGEINFO) // DeviceChangeInfo( wParam, lParam )
{
//   WPARAM wParam = hb_parnl( 1 );
   PDEV_BROADCAST_HDR lpdb = (PDEV_BROADCAST_HDR) hb_parnl( 2 );
//   TCHAR szMsg[80];

   if ( lpdb->dbch_devicetype == DBT_DEVTYP_VOLUME )
   {
      PDEV_BROADCAST_VOLUME lpdbv = (PDEV_BROADCAST_VOLUME) lpdb;
      hb_retnl( lpdbv->dbcv_unitmask );
   } else hb_retnl( 0 );

}

HB_FUNC( PAINTTAB )
{
    HWND hwnd;
    HBRUSH brush;
    RECT recClie;
    HDC hdc;
    UINT  nOffSet;
    UINT  nheight;

    hwnd  = (HWND) hb_parnl (1);
    hdc   = GetDC (hwnd);
    nOffSet = hb_parnl (3);
    nheight = hb_parnl (4);

    GetClientRect(hwnd, &recClie);
    recClie.left  += nOffSet;
    recClie.bottom = nheight;

    if ((hb_pcount() > 1) && (!HB_ISNIL(2)))
    { brush = CreateSolidBrush( RGB(hb_parvni(2, 1),
                                    hb_parvni(2, 2),
                                    hb_parvni(2, 3)) );
      SetBkMode( hdc, 1 );
      SelectObject( hdc, brush);
      FillRect(hdc, &recClie, brush);
      DeleteObject(brush);
    }
    else
    { brush = (HBRUSH)( COLOR_BTNFACE + 1 );
      FillRect(hdc, &recClie, brush);
    }

    ReleaseDC(hwnd, hdc);
}


// http://msdn.microsoft.com/en-us/library/ms684139(VS.85).aspx
typedef BOOL ( WINAPI *LPFN_ISWOW64PROCESS ) ( HANDLE, PBOOL );

/*
 HANDLE WINAPI
    FindFirstChangeNotification( LPCTSTR lpPathName, BOOL bWatchSubtree, DWORD dwNotifyFilter );
*/
HB_FUNC( WAPI_FINDFIRSTCHANGENOTIFICATION )
{
   if( HB_ISCHAR( 1 ) )
   {
      HANDLE handle;
      void   *hText;

      handle = FindFirstChangeNotification( HB_PARSTRDEF( 1, &hText, NULL ),
                                            hbwapi_par_BOOL( 2 ), hbwapi_par_DWORD( 3 ) );
      hb_strfree( hText );

      if ( INVALID_HANDLE_VALUE == handle )
      {
         hbwapi_SetLastError( GetLastError() );

         hb_retptr( NULL );
      }
      else
      {
         hbwapi_ret_raw_HANDLE( handle );
      }
   }
   else
   {
      hb_retptr( NULL );
   }
}

//BOOL FindNextChangeNotification(HANDLE hChangeHandle);
HB_FUNC( WAPI_FINDNEXTCHANGENOTIFICATION )
{
   HANDLE handle = hbwapi_par_raw_HANDLE( 1 );

   if( handle )
   {
      hbwapi_ret_L( FindNextChangeNotification( handle ) );
   }
   else
   {
      hb_retl( HB_FALSE );
   }
}

//BOOL WINAPI FindCloseChangeNotification( HANDLE hChangeHandle );
HB_FUNC( WAPI_FINDCLOSECHANGENOTIFICATION )
{
   HANDLE handle = hbwapi_par_raw_HANDLE( 1 );

   if( handle )
   {
      hbwapi_ret_L( FindCloseChangeNotification( handle ) );
   }
   else
   {
      hb_retl( HB_FALSE );
   }
}

HB_FUNC( INVALID_HANDLE_VALUE )
{
   HANDLE handle = hbwapi_par_raw_HANDLE( 1 );

   if ( NULL != handle )
   {
      hbwapi_ret_L( ( INVALID_HANDLE_VALUE == handle )  );
   }
}

       //GetWindowText2(nHWnd) --> text from control created in another process
HB_FUNC( GETWINDOWTEXT2 )
{
  HWND   hWnd = (HWND)   hb_parnl(1);
  INT    nLen = (INT)    SendMessage(hWnd, WM_GETTEXTLENGTH, 0, 0) + 1;
  LPTSTR Text = (LPTSTR) hb_xgrab(nLen * sizeof(TCHAR));

  SendMessage(hWnd, WM_GETTEXT, nLen, (LPARAM) Text);
  hb_retc(Text);
  hb_xfree(Text);
}


HB_FUNC( CHANGESTYLE )
{
   HWND     hWnd     = ( HWND ) HB_PARNL( 1 );
   LONG_PTR dwAdd    = ( LONG_PTR ) HB_PARNL( 2 );
   LONG_PTR dwRemove = ( LONG_PTR ) HB_PARNL( 3 );
   int      iStyle   = hb_parl( 4 ) ? GWL_EXSTYLE : GWL_STYLE;
   LONG_PTR dwStyle, dwNewStyle;

   dwStyle    = GetWindowLongPtr( hWnd, iStyle );
   dwNewStyle = ( dwStyle & ( ~dwRemove ) ) | dwAdd;

   HB_RETNL( ( LONG_PTR ) SetWindowLongPtr( hWnd, iStyle, dwNewStyle ) );

   SetWindowPos( hWnd, NULL, 0, 0, 0, 0, SWP_FRAMECHANGED | SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER );
}

      // TrackMouseEvent(nHWnd, [nFlags], [nHoverTime]) --> lSuccess
HB_FUNC( TRACKMOUSEEVENT )
{
  TRACKMOUSEEVENT tmi;

  tmi.cbSize      = sizeof(TRACKMOUSEEVENT);
  tmi.dwFlags     = hb_parnidef(2, TME_LEAVE);
  tmi.hwndTrack   = (HWND) hb_parnl(1);
  tmi.dwHoverTime = hb_parnidef(3, HOVER_DEFAULT);

  hb_retl(TrackMouseEvent(&tmi));
}

HB_FUNC( BEGINPAINT )
{
   HWND hWnd = ( HWND ) ( LONG_PTR ) HB_PARNL( 1 );

   if( IsWindow( hWnd ) )
   {
      PAINTSTRUCT ps;

      HB_RETNL( ( LONG_PTR ) BeginPaint( hWnd, &ps ) );

      hb_storclen( ( const char * ) &ps, sizeof( PAINTSTRUCT ), 2 );
   }
   else
      HB_RETNL( ( LONG_PTR ) NULL );
}

HB_FUNC( ENDPAINT )
{
   HWND hWnd         = ( HWND ) ( LONG_PTR ) HB_PARNL( 1 );
   PAINTSTRUCT * pps = ( PAINTSTRUCT * ) hb_parc( 2 );

   if( IsWindow( hWnd ) && pps )
      hb_retl( EndPaint( hWnd, pps ) );
   else
      hb_retl( HB_FALSE );
}


// read-write XLS pure HB
HB_FUNC( WORKSHEET_RC )
{
  const char *cellAddr = hb_parc(1);
  int ii=0, jj, colVal=0;
  while(cellAddr[ii++] >= 'A') {};
  ii--;
  for(jj=0;jj<ii;jj++) colVal = 26*colVal + HB_TOUPPER(cellAddr[jj]) -'A' + 1;
  hb_storni( atoi(cellAddr+ii), 2 );
  hb_storni( colVal, 3 );
}

HB_FUNC( GETICOINDEX )
{
   int nSize = ( HB_ISNUM( 2 ) ? hb_parni( 2 ) : 0 );

   SHFILEINFO sfi = { 0 };

   SHGetFileInfo( hb_parc( 1 ), 0, &sfi, sizeof( SHFILEINFO ), SHGFI_ICON | nSize );

   #ifndef _WIN64
      hb_retnl( ( LONG ) sfi.iIcon );
      HB_STORNL( ( LONG ) ( HICON ) sfi.hIcon, 3 );
   #else
      hb_retnll( ( LONGLONG ) sfi.iIcon );
      HB_STORNLL( ( LONGLONG ) ( HICON ) sfi.hIcon, 3 );
   #endif
}


// BOOL WINAPI DestroyIcon( HICON hIcon )
HB_FUNC( DESTROYICON )
{
   hb_retl( DestroyIcon( ( HICON ) ( LONG ) HB_PARNL( 1 ) ) );
}

#include "FREECORE.C"

#pragma ENDDUMP

*
*
*