*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\HBFILTER.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Procedure HBFILTER()
*+               Static Procedure FillComboData()
*+               Static Procedure SatzEval()
*+               Static Procedure SetDbfFilter()
*+               Static Procedure FieldPre()
*+               Static Procedure FillPreCombo()
*+               Static Procedure WahlPre()
*+               Static Procedure FillMidCombo()
*+               Static Procedure WahlMid()
*+               Static Procedure FillPostCombo()
*+               Static Procedure WahlPost()
*+               Static Procedure FillMoreCombo()
*+               Static Procedure WahlMore()
*+               Static Procedure ControlOnOff()
*+               Static Procedure ShowSay()
*+
*+    Reformatted by Click! 2.05.30 on Aug-28-2020 at  1:52 am
*+
*+--------------------------------------------------------------------

#include "hmg.ch"
#include "Dbstruct.ch"
#include "common.ch"

STATIC aPre, aMid, aPost, aMore, aControls
MEMVAR _HMG_SYSDATA

*+--------------------------------------------------------------------
*+
*+    Procedure HBFILTER()
*+
*+    Called from ( browser.prg )   1 - static procedure setdbffilter()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE HBFILTER()

LOCAL aStructure := SP_aDbfStruct()

   DEFINE WINDOW HBWinFILTER ;
              AT 449, 340 ;
              WIDTH 970 ;
              HEIGHT 278 ;
              TITLE "" ;
              ICON NIL ;
              ON INIT FillComboData( aStructure ) ;
              ON RELEASE Nil ;
              NOSIZE ;
              NOMAXIMIZE ;
              NOMINIMIZE ;
              BACKCOLOR SP_nColor1()

      DEFINE EDITBOX Edit_Filter
         ROW 10
         COL 10
         WIDTH 930
         HEIGHT 100
         VALUE ""
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         TABSTOP .T.
         VISIBLE .T.
         READONLY .F.
         HSCROLLBAR .T.
         VSCROLLBAR .T.
         DISABLEDBACKCOLOR Nil
         DISABLEDFONTCOLOR Nil
         BACKCOLOR SP_nColor5()
         FONTCOLOR SP_nColor6()
      END EDITBOX

      DEFINE COMBOBOX Combo_Fields
         ROW 130
         COL 10
         WIDTH 100
         HEIGHT 100
         ITEMS { "" }
         VALUE 0
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS FieldPre()
         TABSTOP .T.
         VISIBLE .T.
         SORT .F.
         ONENTER Nil
         ONDISPLAYCHANGE Nil
         DISPLAYEDIT .F.
         IMAGE Nil
         DROPPEDWIDTH Nil
         ONDROPDOWN Nil
         ONCLOSEUP Nil
      END COMBOBOX

      DEFINE COMBOBOX Combo_Pre
         ROW 130
         COL 120
         WIDTH 100
         HEIGHT 100
         ITEMS { "" }
         VALUE 0
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS WahlPre()
         TABSTOP .T.
         VISIBLE .T.
         SORT .F.
         ONENTER Nil
         ONDISPLAYCHANGE Nil
         DISPLAYEDIT .F.
         IMAGE Nil
         DROPPEDWIDTH Nil
         ONDROPDOWN Nil
         ONCLOSEUP Nil
      END COMBOBOX

      DEFINE TEXTBOX Text_Pre
         ROW 130
         COL 230
         WIDTH 120
         HEIGHT 24
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS nil
         ONENTER HBWinFILTER.Combo_Mid.SetFocus
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

      DEFINE COMBOBOX Combo_Mid
         ROW 130
         COL 360
         WIDTH 100
         HEIGHT 100
         ITEMS { "" }
         VALUE 0
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS WahlMid()
         TABSTOP .T.
         VISIBLE .T.
         SORT .F.
         ONENTER Nil
         ONDISPLAYCHANGE Nil
         DISPLAYEDIT .F.
         IMAGE Nil
         DROPPEDWIDTH Nil
         ONDROPDOWN Nil
         ONCLOSEUP Nil
      END COMBOBOX

      DEFINE TEXTBOX Text_Mid
         ROW 130
         COL 470
         WIDTH 120
         HEIGHT 24
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         ONENTER HBWinFILTER.Combo_Post.SetFocus
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

      DEFINE COMBOBOX Combo_Post
         ROW 130
         COL 600
         WIDTH 100
         HEIGHT 100
         ITEMS { "" }
         VALUE 0
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS WahlPost()
         TABSTOP .T.
         VISIBLE .T.
         SORT .F.
         ONENTER Nil
         ONDISPLAYCHANGE Nil
         DISPLAYEDIT .F.
         IMAGE Nil
         DROPPEDWIDTH Nil
         ONDROPDOWN Nil
         ONCLOSEUP Nil
      END COMBOBOX

      DEFINE TEXTBOX Text_Post
         ROW 130
         COL 710
         WIDTH 120
         HEIGHT 24
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS nil
         ONENTER HBWinFILTER.Combo_More.setfocus
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

      DEFINE COMBOBOX Combo_More
         ROW 130
         COL 840
         WIDTH 100
         HEIGHT 100
         ITEMS { "" }
         VALUE 0
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS WahlMore()
         TABSTOP .T.
         VISIBLE .T.
         SORT .F.
         ONENTER Nil
         ONDISPLAYCHANGE Nil
         DISPLAYEDIT .F.
         IMAGE Nil
         DROPPEDWIDTH Nil
         ONDROPDOWN Nil
         ONCLOSEUP Nil
      END COMBOBOX

      DEFINE BUTTON Button_Abort
         ROW 170
         COL 10
         WIDTH 100
         HEIGHT 60
         ACTION { || SP_cFilter( "ABORT" ), HBWinFILTER.Release }
         CAPTION "&Abort"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
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

      DEFINE BUTTON Button_Eval
         ROW 170
         COL 360
         WIDTH 100
         HEIGHT 60
         ACTION SatzEval()
         CAPTION "&Eval"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
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

      DEFINE BUTTON Button_Clear
         ROW 170
         COL 470
         WIDTH 100
         HEIGHT 60
         ACTION HBWinFILTER.Edit_Filter.Value := ""
         CAPTION "&Clear Filter"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
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

      DEFINE BUTTON Button_Save
         ROW 170
         COL 840
         WIDTH 100
         HEIGHT 60
         ACTION SetDbfFilter()
         CAPTION "&Use it"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
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

   HBWinFILTER.Combo_Fields.setfocus
   ON KEY ESCAPE OF HBWinFILTER ACTION { || SP_cFilter( "ABORT" ), HBWinFILTER.Release }

   CENTER WINDOW HBWinFILTER
   ACTIVATE WINDOW HBWinFILTER

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure FillComboData()
*+
*+    Called from ( hbfilter.prg )   1 - procedure hbfilter()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE FillComboData( aStructure )

