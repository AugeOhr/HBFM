*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\ADO.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Procedure ADO_VIEW()
*+               Static Function GetXLSgrid()
*+               Static Function Strvalue()
*+               Static Function OnDataRequestADO()
*+               Static Procedure DoResize()
*+               Function ADOxlsxWrite()
*+               Static Function serial2dt()
*+               Static Function dt2serial()
*+
*+    Reformatted by Click! 2.05.30 on Aug-28-2020 at  1:51 am
*+
*+--------------------------------------------------------------------

#include "hmg.ch"
#INCLUDE "Dbstruct.ch"
#INCLUDE "ADORDD.ch"
#INCLUDE "Error.ch"
#INCLUDE "DbInfo.ch"

#define ID_NAME            1
#define ID_TYPE            2
#define ID_LEN             3

#DEFINE pNULL              ""
#DEFINE pCHARACTER         "C"
#DEFINE pNUMERIC           "N"
#DEFINE pMEMO              "M"
#DEFINE pDATE              "D"
#DEFINE pLOGICAL           "L"

// Cursor Type
//  #define adOpenForwardOnly     0
//  #define adOpenKeyset          1
//  #define adOpenDynamic         2
//  #define adOpenStatic          3

// Lock Types
//  #define adLockReadOnly        1
//  #define adLockPessimistic     2
//  #define adLockOptimistic      3
//  #define adLockBatchOptimistic 4

#define adColNullAble            2
#define adFldIsNullable          0x20

MEMVAR Win_1
MEMVAR ExportDbf, ProgressBar_1
MEMVAR _HMG_SYSDATA

STATIC aADOstruc := {}

*+--------------------------------------------------------------------
*+
*+    Procedure ADO_VIEW()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE ADO_VIEW( myXlsFile )

