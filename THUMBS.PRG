*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\THUMBS.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Function pBarForm()
*+               Function SETXPARENT()
*+               Procedure THUMBS()
*+               Function MausRad()
*+               Procedure Prep4Grid()
*+               Function CalcPos()
*+               Static Procedure DelAllMark()
*+               Static Procedure MarkAllImage()
*+               Static Procedure SetActiveImage()
*+               Static Procedure DoShow()
*+               Static Procedure DoReload()
*+               Static Procedure MarkList()
*+               Static Procedure Paint_Frame_Color()
*+               Static Procedure TroggleMark()
*+               Static Procedure Form_ONGOTFOCUS()
*+               Procedure CreateScreenSplash()
*+               Static Procedure TestBreak()
*+               Procedure StopSplash()
*+               Static Function PaintImage()
*+               Static Procedure Rotate()
*+
*+    Reformatted by Click! 2.05.30 on Aug-25-2020 at  5:17 am
*+
*+--------------------------------------------------------------------

#include "HMG.CH"
#include "hbthread.ch"
#include "Common.CH"
#include "Directry.ch"
#include "Dll.ch"

#define Use_FreeImage .T.
#IFDEF Use_FreeImage
#include "freeimage.ch"
#ENDIF

#define ON_STATUSBAR             .T.
#define Use_BT                   .T.

#define SM_CYCAPTION             4
#define SM_CXBORDER              5
#define SM_CYBORDER              6
#define SM_CXDLGFRAME            7
#define SM_CYDLGFRAME            8

#define SM_CXFRAME               32
#define SM_CYFRAME               33
#define SM_CXSIZEFRAME           SM_CXFRAME
#define SM_CYSIZEFRAME           SM_CYFRAME

#define WM_VSCROLL               0x0115
#define SB_LINEUP                0
#define SB_LINELEFT              0
#define SB_LINEDOWN              1
#define SB_LINERIGHT             1
#define SB_PAGEUP                2
#define SB_PAGELEFT              2
#define SB_PAGEDOWN              3
#define SB_VERT                  1
#define SB_TOP                   6
#define SB_BOTTOM                7

#define STM_SETICON              0x0170
#define STM_GETICON              0x0171
#define STM_SETIMAGE             0x0172
#define STM_GETIMAGE             0x0173
#define STM_MSGMAX               0x0174

#define IMAGE_BITMAP             0
#define IMAGE_ICON               1

#xtranslate GetTitleHeight()     => GetSystemMetrics( SM_CYCAPTION )
#xtranslate GetBorderHeight()    => GetSystemMetrics( SM_CYSIZEFRAME )
#xtranslate GetBorderWidth()     => GetSystemMetrics( SM_CXSIZEFRAME )

#xtranslate END TIMER => //

STATIC aMark     := {}
STATIC cShowForm := ""
STATIC lStop     := .F.
STATIC nHandle
STATIC cLastPath := ""

STATIC hDLL := 0

MEMVAR cImage, cDevice
MEMVAR Win_1, aBroThread, WinLeft, WinRight
MEMVAR _HMG_SYSDATA

*+--------------------------------------------------------------------
*+
*+    Function pBarForm()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure dataviewer()
*+                                   1 - static procedure slideshow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION pBarForm( cFormRun )

LOCAL nRow, nCol, nWide, nHight, nSbHight := GetTitleHeight()
LOCAL nHwnd, nSbHwnd

   IF SP_lPbarRunning() = .T.

   ELSE
      SP_lPbarRunning( .T. )

      nRow := GetProperty( "Win_1", "Row" )
      nCol := GetProperty( "Win_1", "Col" )
      nWide := GetProperty( "Win_1", "ClientAreaWidth" )
      nHight := GetProperty( "Win_1", "ClientAreaHeight" )

      nSbHight += GetBorderHeight()
      //  nSbHight += GetBorderWidth()

#IFDEF ON_STATUSBAR
      nRow += nHight + nSbHight
      nWide -= 550
      nSbHight := 18
#ENDIF
      nCol += 8

      //  AT (GetDesktopHeight()/2 ) , (GetDesktopWidth() - 550) / 2 ;
      //               TOPMOST ;

      DEFINE WINDOW Pbar_Form ;
                 AT nRow, nCol ;
                 WIDTH nWide ;
                 HEIGHT nSbHight ;
                 NOMINIMIZE ;
                 NOMAXIMIZE ;
                 NOSIZE ;
                 NOSYSMENU ;
                 NOCAPTION ;
                 ON RELEASE Nil ;
                 ON PAINT nil ;
                 ON INIT &cFormRun

         @  0,  0 PROGRESSBAR ProgressBar_1 RANGE 0, 100 WIDTH nWide HEIGHT nSbHight         

      END WINDOW

