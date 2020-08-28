*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\AUSWAHL.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Function AUSWAHL()
*+               Static Procedure DoTheseFiles()
*+
*+    Reformatted by Click! 2.05.30 on Aug-28-2020 at  1:51 am
*+
*+--------------------------------------------------------------------

#include "HMG.CH"
#include "Directry.ch"

MEMVAR _HMG_SYSDATA

*+--------------------------------------------------------------------
*+
*+    Function AUSWAHL()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure doauswahl()
*+
*+--------------------------------------------------------------------
*+
FUNCTION AUSWAHL( cIn )

LOCAL cTitle

   DO CASE
      CASE cIn = "ADD"
         cTitle := "select files"

      CASE cIn = "SUBTRACT"
         cTitle := "un-select files"
   ENDCASE

   DEFINE WINDOW AUSWAHL ;
              AT 596, 682 ;
              WIDTH 260 HEIGHT 152 ;
              TITLE cTitle ;
              ICON "A1MAIN" ;
              TOPMOST ;
              NOMINIMIZE ;
              NOMAXIMIZE ;
              NOSIZE ;
              BACKCOLOR SP_nColor1()

      DEFINE TEXTBOX SeekFor
         ROW 20
         COL 20
         WIDTH 200
         HEIGHT 24
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONENTER DoTheseFiles()
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
         VALUE SP_GetWahl()
      END TEXTBOX

      DEFINE BUTTON Button_Abort
         ROW 70
         COL 10
         WIDTH 100
         HEIGHT 28
         ACTION AUSWAHL.Release
         CAPTION "Abort"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
         MULTILINE .F.
         PICTURE Nil
         PICTALIGNMENT TOP
      END BUTTON

      DEFINE BUTTON Button_OK
         ROW 70
         COL 130
         WIDTH 100
         HEIGHT 28
         ACTION DoTheseFiles()
         CAPTION "OK"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
         MULTILINE .F.
         PICTURE Nil
         PICTALIGNMENT TOP
      END BUTTON

   END WINDOW

   ON KEY ESCAPE OF AUSWAHL ACTION AUSWAHL.Release
   CENTER WINDOW AUSWAHL
   AUSWAHL.SeekFor.setfocus()
   ACTIVATE WINDOW AUSWAHL

RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoTheseFiles()
*+
*+    Called from ( auswahl.prg )   2 - function auswahl()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoTheseFiles()

   SP_GetWahl( TRIM( GetProperty( "AUSWAHL", "SeekFor", "VALUE" ) ) )
   AUSWAHL.Release
RETURN

*+ EOF: AUSWAHL.PRG
