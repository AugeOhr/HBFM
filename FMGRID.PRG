*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\FMGRID.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Procedure DualGrid()
*+               Function MoreParaLeft()
*+               Function MoreParaRight()
*+               Procedure Fill1StGrid()
*+               Procedure FillCombo()
*+               Procedure DoComboImage()
*+               Static Procedure DefGridLeft()
*+               Static Procedure DefGridRight()
*+               Procedure DoSHfunc()
*+               Function DoSH2func()
*+               Static Procedure ReFreshGrid()
*+               Procedure ReRead()
*+               Function DoSH3func()
*+               Function GetSelectItem()
*+               Procedure GetPathAndFile()
*+               Function SP_GridLeft()
*+               Function SP_GridRight()
*+               Static Procedure CopyClipboard()
*+               Static Procedure ZipIt()
*+               Static Procedure DoIt()
*+               Static Function GridSortDir()
*+               Static Function GridGetSort()
*+               Static Function GridGetDESCEND()
*+               Static Function GridGetPath()
*+               Static Function GridChangePath()
*+               Static Procedure Paint_Background_Window()
*+               Static Procedure Paint_Main_Background_Window()
*+               Static Procedure Paint_Tab_Window()
*+               Static Procedure DoReSizeMain()
*+               Static Procedure DoGridKey1()
*+               Static Procedure DoGridKey2()
*+               Static Procedure OpenCombo()
*+               Static Procedure DragMove()
*+               Static Procedure DragHere()
*+               Procedure AddFile2Grid()
*+               Static Procedure Readydrag()
*+               Static Procedure Change2Drive()
*+               Static Function GetVolumne()
*+               Static Procedure CreateNewFolder()
*+               Static Procedure FillWithDir()
*+               Static Procedure DirImageColor()
*+               Static Procedure HeadLeft()
*+               Static Procedure HeadRight()
*+               Static Procedure NewTab()
*+               Procedure Tab_Change_Left()
*+               Procedure Tab_Change_Right()
*+               Static Procedure TestTabKey()
*+               Static Function IsKeyVK()
*+               Procedure SbarText()
*+               Static Procedure InfoGridChange1()
*+               Static Procedure InfoGridChange2()
*+               Static Procedure CompareDir()
*+               Static Procedure CheckOtherSide()
*+               Static Procedure SetTabStatusText()
*+               Static Procedure DoAuswahl()
*+               Static Procedure PreFuncSysFolder()
*+               Static Procedure PreFuncMSCFolder()
*+               Static Procedure DoMarkFiles()
*+               Static Procedure ChangeLeftRight()
*+               Static Procedure DataViewer()
*+               Static Procedure Pre_BrowseView()
*+               Procedure CheckTabView()
*+               Static Procedure SearchForm()
*+               Static Procedure UpDirPath()
*+               Static Procedure RootUpDirPath()
*+               Static Procedure CloseTab()
*+               Static Procedure SelFolder()
*+               Static Procedure SetActivPath()
*+               Static Function GetActivPath()
*+               Static Procedure GridGotFocus()
*+               Static Procedure WatchDirSwitch()
*+               Static Procedure ItemMark()
*+               Static Procedure ItemUnMark()
*+               Static Procedure UnMarkAll()
*+               Static Procedure RunCMDBox()
*+               Static Procedure ReleaseDelKey()
*+               Static Procedure DelTemp_FI_BMP()
*+               Static Procedure CloseAllThread()
*+               Static Procedure AddBackLog()
*+               Static Procedure ShowHistory()
*+               Static Procedure Back2Dirlist()
*+               Static Procedure DoReSizeBackList()
*+               Static Procedure SaveSetup()
*+               Static Procedure RunWithParameter()
*+               Static Procedure RestoreTab()
*+               Static Procedure ShowOSK()
*+               Static Procedure DoTouchEnter()
*+               Static Function FindAndCloseProcress()
*+               Static Function ChangeFAttr()
*+               Static Procedure Slideshow()
*+               Static Procedure SetLV_View()
*+               Procedure MarkFromThumbs()
*+               Static Procedure DoDevice()
*+               Static Procedure DoReverseMark()
*+               Static Function NetConnect()
*+               Static Function NetDisconnect()
*+               Function WatchDirLeft()
*+               Function WatchDirRight()
*+               Static Procedure RefreshDirLeft()
*+               Static Procedure RefreshDirRight()
*+               Function onDummy()
*+               Static Function About()
*+               Function GetControls()
*+               Procedure SetCursorOnControls()
*+               Procedure SetCursorWait()
*+               Procedure SetGridWait()
*+               Procedure SetCHild()
*+               Static Function HL_IsFolderExist()
*+               Static Procedure ChangeFolder()
*+               Static Procedure DoFolderSize()
*+
*+       Tables: USE (cFile) VIA "DBFCDX" NEW EXCLUSIVE
*+
*+    Reformatted by Click! 2.05.34 on Sep-28-2020 at  3:25 am
*+
*+--------------------------------------------------------------------

#include "HMG.CH"
#include "hbthread.ch"
#include "hbdyn.ch"
#include "hbgtinfo.ch"

#include "Directry.ch"
#include "common.ch"
#include "Shell32.ch"
#include "fileio.ch"
#include "dll.ch"
#include "Dbstruct.ch"

#include "HBFM.CH"

#define Use_FreeImage .T.
#IFDEF Use_FreeImage
#include "freeimage.ch"
#ENDIF

//  #define Use_Thread .T.

#define KEYEVENTF_KEYUP    0x0002

#define RESOURCETYPE_ANY   0
#define RESOURCETYPE_DISK  1
#define RESOURCETYPE_PRINT 2

#define INFINITE        0xFFFFFFFF

// WaitForSingleObject() returns value
#define WAIT_TIMEOUT    0x00000102
#define WAIT_ABANDONED  0x00000080
//  #define WAIT_OBJECT_0   0x00000000
#define WAIT_OBJECT_1   ( WAIT_OBJECT_0 + 1 )

#xtranslate bor            => hb_BitOr

#xtranslate aDir_Left      => Stack_Left\[nDimLeft, 1]
#xtranslate cGrid_Left     => Stack_Left\[nDimLeft, 2]
#xtranslate aColor_Left    => Stack_Left\[nDimLeft, 3]
#xtranslate aImage_Left    => Stack_Left\[nDimLeft, 4]
#xtranslate aFiles_Left    => Stack_Left\[nDimLeft, 5]

#xtranslate aDir_Right     => Stack_Right\[nDimRight, 1]
#xtranslate cGrid_Right    => Stack_Right\[nDimRight, 2]
#xtranslate aColor_Right   => Stack_Right\[nDimRight, 3]
#xtranslate aImage_Right   => Stack_Right\[nDimRight, 4]
#xtranslate aFiles_Right   => Stack_Right\[nDimRight, 5]

STATIC nLastUP       := 0
STATIC nLastDN       := 0
STATIC caItems       := {}                                            // for ComboBox
STATIC acImage       := {}                                            // Image Combobox
STATIC aBack_Left    := {}
STATIC aBack_Right   := {}
STATIC aMore         := {}
STATIC aGetVKkeys
STATIC aDrives
STATIC nMainThreadID
STATIC lFromKeyBoard := .F.
STATIC nLastView     := LVS_REPORT
STATIC lDebug        := .F.

MEMVAR aWin
MEMVAR Stack_Left
MEMVAR Stack_Right
MEMVAR nDimLeft
MEMVAR nDimRight
MEMVAR aDirTemp
MEMVAR lActiveMain
MEMVAR aThread
MEMVAR aSHThread
MEMVAR aBroThread
MEMVAR aWatchThread
MEMVAR aSysIcons
MEMVAR nGridFocus
MEMVAR _HMG_SYSDATA

MEMVAR aForeColorHBP, aBackColorHBP, aFontTypeHBP

*+--------------------------------------------------------------------
*+
*+    Procedure DualGrid()
*+
*+    Called from ( hbfm.prg )   1 - function main()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE DualGrid( aPos, aSize, cVersion, luseParameter )            // from main()

LOCAL nPBwide    := INT( aSize[ 1 ] / 11 )
LOCAL nPBheigh   := 40
LOCAL nIndex
LOCAL cLogic
LOCAL cDir       := CURDIR()
LOCAL cAppFolder := AppFolder()

PUBLIC aWin         := {}                                             // hold all Window
PUBLIC Stack_Left   := {}                                             // Array Tab / Grid left
PUBLIC Stack_Right  := {}                                             // Array Tab / Grid right
PUBLIC nDimLeft     := 0                                              // Layer in 2-DIM Array left
PUBLIC nDimRight    := 0                                              // Layer in 2-DIM Array right
PUBLIC aDirTemp                                                       // temporary for new Tab
PUBLIC lActiveMain  := .T.                                            //
PUBLIC aThread      := { NIL }                                        // Thread USB-Detect
PUBLIC aSHThread    := {}                                             // Array for SH-File Operation
PUBLIC aBroThread   := { nil, nil }                                   // unused
PUBLIC aWatchThread := { nil, nil }
PUBLIC aSysIcons    := {}
PUBLIC nGridFocus   := 1                                              // 1=left, 2=right

PUBLIC aForeColorHBP
PUBLIC aBackColorHBP
PUBLIC aFontTypeHBP

#IFDEF Use_FreeImage
   IF FILE( 'FreeImage.Dll' ) .OR. FILE( 'FreeImage64.Dll' )
      FREE_Initialise()
      //  MsgInfo( Var2char( FREE_GetVersion() ) )
   ELSE
      MsgInfo( "Can't found the FreeImage.Dll" )
   ENDIF
#ENDIF

   SP_cMainPath( cAppFolder )

   aForeColorHBP := SP_nColor12()
   aBackColorHBP := SP_nColor9()
   aFontTypeHBP := ARRAY FONT SP_cFontName() SIZE SP_nFontSize() BOLD ITALIC

   SET FONT TO SP_cFontName(), SP_nFontSize()

   // Image Combobox
   AADD( acImage, "MYUNKNOWN16" )
   AADD( acImage, "MYFIXDRIVE16" )
   AADD( acImage, "MYUSBSTICK16" )
   AADD( acImage, "MYSYSDRIVE16" )
   AADD( acImage, "MYFIXDRIVE16" )
   AADD( acImage, "MYNETDRIVE16" )
   AADD( acImage, "MYCDROM16" )
   AADD( acImage, "MYRAMDISK16" )

   AADD( Stack_Left, ARRAY( 5 ) )
   nDimLeft := LEN( Stack_Left )
   cGrid_Left := "Grid_1"
   aColor_Left := {}
   aImage_Left := {}
   aFiles_Left := {}

   AADD( Stack_Right, ARRAY( 5 ) )
   nDimRight := LEN( Stack_Right )
   cGrid_Right := "Grid_1"
   aColor_Right := {}
   aImage_Right := {}
   aFiles_Right := {}

   aDir_Left := DIRECTORY( "*.*", "DHS" )
   aDir_Right := DIRECTORY( "*.*", "DHS" )
   IF SP_UseImage() = .T.
      aFiles_Left := BT_DirectoryInfo( cAppFolder, BT_DIRECTORYINFO_LISTALL )
      aFiles_Right := BT_DirectoryInfo( cAppFolder, BT_DIRECTORYINFO_LISTALL )
   ENDIF
   AADD( aWin, { "WinLeft", "Grid_1", SP_LWTextLeft(), 1, 1, F_NAME, .F. } )
   AADD( aWin, { "WinRight", "Grid_1", SP_LWTextRight(), 1, 1, F_NAME, .F. } )

   IF lDebug = .T.
      SET ALTER TO ( "_LOGIT2.TXT" )
   ENDIF

   FillCombo()

   aGetVKkeys := GetVKkeys()

   cLogic := IF( luseParameter, "1", "0" )

   DEFINE WINDOW Win_1 ;
      AT aPos[ 1 ], aPos[ 2 ] ;
      WIDTH aSize[ 1 ] HEIGHT aSize[ 2 ] ;
      TITLE 'HBFM ' + cVersion ;
      ICON "A1MAIN" ;
      MAIN ;
      VISIBLE .F. ;
      BACKCOLOR SP_nColor1() ;
      ON MAXIMIZE DoReSizeMain( ThisWindow.Name ) ;
      ON SIZE DoReSizeMain( ThisWindow.Name ) ;
      ON RELEASE SaveSetup( luseParameter ) ;
      ON LOSTFOCUS Readydrag( ThisWindow.Name ) ;
      ON GOTFOCUS WinTans( ThisWindow.Name, .T. ) ;
      ON PAINT Paint_Main_Background_Window( ThisWindow.Name ) ;
      ON INIT CreateScreenSplash( "Fill1StGrid('" + cLogic + "')" )

   ON KEY TAB ACTION IF( HMG_VirtualKeyIsPressed( VK_CONTROL ),, TestTabKey() )

   ON KEY ALT + F1 ACTION OpenCombo( "LEFT", "KEY" )
   ON KEY ALT + F2 ACTION OpenCombo( "RIGHT", "KEY" )
   ON KEY ALT + F7 ACTION IF( HMG_VirtualKeyIsPressed( VK_ALT ), SearchForm( nGridFocus ), )
   ON KEY ALT + F10 ACTION SelFolder( 1 )

   ON KEY CONTROL + F1 ACTION GodMode()

   ON KEY CONTROL + C ACTION IF( lActiveMain = .T., CopyClipboard(), )
   ON KEY CONTROL + E ACTION HBEJECT()
   ON KEY CONTROL + R ACTION ReRead( nGridFocus )
   ON KEY CONTROL + S ACTION FMSETUP()
   ON KEY CONTROL + T ACTION IF( lActiveMain = .T., NewTab(), )
   ON KEY CONTROL + U ACTION IF( lActiveMain = .T., ChangeLeftRight(), )
   // ON KEY CONTROL + W ACTION IF( lActiveMain = .T., CloseTab( nGridFocus ) , )

   ON KEY CONTROL + F4 ACTION IF( nGridFocus = 1, HeadLeft( F_NAME ), HeadRight( F_NAME ) )
   ON KEY CONTROL + F5 ACTION IF( nGridFocus = 1, HeadLeft( F_DATE ), HeadRight( F_DATE ) )
   ON KEY CONTROL + F6 ACTION IF( nGridFocus = 1, HeadLeft( F_SIZE ), HeadRight( F_SIZE ) )
   ON KEY CONTROL + F7 ACTION IF( nGridFocus = 1, HeadLeft( 0 ), HeadRight( 0 ) )
   ON KEY CONTROL + F8 ACTION SelFolder( 2 )
   ON KEY CONTROL + BACK ACTION ShowHistory()

   ON KEY SHIFT + F2 ACTION IF( lActiveMain = .T., CompareDir(), )
   ON KEY SHIFT + F3 ACTION Slideshow()
   ON KEY SHIFT + F4 ACTION CreateNewDbf()

   ON KEY F1 ACTION IF( HMG_VirtualKeyIsPressed( VK_ALT ) .OR. HMG_VirtualKeyIsPressed( VK_CONTROL ),, HelpFile() )
   ON KEY F2 ACTION PreFuncSysFolder()
   ON KEY F3 ACTION IF( HMG_VirtualKeyIsPressed( VK_ALT ) .OR. HMG_VirtualKeyIsPressed( VK_CONTROL ),, DataViewer( .F. ) )
   ON KEY F4 ACTION IF( HMG_VirtualKeyIsPressed( VK_ALT ) .OR. HMG_VirtualKeyIsPressed( VK_CONTROL ),, DataViewer( .T. ) )

   ON KEY F5 ACTION IF( lActiveMain = .T. .AND. .NOT. HMG_VirtualKeyIsPressed( VK_CONTROL ), ASKFORM( "COPY" ), )
   ON KEY F6 ACTION IF( lActiveMain = .T. .AND. .NOT. HMG_VirtualKeyIsPressed( VK_CONTROL ), ASKFORM( "MOVE" ), )
   ON KEY F7 ACTION IF( lActiveMain = .T. .AND. .NOT. ( HMG_VirtualKeyIsPressed( VK_CONTROL ) .OR. HMG_VirtualKeyIsPressed( VK_ALT ) ), CreateNewFolder(), )
   ON KEY F8 ACTION IF( lActiveMain = .T. .AND. .NOT. HMG_VirtualKeyIsPressed( VK_CONTROL ), ASKFORM( "DELETE" ), )
   ON KEY F9 ACTION ShowHistory()

   ON KEY DELETE ACTION IF( lActiveMain = .T. .AND. .NOT. HMG_VirtualKeyIsPressed( VK_CONTROL ), ASKFORM( "DELETE" ), )

   // ON KEY F10 ACTION Test()

   ON KEY F11 ACTION PreFuncMSCFolder()

   DEFINE STATUSBAR PARENT Win_1
