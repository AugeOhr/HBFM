*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\HBINPUT.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Function GetInPut()
*+               Static Function GetInputValue()
*+
*+    Reformatted by Click! 2.05.30 on Aug-25-2020 at  5:17 am
*+
*+--------------------------------------------------------------------

#include "HMG.CH"
#include "common.CH"

MEMVAR _HMG_SYSDATA

*+--------------------------------------------------------------------
*+
*+    Function GetInPut()
*+
*+    Called from ( browser.prg )   1 - static procedure doseek()
*+                                   1 - static procedure doscope()
*+                ( fmgrid.prg )   1 - static procedure zipit()
*+                                   1 - static procedure createnewfolder()
*+                                   1 - static procedure slideshow()
*+                ( viewer.prg )   1 - static procedure dummy_text()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetInPut( cLabel, cTitle, xValue, nIcon )

LOCAL cRet  := ""
LOCAL cType

   DEFAULT nIcon TO 1

   IF VALTYPE( xValue ) = "N"
      cType := "NUMERIC"
   ELSE
      cType := "CHARACTER"
   ENDIF

   DEFINE WINDOW GetInPut ;
              AT 0, 50 ;
              WIDTH 330 ;
              HEIGHT 170 ;
              TITLE cTitle ;
              ICON IF( nIcon = 1, "ICOFOLDER", "ICOSEARCH" ) ;
              NOMAXIMIZE ;
              NOMINIMIZE ;
              TOPMOST ;
              BACKCOLOR SP_nColor1()

      DEFINE LABEL Label_1
         ROW 10
         COL 10
         WIDTH 300
         HEIGHT 30
         VALUE cLabel
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         VISIBLE .T.
         BACKCOLOR SP_nColor1()
         FONTCOLOR SP_nColor2()
      END LABEL

      DEFINE TEXTBOX Text_1
         ROW 50
         COL 10
         WIDTH 300
         HEIGHT 30
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         ONENTER GetInputValue( @cRet )
         TABSTOP .T.
         VISIBLE .T.
         READONLY .F.
         DISABLEDBACKCOLOR Nil
         DISABLEDFONTCOLOR Nil
         CASECONVERT NONE
         BACKCOLOR SP_nColor5()                                       // {192,192,192}
         FONTCOLOR SP_nColor6()
         INPUTMASK Nil
         FORMAT Nil
         IF VALTYPE( xValue ) = "N"
            DATATYPE NUMERIC
         ELSE
            DATATYPE CHARACTER
         ENDIF
         VALUE xValue
      END TEXTBOX

      DEFINE BUTTON Button_OK
         ROW 90
         COL 10
         WIDTH 100
         HEIGHT 30
         ACTION GetInputValue( @cRet )
         CAPTION "&OK"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .T.
         VISIBLE .T.
         PICTURE "MYOK"
         PICTALIGNMENT LEFT
      END BUTTON

      DEFINE BUTTON Button_Abort
         ROW 90
         COL 210
         WIDTH 100
         HEIGHT 30
         ACTION GetInPut.Release
         CAPTION "&Abort"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .T.
         VISIBLE .T.
         PICTURE "MYEXIT"
         PICTALIGNMENT LEFT
      END BUTTON

   END WINDOW

   ON KEY ESCAPE OF GetInPut ACTION GetInPut.Release
   CENTER WINDOW GetInPut
   GetInPut.Text_1.setfocus()
   ACTIVATE WINDOW GetInPut

RETURN cRet

*+--------------------------------------------------------------------
*+
*+    Static Function GetInputValue()
*+
*+    Called from ( hbinput.prg )   2 - function getinput()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GetInputValue( cRet )

   cRet := GetInPut.Text_1.Value
   GetInPut.Release
RETURN NIL

//
//
//

*+ EOF: HBINPUT.PRG
