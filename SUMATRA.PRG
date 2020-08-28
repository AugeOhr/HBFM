*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\SUMATRA.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Function Sumatra_FileOpen()
*+               Function Sumatra_FileClose()
*+               Function Sumatra_FileName()
*+               Function Sumatra_FileSaveAs()
*+               Function Sumatra_FilePrint()
*+               Function Sumatra_FileProperties()
*+               Function Sumatra_FrameHandle()
*+               Function Sumatra_FrameAdjust()
*+               Function Sumatra_FrameRedraw()
*+               Function Sumatra_Bookmarks()
*+               Function Sumatra_BookmarksHandle()
*+               Function Sumatra_BookmarksExist()
*+               Function Sumatra_BookmarksExpand()
*+               Function Sumatra_Toolbar()
*+               Function Sumatra_ToolbarHandle()
*+               Function Sumatra_PageGoTo()
*+               Function Sumatra_PageNumber()
*+               Function Sumatra_PageCount()
*+               Function Sumatra_FindText()
*+               Function Sumatra_SelectAll()
*+               Function Sumatra_GetSelText()
*+               Function Sumatra_Zoom()
*+               Function Sumatra_Rotate()
*+               Function Sumatra_View()
*+               Function Sumatra_About()
*+
*+    Reformatted by Click! 2.05.30 on Aug-28-2020 at  1:53 am
*+
*+--------------------------------------------------------------------

/*

  SumatraPDF.prg
  Library functions for handling SumatraPDF reader in plugin mode
  Version: 2018-07-25
  Author:  KDJ

  Designed for SumatraPDF ver. 3.1.2
  https://www.sumatrapdfreader.org

  Compile to library libSumatraPDF.a or include SumatraPDF.prg into your project

  Contains functions:
    Sumatra_FileOpen
    Sumatra_FileClose
    Sumatra_FileName
    Sumatra_FileSaveAs
    Sumatra_FilePrint
    Sumatra_FileProperties
    Sumatra_FrameHandle
    Sumatra_FrameAdjust
    Sumatra_FrameRedraw
    Sumatra_Bookmarks
    Sumatra_BookmarksHandle
    Sumatra_BookmarksExist
    Sumatra_BookmarksExpand
    Sumatra_Toolbar
    Sumatra_ToolbarHandle
    Sumatra_PageGoTo
    Sumatra_PageNumber
    Sumatra_PageCount
    Sumatra_FindText
    Sumatra_SelectAll
    Sumatra_GetSelText
    Sumatra_Zoom
    Sumatra_Rotate
    Sumatra_View
    Sumatra_About
    GetWindowText2

*/

#include "hmg.ch"

/*
  Sumatra_FileOpen(cPanel, cPdfFile, [nPage], [nZoom], [nView], [lBookmarks], [lToolbar], [cLanguage], [cSumatraPDFExe])
    nZoom can be:
      2 - fit page
      3 - actual (real) size
      4 - fit width (default)
  --> >0 - if no error, page number of cPdfFile is returned
  -->  0 - if error loading cPdfFile occurs
  --> -1 - if cPanel window is not defined
  --> -2 - if SumatraPDF executable file not found
  --> -3 - if cPdfFile does not exist
*/

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_FileOpen()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_FileOpen( cPanel, cPdfFile, nPage, nZoom, nView, lBookmarks, lToolbar, cLang, cExeFile )

