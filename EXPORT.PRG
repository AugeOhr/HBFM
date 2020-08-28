*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\EXPORT.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Procedure ExportDbf()
*+               Static Procedure Pre_Export()
*+               Static Procedure OnChange_Export()
*+               Static Function OnInitPath()
*+               Static Procedure OnGetFolder()
*+               Static Procedure OnGo_Export()
*+               Static Procedure Export_Button()
*+               Static Function Num2Cell()
*+               Static Function MyWriteSDF()
*+               Static Function MyWriteHBXLS()
*+
*+    Reformatted by Click! 2.05.30 on Aug-28-2020 at  1:51 am
*+
*+--------------------------------------------------------------------

#include "HMG.CH"
#INCLUDE "hbclass.ch"
#INCLUDE "Dbstruct.ch"
#include "Fileio.ch"
#include "common.ch"
#INCLUDE "DbInfo.ch"
#include "hblibxlsxwriter.ch"

#define NULL   0

REQUEST HB_CODEPAGE_UTF8EX

// STATIC cExportTo := "DBF"

MEMVAR nGridFocus, aWin
MEMVAR _HMG_SYSDATA

*+--------------------------------------------------------------------
*+
*+    Procedure ExportDbf()
*+
*+    Called from ( browser.prg )   1 - static procedure copyresult()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE ExportDbf( cAlias )

   // LOCAL cAlias := ALIAS()

   DEFINE WINDOW ExportDbf ;
              AT 0, 0 ;
              WIDTH 400 ;
              HEIGHT 210 ;
              TITLE "Export " + cAlias ;
              ICON NIL ;
              TOPMOST ;
              NOMAXIMIZE ;
              NOMINIMIZE ;
              ON INIT Pre_Export() ;
              ON RELEASE Nil ;
              NOSIZE ;
              ON PAINT Nil ;
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
         VALUE cAlias
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

      DEFINE BUTTON Button_Cancel
         ROW 130
         COL 10
         WIDTH 100
         HEIGHT 28
         ACTION ExportDbf.Release
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
         ACTION OnGetFolder()
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
         ACTION OnGo_Export()
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

   CENTER WINDOW ExportDbf
   //  ExportDbf.TXTCtrl.setfocus()
   ON KEY ESCAPE OF ExportDbf ACTION ExportDbf.Release
   ACTIVATE WINDOW ExportDbf
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure Pre_Export()
*+
*+    Called from ( export.prg )   1 - procedure exportdbf()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Pre_Export()

   ExportDbf.Label_SDF.hide
   ExportDbf.Text_SDF.hide
   ExportDbf.Text_SDF.value := ";"

   ExportDbf.Text_Path.value := OnInitPath()

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure OnChange_Export()
*+
*+    Called from ( export.prg )   1 - procedure exportdbf()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE OnChange_Export()

LOCAL nItem := ExportDbf.RadioGroup_1.value

   IF nItem > 2
      ExportDbf.Label_SDF.show
      ExportDbf.Text_SDF.show
   ELSE
      ExportDbf.Label_SDF.hide
      ExportDbf.Text_SDF.hide
   ENDIF

   ExportDbf.Label_EXT.Value := ExportDbf.RadioGroup_1.Caption( nItem )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function OnInitPath()
*+
*+    Called from ( export.prg )   1 - static procedure pre_export()
*+                                   1 - static procedure ongetfolder()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION OnInitPath()

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
*+    Static Procedure OnGetFolder()
*+
*+    Called from ( export.prg )   1 - procedure exportdbf()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE OnGetFolder()

LOCAL cTitle           := "search Folder"
LOCAL lNewFolderButton := .T.
LOCAL cDir, cInitPath := ""

   cInitPath := OnInitPath()
   cDir := GetFolder( cTitle, TRIM( cInitPath ),, lNewFolderButton )

   IF !EMPTY( cDir )
      ExportDbf.Text_Path.value := cDir + "\"
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure OnGo_Export()
*+
*+    Called from ( export.prg )   1 - procedure exportdbf()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE OnGo_Export()

