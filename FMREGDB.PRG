*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\FMREGDB.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Procedure RegDBForm()
*+               Static Procedure LoadDetail()
*+               Static Procedure OnSave()
*+               Static Procedure OnAppend()
*+               Static Procedure GoToURL()
*+               Static Function SetStartNode()
*+               Static Function MYSHELLOPENFILE()
*+               Static Function Is64Bit()
*+               Static Procedure Cre_REG()
*+               Static Function RegArray()
*+
*+       Tables: USE (cAppFolder+"HBREG.DBF") VIA "DBFCDX" NEW EXCLUSIV
*+               USE (datei) ALIAS "HBREG" VIA "DBFCDX" NEW EXCLUSIV
*+
*+    Reformatted by Click! 2.05.30 on Aug-28-2020 at  1:52 am
*+
*+--------------------------------------------------------------------

#include "HMG.CH"
#include "common.CH"
#include "dll.CH"

#include "SHFILE.CH"

REQUEST DBFCDX
REQUEST DBFNTX

STATIC xVersion := " v0.01"

// **********************
//
//  v0.01  15.02.2020  1st Release
//
// **********************

STATIC lRunning := .F.

MEMVAR _HMG_SYSDATA

*+--------------------------------------------------------------------
*+
*+    Procedure RegDBForm()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE RegDBForm()