LOCAL nHFrame
LOCAL cZoom
LOCAL cView

   IF !_IsWindowDefined( cPanel )
      RETURN - 1
   ENDIF

   IF ( !HB_IsChar( cExeFile ) ) .OR. EMPTY( cExeFile )
      cExeFile := HB_DirBase() + "SumatraPDF.exe"
   ENDIF

   IF !HB_FileExists( cExeFile )
      RETURN - 2
   ENDIF

   IF ( !HB_IsChar( cPdfFile ) ) .OR. ( VolSerial( HB_ULeft( cPdfFile, 3 ) ) == - 1 ) .OR. ( !HB_FileExists( cPdfFile ) )
      RETURN - 3
   ENDIF

   IF ( !HB_IsNumeric( nPage ) ) .OR. ( nPage < 1 )
      nPage := 1
   ENDIF

   HB_Default( @nZoom, 4 )
   HB_Default( @nView, 1 )
   HB_Default( @cLang, "en" )

   DO CASE
      CASE nZoom = 2
         cZoom := '"fit page"'
      CASE nZoom = 3
         cZoom := '"actual size"'
      OTHERWISE
         cZoom := '"fit width"'
   ENDCASE

   DO CASE
      CASE nView = 2
         cView := '"continuous facing"'
      CASE nView = 3
         cView := '"continuous book view"'
      OTHERWISE
         cView := '"continuous single page"'
   ENDCASE

   IF Sumatra_FrameHandle( cPanel ) != 0
      Sumatra_FileClose( cPanel )
   ENDIF

   ShellExecute( 0, 'open', cExeFile, '-page ' + HB_NtoS( nPage ) + ' -lang ' + cLang + ' -zoom ' + cZoom + ' -view ' + cView + ' -plugin ' + HB_NtoS( GetFormHandle( cPanel ) ) + ' "' + cPdfFile + '"', NIL, 10 /*SW_SHOWDEFAULT*/ )

   DO WHILE ( ( nHFrame := Sumatra_FrameHandle( cPanel ) ) == 0 ) .OR. ( Sumatra_ToolbarHandle( cPanel ) == 0 ) .OR. ( Sumatra_BookmarksHandle( cPanel ) == 0 )
      HB_IdleSleep( 0.01 )
   ENDDO

   Sumatra_Toolbar( cPanel, lToolbar )
   SendMessage( nHFrame, 273 /*WM_COMMAND*/, 417 /*IDM_VIEW_BOOKMARKS*/, 0 )
   Sumatra_Bookmarks( cPanel, lBookmarks )

   IF nPage > Sumatra_PageCount( cPanel )
      Sumatra_PageGoTo( cPanel, 2 /*last page*/ )
   ENDIF

   SetWindowText( nHFrame, cPdfFile )

RETURN Sumatra_PageNumber( cPanel )

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_FileClose()
*+
*+    Called from ( sumatra.prg )   1 - function sumatra_fileopen()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_FileClose( cPanel, lRedraw )

LOCAL nHFrame := Sumatra_FrameHandle( cPanel )
LOCAL nHPanel
LOCAL nPID

   IF nHFrame != 0
      nHPanel := GetFormHandle( cPanel )
      EnableWindowRedraw( nHPanel, .F. )

      GetWindowThreadProcessId( nHFrame, NIL, @nPID )
      TerminateProcess( nPID )

      DO WHILE IsValidWindowHandle( nHFrame )
      ENDDO

      EnableWindowRedraw( nHPanel, .T., lRedraw )
   ENDIF

RETURN NIL

//Sumatra_FileName(cPanel) --> name of opened PDF file or empty string

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_FileName()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_FileName( cPanel )

LOCAL nHFrame := Sumatra_FrameHandle( cPanel )

   IF nHFrame != 0
      RETURN GetWindowText( nHFrame )
   ENDIF

RETURN ""

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_FileSaveAs()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_FileSaveAs( cPanel )

LOCAL nHFrame := Sumatra_FrameHandle( cPanel )

   IF nHFrame != 0
      PostMessage( nHFrame, 273 /*WM_COMMAND*/, 402 /*IDM_SAVEAS*/, 0 )
   ENDIF

RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_FilePrint()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_FilePrint( cPanel )

LOCAL nHFrame := Sumatra_FrameHandle( cPanel )

   IF nHFrame != 0
      PostMessage( nHFrame, 273 /*WM_COMMAND*/, 403 /*IDM_PRINT*/, 0 )
   ENDIF

RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_FileProperties()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_FileProperties( cPanel )

LOCAL nHFrame := Sumatra_FrameHandle( cPanel )

   IF nHFrame != 0
      PostMessage( nHFrame, 273 /*WM_COMMAND*/, 409 /*IDM_PROPERTIES*/, 0 )
   ENDIF

RETURN NIL