STATUSITEM "Hello" WIDTH aSize[ 1 ] - 300
      KEYBOARD WIDTH 100
      DATE WIDTH 100
      CLOCK WIDTH 100
   END STATUSBAR

   DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 50, 50 FLAT

      BUTTON MYRELOAD ;
              TOOLTIP 'reload Crtl-R' ;
              PICTURE "MYRELOAD" ;
              ACTION ReRead( nGridFocus )

      BUTTON MYCOMPARE ;
              TOOLTIP 'Compare left/right Shift-F2' ;
              PICTURE 'MYCOMPARE' ;
              ACTION CompareDir()

      BUTTON MYHISTORY ;
              TOOLTIP 'F9 List of last visit Folder' ;
              PICTURE "MYHISTORY" ;
              ACTION ShowHistory()

      BUTTON MYTHUMBS ;
              TOOLTIP 'Shift-F3 : Slideshow or Thumbs (9999)' ;
              PICTURE "MYTHUMB32" ;
              ACTION Slideshow()

      BUTTON MYCLIPBOARD ;
              TOOLTIP 'To Clipboard Crtl-C' ;
              PICTURE 'MYCLIPBOARD' ;
              ACTION CopyClipboard()

      BUTTON MYCONFIG ;
              TOOLTIP 'Setup Crtl-S' ;
              PICTURE 'MYCONFIG' ;
              SEPARATOR ;
              ACTION FMSETUP()

      BUTTON MYDUMMY1 ;
              SEPARATOR ;
              ACTION NIL

      BUTTON MYEJECTUSB ;
              TOOLTIP 'Eject USB Crtl-E' ;
              PICTURE 'MYEJECTUSB' ;
              ACTION HBEJECT()

      BUTTON MYDEVICE ;
              TOOLTIP 'Device SmartPhone' ;
              PICTURE "MYPHONE" ;
              SEPARATOR ;
              ACTION DoDevice()

      BUTTON MYDUMMY2 ;
              SEPARATOR ;
              ACTION NIL

      BUTTON MYOSK ;
              TOOLTIP 'On Screen Keyboard' ;
              PICTURE "MYKEYBOARD" ;
              ACTION ShowOSK()

      BUTTON MYENTER ;
              TOOLTIP 'ENTER for Touch-Screen' ;
              PICTURE "MYFINGER" ;
              SEPARATOR ;
              ACTION DoTouchEnter()

      BUTTON MYDUMMY3 ;
              SEPARATOR ;
              ACTION NIL

      BUTTON MYCONNECT ;
              TOOLTIP 'connect to Network' ;
              PICTURE 'MYCONNECT' ;
              ACTION NetConnect()

      BUTTON MYDISCONNECT ;
              TOOLTIP 'disconnect from Network' ;
              PICTURE 'MYDISCONNECT' ;
              SEPARATOR ;
              ACTION NetDisconnect()

      BUTTON MYDUMMY4 ;
              SEPARATOR ;
              ACTION NIL

      BUTTON MYFTP ;
              TOOLTIP 'FTP transfer' ;
              PICTURE 'MYFTP32' ;
              ACTION HbFTP(, cAppFolder )

      BUTTON MYFTPConnect1 ;
              ACTION NIL
      BUTTON MYFTPDisconnect1 ;
              ACTION NIL
      //          BUTTON MYMD_Remote ;
      //                  ACTION NIL
      //          BUTTON MYREN_Remote ;
      //                  ACTION NIL
      //          BUTTON MYDEL_Remote ;
      //                  SEPARATOR ;
      //                  ACTION NIL

      BUTTON MYDUMMY5 ;
              SEPARATOR ;
              ACTION NIL

      BUTTON MYREG ;
              TOOLTIP 'Registry Database' ;
              SEPARATOR ;
              PICTURE 'MYREG' ;
              ACTION RegDBForm()

      BUTTON MYEXIT ;
              TOOLTIP 'Exit' ;
              PICTURE "MYEXIT" ;
              ACTION Win_1.Release

   END TOOLBAR

   DEFINE MAIN MENU
      DEFINE POPUP "&Menu"
         MENUITEM "E&xit" IMAGE 'MYEXIT' ACTION Win_1.Release
      END POPUP

      DEFINE POPUP "&Device"
         MENUITEM "&Device" IMAGE "MYPHONE" ACTION DoDevice()
      END POPUP

      DEFINE POPUP "&Network"
         MENUITEM "&Connect" IMAGE "MYCONNECT" ACTION NetConnect()
         SEPARATOR
         MENUITEM "&DisConnect" IMAGE "MYDISCONNECT" ACTION NetDisconnect()
      END POPUP

      DEFINE POPUP "&About"
         MENUITEM "&About" ACTION About()
         SEPARATOR
         MENUITEM "&Mail to author..." ;
                 ACTION ShellExecute( 0, "open", "rundll32.exe", ;
                 "url.dll,FileProtocolHandler " + ;
                 "mailto:Auge_Ohr@Web.DE" + ;
                 "&subject=HBFM%20" + cVersion + "%20Feedback:" + ;
                 "&body=Hello%20World",, 1 )

      END POPUP

   END MENU

   nPBwide := INT( aSize[ 1 ] / 11 )

   DEFINE BUTTON Button_F1
      PARENT Win_1
      ROW 890
      COL 0
      WIDTH nPBwide - 2
      HEIGHT nPBheigh
      ACTION HelpFile()
      CAPTION "F1"
      FONTNAME SP_cFontName()
      FONTSIZE SP_nFontSize()
      TOOLTIP ""
      TABSTOP .F.
      VISIBLE .T.
      TRANSPARENT .F.
      MULTILINE .F.
   END BUTTON

   DEFINE BUTTON Button_F2
      PARENT Win_1
      ROW 890
      COL nPBwide * 1
      WIDTH nPBwide - 2
      HEIGHT nPBheigh
      ACTION PreFuncSysFolder()
      CAPTION "F2 SysFolder"
      FONTNAME SP_cFontName()
      FONTSIZE SP_nFontSize()
      TABSTOP .F.
   END BUTTON

   DEFINE BUTTON Button_F3
      PARENT Win_1
      ROW 890
      COL nPBwide * 2
      WIDTH nPBwide - 2
      HEIGHT nPBheigh
      ACTION IF( HMG_VirtualKeyIsPressed( VK_SHIFT ), Slideshow(), DataViewer( .F. ) )
      CAPTION "F3 Viewer"
      FONTNAME SP_cFontName()
      FONTSIZE SP_nFontSize()
      TABSTOP .F.
   END BUTTON

   DEFINE BUTTON Button_F4
      PARENT Win_1
      ROW 890
      COL nPBwide * 3
      WIDTH nPBwide - 2
      HEIGHT nPBheigh
      ACTION IF( HMG_VirtualKeyIsPressed( VK_SHIFT ), CreateNewDbf(), DataViewer( .T. ) )
      CAPTION "F4 edit DBF"
      FONTNAME SP_cFontName()
      FONTSIZE SP_nFontSize()
      TABSTOP .F.
   END BUTTON

   DEFINE BUTTON Button_F5
      PARENT Win_1
      ROW 890
      COL nPBwide * 4
      WIDTH nPBwide - 2
      HEIGHT nPBheigh
      ACTION IF( lActiveMain = .T., ASKFORM( "COPY" ), )
      CAPTION "F5 Copy"
      FONTNAME SP_cFontName()
      FONTSIZE SP_nFontSize()
      TABSTOP .F.
   END BUTTON

   DEFINE BUTTON Button_F6
      PARENT Win_1
      ROW 890
      COL nPBwide * 5
      WIDTH nPBwide - 2
      HEIGHT nPBheigh
      ACTION IF( lActiveMain = .T., ASKFORM( "MOVE" ), )
      CAPTION "F6 move"
      FONTNAME SP_cFontName()
      FONTSIZE SP_nFontSize()
      TABSTOP .F.
   END BUTTON

   DEFINE BUTTON Button_F7
      PARENT Win_1
      ROW 890
      COL nPBwide * 6
      WIDTH nPBwide - 2
      HEIGHT nPBheigh
      ACTION IF( lActiveMain = .T., CreateNewFolder(), )
      CAPTION "F7 New Folder"
      FONTNAME SP_cFontName()
      FONTSIZE SP_nFontSize()
      TABSTOP .F.
   END BUTTON

   DEFINE BUTTON Button_F8
      PARENT Win_1
      ROW 890
      COL nPBwide * 7
      WIDTH nPBwide - 2
      HEIGHT nPBheigh
      ACTION IF( lActiveMain = .T., ASKFORM( "DELETE" ), )
      CAPTION "F8 Delete"
      FONTNAME SP_cFontName()
      FONTSIZE SP_nFontSize()
      TABSTOP .F.
   END BUTTON

   DEFINE BUTTON Button_F9
      PARENT Win_1
      ROW 890
      COL nPBwide * 8
      WIDTH nPBwide - 2
      HEIGHT nPBheigh
      ACTION ShowHistory()
      CAPTION "F9 History"
      FONTNAME SP_cFontName()
      FONTSIZE SP_nFontSize()
      TABSTOP .F.
   END BUTTON

   DEFINE BUTTON Button_F10
      PARENT Win_1
      ROW 890
      COL nPBwide * 9
      WIDTH nPBwide - 2
      HEIGHT nPBheigh
      ACTION MsgInfo( "under construction ..." )
      CAPTION "F10"
      FONTNAME SP_cFontName()
      FONTSIZE SP_nFontSize()
      TABSTOP .F.
   END BUTTON

   DEFINE BUTTON Button_F11
      PARENT Win_1
      ROW 890
      COL nPBwide * 10
      WIDTH nPBwide - 2
      HEIGHT nPBheigh
      ACTION PreFuncMSCFolder()
      CAPTION "F11 MSCFolder"
      FONTNAME SP_cFontName()
      FONTSIZE SP_nFontSize()
      TABSTOP .F.
   END BUTTON

   // DEFINE BUTTON Button_F12
   //    PARENT Win_1
   //    ROW 890
   //    COL nPBwide * 11
   //    WIDTH nPBwide - 2
   //    HEIGHT nPBheigh
   //    ACTION MsgInfo( "under construction ..." )
   //    CAPTION "F12"
   //    TABSTOP .F.
   // END BUTTON

   DEFINE TEXTBOX PathInfo
      PARENT Win_1
      ROW 890 - 30
      COL 0
      WIDTH 630
      HEIGHT 30
      FONTNAME SP_cFontName()
      FONTSIZE SP_nFontSize()
      TOOLTIP ""
      ONCHANGE Nil
      ONGOTFOCUS Nil
      ONLOSTFOCUS Nil
      ONENTER ChangeFolder()
      TABSTOP .F.
      VISIBLE .T.
      READONLY .F.
      RIGHTALIGN .T.
      DISABLEDBACKCOLOR Nil
      DISABLEDFONTCOLOR Nil
      CASECONVERT NONE
      BACKCOLOR SP_nColor1()
      FONTCOLOR SP_nColor2()
      INPUTMASK Nil
      FORMAT Nil
      VALUE GetVolumne( "C" ) + " " + STR( HB_DISKSPACE( "C:" ) / 1024 / 1000 / 1000 ) + " Mb free of " + LTRIM( STR( HB_DISKSPACE( "C:", HB_DISK_TOTAL ) / 1024 / 1000 / 1000 ) ) + " Mb"
   END TEXTBOX

   DEFINE TEXTBOX CMDBox
      PARENT Win_1
      ROW 890 - 30
      COL 630
      WIDTH 630
      HEIGHT 30
      FONTNAME SP_cFontName()
      FONTSIZE SP_nFontSize()
      TOOLTIP ""
      ONCHANGE Nil
      ONGOTFOCUS ReleaseDelKey( 1 )
      ONLOSTFOCUS ReleaseDelKey( 2 )
      ONENTER RunCMDBox()
      TABSTOP .F.
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

   DEFINE WINDOW WinLeft ;
      PARENT Win_1 ;
      AT 50, 0 ;
      WIDTH 630 HEIGHT 810 ;
      PANEL ;
      NOCAPTION ;
      BACKCOLOR SP_nColor1() ;
      ON PAINT Paint_Background_Window( ThisWindow.Name, 1 )

   /* ON MOUSEMOVE IF( lActiveMain = .T., DragMove( ThisWindow.Name ), nil ) ; */
   /* ON MOUSEDRAG IF( lActiveMain = .T., DragHere( ThisWindow.Name ), nil ) ; */

   DEFINE CONTEXT MENU OF WinLeft
      MENUITEM "Close Tab Left" IMAGE 'MYEXIT16' ACTION CloseTab( 1 )
      SEPARATOR
      MENUITEM "sort Name" IMAGE 'MYNAME16' ACTION HeadLeft( F_NAME )
      MENUITEM "sort Size" IMAGE 'MYSIZE16' ACTION HeadLeft( F_DATE )
      MENUITEM "sort Date" IMAGE 'MYDATE16' ACTION HeadLeft( F_SIZE )
      MENUITEM "un-sort  " IMAGE 'MYTYPE16' ACTION HeadLeft( 0 )
      SEPARATOR
      MENUITEM "Icon Style" ACTION SetLV_View( 1, LV_VIEW_ICON )
      MENUITEM "Report Style" ACTION SetLV_View( 1, LV_VIEW_DETAILS )
      MENUITEM "small Icon" ACTION SetLV_View( 1, LV_VIEW_SMALLICON )
      MENUITEM "simple List" ACTION SetLV_View( 1, LV_VIEW_LIST )
      // MENUITEM "tile Style"   ACTION SetLV_View( 1, LV_VIEW_TILE )
      // MENUITEM "max Style"    ACTION SetLV_View( 1, LV_VIEW_MAX )
      SEPARATOR
      MENUITEM "Slideshow / Thumbs" IMAGE "MYTHUMB16" ACTION Slideshow()
      SEPARATOR
      MENUITEM "Tree Left " IMAGE 'MYVIEWTREE16' ACTION SelFolder( 1 )
      MENUITEM "Tree Right" IMAGE 'MYSIDETREE16' ACTION SelFolder( 2 )
      SEPARATOR
      MENUITEM "Send to DeskTop" ACTION SendToDeskTop( 1 )
      MENUITEM "Send to Startup" ACTION SendToStartup( 1 )
      SEPARATOR
      MENUITEM "Attribut" IMAGE 'MYATTR16' ACTION ChangeFAttr( 1 )
      SEPARATOR
      MENUITEM "Property" IMAGE 'MYRAMDISK16' ACTION ShowProperty( 1 )
   END MENU

   DEFINE COMBOBOX ComboLeft
      PARENT WinLeft
      ROW 2
      COL 2
      WIDTH 60
      HEIGHT 500
      ITEMS caItems
      IMAGE acImage
      TABSTOP .F.
      DROPPEDWIDTH 150
      ON GOTFOCUS IF( lFromKeyBoard = .T., ComboboxShowList( GetControlHandle( "ComboLeft", "WinLeft" ) ), )
      OnCloseUp Change2Drive( This.Name )
   END COMBOBOX

   DEFINE LABEL VolInfo_Left
      PARENT WinLeft
      ROW 2
      COL 70
      VALUE GetVolumne( "C" ) + " " + STR( HB_DISKSPACE( "C:" ) / 1024 / 1000 / 1000 ) + " Mb free of " + LTRIM( STR( HB_DISKSPACE( "C:", HB_DISK_TOTAL ) / 1024 / 1000 / 1000 ) ) + " Mb"
      WIDTH 300
      HEIGHT 24
      FONTNAME SP_cFontName()
      FONTSIZE SP_nFontSize()
      BACKCOLOR SP_nColor1()
      FONTCOLOR SP_nColor2()
   END LABEL

   DEFINE BUTTON RootUp_Left
      PARENT WinLeft
      ROW 2
      COL 630 - 48
      WIDTH 24
      HEIGHT 24
      ACTION RootUpDirPath( 1 )
      CAPTION "\"
      TOOLTIP "change to Root"
      TABSTOP .F.
   END BUTTON

   DEFINE BUTTON DirUp_Left
      PARENT WinLeft
      ROW 2
      COL 630 - 24
      WIDTH 24
      HEIGHT 24
      ACTION UpDirPath( 1 )
      TOOLTIP "change up Folder"
      CAPTION ".."
      TABSTOP .F.
   END BUTTON

   DEFINE LABEL TabStatus_Left
      PARENT WinLeft
      ROW 786
      COL 0
      VALUE "Status"
      WIDTH 626
      HEIGHT 24
      FONTNAME SP_cFontName()
      FONTSIZE SP_nFontSize()
      BACKCOLOR SP_nColor1()
      FONTCOLOR SP_nColor2()
   END LABEL

   DEFINE TAB Tab_Left ;
              OF WinLeft ;
              AT 30, 0 ;
              WIDTH 630 HEIGHT 746 ;
              VALUE 1 ;
              FONT SP_cFontName() SIZE SP_nFontSize() ;
              TOOLTIP "" ;
              Hottrack ;
              ON CHANGE Tab_Change_Left()

      DEFINE PAGE "Page 1" IMAGE "MYFIXDRIVE16"
         DefGridLeft( "WinLeft", "Grid_1", 1 )
      END PAGE
   END TAB

   END WINDOW

   DEFINE WINDOW WinRight ;
      PARENT Win_1 ;
      AT 50, aSize[ 1 ] / 2 ;
      WIDTH 630 HEIGHT 810 ;
      PANEL ;
      NOCAPTION ;
      BACKCOLOR SP_nColor1() ;
      ON PAINT Paint_Background_Window( ThisWindow.Name, 2 )

   /* ON MOUSEMOVE IF( lActiveMain = .T., DragMove( ThisWindow.Name ), nil ) ; */
   /* ON MOUSEDRAG IF( lActiveMain = .T., DragHere( ThisWindow.Name ), nil ) ; */

   DEFINE CONTEXT MENU OF WinRight
      MENUITEM "Close Tab Right" IMAGE "MYEXIT16" ACTION CloseTab( 2 )
      SEPARATOR
      MENUITEM "sort Name" IMAGE 'MYNAME16' ACTION HeadRight( F_NAME )
      MENUITEM "sort Size" IMAGE 'MYSIZE16' ACTION HeadRight( F_DATE )
      MENUITEM "sort Date" IMAGE 'MYDATE16' ACTION HeadRight( F_SIZE )
      MENUITEM "un-sort  " IMAGE 'MYTYPE16' ACTION HeadRight( 0 )
      SEPARATOR
      MENUITEM "Icon Style" ACTION SetLV_View( 2, LV_VIEW_ICON )
      MENUITEM "Report Style" ACTION SetLV_View( 2, LV_VIEW_DETAILS )
      MENUITEM "small Icon" ACTION SetLV_View( 2, LV_VIEW_SMALLICON )
      MENUITEM "simple List" ACTION SetLV_View( 2, LV_VIEW_LIST )
      // MENUITEM "tile Style"   ACTION SetLV_View( 2, LV_VIEW_TILE )
      // MENUITEM "max Style"    ACTION SetLV_View( 2, LV_VIEW_MAX )
      SEPARATOR
      MENUITEM "Slideshow / Thumbs" IMAGE "MYTHUMB16" ACTION Slideshow()
      SEPARATOR
      MENUITEM "Tree Left " IMAGE 'MYVIEWTREE16' ACTION SelFolder( 2 )
      MENUITEM "Tree Right" IMAGE 'MYSIDETREE16' ACTION SelFolder( 1 )
      SEPARATOR
      MENUITEM "Send to DeskTop" ACTION SendToDeskTop( 2 )
      MENUITEM "Send to Startup" ACTION SendToStartup( 2 )
      SEPARATOR
      MENUITEM "Attribut" IMAGE 'MYATTR16' ACTION ChangeFAttr( 2 )
      SEPARATOR
      MENUITEM "Property" IMAGE 'MYRAMDISK16' ACTION ShowProperty( 2 )
   END MENU

   DEFINE COMBOBOX ComboRight
      PARENT WinRight
      ROW 2
      COL 2
      WIDTH 60
      HEIGHT 500
      ITEMS caItems
      IMAGE acImage
      TABSTOP .F.
      DROPPEDWIDTH 150
      ON GOTFOCUS IF( lFromKeyBoard = .T., ComboboxShowList( GetControlHandle( "ComboRight", "WinRight" ) ), )
      OnCloseUp Change2Drive( This.Name )
   END COMBOBOX

   DEFINE LABEL VolInfo_Right
      PARENT WinRight
      ROW 2
      COL 70
      VALUE GetVolumne( "C" ) + " " + STR( HB_DISKSPACE( "C:" ) / 1024 / 1000 / 1000 ) + " Mb free of " + LTRIM( STR( HB_DISKSPACE( "C:", HB_DISK_TOTAL ) / 1024 / 1000 / 1000 ) ) + " Mb"
      WIDTH 300
      HEIGHT 24
      FONTNAME SP_cFontName()
      FONTSIZE SP_nFontSize()
      BACKCOLOR SP_nColor1()
      FONTCOLOR SP_nColor2()
   END LABEL

   DEFINE BUTTON DirUp_Right
      PARENT WinRight
      ROW 2
      COL 630 - 68
      WIDTH 24
      HEIGHT 24
      ACTION UpDirPath( 2 )
      TOOLTIP "change up Folder"
      CAPTION ".."
      TABSTOP .F.
   END BUTTON

   DEFINE BUTTON RootUp_Right
      PARENT WinRight
      ROW 2
      COL 630 - 44
      WIDTH 24
      HEIGHT 24
      ACTION RootUpDirPath( 2 )
      TOOLTIP "change to Root"
      CAPTION "\"
      TABSTOP .F.
   END BUTTON

   DEFINE LABEL TabStatus_Right
      PARENT WinRight
      ROW 786
      COL 0
      VALUE "Status"
      WIDTH 626
      HEIGHT 24
      FONTNAME SP_cFontName()
      FONTSIZE SP_nFontSize()
      BACKCOLOR SP_nColor1()
      FONTCOLOR SP_nColor2()
   END LABEL

   DEFINE TAB Tab_Right ;
              OF WinRight ;
              AT 30, 0 ;
              WIDTH 630 HEIGHT 746 ;
              VALUE 1 ;
              FONT SP_cFontName() SIZE SP_nFontSize() ;
              TOOLTIP "" ;
              Hottrack ;
              ON CHANGE Tab_Change_Right()

      DEFINE PAGE "Page 1" IMAGE "MYFIXDRIVE16"
         DefGridRight( "WinRight", "Grid_1", 1 )
      END PAGE
   END TAB
   END WINDOW

   END WINDOW

   DoComboImage()

   IF EMPTY( aPos[ 1 ] ) .AND. EMPTY( aPos[ 2 ] )
      CENTER WINDOW Win_1
   ENDIF

#IFDEF Use_Thread

   nMainThreadID := GetCurrentThreadID()
   HMG_ThreadShareData( 1, Win_1.HANDLE )

   aThread[ 1 ] := hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @Wait4Action() )
   // aThread[ 2 ] := hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @DoNothing() )

   AttachThreadInput( nMainThreadID, HMG_ThreadHBtoWinID( aThread[ 1 ] ), .T. )
   // AttachThreadInput( nMainThreadID, HMG_ThreadHBtoWinID( aThread[ 2 ] ), .T. )

   CREATE EVENT PROCNAME USB_Detect() HWND Win_1.HANDLE STOREINDEX nIndex
   EventProcessAllHookMessage( nIndex, .T. )

   // accept Files drag from Explorer
   DragAcceptFiles( Win_1.HANDLE, .t. )

#ENDIF

   SP_lPbarRunning( .F. )

   SP_lDirWatch( .T. )
   ACTIVATE WINDOW Win_1

RETURN

*+--------------------------------------------------------------------
*+
*+    Function MoreParaLeft()
*+
*+    Called from ( hbfm.prg )   1 - function main()
*+
*+--------------------------------------------------------------------
*+
FUNCTION MoreParaLeft( cPara )                                        // from main()

LOCAL nPosi := 1
LOCAL cRest := ""
LOCAL cPart := ""
LOCAL cRet  := ""

   nPosi := AT( "#", cPara )
   IF nPosi > 0
      cRet := SUBSTR( cPara, 1, nPosi - 1 )
      cRest := SUBSTR( cPara, nPosi + 1 )
      DO WHILE nPosi <> 0
         nPosi := AT( "#", cRest )
         IF nPosi > 0
            cPart := SUBSTR( cRest, 1, nPosi - 1 )
            AADD( aMore, { "LEFT", cPart } )

            cRest := SUBSTR( cRest, nPosi + 1 )
         ELSE
            IF !EMPTY( cRest )
               AADD( aMore, { "LEFT", cRest } )
            ENDIF
            EXIT
         ENDIF
      ENDDO
      SP_LWTextLeft( cRet )
   ENDIF

RETURN cRet

*+--------------------------------------------------------------------
*+
*+    Function MoreParaRight()
*+
*+    Called from ( hbfm.prg )   1 - function main()
*+
*+--------------------------------------------------------------------
*+
FUNCTION MoreParaRight( cPara )                                       // from main()

LOCAL nPosi := 1
LOCAL cRest := ""
LOCAL cPart := ""
LOCAL cRet  := ""

   nPosi := AT( "#", cPara )
   IF nPosi > 0
      cRet := SUBSTR( cPara, 1, nPosi - 1 )
      cRest := SUBSTR( cPara, nPosi + 1 )
      DO WHILE nPosi <> 0
         nPosi := AT( "#", cRest )
         IF nPosi > 0
            cPart := SUBSTR( cRest, 1, nPosi - 1 )
            AADD( aMore, { "RIGHT", cPart } )

            cRest := SUBSTR( cRest, nPosi + 1 )
         ELSE
            IF !EMPTY( cRest )
               AADD( aMore, { "RIGHT", cRest } )
            ENDIF
            EXIT
         ENDIF
      ENDDO
      SP_LWTextRight( cRet )
   ENDIF

RETURN cRet

*+--------------------------------------------------------------------
*+
*+    Procedure Fill1StGrid()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE Fill1StGrid( cParameter )

LOCAL nDrive
LOCAL hWnd, hTabWnd
LOCAL hGrid

   DEFAULT cParameter TO "0"

   nDrive := ASCAN( aDrives, { | e | e[ 2 ] = SUBSTR( SP_LWTextLeft(), 1, 1 ) } )
   WinLeft.ComboLeft.Value := nDrive

   nDrive := ASCAN( aDrives, { | e | e[ 2 ] = SUBSTR( SP_LWTextRight(), 1, 1 ) } )
   WinRight.ComboRight.Value := nDrive

   cGrid_Left := "Grid_1"
   cGrid_Right := "Grid_1"

   FillWithDir( "WinLeft", cGrid_Left, SP_LWTextLeft(), "TREEDN" )
   FillWithDir( "WinRight", cGrid_Right, SP_LWTextRight(), "TREEDN" )

   IF SP_DarkMode()
      // main
      hWnd := GetFormHandle( "Win_1" )
      SetWindowTheme( hWnd, 0, 0 )

      // left
      hWnd := GetFormHandle( "WinLeft" )
      SetWindowTheme( hWnd, 0, 0 )

      hTabWnd := WinLeft.Tab_Left.handle
      SetWindowTheme( hTabWnd, 0, 0 )

      // right
      hWnd := GetFormHandle( "WinRight" )
      SetWindowTheme( hWnd, 0, 0 )

      hTabWnd := WinRight.Tab_Right.handle
      SetWindowTheme( hTabWnd, 0, 0 )

   ENDIF

   IF cParameter = "1"
      RunWithParameter()
   ELSE
      RestoreTab()
   ENDIF

   DoReSizeMain( "Win_1" )

   StopSplash()                                                       // in THUMBS.PRG
   Domethod( "Win_1", "show" )

   Domethod( "Win_1", "SetFocus" )
   SetGridWait( .F. )

   // **********************************************************
   //  Domethod( "WinLeft" ,"Tab_Left" , "SetFocus")
   //  Domethod( "WinLeft" , cGrid_Left ,  "SetFocus")
   //  hGrid := GetControlHandle( cGrid_Left , "WinLeft"  )
   //  ItemMark( hGrid, 1 )
   //
   //  Domethod( "WinRight","Tab_Right", "SetFocus")
   //  Domethod( "WinRight", cGrid_Right, "SetFocus")
   //  hGrid := GetControlHandle( cGrid_Right, "WinRight" )
   //  ItemMark( hGrid, 1 )
   //
   // **********************************************************

   Domethod( "WinLeft", "Tab_Left", nDimLeft, cGrid_Left, "SetFocus" )
   hGrid := GetControlHandle( cGrid_Left, "WinLeft" )
   ItemMark( hGrid, 1 )

   Domethod( "WinRight", "Tab_Right", nDimRight, cGrid_Right, "SetFocus" )
   hGrid := GetControlHandle( cGrid_Right, "WinRight" )
   ItemMark( hGrid, 1 )

   //    Keybd_Event( VK_TAB, .F. )                                         // KeyDown
   //    Keybd_Event( VK_TAB, .T. )                                         // KeyUp
   //    Keybd_Event( VK_TAB, .F. )                                         // KeyDown
   //    Keybd_Event( VK_TAB, .T. )                                         // KeyUp

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure FillCombo()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+                ( hbdevice.prg )   1 - procedure wait4action()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE FillCombo( lDelete )                                        // also wait4action()

LOCAL cDrive, cVolume, nDrive, nType, ico, i

   caItems := {}
   aDrives := GetDrives()

   FOR i := 1 TO LEN( aDrives )
      nType := aDrives[ i ] [ 1 ]
      cDrive := aDrives[ i ] [ 2 ]
      cVolume := aDrives[ i ] [ 3 ]

      DO CASE
         CASE nType = DRIVE_UNKNOWN
            AADD( caItems, { IM_UNKNOWN, cDrive + SPACE( 3 ) + cVolume } )
         CASE nType = DRIVE_NO_ROOT_DIR
            AADD( caItems, { IM_FIXDRIVE1, cDrive + SPACE( 3 ) + cVolume } )
         CASE nType = DRIVE_REMOVABLE
            AADD( caItems, { IM_USBSTICK, cDrive + SPACE( 3 ) + cVolume } )
         CASE nType = DRIVE_FIXED
            IF cDrive = "C"
               AADD( caItems, { IM_SYSDRIVE, cDrive + SPACE( 3 ) + cVolume } )
            ELSE
               AADD( caItems, { IM_FIXDRIVE, cDrive + SPACE( 3 ) + cVolume } )
            ENDIF
         CASE nType = DRIVE_REMOTE
            AADD( caItems, { IM_NETDRIVE, cDrive + SPACE( 3 ) + cVolume } )
         CASE nType = DRIVE_CDROM
            AADD( caItems, { IM_CDROM, cDrive + SPACE( 3 ) + cVolume } )
         CASE nType = DRIVE_RAMDISK
            AADD( caItems, { IM_RAMDISK, cDrive + SPACE( 3 ) + cVolume } )
         OTHERWISE
            AADD( caItems, { IM_UNKNOWN, cDrive + SPACE( 3 ) + cVolume } )
      ENDCASE
   NEXT

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure DoComboImage()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+                ( hbdevice.prg )   1 - procedure wait4action()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE DoComboImage( lRefresh )                                    // also wait4action()

LOCAL nStart, i, ii, iiMax, xVal, nDrive

   DEFAULT lRefresh TO .F.

   IF lRefresh = .T.
      Domethod( "WinLeft", "ComboLeft", "hide" )
      Domethod( "WinRight", "ComboRight", "hide" )

      Domethod( "WinLeft", "ComboLeft", "DeleteAllItems" )
      Domethod( "WinRight", "ComboRight", "DeleteAllItems" )

      iiMax := LEN( caItems )
      FOR ii := 1 TO iiMax
         xVal := caItems[ ii ]

         WinLeft.ComboLeft.AddItem( xVal )
         WinRight.ComboRight.AddItem( xVal )
      NEXT
   ENDIF

   nDrive := ASCAN( aDrives, { | e | e[ 2 ] = SUBSTR( SP_LWTextLeft(), 1, 1 ) } )
   SetProperty( "WinLeft", "ComboLeft", "VALUE", nDrive )

   nDrive := ASCAN( aDrives, { | e | e[ 2 ] = SUBSTR( SP_LWTextRight(), 1, 1 ) } )
   SetProperty( "WinRight", "ComboRight", "VALUE", nDrive )

   Domethod( "WinLeft", "ComboLeft", "show" )
   Domethod( "WinRight", "ComboRight", "show" )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DefGridLeft()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+                                   1 - static procedure newtab()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DefGridLeft( cForm, cObj, nDimStack )

LOCAL nRow, nCol, nHeight, hGrid

   IF nDimStack = 1
      nRow := 25
      nCol := 0
      nHeight := 730 - 6
   ELSE
      nRow := - 2
      nCol := 0
      nHeight := 730 - 6
   ENDIF

   @ nRow, nCol GRID &cObj ;
           PARENT &cForm ;
           WIDTH 626 ;
           HEIGHT nHeight ;
           HEADERS { 'Name', 'Size', 'Date', 'Time', 'Attr' } ;
           WIDTHS ACLONE( SP_aColLeft() ) ;                           // { 330, 80, 78, 64, 60 } ;
           VALUE { 1 } ;
           ITEMS aDir_Left ;
           ITEMCOUNT 100 ;                                            // LEN( aDir_Left ) ;
           FONT SP_cFontName() SIZE SP_nFontlarge() ;
           TOOLTIP "" ;
           BACKCOLOR SP_nColor9() ;
           FONTCOLOR SP_nColor10() ;
           DYNAMICBACKCOLOR Nil ;                                     //{bColor1,bColor1,bColor1,bColor1,bColor1} ;
           DYNAMICFORECOLOR Nil ;                                     //{bColor2,bColor2,bColor2,bColor2,bColor2} ;
           ON GOTFOCUS GridGotFocus( 1 ) ;
           ON LOSTFOCUS nil ;
           ON DBLCLICK Doit( ThisWindow.Name, This.Name ) ;
           ON HEADCLICK { { || HeadLeft( F_NAME ) }, { || HeadLeft( F_SIZE ) }, { || HeadLeft( F_DATE ) }, { || HeadLeft( F_TIME ) }, { || HeadLeft( F_ATTR ) } } ;
           ON CHANGE InfoGridChange1( aDir_Left, 1 ) ;
           MULTISELECT ;
           JUSTIFY { GRID_JTFY_LEFT, GRID_JTFY_RIGHT, GRID_JTFY_RIGHT, GRID_JTFY_LEFT, GRID_JTFY_LEFT } ;
           ON KEY DoGridKey1( cForm, cObj )

   SetProperty( cForm, cObj, "PaintDoubleBuffer", .T. )

   IF SP_UseImage() = .T.
      SetProperty( cForm, cObj, "ImageList", BT_ImageListGetSystemIcon() )
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DefGridRight()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+                                   1 - static procedure newtab()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DefGridRight( cForm, cObj, nDimStack )

LOCAL nRow, nCol, nHeight, hGrid

   IF nDimStack = 1
      nRow := 25
      nCol := 0
      nHeight := 730 - 6
   ELSE
      nRow := - 2
      nCol := 0
      nHeight := 730 - 6
   ENDIF

   @ nRow, nCol GRID &cObj ;
           PARENT &cForm ;
           WIDTH 626 ;
           HEIGHT nHeight ;
           HEADERS { 'Name', 'Size', 'Date', 'Time', 'Attr' } ;
           WIDTHS ACLONE( SP_aColRight() ) ;                          // { 330, 80, 78, 64, 60 } ;
           VALUE { 1 } ;
           ITEMS aDir_Right ;
           ITEMCOUNT 100 ;                                            //  LEN( aDir_Right ) ;
           FONT SP_cFontName() SIZE SP_nFontlarge() ;
           TOOLTIP "" ;
           BACKCOLOR SP_nColor9() ;
           FONTCOLOR SP_nColor10() ;
           DYNAMICBACKCOLOR nil ;                                     // {bColor1,bColor1,bColor1,bColor1,bColor1} ;
           DYNAMICFORECOLOR nil ;                                     // {bColor3,bColor3,bColor3,bColor3,bColor3} ;
           ON GOTFOCUS GridGotFocus( 2 ) ;
           ON CHANGE InfoGridChange2( aDir_Right, 2 ) ;
           ON LOSTFOCUS nil ;
           ON DBLCLICK Doit( ThisWindow.Name, This.Name ) ;
           ON HEADCLICK { { || HeadRight( F_NAME ) }, { || HeadRight( F_SIZE ) }, { || HeadRight( F_DATE ) }, { || HeadRight( F_TIME ) }, { || HeadRight( F_ATTR ) } } ;
           MULTISELECT ;
           JUSTIFY { GRID_JTFY_LEFT, GRID_JTFY_RIGHT, GRID_JTFY_RIGHT, GRID_JTFY_LEFT, GRID_JTFY_LEFT } ;
           ON KEY DoGridKey2( cForm, cObj )

   SetProperty( cForm, cObj, "PaintDoubleBuffer", .T. )

   IF SP_UseImage() = .T.
      SetProperty( cForm, cObj, "ImageList", BT_ImageListGetSystemIcon() )
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure DoSHfunc()
*+
*+    Called from ( askform.prg )   1 - static procedure start_shfunc()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE DoSHfunc( cAction, lConfirm, lPaperbin, lAdjustTime )

