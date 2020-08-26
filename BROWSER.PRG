*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\BROWSER.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Static Procedure InitMultiBrowse()
*+               Procedure BrowseView()
*+               Static Procedure DoFindSelf()
*+               Static Procedure MultiBrowseRelease()
*+               Static Procedure DoResize()
*+               Function USE_MYDBF()
*+               Static Function DbeFileType()
*+               Static Function DbfDetail()
*+               Function TNR2STR()
*+               Static Procedure EditDetail()
*+               Static Procedure RefreshCurrent()
*+               Static Procedure DoChange()
*+               Static Procedure MakeFMG()
*+               Static Procedure Pre_SetNewIndex()
*+               Static Procedure SetNewIndex()
*+               Static Procedure DoMyIndexAction()
*+               Static Procedure DoSeek()
*+               Static Procedure CopyResult()
*+               Static Procedure DoScope()
*+               Static Procedure Dolocate()
*+               Static Procedure DoSwitchTags()
*+               Static Procedure DoMySwitchTags()
*+               Static Procedure Do_Modi_Stru()
*+               Static Procedure CalcNewBroGridSize()
*+               Procedure DBF_EditStruRec()
*+               Static Procedure SaveCreate()
*+               Static Procedure CloseForm2()
*+               Static Function AtInside()
*+               Procedure DoFindWin()
*+               Static Function NeedOEMConvert()
*+               Static Procedure ThisDbfInfo()
*+               Static Procedure QueryTest()
*+               Static Procedure DoDebbbuug()
*+               Static Procedure SelecLang()
*+               Function WinCodePage()
*+               Static Procedure DoCreateIndex()
*+               Static Procedure SetThisField()
*+               Static Procedure CreateNewIndex()
*+               Static Procedure SetDbfFilter()
*+               Static Procedure RefreshBrowseLine()
*+               Static Procedure AddNewRecord()
*+               Static Procedure DelThisRecord()
*+               Static Procedure ShowDelete()
*+               Procedure BroSbar()
*+
*+       Tables: USE (cDBF) VIA "DBFNTX" NEW EXCLUSIVE
*+               USE (cDBF) VIA "DBFNTX" NEW SHARE
*+               USE (cDBF) VIA "DBFNTX" NEW
*+               USE (cDBF) VIA "DBFCDX" NEW EXCLUSIVE
*+               USE (cDBF) VIA "DBFCDX" NEW SHARE
*+               USE (cDBF) VIA "DBFCDX" NEW
*+               USE (cPath+cDBF) VIA (cVia) EXCLUSIVE CODEPAGE (cCodepage)
*+
*+      Indexes: INDEX ON &cKey TO &cFile ADDITIVE
*+
*+    Reformatted by Click! 2.05.30 on Aug-25-2020 at  5:15 am
*+
*+--------------------------------------------------------------------

#include "HMG.CH"
#include "Dbstruct.ch"
#include "common.ch"
#include "Directry.ch"
#include "Dll.ch"
#include "DbInfo.ch"

#define ID_Browse         1
#define ID_InArea         2
#define ID_InDBF          3
#define ID_InPath         4
#define ID_IdxActiv       5
#define ID_Index          6
#define ID_InTags         7
#define ID_InExt          8
#define ID_InStruc        9

//  { cBroMacro, cWorkArea, cDBF, cPath, .F., 0, {}, "", {} }
//
#xtranslate oBrowse       => Stack_Browse\[nDimBrowse, 1]
#xtranslate cInArea       => Stack_Browse\[nDimBrowse, 2]
#xtranslate cInDBF        => Stack_Browse\[nDimBrowse, 3]
#xtranslate cInPath       => Stack_Browse\[nDimBrowse, 4]
#xtranslate lIdxActiv     => Stack_Browse\[nDimBrowse, 5]
#xtranslate nIndex        => Stack_Browse\[nDimBrowse, 6]
#xtranslate aInTags       => Stack_Browse\[nDimBrowse, 7]
#xtranslate cInExt        => Stack_Browse\[nDimBrowse, 8]
#xtranslate cOldScope     => Stack_Browse\[nDimBrowse, 9]
#xtranslate cOldSeek      => Stack_Browse\[nDimBrowse,10]

STATIC lShare := .F.
// STATIC cOldScope := ""
// STATIC cOldSeek  := ""

STATIC Stack_Browse := {}
STATIC nDimBrowse   := 0

MEMVAR _HMG_SYSDATA
MEMVAR lActiveMain

MEMVAR aForeColorHBP, aBackColorHBP
// MEMVAR Stack_Browse
// MEMVAR nDimBrowse

*+--------------------------------------------------------------------
*+
*+    Static Procedure InitMultiBrowse()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE InitMultiBrowse()

   // PUBLIC Stack_Browse := {}
   // PUBLIC nDimBrowse   := 0
RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure BrowseView()
*+
*+    Called from ( fmgrid.prg )   2 - static procedure pre_browseview()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE BrowseView( cPath, cDBF, lEdit )

LOCAL aStruc, i, iMax, cType, a1Struc
LOCAL aHead      := {}
LOCAL aFeld      := {}
LOCAL aWide      := {}
LOCAL mainHeight := GetProperty( "Win_1", 'Height' )
LOCAL nHeight    := 1024
LOCAL nPBwide    := INT( 800 / 11 )
LOCAL aJustify   := {}
LOCAL nWide, cWorkArea, cBroMacro, nPosi
LOCAL lConvert   := .F.
LOCAL cFeld

PUBLIC aForeColorHBP
PUBLIC aBackColorHBP

   aForeColorHBP := { 255, 255, 255 }                                 //SP_nColor12()
   aBackColorHBP := { 255, 0, 0 }                                     // SP_nColor9()

   DEFAULT lEdit TO .F.

   //    IF .NOT. __MVEXIST( "Stack_Browse" )
   //       InitMultiBrowse()
   //    ENDIF

   nPosi := ASCAN( Stack_Browse, { | e | e[ ID_InDBF ] = cDBF } )
   IF nPosi > 0
      nDimBrowse := nPosi
      DoFindWin( cDBF )
      RETURN
   ENDIF

   IF FILE( cPath + cDBF )
      USE_MYDBF( cPath + cDbf, lEdit )
      cWorkArea := ALIAS()

      lConvert := SP_lOEM2ANSI()

      a1Struc := DBSTRUCT()
      PickList( a1Struc )
      DO EVENTS

      aStruc := ACLONE( SP_aDbfStruct() )
      IF EMPTY( aStruc )
         CLOSE
         MsgInfo( "must have FIELD Structure" )
         RETURN
      ENDIF

      iMax := LEN( aStruc )
      FOR i := 1 TO iMax
         AADD( aHead, aStruc[ i ] [ DBS_NAME ] )

         IF lConvert = .T.
            //  ALTD()
            // cFeld := "HB_OEMTOANSI( "+ aStruc[ i ] [ DBS_NAME ] +" )"
            // AADD( aFeld, &cFeld )

            AADD( aFeld, aStruc[ i ] [ DBS_NAME ] )
         ELSE
            AADD( aFeld, aStruc[ i ] [ DBS_NAME ] )
         ENDIF

         cType := aStruc[ i ] [ DBS_TYPE ]
         DO CASE
            CASE cType = "D"
               AADD( aWide, 80 )
               AADD( aJustify, GRID_JTFY_LEFT )

            CASE cType = "L"
               AADD( aWide, 30 )
               AADD( aJustify, GRID_JTFY_LEFT )

            OTHERWISE
               IF cType = "C"
                  AADD( aJustify, GRID_JTFY_LEFT )
               ELSEIF cType = "N"
                  AADD( aJustify, GRID_JTFY_RIGHT )
               ENDIF

               nWide := aStruc[ i ] [ DBS_LEN ]
               IF nWide < 2
                  nWide := 30
               ELSE
                  nWide := nWide * SP_nFontlarge()
               ENDIF
               AADD( aWide, nWide )
         ENDCASE
      NEXT
   ELSE
      msginfo( "File " + cPath + cDBF + " not found" )
      RETURN
   ENDIF

   cBroMacro := "Browse_" + STRZERO( LEN( Stack_Browse ), 2 )
   nPosi := ASCAN( Stack_Browse, { | e | e[ ID_Browse ] = cBroMacro } )
   IF nPosi > 0
      nDimBrowse := nPosi
      DoFindWin( cDBF )
   ELSE
      AADD( Stack_Browse, { cBroMacro, ;                              // -> oBrowse
                            cWorkArea, ;                              // -> cInArea
                            cDBF, ;                                   // -> cInDBF
                            cPath, ;                                  // -> cInPath
                            .F., ;                                    // -> lIdxActiv
                            0, ;                                      // -> nIndex
                            {}, ;                                     // -> aInTags
                            "", ;                                     // -> cInExt
                            "", ;                                     // -> cOldScope
                            "" } )                                    // -> cOldSeek
      nDimBrowse := LEN( Stack_Browse )

      // write into Stack_Browse
      //
      //  oBrowse := cBroMacro
      //  cInArea := cWorkArea
      //  cInDBF  := cDBF
      //  cInPath := cPath
      //  lIdxActiv := .F.
      nIndex := nDimBrowse
      //  aInTags := {}
      cInExt := SP_cInxExt()
      //  aInStruc := ACLONE( aStruc )

      SET NAVIGATION EXTENDED
      SET BROWSESYNC ON                                               // sync BROWSE with DBF ?
      SET AUTOSCROLL ON                                               // virtual dimensioned windows scrollbars

      DEFINE WINDOW &oBrowse ;
                 AT 371, 498 ;
                 WIDTH 800 ;
                 HEIGHT 600 ;
                 TITLE cDBF ;
                 ICON "A1MAIN" ;
                 ON SIZE DoResize( cBroMacro, "BrowserView", aStruc ) ;
                 ON MAXIMIZE DoResize( cBroMacro, "BrowserView", aStruc ) ;
                 ON GOTFOCUS DoFindSelf( ThisWindow.Name, cDBF ) ;
                 ON LOSTFOCUS WinTans( ThisWindow.Name, .F. ) ;
                 BACKCOLOR SP_nColor1()

         DEFINE STATUSBAR PARENT oBrowse
STATUSITEM "" WIDTH 800
         END STATUSBAR

#define Use_DataBrowse
#IFDEF Use_DataBrowse

         DEFINE BROWSE BrowserView
            PARENT &oBrowse
            ROW 10
            COL 10
            WIDTH 764
            HEIGHT 500 - 24
            HEADERS aHead
            WIDTHS aWide
            WORKAREA &cWorkArea
            FIELDS aFeld
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontlarge()
            TOOLTIP ""
            ON CHANGE ShowDelete( oBrowse, "BrowserView" )
            // ALLOWEDIT lEdit
            // ALLOWAPPEND lEdit
            // ALLOWDELETE lEdit
            LOCK IF( lEdit = .T., lShare, .F. )
            VSCROLLBAR .T.
            BACKCOLOR SP_nColor9()
            FONTCOLOR SP_nColor10()
            NOLINES .F.
            JUSTIFY aJustify
         END BROWSE