//Sumatra_FrameHandle(cPanel) --> handle to Sumatra frame embeded in panel or 0 if no frame

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_FrameHandle()
*+
*+    Called from ( sumatra.prg )   2 - function sumatra_fileopen()
*+                                   1 - function sumatra_fileclose()
*+                                   1 - function sumatra_filename()
*+                                   1 - function sumatra_filesaveas()
*+                                   1 - function sumatra_fileprint()
*+                                   1 - function sumatra_fileproperties()
*+                                   1 - function sumatra_frameadjust()
*+                                   1 - function sumatra_frameredraw()
*+                                   1 - function sumatra_bookmarks()
*+                                   1 - function sumatra_bookmarkshandle()
*+                                   1 - function sumatra_toolbar()
*+                                   1 - function sumatra_toolbarhandle()
*+                                   1 - function sumatra_pagegoto()
*+                                   1 - function sumatra_pagenumber()
*+                                   1 - function sumatra_pagecount()
*+                                   1 - function sumatra_findtext()
*+                                   1 - function sumatra_selectall()
*+                                   1 - function sumatra_getseltext()
*+                                   1 - function sumatra_zoom()
*+                                   1 - function sumatra_rotate()
*+                                   1 - function sumatra_view()
*+                                   1 - function sumatra_about()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_FrameHandle( cPanel )

   IF _IsWindowDefined( cPanel )
      RETURN FindWindowEx( GetFormHandle( cPanel ), 0, "SUMATRA_PDF_FRAME", 0 )
   ENDIF

RETURN 0

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_FrameAdjust()
*+
*+    Called from ( viewer.prg )   1 - static procedure dopdfresize()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_FrameAdjust( cPanel )

LOCAL nHFrame := Sumatra_FrameHandle( cPanel )

   IF nHFrame != 0
      SetWindowPos( nHFrame, 0, 0, 0, GetProperty( cPanel, "CLIENTAREAWIDTH" ), GetProperty( cPanel, "CLIENTAREAHEIGHT" ), 0x0016 /*SWP_NOACTIVATE|SWP_NOZORDER|SWP_NOMOVE*/ )
   ENDIF

RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_FrameRedraw()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_FrameRedraw( cPanel )

LOCAL nHFrame := Sumatra_FrameHandle( cPanel )

   IF nHFrame != 0
      RedrawWindow( nHFrame )
   ENDIF

RETURN NIL

//Sumatra_Bookmarks(cPanel, [lShow]) - show/hide Sumatra bookmarks
//--> previous setting

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_Bookmarks()
*+
*+    Called from ( sumatra.prg )   1 - function sumatra_fileopen()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_Bookmarks( cPanel, lShow )

LOCAL lVisible := .F.
LOCAL nHFrame  := Sumatra_FrameHandle( cPanel )

   IF nHFrame != 0
      lVisible := IsWindowVisible( Sumatra_BookmarksHandle( cPanel ) )

      IF HB_IsLogical( lShow )
         IF ( lShow != lVisible ) .AND. Sumatra_BookmarksExist( cPanel )
            SendMessage( nHFrame, 273 /*WM_COMMAND*/, 417 /*IDM_VIEW_BOOKMARKS*/, 0 )
         ENDIF
      ENDIF
   ENDIF

RETURN lVisible

//Sumatra_BookmarksHandle(cPanel) --> handle to Sumatra bookmarks tree

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_BookmarksHandle()
*+
*+    Called from ( sumatra.prg )   1 - function sumatra_fileopen()
*+                                   1 - function sumatra_bookmarks()
*+                                   1 - function sumatra_bookmarksexist()
*+                                   1 - function sumatra_bookmarksexpand()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_BookmarksHandle( cPanel )

LOCAL nHFrame := Sumatra_FrameHandle( cPanel )
LOCAL aHWnd
LOCAL n

   IF nHFrame != 0
      aHWnd := EnumChildWindows( nHFrame )

      FOR n := 1 TO LEN( aHWnd )
         IF ( GetClassName( aHWnd[ n ] ) == "SysTreeView32" ) .AND. ( GetWindowText2( aHWnd[ n ] ) == "TOC" )
            RETURN aHWnd[ n ]
         ENDIF
      NEXT
   ENDIF