#IFDEF ON_STATUSBAR

      nHwnd := GetProperty( "Pbar_Form", "Handle" )
      nSbHwnd := GetControlHandle( "STATUSBAR", "Win_1" )
      SETPARENT( nHwnd, nSbHwnd )

      //    TBL_SETVALUE(nHwnd, 0, 100)

      nHwnd := GetControlHandle( "ProgressBar_1", "Pbar_Form" )
      nSbHwnd := GetControlHandle( "STATUSBAR", "Win_1" )
      SETPARENT( nHwnd, nSbHwnd )

      //    TBL_SETVALUE(nSbHwnd, 0, 100)

#ENDIF

      Pbar_Form.ProgressBar_1.value := 0
      Pbar_Form.Activate

      SP_lPbarRunning( .F. )
   ENDIF

RETURN nil

*+--------------------------------------------------------------------
*+
*+    Function SETXPARENT()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SETXPARENT( hWndChild, hWndNewParent )

   HMG_CallDLL( "USER32.DLL",, "SetParent", hWndChild, hWndNewParent )
RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Procedure THUMBS()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE THUMBS( cPath, aDir )

LOCAL nMax, fname, clone, cThumbsFile, nMode := 2
LOCAL ii, xx, yy, iMax, yPicMax, xPicMax, nRow, nCol, cMacro, nCount := 0
LOCAL nStart, nStop, nIndex := 0
LOCAL FI_hBitmap1_aux := 0
LOCAL FI_hBitmap1, Hwnd, hBitmap, nHeight, cTemp, aTempDir
LOCAL cText           := ""
LOCAL nDeskWide       := GETDESKTOPWIDTH()
LOCAL nDeskHigh       := GETDESKTOPHEIGHT()

PUBLIC cImage       := "", cDevice := ""
PUBLIC _HMG_SYSDATA

   /*********************************************
   CHECK TYPE SOFT ;
           cImage AS CHARACTER, ;
           cDevice AS CHARACTER, ;
           fname AS CHARACTER, ;
           cThumbsFile AS CHARACTER, ;
           cMacro AS CHARACTER, ;
           cTemp AS CHARACTER, ;
           cText AS CHARACTER, ;
           aTempDir AS ARRAY, ;
           FI_hBitmap1_aux AS NUMERIC, ;
           FI_hBitmap1 AS NUMERIC, ;
           Hwnd AS NUMERIC, ;
           nMax AS NUMERIC, ;
           nMode AS NUMERIC, ;
           ii AS NUMERIC, ;
           xx AS NUMERIC, ;
           yy AS NUMERIC, ;
           iMax AS NUMERIC, ;
           yPicMax AS NUMERIC, ;
           xPicMax AS NUMERIC, ;
           nRow AS NUMERIC, ;
           nCol AS NUMERIC, ;
           nCount AS NUMERIC, ;
           nStart AS NUMERIC, ;
           nStop AS NUMERIC, ;
           nIndex AS NUMERIC, ;
           nHeight AS NUMERIC, ;
           clone AS NUMERIC
*********************************************/

   aMark := {}

   IF EMPTY( cPath )
      MsgInfo( "missing Path" )
      RETURN
   ELSE
      IF cLastPath <> cPath
         cLastPath := cPath
         cTemp := GetTempFolder()
         aTempDir := DIRECTORY( cTemp + "FI_*.BMP" )
         iMax := LEN( aTempDir )
         FOR ii := 1 TO iMax
            FERASE( cTemp + aTempDir[ ii ] [ F_NAME ] )
         NEXT
      ENDIF
   ENDIF

   IF EMPTY( aDir )
      //  MsgInfo("missing aDir")
      //  RETURN
      //  aDir := DIRECTORY( cPath + "*.*" )
      aDir := HB_DirScanM( cPath, { "*.bmp", "*.jpg", "*.png", "*.gif", "*.tif", "*.wmf", "*.emf", "*.cur" }, "", .F. )
      aDir := ASORT( aDir,,, { | aX, aY | aX[ 1 ] < aY[ 1 ] } )
   ENDIF

   nMax := LEN( aDir )
   IF EMPTY( nMax )
      aDir := HB_DirScanM( cPath, { "*.bmp", "*.jpg", "*.png", "*.gif", "*.tif", "*.wmf", "*.emf", "*.cur" }, "", .F. )
      aDir := ASORT( aDir,,, { | aX, aY | aX[ 1 ] < aY[ 1 ] } )
      nMax := LEN( aDir )
   ENDIF

   //   xPicMax := ROUND( nDeskWide / 128, 0 )
   //   yPicMax := ROUND( ( nMax / xPicMax ), 0 )
   xPicMax := INT( nDeskWide / 128 )
   yPicMax := INT( nMax / xPicMax )

   //    IF ( yPicMax * xPicMax ) < nMax
   yPicMax += 1
   //    ENDIF

   nHeight := ( yPicMax * 128 ) + 50 + 40