#ELSE
         DEFINE GRID BrowserView
            PARENT &oBrowse
            ROW 10
            COL 10
            WIDTH 764
            HEIGHT 500 - 24
            HEADERS aHead
            WIDTHS aWide
            ROWSOURCE( cWorkArea )
            COLUMNFIELDS aFeld
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontlarge()
            TOOLTIP ""
            ON CHANGE ShowDelete( oBrowse, "BrowserView" )
            // ALLOWEDIT lEdit
            ALLOWAPPEND lEdit
            ALLOWDELETE lEdit
            LOCK IF( lEdit = .T., lShare, .F. )
            VSCROLLBAR .T.
            BACKCOLOR SP_nColor9()
            FONTCOLOR SP_nColor10()
            NOLINES .F.
         END GRID
#ENDIF

         DEFINE BUTTON Button_F1
            PARENT &oBrowse
            ROW 520 - 24
            COL 0
            WIDTH nPBwide - 2
            HEIGHT 40
            ACTION ThisDbfInfo( cDBF, cWorkArea )
            CAPTION "F1 Info"
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontSize()
            TABSTOP .F.
            VISIBLE .T.
         END BUTTON

         DEFINE BUTTON Button_F2
            PARENT &oBrowse
            ROW 520 - 24
            COL nPBwide * 1
            WIDTH nPBwide - 2
            HEIGHT 40
            ACTION Do_Modi_Stru( cDBF, cWorkArea )
            CAPTION "F2 Struct"
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontSize()
            TABSTOP .F.
            VISIBLE .T.
         END BUTTON

         DEFINE BUTTON Button_F3
            PARENT &oBrowse
            ROW 520 - 24
            COL nPBwide * 2
            WIDTH nPBwide - 2
            HEIGHT 40
            ACTION EditDetail( cBroMacro, cWorkArea, cDbf, aFeld, .F. )
            CAPTION "F3 View"
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontSize()
            TABSTOP .F.
            VISIBLE .T.
         END BUTTON

         DEFINE BUTTON Button_F4
            PARENT &oBrowse
            ROW 520 - 24
            COL nPBwide * 3
            WIDTH nPBwide - 2
            HEIGHT 40
            ACTION EditDetail( cBroMacro, cWorkArea, cDbf, aFeld, lEdit )
            CAPTION "F4 Edit"
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontSize()
            TOOLTIP ""
            FLAT .F.
            TABSTOP .F.
            VISIBLE .T.
            TRANSPARENT .F.
            MULTILINE .F.
            //  PICTURE "d:\ALASKA\RES\GETMAIL.BMP"
            //  PICTALIGNMENT TOP
         END BUTTON

         DEFINE BUTTON Button_F5
            PARENT &oBrowse
            ROW 520 - 24
            COL nPBwide * 4
            WIDTH nPBwide - 2
            HEIGHT 40
            ACTION CopyResult( cPath, cDBF )
            CAPTION "Copy"
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontSize()
            TABSTOP .F.
            VISIBLE .T.
         END BUTTON

         DEFINE BUTTON Button_F6
            PARENT &oBrowse
            ROW 520 - 24
            COL nPBwide * 5
            WIDTH nPBwide - 2
            HEIGHT 40
            ACTION Pre_SetNewIndex( cPath, cDBF )
            CAPTION "F6 Index"
            TOOLTIP "Ctrl-F6 to create new Index"
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontSize()
            TABSTOP .F.
            VISIBLE .T.
         END BUTTON

         DEFINE BUTTON Button_F7
            PARENT &oBrowse
            ROW 520 - 24
            COL nPBwide * 6
            WIDTH nPBwide - 2
            HEIGHT 40
            ACTION DoSeek( cPath, cDBF, lEdit )
            CAPTION "F7 SEEK"
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontSize()
            TABSTOP .F.
            VISIBLE .T.
         END BUTTON

         DEFINE BUTTON Button_F8
            PARENT &oBrowse
            ROW 520 - 24
            COL nPBwide * 7
            WIDTH nPBwide - 2
            HEIGHT 40
            ACTION IF( lIdxActiv = .T., DoScope( cPath, cDBF, lEdit ), Dolocate( cPath, cDBF ) )
            CAPTION IF( lIdxActiv = .T., "F8 Scope", "F8 locate" )
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontSize()
            TABSTOP .F.
            VISIBLE .T.
         END BUTTON

         DEFINE BUTTON Button_F9
            PARENT &oBrowse
            ROW 520 - 24
            COL nPBwide * 8
            WIDTH nPBwide - 2
            HEIGHT 40
            ACTION IF( lIdxActiv = .T., DoSwitchTags(), )
            CAPTION "F9 IdxTags"
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontSize()
            TABSTOP .F.
            VISIBLE .T.
         END BUTTON

         DEFINE BUTTON Button_F10
            PARENT &oBrowse
            ROW 520 - 24
            COL nPBwide * 9
            WIDTH nPBwide - 2
            HEIGHT 40
            ACTION SelecLang( cPath, cDBF, cWorkArea, cBroMacro )
            CAPTION "Codepage"
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontSize()
            TABSTOP .F.
            VISIBLE .T.
         END BUTTON

         DEFINE BUTTON Button_F11
            PARENT &oBrowse
            ROW 520 - 24
            COL nPBwide * 10
            WIDTH nPBwide - 2
            HEIGHT 40
            ACTION MakeFMG( cPath + cDBF )
            CAPTION "F11 FMG"
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontSize()
            TABSTOP .F.
            VISIBLE .T.
         END BUTTON

      END WINDOW

      //       SetProperty( oBrowse, "BrowserView", "PaintDoubleBuffer", .T. )

      //  ON KEY ESCAPE OF &oBrowse ACTION Domethod( cBroMacro, "Release" )
      ON KEY ESCAPE OF &oBrowse ACTION MultiBrowseRelease( cBroMacro, cDBF )

      ON KEY F1 OF &oBrowse ACTION ThisDbfInfo( cDBF, cWorkArea )
      ON KEY F2 OF &oBrowse ACTION Do_Modi_Stru( cDBF, cWorkArea )
      ON KEY F3 OF &oBrowse ACTION EditDetail( cBroMacro, cWorkArea, cDbf, aFeld, .F. )
      IF lEdit = .T.
         ON KEY F4 OF &oBrowse ACTION EditDetail( cBroMacro, cWorkArea, cDbf, aFeld, lEdit )
      ENDIF
      ON KEY F5 OF &oBrowse ACTION CopyResult( cPath, cDBF )
      ON KEY F6 OF &oBrowse ACTION Pre_SetNewIndex( cPath, cDBF )
      ON KEY F7 OF &oBrowse ACTION IF( lIdxActiv = .T., DoSeek( cPath, cDBF, lEdit ), )
      ON KEY F8 OF &oBrowse ACTION IF( lIdxActiv = .T., DoScope( cPath, cDBF, lEdit ), Dolocate( cPath, cDBF ) )
      ON KEY F9 OF &oBrowse ACTION IF( lIdxActiv = .T., DoSwitchTags(), )

      ON KEY F10 OF &oBrowse ACTION SelecLang( cPath, cDBF, cWorkArea, cBroMacro )
      ON KEY F11 OF &oBrowse ACTION MakeFMG( cPath + cDBF )

      IF lEdit = .T.
         ON KEY INSERT OF &oBrowse ACTION AddNewRecord( oBrowse, "BrowserView", cWorkArea, cDbf, aFeld, lEdit )
         ON KEY DELETE OF &oBrowse ACTION DelThisRecord( oBrowse, "BrowserView", lEdit )
      ENDIF

      ON KEY CONTROL + F6 OF &oBrowse ACTION DoCreateIndex( cPath, cDBF, cWorkArea, aStruc, lEdit )
      ON KEY CONTROL + F8 OF &oBrowse ACTION SetDbfFilter()

      IF lEdit = .F.
         Setproperty( oBrowse, "Button_F4", "Enabled", .F. )
      ENDIF
      Setproperty( oBrowse, "Button_F7", "Enabled", .F. )
      Setproperty( oBrowse, "Button_F9", "Enabled", .F. )

      IF lConvert = .T.
         //         DoDebbbuug()
      ENDIF

      CENTER WINDOW &oBrowse
      //      Domethod( oBrowse, "BrowserView", "SetFocus" )
      ACTIVATE WINDOW &oBrowse

      IF USED()
         SELECT ( cWorkArea )
         CLOSE
      ENDIF

   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoFindSelf()
*+
*+    Called from ( browser.prg )   1 - procedure browseview()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoFindSelf( oWin, cDBF )

LOCAL nPosi, cWorkArea, cBroMacro

   nPosi := ASCAN( Stack_Browse, { | e | e[ ID_InDBF ] = cDBF } )
   IF nPosi > 0
      cBroMacro := Stack_Browse[ nPosi ] [ ID_Browse ]
      WinTans( oWin, .T. )
      nDimBrowse := nPosi
      cWorkArea := cInArea
      SELECT ( cWorkArea )
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure MultiBrowseRelease()
*+
*+    Called from ( browser.prg )   1 - procedure browseview()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE MultiBrowseRelease( cName, cDBF )

LOCAL nPosi, cWorkArea, cPath

   //    MsgInfo("Name "+cName+" DBF "+cDBF)

   nPosi := ASCAN( Stack_Browse, { | e | e[ ID_InDBF ] = cDBF } )
   IF nPosi > 0
      nDimBrowse := nPosi
      cWorkArea := Stack_Browse[ nPosi ] [ ID_InArea ]
      //  cdbf := Stack_Browse[ nPosi ] [ ID_InDBF ]
      cPath := Stack_Browse[ nPosi ] [ ID_InPath ]

      //       SELECT ( cWorkArea )
      //       MsgInfo("Alias "+ALIAS())
      //       CLOSE (cDBF)
      //       MsgInfo("Used "+ALIAS())

      Stack_Browse[ nPosi ] [ ID_Browse ] := ""
      Stack_Browse[ nPosi ] [ ID_InDBF ] := ""
      Stack_Browse[ nPosi ] [ ID_IdxActiv ] := .F.

      //       ADEL(Stack_Browse,nPosi)
      //       ASIZE(Stack_Browse, LEN(Stack_Browse) - 1 )

      Domethod( cName, "Release" )

   ELSE
      MsgInfo( "DBF " + cDBF + "not found?" )
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoResize()
*+
*+    Called from ( browser.prg )   2 - procedure browseview()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoResize( cForm, cObj, aStruc )