RETURN 0

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_BookmarksExist()
*+
*+    Called from ( sumatra.prg )   1 - function sumatra_bookmarks()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_BookmarksExist( cPanel )

LOCAL lExist := .F.
LOCAL nHBook := Sumatra_BookmarksHandle( cPanel )

   IF nHBook != 0
      lExist := ( SendMessage( nHBook, 4357 /*TVM_GETCOUNT*/, 0, 0 ) != 0 )
   ENDIF

RETURN lExist

//Sumatra_BookmarksExpand(cPanel, lExpand) - expand or collapse all items in bookmarks tree

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_BookmarksExpand()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_BookmarksExpand( cPanel, lExpand )

LOCAL nHBook  := Sumatra_BookmarksHandle( cPanel )
LOCAL nHItem
LOCAL nExpand

   IF IsWindowVisible( nHBook )
      nHItem := TreeView_GetRoot( nHBook )
      nExpand := IF( lExpand, 2 /*TVE_EXPAND*/, 1 /*TVE_COLLAPSE*/ )

      DO WHILE nHItem != 0
         TreeView_ExpandChildrenRecursive( nHBook, nHItem, nExpand, .T. )
         nHItem := TreeView_GetNextSibling( nHBook, nHItem )
      ENDDO

      SendMessage( nHBook, 4372 /*TVM_ENSUREVISIBLE*/, 0, TreeView_GetSelection( nHBook ) )
   ENDIF

RETURN NIL

//Sumatra_Toolbar(cPanel, [lShow]) - show/hide Sumatra toolbar
//--> previous setting

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_Toolbar()
*+
*+    Called from ( sumatra.prg )   1 - function sumatra_fileopen()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_Toolbar( cPanel, lShow )

LOCAL lVisible := .F.
LOCAL nHFrame  := Sumatra_FrameHandle( cPanel )

   IF nHFrame != 0
      lVisible := IsWindowVisible( Sumatra_ToolbarHandle( cPanel ) )

      IF HB_IsLogical( lShow )
         IF lShow != lVisible
            SendMessage( nHFrame, 273 /*WM_COMMAND*/, 419 /*IDM_VIEW_SHOW_HIDE_TOOLBAR*/, 0 )
         ENDIF
      ENDIF
   ENDIF

RETURN lVisible

//Sumatra_ToolbarHandle(cPanel) --> handle to Sumatra toolbar

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_ToolbarHandle()
*+
*+    Called from ( sumatra.prg )   1 - function sumatra_fileopen()
*+                                   1 - function sumatra_toolbar()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_ToolbarHandle( cPanel )

LOCAL nHFrame := Sumatra_FrameHandle( cPanel )
LOCAL nHReBar

   IF nHFrame != 0
      nHReBar := FindWindowEx( nHFrame, 0, "ReBarWindow32", 0 )

      IF nHReBar != 0
         RETURN FindWindowEx( nHReBar, 0, "ToolbarWindow32", 0 )
      ENDIF
   ENDIF

   RETURN 0

   /*
  nAction:
  -1 - go to previous page
   1 - go to next page
  -2 - go to first page
   2 - go to last page
  otherwise - "Go to" dialog
*/

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_PageGoTo()
*+
*+    Called from ( sumatra.prg )   1 - function sumatra_fileopen()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_PageGoTo( cPanel, nAction )

LOCAL nHFrame := Sumatra_FrameHandle( cPanel )
LOCAL nWParam

   IF nHFrame != 0
      HB_Default( @nAction, 0 )

      DO CASE
         CASE nAction = - 1
            nWParam := 431 /*IDM_GOTO_PREV_PAGE*/
         CASE nAction = 1
            nWParam := 430 /*IDM_GOTO_NEXT_PAGE*/
         CASE nAction = - 2
            nWParam := 432 /*IDM_GOTO_FIRST_PAGE*/
         CASE nAction = 2
            nWParam := 433 /*IDM_GOTO_LAST_PAGE*/
         OTHERWISE
            nWParam := 434 /*IDM_GOTO_PAGE*/
      ENDCASE

      PostMessage( nHFrame, 273 /*WM_COMMAND*/, nWParam, 0 )
   ENDIF

   RETURN NIL

   /*
  Get current PDF page number
  Returns 0 if error loading occurs
*/

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_PageNumber()
*+
*+    Called from ( sumatra.prg )   1 - function sumatra_fileopen()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_PageNumber( cPanel )