LOCAL cText     := ""
LOCAL nWide, nHeight
LOCAL ii, iMax, cType, cName, nLen
LOCAL aHead     := {}, aWide := {}
LOCAL aGridData := {}
LOCAL aHeadLine := {}
LOCAL aJustify  := {}
LOCAL bError, oError
LOCAL nPBwide
LOCAL nPBheigh  := 40

   aADOstruc := {}

   bError := ERRORBLOCK( { | oErr | BREAK( oErr ) } )
   BEGIN SEQUENCE
      GetXLSgrid( myXlsFile, @aGridData, @aHeadLine )
   RECOVER USING oError
      ERRORBLOCK( bError )
      MsgStop( "Operation: " + oError:Operation + " - Description: " + oError:Description, "Error" )
      SetProperty( "Pbar_Form", "ProgressBar_1", "Value", 0 )
      TBL_SETVALUE( ThisWindow.Handle, 0, 100 )
      Domethod( "Pbar_Form", "ProgressBar_1", "Release" )
      Domethod( "Pbar_Form", "Release" )
      RETURN
   END SEQUENCE
   ERRORBLOCK( bError )

   SetProperty( "Pbar_Form", "ProgressBar_1", "Value", 0 )
   TBL_SETVALUE( ThisWindow.Handle, 0, 100 )
   Domethod( "Pbar_Form", "ProgressBar_1", "Release" )
   Domethod( "Pbar_Form", "Release" )

   IF EMPTY( aGridData )
      RETURN
   ENDIF
   IF EMPTY( aHeadLine )
      RETURN
   ENDIF

   iMax := LEN( aHeadLine )
   FOR ii := 1 TO iMax

      cName := aHeadLine[ ii ] [ ID_NAME ]
      IF EMPTY( cName )
         AADD( aHead, "X" )
      ELSE
         AADD( aHead, cName )
      ENDIF

      nLen := aHeadLine[ ii ] [ ID_LEN ]
      IF EMPTY( nLen )
         AADD( aWide, 1 )
      ELSE
         AADD( aWide, nLen * SP_nFontlarge() )
      ENDIF

      cType := aHeadLine[ ii ] [ ID_TYPE ]
      DO CASE
         CASE cType = "C"
            AADD( aJustify, GRID_JTFY_LEFT )
         CASE cType = "D"
            AADD( aJustify, GRID_JTFY_LEFT )
         CASE cType = "L"
            AADD( aJustify, GRID_JTFY_LEFT )
         CASE cType = "N"
            AADD( aJustify, GRID_JTFY_RIGHT )
      ENDCASE

      AADD( aADOstruc, { cName, cType, nLen, 0 } )
   NEXT

   SP_aADOStruct( ACLONE( aADOstruc ) )

   nWide := 800
   nHeight := 600
   nPBwide := INT( nWide / 11 )

   DEFINE WINDOW XLSSHOWWIN ;
              AT 0, 0 ;
              WIDTH nWide HEIGHT nHeight ;
              TITLE myXlsFile ;
              ICON "ICOEXCEL" ;
              TOPMOST ;
              ON SIZE DoResize( "XLSSHOWWIN", "XLSGrid" ) ;
              ON MAXIMIZE DoResize( "XLSSHOWWIN", "XLSGrid" ) ;
              ON GOTFOCUS WinTans( ThisWindow.Name, .T. ) ;
              ON LOSTFOCUS WinTans( ThisWindow.Name, .F. ) ;
              BACKCOLOR SP_nColor1()

      DEFINE GRID XLSGrid
         PARENT XLSSHOWWIN
         ROW 0
         COL 0
         WIDTH nWide - 30
         HEIGHT nHeight - 50 - 24
         HEADERS aHead
         WIDTHS aWide
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         BACKCOLOR SP_nColor9()
         FONTCOLOR SP_nColor10()
         VIRTUAL .T.
         ITEMCOUNT LEN( aGridData )
         ON QUERYDATA OnDataRequestADO( aGridData, ThisWindow.Name, This.Name )
         JUSTIFY aJustify
      END GRID

      DEFINE BUTTON Button_F1
         PARENT XLSSHOWWIN
         ROW nHeight - 50 - 24
         COL 0
         WIDTH nPBwide - 2
         HEIGHT 40
         ACTION nil
         CAPTION "F1 Info"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .F.
         VISIBLE .T.
      END BUTTON

      DEFINE BUTTON Button_F2
         PARENT XLSSHOWWIN
         ROW nHeight - 50 - 24
         COL nPBwide * 1
         WIDTH nPBwide - 2
         HEIGHT 40
         ACTION ShowArrayStru( aGridData, aHeadLine, myXlsFile )
         CAPTION "F2 Struct"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .F.
         VISIBLE .T.
      END BUTTON

      DEFINE BUTTON Button_F5
         PARENT XLSSHOWWIN
         ROW nHeight - 50 - 24
         COL nPBwide * 4
         WIDTH nPBwide - 2
         HEIGHT nPBheigh
         ACTION XLSexport( aGridData, myXlsFile )
         CAPTION "F5 Copy"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .F.
      END BUTTON

   END WINDOW
   SetProperty( "XLSSHOWWIN", "XLSGrid", "PaintDoubleBuffer", .T. )

   SP_lPbarRunning( .F. )

   ON KEY F2 OF XLSSHOWWIN ACTION ShowArrayStru( aGridData, aHeadLine, myXlsFile )
   ON KEY F5 OF XLSSHOWWIN ACTION XLSexport( aGridData, myXlsFile )

   ON KEY ESCAPE OF XLSSHOWWIN ACTION XLSSHOWWIN.Release
   CENTER WINDOW XLSSHOWWIN
   ACTIVATE WINDOW XLSSHOWWIN

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function GetXLSgrid()
*+
*+    Called from ( ado.prg )   1 - procedure ado_view()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GetXLSgrid( myXlsFile, aGridData, aHeadLine )