LOCAL nPBwide, nwide
LOCAL nDiff      := 0
LOCAL mainRow    := GetProperty( cForm, 'Row' )
LOCAL mainCol    := GetProperty( cForm, 'Col' )
LOCAL mainWidth  := GetProperty( cForm, 'Width' )
LOCAL mainHeight := GetProperty( cForm, 'Height' )
LOCAL nZoom      := ROUND( mainHeight / 600, 0 )
LOCAL nBorder    := GETBORDERWIDTH()
LOCAL hGrid, j, jMax, cType

   // LOCAL nHwnd, i
   //    nHwnd := GetformHandle( cForm )
   //    IF IsMaximized( nHwnd )
   //       nDiff := 10 // 90 + 6
   //    ENDIF

   Domethod( cForm, "hide" )

   Setproperty( cForm, cObj, "Width", mainWidth - 20 - ( 2 * nBorder ) )
   Setproperty( cForm, cObj, "Height", mainHeight - 100 - 24 - nDiff )

   IF SP_lColResize() = .T.
      Setproperty( cForm, cObj, "ChangeFontSize", SP_nFontlarge() * nZoom )
      hGrid := GetControlHandle( cObj, cForm )
      jMax := LEN( aStruc )
      j := 1
      FOR j := 1 TO jMax
         cType := aStruc[ j ] [ DBS_TYPE ]
         DO CASE
            CASE cType = "D"
               nWide := 80 * nZoom
            CASE cType = "L"
               nWide := 30 * nZoom
            OTHERWISE
               nWide := aStruc[ j ] [ DBS_LEN ]
               IF nWide < 2
                  nWide := 30 * nZoom
               ELSE
                  nWide := nWide * SP_nFontlarge() * nZoom
               ENDIF
         ENDCASE
         LISTVIEW_SETCOLUMNWIDTH( hGrid, j - 1, nWide )
      NEXT
   ENDIF

   nPBwide := INT( mainWidth / 11 )

   Setproperty( cForm, "Button_F1", "Width", nPBwide )
   Setproperty( cForm, "Button_F1", "Row", mainHeight - 80 - 24 - nDiff )

   Setproperty( cForm, "Button_F2", "Width", nPBwide )
   Setproperty( cForm, "Button_F2", "Row", mainHeight - 80 - 24 - nDiff )
   Setproperty( cForm, "Button_F2", "Col", nPBwide * 1 )

   Setproperty( cForm, "Button_F3", "Width", nPBwide )
   Setproperty( cForm, "Button_F3", "Row", mainHeight - 80 - 24 - nDiff )
   Setproperty( cForm, "Button_F3", "Col", nPBwide * 2 )

   Setproperty( cForm, "Button_F4", "Width", nPBwide )
   Setproperty( cForm, "Button_F4", "Row", mainHeight - 80 - 24 - nDiff )
   Setproperty( cForm, "Button_F4", "Col", nPBwide * 3 )

   Setproperty( cForm, "Button_F5", "Width", nPBwide )
   Setproperty( cForm, "Button_F5", "Row", mainHeight - 80 - 24 - nDiff )
   Setproperty( cForm, "Button_F5", "Col", nPBwide * 4 )

   Setproperty( cForm, "Button_F6", "Width", nPBwide )
   Setproperty( cForm, "Button_F6", "Row", mainHeight - 80 - 24 - nDiff )
   Setproperty( cForm, "Button_F6", "Col", nPBwide * 5 )

   Setproperty( cForm, "Button_F7", "Width", nPBwide )
   Setproperty( cForm, "Button_F7", "Row", mainHeight - 80 - 24 - nDiff )
   Setproperty( cForm, "Button_F7", "Col", nPBwide * 6 )

   Setproperty( cForm, "Button_F8", "Width", nPBwide )
   Setproperty( cForm, "Button_F8", "Row", mainHeight - 80 - 24 - nDiff )
   Setproperty( cForm, "Button_F8", "Col", nPBwide * 7 )

   Setproperty( cForm, "Button_F9", "Width", nPBwide )
   Setproperty( cForm, "Button_F9", "Row", mainHeight - 80 - 24 - nDiff )
   Setproperty( cForm, "Button_F9", "Col", nPBwide * 8 )

   Setproperty( cForm, "Button_F10", "Width", nPBwide )
   Setproperty( cForm, "Button_F10", "Row", mainHeight - 80 - 24 - nDiff )
   Setproperty( cForm, "Button_F10", "Col", nPBwide * 9 )

   Setproperty( cForm, "Button_F11", "Width", nPBwide )
   Setproperty( cForm, "Button_F11", "Row", mainHeight - 80 - 24 - nDiff )
   Setproperty( cForm, "Button_F11", "Col", nPBwide * 10 )

   Domethod( cForm, "show" )

RETURN

*+--------------------------------------------------------------------
*+
*+    Function USE_MYDBF()
*+
*+    Called from ( browser.prg )   1 - procedure browseview()
*+
*+--------------------------------------------------------------------
*+
FUNCTION USE_MYDBF( cDbf, lExcusive )

LOCAL aType
LOCAL nType
LOCAL cDriver
LOCAL lRet      := .T.
LOCAL _CodePage

   DEFAULT lExcusive TO .T.

   aType := DbeFileType( cDbf )                                       //  {nType,cDbfType,cDriver,cInxExt}
   nType := aType[ 1 ]
   cDriver := aType[ 3 ]
   SP_cInxExt( aType[ 4 ] )
   _CodePage := aType[ 5 ]

   IF EMPTY( nType )
      msginfo( "File " + cDBF + " exclusive used" + CRLF )
      RETURN .F.
   ENDIF

   SP_lOEM2ANSI( .F. )

   // to avoid ALIAS Problem
   DO CASE
      CASE nType = 3                                                  //  03h   FoxBASE+/Dbase III plus, no memo
         IF lExcusive = .T.
            USE (cDBF) VIA "DBFNTX" NEW EXCLUSIVE
         ELSE
            USE (cDBF) VIA "DBFNTX" NEW SHARE
         ENDIF
         IF NETERR()
            USE (cDBF) VIA "DBFNTX" NEW
            IF NETERR()
               RETURN .F.
            ENDIF
            lShare := .T.
         ENDIF
         SP_lOEM2ANSI( .T. )

      CASE nType = 7                                                  //* 07h   VO - dBASE III files w/o memo file
         // MSGInfo( VAR2CHAR( aType ), "Warning DBF Type" )
         IF lExcusive = .T.
            USE (cDBF) VIA "DBFNTX" NEW EXCLUSIVE
         ELSE
            USE (cDBF) VIA "DBFNTX" NEW SHARE
         ENDIF
         IF NETERR()
            USE (cDBF) VIA "DBFNTX" NEW
            IF NETERR()
               RETURN .F.
            ENDIF
            lShare := .T.
         ENDIF
         SP_lOEM2ANSI( .T. )

      CASE nType = 48 .OR. nType = 49                                 //  30h   Visual FoxPro - 31h   Visual FoxPro, autoincrement enabled
         IF lExcusive = .T.
            USE (cDBF) VIA "DBFCDX" NEW EXCLUSIVE
         ELSE
            USE (cDBF) VIA "DBFCDX" NEW SHARE
         ENDIF
         IF NETERR()
            USE (cDBF) VIA "DBFCDX" NEW
            IF NETERR()
               RETURN .F.
            ENDIF
            lShare := .T.
         ENDIF

      CASE nType = 131                                                //  83h   FoxBASE+/dBASE III PLUS, with memo
         IF lExcusive = .T.
            USE (cDBF) VIA "DBFNTX" NEW EXCLUSIVE
         ELSE
            USE (cDBF) VIA "DBFNTX" NEW SHARE
         ENDIF
         IF NETERR()
            USE (cDBF) VIA "DBFNTX" NEW
            IF NETERR()
               RETURN .F.
            ENDIF
            lShare := .T.
         ENDIF
         SP_lOEM2ANSI( .T. )

      CASE nType = 245                                                //  F5h   FoxPro 2.x (or earlier) with memo
         //          // using Cl*pper Comix/SixDrive
         IF lExcusive = .T.
            USE (cDBF) VIA "DBFCDX" NEW EXCLUSIVE
         ELSE
            USE (cDBF) VIA "DBFCDX" NEW SHARE
         ENDIF
         IF NETERR()
            USE (cDBF) VIA "DBFCDX" NEW
            IF NETERR()
               RETURN .F.
            ENDIF
            lShare := .T.
         ENDIF

      OTHERWISE
         MSGInfo( VAR2CHAR( aType ), "DBF Type unknown" )

         IF aType[ 4 ] = "NTX"
            IF lExcusive = .T.
               USE (cDBF) VIA "DBFNTX" NEW EXCLUSIVE
            ELSE
               USE (cDBF) VIA "DBFNTX" NEW SHARE
            ENDIF NEW
            IF NETERR()
               USE (cDBF) VIA "DBFNTX" NEW
               IF NETERR()
                  RETURN .F.
               ENDIF
               lShare := .T.
            ENDIF
            SP_lOEM2ANSI( .T. )

         ELSEIF aType[ 4 ] = "CDX"
            IF lExcusive = .T.
               USE (cDBF) VIA "DBFCDX" NEW EXCLUSIVE
            ELSE
               USE (cDBF) VIA "DBFCDX" NEW SHARE
            ENDIF
            IF NETERR()
               USE (cDBF) VIA "DBFCDX" NEW
               IF NETERR()
                  RETURN .F.
               ENDIF
               lShare := .T.
            ENDIF

         ELSE
            IF lExcusive = .T.
               USE (cDBF) VIA "DBFNTX" NEW EXCLUSIVE
            ELSE
               USE (cDBF) VIA "DBFNTX" NEW SHARE
            ENDIF
            IF NETERR()
               USE (cDBF) VIA "DBFNTX" NEW
               IF NETERR()
                  RETURN .F.
               ENDIF
               lShare := .T.
            ENDIF
            SP_lOEM2ANSI( .T. )
         ENDIF

         lRet := .F.
   ENDCASE

RETURN lRet

*+--------------------------------------------------------------------
*+
*+    Static Function DbeFileType()
*+
*+    Called from ( browser.prg )   1 - function use_mydbf()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION DbeFileType( cDbf )

