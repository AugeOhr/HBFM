*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\VIEWER.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Procedure TXT_Edit()
*+               Static Procedure TXTRelease()
*+               Procedure RTF_Edit()
*+               Static Procedure RTFRelease()
*+               Function Image_Edit()
*+               Static Procedure ImageRelease()
*+               Procedure SlideshowEnd()
*+               Static Procedure ViewRotate()
*+               Static Function SaveView()
*+               Function Get_FIF()
*+               Static Procedure DoTXTResize()
*+               Static Procedure DoRTFResize()
*+               Static Procedure DoBMPResize()
*+               Procedure ShowPDF()
*+               Procedure DoPDFHelp()
*+               Static Procedure DoPDFResize()
*+               Static Procedure DoPDFSearch()
*+               Static Procedure DoSpaceKey()
*+               Static Procedure SearchRTF()
*+               Static Procedure SearchText()
*+               Static Procedure Dummy_Text()
*+               Static Procedure FindReplRTFProc()
*+               Static Procedure MoveInRTF()
*+               Static Procedure FindReplTXTProc()
*+               Static Procedure MoveInTXT()
*+               Static Procedure OnChanged()
*+               Function ShowRowCol()
*+               Static Function RTF_RowCol()
*+               Function PictInfo()
*+               Static Procedure ListJPEGData()
*+               Static Function FindJPEGMarker()
*+               Static Function PaintWindow()
*+               Static Function Zoom()
*+
*+    Reformatted by Click! 2.05.35 on Oct-13-2020 at  4:43 am
*+
*+--------------------------------------------------------------------

#include "HMG.CH"
#include "common.CH"

#define Use_FreeImage .T.
#IFDEF Use_FreeImage
#include "freeimage.ch"
#ENDIF
#include 'Directry.ch'        // Directory Array Definitions
#include 'FileIO.ch'          // Low-Level File Access Definitions

#define SOI_MARKER            chr(255) + chr(216)     // FFD8 -- Start Of Image Marker
#define EOI_MARKER            chr(255) + chr(217)     // FFD9 -- End Of Image Marker
#define JFIF_MARKER           chr(255) + chr(224)     // FFE0 -- JFIF ==> JPEG File Interchange Format Marker
#define EXIF_MARKER           chr(255) + chr(225)     // FFE1 -- EXIF ==> Extended (TIFF) Interchange Format Marker
#define JFIF_SIGNATURE        "JFIF" + chr(0)
#define EXIF_SIGNATURE        "Exif" + chr(0) + chr(0)

#define WM_USER               1024
#define EM_LINEINDEX          187
#define EM_LINEFROMCHAR       201
#define EM_SCROLLCARET        ( WM_USER + 49 )
#define EM_EXLINEFROMCHAR     ( WM_USER + 54 )

#define BMP_INFO_WIDTH        0
#define BMP_INFO_HEIGHT       1
#define BMP_INFO_BITSPIXEL    2

#define OFFSET_DLG            30

STATIC cLastSeek  := ""
STATIC cReplace   := ""
STATIC lDown      := .T.
STATIC lWholeWord := .F.
STATIC lMatchCase := .F.
STATIC lChanged   := .F.

STATIC nKoef := 1
// STATIC nShowX     := 0
// STATIC nShowY     := 0

MEMVAR _HMG_SYSDATA, lActiveMain, nGridFocus

*+--------------------------------------------------------------------
*+
*+    Procedure TXT_Edit()
*+
*+    Called from ( fmgrid.prg )   4 - static procedure dataviewer()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE TXT_Edit( cFile, lEdit )

LOCAL nIndex := 0
LOCAL cMemo  := " "

STATIC lRunning := .F.

   DEFAULT lEdit TO .F.

   IF CHR( 204 ) $ cFile
      MsgInfo( "unknow sign in file " + CRLF + cFile, "Error CHR(204)" )
      RETURN
   ENDIF

   IF lRunning = .T.
      RETURN
   ENDIF
   lRunning := .T.

   lActiveMain := .F.
   lChanged := .F.

   SetCursorWait( "WinLeft", .T. )
   SetCursorWait( "WinRight", .T. )
   DO EVENTS

   cMemo := HB_MEMOREAD( cFile )

   DEFINE WINDOW TXTEdit ;
         AT 240, 384 ;
         WIDTH 800 ;
         HEIGHT 600 ;
         TITLE cFile ;
         ON SIZE DoTXTResize( ThisWindow.Name, "TXTCtrl" ) ;
         ON MAXIMIZE DoTXTResize( ThisWindow.Name, "TXTCtrl" ) ;
         ON RELEASE TXTRelease( lEdit, cFile ) ;
         BACKCOLOR SP_nColor1()

      DEFINE STATUSBAR PARENT TXTEdit
STATUSITEM "TXTCtrl()" WIDTH 400
      END STATUSBAR

      DEFINE EDITBOX TXTCtrl
         ROW 10
         COL 10
         WIDTH 760
         HEIGHT 520
         VALUE cMemo
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .T.
         VISIBLE .T.
         READONLY !lEdit
         HSCROLLBAR lEdit
         VSCROLLBAR .T.
         DISABLEDBACKCOLOR SP_nColor13()
         DISABLEDFONTCOLOR SP_nColor14()
         BACKCOLOR SP_nColor5()
         FONTCOLOR SP_nColor6()
         ONCHANGE OnChanged()
      END EDITBOX

   END WINDOW

   SetCursorWait( "WinLeft", .F. )
   SetCursorWait( "WinRight", .F. )
   DO EVENTS

   ON KEY CONTROL + F OF TXTEdit ACTION SearchText( "TXT" )
   ON KEY F3 OF TXTEdit ACTION SearchText( "TXT" )
   ON KEY ESCAPE OF TXTEdit ACTION TXTEdit.Release

   CREATE EVENT PROCNAME ShowRowCol("TXTEdit","TXTCtrl") HWND TXTEdit.TXTCtrl.HANDLE STOREINDEX nIndex
   EventProcessAllHookMessage( nIndex, .T. )

   CENTER WINDOW TXTEdit
   TXTEdit.TXTCtrl.setfocus()
   ACTIVATE WINDOW TXTEdit

   cMemo := " "
   lRunning := .F.
   lActiveMain := .T.
   EventRemove( nIndex )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure TXTRelease()
*+
*+    Called from ( viewer.prg )   1 - procedure txt_edit()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE TXTRelease( lEdit, cFile )

   IF lEdit = .T.
      IF lChanged = .T.
         IF msgyesno( "Save Change ?", "TXT have change" ) == .T.
            hb_MemoWrit( cFile, TXTEdit.TXTCtrl.Value )
         ENDIF
      ENDIF
   ENDIF

   TXTEdit.TXTCtrl.Value := " "
RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure RTF_Edit()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure dataviewer()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE RTF_Edit( cFile, lEdit )

LOCAL nIndex := 0