LOCAL ii, iMax

   aPre := { { " NONE ", .T. }, ;
             { " $ ", .T. }, ;
             { " == ", .T. }, ;
             { " <> ", .T. }, ;
             { " > ", .T. }, ;
             { " >= ", .T. }, ;
             { " < ", .T. }, ;
             { " <= ", .T. } }

   aMid := { { " NONE ", .T. }, ;
             { " .AND. ", .T. }, ;
             { " .OR. ", .T. }, ;
             { " .AND. .NOT. ", .T. } }

   aPost := { { " NONE ", .T. }, ;
              { " < ", .T. }, ;
              { " <= ", .T. }, ;
              { " > ", .T. }, ;
              { " >= ", .T. } }

   aMore := { { " NONE ", .T. }, ;
              { " .AND. ", .T. }, ;
              { " .OR. ", .T. }, ;
              { " .AND. .NOT. ", .T. } }

   HBWinFILTER.Combo_Fields.DeleteAllItems
   iMax := LEN( aStructure )
   FOR ii := 1 TO iMax
      HBWinFILTER.Combo_Fields.AddItem( aStructure[ ii ] [ 1 ] )
   NEXT
   IF !EMPTY( iMax )
      HBWinFILTER.Combo_Fields.VALUE := 1
   ENDIF

   HBWinFILTER.Combo_Pre.DeleteAllItems
   iMax := LEN( aPre )
   FOR ii := 1 TO iMax
      HBWinFILTER.Combo_Pre.AddItem( aPre[ ii ] [ 1 ] )
   NEXT
   HBWinFILTER.Combo_Pre.VALUE := 1

   HBWinFILTER.Combo_Mid.DeleteAllItems
   iMax := LEN( aMid )
   FOR ii := 1 TO iMax
      HBWinFILTER.Combo_Mid.AddItem( aMid[ ii ] [ 1 ] )
   NEXT
   HBWinFILTER.Combo_Mid.VALUE := 1

   HBWinFILTER.Combo_Post.DeleteAllItems
   iMax := LEN( aPost )
   FOR ii := 1 TO iMax
      HBWinFILTER.Combo_Post.AddItem( aPost[ ii ] [ 1 ] )
   NEXT
   HBWinFILTER.Combo_Post.VALUE := 1

   HBWinFILTER.Combo_More.DeleteAllItems
   iMax := LEN( aMore )
   FOR ii := 1 TO iMax
      HBWinFILTER.Combo_More.Additem( aMore[ ii ] [ 1 ] )
   NEXT
   HBWinFILTER.Combo_More.VALUE := 1

   HBWinFILTER.Button_Save.Enabled := .F.

   HBWinFILTER.Edit_Filter.Value := SP_cFilter()

   aControls := {}
   AADD( aControls, "HBWinFILTER.Combo_Fields" )
   AADD( aControls, "HBWinFILTER.Combo_Pre" )
   AADD( aControls, "HBWinFILTER.Text_Pre" )
   AADD( aControls, "HBWinFILTER.Combo_Mid" )
   AADD( aControls, "HBWinFILTER.Text_Mid" )
   AADD( aControls, "HBWinFILTER.Combo_Post" )
   AADD( aControls, "HBWinFILTER.Text_Post" )
   AADD( aControls, "HBWinFILTER.Combo_More" )

   ControlOnOff( .F. )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SatzEval()