LOCAL nHandle, cBuffer := SPACE( 1 )
LOCAL cTest, nType, aRetVal, cDbe, cTxt, _CodePage := ""

   cDbf := IF( RAT( ".", cDbf ) == 0, cDbf + ".DBF", cDbf )
   cDbf := UPPER( cDbf )

   IF !FILE( cDbf )
      RETURN ( { 0, 'File not found', '???', '???' } )
   ENDIF

   IF ( nHandle := FOPEN( cDbf ) ) < 0                                // file is in exclusive use at this time
      // cDbe := DbeInfo( COMPONENT_DATA, DBE_NAME )
      // IF LEFT( cDbe, 3 ) == "FOX"
      //    aRetVal := { nType, 'Foxbase', 'FOXCDX', 'CDX' }
      // ELSE
      //    aRetVal := { nType, 'Foxbase/Foxpro/dBASEIII/IV no memo', 'DBFNTX', 'NTX' }
      // ENDIF
      aRetVal := { 0, '', '', '' }

      FCLOSE( nHandle )
      MsgInfo( "file is in exclusive use at this time" )
      RETURN aRetVal
   ENDIF

   FSEEK( nHandle, 0, 0 )                                             // Move pointer to first byte
   FREAD( nHandle, @cBuffer, 1 )
   //   FCLOSE( nHandle )
   nType := ASC( cBuffer )

   cTxt := SPACE( 30 )
   FSEEK( nHandle, 0, 0 )                                             // Move pointer to Start
   FREAD( nHandle, @cTxt, 30 )
   FCLOSE( nHandle )

   // ALTD()

   cTest := SUBSTR( cTxt, 30, 1 )                                     // 0-29 / 1-30
   // look for Codepage
   DO CASE
      CASE cTest = CHR( 0x01 )
         _CodePage := "DOS 437"
      CASE cTest = CHR( 0x02 )
         _CodePage := "DOS 850"
      CASE cTest = CHR( 0x03 )
         _CodePage := "WIN 1251"
      CASE cTest = CHR( 0xC8 )
         _CodePage := "WIN 1250"
      CASE cTest = CHR( 0x64 )
         _CodePage := "DOS 852"
      CASE cTest = CHR( 0x65 )
         _CodePage := "DOS 865"
      CASE cTest = CHR( 0x66 )
         _CodePage := "DOS 866"
      OTHERWISE
         _CodePage := STR( ASC( cTest ) )
         // ??? mehr
   ENDCASE

   _CodePage := LTRIM( _CodePage )
   IF _CodePage = "0"
      _CodePage := ""
   ENDIF

   IF EMPTY( _CodePage )
      cTest := SUBSTR( cTxt, 29, 1 )                                  // 0-29 / 1-30
      // look for Codepage
      DO CASE
         CASE cTest = CHR( 0x01 )
            _CodePage := "DOS 437"
         CASE cTest = CHR( 0x02 )
            _CodePage := "DOS 850"
         CASE cTest = CHR( 0x03 )
            _CodePage := "WIN 1251"
         CASE cTest = CHR( 0xC8 )
            _CodePage := "WIN 1250"
         CASE cTest = CHR( 0x64 )
            _CodePage := "DOS 852"
         CASE cTest = CHR( 0x65 )
            _CodePage := "DOS 865"
         CASE cTest = CHR( 0x66 )
            _CodePage := "DOS 866"
         OTHERWISE
            _CodePage := STR( ASC( cTest ) )
            // ??? mehr
      ENDCASE
   ENDIF

   SP_cCodepage( _CodePage )

RETURN DbfDetail( nType, cDbf, _CodePage )

*+--------------------------------------------------------------------
*+
*+    Static Function DbfDetail()
*+
*+    Called from ( browser.prg )   1 - static function dbefiletype()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION DbfDetail( nType, cDbf, _CodePage )

LOCAL cDbfType, cDriver, cInxExt, lIsCdx

   lIsCdx := FILE( STRTRAN( cDbf, '.DBF', '.CDX' ) )

   DO CASE
      CASE nType = 2                                                  //  02h   FoxBASE
         cDbfType = 'Foxbase'
         cDriver := "FOXCDX"
         cInxExt := "CDX"
      CASE nType = 3                                                  //  03h   FoxBASE+/Dbase III plus, no memo
         cDbfType = 'Foxpro/dBASEIII/Ads/Clipper no memo'
         IF lIsCdx
            cDriver := 'DBFCDX/ADSDBE'
            cInxExt := 'CDX'
         ELSE
            cDriver := "DBFNTX/ADSDBE"
            cInxExt := "NTX"
         ENDIF
      CASE nType = 4                                                  //* 04h
         cDbfType = "dBASE IV w/o memo file"
      CASE nType = 5                                                  //* 05h
         cDbfType = "dBASE  V w/o memo file"
      CASE nType = 7                                                  //* 07h
         cDbfType = "VISUAL OBJECTS (first 1.0 versions) for the dBASE III files w/o memo file"
         cDriver := "DBFNTX/ADSDBE"
         cInxExt := "NTX"

      CASE nType = 48                                                 //  30h   Visual FoxPro
         cDbfType = 'Visual Foxpro/Ads'
         cDriver := "FOXCDX/ADSDBE"
         cInxExt := "CDX"
      CASE nType = 49                                                 //  31h   Visual FoxPro, autoincrement enabled
         cDbfType = 'Visual Foxpro AutoIncr'
         cDriver := "FOXCDX"
         cInxExt := "CDX"

         // 0x32 Visual FoxPro with field type Varchar or Varbinary

      CASE nType = 67                                                 //  43h   dBASE IV SQL table files, no memo
         cDbfType = 'dBASE IV SQL table no memo'

         // 0x63 dBASE IV SQL system files, no memo

      CASE nType = 99                                                 //  ???
         cDbfType = 'dBASE IV SQL system file no memo'
      CASE nType = 123                                                //* 7Bh
         cDbfType = "dBASE IV with memo"
      CASE nType = 131                                                //  83h   FoxBASE+/dBASE III PLUS, with memo
         cDbfType = 'FoxPro/dBASEIII/Ads/Clipper with memo'
         IF lIsCdx
            cDriver := 'DBFCDX/ADSDBE'
            cInxExt := 'CDX'
         ELSE
            cDriver := "DBFNTX/ADSDBE"
            cInxExt := "NTX"
         ENDIF
         // 0x8B dBASE IV with memo
      CASE nType = 135                                                //* 87h
         cDbfType = "VISUAL OBJECTS (first 1.0 versions) for the dBASE III files (NTX clipper driver) with memo file"
      CASE nType = 139                                                //  8Bh
         cDbfType = 'dBASE IV with memo'
         cDriver := "DBFNTX"
         cInxExt := "NTX"
      CASE nType = 142                                                //* 8Eh
         cDbfType = "dBASE IV w. SQL table"
      CASE nType = 179                                                //* B3h
         cDbfType = ".dbv and .dbt memo (Flagship)"
      CASE nType = 203                                                //  0xCB  dBASE IV SQL table files, with memo
         cDbfType = 'dBASE IV SQL table with memo'
      CASE nType = 229                                                //* E5h   HiPer-Six format with SMT memo file
         cDbfType = "Clipper SIX driver w. SMT memo file."
      CASE nType = 245                                                //  F5h   FoxPro 2.x (or earlier) with memo
         cDbfType = 'Foxpro 2.x/Ads with memo'
         cDriver := "FOXCDX/ADSDBE"
         cInxExt := "CDX"
      CASE nType = 251                                                //  FBh   FoxBASE
         cDbfType = 'Foxbase'
         cDriver := "FOXCDX"
         cInxExt := "CDX"

      OTHERWISE
         cDbfType = 'Unknown or invalid type'
   ENDCASE

RETURN ( { nType, cDbfType, cDriver, cInxExt, _CodePage } )

*+--------------------------------------------------------------------
*+
*+    Function TNR2STR()
*+
*+--------------------------------------------------------------------
*+
FUNCTION TNR2STR( value )                                             // used in UDF-Index

LOCAL RETVAR := ""
LOCAL nLen   := LEN( value )
LOCAL nSoll  := nLen
LOCAL i, nDiff
LOCAL cStr

   FOR i = 1 TO nLen
      cStr := SUBSTR( value, i, 1 )
      IF cStr == CHR( 32 )
      ELSE
         RETVAR := RETVAR + cStr
      ENDIF
   NEXT

   nDiff := nSoll - LEN( RETVAR )
   FOR i = 1 TO nDiff
      RETVAR := RETVAR + CHR( 32 )
   NEXT

RETURN RETVAR

*+--------------------------------------------------------------------
*+
*+    Static Procedure EditDetail()
*+
*+    Called from ( browser.prg )   4 - procedure browseview()
*+                                   1 - static procedure addnewrecord()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE EditDetail( cBroMacro, cWorkArea, cDbf, aFeld, lEdit )

LOCAL i, iMax, cObj, cLabel, nHeight
LOCAL cText, cType, nSize, nDec, nRow, cFIELD
LOCAL nMaxheight  := GetDeskTopRealHeight()
LOCAL nMaxwide    := GetDesktopRealWidth()
LOCAL nEditHeight := 600
LOCAL nTitlebar   := GETTITLEHEIGHT()
LOCAL nItemheight := 33
LOCAL cTitle      := IF( lEdit, "Edit Record ", "View only " )
LOCAL oBroEdit    := "BroEdit_" + STRZERO( nIndex, 2 )
LOCAL aStruc, nMaxLen := 0
LOCAL nRecno, xValue

#IFDEF Use_DataBrowse
   nRecno := GetProperty( cBroMacro, "BrowserView", "Value" )
#ELSE
   nRecno := GetProperty( cBroMacro, "BrowserView", "RecNo" )