STATIC lRunning := .F.

   DEFAULT lEdit TO .F.

   IF CHR( 204 ) $ cFile
      MsgInfo( "unknow sign in file " + CRLF + cFile, "Error CHR(204)" )
      RETURN
   ENDIF

   IF lRunning = .T.
      RETURN
   ENDIF
   lRunning := .T.
   lActiveMain := .F.

   SetCursorWait( "WinLeft", .T. )
   SetCursorWait( "WinRight", .T. )
   DO EVENTS

   DEFINE WINDOW RTFEdit ;
         AT 292, 562 ;
         WIDTH 800 ;
         HEIGHT 600 ;
         TITLE cFile ;
         ON SIZE DoRTFResize( ThisWindow.Name, "RTFCtrl" ) ;
         ON MAXIMIZE DoRTFResize( ThisWindow.Name, "RTFCtrl" ) ;
         ON RELEASE RTFRelease( lEdit, cFile ) ;
         BACKCOLOR SP_nColor1()

      DEFINE STATUSBAR PARENT RTFEdit
STATUSITEM "RTFCtrl()" WIDTH 400
      END STATUSBAR

      DEFINE RICHEDITBOX RTFCtrl
         ROW 10
         COL 10
         WIDTH 760
         HEIGHT 520
         FONTNAME SP_cFontName()
         TABSTOP .T.
         VISIBLE .T.
         READONLY !lEdit
         BACKCOLOR Nil
         ONCHANGE OnChanged()
      END RICHEDITBOX

   END WINDOW

   RTFEdit.RTFCtrl.RTFLoadFile( cFile, 4, .F. )
   RTFEdit.RTFCtrl.FontBackColor := IF( lEdit = .T., SP_nColor5(), SP_nColor13() )
   RTFEdit.RTFCtrl.FontColor := IF( lEdit = .T., SP_nColor6(), SP_nColor14() )

   // set Flage after load RTF
   lChanged := .F.

   SetCursorWait( "WinLeft", .F. )
   SetCursorWait( "WinRight", .F. )
   DO EVENTS

   ON KEY CONTROL + F OF RTFEdit ACTION SearchRTF( "RTF" )
   ON KEY F3 OF RTFEdit ACTION SearchRTF( "RTF" )
   ON KEY ESCAPE OF RTFEdit ACTION RTFEdit.Release

   CREATE EVENT PROCNAME ShowRowCol("RTFEdit","RTFCtrl") HWND RTFEdit.RTFCtrl.HANDLE STOREINDEX nIndex
   EventProcessAllHookMessage( nIndex, .T. )

   CENTER WINDOW RTFEdit
   RTFEdit.RTFCtrl.setfocus()
   ACTIVATE WINDOW RTFEdit

   lRunning := .F.
   lActiveMain := .T.
   EventRemove( nIndex )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure RTFRelease()
*+
*+    Called from ( viewer.prg )   1 - procedure rtf_edit()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE RTFRelease( lEdit, cFile )

   IF lEdit = .T.
      IF lChanged = .T.
         IF msgyesno( "Save Change ?", "RFT have change" ) == .T.
            RTFEdit.RTFCtrl.RTFSaveFile( cFile, .F. )
         ENDIF
      ENDIF
   ENDIF

   RTFEdit.RTFCtrl.VALUE := ""
RETURN

*+--------------------------------------------------------------------
*+
*+    Function Image_Edit()
*+
*+    Called from ( fmgrid.prg )   2 - static procedure dataviewer()
*+                                   2 - static procedure slideshow()
*+                ( thumbs.prg )   1 - static procedure doshow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Image_Edit( cPath, cFile, nTimeout, lEdit )

LOCAL nMode, nClone, nType, cOldFile
LOCAL nRatio, nWidth, nHeight, nW, nH
LOCAL nFreeHandle, cWorkFile, aRect, nScrWidth, nScrHeight, nWidthOrig, nHeightOrig
LOCAL nTitlebar   := GETTITLEHEIGHT()
LOCAL nBorder     := GETBORDERWIDTH()
LOCAL cExt        := LOWER( cFileExt( cFile ) )
LOCAL nFormat     := 0
LOCAL nFif        := Get_FIF( cExt, @nFormat )
LOCAL acFiles     := {}
LOCAL acTarget    := {}
LOCAL nFormWidth, nFormHeight
LOCAL bError
LOCAL cLoad

