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
*+               Static Function PictInfo()
*+
*+    Reformatted by Click! 2.05.34 on Sep-28-2020 at  3:25 am
*+
*+--------------------------------------------------------------------

#include "HMG.CH"
#include "common.CH"

#define Use_FreeImage .T.
#IFDEF Use_FreeImage
#include "freeimage.ch"
#ENDIF

#define WM_USER                  1024
#define EM_LINEINDEX             187
#define EM_LINEFROMCHAR          201
#define EM_SCROLLCARET           ( WM_USER + 49 )
#define EM_EXLINEFROMCHAR        ( WM_USER + 54 )

#define BMP_INFO_WIDTH           0
#define BMP_INFO_HEIGHT          1
#define BMP_INFO_BITSPIXEL       2

#define OFFSET_DLG               30

STATIC cLastSeek  := ""
STATIC cReplace   := ""
STATIC lDown      := .T.
STATIC lWholeWord := .F.
STATIC lMatchCase := .F.
STATIC lChanged   := .F.

MEMVAR _HMG_SYSDATA, lActiveMain

*+--------------------------------------------------------------------
*+
*+    Procedure TXT_Edit()
*+
*+    Called from ( fmgrid.prg )   3 - static procedure dataviewer()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE TXT_Edit( cFile, lEdit )

LOCAL nIndex := 0
LOCAL cMemo  := " "

STATIC lRunning := .F.

   DEFAULT lEdit TO .F.

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

            RTFEdit.RTFCtrl.VALUE := ""
         ENDIF
      ENDIF
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Function Image_Edit()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure dataviewer()
*+                                   1 - static procedure slideshow()
*+                ( thumbs.prg )   1 - static procedure doshow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Image_Edit( cPath, cFile, nTimeout, lEdit )

LOCAL nMode, fname, clone
LOCAL nRatio, nWidth, nHeight, nW, nH
LOCAL handle, cSaveFile, aRect, nScrWidth, nScrHeight, nWidthOrig, nHeightOrig
LOCAL nTitlebar := GETTITLEHEIGHT()
LOCAL nBorder   := GETBORDERWIDTH()

STATIC lRunning := .F.

   DEFAULT nTimeout TO 0
   DEFAULT lEdit TO .F.

   IF lRunning = .T.
      RETURN nil
   ENDIF
   lRunning := .T.
   lActiveMain := .F.

   // #IFDEF Use_FreeImage
   //    IF FILE( 'FreeImage.Dll' ) .OR. FILE( 'FreeImage64.Dll' )
   //       FREE_Initialise()
   //       //  MsgInfo( Var2char( FREE_GetVersion() ) )
   //    ELSE
   //       MsgInfo( "Can't found the FreeImage.Dll" )
   //       RETURN NIL
   //    ENDIF
   // #ENDIF

   aRect := GetDesktopArea()
   nScrWidth := aRect[ 3 ] - aRect[ 1 ]
   nScrHeight := aRect[ 4 ] - aRect[ 2 ]

   DEFINE WINDOW ImageEdit ;
      AT 249, 410 ;
      WIDTH 0 ;
      HEIGHT 0 ;
      TITLE cPath + cFile ;
      TOPMOST ;
      ON INIT nil ;
      ON SIZE DoBMPResize( ThisWindow.Name, "Image_Edit" ) ;
      ON MAXIMIZE DoBMPResize( ThisWindow.Name, "Image_Edit" ) ;
      ON GOTFOCUS ImageEdit.Image_Edit.setfocus() ;
      ON RELEASE ImageRelease( cPath + cFile ) ;
      BACKCOLOR SP_nColor1()

   DEFINE CONTEXT MENU OF ImageEdit
      IF lEdit = .T.
         MENUITEM "rotate &right" IMAGE "MYROTATER16" ACTION ViewRotate( - 90, cPath, cFile )
         MENUITEM "rotate &left" IMAGE "MYROTATEL16" ACTION ViewRotate( 90, cPath, cFile )
         SEPARATOR
         MENUITEM "rotate 180" ACTION ViewRotate( 180, cPath, cFile )
         SEPARATOR
      ELSE
      ENDIF
      MENUITEM "Pic Info" IMAGE "MYINFO16" ACTION PictInfo( cPath, cFile, nWidthOrig, nHeightOrig )
   END MENU

   DEFINE IMAGE Image_Edit
      ROW 0
      COL 0
      WIDTH 0
      HEIGHT 0
      PICTURE nil
      VISIBLE .T.
      STRETCH .T.
   END IMAGE

   END WINDOW

   ALTD()

   cSaveFile := GetTempFolder() + "FI_" + cFile + ".bmp"

   fname := cPath + cFile

   handle := FREE_Load( FREE_GetFileType( fname, 0 ), fname, 0 )

   nWidth := FREE_GetWidth( handle )
   nHeight := FREE_GetHeight( handle )
   nRatio := nWidth / nHeight

   nWidthOrig := nWidth
   nHeightOrig := nHeight

   nMode := IF( nWidth < nScrWidth .AND. nHeight < nScrHeight, 0, 2 )

   IF nWidth > nScrWidth .OR. nHeight > nScrHeight                    // .OR. nWidthOrig >= nScrWidth .OR. nHeightOrig >= nScrHeight
      nW := nScrWidth
      nH := nScrHeight
      IF nRatio >= 1
         nH := ROUND( nHeight * ( 10 * nW / nWidth ) / 10, 0 )
      ELSE
         nW := ROUND( nWidth * ( 10 * nH / nHeight ) / 10, 0 )
      ENDIF
      nWidth := nW
      nHeight := nH
      clone := FREE_Clone( handle )
      FREE_Unload( handle )
      handle := FREE_Rescale( clone, nWidth, nHeight, FILTER_BICUBIC )
      FREE_Unload( clone )
   ENDIF

   FREE_Save( FIF_BMP, handle, cSaveFile, BMP_DEFAULT )
   FREE_Unload( handle )

   SetProperty( "ImageEdit", "Width", nWidth )
   SetProperty( "ImageEdit", "Height", nHeight )
   SetProperty( "ImageEdit", "Image_Edit", "PICTURE", cSaveFile )

   //  ERASE WINDOW ImageEdit
   //  DrawPicture( GetFormHandle( "ImageEdit" ), cSaveFile, nMode )

   //    SetCursorWait( "WinLeft", .F. )
   //    SetCursorWait( "WinRight", .F. )
   //    DO EVENTS

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

   CENTER WINDOW ImageEdit
   //    ImageEdit.Image_Edit.setfocus()
   ACTIVATE WINDOW ImageEdit

   FERASE( cSaveFile )
   lRunning := .F.
   lActiveMain := .T.

   // #IFDEF Use_FreeImage
   //    FREE_Deinitialise()
   // #ENDIF

RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Procedure ImageRelease()
*+
*+    Called from ( viewer.prg )   1 - function image_edit()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ImageRelease( cFile )

   SetProperty( "ImageEdit", "Image_Edit", "PICTURE", nil )
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
STATIC PROCEDURE ViewRotate( nRad, cPath, cFile )

LOCAL cThumbsFile, nType
LOCAL handle, clone, new_handle

#IFDEF Use_FreeImage
   nType := FREE_GetFileType( cPath + cFile, 0 )
   handle := FREE_Load( nType, cPath + cFile, 0 )

   IF !EMPTY( handle )
      clone := FREE_Clone( handle )
      FREE_Unload( handle )
      IF !( ( new_handle := FREE_RotateClassic( clone, nRad ) ) == Nil )
         FREE_Unload( clone )
         handle := new_handle

         IF FILE( cPath + cFile )
            FERASE( cPath + cFile )
         ENDIF
         FREE_Save( FIF_BMP, handle, cPath + cFile, nType )           // BMP_DEFAULT )

         SetProperty( "ImageEdit", "Image_Edit", "PICTURE", cPath + cFile )
         FREE_Unload( handle )
      ENDIF
   ENDIF
#ENDIF

RETURN

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
STATIC PROCEDURE DoBMPResize( cForm, cObj )

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

   Setproperty( cForm, cObj, "Width", mainWidth - ( 2 * nBorder ) )
   Setproperty( cForm, cObj, "Height", mainHeight - nTitlebar - ( 2 * nBorder ) )

   Domethod( cForm, "show" )

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
*+    Static Function PictInfo()
*+
*+    Called from ( viewer.prg )   1 - function image_edit()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION PictInfo( cPath, cFile, nWidth, nHeight )

LOCAL cExt   := UPPER( cFileExt( cFile ) )
LOCAL aLabel := {}, cLabel, aText := {}, cText, n

   AADD( aLabel, "File name:" )
   AADD( aLabel, "Folder:" )
   AADD( aLabel, "Compression:" )
   AADD( aLabel, "Original size:" )
   AADD( aLabel, "Disk size:" )
   AADD( aLabel, "File date/time:" )
   //    AAdd( aLabel, "Loaded in:" )

   AADD( aText, cFile )
   AADD( aText, cPath )
   AADD( aText, cExt )
   AADD( aText, hb_ntos( nWidth ) + " x " + hb_ntos( nHeight ) + " Pixels" )
   AADD( aText, hb_ntos( FILESIZE( cPath + cFile ) / 1024 ) + " KB" )
   AADD( aText, DTOC( FILEDATE( cPath + cFile ) ) )

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

   CENTER WINDOW Form_Info

   ACTIVATE WINDOW Form_Info

   ImageEdit.setfocus()

RETURN NIL

*+ EOF: VIEWER.PRG