LOCAL bError, oError
LOCAL oConnect, objRS, nStart, nStop
LOCAL arrLine, ii, jj, xValue, cField, nEvery
LOCAL nMaxLen   := 0
LOCAL nCount    := 0
LOCAL strHeader, strRange, xOUT, cType, nLen := 10
LOCAL mySheet   := "Sheet1"
LOCAL bSTP      := .F.
LOCAL oSchema, cSheetName, SCHEMA_TABLES := 20
LOCAL aSheet    := {}

   SetCursorWait( "WinLeft", .T. )
   SetCursorWait( "WinRight", .T. )
   DO EVENTS

   SET CENTURY ON
   SET DATE GERMAN

   strHeader := "HDR=YES;"

   oConnect := CreateObject( "ADODB.Connection" )

   oConnect:ConnectionString = 'Provider=Microsoft.ACE.OLEDB.12.0;' + ;
           'Data Source=' + myXlsFile + ';' + ;
           'Extended Properties="Excel 12.0 Xml;' + strHeader + 'IMEX=1' + '";'

   bError := ERRORBLOCK( { | oErr | BREAK( oErr ) } )
   BEGIN SEQUENCE
      oConnect:Open()
   RECOVER USING oError
      ERRORBLOCK( bError )
      MsgStop( "Operation: " + oError:Operation + " - Description: " + oError:Description, "Error" )
      SetCursorWait( "WinLeft", .F. )
      SetCursorWait( "WinRight", .F. )
      RETURN .F.
   END SEQUENCE
   ERRORBLOCK( bError )

   // search for Schema
   oSchema := oConnect:OpenSchema( SCHEMA_TABLES )
   DO WHILE .NOT. oSchema:EOF()
      // get Sheet Name
      cSheetName := oSchema:Fields( "table_name" ) :Value
      AADD( aSheet, cSheetName )
      oSchema:MoveNext()
   ENDDO
   oSchema:Close()

   IF EMPTY( aSheet )
      MsgInfo( "did not found any Sheet Name ?" )
      SetCursorWait( "WinLeft", .F. )
      SetCursorWait( "WinRight", .F. )
      RETURN .F.
   ENDIF
   IF aSheet[ 1 ] = "????1$"
      MsgInfo( "????1$ is not a valid name" )
      SetCursorWait( "WinLeft", .F. )
      SetCursorWait( "WinRight", .F. )
      RETURN .F.
   ENDIF
   // strRange := mySheet + '$'   // ALL
   // strRange := mySheet + "$" + my1stCell + ":" + myLastCell
   strRange := aSheet[ 1 ]                                            // include '$'

   objRS := CreateObject( "ADODB.Recordset" )

   //    bError := ERRORBLOCK( { | oErr | BREAK( oErr ) } )
   //    BEGIN SEQUENCE
   objRS:Open( "Select * from [" + strRange + "]", oConnect, adOpenStatic )
   //    RECOVER USING oError
   //       ERRORBLOCK( bError )
   //       MsgStop( "Operation: " + oError:Operation + " - Description: " + oError:Description, "Error" )
   //       SetCursorWait( "WinLeft", .F. )
   //       SetCursorWait( "WinRight", .F. )
   //       RETURN
   //    END SEQUENCE
   //    ERRORBLOCK( bError )

   // Structure Info
   aHeadLine := {}
   FOR ii := 1 TO objRS:Fields:Count
      AADD( aHeadLine, { "", "", 0 } )
   NEXT

   // ? '#', aHeadLine [I] [1], 'max column length:' , aHeadLine [I] [ID_LEN]

   jj := 0
   FOR jj := 0 TO objRS:Fields:Count - 1
      xValue := objRS:Fields( jj ) :Value()

      cField := objRS:Fields( jj ) :Name
      aHeadLine[ jj + 1 ] [ ID_NAME ] := cField

      cType := VALTYPE( xValue )
      IF cType = "U"
         cType := "C"
      ENDIF
      aHeadLine[ jj + 1 ] [ ID_TYPE ] := cType

      nLen := MAX( LEN( cField ), LEN( STRVALUE( xValue ) ) )
      aHeadLine[ jj + 1 ] [ ID_LEN ] := nLen
   NEXT

   // nMaxLen for Progressbar
   nMaxLen := objRS:RecordCount
   nEvery := ROUND( nMaxLen / 100, 0 )
   aGridData := {}

   nStart := SECONDS()
   //Read the data from the Excel sheet
   objRS:MoveFirst()                                                  // go top
   DO WHILE .NOT. objRS:EOF()

      //Stop reading when an empty row is encountered in the Excel sheet
      IF EMPTY( objRS:Fields( 0 ) :Value ) .AND. bSTP
         EXIT
      ENDIF

      arrLine := {}
      FOR jj := 0 TO objRS:Fields:Count - 1
         xValue := objRS:Fields( jj ) :Value()
         IF EMPTY( xValue )
            DO CASE
               CASE aHeadLine[ jj + 1 ] [ ID_TYPE ] = "C"
                  xOUT := " "
               CASE aHeadLine[ jj + 1 ] [ ID_TYPE ] = "M"
                  xOUT := " "
               CASE aHeadLine[ jj + 1 ] [ ID_TYPE ] = "N"
                  xOUT := 0.00
               CASE aHeadLine[ jj + 1 ] [ ID_TYPE ] = "D"
                  xOUT := CTOD( "  .  .  " )
               CASE aHeadLine[ jj + 1 ] [ ID_TYPE ] = "L"
                  xOUT := .F.
               OTHERWISE
                  xOUT := "Type " + aHeadLine[ jj + 1 ] [ ID_TYPE ]
            ENDCASE
         ELSE
            xOUT := xValue
         ENDIF
         AADD( arrLine, xOUT )
      NEXT
      AADD( aGridData, arrLine )

      nCount ++
      IF ( nCount % nEvery ) = 0
         SetProperty( "Pbar_Form", "ProgressBar_1", "Value", CalcPos( nCount, nMaxLen ) )
         TBL_SETVALUE( ThisWindow.Handle, CalcPos( nCount, nMaxLen ), 100 )
         DO EVENTS
      ENDIF

      //Move to the next row
      objRS:MoveNext()

      //       IF ( nCount % 10 ) = 0
      //          DO EVENTS
      //       ENDIF
   ENDDO
   nStop := SECONDS() - nStart

   //Close the file and release the objects
   objRS:Close()
   oConnect:Close()

   SetCursorWait( "WinLeft", .F. )
   SetCursorWait( "WinRight", .F. )

   DO EVENTS

   //    Msginfo( "finish after " + LTRIM( STR( nStop ) ) )