LOCAL nLen

#IFDEF Use_Thread
   IF SP_lThreadRun() = .T.
   ELSE
      AADD( aSHThread, {} )
      nLen := LEN( aSHThread )
      aSHThread[ nLen ] := hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @DoSH2func(), cAction, lConfirm, lPaperbin, lAdjustTime )
      AttachThreadInput( nMainThreadID, HMG_ThreadHBtoWinID( aSHThread[ nLen ] ), .T. )
   ENDIF
#ELSE
   IF SP_lThreadRun() = .T.
   ELSE
      DoSH2func( cAction, lConfirm, lPaperbin, lAdjustTime )
   ENDIF
#ENDIF
   DO EVENTS

RETURN

*+--------------------------------------------------------------------
*+
*+    Function DoSH2func()
*+
*+    Called from ( fmgrid.prg )   2 - procedure doshfunc()
*+
*+--------------------------------------------------------------------
*+
FUNCTION DoSH2func( cAction, lConfirm, lPaperbin, lAdjustTime )

LOCAL acFiles, acTarget
LOCAL nPosi, cFile
LOCAL i, iMax
LOCAL cSourceDir := ""
LOCAL cTargetDir := ""
LOCAL acDelete   := {}
LOCAL aSourceNum
LOCAL bError, oError

   DEFAULT lConfirm TO .F.
   DEFAULT lPaperbin TO .F.

   IF EMPTY( cAction )
      msginfo( "Action missing ?" )
      RETURN .F.
   ENDIF

   IF nGridFocus = 1
      aSourceNum := GetProperty( "WinLeft", cGrid_Left, "Value" )
      nPosi := ASCAN( aWin, { | o | o[ 1 ] = "WinLeft" .AND. o[ 2 ] = cGrid_Left } )
      IF nPosi > 0
         cSourceDir := GridGetPath( "WinLeft", cGrid_Left )
      ENDIF

      nPosi := ASCAN( aWin, { | o | o[ 1 ] = "WinRight" .AND. o[ 2 ] = cGrid_Right } )
      IF nPosi > 0
         cTargetDir := GridGetPath( "WinRight", cGrid_Right )
      ENDIF
   ELSE
      aSourceNum := GetProperty( "WinRight", cGrid_Right, "Value" )
      nPosi := ASCAN( aWin, { | o | o[ 1 ] = "WinRight" .AND. o[ 2 ] = cGrid_Right } )
      IF nPosi > 0
         cSourceDir := GridGetPath( "WinRight", cGrid_Right )
      ENDIF

      nPosi := ASCAN( aWin, { | o | o[ 1 ] = "WinLeft" .AND. o[ 2 ] = cGrid_Left } )
      IF nPosi > 0
         cTargetDir := GridGetPath( "WinLeft", cGrid_Left )
      ENDIF
   ENDIF

   IF EMPTY( cSourceDir ) .OR. EMPTY( cTargetDir )
      msginfo( "Source or Target Path missing" )
      DO EVENTS
      RETURN .F.
   ENDIF

   SP_lThreadRun( .T. )
   acFiles := {}
   acTarget := {}
   SP_JustDelete( {} )

   aSourceNum := ASORT( aSourceNum )
   iMax := LEN( aSourceNum )
   FOR i := 1 TO iMax
      nPosi := aSourceNum[ i ]

      //       bError := ERRORBLOCK( { | oErr | BREAK( oErr ) } )
      //       BEGIN SEQUENCE

      IF nGridFocus = 1
         cFile := aDir_Left[ nPosi ] [ F_NAME ]
      ELSE
         cFile := aDir_Right[ nPosi ] [ F_NAME ]
      ENDIF

      AADD( acFiles, cSourceDir + cFile )
      IF cAction = "DELETE"
         AADD( acTarget, "" + CHR( 0 ) )
         AADD( acDelete, cFile )
      ELSE
         AADD( acTarget, cTargetDir + cFile )
      ENDIF

      //       RECOVER USING oError
      //          ERRORBLOCK( bError )
      //          MsgInfo( oError:description + CRLF + oError:operation, "Error " + HB_VALTOSTR( oError:osCode ) )
      //       END SEQUENCE
      //       ERRORBLOCK( bError )

   NEXT

   IF !EMPTY( acDelete )
      SP_JustDelete( ACLONE( acDelete ) )
   ENDIF

   DoSH3func( cAction, lConfirm, lPaperbin, lAdjustTime, acFiles, acTarget )

   ReFreshGrid( cAction, cTargetDir, cSourceDir )

   SP_lThreadRun( .F. )

RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Static Procedure ReFreshGrid()
*+
*+    Called from ( fmgrid.prg )   1 - function dosh2func()
*+                                   1 - procedure addfile2grid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ReFreshGrid( cAction, cTargetDir, cSourceDir, nLeft_Right )

   DEFAULT cAction TO ""
   DEFAULT cTargetDir TO ""
   DEFAULT cSourceDir TO ""
   DEFAULT nLeft_Right TO 0

   onDummy( TIME(), "ReFreshGrid", SP_lDirWatch(), PROCNAME( 1 ), PROCLINE( 1 ) )

   DO CASE
      CASE cAction = "COPY" .AND. LEN( cAction ) = 4
         IF nGridFocus = 2                                            // other side
            FillWithDir( "WinLeft", cGrid_Left, cTargetDir, "TREEDN" )
         ELSEIF nGridFocus = 1
            FillWithDir( "WinRight", cGrid_Right, cTargetDir, "TREEDN" )
         ENDIF

      CASE cAction = "COPY2" .AND. LEN( cAction ) = 5                 // DragDrop AddFile2Grid()
         IF nLeft_Right = 1                                           // Target
            FillWithDir( "WinLeft", cGrid_Left, cTargetDir, "TREEDN" )
         ELSEIF nLeft_Right = 2
            FillWithDir( "WinRight", cGrid_Right, cTargetDir, "TREEDN" )
         ENDIF

      CASE cAction = "MOVE"
         IF nGridFocus = 2                                            // other side
            FillWithDir( "WinLeft", cGrid_Left, cTargetDir, "TREEDN" )
            FillWithDir( "WinRight", cGrid_Right, cSourceDir, "TREEDN" )
         ELSEIF nGridFocus = 1
            FillWithDir( "WinRight", cGrid_Right, cTargetDir, "TREEDN" )
            FillWithDir( "WinLeft", cGrid_Left, cSourceDir, "TREEDN" )
         ENDIF

      CASE cAction = "DELETE"
         IF nGridFocus = 1                                            // same side
            FillWithDir( "WinLeft", cGrid_Left, cSourceDir, "TREEDN" )
         ELSEIF nGridFocus = 2
            FillWithDir( "WinRight", cGrid_Right, cSourceDir, "TREEDN" )
         ENDIF

      CASE cAction = "RENAME"

   ENDCASE

   DO EVENTS
RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure ReRead()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+                                   1 - static procedure zipit()
*+                                   1 - static procedure dogridkey1()
*+                                   1 - static procedure dogridkey2()
*+                                   1 - static procedure refreshdirleft()
*+                                   1 - static procedure refreshdirright()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE ReRead( nNo )

LOCAL cDir

STATIC lIsrunning := .F.

   IF lIsrunning = .T.
      RETURN
   ELSE
      lIsrunning := .T.

      onDummy( TIME(), "ReRead", PROCNAME( 1 ), PROCLINE( 1 ) )

      IF nNo = 1
         cDir := GridGetPath( "WinLeft", cGrid_Left )
         FillWithDir( "WinLeft", cGrid_Left, cDir, "TREEDN" )
      ELSE
         cDir := GridGetPath( "WinRight", cGrid_Right )
         FillWithDir( "WinRight", cGrid_Right, cDir, "TREEDN" )
      ENDIF
      DO EVENTS

      lIsrunning := .F.
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Function DoSH3func()
*+
*+    Called from ( fmgrid.prg )   1 - function dosh2func()
*+                                   1 - procedure addfile2grid()
*+
*+--------------------------------------------------------------------
*+
FUNCTION DoSH3func( cAction, lConfirm, lPaperbin, lAdjustTime, acFiles, acTarget )

LOCAL hWnd
LOCAL nFunc, fFlag
LOCAL iMax  := LEN( acFiles )
LOCAL lRet  := .F.

   SP_lDirWatch( .F. )

   fFlag := FOF_SIMPLEPROGRESS

   DO CASE
      CASE cAction = "COPY"
         nFunc := FO_COPY
      CASE cAction = "MOVE"
         nFunc := FO_MOVE
      CASE cAction = "DELETE"
         nFunc := FO_DELETE
      CASE cAction = "RENAME"
         nFunc := FO_RENAME
   ENDCASE

   IF iMax > 1
      fFlag += FOF_MULTIDESTFILES
   ENDIF

   IF lPaperbin
      fFlag += FOF_ALLOWUNDO
   ENDIF

   IF lConfirm
   ELSE
      //      fFlag += FOF_NOCONFIRMATION + FOF_RENAMEONCOLLISION + FOF_NOCONFIRMMKDIR
      fFlag += FOF_NOCONFIRMATION + FOF_NOCONFIRMMKDIR
   ENDIF

   // ===========================================================================
   // Function ShellFile( hParentWnd, aFiles, aTarget, nFunc, nFlag )
   //
   // Purpose:
   // Performs a copy, move, rename, or delete operation on a file system object.
   // Parameters:
   //   aFiles  is an Array of Source-Filenamestrings, or a single Filenamestring
   //   aTarget is an Array of Target-Filenamestrings, or a single Filenamestring
   //   nFunc   determines the action on the files:
   //           FO_MOVE, FO_COPY, FO_DELETE, FO_RENAME
   //   fFlag   Option Flag ( see the file SHELL32.CH )
   //
   // ===========================================================================

   lRet := ShellFiles( hWnd, acFiles, acTarget, nFunc, fFlag )
   DO EVENTS

   IF lAdjustTime = .T. .AND. cAction <> "DELETE"
      //      AdjustTime(acFiles, acTarget,cSourceDir,cTargetDir)
      DO EVENTS
   ENDIF

RETURN lRet

*+--------------------------------------------------------------------
*+
*+    Function GetSelectItem()
*+
*+    Called from ( askform.prg )   1 - function askform()
*+                                   1 - static procedure setsourceinfo()
*+                ( fmgrid.prg )   1 - static procedure copyclipboard()
*+                                   1 - static procedure draghere()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetSelectItem()                                              // called from askform()

LOCAL aItem := {}
LOCAL aData := {}
LOCAL i, iMax, nRow, cName

   DO CASE
      CASE nGridFocus = 1
         aItem := GetProperty( "WinLeft", cGrid_Left, "Value" )

      CASE nGridFocus = 2
         aItem := GetProperty( "WinRight", cGrid_Right, "Value" )
   ENDCASE

   iMax := LEN( aItem )
   FOR i := 1 TO iMax
      nRow := aItem[ i ]
      DO CASE
         CASE nGridFocus = 1
            cName := aDir_Left[ nRow ] [ F_NAME ]
         CASE nGridFocus = 2
            cName := aDir_Right[ nRow ] [ F_NAME ]
      ENDCASE
      AADD( aData, cName )
   NEXT

RETURN ACLONE( aData )

*+--------------------------------------------------------------------
*+
*+    Procedure GetPathAndFile()
*+
*+    Called from ( fmtool.prg )   1 - procedure showproperty()
*+                                   1 - procedure sendtodesktop()
*+                                   1 - procedure sendtostartup()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE GetPathAndFile( nNo, cPath, cFile, cAttr )                  // called from fmtool.prg

LOCAL cForm, cObj
LOCAL aItem, iMax, nItem
LOCAL aData

   IF nNo = 1
      cForm := "WinLeft"
      cObj := cGrid_Left
      aData := ACLONE( aDir_Left )
   ELSE
      cForm := "WinRight"
      cObj := cGrid_Right
      aData := ACLONE( aDir_Right )
   ENDIF

   aItem := GetProperty( cForm, cObj, "Value" )

   IF VALTYPE( aItem ) = "A"
      iMax := LEN( aItem )
      IF EMPTY( iMax )
         SetProperty( cForm, cObj, "Value", { 1 } )
         RETURN
      ELSE
         nItem := aItem[ 1 ]
      ENDIF
   ELSEIF VALTYPE( aItem ) = "N"
      nItem := aItem
   ENDIF

   cPath := GridGetPath( cForm, cObj )
   cFile := TRIM( aData[ nItem ] [ F_NAME ] )                         // + CHR( 0 )
   cAttr := aData[ nItem ] [ F_ATTR ]

RETURN

*+--------------------------------------------------------------------
*+
*+    Function SP_GridLeft()
*+
*+    Called from ( askform.prg )   2 - function askform()
*+                                   1 - static procedure getnewdir()
*+                ( export.prg )   1 - static function oninitpath()
*+                ( modistru.prg )   1 - static function oninit_path()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_GridLeft( cValue )                                        // called from askform()

   IF PCOUNT() > 0
      cGrid_Left := cValue
   ENDIF
RETURN cGrid_Left

*+--------------------------------------------------------------------
*+
*+    Function SP_GridRight()
*+
*+    Called from ( askform.prg )   2 - function askform()
*+                                   1 - static procedure getnewdir()
*+                ( export.prg )   1 - static function oninitpath()
*+                ( modistru.prg )   1 - static function oninit_path()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SP_GridRight( cValue )                                       // called from askform()

   IF PCOUNT() > 0
      cGrid_Right := cValue
   ENDIF
RETURN cGrid_Right

*+--------------------------------------------------------------------
*+
*+    Static Procedure CopyClipboard()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE CopyClipboard()

LOCAL cPath
LOCAL nRow
LOCAL aData := GetSelectItem()
LOCAL cText := ""
LOCAL i, imax

   IF nGridFocus = 1
      cPath := GridGetPath( "WinLeft", cGrid_Left )
   ELSE
      cPath := GridGetPath( "WinRight", cGrid_Right )
   ENDIF
   imax := LEN( aData )
   FOR i := 1 TO iMax
      cText += cPath + aData[ i ] + CRLF
   NEXT
   System.Clipboard := cText

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure ZipIt()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure dogridkey1()
*+                                   1 - static procedure dogridkey2()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ZipIt( nNo )

LOCAL adir, aSourceNum, cSourceDir, cZipFile, cTargetDir, nPosi, i, iMax, aFiles := {}
LOCAL hGrid

   IF nNo = 1
      adir := ACLONE( aDir_Left )
      hGrid := GetControlHandle( cGrid_Left, "WinLeft" )
      aSourceNum := GetProperty( "WinLeft", cGrid_Left, "Value" )

      nPosi := ASCAN( aWin, { | o | o[ 1 ] = "WinLeft" .AND. o[ 2 ] = cGrid_Left } )
      IF nPosi > 0
         cSourceDir := GridGetPath( "WinLeft", cGrid_Left )
      ENDIF

      nPosi := ASCAN( aWin, { | o | o[ 1 ] = "WinRight" .AND. o[ 2 ] = cGrid_Right } )
      IF nPosi > 0
         cTargetDir := GridGetPath( "WinRight", cGrid_Right )
      ENDIF
      nNo := 2
   ELSE
      adir := ACLONE( aDir_Right )
      hGrid := GetControlHandle( cGrid_Right, "WinRight" )
      aSourceNum := GetProperty( "WinRight", cGrid_Right, "Value" )

      nPosi := ASCAN( aWin, { | o | o[ 1 ] = "WinRight" .AND. o[ 2 ] = cGrid_Right } )
      IF nPosi > 0
         cSourceDir := GridGetPath( "WinRight", cGrid_Right )
      ENDIF

      nPosi := ASCAN( aWin, { | o | o[ 1 ] = "WinLeft" .AND. o[ 2 ] = cGrid_Left } )
      IF nPosi > 0
         cTargetDir := GridGetPath( "WinLeft", cGrid_Left )
      ENDIF
      nNo := 1
   ENDIF

   cZipFile := GetInPut( "Zip Filename", "ZIP to " + cTargetDir, "", 1 )

   IF !EMPTY( cZipFile )
      IF .NOT. ".ZIP" $ UPPER( cZipFile )
         cZipFile += ".ZIP"
      ENDIF
      cZipFile := cTargetDir + cZipFile

      iMax := LEN( aSourceNum )
      FOR i := 1 TO iMax
         nPosi := aSourceNum[ i ]
         AADD( aFiles, cSourceDir + adir[ nPosi ] [ F_NAME ] )
      NEXT

      //  COMPRESS aFiles ;
      //  TO cZipFile ;
      //  BLOCK {|cFile,nPos| SbarText(STR(nPos)+"/"+LTRIM(STR(iMax))+" "+cFile), ItemUnMark( hGrid, aSourceNum[nPos] ) }  ;
      //  OVERWRITE

      // ZIPFILE( cZipFile, aFiles, hGrid, aSourceNum )

      HB_ZIPFILE( cZipFile, aFiles,, { | cFile, nPos | SbarText( STR( nPos ) + "/" + LTRIM( STR( iMax ) ) + " " + cFile ), ItemUnMark( hGrid, aSourceNum[ nPos ] ) }, .T. )

      DO EVENTS
      hb_idleSleep( 1.0 )
      ReRead( nNo )
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoIt()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure defgridleft()
*+                                   1 - static procedure defgridright()
*+                                   1 - static procedure dotouchenter()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoIt( cForm, cObj )

LOCAL hGrid
LOCAL nIndex   := 1
LOCAL cPath, cText, cAttr
LOCAL cNewPath
LOCAL i, iMax, nItem, aItem
LOCAL cUser    := GETENV( "USERPROFILE" )

   DO CASE
      CASE cForm = "WinLeft"
         aItem := GetProperty( "WinLeft", cGrid_Left, "Value" )
      CASE cForm = "WinRight"
         aItem := GetProperty( "WinRight", cGrid_Right, "Value" )
   ENDCASE

   IF VALTYPE( aItem ) = "A"
      iMax := LEN( aItem )
      IF EMPTY( iMax )
         SetProperty( cForm, cObj, "Value", { 1 } )
         RETURN
      ELSE
         nItem := aItem[ 1 ]
      ENDIF
   ELSEIF VALTYPE( aItem ) = "N"
      nItem := aItem
   ENDIF

   cPath := GridGetPath( cForm, cObj )
   cText := GetProperty( cForm, cObj, "CELL", nItem, F_NAME )
   cAttr := GetProperty( cForm, cObj, "CELL", nItem, F_ATTR )

   IF cText = "." .AND. LEN( cText ) = 1

   ELSEIF cText = ".." .AND. "D" $ cAttr
      cNewPath := UpPath( cPath )

      FillWithDir( cForm, cObj, cNewPath, "TREEUP" )
      DO EVENTS

   ELSE

      IF "D" $ cAttr
         IF "L" $ cAttr
            // cNewPath := cUser +"\"+cText +"\"
            // Userfolder(@cNewPath)
            Msginfo( "Hardlink not supported yet. use F2" )
            FillWithDir( cForm, cObj, cPath, "TREEDN" )
         ELSE
            cNewPath := cPath + cText + "\"
            FillWithDir( cForm, cObj, cNewPath, "TREEDN" )
         ENDIF
      ELSE
         IF cForm = "WinLeft"
            WinLeft.Tab_Left.Caption( nDimLeft ) := GetTabName( cPath )
         ELSEIF cForm = "WinRight"
            WinRight.Tab_Right.Caption( nDimRight ) := GetTabName( cPath )
         ENDIF

         RunByExtension( cPath, cText )
      ENDIF
      DO EVENTS

   ENDIF

   hGrid := GetControlHandle( cObj, cForm )
   InvalidateRect( hGrid, 0 )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function GridSortDir()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure fillwithdir()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GridSortDir( aDirIn, cForm, cObj )

LOCAL nStartAt := 1
LOCAL aDirOut  := ACLONE( aDirIn )
LOCAL nPosi, nSort := 1
LOCAL nDescend := .F.

   IF LEN( aDirOut ) < 2
   ELSE
      nPosi := ASCAN( aDirOut, { | x | x[ F_NAME ] = "." .AND. LEN( x[ F_NAME ] ) = 1 .AND. "D" $ x[ F_ATTR ] } )
      IF nPosi > 0
         ADEL( aDirOut, nPosi )
         ASIZE( aDirOut, LEN( aDirOut ) - 1 )
      ENDIF
   ENDIF

   // how is it sort
   nSort := GridGetSort( cForm, cObj )
   nDescend := GridGetDESCEND( cForm, cObj )

   IF nSort = F_DATE .OR. nSort = F_TIME
      nStartAt := 0
   ELSE
      // "D"irectry on Top
      ASORT( aDirOut,,, { | x, y | "D" $ x[ F_ATTR ] } )
      AEVAL( aDirOut, { | x, i | nStartAt := IF( "D" $ x[ F_ATTR ], i, nStartAt ) } )
      ASORT( aDirOut, 1, nStartAt, { | x, y | LOWER( x[ F_NAME ] ) < LOWER( y[ F_NAME ] ) } )
   ENDIF

   DO CASE
      CASE nSort = F_NAME
         IF nDescend = .F.
            ASORT( aDirOut, nStartAt + 1,, { | x, y | CompareFile( x[ F_NAME ], y[ F_NAME ], .T. ) } )
         ELSE
            ASORT( aDirOut, nStartAt + 1,, { | x, y | CompareFile( x[ F_NAME ], y[ F_NAME ], .F. ) } )
         ENDIF

      CASE nSort = F_SIZE
         IF nDescend = .F.
            ASORT( aDirOut, nStartAt + 1,, { | x, y | ( x[ F_SIZE ] ) < ( y[ F_SIZE ] ) } )
         ELSE
            ASORT( aDirOut, nStartAt + 1,, { | x, y | ( x[ F_SIZE ] ) > ( y[ F_SIZE ] ) } )
         ENDIF

      CASE nSort = F_DATE
         IF nDescend = .F.
            ASORT( aDirOut, nStartAt + 1,, { | x, y | ( x[ F_DATE ] ) < ( y[ F_DATE ] ) } )
         ELSE
            ASORT( aDirOut, nStartAt + 1,, { | x, y | ( x[ F_DATE ] ) > ( y[ F_DATE ] ) } )
         ENDIF

      CASE nSort = F_TIME
         IF nDescend = .F.
            ASORT( aDirOut, nStartAt + 1,, { | x, y | ( x[ F_TIME ] ) < ( y[ F_TIME ] ) } )
         ELSE
            ASORT( aDirOut, nStartAt + 1,, { | x, y | ( x[ F_TIME ] ) > ( y[ F_TIME ] ) } )
         ENDIF

      CASE nSort = F_ATTR
         IF nDescend = .F.
            ASORT( aDirOut, nStartAt + 1,, { | x, y | ( x[ F_ATTR ] ) < ( y[ F_ATTR ] ) } )
         ELSE
            ASORT( aDirOut, nStartAt + 1,, { | x, y | ( x[ F_ATTR ] ) > ( y[ F_ATTR ] ) } )
         ENDIF

      OTHERWISE

   ENDCASE

RETURN aDirOut

*+--------------------------------------------------------------------
*+
*+    Static Function GridGetSort()
*+
*+    Called from ( fmgrid.prg )   1 - static function gridsortdir()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GridGetSort( cForm, cObj )

LOCAL nSort := 1
LOCAL nPosi

   nPosi := ASCAN( aWin, { | x | x[ AW_FORM ] = cForm .AND. x[ AW_OBJ ] = cObj } )
   IF nPosi > 0
      nSort := aWin[ nPosi ] [ AW_SORT ]
   ENDIF
RETURN nSort

*+--------------------------------------------------------------------
*+
*+    Static Function GridGetDESCEND()
*+
*+    Called from ( fmgrid.prg )   1 - static function gridsortdir()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GridGetDESCEND( cForm, cObj )

LOCAL nDescend := .F.
LOCAL nPosi

   nPosi := ASCAN( aWin, { | x | x[ AW_FORM ] = cForm .AND. x[ AW_OBJ ] = cObj } )
   IF nPosi > 0
      nDescend := aWin[ nPosi ] [ AW_DESCEND ]
   ENDIF
RETURN nDescend

*+--------------------------------------------------------------------
*+
*+    Static Function GridGetPath()
*+
*+    Called from ( fmgrid.prg )   4 - function dosh2func()
*+                                   2 - procedure reread()
*+                                   1 - procedure getpathandfile()
*+                                   2 - static procedure copyclipboard()
*+                                   4 - static procedure zipit()
*+                                   1 - static procedure doit()
*+                                   2 - static procedure draghere()
*+                                   1 - procedure addfile2grid()
*+                                   2 - static procedure change2drive()
*+                                   2 - static procedure createnewfolder()
*+                                   2 - static procedure newtab()
*+                                   1 - procedure tab_change_left()
*+                                   1 - procedure tab_change_right()
*+                                   1 - static procedure infogridchange1()
*+                                   1 - static procedure infogridchange2()
*+                                   1 - static procedure checkotherside()
*+                                   1 - static procedure domarkfiles()
*+                                   2 - static procedure changeleftright()
*+                                   1 - static procedure dataviewer()
*+                                   2 - procedure checktabview()
*+                                   1 - static procedure searchform()
*+                                   2 - static procedure updirpath()
*+                                   2 - static procedure rootupdirpath()
*+                                   2 - static procedure closetab()
*+                                   4 - static procedure selfolder()
*+                                   2 - static procedure gridgotfocus()
*+                                   2 - static procedure runcmdbox()
*+                                   1 - static function changefattr()
*+                                   1 - static procedure slideshow()
*+                                   1 - static procedure dodevice()
*+                                   1 - static procedure dofoldersize()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GridGetPath( cForm, cObj )

LOCAL cPath := ""
LOCAL nPosi := 0

   nPosi := ASCAN( aWin, { | x | x[ AW_FORM ] = cForm .AND. x[ AW_OBJ ] = cObj } )
   IF nPosi > 0
      cPath := aWin[ nPosi ] [ AW_WDIR ]
   ENDIF
RETURN cPath

*+--------------------------------------------------------------------
*+
*+    Static Function GridChangePath()
*+
*+    Called from ( fmgrid.prg )   2 - static procedure fillwithdir()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GridChangePath( cForm, cObj, cPath, cUpDn )