#IFDEF Use_FreeImage
   IF FILE( 'FreeImage.Dll' ) .OR. FILE( 'FreeImage64.Dll' )
      FREE_Initialise()
      //  MsgInfo( Var2char( FREE_GetVersion() ) )
   ELSE
      MsgInfo( "Can't found the FreeImage.Dll" )
      RETURN
   ENDIF
#ENDIF

   nStart := SECONDS()

   DEFINE WINDOW THUMBSWIN ;
              AT 0, 0 ;
              WIDTH nDeskWide ;
              HEIGHT MIN( nDeskHigh, nHeight ) ;
              VIRTUAL WIDTH nDeskWide + 1 ;
              VIRTUAL HEIGHT nDeskHigh + 1 ;
              TITLE "Thumbs View" ;
              ICON "MYTHUMB32" ;
              ON INIT Nil ;
              ON RELEASE Nil ;
              NOSIZE ;
              NOMAXIMIZE ;
              NOMINIMIZE ;
              ON PAINT Nil ;
              BACKCOLOR Nil                                           // SP_nColor1()

      DEFINE CONTEXT MENU OF THUMBSWIN
         MENUITEM "rotate &right" IMAGE "MYROTATER16" ACTION Rotate( "R", cPath, aDir )
         MENUITEM "rotate &left" IMAGE "MYROTATEL16" ACTION Rotate( "L", cPath, aDir )
         SEPARATOR
      END MENU

      @  2, 000 BUTTON BACKEXIT CAPTION "&Exit"   PICTURE "MYEXIT" LEFT ACTION THUMBSWIN.Release TOOLTIP "close this Windows" WIDTH 90 HEIGHT 46 NOTABSTOP             
      @  2, 100 BUTTON MarkAll CAPTION "Mark&All" PICTURE "MYCHECK16" LEFT ACTION MarkAllImage( aDir ) TOOLTIP "mark all item" WIDTH 90 HEIGHT 46 NOTABSTOP            
      @  2, 200 BUTTON DelMark CAPTION "&DelMark" PICTURE "MYUNCHECK16" LEFT ACTION DelAllMark( aDir ) TOOLTIP "un-mark all item" WIDTH 90 HEIGHT 46 NOTABSTOP         
      @  2, 300 BUTTON ViewPic CAPTION "F3 &View" PICTURE "" LEFT ACTION DoShow( cPath, aDir ) TOOLTIP "view full-Size" WIDTH 90 HEIGHT 46 NOTABSTOP                   

      ALTD()
      //  SetCursorWait("Win_1",.T.)
      SetCursorWait( "WinLeft", .T. )
      SetCursorWait( "WinRight", .T. )
      //  SetCursorWait("THUMBSWIN",.T.)

      FOR xx := 1 TO yPicMax
         YY := 1
         FOR YY := 1 TO xPicMax

            nCount ++
            cMacro := STRZERO( nCount, 5 )
            cImage := "Image_" + cMacro
            cDevice := "Device_" + cMacro

            nRow := 50 + ( ( xx - 1 ) * 128 )
            nCol := 02 + ( ( yy - 1 ) * 128 )

