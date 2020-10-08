*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\HBEVERY.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Procedure HBEVERY()
*+               Static Procedure DoPrepEverything()
*+               Static Procedure DoPrepInText()
*+               Static Function DOMore()
*+               Static Function DOEveryThing()
*+               Static Procedure GoToDir()
*+               Static Function OnDataResult()
*+               Static Function RECUDIRS()
*+               Static Function hb_doScanM()
*+               Function hb_DirScanM()
*+               Static Function Search_in_file()
*+
*+    Reformatted by Click! 2.05.35 on Oct-8-2020 at  3:10 am
*+
*+--------------------------------------------------------------------

#include "hmg.ch"
#include "hbdyn.ch"

#include "EVERY.CH"
#include "HBFM.CH"

#include "DIRECTRY.CH"
#include "common.CH"
#include "fileio.CH"

#xtranslate DllCall => HMG_CallDLL
#xtranslate bor     => hb_BitOr

STATIC l_Every  := .F.
STATIC l_InText := .F.
STATIC l_InZip  := .F.

MEMVAR aItems
MEMVAR _HMG_SYSDATA

*+--------------------------------------------------------------------
*+
*+    Procedure HBEVERY()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure searchform()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE HBEVERY( cStart )

PRIVATE aItems := {}

   IF SP_lRunGoToDir() = .T.
      RETURN
   ENDIF
   SP_lRunGoToDir( .T. )

   DEFINE WINDOW EVFORM ;
         AT 0, 0 ;
         WIDTH 700 - 20 HEIGHT 600 ;
         TITLE "search" ;
         ICON "ICOSEARCH" ;
         BACKCOLOR SP_nColor1() ;
         NOSIZE ;
         NOMINIMIZE ;
         NOMAXIMIZE

      DEFINE PROGRESSBAR MYPROGRESS
         ROW 1
         COL 1
         WIDTH 670
         HEIGHT 3
         RANGEMIN 1
         RANGEMAX 100
         VALUE 0
         TOOLTIP ""
         HELPID Nil
         VISIBLE .T.
         SMOOTH .F.
         VERTICAL .F.
         BACKCOLOR NIL
         FORECOLOR NIL
      END PROGRESSBAR

      DEFINE TEXTBOX Text_Path
         ROW 10
         COL 10
         WIDTH 245
         HEIGHT 30
         VALUE cStart
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         BACKCOLOR SP_nColor5()
         FONTCOLOR SP_nColor6()
         VISIBLE .T.
         TABSTOP .T.
      END TEXTBOX

      DEFINE TEXTBOX Text_Mask
         ROW 10
         COL 265
         WIDTH 245
         HEIGHT 30
         VALUE SP_cFindExt()
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         BACKCOLOR SP_nColor5()
         FONTCOLOR SP_nColor6()
         ON ENTER DOMore( EVFORM.Text_Mask.Value )
         TABSTOP .T.
      END TEXTBOX

      DEFINE CHECKBOX lEveryThing
         ROW 10
         COL 520
         CAPTION "&Everything"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         VALUE l_Every
         ONCHANGE DoPrepEverything()
         WIDTH 80
         HEIGHT 30
         TABSTOP .F.
      END CHECKBOX

      DEFINE BUTTON Button_1
         ROW 10
         COL 610
         WIDTH 50
         HEIGHT 30
         CAPTION "&search"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         ACTION { || DOMore( EVFORM.Text_Mask.Value ) }
         TOOLTIP ''
         TABSTOP .T.
      END BUTTON

      DEFINE TEXTBOX Search_InText
         ROW 48
         COL 265
         WIDTH 245
         HEIGHT 28
         VALUE SP_cFindText()
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         BACKCOLOR SP_nColor5()
         FONTCOLOR SP_nColor6()
         VISIBLE l_InText
         TABSTOP l_InText
         ON ENTER DOMore( EVFORM.Text_Mask.Value )
      END TEXTBOX

      DEFINE CHECKBOX Check_InText
         ROW 48
         COL 520
         CAPTION "in &Text"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         VALUE l_InText
         ONCHANGE DoPrepInText()
         WIDTH 80
         HEIGHT 28
         TABSTOP .F.
      END CHECKBOX

      DEFINE CHECKBOX Check_InZip
         ROW 48
         COL 610
         CAPTION "in &Zip"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         VALUE l_InZip
         ONCHANGE nil                                                 // DoPrepInText()
         WIDTH 50
         HEIGHT 28
         TABSTOP .F.
      END CHECKBOX

      DEFINE GRID Grid_1
         ROW 80
         COL 10
         WIDTH 650
         HEIGHT 480
         HEADERS { 'Path' }
         WIDTHS { 500 }
         ITEMS aItems
         VIRTUAL .T.
         ITEMCOUNT LEN( aItems )
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         BACKCOLOR SP_nColor9()
         FONTCOLOR SP_nColor10()
         ON QUERYDATA OnDataResult( aItems, ThisWindow.Name, This.Name )
         ON DBLCLICK GoToDir( EVFORM.Grid_1.Value, ThisWindow.Name, This.Name )
         TABSTOP .F.
      END GRID

   END WINDOW

   DoPrepEverything()

   SetProperty( "EVFORM", "MYPROGRESS", "Value", 0 )
   Domethod( "EVFORM", "Text_Mask", "SetFocus" )

   ON KEY ESCAPE OF EVFORM ACTION EVFORM.Release
   CENTER WINDOW EVFORM
   ACTIVATE WINDOW EVFORM

   SP_lRunGoToDir( .F. )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoPrepEverything()