LOCAL nIndex  := 1
LOCAL lRet    := .F.
LOCAL nPosi   := 0
LOCAL aCol    := {}
LOCAL cGoLast

   nPosi := ASCAN( aWin, { | x | x[ AW_FORM ] = cForm .AND. x[ AW_OBJ ] = cObj } )
   IF nPosi > 0
      cGoLast := aWin[ nPosi ] [ AW_WDIR ]

      cPath := TRIM( cPath ) + "\"
      cPath := STRTRAN( cPath, "\\", "\" )
      aWin[ nPosi ] [ AW_WDIR ] := cPath
      DO CASE
         CASE cUpDn = "TREEDN"
            aWin[ nPosi ] [ AW_XXX ] := Getproperty( cForm, cObj, "Value" )
         CASE cUpDn = "TREEUP"
            aWin[ nPosi ] [ AW_GOLAST ] := cGoLast
      ENDCASE
      lRet := .T.
   ENDIF

   IF cForm = "WinLeft"
      WinLeft.Tab_Left.Caption( nDimLeft ) := GetTabName( cPath )

   ELSEIF cForm = "WinRight"
      WinRight.Tab_Right.Caption( nDimRight ) := GetTabName( cPath )

   ENDIF

RETURN lRet

*+--------------------------------------------------------------------
*+
*+    Static Procedure Paint_Background_Window()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Paint_Background_Window( cForm, nNo )

LOCAL hWnd

   IF SP_DarkMode()
      hWnd := GetFormHandle( cForm )
      BMP_FILL( hwnd, SP_nColor1() )
      // PAINTBKGND( hwnd, SP_nColor1() )

      Paint_Tab_Window( nNo )
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure Paint_Main_Background_Window()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Paint_Main_Background_Window( cForm )

LOCAL hWnd

   IF SP_DarkMode()
      //  hWnd := Win_1.Handle
      //  BMP_FILL( hwnd, SP_nColor1() )
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure Paint_Tab_Window()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure paint_background_window()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Paint_Tab_Window( nNo )

LOCAL hWnd
LOCAL nOffSet := 0
LOCAL nheight := 0
LOCAL aRect
LOCAL i, iMax

   IF nNo = 1
      hWnd := WinLeft.Tab_Left.handle
      iMax := LEN( Stack_Left )
   ELSE
      hWnd := WinRight.Tab_Right.handle
      iMax := LEN( Stack_Right )
   ENDIF

   FOR i := 1 TO iMax

      IF nNo = 1
         hWnd := GetProperty( "WinLeft", "Tab_Left", STR( i ), "handle" )
      ELSE
         hWnd := GetProperty( "WinRight", "Tab_Right", STR( i ), "handle" )
      ENDIF
      // BMP_FILL( hwnd, SP_nColor1() )
      PAINTBKGND( hwnd, SP_nColor1() )

      aRect := TABCTRL_GETITEMRECT( hWnd, i - 1 )
      nOffSet += aRect[ 3 ] - aRect[ 1 ]
      nheight := aRect[ 4 ] - aRect[ 2 ]
   NEXT

   PAINTTAB( hWnd, SP_nColor1(), nOffSet, nheight )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoReSizeMain()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+                                   1 - procedure fill1stgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoReSizeMain( fMain )

LOCAL hGrid
LOCAL nPBwide, nZoom, aCol, nWide
LOCAL nDiff      := 0
LOCAL nPBheigh   := 40
LOCAL mainRow    := GetProperty( fMain, 'Row' )
LOCAL mainCol    := GetProperty( fMain, 'Col' )
LOCAL mainWidth  := GetProperty( fMain, 'Width' )
LOCAL mainHeight := GetProperty( fMain, 'Height' )
LOCAL nBorder    := GETBORDERWIDTH()
LOCAL nHwnd, i, cObj, j, jMax := 5
LOCAL nRow, nCol, nHeight := 1024

   lActiveMain := .F.

   nHwnd := GetformHandle( fMain )
   IF IsMaximized( nHwnd )
      nDiff := 90 + 6
   ENDIF

   // *************************** left side  ********************************

   Setproperty( "WinLeft", "Width", mainWidth / 2 )
   Setproperty( "WinLeft", "Height", mainHeight - mainRow - 130 - nDiff )
   Setproperty( "WinLeft", "Col", mainCol + nBorder )
   Setproperty( "WinLeft", "Row", mainRow + 100 )

   Setproperty( "WinLeft", "Tab_Left", "Width", mainWidth / 2 )
   Setproperty( "WinLeft", "Tab_Left", "Height", mainHeight - mainRow - 190 - nDiff )

   Setproperty( "WinLeft", "TabStatus_Left", "Col", nBorder )
   Setproperty( "WinLeft", "TabStatus_Left", "Row", mainHeight - mainRow - 130 - nDiff - 24 )
   Setproperty( "WinLeft", "TabStatus_Left", "Width", mainWidth / 2 )

   Setproperty( "WinLeft", "RootUp_Left", "Col", ( mainWidth / 2 ) - 24 )
   Setproperty( "WinLeft", "DirUp_Left", "Col", ( mainWidth / 2 ) - 48 )

   nZoom := ( mainHeight / nHeight )                                  // based on Font 10
   i := 1
   nDimLeft := LEN( Stack_Left )
   FOR i := 1 TO nDimLeft
      cObj := Stack_Left[ i ] [ 2 ]
      Domethod( "WinLeft", cObj, "hide" )
      // Domethod( "WinLeft", cObj, "DisableUpdate" )

      Setproperty( "WinLeft", cObj, "Width", ( mainWidth / 2 ) - 10 )
      Setproperty( "WinLeft", cObj, "Height", mainHeight - mainRow - 214 - nDiff )

      hGrid := GetControlHandle( cObj, "WinLeft" )
      IF SP_lColResize() = .T.
         Setproperty( "WinLeft", cObj, "ChangeFontSize", ROUND( nZoom * SP_nFontLarge(), 0 ) )
         aCol := ACLONE( SP_aColLeft() )
         jMax := LEN( aCol )
         j := 1
         FOR j := 1 TO jMax
            nWide := aCol[ j ] * nZoom
            LISTVIEW_SETCOLUMNWIDTH( hGrid, j - 1, nWide )
         NEXT
      ELSE
         nWide := 0
         j := 2
         jMax := 5
         FOR j := 2 TO jMax
            nWide += LISTVIEW_GETCOLUMNWIDTH( hGrid, j - 1 )
         NEXT
         LISTVIEW_SETCOLUMNWIDTH( hGrid, 0, ( mainWidth / 2 ) - 30 - nWide )
      ENDIF
      // Domethod( "WinLeft", cObj, "EnableUpdate" )
      // Domethod( "WinLeft", cObj, "Refresh" )
      Domethod( "WinLeft", cObj, "show" )
      InvalidateRect( hGrid, 0 )

   NEXT

   // *************************** right side ********************************

   Setproperty( "WinRight", "Width", ( mainWidth / 2 ) - 8 )
   Setproperty( "WinRight", "Height", mainHeight - mainRow - 130 - nDiff )
   Setproperty( "WinRight", "Col", mainCol + ( mainWidth / 2 ) + nBorder )
   Setproperty( "WinRight", "Row", mainRow + 100 )

   Setproperty( "WinRight", "Tab_Right", "Width", ( mainWidth / 2 ) - 8 )
   Setproperty( "WinRight", "Tab_Right", "Height", mainHeight - mainRow - 190 - nDiff )

   Setproperty( "WinRight", "TabStatus_Right", "Col", nBorder )
   Setproperty( "WinRight", "TabStatus_Right", "Row", mainHeight - mainRow - 130 - nDiff - 24 )
   Setproperty( "WinRight", "TabStatus_Right", "Width", mainWidth / 2 )

   Setproperty( "WinRight", "DirUp_Right", "Col", ( mainWidth / 2 ) - 68 )
   Setproperty( "WinRight", "RootUp_Right", "Col", ( mainWidth / 2 ) - 44 )

   i := 1
   nDimRight := LEN( Stack_Right )
   FOR i := 1 TO nDimRight
      cObj := Stack_Right[ i ] [ 2 ]

      Domethod( "WinRight", cObj, "hide" )
      // Domethod( "WinRight", cObj, "DisableUpdate" )

      Setproperty( "WinRight", cObj, "Width", ( mainWidth / 2 ) - 18 )
      Setproperty( "WinRight", cObj, "Height", mainHeight - mainRow - 214 - nDiff )

      hGrid := GetControlHandle( cObj, "WinRight" )
      IF SP_lColResize() = .T.
         Setproperty( "WinRight", cObj, "ChangeFontSize", ROUND( nZoom * SP_nFontLarge(), 0 ) )
         aCol := ACLONE( SP_aColRight() )
         jMax := LEN( aCol )
         j := 1
         FOR j := 1 TO jMax
            nWide := aCol[ j ] * nZoom
            LISTVIEW_SETCOLUMNWIDTH( hGrid, j - 1, nWide )
         NEXT
      ELSE
         nWide := 0
         j := 2
         jMax := 5
         FOR j := 2 TO jMax
            nWide += LISTVIEW_GETCOLUMNWIDTH( hGrid, j - 1 )
         NEXT
         LISTVIEW_SETCOLUMNWIDTH( hGrid, 0, ( mainWidth / 2 ) - 30 - nWide )
      ENDIF
      // Domethod( "WinRight", cObj, "EnableUpdate" )
      // Domethod( "WinRight", cObj, "Refresh" )
      Domethod( "WinRight", cObj, "show" )
      InvalidateRect( hGrid, 0 )
   NEXT

   // *************************** F1-F11 Button *****************************

   nPBwide := INT( mainWidth / 11 )

   Setproperty( fMain, "Button_F1", "Width", nPBwide - 2 )
   Setproperty( fMain, "Button_F2", "Width", nPBwide - 2 )
   Setproperty( fMain, "Button_F3", "Width", nPBwide - 2 )
   Setproperty( fMain, "Button_F4", "Width", nPBwide - 2 )
   Setproperty( fMain, "Button_F5", "Width", nPBwide - 2 )
   Setproperty( fMain, "Button_F6", "Width", nPBwide - 2 )
   Setproperty( fMain, "Button_F7", "Width", nPBwide - 2 )
   Setproperty( fMain, "Button_F8", "Width", nPBwide - 2 )
   Setproperty( fMain, "Button_F9", "Width", nPBwide - 2 )
   Setproperty( fMain, "Button_F10", "Width", nPBwide - 2 )
   Setproperty( fMain, "Button_F11", "Width", nPBwide - 2 )
   //    Setproperty( fMain, "Button_F12", "Width", nPBwide - 2 )

   Setproperty( fMain, "Button_F1", "Col", nPBwide * 0 )
   Setproperty( fMain, "Button_F2", "Col", nPBwide * 1 )
   Setproperty( fMain, "Button_F3", "Col", nPBwide * 2 )
   Setproperty( fMain, "Button_F4", "Col", nPBwide * 3 )
   Setproperty( fMain, "Button_F5", "Col", nPBwide * 4 )
   Setproperty( fMain, "Button_F6", "Col", nPBwide * 5 )
   Setproperty( fMain, "Button_F7", "Col", nPBwide * 6 )
   Setproperty( fMain, "Button_F8", "Col", nPBwide * 7 )
   Setproperty( fMain, "Button_F9", "Col", nPBwide * 8 )
   Setproperty( fMain, "Button_F10", "Col", nPBwide * 9 )
   Setproperty( fMain, "Button_F11", "Col", nPBwide * 10 )
   //    Setproperty( fMain, "Button_F12", "Col", nPBwide * 11 )

   Setproperty( fMain, "Button_F1", "Row", mainHeight - mainRow - nPBheigh - nDiff )
   Setproperty( fMain, "Button_F2", "Row", mainHeight - mainRow - nPBheigh - nDiff )
   Setproperty( fMain, "Button_F3", "Row", mainHeight - mainRow - nPBheigh - nDiff )
   Setproperty( fMain, "Button_F4", "Row", mainHeight - mainRow - nPBheigh - nDiff )
   Setproperty( fMain, "Button_F5", "Row", mainHeight - mainRow - nPBheigh - nDiff )
   Setproperty( fMain, "Button_F6", "Row", mainHeight - mainRow - nPBheigh - nDiff )
   Setproperty( fMain, "Button_F7", "Row", mainHeight - mainRow - nPBheigh - nDiff )
   Setproperty( fMain, "Button_F8", "Row", mainHeight - mainRow - nPBheigh - nDiff )
   Setproperty( fMain, "Button_F9", "Row", mainHeight - mainRow - nPBheigh - nDiff )
   Setproperty( fMain, "Button_F10", "Row", mainHeight - mainRow - nPBheigh - nDiff )
   Setproperty( fMain, "Button_F11", "Row", mainHeight - mainRow - nPBheigh - nDiff )
   //    Setproperty( fMain, "Button_F12", "Row", mainHeight - mainRow - nPBheigh - nDiff )

   Setproperty( fMain, "PathInfo", "Row", mainHeight - mainRow - nPBheigh - 34 - nDiff )
   Setproperty( fMain, "PathInfo", "Width", ( mainWidth / 2 ) - 10 )

   Setproperty( fMain, "CMDBox", "Row", mainHeight - mainRow - nPBheigh - 34 - nDiff )
   Setproperty( fMain, "CMDBox", "Width", ( mainWidth / 2 ) - 10 )
   Setproperty( fMain, "CMDBox", "Col", ( mainWidth / 2 ) )

   lActiveMain := .T.
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoGridKey1()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure defgridleft()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoGridKey1( cForm, cObj )

LOCAL nTab        := Getproperty( "WinLeft", "Tab_Left", "Value" )
LOCAL xKey        := HMG_GetLastVirtualKeyDown()
LOCAL nPosi
LOCAL hGrid       := GetControlHandle( cObj, "WinLeft" )
LOCAL aStart      := GetProperty( "WinLeft", cObj, "Value" )
STATIC cInKeySeek := ""
STATIC nLast      := 1

   IF EMPTY( aDir_Left )
      RETURN
   ENDIF

   IF lActiveMain = .T.
      DO CASE
         CASE xKey == VK_T .AND. HMG_VirtualKeyIsPressed( VK_CONTROL )
            NewTab()
         CASE xKey == VK_U .AND. HMG_VirtualKeyIsPressed( VK_CONTROL )
            ChangeLeftRight()

         CASE xKey == VK_R .AND. HMG_VirtualKeyIsPressed( VK_CONTROL )
            ReRead( 1 )

         CASE xKey == VK_W .AND. HMG_VirtualKeyIsPressed( VK_CONTROL )
            CloseTab( 1 )

         CASE xKey == VK_F2 .AND. HMG_VirtualKeyIsPressed( VK_SHIFT )
            CompareDir()
         CASE xKey == VK_F3 .AND. HMG_VirtualKeyIsPressed( VK_SHIFT )
            Slideshow()
         CASE xKey == VK_F4 .AND. HMG_VirtualKeyIsPressed( VK_SHIFT )
            CreateNewDbf()

         CASE xKey == VK_F1 .AND. HMG_VirtualKeyIsPressed( VK_ALT )
            OpenCombo( "LEFT", "KEY" )
         CASE xKey == VK_F2 .AND. HMG_VirtualKeyIsPressed( VK_ALT )
            OpenCombo( "RIGHT", "KEY" )
         CASE xKey == VK_F5 .AND. HMG_VirtualKeyIsPressed( VK_ALT )
            ZipIt( 1 )
         CASE xKey == VK_F7 .AND. HMG_VirtualKeyIsPressed( VK_ALT )
            SearchForm( 1 )

         CASE xKey == VK_F1 .AND. .NOT. IsKeyVK()
            HelpFile()
         CASE xKey == VK_F2 .AND. .NOT. IsKeyVK()
            PreFuncSysFolder()
         CASE xKey == VK_F3 .AND. .NOT. IsKeyVK()
            IF( HMG_VirtualKeyIsPressed( VK_ALT ),, DataViewer( .F. ) )
         CASE xKey == VK_F4 .AND. .NOT. IsKeyVK()
            IF( HMG_VirtualKeyIsPressed( VK_ALT ),, DataViewer( .T. ) )
         CASE xKey == VK_F5 .AND. .NOT. IsKeyVK()
            ASKFORM( "COPY" )
         CASE xKey == VK_F6 .AND. .NOT. IsKeyVK()
            ASKFORM( "MOVE" )
         CASE xKey == VK_F7 .AND. .NOT. IsKeyVK()
            CreateNewFolder()
         CASE xKey == VK_F8 .AND. .NOT. IsKeyVK()
            ASKFORM( "DELETE" )
         CASE xKey == VK_DELETE .AND. .NOT. IsKeyVK()
            ASKFORM( "DELETE" )
         CASE xKey == VK_RETURN
            // it IS include as DblClick
            // DoDblClick()

         CASE xKey == VK_TAB .AND. HMG_VirtualKeyIsPressed( VK_CONTROL )
            nTab ++
            IF nTab > LEN( Stack_Left )
               nDimLeft := 1
            ELSE
               nDimLeft := nTab
            ENDIF
            WinLeft.Tab_Left.Value := nDimLeft
            Tab_Change_Left()

         CASE xKey == VK_ADD
            DoAuswahl( 1, "ADD" )
         CASE xKey == VK_SUBTRACT
            DoAuswahl( 1, "SUBTRACT" )
         CASE xKey == VK_MULTIPLY
            DoReverseMark( 1 )

         CASE xKey == VK_SPACE
            DoFolderSize( 1 )

         CASE xKey == VK_ESCAPE
            // hm
            cInKeySeek := ""

         OTHERWISE

            IF HMG_VirtualKeyIsPressed( VK_CONTROL ) .OR. HMG_VirtualKeyIsPressed( VK_SHIFT ) .OR. HMG_VirtualKeyIsPressed( VK_ALT )
            ELSE
               nPosi := ASCAN( aGetVKkeys, { | x, i | x[ 3 ] = xKey } )
               IF nPosi > 0
               ELSE
                  IF EMPTY( aStart )
                     aStart := { 1 }
                  ENDIF

                  IF !EMPTY( xKey )
                     cInKeySeek := CHR( xKey )
                     IF !EMPTY( cInKeySeek ) .AND. LEN( aDir_Left ) > 0
                        nPosi := ASCAN( aDir_Left, { | x, i | x[ F_NAME ] = cInKeySeek }, aStart[ 1 ] + 1 )
                        IF nPosi > 0
                           UnMarkAll( hGrid )
                           ItemMark( hGrid, nPosi )
                           nLast := nPosi

                           DO EVENTS
                           CLEAR TYPEAHEAD
                        ELSE
                           IF LEN( aDir_Left ) = 0
                              nDimLeft := 1
                           ENDIF
                           aStart := { 1 }
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
      ENDCASE
   ENDIF

   HMG_CleanLastVirtualKeyDown()
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoGridKey2()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure defgridright()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoGridKey2( cForm, cObj )

LOCAL nTab   := Getproperty( "WinRight", "Tab_Right", "Value" )
LOCAL xKey   := HMG_GetLastVirtualKeyDown()
LOCAL nPosi
LOCAL hGrid  := GetControlHandle( cObj, "WinRight" )
LOCAL aStart := GetProperty( "WinRight", cObj, "Value" )

STATIC cInKeySeek := ""
STATIC nLast      := 1

   IF EMPTY( aDir_Right )
      RETURN
   ENDIF
   IF lActiveMain = .T.
      DO CASE
         CASE xKey == VK_T .AND. HMG_VirtualKeyIsPressed( VK_CONTROL )
            NewTab()
         CASE xKey == VK_U .AND. HMG_VirtualKeyIsPressed( VK_CONTROL )
            ChangeLeftRight()
         CASE xKey == VK_R .AND. HMG_VirtualKeyIsPressed( VK_CONTROL )
            ReRead( 2 )
         CASE xKey == VK_W .AND. HMG_VirtualKeyIsPressed( VK_CONTROL )
            CloseTab( 2 )

         CASE xKey == VK_F2 .AND. HMG_VirtualKeyIsPressed( VK_SHIFT )
            CompareDir()
         CASE xKey == VK_F3 .AND. HMG_VirtualKeyIsPressed( VK_SHIFT )
            Slideshow()
         CASE xKey == VK_F4 .AND. HMG_VirtualKeyIsPressed( VK_SHIFT )
            CreateNewDbf()

         CASE xKey == VK_F1 .AND. HMG_VirtualKeyIsPressed( VK_ALT )
            OpenCombo( "LEFT", "KEY" )
         CASE xKey == VK_F2 .AND. HMG_VirtualKeyIsPressed( VK_ALT )
            OpenCombo( "RIGHT", "KEY" )
         CASE xKey == VK_F5 .AND. HMG_VirtualKeyIsPressed( VK_ALT )
            ZipIt( 2 )
         CASE xKey == VK_F7 .AND. HMG_VirtualKeyIsPressed( VK_ALT )
            SearchForm( 2 )

         CASE xKey == VK_F1 .AND. .NOT. IsKeyVK()
            HelpFile()
         CASE xKey == VK_F2 .AND. .NOT. IsKeyVK()
            PreFuncSysFolder()
         CASE xKey == VK_F3 .AND. .NOT. IsKeyVK()
            IF( HMG_VirtualKeyIsPressed( VK_ALT ),, DataViewer( .F. ) )
         CASE xKey == VK_F4 .AND. .NOT. IsKeyVK()
            IF( HMG_VirtualKeyIsPressed( VK_ALT ),, DataViewer( .T. ) )
         CASE xKey == VK_F5 .AND. .NOT. IsKeyVK()
            ASKFORM( "COPY" )
         CASE xKey == VK_F6 .AND. .NOT. IsKeyVK()
            ASKFORM( "MOVE" )
         CASE xKey == VK_F7 .AND. .NOT. IsKeyVK()
            CreateNewFolder()
         CASE xKey == VK_F8 .AND. .NOT. IsKeyVK()
            ASKFORM( "DELETE" )
         CASE xKey == VK_DELETE
            ASKFORM( "DELETE" )
         CASE xKey == VK_RETURN
            // it IS include as DblClick
            // DoDblClick()
         CASE xKey == VK_TAB .AND. HMG_VirtualKeyIsPressed( VK_CONTROL )
            nTab ++
            IF nTab > LEN( Stack_Right )
               nDimRight := 1
            ELSE
               nDimRight := nTab
            ENDIF
            WinRight.Tab_Right.Value := nDimRight
            Tab_Change_Right()

         CASE xKey == VK_ADD
            DoAuswahl( 2, "ADD" )
         CASE xKey == VK_SUBTRACT
            DoAuswahl( 2, "SUBTRACT" )
         CASE xKey == VK_MULTIPLY
            DoReverseMark( 2 )

         CASE xKey == VK_SPACE
            DoFolderSize( 2 )

         CASE xKey == VK_ESCAPE
            // hm
            cInKeySeek := ""

         OTHERWISE

            IF HMG_VirtualKeyIsPressed( VK_CONTROL ) .OR. HMG_VirtualKeyIsPressed( VK_SHIFT ) .OR. HMG_VirtualKeyIsPressed( VK_ALT )
            ELSE
               nPosi := ASCAN( aGetVKkeys, { | x, i | x[ 3 ] = xKey } )
               IF nPosi > 0
               ELSE
                  IF EMPTY( aStart )
                     aStart := { 1 }
                  ENDIF
                  IF !EMPTY( xKey )
                     cInKeySeek := CHR( xKey )
                     IF !EMPTY( cInKeySeek ) .AND. LEN( aDir_Right ) > 0
                        nPosi := ASCAN( aDir_Right, { | x, i | x[ F_NAME ] = cInKeySeek }, aStart[ 1 ] + 1 )
                        IF nPosi > 0
                           UnMarkAll( hGrid )
                           ItemMark( hGrid, nPosi )
                           nLast := nPosi

                           DO EVENTS
                           CLEAR TYPEAHEAD
                        ELSE
                           IF LEN( aDir_Right ) = 0
                              nDimRight := 1
                           ENDIF
                           aStart := { 1 }
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
      ENDCASE
   ENDIF

   HMG_CleanLastVirtualKeyDown()
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure OpenCombo()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+                                   2 - static procedure dogridkey1()
*+                                   2 - static procedure dogridkey2()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE OpenCombo( cWin, cKey )

   DEFAULT cKey := ""

   HMG_CleanLastVirtualKeyDown()

   lFromKeyBoard := .T.
   DO CASE
      CASE cWin = "LEFT"
         WinLeft.ComboLeft.SetFocus()
      CASE cWin = "RIGHT"
         WinRight.ComboRight.SetFocus()
   ENDCASE
   hb_idleSleep( 0.5 )
   lFromKeyBoard := .F.

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DragMove()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DragMove( cForm )

   // LOCAL hWnd := GetFormHandle( cForm )
   //    SbarText( "DragMove", "ONFLY" )
   //
   //    SetWindowCursor( hWnd, "HP_GLASS" )
   //    SetWindowCursor( hWnd, IDC_HAND )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DragHere()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DragHere( cForm )

LOCAL nHwnd    := GetFormHandle( cForm )
LOCAL nCursRow := GetCursorRow()
LOCAL nCursCol := GetCursorCol()
LOCAL nOther, cClsName, cText
LOCAL cPath, aItem, i, iMax, cString := ""

   SbarText( "DragHere", "ONFLY" )

   nOther := WindowFromPoint( { nCursRow, nCursCol } )
   IF !EMPTY( nOther )                                                // external EDIT Control
      IF nHwnd <> nOther

         IF nGridFocus = 1
            cPath := GridGetPath( "WinLeft", cGrid_Left )
         ELSE
            cPath := GridGetPath( "WinRight", cGrid_Right )
         ENDIF
         aItem := GetSelectItem()
         iMax := LEN( aItem )
         FOR i := 1 TO iMax
            cString += cPath + "\" + aItem[ i ] + CRLF
         NEXT

         // Clipboard-Objekt erzeugen
         // SETCLIPBOARD(cString)

         // System.EmptyClipboard
         System.Clipboard := cString

         ShowWindow( nOther, SW_RESTORE )
         BringWindowToTop( nOther )
         SetForegroundWindow( nOther )
         SetFocus( nOther )

         HMG_PressKey( VK_CONTROL, VK_V )

         // keybd_event( VK_CONTROL, 0, 0, 0 )
         // keybd_event( ASC( "V" ), 0, 0, 0 )
         // keybd_event( ASC( "V" ), 0, KEYEVENTF_KEYUP, 0 )
         // keybd_event( VK_CONTROL, 0, KEYEVENTF_KEYUP, 0 )

         cClsName := SPACE( 1024 ) + CHR( 0 )
         cText := SPACE( 1024 ) + CHR( 0 )
         GetWindowText( nOther, @cText, LEN( cText ) )
         GetClassName( nOther, @cClsName, LEN( cClsName ) )

         cClsName := TRIM( STRTRAN( cClsName, CHR( 0 ), "" ) )
         cText := TRIM( STRTRAN( cText, CHR( 0 ), "" ) )

         SbarText( cClsName + "/" + cText, "ARRIVENOW" )

         IF "SysListView32" $ cClsName .AND. "FolderView" $ cText
         ENDIF

      ELSE
         SetWindowCursor( nHwnd, IDC_ARROW )
         IF( lActiveMain = .T., ASKFORM( "COPY" ), )
         SbarText( "finsh drop", "ARRIVENOW" )
      ENDIF
   ELSE
      // ************************************
      //    IF isWindowDefined(_HMG_Drag_Form_)
      //       DoMethod("_HMG_Drag_Form_" ,"Hide")
      //    ENDIF
      // ************************************
      SetWindowCursor( nHwnd, IDC_ARROW )
      IF( lActiveMain = .T., ASKFORM( "COPY" ), )
      SbarText( "finsh drop", "ARRIVENOW" )
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure AddFile2Grid()
*+
*+    Called from ( hbdevice.prg )   1 - function usb_detect()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE AddFile2Grid( cDropForm, cDropCont, aNewFiles )             // called from hbdevice.prg

LOCAL hWnd        := GetFormHandle( cDropForm )
LOCAL cTargetDir  := GridGetPath( cDropForm, cDropCont )
LOCAL cSourceDir
LOCAL i, iMax, cEletemt, cFile := ""
LOCAL cAction     := "COPY"
LOCAL lConfirm    := .F.
LOCAL lPaperbin   := .F.
LOCAL lAdjustTime := .F.
LOCAL acFiles, acTarget
LOCAL nLeft_Right

   iMax := LEN( aNewFiles )
   IF iMax > 0
      acFiles := {}
      acTarget := {}

      i := 1
      cSourceDir := pathonly( aNewFiles[ 1 ] )
      FOR i := 1 TO iMax
         cEletemt := fileonly( aNewFiles[ i ] )
         cFile := cTargetDir + "\" + cEletemt
         AADD( acFiles, aNewFiles[ i ] )
         AADD( acTarget, cFile )
      NEXT

      DoSH3func( cAction, lConfirm, lPaperbin, lAdjustTime, acFiles, acTarget )

      IF "WinLeft" $ cDropForm
         nLeft_Right := 1
      ELSEIF "WinRight" $ cDropForm
         nLeft_Right := 2
      ELSE
         nLeft_Right := 0
      ENDIF

      IF !EMPTY( nLeft_Right )
         ReFreshGrid( cAction + "2", cTargetDir, cSourceDir, nLeft_Right )
      ENDIF

      SbarText( "finsh drop", "ARRIVENOW" )

   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure Readydrag()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Readydrag( oWin )

   Win_1.CMDBox.SetFocus()
   Win_1.CMDBox.Value := ""
   lActiveMain = .F.

   SbarText( "ready for drop", "STARTNOW" )

   WinTans( oWin, .F. )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure Change2Drive()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Change2Drive( cCombo )

LOCAL nVALUE, aItem, aNewDir
LOCAL nPosi, cDir, cDrive, cNewPath, cText
LOCAL cChoise := ""
LOCAL hGrid

   DO CASE
      CASE cCombo = "ComboLeft"
         nVALUE := GetProperty( "WinLeft", "ComboLeft", "VALUE" )
         aItem := GetProperty( "WinLeft", "ComboLeft", "ITEM", nVALUE )

         nPosi := ASCAN( aWin, { | o | o[ 1 ] = "WinLeft" .AND. o[ 2 ] = cGrid_Left } )
         IF nPosi > 0
            cDir := SUBSTR( GridGetPath( "WinLeft", cGrid_Left ), 1, 1 )
         ENDIF

         IF !EMPTY( aItem ) .AND. !EMPTY( aItem[ 2 ] )
            cChoise := aItem[ 2 ]
            cChoise := SUBSTR( cChoise, 1, 1 )
            IF cChoise <> cDir
               cDrive := cChoise
               cNewPath := cDrive + ":\"

               cText := GetVolumne( cDrive ) + " " + STR( HB_DISKSPACE( cDrive + ":" ) / 1024 / 1000 / 1000 ) + " Mb free of " + LTRIM( STR( HB_DISKSPACE( cDrive + ":", HB_DISK_TOTAL ) / 1024 / 1000 / 1000 ) ) + " Mb"
               SetProperty( "WinLeft", "VolInfo_Left", "VALUE", cText )

               CheckOtherSide( "WinRight", @cNewPath, cDrive )
               FillWithDir( "WinLeft", cGrid_Left, cNewPath, "TREEDN" )
            ENDIF
         ENDIF
         hGrid := GetControlHandle( cGrid_Left, "WinLeft" )

         Domethod( "WinLeft", "Tab_Left", "SetFocus" )
         Domethod( "WinLeft", cGrid_Left, "SetFocus" )

      CASE cCombo = "ComboRight"
         nVALUE := GetProperty( "WinRight", "ComboRight", "VALUE" )
         aItem := GetProperty( "WinRight", "ComboRight", "ITEM", nVALUE )

         nPosi := ASCAN( aWin, { | o | o[ 1 ] = "WinRight" .AND. o[ 2 ] = cGrid_Right } )
         IF nPosi > 0
            cDir := SUBSTR( GridGetPath( "WinRight", cGrid_Right ), 1, 1 )
         ENDIF

         IF !EMPTY( aItem ) .AND. !EMPTY( aItem[ 2 ] )
            cChoise := aItem[ 2 ]
            cChoise := SUBSTR( cChoise, 1, 1 )
            IF cChoise <> cDir
               cDrive := cChoise
               cNewPath := cDrive + ":\"

               cText := GetVolumne( cDrive ) + " " + STR( HB_DISKSPACE( cDrive + ":" ) / 1024 / 1000 / 1000 ) + " Mb free of " + LTRIM( STR( HB_DISKSPACE( cDrive + ":", HB_DISK_TOTAL ) / 1024 / 1000 / 1000 ) ) + " Mb"
               SetProperty( "WinRight", "VolInfo_Right", "VALUE", cText )

               CheckOtherSide( "WinLeft", @cNewPath, cDrive )
               FillWithDir( "WinRight", cGrid_Right, cNewPath, "TREEDN" )
            ENDIF
         ENDIF
         hGrid := GetControlHandle( cGrid_Right, "WinRight" )

         Domethod( "WinRight", "Tab_Right", "SetFocus" )
         Domethod( "WinRight", cGrid_Right, "SetFocus" )

   ENDCASE

   ItemMark( hGrid, 1 )

   DO EVENTS

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function GetVolumne()
*+
*+    Called from ( fmgrid.prg )   3 - procedure dualgrid()
*+                                   2 - static procedure change2drive()
*+                                   1 - procedure tab_change_left()
*+                                   1 - procedure tab_change_right()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GetVolumne( cIn )

LOCAL i
LOCAL nType, cDrive, cVolume := ""

   i := ASCAN( aDrives, { | a | a[ 2 ] = cIn } )
   IF i > 0
      nType := aDrives[ i ] [ 1 ]
      cDrive := aDrives[ i ] [ 2 ]
      cVolume := aDrives[ i ] [ 3 ]
   ENDIF

RETURN "[" + cVolume + "]"

*+--------------------------------------------------------------------
*+
*+    Static Procedure CreateNewFolder()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+                                   1 - static procedure dogridkey1()
*+                                   1 - static procedure dogridkey2()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE CreateNewFolder()

LOCAL cInput := ""
LOCAL nPosi, cDir, aNewDir

   cInput := GetInPut( "New Folder Name:", "Create Folder", "", 1 )
   IF !EMPTY( cInput )
      SP_lDirWatch( .F. )
      IF nGridFocus = 1
         nPosi := ASCAN( aWin, { | o | o[ 1 ] = "WinLeft" .AND. o[ 2 ] = cGrid_Left } )
         IF nPosi > 0
            cDir := GridGetPath( "WinLeft", cGrid_Left )
         ENDIF
         FT_MKDIR( cdir + cInput )

         FillWithDir( "WinLeft", cGrid_Left, cdir, "TREEDN" )

      ELSE
         nPosi := ASCAN( aWin, { | o | o[ AW_FORM ] = "WinRight" .AND. o[ 2 ] = cGrid_Right } )
         IF nPosi > 0
            cDir := GridGetPath( "WinRight", cGrid_Right )
         ENDIF
         FT_MKDIR( cdir + "\" + cInput )

         FillWithDir( "WinRight", cGrid_Right, cdir, "TREEDN" )
      ENDIF
      SP_lDirWatch( .T. )
   ENDIF
   DO EVENTS

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure FillWithDir()
*+
*+    Called from ( fmgrid.prg )   2 - procedure fill1stgrid()
*+                                  10 - static procedure refreshgrid()
*+                                   2 - procedure reread()
*+                                   3 - static procedure doit()
*+                                   2 - static procedure change2drive()
*+                                   2 - static procedure createnewfolder()
*+                                   1 - static procedure headleft()
*+                                   1 - static procedure headright()
*+                                   2 - static procedure newtab()
*+                                   2 - static procedure prefuncsysfolder()
*+                                   2 - static procedure changeleftright()
*+                                   1 - static procedure searchform()
*+                                   1 - static procedure updirpath()
*+                                   1 - static procedure rootupdirpath()
*+                                   2 - static procedure closetab()
*+                                   4 - static procedure selfolder()
*+                                   2 - static procedure runcmdbox()
*+                                   2 - static procedure back2dirlist()
*+                                   1 - static procedure dodevice()
*+                                   2 - static function netdisconnect()
*+                                   1 - static procedure changefolder()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE FillWithDir( cForm, cObj, cNewPath, cUpDn )

LOCAL nState     := hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )
LOCAL nMask      := hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )
LOCAL nGoTo      := 1
LOCAL nIndexRoot := 0
LOCAL acDelete   := SP_JustDelete()
LOCAL aTest      := { { 0, 0, 0 } }
LOCAL xLast      := ""
LOCAL hIcon, nFileHandle
LOCAL cSeek, cFile, cAttr
LOCAL aNewDir
LOCAL hGrid
LOCAL nIndex
LOCAL nPosi, cDir
LOCAL i, iMax, nDimStack, aInfoDir, nIcoHandle, j, jMax
LOCAL xRet