#IFDEF Use_BT
            // *************************
            // fname := cPath + aDir[ nCount ] [ 1 ]
            // * nHandle := FREE_Load( FREE_GetFileType( fname, 0 ), fname, 0 )
            //
            // DEFINE WINDOW &cDevice ;
            //            PARENT THUMBSWIN ;
            //            AT nRow, nCol ;
            //            WIDTH 127 HEIGHT 127 ;
            //            PANEL ;
            //            NOCAPTION ;
            //            ON PAINT PaintImage( ThisWindow.handle, fname ) ;
            //            BACKCOLOR SP_nColor1()
            // END WINDOW
            //
            // * ON INIT DRAWHBMP( ThisWindow.handle, nHandle,0) ;
            // * DRAWHBMP(ThisWindow.handle, nHandle,0)
            // * FREE_Unload(nHandle)
            // *************************

            DEFINE IMAGE &cImage
               ROW nRow                                               // 1
               COL nCol                                               // 1
               PICTURE nil                                            // cPath + aDir[ 1 ] [ 1 ]
               ONCLICK SetActiveImage( This.Name )                    // DoShow( This.Name, cPath, aDir )
               WIDTH 128
               HEIGHT 128
               VISIBLE .T.
               STRETCH .F.
            END IMAGE

            fname := cPath + aDir[ nCount ] [ F_NAME ]
            cThumbsFile := GetTempFolder() + "FI_" + cFileNoExt( fname ) + ".bmp"

            IF FILE( cThumbsFile )
               SetProperty( "THUMBSWIN", cImage, "PICTURE", cThumbsFile )
            ELSE
#IFDEF Use_FreeImage
               FI_hBitmap1_aux := FREE_Load( FREE_GetFileType( fname, 0 ), fname, 0 )

               IF !EMPTY( FI_hBitmap1_aux )
                  clone := FREE_Clone( FI_hBitmap1_aux )
                  FREE_Unload( FI_hBitmap1_aux )

                  //  FI_hBitmap1 := FREE_Rescale( clone, 128, 128, FILTER_BICUBIC )
                  FI_hBitmap1 := Free_MakeThumbnail( clone, 128, TRUE )
                  FREE_Unload( clone )

                  //  FI_hBitmap1 := Free_MakeThumbnail( FI_hBitmap1_aux, 128, TRUE )
                  //  FREE_Unload( FI_hBitmap1_aux )

                  // Clipboard
                  // FreeImage_Copy(FI_hBitmap1,0,0,128,128)
                  // FREE_Unload( FI_hBitmap1 )

                  FREE_Save( FIF_BMP, FI_hBitmap1, cThumbsFile, BMP_DEFAULT )
                  SetProperty( "THUMBSWIN", cImage, "PICTURE", cThumbsFile )
                  FREE_Unload( FI_hBitmap1 )
                  //  FERASE( cThumbsFile )

                  // *******************
                  // if !EMPTY(FI_hBitmap1)
                  //    Hwnd := GetControlHandle( cImage, "THUMBSWIN" )
                  //
                  //    PaintImage(Hwnd, FI_hBitmap1)
                  //    DRAWHBMP(Hwnd, FI_hBitmap1,0)
                  //
                  //    hBitmap := FREE_WINCONVTODIB(FI_hBitmap1)
                  //    DRAWHBMP(Hwnd, hBitmap,0)
                  //    *PaintImage(Hwnd, hBitmap)
                  //
                  //    SetProperty( "THUMBSWIN", cImage, "HBITMAP", hBitmap )
                  //    SetProperty( "THUMBSWIN", cImage, "PICTURE", hBitmap )
                  //
                  //    * DRAWHBMP(Hwnd, hBitmap,0)
                  //    SendMessage(Hwnd, STM_SETIMAGE, IMAGE_BITMAP, hBitmap)
                  //    ReDrawWindow(Hwnd)
                  //    * BT_HMGSetImage( "THUMBSWIN", cImage, hBitmap )
                  // ENDIF
                  // *******************
               ENDIF
#ELSE

               FI_hBitmap1_aux := BT_BitmapLoadFile( cPath + aDir[ nCount ] [ F_NAME ] )
               FI_hBitmap1 := BT_BitmapCopyAndResize( FI_hBitmap1_aux, 128, 128, NIL, BT_RESIZE_HALFTONE )                                  // 74
               //                FI_hBitmap1 := BT_BitmapCopyAndResize( FI_hBitmap1_aux, 128, 128, NIL, BT_RESIZE_COLORONCOLOR )  // 70
               //                FI_hBitmap1 := BT_BitmapCopyAndResize( FI_hBitmap1_aux, 128, 128, NIL, BT_RESIZE_BILINEAR )

               BT_BitmapRelease( FI_hBitmap1_aux )
               BT_HMGSetImage( "THUMBSWIN", cImage, FI_hBitmap1 )
               BT_BitmapSaveFile( FI_hBitmap1, cThumbsFile, BT_FILEFORMAT_BMP )

               //  MarkList( cMacro, aDir, .T. )
               //  DoMethod("THUMBSWIN", cImage, "SetFocus")
