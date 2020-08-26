*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\FMSETUP.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Procedure FMSETUP()
*+               Procedure Paint_Button()
*+               Procedure PaintDisplay_Fmse()
*+               Static Procedure CheckWinTans()
*+               Procedure SaveRecord_Fmse()
*+               Procedure LoadData_Fmse()
*+               Procedure ColorPicker()
*+               Static Procedure PreResetColor()
*+               Static Procedure SwitchDark()
*+               Static Procedure SwitchColResize()
*+               Static Procedure SwitchUseImage()
*+               Static Procedure SetNewSize()
*+               Static Procedure SetNewPos()
*+               Static Procedure PreColorPick()
*+
*+       Tables: USE (cFile) NEW ALIAS "FMSETUP" EXCLUSIVE
*+
*+    Reformatted by Click! 2.05.30 on Aug-25-2020 at  5:16 am
*+
*+--------------------------------------------------------------------

#include <hmg.ch>

STATIC aColorBG
STATIC aColorFG
STATIC aSLEBG
STATIC aSLEFG
STATIC lRunning := .F.

MEMVAR _HMG_SYSDATA

*+--------------------------------------------------------------------
*+
*+    Procedure FMSETUP()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE FMSETUP()

LOCAL cAppData := GETENV( "APPDATA" ) + "\HMG"
LOCAL cFile    := cAppData + "\FMSETUP.DBF"

   IF lRunning = .T.
      DoMethod( "Win_Fmse", "setfocus" )
      RETURN
   ENDIF
   lRunning := .T.

   aColorBG := SP_nColor1()
   aColorFG := SP_nColor2()

   aSLEBG := SP_nColor5()
   aSLEFG := SP_nColor6()

   USE (cFile) NEW ALIAS "FMSETUP" EXCLUSIVE

   DEFINE WINDOW Win_Fmse ;
              AT 0, 0 ;
              WIDTH 940 ;
              HEIGHT 500 ;
              BACKCOLOR SP_nColor1() ;
              NOMINIMIZE ;
              NOMAXIMIZE ;
              TITLE 'Table Fmsetup' ;
              ICON 'ICOCONFIG32' ;
              TOPMOST ;
              ON INIT LoadData_Fmse()

      ON KEY ESCAPE ACTION Win_Fmse.Release

      // DEFINE STATUSBAR FONT 'Arial' SIZE SP_nFontlarge()
      //    STATUSITEM 'Table Fmsetup'
      //    KEYBOARD WIDTH 80
      //    DATE WIDTH 100
      //    CLOCK WIDTH 100
      // END STATUSBAR

      DEFINE BUTTON Button_Save
         PARENT Win_Fmse
         row 300 + 40
         COL 760 + 20
         WIDTH 120
         HEIGHT 100
         ACTION SaveRecord_Fmse()
         CAPTION "&Save"
         PICTURE "MYOKGREEN"
         PICTALIGNMENT TOP
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontlarge()
         TABSTOP .F.
         VISIBLE .T.
         TOOLTIP "save Setup"
      END BUTTON

      /*********************
      * DEFINE TOOLBAR ToolBar_01  BUTTONSIZE 60,40 IMAGESIZE 32,32 FLAT BORDER
      *   BUTTON SAVE ;
      *     CAPTION '&Save' ;
      *     PICTURE 'MYOKGREEN' ;
      *     ACTION SaveRecord_Fmse()
      *
      *   BUTTON EXIT ;
      *     CAPTION 'E&xit' ;
      *     PICTURE 'MYEXIT' ;
      *     ACTION Win_Fmse.Release
      * END TOOLBAR
      *********************/

      PaintDisplay_Fmse()
      Paint_Button()

   END WINDOW

   CENTER WINDOW Win_Fmse
   ACTIVATE WINDOW Win_Fmse

   IF USED()
      CLOSE FMSETUP
   ENDIF

   lRunning := .F.

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure Paint_Button()
*+
*+    Called from ( fmsetup.prg )   1 - procedure fmsetup()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE Paint_Button()

   @ 030, 230 BUTTON Button_40 CAPTION "Button  BG" WIDTH 078 HEIGHT 24 FONT SP_cFontName() SIZE SP_nFontsmall() ACTION ColorPicker( 40 ) ToolTip "Button Backgound Color"              
   @ 060, 230 BUTTON Button_38 CAPTION "Edit    BG" WIDTH 078 HEIGHT 24 FONT SP_cFontName() SIZE SP_nFontsmall() ACTION ColorPicker( 38 ) ToolTip "Edit Backgound Color"                
   @ 090, 230 BUTTON Button_34 CAPTION "Main    BG" WIDTH 078 HEIGHT 24 FONT SP_cFontName() SIZE SP_nFontsmall() ACTION ColorPicker( 34 ) ToolTip "Form Backgound Color"                
   @ 120, 230 BUTTON Button_44 CAPTION "HiLite  BG" WIDTH 078 HEIGHT 24 FONT SP_cFontName() SIZE SP_nFontsmall() ACTION ColorPicker( 44 ) ToolTip "HiLite Backgound Color"              
   @ 150, 230 BUTTON Button_46 CAPTION "Disable BG" WIDTH 078 HEIGHT 24 FONT SP_cFontName() SIZE SP_nFontsmall() ACTION ColorPicker( 46 ) ToolTip "Disable Backgound Color"             
   @ 180, 230 BUTTON Button_42 CAPTION "GRID    BG" WIDTH 078 HEIGHT 24 FONT SP_cFontName() SIZE SP_nFontsmall() ACTION ColorPicker( 42 ) ToolTip "GRID Backgound Color"                
   @ 210, 230 BUTTON Button_36 CAPTION "GRID hi BG" WIDTH 078 HEIGHT 24 FONT SP_cFontName() SIZE SP_nFontsmall() ACTION ColorPicker( 36 ) ToolTip "GRID HiLite Backgound Color"         

   @ 030, 420 BUTTON Button_41 CAPTION "Button  FG" WIDTH 078 HEIGHT 24 FONT SP_cFontName() SIZE SP_nFontsmall() ACTION ColorPicker( 41 ) ToolTip "Button Font Color"              
   @ 060, 420 BUTTON Button_39 CAPTION "Edit    FG" WIDTH 078 HEIGHT 24 FONT SP_cFontName() SIZE SP_nFontsmall() ACTION ColorPicker( 39 ) ToolTip "Edit Font Color"                
   @ 090, 420 BUTTON Button_35 CAPTION "Main    FG" WIDTH 078 HEIGHT 24 FONT SP_cFontName() SIZE SP_nFontsmall() ACTION ColorPicker( 35 ) ToolTip "Form Font Color"                
   @ 120, 420 BUTTON Button_45 CAPTION "HiLite  FG" WIDTH 078 HEIGHT 24 FONT SP_cFontName() SIZE SP_nFontsmall() ACTION ColorPicker( 45 ) ToolTip "HiLite Font Color"              
   @ 150, 420 BUTTON Button_47 CAPTION "Disable FG" WIDTH 078 HEIGHT 24 FONT SP_cFontName() SIZE SP_nFontsmall() ACTION ColorPicker( 47 ) ToolTip "Disable Font Color"             
   @ 180, 420 BUTTON Button_43 CAPTION "GRID    FG" WIDTH 078 HEIGHT 24 FONT SP_cFontName() SIZE SP_nFontsmall() ACTION ColorPicker( 43 ) ToolTip "GRID Font Color"                
   @ 210, 420 BUTTON Button_37 CAPTION "GRID hi FG" WIDTH 078 HEIGHT 24 FONT SP_cFontName() SIZE SP_nFontsmall() ACTION ColorPicker( 37 ) ToolTip "GRID HiLite Font Color"         

   IF Fmsetup->DARKMODE = .T.
      @ 240, 430 LABEL Label_Dark VALUE "&Dark-Mode" WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
      @ 304, 620 LABEL Label_Colr VALUE "Col Resi&ze" WIDTH 070 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
      @ 334, 620 LABEL Label_Icon VALUE "use &Image" WIDTH 070 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   ENDIF

   @ 240, 340 BUTTON PbResetColor CAPTION "&reset" WIDTH 070 HEIGHT 24 FONT SP_cFontName() SIZE SP_nFontsmall() ACTION PreResetColor() ToolTip "reset Color Thema"

   @ 090, 060 BUTTON PbSetPos CAPTION "Set Pos" WIDTH 050 HEIGHT 24 FONT SP_cFontName() SIZE SP_nFontsmall() ACTION SetNewPos() ToolTip "Set Position"
   @ 090, 160 BUTTON PbSetSize CAPTION "Set Size" WIDTH 050 HEIGHT 24 FONT SP_cFontName() SIZE SP_nFontsmall() ACTION SetNewSize() ToolTip "Set Size"

   @ 240, 060 BUTTON PbColorPick CAPTION "&Font" WIDTH 050 HEIGHT 24 FONT SP_cFontName() SIZE SP_nFontsmall() ACTION PreColorPick() ToolTip "GRID HiLite Backgound Color"

   @ 290, 010 FRAME Frame_01 WIDTH 596 HEIGHT 164
   @ 010, 610 FRAME Frame_02 WIDTH 300 HEIGHT 270
   @ 010, 225 FRAME Frame_03 WIDTH 380 HEIGHT 270
   @ 010, 010 FRAME Frame_04 WIDTH 210 HEIGHT 270
   @ 010, 010 FRAME Frame_05 WIDTH 210 HEIGHT 120

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure PaintDisplay_Fmse()
*+
*+    Called from ( fmsetup.prg )   1 - procedure fmsetup()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE PaintDisplay_Fmse()

   @ 030, 20 LABEL Label_01 VALUE "XPOS" WIDTH 040 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 060, 20 LABEL Label_02 VALUE "YPOS" WIDTH 040 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""

   @ 030, 120 LABEL Label_03 VALUE "XSIZE" WIDTH 040 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 060, 120 LABEL Label_04 VALUE "YSIZE" WIDTH 040 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""

   //     @ 120, 20 LABEL Label_18 VALUE "Font Nname" WIDTH 120 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 150, 120 LABEL Label_21 VALUE "Size" WIDTH 50 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 180, 120 LABEL Label_19 VALUE "large" WIDTH 50 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 210, 120 LABEL Label_20 VALUE "small" WIDTH 50 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""

   @ 270 + 30, 20 LABEL Label_13 VALUE "SKINPATH" WIDTH 120 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 300 + 30, 20 LABEL Label_14 VALUE "LWLPATH" WIDTH 120 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 330 + 30, 20 LABEL Label_15 VALUE "LWRPATH" WIDTH 120 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 360 + 30, 20 LABEL Label_16 VALUE "EDITTEXT" WIDTH 120 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 390 + 30, 20 LABEL Label_17 VALUE "EDITDBF" WIDTH 120 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""

   @ 030, 620 LABEL Label_22 VALUE "LWLCOL1" WIDTH 070 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 060, 620 LABEL Label_23 VALUE "LWLCOL2" WIDTH 070 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 090, 620 LABEL Label_24 VALUE "LWLCOL3" WIDTH 070 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 120, 620 LABEL Label_25 VALUE "LWLCOL4" WIDTH 070 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 150, 620 LABEL Label_26 VALUE "LWLCOL5" WIDTH 070 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 180, 620 LABEL Label_27 VALUE "LWLCOL6" WIDTH 070 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""

   @ 030, 770 LABEL Label_28 VALUE "LWRCOL1" WIDTH 070 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 060, 770 LABEL Label_29 VALUE "LWRCOL2" WIDTH 070 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 090, 770 LABEL Label_30 VALUE "LWRCOL3" WIDTH 070 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 120, 770 LABEL Label_31 VALUE "LWRCOL4" WIDTH 070 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 150, 770 LABEL Label_32 VALUE "LWRCOL5" WIDTH 070 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 180, 770 LABEL Label_33 VALUE "LWRCOL6" WIDTH 070 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""

   //    @ 030, 230 LABEL Label_40 VALUE "COLOR7"  WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG  FONTCOLOR aColorFG  FONT SP_cFontName() SIZE SP_nFontsmall()  ToolTip ""
   //    @ 060, 230 LABEL Label_38 VALUE "COLOR5"  WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG  FONTCOLOR aColorFG  FONT SP_cFontName() SIZE SP_nFontsmall()  ToolTip ""
   //    @ 090, 230 LABEL Label_34 VALUE "COLOR1"  WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG  FONTCOLOR aColorFG  FONT SP_cFontName() SIZE SP_nFontsmall()  ToolTip ""
   //    @ 120, 230 LABEL Label_44 VALUE "COLOR11" WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG  FONTCOLOR aColorFG  FONT SP_cFontName() SIZE SP_nFontsmall()  ToolTip ""
   //    @ 150, 230 LABEL Label_46 VALUE "COLOR13" WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG  FONTCOLOR aColorFG  FONT SP_cFontName() SIZE SP_nFontsmall()  ToolTip ""
   //    @ 180, 230 LABEL Label_42 VALUE "COLOR9"  WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG  FONTCOLOR aColorFG  FONT SP_cFontName() SIZE SP_nFontsmall()  ToolTip ""
   //    @ 210, 230 LABEL Label_36 VALUE "COLOR3"  WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG  FONTCOLOR aColorFG  FONT SP_cFontName() SIZE SP_nFontsmall()  ToolTip ""

   //    @ 030, 420 LABEL Label_41 VALUE "COLOR8"  WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG  FONTCOLOR aColorFG  FONT SP_cFontName() SIZE SP_nFontsmall()  ToolTip ""
   //    @ 060, 420 LABEL Label_39 VALUE "COLOR6"  WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG  FONTCOLOR aColorFG  FONT SP_cFontName() SIZE SP_nFontsmall()  ToolTip ""
   //    @ 090, 420 LABEL Label_35 VALUE "COLOR2"  WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG  FONTCOLOR aColorFG  FONT SP_cFontName() SIZE SP_nFontsmall()  ToolTip ""
   //    @ 120, 420 LABEL Label_45 VALUE "COLOR12" WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG  FONTCOLOR aColorFG  FONT SP_cFontName() SIZE SP_nFontsmall()  ToolTip ""
   //    @ 150, 420 LABEL Label_47 VALUE "COLOR14" WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG  FONTCOLOR aColorFG  FONT SP_cFontName() SIZE SP_nFontsmall()  ToolTip ""
   //    @ 180, 420 LABEL Label_43 VALUE "COLOR10" WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG  FONTCOLOR aColorFG  FONT SP_cFontName() SIZE SP_nFontsmall()  ToolTip ""
   //    @ 210, 420 LABEL Label_37 VALUE "COLOR4"  WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG  FONTCOLOR aColorFG  FONT SP_cFontName() SIZE SP_nFontsmall()  ToolTip ""

   @ 210, 620 LABEL Label_07 VALUE "LWLSORT" WIDTH 070 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 210, 770 LABEL Label_08 VALUE "LWRSORT" WIDTH 070 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""

   @ 240, 620 LABEL Label_09 VALUE "LWLVIEW" WIDTH 070 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 240, 770 LABEL Label_10 VALUE "LWRVIEW" WIDTH 070 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""

   //    @ 300, 610 LABEL Label_48 VALUE "LASTLEFT" WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   //    @ 330, 610 LABEL Label_49 VALUE "LASTRIGHT" WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   //    @ 360, 610 LABEL Label_5 VALUE "LWNO" WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   //    @ 360, 760 LABEL Label_6 VALUE "PROZ" WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   //    @ 390, 610 LABEL Label_11 VALUE "THUMBHIGH" WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   //    @ 390, 760 LABEL Label_12 VALUE "THUMBWIDE" WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""

   @ 030, 314 LABEL Label_Color01 VALUE " " WIDTH 020 HEIGHT 24 BACKCOLOR SP_nCOLOR7() FONTCOLOR aColorFG
   @ 060, 314 LABEL Label_Color02 VALUE " " WIDTH 020 HEIGHT 24 BACKCOLOR SP_nCOLOR5() FONTCOLOR aColorFG
   @ 090, 314 LABEL Label_Color03 VALUE " " WIDTH 020 HEIGHT 24 BACKCOLOR SP_nCOLOR1() FONTCOLOR aColorFG
   @ 120, 314 LABEL Label_Color04 VALUE " " WIDTH 020 HEIGHT 24 BACKCOLOR SP_nCOLOR11() FONTCOLOR aColorFG
   @ 150, 314 LABEL Label_Color05 VALUE " " WIDTH 020 HEIGHT 24 BACKCOLOR SP_nCOLOR13() FONTCOLOR aColorFG
   @ 180, 314 LABEL Label_Color06 VALUE " " WIDTH 020 HEIGHT 24 BACKCOLOR SP_nCOLOR9() FONTCOLOR aColorFG
   @ 210, 314 LABEL Label_Color07 VALUE " " WIDTH 020 HEIGHT 24 BACKCOLOR SP_nCOLOR3() FONTCOLOR aColorFG
   @ 030, 504 LABEL Label_Color08 VALUE " " WIDTH 020 HEIGHT 24 BACKCOLOR SP_nCOLOR8() FONTCOLOR aColorFG
   @ 060, 504 LABEL Label_Color09 VALUE " " WIDTH 020 HEIGHT 24 BACKCOLOR SP_nCOLOR6() FONTCOLOR aColorFG
   @ 090, 504 LABEL Label_Color10 VALUE " " WIDTH 020 HEIGHT 24 BACKCOLOR SP_nCOLOR2() FONTCOLOR aColorFG
   @ 120, 504 LABEL Label_Color11 VALUE " " WIDTH 020 HEIGHT 24 BACKCOLOR SP_nCOLOR12() FONTCOLOR aColorFG
   @ 150, 504 LABEL Label_Color12 VALUE " " WIDTH 020 HEIGHT 24 BACKCOLOR SP_nCOLOR14() FONTCOLOR aColorFG
   @ 180, 504 LABEL Label_Color13 VALUE " " WIDTH 020 HEIGHT 24 BACKCOLOR SP_nCOLOR10() FONTCOLOR aColorFG
   @ 210, 504 LABEL Label_Color14 VALUE " " WIDTH 020 HEIGHT 24 BACKCOLOR SP_nCOLOR4() FONTCOLOR aColorFG

   // ******************************************

   @ 030, 060 TEXTBOX TextBox_01 WIDTH 50 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '9999'
   @ 060, 060 TEXTBOX TextBox_02 WIDTH 50 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '9999'

   @ 030, 160 TEXTBOX TextBox_03 WIDTH 50 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '9999'
   @ 060, 160 TEXTBOX TextBox_04 WIDTH 50 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '9999'

   @ 240, 120 TEXTBOX TextBox_18 WIDTH 090 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" INPUTMASK '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
   @ 150, 160 TEXTBOX TextBox_21 WIDTH 50 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '99'
   @ 180, 160 TEXTBOX TextBox_19 WIDTH 50 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '99'
   @ 210, 160 TEXTBOX TextBox_20 WIDTH 50 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '99'

   @ 270 + 30, 100 TEXTBOX TextBox_13 WIDTH 500 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 300 + 30, 100 TEXTBOX TextBox_14 WIDTH 500 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 330 + 30, 100 TEXTBOX TextBox_15 WIDTH 500 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 360 + 30, 100 TEXTBOX TextBox_16 WIDTH 500 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""
   @ 390 + 30, 100 TEXTBOX TextBox_17 WIDTH 500 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip ""

   @ 030, 690 TEXTBOX TextBox_22 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '9999'
   @ 060, 690 TEXTBOX TextBox_23 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '9999'
   @ 090, 690 TEXTBOX TextBox_24 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '9999'
   @ 120, 690 TEXTBOX TextBox_25 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '9999'
   @ 150, 690 TEXTBOX TextBox_26 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '9999'
   @ 180, 690 TEXTBOX TextBox_27 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '9999'

   @ 030, 840 TEXTBOX TextBox_28 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '9999'
   @ 060, 840 TEXTBOX TextBox_29 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '9999'
   @ 090, 840 TEXTBOX TextBox_30 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '9999'
   @ 120, 840 TEXTBOX TextBox_31 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '9999'
   @ 150, 840 TEXTBOX TextBox_32 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '9999'
   @ 180, 840 TEXTBOX TextBox_33 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '9999'

   @ 030, 340 TEXTBOX TextBox_40 WIDTH 070 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '999999999'
   @ 060, 340 TEXTBOX TextBox_38 WIDTH 070 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '999999999'
   @ 090, 340 TEXTBOX TextBox_34 WIDTH 070 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '999999999'
   @ 120, 340 TEXTBOX TextBox_44 WIDTH 070 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '999999999'
   @ 150, 340 TEXTBOX TextBox_46 WIDTH 070 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '999999999'
   @ 180, 340 TEXTBOX TextBox_42 WIDTH 070 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '999999999'
   @ 210, 340 TEXTBOX TextBox_36 WIDTH 070 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '999999999'

   @ 030, 530 TEXTBOX TextBox_41 WIDTH 070 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '999999999'
   @ 060, 530 TEXTBOX TextBox_39 WIDTH 070 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '999999999'
   @ 090, 530 TEXTBOX TextBox_35 WIDTH 070 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '999999999'
   @ 120, 530 TEXTBOX TextBox_45 WIDTH 070 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '999999999'
   @ 150, 530 TEXTBOX TextBox_47 WIDTH 070 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '999999999'
   @ 180, 530 TEXTBOX TextBox_43 WIDTH 070 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '999999999'
   @ 210, 530 TEXTBOX TextBox_37 WIDTH 070 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '999999999'
   @ 240, 510 CHECKBOX CheckBox_01 CAPTION "&Dark-Mode" WIDTH 090 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "use Darkmode Color" ON CHANGE SwitchDark()

   @ 210, 690 TEXTBOX TextBox_07 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '9'
   @ 210, 840 TEXTBOX TextBox_08 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '9'

   @ 240, 690 TEXTBOX TextBox_09 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '9'
   @ 240, 840 TEXTBOX TextBox_10 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '9'

   //    @ 300, 690 TEXTBOX TextBox_48 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '99'
   //    @ 330, 690 TEXTBOX TextBox_49 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '99'
   //    @ 360, 690 TEXTBOX TextBox_5 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '9'
   //    @ 360, 840 TEXTBOX TextBox_6 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '99,999.99'
   //    @ 390, 690 TEXTBOX TextBox_11 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '999'
   //    @ 390, 840 TEXTBOX TextBox_12 WIDTH 60 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "" NUMERIC INPUTMASK '999'

   @ 300, 690 CHECKBOX CheckBox_02 CAPTION "Col Resi&ze" WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "automatic resize Column" ON CHANGE SwitchColResize()
   @ 330, 690 CHECKBOX CheckBox_03 CAPTION "use &Image" WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall() ToolTip "use System-Icon" ON CHANGE SwitchUseImage()

   //    @ 330, 500 LABEL Label_51 VALUE "TABLEFT"   WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG  FONTCOLOR aColorFG  FONT SP_cFontName() SIZE SP_nFontsmall()  ToolTip ""
   //    @ 330, 500 LABEL Label_52 VALUE "TABRIGHT"  WIDTH 080 HEIGHT 24 BACKCOLOR aColorBG  FONTCOLOR aColorFG  FONT SP_cFontName() SIZE SP_nFontsmall()  ToolTip ""
   //    @ 330, 600 EDITBOX EditBox_01  WIDTH 080 HEIGHT 24 BACKCOLOR aSLEBG  FONTCOLOR aSLEFG  FONT SP_cFontName() SIZE SP_nFontsmall()  ToolTip ""
   //    @ 330, 600 EDITBOX EditBox_02 WIDTH 080 HEIGHT 24 BACKCOLOR aSLEBG  FONTCOLOR aSLEFG  FONT SP_cFontName() SIZE SP_nFontsmall()  ToolTip ""

   @ 304, 770 LABEL Label_WT VALUE "&Transparency" WIDTH 90 HEIGHT 24 BACKCOLOR aColorBG FONTCOLOR aColorFG FONT SP_cFontName() SIZE SP_nFontsmall()
   @ 304, 860 TEXTBOX TextBox_WT WIDTH 40 HEIGHT 24 BACKCOLOR aSLEBG FONTCOLOR aSLEFG FONT SP_cFontName() SIZE SP_nFontsmall() NUMERIC INPUTMASK "999" ON ENTER CheckWinTans()

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure CheckWinTans()
*+
*+    Called from ( fmsetup.prg )   1 - procedure paintdisplay_fmse()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE CheckWinTans()

