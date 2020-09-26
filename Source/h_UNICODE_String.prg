*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\SOURCE\\h_UNICODE_String.prg
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Function HMG_LEN()
*+               Function HMG_PADC()
*+               Function HMG_PADL()
*+               Function HMG_PADR()
*+               Function HMG_LEN()
*+               Function HMG_LOWER()
*+               Function HMG_UPPER()
*+               Function HMG_PADC()
*+               Function HMG_PADL()
*+               Function HMG_PADR()
*+               Function HMG_ISALPHA()
*+               Function HMG_ISDIGIT()
*+               Function HMG_ISLOWER()
*+               Function HMG_ISUPPER()
*+               Function HMG_ISALPHANUMERIC()
*+               Function HMG_IsUTF8WithBOM()
*+               Function HMG_UTF8RemoveBOM()
*+               Function HMG_UTF8InsertBOM()
*+               Function HMG_IsUTF8()
*+
*+    Reformatted by Click! 2.05.34 on Sep-22-2020 at  2:50 am
*+
*+--------------------------------------------------------------------

/*----------------------------------------------------------------------------
 HMG Source File --> h_UNICODE_STRING.prg

 Copyright 2012-2017 by Dr. Claudio Soto (from Uruguay).

 mail: <srvet@adinet.com.uy>
 blog: http://srvet.blogspot.com

 Permission to use, copy, modify, distribute and sell this software
 and its documentation for any purpose is hereby granted without fee,
 provided that the above copyright notice appear in all copies and
 that both that copyright notice and this permission notice appear
 in supporting documentation.
 It is provided "as is" without express or implied warranty.

 ----------------------------------------------------------------------------*/

#include "hmg.ch"

/*

UNICODE/ANSI                 ANSI Only
------------                 ---------
HMG_LEN()               <=>   LEN()
HMG_LOWER()             <=>   LOWER()
HMG_UPPER()             <=>   UPPER()
HMG_PADC()              <=>   PADC()
HMG_PADL()              <=>   PADL()
HMG_PADR()              <=>   PADR()
HMG_ISALPHA()           <=>   ISALPHA()
HMG_ISDIGIT()           <=>   ISDIGIT()
HMG_ISLOWER()           <=>   ISLOWER()
HMG_ISUPPER()           <=>   ISUPPER()
HMG_ISALPHANUMERIC()    <=>   RETURN (ISALPHA(c) .OR. ISDIGIT(c))

HB_USUBSTR()            <=>   SUBSTR()
HB_ULEFT()              <=>   LEFT()
HB_URIGHT()             <=>   RIGHT()
HB_UAT()                <=>   AT()
HB_UTF8RAT()            <=>   RAT()
HB_UTF8STUFF()          <=>   STUFF()

*/

#include "SET_COMPILE_HMG_UNICODE.ch"

#ifdef COMPILE_HMG_UNICODE