#ENDIF
            ENDIF
#ELSE
            DEFINE WINDOW &cDevice ;
                       PARENT THUMBSWIN ;
                       AT nRow, nCol ;
                       WIDTH 127 HEIGHT 127 ;
                       PANEL ;
                       NOCAPTION ;
                       ON PAINT Paint_Frame_Color( ThisWindow.Name ) ;
                       BACKCOLOR SP_nColor1()
            END WINDOW

            DEFINE IMAGE &cImage
               PARENT &cDevice
               ROW 1
               COL 1
               PICTURE cPath + aDir[ nCount ] [ 1 ]
               ONCLICK SetActiveImage( This.Name )                    // DoShow( This.Name, cPath, aDir )
               WIDTH 124
               HEIGHT 124
               VISIBLE .T.
               STRETCH .F.
            END IMAGE
            MarkList( cMacro, aDir )
            // DoMethod("THUMBSWIN", cDevice, "SetFocus")

#ENDIF
            SetProperty( "Pbar_Form", "ProgressBar_1", "Value", CalcPos( nCount, nMax ) )
            TBL_SETVALUE( ThisWindow.Handle, CalcPos( nCount, nMax ), 100 )

            //  cText := STR( nCount ) + "/" + LTRIM( STR( nMax ) )
            //  SbarText( cText )

            DO EVENTS
            IF nCount >= nMax
               EXIT
            ENDIF
         NEXT
         IF nCount >= nMax
            EXIT
         ENDIF
      NEXT

   END WINDOW

   nStop := SECONDS() - nStart
   //    MsgInfo( STR( nStop ) + " Sec.", STR( LEN( aMark ) ) )
   THUMBSWIN.TITLE := "Thumbs View " + STR( nStop ) + " Sec."

   IF nHeight < nDeskHigh
      THUMBSWIN.VScroll := .F.
   ENDIF

#IFDEF Use_FreeImage
#ELSE
   DelAllMark( aDir )
#ENDIF

   TBL_SETVALUE( ThisWindow.Handle, 0, 100 )
   TBL_RESET( ThisWindow.Handle )

   SetProperty( "Pbar_Form", "ProgressBar_1", "Value", 0 )
   Domethod( "Pbar_Form", "ProgressBar_1", "Release" )
   Domethod( "Pbar_Form", "Release" )

   // SetCursorWait("THUMBSWIN",.F.)
   // SetCursorWait("Win_1",.F.)
   SetCursorWait( "WinLeft", .F. )
   SetCursorWait( "WinRight", .F. )

   cText := STR( nStop ) + " Sec. " + STR( nStop / nMax ) + " Sec./Rec."
   SbarText( cText )

   //    ON KEY ESCAPE OF THUMBSWIN ACTION THUMBSWIN.Release
   ON KEY SPACE OF THUMBSWIN ACTION TroggleMark( aDir )
   ON KEY RETURN OF THUMBSWIN ACTION DoShow( cPath, aDir )
   ON KEY F3 OF THUMBSWIN ACTION DoShow( cPath, aDir )                // TOOLTIP "also ENTER"

   ON KEY PRIOR OF THUMBSWIN ACTION SendMessage( THUMBSWIN.Handle, WM_VSCROLL, SB_PAGEUP, 0 )
   ON KEY NEXT OF THUMBSWIN ACTION SendMessage( THUMBSWIN.Handle, WM_VSCROLL, SB_PAGEDOWN, 0 )
   ON KEY UP OF THUMBSWIN ACTION SendMessage( THUMBSWIN.Handle, WM_VSCROLL, SB_LINEUP, 0 )
   ON KEY DOWN OF THUMBSWIN ACTION SendMessage( THUMBSWIN.Handle, WM_VSCROLL, SB_LINEDOWN, 0 )

   CREATE EVENT PROCNAME MausRad() HWND THUMBSWIN.HANDLE STOREINDEX nIndex
   EventProcessMouseMessage( nIndex, .T. )

   SP_lPbarRunning( .F. )

   CENTER WINDOW THUMBSWIN
   ACTIVATE WINDOW THUMBSWIN

   EventRemove( nIndex )

#IFDEF Use_FreeImage
   FREE_Deinitialise()