*+
*+    Called from ( hbevery.prg )   2 - procedure hbevery()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoPrepEverything()

LOCAL lEveryThing := EVFORM.lEveryThing.Value

   l_Every := lEveryThing
   IF lEveryThing = .T.
      EVFORM.Text_Path.hide()
   ELSE
      EVFORM.Text_Path.show()
   ENDIF
   EVFORM.Text_Mask.SetFocus()

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoPrepInText()
*+
*+    Called from ( hbevery.prg )   1 - procedure hbevery()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoPrepInText()

LOCAL lIntext := EVFORM.Check_InText.Value
LOCAL lInZip  := EVFORM.Check_InZip.Value

   IF lIntext = .T.
      EVFORM.Search_InText.show()
      l_InText := .T.
   ELSE
      EVFORM.Search_InText.hide()
      l_InText := .F.
   ENDIF

   IF lInZip = .T.
      l_InZip := .T.
   ELSE
      l_InZip := .F.
   ENDIF

   EVFORM.Search_InText.SetFocus()
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function DOMore()
*+
*+    Called from ( hbevery.prg )   3 - procedure hbevery()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION DOMore( cMask )

LOCAL lEveryThing := EVFORM.lEveryThing.Value
LOCAL cStartPath  := TRIM( EVFORM.Text_Path.Value )
LOCAL lIntext     := EVFORM.Check_InText.Value
LOCAL cInTXT      := TRIM( EVFORM.Search_InText.Value )
LOCAL cAttr       := ""
LOCAL cPathSep    := ""
LOCAL hGrid

   SP_cFindExt( cMask )
   l_Every := lEveryThing
   IF lIntext = .T.
      SP_cFindText( cInTXT )
   ENDIF

   EVFORM.Grid_1.DisableUpdate()
   EVFORM.Grid_1.DeleteAllItems()
   aItems := {}

   IF lEveryThing = .T.
      DOEveryThing( cMask )
   ELSE
      cStartPath := EndwithSlash( cStartPath )
      RECUDIRS( cStartPath, TRIM( cMask ), cAttr )
      // aItems := hb_doScanM( cStartPath, {cMask}, cAttr, cPathSep )

      SetProperty( "EVFORM", "Grid_1", "ITEMCOUNT", LEN( aItems ) )

      EVFORM.Grid_1.EnableUpdate()

      hGrid := GetControlHandle( "Grid_1", "EVFORM" )

      LISTVIEW_SETITEMSTATE( hGrid, 1, LVIS_FOCUSED + LVIS_SELECTED, LVIS_FOCUSED + LVIS_SELECTED )
      ListView_EnsureVisible( hGrid, 1 )

   ENDIF
RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Static Function DOEveryThing()
*+
*+    Called from ( hbevery.prg )   1 - static function domore()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION DOEveryThing( cMask )