LOCAL cAppFolder := AppFolder()

   IF lRunning = .T.
      DoMethod( "RegDbForm", "setfocus" )
      RETURN
   ENDIF

   lRunning := .T.

   // SET EPOCH TO YEAR( DATE() ) - 50
   // SET CENTURY ON
   SET BROWSESYNC ON

   IF !FILE( cAppFolder + "HBREG.DBF" )
      Cre_REG( cAppFolder + "HBREG.DBF" )
   ENDIF

   USE (cAppFolder+"HBREG.DBF") VIA "DBFCDX" NEW EXCLUSIV

   DEFINE WINDOW RegDbForm ;
              AT 139, 288 ;
              WIDTH 800 ;
              HEIGHT 600 ;
              TITLE "Registry Database" + xVersion ;
              ICON "ICOREG" ;
              NOMAXIMIZE ;
              NOMINIMIZE ;
              NOSIZE ;
              BACKCOLOR SP_nColor1()                                  //{8,8,8} ;

      DEFINE BROWSE Browse_Reg
         ROW 10
         COL 10
         WIDTH 760
         HEIGHT 300 - 10
         VALUE 0
         WIDTHS { 560, 170 }
         HEADERS { 'HKLM', 'KEY' }
         WORKAREA HBREG
         FIELDS { 'HBREG->HKLM', 'HBREG->KEY' }
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         ONCHANGE LoadDetail()
         ONDBLCLICK SetStartNode()
         ALLOWEDIT .F.
         ALLOWAPPEND .F.
         ALLOWDELETE .F.
         LOCK .F.
         VSCROLLBAR .T.
         BACKCOLOR SP_nColor1()                                       //{8,8,8}
         FONTCOLOR SP_nColor2()                                       //{128,255,255}
      END BROWSE

      DEFINE BUTTON Button_New
         ROW 316
         COL 10
         WIDTH 100
         HEIGHT 50
         ACTION OnAppend()
         CAPTION "&New"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .T.
         VISIBLE .T.
      END BUTTON

      DEFINE BUTTON Button_Save
         ROW 316
         COL 120                                                      // 670
         WIDTH 100
         HEIGHT 50
         ACTION OnSave()
         CAPTION "&Save"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .T.
         VISIBLE .T.
      END BUTTON

      // DEFINE BUTTON Button_Edit
      //     ROW    316
      //     COL    120     // 557
      //     WIDTH  100
      //     HEIGHT 50
      //     CAPTION "&Edit"
      //     FONTNAME SP_cFontName()
      //     FONTSIZE SP_nFontSize()
      //     TABSTOP .T.
      //     VISIBLE .T.
      // END BUTTON

      DEFINE BUTTON Button_Exit
         ROW 316
         COL 670                                                      // 557
         WIDTH 103
         HEIGHT 50
         ACTION RegDbForm.Release
         CAPTION "&Exit"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .T.
         VISIBLE .T.
      END BUTTON

      DEFINE TEXTBOX Text_HKLM
         ROW 380
         COL 70
         WIDTH 690
         HEIGHT 30
         FIELD HBREG->HKLM
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .T.
         VISIBLE .T.
         READONLY .F.
         CASECONVERT NONE
         BACKCOLOR SP_nColor5()                                       //{192,192,192}
         FONTCOLOR SP_nColor6()                                       //{0,0,1}
         VALUE ""
      END TEXTBOX

      DEFINE TEXTBOX Text_KEY
         ROW 412
         COL 70
         WIDTH 360
         HEIGHT 30
         FIELD HBREG->KEY
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .T.
         VISIBLE .T.
         READONLY .F.
         CASECONVERT NONE
         BACKCOLOR SP_nColor5()                                       //{192,192,192}
         FONTCOLOR SP_nColor6()                                       //{0,0,1}
         VALUE ""
      END TEXTBOX

      DEFINE TEXTBOX Text_URL
         ROW 444
         COL 70
         WIDTH 690
         HEIGHT 30
         FIELD HBREG->WHEREURL
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .T.
         VISIBLE .T.
         READONLY .F.
         CASECONVERT NONE
         BACKCOLOR SP_nColor5()                                       //{192,192,192}
         FONTCOLOR SP_nColor6()                                       //{0,0,1}
         VALUE ""
      END TEXTBOX

      DEFINE EDITBOX Edit_Memo
         ROW 476
         COL 70
         WIDTH 690
         HEIGHT 70
         FIELD HBREG->COMMENT
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .T.
         VISIBLE .T.
         READONLY .F.
         HSCROLLBAR .T.
         VSCROLLBAR .T.
         BACKCOLOR SP_nColor5()                                       //{192,192,192}
         FONTCOLOR SP_nColor6()                                       //{0,0,1}
      END EDITBOX

      DEFINE LABEL Label_1
         ROW 383
         COL 10
         WIDTH 50
         HEIGHT 24
         VALUE "HKLM"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         VISIBLE .T.
         BACKCOLOR SP_nColor1()                                       //{8,8,8}
         FONTCOLOR SP_nColor2()                                       //{0,255,255}
         RIGHTALIGN .T.
      END LABEL

      DEFINE LABEL Label_2
         ROW 415
         COL 10
         WIDTH 50
         HEIGHT 24
         VALUE "Key"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         VISIBLE .T.
         BACKCOLOR SP_nColor1()                                       //{8,8,8}
         FONTCOLOR SP_nColor2()                                       //{0,255,255}
         RIGHTALIGN .T.
      END LABEL

      DEFINE BUTTON Button_GoURL
         ROW 444
         COL 10
         WIDTH 50
         HEIGHT 28
         ACTION GoToURL()
         CAPTION "GO Url"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .T.
         VISIBLE .T.
      END BUTTON

      DEFINE LABEL Label_3
         ROW 477
         COL 10
         WIDTH 50
         HEIGHT 24
         VALUE "Note"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         VISIBLE .T.
         BACKCOLOR SP_nColor1()                                       //{8,8,8}
         FONTCOLOR SP_nColor2()                                       //{0,255,255}
         RIGHTALIGN .T.
      END LABEL

   END WINDOW

   ON KEY ESCAPE OF RegDbForm ACTION RegDbForm.Release

   RegDbForm.Browse_Reg.setfocus
   CENTER WINDOW RegDbForm
   ACTIVATE WINDOW RegDbForm

   CLOSE HBREG

   lRunning := .F.

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure LoadDetail()
*+
*+    Called from ( fmregdb.prg )   1 - procedure regdbform()
*+                                   1 - static procedure onappend()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE LoadDetail()

   RegDbForm.Text_HKLM.refresh
   RegDbForm.Text_KEY.refresh
   RegDbForm.Text_URL.refresh
   RegDbForm.Edit_Memo.refresh
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure OnSave()
*+
*+    Called from ( fmregdb.prg )   1 - procedure regdbform()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE OnSave()

   IF RLOCK()
      REPLACE HBREG->HKLM WITH RegDbForm.Text_HKLM.Value
      REPLACE HBREG->KEY WITH RegDbForm.Text_KEY.Value
      REPLACE HBREG->WHEREURL WITH RegDbForm.Text_URL.Value
      REPLACE HBREG->COMMENT WITH RegDbForm.Edit_Memo.Value
      UNLOCK
   ENDIF
   RegDbForm.Browse_Reg.Refresh
   DO EVENTS
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure OnAppend()
*+
*+    Called from ( fmregdb.prg )   1 - procedure regdbform()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE OnAppend()

