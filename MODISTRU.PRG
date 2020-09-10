*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\MODISTRU.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Function ShowArrayStru()
*+               Static Procedure CalcNewGridSize()
*+               Function OnDataRequestStruct()
*+               Procedure Pre_EditStruRec()
*+               Procedure EditStruRec()
*+               Static Procedure SaveArray()
*+               Static Procedure VALID_Text_Len()
*+               Static Procedure VALID_Text_Dec()
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
*+               Procedure CreateNewDbf()
*+               Static Procedure CloseForm()
*+               Static Procedure LoadNewStruct()
*+               Static Procedure CRE_DBUU()
*+               Static Procedure Scatter()
*+               Static Procedure DoAppendBlank()
*+               Static Procedure DoEditSave()
*+               Static Procedure DoDelRecall()
*+               Static Procedure DoCreDBFNow()
*+               Static Procedure DoZAPnow()
*+               Static Procedure RefreshBrowseLine()
*+               Static Function Check_Name()
*+               Static Function CHECK_A2Z()
*+               Static Function Check_Type()
*+               Static Function Check_Len()
*+               Static Function Check_Dec()
*+
*+       Tables: USE ( cExportTo ) VIA (cVIA) EXCLUSIVE
*+               USE ( cExportTo ) VIA (cVIA) EXCLUSIVE CODEPAGE (cCodepage)
*+               USE ("CREDBUU.DBF") VIA "DBFCDX" ALIAS "CREDBUU" EXCLUSIVE
*+
*+    Reformatted by Click! 2.05.32 on Sep-10-2020 at  2:10 am
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
*+    Function OnDataRequestStruct()
*+
*+    Called from ( browser.prg )   1 - static procedure do_modi_stru()
*+                ( modistru.prg )   1 - function showarraystru()
*+
*+--------------------------------------------------------------------
*+
FUNCTION OnDataRequestStruct( aData, cForm, cObj )

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
*+    Called from ( browser.prg )   1 - static procedure do_modi_stru()
*+                ( modistru.prg )   1 - function showarraystru()
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
*+    Called from ( browser.prg )   1 - static procedure dbf_editstrurec()
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
                 ICON "ICODBF" ;
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

         DEFINE TEXTBOX Text_Name
            ROW 10
            COL 70
            WIDTH 120
            HEIGHT 24
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontlarge()
            TOOLTIP ""
            ONCHANGE nil
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

         DEFINE TEXTBOX Text_Type
            ROW 40
            COL 70
            WIDTH 120
            HEIGHT 24
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontlarge()
            TOOLTIP ""
            ONCHANGE nil
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
            MAXLENGTH 1
            BACKCOLOR SP_nColor5()
            FONTCOLOR SP_nColor6()
            INPUTMASK "!"
            FORMAT Nil
            VALUE ""
         END TEXTBOX

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

         DEFINE TEXTBOX Text_Len
            ROW 70
            COL 70
            WIDTH 120
            HEIGHT 24
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontlarge()
            TOOLTIP ""
            ONCHANGE nil                                              // VALID_Text_Len()
            ONGOTFOCUS Nil
            ONLOSTFOCUS Nil
            ONENTER VALID_Text_Len()
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

         DEFINE TEXTBOX Text_Dec
            ROW 100
            COL 70
            WIDTH 120
            HEIGHT 24
            FONTNAME SP_cFontName()
            FONTSIZE SP_nFontlarge()
            TOOLTIP ""
            ONCHANGE nil                                              // VALID_Text_Dec()
            ONGOTFOCUS Nil
            ONLOSTFOCUS Nil
            ONENTER VALID_Text_Dec()
            HELPID Nil
            TABSTOP .T.
            VISIBLE .T.
            READONLY .F.
            RIGHTALIGN .F.
            DISABLEDBACKCOLOR Nil
            DISABLEDFONTCOLOR Nil
            CASECONVERT NONE
            MAXLENGTH 2
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

      EditStruRec.Text_Name.Value := aData[ nRow ] [ DBS_NAME ]
      EditStruRec.Text_Type.Value := aData[ nRow ] [ DBS_TYPE ]
      EditStruRec.Text_Len.Value := aData[ nRow ] [ DBS_LEN ]
      EditStruRec.Text_Dec.Value := aData[ nRow ] [ DBS_DEC ]

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

   //   aData[ nRow ] [ DBS_NAME ] := EditStruRec.Text_Name.Value
   //   aData[ nRow ] [ DBS_TYPE ] := EditStruRec.Text_Type.Value
   aData[ nRow ] [ DBS_LEN ] := EditStruRec.Text_Len.Value
   aData[ nRow ] [ DBS_DEC ] := EditStruRec.Text_Dec.Value

   SP_aADOStruct( ACLONE( aData ) )

   EditStruRec.Release
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure VALID_Text_Len()
*+
*+    Called from ( modistru.prg )   1 - procedure editstrurec()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE VALID_Text_Len()

