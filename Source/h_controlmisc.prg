*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\SOURCE\\h_controlmisc.prg
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Function _Getvalue()
*+               Function _SetValue()
*+               Procedure GRID_CheckRowCol()
*+               Function _AddItem()
*+               Function _DeleteItem()
*+               Function _DeleteAllItems()
*+               Function GetControlIndex()
*+               Function GetControlName()
*+               Function GetControlHandle()
*+               Function GetControlContainerHandle()
*+               Function GetControlParentHandle()
*+               Function GetControlId()
*+               Function GetControlType()
*+               Function GetControlValue()
*+               Function GetControlPageMap()
*+               Function _IsControlDefined()
*+               Function _SetFocus()
*+               Function _DisableControl()
*+               Function _EnableControl()
*+               Function _ShowControl()
*+               Function _HideControl()
*+               Function _SetItem()
*+               Function _GetItem()
*+               Function ListViewGetItem_NEW()
*+               Function _SetControlSizePos()
*+               Function _GetItemCount()
*+               Function _GetControlRow()
*+               Function _GetControlCol()
*+               Function _GetControlWidth()
*+               Function _GetControlHeight()
*+               Function _SetControlCol()
*+               Function _SetControlRow()
*+               Function _SetControlWidth()
*+               Function _SetControlHeight()
*+               Function _SetPicture()
*+               Function _GetPicture()
*+               Function GetData()
*+               Function SendData()
*+               Function _EnableToolbarButton()
*+               Function _DisableToolbarButton()
*+               Function _GetControlAction()
*+               Function _GetToolTip()
*+               Function _SetToolTip()
*+               Function _SetRangeMin()
*+               Function _SetRangeMax()
*+               Function _GetRangeMin()
*+               Function _GetRangeMax()
*+               Function _SetMultiCaption()
*+               Function _GetMultiCaption()
*+               Function InputWindow()
*+               Procedure _InputWindowSetDtFormat()
*+               Function HBtoWinDateFormat()
*+               Function _InputWindowOnRelease()
*+               Function GetColumnHeaderSize()
*+               Function SetMethodCode()
*+               Function _InplaceEditOpt()
*+               Function _InputWindowOk()
*+               Function _InputWindowCancel()
*+               Function _ReleaseControl()
*+               Function _EraseControl()
*+               Function _IsControlVisibleFromHandle()
*+               Function _IsControlVisible()
*+               Function _SetCaretPos()
*+               Function _GetCaretPos()
*+               Function _GetId()
*+               Function Random()
*+               Function _dummy()
*+               Function cFileDrive()
*+               Function cFilePath()
*+               Function cFileNoExt()
*+               Function cFileNoPath()
*+               Function cFileExt()
*+               Function _Refresh()
*+               Function _RedrawControl()
*+               Function _SaveData()
*+               Function _GetFocusedControl()
*+               Function _SetFontColor()
*+               Function _SetBackColor()
*+               Function _GetFontColor()
*+               Function _GetBackColor()
*+               Function _IsControlEnabled()
*+               Function _SetStatusIcon()
*+               Function _GetCaption()
*+               Function _GetControlFree()
*+               Function httpconnect()
*+               Function _SetAddress()
*+               Function _GetAddress()
*+               Function GetStartUpFolder()
*+               Function _HMG_PRINTER_SHOWPREVIEW()
*+               Function _HMG_PRINTER_SpltChldMouseCursor()
*+               Function _HMG_PRINTER_SpltChldMouseClick()
*+               Function _HMG_PRINTER_SET_K_EVENTS()
*+               Function CreateThumbNails()
*+               Function _hmg_printer_ThumbnailToggle()
*+               Function _HMG_PRINTER_ProcessTHUMBNAILS()
*+               Function _HMG_PRINTER_SavePages()
*+               Function HMG_IsValidFileName()
*+               Function _HMG_PRINTER_GO_TO_PAGE()
*+               Function _HMG_PRINTER_hScrollBoxProcess()
*+               Function _HMG_PRINTER_vScrollBoxProcess()
*+               Function _HMG_PRINTER_PreviewClose()
*+               Function _HMG_PRINTER_CleanPreview()
*+               Procedure _HMG_PRINTER_PREVIEWRefresh()
*+               Function _HMG_PRINTER_PREVIEW_OnPaint()
*+               Function _HMG_PRINTER_PrintPages()
*+               Function _HMG_PRINTER_PrintPagesDo()
*+               Function _HMG_PRINTER_ScrollLeft()
*+               Function _HMG_PRINTER_ScrollRight()
*+               Function _HMG_PRINTER_ScrollUp()
*+               Function _HMG_PRINTER_ScrollDown()
*+               Function GetPrinter()
*+               Function _HMG_PRINTER_H_PRINT()
*+               Function _HMG_PRINTER_H_MULTILINE_PRINT()
*+               Function _HMG_PRINTER_H_IMAGE()
*+               Function _HMG_PRINTER_H_LINE()
*+               Function _HMG_PRINTER_H_RECTANGLE()
*+               Function _HMG_PRINTER_H_ROUNDRECTANGLE()
*+               Function _HMG_PRINTER_InitUserMessages()
*+               Function GETPRINTABLEAREAWIDTH()
*+               Function GETPRINTABLEAREAHEIGHT()
*+               Function GETPRINTABLEAREAHORIZONTALOFFSET()
*+               Function GETPRINTABLEAREAVERTICALOFFSET()
*+               Function _HMG_PRINTER_MouseZoom()
*+               Function _HMG_PRINTER_Zoom()
*+               Function _HMG_PRINTER_SETJOBNAME()
*+               Function HMG_PrintGetJobInfo()
*+               Function HMG_PrinterGetStatus()
*+               Function COMPRESSFILES()
*+               Function UNCOMPRESSFILES()
*+               Function _GetControlObject()
*+               Function _DefineActivex()
*+               Function _HMG_SetHeaderImages()
*+               Function _HMG_GetHeaderImages()
*+               Function SetProperty()
*+               Function GetProperty()
*+               Function GetControlTabPage()
*+               Function DoMethod()
*+               Function _IsControlSplitBoxed()
*+               Function _IsWindowVisibleFromHandle()
*+               Function GetFocusedControlType()
*+               Function _GridEx_GetProperty()
*+               Function _GridEx_SetProperty()
*+               Function _GridEx_DoMethod()
*+               Function _Tree_GetProperty()
*+               Function _Tree_SetProperty()
*+               Function _Tree_DoMethod()
*+               Function _RichEditBox_GetProperty()
*+               Function _RichEditBox_SetProperty()
*+               Function _RichEditBox_DoMethod()
*+               Function GetFontList()
*+               Function _SetCargo()
*+               Function _GetCargo()
*+               Function HMG_CreateFontFromArrayFont()
*+               Procedure SetToolTipCustomDraw()
*+               Procedure SetToolTipCustomDrawForm()
*+               Procedure SetToolTipCustomDrawControl()
*+               Function ToolTipCustomDrawEvent()
*+               Function ToolTipMenuDisplayEvent()
*+               Procedure SetToolTipMenu()
*+               Function HMG_CallDLL()
*+               Function HMG_GetHBSymbols()
*+
*+    Reformatted by Click! 2.05.34 on Sep-22-2020 at  2:50 am
*+
*+--------------------------------------------------------------------

/*----------------------------------------------------------------------------
 HMG - Harbour Windows GUI library source code

 Copyright 2002-2017 Roberto Lopez <mail.box.hmg@gmail.com>
 http://sites.google.com/site/hmgweb/

 Head of HMG project:

      2002-2012 Roberto Lopez <mail.box.hmg@gmail.com>
      http://sites.google.com/site/hmgweb/

      2012-2017 Dr. Claudio Soto <srvet@adinet.com.uy>
      http://srvet.blogspot.com

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of HMG.

 The exception is that, if you link the HMG library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 HMG library code into it.

 Parts of this project are based upon:

    "Harbour GUI framework for Win32"
    Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
    Copyright 2001 Antonio Linares <alinares@fivetech.com>
    www - http://www.harbour-project.org

    "Harbour Project"
    Copyright 1999-2008, http://www.harbour-project.org/

    "WHAT32"
    Copyright 2002 AJ Wos <andrwos@aust1.net>

    "HWGUI"
    Copyright 2001-2008 Alexander S.Kresin <alex@belacy.belgorod.su>

---------------------------------------------------------------------------*/

MEMVAR _HMG_SYSDATA
MEMVAR _HMG_StopControlEventProcedure
MEMVAR _HMG_CharRange_Min, _HMG_CharRange_Max
MEMVAR aResult
MEMVAR _Y1, _X1, _Y2, _X2

#include "SET_COMPILE_HMG_UNICODE.ch"   // UNICODE

#include "SETCompileBrowse.ch"

#include "common.ch"
#include "hbdyn.ch"
#include "hmg.ch"

#define _NEW_MethodToolButtonChecked_

// #define SC_CLOSE   0xF060   // ok
#define MF_GRAYED       1   // ok

#define BS_PUSHBUTTON      0    // ok
#define BS_DEFPUSHBUTTON   1    // ok
#define BM_SETSTYLE        244  // ok

#define BM_SETIMAGE        247   // ok
#define IMAGE_BITMAP       0     // ok

#define WM_NEXTDLGCTL      40    // ok

#define COLOR_BTNFACE      15    // ok

#define PBM_GETPOS         1032  // ok
#define BM_GETCHECK        240   // ok
#define BST_UNCHECKED      0     // ok
#define BST_CHECKED        1     // ok
#define BM_SETCHECK        241   // ok
#define EM_GETSEL          176   // ok
#define EM_SETSEL          177   // ok
#define EM_SCROLLCARET     0x00B7   //ok

// #define WM_USER           1024          // ok (MinGW)
// #define TBM_SETPOS       (WM_USER+5)    // ok (MinGW)
// #define TBM_GETPOS       (WM_USER)      // ok (MinGW)
// #define PBM_SETPOS       (WM_USER+2)    // ok (MinGW)
// #define EM_SETBKGNDCOLOR (WM_USER+67)   // ok (MinGW)
#define TBM_SETPOS         1029  // ok
#define TBM_GETPOS         1024  // ok
#define PBM_SETPOS         1026  // ok
#define EM_SETBKGNDCOLOR   1091  // ok

//#define NM_FIRST         0      // ok
//#define NM_CUSTOMDRAW (NM_FIRST-12)  // ok
//#define WM_NOTIFY      78   //  ok

#define _SET_BITMAP_GRAY .T.

*+--------------------------------------------------------------------
*+
*+    Function _Getvalue()
*+
*+    Called from ( h_browse.prg )   1 - function _browseinplaceedit()
*+                                   1 - procedure _inplaceeditok()
*+                ( h_grid.prg )   1 - function setdatagridrecno()
*+                                   1 - function getdatagridrecno()
*+                                   1 - function datagridrefresh()
*+                ( h_timepicker.prg )   1 - procedure _datatimepickersave()
*+                ( h_checkbox.prg )   1 - procedure _datacheckboxsave()
*+                ( h_combo.prg )   1 - procedure _datacomborefresh()
*+                ( h_controlmisc.prg )   2 - function _setvalue()
*+                                   1 - function _inputwindowok()
*+                                   1 - function getproperty()
*+                ( h_datepicker.prg )   1 - procedure _datadatepickersave()
*+                ( h_editbox.prg )   1 - procedure _dataeditboxsave()
*+                ( h_richeditbox.prg )   1 - procedure _dataricheditboxsave()
*+                ( h_textbox.prg )   1 - procedure _datatextboxsave()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _Getvalue( ControlName, ParentForm, Index )

LOCAL retval, h, t, x, c, d, bd, ix, auxval, WorkArea, BackRec, rcount, Tmp, Ts, BF
LOCAL TimeValue24h, cTimeFormat

   retval := 0

   IF PCOUNT() == 2

      IF HMG_UPPER( ALLTRIM( ControlName ) ) == 'VSCROLLBAR'

         RETURN GetScrollPos( GetFormHandle( ParentForm ), 1 )

      ENDIF

      IF HMG_UPPER( ALLTRIM( ControlName ) ) == 'HSCROLLBAR'

         RETURN GetScrollPos( GetFormHandle( ParentForm ), 0 )

      ENDIF

      T = GetControlType( ControlName, ParentForm )
      h = GetControlParentHandle( ControlName, ParentForm )
      c = GetControlHandle( ControlName, ParentForm )
      ix := GetControlIndex( ControlName, ParentForm )

   ELSE

      T = _HMG_SYSDATA[ 1 ] [ Index ]
      h = _HMG_SYSDATA[ 4 ] [ Index ]
      c = _HMG_SYSDATA[ 3 ] [ Index ]
      ix := INDEX

   ENDIF

   DO CASE

#ifdef COMPILEBROWSE

      CASE T == "BROWSE"

         retval := _BrowseGetValue( '', '', ix )

#endif

      CASE T == "PROGRESSBAR"

         retval := SendMessage( c, PBM_GETPOS, 0, 0 )

      CASE T == "IPADDRESS"

         retval := GetIPAddress( c )

      CASE T == "MONTHCAL"

         // bd = Set (_SET_DATEFORMAT )
         bd := HBtoWinDateFormat()

         SET DATE TO ANSI
         d = ALLTRIM( STR( GetMOnthCalYear( c ) ) ) + "." + ALLTRIM( STR( GetMonthCalMonth( c ) ) ) + "." + ALLTRIM( STR( GetMonthCalDay( c ) ) )
         retval := CTOD( d )
         SET( _SET_DATEFORMAT, bd )

      CASE T == "TREE"

         IF _HMG_SYSDATA[ 9 ] [ ix ] == .F.
            retval := ASCAN( _HMG_SYSDATA[ 7 ] [ ix ], TreeView_GetSelection( c ) )
         ELSE
            retval := TreeView_GetSelectionId( c )
         ENDIF

      CASE T == "MASKEDTEXT"

         IF "E" $ _HMG_SYSDATA[ 7 ] [ ix ]

            Ts := GetWindowText( c )

            IF "." $ _HMG_SYSDATA[ 7 ] [ ix ]
               DO CASE
                  CASE HB_UAT( '.', Ts ) > HB_UAT( ',', Ts )
                     retval := GetNumFromText( GetWindowText( c ), ix )
                  CASE HB_UAT( ',', Ts ) > HB_UAT( '.', Ts )
                     retval := GetNumFromTextSp( GetWindowText( c ), ix )
               ENDCASE
            ELSE
               DO CASE
                  CASE HB_UAT( '.', Ts ) != 0
                     retval := GetNumFromTextSp( GetWindowText( c ), ix )
                  CASE HB_UAT( ',', Ts ) != 0
                     retval := GetNumFromText( GetWindowText( c ), ix )
                  OTHERWISE
                     retval := GetNumFromText( GetWindowText( c ), ix )
               ENDCASE
            ENDIF
         ELSE
            retval := GetNumFromText( GetWindowText( c ), ix )
         ENDIF

      CASE T == "TEXT" .OR. T == "EDIT" .OR. T == "LABEL" .OR. T == "CHARMASKTEXT" .OR. T == "RICHEDIT"

         IF t == "CHARMASKTEXT"
            IF VALTYPE( _HMG_SYSDATA[ 17 ] [ ix ] ) == 'L'
               IF _HMG_SYSDATA[ 17 ] [ ix ] == .T.
                  retval := CTOD( ALLTRIM( GetWindowText( c ) ) )
               ELSE
                  retval := GetWindowText( c )
               ENDIF
            ELSE
               retval := GetWindowText( c )
            ENDIF
         ELSE
            retval := GetWindowText( c )
         ENDIF

      CASE T == "NUMTEXT"

         //        retval := Int ( Val( GetWindowText(  c ) ) )
         retval := VAL( GetWindowText( c ) )

      CASE T == "SPINNER"

         retval := GetSpinnerValue( c[ 2 ] )

      CASE T == "CHECKBOX"

         auxval := SendMessage( c, BM_GETCHECK, 0, 0 )

         IF auxval == BST_CHECKED
            retval := .t.
         ELSEIF auxval == BST_UNCHECKED
            retval := .f.
         ENDIF

      CASE T == "RADIOGROUP"

         FOR x = 1 TO HMG_LEN( c )

            auxval := SendMessage( c[ x ], BM_GETCHECK, 0, 0 )

            IF auxval == BST_CHECKED
               retval := x
               EXIT
            ENDIF

         NEXT x

      CASE T == "COMBO"

         IF VALTYPE( _HMG_SYSDATA[ 22 ] [ ix ] ) == 'C'

            auxval := ComboGetCursel( c )
            rcount := 0

            WorkArea := _HMG_SYSDATA[ 22 ] [ ix ]

            BackRec := ( WorkArea )->( RECNO() )
            ( WorkArea )->( DBGOTOP() )

            DO WHILE !( WorkArea )->( EOF() )
               rcount ++
               IF rcount == auxval

                  IF EMPTY( _HMG_SYSDATA[ 33 ] [ ix ] )
                     RetVal := ( WorkArea )->( RECNO() )
                  ELSE
                     Tmp := _HMG_SYSDATA[ 33 ] [ ix ]
                     RetVal := &Tmp
                  ENDIF

               ENDIF
               ( WorkArea )->( DBSKIP() )
            ENDDO

            ( WorkArea )->( DBGOTO( BackRec ) )

         ELSE
            retval := ComboGetCursel( c )
         ENDIF

      CASE T == "LIST"
         retval := ListBoxGetCursel( c )
      CASE T == "GRID"

         IF _HMG_SYSDATA[ 32 ] [ ix ] == .T.

            retval := { _HMG_SYSDATA[ 39 ] [ ix ], _HMG_SYSDATA[ 15 ] [ ix ] }

         ELSE

            retval := LISTVIEW_GETFIRSTITEM( c )

         ENDIF

      CASE T == "TAB"
         retval := TABCTRL_GETCURSEL( c )

      CASE T == "DATEPICK"
         bf := SET( 2 )
         SET( 2, .f. )
         //bd = Set (_SET_DATEFORMAT )
         bd := HBtoWinDateFormat()

         SET DATE TO ANSI
         d = ALLTRIM( STR( GetDatePickYear( c ) ) ) + "." + ALLTRIM( STR( GetDatePickMonth( c ) ) ) + "." + ALLTRIM( STR( GetDatePickDay( c ) ) )
         retval := CTOD( d )
         SET( _SET_DATEFORMAT, bd )
         SET( 2, bf )

      CASE T == "TIMEPICK"                                            // ( Dr. Claudio Soto, April 2013 )
         TimeValue24h := GETTIMEPICK( c )
         IF TimeValue24h[ 1 ] == - 1                                  // Not Valid Time or Disable checkbox (SHOWNONE)
            retval := ""
         ELSE
            // retval := STRZERO (TimeValue24h [1], 2) +":"+ STRZERO (TimeValue24h [2], 2) +":"+ STRZERO (TimeValue24h [3], 2)
            cTimeFormat := _HMG_SYSDATA[ 9 ] [ ix ]
            retval := HMG_ValueToTime( TimeValue24h, cTimeFormat )
         ENDIF

      CASE T == "SLIDER"

         retval := SendMessage( c, TBM_GETPOS, 0, 0 )

      CASE T == "MULTILIST"

         retval := ListBoxGetMultiSel( c )

      CASE T == "MULTIGRID"

         retval := ListViewGetMultiSel( c )

      CASE T == "TOOLBUTTON"
#ifdef _NEW_MethodToolButtonChecked_
         retval := IsToolButtonChecked( _HMG_SYSDATA[ 26 ] [ ix ], NIL, _HMG_SYSDATA[ 5 ] [ ix ] )                                          // ADD
#else
         retval := IsToolButtonChecked( _HMG_SYSDATA[ 26 ] [ ix ], _HMG_SYSDATA[ 8 ] [ ix ] - 1 )
#endif

   ENDCASE
RETURN ( retval )

*+--------------------------------------------------------------------
*+
*+    Function _SetValue()
*+
*+    Called from ( h_grid.prg )   1 - function _definegrid()
*+                                   1 - function setdatagridrecno()
*+                                   1 - function datagridappend()
*+                                   2 - function datagridrefresh()
*+                ( h_timepicker.prg )   1 - procedure _datatimepickerrefresh()
*+                ( h_checkbox.prg )   1 - procedure _datacheckboxrefresh()
*+                ( h_combo.prg )   1 - procedure _datacomborefresh()
*+                ( h_controlmisc.prg )   1 - function setproperty()
*+                ( h_datepicker.prg )   1 - procedure _datadatepickerrefresh()
*+                ( h_editbox.prg )   1 - procedure _dataeditboxrefresh()
*+                ( h_richeditbox.prg )   1 - procedure _dataricheditboxrefresh()
*+                ( h_tab.prg )  16 - function _begintab()
*+                ( h_textbox.prg )   2 - procedure _datatextboxrefresh()
*+                ( h_windows.prg )   2 - procedure _refreshdatacontrols()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetValue( ControlName, ParentForm, Value, index )

LOCAL retval, h, t, x, c, y, r, controlcount, backrec, workarea, rcount, aPos
LOCAL TreeItemHandle := 0, ix
LOCAL z
LOCAL aTemp
LOCAL lEqual
LOCAL xPreviousValue
LOCAL TimeValue24h
LOCAL i, cText

   controlcount := HMG_LEN( _HMG_SYSDATA[ 5 ] )
   retval := 0
   r = 0

   IF PCOUNT() == 3

      ix = GetControlIndex( ControlName, ParentForm )

      t = _HMG_SYSDATA[ 1 ] [ ix ]
      h = _HMG_SYSDATA[ 4 ] [ ix ]
      c = _HMG_SYSDATA[ 3 ] [ ix ]

   ELSE

      t = _HMG_SYSDATA[ 1 ] [ index ]
      h = _HMG_SYSDATA[ 4 ] [ index ]
      c = _HMG_SYSDATA[ 3 ] [ index ]
      ix = INDEX

   ENDIF

   IF VALTYPE( Value ) == 'A'

      aTemp := _GetValue(,, ix )

      IF VALTYPE( aTemp ) == 'A'

         IF HMG_LEN( aTemp ) == HMG_LEN( Value )

            lEqual := .T.

            FOR z := 1 TO HMG_LEN( Value )
               IF VALTYPE( aTemp[ z ] ) == VALTYPE( Value[ z ] )
                  IF aTemp[ z ] <> Value[ z ]
                     lEqual := .F.
                     EXIT
                  ENDIF
               ELSE
                  lEqual := .F.
                  EXIT
               ENDIF
            NEXT z

            IF lEqual == .T.
               RETURN Nil
            ENDIF

         ENDIF

      ENDIF

   ELSE
      IF T <> "TREE"                                                  // ADD

         xPreviousValue := _GetValue(,, ix )
         IF VALTYPE( xPreviousValue ) == VALTYPE( Value )
            IF xPreviousValue == value
               RETURN Nil
            ENDIF
         ENDIF

      ENDIF
   ENDIF

   DO CASE

#ifdef COMPILEBROWSE

      CASE T == "BROWSE"

         _BrowseSetValue( '', '', value, ix )

#endif

      CASE T == "IPADDRESS"

         IF HMG_LEN( Value ) == 0
            ClearIpAddress( c )
         ELSE
            SetIPAddress( c, Value[ 1 ], Value[ 2 ], Value[ 3 ], Value[ 4 ] )
         ENDIF

      CASE T == "MONTHCAL"

         SetMonthCal( c, YEAR( value ), MONTH( value ), DAY( value ) )

         _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ ix ], ix )

      CASE T == "TREE"

         IF _HMG_SYSDATA[ 9 ] [ ix ] == .F.
            IF Value > TreeView_GetCount( c ) .OR. Value < 1
               MsgHMGError( "Value Property: Invalid TreeItem Reference (nPos). Program Terminated" )
            ENDIF

            TreeItemHandle := _HMG_SYSDATA[ 7 ] [ ix ] [ Value ]
         ELSE
            aPos := ASCAN( _HMG_SYSDATA[ 25 ] [ ix ], Value )
            IF aPos == 0
               MsgHMGError( "Value Property: Invalid TreeItem Reference (nID). Program Terminated" )
            ENDIF

            TreeItemHandle := _HMG_SYSDATA[ 7 ] [ ix ] [ aPos ]
         ENDIF

         TreeView_SelectItem( c, TreeItemHandle )

      CASE T == "MASKEDTEXT"

         IF GetFocus() == c
            SetWindowText( _HMG_SYSDATA[ 3 ] [ ix ], TRANSFORM( Value, _HMG_SYSDATA[ 9 ] [ ix ] ) )
         ELSE
            SetWindowText( _HMG_SYSDATA[ 3 ] [ ix ], TRANSFORM( value, _HMG_SYSDATA[ 7 ] [ ix ] ) )
         ENDIF

      CASE T == "TIMER"

         KillTimer( _HMG_SYSDATA[ 4 ] [ ix ], _HMG_SYSDATA[ 5 ] [ ix ] )
         _HMG_SYSDATA[ 8 ] [ ix ] := Value

         FOR x := 1 TO ControlCount
            IF _HMG_SYSDATA[ 5 ] [ x ] == _HMG_SYSDATA[ 5 ] [ ix ]
               InitTimer( GetFormHandle( ParentForm ), _HMG_SYSDATA[ 5 ] [ ix ], _HMG_SYSDATA[ 8 ] [ ix ] )
               EXIT
            ENDIF
         NEXT x

      CASE T == "LABEL"

         IF VALTYPE( value ) <> "C"                                   // ADD October 2015
            IF VALTYPE( value ) == "A"
               cText := ""
               FOR i = 1 TO HMG_LEN( value )
                  cText := cText + hb_ValToStr( value[ i ] )
               NEXT
            ELSE
               cText := hb_ValToStr( value )
            ENDIF
            value := cText
         ENDIF

         IF _HMG_SYSDATA[ 22 ] [ ix ] == 1
            _SetControlWidth( ControlName, ParentForm, GetTextWidth( NIL, Value, _HMG_SYSDATA[ 36 ] [ ix ] ) )
            _SetControlHeight( ControlName, ParentForm, _HMG_SYSDATA[ 28 ] [ ix ] + 16 )
         ENDIF

         SetWindowText( c, value )

         IF VALTYPE( _HMG_SYSDATA[ 9 ] [ ix ] ) == 'L'
            IF _HMG_SYSDATA[ 9 ] [ ix ] == .T.
               RedrawWindowControlRect( h, _HMG_SYSDATA[ 18 ] [ ix ], _HMG_SYSDATA[ 19 ] [ ix ], _HMG_SYSDATA[ 18 ] [ ix ] + _HMG_SYSDATA[ 21 ] [ ix ], _HMG_SYSDATA[ 19 ] [ ix ] + _HMG_SYSDATA[ 20 ] [ ix ] )
            ENDIF
         ELSE
            RedrawWindow( c )                                         // ADD  May 2015
         ENDIF

      CASE T == "TEXT" .OR. T == "EDIT" .OR. T == "CHARMASKTEXT" .OR. T == "RICHEDIT"

         IF t == "CHARMASKTEXT"
            IF VALTYPE( _HMG_SYSDATA[ 17 ] [ ix ] ) == 'L'
               IF _HMG_SYSDATA[ 17 ] [ ix ] == .T.
                  SetWindowText( c, RTRIM( DTOC( value ) ) )
               ELSE
                  SetWindowText( c, RTRIM( value ) )
               ENDIF
            ELSE
               SetWindowText( c, RTRIM( value ) )
            ENDIF
         ELSE
            // add by Jimmy 202009
            IF VALTYPE( value ) == '@' .OR. VALTYPE( value ) == 'T'
               SetWindowText( c, hb_TSToStr( value ) )
            ELSE
               SetWindowText( c, RTRIM( value ) )
            ENDIF
         ENDIF

         IF T == "EDIT"

            _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ ix ], ix )

         ENDIF

      CASE T == "NUMTEXT"

         SetWindowText( c, ALLTRIM( STR( value ) ) )

      CASE T == "SPINNER"
         SetSpinnerValue( c[ 2 ], Value )

      CASE T == "CHECKBOX"
         IF value = .t.
            SendMessage( c, BM_SETCHECK, BST_CHECKED, 0 )
         ELSE
            SendMessage( c, BM_SETCHECK, BST_UNCHECKED, 0 )
         ENDIF

         _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ ix ], ix )

      CASE T == "RADIOGROUP"

         FOR x = 1 TO HMG_LEN( c )
            SendMessage( c[ x ], BM_SETCHECK, BST_UNCHECKED, 0 )
         NEXT x

         SendMessage( c[ value ], BM_SETCHECK, BST_CHECKED, 0 )

         IF _HMG_SYSDATA[ 25 ] [ ix ] == .F. .AND. IsTabStop( c[ value ] )
            SetTabStop( c[ value ], .f. )
         ENDIF

         _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ ix ], ix )

      CASE T == "COMBO"

         IF VALTYPE( Value ) != 'N'
            MsgHMGError( 'COMBOBOX: Value property wrong type (only numeric allowed). Program terminated' )
         ENDIF

         IF VALTYPE( _HMG_SYSDATA[ 22 ] [ ix ] ) == 'C'
            _HMG_SYSDATA[ 8 ] [ ix ] := value
            WorkArea := _HMG_SYSDATA[ 22 ] [ ix ]
            rcount := 0
            BackRec := ( WorkArea )->( RECNO() )
            ( WorkArea )->( DBGOTOP() )
            DO WHILE !( WorkArea )->( EOF() )
               rcount ++
               IF value == ( WorkArea )->( RECNO() )
                  EXIT
               ENDIF
               ( WorkArea )->( DBSKIP() )
            ENDDO
            ( WorkArea )->( DBGOTO( BackRec ) )
            ComboSetCurSel( c, rcount )
         ELSE
            ComboSetCursel( c, value )
         ENDIF

         _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ ix ], ix )

      CASE T == "LIST"
         ListBoxSetCursel( c, value )
         _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ ix ], ix )
      CASE T == "GRID"

         IF _HMG_SYSDATA[ 32 ] [ ix ] == .F.

            ListView_SetCursel( c, value )
            ListView_EnsureVisible( C, VALUE )

         ELSE

            IF VALTYPE( VALUE ) == 'A'
               /*
                IF VALUE [1] == 0 .OR. VALUE [2] == 0   // Remove, April 2016

                    _HMG_SYSDATA [ 39 ] [ix] := 0
                    _HMG_SYSDATA [ 15 ] [ix] := 0

                    RedrawWindow( c )

                    _DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [ix] , ix )

                ELSE
*/
               //                    IF  _HMG_SYSDATA [ 39 ] [ix] <> value [1]   .OR.   _HMG_SYSDATA [ 15 ] [ix] <> value [2]   // Remove, April 2016

               _HMG_SYSDATA[ 39 ] [ ix ] := value[ 1 ]
               _HMG_SYSDATA[ 15 ] [ ix ] := value[ 2 ]

               GRID_CheckRowCol( ix )                                 // ADD, April 2016

               ListView_SetCursel( c, _HMG_SYSDATA[ 39 ] [ ix ] )
               ListView_EnsureVisible( c, _HMG_SYSDATA[ 39 ] [ ix ] )

               IF _HMG_SYSDATA[ 39 ] [ ix ] <> value[ 1 ] .OR. _HMG_SYSDATA[ 15 ] [ ix ] <> value[ 2 ]                                      // ADD, April 2016
                  _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ ix ], ix )
               ENDIF

               RedrawWindow( _HMG_SYSDATA[ 3 ] [ ix ] )

               //                    ENDIF

               //                ENDIF

            ENDIF

         ENDIF

      CASE T == "TAB"
         TABCTRL_SETCURSEL( c, value )

         y := GetControlIndex( ControlName, ParentForm )

         UpdateTab( y )

         _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ y ], y )

      CASE T == "DATEPICK"
         IF EMPTY( Value )
            SetDatePickNull( c )
         ELSE
            SetDatePick( c, YEAR( value ), MONTH( value ), DAY( value ) )
         ENDIF
         _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ ix ], ix )

      CASE T == "TIMEPICK"                                            //   ( Dr. Claudio Soto, April 2013 )
         IF EMPTY( Value )
            SetTimePick( c, - 1, - 1, - 1 )                           // Set Current Time
         ELSE
            TimeValue24h := HMG_TimeToValue( Value )
            SetTimePick( c, TimeValue24h[ 1 ], TimeValue24h[ 2 ], TimeValue24h[ 3 ] )
         ENDIF
         _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ ix ], ix )    // On Change

      CASE T == "PROGRESSBAR"
         SendMessage( c, PBM_SETPOS, value, 0 )
      CASE T == "SLIDER"
         SendMessage( c, TBM_SETPOS, 1, value )
         _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ ix ], ix )
      CASE T == "STATUS"
         SetStatus( C, value )
      CASE T == "MULTILIST"
         LISTBOXSETMULTISEL( c, value )
      CASE T == "MULTIGRID"
         LISTVIEWSETMULTISEL( c, value )

         IF HMG_LEN( value ) > 0
            ListView_EnsureVisible( C, VALUE[ 1 ] )
         ENDIF

      CASE T == "TOOLBUTTON"
#ifdef _NEW_MethodToolButtonChecked_
         CheckToolButton( _HMG_SYSDATA[ 26 ] [ ix ], NIL, value, _HMG_SYSDATA[ 5 ] [ ix ] )                                                 // ADD
#else
         CheckToolButton( _HMG_SYSDATA[ 26 ] [ ix ], _HMG_SYSDATA[ 8 ] [ ix ] - 1, value )
#endif

   ENDCASE
RETURN ( retval )

*+--------------------------------------------------------------------
*+
*+    Procedure GRID_CheckRowCol()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _setvalue()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE GRID_CheckRowCol( ix )                                      // ADD, April 2016

LOCAL hWnd := _HMG_SYSDATA[ 3 ] [ ix ]

   // nRow cellnavigation
   IF ListView_GetItemCount( hWnd ) == 0
      _HMG_SYSDATA[ 39 ] [ ix ] := 0
   ELSEIF _HMG_SYSDATA[ 39 ] [ ix ] <= 0
      _HMG_SYSDATA[ 39 ] [ ix ] := 1
   ELSEIF _HMG_SYSDATA[ 39 ] [ ix ] > ListView_GetItemCount( hWnd )
      _HMG_SYSDATA[ 39 ] [ ix ] := ListView_GetItemCount( hWnd )
   ENDIF

   // nCol cellnavigation
   IF ListView_GetColumnCount( hWnd ) == 0
      _HMG_SYSDATA[ 15 ] [ ix ] := 0
   ELSEIF _HMG_SYSDATA[ 15 ] [ ix ] <= 0
      _HMG_SYSDATA[ 15 ] [ ix ] := 1
   ELSEIF _HMG_SYSDATA[ 15 ] [ ix ] > ListView_GetColumnCount( hWnd )
      _HMG_SYSDATA[ 15 ] [ ix ] := ListView_GetColumnCount( hWnd )
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Function _AddItem()
*+
*+    Called from ( h_controlmisc.prg )   4 - function domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _AddItem( ControlName, ParentForm, Value, Parent, aImage, Id )

LOCAL t, c, NewHandle, TempHandle, i, ix, aPos, ChildHandle, BackHandle, ParentHandle
LOCAL TreeItemHandle                                                  // Tree+
LOCAL ImgDef, iUnSel, iSel

   ix := GetControlIndex( ControlName, ParentForm )

   T = _HMG_SYSDATA[ 1 ] [ ix ]

   c = _HMG_SYSDATA[ 3 ] [ ix ]

   IF VALTYPE( Id ) == 'U'
      Id := 0
   ENDIF

   IF VALTYPE( aImage ) == 'N'
      Id := aImage
   ENDIF

   DO CASE
      CASE T == "TREE"

         IF _HMG_SYSDATA[ 9 ] [ ix ] == .F.

            IF Parent > TreeView_GetCount( c ) .OR. Parent < 0
               MsgHMGError( "Additem Method:  Invalid Parent Value. Program Terminated" )
            ENDIF

         ENDIF

         ImgDef := IIF( VALTYPE( aImage ) == "A", HMG_LEN( aImage ), 0 )                                                                    //Tree+

         IF Parent != 0

            IF _HMG_SYSDATA[ 9 ] [ ix ] == .F.
               TreeItemHandle := _HMG_SYSDATA[ 7 ] [ ix ] [ Parent ]
            ELSE
               aPos := ASCAN( _HMG_SYSDATA[ 25 ] [ ix ], Parent )

               IF aPos == 0
                  MsgHMGError( "Additem Method: Invalid Parent Value. Program Terminated" )
               ENDIF

               TreeItemHandle := _HMG_SYSDATA[ 7 ] [ ix ] [ aPos ]

            ENDIF

            IF ImgDef == 0

               iUnsel := 2                                            // Pointer to defalut Node Bitmaps, no Bitmap loaded
               iSel := 3
            ELSE
               iUnSel := AddTreeViewBitmap( c, aImage[ 1 ], _HMG_SYSDATA[ 39 ] [ ix ] ) - 1
               iSel := IIF( ImgDef == 1, iUnSel, AddTreeViewBitmap( c, aImage[ 2 ], _HMG_SYSDATA[ 39 ] [ ix ] ) - 1 )
               // If only one bitmap in array iSel = iUnsel, only one Bitmap loaded
            ENDIF

            NewHandle := AddTreeItem( c, TreeItemHandle, Value, iUnsel, iSel, Id, _IS_TREE_ITEM_ )

            //  Determine Position of New Item

            TempHandle := TreeView_GetChild( c, TreeItemHandle )

            i := 0

            DO WHILE .t.

               i ++

               IF TempHandle == NewHandle
                  EXIT
               ENDIF

               ChildHandle := TreeView_GetChild( c, TempHandle )

               IF ChildHandle == 0
                  BackHandle := TempHandle
                  TempHandle := TreeView_GetNextSibling( c, TempHandle )
               ELSE
                  i ++
                  BackHandle := Childhandle
                  TempHandle := TreeView_GetNextSibling( c, ChildHandle )
               ENDIF

               DO WHILE TempHandle == 0

                  ParentHandle := TreeView_GetParent( c, BackHandle )

                  TempHandle := TreeView_GetNextSibling( c, ParentHandle )

                  IF TempHandle == 0
                     BackHandle := ParentHandle
                  ENDIF

               ENDDO

            ENDDO

            //  Resize Array

            ASIZE( _HMG_SYSDATA[ 7 ] [ ix ], TreeView_GetCount( c ) )                                                                       // nTreeItemHandle
            ASIZE( _HMG_SYSDATA[ 25 ] [ ix ], TreeView_GetCount( c ) )                                                                      // nID
            ASIZE( _HMG_SYSDATA[ 32 ] [ ix ], TreeView_GetCount( c ) )                                                                      // cargo

            //  Insert New Element

            IF _HMG_SYSDATA[ 9 ] [ ix ] == .F.
               AINS( _HMG_SYSDATA[ 7 ] [ ix ], Parent + i )           // nTreeItemHandle
               AINS( _HMG_SYSDATA[ 25 ] [ ix ], Parent + i )          // nID
               AINS( _HMG_SYSDATA[ 32 ] [ ix ], Parent + i )          // cargo
            ELSE
               AINS( _HMG_SYSDATA[ 7 ] [ ix ], aPos + i )             // nTreeItemHandle
               AINS( _HMG_SYSDATA[ 25 ] [ ix ], aPos + i )            // nID
               AINS( _HMG_SYSDATA[ 32 ] [ ix ], aPos + i )            // cargo
            ENDIF

            //  Assign Handle

            IF _HMG_SYSDATA[ 9 ] [ ix ] == .F.
               _HMG_SYSDATA[ 7 ] [ ix ] [ Parent + i ] := NewHandle
               _HMG_SYSDATA[ 25 ] [ ix ] [ Parent + i ] := Id
               _HMG_SYSDATA[ 32 ] [ ix ] [ Parent + i ] := NIL        // cargo
            ELSE

               IF ASCAN( _HMG_SYSDATA[ 25 ] [ ix ], Id ) != 0
                  MsgHMGError( "Additem Method:  Item Id " + ALLTRIM( STR( Id ) ) + " Already In Use. Program Terminated" )
               ENDIF

               _HMG_SYSDATA[ 7 ] [ ix ] [ aPos + i ] := NewHandle
               _HMG_SYSDATA[ 25 ] [ ix ] [ aPos + i ] := Id
               _HMG_SYSDATA[ 32 ] [ ix ] [ aPos + i ] := NIL          // cargo

            ENDIF

         ELSE
            TreeItemHandle := 0

            IF ImgDef == 0

               iUnsel := 0                                            // Pointer to defalut Node Bitmaps, no Bitmap loaded
               iSel := 1
            ELSE
               iUnSel := AddTreeViewBitmap( c, aImage[ 1 ], _HMG_SYSDATA[ 39 ] [ ix ] ) - 1
               iSel := IIF( ImgDef == 1, iUnSel, AddTreeViewBitmap( c, aImage[ 2 ], _HMG_SYSDATA[ 39 ] [ ix ] ) - 1 )
               // If only one bitmap in array iSel = iUnsel, only one Bitmap loaded
            ENDIF

            NewHandle := AddTreeItem( c, 0, Value, iUnsel, iSel, Id, _IS_TREE_ITEM_ )

            IF _HMG_SYSDATA[ 9 ] [ ix ] == .T.
               IF ASCAN( _HMG_SYSDATA[ 25 ] [ ix ], Id ) != 0
                  MsgHMGError( "Additem Method:  Item Id Already In Use. Program Terminated" )
               ENDIF
            ENDIF

            AADD( _HMG_SYSDATA[ 7 ] [ ix ], NewHandle )               // nTreeItemHandle
            AADD( _HMG_SYSDATA[ 25 ] [ ix ], Id )                     // nID
            AADD( _HMG_SYSDATA[ 32 ] [ ix ], NIL )                    // cargo

         ENDIF

      CASE T == "COMBO"

         IF VALTYPE( Value ) == 'A'
            ImageComboAddItem( c, value[ 1 ], value[ 2 ], - 1 )
         ELSE
            ComboAddString( c, value )
         ENDIF

      CASE T == "LIST" .OR. T == "MULTILIST"
         ListBoxAddstring( c, value )

      CASE T == "GRID" .OR. T == "MULTIGRID"

         IF _HMG_SYSDATA[ 40 ] [ ix ] [ 9 ] == .F.                    // OWNERDATA
            _AddGridRow( ControlName, ParentForm, value )
         ENDIF

   ENDCASE
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _DeleteItem()
*+
*+    Called from ( h_controlmisc.prg )   1 - function domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _DeleteItem( ControlName, ParentForm, Value )

LOCAL t, c, BeforeCount, AfterCount, DeletedCount, i, ix, aPos
LOCAL TreeItemHandle

   ix := GetControlIndex( ControlName, ParentForm )

   T = _HMG_SYSDATA[ 1 ] [ ix ]
   c = _HMG_SYSDATA[ 3 ] [ ix ]

   DO CASE
      CASE T == "TREE"

         BeforeCount := TreeView_GetCount( c )

         IF _HMG_SYSDATA[ 9 ] [ ix ] == .F.                           // ITEMIDS == .F.

            IF Value > BeforeCount .OR. Value < 1
               MsgHMGError( "DeleteItem Method: Invalid Item Specified. Program Terminated" )
            ENDIF

            TreeItemHandle := _HMG_SYSDATA[ 7 ] [ ix ] [ Value ]      // nTreeItemHandle
            DELETETREEITEM( c, TreeItemHandle )

         ELSE

            aPos := ASCAN( _HMG_SYSDATA[ 25 ] [ ix ], Value )         // nID

            IF aPos == 0
               MsgHMGError( "DeleteItem Method: Invalid Item Id. Program Terminated" )
            ENDIF

            TreeItemHandle := _HMG_SYSDATA[ 7 ] [ ix ] [ aPos ]       // nTreeItemHandle
            DELETETREEITEM( c, TreeItemHandle )

         ENDIF

         AfterCount := TreeView_GetCount( c )

         DeletedCount := BeforeCount - AfterCount

         IF _HMG_SYSDATA[ 9 ] [ ix ] == .F.                           // ITEMIDS == .F.

            FOR i := 1 TO DeletedCount
               ADEL( _HMG_SYSDATA[ 7 ] [ ix ], Value )                // nTreeItemHandle
               ADEL( _HMG_SYSDATA[ 32 ] [ ix ], Value )               // cargo
            NEXT i

         ELSE
            FOR i := 1 TO DeletedCount
               ADEL( _HMG_SYSDATA[ 7 ] [ ix ], aPos )                 // nTreeItemHandle
               ADEL( _HMG_SYSDATA[ 25 ] [ ix ], aPos )                // nID
               ADEL( _HMG_SYSDATA[ 32 ] [ ix ], aPos )                // cargo
            NEXT i

         ENDIF

         ASIZE( _HMG_SYSDATA[ 7 ] [ ix ], AfterCount )                // nTreeItemHandle
         ASIZE( _HMG_SYSDATA[ 25 ] [ ix ], AfterCount )               // nID
         ASIZE( _HMG_SYSDATA[ 32 ] [ ix ], AfterCount )               // cargo

      CASE T == "LIST" .OR. T == "MULTILIST"
         ListBoxDeleteString( c, value )
      CASE T == "COMBO"
         ComboBoxDeleteString( c, value )
         RedrawWindow( c )
      CASE T == "GRID" .OR. T == "MULTIGRID"

         IF _HMG_SYSDATA[ 40 ] [ ix ] [ 9 ] == .F.                    // OWNERDATA

            IF _HMG_SYSDATA[ 32 ] [ ix ] == .T. .AND. T == "GRID"     // cellnavigation
               /*
               IF _HMG_SYSDATA [ 39 ] [ix] < value

                    ListViewDeleteString ( c , value )

               ELSEIF _HMG_SYSDATA [ 39 ] [ix] == value   // nRow cellnavigation

                    ListViewDeleteString ( c , value )

                   _SetValue( NIL, NIL, { value, _HMG_SYSDATA [ 15 ] [ix] } , ix )   // ADD, April 2016

                   // _HMG_SYSDATA [ 39 ] [ix] := 0   // nRow cellnavigation    Remove, April 2016
                   // _HMG_SYSDATA [ 15 ] [ix] := 0   // nCol cellnavigation    Remove, April 2016

                ELSEIF  _HMG_SYSDATA [ 39 ] [ix] > value

                    ListViewDeleteString ( c , value )

                    _HMG_SYSDATA [ 39 ] [ix] --   // nRow cellnavigation

                ENDIF
*/

               ListViewDeleteString( c, value )
               _HMG_SYSDATA[ 39 ] [ ix ] := LISTVIEW_GETFOCUSEDITEM( c )                                                                    // ADD, April 2016

            ELSE

               ListViewDeleteString( c, value )

            ENDIF

         ENDIF

   ENDCASE
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _DeleteAllItems()
*+
*+    Called from ( h_controlmisc.prg )   1 - function domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _DeleteAllItems( ControlName, ParentForm )

LOCAL t, c, i

   i = GetControlIndex( ControlName, ParentForm )

   T = _HMG_SYSDATA[ 1 ] [ i ]
   c = _HMG_SYSDATA[ 3 ] [ i ]

   DO CASE

      CASE T == "TREE"
         DELETEALLTREEITEMS( c, _HMG_SYSDATA[ 7 ] [ i ] )
         ASIZE( _HMG_SYSDATA[ 7 ] [ i ], 0 )                          // nTreeItemHandle
         ASIZE( _HMG_SYSDATA[ 25 ] [ i ], 0 )                         // nID
         ASIZE( _HMG_SYSDATA[ 32 ] [ i ], 0 )                         // cargo

      CASE T == "LIST" .OR. T == "MULTILIST"
         ListBoxReset( c )
      CASE T == "COMBO"
         ComboBoxReset( c )
      CASE T == "GRID" .OR. T == "MULTIGRID"

         IF _HMG_SYSDATA[ 40 ] [ i ] [ 9 ] == .F.

            ListViewReset( c )

            IF _HMG_SYSDATA[ 32 ] [ i ] == .T. .AND. T == "GRID"
               _HMG_SYSDATA[ 15 ] [ i ] := 0
               _HMG_SYSDATA[ 39 ] [ i ] := 0
            ENDIF

         ENDIF

   ENDCASE
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function GetControlIndex()
*+
*+    Called from ( h_browse.prg )   1 - procedure _browseupdate()
*+                                   1 - procedure _browsenext()
*+                                   1 - procedure _browseprior()
*+                                   1 - procedure _browsehome()
*+                                   1 - procedure _browseend()
*+                                   1 - procedure _browseup()
*+                                   1 - procedure _browsedown()
*+                                   1 - procedure _browserefresh()
*+                                   1 - procedure _browsesetvalue()
*+                                   1 - function _browsegetvalue()
*+                                   1 - function _browsedelete()
*+                                   1 - procedure _browseinplaceappend()
*+                                   1 - function _setbrowseallowedit()
*+                                   1 - function _setbrowseallowappend()
*+                                   1 - function _setbrowseallowdelete()
*+                                   1 - function _setbrowseinputitems()
*+                                   1 - function _setbrowsedisplayitems()
*+                                   1 - function _getbrowseinputitems()
*+                                   1 - function _getbrowsedisplayitems()
*+                                   1 - function _getbrowseallowedit()
*+                                   1 - function _getbrowseallowappend()
*+                                   1 - function _getbrowseallowdelete()
*+                ( h_grid.prg )   1 - function _addgridrow()
*+                ( h_gridex.prg )   1 - function _gridex_columncount()
*+                                   1 - function _gridex_getcolumncontrol()
*+                                   1 - function _gridex_setcolumncontrol()
*+                                   1 - function _gridex_setcolumndisplayposition()
*+                                   1 - function _gridex_set_default_column_control()
*+                                   1 - function _gridex_delete_column_control()
*+                                   1 - function _gridex_add_column_control()
*+                ( h_timepicker.prg )   1 - procedure _datatimepickersave()
*+                ( h_checkbox.prg )   1 - procedure _datacheckboxsave()
*+                ( h_controlmisc.prg )   1 - function _getvalue()
*+                                   2 - function _setvalue()
*+                                   1 - function _additem()
*+                                   1 - function _deleteitem()
*+                                   1 - function _deleteallitems()
*+                                   1 - function _setfocus()
*+                                   1 - function _disablecontrol()
*+                                   1 - function _enablecontrol()
*+                                   1 - function _showcontrol()
*+                                   1 - function _hidecontrol()
*+                                   1 - function _setitem()
*+                                   1 - function _getitem()
*+                                   1 - function _setcontrolsizepos()
*+                                   1 - function _setpicture()
*+                                   1 - function _getpicture()
*+                                   1 - function _enabletoolbarbutton()
*+                                   1 - function _disabletoolbarbutton()
*+                                   1 - function _getcontrolaction()
*+                                   1 - function _gettooltip()
*+                                   1 - function _settooltip()
*+                                   1 - function _setrangemin()
*+                                   1 - function _setrangemax()
*+                                   1 - function _getrangemin()
*+                                   1 - function _getrangemax()
*+                                   1 - function _setmulticaption()
*+                                   1 - function _getmulticaption()
*+                                   1 - function inputwindow()
*+                                   1 - function setmethodcode()
*+                                   5 - function _releasecontrol()
*+                                   1 - function _iscontrolvisible()
*+                                   1 - function _setcaretpos()
*+                                   1 - function _getcaretpos()
*+                                   1 - function _redrawcontrol()
*+                                   1 - function _savedata()
*+                                   1 - function _setfontcolor()
*+                                   1 - function _setbackcolor()
*+                                   1 - function _getfontcolor()
*+                                   1 - function _getbackcolor()
*+                                   1 - function _iscontrolenabled()
*+                                   1 - function _setstatusicon()
*+                                   1 - function _getcaption()
*+                                   1 - function _setaddress()
*+                                   1 - function _getaddress()
*+                                   1 - function _hmg_setheaderimages()
*+                                   1 - function _hmg_getheaderimages()
*+                                   4 - function setproperty()
*+                                   4 - function getproperty()
*+                                   2 - function getcontroltabpage()
*+                                  10 - function domethod()
*+                                   1 - function _iscontrolsplitboxed()
*+                                   1 - function _gridex_getproperty()
*+                                   1 - function _gridex_setproperty()
*+                                   1 - function _gridex_domethod()
*+                                   1 - function _tree_getproperty()
*+                                   3 - function _tree_setproperty()
*+                                   1 - function _setcargo()
*+                                   1 - function _getcargo()
*+                                   1 - procedure settooltipcustomdrawcontrol()
*+                ( h_datepicker.prg )   1 - procedure _datadatepickersave()
*+                ( h_editbox.prg )   1 - procedure _dataeditboxsave()
*+                ( h_font.prg )   1 - function _getfontname()
*+                                   1 - function _getfontsize()
*+                                   1 - function _getfontbold()
*+                                   1 - function _getfontitalic()
*+                                   1 - function _getfontunderline()
*+                                   1 - function _getfontstrikeout()
*+                                   1 - function _setfontname()
*+                                   1 - function _setfontsize()
*+                                   1 - function _setfontbold()
*+                                   1 - function _setfontitalic()
*+                                   1 - function _setfontunderline()
*+                                   1 - function _setfontstrikeout()
*+                                   1 - function getcontrolfont()
*+                                   1 - function getcontrolfonthandle()
*+                                   1 - function setcontrolfont()
*+                                   1 - function changecontrolfontsize()
*+                ( h_menu.prg )   1 - function _disablemenuitem()
*+                                   1 - function _enablemenuitem()
*+                                   1 - function _checkmenuitem()
*+                                   1 - function _uncheckmenuitem()
*+                                   1 - function _ismenuitemchecked()
*+                                   1 - function _ismenuitemenabled()
*+                                   1 - function _definedropdownmenu()
*+                ( h_radio.prg )   1 - procedure _setradiogroupreadonly()
*+                                   1 - function _getradiogroupreadonly()
*+                ( h_richeditbox.prg )   1 - procedure _dataricheditboxsave()
*+                ( h_tab.prg )   1 - function _addtabpage()
*+                                   2 - function _addtabcontrol()
*+                                   1 - function _deletetabpage()
*+                ( h_textbox.prg )   1 - procedure _datatextboxsave()
*+                ( h_tree.prg )   1 - procedure _collapse()
*+                                   1 - procedure _expand()
*+                                   1 - function treeitemgethandle()
*+                                   1 - function treeitemgetvaluebyitemhandle()
*+                                   1 - function treeaddimage()
*+                                   1 - function treeitemgetallvalue()
*+                                   1 - function treeitemgetfirstitemvalue()
*+                                   1 - procedure treeitemsetdefaultallnodeflag()
*+                                   1 - procedure treeitemsort()
*+                ( h_winapimisc.prg )   1 - function _hmg_setcontroldata()
*+                                   1 - function _hmg_getcontroldata()
*+                ( h_windows.prg )  12 - function events()
*+                                   1 - function stopcontroleventprocedure()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetControlIndex( ControlName, ParentForm )

LOCAL mVar
   mVar := '_' + ParentForm + '_' + ControlName
RETURN ( &mVar )

*+--------------------------------------------------------------------
*+
*+    Function GetControlName()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetControlName( ControlName, ParentForm )

LOCAL mVar, i
   mVar := '_' + ParentForm + '_' + ControlName
   i := &mVar
   IF i == 0
      RETURN ''
   ENDIF
RETURN ( _HMG_SYSDATA[ 2 ] [ &mVar ] )

*+--------------------------------------------------------------------
*+
*+    Function GetControlHandle()
*+
*+    Called from ( h_browse.prg )   2 - procedure _inplaceeditok()
*+                ( h_grid.prg )   1 - function _addgridrow()
*+                                   8 - procedure _addgridcolumn()
*+                                   5 - procedure _deletegridcolumn()
*+                                   8 - function _hmg_gridinplaceedit()
*+                ( h_gridex.prg )   1 - function _gridex_columncount()
*+                                   1 - function _gridex_getcolumncontrol()
*+                                   3 - function _gridex_setcolumncontrol()
*+                                   1 - function _gridex_getcolumndisplayposition()
*+                                   2 - function _gridex_setcolumndisplayposition()
*+                                   1 - function _gridex_setbkimage()
*+                                   1 - function _gridex_getbkimage()
*+                                   1 - function _gridex_getcellvalue()
*+                                   1 - function _gridex_setcellvalue()
*+                                   1 - function _gridex_getrawcellvalue()
*+                                   1 - function _gridex_setrawcellvalue()
*+                ( h_controlmisc.prg )   1 - function _getvalue()
*+                                   1 - function _setfocus()
*+                                   1 - function _disablecontrol()
*+                                   1 - function _enablecontrol()
*+                                   1 - function _showcontrol()
*+                                   1 - function _hidecontrol()
*+                                   1 - function _setcontrolsizepos()
*+                                   1 - function _getitemcount()
*+                                   4 - function _setpicture()
*+                                   1 - function getcolumnheadersize()
*+                                   1 - function _inplaceeditopt()
*+                                   1 - function _hmg_printer_spltchldmouseclick()
*+                                   1 - function createthumbnails()
*+                                   6 - function setproperty()
*+                                   5 - function getproperty()
*+                                   2 - function domethod()
*+                                  10 - function _gridex_getproperty()
*+                                  15 - function _gridex_setproperty()
*+                                   5 - function _gridex_domethod()
*+                                   4 - function _tree_getproperty()
*+                                   6 - function _tree_setproperty()
*+                                   1 - function _richeditbox_getproperty()
*+                                   1 - function _richeditbox_setproperty()
*+                                   1 - function _richeditbox_domethod()
*+                ( h_font.prg )   1 - function setcontrolfont()
*+                ( h_menu.prg )   1 - function _definecontrolcontextmenu()
*+                                   1 - function iscontrolcontextmenudefined()
*+                                   1 - function releasecontrolcontextmenu()
*+                ( h_monthcal.prg )   1 - function getmonthcalendarcolor()
*+                                   1 - function setmonthcalendarcolor()
*+                ( h_tree.prg )   1 - function treeitemgetparenthandle()
*+                                   1 - function treeitemgetroothandle()
*+                                   1 - function treeitemgetvaluebyitemhandle()
*+                                   1 - function treegetimagecount()
*+                                   1 - function treeaddimage()
*+                                   1 - function treeitemgetrootvalue()
*+                                   1 - function treeitemgetparentvalue()
*+                                   1 - function treeitemgetchildvalue()
*+                                   1 - function treeitemgetsiblingvalue()
*+                                   1 - function treeitemgetpathvalue()
*+                                   1 - function treeitemistruenode()
*+                                   1 - function treeitemsetnodeflag()
*+                                   1 - function treeitemgetnodeflag()
*+                                   1 - function treeitemsetimageindex()
*+                                   1 - function treeitemgetimageindex()
*+                                   1 - procedure treeitemsetdefaultallnodeflag()
*+                                   1 - procedure treeitemsort()
*+                                   1 - function treesettextcolor()
*+                                   1 - function treesetbackcolor()
*+                                   1 - function treesetlinecolor()
*+                                   1 - function treeitemisexpand()
*+                ( h_windows.prg )   8 - function events()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetControlHandle( ControlName, ParentForm )

LOCAL mVar, i
   mVar := '_' + ParentForm + '_' + ControlName
   i := &mVar
   IF i == 0
      RETURN 0
   ENDIF
RETURN ( _HMG_SYSDATA[ 3 ] [ &mVar ] )

*+--------------------------------------------------------------------
*+
*+    Function GetControlContainerHandle()
*+
*+    Called from ( h_controlmisc.prg )   1 - function setproperty()
*+                                   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetControlContainerHandle( ControlName, ParentForm )

LOCAL mVar, i
   mVar := '_' + ParentForm + '_' + ControlName
   i := &mVar
   IF i == 0
      RETURN 0
   ENDIF
RETURN ( _HMG_SYSDATA[ 26 ] [ &mVar ] )

*+--------------------------------------------------------------------
*+
*+    Function GetControlParentHandle()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _getvalue()
*+                                   1 - function _disablecontrol()
*+                                   1 - function _enablecontrol()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetControlParentHandle( ControlName, ParentForm )

LOCAL mVar, i
   mVar := '_' + ParentForm + '_' + ControlName
   i := &mVar
   IF i == 0
      RETURN 0
   ENDIF
RETURN ( _HMG_SYSDATA[ 4 ] [ &mVar ] )

*+--------------------------------------------------------------------
*+
*+    Function GetControlId()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _disablecontrol()
*+                                   1 - function _enablecontrol()
*+                                   1 - function _enabletoolbarbutton()
*+                                   1 - function _disabletoolbarbutton()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetControlId( ControlName, ParentForm )

LOCAL mVar, i
   mVar := '_' + ParentForm + '_' + ControlName
   i := &mVar
   IF i == 0
      RETURN 0
   ENDIF
RETURN ( _HMG_SYSDATA[ 5 ] [ &mVar ] )

*+--------------------------------------------------------------------
*+
*+    Function GetControlType()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _getvalue()
*+                                   1 - function _setfocus()
*+                                   1 - function _disablecontrol()
*+                                   1 - function _enablecontrol()
*+                                   1 - function _showcontrol()
*+                                   1 - function _hidecontrol()
*+                                   1 - function _setcontrolsizepos()
*+                                   1 - function _getitemcount()
*+                                   1 - function _setpicture()
*+                                   1 - function _setrangemin()
*+                                   1 - function _setrangemax()
*+                                   1 - function _setmulticaption()
*+                                   2 - function inputwindow()
*+                                   1 - function _inputwindowok()
*+                                   1 - function _releasecontrol()
*+                                   1 - function _iscontrolenabled()
*+                                   1 - function _hmg_setheaderimages()
*+                                   1 - function _hmg_getheaderimages()
*+                                   4 - function setproperty()
*+                                   3 - function getproperty()
*+                                   4 - function domethod()
*+                                   2 - function _gridex_getproperty()
*+                                   2 - function _gridex_setproperty()
*+                                   2 - function _gridex_domethod()
*+                                   1 - function _tree_getproperty()
*+                                   1 - function _tree_setproperty()
*+                                   1 - function _tree_domethod()
*+                                   1 - function _richeditbox_getproperty()
*+                                   1 - function _richeditbox_setproperty()
*+                                   1 - function _richeditbox_domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetControlType( ControlName, ParentForm )

LOCAL mVar, i
   mVar := '_' + ParentForm + '_' + ControlName
   i := &mVar
   IF i == 0
      RETURN ''
   ENDIF
RETURN ( _HMG_SYSDATA[ 1 ] [ &mVar ] )

*+--------------------------------------------------------------------
*+
*+    Function GetControlValue()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetControlValue( ControlName, ParentForm )

LOCAL mVar, i
   mVar := '_' + ParentForm + '_' + ControlName
   i := &mVar
   IF i == 0
      RETURN Nil
   ENDIF
RETURN ( _HMG_SYSDATA[ 8 ] [ &mVar ] )

*+--------------------------------------------------------------------
*+
*+    Function GetControlPageMap()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetControlPageMap( ControlName, ParentForm )

LOCAL mVar, i
   mVar := '_' + ParentForm + '_' + ControlName
   i := &mVar
   IF i == 0
      RETURN {}
   ENDIF
RETURN ( _HMG_SYSDATA[ 7 ] [ &mVar ] )

*+--------------------------------------------------------------------
*+
*+    Function _IsControlDefined()
*+
*+    Called from ( h_browse.prg )   1 - function _definebrowse()
*+                ( h_grid.prg )   1 - function _definegrid()
*+                                   6 - procedure _hmg_setgridcelleditvalue()
*+                ( h_timepicker.prg )   1 - function _definetimepick()
*+                ( h_button.prg )   1 - function _definebutton()
*+                                   1 - function _defineimagebutton()
*+                                   1 - function _definemixedbutton()
*+                ( h_checkbox.prg )   1 - function _definecheckbox()
*+                                   1 - function _definecheckbutton()
*+                                   1 - function _defineimagecheckbutton()
*+                ( h_combo.prg )   1 - function _definecombo()
*+                ( h_controlmisc.prg )   2 - function _releasecontrol()
*+                                   1 - function createthumbnails()
*+                                   1 - function _hmg_printer_preview_onpaint()
*+                                   1 - function _defineactivex()
*+                                   9 - function setproperty()
*+                                   6 - function getproperty()
*+                                   5 - function domethod()
*+                                   1 - function _gridex_getproperty()
*+                                   1 - function _gridex_setproperty()
*+                                   1 - function _gridex_domethod()
*+                                   1 - function _tree_getproperty()
*+                                   1 - function _tree_setproperty()
*+                                   1 - function _tree_domethod()
*+                                   1 - function _richeditbox_getproperty()
*+                                   1 - function _richeditbox_setproperty()
*+                                   1 - function _richeditbox_domethod()
*+                ( h_datepicker.prg )   1 - function _definedatepick()
*+                ( h_editbox.prg )   1 - function _defineeditbox()
*+                ( h_frame.prg )   1 - function _defineframe()
*+                ( h_image.prg )   1 - function _defineimage()
*+                ( h_ipaddress.prg )   1 - function _defineipaddress()
*+                ( h_label.prg )   1 - function _definelabel()
*+                ( h_listbox.prg )   1 - function _definelistbox()
*+                ( h_media.prg )   1 - function _defineplayer()
*+                                   1 - function _defineanimatebox()
*+                ( h_monthcal.prg )   1 - function _definemonthcal()
*+                ( h_progressbar.prg )   1 - function _defineprogressbar()
*+                ( h_radio.prg )   1 - function _defineradiogroup()
*+                ( h_richeditbox.prg )   1 - function _definericheditbox()
*+                ( h_slider.prg )   1 - function _defineslider()
*+                ( h_spinner.prg )   1 - function _definespinner()
*+                ( h_tab.prg )   1 - function _definetab()
*+                ( h_textbox.prg )   1 - function _definetextbox()
*+                                   1 - function _definemaskedtextbox()
*+                                   1 - function _definecharmasktextbox()
*+                ( h_timer.prg )   1 - function _definetimer()
*+                ( h_toolbar.prg )   1 - function _definetoolbar()
*+                                   1 - function _definetoolbutton()
*+                ( h_tree.prg )   1 - function _definetree()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _IsControlDefined( ControlName, FormName )

LOCAL mVar, i, r

   ControlName := CharRem( CHR( 34 ) + CHR( 39 ), ControlName )
   FormName := CharRem( CHR( 34 ) + CHR( 39 ), FormName )

   mVar := '_' + FormName + '_' + ControlName

   IF TYPE( mVar ) = 'U'
      RETURN ( .F. )
   ENDIF
   IF TYPE( mVar ) = 'N'
      i := &mVar
      IF i == 0
         RETURN .f.
      ENDIF
      r := _HMG_SYSDATA[ 13 ] [ i ]
      r := .NOT. r
      RETURN ( r )
   ENDIF
RETURN .F.

*+--------------------------------------------------------------------
*+
*+    Function _SetFocus()
*+
*+    Called from ( h_controlmisc.prg )   1 - function domethod()
*+                ( h_windows.prg )   1 - procedure _setactivationfocus()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetFocus( ControlName, ParentForm, ix )

LOCAL H, T, MaskStart, X, i, j, L, F

   IF PCOUNT() == 2
      i := GetControlIndex( ControlName, ParentForm )
      H = GetControlHandle( ControlName, ParentForm )
      T = GetControlType( ControlName, ParentForm )
   ELSE
      i := ix
      H := _HMG_SYSDATA[ 3 ] [ ix ]
      T := _HMG_SYSDATA[ 1 ] [ ix ]
   ENDIF

   DO CASE

      CASE T == 'TEXT' .OR. T == 'NUMTEXT' .OR. T == 'MASKEDTEXT'
         setfocus( H )
         SendMessage( H, 177, 0, - 1 )                                // EM_SETSEL

      CASE T == "CHARMASKTEXT"

         setfocus( H )

         FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 9 ] [ i ] )
            IF HMG_ISDIGIT( HB_USUBSTR( _HMG_SYSDATA[ 9 ] [ i ], x, 1 ) ) .OR. HMG_ISALPHA( HB_USUBSTR( _HMG_SYSDATA[ 9 ] [ i ], x, 1 ) ) .OR. HB_USUBSTR( _HMG_SYSDATA[ 9 ] [ i ], x, 1 ) == '!'
               MaskStart := x
               EXIT
            ENDIF
         NEXT x

         IF MaskStart == 1
            SendMessage( H, EM_SETSEL, 0, - 1 )
         ELSE
            SendMessage( H, EM_SETSEL, MaskStart - 1, - 1 )
         ENDIF

      CASE T == 'BUTTON'

         IF _HMG_SYSDATA[ 38 ] [ i ] == .T.

            L := HMG_LEN( _HMG_SYSDATA[ 1 ] )

            // F := GetFormHandle( ParentForm )

            F := _HMG_SYSDATA[ 4 ] [ i ]

            FOR J := 1 TO L

               IF _HMG_SYSDATA[ 1 ] [ J ] == 'BUTTON'

                  IF _HMG_SYSDATA[ 4 ] [ J ] == F

                     SendMessage( _HMG_SYSDATA[ 3 ] [ J ], BM_SETSTYLE, LOWORD( BS_PUSHBUTTON ), 1 )
                     RedrawWindow( _HMG_SYSDATA[ 3 ] [ J ] )

                  ENDIF

               ENDIF

            NEXT

            setfocus( H )
            SendMessage( H, BM_SETSTYLE, LOWORD( BS_DEFPUSHBUTTON ), 1 )

         ENDIF

      CASE T == 'SPINNER'
         setfocus( H[ 1 ] )
      CASE T == 'RADIO'
         setfocus( H[ 1 ] )
      OTHERWISE
         setfocus( H )
   ENDCASE
   _HMG_SYSDATA[ 251 ] := .T.
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _DisableControl()
*+
*+    Called from ( h_controlmisc.prg )   1 - function setproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _DisableControl( ControlName, ParentForm )

LOCAL H, T, i, c, y, s, z, w

   T := GetControlType( ControlName, ParentForm )
   i := GetControlId( ControlName, ParentForm )
   h := GetControlParentHandle( ControlName, ParentForm )
   c := GetControlHandle( ControlName, ParentForm )
   y := GetControlIndex( ControlName, ParentForm )

   DO CASE

#ifdef COMPILEBROWSE

      CASE T == "BROWSE"
         DisableWindow( c )
         IF _HMG_SYSDATA[ 5 ] [ y ] != 0
            DisableWindow( _HMG_SYSDATA[ 5 ] [ y ] )
         ENDIF

#endif

      CASE T == "TOOLBUTTON"
         _DisableToolBarButton( ControlName, ParentForm )

      CASE T == "MENU" .OR. T == "POPUP"
         _DisableMenuItem( ControlName, ParentForm )

      CASE T == "TIMER"
         KillTimer( h, i )

      CASE T == "SPINNER"
         DisableWindow( c[ 1 ] )
         DisableWindow( c[ 2 ] )

      CASE T == "RADIOGROUP"
         FOR i := 1 TO HMG_LEN( c )
            DisableWindow( c[ i ] )
         NEXT i

      CASE T == "TAB"

         DisableWindow( c )

         s = TabCtrl_GetCurSel( _HMG_SYSDATA[ 3 ] [ y ] )
         FOR w = 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] [ y ] [ s ] )
            IF VALTYPE( _HMG_SYSDATA[ 7 ] [ y ] [ s ] [ w ] ) <> "A"
               DisableWindow( _HMG_SYSDATA[ 7 ] [ y ] [ s ] [ w ] )
            ELSE
               FOR z = 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] [ y ] [ s ] [ w ] )
                  DisableWindow( _HMG_SYSDATA[ 7 ] [ y ] [ s ] [ w ] [ z ] )
               NEXT z
            ENDIF
         NEXT w

      CASE T == "BUTTON"

         IF _HMG_SYSDATA[ 38 ] [ y ] == .T.

            SendMessage( c, BM_SETSTYLE, LOWORD( BS_PUSHBUTTON ), 1 )
            RedrawWindow( c )

            IF _HMG_SYSDATA[ 22 ] [ y ] == 'T'

               DisableWindow( c )

            ELSE

               IF ( _HMG_SYSDATA[ 22 ] [ y ] == 'M' ) .OR. ( _HMG_SYSDATA[ 22 ] [ y ] == 'I' .AND. IsAppThemed() )

                  IMAGELIST_DESTROY( _HMG_SYSDATA[ 37 ] [ y ] )
                  _HMG_SYSDATA[ 37 ] [ y ] := _SetMixedBtnPicture( _HMG_SYSDATA[ 3 ] [ y ], _HMG_SYSDATA[ 25 ] [ y ], _HMG_SYSDATA[ 26 ] [ y ], _HMG_SYSDATA[ 32 ] [ y ], _SET_BITMAP_GRAY )

                  // _SetMixedBtnPictureDisabled ()

                  RedrawWindow( c )
                  DisableWindow( c )

               ELSE

                  // NewHandle := GetDisabledBitmap( _HMG_SYSDATA [ 37 ] [y], _HMG_SYSDATA [ 39 ] [y] )

                  DeleteObject( _HMG_SYSDATA[ 37 ] [ y ] )
                  _HMG_SYSDATA[ 37 ] [ y ] := _SETBTNPICTURE( _HMG_SYSDATA[ 3 ] [ y ], _HMG_SYSDATA[ 25 ] [ y ], _HMG_SYSDATA[ 32 ] [ y ], _SET_BITMAP_GRAY )

                  RedrawWindow( c )
                  DisableWindow( c )

               ENDIF

            ENDIF

         ENDIF

      CASE T == "CHECKBOX"                                            // CHECKBUTTON ???

         IF _HMG_SYSDATA[ 38 ] [ y ] == .T.

            IF _HMG_SYSDATA[ 39 ] [ y ] == 1

               IF IsAppThemed()

                  IMAGELIST_DESTROY( _HMG_SYSDATA[ 37 ] [ y ] )
                  _HMG_SYSDATA[ 37 ] [ y ] := _SetMixedBtnPicture( _HMG_SYSDATA[ 3 ] [ y ], _HMG_SYSDATA[ 25 ] [ y ], _HMG_SYSDATA[ 26 ] [ y ], _HMG_SYSDATA[ 32 ] [ y ], _SET_BITMAP_GRAY )

                  //  _SetMixedBtnPictureDisabled ()

                  RedrawWindow( c )
                  DisableWindow( c )

               ELSE

                  //  NewHandle := GetDisabledBitmap ( _HMG_SYSDATA [ 37 ] [y] , .F. )

                  DeleteObject( _HMG_SYSDATA[ 37 ] [ y ] )
                  _HMG_SYSDATA[ 37 ] [ y ] := _SETBTNPICTURE( _HMG_SYSDATA[ 3 ] [ y ], _HMG_SYSDATA[ 25 ] [ y ], _HMG_SYSDATA[ 32 ] [ y ], _SET_BITMAP_GRAY )

                  RedrawWindow( c )
                  DisableWindow( c )

               ENDIF

            ELSE

               DisableWindow( c )

            ENDIF

         ENDIF

      OTHERWISE
         DisableWindow( c )
   ENDCASE
   _HMG_SYSDATA[ 38 ] [ y ] := .F.
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _EnableControl()
*+
*+    Called from ( h_controlmisc.prg )   1 - function setproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _EnableControl( ControlName, ParentForm )

LOCAL H, t, i, c, x, controlcount, y, s, z, w

   controlcount := HMG_LEN( _HMG_SYSDATA[ 2 ] )

   T = GetControlType( ControlName, ParentForm )
   i = GetControlId( ControlName, ParentForm )
   h = GetControlParentHandle( ControlName, ParentForm )
   c = GetControlHandle( ControlName, ParentForm )
   y := GetControlIndex( ControlName, ParentForm )

   DO CASE

#ifdef COMPILEBROWSE

      CASE T == "BROWSE"
         EnableWindow( c )
         IF _HMG_SYSDATA[ 5 ] [ y ] != 0
            EnableWindow( _HMG_SYSDATA[ 5 ] [ y ] )
         ENDIF

#endif

      CASE T == "TOOLBUTTON"
         _EnableToolBarButton( ControlName, ParentForm )
      CASE T == "MENU" .OR. T == "POPUP"
         _EnableMenuItem( ControlName, ParentForm )

      CASE T == "TIMER"
         FOR x := 1 TO controlcount
            IF _HMG_SYSDATA[ 5 ] [ x ] == i
               InitTimer( GetFormHandle( ParentForm ), _HMG_SYSDATA[ 5 ] [ x ], _HMG_SYSDATA[ 8 ] [ x ] )
               EXIT
            ENDIF
         NEXT x
      CASE T == "SPINNER"
         EnableWindow( c[ 1 ] )
         EnableWindow( c[ 2 ] )
      CASE T == "RADIOGROUP"
         FOR i := 1 TO HMG_LEN( c )
            EnableWindow( c[ i ] )
         NEXT i

      CASE T == "TAB"

         EnableWindow( c )

         s = TabCtrl_GetCurSel( _HMG_SYSDATA[ 3 ] [ y ] )
         FOR w = 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] [ y ] [ s ] )
            IF VALTYPE( _HMG_SYSDATA[ 7 ] [ y ] [ s ] [ w ] ) <> "A"
               EnableWindow( _HMG_SYSDATA[ 7 ] [ y ] [ s ] [ w ] )
            ELSE
               FOR z = 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] [ y ] [ s ] [ w ] )
                  EnableWindow( _HMG_SYSDATA[ 7 ] [ y ] [ s ] [ w ] [ z ] )
               NEXT z
            ENDIF
         NEXT w

      CASE T == "BUTTON"

         IF _HMG_SYSDATA[ 38 ] [ y ] == .F.

            IF _HMG_SYSDATA[ 22 ] [ y ] == 'T'

               EnableWindow( c )

            ELSE

               IF ( _HMG_SYSDATA[ 22 ] [ y ] == 'M' ) .OR. ( _HMG_SYSDATA[ 22 ] [ y ] == 'I' .AND. IsAppThemed() )

                  IMAGELIST_DESTROY( _HMG_SYSDATA[ 37 ] [ y ] )
                  _HMG_SYSDATA[ 37 ] [ y ] := _SetMixedBtnPicture( _HMG_SYSDATA[ 3 ] [ y ], _HMG_SYSDATA[ 25 ] [ y ], _HMG_SYSDATA[ 26 ] [ y ], _HMG_SYSDATA[ 32 ] [ y ], Nil )

                  ReDrawWindow( _HMG_SYSDATA[ 3 ] [ y ] )
                  EnableWindow( c )

               ELSE

                  EnableWindow( c )
                  DeleteObject( _HMG_SYSDATA[ 37 ] [ y ] )
                  _HMG_SYSDATA[ 37 ] [ y ] := _SETBTNPICTURE( c, _HMG_SYSDATA[ 25 ] [ y ], _HMG_SYSDATA[ 32 ] [ y ], Nil )

               ENDIF

            ENDIF

         ENDIF

      CASE T == "CHECKBOX"

         IF _HMG_SYSDATA[ 38 ] [ y ] == .F.

            IF _HMG_SYSDATA[ 39 ] [ y ] == 1

               IF IsAppThemed()

                  IMAGELIST_DESTROY( _HMG_SYSDATA[ 37 ] [ y ] )
                  _HMG_SYSDATA[ 37 ] [ y ] := _SetMixedBtnPicture( _HMG_SYSDATA[ 3 ] [ y ], _HMG_SYSDATA[ 25 ] [ y ], _HMG_SYSDATA[ 26 ] [ y ], _HMG_SYSDATA[ 32 ] [ y ], Nil )

                  RedrawWindow( _HMG_SYSDATA[ 3 ] [ y ] )
                  EnableWindow( c )

               ELSE

                  EnableWindow( c )
                  DeleteObject( _HMG_SYSDATA[ 37 ] [ y ] )
                  _HMG_SYSDATA[ 37 ] [ y ] := _SETBTNPICTURE( c, _HMG_SYSDATA[ 25 ] [ y ], _HMG_SYSDATA[ 32 ] [ y ], Nil )

               ENDIF

            ELSE

               EnableWindow( c )

            ENDIF

         ENDIF

      OTHERWISE
         EnableWindow( c )
   ENDCASE
   _HMG_SYSDATA[ 38 ] [ y ] := .T.
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _ShowControl()
*+
*+    Called from ( h_controlmisc.prg )   1 - function setproperty()
*+                                   1 - function domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _ShowControl( ControlName, ParentForm )

LOCAL t, i, c, w, s, y, z, r
LOCAL TabHide := .f.

   T = GetControlType( ControlName, ParentForm )

   c = GetControlHandle( ControlName, ParentForm )

   y := GetControlIndex( ControlName, ParentForm )

   IF _HMG_SYSDATA[ 34 ] [ y ] == .t.
      RETURN Nil
   ENDIF

   // *****************************************************************************
   // If the control is inside a TAB and the page is not visible,
   // the control must not be showed
   // *****************************************************************************

   FOR i := 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] )

      IF _HMG_SYSDATA[ 1 ] [ i ] == "TAB"

         s = TabCtrl_GetCurSel( _HMG_SYSDATA[ 3 ] [ i ] )

         FOR r = 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] [ i ] )

            FOR w = 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] [ i ] [ r ] )

               IF t == 'RADIOGROUP'

                  IF VALTYPE( _HMG_SYSDATA[ 7 ] [ i ] [ r ] [ w ] ) == 'A'

                     IF _HMG_SYSDATA[ 7 ] [ i ] [ r ] [ w ] [ 1 ] == _HMG_SYSDATA[ 3 ] [ y ] [ 1 ]

                        IF r != s
                           TabHide := .T.
                        ENDIF

                        EXIT

                     ENDIF

                  ENDIF

               ELSEIF t == 'SPINNER'

                  IF VALTYPE( _HMG_SYSDATA[ 7 ] [ i ] [ r ] [ w ] ) == 'A'

                     IF _HMG_SYSDATA[ 7 ] [ i ] [ r ] [ w ] [ 1 ] == _HMG_SYSDATA[ 3 ] [ y ] [ 1 ]

                        IF r != s
                           TabHide := .T.
                        ENDIF

                        EXIT

                     ENDIF

                  ENDIF

#ifdef COMPILEBROWSE

               ELSEIF t == 'BROWSE'

                  IF VALTYPE( _HMG_SYSDATA[ 7 ] [ i ] [ r ] [ w ] ) == 'A'

                     IF _HMG_SYSDATA[ 7 ] [ i ] [ r ] [ w ] [ 1 ] == _HMG_SYSDATA[ 3 ] [ y ]

                        IF r != s
                           TabHide := .T.
                        ENDIF

                        EXIT

                     ENDIF

                  ELSEIF VALTYPE( _HMG_SYSDATA[ 7 ] [ i ] [ r ] [ w ] ) == 'N'

                     IF _HMG_SYSDATA[ 7 ] [ i ] [ r ] [ w ] == _HMG_SYSDATA[ 3 ] [ y ]

                        IF r != s
                           TabHide := .T.
                        ENDIF

                        EXIT

                     ENDIF

                  ENDIF

#endif

               ELSE

                  IF VALTYPE( _HMG_SYSDATA[ 7 ] [ i ] [ r ] [ w ] ) == 'N'

                     IF _HMG_SYSDATA[ 7 ] [ i ] [ r ] [ w ] == _HMG_SYSDATA[ 3 ] [ y ]

                        IF r != s
                           TabHide := .T.
                        ENDIF

                        EXIT

                     ENDIF

                  ENDIF

               ENDIF

            NEXT w

         NEXT r

      ENDIF

   NEXT i

   IF TabHide == .T.
      _HMG_SYSDATA[ 34 ] [ y ] := .t.
      RETURN Nil
   ENDIF

   // *****************************************************************************

   IF T == "SPINNER"
      CShowControl( c[ 1 ] )
      CShowControl( c[ 2 ] )
      _HMG_SYSDATA[ 34 ] [ y ] := .t.

#ifdef COMPILEBROWSE

   ELSEIF T == "BROWSE"
      CShowControl( c )
      IF _HMG_SYSDATA[ 5 ] [ y ] != 0
         CShowControl( _HMG_SYSDATA[ 5 ] [ y ] )
      ENDIF
      IF _HMG_SYSDATA[ 39 ] [ y ] [ 1 ] != 0
         CShowControl( _HMG_SYSDATA[ 39 ] [ y ] [ 1 ] )
      ENDIF
      _HMG_SYSDATA[ 34 ] [ y ] := .t.

#endif

   ELSEIF T == "TAB"

      CShowControl( c )

      s = TabCtrl_GetCurSel( _HMG_SYSDATA[ 3 ] [ y ] )
      FOR w = 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] [ y ] [ s ] )
         IF VALTYPE( _HMG_SYSDATA[ 7 ] [ y ] [ s ] [ w ] ) <> "A"
            CShowControl( _HMG_SYSDATA[ 7 ] [ y ] [ s ] [ w ] )
         ELSE
            FOR z = 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] [ y ] [ s ] [ w ] )
               CShowControl( _HMG_SYSDATA[ 7 ] [ y ] [ s ] [ w ] [ z ] )
            NEXT z
         ENDIF
      NEXT w
      _HMG_SYSDATA[ 34 ] [ y ] := .t.

   ELSEIF T == "RADIOGROUP"

      FOR i := 1 TO HMG_LEN( c )

         CShowControl( c[ i ] )

      NEXT i
      _HMG_SYSDATA[ 34 ] [ y ] := .t.
   ELSE
      CShowControl( c )
      _HMG_SYSDATA[ 34 ] [ y ] := .t.
   ENDIF
   redrawwindow( c )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HideControl()
*+
*+    Called from ( h_controlmisc.prg )   1 - function setproperty()
*+                                   1 - function domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HideControl( ControlName, ParentForm )

LOCAL t, c, i, y, r, w, z

   T = GetControlType( ControlName, ParentForm )

   c = GetControlHandle( ControlName, ParentForm )

   y := GetControlIndex( ControlName, ParentForm )

   IF T == "SPINNER"
      HideWindow( c[ 1 ] )
      HideWindow( c[ 2 ] )
      _HMG_SYSDATA[ 34 ] [ y ] := .f.

#ifdef COMPILEBROWSE

   ELSEIF T == "BROWSE"
      HideWindow( c )
      IF _HMG_SYSDATA[ 5 ] [ y ] != 0
         HideWindow( _HMG_SYSDATA[ 5 ] [ y ] )
      ENDIF
      IF _HMG_SYSDATA[ 39 ] [ y ] [ 1 ] != 0
         HideWindow( _HMG_SYSDATA[ 39 ] [ y ] [ 1 ] )
      ENDIF
      _HMG_SYSDATA[ 34 ] [ y ] := .f.

#endif

   ELSEIF T == "TAB"

      HideWindow( c )

      FOR r = 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] [ y ] )
         FOR w = 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] [ y ] [ r ] )
            IF VALTYPE( _HMG_SYSDATA[ 7 ] [ y ] [ r ] [ w ] ) <> "A"
               HideWindow( _HMG_SYSDATA[ 7 ] [ y ] [ r ] [ w ] )
            ELSE
               FOR z = 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] [ y ] [ r ] [ w ] )
                  HideWindow( _HMG_SYSDATA[ 7 ] [ y ] [ r ] [ w ] [ z ] )
               NEXT z
            ENDIF
         NEXT w
      NEXT r

      _HMG_SYSDATA[ 34 ] [ y ] := .f.

   ELSEIF T == "RADIOGROUP"

      FOR i := 1 TO HMG_LEN( c )

         HideWindow( c[ i ] )

      NEXT i

      _HMG_SYSDATA[ 34 ] [ y ] := .f.

   ELSEIF T == "COMBO"

      SendMessage( c, 335, 0, 0 )
      HideWindow( c )
      _HMG_SYSDATA[ 34 ] [ y ] := .f.

   ELSE
      HideWindow( c )
      _HMG_SYSDATA[ 34 ] [ y ] := .f.
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _SetItem()
*+
*+    Called from ( h_grid.prg )   1 - function _addgridrow()
*+                                   1 - procedure _hmg_gridinplaceeditok()
*+                ( h_controlmisc.prg )   1 - function setproperty()
*+                ( h_status.prg )   1 - function _setstatusclock()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetItem( ControlName, ParentForm, Item, Value, index )

LOCAL t, c, i, aPos, k
LOCAL TreeHandle, ItemHandle
LOCAL AEDITCONTROLS
LOCAL CI
LOCAL XRES
LOCAL aTemp
LOCAL AEC
LOCAL CTYPE
LOCAL CINPUTMASK
LOCAL CFORMAT
LOCAL AITEMS
LOCAL ARANGE
LOCAL DTYPE
LOCAL ALABELS
LOCAL bd
LOCAL nCurrentValue

   IF PCOUNT() == 5
      i = INDEX
   ELSE
      i = GetControlIndex( ControlName, ParentForm )
   ENDIF

   T = _HMG_SYSDATA[ 1 ] [ i ]
   c = _HMG_SYSDATA[ 3 ] [ i ]

   DO CASE
      CASE t == 'TREE'

         IF _HMG_SYSDATA[ 9 ] [ i ] == .F.
            IF Item > TreeView_GetCount( c ) .OR. Item < 1
               MsgHMGError( "Item Property: Invalid Item Reference. Program Terminated" )
            ENDIF
         ENDIF

         TreeHandle := c

         IF _HMG_SYSDATA[ 9 ] [ i ] == .F.
            ItemHandle := _HMG_SYSDATA[ 7 ] [ i ] [ Item ]
         ELSE

            aPos := ASCAN( _HMG_SYSDATA[ 25 ] [ i ], Item )

            IF aPos == 0
               MsgHMGError( "Item Property: Invalid Item Id. Program Terminated" )
            ENDIF

            ItemHandle := _HMG_SYSDATA[ 7 ] [ i ] [ aPos ]

         ENDIF

         TreeView_SetItem( TreeHandle, ItemHandle, Value )

      CASE T == "LIST" .OR. T == "MULTILIST"
         nCurrentValue := ListBoxGetCursel( c )
         ListBoxDeleteString( c, Item )
         ListBoxInsertString( c, value, Item )
         ListBoxSetCursel( c, nCurrentValue )
      CASE T == "COMBO"
         IF VALTYPE( Value ) == 'C'
            ComboBoxDeleteString( c, Item )
            ComboInsertString( c, value, Item )
         ELSE
            ComboBoxDeleteString( c, Item )
            ImageComboAddItem( c, Value[ 1 ], Value[ 2 ], Item - 1 )
         ENDIF
      CASE T == "GRID" .OR. T == "MULTIGRID"

         IF _HMG_SYSDATA[ 40 ] [ i ] [ 9 ] == .F.

            AEDITCONTROLS := _HMG_SYSDATA[ 40 ] [ I ] [ 2 ]

            IF VALTYPE( AEDITCONTROLS ) <> "A"

               aTemp := ACLONE( Value )
               FOR k := 1 TO HMG_LEN( aTemp )                         // by Dr. Claudio Soto, April 2016
                  IF VALTYPE( aTemp[ k ] ) <> "C"
                     aTemp[ k ] := hb_ValToStr( aTemp[ k ] )
                  ENDIF
               NEXT

               ListViewSetItem( c, aTemp, Item )

            ELSE

               aTemp := ARRAY( HMG_LEN( VALUE ) )

               FOR CI := 1 TO HMG_LEN( VALUE )

                  XRES := _HMG_PARSEGRIDCONTROLS( AEDITCONTROLS, CI )

                  AEC := XRES[ 1 ]
                  CTYPE := HMG_UPPER( XRES[ 2 ] )
                  CINPUTMASK := XRES[ 3 ]
                  CFORMAT := XRES[ 4 ]
                  AITEMS := XRES[ 5 ]
                  ARANGE := XRES[ 6 ]
                  DTYPE := XRES[ 7 ]
                  ALABELS := XRES[ 8 ]

                  IF AEC == 'TEXTBOX'
                     IF CTYPE == 'CHARACTER'
                        IF EMPTY( CINPUTMASK )
                           aTemp[ ci ] := VALUE[ CI ]
                        ELSE
                           aTemp[ ci ] := TRANSFORM( VALUE[ CI ], CINPUTMASK )
                        ENDIF
                     ELSEIF CTYPE == 'NUMERIC'
                        IF EMPTY( CINPUTMASK )
                           aTemp[ ci ] := STR( VALUE[ CI ] )
                        ELSE
                           IF EMPTY( CFORMAT )
                              aTemp[ ci ] := TRANSFORM( VALUE[ CI ], CINPUTMASK )
                           ELSE
                              aTemp[ ci ] := TRANSFORM( VALUE[ CI ], '@' + CFORMAT + ' ' + CINPUTMASK )
                           ENDIF
                        ENDIF
                     ELSEIF CTYPE == 'DATE'
                        aTemp[ ci ] := DTOC( VALUE[ CI ] )
                     ENDIF
                  ELSEIF AEC == 'DATEPICKER'
                     bd = SET( _SET_DATEFORMAT )
                     SET CENTURY ON
                     aTemp[ ci ] := DTOC( VALUE[ CI ] )
                     SET( _SET_DATEFORMAT, bd )

                  ELSEIF AEC == 'TIMEPICKER'
                     // aTemp [ci] := VALUE [CI]
                     aTemp[ ci ] := HMG_TimeToTime( VALUE[ CI ], CFORMAT )

                  ELSEIF AEC == 'EDITBOX'                             // Pablo, February 2015
                     aTemp[ ci ] := VALUE[ CI ]

                  ELSEIF AEC == 'COMBOBOX'
                     IF VALUE[ CI ] == 0
                        aTemp[ ci ] := ''
                     ELSE
                        aTemp[ ci ] := AITEMS[ VALUE[ CI ] ]
                     ENDIF
                  ELSEIF AEC == 'SPINNER'
                     aTemp[ ci ] := STR( VALUE[ CI ] )
                  ELSEIF AEC == 'CHECKBOX'
                     IF VALUE[ CI ] == .T.
                        aTemp[ ci ] := ALABELS[ 1 ]
                     ELSE
                        aTemp[ ci ] := ALABELS[ 2 ]
                     ENDIF
                  ENDIF

               NEXT CI

               FOR k := 1 TO HMG_LEN( aTemp )                         // by Dr. Claudio Soto, April 2016
                  IF VALTYPE( aTemp[ k ] ) <> "C"
                     aTemp[ k ] := hb_ValToStr( aTemp[ k ] )
                  ENDIF
               NEXT

               ListViewSetItem( c, aTemp, Item )

            ENDIF

            IF HMG_LEN( _HMG_SYSDATA[ 14 ] [ i ] ) > 0
               SetImageListViewItems( c, item, value[ 1 ] )
            ENDIF

         ENDIF

      CASE T == "STATUSBAR"

         SetStatusItemText( c, value, Item - 1 )

   ENDCASE
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _GetItem()
*+
*+    Called from ( h_grid.prg )   1 - procedure _hmg_gridinplaceeditok()
*+                ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetItem( ControlName, ParentForm, Item, idx )

LOCAL t, c, RetVal, TreeHandle, ItemHandle, i, aPos
LOCAL AEDITCONTROLS
LOCAL CI
LOCAL XRES
LOCAL aTemp
LOCAL AEC
LOCAL CTYPE
LOCAL CINPUTMASK
LOCAL CFORMAT
LOCAL AITEMS
LOCAL ARANGE
LOCAL DTYPE
LOCAL ALABELS
LOCAL V
LOCAL Z
LOCAL X

   IF PCOUNT() == 3

      i := GetControlIndex( ControlName, ParentForm )

   ELSEIF PCOUNT() == 4

      i := idx

   ENDIF

   T = _HMG_SYSDATA[ 1 ] [ i ]

   c = _HMG_SYSDATA[ 3 ] [ i ]

   DO CASE

      CASE T == "STATUSBAR"

         RetVal := GETSTATUSITEMTEXT( c, Item - 1 )                   // by Dr. Claudio Soto (July 2014)

      CASE t == 'TREE'

         IF _HMG_SYSDATA[ 9 ] [ i ] == .F.
            IF Item > TreeView_GetCount( c ) .OR. Item < 1
               MsgHMGError( "Item Property: Invalid Item Reference. Program Terminated" )
            ENDIF
         ENDIF

         TreeHandle := c

         IF _HMG_SYSDATA[ 9 ] [ i ] == .F.
            ItemHandle := _HMG_SYSDATA[ 7 ] [ i ] [ Item ]
         ELSE

            aPos := ASCAN( _HMG_SYSDATA[ 25 ] [ i ], Item )

            IF aPos == 0
               MsgHMGError( "Item Property: Invalid Item Id. Program Terminated" )
            ENDIF

            ItemHandle := _HMG_SYSDATA[ 7 ] [ i ] [ aPos ]

         ENDIF

         RetVal := TreeView_GetItem( TreeHandle, ItemHandle )

      CASE T == "LIST" .OR. T == "MULTILIST"
         RetVal := ListBoxGetString( c, Item )
      CASE T == "COMBO"

         IF VALTYPE( _HMG_SYSDATA[ 15 ] [ i ] ) == 'U'
            RetVal := ComboGetString( c, Item )
         ELSE
            RetVal := IMAGECOMBOGETITEM( c, Item )
         ENDIF

      CASE T == "GRID" .OR. T == "MULTIGRID"

         IF _HMG_SYSDATA[ 40 ] [ i ] [ 9 ] == .F.

            AEDITCONTROLS := _HMG_SYSDATA[ 40 ] [ I ] [ 2 ]

            IF VALTYPE( AEDITCONTROLS ) != 'A'

               RetVal := ListViewGetItem_NEW( c, Item, HMG_LEN( _HMG_SYSDATA[ 7 ] [ i ] ) )

            ELSE

               V := ListViewGetItem_NEW( c, Item, HMG_LEN( _HMG_SYSDATA[ 7 ] [ i ] ) )

               aTemp := ARRAY( HMG_LEN( _HMG_SYSDATA[ 7 ] [ i ] ) )

               FOR CI := 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] [ i ] )

                  XRES := _HMG_PARSEGRIDCONTROLS( AEDITCONTROLS, CI )

                  AEC := XRES[ 1 ]
                  CTYPE := HMG_UPPER( XRES[ 2 ] )
                  CINPUTMASK := XRES[ 3 ]
                  CFORMAT := XRES[ 4 ]
                  AITEMS := XRES[ 5 ]
                  ARANGE := XRES[ 6 ]
                  DTYPE := XRES[ 7 ]
                  ALABELS := XRES[ 8 ]

                  IF AEC == 'TEXTBOX'
                     IF CTYPE == 'NUMERIC'
                        IF CFORMAT = 'E'
                           aTemp[ CI ] := GetNumFromCellTextSp( v[ CI ] )
                        ELSE
                           aTemp[ CI ] := GetNumFromCellText( v[ CI ] )
                        ENDIF
                     ELSEIF CTYPE == 'DATE'
                        aTemp[ CI ] := CTOD( v[ CI ] )
                     ELSEIF CTYPE == 'CHARACTER'
                        aTemp[ CI ] := v[ CI ]
                     ENDIF

                  ELSEIF AEC == 'DATEPICKER'
                     aTemp[ CI ] := CTOD( V[ CI ] )

                  ELSEIF AEC == 'TIMEPICKER'
                     aTemp[ CI ] := V[ CI ]

                  ELSEIF AEC == 'EDITBOX'                             // Pablo, February 2015
                     aTemp[ ci ] := V[ CI ]

                  ELSEIF AEC == 'COMBOBOX'
                     Z := 0
                     FOR X := 1 TO HMG_LEN( AITEMS )
                        IF HMG_UPPER( ALLTRIM( V[ CI ] ) ) == HMG_UPPER( ALLTRIM( AITEMS[ X ] ) )
                           Z := X
                           EXIT
                        ENDIF
                     NEXT X
                     aTemp[ CI ] := Z

                  ELSEIF AEC == 'SPINNER'
                     aTemp[ CI ] := VAL( V[ CI ] )
                  ELSEIF AEC == 'CHECKBOX'
                     IF ALLTRIM( HMG_UPPER( V[ CI ] ) ) == ALLTRIM( HMG_UPPER( ALABELS[ 1 ] ) )
                        aTemp[ CI ] := .T.
                     ELSEIF ALLTRIM( HMG_UPPER( V[ CI ] ) ) == ALLTRIM( HMG_UPPER( ALABELS[ 2 ] ) )
                        aTemp[ CI ] := .F.
                     ENDIF
                  ENDIF

               NEXT CI

               RetVal := aTemp

            ENDIF

            IF HMG_LEN( _HMG_SYSDATA[ 14 ] [ i ] ) > 0
               IF HMG_LEN( RetVal ) >= 1
                  RetVal[ 1 ] := GetImageListViewItems( c, Item )
               ENDIF
            ENDIF

         ENDIF
   ENDCASE
RETURN ( RetVal )

*+--------------------------------------------------------------------
*+
*+    Function ListViewGetItem_NEW()
*+
*+    Called from ( h_controlmisc.prg )   2 - function _getitem()
*+
*+--------------------------------------------------------------------
*+
FUNCTION ListViewGetItem_NEW( nControlHandle, nRow, nColumnCount )

LOCAL nCol, V := ARRAY( nColumnCount )
   FOR nCol = 1 TO nColumnCount
      V[ nCol ] := LISTVIEW_GETITEMTEXT( nControlHandle, nRow - 1, nCol - 1 )
   NEXT
RETURN V

*+--------------------------------------------------------------------
*+
*+    Function _SetControlSizePos()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _setcontrolcol()
*+                                   1 - function _setcontrolrow()
*+                                   1 - function _setcontrolwidth()
*+                                   1 - function _setcontrolheight()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetControlSizePos( ControlName, ParentForm, row, col, width, height )

LOCAL t, i, c, x, NewRow, r, w, z, p, xx, b, hws
LOCAL DelTaRow, DelTaCol
LOCAL tCol, tRow, tWidth, tHeight, NewCol, Spacing

   T := GetControlType( ControlName, ParentForm )

   c := GetControlHandle( ControlName, ParentForm )

   x := GetControlIndex( ControlName, ParentForm )

   DO CASE

      CASE T == "TAB"

         DelTaRow := Row - _HMG_SYSDATA[ 18 ] [ x ]
         DelTaCol := Col - _HMG_SYSDATA[ 19 ] [ x ]

         _HMG_SYSDATA[ 18 ] [ x ] := Row
         _HMG_SYSDATA[ 19 ] [ x ] := Col
         _HMG_SYSDATA[ 20 ] [ x ] := Width
         _HMG_SYSDATA[ 21 ] [ x ] := Height

         MoveWindow( c, col, Row, Width, Height, .t. )

         FOR r = 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] [ x ] )
            FOR w = 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] [ x ] [ r ] )
               IF VALTYPE( _HMG_SYSDATA[ 7 ] [ x ] [ r ] [ w ] ) <> "A"

                  p := ASCAN( _HMG_SYSDATA[ 3 ], _HMG_SYSDATA[ 7 ] [ x ] [ r ] [ w ] )

                  IF p > 0
                     tCol := _HMG_SYSDATA[ 19 ] [ p ]
                     tRow := _HMG_SYSDATA[ 18 ] [ p ]
                     tWidth := _HMG_SYSDATA[ 20 ] [ p ]
                     tHeight := _HMG_SYSDATA[ 21 ] [ p ]

                     MoveWindow( _HMG_SYSDATA[ 7 ] [ x ] [ r ] [ w ], tCol + DeltaCol, tRow + DeltaRow, tWidth, tHeight, .t. )

                     _HMG_SYSDATA[ 18 ] [ p ] := tRow + DeltaRow
                     _HMG_SYSDATA[ 19 ] [ p ] := tCol + DeltaCol

                     _HMG_SYSDATA[ 23 ] [ p ] := Row
                     _HMG_SYSDATA[ 24 ] [ p ] := Col
                  ENDIF

               ELSE

                  p := ASCAN( _HMG_SYSDATA[ 3 ], _HMG_SYSDATA[ 7 ] [ x ] [ r ] [ w ] [ 1 ] )

                  IF p > 0 .AND. _HMG_SYSDATA[ 1 ] [ p ] == 'BROWSE'

#ifdef COMPILEBROWSE

                     tCol := _HMG_SYSDATA[ 19 ] [ p ]
                     tRow := _HMG_SYSDATA[ 18 ] [ p ]
                     tWidth := _HMG_SYSDATA[ 20 ] [ p ]
                     tHeight := _HMG_SYSDATA[ 21 ] [ p ]

                     IF _HMG_SYSDATA[ 5 ] [ p ] != 0

                        MoveWindow( _HMG_SYSDATA[ 7 ] [ x ] [ r ] [ w ] [ 1 ], tCol + DeltaCol, tRow + DeltaRow, tWidth - GETVSCROLLBARWIDTH(), tHeight, .t. )

                        hws := 0
                        FOR b := 1 TO HMG_LEN( _HMG_SYSDATA[ 6 ] [ p ] )
                           hws := hws + ListView_GetColumnWidth( _HMG_SYSDATA[ 3 ] [ p ], b - 1 )
                        NEXT b

                        IF hws > _HMG_SYSDATA[ 20 ] [ p ] - GETVSCROLLBARWIDTH() - 4

                           MoveWindow( _HMG_SYSDATA[ 5 ] [ p ], tCol + DeltaCol + tWidth - GETVSCROLLBARWIDTH(), tRow + DeltaRow, GETVSCROLLBARWIDTH(), tHeight - GetHScrollBarHeight(), .t. )
                           MoveWindow( _HMG_SYSDATA[ 39 ] [ p ] [ 1 ], tCol + DeltaCol + tWidth - GETVSCROLLBARWIDTH(), tRow + DeltaRow + tHeight - GetHScrollBarHeight(), GetWindowWidth( _HMG_SYSDATA[ 39 ] [ p ] [ 1 ] ), GetWindowHeight( _HMG_SYSDATA[ 39 ] [ p ] [ 1 ] ), .t. )

                        ELSE

                           MoveWindow( _HMG_SYSDATA[ 5 ] [ p ], tCol + DeltaCol + tWidth - GETVSCROLLBARWIDTH(), tRow + DeltaRow, GETVSCROLLBARWIDTH(), tHeight, .t. )
                           MoveWindow( _HMG_SYSDATA[ 39 ] [ p ] [ 1 ], tCol + DeltaCol + tWidth - GETVSCROLLBARWIDTH(), tRow + DeltaRow + tHeight - GetHScrollBarHeight(), 0, 0, .t. )

                        ENDIF

                        _BrowseRefresh( '', '', p )

                        ReDrawWindow( _HMG_SYSDATA[ 5 ] [ p ] )

                        ReDrawWindow( _HMG_SYSDATA[ 39 ] [ p ] [ 1 ] )

                     ELSE

                        MoveWindow( _HMG_SYSDATA[ 7 ] [ x ] [ r ] [ w ] [ 1 ], tCol + DeltaCol, tRow + DeltaRow, tWidth, tHeight, .t. )

                     ENDIF

                     _HMG_SYSDATA[ 18 ] [ p ] := tRow + DeltaRow
                     _HMG_SYSDATA[ 19 ] [ p ] := tCol + DeltaCol

                     _HMG_SYSDATA[ 23 ] [ p ] := Row
                     _HMG_SYSDATA[ 24 ] [ p ] := Col

#endif

                  ELSE

                     FOR z = 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] [ x ] [ r ] [ w ] )

                        FOR xx = 1 TO HMG_LEN( _HMG_SYSDATA[ 1 ] )
                           IF VALTYPE( _HMG_SYSDATA[ 3 ] [ xx ] ) == 'A'
                              IF _HMG_SYSDATA[ 7 ] [ x ] [ r ] [ w ] == _HMG_SYSDATA[ 3 ] [ xx ]
                                 IF _HMG_SYSDATA[ 1 ] [ xx ] == 'RADIOGROUP'
                                    IF _HMG_SYSDATA[ 8 ] [ xx ] == .T.
                                       MoveWindow( _HMG_SYSDATA[ 3 ] [ xx ] [ z ], _HMG_SYSDATA[ 19 ] [ xx ] + DeltaCol + ( _HMG_SYSDATA[ 22 ] [ XX ] * ( z - 1 ) ), _HMG_SYSDATA[ 18 ] [ xx ] + DeltaRow, _HMG_SYSDATA[ 22 ] [ xx ], 28, .t. )
                                    ELSE
                                       MoveWindow( _HMG_SYSDATA[ 3 ] [ xx ] [ z ], _HMG_SYSDATA[ 19 ] [ xx ] + DeltaCol, _HMG_SYSDATA[ 18 ] [ xx ] + DeltaRow + ( _HMG_SYSDATA[ 22 ] [ xx ] * ( z - 1 ) ), _HMG_SYSDATA[ 20 ] [ xx ], 28, .t. )
                                    ENDIF
                                 ENDIF
                                 IF _HMG_SYSDATA[ 1 ] [ xx ] == 'RADIOGROUP' .AND. z == HMG_LEN( _HMG_SYSDATA[ 7 ] [ x ] [ r ] [ w ] )
                                    IF _HMG_SYSDATA[ 8 ] [ xx ] == .T.

                                       _HMG_SYSDATA[ 18 ] [ xx ] := _HMG_SYSDATA[ 18 ] [ xx ] + DeltaRow
                                       _HMG_SYSDATA[ 19 ] [ xx ] := _HMG_SYSDATA[ 19 ] [ xx ] + DeltaCol
                                       _HMG_SYSDATA[ 23 ] [ xx ] := Row
                                       _HMG_SYSDATA[ 24 ] [ xx ] := Col

                                    ELSE
                                       _HMG_SYSDATA[ 18 ] [ xx ] := _HMG_SYSDATA[ 18 ] [ xx ] + DeltaRow
                                       _HMG_SYSDATA[ 19 ] [ xx ] := _HMG_SYSDATA[ 19 ] [ xx ] + DeltaCol
                                       _HMG_SYSDATA[ 23 ] [ xx ] := Row
                                       _HMG_SYSDATA[ 24 ] [ xx ] := Col
                                    ENDIF
                                 ENDIF
                                 IF _HMG_SYSDATA[ 1 ] [ xx ] == 'SPINNER' .AND. z == 1

                                    MoveWIndow( _HMG_SYSDATA[ 3 ] [ xx ] [ 1 ], _HMG_SYSDATA[ 19 ] [ xx ] + DeltaCol, _HMG_SYSDATA[ 18 ] [ xx ] + DeltaRow, _HMG_SYSDATA[ 20 ] [ xx ], _HMG_SYSDATA[ 21 ] [ xx ], .t. )
                                 ENDIF
                                 IF _HMG_SYSDATA[ 1 ] [ xx ] == 'SPINNER' .AND. z == 2

                                    MoveWIndow( _HMG_SYSDATA[ 3 ] [ xx ] [ 2 ], _HMG_SYSDATA[ 19 ] [ xx ] + DeltaCol + _HMG_SYSDATA[ 20 ] [ xx ] - 15, _HMG_SYSDATA[ 18 ] [ xx ] + DeltaRow, 15, _HMG_SYSDATA[ 21 ] [ xx ], .t. )
                                    _HMG_SYSDATA[ 18 ] [ xx ] := _HMG_SYSDATA[ 18 ] [ xx ] + DeltaRow
                                    _HMG_SYSDATA[ 19 ] [ xx ] := _HMG_SYSDATA[ 19 ] [ xx ] + DeltaCol
                                    _HMG_SYSDATA[ 23 ] [ xx ] := Row
                                    _HMG_SYSDATA[ 24 ] [ xx ] := Col

                                 ENDIF

                              ENDIF
                           ENDIF
                        NEXT xx

                     NEXT z
                  ENDIF
               ENDIF
            NEXT w
         NEXT r

      CASE T == "SPINNER"

         IF _HMG_SYSDATA[ 23 ] [ x ] == - 1

            _HMG_SYSDATA[ 18 ] [ x ] := Row
            _HMG_SYSDATA[ 19 ] [ x ] := Col
            _HMG_SYSDATA[ 20 ] [ x ] := Width
            _HMG_SYSDATA[ 21 ] [ x ] := Height

            MoveWindow( c[ 1 ], Col, Row, Width - 15, Height, .t. )
            MoveWindow( c[ 2 ], Col + Width - 15, Row, 15, Height, .t. )

         ELSE

            _HMG_SYSDATA[ 18 ] [ x ] := Row + _HMG_SYSDATA[ 23 ] [ x ]
            _HMG_SYSDATA[ 19 ] [ x ] := Col + _HMG_SYSDATA[ 24 ] [ x ]
            _HMG_SYSDATA[ 20 ] [ x ] := Width
            _HMG_SYSDATA[ 21 ] [ x ] := Height

            MoveWindow( c[ 1 ], Col + _HMG_SYSDATA[ 24 ] [ x ], Row + _HMG_SYSDATA[ 23 ] [ x ], Width - 15, Height, .t. )
            MoveWindow( c[ 2 ], Col + _HMG_SYSDATA[ 24 ] [ x ] + Width - 15, Row + _HMG_SYSDATA[ 23 ] [ x ], 15, Height, .t. )

         ENDIF

#ifdef COMPILEBROWSE

      CASE T == "BROWSE"

         IF _HMG_SYSDATA[ 23 ] [ x ] == - 1

            _HMG_SYSDATA[ 18 ] [ x ] := Row
            _HMG_SYSDATA[ 19 ] [ x ] := Col
            _HMG_SYSDATA[ 20 ] [ x ] := Width
            _HMG_SYSDATA[ 21 ] [ x ] := Height

            IF _HMG_SYSDATA[ 5 ] [ x ] != 0
               MoveWindow( c, col, Row, Width - GETVSCROLLBARWIDTH(), Height, .t. )

               hws := 0
               FOR b := 1 TO HMG_LEN( _HMG_SYSDATA[ 6 ] [ x ] )
                  hws := hws + ListView_GetColumnWidth( _HMG_SYSDATA[ 3 ] [ x ], b - 1 )
               NEXT b

               IF hws > _HMG_SYSDATA[ 20 ] [ x ] - GETVSCROLLBARWIDTH() - 4

                  MoveWindow( _HMG_SYSDATA[ 5 ] [ x ], col + Width - GETVSCROLLBARWIDTH(), Row, GETVSCROLLBARWIDTH(), Height - GetHScrollBarHeight(), .t. )
                  MoveWindow( _HMG_SYSDATA[ 39 ] [ x ] [ 1 ], col + Width - GETVSCROLLBARWIDTH(), Row + Height - GetHScrollBarHeight(), GetWindowWidth( _HMG_SYSDATA[ 39 ] [ x ] [ 1 ] ), GetWindowHeight( _HMG_SYSDATA[ 39 ] [ x ] [ 1 ] ), .t. )

               ELSE

                  MoveWindow( _HMG_SYSDATA[ 5 ] [ x ], col + Width - GETVSCROLLBARWIDTH(), Row, GETVSCROLLBARWIDTH(), Height, .t. )
                  MoveWindow( _HMG_SYSDATA[ 39 ] [ x ] [ 1 ], col + Width - GETVSCROLLBARWIDTH(), Row + Height - GetHScrollBarHeight(), 0, 0, .t. )

               ENDIF

               _BrowseRefresh( '', '', x )
               ReDrawWindow( _HMG_SYSDATA[ 5 ] [ x ] )
               ReDrawWindow( _HMG_SYSDATA[ 39 ] [ x ] [ 1 ] )
            ELSE
               MoveWindow( c, col, Row, Width, Height, .t. )
            ENDIF

         ELSE

            _HMG_SYSDATA[ 18 ] [ x ] := Row + _HMG_SYSDATA[ 23 ] [ x ]
            _HMG_SYSDATA[ 19 ] [ x ] := Col + _HMG_SYSDATA[ 24 ] [ x ]
            _HMG_SYSDATA[ 20 ] [ x ] := Width
            _HMG_SYSDATA[ 21 ] [ x ] := Height

            IF _HMG_SYSDATA[ 5 ] [ x ] != 0

               MoveWindow( c, col + _HMG_SYSDATA[ 24 ] [ x ], Row + _HMG_SYSDATA[ 23 ] [ x ], Width - GETVSCROLLBARWIDTH(), Height, .t. )

               hws := 0
               FOR b := 1 TO HMG_LEN( _HMG_SYSDATA[ 6 ] [ x ] )
                  hws := hws + ListView_GetColumnWidth( _HMG_SYSDATA[ 3 ] [ x ], b - 1 )
               NEXT b

               IF hws > _HMG_SYSDATA[ 20 ] [ x ] - GETVSCROLLBARWIDTH() - 4

                  MoveWindow( _HMG_SYSDATA[ 5 ] [ x ], col + _HMG_SYSDATA[ 24 ] [ x ] + Width - GETVSCROLLBARWIDTH(), Row + _HMG_SYSDATA[ 23 ] [ x ], GETVSCROLLBARWIDTH(), Height - GetHScrollBarHeight(), .t. )
                  MoveWindow( _HMG_SYSDATA[ 39 ] [ x ] [ 1 ], col + _HMG_SYSDATA[ 24 ] [ x ] + Width - GETVSCROLLBARWIDTH(), Row + _HMG_SYSDATA[ 23 ] [ x ] + Height - GetHScrollBarHeight(), GetWindowWidth( _HMG_SYSDATA[ 39 ] [ x ] [ 1 ] ), GetWindowHeight( _HMG_SYSDATA[ 39 ] [ x ] [ 1 ] ), .t. )

               ELSE

                  MoveWindow( _HMG_SYSDATA[ 5 ] [ x ], col + _HMG_SYSDATA[ 24 ] [ x ] + Width - GETVSCROLLBARWIDTH(), Row + _HMG_SYSDATA[ 23 ] [ x ], GETVSCROLLBARWIDTH(), Height, .t. )
                  MoveWindow( _HMG_SYSDATA[ 39 ] [ x ] [ 1 ], col + _HMG_SYSDATA[ 24 ] [ x ] + Width - GETVSCROLLBARWIDTH(), Row + _HMG_SYSDATA[ 23 ] [ x ] + Height - GetHScrollBarHeight(), 0, 0, .t. )

               ENDIF

               _BrowseRefresh( '', '', x )

               ReDrawWindow( _HMG_SYSDATA[ 5 ] [ x ] )

               ReDrawWindow( _HMG_SYSDATA[ 39 ] [ x ] [ 1 ] )

            ELSE
               MoveWindow( c, col + _HMG_SYSDATA[ 24 ] [ x ], Row + _HMG_SYSDATA[ 23 ] [ x ], Width, Height, .t. )
            ENDIF

         ENDIF

         ReDrawWindow( c )

#endif

      CASE T == "RADIOGROUP"

         IF _HMG_SYSDATA[ 23 ] [ x ] == - 1

            _HMG_SYSDATA[ 18 ] [ x ] := Row
            _HMG_SYSDATA[ 19 ] [ x ] := Col
            _HMG_SYSDATA[ 20 ] [ x ] := Width
            Spacing := _HMG_SYSDATA[ 22 ] [ x ]

            IF _HMG_SYSDATA[ 8 ] [ x ]

               FOR i := 1 TO HMG_LEN( c )
                  NewCol := Col + ( ( i - 1 ) * _HMG_SYSDATA[ 22 ] [ x ] )
                  MoveWindow( c[ i ], Newcol, Row, spacing, 28, .t. )
               NEXT i

            ELSE

               FOR i := 1 TO HMG_LEN( c )
                  NewRow := Row + ( ( i - 1 ) * _HMG_SYSDATA[ 22 ] [ x ] )
                  MoveWindow( c[ i ], col, NewRow, Width, 28, .t. )
               NEXT i

            ENDIF

         ELSE

            _HMG_SYSDATA[ 18 ] [ x ] := Row + _HMG_SYSDATA[ 23 ] [ x ]
            _HMG_SYSDATA[ 19 ] [ x ] := Col + _HMG_SYSDATA[ 24 ] [ x ]
            _HMG_SYSDATA[ 20 ] [ x ] := Width

            Spacing := _HMG_SYSDATA[ 22 ] [ x ]

            IF _HMG_SYSDATA[ 8 ] [ x ]

               FOR i := 1 TO HMG_LEN( c )
                  // NewCol := Col + _HMG_SYSDATA [ 24 ] [x] + ( ( i - 1 ) * _HMG_SYSDATA [ 22 ] [ x ] )
                  // MoveWindow ( c [i] , NewCol , Row , Spacing , 28 , .t. )
               NEXT i

            ELSE

               FOR i := 1 TO HMG_LEN( c )
                  NewRow := Row + _HMG_SYSDATA[ 23 ] [ x ] + ( ( i - 1 ) * _HMG_SYSDATA[ 22 ] [ x ] )
                  MoveWindow( c[ i ], col + _HMG_SYSDATA[ 24 ] [ x ], NewRow, Width, 28, .t. )
               NEXT i

            ENDIF

         ENDIF

      OTHERWISE

         IF _HMG_SYSDATA[ 23 ] [ x ] == - 1

            _HMG_SYSDATA[ 18 ] [ x ] := Row
            _HMG_SYSDATA[ 19 ] [ x ] := Col
            _HMG_SYSDATA[ 20 ] [ x ] := Width
            _HMG_SYSDATA[ 21 ] [ x ] := Height
            MoveWindow( c, col, row, width, height, .t. )

         ELSE

            _HMG_SYSDATA[ 18 ] [ x ] := Row + _HMG_SYSDATA[ 23 ] [ x ]
            _HMG_SYSDATA[ 19 ] [ x ] := Col + _HMG_SYSDATA[ 24 ] [ x ]
            _HMG_SYSDATA[ 20 ] [ x ] := Width
            _HMG_SYSDATA[ 21 ] [ x ] := Height
            MoveWindow( c, col + _HMG_SYSDATA[ 24 ] [ x ], row + _HMG_SYSDATA[ 23 ] [ x ], width, height, .t. )

         ENDIF
   ENDCASE
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _GetItemCount()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetItemCount( ControlName, ParentForm )

LOCAL t, c, RetVal

   T = GetControlType( ControlName, ParentForm )

   c = GetControlHandle( ControlName, ParentForm )

   DO CASE
      CASE T == "TREE"
         RetVal := TreeView_GetCount( c )
      CASE T == "LIST" .OR. T == "MULTILIST"
         RetVal := ListBoxGetItemCount( c )
      CASE T == "COMBO"
         RetVal := ComboBoxGetItemCount( c )
      CASE T == "GRID" .OR. T == "MULTIGRID"
         RetVal := ListView_GetItemCount( c )
   ENDCASE
RETURN ( RetVal )

*+--------------------------------------------------------------------
*+
*+    Function _GetControlRow()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _setcontrolcol()
*+                                   1 - function _setcontrolwidth()
*+                                   1 - function _setcontrolheight()
*+                                   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetControlRow( ControlName, ParentForm )

LOCAL mVar, i

   mVar := '_' + ParentForm + '_' + ControlName

   i := &mVar
   IF i == 0
      RETURN 0
   ENDIF

   IF _HMG_SYSDATA[ 23 ] [ &mVar ] == - 1
      RETURN ( _HMG_SYSDATA[ 18 ] [ &mVar ] )
   ELSE
      RETURN ( _HMG_SYSDATA[ 18 ] [ &mVar ] - _HMG_SYSDATA[ 23 ] [ &mVar ] )
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _GetControlCol()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _setcontrolrow()
*+                                   1 - function _setcontrolwidth()
*+                                   1 - function _setcontrolheight()
*+                                   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetControlCol( ControlName, ParentForm )

LOCAL mVar, i

   mVar := '_' + ParentForm + '_' + ControlName

   i := &mVar
   IF i == 0
      RETURN 0
   ENDIF

   IF _HMG_SYSDATA[ 24 ] [ &mVar ] == - 1
      RETURN ( _HMG_SYSDATA[ 19 ] [ &mVar ] )
   ELSE
      RETURN ( _HMG_SYSDATA[ 19 ] [ &mVar ] - _HMG_SYSDATA[ 24 ] [ &mVar ] )
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _GetControlWidth()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _setcontrolcol()
*+                                   1 - function _setcontrolrow()
*+                                   1 - function _setcontrolheight()
*+                                   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetControlWidth( ControlName, ParentForm )

LOCAL mVar, i

   mVar := '_' + ParentForm + '_' + ControlName

   i := &mVar
   IF i == 0
      RETURN 0
   ENDIF
RETURN ( _HMG_SYSDATA[ 20 ] [ &mVar ] )

*+--------------------------------------------------------------------
*+
*+    Function _GetControlHeight()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _setcontrolcol()
*+                                   1 - function _setcontrolrow()
*+                                   1 - function _setcontrolwidth()
*+                                   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetControlHeight( ControlName, ParentForm )

LOCAL mVar, i

   mVar := '_' + ParentForm + '_' + ControlName

   i := &mVar
   IF i == 0
      RETURN 0
   ENDIF
RETURN ( _HMG_SYSDATA[ 21 ] [ &mVar ] )

*+--------------------------------------------------------------------
*+
*+    Function _SetControlCol()
*+
*+    Called from ( h_controlmisc.prg )   1 - function setproperty()
*+                ( h_tab.prg )   1 - function _addtabcontrol()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetControlCol( ControlName, ParentForm, Value )

   _SetControlSizePos( ControlName, ParentForm, _GetControlRow( ControlName, ParentForm ), Value, _GetControlWidth( ControlName, ParentForm ), _GetControlHeight( ControlName, ParentForm ) )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _SetControlRow()
*+
*+    Called from ( h_controlmisc.prg )   1 - function setproperty()
*+                ( h_tab.prg )   1 - function _addtabcontrol()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetControlRow( ControlName, ParentForm, Value )

   _SetControlSizePos( ControlName, ParentForm, Value, _GetControlCol( ControlName, ParentForm ), _GetControlWidth( ControlName, ParentForm ), _GetControlHeight( ControlName, ParentForm ) )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _SetControlWidth()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _setvalue()
*+                                   1 - function setproperty()
*+                ( h_label.prg )   1 - function _definelabel()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetControlWidth( ControlName, ParentForm, Value )

   _SetControlSizePos( ControlName, ParentForm, _GetControlRow( ControlName, ParentForm ), _GetControlCol( ControlName, ParentForm ), Value, _GetControlHeight( ControlName, ParentForm ) )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _SetControlHeight()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _setvalue()
*+                                   1 - function setproperty()
*+                ( h_label.prg )   1 - function _definelabel()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetControlHeight( ControlName, ParentForm, Value )

   _SetControlSizePos( ControlName, ParentForm, _GetControlRow( ControlName, ParentForm ), _GetControlCol( ControlName, ParentForm ), _GetControlWidth( ControlName, ParentForm ), Value )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _SetPicture()
*+
*+    Called from ( h_controlmisc.prg )   1 - function setproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetPicture( ControlName, ParentForm, FileName )

LOCAL w, h, t, i, c, OldBitmap

   i := GetControlIndex( ControlName, ParentForm )
   t := GetControlType( ControlName, ParentForm )
   c := GetControlHandle( ControlName, ParentForm )

   IF t == 'IMAGE'                                                    // Dr. Claudio Soto (May 2013)

      // w := _GetControlWidth  ( ControlName, ParentForm )
      // h := _GetControlHeight ( ControlName, ParentForm )

      w := _HMG_SYSDATA[ 31 ] [ i ]                                   // original Width
      h := _HMG_SYSDATA[ 32 ] [ i ]                                   // original Height

      DeleteObject( _HMG_SYSDATA[ 37 ] [ i ] )
      //  stretch                  transparent              nBackgroundColor        adjustimage              TransparentColor
      _HMG_SYSDATA[ 37 ] [ i ] := C_SetPicture( GetControlHandle( ControlName, ParentForm ), FileName, w, h, _HMG_SYSDATA[ 8 ] [ i ], _HMG_SYSDATA[ 39 ] [ i ], _HMG_SYSDATA[ 26 ] [ i ], _HMG_SYSDATA[ 36 ] [ i ], _HMG_SYSDATA[ 28 ] [ i ] )

      _HMG_SYSDATA[ 25 ] [ i ] := FileName

      _HMG_SYSDATA[ 20 ] [ i ] := GetWindowWidth( GetControlHandle( ControlName, ParentForm ) )
      _HMG_SYSDATA[ 21 ] [ i ] := GetWindowHeight( GetControlHandle( ControlName, ParentForm ) )

   ELSEIF T == 'BUTTON'

      IF _HMG_SYSDATA[ 38 ] [ i ] == .T. .AND. EMPTY( FileName )      // ADD, march 2017
         DeleteObject( _HMG_SYSDATA[ 37 ] [ i ] )
         _HMG_SYSDATA[ 37 ] [ i ] := _SetBtnPicture( _HMG_SYSDATA[ 3 ] [ i ], FileName, Nil, Nil )
         _HMG_SYSDATA[ 25 ] [ i ] := FileName
         RETURN Nil
      ENDIF

      IF .NOT. EMPTY( _HMG_SYSDATA[ 25 ] [ i ] ) ;
                 .AND. ;
                 .NOT. EMPTY( _HMG_SYSDATA[ 33 ] [ i ] ) ;
                 .OR. ;
                 ( _HMG_SYSDATA[ 22 ] [ i ] == 'I' .AND. IsAppThemed() ) ;

         IF _HMG_SYSDATA[ 38 ] [ i ] == .T.

            IMAGELIST_DESTROY( _HMG_SYSDATA[ 37 ] [ i ] )
            _HMG_SYSDATA[ 37 ] [ i ] := _SetMixedBtnPicture( _HMG_SYSDATA[ 3 ] [ i ], FileName, _HMG_SYSDATA[ 26 ] [ i ], _HMG_SYSDATA[ 32 ] [ i ], Nil )

            RedrawWindow( _HMG_SYSDATA[ 3 ] [ i ] )
            _HMG_SYSDATA[ 25 ] [ i ] := FileName

         ENDIF

      ELSE

         IF _HMG_SYSDATA[ 38 ] [ i ] == .T.
            DeleteObject( _HMG_SYSDATA[ 37 ] [ i ] )
            _HMG_SYSDATA[ 37 ] [ i ] := _SetBtnPicture( _HMG_SYSDATA[ 3 ] [ i ], FileName, _HMG_SYSDATA[ 32 ] [ i ], Nil )
            _HMG_SYSDATA[ 25 ] [ i ] := FileName
         ENDIF

      ENDIF

   ELSEIF T == "TOOLBUTTON"                                           // Dr. Claudio Soto (March 2016)

      OldBitmap := _HMG_SYSDATA[ 3 ] [ i ]
      _HMG_SYSDATA[ 3 ] [ i ] := TB_REPLACEBITMAP( _HMG_SYSDATA[ 26 ] [ i ], c, FileName, _HMG_SYSDATA[ 32 ] [ i ], _HMG_SYSDATA[ 5 ] [ i ] )
      _HMG_SYSDATA[ 25 ] [ i ] := FileName
      IF _HMG_SYSDATA[ 3 ] [ i ] <> 0
         DeleteObject( OldBitmap )
      ENDIF

   ELSEIF T == "CHECKBOX"

      IF _HMG_SYSDATA[ 38 ] [ i ] == .T.

         IF _HMG_SYSDATA[ 16 ] [ i ] == 'I'

            IF IsAppThemed()

               IMAGELIST_DESTROY( _HMG_SYSDATA[ 37 ] [ i ] )
               _HMG_SYSDATA[ 37 ] [ i ] := _SetMixedBtnPicture( _HMG_SYSDATA[ 3 ] [ i ], FileName, _HMG_SYSDATA[ 26 ] [ i ], _HMG_SYSDATA[ 32 ] [ i ], Nil )

               RedrawWindow( _HMG_SYSDATA[ 3 ] [ i ] )
               _HMG_SYSDATA[ 25 ] [ i ] := FileName

            ELSE

               DeleteObject( _HMG_SYSDATA[ 37 ] [ i ] )
               _HMG_SYSDATA[ 37 ] [ i ] := _SetBtnPicture( c, FileName, _HMG_SYSDATA[ 32 ] [ i ], Nil )
               _HMG_SYSDATA[ 25 ] [ i ] := FileName

            ENDIF

         ELSE

            DeleteObject( _HMG_SYSDATA[ 37 ] [ i ] )
            _HMG_SYSDATA[ 37 ] [ i ] := _SetBtnPicture( _HMG_SYSDATA[ 3 ] [ i ], FileName, _HMG_SYSDATA[ 32 ] [ i ], Nil )
            _HMG_SYSDATA[ 25 ] [ i ] := FileName

         ENDIF

      ENDIF

   ELSE

      DeleteObject( _HMG_SYSDATA[ 37 ] [ i ] )
      _HMG_SYSDATA[ 37 ] [ i ] := _SetBtnPicture( _HMG_SYSDATA[ 3 ] [ i ], FileName, _HMG_SYSDATA[ 32 ] [ i ], Nil )
      _HMG_SYSDATA[ 25 ] [ i ] := FileName

   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _GetPicture()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetPicture( ControlName, ParentForm )

LOCAL i

   i := GetControlIndex( ControlName, ParentForm )

   IF i == 0
      RETURN ''
   ENDIF
RETURN ( _HMG_SYSDATA[ 25 ] [ i ] )

*+--------------------------------------------------------------------
*+
*+    Function GetData()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetData()

LOCAL PacketNames[ ADIR( _HMG_SYSDATA[ 291 ] + _HMG_SYSDATA[ 292 ] + '.*' ) ], i, Rows, Cols, RetVal := Nil, bd, aItem, aTemp := {}, r, c
LOCAL DataValue, DataType, DataLength, Packet

   bd = SET( _SET_DATEFORMAT )

   SET DATE TO ANSI

   ADIR( _HMG_SYSDATA[ 291 ] + _HMG_SYSDATA[ 292 ] + '.*', PacketNames )

   IF HMG_LEN( PacketNames ) > 0

      Packet := HB_MemoRead( _HMG_SYSDATA[ 291 ] + PacketNames[ 1 ] )                                                                       // ADD

      Rows := VAL( HB_USUBSTR( MEMOLINE( Packet,, 1 ), 11, 99 ) )
      Cols := VAL( HB_USUBSTR( MEMOLINE( Packet,, 2 ), 11, 99 ) )

      DO CASE

            // Single Data

         CASE Rows == 0 .AND. Cols == 0

            DataType := HB_USUBSTR( MEMOLINE( Packet,, 3 ), 12, 1 )
            DataLength := VAL( HB_USUBSTR( MEMOLINE( Packet,, 3 ), 14, 99 ) )

            DataValue := MEMOLINE( Packet, 254, 4 )

            DO CASE
               CASE DataType == 'C'
                  RetVal := HB_ULEFT( DataValue, DataLength )
               CASE DataType == 'N'
                  RetVal := VAL( DataValue )
               CASE DataType == 'D'
                  RetVal := CTOD( DataValue )
               CASE DataType == 'L'
                  RetVal := IIF( ALLTRIM( DataValue ) == 'T', .t., .f. )
            END CASE

            // One Dimension Array Data

         CASE Rows != 0 .AND. Cols == 0

            i := 3

            DO WHILE i < MLCOUNT( Packet )

               DataType := HB_USUBSTR( MEMOLINE( Packet,, i ), 12, 1 )
               DataLength := VAL( HB_USUBSTR( MEMOLINE( Packet,, i ), 14, 99 ) )

               i ++

               DataValue := MEMOLINE( Packet, 254, i )

               DO CASE
                  CASE DataType == 'C'
                     aItem := HB_ULEFT( DataValue, DataLength )
                  CASE DataType == 'N'
                     aItem := VAL( DataValue )
                  CASE DataType == 'D'
                     aItem := CTOD( DataValue )
                  CASE DataType == 'L'
                     aItem := IIF( ALLTRIM( DataValue ) == 'T', .t., .f. )
               END CASE

               AADD( aTemp, aItem )

               i ++

            ENDDO

            RetVal := aTemp

            // Two Dimension Array Data

         CASE Rows != 0 .AND. Cols != 0

            i := 3

            aTemp := ARRAY( Rows, Cols )

            r := 1
            c := 1

            DO WHILE i < MLCOUNT( Packet )

               DataType := HB_USUBSTR( MEMOLINE( Packet,, i ), 12, 1 )
               DataLength := VAL( HB_USUBSTR( MEMOLINE( Packet,, i ), 14, 99 ) )

               i ++

               DataValue := MEMOLINE( Packet, 254, i )

               DO CASE
                  CASE DataType == 'C'
                     aItem := HB_ULEFT( DataValue, DataLength )
                  CASE DataType == 'N'
                     aItem := VAL( DataValue )
                  CASE DataType == 'D'
                     aItem := CTOD( DataValue )
                  CASE DataType == 'L'
                     aItem := IIF( ALLTRIM( DataValue ) == 'T', .t., .f. )
               END CASE

               aTemp[ r ] [ c ] := aItem

               c ++
               IF c > Cols
                  r ++
                  c := 1
               ENDIF

               i ++

            ENDDO

            RetVal := aTemp

      END CASE
   ELSE
      SET( _SET_DATEFORMAT, bd )
      RETURN Nil
   ENDIF
   DELETE FILE ( _HMG_SYSDATA [ 291 ] + PacketNames [1] )
   SET( _SET_DATEFORMAT, bd )
RETURN ( RetVal )

*+--------------------------------------------------------------------
*+
*+    Function SendData()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SendData( cDest, Data )

LOCAL cData := '', i, j
LOCAL pData, cLen, cType, FileName, Rows, Cols

   _HMG_SYSDATA[ 290 ] ++

   FileName := _HMG_SYSDATA[ 291 ] + cDest + '.' + _HMG_SYSDATA[ 292 ] + '.' + ALLTRIM( STR( _HMG_SYSDATA[ 290 ] ) )

   IF VALTYPE( Data ) == 'A'

      IF VALTYPE( Data[ 1 ] ) != 'A'

         cData := '#DataRows=' + ALLTRIM( STR( HMG_LEN( Data ) ) ) + CHR( 13 ) + CHR( 10 )
         cData := cData + '#DataCols=0' + CHR( 13 ) + CHR( 10 )

         FOR i := 1 TO HMG_LEN( Data )

            cType := VALTYPE( Data[ i ] )

            IF cType == 'D'
               pData := ALLTRIM( STR( YEAR( data[ i ] ) ) ) + '.' + ALLTRIM( STR( MONTH( data[ i ] ) ) ) + '.' + ALLTRIM( STR( DAY( data[ i ] ) ) )
               cLen := ALLTRIM( STR( HMG_LEN( pData ) ) )
            ELSEIF cType == 'L'
               IF Data[ i ] == .t.
                  pData := 'T'
               ELSE
                  pData := 'F'
               ENDIF
               cLen := ALLTRIM( STR( HMG_LEN( pData ) ) )
            ELSEIF cType == 'N'
               pData := STR( Data[ i ] )
               cLen := ALLTRIM( STR( HMG_LEN( pData ) ) )
            ELSEIF cType == 'C'
               pData := Data[ i ]
               cLen := ALLTRIM( STR( HMG_LEN( pData ) ) )
            ELSE
               MsgHMGError( 'SendData: Type Not Suported. Program terminated' )
            ENDIF

            cData := cData + '#DataBlock=' + cType + ',' + cLen + CHR( 13 ) + CHR( 10 )
            cData := cData + pData + CHR( 13 ) + CHR( 10 )

         NEXT i

         HB_MemoWrit( FileName, cData )                               // ADD

      ELSE

         Rows := HMG_LEN( Data )
         Cols := HMG_LEN( Data[ 1 ] )

         cData := '#DataRows=' + ALLTRIM( STR( Rows ) ) + CHR( 13 ) + CHR( 10 )
         cData := cData + '#DataCols=' + ALLTRIM( STR( Cols ) ) + CHR( 13 ) + CHR( 10 )

         FOR i := 1 TO Rows

            FOR j := 1 TO Cols

               cType := VALTYPE( Data[ i ] [ j ] )

               IF cType == 'D'
                  pData := ALLTRIM( STR( YEAR( data[ i ] [ j ] ) ) ) + '.' + ALLTRIM( STR( MONTH( data[ i ] [ j ] ) ) ) + '.' + ALLTRIM( STR( DAY( data[ i ] [ j ] ) ) )
                  cLen := ALLTRIM( STR( HMG_LEN( pData ) ) )
               ELSEIF cType == 'L'
                  IF Data[ i ] [ j ] == .t.
                     pData := 'T'
                  ELSE
                     pData := 'F'
                  ENDIF
                  cLen := ALLTRIM( STR( HMG_LEN( pData ) ) )
               ELSEIF cType == 'N'
                  pData := STR( Data[ i ] [ j ] )
                  cLen := ALLTRIM( STR( HMG_LEN( pData ) ) )
               ELSEIF cType == 'C'
                  pData := Data[ i ] [ j ]
                  cLen := ALLTRIM( STR( HMG_LEN( pData ) ) )
               ELSE
                  MsgHMGError( 'SendData: Type Not Suported. Program terminated' )
               ENDIF

               cData := cData + '#DataBlock=' + cType + ',' + cLen + CHR( 13 ) + CHR( 10 )
               cData := cData + pData + CHR( 13 ) + CHR( 10 )

            NEXT j
         NEXT i

         HB_MemoWrit( FileName, cData )                               // ADD

      ENDIF

   ELSE

      cType := VALTYPE( Data )

      IF cType == 'D'
         pData := ALLTRIM( STR( YEAR( data ) ) ) + '.' + ALLTRIM( STR( MONTH( data ) ) ) + '.' + ALLTRIM( STR( DAY( data ) ) )
         cLen := ALLTRIM( STR( HMG_LEN( pData ) ) )
      ELSEIF cType == 'L'
         IF Data == .t.
            pData := 'T'
         ELSE
            pData := 'F'
         ENDIF
         cLen := ALLTRIM( STR( HMG_LEN( pData ) ) )
      ELSEIF cType == 'N'
         pData := STR( Data )
         cLen := ALLTRIM( STR( HMG_LEN( pData ) ) )
      ELSEIF cType == 'C'
         pData := Data
         cLen := ALLTRIM( STR( HMG_LEN( pData ) ) )
      ELSE
         MsgHMGError( 'SendData: Type Not Suported. Program terminated' )
      ENDIF

      cData := '#DataRows=0' + CHR( 13 ) + CHR( 10 )
      cData := cData + '#DataCols=0' + CHR( 13 ) + CHR( 10 )

      cData := cData + '#DataBlock=' + cType + ',' + cLen + CHR( 13 ) + CHR( 10 )
      cData := cData + pData + CHR( 13 ) + CHR( 10 )

      HB_MemoWrit( FileName, cData )                                  // ADD

   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _EnableToolbarButton()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _enablecontrol()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _EnableToolbarButton( ButtonName, FormName )

LOCAL i
LOCAL cCaption
LOCAL x
LOCAL c
LOCAL bAction

   i := GetControlIndex( ButtonName, FormName )

   IF i > 0

      EnableToolButton( _HMG_SYSDATA[ 26 ] [ i ], GetControlId( ButtonName, FormName ) )

      bAction := _HMG_SYSDATA[ 6 ] [ i ]

      cCaption := _HMG_SYSDATA[ 33 ] [ i ]

      IF VALTYPE( cCaption ) != 'U'

         cCaption := HMG_UPPER( cCaption )

         x := HB_UAT( '&', cCaption )

         IF x > 0
            c := ASC( HB_USUBSTR( cCaption, x + 1, 1 ) )

            IF c >= 48 .AND. c <= 90
               _DefineHotKey( FormName, MOD_ALT, c, bAction )
            ENDIF
         ENDIF
      ENDIF
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _DisableToolbarButton()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _disablecontrol()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _DisableToolbarButton( ButtonName, FormName )

LOCAL i
LOCAL cCaption
LOCAL x
LOCAL c

   i := GetControlIndex( ButtonName, FormName )

   IF i > 0

      DisableToolButton( _HMG_SYSDATA[ 26 ] [ i ], GetControlId( ButtonName, FormName ) )

      cCaption := _HMG_SYSDATA[ 33 ] [ i ]

      IF VALTYPE( cCaption ) != 'U'

         cCaption := HMG_UPPER( cCaption )

         x := HB_UAT( '&', cCaption )

         IF x > 0

            c := ASC( HB_USUBSTR( cCaption, x + 1, 1 ) )

            IF c >= 48 .AND. c <= 90
               _ReleaseHotKey( FormName, MOD_ALT, c )
            ENDIF

         ENDIF

      ENDIF

   ENDIF
RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Function _GetControlAction()
*+
*+    Called from ( h_controlmisc.prg )   2 - function domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetControlAction( ControlName, ParentForm )

LOCAL i := GetControlIndex( ControlName, ParentForm )

   IF i == 0
      RETURN ''
   ENDIF
RETURN ( _HMG_SYSDATA[ 6 ] [ i ] )

*+--------------------------------------------------------------------
*+
*+    Function _GetToolTip()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetToolTip( ControlName, ParentForm )

LOCAL i := GetControlIndex( ControlName, ParentForm )

   IF i == 0
      RETURN ''
   ENDIF
RETURN ( _HMG_SYSDATA[ 30 ] [ i ] )

*+--------------------------------------------------------------------
*+
*+    Function _SetToolTip()
*+
*+    Called from ( h_controlmisc.prg )   1 - function setproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetToolTip( ControlName, ParentForm, Value )

LOCAL i, h
LOCAL MenuItemID

   i := GetControlIndex( ControlName, ParentForm )
   IF i == 0
      RETURN Nil
   ENDIF

   IF _HMG_SYSDATA[ 1 ] [ i ] == "MENU"                               // by Dr. Claudio Soto, December 2014
      MenuItemID := _HMG_SYSDATA[ 5 ] [ i ]
      _HMG_SYSDATA[ 30 ] [ i ] := Value
      SetToolTipMenuItem( GetFormHandle( ParentForm ), Value, MenuItemID, GetMenuToolTipHandle( ParentForm ) )
   ELSE
      h := _HMG_SYSDATA[ 3 ] [ i ]
      _HMG_SYSDATA[ 30 ] [ i ] := Value
      SetToolTip( h, Value, GetFormToolTipHandle( ParentForm ) )
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _SetRangeMin()
*+
*+    Called from ( h_controlmisc.prg )   1 - function setproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetRangeMin( ControlName, ParentForm, Value )

LOCAL i, h, t, m

   i := GetControlIndex( ControlName, ParentForm )
   h := _HMG_SYSDATA[ 3 ] [ i ]
   t := GetControlType( ControlName, ParentForm )
   m := _HMG_SYSDATA[ 32 ] [ i ]

   DO CASE

      CASE T == 'SLIDER'

         SetSliderRange( h, Value, m )

      CASE T == 'SPINNER'

         SetSpinnerRange( h[ 2 ], Value, m )

      CASE T == 'PROGRESSBAR'

         SetProgressBarRange( h, Value, m )

   END CASE
   _HMG_SYSDATA[ 31 ] [ i ] := Value
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _SetRangeMax()
*+
*+    Called from ( h_controlmisc.prg )   1 - function setproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetRangeMax( ControlName, ParentForm, Value )

LOCAL i, h, t, m

   i := GetControlIndex( ControlName, ParentForm )
   h := _HMG_SYSDATA[ 3 ] [ i ]
   t := GetControlType( ControlName, ParentForm )
   m := _HMG_SYSDATA[ 31 ] [ i ]

   DO CASE
      CASE T == 'SLIDER'
         SetSliderRange( h, m, Value )

      CASE T == 'SPINNER'
         SetSpinnerRange( h[ 2 ], m, Value )

      CASE T == 'PROGRESSBAR'
         SetProgressBarRange( h, m, Value )

   END CASE
   _HMG_SYSDATA[ 32 ] [ i ] := Value
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _GetRangeMin()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetRangeMin( ControlName, ParentForm )

LOCAL i

   i := GetControlIndex( ControlName, ParentForm )

   IF i == 0
      RETURN 0
   ENDIF
RETURN ( _HMG_SYSDATA[ 31 ] [ i ] )

*+--------------------------------------------------------------------
*+
*+    Function _GetRangeMax()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetRangeMax( ControlName, ParentForm )

LOCAL i

   i := GetControlIndex( ControlName, ParentForm )

   IF i == 0
      RETURN 0
   ENDIF
RETURN ( _HMG_SYSDATA[ 32 ] [ i ] )

*+--------------------------------------------------------------------
*+
*+    Function _SetMultiCaption()
*+
*+    Called from ( h_controlmisc.prg )   2 - function setproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetMultiCaption( ControlName, ParentForm, Column, Value )

LOCAL i, h, t

   i := GetControlIndex( ControlName, ParentForm )

   h := _HMG_SYSDATA[ 3 ] [ i ]

   t := GetControlType( ControlName, ParentForm )

   _HMG_SYSDATA[ 33 ] [ i ] [ Column ] := Value

   DO CASE
      CASE t == 'GRID' .OR. t == 'MULTIGRID' .OR. t == 'BROWSE'
         SETGRIDCOLOMNHEADER( h, Column, Value )
      CASE t == 'RADIOGROUP'
         SetWindowText( h[ Column ], Value )
      CASE t == 'TAB'
         _HMG_SYSDATA[ 33 ] [ i ] [ Column ] := Value
         SETTABCAPTION( h, Column, Value )
   ENDCASE
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _GetMultiCaption()
*+
*+    Called from ( h_controlmisc.prg )   2 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetMultiCaption( ControlName, ParentForm, Item )

LOCAL i := GetControlIndex( ControlName, ParentForm )
   IF i == 0
      RETURN ''
   ENDIF
RETURN ( _HMG_SYSDATA[ 33 ] [ i ] [ item ] )

/*****************************************************************************************************************/
//  By Pablo César on June 26th, 2015

*+--------------------------------------------------------------------
*+
*+    Function InputWindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION InputWindow( cTitle, aLabels, aValues, aFormats, nRow, nCol, aBackColor, aToolTips, aHotKeys, aStyles, bCode )

LOCAL i, nLen, nControlRow := 10, nControlCol, LN, CN, nR, nC, nW, nH := 0, nDiff, cType1, cType2, nCWidth := 140, nLWidth := 90
LOCAL cForm, cGrid, aCtrlsWidths, aCtrlsWhen, nIdx, cValue, cTimeFormat, aEditControls, XRES, aFields, cControlType := ""
LOCAL cDbf, nPos, lWidthCDefined, nGridRow, nGridCol, xValue, aGridValue, cTxt, lWhen, lHidden, lCheckBoxEnabled := .F.
LOCAL aJust, lRightAlign, lHotKeysDefined, nEditOption := 0, lAtFirstImages, oError, OldScrollStep

   DEFAULT nRow := 0
   DEFAULT nCol := 0

   IF !VALTYPE( aBackColor ) = "A"
      aBackColor := NIL
   ENDIF
   IF !VALTYPE( aHotKeys ) = "A"
      aHotKeys := {}
   ENDIF
   IF VALTYPE( aStyles ) = "A" .AND. HMG_Len( aStyles ) = 2
      IF !( HMG_Len( aStyles[ 1 ] ) = 4 .AND. HMG_Len( aStyles[ 2 ] ) = 2 )
         ASIZE( aStyles[ 1 ], 4 )
         ASIZE( aStyles[ 2 ], 2 )
      ENDIF
   ELSE
      aStyles := { { nLWidth, .F., Nil, 0 }, { nCWidth, .F. } }
   ENDIF

   IF VALTYPE( cTitle ) = "U"
      cTitle := ( ThisWindow.Name )
   ENDIF
   IF VALTYPE( aLabels ) = "U"
      aLabels := ( ThisWindow.FocusedControl )
   ENDIF

   IF !VALTYPE( aLabels ) = "A"
      IF VALTYPE( cTitle ) = "C" .AND. VALTYPE( aLabels ) = "C"
         cControlType := HMG_Upper( GetControlType( aLabels, cTitle ) )
         IF "GRID" $ cControlType
            cForm := cTitle
            cGrid := aLabels
            //DoMethod(cForm,cGrid,"DisableUpdate")
            nIdx := GetControlIndex( cGrid, cForm )
            aGridValue := GetProperty( cForm, cGrid, "Value" )
            IF cControlType = "MULTIGRID"
               IF LEN( aGridValue ) = 1
                  nGridRow := aGridValue[ 1 ]
                  cTitle := "Record #" + ALLTRIM( STR( nGridRow ) ) + " edition"
               ELSE
                  nGridRow := 1
                  cTxt := ""
                  AEVAL( aGridValue, { | Arr, n | cTxt += ALLTRIM( STR( Arr ) ) + IF( n = LEN( aGridValue ), "", "," ) } )
                  cTitle := "Records #" + cTxt + " edition"
               ENDIF
               nGridCol := 1
            ELSE
               IF VALTYPE( aGridValue ) = "A"
                  nGridRow := aGridValue[ 1 ]
                  nGridCol := aGridValue[ 2 ]
               ELSE
                  nGridRow := aGridValue
                  nGridCol := 1
               ENDIF
               cTitle := "Record #" + ALLTRIM( STR( nGridRow ) ) + " edition"
            ENDIF
            IF !GetProperty( cForm, cGrid, "CELLNAVIGATION" )
               IF GetProperty( cForm, cGrid, "CELLCOLCLICKED" ) > 0
                  nGridCol := GetProperty( cForm, cGrid, "CELLCOLCLICKED" )
                  _HMG_SYSDATA[ 40 ] [ nIdx ] [ 37 ] [ 2 ] := 0       // Need to reset the last clicked
               ENDIF
            ENDIF
            IF nGridCol = 0                                           // In case click out of active columns
               RETURN Nil
            ENDIF
            lAtFirstImages := ( LEN( _HMG_SYSDATA[ 14 ] [ nIdx ] ) > 0 )
            IF nGridCol = 1 .AND. lAtFirstImages
               nGridCol ++
            ENDIF
            aLabels := {}
            IF VALTYPE( aValues ) = "A"
               aStyles[ 2, 1 ] := aValues
               lWidthCDefined := .T.
            ELSE
               lWidthCDefined := .F.
            ENDIF
            aValues := {}
            IF VALTYPE( aFormats ) = "A"
               aHotKeys := aFormats
               lHotKeysDefined := .T.
            ELSE
               lHotKeysDefined := .F.
            ENDIF
            aJust := {}
            aFormats := {}
            aCtrlsWidths := {}

            aEditControls := _HMG_SYSDATA[ 40 ] [ nIdx ] [ 2 ]
            aCtrlsWhen := _HMG_SYSDATA[ 40 ] [ nIdx ] [ 6 ]

            nEditOption := GetProperty( cForm, cGrid, "EDITOPTION" )

            cDbf := ( _HMG_SYSDATA[ 40 ] [ nIdx ] [ 10 ] )

            lCheckBoxEnabled := GetProperty( cForm, cGrid, "CHECKBOXENABLED" )
            IF lCheckBoxEnabled
               xValue := GetProperty( cForm, cGrid, "CHECKBOXITEM", nGridRow )
               AADD( aLabels, "" )                                    // "Selected item"
               AADD( aValues, xValue )
               AADD( aFormats, Nil )
               AADD( aJust, 0 )
            ENDIF

            nLen := GetProperty( cForm, cGrid, "COLUMNCOUNT" )

            nCWidth := 0
            FOR i = 1 TO nLen
               nPos := _GridEx_GetColumnDisplayPosition( cGrid, cForm, i )

               IF cControlType = "MULTIGRID"
                  IF LEN( aGridValue ) = 1

                     xValue := GetProperty( cForm, cGrid, "CELL", nGridRow, nPos )
                  ELSE
                     xValue := ""
                  ENDIF
               ELSE
                  xValue := GetProperty( cForm, cGrid, "CELL", nGridRow, nPos )
               ENDIF

               AADD( aLabels, GetProperty( cForm, cGrid, "ColumnHEADER", nPos ) )

               IF VALTYPE( aEditControls ) = "A" .AND. VALTYPE( aEditControls[ nPos ] ) = "A"
                  XRES := _HMG_PARSEGRIDCONTROLS( aEditControls, nPos )
                  DO CASE
                     CASE XRES[ 1 ] == 'CHECKBOX'
                        AADD( aValues, xValue )
                        AADD( aFormats, Nil )

                     CASE XRES[ 1 ] == 'TEXTBOX' .AND. XRES[ 2 ] == 'DATE'
                        AADD( aValues, xValue )
                        AADD( aFormats, Nil )

                     CASE XRES[ 1 ] == 'TEXTBOX' .AND. XRES[ 2 ] == 'NUMERIC'
                        AADD( aValues, xValue )
                        IF !EMPTY( XRES[ 3 ] )                        // INPUTMASK
                           AADD( aFormats, XRES[ 3 ] )
                        ELSE
                           AADD( aFormats, xValue )
                        ENDIF

                     CASE XRES[ 1 ] == 'TEXTBOX' .AND. XRES[ 2 ] == 'CHARACTER'
                        AADD( aValues, xValue )
                        AADD( aFormats, 32 )

                     CASE XRES[ 1 ] == 'TEXTBOX' .AND. XRES[ 2 ] == 'PASSWORD'                                                              // Required Grid implementation in HMG
                        IF VALTYPE( xValue ) = "U"
                           xValue := ""
                        ENDIF
                        AADD( aValues, xValue )
                        AADD( aFormats, "PASSWORD" )

                     CASE XRES[ 1 ] == 'COMBOBOX' .AND. LEN( XRES[ 5 ] ) > 0
                        AADD( aValues, xValue )
                        AADD( aFormats, XRES[ 5 ] )

                     CASE XRES[ 1 ] == 'DATEPICKER'
                        AADD( aValues, xValue )
                        IF XRES[ 7 ] = 'DROPDOWN'
                           AADD( aFormats, .F. )
                        ELSEIF XRES[ 7 ] = 'UPDOWN'
                           AADD( aFormats, .T. )
                        ENDIF

                     CASE XRES[ 1 ] == 'TIMEPICKER'
                        AADD( aValues, xValue )
                        AADD( aFormats, { HMG_TimeToTime( xValue, XRES[ 4 ] ) } )

                     CASE XRES[ 1 ] == 'SPINNER'
                        IF !( LEN( XRES[ 6 ] ) == ( LEN( aEditControls[ nPos ] ) - 1 ) )
                           XRES[ 6 ] := { aEditControls[ nPos, 2 ], aEditControls[ nPos, 3 ] }
                           IF LEN( aEditControls[ nPos ] ) = 4
                              AADD( XRES[ 6 ], aEditControls[ nPos, 4 ] )
                           ENDIF
                        ENDIF
                        IF LEN( XRES[ 6 ] ) < 3
                           AADD( aValues, { XRES[ 6, 1 ], XRES[ 6, 2 ], 1 } )
                        ELSE
                           AADD( aValues, { XRES[ 6, 1 ], XRES[ 6, 2 ], XRES[ 6, 3 ] } )
                        ENDIF
                        AADD( aFormats, xValue )

                     CASE XRES[ 1 ] == 'EDITBOX'
                        IF ":" $ xValue .AND. FILE( xValue )
                           cValue := hb_MemoRead( xValue )
                        ELSEIF "\" $ xValue .AND. FILE( GetCurrentFolder() + xValue )
                           cValue := hb_MemoRead( GetCurrentFolder() + xValue )
                        ELSEIF ( !EMPTY( cDbf ) .AND. IsDataGridMemo( nIdx, nPos ) ) .OR. HMG_LOWER( xValue ) == "<memo>"
                           aFields := ( _HMG_SYSDATA[ 40 ] [ nIdx ] [ 11 ] )
                           cValue := ( &cDbf->&( aFields[ nPos ] ) )
                        ELSE
                           cValue := xValue
                        ENDIF
                        AADD( aValues, cValue )
                        AADD( aFormats, 64 )
                  ENDCASE
               ELSE
                  IF ( !EMPTY( cDbf ) .AND. IsDataGridMemo( nIdx, nPos ) ) .OR. HMG_LOWER( xValue ) == "<memo>"
                     aFields := ( _HMG_SYSDATA[ 40 ] [ nIdx ] [ 11 ] )
                     cValue := ( &cDbf->&( aFields[ nPos ] ) )
                     xValue := cValue
                     AADD( aFormats, 64 )
                  ELSE
                     AADD( aFormats, 32 )
                  ENDIF
                  AADD( aValues, xValue )
               ENDIF

               AADD( aCtrlsWidths, GetProperty( cForm, cGrid, "COLUMNWIDTH", nPos ) )
               AADD( aJust, GetProperty( cForm, cGrid, "COLUMNJUSTIFY", nPos ) )

               IF GetColumnHeaderSize( cForm, cGrid, "COLUMNHEADERWIDTH", aLabels[ i ] ) > nLWidth
                  nLWidth := GetColumnHeaderSize( cForm, cGrid, "COLUMNHEADERWIDTH", aLabels[ i ] )
               ENDIF
            NEXT
            aStyles[ 1, 1 ] := nLWidth
            aStyles[ 1, 2 ] := .T.
            aStyles[ 1, 4 ] := 1
            IF !lWidthCDefined
               aStyles[ 2, 1 ] := aCtrlsWidths
            ENDIF
            // DoMethod(cForm,cGrid,"UnableUpdate")
         ENDIF
      ENDIF
   ENDIF

   DEFAULT cTitle := ""
   DEFAULT aStyles[ 1, 1 ] := 90
   DEFAULT aStyles[ 1, 2 ] := .F.
   DEFAULT aStyles[ 1, 4 ] := 0

   OldScrollStep := _HMG_SYSDATA[ 345 ]

   IF VALTYPE( aStyles[ 2, 1 ] ) = "A"
      IF !( HMG_Len( aStyles[ 2, 1 ] ) = HMG_Len( aLabels ) )
         ASIZE( aStyles[ 2, 1 ], HMG_Len( aLabels ) )
      ENDIF
      nCWidth := 0
      FOR i = 1 TO HMG_Len( aStyles[ 2, 1 ] )
         IF VALTYPE( aStyles[ 2, 1, i ] ) = "U"                       // .or. aStyles[2,1,i] = 140
            IF nCWidth > 140
               aStyles[ 2, 1, i ] := nCWidth
            ELSE
               aStyles[ 2, 1, i ] := 140
            ENDIF
         ENDIF
         IF aStyles[ 2, 1, i ] > nCWidth
            nCWidth := aStyles[ 2, 1, i ]
         ENDIF
      NEXT
   ELSEIF VALTYPE( aStyles[ 2, 1 ] ) = "N"
      nCWidth := aStyles[ 2, 1 ]
   ELSE
      nCWidth := 140
   ENDIF

   DEFAULT aStyles[ 2, 2 ] := .F.

   IF VALTYPE( aToolTips ) == "U"
      aToolTips := ARRAY( HMG_Len( aValues ) )
      AFILL( aToolTips, "?" )
   ELSE
      ASIZE( aToolTips, HMG_Len( aValues ) )
      AEVAL( aToolTips, { | x | x := IIF( x == Nil, "", x ) } )
   ENDIF

   nLen := HMG_Len( aLabels )
PRIVATE aResult[ nLen ]

   IF !( HMG_Len( aValues ) == nLen .AND. HMG_Len( aFormats ) == nLen )
      MsgStop( "Number of elements of arrays, doesn't match !" + CRLF + "It must be same size in:" + CRLF + CRLF + "aLabels[" + ALLTRIM( STR( HMG_Len( aLabels ) ) ) + "], aValues[" + ALLTRIM( STR( HMG_Len( aValues ) ) ) + "], aFormats[" + ALLTRIM( STR( HMG_Len( aFormats ) ) ) + "]", "Please correct your source code" )
      RETURN aResult
   ENDIF

   FOR i := 1 TO nLen                                                 // Calculate Height Window according controls height
      lHidden := .F.
      IF VALTYPE( aStyles[ 2, 1 ] ) = "A"
         nDiff := aStyles[ 2, 1, i ]
      ELSE
         nDiff := aStyles[ 2, 1 ]
      ENDIF
      IF "GRID" $ cControlType .AND. i = 1
         IF lAtFirstImages
            lHidden := .T.
         ENDIF
      ENDIF
      IF nDiff == 0
         lHidden := .T.
      ENDIF
      IF lHidden
         LOOP
      ENDIF

      DO CASE
         CASE VALTYPE( aValues[ i ] ) == 'C' .AND. VALTYPE( aFormats[ i ] ) == 'N'
            IF aFormats[ i ] > 32
               nH := nH + 94
            ELSE
               nH := nH + 30
            ENDIF
         CASE VALTYPE( aValues[ i ] ) == 'M'
            nH := nH + 94
         CASE VALTYPE( aValues[ i ] ) == 'A' .AND. VALTYPE( aFormats[ i ] ) == 'A'                                                          // Grids
            nH := nH + 94
         OTHERWISE
            nH := nH + 30
      ENDCASE
   NEXT i

   nR := nRow
   nC := nCol
   nH := nH + 90

   nW := aStyles[ 1, 1 ] + nCWidth + 50
   nControlCol := aStyles[ 1, 1 ] + 30

   IF nR + nH > GetDeskTopRealHeight()
      nDiff := nR + nH - GetDeskTopRealHeight()
      // nR := nR - nDiff
      DEFINE WINDOW _InputWindow AT nR, nC WIDTH nW HEIGHT( nH - nDiff ) ;
         VIRTUAL HEIGHT nH VIRTUAL WIDTH nW + 20 ;
         TITLE cTitle MODAL NOSIZE BackColor aBackColor ON RELEASE _InputWindowOnRelease( OldScrollStep, aHotKeys )

      SET SCROLLSTEP TO 20
   ELSE
      DEFINE WINDOW _InputWindow AT nR, nC WIDTH nW HEIGHT nH ;
         TITLE cTitle MODAL NOSIZE BackColor aBackColor ON RELEASE _InputWindowOnRelease( OldScrollStep, aHotKeys )
   ENDIF

   FOR i := 1 TO nLen

      LN := 'Label_' + ALLTRIM( STR( i, 2, 0 ) )
      CN := 'Control_' + ALLTRIM( STR( i, 2, 0 ) )
      lHidden := .F.

      IF VALTYPE( aStyles[ 2, 1 ] ) = "A"
         nCWidth := aStyles[ 2, 1, i ]
      ELSE
         nCWidth := aStyles[ 2, 1 ]
      ENDIF

      IF VALTYPE( aCtrlsWhen ) = 'A'
         IF HMG_Len( aCtrlsWhen ) >= i
            IF VALTYPE( aCtrlsWhen[ i ] ) = 'B'
               _HMG_SYSDATA[ 202 ] := i                               // This.QueryColIndex
               _HMG_SYSDATA[ 196 ] := i                               // This.CellColIndex
               _HMG_SYSDATA[ 318 ] := GetProperty( cForm, cGrid, "CellEx", nGridRow, i )                                                    // This.CellValue

               BEGIN SEQUENCE WITH { | oError | BREAK( oError ) }
                  lWhen := EVAL( aCtrlsWhen[ i ] )
               RECOVER USING oError
                  MsgStop( "Error: " + ( oError:Description ) + CRLF + CRLF + "Please check COLUMNWHEN at column #" + ALLTRIM( STR( i ) ) + CRLF + CRLF + 'Tips: Do not use any "This.xxx" like This.CellValue, etc.' + CRLF + "         Use just .T. or .F.", "Exemption edit aborted" )
               END SEQUENCE
            ELSEIF VALTYPE( aCtrlsWhen[ i ] ) = 'L'
               lWhen := aCtrlsWhen[ i ]
            ELSE
               lWhen := .T.
            ENDIF
            IF !VALTYPE( lWhen ) = "L"
               lWhen := .T.
            ENDIF
         ENDIF
      ELSE
         lWhen := .T.
      ENDIF

      IF "GRID" $ cControlType .AND. i = 1
         IF lCheckBoxEnabled
            lHidden := .F.
         ELSE
            IF lAtFirstImages
               lHidden := .T.
            ENDIF
         ENDIF
      ENDIF
      IF nCWidth == 0
         lHidden := .T.
      ENDIF

      IF VALTYPE( aJust ) = "A"
         lRightAlign := IF( aJust[ i ] = 1, .T., .F. )
      ELSE
         lRightAlign := .F.
      ENDIF

      DEFINE LABEL &( LN )
         PARENT "_InputWindow"
         ROW nControlRow
         COL 10
         VALUE aLabels[ i ]
         WIDTH aStyles[ 1, 1 ]
         FONTBOLD aStyles[ 1, 2 ]
         BACKCOLOR aBackColor
         FONTCOLOR aStyles[ 1, 3 ]
         RIGHTALIGN IF( aStyles[ 1, 4 ] = 1, .T., .F. )
         CENTERALIGN IF( aStyles[ 1, 4 ] = 2, .T., .F. )
      END LABEL

      nDiff := 30
      cType1 := VALTYPE( aValues[ i ] )
      cType2 := VALTYPE( aFormats[ i ] )

      DO CASE
         CASE cType1 == 'L'

            DEFINE CHECKBOX &( CN )
               PARENT "_InputWindow"
               ROW nControlRow
               COL nControlCol
               CAPTION ""
               VALUE aValues[ i ]
               WIDTH nCWidth
               FONTBOLD aStyles[ 2, 2 ]
               TOOLTIP aToolTips[ i ]
               BACKCOLOR aBackColor
            END CHECKBOX
         CASE cType1 == 'D'
            /* Probably need to be reforced as logical when is not a grid
                If cType2 == "U"
                   aFormats[i]:=.T.

                Endif  */

            DEFINE DATEPICKER &( CN )
               PARENT "_InputWindow"
               ROW nControlRow
               COL nControlCol
               WIDTH nCWidth
               FONTBOLD aStyles[ 2, 2 ]
               TOOLTIP aToolTips[ i ]
               VALUE aValues[ i ]
               UPDOWN aFormats[ i ]
               RIGHTALIGN lRightAlign
               FORMAT aFormats[ i ]
               IF aFormats[ i ] == "  "
                  // ONCHANGE _InputWindowSetDtFormat("_InputWindow", CN)
                  ONCHANGE SetProperty( ThisWindow.Name, This.Name, "FORMAT", HBtoWinDateFormat() )
               ENDIF
            END DATEPICKER

         CASE cType1 == 'N'
            IF cType2 == 'A'

               DEFINE COMBOBOX &( CN )
                  PARENT "_InputWindow"
                  ROW nControlRow
                  COL nControlCol
                  WIDTH nCWidth
                  FONTBOLD aStyles[ 2, 2 ]
                  TOOLTIP aToolTips[ i ]
                  ITEMS aFormats[ i ]
                  VALUE aValues[ i ]
               END COMBOBOX
            ELSEIF cType2 == 'C'
               IF hb_UAT( '.', aFormats[ i ] ) > 0

                  DEFINE TEXTBOX &( CN )
                     PARENT "_InputWindow"
                     ROW nControlRow
                     COL nControlCol
                     VALUE aValues[ i ]
                     WIDTH nCWidth
                     INPUTMASK CharOnly( "0123456789.", aFormats[ i ] )
                     FONTBOLD aStyles[ 2, 2 ]
                     TOOLTIP aToolTips[ i ]
                     DATATYPE NUMERIC
                     RIGHTALIGN lRightAlign
                  END TEXTBOX
               ELSE

                  DEFINE TEXTBOX &( CN )
                     PARENT "_InputWindow"
                     ROW nControlRow
                     COL nControlCol
                     VALUE aValues[ i ]
                     WIDTH nCWidth
                     INPUTMASK aFormats[ i ]
                     FONTBOLD aStyles[ 2, 2 ]
                     TOOLTIP aToolTips[ i ]
                     DATATYPE NUMERIC
                     RIGHTALIGN lRightAlign
                  END TEXTBOX
                  // MAXLENGTH  HMG_Len(aFormats[i])
               ENDIF
            ELSEIF cType2 == 'N'

               DEFINE TEXTBOX &( CN )
                  PARENT "_InputWindow"
                  ROW nControlRow
                  COL nControlCol
                  VALUE aValues[ i ]
                  WIDTH nCWidth
                  FONTBOLD aStyles[ 2, 2 ]
                  TOOLTIP aToolTips[ i ]
                  MAXLENGTH aFormats[ i ]
                  DATATYPE NUMERIC
                  RIGHTALIGN lRightAlign
               END TEXTBOX
            ENDIF
         CASE cType1 == 'C'
            IF cType2 == 'N'
               IF aFormats[ i ] <= 32

                  DEFINE TEXTBOX &( CN )
                     PARENT "_InputWindow"
                     ROW nControlRow
                     COL nControlCol
                     VALUE aValues[ i ]
                     WIDTH nCWidth
                     FONTBOLD aStyles[ 2, 2 ]
                     TOOLTIP aToolTips[ i ]
                     MAXLENGTH aFormats[ i ]
                     DATATYPE CHARACTER
                     RIGHTALIGN lRightAlign
                  END TEXTBOX
               ELSE

                  DEFINE EDITBOX &( CN )
                     PARENT "_InputWindow"
                     ROW nControlRow
                     COL nControlCol
                     VALUE aValues[ i ]
                     WIDTH nCWidth
                     HEIGHT 90
                     FONTBOLD aStyles[ 2, 2 ]
                     TOOLTIP aToolTips[ i ]

                  END EDITBOX
                  // MAXLENGTH  aFormats[i]
                  nDiff := 94
               ENDIF
            ELSEIF cType2 == 'A'
               cTimeFormat := CharRem( "{}", hb_ValToExp( aFormats[ i ] ) )
               cTimeFormat := CharRem( CHR( 34 ) + CHR( 39 ), cTimeFormat )
               cValue := hb_ValToExp( aValues[ i ] )
               cValue := CharRem( CHR( 34 ) + CHR( 39 ), cValue )

               DEFINE TIMEPICKER &( CN )
                  PARENT "_InputWindow"
                  ROW nControlRow
                  COL nControlCol
                  VALUE aValues[ i ]
                  WIDTH nCWidth
                  FONTBOLD aStyles[ 2, 2 ]
                  TOOLTIP aToolTips[ i ]
                  FORMAT cTimeFormat
               END TIMEPICKER
            ELSEIF cType2 == 'C'
               IF HMG_Upper( aFormats[ i ] ) == 'PASSWORD'

                  DEFINE TEXTBOX &( CN )
                     PARENT "_InputWindow"
                     ROW nControlRow
                     COL nControlCol
                     VALUE aValues[ i ]
                     WIDTH nCWidth
                     FONTBOLD aStyles[ 2, 2 ]
                     TOOLTIP aToolTips[ i ]
                     PASSWORD .T.
                     FONTBOLD aStyles[ 2, 2 ]
                     TOOLTIP aToolTips[ i ]
                     DATATYPE CHARACTER
                     RIGHTALIGN lRightAlign
                  END TEXTBOX
               ELSE

                  DEFINE TEXTBOX &( CN )
                     PARENT "_InputWindow"
                     ROW nControlRow
                     COL nControlCol
                     VALUE aValues[ i ]
                     WIDTH nCWidth
                     INPUTMASK aFormats[ i ]
                     FONTBOLD aStyles[ 2, 2 ]
                     TOOLTIP aToolTips[ i ]
                     DATATYPE CHARACTER
                     RIGHTALIGN lRightAlign
                  END TEXTBOX
               ENDIF
            ELSE

               DEFINE LABEL &( CN )
                  PARENT "_InputWindow"
                  ROW nControlRow
                  COL nControlCol - 20
                  VALUE aLabels[ i ]
                  WIDTH nCWidth + 20
                  FONTBOLD aStyles[ 1, 2 ]
                  TOOLTIP aToolTips[ i ]
                  BACKCOLOR aBackColor
                  FONTCOLOR aStyles[ 1, 3 ]
               END LABEL

               nDiff := 20
            ENDIF
         CASE cType1 == 'M'

            DEFINE EDITBOX &( CN )
               PARENT "_InputWindow"
               ROW nControlRow
               COL nControlCol
               FIELD aValues[ i ]
               WIDTH nCWidth
               HEIGHT 90
               FONTBOLD aStyles[ 2, 2 ]
               TOOLTIP aToolTips[ i ]

            END EDITBOX
            // MAXLENGTH  aFormats[i]

            nDiff := 94
         CASE cType1 == 'A'
            IF cType2 == 'N'
               /* aValues[i,3] (Incremental, new)
                      Used aValues in place of aFormats, due only available option in InputWindow to differentiate to others */

               DEFINE SPINNER &( CN )
                  PARENT "_InputWindow"
                  ROW nControlRow
                  COL nControlCol
                  RANGEMAX aValues[ i, 1 ]
                  RANGEMIN aValues[ i, 2 ]
                  VALUE aFormats[ i ]
                  WIDTH nCWidth
                  FONTBOLD aStyles[ 2, 2 ]
                  TOOLTIP aToolTips[ i ]
                  INCREMENT aValues[ i, 3 ]
               END SPINNER
            ELSE

               DEFINE GRID &( CN )
                  PARENT "_InputWindow"
                  ROW nControlRow
                  COL nControlCol
                  WIDTH nCWidth
                  HEIGHT 90
                  FONTBOLD aStyles[ 2, 2 ]
                  TOOLTIP aToolTips[ i ]
                  ITEMS aValues[ i ]
                  HEADERS aFormats[ i, 1 ]
                  WIDTHS aFormats[ i, 2 ]
                  ALLOWEDIT .T.
                  MULTISELECT .F.
                  CELLNAVIGATION .T.
               END GRID
               nDiff := 94
            ENDIF
      ENDCASE
      IF !lWhen
         SetProperty( "_InputWindow", CN, "Enabled", lWhen )
      ENDIF
      IF lHidden
         DoMethod( "_InputWindow", LN, "Hide" )
         DoMethod( "_InputWindow", CN, "Hide" )
      ELSE
         nControlRow += nDiff
      ENDIF
   NEXT i
   IF "GRID" $ cControlType
      CN := 'Control_' + ALLTRIM( STR( _GridEx_GetColumnDisplayPosition( cGrid, cForm, nGridCol ) + IF( lCheckBoxEnabled, 1, 0 ), 2, 0 ) )
      DoMethod( "_InputWindow", CN, "SetFocus" )
      IF nEditOption > 0 .AND. "TEXT" $ HMG_Upper( GetControlType( CN, "_InputWindow" ) )
         _InplaceEditOpt( "_InputWindow", CN, nEditOption )
      ENDIF
   ENDIF
   @ nControlRow + 10, nW / 2 - 110 BUTTON BUTTON_1 ;
           OF _InputWindow ;
           CAPTION _hMG_SYSDATA[ 128 ] [ 8 ] ;
           ACTION _InputWindowOk()

   @ nControlRow + 10, nW / 2 BUTTON BUTTON_2 ;
           OF _InputWindow ;
           CAPTION _hMG_SYSDATA[ 128 ] [ 7 ] ;
           ACTION _InputWindowCancel()

   nLen := HMG_Len( aHotKeys )
   FOR i := 1 TO nLen
      _DefineHotKey( "_InputWindow", aHotKeys[ i, 1 ], aHotKeys[ i, 2 ], aHotKeys[ i, 3 ] )
   NEXT

   IF VALTYPE( _GetHotKey( "_InputWindow", 0, VK_ESCAPE ) ) = "U"
      _DefineHotKey( "_InputWindow", 0, VK_ESCAPE, { || ThisWindow.Release() } )
   ENDIF

   IF VALTYPE( bCode ) = 'B'
      EVAL( bCode )
   ENDIF

   END WINDOW
   IF nRow = 0 .OR. nCol = 0
      CENTER WINDOW _InputWindow
   ENDIF
   IF nRow > 0
      _InputWindow.Row := nR
   ENDIF
   IF nCol > 0
      _InputWindow.Col := nC
   ENDIF
   ACTIVATE WINDOW _InputWindow
RETURN aResult

*+--------------------------------------------------------------------
*+
*+    Procedure _InputWindowSetDtFormat()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE _InputWindowSetDtFormat( cForm, cControl, cDtFormat )       // By Pablo César on June 26th, 2015

   hb_default( @cDtFormat, HBtoWinDateFormat() )
   SetProperty( cForm, cControl, "FORMAT", cDtFormat )
RETURN

*+--------------------------------------------------------------------
*+
*+    Function HBtoWinDateFormat()
*+
*+    Called from ( h_controlmisc.prg )   2 - function _getvalue()
*+                                   1 - function inputwindow()
*+                                   1 - procedure _inputwindowsetdtformat()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HBtoWinDateFormat()                                          // By Pablo César on June 26th, 2015

LOCAL cDateFormat := HMG_LOWER( SET( _SET_DATEFORMAT ) )
RETURN CharRepl( "m", @cDateFormat, "M" )                             // this transform is need for internal structure of date format of MonthCal/DatePick controls

*+--------------------------------------------------------------------
*+
*+    Function _InputWindowOnRelease()
*+
*+    Called from ( h_controlmisc.prg )   2 - function inputwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _InputWindowOnRelease( OldScrollStep, aHotKeys )             // By Pablo on June 26th, 2015

LOCAL i, nLen := HMG_Len( aHotKeys )

   SET SCROLLSTEP TO OldScrollStep

   FOR i := 1 TO nLen
      _ReleaseHotKey( "_InputWindow", aHotKeys[ i, 1 ], aHotKeys[ i, 2 ] )
   NEXT

   IF VALTYPE( _GetHotKey( "_InputWindow", 0, VK_ESCAPE ) ) = "U"
      _ReleaseHotKey( "_InputWindow", 0, VK_ESCAPE )
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function GetColumnHeaderSize()
*+
*+    Called from ( h_controlmisc.prg )   2 - function inputwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetColumnHeaderSize( Arg1, Arg2, Arg3, Arg4 )                // By Pablo César on June 26th, 2015 (function renamed, was My_GeProperty)

LOCAL nRet := 0, hGrid, hHeader, hFont

   hGrid := GetControlHandle( Arg2, Arg1 )
   hHeader := ListView_GetHeader( hGrid )
   hFont := SendMessage( hHeader, WM_GETFONT, 0, 0 )
   DO CASE
      CASE HMG_Upper( Arg3 ) == "COLUMNHEADERWIDTH"
         nRet := GetTextWidth( NIL, Arg4, hFont )
      CASE HMG_Upper( Arg3 ) == "COLUMNHEADERHEIGHT"
         nRet := GetTextHeight( NIL, Arg4, hFont )
   ENDCASE
RETURN nRet

*+--------------------------------------------------------------------
*+
*+    Function SetMethodCode()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SetMethodCode( cForm, cControl, cMethod, bCode )             // By Pablo César on June 26th, 2015 (not renamed because is known by Minigui users)

LOCAL nIndex       := GetControlIndex( cControl, cForm )
LOCAL cControlType := GetControlTypeByIndex( nIndex )

   DO CASE
      CASE nIndex = 0
      CASE cControlType = "COMBO"
         DO CASE
            CASE cMethod = 'DISPLAYCHANGE'
               _HMG_SYSDATA[ 6 ] [ nIndex ] := bCode
            CASE cMethod = 'LISTDISPLAY'
               // _HMG_aControlInputMask [nIndex] := bCode
            CASE cMethod = 'LOSTFOCUS'
               _HMG_SYSDATA[ 10 ] [ nIndex ] := bCode
            CASE cMethod = 'GOTFOCUS'
               _HMG_SYSDATA[ 11 ] [ nIndex ] := bCode
            CASE cMethod = 'CHANGE'
               _HMG_SYSDATA[ 12 ] [ nIndex ] := bCode
            CASE cMethod = 'ENTER'
               _HMG_SYSDATA[ 16 ] [ nIndex ] := bCode
            CASE cMethod = 'LISTCLOSE'
               // _HMG_aControlPicture[nIndex] :=  bCode
         ENDCASE
      CASE cControlType = "TEXT" .OR. cControlType = "NUMTEXT" .OR. cControlType = "MASKEDTEXT"
         DO CASE
            CASE cMethod = 'LOSTFOCUS'
               _HMG_SYSDATA[ 10 ] [ nIndex ] := bCode
               SetProperty( cForm, cControl, cMethod, bCode )
            CASE cMethod = 'GOTFOCUS'
               _HMG_SYSDATA[ 11 ] [ nIndex ] := bCode
            CASE cMethod = 'CHANGE'
               _HMG_SYSDATA[ 12 ] [ nIndex ] := bCode
            CASE cMethod = 'ENTER'
               _HMG_SYSDATA[ 16 ] [ nIndex ] := bCode
         ENDCASE
      CASE cControlType = "EDIT"
         DO CASE
            CASE cMethod = 'LOSTFOCUS'
               _HMG_SYSDATA[ 10 ] [ nIndex ] := bCode
            CASE cMethod = 'GOTFOCUS'
               _HMG_SYSDATA[ 11 ] [ nIndex ] := bCode
            CASE cMethod = 'CHANGE'
               _HMG_SYSDATA[ 12 ] [ nIndex ] := bCode
         ENDCASE
      CASE cControlType = "DATEPICK"
         DO CASE
            CASE cMethod = 'LOSTFOCUS'
               _HMG_SYSDATA[ 10 ] [ nIndex ] := bCode
            CASE cMethod = 'GOTFOCUS'
               _HMG_SYSDATA[ 11 ] [ nIndex ] := bCode
            CASE cMethod = 'CHANGE'
               _HMG_SYSDATA[ 12 ] [ nIndex ] := bCode
            CASE cMethod = 'ENTER'
               _HMG_SYSDATA[ 6 ] [ nIndex ] := bCode
         ENDCASE
      CASE cControlType = "CHECKBOX"
         DO CASE
            CASE cMethod = 'LOSTFOCUS'
               _HMG_SYSDATA[ 10 ] [ nIndex ] := bCode
            CASE cMethod = 'GOTFOCUS'
               _HMG_SYSDATA[ 11 ] [ nIndex ] := bCode
            CASE cMethod = 'CHANGE'
               _HMG_SYSDATA[ 12 ] [ nIndex ] := bCode
            CASE cMethod = 'ENTER'
               _HMG_SYSDATA[ 6 ] [ nIndex ] := bCode
         ENDCASE
      CASE cControlType = "GRID"
         DO CASE
            CASE cMethod = 'LOSTFOCUS'
               _HMG_SYSDATA[ 10 ] [ nIndex ] := bCode
            CASE cMethod = 'GOTFOCUS'
               _HMG_SYSDATA[ 11 ] [ nIndex ] := bCode
            CASE cMethod = 'CHANGE'
               _HMG_SYSDATA[ 12 ] [ nIndex ] := bCode
            CASE cMethod = 'ENTER'
               _HMG_SYSDATA[ 16 ] [ nIndex ] := .T.
         ENDCASE
   ENDCASE
   DO Events
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _InplaceEditOpt()
*+
*+    Called from ( h_controlmisc.prg )   1 - function inputwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _InplaceEditOpt( Arg1, Arg2, nInplaceEditOption )

LOCAL nCtrlHnd := GetControlHandle( Arg2, Arg1 )

   IF nInplaceEditOption == 2
      _PushKey( VK_END )
   ELSEIF nInplaceEditOption == 3
      SendMessage( nCtrlHnd, WM_KEYDOWN, VK_END, 0 )
      SendMessage( nCtrlHnd, WM_KEYUP, VK_END, 0 )
      HMG_SendCharacterEx( nCtrlHnd, HMG_GetLastCharacterEx() )
      _PushKey( VK_END )
   ELSEIF nInplaceEditOption == 4
      //_PushKey (VK_BACK)
      HMG_SendCharacter( nCtrlHnd, HMG_GetLastCharacterEx() )
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _InputWindowOk()
*+
*+    Called from ( h_controlmisc.prg )   1 - function inputwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _InputWindowOk()

LOCAL i, r, c, nRowCount, nColCount, cControlName, l, aTemp, aTupla

   l := HMG_Len( aResult )
   FOR i := 1 TO l
      cControlName := 'Control_' + ALLTRIM( STR( i, 2, 0 ) )
      IF GetControlType( cControlName, '_InputWindow' ) = "GRID"
         aTemp := {}
         nRowCount := GetProperty( "_InputWindow", cControlName, "ItemCount" )
         nColCount := _GridEx_ColumnCount( cControlName, '_InputWindow' )
         FOR r := 1 TO nRowCount
            aTupla := {}
            FOR c = 1 TO nColCount
               AADD( aTupla, _GridEx_GetCellValue( cControlName, '_InputWindow', r, c ) )
            NEXT
            AADD( aTemp, aTupla )
         NEXT
         aResult[ i ] := aTemp
      ELSE
         aResult[ i ] := _GetValue( cControlName, '_InputWindow' )
      ENDIF
   NEXT i
   RELEASE WINDOW _InputWindow
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _InputWindowCancel()
*+
*+    Called from ( h_controlmisc.prg )   1 - function inputwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _InputWindowCancel()

   AEVAL( aResult, { | x, i | HB_SYMBOL_UNUSED( x ), aResult[ i ] := Nil } )
   RELEASE WINDOW _InputWindow
RETURN Nil

/*****************************************************************************************************************/

*+--------------------------------------------------------------------
*+
*+    Function _ReleaseControl()
*+
*+    Called from ( h_controlmisc.prg )   1 - function domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _ReleaseControl( ControlName, ParentForm )

LOCAL i, t, r, w, z, x, y, k

   i := GetControlIndex( ControlName, ParentForm )
   t := GetControlType( ControlName, ParentForm )
   k := GetFormIndex( ParentForm )

   DO CASE
      CASE t == "GRID"

         ReleaseControl( _HMG_SYSDATA[ 3 ] [ i ] )

      CASE t == "ANIMATEBOX"
         _DestroyAnimateBox( ControlName, ParentForm )

      CASE t == "PLAYER"
         _DestroyPlayer( ControlName, ParentForm )

      CASE t == "SPINNER"
         ReleaseControl( _HMG_SYSDATA[ 3 ] [ i ] [ 1 ] )
         ReleaseControl( _HMG_SYSDATA[ 3 ] [ i ] [ 2 ] )

      CASE t == "STATUSBAR"
         IF _IsControlDefined( 'StatusTimer', ParentForm )
            ReleaseControl( _HMG_SYSDATA[ 3 ] [ GetControlIndex( 'StatusTimer', ParentForm ) ] )
            _EraseControl( GetControlIndex( 'StatusTimer', ParentForm ), k )
         ENDIF

         IF _IsControlDefined( 'StatusKeyBrd', ParentForm )
            ReleaseControl( _HMG_SYSDATA[ 3 ] [ GetControlIndex( 'StatusKeyBrd', ParentForm ) ] )
            _EraseControl( GetControlIndex( 'StatusKeyBrd', ParentForm ), k )
         ENDIF

         ReleaseControl( _HMG_SYSDATA[ 3 ] [ i ] )

#ifdef COMPILEBROWSE

      CASE t == "BROWSE"

         ReleaseControl( _HMG_SYSDATA[ 3 ] [ i ] )

         IF _HMG_SYSDATA[ 5 ] [ i ] != 0

            ReleaseControl( _HMG_SYSDATA[ 5 ] [ i ] )
            ReleaseControl( _HMG_SYSDATA[ 39 ] [ i ] [ 1 ] )

         ENDIF

#endif

      CASE t == "RADIOGROUP"

         FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 3 ] [ i ] )
            ReleaseControl( _HMG_SYSDATA[ 3 ] [ i ] [ x ] )
         NEXT x

      CASE t == "TAB"

         FOR r = 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] [ i ] )
            FOR w = 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] [ i ] [ r ] )
               IF VALTYPE( _HMG_SYSDATA[ 7 ] [ i ] [ r ] [ w ] ) <> "A"
                  ReleaseControl( _HMG_SYSDATA[ 7 ] [ i ] [ r ] [ w ] )
                  x := ASCAN( _HMG_SYSDATA[ 3 ], _HMG_SYSDATA[ 7 ] [ i ] [ r ] [ w ] )
                  IF x > 0
                     _EraseControl( x, k )
                  ENDIF
               ELSE
                  FOR z = 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] [ i ] [ r ] [ w ] )
                     ReleaseControl( _HMG_SYSDATA[ 7 ] [ i ] [ r ] [ w ] [ z ] )
                  NEXT z

                  FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 3 ] )
                     IF VALTYPE( _HMG_SYSDATA[ 3 ] [ x ] ) == 'A'
                        IF _HMG_SYSDATA[ 3 ] [ x ] [ 1 ] == _HMG_SYSDATA[ 7 ] [ i ] [ r ] [ w ] [ 1 ]
                           _EraseControl( x, k )
                           EXIT
                        ENDIF
                     ENDIF
                  NEXT x

               ENDIF
            NEXT w
         NEXT r

         ReleaseControl( _HMG_SYSDATA[ 3 ] [ i ] )

      OTHERWISE
         ReleaseControl( _HMG_SYSDATA[ 3 ] [ i ] )
   ENDCASE

   // If the control is inside a TAB, PageMap must be updated

   FOR y := 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] )

      IF _HMG_SYSDATA[ 1 ] [ y ] == "TAB"

         FOR r = 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] [ y ] )

            FOR w = 1 TO HMG_LEN( _HMG_SYSDATA[ 7 ] [ y ] [ r ] )

               IF t == 'RADIOGROUP'

                  IF VALTYPE( _HMG_SYSDATA[ 7 ] [ y ] [ r ] [ w ] ) == 'A'

                     IF _HMG_SYSDATA[ 7 ] [ y ] [ r ] [ w ] [ 1 ] == _HMG_SYSDATA[ 3 ] [ i ] [ 1 ]

                        ADEL( _HMG_SYSDATA[ 7 ] [ y ] [ r ], w )
                        ASIZE( _HMG_SYSDATA[ 7 ] [ y ] [ r ], HMG_LEN( _HMG_SYSDATA[ 7 ] [ y ] [ r ] ) - 1 )
                        EXIT

                     ENDIF

                  ENDIF

               ELSEIF t == 'SPINNER'

                  IF VALTYPE( _HMG_SYSDATA[ 7 ] [ y ] [ r ] [ w ] ) == 'A'

                     IF _HMG_SYSDATA[ 7 ] [ y ] [ r ] [ w ] [ 1 ] == _HMG_SYSDATA[ 3 ] [ i ] [ 1 ]

                        ADEL( _HMG_SYSDATA[ 7 ] [ y ] [ r ], w )
                        ASIZE( _HMG_SYSDATA[ 7 ] [ y ] [ r ], HMG_LEN( _HMG_SYSDATA[ 7 ] [ y ] [ r ] ) - 1 )
                        EXIT

                     ENDIF

                  ENDIF

#ifdef COMPILEBROWSE

               ELSEIF t == 'BROWSE'

                  IF VALTYPE( _HMG_SYSDATA[ 7 ] [ y ] [ r ] [ w ] ) == 'A'

                     IF _HMG_SYSDATA[ 7 ] [ y ] [ r ] [ w ] [ 1 ] == _HMG_SYSDATA[ 3 ] [ i ]

                        ADEL( _HMG_SYSDATA[ 7 ] [ y ] [ r ], w )
                        ASIZE( _HMG_SYSDATA[ 7 ] [ y ] [ r ], HMG_LEN( _HMG_SYSDATA[ 7 ] [ y ] [ r ] ) - 1 )
                        EXIT

                     ENDIF

                  ELSEIF VALTYPE( _HMG_SYSDATA[ 7 ] [ y ] [ r ] [ w ] ) == 'N'

                     IF _HMG_SYSDATA[ 7 ] [ y ] [ r ] [ w ] == _HMG_SYSDATA[ 3 ] [ i ]

                        ADEL( _HMG_SYSDATA[ 7 ] [ y ] [ r ], w )
                        ASIZE( _HMG_SYSDATA[ 7 ] [ y ] [ r ], HMG_LEN( _HMG_SYSDATA[ 7 ] [ y ] [ r ] ) - 1 )
                        EXIT

                     ENDIF

                  ENDIF

#endif

               ELSE

                  IF VALTYPE( _HMG_SYSDATA[ 7 ] [ y ] [ r ] [ w ] ) == 'N'

                     IF _HMG_SYSDATA[ 7 ] [ y ] [ r ] [ w ] == _HMG_SYSDATA[ 3 ] [ i ]

                        ADEL( _HMG_SYSDATA[ 7 ] [ y ] [ r ], w )
                        ASIZE( _HMG_SYSDATA[ 7 ] [ y ] [ r ], HMG_LEN( _HMG_SYSDATA[ 7 ] [ y ] [ r ] ) - 1 )
                        EXIT

                     ENDIF

                  ENDIF

               ENDIF

            NEXT w

         NEXT r

      ENDIF

   NEXT y
   _EraseControl( i, k )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _EraseControl()
*+
*+    Called from ( h_controlmisc.prg )   5 - function _releasecontrol()
*+                ( h_hotkey.prg )   1 - procedure _definehotkey()
*+                                   1 - procedure _releasehotkey()
*+                ( h_windows.prg )   1 - function events()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _EraseControl( i, nParentIndex )

LOCAL mVar
   // i = nControlIndex// nParentIndex (nFormIndex)
   DeleteObject( _HMG_SYSDATA[ 36 ] [ i ] )
   DeleteObject( _HMG_SYSDATA[ 37 ] [ i ] )

   IF IsAppThemed() .AND. ( _HMG_SYSDATA[ 1 ] [ i ] == 'BUTTON' .OR. _HMG_SYSDATA[ 1 ] [ i ] == 'CHECKBOX' )
      IMAGELIST_DESTROY( _HMG_SYSDATA[ 37 ] [ i ] )
   ENDIF

   IF _HMG_SYSDATA[ 1 ] [ i ] == 'GRID' .OR. _HMG_SYSDATA[ 1 ] [ i ] == 'MULTIGRID'
      IF VALTYPE( _HMG_SYSDATA[ 26 ] [ i ] ) == 'N'
         IMAGELIST_DESTROY( _HMG_SYSDATA[ 26 ] [ i ] )
      ENDIF
      IF _HMG_SYSDATA[ 40 ] [ i ] [ 42 ] <> 0                         // hFont_Dynamic
         DeleteObject( _HMG_SYSDATA[ 40 ] [ i ] [ 42 ] )
      ENDIF
   ENDIF

#ifdef COMPILEBROWSE
   IF _HMG_SYSDATA[ 1 ] [ i ] == 'BROWSE'
      IF VALTYPE( _HMG_SYSDATA[ 39 ] [ i ] [ 10 ] ) == 'N'
         IMAGELIST_DESTROY( _HMG_SYSDATA[ 39 ] [ i ] [ 10 ] )
      ENDIF
   ENDIF
#endif

   IF _HMG_SYSDATA[ 1 ] [ i ] == 'COMBO'
      IF VALTYPE( _HMG_SYSDATA[ 15 ] [ i ] ) == 'N'
         IMAGELIST_DESTROY( _HMG_SYSDATA[ 15 ] [ i ] )
      ENDIF
   ENDIF

   IF _HMG_SYSDATA[ 1 ] [ i ] == 'ACTIVEX'
      DestroyWindow( _HMG_SYSDATA[ 1 ] [ i ] )
      FreeLibrary( _HMG_SYSDATA[ 35 ] [ i ] )
   ENDIF

   IF _HMG_SYSDATA[ 1 ] [ i ] == 'HOTKEY'
      ReleaseHotKey( _HMG_SYSDATA[ 4 ] [ i ], _HMG_SYSDATA[ 5 ] [ i ] )
   ENDIF

   IF _HMG_SYSDATA[ 1 ] [ i ] == 'TAB'
      IF _HMG_SYSDATA[ 9 ] [ i ] != 0
         IMAGELIST_DESTROY( _HMG_SYSDATA[ 9 ] [ i ] )
      ENDIF
   ENDIF

   mVar := '_' + _HMG_SYSDATA[ 66 ] [ nParentIndex ] + '_' + _HMG_SYSDATA[ 2 ] [ i ]
   IF TYPE( mVar ) != 'U'
      __MVPUT( mVar, 0 )
   ENDIF

   _HMG_SYSDATA[ 13 ] [ i ] := .T.
   _HMG_SYSDATA[ 1 ] [ i ] := ""
   _HMG_SYSDATA[ 2 ] [ i ] := ""
   _HMG_SYSDATA[ 3 ] [ i ] := 0
   _HMG_SYSDATA[ 4 ] [ i ] := 0
   _HMG_SYSDATA[ 5 ] [ i ] := 0
   _HMG_SYSDATA[ 6 ] [ i ] := ""
   _HMG_SYSDATA[ 7 ] [ i ] := {}
   _HMG_SYSDATA[ 8 ] [ i ] := Nil
   _HMG_SYSDATA[ 9 ] [ i ] := ""
   _HMG_SYSDATA[ 10 ] [ i ] := ""
   _HMG_SYSDATA[ 11 ] [ i ] := ""
   _HMG_SYSDATA[ 12 ] [ i ] := ""
   _HMG_SYSDATA[ 14 ] [ i ] := Nil
   _HMG_SYSDATA[ 15 ] [ i ] := Nil
   _HMG_SYSDATA[ 16 ] [ i ] := ""
   _HMG_SYSDATA[ 17 ] [ i ] := {}
   _HMG_SYSDATA[ 18 ] [ i ] := 0
   _HMG_SYSDATA[ 19 ] [ i ] := 0
   _HMG_SYSDATA[ 20 ] [ i ] := 0
   _HMG_SYSDATA[ 21 ] [ i ] := 0
   _HMG_SYSDATA[ 22 ] [ i ] := 0
   _HMG_SYSDATA[ 23 ] [ i ] := 0
   _HMG_SYSDATA[ 24 ] [ i ] := 0
   _HMG_SYSDATA[ 25 ] [ i ] := ''
   _HMG_SYSDATA[ 26 ] [ i ] := 0
   _HMG_SYSDATA[ 27 ] [ i ] := ''
   _HMG_SYSDATA[ 28 ] [ i ] := 0
   _HMG_SYSDATA[ 30 ] [ i ] := ''
   _HMG_SYSDATA[ 31 ] [ i ] := 0
   _HMG_SYSDATA[ 32 ] [ i ] := 0
   _HMG_SYSDATA[ 33 ] [ i ] := ''
   _HMG_SYSDATA[ 34 ] [ i ] := .f.
   _HMG_SYSDATA[ 35 ] [ i ] := 0
   _HMG_SYSDATA[ 36 ] [ i ] := 0
   _HMG_SYSDATA[ 29 ] [ i ] := {}
   _HMG_SYSDATA[ 37 ] [ i ] := 0
   _HMG_SYSDATA[ 38 ] [ i ] := .F.
   _HMG_SYSDATA[ 39 ] [ i ] := 0
   _HMG_SYSDATA[ 40 ] [ i ] := NIL

   _HMG_StopControlEventProcedure[ i ] := .F.
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _IsControlVisibleFromHandle()
*+
*+    Called from ( h_tab.prg )   2 - function updatetab()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _IsControlVisibleFromHandle( Handle )

LOCAL x
LOCAL lVisible := .f.

   FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 3 ] )

      IF VALTYPE( _HMG_SYSDATA[ 3 ] [ x ] ) == 'N'

         IF _HMG_SYSDATA[ 3 ] [ x ] == Handle
            lVisible := _HMG_SYSDATA[ 34 ] [ x ]
            EXIT
         ENDIF

      ELSEIF VALTYPE( _HMG_SYSDATA[ 3 ] [ x ] ) == 'A'

         IF _HMG_SYSDATA[ 3 ] [ x ] [ 1 ] == Handle
            lVisible := _HMG_SYSDATA[ 34 ] [ x ]
            EXIT
         ENDIF

      ENDIF

   NEXT x
RETURN lVisible

*+--------------------------------------------------------------------
*+
*+    Function _IsControlVisible()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _IsControlVisible( ControlName, FormName )

LOCAL lVisible, ix

   lVisible := .f.

   ix := GetControlIndex( ControlName, FormName )

   IF ix > 0
      lVisible := _HMG_SYSDATA[ 34 ] [ ix ]
   ENDIF
RETURN lVisible

*+--------------------------------------------------------------------
*+
*+    Function _SetCaretPos()
*+
*+    Called from ( h_controlmisc.prg )   1 - function setproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetCaretPos( ControlName, FormName, Pos )

LOCAL i
   i := GetControlIndex( ControlName, FormName )
   IF i == 0 .OR. VALTYPE( Pos ) <> "N"
      RETURN Nil
   ENDIF
   IF Pos == - 1
      Pos := GetProperty( FormName, ControlName, "GetTextLength" )    // ADD August 2015
   ENDIF
   SendMessage( _HMG_SYSDATA[ 3 ] [ i ], EM_SETSEL, Pos, Pos )
   SendMessage( _HMG_SYSDATA[ 3 ] [ i ], EM_SCROLLCARET, 0, 0 )       // ADD August 2015
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _GetCaretPos()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetCaretPos( ControlName, FormName )

LOCAL i, nStart, nEnd
   i := GetControlIndex( ControlName, FormName )
   IF i == 0
      RETURN 0
   ENDIF
   // Dr. Claudio Soto (July 2013)
   HMG_SendMessage( _HMG_SYSDATA[ 3 ] [ i ], EM_GETSEL, @nStart, @nEnd )                                                                    // This functions supports huge text
RETURN nEnd

*+--------------------------------------------------------------------
*+
*+    Function _GetId()
*+
*+    Called from ( h_hotkey.prg )   1 - procedure _definehotkey()
*+                ( h_menu.prg )   2 - function _definemenuitem()
*+                ( h_status.prg )   1 - function _endstatusbar()
*+                ( h_timer.prg )   1 - function _definetimer()
*+                ( h_toolbar.prg )   1 - function _definetoolbar()
*+                                   1 - function _definetoolbutton()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetId()

LOCAL RetVal, i

   DO WHILE .t.

      RetVal := random( 65000 )

      i := ASCAN( _HMG_SYSDATA[ 5 ], retval )

      IF i == 0 .AND. retval != 0
         EXIT
      ENDIF

   ENDDO
RETURN RetVal

*+--------------------------------------------------------------------
*+
*+    Function Random()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _getid()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Random( nLimit )

   __THREAD STATIC snRandom := Nil
LOCAL nDecimals, cLimit

   DEFAULT snRandom TO SECONDS() / EXP( 1 )
   DEFAULT nLimit TO 65535

   snRandom := LOG( snRandom + SQRT( 2 ) ) * EXP( 3 )
   snRandom := VAL( STR( snRandom - INT( snRandom ), 17, 15 ) )
   cLimit := TRANSFORM( nLimit, "@N" )

   nDecimals := HB_UAT( ".", cLimit )

   IF nDecimals > 0
      nDecimals := HMG_LEN( cLimit ) - nDecimals
   ENDIF
RETURN ROUND( nLimit * snRandom, nDecimals )

*+--------------------------------------------------------------------
*+
*+    Function _dummy()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _dummy()

RETURN nil

// *******************************************************************************

// by Pablo César (April 2014)

*+--------------------------------------------------------------------
*+
*+    Function cFileDrive()
*+
*+--------------------------------------------------------------------
*+
FUNCTION cFileDrive( cFileMask )

LOCAL cDrive
   // hb_FNameSplit( cFileMask, @cDir, @cName, @cExt, @cDrive )
   hb_FNameSplit( cFileMask, NIL, NIL, NIL, @cDrive )
RETURN cDrive

*+--------------------------------------------------------------------
*+
*+    Function cFilePath()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getstartupfolder()
*+
*+--------------------------------------------------------------------
*+
FUNCTION cFilePath( cFileMask )

LOCAL cDir
   // hb_FNameSplit( cFileMask, @cDir, @cName, @cExt, @cDrive )
   hb_FNameSplit( cFileMask, @cDir, NIL, NIL, NIL )
RETURN HB_ULEFT( cDir, HMG_LEN( cDir ) - 1 )

*+--------------------------------------------------------------------
*+
*+    Function cFileNoExt()
*+
*+    Called from ( h_hmg_hpdf.prg )   1 - function _hmg_hpdf_setfont()
*+                                   1 - function _hmg_hpdf_existinlocal()
*+                                   2 - function _hmg_hpdf_seekinlocaloptions()
*+
*+--------------------------------------------------------------------
*+
FUNCTION cFileNoExt( cFileMask )

LOCAL cName
   // hb_FNameSplit( cFileMask, @cDir, @cName, @cExt, @cDrive )
   hb_FNameSplit( cFileMask, NIL, @cName, NIL, NIL )
RETURN cName

*+--------------------------------------------------------------------
*+
*+    Function cFileNoPath()
*+
*+--------------------------------------------------------------------
*+
FUNCTION cFileNoPath( cFileMask )

LOCAL cName, cExt
   // hb_FNameSplit( cFileMask, @cDir, @cName, @cExt, @cDrive )
   hb_FNameSplit( cFileMask, NIL, @cName, @cExt, NIL )
RETURN ( cName + cExt )

*+--------------------------------------------------------------------
*+
*+    Function cFileExt()
*+
*+    Called from ( h_hmg_hpdf.prg )   1 - function _hmg_hpdf_print()
*+                                   1 - function _hmg_hpdf_multiline_print()
*+                                   1 - function _hmg_hpdf_setpagelink()
*+                                   1 - function _hmg_hpdf_seturllink()
*+                                   1 - function _hmg_hpdf_setfont()
*+
*+--------------------------------------------------------------------
*+
FUNCTION cFileExt( cFileMask )

LOCAL cExt
   // hb_FNameSplit( cFileMask, @cDir, @cName, @cExt, @cDrive )
   hb_FNameSplit( cFileMask, NIL, NIL, @cExt, NIL )
RETURN ( cExt )

/*
Function cFileNoPath( cPathMask )
Local n := HB_UTF8RAT( "\", cPathMask )

Return If( n > 0 .and. n < HMG_LEN( cPathMask ), ;
        HB_URIGHT( cPathMask, HMG_LEN( cPathMask ) - n ), ;
        If( ( n := HB_UAT( ":", cPathMask ) ) > 0, ;
        HB_URIGHT( cPathMask, HMG_LEN( cPathMask ) - n ), cPathMask ) )

Function cFileNoExt( cPathMask )
Local cName := ALLTRIM( cFileNoPath( cPathMask ) )
Local n     := HB_UAT( ".", cName )

Return ALLTRIM( If( n > 0, HB_ULEFT( cName, n - 1 ), cName ) )
*/

// *******************************************************************************

*+--------------------------------------------------------------------
*+
*+    Function _Refresh()
*+
*+    Called from ( h_controlmisc.prg )   1 - function domethod()
*+                ( h_windows.prg )   2 - procedure _refreshdatacontrols()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _Refresh( i )

LOCAL ControlHandle, k
   IF _HMG_SYSDATA[ 1 ] [ i ] == 'COMBO'
      _DataComboRefresh( i )

   ELSEIF _HMG_SYSDATA[ 1 ] [ i ] == 'TEXT' .OR. _HMG_SYSDATA[ 1 ] [ i ] == 'NUMTEXT' .OR. _HMG_SYSDATA[ 1 ] [ i ] == "CHARMASKTEXT" .OR. _HMG_SYSDATA[ 1 ] [ i ] == "MASKEDTEXT"
      _DataTextBoxRefresh( i )

   ELSEIF _HMG_SYSDATA[ 1 ] [ i ] == 'DATEPICK'
      _DataDatePickerRefresh( i )

   ELSEIF _HMG_SYSDATA[ 1 ] [ i ] == 'TIMEPICK'                       // ( Dr. Claudio Soto, April 2013 )
      _DataTimePickerRefresh( i )

   ELSEIF _HMG_SYSDATA[ 1 ] [ i ] == 'EDIT'
      _DataEditBoxRefresh( i )

   ELSEIF _HMG_SYSDATA[ 1 ] [ i ] == 'CHECKBOX'
      _DataCheckBoxRefresh( i )

#ifdef COMPILEBROWSE

   ELSEIF _HMG_SYSDATA[ 1 ] [ i ] == 'BROWSE'
      _BrowseRefresh( '', '', i )

#endif

   ELSEIF _HMG_SYSDATA[ 1 ] [ i ] == 'GRID'

      IF VALTYPE( _HMG_SYSDATA[ 40 ] [ i ] [ 10 ] ) == 'C'            // Grid with cRecordSource ( DataBase )
         DataGridRefresh( i, .T. )                                    // ADD .T. parameter (May 2016)
      ENDIF

   ELSEIF _HMG_SYSDATA[ 1 ] [ i ] == 'MULTIGRID'
      // _HMG_DOGRIDREFRESH(I)

   ENDIF

   // ( Dr. Claudio Soto, May 2013 )
   ControlHandle := _HMG_SYSDATA[ 3 ] [ i ]
   IF VALTYPE( ControlHandle ) == "A"
      FOR k = 1 TO HMG_LEN( ControlHandle )
         RedrawWindow( ControlHandle[ k ] )
      NEXT
   ELSE
      RedrawWindow( ControlHandle )
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _RedrawControl()
*+
*+    Called from ( h_controlmisc.prg )   1 - function domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _RedrawControl( ControlName, ParentForm )                    // ( Dr. Claudio Soto, July 2014 )

LOCAL ControlHandle, k, i
   i := GetControlIndex( ControlName, ParentForm )
   ControlHandle := _HMG_SYSDATA[ 3 ] [ i ]
   IF VALTYPE( ControlHandle ) == "A"
      FOR k = 1 TO HMG_LEN( ControlHandle )
         RedrawWindow( ControlHandle[ k ] )
      NEXT
   ELSE
      RedrawWindow( ControlHandle )
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _SaveData()
*+
*+    Called from ( h_controlmisc.prg )   1 - function domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SaveData( ControlName, ParentForm )

LOCAL I

   i := GetControlIndex( ControlName, ParentForm )
   IF _HMG_SYSDATA[ 1 ] [ i ] == 'TEXT' .OR. _HMG_SYSDATA[ 1 ] [ i ] == 'NUMTEXT' .OR. _HMG_SYSDATA[ 1 ] [ i ] == "CHARMASKTEXT" .OR. _HMG_SYSDATA[ 1 ] [ i ] == "MASKEDTEXT"
      _DataTextBoxSave( ControlName, ParentForm )
   ELSEIF _HMG_SYSDATA[ 1 ] [ i ] == 'DATEPICK'
      _DataDatePickerSave( ControlName, ParentForm )
   ELSEIF _HMG_SYSDATA[ 1 ] [ i ] == 'TIMEPICK'                       // ( Dr. Claudio Soto, April 2013 )
      _DataTimePickerSave( ControlName, ParentForm )
   ELSEIF _HMG_SYSDATA[ 1 ] [ i ] == 'EDIT'
      _DataEditBoxSave( ControlName, ParentForm )
   ELSEIF _HMG_SYSDATA[ 1 ] [ i ] == 'CHECKBOX'
      _DataCheckBoxSave( ControlName, ParentForm )
   ELSEIF _HMG_SYSDATA[ 1 ] [ i ] == 'GRID'
      DataGridSave( i )
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _GetFocusedControl()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetFocusedControl( cFormName )

LOCAL nFormHandle, i, nFocusedControlHandle, nControlCount, cRetVal, x

   nFormHandle := GetFormHandle( cFormName )
   nFocusedControlHandle := GetFocus()
   nControlCount := HMG_LEN( _HMG_SYSDATA[ 3 ] )

   IF nFocusedControlHandle != 0

      FOR i := 1 TO nControlCount

         IF _HMG_SYSDATA[ 4 ] [ i ] == nFormHandle
            IF VALTYPE( _HMG_SYSDATA[ 3 ] [ i ] ) == 'N'
               IF _HMG_SYSDATA[ 3 ] [ i ] == nFocusedControlHandle .OR. ( _HMG_SYSDATA[ 1 ] [ i ] == "COMBO" .AND. _HMG_SYSDATA[ 31 ] [ i ] == nFocusedControlHandle )                                            // ADD
                  cRetVal := _HMG_SYSDATA[ 2 ] [ i ]
               ENDIF
            ELSEIF VALTYPE( _HMG_SYSDATA[ 3 ] [ i ] ) == 'A'
               FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 3 ] [ i ] )
                  IF _HMG_SYSDATA[ 3 ] [ i ] [ x ] == nFocusedControlHandle
                     cRetVal := _HMG_SYSDATA[ 2 ] [ i ]
                     EXIT
                  ENDIF
               NEXT x
            ENDIF
         ENDIF

         IF !EMPTY( cRetVal )
            EXIT
         ENDIF

      NEXT i

   ELSE

      cRetVal := ''

   ENDIF
RETURN cRetVal

*+--------------------------------------------------------------------
*+
*+    Function _SetFontColor()
*+
*+    Called from ( h_controlmisc.prg )   2 - function setproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetFontColor( ControlName, ParentForm, Value )

LOCAL i

   IF value[ 1 ] == Nil .OR. value[ 2 ] == Nil .OR. value[ 3 ] == Nil
      RETURN Nil
   ENDIF

   i := GetControlIndex( ControlName, ParentForm )

   IF _HMG_SYSDATA[ 1 ] [ i ] == 'GRID' .OR. _HMG_SYSDATA[ 1 ] [ i ] == 'MULTIGRID' .OR. _HMG_SYSDATA[ 1 ] [ i ] == 'BROWSE'
      ListView_SetTextColor( _HMG_SYSDATA[ 3 ] [ i ], value[ 1 ], value[ 2 ], value[ 3 ] )
      RedrawWindow( _HMG_SYSDATA[ 3 ] [ i ] )

   ELSEIF _HMG_SYSDATA[ 1 ] [ i ] == 'PROGRESSBAR'
      _HMG_SYSDATA[ 15 ] [ i ] := Value
      SetProgressBarBarColor( _HMG_SYSDATA[ 3 ] [ i ], value[ 1 ], value[ 2 ], value[ 3 ] )

   ELSE
      _HMG_SYSDATA[ 15 ] [ i ] := Value
      RedrawWindow( _HMG_SYSDATA[ 3 ] [ i ] )
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _SetBackColor()
*+
*+    Called from ( h_controlmisc.prg )   1 - function setproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetBackColor( ControlName, ParentForm, Value )

LOCAL i, f

   IF value[ 1 ] == Nil .OR. value[ 2 ] == Nil .OR. value[ 3 ] == Nil
      RETURN Nil
   ENDIF

   i := GetControlIndex( ControlName, ParentForm )

   IF _HMG_SYSDATA[ 1 ] [ i ] == 'SLIDER'

      _HMG_SYSDATA[ 14 ] [ i ] := Value
      RedrawWindow( _HMG_SYSDATA[ 3 ] [ i ] )
      f := GetFocus()
      setfocus( _HMG_SYSDATA[ 3 ] [ i ] )
      setfocus( f )

   ELSEIF _HMG_SYSDATA[ 1 ] [ i ] == 'GRID' .OR. _HMG_SYSDATA[ 1 ] [ i ] == 'MULTIGRID' .OR. _HMG_SYSDATA[ 1 ] [ i ] == 'BROWSE'

      ListView_SetBkColor( _HMG_SYSDATA[ 3 ] [ i ], value[ 1 ], value[ 2 ], value[ 3 ] )
      ListView_SetTextBkColor( _HMG_SYSDATA[ 3 ] [ i ], value[ 1 ], value[ 2 ], value[ 3 ] )
      RedrawWindow( _HMG_SYSDATA[ 3 ] [ i ] )

   ELSEIF _HMG_SYSDATA[ 1 ] [ i ] == 'RICHEDIT'

      SendMessage( _HMG_SYSDATA[ 3 ] [ i ], EM_SETBKGNDCOLOR, 0, RGB( value[ 1 ], value[ 2 ], value[ 3 ] ) )

      RedrawWindow( _HMG_SYSDATA[ 3 ] [ i ] )

   ELSEIF _HMG_SYSDATA[ 1 ] [ i ] == 'PROGRESSBAR'
      _HMG_SYSDATA[ 14 ] [ i ] := Value
      SetProgressBarBkColor( _HMG_SYSDATA[ 3 ] [ i ], value[ 1 ], value[ 2 ], value[ 3 ] )

   ELSE

      _HMG_SYSDATA[ 14 ] [ i ] := Value
      RedrawWindow( _HMG_SYSDATA[ 3 ] [ i ] )

   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _GetFontColor()
*+
*+    Called from ( h_controlmisc.prg )   2 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetFontColor( ControlName, ParentForm )

LOCAL i, RetVal := { Nil, Nil, Nil }, Tmp

   i := GetControlIndex( ControlName, ParentForm )

   IF _HMG_SYSDATA[ 1 ] [ i ] == 'GRID' .OR. _HMG_SYSDATA[ 1 ] [ i ] == 'MULTIGRID' .OR. _HMG_SYSDATA[ 1 ] [ i ] == 'BROWSE'
      Tmp := ListView_GetTextColor( _HMG_SYSDATA[ 3 ] [ i ] )
      RetVal[ 1 ] := GetRed( Tmp )
      RetVal[ 2 ] := GetGreen( Tmp )
      RetVal[ 3 ] := GetBlue( Tmp )
   ELSE
      RetVal := _HMG_SYSDATA[ 15 ] [ i ]
   ENDIF
RETURN RetVal

*+--------------------------------------------------------------------
*+
*+    Function _GetBackColor()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetBackColor( ControlName, ParentForm )

LOCAL i, RetVal := { Nil, Nil, Nil }, Tmp

   i := GetControlIndex( ControlName, ParentForm )

   IF _HMG_SYSDATA[ 1 ] [ i ] == 'GRID' .OR. _HMG_SYSDATA[ 1 ] [ i ] == 'MULTIGRID' .OR. _HMG_SYSDATA[ 1 ] [ i ] == 'BROWSE'
      Tmp := ListView_GetBkColor( _HMG_SYSDATA[ 3 ] [ i ] )
      RetVal[ 1 ] := GetRed( Tmp )
      RetVal[ 2 ] := GetGreen( Tmp )
      RetVal[ 3 ] := GetBlue( Tmp )
   ELSE
      RetVal := _HMG_SYSDATA[ 14 ] [ i ]
   ENDIF
RETURN RetVal

*+--------------------------------------------------------------------
*+
*+    Function _IsControlEnabled()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _IsControlEnabled( ControlName, ParentForm )

LOCAL i, t, RetVal

   i := GetControlIndex( ControlName, ParentForm )
   t := GetControlType( ControlName, ParentForm )

   IF t == 'MENU'
      RetVal := _IsMenuItemEnabled( ControlName, ParentForm )
   ELSE
      RetVal := _HMG_SYSDATA[ 38 ] [ i ]
   ENDIF
RETURN RetVal

*+--------------------------------------------------------------------
*+
*+    Function _SetStatusIcon()
*+
*+    Called from ( h_controlmisc.prg )   2 - function setproperty()
*+                ( h_status.prg )   3 - function _setstatuskeybrd()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetStatusIcon( ControlName, ParentForm, nItem, cIcon, hIcon )

LOCAL i := GetControlIndex( ControlName, ParentForm )
   SetStatusItemIcon( _HMG_SYSDATA[ 3 ] [ i ], nItem - 1, cIcon, hIcon )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _GetCaption()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetCaption( ControlName, ParentForm )

LOCAL i
LOCAL cRetVal := ''

   i := GetControlIndex( ControlName, ParentForm )

   IF _HMG_SYSDATA[ 1 ] [ i ] == 'TOOLBUTTON'
      cRetVal := _HMG_SYSDATA[ 33 ] [ i ]
   ELSE
      cRetVal := GetWindowText( _HMG_SYSDATA[ 3 ] [ i ] )
   ENDIF
RETURN cRetVal

*+--------------------------------------------------------------------
*+
*+    Function _GetControlFree()
*+
*+    Called from ( h_browse.prg )   1 - function _definebrowse()
*+                ( h_grid.prg )   1 - function _definegrid()
*+                ( h_timepicker.prg )   1 - function _definetimepick()
*+                ( h_button.prg )   1 - function _definebutton()
*+                                   1 - function _defineimagebutton()
*+                                   1 - function _definemixedbutton()
*+                ( h_checkbox.prg )   1 - function _definecheckbox()
*+                                   1 - function _definecheckbutton()
*+                                   1 - function _defineimagecheckbutton()
*+                ( h_combo.prg )   1 - function _definecombo()
*+                ( h_controlmisc.prg )   1 - function _defineactivex()
*+                ( h_datepicker.prg )   1 - function _definedatepick()
*+                ( h_editbox.prg )   1 - function _defineeditbox()
*+                ( h_frame.prg )   1 - function _defineframe()
*+                ( h_hotkey.prg )   1 - procedure _definehotkey()
*+                ( h_image.prg )   1 - function _defineimage()
*+                ( h_ipaddress.prg )   1 - function _defineipaddress()
*+                ( h_label.prg )   1 - function _definelabel()
*+                ( h_listbox.prg )   1 - function _definelistbox()
*+                ( h_media.prg )   1 - function _defineplayer()
*+                                   1 - function _defineanimatebox()
*+                ( h_menu.prg )   1 - function _definemenupopup()
*+                                   2 - function _definemenuitem()
*+                ( h_monthcal.prg )   1 - function _definemonthcal()
*+                ( h_progressbar.prg )   1 - function _defineprogressbar()
*+                ( h_radio.prg )   1 - function _defineradiogroup()
*+                ( h_richeditbox.prg )   1 - function _definericheditbox()
*+                ( h_slider.prg )   1 - function _defineslider()
*+                ( h_spinner.prg )   1 - function _definespinner()
*+                ( h_status.prg )   1 - function _endstatusbar()
*+                ( h_tab.prg )   1 - function _definetab()
*+                ( h_textbox.prg )   1 - function _definetextbox()
*+                                   1 - function _definemaskedtextbox()
*+                                   1 - function _definecharmasktextbox()
*+                ( h_timer.prg )   1 - function _definetimer()
*+                ( h_toolbar.prg )   1 - function _definetoolbar()
*+                                   1 - function _definetoolbutton()
*+                ( h_tree.prg )   1 - function _definetree()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetControlFree()

LOCAL k

   k := ASCAN( _HMG_SYSDATA[ 13 ], .T. )

   IF k == 0

      k := HMG_LEN( _HMG_SYSDATA[ 2 ] ) + 1

      AADD( _HMG_SYSDATA[ 1 ], Nil )
      AADD( _HMG_SYSDATA[ 2 ], Nil )
      AADD( _HMG_SYSDATA[ 3 ], Nil )
      AADD( _HMG_SYSDATA[ 4 ], Nil )
      AADD( _HMG_SYSDATA[ 5 ], Nil )
      AADD( _HMG_SYSDATA[ 6 ], Nil )
      AADD( _HMG_SYSDATA[ 7 ], Nil )
      AADD( _HMG_SYSDATA[ 8 ], Nil )
      AADD( _HMG_SYSDATA[ 9 ], Nil )
      AADD( _HMG_SYSDATA[ 10 ], Nil )
      AADD( _HMG_SYSDATA[ 11 ], Nil )
      AADD( _HMG_SYSDATA[ 12 ], Nil )
      AADD( _HMG_SYSDATA[ 13 ], Nil )
      AADD( _HMG_SYSDATA[ 14 ], Nil )
      AADD( _HMG_SYSDATA[ 15 ], Nil )
      AADD( _HMG_SYSDATA[ 16 ], Nil )
      AADD( _HMG_SYSDATA[ 17 ], Nil )
      AADD( _HMG_SYSDATA[ 18 ], Nil )
      AADD( _HMG_SYSDATA[ 19 ], Nil )
      AADD( _HMG_SYSDATA[ 20 ], Nil )
      AADD( _HMG_SYSDATA[ 21 ], Nil )
      AADD( _HMG_SYSDATA[ 22 ], Nil )
      AADD( _HMG_SYSDATA[ 23 ], Nil )
      AADD( _HMG_SYSDATA[ 24 ], Nil )
      AADD( _HMG_SYSDATA[ 25 ], Nil )
      AADD( _HMG_SYSDATA[ 26 ], Nil )
      AADD( _HMG_SYSDATA[ 27 ], Nil )
      AADD( _HMG_SYSDATA[ 28 ], Nil )
      AADD( _HMG_SYSDATA[ 29 ], Nil )
      AADD( _HMG_SYSDATA[ 30 ], Nil )
      AADD( _HMG_SYSDATA[ 31 ], Nil )
      AADD( _HMG_SYSDATA[ 32 ], Nil )
      AADD( _HMG_SYSDATA[ 33 ], Nil )
      AADD( _HMG_SYSDATA[ 34 ], Nil )
      AADD( _HMG_SYSDATA[ 35 ], Nil )
      AADD( _HMG_SYSDATA[ 36 ], Nil )
      AADD( _HMG_SYSDATA[ 37 ], Nil )
      AADD( _HMG_SYSDATA[ 38 ], Nil )
      AADD( _HMG_SYSDATA[ 39 ], Nil )
      AADD( _HMG_SYSDATA[ 40 ], Nil )

      AADD( _HMG_SYSDATA[ 41 ], { Nil, Nil, Nil } )                   // array --> { OnKeyControlEventProc, OnMouseControlEventProc, ToolTip_CustomDrawData }

      AADD( _HMG_StopControlEventProcedure, .F. )                     // ADD
   ENDIF
RETURN k

*+--------------------------------------------------------------------
*+
*+    Function httpconnect()
*+
*+--------------------------------------------------------------------
*+
FUNCTION httpconnect( Connection, Server, Port )

   Connection := NIL                                                  // ADD
   Server := NIL                                                      // ADD
   Port := NIL                                                        // ADD
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _SetAddress()
*+
*+    Called from ( h_controlmisc.prg )   1 - function setproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetAddress( ControlName, ParentForm, url )

LOCAL i

   i := GetControlIndex( ControlName, ParentForm )

   IF i > 0

      IF HB_UAT( "@", url ) > 0

         _HMG_SYSDATA[ 6 ] [ i ] := { || ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler mailto:" + url,, 1 ) }
         _HMG_SYSDATA[ 8 ] [ i ] := url

      ELSEIF HB_UAT( "http", url ) > 0

         _HMG_SYSDATA[ 6 ] [ i ] := { || ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + url,, 1 ) }
         _HMG_SYSDATA[ 8 ] [ i ] := url

      ELSE

         MsgHMGError( "Control: " + ControlName + " must have valid email or url defined. Program Terminated" )

      ENDIF

   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _GetAddress()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetAddress( ControlName, ParentForm )

LOCAL i, RetVal := ''

   i := GetControlIndex( ControlName, ParentForm )

   IF i > 0

      RetVal := _HMG_SYSDATA[ 8 ] [ i ]

   ENDIF
RETURN RetVal

/*
Function GetStartUpFolder()
Local StartUpFolder := GetProgramFileName()
Return HB_ULEFT ( StartUpFolder , HB_UTF8RAT ( '\' , StartUpFolder ) - 1 )
*/

*+--------------------------------------------------------------------
*+
*+    Function GetStartUpFolder()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetStartUpFolder()                                           // by Pablo Cesar, march 2017 ( remove last unnecessary backslash )

   RETURN cFilePath( hb_ProgName() )

   ///////////////////////////////////////////////////////////////////////////////
   // HARBOUR LEVEL PRINT ROUTINES
   ///////////////////////////////////////////////////////////////////////////////

#define SB_HORZ     0        // ok
#define SB_VERT     1        // ok
#define WM_VSCROLL  0x0115    // ok
   // #define WM_CLOSE     16   // ok (MinGW)
   // #define WM_VSCROLL   277  // ok (MinGW)

#if 1

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_SHOWPREVIEW()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_SHOWPREVIEW()

   __THREAD STATIC nIndexEvent := 0                                   // ADD, April 2014
LOCAL ModalHandle := 0
LOCAL Tmp
LOCAL i
LOCAL tWidth
LOCAL tHeight
LOCAL tFactor
LOCAL tvHeight
LOCAL icb         := 0
LOCAL ppnavtitle
LOCAL cLang       := HB_USubStr( HMG_UPPER( SET( _SET_LANGUAGE ) ), 1, 2 )

PUBLIC _Y1 := 0, _X1 := 0, _Y2 := 0, _X2 := 0                         // ADD April 2014

   IF !( cLang == "EN" )
      _HMG_PRINTER_InitUserMessages( cLang )
   ENDIF

   _HMG_SYSDATA[ 360 ] := GetTempFolder() + _HMG_SYSDATA[ 379 ] + "_hmg_print_preview_"
   _HMG_SYSDATA[ 361 ] := 1
   _HMG_SYSDATA[ 362 ] := NIL
   _HMG_SYSDATA[ 363 ] := 0
   _HMG_SYSDATA[ 364 ] := 0
   _HMG_SYSDATA[ 365 ] := 0
   _HMG_SYSDATA[ 366 ] := 10
   _HMG_SYSDATA[ 367 ] := 0
   _HMG_SYSDATA[ 368 ] := .T.
   _HMG_SYSDATA[ 369 ] := NIL
   _HMG_SYSDATA[ 370 ] := 0

   IF _HMG_SYSDATA[ 271 ] == .T.

      ModalHandle := _HMG_SYSDATA[ 167 ]

      _HMG_SYSDATA[ 271 ] := .F.
      _HMG_SYSDATA[ 167 ] := 0

      DisableWindow( ModalHandle )

   ELSE

      ModalHandle := 0

   ENDIF

   IF _HMG_SYSDATA[ 372 ] == 0
      RETURN Nil
   ENDIF

   IF _IsWindowDefined( "_HMG_PRINTER_SHOWPREVIEW" )
      RETURN Nil
   ENDIF

   icb := _HMG_SYSDATA[ 339 ]

   SET INTERACTIVECLOSE ON

   _HMG_SYSDATA[ 362 ] := GetDesktopHeight() / _HMG_PRINTER_GETPAGEHEIGHT( _HMG_SYSDATA[ 372 ] ) * 0.63

   IF _HMG_PRINTER_GETPAGEHEIGHT( _HMG_SYSDATA[ 372 ] ) > 370
      _HMG_SYSDATA[ 359 ] := - 250
   ELSE
      _HMG_SYSDATA[ 359 ] := 0
   ENDIF

   DEFINE WINDOW _HMG_PRINTER_WAIT AT 0, 0 width 310 height 85 title '' child noshow nocaption
   DEFINE LABEL label_1
      ROW 30
      COL 5
      WIDTH 300
      HEIGHT 30
      VALUE _HMG_SYSDATA[ 371 ] [ 29 ]
      CENTERALIGN .T.
   END LABEL
   END WINDOW
   CENTER WINDOW _HMG_PRINTER_WAIT

   ppnavtitle := _HMG_SYSDATA[ 371 ] [ 01 ] + ' [' + ALLTRIM( STR( _HMG_SYSDATA[ 361 ] ) ) + '/' + ALLTRIM( STR( _HMG_SYSDATA[ 380 ] ) ) + ']'

   DEFINE WINDOW _HMG_PRINTER_SHOWPREVIEW ;
      AT 0, 0 ;
      WIDTH GetDesktopWidth() - 103 - IF( ISVISTA() .AND. IsAppThemed(), 25, 0 ) ;
      HEIGHT GetDesktopHeight() - 066 - IF( ISVISTA() .AND. IsAppThemed(), 25, 0 ) ;
      CHILD NOSIZE NOMINIMIZE NOMAXIMIZE NOSYSMENU ;
      TITLE ppnavtitle ;
      BACKCOLOR GRAY ;
      ON INIT _HMG_PRINTER_PREVIEWRefresh()

   _HMG_PRINTER_SET_K_EVENTS( "_HMG_PRINTER_SHOWPREVIEW" )

   DEFINE SPLITBOX                                                    // by Pablo César, April 2014
      DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 40, 32 IMAGESIZE 24, 24 FLAT CAPTION _HMG_SYSDATA[ 371 ] [ 02 ]
         BUTTON b2 PICTURE "HP_BACK" TOOLTIP _HMG_SYSDATA[ 371 ] [ 04 ] ACTION( _HMG_SYSDATA[ 361 ] --, _HMG_PRINTER_PREVIEWRefresh() )
         BUTTON b3 PICTURE "HP_NEXT" TOOLTIP _HMG_SYSDATA[ 371 ] [ 05 ] ACTION( _HMG_SYSDATA[ 361 ] ++, _HMG_PRINTER_PREVIEWRefresh() ) SEPARATOR
         BUTTON b1 PICTURE "HP_TOP" TOOLTIP _HMG_SYSDATA[ 371 ] [ 03 ] ACTION( _HMG_SYSDATA[ 361 ] := 1, _HMG_PRINTER_PREVIEWRefresh() )
         BUTTON b4 PICTURE "HP_END" TOOLTIP _HMG_SYSDATA[ 371 ] [ 06 ] ACTION( _HMG_SYSDATA[ 361 ] := _HMG_SYSDATA[ 380 ], _HMG_PRINTER_PREVIEWRefresh() ) SEPARATOR
         BUTTON bGoToPage PICTURE "HP_GOPAGE" TOOLTIP _HMG_SYSDATA[ 371 ] [ 07 ] + ' [Ctrl+G]' ACTION( ( EnableWindow( GetformHandle( "_HMG_PRINTER_SHOWPREVIEW" ) ), EnableWindow( GetformHandle( "SPLITCHILD_1" ) ), EnableWindow( GetformHandle( "_HMG_PRINTER_SHOWTHUMBNAILS" ) ), HideWindow( GetFormHandle( "_HMG_PRINTER_GO_TO_PAGE" ) ), DoMethod( "SPLITCHILD_1", "SetFocus" ) ), _HMG_PRINTER_GO_TO_PAGE() ) SEPARATOR
         BUTTON thumbswitch PICTURE "HP_THUMBNAIL" TOOLTIP _HMG_SYSDATA[ 371 ] [ 28 ] + ' [Ctrl+T]' ACTION( _HMG_PRINTER_ProcessTHUMBNAILS(), _HMG_PRINTER_PREVIEWRefresh() ) CHECK SEPARATOR
         BUTTON b5 PICTURE "HP_ZOOM" TOOLTIP _HMG_SYSDATA[ 371 ] [ 08 ] + ' [*]' ACTION( _HMG_PRINTER_Zoom() ) CHECK SEPARATOR
         BUTTON b12 PICTURE "HP_PRINT" TOOLTIP _HMG_SYSDATA[ 371 ] [ 09 ] + ' [Ctrl+P]' ACTION _HMG_PRINTER_PrintPages()
         BUTTON b7 PICTURE "HP_SAVE" TOOLTIP _HMG_SYSDATA[ 371 ] [ 27 ] + ' [Ctrl+S]' ACTION( _HMG_PRINTER_SavePages(), _HMG_PRINTER_PREVIEWRefresh() ) SEPARATOR
         BUTTON b6 PICTURE "HP_CLOSE" TOOLTIP _HMG_SYSDATA[ 371 ] [ 26 ] + ' [Ctrl+C]' ACTION _HMG_PRINTER_PreviewClose()
      END TOOLBAR

      IF _HMG_SYSDATA[ 505 ] == .T.                                   // PrintPreview NoSavaButton --> .T. or .F.
         _HMG_PRINTER_SHOWPREVIEW.ToolBar_1.b7.Enabled := .F.
      ENDIF

      DEFINE WINDOW SPLITCHILD_1 ;
         WIDTH GetDesktopWidth() - 103 - IF( ISVISTA() .AND. IsAppThemed(), 25, 0 ) ;
         HEIGHT GetDesktopHeight() - 140 - IF( ISVISTA() .AND. IsAppThemed(), 25, 0 ) ;
         VIRTUAL WIDTH( GetDesktopWidth() - 103 ) * 2 ;
         VIRTUAL HEIGHT( GetDesktopHeight() - 140 ) * 2 ;
         SPLITCHILD NOCAPTION ;                                       // CURSOR          "HP_GLASS" ;
         ON SCROLLUP _HMG_PRINTER_ScrollUp() ;
         ON SCROLLDOWN _HMG_PRINTER_ScrollDown() ;
         ON SCROLLLEFT _HMG_PRINTER_ScrollLeft() ;
         ON SCROLLRIGHT _HMG_PRINTER_ScrollRight() ;
         ON HSCROLLBOX _HMG_PRINTER_hScrollBoxProcess() ;
         ON VSCROLLBOX _HMG_PRINTER_vScrollBoxProcess() ;
         ON PAINT _HMG_PRINTER_PREVIEW_OnPaint()

      _HMG_PRINTER_SET_K_EVENTS( "SPLITCHILD_1" )
      END WINDOW

      CREATE EVENT PROCNAME _HMG_PRINTER_SpltChldMouseClick() STOREINDEX nIndexEvent

   END SPLITBOX
   END WINDOW

   DEFINE WINDOW _HMG_PRINTER_PRINTPAGES ;
      AT 0, 0 WIDTH 420 HEIGHT 168 + GetTitleHeight() ;
      TITLE _HMG_SYSDATA[ 371 ] [ 9 ] CHILD NOSHOW ;
      NOSIZE NOSYSMENU

   ON KEY ESCAPE ACTION( EnableWindow( GetformHandle( "_HMG_PRINTER_SHOWPREVIEW" ) ), EnableWindow( GetformHandle( "SPLITCHILD_1" ) ), EnableWindow( GetformHandle( "_HMG_PRINTER_SHOWTHUMBNAILS" ) ), HideWindow( GetFormHandle( "_HMG_PRINTER_PRINTPAGES" ) ), DoMethod( "SPLITCHILD_1", "SetFocus" ) )
   ON KEY RETURN ACTION _HMG_PRINTER_PrintPagesDo()

   Define Frame Frame_1
      Row 5
      Col 10
      Width 275
      Height 147
      FontName 'Arial'
      FontSize 9
      Caption _HMG_SYSDATA[ 371 ] [ 15 ]
   END Frame

   Define RadioGroup Radio_1
      Row 25
      Col 20
      FontName 'Arial'
      FontSize 9
      Value 1
      Options { _HMG_SYSDATA[ 371 ] [ 16 ], _HMG_SYSDATA[ 371 ] [ 17 ] }
      OnChange IF( This.value == 1, ( _HMG_PRINTER_PRINTPAGES.Label_1.Enabled := .F., _HMG_PRINTER_PRINTPAGES.Label_2.Enabled := .F., _HMG_PRINTER_PRINTPAGES.Spinner_1.Enabled := .F., _HMG_PRINTER_PRINTPAGES.Spinner_2.Enabled := .F., _HMG_PRINTER_PRINTPAGES.Combo_1.Enabled := .F., _HMG_PRINTER_PRINTPAGES.Label_4.Enabled := .F. ), ( _HMG_PRINTER_PRINTPAGES.Label_1.Enabled := .T., _HMG_PRINTER_PRINTPAGES.Label_2.Enabled := .T., _HMG_PRINTER_PRINTPAGES.Spinner_1.Enabled := .T., _HMG_PRINTER_PRINTPAGES.Spinner_2.Enabled := .T., _HMG_PRINTER_PRINTPAGES.Combo_1.Enabled := .T., _HMG_PRINTER_PRINTPAGES.Label_4.Enabled := .T., _HMG_PRINTER_PRINTPAGES.Spinner_1.SetFocus ) )
   END RadioGroup

   Define Label Label_1
      Row 84
      Col 55
      Width 50
      Height 25
      FontName 'Arial'
      FontSize 9
      Value _HMG_SYSDATA[ 371 ] [ 18 ] + ':'
   END Label

   Define Spinner Spinner_1
      Row 81
      Col 110
      Width 50
      FontName 'Arial'
      FontSize 9
      Value 1
      RangeMin 1
      RangeMax _HMG_SYSDATA[ 380 ]
   END Spinner

   Define Label Label_2
      Row 84
      Col 165
      Width 35
      Height 25
      FontName 'Arial'
      FontSize 9
      Value _HMG_SYSDATA[ 371 ] [ 19 ] + ':'
   END Label

   Define Spinner Spinner_2
      Row 81
      Col 205
      Width 50
      FontName 'Arial'
      FontSize 9
      Value _HMG_SYSDATA[ 380 ]
      RangeMin 1
      RangeMax _HMG_SYSDATA[ 380 ]
   END Spinner

   Define Label Label_4
      Row 115
      Col 55
      Width 50
      Height 25
      FontName 'Arial'
      FontSize 9
      Value _HMG_SYSDATA[ 371 ] [ 09 ] + ':'
   END Label

   Define ComboBox Combo_1
      Row 113
      Col 110
      Width 145
      FontName 'Arial'
      FontSize 9
      Value 1
      Items { _HMG_SYSDATA[ 371 ] [ 21 ], _HMG_SYSDATA[ 371 ] [ 22 ], _HMG_SYSDATA[ 371 ] [ 23 ] }
   END ComboBox

   Define Button Ok
      Row 10
      Col 300
      Width 105
      Height 25
      FontName 'Arial'
      FontSize 9
      Caption _HMG_SYSDATA[ 371 ] [ 11 ]
      Action _HMG_PRINTER_PrintPagesDo()
   END Button

   Define Button CANCEL
      Row 40
      Col 300
      Width 105
      Height 25
      FontName 'Arial'
      FontSize 9
      Caption _HMG_SYSDATA[ 371 ] [ 12 ]
      Action( EnableWindow( GetformHandle( "_HMG_PRINTER_SHOWPREVIEW" ) ), EnableWindow( GetformHandle( "SPLITCHILD_1" ) ), EnableWindow( GetformHandle( "_HMG_PRINTER_SHOWTHUMBNAILS" ) ), HideWindow( GetFormHandle( "_HMG_PRINTER_PRINTPAGES" ) ), DoMethod( "SPLITCHILD_1", "SetFocus" ) )
   END Button

   Define Label Label_3
      Row 103
      Col 300
      Width 45
      Height 25
      FontName 'Arial'
      FontSize 9
      Value _HMG_SYSDATA[ 371 ] [ 20 ] + ':'
   END Label

   Define Spinner Spinner_3
      Row 100
      Col 355
      Width 50
      FontName 'Arial'
      FontSize 9
      Value _HMG_SYSDATA[ 376 ]
      RangeMin 1
      RangeMax 999
      OnChange( IF( IsControlDefined( CheckBox_1, _HMG_PRINTER_PRINTPAGES ), IF( This.Value > 1, SetProperty( '_HMG_PRINTER_PRINTPAGES', 'CheckBox_1', 'Enabled', .T. ), SetProperty( '_HMG_PRINTER_PRINTPAGES', 'CheckBox_1', 'Enabled', .F. ) ), Nil ) )
   END Spinner

   Define CheckBox CheckBox_1
      Row 132
      Col 300
      Width 110
      FontName 'Arial'
      FontSize 9
      Value IF( _HMG_SYSDATA[ 377 ] == 1, .T., .F. )
      Caption _HMG_SYSDATA[ 371 ] [ 14 ]
   END CheckBox

   END WINDOW
   CENTER WINDOW _HMG_PRINTER_PRINTPAGES

   DEFINE WINDOW _HMG_PRINTER_GO_TO_PAGE ;
      AT 0, 0 ;
      WIDTH 195 ;
      HEIGHT 90 + GetTitleHeight() ;
      TITLE _HMG_SYSDATA[ 371 ] [ 07 ] ;
      CHILD NOSHOW NOSIZE NOSYSMENU

   ON KEY ESCAPE ACTION( EnableWindow( GetformHandle( "_HMG_PRINTER_SHOWPREVIEW" ) ), EnableWindow( GetformHandle( "SPLITCHILD_1" ) ), EnableWindow( GetformHandle( "_HMG_PRINTER_SHOWTHUMBNAILS" ) ), HideWindow( GetFormHandle( "_HMG_PRINTER_GO_TO_PAGE" ) ), DoMethod( "SPLITCHILD_1", "SetFocus" ) )

   ON KEY RETURN ACTION( _HMG_SYSDATA[ 361 ] := _HMG_PRINTER_GO_TO_PAGE.Spinner_1.Value, ;
                         EnableWindow( GetformHandle( "_HMG_PRINTER_SHOWPREVIEW" ) ), ;
                         EnableWindow( GetformHandle( "SPLITCHILD_1" ) ), ;
                         EnableWindow( GetformHandle( "_HMG_PRINTER_SHOWTHUMBNAILS" ) ), ;
                         HideWindow( GetFormHandle( "_HMG_PRINTER_GO_TO_PAGE" ) ), ;
                         _HMG_PRINTER_PREVIEWRefresh(), ;             // ADD April 2014
                         DoMethod( "SPLITCHILD_1", "SetFocus" ) )

   Define Label Label_1
      Row 13
      Col 10
      Width 94
      Height 25
      FontName 'Arial'
      FontSize 9
      Value _HMG_SYSDATA[ 371 ] [ 10 ] + ':'
   END Label

   Define Spinner Spinner_1
      Row 10
      Col 105
      Width 75
      FontName 'Arial'
      FontSize 9
      Value _HMG_SYSDATA[ 361 ]
      RangeMin 1
      RangeMax _HMG_SYSDATA[ 380 ]
   END Spinner

   Define Button Ok
      Row 48
      Col 10
      Width 80
      Height 25
      FontName 'Arial'
      FontSize 9
      Caption _HMG_SYSDATA[ 371 ] [ 11 ]
      Action( _HMG_SYSDATA[ 361 ] := _HMG_PRINTER_GO_TO_PAGE.Spinner_1.Value, ;
              HideWindow( GetFormHandle( "_HMG_PRINTER_GO_TO_PAGE" ) ), ;
              EnableWindow( GetformHandle( "_HMG_PRINTER_SHOWPREVIEW" ) ), ;
              EnableWindow( GetformHandle( "SPLITCHILD_1" ) ), ;
              EnableWindow( GetformHandle( "_HMG_PRINTER_SHOWTHUMBNAILS" ) ), ;
              _HMG_PRINTER_PREVIEWRefresh(), ;                        // ADD April 2014
              DoMethod( "_HMG_PRINTER_SHOWPREVIEW", "SetFocus" ) )
   END Button

   Define Button CANCEL
      Row 48
      Col 100
      Width 80
      Height 25
      FontName 'Arial'
      FontSize 9
      Caption _HMG_SYSDATA[ 371 ] [ 12 ]
      Action( EnableWindow( GetformHandle( "_HMG_PRINTER_SHOWPREVIEW" ) ), EnableWindow( GetformHandle( "SPLITCHILD_1" ) ), EnableWindow( GetformHandle( "_HMG_PRINTER_SHOWTHUMBNAILS" ) ), HideWindow( GetFormHandle( "_HMG_PRINTER_GO_TO_PAGE" ) ), DoMethod( "SPLITCHILD_1", "SetFocus" ) )
   END Button
   END WINDOW
   CENTER WINDOW _HMG_PRINTER_GO_TO_PAGE

   IF _HMG_PRINTER_GETPAGEHEIGHT( _HMG_SYSDATA[ 372 ] ) > _HMG_PRINTER_GETPAGEWIDTH( _HMG_SYSDATA[ 372 ] )
      tFactor := 0.44
   ELSE
      tFactor := 0.26
   ENDIF

   tWidth := _HMG_PRINTER_GETPAGEWIDTH( _HMG_SYSDATA[ 372 ] ) * tFactor
   tHeight := _HMG_PRINTER_GETPAGEHEIGHT( _HMG_SYSDATA[ 372 ] ) * tFactor

   tHeight := INT( tHeight )

   tvHeight := ( _HMG_SYSDATA[ 380 ] * ( tHeight + 10 ) ) + GetHScrollbarHeight() + GetTitleHeight() + ( GetBorderHeight() * 2 ) + 7

   IF tvHeight <= GetDesktopHeight() - 066
      _HMG_SYSDATA[ 369 ] := .f.
      tvHeight := GetDesktopHeight() - 065
   ELSE
      _HMG_SYSDATA[ 369 ] := .t.
   ENDIF

   DEFINE WINDOW _HMG_PRINTER_SHOWTHUMBNAILS ;
      AT 0, 5 ;
      WIDTH 130 ;
      HEIGHT GetDesktopHeight() - 066 - IF( ISVISTA() .AND. IsAppThemed(), 25, 0 ) ;
      VIRTUAL WIDTH 131 ;
      VIRTUAL HEIGHT tvHeight ;
      TITLE _HMG_SYSDATA[ 371 ] [ 28 ] ;
      CHILD ;
      NOSIZE ;
      NOMINIMIZE ;
      NOMAXIMIZE ;
      NOSYSMENU ;
      NOSHOW ;
      BACKCOLOR GRAY

   _HMG_PRINTER_SET_K_EVENTS( "_HMG_PRINTER_SHOWTHUMBNAILS" )

   END WINDOW

   IF _HMG_SYSDATA[ 369 ] == .f.
      _HMG_PRINTER_PREVIEW_DISABLESCROLLBARS( GetFormHandle( '_HMG_PRINTER_SHOWTHUMBNAILS' ) )
   ENDIF

   SetScrollRange( GetFormHandle( 'SPLITCHILD_1' ), SB_VERT, 0, 100, .T. )
   SetScrollRange( GetFormHandle( 'SPLITCHILD_1' ), SB_HORZ, 0, 100, .T. )

   SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_VERT, 50, .T. )
   SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_HORZ, 50, .T. )

   _HMG_PRINTER_PREVIEW_DISABLESCROLLBARS( GetFormHandle( 'SPLITCHILD_1' ) )
   _HMG_PRINTER_PREVIEW_DISABLEHSCROLLBAR( GetFormHandle( '_HMG_PRINTER_SHOWTHUMBNAILS' ) )

   CENTER WINDOW _HMG_PRINTER_SHOWPREVIEW

   Tmp := _HMG_PRINTER_SHOWPREVIEW.ROW
   _HMG_PRINTER_SHOWTHUMBNAILS.ROW := Tmp

   ACTIVATE WINDOW _HMG_PRINTER_PRINTPAGES, _HMG_PRINTER_GO_TO_PAGE, _HMG_PRINTER_SHOWTHUMBNAILS, _HMG_PRINTER_SHOWPREVIEW, _HMG_PRINTER_WAIT

   IF nIndexEvent > 0
      EventRemove( nIndexEvent )                                      // ADD, April 2014
   ENDIF

   _HMG_SYSDATA[ 374 ] := _HMG_SYSDATA[ 372 ]

   IF ModalHandle != 0

      FOR i := 1 TO HMG_LEN( _HMG_SYSDATA[ 67 ] )
         IF _HMG_SYSDATA[ 65 ] [ i ] == .F.
            IF _HMG_SYSDATA[ 69 ] [ i ] != 'X'
               IF _HMG_SYSDATA[ 67 ] [ i ] != ModalHandle
                  DisableWindow( _HMG_SYSDATA[ 67 ] [ i ] )
               ENDIF
            ENDIF
         ENDIF
      NEXT i

      EnableWindow( ModalHandle )

      // by Dr. Claudio Soto (April 2014)
      FOR i := 1 TO HMG_LEN( _HMG_SYSDATA[ 67 ] )
         IF _HMG_SYSDATA[ 65 ] [ i ] == .F.
            IF _HMG_SYSDATA[ 69 ] [ i ] == 'P' .AND. _HMG_SYSDATA[ 70 ] [ i ] == ModalHandle                                                // Panel window into Modal window
               EnableWindow( _HMG_SYSDATA[ 67 ] [ i ] )               // Enable Panel window
            ENDIF
         ENDIF
      NEXT

      SetFocus( ModalHandle )

      _HMG_SYSDATA[ 271 ] := .T.
      _HMG_SYSDATA[ 167 ] := ModalHandle
   ENDIF

   _HMG_SYSDATA[ 339 ] := icb

RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_SpltChldMouseCursor()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_spltchldmouseclick()
*+                                   1 - function _hmg_printer_mousezoom()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_SpltChldMouseCursor()                           // by Dr. Claudio Soto, April 2014

   __THREAD STATIC Flag := .F.
LOCAL hWnd, x, y, IsPoint

   hWnd := GetformHandle( "SPLITCHILD_1" )
   // GetCursorPos (@x, @y)
   // ScreenToClient (hWnd, @x, @y)
   HMG_GetCursorPos( hWnd, @y, @x )

   // IsPoint := ( x >= _X1 .AND. y >= _Y1 .AND. x <= _X2 .AND. y <= _Y2 )
   IsPoint := PtInRect( x, y, _X1, _Y1, _X2, _Y2 )

   IF IsPoint == .T. .AND. Flag == .F.
      Flag := .T.
      SetWindowCursor( hWnd, "HP_GLASS" )
   ELSEIF IsPoint == .F. .AND. Flag == .T.
      Flag := .F.
      SetWindowCursor( hWnd, IDC_ARROW )
   ENDIF

RETURN Flag

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_SpltChldMouseClick()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_SpltChldMouseClick()                            // by Pablo César and Dr. Claudio Soto, April 2014

LOCAL Flag := _HMG_PRINTER_SpltChldMouseCursor()

#define WM_SETCURSOR 32
   IF EventMSG() == WM_SETCURSOR
      IF EventWPARAM() == GetControlHandle( "TOOLBAR_1", "_HMG_PRINTER_SHOWPREVIEW" )
         DoMethod( "_HMG_PRINTER_SHOWPREVIEW", "SetFocus" )           // SetFocus for display ToolTip of the ToolBar define into SPLITBOX
      ENDIF
   ENDIF

   IF EventMSG() == WM_LBUTTONDOWN .AND. Flag == .T. .AND. EventIsHMGWindowsMessage() == .T.
      IF EventHWND() == GetformHandle( "SPLITCHILD_1" )               // Click in show page to print
         _HMG_PRINTER_SHOWPREVIEW.b5.Value := .NOT. ( _HMG_PRINTER_SHOWPREVIEW.b5.Value )
         _HMG_PRINTER_MouseZoom()
      ENDIF
   ENDIF

RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_SET_K_EVENTS()
*+
*+    Called from ( h_controlmisc.prg )   3 - function _hmg_printer_showpreview()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_SET_K_EVENTS( parent )

   _DefineHotKey( parent, 0, VK_HOME, { || ( _HMG_SYSDATA[ 361 ] := 1, _HMG_PRINTER_PREVIEWRefresh() ) } )
   _DefineHotKey( parent, 0, VK_PRIOR, { || ( _HMG_SYSDATA[ 361 ] --, _HMG_PRINTER_PREVIEWRefresh() ) } )
   _DefineHotKey( parent, 0, VK_NEXT, { || ( _HMG_SYSDATA[ 361 ] ++, _HMG_PRINTER_PREVIEWRefresh() ) } )
   _DefineHotKey( parent, 0, VK_END, { || ( _HMG_SYSDATA[ 361 ] := _HMG_SYSDATA[ 380 ], _HMG_PRINTER_PREVIEWRefresh() ) } )
   _DefineHotKey( parent, MOD_CONTROL, VK_P, { || _HMG_PRINTER_PrintPages() } )
   _DefineHotKey( parent, MOD_CONTROL, VK_G, { || _HMG_PRINTER_GO_TO_PAGE() } )
   _DefineHotKey( parent, 0, VK_ESCAPE, { || _HMG_PRINTER_PreviewClose() } )
   _DefineHotKey( parent, 0, VK_MULTIPLY, { || ( _HMG_PRINTER_SHOWPREVIEW.b5.Value := .NOT. ( _HMG_PRINTER_SHOWPREVIEW.b5.Value ), _HMG_PRINTER_MouseZoom( .T. ) ) } )
   _DefineHotKey( parent, MOD_CONTROL, VK_C, { || _HMG_PRINTER_PreviewClose() } )
   _DefineHotKey( parent, MOD_ALT, VK_F4, { || _HMG_PRINTER_PreviewClose() } )

   IF _HMG_SYSDATA[ 505 ] <> .T.                                      // PrintPreview NoSavaButton --> .T. or .F.
      _DefineHotKey( parent, MOD_CONTROL, VK_S, { || ( _hmg_printer_savepages(), _HMG_PRINTER_PREVIEWRefresh() ) } )
   ENDIF

   _DefineHotKey( parent, MOD_CONTROL, VK_T, { || _hmg_printer_ThumbnailToggle() } )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function CreateThumbNails()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_processthumbnails()
*+
*+--------------------------------------------------------------------
*+
FUNCTION CreateThumbNails()

LOCAL tFactor
LOCAL tWidth
LOCAL tHeight
LOCAL ttHandle
LOCAL i
LOCAL cMacroTemp
LOCAL cAction
LOCAL cFileName, hBitmap

   IF _IsControlDefined( 'Image1', '_HMG_PRINTER_SHOWTHUMBNAILS' )
      RETURN Nil
   ENDIF

   ShowWindow( GetFormHandle( "_HMG_PRINTER_WAIT" ) )

   IF _HMG_PRINTER_GETPAGEHEIGHT( _HMG_SYSDATA[ 372 ] ) > _HMG_PRINTER_GETPAGEWIDTH( _HMG_SYSDATA[ 372 ] )
      tFactor := 0.44
   ELSE
      tFactor := 0.26
   ENDIF

   tWidth := _HMG_PRINTER_GETPAGEWIDTH( _HMG_SYSDATA[ 372 ] ) * tFactor
   tHeight := _HMG_PRINTER_GETPAGEHEIGHT( _HMG_SYSDATA[ 372 ] ) * tFactor

   tHeight := INT( tHeight )

   ttHandle := GetFormToolTipHandle( '_HMG_PRINTER_SHOWTHUMBNAILS' )

   FOR i := 1 TO _HMG_SYSDATA[ 380 ]

      cMacroTemp := 'Image' + ALLTRIM( STR( i ) )

      cAction := "( _HMG_SYSDATA [ 361 ]:=" + ALLTRIM( STR( i ) ) + ", _HMG_SYSDATA [ 368 ] := .F. , _HMG_PRINTER_PREVIEWRefresh() , _HMG_SYSDATA [ 368 ] := .T. )"

      cFileName := _HMG_SYSDATA[ 360 ] + STRZERO( i, 4 ) + ".EMF"

      _DefineImage( cMacroTemp, ;
                    '_HMG_PRINTER_SHOWTHUMBNAILS', ;
                    10, ;
                    ( i * ( tHeight + 10 ) ) - tHeight, ;
                    "" /*cFileName*/, ;
                    tWidth, ;
                    tHeight, ;
                    { || &cAction }, ;
                    Nil, ;
                    .F., ;
                    .F., ;
                    .T. )

      //  by Dr. Claudio Soto, April 2014
      hBitmap := BT_BitmapLoadEMF( cFileName, WHITE, tWidth, tHeight )
      BT_HMGSetImage( '_HMG_PRINTER_SHOWTHUMBNAILS', cMacroTemp, hBitmap )

      SetToolTip( GetControlHandle( cMacroTemp, '_HMG_PRINTER_SHOWTHUMBNAILS' ), _HMG_SYSDATA[ 371 ] [ 01 ] + ' ' + ALLTRIM( STR( i ) ) + ' [Click]', ttHandle )

   NEXT i
   HideWindow( GetFormHandle( "_HMG_PRINTER_WAIT" ) )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _hmg_printer_ThumbnailToggle()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_set_k_events()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _hmg_printer_ThumbnailToggle()

   IF _HMG_PRINTER_SHOWPREVIEW.thumbswitch.Value == .t.

      _HMG_PRINTER_SHOWPREVIEW.thumbswitch.Value := .f.

   ELSE

      _HMG_PRINTER_SHOWPREVIEW.thumbswitch.Value := .t.

   ENDIF
   _HMG_PRINTER_ProcessTHUMBNAILS()
RETURN .F.

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_ProcessTHUMBNAILS()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_showpreview()
*+                                   1 - function _hmg_printer_thumbnailtoggle()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_ProcessTHUMBNAILS()

   IF _HMG_PRINTER_SHOWPREVIEW.thumbswitch.Value == .T.

      CreateThumbNails()

      _HMG_SYSDATA[ 367 ] := 90

      _HMG_SYSDATA[ 362 ] := GetDesktopHeight() / _HMG_PRINTER_GETPAGEHEIGHT( _HMG_SYSDATA[ 372 ] ) * 0.58

      SetProperty( "_HMG_PRINTER_SHOWPREVIEW", "Width", GetDesktopWidth() - 148 - IF( ISVISTA() .AND. IsAppThemed(), 30, 0 ) )
      SetProperty( "_HMG_PRINTER_SHOWPREVIEW", "Col", 138 + IF( ISVISTA() .AND. IsAppThemed(), 20, 0 ) )
      ShowWindow( GetFormHandle( "_HMG_PRINTER_SHOWTHUMBNAILS" ) )

   ELSE

      _HMG_SYSDATA[ 367 ] := 0

      _HMG_SYSDATA[ 362 ] := GetDesktopHeight() / _HMG_PRINTER_GETPAGEHEIGHT( _HMG_SYSDATA[ 372 ] ) * 0.63

      SetProperty( "_HMG_PRINTER_SHOWPREVIEW", "Width", GetDesktopWidth() - 103 )
      SetProperty( "_HMG_PRINTER_SHOWPREVIEW", "Col", 51 )
      HideWindow( GetFormHandle( "_HMG_PRINTER_SHOWTHUMBNAILS" ) )
      DoMethod( "_HMG_PRINTER_SHOWPREVIEW", "SetFocus" )

   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_SavePages()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_showpreview()
*+                                   1 - function _hmg_printer_set_k_events()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_SavePages( lSaveAs )

LOCAL i, nFiles, cFileEMF, cTempFolder, cPrintFileName, aFiles := {}

LOCAL g            := { ".PDF", ".BMP", ".JPG", ".GIF", ".TIF", ".PNG", ".EMF" }
LOCAL nTypePicture := { Nil, BT_FILEFORMAT_BMP, BT_FILEFORMAT_JPG, BT_FILEFORMAT_GIF, BT_FILEFORMAT_TIF, BT_FILEFORMAT_PNG, Nil }
LOCAL acFilter     := { { "PDF", "*.pdf" }, { "BMP", "*.bmp" }, { "JPG", "*.jpg" }, { "GIF", "*.gif" }, { "TIF", "*.tif" }, { "PNG", "*.png" }, { "EMF", "*.emf" } }
LOCAL cFullName    := "", cPath := "", cName := "", cExt := "", cExtFile := ""
LOCAL cFileName    := "HMG_PrintFile"
LOCAL cFolder

LOCAL hBitmap, nType
LOCAL flag_PDF := .F.
LOCAL nWidth, nHeight, nDPI

   IF VALTYPE( _HMG_SYSDATA[ 506 ] ) == "C"
      hb_FNameSplit( _HMG_SYSDATA[ 506 ], @cFolder, @cFileName, @cExt, NIL )                                                                // Dialog cFileName
   ENDIF

   // by Dr. Claudio Soto, September 2014

   IF VALTYPE( lSaveAs ) == "L" .AND. lSaveAs == .T.
      IF VALTYPE( _HMG_SYSDATA[ 507 ] ) == "C"
         cFullName := _HMG_SYSDATA[ 507 ]                             // SaveAs: cFileName + cExt
      ELSE
         MsgStop( "SaveAs: Invalid File Name", "ERROR" )
         RETURN NIL
      ENDIF
   ELSE
      cExt := HMG_UPPER( ALLTRIM( cExt ) )
      i := ASCAN( g, cExt )
      cFullName := PutFile( acFilter, NIL, cFolder, .F., cFileName, @cExtFile, i )
   ENDIF

   HB_FNameSplit( cFullName, @cPath, @cName, @cExt, NIL )
   IF EMPTY( cName )
      RETURN Nil
   ENDIF
   cExt := HMG_UPPER( ALLTRIM( cExt ) )

   i := ASCAN( g, cExt )
   IF i == 0
      MsgStop( "Invalid File Extension: " + cExt, "ERROR" )
      RETURN Nil
   ENDIF

   nType := nTypePicture[ i ]

   IF HMG_UPPER( cExt ) == ".PDF"
      flag_PDF := .T.
   ENDIF

   cTempFolder := GetTempFolder()

   nFiles := ADIR( cTempFolder + _HMG_SYSDATA[ 379 ] + "_hmg_print_preview_*.Emf" )

   ASIZE( aFiles, nFiles )

   ADIR( cTempFolder + _HMG_SYSDATA[ 379 ] + "_hmg_print_preview_*.Emf", aFiles )

   FOR i := 1 TO nFiles
      cFileEMF := cTempFolder + aFiles[ i ]
      cPrintFileName := cPath + cName + "_" + STRZERO( i, 4 )

      IF HMG_UPPER( cExt ) == ".EMF"
         COPY FILE (cFileEMF) TO (cPrintFileName + cExt)
      ELSE

         // by Dr. Claudio Soto, April 2014
         hBitmap = BT_BitmapLoadEMF( cFileEMF, WHITE )

         IF hBitmap <> 0 .AND. flag_PDF == .F.
            BT_BitmapSaveFile( hBitmap, cPrintFileName + cExt, nType )
            BT_BitmapRelease( hBitmap )
         ENDIF

         IF hBitmap <> 0 .AND. flag_PDF == .T.                        // by Rathinagiri (May 2014)
            IF i == 1
               nDPI := 300
               nWidth := ( BT_BitmapWidth( hBitmap ) / nDPI * 25.4 )
               nHeight := ( BT_BitmapHeight( hBitmap ) / nDPI * 25.4 )
               _HMG_HPDF_INIT( cPath + cName + ".PDF", 1, 256, nHeight, nWidth, .f. )
               _hmg_hpdf_startdoc()
               _HMG_HPDF_SetCompression( 'ALL' )
            ENDIF

            _hmg_hpdf_startpage()
            BT_BitmapSaveFile( hBitmap, cPrintFileName + ".JPG", BT_FILEFORMAT_JPG )
            BT_BitmapRelease( hBitmap )
            _HMG_HPDF_IMAGE( cPrintFileName + ".JPG", 0, 0, nHeight, nWidth, .t., "JPG" )
            _hmg_hpdf_endpage()
            FERASE( cPrintFileName + ".JPG" )

            IF i == nFiles
               _hmg_hpdf_enddoc()
            ENDIF

         ENDIF

      ENDIF
   NEXT i
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function HMG_IsValidFileName()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_IsValidFileName( cFileName )                             // cFileName --> ONLY FILE NAME without Path

LOCAL cName, ch, i
   cName := ALLTRIM( cFileName )
   IF EMPTY( cName )
      RETURN .F.
   ENDIF
   FOR i := 1 TO HMG_LEN( cName )
      ch := HB_USUBSTR( cName, i, 1 )
      // Not valid characters --> ASCII 0 to 31 and < > : " / \ |
      IF ( HB_UCODE( ch ) >= 0 .AND. HB_UCODE( ch ) <= 31 ) .OR. ch $ '<>:"/\|'
         RETURN .F.
      ENDIF
   NEXT
RETURN .T.

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_GO_TO_PAGE()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_showpreview()
*+                                   1 - function _hmg_printer_set_k_events()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_GO_TO_PAGE()

   DisableWindow( GetformHandle( "_HMG_PRINTER_SHOWTHUMBNAILS" ) )
   DisableWindow( GetformHandle( "_HMG_PRINTER_SHOWPREVIEW" ) )
   DisableWindow( GetformHandle( "SPLITCHILD_1" ) )
   ShowWindow( GetFormHandle( "_HMG_PRINTER_GO_TO_PAGE" ) )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_hScrollBoxProcess()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_showpreview()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_hScrollBoxProcess()

LOCAL Sp
   Sp := GetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_HORZ )
   _HMG_SYSDATA[ 363 ] := - ( Sp - 50 ) * 10
   _HMG_PRINTER_PREVIEWRefresh()
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_vScrollBoxProcess()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_showpreview()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_vScrollBoxProcess()

LOCAL Sp
   Sp := GetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_VERT )
   _HMG_SYSDATA[ 364 ] := - ( Sp - 50 ) * 10
   _HMG_PRINTER_PREVIEWRefresh()
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_PreviewClose()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_showpreview()
*+                                   3 - function _hmg_printer_set_k_events()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_PreviewClose()

   _HMG_PRINTER_CleanPreview()
   _HMG_PRINTER_WAIT.Release
   _HMG_PRINTER_SHOWTHUMBNAILS.Release
   _HMG_PRINTER_SHOWPREVIEW.Release
   _HMG_PRINTER_GO_TO_PAGE.Release
   _HMG_PRINTER_PRINTPAGES.Release
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_CleanPreview()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_previewclose()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_CleanPreview()

LOCAL c, i, f, t
LOCAL a := {}

   t := gettempfolder()
   c := ADIR( t + _HMG_SYSDATA[ 379 ] + "_hmg_print_preview_*.Emf" )
   ASIZE( a, c )
   ADIR( t + _HMG_SYSDATA[ 379 ] + "_hmg_print_preview_*.Emf", a )
   FOR i := 1 TO c
      f := t + a[ i ]
      DELETE FILE (f)
   NEXT i
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Procedure _HMG_PRINTER_PREVIEWRefresh()
*+
*+    Called from ( h_controlmisc.prg )   9 - function _hmg_printer_showpreview()
*+                                   5 - function _hmg_printer_set_k_events()
*+                                   1 - function _hmg_printer_hscrollboxprocess()
*+                                   1 - function _hmg_printer_vscrollboxprocess()
*+                                   1 - function _hmg_printer_scrollleft()
*+                                   1 - function _hmg_printer_scrollright()
*+                                   1 - function _hmg_printer_scrollup()
*+                                   1 - function _hmg_printer_scrolldown()
*+                                   1 - function _hmg_printer_mousezoom()
*+                                   2 - function _hmg_printer_zoom()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE _HMG_PRINTER_PREVIEWRefresh()                               // July 2015

   BT_ClientAreaInvalidateAll( "SPLITCHILD_1" )
RETURN

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_PREVIEW_OnPaint()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_showpreview()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_PREVIEW_OnPaint()                               // July 2015

LOCAL hwnd
LOCAL nRow
LOCAL nScrollMax
LOCAL aCoord     := { 0, 0, 0, 0 }
LOCAL hDC, BTstruct                                                   // July 2015

   IF _IsControlDefined( 'Image' + ALLTRIM( STR( _HMG_SYSDATA[ 361 ] ) ), '_HMG_PRINTER_SHOWTHUMBNAILS' ) .AND. _HMG_SYSDATA[ 368 ] == .T. .AND. _HMG_SYSDATA[ 369 ] == .T.

      IF _HMG_SYSDATA[ 370 ] != _HMG_SYSDATA[ 361 ]

         _HMG_SYSDATA[ 370 ] := _HMG_SYSDATA[ 361 ]
         hwnd := GetFormHandle( '_HMG_PRINTER_SHOWTHUMBNAILS' )
         nRow := GetProperty( '_HMG_PRINTER_SHOWTHUMBNAILS', 'Image' + ALLTRIM( STR( _HMG_SYSDATA[ 361 ] ) ), 'Row' )
         nScrollMax := GetScrollRangeMax( hwnd, SB_VERT )

         IF _HMG_SYSDATA[ 380 ] == _HMG_SYSDATA[ 361 ]

            IF GetScrollPos( hwnd, SB_VERT ) != nScrollMax
               _HMG_PRINTER_SETVSCROLLVALUE( hwnd, nScrollMax )
            ENDIF

         ELSEIF _HMG_SYSDATA[ 361 ] == 1

            IF GetScrollPos( hwnd, SB_VERT ) != 0
               _HMG_PRINTER_SETVSCROLLVALUE( hwnd, 0 )
            ENDIF

         ELSE

            IF ( nRow - 9 ) < nScrollMax
               _HMG_PRINTER_SETVSCROLLVALUE( hwnd, nRow - 9 )
            ELSE
               IF GetScrollPos( hwnd, SB_VERT ) != nScrollMax
                  _HMG_PRINTER_SETVSCROLLVALUE( hwnd, nScrollMax )
               ENDIF
            ENDIF

         ENDIF

      ENDIF

   ENDIF

   IF _HMG_SYSDATA[ 361 ] < 1
      _HMG_SYSDATA[ 361 ] := 1
      PlayBeep()
      RETURN Nil
   ENDIF

   IF _HMG_SYSDATA[ 361 ] > _HMG_SYSDATA[ 380 ]
      _HMG_SYSDATA[ 361 ] := _HMG_SYSDATA[ 380 ]
      PlayBeep()
      RETURN Nil
   ENDIF

   hDC := BT_CreateDC( "SPLITCHILD_1", BT_HDC_INVALIDCLIENTAREA, @BTstruct )                                                                // July 2015

   aCoord := _HMG_PRINTER_SHOWPAGE( _HMG_SYSDATA[ 360 ] + STRZERO( _HMG_SYSDATA[ 361 ], 4 ) + ".emf", ;
                                    GetFormhandle( 'SPLITCHILD_1' ), ;
                                    _HMG_SYSDATA[ 372 ], ;
                                    _HMG_SYSDATA[ 362 ] * 10000, ;
                                    _HMG_SYSDATA[ 365 ], ;
                                    _HMG_SYSDATA[ 363 ], ;
                                    _HMG_SYSDATA[ 364 ], ;
                                    hDC )                             // July 2015
   BT_DeleteDC( BTstruct )                                            // July 2015

   // ADD April 2014
   _Y1 := aCoord[ 1 ]
   _X1 := aCoord[ 2 ]
   _Y2 := aCoord[ 3 ]
   _X2 := aCoord[ 4 ]

   _HMG_PRINTER_SHOWPREVIEW.TITLE := _HMG_SYSDATA[ 371 ] [ 01 ] + ' [' + ALLTRIM( STR( _HMG_SYSDATA[ 361 ] ) ) + '/' + ALLTRIM( STR( _HMG_SYSDATA[ 380 ] ) ) + ']'

RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_PrintPages()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_showpreview()
*+                                   1 - function _hmg_printer_set_k_events()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_PrintPages()

LOCAL aProp := {}

   DisableWindow( GetformHandle( "_HMG_PRINTER_SHOWPREVIEW" ) )
   DisableWindow( GetformHandle( "SPLITCHILD_1" ) )
   DisableWindow( GetformHandle( "_HMG_PRINTER_SHOWTHUMBNAILS" ) )

   _HMG_PRINTER_PRINTPAGES.Radio_1.Value := 1

   _HMG_PRINTER_PRINTPAGES.Label_1.Enabled := .F.
   _HMG_PRINTER_PRINTPAGES.Label_2.Enabled := .F.
   _HMG_PRINTER_PRINTPAGES.Label_4.Enabled := .F.
   _HMG_PRINTER_PRINTPAGES.Spinner_1.Enabled := .F.
   _HMG_PRINTER_PRINTPAGES.Spinner_2.Enabled := .F.
   _HMG_PRINTER_PRINTPAGES.Combo_1.Enabled := .F.
   _HMG_PRINTER_PRINTPAGES.CheckBox_1.Enabled := .F.

   IF _HMG_SYSDATA[ 286 ] ;
              .OR. ;
              _HMG_SYSDATA[ 287 ]

      _HMG_PRINTER_PRINTPAGES.Spinner_3.Enabled := .F.

   ENDIF
   ShowWindow( GetFormHandle( "_HMG_PRINTER_PRINTPAGES" ) )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_PrintPagesDo()
*+
*+    Called from ( h_controlmisc.prg )   2 - function _hmg_printer_showpreview()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_PrintPagesDo()

LOCAL PageFrom
LOCAL PageTo
LOCAL p, i
LOCAL OddOnly  := .F.
LOCAL EvenOnly := .F.

   IF _HMG_PRINTER_PrintPages.Radio_1.Value == 1

      PageFrom := 1
      PageTo := _HMG_SYSDATA[ 380 ]

   ELSEIF _HMG_PRINTER_PrintPages.Radio_1.Value == 2

      PageFrom := _HMG_PRINTER_PrintPages.Spinner_1.Value
      PageTo := _HMG_PRINTER_PrintPages.Spinner_2.Value

      IF _HMG_PRINTER_PrintPages.Combo_1.Value == 2
         OddOnly := .T.
      ELSEIF _HMG_PRINTER_PrintPages.Combo_1.Value == 3
         EvenOnly := .T.
      ENDIF

   ENDIF

   // by Dr. Claudio Soto, August 2015

   // _HMG_SYSDATA [ 516 ] -->  cVarName_aJobData of START PRINTDOC STOREJOBDATA
   OpenPrinterGetJobID() := _HMG_PRINTER_StartDoc( _HMG_SYSDATA[ 372 ], _HMG_SYSDATA[ 358 ] )
   IF .NOT. EMPTY( _HMG_SYSDATA[ 516 ] )
      IF __mvExist( _HMG_SYSDATA[ 516 ] )
         __mvPut( _HMG_SYSDATA[ 516 ], OpenPrinterGetJobData() )
      ELSE
         MsgHMGError( "START PRINTDOC STOREJOBDATA: " + _HMG_SYSDATA[ 516 ] + " VarMem must be declared Public or Private. Program Terminated" )
      ENDIF
   ENDIF

   IF _HMG_PRINTER_PrintPages.Spinner_3.Value == 1                    // Copies

      FOR i := PageFrom TO PageTo

         IF OddOnly == .T.
            IF i / 2 != INT( i / 2 )
               _HMG_PRINTER_PRINTPAGE( _HMG_SYSDATA[ 372 ], _HMG_SYSDATA[ 360 ] + STRZERO( i, 4 ) + ".emf" )
            ENDIF
         ELSEIF EvenOnly == .T.
            IF i / 2 == INT( i / 2 )
               _HMG_PRINTER_PRINTPAGE( _HMG_SYSDATA[ 372 ], _HMG_SYSDATA[ 360 ] + STRZERO( i, 4 ) + ".emf" )
            ENDIF
         ELSE
            _HMG_PRINTER_PRINTPAGE( _HMG_SYSDATA[ 372 ], _HMG_SYSDATA[ 360 ] + STRZERO( i, 4 ) + ".emf" )
         ENDIF

      NEXT i

   ELSE

      IF _HMG_PRINTER_PrintPages.CheckBox_1.Value == .F.

         FOR p := 1 TO _HMG_PRINTER_PrintPages.Spinner_3.Value

            FOR i := PageFrom TO PageTo

               IF OddOnly == .T.
                  IF i / 2 != INT( i / 2 )
                     _HMG_PRINTER_PRINTPAGE( _HMG_SYSDATA[ 372 ], _HMG_SYSDATA[ 360 ] + STRZERO( i, 4 ) + ".emf" )
                  ENDIF
               ELSEIF EvenOnly == .T.
                  IF i / 2 == INT( i / 2 )
                     _HMG_PRINTER_PRINTPAGE( _HMG_SYSDATA[ 372 ], _HMG_SYSDATA[ 360 ] + STRZERO( i, 4 ) + ".emf" )
                  ENDIF
               ELSE
                  _HMG_PRINTER_PRINTPAGE( _HMG_SYSDATA[ 372 ], _HMG_SYSDATA[ 360 ] + STRZERO( i, 4 ) + ".emf" )
               ENDIF

            NEXT i

         NEXT p

      ELSE

         FOR i := PageFrom TO PageTo

            FOR p := 1 TO _HMG_PRINTER_PrintPages.Spinner_3.Value

               IF OddOnly == .T.
                  IF i / 2 != INT( i / 2 )
                     _HMG_PRINTER_PRINTPAGE( _HMG_SYSDATA[ 372 ], _HMG_SYSDATA[ 360 ] + STRZERO( i, 4 ) + ".emf" )
                  ENDIF
               ELSEIF EvenOnly == .T.
                  IF i / 2 == INT( i / 2 )
                     _HMG_PRINTER_PRINTPAGE( _HMG_SYSDATA[ 372 ], _HMG_SYSDATA[ 360 ] + STRZERO( i, 4 ) + ".emf" )
                  ENDIF
               ELSE
                  _HMG_PRINTER_PRINTPAGE( _HMG_SYSDATA[ 372 ], _HMG_SYSDATA[ 360 ] + STRZERO( i, 4 ) + ".emf" )
               ENDIF

            NEXT p

         NEXT i

      ENDIF

   ENDIF

   _HMG_PRINTER_ENDDOC( _HMG_SYSDATA[ 372 ] )

   EnableWindow( GetformHandle( "_HMG_PRINTER_SHOWPREVIEW" ) )
   EnableWindow( GetformHandle( "SPLITCHILD_1" ) )
   EnableWindow( GetformHandle( "_HMG_PRINTER_SHOWTHUMBNAILS" ) )
   HideWindow( GetFormHandle( "_HMG_PRINTER_PRINTPAGES" ) )
   DoMethod( "SPLITCHILD_1", "SetFocus" )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_ScrollLeft()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_showpreview()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_ScrollLeft()

   _HMG_SYSDATA[ 363 ] := _HMG_SYSDATA[ 363 ] + _HMG_SYSDATA[ 366 ]
   IF _HMG_SYSDATA[ 363 ] >= 500
      _HMG_SYSDATA[ 363 ] := 500
      PlayBeep()
   ENDIF
   _HMG_PRINTER_PREVIEWRefresh()
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_ScrollRight()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_showpreview()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_ScrollRight()

   _HMG_SYSDATA[ 363 ] := _HMG_SYSDATA[ 363 ] - _HMG_SYSDATA[ 366 ]
   IF _HMG_SYSDATA[ 363 ] <= - 500
      _HMG_SYSDATA[ 363 ] := - 500
      PlayBeep()
   ENDIF
   _HMG_PRINTER_PREVIEWRefresh()
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_ScrollUp()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_showpreview()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_ScrollUp()

   _HMG_SYSDATA[ 364 ] := _HMG_SYSDATA[ 364 ] + _HMG_SYSDATA[ 366 ]
   IF _HMG_SYSDATA[ 364 ] >= 500
      _HMG_SYSDATA[ 364 ] := 500
      PlayBeep()
   ENDIF
   _HMG_PRINTER_PREVIEWRefresh()
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_ScrollDown()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_showpreview()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_ScrollDown()

   _HMG_SYSDATA[ 364 ] := _HMG_SYSDATA[ 364 ] - _HMG_SYSDATA[ 366 ]
   IF _HMG_SYSDATA[ 364 ] <= - 500
      _HMG_SYSDATA[ 364 ] := - 500
      PlayBeep()
   ENDIF
   _HMG_PRINTER_PREVIEWRefresh()
   RETURN Nil

#endif

*+--------------------------------------------------------------------
*+
*+    Function GetPrinter()
*+
*+    Called from ( h_rptgen.prg )   1 - procedure executereport()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetPrinter()

LOCAL RetVal          := ''
LOCAL Printers        := ASORT( aPrinters() )
LOCAL cDefaultPrinter := GetDefaultPrinter()
LOCAL nInitPosition   := 0
LOCAL i

   FOR i := 1 TO HMG_LEN( Printers )

      IF Printers[ i ] == cDefaultPrinter
         nInitPosition := i
         EXIT
      ENDIF

   NEXT i

   DEFINE WINDOW _HMG_PRINTER_GETPRINTER ;
      AT 0, 0 ;
      WIDTH 345 ;
      HEIGHT GetTitleHeight() + 100 ;
      TITLE _HMG_SYSDATA[ 371 ] [ 13 ] ;
      MODAL ;
      NOSIZE

   @ 15, 10 COMBOBOX Combo_1 ITEMS Printers VALUE nInitPosition WIDTH 320

   @ 53, 65 BUTTON Ok CAPTION _HMG_SYSDATA[ 371 ] [ 11 ] ACTION( RetVal := Printers[ GetProperty( '_HMG_PRINTER_GETPRINTER', 'Combo_1', 'Value' ) ], DoMethod( '_HMG_PRINTER_GETPRINTER', 'Release' ) )

   @ 53, 175 BUTTON CANCEL CAPTION _HMG_SYSDATA[ 371 ] [ 12 ] ACTION( RetVal := '', DoMethod( '_HMG_PRINTER_GETPRINTER', 'Release' ) )

   END WINDOW
   CENTER WINDOW _HMG_PRINTER_GETPRINTER
   ACTIVATE WINDOW _HMG_PRINTER_GETPRINTER
   RETURN RetVal

#define TA_CENTER   6   // ok
#define TA_LEFT     0   // ok
#define TA_RIGHT    2   // ok

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_H_PRINT()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_H_PRINT( nHdc, nRow, nCol, cFontName, nFontSize, nColor1, nColor2, nColor3, cText, lbold, litalic, lunderline, lstrikeout, lcolor, lfont, lsize, cAlign, nAngle )

LOCAL lAlignChanged := .F.

   IF VALTYPE( cText ) == "N"
      cText := ALLTRIM( STR( cText ) )
   ELSEIF VALTYPE( cText ) == "D"
      cText := DTOC( cText )
   ELSEIF VALTYPE( cText ) == "L"
      cText := IF( cText == .T., _HMG_SYSDATA[ 371 ] [ 24 ], _HMG_SYSDATA[ 371 ] [ 25 ] )
   ELSEIF VALTYPE( cText ) == "A"
      RETURN Nil
   ELSEIF VALTYPE( cText ) == "B"
      RETURN Nil
   ELSEIF VALTYPE( cText ) == "O"
      RETURN Nil
   ELSEIF VALTYPE( cText ) == "U"
      RETURN Nil
   ENDIF

   nRow := INT( nRow * 10000 / 254 )
   nCol := INT( nCol * 10000 / 254 )

   IF VALTYPE( cAlign ) = 'C'
      IF HMG_UPPER( ALLTRIM( cAlign ) ) == 'CENTER'
         SetTextAlign( nHdc, TA_CENTER )
         lAlignChanged := .T.
      ELSEIF HMG_UPPER( ALLTRIM( cAlign ) ) == 'RIGHT'
         SetTextAlign( nHdc, TA_RIGHT )
         lAlignChanged := .T.
      ENDIF
   ENDIF

   _HMG_PRINTER_C_PRINT( nHdc, nRow, nCol, cFontName, nFontSize, nColor1, nColor2, nColor3, cText, lbold, litalic, lunderline, lstrikeout, lcolor, lfont, lsize, nAngle )

   IF lAlignChanged
      SetTextAlign( nHdc, TA_LEFT )
   ENDIF
RETURN nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_H_MULTILINE_PRINT()
*+
*+    Called from ( h_rptgen.prg )   1 - procedure _printtext()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_H_MULTILINE_PRINT( nHdc, nRow, nCol, nToRow, nToCol, cFontName, nFontSize, nColor1, nColor2, nColor3, cText, lbold, litalic, lunderline, lstrikeout, lcolor, lfont, lsize, cAlign )

LOCAL nAlign := TA_LEFT

   //  cText := hb_oemtoansi(cText)
   IF VALTYPE( cText ) == "N"
      cText := ALLTRIM( STR( cText ) )
   ELSEIF VALTYPE( cText ) == "D"
      cText := DTOC( cText )
   ELSEIF VALTYPE( cText ) == "L"
      cText := IF( cText == .T., _HMG_SYSDATA[ 371 ] [ 24 ], _HMG_SYSDATA[ 371 ] [ 25 ] )
   ELSEIF VALTYPE( cText ) == "A"
      RETURN Nil
   ELSEIF VALTYPE( cText ) == "B"
      RETURN Nil
   ELSEIF VALTYPE( cText ) == "O"
      RETURN Nil
   ELSEIF VALTYPE( cText ) == "U"
      RETURN Nil
   ENDIF

   nRow := INT( nRow * 10000 / 254 )
   nCol := INT( nCol * 10000 / 254 )
   nToRow := INT( nToRow * 10000 / 254 )
   nToCol := INT( nToCol * 10000 / 254 )

   IF VALTYPE( cAlign ) = 'C'
      IF HMG_UPPER( ALLTRIM( cAlign ) ) == 'CENTER'
         nAlign := TA_CENTER
      ELSEIF HMG_UPPER( ALLTRIM( cAlign ) ) == 'RIGHT'
         nAlign := TA_RIGHT
      ENDIF
   ENDIF
   _HMG_PRINTER_C_MULTILINE_PRINT( nHdc, nRow, nCol, cFontName, nFontSize, nColor1, nColor2, nColor3, cText, lbold, litalic, lunderline, lstrikeout, lcolor, lfont, lsize, nToRow, nToCol, nAlign )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_H_IMAGE()
*+
*+    Called from ( h_rptgen.prg )   1 - procedure _printimage()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_H_IMAGE( nHdc, cImage, nRow, nCol, nHeight, nWidth, lStretch, lTransparent, aTransparentColor )

   nRow := INT( nRow * 10000 / 254 )
   nCol := INT( nCol * 10000 / 254 )
   nWidth := INT( nWidth * 10000 / 254 )
   nHeight := INT( nHeight * 10000 / 254 )

   _HMG_PRINTER_C_IMAGE( nHdc, cImage, nRow, nCol, nHeight, nWidth, lStretch, lTransparent, aTransparentColor )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_H_LINE()
*+
*+    Called from ( h_rptgen.prg )   1 - procedure _printline()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_H_LINE( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nColor1, nColor2, nColor3, lwidth, lcolor )

   nRow := INT( nRow * 10000 / 254 )
   nCol := INT( nCol * 10000 / 254 )
   nToRow := INT( nToRow * 10000 / 254 )
   nToCol := INT( nToCol * 10000 / 254 )

   IF VALTYPE( nWidth ) != 'U'
      nWidth := INT( nWidth * 10000 / 254 )
   ENDIF

   _HMG_PRINTER_C_LINE( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nColor1, nColor2, nColor3, lwidth, lcolor )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_H_RECTANGLE()
*+
*+    Called from ( h_rptgen.prg )   1 - procedure _printrectangle()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_H_RECTANGLE( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nColor1, nColor2, nColor3, lwidth, lcolor, lfilled )

   nRow := INT( nRow * 10000 / 254 )
   nCol := INT( nCol * 10000 / 254 )
   nToRow := INT( nToRow * 10000 / 254 )
   nToCol := INT( nToCol * 10000 / 254 )

   IF VALTYPE( nWidth ) != 'U'
      nWidth := INT( nWidth * 10000 / 254 )
   ENDIF
   _HMG_PRINTER_C_RECTANGLE( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nColor1, nColor2, nColor3, lwidth, lcolor, lfilled )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_H_ROUNDRECTANGLE()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_H_ROUNDRECTANGLE( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nColor1, nColor2, nColor3, lwidth, lcolor, lfilled )

   nRow := INT( nRow * 10000 / 254 )
   nCol := INT( nCol * 10000 / 254 )
   nToRow := INT( nToRow * 10000 / 254 )
   nToCol := INT( nToCol * 10000 / 254 )

   IF VALTYPE( nWidth ) != 'U'
      nWidth := INT( nWidth * 10000 / 254 )
   ENDIF
   _HMG_PRINTER_C_ROUNDRECTANGLE( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nColor1, nColor2, nColor3, lwidth, lcolor, lfilled )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_InitUserMessages()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_showpreview()
*+                ( h_init.prg )   1 - procedure initmessages()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_InitUserMessages( cLang )

   // LANGUAGES NOT SUPPORTED BY hb_langSelect() FUNCTION.
   /*
IF _HMG_SYSDATA [ 211 ] == 'FI'     // FINNISH
    cLang := 'FI'
ELSEIF _HMG_SYSDATA [ 211 ] == 'NL' // DUTCH
    cLang := 'NL'
ENDIF
*/

   // *******************************************************************************************************************************************************
   IF HMG_IsCurrentCodePageUnicode()
      // *******************************************************************************************************************************************************
      DO CASE
            /////////////////////////////////////////////////////////////
            // TURKISH
            ////////////////////////////////////////////////////////////
            // case cLang == "TRWIN" .OR. cLang == "TR"
         CASE cLang == "TR"
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Sayfa'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Print Ã–n-izleme'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'Ãlk Sayfa [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Ã–nceki Sayfa [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Sonraki Sayfa [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Son sayfa [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Sayfa no'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'BÃ¼yÃ¼t/KÃ¼Ã§Ã¼lt'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'YazdÃ½r'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Sayfa No'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Tamam'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Ãptal'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Printer SeÃ§'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'KopyalarÃ½ birleÃ¾tir'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'SÃ½nÃ½rlÃ½ Print'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'Hepsi'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Sayfalar'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'Ãlk'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'Son'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Kopya sayÃ½sÃ½'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'BÃ¼tÃ¼n sÃ½nÃ½rlar'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'YalnÃ½z tek sayfalar'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'YalnÃ½z Ã§ift sayfalar'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Evet'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'HayÃ½r'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Kapat'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Kaydet'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Sayfa ikonlarÃ½'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Sayfa ikonlarÃ½ oluÃ¾turuluyor... LÃ¼tfen bekleyin...'

            /////////////////////////////////////////////////////////////
            // CZECH
            ////////////////////////////////////////////////////////////
            // case cLang ==  "CS" .OR. cLang == "CSWIN"
         CASE cLang == "CS"
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Strana'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'NÃ¡hled'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'PrvnÃ­ strana [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'PÃ¸edchozÃ­ strana [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'DalÅ¡Ã­ strana [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'PoslednÃ­ strana [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Jdi na stranu'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Lupa'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Tisk'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'ÃˆÃ­slo strany'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Storno'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Vyber tiskÃ¡rnu'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'TÃ¸Ã­dÃ¬nÃ­'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Rozsah tisku'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'vÅ¡e'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'strany'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'od'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'do'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'kopiÃ­'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'vÅ¡echny strany'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'lichÃ© strany'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'sudÃ© strany'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Ano'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'ZavÃ¸i'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'UloÅ¾'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Miniatury'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generuji miniatury... Ãˆekejte, prosÃ­m...'

            /////////////////////////////////////////////////////////////
            // CROATIAN
            ////////////////////////////////////////////////////////////
            // case cLang == "HR852" // Croatian
         CASE cLang == "HR"
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Page'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Print Preview'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'First Page [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Previous Page [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Next Page [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Last Page [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Go To Page'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Print'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Page Number'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Cancel'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Select Printer'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Collate Copies'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Print Range'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'All'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Pages'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'From'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'To'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copies'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'All Range'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Odd Pages Only'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Even Pages Only'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Yes'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Close'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Save'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Thumbnails'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generating Thumbnails... Please Wait...'

            /////////////////////////////////////////////////////////////
            // BASQUE
            ////////////////////////////////////////////////////////////
         CASE cLang == "EU"                                           // Basque.
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Page'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Print Preview'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'First Page [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Previous Page [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Next Page [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Last Page [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Go To Page'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Print'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Page Number'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Cancel'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Select Printer'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Collate Copies'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Print Range'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'All'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Pages'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'From'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'To'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copies'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'All Range'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Odd Pages Only'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Even Pages Only'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Yes'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Close'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Save'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Thumbnails'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generating Thumbnails... Please Wait...'

            /////////////////////////////////////////////////////////////
            // ENGLISH
            ////////////////////////////////////////////////////////////
         CASE cLang == "EN"                                           // English
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Page'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Print Preview'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'First Page [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Previous Page [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Next Page [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Last Page [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Go To Page'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Print'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Page Number'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Cancel'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Select Printer'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Collate Copies'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Print Range'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'All'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Pages'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'From'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'To'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copies'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'All Range'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Odd Pages Only'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Even Pages Only'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Yes'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Close'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Save'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Thumbnails'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generating Thumbnails... Please Wait...'

            /////////////////////////////////////////////////////////////
            // FRENCH
            ////////////////////////////////////////////////////////////
         CASE cLang == "FR"                                           // French
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Page'
            _HMG_SYSDATA[ 371 ] [ 02 ] := "AperÃ§u avant impression"
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'PremiÃ¨re page [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Page prÃ©cÃ©dente [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Page suivante [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'DerniÃ¨re page [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Allez page'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Imprimer'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Page'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Annulation'
            _HMG_SYSDATA[ 371 ] [ 13 ] := "SÃ©lection de l'imprimante"
            _HMG_SYSDATA[ 371 ] [ 14 ] := "Assemblez"
            _HMG_SYSDATA[ 371 ] [ 15 ] := "ParamÃ¨tres d'impression"
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'Tous'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Pages'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'De'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'Ã€'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copies'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'Toutes les pages'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Pages Impaires'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Pages Paires'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Oui'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'Non'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Fermer'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Sauver'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Affichettes'
            _HMG_SYSDATA[ 371 ] [ 29 ] := "CrÃ©ation des affichettes... Merci d'attendre..."

            /////////////////////////////////////////////////////////////
            // GERMAN
            ////////////////////////////////////////////////////////////
            // case cLang == "DEWIN" .OR. cLang == "DE"       // German
         CASE cLang == "DE"
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Seite'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'DruckcVorbetrachtung'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'Erste Seite [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Vorige Seite [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Folgende Seite [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Letzte Seite [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Gehen Sie Zu paginieren'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Druck'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Seitenzahl'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'O.K.'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'LÃ¶schen'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'WÃ¤hlen Sie Drucker Vor'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Sortieren'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'DruckcStrecke'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'Alle'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Seiten'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'Von'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'Zu'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Kopien'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'Alle Strecke'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Nur Ungerade Seiten'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Nur GleichmÃ¤ÃŸige Seiten'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Ja'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'Nein'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Fenster'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Speichern'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Ãœberblick'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Ãœberblick Erzeugen...  Bitte Wartezeit...'

            /////////////////////////////////////////////////////////////
            // ITALIAN
            ////////////////////////////////////////////////////////////
         CASE cLang == "IT"                                           // Italian
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Pagina'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Anteprima di stampa'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'Prima Pagina [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Pagina Precedente [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Pagina Seguente [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Ultima Pagina [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Vai Alla Pagina'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Stampa'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Pagina'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Annulla'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Selezioni Lo Stampatore'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Fascicoli'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Intervallo di stampa'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'Tutti'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Pagine'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'Da'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'A'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copie'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'Tutte le pagine'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Le Pagine Pari'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Le Pagine Dispari'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Si'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Chiudi'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Salva'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Miniatura'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generando Miniatura...  Prego Attesa...'

            /////////////////////////////////////////////////////////////
            // POLISH
            ////////////////////////////////////////////////////////////
            // case cLang == "PLWIN"  .OR. cLang == "PL852"  .OR. cLang == "PLISO"  .OR. cLang == ""  .OR. cLang == "PLMAZ"   // Polish
         CASE cLang == "PL"

            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Strona'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'PodglÂ¹d wydruku'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'Pierwsza strona [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Poprzednia strona [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'NastÃªpna strona [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Ostatnia strona [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Skocz do strony'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'PowiÃªksz'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Drukuj'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Numer strony'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Tak'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Przerwij'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Wybierz drukarkÃª'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Sortuj kopie'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Zakres wydruku'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'Wszystkie'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Strony'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'Od'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'Do'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Kopie'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'Wszystkie'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Nieparzyste'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Parzyste'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Tak'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'Nie'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Zamknij'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Zapisz'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Thumbnails'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'GenerujÃª Thumbnails... ProszÃª czekaÃ¦...'

            /////////////////////////////////////////////////////////////
            // PORTUGUESE
            ////////////////////////////////////////////////////////////
            // case cLang == "pt.PT850"        // Portuguese
         CASE cLang == "PT"
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'PÃ¡gina'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'VisualizaÃ§Ã£o prÃ©via da ImpressÃ£o'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'Primeira PÃ¡gina [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'PÃ¡gina Anterior [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'PrÃ³xima PÃ¡gina [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Ãšltima PÃ¡gina [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Ir para PÃ¡gina NÂº...'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Ampliar'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Imprimir'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'PÃ¡gina'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Cancelar'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Selecionar Impressora'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Ordenar CÃ³pias'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Faixa De ImpressÃ£o'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'Tudo'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'PÃ¡ginas'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'De'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'AtÃ©'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'CÃ³pias'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'Todas as PÃ¡ginas'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'SÃ³ PÃ¡ginas Ãmpares'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'SÃ³ PÃ¡ginas Pares'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Sim'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'NÃ£o'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Fechar e Sair'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Salvar em Arquivo'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Gerar Miniaturas'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Aguarde por favor, gerando Miniaturas...'

            /////////////////////////////////////////////////////////////
            // RUSSIAN
            ////////////////////////////////////////////////////////////
            // case cLang == "RUWIN"  .OR. cLang == "RU866" .OR. cLang == "RUKOI8" // Russian
         CASE cLang == "RU"
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Page'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Print Preview'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'First Page [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Previous Page [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Next Page [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Last Page [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Go To Page'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Print'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Page Number'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Cancel'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Select Printer'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Collate Copies'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Print Range'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'All'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Pages'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'From'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'To'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copies'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'All Range'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Odd Pages Only'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Even Pages Only'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Yes'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Close'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Save'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Thumbnails'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generating Thumbnails... Please Wait...'

            /////////////////////////////////////////////////////////////
            // SPANISH
            ////////////////////////////////////////////////////////////
            // case cLang == "ES"  .OR. cLang == "ESWIN"       // Spanish
         CASE cLang == "ES"
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'PÃ¡gina'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Vista Previa'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'Inicio [INICIO]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Anterior [REPAG]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Siguiente [AVPAG]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Fin [FIN]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Ir a'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Imprimir'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'PÃ¡gina Nro.'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Aceptar'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Cancelar'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Seleccionar Impresora'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Ordenar Copias'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Rango de ImpresiÃ³n'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'Todo'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'PÃ¡ginas'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'Desde'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'Hasta'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copias'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'Todo El Rango'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Solo PÃ¡ginas Impares'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Solo PÃ¡ginas Pares'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Si'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Cerrar'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Guardar'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Miniaturas'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generando Miniaturas... Espere Por Favor...'

            ///////////////////////////////////////////////////////////////////////
            // FINNISH
            ///////////////////////////////////////////////////////////////////////
         CASE cLang == "FI"                                           // Finnish
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Page'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Print Preview'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'First Page [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Previous Page [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Next Page [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Last Page [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Go To Page'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Print'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Page Number'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Cancel'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Select Printer'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Collate Copies'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Print Range'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'All'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Pages'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'From'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'To'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copies'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'All Range'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Odd Pages Only'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Even Pages Only'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Yes'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Close'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Save'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Thumbnails'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generating Thumbnails... Please Wait...'

            /////////////////////////////////////////////////////////////
            // DUTCH
            ////////////////////////////////////////////////////////////
         CASE cLang == "NL"                                           // Dutch
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Page'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Print Preview'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'First Page [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Previous Page [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Next Page [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Last Page [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Go To Page'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Print'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Page Number'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Cancel'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Select Printer'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Collate Copies'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Print Range'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'All'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Pages'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'From'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'To'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copies'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'All Range'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Odd Pages Only'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Even Pages Only'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Yes'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Close'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Save'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Thumbnails'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generating Thumbnails... Please Wait...'

            /////////////////////////////////////////////////////////////
            // SLOVENIAN
            ////////////////////////////////////////////////////////////
            // case cLang == "SLWIN" .OR. cLang == "SLISO" .OR. cLang == "SL852" .OR. cLang == "" .OR. cLang == "SL437" // Slovenian
         CASE cLang == "SL"
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Page'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Print Preview'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'First Page [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Previous Page [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Next Page [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Last Page [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Go To Page'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Print'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Page Number'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Cancel'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Select Printer'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Collate Copies'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Print Range'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'All'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Pages'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'From'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'To'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copies'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'All Range'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Odd Pages Only'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Even Pages Only'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Yes'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Close'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Save'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Thumbnails'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generating Thumbnails... Please Wait...'

         OTHERWISE
            /////////////////////////////////////////////////////////////
            // DEFAULT ENGLISH
            ////////////////////////////////////////////////////////////

            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Page'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Print Preview'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'First Page [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Previous Page [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Next Page [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Last Page [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Go To Page'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Print'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Page Number'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Cancel'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Select Printer'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Collate Copies'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Print Range'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'All'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Pages'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'From'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'To'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copies'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'All Range'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Odd Pages Only'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Even Pages Only'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Yes'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Close'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Save'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Thumbnails'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generating Thumbnails... Please Wait...'

      ENDCASE

      // *******************************************************************************************************************************************************
   ELSE                                                               // ANSI
      // *******************************************************************************************************************************************************

      DO CASE
            /////////////////////////////////////////////////////////////
            // TÜRKÇE
            ////////////////////////////////////////////////////////////
            // case cLang == "TRWIN" .OR. cLang == "TR"
         CASE cLang == "TR"
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Sayfa'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Print Ön-izleme'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'Ýlk Sayfa [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Önceki Sayfa [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Sonraki Sayfa [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Son sayfa [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Sayfa no'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Büyüt/Küçült'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Yazdýr'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Sayfa No'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Tamam'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Ýptal'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Printer Seç'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Kopyalarý birleþtir'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Sýnýrlý Print'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'Hepsi'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Sayfalar'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'Ýlk'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'Son'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Kopya sayýsý'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'Bütün sýnýrlar'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Yalnýz tek sayfalar'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Yalnýz çift sayfalar'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Evet'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'Hayýr'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Kapat'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Kaydet'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Sayfa ikonlarý'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Sayfa ikonlarý oluþturuluyor... Lütfen bekleyin...'

            /////////////////////////////////////////////////////////////
            // CZECH
            ////////////////////////////////////////////////////////////
            // case cLang ==  "CS" .OR. cLang == "CSWIN"
         CASE cLang == "CS"
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Strana'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Náhled'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'První strana [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Pøedchozí strana [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Další strana [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Poslední strana [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Jdi na stranu'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Lupa'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Tisk'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Èíslo strany'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Storno'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Vyber tiskárnu'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Tøídìní'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Rozsah tisku'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'vše'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'strany'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'od'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'do'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'kopií'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'všechny strany'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'liché strany'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'sudé strany'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Ano'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Zavøi'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Ulož'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Miniatury'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generuji miniatury... Èekejte, prosím...'

            /////////////////////////////////////////////////////////////
            // CROATIAN
            ////////////////////////////////////////////////////////////
            // case cLang == "HR852" // Croatian
         CASE cLang == "HR"
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Page'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Print Preview'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'First Page [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Previous Page [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Next Page [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Last Page [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Go To Page'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Print'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Page Number'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Cancel'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Select Printer'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Collate Copies'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Print Range'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'All'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Pages'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'From'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'To'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copies'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'All Range'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Odd Pages Only'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Even Pages Only'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Yes'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Close'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Save'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Thumbnails'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generating Thumbnails... Please Wait...'

            /////////////////////////////////////////////////////////////
            // BASQUE
            ////////////////////////////////////////////////////////////
         CASE cLang == "EU"                                           // Basque.
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Page'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Print Preview'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'First Page [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Previous Page [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Next Page [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Last Page [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Go To Page'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Print'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Page Number'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Cancel'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Select Printer'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Collate Copies'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Print Range'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'All'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Pages'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'From'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'To'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copies'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'All Range'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Odd Pages Only'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Even Pages Only'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Yes'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Close'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Save'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Thumbnails'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generating Thumbnails... Please Wait...'

            /////////////////////////////////////////////////////////////
            // ENGLISH
            ////////////////////////////////////////////////////////////
         CASE cLang == "EN"                                           // English
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Page'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Print Preview'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'First Page [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Previous Page [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Next Page [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Last Page [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Go To Page'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Print'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Page Number'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Cancel'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Select Printer'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Collate Copies'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Print Range'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'All'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Pages'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'From'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'To'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copies'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'All Range'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Odd Pages Only'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Even Pages Only'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Yes'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Close'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Save'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Thumbnails'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generating Thumbnails... Please Wait...'

            /////////////////////////////////////////////////////////////
            // FRENCH
            ////////////////////////////////////////////////////////////
         CASE cLang == "FR"                                           // French
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Page'
            _HMG_SYSDATA[ 371 ] [ 02 ] := "Aperçu avant impression"
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'Première page [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Page précédente [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Page suivante [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Dernière page [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Allez page'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Imprimer'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Page'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Annulation'
            _HMG_SYSDATA[ 371 ] [ 13 ] := "Sélection de l'imprimante"
            _HMG_SYSDATA[ 371 ] [ 14 ] := "Assemblez"
            _HMG_SYSDATA[ 371 ] [ 15 ] := "Paramètres d'impression"
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'Tous'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Pages'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'De'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'À'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copies'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'Toutes les pages'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Pages Impaires'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Pages Paires'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Oui'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'Non'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Fermer'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Sauver'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Affichettes'
            _HMG_SYSDATA[ 371 ] [ 29 ] := "Création des affichettes... Merci d'attendre..."

            /////////////////////////////////////////////////////////////
            // GERMAN
            ////////////////////////////////////////////////////////////
            // case cLang == "DEWIN" .OR. cLang == "DE"       // German
         CASE cLang == "DE"
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Seite'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'DruckcVorbetrachtung'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'Erste Seite [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Vorige Seite [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Folgende Seite [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Letzte Seite [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Gehen Sie Zu paginieren'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Druck'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Seitenzahl'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'O.K.'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Löschen'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Wählen Sie Drucker Vor'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Sortieren'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'DruckcStrecke'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'Alle'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Seiten'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'Von'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'Zu'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Kopien'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'Alle Strecke'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Nur Ungerade Seiten'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Nur Gleichmäßige Seiten'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Ja'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'Nein'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Fenster'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Speichern'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Überblick'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Überblick Erzeugen...  Bitte Wartezeit...'

            /////////////////////////////////////////////////////////////
            // ITALIAN
            ////////////////////////////////////////////////////////////
         CASE cLang == "IT"                                           // Italian
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Pagina'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Anteprima di stampa'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'Prima Pagina [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Pagina Precedente [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Pagina Seguente [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Ultima Pagina [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Vai Alla Pagina'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Stampa'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Pagina'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Annulla'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Selezioni Lo Stampatore'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Fascicoli'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Intervallo di stampa'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'Tutti'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Pagine'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'Da'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'A'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copie'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'Tutte le pagine'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Le Pagine Pari'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Le Pagine Dispari'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Si'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Chiudi'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Salva'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Miniatura'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generando Miniatura...  Prego Attesa...'

            /////////////////////////////////////////////////////////////
            // POLISH
            ////////////////////////////////////////////////////////////
            // case cLang == "PLWIN"  .OR. cLang == "PL852"  .OR. cLang == "PLISO"  .OR. cLang == ""  .OR. cLang == "PLMAZ"   // Polish
         CASE cLang == "PL"
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Strona'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Podgl¹d wydruku'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'Pierwsza strona [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Poprzednia strona [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Nastêpna strona [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Ostatnia strona [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Skocz do strony'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Powiêksz'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Drukuj'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Numer strony'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Tak'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Przerwij'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Wybierz drukarkê'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Sortuj kopie'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Zakres wydruku'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'Wszystkie'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Strony'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'Od'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'Do'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Kopie'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'Wszystkie'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Nieparzyste'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Parzyste'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Tak'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'Nie'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Zamknij'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Zapisz'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Thumbnails'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generujê Thumbnails... Proszê czekaæ...'

            /////////////////////////////////////////////////////////////
            // PORTUGUESE
            ////////////////////////////////////////////////////////////
            // case cLang == "pt.PT850"        // Portuguese
         CASE cLang == "PT"
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Página'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Visualização prévia da Impressão'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'Primeira Página [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Página Anterior [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Próxima Página [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Última Página [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Ir para Página Nº...'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Ampliar'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Imprimir'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Página'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Cancelar'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Selecionar Impressora'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Ordenar Cópias'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Faixa De Impressão'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'Tudo'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Páginas'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'De'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'Até'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Cópias'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'Todas as Páginas'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Só Páginas Ímpares'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Só Páginas Pares'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Sim'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'Não'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Fechar e Sair'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Salvar em Arquivo'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Gerar Miniaturas'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Aguarde por favor, gerando Miniaturas...'

            /////////////////////////////////////////////////////////////
            // RUSSIAN
            ////////////////////////////////////////////////////////////
            // case cLang == "RUWIN"  .OR. cLang == "RU866" .OR. cLang == "RUKOI8" // Russian
         CASE cLang == "RU"
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Page'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Print Preview'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'First Page [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Previous Page [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Next Page [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Last Page [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Go To Page'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Print'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Page Number'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Cancel'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Select Printer'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Collate Copies'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Print Range'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'All'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Pages'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'From'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'To'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copies'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'All Range'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Odd Pages Only'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Even Pages Only'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Yes'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Close'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Save'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Thumbnails'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generating Thumbnails... Please Wait...'

            /////////////////////////////////////////////////////////////
            // SPANISH
            ////////////////////////////////////////////////////////////
            // case cLang == "ES"  .OR. cLang == "ESWIN"       // Spanish
         CASE cLang == "ES"
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Página'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Vista Previa'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'Inicio [INICIO]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Anterior [REPAG]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Siguiente [AVPAG]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Fin [FIN]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Ir a'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Imprimir'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Página Nro.'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Aceptar'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Cancelar'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Seleccionar Impresora'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Ordenar Copias'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Rango de Impresión'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'Todo'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Páginas'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'Desde'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'Hasta'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copias'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'Todo El Rango'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Solo Páginas Impares'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Solo Páginas Pares'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Si'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Cerrar'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Guardar'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Miniaturas'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generando Miniaturas... Espere Por Favor...'

            ///////////////////////////////////////////////////////////////////////
            // FINNISH
            ///////////////////////////////////////////////////////////////////////
         CASE cLang == "FI"                                           // Finnish
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Page'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Print Preview'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'First Page [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Previous Page [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Next Page [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Last Page [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Go To Page'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Print'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Page Number'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Cancel'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Select Printer'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Collate Copies'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Print Range'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'All'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Pages'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'From'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'To'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copies'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'All Range'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Odd Pages Only'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Even Pages Only'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Yes'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Close'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Save'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Thumbnails'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generating Thumbnails... Please Wait...'

            /////////////////////////////////////////////////////////////
            // DUTCH
            ////////////////////////////////////////////////////////////
         CASE cLang == "NL"                                           // Dutch
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Page'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Print Preview'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'First Page [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Previous Page [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Next Page [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Last Page [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Go To Page'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Print'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Page Number'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Cancel'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Select Printer'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Collate Copies'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Print Range'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'All'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Pages'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'From'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'To'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copies'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'All Range'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Odd Pages Only'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Even Pages Only'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Yes'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Close'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Save'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Thumbnails'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generating Thumbnails... Please Wait...'

            /////////////////////////////////////////////////////////////
            // SLOVENIAN
            ////////////////////////////////////////////////////////////
            // case cLang == "SLWIN" .OR. cLang == "SLISO" .OR. cLang == "SL852" .OR. cLang == "" .OR. cLang == "SL437" // Slovenian
         CASE cLang == "SL"
            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Page'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Print Preview'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'First Page [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Previous Page [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Next Page [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Last Page [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Go To Page'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Print'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Page Number'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Cancel'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Select Printer'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Collate Copies'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Print Range'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'All'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Pages'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'From'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'To'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copies'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'All Range'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Odd Pages Only'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Even Pages Only'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Yes'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Close'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Save'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Thumbnails'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generating Thumbnails... Please Wait...'

         OTHERWISE
            /////////////////////////////////////////////////////////////
            // DEFAULT ENGLISH
            ////////////////////////////////////////////////////////////

            _HMG_SYSDATA[ 371 ] [ 01 ] := 'Page'
            _HMG_SYSDATA[ 371 ] [ 02 ] := 'Print Preview'
            _HMG_SYSDATA[ 371 ] [ 03 ] := 'First Page [HOME]'
            _HMG_SYSDATA[ 371 ] [ 04 ] := 'Previous Page [PGUP]'
            _HMG_SYSDATA[ 371 ] [ 05 ] := 'Next Page [PGDN]'
            _HMG_SYSDATA[ 371 ] [ 06 ] := 'Last Page [END]'
            _HMG_SYSDATA[ 371 ] [ 07 ] := 'Go To Page'
            _HMG_SYSDATA[ 371 ] [ 08 ] := 'Zoom'
            _HMG_SYSDATA[ 371 ] [ 09 ] := 'Print'
            _HMG_SYSDATA[ 371 ] [ 10 ] := 'Page Number'
            _HMG_SYSDATA[ 371 ] [ 11 ] := 'Ok'
            _HMG_SYSDATA[ 371 ] [ 12 ] := 'Cancel'
            _HMG_SYSDATA[ 371 ] [ 13 ] := 'Select Printer'
            _HMG_SYSDATA[ 371 ] [ 14 ] := 'Collate Copies'
            _HMG_SYSDATA[ 371 ] [ 15 ] := 'Print Range'
            _HMG_SYSDATA[ 371 ] [ 16 ] := 'All'
            _HMG_SYSDATA[ 371 ] [ 17 ] := 'Pages'
            _HMG_SYSDATA[ 371 ] [ 18 ] := 'From'
            _HMG_SYSDATA[ 371 ] [ 19 ] := 'To'
            _HMG_SYSDATA[ 371 ] [ 20 ] := 'Copies'
            _HMG_SYSDATA[ 371 ] [ 21 ] := 'All Range'
            _HMG_SYSDATA[ 371 ] [ 22 ] := 'Odd Pages Only'
            _HMG_SYSDATA[ 371 ] [ 23 ] := 'Even Pages Only'
            _HMG_SYSDATA[ 371 ] [ 24 ] := 'Yes'
            _HMG_SYSDATA[ 371 ] [ 25 ] := 'No'
            _HMG_SYSDATA[ 371 ] [ 26 ] := 'Close'
            _HMG_SYSDATA[ 371 ] [ 27 ] := 'Save'
            _HMG_SYSDATA[ 371 ] [ 28 ] := 'Thumbnails'
            _HMG_SYSDATA[ 371 ] [ 29 ] := 'Generating Thumbnails... Please Wait...'

      ENDCASE

   ENDIF                                                              // HMG_IsCurrentCodePageUnicode()
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function GETPRINTABLEAREAWIDTH()
*+
*+    Called from ( h_windows.prg )   1 - function printwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GETPRINTABLEAREAWIDTH()

RETURN _HMG_PRINTER_GETPRINTERWIDTH( _HMG_SYSDATA[ 374 ] )

*+--------------------------------------------------------------------
*+
*+    Function GETPRINTABLEAREAHEIGHT()
*+
*+    Called from ( h_windows.prg )   1 - function printwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GETPRINTABLEAREAHEIGHT()

RETURN _HMG_PRINTER_GETPRINTERHEIGHT( _HMG_SYSDATA[ 374 ] )

*+--------------------------------------------------------------------
*+
*+    Function GETPRINTABLEAREAHORIZONTALOFFSET()
*+
*+    Called from ( h_windows.prg )   1 - function printwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GETPRINTABLEAREAHORIZONTALOFFSET()

   IF !__MVEXIST( '_HMG_SYSDATA [ 374 ]' )
      RETURN 0
   ENDIF
RETURN ( _HMG_PRINTER_GETPRINTABLEAREAPHYSICALOFFSETX( _HMG_SYSDATA[ 374 ] ) / _HMG_PRINTER_GETPRINTABLEAREALOGPIXELSX( _HMG_SYSDATA[ 374 ] ) * 25.4 )

*+--------------------------------------------------------------------
*+
*+    Function GETPRINTABLEAREAVERTICALOFFSET()
*+
*+    Called from ( h_windows.prg )   1 - function printwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GETPRINTABLEAREAVERTICALOFFSET()

   IF !__MVEXIST( '_HMG_SYSDATA [ 374 ]' )
      RETURN 0
   ENDIF
RETURN ( _HMG_PRINTER_GETPRINTABLEAREAPHYSICALOFFSETY( _HMG_SYSDATA[ 374 ] ) / _HMG_PRINTER_GETPRINTABLEAREALOGPIXELSY( _HMG_SYSDATA[ 374 ] ) * 25.4 )

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_MouseZoom()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_spltchldmouseclick()
*+                                   1 - function _hmg_printer_set_k_events()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_MouseZoom( Flag )

LOCAL Width       := GetDesktopWidth()
LOCAL Height      := GetDesktopHeight()
LOCAL Q           := 0
LOCAL DeltaHeight := 35 + GetTitleHeight() + GetBorderHeight() + 10

   IF VALTYPE( Flag ) <> "L"
      IF _HMG_PRINTER_SpltChldMouseCursor() == .F.                    // ADD April 2014
         RETURN NIL
      ENDIF
   ENDIF

   IF _HMG_SYSDATA[ 365 ] == 1000 + _HMG_SYSDATA[ 359 ]

      _HMG_SYSDATA[ 365 ] := 0
      _HMG_SYSDATA[ 363 ] := 0
      _HMG_SYSDATA[ 364 ] := 0

      SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_VERT, 50, .T. )
      SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_HORZ, 50, .T. )

      _HMG_PRINTER_PREVIEW_DISABLESCROLLBARS( GetFormHandle( 'SPLITCHILD_1' ) )

   ELSE

      //  Calculate Quadrant

      IF _HMG_SYSDATA[ 192 ] <= ( Width / 2 ) - _HMG_SYSDATA[ 367 ] .AND. ;
                 _HMG_SYSDATA[ 191 ] <= ( Height / 2 ) - DeltaHeight

         Q := 1

      ELSEIF _HMG_SYSDATA[ 192 ] > ( Width / 2 ) - _HMG_SYSDATA[ 367 ] .AND. ;
                 _HMG_SYSDATA[ 191 ] <= ( Height / 2 ) - DeltaHeight

         Q := 2

      ELSEIF _HMG_SYSDATA[ 192 ] <= ( Width / 2 ) - _HMG_SYSDATA[ 367 ] .AND. ;
                 _HMG_SYSDATA[ 191 ] > ( Height / 2 ) - DeltaHeight

         Q := 3

      ELSEIF _HMG_SYSDATA[ 192 ] > ( Width / 2 ) - _HMG_SYSDATA[ 367 ] .AND. ;
                 _HMG_SYSDATA[ 191 ] > ( Height / 2 ) - DeltaHeight

         Q := 4

      ENDIF

      IF _HMG_PRINTER_GETPAGEHEIGHT( _HMG_SYSDATA[ 372 ] ) > ;
                                     _HMG_PRINTER_GETPAGEWIDTH( _HMG_SYSDATA[ 372 ] )

         //  Portrait

         IF Q == 1
            _HMG_SYSDATA[ 365 ] := 1000 + _HMG_SYSDATA[ 359 ]
            _HMG_SYSDATA[ 363 ] := 100
            _HMG_SYSDATA[ 364 ] := 400
            SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_VERT, 10, .T. )
            SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_HORZ, 40, .T. )
         ELSEIF Q == 2
            _HMG_SYSDATA[ 365 ] := 1000 + _HMG_SYSDATA[ 359 ]
            _HMG_SYSDATA[ 363 ] := - 100
            _HMG_SYSDATA[ 364 ] := 400
            SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_VERT, 10, .T. )
            SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_HORZ, 60, .T. )
         ELSEIF Q == 3
            _HMG_SYSDATA[ 365 ] := 1000 + _HMG_SYSDATA[ 359 ]
            _HMG_SYSDATA[ 363 ] := 100
            _HMG_SYSDATA[ 364 ] := - 400
            SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_VERT, 90, .T. )
            SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_HORZ, 40, .T. )
         ELSEIF Q == 4
            _HMG_SYSDATA[ 365 ] := 1000 + _HMG_SYSDATA[ 359 ]
            _HMG_SYSDATA[ 363 ] := - 100
            _HMG_SYSDATA[ 364 ] := - 400
            SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_VERT, 90, .T. )
            SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_HORZ, 60, .T. )
         ENDIF

      ELSE

         //  Landscape

         IF Q == 1
            _HMG_SYSDATA[ 365 ] := 1000 + _HMG_SYSDATA[ 359 ]
            _HMG_SYSDATA[ 363 ] := 500
            _HMG_SYSDATA[ 364 ] := 300
            SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_VERT, 20, .T. )
            SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_HORZ, 1, .T. )
         ELSEIF Q == 2
            _HMG_SYSDATA[ 365 ] := 1000 + _HMG_SYSDATA[ 359 ]
            _HMG_SYSDATA[ 363 ] := - 500
            _HMG_SYSDATA[ 364 ] := 300
            SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_VERT, 20, .T. )
            SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_HORZ, 99, .T. )
         ELSEIF Q == 3
            _HMG_SYSDATA[ 365 ] := 1000 + _HMG_SYSDATA[ 359 ]
            _HMG_SYSDATA[ 363 ] := 500
            _HMG_SYSDATA[ 364 ] := - 300
            SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_VERT, 80, .T. )
            SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_HORZ, 1, .T. )
         ELSEIF Q == 4
            _HMG_SYSDATA[ 365 ] := 1000 + _HMG_SYSDATA[ 359 ]
            _HMG_SYSDATA[ 363 ] := - 500
            _HMG_SYSDATA[ 364 ] := - 300
            SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_VERT, 80, .T. )
            SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_HORZ, 99, .T. )
         ENDIF

      ENDIF

      _HMG_PRINTER_PREVIEW_ENABLESCROLLBARS( GetFormHandle( 'SPLITCHILD_1' ) )
      DoMethod( "SPLITCHILD_1", "SetFocus" )
   ENDIF
   _HMG_PRINTER_PREVIEWRefresh()
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_Zoom()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_showpreview()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_Zoom()

   IF _HMG_SYSDATA[ 365 ] == 1000 + _HMG_SYSDATA[ 359 ]

      _HMG_SYSDATA[ 365 ] := 0
      _HMG_SYSDATA[ 363 ] := 0
      _HMG_SYSDATA[ 364 ] := 0

      SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_VERT, 50, .T. )
      SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_HORZ, 50, .T. )

      _HMG_PRINTER_PREVIEW_DISABLESCROLLBARS( GetFormHandle( 'SPLITCHILD_1' ) )
      _HMG_PRINTER_PREVIEWRefresh()
      DoMethod( "_HMG_PRINTER_SHOWPREVIEW", "SetFocus" )
   ELSE

      IF _HMG_PRINTER_GETPAGEHEIGHT( _HMG_SYSDATA[ 372 ] ) > ;
                                     _HMG_PRINTER_GETPAGEWIDTH( _HMG_SYSDATA[ 372 ] )

         _HMG_SYSDATA[ 365 ] := 1000 + _HMG_SYSDATA[ 359 ]
         _HMG_SYSDATA[ 363 ] := 100
         _HMG_SYSDATA[ 364 ] := 400
         SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_VERT, 10, .T. )
         SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_HORZ, 40, .T. )

      ELSE

         _HMG_SYSDATA[ 365 ] := 1000 + _HMG_SYSDATA[ 359 ]
         _HMG_SYSDATA[ 363 ] := 500
         _HMG_SYSDATA[ 364 ] := 300
         SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_VERT, 20, .T. )
         SetScrollPos( GetFormHandle( 'SPLITCHILD_1' ), SB_HORZ, 1, .T. )

      ENDIF
      _HMG_PRINTER_PREVIEW_ENABLESCROLLBARS( GetFormHandle( 'SPLITCHILD_1' ) )
      _HMG_PRINTER_PREVIEWRefresh()
      DoMethod( "SPLITCHILD_1", "SetFocus" )
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_PRINTER_SETJOBNAME()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_PRINTER_SETJOBNAME( cName )

   IF VALTYPE( cName ) = 'U'
      _HMG_SYSDATA[ 358 ] := 'HMG Print System'
   ELSE
      _HMG_SYSDATA[ 358 ] := cName
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function HMG_PrintGetJobInfo()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_PrintGetJobInfo( aJobData )                              // by Dr. Claudio Soto, August 2015

LOCAL cPrinterName, nJobID
   IF VALTYPE( aJobData ) == "U"
      aJobData := OpenPrinterGetJobData()
   ENDIF
   nJobID := aJobData[ 1 ]
   cPrinterName := aJobData[ 2 ]
RETURN _HMG_PrintGetJobInfo( cPrinterName, nJobID )                   // --> { nJobID, cPrinterName, cMachineName, cUserName, cDocument, cDataType, cStatus, nStatus
//       nPriorityLevel, nPositionPrintQueue, nTotalPages, nPagesPrinted, cLocalDate, cLocalTime }

*+--------------------------------------------------------------------
*+
*+    Function HMG_PrinterGetStatus()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_PrinterGetStatus( cPrinterName )

   IF VALTYPE( cPrinterName ) == "U"
      cPrinterName := OpenPrinterGetName()
   ENDIF
RETURN _HMG_PrinterGetStatus( cPrinterName )                          // --> nStatus

// ******************************************************************************************************************

// ------------------------------------------------------------------------------*
//  Based on HBMZIP Harbour contribution library samples.
// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function COMPRESSFILES()
*+
*+--------------------------------------------------------------------
*+
FUNCTION COMPRESSFILES( cFileName, aDir, bBlock, lOvr )

LOCAL hZip, i, cPassword

   IF VALTYPE( lOvr ) == 'L'
      IF lOvr == .t.
         IF FILE( cFileName )
            DELETE FILE (cFileName)
         ENDIF
      ENDIF
   ENDIF

   hZip := HB_ZIPOPEN( cFileName )
   IF !EMPTY( hZip )
      FOR i := 1 TO HMG_LEN( aDir )
         IF VALTYPE( bBlock ) == 'B'
            EVAL( bBlock, aDir[ i ], i )
         ENDIF
         HB_ZipStoreFile( hZip, aDir[ i ], aDir[ i ], cPassword )
      NEXT
   ENDIF
   HB_ZIPCLOSE( hZip )
RETURN Nil

// ------------------------------------------------------------------------------*
//  Based on HBMZIP Harbour contribution library samples.
// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function UNCOMPRESSFILES()
*+
*+--------------------------------------------------------------------
*+
FUNCTION UNCOMPRESSFILES( cFileName, bBlock )

LOCAL i := 0, hUnzip, nErr, cFile, dDate, cTime, nSize, nCompSize

   hUnzip := HB_UNZIPOPEN( cFileName )

   nErr := HB_UNZIPFILEFIRST( hUnzip )

   DO WHILE nErr == 0

      HB_UnzipFileInfo( hUnzip, @cFile, @dDate, @cTime,,,, @nSize, @nCompSize )

      i ++
      IF VALTYPE( bBlock ) = 'B'
         EVAL( bBlock, cFile, i )
      ENDIF

      HB_UnzipExtractCurrentFile( hUnzip, NIL, NIL )

      nErr := HB_UNZIPFILENEXT( hUnzip )

   ENDDO
   HB_UNZIPCLOSE( hUnzip )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _GetControlObject()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetControlObject( ControlName, ParentForm )

LOCAL mVar, i

   mVar := '_' + ParentForm + '_' + ControlName
   i := &mVar
   IF i == 0
      RETURN ''
   ENDIF
RETURN ( _HMG_SYSDATA[ 39 ] [ &mVar ] )

// *****************************************************************************************

*+--------------------------------------------------------------------
*+
*+    Function _DefineActivex()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _DefineActivex( cControlName, cParentForm, nRow, nCol, nWidth, nHeight, cProgId )

LOCAL mVar, nControlHandle, k := 0, nParentFormHandle, oOle
LOCAL nAtlDllHandle, cParentTabName, nInterfacePointer

   //  If defined inside DEFINE WINDOW structure, determine cParentForm

   IF _HMG_SYSDATA[ 264 ] = .T.
      cParentForm := _HMG_SYSDATA[ 223 ]
   ENDIF

   //  If defined inside a Tab structure, adjust position and determine
   //  cParentForm

   IF _HMG_SYSDATA[ 183 ] > 0
      nCol := nCol + _HMG_SYSDATA[ 334 ] [ _HMG_SYSDATA[ 183 ] ]
      nRow := nRow + _HMG_SYSDATA[ 333 ] [ _HMG_SYSDATA[ 183 ] ]
      cParentForm := _HMG_SYSDATA[ 332 ] [ _HMG_SYSDATA[ 183 ] ]
      cParentTabName := _HMG_SYSDATA[ 225 ]
   ENDIF

   //  Check for errors

   //  Check Parent Window

   IF .NOT. _IsWindowDefined( cParentForm )
      MsgHMGError( "Window: " + cParentForm + " is not defined. Program terminated" )
   ENDIF

   //  Check Control

   IF _IsControlDefined( cControlName, cParentForm )
      MsgHMGError( "Control: " + cControlName + " Of " + cParentForm + " Already defined. Program Terminated" )
   ENDIF

   //  Check cProgId

   IF VALTYPE( cProgId ) <> 'C'
      MsgHMGError( "Control: " + cControlName + " Of " + cParentForm + " PROGID Property Invalid Type. Program Terminated" )
   ENDIF

   IF EMPTY( cProgId )
      MsgHMGError( "Control: " + cControlName + " Of " + cParentForm + " PROGID Can't be empty. Program Terminated" )
   ENDIF

   //  Define public variable associated with control

   mVar := '_' + cParentForm + '_' + cControlName

   nParentFormHandle := GetFormHandle( cParentForm )

   //  Init Activex

   aResult := InitActivex( nParentFormHandle, cProgId, nCol, nRow, nWidth, nHeight )

   nControlHandle := aResult[ 1 ]
   nInterfacePointer := aResult[ 2 ]
   nAtlDllHandle := aResult[ 3 ]

   IF _HMG_SYSDATA[ 265 ] = .T.
      AADD( _HMG_SYSDATA[ 142 ], nControlhandle )
   ENDIF

   //  Create OLE control

   oOle := ToleAuto() :New( nInterfacePointer )

   k := _GetControlFree()

PUBLIC &mVar. := k

   _HMG_SYSDATA[ 1 ] [ k ] := "ACTIVEX"
   _HMG_SYSDATA[ 2 ] [ k ] := cControlName
   _HMG_SYSDATA[ 3 ] [ k ] := nControlHandle
   _HMG_SYSDATA[ 4 ] [ k ] := nParentFormHandle
   _HMG_SYSDATA[ 5 ] [ k ] := 0
   _HMG_SYSDATA[ 6 ] [ k ] := ""
   _HMG_SYSDATA[ 7 ] [ k ] := {}
   _HMG_SYSDATA[ 8 ] [ k ] := Nil
   _HMG_SYSDATA[ 9 ] [ k ] := ""
   _HMG_SYSDATA[ 10 ] [ k ] := Nil
   _HMG_SYSDATA[ 11 ] [ k ] := Nil
   _HMG_SYSDATA[ 12 ] [ k ] := ""
   _HMG_SYSDATA[ 13 ] [ k ] := .F.
   _HMG_SYSDATA[ 14 ] [ k ] := Nil
   _HMG_SYSDATA[ 15 ] [ k ] := Nil
   _HMG_SYSDATA[ 16 ] [ k ] := ""
   _HMG_SYSDATA[ 17 ] [ k ] := {}
   _HMG_SYSDATA[ 18 ] [ k ] := nRow
   _HMG_SYSDATA[ 19 ] [ k ] := nCol
   _HMG_SYSDATA[ 20 ] [ k ] := nWidth
   _HMG_SYSDATA[ 21 ] [ k ] := nHeight
   _HMG_SYSDATA[ 22 ] [ k ] := 'T'
   _HMG_SYSDATA[ 23 ] [ k ] := IIF( _HMG_SYSDATA[ 183 ] > 0, _HMG_SYSDATA[ 333 ] [ _HMG_SYSDATA[ 183 ] ], - 1 )
   _HMG_SYSDATA[ 24 ] [ k ] := IIF( _HMG_SYSDATA[ 183 ] > 0, _HMG_SYSDATA[ 334 ] [ _HMG_SYSDATA[ 183 ] ], - 1 )
   _HMG_SYSDATA[ 25 ] [ k ] := ""
   _HMG_SYSDATA[ 26 ] [ k ] := 0
   _HMG_SYSDATA[ 27 ] [ k ] := ""
   _HMG_SYSDATA[ 28 ] [ k ] := 0
   _HMG_SYSDATA[ 29 ] [ k ] := { .f., .f., .f., .f. }
   _HMG_SYSDATA[ 30 ] [ k ] := ""
   _HMG_SYSDATA[ 31 ] [ k ] := ""
   _HMG_SYSDATA[ 32 ] [ k ] := 0
   _HMG_SYSDATA[ 33 ] [ k ] := ""
   _HMG_SYSDATA[ 34 ] [ k ] := .t.
   _HMG_SYSDATA[ 35 ] [ k ] := nAtlDllHandle
   _HMG_SYSDATA[ 36 ] [ k ] := 0
   _HMG_SYSDATA[ 37 ] [ k ] := 0
   _HMG_SYSDATA[ 38 ] [ k ] := .T.
   _HMG_SYSDATA[ 39 ] [ k ] := oOle
   _HMG_SYSDATA[ 40 ] [ k ] := { NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL }
RETURN oOle

*+--------------------------------------------------------------------
*+
*+    Function _HMG_SetHeaderImages()
*+
*+    Called from ( h_controlmisc.prg )   1 - function setproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_SetHeaderImages( cControlName, cParentForm, nColumn, cImage )

LOCAL i, nControlHandle, nHeaderImageListHandle, aHeaderImages
LOCAL cControlType
LOCAL aHeadersJustify
LOCAL NoTransHeader

   //  Get Control Type

   cControlType := GetControlType( cControlName, cParentForm )

   //  Get Control Index

   i := GetControlIndex( cControlName, cParentForm )

   //  Get Control handle

   nControlHandle := _HMG_SYSDATA[ 3 ] [ i ]

   //  Process According Control Type

   IF cControlType == 'GRID' .OR. cControlType == 'MULTIGRID'

      //  Get Header Justify Array

      aHeadersJustify := _HMG_SYSDATA[ 37 ] [ i ]

      //  Get Header Images Array *

      aHeaderImages := _HMG_SYSDATA[ 22 ] [ i ]

      //  Get Header ImageList Handle *

      nHeaderImageListHandle := _HMG_SYSDATA[ 26 ] [ i ]

      NoTransHeader := _HMG_SYSDATA[ 40 ] [ i ] [ 39 ]

      //  Destroy Current ImageList *

      IMAGELIST_DESTROY( nHeaderImageListHandle )

      //  Updete aHeaderImages Specified Column With The New Image *

      aHeaderImages[ nColumn ] := cImage

      _HMG_SYSDATA[ 22 ] [ i ] := aHeaderImages

      //  Set New Image *

      nHeaderImageListHandle := SetListViewHeaderImages( nControlHandle, aHeaderImages, aHeadersJustify, NoTransHeader )

      //  Update ImageList Handle in Control Data Array *

      _HMG_SYSDATA[ 26 ] [ i ] := nHeaderImageListHandle

#ifdef COMPILEBROWSE

   ELSEIF cControlType == 'BROWSE'

      //  Get Header Justify Array

      aHeadersJustify := _HMG_SYSDATA[ 39 ] [ i ] [ 11 ]

      //  Get Header Images Array *

      aHeaderImages := _HMG_SYSDATA[ 39 ] [ i ] [ 9 ]

      //  Get Header ImageList Handle *

      nHeaderImageListHandle := _HMG_SYSDATA[ 39 ] [ i ] [ 10 ]

      //  Destroy Current ImageList *

      IMAGELIST_DESTROY( nHeaderImageListHandle )

      //  Updete aHeaderImages Specified Column With The New Image *

      aHeaderImages[ nColumn ] := cImage

      _HMG_SYSDATA[ 39 ] [ i ] [ 9 ] := aHeaderImages

      //  Set New Image *

      // NoTransHeader := .F.

      nHeaderImageListHandle := SetListViewHeaderImages( nControlHandle, aHeaderImages, aHeadersJustify, .F. /* NoTransHeader */ )          // Browse

      //  Update ImageList Handle in Control Data Array *

      _HMG_SYSDATA[ 39 ] [ i ] [ 10 ] := nHeaderImageListHandle

#endif

   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_GetHeaderImages()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_GetHeaderImages( cControlName, cParentForm, nColumn )

LOCAL i, aHeaderImages
LOCAL cControlType
LOCAL cRetVal

   //  Get Control Type *

   cControlType := GetControlType( cControlName, cParentForm )

   //  Get Control Index *

   i := GetControlIndex( cControlName, cParentForm )

   //  Process According Control Type

   IF cControlType == 'GRID' .OR. cControlType == 'MULTIGRID'

      //  Get Header Images Array *

      aHeaderImages := _HMG_SYSDATA[ 22 ] [ i ]

      cRetVal := aHeaderImages[ nColumn ]

#ifdef COMPILEBROWSE

   ELSEIF cControlType == 'BROWSE'

      //  Get Header Images Array *

      aHeaderImages := _HMG_SYSDATA[ 39 ] [ i ] [ 9 ]

      cRetVal := aHeaderImages[ nColumn ]

#endif

   ENDIF
RETURN cRetVal

*+--------------------------------------------------------------------
*+
*+    Function SetProperty()
*+
*+    Called from ( h_grid.prg )   7 - procedure _hmg_setgridcelleditvalue()
*+                ( h_gridex.prg )   1 - procedure _gridex_checkboxallitems()
*+                                   1 - procedure _gridex_groupcheckboxallitems()
*+                ( h_controlmisc.prg )   2 - function inputwindow()
*+                                   1 - procedure _inputwindowsetdtformat()
*+                                   1 - function setmethodcode()
*+                                   2 - function _hmg_printer_showpreview()
*+                                   4 - function _hmg_printer_processthumbnails()
*+                                  10 - function setproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SetProperty( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8 )

LOCAL i, hWnd
LOCAL cMacro
LOCAL k

   IF _GridEx_SetProperty( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8 ) == .T.
      RETURN NIL
   ENDIF

   IF _Tree_SetProperty( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8 ) == .T.
      RETURN NIL
   ENDIF

   IF _RichEditBox_SetProperty( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8 ) == .T.
      RETURN NIL
   ENDIF

   IF PCOUNT() == 3                                                   // Window

      Arg2 := HMG_UPPER( ALLTRIM( Arg2 ) )

      FOR i := 1 TO HMG_LEN( _HMG_SYSDATA[ 61 ] )
         IF Arg2 == _HMG_SYSDATA[ 61 ] [ i ] [ 1 ]
            cMacro := _HMG_SYSDATA[ 61 ] [ i ] [ 2 ]
            &cMacro( Arg1, Arg2, Arg3 )

            IF _HMG_SYSDATA[ 63 ] == .T.
               RETURN NIL
            ENDIF

         ENDIF

      NEXT i

      IF .NOT. _IsWindowDefined( Arg1 )
         MsgHMGError( "Window: " + Arg1 + " is not defined. Program terminated" )
      ENDIF

      hWnd := GetFormHandle( Arg1 )

      IF Arg2 == 'TITLE'
         SetWindowText( GetFormHandle( Arg1 ), Arg3 )

      ELSEIF Arg2 == 'HEIGHT'
         _SetWindowSizePos( Arg1,,,, Arg3 )

      ELSEIF Arg2 == 'WIDTH'
         _SetWindowSizePos( Arg1,,, Arg3, )

      ELSEIF Arg2 == 'COL'
         _SetWindowSizePos( Arg1,, Arg3,, )

      ELSEIF Arg2 == 'ROW'
         _SetWindowSizePos( Arg1, Arg3,,, )

      ELSEIF Arg2 == 'NOTIFYICON'
         _SetNotifyIconName( Arg1, Arg3 )

      ELSEIF Arg2 == 'NOTIFYTOOLTIP'
         _SetNotifyIconTooltip( Arg1, Arg3 )

      ELSEIF Arg2 == 'CURSOR'
         SetWindowCursor( GetFormHandle( Arg1 ), Arg3 )

      ELSEIF Arg2 == HMG_UPPER( "NoClose" )
         IF Arg3 == .T.
            xDisableMenuItem( GetSystemMenu( hWnd ), SC_CLOSE )
         ELSE
            xEnableMenuItem( GetSystemMenu( hWnd ), SC_CLOSE )
         ENDIF

      ELSEIF Arg2 == HMG_UPPER( "NoCaption" )
         IF Arg3 == .T.
            HMG_ChangeWindowStyle( hWnd, NIL, WS_CAPTION, .F. )       // remove style
         ELSE
            HMG_ChangeWindowStyle( hWnd, WS_CAPTION, NIL, .F. )       // add style
         ENDIF
      ELSEIF Arg2 == HMG_UPPER( "NoMaximize" )
         IF HMG_IsWindowStyle( hWnd, WS_EX_CONTEXTHELP, .T. ) == .F.
            IF Arg3 == .T.
               HMG_ChangeWindowStyle( hWnd, NIL, WS_MAXIMIZEBOX, .F. )                                                                      // remove style
            ELSE
               HMG_ChangeWindowStyle( hWnd, WS_MAXIMIZEBOX, NIL, .F. )                                                                      // add style
            ENDIF
         ENDIF
      ELSEIF Arg2 == HMG_UPPER( "NoMinimize" )
         IF HMG_IsWindowStyle( hWnd, WS_EX_CONTEXTHELP, .T. ) == .F.
            IF Arg3 == .T.
               HMG_ChangeWindowStyle( hWnd, NIL, WS_MINIMIZEBOX, .F. )                                                                      // remove style
            ELSE
               HMG_ChangeWindowStyle( hWnd, WS_MINIMIZEBOX, NIL, .F. )                                                                      // add style
            ENDIF
         ENDIF
      ELSEIF Arg2 == HMG_UPPER( "NoSize" )
         IF Arg3 == .T.
            HMG_ChangeWindowStyle( hWnd, NIL, WS_SIZEBOX, .F. )       // remove style
         ELSE
            HMG_ChangeWindowStyle( hWnd, WS_SIZEBOX, NIL, .F. )       // add style
         ENDIF
      ELSEIF Arg2 == HMG_UPPER( "NoSysMenu" )
         IF Arg3 == .T.
            HMG_ChangeWindowStyle( hWnd, NIL, WS_SYSMENU, .F. )       // remove style
         ELSE
            HMG_ChangeWindowStyle( hWnd, WS_SYSMENU, NIL, .F. )       // add style
         ENDIF
      ELSEIF Arg2 == HMG_UPPER( "HScroll" )
         IF Arg3 == .T.
            HMG_ChangeWindowStyle( hWnd, WS_HSCROLL, NIL, .F. )       // add style
         ELSE
            HMG_ChangeWindowStyle( hWnd, NIL, WS_HSCROLL, .F. )       // remove style
         ENDIF
      ELSEIF Arg2 == HMG_UPPER( "VScroll" )
         IF Arg3 == .T.
            HMG_ChangeWindowStyle( hWnd, WS_VSCROLL, NIL, .F. )       // add style
         ELSE
            HMG_ChangeWindowStyle( hWnd, NIL, WS_VSCROLL, .F. )       // remove style
         ENDIF
      ELSEIF Arg2 == HMG_UPPER( "Enabled" )
         IF Arg3 == .T.
            EnableWindow( hWnd )
         ELSE
            DisableWindow( hWnd )
         ENDIF

      ELSEIF Arg2 == HMG_UPPER( "AlphaBlendTransparent" )
         SetLayeredWindowAttributes( hWnd, 0, Arg3, LWA_ALPHA )       // nAlphaBlend = 0 to 255 (completely transparent = 0, opaque = 255)

      ELSEIF Arg2 == HMG_UPPER( "BackColorTransparent" )
         SetLayeredWindowAttributes( hWnd, RGB( Arg3[ 1 ], Arg3[ 2 ], Arg3[ 3 ] ), 0, LWA_COLORKEY )

      ENDIF

   ELSEIF PCOUNT() == 4                                               // CONTROL

      Arg3 := HMG_UPPER( ALLTRIM( Arg3 ) )

      FOR i := 1 TO HMG_LEN( _HMG_SYSDATA[ 61 ] )
         IF Arg3 == _HMG_SYSDATA[ 61 ] [ i ] [ 1 ]
            cMacro := _HMG_SYSDATA[ 61 ] [ i ] [ 2 ]
            &cMacro( Arg1, Arg2, Arg3, Arg4 )

            IF _HMG_SYSDATA[ 63 ] == .T.
               RETURN NIL
            ENDIF
         ENDIF
      NEXT i

      IF .NOT. _IsControlDefined( Arg2, Arg1 )
         MsgHMGError( "Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
      ENDIF

      IF Arg3 == 'VALUE'

         _SetValue( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'CHANGEFONTSIZE'                                 // ADD

         ChangeControlFontSize( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'FORMAT'                                         // cTimeFormat (TimePicker)

         IF HMG_IsUTF8( Arg4 )
            Arg4 := HMG_UNICODE_TO_ANSI( Arg4 )
         ENDIF

         IF DateTime_SetFormat( GetControlHandle( Arg2, Arg1 ), Arg4 ) == .F.
            IF GetControlType( Arg2, Arg1 ) == "DATEPICK"
               MsgHMGError( "DatePicker Control: " + Arg2 + " Of " + Arg1 + ": Invalid Date Format" )
            ELSE
               MsgHMGError( "TimePicker Control: " + Arg2 + " Of " + Arg1 + ": Invalid Time Format" )
            ENDIF
         ENDIF
         i := GetControlIndex( Arg2, Arg1 )
         _HMG_SYSDATA[ 9 ] [ i ] := Arg4

      ELSEIF Arg3 == 'ALLOWEDIT'

#ifdef COMPILEBROWSE

         _SetBrowseAllowEdit( Arg2, Arg1, Arg4 )

#endif

      ELSEIF Arg3 == 'RECNO'

         SetDataGridRecNo( GetControlIndex( Arg2, Arg1 ), Arg4 )

      ELSEIF Arg3 == 'ALLOWAPPEND'

#ifdef COMPILEBROWSE

         _SetBrowseAllowAppend( Arg2, Arg1, Arg4 )

#endif

      ELSEIF Arg3 == 'ALLOWDELETE'

#ifdef COMPILEBROWSE

         _SetBrowseAllowDelete( Arg2, Arg1, Arg4 )

#endif

      ELSEIF Arg3 == 'PICTURE'

         _SetPicture( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == "HBITMAP"

         BT_HMGSetImage( Arg1, Arg2, Arg4, .T. )                      // Assign hBitmap to the IMAGE control

      ELSEIF Arg3 == 'TOOLTIP'

         _SetTooltip( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'FONTNAME'

         _SetFontName( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'FONTSIZE'

         _SetFontSize( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'FONTBOLD'

         _SetFontBold( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'FONTITALIC'

         _SetFontItalic( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'FONTUNDERLINE'

         _SetFontUnderline( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'FONTSTRIKEOUT'

         _SetFontStrikeout( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'CAPTION'

         IF GetControlType( Arg2, Arg1 ) == 'TOOLBUTTON'

            k := GetControlIndex( Arg2, Arg1 )

            SetToolButtonCaption( _HMG_SYSDATA[ 26 ] [ k ], _HMG_SYSDATA[ 5 ] [ k ], Arg4 )

            _HMG_SYSDATA[ 33 ] [ k ] := Arg4

         ELSE

            SetWindowText( GetControlHandle( Arg2, Arg1 ), Arg4 )

         ENDIF

      ELSEIF Arg3 == 'DISPLAYVALUE'

         SetWindowText( GetControlHandle( Arg2, Arg1 ), Arg4 )

      ELSEIF Arg3 == 'ROW'

         _SetControlRow( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'COL'

         _SetControlCol( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'WIDTH'

         _SetControlWidth( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'HEIGHT'

         _SetControlHeight( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'VISIBLE'

         IIF( Arg4 == .t., _ShowControl( Arg2, Arg1 ), _HideControl( Arg2, Arg1 ) )

      ELSEIF Arg3 == 'ENABLED'

         IIF( Arg4 == .t., _EnableControl( Arg2, Arg1 ), _DisableControl( Arg2, Arg1 ) )

      ELSEIF Arg3 == 'CHECKED'

         IIF( Arg4 == .t., _CheckMenuItem( Arg2, Arg1 ), _UnCheckMenuItem( Arg2, Arg1 ) )

      ELSEIF Arg3 == 'RANGEMIN'

         _SetRangeMin( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'RANGEMAX'

         _SetRangeMax( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'REPEAT'

         IF Arg4 == .t.
            _SetPlayerRepeatOn( Arg2, Arg1 )
         ELSE
            _SetPlayerRepeatOff( Arg2, Arg1 )
         ENDIF

      ELSEIF Arg3 == 'SPEED'

         _SetPlayerSpeed( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'VOLUME'

         _SetPlayerVolume( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'ZOOM'

         _SetPlayerZoom( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'SEEK'                                           // ADD

         _SetPlayerSeek( Arg2, Arg1, Arg4 )                           // ADD

      ELSEIF Arg3 == 'POSITION'

         IF Arg4 == 0
            _SetPlayerPositionHome( Arg2, Arg1 )
         ELSEIF Arg4 == 1
            _SetPlayerPositionEnd( Arg2, Arg1 )
         ENDIF

      ELSEIF Arg3 == 'CARETPOS'

         _SetCaretPos( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'BACKCOLOR'

         _SetBackColor( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'FONTCOLOR'

         _SetFontColor( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'FORECOLOR'

         _SetFontColor( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'ADDRESS'

         _SetAddress( Arg2, Arg1, Arg4 )

#ifdef COMPILEBROWSE

      ELSEIF Arg3 == 'INPUTITEMS'

         _SetBrowseInputItems( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'DISPLAYITEMS'

         _SetBrowseDisplayItems( Arg2, Arg1, Arg4 )

#endif

      ELSEIF Arg3 == 'READONLY'

         IF GetControlType( Arg2, Arg1 ) == 'RADIOGROUP'

            _SetRadioGroupReadOnly( Arg2, Arg1, Arg4 )

         ELSE

            SetTextEditReadOnly( GetControlHandle( Arg2, Arg1 ), Arg4 )

         ENDIF

      ELSEIF Arg3 == 'ITEMCOUNT'

         ListView_SetItemCount( GetControlHandle( Arg2, Arg1 ), Arg4 )

      ENDIF

   ELSEIF PCOUNT() == 5                                               // CONTROL WITH ARGUMENT, TOOLBAR BUTTON OR
      // SPLITBOX CHILD CONTROL WITHOUT ARGUMENT

      Arg3 := HMG_UPPER( ALLTRIM( Arg3 ) )

      FOR i := 1 TO HMG_LEN( _HMG_SYSDATA[ 61 ] )
         IF Arg3 == _HMG_SYSDATA[ 61 ] [ i ] [ 1 ]
            cMacro := _HMG_SYSDATA[ 61 ] [ i ] [ 2 ]
            &cMacro( Arg1, Arg2, Arg3, Arg4, Arg5 )

            IF _HMG_SYSDATA[ 63 ] == .T.
               RETURN NIL
            ENDIF

         ENDIF

      NEXT i

      IF HMG_UPPER( ALLTRIM( Arg2 ) ) == 'SPLITBOX'

         IF _IsControlSplitBoxed( Arg3, Arg1 )
            SetProperty( Arg1, Arg3, Arg4, Arg5 )
            RETURN Nil
         ELSE
            MsgHMGError( 'Control Does Not Belong To Container' )
         ENDIF

      ENDIF

      IF Arg3 == 'CAPTION'

         IF .NOT. _IsControlDefined( Arg2, Arg1 )
            MsgHMGError( "Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
         ENDIF

         _SetMultiCaption( Arg2, Arg1, Arg4, Arg5 )

      ELSEIF Arg3 == 'HEADER'

         IF .NOT. _IsControlDefined( Arg2, Arg1 )
            MsgHMGError( "Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
         ENDIF

         _SetMultiCaption( Arg2, Arg1, Arg4, Arg5 )

      ELSEIF Arg3 == 'HEADERIMAGES'

         IF .NOT. _IsControlDefined( Arg2, Arg1 )
            MsgHMGError( "Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
         ENDIF

         _HMG_SetHeaderImages( Arg2, Arg1, Arg4, Arg5 )

      ELSEIF Arg3 == 'ITEM'

         IF .NOT. _IsControlDefined( Arg2, Arg1 )
            MsgHMGError( "Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
         ENDIF

         _SetItem( Arg2, Arg1, Arg4, Arg5 )

      ELSEIF Arg3 == 'ICONHANDLE'

         IF .NOT. _IsControlDefined( Arg2, Arg1 )
            MsgHMGError( "Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
         ENDIF

         _SetStatusIcon( Arg2, Arg1, Arg4, NIL, Arg5 )

      ELSEIF Arg3 == 'ICON'

         IF .NOT. _IsControlDefined( Arg2, Arg1 )
            MsgHMGError( "Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
         ENDIF

         _SetStatusIcon( Arg2, Arg1, Arg4, Arg5 )

      ELSE
         // If Property Not Matched Look For ToolBar Button

         IF GetControlType( Arg2, Arg1 ) == 'TOOLBAR'

            IF GetControlHandle( Arg2, Arg1 ) != GetControlContainerHandle( Arg3, Arg1 )
               MsgHMGError( 'Control Does Not Belong To Container' )
            ENDIF

            SetProperty( Arg1, Arg3, Arg4, Arg5 )
         ENDIF

      ENDIF

   ELSEIF PCOUNT() == 6                                               // TAB CHILD CONTROL,
      // SPLITBOX CHILD WITH 1 ARGUMENT
      // OR SPLITCHILD TOOLBAR BUTTON

      IF HMG_UPPER( ALLTRIM( Arg2 ) ) == 'SPLITBOX'

         IF _IsControlSplitBoxed( Arg3, Arg1 )
            SetProperty( Arg1, Arg3, Arg4, Arg5, Arg6 )
            RETURN Nil
         ELSE
            IF _IsControlDefined( Arg4, Arg1 )

               IF _IsControlSplitBoxed( Arg4, Arg1 )

                  SetProperty( Arg1, Arg3, Arg4, Arg5, Arg6 )
                  RETURN Nil

               ELSE
                  MsgHMGError( 'Control Does Not Belong To Container' )
               ENDIF
            ELSE
               MsgHMGError( 'Control Does Not Belong To Container' )
            ENDIF

         ENDIF

      ENDIF

      IF VALTYPE( Arg3 ) = 'C'

         Arg3 := HMG_UPPER( ALLTRIM( Arg3 ) )

         IF Arg3 == 'CELL'

            IF .NOT. _IsControlDefined( Arg2, Arg1 )
               MsgHMGError( "Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
            ENDIF

            // _HMG_SETGRIDCELLVALUE ( Arg2 , Arg1 , Arg4 , Arg5 , Arg6 )

            i := GetControlIndex( Arg2, Arg1 )
            IF HMG_LEN( _HMG_SYSDATA[ 14 ] [ i ] ) > 0 .AND. Arg5 == 1                                                                      // Image Array
               SetProperty( Arg1, Arg2, "ImageIndex", Arg4, Arg5, Arg6 )                                                                    // ADD October 2015
               RETURN Nil
            ENDIF

            _GridEx_SetCellValue( Arg2, Arg1, Arg4, Arg5, Arg6 )      // ADD February 2015
            RETURN Nil

         ENDIF

      ENDIF

      IF GetControlTabPage( Arg4, Arg2, Arg1 ) <> Arg3
         MsgHMGError( 'Control Does Not Belong To Container' )
      ENDIF

      SetProperty( Arg1, Arg4, Arg5, Arg6 )

   ELSEIF PCOUNT() == 7                                               // TAB CHILD CONTROL WITH 1 ARGUMENT OR
      // SPLITBOX WITH 2 ARGUMENTS

      IF HMG_UPPER( ALLTRIM( Arg2 ) ) == 'SPLITBOX'

         IF _IsControlSplitBoxed( Arg3, Arg1 )
            SetProperty( Arg1, Arg3, Arg4, Arg5, Arg6, Arg7 )
            RETURN Nil
         ELSE
            MsgHMGError( 'Control Does Not Belong To Container' )
         ENDIF

      ENDIF

      IF GetControlTabPage( Arg4, Arg2, Arg1 ) <> Arg3
         MsgHMGError( 'Control Does Not Belong To Container' )
      ENDIF

      SetProperty( Arg1, Arg4, Arg5, Arg6, Arg7 )

   ELSEIF PCOUNT() == 8                                               // TAB CHILD CONTROL WITH 2 ARGUMENTS

      IF HMG_UPPER( ALLTRIM( Arg2 ) ) == 'SPLITBOX'

         IF _IsControlSplitBoxed( Arg3, Arg1 )
            SetProperty( Arg1, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8 )
            RETURN Nil
         ELSE
            MsgHMGError( 'Control Does Not Belong To Container' )
         ENDIF

      ENDIF

      IF GetControlTabPage( Arg4, Arg2, Arg1 ) <> Arg3
         MsgHMGError( 'Control Does Not Belong To Container' )
      ENDIF

      SetProperty( Arg1, Arg4, Arg5, Arg6, Arg7, Arg8 )

   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function GetProperty()
*+
*+    Called from ( h_grid.prg )   1 - procedure _addgridcolumn()
*+                                   2 - procedure _hmg_gridinplaceeditok()
*+                ( h_gridex.prg )   1 - function _gridex_updatecellvalue()
*+                                   1 - procedure _gridex_checkboxallitems()
*+                                   3 - procedure _gridex_groupdeleteallitems()
*+                                   3 - function _gridex_groupgetallitemindex()
*+                                   1 - procedure _gridex_groupcheckboxallitems()
*+                ( h_controlmisc.prg )  14 - function inputwindow()
*+                                   1 - function _inputwindowok()
*+                                   1 - function _setcaretpos()
*+                                   1 - function _hmg_printer_preview_onpaint()
*+                                   1 - function getprinter()
*+                                  10 - function getproperty()
*+                ( h_tree.prg )   2 - function treeitemgetallvalue()
*+                                   1 - function treeitemgetfirstitemvalue()
*+                                   1 - function treeitemgetitemtext()
*+                                   1 - procedure treeitemsetdefaultallnodeflag()
*+                ( h_windows.prg )   2 - function printwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetProperty( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8 )

LOCAL xData, RetVal
LOCAL i, hWnd
LOCAL cMacro
LOCAL tRetVal

   IF _GridEx_GetProperty( @xData, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8 ) == .T.
      RETURN xData
   ENDIF

   IF _Tree_GetProperty( @xData, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8 ) == .T.
      RETURN xData
   ENDIF

   IF _RichEditBox_GetProperty( @xData, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8 ) == .T.
      RETURN xData
   ENDIF

   IF PCOUNT() == 2                                                   // WINDOW

      IF .NOT. _IsWindowDefined( Arg1 )
         MsgHMGError( "Window: " + Arg1 + " is not defined. Program terminated" )
      ENDIF

      Arg2 := HMG_UPPER( ALLTRIM( Arg2 ) )

      FOR i := 1 TO HMG_LEN( _HMG_SYSDATA[ 61 ] )                     // Custom Properties Procedures Array
         IF Arg2 == _HMG_SYSDATA[ 61 ] [ i ] [ 1 ]
            cMacro := _HMG_SYSDATA[ 61 ] [ i ] [ 3 ]
            tRetVal := &cMacro( Arg1, Arg2 )

            IF _HMG_SYSDATA[ 63 ] == .T.                              // User Component Process Flag
               RETURN tRetVal
            ENDIF

         ENDIF
      NEXT i
      hWnd := GetFormHandle( Arg1 )
      IF Arg2 == 'HANDLE'
         RetVal := GetFormHandle( Arg1 )

      ELSEIF Arg2 == 'INDEX'
         RetVal := GetFormIndex( Arg1 )

      ELSEIF Arg2 == HMG_UPPER( "IsMinimized" )
         RetVal := IsMinimized( hWnd )

      ELSEIF Arg2 == HMG_UPPER( "IsMaximized" )
         RetVal := IsMaximized( hWnd )

      ELSEIF Arg2 == HMG_UPPER( "ClientAreaWidth" )
         RetVal := GetClientAreaWidth( hWnd )

      ELSEIF Arg2 == HMG_UPPER( "ClientAreaHeight" )
         RetVal := GetClientAreaHeight( hWnd )

      ELSEIF Arg2 == HMG_UPPER( "NoClose" )
         RetVal := IF( HB_bitAND( GetMenuState( GetSystemMenu( hWnd ), SC_CLOSE ), MF_GRAYED ) == MF_GRAYED, .T., .F. )
      ELSEIF Arg2 == HMG_UPPER( "NoCaption" )
         RetVal := HMG_IsWindowStyle( hWnd, WS_CAPTION, .F. )
      ELSEIF Arg2 == HMG_UPPER( "NoMaximize" )
         RetVal := HMG_IsWindowStyle( hWnd, WS_MAXIMIZEBOX, .F. )
      ELSEIF Arg2 == HMG_UPPER( "NoMinimize" )
         RetVal := HMG_IsWindowStyle( hWnd, WS_MINIMIZEBOX, .F. )
      ELSEIF Arg2 == HMG_UPPER( "NoSize" )
         RetVal := HMG_IsWindowStyle( hWnd, WS_SIZEBOX, .F. )
      ELSEIF Arg2 == HMG_UPPER( "NoSysMenu" )
         RetVal := HMG_IsWindowStyle( hWnd, WS_SYSMENU, .F. )
      ELSEIF Arg2 == HMG_UPPER( "HScroll" )
         RetVal := HMG_IsWindowStyle( hWnd, WS_HSCROLL, .F. )
      ELSEIF Arg2 == HMG_UPPER( "VScroll" )
         RetVal := HMG_IsWindowStyle( hWnd, WS_VSCROLL, .F. )
      ELSEIF Arg2 == HMG_UPPER( "Enabled" )
         RetVal := IsWindowEnabled( hWnd )

      ELSEIF Arg2 == 'TITLE'

         RetVal := GetWindowText( GetFormHandle( Arg1 ) )

      ELSEIF Arg2 == 'FOCUSEDCONTROL'

         RetVal := _GetFocusedControl( Arg1 )

      ELSEIF Arg2 == 'NAME'

         RetVal := GetFormName( Arg1 )

      ELSEIF Arg2 == 'HEIGHT'

         // RetVal := GetWindowHeight ( GetFormHandle ( Arg1 ) )
         RetVal := _GetWindowSizePos( GetFormHandle( Arg1 ) ) [ 4 ]

      ELSEIF Arg2 == 'WIDTH'

         // RetVal := GetWindowWidth ( GetFormHandle ( Arg1 ) )
         RetVal := _GetWindowSizePos( GetFormHandle( Arg1 ) ) [ 3 ]

      ELSEIF Arg2 == 'COL'

         // RetVal := GetWindowCol ( GetFormHandle ( Arg1 ) )
         RetVal := _GetWindowSizePos( GetFormHandle( Arg1 ) ) [ 2 ]

      ELSEIF Arg2 == 'ROW'

         // RetVal := GetWindowRow ( GetFormHandle ( Arg1 ) )
         RetVal := _GetWindowSizePos( GetFormHandle( Arg1 ) ) [ 1 ]

      ELSEIF Arg2 == 'NOTIFYICON'

         RetVal := _GetNotifyIconName( Arg1 )

      ELSEIF Arg2 == 'NOTIFYTOOLTIP'

         RetVal := _GetNotifyIconTooltip( Arg1 )

      ENDIF

   ELSEIF PCOUNT() == 3                                               // CONTROL

      Arg3 := HMG_UPPER( ALLTRIM( Arg3 ) )

      FOR i := 1 TO HMG_LEN( _HMG_SYSDATA[ 61 ] )                     // Custom Properties Procedures Array
         IF Arg3 == _HMG_SYSDATA[ 61 ] [ i ] [ 1 ]
            cMacro := _HMG_SYSDATA[ 61 ] [ i ] [ 3 ]
            tRetVal := &cMacro( Arg1, Arg2, Arg3 )

            IF _HMG_SYSDATA[ 63 ] == .T.                              // User Component Process Flag
               RETURN tRetVal
            ENDIF

         ENDIF

      NEXT i

      IF ( HMG_UPPER( ALLTRIM( Arg2 ) ) == 'VSCROLLBAR' .OR. HMG_UPPER( ALLTRIM( Arg2 ) ) == 'HSCROLLBAR' )

         IF .NOT. _IsWindowDefined( Arg1 )
            MsgHMGError( "Window: " + Arg1 + " is not defined. Program terminated" )
         ENDIF

      ELSE

         IF .NOT. _IsControlDefined( Arg2, Arg1 )
            MsgHMGError( "Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
         ENDIF

      ENDIF

      IF Arg3 == 'HANDLE'

         RetVal := GetControlHandle( Arg2, Arg1 )

      ELSEIF Arg3 == 'INDEX'

         RetVal := GetControlIndex( Arg2, Arg1 )

      ELSEIF Arg3 == 'TYPE'

         RetVal := GetControlType( Arg2, Arg1 )

      ELSEIF Arg3 == HMG_UPPER( "GetTextLength" )

         RetVal := HMG_LEN( GetWindowText( GetControlHandle( Arg2, Arg1 ) ) )

      ELSEIF Arg3 == 'VALUE'

         RetVal := _GetValue( Arg2, Arg1 )

      ELSEIF Arg3 == 'FORMAT'

         i := GetControlIndex( Arg2, Arg1 )
         RetVal := _HMG_SYSDATA[ 9 ] [ i ]                            // cTimeFormat (TimePicker)

      ELSEIF Arg3 == 'RECNO'

         RetVal := GetDataGridRecno( GetControlIndex( Arg2, Arg1 ) )

      ELSEIF Arg3 == 'NAME'

         RetVal := GetControlName( Arg2, Arg1 )

      ELSEIF Arg3 == 'ALLOWEDIT'

#ifdef COMPILEBROWSE

         RetVal := _GetBrowseAllowEdit( Arg2, Arg1 )

#endif

      ELSEIF Arg3 == 'INPUTITEMS'

#ifdef COMPILEBROWSE

         RetVal := _GetBrowseInputItems( Arg2, Arg1 )

#endif

      ELSEIF Arg3 == 'DISPLAYITEMS'

#ifdef COMPILEBROWSE

         RetVal := _GetBrowseDisplayItems( Arg2, Arg1 )

#endif

      ELSEIF Arg3 == 'ALLOWAPPEND'

#ifdef COMPILEBROWSE

         RetVal := _GetBrowseAllowAppend( Arg2, Arg1 )

#endif

      ELSEIF Arg3 == 'ALLOWDELETE'

#ifdef COMPILEBROWSE

         RetVal := _GetBrowseAllowDelete( Arg2, Arg1 )

#endif

      ELSEIF Arg3 == 'PICTURE'

         RetVal := _GetPicture( Arg2, Arg1 )

      ELSEIF Arg3 == "HBITMAP"

         RetVal := BT_HMGGetImage( Arg1, Arg2 )                       // Gets the value of hBitmap from the IMAGE control

      ELSEIF Arg3 == 'TOOLTIP'

         RetVal := _GetTooltip( Arg2, Arg1 )

      ELSEIF Arg3 == 'FONTNAME'

         RetVal := _GetFontName( Arg2, Arg1 )

      ELSEIF Arg3 == 'FONTSIZE'

         RetVal := _GetFontSize( Arg2, Arg1 )

      ELSEIF Arg3 == 'FONTBOLD'

         RetVal := _GetFontBold( Arg2, Arg1 )

      ELSEIF Arg3 == 'FONTITALIC'

         RetVal := _GetFontItalic( Arg2, Arg1 )

      ELSEIF Arg3 == 'FONTUNDERLINE'

         RetVal := _GetFontUnderline( Arg2, Arg1 )

      ELSEIF Arg3 == 'FONTSTRIKEOUT'

         RetVal := _GetFontStrikeout( Arg2, Arg1 )

      ELSEIF Arg3 == 'CAPTION'

         RetVal := _GetCaption( Arg2, Arg1 )

      ELSEIF Arg3 == 'DISPLAYVALUE'

         RetVal := GetWindowText( GetControlHandle( Arg2, Arg1 ) )

      ELSEIF Arg3 == 'ROW'

         RetVal := _GetControlRow( Arg2, Arg1 )

      ELSEIF Arg3 == 'COL'

         RetVal := _GetControlCol( Arg2, Arg1 )

      ELSEIF Arg3 == 'WIDTH'

         RetVal := _GetControlWidth( Arg2, Arg1 )

      ELSEIF Arg3 == 'HEIGHT'

         RetVal := _GetControlHeight( Arg2, Arg1 )

      ELSEIF Arg3 == 'VISIBLE'

         RetVal := _IsControlVisible( Arg2, Arg1 )

      ELSEIF Arg3 == 'ENABLED'

         RetVal := _IsControlEnabled( Arg2, Arg1 )

      ELSEIF Arg3 == 'CHECKED'

         RetVal := _IsMenuItemChecked( Arg2, Arg1 )

      ELSEIF Arg3 == 'ITEMCOUNT'

         RetVal := _GetItemCount( Arg2, Arg1 )

      ELSEIF Arg3 == 'RANGEMIN'

         RetVal := _GetRangeMin( Arg2, Arg1 )

      ELSEIF Arg3 == 'RANGEMAX'

         RetVal := _GetRangeMax( Arg2, Arg1 )

      ELSEIF Arg3 == 'LENGTH'

         RetVal := _GetPlayerLength( Arg2, Arg1 )

      ELSEIF Arg3 == 'POSITION'

         RetVal := _GetPlayerPosition( Arg2, Arg1 )

      ELSEIF Arg3 == 'VOLUME'                                         // ADD
         RetVal := _GetPlayerVolume( Arg2, Arg1 )                     // ADD

      ELSEIF Arg3 == 'CARETPOS'

         RetVal := _GetCaretPos( Arg2, Arg1 )

      ELSEIF Arg3 == 'BACKCOLOR'

         RetVal := _GetBackColor( Arg2, Arg1 )

      ELSEIF Arg3 == 'FONTCOLOR'

         RetVal := _GetFontColor( Arg2, Arg1 )

      ELSEIF Arg3 == 'FORECOLOR'

         RetVal := _GetFontColor( Arg2, Arg1 )

      ELSEIF Arg3 == 'ADDRESS'

         RetVal := _GetAddress( Arg2, Arg1 )

      ELSEIF Arg3 == 'OBJECT'

         RetVal := _GetControlObject( Arg2, Arg1 )

      ELSEIF Arg3 == 'READONLY'

         IF GetControlType( Arg2, Arg1 ) == 'RADIOGROUP'

            RetVal := _GetRadioGroupReadOnly( Arg2, Arg1 )

         ELSE

#define ES_READONLY 0x0800
            RetVal := HMG_IsWindowStyle( GetControlHandle( Arg2, Arg1 ), ES_READONLY, .F. )                                                 // ADD July 2016

         ENDIF

      ENDIF

   ELSEIF PCOUNT() == 4                                               // CONTROL WITH ARGUMENT, TOOLBAR BUTTON
      // OR SPLITBOX CHILD WITHOUT ARGUMENT

      IF HMG_UPPER( ALLTRIM( Arg2 ) ) == 'SPLITBOX'

         IF _IsControlSplitBoxed( Arg3, Arg1 )
            RetVal := GetProperty( Arg1, Arg3, Arg4 )
         ELSE
            MsgHMGError( 'Control Does Not Belong To Container' )
         ENDIF

      ELSE

         Arg3 := HMG_UPPER( ALLTRIM( Arg3 ) )

         IF Arg3 == 'ITEM'

            IF .NOT. _IsControlDefined( Arg2, Arg1 )
               MsgHMGError( "Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
            ENDIF

            RetVal := _GetItem( Arg2, Arg1, Arg4 )

         ELSEIF Arg3 == 'CAPTION'

            IF .NOT. _IsControlDefined( Arg2, Arg1 )
               MsgHMGError( "Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
            ENDIF

            RetVal := _GetMultiCaption( Arg2, Arg1, Arg4 )

         ELSEIF Arg3 == 'HEADER'

            IF .NOT. _IsControlDefined( Arg2, Arg1 )
               MsgHMGError( "Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
            ENDIF

            RetVal := _GetMultiCaption( Arg2, Arg1, Arg4 )

         ELSEIF Arg3 == 'HEADERIMAGES'

            IF .NOT. _IsControlDefined( Arg2, Arg1 )
               MsgHMGError( "Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
            ENDIF

            RetVal := _HMG_GetHeaderImages( Arg2, Arg1, Arg4 )

         ELSE

            // If Property Not Matched Look For Contained Control
            // With No Arguments (ToolBar Button)

            IF GetControlType( Arg2, Arg1 ) == 'TOOLBAR'

               IF GetControlHandle( Arg2, Arg1 ) != GetControlContainerHandle( Arg3, Arg1 )
                  MsgHMGError( 'Control Does Not Belong To Container' )
               ENDIF

               RetVal := GetProperty( Arg1, Arg3, Arg4 )

            ENDIF

         ENDIF

      ENDIF

   ELSEIF PCOUNT() == 5                                               // TAB CHILD CONTROL (WITHOUT ARGUMENT)
      // OR SPLITBOX CHILD WITH ARGUMENT

      IF HMG_UPPER( ALLTRIM( Arg2 ) ) == 'SPLITBOX'

         IF _IsControlSplitBoxed( Arg3, Arg1 )
            RetVal := GetProperty( Arg1, Arg3, Arg4, Arg5 )
         ELSE
            IF _IsControlDefined( Arg4, Arg1 )

               IF _IsControlSplitBoxed( Arg4, Arg1 )

                  RetVal := GetProperty( Arg1, Arg3, Arg4, Arg5 )

               ELSE

                  MsgHMGError( 'Control Does Not Belong To Container' )

               ENDIF

            ELSE

               MsgHMGError( 'Control Does Not Belong To Container' )

            ENDIF

         ENDIF

      ELSE

         IF VALTYPE( Arg3 ) = 'C'

            Arg3 := HMG_UPPER( ALLTRIM( Arg3 ) )

            IF Arg3 == 'CELL'

               // Return ( _HMG_GETGRIDCELLVALUE ( Arg2 , Arg1 , Arg4 , Arg5 ) )

               i := GetControlIndex( Arg2, Arg1 )
               IF HMG_LEN( _HMG_SYSDATA[ 14 ] [ i ] ) > 0 .AND. Arg5 == 1                                                                   // Image Array
                  RETURN GetProperty( Arg1, Arg2, "ImageIndex", Arg4, Arg5 )                                                                // ADD October 2015
               ENDIF
               RETURN _GridEx_GetCellValue( Arg2, Arg1, Arg4, Arg5 )  // ADD February 2015
            ENDIF

         ENDIF

         IF GetControlTabPage( Arg4, Arg2, Arg1 ) <> Arg3
            MsgHMGError( 'Control Does Not Belong To Container' )
         ENDIF

         RetVal := GetProperty( Arg1, Arg4, Arg5 )

      ENDIF

   ELSEIF PCOUNT() == 6                                               // TAB CHILD CONTROL (WITH 1 ARGUMENT
      // OR SPLITBOX CHILD WITH 2 ARGUMENT

      IF HMG_UPPER( ALLTRIM( Arg2 ) ) == 'SPLITBOX'

         IF _IsControlSplitBoxed( Arg3, Arg1 )
            RetVal := GetProperty( Arg1, Arg3, Arg4, Arg5, Arg6 )
         ELSE
            MsgHMGError( 'Control Does Not Belong To Container' )
         ENDIF

      ELSE

         IF GetControlTabPage( Arg4, Arg2, Arg1 ) <> Arg3
            MsgHMGError( 'Control Does Not Belong To Container' )
         ENDIF

         RetVal := GetProperty( Arg1, Arg4, Arg5, Arg6 )

      ENDIF

   ELSEIF PCOUNT() == 7                                               // TAB CHILD CONTROL (WITH 2 ARGUMENT
      // OR SPLITBOX CHILD WITH 3 ARGUMENT

      IF HMG_UPPER( ALLTRIM( Arg2 ) ) == 'SPLITBOX'

         IF _IsControlSplitBoxed( Arg3, Arg1 )
            RetVal := GetProperty( Arg1, Arg3, Arg4, Arg5, Arg6, Arg7 )
         ELSE
            MsgHMGError( 'Control Does Not Belong To Container' )
         ENDIF

      ELSE

         IF GetControlTabPage( Arg4, Arg2, Arg1 ) <> Arg3
            MsgHMGError( 'Control Does Not Belong To Container' )
         ENDIF

         RetVal := GetProperty( Arg1, Arg4, Arg5, Arg6, Arg7 )

      ENDIF

   ENDIF
RETURN RetVal

*+--------------------------------------------------------------------
*+
*+    Function GetControlTabPage()
*+
*+    Called from ( h_controlmisc.prg )   3 - function setproperty()
*+                                   3 - function getproperty()
*+                                   5 - function domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetControlTabPage( cControlName, cTabName, cParentWindowName )

LOCAL r, c, j, a
LOCAL aPageMap
LOCAL niTab
LOCAL niControl
LOCAL xControlHandle
LOCAL nRetVal        := 0

   niTab := GetControlIndex( cTabName, cParentWindowName )
   niControl := GetControlIndex( cControlName, cParentWindowName )

   xControlHandle := _HMG_SYSDATA[ 3 ] [ niControl ]
   aPageMap := _HMG_SYSDATA[ 7 ] [ niTab ]

   FOR r = 1 TO HMG_LEN( aPageMap )

      FOR c = 1 TO HMG_LEN( aPageMap[ r ] )

         IF VALTYPE( aPageMap[ r ] [ c ] ) == 'N' ;
                     .AND. ;
                     VALTYPE( xControlHandle ) == 'N'

            IF aPageMap[ r ] [ c ] == xControlHandle

               nRetVal := r
               EXIT

            ENDIF

         ELSEIF VALTYPE( aPageMap[ r ] [ c ] ) == "A" ;
                            .AND. ;
                            VALTYPE( xControlHandle ) == "A"

            FOR j := 1 TO HMG_LEN( xControlHandle )

               a := ASCAN( aPageMap[ r ] [ c ], xControlHandle[ j ] )

               IF a <> 0
                  nRetVal := r
                  EXIT
               ENDIF

            NEXT j

            IF nRetVal <> 0
               EXIT
            ENDIF

         ELSEIF VALTYPE( aPageMap[ r ] [ c ] ) == "A" ;
                            .AND. ;
                            VALTYPE( xControlHandle ) == "N"

            a := ASCAN( aPageMap[ r ] [ c ], xControlHandle )

            IF a <> 0
               nRetVal := r
               EXIT
            ENDIF

         ENDIF

      NEXT c

      IF nRetVal <> 0
         EXIT
      ENDIF

   NEXT r
RETURN nRetVal

*+--------------------------------------------------------------------
*+
*+    Function DoMethod()
*+
*+    Called from ( h_gridex.prg )   1 - function _gridex_setcolumncontrol()
*+                                   1 - function _gridex_setcolumndisplayposition()
*+                                   1 - procedure _gridex_groupdeleteallitems()
*+                ( h_controlmisc.prg )   3 - function inputwindow()
*+                                   7 - function _hmg_printer_showpreview()
*+                                   1 - function _hmg_printer_spltchldmouseclick()
*+                                   1 - function _hmg_printer_processthumbnails()
*+                                   1 - function _hmg_printer_printpagesdo()
*+                                   2 - function getprinter()
*+                                   1 - function _hmg_printer_mousezoom()
*+                                   2 - function _hmg_printer_zoom()
*+                                  11 - function domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION DoMethod( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9 )

LOCAL i, hWnd
LOCAL cMacro, cControlType

   IF _GridEx_DoMethod( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9 ) == .T.
      RETURN Nil
   ENDIF

   IF _Tree_DoMethod( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9 ) == .T.
      RETURN Nil
   ENDIF

   IF _RichEditBox_DoMethod( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9 ) == .T.
      RETURN Nil
   ENDIF

   IF PCOUNT() == 2                                                   // Window

      Arg2 := HMG_UPPER( ALLTRIM( Arg2 ) )

      FOR i := 1 TO HMG_LEN( _HMG_SYSDATA[ 62 ] )

         IF Arg2 == _HMG_SYSDATA[ 62 ] [ i ] [ 1 ]

            cMacro := _HMG_SYSDATA[ 62 ] [ i ] [ 2 ]

            &cMacro( Arg1, Arg2 )

            IF _HMG_SYSDATA[ 63 ] == .T.
               RETURN NIL
            ENDIF

         ENDIF

      NEXT i

      IF VALTYPE( Arg1 ) == 'C'
         IF .NOT. _IsWindowDefined( Arg1 )
            MsgHMGError( "Window: " + Arg1 + " is not defined. Program terminated" )
         ENDIF
      ENDIF

      IF Arg2 == 'ACTIVATE'

         IF VALTYPE( Arg1 ) == 'A'
            _ActivateWindow( Arg1 )
         ELSE
            _ActivateWindow( { Arg1 } )
         ENDIF

      ELSEIF Arg2 == 'CENTER'

         _CenterWindow( Arg1 )

      ELSEIF Arg2 == 'REDRAW'

         RedrawWindow( GetFormHandle( Arg1 ) )

      ELSEIF Arg2 == HMG_UPPER( 'CenterDesktop' )

         _CenterWindow( Arg1, 1 )

      ELSEIF Arg2 == 'RELEASE'

         _ReleaseWindow( Arg1 )

      ELSEIF Arg2 == 'MAXIMIZE'

         _MaximizeWindow( Arg1 )

      ELSEIF Arg2 == 'MINIMIZE'

         _MinimizeWindow( Arg1 )

      ELSEIF Arg2 == 'RESTORE'

         _RestoreWindow( Arg1 )

      ELSEIF Arg2 == 'SHOW'

         _ShowWindow( Arg1 )

      ELSEIF Arg2 == 'HIDE'

         _HideWindow( Arg1 )

      ELSEIF Arg2 == 'SETFOCUS'

         i := GetFormIndex( Arg1 )

         IF i >= 1 .AND. i <= HMG_LEN( _HMG_SYSDATA[ 67 ] )

            IF _HMG_SYSDATA[ 68 ] [ i ] == .T.                        // _HMG_aFormActive
               setfocus( _HMG_SYSDATA[ 67 ] [ i ] )
            ENDIF

         ENDIF

      ELSEIF Arg2 == 'PRINT'

         PrintWindow( Arg1 )

      ELSEIF Arg2 == 'CAPTURE'

         SaveWindow( Arg1 )

      ENDIF

   ELSEIF PCOUNT() == 3                                               // CONTROL

      IF VALTYPE( Arg2 ) == "C" .AND. HMG_UPPER( Arg2 ) == HMG_UPPER( 'CenterIn' )
         _CenterWindow( Arg1, Arg3 )                                  //  ---> window center
         RETURN NIL
      ENDIF

      Arg3 := HMG_UPPER( ALLTRIM( Arg3 ) )

      FOR i := 1 TO HMG_LEN( _HMG_SYSDATA[ 62 ] )

         IF Arg3 == _HMG_SYSDATA[ 62 ] [ i ] [ 1 ]

            cMacro := _HMG_SYSDATA[ 62 ] [ i ] [ 2 ]

            &cMacro( Arg1, Arg2, Arg3 )

            IF _HMG_SYSDATA[ 63 ] == .T.
               RETURN NIL
            ENDIF

         ENDIF

      NEXT i

      IF .NOT. _IsControlDefined( Arg2, Arg1 )
         MsgHMGError( "Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
      ENDIF

      IF Arg3 == 'REFRESH'

         _Refresh( GetControlIndex( Arg2, Arg1 ) )

      ELSEIF Arg3 == 'REDRAW'

         _RedrawControl( Arg2, Arg1 )

      ELSEIF Arg3 == 'SAVE'

         _SaveData( Arg2, Arg1 )

      ELSEIF Arg3 == 'CLEARBUFFER'

         DataGridClearBuffer( GetControlIndex( Arg2, Arg1 ) )

      ELSEIF Arg3 == 'DISABLEUPDATE'

         cControlType := _HMG_SYSDATA[ 1 ] [ GetControlIndex( Arg2, Arg1 ) ]

         IF cControlType $ "COMBO,BROWSE,TREE,GRID"
            hWnd := GetControlHandle( Arg2, Arg1 )
            EnableWindowRedraw( hWnd, .F. )
         ENDIF

         IF cControlType == "GRID"
            _HMG_SYSDATA[ 40 ] [ GetControlIndex( Arg2, Arg1 ) ] [ 33 ] := .F.
         ENDIF

      ELSEIF Arg3 == 'ENABLEUPDATE'
         cControlType := _HMG_SYSDATA[ 1 ] [ GetControlIndex( Arg2, Arg1 ) ]

         IF cControlType $ "COMBO,BROWSE,TREE,GRID"
            hWnd := GetControlHandle( Arg2, Arg1 )
            EnableWindowRedraw( hWnd, .T. )
            RedrawWindow( hWnd )
         ENDIF

         IF cControlType == "GRID"
            _HMG_SYSDATA[ 40 ] [ GetControlIndex( Arg2, Arg1 ) ] [ 33 ] := .T.
         ENDIF

      ELSEIF Arg3 == 'APPEND'

         DataGridAppend( GetControlIndex( Arg2, Arg1 ) )

      ELSEIF Arg3 == 'DELETE'

         DataGridDelete( GetControlIndex( Arg2, Arg1 ) )

      ELSEIF Arg3 == 'RECALL'

         DataGridRecall( GetControlIndex( Arg2, Arg1 ) )

      ELSEIF Arg3 == 'SETFOCUS'

         _SetFocus( Arg2, Arg1 )

      ELSEIF Arg3 == 'ACTION'

         EVAL( _GetControlAction( Arg2, Arg1 ) )

      ELSEIF Arg3 == 'ONCLICK'

         EVAL( _GetControlAction( Arg2, Arg1 ) )

      ELSEIF Arg3 == 'DELETEALLITEMS'

         _DeleteAllItems( Arg2, Arg1 )

      ELSEIF Arg3 == 'RELEASE'

         _ReleaseControl( Arg2, Arg1 )

      ELSEIF Arg3 == 'SHOW'

         _ShowControl( Arg2, Arg1 )

      ELSEIF Arg3 == 'HIDE'

         _HideControl( Arg2, Arg1 )

      ELSEIF Arg3 == 'PLAY'

         IIF( GetControlType( Arg2, Arg1 ) == "ANIMATEBOX", _PlayAnimateBox( Arg2, Arg1 ), _PlayPlayer( Arg2, Arg1 ) )

      ELSEIF Arg3 == 'STOP'

         IIF( GetControlType( Arg2, Arg1 ) == "ANIMATEBOX", _StopAnimateBox( Arg2, Arg1 ), _StopPlayer( Arg2, Arg1 ) )

      ELSEIF Arg3 == 'CLOSE'

         IIF( GetControlType( Arg2, Arg1 ) == "ANIMATEBOX", _CloseAnimateBox( Arg2, Arg1 ), _ClosePlayer( Arg2, Arg1 ) )

      ELSEIF Arg3 == 'PLAYREVERSE'

         _PlayPlayerReverse( Arg2, Arg1 )

      ELSEIF Arg3 == 'PAUSE'

         _PausePlayer( Arg2, Arg1 )

      ELSEIF Arg3 == 'EJECT'

         _EjectPlayer( Arg2, Arg1 )

      ELSEIF Arg3 == 'OPENDIALOG'

         _OpenPlayerDialog( Arg2, Arg1 )

      ELSEIF Arg3 == 'RESUME'

         _ResumePlayer( Arg2, Arg1 )

      ENDIF

   ELSEIF PCOUNT() == 4                                               // CONTROL WITH 1 ARGUMENT
      // OR SPLITBOX CHILD WITHOUT ARGUMENT

      Arg3 := HMG_UPPER( ALLTRIM( Arg3 ) )

      FOR i := 1 TO HMG_LEN( _HMG_SYSDATA[ 62 ] )

         IF Arg3 == _HMG_SYSDATA[ 62 ] [ i ] [ 1 ]

            cMacro := _HMG_SYSDATA[ 62 ] [ i ] [ 2 ]
            &cMacro( Arg1, Arg2, Arg3, Arg4 )

            IF _HMG_SYSDATA[ 63 ] == .T.
               RETURN NIL
            ENDIF

         ENDIF

      NEXT i

      IF HMG_UPPER( ALLTRIM( Arg2 ) ) == 'SPLITBOX'
         IF _IsControlSplitBoxed( Arg3, Arg1 )
            DoMethod( Arg1, Arg3, Arg4 )
            RETURN Nil
         ELSE
            MsgHMGError( 'Control Does Not Belong To Container' )
         ENDIF
      ENDIF

      IF .NOT. _IsControlDefined( Arg2, Arg1 )
         MsgHMGError( "Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
      ENDIF

      IF Arg3 == 'DELETEITEM'

         _DeleteItem( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'DELETEPAGE'

         _DeleteTabPage( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'REFRESH'

         DataGridRefresh( GetControlIndex( Arg2, Arg1 ), Arg4 )

      ELSEIF Arg3 == 'OPEN'

         IIF( GetControlType( Arg2, Arg1 ) == "ANIMATEBOX", _OpenAnimateBox( Arg2, Arg1, Arg4 ), _OpenPlayer( Arg2, Arg1, Arg4 ) )

      ELSEIF Arg3 == 'SEEK'

         _SeekAnimateBox( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'ADDITEM'

         _AddItem( Arg2, Arg1, Arg4 )

      ELSEIF Arg3 == 'EXPAND'

         _Expand( Arg2, Arg1, Arg4, NIL )                             // Tree

      ELSEIF Arg3 == 'COLLAPSE'

         _Collapse( Arg2, Arg1, Arg4, NIL )                           // Tree

      ELSEIF Arg3 == 'DELETECOLUMN'

         _DeleteGridColumn( Arg2, Arg1, Arg4 )

      ENDIF

   ELSEIF PCOUNT() == 5 .AND. VALTYPE( Arg3 ) == 'C'

      // CONTROL WITH 2 ARGUMENTS
      //  OR SPLITBOX CHILD WITH 1 ARGUMENT

      Arg3 := HMG_UPPER( ALLTRIM( Arg3 ) )

      FOR i := 1 TO HMG_LEN( _HMG_SYSDATA[ 62 ] )

         IF Arg3 == _HMG_SYSDATA[ 62 ] [ i ] [ 1 ]

            cMacro := _HMG_SYSDATA[ 62 ] [ i ] [ 2 ]
            &cMacro( Arg1, Arg2, Arg3, Arg4, Arg5 )

            IF _HMG_SYSDATA[ 63 ] == .T.
               RETURN NIL
            ENDIF

         ENDIF

      NEXT i

      IF HMG_UPPER( ALLTRIM( Arg2 ) ) == 'SPLITBOX'
         IF _IsControlSplitBoxed( Arg3, Arg1 )
            DoMethod( Arg1, Arg3, Arg4, Arg5 )
            RETURN Nil
         ELSE
            MsgHMGError( 'Control Does Not Belong To Container' )
         ENDIF
      ENDIF

      IF .NOT. _IsControlDefined( Arg2, Arg1 )
         MsgHMGError( "Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
      ENDIF

      IF Arg3 == 'ADDITEM'

         _AddItem( Arg2, Arg1, Arg4, Arg5 )

      ELSEIF Arg3 == 'ADDPAGE'

         _AddTabPage( Arg2, Arg1, Arg4, Arg5 )

      ELSEIF Arg3 == 'EXPAND'

         _Expand( Arg2, Arg1, Arg4, Arg5 )                            // Tree

      ELSEIF Arg3 == 'COLLAPSE'

         _Collapse( Arg2, Arg1, Arg4, Arg5 )                          // Tree

      ENDIF

   ELSEIF PCOUNT() = 5 .AND. VALTYPE( Arg3 ) == 'N'

      // TAB CHILD WITHOUT ARGUMENTS

      IF GetControlTabPage( Arg4, Arg2, Arg1 ) <> Arg3
         MsgHMGError( 'Control Does Not Belong To Container' )
      ENDIF

      DoMethod( Arg1, Arg4, Arg5 )

   ELSEIF PCOUNT() == 6 .AND. VALTYPE( Arg3 ) == 'C'

      // CONTROL WITH 3 ARGUMENTS
      // OR SPLITBOX CHILD WITH 2 ARGUMENTS

      Arg3 := HMG_UPPER( ALLTRIM( Arg3 ) )

      FOR i := 1 TO HMG_LEN( _HMG_SYSDATA[ 62 ] )

         IF Arg3 == _HMG_SYSDATA[ 62 ] [ i ] [ 1 ]

            cMacro := _HMG_SYSDATA[ 62 ] [ i ] [ 2 ]
            &cMacro( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6 )

            IF _HMG_SYSDATA[ 63 ] == .T.
               RETURN NIL
            ENDIF

         ENDIF

      NEXT i

      IF HMG_UPPER( ALLTRIM( Arg2 ) ) == 'SPLITBOX'

         IF _IsControlSplitBoxed( Arg3, Arg1 )
            DoMethod( Arg1, Arg3, Arg4, Arg5, Arg6 )
            RETURN Nil
         ELSE
            MsgHMGError( 'Control Does Not Belong To Container' )
         ENDIF

      ENDIF

      IF .NOT. _IsControlDefined( Arg2, Arg1 )
         MsgHMGError( "Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
      ENDIF

      IF Arg3 == 'ADDITEM'

         _AddItem( Arg2, Arg1, Arg4, Arg5, Arg6 )

      ELSEIF Arg3 == 'ADDPAGE'

         _AddTabPage( Arg2, Arg1, Arg4, Arg5, Arg6 )

      ENDIF

   ELSEIF PCOUNT() == 6 .AND. VALTYPE( Arg3 ) == 'N'
      // TAB CHILD WITH 1 ARGUMENT

      IF GetControlTabPage( Arg4, Arg2, Arg1 ) <> Arg3
         MsgHMGError( 'Control Does Not Belong To Container' )
      ENDIF

      DoMethod( Arg1, Arg4, Arg5, Arg6 )

   ELSEIF PCOUNT() == 7 .AND. HMG_UPPER( ALLTRIM( Arg2 ) ) == 'CAPTURE'

      SaveWindow( Arg1, Arg3, Arg4, Arg5, Arg6, Arg7 )

   ELSEIF PCOUNT() == 7 .AND. VALTYPE( Arg3 ) == 'C'

      // CONTROL WITH 4 ARGUMENTS
      // OR SPLITBOX CHILD WITH 3 ARGUMENTS

      Arg3 := HMG_UPPER( ALLTRIM( Arg3 ) )

      FOR i := 1 TO HMG_LEN( _HMG_SYSDATA[ 62 ] )

         IF Arg3 == _HMG_SYSDATA[ 62 ] [ i ] [ 1 ]

            cMacro := _HMG_SYSDATA[ 62 ] [ i ] [ 2 ]
            &cMacro( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7 )

            IF _HMG_SYSDATA[ 63 ] == .T.
               RETURN NIL
            ENDIF

         ENDIF

      NEXT i

      IF HMG_UPPER( ALLTRIM( Arg2 ) ) == 'SPLITBOX'

         IF _IsControlSplitBoxed( Arg3, Arg1 )
            DoMethod( Arg1, Arg3, Arg4, Arg5, Arg6, Arg7 )
            RETURN Nil
         ELSE
            MsgHMGError( 'Control Does Not Belong To Container' )
         ENDIF

      ENDIF

      IF .NOT. _IsControlDefined( Arg2, Arg1 )
         MsgHMGError( "Control: " + Arg2 + " Of " + Arg1 + " Not defined. Program Terminated" )
      ENDIF

      IF Arg3 == 'ADDCONTROL'

         _AddTabControl( Arg2, Arg4, Arg1, Arg5, Arg6, Arg7 )

      ELSEIF Arg3 == 'ADDCOLUMN'

         _AddGridColumn( Arg2, Arg1, Arg4, Arg5, Arg6, Arg7 )

      ELSEIF Arg3 == 'ADDITEM'

         _AddItem( Arg2, Arg1, Arg4, Arg5, Arg6, Arg7 )

      ENDIF

   ELSEIF PCOUNT() == 7 .AND. VALTYPE( Arg3 ) == 'N'

      // TAB CHILD WITH 2 ARGUMENTS

      IF GetControlTabPage( Arg4, Arg2, Arg1 ) <> Arg3
         MsgHMGError( 'Control Does Not Belong To Container' )
      ENDIF

      DoMethod( Arg1, Arg4, Arg5, Arg6, Arg7 )

   ELSEIF PCOUNT() == 8

      // TAB CHILD WITH 3 ARGUMENTS
      // OR SPLITBOX CHILD WITH 4 ARGUMENTS

      IF HMG_UPPER( ALLTRIM( Arg2 ) ) == 'SPLITBOX'

         IF _IsControlSplitBoxed( Arg3, Arg1 )
            DoMethod( Arg1, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8 )
            RETURN Nil
         ELSE
            MsgHMGError( 'Control Does Not Belong To Container' )
         ENDIF

      ENDIF

      IF VALTYPE( Arg3 ) == 'N'

         IF GetControlTabPage( Arg4, Arg2, Arg1 ) <> Arg3
            MsgHMGError( 'Control Does Not Belong To Container' )
         ENDIF

         DoMethod( Arg1, Arg4, Arg5, Arg6, Arg7, Arg8 )

      ENDIF

   ELSEIF PCOUNT() == 9
      // TAB CHILD WITH 4 ARGUMENTS
      // OR SPLITBOX CHILD WITH 5 ARGUMENTS

      IF HMG_UPPER( ALLTRIM( Arg2 ) ) == 'SPLITBOX'

         IF _IsControlSplitBoxed( Arg3, Arg1 )
            DoMethod( Arg1, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9 )
            RETURN Nil
         ELSE
            MsgHMGError( 'Control Does Not Belong To Container' )
         ENDIF

      ENDIF

      IF VALTYPE( Arg3 ) == 'N'

         IF GetControlTabPage( Arg4, Arg2, Arg1 ) <> Arg3
            MsgHMGError( 'Control Does Not Belong To Container' )
         ENDIF

         DoMethod( Arg1, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9 )

      ENDIF

   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _IsControlSplitBoxed()
*+
*+    Called from ( h_controlmisc.prg )   5 - function setproperty()
*+                                   5 - function getproperty()
*+                                   6 - function domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _IsControlSplitBoxed( cControlName, cWindowName )

LOCAL lSplitBoxed := .F.
LOCAL i

   i := GetControlIndex( cControlName, cWindowName )

   IF i > 0

      IF VALTYPE( _HMG_SYSDATA[ 18 ] [ i ] ) == 'U' ;
                  .AND. ;
                  VALTYPE( _HMG_SYSDATA[ 19 ] [ i ] ) == 'U' ;

         lSplitBoxed := .T.

      ENDIF

   ENDIF
RETURN lSplitBoxed

*+--------------------------------------------------------------------
*+
*+    Function _IsWindowVisibleFromHandle()
*+
*+    Called from ( h_tab.prg )   1 - function updatetab()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _IsWindowVisibleFromHandle( Handle )

LOCAL x
LOCAL lVisible := .f.

   FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 67 ] )

      IF _HMG_SYSDATA[ 67 ] [ x ] == Handle
         lVisible := .NOT. _HMG_SYSDATA[ 81 ] [ x ]
         EXIT

      ENDIF

   NEXT x
RETURN lVisible

*+--------------------------------------------------------------------
*+
*+    Function GetFocusedControlType()
*+
*+    Called from ( h_windows.prg )   1 - function events()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetFocusedControlType()

LOCAL nHandle
LOCAL cType
LOCAL i

   cType := ''

   nHandle := GetFocus()

   FOR i := 1 TO HMG_LEN( _HMG_SYSDATA[ 3 ] )

      IF VALTYPE( _HMG_SYSDATA[ 3 ] [ i ] ) == 'N'

         IF _HMG_SYSDATA[ 3 ] [ i ] == nHandle

            cType := _HMG_SYSDATA[ 1 ] [ i ]

         ENDIF

      ENDIF

   NEXT i
RETURN cType

//*********************************************
// by Dr. Claudio Soto (April 2013)
//*********************************************

*+--------------------------------------------------------------------
*+
*+    Function _GridEx_GetProperty()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GridEx_GetProperty( xData, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8 )

LOCAL i, RetVal := .F.
LOCAL cHeader, nAlignHeader, cFooter, nAlingFooter, nState

   IF ( VALTYPE( Arg1 ) <> "C" ) .OR. ( VALTYPE( Arg2 ) <> "C" ) .OR. ( VALTYPE( Arg3 ) <> "C" ) .OR. ( _IsControlDefined( Arg2, Arg1 ) == .F. ) .OR. ( ( GetControlType( Arg2, Arg1 ) <> "GRID" ) .AND. ( GetControlType( Arg2, Arg1 ) <> "MULTIGRID" ) )
      RETURN .F.
   ENDIF

   // Parameters NOT used
   HB_SYMBOL_UNUSED( Arg6 )
   HB_SYMBOL_UNUSED( Arg7 )
   HB_SYMBOL_UNUSED( Arg8 )

   i := GetControlIndex( Arg2, Arg1 )

   Arg3 := HMG_UPPER( ALLTRIM( Arg3 ) )

   DO CASE
      CASE Arg3 == 'COLUMNCOUNT'
         xData := _GridEx_ColumnCount( Arg2, Arg1 )
         RetVal := .T.

      CASE Arg3 == 'COLUMNHEADER'
         xData := _GridEx_GetColumnControl( Arg2, Arg1, _GRID_COLUMN_HEADER_, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'COLUMNWIDTH'
         xData := _GridEx_GetColumnControl( Arg2, Arg1, _GRID_COLUMN_WIDTH_, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'COLUMNJUSTIFY'
         xData := _GridEx_GetColumnControl( Arg2, Arg1, _GRID_COLUMN_JUSTIFY_, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'COLUMNCONTROL'
         xData := _GridEx_GetColumnControl( Arg2, Arg1, _GRID_COLUMN_CONTROL_, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'COLUMNDYNAMICBACKCOLOR'
         xData := _GridEx_GetColumnControl( Arg2, Arg1, _GRID_COLUMN_DYNAMICBACKCOLOR_, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'COLUMNDYNAMICFORECOLOR'
         xData := _GridEx_GetColumnControl( Arg2, Arg1, _GRID_COLUMN_DYNAMICFORECOLOR_, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'COLUMNDYNAMICFONT'
         xData := _GridEx_GetColumnControl( Arg2, Arg1, _GRID_COLUMN_DYNAMICFONT_, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'HEADERDYNAMICFONT'
         xData := _GridEx_GetColumnControl( Arg2, Arg1, _GRID_COLUMN_HEADERFONT_, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'HEADERDYNAMICBACKCOLOR'
         xData := _GridEx_GetColumnControl( Arg2, Arg1, _GRID_COLUMN_HEADERBACKCOLOR_, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'HEADERDYNAMICFORECOLOR'
         xData := _GridEx_GetColumnControl( Arg2, Arg1, _GRID_COLUMN_HEADERFORECOLOR_, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'COLUMNVALID'
         xData := _GridEx_GetColumnControl( Arg2, Arg1, _GRID_COLUMN_VALID_, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'COLUMNWHEN'
         xData := _GridEx_GetColumnControl( Arg2, Arg1, _GRID_COLUMN_WHEN_, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'COLUMNONHEADCLICK'
         xData := _GridEx_GetColumnControl( Arg2, Arg1, _GRID_COLUMN_ONHEADCLICK_, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'COLUMNDISPLAYPOSITION'
         xData := _GridEx_GetColumnDisplayPosition( Arg2, Arg1, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'CELLEX'
         xData := _GridEx_GetCellValue( Arg2, Arg1, Arg4, Arg5 )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'CellRowFocused' )
         IF _HMG_SYSDATA[ 32 ] [ i ] == .T.                           // CellNavigation == .T.
            xData := _HMG_SYSDATA[ 39 ] [ i ]                         // nRow of the selected cell
         ELSE
            xData := LISTVIEW_GETFOCUSEDITEM( GetControlHandleByIndex( i ) )
         ENDIF
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'CellColFocused' )
         IF _HMG_SYSDATA[ 32 ] [ i ] == .T.                           // CellNavigation == .T.
            xData := _HMG_SYSDATA[ 15 ] [ i ]                         // nCol of the selected cell
         ELSE
            xData := 0
         ENDIF
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'CellNavigation' )
         xData := _HMG_SYSDATA[ 32 ] [ i ]                            // CellNavigation == .T. or .F.
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'CellRowClicked' )
         xData := _HMG_SYSDATA[ 40 ] [ i ] [ 37 ] [ 1 ]
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'CellColClicked' )
         xData := _HMG_SYSDATA[ 40 ] [ i ] [ 37 ] [ 2 ]
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'EditOption' )
         xData := _HMG_SYSDATA[ 40 ] [ i ] [ 38 ]
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'ImageList' )
         xData := ListView_GetImageList( GetControlHandle( Arg2, Arg1 ), LVSIL_SMALL )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'ImageIndex' )
         xData := ListView_GetItemImageIndex( GetControlHandle( Arg2, Arg1 ), ( Arg4 - 1 ), ( Arg5 - 1 ) )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'HeaderImageIndex' )
         xData := ListView_GetHeaderImageIndex( GetControlHandle( Arg2, Arg1 ), ( Arg4 - 1 ) )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'PaintDoubleBuffer' )
         xData := ListView_GetExtendedStyle( GetControlHandle( Arg2, Arg1 ), LVS_EX_DOUBLEBUFFER )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'CheckBoxEnabled' )
         xData := ListView_GetExtendedStyle( GetControlHandle( Arg2, Arg1 ), LVS_EX_CHECKBOXES )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'CheckBoxItem' )
         xData := ListView_GetCheckState( GetControlHandle( Arg2, Arg1 ), ( Arg4 - 1 ) )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'GroupEnabled' )
         xData := ListView_IsGroupViewEnabled( GetControlHandle( Arg2, Arg1 ) )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'GroupInfo' )
         cHeader := nAlignHeader := cFooter := nAlingFooter := nState := NIL
         ListView_GroupGetInfo( GetControlHandle( Arg2, Arg1 ), Arg4, @cHeader, @nAlignHeader, @cFooter, @nAlingFooter, @nState )
         xData := { cHeader, nAlignHeader, cFooter, nAlingFooter, nState }
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'GroupItemID' )
         xData := ListView_GroupItemGetID( GetControlHandle( Arg2, Arg1 ), ( Arg4 - 1 ) )
         RetVal := .T.
      CASE Arg3 == HMG_UPPER( 'GroupExist' )
         xData := ListView_HasGroup( GetControlHandle( Arg2, Arg1 ), Arg4 )
         RetVal := .T.
      CASE Arg3 == HMG_UPPER( 'GroupGetAllItemIndex' )
         xData := _GridEx_GroupGetAllItemIndex( Arg2, Arg1, Arg4 )
         RetVal := .T.
   ENDCASE
RETURN RetVal

*+--------------------------------------------------------------------
*+
*+    Function _GridEx_SetProperty()
*+
*+    Called from ( h_controlmisc.prg )   1 - function setproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GridEx_SetProperty( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8 )

LOCAL i, hImageList, RetVal := .F.

   IF ( VALTYPE( Arg1 ) <> "C" ) .OR. ( VALTYPE( Arg2 ) <> "C" ) .OR. ( VALTYPE( Arg3 ) <> "C" ) .OR. ( _IsControlDefined( Arg2, Arg1 ) == .F. ) .OR. ( ( GetControlType( Arg2, Arg1 ) <> "GRID" ) .AND. ( GetControlType( Arg2, Arg1 ) <> "MULTIGRID" ) )
      RETURN .F.
   ENDIF

   // Parameters NOT used
   HB_SYMBOL_UNUSED( Arg8 )

   i := GetControlIndex( Arg2, Arg1 )

   Arg3 := HMG_UPPER( ALLTRIM( Arg3 ) )

   DO CASE
      CASE Arg3 == 'COLUMNHEADER'
         _GridEx_SetColumnControl( Arg2, Arg1, _GRID_COLUMN_HEADER_, Arg4, Arg5 )
         RetVal := .T.

      CASE Arg3 == 'COLUMNWIDTH'
         _GridEx_SetColumnControl( Arg2, Arg1, _GRID_COLUMN_WIDTH_, Arg4, Arg5 )
         RetVal := .T.

      CASE Arg3 == 'COLUMNJUSTIFY'
         _GridEx_SetColumnControl( Arg2, Arg1, _GRID_COLUMN_JUSTIFY_, Arg4, Arg5 )
         RetVal := .T.

      CASE Arg3 == 'COLUMNCONTROL'
         _GridEx_SetColumnControl( Arg2, Arg1, _GRID_COLUMN_CONTROL_, Arg4, Arg5 )
         RetVal := .T.

      CASE Arg3 == 'COLUMNDYNAMICBACKCOLOR'
         _GridEx_SetColumnControl( Arg2, Arg1, _GRID_COLUMN_DYNAMICBACKCOLOR_, Arg4, Arg5 )
         RetVal := .T.

      CASE Arg3 == 'COLUMNDYNAMICFORECOLOR'
         _GridEx_SetColumnControl( Arg2, Arg1, _GRID_COLUMN_DYNAMICFORECOLOR_, Arg4, Arg5 )
         RetVal := .T.

      CASE Arg3 == 'COLUMNDYNAMICFONT'
         _GridEx_SetColumnControl( Arg2, Arg1, _GRID_COLUMN_DYNAMICFONT_, Arg4, Arg5 )
         RetVal := .T.

      CASE Arg3 == 'HEADERDYNAMICFONT'
         _GridEx_SetColumnControl( Arg2, Arg1, _GRID_COLUMN_HEADERFONT_, Arg4, Arg5 )
         RetVal := .T.

      CASE Arg3 == 'HEADERDYNAMICBACKCOLOR'
         _GridEx_SetColumnControl( Arg2, Arg1, _GRID_COLUMN_HEADERBACKCOLOR_, Arg4, Arg5 )
         RetVal := .T.

      CASE Arg3 == 'HEADERDYNAMICFORECOLOR'
         _GridEx_SetColumnControl( Arg2, Arg1, _GRID_COLUMN_HEADERFORECOLOR_, Arg4, Arg5 )
         RetVal := .T.

      CASE Arg3 == 'COLUMNVALID'
         _GridEx_SetColumnControl( Arg2, Arg1, _GRID_COLUMN_VALID_, Arg4, Arg5 )
         RetVal := .T.

      CASE Arg3 == 'COLUMNWHEN'
         _GridEx_SetColumnControl( Arg2, Arg1, _GRID_COLUMN_WHEN_, Arg4, Arg5 )
         RetVal := .T.

      CASE Arg3 == 'COLUMNONHEADCLICK'
         _GridEx_SetColumnControl( Arg2, Arg1, _GRID_COLUMN_ONHEADCLICK_, Arg4, Arg5 )
         RetVal := .T.

      CASE Arg3 == 'COLUMNDISPLAYPOSITION'
         _GridEx_SetColumnDisplayPosition( Arg2, Arg1, Arg4, Arg5 )
         RetVal := .T.

      CASE Arg3 == 'CELLEX'
         _GridEx_SetCellValue( Arg2, Arg1, Arg4, Arg5, Arg6 )
         RetVal := .T.

      CASE Arg3 == 'BACKGROUNDIMAGE'
         _GridEx_SetBkImage( Arg2, Arg1, Arg4, Arg5, Arg6, Arg7 )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'CellNavigation' )
         IF VALTYPE( Arg4 ) == "L"
            _HMG_SYSDATA[ 32 ] [ i ] := Arg4                          // CellNavigation == .T. or .F.
            _HMG_SYSDATA[ 39 ] [ i ] := LISTVIEW_GETFOCUSEDITEM( GetControlHandle( Arg2, Arg1 ) )                                           // nRow of the selected cell
            RedrawWindow( GetControlHandle( Arg2, Arg1 ) )
         ENDIF
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'EditOption' )
         IF VALTYPE( Arg4 ) == "N"
            _HMG_SYSDATA[ 40 ] [ i ] [ 38 ] := Arg4
         ENDIF
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'ImageList' )
         ListView_SetImageList( GetControlHandle( Arg2, Arg1 ), Arg4, LVSIL_SMALL )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'ImageIndex' )
         ListView_SetItemImageIndex( GetControlHandle( Arg2, Arg1 ), ( Arg4 - 1 ), ( Arg5 - 1 ), Arg6 )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'HeaderImageIndex' )
         ListView_SetHeaderImageIndex( GetControlHandle( Arg2, Arg1 ), ( Arg4 - 1 ), Arg5 )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'Image' )
         hImageList := ListView_GetImageList( GetControlHandle( Arg2, Arg1 ), LVSIL_SMALL )
         IF hImageList <> 0
            ImageList_Destroy( hImageList )
         ENDIF
         IF VALTYPE( Arg4 ) <> "L"
            Arg4 := .T.
         ENDIF
         //   aImage   NoTransparent
         ADDLISTVIEWBITMAP( GetControlHandle( Arg2, Arg1 ), Arg5, .NOT. Arg4 )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'PaintDoubleBuffer' )
         IF Arg4 == .T.
            ListView_ChangeExtendedStyle( GetControlHandle( Arg2, Arg1 ), LVS_EX_DOUBLEBUFFER, NIL )
         ELSE
            ListView_ChangeExtendedStyle( GetControlHandle( Arg2, Arg1 ), NIL, LVS_EX_DOUBLEBUFFER )
         ENDIF
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'CheckBoxEnabled' )
         IF Arg4 == .T.
            ListView_ChangeExtendedStyle( GetControlHandle( Arg2, Arg1 ), LVS_EX_CHECKBOXES, NIL )                                          // Add
         ELSE
            ListView_ChangeExtendedStyle( GetControlHandle( Arg2, Arg1 ), NIL, LVS_EX_CHECKBOXES )                                          // Remove
         ENDIF
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'CheckBoxItem' )
         ListView_SetCheckState( GetControlHandle( Arg2, Arg1 ), ( Arg4 - 1 ), Arg5 )
         RetVal := .T.
      CASE Arg3 == HMG_UPPER( 'CheckBoxAllItems' )
         _GridEx_CheckBoxAllItems( Arg2, Arg1, Arg4 )
         RetVal := .T.
      CASE Arg3 == HMG_UPPER( 'GroupEnabled' )
         IF HMG_IsRunAppInWin32() == .F.                              // GridGroup only work on Windows 64-bits
            ListView_EnableGroupView( GetControlHandle( Arg2, Arg1 ), Arg4 )
         ELSE                                                         // MsgHMGError ("Grid Group is not available when application is running on Windows versions of 32-bits. Program terminated")
         ENDIF
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'GroupInfo' )
         ASIZE( Arg5, 5 )
         ListView_GroupSetInfo( GetControlHandle( Arg2, Arg1 ), Arg4, Arg5[ 1 ], Arg5[ 2 ], Arg5[ 3 ], Arg5[ 4 ], Arg5[ 5 ] )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'GroupItemID' )
         ListView_GroupItemSetID( GetControlHandle( Arg2, Arg1 ), ( Arg4 - 1 ), Arg5 )
         RetVal := .T.
      CASE Arg3 == HMG_UPPER( 'GroupCheckBoxAllItems' )
         _GridEx_GroupCheckBoxAllItems( Arg2, Arg1, Arg4, Arg5 )
         RetVal := .T.
   ENDCASE
RETURN RetVal

*+--------------------------------------------------------------------
*+
*+    Function _GridEx_DoMethod()
*+
*+    Called from ( h_controlmisc.prg )   1 - function domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GridEx_DoMethod( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9 )

LOCAL RetVal := .F.

   IF ( VALTYPE( Arg1 ) <> "C" ) .OR. ( VALTYPE( Arg2 ) <> "C" ) .OR. ( VALTYPE( Arg3 ) <> "C" ) .OR. ( _IsControlDefined( Arg2, Arg1 ) == .F. ) .OR. ( ( GetControlType( Arg2, Arg1 ) <> "GRID" ) .AND. ( GetControlType( Arg2, Arg1 ) <> "MULTIGRID" ) )
      RETURN .F.
   ENDIF

   // Parameters NOT used
   HB_SYMBOL_UNUSED( Arg9 )

   Arg3 := HMG_UPPER( ALLTRIM( Arg3 ) )

   DO CASE
      CASE Arg3 == 'ADDCOLUMNEX'
         _AddGridColumn( Arg2, Arg1, Arg4, Arg5, Arg6, Arg7, Arg8 )
         RetVal := .T.

      CASE Arg3 == 'ADDITEMEX'
         IF _HMG_SYSDATA[ 40 ] [ GetControlIndex( Arg2, Arg1 ) ] [ 9 ] == .F.
            _AddGridRow( Arg2, Arg1, Arg4, Arg5 )
         ENDIF
         RetVal := .T.
      CASE Arg3 == HMG_UPPER( 'GroupDeleteAll' )
         ListView_GroupDeleteAll( GetControlHandle( Arg2, Arg1 ) )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'GroupDelete' )
         ListView_GroupDelete( GetControlHandle( Arg2, Arg1 ), Arg4 )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'GroupAdd' )
         ListView_GroupAdd( GetControlHandle( Arg2, Arg1 ), Arg4, Arg5 )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'GroupExpand' )
         ListView_GroupSetInfo( GetControlHandle( Arg2, Arg1 ), Arg4, NIL, NIL, NIL, NIL, GRID_GROUP_NORMAL )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'GroupCollapsed' )
         ListView_GroupSetInfo( GetControlHandle( Arg2, Arg1 ), Arg4, NIL, NIL, NIL, NIL, GRID_GROUP_COLLAPSED )
         RetVal := .T.
      CASE Arg3 == HMG_UPPER( 'GroupDeleteAllItems' )
         _GridEx_GroupDeleteAllItems( Arg2, Arg1, Arg4 )
         RetVal := .T.
   ENDCASE
RETURN RetVal

//*********************************************
// by Dr. Claudio Soto (November 2013)
//*********************************************

*+--------------------------------------------------------------------
*+
*+    Function _Tree_GetProperty()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _Tree_GetProperty( xData, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8 )

LOCAL i, nPos, RetVal := .F.

   IF ( VALTYPE( Arg1 ) <> "C" ) .OR. ( VALTYPE( Arg2 ) <> "C" ) .OR. ( VALTYPE( Arg3 ) <> "C" ) .OR. ( _IsControlDefined( Arg2, Arg1 ) == .F. ) .OR. ( GetControlType( Arg2, Arg1 ) <> "TREE" )
      RETURN .F.
   ENDIF

   // Parameters NOT used
   HB_SYMBOL_UNUSED( Arg5 )
   HB_SYMBOL_UNUSED( Arg6 )
   HB_SYMBOL_UNUSED( Arg7 )
   HB_SYMBOL_UNUSED( Arg8 )

   Arg3 := HMG_UPPER( ALLTRIM( Arg3 ) )

   DO CASE

      CASE Arg3 == 'ALLVALUE'
         xData := TreeItemGetAllValue( Arg2, Arg1 )
         RetVal := .T.

      CASE Arg3 == 'ROOTVALUE'
         xData := TreeItemGetRootValue( Arg2, Arg1 )
         RetVal := .T.

      CASE Arg3 == 'FIRSTITEMVALUE'
         xData := TreeItemGetFirstItemValue( Arg2, Arg1 )
         RetVal := .T.

      CASE Arg3 == 'PARENTVALUE'
         xData := TreeItemGetParentValue( Arg2, Arg1, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'CHILDVALUE'
         xData := TreeItemGetChildValue( Arg2, Arg1, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'SIBLINGVALUE'
         xData := TreeItemGetSiblingValue( Arg2, Arg1, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'ITEMTEXT'
         xData := TreeItemGetItemText( Arg2, Arg1, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'ISTRUENODE'
         xData := TreeItemIsTrueNode( Arg2, Arg1, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'NODEFLAG'
         xData := TreeItemGetNodeFlag( Arg2, Arg1, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'IMAGEINDEX'
         xData := TreeItemGetImageIndex( Arg2, Arg1, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'IMAGECOUNT'
         xData := TreeGetImageCount( Arg2, Arg1 )
         RetVal := .T.

      CASE Arg3 == 'ISEXPAND'
         xData := TreeItemIsExpand( Arg2, Arg1, Arg4 )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'ImageList' )
         xData := TreeView_GetImageList( GetControlHandle( Arg2, Arg1 ), TVSIL_NORMAL )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'HasLines' )
         xData := HMG_IsWindowStyle( GetControlHandle( Arg2, Arg1 ), TVS_HASLINES, .F. )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'FullRowSelect' )
         xData := HMG_IsWindowStyle( GetControlHandle( Arg2, Arg1 ), TVS_FULLROWSELECT, .F. )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'HasButton' )
         xData := TreeView_GetHasButton( GetControlHandle( Arg2, Arg1 ), TreeItemGetHandle( Arg2, Arg1, Arg4 ) )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'Cargo' )
         xData := _GetCargo( Arg2, Arg1, Arg4, NIL )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'CargoScan' )
         i := GetControlIndex( Arg2, Arg1 )
         nPos := ASCAN( _HMG_SYSDATA[ 32 ] [ i ], Arg4 )
         xData := IF( nPos > 0, nPos, NIL )
         IF nPos <> NIL .AND. _HMG_SYSDATA[ 9 ] [ i ] == .T.
            xData := _HMG_SYSDATA[ 25 ] [ i ] [ nPos ]
         ENDIF
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'GetPathValue' )
         xData := TreeItemGetPathValue( Arg2, Arg1, Arg4 )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'GetPathName' )
         xData := TreeItemGetPathName( Arg2, Arg1, Arg4 )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'GetDisplayLevel' )
         xData := TreeItemGetDisplayLevel( Arg2, Arg1, Arg4 )
         RetVal := .T.

   ENDCASE
RETURN RetVal

*+--------------------------------------------------------------------
*+
*+    Function _Tree_SetProperty()
*+
*+    Called from ( h_controlmisc.prg )   1 - function setproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _Tree_SetProperty( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8 )

LOCAL RetVal := .F.

   IF ( VALTYPE( Arg1 ) <> "C" ) .OR. ( VALTYPE( Arg2 ) <> "C" ) .OR. ( VALTYPE( Arg3 ) <> "C" ) .OR. ( _IsControlDefined( Arg2, Arg1 ) == .F. ) .OR. ( GetControlType( Arg2, Arg1 ) <> "TREE" )
      RETURN .F.
   ENDIF

   // Parameters NOT used
   HB_SYMBOL_UNUSED( Arg6 )
   HB_SYMBOL_UNUSED( Arg7 )
   HB_SYMBOL_UNUSED( Arg8 )

   Arg3 := HMG_UPPER( ALLTRIM( Arg3 ) )

   DO CASE
      CASE Arg3 == 'NODEFLAG'
         TreeItemSetNodeFlag( Arg2, Arg1, Arg4, Arg5 )
         RetVal := .T.

      CASE Arg3 == 'IMAGEINDEX'
         TreeItemSetImageIndex( Arg2, Arg1, Arg4, Arg5 )
         RetVal := .T.

      CASE Arg3 == 'ADDIMAGE'
         TreeAddImage( Arg2, Arg1, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'TEXTCOLOR'
         TreeSetTextColor( Arg2, Arg1, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'BACKCOLOR'
         TreeSetBackColor( Arg2, Arg1, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'LINECOLOR'
         TreeSetLineColor( Arg2, Arg1, Arg4 )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'ImageList' )
         TreeView_SetImageList( GetControlHandle( Arg2, Arg1 ), Arg4, TVSIL_NORMAL )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'HasLines' )
         IF Arg4 == .T.
            HMG_ChangeWindowStyle( GetControlHandle( Arg2, Arg1 ), TVS_HASLINES, NIL, .F. )
         ELSE
            HMG_ChangeWindowStyle( GetControlHandle( Arg2, Arg1 ), NIL, TVS_HASLINES, .F. )
         ENDIF
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'FullRowSelect' )
         IF Arg4 == .T.
            HMG_ChangeWindowStyle( GetControlHandle( Arg2, Arg1 ), TVS_FULLROWSELECT, NIL, .F. )
         ELSE
            HMG_ChangeWindowStyle( GetControlHandle( Arg2, Arg1 ), NIL, TVS_FULLROWSELECT, .F. )
         ENDIF
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'HasButton' )
         TreeView_SetHasButton( GetControlHandle( Arg2, Arg1 ), TreeItemGetHandle( Arg2, Arg1, Arg4 ), Arg5 )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'Cargo' )
         _SetCargo( Arg2, Arg1, Arg4, NIL, Arg5 )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'DynamicBackColor' )
         _HMG_SYSDATA[ 40 ] [ GetControlIndex( Arg2, Arg1 ) ] [ 1 ] := Arg4
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'DynamicForeColor' )
         _HMG_SYSDATA[ 40 ] [ GetControlIndex( Arg2, Arg1 ) ] [ 2 ] := Arg4
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( 'DynamicFont' )
         _HMG_SYSDATA[ 40 ] [ GetControlIndex( Arg2, Arg1 ) ] [ 3 ] := Arg4
         RetVal := .T.

   ENDCASE
RETURN RetVal

*+--------------------------------------------------------------------
*+
*+    Function _Tree_DoMethod()
*+
*+    Called from ( h_controlmisc.prg )   1 - function domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _Tree_DoMethod( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9 )

LOCAL RetVal := .F.

   IF ( VALTYPE( Arg1 ) <> "C" ) .OR. ( VALTYPE( Arg2 ) <> "C" ) .OR. ( VALTYPE( Arg3 ) <> "C" ) .OR. ( _IsControlDefined( Arg2, Arg1 ) == .F. ) .OR. ( GetControlType( Arg2, Arg1 ) <> "TREE" )
      RETURN .F.
   ENDIF

   // Parameters NOT used
   HB_SYMBOL_UNUSED( Arg9 )

   Arg3 := HMG_UPPER( ALLTRIM( Arg3 ) )

   DO CASE
      CASE Arg3 == 'SETDEFAULTNODEFLAG'
         TreeItemSetDefaultNodeFlag( Arg2, Arg1, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'SETDEFAULTALLNODEFLAG'
         TreeItemSetDefaultAllNodeFlag( Arg2, Arg1 )
         RetVal := .T.

      CASE Arg3 == 'SORT'
         TreeItemSort( Arg2, Arg1, Arg4, Arg5, Arg6, Arg7, Arg8 )
         RetVal := .T.

   ENDCASE
RETURN RetVal

//*********************************************
// by Dr. Claudio Soto (January 2014)
//*********************************************

*+--------------------------------------------------------------------
*+
*+    Function _RichEditBox_GetProperty()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _RichEditBox_GetProperty( xData, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8 )

LOCAL hWndControl, cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, aTextColor, aBackColor, nScript, lLink
LOCAL nAlignment, nNumbering, nNumberingStyle, nNumberingStart, ndOffset, ndLineSpacing, ndStartIndent
LOCAL nNumerator, nDenominator
LOCAL RetVal      := .F.

   IF ( VALTYPE( Arg1 ) <> "C" ) .OR. ( VALTYPE( Arg2 ) <> "C" ) .OR. ( VALTYPE( Arg3 ) <> "C" ) .OR. ( _IsControlDefined( Arg2, Arg1 ) == .F. ) .OR. ( GetControlType( Arg2, Arg1 ) <> "RICHEDIT" )
      RETURN .F.
   ENDIF

   cFontName := nFontSize := lBold := lItalic := lUnderline := lStrikeout := aTextColor := aBackColor := nScript := lLink := NIL
   nAlignment := nNumbering := nNumberingStyle := nNumberingStart := ndOffset := ndLineSpacing := ndStartIndent := NIL

   hWndControl := GetControlHandle( Arg2, Arg1 )
   RichEditBox_GetFont( hWndControl, @cFontName, @nFontSize, @lBold, @lItalic, @lUnderline, @lStrikeout, @aTextColor, @aBackColor, @nScript, @lLink )
   RichEditBox_GetParaFormat( hWndControl, @nAlignment, @nNumbering, @nNumberingStyle, @nNumberingStart, @ndOffset, @ndLineSpacing, @ndStartIndent )

   Arg3 := HMG_UPPER( ALLTRIM( Arg3 ) )

   DO CASE
      CASE Arg3 == 'FONTNAME'
         xData := cFontName
         RetVal := .T.

      CASE Arg3 == 'FONTSIZE'
         xData := nFontSize
         RetVal := .T.

      CASE Arg3 == 'FONTBOLD'
         xData := lBold
         RetVal := .T.

      CASE Arg3 == 'FONTITALIC'
         xData := lItalic
         RetVal := .T.

      CASE Arg3 == 'FONTUNDERLINE'
         xData := lUnderline
         RetVal := .T.

      CASE Arg3 == 'FONTSTRIKEOUT'
         xData := lStrikeout
         RetVal := .T.

      CASE Arg3 == 'FONTCOLOR'
         xData := aTextColor
         RetVal := .T.

      CASE Arg3 == 'FONTBACKCOLOR'
         xData := aBackColor
         RetVal := .T.

      CASE Arg3 == 'FONTSCRIPT'
         xData := nScript
         RetVal := .T.

      CASE Arg3 == 'RTFTEXTMODE'
         xData := RichEditBox_IsRTFTextMode( hWndControl )
         RetVal := .T.

      CASE Arg3 == 'AUTOURLDETECT'
         xData := RichEditBox_GetAutoURLDetect( hWndControl )
         RetVal := .T.

      CASE Arg3 == 'ZOOM'
         RichEditBox_GetZoom( hWndControl, @nNumerator, @nDenominator )
         xData := ( nNumerator / nDenominator ) * 100
         RetVal := .T.

      CASE Arg3 == 'SELECTRANGE'
         xData := RichEditBox_GetSelRange( hWndControl )
         RetVal := .T.

      CASE Arg3 == 'CARETPOS'
         xData := RichEditBox_GetCaretPos( hWndControl )
         RetVal := .T.

      CASE Arg3 == 'VALUE'
         xData := RichEditBox_GetText( hWndControl, .F. )
         RetVal := .T.

      CASE Arg3 == 'GETSELECTTEXT'
         xData := RichEditBox_GetText( hWndControl, .T. )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "GetTextRange" )
         xData := RichEditBox_GetTextRange( hWndControl, Arg4 )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "GetTextLength" )
         xData := RichEditBox_GetTextLength( hWndControl )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "GetPosChar" )
         xData := RichEditBox_PosFromChar( hWndControl, Arg4 )        // return { nRowScreen, nColScreen } or { -1, -1 } if character is not displayed
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "ParaAlignment" )
         xData := nAlignment
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "ParaNumbering" )
         xData := nNumbering
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "ParaNumberingStyle" )
         xData := nNumberingStyle
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "ParaNumberingStart" )
         xData := nNumberingStart
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "ParaOffset" )
         xData := ndOffset                                            // in millimeters
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "ParaLineSpacing" )
         xData := ndLineSpacing
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "ParaIndent" )
         xData := ndStartIndent                                       // in millimeters
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "CanPaste" )
         xData := RichEditBox_CanPaste( hWndControl )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "CanUnDo" )
         xData := RichEditBox_CanUnDo( hWndControl )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "CanReDo" )
         xData := RichEditBox_CanReDo( hWndControl )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "FindText" )
         xData := RichEditBox_FindText( hWndControl, Arg4, Arg5, Arg6, Arg7, Arg8 )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "ReplaceText" )
         xData := RichEditBox_ReplaceText( hWndControl, Arg4, Arg5, Arg6, Arg7, Arg8 )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "ReplaceAllText" )
         xData := RichEditBox_ReplaceAllText( hWndControl, Arg4, Arg5, Arg6, Arg7, Arg8 )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "Link" )
         xData := lLink
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "GetClickLinkRange" )
         xData := { _HMG_CharRange_Min, _HMG_CharRange_Max }          // This Value is valid only into ON LINK procedure
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "GetClickLinkText" )
         xData := RichEditBox_GetTextRange( hWndControl, { _HMG_CharRange_Min, _HMG_CharRange_Max } )                                       // This Value is valid only into ON LINK procedure
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "ViewRect" )
         xData := RichEditBox_GetRect( hWndControl )
         RetVal := .T.

   ENDCASE
RETURN RetVal

*+--------------------------------------------------------------------
*+
*+    Function _RichEditBox_SetProperty()
*+
*+    Called from ( h_controlmisc.prg )   1 - function setproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _RichEditBox_SetProperty( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8 )

LOCAL hWndControl, cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, aTextColor, aBackColor, nScript, lLink
LOCAL nAlignment, nNumbering, nNumberingStyle, nNumberingStart, ndOffset, ndLineSpacing, ndStartIndent
LOCAL nNumerator, nDenominator
LOCAL RetVal      := .F.

   IF ( VALTYPE( Arg1 ) <> "C" ) .OR. ( VALTYPE( Arg2 ) <> "C" ) .OR. ( VALTYPE( Arg3 ) <> "C" ) .OR. ( _IsControlDefined( Arg2, Arg1 ) == .F. ) .OR. ( GetControlType( Arg2, Arg1 ) <> "RICHEDIT" )
      RETURN .F.
   ENDIF

   cFontName := nFontSize := lBold := lItalic := lUnderline := lStrikeout := aTextColor := aBackColor := nScript := lLink := NIL
   nAlignment := nNumbering := nNumberingStyle := nNumberingStart := ndOffset := ndLineSpacing := ndStartIndent := NIL

   // Parameters NOT used
   HB_SYMBOL_UNUSED( Arg6 )
   HB_SYMBOL_UNUSED( Arg7 )
   HB_SYMBOL_UNUSED( Arg8 )

   hWndControl := GetControlHandle( Arg2, Arg1 )

   Arg3 := HMG_UPPER( ALLTRIM( Arg3 ) )

   DO CASE

      CASE Arg3 == 'FONTNAME'
         cFontName := Arg4
         RetVal := .T.

      CASE Arg3 == 'FONTSIZE'
         nFontSize := Arg4
         RetVal := .T.

      CASE Arg3 == 'FONTBOLD'
         lBold := Arg4
         RetVal := .T.

      CASE Arg3 == 'FONTITALIC'
         lItalic := Arg4
         RetVal := .T.

      CASE Arg3 == 'FONTUNDERLINE'
         lUnderline := Arg4
         RetVal := .T.

      CASE Arg3 == 'FONTSTRIKEOUT'
         lStrikeout := Arg4
         RetVal := .T.

      CASE Arg3 == 'FONTCOLOR'
         aTextColor := Arg4
         RetVal := .T.

      CASE Arg3 == 'FONTBACKCOLOR'
         aBackColor := Arg4
         RetVal := .T.

      CASE Arg3 == 'FONTSCRIPT'
         nScript := Arg4
         RetVal := .T.

      CASE Arg3 == 'RTFTEXTMODE'
         RichEditBox_SetRTFTextMode( hWndControl, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'AUTOURLDETECT'
         RichEditBox_SetAutoURLDetect( hWndControl, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'BACKGROUNDCOLOR'
         RichEditBox_SetBkgndColor( hWndControl, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'ZOOM'
         nNumerator := Arg4                                           // in percentage
         nDenominator := 100
         RichEditBox_SetZoom( hWndControl, nNumerator, nDenominator )
         RetVal := .T.

      CASE Arg3 == 'SELECTRANGE'
         RichEditBox_SetSelRange( hWndControl, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'CARETPOS'
         RichEditBox_SetCaretPos( hWndControl, Arg4 )
         RetVal := .T.

      CASE Arg3 == 'VALUE'
         RichEditBox_SetText( hWndControl, .F., Arg4 )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "AddText" )
         Arg4 := IF( VALTYPE( Arg4 ) <> "N", - 1, Arg4 )
         RichEditBox_SetCaretPos( hWndControl, Arg4 )
         RichEditBox_SetText( hWndControl, .T., Arg5 )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "AddTextAndSelect" )
         Arg4 := IF( VALTYPE( Arg4 ) <> "N", - 1, Arg4 )
         RichEditBox_AddTextAndSelect( hWndControl, Arg4, Arg5 )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "ParaAlignment" )
         nAlignment := Arg4
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "ParaNumbering" )
         nNumbering := Arg4
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "ParaNumberingStyle" )
         nNumberingStyle := Arg4
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "ParaNumberingStart" )
         nNumberingStart := Arg4
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "ParaOffset" )
         ndOffset := Arg4                                             // in millimeters
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "ParaLineSpacing" )
         ndLineSpacing := Arg4
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "ParaIndent" )
         ndStartIndent := Arg4                                        // in millimeters
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "Link" )
         lLink := Arg4
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "ViewRect" )
         RichEditBox_SetRect( hWndControl, Arg4 )
         RetVal := .T.

   ENDCASE

   RichEditBox_SetFont( hWndControl, cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, aTextColor, aBackColor, nScript, lLink )
   RichEditBox_SetParaFormat( hWndControl, nAlignment, nNumbering, nNumberingStyle, nNumberingStart, ndOffset, ndLineSpacing, ndStartIndent )
RETURN RetVal

*+--------------------------------------------------------------------
*+
*+    Function _RichEditBox_DoMethod()
*+
*+    Called from ( h_controlmisc.prg )   1 - function domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _RichEditBox_DoMethod( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9 )

LOCAL RetVal      := .F.
LOCAL hWndControl

   IF ( VALTYPE( Arg1 ) <> "C" ) .OR. ( VALTYPE( Arg2 ) <> "C" ) .OR. ( VALTYPE( Arg3 ) <> "C" ) .OR. ( _IsControlDefined( Arg2, Arg1 ) == .F. ) .OR. ( GetControlType( Arg2, Arg1 ) <> "RICHEDIT" )
      RETURN .F.
   ENDIF

   hWndControl := GetControlHandle( Arg2, Arg1 )

   Arg3 := HMG_UPPER( ALLTRIM( Arg3 ) )

   DO CASE
      CASE Arg3 == HMG_UPPER( "SelectAll" )
         RichEditBox_SelectAll( hWndControl )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "UnSelectAll" )
         RichEditBox_UnSelectAll( hWndControl )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "RTFLoadFile" ) .OR. Arg3 == HMG_UPPER( "LoadFile" )
         RichEditBox_LoadFile( hWndControl, Arg4, Arg5, Arg6 )        // by default load in SF_RTF format
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "RTFSaveFile" ) .OR. Arg3 == HMG_UPPER( "SaveFile" )
         RichEditBox_SaveFile( hWndControl, Arg4, Arg5, Arg6 )        // by default save in SF_RTF format
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "SelPasteSpecial" )
         RichEditBox_PasteSpecial( hWndControl, Arg4 )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "SelCopy" )
         RichEditBox_SelCopy( hWndControl )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "SelPaste" )
         RichEditBox_SelPaste( hWndControl )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "SelCut" )
         RichEditBox_SelCut( hWndControl )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "SelClear" )
         RichEditBox_SelClear( hWndControl )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "Undo" )
         RichEditBox_ChangeUndo( hWndControl )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "Redo" )
         RichEditBox_ChangeRedo( hWndControl )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "ClearUndoBuffer" )
         RichEditBox_ClearUndoBuffer( hWndControl )
         RetVal := .T.

      CASE Arg3 == HMG_UPPER( "RTFPrint" )
         RichEditBox_RTFPrint( hWndControl, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9 )
         RetVal := .T.

   ENDCASE
RETURN RetVal

//*********************************************
// by Dr. Claudio Soto (January 2014)
//*********************************************

*+--------------------------------------------------------------------
*+
*+    Function GetFontList()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetFontList( hDC, cFontFamilyName, nCharSet, nPitch, nFontType, lSortCaseSensitive, aFontName )                                    // return array { { cFontName, nCharSet, nPitchAndFamily, nFontType } , ... }

LOCAL SortCodeBlock

   IF VALTYPE( lSortCaseSensitive ) <> "L"
      lSortCaseSensitive := .F.
   ENDIF

   IF lSortCaseSensitive == .T.
      SortCodeBlock := { | x, y | x[ 1 ] < y[ 1 ] }
   ELSE
      SortCodeBlock := { | x, y | HMG_UPPER( ALLTRIM( x[ 1 ] ) ) < HMG_UPPER( ALLTRIM( y[ 1 ] ) ) }
   ENDIF
RETURN EnumFonts( hDC, cFontFamilyName, nCharSet, nPitch, nFontType, SortCodeBlock, @aFontName )

//*********************************************
// by Dr. Claudio Soto (July 2014)
//*********************************************

*+--------------------------------------------------------------------
*+
*+    Function _SetCargo()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _tree_setproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetCargo( ControlName, ParentForm, Item, idx, xData )

LOCAL i := 0, RetVal := NIL
LOCAL T, c, aPos

   IF VALTYPE( idx ) <> "N"
      i := GetControlIndex( ControlName, ParentForm )
   ELSE
      i := idx
   ENDIF

   T = _HMG_SYSDATA[ 1 ] [ i ]
   c = _HMG_SYSDATA[ 3 ] [ i ]

   DO CASE
      CASE t == 'TREE'
         IF _HMG_SYSDATA[ 9 ] [ i ] == .F.
            IF Item > TreeView_GetCount( c ) .OR. Item < 1
               MsgHMGError( "Item Property: Invalid Item Reference. Program Terminated" )
            ENDIF
            _HMG_SYSDATA[ 32 ] [ i ] [ Item ] := xData                // cargo
         ELSE
            aPos := ASCAN( _HMG_SYSDATA[ 25 ] [ i ], Item )
            IF aPos == 0
               MsgHMGError( "Item Property: Invalid Item Id. Program Terminated" )
            ENDIF
            _HMG_SYSDATA[ 32 ] [ i ] [ aPos ] := xData                // cargo
         ENDIF
   ENDCASE
RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Function _GetCargo()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _tree_getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetCargo( ControlName, ParentForm, Item, idx )

LOCAL i := 0, xData := NIL
LOCAL T, c, aPos

   IF VALTYPE( idx ) <> "N"
      i := GetControlIndex( ControlName, ParentForm )
   ELSE
      i := idx
   ENDIF

   T = _HMG_SYSDATA[ 1 ] [ i ]
   c = _HMG_SYSDATA[ 3 ] [ i ]

   DO CASE
      CASE t == 'TREE'
         IF _HMG_SYSDATA[ 9 ] [ i ] == .F.
            IF Item > TreeView_GetCount( c ) .OR. Item < 1
               MsgHMGError( "Item Property: Invalid Item Reference. Program Terminated" )
            ENDIF
            xData := _HMG_SYSDATA[ 32 ] [ i ] [ Item ]                // cargo
         ELSE
            aPos := ASCAN( _HMG_SYSDATA[ 25 ] [ i ], Item )
            IF aPos == 0
               MsgHMGError( "Item Property: Invalid Item Id. Program Terminated" )
            ENDIF
            xData := _HMG_SYSDATA[ 32 ] [ i ] [ aPos ]                // cargo
         ENDIF
   ENDCASE
RETURN xData

//*********************************************
// by Dr. Claudio Soto (December 2014)
//*********************************************

*+--------------------------------------------------------------------
*+
*+    Function HMG_CreateFontFromArrayFont()
*+
*+    Called from ( h_controlmisc.prg )   1 - procedure settooltipcustomdrawform()
*+                                   1 - procedure settooltipcustomdrawcontrol()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_CreateFontFromArrayFont( aFont )

LOCAL cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeOut
LOCAL hFont     := 0

   IF VALTYPE( aFont ) == "A"
      IF HMG_LEN( aFont ) < 6
         ASIZE( aFont, 6 )                                            // { cFontName, nFontSize, [ lBold, lItalic, lUnderline, lStrikeOut ] }
      ENDIF

      IF VALTYPE( aFont[ 1 ] ) == "C" .AND. .NOT. EMPTY( aFont[ 1 ] ) .AND. VALTYPE( aFont[ 2 ] ) == "N" .AND. aFont[ 2 ] > 0
         cFontName := aFont[ 1 ]
         nFontSize := aFont[ 2 ]
         lBold := aFont[ 3 ]
         lItalic := aFont[ 4 ]
         lUnderline := aFont[ 5 ]
         lStrikeOut := aFont[ 6 ]

         hFont := HMG_CreateFont( NIL, cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeOut )
      ENDIF
   ENDIF

RETURN hFont

*+--------------------------------------------------------------------
*+
*+    Procedure SetToolTipCustomDraw()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE SetToolTipCustomDraw( lOn )

LOCAL k, hWndToolTip
   IF HB_ISLOGICAL( lOn )
      _HMG_SYSDATA[ 509 ] := lOn
      IF lOn == .F.
         FOR k := 1 TO HMG_LEN( _HMG_SYSDATA[ 67 ] )
            IF _HMG_SYSDATA[ 65 ] [ k ] == .F.                        // aFormDeleted
               hWndToolTip := _HMG_SYSDATA[ 73 ] [ k ]
               IF _HMG_SYSDATA[ 512 ] [ k ] [ 7 ] == .T.
                  HMG_ChangeWindowStyle( hWndToolTip, TTS_BALLOON, NIL, .F. )
               ELSE
                  HMG_ChangeWindowStyle( hWndToolTip, NIL, TTS_BALLOON, .F. )
               ENDIF
               SendMessage( hWndToolTip, WM_SETFONT, 0, MAKELPARAM( 1, 0 ) )                                                                // Set Default Font System
               ToolTip_SetTitle( hwndToolTip, "", "" )
            ENDIF
         NEXT
      ENDIF
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure SetToolTipCustomDrawForm()
*+
*+    Called from ( h_windows.prg )   1 - function _definewindow()
*+                                   1 - function _definemodalwindow()
*+                                   1 - function _definesplitchildwindow()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE SetToolTipCustomDrawForm( cFormName, aBackColor, aForeColor, aFont, lBalloon, cTitle, xIconName )

LOCAL k     := GetFormIndex( cFormName )
LOCAL hFont, DefaultBalloon

   IF HB_ISNIL( aBackColor ) .AND. ;
                HB_ISNIL( aForeColor ) .AND. ;
                HB_ISNIL( aFont ) .AND. ;
                HB_ISNIL( lBalloon ) .AND. ;
                HB_ISNIL( cTitle ) .AND. ;
                HB_ISNIL( xIconName )

      DefaultBalloon := _HMG_SYSDATA[ 512 ] [ k ] [ 7 ]
      _HMG_SYSDATA[ 512 ] [ k ] := { - 1, - 1, 0, DefaultBalloon, "", "", DefaultBalloon }                                                  // Set Default Data
   ENDIF

   IF VALTYPE( aBackColor ) == "A"
      _HMG_SYSDATA[ 512 ] [ k ] [ 1 ] := RGB( aBackColor[ 1 ], aBackColor[ 2 ], aBackColor[ 3 ] )
   ENDIF

   IF VALTYPE( aForeColor ) == "A"
      _HMG_SYSDATA[ 512 ] [ k ] [ 2 ] := RGB( aForeColor[ 1 ], aForeColor[ 2 ], aForeColor[ 3 ] )
   ENDIF

   IF VALTYPE( aFont ) == "A"
      hFont := _HMG_SYSDATA[ 512 ] [ k ] [ 3 ]
      IF hFont <> 0
         DeleteObject( hFont )
      ENDIF

      hFont := HMG_CreateFontFromArrayFont( aFont )
      _HMG_SYSDATA[ 512 ] [ k ] [ 3 ] := hFont
   ENDIF

   IF VALTYPE( lBalloon ) == "L"
      _HMG_SYSDATA[ 512 ] [ k ] [ 4 ] := lBalloon
   ENDIF

   IF VALTYPE( cTitle ) == "C"
      _HMG_SYSDATA[ 512 ] [ k ] [ 5 ] := cTitle
   ENDIF

   IF VALTYPE( xIconName ) == "C" .OR. VALTYPE( xIconName ) == "N"
      _HMG_SYSDATA[ 512 ] [ k ] [ 6 ] := xIconName
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure SetToolTipCustomDrawControl()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE SetToolTipCustomDrawControl( cControlName, cFormName, aBackColor, aForeColor, aFont, lBalloon, cTitle, xIconName )

LOCAL hFont, DefaultBalloon
LOCAL i     := GetControlIndex( cControlName, cFormName )
LOCAL k     := GetFormIndex( cFormName )

   IF VALTYPE( _HMG_SYSDATA[ 41 ] [ i ] [ 3 ] ) != "A" .OR. ;
               ( HB_ISNIL( aBackColor ) .AND. ;
               HB_ISNIL( aForeColor ) .AND. ;
               HB_ISNIL( aFont ) .AND. ;
               HB_ISNIL( lBalloon ) .AND. ;
               HB_ISNIL( cTitle ) .AND. ;
               HB_ISNIL( xIconName ) )
      DefaultBalloon := _HMG_SYSDATA[ 512 ] [ k ] [ 7 ]
      _HMG_SYSDATA[ 41 ] [ i ] [ 3 ] := { - 1, - 1, 0, DefaultBalloon, "", "" }                                                             // Set Default Data
   ENDIF

   IF VALTYPE( aBackColor ) == "A"
      _HMG_SYSDATA[ 41 ] [ i ] [ 3 ] [ 1 ] := RGB( aBackColor[ 1 ], aBackColor[ 2 ], aBackColor[ 3 ] )
   ENDIF

   IF VALTYPE( aForeColor ) == "A"
      _HMG_SYSDATA[ 41 ] [ i ] [ 3 ] [ 2 ] := RGB( aForeColor[ 1 ], aForeColor[ 2 ], aForeColor[ 3 ] )
   ENDIF

   IF VALTYPE( aFont ) == "A"
      hFont := _HMG_SYSDATA[ 41 ] [ i ] [ 3 ] [ 3 ]
      IF hFont <> 0
         DeleteObject( hFont )
      ENDIF

      hFont := HMG_CreateFontFromArrayFont( aFont )
      _HMG_SYSDATA[ 41 ] [ i ] [ 3 ] [ 3 ] := hFont
   ENDIF

   IF VALTYPE( lBalloon ) == "L"
      _HMG_SYSDATA[ 41 ] [ i ] [ 3 ] [ 4 ] := lBalloon
   ENDIF

   IF VALTYPE( cTitle ) == "C"
      _HMG_SYSDATA[ 41 ] [ i ] [ 3 ] [ 5 ] := cTitle
   ENDIF

   IF VALTYPE( xIconName ) == "C" .OR. VALTYPE( xIconName ) == "N"
      _HMG_SYSDATA[ 41 ] [ i ] [ 3 ] [ 6 ] := xIconName
   ENDIF

   RETURN

#define TTN_FIRST (0 - 520)
#define TTN_SHOW (TTN_FIRST - 1)
#define DEFAULT_GUI_FONT 17

*+--------------------------------------------------------------------
*+
*+    Function ToolTipCustomDrawEvent()
*+
*+    Called from ( h_windows.prg )   1 - function events()
*+
*+--------------------------------------------------------------------
*+
FUNCTION ToolTipCustomDrawEvent( lParam )

LOCAL i, k, j, hFont
LOCAL IsToolTipMenu := .F.                                            //, hWnd := 0
LOCAL xRet          := NIL
   IF GetNotifyCode( lParam ) == NM_CUSTOMDRAW .OR. GetNotifyCode( lParam ) == TTN_SHOW
      IF _HMG_SYSDATA[ 509 ] == .T.                                   // ToolTip CustomDraw
         k := ASCAN( _HMG_SYSDATA[ 73 ], GetHwndFrom( lParam ) )      // ToolTipHandle
         i := ASCAN( _HMG_SYSDATA[ 3 ], GetIdFrom( lParam ) )         // ToolTipID == ControlHandle

         IF k > 0 .AND. i == 0
            FOR j := 1 TO HMG_LEN( _HMG_SYSDATA[ 3 ] )
               IF VALTYPE( _HMG_SYSDATA[ 3 ] [ j ] ) == 'A' .AND. _HMG_SYSDATA[ 1 ] [ j ] == 'SPINNER' .AND. _HMG_SYSDATA[ 3 ] [ j ] [ 1 ] == GetIdFrom( lParam )                                                 // ToolTipID == ControlHandle
                  i := j
                  EXIT
               ENDIF
            NEXT
         ENDIF

         IF k == 0 .AND. i == 0
            k := ASCAN( _HMG_SYSDATA[ 511 ], GetHwndFrom( lParam ) )  // ToolTipHandleMenu
            i := ASCAN( _HMG_SYSDATA[ 5 ], GetIdFrom( lParam ) )      // ToolTipID == MenuItemID
            IsToolTipMenu := .T.
         ENDIF

         IF k > 0 .AND. i > 0
            /*
            if IsToolTipMenu == .T.
               hWnd := _HMG_SYSDATA [ 4 ] [ i ]
            endif
*/
            IF VALTYPE( _HMG_SYSDATA[ 41 ] [ i ] [ 3 ] ) == "A"
               IF GetNotifyCode( lParam ) == NM_CUSTOMDRAW
                  ToolTip_SetTitle( GetHwndFrom( lParam ), _HMG_SYSDATA[ 41 ] [ i ] [ 3 ] [ 5 ], _HMG_SYSDATA[ 41 ] [ i ] [ 3 ] [ 6 ] )

                  IF _HMG_SYSDATA[ 41 ] [ i ] [ 3 ] [ 4 ] == .T.
                     HMG_ChangeWindowStyle( GetHwndFrom( lParam ), TTS_BALLOON, NIL, .F., .F. )
                  ELSE
                     HMG_ChangeWindowStyle( GetHwndFrom( lParam ), NIL, TTS_BALLOON, .F., .F. )
                  ENDIF
                  xRet := TOOLTIP_CUSTOMDRAW( lParam, ;
                                              _HMG_SYSDATA[ 41 ] [ i ] [ 3 ] [ 1 ], ;
                                              _HMG_SYSDATA[ 41 ] [ i ] [ 3 ] [ 2 ], ;
                                              )

                  /*_HMG_SYSDATA [ 41 ] [ i ] [ 3 ] [ 3 ],IsToolTipMenu,hWnd */

               ELSEIF GetNotifyCode( lParam ) == TTN_SHOW .AND. .NOT. ( IsToolTipMenu )
                  hFont := _HMG_SYSDATA[ 41 ] [ i ] [ 3 ] [ 3 ]
                  IF hFont == 0
                     hFont := GetStockObject( DEFAULT_GUI_FONT )
                  ENDIF
                  SetWindowFont( GetHwndFrom( lParam ), hFont, .T. )
                  //xRet := 1
               ENDIF
            ELSE

               IF GetNotifyCode( lParam ) == NM_CUSTOMDRAW
                  ToolTip_SetTitle( GetHwndFrom( lParam ), _HMG_SYSDATA[ 512 ] [ k ] [ 5 ], _HMG_SYSDATA[ 512 ] [ k ] [ 6 ] )

                  IF _HMG_SYSDATA[ 512 ] [ k ] [ 4 ] == .T.
                     HMG_ChangeWindowStyle( GetHwndFrom( lParam ), TTS_BALLOON, NIL, .F., .F. )
                  ELSE
                     HMG_ChangeWindowStyle( GetHwndFrom( lParam ), NIL, TTS_BALLOON, .F., .F. )
                  ENDIF

                  xRet := TOOLTIP_CUSTOMDRAW( lParam, ;
                                              _HMG_SYSDATA[ 512 ] [ k ] [ 1 ], ;
                                              _HMG_SYSDATA[ 512 ] [ k ] [ 2 ], ;
                                              )

                  /*_HMG_SYSDATA [ 512 ] [ k ] [ 3 ],IsToolTipMenu,hWnd */

               ELSEIF GetNotifyCode( lParam ) == TTN_SHOW .AND. .NOT. ( IsToolTipMenu )
                  hFont := _HMG_SYSDATA[ 512 ] [ k ] [ 3 ]
                  IF hFont == 0
                     hFont := GetStockObject( DEFAULT_GUI_FONT )
                  ENDIF
                  SetWindowFont( GetHwndFrom( lParam ), hFont, .T. )
                  //xRet := 1
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF
RETURN xRet

*+--------------------------------------------------------------------
*+
*+    Function ToolTipMenuDisplayEvent()
*+
*+    Called from ( h_windows.prg )   1 - function events()
*+
*+--------------------------------------------------------------------
*+
FUNCTION ToolTipMenuDisplayEvent( wParam, lParam )

   __THREAD STATIC hWndToolTip_Old := 0, hWnd_Old := 0, nMenuItemID_Old := 0
LOCAL hWndToolTip := 0
LOCAL Menu_ID     := LOWORD( wParam )
LOCAL Menu_Flag   := HIWORD( wParam )
LOCAL hMenu       := lParam
LOCAL hWnd        := 0
LOCAL hFont       := 0
LOCAL i, k

   IF _HMG_SYSDATA[ 510 ] == .T.

      FOR i := 1 TO HMG_LEN( _HMG_SYSDATA[ 3 ] )
         IF _HMG_SYSDATA[ 1 ] [ i ] == "MENU" .AND. _HMG_SYSDATA[ 5 ] [ i ] == Menu_ID
            hWnd := _HMG_SYSDATA[ 4 ] [ i ]
            hWndToolTip := _HMG_SYSDATA[ 511 ] [ GetFormIndexByHandle( hWnd ) ]
            EXIT
         ENDIF
      NEXT

      ToolTip_ShowMenu( hWndToolTip_Old, hWnd_Old, nMenuItemID_Old, .F. )                                                                   // Hide Previous ToolTip Menu

      hWndToolTip_Old := hWndToolTip
      hWnd_Old := hWnd
      nMenuItemID_Old := nMenuItemID_Old

      k := ASCAN( _HMG_SYSDATA[ 511 ], hWndToolTip )                  // ToolTipHandleMenu
      i := ASCAN( _HMG_SYSDATA[ 5 ], Menu_ID )                        // ToolTipID == MenuItemID
      IF i > 0 .AND. VALTYPE( _HMG_SYSDATA[ 41 ] [ i ] [ 3 ] ) == "A"
         hFont := _HMG_SYSDATA[ 41 ] [ i ] [ 3 ] [ 3 ]
      ELSEIF k > 0
         hFont := _HMG_SYSDATA[ 512 ] [ k ] [ 3 ]
      ENDIF
      IF hFont == 0
         hFont := GetStockObject( DEFAULT_GUI_FONT )
      ENDIF

      ToolTip_MenuDisplay( hWndToolTip, hWnd, hMenu, Menu_ID, Menu_Flag, hFont )

   ENDIF

RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Procedure SetToolTipMenu()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE SetToolTipMenu( lOn )

LOCAL k, hWndToolTip
   IF HB_ISLOGICAL( lOn )
      _HMG_SYSDATA[ 510 ] := lOn
      IF lOn == .F.
         FOR k := 1 TO HMG_LEN( _HMG_SYSDATA[ 67 ] )
            IF _HMG_SYSDATA[ 65 ] [ k ] == .F.                        // aFormDeleted
               hWndToolTip := _HMG_SYSDATA[ 511 ] [ k ]
               IF _HMG_SYSDATA[ 512 ] [ k ] [ 7 ] == .T.
                  HMG_ChangeWindowStyle( hWndToolTip, TTS_BALLOON, NIL, .F. )
               ELSE
                  HMG_ChangeWindowStyle( hWndToolTip, NIL, TTS_BALLOON, .F. )
               ENDIF
               SendMessage( hWndToolTip, WM_SETFONT, 0, MAKELPARAM( 1, 0 ) )                                                                // Set Default Font System
            ENDIF
         NEXT
      ENDIF
   ENDIF
RETURN

//*********************************************
// by Dr. Claudio Soto (May 2015)
//*********************************************

//-----------------------------------------------------------------------------------------------
//   HMG_CallDLL ( cLibName , [ nRetType ] , cFuncName , Arg1 , ... , ArgN ) ---> xRetValue
//-----------------------------------------------------------------------------------------------

*+--------------------------------------------------------------------
*+
*+    Function HMG_CallDLL()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_CallDLL( cLibName, nRetType, cFuncName, ... )

STATIC s_hDLL   := { => }
STATIC s_mutex  := hb_mutexCreate()
LOCAL nCallConv := HB_DYN_CALLCONV_STDCALL
LOCAL nEncoding := IIF( HMG_IsCurrentCodePageUnicode(), HB_DYN_ENC_UTF16, HB_DYN_ENC_ASCII )
LOCAL pLibrary

   IF HB_ISSTRING( cFuncName ) .AND. HB_ISSTRING( cLibName )
      hb_mutexLock( s_mutex )

      IF !( cLibName $ s_hDLL )
         s_hDLL[ cLibName ] := hb_libLoad( cLibName )
      ENDIF

      pLibrary := s_hDLL[ cLibName ]

      hb_mutexUnlock( s_mutex )

      IF .NOT. HB_ISNUMERIC( nRetType )
         nRetType := HB_DYN_CTYPE_DEFAULT
      ENDIF

      cFuncName := ALLTRIM( cFuncName )

      DO CASE
         CASE HMG_IsCurrentCodePageUnicode() == .T. .AND. HMG_IsFuncDLL( pLibrary, cFuncName + "W" )
            cFuncName := cFuncName + "W"
         CASE HMG_IsCurrentCodePageUnicode() == .F. .AND. HMG_IsFuncDLL( pLibrary, cFuncName + "A" )
            cFuncName := cFuncName + "A"
      ENDCASE

      RETURN hb_DynCall( { cFuncName, pLibrary, hb_bitOR( nCallConv, nRetType, nEncoding ) }, ... )
   ENDIF

   RETURN NIL

   /*
   HB_DYNCALL ({<cFunction>, <cLibrary> | <pLibrary> [, <nFuncFlags> [, <nArgFlags1>, ..., <nArgFlagsn>]]}, ...) -> <xResult>

      nFuncFlags ---> hb_bitOr (HB_DYN_CTYPE_ *, HB_DYN_ENC_ *, HB_DYN_CALLCONV_ *)
      nArgFlags  ---> hb_bitOr (HB_DYN_CTYPE_ *, HB_DYN_ENC_ *)
      pLibrary : = hb_libLoad (cLibrary)
*/

   /***** change to HB_FUNC.PRG ************************

#pragma BEGINDUMP
#include "SET_COMPILE_HMG_UNICODE.ch"
#include "HMG_UNICODE.h"
#include <windows.h>
#include "hbapi.h"

//        HMG_IsFuncDLL ( pLibDLL | cLibName, cFuncName ) ---> Boolean
HB_FUNC ( HMG_ISFUNCDLL )
{
   HMODULE hModule = NULL;
   BOOL bRelease;

   if ( HB_ISCHAR (1) )
   {  hModule = LoadLibrary ((TCHAR *) HMG_parc (1));
      bRelease = TRUE;
   }
   else
   {  hModule = hb_libHandle (hb_param (1, HB_IT_ANY));
      bRelease = FALSE;
   }

   CHAR * cFuncName = (CHAR *) hb_parc (2);

   hb_retl (GetProcAddress (hModule, cFuncName) ? TRUE : FALSE);

   if (bRelease && hModule)
      FreeLibrary (hModule);
}

#pragma ENDDUMP

*****************************/

*+--------------------------------------------------------------------
*+
*+    Function HMG_GetHBSymbols()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_GetHBSymbols()                                           // return array -->   { { cSymName1, cSymType1 } , { cSymName2, cSymType2 }, ... }

LOCAL i, cSymName, aSym := {}
   /*
__DYNSCOUNT()    // How much symbols do we have:    dsCount = __dynsCount()
__DYNSGETNAME()  // Get name of symbol:             cSymbol = __dynsGetName( dsIndex )
__DYNSGETINDEX() // Get index number of symbol:     dsIndex = __dynsGetIndex( cSymbol )
__DYNSISFUN()    // returns .T. if a symbol has a function/procedure pointer given its symbol index or name:   __DynsIsFun( cSymbol | dsIndex )
HB_ISFUNCTION()  // returns .T. if a symbol has a function/procedure pointer:                                  hb_IsFunction( cSymbol )
*/

   FOR i := __DYNSCOUNT() TO 1 STEP - 1
      cSymName := __DYNSGETNAME( i )
      AADD( aSym, { cSymName, IIF( __DYNSISFUN( cSymName ), "FUNC/PROC", "" ) } )
   NEXT

RETURN aSym

*+ EOF: h_controlmisc.prg