STATIC lRunning := .F.

   DEFAULT nTimeout TO 0
   DEFAULT lEdit TO .F.

   IF "?" $ cFile
      MsgInfo( "file " + cPath + cFile + " not found", "Error ? sign" )
      RETURN .F.
   ENDIF

   IF CHR( 204 ) $ cFile
      MsgInfo( "unknow sign in file " + CRLF + cPath + cFile, "Error CHR(204)" )
      RETURN .F.
   ENDIF

   IF !FILE( cPath + cFile )
      MsgInfo( "File not found !" + CRLF + cFile, "Error File" )
      RETURN .F.
   ENDIF

   IF lRunning = .T.
      RETURN nil
   ENDIF
   lRunning := .T.
   lActiveMain := .F.
   lChanged := .F.
   nKoef := 1

   // open in FmGrid.PRG
   //
   // #IFDEF Use_FreeImage
   //    IF FILE( 'FreeImage.Dll' ) .OR. FILE( 'FreeImage64.Dll' )
   //       FREE_Initialise()
   //    ELSE
   //       MsgInfo( "Can't found the FreeImage.Dll" )
   //       RETURN NIL
   //    ENDIF
   // #ENDIF

   bError := ERRORBLOCK( { | oErr | BREAK( oErr ) } )
   BEGIN SEQUENCE

      IF HMG_IsUTF8( cFile )
         cLoad := HMG_UNICODE_TO_ANSI( cFile )
      ELSE
         cLoad := cFile
      ENDIF

      nType := FREE_GetFileType( cPath + cLoad, 0 )
      nFreeHandle := FREE_Load( nType, cPath + cLoad, 0 )
      // nFreeHandle := FREE_Load( nFif, cPath + cFile, 0 )
   END SEQUENCE
   ERRORBLOCK( bError )

   IF EMPTY( nFreeHandle )
      Msginfo( "Error loading : " + cPath + cFile )
      RETURN nil
   ENDIF

   nWidth := FREE_GetWidth( nFreeHandle )
   nHeight := FREE_GetHeight( nFreeHandle )
   nRatio := nWidth / nHeight

   // if empty(nWidth) .or. empty(nHeight)
   //    Msginfo( str(nWidth)+"/"+STR(nHeight),STR(nRatio))
   // ENDIF

   nWidthOrig := nWidth
   nHeightOrig := nHeight

   // create temp. file
   cWorkFile := GetTempFolder() + "FI_" + cFile                       // + ".bmp"

   aRect := GetDesktopArea()
   nScrWidth := aRect[ 3 ] - aRect[ 1 ]
   nScrHeight := aRect[ 4 ] - aRect[ 2 ]

   DEFINE WINDOW ImageEdit ;
         AT 0, 0 ;
         WIDTH 0 ;
         HEIGHT 0 ;
         TITLE IF( nWidth < 33, "", cPath + cFile ) ;
         ICON "ICOINFO" ;
         TOPMOST ;
         NOMINIMIZE ;
         ON INIT nil ;
         ON SIZE DoBMPResize( ThisWindow.Name, cWorkFile, 2 ) ;
         ON MAXIMIZE DoBMPResize( ThisWindow.Name, cWorkFile, 2 ) ;
         ON RELEASE ImageRelease( cPath, cFile, cWorkFile ) ;
         BACKCOLOR SP_nColor1()

      DEFINE CONTEXT MENU OF ImageEdit
         IF lEdit = .T.
            MENUITEM "rotate &right" IMAGE "MYROTATER16" ACTION ViewRotate( - 90, cWorkFile, cPath, cFile, nType )
            MENUITEM "rotate &left" IMAGE "MYROTATEL16" ACTION ViewRotate( 90, cWorkFile, cPath, cFile, nType )
            SEPARATOR
            MENUITEM "rotate 180" ACTION ViewRotate( 180, cWorkFile, cPath, cFile, nType )
            SEPARATOR
         ENDIF
         MENUITEM "Pic Info" IMAGE "MYINFO16" ACTION PictInfo( cPath, cFile, nWidthOrig, nHeightOrig, nFreeHandle )
      END MENU

      // DEFINE IMAGE Image_Edit
      //    ROW 0
      //    COL 0
      //    WIDTH 0
      //    HEIGHT 0
      //    PICTURE nil
      //    VISIBLE .T.
      //    STRETCH .T.
      // END IMAGE

   END WINDOW

   nFormWidth := nWidth
   nFormHeight := nHeight + GetTitleHeight() + ( 3 * GetBorderHeight() )

   //  nMode := IF( nWidth < nScrWidth .AND. nHeight < nScrHeight, 0, 2 )
   //  nMode := 0
   //  nMode := 1
   nMode := 2

   IF nWidth > nScrWidth .OR. nHeight > nScrHeight                    //
      DO WHILE .T.
         nFormWidth := ROUND( nWidth * nKoef, 0 ) + GetBorderWidth() + 4
         nFormHeight := ROUND( nHeight * nKoef, 0 ) + GetTitleHeight() + ( 3 * GetBorderHeight() )                                          //  + GetMenuBarHeight() // + IF( HMG_IsWinVistaOrLater(), 60, 56 )
         IF nFormWidth <= nScrWidth .OR. nKoef < 0.11
            IF nFormHeight <= nScrHeight .OR. nKoef < 0.11
               nWidth := nFormWidth - ( GetBorderWidth() + 4 )
               nHeight := nFormHeight - ( GetTitleHeight() + ( 3 * GetBorderHeight() ) )                                                    //  + GetMenuBarHeight() ) // + IF( HMG_IsWinVistaOrLater(), 60, 56 ) )
               EXIT
            ENDIF
         ENDIF
         nKoef -= 0.01
      ENDDO

      nClone := FREE_Clone( nFreeHandle )
      FREE_Unload( nFreeHandle )
      nFreeHandle := FREE_Rescale( nClone, nWidth, nHeight, FILTER_BICUBIC )
      FREE_Unload( nClone )
   ENDIF

   //    nShowX := nFormWidth
   //    nShowY := nFormHeight

   // MUST be Bitmap for FREE_DRAWPICTURE()
   FREE_Save( FIF_BMP, nFreeHandle, cWorkFile, BMP_DEFAULT )

   SetProperty( "ImageEdit", "Width", nFormWidth + GetBorderWidth() + 4 )
   SetProperty( "ImageEdit", "Height", nFormHeight + GetTitleHeight() + 4 )
   //    SetProperty( "ImageEdit", "Image_Edit", "PICTURE", cWorkFile )

   ERASE WINDOW ImageEdit
   FREE_DRAWPICTURE( GetFormHandle( "ImageEdit" ), cWorkFile, nMode, nFormWidth, nFormHeight )
   FREE_Unload( nFreeHandle )

   IF !EMPTY( nTimeout )

      ON KEY ESCAPE OF ImageEdit ACTION SlideshowEnd( 1 )
      ON KEY NEXT OF ImageEdit ACTION SlideshowEnd( 2 )
      ON KEY PRIOR OF ImageEdit ACTION SlideshowEnd( 3 )

      DEFINE TIMER SlideTime PARENT ImageEdit ;
              INTERVAL nTimeout ;
              ACTION SlideshowEnd( - 1 )

      ON KEY SPACE OF ImageEdit ACTION DoSpaceKey()
   ELSE
      ON KEY ESCAPE OF ImageEdit ACTION ImageEdit.Release
   ENDIF

   ON KEY HOME OF ImageEdit ACTION Zoom( 0, nFreeHandle, nWidth, nHeight )
   ON KEY PRIOR OF ImageEdit ACTION Zoom( - 1, nFreeHandle, nWidth, nHeight )
   ON KEY NEXT OF ImageEdit ACTION Zoom( 1, nFreeHandle, nWidth, nHeight )

   CENTER WINDOW ImageEdit
   //    ImageEdit.Image_Edit.setfocus()
   ACTIVATE WINDOW ImageEdit

   lRunning := .F.
   lActiveMain := .T.

   // closed in FmGrid.PRG
   // #IFDEF Use_FreeImage
   //    FREE_Deinitialise()
   // #ENDIF

   IF lChanged = .T.
      IF msgyesno( "Save Change ?", "Image have change" ) == .T.
         SP_lDirWatch( .F. )

         cOldFile := STRTRAN( cPath + cFile, ".", "_" )
         IF FILE( cOldFile + ".BAK" )
            FERASE( cOldFile + ".BAK" )
         ENDIF

         IF FRENAME( cPath + cFile, cOldFile + ".BAK" ) = 0
            IF SaveView( cPath, cFile )
               FERASE( cWorkFile )
               SP_lDirWatch( .T. )
               ReRead( nGridFocus )
            ELSE
               msgInfo( "Problem to rename file " + cWorkFile, "Error FRENAME" )
            ENDIF
         ELSE
            msgInfo( "Problem to rename file " + cPath + cFile, "Error FRENAME" )
         ENDIF
      ELSE
         FERASE( cWorkFile )
      ENDIF
   ELSE
      FERASE( cWorkFile )
   ENDIF
   lChanged := .F.

RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Procedure ImageRelease()
*+
*+    Called from ( viewer.prg )   1 - function image_edit()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ImageRelease( cPath, cFile, cWorkFile )

   // SetProperty( "ImageEdit", "Image_Edit", "PICTURE", nil )
RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure SlideshowEnd()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure slideshow()
*+                ( viewer.prg )   4 - function image_edit()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE SlideshowEnd( nNo )

   SP_nSlideShow( nNo )
   IF isWindowDefined( ImageEdit )
      ImageEdit.show()
      ImageEdit.Release
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure ViewRotate()
*+
*+    Called from ( viewer.prg )   3 - function image_edit()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ViewRotate( nRad, cWorkFile, cPath, cFile, nType )

LOCAL cThumbsFile
LOCAL nFreeHandle, nClone, new_handle
LOCAL cExt        := LOWER( cFileExt( cFile ) )
LOCAL nFormat     := 0                                                // 0 = DEFAULT
LOCAL nFif        := Get_FIF( cExt, @nFormat )
LOCAL nWidth
LOCAL nHeight
LOCAL bError