LOCAL nValue := Win_Fmse.TextBox_WT.Value

   IF nValue < 1 .OR. nValue > 255
      MsgInfo( "Error Range : 1-255" )
      Win_Fmse.TextBox_WT.Value := 255
      Win_Fmse.TextBox_WT.setfocus
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure SaveRecord_Fmse()
*+
*+    Called from ( fmsetup.prg )   1 - procedure fmsetup()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE SaveRecord_Fmse

   IF RLOCK()
      Fmsetup->XPOS := Win_Fmse.TextBox_01.Value
      Fmsetup->YPOS := Win_Fmse.TextBox_02.Value
      Fmsetup->XSIZE := Win_Fmse.TextBox_03.Value
      Fmsetup->YSIZE := Win_Fmse.TextBox_04.Value
      //       Fmsetup->LWNO := Win_Fmse.TextBox_5.Value
      //       Fmsetup->PROZ := Win_Fmse.TextBox_6.Value
      Fmsetup->LWLSORT := Win_Fmse.TextBox_07.Value
      Fmsetup->LWRSORT := Win_Fmse.TextBox_08.Value
      Fmsetup->LWLVIEW := Win_Fmse.TextBox_09.Value
      Fmsetup->LWRVIEW := Win_Fmse.TextBox_10.Value
      //       Fmsetup->THUMBHIGH := Win_Fmse.TextBox_11.Value
      //       Fmsetup->THUMBWIDE := Win_Fmse.TextBox_12.Value
      Fmsetup->SKINPATH := Win_Fmse.TextBox_13.Value
      Fmsetup->LWLPATH := Win_Fmse.TextBox_14.Value
      Fmsetup->LWRPATH := Win_Fmse.TextBox_15.Value
      Fmsetup->EDITTEXT := Win_Fmse.TextBox_16.Value
      Fmsetup->EDITDBF := Win_Fmse.TextBox_17.Value
      Fmsetup->FONTNAME := Win_Fmse.TextBox_18.Value
      Fmsetup->FONTHEIGH := Win_Fmse.TextBox_19.Value
      Fmsetup->FONTWIDTH := Win_Fmse.TextBox_20.Value
      Fmsetup->FONTSIZE := Win_Fmse.TextBox_21.Value
      Fmsetup->LWLCOL1 := Win_Fmse.TextBox_22.Value
      Fmsetup->LWLCOL2 := Win_Fmse.TextBox_23.Value
      Fmsetup->LWLCOL3 := Win_Fmse.TextBox_24.Value
      Fmsetup->LWLCOL4 := Win_Fmse.TextBox_25.Value
      Fmsetup->LWLCOL5 := Win_Fmse.TextBox_26.Value
      Fmsetup->LWLCOL6 := Win_Fmse.TextBox_27.Value
      Fmsetup->LWRCOL1 := Win_Fmse.TextBox_28.Value
      Fmsetup->LWRCOL2 := Win_Fmse.TextBox_29.Value
      Fmsetup->LWRCOL3 := Win_Fmse.TextBox_30.Value
      Fmsetup->LWRCOL4 := Win_Fmse.TextBox_31.Value
      Fmsetup->LWRCOL5 := Win_Fmse.TextBox_32.Value
      Fmsetup->LWRCOL6 := Win_Fmse.TextBox_33.Value

      Fmsetup->COLOR1 := Win_Fmse.TextBox_34.Value
      Fmsetup->COLOR2 := Win_Fmse.TextBox_35.Value
      Fmsetup->COLOR3 := Win_Fmse.TextBox_36.Value
      Fmsetup->COLOR4 := Win_Fmse.TextBox_37.Value
      Fmsetup->COLOR5 := Win_Fmse.TextBox_38.Value
      Fmsetup->COLOR6 := Win_Fmse.TextBox_39.Value
      Fmsetup->COLOR7 := Win_Fmse.TextBox_40.Value
      Fmsetup->COLOR8 := Win_Fmse.TextBox_41.Value
      Fmsetup->COLOR9 := Win_Fmse.TextBox_42.Value
      Fmsetup->COLOR10 := Win_Fmse.TextBox_43.Value
      Fmsetup->COLOR11 := Win_Fmse.TextBox_44.Value
      Fmsetup->COLOR12 := Win_Fmse.TextBox_45.Value
      Fmsetup->COLOR13 := Win_Fmse.TextBox_46.Value
      Fmsetup->COLOR14 := Win_Fmse.TextBox_47.Value
      Fmsetup->DARKMODE := Win_Fmse.CheckBox_01.Value
      Fmsetup->COLRESIZE := Win_Fmse.CheckBox_02.Value

      Fmsetup->USEIMAGE := Win_Fmse.CheckBox_03.Value

      //    Fmsetup->LASTLEFT := Win_Fmse.TextBox_48.Value
      //    Fmsetup->LASTRIGHT := Win_Fmse.TextBox_49.Value
      //    Fmsetup->TABLEFT       := Win_Fmse.EditBox_01.Value
      //    Fmsetup->TABRIGHT      := Win_Fmse.EditBox_02.Value

      Fmsetup->WINTANS := Win_Fmse.TextBox_WT.Value

      DBCOMMIT()
      UNLOCK
      // Win_Fmse.StatusBar.Item( 1 ) := 'Save Record'

      SP_nWinTans( Win_Fmse.TextBox_WT.Value )

      Win_Fmse.Release
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure LoadData_Fmse()
*+
*+    Called from ( fmsetup.prg )   1 - procedure fmsetup()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE LoadData_Fmse()

   Win_Fmse.TextBox_01.Value := Fmsetup->XPOS
   Win_Fmse.TextBox_02.Value := Fmsetup->YPOS
   Win_Fmse.TextBox_03.Value := Fmsetup->XSIZE
   Win_Fmse.TextBox_04.Value := Fmsetup->YSIZE
   //    Win_Fmse.TextBox_5.Value := Fmsetup->LWNO
   //    Win_Fmse.TextBox_6.Value := Fmsetup->PROZ
   Win_Fmse.TextBox_07.Value := Fmsetup->LWLSORT
   Win_Fmse.TextBox_08.Value := Fmsetup->LWRSORT
   Win_Fmse.TextBox_09.Value := Fmsetup->LWLVIEW
   Win_Fmse.TextBox_10.Value := Fmsetup->LWRVIEW
   //    Win_Fmse.TextBox_11.Value := Fmsetup->THUMBHIGH
   //    Win_Fmse.TextBox_12.Value := Fmsetup->THUMBWIDE
   Win_Fmse.TextBox_13.Value := Fmsetup->SKINPATH
   Win_Fmse.TextBox_14.Value := Fmsetup->LWLPATH
   Win_Fmse.TextBox_15.Value := Fmsetup->LWRPATH
   Win_Fmse.TextBox_16.Value := Fmsetup->EDITTEXT
   Win_Fmse.TextBox_17.Value := Fmsetup->EDITDBF
   Win_Fmse.TextBox_18.Value := Fmsetup->FONTNAME
   Win_Fmse.TextBox_19.Value := Fmsetup->FONTHEIGH
   Win_Fmse.TextBox_20.Value := Fmsetup->FONTWIDTH
   Win_Fmse.TextBox_21.Value := Fmsetup->FONTSIZE
   Win_Fmse.TextBox_22.Value := Fmsetup->LWLCOL1
   Win_Fmse.TextBox_23.Value := Fmsetup->LWLCOL2
   Win_Fmse.TextBox_24.Value := Fmsetup->LWLCOL3
   Win_Fmse.TextBox_25.Value := Fmsetup->LWLCOL4
   Win_Fmse.TextBox_26.Value := Fmsetup->LWLCOL5
   Win_Fmse.TextBox_27.Value := Fmsetup->LWLCOL6
   Win_Fmse.TextBox_28.Value := Fmsetup->LWRCOL1
   Win_Fmse.TextBox_29.Value := Fmsetup->LWRCOL2
   Win_Fmse.TextBox_30.Value := Fmsetup->LWRCOL3
   Win_Fmse.TextBox_31.Value := Fmsetup->LWRCOL4
   Win_Fmse.TextBox_32.Value := Fmsetup->LWRCOL5
   Win_Fmse.TextBox_33.Value := Fmsetup->LWRCOL6

   Win_Fmse.TextBox_34.Value := Fmsetup->COLOR1
   Win_Fmse.TextBox_35.Value := Fmsetup->COLOR2
   Win_Fmse.TextBox_36.Value := Fmsetup->COLOR3
   Win_Fmse.TextBox_37.Value := Fmsetup->COLOR4
   Win_Fmse.TextBox_38.Value := Fmsetup->COLOR5
   Win_Fmse.TextBox_39.Value := Fmsetup->COLOR6
   Win_Fmse.TextBox_40.Value := Fmsetup->COLOR7
   Win_Fmse.TextBox_41.Value := Fmsetup->COLOR8
   Win_Fmse.TextBox_42.Value := Fmsetup->COLOR9
   Win_Fmse.TextBox_43.Value := Fmsetup->COLOR10
   Win_Fmse.TextBox_44.Value := Fmsetup->COLOR11
   Win_Fmse.TextBox_45.Value := Fmsetup->COLOR12
   Win_Fmse.TextBox_46.Value := Fmsetup->COLOR13
   Win_Fmse.TextBox_47.Value := Fmsetup->COLOR14
   Win_Fmse.CheckBox_01.Value := Fmsetup->DARKMODE
   Win_Fmse.CheckBox_02.Value := Fmsetup->COLRESIZE
   Win_Fmse.CheckBox_03.Value := Fmsetup->USEIMAGE

   //    Win_Fmse.TextBox_48.Value := Fmsetup->LASTLEFT
   //    Win_Fmse.TextBox_49.Value := Fmsetup->LASTRIGHT
   //    Win_Fmse.EditBox_01.Value := Fmsetup->TABLEFT
   //    Win_Fmse.EditBox_02.Value := Fmsetup->TABRIGHT

   Win_Fmse.TextBox_WT.Value := Fmsetup->WINTANS

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure ColorPicker()
*+
*+    Called from ( fmsetup.prg )  14 - procedure paint_button()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE ColorPicker( nNo )