STATIC lIsrunning := .F.

   DEFAULT cUpDn TO "TREEDN"

   IF lIsrunning = .T.
      RETURN
   ELSE
      lIsrunning := .T.

      SP_lDirWatch( .F. )
      onDummy( TIME(), "FillWithDir", cNewPath, PROCNAME( 1 ), PROCLINE( 1 ), PROCNAME( 2 ), PROCLINE( 2 ) )

      cNewPath += "\"
      cNewPath := STRTRAN( cNewPath, "\\", "\" )

      aNewDir := DIRECTORY( cNewPath + "*.*", "DHS" )

      IF EMPTY( aNewDir )
         RETURN
      ENDIF

      IF !EMPTY( acDelete )
         iMax := LEN( acDelete )
         FOR i := 1 TO iMax
            nPosi := ASCAN( aNewDir, { | o | o[ F_NAME ] = acDelete[ i ] } )
            IF nPosi > 0
               ADEL( aNewDir, nPosi )
               ASIZE( aNewDir, LEN( aNewDir ) - 1 )
            ENDIF
         NEXT
      ENDIF
      SP_JustDelete( {} )

      aNewDir := GridSortDir( aNewDir, cForm, cObj )

      DO CASE
         CASE cForm = "WinLeft"
            Domethod( "WinLeft", cObj, "DisableUpdate" )
            Domethod( "WinLeft", cObj, "DeleteAllItems" )

            aDir_Left := {}
            aDir_Left := ACLONE( aNewDir )
            iMax := LEN( aNewDir )
#IFDEF Use_Virtual
            SetProperty( "WinLeft", cObj, "ITEMCOUNT", LEN( aDir_Left ) )
#ELSE
            xLast := ""
            FOR i := 1 TO iMax
               IF xLast <> aNewDir[ i ] [ F_NAME ]
                  xLast := aNewDir[ i ] [ F_NAME ]
                  Domethod( "WinLeft", cObj, "addItem", aNewDir[ i ] )
               ENDIF
            NEXT
            IF SP_UseImage() = .T.
               aFiles_Left := BT_DirectoryInfo( cNewPath, BT_DIRECTORYINFO_LISTALL )
               DirImageColor( cNewPath, aNewDir, "WinLeft", cObj )
            ENDIF
#ENDIF
            GridChangePath( "WinLeft", cObj, cNewPath, cUpDn )
            Domethod( "WinLeft", cObj, "EnableUpdate" )
            Domethod( "WinLeft", cObj, "Refresh" )
            Domethod( "WinLeft", cObj, "SetFocus" )
            hGrid := GetControlHandle( cObj, "WinLeft" )
            AddBackLog( 1, cNewPath )

         CASE cForm = "WinRight"
            Domethod( "WinRight", cObj, "DisableUpdate" )
            Domethod( "WinRight", cObj, "DeleteAllItems" )

            aDir_Right := {}
            aDir_Right := ACLONE( aNewDir )
            iMax := LEN( aNewDir )
#IFDEF Use_Virtual
            SetProperty( "WinRight", cObj, "ITEMCOUNT", LEN( aDir_Right ) )
#ELSE
            xLast := ""
            FOR i := 1 TO iMax
               IF xLast <> aNewDir[ i ] [ F_NAME ]
                  xLast := aNewDir[ i ] [ F_NAME ]
                  Domethod( "WinRight", cObj, "addItem", aNewDir[ i ] )
               ENDIF
            NEXT
            IF SP_UseImage() = .T.
               aFiles_Right := BT_DirectoryInfo( cNewPath, BT_DIRECTORYINFO_LISTALL )
               DirImageColor( cNewPath, aNewDir, "WinRight", cObj )
            ENDIF
#ENDIF
            GridChangePath( "WinRight", cObj, cNewPath, cUpDn )
            Domethod( "WinRight", cObj, "EnableUpdate" )
            Domethod( "WinRight", cObj, "Refresh" )
            Domethod( "WinRight", cObj, "SetFocus" )
            hGrid := GetControlHandle( cObj, "WinRight" )

            AddBackLog( 2, cNewPath )

      ENDCASE

      DO CASE
         CASE cUpDn = "TREEDN"
            nGoTo := 1
            DO CASE
               CASE cForm = "WinLeft"
                  SetProperty( "WinLeft", cObj, "Value", { nGoTo } )
               CASE cForm = "WinRight"
                  SetProperty( "WinRight", cObj, "Value", { nGoTo } )
            ENDCASE

         CASE cUpDn = "TREEUP"
            nPosi := ASCAN( aWin, { | x | x[ AW_FORM ] = cForm .AND. x[ AW_OBJ ] = cObj } )
            IF nPosi > 0
               cDir := GetTabName( aWin[ nPosi ] [ AW_GOLAST ] )
               DO CASE
                  CASE cForm = "WinLeft"
                     nGoTo := ASCAN( aDir_Left, { | o | o[ F_NAME ] = cDir } )
                     SetProperty( "WinLeft", cObj, "Value", { nGoTo } )

                  CASE cForm = "WinRight"
                     nGoTo := ASCAN( aDir_Right, { | o | o[ F_NAME ] = cDir } )
                     SetProperty( "WinRight", cObj, "Value", { nGoTo } )
               ENDCASE
            ENDIF
      ENDCASE

      ItemMark( hGrid, nGoTo, nState, nMask )
      ListView_EnsureVisible( hGrid, nGoTo )
      DO EVENTS

      iMax := MAX( iMax, ListViewGetCountPerPage( hGrid ) )
      ListView_RedrawItems( hGrid, 1, iMax )
      DO EVENTS

      DO CASE
         CASE cForm = "WinLeft"
            nDimStack := nDimLeft
            Domethod( "WinLeft", cObj, "SetFocus" )

         CASE cForm = "WinRight"
            nDimStack := nDimRight
            Domethod( "WinRight", cObj, "SetFocus" )
      ENDCASE

      IF nDimStack > 1
         DO CASE
            CASE cForm = "WinLeft"
               Domethod( "WinLeft", cObj, "SetFocus" )
            CASE cForm = "WinRight"
               Domethod( "WinRight", cObj, "SetFocus" )
         ENDCASE
         DO EVENTS
      ENDIF

      SP_lDirWatch( .T. )
      DO EVENTS

      lIsrunning := .F.
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DirImageColor()
*+
*+    Called from ( fmgrid.prg )   2 - static procedure fillwithdir()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DirImageColor( cPath, aDir, cForm, cObj )

LOCAL i, iMax := LEN( aDir )
LOCAL cName, nPosi, nIndex, cFull, nLen, cFile, cAttr, nFileHandle, hIcon

   FOR i := 1 TO iMax
      cName := aDir[ i ] [ F_NAME ]
      cAttr := aDir[ i ] [ F_ATTR ]
      cFile := cPath + cName

      IF "D" $ cAttr
         nIndex := 3
      ELSE
         // !!! WARNING !!!
         // API Function seems to have Side-Effects
         nIndex := GETICOINDEX( cFile, 16, @hIcon )
      ENDIF
      SetProperty( cForm, cObj, "ImageIndex", i, 1, nIndex )

      // need to DestroyIcon()
      IF VALTYPE( hIcon ) != "U"
         IF DestroyIcon( hIcon )
            hIcon := NIL
         ENDIF
      ENDIF

   NEXT

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure HeadLeft()
*+
*+    Called from ( fmgrid.prg )   8 - procedure dualgrid()
*+                                   5 - static procedure defgridleft()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE HeadLeft( nSort )

LOCAL cForm    := "WinLeft"
LOCAL cObj     := cGrid_Left
LOCAL cUpDn    := "TREEDN"
LOCAL cNewPath
LOCAL nPosi, nDescend

STATIC lLast := .T.

   nPosi := ASCAN( aWin, { | x | x[ AW_FORM ] = cForm .AND. x[ AW_OBJ ] = cObj } )
   IF nPosi > 0
      cNewPath := aWin[ nPosi ] [ AW_WDIR ]
      nDescend := aWin[ nPosi ] [ AW_DESCEND ]
      IF lLast <> nDescend
         lLast := nDescend
      ENDIF
      aWin[ nPosi ] [ AW_DESCEND ] := .NOT. nDescend
      aWin[ nPosi ] [ AW_SORT ] := nSort
      FillWithDir( cForm, cObj, cNewPath, "TREEDN" )
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure HeadRight()
*+
*+    Called from ( fmgrid.prg )   8 - procedure dualgrid()
*+                                   5 - static procedure defgridright()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE HeadRight( nSort )

LOCAL cForm    := "WinRight"
LOCAL cObj     := cGrid_Right
LOCAL cUpDn    := "TREEDN"
LOCAL cNewPath
LOCAL nPosi, nDescend
STATIC lLast   := .T.

   nPosi := ASCAN( aWin, { | x | x[ AW_FORM ] = cForm .AND. x[ AW_OBJ ] = cObj } )
   IF nPosi > 0
      cNewPath := aWin[ nPosi ] [ AW_WDIR ]
      nDescend := aWin[ nPosi ] [ AW_DESCEND ]
      IF lLast <> nDescend
         lLast := nDescend
      ENDIF
      aWin[ nPosi ] [ AW_DESCEND ] := .NOT. nDescend
      aWin[ nPosi ] [ AW_SORT ] := nSort
      FillWithDir( cForm, cObj, cNewPath, "TREEDN" )
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure NewTab()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+                                   1 - static procedure dogridkey1()
*+                                   1 - static procedure dogridkey2()
*+                                   1 - static procedure runwithparameter()
*+                                   2 - static procedure restoretab()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE NewTab( cDir )

LOCAL nStackNumber := 0
LOCAL cCaption     := "Page "
LOCAL cImageName   := "MYFIXDRIVE16"
LOCAL cObj, xObj

   // since v0.061
STATIC nPageLeft  := 1
STATIC nPageRight := 1

   HMG_CleanLastVirtualKeyDown()

   IF nGridFocus = 1
      nStackNumber := LEN( Stack_Left )

      IF PCOUNT() > 0

      ELSE
         IF nStackNumber > 0
            cDir := GridGetPath( "WinLeft", cGrid_Left )
         ELSE
            cDir := "C:\"
         ENDIF
      ENDIF

      nStackNumber ++
      cCaption += LTRIM( STR( nStackNumber ) )
      WinLeft.Tab_Left.AddPage( nStackNumber, cCaption, cImageName )

      nPageLeft ++
      cObj := "Grid_" + LTRIM( STR( nPageLeft ) )
      DefGridLeft( "WinLeft", cObj, nPageLeft )

      Domethod( "WinLeft", cObj, "DisableUpdate" )

      WinLeft.Tab_Left.AddControl( cObj, nStackNumber, 20, 0 )

      aDirTemp := ACLONE( aDir_Left )

      AADD( Stack_Left, ARRAY( 5 ) )
      nDimLeft := LEN( Stack_Left )
      cGrid_Left := cObj
      aColor_Left := {}
      aImage_Left := {}
      aFiles_Left := {}

      aDir_Left := ACLONE( aDirTemp )
      AADD( aWin, { "WinLeft", cObj, cDir, 1, 1, F_NAME, .F. } )

      SetProperty( "WinLeft", cObj, "ITEMCOUNT", 100 )                // LEN( aDir_Left )
      WinLeft.Tab_Left.Caption( nDimLeft ) := GetTabName( cDir )
      WinLeft.Tab_Left.Value := nDimLeft

      Domethod( "WinLeft", cObj, "EnableUpdate" )

      FillWithDir( "WinLeft", cObj, cDir, "TREEDN" )

      Tab_Change_Left()

   ELSE
      nStackNumber := LEN( Stack_Right )

      IF PCOUNT() > 0
      ELSE
         IF nStackNumber > 0
            cDir := GridGetPath( "WinRight", cGrid_Right )
         ELSE
            cDir := "C:\"
         ENDIF
      ENDIF

      nStackNumber ++
      cCaption += LTRIM( STR( nStackNumber ) )

      WinRight.Tab_Right.AddPage( nStackNumber, cCaption, cImageName )

      nPageRight ++
      cObj := "Grid_" + LTRIM( STR( nPageRight ) )
      DefGridRight( "WinRight", cObj, nPageRight )

      Domethod( "WinRight", cObj, "DisableUpdate" )

      WinRight.Tab_Right.AddControl( cObj, nStackNumber, 20, 0 )

      aDirTemp := ACLONE( aDir_Right )

      AADD( Stack_Right, ARRAY( 5 ) )
      nDimRight := LEN( Stack_Right )
      cGrid_Right := cObj
      aColor_Right := {}
      aImage_Right := {}
      aFiles_Right := {}

      aDir_Right := ACLONE( aDirTemp )
      AADD( aWin, { "WinRight", cObj, cDir, 1, 1, F_NAME, .F. } )

      SetProperty( "WinRight", cObj, "ITEMCOUNT", 100 )               // LEN( aDir_Right )
      WinRight.Tab_Right.Caption( nDimRight ) := GetTabName( cDir )
      WinRight.Tab_Right.Value := nDimRight

      Domethod( "WinRight", cObj, "EnableUpdate" )

      FillWithDir( "WinRight", cObj, cDir, "TREEDN" )

      Tab_Change_Right()
   ENDIF

   aDirTemp := NIL

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure Tab_Change_Left()
*+
*+    Called from ( askform.prg )   1 - function askform()
*+                ( fmgrid.prg )   1 - procedure dualgrid()
*+                                   1 - static procedure dogridkey1()
*+                                   1 - static procedure newtab()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE Tab_Change_Left()

LOCAL cObj, cPath, nDrive, cDrive, cText
LOCAL cForm := "WinLeft"
LOCAL hGrid, hHeader

   nDimLeft := WinLeft.Tab_Left.Value
   cObj := cGrid_Left

   cPath := GridGetPath( cForm, cObj )
   cDrive := SUBSTR( cPath, 1, 1 )
   SetActivPath( cPath )

   cText := GetVolumne( cDrive ) + " " + STR( HB_DISKSPACE( cDrive + ":" ) / 1024 / 1000 / 1000 ) + " Mb free of " + LTRIM( STR( HB_DISKSPACE( cDrive + ":", HB_DISK_TOTAL ) / 1024 / 1000 / 1000 ) ) + " Mb"
   SetProperty( "WinLeft", "VolInfo_Left", "VALUE", cText )

   nDrive := ASCAN( aDrives, { | e | e[ 2 ] = cDrive } )
   WinLeft.ComboLeft.Value := nDrive

   IF SP_DarkMode()
      hGrid := GetControlHandle( cObj, cForm )
      hHeader := ListView_GetHeader( hGrid )
   ENDIF

   Domethod( "WinLeft", cObj, "SetFocus" )

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure Tab_Change_Right()
*+
*+    Called from ( askform.prg )   1 - function askform()
*+                ( fmgrid.prg )   1 - procedure dualgrid()
*+                                   1 - static procedure dogridkey2()
*+                                   1 - static procedure newtab()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE Tab_Change_Right()

LOCAL cObj, cPath, nDrive, cDrive, cText
LOCAL cForm := "WinRight"
LOCAL hGrid, hHeader

   nDimRight := WinRight.Tab_Right.Value
   cObj := cGrid_Right

   cPath := GridGetPath( cForm, cObj )
   cDrive := SUBSTR( cPath, 1, 1 )
   SetActivPath( cPath )

   cText := GetVolumne( cDrive ) + " " + STR( HB_DISKSPACE( cDrive + ":" ) / 1024 / 1000 / 1000 ) + " Mb free of " + LTRIM( STR( HB_DISKSPACE( cDrive + ":", HB_DISK_TOTAL ) / 1024 / 1000 / 1000 ) ) + " Mb"
   SetProperty( "WinRight", "VolInfo_Right", "VALUE", cText )

   nDrive := ASCAN( aDrives, { | e | e[ 2 ] = cDrive } )
   WinRight.ComboRight.Value := nDrive

   IF SP_DarkMode()
      hGrid := GetControlHandle( cObj, cForm )
      hHeader := ListView_GetHeader( hGrid )
   ENDIF

   Domethod( "WinRight", cObj, "SetFocus" )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure TestTabKey()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE TestTabKey()

LOCAL nKey := HMG_VirtualKeyIsPressed( VK_CONTROL )
LOCAL nTab

   IF .NOT. EMPTY( nKey )
      RETURN
   ENDIF

   IF nGridFocus = 2
      Domethod( "WinLeft", cGrid_Left, "SetFocus" )
      nGridFocus := 1
   ELSE
      Domethod( "WinRight", cGrid_Right, "SetFocus" )
      nGridFocus := 2
   ENDIF

   HMG_CleanLastVirtualKeyDown()

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function IsKeyVK()
*+
*+    Called from ( fmgrid.prg )   9 - static procedure dogridkey1()
*+                                   8 - static procedure dogridkey2()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION IsKeyVK()

RETURN ( HMG_VirtualKeyIsPressed( VK_ALT ) .OR. HMG_VirtualKeyIsPressed( VK_CONTROL ) .OR. HMG_VirtualKeyIsPressed( VK_SHIFT ) )

*+--------------------------------------------------------------------
*+
*+    Procedure SbarText()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure zipit()
*+                                   4 - static procedure draghere()
*+                                   1 - procedure addfile2grid()
*+                                   1 - static procedure readydrag()
*+                                   1 - static procedure infogridchange1()
*+                                   1 - static procedure infogridchange2()
*+                ( hbdevice.prg )   1 - function onmousehover()
*+                ( thumbs.prg )   1 - procedure thumbs()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE SbarText( cText, cIcon )                                    // also hbdevice.prg

LOCAL hWnd := GetControlHandle( "StatusBar", "Win_1" )

   DEFAULT cText TO ""

   //  hWnd := Win_1.StatusBar.Item.handle

   DO CASE
      CASE EMPTY( cIcon )
         _SetStatusIcon( "StatusBar", "Win_1", 1, NIL )
         // BMP_FILL( hwnd, GRAY )

      CASE cIcon = "STARTNOW"
         //  Win_1.StatusBar.IconHandle (1) := LOADRESOURCE(0,"ICOSEARCH")
         _SetStatusIcon( "StatusBar", "Win_1", 1, "ICODEPART" )
         // BMP_FILL( hwnd, YELLOW )

      CASE cIcon = "ONFLY"                                            // OnMouseHover()
         _SetStatusIcon( "StatusBar", "Win_1", 1, "ICOONFLY" )
         // BMP_FILL( hwnd, GREEN )

      CASE cIcon = "ARRIVENOW"
         _SetStatusIcon( "StatusBar", "Win_1", 1, "ICOARRIVE" )
         // BMP_FILL( hwnd, YELLOW )
   ENDCASE

   Win_1.StatusBar.Item( 1 ) := cText

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure InfoGridChange1()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure defgridleft()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE InfoGridChange1( aData, nSide )

LOCAL cText, aItem, nItem, nSum := 0, oError
LOCAL bError := ERRORBLOCK( { | oErr | BREAK( oErr ) } )

STATIC aOld := {}

   IF LEN( aOld ) <> LEN( aData )
      aOld := ACLONE( aData )
      AEVAL( aData, { | o | nSum += o[ F_SIZE ] } )
      cText := LTRIM( STR( nSum / 1024 / 1000 ) ) + " Mb "
      SetTabStatusText( cText, nSide )
   ENDIF

   cText := GridGetPath( "WinLeft", cGrid_Left )
   SetActivPath( cText )

   BEGIN SEQUENCE
      aItem := GetProperty( "WinLeft", cGrid_Left, "Value" )
      IF LEN( aItem ) > 0
         nItem := aItem[ 1 ]
         cText := aDir_Left[ nItem, F_NAME ]
         SbarText( cText )
      ENDIF
   RECOVER USING oError
      ERRORBLOCK( bError )
      MsgInfo( oError:description + CRLF + oError:operation, "Error " + HB_VALTOSTR( oError:osCode ) )
   END SEQUENCE
   ERRORBLOCK( bError )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure InfoGridChange2()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure defgridright()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE InfoGridChange2( aData, nSide )

LOCAL cText, aItem, nItem, nSum := 0, oError
LOCAL bError := ERRORBLOCK( { | oErr | BREAK( oErr ) } )
STATIC aOld  := {}

   IF LEN( aOld ) <> LEN( aData )
      aOld := ACLONE( aData )
      AEVAL( aData, { | o | nSum += o[ F_SIZE ] } )
      cText := LTRIM( STR( nSum / 1024 / 1000 ) ) + " Mb "
      SetTabStatusText( cText, nSide )
   ENDIF

   cText := GridGetPath( "WinRight", cGrid_Right )
   SetActivPath( cText )

   BEGIN SEQUENCE
      aItem := GetProperty( "WinRight", cGrid_Right, "Value" )
      IF LEN( aItem ) > 0
         nItem := aItem[ 1 ]
         cText := aDir_Right[ nItem, F_NAME ]
         SbarText( cText )
      ENDIF
   RECOVER USING oError
      ERRORBLOCK( bError )
      MsgInfo( oError:description + CRLF + oError:operation, "Error " + HB_VALTOSTR( oError:osCode ) )
   END SEQUENCE
   ERRORBLOCK( bError )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure CompareDir()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+                                   1 - static procedure dogridkey1()
*+                                   1 - static procedure dogridkey2()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE CompareDir()

LOCAL aSource
LOCAL aTarget
LOCAL nPosi, cName, nSize, dDate, cAttr, cTime
LOCAL ii, iMax
LOCAL jj, jMax
LOCAL nState     := hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )
LOCAL nMask      := hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )
LOCAL aSoDMarked := {}
LOCAL aTaDMarked := {}
LOCAL cForm
LOCAL cObj
LOCAL hGridS
LOCAL hGridO

   DO CASE
      CASE nGridFocus = 1
         cForm := "WinLeft"
         cObj := cGrid_Left
         hGridS := GetControlHandle( cObj, cForm )
         SetProperty( "WinLeft", cObj, "Value", {} )

         cForm := "WinRight"
         cObj := cGrid_Right
         hGridO := GetControlHandle( cObj, cForm )
         SetProperty( "WinRight", cObj, "Value", {} )

         aSource := ACLONE( aDir_Left )
         aTarget := ACLONE( aDir_Right )

      CASE nGridFocus = 2
         cForm := "WinRight"
         cObj := cGrid_Right
         hGridS := GetControlHandle( cObj, cForm )
         SetProperty( "WinRight", cObj, "Value", {} )

         cForm := "WinLeft"
         cObj := cGrid_Left
         hGridO := GetControlHandle( cObj, cForm )
         SetProperty( "WinLeft", cObj, "Value", {} )

         aSource := ACLONE( aDir_Right )
         aTarget := ACLONE( aDir_Left )
   ENDCASE

   //  ------------------------------------------------------------------ *

   // first Target (while Focus stay on last)
   jMax := LEN( aTarget )
   FOR jj := 1 TO jMax
      cName := TRIM( aTarget[ jj ] [ F_NAME ] )
      nSize := aTarget[ jj ] [ F_SIZE ]
      dDate := aTarget[ jj ] [ F_DATE ]
      cTime := aTarget[ jj ] [ F_TIME ]
      cAttr := aTarget[ jj ] [ F_ATTR ]

      IF TRIM( cName ) = ".." .OR. TRIM( cName ) = "." .OR. "D" $ cAttr .OR. nSize < 2
         LOOP
      ENDIF

      // check if Source exist
      nPosi := ASCAN( aSource, { | x | LOWER( x[ F_NAME ] ) = LOWER( cName ) } )
      IF nPosi > 0
         DO CASE
            CASE aSource[ nPosi ] [ F_SIZE ] < 2                      // old Dummy files

            CASE nSize <> aSource[ nPosi ] [ F_SIZE ]                 // Target Size is different
               ItemMark( hGridO, jj, nState, nMask )
               AADD( aTaDMarked, jj )

            CASE dDate <> aSource[ nPosi ] [ F_DATE ]                 // Target Date is different
               ItemMark( hGridO, jj, nState, nMask )
               AADD( aTaDMarked, jj )

            CASE dDate = aSource[ nPosi ] [ F_DATE ]                  // Target Date is same
               IF HMS2Sec( cTime ) > HMS2Sec( aSource[ nPosi ] [ F_TIME ] ) + 2
                  ItemMark( hGridO, jj, nState, nMask )
                  AADD( aTaDMarked, jj )
               ENDIF

            OTHERWISE
               DiffCompare( TIME(), ii, aSource[ ii ], nPosi, aTarget[ nPosi ] )
         ENDCASE
      ELSE
         ItemMark( hGridO, jj, nState, nMask )
         AADD( aTaDMarked, jj )
      ENDIF
   NEXT

   IF EMPTY( aTaDMarked )
      ItemUnMark( hGridO, - 1, 0, LVIS_FOCUSED )
   ENDIF

   //  ------------------------------------------------------------------ *

   // now Source. Focus stay on last which is Source
   iMax := LEN( aSource )
   FOR ii := 1 TO iMax
      cName := TRIM( aSource[ ii ] [ F_NAME ] )
      nSize := aSource[ ii ] [ F_SIZE ]
      dDate := aSource[ ii ] [ F_DATE ]
      cTime := aSource[ ii ] [ F_TIME ]
      cAttr := aSource[ ii ] [ F_ATTR ]

      // not want
      IF TRIM( cName ) = ".." .OR. TRIM( cName ) = "." .OR. "D" $ cAttr .OR. nSize < 2
         LOOP
      ENDIF

      // check if Target exist
      nPosi := ASCAN( aTarget, { | x | LOWER( x[ F_NAME ] ) = LOWER( cName ) } )
      IF nPosi > 0
         DO CASE
            CASE aTarget[ nPosi ] [ F_SIZE ] < 2                      // old Dummy files

            CASE nSize <> aTarget[ nPosi ] [ F_SIZE ]                 // Source Size is different
               ItemMark( hGridS, ii, nState, nMask )
               AADD( aSoDMarked, ii )

            CASE dDate <> aTarget[ nPosi ] [ F_DATE ]                 // Source Date is different
               ItemMark( hGridS, ii, nState, nMask )
               AADD( aSoDMarked, ii )

            CASE dDate = aTarget[ nPosi ] [ F_DATE ]                  // Source Date is same

               // check if Source Time is newer
               IF HMS2Sec( cTime ) > HMS2Sec( aTarget[ nPosi ] [ F_TIME ] ) + 2
                  ItemMark( hGridS, ii, nState, nMask )
                  AADD( aSoDMarked, ii )
               ENDIF

            OTHERWISE                                                 // else ... when ?
               DiffCompare( TIME(), ii, aSource[ ii ], nPosi, aTarget[ nPosi ] )
         ENDCASE
      ELSE
         // get New File Position and mark it
         ItemMark( hGridS, ii, nState, nMask )
         AADD( aSoDMarked, ii )
      ENDIF
   NEXT

   IF EMPTY( aSoDMarked )
      ItemUnMark( hGridS, - 1, 0, LVIS_FOCUSED )
   ENDIF

   //  ------------------------------------------------------------------ *

   IF LEN( aSoDMarked ) = 0 .AND. LEN( aTaDMarked ) = 0
      MSGInfo( "no difference", "compare" )
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure CheckOtherSide()
*+
*+    Called from ( fmgrid.prg )   2 - static procedure change2drive()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE CheckOtherSide( cForm, cNewPath, cDrive )

