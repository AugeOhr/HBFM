*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\ASKFORM.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Function ASKFORM()
*+               Static Procedure Start_SHfunc()
*+               Static Procedure GetNewDir()
*+               Static Procedure SetSourceInfo()
*+
*+    Reformatted by Click! 2.05.33 on Sep-18-2020 at  1:09 am
*+
*+--------------------------------------------------------------------

#include "HMG.CH"

MEMVAR nGridFocus
MEMVAR aWin

MEMVAR _HMG_SYSDATA

*+--------------------------------------------------------------------
*+
*+    Function ASKFORM()
*+
*+    Called from ( fmgrid.prg )   7 - procedure dualgrid()
*+                                   4 - static procedure dogridkey1()
*+                                   4 - static procedure dogridkey2()
*+                                   2 - static procedure draghere()
*+
*+--------------------------------------------------------------------
*+
FUNCTION ASKFORM( cAction )

LOCAL i, iMax, nPosi
LOCAL lRet       := .F.
LOCAL cSourceDir := ""
LOCAL cTargetDir := ""
LOCAL aItem      := GetSelectItem()

   IF EMPTY( aItem )
   ELSE
      iMax := LEN( aItem )
      IF iMax = 1
         IF aItem[ 1 ] = ".."
            Msginfo( "can't " + cAction + " '..'" )
            RETURN Nil
         ENDIF
      ENDIF
   ENDIF

   IF cAction = "DELETE"
      // msgInfo("DELETE" )
   ENDIF

   IF nGridFocus = 1
      nPosi := ASCAN( aWin, { | o | o[ 1 ] = "WinLeft" .AND. o[ 2 ] = SP_GridLeft() } )
      IF nPosi > 0
         cSourceDir := aWin[ nPosi ] [ 3 ]
      ENDIF
      nPosi := ASCAN( aWin, { | o | o[ 1 ] = "WinRight" .AND. o[ 2 ] = SP_GridRight() } )
      IF nPosi > 0
         cTargetDir := aWin[ nPosi ] [ 3 ]
      ENDIF

   ELSE
      nPosi := ASCAN( aWin, { | o | o[ 1 ] = "WinRight" .AND. o[ 2 ] = SP_GridRight() } )
      IF nPosi > 0
         cSourceDir := aWin[ nPosi ] [ 3 ]
      ENDIF
      nPosi := ASCAN( aWin, { | o | o[ 1 ] = "WinLeft" .AND. o[ 2 ] = SP_GridLeft() } )
      IF nPosi > 0
         cTargetDir := aWin[ nPosi ] [ 3 ]
      ENDIF
   ENDIF

   DEFINE WINDOW ASKFORM ;
              AT 396, 469 ;
              WIDTH 534 HEIGHT 270 ;
              TITLE cAction ;
              ICON "A1MAIN" ;
              TOPMOST ;
              NOMINIMIZE ;
              NOMAXIMIZE ;
              NOSIZE ;
              ON PAINT Nil ;
              BACKCOLOR SP_nColor1()

      DEFINE TEXTBOX Text_1
         ROW 40
         COL 10
         WIDTH 500
         HEIGHT 30
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         TABSTOP .T.
         VISIBLE .T.
         READONLY .T.
         RIGHTALIGN .F.
         CASECONVERT NONE
         BACKCOLOR SP_nColor5()
         FONTCOLOR SP_nColor6()
         INPUTMASK Nil
         FORMAT Nil
         VALUE cSourceDir
      END TEXTBOX

      DEFINE TEXTBOX Text_2
         ROW 110
         COL 10
         WIDTH 500
         HEIGHT 30
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         TABSTOP .T.
         VISIBLE .T.
         READONLY .F.
         RIGHTALIGN .F.
         CASECONVERT NONE
         BACKCOLOR SP_nColor5()
         FONTCOLOR SP_nColor6()
         INPUTMASK Nil
         FORMAT Nil
         VALUE cTargetDir
      END TEXTBOX

      DEFINE LABEL Label_1
         ROW 10
         COL 10
         WIDTH 60
         HEIGHT 24
         VALUE "Source"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         VISIBLE .T.
         TRANSPARENT .F.
         AUTOSIZE .F.
         BACKCOLOR SP_nColor1()
         FONTCOLOR SP_nColor2()
      END LABEL

      DEFINE LABEL SourceInfo
         ROW 10
         COL 80
         WIDTH 400
         HEIGHT 24
         VALUE ""
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         VISIBLE .T.
         TRANSPARENT .F.
         AUTOSIZE .F.
         BACKCOLOR SP_nColor1()
         FONTCOLOR SP_nColor2()
      END LABEL

      DEFINE LABEL Label_2
         ROW 80
         COL 10
         WIDTH 60
         HEIGHT 24
         VALUE "Target"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         VISIBLE .T.
         TRANSPARENT .F.
         AUTOSIZE .F.
         BACKCOLOR SP_nColor1()
         FONTCOLOR SP_nColor2()
      END LABEL

      DEFINE CHECKBOX lAdjustTime
         PARENT AskForm
         ROW 80
         COL 410
         CAPTION "Adjust &Time"
         VALUE .T.
         WIDTH 100
         HEIGHT 24
         TABSTOP .F.
      END CHECKBOX

      DEFINE CHECKBOX lConfirm
         PARENT AskForm
         ROW 80
         COL 210
         CAPTION "want &Confirm"
         VALUE .F.
         WIDTH 100
         HEIGHT 24
         TABSTOP .F.
      END CHECKBOX

      DEFINE CHECKBOX lPaperbin
         PARENT AskForm
         ROW 80
         COL 210
         CAPTION "to &Paperbin"
         VALUE .T.
         WIDTH 100
         HEIGHT 24
         TABSTOP .F.
      END CHECKBOX

      DEFINE BUTTON Button_Start
         ROW 150
         COL 10
         WIDTH 100
         HEIGHT 64
         ACTION Start_SHfunc( cAction )
         CAPTION "&OK"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         FLAT .F.
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
         MULTILINE .F.
         PICTURE Nil
         PICTALIGNMENT TOP
      END BUTTON

      DEFINE BUTTON Button_Tree
         ROW 150
         COL 210
         WIDTH 100
         HEIGHT 64
         ACTION GetNewDir()
         CAPTION "&Tree"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         FLAT .F.
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
         MULTILINE .F.
         PICTURE Nil
         PICTALIGNMENT TOP
      END BUTTON

      DEFINE BUTTON Button_Abort
         ROW 150
         COL 410
         WIDTH 100
         HEIGHT 64
         ACTION ASKFORM.Release
         CAPTION "&Abort"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         FLAT .F.
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
         MULTILINE .F.
         PICTURE Nil
         PICTALIGNMENT TOP
      END BUTTON

   END WINDOW

   IF cAction = "DELETE"
      ASKFORM.Text_2.hide()
      ASKFORM.Label_2.hide()

      ASKFORM.lConfirm.hide()
      ASKFORM.Button_Tree.hide()

      ASKFORM.lAdjustTime.hide()
   ELSE
      ASKFORM.lPaperbin.hide()
      ASKFORM.lAdjustTime.hide()
   ENDIF

   SetSourceInfo()

   ON KEY ESCAPE OF ASKFORM ACTION ASKFORM.Release
   CENTER WINDOW ASKFORM
   ASKFORM.Button_Start.setfocus()
   ACTIVATE WINDOW ASKFORM

   IF nGridFocus = 1
      Tab_Change_Left()
   ELSE
      Tab_Change_Right()
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Static Procedure Start_SHfunc()
*+
*+    Called from ( askform.prg )   1 - function askform()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Start_SHfunc( cAction )