RETURN .T.

*+--------------------------------------------------------------------
*+
*+    Static Function Strvalue()
*+
*+    Called from ( ado.prg )   1 - static function getxlsgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION Strvalue( string )

LOCAL retval := pNULL

   DO CASE
      CASE VALTYPE( string ) == pCHARACTER
         retval := string

      CASE VALTYPE( string ) == pNUMERIC
         retval := hb_ntos( string )

      CASE VALTYPE( string ) == pMEMO
         retval := IF( ( LEN( string ) > ( MEMORY( 0 ) * 1024 ) * .80 ), ;
                       SUBSTR( string, 1, INT( ( MEMORY( 0 ) * 1024 ) * .80 ) ), ;
                       string )

      CASE VALTYPE( string ) == pDATE
         retval := DTOC( string )

      CASE VALTYPE( STOD( string ) ) == pDATE
         retval := DTOC( STOD( string ) )

      CASE VALTYPE( string ) == pLOGICAL
         retval := IF( string, "J", "N" )

   ENDCASE

RETURN ( retval )

*+--------------------------------------------------------------------
*+
*+    Static Function OnDataRequestADO()
*+
*+    Called from ( ado.prg )   1 - procedure ado_view()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION OnDataRequestADO( aData, cForm, cObj )

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
*+    Static Procedure DoResize()
*+
*+    Called from ( ado.prg )   2 - procedure ado_view()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoResize( cForm, cObj )

