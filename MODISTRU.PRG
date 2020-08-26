*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\MODISTRU.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Function ShowArrayStru()
*+               Static Procedure CalcNewGridSize()
*+               Static Function OnDataRequestStruct()
*+               Procedure Pre_EditStruRec()
*+               Procedure EditStruRec()
*+               Static Procedure SaveArray()
*+               Static Procedure VALID_Text_1()
*+               Static Procedure VALID_Text_2()
*+               Static Procedure VALID_Text_3()
*+               Static Procedure VALID_Text_4()
*+               Static Procedure MaxItemLen()
*+               Procedure XLSexport()
*+               Static Procedure ExportXLS()
*+               Static Procedure Pre_Export()
*+               Static Procedure OnChange_Export()
*+               Static Function OnInit_Path()
*+               Static Procedure OnGet_Folder()
*+               Static Procedure OnGo_Export()
*+               Static Procedure Export_Button()
*+               Static Function WriteADO2SDF()
*+
*+       Tables: USE ( cExportTo ) VIA (cVIA) EXCLUSIVE
*+               USE ( cExportTo ) VIA (cVIA) EXCLUSIVE CODEPAGE (cCodepage)
*+
*+    Reformatted by Click! 2.05.30 on Aug-25-2020 at  5:17 am
*+
*+--------------------------------------------------------------------

#include "hmg.ch"
#INCLUDE "Dbstruct.ch"
#INCLUDE "fileio.ch"
#INCLUDE "common.ch"

#define ID_NAME            1
#define ID_TYPE            2
#define ID_LEN             3

MEMVAR nGridFocus, aWin
MEMVAR _HMG_SYSDATA

*+--------------------------------------------------------------------
*+
*+    Function ShowArrayStru()
*+
*+    Called from ( ado.prg )   2 - procedure ado_view()
*+
*+--------------------------------------------------------------------
*+
FUNCTION ShowArrayStru( aGridData, aHeadLine, myXlsFile )

LOCAL aStruc    := {}, cField, cType, nLen
LOCAL ii, iMax, aWork, aSort, xValue, nMax
LOCAL nWide, nHeight
LOCAL aHead     := { "Name", "Type", "Len", "Dec" }
LOCAL aWide     := { 110, 50, 60, 60 }
LOCAL aJustify  := { GRID_JTFY_LEFT, GRID_JTFY_LEFT, GRID_JTFY_LEFT, GRID_JTFY_LEFT }
LOCAL nTitlebar := GETTITLEHEIGHT()
   // LOCAL xValue1

STATIC isRunning := .F.

   IF isRunning = .T.

   ELSE
      isRunning := .T.

      iMax := LEN( aHeadLine )
      FOR ii := 1 TO iMax
         cField := aHeadLine[ ii ] [ ID_NAME ]
         cType := aHeadLine[ ii ] [ ID_TYPE ]
         nLen := aHeadLine[ ii ] [ ID_LEN ]
         AADD( aStruc, { cField, cType, nLen, 0 } )
      NEXT

      nWide := 320
      nHeight := ( iMax * 22 ) + nTitlebar + 50 + 30

      DEFINE WINDOW ShowArrayStru ;
                 AT 0, 0 ;
                 WIDTH nWide HEIGHT nHeight ;
                 TITLE myXlsFile ;
                 ICON "ICOEXCEL" ;
                 TOPMOST ;
                 FONTNAME SP_cFontName() ;
                 FONTSIZE SP_nFontlarge() ;
                 NOSIZE ;
                 NOMINIMIZE ;
                 NOMAXIMIZE ;
                 ON GOTFOCUS WinTans( ThisWindow.Name, .T. ) ;
                 ON LOSTFOCUS WinTans( ThisWindow.Name, .F. ) ;
                 BACKCOLOR SP_nColor1()

         DEFINE TOOLBAR oTOOLBAR BUTTONSIZE 50, 50 FLAT BORDER
            BUTTON oBtInfo ;
                    TOOLTIP "check max. Lengh of each Column" ;
                    PICTURE "MYINFO32" ;
                    SEPARATOR ;
                    ACTION MaxItemLen( aGridData, aStruc )

            // BUTTON oBtSave ;
            //         TOOLTIP "Export" ;
            //         PICTURE "MYBAG32" ;
            //         SEPARATOR ;
            //         ACTION XLSexport( aGridData, myXlsFile )
         END TOOLBAR

         DEFINE GRID XLSGrid1
            PARENT ShowArrayStru
            ROW 50
            COL 10
            WIDTH nWide - 30
            HEIGHT nHeight - nTitlebar - 50 - 30
            HEADERS aHead
            WIDTHS aWide
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontlarge()
            BACKCOLOR SP_nColor9()
            FONTCOLOR SP_nColor10()
            JUSTIFY aJustify
            ONDBLCLICK Pre_EditStruRec( ThisWindow.Name, This.Name, aStruc )
            ITEMCOUNT LEN( aStruc )
            VIRTUAL .T.
            ON QUERYDATA OnDataRequestStruct( aStruc, ThisWindow.Name, This.Name )
         END GRID

         // ALLOWEDIT .F.
         // COLUMNWHEN {.F.,.T.,.T.,.T.}

         // ITEMS aStruc
         // CELLNAVIGATION .F.
         // ALLOWAPPEND .T.
         // ALLOWDELETE .T.

      END WINDOW
      SetProperty( "ShowArrayStru", "XLSGrid1", "PaintDoubleBuffer", .T. )

      CalcNewGridSize( iMax )

      SP_lPbarRunning( .F. )
      ON KEY ESCAPE OF ShowArrayStru ACTION ShowArrayStru.Release
      CENTER WINDOW ShowArrayStru
      ACTIVATE WINDOW ShowArrayStru

      isRunning := .F.

   ENDIF

