*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\DBF2FMG.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Procedure MAIN()
*+               Procedure Make_FMG()
*+               Function Cre_Form()
*+               Function Cre_Label()
*+               Function Cre_Textbox()
*+               Function Cre_CheckBox()
*+
*+    Reformatted by Click! 2.05.30 on Aug-25-2020 at  5:16 am
*+
*+--------------------------------------------------------------------

#include "Directry.ch"
#include "Dbstruct.ch"
#include "Fileio.ch"
#include "common.ch"

#define CRLF         CHR(13)+CHR(10)

#IFDEF Stand_Alone
REQUEST DBFCDX
REQUEST DBFNTX

*+--------------------------------------------------------------------
*+
*+    Procedure MAIN()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE MAIN( cWide, cHight )

LOCAL i, iMax
LOCAL aDir := DIRECTORY( "*.DBF" )

   RDDSETDEFAULT( "DBFCDX" )

   iMax := LEN( aDir )
   FOR i := 1 TO iMax
      Make_FMG( aDir[ i ] [ F_NAME ], cWide, cHight )
   NEXT
   RETURN

#ENDIF

*+--------------------------------------------------------------------
*+
*+    Procedure Make_FMG()
*+
*+    Called from ( browser.prg )   1 - static procedure makefmg()
*+                ( dbf2fmg.prg )   1 - procedure main()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE Make_FMG( cDbf, cWide, cHight )

LOCAL aSize     := { 0, 0 }
LOCAL aStruct
LOCAL ii, iMax, cText
LOCAL cFile, cName, cType, nLen, nDec
LOCAL nHandle
LOCAL nRow, nCol, nWidth, nHeight
LOCAL nMaxlen   := 0
LOCAL nLabellen := 80
LOCAL nStartCol := 10
LOCAL cFPT, cDBT, nWide, nHight

   DEFAULT cWide TO "1280"
   DEFAULT cHight TO "1024"

   ALTD()

   aSize[ 1 ] := VAL( cWide )
   aSize[ 2 ] := VAL( cHight )

   cFile := STRTRAN( UPPER( cDBF ), ".DBF", ".FMG" )
   cFPT := STRTRAN( UPPER( cDBF ), ".DBF", ".FPT" )
   cDBT := STRTRAN( UPPER( cDBF ), ".DBF", ".DBT" )

   //    DO CASE
   //       CASE FILE( cFPT )
   //          USE (cDbf) VIA "DBFCDX" ALIAS DBF2FMG
   //       CASE FILE( cDBT )
   //          USE (cDbf) VIA "DBFNTX" ALIAS DBF2FMG
   //       OTHERWISE
   //          USE (cDbf)              ALIAS DBF2FMG
   //    ENDCASE

   //    IF !NETERR()
   aStruct := DBSTRUCT()
   nHandle := FCREATE( cFile, FC_NORMAL )
   IF nHandle == - 1
   ELSE
      nRow := 10
      nCol := 0
      nHeight := 24

      cText := Cre_Form( aSize )
      FWRITE( nHandle, cText )

      ii := 1
      iMax := LEN( aStruct )
      FOR ii := 1 TO iMax

         nCol := nStartCol
         cName := aStruct[ ii ] [ DBS_NAME ]
         cText := Cre_Label( ii, nRow, nCol, nLabellen, nHeight, cName )
         FWRITE( nHandle, cText )

         cType := aStruct[ ii ] [ DBS_TYPE ]
         nLen := aStruct[ ii ] [ DBS_LEN ]
         nDec := aStruct[ ii ] [ DBS_DEC ]
         nWidth := nLen * 10

         IF cType = "L"
            cText := Cre_CheckBox( ii, nRow, nCol + nLabellen, nWidth, nHeight, cName )
         ELSE
            IF nWidth > 250
               nWidth := 250
            ENDIF
            nCol += nLabellen
            cText := Cre_Textbox( ii, nRow, nCol, nWidth, nHeight, cName, cType, nLen, nDec )
         ENDIF
         FWRITE( nHandle, cText )

         nMaxlen := MAX( nMaxlen, nWidth )

         nRow += 30
         IF nRow >= aSize[ 2 ] - 100
            nStartCol += nLabellen + nMaxlen + 20
            nRow := 10
            nMaxlen := 0
         ENDIF
      NEXT
      FCLOSE( nHandle )
   ENDIF
   //    ENDIF
   //
   //    IF USED()
   //      CLOSE
   //    ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Function Cre_Form()