LOCAL nPBheigh   := 40
LOCAL nDiff      := 0
LOCAL mainRow    := GetProperty( cForm, 'Row' )
LOCAL mainCol    := GetProperty( cForm, 'Col' )
LOCAL mainWidth  := GetProperty( cForm, 'Width' )
LOCAL mainHeight := GetProperty( cForm, 'Height' )
LOCAL nZoom      := ROUND( mainHeight / 600, 0 )
LOCAL nBorder    := GETBORDERWIDTH()
LOCAL nTitlebar  := GETTITLEHEIGHT()
LOCAL nHwnd      := GetformHandle( cForm )
LOCAL nPBwide

   IF IsMaximized( nHwnd )
      nDiff := 10
   ENDIF

   Domethod( cForm, "hide" )

   SetProperty( cForm, cObj, 'Row', 0 )
   SetProperty( cForm, cObj, 'Col', 10 )
   Setproperty( cForm, cObj, "Width", mainWidth - 30 )
   Setproperty( cForm, cObj, "Height", mainHeight - 50 - 24 - nDiff )

   nPBwide := INT( mainWidth / 11 )

   Setproperty( cForm, "Button_F1", "Width", nPBwide - 2 )
   Setproperty( cForm, "Button_F2", "Width", nPBwide - 2 )
   Setproperty( cForm, "Button_F5", "Width", nPBwide - 2 )

   SetProperty( cForm, "Button_F1", 'Row', mainHeight - 50 - 24 - nDiff )
   Setproperty( cForm, "Button_F2", "Row", mainHeight - 50 - 24 - nDiff )
   Setproperty( cForm, "Button_F5", "Row", mainHeight - 50 - 24 - nDiff )

   SetProperty( cForm, "Button_F1", 'Col', 0 )
   Setproperty( cForm, "Button_F2", "Col", nPBwide * 1 )
   Setproperty( cForm, "Button_F5", "Col", nPBwide * 4 )

   Domethod( cForm, "show" )

RETURN

*+--------------------------------------------------------------------
*+
*+    Function ADOxlsxWrite()
*+
*+    Called from ( export.prg )   1 - static procedure ongo_export()
*+
*+--------------------------------------------------------------------
*+
FUNCTION ADOxlsxWrite( cText_Path, cText_Name, cText_Ext )

