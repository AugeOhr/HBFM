*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\FMSTACK.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Function SP_INIT()
*+               Function GetVKkeys()
*+               Function SP_JustDelete()
*+               Function SP_GetWahl()
*+               Function SP_NewPath()
*+               Function SP_aColLeft()
*+               Function SP_aColRight()
*+               Function SP_LWTextLeft()
*+               Function SP_LWTextRight()
*+               Function SP_nColor1()
*+               Function SP_nColor2()
*+               Function SP_nColor3()
*+               Function SP_nColor4()
*+               Function SP_nColor5()
*+               Function SP_nColor6()
*+               Function SP_nColor7()
*+               Function SP_nColor8()
*+               Function SP_nColor9()
*+               Function SP_nColor10()
*+               Function SP_nColor11()
*+               Function SP_nColor12()
*+               Function SP_nColor13()
*+               Function SP_nColor14()
*+               Function SP_DarkMode()
*+               Function SP_cInxExt()
*+               Function SP_lIndexActive()
*+               Function SP_IndexTags()
*+               Function SP_Device()
*+               Function SP_lThreadRun()
*+               Function SP_RunEject()
*+               Function SP_cGoToDir()
*+               Function SP_lRunGoToDir()
*+               Function SP_lColResize()
*+               Function SP_cFontName()
*+               Function SP_nFontSize()
*+               Function SP_nFontlarge()
*+               Function SP_nFontsmall()
*+               Function SP_cCodepage()
*+               Function SP_lOEM2ANSI()
*+               Function SP_TabLeft()
*+               Function SP_TabRight()
*+               Function SP_ViewLeft()
*+               Function SP_ViewRight()
*+               Function SP_UseImage()
*+               Function SP_AdjustTime()
*+               Function SP_lDropfiles()
*+               Function SP_nSlideShow()
*+               Function SP_lDirWatch()
*+               Function SP_cFindText()
*+               Function SP_cFindExt()
*+               Function SP_lFreeImage()
*+               Function SP_aDbfStruct()
*+               Function SP_cFilter()
*+               Function SP_lFTPrunning()
*+               Function SP_lPbarRunning()
*+               Function SP_aADOStruct()
*+               Function SP_nWinTans()
*+               Function SP_lModiStruct()
*+               Function SP_cMainPath()
*+               Function DebugStack()
*+
*+    Reformatted by Click! 2.05.35 on Oct-8-2020 at  3:10 am
*+
*+--------------------------------------------------------------------

#include "hmg.ch"
#include "MYKEY.CH"
#include "COLOR.CH"

#xtranslate aJustDelete       => Stack\[SP, 1]
#xtranslate cGetWahl          => Stack\[SP, 2]
#xtranslate cNewPath          => Stack\[SP, 3]
#xtranslate aColLeft          => Stack\[SP, 4]
#xtranslate aColRight         => Stack\[SP, 5]
#xtranslate cTextLeft         => Stack\[SP, 6]
#xtranslate cTextRight        => Stack\[SP, 7]
#xtranslate nColor1           => Stack\[SP, 8]
#xtranslate nColor2           => Stack\[SP, 9]
#xtranslate nColor3           => Stack\[SP,10]
#xtranslate nColor4           => Stack\[SP,11]
#xtranslate nColor5           => Stack\[SP,12]
#xtranslate nColor6           => Stack\[SP,13]
#xtranslate nColor7           => Stack\[SP,14]
#xtranslate nColor8           => Stack\[SP,15]
#xtranslate nColor9           => Stack\[SP,16]
#xtranslate nColor10          => Stack\[SP,17]
#xtranslate nColor11          => Stack\[SP,18]
#xtranslate nColor12          => Stack\[SP,19]
#xtranslate nColor13          => Stack\[SP,20]
#xtranslate nColor14          => Stack\[SP,21]
#xtranslate lDarkMode         => Stack\[SP,22]
#xtranslate cInxExt           => Stack\[SP,23]
#xtranslate lIndexActive      => Stack\[SP,24]
#xtranslate aIndexTags        => Stack\[SP,25]
#xtranslate lDevice           => Stack\[SP,26]
#xtranslate lThreadRun        => Stack\[SP,27]
#xtranslate lRunEject         => Stack\[SP,28]
#xtranslate cGoToDir          => Stack\[SP,29]
#xtranslate lRunGoToDir       => Stack\[SP,30]
#xtranslate lColumnResize     => Stack\[SP,31]
#xtranslate cFontName         => Stack\[SP,32]
#xtranslate nFontSize         => Stack\[SP,33]
#xtranslate nFontlarge        => Stack\[SP,34]
#xtranslate nFontsmall        => Stack\[SP,35]
#xtranslate cCodepage         => Stack\[SP,36]
#xtranslate lOEM2ANSI         => Stack\[SP,37]
#xtranslate aTabLeft          => Stack\[SP,38]
#xtranslate aTabRight         => Stack\[SP,39]
#xtranslate nViewLeft         => Stack\[SP,40]
#xtranslate nViewRight        => Stack\[SP,41]
#xtranslate lUseImage         => Stack\[SP,42]
#xtranslate lAdjustTime       => Stack\[SP,43]
#xtranslate lDropfiles        => Stack\[SP,44]
#xtranslate nSlideShow        => Stack\[SP,45]
#xtranslate lDirWatch         => Stack\[SP,46]
#xtranslate cFindText         => Stack\[SP,47]
#xtranslate cFindExt          => Stack\[SP,48]
#xtranslate lFreeImage        => Stack\[SP,49]
#xtranslate aDbfStruct        => Stack\[SP,50]
#xtranslate cFilter           => Stack\[SP,51]
#xtranslate lFTPrunning       => Stack\[SP,52]
#xtranslate lPbarRunning      => Stack\[SP,53]
#xtranslate aADOStruct        => Stack\[SP,54]
#xtranslate nWinTans          => Stack\[SP,55]
#xtranslate lModiStruct       => Stack\[SP,56]
#xtranslate cMainPath         => Stack\[SP,57]

STATIC Stack := {}
STATIC SP    := 0