#ENDIF

   SELECT ( cWorkArea )
   GOTO( nRecno )

   //  aStruc := DBSTRUCT()
   aStruc := ACLONE( SP_aDbfStruct() )
   iMax := LEN( aStruc )
   nHeight := iMax * nItemheight

   IF nHeight + nItemheight + nTitlebar < nEditHeight
      nEditHeight := nHeight + nItemheight + nTitlebar
   ENDIF
   IF nHeight > nMaxheight
      nEditHeight := nMaxheight
   ENDIF

   IF !EMPTY( ALIAS() )
      cTitle += ALIAS()
   ENDIF

   //      OF &cBroMacro ;
   //      TOPMOST ;
   //      MODAL ;

   DEFINE WINDOW &oBroEdit ;
              AT 0, 0 ;
              WIDTH 300 ;
              HEIGHT nEditHeight ;
              VIRTUAL WIDTH 9999 ;
              VIRTUAL HEIGHT( iMax * nItemheight ) + nItemheight + nTitlebar + 1 ;
              TITLE cTitle ;
              ICON "A1MAIN" ;
              TOPMOST ;
              BACKCOLOR SP_nColor1()

      FOR i := 1 TO iMax

         cLabel := "LABEL_" + STRZERO( i, 3 )
         cObj := "TEXT_" + STRZERO( i, 3 )
         nRow := 32 * ( i - 1 )
         nSize := aStruc[ i ] [ DBS_LEN ] * SP_nFontlarge()

         nMaxLen := MAX( nMaxLen, nSize )

         cFIELD := aStruc[ i ] [ DBS_NAME ]

         DEFINE LABEL &cLabel
            ROW nRow
            COL 10
            VALUE cFIELD
            WIDTH 80
            HEIGHT 30
            BACKCOLOR SP_nColor1()
            FONTCOLOR SP_nColor2()
         END LABEL

         cFIELD := "FIELD->" + aStruc[ i ] [ DBS_NAME ]

         DO CASE
            CASE aStruc[ i ] [ DBS_TYPE ] = "C"

               DEFINE TEXTBOX &cObj
                  ROW nRow
                  COL 100
                  HEIGHT 30
                  FIELD &( cFIELD )
                  READONLY !lEdit
                  WIDTH nSize
                  FONTNAME SP_cFontName()
                  FONTSIZE SP_nFontSize()
                  TOOLTIP ""
                  BACKCOLOR SP_nColor5()
                  FONTCOLOR SP_nColor6()
                  DISABLEDBACKCOLOR IF( lEdit = .T., SP_nColor5(), SP_nColor13() )
                  DISABLEDFONTCOLOR IF( lEdit = .T., SP_nColor6(), SP_nColor14() )
                  ONCHANGE IF( lEdit = .T., DoChange( oBroEdit, This.Name, aStruc, cBroMacro ), )
                  DATATYPE CHARACTER
                  CASECONVERT NONE
                  RIGHTALIGN .F.
                  VISIBLE .T.
                  TABSTOP .T.
               END TEXTBOX

            CASE aStruc[ i ] [ DBS_TYPE ] = "N"

               DEFINE TEXTBOX &cObj
                  ROW nRow
                  COL 100
                  HEIGHT 30
                  FIELD &( cFIELD )
                  READONLY !lEdit
                  WIDTH nSize
                  FONTNAME SP_cFontName()
                  FONTSIZE SP_nFontSize()
                  BACKCOLOR SP_nColor5()
                  FONTCOLOR SP_nColor6()
                  DISABLEDBACKCOLOR IF( lEdit = .T., SP_nColor5(), SP_nColor13() )
                  DISABLEDFONTCOLOR IF( lEdit = .T., SP_nColor6(), SP_nColor14() )
                  ONCHANGE IF( lEdit = .T., DoChange( oBroEdit, This.Name, aStruc, cBroMacro ), )
                  DATATYPE NUMERIC
                  VISIBLE .T.
                  TABSTOP .T.
               END TEXTBOX

            CASE aStruc[ i ] [ DBS_TYPE ] = "D"
               DEFINE TEXTBOX &cObj
                  ROW nRow
                  COL 100
                  HEIGHT 30
                  FIELD &( cFIELD )
                  READONLY !lEdit
                  WIDTH nSize
                  FONTNAME SP_cFontName()
                  FONTSIZE SP_nFontSize()
                  BACKCOLOR SP_nColor5()
                  FONTCOLOR SP_nColor6()
                  DISABLEDBACKCOLOR IF( lEdit = .T., SP_nColor5(), SP_nColor13() )
                  DISABLEDFONTCOLOR IF( lEdit = .T., SP_nColor6(), SP_nColor14() )
                  ONCHANGE IF( lEdit = .T., DoChange( oBroEdit, This.Name, aStruc, cBroMacro ), )
                  DATATYPE DATE
                  VISIBLE .T.
                  TABSTOP .T.
               END TEXTBOX

            CASE aStruc[ i ] [ DBS_TYPE ] = "L"

               DEFINE CHECKBOX &cObj
                  ROW nRow
                  COL 100
                  CAPTION ""
                  HEIGHT 30
                  FIELD &( cFIELD )
                  WIDTH 50
                  BACKCOLOR SP_nColor5()
                  FONTCOLOR SP_nColor6()
                  DISABLEDBACKCOLOR IF( lEdit = .T., SP_nColor5(), SP_nColor13() )
                  DISABLEDFONTCOLOR IF( lEdit = .T., SP_nColor6(), SP_nColor14() )
                  ONCHANGE IF( lEdit = .T., DoChange( oBroEdit, This.Name, aStruc, cBroMacro ), )
                  VISIBLE .T.
                  TABSTOP .T.
               END CHECKBOX

         ENDCASE

      NEXT
   END WINDOW

   nMaxLen += 100
   nMaxLen := MIN( nMaxLen, nMaxwide )
   SetProperty( oBroEdit, "Width", nMaxLen )

   ON KEY ESCAPE OF &oBroEdit ACTION Domethod( oBroEdit, "Release" )
   CENTER WINDOW &oBroEdit
   Domethod( oBroEdit, "TEXT_001", "SetFocus" )
   //   SetProperty(oBroEdit, "HScrollBar","Value",0 )

   ACTIVATE WINDOW &oBroEdit

   DoFindWin( cDBF )

#IFDEF Use_DataBrowse
   RefreshBrowseLine( cBroMacro, "BrowserView", aFeld )
#ELSE
   RefreshCurrent( cBroMacro, "BrowserView" )
#ENDIF

   Domethod( oBrowse, "BrowserView", "SetFocus" )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure RefreshCurrent()
*+
*+    Called from ( browser.prg )   1 - static procedure editdetail()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE RefreshCurrent( cForm, cBrowse )

LOCAL hBrowse := GetControlHandle( cBrowse, cForm )
LOCAL nRecord := GetProperty( cForm, cBrowse, "VALUE" )
   ListView_RedrawItems( hBrowse, nRecord, nRecord )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoChange()
*+
*+    Called from ( browser.prg )   4 - static procedure editdetail()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoChange( cForm, cObj, aStruc, cBroMacro )

LOCAL xValue, cFeld, cPosi, nItem

   cPosi := STRTRAN( cObj, "TEXT_", "" )
   cFeld := aStruc[ VAL( cPosi ) ] [ DBS_NAME ]
   xValue := GetProperty( cForm, cObj, "VALUE" )
   nItem := GetProperty( cBroMacro, "BrowserView", "VALUE" )

   IF RLOCK()
      REPLACE &( cFeld ) WITH xValue
      UNLOCK
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure MakeFMG()
*+
*+    Called from ( browser.prg )   2 - procedure browseview()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE MakeFMG( cDbf )

LOCAL cFMG, cWide, cHight
   //    msginfo("under construction")

   Make_FMG( cDbf, cWide, cHight )
   cFMG := STRTRAN( UPPER( cDbf ), ".DBF", ".FMG" )
   IF FILE( cFMG )
      // *************************************************
      //    IF !IsWindowDefined( cFMG )
      //       Load Window cFMG
      //
      //       ON KEY ESCAPE OF &cFMG ACTION Domethod(cFMG,"Release")
      //
      //       CENTER WINDOW cFMG
      //       Activate Window cFMG
      //    ENDIF
      // ************************************************
      msginfo( "file " + cFMG + " create" )
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure Pre_SetNewIndex()
*+
*+    Called from ( browser.prg )   2 - procedure browseview()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Pre_SetNewIndex( cPath, cDBF )

LOCAL cRet   := ""
LOCAL lRet   := .F.
LOCAL bError
LOCAL aPara  := {}
LOCAL i, iMax, cIndex
LOCAL cAlias := ALIAS()
LOCAL nselec := SELECT ()
LOCAL nPosi, cWorkArea

   nPosi := ASCAN( Stack_Browse, { | e | e[ ID_InDBF ] = cDBF } )
   IF nPosi > 0
      nDimBrowse := nPosi
      cWorkArea := cInArea
      SELECT ( cWorkArea )
   ELSE
      MsgInfo( "can't find WorkArea for " + cDBF )
      RETURN
   ENDIF

   SP_GetWahl( "" )
   SetNewIndex( cPath )
   cRet := SP_GetWahl()
   //    ALTD()
   IF !EMPTY( cRet )
      ORDLISTCLEAR()
      aPara := AtInside( ",", cRet )
      iMax := LEN( aPara )
      FOR i := 1 TO iMax
         cIndex := aPara[ i ]
         lRet := .F.
         bError := ERRORBLOCK( { | oErr | BREAK( oErr ) } )
         BEGIN SEQUENCE
            SET INDEX TO &cIndex ADDITIVE
            lRet := .T.
         END SEQUENCE
         ERRORBLOCK( bError )
      NEXT

      IF lRet = .T.
         lIdxActiv := .T.
         Setproperty( oBrowse, "Button_F7", "Enabled", .T. )
         Setproperty( oBrowse, "Button_F8", "CAPTION", IF( lIdxActiv = .T., "F8 Scope", "F8 locate" ) )

         Domethod( oBrowse, "BrowserView", "SetFocus" )
         Domethod( oBrowse, "BrowserView", "Refresh" )
      ELSE
         MsgInfo( "Error set Index TO " + CRLF + cRet )
      ENDIF
   ENDIF

   DoFindWin( cDBF )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SetNewIndex()
*+
*+    Called from ( browser.prg )   1 - static procedure pre_setnewindex()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SetNewIndex( cPath )

LOCAL aDir, i, iMax
LOCAL a2List    := {}
LOCAL aSort
LOCAL oNewIndex := "NewIndex_" + STRZERO( nIndex, 2 )

   lActiveMain := .F.

   aDir := DIRECTORY( cPath + "*." + cInExt )
   aSort := ASORT( aDir,,, { | x, y | x[ F_NAME ] < y[ F_NAME ] } )

   iMax := LEN( aSort )
   FOR i := 1 TO iMax
      AADD( a2List, aSort[ i ] [ F_NAME ] )
   NEXT

   DEFINE WINDOW &oNewIndex ;
              AT 348, 589 ;
              WIDTH 174 ;
              HEIGHT 755 ;
              TITLE "" ;
              ICON "A1MAIN" ;
              TOPMOST ;
              NOMINIMIZE ;
              NOMAXIMIZE ;
              NOSIZE ;
              BACKCOLOR SP_nColor1()

      DEFINE LISTBOX Set_NewIndex
         PARENT &oNewIndex
         ROW 10
         COL 10
         WIDTH 150
         HEIGHT 700
         ITEMS a2List
         VALUE 1
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         BACKCOLOR SP_nColor9( )
         FONTCOLOR SP_nColor10()
         ONDBLCLICK DoMyIndexAction( aSort, cPath, oNewIndex )
         TABSTOP .T.
         VISIBLE .T.
         SORT .F.
         MULTISELECT .T.
         DRAGITEMS .F.
      END LISTBOX

   END WINDOW

   ON KEY ESCAPE OF &oNewIndex ACTION Domethod( oNewIndex, "Release" )
   CENTER WINDOW &oNewIndex
   Domethod( oNewIndex, "Set_NewIndex", "setfocus" )

   ACTIVATE WINDOW &oNewIndex

   lActiveMain := .T.

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoMyIndexAction()
*+
*+    Called from ( browser.prg )   1 - static procedure setnewindex()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoMyIndexAction( aSort, cPath, oNewIndex )

LOCAL bError := ERRORBLOCK( { | oErr | BREAK( oErr ) } )
LOCAL aRow, nRow, i, imax, cItem, j
LOCAL cRet   := ""
LOCAL aTags  := {}

   aRow := GetProperty( oNewIndex, "Set_NewIndex", "Value" )
   IF EMPTY( aRow )
      Domethod( oNewIndex, "Release" )
      RETURN
   ENDIF
   imax := LEN( aRow )
   FOR i := 1 TO iMax
      nRow := aRow[ i ]
      cItem := TRIM( aSort[ nRow ] [ 1 ] )
      AADD( aTags, cItem )
      cRet += cPath + cItem
      IF i <> iMax
         cRet += ','
      ENDIF
   NEXT

   SP_GetWahl( cRet )
   aInTags := ACLONE( aTags )

   Setproperty( oBrowse, "Button_F9", "Enabled", .T. )
   Domethod( oNewIndex, "Release" )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoSeek()