*+
*+    Called from ( hbfilter.prg )   1 - procedure hbfilter()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SatzEval()

LOCAL bBlock
LOCAL bSaveError
LOCAL oError
LOCAL lret       := .F.
LOCAL cText      := ""
LOCAL iMax, nPosi
LOCAL cFeldCombo, cPreCombo, cSLEpre, cMidCombo, cSLEsay, cPostCombo, cSLEpost, cMoreCombo, cType
LOCAL aStructure := SP_aDbfStruct()

   IF !EMPTY( HBWinFILTER.Edit_Filter.Value )
      cText := HBWinFILTER.Edit_Filter.Value
   ELSE

      cFeldCombo := HBWinFILTER.Combo_Fields.Item( HBWinFILTER.Combo_Fields.VALUE )

      nPosi := ASCAN( aStructure, { | e | e[ DBS_NAME ] = cFeldCombo } )
      IF nPosi > 0
         cType := aStructure[ nPosi ] [ DBS_TYPE ]
      ELSE
         cType := "U"
      ENDIF

      cPreCombo := HBWinFILTER.Combo_Pre.Item( HBWinFILTER.Combo_Pre.VALUE )
      cSLEpre := HBWinFILTER.Text_Pre.VALUE

      cMidCombo := HBWinFILTER.Combo_Mid.Item( HBWinFILTER.Combo_Mid.Value )
      cSLEsay := HBWinFILTER.Text_Mid.VALUE

      cPostCombo := HBWinFILTER.Combo_Post.Item( HBWinFILTER.Combo_Post.Value )
      cSLEpost := HBWinFILTER.Text_Post.VALUE

      cMoreCombo := HBWinFILTER.Combo_More.Item( HBWinFILTER.Combo_More.Value )

      ALTD()

      IF "NONE" $ cMidCombo
      ELSE
         DO CASE
            CASE "NONE" $ cPostCombo
               MsgInfo( "while Mid is " + cMidCombo + " you need 2nd Operator" )
               HBWinFILTER.Combo_Post.Setfocus()
               RETURN

            CASE EMPTY( TRIM( cSLEpost ) )
               MsgInfo( "while Mid is " + cMidCombo + " you need 2nd Value" )
               HBWinFILTER.Text_Post.Setfocus()
               RETURN

            CASE EMPTY( TRIM( cSLEsay ) )
               MsgInfo( "something wrong with '" + cSLEsay + "'" )
               HBWinFILTER.Combo_Pre.Setfocus()
               RETURN
         ENDCASE
      ENDIF

      // ----------------------------------------------------------------------

      DO CASE
         CASE cType = "C"

            DO CASE
               CASE cPreCombo = " $ "