*+--------------------------------------------------------------------
*+
*+    Function SP_INIT()
*+
*+    Called from ( hbfm.prg )   1 - function main()
*+                ( hbfm64.prg )   1 - function main()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_INIT()                                                    // init STACK

   AADD( Stack, ARRAY( 57 ) )
   SP ++
   aJustDelete := {}
   cGetWahl := "*.*"
   cNewPath := ""
   aColLeft := { 330, 80, 78, 64, 60 }
   aColRight := { 330, 80, 78, 64, 60 }
   cTextLeft := "C:\"
   cTextRight := "C:\"
   nColor1 := SysColor2Num( COLOR_BTNFACE )
   nColor2 := SysColor2Num( COLOR_WINDOWTEXT ) + 1
   nColor3 := SysColor2Num( COLOR_HIGHLIGHT )
   nColor4 := SysColor2Num( COLOR_HIGHLIGHTTEXT )
   nColor5 := SysColor2Num( COLOR_WINDOW )
   nColor6 := SysColor2Num( COLOR_WINDOWTEXT ) + 1
   nColor7 := SysColor2Num( COLOR_BTNTEXT ) + 1
   nColor8 := SysColor2Num( COLOR_WINDOWTEXT ) + 1
   nColor9 := SysColor2Num( COLOR_BTNFACE )
   nColor10 := SysColor2Num( COLOR_WINDOWTEXT ) + 1
   nColor11 := SysColor2Num( COLOR_HIGHLIGHT )
   nColor12 := SysColor2Num( COLOR_HIGHLIGHTTEXT )
   nColor13 := SysColor2Num( COLOR_GRAYTEXT )
   nColor14 := SysColor2Num( COLOR_WINDOWTEXT ) + 1
   lDarkMode := .F.
   cInxExt := "NTX"
   lIndexActive := .F.
   aIndexTags := {}
   lDevice := .F.
   lThreadRun := .F.
   lRunEject := .F.
   cGoToDir := "C:\"
   lRunGoToDir := .F.
   lColumnResize := .F.
   cFontName := "Arial"
   nFontSize := "10"
   nFontlarge := "11"
   nFontsmall := "9"
   cCodepage := "DE850"
   lOEM2ANSI := .F.
   aTabLeft := {}
   aTabRight := {}
   nViewLeft := 1
   nViewRight := 1
   lUseImage := .T.
   lAdjustTime := .T.
   lDropfiles := .F.
   nSlideShow := .F.
   lDirWatch := .T.
   cFindText := ""
   cFindExt := "*.*"
   lFreeImage := .F.
   aDbfStruct := {}
   cFilter := ""
   lFTPrunning := .F.
   lPbarRunning := .F.
   aADOStruct := {}
   nWinTans := 255
   lModiStruct := .F.
   cMainPath := "C:\"

RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Function GetVKkeys()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetVKkeys()

LOCAL aRet := {}
   AADD( aRet, { VK_BACK, 0x08, xbeK_BS } )
   AADD( aRet, { VK_TAB, 0x09, xbeK_TAB } )
   AADD( aRet, { VK_RETURN, 0x0D, xbeK_RETURN } )
   AADD( aRet, { VK_SHIFT, 0x10, xbeK_SHIFT } )
   AADD( aRet, { VK_CONTROL, 0x11, xbeK_CTRL } )
   AADD( aRet, { VK_MENU, 0x12, xbeK_ALT } )
   AADD( aRet, { VK_PAUSE, 0x13, 65555 } )
   AADD( aRet, { VK_CAPITAL, 0x14, xbeK_CAPS_LOCK } )
   AADD( aRet, { VK_ESCAPE, 0x1B, xbeK_ESC } )
   AADD( aRet, { VK_SPACE, 0x20, xbeK_SPACE } )
   AADD( aRet, { VK_PRIOR, 0x21, xbeK_PGUP } )
   AADD( aRet, { VK_NEXT, 0x22, xbeK_PGDN } )
   AADD( aRet, { VK_END, 0x23, xbeK_END } )
   AADD( aRet, { VK_HOME, 0x24, xbeK_HOME } )
   AADD( aRet, { VK_LEFT, 0x25, xbeK_LEFT } )
   AADD( aRet, { VK_UP, 0x26, xbeK_UP } )
   AADD( aRet, { VK_RIGHT, 0x27, xbeK_RIGHT } )
   AADD( aRet, { VK_DOWN, 0x28, xbeK_DOWN } )
   AADD( aRet, { VK_SNAPSHOT, 0x2C, 99999 } )
   AADD( aRet, { VK_INSERT, 0x2D, xbeK_INS } )
   AADD( aRet, { VK_DELETE, 0x2E, xbeK_DEL } )
   AADD( aRet, { VK_LWIN, 0x5B, 65627 } )
   AADD( aRet, { VK_RWIN, 0x5C, 65628 } )
   AADD( aRet, { VK_APPS, 0x5D, xbeK_CMENU } )
   AADD( aRet, { VK_MULTIPLY, 0x6A, 42 } )
   AADD( aRet, { VK_ADD, 0x6B, 43 } )
   AADD( aRet, { VK_SUBTRACT, 0x6D, 45 } )
   AADD( aRet, { VK_DECIMAL, 0x6E, 44 } )
   AADD( aRet, { VK_DIVIDE, 0x6F, 47 } )
   AADD( aRet, { VK_F1, 0x70, xbeK_F1 } )
   AADD( aRet, { VK_F2, 0x71, xbeK_F2 } )
   AADD( aRet, { VK_F3, 0x72, xbeK_F3 } )
   AADD( aRet, { VK_F4, 0x73, xbeK_F4 } )
   AADD( aRet, { VK_F5, 0x74, xbeK_F5 } )
   AADD( aRet, { VK_F6, 0x75, xbeK_F6 } )
   AADD( aRet, { VK_F7, 0x76, xbeK_F7 } )
   AADD( aRet, { VK_F8, 0x77, xbeK_F8 } )
   AADD( aRet, { VK_F9, 0x78, xbeK_F9 } )
   AADD( aRet, { VK_F10, 0x79, xbeK_F10 } )
   AADD( aRet, { VK_F11, 0x7A, xbeK_F11 } )
   AADD( aRet, { VK_F12, 0x7B, xbeK_F12 } )
   AADD( aRet, { VK_F13, 0x7C, xbeK_SH_F1 } )
   AADD( aRet, { VK_F14, 0x7D, xbeK_SH_F2 } )
   AADD( aRet, { VK_F15, 0x7E, xbeK_SH_F3 } )
   AADD( aRet, { VK_F16, 0x7F, xbeK_SH_F4 } )
   AADD( aRet, { VK_F17, 0x80, xbeK_SH_F5 } )
   AADD( aRet, { VK_F18, 0x81, xbeK_SH_F6 } )
   AADD( aRet, { VK_F19, 0x82, xbeK_SH_F7 } )
   AADD( aRet, { VK_F20, 0x83, xbeK_SH_F8 } )
   AADD( aRet, { VK_F21, 0x84, xbeK_SH_F9 } )
   AADD( aRet, { VK_F22, 0x85, xbeK_SH_F10 } )
   AADD( aRet, { VK_F23, 0x86, xbeK_SH_F11 } )
   AADD( aRet, { VK_F24, 0x87, xbeK_SH_F12 } )
   AADD( aRet, { VK_NUMLOCK, 0x90, xbeK_NUM_LOCK } )
   AADD( aRet, { VK_SCROLL, 0x91, xbeK_SCROLL_LOCK } )