LOCAL cType := EditStruRec.Text_Type.Value
LOCAL nLen  := EditStruRec.Text_Len.Value
LOCAL lErr  := .F.

   IF EMPTY( nLen )
      MsgInfo( "Len must > 0" )
      EditStruRec.Text_Len.Value := 1
      EditStruRec.Text_Len.SetFocus()
      RETURN
   ENDIF

   DO CASE
      CASE cType = "C"

      CASE cType = "M"
         IF nLen = 4 .OR. nLen = 10
         ELSE
            lErr := .T.
            EditStruRec.Text_Len.Value := 10
            EditStruRec.Text_Dec.Value := 0
         ENDIF

      CASE cType = "N"
         IF nLen > 19
            lErr := .T.
            EditStruRec.Text_Len.Value := 19
            EditStruRec.Text_Dec.Value := 0
         ENDIF

      CASE cType = "D"
         IF nLen = 8 .OR. nLen = 10
         ELSE
            lErr := .T.
            EditStruRec.Text_Len.Value := 8
            EditStruRec.Text_Dec.Value := 0
         ENDIF

      CASE cType = "L"
         IF nLen <> 1
            lErr := .T.
            EditStruRec.Text_Len.Value := 1
            EditStruRec.Text_Dec.Value := 0
         ENDIF
   ENDCASE

   IF lErr = .T.
      EditStruRec.Text_Len.SetFocus()
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure VALID_Text_Dec()
*+
*+    Called from ( modistru.prg )   1 - procedure editstrurec()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE VALID_Text_Dec()

LOCAL cType := EditStruRec.Text_Type.Value
LOCAL nDec  := EditStruRec.Text_Dec.Value

   IF !EMPTY( nDec )
      IF cType $ "N"
      ELSE
         MsgInfo( "only Type 'N' allowed" )
         EditStruRec.Text_Dec.Value := 0
         EditStruRec.Text_Type.SetFocus()
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
            IF MsgYesNo( "Overwrite: " + cExportTo + CRLF, "Export DBF" )
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
            IF MsgYesNo( "Overwrite: " + cExportTo + CRLF, "Export XLSx" )
               FERASE( cExportTo )
            ELSE
               Export_Button( .T. )
               RETURN
            ENDIF
         ENDIF

      CASE nItem = 3
         cExportTo := cText_Path + cText_Name + ".SDF"
         IF FILE( cExportTo )
            IF MsgYesNo( "Overwrite: " + cExportTo + CRLF, "Export SDF" )
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

*+--------------------------------------------------------------------
*+
*+    Procedure CreateNewDbf()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+                                   1 - static procedure dogridkey1()
*+                                   1 - static procedure dogridkey2()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE CreateNewDbf()