#IFDEF Use_SQL
                  cText += cFeldCombo + " LIKE " + "'%" + TRIM( cSLEpre ) + "%'"
#ELSE
                  cText += "'" + TRIM( cSLEpre ) + "' $ " + cFeldCombo
#ENDIF
               CASE cPreCombo = " == "
                  cText += cFeldCombo + " = " + "'" + TRIM( cSLEpre ) + "'"
               CASE cPreCombo = " <> "
                  cText += cFeldCombo + cPreCombo + "'" + TRIM( cSLEpre ) + "'"
               CASE cPreCombo = " > "
                  cText += cFeldCombo + cPreCombo + "'" + TRIM( cSLEpre ) + "'"
               CASE cPreCombo = " >= "
                  cText += cFeldCombo + cPreCombo + "'" + TRIM( cSLEpre ) + "'"
               CASE cPreCombo = " < "
                  cText += cFeldCombo + cPreCombo + "'" + TRIM( cSLEpre ) + "'"
               CASE cPreCombo = " <= "
                  cText += cFeldCombo + cPreCombo + "'" + TRIM( cSLEpre ) + "'"
            ENDCASE

            IF "NONE" $ cMidCombo
            ELSE
               cText += cMidCombo + TRIM( cSLEsay ) + cPostCombo + "'" + TRIM( cSLEpost ) + "'"
            ENDIF

         CASE cType = "N"

            IF .NOT. ISDIGIT( ALLTRIM( cSLEpre ) )
               MsgInfo( "Value must be numeric" )
               HBWinFILTER.Text_Pre.Setfocus()
               RETURN
            ENDIF

            cText += cFeldCombo + cPreCombo + "'" + TRIM( cSLEpre ) + "'"

            IF "NONE" $ cMidCombo
            ELSE
               IF .NOT. ISDIGIT( ALLTRIM( cSLEpost ) )
                  MsgInfo( "Value must be numeric" )
                  HBWinFILTER.Text_Post.Setfocus( )
                  RETURN
               ENDIF
               cText += cMidCombo + TRIM( cSLEsay ) + cPostCombo + "'" + TRIM( cSLEpost ) + "'"
            ENDIF

         CASE cType = "D"

            IF EMPTY( CTOD( cSLEpre ) )
               MsgInfo( "Value must be valid Date " + DTOC( DATE() ) )
               HBWinFILTER.Text_Pre.Setfocus()
               RETURN
            ENDIF

            cText += cFeldCombo + cPreCombo + " '" + DTOS( CTOD( TRIM( cSLEpre ) ) ) + "'"

            IF "NONE" $ cMidCombo
            ELSE
               IF EMPTY( CTOD( cSLEpost ) )
                  MsgInfo( "Value must be valid Date" )
                  HBWinFILTER.Text_Post.Setfocus( )
                  RETURN
               ENDIF
               cText += cMidCombo + TRIM( cSLEsay ) + cPostCombo + " '" + DTOS( CTOD( TRIM( cSLEpost ) ) ) + "'"                            // + ")"
            ENDIF

         CASE cType = "L"

            DO CASE
               CASE cPreCombo = " == "
                  cText += cFeldCombo
               CASE cPreCombo = " <> "
                  cText += " .NOT. " + cFeldCombo
               OTHERWISE
                  MsgInfo( "Logic only .T. -> '==' or .F. -> '<>' " )
                  HBWinFILTER.Combo_Pre.Setfocus()
                  RETURN
            ENDCASE

      ENDCASE

      HBWinFILTER.Edit_Filter.Value := cText
   ENDIF

   // ----------------------------------------------------------------------

   //  ondummy( cText )                                                   // debug

   bBlock := "{|| " + cText + " }"
   //    cOutString := bBlock
   //    cOutString := cText

   bSaveError := ERRORBLOCK()
   ERRORBLOCK( { | e | BREAK( e ) } )
   BEGIN SEQUENCE

      EVAL( &( bBlock ) )
      lret := .T.

      // da es keine DBF ist
      // erkennt er kein Field
      // und meint die Variable
      // w„re unbekannt
      //
      //  for SQL use this
      //  bBlock := { | x | x }
      //  lRet := EVAL( bBlock, cText )

   RECOVER USING oError
      ERRORBLOCK( bSaveError )
   END SEQUENCE
   ERRORBLOCK( bSaveError )

   IF lret = .T.
      MsgInfo( "Codeblock OK" )
      HBWinFILTER.Button_Save.Enabled := .T.
      HBWinFILTER.Button_Save.Setfocus
      SP_cFilter( HBWinFILTER.Edit_Filter.Value )
   ELSE
      MsgInfo( "Error eval Codeblock" )
      HBWinFILTER.Button_Save.Enabled := .F.
      SP_cFilter( "" )
   ENDI
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SetDbfFilter()
*+
*+    Called from ( hbfilter.prg )   1 - procedure hbfilter()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SetDbfFilter()

   SP_cFilter( HBWinFILTER.Edit_Filter.Value )

   HBWinFILTER.Release
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure FieldPre()
*+
*+    Called from ( hbfilter.prg )   1 - procedure hbfilter()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE FieldPre()