#ENDIF

   //   MsgInfo( STR( LEN( aMark ) ) + " marked" )
   Prep4Grid( aDir )

RETURN

*+--------------------------------------------------------------------
*+
*+    Function MausRad()
*+
*+--------------------------------------------------------------------
*+
FUNCTION MausRad()

LOCAL nHWnd   := EventHWND()
LOCAL nMsg    := EventMSG()
LOCAL nWParam := EventWPARAM()
LOCAL nLParam := EventLPARAM()

   DO CASE
      CASE nMsg == WM_MOUSEWHEEL
         IF nHWnd != 0
            IF HIWORD( nWParam ) == 120
               IF GetScrollPos( nHWnd, SB_VERT ) < 25
                  SendMessage( nHWnd, WM_VSCROLL, SB_TOP, 0 )
               ELSE
                  SendMessage( nHWnd, WM_VSCROLL, SB_PAGEUP, 0 )
               ENDIF
            ELSE
               IF GetScrollPos( nHWnd, SB_VERT ) >= GetScrollRangeMax( nHWnd, SB_VERT ) - 10
                  SendMessage( nHWnd, WM_VSCROLL, SB_BOTTOM, 0 )
               ELSE
                  SendMessage( nHWnd, WM_VSCROLL, SB_PAGEDOWN, 0 )
               ENDIF
            ENDIF
         ENDIF
   ENDCASE

RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Procedure Prep4Grid()
*+
*+    Called from ( thumbs.prg )   1 - procedure thumbs()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE Prep4Grid( aDir )

LOCAL i, iMax, cFile, aSelect := {}

   iMax := LEN( aMark )
   FOR i := 1 TO iMax
      IF !EMPTY( VAL( aMark[ i ] ) )
         cFile := aDir[ VAL( aMark[ i ] ) ] [ F_NAME ]
         AADD( aSelect, cFile )
      ENDIF
   NEXT
   IF !EMPTY( aSelect )
      MarkFromThumbs( aSelect )
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Function CalcPos()
*+
*+    Called from ( ado.prg )   2 - static function getxlsgrid()
*+                                   2 - function adoxlsxwrite()
*+                ( export.prg )   1 - static function mywritesdf()
*+                                   1 - static function mywritehbxls()
*+                ( hbevery.prg )   2 - static function doeverything()
*+                ( hbftp.prg )   1 - static function doprogress()
*+                ( modistru.prg )   1 - static procedure ongo_export()
*+                                   1 - static function writeado2sdf()
*+                ( phone2.prg )   2 - static procedure dotreerecursiv()
*+                                   2 - static procedure docopysingle()
*+                ( thumbs.prg )   2 - procedure thumbs()
*+
*+--------------------------------------------------------------------
*+
FUNCTION CalcPos( nValue, iMax )

LOCAL nRet   := 0
LOCAL nEvery
LOCAL xScale

   IF iMax < 100
      nEvery := 100 / iMax
      nRet := nValue * nEvery
   ELSE
      nEvery := INT( iMax / 100 )
      xScale := iMax * nEvery                                         // Scale to 100%
      nRet := iMax / xScale * nValue
   ENDIF

RETURN ROUND( nRet, 0 )

*+--------------------------------------------------------------------
*+
*+    Static Procedure DelAllMark()
*+
*+    Called from ( thumbs.prg )   2 - procedure thumbs()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DelAllMark( aDir )

LOCAL i, iMax := LEN( aDir )
LOCAL cNo, lShow := .T.

   // reset all
   aMark := {}

   FOR i := 1 TO iMax
      cNo := STRZERO( i, 5 )
      AADD( aMark, cNo )
      MarkList( cNo, aDir, lShow )
   NEXT
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure MarkAllImage()
*+
*+    Called from ( thumbs.prg )   1 - procedure thumbs()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE MarkAllImage( aDir )

LOCAL i, iMax := LEN( aDir )
LOCAL cNo, lShow := .T.

   // reset all
   aMark := {}

   FOR i := 1 TO iMax
      cNo := STRZERO( i, 5 )
      MarkList( cNo, aDir, lShow )
   NEXT
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SetActiveImage()
*+
*+    Called from ( thumbs.prg )   2 - procedure thumbs()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SetActiveImage( cImage )

   DoMethod( "THUMBSWIN", cImage, "SetFocus" )
   cShowForm := cImage
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoShow()
*+
*+    Called from ( thumbs.prg )   3 - procedure thumbs()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoShow( cPath, aDir )