*+
*+    Called from ( browser.prg )   2 - procedure browseview()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoSeek( cPath, cDBF, lEdit )

LOCAL cSeek
LOCAL nRec  := RECNO()
LOCAL cRet  := SP_GetWahl()
LOCAL cKey  := INDEXKEY()

   cSeek := GetInPut( "seek " + cKey, STRTRAN( cRet, cPath, "" ), cOldSeek, 2 )
   cSeek := TRIM( cSeek )

   IF !EMPTY( cSeek )
      SEEK( cSeek )
      IF FOUND()
         cOldSeek := cSeek
         nRec := RECNO()
         DoFindWin( cDBF )
#IFDEF Use_DataBrowse
         SetProperty( oBrowse, "BrowserView", "Value", nRec )
#ELSE
         SetProperty( oBrowse, "BrowserView", "RecNo", nRec )
#ENDIF
         Domethod( oBrowse, "BrowserView", "SetFocus" )
         Domethod( oBrowse, "BrowserView", "Refresh" )
      ELSE
         Msginfo( "nothing found for : " + cSeek )
         GOTO( nRec )
      ENDIF
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure CopyResult()
*+
*+    Called from ( browser.prg )   2 - procedure browseview()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE CopyResult( cPath, cDbf )

   ExportDbf( ALIAS() )
   DoFindWin( cDBF )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoScope()
*+
*+    Called from ( browser.prg )   2 - procedure browseview()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoScope( cPath, cDbf, lEdit )

LOCAL cScope, cSeek, cTitle, cTop, cBottom
LOCAL cPart  := "", cPart2 := ""
LOCAL nRec   := RECNO()
LOCAL cRet   := SP_GetWahl()
LOCAL cKey   := INDEXKEY()
LOCAL nPosi, cWorkArea

   nPosi := ASCAN( Stack_Browse, { | e | e[ ID_InDBF ] = cDBF } )
   IF nPosi > 0
      nDimBrowse := nPosi
      cWorkArea := cInArea
      SELECT ( cWorkArea )
   ELSE
      MsgInfo( "can't find WorkArea for " + cDBF )
      RETURN
   ENDIF

   cSeek := GetInPut( "Scope", STRTRAN( cRet, cPath, "" ) + " : " + cKey, cOldScope, 2 )
   cSeek := TRIM( cSeek )

   IF !EMPTY( cSeek )
      SET SCOPE TO
      cOldScope := cSeek
      IF "," $ cSeek
         nPosi := AT( ",", cSeek )
         cPart := ALLTRIM( SUBSTR( cSeek, 1, nPosi - 1 ) )
         cPart2 := ALLTRIM( SUBSTR( cSeek, nPosi + 1 ) )

         SEEK( cPart )
         cScope := CHR( 34 ) + cPart + CHR( 34 ) + "," + CHR( 34 ) + cPart2 + CHR( 34 )
      ELSE
         cPart := cSeek
         SEEK( cSeek )
         cScope := CHR( 34 ) + cSeek + CHR( 34 )
      ENDIF

      IF FOUND()
         nRec := RECNO()
#IFDEF Use_DataBrowse
         SetProperty( oBrowse, "BrowserView", "Value", nRec )
#ELSE
         SetProperty( oBrowse, "BrowserView", "RecNo", nRec )
#ENDIF

         IF EMPTY( cPart2 )
            SET SCOPE TO &cScope
         ELSE
            cTop := CHR( 34 ) + cPart + CHR( 34 )
            SET SCOPETOP TO &cTop
            cBottom := CHR( 34 ) + cPart2 + CHR( 34 )
            SET SCOPEBOTTOM TO &cBottom
         ENDIF

         Domethod( oBrowse, "BrowserView", "SetFocus" )
         Domethod( oBrowse, "BrowserView", "Refresh" )

         cTitle := cDbf + " Scope " + cPart
         IF !EMPTY( cPart2 )
            cTitle += ", " + cPart2
         ENDIF
         Setproperty( oBrowse, "TITLE", cTitle )

      ELSE
         Msginfo( "nothing found for Scope : " + cScope )
         GOTO( nRec )
      ENDIF
   ENDIF
   DoFindWin( cDBF )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure Dolocate()
*+
*+    Called from ( browser.prg )   2 - procedure browseview()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Dolocate( cPath, cDBF )

   msginfo( "locate()  under construction ..." + CRLF + CRLF + "Ctrl-F8 for Filter-Assistant" )
   DoFindWin( cDBF )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoSwitchTags()
*+
*+    Called from ( browser.prg )   2 - procedure browseview()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoSwitchTags()

LOCAL aElem     := {}
LOCAL i, cText
LOCAL oDoSwTags := "SwTags_" + STRZERO( nIndex, 2 )

   IF cInExt = "NTX"
      aElem := ACLONE( aInTags )
   ELSE
      FOR i := 1 TO 10
         cText := ORDNAME( i )
         IF EMPTY( cText )
            EXIT
         ENDIF
         AADD( aElem, cText )
      NEXT
   ENDIF

   DEFINE WINDOW &oDoSwTags ;
              AT 348, 589 ;
              WIDTH 174 ;
              HEIGHT 355 ;
              TITLE "" ;
              ICON "A1MAIN" ;
              TOPMOST ;
              NOMINIMIZE ;
              NOMAXIMIZE ;
              NOSIZE ;
              BACKCOLOR SP_nColor1()

      DEFINE LISTBOX Do_SwitchTags
         PARENT &oDoSwTags
         ROW 10
         COL 10
         WIDTH 150
         HEIGHT 300
         ITEMS aElem
         VALUE 1
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         BACKCOLOR SP_nColor9( )
         FONTCOLOR SP_nColor10()
         ONDBLCLICK DoMySwitchTags( oDoSwTags )
         TABSTOP .T.
         VISIBLE .T.
         SORT .F.
         MULTISELECT .F.
         DRAGITEMS .F.
      END LISTBOX
   END WINDOW

   ON KEY ESCAPE OF &oDoSwTags ACTION Domethod( oDoSwTags, "Release" )
   CENTER WINDOW &oDoSwTags
   Domethod( oDoSwTags, "Do_SwitchTags", "setfocus" )
   ACTIVATE WINDOW &oDoSwTags

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoMySwitchTags()
*+
*+    Called from ( browser.prg )   1 - static procedure doswitchtags()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoMySwitchTags( oDoSwTags )

LOCAL nRow := GetProperty( oDoSwTags, "Do_SwitchTags", "Value" )

   IF EMPTY( nRow )
      Domethod( oDoSwTags, "Release" )
      RETURN
   ENDIF

   ORDSETFOCUS( nRow )
   Domethod( oBrowse, "BrowserView", "SetFocus" )
   Domethod( oBrowse, "BrowserView", "Refresh" )
   Domethod( oDoSwTags, "Release" )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure Do_Modi_Stru()
*+
*+    Called from ( browser.prg )   2 - procedure browseview()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Do_Modi_Stru( cDbf, cWorkArea )

LOCAL aStruc, i, iMax, aClone
LOCAL aCaption  := { "Name", "Type", "Len", "Dec" }
LOCAL aWide     := { 110, 50, 60, 60 }
LOCAL aItems    := {}
LOCAL nHeight   := 0
LOCAL nTitlebar := GETTITLEHEIGHT()
LOCAL oModiStr  := "ModiForn_" + STRZERO( nIndex, 2 )

   SELECT ( cWorkArea )
   aStruc := DBSTRUCT()
   iMax := LEN( aStruc )
   nHeight := ( iMax + 1 ) * 22.3

   FOR i := 1 TO iMax
      AADD( aItems, { aStruc[ i ] [ DBS_NAME ], ;
                      aStruc[ i ] [ DBS_TYPE ], ;
                      aStruc[ i ] [ DBS_LEN ], ;
                      aStruc[ i ] [ DBS_DEC ] } )
   NEXT

   /***********************************************************************
   ShowArrayStru(aStruc,aCaption,cDbf)
***********************************************************************/

   DEFINE WINDOW &oModiStr ;
              AT 0, 0 ;
              WIDTH 330 ;
              HEIGHT nHeight + nTitlebar + 40 + 50 ;
              TITLE cDbf ;
              ICON "A1MAIN" ;
              TOPMOST ;
              FONTNAME SP_cFontName() ;
              FONTSIZE SP_nFontlarge() ;
              NOMINIMIZE ;
              NOMAXIMIZE ;
              NOSIZE ;
              BACKCOLOR SP_nColor1() ;
              ON RELEASE CloseForm2()

      DEFINE TOOLBAR oTOOLBAR BUTTONSIZE 50, 50 FLAT BORDER
         BUTTON oBtSave ;
                 TOOLTIP "F5: create DBF" ;
                 PICTURE "MYOKGREEN" ;
                 ACTION SaveCreate( aStruc, aClone )
      END TOOLBAR

      DEFINE GRID Brow_2
         PARENT &oModiStr
         ROW 50
         COL 10
         WIDTH 290
         HEIGHT nHeight
         HEADERS aCaption
         WIDTHS aWide
         ITEMS aItems
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         BACKCOLOR SP_nColor9( )
         FONTCOLOR SP_nColor10()
         ONDBLCLICK DBF_EditStruRec( ThisWindow.Name, This.Name, aStruc )
      END GRID
   END WINDOW

   CalcNewBroGridSize( iMax, oModiStr )

   ON KEY F5 OF &oModiStr ACTION SaveCreate()
   ON KEY ESCAPE OF &oModiStr ACTION Domethod( oModiStr, "Release" )

   Domethod( oModiStr, "Brow_2", "setfocus" )
   CENTER WINDOW &oModiStr
   ACTIVATE WINDOW &oModiStr

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure CalcNewBroGridSize()
*+
*+    Called from ( browser.prg )   1 - static procedure do_modi_stru()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE CalcNewBroGridSize( iMax, oModiStr )

LOCAL hGrid, nHeigh, nFrame := 4
LOCAL aRect     := { 0, 0, 0, 0 }
LOCAL nTitlebar := GETTITLEHEIGHT()
LOCAL nHeader   := 30
LOCAL nToolbar  := 50

   hGrid := GetControlHandle( "Brow_2", oModiStr )
   aRect := LISTVIEW_GETITEMRECT( hGrid, 0 )
   nHeigh := aRect[ 4 ] - aRect[ 2 ]

   IF !EMPTY( nHeigh )
      nHeigh += nFrame
      Setproperty( oModiStr, "Brow_2", "Height", ( nHeigh * iMax ) + nHeader )

      Setproperty( oModiStr, "Height", ( nHeigh * iMax ) + nHeader + nTitlebar + nToolbar + 10 )
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure DBF_EditStruRec()
*+
*+    Called from ( browser.prg )   1 - static procedure do_modi_stru()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE DBF_EditStruRec( cWin, cGrid, aStruc )

   EditStruRec( aStruc )
   DoMethod( cWin, cGrid, "Refresh" )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SaveCreate()