RETURN aStruc

*+--------------------------------------------------------------------
*+
*+    Static Procedure CalcNewGridSize()
*+
*+    Called from ( modistru.prg )   1 - function showarraystru()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE CalcNewGridSize( iMax )

LOCAL hGrid, nHeigh, nFrame := 4
LOCAL aRect     := { 0, 0, 0, 0 }
LOCAL nTitlebar := GETTITLEHEIGHT()
LOCAL nHeader   := 30
LOCAL nToolbar  := 50

   hGrid := GetControlHandle( "XLSGrid1", "ShowArrayStru" )
   aRect := LISTVIEW_GETITEMRECT( hGrid, 0 )
   nHeigh := aRect[ 4 ] - aRect[ 2 ]

   IF !EMPTY( nHeigh )
      nHeigh += nFrame
      Setproperty( "ShowArrayStru", "XLSGrid1", "Height", ( nHeigh * iMax ) + nHeader )

      Setproperty( "ShowArrayStru", "Height", ( nHeigh * iMax ) + nHeader + nTitlebar + nToolbar + 10 )
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function OnDataRequestStruct()
*+
*+    Called from ( modistru.prg )   1 - function showarraystru()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION OnDataRequestStruct( aData, cForm, cObj )

LOCAL nRow                                                            // := Getproperty( cForm, cGrid_Left ,"QueryRowIndex" )
LOCAL nCol                                                            // := Getproperty( cForm, cGrid_Left ,"Querycolindex" )
LOCAL xVal

   nRow := This.QueryRowIndex
   nCol := This.Querycolindex

   IF .NOT. EMPTY( nRow ) .AND. LEN( aData ) >= nRow
      xVal := aData[ nRow ] [ nCol ]
      This.QueryData := xVal
   ENDIF

RETURN .T.

*+--------------------------------------------------------------------
*+
*+    Procedure Pre_EditStruRec()
*+
*+    Called from ( modistru.prg )   1 - function showarraystru()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE Pre_EditStruRec( cWin, cGrid, aData )

   EditStruRec( aData )
   DoMethod( cWin, cGrid, "Refresh" )
RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure EditStruRec()
*+
*+    Called from ( browser.prg )   1 - procedure dbf_editstrurec()
*+                ( modistru.prg )   1 - procedure pre_editstrurec()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE EditStruRec( aData )