LOCAL cNo
LOCAL cFile

   IF !EMPTY( cShowForm )
      cNo := STRTRAN( cShowForm, "Image_", "" )
      cFile := cPath + aDir[ VAL( cNo ) ] [ 1 ]
      Image_Edit( cFile )
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoReload()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoReload()

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure MarkList()
*+
*+    Called from ( thumbs.prg )   1 - procedure thumbs()
*+                                   1 - static procedure delallmark()
*+                                   1 - static procedure markallimage()
*+                                   1 - static procedure trogglemark()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE MarkList( cNo, aDir, lShow )

LOCAL nPosi, hWnd, cForm
LOCAL aColor
LOCAL hBitmap, hDC, BTstruct
LOCAL nTypeText, nAlingText, nOrientation
LOCAL cText, lMark

   DEFAULT lShow TO .F.

   nPosi := ASCAN( aMark, { | e | e = cNo } )
   IF nPosi > 0
      ADEL( aMark, nPosi )
      ASIZE( aMark, LEN( aMark ) - 1 )
      aColor := BLACK
      lMark := .F.
      cText := "unmark"
   ELSE
      AADD( aMark, cNo )
      aColor := RED                                                   // GREEN
      lMark := .T.
      cText := "marked"
   ENDIF

   IF lShow = .T.
#IFDEF Use_BT
      cForm := "Image_" + cNo
      hBitmap := BT_HMGGetImage( "THUMBSWIN", cForm )

      hDC := BT_CreateDC( hBitmap, BT_HDC_BITMAP, @BTstruct )
      //   nTypeText    := BT_TEXT_TRANSPARENT + BT_TEXT_BOLD
      //   nAlingText   := BT_TEXT_LEFT + BT_TEXT_BASELINE
      //   nOrientation := 0
      //   BT_DrawText (hDC, 64, 2, cText, "Times New Roman", 18, aColor, WHITE, nTypeText, nAlingText, nOrientation)

      BT_DrawRectangle( hDC, 1, 1, 126, 126, aColor, 2 )

      BT_DeleteDC( BTstruct )
      BT_ClientAreaInvalidateAll( "THUMBSWIN" )

      hWnd := GetControlHandle( cForm, "THUMBSWIN" )
      InvalidateRect( hWnd, 0 )
#ELSE
      cForm := "Device_" + cNo
      Paint_Frame_Color( cForm )
      hWnd := GetFormHandle( cForm )
      InvalidateRect( hWnd, 0 )
#ENDIF

   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure Paint_Frame_Color()
*+
*+    Called from ( thumbs.prg )   1 - procedure thumbs()
*+                                   1 - static procedure marklist()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Paint_Frame_Color( cForm )

LOCAL hWnd   := GetFormHandle( cForm )
LOCAL aColor
LOCAL cNo    := STRTRAN( cForm, "Device_", "" )
LOCAL nPosi

   nPosi := ASCAN( aMark, { | e | e = cNo } )
   IF nPosi > 0
      aColor := RED                                                   // GREEN
   ELSE
      aColor := BLACK
   ENDIF
   BMP_FILL( hwnd, aColor )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure TroggleMark()
*+
*+    Called from ( thumbs.prg )   1 - procedure thumbs()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE TroggleMark( aDir )

LOCAL cNo

   IF !EMPTY( cShowForm )
      cNo := STRTRAN( cShowForm, "Image_", "" )
      //  DISABLE WINDOW EVENT OF THUMBSWIN
      MarkList( cNo, aDir, .T. )
      //  ENABLE WINDOW EVENT OF THUMBSWIN
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure Form_ONGOTFOCUS()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Form_ONGOTFOCUS( cForm )

LOCAL i   := GetLastActiveControlIndex()
LOCAL cNo := STRTRAN( cForm, "Device_", "" )
   Msginfo( cNo )
RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure CreateScreenSplash()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE CreateScreenSplash( cFormRun, aPos, aSize, cVersion, luseParameter )