LOCAL nPosi, cType
LOCAL cFeldCombo
LOCAL aStruc     := SP_aDbfStruct()

   cFeldCombo := HBWinFILTER.Combo_Fields.Item( HBWinFILTER.Combo_Fields.VALUE )

   nPosi := ASCAN( aStruc, { | x | x[ 1 ] = cFeldCombo } )
   IF nPosi > 0
      cType := aStruc[ nPosi ] [ DBS_TYPE ]

      aPre := { { " NONE ", .F. }, ;
                { " $ ", .T. }, ;
                { " == ", .T. }, ;
                { " <> ", .T. }, ;
                { " > ", .T. }, ;
                { " >= ", .T. }, ;
                { " < ", .T. }, ;
                { " <= ", .T. } }
   ENDIF

   DO CASE
      CASE cType = "C"
         aPre[ 2 ] [ 2 ] := .T.
         aPre[ 3 ] [ 2 ] := .T.
         aPre[ 4 ] [ 2 ] := .T.

         aPre[ 5 ] [ 2 ] := .T.
         aPre[ 6 ] [ 2 ] := .T.
         aPre[ 7 ] [ 2 ] := .T.
         aPre[ 8 ] [ 2 ] := .T.

      CASE cType = "N"
         aPre[ 2 ] [ 2 ] := .F.
         aPre[ 3 ] [ 2 ] := .T.
         aPre[ 4 ] [ 2 ] := .T.
         aPre[ 5 ] [ 2 ] := .T.
         aPre[ 6 ] [ 2 ] := .T.
         aPre[ 7 ] [ 2 ] := .T.
         aPre[ 8 ] [ 2 ] := .T.

      CASE cType = "D"
         aPre[ 2 ] [ 2 ] := .F.
         aPre[ 3 ] [ 2 ] := .T.
         aPre[ 4 ] [ 2 ] := .T.
         aPre[ 5 ] [ 2 ] := .T.
         aPre[ 6 ] [ 2 ] := .T.
         aPre[ 7 ] [ 2 ] := .T.
         aPre[ 8 ] [ 2 ] := .T.

      CASE cType = "L"

         aPre[ 2 ] [ 2 ] := .F.
         aPre[ 3 ] [ 2 ] := .T.
         aPre[ 4 ] [ 2 ] := .T.
         aPre[ 5 ] [ 2 ] := .F.
         aPre[ 6 ] [ 2 ] := .F.
         aPre[ 7 ] [ 2 ] := .F.
         aPre[ 8 ] [ 2 ] := .F.
   ENDCASE

   FillPreCombo()

   IF nPosi > 0
      HBWinFILTER.Combo_Pre.SETFOCUS()
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure FillPreCombo()
*+
*+    Called from ( hbfilter.prg )   1 - static procedure fieldpre()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE FillPreCombo()