*+--------------------------------------------------------------------
*+
*+    Function HMG_LEN()
*+
*+    Called from ( h_browse.prg )   4 - function _definebrowse()
*+                                  23 - procedure _browseupdate()
*+                                   2 - procedure _browsenext()
*+                                   1 - procedure _browsedown()
*+                                   1 - procedure _browserefresh()
*+                                   1 - procedure _browsesetvalue()
*+                                  14 - function _browseinplaceedit()
*+                                   2 - procedure _inplaceeditok()
*+                                   4 - procedure processinplacekbdedit()
*+                                   2 - procedure _browseinplaceappend()
*+                                   1 - function _browsecharmaskdisplay()
*+                ( h_grid.prg )  24 - function _definegrid()
*+                                   6 - function _addgridrow()
*+                                   3 - function _hmg_gridinplaceedit()
*+                                  12 - function _hmg_parsegridcontrols()
*+                                   5 - procedure _hmg_gridinplaceeditok()
*+                                   4 - procedure _hmg_gridinplacekbdedit()
*+                                   1 - function getnumfromcelltext()
*+                                   1 - function getnumfromcelltextsp()
*+                                   3 - procedure _hmg_gridinplacekbdedit_2()
*+                                   1 - function getdatagridrecno()
*+                                   1 - function savedatagridfield()
*+                                   1 - function datagridappend()
*+                                   5 - function datagridsave()
*+                                   1 - procedure getdatagridcelldata()
*+                ( h_eventcb.prg )   1 - function eventremove()
*+                                   1 - function eventremoveall()
*+                                   1 - function eventcount()
*+                                   1 - function getformindexbyhandle()
*+                                   1 - function getcontrolindexbyhandle()
*+                                   1 - function getwindowinfobyhandle()
*+                                   1 - function getwindowinfobyhandleex()
*+                                   4 - function hmg_comparehandle()
*+                                   1 - function getforminfobyhandle()
*+                                   1 - function getcontrolinfobyhandle()
*+                                   1 - function hmg_getsubmenuitemfrompoint()
*+                                   1 - function getsplitchildwindowhandle()
*+                ( h_graphbitmap.prg )  27 - function hmg_graph()
*+                                  13 - function hmg_piegraph()
*+                                   1 - procedure drawpolygoninbitmap()
*+                                   2 - static function nmax()
*+                ( h_gridex.prg )   1 - function _gridex_columncount()
*+                                   2 - function _gridex_getcolumncontrol()
*+                                   2 - function _gridex_setcolumncontrol()
*+                                   1 - function _gridex_getcellvalue()
*+                                   1 - function cellnavigationcolor()
*+                                   1 - function _gridex_dogridcustomdrawfont()
*+                                   1 - function _gridex_doheadercustomdrawfont()
*+                                   1 - procedure _gridex_groupcheckboxallitems()
*+                ( h_hmg_hpdf.prg )   1 - function _hmg_hpdf_startpage()
*+                                   2 - function _hmg_hpdf_insertpage()
*+                                   1 - function _hmg_hpdf_gotopage()
*+                                   1 - function hmg_hpdf_pagecount()
*+                                   7 - function _hmg_hpdf_print()
*+                                   7 - function _hmg_hpdf_multiline_print()
*+                                   4 - function _hmg_hpdf_rootoutline()
*+                                   3 - function _hmg_hpdf_pageoutline()
*+                                   3 - function _hmg_hpdf_setpagelink()
*+                                   2 - function _hmg_hpdf_seturllink()
*+                                   2 - function _hmg_hpdf_setinfo()
*+                                   1 - function _hmg_hpdf_setfont()
*+                                   2 - function _hmg_hpdf_seekinlocaloptions()
*+                ( h_hmg_zebra.prg )   1 - function hmg_createbarcode()
*+                                   1 - function hmg_zebra_createbitmapbarcode()
*+                ( h_checkbox.prg )   1 - function _definecheckbox()
*+                ( h_combo.prg )   9 - function _definecombo()
*+                ( h_controlmisc.prg )   1 - function _getvalue()
*+                                   8 - function _setvalue()
*+                                   1 - function _additem()
*+                                   2 - function _setfocus()
*+                                   3 - function _disablecontrol()
*+                                   4 - function _enablecontrol()
*+                                   6 - function _showcontrol()
*+                                   4 - function _hidecontrol()
*+                                   5 - function _setitem()
*+                                   7 - function _getitem()
*+                                  12 - function _setcontrolsizepos()
*+                                   1 - function getdata()
*+                                  16 - function senddata()
*+                                  17 - function inputwindow()
*+                                   1 - function _inputwindowonrelease()
*+                                   1 - function _inputwindowok()
*+                                  13 - function _releasecontrol()
*+                                   1 - function _iscontrolvisiblefromhandle()
*+                                   1 - function random()
*+                                   1 - function cfilepath()
*+                                   1 - function _refresh()
*+                                   1 - function _redrawcontrol()
*+                                   2 - function _getfocusedcontrol()
*+                                   1 - function _getcontrolfree()
*+                                   2 - function _hmg_printer_showpreview()
*+                                   1 - function hmg_isvalidfilename()
*+                                   1 - function getprinter()
*+                                   1 - function compressfiles()
*+                                   4 - function setproperty()
*+                                   4 - function getproperty()
*+                                   3 - function getcontroltabpage()
*+                                   7 - function domethod()
*+                                   1 - function _iswindowvisiblefromhandle()
*+                                   1 - function getfocusedcontroltype()
*+                                   1 - function hmg_createfontfromarrayfont()
*+                                   1 - procedure settooltipcustomdraw()
*+                                   1 - function tooltipcustomdrawevent()
*+                                   1 - function tooltipmenudisplayevent()
*+                                   1 - procedure settooltipmenu()
*+                ( h_dialogs.prg )   3 - function getfile()
*+                                   1 - function putfile()
*+                                   1 - function _hmg_virtualkeyboardgethandle()
*+                ( h_error.prg )   1 - function hmg_getcompileversionraw()
*+                ( h_font.prg )   1 - function _setfontname()
*+                                   1 - function _setfontsize()
*+                                   1 - function _setfontbold()
*+                                   1 - function _setfontitalic()
*+                                   1 - function _setfontunderline()
*+                                   1 - function _setfontstrikeout()
*+                ( h_hotkey.prg )   1 - procedure _definehotkey()
*+                                   1 - procedure _releasehotkey()
*+                                   1 - function _gethotkey()
*+                                   1 - function hmg_presskey()
*+                ( h_label.prg )   1 - function _definelabel()
*+                ( h_listbox.prg )   1 - function _definelistbox()
*+                ( h_menu.prg )   1 - function iscontextmenudefined()
*+                                   1 - function isnotifymenudefined()
*+                                   1 - function isdropdownmenudefined()
*+                                   1 - function releasemainmenu()
*+                                   1 - function releasecontextmenu()
*+                                   1 - function releasenotifymenu()
*+                                   1 - function releasedropdownmenu()
*+                                   1 - function iscontrolcontextmenudefined()
*+                                   1 - function releasecontrolcontextmenu()
*+                                   4 - function _testcontrolhandle_contextmenu()
*+                ( h_msgbox.prg )   1 - function hmg_valtostr()
*+                ( h_radio.prg )   6 - function _defineradiogroup()
*+                                   3 - procedure _setradiogroupreadonly()
*+                ( h_richeditbox.prg )   3 - function _definericheditbox()
*+                ( h_rptgen.prg )   3 - procedure executereport()
*+                                   1 - procedure _processband()
*+                ( h_status.prg )   1 - function _definestatusbaritem()
*+                                   1 - function _endstatusbar()
*+                                   1 - procedure setstatusbarsize()
*+                ( h_tab.prg )   6 - function _definetab()
*+                                   5 - function updatetab()
*+                                   4 - function _deletetabpage()
*+                ( h_textbox.prg )   1 - function _definetextbox()
*+                                   2 - function _definemaskedtextbox()
*+                                   1 - function getnumfromtext()
*+                                   1 - function getnummask()
*+                                  10 - procedure processcharmask()
*+                                   2 - function charmasktekstok()
*+                                   2 - procedure processnumtext()
*+                                   1 - function getnumfromtextsp()
*+                ( h_tree.prg )   2 - function _definetree()
*+                                   1 - function _definetreenode()
*+                                   1 - function _definetreeitem()
*+                                   1 - function treeitemgetdisplaylevel()
*+                                   1 - function treeitemgetitemtext()
*+                                   1 - function _treecustomdrawfont()
*+                ( h_winapimisc.prg )   1 - function _hmg_onkey_onmouse_controls()
*+                ( h_windows.prg )  46 - function events()
*+                                   2 - function releaseallwindows()
*+                                   1 - function _releasewindow()
*+                                   3 - function _showwindow()
*+                                   5 - function _definewindow()
*+                                   3 - function _definemodalwindow()
*+                                   4 - function _definesplitchildwindow()
*+                                   3 - function _activatewindow()
*+                                   2 - function _activateallwindows()
*+                                   1 - procedure _popeventinfo()
*+                                   4 - procedure _refreshdatacontrols()
*+                                   1 - procedure _setactivationflag()
*+                                   1 - procedure _processinitprocedure()
*+                                   2 - function _setfocusedsplitchild()
*+                                   1 - procedure _setactivationfocus()
*+                                   1 - procedure _hmg_onhidefocusmanagement()
*+                                   2 - procedure virtualchildcontrolfocusprocess()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_LEN( x )

   IF VALTYPE( x ) == "C"                                             // HB_ISSTRING(x) .OR. HB_ISCHAR(x) .OR. HB_ISMEMO(x)
      RETURN HB_ULEN( x )
   ELSE
      RETURN LEN( x )
   ENDIF
RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Function HMG_PADC()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_PADC( xValue, nLen, cFillChar )

LOCAL cText, nSize, cPadText := ""
   IF nLen > 0
      IF HB_ISNIL( cFillChar )
         cFillChar := " "
      ENDIF
      IF .NOT. HB_WILDMATCHI( "", cFillChar )
         cFillChar := HB_USUBSTR( cFillChar, 1, 1 )
         cText := HB_VALTOSTR( xValue )
         IF HB_ULEN( cText ) >= nLen
            cPadText := HB_USUBSTR( cText, 1, nLen )
         ELSE
            nSize := nLen - HB_ULEN( cText )
            cPadText := REPLICATE( cFillChar, ( nSize / 2 ) ) + cText + REPLICATE( cFillChar, ( ( nSize + 1 ) / 2 ) )
            cPadText := HB_USUBSTR( cPadText, 1, nLen )
         ENDIF
      ENDIF
   ENDIF
RETURN cPadText

*+--------------------------------------------------------------------
*+
*+    Function HMG_PADL()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_PADL( xValue, nLen, cFillChar )

LOCAL cText, nSize, cPadText := ""
   IF nLen > 0
      IF HB_ISNIL( cFillChar )
         cFillChar := " "
      ENDIF
      IF .NOT. HB_WILDMATCHI( "", cFillChar )
         cFillChar := HB_USUBSTR( cFillChar, 1, 1 )
         cText := HB_VALTOSTR( xValue )
         IF HB_ULEN( cText ) >= nLen
            cPadText := HB_USUBSTR( cText, 1, nLen )
         ELSE
            nSize := nLen - HB_ULEN( cText )
            cPadText := REPLICATE( cFillChar, nSize ) + cText
         ENDIF
      ENDIF
   ENDIF