*+
*+    Called from ( dbf2fmg.prg )   1 - procedure make_fmg()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Cre_Form( aSize )

LOCAL cText := "* Auge & Ohr, Jimmy" + CRLF

   cText += ' ' + CRLF

   cText += 'DEFINE WINDOW TEMPLATE AT 0,0 '
   cText += 'WIDTH ' + LTRIM( STR( aSize[ 1 ] ) ) + ' '
   cText += 'HEIGHT ' + LTRIM( STR( aSize[ 2 ] ) ) + ' '
   cText += 'VIRTUAL WIDTH Nil '
   cText += 'VIRTUAL HEIGHT Nil '
   cText += 'TITLE "" '
   cText += 'ICON NIL '
   cText += 'CURSOR NIL '
   cText += 'ON INIT Nil '
   cText += 'ON RELEASE Nil '
   cText += 'ON INTERACTIVECLOSE Nil '
   cText += 'ON MOUSECLICK Nil '
   cText += 'ON MOUSEDRAG Nil '
   cText += 'ON MOUSEMOVE Nil '
   cText += 'ON SIZE Nil '
   cText += 'ON MAXIMIZE Nil '
   cText += 'ON MINIMIZE Nil '
   cText += 'ON PAINT Nil '
   cText += 'BACKCOLOR NIL '
   cText += 'NOTIFYICON NIL '
   cText += 'NOTIFYTOOLTIP NIL '
   cText += 'ON NOTIFYCLICK Nil '
   cText += 'ON GOTFOCUS Nil '
   cText += 'ON LOSTFOCUS Nil '
   cText += 'ON SCROLLUP Nil '
   cText += 'ON SCROLLDOWN Nil '
   cText += 'ON SCROLLLEFT Nil '
   cText += 'ON SCROLLRIGHT Nil '
   cText += 'ON HSCROLLBOX Nil '
   cText += 'ON VSCROLLBOX Nil ' + CRLF
   cText += ' ' + CRLF

RETURN cText

*+--------------------------------------------------------------------
*+
*+    Function Cre_Label()
*+
*+    Called from ( dbf2fmg.prg )   1 - procedure make_fmg()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Cre_Label( nNo, nRow, nCol, nWidth, nHeight, cValue )

LOCAL cLabel := "Label_" + STRZERO( nNo, 3 )
LOCAL cText  := ""

   cText += 'DEFINE LABEL ' + cLabel + CRLF
   cText += '   ROW ' + LTRIM( STR( nRow ) ) + CRLF
   cText += '   COL ' + LTRIM( STR( nCol ) ) + CRLF
   cText += '   WIDTH ' + LTRIM( STR( nWidth ) ) + CRLF
   cText += '   HEIGHT ' + LTRIM( STR( nHeight ) ) + CRLF
   cText += '   VALUE "' + cValue + '" ' + CRLF
   cText += '   FONTNAME "Arial" ' + CRLF
   cText += '   FONTSIZE 10 ' + CRLF
   cText += '   TOOLTIP "" ' + CRLF
   cText += '   FONTBOLD .F. ' + CRLF
   cText += '   FONTITALIC .F. ' + CRLF
   cText += '   FONTUNDERLINE .F. ' + CRLF
   cText += '   FONTSTRIKEOUT .F. ' + CRLF
   cText += '   HELPID Nil ' + CRLF
   cText += '   VISIBLE .T. ' + CRLF
   cText += '   TRANSPARENT .F. ' + CRLF
   cText += '   ACTION Nil ' + CRLF
   cText += '   AUTOSIZE .F. ' + CRLF
   cText += '   BACKCOLOR Nil ' + CRLF
   cText += '   FONTCOLOR Nil ' + CRLF
   cText += 'END LABEL' + CRLF
   cText += ' ' + CRLF

RETURN cText

*+--------------------------------------------------------------------
*+
*+    Function Cre_Textbox()
*+
*+    Called from ( dbf2fmg.prg )   1 - procedure make_fmg()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Cre_Textbox( nNo, nRow, nCol, nWidth, nHeight, cField, cType, nLen, nDec )