LOCAL nItem      := ExportDbf.RadioGroup_1.value
LOCAL cText_Path := ExportDbf.Text_Path.value
LOCAL cText_Name := ExportDbf.Text_Name.value
LOCAL cText_SDF  := ExportDbf.Text_SDF .value
LOCAL cExportTo  := ""

   Export_Button( .F. )

   DO CASE
      CASE nItem = 1
         cExportTo := cText_Path + cText_Name + ".DBF"
         IF FILE( cExportTo )
            MsgInfo( "can't copy to same DBF Name" )
            Export_Button( .T. )
            RETURN
         ENDIF

         COPY TO &(cExportTo)
         Export_Button( .T. )
         ExportDbf.Release

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

         IF FILE( "libxlsxwriter.dll" )
            IF MyWriteHBXLS( cExportTo )
               Export_Button( .T. )
               ExportDbf.Release
            ENDIF
         ELSE
            IF ADOxlsxWrite( cText_Path, cText_Name, ".XLSX" )
               Export_Button( .T. )
               ExportDbf.Release
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

         IF MyWriteSDF( cExportTo )
            Export_Button( .T. )
            ExportDbf.Release
         ENDIF
   ENDCASE

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure Export_Button()
*+
*+    Called from ( export.prg )   8 - static procedure ongo_export()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Export_Button( lOnOff )

   DEFAULT lOnOff TO .T.

   ExportDbf.Button_Cancel.Enabled := lOnOff
   ExportDbf.Button_Folder.Enabled := lOnOff
   ExportDbf.Button_Go.Enabled := lOnOff

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function Num2Cell()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION Num2Cell( numColumns )

LOCAL nMal
LOCAL cEnde

   IF numColumns > 26
      nMal := INT( numColumns / 26 )
      cEnde := CHR( nMal + 64 ) + CHR( ( numColumns - ( nMal * 26 ) ) + 64 )
   ELSE
      cEnde := CHR( numColumns + 64 )
   ENDIF

RETURN cEnde

*+--------------------------------------------------------------------
*+
*+    Static Function MyWriteSDF()
*+
*+    Called from ( export.prg )   1 - static procedure ongo_export()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION MyWriteSDF( cExportTo )

LOCAL aStructure, ii, iMax, nRowLine, xValue, nMax, nEvery, nProz
LOCAL nHandle, nStart, nStop
LOCAL cField, nPosi, cType
LOCAL cText_SDF  := ExportDbf.Text_SDF.value

   ExportDbf.ProgressBar_1.Value := 0

   IF USED()
      aStructure := SP_aDbfStruct()
      IF EMPTY( aStructure )
         MsgInfo( "Error empty Structure,no FIELDs" )
         RETURN .F.
      ENDIF
      iMax := LEN( aStructure )
      nMax := 0
      // GO TOP
      // DO WHILE !EOF()
      //    nMax ++
      //    SKIP
      // ENDDO
      nMax := DBORDERINFO( DBOI_KEYCOUNT )                            // harbour
      nEvery := ROUND( nMax / 100, 0 )
   ELSE
      msgInfo( "need DBF" )
      RETURN .F.
   ENDIF

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
      GO TOP
      DO WHILE !EOF()
         ii := 1
         FOR ii := 1 TO iMax
            cField := aStructure[ ii ] [ DBS_NAME ]
            cType := aStructure[ ii ] [ DBS_TYPE ]
            nPosi := FIELDPOS( cField )
            xValue := VAR2CHAR( FIELDGET( nPosi ) )
            FWRITE( nHandle, xValue )
            IF ii < iMax
               FWRITE( nHandle, cText_SDF )
            ENDIF
         NEXT
         FWRITE( nHandle, CRLF )

         nRowLine ++
         IF ( nRowLine % nEvery ) = 0
            nProz := CalcPos( nRowLine, nMax )
            IF nProz > 100
               nProz := 100
            ENDIF
            SetProperty( "ExportDbf", "ProgressBar_1", "Value", nProz )
            DO EVENTS
         ENDIF

         SKIP
      ENDDO
      FCLOSE( nHandle )

      nStop := SECONDS() - nStart

      //       Msginfo( "finish after " + LTRIM( STR( nStop ) ) )

   ENDIF

   DO EVENTS