LOCAL nPage   := 0
LOCAL nHFrame := Sumatra_FrameHandle( cPanel )
LOCAL nHReBar
LOCAL aHWnd

LOCAL cText
LOCAL nPos
LOCAL n

   IF nHFrame != 0
      nHReBar := FindWindowEx( nHFrame, 0, "ReBarWindow32", 0 )

      IF nHReBar != 0
         aHWnd := EnumChildWindows( nHReBar )

         FOR n := 1 TO LEN( aHWnd )
            IF ( GetClassName( aHWnd[ n ] ) == "Static" )
               cText := GetWindowText2( aHWnd[ n ] )
               nPos := HB_UAt( "(", cText )

               IF nPos > 0
                  nPage := VAL( SUBSTR( cText, nPos + 1 ) )
                  EXIT
               ENDIF
            ENDIF
         NEXT

         IF nPage == 0
            FOR n := 1 TO LEN( aHWnd )
               IF ( GetClassName( aHWnd[ n ] ) == "Edit" ) .AND. ( HB_BitAnd( GetWindowLongPtr( aHWnd[ n ], - 16 /*GWL_STYLE*/ ), 0x2002 /*ES_NUMBER|ES_RIGHT*/ ) != 0 )
                  nPage := VAL( GetWindowText2( aHWnd[ n ] ) )
                  EXIT
               ENDIF
            NEXT
         ENDIF
      ENDIF
   ENDIF

   RETURN nPage

   /*
  Get page count in opened PDF
  Returns 0 if error loading occurs
*/

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_PageCount()
*+
*+    Called from ( sumatra.prg )   1 - function sumatra_fileopen()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_PageCount( cPanel )

LOCAL nCount  := 0
LOCAL nHFrame := Sumatra_FrameHandle( cPanel )
LOCAL nHReBar
LOCAL aHWnd
LOCAL cText
LOCAL nPos
LOCAL n

   IF nHFrame != 0
      nHReBar := FindWindowEx( nHFrame, 0, "ReBarWindow32", 0 )

      IF nHReBar != 0
         aHWnd := EnumChildWindows( nHReBar )

         FOR n := 1 TO LEN( aHWnd )
            IF ( GetClassName( aHWnd[ n ] ) == "Static" )
               cText := GetWindowText2( aHWnd[ n ] )
               nPos := HB_UAt( "/", cText )

               IF nPos > 0
                  nCount := VAL( SUBSTR( cText, nPos + 1 ) )
                  EXIT
               ENDIF
            ENDIF
         NEXT

      ENDIF
   ENDIF

   RETURN nCount

   /*
  nAction:
  -1 - find previous
   1 - find next
  otherwise - "Find" dialog
*/

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_FindText()
*+
*+    Called from ( viewer.prg )   1 - static procedure dopdfsearch()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_FindText( cPanel, nAction )

LOCAL nHFrame := Sumatra_FrameHandle( cPanel )
LOCAL nWParam

   IF nHFrame != 0
      HB_Default( @nAction, 0 )

      DO CASE
         CASE nAction = - 1
            nWParam := 437 /*IDM_FIND_PREV*/
         CASE nAction = 1
            nWParam := 436 /*IDM_FIND_NEXT*/
         OTHERWISE
            nWParam := 435 /*IDM_FIND_FIRST*/
      ENDCASE

      PostMessage( nHFrame, 273 /*WM_COMMAND*/, nWParam, 0 )
   ENDIF

RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_SelectAll()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_SelectAll( cPanel )

LOCAL nHFrame := Sumatra_FrameHandle( cPanel )

   IF nHFrame != 0
      SendMessage( nHFrame, 273 /*WM_COMMAND*/, 422 /*IDM_SELECT_ALL*/, 0 )
   ENDIF

RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_GetSelText()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_GetSelText( cPanel )

