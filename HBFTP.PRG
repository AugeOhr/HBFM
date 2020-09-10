*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\HBFTP.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Function HbFTP()
*+               Static Procedure FTPForm()
*+               Static Procedure FTPFormExit()
*+               Static Procedure SiteForm()
*+               Static Procedure EditForm()
*+               Static Function sitemanagerexit()
*+               Static Function ftppropcancel()
*+               Static Function ftpdelete()
*+               Static Function ftppropsave()
*+               Static Function FillFTPCombo()
*+               Static Function ftpconn1()
*+               Static Function ftpconn2()
*+               Static Function ftpConnect()
*+               Static Function FTPFILLGRID()
*+               Static Function LOCALMKDIR()
*+               Static Function LOCALREN()
*+               Static Function LOCALDEL()
*+               Static Function FTPCWD()
*+               Static Function FTPCLOSE()
*+               Static Function FTPREN()
*+               Static Function FTPMKDIR()
*+               Static Function FTPDEL()
*+               Static Function DoProgress()
*+               Static Function FTPDOWN()
*+               Static Function FTPUP()
*+               Static Function GetColValue()
*+               Static Function GetArrayColValue()
*+               Static Function initgrid()
*+               Static Function nMonth()
*+               Static Procedure Head_click()
*+               Static Function GetDirectory()
*+               Static Function Verify()
*+               Static Function CurrentDirectory()
*+               Static Function GetExt()
*+               Static Function GetName()
*+               Static Function GetFull()
*+               Static Function _SetGridCaption()
*+               Static Procedure CreateTable()
*+               Static Function Encrip()
*+               Static Function Desencri()
*+               Static Procedure ShowPassword()
*+               Static Function AtInside()
*+               Static Function CalcPos()
*+               Static Function onDummy()
*+               Static Function VAR2CHAR()
*+               Static Procedure DoReSizeMain()
*+               Static Procedure FillLocalCombo()
*+               Static Procedure LoadComboImage()
*+               Static Procedure ChangeLocalDrive()
*+
*+       Tables: USE (cPath+"SITES.dbf") ALIAS sites
*+
*+    Reformatted by Click! 2.05.32 on Sep-10-2020 at  7:52 am
*+
*+--------------------------------------------------------------------

/*
 * MINIGUI - Harbour Win32 GUI library Demo
 *
 * Copyright 2002-07 Roberto Lopez <harbourminigui@gmail.com>
 *
 * Based upon program MINIGUI\SAMPLES\ADVANCED\FILEMAN
 * Copyright 2003-2007 Grigory Filatov <gfilatov@inbox.ru>
 *
 * Used functions desencri() and encri() by Gustavo C. Asborno <gcasborno@yahoo.com.ar>
 *
 * Used functions of sample ftplite on group harbourminigui_es by Juan Castillo A. <juan_casarte@yahoo.es>
 *
 * Copyright 2007 Walter Formigoni <walter.formigoni@uol.com.br>
 *
 * Revision of Pierpaolo Martinello 2018
 *
 * modify for HMG by Auge & Ohr, Jimmy 2020/05
 *
*/

#include <HMG.ch>
#include "Dbstruct.ch"
#include "directry.ch"
#include "dll.ch"
#include "common.ch"

#include "HBFM.CH"

#define ISOBJECT( n )         HB_ISOBJECT( n )

//  Constant for List()                            // Jimmy
#define IDL_cDate    1
#define IDL_cTime    2
#define IDL_cSize    3
#define IDL_cFile    4

//  Constant for GRID_2 Column                     // Jimmy
#define IDG_ICON     1
#define IDG_NAME     2
#define IDG_DIRSIZE  3
#define IDG_ATTR     6

//  Constant for ShellExecute()                  // Jimmy
#define SE_ERR_FNF               2
#define SE_ERR_PNF               3
#define SE_ERR_ACCESSDENIED      5
#define SE_ERR_OOM               8
#define SE_ERR_SHARE             26
#define SE_ERR_ASSOCINCOMPLETE   27
#define SE_ERR_DDETIMEOUT        28
#define SE_ERR_DDEFAIL           29
#define SE_ERR_DDEBUSY           30
#define SE_ERR_NOASSOC           31

#require "hbtip"

STATIC aDirectory, aSubDirectory, aOldPos
STATIC aNivel      := { 1, 1 }, aBack := { .t., .t. }, aGridWidth, nGridFocus := 1, bBlock, lBlock := .f.
STATIC cRunCommand := "", aWinVer, aSortCol := { 2, 2 }

STATIC xVersion   := "v0.1.0 modify for HMG"                          // Jimmy
STATIC nLast      := 0                                                // exGauge
STATIC xTitle     := "FTP Client "
STATIC caItems    := {}                                               // for ComboBox
STATIC acImage    := {}                                               // Image Combobox
STATIC lIsConnect := .F.

MEMVAR lfirst, oClient, oUrl
MEMVAR newRecord
MEMVAR _HMG_SYSDATA, _HMG_ACONTROLHANDLES, _HMG_ACONTROLCAPTION, lDebug
MEMVAR ftpMain, sitemanager, editsitemanager                          // old FMG

// *********************************************************************
//  v0.1.0 09.09.2020  add FTP Port
//  v0.0.9 27.08.2020  BUG
//  v0.0.8 11.07.2020  include in HBFM
//
//  v0.0.7 23.06.2020  Resize
//  v0.0.6 22.06.2020  GRID_2 now fill with o:List
//  v0.0.5 21.06.2020  Release with GRID_2 BUG
//
// *********************************************************************

*+--------------------------------------------------------------------
*+
*+    Function HbFTP()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HbFTP( aRect, cPath )

LOCAL nScrWidth := GetDesktopWidth(), nScrHeight := GetDesktopHeight(), nWidth, nHeight, nGridHeight, nGridWidth
LOCAL nWnd      := 1

   DEFAULT aRect TO { 0, 0, 1024, 768 }

