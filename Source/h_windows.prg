*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\SOURCE\\h_windows.prg
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Function Events()
*+               Function GetWindowType()
*+               Function _IsWindowActive()
*+               Function _IsWindowDefined()
*+               Function GetFormName()
*+               Function GetFormToolTipHandle()
*+               Function GetMenuToolTipHandle()
*+               Function GetFormHandle()
*+               Function ReleaseAllWindows()
*+               Function _ReleaseWindow()
*+               Function _ShowWindow()
*+               Function _HideWindow()
*+               Function _CenterWindow()
*+               Function _RestoreWindow()
*+               Function _MaximizeWindow()
*+               Function _MinimizeWindow()
*+               Function HMG_MakeWindowsClassName()
*+               Function _DefineWindow()
*+               Function _DefineModalWindow()
*+               Function _DefineSplitChildWindow()
*+               Function _SetWindowSizePos()
*+               Function _GetWindowSizePos()
*+               Function GetFormIndex()
*+               Function _SetNotifyIconName()
*+               Function _SetNotifyIconTooltip()
*+               Function _GetNotifyIconName()
*+               Function _GetNotifyIconTooltip()
*+               Function _DefineSplitBox()
*+               Function _EndSplitBox()
*+               Function _EndSplitChildWindow()
*+               Function _EndPanelWindow()
*+               Function _EndWindow()
*+               Function InputBox()
*+               Function _SetWindowRgn()
*+               Function _SetPolyWindowRgn()
*+               Procedure _SetNextFocus()
*+               Function HMG_ActivateMainWindowFirst()
*+               Function _ActivateWindow()
*+               Function _ActivateAllWindows()
*+               Procedure _PushEventInfo()
*+               Procedure _PopEventInfo()
*+               Procedure _RefreshDataControls()
*+               Procedure _SetActivationFlag()
*+               Procedure _ProcessInitProcedure()
*+               Function _SetFocusedSplitChild()
*+               Procedure _SetActivationFocus()
*+               Function _GenActivateId()
*+               Procedure _hmg_OnHideFocusManagement()
*+               Function _DoControlEventProcedure()
*+               Function _DoWindowEventProcedure()
*+               Function StopWindowEventProcedure()
*+               Function StopControlEventProcedure()
*+               Function _GetGridCellData()
*+               Function IsXPThemeActive()
*+               Procedure InstallEventHandler()
*+               Procedure InstallPropertyHandler()
*+               Procedure InstallMethodHandler()
*+               Function SAVEWINDOW()
*+               Function PRINTWINDOW()
*+               Function IsAppThemed()
*+               Function OpenThemeData()
*+               Function CloseThemeData()
*+               Function DrawThemeBackground()
*+               Procedure VirtualChildControlFocusProcess()
*+               Function InitWaitWindow()
*+               Function ShowWaitWindow()
*+               Function ShowWaitWindowModal()
*+               Function HideWaitWindow()
*+               Function WaitWindow()
*+               Function GetWindowDataByIndex()
*+
*+    Reformatted by Click! 2.05.34 on Sep-22-2020 at  2:53 am
*+
*+--------------------------------------------------------------------

/*----------------------------------------------------------------------------
 HMG - Harbour Windows GUI library source code

 Copyright 2002-2017 Roberto Lopez <mail.box.hmg@gmail.com>
 http://sites.google.com/site/hmgweb/
 Head of HMG project:        2002-2012 Roberto Lopez <mail.box.hmg@gmail.com>
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

// #define ALLOW_ONLY_ONE_MESSAGE_LOOP

/*
  The adaptation of the source code of this file to support UNICODE character set and WIN64 architecture was made
  by Dr. Claudio Soto, November 2012 and June 2014 respectively.
  mail: <srvet@adinet.com.uy>
  blog: http://srvet.blogspot.com
*/

#include "SET_COMPILE_HMG_UNICODE.ch"

#include "SETCompileBrowse.ch"

#include "hmg.ch"
#include "common.ch"
#include "error.ch"

MEMVAR _HMG_SYSDATA
MEMVAR _HMG_MainWindowFirst
MEMVAR _HMG_MainFormIndex
MEMVAR _HMG_LastActiveFormIndex
MEMVAR _HMG_LastActiveControlIndex
MEMVAR _HMG_LastFormIndexWithCursor
MEMVAR _HMG_StopWindowEventProcedure
MEMVAR _HMG_StopControlEventProcedure
MEMVAR _HMG_AvoidReentryEventProcedure
MEMVAR _HMG_GRID_SELECTEDROW_DISPLAYCOLOR
MEMVAR _HMG_GRID_SELECTEDCELL_DISPLAYCOLOR
MEMVAR _HMG_SetControlContextMenu
MEMVAR _HMG_MsgIDFindDlg
MEMVAR _HMG_FindReplaceOnAction

/*
MEMVAR _HMG_EventData
MEMVAR _HMG_EventIsInProgress
MEMVAR _HMG_EventIsKeyboardMessage
MEMVAR _HMG_EventIsMouseMessage
MEMVAR _HMG_EventIsHMGWindowsMessage
MEMVAR _HMG_EventHookID
MEMVAR _HMG_EventHookCode
MEMVAR _HMG_EventINDEX
MEMVAR _HMG_EventHWND
MEMVAR _HMG_EventMSG
MEMVAR _HMG_EventWPARAM
MEMVAR _HMG_EventLPARAM
MEMVAR _HMG_EventPROCNAME
*/

MEMVAR _HMG_CharRange_Min
MEMVAR _HMG_CharRange_Max

MEMVAR _HMG_DefaultIconName

MEMVAR _HMG_This_TreeItem_Value

//#define WM_GETFONT 49   // ok

//#define WM_MENUCOMMAND    0x0126   // ok
//#define WM_MENUSELECT     287     // ok
//#define WM_MENURBUTTONUP  290     // ok
//#define WM_MENUGETOBJECT  0x0124   // ok

#define WM_NCCALCSIZE      131    // ok
#define EM_SETREADONLY     207    // ok
#define COLOR_MENU      4      // ok
#define WM_NCACTIVATE      134    // ok
//#define GWL_EXSTYLE       (-20)   // ok
#define CBN_CLOSEUP       8      // ok
#define CBN_DROPDOWN      7      // ok
#define WM_MOVE          3      // ok
#define WM_MOVING        534    // ok

//#define NM_FIRST         0      // ok
#define CDRF_DODEFAULT    0x00    // ok
#define CDDS_ITEMPOSTPAINT 65538  // ok
#define DL_BEGINDRAG      1157   // ok
#define DL_CANCELDRAG    1160    // ok
#define DL_DRAGGING      1158    // ok
#define DL_DROPPED       1159    // ok
#define DL_CURSORSET     0       // ok
#define DL_STOPCURSOR    1       // ok
#define DL_COPYCURSOR    2       // ok
#define DL_MOVECURSOR    3       // ok

#define DTM_FIRST      0x1000          //  ok
#define DTM_GETMONTHCAL (DTM_FIRST+8)     // ok
// #define DTM_GETMONTHCAL   0x1008  // ok  (MinGW)

// #define TTN_NEEDTEXT (-520)  // only ANSI
#define TTN_FIRST          (-520)
#define TTN_GETDISPINFOA    (TTN_FIRST - 0)
#define TTN_GETDISPINFOW    (TTN_FIRST - 10)
#define TTN_NEEDTEXTA       TTN_GETDISPINFOA
#define TTN_NEEDTEXTW       TTN_GETDISPINFOW
#ifdef COMPILE_HMG_UNICODE
#define TTN_NEEDTEXT TTN_NEEDTEXTW   // UNICODE ok
#else
#define TTN_NEEDTEXT TTN_NEEDTEXTA   // ANSI ok
#endif

#define HOLLOW_BRUSH   5           // ok
#define DC_BRUSH      18          // ok
//#define NM_CUSTOMDRAW (NM_FIRST-12)  // ok

#define LVN_FIRST      (-100)        // ok
// #define LVN_BEGINDRAG   (LVN_FIRST-9)   // ok  (MinGW)
#define LVN_BEGINDRAG   (-109)    // ok

// #define WS_EX_TRANSPARENT   32    // ok
// #define WS_VISIBLE   0x10000000   // ok
// #define WS_GROUP     0x20000      // ok
// #define WS_CHILD   0x40000000     // ok

#define BS_AUTORADIOBUTTON   9    // ok
#define BS_NOTIFY   0x4000       // ok
//#define GWL_STYLE   (-16)       // ok
#define CBN_EDITCHANGE   5       // ok
#define SIZE_MAXHIDE   4         // ok
#define SIZE_MAXIMIZED   2        // ok
#define SIZEFULLSCREEN   2        // ok
#define SIZE_MAXSHOW     3       // ok
#define SIZE_MINIMIZED    1      // ok
#define SIZEICONIC       1      // ok
#define SIZE_RESTORED    0       // ok
#define SIZENORMAL      0       // ok
#define TBN_FIRST     (-700)    // ok
#define TBN_DROPDOWN  (TBN_FIRST-10)   // ok
#define WM_CTLCOLORLISTBOX  308     // ok
#define WM_CTLCOLORBTN   309       // ok
#define COLOR_WINDOW   5        // ok
#define COLOR_3DFACE   15       // ok
#define COLOR_BTNFACE  15       // ok
#define OPAQUE   2               // ok
#define DKGRAY_BRUSH   3          // ok

#define LVN_GETDISPINFOA   (LVN_FIRST-50)
#define LVN_GETDISPINFOW   (LVN_FIRST-77)
#ifdef COMPILE_HMG_UNICODE
#define LVN_GETDISPINFO   LVN_GETDISPINFOW    // Unicode  ok
#else
#define LVN_GETDISPINFO   LVN_GETDISPINFOA    // ANSI ok
#endif

#define LVN_BEGINSCROLL   (LVN_FIRST-80)
#define LVN_ENDSCROLL     (LVN_FIRST-81)

// #define WM_HOTKEY    786       // ok
#define WM_CTLCOLOREDIT   307   // ok
// #define WM_MOUSEWHEEL   522     // ok
// #define WM_MOUSEHOVER   0x2a1    // ok
#define EN_MSGFILTER    1792    // ok
#define DLGC_WANTCHARS   128    // ok
#define DLGC_WANTMESSAGE  4     // ok

#define MCN_FIRST           -750  // ok
#define MCN_LAST            -759  // ok
#define MCN_SELCHANGE       (MCN_FIRST + 1) // ok
#define MCN_SELECT          (MCN_FIRST + 4) // ok
// #define MCN_SELCHANGE  (-749)  // ok (MinGW)
// #define MCN_SELECT     (-746)  // ok (MinGW)

#define WM_HELP            83   // ok
#define STN_CLICKED         0    // ok
#define STN_DBLCLK          1    // ok
#define STN_ENABLE          2    // ok
#define STN_DISABLE         3    // ok

#define SB_HORZ            0    // ok
#define NM_CLICK           (-2)   // ok
// #define NM_CLICK      (NM_FIRST-2)   // ok (MinGW)
#define BS_DEFPUSHBUTTON     1    // ok
#define BM_SETSTYLE         244   // ok
#define SB_CTL             2     // ok
#define SB_VERT            1     // ok
#define SB_LINEUP           0    // ok
#define SB_LINEDOWN         1    // ok
#define SB_LINELEFT         0    // ok
#define SB_LINERIGHT        1    // ok
#define SB_PAGEUP          2    // ok
#define SB_PAGEDOWN         3   // ok
#define SB_PAGELEFT         2   // ok
#define SB_PAGERIGHT        3   // ok
#define SB_THUMBPOSITION     4   // ok
#define SB_THUMBTRACK       5   // ok
#define SB_ENDSCROLL        8   // ok
#define SB_LEFT            6   // ok
#define SB_RIGHT           7   // ok
#define SB_BOTTOM          7   // ok
#define SB_TOP            6   // ok

#define WM_VSCROLL             0x0115  // ok
// #define WM_VSCROLL    277   // ok (MinGW)

// TreeView Notify
#define TVN_FIRST             (-400)
#define TVN_SELCHANGEDA       (TVN_FIRST-2)
#define TVN_SELCHANGEDW       (TVN_FIRST-51)
#define TVN_ITEMEXPANDINGA    (TVN_FIRST-5)
#define TVN_ITEMEXPANDINGW    (TVN_FIRST-54)
#define TVN_ITEMEXPANDEDA     (TVN_FIRST-6)
#define TVN_ITEMEXPANDEDW     (TVN_FIRST-55)
#define TVN_GETDISPINFOA      (TVN_FIRST-3)
#define TVN_GETDISPINFOW      (TVN_FIRST-52)

#ifdef COMPILE_HMG_UNICODE
#define TVN_SELCHANGED        TVN_SELCHANGEDW        // Unicode ok
#define TVN_ITEMEXPANDING     TVN_ITEMEXPANDINGW
#define TVN_ITEMEXPANDED      TVN_ITEMEXPANDEDW
#define TVN_GETDISPINFO       TVN_GETDISPINFOW
#else
#define TVN_SELCHANGED        TVN_SELCHANGEDA        // ANSI ok
#define TVN_ITEMEXPANDING     TVN_ITEMEXPANDINGA
#define TVN_ITEMEXPANDED      TVN_ITEMEXPANDEDA
#define TVN_GETDISPINFO       TVN_GETDISPINFOA
#endif

#define TVE_COLLAPSE   1
#define TVE_EXPAND     2

//New define for TaskBar
#define WM_USER         0x0400    // ok
// #define WM_USER         1024  // ok (MinGW)

#define WM_TASKBAR      WM_USER+1043   // User define Message
#define ID_TASKBAR      0            // User define Message

// #define WM_NCMOUSEMOVE    160    // ok
// #define WM_MOUSEMOVE      512    // 0x0200      // ok
// #define WM_LBUTTONDOWN    513    // 0x0201      // ok
// #define WM_LBUTTONUP      514    // 0x0202      // ok
// #define WM_LBUTTONDBLCLK  515    // 0x203      // ok
// #define WM_RBUTTONDOWN    516    // 0x0204      // ok
// #define WM_RBUTTONUP      517    // 0x0205      // ok

#define WM_INITDIALOG     272   // ok
#define WM_ACTIVATEAPP    28    // ok
// #define TB_AUTOSIZE      (WM_USER+33)   // ok (MinGW)
#define TB_AUTOSIZE      1057   // ok
#define WM_EXITSIZEMOVE   562    // ok
#define WM_ENTERSIZEMOVE  561    // ok
#define WM_NEXTDLGCTL    40      // ok
#define WM_GETDLGCODE    135     // ok
#define TRANSPARENT   1       // ok
#define GRAY_BRUSH      2       // ok
#define NULL_BRUSH      5       // ok
#define WM_CTLCOLORSTATIC   312  // ok
#define WM_CTLCOLORDLG     310   // ok
#define BN_CLICKED        0     // ok
#define WM_VKEYTOITEM     46    // ok
#define LBN_KILLFOCUS     5     // ok
#define LBN_SETFOCUS      4     // ok
#define CBN_KILLFOCUS     4     // ok
#define CBN_SETFOCUS      3     // ok
#define BN_KILLFOCUS      7     // ok
#define BN_SETFOCUS       6     // ok

// #define NM_SETFOCUS  (NM_FIRST-7)   // ok (MinGW)
// #define NM_KILLFOCUS (NM_FIRST-8)   // ok (MinGW)
#define NM_SETFOCUS     (-7)   // ok
#define NM_KILLFOCUS     (-8)   // ok

// #define LVN_KEYDOWN       (LVN_FIRST-55)   // ok  (MinGW)
// #define LVN_COLUMNCLICK   (LVN_FIRST-8)    // ok  (MinGW)
#define LVN_KEYDOWN     (-155)  // ok
#define LVN_COLUMNCLICK  (-108)  // ok

// #define NM_DBLCLK (NM_FIRST-3)   // ok  (MinGW)
#define NM_DBLCLK       (-3)    // ok

#define LBN_DBLCLK       2     // ok

#define TCN_FIRST   (-550)
// #define TCN_SELCHANGE    (TCN_FIRST-1)   // ok (MinGW)
// #define TCN_SELCHANGING  (TCN_FIRST-2)   // ok (MinGW)
#define TCN_SELCHANGE    (-551)  // ok
#define TCN_SELCHANGING  (-552)  // ok

#define DTN_FIRST       (-760)  // ok
#define DTN_DATETIMECHANGE (DTN_FIRST+1)  // ok
#define DTN_CLOSEUP    (DTN_FIRST+7)
// #define DTN_DATETIMECHANGE (-759)   //  ok (MinGW)
// #define DTN_CLOSEUP        (-753)   //  ok (MinGW)

#define TB_ENDTRACK      8    //  ok
#define WM_HSCROLL       276  //  ok
#define CBN_SELCHANGE    1     //  ok

// #define LVN_ITEMCHANGED   (LVN_FIRST-1)   // ok (MinGW)
#define LVN_ITEMCHANGED  (-101)  //  ok

#define LBN_SELCHANGE    1     // ok
//#define WM_PAINT        15    // ok
//#define WM_ERASEBKGND    20    // ok
//#define WM_DRAWITEM      43    // ok
#define WM_SHOWWINDOW    24    // ok
#define EN_SETFOCUS     256    // ok
#define EN_KILLFOCUS    512    // ok
#define WM_SETFOCUS     7     //  ok
#define WM_KILLFOCUS    8     //  ok
#define WM_UNDO        772   //  ok
#define EM_SETMODIFY    185   //  ok
#define WM_PASTE       770   //  ok
#define EM_GETLINE     196    //  ok
#define EM_SETSEL      177    //  ok
#define WM_CLEAR       771   //  ok
#define EM_GETSEL      176   //  ok
#define EM_UNDO       199    //  ok
#define EN_CHANGE      768   //  ok
#define EN_UPDATE      1024  //  ok
#define WM_ACTIVATE    6     //   ok
#define WM_SIZING     532    //  ok
// #define MK_LBUTTON    1     // ok (i_keybd.ch)
#define WM_CONTEXTMENU 123   // ok
#define WM_TIMER      275   // ok
#define WM_SIZE       5     // ok

// #define TBM_SETPOS   (WM_USER+5)   //  ok  (MinGW)
// #define TBM_GETPOS   (WM_USER)     //  ok  (MinGW)
// #define PBM_SETPOS   (WM_USER+2)   //  ok  (MinGW)
#define TBM_SETPOS    1029  // ok
#define TBM_GETPOS    1024  // ok
#define PBM_SETPOS    1026  // ok

//#define WM_SYSCOMMAND  274     //  ok

// #define SC_CLOSE 0xF060    // ok  (MinGW)
//#define SC_CLOSE      61536     // ok

#define WM_CLOSE      16    //  ok  (MinGW)
// #define WM_COMMAND    273   //  ok  (MinGW)
// #define WM_DESTROY    2     //  ok  (MinGW)

// #define WM_CLOSE        0x0010    //  ok
#define WM_COMMAND      0x0111    //  ok
#define WM_DESTROY      0x0002    //  ok

//#define WM_NOTIFY      78   //  ok
#define WM_CREATE      1    //  ok
#define WM_QUIT        18   //  ok

#define TTM_SETTIPBKCOLOR    (WM_USER + 19)   // ok
#define TTM_SETTIPTEXTCOLOR  (WM_USER + 20)   // ok

#define LVM_FIRST           0x1000         // ok
#define LVM_GETTOPINDEX      (LVM_FIRST+39)   // ok
#define LVM_GETCOUNTPERPAGE   (LVM_FIRST+40)   // ok
#define NM_RCLICK           (NM_FIRST-5)     // ok

#define EN_SELCHANGE   1794   // ok
#define EN_LINK        1803   // ok
#define EN_VSCROLL     1538   // ok

#define CBN_SELENDCANCEL 10   // ok

//   OnCheckBoxClicked   (by Dr. Claudio Soto, December 2014)
#define LVIS_UNCHECKED 0x1000
#define LVIS_CHECKED   0x2000

//#include "hmg.ch"
//#include "common.ch"
//#include "error.ch"
MEMVAR mVar

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function Events()
*+
*+    Called from ( h_grid.prg )   1 - function _hmg_gridonclickandonkeyevent()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Events( hWnd, nMsg, wParam, lParam )

   // ------------------------------------------------------------------------------*
LOCAL i, j, z, x, FormCount, lvc, aPos, maskstart, xs, xd, ts, nr
LOCAL k
LOCAL ControlCount, RecordCount, SkipCount, BackRec, BackArea, BrowseArea, NextControlHandle, NewPos, NewHPos, NewVPos, _ThisQueryTemp, r
LOCAL hwm           := .F.
LOCAL hws
LOCAL mVar
LOCAL DeltaSelect
LOCAL TmpStr
LOCAL Tmp
LOCAL xRetVal
LOCAL aCellData
LOCAL aTemp
LOCAL a
LOCAL MaxBrowseRows
LOCAL MaxBrowseCols
LOCAL aTemp2
LOCAL aSize
   // Local MaxGridRows
   // Local MaxGridCols
LOCAL cProc
LOCAL dlnc
LOCAL _GridInitValue
   // Local _GridInitValue2
LOCAL cTemp
LOCAL xTemp

LOCAL nDestinationColumn
LOCAL nFrozenColumnCount
LOCAL anOriginalColumnWidths
   // Local anCurrentColumnWidths

   // ADD
LOCAL _HMG_ControlHandle, _HMG_MouseRow, _HMG_MouseCol, _HMG_ControlContextMenu
LOCAL aux_hWnd, nIndex, _HMG_ret
LOCAL hFont              := 0

   /*
   // Dr. Claudio Soto (June 2013)

   SetNewBehaviorWndProc (.T.)
   r := EventProcess (hWnd, nMsg, wParam, lParam, .F., .F., .T., (WH_MIN -1), -1)

   IF ValType (r) == "N"
      Return r
   ENDIF
   SetNewBehaviorWndProc (.F.)
   // ret <> Num   --> execution continues normally in the function EVENTS(), not returns to CALLBACK WndProc()
   // ret == -1    --> returns to CALLBACK WndProc() and executes DefWindowProc(Default Window Procedure)
   // ret <> -1    --> returns to CALLBACK WndProc() and NOT executes DefWindowProc(), the application is responsible for fully process the event

*/

   SetNewBehaviorWndProc( .F. )                                       // ADD2, December 2014

   FOR i := 1 TO HMG_LEN( _HMG_SYSDATA[ 60 ] )
      cProc := _HMG_SYSDATA[ 60 ] [ i ]                               // Custom Event Procedures Array
      r := &cProc( hWnd, nMsg, wParam, lParam )
      IF VALTYPE( r ) == 'N'
         RETURN r
      ENDIF
   NEXT i
   // ret <> Num   --> execution continues normally in the function EVENTS(), not returns to CALLBACK WndProc()
   // ret == 0     --> returns to CALLBACK WndProc() and executes DefWindowProc(Default Window Procedure)
   // ret <> 0     --> returns to CALLBACK WndProc() and NOT executes DefWindowProc(), the application is responsible for fully process the event

   DO CASE

         // *********************************************************************************************************
      CASE nMsg == _HMG_MsgIDFindDlg                                  // FindReplace Dialog Notification   ( by Dr. Claudio Soto, January 2014 )
         // *********************************************************************************************************
         _HMG_FindReplaceOptions := FindReplaceDlgGetOptions( lParam )

         EVAL( _HMG_FindReplaceOnAction )

         IF _HMG_FindReplaceOptions[ 1 ] == 0                         // User CANCEL or CLOSE Dialog
            FindReplaceDlgRelease( .T. )                              // Destroy Dialog Window and Set NULL Dialog Handle
         ENDIF

         AFILL( _HMG_FindReplaceOptions, NIL )

         // **********************************************************************
      CASE nMsg == _HMG_SYSDATA[ 54 ]                                 //Drag ListBox Notification
         // **********************************************************************

         dlnc := GET_DRAG_LIST_NOTIFICATION_CODE( lParam )

         IF dlnc == DL_BEGINDRAG

            //  Original Item
            _HMG_SYSDATA[ 53 ] := GET_DRAG_LIST_DRAGITEM( lParam )
            RETURN 1

         ELSEIF dlnc == DL_DRAGGING

            //  Current Item
            _HMG_SYSDATA[ 52 ] := GET_DRAG_LIST_DRAGITEM( lParam )

            IF _HMG_SYSDATA[ 52 ] > _HMG_SYSDATA[ 53 ]

               DRAG_LIST_DRAWINSERT( hWnd, lParam, _HMG_SYSDATA[ 52 ] + 1 )

            ELSE

               DRAG_LIST_DRAWINSERT( hWnd, lParam, _HMG_SYSDATA[ 52 ] )

            ENDIF

            IF _HMG_SYSDATA[ 52 ] <> - 1

               IF _HMG_SYSDATA[ 52 ] > _HMG_SYSDATA[ 53 ]
                  DRAG_LIST_SETCURSOR_DOWN()
               ELSE
                  DRAG_LIST_SETCURSOR_UP()
               ENDIF

               RETURN 0

            ENDIF

            RETURN DL_STOPCURSOR

         ELSEIF dlnc == DL_CANCELDRAG
            _HMG_SYSDATA[ 53 ] := - 1

         ELSEIF dlnc == DL_DROPPED

            _HMG_SYSDATA[ 52 ] := GET_DRAG_LIST_DRAGITEM( lParam )

            IF _HMG_SYSDATA[ 52 ] <> - 1

               DRAG_LIST_MOVE_ITEMS( lParam, _HMG_SYSDATA[ 53 ], _HMG_SYSDATA[ 52 ] )

            ENDIF

            DRAG_LIST_DRAWINSERT( hWnd, lParam, - 1 )

            _HMG_SYSDATA[ 53 ] := - 1

         ENDIF

         // **********************************************************************
      CASE nMsg == WM_CTLCOLORSTATIC
         // **********************************************************************

         i := ASCAN( _HMG_SYSDATA[ 3 ], lParam )

         IF i > 0

            IF _HMG_SYSDATA[ 1 ] [ i ] == 'EDIT' .OR. _HMG_SYSDATA[ 1 ] [ i ] == 'TEXT' .OR. _HMG_SYSDATA[ 1 ] [ i ] == 'NUMTEXT' .OR. _HMG_SYSDATA[ 1 ] [ i ] == 'MASKEDTEXT' .OR. _HMG_SYSDATA[ 1 ] [ i ] == 'CHARMASKTEXT'

               IF _HMG_SYSDATA[ 40 ] [ i ] [ 10 ] != Nil
                  SetTextColor( wParam, _HMG_SYSDATA[ 40 ] [ i ] [ 10 ] [ 1 ], _HMG_SYSDATA[ 40 ] [ i ] [ 10 ] [ 2 ], _HMG_SYSDATA[ 40 ] [ i ] [ 10 ] [ 3 ] )
               ENDIF

               IF _HMG_SYSDATA[ 40 ] [ i ] [ 9 ] != Nil
                  SetBkColor( wParam, _HMG_SYSDATA[ 40 ] [ i ] [ 9 ] [ 1 ], _HMG_SYSDATA[ 40 ] [ i ] [ 9 ] [ 2 ], _HMG_SYSDATA[ 40 ] [ i ] [ 9 ] [ 3 ] )
                  DeleteObject( _HMG_SYSDATA[ 37 ] [ i ] )
                  _HMG_SYSDATA[ 37 ] [ i ] := CreateSolidBrush( _HMG_SYSDATA[ 40 ] [ i ] [ 9 ] [ 1 ], _HMG_SYSDATA[ 40 ] [ i ] [ 9 ] [ 2 ], _HMG_SYSDATA[ 40 ] [ i ] [ 9 ] [ 3 ] )
                  RETURN ( _HMG_SYSDATA[ 37 ] [ i ] )
               ELSE

                  DeleteObject( _HMG_SYSDATA[ 37 ] [ i ] )
                  _HMG_SYSDATA[ 37 ] [ i ] := CreateSolidBrush( GetRed( GetSysColor( COLOR_MENU ) ), GetGreen( GetSysColor( COLOR_MENU ) ), GetBlue( GetSysColor( COLOR_MENU ) ) )
                  SetBkColor( wParam, GetRed( GetSysColor( COLOR_MENU ) ), GetGreen( GetSysColor( COLOR_MENU ) ), GetBlue( GetSysColor( COLOR_MENU ) ) )
                  RETURN ( _HMG_SYSDATA[ 37 ] [ i ] )

               ENDIF

            ENDIF

            IF _HMG_SYSDATA[ 1 ] [ i ] == "LABEL" .OR. _HMG_SYSDATA[ 1 ] [ i ] == "CHECKBOX" .OR. _HMG_SYSDATA[ 1 ] [ i ] == "FRAME" .OR. _HMG_SYSDATA[ 1 ] [ i ] == "SLIDER"

               IF ( IsAppThemed() ) .AND. _HMG_SYSDATA[ 1 ] [ i ] == "SLIDER" .AND. _hmg_sysdata[ 23 ] [ i ] <> - 1 .AND. _hmg_sysdata[ 24 ] [ i ] <> - 1 .AND. _HMG_SYSDATA[ 14 ] [ i ] == Nil
                  IF _hmg_sysdata[ 16 ] [ i ] == .F.
                     DeleteObject( _HMG_SYSDATA[ 39 ] [ GetControlIndex( _hmg_sysdata[ 36 ] [ i ], _hmg_sysdata[ 37 ] [ i ] ) ] )
                     _HMG_SYSDATA[ 39 ] [ GetControlIndex( _hmg_sysdata[ 36 ] [ i ], _hmg_sysdata[ 37 ] [ i ] ) ] := _GetTabBrush( GetControlHandle( _hmg_sysdata[ 36 ] [ i ], _hmg_sysdata[ 37 ] [ i ] ) )
                     RETURN _GetTabbedControlBrush( wParam, lParam, GetControlHandle( _hmg_sysdata[ 36 ] [ i ], _hmg_sysdata[ 37 ] [ i ] ), _HMG_SYSDATA[ 39 ] [ GetControlIndex( _hmg_sysdata[ 36 ] [ i ], _hmg_sysdata[ 37 ] [ i ] ) ] )
                  ENDIF
               ENDIF

               IF ( IsAppThemed() ) .AND. _HMG_SYSDATA[ 1 ] [ i ] == "FRAME" .AND. _hmg_sysdata[ 23 ] [ i ] <> - 1 .AND. _hmg_sysdata[ 24 ] [ i ] <> - 1 .AND. _HMG_SYSDATA[ 14 ] [ i ] == Nil
                  IF _hmg_sysdata[ 16 ] [ i ] == .F.
                     DeleteObject( _HMG_SYSDATA[ 39 ] [ GetControlIndex( _hmg_sysdata[ 31 ] [ i ], _hmg_sysdata[ 32 ] [ i ] ) ] )
                     _HMG_SYSDATA[ 39 ] [ GetControlIndex( _hmg_sysdata[ 31 ] [ i ], _hmg_sysdata[ 32 ] [ i ] ) ] := _GetTabBrush( GetControlHandle( _hmg_sysdata[ 31 ] [ i ], _hmg_sysdata[ 32 ] [ i ] ) )
                     RETURN _GetTabbedControlBrush( wParam, lParam, GetControlHandle( _hmg_sysdata[ 31 ] [ i ], _hmg_sysdata[ 32 ] [ i ] ), _HMG_SYSDATA[ 39 ] [ GetControlIndex( _hmg_sysdata[ 31 ] [ i ], _hmg_sysdata[ 32 ] [ i ] ) ] )
                  ENDIF
               ENDIF

               IF ( IsAppThemed() ) .AND. _HMG_SYSDATA[ 1 ] [ i ] == "CHECKBOX" .AND. _hmg_sysdata[ 23 ] [ i ] <> - 1 .AND. _hmg_sysdata[ 24 ] [ i ] <> - 1 .AND. _HMG_SYSDATA[ 14 ] [ i ] == Nil
                  IF _hmg_sysdata[ 16 ] [ i ] == .F.
                     DeleteObject( _HMG_SYSDATA[ 39 ] [ GetControlIndex( _hmg_sysdata[ 31 ] [ i ], _hmg_sysdata[ 32 ] [ i ] ) ] )
                     _HMG_SYSDATA[ 39 ] [ GetControlIndex( _hmg_sysdata[ 31 ] [ i ], _hmg_sysdata[ 32 ] [ i ] ) ] := _GetTabBrush( GetControlHandle( _hmg_sysdata[ 31 ] [ i ], _hmg_sysdata[ 32 ] [ i ] ) )
                     RETURN _GetTabbedControlBrush( wParam, lParam, GetControlHandle( _hmg_sysdata[ 31 ] [ i ], _hmg_sysdata[ 32 ] [ i ] ), _HMG_SYSDATA[ 39 ] [ GetControlIndex( _hmg_sysdata[ 31 ] [ i ], _hmg_sysdata[ 32 ] [ i ] ) ] )
                  ENDIF
               ENDIF

               IF _HMG_SYSDATA[ 15 ] [ i ] != Nil
                  SetTextColor( wParam, _HMG_SYSDATA[ 15 ] [ i ] [ 1 ], _HMG_SYSDATA[ 15 ] [ i ] [ 2 ], _HMG_SYSDATA[ 15 ] [ i ] [ 3 ] )
               ENDIF

               IF VALTYPE( _HMG_SYSDATA[ 9 ] [ i ] ) == 'L'
                  IF _HMG_SYSDATA[ 9 ] [ i ] == .T.
                     SetBkMode( wParam, TRANSPARENT )
                     RETURN ( GetStockObject( NULL_BRUSH ) )
                  ENDIF
               ENDIF

               IF _HMG_SYSDATA[ 14 ] [ i ] != Nil

                  SetBkColor( wParam, _HMG_SYSDATA[ 14 ] [ i ] [ 1 ], _HMG_SYSDATA[ 14 ] [ i ] [ 2 ], _HMG_SYSDATA[ 14 ] [ i ] [ 3 ] )
                  DeleteObject( _HMG_SYSDATA[ 37 ] [ i ] )
                  _HMG_SYSDATA[ 37 ] [ i ] := CreateSolidBrush( _HMG_SYSDATA[ 14 ] [ i ] [ 1 ], _HMG_SYSDATA[ 14 ] [ i ] [ 2 ], _HMG_SYSDATA[ 14 ] [ i ] [ 3 ] )
                  RETURN ( _HMG_SYSDATA[ 37 ] [ i ] )

               ELSE

                  DeleteObject( _HMG_SYSDATA[ 37 ] [ i ] )
                  _HMG_SYSDATA[ 37 ] [ i ] := CreateSolidBrush( GetRed( GetSysColor( COLOR_3DFACE ) ), GetGreen( GetSysColor( COLOR_3DFACE ) ), GetBlue( GetSysColor( COLOR_3DFACE ) ) )
                  SetBkColor( wParam, GetRed( GetSysColor( COLOR_3DFACE ) ), GetGreen( GetSysColor( COLOR_3DFACE ) ), GetBlue( GetSysColor( COLOR_3DFACE ) ) )
                  RETURN ( _HMG_SYSDATA[ 37 ] [ i ] )

               ENDIF

            ENDIF

         ELSE

            FOR i := 1 TO HMG_LEN( _HMG_SYSDATA[ 3 ] )

               IF VALTYPE( _HMG_SYSDATA[ 3 ] [ i ] ) == 'A'

                  IF _HMG_SYSDATA[ 1 ] [ i ] == 'RADIOGROUP'

                     FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 3 ] [ i ] )

                        IF _HMG_SYSDATA[ 3 ] [ i ] [ x ] == lParam

                           IF _HMG_SYSDATA[ 15 ] [ i ] != Nil
                              SetTextColor( wParam, _HMG_SYSDATA[ 15 ] [ i ] [ 1 ], _HMG_SYSDATA[ 15 ] [ i ] [ 2 ], _HMG_SYSDATA[ 15 ] [ i ] [ 3 ] )
                           ENDIF

                           // if ( IsAppThemed() ) .and. _hmg_sysdata [23] [i] <> -1 .and. _hmg_sysdata [24] [i] <> -1   // Bug: set background color in RADIOGROUP when defined in the TAB control
                           IF ( IsAppThemed() ) .AND. _hmg_sysdata[ 23 ] [ i ] <> - 1 .AND. _hmg_sysdata[ 24 ] [ i ] <> - 1 .AND. _HMG_SYSDATA[ 14 ] [ i ] == Nil
                              IF _hmg_sysdata[ 16 ] [ i ] == .F.
                                 DeleteObject( _HMG_SYSDATA[ 39 ] [ GetControlIndex( _hmg_sysdata[ 31 ] [ i ], _hmg_sysdata[ 32 ] [ i ] ) ] )
                                 _HMG_SYSDATA[ 39 ] [ GetControlIndex( _hmg_sysdata[ 31 ] [ i ], _hmg_sysdata[ 32 ] [ i ] ) ] := _GetTabBrush( GetControlHandle( _hmg_sysdata[ 31 ] [ i ], _hmg_sysdata[ 32 ] [ i ] ) )
                                 RETURN _GetTabbedControlBrush( wParam, lParam, GetControlHandle( _hmg_sysdata[ 31 ] [ i ], _hmg_sysdata[ 32 ] [ i ] ), _HMG_SYSDATA[ 39 ] [ GetControlIndex( _hmg_sysdata[ 31 ] [ i ], _hmg_sysdata[ 32 ] [ i ] ) ] )
                              ENDIF
                           ENDIF

                           IF VALTYPE( _HMG_SYSDATA[ 9 ] [ i ] ) == 'L'
                              IF _HMG_SYSDATA[ 9 ] [ i ] == .T.
                                 SetBkMode( wParam, TRANSPARENT )
                                 RETURN ( GetStockObject( NULL_BRUSH ) )
                              ENDIF
                           ENDIF

                           IF _HMG_SYSDATA[ 14 ] [ i ] != Nil
                              SetBkColor( wParam, _HMG_SYSDATA[ 14 ] [ i ] [ 1 ], _HMG_SYSDATA[ 14 ] [ i ] [ 2 ], _HMG_SYSDATA[ 14 ] [ i ] [ 3 ] )
                              IF x == 1
                                 DeleteObject( _HMG_SYSDATA[ 37 ] [ i ] )
                                 _HMG_SYSDATA[ 37 ] [ i ] := CreateSolidBrush( _HMG_SYSDATA[ 14 ] [ i ] [ 1 ], _HMG_SYSDATA[ 14 ] [ i ] [ 2 ], _HMG_SYSDATA[ 14 ] [ i ] [ 3 ] )
                              ENDIF
                              RETURN ( _HMG_SYSDATA[ 37 ] [ i ] )
                           ELSE
                              IF x == 1
                                 DeleteObject( _HMG_SYSDATA[ 37 ] [ i ] )
                                 _HMG_SYSDATA[ 37 ] [ i ] := CreateSolidBrush( GetRed( GetSysColor( COLOR_3DFACE ) ), GetGreen( GetSysColor( COLOR_3DFACE ) ), GetBlue( GetSysColor( COLOR_3DFACE ) ) )
                              ENDIF
                              SetBkColor( wParam, GetRed( GetSysColor( COLOR_3DFACE ) ), GetGreen( GetSysColor( COLOR_3DFACE ) ), GetBlue( GetSysColor( COLOR_3DFACE ) ) )
                              RETURN ( _HMG_SYSDATA[ 37 ] [ i ] )
                           ENDIF

                        ENDIF

                     NEXT x

                  ENDIF

               ENDIF

            NEXT i

         ENDIF

         // **********************************************************************
      CASE nMsg == WM_CTLCOLOREDIT .OR. nMsg == WM_CTLCOLORLISTBOX
         // **********************************************************************

         i := ASCAN( _HMG_SYSDATA[ 3 ], lParam )

         IF i > 0

            IF _HMG_SYSDATA[ 1 ] [ i ] == "NUMTEXT" .OR. _HMG_SYSDATA[ 1 ] [ i ] == "TEXT" .OR. _HMG_SYSDATA[ 1 ] [ i ] == "MASKEDTEXT" .OR. _HMG_SYSDATA[ 1 ] [ i ] == "CHARMASKTEXT" .OR. _HMG_SYSDATA[ 1 ] [ i ] == "EDIT" .OR. _HMG_SYSDATA[ 1 ] [ i ] == "LIST" .OR. _HMG_SYSDATA[ 1 ] [ i ] == "MULTILIST"

               IF _HMG_SYSDATA[ 15 ] [ i ] != Nil
                  SetTextColor( wParam, _HMG_SYSDATA[ 15 ] [ i ] [ 1 ], _HMG_SYSDATA[ 15 ] [ i ] [ 2 ], _HMG_SYSDATA[ 15 ] [ i ] [ 3 ] )
               ENDIF

               IF _HMG_SYSDATA[ 14 ] [ i ] != Nil
                  SetBkColor( wParam, _HMG_SYSDATA[ 14 ] [ i ] [ 1 ], _HMG_SYSDATA[ 14 ] [ i ] [ 2 ], _HMG_SYSDATA[ 14 ] [ i ] [ 3 ] )
                  DeleteObject( _HMG_SYSDATA[ 37 ] [ i ] )
                  _HMG_SYSDATA[ 37 ] [ i ] := CreateSolidBrush( _HMG_SYSDATA[ 14 ] [ i ] [ 1 ], _HMG_SYSDATA[ 14 ] [ i ] [ 2 ], _HMG_SYSDATA[ 14 ] [ i ] [ 3 ] )
                  RETURN ( _HMG_SYSDATA[ 37 ] [ i ] )
               ELSE

                  DeleteObject( _HMG_SYSDATA[ 37 ] [ i ] )
                  _HMG_SYSDATA[ 37 ] [ i ] := CreateSolidBrush( GetRed( GetSysColor( COLOR_WINDOW ) ), GetGreen( GetSysColor( COLOR_WINDOW ) ), GetBlue( GetSysColor( COLOR_WINDOW ) ) )
                  SetBkColor( wParam, GetRed( GetSysColor( COLOR_WINDOW ) ), GetGreen( GetSysColor( COLOR_WINDOW ) ), GetBlue( GetSysColor( COLOR_WINDOW ) ) )
                  RETURN ( _HMG_SYSDATA[ 37 ] [ i ] )

               ENDIF

            ENDIF

         ELSE

            FOR i := 1 TO HMG_LEN( _HMG_SYSDATA[ 3 ] )

               IF VALTYPE( _HMG_SYSDATA[ 3 ] [ i ] ) == 'A'

                  IF _HMG_SYSDATA[ 1 ] [ i ] == 'SPINNER'

                     IF _HMG_SYSDATA[ 3 ] [ i ] [ 1 ] == lParam

                        IF _HMG_SYSDATA[ 15 ] [ i ] != Nil
                           SetTextColor( wParam, _HMG_SYSDATA[ 15 ] [ i ] [ 1 ], _HMG_SYSDATA[ 15 ] [ i ] [ 2 ], _HMG_SYSDATA[ 15 ] [ i ] [ 3 ] )
                        ENDIF

                        IF _HMG_SYSDATA[ 14 ] [ i ] != Nil
                           SetBkColor( wParam, _HMG_SYSDATA[ 14 ] [ i ] [ 1 ], _HMG_SYSDATA[ 14 ] [ i ] [ 2 ], _HMG_SYSDATA[ 14 ] [ i ] [ 3 ] )
                           DeleteObject( _HMG_SYSDATA[ 37 ] [ i ] )
                           _HMG_SYSDATA[ 37 ] [ i ] := CreateSolidBrush( _HMG_SYSDATA[ 14 ] [ i ] [ 1 ], _HMG_SYSDATA[ 14 ] [ i ] [ 2 ], _HMG_SYSDATA[ 14 ] [ i ] [ 3 ] )
                           RETURN ( _HMG_SYSDATA[ 37 ] [ i ] )
                        ELSE
                           DeleteObject( _HMG_SYSDATA[ 37 ] [ i ] )
                           _HMG_SYSDATA[ 37 ] [ i ] := CreateSolidBrush( GetRed( GetSysColor( COLOR_WINDOW ) ), GetGreen( GetSysColor( COLOR_WINDOW ) ), GetBlue( GetSysColor( COLOR_WINDOW ) ) )
                           SetBkColor( wParam, GetRed( GetSysColor( COLOR_WINDOW ) ), GetGreen( GetSysColor( COLOR_WINDOW ) ), GetBlue( GetSysColor( COLOR_WINDOW ) ) )
                           RETURN ( _HMG_SYSDATA[ 37 ] [ i ] )
                        ENDIF

                     ENDIF

                  ENDIF

               ENDIF

            NEXT i

         ENDIF

         // **********************************************************************
      CASE nMsg == WM_HOTKEY
         // **********************************************************************

         //  Process HotKeys

         i := ASCAN( _HMG_SYSDATA[ 5 ], wParam )

         IF i > 0

            IF _HMG_SYSDATA[ 1 ] [ i ] = "HOTKEY" .AND. _HMG_SYSDATA[ 4 ] [ i ] == GetActiveWindow()

               IF hiword( lParam ) == 27 .AND. loword( lParam ) == 0

                  _HMG_CLOSEMENU( _HMG_SYSDATA[ 4 ] [ i ] )

                  DO EVENTS

               ENDIF

               IF _DoControlEventProcedure( _HMG_SYSDATA[ 6 ] [ i ], i )

                  RETURN 0

               ENDIF

            ENDIF

         ENDIF

         // **********************************************************************
      CASE nMsg == WM_MOUSEWHEEL
         // **********************************************************************

         hwnd := 0

         i := ASCAN( _HMG_SYSDATA[ 67 ], GetFocus() )

         IF i > 0

            IF _HMG_SYSDATA[ 91 ] [ i ] > 0
               hwnd := _HMG_SYSDATA[ 67 ] [ i ]
            ENDIF

         ELSE

            i := ASCAN( _HMG_SYSDATA[ 3 ], GetFocus() )
            IF i > 0

               x := ASCAN( _HMG_SYSDATA[ 67 ], _HMG_SYSDATA[ 4 ] [ i ] )

               IF x > 0
                  IF _HMG_SYSDATA[ 91 ] [ x ] > 0
                     hwnd := _HMG_SYSDATA[ 67 ] [ x ]
                     i := x
                  ENDIF
               ENDIF
            ELSE
               ControlCount := HMG_LEN( _HMG_SYSDATA[ 3 ] )
               FOR i := 1 TO ControlCount
                  IF _HMG_SYSDATA[ 1 ] [ i ] == 'RADIOGROUP'
                     x := ASCAN( _HMG_SYSDATA[ 3 ] [ i ], GetFocus() )
                     IF x > 0
                        z := ASCAN( _HMG_SYSDATA[ 67 ], _HMG_SYSDATA[ 4 ] [ i ] )
                        IF z > 0
                           IF _HMG_SYSDATA[ 91 ] [ z ] > 0
                              hwnd := _HMG_SYSDATA[ 67 ] [ z ]
                              i := z
                              EXIT
                           ENDIF
                        ENDIF
                     ENDIF
                  ENDIF
               NEXT i
            ENDIF

         ENDIF

         IF hwnd != 0

            IF HIWORD( wParam ) == 120
               IF GetScrollPos( hwnd, SB_VERT ) < 25
                  SendMessage( hwnd, WM_VSCROLL, SB_TOP, 0 )
               ELSE
                  SendMessage( hwnd, WM_VSCROLL, SB_PAGEUP, 0 )
               ENDIF
            ELSE
               IF GetScrollPos( hwnd, SB_VERT ) >= GetScrollRangeMax( hwnd, SB_VERT ) - 10
                  SendMessage( hwnd, WM_VSCROLL, SB_BOTTOM, 0 )
               ELSE
                  SendMessage( hwnd, WM_VSCROLL, SB_PAGEDOWN, 0 )
               ENDIF
            ENDIF

         ENDIF

         // **********************************************************************
      CASE nMsg == WM_ACTIVATE
         // **********************************************************************

         IF LoWord( wparam ) == 0
            i := ASCAN( _HMG_SYSDATA[ 67 ], hWnd )
            IF i > 0

               ControlCount := HMG_LEN( _HMG_SYSDATA[ 3 ] )

               FOR x := 1 TO ControlCount
                  IF _HMG_SYSDATA[ 1 ] [ x ] == 'HOTKEY'
                     ReleaseHotKey( _HMG_SYSDATA[ 4 ] [ x ], _HMG_SYSDATA[ 5 ] [ x ] )
                  ENDIF
               NEXT x

               _HMG_SYSDATA[ 101 ] [ i ] := GetFocus()

               _DoWindowEventProcedure( _HMG_SYSDATA[ 86 ] [ i ], i, 'WINDOW_LOSTFOCUS' )

            ENDIF

         ELSE

            i := ASCAN( _HMG_SYSDATA[ 67 ], hWnd )
            IF i > 0
               UpdateWIndow( hWnd )
            ENDIF

         ENDIF

         // **********************************************************************
      CASE nMsg == WM_SETFOCUS
         // **********************************************************************

         i := ASCAN( _HMG_SYSDATA[ 67 ], hWnd )

         IF i > 0

            IF _HMG_SYSDATA[ 68 ] [ i ] == .T. .AND. _HMG_SYSDATA[ 69 ] [ i ] != 'X'
               _HMG_SYSDATA[ 166 ] := hWnd
            ENDIF

            ControlCount := HMG_LEN( _HMG_SYSDATA[ 3 ] )

            FOR x := 1 TO ControlCount
               IF _HMG_SYSDATA[ 1 ] [ x ] == 'HOTKEY'
                  ReleaseHotKey( _HMG_SYSDATA[ 4 ] [ x ], _HMG_SYSDATA[ 5 ] [ x ] )
               ENDIF
            NEXT x

            FOR x := 1 TO ControlCount
               IF _HMG_SYSDATA[ 1 ] [ x ] == 'HOTKEY'
                  IF _HMG_SYSDATA[ 4 ] [ x ] == hWnd
                     InitHotKey( hWnd, _HMG_SYSDATA[ 7 ] [ x ], _HMG_SYSDATA[ 8 ] [ x ], _HMG_SYSDATA[ 5 ] [ x ] )
                  ENDIF
               ENDIF
            NEXT x

            _DoWindowEventProcedure( _HMG_SYSDATA[ 85 ] [ i ], i, 'WINDOW_GOTFOCUS' )

            IF( _HMG_SYSDATA[ 101 ] [ i ] != 0, setfocus( _HMG_SYSDATA[ 101 ] [ i ] ), Nil )

         ENDIF

         // **********************************************************************
      CASE nMsg == WM_HELP
         // **********************************************************************
         /*
      i := ascan ( _HMG_SYSDATA [3] , GetHelpData ( lParam ) )

      if i > 0
         WinHelp ( hwnd , _HMG_SYSDATA [ 217 ] , 1  , 2 , _HMG_SYSDATA [ 35 ][i] )
      EndIf
*/

         i := ASCAN( _HMG_SYSDATA[ 3 ], GetHelpData( lParam ) )

         IF i > 0

            cTemp := _HMG_SYSDATA[ 217 ]
            xTemp := _HMG_SYSDATA[ 35 ] [ i ]
            IF HB_URIGHT( ALLTRIM( HMG_UPPER( cTemp ) ), 4 ) == '.CHM'
               _Execute( hwnd, "open", "hh.exe", cTemp + IF( VALTYPE( xTemp ) == 'C', '::/' + xTemp, '' ),, SW_SHOW )                       // ADD, Kevin march 2017
            ELSE
               WinHelp( hwnd, cTemp, 1, 2, xTemp )
            ENDIF

         ENDIF

         // **********************************************************************
      CASE nMsg == WM_VSCROLL
         // **********************************************************************

         i := ASCAN( _HMG_SYSDATA[ 67 ], hWnd )

         IF i > 0

            //  Vertical ScrollBar Processing

            IF _HMG_SYSDATA[ 91 ] [ i ] > 0 .AND. lParam == 0

               IF _HMG_SYSDATA[ 87 ] [ i ] > 0
                  MsgHMGError( "SplitBox's Parent Window Can't Be a 'Virtual Dimensioned' Window (Use 'Virtual Dimensioned' SplitChild Instead). Program terminated" )
               ENDIF

               IF LoWord( wParam ) == SB_LINEDOWN

                  NewPos := GetScrollPos( hwnd, SB_VERT ) + _HMG_SYSDATA[ 345 ]
                  SetScrollPos( hwnd, SB_VERT, NewPos, .T. )

               ELSEIF LoWord( wParam ) == SB_LINEUP

                  NewPos := GetScrollPos( hwnd, SB_VERT ) - _HMG_SYSDATA[ 345 ]
                  SetScrollPos( hwnd, SB_VERT, NewPos, .T. )

               ELSEIF LoWord( wParam ) == SB_TOP

                  NewPos := 0
                  SetScrollPos( hwnd, SB_VERT, NewPos, .T. )

               ELSEIF LoWord( wParam ) == SB_BOTTOM

                  NewPos := GetScrollRangeMax( hwnd, SB_VERT )
                  SetScrollPos( hwnd, SB_VERT, NewPos, .T. )

               ELSEIF LoWord( wParam ) == SB_PAGEUP

                  NewPos := GetScrollPos( hwnd, SB_VERT ) - _HMG_SYSDATA[ 501 ]
                  SetScrollPos( hwnd, SB_VERT, NewPos, .T. )

               ELSEIF LoWord( wParam ) == SB_PAGEDOWN

                  NewPos := GetScrollPos( hwnd, SB_VERT ) + _HMG_SYSDATA[ 501 ]
                  SetScrollPos( hwnd, SB_VERT, NewPos, .T. )

               ELSEIF LoWord( wParam ) == SB_THUMBPOSITION

                  NewPos := HIWORD( wParam )
                  SetScrollPos( hwnd, SB_VERT, NewPos, .T. )

               ENDIF

               IF _HMG_SYSDATA[ 92 ] [ i ] > 0
                  NewHPos := GetScrollPos( hwnd, SB_HORZ )
               ELSE
                  NewHPos := 0
               ENDIF

               //  Panel Window Repositioning ( by Dr. Claudio Soto, April 2014 )

               IF LoWord( wParam ) == SB_THUMBPOSITION .OR. LoWord( wParam ) == SB_LINEDOWN .OR. LoWord( wParam ) == SB_LINEUP .OR. LoWord( wParam ) == SB_PAGEUP .OR. LoWord( wParam ) == SB_PAGEDOWN .OR. LoWord( wParam ) == SB_BOTTOM .OR. LoWord( wParam ) == SB_TOP
                  FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 67 ] )
                     IF _HMG_SYSDATA[ 65 ] [ x ] == .F.
                        IF _HMG_SYSDATA[ 69 ] [ x ] == 'P' .AND. _HMG_SYSDATA[ 70 ] [ x ] == hWnd
                           MoveWindow( _HMG_SYSDATA[ 67 ] [ x ], _HMG_SYSDATA[ 504 ] [ x ] [ 1 ] - NewHPos, _HMG_SYSDATA[ 504 ] [ x ] [ 2 ] - NewPos, _HMG_SYSDATA[ 504 ] [ x ] [ 3 ], _HMG_SYSDATA[ 504 ] [ x ] [ 4 ], .T. )
                           // RedrawWindow ( hWnd )
                        ENDIF
                     ENDIF
                  NEXT
               ENDIF

               //  Control Repositioning

               IF LoWord( wParam ) == SB_THUMBPOSITION .OR. LoWord( wParam ) == SB_LINEDOWN .OR. LoWord( wParam ) == SB_LINEUP .OR. LoWord( wParam ) == SB_PAGEUP .OR. LoWord( wParam ) == SB_PAGEDOWN .OR. LoWord( wParam ) == SB_BOTTOM .OR. LoWord( wParam ) == SB_TOP

                  FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 3 ] )

                     IF _HMG_SYSDATA[ 4 ] [ x ] == hwnd

                        IF _HMG_SYSDATA[ 1 ] [ x ] == 'SPINNER'

                           MoveWindow( _HMG_SYSDATA[ 3 ] [ x ] [ 1 ], _HMG_SYSDATA[ 19 ] [ x ] - NewHPos, _HMG_SYSDATA[ 18 ] [ x ] - NewPos, _HMG_SYSDATA[ 20 ] [ x ] - GetWindowWidth( _HMG_SYSDATA[ 3 ] [ x ] [ 2 ] ) + 1, _HMG_SYSDATA[ 21 ] [ x ], .t. )
                           MoveWindow( _HMG_SYSDATA[ 3 ] [ x ] [ 2 ], _HMG_SYSDATA[ 19 ] [ x ] + _HMG_SYSDATA[ 20 ] [ x ] - GetWindowWidth( _HMG_SYSDATA[ 3 ] [ x ] [ 2 ] ) - NewHPos, _HMG_SYSDATA[ 18 ] [ x ] - NewPos, GetWindowWidth( _HMG_SYSDATA[ 3 ] [ x ] [ 2 ] ), _HMG_SYSDATA[ 21 ] [ x ], .t. )

#ifdef COMPILEBROWSE

                        ELSEIF _HMG_SYSDATA[ 1 ] [ x ] == 'BROWSE'

                           MoveWindow( _HMG_SYSDATA[ 3 ] [ x ], _HMG_SYSDATA[ 19 ] [ x ] - NewHPos, _HMG_SYSDATA[ 18 ] [ x ] - NewPos, _HMG_SYSDATA[ 20 ] [ x ] - GETVSCROLLBARWIDTH(), _HMG_SYSDATA[ 21 ] [ x ], .t. )
                           MoveWindow( _HMG_SYSDATA[ 5 ] [ x ], _HMG_SYSDATA[ 19 ] [ x ] + _HMG_SYSDATA[ 20 ] [ x ] - GETVSCROLLBARWIDTH() - NewHPos, _HMG_SYSDATA[ 18 ] [ x ] - NewPos, GETVSCROLLBARWIDTH(), GetWIndowHeight( _HMG_SYSDATA[ 5 ] [ x ] ), .t. )
                           MoveWindow( _HMG_SYSDATA[ 39 ] [ x ] [ 1 ], _HMG_SYSDATA[ 19 ] [ x ] + _HMG_SYSDATA[ 20 ] [ x ] - GETVSCROLLBARWIDTH() - NewHPos, _HMG_SYSDATA[ 18 ] [ x ] + _HMG_SYSDATA[ 21 ] [ x ] - GetHScrollBarHeight() - NewPos, GetWindowWidth( _HMG_SYSDATA[ 39 ] [ x ] [ 1 ] ), GetWindowHeight( _HMG_SYSDATA[ 39 ] [ x ] [ 1 ] ), .t. )
                           ReDrawWindow( _HMG_SYSDATA[ 3 ] [ x ] )

#endif

                        ELSEIF _HMG_SYSDATA[ 1 ] [ x ] == 'RADIOGROUP'

                           IF _HMG_SYSDATA[ 8 ] [ x ] == .F.

                              FOR z := 1 TO HMG_LEN( _HMG_SYSDATA[ 3 ] [ x ] )
                                 MoveWindow( _HMG_SYSDATA[ 3 ] [ x ] [ z ], _HMG_SYSDATA[ 19 ] [ x ] - NewHPos, _HMG_SYSDATA[ 18 ] [ x ] - NewPos + ( ( z - 1 ) * _HMG_SYSDATA[ 22 ] [ x ] ), _HMG_SYSDATA[ 20 ] [ x ], _HMG_SYSDATA[ 21 ] [ x ] / HMG_LEN( _HMG_SYSDATA[ 3 ] [ x ] ), .t. )
                              NEXT z

                           ELSE

                              FOR z := 1 TO HMG_LEN( _HMG_SYSDATA[ 3 ] [ x ] )
                                 MoveWindow( _HMG_SYSDATA[ 3 ] [ x ] [ z ], _HMG_SYSDATA[ 19 ] [ x ] - NewHPos + ( z - 1 ) * _HMG_SYSDATA[ 22 ] [ x ], _HMG_SYSDATA[ 18 ] [ x ] - NewPos, _HMG_SYSDATA[ 20 ] [ x ] / HMG_LEN( _HMG_SYSDATA[ 3 ] [ x ] ), _HMG_SYSDATA[ 21 ] [ x ], .t. )
                              NEXT z

                           ENDIF

                        ELSEIF _HMG_SYSDATA[ 1 ] [ x ] == 'TOOLBAR'

                           MsgHMGError( "ToolBar's Parent Window Can't Be a 'Virtual Dimensioned' Window (Use 'Virtual Dimensioned' SplitChild Instead). Program terminated" )

                        ELSEIF _HMG_SYSDATA[ 1 ] [ x ] == 'STATUSBAR'                                                                       // Dr. Claudio Soto (November 2013)
                           // No change

                        ELSE

                           MoveWindow( _HMG_SYSDATA[ 3 ] [ x ], _HMG_SYSDATA[ 19 ] [ x ] - NewHPos, _HMG_SYSDATA[ 18 ] [ x ] - NewPos, _HMG_SYSDATA[ 20 ] [ x ], _HMG_SYSDATA[ 21 ] [ x ], .t. )

                        ENDIF

                     ENDIF
                  NEXT x

                  ReDrawWindow( hwnd )

               ENDIF

            ENDIF

            IF LoWord( wParam ) == SB_LINEDOWN
               _DoWindowEventProcedure( _HMG_SYSDATA[ 95 ] [ i ], i, '' )
            ELSEIF LoWord( wParam ) == SB_LINEUP
               _DoWindowEventProcedure( _HMG_SYSDATA[ 94 ] [ i ], i, '' )
            ELSEIF LoWord( wParam ) == SB_THUMBPOSITION ;
                              .OR. ;
                              LoWord( wParam ) == SB_PAGEUP ;
                              .OR. ;
                              LoWord( wParam ) == SB_PAGEDOWN ;
                              .OR. ;
                              LoWord( wParam ) == SB_TOP ;
                              .OR. ;
                              LoWord( wParam ) == SB_BOTTOM

               _DoWindowEventProcedure( _HMG_SYSDATA[ 99 ] [ i ], i, '' )

            ENDIF

         ENDIF

         i := ASCAN( _HMG_SYSDATA[ 5 ], lParam )

         IF i > 0

#ifdef COMPILEBROWSE

            IF _HMG_SYSDATA[ 1 ] [ i ] == 'BROWSE'

               IF LoWord( wParam ) == SB_LINEDOWN

                  setfocus( _HMG_SYSDATA[ 3 ] [ i ] )
                  InsertDown()

               ENDIF

               IF LoWord( wParam ) == SB_LINEUP

                  setfocus( _HMG_SYSDATA[ 3 ] [ i ] )
                  InsertUp()

               ENDIF

               IF LoWord( wParam ) == SB_PAGEUP
                  setfocus( _HMG_SYSDATA[ 3 ] [ i ] )
                  InsertPrior()
               ENDIF

               IF LoWord( wParam ) == SB_PAGEDOWN
                  setfocus( _HMG_SYSDATA[ 3 ] [ i ] )
                  InsertNext()
               ENDIF

               IF LoWord( wParam ) == SB_THUMBPOSITION

                  BackArea := ALIAS()
                  BrowseArea := _HMG_SYSDATA[ 22 ] [ i ]

                  IF SELECT ( BrowseArea ) != 0

                     SELECT &BrowseArea
                     BackRec := RECNO()

                     IF ORDKEYCOUNT() > 0
                        RecordCount := ORDKEYCOUNT()
                     ELSE
                        RecordCount := RECCOUNT()
                     ENDIF

                     SkipCount := INT( HIWORD( wParam ) * RecordCount / GetScrollRangeMax( _HMG_SYSDATA[ 5 ] [ i ], 2 ) )

                     IF SkipCount > ( RecordCount / 2 )
                        GO BOTTOM
                        SKIP - ( RecordCount - SkipCount )
                     ELSE
                        GO TOP
                        SKIP SkipCount
                     ENDIF

                     IF EOF()
                        SKIP - 1
                     ENDIF

                     nr := RECNO()

                     SetScrollPos( _HMG_SYSDATA[ 5 ] [ i ], 2, HIWORD( wParam ), .t. )

                     GO BackRec

                     IF SELECT ( BackArea ) != 0
                        SELECT &BackArea
                     ELSE
                        SELECT 0
                     ENDIF

                     _BrowseSetValue( '', '', nr, i )

                  ENDIF

               ENDIF

            ENDIF

#endif

         ENDIF

         i := ASCAN( _HMG_SYSDATA[ 3 ], lParam )
         IF ( i > 0 )
            IF LoWord( wParam ) == TB_ENDTRACK
               _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )
            ENDIF
         ENDIF

         // **********************************************************************
      CASE nMsg == WM_TASKBAR
         // **********************************************************************

         IF wParam == ID_TASKBAR .AND. lParam # WM_MOUSEMOVE
            aPos := GETCURSORPOS()

            DO CASE

               CASE lParam == WM_LBUTTONDOWN

                  i := ASCAN( _HMG_SYSDATA[ 67 ], hWnd )
                  IF i > 0
                     _DoWindowEventProcedure( _HMG_SYSDATA[ 84 ] [ i ], i, "TASKBAR" )                                                      //  ADD, November 2016
                  ENDIF

               CASE lParam == WM_RBUTTONDOWN

                  IF _HMG_SYSDATA[ 338 ] == .t.

                     I := ASCAN( _HMG_SYSDATA[ 67 ], hWnd )
                     IF i > 0
                        IF _HMG_SYSDATA[ 88 ] [ i ] != 0
                           TrackPopupMenu( _HMG_SYSDATA[ 88 ] [ i ], aPos[ 2 ], aPos[ 1 ], hWnd )
                        ENDIF
                     ENDIF

                  ENDIF

            ENDCASE
         ENDIF

         // **********************************************************************
      CASE nMsg == WM_NEXTDLGCTL
         // **********************************************************************
#if 0

         IF Wparam == 0
            NextControlHandle := GetNextDlgTabITem( GetActiveWindow(), GetFocus(), .F. )
         ELSE
            NextControlHandle := GetNextDlgTabITem( GetActiveWindow(), GetFocus(), .T. )
         ENDIF

#else   // by Dr. Claudio Soto, march 2017

         IF LOWORD( lParam ) <> 0                                     // if LOWORD( lParam ) == .T.

            NextControlHandle = wParam                                // wParam identifies the handle of the control that receives the focus

         ELSE                                                         // if LOWORD( lParam ) == .F.

            IF wParam == 0
               NextControlHandle := GetNextDlgTabITem( GetActiveWindow(), GetFocus(), .F. )                                                 // next control with the WS_TABSTOP style receives the focus
            ELSE
               NextControlHandle := GetNextDlgTabITem( GetActiveWindow(), GetFocus(), .T. )                                                 // previous control with the WS_TABSTOP style receives the focus
            ENDIF

         ENDIF

#endif

         setfocus( NextControlHandle )

         i := ASCAN( _HMG_SYSDATA[ 3 ], NextControlHandle )

         IF i > 0
            IF _HMG_SYSDATA[ 1 ] [ i ] == 'BUTTON'
               SendMessage( NextControlHandle, BM_SETSTYLE, LOWORD( BS_DEFPUSHBUTTON ), 1 )
            ELSEIF _HMG_SYSDATA[ 1 ] [ i ] == 'EDIT' .OR. _HMG_SYSDATA[ 1 ] [ i ] == 'TEXT'
               SendMessage( _HMG_SYSDATA[ 3 ] [ i ], EM_SETSEL, 0, - 1 )
            ENDIF
         ENDIF

         RETURN 0

         // **********************************************************************
      CASE nMsg == WM_HSCROLL
         // **********************************************************************

         i := ASCAN( _HMG_SYSDATA[ 67 ], hWnd )

         IF i > 0

            //  Horizontal ScrollBar Processing

            IF _HMG_SYSDATA[ 92 ] [ i ] > 0 .AND. lParam == 0

               IF _HMG_SYSDATA[ 87 ] [ i ] > 0
                  MsgHMGError( "SplitBox's Parent Window Can't Be a 'Virtual Dimensioned' Window (Use 'Virtual Dimensioned' SplitChild Instead). Program terminated" )
               ENDIF

               IF LoWord( wParam ) == SB_LINERIGHT

                  NewHPos := GetScrollPos( hwnd, SB_HORZ ) + _HMG_SYSDATA[ 345 ]
                  SetScrollPos( hwnd, SB_HORZ, NewHPos, .T. )

               ELSEIF LoWord( wParam ) == SB_LINELEFT

                  NewHPos := GetScrollPos( hwnd, SB_HORZ ) - _HMG_SYSDATA[ 345 ]
                  SetScrollPos( hwnd, SB_HORZ, NewHPos, .T. )

               ELSEIF LoWord( wParam ) == SB_PAGELEFT

                  NewHPos := GetScrollPos( hwnd, SB_HORZ ) - _HMG_SYSDATA[ 501 ]
                  SetScrollPos( hwnd, SB_HORZ, NewHPos, .T. )

               ELSEIF LoWord( wParam ) == SB_PAGERIGHT

                  NewHPos := GetScrollPos( hwnd, SB_HORZ ) + _HMG_SYSDATA[ 501 ]
                  SetScrollPos( hwnd, SB_HORZ, NewHPos, .T. )

               ELSEIF LoWord( wParam ) == SB_THUMBPOSITION

                  NewHPos := HIWORD( wParam )
                  SetScrollPos( hwnd, SB_HORZ, NewHPos, .T. )

               ENDIF

               IF _HMG_SYSDATA[ 91 ] [ i ] > 0
                  NewVPos := GetScrollPos( hwnd, SB_VERT )
               ELSE
                  NewVPos := 0
               ENDIF

               //  Panel Window Repositioning ( by Dr. Claudio Soto, April 2014 )

               IF LoWord( wParam ) == SB_THUMBPOSITION .OR. LoWord( wParam ) == SB_LINELEFT .OR. LoWord( wParam ) == SB_LINERIGHT .OR. LoWord( wParam ) == SB_PAGELEFT .OR. LoWord( wParam ) == SB_PAGERIGHT
                  FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 67 ] )
                     IF _HMG_SYSDATA[ 65 ] [ x ] == .F.
                        IF _HMG_SYSDATA[ 69 ] [ x ] == 'P' .AND. _HMG_SYSDATA[ 70 ] [ x ] == hWnd
                           MoveWindow( _HMG_SYSDATA[ 67 ] [ x ], _HMG_SYSDATA[ 504 ] [ x ] [ 1 ] - NewHPos, _HMG_SYSDATA[ 504 ] [ x ] [ 2 ] - NewVPos, _HMG_SYSDATA[ 504 ] [ x ] [ 3 ], _HMG_SYSDATA[ 504 ] [ x ] [ 4 ], .T. )
                           // RedrawWindow ( hWnd )
                        ENDIF
                     ENDIF
                  NEXT
               ENDIF

               //  Control Repositioning

               IF LoWord( wParam ) == SB_THUMBPOSITION .OR. LoWord( wParam ) == SB_LINELEFT .OR. LoWord( wParam ) == SB_LINERIGHT .OR. LoWord( wParam ) == SB_PAGELEFT .OR. LoWord( wParam ) == SB_PAGERIGHT

                  FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 3 ] )

                     IF _HMG_SYSDATA[ 4 ] [ x ] == hwnd

                        IF _HMG_SYSDATA[ 1 ] [ x ] == 'SPINNER'

                           MoveWindow( _HMG_SYSDATA[ 3 ] [ x ] [ 1 ], _HMG_SYSDATA[ 19 ] [ x ] - NewHPos, _HMG_SYSDATA[ 18 ] [ x ] - NewVPos, _HMG_SYSDATA[ 20 ] [ x ] - GetWindowWidth( _HMG_SYSDATA[ 3 ] [ x ] [ 2 ] ) + 1, _HMG_SYSDATA[ 21 ] [ x ], .t. )
                           MoveWindow( _HMG_SYSDATA[ 3 ] [ x ] [ 2 ], _HMG_SYSDATA[ 19 ] [ x ] + _HMG_SYSDATA[ 20 ] [ x ] - GetWindowWidth( _HMG_SYSDATA[ 3 ] [ x ] [ 2 ] ) - NewHPos, _HMG_SYSDATA[ 18 ] [ x ] - NewVPos, GetWindowWidth( _HMG_SYSDATA[ 3 ] [ x ] [ 2 ] ), _HMG_SYSDATA[ 21 ] [ x ], .t. )

#ifdef COMPILEBROWSE

                        ELSEIF _HMG_SYSDATA[ 1 ] [ x ] == 'BROWSE'

                           MoveWindow( _HMG_SYSDATA[ 3 ] [ x ], _HMG_SYSDATA[ 19 ] [ x ] - NewHPos, _HMG_SYSDATA[ 18 ] [ x ] - NewVPos, _HMG_SYSDATA[ 20 ] [ x ] - GETVSCROLLBARWIDTH(), _HMG_SYSDATA[ 21 ] [ x ], .t. )
                           MoveWindow( _HMG_SYSDATA[ 5 ] [ x ], _HMG_SYSDATA[ 19 ] [ x ] + _HMG_SYSDATA[ 20 ] [ x ] - GETVSCROLLBARWIDTH() - NewHPos, _HMG_SYSDATA[ 18 ] [ x ] - NewVPos, GetWindowWidth( _HMG_SYSDATA[ 5 ] [ x ] ), GetWindowHeight( _HMG_SYSDATA[ 5 ] [ x ] ), .t. )
                           MoveWindow( _HMG_SYSDATA[ 39 ] [ x ] [ 1 ], _HMG_SYSDATA[ 19 ] [ x ] + _HMG_SYSDATA[ 20 ] [ x ] - GETVSCROLLBARWIDTH() - NewHPos, _HMG_SYSDATA[ 18 ] [ x ] + _HMG_SYSDATA[ 21 ] [ x ] - GethScrollBarHeight() - NewVPos, GetWindowWidth( _HMG_SYSDATA[ 39 ] [ x ] [ 1 ] ), GetWindowHeight( _HMG_SYSDATA[ 39 ] [ x ] [ 1 ] ), .t. )
                           ReDrawWindow( _HMG_SYSDATA[ 3 ] [ x ] )

#endif

                        ELSEIF _HMG_SYSDATA[ 1 ] [ x ] == 'RADIOGROUP'

                           IF _HMG_SYSDATA[ 8 ] [ x ] == .F.

                              FOR z := 1 TO HMG_LEN( _HMG_SYSDATA[ 3 ] [ x ] )
                                 MoveWindow( _HMG_SYSDATA[ 3 ] [ x ] [ z ], _HMG_SYSDATA[ 19 ] [ x ] - NewHPos, _HMG_SYSDATA[ 18 ] [ x ] - NewVPos + ( ( z - 1 ) * _HMG_SYSDATA[ 22 ] [ x ] ), _HMG_SYSDATA[ 20 ] [ x ], _HMG_SYSDATA[ 21 ] [ x ] / HMG_LEN( _HMG_SYSDATA[ 3 ] [ x ] ), .t. )
                              NEXT z

                           ELSE

                              FOR z := 1 TO HMG_LEN( _HMG_SYSDATA[ 3 ] [ x ] )
                                 MoveWindow( _HMG_SYSDATA[ 3 ] [ x ] [ z ], _HMG_SYSDATA[ 19 ] [ x ] - NewHPos + ( z - 1 ) * _HMG_SYSDATA[ 22 ] [ x ], _HMG_SYSDATA[ 18 ] [ x ] - NewVPos, _HMG_SYSDATA[ 20 ] [ x ] / HMG_LEN( _HMG_SYSDATA[ 3 ] [ x ] ), _HMG_SYSDATA[ 21 ] [ x ], .t. )
                              NEXT z

                           ENDIF

                        ELSEIF _HMG_SYSDATA[ 1 ] [ x ] == 'TOOLBAR'

                           MsgHMGError( "ToolBar's Parent Window Can't Be a 'Virtual Dimensioned' Window (Use 'Virtual Dimensioned' SplitChild Instead). Program terminated" )

                        ELSEIF _HMG_SYSDATA[ 1 ] [ x ] == 'STATUSBAR'                                                                       // Dr. Claudio Soto (November 2013)
                           // No change

                        ELSE

                           MoveWindow( _HMG_SYSDATA[ 3 ] [ x ], _HMG_SYSDATA[ 19 ] [ x ] - NewHPos, _HMG_SYSDATA[ 18 ] [ x ] - NewVPos, _HMG_SYSDATA[ 20 ] [ x ], _HMG_SYSDATA[ 21 ] [ x ], .t. )

                        ENDIF

                     ENDIF
                  NEXT x

                  RedrawWindow( hwnd )

               ENDIF

            ENDIF

            IF LoWord( wParam ) == SB_LINERIGHT

               _DoWindowEventProcedure( _HMG_SYSDATA[ 97 ] [ i ], i, '' )

            ELSEIF LoWord( wParam ) == SB_LINELEFT

               _DoWindowEventProcedure( _HMG_SYSDATA[ 96 ] [ i ], i, '' )

            ELSEIF LoWord( wParam ) == SB_THUMBPOSITION ;
                              .OR. ;
                              LoWord( wParam ) == SB_PAGELEFT ;
                              .OR. ;
                              LoWord( wParam ) == SB_PAGERIGHT

               _DoWindowEventProcedure( _HMG_SYSDATA[ 98 ] [ i ], i, '' )

            ENDIF

         ENDIF

         i := ASCAN( _HMG_SYSDATA[ 3 ], lParam )
         IF ( i > 0 )
            IF LoWord( wParam ) == TB_ENDTRACK
               _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )
            ENDIF
         ENDIF

         // **********************************************************************
      CASE nMsg == WM_PAINT
         // **********************************************************************

         i := ASCAN( _HMG_SYSDATA[ 67 ], hWnd )
         IF i > 0
            _DoWindowEventProcedure( _HMG_SYSDATA[ 80 ] [ i ], i, '' )                                                                      // _HMG_aFormPaintProcedure
            FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 102 ] [ i ] )
               EVAL( _HMG_SYSDATA[ 102 ] [ i ] [ x ] )                // _HMG_aFormGraphTasks
            NEXT x
         ENDIF

         FormCount := HMG_LEN( _HMG_SYSDATA[ 67 ] )
         FOR z := 1 TO FormCount
            // _HMG_aFormDeleted_                       _HMG_aFormType ---> X = SplitChildWindow
            IF _HMG_SYSDATA[ 65 ] [ z ] == .F. .AND. _HMG_SYSDATA[ 69 ] [ z ] == 'X'
               _DoWindowEventProcedure( _HMG_SYSDATA[ 80 ] [ z ], z, '' )                                                                   // _HMG_aFormPaintProcedure
               IF VALTYPE( _HMG_SYSDATA[ 102 ] [ z ] ) == 'A'
                  FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 102 ] [ z ] )
                     EVAL( _HMG_SYSDATA[ 102 ] [ z ] [ x ] )          // _HMG_aFormGraphTasks
                  NEXT x
               ENDIF
            ENDIF
         NEXT z

         RepositionToolBar( i )

         RETURN 0                                                     //call DefWindowProc( hWnd, nMsg, wParam, lParam )

         // **********************************************************************
      CASE nMsg == WM_LBUTTONDOWN
         // **********************************************************************

         _HMG_SYSDATA[ 191 ] := HIWORD( lParam )
         _HMG_SYSDATA[ 192 ] := LOWORD( lParam )
         _HMG_SYSDATA[ 193 ] := 1

         i := ASCAN( _HMG_SYSDATA[ 67 ], hWnd )

         IF i > 0

            IF _HMG_SYSDATA[ 91 ] [ i ] > 0
               _HMG_SYSDATA[ 191 ] := _HMG_SYSDATA[ 191 ] + GetScrollPos( hwnd, SB_VERT )
            ENDIF

            IF _HMG_SYSDATA[ 92 ] [ i ] > 0
               _HMG_SYSDATA[ 192 ] := _HMG_SYSDATA[ 192 ] + GetScrollPos( hwnd, SB_HORZ )
            ENDIF

            _DoWindowEventProcedure( _HMG_SYSDATA[ 77 ] [ i ], i, '' )

         ENDIF

         // **********************************************************************
      CASE nMsg == WM_LBUTTONUP
         // **********************************************************************

         _HMG_SYSDATA[ 193 ] := 0

         // **********************************************************************
      CASE nMsg == WM_NCMOUSEMOVE
         // **********************************************************************
         // Dr. Claudio Soto (June 2013)
         i := ASCAN( _HMG_SYSDATA[ 67 ], hWnd )
         IF i > 0
            _HMG_LastFormIndexWithCursor := i
         ENDIF

         // **********************************************************************
      CASE nMsg == WM_MOUSEMOVE
         // **********************************************************************

         _HMG_SYSDATA[ 191 ] := HIWORD( lParam )
         _HMG_SYSDATA[ 192 ] := LOWORD( lParam )

         I := ASCAN( _HMG_SYSDATA[ 67 ], hWnd )
         IF i > 0

            _HMG_LastFormIndexWithCursor := i

            IF _HMG_SYSDATA[ 91 ] [ i ] > 0
               _HMG_SYSDATA[ 191 ] := _HMG_SYSDATA[ 191 ] + GetScrollPos( hwnd, SB_VERT )
            ENDIF

            IF _HMG_SYSDATA[ 92 ] [ i ] > 0
               _HMG_SYSDATA[ 192 ] := _HMG_SYSDATA[ 192 ] + GetScrollPos( hwnd, SB_HORZ )
            ENDIF

            IF wParam == MK_LBUTTON
               _DoWindowEventProcedure( _HMG_SYSDATA[ 75 ] [ i ], i, "MOUSEMOVE" )
            ELSE
               _DoWindowEventProcedure( _HMG_SYSDATA[ 78 ] [ i ], i, "MOUSEMOVE" )
            ENDIF

         ENDIF

         // **********************************************************************
      CASE nMsg == WM_CONTEXTMENU
         // **********************************************************************

         // Dr. Claudio Soto (May 2013)

         _HMG_ControlHandle := wParam
         _HMG_MouseRow := HIWORD( lParam )
         _HMG_MouseCol := LOWORD( lParam )
         _HMG_ControlContextMenu := 0
         i := 0

         IF _HMG_SetControlContextMenu == .T.
            FOR k = 1 TO HMG_LEN( _HMG_SYSDATA[ 1 ] )
               IF ( _HMG_SYSDATA[ 1 ] [ k ] == "MENU" ) .AND. ( _HMG_SYSDATA[ 12 ] [ k ] == "CONTROL_MENU_ITEM" ) .AND. _TestControlHandle_ContextMenu( _HMG_SYSDATA[ 18 ] [ k ], _HMG_ControlHandle )
                  _HMG_ControlContextMenu := _HMG_SYSDATA[ 7 ] [ k ]
                  i := k
                  EXIT
               ENDIF
            NEXT

            IF i > 0
               SetFocus( _HMG_ControlHandle )
               TrackPopupMenu( _HMG_ControlContextMenu, _HMG_MouseCol, _HMG_MouseRow, hWnd )
            ENDIF
         ENDIF

         IF _HMG_SYSDATA[ 338 ] == .t.

            _HMG_SYSDATA[ 191 ] := HIWORD( lParam )
            _HMG_SYSDATA[ 192 ] := LOWORD( lParam )

            setfocus( wParam )

            I := ASCAN( _HMG_SYSDATA[ 67 ], hWnd )
            IF i > 0
               IF _HMG_SYSDATA[ 74 ] [ i ] != 0
                  IF _HMG_SYSDATA[ 91 ] [ i ] > 0
                     _HMG_SYSDATA[ 191 ] := _HMG_SYSDATA[ 191 ] + GetScrollPos( hwnd, SB_VERT )
                  ENDIF
                  IF _HMG_SYSDATA[ 92 ] [ i ] > 0
                     _HMG_SYSDATA[ 192 ] := _HMG_SYSDATA[ 192 ] + GetScrollPos( hwnd, SB_HORZ )
                  ENDIF
                  TrackPopupMenu( _HMG_SYSDATA[ 74 ] [ i ], LOWORD( lparam ), HIWORD( lparam ), hWnd )
               ENDIF
            ENDIF

         ENDIF

         // **********************************************************************
      CASE nMsg == WM_TIMER
         // **********************************************************************

         i := ASCAN( _HMG_SYSDATA[ 5 ], wParam )

         IF i > 0
            _DoControlEventProcedure( _HMG_SYSDATA[ 6 ] [ i ], i )
         ENDIF

         // **********************************************************************
      CASE nMsg == WM_SIZE
         // **********************************************************************

#if 0

         // REMOVE3
         /*
      i := aScan ( _HMG_SYSDATA [ 67  ] , hWnd )

      if i > 0

         If _HMG_SYSDATA [ 263 ] == .T.   // _HMG_MainActive

            If wParam == SIZE_MAXIMIZED

               _DoWindowEventProcedure ( _HMG_SYSDATA [ 103  ]  [i] , i , '' )

            ElseIf wParam == SIZE_MINIMIZED

               _DoWindowEventProcedure ( _HMG_SYSDATA [ 104  ]  [i] , i , '' )

            Else

               _DoWindowEventProcedure ( _HMG_SYSDATA [ 76  ]  [i] , i , '' )

            EndIf

         EndIf

         If _HMG_SYSDATA [ 87 ] [i] > 0
            SizeRebar ( _HMG_SYSDATA [ 87 ] [i] )
            RedrawWindow  ( _HMG_SYSDATA [ 87 ] [i] )
         EndIf

      EndIf

      ControlCount := HMG_LEN (_HMG_SYSDATA [3])

      For i = 1 to ControlCount
         if _HMG_SYSDATA [4] [i] == hWnd   // ParentHandle
            if _HMG_SYSDATA [1] [i] == "STATUSBAR"
               MoveWindow( _HMG_SYSDATA [3] [i] , 0 , 0 , 0 , 0 , .T. )
               SetStatusBarSize ( hWnd , _HMG_SYSDATA [3] [i] , _HMG_SYSDATA [ 20 ] [i] )
               EXIT
            endif
        EndIf
      Next

      For i = 1 to ControlCount
         if _HMG_SYSDATA [4] [i] == hWnd   // ParentHandle
            if _HMG_SYSDATA [1] [i] == "TOOLBAR"
               SendMessage( _HMG_SYSDATA [3] [i] , TB_AUTOSIZE , 0 , 0 )
            EndIf
         EndIf
      Next
*/
#else

         ControlCount := HMG_LEN( _HMG_SYSDATA[ 3 ] )

         FOR i = 1 TO ControlCount
            IF _HMG_SYSDATA[ 4 ] [ i ] == hWnd                        // ParentHandle

               IF _HMG_SYSDATA[ 1 ] [ i ] == "TOOLBAR"
                  SendMessage( _HMG_SYSDATA[ 3 ] [ i ], TB_AUTOSIZE, 0, 0 )

               ELSEIF _HMG_SYSDATA[ 1 ] [ i ] == "STATUSBAR"
                  MoveWindow( _HMG_SYSDATA[ 3 ] [ i ], 0, 0, 0, 0, .T. )
                  SetStatusBarSize( hWnd, _HMG_SYSDATA[ 3 ] [ i ], _HMG_SYSDATA[ 20 ] [ i ] )
               ENDIF

            ENDIF
         NEXT

         i := ASCAN( _HMG_SYSDATA[ 67 ], hWnd )

         IF i > 0                                                     // ADD3

            IF _HMG_SYSDATA[ 87 ] [ i ] > 0
               SizeRebar( _HMG_SYSDATA[ 87 ] [ i ] )                  // resize SplitBox
               RedrawWindow( _HMG_SYSDATA[ 87 ] [ i ] )
            ENDIF

            IF _HMG_SYSDATA[ 263 ] == .T. .OR. ;                      // _HMG_MainActive
                       _HMG_SYSDATA[ 68 ] [ i ] == .T.                // _HMG_aFormActive

               IF wParam == SIZE_MAXIMIZED
                  _DoWindowEventProcedure( _HMG_SYSDATA[ 103 ] [ i ], i, '' )                                                               // On Maximize

               ELSEIF wParam == SIZE_MINIMIZED
                  _DoWindowEventProcedure( _HMG_SYSDATA[ 104 ] [ i ], i, '' )                                                               // On Minimize

               ELSE
                  _DoWindowEventProcedure( _HMG_SYSDATA[ 76 ] [ i ], i, '' )                                                                // On Size

               ENDIF

            ENDIF

         ENDIF

#endif

         // **********************************************************************
      CASE nMsg == WM_COMMAND
         // **********************************************************************

         ControlCount := HMG_LEN( _HMG_SYSDATA[ 3 ] )

         // ...............................................
         //  Search Control From Received Id LoWord(wParam)
         // ...............................................

         i := ASCAN( _HMG_SYSDATA[ 5 ], LoWord( wParam ) )

         IF i > 0

            //  Process Menus .......................................

            IF HiWord( wParam ) == 0 .AND. _HMG_SYSDATA[ 1 ] [ i ] = "MENU"
               _DoControlEventProcedure( _HMG_SYSDATA[ 6 ] [ i ], i )
               RETURN 0
            ENDIF

            //  Process ToolBar Buttons ............................

            IF _HMG_SYSDATA[ 1 ] [ i ] = "TOOLBUTTON"
               _DoControlEventProcedure( _HMG_SYSDATA[ 6 ] [ i ], i )
               RETURN 0
            ENDIF

         ENDIF

         // ..............................................
         //  Search Control From Received Handle (lparam)
         // ..............................................

         i := ASCAN( _HMG_SYSDATA[ 3 ], lParam )

         //  If Handle Not Found, Look For Spinner

         IF i == 0
            FOR x := 1 TO ControlCount
               IF VALTYPE( _HMG_SYSDATA[ 3 ] [ x ] ) == 'A'
                  IF _HMG_SYSDATA[ 3 ] [ x ] [ 1 ] == lParam .AND. _HMG_SYSDATA[ 1 ] [ x ] == 'SPINNER'
                     i := x
                     EXIT
                  ENDIF
               ENDIF
            NEXT x
         ENDIF

         // ................................
         //  Process Command (Handle based)
         // ................................

         IF ( i > 0 )

            //  Button Click ........................................

            IF HIWORD( wParam ) == BN_CLICKED .AND. _HMG_SYSDATA[ 1 ] [ i ] = "BUTTON"

               SetFocus( _HMG_SYSDATA[ 3 ] [ i ] )
               SendMessage( _HMG_SYSDATA[ 3 ] [ i ], 244, LOWORD( 1 ), 1 )

               _DoControlEventProcedure( _HMG_SYSDATA[ 6 ] [ i ], i )

               RETURN 0
            ENDIF

            //  CheckBox Click ......................................

            IF HIWORD( wParam ) == BN_CLICKED .AND. _HMG_SYSDATA[ 1 ] [ i ] = "CHECKBOX"
               _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )
               RETURN 0
            ENDIF

            //  Label / HyperLink / Image Click .....................

            IF HiWord( wParam ) == STN_CLICKED .AND. ( _HMG_SYSDATA[ 1 ] [ i ] = "LABEL" .OR. _HMG_SYSDATA[ 1 ] [ i ] = "IMAGE" )
               _DoControlEventProcedure( _HMG_SYSDATA[ 6 ] [ i ], i )
               RETURN 0
            ENDIF

            //  Process Richedit Area Change ........................ ( Dr. Claudio Soto, January 2014 )

            IF HiWord( wParam ) == EN_VSCROLL .AND. ( _HMG_SYSDATA[ 1 ] [ i ] == "RICHEDIT" )
               _DoControlEventProcedure( _HMG_SYSDATA[ 32 ] [ i ], i )
               RETURN 0
            ENDIF

            //  TextBox Change ......................................

            IF HiWord( wParam ) == EN_CHANGE

               IF _HMG_SYSDATA[ 253 ] == .T.
                  _HMG_SYSDATA[ 253 ] := .F.
               ELSE

                  IF HMG_LEN( _HMG_SYSDATA[ 9 ] [ i ] ) > 0

                     IF _HMG_SYSDATA[ 1 ] [ i ] == 'MASKEDTEXT'

                        IF _HMG_SYSDATA[ 22 ] [ i ] == .T.
                           ProcessCharmask( i, .t. )
                        ENDIF

                        _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )

                     ELSEIF _HMG_SYSDATA[ 1 ] [ i ] == 'CHARMASKTEXT'

                        ProcessCharMask( i )

                        _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )

                     ENDIF

                  ELSE

                     IF _HMG_SYSDATA[ 1 ] [ i ] == 'NUMTEXT'
                        ProcessNumText( i )
                     ENDIF

                     _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )

                  ENDIF

               ENDIF

               RETURN 0

            ENDIF

            //  TextBox LostFocus ...................................

            IF HiWord( wParam ) == EN_KILLFOCUS

               _HMG_SYSDATA[ 243 ] := .T.

               IF _HMG_SYSDATA[ 1 ] [ i ] == 'MASKEDTEXT'

                  _HMG_SYSDATA[ 22 ] [ i ] := .F.

                  IF "E" $ _HMG_SYSDATA[ 7 ] [ i ]

                     Ts := GetWindowText( _HMG_SYSDATA[ 3 ] [ i ] )

                     IF "." $ _HMG_SYSDATA[ 7 ] [ i ]
                        DO CASE
                           CASE HB_UAT( '.', Ts ) > HB_UAT( ',', Ts )
                              SetWindowText( _HMG_SYSDATA[ 3 ] [ i ], TRANSFORM( GetNumFromText( GetWindowText( _HMG_SYSDATA[ 3 ] [ i ] ), i ), _HMG_SYSDATA[ 7 ] [ i ] ) )
                           CASE HB_UAT( ',', Ts ) > HB_UAT( '.', Ts )
                              SetWindowText( _HMG_SYSDATA[ 3 ] [ i ], TRANSFORM( GetNumFromTextSp( GetWindowText( _HMG_SYSDATA[ 3 ] [ i ] ), i ), _HMG_SYSDATA[ 7 ] [ i ] ) )
                        ENDCASE
                     ELSE
                        DO CASE
                           CASE HB_UAT( '.', Ts ) != 0
                              SetWindowText( _HMG_SYSDATA[ 3 ] [ i ], TRANSFORM( GetNumFromTextSp( GetWindowText( _HMG_SYSDATA[ 3 ] [ i ] ), i ), _HMG_SYSDATA[ 7 ] [ i ] ) )
                           CASE HB_UAT( ',', Ts ) != 0
                              SetWindowText( _HMG_SYSDATA[ 3 ] [ i ], TRANSFORM( GetNumFromText( GetWindowText( _HMG_SYSDATA[ 3 ] [ i ] ), i ), _HMG_SYSDATA[ 7 ] [ i ] ) )
                           OTHERWISE
                              SetWindowText( _HMG_SYSDATA[ 3 ] [ i ], TRANSFORM( GetNumFromText( GetWindowText( _HMG_SYSDATA[ 3 ] [ i ] ), i ), _HMG_SYSDATA[ 7 ] [ i ] ) )
                        ENDCASE
                     ENDIF
                  ELSE
                     SetWindowText( _HMG_SYSDATA[ 3 ] [ i ], TRANSFORM( GetNumFromText( GetWindowText( _HMG_SYSDATA[ 3 ] [ i ] ), i ), _HMG_SYSDATA[ 7 ] [ i ] ) )
                  ENDIF

               ENDIF

               IF _HMG_SYSDATA[ 1 ] [ i ] == 'CHARMASKTEXT'
                  IF VALTYPE( _HMG_SYSDATA[ 17 ] [ i ] ) == 'L'
                     IF _HMG_SYSDATA[ 17 ] [ i ] == .T.
                        _HMG_SYSDATA[ 253 ] := .T.
                        SetWindowText( _HMG_SYSDATA[ 3 ] [ i ], DTOC( CTOD( GetWindowText( _HMG_SYSDATA[ 3 ] [ i ] ) ) ) )
                     ENDIF
                  ENDIF
               ENDIF

               IF _HMG_SYSDATA[ 252 ] != .T.
                  _DoControlEventProcedure( _HMG_SYSDATA[ 10 ] [ i ], i )
               ENDIF

               _HMG_SYSDATA[ 243 ] := .F.

               RETURN 0

            ENDIF

            //  TextBox GotFocus ....................................

            IF HIWORD( wParam ) == EN_SETFOCUS

               _HMG_SYSDATA[ 242 ] := .T.

               VirtualChildControlFocusProcess( _HMG_SYSDATA[ 3 ] [ i ], _HMG_SYSDATA[ 4 ] [ i ] )

               IF _HMG_SYSDATA[ 1 ] [ i ] == 'MASKEDTEXT'

                  IF "E" $ _HMG_SYSDATA[ 7 ] [ i ]

                     Ts := GetWindowText( _HMG_SYSDATA[ 3 ] [ i ] )

                     IF "." $ _HMG_SYSDATA[ 7 ] [ i ]
                        DO CASE
                           CASE HB_UAT( '.', Ts ) > HB_UAT( ',', Ts )
                              SetWindowText( _HMG_SYSDATA[ 3 ] [ i ], TRANSFORM( GetNumFromText( GetWindowText( _HMG_SYSDATA[ 3 ] [ i ] ), i ), _HMG_SYSDATA[ 9 ] [ i ] ) )
                           CASE HB_UAT( ',', Ts ) > HB_UAT( '.', Ts )
                              TmpStr := TRANSFORM( GetNumFromTextSP( GetWindowText( _HMG_SYSDATA[ 3 ] [ i ] ), i ), _HMG_SYSDATA[ 9 ] [ i ] )
                              IF VAL( TmpStr ) == 0
                                 TmpStr := HB_UTF8STRTRAN( TmpStr, '0.', ' .' )
                              ENDIF
                              SetWindowText( _HMG_SYSDATA[ 3 ] [ i ], TmpStr )
                        ENDCASE
                     ELSE
                        DO CASE
                           CASE HB_UAT( '.', Ts ) != 0
                              SetWindowText( _HMG_SYSDATA[ 3 ] [ i ], TRANSFORM( GetNumFromTextSP( GetWindowText( _HMG_SYSDATA[ 3 ] [ i ] ), i ), _HMG_SYSDATA[ 9 ] [ i ] ) )
                           CASE HB_UAT( ',', Ts ) != 0
                              SetWindowText( _HMG_SYSDATA[ 3 ] [ i ], TRANSFORM( GetNumFromText( GetWindowText( _HMG_SYSDATA[ 3 ] [ i ] ), i ), _HMG_SYSDATA[ 9 ] [ i ] ) )
                           OTHERWISE
                              SetWindowText( _HMG_SYSDATA[ 3 ] [ i ], TRANSFORM( GetNumFromText( GetWindowText( _HMG_SYSDATA[ 3 ] [ i ] ), i ), _HMG_SYSDATA[ 9 ] [ i ] ) )
                        ENDCASE
                     ENDIF
                  ELSE
                     TmpStr := TRANSFORM( GetNumFromText( GetWindowText( _HMG_SYSDATA[ 3 ] [ i ] ), i ), _HMG_SYSDATA[ 9 ] [ i ] )

                     IF VAL( TmpStr ) == 0
                        TmpStr := HB_UTF8STRTRAN( TmpStr, '0.', ' .' )
                     ENDIF

                     SetWindowText( _HMG_SYSDATA[ 3 ] [ i ], TmpStr )
                  ENDIF

                  SendMessage( _HMG_SYSDATA[ 3 ] [ i ], EM_SETSEL, 0, - 1 )

                  _HMG_SYSDATA[ 22 ] [ i ] := .T.

               ENDIF

               IF _HMG_SYSDATA[ 1 ] [ i ] == 'CHARMASKTEXT'

                  FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 9 ] [ i ] )
                     IF HMG_ISDIGIT( HB_USUBSTR( _HMG_SYSDATA[ 9 ] [ i ], x, 1 ) ) .OR. HMG_ISALPHA( HB_USUBSTR( _HMG_SYSDATA[ 9 ] [ i ], x, 1 ) ) .OR. HB_USUBSTR( _HMG_SYSDATA[ 9 ] [ i ], x, 1 ) == '!'
                        MaskStart := x
                        EXIT
                     ENDIF
                  NEXT x

                  IF MaskStart == 1
                     SendMessage( _HMG_SYSDATA[ 3 ] [ i ], EM_SETSEL, 0, - 1 )
                  ELSE
                     SendMessage( _HMG_SYSDATA[ 3 ] [ i ], EM_SETSEL, MaskStart - 1, - 1 )
                  ENDIF

               ENDIF

               _DoControlEventProcedure( _HMG_SYSDATA[ 11 ] [ i ], i )

               _HMG_SYSDATA[ 242 ] := .F.

               RETURN 0

            ENDIF

            //  ListBox OnChange ....................................

            IF HIWORD( wParam ) == LBN_SELCHANGE .AND. ( _HMG_SYSDATA[ 1 ] [ i ] == 'LIST' .OR. _HMG_SYSDATA[ 1 ] [ i ] == 'MULTILIST' )
               _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )
               RETURN 0
            ENDIF

            //  ListBox Double Click ................................

            IF HIWORD( wParam ) == LBN_DBLCLK
               _DoControlEventProcedure( _HMG_SYSDATA[ 16 ] [ i ], i )
               RETURN 0
            ENDIF

            //  ComboBox Change .....................................

            IF HiWord( wParam ) == CBN_SELCHANGE .AND. _HMG_SYSDATA[ 1 ] [ i ] == 'COMBO'
               _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )
               RETURN 0
            ENDIF

            //  ComboBox OnCancel .....................................

            IF HiWord( wParam ) == CBN_SELENDCANCEL .AND. _HMG_SYSDATA[ 1 ] [ i ] == 'COMBO'
               _DoControlEventProcedure( _HMG_SYSDATA[ 32 ] [ i ], i )
               RETURN 0
            ENDIF

            //  ComboBox OnDropDown .....................................

            IF HiWord( wParam ) == CBN_DROPDOWN .AND. _HMG_SYSDATA[ 1 ] [ i ] == 'COMBO'
               _DoControlEventProcedure( _HMG_SYSDATA[ 39 ] [ i ], i )
               RETURN 0
            ENDIF

            //  ComboBox OnCloseUp .....................................

            IF HiWord( wParam ) == CBN_CLOSEUP .AND. _HMG_SYSDATA[ 1 ] [ i ] == 'COMBO'
               _DoControlEventProcedure( _HMG_SYSDATA[ 37 ] [ i ], i )
               RETURN 0
            ENDIF

            //  ComboBox LostFocus ..................................

            IF HiWord( wParam ) == CBN_KILLFOCUS .AND. _HMG_SYSDATA[ 1 ] [ i ] == 'COMBO'
               _DoControlEventProcedure( _HMG_SYSDATA[ 10 ] [ i ], i )
               RETURN 0
            ENDIF

            //  ComboBox GotFocus ...................................

            IF HiWord( wParam ) == CBN_SETFOCUS .AND. _HMG_SYSDATA[ 1 ] [ i ] == 'COMBO'
               VirtualChildControlFocusProcess( _HMG_SYSDATA[ 3 ] [ i ], _HMG_SYSDATA[ 4 ] [ i ] )
               _DoControlEventProcedure( _HMG_SYSDATA[ 11 ] [ i ], i )
               RETURN 0
            ENDIF

            //  Process Combo Display Area Change ...................

            IF HiWord( wParam ) == CBN_EDITCHANGE .AND. _HMG_SYSDATA[ 1 ] [ i ] == 'COMBO'
               _DoControlEventProcedure( _HMG_SYSDATA[ 6 ] [ i ], i )
               RETURN 0
            ENDIF

            //  Button LostFocus ....................................

            IF HIWORD( wParam ) == BN_KILLFOCUS .AND. _HMG_SYSDATA[ 1 ] [ i ] <> 'COMBO'
               _DoControlEventProcedure( _HMG_SYSDATA[ 10 ] [ i ], i )
               RETURN 0
            ENDIF

            //  Button GotFocus .....................................

            IF HIWORD( wParam ) == BN_SETFOCUS
               VirtualChildControlFocusProcess( _HMG_SYSDATA[ 3 ] [ i ], _HMG_SYSDATA[ 4 ] [ i ] )
               _DoControlEventProcedure( _HMG_SYSDATA[ 11 ] [ i ], i )
               RETURN 0
            ENDIF

            //  ListBox LostFocus ...................................

            IF HIWORD( wParam ) == LBN_KILLFOCUS .AND. ( _HMG_SYSDATA[ 1 ] [ i ] = "LIST" .OR. _HMG_SYSDATA[ 1 ] [ i ] = "MULTILIST" )
               _DoControlEventProcedure( _HMG_SYSDATA[ 10 ] [ i ], i )
               RETURN 0
            ENDIF

            //  ListBox GotFocus ....................................

            IF HIWORD( wParam ) == LBN_SETFOCUS .AND. ( _HMG_SYSDATA[ 1 ] [ i ] = "LIST" .OR. _HMG_SYSDATA[ 1 ] [ i ] = "MULTILIST" )
               VirtualChildControlFocusProcess( _HMG_SYSDATA[ 3 ] [ i ], _HMG_SYSDATA[ 4 ] [ i ] )
               _DoControlEventProcedure( _HMG_SYSDATA[ 11 ] [ i ], i )
               RETURN 0
            ENDIF

            //  Process Combo Display Area Change ...................

            IF HIWORD( wParam ) == CBN_EDITCHANGE .AND. _HMG_SYSDATA[ 1 ] [ i ] == 'COMBO'
               _DoControlEventProcedure( _HMG_SYSDATA[ 6 ] [ i ], i )
               RETURN 0
            ENDIF

         ELSE

            //  Process RadioGrop ...................................

            IF HIWORD( wParam ) == BN_CLICKED
               FOR i := 1 TO ControlCount
                  IF VALTYPE( _HMG_SYSDATA[ 3 ] [ i ] ) == "A" .AND. _HMG_SYSDATA[ 4 ] [ i ] == hWnd
                     FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 3 ] [ i ] )
                        IF _HMG_SYSDATA[ 3 ] [ i ] [ x ] == lParam
                           _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )
                           IF _HMG_SYSDATA[ 25 ] [ i ] == .F.         // No TabStop
                              IF IsTabStop( _HMG_SYSDATA[ 3 ] [ i ] [ x ] )
                                 SetTabStop( _HMG_SYSDATA[ 3 ] [ i ] [ x ], .f. )
                              ENDIF
                           ENDIF
                           RETURN 0
                        ENDIF
                     NEXT x
                  ENDIF
               NEXT i

            ELSEIF HIWORD( wParam ) == BN_SETFOCUS

               FOR i := 1 TO ControlCount
                  IF VALTYPE( _HMG_SYSDATA[ 3 ] [ i ] ) == "A" .AND. _HMG_SYSDATA[ 4 ] [ i ] == hWnd
                     FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 3 ] [ i ] )
                        IF _HMG_SYSDATA[ 3 ] [ i ] [ x ] == lParam
                           VirtualChildControlFocusProcess( _HMG_SYSDATA[ 3 ] [ i ] [ x ], _HMG_SYSDATA[ 4 ] [ i ] )
                           IF _HMG_SYSDATA[ 25 ] [ i ] == .F.         // No TabStop
                              IF IsTabStop( _HMG_SYSDATA[ 3 ] [ i ] [ x ] )
                                 SetTabStop( _HMG_SYSDATA[ 3 ] [ i ] [ x ], .f. )
                              ENDIF
                           ENDIF
                           RETURN 0
                        ENDIF
                     NEXT x
                  ENDIF
               NEXT i

            ENDIF

         ENDIF

         // ...................
         //  Process Enter Key
         // ...................

         i := ASCAN( _HMG_SYSDATA[ 3 ], GetFocus() )

         IF i > 0

            //  CheckBox Enter ( Pablo Cesar, December 2014 ) .......................................

            IF _HMG_SYSDATA[ 1 ] [ i ] = "CHECKBOX" .AND. ( HiWord( wParam ) == 0 .AND. LoWord( wParam ) == 1 )
               _DoControlEventProcedure( _HMG_SYSDATA[ 6 ] [ i ], i )
               IF _HMG_SYSDATA[ 255 ] == .T.                          // If Set ExtendedNavigation
                  _SetNextFocus()
               ENDIF
               RETURN 0
            ENDIF

            //  DatePicker Enter ......................................

            IF _HMG_SYSDATA[ 1 ] [ i ] = "DATEPICK" .AND. ( HiWord( wParam ) == 0 .AND. LoWord( wParam ) == 1 )
               _DoControlEventProcedure( _HMG_SYSDATA[ 6 ] [ i ], i )
               IF _HMG_SYSDATA[ 255 ] == .T.                          // If Set ExtendedNavigation
                  _SetNextFocus()
               ENDIF
               RETURN 0
            ENDIF

            //  TimePicker Enter ( Dr. Claudio Soto, April 2013 ) ......................................

            IF _HMG_SYSDATA[ 1 ] [ i ] = "TIMEPICK" .AND. ( HiWord( wParam ) == 0 .AND. LoWord( wParam ) == 1 )
               _DoControlEventProcedure( _HMG_SYSDATA[ 6 ] [ i ], i )
               IF _HMG_SYSDATA[ 255 ] == .T.                          // If Set ExtendedNavigation
                  _SetNextFocus()
               ENDIF
               RETURN 0
            ENDIF

            //  Browse Enter ..........................................

#ifdef COMPILEBROWSE

            IF _HMG_SYSDATA[ 1 ] [ i ] = "BROWSE" .AND. lparam == 0 .AND. wparam == 1

               IF _HMG_SYSDATA[ 39 ] [ i ] [ 6 ] == .T.
                  ProcessInPlaceKbdEdit( i )
               ELSE
                  _DoControlEventProcedure( _HMG_SYSDATA[ 16 ] [ i ], i )
               ENDIF

               RETURN 0

            ENDIF

#endif

            //  Grid Enter ..........................................

            IF ( _HMG_SYSDATA[ 1 ] [ i ] = "GRID" .OR. _HMG_SYSDATA[ 1 ] [ i ] = "MULTIGRID" ) .AND. lparam == 0 .AND. wparam == 1
               IF _HMG_SYSDATA[ 40 ] [ I ] [ 1 ] == .T.

                  IF _HMG_SYSDATA[ 32 ] [ i ] == .T.                  // cellnavigation

                     _HMG_GRIDINPLACEKBDEDIT_2( I )

                  ELSE

                     _HMG_GRIDINPLACEKBDEDIT( I )

                  ENDIF

               ELSE
                  _DoControlEventProcedure( _HMG_SYSDATA[ 16 ] [ i ], i )
               ENDIF
               RETURN 0
            ENDIF

            //  ComboBox Enter ......................................

            IF _HMG_SYSDATA[ 1 ] [ i ] = "COMBO" .AND. ( HiWord( wParam ) == 0 .AND. LoWord( wParam ) == 1 )
               _DoControlEventProcedure( _HMG_SYSDATA[ 16 ] [ i ], i )
               IF _HMG_SYSDATA[ 255 ] == .T.                          // If Set ExtendedNavigation
                  _SetNextFocus()
               ENDIF
               RETURN 0
            ENDIF

            //  ListBox Enter .......................................

            IF ( _HMG_SYSDATA[ 1 ] [ i ] = "LIST" .OR. _HMG_SYSDATA[ 1 ] [ i ] = "MULTILIST" ) .AND. ( HiWord( wParam ) == 0 .AND. LoWord( wParam ) == 1 )
               _DoControlEventProcedure( _HMG_SYSDATA[ 16 ] [ i ], i )
               RETURN 0
            ENDIF

            //  TextBox Enter .......................................

            IF ( _HMG_SYSDATA[ 1 ] [ i ] == "TEXT" .OR. _HMG_SYSDATA[ 1 ] [ i ] == "MASKEDTEXT" .OR. _HMG_SYSDATA[ 1 ] [ i ] == "CHARMASKTEXT" .OR. _HMG_SYSDATA[ 1 ] [ i ] == "NUMTEXT" ) .AND. HiWord( wParam ) == 0 .AND. LoWord( wParam ) == 1
               _HMG_SYSDATA[ 251 ] := .F.
               _DoControlEventProcedure( _HMG_SYSDATA[ 16 ] [ i ], i )
               IF _HMG_SYSDATA[ 251 ] == .F.
                  IF _HMG_SYSDATA[ 255 ] == .T.                       // If Set ExtendedNavigation
                     _SetNextFocus()
                  ENDIF
               ELSE
                  _HMG_SYSDATA[ 251 ] := .F.
               ENDIF
               RETURN 0
            ENDIF

            //  Tree Enter ..........................................

            IF _HMG_SYSDATA[ 1 ] [ i ] == "TREE" .AND. HiWord( wParam ) == 0 .AND. LoWord( wParam ) == 1
               _DoControlEventProcedure( _HMG_SYSDATA[ 16 ] [ i ], i )
               RETURN 0
            ENDIF

         ELSE

            //  ComboBox (DisplayEdit) ..............................

            FOR i := 1 TO ControlCount

               IF _HMG_SYSDATA[ 1 ] [ i ] = "COMBO" .AND. ( HiWord( wParam ) == 0 .AND. LoWord( wParam ) == 1 )
                  IF _HMG_SYSDATA[ 31 ] [ i ] == GetFocus()
                     _DoControlEventProcedure( _HMG_SYSDATA[ 16 ] [ i ], i )
                     IF _HMG_SYSDATA[ 255 ] == .T.                    // If Set ExtendedNavigation
                        _SetNextFocus()
                     ENDIF
                     EXIT
                  ENDIF
               ENDIF
            NEXT i

            //  ComboBox (Image) ..............................

            i := ASCAN( _HMG_SYSDATA[ 32 ], GetFocus() )

            IF i > 0
               IF _HMG_SYSDATA[ 1 ] [ i ] = "COMBO" .AND. ( HiWord( wParam ) == 0 .AND. LoWord( wParam ) == 1 )
                  _DoControlEventProcedure( _HMG_SYSDATA[ 16 ] [ i ], i )
                  IF _HMG_SYSDATA[ 255 ] == .T.                       // If Set ExtendedNavigation
                     _SetNextFocus()
                  ENDIF
               ENDIF
            ENDIF

            RETURN 0

         ENDIF

         // **********************************************************************
      CASE nMsg == WM_MENUSELECT
         // **********************************************************************

         ToolTipMenuDisplayEvent( wParam, lParam )                    // ToolTip Menu Custom Draw, by Dr. Claudio Soto (December 2014)
         RETURN 0

         // **********************************************************************
      CASE nMsg == WM_NOTIFY
         // **********************************************************************

         //  Process ToolTip Custom Draw, by Dr. Claudio Soto (December 2014)

         xRetVal := ToolTipCustomDrawEvent( lParam )
         IF VALTYPE( xRetVal ) == "N"
            SetNewBehaviorWndProc( .T. )
            RETURN xRetVal
         ENDIF

         //  Process ToolBar ToolTip .....................................

         IF GetNotifyCode( lParam ) == TTN_NEEDTEXT
            i := ASCAN( _HMG_SYSDATA[ 5 ], GetToolButtonId( lParam ) )
            IF i > 0
               IF VALTYPE( _HMG_SYSDATA[ 30 ] [ i ] ) == 'C'
                  ShowToolButtonTip( lParam, _HMG_SYSDATA[ 30 ] [ i ] )
               ENDIF
            ENDIF
         ENDIF

         // *******************************************************************
         //  GRID HEAD Custom Draw   // by Dr. Claudio Soto, September 2014
         // *******************************************************************

         IF GetNotifyCode( lParam ) == NM_CUSTOMDRAW
            i := ASCAN( _HMG_SYSDATA[ 5 ], GetHwndFrom( lParam ) )
            IF i > 0
               IF ( _HMG_SYSDATA[ 1 ] [ i ] == "GRID" .OR. _HMG_SYSDATA[ 1 ] [ i ] == "MULTIGRID" )
                  SetNewBehaviorWndProc( .T. )                        // ADD2, December 2014
                  r := HEADER_CUSTOMDRAW_GetAction( lParam )
                  IF r <> - 1
                     RETURN r                                         // return CDRF_NOTIFYITEMDRAW or CDRF_DODEFAULT
                  ENDIF
                  RETURN _GridEx_DoHeaderCustomDraw( i, lParam, Header_CustomDraw_GetItem( lParam ) + 1 )                                   // return CDRF_NEWFONT
               ENDIF
            ENDIF
         ENDIF

         i := ASCAN( _HMG_SYSDATA[ 3 ], GetHwndFrom( lParam ) )

         IF i > 0

            //  Process StatusBar Single Click ...................

            IF _HMG_SYSDATA[ 1 ] [ i ] = "STATUSBAR"

               //  StatusBar Single Click

               IF GetNotifyCode( lParam ) == NM_CLICK

                  x := GetStatusBarItemPos( lParam ) + 1

                  IF x > 0

                     IF VALTYPE( _HMG_SYSDATA ) = 'A'

                        IF HMG_LEN( _HMG_SYSDATA ) >= 6

                           IF VALTYPE( _HMG_SYSDATA[ 6 ] ) = 'A'

                              IF HMG_LEN( _HMG_SYSDATA[ 6 ] ) >= i

                                 IF VALTYPE( _HMG_SYSDATA[ 6 ] [ i ] ) = 'A'

                                    IF HMG_LEN( _HMG_SYSDATA[ 6 ] [ i ] ) >= x

                                       IF VALTYPE( _HMG_SYSDATA[ 6 ] [ i ] [ x ] ) = 'B'
                                          IF _DoControlEventProcedure( _HMG_SYSDATA[ 6 ] [ i ] [ x ], i )
                                             RETURN 0
                                          ENDIF

                                       ENDIF

                                    ENDIF

                                 ENDIF

                              ENDIF

                           ENDIF

                        ENDIF

                     ENDIF

                  ENDIF

               ENDIF

            ENDIF

            //  Process Browse .....................................

#ifdef COMPILEBROWSE

            IF ( _HMG_SYSDATA[ 1 ] [ i ] = "BROWSE" )

               IF GetNotifyCode( lParam ) == NM_RCLICK

                  IF LISTVIEW_GETFIRSTITEM( _HMG_SYSDATA[ 3 ] [ i ] ) > 0
                     DeltaSelect := LISTVIEW_GETFIRSTITEM( _HMG_SYSDATA[ 3 ] [ i ] ) - ASCAN( _HMG_SYSDATA[ 32 ] [ i ], _HMG_SYSDATA[ 8 ] [ i ] )
                     _HMG_SYSDATA[ 8 ] [ i ] := _HMG_SYSDATA[ 32 ] [ i ] [ LISTVIEW_GETFIRSTITEM( _HMG_SYSDATA[ 3 ] [ i ] ) ]
                     _BrowseVscrollFastUpdate( i, DeltaSelect )
                     _BrowseOnChange( i )
                  ENDIF

                  RETURN 0

               ENDIF

               //  Browse Refresh On Column Size ..............

               IF GetNotifyCode( lParam ) == - 12

                  hws := 0
                  hwm := .F.
                  FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 6 ] [ i ] )
                     hws := hws + ListView_GetColumnWidth( _HMG_SYSDATA[ 3 ] [ i ], x - 1 )
                     IF _HMG_SYSDATA[ 6 ] [ i ] [ x ] != ListView_GetColumnWidth( _HMG_SYSDATA[ 3 ] [ i ], x - 1 )
                        hwm := .T.
                        _HMG_SYSDATA[ 6 ] [ i ] [ x ] := ListView_GetColumnWidth( _HMG_SYSDATA[ 3 ] [ i ], x - 1 )
                        _BrowseRefresh( '', '', i )
                     ENDIF
                  NEXT x

                  //  Browse ReDraw Vertical ScrollBar If Needed ...

                  IF _HMG_SYSDATA[ 5 ] [ i ] != 0 .AND. hwm == .T.
                     IF hws > _HMG_SYSDATA[ 20 ] [ i ] - GETVSCROLLBARWIDTH() - 4
                        MoveWindow( _HMG_SYSDATA[ 5 ] [ i ], _HMG_SYSDATA[ 19 ] [ i ] + _HMG_SYSDATA[ 20 ] [ i ] - GETVSCROLLBARWIDTH(), _HMG_SYSDATA[ 18 ] [ i ], GETVSCROLLBARWIDTH(), _HMG_SYSDATA[ 21 ] [ i ] - GETHSCROLLBARHEIGHT(), .t. )
                        MoveWindow( _HMG_SYSDATA[ 39 ] [ i ] [ 1 ], _HMG_SYSDATA[ 19 ] [ i ] + _HMG_SYSDATA[ 20 ] [ i ] - GETVSCROLLBARWIDTH(), _HMG_SYSDATA[ 18 ] [ i ] + _HMG_SYSDATA[ 21 ] [ i ] - GETHSCROLLBARHEIGHT(), GETVSCROLLBARWIDTH(), GETHSCROLLBARHEIGHT(), .t. )
                     ELSE
                        MoveWindow( _HMG_SYSDATA[ 5 ] [ i ], _HMG_SYSDATA[ 19 ] [ i ] + _HMG_SYSDATA[ 20 ] [ i ] - GETVSCROLLBARWIDTH(), _HMG_SYSDATA[ 18 ] [ i ], GETVSCROLLBARWIDTH(), _HMG_SYSDATA[ 21 ] [ i ], .t. )
                        MoveWindow( _HMG_SYSDATA[ 39 ] [ i ] [ 1 ], _HMG_SYSDATA[ 19 ] [ i ] + _HMG_SYSDATA[ 20 ] [ i ] - GETVSCROLLBARWIDTH(), _HMG_SYSDATA[ 18 ] [ i ] + _HMG_SYSDATA[ 21 ] [ i ] - GETHSCROLLBARHEIGHT(), 0, 0, .t. )
                     ENDIF
                  ENDIF

               ENDIF

               IF GetNotifyCode( lParam ) = NM_CUSTOMDRAW

                  // r := GetDs ( lParam )
                  r := LISTVIEW_CUSTOMDRAW_GetAction( lParam )
                  IF r <> - 1
                     RETURN r
                  ELSE
                     a := LISTVIEW_CUSTOMDRAW_GetRowCol( lParam )

                     MaxBrowseRows := HMG_LEN( _HMG_SYSDATA[ 32 ] [ i ] )
                     MaxBrowseCols := HMG_LEN( _HMG_SYSDATA[ 31 ] [ i ] )

                     IF a[ 1 ] >= 1 .AND. a[ 1 ] <= MaxBrowseRows .AND. a[ 2 ] >= 1 .AND. a[ 2 ] <= MaxBrowseCols
                        aTemp := _HMG_SYSDATA[ 40 ] [ I ] [ 6 ]
                        aTemp2 := _HMG_SYSDATA[ 40 ] [ I ] [ 7 ]

                        IF VALTYPE( aTemp ) = 'A' .AND. VALTYPE( aTemp2 ) <> 'A'
                           IF HMG_LEN( aTemp ) >= a[ 1 ]
                              IF aTemp[ a[ 1 ] ] [ a[ 2 ] ] <> - 1
                                 RETURN SetBCFC( lParam, aTemp[ a[ 1 ] ] [ a[ 2 ] ], RGB( 0, 0, 0 ) )
                              ELSE
                                 RETURN SetBCFC_Default( LpARAM )
                              ENDIF
                           ELSE
                              RETURN SetBCFC_Default( LpARAM )
                           ENDIF
                        ELSEIF VALTYPE( aTemp ) <> 'A' .AND. VALTYPE( aTemp2 ) = 'A'
                           IF HMG_LEN( aTemp2 ) >= a[ 1 ]
                              IF aTemp2[ a[ 1 ] ] [ a[ 2 ] ] <> - 1
                                 RETURN SetBCFC( lParam, RGB( 255, 255, 255 ), aTemp2[ a[ 1 ] ] [ a[ 2 ] ] )
                              ELSE
                                 RETURN SetBCFC_Default( LpARAM )
                              ENDIF
                           ELSE
                              RETURN SetBCFC_Default( LpARAM )
                           ENDIF
                        ELSEIF VALTYPE( aTemp ) = 'A' .AND. VALTYPE( aTemp2 ) = 'A'
                           IF HMG_LEN( aTemp ) >= a[ 1 ] .AND. HMG_LEN( aTemp2 ) >= a[ 1 ]
                              IF aTemp[ a[ 1 ] ] [ a[ 2 ] ] <> - 1
                                 RETURN SetBCFC( lParam, aTemp[ a[ 1 ] ] [ a[ 2 ] ], aTemp2[ a[ 1 ] ] [ a[ 2 ] ] )
                              ELSE
                                 RETURN SetBCFC_Default( LpARAM )
                              ENDIF
                           ELSE
                              RETURN SetBCFC_Default( LpARAM )
                           ENDIF
                        ENDIF

                     ELSE
                        RETURN SetBCFC_Default( LpARAM )
                     ENDIF

                  ENDIF

               ENDIF

               //  Browse Click ................................

               IF GetNotifyCode( lParam ) == NM_CLICK .OR. ;
                                 GetNotifyCode( lParam ) == LVN_BEGINDRAG

                  IF LISTVIEW_GETFIRSTITEM( _HMG_SYSDATA[ 3 ] [ i ] ) > 0
                     DeltaSelect := LISTVIEW_GETFIRSTITEM( _HMG_SYSDATA[ 3 ] [ i ] ) - ASCAN( _HMG_SYSDATA[ 32 ] [ i ], _HMG_SYSDATA[ 8 ] [ i ] )
                     _HMG_SYSDATA[ 8 ] [ i ] := _HMG_SYSDATA[ 32 ] [ i ] [ LISTVIEW_GETFIRSTITEM( _HMG_SYSDATA[ 3 ] [ i ] ) ]
                     _BrowseVscrollFastUpdate( i, DeltaSelect )
                     _BrowseOnChange( i )
                  ENDIF

                  RETURN 0

               ENDIF

               //  Browse Key Handling .........................

               IF GetNotifyCode( lParam ) = LVN_KEYDOWN

                  DO CASE

                     CASE GetGridvKey( lParam ) == 65                 // A

                        IF GetAltState() == - 127 ;
                                   .OR. ;
                                   GetAltState() == - 128             // ALT

                           IF _HMG_SYSDATA[ 39 ] [ i ] [ 2 ] == .T.
                              _BrowseEdit( _HMG_SYSDATA[ 3 ] [ i ], _HMG_SYSDATA[ 39 ] [ i ] [ 4 ], _HMG_SYSDATA[ 39 ] [ i ] [ 5 ], _HMG_SYSDATA[ 39 ] [ i ] [ 3 ], _HMG_SYSDATA[ 9 ] [ i ], .t., _HMG_SYSDATA[ 15 ] [ i ], _HMG_SYSDATA[ 39 ] [ i ] [ 7 ] )
                           ENDIF

                        ENDIF

                     CASE GetGridvKey( lParam ) == 46                 // DEL

                        IF _HMG_SYSDATA[ 25 ] [ i ] == .t.
                           IF MsgYesNo( _HMG_SYSDATA[ 137 ] [ 1 ], _HMG_SYSDATA[ 137 ] [ 2 ] ) == .t.
                              _BrowseDelete( '', '', i )
                           ENDIF
                        ENDIF

                     CASE GetGridvKey( lParam ) == 36                 // HOME

                        _BrowseHome( '', '', i )
                        RETURN 1

                     CASE GetGridvKey( lParam ) == 35                 // END

                        _BrowseEnd( '', '', i )
                        RETURN 1

                     CASE GetGridvKey( lParam ) == 33                 // PGUP

                        _BrowsePrior( '', '', i )
                        RETURN 1

                     CASE GetGridvKey( lParam ) == 34                 // PGDN

                        _BrowseNext( '', '', i )
                        RETURN 1

                     CASE GetGridvKey( lParam ) == 38                 // UP

                        _BrowseUp( '', '', i )
                        RETURN 1

                     CASE GetGridvKey( lParam ) == 40                 // DOWN

                        _BrowseDown( '', '', i )
                        RETURN 1

                  ENDCASE

                  RETURN 0

               ENDIF

               //  Browse Double Click .........................

               IF GetNotifyCode( lParam ) == NM_DBLCLK

                  _PushEventInfo()
                  _HMG_SYSDATA[ 194 ] := ASCAN( _HMG_SYSDATA[ 67 ], _HMG_SYSDATA[ 4 ] [ i ] )
                  _HMG_SYSDATA[ 231 ] := 'C'
                  _HMG_SYSDATA[ 203 ] := i
                  _HMG_SYSDATA[ 316 ] := _HMG_SYSDATA[ 66 ] [ _HMG_SYSDATA[ 194 ] ]
                  _HMG_SYSDATA[ 317 ] := _HMG_SYSDATA[ 2 ] [ _HMG_SYSDATA[ 203 ] ]

                  r := ListView_HitTest( _HMG_SYSDATA[ 3 ] [ i ], GetCursorRow() - GetWindowRow( _HMG_SYSDATA[ 3 ] [ i ] ), GetCursorCol() - GetWindowCol( _HMG_SYSDATA[ 3 ] [ i ] ) )
                  IF r[ 2 ] == 1
                     ListView_Scroll( _HMG_SYSDATA[ 3 ] [ i ], - 10000, 0 )
                     r := ListView_HitTest( _HMG_SYSDATA[ 3 ] [ i ], GetCursorRow() - GetWindowRow( _HMG_SYSDATA[ 3 ] [ i ] ), GetCursorCol() - GetWindowCol( _HMG_SYSDATA[ 3 ] [ i ] ) )
                  ELSE
                     r := LISTVIEW_GETSUBITEMRECT( _HMG_SYSDATA[ 3 ] [ i ], r[ 1 ] - 1, r[ 2 ] - 1 )

                     //   CellCol           CellWidth
                     xs := ( ( _HMG_SYSDATA[ 19 ] [ i ] + r[ 2 ] ) + ( r[ 3 ] ) ) - ( _HMG_SYSDATA[ 19 ] [ i ] + _HMG_SYSDATA[ 20 ] [ i ] )
                     xd := 20
                     IF xs > - xd
                        ListView_Scroll( _HMG_SYSDATA[ 3 ] [ i ], xs + xd, 0 )
                     ELSE
                        IF r[ 2 ] < 0
                           ListView_Scroll( _HMG_SYSDATA[ 3 ] [ i ], r[ 2 ], 0 )
                        ENDIF
                     ENDIF
                     r := ListView_HitTest( _HMG_SYSDATA[ 3 ] [ i ], GetCursorRow() - GetWindowRow( _HMG_SYSDATA[ 3 ] [ i ] ), GetCursorCol() - GetWindowCol( _HMG_SYSDATA[ 3 ] [ i ] ) )
                  ENDIF

                  _HMG_SYSDATA[ 195 ] := r[ 1 ]
                  _HMG_SYSDATA[ 196 ] := r[ 2 ]
                  IF r[ 2 ] == 1
                     r := LISTVIEW_GETITEMRECT( _HMG_SYSDATA[ 3 ] [ i ], r[ 1 ] - 1 )
                  ELSE
                     r := LISTVIEW_GETSUBITEMRECT( _HMG_SYSDATA[ 3 ] [ i ], r[ 1 ] - 1, r[ 2 ] - 1 )
                  ENDIF
                  _HMG_SYSDATA[ 197 ] := _HMG_SYSDATA[ 18 ] [ i ] + r[ 1 ]
                  _HMG_SYSDATA[ 198 ] := _HMG_SYSDATA[ 19 ] [ i ] + r[ 2 ]
                  _HMG_SYSDATA[ 199 ] := r[ 3 ]
                  _HMG_SYSDATA[ 200 ] := r[ 4 ]

                  IF _HMG_SYSDATA[ 39 ] [ i ] [ 6 ] == .T.
                     _BrowseEdit( _HMG_SYSDATA[ 3 ] [ i ], _HMG_SYSDATA[ 39 ] [ i ] [ 4 ], _HMG_SYSDATA[ 39 ] [ i ] [ 5 ], _HMG_SYSDATA[ 39 ] [ i ] [ 3 ], _HMG_SYSDATA[ 9 ] [ i ], .f., _HMG_SYSDATA[ 15 ] [ i ], _HMG_SYSDATA[ 39 ] [ i ] [ 7 ] )
                  ELSE
                     IF VALTYPE( _HMG_SYSDATA[ 16 ] [ i ] ) == 'B'
                        EVAL( _HMG_SYSDATA[ 16 ] [ i ] )
                     ENDIF
                  ENDIF

                  _PopEventInfo()
                  _HMG_SYSDATA[ 195 ] := 0
                  _HMG_SYSDATA[ 196 ] := 0
                  _HMG_SYSDATA[ 197 ] := 0
                  _HMG_SYSDATA[ 198 ] := 0
                  _HMG_SYSDATA[ 199 ] := 0
                  _HMG_SYSDATA[ 200 ] := 0

               ENDIF

               //  Browse LostFocus ............................

               IF GetNotifyCode( lParam ) = NM_KILLFOCUS

                  // by Dr. Claudio Soto, December 2014
                  IF IsGridCustomDrawNewBehavior() == .T.
                     SetEventProcessHMGWindowsMessage( .T. )
                  ENDIF

                  _DoControlEventProcedure( _HMG_SYSDATA[ 10 ] [ i ], i )
                  RETURN 0
               ENDIF

               //  Browse GotFocus ..............................

               IF GetNotifyCode( lParam ) = NM_SETFOCUS

                  // by Dr. Claudio Soto, December 2014
                  IF IsGridCustomDrawNewBehavior() == .T.
                     SetEventProcessHMGWindowsMessage( .F. )
                  ENDIF

                  VirtualChildControlFocusProcess( _HMG_SYSDATA[ 3 ] [ i ], _HMG_SYSDATA[ 4 ] [ i ] )
                  _DoControlEventProcedure( _HMG_SYSDATA[ 11 ] [ i ], i )
                  RETURN 0
               ENDIF

               //  Browse Header Click .........................

               IF GetNotifyCode( lParam ) = LVN_COLUMNCLICK
                  IF VALTYPE( _HMG_SYSDATA[ 17 ] [ i ] ) == 'A'
                     lvc := GetGridColumn( lParam ) + 1
                     IF HMG_LEN( _HMG_SYSDATA[ 17 ] [ i ] ) >= lvc
                        _DoControlEventProcedure( _HMG_SYSDATA[ 17 ] [ i ] [ lvc ], i )
                     ENDIF
                  ENDIF
                  RETURN 0
               ENDIF

            ENDIF

#endif

            //  ToolBar DropDown Button Click .......................

            IF GetNotifyCode( lParam ) == TBN_DROPDOWN

               x := ASCAN( _HMG_SYSDATA[ 5 ], GetToolButtonDDId( lParam ) )

               IF x > 0 .AND. _HMG_SYSDATA[ 1 ] [ x ] = "TOOLBUTTON"
                  aPos := { 0, 0, 0, 0 }
                  GetWindowRect( _HMG_SYSDATA[ 3 ] [ i ], aPos )
                  aSize := GetToolButtonSize( _HMG_SYSDATA[ 3 ] [ i ], _HMG_SYSDATA[ 8 ] [ x ] - 1 )
                  TrackPopupMenu( _HMG_SYSDATA[ 32 ] [ x ], aPos[ 1 ] + aSize[ 1 ], aPos[ 2 ] + aSize[ 2 ] + ( aPos[ 4 ] - aPos[ 2 ] - aSize[ 2 ] ) / 2, hWnd )
               ENDIF

            ENDIF

            //  MonthCalendar Selection Change ......................

            IF _HMG_SYSDATA[ 1 ] [ i ] = "MONTHCAL"
               IF GetNotifyCode( lParam ) = MCN_SELECT
                  _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )
                  RETURN 0
               ENDIF
            ENDIF

            //  Grid Processing .....................................

            IF ( _HMG_SYSDATA[ 1 ] [ i ] = "GRID" ) .OR. ( _HMG_SYSDATA[ 1 ] [ i ] = "MULTIGRID" )

               IF _HMG_SYSDATA[ 32 ] [ i ] == .T.

                  //  Grid Key Handling .........................

                  IF GetNotifyCode( lParam ) = LVN_KEYDOWN

                     DO CASE

                        CASE GetGridvKey( lParam ) == 37              // LEFT

                           IF _HMG_SYSDATA[ 15 ] [ i ] > 1

                              _HMG_SYSDATA[ 15 ] [ i ] --

                              // *************************************************************************************************************************************

                              nDestinationColumn := _HMG_SYSDATA[ 15 ] [ i ]
                              nFrozenColumnCount := _HMG_SYSDATA[ 40 ] [ i ] [ 32 ]
                              anOriginalColumnWidths := _HMG_SYSDATA[ 40 ] [ i ] [ 31 ]

                              IF nFrozenColumnCount > 0

                                 IF nDestinationColumn >= nFrozenColumnCount + 1

                                    //  Set Destination Column Width To Original

                                    LISTVIEW_SETCOLUMNWIDTH( _HMG_SYSDATA[ 3 ] [ i ], nDestinationColumn - 1, anOriginalColumnWidths[ nDestinationColumn ] )

                                 ENDIF

                              ENDIF

                              // *************************************************************************************************************************************

                              _HMG_GRID_KBDSCROLL( I )

                              LISTVIEW_REDRAWITEMS( _HMG_SYSDATA[ 3 ] [ i ], _HMG_SYSDATA[ 39 ] [ i ] - 1, _HMG_SYSDATA[ 39 ] [ i ] - 1 )

                              _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )

                           ENDIF

                        CASE GetGridvKey( lParam ) == 39              // RIGHT

                           IF _HMG_SYSDATA[ 15 ] [ i ] < HMG_LEN( _HMG_SYSDATA[ 33 ] [ i ] )

                              _HMG_SYSDATA[ 15 ] [ i ] ++

                              nDestinationColumn := _HMG_SYSDATA[ 15 ] [ i ]
                              nFrozenColumnCount := _HMG_SYSDATA[ 40 ] [ i ] [ 32 ]

                              FOR J := nDestinationColumn TO HMG_LEN( _HMG_SYSDATA[ 33 ] [ i ] ) - 1

                                 IF LISTVIEW_GETCOLUMNWIDTH( _HMG_SYSDATA[ 3 ] [ i ], J - 1 ) == 0
                                    _HMG_SYSDATA[ 15 ] [ i ] ++
                                 ENDIF

                              NEXT J

                              IF nFrozenColumnCount > 0

                                 IF nDestinationColumn > nFrozenColumnCount + 1

                                    //  Set Current Column Width To 0

                                    LISTVIEW_SETCOLUMNWIDTH( _HMG_SYSDATA[ 3 ] [ i ], nDestinationColumn - 2, 0 )

                                 ENDIF

                              ENDIF

                              // *************************************************************************************************************************************
                              _HMG_GRID_KBDSCROLL( I )

                              LISTVIEW_REDRAWITEMS( _HMG_SYSDATA[ 3 ] [ i ], _HMG_SYSDATA[ 39 ] [ i ] - 1, _HMG_SYSDATA[ 39 ] [ i ] - 1 )

                              _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )

                           ENDIF

                        CASE GetGridvKey( lParam ) == 38              // UP

                           IF _HMG_SYSDATA[ 15 ] [ i ] == 0
                              _HMG_SYSDATA[ 15 ] [ i ] := 1
                           ENDIF

                           IF _HMG_SYSDATA[ 39 ] [ i ] > 1

                              _HMG_SYSDATA[ 39 ] [ i ] --

                              _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )

                           ENDIF

                        CASE GetGridvKey( lParam ) == 40              // DOWN

                           IF _HMG_SYSDATA[ 15 ] [ i ] == 0
                              _HMG_SYSDATA[ 15 ] [ i ] := 1
                           ENDIF

                           IF _HMG_SYSDATA[ 39 ] [ i ] < ListView_GetItemCount( _HMG_SYSDATA[ 3 ] [ i ] )

                              _HMG_SYSDATA[ 39 ] [ i ] ++

                              _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )

                           ENDIF

                        CASE GetGridvKey( lParam ) == 33              // PGUP

                           _GridInitValue := _HMG_SYSDATA[ 39 ] [ i ]

                           IF _HMG_SYSDATA[ 39 ] [ i ] == SendMessage( _HMG_SYSDATA[ 3 ] [ i ], LVM_GETTOPINDEX, 0, 0 ) + 1

                              _HMG_SYSDATA[ 39 ] [ i ] -= SendMessage( _HMG_SYSDATA[ 3 ] [ i ], LVM_GETCOUNTPERPAGE, 0, 0 ) - 1

                           ELSE

                              _HMG_SYSDATA[ 39 ] [ i ] := SendMessage( _HMG_SYSDATA[ 3 ] [ i ], LVM_GETTOPINDEX, 0, 0 ) + 1

                           ENDIF

                           IF _HMG_SYSDATA[ 39 ] [ i ] < 1

                              _HMG_SYSDATA[ 39 ] [ i ] := 1

                           ENDIF

                           IF _GridInitValue <> _HMG_SYSDATA[ 39 ] [ i ]

                              _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )

                           ENDIF

                        CASE GetGridvKey( lParam ) == 34              // PGDOWN

                           _GridInitValue := _HMG_SYSDATA[ 39 ] [ i ]

                           IF _HMG_SYSDATA[ 39 ] [ i ] == SendMessage( _HMG_SYSDATA[ 3 ] [ i ], LVM_GETTOPINDEX, 0, 0 ) + SendMessage( _HMG_SYSDATA[ 3 ] [ i ], LVM_GETCOUNTPERPAGE, 0, 0 )

                              _HMG_SYSDATA[ 39 ] [ i ] += SendMessage( _HMG_SYSDATA[ 3 ] [ i ], LVM_GETCOUNTPERPAGE, 0, 0 ) - 1

                           ELSE

                              _HMG_SYSDATA[ 39 ] [ i ] := SendMessage( _HMG_SYSDATA[ 3 ] [ i ], LVM_GETTOPINDEX, 0, 0 ) + SendMessage( _HMG_SYSDATA[ 3 ] [ i ], LVM_GETCOUNTPERPAGE, 0, 0 )

                           ENDIF

                           IF _HMG_SYSDATA[ 39 ] [ i ] > ListView_GetItemCount( _HMG_SYSDATA[ 3 ] [ i ] )

                              _HMG_SYSDATA[ 39 ] [ i ] := ListView_GetItemCount( _HMG_SYSDATA[ 3 ] [ i ] )

                           ENDIF

                           IF _GridInitValue <> _HMG_SYSDATA[ 39 ] [ i ]
                              _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )
                           ENDIF

                           //ListView_Scroll ( _HMG_SYSDATA [ 3 ] [i] , 0, (_HMG_SYSDATA [ 39 ] [i] - _GridInitValue) * LISTVIEW_GETITEMRECT ( _HMG_SYSDATA [3] [i]  , _HMG_SYSDATA [ 39 ] [i] ) [4])
                           //return 0

                        CASE GetGridvKey( lParam ) == 35              // END

                           _GridInitValue := _HMG_SYSDATA[ 39 ] [ i ]

                           _HMG_SYSDATA[ 39 ] [ i ] := ListView_GetItemCount( _HMG_SYSDATA[ 3 ] [ i ] )

                           IF _GridInitValue <> _HMG_SYSDATA[ 39 ] [ i ]

                              _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )

                           ENDIF

                        CASE GetGridvKey( lParam ) == 36              // HOME

                           _GridInitValue := _HMG_SYSDATA[ 39 ] [ i ]

                           _HMG_SYSDATA[ 39 ] [ i ] := 1

                           IF _GridInitValue <> _HMG_SYSDATA[ 39 ] [ i ]

                              _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )

                           ENDIF

                        CASE GetGridvKey( lParam ) == 65              // A
                           IF GetAltState() == - 127 .OR. GetAltState() == - 128                                                            // ALT
                              IF _HMG_SYSDATA[ 40 ] [ i ] [ 12 ] == .T. .AND. VALTYPE( _HMG_SYSDATA[ 40 ] [ i ] [ 10 ] ) == 'C'
                                 DataGridAppend( i )
                              ENDIF
                           ELSE
                              // Return 1
                           ENDIF

                        CASE GetGridvKey( lParam ) == 68              // D
                           IF GetAltState() == - 127 .OR. GetAltState() == - 128                                                            // ALT
                              IF _HMG_SYSDATA[ 40 ] [ i ] [ 17 ] == .T. .AND. VALTYPE( _HMG_SYSDATA[ 40 ] [ i ] [ 10 ] ) == 'C'
                                 DataGridDelete( i )
                              ENDIF
                           ELSE
                              // Return 1
                           ENDIF

                        CASE GetGridvKey( lParam ) == 82              // R
                           IF GetAltState() == - 127 .OR. GetAltState() == - 128                                                            // ALT
                              IF _HMG_SYSDATA[ 40 ] [ i ] [ 17 ] == .T. .AND. VALTYPE( _HMG_SYSDATA[ 40 ] [ i ] [ 10 ] ) == 'C'
                                 DataGridReCall( i )
                              ENDIF
                           ELSE
                              // Return 1
                           ENDIF

                        CASE GetGridvKey( lParam ) == 83              // S
                           IF GetAltState() == - 127 .OR. GetAltState() == - 128                                                            // ALT
                              IF ( _HMG_SYSDATA[ 40 ] [ i ] [ 12 ] == .T. .OR. ;                                                            // allowAppend
                                   _HMG_SYSDATA[ 40 ] [ i ] [ 17 ] == .T. .OR. ;                                                            // allowDelete
                                   _HMG_SYSDATA[ 40 ] [ i ] [ 1 ] == .T. ) .AND. ;                                                          // allowEdit inplace
                                   ( VALTYPE( _HMG_SYSDATA[ 40 ] [ i ] [ 10 ] ) == 'C' )
                                 DataGridSave( i )
                              ENDIF
                           ELSE
                              // Return 1
                           ENDIF

                        CASE GetGridvKey( lParam ) == 85              // U
                           IF GetAltState() == - 127 .OR. GetAltState() == - 128                                                            // ALT
                              IF ( _HMG_SYSDATA[ 40 ] [ i ] [ 12 ] == .T. .OR. ;                                                            // allowAppend
                                   _HMG_SYSDATA[ 40 ] [ i ] [ 17 ] == .T. .OR. ;                                                            // allowDelete
                                   _HMG_SYSDATA[ 40 ] [ i ] [ 1 ] == .T. ) .AND. ;                                                          // allowEdit inplace
                                   ( VALTYPE( _HMG_SYSDATA[ 40 ] [ i ] [ 10 ] ) == 'C' )
                                 DataGridClearBuffer( i )
                              ENDIF
                           ELSE
                              // Return 1
                           ENDIF

                        OTHERWISE

                           // Return 1   // Remove, december 2014

                     ENDCASE

                     RETURN 0                                         // ADD, december 2014

                  ENDIF

               ENDIF

               /*
            // by Dr. Claudio Soto, December 2014
            If GetNotifyCode (lParam) = LVN_BEGINSCROLL
               Return 0
            ENDIF

            If GetNotifyCode (lParam) = LVN_ENDSCROLL
               Return 0
            ENDIF
*/

               IF GetNotifyCode( lParam ) = NM_CUSTOMDRAW

                  SetNewBehaviorWndProc( .T. )                        // ADD2, December 2014

                  IF _HMG_SYSDATA[ 32 ] [ i ] == .T.                  // CellNavigation == .T.
                     // r := GetDsx ( lParam , _HMG_SYSDATA [ 3 ] [i] , _HMG_SYSDATA [ 39 ] [i] )
                     r := LISTVIEW_CUSTOMDRAW_GetAction( lParam, .T., _HMG_SYSDATA[ 3 ] [ i ], _HMG_SYSDATA[ 39 ] [ i ] )
                  ELSE
                     // r := GetDs ( lParam )   // CellNavigation == .F.
                     r := LISTVIEW_CUSTOMDRAW_GetAction( lParam )
                  ENDIF

                  IF r <> - 1
                     RETURN r                                         // return CDRF_NOTIFYITEMDRAW, CDRF_NOTIFYSUBITEMDRAW or CDRF_DODEFAULT
                  ELSE

                     a := LISTVIEW_CUSTOMDRAW_GetRowCol( lParam )     //  get nROW and nCOL of the cell draw

                     //   a [1] --> nRow draw
                     //   a [2] --> nCow draw
                     //   _HMG_SYSDATA [ 39 ] [i] --> nRow of the selected cell
                     //   _HMG_SYSDATA [ 15 ] [i] --> nCol of the selected cell

                     IF _HMG_SYSDATA[ 32 ] [ i ] == .T.               // CellNavigation == .T.

                        IF a[ 1 ] == _HMG_SYSDATA[ 39 ] [ i ] .AND. a[ 2 ] == _HMG_SYSDATA[ 15 ] [ i ] .AND. _HMG_GRID_SELECTEDCELL_DISPLAYCOLOR == .T.                                                           // ADD
                           hFont := _GridEx_DoGridCustomDrawFont( i, a, lParam, .F. )
                           r := GRID_SetBCFC( lParam, RGB( _HMG_SYSDATA[ 351 ] [ 1 ], _HMG_SYSDATA[ 351 ] [ 2 ], _HMG_SYSDATA[ 351 ] [ 3 ] ), RGB( _HMG_SYSDATA[ 350 ] [ 1 ], _HMG_SYSDATA[ 350 ] [ 2 ], _HMG_SYSDATA[ 350 ] [ 3 ] ), hFont )

                        ELSEIF a[ 1 ] == _HMG_SYSDATA[ 39 ] [ i ] .AND. a[ 2 ] <> _HMG_SYSDATA[ 15 ] [ i ] .AND. _HMG_GRID_SELECTEDROW_DISPLAYCOLOR == .T.                                                        // ADD
                           hFont := _GridEx_DoGridCustomDrawFont( i, a, lParam, .F. )
                           r := GRID_SetBCFC( lParam, RGB( _HMG_SYSDATA[ 349 ] [ 1 ], _HMG_SYSDATA[ 349 ] [ 2 ], _HMG_SYSDATA[ 349 ] [ 3 ] ), RGB( _HMG_SYSDATA[ 348 ] [ 1 ], _HMG_SYSDATA[ 348 ] [ 2 ], _HMG_SYSDATA[ 348 ] [ 3 ] ), hFont )

                        ELSE
                           r := _GridEx_DoGridCustomDraw( i, a, lParam )                                                                    // ADD2
                        ENDIF

                     ELSE
                        r := _GridEx_DoGridCustomDraw( i, a, lParam )                                                                       // ADD2
                     ENDIF

                     RETURN r                                         // return CDRF_NEWFONT

                  ENDIF

               ENDIF

               // ******************************************************************************
               IF GetNotifyCode( lParam ) = - 181
                  redrawwindow( _HMG_SYSDATA[ 3 ] [ i ] )
               ENDIF
               // ******************************************************************************

               //  Grid OnQueryData ............................

               IF GetNotifyCode( lParam ) = LVN_GETDISPINFO

                  _PushEventInfo()
                  _HMG_SYSDATA[ 194 ] := ASCAN( _HMG_SYSDATA[ 67 ], _HMG_SYSDATA[ 4 ] [ i ] )
                  _HMG_SYSDATA[ 231 ] := 'C'
                  _HMG_SYSDATA[ 203 ] := i
                  _HMG_SYSDATA[ 316 ] := _HMG_SYSDATA[ 66 ] [ _HMG_SYSDATA[ 194 ] ]
                  _HMG_SYSDATA[ 317 ] := _HMG_SYSDATA[ 2 ] [ _HMG_SYSDATA[ 203 ] ]
                  _ThisQueryTemp := GETGRIDDISPINFOINDEX( lParam )
                  _HMG_SYSDATA[ 201 ] := _ThisQueryTemp[ 1 ]          // This.QueryRowIndex
                  _HMG_SYSDATA[ 202 ] := _ThisQueryTemp[ 2 ]          // This.QueryColIndex

                  IF VALTYPE( _HMG_SYSDATA[ 40 ] [ i ] [ 10 ] ) == 'C'
                     IF USED()                                        // ADD
                        GetDataGridCellData( i, .F. )
                     ENDIF
                  ELSE
                     IF VALTYPE( _HMG_SYSDATA[ 6 ] [ i ] ) == "B"     // ADD
                        EVAL( _HMG_SYSDATA[ 6 ] [ i ] )               // OnQueryData Event
                     ENDIF
                  ENDIF

                  IF HMG_LEN( _HMG_SYSDATA[ 14 ] [ i ] ) > 0 .AND. _HMG_SYSDATA[ 202 ] == 1
                     SetGridQueryImage( lParam, _HMG_SYSDATA[ 230 ] )
                  ELSE
                     xTemp := _HMG_SYSDATA[ 230 ]                     // This.QueryData

                     IF VALTYPE( xTemp ) == 'C'
                        cTemp := RTRIM( xTemp )
                     ELSEIF VALTYPE( xTemp ) == 'N'
                        cTemp := STR( xTemp )
                     ELSEIF VALTYPE( xTemp ) == 'D'
                        cTemp := DTOC( xTemp )
                     ELSEIF VALTYPE( xTemp ) == 'L'
                        cTemp := IF( xTemp, '.T.', '.F.' )
                     ELSE
                        cTemp := ''
                     ENDIF

                     SetGridQueryData( lParam, cTemp )
                  ENDIF

                  _HMG_SYSDATA[ 201 ] := 0                            // This.QueryRowIndex
                  _HMG_SYSDATA[ 202 ] := 0                            // This.QueryColIndex
                  _HMG_SYSDATA[ 230 ] := ""                           // This.QueryData
                  _PopEventInfo()
                  RETURN 0                                            // ADD
               ENDIF

               //  Grid LostFocus ..............................

               IF GetNotifyCode( lParam ) = NM_KILLFOCUS

                  // by Dr. Claudio Soto, December 2014
                  IF IsGridCustomDrawNewBehavior() == .T.
                     SetEventProcessHMGWindowsMessage( .T. )
                  ENDIF

                  _DoControlEventProcedure( _HMG_SYSDATA[ 10 ] [ i ], i )
                  RETURN 0

               ENDIF

               //  Grid GotFocus ...............................

               IF GetNotifyCode( lParam ) = NM_SETFOCUS

                  // by Dr. Claudio Soto, December 2014
                  IF IsGridCustomDrawNewBehavior() == .T.
                     SetEventProcessHMGWindowsMessage( .F. )
                  ENDIF

                  VirtualChildControlFocusProcess( _HMG_SYSDATA[ 3 ] [ i ], _HMG_SYSDATA[ 4 ] [ i ] )
                  _DoControlEventProcedure( _HMG_SYSDATA[ 11 ] [ i ], i )
                  RETURN 0
               ENDIF

               //  Grid Change .................................

               IF GetNotifyCode( lParam ) = LVN_ITEMCHANGED

                  //   OnCheckBoxClicked   (by Dr. Claudio Soto, December 2014)
                  IF GetGridNewState( lParam ) == LVIS_UNCHECKED .OR. GetGridNewState( lParam ) == LVIS_CHECKED
                     xTemp := { NIL, NIL }
                     xTemp[ 1 ] := _HMG_SYSDATA[ 40 ] [ i ] [ 37 ] [ 1 ]                                                                    // This.CellRowClicked
                     IF ( xTemp[ 1 ] > 0 .AND. xTemp[ 1 ] <= ListView_GetItemCount( _HMG_SYSDATA[ 3 ] [ i ] ) ) .OR. ;
                          ( HMG_GetLastVirtualKeyDown( @xTemp[ 2 ] ) == VK_SPACE .AND. xTemp[ 2 ] == _HMG_SYSDATA[ 3 ] [ i ] ) .OR. ;
                          ( HMG_GetLastMouseMessage( @xTemp[ 2 ] ) == WM_LBUTTONDOWN .AND. xTemp[ 2 ] == _HMG_SYSDATA[ 3 ] [ i ] )          // ADD, March 2016
                        IF HMG_GetLastVirtualKeyDown() == VK_SPACE .OR. HMG_GetLastMouseMessage() == WM_LBUTTONDOWN
                           _HMG_SYSDATA[ 40 ] [ i ] [ 37 ] [ 1 ] := GETGRIDROW( lParam ) + 1                                                // CellRowClicked
                           _HMG_SYSDATA[ 40 ] [ i ] [ 37 ] [ 2 ] := 0                                                                       // CellColClicked
                        ENDIF
                        _DoControlEventProcedure( _HMG_SYSDATA[ 40 ] [ i ] [ 46 ], i )                                                      // OnCheckBoxClicked
                        RETURN 0
                     ENDIF
                  ENDIF

                  IF GetGridOldState( lParam ) == 0 .AND. GetGridNewState( lParam ) <> 0
                     IF _HMG_SYSDATA[ 32 ] [ i ] == .T.
                        _HMG_SYSDATA[ 39 ] [ i ] := LISTVIEW_GETFIRSTITEM( _HMG_SYSDATA[ 3 ] [ i ] )
                     ELSE
                        _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )
                     ENDIF
                     RETURN 0
                  ENDIF

               ENDIF

               //  Grid Header Click ..........................

               IF GetNotifyCode( lParam ) = LVN_COLUMNCLICK
                  IF VALTYPE( _HMG_SYSDATA[ 17 ] [ i ] ) == 'A'
                     lvc := GetGridColumn( lParam ) + 1
                     IF HMG_LEN( _HMG_SYSDATA[ 17 ] [ i ] ) >= lvc
                        _DoControlEventProcedure( _HMG_SYSDATA[ 17 ] [ i ] [ lvc ], i )
                        RETURN 0
                     ENDIF
                  ENDIF
               ENDIF

               //  Grid Click ...........................

               IF GetNotifyCode( lParam ) == NM_CLICK
                  IF _HMG_SYSDATA[ 32 ] [ i ] == .T.

                     aCellData := _GetGridCellData( i )

                     IF aCellData[ 2 ] > 0

                        _HMG_SYSDATA[ 15 ] [ i ] := aCellData[ 2 ]

                     ENDIF

                     LISTVIEW_REDRAWITEMS( _HMG_SYSDATA[ 3 ] [ i ], _HMG_SYSDATA[ 39 ] [ i ] - 1, _HMG_SYSDATA[ 39 ] [ i ] - 1 )

                     _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )

                  ENDIF
                  RETURN 0                                            // ADD2
               ENDIF

               //  Grid Double Click ...........................

               IF GetNotifyCode( lParam ) == NM_DBLCLK

                  IF _HMG_SYSDATA[ 40 ] [ I ] [ 1 ] == .T.

                     _PushEventInfo()
                     _HMG_SYSDATA[ 194 ] := ASCAN( _HMG_SYSDATA[ 67 ], _HMG_SYSDATA[ 4 ] [ i ] )                                            // Parent Index
                     _HMG_SYSDATA[ 231 ] := 'C'
                     _HMG_SYSDATA[ 203 ] := i                         // Control Index
                     _HMG_SYSDATA[ 316 ] := _HMG_SYSDATA[ 66 ] [ _HMG_SYSDATA[ 194 ] ]                                                      // Parent Name
                     _HMG_SYSDATA[ 317 ] := _HMG_SYSDATA[ 2 ] [ _HMG_SYSDATA[ 203 ] ]                                                       // Control Name
                     aCellData := _GetGridCellData( i )
                     _HMG_SYSDATA[ 195 ] := aCellData[ 1 ]
                     _HMG_SYSDATA[ 196 ] := aCellData[ 2 ]
                     _HMG_SYSDATA[ 197 ] := aCellData[ 3 ]
                     _HMG_SYSDATA[ 198 ] := aCellData[ 4 ]
                     _HMG_SYSDATA[ 199 ] := aCellData[ 5 ]
                     _HMG_SYSDATA[ 200 ] := aCellData[ 6 ]

                     _HMG_GRIDINPLACEEDIT( i )

                     _PopEventInfo()
                     _HMG_SYSDATA[ 195 ] := 0
                     _HMG_SYSDATA[ 196 ] := 0
                     _HMG_SYSDATA[ 197 ] := 0
                     _HMG_SYSDATA[ 198 ] := 0
                     _HMG_SYSDATA[ 199 ] := 0
                     _HMG_SYSDATA[ 200 ] := 0

                     // Return 0

                  ELSE

                     IF VALTYPE( _HMG_SYSDATA[ 16 ] [ i ] ) == 'B'

                        _PushEventInfo()
                        _HMG_SYSDATA[ 194 ] := ASCAN( _HMG_SYSDATA[ 67 ], _HMG_SYSDATA[ 4 ] [ i ] )
                        _HMG_SYSDATA[ 231 ] := 'C'
                        _HMG_SYSDATA[ 203 ] := i
                        _HMG_SYSDATA[ 316 ] := _HMG_SYSDATA[ 66 ] [ _HMG_SYSDATA[ 194 ] ]
                        _HMG_SYSDATA[ 317 ] := _HMG_SYSDATA[ 2 ] [ _HMG_SYSDATA[ 203 ] ]

                        aCellData := _GetGridCellData( i )

                        _HMG_SYSDATA[ 195 ] := aCellData[ 1 ]
                        _HMG_SYSDATA[ 196 ] := aCellData[ 2 ]
                        _HMG_SYSDATA[ 197 ] := aCellData[ 3 ]
                        _HMG_SYSDATA[ 198 ] := aCellData[ 4 ]
                        _HMG_SYSDATA[ 199 ] := aCellData[ 5 ]
                        _HMG_SYSDATA[ 200 ] := aCellData[ 6 ]

                        EVAL( _HMG_SYSDATA[ 16 ] [ i ] )
                        _PopEventInfo()

                        _HMG_SYSDATA[ 195 ] := 0
                        _HMG_SYSDATA[ 196 ] := 0
                        _HMG_SYSDATA[ 197 ] := 0
                        _HMG_SYSDATA[ 198 ] := 0
                        _HMG_SYSDATA[ 199 ] := 0
                        _HMG_SYSDATA[ 200 ] := 0

                        // Return 0

                     ENDIF

                  ENDIF

                  RETURN 0

               ENDIF

            ENDIF

            //  DatePicker Process ..................................

            IF _HMG_SYSDATA[ 1 ] [ i ] = "DATEPICK"

               //  DatePicker Change ............................

               IF ( GetNotifyCode( lParam ) == DTN_DATETIMECHANGE .AND. SendMessage( _HMG_SYSDATA[ 3 ] [ i ], DTM_GETMONTHCAL, 0, 0 ) == 0 ) .OR. ( GetNotifyCode( lParam ) == DTN_CLOSEUP )
                  _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )
                  RETURN 0
               ENDIF

               //  DatePicker LostFocus ........................

               IF GetNotifyCode( lParam ) = NM_KILLFOCUS
                  _DoControlEventProcedure( _HMG_SYSDATA[ 10 ] [ i ], i )
                  RETURN 0
               ENDIF

               //  DatePicker GotFocus .........................

               IF GetNotifyCode( lParam ) = NM_SETFOCUS
                  VirtualChildControlFocusProcess( _HMG_SYSDATA[ 3 ] [ i ], _HMG_SYSDATA[ 4 ] [ i ] )
                  _DoControlEventProcedure( _HMG_SYSDATA[ 11 ] [ i ], i )
                  RETURN 0
               ENDIF

            ENDIF

            //  TimePicker Process ( Dr. Claudio Soto, April 2013 ) ..................................

            IF _HMG_SYSDATA[ 1 ] [ i ] = "TIMEPICK"

               //  TimePicker Change ............................

               IF ( GetNotifyCode( lParam ) == DTN_DATETIMECHANGE )
                  _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )
                  RETURN 0
               ENDIF

               //  TimePicker LostFocus ........................

               IF GetNotifyCode( lParam ) = NM_KILLFOCUS
                  _DoControlEventProcedure( _HMG_SYSDATA[ 10 ] [ i ], i )
                  RETURN 0
               ENDIF

               //  TimePicker GotFocus .........................

               IF GetNotifyCode( lParam ) = NM_SETFOCUS
                  VirtualChildControlFocusProcess( _HMG_SYSDATA[ 3 ] [ i ], _HMG_SYSDATA[ 4 ] [ i ] )
                  _DoControlEventProcedure( _HMG_SYSDATA[ 11 ] [ i ], i )
                  RETURN 0
               ENDIF

            ENDIF

            // by Dr. Claudio Soto, January 2014
            //  RichEditBox Processing ......................................

            IF _HMG_SYSDATA[ 1 ] [ i ] = "RICHEDIT"

               //  RichEditBox Selelection Change ..................................

               IF GetNotifyCode( lParam ) = EN_SELCHANGE
                  _DoControlEventProcedure( _HMG_SYSDATA[ 22 ] [ i ], i )
                  RETURN 0
               ENDIF

               IF GetNotifyCode( lParam ) = EN_LINK
                  // GetNotifyLink ( lParam , @Link_wParam , @Link_lParam , @Link_cpMin         , @Link_cpMax         )   -> return Link_nMsg

                  IF GetNotifyLink( lParam, NIL, NIL, @_HMG_CharRange_Min, @_HMG_CharRange_Max ) = WM_LBUTTONDOWN
                     _DoControlEventProcedure( _HMG_SYSDATA[ 31 ] [ i ], i )
                     _HMG_CharRange_Min := 0
                     _HMG_CharRange_Max := 0
                     RETURN 0
                  ENDIF

               ENDIF

            ENDIF

            //  Tab Processing ......................................

            IF _HMG_SYSDATA[ 1 ] [ i ] = "TAB"
               //  Tab Change ..................................

               IF GetNotifyCode( lParam ) = TCN_SELCHANGE
                  IF HMG_LEN( _HMG_SYSDATA[ 7 ] [ i ] ) > 0
                     UpdateTab( i )
                  ENDIF
                  _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )
                  RETURN 0
               ENDIF

            ENDIF

            //  Tree Processing .....................................

            IF _HMG_SYSDATA[ 1 ] [ i ] = "TREE"

               //  Tree LostFocus .............................

               IF GetNotifyCode( lParam ) = NM_KILLFOCUS
                  _DoControlEventProcedure( _HMG_SYSDATA[ 10 ] [ i ], i )
                  RETURN 0
               ENDIF

               //  Tree GotFocus ..............................

               IF GetNotifyCode( lParam ) = NM_SETFOCUS
                  VirtualChildControlFocusProcess( _HMG_SYSDATA[ 3 ] [ i ], _HMG_SYSDATA[ 4 ] [ i ] )
                  _DoControlEventProcedure( _HMG_SYSDATA[ 11 ] [ i ], i )
                  RETURN 0
               ENDIF

               //  Tree Change ................................

               IF GetNotifyCode( lParam ) = TVN_SELCHANGED
                  _DoControlEventProcedure( _HMG_SYSDATA[ 12 ] [ i ], i )
                  RETURN 0
               ENDIF

               //  Tree Double Click .........................

               IF GetNotifyCode( lParam ) == NM_DBLCLK
                  _DoControlEventProcedure( _HMG_SYSDATA[ 16 ] [ i ], i )
                  RETURN 0
               ENDIF

               //  Tree OnExpand and OnCollapse ......................... (Dr. Claudio Soto, July 2014)

               IF GetNotifyCode( lParam ) == TVN_ITEMEXPANDING /*TVN_ITEMEXPANDED*/

                  _HMG_ret := NOTIFY_TREEVIEW_ITEMEXPAND( lParam )
                  _HMG_This_TreeItem_Value := NIL

                  IF _HMG_SYSDATA[ 9 ] [ i ] == .F.
                     _HMG_This_TreeItem_Value := ASCAN( _HMG_SYSDATA[ 7 ] [ i ], _HMG_ret[ 2 ] )
                  ELSE
                     _HMG_This_TreeItem_Value := TREEITEM_GETID( _HMG_SYSDATA[ 3 ] [ i ], _HMG_ret[ 2 ] )
                  ENDIF

                  IF _HMG_ret[ 1 ] == TVE_EXPAND
                     _DoControlEventProcedure( _HMG_SYSDATA[ 17 ] [ i ] [ 1 ], i )
                     _HMG_This_TreeItem_Value := NIL
                     RETURN 0
                  ENDIF

                  IF _HMG_ret[ 1 ] == TVE_COLLAPSE
                     _DoControlEventProcedure( _HMG_SYSDATA[ 17 ] [ i ] [ 2 ], i )
                     _HMG_This_TreeItem_Value := NIL
                     RETURN 0
                  ENDIF

               ENDIF
               //  Tree Dynamic ForeColor, BackColor and Font   ......................... (Dr. Claudio Soto, July 2014)
               IF GetNotifyCode( lParam ) == NM_CUSTOMDRAW
                  IF VALTYPE( _HMG_SYSDATA[ 40 ] [ i ] [ 1 ] ) == "B" .OR. ;                                                                // DynamicBackColor
                              VALTYPE( _HMG_SYSDATA[ 40 ] [ i ] [ 2 ] ) == "B" .OR. ;                                                       // DynamicForeColor
                              VALTYPE( _HMG_SYSDATA[ 40 ] [ i ] [ 3 ] ) == "B"                                                              // DynamicFont

                     SetNewBehaviorWndProc( .T. )                     // ADD2, December 2014

                     r := TREEVIEW_CUSTOMDRAW_GetAction( lParam )
                     IF r <> - 1
                        RETURN R                                      // return CDRF_NOTIFYITEMDRAW or CDRF_DODEFAULT
                     ENDIF

                     _HMG_This_TreeItem_Value := NIL
                     _HMG_ret := ASCAN( _HMG_SYSDATA[ 7 ] [ i ], TREEVIEW_CUSTOMDRAW_GETITEMHANDLE( lParam ) )

                     IF _HMG_ret > 0
                        IF _HMG_SYSDATA[ 9 ] [ i ] == .F.
                           _HMG_This_TreeItem_Value := _HMG_ret
                        ELSE
                           _HMG_This_TreeItem_Value := _HMG_SYSDATA[ 25 ] [ i ] [ _HMG_ret ]
                        ENDIF
                        RETURN _DoTreeCustomDraw( i, lParam )         // return CDRF_NEWFONT
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
         ENDIF

         // **********************************************************************
      CASE nMsg == WM_CLOSE
         // **********************************************************************

         IF GetEscapeState() < 0                                      // GetKeyState( VK_ESCAPE )
            IF GetFocusedControlType() == 'EDIT'
               RETURN ( 1 )                                           // Not Closes Window
            ENDIF
         ENDIF

         i := ASCAN( _HMG_SYSDATA[ 67 ], hWnd )
         IF i > 0

            //  Process Interactive Close Event / Setting

            IF VALTYPE( _HMG_SYSDATA[ 106 ] [ i ] ) == 'B'
               xRetVal := _DoWindowEventProcedure( _HMG_SYSDATA[ 106 ] [ i ], i, 'WINDOW_ONINTERACTIVECLOSE' )
               IF VALTYPE( xRetVal ) = 'L'
                  IF !xRetVal
                     RETURN ( 1 )                                     // Not Closes Window
                  ENDIF
               ENDIF
            ENDIF

            DO CASE
               CASE _HMG_SYSDATA[ 339 ] == 0                          // _HMG_InteractiveClose
                  MsgStop( _HMG_SYSDATA[ 331 ] [ 3 ] )
                  RETURN ( 1 )                                        // Not Closes Window
               CASE _HMG_SYSDATA[ 339 ] == 2
                  IF !MsgYesNo( _HMG_SYSDATA[ 331 ] [ 1 ], _HMG_SYSDATA[ 331 ] [ 2 ] )
                     RETURN ( 1 )                                     // Not Closes Window
                  ENDIF
               CASE _HMG_SYSDATA[ 339 ] == 3
                  IF _HMG_SYSDATA[ 69 ] [ i ] == 'A'
                     IF !MsgYesNo( _HMG_SYSDATA[ 331 ] [ 1 ], _HMG_SYSDATA[ 331 ] [ 2 ] )
                        RETURN ( 1 )                                  // Not Closes Window
                     ENDIF
                  ENDIF
            ENDCASE

            //  Process AutoRelease Property

            IF _HMG_SYSDATA[ 105 ] [ i ] == .F.
               _HideWindow( _HMG_SYSDATA[ 66 ] [ i ] )
               RETURN ( 1 )                                           // Not Closes Window
            ENDIF

            //  If Not AutoRelease Destroy Window

            IF _HMG_SYSDATA[ 69 ] [ i ] == 'A'                        // Main Window
               ReleaseAllWindows()                                    // call ExitProcess(0) and ends the application
            ELSE
               IF VALTYPE( _HMG_SYSDATA[ 71 ] [ i ] ) == 'B'
                  _HMG_SYSDATA[ 252 ] := .T.
                  _DoWindowEventProcedure( _HMG_SYSDATA[ 71 ] [ i ], i, 'WINDOW_RELEASE' )
               ENDIF
               _hmg_OnHideFocusManagement( i )

#ifdef ALLOW_ONLY_ONE_MESSAGE_LOOP
               // DestroyWindow(hWnd): Destroys the specified window.
               // The function sends WM_DESTROY and WM_NCDESTROY messages to the window to deactivate it and remove the keyboard focus from it.
               // The function also destroys the window's MENU, flushes the thread MESSAGE QUEUE, destroys TIMERS, removes CLIPBOARD ownership,
               // and breaks the clipboard viewer chain (if the window is at the top of the viewer chain).
               // If the specified window is a parent or owner window, DestroyWindow automatically destroys the associated CHILD or OWNED windows
               // when it destroys the parent or owner window. The function first destroys child or owned windows, and then it destroys the parent or owner window.
               // DestroyWindow also destroys MODELESS DIALOG BOXES created by the CreateDialog function.

               DestroyWindow( _HMG_SYSDATA[ 67 ] [ i ] )              // _HMG_aFormHandles
#endif
            ENDIF

         ENDIF

         // **********************************************************************
      CASE nMsg == WM_DESTROY
         // **********************************************************************

         ControlCount := HMG_LEN( _HMG_SYSDATA[ 3 ] )
         i := ASCAN( _HMG_SYSDATA[ 67 ], hWnd )

         IF i > 0

            //  Remove Child Controls
            FOR x := 1 TO ControlCount
               IF _HMG_SYSDATA[ 4 ] [ x ] == hWnd                     // _HMG_aParentHandle
                  IF _HMG_SYSDATA[ 1 ] [ x ] == 'ACTIVEX'             // _HMG_aControlType
                     releasecontrol( _HMG_SYSDATA[ 3 ] [ x ] )        // _HMG_aControlHandle
                  ENDIF
                  IF _HMG_SYSDATA[ 1 ] [ x ] == 'BUTTON'
                     IMAGELIST_DESTROY( _HMG_SYSDATA[ 37 ] [ x ] )    // avoid the increase of GDI handles when subwindow with buttons is released
                  ENDIF
                  _EraseControl( x, i )                               // This function call: DeleteObject(), IMAGELIST_DESTROY(), ReleaseHotKey() and clean the content of _HMG_SYSDATA of control
               ENDIF
            NEXT x

            // Delete Brush
            DeleteObject( _HMG_SYSDATA[ 100 ] [ i ] )                 // _HMG_aFormBrushHandle

            // Update Form Index Variable
            mVar := '_' + _HMG_SYSDATA[ 66 ] [ i ]                    // _HMG_aFormNames
            IF TYPE( mVar ) != 'U'
               __MVPUT( mVar, 0 )
            ENDIF

            Tmp := NIL                                                // avoid warning message: defined variable but not used (need only ALLOW_ONLY_ONE_MESSAGE_LOOP is defined)

#ifndef ALLOW_ONLY_ONE_MESSAGE_LOOP

            //  If Window Was Multi-Activated, Determine If It Is The Last One.
            //  If Yes, Post Quit Message To Finish The Message Loop
            //  Quit Message, will be posted always for single activated windows.

            IF _HMG_SYSDATA[ 107 ] [ i ] > 0                          // _HMG_aFormActivateId
               TmpStr := '_HMG_ACTIVATE_' + ALLTRIM( STR( _HMG_SYSDATA[ 107 ] [ i ] ) )
               IF __MVEXIST( TmpStr )
                  Tmp := __MVGET( TmpStr )
                  IF VALTYPE( Tmp ) == 'N'
                     __MVPUT( TmpStr, Tmp - 1 )
                     IF Tmp - 1 == 0
                        PostQuitMessage( 0 )
                        __MVXRELEASE( TmpStr )
                     ENDIF
                  ENDIF
               ENDIF
            ELSE
               PostQuitMessage( 0 )
            ENDIF

#endif

#ifdef ALLOW_ONLY_ONE_MESSAGE_LOOP
            IF _HMG_SYSDATA[ 69 ] [ i ] == "A"                        // Main Window
               PostQuitMessage( 0 )
            ENDIF
#endif

            _HMG_SYSDATA[ 65 ] [ i ] := .T.
            _HMG_SYSDATA[ 67 ] [ i ] := 0
            _HMG_SYSDATA[ 66 ] [ i ] := ""
            _HMG_SYSDATA[ 68 ] [ i ] := .f.
            _HMG_SYSDATA[ 69 ] [ i ] := ""
            _HMG_SYSDATA[ 70 ] [ i ] := 0
            _HMG_SYSDATA[ 72 ] [ i ] := ""
            _HMG_SYSDATA[ 71 ] [ i ] := ""
            _HMG_SYSDATA[ 73 ] [ i ] := 0
            _HMG_SYSDATA[ 74 ] [ i ] := 0
            _HMG_SYSDATA[ 75 ] [ i ] := ""
            _HMG_SYSDATA[ 76 ] [ i ] := ""
            _HMG_SYSDATA[ 77 ] [ i ] := ""
            _HMG_SYSDATA[ 78 ] [ i ] := ""
            _HMG_SYSDATA[ 79 ] [ I ] := Nil
            _HMG_SYSDATA[ 80 ] [ i ] := ""
            _HMG_SYSDATA[ 81 ] [ i ] := .F.
            _HMG_SYSDATA[ 82 ] [ i ] := ''
            _HMG_SYSDATA[ 83 ] [ i ] := ''
            _HMG_SYSDATA[ 84 ] [ i ] := ''
            _HMG_SYSDATA[ 87 ] [ i ] := 0
            _HMG_SYSDATA[ 88 ] [ I ] := 0
            _HMG_SYSDATA[ 89 ] [ i ] := {}
            _HMG_SYSDATA[ 90 ] [ i ] := {}
            _HMG_SYSDATA[ 91 ] [ i ] := 0
            _HMG_SYSDATA[ 85 ] [ i ] := ""
            _HMG_SYSDATA[ 86 ] [ i ] := ""
            _HMG_SYSDATA[ 92 ] [ i ] := 0
            _HMG_SYSDATA[ 93 ] [ i ] := .f.
            _HMG_SYSDATA[ 94 ] [ i ] := ""
            _HMG_SYSDATA[ 95 ] [ i ] := ""
            _HMG_SYSDATA[ 96 ] [ i ] := ""
            _HMG_SYSDATA[ 97 ] [ i ] := ""
            _HMG_SYSDATA[ 98 ] [ i ] := ""
            _HMG_SYSDATA[ 99 ] [ i ] := ""
            _HMG_SYSDATA[ 100 ] [ i ] := 0
            _HMG_SYSDATA[ 101 ] [ i ] := 0
            _HMG_SYSDATA[ 102 ] [ i ] := {}
            _HMG_SYSDATA[ 103 ] [ i ] := Nil
            _HMG_SYSDATA[ 104 ] [ i ] := Nil
            _HMG_SYSDATA[ 105 ] [ i ] := .F.
            _HMG_SYSDATA[ 106 ] [ i ] := ""
            _HMG_SYSDATA[ 107 ] [ i ] := 0
            _HMG_SYSDATA[ 108 ] [ i ] := NIL
            _HMG_SYSDATA[ 504 ] [ i ] := { NIL, NIL, NIL, NIL }
            _HMG_SYSDATA[ 511 ] [ i ] := 0
            _HMG_SYSDATA[ 512 ] [ i ] := { NIL, NIL, NIL, NIL, NIL, NIL, NIL }

            _HMG_SYSDATA[ 252 ] := .F.

         ENDIF

         // Dr. Claudio Soto (July 2013)

         IF _HMG_LastActiveControlIndex > 0 .AND. IsControlDeletedByIndex( _HMG_LastActiveControlIndex ) == .T.
            aux_hWnd := GetFocus()
            IF aux_hWnd == 0
               aux_hWnd := GetActiveWindow()
            ENDIF
            nIndex := 0
            IF aux_hWnd <> 0
               nIndex := GetControlIndexByHandle( aux_hWnd )
            ENDIF
            _HMG_LastActiveControlIndex := nIndex
         ENDIF

         // **********************************************************************
      CASE nMsg == WM_NCACTIVATE
         // **********************************************************************

         IF wParam == 0
            IF lParam == 0
               IF _isWindowDefined( '_HMG_GRID_InplaceEdit' )
                  _HMG_SYSDATA[ 256 ] := .F.
                  EXITGRIDCELL()
               ENDIF
               IF VALTYPE( _HMG_SYSDATA[ 296 ] ) == 'B'
                  EVAL( _HMG_SYSDATA[ 296 ] )
               ENDIF
            ENDIF
         ENDIF

   ENDCASE

RETURN ( 0 )
// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function GetWindowType()
*+
*+    Called from ( h_windows.prg )   2 - function _releasewindow()
*+                                   2 - function _definewindow()
*+                                   2 - function _activatewindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetWindowType( FormName )

   // -----------------------------------------------------------------------------*
LOCAL mVar, i

   mVar := '_' + FormName

   i := &mVar
   IF i == 0
      RETURN ''
   ENDIF

RETURN ( _HMG_SYSDATA[ 69 ] [ &mVar ] )
// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _IsWindowActive()
*+
*+    Called from ( h_browse.prg )   2 - function _browseinplaceedit()
*+                ( h_grid.prg )   4 - function _hmg_gridinplaceedit()
*+                                   1 - procedure _hmg_grid_enablekeys()
*+                ( h_windows.prg )   1 - function _releasewindow()
*+                                   2 - function _activatewindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _IsWindowActive( FormName )

   // -----------------------------------------------------------------------------*
LOCAL mVar, i

   FormName := CharRem( CHR( 34 ) + CHR( 39 ), FormName )

   mVar := '_' + FormName

   IF TYPE( mVar ) = 'U'
      RETURN ( .F. )
   ELSE
      i := &mVar
      IF i == 0
         RETURN .f.
      ENDIF
      RETURN ( _HMG_SYSDATA[ 68 ] [ &mVar ] )
   ENDIF

RETURN .F.

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _IsWindowDefined()
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
*+                ( h_controlmisc.prg )   1 - function _hmg_printer_showpreview()
*+                                   1 - function _defineactivex()
*+                                   1 - function setproperty()
*+                                   2 - function getproperty()
*+                                   1 - function domethod()
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
*+                ( h_windows.prg )   1 - function events()
*+                                   1 - function _releasewindow()
*+                                   1 - function _definewindow()
*+                                   1 - function _definemodalwindow()
*+                                   1 - function _definesplitchildwindow()
*+                                   1 - function _definesplitbox()
*+                                   2 - function _activatewindow()
*+                                   1 - function printwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _IsWindowDefined( FormName )

   // -----------------------------------------------------------------------------*
LOCAL mVar, i

   FormName := CharRem( CHR( 34 ) + CHR( 39 ), FormName )

   mVar := '_' + FormName

   IF TYPE( mVar ) = 'U'
      RETURN ( .F. )
   ELSE
      i := &mVar
      IF i == 0
         RETURN .f.
      ENDIF
      RETURN ( .NOT. ( _HMG_SYSDATA[ 65 ] [ &mVar ] ) )
   ENDIF

RETURN .F.

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function GetFormName()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetFormName( FormName )

   // -----------------------------------------------------------------------------*
LOCAL mVar, i

   mVar := '_' + FormName

   i := &mVar
   IF i == 0
      RETURN ''
   ENDIF

RETURN ( _HMG_SYSDATA[ 66 ] [ &mVar ] )
// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function GetFormToolTipHandle()
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
*+                ( h_controlmisc.prg )   1 - function _settooltip()
*+                                   1 - function createthumbnails()
*+                ( h_datepicker.prg )   1 - function _definedatepick()
*+                ( h_editbox.prg )   1 - function _defineeditbox()
*+                ( h_image.prg )   1 - function _defineimage()
*+                ( h_ipaddress.prg )   1 - function _defineipaddress()
*+                ( h_label.prg )   1 - function _definelabel()
*+                ( h_listbox.prg )   1 - function _definelistbox()
*+                ( h_monthcal.prg )   1 - function _definemonthcal()
*+                ( h_progressbar.prg )   1 - function _defineprogressbar()
*+                ( h_radio.prg )   2 - function _defineradiogroup()
*+                ( h_richeditbox.prg )   1 - function _definericheditbox()
*+                ( h_slider.prg )   1 - function _defineslider()
*+                ( h_spinner.prg )   1 - function _definespinner()
*+                ( h_tab.prg )   1 - function _definetab()
*+                ( h_textbox.prg )   1 - function _definetextbox()
*+                                   1 - function _definemaskedtextbox()
*+                                   1 - function _definecharmasktextbox()
*+                ( h_toolbar.prg )   1 - function _definetoolbar()
*+                ( h_tree.prg )   1 - function _definetree()
*+                ( h_windows.prg )   2 - function _definewindow()
*+                                   2 - function _definemodalwindow()
*+                                   2 - function _definesplitchildwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetFormToolTipHandle( FormName )

   // -----------------------------------------------------------------------------*
LOCAL mVar, i

   mVar := '_' + FormName

   i := &mVar
   IF i == 0
      RETURN 0
   ENDIF

RETURN ( _HMG_SYSDATA[ 73 ] [ &mVar ] )

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function GetMenuToolTipHandle()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _settooltip()
*+                ( h_menu.prg )   1 - function _definemenuitem()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetMenuToolTipHandle( FormName )

   // -----------------------------------------------------------------------------*
LOCAL mVar, i

   mVar := '_' + FormName

   i := &mVar
   IF i == 0
      RETURN 0
   ENDIF

RETURN ( _HMG_SYSDATA[ 511 ] [ &mVar ] )

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function GetFormHandle()
*+
*+    Called from ( h_browse.prg )   1 - function _definebrowse()
*+                ( h_grid.prg )   1 - function _definegrid()
*+                ( h_eventcb.prg )   1 - function getsplitchildwindowhandle()
*+                ( h_timepicker.prg )   1 - function _definetimepick()
*+                ( h_button.prg )   1 - function _definebutton()
*+                                   1 - function _defineimagebutton()
*+                                   1 - function _definemixedbutton()
*+                ( h_checkbox.prg )   1 - function _definecheckbox()
*+                                   1 - function _definecheckbutton()
*+                                   1 - function _defineimagecheckbutton()
*+                ( h_combo.prg )   1 - function _definecombo()
*+                ( h_controlmisc.prg )   2 - function _getvalue()
*+                                   1 - function _setvalue()
*+                                   1 - function _enablecontrol()
*+                                   1 - function _settooltip()
*+                                   1 - function _getfocusedcontrol()
*+                                  35 - function _hmg_printer_showpreview()
*+                                   1 - function _hmg_printer_spltchldmousecursor()
*+                                   1 - function _hmg_printer_spltchldmouseclick()
*+                                   2 - function createthumbnails()
*+                                   2 - function _hmg_printer_processthumbnails()
*+                                   4 - function _hmg_printer_go_to_page()
*+                                   1 - function _hmg_printer_hscrollboxprocess()
*+                                   1 - function _hmg_printer_vscrollboxprocess()
*+                                   2 - function _hmg_printer_preview_onpaint()
*+                                   4 - function _hmg_printer_printpages()
*+                                   4 - function _hmg_printer_printpagesdo()
*+                                  20 - function _hmg_printer_mousezoom()
*+                                   8 - function _hmg_printer_zoom()
*+                                   1 - function _defineactivex()
*+                                   3 - function setproperty()
*+                                   7 - function getproperty()
*+                                   1 - function domethod()
*+                ( h_datepicker.prg )   1 - function _definedatepick()
*+                ( h_editbox.prg )   1 - function _defineeditbox()
*+                ( h_frame.prg )   1 - function _defineframe()
*+                ( h_hotkey.prg )   1 - procedure _definehotkey()
*+                                   1 - procedure _releasehotkey()
*+                                   1 - function _gethotkey()
*+                ( h_image.prg )   1 - function _defineimage()
*+                ( h_ipaddress.prg )   1 - function _defineipaddress()
*+                ( h_label.prg )   1 - function _definelabel()
*+                ( h_listbox.prg )   1 - function _definelistbox()
*+                ( h_media.prg )   2 - function _defineplayer()
*+                                   2 - function _defineanimatebox()
*+                ( h_menu.prg )   1 - function _definemainmenu()
*+                                   1 - function _definemenuitem()
*+                                   1 - function _definecontextmenu()
*+                                   1 - function _definenotifymenu()
*+                                   1 - function _definedropdownmenu()
*+                                   1 - function ismainmenudefined()
*+                                   1 - function iscontextmenudefined()
*+                                   1 - function isnotifymenudefined()
*+                                   1 - function isdropdownmenudefined()
*+                                   1 - function releasemainmenu()
*+                                   1 - function releasecontextmenu()
*+                                   1 - function releasenotifymenu()
*+                                   1 - function releasedropdownmenu()
*+                                   1 - function _definecontrolcontextmenu()
*+                                   1 - function iscontrolcontextmenudefined()
*+                                   1 - function releasecontrolcontextmenu()
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
*+                ( h_timer.prg )   2 - function _definetimer()
*+                ( h_toolbar.prg )   1 - function _definetoolbar()
*+                                   1 - procedure repositiontoolbar()
*+                ( h_tree.prg )   1 - function _definetree()
*+                ( h_windows.prg )   2 - function _centerwindow()
*+                                   1 - function _restorewindow()
*+                                   1 - function _maximizewindow()
*+                                   1 - function _minimizewindow()
*+                                   2 - function _definewindow()
*+                                   2 - function _definesplitchildwindow()
*+                                   1 - function _setwindowsizepos()
*+                                   1 - function _getwindowsizepos()
*+                                   1 - function _definesplitbox()
*+                                   1 - function _setwindowrgn()
*+                                   1 - function _setpolywindowrgn()
*+                                   1 - function _activatewindow()
*+                                   1 - function printwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetFormHandle( FormName )

   // -----------------------------------------------------------------------------*
LOCAL mVar, i

   mVar := '_' + FormName

   i := &mVar
   IF i == 0
      RETURN 0
   ENDIF

RETURN ( _HMG_SYSDATA[ 67 ] [ &mVar ] )

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function ReleaseAllWindows()
*+
*+    Called from ( h_windows.prg )   1 - function events()
*+                                   1 - function _releasewindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION ReleaseAllWindows()

   // -----------------------------------------------------------------------------*
LOCAL i, FormCount, x, ControlCount

   IF _HMG_SYSDATA[ 232 ] == 'WINDOW_RELEASE'
      MsgHMGError( "Release a window in its own 'on release' procedure or release the main window in any 'on release' procedure is not allowed. Program terminated" )
   ENDIF

   //  _HMG_SYSDATA [  65 ] -> _HMG_aFormDeleted
   //  _HMG_SYSDATA [  66 ] -> _HMG_aFormNames
   //  _HMG_SYSDATA [  67 ] -> _HMG_aFormHandles
   //  _HMG_SYSDATA [  68 ] -> _HMG_aFormActive
   //  _HMG_SYSDATA [  69 ] -> _HMG_aFormType
   //  _HMG_SYSDATA [  70 ] -> _HMG_aFormParentHandle
   //  _HMG_SYSDATA [  71 ] -> _HMG_aFormReleaseProcedure

   FormCount := HMG_LEN( _HMG_SYSDATA[ 67 ] )

   FOR i = 1 TO FormCount
      IF _HMG_SYSDATA[ 68 ] [ i ] == .t.                              // _HMG_aFormActive

         _DoWindowEventProcedure( _HMG_SYSDATA[ 71 ] [ i ], i, 'WINDOW_RELEASE' )

         IF .NOT. EMPTY( _HMG_SYSDATA[ 82 ] [ i ] )
            _HMG_SYSDATA[ 82 ] [ i ] := ''
            ShowNotifyIcon( _HMG_SYSDATA[ 67 ] [ i ], .F., NIL, NIL )
         ENDIF

      ENDIF

      // if set mixedmode
      //      _HMG_SYSDATA [ 65 ] [i]  = .T.              // _HMG_aFormDeleted
      //      DestroyWindow ( _HMG_SYSDATA [ 67 ] [i] )   // _HMG_aFormHandles

   NEXT i

   ControlCount := HMG_LEN( _HMG_SYSDATA[ 3 ] )

   FOR x := 1 TO ControlCount

      IF _HMG_SYSDATA[ 1 ] [ x ] == 'HOTKEY'
         ReleaseHotKey( _HMG_SYSDATA[ 4 ] [ x ], _HMG_SYSDATA[ 5 ] [ x ] )                                                                  // This is not necessary here !!!
      ENDIF

   NEXT x

   // Dr. Claudio Soto (July 2013)
   HMG_HOOK_UNINSTALL()

   UnloadAllDll()

   DBCLOSEALL()

   ExitProcess( 0 )

   // if Set MixedMode --> call PostQuitMessage(0) and not ExitProcess(0), dbcloseall(), UnloadAllDll() ???

RETURN Nil

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _ReleaseWindow()
*+
*+    Called from ( h_controlmisc.prg )   1 - function domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _ReleaseWindow( FormName )

   // -----------------------------------------------------------------------------*
LOCAL FormCount, b, i, x

   b := _HMG_SYSDATA[ 339 ]
   _HMG_SYSDATA[ 339 ] := 1

   FormCount := HMG_LEN( _HMG_SYSDATA[ 67 ] )

   IF .NOT. _IsWindowDefined( Formname )
      MsgHMGError( "Window: " + FormName + " is not defined. Program terminated" )
   ENDIF

   IF .NOT. _IsWindowActive( Formname )
      MsgHMGError( "Window: " + FormName + " is not active. Program terminated" )
   ENDIF

   IF _HMG_SYSDATA[ 232 ] == 'WINDOW_RELEASE'
      IF GetFormIndex( FormName ) == _HMG_SYSDATA[ 203 ]
         MsgHMGError( "Release a window in its own 'on release' procedure or release the main window in any 'on release' procedure is not allowed. Program terminated" )
      ENDIF
   ENDIF

   // If the window to release is the main application window, release all windows command will be executed
   IF GetWindowType( FormName ) == 'A'                                // Release MainWindow

      IF _HMG_SYSDATA[ 232 ] == 'WINDOW_RELEASE'
         MsgHMGError( "Release a window in its own 'on release' procedure or release the main window in any 'on release' procedure is not allowed. Program terminated" )
      ELSE
         ReleaseAllWindows()                                          // in ReleaseAllWindows() is called HMG_HOOK_UNINSTALL()
      ENDIF

   ENDIF

   IF GetWindowType( FormName ) == 'P'
      MsgHMGError( "Release a 'Panel' window is not allowed (It is released via its parent). Program terminated" )
   ENDIF

   i := GetFormIndex( Formname )

   //  Release Window

   //  _HMG_SYSDATA [  67 ] -> _HMG_aFormHandles
   //  _HMG_SYSDATA [  69 ] -> _HMG_aFormType
   //  _HMG_SYSDATA [  70 ] -> _HMG_aFormParentHandle
   //  _HMG_SYSDATA [ 167 ] -> _hmg_activemodalhandle
   //  _HMG_SYSDATA [ 181 ] -> _HMG_MainHandle

   IF _HMG_SYSDATA[ 69 ] [ i ] == 'M' .AND. _HMG_SYSDATA[ 167 ] <> _HMG_SYSDATA[ 67 ] [ i ]

      IF IsWindowVisible( _HMG_SYSDATA[ 67 ] [ i ] )
         MsgHMGError( "Non top modal windows can't be released. Program terminated" )
      ELSE
         EnableWindow( _HMG_SYSDATA[ 67 ] [ i ] )
         SendMessage( _HMG_SYSDATA[ 67 ] [ i ], WM_SYSCOMMAND, SC_CLOSE, 0 )
         // SendMessage( _HMG_SYSDATA [ 67 ] [i], WM_CLOSE, 0, 0 )   // ADD October 2015, REMOVE January 2016
      ENDIF

   ELSE

      FOR x := 1 TO FormCount
         IF _HMG_SYSDATA[ 70 ] [ x ] == _HMG_SYSDATA[ 67 ] [ i ]      // if _HMG_aFormParentHandle == FormHandle to Release
            _HMG_SYSDATA[ 70 ] [ x ] := _HMG_SYSDATA[ 181 ]           // _HMG_aFormParentHandle := _HMG_MainHandle  -->  WHY THIS ???
         ENDIF
      NEXT x

      EnableWindow( _HMG_SYSDATA[ 67 ] [ i ] )
      SendMessage( _HMG_SYSDATA[ 67 ] [ i ], WM_SYSCOMMAND, SC_CLOSE, 0 )
      // SendMessage( _HMG_SYSDATA [ 67 ] [i], WM_CLOSE, 0, 0 )   // ADD October 2015, REMOVE January 2016
   ENDIF

   _HMG_SYSDATA[ 339 ] := b

RETURN Nil

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _ShowWindow()
*+
*+    Called from ( h_controlmisc.prg )   1 - function domethod()
*+                ( h_windows.prg )   1 - function _restorewindow()
*+                                   4 - function _activatewindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _ShowWindow( FormName )

   // -----------------------------------------------------------------------------*
LOCAL i, FormCount, x
LOCAL ActiveWindowHandle

   i := GetFormIndex( FormName )

   IF _HMG_SYSDATA[ 69 ] [ i ] == "M"

      // Find Parent

      //  _HMG_SYSDATA [  69 ] -> _HMG_aFormType
      //  _HMG_SYSDATA [  70 ] -> _HMG_aFormParentHandle
      //  _HMG_SYSDATA [ 167 ] -> _hmg_activemodalhandle
      //  _HMG_SYSDATA [ 271 ] -> _HMG_IsModalActive

      IF _HMG_SYSDATA[ 271 ]
         _HMG_SYSDATA[ 70 ] [ i ] := _HMG_SYSDATA[ 167 ]
      ELSE

         ActiveWindowhandle := _HMG_SYSDATA[ 166 ]
         x := ASCAN( _HMG_SYSDATA[ 67 ], ActiveWindowhandle )
         IF x > 0
            _HMG_SYSDATA[ 70 ] [ i ] := ActiveWindowhandle
         ELSE
            _HMG_SYSDATA[ 70 ] [ i ] := _HMG_SYSDATA[ 181 ]
         ENDIF

      ENDIF

      FormCount := HMG_LEN( _HMG_SYSDATA[ 67 ] )

      FOR x := 1 TO FormCount

         IF x <> i .AND. _HMG_SYSDATA[ 69 ] [ x ] != 'X' .AND. _HMG_SYSDATA[ 69 ] [ x ] != 'P' .AND. _HMG_SYSDATA[ 70 ] [ x ] != _HMG_SYSDATA[ 67 ] [ i ]
            DisableWindow( _HMG_SYSDATA[ 67 ] [ x ] )
         ENDIF

      NEXT x

      IF HMG_LEN( _HMG_SYSDATA[ 90 ] [ i ] ) > 0
         FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 90 ] [ i ] )
            EnableWindow( _HMG_SYSDATA[ 67 ] [ _HMG_SYSDATA[ 90 ] [ i ] [ x ] ] )
         NEXT x
      ENDIF

      _HMG_SYSDATA[ 271 ] := .T.
      _HMG_SYSDATA[ 167 ] := _HMG_SYSDATA[ 67 ] [ i ]
      EnableWindow( _HMG_SYSDATA[ 67 ] [ i ] )

      IF _SetFocusedSplitChild( i ) == .f.
         _SetActivationFocus( i )
      ENDIF

   ENDIF

   ShowWindow( _HMG_SYSDATA[ 67 ] [ i ] )

   DO EVENTS                                                          // ProcessMessages()

RETURN Nil

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _HideWindow()
*+
*+    Called from ( h_controlmisc.prg )   1 - function domethod()
*+                ( h_windows.prg )   1 - function events()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HideWindow( FormName )

   // -----------------------------------------------------------------------------*
LOCAL i

   i := GetFormIndex( FormName )

   IF i > 0

      IF IsWindowVisible( _HMG_SYSDATA[ 67 ] [ i ] )

         IF _HMG_SYSDATA[ 69 ] [ i ] == 'M'
            IF _HMG_SYSDATA[ 167 ] <> _HMG_SYSDATA[ 67 ] [ i ]
               MsgHMGError( "Non top modal windows can't be hide. Program terminated" )
            ENDIF
         ENDIF

         HideWindow( _HMG_SYSDATA[ 67 ] [ i ] )
         _hmg_OnHideFocusManagement( i )

      ENDIF

   ENDIF

RETURN Nil
// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _CenterWindow()
*+
*+    Called from ( h_controlmisc.prg )   3 - function domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _CenterWindow( FormName, Parent )

   // -----------------------------------------------------------------------------*
   C_Center( GetFormHandle( FormName ), IIF( VALTYPE( Parent ) == "C", GetFormHandle( Parent ), Parent ) )
RETURN Nil
// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _RestoreWindow()
*+
*+    Called from ( h_controlmisc.prg )   1 - function domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _RestoreWindow( FormName )

   // -----------------------------------------------------------------------------*
LOCAL h
   _ShowWindow( FormName )
   H = GetFormHandle( FormName )
   RESTORE( H )
RETURN Nil
// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _MaximizeWindow()
*+
*+    Called from ( h_controlmisc.prg )   1 - function domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _MaximizeWindow( FormName )

   // -----------------------------------------------------------------------------*
LOCAL h
   H = GetFormHandle( FormName )
   Maximize( H )
RETURN Nil
// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _MinimizeWindow()
*+
*+    Called from ( h_controlmisc.prg )   1 - function domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _MinimizeWindow( FormName )

   // -----------------------------------------------------------------------------*
LOCAL h
   H = GetFormHandle( FormName )
   Minimize( H )
RETURN Nil

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function HMG_MakeWindowsClassName()
*+
*+    Called from ( h_windows.prg )   3 - function _definewindow()
*+                                   3 - function _definemodalwindow()
*+                                   3 - function _definesplitchildwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_MakeWindowsClassName( cForm )

LOCAL ClassName := "_HMG_" + cForm + "_" + hb_NtoS( GetCurrentThreadID() )
RETURN ClassName
// -----------------------------------------------------------------------------*

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _DefineWindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _DefineWindow( FormName, Caption, x, y, w, h, nominimize, nomaximize, nosize, nosysmenu, nocaption, StatusBar, StatusText, initprocedure, ReleaseProcedure, MouseDragProcedure, SizeProcedure, ClickProcedure, MouseMoveProcedure, aRGB, PaintProcedure, noshow, topmost, main, icon, child, fontname, fontsize, NotifyIconName, NotifyIconTooltip, NotifyIconLeftClick, GotFocus, LostFocus, virtualheight, VirtualWidth, scrollleft, scrollright, scrollup, scrolldown, hscrollbox, vscrollbox, helpbutton, maximizeprocedure, minimizeprocedure, cursor, NoAutoRelease, InteractiveCloseProcedure, visible, autorelease, minbutton, maxbutton, sizable, sysmenu, titlebar, cPanelParent, panel )

   // -----------------------------------------------------------------------------*
LOCAL i, htooltip, mVar, vscroll, hscroll, BrushHandle, k := 0, FormHandle, ParentHandle
LOCAL cType
LOCAL hWnd_ToolTip

   //  Unused Parameters

StatusBar := Nil
StatusText := Nil

   DEFAULT x := GetDesktopRealLeft()
   DEFAULT y := GetDesktopRealTop()
   DEFAULT w := GetDeskTopRealWidth()
   DEFAULT h := GetDeskTopRealHeight()

   Parenthandle := 0

   IF VALTYPE( cPanelParent ) == 'C' .AND. panel == .f.

      MsgHMGError( "Parent can be specified only for Panel windows. Program Terminated" )

   ENDIF

   IF .NOT. EMPTY( _HMG_SYSDATA[ 223 ] ) .AND. panel == .f.
      MsgHMGError( "Only Panel windows can be defined inside a DEFINE WINDOW...END WINDOW structure. Program Terminated" )
   ENDIF

   IF VALTYPE( sizable ) == "L"
      nosize := .NOT. sizable
   ENDIF

   IF VALTYPE( sysmenu ) == "L"
      nosysmenu := .NOT. sysmenu
   ENDIF

   IF VALTYPE( titlebar ) == "L"
      nocaption := .NOT. titlebar
   ENDIF

   IF VALTYPE( minbutton ) == "L"
      nominimize := .NOT. minbutton
   ENDIF

   IF VALTYPE( maxbutton ) == "L"
      nomaximize := .NOT. maxbutton
   ENDIF

   IF VALTYPE( autorelease ) == "L"
      NoAutoRelease := .NOT. AutoRelease
   ENDIF

   IF VALTYPE( visible ) == "L"
      NoShow := .NOT. Visible
   ENDIF

   IF VALTYPE( FormName ) == "U"
      FormName := _HMG_SYSDATA[ 214 ]

      IF _HMG_SYSDATA[ 235 ] <> - 1

         y := _HMG_SYSDATA[ 235 ]
         x := _HMG_SYSDATA[ 236 ]
         w := _HMG_SYSDATA[ 237 ]
         h := _HMG_SYSDATA[ 238 ]

         _HMG_SYSDATA[ 235 ] := - 1
         _HMG_SYSDATA[ 236 ] := - 1
         _HMG_SYSDATA[ 237 ] := - 1
         _HMG_SYSDATA[ 238 ] := - 1

      ENDIF

   ENDIF

   IF _HMG_SYSDATA[ 183 ] > 0
      x := x + _HMG_SYSDATA[ 334 ] [ _HMG_SYSDATA[ 183 ] ]
      y := y + _HMG_SYSDATA[ 333 ] [ _HMG_SYSDATA[ 183 ] ]
   ENDIF

   FormName := ALLTRIM( FormName )

   IF Main

      i := ASCAN( _HMG_SYSDATA[ 69 ], 'A' )

      IF i > 0
         MsgHMGError( "Main Window Already Defined. Program Terminated" )
      ENDIF

      IF Child == .T.
         MsgHMGError( "Child and Main Clauses Can't Be Used Simultaneously. Program Terminated" )
      ENDIF

      IF NoAutoRelease == .T.
         MsgHMGError( "NOAUTORELEASE and MAIN Clauses Can't Be Used Simultaneously. Program Terminated" )
      ENDIF

      //    _HMG_SYSDATA [54] := _GETDDLMESSAGE()

   ELSE

      IF _HMG_MainWindowFirst == .T.
         i := ASCAN( _HMG_SYSDATA[ 69 ], 'A' )
         IF i <= 0
            MsgHMGError( "Main Window Not Defined. Program Terminated" )
         ENDIF
      ENDIF

      IF _IsWindowDefined( FormName )
         MsgHMGError( "Window: " + FormName + " already defined. Program Terminated" )
      ENDIF

      IF .NOT. EMPTY( NotifyIconName )
         MsgHMGError( "Notification Icon Allowed Only in Main Window. Program Terminated" )
      ENDIF

   ENDIF

   mVar := '_' + FormName

   IF child == .T.
      ParentHandle := _HMG_SYSDATA[ 181 ]
   ELSE
      ParentHandle := 0
   ENDIF

   IF panel == .T.

      IF VALTYPE( cPanelParent ) == 'C'

         IF GetWindowType( cPanelParent ) == 'X'
            MsgHMGError( "Panel Windows Can't Have SplitChild Parents. Program Terminated" )
         ENDIF

         ParentHandle := GetFormHandle( cPanelParent )
         _HMG_SYSDATA[ 240 ] := .F.

      ELSEIF .NOT. EMPTY( _HMG_SYSDATA[ 223 ] )

         IF GetWindowType( _HMG_SYSDATA[ 223 ] ) == 'X'
            MsgHMGError( "panel Windows Can't Have SplitChild Parents. Program Terminated" )
         ENDIF

         ParentHandle := GetFormHandle( _HMG_SYSDATA[ 223 ] )
         _HMG_SYSDATA[ 240 ] := .t.
         _HMG_SYSDATA[ 215 ] := _HMG_SYSDATA[ 223 ]

      ELSE

         MsgHMGError( "Panel Windows Must Have a Parent. Program Terminated" )

      ENDIF

   ENDIF

   IF VALTYPE( FontName ) == "U"
      _HMG_SYSDATA[ 224 ] := ""
   ELSE
      _HMG_SYSDATA[ 224 ] := FontName
   ENDIF

   IF VALTYPE( FontSize ) == "U"
      _HMG_SYSDATA[ 182 ] := 0
   ELSE
      _HMG_SYSDATA[ 182 ] := FontSize
   ENDIF

   IF VALTYPE( Caption ) == "U"
      Caption := ""
   ENDIF

   IF VALTYPE( scrollup ) == "U"
      scrollup := ""
   ENDIF
   IF VALTYPE( scrolldown ) == "U"
      scrolldown := ""
   ENDIF
   IF VALTYPE( scrollleft ) == "U"
      scrollleft := ""
   ENDIF
   IF VALTYPE( scrollright ) == "U"
      scrollright := ""
   ENDIF

   IF VALTYPE( hscrollbox ) == "U"
      hscrollbox := ""
   ENDIF
   IF VALTYPE( vscrollbox ) == "U"
      vscrollbox := ""
   ENDIF

   IF VALTYPE( InitProcedure ) == "U"
      InitProcedure := ""
   ENDIF

   IF VALTYPE( ReleaseProcedure ) == "U"
      ReleaseProcedure := ""
   ENDIF

   IF VALTYPE( MouseDragProcedure ) == "U"
      MouseDragProcedure := ""
   ENDIF

   IF VALTYPE( SizeProcedure ) == "U"
      SizeProcedure := ""
   ENDIF

   IF VALTYPE( ClickProcedure ) == "U"
      ClickProcedure := ""
   ENDIF

   IF VALTYPE( MouseMoveProcedure ) == "U"
      MouseMoveProcedure := ""
   ENDIF

   IF VALTYPE( PaintProcedure ) == "U"
      PaintProcedure := ""
   ENDIF

   IF VALTYPE( GotFocus ) == "U"
      GotFocus := ""
   ENDIF

   IF VALTYPE( LostFocus ) == "U"
      LostFocus := ""
   ENDIF

   IF VALTYPE( VirtualHeight ) == "U"
      VirtualHeight := 0
      vscroll := .f.
   ELSE
      IF VirtualHeight <= h
         MsgHMGError( "DEFINE WINDOW: Virtual Height Must Be Greater Than Height. Program Terminated" )
      ENDIF

      vscroll := .t.

   ENDIF

   IF VALTYPE( VirtualWidth ) == "U"
      VirtualWidth := 0
      hscroll := .f.
   ELSE
      IF VirtualWidth <= w
         MsgHMGError( "DEFINE WINDOW: Virtual Width Must Be Greater Than Width. Program Terminated" )
      ENDIF

      hscroll := .t.

   ENDIF

   IF VALTYPE( aRGB ) == 'U'
      aRGB := { - 1, - 1, - 1 }
   ENDIF

   _HMG_SYSDATA[ 223 ] := FormName
   _HMG_SYSDATA[ 264 ] := .T.

   UnRegisterWindow( HMG_MakeWindowsClassName( FormName ) )

   IF VALTYPE( icon ) == 'U' .AND. VALTYPE( _HMG_DefaultIconName ) != 'U'
      icon := _HMG_DefaultIconName
   ENDIF

   BrushHandle := RegisterWindow( icon, HMG_MakeWindowsClassName( FormName ), aRGB )

   Formhandle = InitWindow( Caption, x, y, w, h, nominimize, nomaximize, nosize, nosysmenu, nocaption, topmost, HMG_MakeWindowsClassName( FormName ), ParentHandle, vscroll, hscroll, helpbutton, panel )

   IF _HMG_SYSDATA[ 265 ] = TRUE .AND. Panel == .T.
      AADD( _HMG_SYSDATA[ 142 ], Formhandle )
   ENDIF

   IF VALTYPE( cursor ) != "U"
      SetWindowCursor( Formhandle, cursor )
   ENDIF

   IF Main
      _HMG_SYSDATA[ 181 ] := Formhandle
   ENDIF

   IF VALTYPE( NotifyIconName ) == "U"
      NotifyIconName := ""
   ELSE
      ShowNotifyIcon( FormHandle, .T., LoadTrayIcon( GETINSTANCE(), NotifyIconName ), NotifyIconTooltip )
   ENDIF

   htooltip := InitToolTip( FormHandle, _HMG_SYSDATA[ 55 ] )

   hWnd_ToolTip := TOOLTIP_INITMENU( FormHandle, _HMG_SYSDATA[ 55 ] )

   IF Main

      cType := 'A'

   ELSE

      IF Child == .T.

         cType := 'C'

      ELSEIF Panel == .T.

         cType := 'P'

      ELSE

         cType := 'S'

      ENDIF

   ENDIF

   k := ASCAN( _HMG_SYSDATA[ 65 ], .T. )

   IF k > 0

      _HMG_SYSDATA[ 164 ] := k

PUBLIC &mVar. := k

      IF Main
         _HMG_MainFormIndex := k
      ENDIF

      _HMG_SYSDATA[ 66 ] [ k ] := FormName
      _HMG_SYSDATA[ 67 ] [ k ] := FormHandle
      _HMG_SYSDATA[ 68 ] [ k ] := .f.
      _HMG_SYSDATA[ 69 ] [ k ] := cType
      _HMG_SYSDATA[ 70 ] [ k ] := IF( panel, Parenthandle, 0 )
      _HMG_SYSDATA[ 71 ] [ k ] := ReleaseProcedure
      _HMG_SYSDATA[ 72 ] [ k ] := InitProcedure
      _HMG_SYSDATA[ 73 ] [ k ] := htooltip
      _HMG_SYSDATA[ 74 ] [ k ] := 0
      _HMG_SYSDATA[ 75 ] [ k ] := MouseDragProcedure
      _HMG_SYSDATA[ 76 ] [ k ] := SizeProcedure
      _HMG_SYSDATA[ 77 ] [ k ] := ClickProcedure
      _HMG_SYSDATA[ 78 ] [ k ] := MouseMoveProcedure
      _HMG_SYSDATA[ 65 ] [ k ] := .f.
      _HMG_SYSDATA[ 79 ] [ k ] := aRGB
      _HMG_SYSDATA[ 80 ] [ k ] := PaintProcedure
      _HMG_SYSDATA[ 81 ] [ k ] := noshow
      _HMG_SYSDATA[ 82 ] [ k ] := NotifyIconName
      _HMG_SYSDATA[ 83 ] [ k ] := NotifyIconToolTip
      _HMG_SYSDATA[ 84 ] [ k ] := NotifyIconLeftClick
      _HMG_SYSDATA[ 85 ] [ k ] := GotFocus
      _HMG_SYSDATA[ 86 ] [ k ] := LostFocus
      _HMG_SYSDATA[ 87 ] [ k ] := 0
      _HMG_SYSDATA[ 88 ] [ k ] := 0
      _HMG_SYSDATA[ 89 ] [ k ] := {}
      _HMG_SYSDATA[ 90 ] [ k ] := {}
      _HMG_SYSDATA[ 91 ] [ k ] := VirtualHeight
      _HMG_SYSDATA[ 92 ] [ k ] := VirtualWidth
      _HMG_SYSDATA[ 93 ] [ k ] := .f.
      _HMG_SYSDATA[ 94 ] [ k ] := ScrollUp
      _HMG_SYSDATA[ 95 ] [ k ] := ScrollDown
      _HMG_SYSDATA[ 96 ] [ k ] := ScrollLeft
      _HMG_SYSDATA[ 97 ] [ k ] := ScrollRight
      _HMG_SYSDATA[ 98 ] [ k ] := HScrollBox
      _HMG_SYSDATA[ 99 ] [ k ] := VScrollBox
      _HMG_SYSDATA[ 100 ] [ k ] := BrushHandle
      _HMG_SYSDATA[ 101 ] [ k ] := 0
      _HMG_SYSDATA[ 102 ] [ k ] := {}
      _HMG_SYSDATA[ 103 ] [ k ] := MaximizeProcedure
      _HMG_SYSDATA[ 104 ] [ k ] := MinimizeProcedure
      _HMG_SYSDATA[ 105 ] [ k ] := .NOT. NoAutoRelease
      _HMG_SYSDATA[ 106 ] [ k ] := InteractiveCloseProcedure
      _HMG_SYSDATA[ 107 ] [ k ] := 0
      _HMG_SYSDATA[ 108 ] [ k ] := NIL
      _HMG_SYSDATA[ 504 ] [ k ] := { x, y, w, h }
      _HMG_SYSDATA[ 511 ] [ k ] := hWnd_ToolTip
      _HMG_SYSDATA[ 512 ] [ k ] := { NIL, NIL, NIL, NIL, NIL, NIL, NIL }

      _HMG_StopWindowEventProcedure[ k ] := .F.

   ELSE

      _HMG_SYSDATA[ 164 ] := HMG_LEN( _HMG_SYSDATA[ 66 ] ) + 1

      IF Main
         _HMG_MainFormIndex := HMG_LEN( _HMG_SYSDATA[ 66 ] ) + 1
      ENDIF

PUBLIC &mVar. := HMG_LEN( _HMG_SYSDATA[ 66 ] ) + 1

      AADD( _HMG_SYSDATA[ 66 ], FormName )
      AADD( _HMG_SYSDATA[ 67 ], FormHandle )
      AADD( _HMG_SYSDATA[ 68 ], .f. )
      AADD( _HMG_SYSDATA[ 69 ], cType )
      AADD( _HMG_SYSDATA[ 70 ], IF( panel, Parenthandle, 0 ) )
      AADD( _HMG_SYSDATA[ 71 ], ReleaseProcedure )
      AADD( _HMG_SYSDATA[ 72 ], InitProcedure )
      AADD( _HMG_SYSDATA[ 73 ], htooltip )
      AADD( _HMG_SYSDATA[ 74 ], 0 )
      AADD( _HMG_SYSDATA[ 75 ], MouseDragProcedure )
      AADD( _HMG_SYSDATA[ 76 ], SizeProcedure )
      AADD( _HMG_SYSDATA[ 77 ], ClickProcedure )
      AADD( _HMG_SYSDATA[ 78 ], MouseMoveProcedure )
      AADD( _HMG_SYSDATA[ 65 ], .f. )
      AADD( _HMG_SYSDATA[ 79 ], aRGB )
      AADD( _HMG_SYSDATA[ 80 ], PaintProcedure )
      AADD( _HMG_SYSDATA[ 81 ], noshow )
      AADD( _HMG_SYSDATA[ 82 ], NotifyIconName )
      AADD( _HMG_SYSDATA[ 83 ], NotifyIconToolTip )
      AADD( _HMG_SYSDATA[ 84 ], NotifyIconLeftClick )
      AADD( _HMG_SYSDATA[ 85 ], GotFocus )
      AADD( _HMG_SYSDATA[ 86 ], LostFocus )
      AADD( _HMG_SYSDATA[ 87 ], 0 )
      AADD( _HMG_SYSDATA[ 88 ], 0 )
      AADD( _HMG_SYSDATA[ 89 ], {} )
      AADD( _HMG_SYSDATA[ 90 ], {} )
      AADD( _HMG_SYSDATA[ 91 ], VirtualHeight )
      AADD( _HMG_SYSDATA[ 92 ], VirtualWidth )
      AADD( _HMG_SYSDATA[ 93 ], .f. )
      AADD( _HMG_SYSDATA[ 94 ], ScrollUp )
      AADD( _HMG_SYSDATA[ 95 ], ScrollDown )
      AADD( _HMG_SYSDATA[ 96 ], ScrollLeft )
      AADD( _HMG_SYSDATA[ 97 ], ScrollRight )
      AADD( _HMG_SYSDATA[ 98 ], HScrollBox )
      AADD( _HMG_SYSDATA[ 99 ], VScrollBox )
      AADD( _HMG_SYSDATA[ 100 ], BrushHandle )
      AADD( _HMG_SYSDATA[ 101 ], 0 )
      AADD( _HMG_SYSDATA[ 102 ], {} )
      AADD( _HMG_SYSDATA[ 103 ], MaximizeProcedure )
      AADD( _HMG_SYSDATA[ 104 ], MinimizeProcedure )
      AADD( _HMG_SYSDATA[ 105 ], .NOT. NoAutoRelease )
      AADD( _HMG_SYSDATA[ 106 ], InteractiveCloseProcedure )
      AADD( _HMG_SYSDATA[ 107 ], 0 )
      AADD( _HMG_SYSDATA[ 108 ], NIL )
      AADD( _HMG_SYSDATA[ 504 ], { x, y, w, h } )
      AADD( _HMG_SYSDATA[ 511 ], hWnd_ToolTip )
      AADD( _HMG_SYSDATA[ 512 ], { NIL, NIL, NIL, NIL, NIL, NIL, NIL } )

      AADD( _HMG_StopWindowEventProcedure, .F. )

   ENDIF

   InitDummy( FormHandle )

   IF VirtualHeight > 0
      SetScrollRange( Formhandle, SB_VERT, 0, VirtualHeight - h, .T. )
   ENDIF
   IF VirtualWidth > 0
      SetScrollRange( Formhandle, SB_HORZ, 0, VirtualWidth - w, .T. )
   ENDIF

   IF VALTYPE( _HMG_SYSDATA[ 56 ] ) = 'A'
      IF HMG_LEN( _HMG_SYSDATA[ 56 ] ) = 3
         SendMessage( GetFormToolTipHandle( FormName ), TTM_SETTIPBKCOLOR, RGB( _HMG_SYSDATA[ 56 ] [ 1 ], _HMG_SYSDATA[ 56 ] [ 2 ], _HMG_SYSDATA[ 56 ] [ 3 ] ), 0 )
      ENDIF
   ENDIF

   IF VALTYPE( _HMG_SYSDATA[ 57 ] ) = 'A'
      IF HMG_LEN( _HMG_SYSDATA[ 57 ] ) = 3
         SendMessage( GetFormToolTipHandle( FormName ), TTM_SETTIPTEXTCOLOR, RGB( _HMG_SYSDATA[ 57 ] [ 1 ], _HMG_SYSDATA[ 57 ] [ 2 ], _HMG_SYSDATA[ 57 ] [ 3 ] ), 0 )
      ENDIF
   ENDIF

   _HMG_SYSDATA[ 512 ] [ GetFormIndex( FormName ) ] [ 7 ] := _HMG_SYSDATA[ 55 ]
   SetToolTipCustomDrawForm( FormName )

RETURN ( FormHandle )
// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _DefineModalWindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _DefineModalWindow( FormName, Caption, x, y, w, h, Parent, nosize, nosysmenu, nocaption, StatusBar, StatusText, InitProcedure, ReleaseProcedure, MouseDragProcedure, SizeProcedure, ClickProcedure, MouseMoveProcedure, aRGB, PaintProcedure, icon, FontName, FontSize, GotFocus, LostFocus, virtualheight, VirtualWidth, scrollleft, scrollright, scrollup, scrolldown, hscrollbox, vscrollbox, helpbutton, cursor, noshow, NoAutoRelease, InteractiveCloseProcedure, visible, autorelease, sizable, sysmenu, titlebar, lLittleTitle )

   // -----------------------------------------------------------------------------*
LOCAL i, htooltip, mVar, vscroll, hscroll, BrushHandle, k := 0
LOCAL FormHandle
LOCAL hWnd_ToolTip

   //  Unused Parameters

StatusBar := Nil
StatusText := Nil

   DEFAULT x := GetDesktopRealLeft()
   DEFAULT y := GetDesktopRealTop()
   DEFAULT w := GetDeskTopRealWidth()
   DEFAULT h := GetDeskTopRealHeight()

   IF VALTYPE( titlebar ) == "L"
      NoCaption := .NOT. TitleBar
   ENDIF

   IF VALTYPE( sysmenu ) == "L"
      NoSysMenu := .NOT. sysmenu
   ENDIF

   IF VALTYPE( sizable ) == "L"
      NoSize := .NOT. Sizable
   ENDIF

   IF VALTYPE( visible ) == "L"
      NoShow := .NOT. Visible
   ENDIF

   IF VALTYPE( autorelease ) == "L"
      NoAutoRelease := .NOT. autorelease
   ENDIF

   IF VALTYPE( FormName ) == "U"
      FormName := _HMG_SYSDATA[ 214 ]
   ENDIF

   IF _HMG_MainWindowFirst == .T.
      i := ASCAN( _HMG_SYSDATA[ 69 ], 'A' )
      IF i <= 0
         MsgHMGError( "Main Window Not Defined. Program Terminated" )
      ENDIF
   ENDIF

   IF _IsWindowDefined( FormName )
      MsgHMGError( "Window: " + FormName + " already defined. Program Terminated" )
   ENDIF

   mVar := '_' + FormName

   IF VALTYPE( FontName ) == "U"
      _HMG_SYSDATA[ 224 ] := ""
   ELSE
      _HMG_SYSDATA[ 224 ] := FontName
   ENDIF

   IF VALTYPE( FontSize ) == "U"
      _HMG_SYSDATA[ 182 ] := 0
   ELSE
      _HMG_SYSDATA[ 182 ] := FontSize
   ENDIF

   IF VALTYPE( Caption ) == "U"
      Caption := ""
   ENDIF

   IF VALTYPE( InitProcedure ) == "U"
      InitProcedure := ""
   ENDIF

   IF VALTYPE( PaintProcedure ) == "U"
      PaintProcedure := ""
   ENDIF

   IF VALTYPE( ReleaseProcedure ) == "U"
      ReleaseProcedure := ""
   ENDIF

   IF VALTYPE( MouseDragProcedure ) == "U"
      MouseDragProcedure := ""
   ENDIF

   IF VALTYPE( SizeProcedure ) == "U"
      SizeProcedure := ""
   ENDIF

   IF VALTYPE( ClickProcedure ) == "U"
      ClickProcedure := ""
   ENDIF

   IF VALTYPE( MouseMoveProcedure ) == "U"
      MouseMoveProcedure := ""
   ENDIF

   IF VALTYPE( GotFocus ) == "U"
      GotFocus := ""
   ENDIF

   IF VALTYPE( LostFocus ) == "U"
      LostFocus := ""
   ENDIF

   IF VALTYPE( scrollup ) == "U"
      scrollup := ""
   ENDIF
   IF VALTYPE( scrolldown ) == "U"
      scrolldown := ""
   ENDIF
   IF VALTYPE( scrollleft ) == "U"
      scrollleft := ""
   ENDIF
   IF VALTYPE( scrollright ) == "U"
      scrollright := ""
   ENDIF

   IF VALTYPE( hscrollbox ) == "U"
      hscrollbox := ""
   ENDIF
   IF VALTYPE( vscrollbox ) == "U"
      vscrollbox := ""
   ENDIF

   IF VALTYPE( VirtualHeight ) == "U"
      VirtualHeight := 0
      vscroll := .f.
   ELSE
      IF VirtualHeight <= h
         MsgHMGError( "DEFINE WINDOW: Virtual Height Must Be Greater Than Height. Program Terminated" )
      ENDIF

      vscroll := .t.

   ENDIF

   IF VALTYPE( VirtualWidth ) == "U"
      VirtualWidth := 0
      hscroll := .f.
   ELSE
      IF VirtualWidth <= w
         MsgHMGError( "DEFINE WINDOW: Virtual Width Must Be Greater Than Width. Program Terminated" )

      ENDIF

      hscroll := .t.

   ENDIF

   IF VALTYPE( aRGB ) == 'U'
      aRGB := { - 1, - 1, - 1 }
   ENDIF

   IF _HMG_SYSDATA[ 109 ] <> 0
      Parent := _HMG_SYSDATA[ 109 ]
   ELSE
      Parent = _HMG_SYSDATA[ 181 ]
   ENDIF

   _HMG_SYSDATA[ 223 ] := FormName
   _HMG_SYSDATA[ 264 ] := .T.

   UnRegisterWindow( HMG_MakeWindowsClassName( FormName ) )

   IF VALTYPE( icon ) == 'U' .AND. VALTYPE( _HMG_DefaultIconName ) != 'U'
      icon := _HMG_DefaultIconName
   ENDIF

   BrushHandle := RegisterWindow( icon, HMG_MakeWindowsClassName( FormName ), aRGB )

   Formhandle = InitModalWindow( Caption, x, y, w, h, Parent, nosize, nosysmenu, nocaption, HMG_MakeWindowsClassName( FormName ), vscroll, hscroll, helpbutton, lLittleTitle )

   IF VALTYPE( cursor ) != "U"
      SetWindowCursor( Formhandle, cursor )
   ENDIF

   htooltip := InitToolTip( NIL, _HMG_SYSDATA[ 55 ] )

   hWnd_ToolTip := TOOLTIP_INITMENU( NIL, _HMG_SYSDATA[ 55 ] )

   k := ASCAN( _HMG_SYSDATA[ 65 ], .T. )

   IF k > 0

PUBLIC &mVar. := k

      _HMG_SYSDATA[ 66 ] [ k ] := FormName
      _HMG_SYSDATA[ 67 ] [ k ] := FormHandle
      _HMG_SYSDATA[ 68 ] [ k ] := .f.
      _HMG_SYSDATA[ 69 ] [ k ] := "M"
      _HMG_SYSDATA[ 70 ] [ k ] := Parent
      _HMG_SYSDATA[ 71 ] [ k ] := ReleaseProcedure
      _HMG_SYSDATA[ 72 ] [ k ] := InitProcedure
      _HMG_SYSDATA[ 73 ] [ k ] := htooltip
      _HMG_SYSDATA[ 74 ] [ k ] := 0
      _HMG_SYSDATA[ 75 ] [ k ] := MouseDragProcedure
      _HMG_SYSDATA[ 76 ] [ k ] := SizeProcedure
      _HMG_SYSDATA[ 77 ] [ k ] := ClickProcedure
      _HMG_SYSDATA[ 78 ] [ k ] := MouseMoveProcedure
      _HMG_SYSDATA[ 65 ] [ k ] := .f.
      _HMG_SYSDATA[ 79 ] [ k ] := aRGB
      _HMG_SYSDATA[ 80 ] [ k ] := PaintProcedure
      _HMG_SYSDATA[ 81 ] [ k ] := noshow
      _HMG_SYSDATA[ 82 ] [ k ] := ''
      _HMG_SYSDATA[ 83 ] [ k ] := ''
      _HMG_SYSDATA[ 84 ] [ k ] := ''
      _HMG_SYSDATA[ 85 ] [ k ] := GotFocus
      _HMG_SYSDATA[ 86 ] [ k ] := LostFocus
      _HMG_SYSDATA[ 87 ] [ k ] := 0
      _HMG_SYSDATA[ 88 ] [ k ] := 0
      _HMG_SYSDATA[ 89 ] [ k ] := {}
      _HMG_SYSDATA[ 90 ] [ k ] := {}
      _HMG_SYSDATA[ 91 ] [ k ] := VirtualHeight
      _HMG_SYSDATA[ 92 ] [ k ] := VirtualWidth
      _HMG_SYSDATA[ 93 ] [ k ] := .f.
      _HMG_SYSDATA[ 94 ] [ k ] := ScrollUp
      _HMG_SYSDATA[ 95 ] [ k ] := ScrollDown
      _HMG_SYSDATA[ 96 ] [ k ] := ScrollLeft
      _HMG_SYSDATA[ 97 ] [ k ] := ScrollRight
      _HMG_SYSDATA[ 98 ] [ k ] := HScrollBox
      _HMG_SYSDATA[ 99 ] [ k ] := VScrollBox
      _HMG_SYSDATA[ 100 ] [ k ] := BrushHandle
      _HMG_SYSDATA[ 101 ] [ k ] := 0
      _HMG_SYSDATA[ 102 ] [ k ] := {}
      _HMG_SYSDATA[ 103 ] [ k ] := Nil
      _HMG_SYSDATA[ 104 ] [ k ] := Nil
      _HMG_SYSDATA[ 105 ] [ k ] := .NOT. NoAutoRelease
      _HMG_SYSDATA[ 106 ] [ k ] := InteractiveCloseProcedure
      _HMG_SYSDATA[ 107 ] [ k ] := 0
      _HMG_SYSDATA[ 108 ] [ k ] := NIL
      _HMG_SYSDATA[ 504 ] [ k ] := { x, y, w, h }
      _HMG_SYSDATA[ 511 ] [ k ] := hWnd_ToolTip
      _HMG_SYSDATA[ 512 ] [ k ] := { NIL, NIL, NIL, NIL, NIL, NIL, NIL }

      _HMG_StopWindowEventProcedure[ k ] := .F.

   ELSE

PUBLIC &mVar. := HMG_LEN( _HMG_SYSDATA[ 66 ] ) + 1

      AADD( _HMG_SYSDATA[ 66 ], FormName )
      AADD( _HMG_SYSDATA[ 67 ], FormHandle )
      AADD( _HMG_SYSDATA[ 68 ], .f. )
      AADD( _HMG_SYSDATA[ 69 ], "M" )
      AADD( _HMG_SYSDATA[ 70 ], Parent )
      AADD( _HMG_SYSDATA[ 71 ], ReleaseProcedure )
      AADD( _HMG_SYSDATA[ 72 ], InitProcedure )
      AADD( _HMG_SYSDATA[ 73 ], htooltip )
      AADD( _HMG_SYSDATA[ 74 ], 0 )
      AADD( _HMG_SYSDATA[ 75 ], MouseDragProcedure )
      AADD( _HMG_SYSDATA[ 76 ], SizeProcedure )
      AADD( _HMG_SYSDATA[ 77 ], ClickProcedure )
      AADD( _HMG_SYSDATA[ 78 ], MouseMoveProcedure )
      AADD( _HMG_SYSDATA[ 65 ], .f. )
      AADD( _HMG_SYSDATA[ 79 ], aRGB )
      AADD( _HMG_SYSDATA[ 80 ], PaintProcedure )
      AADD( _HMG_SYSDATA[ 81 ], noshow )
      AADD( _HMG_SYSDATA[ 82 ], '' )
      AADD( _HMG_SYSDATA[ 83 ], '' )
      AADD( _HMG_SYSDATA[ 84 ], '' )
      AADD( _HMG_SYSDATA[ 85 ], GotFocus )
      AADD( _HMG_SYSDATA[ 86 ], LostFocus )
      AADD( _HMG_SYSDATA[ 87 ], 0 )
      AADD( _HMG_SYSDATA[ 88 ], 0 )
      AADD( _HMG_SYSDATA[ 89 ], {} )
      AADD( _HMG_SYSDATA[ 90 ], {} )
      AADD( _HMG_SYSDATA[ 91 ], VirtualHeight )
      AADD( _HMG_SYSDATA[ 92 ], VirtualWidth )
      AADD( _HMG_SYSDATA[ 93 ], .f. )
      AADD( _HMG_SYSDATA[ 94 ], ScrollUp )
      AADD( _HMG_SYSDATA[ 95 ], ScrollDown )
      AADD( _HMG_SYSDATA[ 96 ], ScrollLeft )
      AADD( _HMG_SYSDATA[ 97 ], ScrollRight )
      AADD( _HMG_SYSDATA[ 98 ], HScrollBox )
      AADD( _HMG_SYSDATA[ 99 ], VScrollBox )
      AADD( _HMG_SYSDATA[ 100 ], BrushHandle )
      AADD( _HMG_SYSDATA[ 101 ], 0 )
      AADD( _HMG_SYSDATA[ 102 ], {} )
      AADD( _HMG_SYSDATA[ 103 ], Nil )
      AADD( _HMG_SYSDATA[ 104 ], Nil )
      AADD( _HMG_SYSDATA[ 105 ], .NOT. NoAutoRelease )
      AADD( _HMG_SYSDATA[ 106 ], InteractiveCloseProcedure )
      AADD( _HMG_SYSDATA[ 107 ], 0 )
      AADD( _HMG_SYSDATA[ 108 ], NIL )
      AADD( _HMG_SYSDATA[ 504 ], { x, y, w, h } )
      AADD( _HMG_SYSDATA[ 511 ], hWnd_ToolTip )
      AADD( _HMG_SYSDATA[ 512 ], { NIL, NIL, NIL, NIL, NIL, NIL, NIL } )

      AADD( _HMG_StopWindowEventProcedure, .F. )

   ENDIF

   InitDummy( FormHandle )

   IF VirtualHeight > 0
      SetScrollRange( Formhandle, SB_VERT, 0, VirtualHeight - h, .T. )
   ENDIF
   IF VirtualWidth > 0
      SetScrollRange( Formhandle, SB_HORZ, 0, VirtualWidth - w, .T. )
   ENDIF

   IF VALTYPE( _HMG_SYSDATA[ 56 ] ) = 'A'
      IF HMG_LEN( _HMG_SYSDATA[ 56 ] ) = 3
         SendMessage( GetFormToolTipHandle( FormName ), TTM_SETTIPBKCOLOR, RGB( _HMG_SYSDATA[ 56 ] [ 1 ], _HMG_SYSDATA[ 56 ] [ 2 ], _HMG_SYSDATA[ 56 ] [ 3 ] ), 0 )
      ENDIF
   ENDIF

   IF VALTYPE( _HMG_SYSDATA[ 57 ] ) = 'A'
      IF HMG_LEN( _HMG_SYSDATA[ 57 ] ) = 3
         SendMessage( GetFormToolTipHandle( FormName ), TTM_SETTIPTEXTCOLOR, RGB( _HMG_SYSDATA[ 57 ] [ 1 ], _HMG_SYSDATA[ 57 ] [ 2 ], _HMG_SYSDATA[ 57 ] [ 3 ] ), 0 )
      ENDIF
   ENDIF

   _HMG_SYSDATA[ 512 ] [ GetFormIndex( FormName ) ] [ 7 ] := _HMG_SYSDATA[ 55 ]
   SetToolTipCustomDrawForm( FormName )

RETURN ( FormHandle )

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _DefineSplitChildWindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _DefineSplitChildWindow( FormName, w, h, break, grippertext, nocaption, title, fontname, fontsize, gotfocus, lostfocus, virtualheight, VirtualWidth, Focused, scrollleft, scrollright, scrollup, scrolldown, hscrollbox, vscrollbox, cursor, titlebar, PaintProcedure )

   // -----------------------------------------------------------------------------*
LOCAL i, htooltip, mVar, ParentForm, hscroll, BrushHandle, k := 0
LOCAL FormHandle, vscroll
LOCAL hWnd_ToolTip

   DEFAULT w := GetDeskTopRealWidth()
   DEFAULT h := GetDeskTopRealHeight()

   IF VALTYPE( titlebar ) == "L"
      NoCaption := .NOT. TitleBar
   ENDIF

   IF VALTYPE( FormName ) == "U"
      FormName := _HMG_SYSDATA[ 214 ]
   ENDIF

   IF _HMG_MainWindowFirst == .T.
      i := ASCAN( _HMG_SYSDATA[ 69 ], 'A' )
      IF i <= 0
         MsgHMGError( "Main Window Not Defined. Program Terminated" )
      ENDIF
   ENDIF

   IF _IsWindowDefined( FormName )
      MsgHMGError( "Window: " + FormName + " already defined. Program Terminated" )
   ENDIF

   IF _HMG_SYSDATA[ 262 ] == .F.
      MsgHMGError( "SplitChild Windows Can be Defined Only Inside SplitBox. Program terminated" )
   ENDIF

   IF VALTYPE( FontName ) == "U"
      _HMG_SYSDATA[ 224 ] := ""
   ELSE
      _HMG_SYSDATA[ 224 ] := FontName
   ENDIF

   IF VALTYPE( FontSize ) == "U"
      _HMG_SYSDATA[ 182 ] := 0
   ELSE
      _HMG_SYSDATA[ 182 ] := FontSize
   ENDIF

   IF VALTYPE( VirtualHeight ) == "U"
      VirtualHeight := 0
      vscroll := .f.
   ELSE
      IF VirtualHeight <= h
         MsgHMGError( "DEFINE WINDOW: Virtual Height Must Be Greater Than Height. Program Terminated" )

      ENDIF

      vscroll := .t.

   ENDIF

   IF VALTYPE( VirtualWidth ) == "U"
      VirtualWidth := 0
      hscroll := .f.
   ELSE
      IF VirtualWidth <= w
         MsgHMGError( "DEFINE WINDOW: Virtual Width Must Be Greater Than Width. Program Terminated" )

      ENDIF

      hscroll := .t.

   ENDIF

   _HMG_SYSDATA[ 260 ] := .t.

   ParentForm := _HMG_SYSDATA[ 223 ]

   mVar := '_' + FormName

   _HMG_SYSDATA[ 215 ] := _HMG_SYSDATA[ 223 ]

   _HMG_SYSDATA[ 223 ] := FormName
   _HMG_SYSDATA[ 264 ] := .T.

   UnRegisterWindow( HMG_MakeWindowsClassName( FormName ) )
   BrushHandle := RegisterSplitChildWindow( "", HMG_MakeWindowsClassName( FormName ), { - 1, - 1, - 1 } )

   i := GetFormIndex( ParentForm )

   IF i > 0

      Formhandle := InitSplitChildWindow( w, h, HMG_MakeWindowsClassName( FormName ), nocaption, title, 0, vscroll, hscroll )

      IF VALTYPE( cursor ) != "U"
         SetWindowCursor( Formhandle, cursor )
      ENDIF

      IF _HMG_SYSDATA[ 216 ] == 'TOOLBAR' .AND. _HMG_SYSDATA[ 258 ] == .F.
         BREAK := .T.
      ENDIF

      AddSplitBoxItem( FormHandle, _HMG_SYSDATA[ 87 ] [ i ], w, break, grippertext,,, _HMG_SYSDATA[ 258 ] )

      _HMG_SYSDATA[ 216 ] := 'SPLITCHILD'

   ENDIF

   IF VALTYPE( scrollup ) == "U"
      scrollup := ""
   ENDIF
   IF VALTYPE( scrolldown ) == "U"
      scrolldown := ""
   ENDIF
   IF VALTYPE( scrollleft ) == "U"
      scrollleft := ""
   ENDIF
   IF VALTYPE( scrollright ) == "U"
      scrollright := ""
   ENDIF

   IF VALTYPE( hscrollbox ) == "U"
      hscrollbox := ""
   ENDIF
   IF VALTYPE( vscrollbox ) == "U"
      vscrollbox := ""
   ENDIF

   htooltip := InitToolTip( FormHandle, _HMG_SYSDATA[ 55 ] )

   hWnd_ToolTip := TOOLTIP_INITMENU( FormHandle, _HMG_SYSDATA[ 55 ] )

   k := ASCAN( _HMG_SYSDATA[ 65 ], .T. )

   IF k > 0

PUBLIC &mVar. := k
      _HMG_SYSDATA[ 171 ] := k

      _HMG_SYSDATA[ 66 ] [ k ] := FormName
      _HMG_SYSDATA[ 67 ] [ k ] := FormHandle
      _HMG_SYSDATA[ 68 ] [ k ] := .f.
      _HMG_SYSDATA[ 69 ] [ k ] := 'X'
      _HMG_SYSDATA[ 70 ] [ k ] := GetFormHandle( ParentForm )
      _HMG_SYSDATA[ 71 ] [ k ] := ""
      _HMG_SYSDATA[ 72 ] [ k ] := ""
      _HMG_SYSDATA[ 73 ] [ k ] := hToolTip
      _HMG_SYSDATA[ 74 ] [ k ] := 0
      _HMG_SYSDATA[ 75 ] [ k ] := ""
      _HMG_SYSDATA[ 76 ] [ k ] := ""
      _HMG_SYSDATA[ 77 ] [ k ] := ""
      _HMG_SYSDATA[ 78 ] [ k ] := ""
      _HMG_SYSDATA[ 65 ] [ k ] := .f.
      _HMG_SYSDATA[ 79 ] [ k ] := Nil
      _HMG_SYSDATA[ 80 ] [ k ] := PaintProcedure
      _HMG_SYSDATA[ 81 ] [ k ] := .f.
      _HMG_SYSDATA[ 82 ] [ k ] := ""
      _HMG_SYSDATA[ 83 ] [ k ] := ""
      _HMG_SYSDATA[ 84 ] [ k ] := ""
      _HMG_SYSDATA[ 85 ] [ k ] := gotfocus
      _HMG_SYSDATA[ 86 ] [ k ] := lostfocus
      _HMG_SYSDATA[ 87 ] [ k ] := 0
      _HMG_SYSDATA[ 88 ] [ k ] := 0
      _HMG_SYSDATA[ 89 ] [ k ] := {}
      _HMG_SYSDATA[ 90 ] [ k ] := {}
      _HMG_SYSDATA[ 91 ] [ k ] := VirtualHeight
      _HMG_SYSDATA[ 92 ] [ k ] := VirtualWidth
      _HMG_SYSDATA[ 93 ] [ k ] := Focused
      _HMG_SYSDATA[ 94 ] [ k ] := ScrollUp
      _HMG_SYSDATA[ 95 ] [ k ] := ScrollDown
      _HMG_SYSDATA[ 96 ] [ k ] := ScrollLeft
      _HMG_SYSDATA[ 97 ] [ k ] := ScrollRight
      _HMG_SYSDATA[ 98 ] [ k ] := HScrollBox
      _HMG_SYSDATA[ 99 ] [ k ] := VScrollBox
      _HMG_SYSDATA[ 100 ] [ k ] := BrushHandle
      _HMG_SYSDATA[ 101 ] [ k ] := 0
      _HMG_SYSDATA[ 102 ] [ k ] := {}
      _HMG_SYSDATA[ 103 ] [ k ] := Nil
      _HMG_SYSDATA[ 104 ] [ k ] := Nil
      _HMG_SYSDATA[ 105 ] [ k ] := .T.
      _HMG_SYSDATA[ 106 ] [ k ] := ""
      _HMG_SYSDATA[ 107 ] [ k ] := 0
      _HMG_SYSDATA[ 108 ] [ k ] := NIL
      _HMG_SYSDATA[ 504 ] [ k ] := { NIL, NIL, NIL, NIL }
      _HMG_SYSDATA[ 511 ] [ k ] := hWnd_ToolTip
      _HMG_SYSDATA[ 512 ] [ k ] := { NIL, NIL, NIL, NIL, NIL, NIL, NIL }

      _HMG_StopWindowEventProcedure[ k ] := .F.

   ELSE

PUBLIC &mVar. := HMG_LEN( _HMG_SYSDATA[ 66 ] ) + 1
      _HMG_SYSDATA[ 171 ] := HMG_LEN( _HMG_SYSDATA[ 66 ] ) + 1

      AADD( _HMG_SYSDATA[ 66 ], FormName )
      AADD( _HMG_SYSDATA[ 67 ], FormHandle )
      AADD( _HMG_SYSDATA[ 68 ], .f. )
      AADD( _HMG_SYSDATA[ 69 ], 'X' )
      AADD( _HMG_SYSDATA[ 70 ], GetFormHandle( ParentForm ) )
      AADD( _HMG_SYSDATA[ 71 ], "" )
      AADD( _HMG_SYSDATA[ 72 ], "" )
      AADD( _HMG_SYSDATA[ 73 ], hToolTip )
      AADD( _HMG_SYSDATA[ 74 ], 0 )
      AADD( _HMG_SYSDATA[ 75 ], "" )
      AADD( _HMG_SYSDATA[ 76 ], "" )
      AADD( _HMG_SYSDATA[ 77 ], "" )
      AADD( _HMG_SYSDATA[ 78 ], "" )
      AADD( _HMG_SYSDATA[ 65 ], .f. )
      AADD( _HMG_SYSDATA[ 79 ], Nil )
      AADD( _HMG_SYSDATA[ 80 ], PaintProcedure )
      AADD( _HMG_SYSDATA[ 81 ], .f. )
      AADD( _HMG_SYSDATA[ 82 ], "" )
      AADD( _HMG_SYSDATA[ 83 ], "" )
      AADD( _HMG_SYSDATA[ 84 ], "" )
      AADD( _HMG_SYSDATA[ 85 ], gotfocus )
      AADD( _HMG_SYSDATA[ 86 ], lostfocus )
      AADD( _HMG_SYSDATA[ 87 ], 0 )
      AADD( _HMG_SYSDATA[ 88 ], 0 )
      AADD( _HMG_SYSDATA[ 89 ], {} )
      AADD( _HMG_SYSDATA[ 90 ], {} )
      AADD( _HMG_SYSDATA[ 91 ], VirtualHeight )
      AADD( _HMG_SYSDATA[ 92 ], VirtualWidth )
      AADD( _HMG_SYSDATA[ 93 ], Focused )
      AADD( _HMG_SYSDATA[ 94 ], ScrollUp )
      AADD( _HMG_SYSDATA[ 95 ], ScrollDown )
      AADD( _HMG_SYSDATA[ 96 ], ScrollLeft )
      AADD( _HMG_SYSDATA[ 97 ], ScrollRight )
      AADD( _HMG_SYSDATA[ 98 ], HScrollBox )
      AADD( _HMG_SYSDATA[ 99 ], VScrollBox )
      AADD( _HMG_SYSDATA[ 100 ], BrushHandle )
      AADD( _HMG_SYSDATA[ 101 ], 0 )
      AADD( _HMG_SYSDATA[ 102 ], {} )
      AADD( _HMG_SYSDATA[ 103 ], Nil )
      AADD( _HMG_SYSDATA[ 104 ], Nil )
      AADD( _HMG_SYSDATA[ 105 ], .T. )
      AADD( _HMG_SYSDATA[ 106 ], "" )
      AADD( _HMG_SYSDATA[ 107 ], 0 )
      AADD( _HMG_SYSDATA[ 108 ], NIL )
      AADD( _HMG_SYSDATA[ 504 ], { NIL, NIL, NIL, NIL } )
      AADD( _HMG_SYSDATA[ 511 ], hWnd_ToolTip )
      AADD( _HMG_SYSDATA[ 512 ], { NIL, NIL, NIL, NIL, NIL, NIL, NIL } )

      AADD( _HMG_StopWindowEventProcedure, .F. )

   ENDIF

   InitDummy( FormHandle )

   AADD( _HMG_SYSDATA[ 90 ] [ i ], _HMG_SYSDATA[ 171 ] )

   IF VirtualHeight > 0
      SetScrollRange( Formhandle, SB_VERT, 0, VirtualHeight - h, .T. )
   ENDIF
   IF VirtualWidth > 0
      SetScrollRange( Formhandle, SB_HORZ, 0, VirtualWidth - w, .T. )
   ENDIF

   IF VALTYPE( _HMG_SYSDATA[ 56 ] ) = 'A'
      IF HMG_LEN( _HMG_SYSDATA[ 56 ] ) = 3
         SendMessage( GetFormToolTipHandle( FormName ), TTM_SETTIPBKCOLOR, RGB( _HMG_SYSDATA[ 56 ] [ 1 ], _HMG_SYSDATA[ 56 ] [ 2 ], _HMG_SYSDATA[ 56 ] [ 3 ] ), 0 )
      ENDIF
   ENDIF

   IF VALTYPE( _HMG_SYSDATA[ 57 ] ) = 'A'
      IF HMG_LEN( _HMG_SYSDATA[ 57 ] ) = 3
         SendMessage( GetFormToolTipHandle( FormName ), TTM_SETTIPTEXTCOLOR, RGB( _HMG_SYSDATA[ 57 ] [ 1 ], _HMG_SYSDATA[ 57 ] [ 2 ], _HMG_SYSDATA[ 57 ] [ 3 ] ), 0 )
      ENDIF
   ENDIF

   _HMG_SYSDATA[ 512 ] [ GetFormIndex( FormName ) ] [ 7 ] := _HMG_SYSDATA[ 55 ]
   SetToolTipCustomDrawForm( FormName )

RETURN ( FormHandle )

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _SetWindowSizePos()
*+
*+    Called from ( h_controlmisc.prg )   4 - function setproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetWindowSizePos( FormName, row, col, width, height )

   // -----------------------------------------------------------------------------*
LOCAL hWnd, hParent, nIndex, actpos := { 0, 0, 0, 0 }

   IF VALTYPE( FormName ) == "N"
      hWnd := FormName
   ELSE
      hWnd := GetFormHandle( FormName )
   ENDIF

   GetWindowRect( hWnd, actpos )
   col := IF( col == NIL, actpos[ 1 ], col )
   row := IF( row == NIL, actpos[ 2 ], row )
   width := IF( width == NIL, actpos[ 3 ] - actpos[ 1 ], width )
   height := IF( height == NIL, actpos[ 4 ] - actpos[ 2 ], height )

   nIndex := GetFormIndexByHandle( hWnd )
   IF nIndex > 0 .AND. GetFormTypeByIndex( nIndex ) == "P"            // Panel Window,   ADD (May 2015, Fixed January 2016)
      hParent := _HMG_SYSDATA[ 70 ] [ nIndex ]
      ScreenToClient( hParent, @col, @row )
   ENDIF

   MoveWindow( hWnd, col, row, width, height, .T. )
RETURN Nil

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _GetWindowSizePos()
*+
*+    Called from ( h_controlmisc.prg )   4 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetWindowSizePos( FormName )                                //   ADD   May 2015

   // -----------------------------------------------------------------------------*
LOCAL hWnd, hParent, nIndex, actpos := { 0, 0, 0, 0 }
LOCAL row, col, width, height

   IF VALTYPE( FormName ) == "N"
      hWnd := FormName
   ELSE
      hWnd := GetFormHandle( FormName )
   ENDIF

   GetWindowRect( hWnd, actpos )
   col := actpos[ 1 ]
   row := actpos[ 2 ]
   width := actpos[ 3 ] - actpos[ 1 ]
   height := actpos[ 4 ] - actpos[ 2 ]

   nIndex := GetFormIndexByHandle( hWnd )
   IF GetFormTypeByIndex( nIndex ) == "P"                             // Panel Window
      hParent := _HMG_SYSDATA[ 70 ] [ nIndex ]
      ScreenToClient( hParent, @col, @row )
   ENDIF

RETURN { row, col, width, height }

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function GetFormIndex()
*+
*+    Called from ( h_browse.prg )   3 - function _definebrowse()
*+                ( h_grid.prg )   1 - function _definegrid()
*+                ( h_eventcb.prg )   1 - function getsplitboxhandle()
*+                ( h_checkbox.prg )   2 - function _definecheckbox()
*+                ( h_combo.prg )   3 - function _definecombo()
*+                ( h_controlmisc.prg )   1 - function _releasecontrol()
*+                                   1 - function getproperty()
*+                                   1 - function domethod()
*+                                   1 - procedure settooltipcustomdrawform()
*+                                   1 - procedure settooltipcustomdrawcontrol()
*+                ( h_editbox.prg )   2 - function _defineeditbox()
*+                ( h_hotkey.prg )   1 - procedure _definehotkey()
*+                                   1 - procedure _releasehotkey()
*+                ( h_listbox.prg )   1 - function _definelistbox()
*+                ( h_menu.prg )   2 - function _endmenu()
*+                ( h_richeditbox.prg )   2 - function _definericheditbox()
*+                ( h_textbox.prg )   1 - function _definetextbox()
*+                                   1 - function _definemaskedtextbox()
*+                                   1 - function _definecharmasktextbox()
*+                ( h_toolbar.prg )   1 - function _endtoolbar()
*+                ( h_tree.prg )   1 - function _definetree()
*+                ( h_windows.prg )   2 - function _releasewindow()
*+                                   1 - function _showwindow()
*+                                   1 - function _hidewindow()
*+                                   1 - function _definewindow()
*+                                   1 - function _definemodalwindow()
*+                                   2 - function _definesplitchildwindow()
*+                                   1 - function _setnotifyiconname()
*+                                   1 - function _setnotifyicontooltip()
*+                                   1 - function _getnotifyiconname()
*+                                   1 - function _getnotifyicontooltip()
*+                                   1 - function _definesplitbox()
*+                                   5 - function _activatewindow()
*+                                   1 - function stopwindoweventprocedure()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetFormIndex( FormName )

   // -----------------------------------------------------------------------------*
LOCAL mVar

   mVar := '_' + FormName

RETURN ( &mVar )
// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _SetNotifyIconName()
*+
*+    Called from ( h_controlmisc.prg )   1 - function setproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetNotifyIconName( FormName, IconName )

   // -----------------------------------------------------------------------------*
LOCAL i

   i := GetFormIndex( FormName )

   ChangeNotifyIcon( _HMG_SYSDATA[ 67 ] [ i ], LoadTrayIcon( GETINSTANCE(), IconName ), _HMG_SYSDATA[ 83 ] [ i ] )

   _HMG_SYSDATA[ 82 ] [ i ] := IconName

RETURN Nil
// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _SetNotifyIconTooltip()
*+
*+    Called from ( h_controlmisc.prg )   1 - function setproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetNotifyIconTooltip( FormName, TooltipText )

   // -----------------------------------------------------------------------------*
LOCAL i

   i := GetFormIndex( FormName )

   ChangeNotifyIcon( _HMG_SYSDATA[ 67 ] [ i ], LoadTrayIcon( GETINSTANCE(), _HMG_SYSDATA[ 82 ] [ i ] ), TooltipText )

   _HMG_SYSDATA[ 83 ] [ i ] := TooltipText

RETURN Nil
// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _GetNotifyIconName()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetNotifyIconName( FormName )

   // -----------------------------------------------------------------------------*
LOCAL i

   i := GetFormIndex( FormName )

RETURN ( _HMG_SYSDATA[ 82 ] [ i ] )
// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _GetNotifyIconTooltip()
*+
*+    Called from ( h_controlmisc.prg )   1 - function getproperty()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetNotifyIconTooltip( FormName )

   // -----------------------------------------------------------------------------*
LOCAL i

   i := GetFormIndex( FormName )

RETURN ( _HMG_SYSDATA[ 83 ] [ i ] )

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _DefineSplitBox()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _DefineSplitBox( ParentForm, bottom, inverted )

   // -----------------------------------------------------------------------------*
LOCAL i, cParentForm, Controlhandle

   IF _HMG_SYSDATA[ 264 ] = .T.
      ParentForm := _HMG_SYSDATA[ 223 ]
   ENDIF

   IF _HMG_SYSDATA[ 183 ] > 0
      MsgHMGError( "SPLITBOX can't be defined inside Tab control. Program terminated" )
   ENDIF

   IF .NOT. _IsWindowDefined( ParentForm )
      MsgHMGError( "Window: " + ParentForm + " is not defined. Program terminated" )
   ENDIF

   IF _HMG_SYSDATA[ 260 ] == .T.
      MsgHMGError( "SplitBox Can't Be Defined inside SplitChild Windows. Program terminated" )
   ENDIF

   IF _HMG_SYSDATA[ 262 ] == .T.
      MsgHMGError( "SplitBox Controls Can't Be Nested. Program terminated" )
   ENDIF

   _HMG_SYSDATA[ 258 ] := Inverted

   _HMG_SYSDATA[ 262 ] := .T.

   _HMG_SYSDATA[ 222 ] := ParentForm

   cParentForm := ParentForm

   ParentForm = GetFormHandle( ParentForm )

   ControlHandle := InitSplitBox( ParentForm, bottom, inverted )

   i := GetFormIndex( cParentForm )

   IF i > 0
      _HMG_SYSDATA[ 87 ] [ i ] := ControlHandle
   ENDIF

RETURN Nil
// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _EndSplitBox()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _EndSplitBox()

   // -----------------------------------------------------------------------------*

   _HMG_SYSDATA[ 216 ] := 'TOOLBAR'

   _HMG_SYSDATA[ 262 ] := .F.

RETURN Nil

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _EndSplitChildWindow()
*+
*+    Called from ( h_windows.prg )   1 - function _endwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _EndSplitChildWindow()

   // -----------------------------------------------------------------------------*

   _HMG_SYSDATA[ 223 ] := _HMG_SYSDATA[ 215 ]
   _HMG_SYSDATA[ 260 ] := .f.
   _HMG_SYSDATA[ 68 ] [ _HMG_SYSDATA[ 171 ] ] := .t.

RETURN Nil

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _EndPanelWindow()
*+
*+    Called from ( h_windows.prg )   1 - function _endwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _EndPanelWindow()

   // -----------------------------------------------------------------------------*

   _HMG_SYSDATA[ 223 ] := _HMG_SYSDATA[ 215 ]
   _HMG_SYSDATA[ 240 ] := .f.

RETURN Nil

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _EndWindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _EndWindow()

   // -----------------------------------------------------------------------------*

   _HMG_SYSDATA[ 344 ] := _HMG_SYSDATA[ 223 ]

   IF _HMG_SYSDATA[ 260 ] == .t.
      _EndSplitChildWindow()

   ELSEIF _HMG_SYSDATA[ 240 ] == .T.
      _EndPanelWindow()

   ELSE
      _HMG_SYSDATA[ 264 ] := .F.
      _HMG_SYSDATA[ 223 ] := ""
   ENDIF

RETURN Nil

// Pablo César (January 2015)
// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function InputBox()
*+
*+    Called from ( h_browse.prg )   1 - function _browseinplaceedit()
*+
*+--------------------------------------------------------------------
*+
FUNCTION InputBox( cInputPrompt, cWindowTitle, cDefaultValue, nTimeout, cTimeoutValue, lMultiLine, nWidth )

   // -----------------------------------------------------------------------------*
LOCAL RetVal, mo

   DEFAULT cInputPrompt := ""
   DEFAULT cWindowTitle := ""
   DEFAULT cDefaultValue := ""

   IF !( nWidth = Nil )
      IF nWidth < 350
         nWidth := 350
      ENDIF
   ENDIF

   RetVal := ''

   IF VALTYPE( lMultiLine ) != 'U'
      IF lMultiLine == .T.
         mo := 150
      ELSE
         mo := 0
      ENDIF
   ELSE
      mo := 0
   ENDIF

   DEFINE WINDOW _InputBox ;
      AT 0, 0 ;
      WIDTH IF( nWidth = Nil, 350, nWidth ) ;
      HEIGHT 115 + mo + GetTitleHeight() ;
      TITLE cWindowTitle ;
      MODAL ;
      NOSIZE ;
      FONT 'Arial' ;
      SIZE 10

   ON KEY CONTROL + W ACTION( _HMG_SYSDATA[ 257 ] := .F., RetVal := _InputBox._TextBox.Value, _InputBox.Release )
   ON KEY ESCAPE ACTION( _HMG_SYSDATA[ 257 ] := .T., _InputBox.Release )

   @ 07, 10 LABEL _Label ;
           VALUE cInputPrompt ;
           WIDTH 280

   IF VALTYPE( lMultiLine ) != 'U' .AND. lMultiLine == .T.
      @ 30, 10 EDITBOX _TextBox ;
              VALUE cDefaultValue ;
              HEIGHT 26 + mo ;
              WIDTH IF( nWidth = Nil, 320, nWidth - 30 )
   ELSE
      @ 30, 10 TEXTBOX _TextBox ;
              VALUE cDefaultValue ;
              HEIGHT 26 + mo ;
              WIDTH IF( nWidth = Nil, 320, nWidth - 30 ) ;
              ON ENTER( _HMG_SYSDATA[ 257 ] := .F., RetVal := _InputBox._TextBox.Value, _InputBox.Release )
   ENDIF

   @ 67 + mo, IF( nWidth = Nil, 120, ( nWidth / 2 ) - 10 - 100 ) BUTTON _Ok ;
           CAPTION _hMG_SYSDATA[ 128 ] [ 8 ] ;
           ACTION( _HMG_SYSDATA[ 257 ] := .F., RetVal := _InputBox._TextBox.Value, _InputBox.Release )

   @ 67 + mo, IF( nWidth = Nil, 230, ( nWidth / 2 ) + 10 ) BUTTON _Cancel ;
           CAPTION _hMG_SYSDATA[ 128 ] [ 7 ] ;
           ACTION( _HMG_SYSDATA[ 257 ] := .T., _InputBox.Release )

   IF VALTYPE( nTimeout ) != 'U'
      IF VALTYPE( cTimeoutValue ) != 'U'
         DEFINE TIMER _InputBox ;
                 INTERVAL nTimeout ;
                 ACTION( RetVal := cTimeoutValue, _InputBox.Release )
      ELSE
         DEFINE TIMER _InputBox ;
                 INTERVAL nTimeout ;
                 ACTION _InputBox.Release
      ENDIF
   ENDIF
   END WINDOW
   _InputBox._TextBox.SetFocus
   CENTER WINDOW _InputBox
   ACTIVATE WINDOW _InputBox
RETURN ( RetVal )

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _SetWindowRgn()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetWindowRgn( name, col, row, w, h, lx )

   // -----------------------------------------------------------------------------*
LOCAL lhand := 0

   lhand := GetFormHandle( name )

   c_SetWindowRgn( lhand, col, row, w, h, lx )

RETURN Nil
// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _SetPolyWindowRgn()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetPolyWindowRgn( name, apoints, lx )

   // -----------------------------------------------------------------------------*
LOCAL lhand := 0, apx := {}, apy := {}

   lhand := GetFormHandle( name )

   AEVAL( apoints, { | x | AADD( apx, x[ 1 ] ), AADD( apy, x[ 2 ] ) } )

   c_SetPolyWindowRgn( lhand, apx, apy, lx )

RETURN Nil
// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Procedure _SetNextFocus()
*+
*+    Called from ( h_windows.prg )   7 - function events()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE _SetNextFocus()

   // -----------------------------------------------------------------------------*
LOCAL i, NextControlHandle := 0

   NextControlHandle := GetNextDlgTabITem( GetActiveWindow(), GetFocus(), .F. )
   i := ASCAN( _HMG_SYSDATA[ 3 ], NextControlHandle )

   IF i > 0
      IF _HMG_SYSDATA[ 1 ] [ i ] == 'BUTTON'
         setfocus( NextControlHandle )
         SendMessage( NextControlHandle, BM_SETSTYLE, LOWORD( BS_DEFPUSHBUTTON ), 1 )
      ELSE
         InsertTab()
      ENDIF
   ELSE
      InsertTab()
   ENDIF

RETURN

// *********************************************************

*+--------------------------------------------------------------------
*+
*+    Function HMG_ActivateMainWindowFirst()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_ActivateMainWindowFirst( lOn )

LOCAL lOldMainFirst := _HMG_MainWindowFirst
   IF VALTYPE( lOn ) == "L"
      _HMG_MainWindowFirst := lOn
   ENDIF
RETURN lOldMainFirst

// -----------------------------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _ActivateWindow()
*+
*+    Called from ( h_controlmisc.prg )   2 - function domethod()
*+                ( h_windows.prg )   1 - function _activateallwindows()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _ActivateWindow( aForm, lActivateMsgLoop, lNotExitAppAtCloseForm )

   // -----------------------------------------------------------------------------------------------------*
   __THREAD STATIC IsInstallHook := .F., IsLoopMessageActive := .F.
LOCAL I, z, MainFound := .F.
LOCAL nForm             := HMG_LEN( aForm )
LOCAL FormName
LOCAL VisibleModalCount := 0
LOCAL VisibleModalName  := ''
LOCAL TmpId
LOCAL FormCount         := HMG_LEN( _HMG_SYSDATA[ 66 ] )
LOCAL nLastWindowIndex  := 0
LOCAL x

   DEFAULT lActivateMsgLoop TO .T.
   DEFAULT lNotExitAppAtCloseForm TO .F.

   IF _HMG_SYSDATA[ 232 ] == 'WINDOW_RELEASE'
      MsgHMGError( "ACTIVATE WINDOW: activate windows within an 'on release' window procedure is not allowed. Program terminated" )
   ENDIF

   IF _HMG_SYSDATA[ 264 ] = .T.
      MsgHMGError( "ACTIVATE WINDOW: DEFINE WINDOW Structure is not closed. Program terminated" )
   ENDIF

   IF _HMG_SYSDATA[ 232 ] == 'WINDOW_GOTFOCUS'
      MsgHMGError( "ACTIVATE WINDOW / Activate(): Not allowed in window's GOTFOCUS event procedure. Program terminated" )
   ENDIF

   IF _HMG_SYSDATA[ 232 ] == 'WINDOW_LOSTFOCUS'
      MsgHMGError( "ACTIVATE WINDOW / Activate(): Not allowed in window's LOSTFOCUS event procedure. Program terminated" )
   ENDIF

   //  Look For Main Window

   FOR z := 1 TO nForm
      FormName := aForm[ z ]
      i := GetFormIndex( FormName )
      IF _HMG_SYSDATA[ 69 ] [ i ] == 'A'
         MainFound := .T.
         EXIT
      ENDIF
   NEXT z

   // Main Check

   // Dr. Claudio Soto (August 2013)
   IF _HMG_MainWindowFirst == .T.
      IF _HMG_SYSDATA[ 263 ] == .F.                                   // _HMG_IsMainFormActive
         IF MainFound == .F.
            MsgHMGError( "ACTIVATE WINDOW: Main Window Must be Activated In First ACTIVATE WINDOW Command. Program terminated" )
         ENDIF
      ELSE
         IF MainFound == .T.
            MsgHMGError( "ACTIVATE WINDOW: Main Window Already Active. Program terminated" )
         ENDIF
      ENDIF
   ENDIF

   // Dr. Claudio Soto (July 2013)
   IF IsInstallHook == .F.
      IF HMG_HOOK_INSTALL() == .F.
         MsgHMGError( "Error in the Installation of the Hooks that process the Keyboard Events" )
      ENDIF
      IsInstallHook := .T.
   ENDIF

   nLastWindowIndex := GetFormIndex( aForm[ nForm ] )

   // Set Main Active Public Flag

   IF MainFound == .T.
      _HMG_SYSDATA[ 263 ] := .T.

      //  Create Wait Window, add to form array and increment form counter

      InitWaitWindow()

      AADD( aForm, '_HMG_CHILDWAITWINDOW' )

      nForm += 1

   ENDIF

   IF nForm > 1

      IF _HMG_SYSDATA[ 271 ]
         MsgHMGError( "Multiple Activation can be used when a modal window is active. Program Terminated" )
      ENDIF

      TmpId := _GenActivateId( nForm )

      FOR z := 1 TO nForm

         FormName := aForm[ z ]

         IF .NOT. _IsWindowDefined( Formname )
            MsgHMGError( "Window: " + FormName + " is not defined. Program terminated" )
         ENDIF

         IF _IsWindowActive( FormName )
            MsgHMGError( "Window: " + FormName + " already active. Program terminated" )
         ENDIF

         IF GetWindowType( FormName ) == 'P'
            MsgHMGError( "Panel Windows can't be explicity activated (They are activated via its parent). Program terminated" )
         ENDIF

         i := GetFormIndex( FormName )

         FOR x := 1 TO FormCount

            IF _HMG_SYSDATA[ 69 ] [ x ] == 'P' .AND. _HMG_SYSDATA[ 70 ] [ x ] == _HMG_SYSDATA[ 67 ] [ i ]

               _ShowWindow( _HMG_SYSDATA[ 66 ] [ x ] )

               _SetActivationFlag( x )
               _ProcessInitProcedure( x )
               _RefreshDataControls( x )

               IF _SetFocusedSplitChild( x ) == .f.
                  _SetActivationFocus( x )
               ENDIF

            ENDIF

         NEXT x

         //  Only One Visible Modal is Allowed

         IF _HMG_SYSDATA[ 69 ] [ i ] == "M" .AND. _HMG_SYSDATA[ 81 ] [ i ] == .F.
            VisibleModalCount ++
            VisibleModalName := _HMG_SYSDATA[ 66 ] [ i ]
            IF VisibleModalCount > 1
               MsgHMGError( "ACTIVATE WINDOW: Only one initially visible modal window allowed. Program terminated" )
            ENDIF
         ENDIF

         //  Set Activate Id

         _HMG_SYSDATA[ 107 ] [ i ] := TmpId

         //  If NOSHOW Is Not Specified, Show The Window.

         IF _HMG_SYSDATA[ 81 ] [ i ] == .F.
            ShowWindow( _HMG_SYSDATA[ 67 ] [ i ] )
         ENDIF

         _SetActivationFlag( i )
         _ProcessInitProcedure( i )
         _RefreshDataControls( i )

      NEXT z

      //  If Specified, Execute Show Method For Visible Modal
      //  If Not, Process Focus For Last Window In The List

      IF VisibleModalCount == 1
         _ShowWindow( VisibleModalName )
      ELSE
         IF _SetFocusedSplitChild( nLastWindowIndex ) == .f.
            _SetActivationFocus( nLastWindowIndex )
         ENDIF

      ENDIF

   ELSE

      FormName := aForm[ 1 ]

      IF .NOT. _IsWindowDefined( Formname )
         MsgHMGError( "Window: " + FormName + " is not defined. Program terminated" )
      ENDIF

      IF _IsWindowActive( FormName )
         MsgHMGError( "Window: " + FormName + " already active. Program terminated" )
      ENDIF

      IF GetWindowType( FormName ) == 'P'
         MsgHMGError( "Panel Windows can't be explicity activated (They are activated via its parent). Program terminated" )
      ENDIF

      i := GetFormIndex( FormName )

      FormCount := HMG_LEN( _HMG_SYSDATA[ 67 ] )

      FOR x := 1 TO FormCount

         IF _HMG_SYSDATA[ 69 ] [ x ] == 'P' .AND. _HMG_SYSDATA[ 70 ] [ x ] == _HMG_SYSDATA[ 67 ] [ i ]

            _ShowWindow( _HMG_SYSDATA[ 66 ] [ x ] )

            _SetActivationFlag( x )
            _ProcessInitProcedure( x )
            _RefreshDataControls( x )

            IF _SetFocusedSplitChild( x ) == .f.
               _SetActivationFocus( x )
            ENDIF

         ENDIF

      NEXT x

      IF _HMG_SYSDATA[ 69 ] [ i ] == "M"

         _ShowWindow( _HMG_SYSDATA[ 66 ] [ i ] )

         _SetActivationFlag( i )
         _ProcessInitProcedure( i )
         _RefreshDataControls( i )

      ELSE
         IF _HMG_SYSDATA[ 271 ] .AND. lActivateMsgLoop == .T.         // for HMG Debugger (by Dr. Claudio Soto, May 2016)
            MsgHMGError( "Non Modal Windows can't be activated when a modal window is active. " + Formname + " Program Terminated" )
         ENDIF

         IF _HMG_SYSDATA[ 81 ] [ i ] == .F.
            ShowWindow( GetFormHandle( FormName ) )
         ENDIF

         _SetActivationFlag( i )
         _ProcessInitProcedure( i )
         _RefreshDataControls( i )

         IF _SetFocusedSplitChild( i ) == .f.
            _SetActivationFocus( i )
         ENDIF

      ENDIF

   ENDIF

   IF lActivateMsgLoop == .T.                                         // for HMG Debugger (by Dr. Claudio Soto, June 2015)
      DoMessageLoop()                                                 // Start The Message Loop
   ENDIF

   IF nForm == 1 .AND. lNotExitAppAtCloseForm == .T.                  // for HMG Debugger (by Dr. Claudio Soto, June 2015)
      i := GetFormIndex( FormName )
      _HMG_SYSDATA[ 107 ] [ i ] := _GenActivateId( nForm + 1 )
   ENDIF

RETURN Nil

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _ActivateAllWindows()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _ActivateAllWindows

   // -----------------------------------------------------------------------------*
LOCAL i
LOCAL FormCount := HMG_LEN( _HMG_SYSDATA[ 66 ] )
LOCAL aForm     := {}
LOCAL MainName  := ''

   //  If Already Active Windows Abort Command

   IF ASCAN( _HMG_SYSDATA[ 68 ], .t. ) > 0
      MsgHMGError( "ACTIVATE WINDOW ALL: This Command Should Be Used At Application Startup Only. Program terminated" )
   ENDIF

   //  Force NoShow And NoAutoRelease Styles For Non Main Windows
   //  Excepting SplitChild and Panel
   //  ( Force AutoRelease And Visible For Main )

   FOR i := 1 TO FormCount

      IF _HMG_SYSDATA[ 65 ] [ i ] == .F.

         IF _HMG_SYSDATA[ 69 ] [ i ] != 'X' ;
                    .AND. ;
                    _HMG_SYSDATA[ 69 ] [ i ] != 'P'

            IF _HMG_SYSDATA[ 69 ] [ i ] == 'A'
               _HMG_SYSDATA[ 81 ] [ i ] := .F.
               _HMG_SYSDATA[ 105 ] [ i ] := .T.
               MainName := _HMG_SYSDATA[ 66 ] [ i ]
            ELSE
               _HMG_SYSDATA[ 81 ] [ i ] := .T.
               _HMG_SYSDATA[ 105 ] [ i ] := .F.
               AADD( aForm, _HMG_SYSDATA[ 66 ] [ i ] )
            ENDIF

         ENDIF

      ENDIF

   NEXT i

   AADD( aForm, MainName )

   //  Check For Error And Call Activate Window Command

   IF HMG_LEN( aForm ) > 0
      IF EMPTY( MainName )
         MsgHMGError( "ACTIVATE WINDOW ALL: Main Window Not Defined. Program terminated" )
      ENDIF
      _ActivateWindow( aForm )
   ELSE
      MsgHMGError( "ACTIVATE WINDOW ALL: No Windows Defined. Program terminated" )
   ENDIF

RETURN Nil
// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Procedure _PushEventInfo()
*+
*+    Called from ( h_eventcb.prg )   1 - function eventprocess()
*+                ( h_windows.prg )   4 - function events()
*+                                   1 - procedure _processinitprocedure()
*+                                   1 - function _docontroleventprocedure()
*+                                   1 - function _dowindoweventprocedure()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE _PushEventInfo

   // ------------------------------------------------------------------------------*

   AADD( _HMG_SYSDATA[ 330 ], { _HMG_SYSDATA[ 194 ], _HMG_SYSDATA[ 232 ], _HMG_SYSDATA[ 231 ], _HMG_SYSDATA[ 203 ], _HMG_SYSDATA[ 316 ], _HMG_SYSDATA[ 317 ] } )

RETURN

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Procedure _PopEventInfo()
*+
*+    Called from ( h_eventcb.prg )   1 - function eventprocess()
*+                ( h_windows.prg )   4 - function events()
*+                                   1 - procedure _processinitprocedure()
*+                                   1 - function _docontroleventprocedure()
*+                                   1 - function _dowindoweventprocedure()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE _PopEventInfo

   // ------------------------------------------------------------------------------*
LOCAL l

   l := HMG_LEN( _HMG_SYSDATA[ 330 ] )

   IF l > 0

      _HMG_SYSDATA[ 194 ] := _HMG_SYSDATA[ 330 ] [ l ] [ 1 ]
      _HMG_SYSDATA[ 232 ] := _HMG_SYSDATA[ 330 ] [ l ] [ 2 ]
      _HMG_SYSDATA[ 231 ] := _HMG_SYSDATA[ 330 ] [ l ] [ 3 ]
      _HMG_SYSDATA[ 203 ] := _HMG_SYSDATA[ 330 ] [ l ] [ 4 ]
      _HMG_SYSDATA[ 316 ] := _HMG_SYSDATA[ 330 ] [ l ] [ 5 ]
      _HMG_SYSDATA[ 317 ] := _HMG_SYSDATA[ 330 ] [ l ] [ 6 ]

      ASIZE( _HMG_SYSDATA[ 330 ], l - 1 )

   ELSE

      _HMG_SYSDATA[ 203 ] := 0                                        // _HMG_SYSDATA [ 203 ] -> _HMG_ThisIndex
      _HMG_SYSDATA[ 194 ] := 0                                        // _HMG_SYSDATA [ 194 ] -> _HMG_ThisFormIndex
      _HMG_SYSDATA[ 231 ] := ''                                       // _HMG_SYSDATA [ 231 ] -> _HMG_ThisType
      _HMG_SYSDATA[ 232 ] := ''                                       // _HMG_SYSDATA [ 232 ] -> _HMG_ThisEventType
      _HMG_SYSDATA[ 316 ] := ''                                       // _HMG_SYSDATA [ 316 ] -> _HMG_ThisFormName
      _HMG_SYSDATA[ 317 ] := ''                                       // _HMG_SYSDATA [ 317 ] -> _HMG_ThisControlName

   ENDIF

RETURN
// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Procedure _RefreshDataControls()
*+
*+    Called from ( h_windows.prg )   5 - function _activatewindow()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE _RefreshDataControls( i )

   // ------------------------------------------------------------------------------*
LOCAL SplitIndex
LOCAL x
LOCAL w

   FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 89 ] [ i ] )

      _Refresh( _HMG_SYSDATA[ 89 ] [ i ] [ x ] )

      IF _HMG_SYSDATA[ 1 ] [ _HMG_SYSDATA[ 89 ] [ i ] [ x ] ] == 'COMBO' .OR. _HMG_SYSDATA[ 1 ] [ _HMG_SYSDATA[ 89 ] [ i ] [ x ] ] == 'BROWSE'
         _SetValue( '', '', _HMG_SYSDATA[ 8 ] [ _HMG_SYSDATA[ 89 ] [ i ] [ x ] ], _HMG_SYSDATA[ 89 ] [ i ] [ x ] )
      ENDIF

   NEXT x

   IF HMG_LEN( _HMG_SYSDATA[ 90 ] [ i ] ) > 0

      FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 90 ] [ i ] )
         SplitIndex := _HMG_SYSDATA[ 90 ] [ i ] [ x ]
         FOR w := 1 TO HMG_LEN( _HMG_SYSDATA[ 89 ] [ SplitIndex ] )
            _Refresh( _HMG_SYSDATA[ 89 ] [ SplitIndex ] [ w ] )
            IF _HMG_SYSDATA[ 1 ] [ _HMG_SYSDATA[ 89 ] [ SplitIndex ] [ w ] ] == 'COMBO' .OR. _HMG_SYSDATA[ 1 ] [ _HMG_SYSDATA[ 89 ] [ SplitIndex ] [ w ] ] == 'BROWSE'
               _SetValue( '', '', _HMG_SYSDATA[ 8 ] [ _HMG_SYSDATA[ 89 ] [ SplitIndex ] [ w ] ], _HMG_SYSDATA[ 89 ] [ SplitIndex ] [ w ] )
            ENDIF
         NEXT w
      NEXT x

   ENDIF

RETURN
// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Procedure _SetActivationFlag()
*+
*+    Called from ( h_windows.prg )   5 - function _activatewindow()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE _SetActivationFlag( i )

   // ------------------------------------------------------------------------------*
LOCAL x
   _HMG_SYSDATA[ 68 ] [ i ] = .t.
   FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 90 ] [ i ] )
      _HMG_SYSDATA[ 68 ] [ _HMG_SYSDATA[ 90 ] [ i ] [ x ] ] := .t.
   NEXT x
RETURN
// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Procedure _ProcessInitProcedure()
*+
*+    Called from ( h_windows.prg )   5 - function _activatewindow()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE _ProcessInitProcedure( i )

   // ------------------------------------------------------------------------------*
   IF VALTYPE( _HMG_SYSDATA[ 72 ] [ i ] ) == 'B'
      DO EVENTS                                                       // ProcessMessages()
      _PushEventInfo()
      _HMG_SYSDATA[ 232 ] := 'WINDOW_INIT'
      _HMG_SYSDATA[ 194 ] := i
      _HMG_SYSDATA[ 231 ] := 'W'
      _HMG_SYSDATA[ 203 ] := i
      _HMG_SYSDATA[ 316 ] := _HMG_SYSDATA[ 66 ] [ _HMG_SYSDATA[ 194 ] ]
      _HMG_SYSDATA[ 317 ] := ""
      EVAL( _HMG_SYSDATA[ 72 ] [ i ] )
      _PopEventInfo()
   ENDIF
   // added in hmg 3.0.43 - start
   IF VALTYPE( _HMG_SYSDATA[ 80 ] [ i ] ) == 'B' .OR. HMG_LEN( _HMG_SYSDATA[ 102 ] [ i ] ) > 0
      InvalidateRect( _HMG_SYSDATA[ 67 ] [ i ], NIL, .F. )
   ENDIF
   // end

RETURN
// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _SetFocusedSplitChild()
*+
*+    Called from ( h_windows.prg )   1 - function _showwindow()
*+                                   4 - function _activatewindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _SetFocusedSplitChild( i )

   // ------------------------------------------------------------------------------*
LOCAL x
LOCAL SplitFocusFlag

   SplitFocusFlag := .f.

   IF HMG_LEN( _HMG_SYSDATA[ 90 ] [ i ] ) > 0

      FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 90 ] [ i ] )
         IF _HMG_SYSDATA[ 93 ] [ _HMG_SYSDATA[ 90 ] [ i ] [ x ] ] == .t.
            setfocus( _HMG_SYSDATA[ 67 ] [ _HMG_SYSDATA[ 90 ] [ i ] [ x ] ] )
            SplitFocusFlag := .T.
         ENDIF
      NEXT x

   ENDIF

RETURN SplitFocusFlag
// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Procedure _SetActivationFocus()
*+
*+    Called from ( h_windows.prg )   1 - function _showwindow()
*+                                   4 - function _activatewindow()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE _SetActivationFocus( i )

   // ------------------------------------------------------------------------------*
LOCAL Sp
LOCAL x
LOCAL FocusDefined  := .f.
LOCAL nFocusHandle
LOCAL nControlIndex

   Sp := GetFocus()
   FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 3 ] )
      IF _HMG_SYSDATA[ 4 ] [ x ] == _HMG_SYSDATA[ 67 ] [ i ]
         IF VALTYPE( _HMG_SYSDATA[ 3 ] [ x ] ) == 'N'
            IF _HMG_SYSDATA[ 3 ] [ x ] == Sp
               FocusDefined := .T.
               EXIT
            ENDIF
         ELSEIF VALTYPE( _HMG_SYSDATA[ 3 ] [ x ] ) == 'A'
            IF _HMG_SYSDATA[ 3 ] [ x ] [ 1 ] == Sp
               FocusDefined := .T.
               EXIT
            ENDIF
         ENDIF
      ENDIF
   NEXT x

   IF FocusDefined == .F.

      nFocusHandle := GetNextDlgTabItem( _HMG_SYSDATA[ 67 ] [ i ], 0, .F. )

      nControlIndex := ASCAN( _HMG_SYSDATA[ 3 ], nFocusHandle )

      IF nControlIndex <> 0

         _SetFocus(,, nControlIndex )

      ELSE
         SetFocus( nFocusHandle )

      ENDIF

   ENDIF

RETURN
// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _GenActivateId()
*+
*+    Called from ( h_windows.prg )   2 - function _activatewindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GenActivateId( nForm )

   // ------------------------------------------------------------------------------*
LOCAL TmpStr
LOCAL TmpId

   DO WHILE .t.
      TmpId := INT( SECONDS() * 100 )
      TmpStr := '_HMG_ACTIVATE_' + ALLTRIM( STR( TmpId ) )
      IF !__MVEXIST( TmpStr )
         EXIT
      END IF
   ENDDO

   __MVPUBLIC( TmpStr )
   __MVPUT( TmpStr, nForm )

RETURN TmpId

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Procedure _hmg_OnHideFocusManagement()
*+
*+    Called from ( h_windows.prg )   1 - function events()
*+                                   1 - function _hidewindow()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE _hmg_OnHideFocusManagement( i )

   // ------------------------------------------------------------------------------*
LOCAL FormCount
LOCAL z
LOCAL x

   FormCount := HMG_LEN( _HMG_SYSDATA[ 67 ] )

   IF _HMG_SYSDATA[ 70 ] [ i ] == 0                                   // _HMG_aFormParentHandle
      //  Non Modal

      IF _HMG_SYSDATA[ 271 ] == .F.                                   // _HMG_IsModalActive
         FOR z := 1 TO FormCount
            IF _HMG_SYSDATA[ 65 ] [ z ] == .F.                        // _HMG_aFormDeleted
               EnableWindow( _HMG_SYSDATA[ 67 ] [ z ] )
            ENDIF
         NEXT z
      ENDIF

   ELSE

      //  Modal

      x := ASCAN( _HMG_SYSDATA[ 67 ], _HMG_SYSDATA[ 70 ] [ i ] )      // if exist FormParentHandle
      IF x > 0

         IF _HMG_SYSDATA[ 69 ] [ x ] == "M"                           // Modal Window
            //  Modal Parent
            _HMG_SYSDATA[ 271 ] := .T.                                // _HMG_IsModalActive
            _HMG_SYSDATA[ 167 ] := _HMG_SYSDATA[ 70 ] [ i ]           // _HMG_ActiveModalHandle = _HMG_aFormParentHandle
            EnableWindow( _HMG_SYSDATA[ 70 ] [ i ] )                  // _HMG_aFormParentHandle
            SetFocus( _HMG_SYSDATA[ 70 ] [ i ] )                      // _HMG_aFormParentHandle
         ELSE
            //  Non Modal Parent
            _HMG_SYSDATA[ 271 ] := .F.                                // _HMG_IsModalActive
            _HMG_SYSDATA[ 167 ] := 0                                  // _HMG_ActiveModalHandle

            FOR z := 1 TO FormCount
               IF _HMG_SYSDATA[ 65 ] [ z ] == .F.                     // _HMG_aFormDeleted
                  EnableWindow( _HMG_SYSDATA[ 67 ] [ z ] )            // _HMG_aFormHandles
               ENDIF
            NEXT z
            SetFocus( _HMG_SYSDATA[ 70 ] [ i ] )                      // _HMG_aFormParentHandle
         ENDIF

      ELSE

         //  Missing Parent

         _HMG_SYSDATA[ 271 ] := .F.                                   // _HMG_IsModalActive
         _HMG_SYSDATA[ 167 ] := 0                                     // _HMG_ActiveModalHandle
         FOR z := 1 TO FormCount
            IF _HMG_SYSDATA[ 65 ] [ z ] == .F.                        // _HMG_aFormDeleted
               EnableWindow( _HMG_SYSDATA[ 67 ] [ z ] )               // _HMG_aFormHandles
            ENDIF
         NEXT z
         SetFocus( _HMG_SYSDATA[ 181 ] )                              // _HMG_MainHandle

      ENDIF

   ENDIF

RETURN

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _DoControlEventProcedure()
*+
*+    Called from ( h_browse.prg )   1 - procedure _browseonchange()
*+                ( h_grid.prg )   1 - procedure _hmg_gridinplaceeditok()
*+                                   1 - procedure _hmg_gridinplacekbdedit_2()
*+                ( h_controlmisc.prg )  11 - function _setvalue()
*+                ( h_windows.prg )  75 - function events()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _DoControlEventProcedure( bBlock, i )

   // ------------------------------------------------------------------------------*
   IF _HMG_StopControlEventProcedure[ i ] == .T.                      //   ( Dr. Claudio Soto, April 2013 )
      RETURN .F.
   ENDIF

   IF _HMG_SYSDATA[ 1 ] [ i ] <> "HOTKEY"                             //  ADD, November 2016
      _HMG_LastActiveControlIndex := i
   ENDIF

   IF VALTYPE( bBlock ) == 'B'
      _PushEventInfo()
      _HMG_SYSDATA[ 194 ] := ASCAN( _HMG_SYSDATA[ 67 ], _HMG_SYSDATA[ 4 ] [ i ] )                                                           // FormParentIndex
      _HMG_SYSDATA[ 231 ] := 'C'
      _HMG_SYSDATA[ 203 ] := i                                        // ControlIndex
      _HMG_SYSDATA[ 316 ] := _HMG_SYSDATA[ 66 ] [ _HMG_SYSDATA[ 194 ] ]                                                                     // FormParentName
      _HMG_SYSDATA[ 317 ] := _HMG_SYSDATA[ 2 ] [ _HMG_SYSDATA[ 203 ] ]                                                                      // ControlName

      _HMG_SYSDATA[ 293 ] := EVAL( bBlock )

      _PopEventInfo()
      RETURN .T.
   ENDIF

RETURN .F.

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _DoWindowEventProcedure()
*+
*+    Called from ( h_windows.prg )  19 - function events()
*+                                   1 - function releaseallwindows()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _DoWindowEventProcedure( bBlock, i, cEventType )

   // ------------------------------------------------------------------------------*
LOCAL lRetVal := .F.

   IF cEventType == "MOUSEMOVE" .AND. VALTYPE( bBlock ) <> "B"
      RETURN .F.
   ENDIF

   IF cEventType <> "TASKBAR"                                         //  ADD, November 2016
      _HMG_LastActiveFormIndex := i
   ENDIF

   IF _HMG_StopWindowEventProcedure[ i ] == .T.                       //   ( Dr. Claudio Soto, April 2013 )
      RETURN .F.
   ENDIF

   IF VALTYPE( bBlock ) == 'B'

      _PushEventInfo()
      _HMG_SYSDATA[ 194 ] := i
      _HMG_SYSDATA[ 232 ] := cEventType
      _HMG_SYSDATA[ 231 ] := 'W'
      _HMG_SYSDATA[ 203 ] := i
      _HMG_SYSDATA[ 316 ] := _HMG_SYSDATA[ 66 ] [ _HMG_SYSDATA[ 194 ] ]
      _HMG_SYSDATA[ 317 ] := ""
      lRetVal := EVAL( bBlock )
      _PopEventInfo()

   ENDIF

RETURN lRetVal

//  by Dr. Claudio Soto, April 2013
// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function StopWindowEventProcedure()
*+
*+--------------------------------------------------------------------
*+
FUNCTION StopWindowEventProcedure( cFormName, lStop )

   // ------------------------------------------------------------------------------*
LOCAL i
   i := GetFormIndex( cFormName )
   _HMG_StopWindowEventProcedure[ i ] := IIF( VALTYPE( lStop ) <> "L", .F., lStop )
RETURN NIL

//  by Dr. Claudio Soto, April 2013
// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function StopControlEventProcedure()
*+
*+--------------------------------------------------------------------
*+
FUNCTION StopControlEventProcedure( cControlName, cFormName, lStop )

   // ------------------------------------------------------------------------------*
LOCAL i
   i := GetControlIndex( cControlName, cFormName )
   _HMG_StopControlEventProcedure[ i ] := IIF( VALTYPE( lStop ) <> "L", .F., lStop )
RETURN NIL

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _GetGridCellData()
*+
*+    Called from ( h_grid.prg )   1 - function _hmg_gridonclickandonkeyevent()
*+                ( h_windows.prg )   3 - function events()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _GetGridCellData( i )

   // ------------------------------------------------------------------------------*
LOCAL ThisItemRowIndex
LOCAL ThisItemColIndex
LOCAL ThisItemCellRow
LOCAL ThisItemCellCol
LOCAL ThisItemCellWidth
LOCAL ThisItemCellHeight
LOCAL r
LOCAL xs
LOCAL xd
LOCAL aCellData

LOCAL ControlHandle := _HMG_SYSDATA[ 3 ] [ i ]

LOCAL nRowControl := IF( VALTYPE( _HMG_SYSDATA[ 18 ] [ i ] ) == "N", _HMG_SYSDATA[ 18 ] [ i ], 0 )                                          // check if number --> SplitBox
LOCAL nColControl := IF( VALTYPE( _HMG_SYSDATA[ 19 ] [ i ] ) == "N", _HMG_SYSDATA[ 19 ] [ i ], 0 )                                          // check if number --> SplitBox

LOCAL nWidthControl := _HMG_SYSDATA[ 20 ] [ i ]

   r := ListView_HitTest( ControlHandle, GetCursorRow() - GetWindowRow( ControlHandle ), GetCursorCol() - GetWindowCol( ControlHandle ) )
   IF r[ 2 ] == 1
      ListView_Scroll( ControlHandle, - 10000, 0 )
      r := ListView_HitTest( ControlHandle, GetCursorRow() - GetWindowRow( ControlHandle ), GetCursorCol() - GetWindowCol( ControlHandle ) )
   ELSE
      r := LISTVIEW_GETSUBITEMRECT( ControlHandle, r[ 1 ] - 1, r[ 2 ] - 1 )
      xs := ( ( nColControl + r[ 2 ] ) + r[ 3 ] ) - ( nColControl + nWidthControl )
      IF ListView_GetItemCount( ControlHandle ) > ListViewGetCountPerPage( ControlHandle )
         xd := 20
      ELSE
         xd := 0
      ENDIF

      IF xs > - xd
         ListView_Scroll( ControlHandle, xs + xd, 0 )
      ELSE
         IF r[ 2 ] < 0
            ListView_Scroll( ControlHandle, r[ 2 ], 0 )
         ENDIF
      ENDIF

      r := ListView_HitTest( ControlHandle, GetCursorRow() - GetWindowRow( ControlHandle ), GetCursorCol() - GetWindowCol( ControlHandle ) )

   ENDIF

   ThisItemRowIndex := r[ 1 ]
   ThisItemColIndex := r[ 2 ]

   IF r[ 2 ] == 1
      r := LISTVIEW_GETITEMRECT( ControlHandle, r[ 1 ] - 1 )
   ELSE
      r := LISTVIEW_GETSUBITEMRECT( ControlHandle, r[ 1 ] - 1, r[ 2 ] - 1 )
   ENDIF

   ThisItemCellRow := nRowControl + r[ 1 ]
   ThisItemCellCol := nColControl + r[ 2 ]
   ThisItemCellWidth := r[ 3 ]
   ThisItemCellHeight := r[ 4 ]

   aCellData := { ThisItemRowIndex, ThisItemColIndex, ThisItemCellRow, ThisItemCellCol, ThisItemCellWidth, ThisItemCellHeight }

RETURN aCellData
// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function IsXPThemeActive()
*+
*+--------------------------------------------------------------------
*+
FUNCTION IsXPThemeActive()

   // ------------------------------------------------------------------------------*
LOCAL uResult

   IF _HMG_SYSDATA[ 250 ]

      uResult := CallDll32( "IsThemeActive", "UXTHEME.DLL", 0 )

      IF uResult != 0
         uResult := .T.
      ELSE
         uResult := .F.
      ENDIF

   ELSE

      uResult := .F.

   ENDIF

RETURN uResult

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Procedure InstallEventHandler()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE InstallEventHandler( cProcedure )

   // ------------------------------------------------------------------------------*

   AADD( _HMG_SYSDATA[ 60 ], ALLTRIM( HMG_UPPER( cProcedure ) ) )

RETURN

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Procedure InstallPropertyHandler()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE InstallPropertyHandler( cPropertyName, cSetProcedure, cGetProcedure )

   // ------------------------------------------------------------------------------*

   AADD( _HMG_SYSDATA[ 61 ], { ALLTRIM( HMG_UPPER( cPropertyName ) ), ALLTRIM( HMG_UPPER( cSetProcedure ) ), ALLTRIM( HMG_UPPER( cGetProcedure ) ) } )

RETURN

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Procedure InstallMethodHandler()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE InstallMethodHandler( cEventName, cMethodProcedure )

   // ------------------------------------------------------------------------------*

   AADD( _HMG_SYSDATA[ 62 ], { ALLTRIM( HMG_UPPER( cEventName ) ), ALLTRIM( HMG_UPPER( cMethodProcedure ) ) } )

RETURN

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function SAVEWINDOW()
*+
*+    Called from ( h_controlmisc.prg )   2 - function domethod()
*+                ( h_windows.prg )   1 - function printwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SAVEWINDOW( cWindowName, cFileName, nRow, nCol, nWidth, nHeight )

   // ------------------------------------------------------------------------------*
LOCAL hBitmap
   hBitmap := BT_BitmapCaptureClientArea( cWindowName, nRow, nCol, nWidth, nHeight )
   IF hBitmap <> 0
      DEFAULT cFileName TO cWindowName + '.BMP'
      BT_BitmapSaveFile( hBitmap, cFileName )
      BT_BitmapRelease( hBitmap )
   ENDIF
RETURN NIL

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function PRINTWINDOW()
*+
*+    Called from ( h_controlmisc.prg )   1 - function domethod()
*+
*+--------------------------------------------------------------------
*+
FUNCTION PRINTWINDOW( cWindowName, lPreview, ldialog, nRow, nCol, nWidth, nHeight )

   // ------------------------------------------------------------------------------*
LOCAL lSuccess
LOCAL TempName
LOCAL W
LOCAL H
LOCAL HO
LOCAL VO
LOCAL bw, bh, r, tw, th, dc, wdif, hdif, dr
LOCAL ntop, nleft, nbottom, nright

   IF VALTYPE( nRow ) = 'U' ;
               .OR. ;
               VALTYPE( nCol ) = 'U' ;
               .OR. ;
               VALTYPE( nWidth ) = 'U' ;
               .OR. ;
               VALTYPE( nHeight ) = 'U'

      ntop := - 1
      nleft := - 1
      nbottom := - 1
      nright := - 1

   ELSE

      ntop := nRow
      nleft := nCol
      nbottom := nHeight + nRow
      nright := nWidth + nCol

   ENDIF

   IF VALTYPE( lDialog ) = 'U'
      lDialog := .F.
   ENDIF

   IF VALTYPE( lPreview ) = 'U'
      lPreview := .F.
   ENDIF

   IF lDialog

      IF lPreview
         SELECT PRINTER DIALOG TO lSuccess PREVIEW
      ELSE
         SELECT PRINTER DIALOG TO lSuccess
      ENDIF

      IF !lSuccess
         RETURN NIL
      ENDIF

   ELSE

      IF lPreview
         SELECT PRINTER DEFAULT TO lSuccess PREVIEW
      ELSE
         SELECT PRINTER DEFAULT TO lSuccess
      ENDIF

      IF !lSuccess
         MSGHMGERROR( "Can't Init Printer" )
         RETURN NIL
      ENDIF

   ENDIF

   IF !_IsWIndowDefined( cWindowName )
      MSGHMGERROR( 'Window Not Defined' )
      RETURN NIL
   ENDIF

   TempName := GetTempFolder() + '_hmg_printwindow_' + ALLTRIM( STR( INT( SECONDS() * 100 ) ) ) + '.BMP'

   SAVEWINDOW( cWindowName, TempName, nRow, nCol, nWidth, nHeight )

   HO := GETPRINTABLEAREAHORIZONTALOFFSET()
   VO := GETPRINTABLEAREAVERTICALOFFSET()

   W := GETPRINTABLEAREAWIDTH() - 10 - ( HO * 2 )
   H := GETPRINTABLEAREAHEIGHT() - 10 - ( VO * 2 )

   IF ntop = - 1

      bw := GetProperty( cWindowName, 'Width' )
      bh := GetProperty( cWindowName, 'Height' ) - GetTitleHeight( GetFormHandle( cWindowName ) )

   ELSE

      bw := nright - nleft
      bh := nbottom - ntop

   ENDIF

   r := bw / bh

   tw := 0
   th := 0

   DO WHILE .t.

      tw ++
      th := tw / r

      IF tw > w .OR. th > h
         EXIT
      ENDIF

   ENDDO

   wdif := w - tw

   IF wdif > 0
      dc := wdif / 2
   ELSE
      dc := 0
   ENDIF

   hdif := h - th

   IF hdif > 0
      dr := hdif / 2
   ELSE
      dr := 0
   ENDIF

   START PRINTDOC

      START PRINTPAGE

         @ VO + 10 + ( ( h - th ) / 2 ), HO + 10 + ( ( w - tw ) / 2 ) PRINT IMAGE TempName WIDTH tW HEIGHT tH

      END PRINTPAGE

   END PRINTDOC

   DO EVENTS

   FERASE( TempName )

RETURN NIL

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function IsAppThemed()
*+
*+    Called from ( h_grid.prg )   3 - function _hmg_gridinplaceedit()
*+                ( h_button.prg )   1 - function _defineimagebutton()
*+                ( h_checkbox.prg )   1 - function _defineimagecheckbutton()
*+                ( h_controlmisc.prg )   2 - function _disablecontrol()
*+                                   2 - function _enablecontrol()
*+                                   2 - function _setpicture()
*+                                   1 - function _erasecontrol()
*+                                   5 - function _hmg_printer_showpreview()
*+                                   2 - function _hmg_printer_processthumbnails()
*+                ( h_label.prg )   1 - function _definelabel()
*+                ( h_tab.prg )   2 - function _definetab()
*+                ( h_windows.prg )   4 - function events()
*+
*+--------------------------------------------------------------------
*+
FUNCTION IsAppThemed()

   // ------------------------------------------------------------------------------*
LOCAL uResult
LOCAL nVersion

   nVersion := WINMAJORVERSIONNUMBER() + ( WINMINORVERSIONNUMBER() / 10 )

   IF nVersion >= 5.1

      //    uResult := CallDll32 ( "IsAppThemed" , "UXTHEME.DLL", 0  )
      uResult := CallDll32( "IsAppThemed", "UXTHEME.DLL" )

      IF uResult != 0
         uResult := .T.
      ELSE
         uResult := .F.
      ENDIF

   ELSE

      uResult := .F.

   ENDIF

RETURN uResult

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function OpenThemeData()
*+
*+--------------------------------------------------------------------
*+
FUNCTION OpenThemeData( hwnd, pszClassList )

   // ------------------------------------------------------------------------------*
LOCAL uResult := CallDll32( "OpenThemeData", "UXTHEME.DLL", hwnd, pszClassList )
RETURN uResult

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function CloseThemeData()
*+
*+--------------------------------------------------------------------
*+
FUNCTION CloseThemeData( hTheme )

   // ------------------------------------------------------------------------------*
LOCAL uResult := CallDll32( "CloseThemeData", "UXTHEME.DLL", hTheme )
RETURN uResult

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function DrawThemeBackground()
*+
*+--------------------------------------------------------------------
*+
FUNCTION DrawThemeBackground( hTheme, hdc, iPartId, iStateId, pRect, pClipRect )

   // ------------------------------------------------------------------------------*
LOCAL uResult := CallDll32( "DrawThemeBackground", "UXTHEME.DLL", hTheme, hdc, iPartId, iStateId, pRect, pClipRect )
RETURN uResult

// ----------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Procedure VirtualChildControlFocusProcess()
*+
*+    Called from ( h_windows.prg )  10 - function events()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE VirtualChildControlFocusProcess( nControlHandle, nWindowHandle )

   // ----------------------------------------------------------------*
LOCAL x                            := 0
LOCAL nWindowVirtualWidth          := 0
LOCAL nWindowVirtualHeight         := 0
LOCAL nWindowHeight                := 0
LOCAL nWindowWidth                 := 0
LOCAL nControlHeight               := 0
LOCAL nControlWidth                := 0
LOCAL nControlRow                  := 0
LOCAL nControlCol                  := 0
LOCAL nHorizontalScrollBoxPos      := 0
LOCAL nVerticalScrollBoxPos        := 0
LOCAL nHorizontalScrollBarRangeMax := 0
LOCAL nVerticalScrollBarRangeMax   := 0
LOCAL nVisibleAreaFromRow          := 0
LOCAL nVisibleAreaFromCol          := 0
LOCAL nVisibleAreaToRow            := 0
LOCAL nVisibleAreaToCol            := 0
LOCAL nNewScrollBarPos             := 0

   IF _HMG_SYSDATA[ 346 ] == .F.
      RETURN
   ENDIF

   //  Get Window Width / Height / Virtual Width / Virtual Height

   FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 67 ] )

      IF _HMG_SYSDATA[ 67 ] [ X ] == nWindowHandle

         nWindowVirtualHeight := _HMG_SYSDATA[ 91 ] [ x ]
         nWindowVirtualWidth := _HMG_SYSDATA[ 92 ] [ x ]

         IF nWindowVirtualHeight == 0 ;
                    .AND. ;
                    nWindowVirtualWidth == 0

            // Return .T.   // REMOVE
            RETURN
         ELSE

            nWindowHeight := GetWindowHeight( nWindowHandle )
            nWindowWidth := GetWindowWidth( nWindowHandle )

            EXIT

         ENDIF

      ENDIF

   NEXT x

   //  Get Control Row / Col / Width / Height

   FOR x := 1 TO HMG_LEN( _HMG_SYSDATA[ 3 ] )

      IF VALTYPE( _HMG_SYSDATA[ 3 ] [ x ] ) == 'N' ;
                  .AND. ;
                  VALTYPE( nControlHandle ) == 'N'

         IF _HMG_SYSDATA[ 3 ] [ x ] == nControlHandle

            nControlHeight := _HMG_SYSDATA[ 21 ] [ x ]
            nControlWidth := _HMG_SYSDATA[ 20 ] [ x ]
            nControlRow := _HMG_SYSDATA[ 18 ] [ x ]
            nControlCol := _HMG_SYSDATA[ 19 ] [ x ]

            EXIT

         ENDIF

      ELSEIF VALTYPE( _HMG_SYSDATA[ 3 ] [ x ] ) == 'A' ;
                         .AND. ;
                         VALTYPE( nControlHandle ) == 'N'

         IF ASCAN( _HMG_SYSDATA[ 3 ] [ x ], nControlHandle ) > 0

            nControlHeight := _HMG_SYSDATA[ 21 ] [ x ]
            nControlWidth := _HMG_SYSDATA[ 20 ] [ x ]
            nControlRow := _HMG_SYSDATA[ 18 ] [ x ]
            nControlCol := _HMG_SYSDATA[ 19 ] [ x ]

            EXIT

         ENDIF

      ENDIF

   NEXT x

   //  Get hScrollBox Position / vScrollBox Position

   nHorizontalScrollBoxPos := GetScrollPos( nWindowHandle, SB_HORZ )
   nVerticalScrollBoxPos := GetScrollPos( nWindowHandle, SB_VERT )

   //  Get hScrollBar Maximun Range / vScrollBar Maximun Range

   nHorizontalScrollBarRangeMax := GetScrollRangeMax( nWindowHandle, SB_HORZ )
   nVerticalScrollBarRangeMax := GetScrollRangeMax( nWindowHandle, SB_VERT )

   //  Calculate Current Visible Area

   nVisibleAreaFromRow := nVerticalScrollBoxPos
   nVisibleAreaFromCol := nHorizontalScrollBoxPos

   nVisibleAreaToRow := nVisibleAreaFromRow + nWindowHeight - 50
   nVisibleAreaToCol := nVisibleAreaFromCol + nWindowWidth - 10

   //  Determine if Control Getting the Focus is out of Visible
   //  Area. If So, scroll The Window.

   //  Control is too LoW To be Visible

   IF nControlRow + nControlHeight > nVisibleAreaToRow

      nNewScrollBarPos := nControlRow + nControlHeight - nWindowHeight + 100

      IF nNewScrollBarPos > nVerticalScrollBarRangeMax
         nNewScrollBarPos := nVerticalScrollBarRangeMax
      ENDIF

      _HMG_PRINTER_SETVSCROLLVALUE( nWindowHandle, nNewScrollBarPos )

   ELSE

      //  Control is too high To be Visible

      IF nControlRow + nControlHeight < nVisibleAreaFromRow

         nNewScrollBarPos := nControlRow - nWindowHeight - 100

         IF nNewScrollBarPos < 0
            nNewScrollBarPos := 0
         ENDIF

         _HMG_PRINTER_SETVSCROLLVALUE( nWindowHandle, nNewScrollBarPos )

      ENDIF

   ENDIF

   //  Control Is Too RIGHT To Be Visible

   IF nControlCol + nControlWidth > nVisibleAreaToCol

      nNewScrollBarPos := nControlCol + nControlWidth - nWindowWidth + 100

      IF nNewScrollBarPos > nHorizontalScrollBarRangeMax
         nNewScrollBarPos := nHorizontalScrollBarRangeMax
      ENDIF

      _HMG_PRINTER_SETHSCROLLVALUE( nWindowHandle, nNewScrollBarPos )

   ELSE

      //  Control Is Too LEFT To Be Visible

      IF nControlCol + nControlWidth < nVisibleAreaFromCol

         nNewScrollBarPos := nControlCol - nWindowWidth - 100

         IF nNewScrollBarPos < 0
            nNewScrollBarPos := 0
         ENDIF

         _HMG_PRINTER_SETHSCROLLVALUE( nWindowHandle, nNewScrollBarPos )

      ENDIF

   ENDIF

RETURN

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function InitWaitWindow()
*+
*+    Called from ( h_windows.prg )   1 - function _activatewindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION InitWaitWindow()

   // ------------------------------------------------------------------------------*

   DEFINE WINDOW _HMG_CHILDWAITWINDOW ;
      AT 0, 0 ;
      WIDTH 500 ;
      HEIGHT 40 ;
      TITLE '' ;
      CHILD ;
      NOSHOW ;
      NOSYSMENU ;
      NOCAPTION

   DEFINE LABEL Message
      ROW 5
      COL 10
      WIDTH 480
      HEIGHT 25
      VALUE ''
      CENTERALIGN .T.
   END LABEL

   END WINDOW

   _HMG_CHILDWAITWINDOW.CENTER

RETURN Nil

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function ShowWaitWindow()
*+
*+    Called from ( h_windows.prg )   1 - function waitwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION ShowWaitWindow( cMessage )

   // ------------------------------------------------------------------------------*

   _HMG_CHILDWAITWINDOW.MESSAGE.VALUE := cMessage

   _HMG_CHILDWAITWINDOW.SHOW

RETURN Nil

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function ShowWaitWindowModal()
*+
*+    Called from ( h_windows.prg )   2 - function waitwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION ShowWaitWindowModal( cMessage )

   // ------------------------------------------------------------------------------*
LOCAL lExit, i

   lExit := .F.

   _HMG_CHILDWAITWINDOW.MESSAGE.VALUE := cMessage

   _HMG_CHILDWAITWINDOW.SHOW

   FOR i := 1 TO 255
      GetAsyncKeyState( i )
   NEXT i

   DO WHILE .NOT. lExit
      FOR i := 1 TO 255
         IF GetAsyncKeyState( i ) <> 0
            lExit := .T.
            EXIT
         ENDIF
      NEXT i
   ENDDO

   _HMG_CHILDWAITWINDOW.HIDE

RETURN Nil

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function HideWaitWindow()
*+
*+    Called from ( h_windows.prg )   1 - function waitwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HideWaitWindow()

   // ------------------------------------------------------------------------------*

   _HMG_CHILDWAITWINDOW.HIDE

RETURN Nil

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function WaitWindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION WaitWindow( cMessage, lNoWait )

   // ------------------------------------------------------------------------------*

   IF PCOUNT() > 0

      IF VALTYPE( lNoWait ) == 'L'

         IF lNoWait == .T.

            ShowWaitWindow( cMessage )

         ELSE

            ShowWaitWindowModal( cMessage )

         ENDIF

      ELSE

         ShowWaitWindowModal( cMessage )

      ENDIF

   ELSE

      HideWaitWindow()

   ENDIF

RETURN Nil

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function GetWindowDataByIndex()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetWindowDataByIndex( k )

   // -----------------------------------------------------------------------------*
LOCAL aWinData := {}
   AADD( aWinData, _HMG_SYSDATA[ 66 ] [ k ] )                         // FormName
   AADD( aWinData, _HMG_SYSDATA[ 67 ] [ k ] )                         // FormHandle
   AADD( aWinData, _HMG_SYSDATA[ 68 ] [ k ] )                         // .f.
   AADD( aWinData, _HMG_SYSDATA[ 69 ] [ k ] )                         // cType
   AADD( aWinData, _HMG_SYSDATA[ 70 ] [ k ] )                         // If ( panel , Parenthandle , 0 )
   AADD( aWinData, _HMG_SYSDATA[ 71 ] [ k ] )                         // ReleaseProcedure
   AADD( aWinData, _HMG_SYSDATA[ 72 ] [ k ] )                         // InitProcedure
   AADD( aWinData, _HMG_SYSDATA[ 73 ] [ k ] )                         // htooltip
   AADD( aWinData, _HMG_SYSDATA[ 74 ] [ k ] )                         // 0
   AADD( aWinData, _HMG_SYSDATA[ 75 ] [ k ] )                         // MouseDragProcedure
   AADD( aWinData, _HMG_SYSDATA[ 76 ] [ k ] )                         // SizeProcedure
   AADD( aWinData, _HMG_SYSDATA[ 77 ] [ k ] )                         // ClickProcedure
   AADD( aWinData, _HMG_SYSDATA[ 78 ] [ k ] )                         // MouseMoveProcedure
   AADD( aWinData, _HMG_SYSDATA[ 65 ] [ k ] )                         // .f.
   AADD( aWinData, _HMG_SYSDATA[ 79 ] [ k ] )                         // aRGB
   AADD( aWinData, _HMG_SYSDATA[ 80 ] [ k ] )                         // PaintProcedure
   AADD( aWinData, _HMG_SYSDATA[ 81 ] [ k ] )                         // noshow
   AADD( aWinData, _HMG_SYSDATA[ 82 ] [ k ] )                         // NotifyIconName
   AADD( aWinData, _HMG_SYSDATA[ 83 ] [ k ] )                         // NotifyIconToolTip
   AADD( aWinData, _HMG_SYSDATA[ 84 ] [ k ] )                         // NotifyIconLeftClick
   AADD( aWinData, _HMG_SYSDATA[ 85 ] [ k ] )                         // GotFocus
   AADD( aWinData, _HMG_SYSDATA[ 86 ] [ k ] )                         // LostFocus
   AADD( aWinData, _HMG_SYSDATA[ 87 ] [ k ] )                         // 0
   AADD( aWinData, _HMG_SYSDATA[ 88 ] [ k ] )                         // 0
   AADD( aWinData, _HMG_SYSDATA[ 89 ] [ k ] )                         // {}
   AADD( aWinData, _HMG_SYSDATA[ 90 ] [ k ] )                         // {}
   AADD( aWinData, _HMG_SYSDATA[ 91 ] [ k ] )                         // VirtualHeight
   AADD( aWinData, _HMG_SYSDATA[ 92 ] [ k ] )                         // VirtualWidth
   AADD( aWinData, _HMG_SYSDATA[ 93 ] [ k ] )                         // .f.
   AADD( aWinData, _HMG_SYSDATA[ 94 ] [ k ] )                         // ScrollUp
   AADD( aWinData, _HMG_SYSDATA[ 95 ] [ k ] )                         // ScrollDown
   AADD( aWinData, _HMG_SYSDATA[ 96 ] [ k ] )                         // ScrollLeft
   AADD( aWinData, _HMG_SYSDATA[ 97 ] [ k ] )                         // ScrollRight
   AADD( aWinData, _HMG_SYSDATA[ 98 ] [ k ] )                         // HScrollBox
   AADD( aWinData, _HMG_SYSDATA[ 99 ] [ k ] )                         // VScrollBox
   AADD( aWinData, _HMG_SYSDATA[ 100 ] [ k ] )                        // BrushHandle
   AADD( aWinData, _HMG_SYSDATA[ 101 ] [ k ] )                        // 0
   AADD( aWinData, _HMG_SYSDATA[ 102 ] [ k ] )                        // {}
   AADD( aWinData, _HMG_SYSDATA[ 103 ] [ k ] )                        // MaximizeProcedure
   AADD( aWinData, _HMG_SYSDATA[ 104 ] [ k ] )                        // MinimizeProcedure
   AADD( aWinData, _HMG_SYSDATA[ 105 ] [ k ] )                        // .Not. NoAutoRelease
   AADD( aWinData, _HMG_SYSDATA[ 106 ] [ k ] )                        // InteractiveCloseProcedure
   AADD( aWinData, _HMG_SYSDATA[ 107 ] [ k ] )                        // 0
   AADD( aWinData, _HMG_SYSDATA[ 108 ] [ k ] )                        // NIL
   AADD( aWinData, _HMG_SYSDATA[ 504 ] [ k ] )                        // {x, y, w, h}
   AADD( aWinData, _HMG_SYSDATA[ 511 ] [ k ] )                        // hToolTipMenu
   AADD( aWinData, _HMG_SYSDATA[ 512 ] [ k ] )                        // ToolTip Form Data

   AADD( aWinData, _HMG_StopWindowEventProcedure[ k ] )               // .F.
RETURN aWinData

*+ EOF: h_windows.prg