#IFDEF Use_FreeImage

   //    bError := ERRORBLOCK( { | oErr | BREAK( oErr ) } )
   //    BEGIN SEQUENCE
   nFreeHandle := FREE_Load( FIF_BMP, cWorkFile, 0 )
   //    END SEQUENCE
   //    ERRORBLOCK( bError )

   IF EMPTY( nFreeHandle )
      MsgInfo( "Error loading file " + CRLF + cWorkFile, cFile )
   ELSE
      nClone := FREE_Clone( nFreeHandle )
      FREE_Unload( nFreeHandle )
      IF !( ( new_handle := FREE_RotateClassic( nClone, nRad ) ) == Nil )
         FREE_Unload( nClone )
         nFreeHandle := new_handle

         IF FILE( cWorkFile )
            FERASE( cWorkFile )
         ENDIF
         // MUST be Bitmap for FREE_DRAWPICTURE()
         FREE_Save( FIF_BMP, nFreeHandle, cWorkFile, BMP_DEFAULT )

         nWidth := FREE_GetWidth( nFreeHandle )
         nHeight := FREE_GetHeight( nFreeHandle )

         // SetProperty( "ImageEdit", "Image_Edit", "PICTURE", cWorkFile )

         ERASE WINDOW ImageEdit
         FREE_DRAWPICTURE( GetFormHandle( "ImageEdit" ), cWorkFile, 2, nWidth, nHeight )
         FREE_Unload( nFreeHandle )

         lChanged := .T.
      ENDIF
   ENDIF
#ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function SaveView()
*+
*+    Called from ( viewer.prg )   1 - function image_edit()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION SaveView( cPath, cFile )

LOCAL cWorkFile, nFreeHandle, lRet := .F.
LOCAL cExt, nFif, nFormat := 0
LOCAL cLoad

   cExt := LOWER( cFileExt( cFile ) )
   nFif := Get_FIF( cExt, @nFormat )

   cWorkFile := GetTempFolder() + "FI_" + cFile                       // + ".bmp"
   nFreeHandle := FREE_Load( FIF_BMP, cWorkFile, 0 )

   IF !EMPTY( nFreeHandle )
      IF FILE( cPath + cFile )
         FERASE( cPath + cFile )
      ENDIF

      IF HMG_IsUTF8( cFile )
         cLoad := HMG_UNICODE_TO_ANSI( cFile )
      ELSE
         cLoad := cFile
      ENDIF

      FREE_Save( nFif, nFreeHandle, cPath + cLoad, nFormat )          //  BMP_DEFAULT
      FREE_Unload( nFreeHandle )
      lRet := .T.
   ENDIF

RETURN lRet

*+--------------------------------------------------------------------
*+
*+    Function Get_FIF()
*+
*+    Called from ( thumbs.prg )   1 - procedure thumbs()
*+                                   1 - static procedure thumbsrotate()
*+                ( viewer.prg )   1 - function image_edit()
*+                                   1 - static procedure viewrotate()
*+                                   1 - static function saveview()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Get_FIF( cExt, nDef )

LOCAL nFif := FIF_UNKNOWN                                             // -1

   DO CASE
      CASE cExt == ".bmp"
         nFif := FIF_BMP                                              // 0
         nDef := BMP_DEFAULT
      CASE cExt == ".ico"
         nFif := FIF_ICO                                              // 1
         nDef := ICO_DEFAULT
      CASE cExt == ".jpg" .OR. cExt == ".jpeg"
         nFif := FIF_JPEG                                             // 2
         nDef := JPEG_DEFAULT
      CASE cExt == ".jng"
         nFif := FIF_JNG                                              // 3
         nDef := 0
      CASE cExt == ".koala"
         nFif := FIF_KOALA                                            // 4
         nDef := KOALA_DEFAULT
      CASE cExt == ".lbm"
         nFif := FIF_LBM                                              // 5
         nDef := LBM_DEFAULT
      CASE cExt == ".iff"
         nFif := FIF_IFF                                              // FIF_LBM
         nDef := IFF_DEFAULT
      CASE cExt == ".mng"
         nFif := FIF_MNG                                              // 6
         nDef := MNG_DEFAULT
      CASE cExt == ".pbm"
         nFif := FIF_PBM                                              // 7
         nDef := 0
      CASE cExt == ".pbmraw"
         nFif := FIF_PBMRAW                                           // 8
         nDef := 0
      CASE cExt == ".pcd"
         nFif := FIF_PCD                                              // 9
         nDef := PCD_DEFAULT
      CASE cExt == ".pcx"
         nFif := FIF_PCX                                              // 10
         nDef := PCX_DEFAULT
      CASE cExt == ".pgm"
         nFif := FIF_PGM                                              // 11
         nDef := 0
      CASE cExt == ".pgmraw"
         nFif := FIF_PGMRAW                                           // 12
         nDef := 0
      CASE cExt == ".png"
         nFif := FIF_PNG                                              // 13
         nDef := PNG_DEFAULT
      CASE cExt == ".ppm"
         nFif := FIF_PPM                                              // 14
         nDef := 0
      CASE cExt == ".ppmraw"
         nFif := FIF_PPMRAW                                           // 15
         nDef := 0
      CASE cExt == ".ras"
         nFif := FIF_RAS                                              // 16
         nDef := RAS_DEFAULT
      CASE cExt == ".targa"
         nFif := FIF_TARGA                                            // 17
         nDef := TARGA_DEFAULT
      CASE cExt == ".tiff"
         nFif := FIF_TIFF                                             // 18
         nDef := TIFF_DEFAULT
      CASE cExt == ".wbmp"
         nFif := FIF_WBMP                                             // 19
         nDef := WBMP_DEFAULT
      CASE cExt == ".psd"
         nFif := FIF_PSD                                              // 20
         nDef := PSD_DEFAULT
      CASE cExt == ".cut"
         nFif := FIF_CUT                                              // 21
         nDef := CUT_DEFAULT
      CASE cExt == ".xbm"
         nFif := FIF_XBM                                              // 22
      CASE cExt == ".xpm"
         nFif := FIF_XPM                                              // 23
         nDef := XPM_DEFAULT
      CASE cExt == ".dds"
         nFif := FIF_DDS                                              // 24
         nDef := DDS_DEFAULT
      CASE cExt == ".gif"
         nFif := FIF_GIF                                              // 25
         nDef := GIF_DEFAULT
      CASE cExt == ".hdr"
         nFif := FIF_HDR                                              // 26
         nDef := HDR_DEFAULT
      OTHERWISE
         nFif := FIF_UNKNOWN                                          // -1
         nDef := 0
   ENDCASE
RETURN nFif

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoTXTResize()
*+
*+    Called from ( viewer.prg )   2 - procedure txt_edit()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoTXTResize( cForm, cObj )

LOCAL nDiff      := 0
LOCAL mainRow    := GetProperty( cForm, 'Row' )
LOCAL mainCol    := GetProperty( cForm, 'Col' )
LOCAL mainWidth  := GetProperty( cForm, 'Width' )
LOCAL mainHeight := GetProperty( cForm, 'Height' )
LOCAL nBorder    := GETBORDERWIDTH()

   Domethod( cForm, "hide" )

   Setproperty( cForm, cObj, "Width", mainWidth - 20 - ( 2 * nBorder ) )
   Setproperty( cForm, cObj, "Height", mainHeight - 30 - nDiff )

   Domethod( cForm, "show" )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoRTFResize()