LOCAL cText
LOCAL cDef   := "Text_" + STRZERO( nNo, 3 )
LOCAL cValue := "NIL"

   cText := 'DEFINE TEXTBOX ' + cDef + CRLF
   cText += '   ROW ' + LTRIM( STR( nRow ) ) + CRLF
   cText += '   COL ' + LTRIM( STR( nCol ) ) + CRLF
   cText += '   WIDTH ' + LTRIM( STR( nWidth ) ) + CRLF
   cText += '   HEIGHT ' + LTRIM( STR( nHeight ) ) + CRLF
   cText += '   FONTNAME "Arial" ' + CRLF
   cText += '   FONTSIZE 10 ' + CRLF
   cText += '   TOOLTIP "" ' + CRLF
   cText += '   ONCHANGE Nil ' + CRLF
   cText += '   ONGOTFOCUS Nil ' + CRLF
   cText += '   ONLOSTFOCUS Nil ' + CRLF
   cText += '   FONTBOLD .F. ' + CRLF
   cText += '   FONTITALIC .F. ' + CRLF
   cText += '   FONTUNDERLINE .F. ' + CRLF
   cText += '   FONTSTRIKEOUT .F. ' + CRLF
   cText += '   ONENTER Nil ' + CRLF
   cText += '   HELPID Nil ' + CRLF
   cText += '   TABSTOP .T. ' + CRLF
   cText += '   VISIBLE .T. ' + CRLF
   cText += '   READONLY .F. ' + CRLF
   cText += '   RIGHTALIGN .F. ' + CRLF
   cText += '   DISABLEDBACKCOLOR Nil ' + CRLF
   cText += '   DISABLEDFONTCOLOR Nil ' + CRLF
   cText += '   CASECONVERT NONE ' + CRLF
   cText += '   BACKCOLOR Nil ' + CRLF
   cText += '   FONTCOLOR Nil ' + CRLF
   cText += '   INPUTMASK Nil ' + CRLF
   cText += '   FORMAT Nil ' + CRLF
   cText += '   VALUE "' + cValue + '" ' + CRLF
   DO CASE
      CASE cType = "C"
         cText += "   INPUTMASK '" + REPL( "X", nLen ) + "' " + CRLF
      CASE cType = "N" .AND. nDec = 0
         cText += "   NUMERIC INPUTMASK '" + REPL( "9", nLen ) + "' " + CRLF
      CASE cType = "N" .AND. nDec <> 0
         cText += "   NUMERIC INPUTMASK '" + REPLICATE( "9", nLen - nDec - 1 ) + "." + REPLICATE( "9", nDec ) + "' " + CRLF
      CASE cType = "D"
         cText += "   DATE INPUTMASK '99.99.9999' " + CRLF
   ENDCASE
   cText += 'END TEXTBOX' + CRLF
   cText += ' ' + CRLF

RETURN cText

*+--------------------------------------------------------------------
*+
*+    Function Cre_CheckBox()
*+
*+    Called from ( dbf2fmg.prg )   1 - procedure make_fmg()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Cre_CheckBox( nNo, nRow, nCol, nWidth, nHeight, cName )

LOCAL cText
LOCAL cDef  := "CheckBox_" + STRZERO( nNo, 3 )

   cText := 'DEFINE CHECKBOX ' + cDef + CRLF
   cText += '   ROW ' + LTRIM( STR( nRow ) ) + CRLF
   cText += '   COL ' + LTRIM( STR( nCol ) ) + CRLF
   cText += '   WIDTH  ' + LTRIM( STR( nWidth ) ) + CRLF
   cText += '   HEIGHT  ' + LTRIM( STR( nHeight ) ) + CRLF
   cText += '   CAPTION "' + cName + '" ' + CRLF
   cText += '   VALUE .F.' + CRLF
   cText += '   FONTNAME "Arial"' + CRLF
   cText += '   FONTSIZE 9' + CRLF
   cText += '   TOOLTIP ""' + CRLF
   cText += '   ONCHANGE Nil' + CRLF
   cText += '   ONGOTFOCUS Nil' + CRLF
   cText += '   ONLOSTFOCUS Nil' + CRLF
   cText += '   FONTBOLD .F.' + CRLF
   cText += '   FONTITALIC .F.' + CRLF
   cText += '   FONTUNDERLINE .F.' + CRLF
   cText += '   FONTSTRIKEOUT .F.' + CRLF
   cText += '   BACKCOLOR Nil' + CRLF
   cText += '   FONTCOLOR Nil' + CRLF
   cText += '   HELPID Nil' + CRLF
   cText += '   TABSTOP .T.' + CRLF
   cText += '   VISIBLE .T.' + CRLF
   cText += '   TRANSPARENT .F.' + CRLF
   cText += 'END CHECKBOX ' + CRLF
   cText += ' ' + CRLF
RETURN cText

//
//
//

*+ EOF: DBF2FMG.PRG