LOCAL ii, nPre := LEN( aPre )
LOCAL nCount := 0

   HBWinFILTER.Combo_Pre.DeleteAllItems
   ii := 1
   FOR ii := 1 TO nPre
      IF aPre[ ii ] [ 2 ] = .T.
         HBWinFILTER.Combo_Pre.addItem( aPre[ ii ] [ 1 ] )
         nCount ++
      ENDIF
   NEXT
   IF !EMPTY( nCount )
      HBWinFILTER.Combo_Pre.VALUE := 1
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure WahlPre()
*+
*+    Called from ( hbfilter.prg )   1 - procedure hbfilter()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE WahlPre()

LOCAL nPosi, cType
LOCAL cPreCombo

   nPosi := ASCAN( aPre, { | e | e[ 2 ] = .T. } )
   IF nPosi > 0
      ControlOnOff( .F. )
      IF cType = "L"
      ELSE
         cPreCombo := HBWinFILTER.Combo_Pre.Item( HBWinFILTER.Combo_Pre.VALUE )
         DO CASE
            CASE "NONE" $ cPreCombo
               MSGInfo( "NONE make no Sence" )
               HBWinFILTER.Combo_Pre.Setfocus
               RETURN

            CASE "$" $ UPPER( cPreCombo )
               ControlOnOff( .T., 3, 3 )
            CASE "==" $ UPPER( cPreCombo )
               ControlOnOff( .T., 3, 3 )
            CASE "<>" $ UPPER( cPreCombo )
               ControlOnOff( .T., 3, 3 )
            OTHERWISE
               ControlOnOff( .T., 3, 4 )
         ENDCASE
      ENDIF
      FillMidCombo()

      HBWinFILTER.Text_Pre.SetFocus
   ELSE
      HBWinFILTER.Combo_Pre.SetFocus
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure FillMidCombo()
*+
*+    Called from ( hbfilter.prg )   1 - static procedure wahlpre()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE FillMidCombo()

LOCAL ii, nMid := LEN( aMid )
LOCAL nPosi, nCount := 0

   HBWinFILTER.Combo_Mid.DeleteAllItems

   nPosi := ASCAN( aMid, { | e | e[ 2 ] = .T. } )
   IF nPosi > 0
      ii := 1
      FOR ii := 1 TO nMid
         IF aMid[ ii ] [ 2 ] = .T.
            HBWinFILTER.Combo_Mid.addItem( aMid[ ii ] [ 1 ] )
            nCount ++
         ENDIF
      NEXT
      IF !EMPTY( nCount )
         HBWinFILTER.Combo_Mid.VALUE := 1
      ENDIF
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure WahlMid()
*+
*+    Called from ( hbfilter.prg )   1 - procedure hbfilter()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE WahlMid()