RETURN aRet

*+--------------------------------------------------------------------
*+
*+    Function SP_JustDelete()
*+
*+    Called from ( fmgrid.prg )   2 - function dosh2func()
*+                                   2 - static procedure fillwithdir()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_JustDelete( aValue )

   IF PCOUNT() > 0
      aJustDelete := ACLONE( aValue )
   ENDIF
RETURN aJustDelete

*+--------------------------------------------------------------------
*+
*+    Function SP_GetWahl()
*+
*+    Called from ( auswahl.prg )   1 - function auswahl()
*+                                   1 - static procedure dothesefiles()
*+                ( browser.prg )   2 - static procedure pre_setnewindex()
*+                                   1 - static procedure domyindexaction()
*+                                   1 - static procedure doseek()
*+                                   1 - static procedure doscope()
*+                ( fmgrid.prg )   2 - static procedure prefuncmscfolder()
*+                                   1 - static procedure domarkfiles()
*+                ( fmtool.prg )   1 - static procedure domymscaction()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_GetWahl( cValue )

   IF PCOUNT() > 0
      cGetWahl := cValue
   ENDIF
RETURN cGetWahl

*+--------------------------------------------------------------------
*+
*+    Function SP_NewPath()
*+
*+    Called from ( fmgrid.prg )   2 - static procedure prefuncsysfolder()
*+                ( fmtool.prg )   1 - static procedure domysysaction()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_NewPath( cValue )

   IF PCOUNT() > 0
      cNewPath := cValue
   ENDIF
RETURN cNewPath

*+--------------------------------------------------------------------
*+
*+    Function SP_aColLeft()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure defgridleft()
*+                                   1 - static procedure doresizemain()
*+                                   1 - static procedure setlv_view()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_aColLeft( xValue )

   IF PCOUNT() > 0
      aColLeft := xValue
   ENDIF
RETURN aColLeft

*+--------------------------------------------------------------------
*+
*+    Function SP_aColRight()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure defgridright()
*+                                   1 - static procedure doresizemain()
*+                                   1 - static procedure setlv_view()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_aColRight( xValue )

   IF PCOUNT() > 0
      aColRight := xValue
   ENDIF
RETURN aColRight

*+--------------------------------------------------------------------
*+
*+    Function SP_LWTextLeft()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+                                   1 - function moreparaleft()
*+                                   2 - procedure fill1stgrid()
*+                                   1 - procedure docomboimage()
*+                                   2 - static procedure changeleftright()
*+                ( hbfm.prg )   1 - function main()
*+                                   1 - static function loadsetup()
*+                ( hbfm64.prg )   1 - function main()
*+                                   1 - static function loadsetup()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_LWTextLeft( xValue )                                      // Static Drive VolInfo left

   IF PCOUNT() > 0
      IF LEN( xValue ) > 2
         cTextLeft := xValue
      ENDIF
   ENDIF
RETURN cTextLeft

*+--------------------------------------------------------------------
*+
*+    Function SP_LWTextRight()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+                                   1 - function morepararight()
*+                                   2 - procedure fill1stgrid()
*+                                   1 - procedure docomboimage()
*+                                   2 - static procedure changeleftright()
*+                ( hbfm.prg )   1 - function main()
*+                                   1 - static function loadsetup()
*+                ( hbfm64.prg )   1 - function main()
*+                                   1 - static function loadsetup()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_LWTextRight( xValue )                                     // Static Drive VolInfo right

   IF PCOUNT() > 0
      IF LEN( xValue ) > 2
         cTextRight := xValue
      ENDIF
   ENDIF
RETURN cTextRight

*+--------------------------------------------------------------------
*+
*+    Function SP_nColor1()
*+
*+    Called from ( ado.prg )   1 - procedure ado_view()
*+                ( askform.prg )   4 - function askform()
*+                ( auswahl.prg )   1 - function auswahl()
*+                ( browser.prg )   1 - procedure browseview()
*+                                   2 - static procedure editdetail()
*+                                   1 - static procedure setnewindex()
*+                                   1 - static procedure doswitchtags()
*+                                   1 - static procedure do_modi_stru()
*+                                   1 - function wincodepage()
*+                ( export.prg )   4 - procedure exportdbf()
*+                ( fmcolor.prg )   2 - function resetcolor()
*+                ( fmgrid.prg )   8 - procedure dualgrid()
*+                                   2 - static procedure paint_tab_window()
*+                                   1 - static procedure showhistory()
*+                                   1 - static procedure savesetup()
*+                ( fmregdb.prg )   5 - procedure regdbform()
*+                ( fmsetup.prg )   2 - procedure fmsetup()
*+                                   1 - procedure paintdisplay_fmse()
*+                                   1 - procedure saverecord_fmse()
*+                                   2 - procedure colorpicker()
*+                                   2 - static procedure preresetcolor()
*+                ( fmstack.prg )   1 - function debugstack()
*+                ( fmtool.prg )   1 - procedure funcsysfolder()
*+                                   1 - procedure funcmscfolder()
*+                ( hbeject.prg )   2 - procedure hbeject()
*+                ( hbevery.prg )   1 - procedure hbevery()
*+                ( hbfilter.prg )   1 - procedure hbfilter()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( hbftp.prg )   3 - static procedure ftpform()
*+                                   1 - static procedure siteform()
*+                                   7 - static procedure editform()
*+                ( hbinput.prg )   2 - function getinput()
*+                ( modistru.prg )   1 - function showarraystru()
*+                                   1 - procedure editstrurec()
*+                                   4 - static procedure exportxls()
*+                                   5 - procedure createnewdbf()
*+                ( phone2.prg )   1 - procedure getdevicepath()
*+                ( picklist.prg )   1 - procedure picklist()
*+                ( thumbs.prg )   1 - procedure thumbs()
*+                ( viewer.prg )   1 - procedure txt_edit()
*+                                   1 - procedure rtf_edit()
*+                                   1 - function image_edit()
*+                                   2 - procedure dopdfhelp()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_nColor1( xValue )                                         // Background (Skin) Color

   IF PCOUNT() > 0
      nColor1 := xValue
   ENDIF
   IF VALTYPE( nColor1 ) = "N"
      nColor1 := NumColor2RGB( nColor1 )
   ENDIF
RETURN nColor1