LOCAL nDll, nEvery, nProz := 0
LOCAL nNum, n
LOCAL cItem
LOCAL aResult := {}
LOCAL buf
LOCAL bufsize := 250
LOCAL nRet    := 0
LOCAL hGrid

   Domethod( "EVFORM", "Grid_1", "SetFocus" )
   hGrid := GetControlHandle( "Grid_1", "EVFORM" )

   EVFORM.Grid_1.DeleteAllItems()

   nDLL := HMG_CallDLL( "Kernel32.dll",, "LoadLibrary", "Everything32.dll" )
   IF nDLL > 0
      nDll := "Everything32.dll"

      // set thesearch
      IF hb_cdpSelect() = "UTF8"
         nRet := DllCall( nDLL,, "Everything_SetSearchW", cMask )
      ELSE
         nRet := DllCall( nDLL,, "Everything_SetSearchA", cMask )
      ENDIF

      // request name and size
      nRet := DllCall( nDLL,, "Everything_SetRequestFlags", bor( EVERYTHING_REQUEST_PATH, EVERYTHING_REQUEST_FILE_NAME, EVERYTHING_REQUEST_SIZE ) )

      // sort by size
      // @Everything32:Everything_SetSort(EVERYTHING_SORT_SIZE_DESCENDING)
      // sort by name
      // @Everything32:Everything_SetSort(EVERYTHING_SORT_NAME_ASCENDING)
      // sort by path
      // @Everything32:Everything_SetSort(EVERYTHING_SORT_PATH_ASCENDING)

      nRet := DllCall( nDLL,, "Everything_SetSort", EVERYTHING_SORT_FILE_LIST_FILENAME_ASCENDING )

      // execute the query
      IF hb_cdpSelect() = "UTF8"
         nRet := DllCall( nDLL,, "Everything_QueryW", .T. )
         nNum := DllCall( nDLL, HB_DYN_CTYPE_LONG, "Everything_GetNumResults" )
      ELSE
         nRet := DllCall( nDLL,, "Everything_QueryA", .T. )
         nNum := DllCall( nDLL, HB_DYN_CTYPE_INT, "Everything_GetNumResults" )
      ENDIF

      SetProperty( "EVFORM", "MYPROGRESS", "Value", 0 )
      nEvery := INT( ROUND( nNum / 100, 0 ) )
      nProz := 0

      FOR n := 1 TO nNum
         buf := SPACE( bufsize )
         IF hb_cdpSelect() = "UTF8"
            nRet := DllCall( nDLL,, "Everything_GetResultFullPathNameW", n, @buf, bufsize )
         ELSE
            nRet := DllCall( nDLL,, "Everything_GetResultFullPathNameA", n, @buf, bufsize )
         ENDIF

         AADD( aResult, UPPER( TRIM( buf ) ) )

         IF ( n % nEvery ) = 0
            // PROGRESSBAR : Numeric (Write Only)
            // nProz := EVFORM.MYPROGRESS.Value
            // nProz ++
            nProz := CalcPos( n, nNum )
            IF nProz > 100
               nProz := 100
            ENDIF
            SetProperty( "EVFORM", "MYPROGRESS", "Value", nProz )
         ENDIF
      NEXT
      // sort it here
      aResult := ASORT( aResult )

      nNum := LEN( aResult )

      SetProperty( "EVFORM", "MYPROGRESS", "Value", 0 )
      nEvery := INT( ROUND( nNum / 100, 0 ) )
      nProz := 0

      FOR n := 1 TO nNum
         cItem := aResult[ n ]
         cItem := STRTRAN( cItem, CHR( 0 ), "" )
         cItem := TRIM( cItem )
         IF EMPTY( cItem )
            LOOP
         ENDIF
         AADD( aItems, { cItem } )

         IF ( n % nEvery ) = 0
            //  PROGRESSBAR : Numeric (Write Only)
            // nProz := EVFORM.MYPROGRESS.Value
            // nProz ++
            nProz := CalcPos( n, nNum )
            IF nProz > 100
               nProz := 100
            ENDIF
            SetProperty( "EVFORM", "MYPROGRESS", "Value", nProz )
         ENDIF
      NEXT

      SetProperty( "EVFORM", "MYPROGRESS", "Value", 0 )
      SetProperty( "EVFORM", "Grid_1", "ITEMCOUNT", LEN( aItems ) )

      EVFORM.Grid_1.EnableUpdate()

      LISTVIEW_SETITEMSTATE( hGrid, 1, LVIS_FOCUSED + LVIS_SELECTED, LVIS_FOCUSED + LVIS_SELECTED )
      ListView_EnsureVisible( hGrid, 1 )

      FreeLibrary( nDLL )
      //
   ELSE
      MsgInfo( "need Everything32.dll !" + CRLF + ;
               "you can get it at" + CRLF + ;
               "http://www.voidtools.com/" )
   ENDIF

RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Static Procedure GoToDir()
*+
*+    Called from ( hbevery.prg )   1 - procedure hbevery()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE GoToDir( nDir, cForm, cObj )

   // LOCAL cText := ""
LOCAL cPath := ""

   cPath := GetProperty( cForm, cObj, "CELL", nDir, 1 )

   SP_cGoToDir( cPath )

   //  cText  := "explorer /e,/select,"+cPath
   //  MemoWrit("ChangeDir.BAT",cText)
   //  RUN ChangeDir.BAT
   //  Runshell( , "/C START ChangeDir.BAT" , .T.)

   EVFORM.Release
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function OnDataResult()
*+
*+    Called from ( hbevery.prg )   1 - procedure hbevery()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION OnDataResult( aData, cForm, cObj )

LOCAL nRow                                                            // := Getproperty( cForm, cGrid_Left ,"QueryRowIndex" )
LOCAL nCol                                                            // := Getproperty( cForm, cGrid_Left ,"Querycolindex" )
LOCAL xVal

   nRow := This.QueryRowIndex
   nCol := This.Querycolindex

   IF .NOT. EMPTY( nRow ) .AND. LEN( aData ) >= nRow
      IF nCol = 1
         xVal := aData[ nRow ] [ 1 ]
         // Setproperty( cForm, cObj,"QueryData",xVal)
         This.QueryData := xVal
      ENDIF
   ENDIF

RETURN .T.

*+--------------------------------------------------------------------
*+
*+    Static Function RECUDIRS()
*+
*+    Called from ( hbevery.prg )   1 - static function domore()
*+                                   1 - static function recudirs()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION RECUDIRS( cPath, cMask, cAttr )