LOCAL hGrid := GetControlHandle( "Browse_Reg", "RegDbForm" )

   APPEND BLANK
   LoadDetail()

   ListView_EnsureVisible( hGrid, 13 )
   RegDbForm.Browse_Reg.Refresh
   RegDbForm.Text_HKLM.setfocus

   DO EVENTS
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure GoToURL()
*+
*+    Called from ( fmregdb.prg )   1 - procedure regdbform()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE GoToURL()

LOCAL cURL := TRIM( RegDbForm.Text_URL.Value )
   IF !EMPTY( cURL )
      MYSHELLOPENFILE( cURL, "" )
   ENDIF
   DO EVENTS
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function SetStartNode()
*+
*+    Called from ( fmregdb.prg )   1 - procedure regdbform()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION SetStartNode()

LOCAL nKey      := HKEY_CURRENT_USER
LOCAL cPath     := "Software\Microsoft\Windows\CurrentVersion\Applets\Regedit"
LOCAL cKEY      := "LastKey"
LOCAL oReg
LOCAL cRet      := ""
LOCAL bOldError
LOCAL oError
LOCAL xValue    := ""
LOCAL cTitle    := "Registrierungs-Editor"
LOCAL hWndDlg   := HMG_CallDLL( "User32.dll", DLL_OSAPI, "FindWindow", 0, cTitle )
LOCAL cWin      := GETENV( "windir" )

   IF !( hWndDlg == 0 )
      HMG_CallDLL( "User32.dll", DLL_OSAPI, "SetForegroundWindow", hWndDlg )
      HMG_CallDLL( "User32.dll", DLL_OSAPI, "BringWindowToTop", hWndDlg )
      HMG_CallDLL( "User32.dll", DLL_OSAPI, "ShowWindow", hWndDlg, 1 )
      HMG_CallDLL( "User32.dll", DLL_OSAPI, "UpdateWindow", hWndDlg )
      // now close it
      HMG_CallDLL( "User32.DLL", DLL_OSAPI, "SendMessage", hWndDlg, WM_SYSCOMMAND, SC_CLOSE, 0 )
      // SendMessage( hWndDlg, WM_SYSCOMMAND, SC_CLOSE, 0 )
   ENDIF

   IF Is64Bit()
      HMG_CallDLL( "Kernel32.DLL", DLL_OSAPI, "Wow64EnableWow64FsRedirection", FALSE )
   ENDIF

   ALTD()

   IF ALIAS() = "HBREG"
      //       bOldError := ERRORBLOCK( { | e | BREAK( e ) } )
      //       BEGIN SEQUENCE

      xValue := TRIM( HBREG->HKLM )
      RegistryWrite( "HKEY_CURRENT_USER\" + cPath + "\" + cKEY, xValue )
      MYSHELLOPENFILE( cWin + "\", "REGEDIT.EXE" )

      //          oReg := TReg32() :NEW( nKey, cPath )
      //          IF !EMPTY( oReg )
      //             xValue := TRIM( HBREG->HKLM )
      //             cRet := oReg:Set( cKEY, xValue )
      //
      //             MYSHELLOPENFILE( cWin + "\", "REGEDIT.EXE" )
      //          ENDIF

      //       END SEQUENCE
      //       ERRORBLOCK( bOldError )
   ENDIF

   IF Is64Bit()
      HMG_CallDLL( "Kernel32.DLL", DLL_OSAPI, "Wow64EnableWow64FsRedirection", TRUE )
   ENDIF

   DO EVENTS
RETURN cRet

*+--------------------------------------------------------------------
*+
*+    Static Function MYSHELLOPENFILE()
*+
*+    Called from ( fmregdb.prg )   1 - static procedure gotourl()
*+                                   1 - static function setstartnode()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION MYSHELLOPENFILE( cPath, cFILE, cPara )

LOCAL lSuccess
LOCAL Retvar   := .F.

   DEFAULT cPath TO ""
   DEFAULT cFILE TO ""
   DEFAULT cPara TO ""                                                // CURDIR()

   // IF Is64Bit()
   //    HMG_CallDLL( "Kernel32.DLL", DLL_OSAPI, "Wow64EnableWow64FsRedirection", FALSE )
   // ENDIF

   lSuccess := ShellExecute( 0, ;
                             "open", ;
                             cPath + cFile, ;
                             cPara, ;
                             0, ;                                     // CURDIR()
                             SW_NORMAL )

   DO CASE

      CASE lSuccess > 32                                              // Aufruf erfolgreich
         Retvar := .T.

      CASE lSuccess = SE_ERR_NOASSOC                                  // Keine verknÅpfte Anwendung

         // Falls ShowOpenWithDialog = True, wird der Dialog
         // "ôffnen mit" fÅr diese Datei angezeigt:
         // Shell "RunDLL32 shell32.dll,OpenAs_RunDLL " & Filename

         HMG_CallDLL( "SHELL32.DLL", DLL_OSAPI, "OpenAs_RunDLL", ;
                      0, ;
                      0, ;
                      cPath + cFile, ;
                      0, ;
                      CURDIR(), ;
                      SW_NORMAL )                                     // SW_MAXIMIZE

         //  Die Auswahlmîglichkeit wird als Erfolg gewertet:
         Retvar := .F.
      OTHERWISE
         // ShellExecute war erfolglos.
         // Boolean-Standardwert False zurÅckgeben
         DO CASE
            CASE lSuccess = SE_ERR_FNF
               MsgInfo( "File not found.", cPath + cFILE )
            CASE lSuccess = SE_ERR_PNF
               MsgInfo( "Path not found.", cPath + cFILE )
            CASE lSuccess = SE_ERR_ACCESSDENIED
               MsgInfo( "Access denied !", cPath + cFILE )
            CASE lSuccess = SE_ERR_OOM
               MsgInfo( "Out of memory !", cPath + cFILE )
            CASE lSuccess = SE_ERR_SHARE
               MsgInfo( "Cannot share an open file.", cPath + cFILE )
            CASE lSuccess = SE_ERR_ASSOCINCOMPLETE
               MsgInfo( "File association information not complete.", cPath + cFILE )
            CASE lSuccess = SE_ERR_DDETIMEOUT
               MsgInfo( "DDE operation timed out.", cPath + cFILE )
            CASE lSuccess = SE_ERR_DDEFAIL
               MsgInfo( "DDE operation failed.", cPath + cFILE )
            CASE lSuccess = SE_ERR_DDEBUSY
               MsgInfo( "DDE operation is busy.", cPath + cFILE )
         ENDCASE
         Retvar := .F.
   ENDCASE

   // IF Is64Bit()
   //    HMG_CallDLL( "Kernel32.DLL", DLL_OSAPI, "Wow64EnableWow64FsRedirection", TRUE )
   // ENDIF

   DO EVENTS
RETURN Retvar

*+--------------------------------------------------------------------
*+
*+    Static Function Is64Bit()
*+
*+    Called from ( fmregdb.prg )   2 - static function setstartnode()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION Is64Bit()

RETURN IF( FILE( "C:\WINDOWS\SysWOW64\Format.COM" ), .T., .F. )

*+--------------------------------------------------------------------
*+
*+    Static Procedure Cre_REG()
*+
*+    Called from ( fmregdb.prg )   1 - procedure regdbform()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Cre_REG( datei, aArray )

LOCAL field_list := {}
LOCAL aText      := {}
LOCAL aTemp      := {}
LOCAL i, iMax

   DEFAULT aArray TO RegArray()

   IF !FILE( datei )
      AADD( field_list, { "HKLM", "C", 128, 0 } )
      AADD( field_list, { "KEY", "C", 64, 0 } )
      AADD( field_list, { "WHEREURL", "C", 128, 0 } )
      AADD( field_list, { "COMMENT", "C", 250, 0 } )

      DBCREATE( datei, field_list, "DBFCDX" )

      SELECT 1
      USE (datei) ALIAS "HBREG" VIA "DBFCDX" NEW EXCLUSIV
      iMax := LEN( aArray )
      FOR i := 1 TO iMax
         APPEND BLANK
         REPLACE HBREG->HKLM WITH aArray[ i ] [ 1 ]
         REPLACE HBREG->KEY WITH aArray[ i ] [ 2 ]
         REPLACE HBREG->WHEREURL WITH aArray[ i ] [ 3 ]
         REPLACE HBREG->COMMENT WITH aArray[ i ] [ 4 ]
      NEXT
      CLOSE
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function RegArray()
*+
*+    Called from ( fmregdb.prg )   1 - static procedure cre_reg()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION RegArray()

LOCAL aArray := {}

   AADD( aArray, { "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers", ;
                   "0", ;
                   "", ;
                   "Windows Time Server" + CRLF + "Germany : ptbtime1.ptb.de" } )

   AADD( aArray, { "HKEY_CURRENT_USER\Environment", ;
                   "LIB", ;
                   "", ;
                   "USER Environment" } )

   AADD( aArray, { "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Environment", ;
                   "OS", ;
                   "", ;
                   "SYSTEM Environment" } )

   AADD( aArray, { "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont", ;
                   "0", ;
                   "", ;
                   "Consolas TTF" } )

   AADD( aArray, { "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", ;
                   "ProductId", ;
                   "", ;
                   "OEM Seriennummer" } )

   AADD( aArray, { "HKEY_CURRENT_USER\Control Panel\Desktop", ;
                   "Wallpaper", ;
                   "", ;
                   "Wallpaper" } )

   AADD( aArray, { "HKEY_CURRENT_USER\Software\Microsoft\Notepad", ;
                   "StatusBar", ;
                   "", ;
                   "enable = 1" } )

   AADD( aArray, { "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", ;
                   "ShowSecondsInSystemClock", ;
                   "", ;
                   "Windows 10 : Uhrzeit im Try mit Sekunden" } )

   AADD( aArray, { "HKEY_CURRENT_USER\Control Panel\Desktop", ;
                   "JPEGImportQuality", ;
                   "", ;
                   "Windows 10 : Wallpaper QualitÑt max 100" } )

   AADD( aArray, { "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Explorer", ;
                   "ShowDriveLettersFirst", ;
                   "http://support.microsoft.com/kb/330193", ;
                   "Laufwerksbuchstaben zuerst anzeigen; setzen Sie den Wert auf Ô4Ô.;Der Wert Ô2Ô unterdrÅckt die Anzeige der Laufwerksbuchstaben vollstÑndig." } )

   AADD( aArray, { "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics", ;
                   "IconSpacing", ;
                   "", ;
                   "Horizontal Spacing Icons Desktop" } )

   AADD( aArray, { "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics", ;
                   "IconVerticalSpacing", ;
                   "", ;
                   "Vertikal Spacing Icons Desktop" } )

   AADD( aArray, { "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Lanmanworkstation\Parameters", ;
                   "DirectoryCacheLifetime", ;
                   "http://technet.microsoft.com/en-us/library/ff686200%28WS.10%29.aspx", ;
                   "for xBase set to 0 (zero)" } )

   AADD( aArray, { "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Lanmanworkstation\Parameters", ;
                   "FileNotFoundCacheLifetime", ;
                   "http://technet.microsoft.com/en-us/library/ff686200%28WS.10%29.aspx", ;
                   "for xBase set to 0 (zero)" } )

   AADD( aArray, { "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Lanmanworkstation\Parameters", ;
                   "FileInfoCacheLifetime", ;
                   "http://technet.microsoft.com/en-us/library/ff686200%28WS.10%29.aspx", ;
                   "for xBase set to 0 (zero)" } )

RETURN aArray

//
//
//

*+ EOF: FMREGDB.PRG