LOCAL cObj, cPath
   DO CASE
      CASE cForm = "WinLeft"
         cObj := cGrid_Left
      CASE cForm = "WinRight"
         cObj := cGrid_Right
   ENDCASE
   cPath := GridGetPath( cForm, cObj )
   IF SUBSTR( cPath, 1, 1 ) = cDrive
      cNewPath := cPath + "\"
      cNewPath := STRTRAN( cNewPath, "\\", "\" )
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SetTabStatusText()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure infogridchange1()
*+                                   1 - static procedure infogridchange2()
*+                                   1 - static procedure domarkfiles()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SetTabStatusText( cText, nSide )

   IF nSide = 1
      SetProperty( "WinLeft", "TabStatus_Left", "Value", cText )
   ELSE
      SetProperty( "WinRight", "TabStatus_Right", "Value", cText )
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoAuswahl()
*+
*+    Called from ( fmgrid.prg )   2 - static procedure dogridkey1()
*+                                   2 - static procedure dogridkey2()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoAuswahl( nNo, cIn )

   Auswahl( cIn )
   DoMarkFiles( nNo, cIn )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure PreFuncSysFolder()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+                                   1 - static procedure dogridkey1()
*+                                   1 - static procedure dogridkey2()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE PreFuncSysFolder()

LOCAL cNewPath := ""

   SP_NewPath()
   FuncSysFolder()

   cNewPath := SP_NewPath()
   IF !EMPTY( cNewPath )
      IF nGridFocus = 1
         FillWithDir( "WinLeft", cGrid_Left, cNewPath, "TREEDN" )
      ELSE
         FillWithDir( "WinRight", cGrid_Right, cNewPath, "TREEDN" )
      ENDIF

   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure PreFuncMSCFolder()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE PreFuncMSCFolder()

LOCAL cNewPath := ""
   SP_GetWahl( "" )
   FuncMSCFolder()

   cNewPath := SP_GetWahl()
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoMarkFiles()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure doauswahl()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoMarkFiles( nNo, cAction )

LOCAL cSeek      := SP_GetWahl()
LOCAL aDir
LOCAL lAdd       := .T.
LOCAL nPosi, cFile, nSum := 0
LOCAL i, iMax
LOCAL cForm, cObj, cText
LOCAL aSource, cPath, hGrid
LOCAL aHMGselect := {}

   DO CASE
      CASE nNo = 1
         cForm := "WinLeft"
         cObj := cGrid_Left
         hGrid := GetControlHandle( cObj, cForm )
         aSource := ACLONE( aDir_Left )
      CASE nNo = 2
         cForm := "WinRight"
         cObj := cGrid_Right
         hGrid := GetControlHandle( cObj, cForm )
         aSource := ACLONE( aDir_Right )
   ENDCASE
   cPath := GridGetPath( cForm, cObj )

   aDir := DIRECTORY( cPath + "\" + cSeek, "DHS" )
   iMax := LEN( aDir )

   DO CASE
      CASE cAction = "ADD"
         lAdd := .T.
      CASE cAction = "SUBTRACT"
         lAdd := .F.
   ENDCASE

   Domethod( cForm, cObj, "SetFocus" )
   Domethod( cForm, cObj, "DisableUpdate" )

   FOR i := 1 TO iMax
      cFile := aDir[ i ] [ F_NAME ]
      nSum += aDir[ i ] [ F_SIZE ]
      nPosi := ASCAN( aSource, { | o | LOWER( o[ F_NAME ] ) = LOWER( cFile ) } )
      IF nPosi > 1
#IFDEF Use_LVStyle
         IF lAdd = .T.
            ItemMark( hGrid, nPosi )
         ELSE
            ItemUnMark( hGrid, nPosi )
         ENDIF
#ELSE
         IF lAdd = .T.
            AADD( aHMGselect, nPosi )
         ENDIF
#ENDIF
      ENDIF
   NEXT

   IF lAdd = .T.
      cText := "Select " + LTRIM( STR( nSum / 1024 / 1000 ) ) + " Mb "
   ELSE
      cText := ""
   ENDIF
   SetTabStatusText( cText, nNo )

#IFDEF Use_LVStyle
#ELSE
   SetProperty( cForm, cObj, "Value", aHMGselect )
#ENDIF

   Domethod( cForm, cObj, "EnableUpdate" )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure ChangeLeftRight()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+                                   1 - static procedure dogridkey1()
*+                                   1 - static procedure dogridkey2()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ChangeLeftRight()

LOCAL nDrive
LOCAL cDir1  := GridGetPath( "WinLeft", cGrid_Left )
LOCAL cDir2  := GridGetPath( "WinRight", cGrid_Right )

   FillWithDir( "WinLeft", cGrid_Left, cDir2, "TREEDN" )
   FillWithDir( "WinRight", cGrid_Right, cDir1, "TREEDN" )

   SP_LWTextLeft( cDir2 )
   SP_LWTextRight( cDir1 )

   aDrives := GetDrives()

   nDrive := ASCAN( aDrives, { | e | e[ 2 ] = SUBSTR( SP_LWTextLeft(), 1, 1 ) } )
   WinLeft.ComboLeft.Value := nDrive

   nDrive := ASCAN( aDrives, { | e | e[ 2 ] = SUBSTR( SP_LWTextRight(), 1, 1 ) } )
   WinRight.ComboRight.Value := nDrive

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DataViewer()
*+
*+    Called from ( fmgrid.prg )   4 - procedure dualgrid()
*+                                   2 - static procedure dogridkey1()
*+                                   2 - static procedure dogridkey2()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DataViewer( lEdit )

LOCAL cForm, cObj
LOCAL aItem, nItem
LOCAL cPath, cText, cExt

   DO CASE
      CASE nGridFocus = 1
         cForm := "WinLeft"
         cObj := cGrid_Left

      CASE nGridFocus = 2
         cForm := "WinRight"
         cObj := cGrid_Right
   ENDCASE

   aItem := GetProperty( cForm, cObj, "Value" )
   IF LEN( aItem ) > 0
      nItem := aItem[ 1 ]
      cPath := GridGetPath( cForm, cObj )

      DO CASE
         CASE nGridFocus = 1
            cText := aDir_Left[ nItem, F_NAME ]
         CASE nGridFocus = 2
            cText := aDir_Right[ nItem, F_NAME ]
      ENDCASE

      cPath += "\"
      cPath := STRTRAN( cPath, "\\", "\" )

      cExt := UPPER( FindExt( cText ) )

      DO CASE
         CASE cExt $ ".PRG.FMG.TXT.BAT.CH.LOG.HBP.HBC.HBM.RC.HDR.INI.ARC.XPJ.CPP.BAK.SDF.CSV"
            TXT_Edit( cPath + cText, lEdit )

         CASE cExt $ ".PDF.EPUB.MOBI.FB2.CHM.XPS.DJVU"
            ShowPDF( cPath, cText, cObj )

         CASE ".DBF" $ UPPER( cText )
            Pre_BrowseView( cPath, cText, lEdit )

         CASE ".RTF" $ UPPER( cText )
            RTF_Edit( cPath + cText, lEdit )

         CASE cExt $ ".BMP.GIF.JPG.JPEG.TIF.TIFF.WMF.EMF.PNG"
            Image_Edit( cPath, cText, 0, lEdit )

         CASE cExt $ ".HTM.HTML"
            //  ShowHTML(cPath + cText)
            TXT_Edit( cPath + cText )

         CASE cExt $ ".H.C."
            TXT_Edit( cPath + cText, lEdit )

         CASE cExt $ ".XLS.XLSX"
            //  ADO_VIEW( cPath + cText )
            pBarForm( "ADO_VIEW('" + cPath + cText + "')" )
      ENDCASE
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure Pre_BrowseView()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure dataviewer()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Pre_BrowseView( cPath, cText, lEdit )

LOCAL nLen

#IFDEF Use_HB_Thread                             // unused
   AADD( aBroThread, {} )
   nLen := LEN( aBroThread )
   aBroThread[ nLen ] := hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @BrowseView(), cPath, cText, lEdit )
   AttachThreadInput( nMainThreadID, HMG_ThreadHBtoWinID( aBroThread[ nLen ] ), .T. )
#ELSE
   BrowseView( cPath, cText, lEdit )
#ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure CheckTabView()
*+
*+    Called from ( hbdevice.prg )   1 - procedure wait4action()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE CheckTabView()                                              // called from wait4action()

LOCAL cDir, nDrive

   aDrives := GetDrives()

   IF nGridFocus = 1
      cDir := GridGetPath( "WinLeft", cGrid_Left )
      nDrive := ASCAN( aDrives, { | e | e[ 2 ] = SUBSTR( cDir, 1, 1 ) } )
      IF nDrive > 0
      ELSE
         cDir := "C:\"
         nDrive := 1
      ENDIF
      SetProperty( "WinLeft", "ComboLeft", "VALUE", nDrive )

   ELSE
      cDir := GridGetPath( "WinRight", cGrid_Right )
      nDrive := ASCAN( aDrives, { | e | e[ 2 ] = SUBSTR( cDir, 1, 1 ) } )
      IF nDrive > 0
      ELSE
         cDir := "C:\"
         nDrive := 1
      ENDIF
      SetProperty( "WinRight", "ComboRight", "VALUE", nDrive )
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SearchForm()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+                                   1 - static procedure dogridkey1()
*+                                   1 - static procedure dogridkey2()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SearchForm( nNo )

LOCAL cPath, nPosi, hGrid
LOCAL cNewPath := ""
LOCAL cNewFile := ""
LOCAL cForm, cObj, cStart, aDir

   IF nNo = 1
      cForm := "WinLeft"
      cObj := cGrid_Left
      aDir := aDir_Left
   ELSE
      cForm := "WinRight"
      cObj := cGrid_Right
      aDir := aDir_Right
   ENDIF
   cStart := GridGetPath( cForm, cObj )

   IF SP_lRunGoToDir() = .T.

   ELSE
      SP_cGoToDir( "" )
      HBEVERY( cStart )
      cPath := SP_cGoToDir()
      IF !EMPTY( cPath )
         nPosi := RAT( "\", cPath )
         IF nPosi > 0
            cNewPath := SUBSTR( cPath, 1, nPosi )
            cNewFile := SUBSTR( cPath, nPosi + 1 )
         ENDIF
      ENDIF

      IF !EMPTY( cNewPath )
         FillWithDir( cForm, cObj, cNewPath, "TREEDN" )

         nPosi := ASCAN( aDir, { | e | e[ F_NAME ] = cNewFile } )
         IF nPosi > 0
            hGrid := GetControlHandle( cObj, cForm )
            ItemMark( hGrid, nPosi )
         ENDIF
      ENDIF
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure UpDirPath()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE UpDirPath( nNo )

LOCAL cPath
LOCAL cNewPath
LOCAL cForm, cObj

   IF nNo = 1
      cPath := GridGetPath( "WinLeft", cGrid_Left )
      cForm := "WinLeft"
      cObj := cGrid_Left
   ELSE
      cPath := GridGetPath( "WinRight", cGrid_Right )
      cForm := "WinRight"
      cObj := cGrid_Right
   ENDIF

   cNewPath := UpPath( cPath )
   FillWithDir( cForm, cObj, cNewPath, "TREEUP" )
   DO EVENTS
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure RootUpDirPath()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE RootUpDirPath( nNo )

LOCAL cPath, cTest, nPosi, cDir
LOCAL cNewPath, aNewDir
LOCAL cForm, cObj

   IF nNo = 1
      cPath := GridGetPath( "WinLeft", cGrid_Left )
      cForm := "WinLeft"
      cObj := cGrid_Left
   ELSE
      cPath := GridGetPath( "WinRight", cGrid_Right )
      cForm := "WinRight"
      cObj := cGrid_Right
   ENDIF

   // test last Sub-Dir
   cNewPath := cPath
   DO WHILE .T.
      cTest := UpPath( cNewPath )
      IF EMPTY( cTest )
         EXIT
      ENDIF
      IF LEN( cTest ) > 3
         cNewPath := cTest
      ELSE
         EXIT
      ENDIF
   ENDDO
   // last Sub-Dir
   cDir := GetTabName( cNewPath )

   // Root-Path
   cNewPath := SUBSTR( cPath, 1, 3 )
   FillWithDir( cForm, cObj, cNewPath, "TREEDN" )

   // new Position
   IF nNo = 1
      aNewDir := ACLONE( aDir_Left )
   ELSE
      aNewDir := ACLONE( aDir_Right )
   ENDIF
   nPosi := ASCAN( aNewDir, { | o | o[ F_NAME ] = cDir } )
   SetProperty( cForm, cObj, "Value", { nPosi } )

   DO EVENTS
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure CloseTab()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+                                   1 - static procedure dogridkey1()
*+                                   1 - static procedure dogridkey2()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE CloseTab( nNo )

LOCAL nDimStack, cForm, cObj, nPosi, cDir, nDrive

   IF nNo = 1
      IF LEN( Stack_Left ) > 1
         nDimStack := WinLeft.Tab_Left.Value

         cForm := "WinLeft"
         cObj := cGrid_Left

         Domethod( cForm, cObj, "Release" )
         WinLeft.Tab_Left.DeletePage( nDimStack )

         ADEL( Stack_Left, nDimStack )
         ASIZE( Stack_Left, LEN( Stack_Left ) - 1 )
         nDimLeft := LEN( Stack_Left )

      ENDIF
      cDir := GridGetPath( "WinLeft", cGrid_Left )
      nDrive := ASCAN( aDrives, { | e | e[ 2 ] = SUBSTR( cDir, 1, 1 ) } )
      SetProperty( "WinLeft", "ComboLeft", "VALUE", nDrive )

   ELSE
      IF LEN( Stack_Right ) > 1
         nDimStack := WinRight.Tab_Right.Value

         cForm := "WinRight"
         cObj := cGrid_Right

         Domethod( cForm, cObj, "Release" )
         WinRight.Tab_Right.DeletePage( nDimStack )

         ADEL( Stack_Right, nDimStack )
         ASIZE( Stack_Right, LEN( Stack_Right ) - 1 )
         nDimRight := LEN( Stack_Right )

      ENDIF
      cDir := GridGetPath( "WinRight", cGrid_Right )
      nDrive := ASCAN( aDrives, { | e | e[ 2 ] = SUBSTR( cDir, 1, 1 ) } )
      SetProperty( "WinRight", "ComboRight", "VALUE", nDrive )
   ENDIF

   nPosi := ASCAN( aWin, { | x | x[ AW_FORM ] = cForm .AND. x[ AW_OBJ ] = cObj } )
   IF nPosi > 0
      ADEL( aWin, nPosi )
      ASIZE( aWin, LEN( aWin ) - 1 )
   ENDIF

   IF nNo = 1
      FillWithDir( "WinLeft", cGrid_Left, cDir, "TREEDN" )
   ELSE
      FillWithDir( "WinRight", cGrid_Right, cDir, "TREEDN" )
   ENDIF
   DO EVENTS

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SelFolder()
*+
*+    Called from ( fmgrid.prg )   6 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SelFolder( nNo )

LOCAL cNewPath
LOCAL cTitle    := "change Folder"
LOCAL cInitPath

   IF nNo = 1
      IF nGridFocus = 1
         cInitPath := GridGetPath( "WinLeft", cGrid_Left )
      ELSE
         cInitPath := GridGetPath( "WinRight", cGrid_Right )
      ENDIF
   ELSE
      IF nGridFocus = 1
         cInitPath := GridGetPath( "WinRight", cGrid_Right )
      ELSE
         cInitPath := GridGetPath( "WinLeft", cGrid_Left )
      ENDIF
   ENDIF

   cNewPath := GetFolder( cTitle, cInitPath )

   IF !EMPTY( cNewPath )

      cNewPath += "\"
      IF nNo = 1
         IF nGridFocus = 1
            FillWithDir( "WinLeft", cGrid_Left, cNewPath, "TREEDN" )
         ELSE
            FillWithDir( "WinRight", cGrid_Right, cNewPath, "TREEDN" )
         ENDIF
      ELSE
         IF nGridFocus = 1
            FillWithDir( "WinRight", cGrid_Right, cNewPath, "TREEDN" )
         ELSE
            FillWithDir( "WinLeft", cGrid_Left, cNewPath, "TREEDN" )
         ENDIF
      ENDIF
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SetActivPath()
*+
*+    Called from ( fmgrid.prg )   1 - procedure tab_change_left()
*+                                   1 - procedure tab_change_right()
*+                                   1 - static procedure infogridchange1()
*+                                   1 - static procedure infogridchange2()
*+                                   1 - static procedure gridgotfocus()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SetActivPath( cText )

   Win_1.PathInfo.Value := cText
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function GetActivPath()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure runcmdbox()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GetActivPath()

LOCAL cText
   cText := Win_1.PathInfo.Value
RETURN cText

*+--------------------------------------------------------------------
*+
*+    Static Procedure GridGotFocus()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure defgridleft()
*+                                   1 - static procedure defgridright()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE GridGotFocus( nNo )

LOCAL cPath
LOCAL cForm

   lActiveMain = .T.
   IF nNo = 1
      nGridFocus := 1
      nDimLeft := WinLeft.Tab_Left.Value
      cForm := "WinLeft"
      cPath := GridGetPath( "WinLeft", cGrid_Left )
   ELSE
      nGridFocus := 2
      nDimRight := WinRight.Tab_Right.Value
      cForm := "WinRight"
      cPath := GridGetPath( "WinRight", cGrid_Right )
   ENDIF
   SetActivPath( cPath )

   WatchDirSwitch( cForm, cPath )
   DO EVENTS

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure WatchDirSwitch()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure gridgotfocus()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE WatchDirSwitch( cForm, cNewPath )

   SP_lDirWatch( .F. )
   ondummy( TIME(), "WatchDirSwitch", cNewPath, PROCNAME( 1 ), PROCLINE( 1 ), PROCNAME( 2 ), PROCLINE( 2 ) )

   //  MemoWrit( cNewPath+"Threadquit.$$$", "EOT now" )
#IFDEF Use_Thread

   DO CASE
      CASE cForm = "WinLeft"
         //  hb_threadDetach( hb_threadStart( HB_THREAD_INHERIT_MEMVARS, @WatchDirLeft(), cNewPath ) )
         //  hb_threadDetach( hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @WatchDirLeft(), cNewPath ) )

         IF aWatchThread[ 1 ] <> NIL
            hb_threadDetach( aWatchThread[ 1 ] )
            // hb_threadQuitRequest( aWatchThread[ 1 ] )                      // terminate thread
         ENDIF
         //  aWatchThread[ 1 ] :=  hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @WatchDirLeft(), cNewPath )
         aWatchThread[ 1 ] := hb_threadStart( HB_BITOR( HB_THREAD_INHERIT_PUBLIC, HB_THREAD_MEMVARS_COPY ), @WatchDirLeft(), cNewPath )

         //  AttachThreadInput( nMainThreadID, HMG_ThreadHBtoWinID( aWatchThread[ 1 ] ), .T. )

      CASE cForm = "WinRight"
         //  hb_threadDetach( hb_threadStart( HB_THREAD_INHERIT_MEMVARS, @WatchDirRight(), cNewPath ) )
         //  hb_threadDetach( hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @WatchDirRight(), cNewPath ) )

         IF aWatchThread[ 2 ] <> NIL
            hb_threadDetach( aWatchThread[ 2 ] )
            // hb_threadQuitRequest( aWatchThread[ 2 ] )                      // terminate thread
         ENDIF
         //  aWatchThread[ 2 ] :=  hb_threadStart( HB_THREAD_INHERIT_PUBLIC, @WatchDirRight(), cNewPath )
         aWatchThread[ 2 ] := hb_threadStart( HB_BITOR( HB_THREAD_INHERIT_PUBLIC, HB_THREAD_MEMVARS_COPY ), @WatchDirRight(), cNewPath )

         //  AttachThreadInput( nMainThreadID, HMG_ThreadHBtoWinID( aWatchThread[ 2 ] ), .T. )
   ENDCASE

#ENDIF

   SP_lDirWatch( .T. )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure ItemMark()
*+
*+    Called from ( fmgrid.prg )   2 - procedure fill1stgrid()
*+                                   1 - static procedure dogridkey1()
*+                                   1 - static procedure dogridkey2()
*+                                   1 - static procedure change2drive()
*+                                   1 - static procedure fillwithdir()
*+                                   8 - static procedure comparedir()
*+                                   1 - static procedure domarkfiles()
*+                                   1 - static procedure searchform()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ItemMark( hGrid, nPos, nState, nMask )

   DEFAULT nState TO hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )
   DEFAULT nMask TO hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )

   LISTVIEW_SETITEMSTATE( hGrid, nPos, nState, nMask )
   ListView_EnsureVisible( hGrid, nPos, .T. )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure ItemUnMark()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure zipit()
*+                                   2 - static procedure comparedir()
*+                                   1 - static procedure domarkfiles()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ItemUnMark( hGrid, nPos, nState, nMask )

   DEFAULT nState TO hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )
   DEFAULT nMask TO hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )

   LISTVIEW_SETITEMSTATE( hGrid, nPos, 0, nMask )
   ListView_EnsureVisible( hGrid, nPos, .T. )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure UnMarkAll()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure dogridkey1()