LOCAL nRow := This.CellRowIndex
LOCAL nCol := This.CellColIndex

   IF .NOT. EMPTY( nRow ) .AND. LEN( aData ) >= nRow

      DEFINE WINDOW EditStruRec ;
                 AT 0, 0 ;
                 WIDTH 213 HEIGHT 225 ;
                 TITLE "Edit Structure" ;
                 ICON "ICOINFO" ;
                 TOPMOST ;
                 NOSIZE ;
                 NOMINIMIZE ;
                 NOMAXIMIZE ;
                 BACKCOLOR SP_nColor1()

         DEFINE LABEL Label_1
            ROW 10
            COL 10
            WIDTH 50
            HEIGHT 24
            VALUE "Name"
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontlarge()
            TOOLTIP ""
            VISIBLE .T.
            TRANSPARENT .F.
            ACTION Nil
            AUTOSIZE .F.
            BACKCOLOR Nil
            FONTCOLOR Nil
         END LABEL

         DEFINE LABEL Label_2
            ROW 40
            COL 10
            WIDTH 50
            HEIGHT 24
            VALUE "Type"
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontlarge()
            TOOLTIP ""
            VISIBLE .T.
            TRANSPARENT .F.
            ACTION Nil
            AUTOSIZE .F.
            BACKCOLOR Nil
            FONTCOLOR Nil
         END LABEL

         DEFINE LABEL Label_3
            ROW 70
            COL 10
            WIDTH 50
            HEIGHT 24
            VALUE "Len"
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontlarge()
            TOOLTIP ""
            VISIBLE .T.
            TRANSPARENT .F.
            ACTION Nil
            AUTOSIZE .F.
            BACKCOLOR Nil
            FONTCOLOR Nil
         END LABEL

         DEFINE LABEL Label_4
            ROW 100
            COL 10
            WIDTH 50
            HEIGHT 24
            VALUE "Dec"
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontlarge()
            TOOLTIP ""
            VISIBLE .T.
            TRANSPARENT .F.
            ACTION Nil
            AUTOSIZE .F.
            BACKCOLOR Nil
            FONTCOLOR Nil
         END LABEL

         DEFINE TEXTBOX Text_1
            ROW 10
            COL 70
            WIDTH 120
            HEIGHT 24
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontlarge()
            TOOLTIP ""
            ONCHANGE nil                                              // VALID_Text_1()
            ONGOTFOCUS Nil
            ONLOSTFOCUS Nil
            ONENTER Nil
            HELPID Nil
            TABSTOP .F.
            VISIBLE .T.
            READONLY .T.
            RIGHTALIGN .F.
            DISABLEDBACKCOLOR Nil
            DISABLEDFONTCOLOR Nil
            CASECONVERT NONE
            MAXLENGTH 10
            BACKCOLOR SP_nColor5()
            FONTCOLOR SP_nColor6()
            INPUTMASK "!!!!!!!!!!"
            FORMAT Nil
            VALUE ""
         END TEXTBOX

         DEFINE TEXTBOX Text_2
            ROW 40
            COL 70
            WIDTH 120
            HEIGHT 24
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontlarge()
            TOOLTIP ""
            ONCHANGE nil                                              // VALID_Text_2()
            ONGOTFOCUS Nil
            ONLOSTFOCUS Nil
            ONENTER VALID_Text_2()
            HELPID Nil
            TABSTOP .T.
            VISIBLE .T.
            READONLY .F.
            RIGHTALIGN .F.
            DISABLEDBACKCOLOR Nil
            DISABLEDFONTCOLOR Nil
            CASECONVERT NONE
            MAXLENGTH 1
            BACKCOLOR SP_nColor5()
            FONTCOLOR SP_nColor6()
            INPUTMASK "!"
            FORMAT Nil
            VALUE ""
         END TEXTBOX

         DEFINE TEXTBOX Text_3
            ROW 70
            COL 70
            WIDTH 120
            HEIGHT 24
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontlarge()
            TOOLTIP ""
            ONCHANGE nil                                              // VALID_Text_3()
            ONGOTFOCUS Nil
            ONLOSTFOCUS Nil
            ONENTER VALID_Text_3()
            HELPID Nil
            TABSTOP .T.
            VISIBLE .T.
            READONLY .F.
            RIGHTALIGN .F.
            DISABLEDBACKCOLOR Nil
            DISABLEDFONTCOLOR Nil
            CASECONVERT NONE
            MAXLENGTH 3
            BACKCOLOR SP_nColor5()
            FONTCOLOR SP_nColor6()
            INPUTMASK "999"
            FORMAT Nil
            NUMERIC .T.
            VALUE Nil
         END TEXTBOX

         DEFINE TEXTBOX Text_4
            ROW 100
            COL 70
            WIDTH 120
            HEIGHT 24
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontlarge()
            TOOLTIP ""
            ONCHANGE nil                                              // VALID_Text_4()
            ONGOTFOCUS Nil
            ONLOSTFOCUS Nil
            ONENTER VALID_Text_4()
            HELPID Nil
            TABSTOP .T.
            VISIBLE .T.
            READONLY .F.
            RIGHTALIGN .F.
            DISABLEDBACKCOLOR Nil
            DISABLEDFONTCOLOR Nil
            CASECONVERT NONE
            BACKCOLOR SP_nColor5()
            FONTCOLOR SP_nColor6()
            INPUTMASK "99"
            FORMAT Nil
            NUMERIC .T.
            VALUE Nil
         END TEXTBOX

         DEFINE BUTTON Button_1
            ROW 140
            COL 10
            WIDTH 180
            HEIGHT 40
            ACTION SaveArray( aData, nRow )
            CAPTION "&Save"
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontlarge()
            TOOLTIP ""
            ONGOTFOCUS Nil
            ONLOSTFOCUS Nil
            HELPID Nil
            FLAT .F.
            TABSTOP .T.
            VISIBLE .T.
            TRANSPARENT .F.
            MULTILINE .F.
            PICTURE Nil
            PICTALIGNMENT TOP
         END BUTTON

      END WINDOW

      EditStruRec.Text_1.Value := aData[ nRow ] [ DBS_NAME ]
      EditStruRec.Text_2.Value := aData[ nRow ] [ DBS_TYPE ]
      EditStruRec.Text_3.Value := aData[ nRow ] [ DBS_LEN ]
      EditStruRec.Text_4.Value := aData[ nRow ] [ DBS_DEC ]

      ON KEY ESCAPE OF EditStruRec ACTION EditStruRec.Release
      CENTER WINDOW EditStruRec
      ACTIVATE WINDOW EditStruRec

   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SaveArray()