*+--------------------------------------------------------------------
*+
*+    Function SP_nColor2()
*+
*+    Called from ( askform.prg )   3 - function askform()
*+                ( browser.prg )   1 - static procedure editdetail()
*+                ( export.prg )   3 - procedure exportdbf()
*+                ( fmcolor.prg )   2 - function resetcolor()
*+                ( fmgrid.prg )   5 - procedure dualgrid()
*+                                   1 - static procedure savesetup()
*+                ( fmregdb.prg )   4 - procedure regdbform()
*+                ( fmsetup.prg )   1 - procedure fmsetup()
*+                                   1 - procedure paintdisplay_fmse()
*+                                   1 - procedure saverecord_fmse()
*+                                   2 - procedure colorpicker()
*+                                   2 - static procedure preresetcolor()
*+                                   1 - static procedure precolorpick()
*+                ( hbeject.prg )   2 - procedure hbeject()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( hbftp.prg )   2 - static procedure ftpform()
*+                                   6 - static procedure editform()
*+                ( hbinput.prg )   1 - function getinput()
*+                ( modistru.prg )   3 - static procedure exportxls()
*+                                   4 - procedure createnewdbf()
*+                ( viewer.prg )   1 - procedure dopdfhelp()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_nColor2( xValue )                                         // Font (Skin) Color Foreground

   IF PCOUNT() > 0
      nColor2 := xValue
   ENDIF
   IF VALTYPE( nColor2 ) = "N"
      nColor2 := NumColor2RGB( nColor2 )
   ENDIF
RETURN nColor2

*+--------------------------------------------------------------------
*+
*+    Function SP_nColor3()
*+
*+    Called from ( fmcolor.prg )   2 - function resetcolor()
*+                ( fmgrid.prg )   1 - static procedure savesetup()
*+                ( fmsetup.prg )   1 - procedure paintdisplay_fmse()
*+                                   1 - procedure saverecord_fmse()
*+                                   2 - procedure colorpicker()
*+                                   2 - static procedure preresetcolor()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_nColor3( xValue )                                         // Listview Hilite Background

   IF PCOUNT() > 0
      nColor3 := xValue
   ENDIF
   IF VALTYPE( nColor3 ) = "N"
      nColor3 := NumColor2RGB( nColor3 )
   ENDIF
RETURN nColor3

*+--------------------------------------------------------------------
*+
*+    Function SP_nColor4()
*+
*+    Called from ( fmcolor.prg )   2 - function resetcolor()
*+                ( fmgrid.prg )   1 - static procedure savesetup()
*+                ( fmsetup.prg )   1 - procedure paintdisplay_fmse()
*+                                   1 - procedure saverecord_fmse()
*+                                   2 - procedure colorpicker()
*+                                   2 - static procedure preresetcolor()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_nColor4( xValue )                                         // Listview Hilite Foreground

   IF PCOUNT() > 0
      nColor4 := xValue
   ENDIF
   IF VALTYPE( nColor4 ) = "N"
      nColor4 := NumColor2RGB( nColor4 )
   ENDIF
RETURN nColor4

*+--------------------------------------------------------------------
*+
*+    Function SP_nColor5()
*+
*+    Called from ( askform.prg )   2 - function askform()
*+                ( auswahl.prg )   1 - function auswahl()
*+                ( browser.prg )  10 - static procedure editdetail()
*+                ( export.prg )   4 - procedure exportdbf()
*+                ( fmcolor.prg )   2 - function resetcolor()
*+                ( fmgrid.prg )   1 - procedure dualgrid()
*+                                   1 - static procedure savesetup()
*+                ( fmregdb.prg )   4 - procedure regdbform()
*+                ( fmsetup.prg )   1 - procedure fmsetup()
*+                                   1 - procedure paintdisplay_fmse()
*+                                   1 - procedure saverecord_fmse()
*+                                   2 - procedure colorpicker()
*+                                   2 - static procedure preresetcolor()
*+                ( hbevery.prg )   3 - procedure hbevery()
*+                ( hbfilter.prg )   4 - procedure hbfilter()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( hbftp.prg )   6 - static procedure editform()
*+                ( hbinput.prg )   1 - function getinput()
*+                ( modistru.prg )   4 - procedure editstrurec()
*+                                   5 - static procedure exportxls()
*+                                   5 - procedure createnewdbf()
*+                ( phone2.prg )   1 - procedure getdevicepath()
*+                ( viewer.prg )   1 - procedure txt_edit()
*+                                   1 - procedure rtf_edit()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_nColor5( xValue )                                         // SLE Background

   IF PCOUNT() > 0
      nColor5 := xValue
   ENDIF
   IF VALTYPE( nColor5 ) = "N"
      nColor5 := NumColor2RGB( nColor5 )
   ENDIF
RETURN nColor5

*+--------------------------------------------------------------------
*+
*+    Function SP_nColor6()
*+
*+    Called from ( askform.prg )   2 - function askform()
*+                ( auswahl.prg )   1 - function auswahl()
*+                ( browser.prg )  10 - static procedure editdetail()
*+                ( export.prg )   4 - procedure exportdbf()
*+                ( fmcolor.prg )   2 - function resetcolor()
*+                ( fmgrid.prg )   1 - procedure dualgrid()
*+                                   1 - static procedure savesetup()
*+                ( fmregdb.prg )   4 - procedure regdbform()
*+                ( fmsetup.prg )   1 - procedure fmsetup()
*+                                   1 - procedure paintdisplay_fmse()
*+                                   1 - procedure saverecord_fmse()
*+                                   2 - procedure colorpicker()
*+                                   2 - static procedure preresetcolor()
*+                ( hbevery.prg )   3 - procedure hbevery()
*+                ( hbfilter.prg )   4 - procedure hbfilter()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( hbftp.prg )   6 - static procedure editform()
*+                ( hbinput.prg )   1 - function getinput()
*+                ( modistru.prg )   4 - procedure editstrurec()
*+                                   5 - static procedure exportxls()
*+                                   5 - procedure createnewdbf()
*+                ( phone2.prg )   1 - procedure getdevicepath()
*+                ( viewer.prg )   1 - procedure txt_edit()
*+                                   1 - procedure rtf_edit()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_nColor6( xValue )                                         // SLE Foreground

   IF PCOUNT() > 0
      nColor6 := xValue
   ENDIF
   IF VALTYPE( nColor6 ) = "N"
      nColor6 := NumColor2RGB( nColor6 )
   ENDIF
RETURN nColor6

*+--------------------------------------------------------------------
*+
*+    Function SP_nColor7()
*+
*+    Called from ( fmcolor.prg )   2 - function resetcolor()
*+                ( fmgrid.prg )   1 - static procedure savesetup()
*+                ( fmsetup.prg )   1 - procedure paintdisplay_fmse()
*+                                   1 - procedure saverecord_fmse()
*+                                   2 - procedure colorpicker()
*+                                   2 - static procedure preresetcolor()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_nColor7( xValue )                                         // Button Background

   IF PCOUNT() > 0
      nColor7 := xValue
   ENDIF
   IF VALTYPE( nColor7 ) = "N"
      nColor7 := NumColor2RGB( nColor7 )
   ENDIF