*+
*+    Called from ( browser.prg )   2 - static procedure do_modi_stru()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SaveCreate( aStruc, aClone )

   MsgInfo( "under Construction" )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure CloseForm2()
*+
*+    Called from ( browser.prg )   1 - static procedure do_modi_stru()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE CloseForm2()

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function AtInside()
*+
*+    Called from ( browser.prg )   1 - static procedure pre_setnewindex()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION AtInside( cMarker, cText )

LOCAL nPos := 1
LOCAL nIst := 0
LOCAL aRet := {}

   DO WHILE .T.
      nPos := AT( cMarker, cText )
      IF nPos > 0
         nIst ++
         AADD( aRet, LTRIM( SUBSTR( cText, 1, ( nPos - 1 ) ) ) )
         cText := SUBSTR( cText, ( nPos + 1 ), LEN( cText ) - nPos )
      ELSE
         //          IF nIst > 0
         AADD( aRet, LTRIM( cText ) )
         //          ENDIF
         EXIT
      ENDIF
   ENDDO

RETURN aRet

*+--------------------------------------------------------------------
*+
*+    Procedure DoFindWin()
*+
*+    Called from ( browser.prg )   2 - procedure browseview()
*+                                   1 - static procedure editdetail()
*+                                   1 - static procedure pre_setnewindex()
*+                                   1 - static procedure doseek()
*+                                   1 - static procedure copyresult()
*+                                   1 - static procedure doscope()
*+                                   1 - static procedure dolocate()
*+                ( hbftp.prg )   1 - function hbftp()
*+                ( viewer.prg )   1 - procedure showpdf()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE DoFindWin( cTitle )

LOCAL nWin                                                            // := FINDWINDOW( 0, cTitle )

   //    IF EMPTY( nWin )
   nWin := HMG_CallDLL( "User32.dll", DLL_OSAPI, "FindWindowA", 0, cTitle )
   //    ENDIF

   IF !EMPTY( nWin )
      HMG_CallDLL( "User32.dll", DLL_OSAPI, "SetForegroundWindow", nWin )
      HMG_CallDLL( "User32.dll", DLL_OSAPI, "BringWindowToTop", nWin )
      HMG_CallDLL( "User32.dll", DLL_OSAPI, "ShowWindow", nWin, 1 )
      HMG_CallDLL( "User32.dll", DLL_OSAPI, "UpdateWindow", nWin )
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function NeedOEMConvert()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION NeedOEMConvert()

LOCAL cTxt      := SP_cCodepage()
LOCAL _CodePage := ""
LOCAL lRet      := .F.
   //    ALTD()
   // look for Codepage
   DO CASE
      CASE _CodePage = "DOS 437"
      CASE _CodePage = "DOS 850"
         lRet := .T.
      CASE _CodePage = "WIN 1251"
      CASE _CodePage = "WIN 1250"
      CASE _CodePage = "DOS 852"
      CASE _CodePage = "DOS 865"
      CASE _CodePage = "DOS 866"
         // ??? mehr
   ENDCASE

RETURN lRet

*+--------------------------------------------------------------------
*+
*+    Static Procedure ThisDbfInfo()
*+
*+    Called from ( browser.prg )   2 - procedure browseview()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ThisDbfInfo( cDBF, cWorkArea )

LOCAL nHandle, _CodePage := "", cMsg := ""

   cMsg := "DBF         " + cDBF + CRLF
   cMsg += "WorkArea    " + cWorkArea + CRLF
   cMsg += "Extension   " + SP_cInxExt() + CRLF
   cMsg += "Codepage    " + SP_cCodepage() + CRLF
   cMsg += "last update " + DTOC( DBINFO( DBI_LASTUPDATE ) ) + CRLF
   cMsg += "Fields      " + hb_NTOS( DBINFO( DBI_FCOUNT ) ) + CRLF
   cMsg += "Header Size " + hb_NTOS( DBINFO( DBI_GETHEADERSIZE ) ) + CRLF
   cMsg += "Rec Size    " + hb_NTOS( DBINFO( DBI_GETRECSIZE ) ) + CRLF
   cMsg += "Records     " + hb_NTOS( RECCOUNT() ) + CRLF + CRLF

   cMsg += "DBF Size    " + hb_NTOS( ( DBINFO( DBI_GETRECSIZE ) * RECCOUNT() ) + DBINFO( DBI_GETHEADERSIZE ) + 1 )

   MsgInfo( cMsg )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure QueryTest()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE QueryTest()

LOCAL nRow  := This.QueryRowIndex
LOCAL nCol  := This.Querycolindex
LOCAL aData := This.QueryData
LOCAL xVal, cData

   //    ALTD()

   IF .NOT. EMPTY( nRow )
      GOTO( nRow )
      xVal := FIELDGET( nCol )
      DO CASE
         CASE VALTYPE( xVal ) = "N"
            cData := STR( xVal )
         CASE VALTYPE( xVal ) = "D"
            cData := DTOC( xVal )
         CASE VALTYPE( xVal ) = "L"
            cData := IF( xVal = .T., ".T.", ".F." )
         CASE VALTYPE( xVal ) = "C"
            IF SP_lOEM2ANSI()
               cData := HB_OEMTOANSI( xVal )
            ELSE
               cData := xVal
            ENDIF
         OTHERWISE
            cData := VAR2CHAR( xVal )
      ENDCASE
      This.QueryData := cData
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoDebbbuug()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoDebbbuug()

LOCAL aaa, i, iMax, bbb
LOCAL aStruc, cSeek, nPosi, cType

   //    ALTD()

   aaa := ACLONE( _HMG_SYSDATA[ 326 ] )                               // -> Current Control Definition: "ColumnFields"
   aStruc := DBSTRUCT()

   iMax := LEN( aaa )
   FOR i := 1 TO iMax
      cSeek := aaa[ i ]
      nPosi := ASCAN( aStruc, { | e | e[ DBS_NAME ] = cSeek } )
      IF nPosi > 0
         cType := aStruc[ nPosi ] [ DBS_TYPE ]
         IF cType = "C"
            aaa[ i ] := "HB_OEMTOANSI( " + cSeek + " )"
         ENDIF
      ENDIF
   NEXT

   _HMG_SYSDATA[ 326 ] := ACLONE( aaa )

   bbb := ACLONE( _HMG_SYSDATA[ 326 ] )                               // -> Current Control Definition: "ColumnFields"

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SelecLang()
*+
*+    Called from ( browser.prg )   2 - procedure browseview()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SelecLang( cPath, cDBF, cWorkArea, cBroMacro )

LOCAL cCodepage
LOCAL cExt      := SP_cInxExt()
LOCAL cVia

   IF cExt = "NTX"
      cVia := "DBFNTX"
   ELSE
      cVia := "DBFCDX"
   ENDIF

   cCodepage := WinCodePage()
   IF !EMPTY( cCodepage )
      CLOSE( cDBF )
      USE (cPath+cDBF) VIA (cVia) EXCLUSIVE CODEPAGE (cCodepage)
      Domethod( cBroMacro, "BrowserView", "Refresh" )
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Function WinCodePage()
*+
*+    Called from ( browser.prg )   1 - static procedure seleclang()
*+                ( modistru.prg )   1 - static procedure ongo_export()
*+
*+--------------------------------------------------------------------
*+
FUNCTION WinCodePage()

LOCAL cRet      := ""
LOCAL aLangName := { "Basque", ;
                        "Czech 852", ;
                        "Czech ISO-8859-2", ;
                        "Czech KAM", ;
                        "Catalan", ;
                        "English", ;
                        "French", ;
                        "Galician", ;
                        "German Ansi", ;
                        "German OEM", ;
                        "Hebrew 862", ;
                        "Hebrew 1255", ;
                        "Hungarian 852", ;
                        "Hungarian CWI-2", ;
                        "Hungarian WINDOWS-1", ;
                        "Italian", ;
                        "Polish 852", ;
                        "Polish ISO-8859-1", ;
                        "Polish Mozowia", ;
                        "Portuguese", ;
                        "Romanian", ;
                        "Russian WINDOWS-1", ;
                        "Serbian ISO-8859-2", ;
                        "Serbian 852", ;
                        "Spanish" }

LOCAL aLangID := { "EU", ;
                      "CS852", ;
                      "CSISO", ;
                      "CSKAM", ;
                      "CA", ;
                      "EN", ;
                      "FR", ;
                      "GL", ;
                      "DEWIN", ;
                      "DE850", ;
                      "HE862", ;
                      "HEWIN", ;
                      "HU852", ;
                      "HUCWI", ;
                      "HUWIN", ;
                      "IT", ;
                      "PL852", ;
                      "PLISO", ;
                      "PLMAZ", ;
                      "PT", ;
                      "RO", ;
                      "RUWIN", ;
                      "SRISO", ;
                      "SR852", ;
                      "ES" }

LOCAL nItem := 0

   DEFINE WINDOW wndSelItem ;
              AT 0, 0 ;
              WIDTH 245 ;
              HEIGHT 470 ;
              TITLE "Codepage" ;
              ICON "A1MAIN" ;
              TOPMOST ;
              NOSIZE ;
              NOMINIMIZE ;
              NOMAXIMIZE ;
              BACKCOLOR SP_nColor1()

      @ 20, 20 LISTBOX lbxItems ;
              WIDTH 200 ;
              HEIGHT 410 ;
              ITEMS aLangName ;
              VALUE 1 ;
              BACKCOLOR SP_nColor9() ;
              FONTCOLOR SP_nColor10() ;
              FONT SP_cFontName() ;
              SIZE SP_nFontSize() ;
              ON DBLCLICK { || nItem := wndSelItem.lbxItems.Value, wndSelItem.Release }

   END WINDOW

   wndSelItem.lbxItems.SetFocus

   ON KEY ESCAPE OF wndSelItem ACTION Domethod( "wndSelItem", "Release" )

   CENTER WINDOW wndSelItem
   ACTIVATE WINDOW wndSelItem

   IF !EMPTY( nItem )
      cRet := aLangID[ nItem ]
   ELSE
      cRet := ""
   ENDIF

RETURN cRet

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoCreateIndex()
*+
*+    Called from ( browser.prg )   1 - procedure browseview()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoCreateIndex( cPath, cDBF, cWorkArea, aStruc, lEdit )