*+
*+    Called from ( viewer.prg )   2 - procedure rtf_edit()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoRTFResize( cForm, cObj )

LOCAL nDiff      := 0
LOCAL mainRow    := GetProperty( cForm, 'Row' )
LOCAL mainCol    := GetProperty( cForm, 'Col' )
LOCAL mainWidth  := GetProperty( cForm, 'Width' )
LOCAL mainHeight := GetProperty( cForm, 'Height' )
LOCAL nBorder    := GETBORDERWIDTH()

   Domethod( cForm, "hide" )

   Setproperty( cForm, cObj, "Width", mainWidth - 20 - ( 2 * nBorder ) )
   Setproperty( cForm, cObj, "Height", mainHeight - 30 - nDiff )

   Domethod( cForm, "show" )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoBMPResize()
*+
*+    Called from ( viewer.prg )   2 - function image_edit()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoBMPResize( cForm, cWorkFile, nMode )

LOCAL mainRow    := GetProperty( cForm, 'Row' )
LOCAL mainCol    := GetProperty( cForm, 'Col' )
LOCAL mainWidth  := GetProperty( cForm, 'Width' )
LOCAL mainHeight := GetProperty( cForm, 'Height' )
LOCAL nBorder    := GETBORDERWIDTH()
LOCAL nTitlebar  := GETTITLEHEIGHT()
LOCAL nDeskWide  := GETDESKTOPWIDTH()
LOCAL nDeskHigh  := GETDESKTOPHEIGHT()

   Domethod( cForm, "hide" )

   IF mainWidth > nDeskWide
      mainWidth := nDeskWide
   ENDIF
   IF mainHeight > nDeskHigh
      mainHeight := nDeskHigh
   ENDIF

   // IF !EMPTY(cObj)
   //    Setproperty( cForm, cObj, "Width", mainWidth - ( 2 * nBorder ) )
   //    Setproperty( cForm, cObj, "Height", mainHeight - nTitlebar - ( 2 * nBorder ) )
   // ENDIF

   Domethod( cForm, "show" )

   ERASE WINDOW ImageEdit
   FREE_DRAWPICTURE( GetFormHandle( "ImageEdit" ), cWorkFile, nMode, mainWidth, mainHeight - nTitlebar )
   //    FREE_DRAWPICTURE( GetFormHandle( "ImageEdit" ), cWorkFile, nMode,nShowX,nShowY)

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure ShowPDF()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure dataviewer()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE ShowPDF( cPath, cFile, cObj )

LOCAL cHwnd, cNation
LOCAL nCountry := HB_bitAND( GETKEYBOARDLAYOUT(), 0xFFFF )
LOCAL cForm

STATIC lRunning := .F.
STATIC cLast    := ""

   cForm := cObj + "ShowPDF"

   IF lRunning = .T.
      DoFindWin( cLast )
      RETURN
   ENDIF

   lRunning := .T.
   cLast := cFile

   IF FILE( "SumatraPDF.exe" )

      IF nCountry = 1031
         cNation := "de"
      ELSE
         cNation := "en"
      ENDIF

      SetCursorWait( "WinLeft", .T. )
      SetCursorWait( "WinRight", .T. )
      DO EVENTS

      DEFINE WINDOW &cForm ;
            ROW 10 ;
            COL 10 ;
            WIDTH 1024 ;
            HEIGHT 1024 ;
            TITLE cFile ;
            ICON "ICOPDF" ;
            ON MAXIMIZE DoPDFResize( cForm, "PdfView" ) ;
            ON SIZE DoPDFResize( cForm, "PdfView" ) ;
            BACKCOLOR { 250, 241, 228 }

         DEFINE WINDOW PdfView ;
               ROW 10 ;
               COL 10 ;
               WIDTH 1000 ;
               HEIGHT 960 ;
               PANEL ;
               BACKCOLOR { 250, 241, 228 }
         END WINDOW
      END WINDOW

      cHwnd := ALLTRIM( STR( GETFORMHANDLE( 'PdfView' ) ) )
      //       EXECUTE FILE 'SumatraPDF.exe' PARAMETERS '-lang ' + cNation + ' -plugin ' + cHwnd + ' ' + cPath + cfile
      EXECUTE FILE 'SumatraPDF.exe' PARAMETERS '-lang ' + cNation + ' -plugin ' + cHwnd + ' ' + CHR( 34 ) + cPath + cfile + CHR( 34 )

      ON KEY ESCAPE OF &cForm ACTION Domethod( cForm, "Release" )

      ON KEY F7 OF &cForm ACTION DoPDFSearch( "PdfView", "xbase" )
      ON KEY F1 OF &cForm ACTION DoPDFHelp()

      SetCursorWait( "WinLeft", .F. )
      SetCursorWait( "WinRight", .F. )
      DO EVENTS

      CENTER WINDOW &cForm
      Activate Window &cForm
   ELSE
      RunByExtension( cPath, cfile )
   ENDIF

   lRunning := .F.
RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure DoPDFHelp()
*+
*+    Called from ( viewer.prg )   1 - procedure showpdf()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE DoPDFHelp()

LOCAL nWide := 1193
LOCAL nHigh := 823
LOCAL cText := ""

   cText += "Ctrl-0 : fit to Page     Ctrl-1 : Orginal-Size    Ctrl-2 : fit to wide" + CRLF
   cText += "Ctrl-6 : Singe-Side    Ctrl-7 : Double-Side    Ctrl-8 : Book-view" + CRLF

   DEFINE WINDOW DoPDFHelp ;
         ROW 0 ;
         COL 0 ;
         WIDTH 1280 - 80 ;
         HEIGHT 1024 - 50 ;
         TITLE "Help" ;
         ICON "ICOPDF" ;
         NOMAXIMIZE ;
         NOSIZE ;
         BACKCOLOR NIL

      DEFINE IMAGE HelpInfo
         ROW 0
         COL 0
         WIDTH nWide
         HEIGHT nHigh
         PICTURE "MYSUMATRA"
         VISIBLE .T.
         TRANSPARENT .F.
         BACKGROUNDCOLOR SP_nColor1()
      END IMAGE

      DEFINE LABEL PathInfo
         ROW nHigh + 20
         COL 0
         VALUE cText
         WIDTH nWide
         HEIGHT 100
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         BACKCOLOR SP_nColor1()
         FONTCOLOR SP_nColor2()
         ALIGNMENT Left
      END LABEL

   END WINDOW

   ON KEY ESCAPE OF DoPDFHelp ACTION DoPDFHelp.Release
   CENTER WINDOW DoPDFHelp
   Activate Window DoPDFHelp

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoPDFResize()
*+
*+    Called from ( viewer.prg )   2 - procedure showpdf()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoPDFResize( fMain, fView )