RETURN cPadText

*+--------------------------------------------------------------------
*+
*+    Function HMG_PADR()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_PADR( xValue, nLen, cFillChar )

LOCAL cText, nSize, cPadText := ""
   IF nLen > 0
      IF HB_ISNIL( cFillChar )
         cFillChar := " "
      ENDIF
      IF .NOT. HB_WILDMATCHI( "", cFillChar )
         cFillChar := HB_USUBSTR( cFillChar, 1, 1 )
         cText := HB_VALTOSTR( xValue )
         IF HB_ULEN( cText ) >= nLen
            cPadText := HB_USUBSTR( cText, 1, nLen )
         ELSE
            nSize := nLen - HB_ULEN( cText )
            cPadText := cText + REPLICATE( cFillChar, nSize )
         ENDIF
      ENDIF
   ENDIF
   RETURN cPadText

   /*
   HB_FUNC (HMG_LOWER)
   HB_FUNC (HMG_UPPER)
   HB_FUNC (HMG_ISALPHA)
   HB_FUNC (HMG_ISDIGIT)
   HB_FUNC (HMG_ISLOWER)
   HB_FUNC (HMG_ISUPPER)
   HB_FUNC (HMG_ISALPHANUMERIC)
*/

#else

*+--------------------------------------------------------------------
*+
*+    Function HMG_LEN()
*+
*+    Called from ( h_browse.prg )   4 - function _definebrowse()
*+                                  23 - procedure _browseupdate()
*+                                   2 - procedure _browsenext()
*+                                   1 - procedure _browsedown()
*+                                   1 - procedure _browserefresh()
*+                                   1 - procedure _browsesetvalue()
*+                                  14 - function _browseinplaceedit()
*+                                   2 - procedure _inplaceeditok()
*+                                   4 - procedure processinplacekbdedit()
*+                                   2 - procedure _browseinplaceappend()
*+                                   1 - function _browsecharmaskdisplay()
*+                ( h_grid.prg )  24 - function _definegrid()
*+                                   6 - function _addgridrow()
*+                                   3 - function _hmg_gridinplaceedit()
*+                                  12 - function _hmg_parsegridcontrols()
*+                                   5 - procedure _hmg_gridinplaceeditok()
*+                                   4 - procedure _hmg_gridinplacekbdedit()
*+                                   1 - function getnumfromcelltext()
*+                                   1 - function getnumfromcelltextsp()
*+                                   3 - procedure _hmg_gridinplacekbdedit_2()
*+                                   1 - function getdatagridrecno()
*+                                   1 - function savedatagridfield()
*+                                   1 - function datagridappend()
*+                                   5 - function datagridsave()
*+                                   1 - procedure getdatagridcelldata()
*+                ( h_eventcb.prg )   1 - function eventremove()
*+                                   1 - function eventremoveall()
*+                                   1 - function eventcount()
*+                                   1 - function getformindexbyhandle()
*+                                   1 - function getcontrolindexbyhandle()
*+                                   1 - function getwindowinfobyhandle()
*+                                   1 - function getwindowinfobyhandleex()
*+                                   4 - function hmg_comparehandle()
*+                                   1 - function getforminfobyhandle()
*+                                   1 - function getcontrolinfobyhandle()
*+                                   1 - function hmg_getsubmenuitemfrompoint()
*+                                   1 - function getsplitchildwindowhandle()
*+                ( h_graphbitmap.prg )  27 - function hmg_graph()
*+                                  13 - function hmg_piegraph()
*+                                   1 - procedure drawpolygoninbitmap()
*+                                   2 - static function nmax()
*+                ( h_gridex.prg )   1 - function _gridex_columncount()
*+                                   2 - function _gridex_getcolumncontrol()
*+                                   2 - function _gridex_setcolumncontrol()
*+                                   1 - function _gridex_getcellvalue()
*+                                   1 - function cellnavigationcolor()
*+                                   1 - function _gridex_dogridcustomdrawfont()
*+                                   1 - function _gridex_doheadercustomdrawfont()
*+                                   1 - procedure _gridex_groupcheckboxallitems()
*+                ( h_hmg_hpdf.prg )   1 - function _hmg_hpdf_startpage()
*+                                   2 - function _hmg_hpdf_insertpage()
*+                                   1 - function _hmg_hpdf_gotopage()
*+                                   1 - function hmg_hpdf_pagecount()
*+                                   7 - function _hmg_hpdf_print()
*+                                   7 - function _hmg_hpdf_multiline_print()
*+                                   4 - function _hmg_hpdf_rootoutline()
*+                                   3 - function _hmg_hpdf_pageoutline()
*+                                   3 - function _hmg_hpdf_setpagelink()
*+                                   2 - function _hmg_hpdf_seturllink()
*+                                   2 - function _hmg_hpdf_setinfo()
*+                                   1 - function _hmg_hpdf_setfont()
*+                                   2 - function _hmg_hpdf_seekinlocaloptions()
*+                ( h_hmg_zebra.prg )   1 - function hmg_createbarcode()
*+                                   1 - function hmg_zebra_createbitmapbarcode()
*+                ( h_checkbox.prg )   1 - function _definecheckbox()
*+                ( h_combo.prg )   9 - function _definecombo()
*+                ( h_controlmisc.prg )   1 - function _getvalue()
*+                                   8 - function _setvalue()
*+                                   1 - function _additem()
*+                                   2 - function _setfocus()
*+                                   3 - function _disablecontrol()
*+                                   4 - function _enablecontrol()
*+                                   6 - function _showcontrol()
*+                                   4 - function _hidecontrol()
*+                                   5 - function _setitem()
*+                                   7 - function _getitem()
*+                                  12 - function _setcontrolsizepos()
*+                                   1 - function getdata()
*+                                  16 - function senddata()
*+                                  17 - function inputwindow()
*+                                   1 - function _inputwindowonrelease()
*+                                   1 - function _inputwindowok()
*+                                  13 - function _releasecontrol()
*+                                   1 - function _iscontrolvisiblefromhandle()
*+                                   1 - function random()
*+                                   1 - function cfilepath()
*+                                   1 - function _refresh()
*+                                   1 - function _redrawcontrol()
*+                                   2 - function _getfocusedcontrol()
*+                                   1 - function _getcontrolfree()
*+                                   2 - function _hmg_printer_showpreview()
*+                                   1 - function hmg_isvalidfilename()
*+                                   1 - function getprinter()
*+                                   1 - function compressfiles()
*+                                   4 - function setproperty()
*+                                   4 - function getproperty()
*+                                   3 - function getcontroltabpage()
*+                                   7 - function domethod()
*+                                   1 - function _iswindowvisiblefromhandle()
*+                                   1 - function getfocusedcontroltype()
*+                                   1 - function hmg_createfontfromarrayfont()
*+                                   1 - procedure settooltipcustomdraw()
*+                                   1 - function tooltipcustomdrawevent()
*+                                   1 - function tooltipmenudisplayevent()
*+                                   1 - procedure settooltipmenu()
*+                ( h_dialogs.prg )   3 - function getfile()
*+                                   1 - function putfile()
*+                                   1 - function _hmg_virtualkeyboardgethandle()
*+                ( h_error.prg )   1 - function hmg_getcompileversionraw()
*+                ( h_font.prg )   1 - function _setfontname()
*+                                   1 - function _setfontsize()
*+                                   1 - function _setfontbold()
*+                                   1 - function _setfontitalic()
*+                                   1 - function _setfontunderline()
*+                                   1 - function _setfontstrikeout()
*+                ( h_hotkey.prg )   1 - procedure _definehotkey()
*+                                   1 - procedure _releasehotkey()
*+                                   1 - function _gethotkey()
*+                                   1 - function hmg_presskey()
*+                ( h_label.prg )   1 - function _definelabel()
*+                ( h_listbox.prg )   1 - function _definelistbox()
*+                ( h_menu.prg )   1 - function iscontextmenudefined()
*+                                   1 - function isnotifymenudefined()
*+                                   1 - function isdropdownmenudefined()
*+                                   1 - function releasemainmenu()
*+                                   1 - function releasecontextmenu()
*+                                   1 - function releasenotifymenu()
*+                                   1 - function releasedropdownmenu()
*+                                   1 - function iscontrolcontextmenudefined()
*+                                   1 - function releasecontrolcontextmenu()
*+                                   4 - function _testcontrolhandle_contextmenu()
*+                ( h_msgbox.prg )   1 - function hmg_valtostr()
*+                ( h_radio.prg )   6 - function _defineradiogroup()
*+                                   3 - procedure _setradiogroupreadonly()
*+                ( h_richeditbox.prg )   3 - function _definericheditbox()
*+                ( h_rptgen.prg )   3 - procedure executereport()
*+                                   1 - procedure _processband()
*+                ( h_status.prg )   1 - function _definestatusbaritem()
*+                                   1 - function _endstatusbar()
*+                                   1 - procedure setstatusbarsize()
*+                ( h_tab.prg )   6 - function _definetab()
*+                                   5 - function updatetab()
*+                                   4 - function _deletetabpage()
*+                ( h_textbox.prg )   1 - function _definetextbox()
*+                                   2 - function _definemaskedtextbox()
*+                                   1 - function getnumfromtext()
*+                                   1 - function getnummask()
*+                                  10 - procedure processcharmask()
*+                                   2 - function charmasktekstok()
*+                                   2 - procedure processnumtext()
*+                                   1 - function getnumfromtextsp()
*+                ( h_tree.prg )   2 - function _definetree()
*+                                   1 - function _definetreenode()
*+                                   1 - function _definetreeitem()
*+                                   1 - function treeitemgetdisplaylevel()
*+                                   1 - function treeitemgetitemtext()
*+                                   1 - function _treecustomdrawfont()
*+                ( h_winapimisc.prg )   1 - function _hmg_onkey_onmouse_controls()
*+                ( h_windows.prg )  46 - function events()
*+                                   2 - function releaseallwindows()
*+                                   1 - function _releasewindow()
*+                                   3 - function _showwindow()
*+                                   5 - function _definewindow()
*+                                   3 - function _definemodalwindow()
*+                                   4 - function _definesplitchildwindow()
*+                                   3 - function _activatewindow()
*+                                   2 - function _activateallwindows()
*+                                   1 - procedure _popeventinfo()
*+                                   4 - procedure _refreshdatacontrols()
*+                                   1 - procedure _setactivationflag()
*+                                   1 - procedure _processinitprocedure()
*+                                   2 - function _setfocusedsplitchild()
*+                                   1 - procedure _setactivationfocus()
*+                                   1 - procedure _hmg_onhidefocusmanagement()
*+                                   2 - procedure virtualchildcontrolfocusprocess()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_LEN( x )