RETURN .T.

*+--------------------------------------------------------------------
*+
*+    Static Function MyWriteHBXLS()
*+
*+    Called from ( export.prg )   1 - static procedure ongo_export()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION MyWriteHBXLS( cExportTo )

LOCAL aStructure, ii, iMax, nRowLine, xValue, cOldLang, nMax, nEvery, nProz
LOCAL cField, nPosi, cType, nStart, nStop
LOCAL cText_SDF  := ExportDbf.Text_SDF.value

LOCAL workbook, worksheet, format

   ExportDbf.ProgressBar_1.Value := 0

   IF USED()
      aStructure := SP_aDbfStruct()
      IF EMPTY( aStructure )
         MsgInfo( "Error empty Structure,no FIELDs" )
         RETURN .F.
      ENDIF
      iMax := LEN( aStructure )
      nMax := 0
      // GO TOP
      // DO WHILE !EOF()
      //    nMax ++
      //    SKIP
      // ENDDO
      nMax := DBORDERINFO( DBOI_KEYCOUNT )                            // harbour
      nEvery := ROUND( nMax / 100, 0 )
   ELSE
      msgInfo( "need DBF" )
      RETURN .F.
   ENDIF

   cOldLang := hb_cdpSelect( 'UTF8EX' )
   SET DATE FORMAT "dd.mm.yyyy"

   lxw_init()

   /* Create a new workbook and add a worksheet. */
   //  workbook  := lxw_workbook_new("demo1.xlsx")
   workbook := lxw_workbook_new( cExportTo )
   worksheet := lxw_workbook_add_worksheet( workbook, NIL )

   /* Add a format with date formatting. */
   format := lxw_workbook_add_format( workbook )
   //    lxw_format_set_num_format(format, "mmm d yyyy hh:mm AM/PM")
   lxw_format_set_num_format( format, "dd.mm.yyyy hh:mm" )

   ii := 1
   FOR ii := 1 TO iMax
      cField := aStructure[ ii ] [ DBS_NAME ]
      lxw_worksheet_write_string( worksheet, 0, ii - 1, cField, NULL )
   NEXT

   nStart := SECONDS()

   nRowLine := 1
   GO TOP
   DO WHILE !EOF()
      ii := 1
      FOR ii := 1 TO iMax
         cField := aStructure[ ii ] [ DBS_NAME ]
         cType := aStructure[ ii ] [ DBS_TYPE ]
         nPosi := FIELDPOS( cField )
         // xValue := VAR2CHAR( FIELDGET( nPosi ) )
         xValue := FIELDGET( nPosi )

         DO CASE
            CASE cType = "C"
               lxw_worksheet_write_string( worksheet, nRowLine, ii - 1, xValue, NULL )
            CASE cType = "M"
               lxw_worksheet_write_string( worksheet, nRowLine, ii - 1, xValue, NULL )
            CASE cType = "N"
               lxw_worksheet_write_number( worksheet, nRowLine, ii - 1, xValue, NULL )
            CASE cType = "L"
               lxw_worksheet_write_boolean( worksheet, nRowLine, ii - 1, xValue, NULL )
            CASE cType = "D"
               /* Write the datetime with formatting. */
               /* datetime := HB_STOT("201302281200")  */
               xValue := HB_STOT( DTOS( xValue ) + "0000" )
               lxw_worksheet_write_datetime( worksheet, nRowLine, ii - 1, xValue, format )                                                  // Feb 28 2013 12:00 PM
         ENDCASE
      NEXT
      nRowLine ++

      IF ( nRowLine % nEvery ) = 0
         nProz := CalcPos( nRowLine, nMax )
         IF nProz > 100
            nProz := 100
         ENDIF
         SetProperty( "ExportDbf", "ProgressBar_1", "Value", nProz )
         DO EVENTS
      ENDIF

      SKIP
   ENDDO

   nStop := SECONDS() - nStart

   lxw_workbook_close( workbook )

   hb_cdpSelect( cOldLang )

   DO EVENTS

   //    Msginfo( "finish after " + LTRIM( STR( nStop ) ) )

RETURN .T.

//
//
//

*+ EOF: EXPORT.PRG