LOCAL bError, oError
LOCAL oConnect, oCatalog, oTable, oColumn, objRS
LOCAL aStructure, ii, iMax, xValue, cOldLang
LOCAL nMax, nEvery, nProz
LOCAL cField, nPosi, cType, cLine, nLen, nDec, cSql, cSelect, nStart, nStop
LOCAL myXlsFile
LOCAL mySheet    := "Sheet1"
LOCAL aValue     := {}
LOCAL aField     := {}
LOCAL nRowLine   := 1

   SetCursorWait( "WinLeft", .T. )
   SetCursorWait( "WinRight", .T. )

   myXlsFile := cText_Path + cText_Name + cText_Ext

   IF FILE( myXlsFile )
      FERASE( myXlsFile )
   ENDIF

   IF USED()
      aStructure := SP_aDbfStruct()
      IF EMPTY( aStructure )
         SetCursorWait( "WinLeft", .F. )
         SetCursorWait( "WinRight", .F. )
         MsgInfo( "Error empty Structure,no FIELDs" )
         RETURN .F.
      ENDIF
      iMax := LEN( aStructure )

      SET DELETED ON

      // count for progressbar when have Filter/Scope
      // nMax := 0
      // GO TOP
      // DO WHILE !EOF()
      //    nMax ++
      //    SKIP
      // ENDDO
      nMax := DBORDERINFO( DBOI_KEYCOUNT )                            // harbour
      nEvery := ROUND( nMax / 100, 0 )
      Ondummy( TIME(), nMax, nEvery )
   ELSE
      SetCursorWait( "WinLeft", .F. )
      SetCursorWait( "WinRight", .F. )
      msgInfo( "need DBF" )
      RETURN .F.
   ENDIF

   cOldLang := hb_cdpSelect( 'UTF8EX' )

   SET CENTURY ON
   SET DATE GERMAN
   //  SET DATE FORMAT "dd.mm.yyyy"

   oConnect := CreateObject( "ADODB.Connection" )

   bError := ERRORBLOCK( { | oErr | BREAK( oErr ) } )
   BEGIN SEQUENCE
      oConnect:Execute( "DROP TABLE " + myXlsFile )
   END SEQUENCE
   ERRORBLOCK( bError )

   //  ---------------------- Catalog -------------------------- *

   oCatalog := CreateObject( "ADOX.Catalog" )
   oCatalog:ActiveConnection := 'Provider=Microsoft.ACE.OLEDB.12.0;' + ;
                                'Data Source=' + myXlsFile + ';' + ;
                                'Extended Properties="Excel 12.0 Xml";'

   //  ---------------------- Create Table --------------------- *

   oTable := CreateObject( "ADOX.Table" )
   oTable:Name := "Sheet1"

   ii := 1
   FOR ii := 1 TO iMax
      cField := aStructure[ ii ] [ DBS_NAME ]
      cType := aStructure[ ii ] [ DBS_TYPE ]
      nLen := aStructure[ ii ] [ DBS_LEN ]
      nDec := aStructure[ ii ] [ DBS_DEC ]

      oColumn := CreateObject( "ADOX.Column" )
      oColumn:Name := cField

      DO CASE
         CASE cType = "C"
            oColumn:Type := adVarWChar
            oColumn:DefinedSize := nLen
            oColumn:Attributes := 2                                   // adColNullable
         CASE cType = "M"
            oColumn:Type := adLongVarWChar
            oColumn:Attributes := 2                                   // adColNullable
         CASE cType = "N"
            oColumn:Type := adDouble
            oColumn:DefinedSize := nLen
            oColumn:NumericScale := nDec
         CASE cType = "D"
            oColumn:Type := adDate
         CASE cType = "L"
            oColumn:Type := adBoolean
      ENDCASE

      oTable:Columns:Append( oColumn )
   NEXT

   // add Table to Catalog
   oCatalog:Tables:Append( oTable )

   oConnect:ConnectionString = 'Provider=Microsoft.ACE.OLEDB.12.0;' + ;
           'Data Source=' + myXlsFile + ';' + ;
           'Extended Properties="Excel 12.0 Xml";'

   oConnect:open()

   SetProperty( "ExportDbf", "ProgressBar_1", "Value", 0 )

   DO EVENTS

   //  #define Use_INSERT .T.