*+
*+    Called from ( modistru.prg )   1 - procedure editstrurec()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SaveArray( aData, nRow )

   //   aData[nRow][ DBS_NAME] := EditStruRec.Text_1.Value
   aData[ nRow ] [ DBS_TYPE ] := EditStruRec.Text_2.Value
   aData[ nRow ] [ DBS_LEN ] := EditStruRec.Text_3.Value
   aData[ nRow ] [ DBS_DEC ] := EditStruRec.Text_4.Value

   SP_aADOStruct( ACLONE( aData ) )

   EditStruRec.Release
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure VALID_Text_1()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE VALID_Text_1()

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure VALID_Text_2()
*+
*+    Called from ( modistru.prg )   1 - procedure editstrurec()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE VALID_Text_2()

LOCAL cType := EditStruRec.Text_2.Value

   IF cType $ "CMNDL"
   ELSE
      MsgInfo( "only 'CMNDL' allowed" )
      EditStruRec.Text_2.SetFocus()
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure VALID_Text_3()
*+
*+    Called from ( modistru.prg )   1 - procedure editstrurec()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE VALID_Text_3()

LOCAL cType := EditStruRec.Text_2.Value
LOCAL nLen  := EditStruRec.Text_3.Value

   IF EMPTY( nLen )
      MsgInfo( "Len must > 0" )
      EditStruRec.Text_3.Value := 1
      EditStruRec.Text_3.SetFocus()
      RETURN
   ENDIF

   DO CASE
      CASE cType = "C"
      CASE cType = "M"
      CASE cType = "N"
      CASE cType = "D"
      CASE cType = "L"
   ENDCASE

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure VALID_Text_4()
*+
*+    Called from ( modistru.prg )   1 - procedure editstrurec()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE VALID_Text_4()

LOCAL cType := EditStruRec.Text_2.Value
LOCAL nDec  := EditStruRec.Text_4.Value

   IF !EMPTY( nDec )
      IF cType $ "N"
      ELSE
         MsgInfo( "only Type 'N' allowed" )
         EditStruRec.Text_4.Value := 0
         EditStruRec.Text_2.SetFocus()
      ENDIF
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure MaxItemLen()
*+
*+    Called from ( modistru.prg )   1 - function showarraystru()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE MaxItemLen( aGridData, aStruc )