RETURN LEN( x )

*+--------------------------------------------------------------------
*+
*+    Function HMG_LOWER()
*+
*+    Called from ( h_grid.prg )   1 - function _hmg_gridinplaceedit()
*+                                   1 - procedure _hmg_gridinplaceeditok()
*+                ( h_timepicker.prg )   1 - function hmg_gettimeampm()
*+                                   2 - function hmg_istimeampm()
*+                                   2 - function hmg_timetovalue()
*+                ( h_controlmisc.prg )   2 - function inputwindow()
*+                                   1 - function hbtowindateformat()
*+                ( h_label.prg )   1 - function _definelabel()
*+                ( h_textbox.prg )   2 - function _definecharmasktextbox()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_LOWER( c )

RETURN LOWER( c )

*+--------------------------------------------------------------------
*+
*+    Function HMG_UPPER()
*+
*+    Called from ( h_browse.prg )   1 - function _browsecharmaskdisplay()
*+                ( h_grid.prg )   2 - function _definegrid()
*+                                   1 - function _hmg_gridinplaceedit()
*+                                   1 - function _hmg_parsegridcontrols()
*+                ( h_eventcb.prg )  10 - procedure hmg_checktype()
*+                ( h_gridex.prg )   7 - function _gridex_getcellvalue()
*+                                   1 - function _gridex_setcellvalue()
*+                ( h_hmg_hpdf.prg )   5 - function _hmg_hpdf_print()
*+                                   6 - function _hmg_hpdf_multiline_print()
*+                                   2 - function _hmg_hpdf_image()
*+                                   1 - function _hmg_hpdf_setcompression()
*+                                   1 - function _hmg_hpdf_setpermission()
*+                                   1 - function _hmg_hpdf_setpagemode()
*+                                   2 - function _hmg_hpdf_rootoutline()
*+                                   2 - function _hmg_hpdf_pageoutline()
*+                                   7 - function _hmg_hpdf_settextannot()
*+                                   5 - function _hmg_hpdf_setpagelink()
*+                                   5 - function _hmg_hpdf_seturllink()
*+                                   7 - function _hmg_hpdf_setinfo()
*+                                   7 - function _hmg_hpdf_getinfo()
*+                                   5 - function _hmg_hpdf_setpagelabel()
*+                                   1 - function _hmg_hpdf_setfont()
*+                                   5 - function _hmg_hpdf_seekharufonts()
*+                                   4 - function _hmg_hpdf_seekequivalences()
*+                ( h_hmg_hpdf_unicode.prg )   3 - function _hmg_hpdf_multiline_print_unicode()
*+                ( h_button.prg )   4 - function _definemixedbutton()
*+                ( h_controlmisc.prg )   2 - function _getvalue()
*+                                   1 - function _setitem()
*+                                   7 - function _getitem()
*+                                   1 - function _enabletoolbarbutton()
*+                                   1 - function _disabletoolbarbutton()
*+                                   3 - function inputwindow()
*+                                   2 - function getcolumnheadersize()
*+                                   1 - function _hmg_printer_showpreview()
*+                                   4 - function _hmg_printer_savepages()
*+                                   2 - function _hmg_printer_h_print()
*+                                   2 - function _hmg_printer_h_multiline_print()
*+                                  19 - function setproperty()
*+                                  24 - function getproperty()
*+                                  16 - function domethod()
*+                                  18 - function _gridex_getproperty()
*+                                  15 - function _gridex_setproperty()
*+                                   7 - function _gridex_domethod()
*+                                  10 - function _tree_getproperty()
*+                                   9 - function _tree_setproperty()
*+                                   1 - function _tree_domethod()
*+                                  21 - function _richeditbox_getproperty()
*+                                  12 - function _richeditbox_setproperty()
*+                                  16 - function _richeditbox_domethod()
*+                                   2 - function getfontlist()
*+                ( h_dialogs.prg )   2 - function _hmg_virtualkeyboardgethandle()
*+                ( h_help.prg )   1 - procedure _hmg_displayhelptopic()
*+                ( h_rptgen.prg )   2 - procedure executereport()
*+                                   1 - procedure _printimage()
*+                ( h_status.prg )   2 - function _definestatusbaritem()
*+                ( h_tab.prg )   1 - function _definetab()
*+                ( h_textbox.prg )   1 - procedure processcharmask()
*+                ( h_timer.prg )   1 - function _definetimer()
*+                ( h_toolbar.prg )   1 - function _definetoolbutton()
*+                ( h_windows.prg )   1 - function events()
*+                                   1 - procedure installeventhandler()
*+                                   3 - procedure installpropertyhandler()
*+                                   2 - procedure installmethodhandler()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_UPPER( c )