*+                                   1 - static procedure dogridkey2()
*+                                   1 - procedure markfromthumbs()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE UnMarkAll( hGrid, lAll )

LOCAL iMax
LOCAL nCount := 0
LOCAL nSel
LOCAL nState := hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )
LOCAL nMask  := hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )

   DEFAULT lAll TO .T.

   // zurest den markierten
   nSel := ListView_GetSelectionMark( hGrid )
   LISTVIEW_SETITEMSTATE( hGrid, nSel, 0, nMask )

   iMax := ListView_GetSelectedCount( hGrid )
   IF iMax > 0
      nSel := ListView_GetNextItem( hGrid, - 1, LVNI_SELECTED )
      LISTVIEW_SETITEMSTATE( hGrid, nSel, 0, nMask )

      DO WHILE .T.
         nSel := ListView_GetNextItem( hGrid, nSel, LVNI_SELECTED )
         nCount ++
         IF nSel > 0
            LISTVIEW_SETITEMSTATE( hGrid, nSel, 0, nMask )
         ELSE
            EXIT
         ENDIF
         IF nCount > iMax
            EXIT
         ENDIF
      ENDDO
   ENDIF

   DO EVENTS

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure RunCMDBox()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE RunCMDBox()

LOCAL cNewPath, oError
LOCAL cValue   := Win_1.CMDBox.Value
LOCAL bError   := ERRORBLOCK( { | oErr | BREAK( oErr ) } )
LOCAL cCMD     := "CMD.EXE "
LOCAL lRet     := .F.
LOCAL cCommand := GETENV( "COMSPEC" ) + " /C "

   IF !EMPTY( cCMD )
      SP_lDirWatch( .F. )
      BEGIN SEQUENCE
         EXECUTE FILE( cCommand + CHR( 34 ) + cValue + CHR( 34 ) ) WAIT
         lRet := .T.
      RECOVER USING oError
         ERRORBLOCK( bError )
         MsgInfo( oError:description + CRLF + oError:operation, "Error " + HB_VALTOSTR( oError:osCode ) )
      END SEQUENCE
      ERRORBLOCK( bError )
      SP_lDirWatch( .T. )
   ENDIF

   IF lRet = .F.
      MsgInfo( "Error : " + cValue )
   ELSE
      Win_1.CMDBox.Value := ""

      cNewPath := GetActivPath()
      DO CASE
         CASE cNewPath = GridGetPath( "WinLeft", cGrid_Left )
            FillWithDir( "WinLeft", cGrid_Left, cNewPath, "TREEDN" )
         CASE cNewPath = GridGetPath( "WinRight", cGrid_Right )
            FillWithDir( "WinRight", cGrid_Right, cNewPath, "TREEDN" )
      ENDCASE
   ENDIF
   DO EVENTS

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure ReleaseDelKey()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ReleaseDelKey( nNo )

   IF nNo = 1
      lActiveMain = .F.
   ELSE
      lActiveMain = .T.
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DelTemp_FI_BMP()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure savesetup()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DelTemp_FI_BMP()

LOCAL cTemp    := GetTempFolder()
LOCAL aTempDir := DIRECTORY( cTemp + "FI_*.BMP" )
LOCAL ii, iMax := LEN( aTempDir )

   FOR ii := 1 TO iMax
      FERASE( cTemp + aTempDir[ ii ] [ F_NAME ] )
   NEXT
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure CloseAllThread()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure savesetup()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE CloseAllThread()

LOCAL i

   FOR i := 1 TO LEN( aThread )
      IF aThread[ i ] <> NIL
         hb_threadDetach( aThread[ i ] )                              // close thread handle
         hb_threadQuitRequest( aThread[ i ] )                         // terminate thread
         aThread[ i ] := NIL
      ENDIF
   NEXT

   i := 1
   FOR i := 1 TO LEN( aShThread )
      IF aShThread[ i ] <> NIL
         hb_threadDetach( aShThread[ i ] )                            // close thread handle
         hb_threadQuitRequest( aShThread[ i ] )                       // terminate thread
         aShThread[ i ] := NIL
      ENDIF
   NEXT

   i := 1
   FOR i := 1 TO LEN( aSysIcons )
      IF aSysIcons[ i ] <> NIL
         hb_threadDetach( aSysIcons[ i ] )                            // close thread handle
         hb_threadQuitRequest( aSysIcons[ i ] )                       // terminate thread
         aSysIcons[ i ] := NIL
      ENDIF
   NEXT

   i := 1
   FOR i := 1 TO LEN( aBroThread )
      IF aBroThread[ i ] <> NIL
         hb_threadDetach( aBroThread[ i ] )                           // close thread handle
         hb_threadQuitRequest( aBroThread[ i ] )                      // terminate thread
         aBroThread[ i ] := NIL
      ENDIF
   NEXT

   FOR i := 1 TO LEN( aWatchThread )
      IF aWatchThread[ i ] <> NIL
         hb_threadDetach( aWatchThread[ i ] )                         // close thread handle
         hb_threadQuitRequest( aWatchThread[ i ] )                    // terminate thread
         aWatchThread[ i ] := NIL
      ENDIF
   NEXT

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure AddBackLog()
*+
*+    Called from ( fmgrid.prg )   2 - static procedure fillwithdir()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE AddBackLog( nNo, cDir )

   IF nNo = 1
      AADD( aBack_Left, cDir )
   ELSE
      AADD( aBack_Right, cDir )
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure ShowHistory()
*+
*+    Called from ( fmgrid.prg )   4 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ShowHistory()

LOCAL i, nCount, aItems
LOCAL nTitlebar := GETTITLEHEIGHT()

   IF nGridFocus = 1
      aItems := ACLONE( aBack_Left )
   ELSE
      aItems := ACLONE( aBack_Right )
   ENDIF

   DEFINE WINDOW ShowBackList ;
      AT 0, 0 ;
      WIDTH 600 HEIGHT 600 ;
      TITLE 'Last visit Folder' ;
      ICON "ICOHISTORY" ;
      ON MAXIMIZE DoReSizeBackList( ThisWindow.Name ) ;
      ON SIZE DoReSizeBackList( ThisWindow.Name ) ;
      BACKCOLOR SP_nColor1()

   DEFINE LISTBOX List_BackDir
      PARENT ShowBackList
      ROW 5
      COL 5
      WIDTH 570
      HEIGHT 570 - nTitlebar
      ITEMS {}
      VALUE 1
      FONTNAME SP_cFontName()
      FONTSIZE SP_nFontlarge()
      TOOLTIP ""
      BACKCOLOR SP_nColor9()
      FONTCOLOR SP_nColor10()
      ONDBLCLICK Back2Dirlist()
      TABSTOP .T.
      VISIBLE .T.
      SORT .F.
      MULTISELECT .F.
      DRAGITEMS .F.
   END LISTBOX
   END WINDOW

   nCount := LEN( aItems )
   FOR i := 1 TO nCount
      DoMethod( "ShowBackList", "List_BackDir", "AddItem", aItems[ i ] )
   NEXT

   SetProperty( "ShowBackList", "List_BackDir", "Value", nCount )

   ON KEY ESCAPE OF ShowBackList ACTION Domethod( "ShowBackList", "Release" )
   CENTER WINDOW ShowBackList
   ACTIVATE WINDOW ShowBackList

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure Back2Dirlist()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure showhistory()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Back2Dirlist()

LOCAL nRow, cNewPath

   nRow := GetProperty( "ShowBackList", "List_BackDir", "Value" )
   IF nRow > 0
      cNewPath := GetProperty( "ShowBackList", "List_BackDir", "Item", nRow )

      IF nGridFocus = 1
         FillWithDir( "WinLeft", cGrid_Left, cNewPath, "TREEDN" )
      ELSE
         FillWithDir( "WinRight", cGrid_Right, cNewPath, "TREEDN" )
      ENDIF

   ENDIF

   Domethod( "ShowBackList", "Release" )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoReSizeBackList()
*+
*+    Called from ( fmgrid.prg )   2 - static procedure showhistory()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoReSizeBackList( fMain )

LOCAL mainRow    := GetProperty( fMain, 'Row' )
LOCAL mainCol    := GetProperty( fMain, 'Col' )
LOCAL mainWidth  := GetProperty( fMain, 'Width' )
LOCAL mainHeight := GetProperty( fMain, 'Height' )
LOCAL nBorder    := GETBORDERWIDTH()
LOCAL nTitlebar  := GETTITLEHEIGHT()

   Setproperty( fMain, "List_BackDir", "Width", mainWidth - 30 )
   Setproperty( fMain, "List_BackDir", "Height", mainHeight - nTitlebar - 30 )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SaveSetup()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SaveSetup( luseParameter )