LOCAL aColor, nColor

   DO CASE
      CASE nNo = 40
         nColor := Win_Fmse.TextBox_40.Value
      CASE nNo = 38
         nColor := Win_Fmse.TextBox_38.Value
      CASE nNo = 34
         nColor := Win_Fmse.TextBox_34.Value
      CASE nNo = 44
         nColor := Win_Fmse.TextBox_44.Value
      CASE nNo = 46
         nColor := Win_Fmse.TextBox_46.Value
      CASE nNo = 42
         nColor := Win_Fmse.TextBox_42.Value
      CASE nNo = 36
         nColor := Win_Fmse.TextBox_36.Value

      CASE nNo = 41
         nColor := Win_Fmse.TextBox_41.Value
      CASE nNo = 39
         nColor := Win_Fmse.TextBox_39.Value
      CASE nNo = 35
         nColor := Win_Fmse.TextBox_35.Value
      CASE nNo = 45
         nColor := Win_Fmse.TextBox_45.Value
      CASE nNo = 47
         nColor := Win_Fmse.TextBox_47.Value
      CASE nNo = 43
         nColor := Win_Fmse.TextBox_43.Value
      CASE nNo = 37
         nColor := Win_Fmse.TextBox_37.Value
   ENDCASE

   aColor := { GetRed( nColor ), GetGreen( nColor ), GetBlue( nColor ) }
   ALTD()
   aColor := GetColor( aColor )

   IF !EMPTY( aColor[ 1 ] )
      nColor := RGB( aColor[ 1 ], aColor[ 2 ], aColor[ 3 ] )
      IF !EMPTY( nColor )
         DO CASE
            CASE nNo = 40
               Win_Fmse.TextBox_40.Value := nColor
               SP_nCOLOR7( nColor )
               Win_Fmse.Label_Color01.BackColor := SP_nCOLOR7()
            CASE nNo = 38
               Win_Fmse.TextBox_38.Value := nColor
               SP_nCOLOR5( nColor )
               Win_Fmse.Label_Color02.BackColor := SP_nCOLOR5()
            CASE nNo = 34
               Win_Fmse.TextBox_34.Value := nColor
               SP_nCOLOR1( nColor )
               Win_Fmse.Label_Color03.BackColor := SP_nCOLOR1()
            CASE nNo = 44
               Win_Fmse.TextBox_44.Value := nColor
               SP_nCOLOR11( nColor )
               Win_Fmse.Label_Color04.BackColor := SP_nCOLOR11()
            CASE nNo = 46
               Win_Fmse.TextBox_46.Value := nColor
               SP_nCOLOR13( nColor )
               Win_Fmse.Label_Color05.BackColor := SP_nCOLOR13()
            CASE nNo = 42
               Win_Fmse.TextBox_42.Value := nColor
               SP_nCOLOR9( nColor )
               Win_Fmse.Label_Color06.BackColor := SP_nCOLOR9()
            CASE nNo = 36
               Win_Fmse.TextBox_36.Value := nColor
               SP_nCOLOR3( nColor )
               Win_Fmse.Label_Color07.BackColor := SP_nCOLOR3()

            CASE nNo = 41
               Win_Fmse.TextBox_41.Value := nColor
               SP_nCOLOR8( nColor )
               Win_Fmse.Label_Color08.BackColor := SP_nCOLOR8()
            CASE nNo = 39
               Win_Fmse.TextBox_39.Value := nColor
               SP_nCOLOR6( nColor )
               Win_Fmse.Label_Color09.BackColor := SP_nCOLOR6()
            CASE nNo = 35
               Win_Fmse.TextBox_35.Value := nColor
               SP_nCOLOR2( nColor )
               Win_Fmse.Label_Color10.BackColor := SP_nCOLOR2()
            CASE nNo = 45
               Win_Fmse.TextBox_45.Value := nColor
               SP_nCOLOR12( nColor )
               Win_Fmse.Label_Color11.BackColor := SP_nCOLOR12()
            CASE nNo = 47
               Win_Fmse.TextBox_47.Value := nColor
               SP_nCOLOR14( nColor )
               Win_Fmse.Label_Color12.BackColor := SP_nCOLOR14()
            CASE nNo = 43
               Win_Fmse.TextBox_43.Value := nColor
               SP_nCOLOR10( nColor )
               Win_Fmse.Label_Color13.BackColor := SP_nCOLOR10()
            CASE nNo = 37
               Win_Fmse.TextBox_37.Value := nColor
               SP_nCOLOR4( nColor )
               Win_Fmse.Label_Color14.BackColor := SP_nCOLOR4()
         ENDCASE
      ENDIF
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure PreResetColor()
*+
*+    Called from ( fmsetup.prg )   1 - procedure paint_button()
*+                                   1 - static procedure switchdark()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE PreResetColor()