LOCAL aStruc, cWorkArea

   IF !FILE( "CREDBUU.DBF" )
      CRE_DBUU( "CREDBUU.DBF" )
   ENDIF

   USE ("CREDBUU.DBF") VIA "DBFCDX" ALIAS "CREDBUU" EXCLUSIVE

   cWorkArea := ALIAS()

   DEFINE WINDOW CreateNewDbf ;
              AT 292, 521 ;
              WIDTH 506 ;
              HEIGHT 548 ;
              TITLE "create DBF" ;
              ICON "ICODBF" ;
              TOPMOST ;
              ON INIT Scatter() ;
              ON RELEASE CloseForm() ;
              NOSIZE ;
              NOMAXIMIZE ;
              NOMINIMIZE ;
              ON PAINT Nil ;
              BACKCOLOR SP_nColor1()

      DEFINE MAIN MENU
         DEFINE POPUP "&Load"
            MENUITEM "load Structure from DBF" IMAGE 'MYDBF16' ACTION LoadNewStruct()
         END POPUP
      END MENU

      DEFINE STATUSBAR FONT "Arial" SIZE 9
STATUSITEM "" WIDTH 500
      END STATUSBAR

      DEFINE BROWSE Browse_Struct
         ROW 10
         COL 10
         WIDTH 300
         HEIGHT 430
         VALUE 1
         WIDTHS { 100, 60, 60, 60 }
         HEADERS { 'Name', 'Type', 'Len', 'Dec' }
         WORKAREA &cWorkArea
         FIELDS { 'NAME', 'TYPE', 'LEN', 'DEC' }
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         TOOLTIP ""
         ONCHANGE Scatter()
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         ONDBLCLICK Nil
         ALLOWEDIT .F.
         ALLOWAPPEND .T.
         ONHEADCLICK Nil
         ALLOWDELETE .F.
         HELPID Nil
         VALID Nil
         VALIDMESSAGES Nil
         LOCK .F.
         VSCROLLBAR .T.
         DYNAMICBACKCOLOR Nil
         DYNAMICFORECOLOR Nil
         INPUTMASK Nil
         FORMAT Nil
         WHEN Nil
         INPUTITEMS Nil
         DISPLAYITEMS Nil
         BACKCOLOR Nil
         FONTCOLOR Nil
         IMAGE Nil
         JUSTIFY Nil
         NOLINES .F.
         READONLYFIELDS Nil
         HEADERIMAGES Nil
      END BROWSE

      DEFINE LABEL Label_1
         ROW 10
         COL 320
         WIDTH 50
         HEIGHT 24
         VALUE "Name"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         TOOLTIP ""
         HELPID Nil
         VISIBLE .T.
         TRANSPARENT .F.
         ACTION Nil
         AUTOSIZE .F.
         BACKCOLOR SP_nColor1()
         FONTCOLOR SP_nColor2()
      END LABEL

      DEFINE TEXTBOX Text_Name
         ROW 10
         COL 380
         WIDTH 100
         HEIGHT 24
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         TOOLTIP ""
         ONCHANGE nil
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
         MAXLENGTH 10
         BACKCOLOR SP_nColor5()
         FONTCOLOR SP_nColor6()
         INPUTMASK "!!!!!!!!!!"
         FORMAT nil
         VALUE ""
      END TEXTBOX

      DEFINE LABEL Label_2
         ROW 40
         COL 320
         WIDTH 50
         HEIGHT 24
         VALUE "Type"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         TOOLTIP ""
         HELPID Nil
         VISIBLE .T.
         TRANSPARENT .F.
         ACTION Nil
         AUTOSIZE .F.
         BACKCOLOR SP_nColor1()
         FONTCOLOR SP_nColor2()
      END LABEL

      DEFINE TEXTBOX Text_Type
         ROW 40
         COL 380
         WIDTH 100
         HEIGHT 24
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         TOOLTIP ""
         ONCHANGE nil
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
         MAXLENGTH 1
         BACKCOLOR SP_nColor5()
         FONTCOLOR SP_nColor6()
         INPUTMASK "!"
         FORMAT nil
         VALUE ""
      END TEXTBOX

      DEFINE LABEL Label_3
         ROW 70
         COL 320
         WIDTH 50
         HEIGHT 24
         VALUE "Len"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         TOOLTIP ""
         HELPID Nil
         VISIBLE .T.
         TRANSPARENT .F.
         ACTION Nil
         AUTOSIZE .F.
         BACKCOLOR SP_nColor1()
         FONTCOLOR SP_nColor2()
      END LABEL

      DEFINE TEXTBOX Text_Len
         ROW 70
         COL 380
         WIDTH 100
         HEIGHT 24
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         TOOLTIP ""
         ONCHANGE nil
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
         MAXLENGTH 3
         BACKCOLOR SP_nColor5()
         FONTCOLOR SP_nColor6()
         INPUTMASK "999"
         FORMAT nil
         NUMERIC .T.
         VALUE Nil
      END TEXTBOX

      DEFINE LABEL Label_4
         ROW 100
         COL 320
         WIDTH 50
         HEIGHT 24
         VALUE "Dec"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         TOOLTIP ""
         HELPID Nil
         VISIBLE .T.
         TRANSPARENT .F.
         ACTION Nil
         AUTOSIZE .F.
         BACKCOLOR SP_nColor1()
         FONTCOLOR SP_nColor2()
      END LABEL

      DEFINE TEXTBOX Text_Dec
         ROW 100
         COL 380
         WIDTH 100
         HEIGHT 24
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         TOOLTIP ""
         ONCHANGE nil
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
         MAXLENGTH 2
         BACKCOLOR SP_nColor5()
         FONTCOLOR SP_nColor6()
         INPUTMASK "99"
         FORMAT nil
         NUMERIC .T.
         VALUE Nil
      END TEXTBOX

      DEFINE BUTTON Button_Edit
         ROW 150
         COL 320
         WIDTH 160
         HEIGHT 70
         ACTION DoEditSave()
         CAPTION "&Save Edit"
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

      DEFINE BUTTON Button_Append
         ROW 225
         COL 320
         WIDTH 160
         HEIGHT 70
         ACTION DoAppendBlank()
         CAPTION "&Append"
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

      DEFINE BUTTON Button_Delete
         ROW 300
         COL 320
         WIDTH 160
         HEIGHT 70
         ACTION DoZAPnow()
         CAPTION "&Zap DBF"
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

      DEFINE TEXTBOX Text_DBF
         ROW 450
         COL 10
         WIDTH 300
         HEIGHT 24
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
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

      DEFINE BUTTON Button_CreDBF
         ROW 404
         COL 320
         WIDTH 160
         HEIGHT 70
         ACTION DoCreDBFNow()
         CAPTION "&create DBF"
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

   ON KEY ESCAPE OF CreateNewDbf ACTION CreateNewDbf.Release
   ON KEY INSERT OF CreateNewDbf ACTION DoAppendBlank()
   ON KEY DELETE OF CreateNewDbf ACTION DoDelRecall()

   CENTER WINDOW CreateNewDbf
   ACTIVATE WINDOW CreateNewDbf

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure CloseForm()
*+
*+    Called from ( modistru.prg )   1 - procedure createnewdbf()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE CloseForm()

   IF USED()
      CLOSE
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure LoadNewStruct()
*+
*+    Called from ( modistru.prg )   1 - procedure createnewdbf()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE LoadNewStruct()