RETURN nColor7

*+--------------------------------------------------------------------
*+
*+    Function SP_nColor8()
*+
*+    Called from ( fmcolor.prg )   2 - function resetcolor()
*+                ( fmgrid.prg )   1 - static procedure savesetup()
*+                ( fmsetup.prg )   1 - procedure paintdisplay_fmse()
*+                                   1 - procedure saverecord_fmse()
*+                                   2 - procedure colorpicker()
*+                                   2 - static procedure preresetcolor()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_nColor8( xValue )                                         // Button Foreground

   IF PCOUNT() > 0
      nColor8 := xValue
   ENDIF
   IF VALTYPE( nColor8 ) = "N"
      nColor8 := NumColor2RGB( nColor8 )
   ENDIF
RETURN nColor8

*+--------------------------------------------------------------------
*+
*+    Function SP_nColor9()
*+
*+    Called from ( ado.prg )   1 - procedure ado_view()
*+                ( browser.prg )   2 - procedure browseview()
*+                                   1 - static procedure setnewindex()
*+                                   1 - static procedure doswitchtags()
*+                                   1 - static procedure do_modi_stru()
*+                                   1 - function wincodepage()
*+                ( export.prg )   1 - procedure exportdbf()
*+                ( fmcolor.prg )   2 - function resetcolor()
*+                ( fmgrid.prg )   1 - procedure dualgrid()
*+                                   1 - static procedure defgridleft()
*+                                   1 - static procedure defgridright()
*+                                   1 - static procedure showhistory()
*+                                   1 - static procedure savesetup()
*+                ( fmsetup.prg )   1 - procedure paintdisplay_fmse()
*+                                   1 - procedure saverecord_fmse()
*+                                   2 - procedure colorpicker()
*+                                   2 - static procedure preresetcolor()
*+                ( fmtool.prg )   1 - procedure funcsysfolder()
*+                                   1 - procedure funcmscfolder()
*+                ( hbeject.prg )   1 - procedure hbeject()
*+                ( hbevery.prg )   1 - procedure hbevery()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( hbftp.prg )   2 - static procedure ftpform()
*+                                   1 - static procedure siteform()
*+                ( modistru.prg )   1 - function showarraystru()
*+                                   1 - static procedure exportxls()
*+                ( phone2.prg )   2 - procedure getdevicepath()
*+                ( picklist.prg )   2 - procedure picklist()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_nColor9( xValue )                                         // Listview Background

   IF PCOUNT() > 0
      nColor9 := xValue
   ENDIF
   IF VALTYPE( nColor9 ) = "N"
      nColor9 := NumColor2RGB( nColor9 )
   ENDIF
RETURN nColor9

*+--------------------------------------------------------------------
*+
*+    Function SP_nColor10()
*+
*+    Called from ( ado.prg )   1 - procedure ado_view()
*+                ( browser.prg )   2 - procedure browseview()
*+                                   1 - static procedure setnewindex()
*+                                   1 - static procedure doswitchtags()
*+                                   1 - static procedure do_modi_stru()
*+                                   1 - function wincodepage()
*+                ( export.prg )   1 - procedure exportdbf()
*+                ( fmcolor.prg )   2 - function resetcolor()
*+                ( fmgrid.prg )   1 - static procedure defgridleft()
*+                                   1 - static procedure defgridright()
*+                                   1 - static procedure showhistory()
*+                                   1 - static procedure savesetup()
*+                ( fmsetup.prg )   1 - procedure paintdisplay_fmse()
*+                                   1 - procedure saverecord_fmse()
*+                                   2 - procedure colorpicker()
*+                                   2 - static procedure preresetcolor()
*+                ( fmtool.prg )   1 - procedure funcsysfolder()
*+                                   1 - procedure funcmscfolder()
*+                ( hbeject.prg )   1 - procedure hbeject()
*+                ( hbevery.prg )   1 - procedure hbevery()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( hbftp.prg )   2 - static procedure ftpform()
*+                                   1 - static procedure siteform()
*+                ( modistru.prg )   1 - function showarraystru()
*+                                   1 - static procedure exportxls()
*+                ( phone2.prg )   2 - procedure getdevicepath()
*+                ( picklist.prg )   2 - procedure picklist()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_nColor10( xValue )                                        // Listview Foreground

   IF PCOUNT() > 0
      nColor10 := xValue
   ENDIF
   IF VALTYPE( nColor10 ) = "N"
      nColor10 := NumColor2RGB( nColor10 )
   ENDIF
RETURN nColor10

*+--------------------------------------------------------------------
*+
*+    Function SP_nColor11()
*+
*+    Called from ( fmcolor.prg )   2 - function resetcolor()
*+                ( fmgrid.prg )   1 - static procedure savesetup()
*+                ( fmsetup.prg )   1 - procedure paintdisplay_fmse()
*+                                   1 - procedure saverecord_fmse()
*+                                   2 - procedure colorpicker()
*+                                   2 - static procedure preresetcolor()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_nColor11( xValue )                                        // Hilite Background

   IF PCOUNT() > 0
      nColor11 := xValue
   ENDIF
   IF VALTYPE( nColor11 ) = "N"
      nColor11 := NumColor2RGB( nColor11 )
   ENDIF
RETURN nColor11

*+--------------------------------------------------------------------
*+
*+    Function SP_nColor12()
*+
*+    Called from ( fmcolor.prg )   2 - function resetcolor()
*+                ( fmgrid.prg )   1 - procedure dualgrid()
*+                                   1 - static procedure savesetup()
*+                ( fmsetup.prg )   1 - procedure paintdisplay_fmse()
*+                                   1 - procedure saverecord_fmse()
*+                                   2 - procedure colorpicker()
*+                                   2 - static procedure preresetcolor()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_nColor12( xValue )                                        // Hilite Foreground

   IF PCOUNT() > 0
      nColor12 := xValue
   ENDIF
   IF VALTYPE( nColor12 ) = "N"
      nColor12 := NumColor2RGB( nColor12 )
   ENDIF
RETURN nColor12

*+--------------------------------------------------------------------
*+
*+    Function SP_nColor13()
*+
*+    Called from ( browser.prg )   5 - static procedure editdetail()
*+                ( fmcolor.prg )   2 - function resetcolor()
*+                ( fmgrid.prg )   1 - static procedure savesetup()
*+                ( fmsetup.prg )   1 - procedure paintdisplay_fmse()
*+                                   1 - procedure saverecord_fmse()
*+                                   2 - procedure colorpicker()
*+                                   2 - static procedure preresetcolor()
*+                ( hbeject.prg )   1 - procedure hbeject()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( viewer.prg )   1 - procedure txt_edit()
*+                                   1 - procedure rtf_edit()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_nColor13( xValue )                                        // disable Background

   IF PCOUNT() > 0
      nColor13 := xValue
   ENDIF
   IF VALTYPE( nColor13 ) = "N"
      nColor13 := NumColor2RGB( nColor13 )
   ENDIF