LOCAL nColor

   ResetColor()

   //    nColor := SP_nCOLOR1()
   //    nColor := RGB2Num(SP_nCOLOR1() )

   Win_Fmse.TextBox_34.Value := RGB2Num( SP_nCOLOR1() )
   Win_Fmse.TextBox_35.Value := RGB2Num( SP_nCOLOR2() )
   Win_Fmse.TextBox_36.Value := RGB2Num( SP_nCOLOR3() )
   Win_Fmse.TextBox_37.Value := RGB2Num( SP_nCOLOR4() )
   Win_Fmse.TextBox_38.Value := RGB2Num( SP_nCOLOR5() )
   Win_Fmse.TextBox_39.Value := RGB2Num( SP_nCOLOR6() )
   Win_Fmse.TextBox_40.Value := RGB2Num( SP_nCOLOR7() )
   Win_Fmse.TextBox_41.Value := RGB2Num( SP_nCOLOR8() )
   Win_Fmse.TextBox_42.Value := RGB2Num( SP_nCOLOR9() )
   Win_Fmse.TextBox_43.Value := RGB2Num( SP_nCOLOR10() )
   Win_Fmse.TextBox_44.Value := RGB2Num( SP_nCOLOR11() )
   Win_Fmse.TextBox_45.Value := RGB2Num( SP_nCOLOR12() )
   Win_Fmse.TextBox_46.Value := RGB2Num( SP_nCOLOR13() )
   Win_Fmse.TextBox_47.Value := RGB2Num( SP_nCOLOR14() )

   Win_Fmse.Label_Color01.BackColor := SP_nCOLOR7()
   Win_Fmse.Label_Color02.BackColor := SP_nCOLOR5()
   Win_Fmse.Label_Color03.BackColor := SP_nCOLOR1()
   Win_Fmse.Label_Color04.BackColor := SP_nCOLOR11()
   Win_Fmse.Label_Color05.BackColor := SP_nCOLOR13()
   Win_Fmse.Label_Color06.BackColor := SP_nCOLOR9()
   Win_Fmse.Label_Color07.BackColor := SP_nCOLOR3()
   Win_Fmse.Label_Color08.BackColor := SP_nCOLOR8()
   Win_Fmse.Label_Color09.BackColor := SP_nCOLOR6()
   Win_Fmse.Label_Color10.BackColor := SP_nCOLOR2()
   Win_Fmse.Label_Color11.BackColor := SP_nCOLOR12()
   Win_Fmse.Label_Color12.BackColor := SP_nCOLOR14()
   Win_Fmse.Label_Color13.BackColor := SP_nCOLOR10()
   Win_Fmse.Label_Color14.BackColor := SP_nCOLOR4()

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SwitchDark()
*+
*+    Called from ( fmsetup.prg )   1 - procedure paintdisplay_fmse()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SwitchDark()