LOCAL mainRow    := GetProperty( fMain, 'Row' )
LOCAL mainCol    := GetProperty( fMain, 'Col' )
LOCAL mainWidth  := GetProperty( fMain, 'Width' )
LOCAL mainHeight := GetProperty( fMain, 'Height' )
LOCAL nHANDLE    := GetProperty( fMain, 'HANDLE' )
LOCAL nBorder    := GETBORDERWIDTH()

   Setproperty( fView, "Width", mainWidth - 30 )
   Setproperty( fView, "Height", mainHeight - 60 )
   Setproperty( fView, "Col", ClientToScreenCol( nHANDLE, 10 ) )
   Setproperty( fView, "Row", ClientToScreenRow( nHANDLE, 10 ) )

   Sumatra_FrameAdjust( fView )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoPDFSearch()
*+
*+    Called from ( viewer.prg )   1 - procedure showpdf()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoPDFSearch( fView, cText )

LOCAL lRet := .F.

   DEFAULT cText TO "xbase"

   lRet := Sumatra_FindText( fView )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoSpaceKey()
*+
*+    Called from ( viewer.prg )   1 - function image_edit()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoSpaceKey()

   IF ImageEdit.SlideTime.Enabled = .T.
      ImageEdit.SlideTime.Enabled := .F.
   ELSE
      ImageEdit.SlideTime.Enabled := .T.
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SearchRTF()
*+
*+    Called from ( viewer.prg )   2 - procedure rtf_edit()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SearchRTF()

LOCAL cFind

   ( cFind := RTFEdit.RTFCtrl.GetSelectText, ;
     FINDTEXTDIALOG ON ACTION FindReplRTFProc() FIND cFind CHECKDOWN lDown CHECKMATCHCASE lMatchCase CHECKWHOLEWORD lWholeWord )

   SP_cFindText( cFind )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SearchText()
*+
*+    Called from ( viewer.prg )   2 - procedure txt_edit()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SearchText()

LOCAL cFind

   ( cFind := SP_cFindText(), ;
     FINDTEXTDIALOG ON ACTION FindReplTXTProc() FIND cFind CHECKDOWN lDown CHECKMATCHCASE lMatchCase CHECKWHOLEWORD lWholeWord )

   SP_cFindText( cFind )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure Dummy_Text()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Dummy_Text()

LOCAL cHoleText
LOCAL cSeek, nPosi, aPos := { 0, 0 }
STATIC nStart   := 1

   cSeek := GetInPut( "seek", "Search", cLastSeek, 1 )
   IF !EMPTY( cSeek )
      cLastSeek := cSeek
      cHoleText := TXTEdit.TXTCtrl.Value
      nPosi := hb_at( UPPER( cSeek ), UPPER( cHoleText ), nStart )
      IF nPosi > 0
         TXTEdit.TXTCtrl.CaretPos := nPosi
         nStart := nPosi + 1
      ELSE
         MsgInfo( "EOF no more" )
         nStart := 1
      ENDIF
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure FindReplRTFProc()
*+
*+    Called from ( viewer.prg )   1 - static procedure searchrtf()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE FindReplRTFProc( oObj )

LOCAL lSelectFindText
LOCAL aPosRange       := { 0, 0 }
LOCAL cFind           := SP_cFindText()

   IF FindReplaceDlg.RetValue == FRDLG_CANCEL                         // User Cancel or Close dialog
      RETURN
   ENDIF

   cFind := FindReplaceDlg.Find
   cReplace := FindReplaceDlg.Replace
   lDown := FindReplaceDlg.Down
   lMatchCase := FindReplaceDlg.MatchCase
   lWholeWord := FindReplaceDlg.WholeWord
   lSelectFindText := .T.

   SP_cFindText( cFind )
   DO CASE
      CASE FindReplaceDlg.RetValue == FRDLG_FINDNEXT
         aPosRange := RTFEdit.RTFCtrl.FindText( cFind, lDown, lMatchCase, lWholeWord, lSelectFindText )

      CASE FindReplaceDlg.RetValue == FRDLG_REPLACE
         aPosRange := RTFEdit.RTFCtrl.ReplaceText( cFind, cReplace, lMatchCase, lWholeWord, lSelectFindText )

      CASE FindReplaceDlg.RetValue == FRDLG_REPLACEALL
         aPosRange := RTFEdit.RTFCtrl.ReplaceAllText( cFind, cReplace, lMatchCase, lWholeWord, lSelectFindText )
   ENDCASE

   IF aPosRange[ 1 ] == - 1
      MsgInfo( "Can't find the text:" + HB_OSNEWLINE() + cFind )
   ELSE
      MoveInRTF( aPosRange[ 1 ] )
      RTFEdit.RTFCtrl.SelectRange := { aPosRange[ 1 ], aPosRange[ 1 ] + LEN( cFind ) }
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure MoveInRTF()
*+
*+    Called from ( viewer.prg )   1 - static procedure findreplrtfproc()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE MoveInRTF( nPos )

LOCAL CharRowCol := RTFEdit.RTFCtrl.GetPosChar( nPos )

   IF CharRowCol[ 1 ] <> - 1 .AND. CharRowCol[ 2 ] <> - 1
      IF ( FindReplaceDlg.HEIGHT + OFFSET_DLG ) < CharRowCol[ 1 ]
         FindReplaceDlg.Row := CharRowCol[ 1 ] - ( FindReplaceDlg.HEIGHT + OFFSET_DLG )
      ELSEIF FindReplaceDlg.Row < CharRowCol[ 1 ] + OFFSET_DLG
         FindReplaceDlg.Row := CharRowCol[ 1 ] + OFFSET_DLG
      ENDIF
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure FindReplTXTProc()
*+
*+    Called from ( viewer.prg )   1 - static procedure searchtext()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE FindReplTXTProc()

LOCAL lSelectFindText
LOCAL aPosRange       := { 0, 0 }
LOCAL cFind           := SP_cFindText()
LOCAL cHoleText, nPosi

STATIC nStart := 1

   IF FindReplaceDlg.RetValue == FRDLG_CANCEL                         // User Cancel or Close dialog
      RETURN
   ENDIF

   cFind := FindReplaceDlg.Find
   cReplace := FindReplaceDlg.Replace
   lDown := FindReplaceDlg.Down
   lMatchCase := FindReplaceDlg.MatchCase
   lWholeWord := FindReplaceDlg.WholeWord
   lSelectFindText := .T.

   SP_cFindText( cFind )
   cHoleText := TXTEdit.TXTCtrl.Value
   IF lDown = .T.
      nPosi := hb_at( UPPER( cFind ), UPPER( cHoleText ), nStart )
   ELSE
      nPosi := hb_rat( UPPER( cFind ), UPPER( cHoleText ), nStart )
   ENDIF

   IF nPosi > 0
      TXTEdit.TXTCtrl.CaretPos := nPosi
      nStart := nPosi + 1
   ELSE
      IF lDown = .T.
         MsgInfo( "EOF no more" )
         nStart := 1
      ELSE
         MsgInfo( "BOF no more" )
         nStart := LEN( cHoleText )
      ENDIF
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure MoveInTXT()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE MoveInTXT( nPos )