RETURN nColor13

*+--------------------------------------------------------------------
*+
*+    Function SP_nColor14()
*+
*+    Called from ( browser.prg )   5 - static procedure editdetail()
*+                ( fmcolor.prg )   2 - function resetcolor()
*+                ( fmgrid.prg )   1 - static procedure savesetup()
*+                ( fmsetup.prg )   1 - procedure paintdisplay_fmse()
*+                                   1 - procedure saverecord_fmse()
*+                                   2 - procedure colorpicker()
*+                                   2 - static procedure preresetcolor()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+                                   1 - static function cre_fmsetup()
*+                ( viewer.prg )   1 - procedure txt_edit()
*+                                   1 - procedure rtf_edit()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_nColor14( xValue )                                        // disable Foreground

   IF PCOUNT() > 0
      nColor14 := xValue
   ENDIF
   IF VALTYPE( nColor14 ) = "N"
      nColor14 := NumColor2RGB( nColor14 )
   ENDIF
RETURN nColor14

*+--------------------------------------------------------------------
*+
*+    Function SP_DarkMode()
*+
*+    Called from ( fmcolor.prg )   1 - function resetcolor()
*+                ( fmgrid.prg )   1 - procedure fill1stgrid()
*+                                   1 - static procedure paint_background_window()
*+                                   1 - static procedure paint_main_background_window()
*+                                   1 - procedure tab_change_left()
*+                                   1 - procedure tab_change_right()
*+                                   1 - static procedure savesetup()
*+                ( fmsetup.prg )   1 - static procedure switchdark()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_DarkMode( xValue )

   IF PCOUNT() > 0
      lDarkMode := xValue
   ENDIF
RETURN lDarkMode

*+--------------------------------------------------------------------
*+
*+    Function SP_cInxExt()
*+
*+    Called from ( browser.prg )   2 - procedure browseview()
*+                                   1 - function use_mydbf()
*+                                   1 - static procedure savecreate()
*+                                   1 - static procedure thisdbfinfo()
*+                                   1 - static procedure seleclang()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_cInxExt( xValue )

   IF PCOUNT() > 0
      cInxExt := xValue
   ENDIF
RETURN cInxExt

*+--------------------------------------------------------------------
*+
*+    Function SP_lIndexActive()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_lIndexActive( xValue )

   IF PCOUNT() > 0
      lIndexActive := xValue
   ENDIF
RETURN lIndexActive

*+--------------------------------------------------------------------
*+
*+    Function SP_IndexTags()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_IndexTags( xValue )

   IF PCOUNT() > 0
      aIndexTags := xValue
   ENDIF
RETURN aIndexTags

*+--------------------------------------------------------------------
*+
*+    Function SP_Device()
*+
*+    Called from ( hbdevice.prg )   2 - function usb_detect()
*+                                   2 - procedure wait4action()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_Device( xValue )

   IF PCOUNT() > 0
      lDevice := xValue
   ENDIF
RETURN lDevice

*+--------------------------------------------------------------------
*+
*+    Function SP_lThreadRun()
*+
*+    Called from ( fmgrid.prg )   2 - procedure doshfunc()
*+                                   2 - function dosh2func()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_lThreadRun( xValue )

   IF PCOUNT() > 0
      lThreadRun := xValue
   ENDIF
RETURN lThreadRun

*+--------------------------------------------------------------------
*+
*+    Function SP_RunEject()
*+
*+    Called from ( hbeject.prg )   3 - procedure hbeject()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_RunEject( xValue )

   IF PCOUNT() > 0
      lRunEject := xValue
   ENDIF
RETURN lRunEject

*+--------------------------------------------------------------------
*+
*+    Function SP_cGoToDir()
*+
*+    Called from ( fmgrid.prg )   2 - static procedure searchform()
*+                ( hbevery.prg )   1 - static procedure gotodir()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_cGoToDir( xValue )

   IF PCOUNT() > 0
      cGoToDir := xValue
   ENDIF
RETURN cGoToDir

*+--------------------------------------------------------------------
*+
*+    Function SP_lRunGoToDir()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure searchform()
*+                ( hbevery.prg )   3 - procedure hbevery()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_lRunGoToDir( xValue )

   IF PCOUNT() > 0
      lRunGoToDir := xValue
   ENDIF
RETURN lRunGoToDir

*+--------------------------------------------------------------------
*+
*+    Function SP_lColResize()
*+
*+    Called from ( browser.prg )   1 - static procedure doresize()
*+                ( fmgrid.prg )   2 - static procedure doresizemain()
*+                                   1 - static procedure savesetup()
*+                ( fmsetup.prg )   1 - static procedure switchcolresize()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_lColResize( xValue )

   IF PCOUNT() > 0
      lColumnResize := xValue
   ENDIF
RETURN lColumnResize

*+--------------------------------------------------------------------
*+
*+    Function SP_cFontName()
*+
*+    Called from ( ado.prg )   4 - procedure ado_view()
*+                ( askform.prg )   8 - function askform()
*+                ( auswahl.prg )   3 - function auswahl()
*+                ( browser.prg )  13 - procedure browseview()
*+                                   5 - static procedure editdetail()
*+                                   1 - static procedure setnewindex()
*+                                   1 - static procedure doswitchtags()
*+                                   2 - static procedure do_modi_stru()
*+                                   1 - function wincodepage()
*+                                   8 - static procedure docreateindex()
*+                ( export.prg )  11 - procedure exportdbf()
*+                ( fmgrid.prg )  21 - procedure dualgrid()
*+                                   1 - static procedure defgridleft()
*+                                   1 - static procedure defgridright()
*+                                   1 - static procedure showhistory()
*+                                   1 - static procedure savesetup()
*+                ( fmregdb.prg )  12 - procedure regdbform()
*+                ( fmsetup.prg )   1 - procedure fmsetup()
*+                                  21 - procedure paint_button()
*+                                  76 - procedure paintdisplay_fmse()
*+                                   1 - static procedure precolorpick()
*+                ( fmtool.prg )   1 - procedure funcsysfolder()
*+                                   1 - procedure funcmscfolder()
*+                ( hbeject.prg )   4 - procedure hbeject()
*+                ( hbevery.prg )   8 - procedure hbevery()
*+                ( hbfilter.prg )  13 - procedure hbfilter()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+                ( hbftp.prg )  18 - static procedure ftpform()
*+                                   6 - static procedure siteform()
*+                                  17 - static procedure editform()
*+                ( hbinput.prg )   4 - function getinput()
*+                ( modistru.prg )   2 - function showarraystru()
*+                                   9 - procedure editstrurec()
*+                                  12 - static procedure exportxls()
*+                                  14 - procedure createnewdbf()
*+                ( picklist.prg )   8 - procedure picklist()
*+                ( viewer.prg )   1 - procedure txt_edit()
*+                                   1 - procedure rtf_edit()
*+                                   1 - procedure dopdfhelp()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_cFontName( xValue )

   IF PCOUNT() > 0
      cFontName := xValue
   ENDIF