LOCAL nPosi
LOCAL cMidCombo

   nPosi := ASCAN( aMid, { | e | e[ 2 ] = .T. } )
   IF nPosi > 0
      cMidCombo := HBWinFILTER.Combo_Mid.Item( HBWinFILTER.Combo_Mid.Value )

      IF "NONE" $ cMidCombo
         ControlOnOff( .F., 5, 7 )
      ELSE
         ControlOnOff( .T., 5, 8 )
         ShowSay()
      ENDIF

      IF "NONE" $ cMidCombo
         aPost[ 1 ] [ 2 ] := .T.
         aPost[ 2 ] [ 2 ] := .F.
         aPost[ 3 ] [ 2 ] := .F.
         aPost[ 4 ] [ 2 ] := .F.
         aPost[ 5 ] [ 2 ] := .F.
      ELSE
         aPost[ 1 ] [ 2 ] := .F.
         aPost[ 2 ] [ 2 ] := .T.
         aPost[ 3 ] [ 2 ] := .T.
         aPost[ 4 ] [ 2 ] := .T.
         aPost[ 5 ] [ 2 ] := .T.
      ENDIF

      FillPostCombo()

      IF "NONE" $ cMidCombo
         HBWinFILTER.Button_Save.SetFocus
      ELSE
         HBWinFILTER.Combo_Post.SetFocus
      ENDIF
   ELSE
      HBWinFILTER.Combo_Mid.SetFocus
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure FillPostCombo()
*+
*+    Called from ( hbfilter.prg )   1 - static procedure wahlmid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE FillPostCombo()

LOCAL nCount := 0
LOCAL ii, nPost := LEN( aPost )

   HBWinFILTER.Combo_Post.DeleteAllItems
   ii := 1
   FOR ii := 1 TO nPost
      IF aPost[ ii ] [ 2 ] = .T.
         HBWinFILTER.Combo_Post.addItem( aPost[ ii ] [ 1 ] )
         nCount ++
      ENDIF
   NEXT
   IF !EMPTY( nCount )
      HBWinFILTER.Combo_Post.VALUE := 1
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure WahlPost()
*+
*+    Called from ( hbfilter.prg )   1 - procedure hbfilter()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE WahlPost()

LOCAL nPosi, cPostCombo

   nPosi := ASCAN( aPost, { | e | e[ 2 ] = .T. } )
   IF nPosi > 0

      cPostCombo := HBWinFILTER.Combo_Post.Item( HBWinFILTER.Combo_Post.Value )

      IF "NONE" $ cPostCombo
         ControlOnOff( .F., 7, 7 )
      ELSE
         ControlOnOff( .T., 7, 8 )
      ENDIF

      FillMoreCombo()

      HBWinFILTER.Text_Post.SetFocus
   ELSE
      HBWinFILTER.Combo_Post.SetFocus
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure FillMoreCombo()
*+
*+    Called from ( hbfilter.prg )   1 - static procedure wahlpost()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE FillMoreCombo()

LOCAL ii, nMore := LEN( aMore )
LOCAL nCount := 0

   HBWinFILTER.Combo_More.DeleteAllItems
   ii := 1
   FOR ii := 1 TO nMore
      IF aMore[ ii ] [ 2 ] = .T.
         HBWinFILTER.Combo_More.addItem( aMore[ ii ] [ 1 ] )
         nCount ++
      ENDIF
   NEXT
   IF !EMPTY( nCount )
      HBWinFILTER.Combo_More.VALUE := 1
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure WahlMore()
*+
*+    Called from ( hbfilter.prg )   1 - procedure hbfilter()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE WahlMore()