RETURN UPPER( c )

*+--------------------------------------------------------------------
*+
*+    Function HMG_PADC()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_PADC( x, n, c )

RETURN PADC( x, n, c )

*+--------------------------------------------------------------------
*+
*+    Function HMG_PADL()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_PADL( x, n, c )

RETURN PADL( x, n, c )

*+--------------------------------------------------------------------
*+
*+    Function HMG_PADR()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_PADR( x, n, c )

RETURN PADR( x, n, c )

*+--------------------------------------------------------------------
*+
*+    Function HMG_ISALPHA()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _setfocus()
*+                ( h_textbox.prg )   2 - procedure processcharmask()
*+                                   1 - function charmasktekstok()
*+                ( h_windows.prg )   1 - function events()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_ISALPHA( c )

RETURN ISALPHA( c )

*+--------------------------------------------------------------------
*+
*+    Function HMG_ISDIGIT()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _setfocus()
*+                ( h_textbox.prg )   2 - procedure processcharmask()
*+                                   1 - function charmasktekstok()
*+                                   1 - procedure processnumtext()
*+                ( h_windows.prg )   1 - function events()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_ISDIGIT( c )

RETURN ISDIGIT( c )

*+--------------------------------------------------------------------
*+
*+    Function HMG_ISLOWER()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_ISLOWER( c )