LOCAL cText   := ""
LOCAL nHFrame := Sumatra_FrameHandle( cPanel )
LOCAL cClip

   IF nHFrame != 0
      cClip := GetClipboard()

      SetClipboard( cText )
      SendMessage( nHFrame, 273 /*WM_COMMAND*/, 420 /*IDM_COPY_SELECTION*/, 0 )

      cText := GetClipboard()

      SetClipboard( cClip )
   ENDIF

   RETURN cText

   /*
  nAction:
  -1 - size down
   1 - size up
   2 - fit page
   3 - real size
   4 - fit width
  otherwise - "Zoom factor" dialog
*/

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_Zoom()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_Zoom( cPanel, nAction )

LOCAL nHFrame := Sumatra_FrameHandle( cPanel )

   IF nHFrame != 0
      HB_Default( @nAction, 0 )

      DO CASE
         CASE nAction = - 1
            SendMessage( nHFrame, 273 /*WM_COMMAND*/, 3013 /*IDT_VIEW_ZOOMOUT*/, 0 )
         CASE nAction = 1
            SendMessage( nHFrame, 273 /*WM_COMMAND*/, 3012 /*IDT_VIEW_ZOOMIN*/, 0 )
         CASE nAction = 2
            SendMessage( nHFrame, 273 /*WM_COMMAND*/, 3026 /*IDT_VIEW_FIT_WIDTH*/, 0 )
            SendMessage( nHFrame, 273 /*WM_COMMAND*/, 440 /*IDM_ZOOM_FIT_PAGE*/, 0 )
         CASE nAction = 3
            SendMessage( nHFrame, 273 /*WM_COMMAND*/, 3026 /*IDT_VIEW_FIT_WIDTH*/, 0 )
            SendMessage( nHFrame, 273 /*WM_COMMAND*/, 441 /*IDM_ZOOM_ACTUAL_SIZE*/, 0 )
         CASE nAction = 4
            SendMessage( nHFrame, 273 /*WM_COMMAND*/, 3026 /*IDT_VIEW_FIT_WIDTH*/, 0 )
         OTHERWISE
            PostMessage( nHFrame, 273 /*WM_COMMAND*/, 457 /*IDM_ZOOM_CUSTOM*/, 0 )
      ENDCASE
   ENDIF

   RETURN NIL

   /*
  nAction:
  -1 - rotate left
   1 - rotate right
  otherwise - rotate 180°
*/

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_Rotate()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_Rotate( cPanel, nAction )

LOCAL nHFrame := Sumatra_FrameHandle( cPanel )
LOCAL nWParam

   IF nHFrame != 0
      HB_Default( @nAction, 0 )

      IF nAction == - 1
         nWParam := 415 /*IDM_VIEW_ROTATE_LEFT*/
      ELSE
         nWParam := 416 /*IDM_VIEW_ROTATE_RIGHT*/
      ENDIF

      SendMessage( nHFrame, 273 /*WM_COMMAND*/, nWParam, 0 )

      IF nAction == 0
         SendMessage( nHFrame, 273 /*WM_COMMAND*/, nWParam, 0 )
      ENDIF
   ENDIF

   RETURN NIL

   /*
  nAction:
   1 - single page (default)
   2 - facing (two pages)
   3 - book view
*/

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_View()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_View( cPanel, nAction )

LOCAL nHFrame := Sumatra_FrameHandle( cPanel )
LOCAL nWParam

   IF nHFrame != 0
      HB_Default( @nAction, 1 )

      DO CASE
         CASE nAction = 1
            nWParam := 410 /*IDM_VIEW_SINGLE_PAGE*/
         CASE nAction = 2
            nWParam := 411 /*IDM_VIEW_FACING*/
         OTHERWISE
            nWParam := 412 /*IDM_VIEW_BOOK*/
      ENDCASE

      SendMessage( nHFrame, 273 /*WM_COMMAND*/, nWParam, 0 )
   ENDIF

RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Function Sumatra_About()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Sumatra_About( cPanel )

LOCAL nHFrame := Sumatra_FrameHandle( cPanel )

   IF nHFrame != 0
      PostMessage( nHFrame, 273 /*WM_COMMAND*/, 551 /*IDM_ABOUT*/, 0 )
   ENDIF

RETURN NIL

*+ EOF: SUMATRA.PRG
