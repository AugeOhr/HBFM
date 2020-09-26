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
*+
*+    Reformatted by Click! 2.05.34 on Sep-26-2020 at  5:14 am
*+
*+--------------------------------------------------------------------

#include "HMG.CH"
#include "common.CH"

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
   lActiveMain = .T.
   EventRemove( nIndex )

   //   RELEASE MEMORY

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
   lActiveMain = .T.
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
FUNCTION Image_Edit( cFile, nTimeout )

LOCAL nRet      := 0
LOCAL nwide     := 0
LOCAL nheight   := 0
LOCAL nTitlebar := GETTITLEHEIGHT()
LOCAL nBorder   := GETBORDERWIDTH()

STATIC lRunning := .F.

   DEFAULT nTimeout TO 0

   IF lRunning = .T.
      RETURN nil
   ENDIF
   lRunning := .T.
   //    IF !isWindowDefined(ImageEdit)

   lActiveMain = .F.

   SetCursorWait( "WinLeft", .T. )
   SetCursorWait( "WinRight", .T. )
   DO EVENTS

   DEFINE WINDOW ImageEdit ;
      AT 249, 410 ;
      WIDTH nwide ;
      HEIGHT nheight + nTitlebar ;
      TITLE cFile ;
      TOPMOST ;
      ON INIT DoBMPResize( ThisWindow.Name, "Image_Edit" ) ;
      ON SIZE DoBMPResize( ThisWindow.Name, "Image_Edit" ) ;
      ON MAXIMIZE DoBMPResize( ThisWindow.Name, "Image_Edit" ) ;
      ON RELEASE ImageRelease( cFile ) ;
      BACKCOLOR SP_nColor1()

   DEFINE IMAGE Image_Edit
      ROW 0
      COL 0
      WIDTH 0
      HEIGHT 0
      PICTURE cFile
      VISIBLE .T.
      STRETCH .T.
   END IMAGE

   END WINDOW

   nwide := ImageEdit.Image_Edit.Width
   nheight := ImageEdit.Image_Edit.Height

   ImageEdit.Width := nwide + 4
   ImageEdit.Height := nheight + nTitlebar + ( 2 * nBorder )

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

   SetCursorWait( "WinLeft", .F. )
   SetCursorWait( "WinRight", .F. )
   DO EVENTS

   CENTER WINDOW ImageEdit
   ImageEdit.Image_Edit.setfocus()
   ACTIVATE WINDOW ImageEdit

   lRunning := .F.
   lActiveMain = .T.

RETURN nRet

*+--------------------------------------------------------------------
*+
*+    Static Procedure ImageRelease()
*+
*+    Called from ( viewer.prg )   1 - function image_edit()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ImageRelease( cFile )

   //    Domethod( "ImageEdit", "Image_Edit", "PICTURE", "" )
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
*+    Called from ( viewer.prg )   3 - function image_edit()
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

   Domethod( cForm, "hide" )

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
   //    SendMessage(hRtf,EM_SCROLLCARET,0,0)
   nSelStart := GetProperty( cForm, cObj, "CaretPos" )
   //   nRow := SendMessage(hRtf, EM_LINEFROMCHAR, nSelStart , 0)
   nRow := SendMessage( hRtf, EM_EXLINEFROMCHAR, 0, nSelStart )
   nCol := nSelStart - SendMessage( hRtf, EM_LINEINDEX, nRow, 0 )

RETURN ( { nRow + 1, nCol } )

*+ EOF: VIEWER.PRG