LOCAL iMax, ii, nLen, cType, nDec
LOCAL aWork, aSort, xValue
LOCAL hGrid := GetControlHandle( "XLSGrid1", "ShowArrayStru" )

   SetCursorWait( "ShowArrayStru", .T. )
   SetCursorOnControls( hGrid, IDC_WAIT )

   iMax := LEN( aStruc )
   ii := 1
   FOR ii := 1 TO iMax
      aStruc[ ii ] [ DBS_TYPE ] := "C"
      aStruc[ ii ] [ DBS_LEN ] := 1
      aStruc[ ii ] [ DBS_DEC ] := 0
   NEXT
   DoMethod( "ShowArrayStru", "XLSGrid1", "Refresh" )

   ii := 1
   FOR ii := 1 TO iMax
      aWork := ACLONE( aGridData )
      aSort := ASORT( aWork,,, { | x, y | x[ ii ] > y[ ii ] } )
      xValue := aSort[ 1 ] [ ii ]

      nLen := LEN( ALLTRIM( VAR2CHAR( xValue ) ) )
      IF nLen < 1
         nLen := 1
      ENDIF

      nDec := 0
      cType := VALTYPE( xValue )
      DO CASE
         CASE cType = "C" .AND. EMPTY( xValue )
            DO CASE
               CASE xValue = "0.00"
                  cType = "N"
                  nLen := 19
                  nDec := 2
               CASE xValue = "  .  .  "
                  cType = "D"
                  nLen := 8
               CASE xValue = "  /  /  "
                  cType = "D"
                  nLen := 8
            ENDCASE

         CASE cType = "N"
            nDec := 2
      ENDCASE

      aStruc[ ii ] [ DBS_TYPE ] := cType
      aStruc[ ii ] [ DBS_LEN ] := nLen
      aStruc[ ii ] [ DBS_DEC ] := nDec

      DoMethod( "ShowArrayStru", "XLSGrid1", "Refresh" )

   NEXT

   SetCursorWait( "ShowArrayStru", .F. )
   SetCursorOnControls( hGrid, IDC_ARROW )

   SP_aADOStruct( ACLONE( aStruc ) )

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure XLSexport()
*+
*+    Called from ( ado.prg )   2 - procedure ado_view()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE XLSexport( aGridData, myXlsFile )

   ExportXLS( aGridData, myXlsFile )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure ExportXLS()
*+
*+    Called from ( modistru.prg )   1 - procedure xlsexport()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ExportXLS( aGridData, myXlsFile )