LOCAL lValue := Win_Fmse.CheckBox_01.Value
   SP_DarkMode( lValue )
   PreResetColor()
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SwitchColResize()
*+
*+    Called from ( fmsetup.prg )   1 - procedure paintdisplay_fmse()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SwitchColResize()

LOCAL lValue := Win_Fmse.CheckBox_02.Value
   SP_lColResize( lValue )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SwitchUseImage()
*+
*+    Called from ( fmsetup.prg )   1 - procedure paintdisplay_fmse()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SwitchUseImage()

LOCAL lValue := Win_Fmse.CheckBox_03.Value
   SP_UseImage( lValue )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SetNewSize()
*+
*+    Called from ( fmsetup.prg )   1 - procedure paint_button()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SetNewSize()

LOCAL xValue := Win_Fmse.TextBox_03.Value
LOCAL yValue := Win_Fmse.TextBox_04.Value

   Setproperty( "Win_1", "Width", xValue )
   Setproperty( "Win_1", "Height", yValue )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SetNewPos()
*+
*+    Called from ( fmsetup.prg )   1 - procedure paint_button()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SetNewPos()

LOCAL xValue := Win_Fmse.TextBox_01.Value
LOCAL yValue := Win_Fmse.TextBox_02.Value

   Setproperty( "Win_1", "Row", xValue )
   Setproperty( "Win_1", "Col", yValue )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure PreColorPick()