LOCAL nPosi, cMoreCombo

   nPosi := ASCAN( aMore, { | e | e[ 2 ] = .T. } )
   IF nPosi > 0
      cMoreCombo := HBWinFILTER.Combo_More.Item( HBWinFILTER.Combo_More.Value )

      IF "NONE" $ cMoreCombo
         HBWinFILTER.Button_Eval.Setfocus
      ENDIF
   ELSE
      HBWinFILTER.Combo_More.Setfocus
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure ControlOnOff()
*+
*+    Called from ( hbfilter.prg )   1 - static procedure fillcombodata()
*+                                   5 - static procedure wahlpre()
*+                                   2 - static procedure wahlmid()
*+                                   2 - static procedure wahlpost()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ControlOnOff( lOn, nStart, nEnde )

LOCAL j, jMax, cText

   DEFAULT lOn TO .T.
   DEFAULT nStart TO 3
   DEFAULT nEnde TO 0

   IF nEnde = 0
      jMax := LEN( aControls )
   ELSE
      jMax := IF( nEnde > LEN( aControls ), LEN( aControls ), nEnde )
   ENDIF

#IFDEF Use_disable
   FOR j := nStart TO jMax
      cText := aControls[ j ]
      IF lOn = .T.
         DO CASE
            CASE cText = "HBWinFILTER.Combo_Fields"
               HBWinFILTER.Combo_Fields.Enabled := .T.
            CASE cText = "HBWinFILTER.Combo_Pre"
               HBWinFILTER.Combo_Pre.Enabled := .T.
            CASE cText = "HBWinFILTER.Text_Pre"
               HBWinFILTER.Text_Pre.Enabled := .T.
            CASE cText = "HBWinFILTER.Combo_Mid"
               HBWinFILTER.Combo_Mid.Enabled := .T.
            CASE cText = "HBWinFILTER.Text_Mid"
               HBWinFILTER.Text_Mid.Enabled := .T.
            CASE cText = "HBWinFILTER.Combo_Post"
               HBWinFILTER.Combo_Post.Enabled := .T.
            CASE cText = "HBWinFILTER.Text_Post"
               HBWinFILTER.Text_Post.Enabled := .T.
            CASE cText = "HBWinFILTER.Combo_More"
               HBWinFILTER.Combo_More.Enabled := .T.
         ENDCASE
      ELSE
         DO CASE
            CASE cText = "HBWinFILTER.Combo_Fields"
               HBWinFILTER.Combo_Fields.Enabled := .F.
            CASE cText = "HBWinFILTER.Combo_Pre"
               HBWinFILTER.Combo_Pre.Enabled := .F.
            CASE cText = "HBWinFILTER.Text_Pre"
               HBWinFILTER.Text_Pre.Enabled := .F.
            CASE cText = "HBWinFILTER.Combo_Mid"
               HBWinFILTER.Combo_Mid.Enabled := .F.
            CASE cText = "HBWinFILTER.Text_Mid"
               HBWinFILTER.Text_Mid.Enabled := .F.
            CASE cText = "HBWinFILTER.Combo_Post"
               HBWinFILTER.Combo_Post.Enabled := .F.
            CASE cText = "HBWinFILTER.Text_Post"
               HBWinFILTER.Text_Post.Enabled := .F.
            CASE cText = "HBWinFILTER.Combo_More"
               HBWinFILTER.Combo_More.Enabled := .F.
         ENDCASE
      ENDIF
   NEXT
#ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure ShowSay()
*+
*+    Called from ( hbfilter.prg )   1 - static procedure wahlmid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ShowSay()

LOCAL cFeldCombo := HBWinFILTER.Combo_Fields.Item( HBWinFILTER.Combo_Fields.VALUE )
   HBWinFILTER.Text_Mid.Value := cFeldCombo
RETURN

//
//
//

*+ EOF: HBFILTER.PRG