LOCAL aItems := {}
LOCAL i, iMax

   iMax := LEN( aStruc )

   IF lEdit = .F.
      MsgInfo( "MUST use F4 Edit Mode to create Index" )
      RETURN
   ENDIF

   FOR i := 1 TO iMax
      AADD( aItems, { aStruc[ i ] [ DBS_NAME ], ;
                      aStruc[ i ] [ DBS_TYPE ], ;
                      aStruc[ i ] [ DBS_LEN ], ;
                      aStruc[ i ] [ DBS_DEC ] } )
   NEXT

   DEFINE WINDOW WinNewIndex ;
              AT 0, 0 ;
              WIDTH 550 ;
              HEIGHT 300 ;
              TITLE "Create Index" ;
              ICON "A1MAIN" ;
              ON INIT Nil ;
              ON SIZE Nil ;
              NOMAXIMIZE ;
              NOMINIMIZE ;
              TOPMOST ;
              BACKCOLOR { 8, 8, 8 }

      DEFINE LABEL Label_Text
         ROW 10
         COL 10
         WIDTH 350
         HEIGHT 30
         VALUE ""
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         VISIBLE .T.
         TRANSPARENT .F.
         BACKCOLOR { 8, 8, 8 }
         FONTCOLOR { 0, 255, 255 }
      END LABEL

      DEFINE LABEL Label_2
         ROW 50
         COL 10
         WIDTH 40
         HEIGHT 30
         VALUE "File"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         TOOLTIP ""
         VISIBLE .T.
         TRANSPARENT .F.
         BACKCOLOR { 8, 8, 8 }
         FONTCOLOR { 0, 255, 255 }
      END LABEL

      DEFINE LABEL Label_3
         ROW 90
         COL 10
         WIDTH 40
         HEIGHT 30
         VALUE "Key"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         TOOLTIP ""
         VISIBLE .T.
         TRANSPARENT .F.
         BACKCOLOR { 8, 8, 8 }
         FONTCOLOR { 0, 255, 255 }
      END LABEL

      DEFINE LISTBOX List_Fields
         ROW 10
         COL 370
         WIDTH 160
         HEIGHT 240
         ITEMS {}
         VALUE 1
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         TOOLTIP ""
         BACKCOLOR { 8, 8, 8 }
         FONTCOLOR { 0, 255, 255 }
         ONDBLCLICK SetThisField( aItems )
         TABSTOP .T.
         VISIBLE .T.
         SORT .F.
         MULTISELECT .F.
      END LISTBOX

      DEFINE TEXTBOX Text_File
         ROW 50
         COL 60
         WIDTH 300
         HEIGHT 30
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         TOOLTIP ""
         ONENTER Nil
         TABSTOP .T.
         VISIBLE .T.
         DISABLEDBACKCOLOR Nil
         DISABLEDFONTCOLOR Nil
         CASECONVERT NONE
         BACKCOLOR Nil
         FONTCOLOR Nil
         INPUTMASK Nil
         FORMAT Nil
         VALUE ""
      END TEXTBOX

      DEFINE TEXTBOX Text_Key
         ROW 90
         COL 60
         WIDTH 300
         HEIGHT 30
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         ONENTER Nil
         TABSTOP .T.
         VISIBLE .T.
         DISABLEDBACKCOLOR Nil
         DISABLEDFONTCOLOR Nil
         CASECONVERT NONE
         BACKCOLOR Nil
         FONTCOLOR Nil
         INPUTMASK Nil
         FORMAT Nil
         VALUE ""
      END TEXTBOX

      DEFINE BUTTON Button_OK
         ROW 150
         COL 10
         WIDTH 100
         HEIGHT 100
         ACTION CreateNewIndex( cPath, cDBF )
         CAPTION "&OK"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         TOOLTIP ""
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
         PICTURE Nil
         PICTALIGNMENT TOP
      END BUTTON

      DEFINE BUTTON Button_Abort
         ROW 150
         COL 260
         WIDTH 100
         HEIGHT 100
         ACTION Domethod( "WinNewIndex", "Release" )
         CAPTION "&Abort"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         TOOLTIP ""
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
         PICTURE Nil
         PICTALIGNMENT TOP
      END BUTTON

   END WINDOW

   WinNewIndex.Label_Text.Value := "Index " + cDBF + " to ..."

   iMax := LEN( aItems )
   FOR i := 1 TO iMax
      Domethod( "WinNewIndex", "List_Fields", "AddItem", aItems[ i ] [ DBS_NAME ] )
   NEXT

   ON KEY ESCAPE OF WinNewIndex ACTION Domethod( "WinNewIndex", "Release" )

   Domethod( "WinNewIndex", "List_Fields", "setfocus" )
   CENTER WINDOW WinNewIndex
   ACTIVATE WINDOW WinNewIndex

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SetThisField()
*+
*+    Called from ( browser.prg )   1 - static procedure docreateindex()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SetThisField( aItems )

LOCAL nRow  := GetProperty( "WinNewIndex", "List_Fields", "Value" )
LOCAL cType

   IF nRow > 0 .AND. nRow <= LEN( aItems )
      // Filename
      WinNewIndex.Text_File.Value := aItems[ nRow ] [ DBS_NAME ]
      // convert to String
      cType := aItems[ nRow ] [ DBS_TYPE ]
      DO CASE
         CASE cType = "C"
            WinNewIndex.Text_Key.Value := aItems[ nRow ] [ DBS_NAME ]
         CASE cType = "N"
            WinNewIndex.Text_Key.Value := "STR( " + aItems[ nRow ] [ DBS_NAME ] + " )"
         CASE cType = "D"
            WinNewIndex.Text_Key.Value := "DTOS( " + aItems[ nRow ] [ DBS_NAME ] + " )"
         CASE cType = "L"
            WinNewIndex.Text_Key.Value := "IF( " + aItems[ nRow ] [ DBS_NAME ] + " = .T.," + "'.T.'," + "'.F.'" + ") "
         OTHERWISE
            WinNewIndex.Text_Key.Value := aItems[ nRow ] [ DBS_NAME ]
      ENDCASE
      Domethod( "WinNewIndex", "Text_Key", "setfocus" )
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure CreateNewIndex()
*+
*+    Called from ( browser.prg )   1 - static procedure docreateindex()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE CreateNewIndex( cPath, cDBF )

LOCAL cFile  := WinNewIndex.Text_File.Value
LOCAL cKey   := WinNewIndex.Text_Key.Value
LOCAL lRet   := .F.
LOCAL bError

   bError := ERRORBLOCK( { | oErr | BREAK( oErr ) } )
   BEGIN SEQUENCE
      INDEX ON &cKey TO &cFile ADDITIVE
      lRet := .T.
   END SEQUENCE
   ERRORBLOCK( bError )

   IF lRet = .T.
      Domethod( "WinNewIndex", "Release" )
   ELSE
      msgInfo( "Error " + cKey )
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SetDbfFilter()
*+
*+    Called from ( browser.prg )   1 - procedure browseview()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SetDbfFilter()

LOCAL cFilter
LOCAL cOld    := DBFILTER()
LOCAL nrec    := RECNO()

   //   SP_cFilter( "" )             // clear String
   SP_cFilter( cOld )
   HBFILTER()
   cFilter := SP_cFilter()
   IF !EMPTY( cFilter )
      IF cFilter = "ABORT"
         SET FILTER TO
      ELSE
         SET FILTER TO &cFilter
      ENDIF
      GO TOP
   ELSE
      IF !EMPTY( cOld )
         SET FILTER TO &cOld
      ENDIF
      GOTO( nrec )
   ENDIF

   Domethod( oBrowse, "BrowserView", "SetFocus" )
   Domethod( oBrowse, "BrowserView", "Refresh" )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure RefreshBrowseLine()
*+
*+    Called from ( browser.prg )   1 - static procedure editdetail()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE RefreshBrowseLine( cForm, cBrowse, aStruc )

   // Refreshline(cBroMacro,aStruc)
LOCAL i, iMax
LOCAL cField, xValue
LOCAL h, nIdx, nRow
   //    local aStruc

   nIdx := GetControlIndex( cBrowse, cForm )
   h := GetControlHandle( cBrowse, cForm )
   nRow := LISTVIEW_GETFIRSTITEM( h )                                 // this function returns current screen row number
   //   aStruc := _HMG_SYSDATA [ 31 ] [nIdx]   // array conainig FIELDS parameter
   //   aStruc := _HMG_aControlRangeMin [ 31 ] [nIdx] // extended Version

   iMax := LEN( aStruc )
   FOR i := 1 TO iMax
      //      cField := aStruc[ i ][DBS_NAME]
      cField := aStruc[ i ]
      xValue := &( cField )
      IF VALTYPE( xValue ) == "N"
         xValue := hb_ntos( xValue )
      ENDIF
      SetProperty( cForm, cBrowse, "CELL", nRow, i, xValue )
   NEXT i

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure AddNewRecord()
*+
*+    Called from ( browser.prg )   1 - procedure browseview()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE AddNewRecord( cForm, cObj, cWorkArea, cDbf, aFeld, lEdit )

   IF USED()
      APPEND BLANK
      GOTO( RECNO() )
#IFDEF Use_DataBrowse
      SetProperty( cForm, cObj, "Value", RECNO() )
#ELSE
      SetProperty( cForm, cObj, "RecNo", RECNO() )
#ENDIF
      EditDetail( cForm, cWorkArea, cDbf, aFeld, lEdit )
      Domethod( cForm, cObj, "Refresh" )
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DelThisRecord()
*+
*+    Called from ( browser.prg )   1 - procedure browseview()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DelThisRecord( cForm, cObj, lEdit )

   IF USED()
      IF RLOCK()
         IF DELETED()
            DBRECALL()
         ELSE
            DBDELETE()
         ENDIF
         UNLOCK
      ENDIF
   ENDIF
   ShowDelete( cForm, cObj, lEdit )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure ShowDelete()
*+
*+    Called from ( browser.prg )   2 - procedure browseview()
*+                                   1 - static procedure delthisrecord()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ShowDelete( cForm, cObj, lEdit )

LOCAL nRecno, nCount, cText := ""
   //    SetProperty( cForm, cObj, "ColumnDYNAMICFORECOLOR", 1, { || IF( DELETED(), aForeColorHBP, SP_nColor10() ) } )
   //    SetProperty( cForm, cObj, "ColumnDYNAMICBACKCOLOR", 1, { || IF( DELETED(), aBackColorHBP, SP_nColor9()  ) } )

#IFDEF Use_DataBrowse
   IF INDEXORD() > 0
      IF DELETED()
         cText := "Deleted logical Record " + hb_NTOS( ORDKEYNO() ) + "/" + hb_NTOS( ORDKEYCOUNT() )
      ELSE
         cText := "logical Record " + hb_NTOS( ORDKEYNO() ) + "/" + hb_NTOS( ORDKEYCOUNT() )
      ENDIF
   ELSE
      IF DELETED()
         cText := "Deleted Record " + hb_NTOS( RECNO() ) + "/" + hb_NTOS( RECCOUNT() )
      ELSE
         cText := "Record " + hb_NTOS( RECNO() ) + "/" + hb_NTOS( RECCOUNT() )
      ENDIF
   ENDIF
#ELSE
   nRecno := GetProperty( cForm, cObj, "RecNo" )
   nCount := GetProperty( cForm, cObj, "Itemcount" )
   cText := "Element " + hb_NTOS( nRecno ) + "/" + hb_NTOS( nCount )
#ENDIF
   BroSbar( cText )
RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure BroSbar()
*+
*+    Called from ( browser.prg )   1 - static procedure showdelete()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE BroSbar( cText )

   SetProperty( oBrowse, "StatusBar", "Item", 1, cText )
RETURN

*+ EOF: BROWSER.PRG