LOCAL hBitmap, Image_Width, Image_Height, Image_BackColor
LOCAL nDelaySeconds   := 7
LOCAL nAnimateSeconds := 2

   IF HMG_GetImageInfo( "MYSPLASH", @Image_Width, @Image_Height, @Image_BackColor ) == .F.
      MsgHMGError( "File Opening Error. Program Terminated" )
   ENDIF

   lStop := .F.

   DEFINE WINDOW SplashForm ;
              AT 0, 0 ;
              WIDTH Image_Width HEIGHT Image_Height ;
              TITLE 'DEMO4' ;
              NOCAPTION ;
              NOSYSMENU ;
              NOSIZE ;
              NOMINIMIZE ;
              NOMAXIMIZE ;
              TOPMOST ;
              BACKCOLOR Image_BackColor ;
              ON INIT &cFormRun

      SET WINDOW SplashForm TRANSPARENT TO COLOR Image_BackColor

      @ 10, 00 IMAGE Image_1 PICTURE "MYSPLASH" ON CLICK MsgInfo( "Splash Image" ) WIDTH Image_Width HEIGHT Image_Height // STRETCH         
      // @ 20, 10 LABEL Label_1 VALUE "The Power of HMG" WIDTH Image_Width - 20 HEIGHT 50 TRANSPARENT CENTERALIGN FONT "Times New Roman" SIZE 36 FONTCOLOR NAVY
      // @ 76, 10 PROGRESSBAR ProgressBar_1 RANGE 0, 1 WIDTH Image_Width - 20 HEIGHT 20

      @ Image_Height - 4, 0 PROGRESSBAR ProgressBar_1 RANGE 0, 1 WIDTH Image_Width HEIGHT 3         
      SET PROGRESSBAR ProgressBar_1 OF SplashForm ENABLE MARQUEE UPDATED 10
      DEFINE TIMER Timer_1 INTERVAL 10 ACTION { || TestBreak( ThisWindow.Name ) }
   END TIMER

   END WINDOW

   SetCursorWait( "SplashForm", .T. )

   ON KEY ESCAPE OF SplashForm ACTION Domethod( "SplashForm", "Release" )
   CENTER WINDOW SplashForm
   ACTIVATE WINDOW SplashForm

   SetCursorWait( "SplashForm", .F. )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure TestBreak()
*+
*+    Called from ( thumbs.prg )   1 - procedure createscreensplash()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE TestBreak()

   IF lStop = .T.
      Domethod( "SplashForm", "Timer_1", "Release" )
      Domethod( "SplashForm", "Release" )
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure StopSplash()
*+
*+    Called from ( fmgrid.prg )   1 - procedure fill1stgrid()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE StopSplash()

   lStop := .T.
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function PaintImage()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION PaintImage( nFormHandle, nFreeHandle )                // fname)

LOCAL pps, hDC
LOCAL nWidth := 128, nHeight := 128

#IFDEF Use_FreeImage
   // LOCAL nFreeHandle := FREE_Load( FREE_GetFileType( fname, 0 ), fname, 0 )

   hDC := BeginPaint( nFormHandle, @pps )

   FREE_WinDraw( nFreeHandle, hDC, 0, 0, nHeight, nWidth )

   EndPaint( nFormHandle, pps )

   InvalidateRect( nFormHandle, 0 )

   FREE_Unload( nFreeHandle )
#ENDIF
RETURN 0

*+--------------------------------------------------------------------
*+
*+    Static Procedure Rotate()
*+
*+    Called from ( thumbs.prg )   2 - procedure thumbs()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Rotate( cLR, cPath, aDir )

LOCAL cNo, cFile, nRad, cThumbsFile
LOCAL handle, clone, new_handle

   IF !EMPTY( cShowForm )
      cNo := STRTRAN( cShowForm, "Image_", "" )
      cFile := cPath + aDir[ VAL( cNo ) ] [ 1 ]
#IFDEF Use_FreeImage

      handle := FREE_Load( FREE_GetFileType( cFile, 0 ), cFile, 0 )

      IF !EMPTY( handle )
         clone := FREE_Clone( handle )
         FREE_Unload( handle )

         IF cLR = "L"
            nRad := 90
         ELSE
            nRad := - 90
         ENDIF

         IF !( ( new_handle := FREE_RotateClassic( clone, nRad ) ) == Nil )
            FREE_Unload( clone )
            handle := new_handle

            cThumbsFile := GetTempFolder() + "FI_" + cFileNoExt( cFile ) + ".bmp"
            IF FILE( cThumbsFile )
               FERASE( cThumbsFile )
            ENDIF

            FREE_Save( FIF_BMP, handle, cFile, BMP_DEFAULT )
            SetProperty( "THUMBSWIN", cShowForm, "PICTURE", cFile )
            FREE_Unload( handle )
         ENDIF
      ENDIF
#ENDIF

   ENDIF

RETURN

*+ EOF: THUMBS.PRG