RETURN cFontName

*+--------------------------------------------------------------------
*+
*+    Function SP_nFontSize()
*+
*+    Called from ( ado.prg )   3 - procedure ado_view()
*+                ( askform.prg )   8 - function askform()
*+                ( auswahl.prg )   3 - function auswahl()
*+                ( browser.prg )  11 - procedure browseview()
*+                                   5 - static procedure editdetail()
*+                                   1 - static procedure setnewindex()
*+                                   1 - static procedure doswitchtags()
*+                                   1 - function wincodepage()
*+                ( export.prg )  11 - procedure exportdbf()
*+                ( fmgrid.prg )  21 - procedure dualgrid()
*+                                   1 - static procedure savesetup()
*+                ( fmregdb.prg )  12 - procedure regdbform()
*+                ( fmsetup.prg )   1 - static procedure precolorpick()
*+                ( hbevery.prg )   7 - procedure hbevery()
*+                ( hbfilter.prg )  13 - procedure hbfilter()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+                ( hbftp.prg )  18 - static procedure ftpform()
*+                                   6 - static procedure siteform()
*+                                  17 - static procedure editform()
*+                ( hbinput.prg )   4 - function getinput()
*+                ( modistru.prg )  12 - static procedure exportxls()
*+                ( picklist.prg )   8 - procedure picklist()
*+                ( viewer.prg )   1 - procedure txt_edit()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_nFontSize( xValue )

   IF PCOUNT() > 0
      nFontSize := xValue
   ENDIF
RETURN nFontSize

*+--------------------------------------------------------------------
*+
*+    Function SP_nFontlarge()
*+
*+    Called from ( ado.prg )   2 - procedure ado_view()
*+                ( browser.prg )   3 - procedure browseview()
*+                                   2 - static procedure doresize()
*+                                   5 - static procedure editdetail()
*+                                   2 - static procedure do_modi_stru()
*+                                   8 - static procedure docreateindex()
*+                ( fmgrid.prg )   1 - static procedure defgridleft()
*+                                   1 - static procedure defgridright()
*+                                   2 - static procedure doresizemain()
*+                                   1 - static procedure showhistory()
*+                                   1 - static procedure savesetup()
*+                ( fmsetup.prg )   1 - procedure fmsetup()
*+                                   1 - static procedure precolorpick()
*+                ( fmtool.prg )   1 - procedure funcsysfolder()
*+                                   1 - procedure funcmscfolder()
*+                ( hbevery.prg )   1 - procedure hbevery()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+                ( modistru.prg )   2 - function showarraystru()
*+                                   9 - procedure editstrurec()
*+                                  14 - procedure createnewdbf()
*+                ( viewer.prg )   1 - procedure dopdfhelp()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_nFontlarge( xValue )

   IF PCOUNT() > 0
      nFontlarge := xValue
   ENDIF
RETURN nFontlarge

*+--------------------------------------------------------------------
*+
*+    Function SP_nFontsmall()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure savesetup()
*+                ( fmsetup.prg )  21 - procedure paint_button()
*+                                  76 - procedure paintdisplay_fmse()
*+                                   1 - static procedure precolorpick()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_nFontsmall( xValue )

   IF PCOUNT() > 0
      nFontsmall := xValue
   ENDIF
RETURN nFontsmall

*+--------------------------------------------------------------------
*+
*+    Function SP_cCodepage()
*+
*+    Called from ( browser.prg )   1 - static function dbefiletype()
*+                                   1 - static function needoemconvert()
*+                                   1 - static procedure thisdbfinfo()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_cCodepage( xValue )

   IF PCOUNT() > 0
      cCodepage := xValue
   ENDIF
RETURN cCodepage

*+--------------------------------------------------------------------
*+
*+    Function SP_lOEM2ANSI()
*+
*+    Called from ( browser.prg )   1 - procedure browseview()
*+                                   6 - function use_mydbf()
*+                                   1 - static procedure querytest()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_lOEM2ANSI( xValue )

   IF PCOUNT() > 0
      lOEM2ANSI := xValue
   ENDIF
RETURN lOEM2ANSI

*+--------------------------------------------------------------------
*+
*+    Function SP_TabLeft()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure restoretab()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_TabLeft( xValue )

   IF PCOUNT() > 0
      aTabLeft := xValue
   ENDIF
RETURN aTabLeft

*+--------------------------------------------------------------------
*+
*+    Function SP_TabRight()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure restoretab()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_TabRight( xValue )

   IF PCOUNT() > 0
      aTabRight := xValue
   ENDIF
RETURN aTabRight

*+--------------------------------------------------------------------
*+
*+    Function SP_ViewLeft()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure restoretab()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_ViewLeft( xValue )

   IF PCOUNT() > 0
      nViewLeft := xValue
   ENDIF
RETURN nViewLeft

*+--------------------------------------------------------------------
*+
*+    Function SP_ViewRight()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure restoretab()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_ViewRight( xValue )

   IF PCOUNT() > 0
      nViewRight := xValue
   ENDIF
RETURN nViewRight

*+--------------------------------------------------------------------
*+
*+    Function SP_UseImage()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+                                   1 - static procedure defgridleft()
*+                                   1 - static procedure defgridright()
*+                                   2 - static procedure fillwithdir()
*+                                   1 - static procedure savesetup()
*+                ( fmsetup.prg )   1 - static procedure switchuseimage()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_UseImage( xValue )

   IF PCOUNT() > 0
      lUseImage := xValue
   ENDIF
RETURN lUseImage

*+--------------------------------------------------------------------
*+
*+    Function SP_AdjustTime()
*+
*+    Called from ( askform.prg )   1 - static procedure start_shfunc()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_AdjustTime( xValue )

   IF PCOUNT() > 0
      lAdjustTime := xValue
   ENDIF
RETURN lAdjustTime

*+--------------------------------------------------------------------
*+
*+    Function SP_lDropfiles()
*+
*+    Called from ( hbdevice.prg )   1 - function usb_detect()
*+                                   2 - procedure wait4action()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_lDropfiles( xValue )

   IF PCOUNT() > 0
      lDropfiles := xValue
   ENDIF
RETURN lDropfiles := .F.