*+
*+    Called from ( fmsetup.prg )   1 - procedure paint_button()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE PreColorPick()

LOCAL cInitFontName := Win_Fmse.TextBox_18.Value
LOCAL nInitFontSize := Win_Fmse.TextBox_21.Value
LOCAL lBold         := .F.
LOCAL lItalic       := .F.
LOCAL anFontColor   := SP_nColor2()
LOCAL lUnderLine    := .F.
LOCAL lStrikeOut    := .F.
LOCAL nCharset      := DEFAULT_CHARSET
LOCAL aFont

   aFont := GetFont( cInitFontName, nInitFontSize, lBold, lItalic, ;
                     anFontColor, lUnderLine, lStrikeOut, nCharset )

   IF EMPTY( aFont[ 1 ] )
   ELSE
      cInitFontName := aFont[ 1 ]                                     //: Font Name (Character)
      nInitFontSize := aFont[ 2 ]                                     //: Font Size (Numeric)
      lBold := aFont[ 3 ]                                             //: Font Bold (Logical)
      lItalic := aFont[ 4 ]                                           //: Font Italic (Logical)
      anFontColor := aFont[ 5 ]                                       //: Font Color (three element numeric array)
      lUnderLine := aFont[ 6 ]                                        //: Font Underline (Logical)
      lStrikeOut := aFont[ 7 ]                                        //: Font StrikeOut (Logical)
      nCharset := aFont[ 8 ]                                          //: Font Charset (Numeric)

      Win_Fmse.TextBox_18.Value := cInitFontName
      Win_Fmse.TextBox_21.Value := nInitFontSize
      Win_Fmse.TextBox_19.Value := nInitFontSize + 1
      Win_Fmse.TextBox_20.Value := nInitFontSize - 1

      SP_cFontName( cInitFontName )
      SP_nFontSize( nInitFontSize )
      SP_nFontlarge( nInitFontSize + 1 )
      SP_nFontsmall( nInitFontSize - 1 )

   ENDIF

RETURN

*+ EOF: FMSETUP.PRG