PUBLIC lfirst  := .t.
PUBLIC oClient, oUrl
PUBLIC lDebug  := .F.
PUBLIC ftpMain, sitemanager, editsitemanager

   IF SP_lFTPrunning() = .T.
      dofindwin( xTitle + xVersion )
      RETURN .F.
   ELSE
      SP_lFTPrunning( .T. )

      IF !FILE( cPath + "SITES.dbf" )
         CreateTable( cPath, .F. )
      ENDIF

      USE (cPath+"SITES.dbf") ALIAS sites

      IF FCOUNT() < 7
         copy TO Osites
         DBCLOSEALL()
         CreateTable( cPath, .T. )
         USE (cPath+"SITES.dbf") ALIAS sites
         APPEND FROM Osites
         FERASE( "Osites.dbf" )
      ENDIF

      WHILE IsExeRunning( cFileNoPath( HB_ArgV( 0 ) ) + "_" + LTRIM( STR( nWnd ) ) )
         nWnd ++
      END

      aWinVer := WindowsVersion()

      SET CENTURY ON
      SET DATE GERMAN
      SET BROWSESYNC ON
      //       SET NAVIGATION EXTENDED

      IF lDebug = .T.                                                 // create "OnDummy()" Debug file
         SET ALTER TO ( "_LOGIT2.TXT" )
      ENDIF

      aDirectory := ARRAY( 2 )
      aSubDirectory := ARRAY( 2, 64 )
      aOldPos := ARRAY( 2, 64 )

      aSubDirectory[ 1 ] [ 1 ] := 'C:'
      aSubDirectory[ 2 ] [ 1 ] := 'C:'
      setcurrentfolder( 'c:\' )

      //    nWidth  := IF( nScrWidth >= 1024, 800, IF( nScrWidth >= 800, 700, 600 ) )
      //    nHeight := IF( nScrHeight >= 768, 600, IF( nScrHeight >= 600, 540, 480 ) )
      //    nGridHeight := IF( nHeight = 600, 360, IF( nHeight = 540, 299, 240 ) )
      //    nGridWidth :=  IF( nWidth = 800, 380, IF( nWidth = 700, 330, 280 ) )
      //    aGridWidth :=  IF( nHeight = 600, { 0, 145, 80, 74, 70 }, IF( nHeight = 540, { 0, 115, 80, 60, 64 }, { 0, 85, 70, 60, 55 } ) )

      nWidth := 1024
      nHeight := 768
      nGridHeight := 600
      nGridWidth := 800
      aGridWidth := { 26, 150, 80, 80, 70 }

      FillLocalCombo()
      // Image Combobox
      AADD( acImage, "MYUNKNOWN16" )
      AADD( acImage, "MYFIXDRIVE16" )
      AADD( acImage, "MYUSBSTICK16" )
      AADD( acImage, "MYSYSDRIVE16" )
      AADD( acImage, "MYFIXDRIVE16" )
      AADD( acImage, "MYNETDRIVE16" )
      AADD( acImage, "MYCDROM16" )
      AADD( acImage, "MYRAMDISK16" )

      IF PCOUNT() > 0
         nWidth := aRect[ 3 ]
         nHeight := aRect[ 4 ]
      ELSE
         nWidth := 900
         nHeight := 609
      ENDIF

      FTPForm( nWidth, nHeight )                                      // Jimmy

      SP_lFTPrunning( .F. )
   ENDIF

   IF USED()
      CLOSE
   ENDIF

   IF lDebug = .T.
      SET ALTER TO
   ENDIF

RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Procedure FTPForm()
*+
*+    Called from ( hbftp.prg )   1 - function hbftp()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE FTPForm( nWidth, nHeight )                           // Jimmy

   DEFINE WINDOW ftpMain ;
              AT 140, 412 ;
              WIDTH 900 ;
              HEIGHT 609 ;
              TITLE xTitle + xVersion ;
              ICON "ICOFTP" ;
              ON INIT initgrid() ;
              ON RELEASE FTPFormExit() ;
              ON SIZE DoReSizeMain() ;
              ON MAXIMIZE DoReSizeMain() ;
              ON MINIMIZE Nil ;
              ON PAINT Nil ;
              BACKCOLOR SP_nColor1()

      DEFINE GRID Grid_Local
         ROW 95
         COL 20
         WIDTH 410
         HEIGHT 445
         ITEMS { { "", "", "", "", "" } }
         VALUE 1
         WIDTHS aGridWidth
         HEADERS { '', '[Name]', 'Size', 'Date', 'Time' }
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE { || IF( lfirst,, CurrentDirectory( 1 ) ) }
         ONGOTFOCUS { || CurrentDirectory( 1 ) }
         ONLOSTFOCUS Nil
         ONDBLCLICK Verify()
         ONHEADCLICK Nil
         ONQUERYDATA Nil
         MULTISELECT .F.
         ALLOWEDIT .F.
         VIRTUAL .F.
         DYNAMICBACKCOLOR Nil
         DYNAMICFORECOLOR Nil
         COLUMNWHEN Nil
         COLUMNVALID Nil
         COLUMNCONTROLS Nil
         SHOWHEADERS .T.
         CELLNAVIGATION .F.
         NOLINES .F.
         HELPID Nil
         IMAGE { "MYFTPFOLDER", "MYFTPFILE" }
         JUSTIFY { 0, BROWSE_JTFY_LEFT, BROWSE_JTFY_RIGHT, BROWSE_JTFY_CENTER, BROWSE_JTFY_CENTER }
         ITEMCOUNT Nil
         BACKCOLOR SP_nColor9()
         FONTCOLOR SP_nColor10()
         HEADERIMAGES { "" }
         ROWSOURCE Nil
         COLUMNFIELDS Nil
         ALLOWAPPEND .F.
         ALLOWDELETE .F.
         BUFFERED .F.
         DYNAMICDISPLAY .F.
         ONSAVE Nil
         LOCKCOLUMNS 0
      END GRID

      DEFINE GRID Grid_FTP
         ROW 95
         COL 450
         WIDTH 410
         HEIGHT 445
         ITEMS {}
         VALUE 0
         WIDTHS { 26, 150, 80, 80, 70, 90 }
         HEADERS { '', '[Name]', 'Size', 'Date', 'Time', 'Attributes' }
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         ONDBLCLICK FTPCWD()
         ONHEADCLICK Nil
         ONQUERYDATA Nil
         MULTISELECT .F.
         ALLOWEDIT .F.
         VIRTUAL .F.
         DYNAMICBACKCOLOR Nil
         DYNAMICFORECOLOR Nil
         COLUMNWHEN Nil
         COLUMNVALID Nil
         COLUMNCONTROLS Nil
         SHOWHEADERS .T.
         CELLNAVIGATION .F.
         NOLINES .F.
         HELPID Nil
         IMAGE { "MYFTPFOLDER", "MYFTPFILE" }
         JUSTIFY { 0, BROWSE_JTFY_LEFT, BROWSE_JTFY_RIGHT, BROWSE_JTFY_CENTER, BROWSE_JTFY_LEFT, BROWSE_JTFY_LEFT }
         ITEMCOUNT Nil
         BACKCOLOR SP_nColor9()
         FONTCOLOR SP_nColor10()
         HEADERIMAGES { "" }
         ROWSOURCE Nil
         COLUMNFIELDS Nil
         ALLOWAPPEND .F.
         ALLOWDELETE .F.
         BUFFERED .F.
         DYNAMICDISPLAY .F.
         ONSAVE Nil
         LOCKCOLUMNS 0
      END GRID

      DEFINE LABEL Label_SrvPath
         ROW 545
         COL 450
         WIDTH 400
         HEIGHT 24
         VALUE ""
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         HELPID Nil
         VISIBLE .T.
         TRANSPARENT .F.
         ACTION Nil
         AUTOSIZE .F.
         BACKCOLOR SP_nColor1()
         FONTCOLOR SP_nColor2()
      END LABEL

      DEFINE BUTTON Button_Upload
         ROW 280
         COL 430
         WIDTH 20
         HEIGHT 44
         ACTION FTPUP()
         CAPTION ""
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP "Upload files to FTP - server"
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         HELPID Nil
         FLAT .F.
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .T.
         MULTILINE .T.
         PICTURE "MYFTP16UP"
         PICTALIGNMENT TOP
      END BUTTON

      DEFINE BUTTON Button_Download
         ROW 330
         COL 430
         WIDTH 20
         HEIGHT 44
         ACTION FTPDOWN()
         CAPTION ""
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP "Download files from FTP - server"
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         HELPID Nil
         FLAT .F.
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .T.
         MULTILINE .T.
         PICTURE "MYFTP16DOWN"
         PICTALIGNMENT TOP
      END BUTTON

      DEFINE BUTTON Button_Connect1
         ROW 5
         COL 610
         WIDTH 100
         HEIGHT 28
         ACTION ftpconn1()
         CAPTION "&Connect"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
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

      DEFINE BUTTON Button_Disconnect
         ROW 5
         COL 730
         WIDTH 100
         HEIGHT 28
         ACTION ftpclose()
         CAPTION "&Disconnect"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
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

      DEFINE BUTTON Button_MD_Local
         ROW 60
         COL 490
         WIDTH 100
         HEIGHT 28
         ACTION ftpmkdir()
         CAPTION "Make Dir"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
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

      DEFINE BUTTON Button_REN_Local
         ROW 60
         COL 610
         WIDTH 100
         HEIGHT 28
         ACTION ftpren()
         CAPTION "Rename"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
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

      DEFINE BUTTON Button_DEL_Local
         ROW 60
         COL 730
         WIDTH 100
         HEIGHT 28
         ACTION ftpdel()
         CAPTION "Delete"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
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

      DEFINE LABEL Label_CurDir
         ROW 545
         COL 20
         WIDTH 400
         HEIGHT 24
         VALUE "aSubDirectory[1][1]"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         HELPID Nil
         VISIBLE .T.
         TRANSPARENT .F.
         ACTION Nil
         AUTOSIZE .F.
         BACKCOLOR SP_nColor1()
         FONTCOLOR SP_nColor2()
      END LABEL

      DEFINE BUTTON Button_MD_Remote
         ROW 59
         COL 30
         WIDTH 70
         HEIGHT 28
         ACTION localmkdir()
         CAPTION "Make Dir"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
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

      DEFINE BUTTON Button_REN_Remote
         ROW 60
         COL 110
         WIDTH 70
         HEIGHT 28
         ACTION localren()
         CAPTION "Rename"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
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

      DEFINE BUTTON Button_DEL_Remote
         ROW 60
         COL 190
         WIDTH 70
         HEIGHT 28
         ACTION LocalDel()
         CAPTION "Delete"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
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

      DEFINE COMBOBOX Combo_Drive
         ROW 60
         COL 360
         WIDTH 60
         HEIGHT 500
         ITEMS caItems
         IMAGE acImage
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         TABSTOP .T.
         DROPPEDWIDTH 150
         OnCloseUp ChangeLocalDrive( )
      END COMBOBOX

      //  DEFINE BUTTON Button_11
      //     ROW 60
      //     COL 270
      //     WIDTH 70
      //     HEIGHT 28
      //     ACTION Nil
      //     CAPTION "View"
      //     FONTNAME SP_cFontName()
      //     FONTSIZE SP_nFontSize()
      //     TOOLTIP ""
      //     ONGOTFOCUS Nil
      //     ONLOSTFOCUS Nil
      //     HELPID Nil
      //     FLAT .F.
      //     TABSTOP .T.
      //     VISIBLE .T.
      //     TRANSPARENT .F.
      //     MULTILINE .F.
      //     PICTURE Nil
      //     PICTALIGNMENT TOP
      //  END BUTTON

      //  DEFINE BUTTON Button_12
      //     ROW 60
      //     COL 350
      //     WIDTH 70
      //     HEIGHT 28
      //     ACTION Nil
      //     CAPTION "Run"
      //     FONTNAME SP_cFontName()
      //     FONTSIZE SP_nFontSize()
      //     TOOLTIP ""
      //     ONGOTFOCUS Nil
      //     ONLOSTFOCUS Nil
      //     HELPID Nil
      //     FLAT .F.
      //     TABSTOP .T.
      //     VISIBLE .T.
      //     TRANSPARENT .F.
      //     MULTILINE .F.
      //     PICTURE Nil
      //     PICTALIGNMENT TOP
      //  END BUTTON

      DEFINE LABEL Label_LocalPC
         ROW 40
         COL 20
         WIDTH 410
         HEIGHT 18
         VALUE "Local Computer"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         HELPID Nil
         VISIBLE .T.
         TRANSPARENT .F.
         ACTION Nil
         AUTOSIZE .F.
         BACKCOLOR { 0, 0, 255 }
         FONTCOLOR { 255, 255, 255 }
         CENTERALIGN .T.
      END LABEL

      DEFINE LABEL Label_FTPServer
         ROW 40
         COL 450
         WIDTH 410
         HEIGHT 17
         VALUE "FTP - Server"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         HELPID Nil
         VISIBLE .T.
         TRANSPARENT .F.
         ACTION Nil
         AUTOSIZE .F.
         BACKCOLOR { 0, 0, 255 }
         FONTCOLOR { 255, 255, 255 }
         CENTERALIGN .T.
      END LABEL

      DEFINE BUTTON Button_Sites
         ROW 5
         COL 490
         WIDTH 100
         HEIGHT 28
         ACTION SiteForm()
         CAPTION "&Sites"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
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

      DEFINE COMBOBOX Combo_Sites
         ROW 10
         COL 30
         WIDTH 390
         HEIGHT 100
         ITEMS { "" }
         VALUE 1
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         HELPID Nil
         TABSTOP .T.
         VISIBLE .T.
         SORT .F.
         ONENTER Nil
         ONDISPLAYCHANGE Nil
         DISPLAYEDIT .F.
         ITEMSOURCE sites->Name
         IMAGE Nil
         DROPPEDWIDTH Nil
         ONDROPDOWN Nil
         ONCLOSEUP Nil
      END COMBOBOX

      DEFINE PROGRESSBAR ProgressBar_1
         ROW 565
         COL 0
         WIDTH 880
         HEIGHT 3
         RANGEMIN 1
         RANGEMAX 100
         VALUE 0
         TOOLTIP ""
         HELPID Nil
         VISIBLE .F.
         SMOOTH .F.
         VERTICAL .F.
         BACKCOLOR NIL
         FORECOLOR NIL
      END PROGRESSBAR

   END WINDOW

   ftpMain.Combo_Sites.value := 1
   ftpMain.button_Disconnect.enabled := .f.
   ftpMain.Button_MD_Local.enabled := .f.
   ftpMain.Button_REN_Local.enabled := .f.
   ftpMain.Button_DEL_Local.enabled := .f.

   LoadComboImage( .T. )
   _SetWindowSizePos( "ftpMain", 0, 0, nwidth, nheight )

   //    ON KEY ESCAPE OF ftpMain ACTION ftpMain.Release
   center window ftpMain
   activate window ftpMain

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure FTPFormExit()
*+
*+    Called from ( hbftp.prg )   1 - static procedure ftpform()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE FTPFormExit()                                        // Jimmy

   IF lIsConnect = .T.
      // close open Connection
      FTPCLOSE()
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SiteForm()
*+
*+    Called from ( hbftp.prg )   1 - static procedure ftpform()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SiteForm()                                           // Jimmy

   DEFINE WINDOW sitemanager ;
              AT 0, 0 ;
              WIDTH 472 ;
              HEIGHT 295 ;
              TITLE "Site Manager" ;
              ICON NIL ;
              TOPMOST ;
              CURSOR NIL ;
              ON INIT NIL ;
              ON RELEASE NIL ;
              NOSIZE ;
              NOMAXIMIZE ;
              NOMINIMIZE ;
              ON PAINT NIL ;
              BACKCOLOR SP_nColor1()

      DEFINE BROWSE Browse_1
         ROW 10
         COL 5
         WIDTH 346
         HEIGHT 233
         VALUE 1                                                      // ftpMain.Combo_Sites.value
         WIDTHS { 600, 1000, 600, 200 }
         HEADERS { 'Name', 'Address', 'User', 'Password' }
         WORKAREA Sites
         FIELDS { 'Sites->NAME', 'Sites->ADDRESS', 'Sites->USER', 'Sites->PASSWORD' }
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE NIL
         ONGOTFOCUS NIL
         ONLOSTFOCUS NIL
         ONDBLCLICK EditForm()                                        // editsite()
         ALLOWEDIT .F.
         ALLOWAPPEND .F.
         ONHEADCLICK NIL
         ALLOWDELETE .F.
         HELPID NIL
         VALID NIL
         VALIDMESSAGES NIL
         LOCK .F.
         VSCROLLBAR .T.
         DYNAMICFORECOLOR NIL
         DYNAMICBACKCOLOR NIL
         INPUTMASK NIL
         FORMAT NIL
         WHEN NIL
         BACKCOLOR SP_nColor9()
         FONTCOLOR SP_nColor10()
         IMAGE NIL
         JUSTIFY NIL
         NOLINES .F.
         READONLYFIELDS NIL
         INPLACEEDIT .F.
      END BROWSE

      DEFINE BUTTON Button_Connect2
         ROW 10
         COL 350
         WIDTH 100
         HEIGHT 28
         CAPTION "&Connect"
         ACTION ftpconn2()
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONGOTFOCUS NIL
         ONLOSTFOCUS NIL
         HELPID NIL
         FLAT .F.
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
      END BUTTON

      DEFINE BUTTON Button_CreateSite
         ROW 40
         COL 350
         WIDTH 100
         HEIGHT 28
         CAPTION "Create &site..."
         ACTION EditForm( "new" )
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONGOTFOCUS NIL
         ONLOSTFOCUS NIL
         HELPID NIL
         FLAT .F.
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
      END BUTTON

      DEFINE BUTTON Button_EditSite
         ROW 70
         COL 350
         WIDTH 100
         HEIGHT 28
         CAPTION "&Edit..."
         ACTION EditForm()
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONGOTFOCUS NIL
         ONLOSTFOCUS NIL
         HELPID NIL
         FLAT .F.
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
      END BUTTON

      DEFINE BUTTON Button_DeleteSite
         ROW 100
         COL 350
         WIDTH 100
         HEIGHT 28
         CAPTION "&Delete"
         ACTION ftpdelete()
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONGOTFOCUS NIL
         ONLOSTFOCUS NIL
         HELPID NIL
         FLAT .F.
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
      END BUTTON

      DEFINE BUTTON Button_ExitSite
         ROW 130
         COL 350
         WIDTH 100
         HEIGHT 28
         CAPTION "E&xit"
         ACTION sitemanagerexit()
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONGOTFOCUS NIL
         ONLOSTFOCUS NIL
         HELPID NIL
         FLAT .F.
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
      END BUTTON

   END WINDOW

   ON KEY ESCAPE OF sitemanager ACTION sitemanager.Release
   center window sitemanager
   activate window sitemanager

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure EditForm()
*+
*+    Called from ( hbftp.prg )   3 - static procedure siteform()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE EditForm( xParam )                                   // Jimmy

   DEFINE WINDOW editsitemanager ;
              AT 324, 493 ;
              WIDTH 450 ;
              HEIGHT 320 ;
              TITLE "FTP Server Properties" ;
              ICON NIL ;
              TOPMOST ;
              ON INIT Nil ;
              ON RELEASE Nil ;
              NOSIZE ;
              NOMAXIMIZE ;
              NOMINIMIZE ;
              ON PAINT Nil ;
              BACKCOLOR SP_nColor1()

      DEFINE FRAME Frame_1
         ROW 19
         COL 10
         WIDTH 410
         HEIGHT 205
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         CAPTION NIL
         BACKCOLOR Nil
         FONTCOLOR Nil
         OPAQUE .T.
      END FRAME

      DEFINE LABEL Label_Name
         ROW 30
         COL 20
         WIDTH 60
         HEIGHT 24
         VALUE "Site name"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         HELPID Nil
         VISIBLE .T.
         TRANSPARENT .F.
         ACTION Nil
         AUTOSIZE .F.
         BACKCOLOR SP_nColor1()
         FONTCOLOR SP_nColor2()
      END LABEL

      DEFINE LABEL Label_Adress
         ROW 60
         COL 20
         WIDTH 80
         HEIGHT 24
         VALUE "FTP Server"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         HELPID Nil
         VISIBLE .T.
         TRANSPARENT .F.
         ACTION Nil
         AUTOSIZE .F.
         BACKCOLOR SP_nColor1()
         FONTCOLOR SP_nColor2()
      END LABEL

      DEFINE LABEL Label_Port                                         // Jimmy
         ROW 90
         COL 20
         WIDTH 80
         HEIGHT 24
         VALUE "Port"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         HELPID Nil
         VISIBLE .T.
         TRANSPARENT .F.
         ACTION Nil
         AUTOSIZE .F.
         BACKCOLOR SP_nColor1()
         FONTCOLOR SP_nColor2()
      END LABEL

      DEFINE LABEL Label_User
         ROW 120
         COL 20
         WIDTH 60
         HEIGHT 24
         VALUE "User id"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         HELPID Nil
         VISIBLE .T.
         TRANSPARENT .F.
         ACTION Nil
         AUTOSIZE .F.
         BACKCOLOR SP_nColor1()
         FONTCOLOR SP_nColor2()
      END LABEL

      DEFINE LABEL Label_PW
         ROW 150
         COL 20
         WIDTH 60
         HEIGHT 24
         VALUE "Password"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         HELPID Nil
         VISIBLE .T.
         TRANSPARENT .F.
         ACTION Nil
         AUTOSIZE .F.
         BACKCOLOR SP_nColor1()
         FONTCOLOR SP_nColor2()
      END LABEL

      DEFINE LABEL Label_SPath
         ROW 180
         COL 20
         WIDTH 65
         HEIGHT 24
         VALUE "Initial Path"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         HELPID Nil
         VISIBLE .T.
         TRANSPARENT .F.
         ACTION Nil
         AUTOSIZE .F.
         BACKCOLOR SP_nColor1()
         FONTCOLOR SP_nColor2()
      END LABEL

      DEFINE TEXTBOX Text_Name
         ROW 30
         COL 110
         WIDTH 300
         HEIGHT 24
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         ONENTER Nil
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

      DEFINE TEXTBOX Text_Adress
         ROW 60
         COL 110
         WIDTH 300
         HEIGHT 24
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         ONENTER Nil
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

      DEFINE TEXTBOX Text_Port
         ROW 90
         COL 110
         WIDTH 100
         HEIGHT 24
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         ONENTER Nil
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
         DATATYPE NUMERIC
         INPUTMASK "99999"
         FORMAT Nil
         VALUE ""
      END TEXTBOX

      DEFINE TEXTBOX Text_User
         ROW 120
         COL 110
         WIDTH 300
         HEIGHT 24
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         ONENTER Nil
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

      DEFINE TEXTBOX Text_PW
         ROW 150
         COL 110
         WIDTH 180
         HEIGHT 24
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         ONENTER Nil
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

      DEFINE CHECKBOX Check_MaskPW
         ROW 147
         COL 300
         WIDTH 110
         HEIGHT 28
         CAPTION "Mask Password"
         VALUE .F.
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE ShowPassword()
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         BACKCOLOR NIL
         FONTCOLOR NIL
         HELPID Nil
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
      END CHECKBOX

      DEFINE TEXTBOX Text_SPath
         ROW 180
         COL 110
         WIDTH 241
         HEIGHT 24
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         ONENTER Nil
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
         VALUE "/"
      END TEXTBOX

      DEFINE CHECKBOX Check_Log
         ROW 177
         COL 370
         WIDTH 40
         HEIGHT 28
         CAPTION "Log"
         VALUE .F.
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
         ONCHANGE Nil
         ONGOTFOCUS Nil
         ONLOSTFOCUS Nil
         BACKCOLOR NIL
         FONTCOLOR NIL
         HELPID Nil
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
      END CHECKBOX

      DEFINE BUTTON Button_Save
         ROW 235
         COL 200
         WIDTH 100
         HEIGHT 30
         ACTION ftppropsave()
         CAPTION "&Save"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
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

      DEFINE BUTTON Button_Cancel
         ROW 235
         COL 320
         WIDTH 100
         HEIGHT 30
         ACTION ftppropcancel()
         CAPTION "Cancel"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TOOLTIP ""
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

   IF xParam = NIL
      newRecord := .f.
      sites->( DBGOTO( sitemanager.browse_1.value ) )
      editsitemanager.Text_Name.value := sites->name
      editsitemanager.Text_Adress.value := sites->address
      editsitemanager.Text_User.value := sites->user
      editsitemanager.Text_PW.value := desencri( sites->password )    // decript
      editsitemanager.Text_SPath.value := Sites->SPath
      editsitemanager.Check_Log.value := Sites->Log

      editsitemanager.Text_Port.value := Sites->Port                  // Jimmy

   ELSE
      newRecord := .t.

      editsitemanager.Text_User.value := "anonimous"
      editsitemanager.Text_PW.value := "anonimous"
   ENDIF

   ON KEY ESCAPE OF editsitemanager ACTION editsitemanager.Release
   center window editsitemanager
   activate window editsitemanager

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function sitemanagerexit()
*+
*+    Called from ( hbftp.prg )   1 - static procedure siteform()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION sitemanagerexit()

   RELEASE window sitemanager
RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function ftppropcancel()
*+
*+    Called from ( hbftp.prg )   1 - static procedure editform()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION ftppropcancel()

   RELEASE window editsitemanager
RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function ftpdelete()
*+
*+    Called from ( hbftp.prg )   1 - static procedure siteform()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION ftpdelete()

LOCAL nRec := sitemanager.browse_1.value

   IF msgyesno( 'Are You Sure?', 'Delete Record' ) == .f.
      RETURN nil
   ENDIF
   sites->( DBDELETE( sitemanager.browse_1.value ) )
   sites->( __dbpack() )
   IF nRec < 2
      sitemanager.browse_1.value := 1
      ftpMain.Combo_Sites.value := 1
   ELSE
      sitemanager.browse_1.value := nRec - 1
   ENDIF
   sitemanager.browse_1.refresh
   FillFTPCombo()
RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function ftppropsave()
*+
*+    Called from ( hbftp.prg )   1 - static procedure editform()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION ftppropsave()

   IF newRecord = .t.
      sites->( DBAPPEND() )
   ENDIF
   IF LEFT( editsitemanager.Text_SPath.value, 1 ) != "/"
      editsitemanager.Text_SPath.value := "/" + editsitemanager.Text_SPath.value
   ENDIF
   sites->Name := editsitemanager.Text_Name.value
   sites->Address := editsitemanager.Text_Adress.value
   sites->User := editsitemanager.Text_User.value
   sites->Password := encrip( editsitemanager.Text_PW.value )         // encript
   sites->Spath := editsitemanager.Text_SPath.value
   sites->Log := editsitemanager.Check_Log.value

   Sites->Port := editsitemanager.Text_Port.value                     // Jimmy

   sitemanager.browse_1.refresh
   FillFTPCombo()
   RELEASE window editsitemanager
RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function FillFTPCombo()
*+
*+    Called from ( hbftp.prg )   1 - static function ftpdelete()
*+                                   1 - static function ftppropsave()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION FillFTPCombo()

   ftpMain.Combo_Sites.refresh
RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function ftpconn1()
*+
*+    Called from ( hbftp.prg )   1 - static procedure ftpform()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION ftpconn1()

   IF sites->( RECCOUNT() ) > 0
      sites->( DBGOTO( ftpMain.Combo_Sites.value ) )
      ftpconnect()
   ELSE
      MsgInfo( "No available sites", "Alert" )
   ENDIF
RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function ftpconn2()
*+
*+    Called from ( hbftp.prg )   1 - static procedure siteform()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION ftpconn2()

   sites->( DBGOTO( sitemanager.browse_1.value ) )
   ftpMain.Combo_Sites.value := sitemanager.browse_1.value
   ftpconnect()
   RELEASE window sitemanager
RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function ftpConnect()
*+
*+    Called from ( hbftp.prg )   1 - static function ftpconn1()
*+                                   1 - static function ftpconn2()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION ftpConnect()

LOCAL bError
LOCAL lConnect  := .F.
LOCAL cUser     := sites->user
LOCAL cPassWord := desencri( sites->password )
LOCAL cServer   := sites->address
LOCAL nPort     := sites->Port
LOCAL cProtocol := "ftp://"
LOCAL cUrl, oError

   cUrl := cProtocol + ALLTRIM( cUser ) + ":" + ALLTRIM( cPassWord ) + "@" + ALLTRIM( cServer )
   //    IF EMPTY( nPort )
   oUrl := tURL() :New( cUrl )
   //    ELSE
   //       oUrl := tURL() :New( cUrl ) + ":" + hb_NTOS( nPort )
   //    ENDIF

   IF EMPTY( oUrl )
      RETURN nil
   ENDIF

   //    oUrl:cProto  := "ftp://"
   //    oUrl:cServer := cServer
   //    oUrl:cUserID := cUser
   //    oUrl:cPassword := cPassword
   IF !EMPTY( nPort )
      oURL:nPort := nPort
   ENDIF

   bError := ERRORBLOCK( { | oErr | BREAK( oErr ) } )
   BEGIN SEQUENCE
      oClient := TIpClientFtp() :new( oUrl, Sites->Log )              // PARAM .T. TO LOG
   RECOVER
      ERRORBLOCK( bError )
      MsgInfo( "can not Open() the connection, try again ", "Attention message" )
      RETURN nil
   END SEQUENCE
   ERRORBLOCK( bError )

   IF EMPTY( oClient )
      RETURN nil
   ENDIF
   oClient:nConnTimeout := 2000
   oClient:bUsePasv := .T.

   // Comprobamos si el usuario contiene una @ para forzar el userid
   // We check if the user contains an @ to force the userid
   IF AT( "@", cUser ) > 0
      oClient:oUrl:cServer := cServer
      oClient:oUrl:cUserID := cUser
      oClient:oUrl:cPassword := cPassword
      IF !EMPTY( nPort )
         oClient:oURL:nPort := nPort
      ENDIF
   ENDIF

   bError := ERRORBLOCK( { | oErr | BREAK( oErr ) } )
   BEGIN SEQUENCE
      IF oClient:Open()
         lConnect := .T.
      ELSE
         lConnect := .F.
         MsgInfo( "Connection is not opened", "Alert" )
      ENDIF
   RECOVER USING oError
      ERRORBLOCK( bError )
      MsgInfo( "Connection FAIL" + CRLF + ;
               oError:description + CRLF + oError:operation, "Error " + HB_VALTOSTR( oError:osCode ) )
   END SEQUENCE
   ERRORBLOCK( bError )

   IF lConnect = .T.
      IF EMPTY( oClient:cReply )
         oClient:Pasv()
      ELSE
         oClient:Pasv()
      ENDIF
      ftpMain.button_Disconnect.enabled := .t.
      ftpMain.Button_MD_Local.enabled := .t.
      ftpMain.Button_REN_Local.enabled := .t.
      ftpMain.Button_DEL_Local.enabled := .t.
      ftpMain.button_Connect1.enabled := .f.

      IF !EMPTY( Sites->SPath )
         oClient:CWD( ALLTRIM( Sites->Spath ) )
         ftpMain.Label_SrvPath.value := ALLTRIM( Sites->Spath )
         FTPFILLGRID()
      ELSE
         ftpMain.Label_SrvPath.value := "/"
         FTPFILLGRID()
      ENDIF

      lIsConnect := .T.
   ENDIF
RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function FTPFILLGRID()
*+
*+    Called from ( hbftp.prg )   2 - static function ftpconnect()
*+                                   1 - static function ftpcwd()
*+                                   1 - static function ftpren()
*+                                   1 - static function ftpmkdir()
*+                                   1 - static function ftpdel()
*+                                   1 - static function ftpup()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION FTPFILLGRID()

LOCAL ctext, cSepChar, nPos, acDir, cLine, x, avalues, xpesq, xpos, cvalue, cvalue1
LOCAL nX, cFileName, nDirImg
LOCAL ii, iMax, cDate, cTime, cSize, cFile

   acDir := {}

   //  #DEFINE Use_Original .T.
#IFDEF Use_Original

   ctext := oClient:List()
   oClient:reset()
   cSepChar := CRLF
   nPos := AT( cSepChar, ctext )
   IF nPos == 0
      IF !EMPTY( ctext )                                              // single line, just one file, THEREFORE there won't be any CRLF's!
         ctext += CRLF
      ELSE
         cSepChar := CHR( 10 )
      ENDIF
      nPos := AT( cSepChar, ctext )
   ENDIF

   DO WHILE nPos > 0                                                  //.and. ! Eval( ::bAbort )
      cLine := ALLTRIM( LEFT( ctext, nPos - 1 ) )
      ctext := SUBSTR( ctext, nPos + LEN( cSepChar ) )
      cLine := ALLTRIM( STRTRAN( cLine, CHR( 0 ), "" ) )

      IF( !EMPTY( cLine ), AADD( acDir, cLine ), Nil )

      nPos := AT( cSepChar, ctext )
      DO EVENTS
   ENDDO

   ftpMain.Grid_FTP.DisableUpdate
   ftpMain.Grid_FTP.DeleteAllItems

   nPos := IF( LEN( acDir ) > 0 .AND. acDir[ 1 ] == "[..]", 2, 1 )

   // Pierpaolo 20/5/2018 add backward row for certain ftp server Ie Nas

   IF EMPTY( ATAIL( acdir ) ) .AND. LEN( LEFT( ftpMain.Label_SrvPath.value, 2 ) ) > 1
      ftpMain.Grid_FTP.AddItem( { 0, ".", "", "", "", "drwxrwxrwx" } )
      ftpMain.Grid_FTP.AddItem( { 0, "..", "", "", "", "drwxrwxrwx" } )
      ftpMain.Grid_FTP.EnableUpdate
      RETURN nil
   ENDIF

   IF RIGHT( acdir[ 1 ], 1 ) != "." .AND. LEN( LEFT( ftpMain.Label_SrvPath.value, 2 ) ) > 1
      ftpMain.Grid_FTP.AddItem( { 0, ".", "", "", "", "drwxrwxrwx" } )
      ftpMain.Grid_FTP.AddItem( { 0, "..", "", "", "", "drwxrwxrwx" } )
   ENDIF

   FOR x = nPos TO LEN( acDir )
      avalues := {}
      xpesq := ALLTRIM( acDir[ x ] )
      DO WHILE .t.
         xpos := AT( ' ', xpesq )
         IF xpos = 0
            AADD( avalues, xpesq )
            cFileName := ""
            FOR nX := 10 TO LEN( avalues )
               //  for nX := 1 to len(avalues)
               cFileName += avalues[ nX ] + ' '
            NEXT
            cFileName := IF( SUBSTR( avalues[ 1 ], 1, 1 ) = 'l', SUBSTR( cFileName, 1, AT( '->', cFileName ) - 1 ), RTRIM( cFileName ) )
            nDirImg := IF( SUBSTR( avalues[ 1 ], 1, 1 ) = 'd', 0, 1 )

            IF LEN( avalues ) > 8
               ftpMain.Grid_FTP.AddItem( { nDirImg, cFileName, avalues[ 5 ], STRZERO( VAL( avalues[ 7 ] ), 2 ) + '.' + STRZERO( nMONTH( avalues[ 6 ] ), 2 ) + '.' + avalues[ 8 ], avalues[ 9 ], avalues[ 1 ] } )
            ELSE
               ftpMain.Grid_FTP.AddItem( { nDirImg, avalues[ 4 ], 0, avalues[ 1 ], avalues[ 2 ], avalues[ 3 ] } )
            ENDIF
            EXIT
         ENDIF
         cvalue := SUBSTR( xpesq, 1, xpos - 1 )
         xpesq := LTRIM( SUBSTR( xpesq, xpos + 1, LEN( xpesq ) ) )
         IF LEN( avalues ) < 7 .OR. LEN( avalues ) > 8
            AADD( avalues, cvalue )
         ELSE
            IF AT( ':', cvalue ) > 0
               cvalue1 := ALLTRIM( STR( YEAR( DATE() ) ) )
               AADD( avalues, cvalue1 )                               // year
               AADD( avalues, cvalue )                                // time
            ELSE
               AADD( avalues, cvalue )                                // year
               AADD( avalues, "" )                                    // time
            ENDIF
         ENDIF
      ENDDO

   NEXT x

#ELSE                                            // Jimmy

   ftpMain.Grid_FTP.DisableUpdate
   ftpMain.Grid_FTP.DeleteAllItems

   // add backward row for certain ftp server Ie Nas
   //  ftpMain.Grid_FTP.AddItem( { 0, ".", "", "", "", "drwxrwxrwx" } )
   ftpMain.Grid_FTP.AddItem( { 0, "..", "", "", "", "drwxrwxrwx" } )

   acDir := oClient:list()                                            // on serverside
   oClient:reset()
   avalues := AtInside( CRLF, acDir )

   iMax := LEN( avalues )
   FOR x := 1 TO iMax
      cLine := avalues[ x ]
      cDate := SUBSTR( cLine, 1, 8 )
      cTime := SUBSTR( cLine, 11, 7 )
      cSize := SUBSTR( cLine, 18, 22 )
      cFile := SUBSTR( cLine, 40 )

      IF !EMPTY( cFile )
         nDirImg := IF( 'DIR' $ cSize, 0, 1 )

         ftpMain.Grid_FTP.AddItem( { nDirImg, ;
                                     cFile, ;
                                     LTRIM( cSize ), ;
                                     cDate, ;
                                     cTime, ;
                                     "" } )
      ENDIF
   NEXT

#ENDIF

   ftpMain.Grid_FTP.EnableUpdate
RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function LOCALMKDIR()
*+
*+    Called from ( hbftp.prg )   1 - static procedure ftpform()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION LOCALMKDIR()

LOCAL cfile := INPUTBOX( 'NEW DIR NAME ?' )
LOCAL cF    := GetcurrentFolder()

   IF DIRCHANGE( cF + '\' + cfile ) > 0
      IF MAKEDIR( cF + '\' + cfile ) = 0
         GetDirectory( cF + '\*.*', 1 )
      ELSE
         MsgStop( "Permission Denied!" )
      ENDIF
   ENDIF
RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function LOCALREN()
*+
*+    Called from ( hbftp.prg )   1 - static procedure ftpform()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION LOCALREN()

LOCAL cFileOld := CharRem( "[]", getcurrentfolder() + '\' + getcolvalue( "Grid_Local", "FTPMAIN", IDG_NAME ) )
LOCAL cFileNew, ctype := ALLTRIM( getcolvalue( "Grid_Local", "FTPMAIN", IDG_DIRSIZE ) )
   cFileNew := INPUTBOX( 'NEW FILE NAME ?',, CharRem( "[]", getcolvalue( "Grid_Local", "FTPMAIN", IDG_NAME ) ) )
   cFileNew := getcurrentfolder() + '\' + cFileNew
   RENAME( cFileOld ) TO ( cFileNew )
   GetDirectory( getcurrentfolder() + '\*.*', 1 )
   ftpMain.Grid_Local.refresh
RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function LOCALDEL()
*+
*+    Called from ( hbftp.prg )   1 - static procedure ftpform()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION LOCALDEL()

LOCAL ctype := ALLTRIM( getcolvalue( "Grid_Local", "FTPMAIN", IDG_DIRSIZE ) )
LOCAL cFile := getcurrentfolder() + '\' + getcolvalue( "Grid_Local", "FTPMAIN", IDG_NAME )

   IF msgyesno( 'Are You Sure?', 'You are deleting the ' + IIF( ctype = '<DIR>', 'folder "', 'file "' ) + cFile + '"' ) == .f.
      RETURN nil
   ENDIF

   IF .NOT. EMPTY( cFile )
      IF ctype = '<DIR>'
         cfile := STRTRAN( cfile, '[', '' )
         cfile := STRTRAN( cfile, ']', '' )
         IF !removefolder( cfile )
            MsgStop( "Not Empty Folder", "Permission Denied!" )
         ENDIF
      ELSE
         ERASE (cFile)
      ENDIF

      GetDirectory( getcurrentfolder() + '\*.*', 1 )
   ENDIF
RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function FTPCWD()
*+
*+    Called from ( hbftp.prg )   1 - static procedure ftpform()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION FTPCWD()

LOCAL lresp, cpath, cfolder := "/", dg
LOCAL ctype    := SUBSTR( getcolvalue( "Grid_FTP", "FTPMAIN", IDG_ATTR ), 1, 1 )
LOCAL cDirSize := getcolvalue( "Grid_FTP", "FTPMAIN", IDG_DIRSIZE )

   IF ctype = 'd' .OR. "DIR" $ cDirSize                               // Jimmy
      lresp := oClient:PWD
      cpath := oClient:cReply
      IF cpath == '/'
         cfolder := '/' + getcolvalue( "Grid_FTP", "FTPMAIN", IDG_NAME )
      ELSE
         dg := getcolvalue( "Grid_FTP", "FTPMAIN", IDG_NAME )
         IF ASCAN( { ".", ".." }, dg ) > 0
            cfolder := SUBSTR( cpath, 1, RAT( "/", cPath ) - 1 )
            IF EMPTY( cFolder )
               cFolder := "/"
            ENDIF
         ELSE
            cfolder := cpath + '/' + getcolvalue( "Grid_FTP", "FTPMAIN", IDG_NAME )
         ENDIF
      ENDIF
      lresp := oClient:CWD( cfolder )
      ftpMain.Label_SrvPath.value := cFolder
      FTPFILLGRID()
   ENDIF
   IF EMPTY( cfolder ) .OR. LEFT( cFolder, 2 ) = "/."
      ftpMain.Label_SrvPath.value := "/"
   ELSE
      ftpMain.Label_SrvPath.value := cFolder
   ENDIF
RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function FTPCLOSE()
*+
*+    Called from ( hbftp.prg )   1 - static procedure ftpform()
*+                                   1 - static procedure ftpformexit()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION FTPCLOSE()

LOCAL lresp := oClient:CLOSE()

   ftpMain.Grid_FTP.DeleteAllItems
   ftpMain.button_Disconnect.enabled := .f.
   ftpMain.Button_MD_Local.enabled := .f.
   ftpMain.Button_REN_Local.enabled := .f.
   ftpMain.Button_DEL_Local.enabled := .f.
   ftpMain.button_Connect1.enabled := .t.
   ftpMain.Label_SrvPath.value := ""

   lIsConnect := .F.

RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function FTPREN()
*+
*+    Called from ( hbftp.prg )   1 - static procedure ftpform()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION FTPREN()

LOCAL cFileOld := getcolvalue( "Grid_FTP", "FTPMAIN", IDG_NAME )
LOCAL cFileNew := INPUTBOX( 'NEW FILE NAME ?',, getcolvalue( "Grid_FTP", "FTPMAIN", IDG_NAME ) )
LOCAL lresp    := oClient:RENAME( cFileOld, cFileNew )
   FTPFILLGRID()
RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function FTPMKDIR()
*+
*+    Called from ( hbftp.prg )   1 - static procedure ftpform()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION FTPMKDIR()

LOCAL cFile := INPUTBOX( 'NEW DIR NAME ?' )
LOCAL lresp := oClient:MKD( cFile )
   FTPFILLGRID()
RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function FTPDEL()
*+
*+    Called from ( hbftp.prg )   1 - static procedure ftpform()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION FTPDEL()

LOCAL lresp
LOCAL cFile    := getcolvalue( "Grid_FTP", "FTPMAIN", IDG_NAME )
LOCAL ctype    := SUBSTR( getcolvalue( "Grid_FTP", "FTPMAIN", IDG_ATTR ), 1, 1 )
LOCAL cDirSize := getcolvalue( "Grid_FTP", "FTPMAIN", IDG_DIRSIZE )

   IF msgyesno( 'Are You Sure?', 'You are deleting the ' + IIF( ctype = 'd', 'folder "', 'file "' ) + cFile + '"' ) == .f.
      RETURN nil
   ENDIF

   IF .NOT. EMPTY( cFile )
      //ctype := substr(getcolvalue("Grid_FTP","FTPMAIN",IDG_ATTR),1,1)
      IF ctype = 'd' .OR. "DIR" $ cDirSize                            // Jimmy
         lresp := oClient:RMD( cFile )
      ELSE
         lresp := oClient:Dele( cFile )
      ENDIF
      ftpfillgrid()
   ENDIF
RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function DoProgress()
*+
*+    Called from ( hbftp.prg )   1 - static function ftpdown()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION DoProgress( nCount, nMax, nSize )

LOCAL nEvery, nPercent

   nMax := MAX( nMax, nSize )

   IF nMax < 100
      nEvery := 100 / nMax
   ELSE
      nEvery := INT( nMax / 100 )
   ENDIF

   nPercent := CalcPos( nCount, nMax )
   //    IF ( nCount % nEvery ) = 0
   IF nLast <> nPercent
      nLast := nPercent
      SetProperty( "FTPMAIN", "ProgressBar_1", "Value", nPercent )
      // onDummy(nSize,nMax,nEvery,nCount, CalcPos( nCount, nMax ))
      onDummy( nCount, nPercent )
   ENDIF
   DO EVENTS

RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function FTPDOWN()
*+
*+    Called from ( hbftp.prg )   1 - static procedure ftpform()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION FTPDOWN()

LOCAL lresp
LOCAL cFile    := getcolvalue( "Grid_FTP", "FTPMAIN", IDG_NAME )
LOCAL cDirSize := getcolvalue( "Grid_FTP", "FTPMAIN", IDG_DIRSIZE )
LOCAL cPathSrv := ""
LOCAL cPathLoc := getcurrentfolder() + "\"
LOCAL cSource
LOCAL cTarget
LOCAL nSize    := VAL( cDirSize )

   ALTD()
   IF ftpMain.Grid_Local.cell( 1, 2 ) # '[..]'
      setcurrentfolder( 'c:\' )
   ENDIF
   IF ISOBJECT( oClient )

      ftpMain.Button_Upload.Enabled := .F.
      ftpMain.Button_Download.Enabled := .F.

      nLast := 0
      oClient:bUsePasv := .T.
      oClient:nConnTimeout := 20000
      oClient:exGauge := { | nCount, nMax | DoProgress( nCount, nMax, nSize ) }

      // cPathSrv += oClient:oUrl:cServer
      // cPathSrv += ftpMain.Label_SrvPath.value
      cSource := cPathSrv + cFile

      cPathLoc := STRTRAN( cPathLoc, "\\", "\" )
      cTarget := cPathLoc + cFile

      SetProperty( "FTPMAIN", "ProgressBar_1", "VISIBLE", .T. )
      SetProperty( "FTPMAIN", "ProgressBar_1", "Value", 0 )

      lresp := oClient:DownloadFile( cTarget, cSource )
      ALTD()
      cPathLoc := getcurrentfolder()
      GetDirectory( cPathLoc + '\*.*', 1 )
      IF VALTYPE( lresp ) = "L"
         IF lresp != .t.
            // MsgStop('Error was arised at downloading!')
            // ? "Could not connect to FTP server", oURL:cServer
            // MsgStop("Could not connect to FTP server", oClient:oUrl:cServer )

            IF oClient:SocketCon == NIL
               MsgStop( "Connection not initialized" )
            ELSEIF hb_inetErrorCode( oClient:SocketCon ) == 0
               MsgStop( oClient:cReply, "Server response:" )
            ELSE
               MsgStop( hb_inetErrorDesc( oClient:SocketCon ), "Error in connection:" )
            ENDIF

         ENDIF
      ENDIF
      SetProperty( "FTPMAIN", "ProgressBar_1", "VISIBLE", .F. )
      nLast := 0
      ftpMain.Button_Upload.Enabled := .T.
      ftpMain.Button_Download.Enabled := .T.

   ENDIF

RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function FTPUP()
*+
*+    Called from ( hbftp.prg )   1 - static procedure ftpform()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION FTPUP()

LOCAL lresp
LOCAL cFile  := getcolvalue( "Grid_Local", "FTPMAIN", IDG_NAME )
LOCAL cFile1 := getcurrentfolder() + '\' + cFile

   IF ftpMain.Grid_Local.cell( 1, 2 ) # '[..]'
      cFile1 := 'C:\' + cFile
   ENDIF
   IF FILE( cFile1 )
      IF ISOBJECT( oClient )
         //       oClient:TypeA()
         oClient:bUsePasv := .T.

         ftpMain.Button_Upload.Enabled := .F.
         ftpMain.Button_Download.Enabled := .F.

         lresp := oClient:UploadFile( cFile1 )
         IF VALTYPE( lresp ) = "L"
            IF lresp = .t.
               ftpfillgrid()
            ELSE
               MsgStop( 'Error was arised at uploading!' )
            ENDIF
         ENDIF

         ftpMain.Button_Upload.Enabled := .T.
         ftpMain.Button_Download.Enabled := .T.

      ENDIF
   ENDIF
RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function GetColValue()
*+
*+    Called from ( hbftp.prg )   3 - static function localren()
*+                                   2 - static function localdel()
*+                                   5 - static function ftpcwd()
*+                                   2 - static function ftpren()
*+                                   3 - static function ftpdel()
*+                                   2 - static function ftpdown()
*+                                   1 - static function ftpup()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GetColValue( xObj, xForm, nCol )

LOCAL nPos := GetProperty( xForm, xObj, 'Value' )
LOCAL aRet := GetProperty( xForm, xObj, 'Item', nPos )
RETURN aRet[ nCol ]

*+--------------------------------------------------------------------
*+
*+    Static Function GetArrayColValue()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GetArrayColValue( xObj, xForm, nCol )                 // Jimmy unused

LOCAL aPos := GetProperty( xForm, xObj, 'Value' )
LOCAL ii, iMax, nPos, xValue, aRet := {}

   iMax := LEN( aPos )
   FOR ii := 1 TO iMax
      nPos := aPos[ ii ]
      xValue := GetProperty( xForm, xObj, 'Item', nPos )
      AADD( aRet, xValue )
   NEXT

RETURN aRet

*+--------------------------------------------------------------------
*+
*+    Static Function initgrid()
*+
*+    Called from ( hbftp.prg )   1 - static procedure ftpform()
*+                                   1 - static procedure changelocaldrive()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION initgrid()

   GetDirectory( aSubDirectory[ 1 ] [ 1 ] + '\*.*', 1 )
   lfirst := .f.

RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function nMonth()
*+
*+    Called from ( hbftp.prg )   1 - static function ftpfillgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION nMonth( xParam )                                      // unused

LOCAL RETVAL := 0

   IF UPPER( xParam ) = 'JAN'
      RETVAL := 1
   ELSEIF UPPER( xParam ) = 'FEB'
      RETVAL := 2
   ELSEIF UPPER( xParam ) = 'MAR'
      RETVAL := 3
   ELSEIF UPPER( xParam ) = 'APR'
      RETVAL := 4
   ELSEIF UPPER( xParam ) = 'MAY'
      RETVAL := 5
   ELSEIF UPPER( xParam ) = 'JUN'
      RETVAL := 6
   ELSEIF UPPER( xParam ) = 'JUL'
      RETVAL := 7
   ELSEIF UPPER( xParam ) = 'AUG'
      RETVAL := 8
   ELSEIF UPPER( xParam ) = 'SEP'
      RETVAL := 9
   ELSEIF UPPER( xParam ) = 'OCT'
      RETVAL := 10
   ELSEIF UPPER( xParam ) = 'NOV'
      RETVAL := 11
   ELSEIF UPPER( xParam ) = 'DEC'
      RETVAL := 12
   ENDIF
RETURN ( RETVAL )

*+--------------------------------------------------------------------
*+
*+    Static Procedure Head_click()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Head_click( nCol )                                   // unused

LOCAL nPos := IF( nGridFocus = 1, ftpMain.Grid_Local.Value, ftpMain.Grid_FTP.Value ), ;
                     nOldCol := aSortCol[ nGridFocus ]

   IF nCol = 2
      ASORT( aDirectory[ nGridFocus ],,, { | a, b | IF( VALTYPE( a[ 3 ] ) # "N" .AND. VALTYPE( b[ 3 ] ) # "N", ;
              SUBSTR( a[ 2 ], 2 ) < SUBSTR( b[ 2 ], 2 ), IF( VALTYPE( a[ 3 ] ) # "N", SUBSTR( a[ 1 ], 2 ) < CHR( 254 ) + b[ 1 ], ;
              IF( VALTYPE( b[ 2 ] ) # "N", CHR( 254 ) + a[ 1 ] < SUBSTR( b[ 1 ], 2 ), a[ 1 ] < b[ 1 ] ) ) ) } )
   ELSEIF nCol = 3
      ASORT( aDirectory[ nGridFocus ],,, { | a, b | IF( VALTYPE( a[ 2 ] ) # "N" .AND. VALTYPE( b[ 2 ] ) # "N", ;
              SUBSTR( a[ 1 ], 2 ) < SUBSTR( b[ 1 ], 2 ), IF( VALTYPE( a[ 2 ] ) # "N", SUBSTR( a[ 1 ], 2 ) < CHR( 254 ) + b[ 1 ], ;
              IF( VALTYPE( b[ 2 ] ) # "N", CHR( 254 ) + a[ 1 ] < SUBSTR( b[ 1 ], 2 ), a[ 2 ] < b[ 2 ] ) ) ) } )
   ELSEIF nCol = 4
      ASORT( aDirectory[ nGridFocus ],,, { | a, b | IF( VALTYPE( a[ 2 ] ) # "N" .AND. VALTYPE( b[ 2 ] ) # "N", ;
              SUBSTR( a[ 1 ], 2 ) < SUBSTR( b[ 1 ], 2 ), IF( VALTYPE( a[ 2 ] ) # "N", SUBSTR( a[ 1 ], 2 ) < CHR( 254 ) + b[ 1 ], ;
              IF( VALTYPE( b[ 2 ] ) # "N", CHR( 254 ) + a[ 1 ] < SUBSTR( b[ 1 ], 2 ), a[ 3 ] < b[ 3 ] ) ) ) } )
   ELSEIF nCol = 5
      ASORT( aDirectory[ nGridFocus ],,, { | a, b | IF( VALTYPE( a[ 2 ] ) # "N" .AND. VALTYPE( b[ 2 ] ) # "N", ;
              SUBSTR( a[ 1 ], 2 ) < SUBSTR( b[ 1 ], 2 ), IF( VALTYPE( a[ 2 ] ) # "N", SUBSTR( a[ 1 ], 2 ) < CHR( 254 ) + b[ 1 ], ;
              IF( VALTYPE( b[ 2 ] ) # "N", CHR( 254 ) + a[ 1 ] < SUBSTR( b[ 1 ], 2 ), a[ 4 ] < b[ 4 ] ) ) ) } )
   ENDIF

   IF nGridFocus = 1
      _SetGridCaption( "Grid_Local", "FTPMAIN", nOldCol, ;
                       SUBSTR( ftpMain.Grid_Local.Header( nOldCol ), 2, LEN( ftpMain.Grid_Local.Header( nOldCol ) ) - 2 ), ;
                       IF( nOldCol = 1, BROWSE_JTFY_LEFT, IF( nOldCol = 2, BROWSE_JTFY_RIGHT, BROWSE_JTFY_CENTER ) ) )
   ENDIF

   aSortCol[ nGridFocus ] := nCol

   IF nGridFocus = 1
      ftpMain.Grid_Local.DisableUpdate
      ftpMain.Grid_Local.DeleteAllItems
      AEVAL( aDirectory[ nGridFocus ], { | e | ftpMain.Grid_Local.AddItem( { IF( VALTYPE( e[ 2 ] ) = "N", 0, 1 ), e[ 1 ], ;
              IF( VALTYPE( e[ 2 ] ) = "N", STR( e[ 2 ] ), e[ 2 ] ), DTOC( e[ 3 ] ), e[ 4 ] } ) } )
      _SetGridCaption( "Grid_Local", "FTPMAIN", nCol, "[" + ftpMain.Grid_Local.Header( nCol ) + "]", IF( nCol = 2, BROWSE_JTFY_LEFT, IF( nCol = 3, BROWSE_JTFY_RIGHT, BROWSE_JTFY_CENTER ) ) )
      ftpMain.Grid_Local.Value := IF( EMPTY( nPos ), 1, nPos )
      ftpMain.Grid_Local.EnableUpdate
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function GetDirectory()
*+
*+    Called from ( hbftp.prg )   1 - static function localmkdir()
*+                                   1 - static function localren()
*+                                   1 - static function localdel()
*+                                   1 - static function ftpdown()
*+                                   1 - static function initgrid()
*+                                   2 - static function verify()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GetDirectory( cVar, nFocus )

LOCAL aDir := {}, aAux := {}, nSortCol
LOCAL cDir, i := 1, j := 1

   cDir := ALLTRIM( cVar )
   aDir := DIRECTORY( cDir, 'D' )

   IF ( i := ASCAN( aDir, { | e | ALLTRIM( e[ 1 ] ) = "." } ) ) > 0
      ADEL( aDir, i )
      ASIZE( aDir, LEN( aDir ) - 1 )
   ENDIF
   IF LEN( aDir ) = 0
      AADD( aDir, { "..", 0, DATE(), TIME() } )
   ENDIF

   aDirectory[ nFocus ] := aDir

   FOR i = 1 TO LEN( aDirectory[ nFocus ] )

      FOR j = 1 TO LEN( aDirectory[ nFocus ] )

         IF LOWER( aDirectory[ nFocus ] [ i ] [ 1 ] ) <= LOWER( aDirectory[ nFocus ] [ j ] [ 1 ] )

            IF SUBSTR( aDirectory[ nFocus ] [ i ] [ 1 ], 2, 1 ) <> '.' .AND. SUBSTR( aDirectory[ nFocus ] [ j ] [ 1 ], 2, 1 ) <> '.'

               aAux := aDirectory[ nFocus ] [ i ]
               aDirectory[ nFocus ] [ i ] := aDirectory[ nFocus ] [ j ]
               aDirectory[ nFocus ] [ j ] := aAux
               aAux := {}
            ENDIF
         ENDIF

      NEXT
   NEXT

   AEVAL( aDirectory[ nFocus ], { | e | IF( e[ 2 ] = 0 .AND. AT( ".SWP", e[ 1 ] ) = 0, ( e[ 1 ] := "[" + UPPER( e[ 1 ] ) + "]", e[ 2 ] := "<DIR>" ), e[ 1 ] := LOWER( e[ 1 ] ) ) } )

   nSortCol := aSortCol[ nFocus ]
   IF nSortCol = 1
      ASORT( aDirectory[ nFocus ],,, { | a, b | IF( VALTYPE( a[ 2 ] ) # "N" .AND. VALTYPE( b[ 2 ] ) # "N", ;
              SUBSTR( a[ 1 ], 2 ) < SUBSTR( b[ 1 ], 2 ), IF( VALTYPE( a[ 2 ] ) # "N", SUBSTR( a[ 1 ], 2 ) < CHR( 254 ) + b[ 1 ], IF( VALTYPE( b[ 2 ] ) # "N", CHR( 254 ) + a[ 1 ] < SUBSTR( b[ 1 ], 2 ), a[ 1 ] < b[ 1 ] ) ) ) } )
   ELSEIF nSortCol = 2
      ASORT( aDirectory[ nFocus ],,, { | a, b | IF( VALTYPE( a[ 2 ] ) # "N" .AND. VALTYPE( b[ 2 ] ) # "N", ;
              SUBSTR( a[ 1 ], 2 ) < SUBSTR( b[ 1 ], 2 ), IF( VALTYPE( a[ 2 ] ) # "N", SUBSTR( a[ 1 ], 2 ) < CHR( 254 ) + b[ 1 ], IF( VALTYPE( b[ 2 ] ) # "N", CHR( 254 ) + a[ 1 ] < SUBSTR( b[ 1 ], 2 ), a[ 2 ] < b[ 2 ] ) ) ) } )
   ELSEIF nSortCol = 3
      ASORT( aDirectory[ nFocus ],,, { | a, b | IF( VALTYPE( a[ 2 ] ) # "N" .AND. VALTYPE( b[ 2 ] ) # "N", ;
              SUBSTR( a[ 1 ], 2 ) < SUBSTR( b[ 1 ], 2 ), IF( VALTYPE( a[ 2 ] ) # "N", SUBSTR( a[ 1 ], 2 ) < CHR( 254 ) + b[ 1 ], IF( VALTYPE( b[ 2 ] ) # "N", CHR( 254 ) + a[ 1 ] < SUBSTR( b[ 1 ], 2 ), a[ 3 ] < b[ 3 ] ) ) ) } )
   ELSE
      ASORT( aDirectory[ nFocus ],,, { | a, b | IF( VALTYPE( a[ 2 ] ) # "N" .AND. VALTYPE( b[ 2 ] ) # "N", ;
              SUBSTR( a[ 1 ], 2 ) < SUBSTR( b[ 1 ], 2 ), IF( VALTYPE( a[ 2 ] ) # "N", SUBSTR( a[ 1 ], 2 ) < CHR( 254 ) + b[ 1 ], IF( VALTYPE( b[ 2 ] ) # "N", CHR( 254 ) + a[ 1 ] < SUBSTR( b[ 1 ], 2 ), a[ 4 ] < b[ 4 ] ) ) ) } )
   ENDIF

   IF nFocus = 1
      ftpMain.Grid_Local.DisableUpdate
      ftpMain.Grid_Local.DeleteAllItems
      AEVAL( aDirectory[ nFocus ], { | e | ftpMain.Grid_Local.AddItem( { IF( VALTYPE( e[ 2 ] ) = "N", 1, 0 ), e[ 1 ], IF( VALTYPE( e[ 2 ] ) = "N", STR( e[ 2 ] ), e[ 2 ] ), DTOC( e[ 3 ] ), e[ 4 ] } ) } )
      ftpMain.Grid_Local.Value := IF( aBack[ nFocus ], aOldPos[ nFocus ] [ aNivel[ nFocus ] ], 1 )
      ftpMain.Grid_Local.EnableUpdate

   ENDIF

RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Static Function Verify()
*+
*+    Called from ( hbftp.prg )   1 - static procedure ftpform()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION Verify()

LOCAL nPos       := IF( nGridFocus = 1, ftpMain.Grid_Local.Value, ftpMain.Grid_FTP.Value )
LOCAL cDirectory := aSubDirectory[ nGridFocus ] [ 1 ], i, cPath, cFile, cExt, cExe
   IF !EMPTY( nPos )
      IF LEN( aDirectory[ nGridFocus ] ) > 0
         IF ALLTRIM( aDirectory[ nGridFocus ] [ nPos, 1 ] ) <> '[..]' .AND. VALTYPE( aDirectory[ nGridFocus ] [ nPos, 2 ] ) # "N"
            aOldPos[ nGridFocus ] [ aNivel[ nGridFocus ] ] := nPos
            aNivel[ nGridFocus ] ++
            aSubDirectory[ nGridFocus ] [ aNivel[ nGridFocus ] ] := '\' + SUBSTR( aDirectory[ nGridFocus ] [ nPos, 1 ], 2, LEN( aDirectory[ nGridFocus ] [ nPos, 1 ] ) - 1 )

            FOR i = 2 TO aNivel[ nGridFocus ]
               cDirectory += SUBSTR( aSubDirectory[ nGridFocus ] [ i ], 1, LEN( aSubDirectory[ nGridFocus ] [ i ] ) - 1 )
            NEXT
            setcurrentfolder( cdirectory )
            aBack[ nGridFocus ] := .f.
            GetDirectory( cDirectory + '\*.*', nGridFocus )

         ELSEIF ALLTRIM( aDirectory[ nGridFocus ] [ nPos, 1 ] ) = '[..]'
            aSubDirectory[ nGridFocus ] [ aNivel[ nGridFocus ] ] := ""
            IF aNivel[ nGridFocus ] > 1
               aNivel[ nGridFocus ] --
            ENDIF
            FOR i = 2 TO aNivel[ nGridFocus ]
               cDirectory += SUBSTR( aSubDirectory[ nGridFocus ] [ i ], 1, LEN( aSubDirectory[ nGridFocus ] [ i ] ) - 1 )
            NEXT
            setcurrentfolder( cdirectory )
            aBack[ nGridFocus ] := .t.
            GetDirectory( cDirectory + '\*.*', nGridFocus )
         ELSE
            cPath := GetFull()
            cFile := GetName()
            cExt := GetExt()
            IF cExt = 'EXE' .OR. cExt = 'BAT' .OR. cExt = 'COM'
               _Execute( 0,, cFile,, cPath, 5 )
            ELSE
               _Execute( 0, "open", '"' + cFile + '"',, cPath, 5 )

               //     cExe := GetOpenCommand( cExt )
               //     IF !EMPTY( cExe )
               //        cFile := cPath + '\' + cFile
               //        _Execute( 0,, cExe, IF( AT( " ", cFile ) > 0, '"' + cFile + '"', cFile ), cPath, 5 )
               //     ELSE
               //        MsgInfo( 'Error executing program!', "Alert" )
               //     ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF

RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Static Function CurrentDirectory()
*+
*+    Called from ( hbftp.prg )   2 - static procedure ftpform()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION CurrentDirectory( xParam )

LOCAL cPath := GetFull(), cName := GetName()
LOCAL cText := cPath + '\' + cName
   IF xParam # NIL
      nGridFocus := xParam
   ENDIF
   IF nGridFocus = 1
      ftpMain.Label_CurDir.Value := cText
   ENDIF

RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Static Function GetExt()
*+
*+    Called from ( hbftp.prg )   1 - static function verify()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GetExt()

LOCAL cExtension := "", cFile := GetName()
LOCAL nPosition  := RAT( '.', ALLTRIM( cFile ) )

   IF nPosition > 0
      cExtension := SUBSTR( cFile, nPosition + 1, LEN( ALLTRIM( cFile ) ) )
   ENDIF

RETURN UPPER( cExtension )

*+--------------------------------------------------------------------
*+
*+    Static Function GetName()
*+
*+    Called from ( hbftp.prg )   1 - static function verify()
*+                                   1 - static function currentdirectory()
*+                                   1 - static function getext()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GetName()

LOCAL cText := "", nPos

   IF ( nPos := IF( nGridFocus = 1, ftpMain.Grid_Local.Value, ftpMain.Grid_FTP.Value ) ) > 0
      cText := IF( VALTYPE( aDirectory[ nGridFocus ] [ nPos, 2 ] ) # "N", ;
                   SUBSTR( aDirectory[ nGridFocus ] [ nPos, 1 ], 2, LEN( aDirectory[ nGridFocus ] [ nPos, 1 ] ) - 2 ), ;
                   aDirectory[ nGridFocus ] [ nPos, 1 ] )
   ENDIF

RETURN ALLTRIM( cText )

*+--------------------------------------------------------------------
*+
*+    Static Function GetFull()
*+
*+    Called from ( hbftp.prg )   1 - static function verify()
*+                                   1 - static function currentdirectory()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GetFull()

LOCAL cText := aSubDirectory[ nGridFocus ] [ 1 ], i

   FOR i = 2 TO aNivel[ nGridFocus ]
      cText += SUBSTR( aSubDirectory[ nGridFocus ] [ i ], 1, LEN( aSubDirectory[ nGridFocus ] [ i ] ) - 1 )
   NEXT

RETURN cText

/*********************************************************************
STATIC FUNCTION GetOpenCommand( cExt )           // unused

LOCAL oReg, cVar1 := "", cVar2 := "", nPos

   IF !VALTYPE( cExt ) == "C"
      RETURN ""
   ENDIF

   IF !LEFT( cExt, 1 ) == "."
      cExt := "." + cExt
   ENDIF

   oReg := TReg32() :New( HKEY_CLASSES_ROOT, cExt, .f. )
   cVar1 := RTRIM( STRTRAN( oReg:Get( Nil, "" ), CHR( 0 ), " " ) )    // i.e look for (Default) key
   oReg:close()

   IF !EMPTY( cVar1 )
      oReg := TReg32() :New( HKEY_CLASSES_ROOT, cVar1 + "\shell\open\command", .f. )
      cVar2 := RTRIM( STRTRAN( oReg:Get( Nil, "" ), CHR( 0 ), " " ) )                                                                       // i.e look for (Default) key
      oReg:close()

      IF ( nPos := RAT( " %1", cVar2 ) ) > 0                          // look for param placeholder without the quotes (ie notepad)
         cVar2 := SUBSTR( cVar2, 1, nPos )
      ELSEIF ( nPos := RAT( '"%', cVar2 ) ) > 0                       // look for stuff like "%1", "%L", and so forth (ie, with quotes)
         cVar2 := SUBSTR( cVar2, 1, nPos - 1 )
      ELSEIF ( nPos := RAT( '%', cVar2 ) ) > 0                        // look for stuff like "%1", "%L", and so forth (ie, without quotes)
         cVar2 := SUBSTR( cVar2, 1, nPos - 1 )
      ELSEIF ( nPos := RAT( ' /', cVar2 ) ) > 0                       // look for stuff like "/"
         cVar2 := SUBSTR( cVar2, 1, nPos - 1 )
      ENDIF
   ENDIF

RETURN RTRIM( cVar2 )
*********************************************************************/

*+--------------------------------------------------------------------
*+
*+    Static Function _SetGridCaption()
*+
*+    Called from ( hbftp.prg )   2 - static procedure head_click()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION _SetGridCaption( ControlName, ParentForm, Column, Value, nJustify )

LOCAL i, h, t

   i := GetControlIndex( ControlName, ParentForm )

   h := _HMG_aControlhandles[ i ]

   t := GetControlType( ControlName, ParentForm )

   _HMG_aControlCaption[ i ] [ Column ] := Value

   IF t == 'GRID'
      //  SETGRIDCOLUMNHEADER ( h , Column , Value , nJustify )
   ENDIF

RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Static Procedure CreateTable()
*+
*+    Called from ( hbftp.prg )   2 - function hbftp()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE CreateTable( cPath, Upg )

LOCAL aDbf[ 7 ] [ 4 ]
   FIELD NAME, ADDRESS, USER, PASSWORD
   IF upg
      FIELD LOG
      FIELD SPATH
      FIELD Port                                                      // Jimmy
   ENDIF

   aDbf[ 1 ] [ DBS_NAME ] := "Name"
   aDbf[ 1 ] [ DBS_TYPE ] := "C"                                      //"Character"
   aDbf[ 1 ] [ DBS_LEN ] := 60
   aDbf[ 1 ] [ DBS_DEC ] := 0
   //
   aDbf[ 2 ] [ DBS_NAME ] := "Address"
   aDbf[ 2 ] [ DBS_TYPE ] := "C"                                      //"Character"
   aDbf[ 2 ] [ DBS_LEN ] := 100
   aDbf[ 2 ] [ DBS_DEC ] := 0
   //
   aDbf[ 3 ] [ DBS_NAME ] := "User"
   aDbf[ 3 ] [ DBS_TYPE ] := "C"                                      //"Character"
   aDbf[ 3 ] [ DBS_LEN ] := 60
   aDbf[ 3 ] [ DBS_DEC ] := 0
   //
   aDbf[ 4 ] [ DBS_NAME ] := "Password"
   aDbf[ 4 ] [ DBS_TYPE ] := "C"                                      //"Character"
   aDbf[ 4 ] [ DBS_LEN ] := 20
   aDbf[ 4 ] [ DBS_DEC ] := 0

   aDbf[ 5 ] [ DBS_NAME ] := "SPATH"
   aDbf[ 5 ] [ DBS_TYPE ] := "C"                                      //"Character"
   aDbf[ 5 ] [ DBS_LEN ] := 60
   aDbf[ 5 ] [ DBS_DEC ] := 0
   //
   aDbf[ 6 ] [ DBS_NAME ] := "Log"
   aDbf[ 6 ] [ DBS_TYPE ] := "L"                                      //"Logical"
   aDbf[ 6 ] [ DBS_LEN ] := 1
   aDbf[ 6 ] [ DBS_DEC ] := 0
   //

   aDbf[ 7 ] [ DBS_NAME ] := "Port"                                   // Jimmy
   aDbf[ 7 ] [ DBS_TYPE ] := "N"                                      // "Numeric"
   aDbf[ 7 ] [ DBS_LEN ] := 5
   aDbf[ 7 ] [ DBS_DEC ] := 0

   DBCREATE( ( cPath + "SITES" ), aDbf, "DBFCDX" )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function Encrip()
*+
*+    Called from ( hbftp.prg )   1 - static function ftppropsave()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION Encrip( pepe )

LOCAL pala := '', let, a, conv
LOCAL enc  := LEN( pepe )
   FOR a = 1 TO enc
      let := SUBSTR( pepe, a, 1 )
      conv := ASC( let ) + 100 + a
      pala += CHR( conv )
   NEXT
RETURN ( pala )

*+--------------------------------------------------------------------
*+
*+    Static Function Desencri()
*+
*+    Called from ( hbftp.prg )   1 - static procedure editform()
*+                                   1 - static function ftpconnect()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION Desencri( pepe )

LOCAL pala := '', let, a, conv
LOCAL enc  := LEN( ALLTRIM( pepe ) )
   FOR a = 1 TO enc
      let := SUBSTR( pepe, a, 1 )
      conv := ASC( let ) - 100 - a
      pala += CHR( conv )
   NEXT
   RETURN ( pala )
   /*
*/

#define EM_SETPASSWORDCHAR      0x00CC

*+--------------------------------------------------------------------
*+
*+    Static Procedure ShowPassword()
*+
*+    Called from ( hbftp.prg )   1 - static procedure editform()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ShowPassword()

LOCAL cPass     := editsitemanager.Text_PW.VALUE
LOCAL lShowPass := !editsitemanager.Check_MaskPW.VALUE

   lShowPass := .T.
   IF lShowPass
      SendMessage( editsitemanager.Text_PW.HANDLE, EM_SETPASSWORDCHAR, 0, 0 )
      //      SetProperty("editsitemanager","Text_PW","PASSWORD", .F. )
      //      editsitemanager.Text_PW.REFRESH
   ELSE
      //      SetProperty("editsitemanager","Text_PW","PASSWORD", .T. )
      //      editsitemanager.Text_PW.REFRESH

      //      editsitemanager.Text_PW.RELEASE
      //      DoEvents()
      //      DEFINE TEXTBOX Text_PW
      //        PARENT editsitemanager
      //        ROW    150
      //        COL    110
      //        WIDTH  180
      //        HEIGHT 24
      //        VALUE     cPass
      //        PASSWORD  .F.
      //      END TEXTBOX
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function AtInside()
*+
*+    Called from ( hbftp.prg )   1 - static function ftpfillgrid()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION AtInside( cMarker, cText )                            // Jimmy

LOCAL nPos := 1
LOCAL nIst := 0
LOCAL aRet := {}
LOCAL i, iMax

   DO WHILE .T.
      nPos := AT( cMarker, cText )
      IF nPos > 0
         nIst ++
         AADD( aRet, LTRIM( SUBSTR( cText, 1, ( nPos - 1 ) ) ) )
         cText := SUBSTR( cText, ( nPos + 1 ), LEN( cText ) - nPos )
      ELSE
         //          IF nIst > 0
         AADD( aRet, LTRIM( cText ) )
         //          ENDIF
         EXIT
      ENDIF
   ENDDO

   //    iMax := LEN( aRet )
   //    FOR i := iMax TO 1 STEP - 1
   //       IF EMPTY( aRet[ i ] )
   //          AREMOVE( aRet, i )
   //       ENDIF
   //    NEXT

RETURN aRet

*+--------------------------------------------------------------------
*+
*+    Static Function CalcPos()
*+
*+    Called from ( hbftp.prg )   1 - static function doprogress()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION CalcPos( nValue, iMax )                               // Jimmy

LOCAL nRet   := 0
LOCAL nEvery
LOCAL xScale

   IF iMax < 100
      nEvery := 100 / iMax
      nRet := nValue * nEvery
   ELSE
      nEvery := INT( iMax / 100 )
      xScale := iMax * nEvery                                         // Scale to 100%
      nRet := iMax / xScale * nValue
   ENDIF

RETURN ROUND( nRet, 0 )

*+--------------------------------------------------------------------
*+
*+    Static Function onDummy()
*+
*+    Called from ( hbftp.prg )   1 - static function doprogress()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION onDummy()                                             // Jimmy

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
*+    Static Function VAR2CHAR()
*+
*+    Called from ( hbftp.prg )   2 - static function ondummy()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION VAR2CHAR( cIn )                                       // Jimmy

LOCAL cOut := hb_valToExp( cIn )
RETURN STRTRAN( cOut, '"', '' )

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoReSizeMain()
*+
*+    Called from ( hbftp.prg )   2 - static procedure ftpform()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoReSizeMain()                                       // Jimmy

LOCAL mainRow    := GetProperty( "ftpMain", 'Row' )
LOCAL mainCol    := GetProperty( "ftpMain", 'Col' )
LOCAL mainWidth  := GetProperty( "ftpMain", 'Width' )
LOCAL mainHeight := GetProperty( "ftpMain", 'Height' )
LOCAL nBorder    := GETBORDERWIDTH()
LOCAL nTitlebar  := GETTITLEHEIGHT()

   SetProperty( "ftpMain", "Grid_Local", "Width", ( mainWidth / 2 ) - 30 )
   SetProperty( "ftpMain", "Grid_Local", "Height", mainHeight - 170 )
   SetProperty( "ftpMain", "Grid_Local", "Col", nBorder )
   SetProperty( "ftpMain", "Grid_Local", "Row", 100 )

   SetProperty( "ftpMain", "Grid_FTP", "Width", ( mainWidth / 2 ) - 30 )
   SetProperty( "ftpMain", "Grid_FTP", "Height", mainHeight - 170 )
   SetProperty( "ftpMain", "Grid_FTP", "Col", ( mainWidth / 2 ) - 10 + nBorder )
   SetProperty( "ftpMain", "Grid_FTP", "Row", 100 )

   SetProperty( "ftpMain", "Label_LocalPC", "Width", ( mainWidth / 2 ) - 30 )
   SetProperty( "ftpMain", "Label_LocalPC", "Col", nBorder )
   SetProperty( "ftpMain", "Label_LocalPC", "Row", 040 )

   SetProperty( "ftpMain", "Label_FTPServer", "Width", ( mainWidth / 2 ) - 30 )
   SetProperty( "ftpMain", "Label_FTPServer", "Col", ( mainWidth / 2 ) - 10 + nBorder )
   SetProperty( "ftpMain", "Label_FTPServer", "Row", 040 )

   SetProperty( "ftpMain", "Label_CurDir", "Width", ( mainWidth / 2 ) - 30 )
   SetProperty( "ftpMain", "Label_CurDir", "Col", nBorder )
   SetProperty( "ftpMain", "Label_CurDir", "Row", mainHeight - nTitlebar - 40 )

   SetProperty( "ftpMain", "Label_SrvPath", "Width", ( mainWidth / 2 ) - 30 )
   SetProperty( "ftpMain", "Label_SrvPath", "Col", ( mainWidth / 2 ) - 10 + nBorder )
   SetProperty( "ftpMain", "Label_SrvPath", "Row", mainHeight - nTitlebar - 40 )

   SetProperty( "ftpMain", "Button_Upload", "Col", ( mainWidth / 2 ) - 30 + nBorder )
   SetProperty( "ftpMain", "Button_Upload", "Row", ( ( mainHeight - nTitlebar ) / 2 ) - 50 )

   SetProperty( "ftpMain", "Button_Download", "Col", ( mainWidth / 2 ) - 30 + nBorder )
   SetProperty( "ftpMain", "Button_Download", "Row", ( ( mainHeight - nTitlebar ) / 2 ) )

   SetProperty( "ftpMain", "ProgressBar_1", "Width", mainWidth - 20 )
   SetProperty( "ftpMain", "ProgressBar_1", "Row", ( mainHeight - nTitlebar - 22 ) )

   // *********
   //    SetProperty("ftpMain","Combo_Sites"
   //
   //    SetProperty("ftpMain","Button_Connect"
   //    SetProperty("ftpMain","Button_Disconnect"
   //
   //    SetProperty("ftpMain","Button_MD_Local"
   //    SetProperty("ftpMain","Button_REN_Local"
   //    SetProperty("ftpMain","Button_DEL_Local"
   //
   //    SetProperty("ftpMain","Button_MD_Remote"
   //    SetProperty("ftpMain","Button_REN_Remote"
   //    SetProperty("ftpMain","Button_DEL_Remote"
   //    SetProperty("ftpMain","Button_Sites"
   // *********

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure FillLocalCombo()
*+
*+    Called from ( hbftp.prg )   1 - function hbftp()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE FillLocalCombo( lDelete )                            // Jimmy

LOCAL cDrive, cVolume, nDrive, nType, ico, i, aDrives

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
*+    Static Procedure LoadComboImage()
*+
*+    Called from ( hbftp.prg )   1 - static procedure ftpform()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE LoadComboImage( lRefresh )                           // Jimmy

LOCAL nStart, i, ii, iiMax, xVal, nDrive := 1

   DEFAULT lRefresh TO .F.

   IF lRefresh = .T.
      Domethod( "ftpMain", "Combo_Drive", "hide" )
      Domethod( "ftpMain", "Combo_Drive", "DeleteAllItems" )

      iiMax := LEN( caItems )
      FOR ii := 1 TO iiMax
         xVal := caItems[ ii ]
         ftpMain.Combo_Drive.AddItem( xVal )
      NEXT
   ENDIF

   //  nDrive := ASCAN( aDrives, { | e | e[ 2 ] = SUBSTR( SP_LWTextLeft(), 1, 1 ) } )
   SetProperty( "ftpMain", "Combo_Drive", "VALUE", nDrive )
   Domethod( "ftpMain", "Combo_Drive", "show" )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure ChangeLocalDrive()
*+
*+    Called from ( hbftp.prg )   1 - static procedure ftpform()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ChangeLocalDrive()                                   // Jimmy

LOCAL nVALUE, aItem, aNewDir
LOCAL nPosi, cDrive
LOCAL cChoise := ""
LOCAL hGrid

   nVALUE := GetProperty( "ftpMain", "Combo_Drive", "VALUE" )
   aItem := GetProperty( "ftpMain", "Combo_Drive", "ITEM", nVALUE )
   ALTD()
   IF !EMPTY( aItem ) .AND. !EMPTY( aItem[ 2 ] )
      cChoise := aItem[ 2 ]
      cChoise := SUBSTR( cChoise, 1, 1 )
      IF !EMPTY( cChoise )
         cDrive := cChoise + ":"
         aSubDirectory[ 1 ] [ 1 ] := cDrive
         initgrid()
         SetProperty( "ftpMain", "Label_CurDir", "VALUE", cDrive + "\" )
      ENDIF
   ENDIF

   DO EVENTS

RETURN

//
//
//

*+ EOF: HBFTP.PRG