LOCAL c_File
LOCAL n_Size
LOCAL c_Attr
LOCAL a_DIR
LOCAL n_LEN
LOCAL n_Count
LOCAL nSum    := 0
LOCAL cTemp, aFiles, ii, iMax, a_File := {}
LOCAL lIntext := EVFORM.Check_InText.Value
LOCAL cInTXT  := TRIM( EVFORM.Search_InText.Value )
LOCAL lInZip  := EVFORM.Check_InZip.Value

   ALTD()

   a_DIR := DIRECTORY( cPath + "*.*", "D" )
   n_LEN := LEN( a_DIR )

   FOR n_Count := 1 TO n_LEN
      c_File := a_DIR[ n_Count, F_NAME ]
      c_Attr := a_DIR[ n_Count, F_ATTR ]

      IF "D" $ c_Attr .AND. .NOT. ( c_File = "." .OR. c_File = ".." )
         RECUDIRS( cPath + c_File + "\", cMask, cAttr )
      ENDIF
   NEXT

   a_DIR := DIRECTORY( cPath + cMask )
   n_LEN := LEN( a_DIR )
   FOR n_Count := 1 TO n_LEN
      c_File := a_DIR[ n_Count, F_NAME ]
      c_Attr := a_DIR[ n_Count, F_ATTR ]
      n_Size := a_DIR[ n_Count, F_SIZE ]

      IF "D" $ c_Attr
      ELSE
         IF lIntext = .T.
            IF Search_in_file( cPath + c_File, cInTXT )
               AADD( aItems, { cPath + c_File } )
               nSum += n_Size
            ENDIF
         ELSE
            AADD( aItems, { cPath + c_File } )
            nSum += n_Size
         ENDIF
      ENDIF
   NEXT

   IF lInZip = .T.
      ALTD()

      a_DIR := DIRECTORY( cPath + "*.ZIP" )
      n_LEN := LEN( a_DIR )
      n_Count := 1
      FOR n_Count := 1 TO n_LEN
         c_File := a_DIR[ n_Count, F_NAME ]
         c_Attr := a_DIR[ n_Count, F_ATTR ]
         n_Size := a_DIR[ n_Count, F_SIZE ]

         IF "D" $ c_Attr
         ELSE
            cTemp := GetTempFolder()
            aFiles := hb_GetFilesInZip( c_File, .F. )
            iMax := LEN( aFiles )
            ii := 1
            FOR ii := 1 TO iMax
               DO CASE
                  CASE cMask = "*.*"
                     AADD( a_File, aFiles[ ii ] )

                  CASE UPPER( cMask ) = "*.PRG"
                     IF ".PRG" $ UPPER( aFiles[ ii ] )
                        AADD( a_File, aFiles[ ii ] )
                     ENDIF
               ENDCASE
            NEXT

            iMax := LEN( a_File )
            ii := 1
            FOR ii := 1 TO iMax
               hb_UnzipFile( c_File,,,, cTemp, a_File[ ii ], )

               IF lIntext = .T.
                  IF Search_in_file( cTemp + a_File[ ii ], cInTXT )
                     IF ASCAN( aItems, { | e | e[ 1 ] = cPath + c_File } ) > 0
                     ELSE
                        AADD( aItems, { cPath + c_File } )
                     ENDIF
                  ENDIF
               ELSE
                  IF ASCAN( aItems, { | e | e[ 1 ] = cPath + c_File } ) > 0
                  ELSE
                     AADD( aItems, { cPath + c_File } )
                  ENDIF
               ENDIF

               FERASE( cTemp + a_File[ ii ] )
            NEXT
         ENDIF
      NEXT
   ENDIF

RETURN nSum

*+--------------------------------------------------------------------
*+
*+    Static Function hb_doScanM()
*+
*+    Called from ( hbevery.prg )   1 - static function hb_doscanm()
*+                                   1 - function hb_dirscanm()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION hb_doScanM( cPath, aMask, cAttr, cPathSep, lrecursiv )

LOCAL aFile
LOCAL lMatch
LOCAL aResult := {}

   DEFAULT lrecursiv TO .T.

   FOR EACH aFile IN hb_vfDirectory( cPath + hb_osFileMask(), cAttr + IF( lrecursiv, "D", "" ) )
      lMatch := .F.
      AEVAL( aMask, { | x | IIF( HB_ISSTRING( x ), lMatch := hb_FileMatch( aFile[ F_NAME ], x ) .OR. lMatch, Nil ) } )
      IF "D" $ aFile[ F_ATTR ]
         IF lMatch .AND. "D" $ cAttr
            IF lrecursiv = .T.
               AADD( aResult, aFile )
            ENDIF
         ENDIF
         IF !( aFile[ F_NAME ] == "." .OR. aFile[ F_NAME ] == ".." .OR. aFile[ F_NAME ] == "" )
            AEVAL( hb_DoScanM( cPath + aFile[ F_NAME ] + cPathSep, aMask, cAttr, cPathSep ), ;
                   { | x | x[ F_NAME ] := aFile[ F_NAME ] + cPathSep + x[ F_NAME ], ;
                   AADD( aResult, x ) } )
         ENDIF
      ELSEIF lMatch
         AADD( aResult, aFile )
      ENDIF
   NEXT

RETURN aResult

*+--------------------------------------------------------------------
*+
*+    Function hb_DirScanM()
*+
*+    Called from ( thumbs.prg )   2 - procedure thumbs()
*+
*+--------------------------------------------------------------------
*+
FUNCTION hb_DirScanM( cPath, aFileMask, cAttr, lrecursiv )

RETURN hb_DoScanM( hb_DirSepAdd( hb_defaultValue( cPath, "" ) ), ;
                   IIF( HB_ISARRAY( aFileMask ), aFileMask, IIF( HB_ISSTRING( aFileMask ), { aFileMask }, { hb_osFileMask() } ) ), ;
                   hb_defaultValue( cAttr, "" ), ;
                   hb_ps(), lrecursiv )

*+--------------------------------------------------------------------
*+
*+    Static Function Search_in_file()
*+
*+    Called from ( hbevery.prg )   2 - static function recudirs()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION Search_in_file( cFile, cText )

LOCAL nHandle, nEnd, cBuffer, lRet := .F.

   nHandle := FOPEN( cFile )
   nEnd := FSEEK( nHandle, 0, FS_END )
   FSEEK( nHandle, 0, 0 )
   cBuffer := SPACE( nEnd )
   FREAD( nHandle, @cBuffer, nEnd )
   FCLOSE( nHandle )

   IF UPPER( cText ) $ UPPER( cBuffer )
      lRet := .T.
   ENDIF

   cBuffer := ""
   DO EVENTS
RETURN lRet

//
//  eof
//

*+ EOF: HBEVERY.PRG