LOCAL ii, iMax, aStruct := {}
LOCAL nOldSel, bError, oError
LOCAL cTitle  := "load DBF Structure"
LOCAL cFile   := GetFile( { { "DBF File", "*.DBF" } }, cTitle )

   //   msginfo("under construction ... ")

   IF !EMPTY( cFile )
      nOldSel := SELECT ()
      bError := ERRORBLOCK( { | oErr | BREAK( oErr ) } )
      BEGIN SEQUENCE
         USE_MYDBF( cFile )
         aStruct := DBSTRUCT()
         CLOSE
      RECOVER USING oError
         ERRORBLOCK( bError )
         MsgInfo( "Error open " + cFile + CRLF + ;
                  oError:description + CRLF + oError:operation, "Error " + HB_VALTOSTR( oError:osCode ) )
      END SEQUENCE
      ERRORBLOCK( bError )
      SELECT ( nOldSel )

      IF !EMPTY( aStruct )
         ZAP
         iMax := LEN( aStruct )
         FOR ii := 1 TO iMax
            APPEND BLANK
            REPLACE CREDBUU->NAME WITH aStruct[ ii ] [ DBS_NAME ]
            REPLACE CREDBUU->TYPE WITH aStruct[ ii ] [ DBS_TYPE ]
            REPLACE CREDBUU->LEN WITH aStruct[ ii ] [ DBS_LEN ]
            REPLACE CREDBUU->DEC WITH aStruct[ ii ] [ DBS_DEC ]
         NEXT
         CreateNewDbf.Browse_Struct.Value := 1
         DoMethod( "CreateNewDbf", "Browse_Struct", "Refresh" )
      ENDIF
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure CRE_DBUU()
*+
*+    Called from ( modistru.prg )   1 - procedure createnewdbf()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE CRE_DBUU( datei )