RETURN ISLOWER( c )

*+--------------------------------------------------------------------
*+
*+    Function HMG_ISUPPER()
*+
*+    Called from ( h_textbox.prg )   1 - function charmasktekstok()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_ISUPPER( c )

RETURN ISUPPER( c )

*+--------------------------------------------------------------------
*+
*+    Function HMG_ISALPHANUMERIC()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_ISALPHANUMERIC( c )

   RETURN ( ISALPHA( c ) .OR. ISDIGIT( c ) )

#endif

   // #define UTF8_BOM  ( HB_BCHAR (0xEF) + HB_BCHAR (0xBB) + HB_BCHAR (0xBF) )

*+--------------------------------------------------------------------
*+
*+    Function HMG_IsUTF8WithBOM()
*+
*+    Called from ( h_unicode_string.prg )   1 - function hmg_utf8removebom()
*+                                   1 - function hmg_utf8insertbom()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_IsUTF8WithBOM( cString )

RETURN ( HB_BLEFT( cString, HB_BLEN( UTF8_BOM ) ) == UTF8_BOM )

*+--------------------------------------------------------------------
*+
*+    Function HMG_UTF8RemoveBOM()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_UTF8RemoveBOM( cString )

   IF HMG_IsUTF8WithBOM( cString ) == .T.
      cString := HB_BSUBSTR( cString, HB_BLEN( UTF8_BOM ) + 1 )
   ENDIF