*+--------------------------------------------------------------------
*+
*+    Function SP_nSlideShow()
*+
*+    Called from ( fmgrid.prg )   2 - static procedure slideshow()
*+                ( viewer.prg )   1 - procedure slideshowend()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_nSlideShow( xValue )

   IF PCOUNT() > 0
      nSlideShow := xValue
   ENDIF
RETURN nSlideShow

*+--------------------------------------------------------------------
*+
*+    Function SP_lDirWatch()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+                                   1 - static procedure refreshgrid()
*+                                   1 - function dosh3func()
*+                                   2 - static procedure createnewfolder()
*+                                   2 - static procedure fillwithdir()
*+                                   2 - static procedure watchdirswitch()
*+                                   2 - static procedure runcmdbox()
*+                                   2 - static procedure dodevice()
*+                                   1 - static function netdisconnect()
*+                                   1 - function watchdirleft()
*+                                   1 - function watchdirright()
*+                                   2 - static procedure dorename()
*+                ( viewer.prg )   2 - function image_edit()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_lDirWatch( xValue )

   IF PCOUNT() > 0
      lDirWatch := xValue
   ENDIF
RETURN lDirWatch

*+--------------------------------------------------------------------
*+
*+    Function SP_cFindText()
*+
*+    Called from ( hbevery.prg )   1 - procedure hbevery()
*+                                   1 - static function domore()
*+                ( viewer.prg )   1 - static procedure searchrtf()
*+                                   2 - static procedure searchtext()
*+                                   2 - static procedure findreplrtfproc()
*+                                   2 - static procedure findrepltxtproc()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_cFindText( xValue )

   IF PCOUNT() > 0
      cFindText := xValue
   ENDIF
RETURN cFindText

*+--------------------------------------------------------------------
*+
*+    Function SP_cFindExt()
*+
*+    Called from ( hbevery.prg )   1 - procedure hbevery()
*+                                   1 - static function domore()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_cFindExt( xValue )

   IF PCOUNT() > 0
      cFindExt := xValue
   ENDIF
RETURN cFindExt

*+--------------------------------------------------------------------
*+
*+    Function SP_lFreeImage()
*+
*+    Called from ( hbfm.prg )   1 - function main()
*+                ( hbfm64.prg )   1 - function main()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_lFreeImage( xValue )

   IF PCOUNT() > 0
      lFreeImage := xValue
   ENDIF
RETURN lFreeImage

*+--------------------------------------------------------------------
*+
*+    Function SP_aDbfStruct()
*+
*+    Called from ( ado.prg )   1 - function adoxlsxwrite()
*+                ( browser.prg )   2 - procedure browseview()
*+                                   1 - static procedure editdetail()
*+                ( export.prg )   1 - static function mywritesdf()
*+                                   1 - static function mywritehbxls()
*+                ( hbfilter.prg )   1 - procedure hbfilter()
*+                                   1 - static procedure satzeval()
*+                                   1 - static procedure fieldpre()
*+                ( picklist.prg )   1 - procedure picklist()
*+                                   1 - static procedure getrightesult()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_aDbfStruct( xValue )

   IF PCOUNT() > 0
      aDbfStruct := ACLONE( xValue )
   ENDIF
RETURN aDbfStruct

*+--------------------------------------------------------------------
*+
*+    Function SP_cFilter()
*+
*+    Called from ( browser.prg )   2 - static procedure setdbffilter()
*+                ( hbfilter.prg )   2 - procedure hbfilter()
*+                                   1 - static procedure fillcombodata()
*+                                   2 - static procedure satzeval()
*+                                   1 - static procedure setdbffilter()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_cFilter( xValue )

   IF PCOUNT() > 0
      cFilter := xValue
   ENDIF
RETURN cFilter

*+--------------------------------------------------------------------
*+
*+    Function SP_lFTPrunning()
*+
*+    Called from ( hbftp.prg )   3 - function hbftp()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_lFTPrunning( lValue )

   IF PCOUNT() > 0
      lFTPrunning := lValue
   ENDIF
RETURN lFTPrunning

*+--------------------------------------------------------------------
*+
*+    Function SP_lPbarRunning()
*+
*+    Called from ( ado.prg )   1 - procedure ado_view()
*+                ( fmgrid.prg )   1 - procedure dualgrid()
*+                ( modistru.prg )   1 - function showarraystru()
*+                ( thumbs.prg )   3 - function pbarform()
*+                                   1 - procedure thumbs()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_lPbarRunning( lValue )

   IF PCOUNT() > 0
      lPbarRunning := lValue
   ENDIF
RETURN lPbarRunning

*+--------------------------------------------------------------------
*+
*+    Function SP_aADOStruct()
*+
*+    Called from ( ado.prg )   1 - procedure ado_view()
*+                ( modistru.prg )   1 - static procedure savearray()
*+                                   1 - static procedure maxitemlen()
*+                                   1 - static procedure ongo_export()
*+                                   1 - static function writeado2sdf()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_aADOStruct( xValue )

   IF PCOUNT() > 0
      aADOStruct := ACLONE( xValue )
   ENDIF
RETURN aADOStruct

*+--------------------------------------------------------------------
*+
*+    Function SP_nWinTans()
*+
*+    Called from ( fmsetup.prg )   1 - procedure saverecord_fmse()
*+                ( fm_func.prg )   1 - procedure wintans()
*+                ( hbfm.prg )   1 - static function loadsetup()
*+                ( hbfm64.prg )   1 - static function loadsetup()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_nWinTans( xValue )

   IF PCOUNT() > 0
      nWinTans := xValue
   ENDIF
RETURN nWinTans

*+--------------------------------------------------------------------
*+
*+    Function SP_lModiStruct()
*+
*+    Called from ( browser.prg )   2 - procedure browseview()
*+                                   1 - static procedure savecreate()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_lModiStruct( lValue )

   IF PCOUNT() > 0
      lModiStruct := lValue
   ENDIF
RETURN lModiStruct

*+--------------------------------------------------------------------
*+
*+    Function SP_cMainPath()
*+
*+    Called from ( browser.prg )   1 - procedure browseview()
*+                                   1 - static procedure savecreate()
*+                ( fmgrid.prg )   1 - procedure dualgrid()
*+                ( fmregdb.prg )   1 - procedure regdbform()
*+                ( thumbs.prg )   1 - procedure changedbfstructur()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_cMainPath( cValue )

   IF PCOUNT() > 0
      cMainPath := cValue
   ENDIF
RETURN cMainPath

*+--------------------------------------------------------------------
*+
*+    Function DebugStack()
*+
*+--------------------------------------------------------------------
*+
FUNCTION DebugStack()

LOCAL xxx := SP_nColor1()
   ALTD()
RETURN NIL

*+ EOF: FMSTACK.PRG