#ifdef Use_INSERT
   //  ---------------------- INSERT INTO ---------------------- *

   // prepare String for Fields
   cSelect := "( "
   ii := 1
   FOR ii := 1 TO iMax
      cField := aStructure[ ii ] [ DBS_NAME ]
      cSelect += cField
      IF ii < iMax
         cSelect += ", "
      ENDIF
   NEXT
   cSelect += " ) "

   // now start
   nStart := SECONDS()
   GO TOP
   DO WHILE !EOF()
      ii := 1
      cSql := "INSERT INTO [Sheet1] " + cSelect + "VALUES ( "

      FOR ii := 1 TO iMax
         cField := aStructure[ ii ] [ DBS_NAME ]
         cType := aStructure[ ii ] [ DBS_TYPE ]
         nPosi := FIELDPOS( cField )
         xValue := FIELDGET( nPosi )

         DO CASE
            CASE cType = "C"
               xValue := "'" + STRTRAN( xValue, "'", " " ) + "'"
            CASE cType = "M"
               IF LEN( xValue ) > 64
                  xValue := "'Memo'"
               ELSE
                  xValue := "'" + STRTRAN( xValue, "'", " " ) + "'"
               ENDIF
            CASE cType = "D"

               IF EMPTY( xValue )
                  xValue := "0"
               ELSE
                  //  xValue := DTOC( xValue )
                  //  xValue := DTOS( xValue ) + "000001"
                  //  xValue := HB_STOT( DTOS( xValue ) + "000000" )
                  //  xValue := serial2dt(xValue )

                  xValue := STR( dt2serial( xValue ) )
               ENDIF

            CASE cType = "L"
               xValue := IF( xValue = .T., "TRUE", "FALSE" )
            CASE cType = "N"
               xValue := STR( xValue )
         ENDCASE

         cSql += xValue
         IF ii < iMax
            cSql += ","
         ENDIF
      NEXT
      cSql += ")"
      oConnect:Execute( cSql )
      onDummy( TIME(), cSql )

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

#ELSE
   //  ---------------------- ADO Recordset -------------------- *
   //    ALTD()

   objRS := CreateObject( "ADODB.Recordset" )
   objRS:Open( "Select * from [Sheet1]", oConnect, adOpenKeyset, adLockOptimistic )

   // now start
   nStart := SECONDS()
   GO TOP
   DO WHILE !EOF()
      aField := {}
      aValue := {}
      ii := 1
      FOR ii := 1 TO iMax
         cField := aStructure[ ii ] [ DBS_NAME ]
         cType := aStructure[ ii ] [ DBS_TYPE ]
         nPosi := FIELDPOS( cField )
         xValue := FIELDGET( nPosi )

         IF EMPTY( xValue )
            DO CASE
               CASE cType = "C"
                  xValue := " "
               CASE cType = "M"
                  xValue := " "
               CASE cType = "N"
                  xValue := 0.00
               CASE cType = "D"
                  xValue := CTOD( "  .  .  " )
               CASE cType = "L"
                  xValue := .F.
            ENDCASE
         ENDIF

         AADD( aField, cField )
         AADD( aValue, xValue )
      NEXT
      objRS:AddNew( aField, aValue )
      objRS:Update()                                                  // objRS:UpdateBatch()

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

   objRS:Close()
   objRS := NIL

#ENDIF

   oConnect:Close()
   oConnect := NIL

   nStop := SECONDS() - nStart
   onDummy( TIME(), "finish after " + LTRIM( STR( nStop ) ) )

   oCatalog := NIL
   oTable := NIL
   oColumn := NIL

   hb_cdpSelect( cOldLang )

   SetCursorWait( "WinLeft", .F. )
   SetCursorWait( "WinRight", .F. )

   DO EVENTS

   //    Msginfo( "finish after " + LTRIM( STR( nStop ) ) )

RETURN .T.

// msginfo( serial2dt(39448),"Date serial 44180 to date"+space(10))
// msginfo( dt2serial(date()),"Today's Date Serial"+space(10))

*+--------------------------------------------------------------------
*+
*+    Static Function serial2dt()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION serial2dt( xdt )

LOCAL x_dateorigin, x_datenew
   //    SET DATE BRITI
   //    SET CENT ON
   x_dateorigin := CTOD( "01.01.1900" )
   x_datenew := ( x_dateorigin + xdt ) - 2
RETURN DTOC( x_datenew )

*+--------------------------------------------------------------------
*+
*+    Static Function dt2serial()
*+
*+    Called from ( ado.prg )   1 - function adoxlsxwrite()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION dt2serial( xdt )

LOCAL x_dateorigin, x_datenew
   //    SET DATE BRITI
   //    SET CENT ON
   x_dateorigin := CTOD( "01.01.1900" )
   x_datenew := ( xdt - x_dateorigin ) + 2
RETURN x_datenew

*+ EOF: ADO.PRG