LOCAL cAppData := GETENV( "APPDATA" ) + "\HMG"
LOCAL cFile    := cAppData + "\FMSETUP.DBF"
LOCAL aPos     := { 0, 0 }
LOCAL aSize    := { 0, 0 }
LOCAL aCol
LOCAL hGrid, i, iMax := 5                                             // both same lenght
LOCAL cText
LOCAL cObj
LOCAL aTabs1   := {}
LOCAL aTabs2   := {}

   DEFAULT luseParameter TO .F.

   Domethod( "Win_1", "Restore" )

   aPos[ 1 ] := GetProperty( "Win_1", 'Row' )
   aPos[ 2 ] := GetProperty( "Win_1", 'Col' )
   aSize[ 1 ] := GetProperty( "Win_1", 'Width' )
   aSize[ 2 ] := GetProperty( "Win_1", 'Height' )

   IF luseParameter = .T.
      RETURN
   ENDIF

   IF lDebug = .T.
      SET ALTER TO
   ENDIF

   CLOSE DATABASE
   USE (cFile) VIA "DBFCDX" NEW EXCLUSIVE

   REPLACE FMSETUP->XPOS WITH aPos[ 1 ]
   REPLACE FMSETUP->YPOS WITH aPos[ 2 ]
   REPLACE FMSETUP->XSIZE WITH aSize[ 1 ]
   REPLACE FMSETUP->YSIZE WITH aSize[ 2 ]

   iMax := 5
   aCol := {}
   hGrid := GetControlHandle( cGrid_Left, "WinLeft" )
   i := 1
   FOR i := 1 TO iMax
      AADD( aCol, LISTVIEW_GETCOLUMNWIDTH( hGrid, i - 1 ) )
   NEXT
   REPLACE FMSETUP->LWLCOL1 WITH aCol[ 1 ]
   REPLACE FMSETUP->LWLCOL2 WITH aCol[ 2 ]
   REPLACE FMSETUP->LWLCOL3 WITH aCol[ 3 ]
   REPLACE FMSETUP->LWLCOL4 WITH aCol[ 4 ]
   REPLACE FMSETUP->LWLCOL5 WITH aCol[ 5 ]

   iMax := 5
   aCol := {}
   i := 1
   hGrid := GetControlHandle( cGrid_Right, "WinRight" )
   FOR i := 1 TO iMax
      AADD( aCol, LISTVIEW_GETCOLUMNWIDTH( hGrid, i - 1 ) )
   NEXT
   REPLACE FMSETUP->LWRCOL1 WITH aCol[ 1 ]
   REPLACE FMSETUP->LWRCOL2 WITH aCol[ 2 ]
   REPLACE FMSETUP->LWRCOL3 WITH aCol[ 3 ]
   REPLACE FMSETUP->LWRCOL4 WITH aCol[ 4 ]
   REPLACE FMSETUP->LWRCOL5 WITH aCol[ 5 ]

   REPLACE FMSETUP->COLOR1 WITH RGB2Num( SP_nColor1( ) )
   REPLACE FMSETUP->COLOR2 WITH RGB2Num( SP_nColor2( ) )
   REPLACE FMSETUP->COLOR3 WITH RGB2Num( SP_nColor3( ) )
   REPLACE FMSETUP->COLOR4 WITH RGB2Num( SP_nColor4( ) )
   REPLACE FMSETUP->COLOR5 WITH RGB2Num( SP_nColor5( ) )
   REPLACE FMSETUP->COLOR6 WITH RGB2Num( SP_nColor6( ) )
   REPLACE FMSETUP->COLOR7 WITH RGB2Num( SP_nColor7( ) )
   REPLACE FMSETUP->COLOR8 WITH RGB2Num( SP_nColor8( ) )
   REPLACE FMSETUP->COLOR9 WITH RGB2Num( SP_nColor9( ) )
   REPLACE FMSETUP->COLOR10 WITH RGB2Num( SP_nColor10() )
   REPLACE FMSETUP->COLOR11 WITH RGB2Num( SP_nColor11() )
   REPLACE FMSETUP->COLOR12 WITH RGB2Num( SP_nColor12() )
   REPLACE FMSETUP->COLOR13 WITH RGB2Num( SP_nColor13() )
   REPLACE FMSETUP->COLOR14 WITH RGB2Num( SP_nColor14() )

   REPLACE FMSETUP->DARKMODE WITH SP_DarkMode()
   REPLACE FMSETUP->COLRESIZE WITH SP_lColResize()
   REPLACE FMSETUP->FONTNAME WITH SP_cFontName()
   REPLACE FMSETUP->FONTSIZE WITH SP_nFontSize()
   REPLACE FMSETUP->FONTHEIGH WITH SP_nFontlarge()
   REPLACE FMSETUP->FONTWIDTH WITH SP_nFontsmall()
   REPLACE FMSETUP->USEIMAGE WITH SP_UseImage()

   i := 1
   iMax := LEN( aWin )
   FOR i := 1 TO iMax
      cText := aWin[ i ] [ 1 ]
      DO CASE
         CASE cText = "WinLeft"
            AADD( aTabs1, aWin[ i ] )
         CASE cText = "WinRight"
            AADD( aTabs2, aWin[ i ] )
      ENDCASE
   NEXT

   REPLACE FMSETUP->LWLPATH WITH STRTRAN( TRIM( aTabs1[ 1 ] [ 3 ] ) + "\", "\\", "\" )
   REPLACE FMSETUP->LWRPATH WITH STRTRAN( TRIM( aTabs2[ 1 ] [ 3 ] ) + "\", "\\", "\" )

   i := 1
   iMax := LEN( aTabs1 )
   FOR i := 1 TO iMax
      cObj := "Grid_" + LTRIM( STR( i ) )
      aTabs1[ i ] [ 2 ] := cObj
   NEXT

   i := 1
   iMax := LEN( aTabs2 )
   FOR i := 1 TO iMax
      cObj := "Grid_" + LTRIM( STR( i ) )
      aTabs2[ i ] [ 2 ] := cObj
   NEXT

   REPLACE FMSETUP->TabLeft WITH HB_Serialize( aTabs1 )
   REPLACE FMSETUP->TabRight WITH HB_Serialize( aTabs2 )

   REPLACE FMSETUP->LWLVIEW WITH WinLeft.Tab_Left.Value               // SP_ViewLeft( )
   REPLACE FMSETUP->LWRVIEW WITH WinRight.Tab_Right.Value             // SP_ViewRight()

   CLOSE ALL

   //  IF( VirtualKeyboard.IsOpen == .T., VirtualKeyboard.RELEASE, NIL )

   DelTemp_FI_BMP()
   CloseAllThread()

#IFDEF Use_FreeImage
   FREE_Deinitialise()
#ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure RunWithParameter()
*+
*+    Called from ( fmgrid.prg )   1 - procedure fill1stgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE RunWithParameter()

LOCAL i, iMax := LEN( aMore )
LOCAL cGrid, cPath

   FOR i := 1 TO iMax
      cGrid := aMore[ i ] [ 1 ]                                       // "LEFT" - "RIGHT"
      cPath := aMore[ i ] [ 2 ]                                       // Path of this Tab

      DO CASE
         CASE cGrid = "LEFT"
            nGridFocus := 1
         CASE cGrid = "RIGHT"
            nGridFocus := 2
      ENDCASE

      NewTab( cPath )
      DO EVENTS
   NEXT

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure RestoreTab()
*+
*+    Called from ( fmgrid.prg )   1 - procedure fill1stgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE RestoreTab()

LOCAL aTabs1 := SP_TabLeft()
LOCAL aTabs2 := SP_TabRight()
LOCAL cForm
LOCAL cObj
LOCAL cPath
LOCAL i, iMax, nPosi

   IF !EMPTY( aTabs1 )
      i := 1
      iMax := LEN( aTabs1 )
      IF iMax > 1
         FOR i := 2 TO iMax
            nGridFocus := 1

            cForm := aTabs1[ i ] [ 1 ]
            cObj := aTabs1[ i ] [ 2 ]
            cPath := aTabs1[ i ] [ 3 ]
            nPosi := ASCAN( aWin, { | x | x[ AW_FORM ] = cForm .AND. x[ AW_OBJ ] = cObj } )
            IF nPosi > 0
            ELSE
               NewTab( cPath )
               DO EVENTS
            ENDIF
         NEXT
         WinLeft.Tab_Left.Value := SP_ViewLeft( )
      ENDIF
   ENDIF

   IF !EMPTY( aTabs2 )
      i := 1
      iMax := LEN( aTabs2 )
      IF iMax > 1
         FOR i := 2 TO iMax
            nGridFocus := 2

            cForm := aTabs2[ i ] [ 1 ]
            cObj := aTabs2[ i ] [ 2 ]
            cPath := aTabs2[ i ] [ 3 ]
            nPosi := ASCAN( aWin, { | x | x[ AW_FORM ] = cForm .AND. x[ AW_OBJ ] = cObj } )
            IF nPosi > 0
            ELSE
               NewTab( cPath )
               DO EVENTS
            ENDIF
         NEXT
         WinRight.Tab_Right.Value := SP_ViewRight()
      ENDIF
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure ShowOSK()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ShowOSK()

LOCAL windir := GETENV( "windir" )

STATIC lOpen := .F.

   IF lOpen = .F.
      lOpen := .T.

      IF Is64Bit()
         HMG_CallDLL( "Kernel32.dll", DLL_OSAPI, "Wow64EnableWow64FsRedirection", FALSE )                                                   // disable bevor API Call
      ENDIF

      //  IF .NOT. FILE (VirtualKeyboard.FULLFILENAME)
      IF .NOT. FILE( windir + "\System32\osk.exe" )
         msgInfo( "file OSK.EXE not found ?" )
         RETURN
      ENDIF

      _EXECUTE( 0,, VirtualKeyboard.FULLFILENAME, "ON",, 5 )
      INKEY( 1 )                                                      // Wait until the application is loaded

      IF Is64Bit()
         HMG_CallDLL( "Kernel32.dll", DLL_OSAPI, "Wow64EnableWow64FsRedirection", TRUE )                                                    // enable again
      ENDIF

      RETURN
   ELSE
      lOpen := .F.
      FindAndCloseProcress( "OSK.EXE" )
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoTouchEnter()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoTouchEnter()

LOCAL cForm, cObj

   DO CASE
      CASE nGridFocus = 1
         cForm := "WinLeft"
         cObj := cGrid_Left

      CASE nGridFocus = 2
         cForm := "WinRight"
         cObj := cGrid_Right
   ENDCASE
   Doit( cForm, cObj )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function FindAndCloseProcress()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure showosk()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION FindAndCloseProcress( cApp )

LOCAL oProcesses, oProcess, oWMI, oLocator
LOCAL lRet       := .F.

   oLocator := CreateObject( "wbemScripting.SwbemLocator" )
   IF EMPTY( oLocator )
      msginfo( "can not create wbemScripting.SwbemLocator" )
      RETURN .F.
   ELSE
      oWMI := oLocator:ConnectServer()
   ENDIF

   IF EMPTY( oWMI )
      msginfo( "can not connect oLocator:ConnectServer()" )
      RETURN .F.
   ELSE
      oProcesses = oWMI:ExecQuery( "SELECT * FROM Win32_Process" )

      IF oProcesses:Count > 0
         FOR EACH oProcess in oProcesses
            IF UPPER( TRIM( oProcess:Name ) ) = cApp
               //  msginfo( "terminate " + cApp )
               oProcess:Terminate( 0 )
               lRet := .T.
               EXIT
            ENDIF
         NEXT
      ENDIF
   ENDIF

   oProcesses := NIL
   oWMI := NIL
   oLocator := NIL
RETURN lRet

*+--------------------------------------------------------------------
*+
*+    Static Function ChangeFAttr()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION ChangeFAttr( nNo )

LOCAL cForm, cObj, aItem, iMax, nItem
LOCAL lArchive, lRead, lHidden, lSystem, cDate, cTime, aDir
LOCAL cPath, cName, cFile, lChange := .f.

   DO CASE
      CASE nNo = 1
         cForm := "WinLeft"
         cObj := cGrid_Left
         aItem := GetProperty( "WinLeft", cGrid_Left, "Value" )

      CASE nNo = 2
         cForm := "WinRight"
         cObj := cGrid_Right
         aItem := GetProperty( "WinRight", cGrid_Right, "Value" )
   ENDCASE

   IF VALTYPE( aItem ) = "A"
      iMax := LEN( aItem )
      IF EMPTY( iMax )
         SetProperty( cForm, cObj, "Value", { 1 } )
         RETURN .F.
      ELSE
         nItem := aItem[ 1 ]
      ENDIF
   ELSEIF VALTYPE( aItem ) = "N"
      nItem := aItem
   ENDIF

   cPath := GridGetPath( cForm, cObj )
   cName := GetProperty( cForm, cObj, "CELL", nItem, F_NAME )
   cFile := cPath + cName

   aDir := DIRECTORY( cFile )
   cDate := DTOC( aDir[ 1 ] [ F_DATE ] )
   cTime := aDir[ 1 ] [ F_TIME ]
   lArchive := "A" $ aDir[ 1 ] [ F_ATTR ]
   lRead := "R" $ aDir[ 1 ] [ F_ATTR ]
   lHidden := "H" $ aDir[ 1 ] [ F_ATTR ]
   lSystem := "S" $ aDir[ 1 ] [ F_ATTR ]

   DEFINE WINDOW wFileAttr ;
      AT 0, 0 ;
      WIDTH 300 ;
      HEIGHT 260 ;
      TITLE "File attributes for " + cName ;
      ICON 'ICOATTR' ;
      MODAL ;
      NOSIZE

   @  4,  5 FRAME FA_Frame_1 CAPTION "Change attributes" WIDTH 284 HEIGHT 118

   @ 26, 14 CHECKBOX FA_Check_1 ;
           CAPTION '&Archive' ;
           WIDTH 200 ;
           HEIGHT 16 ;
           VALUE lArchive ;
           ON CHANGE lArchive := wFileAttr.FA_Check_1.Value

   @ 48, 14 CHECKBOX FA_Check_2 ;
           CAPTION '&Read only' ;
           WIDTH 200 ;
           HEIGHT 16 ;
           VALUE lRead ;
           ON CHANGE lRead := wFileAttr.FA_Check_2.Value

   @ 70, 14 CHECKBOX FA_Check_3 ;
           CAPTION '&Hidden' ;
           WIDTH 200 ;
           HEIGHT 16 ;
           VALUE lHidden ;
           ON CHANGE lHidden := wFileAttr.FA_Check_3.Value

   @ 92, 14 CHECKBOX FA_Check_4 ;
           CAPTION '&System' ;
           WIDTH 200 ;
           HEIGHT 16 ;
           VALUE lSystem ;
           ON CHANGE lSystem := wFileAttr.FA_Check_4.Value

   @ 130,  5 FRAME Frame_2 WIDTH 284 HEIGHT 64

   @ 140, 14 CHECKBOX FA_Check_5 ;
           CAPTION 'Change &date/time' ;
           WIDTH 120 ;
           HEIGHT 16 ;
           VALUE lChange ;
           ON CHANGE lChange := wFileAttr.FA_Check_5.Value

   @ 138, 206 BUTTON FA_Button_3 ;
           CAPTION "C&urrent" ;
           ACTION( wFileAttr.FA_Text_1.Value := DTOC( DATE() ), ;
           wFileAttr.FA_Text_2.Value := TIME(), ;
           wFileAttr.FA_Check_5.Value := .t. ) ;
           WIDTH 74 HEIGHT 23

   @ 166, 014 LABEL FA_Label_1 VALUE "Date:" AUTOSIZE

   @ 166, 162 LABEL FA_Label_2 VALUE "Time:" AUTOSIZE

   @ 164, 56 TEXTBOX FA_Text_1 ;
           VALUE cDate ;
           WIDTH 74 ;
           HEIGHT 20 ;
           ON CHANGE( cDate := wFileAttr.FA_Text_1.Value, wFileAttr.FA_Check_5.Value := .t. )

   @ 164, 206 TEXTBOX FA_Text_2 ;
           VALUE cTime ;
           WIDTH 74 ;
           HEIGHT 20 ;
           ON CHANGE( cTime := wFileAttr.FA_Text_2.Value, wFileAttr.FA_Check_5.Value := .t. )

   @ 204, 122 BUTTON FA_Button_1 ;
           CAPTION "&Ok" ;
           ACTION( SetAttr( cFile, lArchive, lRead, lHidden, lSystem, lChange, cDate, cTime ), wFileAttr.Release ) ;
           WIDTH 80 HEIGHT 23

   @ 204, 208 BUTTON FA_Button_2 ;
           CAPTION "&Cancel" ;
           ACTION wFileAttr.Release ;
           WIDTH 80 HEIGHT 23

   END WINDOW

   ON KEY ESCAPE OF wFileAttr ACTION wFileAttr.Release
   CENTER WINDOW wFileAttr
   ACTIVATE WINDOW wFileAttr

   Domethod( cForm, cObj, "Refresh" )
   Domethod( cForm, cObj, "SetFocus" )

RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Static Procedure Slideshow()
*+
*+    Called from ( fmgrid.prg )   5 - procedure dualgrid()
*+                                   1 - static procedure dogridkey1()
*+                                   1 - static procedure dogridkey2()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Slideshow()

LOCAL cForm, cObj
LOCAL aItem, nItem, nKey := 0
LOCAL cPath, cText, cExt, nMilliSec := 9999
LOCAL aDir, i, iMax, lshow := .F.
LOCAL xInput := ""

   DO CASE
      CASE nGridFocus = 1
         cForm := "WinLeft"
         cObj := cGrid_Left
         aDir := aDir_Left
      CASE nGridFocus = 2
         cForm := "WinRight"
         cObj := cGrid_Right
         aDir := aDir_Right
   ENDCASE
   cPath := GridGetPath( cForm, cObj )
   cPath += "\"
   cPath := STRTRAN( cPath, "\\", "\" )

   xInput := GetInPut( "Timeout Milliseconds. Thumbs = 9999 ", "Slideshow " + cPath, nMilliSec, 1 )
   IF EMPTY( xInput )
      RETURN
   ELSE
      IF VALTYPE( xInput ) = "C"
         nMilliSec := VAL( xInput )
      ELSE
         nMilliSec := xInput
      ENDIF
   ENDIF

   lActiveMain = .F.
   IF nMilliSec = 9999
      pBarForm( "THUMBS('" + cPath + "')" )
   ELSE
      aDir := DIRECTORY( cPath + "*.*", "DHS" )
      iMax := LEN( aDir )
      FOR i := 1 TO iMax
         lshow := .F.
         nKey := 0
         cText := aDir[ i ] [ F_NAME ]
         cExt := UPPER( FindExt( cText ) )
         DO CASE
            CASE cExt $ ".BMP.GIF.JPG.JPEG.TIF.TIFF.WMF.EMF.PNG"
               Image_Edit( cPath, cText, nMilliSec )
               nKey := SP_nSlideShow()
         ENDCASE
         DO EVENTS
         DO CASE
            CASE nKey = 0

            CASE nKey = 1
               EXIT
            CASE nKey = 2

            CASE nKey = 3
               i --
               i --
               IF i < 1
                  i := 1
               ENDIF
         ENDCASE
      NEXT
      SlideshowEnd()
   ENDIF
   lActiveMain = .T.

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SetLV_View()
*+
*+    Called from ( fmgrid.prg )   8 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SetLV_View( nNo, nView )

LOCAL cForm, cObj
LOCAL hGrid, nLVS
LOCAL aCol, i, iMax, nZoom, nWide
LOCAL mainHeight := GetProperty( "Win_1", 'Height' )
LOCAL nHeight    := 1024
LOCAL aOrg       := { 330, 80, 78, 64, 60 }

   IF nNo = 1
      cForm := "WinLeft"
      cObj := cGrid_Left
      aCol := ACLONE( SP_aColLeft() )
   ELSE
      cForm := "WinRight"
      cObj := cGrid_Right
      aCol := ACLONE( SP_aColRight() )
   ENDIF

   hGrid := GetControlHandle( cObj, cForm )
   Domethod( cForm, cObj, "DisableUpdate" )

   DO CASE
      CASE nView = LV_VIEW_ICON
         nLVS := LVS_ICON
      CASE nView = LV_VIEW_DETAILS
         nLVS := LVS_REPORT
      CASE nView = LV_VIEW_SMALLICON
         nLVS := LVS_SMALLICON
      CASE nView = LV_VIEW_LIST
         nLVS := LVS_LIST
   ENDCASE

   LISTVIEW_CHANGEVIEW( hGrid, nView )

   CHANGESTYLE( hGrid, nLVS, nLastView )
   nLastView := nLVS

   IF nView = LV_VIEW_ICON
      CHANGESTYLE( hGrid, LVS_ALIGNTOP )
   ENDIF

   IF nView = LV_VIEW_DETAILS
      ListView_ChangeExtendedStyle( hGrid, LVS_EX_FULLROWSELECT, nil )
      ListView_ChangeExtendedStyle( hGrid, LVS_EX_GRIDLINES, nil )

      nZoom := ( mainHeight / nHeight )                               // based on Font 10
      iMax := LEN( aCol )
      FOR i := 1 TO iMax
         IF EMPTY( aCol[ i ] )
            nWide := aOrg[ i ] * nZoom
         ELSE
            nWide := aCol[ i ] * nZoom
         ENDIF
         LISTVIEW_SETCOLUMNWIDTH( hGrid, i - 1, nWide )
      NEXT
   ELSE
      ListView_ChangeExtendedStyle( hGrid, nil, LVS_EX_FULLROWSELECT )
      ListView_ChangeExtendedStyle( hGrid, nil, LVS_EX_GRIDLINES )
   ENDIF

   Domethod( cForm, cObj, "EnableUpdate" )

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure MarkFromThumbs()
*+
*+    Called from ( thumbs.prg )   1 - procedure prep4grid()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE MarkFromThumbs( aHMGselect )                                // Called from thumbs.prg

LOCAL cForm, cObj, hGrid, i, iMax, aSelect := {}
LOCAL aDir, nPosi, cFile

   DO CASE
      CASE nGridFocus = 1
         cForm := "WinLeft"
         cObj := cGrid_Left
         aDir := aDir_Left
      CASE nGridFocus = 2
         cForm := "WinRight"
         cObj := cGrid_Right
         aDir := aDir_Right
   ENDCASE

   hGrid := GetControlHandle( cObj, cForm )

   Domethod( cForm, cObj, "SetFocus" )
   Domethod( cForm, cObj, "DisableUpdate" )

   iMax := LEN( aHMGselect )
   IF iMax > 0
      UnMarkAll( hGrid )
   ENDIF

   FOR i := 1 TO iMax
      cFile := aHMGselect[ i ]
      nPosi := ASCAN( aDir, { | e | e[ F_NAME ] = cFile } )
      IF nPosi > 0
         AADD( aSelect, nPosi )
      ENDIF
   NEXT

   SetProperty( cForm, cObj, "Value", aSelect )
   Domethod( cForm, cObj, "EnableUpdate" )
   Domethod( cForm, cObj, "setfocus" )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoDevice()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoDevice()

LOCAL cForm, cObj, cPath

STATIC lIsrunning := .F.

   IF lIsrunning = .T.
      RETURN
   ELSE
      lIsrunning := .T.

      DO CASE
         CASE nGridFocus = 1
            cForm := "WinLeft"
            cObj := cGrid_Left
         CASE nGridFocus = 2
            cForm := "WinRight"
            cObj := cGrid_Right
      ENDCASE
      cPath := GridGetPath( cForm, cObj )
      SP_lDirWatch( .F. )
      lActiveMain := .F.

      GetDevicePath( cPath )
      DO EVENTS

      lActiveMain := .T.
      SP_lDirWatch( .T. )

      lIsrunning := .F.
      FillWithDir( cForm, cObj, cPath, "TREEDN" )
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoReverseMark()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure dogridkey1()
*+                                   1 - static procedure dogridkey2()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoReverseMark( nNo )

LOCAL adir, aSourceNum, cSourceDir, nPosi, i, iMax, aFiles := {}
LOCAL cForm, cObj

   IF nNo = 1
      cForm := "WinLeft"
      cObj := cGrid_Left
      adir := ACLONE( aDir_Left )
   ELSE
      cForm := "WinRight"
      cObj := cGrid_Right
      adir := ACLONE( aDir_Right )
   ENDIF
   aSourceNum := GetProperty( cForm, cObj, "Value" )

   iMax := LEN( adir )
   FOR i := 1 TO iMax
      IF ASCAN( aSourceNum, { | e | e = i } ) > 0
      ELSE
         IF "D" $ adir[ i ] [ F_ATTR ]
         ELSE
            AADD( aFiles, i )
         ENDIF
      ENDIF
   NEXT

   Domethod( cForm, cObj, "DisableUpdate" )
   SetProperty( cForm, cObj, "Value", aFiles )
   Domethod( cForm, cObj, "EnableUpdate" )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function NetConnect()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION NetConnect()

LOCAL nHandle := GetActiveWindow()                                    // GetProperty( "Win_1", "Handle" )
RETURN HMG_CallDLL( "Mpr.dll", DLL_OSAPI, "WNetConnectionDialog", nHandle, RESOURCETYPE_DISK )

*+--------------------------------------------------------------------
*+
*+    Static Function NetDisconnect()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION NetDisconnect()

LOCAL nHandle := GetActiveWindow()
LOCAL cDir    := "C:\"

   SP_lDirWatch( .F. )

   HMG_CallDLL( "Mpr.dll", DLL_OSAPI, "WNetDisconnectDialog", nHandle, RESOURCETYPE_DISK )

   IF nGridFocus = 1
      FillWithDir( "WinLeft", cGrid_Left, cdir, "TREEDN" )
   ELSE
      FillWithDir( "WinRight", cGrid_Right, cdir, "TREEDN" )
   ENDIF

RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Function WatchDirLeft()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure watchdirswitch()
*+
*+--------------------------------------------------------------------
*+
FUNCTION WatchDirLeft( cDir )

LOCAL pChangeHandle
LOCAL nWaitStatus
LOCAL lRunAnyway    := .T.
LOCAL aDir

   IF hb_FileExists( cDir + "Threadquit.$$$" )
      hb_FileDelete( cDir + "Threadquit.$$$" )
   ENDIF

   onDummy( TIME(), "_WatchDirLeft", cDir )

   aDir := DIRECTORY( cDir + "*.*" )
   IF EMPTY( aDir )
      RETURN .F.
   ENDIF

   // watch file name changes ( file was CREATED, RENAMED or DELETED)
   // pChangeHandle := wapi_FindFirstChangeNotification( cDir, .F., FILE_NOTIFY_CHANGE_FILE_NAME )
   pChangeHandle := wapi_FindFirstChangeNotification( cDir, .F., FILE_NOTIFY_CHANGE_NAME )

   IF INVALID_HANDLE_VALUE( pChangeHandle )
      MsgInfo( "ERROR: FindFirstChangeNotification function failed." )
      RETURN wapi_GetLastError()
   ENDIF

   // Change notification is set. Now we can wait on notification handle.
   DO WHILE lRunAnyway
      // MsgInfo( "Waiting for notification...")

      // If the function succeeds, the return value indicates
      // the event that caused the function to return.
      nWaitStatus = wapi_WaitForSingleObject( pChangeHandle, INFINITE )

      IF SP_lDirWatch() = .F.
         onDummy( TIME(), "_WatchDirLeft", "SP_lDirWatch(.F.)" )
         RETURN 0
      ELSE

         DO CASE
            CASE nWaitStatus = WAIT_OBJECT_0
               // A file was CREATED, RENAMED or DELETED in the directory.
               // _Refresh_ this directory and _restart_ the notification.
               RefreshDirLeft( cDir, @lRunAnyway )

               IF lRunAnyway
                  IF !wapi_FindNextChangeNotification( pChangeHandle )
                     MsgInfo( "ERROR: FindNextChangeNotification function failed." )
                     RETURN wapi_GetLastError()
                  ENDIF
               ELSE
                  wapi_FindCloseChangeNotification( pChangeHandle )
               ENDIF

            CASE nWaitStatus = WAIT_TIMEOUT
               // A timeout occurred, this would happen if some value other
               // than INFINITE is used in the Wait call and no changes occur.
               // In a single-threaded environment you might not want an
               // INFINITE wait.
               MsgInfo( "No changes in the timeout period." )
               //  EXIT

            OTHERWISE
               MsgInfo( "ERROR: Unhandled nWaitStatus." )
               RETURN wapi_GetLastError()

         ENDCASE

      ENDIF

   END WHILE

RETURN 0

*+--------------------------------------------------------------------
*+
*+    Function WatchDirRight()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure watchdirswitch()
*+
*+--------------------------------------------------------------------
*+
FUNCTION WatchDirRight( cDir )

LOCAL pChangeHandle
LOCAL nWaitStatus
LOCAL lRunAnyway    := .T.
LOCAL aDir

   IF hb_FileExists( cDir + "Threadquit.$$$" )
      hb_FileDelete( cDir + "Threadquit.$$$" )
   ENDIF

   onDummy( TIME(), "_WatchDirRight", cDir )

   aDir := DIRECTORY( cDir + "*.*" )
   IF EMPTY( aDir )
      RETURN .F.
   ENDIF

   // watch file name changes ( file was CREATED, RENAMED or DELETED)
   // pChangeHandle := wapi_FindFirstChangeNotification( cDir, .F., FILE_NOTIFY_CHANGE_FILE_NAME )
   pChangeHandle := wapi_FindFirstChangeNotification( cDir, .F., FILE_NOTIFY_CHANGE_NAME )

   IF INVALID_HANDLE_VALUE( pChangeHandle )
      MsgInfo( "ERROR: FindFirstChangeNotification function failed." )
      RETURN wapi_GetLastError()
   ENDIF

   // Change notification is set. Now we can wait on notification handle.
   DO WHILE lRunAnyway
      //  MsgInfo( "Waiting for notification...")

      // If the function succeeds, the return value indicates
      // the event that caused the function to return.
      nWaitStatus = wapi_WaitForSingleObject( pChangeHandle, INFINITE )

      IF SP_lDirWatch() = .F.
         onDummy( TIME(), "_WatchDirRight", "SP_lDirWatch(.F.)" )
         RETURN 0
      ELSE

         DO CASE

            CASE nWaitStatus = WAIT_OBJECT_0
               // A file was CREATED, RENAMED or DELETED in the directory.
               // _Refresh_ this directory and _restart_ the notification.
               RefreshDirRight( cDir, @lRunAnyway )

               IF lRunAnyway
                  IF !wapi_FindNextChangeNotification( pChangeHandle )
                     MsgInfo( "ERROR: FindNextChangeNotification function failed." )
                     RETURN wapi_GetLastError()
                  ENDIF
               ELSE
                  wapi_FindCloseChangeNotification( pChangeHandle )
               ENDIF

            CASE nWaitStatus = WAIT_TIMEOUT
               // A timeout occurred, this would happen if some value other
               // than INFINITE is used in the Wait call and no changes occur.
               // In a single-threaded environment you might not want an
               // INFINITE wait.
               MsgInfo( "No changes in the timeout period." )
               //  EXIT

            OTHERWISE
               MsgInfo( "ERROR: Unhandled nWaitStatus." )
               RETURN wapi_GetLastError()

         ENDCASE

      ENDIF

   END WHILE

RETURN 0

*+--------------------------------------------------------------------
*+
*+    Static Procedure RefreshDirLeft()
*+
*+    Called from ( fmgrid.prg )   1 - function watchdirleft()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE RefreshDirLeft( cDir, lRunAnyway )

   // This is where you might place code to refresh your
   // directory listing, but not the subtree because it
   // would not be necessary.
   //    MsgInfo( hb_StrFormat( "Directory %1$s was changed.", cDir ))

   IF hb_FileExists( cDir + "Threadquit.$$$" )
      hb_FileDelete( cDir + "Threadquit.$$$" )
      lRunAnyway := .F.
   ENDIF
   onDummy( TIME(), "_RefreshDirLeft", cDir )
   ReRead( 1 )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure RefreshDirRight()
*+
*+    Called from ( fmgrid.prg )   1 - function watchdirright()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE RefreshDirRight( cDir, lRunAnyway )

   // This is where you might place code to refresh your
   // directory listing, but not the subtree because it
   // would not be necessary.
   //    MsgInfo( hb_StrFormat( "Directory %1$s was changed.", cDir ))

   IF hb_FileExists( cDir + "Threadquit.$$$" )
      hb_FileDelete( cDir + "Threadquit.$$$" )
      lRunAnyway := .F.
   ENDIF

   onDummy( TIME(), "_RefreshDirRight", cDir )
   ReRead( 2 )

RETURN

*+--------------------------------------------------------------------
*+
*+    Function onDummy()
*+
*+    Called from ( ado.prg )   3 - function adoxlsxwrite()
*+                ( fmgrid.prg )   1 - static procedure refreshgrid()
*+                                   1 - procedure reread()
*+                                   1 - static procedure fillwithdir()
*+                                   1 - static procedure watchdirswitch()
*+                                   2 - function watchdirleft()
*+                                   2 - function watchdirright()
*+                                   1 - static procedure refreshdirleft()
*+                                   1 - static procedure refreshdirright()
*+                ( hbftp.prg )   1 - static function doprogress()
*+
*+--------------------------------------------------------------------
*+
FUNCTION onDummy()

LOCAL iMax   := PCOUNT()
LOCAL i
LOCAL cText  := ""
LOCAL xValue

   IF lDebug = .T.
      FOR i := 1 TO iMax - 1
         cText += Var2Char( PValue( i ) ) + CHR( 9 )
      NEXT
      cText += Var2Char( PValue( iMax ) )

      IF EMPTY( cText )
         cText := TIME() + " no Parameter ? " + CRLF + PROCNAME( 1 ) + STR( PROCLINE( 1 ) ) + CRLF + PROCNAME( 2 ) + STR( PROCLINE( 2 ) )
      ENDIF
      SET CONSOLE OFF
      SET ALTER ON

      ? cText

      SET ALTER OFF
      SET CONSOLE ON
   ENDIF

RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Static Function About()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION About()

LOCAL cText := ""
   //    HarbourInit()
   cText += VERSION() + HB_EOL()
   cText += HB_Compiler() + HB_EOL()
   cText += hb_gtInfo( HB_GTI_VERSION ) + HB_EOL()
   cText += "Available Memory:" + LTRIM( TRANSFORM( MEMORY( 0 ) / 1000, "999,999" ) ) + "MB" + HB_EOL()
   cText += "(Max 4GB for Harbour 32 bits)" + HB_EOL()

#ifdef GTWVG
   MsgExclamation( cText )
#else
   hb_Alert( cText )
#endif
RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Function GetControls()
*+
*+    Called from ( fmgrid.prg )   1 - procedure setchild()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetControls( cForm )                                         // like Childlist

LOCAL hWnd      := GetFormHandle( cForm )
LOCAL aControls := {}                                                 // List of controls {ControlType, ControlName}
   AEVAL( _HMG_SYSDATA[ 4 ], { | hCtrWnd, nPos | IF( hCtrWnd == hWnd, AADD( aControls, { _HMG_SYSDATA[ 1, nPos ], _HMG_SYSDATA[ 2, nPos ] } ), Nil ) } )
   //  MsgDebug( 'List of controls', aControls)

RETURN aControls

*+--------------------------------------------------------------------
*+
*+    Procedure SetCursorOnControls()
*+
*+    Called from ( fmgrid.prg )   2 - procedure setcursorwait()
*+                                   4 - procedure setgridwait()
*+                                   2 - procedure setchild()
*+                ( modistru.prg )   2 - static procedure maxitemlen()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE SetCursorOnControls( nHwnd, xCursor )

   SetWindowCursor( nHwnd, xCursor )

   //    IF NIL <> This.Handle
   //       SetWindowCursor (This.Handle, xCursor)    // All Controls associated with the class
   //    ENDIF
   //   SetWindowCursor ( GetControlHandle("Text_1","Demo2"), IDC_WAIT)
RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure SetCursorWait()
*+
*+    Called from ( ado.prg )  10 - static function getxlsgrid()
*+                                   8 - function adoxlsxwrite()
*+                ( fm_func.prg )   2 - procedure createscreensplash()
*+                ( modistru.prg )   2 - static procedure maxitemlen()
*+                ( thumbs.prg )   4 - procedure thumbs()
*+                ( viewer.prg )   4 - procedure txt_edit()
*+                                   4 - procedure rtf_edit()
*+                                   4 - procedure showpdf()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE SetCursorWait( cForm, lOn )

LOCAL nHwnd
   DEFAULT lOn TO .F.

   nHwnd := GetformHandle( cForm )
   IF lOn = .T.
      SetCursorOnControls( nHwnd, IDC_WAIT )
   ELSE
      SetCursorOnControls( nHwnd, IDC_ARROW )
   ENDIF
   //  SetCHild(cForm,lOn)
   SetGridWait( lOn )
RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure SetGridWait()
*+
*+    Called from ( fmgrid.prg )   1 - procedure fill1stgrid()
*+                                   1 - procedure setcursorwait()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE SetGridWait( lOn )

LOCAL hGrid
   DEFAULT lOn TO .F.

   IF LEN( Stack_Left ) > 0
      hGrid := GetControlHandle( cGrid_Left, "WinLeft" )
      IF lOn = .T.
         SetCursorOnControls( hGrid, IDC_WAIT )
      ELSE
         SetCursorOnControls( hGrid, IDC_ARROW )
      ENDIF
   ENDIF

   IF LEN( Stack_Right ) > 0
      hGrid := GetControlHandle( cGrid_Right, "WinRight" )
      IF lOn = .T.
         SetCursorOnControls( hGrid, IDC_WAIT )
      ELSE
         SetCursorOnControls( hGrid, IDC_ARROW )
      ENDIF
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure SetCHild()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE SetCHild( cForm, lOn )

LOCAL aChild := GetControls( cForm )
LOCAL ii, iMax := LEN( aChild )
LOCAL cObj, nHwnd
   DEFAULT lOn TO .F.

   FOR ii := 1 TO iMax
      cObj := aChild[ ii ] [ 2 ]
      nHwnd := GetControlHandle( cObj, cForm )

      IF lOn = .T.
         SetCursorOnControls( nHwnd, IDC_WAIT )
      ELSE
         SetCursorOnControls( nHwnd, IDC_ARROW )
      ENDIF

   NEXT
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function HL_IsFolderExist()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure changefolder()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION HL_IsFolderExist( cDirName )

LOCAL cCurDir := GetCurrentFolder()
LOCAL lRVal   := ( DIRCHANGE( cDirName ) == 0 )

   SetCurrentFolder( cCurDir )

RETURN lRVal                                                          // HL_IsFolderExist()

*+--------------------------------------------------------------------
*+
*+    Static Procedure ChangeFolder()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ChangeFolder()

LOCAL cDirName := Win_1.PathInfo.Value
LOCAL cTitle   := "change Folder"
LOCAL cForm, cObj

   IF HL_IsFolderExist( cDirName )
   ELSE
      cDirName := GetFolder( cTitle, GetCurrentFolder(),, .T. )
   ENDIF

   DO CASE
      CASE nGridFocus = 1
         cForm := "WinLeft"
         cObj := cGrid_Left

      CASE nGridFocus = 2
         cForm := "WinRight"
         cObj := cGrid_Right
   ENDCASE
   FillWithDir( cForm, cObj, cDirName, "TREEDN" )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoFolderSize()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure dogridkey1()
*+                                   1 - static procedure dogridkey2()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoFolderSize( nForm )

LOCAL aItem, nItem, cPath, cText, cAttr
LOCAL cForm, cObj

   DO CASE
      CASE nForm = 1
         cForm := "WinLeft"
         cObj := cGrid_Left
      CASE nForm = 2
         cForm := "WinRight"
         cObj := cGrid_Right
   ENDCASE

   aItem := GetProperty( cForm, cObj, "Value" )
   nItem := aItem[ 1 ]

   cPath := GridGetPath( cForm, cObj )
   cText := GetProperty( cForm, cObj, "CELL", nItem, F_NAME )
   cAttr := GetProperty( cForm, cObj, "CELL", nItem, F_ATTR )

   IF cText = "." .AND. LEN( cText ) = 1
   ELSEIF cText = ".." .AND. "D" $ cAttr
   ELSE
      IF "D" $ cAttr
         ShowProperty( nForm )
      ENDIF
   ENDIF
RETURN

*+ EOF: FMGRID.PRG