RETURN cString

*+--------------------------------------------------------------------
*+
*+    Function HMG_UTF8InsertBOM()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_UTF8InsertBOM( cString )

   IF HMG_IsUTF8WithBOM( cString ) == .F.
      cString := UTF8_BOM + cString
   ENDIF
RETURN cString

*+--------------------------------------------------------------------
*+
*+    Function HMG_IsUTF8()
*+
*+    Called from ( h_controlmisc.prg )   1 - function setproperty()
*+                ( h_datepicker.prg )   1 - procedure _datepickerformatdate()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_IsUTF8( cString )

RETURN HB_StrIsUTF8( cString )

/*
FUNCTION HMG_IsUTF8 ( cString )   // code from Harbour Project, now is implemented as HB_StrIsUTF8()
LOCAL lASCII := .T.
LOCAL nOctets := 0
LOCAL nChar
LOCAL tmp

   FOR EACH tmp IN cString

      nChar := HB_BCODE( tmp )

      IF HB_bitAND ( nChar, 0x80 ) != 0
         lASCII := .F.
      ENDIF

      IF nOctets != 0

         IF HB_bitAND ( nChar, 0xC0 ) != 0x80
            RETURN .F.
         ENDIF

         --nOctets

      ELSEIF HB_bitAND ( nChar, 0x80 ) != 0

         DO WHILE HB_bitAND ( nChar, 0x80 ) != 0
            nChar := HB_bitAND ( HB_bitSHIFT ( nChar, 1 ), 0xFF )
            ++nOctets
         ENDDO

         --nOctets

         IF nOctets == 0
            RETURN .F.
         ENDIF
      ENDIF

   NEXT

RETURN !( nOctets > 0 .OR. lASCII )
*/

*+ EOF: h_UNICODE_String.prg