LOCAL CharRowCol := TXTEdit.TXTCtrl.GetPosChar( nPos )

   IF CharRowCol[ 1 ] <> - 1 .AND. CharRowCol[ 2 ] <> - 1
      IF ( FindReplaceDlg.HEIGHT + OFFSET_DLG ) < CharRowCol[ 1 ]
         FindReplaceDlg.Row := CharRowCol[ 1 ] - ( FindReplaceDlg.HEIGHT + OFFSET_DLG )
      ELSEIF FindReplaceDlg.Row < CharRowCol[ 1 ] + OFFSET_DLG
         FindReplaceDlg.Row := CharRowCol[ 1 ] + OFFSET_DLG
      ENDIF
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure OnChanged()
*+
*+    Called from ( viewer.prg )   1 - procedure txt_edit()
*+                                   1 - procedure rtf_edit()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE OnChanged()

   lChanged := .T.
RETURN

*+--------------------------------------------------------------------
*+
*+    Function ShowRowCol()
*+
*+--------------------------------------------------------------------
*+
FUNCTION ShowRowCol( cForm, cObj )                                    // must be public

LOCAL hWnd   := EventHWND()
LOCAL nIndex := GetControlIndexByHandle( hWnd )
LOCAL ch, cText, i, nPos, aPos, nRow := 0, nCol := 0

   IF nIndex > 0 .AND. ( GetControlTypeByIndex( nIndex ) == "EDIT" .OR. ;
              GetControlTypeByIndex( nIndex ) == "RICHEDIT" )

      IF GetControlTypeByIndex( nIndex ) == "EDIT"
         ch := GetProperty( cForm, cObj, "Value" )
         nPos := GetProperty( cForm, cObj, "CaretPos" )
         FOR i := 1 TO nPos
            IF SUBSTR( ch, i, 1 ) == CHR( 13 )
               nRow ++
               nCol := 0
            ELSE
               nCol ++
            ENDIF
         NEXT i
      ELSE
         aPos := RTF_RowCol( cForm, cObj )
         nRow := aPos[ 1 ]
         nCol := aPos[ 2 ]
      ENDIF
      cText := "Row " + hb_NTOS( nRow ) + " / Col " + hb_NTOS( nCol )
      SetProperty( cForm, "StatusBar", "Item", 1, cText )
   ENDIF
RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Static Function RTF_RowCol()
*+
*+    Called from ( viewer.prg )   1 - function showrowcol()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION RTF_RowCol( cForm, cObj )

LOCAL hRtf, nRow, nCol, nSelStart := 1

   hRtf := GetControlHandle( cObj, cForm )
   nSelStart := GetProperty( cForm, cObj, "CaretPos" )
   nRow := SendMessage( hRtf, EM_EXLINEFROMCHAR, 0, nSelStart )
   nCol := nSelStart - SendMessage( hRtf, EM_LINEINDEX, nRow, 0 )

RETURN ( { nRow + 1, nCol } )

*+--------------------------------------------------------------------
*+
*+    Function PictInfo()
*+
*+    Called from ( thumbs.prg )   1 - static procedure pre_picinfo()
*+                ( viewer.prg )   1 - function image_edit()
*+
*+--------------------------------------------------------------------
*+
FUNCTION PictInfo( cPath, cFile, nWidth, nHeight, handle )

LOCAL cExt   := UPPER( cFileExt( cFile ) )
LOCAL aLabel := {}, cLabel, aText := {}, cText, n, cInOut := ""
LOCAL aFocus := StoreLastFocus()

   AADD( aLabel, "File name:" )
   AADD( aLabel, "Folder:" )
   AADD( aLabel, "Compression:" )
   AADD( aLabel, "Original size:" )
   AADD( aLabel, "Disk size:" )
   AADD( aLabel, "File date/time:" )

   AADD( aText, cFile )
   AADD( aText, cPath )
   AADD( aText, cExt )
   AADD( aText, hb_ntos( nWidth ) + " x " + hb_ntos( nHeight ) + " Pixels" )
   AADD( aText, hb_ntos( FILESIZE( cPath + cFile ) / 1024 ) + " KB" )
   AADD( aText, DTOC( FILEDATE( cPath + cFile ) ) )

   IF !EMPTY( handle )
      AADD( aLabel, "Bits per Pixel:" )
      AADD( aText, Var2char( FREE_GETBPP( handle ) ) )
   ENDIF

   ListJPEGData( cFile, cPath, @cInOut )
   IF !EMPTY( cInOut )
      AADD( aLabel, "Exif Info:" )
      AADD( aText, cInOut )
   ENDIF

   DEFINE WINDOW Form_Info AT 0, 0 ;
         WIDTH 360 HEIGHT 300 ;
         TITLE "Image properties" ;
         TOPMOST ;
         CHILD ;
         NOSIZE ;
         NOSYSMENU ;
         ON INIT Form_Info.Button_OK.SetFocus ;
         FONT 'MS Sans Serif' ;
         SIZE 9

      @  8,  8 FRAME Frame_1 ;
              WIDTH 338 ;
              HEIGHT 212

      FOR n := 1 TO LEN( aLabel )
         cLabel := "Label_" + hb_ntos( n )
         @ ( n - 1 ) * 24 + 23, 20 LABEL &cLabel ;
             VALUE aLabel[ n ] ;
             WIDTH 100 HEIGHT 20
      NEXT

      FOR n := 1 TO LEN( aText )
         cText := "Text_" + hb_ntos( n )
         @ ( n - 1 ) * 24 + 21, 134 TEXTBOX &cText ;
             VALUE aText[ n ] ;
             HEIGHT 20 ;
             WIDTH 200 ;
             READONLY
      NEXT

      @ Form_Info.Height - 68 - IF( IsXPThemeActive(), 4, 0 ), Form_Info.Width / 2 - 50 BUTTON Button_OK ;
              CAPTION "OK" ;
              ACTION Form_Info.Release ;
              WIDTH 96 HEIGHT 32

   END WINDOW

   ON KEY ESCAPE OF Form_Info ACTION Form_Info.Release
   CENTER WINDOW Form_Info

   ACTIVATE WINDOW Form_Info

   //    IF isWindowDefined( ImageEdit )
   //       ImageEdit.setfocus()
   //    ENDIF
   RestoreLastFocus( aFocus[ 1 ], aFocus[ 2 ] )

RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Static Procedure ListJPEGData()
*+
*+    Called from ( viewer.prg )   1 - function pictinfo()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ListJPEGData( cFileName, cPath, cInOut )