LOCAL field_list := {}

   IF !FILE( datei )
      AADD( field_list, { "NAME", "C", 10, 0 } )
      AADD( field_list, { "TYPE", "C", 1, 0 } )
      AADD( field_list, { "LEN", "N", 3, 0 } )
      AADD( field_list, { "DEC", "N", 2, 0 } )
      DBCREATE( datei, field_list, "DBFCDX" )
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure Scatter()
*+
*+    Called from ( modistru.prg )   2 - procedure createnewdbf()
*+                                   1 - static procedure doappendblank()
*+                                   1 - static procedure dozapnow()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Scatter()

   CreateNewDbf.Text_Name.Value := CREDBUU->NAME
   CreateNewDbf.Text_Type.Value := CREDBUU->TYPE
   CreateNewDbf.Text_Len.Value := CREDBUU->LEN
   CreateNewDbf.Text_Dec.Value := CREDBUU->DEC

   RefreshBrowseLine()

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoAppendBlank()
*+
*+    Called from ( modistru.prg )   2 - procedure createnewdbf()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoAppendBlank()

   APPEND BLANK
   GOTO LASTREC()
   CreateNewDbf.Browse_Struct.Value := RECNO()

   Scatter()

   CreateNewDbf.Text_Name.setfocus()
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoEditSave()
*+
*+    Called from ( modistru.prg )   1 - procedure createnewdbf()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoEditSave()

LOCAL lErr := .F.

   IF .NOT. Check_Name()
      RETURN
   ENDIF
   IF .NOT. Check_Type()
      RETURN
   ENDIF
   IF .NOT. Check_Len()
      RETURN
   ENDIF
   IF .NOT. Check_Dec()
      RETURN
   ENDIF

   REPLACE CREDBUU->NAME WITH TRIM( CreateNewDbf.Text_Name.Value )
   REPLACE CREDBUU->TYPE WITH CreateNewDbf.Text_Type.Value
   REPLACE CREDBUU->LEN WITH CreateNewDbf.Text_Len.Value
   REPLACE CREDBUU->DEC WITH CreateNewDbf.Text_Dec.Value

   RefreshBrowseLine()
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoDelRecall()
*+
*+    Called from ( modistru.prg )   1 - procedure createnewdbf()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoDelRecall()

   IF DELETED()
      RECALL
   ELSE
      DELETE
   ENDIF
   RefreshBrowseLine()
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoCreDBFNow()
*+
*+    Called from ( modistru.prg )   1 - procedure createnewdbf()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoCreDBFNow()