LOCAL cXLS := fileonly( myXlsFile )

   cXLS := STRTRAN( cXLS, ".XLSX", "" )
   cXLS := STRTRAN( cXLS, ".XLS", "" )

   DEFINE WINDOW ExportXLS ;
              AT 0, 0 ;
              WIDTH 400 ;
              HEIGHT 210 ;
              TITLE "Export " + myXlsFile ;
              ICON "ICOEXCEL" ;
              TOPMOST ;
              NOMAXIMIZE ;
              NOMINIMIZE ;
              ON INIT Pre_Export() ;
              ON RELEASE Nil ;
              NOSIZE ;
              ON PAINT Nil ;
              ON GOTFOCUS WinTans( ThisWindow.Name, .T. ) ;
              ON LOSTFOCUS WinTans( ThisWindow.Name, .F. ) ;
              BACKCOLOR SP_nColor1()

      DEFINE RADIOGROUP RadioGroup_1
         ROW 20
         COL 10
         WIDTH 300
         HEIGHT 28
         OPTIONS { 'DBF', 'XLSX', 'CSV' }
         VALUE 1
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE OnChange_Export()
         HELPID Nil
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
         SPACING 123
         BACKCOLOR SP_nColor5()
         FONTCOLOR SP_nColor6()
         READONLY Nil
         HORIZONTAL .T.
      END RADIOGROUP

      DEFINE LABEL Label_Path
         ROW 60
         COL 20
         WIDTH 40
         HEIGHT 20
         VALUE "Path"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         HELPID Nil
         VISIBLE .T.
         TRANSPARENT .F.
         ACTION Nil
         AUTOSIZE .F.
         BACKCOLOR SP_nColor1()
         FONTCOLOR SP_nColor2()
      END LABEL

      DEFINE LABEL Label_Name
         ROW 90
         COL 20
         WIDTH 40
         HEIGHT 24
         VALUE "Name"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         HELPID Nil
         VISIBLE .T.
         TRANSPARENT .F.
         ACTION Nil
         AUTOSIZE .F.
         BACKCOLOR SP_nColor1()
         FONTCOLOR SP_nColor2()
      END LABEL

      DEFINE TEXTBOX Text_Path
         ROW 60
         COL 70
         WIDTH 300 + 10
         HEIGHT 24
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         ONENTER Nil
         HELPID Nil
         TABSTOP .T.
         VISIBLE .T.
         READONLY .F.
         RIGHTALIGN .F.
         DISABLEDBACKCOLOR Nil
         DISABLEDFONTCOLOR Nil
         CASECONVERT NONE
         BACKCOLOR SP_nColor5()
         FONTCOLOR SP_nColor6()
         INPUTMASK Nil
         FORMAT Nil
         VALUE ""
      END TEXTBOX

      DEFINE TEXTBOX Text_Name
         ROW 90
         COL 70
         WIDTH 120
         HEIGHT 24
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         ONENTER Nil
         HELPID Nil
         TABSTOP .T.
         VISIBLE .T.
         READONLY .F.
         RIGHTALIGN .F.
         DISABLEDBACKCOLOR Nil
         DISABLEDFONTCOLOR Nil
         CASECONVERT NONE
         BACKCOLOR SP_nColor5()
         FONTCOLOR SP_nColor6()
         INPUTMASK Nil
         FORMAT Nil
         VALUE cXLS
      END TEXTBOX

      DEFINE LABEL Label_EXT
         ROW 90
         COL 200
         WIDTH 50
         HEIGHT 24
         VALUE "DBF"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         HELPID Nil
         VISIBLE .T.
         TRANSPARENT .F.
         ACTION Nil
         AUTOSIZE .F.
         BACKCOLOR SP_nColor9()
         FONTCOLOR SP_nColor10()
         ALIGNMENT Left
      END LABEL

      DEFINE LABEL Label_SDF
         ROW 90
         COL 270 + 10
         WIDTH 50
         HEIGHT 24
         VALUE "Delimter"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         HELPID Nil
         VISIBLE .T.
         TRANSPARENT .F.
         ACTION Nil
         AUTOSIZE .F.
         BACKCOLOR SP_nColor1()
         FONTCOLOR SP_nColor2()
         RIGHTALIGN .T.
      END LABEL

      DEFINE TEXTBOX Text_SDF
         ROW 90
         COL 350 + 10
         WIDTH 20
         HEIGHT 20
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         ONENTER Nil
         HELPID Nil
         TABSTOP .T.
         VISIBLE .T.
         READONLY .F.
         RIGHTALIGN .F.
         DISABLEDBACKCOLOR Nil
         DISABLEDFONTCOLOR Nil
         CASECONVERT NONE
         BACKCOLOR SP_nColor5()
         FONTCOLOR SP_nColor6()
         INPUTMASK Nil
         FORMAT Nil
         VALUE ";"
      END TEXTBOX

      DEFINE RADIOGROUP RadioGroup_2
         ROW 90
         COL 280
         WIDTH 100
         HEIGHT 24
         OPTIONS { 'NTX', 'CDX' }
         VALUE 1
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE OnChange_Export()
         HELPID Nil
         TABSTOP .F.
         VISIBLE .F.
         TRANSPARENT .F.
         SPACING 50
         BACKCOLOR SP_nColor5()
         FONTCOLOR SP_nColor6()
         READONLY Nil
         HORIZONTAL .T.
      END RADIOGROUP

      DEFINE BUTTON Button_Cancel
         ROW 130
         COL 10
         WIDTH 100
         HEIGHT 28
         ACTION ExportXLS.Release
         CAPTION "&Cancel"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         HELPID Nil
         FLAT .F.
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
         MULTILINE .F.
         PICTURE Nil
         PICTALIGNMENT TOP
      END BUTTON

      DEFINE BUTTON Button_Folder
         ROW 130
         COL 140
         WIDTH 100
         HEIGHT 28
         ACTION OnGet_Folder()
         CAPTION "&Folder"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         HELPID Nil
         FLAT .F.
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
         MULTILINE .F.
         PICTURE Nil
         PICTALIGNMENT TOP
      END BUTTON

      DEFINE BUTTON Button_Go
         ROW 130
         COL 280
         WIDTH 100
         HEIGHT 28
         ACTION OnGo_Export( aGridData )
         CAPTION "&Go"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         HELPID Nil
         FLAT .F.
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
         MULTILINE .F.
         PICTURE Nil
         PICTALIGNMENT TOP
      END BUTTON

      DEFINE PROGRESSBAR ProgressBar_1
         ROW 170
         COL 10
         WIDTH 370
         HEIGHT 3
         RANGEMIN 1
         RANGEMAX 100
         VALUE 0
         TOOLTIP ""
         HELPID Nil
         VISIBLE .T.
         SMOOTH .F.
         VERTICAL .F.
         BACKCOLOR Nil
         FORECOLOR Nil
      END PROGRESSBAR

   END WINDOW

   OnChange_Export()

   CENTER WINDOW ExportXLS
   //  ExportXLS.TXTCtrl.setfocus()
   ON KEY ESCAPE OF ExportXLS ACTION ExportXLS.Release
   ACTIVATE WINDOW ExportXLS
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure Pre_Export()
*+
*+    Called from ( modistru.prg )   1 - static procedure exportxls()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Pre_Export()

   ExportXLS.Label_SDF.hide
   ExportXLS.Text_SDF.hide
   ExportXLS.Text_SDF.value := ";"

   ExportXLS.Text_Path.value := OnInit_Path()

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure OnChange_Export()
*+
*+    Called from ( modistru.prg )   3 - static procedure exportxls()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE OnChange_Export()