LOCAL nLength  := 0                                                   // 2 bytes: Length of Marker Header
LOCAL nMajVers := 0                                                   // 1 bytes: (01)
LOCAL nMinVers := 0                                                   // 1 bytes: (02)
LOCAL nUnits   := 0                                                   // 1 byte: 0 = Aspect Ratio, 1 = DPI (Inches), 2 = DPC (cm)
LOCAL nXSize   := 0                                                   // 2 bytes
LOCAL nYSize   := 0                                                   // 2 bytes
LOCAL nFileLen := 0                                                   // Length of JPEG File
LOCAL nHandle  := 0
LOCAL lValid   := .f.
LOCAL cText    := SPACE( 2 ), nTextLen, nOffSet
LOCAL bError   := ERRORBLOCK( { | oErr | BREAK( oErr ) } )

   BEGIN SEQUENCE

      IF ( nHandle := FOPEN( cPath + cFileName, FO_READ + FO_SHARED ) ) > 0
         nTextLen := FSEEK( nHandle, 0, FS_END )
         FSEEK( nHandle, 0, FS_SET )
         IF ( lValid := FREAD( nHandle, @cText, 2 ) == 2 .AND. cText == SOI_MARKER )
            FSEEK( nHandle, - 2, FS_END )
            IF ( lValid := FREAD( nHandle, @cText, 2 ) == 2 .AND. cText == EOI_MARKER )
               IF ( nLength := FindJPEGMarker( nHandle, JFIF_MARKER ) ) > 0
                  cText := SPACE( nLength )
                  IF FREAD( nHandle, @cText, nLength ) == nLength
                     nOffSet := LEN( JFIF_SIGNATURE )
                     IF LEFT( cText, nOffSet ) == JFIF_SIGNATURE
                        nMajVers := ASC( SUBSTR( cText, ++ nOffSet, 1 ) )
                        nMinVers := ASC( SUBSTR( cText, ++ nOffSet, 1 ) )
                        nUnits := ASC( SUBSTR( cText, ++ nOffSet, 1 ) )
                        nXSize := ASC( SUBSTR( cText, ++ nOffSet, 1 ) ) * 256 + ASC( SUBSTR( cText, ++ nOffSet, 1 ) )
                        nYSize := ASC( SUBSTR( cText, ++ nOffSet, 1 ) ) * 256 + ASC( SUBSTR( cText, ++ nOffSet, 1 ) )
                        cInOut := ( " -- X/Y " + IIF( nUnits == 1 .OR. nUnits == 2, "Resolution", "Aspect-Ratio" ) + ": " + ALLTRIM( STR( nXSize ) ) + "/" + ALLTRIM( STR( nYSize ) ) + IIF( nUnits == 1, " DPI", IIF( nUnits == 2, " DPC", "" ) ) )
                     ELSE
                        cInOut := ""                                  // ( ' -- Not a valid JFIF file...' )
                     ENDIF
                  ELSE
                     cInOut := ( " -- Invalid/Corrupted JFIF Header..." )
                  ENDIF
               ELSEIF ( nLength := FindJPEGMarker( nHandle, EXIF_MARKER ) ) > 0
                  cText := SPACE( nLength )
                  IF FREAD( nHandle, @cText, nLength ) == nLength
                     nOffSet := LEN( EXIF_SIGNATURE )
                     IF LEFT( cText, nOffSet ) == EXIF_SIGNATURE
                        cInOut := ( " -- Can't (yet) deceipher EXIF Application Markers..." )
                     ELSE
                        cInOut := ""                                  // ( ' -- Not a valid EXIF file...' )
                     ENDIF
                  ELSE
                     cInOut := ( " -- Invalid/Corrupted EXIF Header..." )
                  ENDIF
               ELSE
                  cInOut := ( " -- Could not find valid (JFIF/EXIF) Application Marker..." )
               ENDIF
            ENDIF
         ENDIF
         FCLOSE( nHandle )
      ENDIF

   END SEQUENCE
   ERRORBLOCK( bError )

   IF .NOT. lValid
      cInOut := ""                                                    // ( " -- Not a valid JPEG file..." )
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function FindJPEGMarker()
*+
*+    Called from ( viewer.prg )   2 - static procedure listjpegdata()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION FindJPEGMarker( nHandle, cMarker )

LOCAL nLength := 0
LOCAL cHeader := SPACE( 2 )
LOCAL cBuffer := SPACE( 2 )
   FSEEK( nHandle, 2, FS_SET )
   WHILE FREAD( nHandle, @cHeader, 2 ) == 2 .AND. cHeader # EOI_MARKER
      IF FREAD( nHandle, @cBuffer, 2 ) == 2
         nLength := ASC( SUBSTR( cBuffer, 1, 1 ) ) * 256 + ASC( SUBSTR( cBuffer, 2, 1 ) ) - 2
         IF cHeader == cMarker
            EXIT
         ELSE
            cHeader := SPACE( 2 )
            cBuffer := SPACE( nLength )
            IF FREAD( nHandle, @cBuffer, nLength ) # nLength
               nLength := 0
               EXIT
            ENDIF
            nLength := 0
         ENDIF
      ELSE
         nLength := 0
         EXIT
      ENDIF
   ENDDO
RETURN ( nLength )

*+--------------------------------------------------------------------
*+
*+    Static Function PaintWindow()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION PaintWindow( handle, nHeight, nWidth )

LOCAL pps, hDC

   IF handle == Nil
      RETURN - 1
   ENDIF

   hDC := BeginPaint( ImageEdit.Handle, @pps )

   FREE_WinDraw( handle, hDC, 36, 0, ROUND( nHeight * nKoef, 0 ) + 36, ROUND( nWidth * nKoef, 0 ) )

   EndPaint( ImageEdit.Handle, pps )

   InvalidateRect( ImageEdit.Handle, 0 )

RETURN 0

*+--------------------------------------------------------------------
*+
*+    Static Function Zoom()
*+
*+    Called from ( viewer.prg )   3 - function image_edit()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION Zoom( nOp, nFreeHandle, nWidth, nHeight )

LOCAL nPictWidth, nPictHeight

   IF nFreeHandle == Nil
      RETURN NIL
   ENDIF

   IF EMPTY( nOp ) .AND. nKoef == 1
      RETURN NIL
   ENDIF

   IF INT( nKoef * 10 ) # ROUND( nKoef, 1 ) * 10
      nKoef := INT( nKoef * 10 ) / 10
   ELSE
      nKoef := ROUND( nKoef, 1 )
   ENDIF
   IF nOp < 0 .AND. nKoef > 0.11
      nKoef -= 0.1
   ELSEIF nOp > 0 .AND. nKoef < 9.9
      nKoef += 0.1
   ELSE
      nKoef := 1
   ENDIF

   nPictWidth := ROUND( nWidth * nKoef, 0 )
   nPictHeight := ROUND( nHeight * nKoef, 0 )

   //    nShowX := nPictWidth
   //    nShowY := nPictHeight

   ImageEdit.Width := nPictWidth + GetBorderWidth() + 4
   ImageEdit.Height := nPictHeight + GetTitleHeight() + GetBorderHeight() + GetMenuBarHeight() + 60

   IF ImageEdit.Width < 400
      ImageEdit.Width := 400
   ENDIF
   IF ImageEdit.Height < 100
      ImageEdit.Height := 100
   ENDIF

   //    ImageEdit.Title := cFileNoPath( cFile ) + ' - ' + PROGRAM + IF( nKoef # 1, " (Zoom: " + hb_ntos( nPictWidth ) + " x " + hb_ntos( nPictHeight ) + ")", "" )
   //    ImageEdit.StatusBar.Item( 3 ) := STR( nKoef * 100, 4 ) + " %"
   //    InvalidateRect( ImageEdit.Handle, 0 )

   ImageEdit.Center

RETURN NIL

*+ EOF: VIEWER.PRG