LOCAL bError, oError
LOCAL field_list := {}
LOCAL cDBF       := CreateNewDbf.Text_DBF.Value

   IF EMPTY( cDBF )
      msginfo( "need Name for DBF", "DBF Name missing" )
      CreateNewDbf.Text_DBF.setfocus()
      RETURN
   ELSE
      IF FILE( cDBF )
         IF MsgYesNo( "override " + cDBF + CRLF, "create new DBF" )
            FERASE( cDBF )

            GO TOP
            DO WHILE !EOF()
               IF .NOT. DELETED()
                  AADD( field_list, { CREDBUU->NAME, CREDBUU->TYPE, CREDBUU->LEN, CREDBUU->DEC } )
               ENDIF
               SKIP
            ENDDO

            bError := ERRORBLOCK( { | oErr | BREAK( oErr ) } )
            BEGIN SEQUENCE
               DBCREATE( cDBF, field_list, "DBFCDX" )
               msginfo( "DBF " + cDBF + " create" )
            RECOVER USING oError
               ERRORBLOCK( bError )
               MsgInfo( "create DBF " + cDBF + " fail" + CRLF + ;
                        oError:description + CRLF + oError:operation, "Error " + HB_VALTOSTR( oError:osCode ) )
               CreateNewDbf.Text_DBF.setfocus()
            END SEQUENCE
            ERRORBLOCK( bError )

         ENDIF
      ENDIF

   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoZAPnow()
*+
*+    Called from ( modistru.prg )   1 - procedure createnewdbf()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoZAPnow()

   IF MsgYesNo( "ZAP DBF Strukture ?", "DBF Structure" )
      ZAP
      APPEND BLANK
      CreateNewDbf.Browse_Struct.Value := RECNO()

      // Browse refreshAll()
      DoMethod( "CreateNewDbf", "Browse_Struct", "Refresh" )
      // fill Controls
      Scatter()
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure RefreshBrowseLine()
*+
*+    Called from ( modistru.prg )   1 - static procedure scatter()
*+                                   1 - static procedure doeditsave()
*+                                   1 - static procedure dodelrecall()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE RefreshBrowseLine()

LOCAL i, iMax, cText
LOCAL cField, xValue
LOCAL h, nIdx, nRow
LOCAL aStruc := DBSTRUCT()

   nIdx := GetControlIndex( "Browse_Struct", "CreateNewDbf" )
   h := GetControlHandle( "Browse_Struct", "CreateNewDbf" )
   nRow := LISTVIEW_GETFIRSTITEM( h )                                 // this function returns current screen row number
   //   aStruc := _HMG_SYSDATA [ 31 ] [nIdx]   // array conainig FIELDS parameter
   //   aStruc := _HMG_aControlRangeMin [ 31 ] [nIdx] // extended Version

   iMax := LEN( aStruc )
   FOR i := 1 TO iMax
      cField := aStruc[ i ] [ DBS_NAME ]
      //  cField := aStruc[ i ]
      xValue := &( cField )
      IF VALTYPE( xValue ) == "N"
         xValue := hb_ntos( xValue )
      ENDIF
      SetProperty( "CreateNewDbf", "Browse_Struct", "CELL", nRow, i, xValue )
   NEXT i

   IF DELETED()
      cText := "Deleted Record " + hb_NTOS( RECNO() ) + "/" + hb_NTOS( RECCOUNT() )
   ELSE
      cText := "Record " + hb_NTOS( RECNO() ) + "/" + hb_NTOS( RECCOUNT() )
   ENDIF
   SetProperty( "CreateNewDbf", "StatusBar", "Item", 1, cText )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function Check_Name()
*+
*+    Called from ( modistru.prg )   1 - static procedure doeditsave()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION Check_Name()

LOCAL lRet  := .T.
LOCAL cName := TRIM( CreateNewDbf.Text_Name.Value )

   IF .NOT. CHECK_A2Z( cName )
      lRet := .F.
      CreateNewDbf.Text_Name.setfocus()
   ENDIF

RETURN lRet