LOCAL nItem := ExportXLS.RadioGroup_1.value

   IF nItem > 2
      ExportXLS.Label_SDF.show
      ExportXLS.Text_SDF.show
   ELSE
      ExportXLS.Label_SDF.hide
      ExportXLS.Text_SDF.hide
   ENDIF

   ExportXLS.Label_EXT.Value := ExportXLS.RadioGroup_1.Caption( nItem )

   IF nItem = 1
      ExportXLS.RadioGroup_2.VISIBLE := .T.
   ELSE
      ExportXLS.RadioGroup_2.VISIBLE := .F.
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function OnInit_Path()
*+
*+    Called from ( modistru.prg )   1 - static procedure pre_export()
*+                                   1 - static procedure onget_folder()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION OnInit_Path()

LOCAL nPosi, cInitPath := ""

   IF nGridFocus = 1
      nPosi := ASCAN( aWin, { | o | o[ 1 ] = "WinLeft" .AND. o[ 2 ] = SP_GridLeft() } )
      cInitPath := aWin[ nPosi ] [ 3 ]
   ELSE
      nPosi := ASCAN( aWin, { | o | o[ 1 ] = "WinRight" .AND. o[ 2 ] = SP_GridRight() } )
      cInitPath := aWin[ nPosi ] [ 3 ]
   ENDIF
RETURN cInitPath

*+--------------------------------------------------------------------
*+
*+    Static Procedure OnGet_Folder()
*+
*+    Called from ( modistru.prg )   1 - static procedure exportxls()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE OnGet_Folder()

LOCAL cTitle           := "search Folder"
LOCAL lNewFolderButton := .T.
LOCAL cDir, cInitPath := ""

   cInitPath := OnInit_Path()
   cDir := GetFolder( cTitle, TRIM( cInitPath ),, lNewFolderButton )

   IF !EMPTY( cDir )
      ExportXLS.Text_Path.value := cDir + "\"
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure OnGo_Export()
*+
*+    Called from ( modistru.prg )   1 - static procedure exportxls()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE OnGo_Export( aGridData )