LOCAL lConfirm    := GetProperty( "ASKFORM", "lConfirm", "Value" )
LOCAL lPaperbin   := GetProperty( "ASKFORM", "lPaperbin", "Value" )
LOCAL lAdjustTime := GetProperty( "ASKFORM", "lAdjustTime", "Value" )

   SP_AdjustTime( lAdjustTime )

   ASKFORM.Hide()
   DoSHfunc( cAction, lConfirm, lPaperbin )
   ASKFORM.Release
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure GetNewDir()
*+
*+    Called from ( askform.prg )   1 - function askform()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE GetNewDir()

LOCAL cTitle           := "search Folder"
LOCAL lNewFolderButton := .T.
LOCAL cDir, nPosi, cInitPath := ""

   IF nGridFocus = 1
      nPosi := ASCAN( aWin, { | o | o[ 1 ] = "WinLeft" .AND. o[ 2 ] = SP_GridLeft() } )
      cInitPath := aWin[ nPosi ] [ 3 ]
   ELSE
      nPosi := ASCAN( aWin, { | o | o[ 1 ] = "WinRight" .AND. o[ 2 ] = SP_GridRight() } )
      cInitPath := aWin[ nPosi ] [ 3 ]
   ENDIF

   cDir := GetFolder( cTitle, TRIM( cInitPath ),, lNewFolderButton )

   IF !EMPTY( cDir )
      ASKFORM.Text_2.VALUE := cDir + "\"
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SetSourceInfo()
*+
*+    Called from ( askform.prg )   1 - function askform()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SetSourceInfo()

LOCAL cText := ""
LOCAL aItem := GetSelectItem()
LOCAL i, iMax, nPosi

   IF !EMPTY( aItem )
      iMax := LEN( aItem )
      FOR i := 1 TO iMax
         cText += aItem[ i ]
         IF i <> iMax
            cText += "*"
         ENDIF
      NEXT

      IF iMax > 1
         ASKFORM.SourceInfo.VALUE := LTRIM( STR( iMax ) ) + " Items"
      ELSE
         ASKFORM.SourceInfo.VALUE := cText
      ENDIF

   ENDIF

RETURN

*+ EOF: ASKFORM.PRG