*+--------------------------------------------------------------------
*+
*+    Static Function CHECK_A2Z()
*+
*+    Called from ( modistru.prg )   1 - static function check_name()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION CHECK_A2Z( cName )

LOCAL cSign, ii, iMax := LEN( cName )
LOCAL lRet  := .T.

   IF SUBSTR( cName, 1, 1 ) $ "1234567890"
      msginfo( "Problem 1st sign is a Number", "Problem Alias Name" )
      lRet := .F.
      RETURN lRet
   ENDIF

   FOR ii := 1 TO iMax
      cSign := SUBSTR( cName, ii, 1 )
      IF cSign $ "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
      ELSE
         msginfo( "ony A-Z and 0-9 allowed", "Problem FIELD Name" )
         lRet := .F.
         EXIT
      ENDIF
   NEXT

RETURN lRet

*+--------------------------------------------------------------------
*+
*+    Static Function Check_Type()
*+
*+    Called from ( modistru.prg )   1 - static procedure doeditsave()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION Check_Type()

LOCAL lRet  := .T.
LOCAL cType := CreateNewDbf.Text_Type.Value

   IF cType $ "CMNDL"
   ELSE
      lRet := .F.
      msginfo( "Problem FIELD Type. only 'CMNDL'" )
      CreateNewDbf.Text_Type.Setfocus()
   ENDIF
RETURN lRet

*+--------------------------------------------------------------------
*+
*+    Static Function Check_Len()
*+
*+    Called from ( modistru.prg )   1 - static procedure doeditsave()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION Check_Len()

LOCAL lRet  := .T.
LOCAL cType := CreateNewDbf.Text_Type.Value
LOCAL nLen  := CreateNewDbf.Text_Len.Value
LOCAL lErr  := .F.
LOCAL cText := ""

   DO CASE
      CASE cType = "L"
         IF nLen <> 1
            lErr := .T.
            cText := "logic can onyl LEN = 1"
            CreateNewDbf.Text_Len.Value := 1
            CreateNewDbf.Text_Dec.Value := 0
         ENDIF
      CASE cType = "D"
         IF nLen = 8 .OR. nLen = 10
         ELSE
            lErr := .T.
            cText := "Date can onyl LEN = 8 or 10"
            CreateNewDbf.Text_Len.Value := 8
            CreateNewDbf.Text_Dec.Value := 0
         ENDIF

      CASE cType = "N"
         IF nLen > 19
            lErr := .T.
            cText := "numeric can max LEN = 19"
            CreateNewDbf.Text_Len.Value := 19
            CreateNewDbf.Text_Dec.Value := 0
         ENDIF

      CASE cType = "M"
         IF nLen = 4 .OR. nLen = 10
         ELSE
            lErr := .T.
            cText := "Memo can onyl LEN = 4 or 10"
            CreateNewDbf.Text_Len.Value := 10
            CreateNewDbf.Text_Dec.Value := 0
         ENDIF
      OTHERWISE

   ENDCASE

   IF lErr = .T.
      lRet := .F.
      msginfo( cText )
      CreateNewDbf.Text_Len.Setfocus()
   ENDIF
RETURN lRet

*+--------------------------------------------------------------------
*+
*+    Static Function Check_Dec()
*+
*+    Called from ( modistru.prg )   1 - static procedure doeditsave()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION Check_Dec()

LOCAL lRet  := .T.
LOCAL cType := CreateNewDbf.Text_Type.Value
LOCAL nDec  := CreateNewDbf.Text_Dec.Value
LOCAL lErr  := .F.
LOCAL cText := ""

   IF cType = "N"
   ELSE
      IF nDec <> 0
         lErr := .T.
         cText := "only numeric can have DEC > 0"
         CreateNewDbf.Text_Dec.Value := 0
      ENDIF
   ENDIF

   IF lErr = .T.
      lRet := .F.
      msginfo( cText )
      CreateNewDbf.Text_Dec.Setfocus()
   ENDIF

RETURN lRet

//
//

*+ EOF: MODISTRU.PRG