LOCAL nItem      := ExportXLS.RadioGroup_1.value
LOCAL nIndex     := ExportXLS.RadioGroup_2.value
LOCAL cText_Path := ExportXLS.Text_Path.value
LOCAL cText_Name := ExportXLS.Text_Name.value
LOCAL cText_SDF  := ExportXLS.Text_SDF .value
LOCAL cExportTo  := ""
LOCAL ii, iMax, xValue, nEvery, cCodepage := ""
LOCAL jj, nFcount, cVIA, aDbStru := SP_aADOStruct()

   nFcount := LEN( aDbStru )

   Export_Button( .F. )
   ExportXLS.ProgressBar_1.Value := 0

   DO CASE
      CASE nItem = 1
         cExportTo := cText_Path + cText_Name + ".DBF"
         IF FILE( cExportTo )
            IF MsgYesNo( "Overwrite: " + cExportTo + CRLF, .T. )
               FERASE( cExportTo )
            ELSE
               Export_Button( .T. )
               RETURN
            ENDIF
         ENDIF
         DBCREATE( cExportTo, aDbStru, "DBFCDX" )

         IF nIndex = 1
            cVIA := "DBFNTX"
         ELSE
            cVIA := "DBFCDX"
         ENDIF

         cCodepage := WinCodePage()
         IF EMPTY( cCodepage )
            USE ( cExportTo ) VIA (cVIA) EXCLUSIVE
         ELSE
            USE ( cExportTo ) VIA (cVIA) EXCLUSIVE CODEPAGE (cCodepage)
         ENDIF

         iMax := LEN( aGridData )
         nEvery := ROUND( iMax / 100, 0 )

         FOR ii := 1 TO iMax
            APPEND BLANK
            jj := 1
            FOR jj := 1 TO nFcount
               xValue := aGridData[ ii ] [ jj ]
               FIELDPUT( jj, xValue )
            NEXT

            IF ( ii % nEvery ) = 0
               SetProperty( "ExportXLS", "ProgressBar_1", "Value", CalcPos( ii, iMax ) )
               DO EVENTS
            ENDIF
         NEXT
         CLOSE

      CASE nItem = 2
         cExportTo := cText_Path + cText_Name + ".XLSX"
         IF FILE( cExportTo )
            IF MsgYesNo( "Overwrite: " + cExportTo + CRLF, .T. )
               FERASE( cExportTo )
            ELSE
               Export_Button( .T. )
               RETURN
            ENDIF
         ENDIF

      CASE nItem = 3
         cExportTo := cText_Path + cText_Name + ".SDF"
         IF FILE( cExportTo )
            IF MsgYesNo( "Overwrite: " + cExportTo + CRLF, .T. )
               FERASE( cExportTo )
            ELSE
               Export_Button( .T. )
               RETURN
            ENDIF
         ENDIF

         WriteADO2SDF( cExportTo, aGridData )

   ENDCASE

   ExportXLS.ProgressBar_1.Value := 0
   ExportXLS.Release

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure Export_Button()
*+
*+    Called from ( modistru.prg )   4 - static procedure ongo_export()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Export_Button( lOnOff )

   DEFAULT lOnOff TO .T.

   ExportXLS.Button_Cancel.Enabled := lOnOff
   ExportXLS.Button_Folder.Enabled := lOnOff
   ExportXLS.Button_Go.Enabled := lOnOff

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function WriteADO2SDF()
*+
*+    Called from ( modistru.prg )   1 - static procedure ongo_export()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION WriteADO2SDF( cExportTo, aGridData )

LOCAL aStructure, ii, iMax, nRowLine, xValue, nMax, nEvery
LOCAL nHandle, nStart, nStop
LOCAL cField, nPosi, cType
LOCAL cText_SDF  := ExportXLS.Text_SDF.value

   ExportXLS.ProgressBar_1.Value := 0

   //    IF USED()
   aStructure := SP_aADOStruct()
   IF EMPTY( aStructure )
      MsgInfo( "Error empty Structure,no FIELDs" )
      RETURN .F.
   ENDIF
   iMax := LEN( aStructure )
   nMax := LEN( aGridData )
   nEvery := ROUND( nMax / 100, 0 )
   //    ELSE
   //       msgInfo( "need DBF" )
   //       RETURN .F.
   //    ENDIF

   nHandle := FCREATE( cExportTo, FC_NORMAL )
   IF nHandle == - 1
      MsgInfo( "Error create File:" + cExportTo, "Error " + VAR2CHAR( FERROR() ) )
   ELSE
      nStart := SECONDS()

      // write Header
      FOR ii := 1 TO iMax
         cField := aStructure[ ii ] [ DBS_NAME ]
         FWRITE( nHandle, cField )
         IF ii < iMax
            FWRITE( nHandle, cText_SDF )
         ENDIF
      NEXT
      FWRITE( nHandle, CRLF )

      nRowLine := 1
      FOR nRowLine := 1 TO nMax
         ii := 1
         FOR ii := 1 TO iMax
            xValue := VAR2CHAR( aGridData[ nRowLine ] [ ii ] )
            FWRITE( nHandle, xValue )
            IF ii < iMax
               FWRITE( nHandle, cText_SDF )
            ENDIF
         NEXT
         FWRITE( nHandle, CRLF )

         IF ( nRowLine % nEvery ) = 0
            SetProperty( "ExportXLS", "ProgressBar_1", "Value", CalcPos( nRowLine, nMax ) )
            DO EVENTS
         ENDIF
      NEXT
      FCLOSE( nHandle )
      ExportXLS.ProgressBar_1.Value := 0

      nStop := SECONDS() - nStart

      // Msginfo( "finish after " + LTRIM( STR( nStop ) ) )

   ENDIF

   DO EVENTS

RETURN .T.

//
//
//

*+ EOF: MODISTRU.PRG
