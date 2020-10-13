*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\HMGDLL.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Function SHELLOPENFILE()
*+               Function Findwindow()
*+               Function GETDRIVETYPE()
*+               Function GETVOLUMEINFORMATION()
*+               Function DRAGACCEPTFILES()
*+               Function GetShortFileName()
*+               Procedure ShowProperty()
*+               Procedure RunWinMsc()
*+               Function SETXPARENT()
*+               Procedure DoFindWin()
*+               Procedure ShowOSK()
*+               Static Function FindAndCloseProcress()
*+
*+    Reformatted by Click! 2.05.35 on Oct-13-2020 at  4:43 am
*+
*+--------------------------------------------------------------------

#include "HMG.CH"
#include "dll.ch"
#include "common.ch"

#include "SHFILE.CH"

*+--------------------------------------------------------------------
*+
*+    Function SHELLOPENFILE()
*+
*+    Called from ( fm_func.prg )   3 - procedure runbyextension()
*+                ( hbeject.prg )   1 - function ejectmedia()
*+                ( hmgdll.prg )   5 - procedure runwinmsc()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SHELLOPENFILE( cPath, cFILE, cPara, cHome )

LOCAL lSuccess
LOCAL Retvar   := .F.

   DEFAULT cPath TO ""
   DEFAULT cFILE TO ""
   DEFAULT cPara TO ""
   DEFAULT cHome TO CURDIR()

   //  #define SW_HIDE             0
   //  #define SW_NORMAL           1
   //  #define SW_SHOWMINIMIZED    2
   //  #define SW_SHOWMAXIMIZED    3
   //  #define SW_MAXIMIZE         3
   //  #define SW_SHOWNOACTIVATE   4
   //  #define SW_SHOW             5
   //  #define SW_MINIMIZE         6
   //  #define SW_SHOWMINNOACTIVE  7
   //  #define SW_SHOWNA           8
   //  #define SW_RESTORE          9
   //  #define SW_SHOWDEFAULT      10
   //#define SE_ERR_NOASSOC      31

   IF Is64Bit()
      HMG_CallDLL( "Kernel32.dll", DLL_OSAPI, "Wow64EnableWow64FsRedirection", FALSE )                                                      // disable bevor API Call
   ENDIF

   lSuccess := ShellExecute( 0, ;
                             "open", ;
                             cPath + cFILE, ;
                             cPara, ;
                             cHome, ;
                             SW_NORMAL )

   DO CASE

      CASE lSuccess > 32                                              // Aufruf erfolgreich
         Retvar := .T.

      CASE lSuccess = SE_ERR_NOASSOC                                  // Keine verknpfte Anwendung

         // Falls ShowOpenWithDialog = True, wird der Dialog
         // "™ffnen mit" fr diese Datei angezeigt:
         // Shell "RunDLL32 shell32.dll,OpenAs_RunDLL " & Filename

         HMG_CallDLL( "shell32", DLL_OSAPI, "OpenAs_RunDLL", ;
                      0, ;
                      0, ;
                      cPath + cFile, ;
                      cPara, ;
                      0, ;
                      SW_HIDE )                                       // SW_NORMAL

         //  Die Auswahlm”glichkeit wird als Erfolg gewertet:
         Retvar := .T.

      OTHERWISE
         // ShellExecute war erfolglos.
         // Boolean-Standardwert False zurckgeben
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

   IF Is64Bit()
      HMG_CallDLL( "Kernel32.dll", DLL_OSAPI, "Wow64EnableWow64FsRedirection", TRUE )                                                       // enable again
   ENDIF

   DO EVENTS

RETURN Retvar

*+--------------------------------------------------------------------
*+
*+    Function Findwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Findwindow( cTitle )

LOCAL hWnd

   IF hb_cdpSelect() = "UTF8"
      hWnd := HMG_Calldll( "User32.dll", DLL_OSAPI, "FindWindowW", 0, cTitle )
   ELSE
      hWnd := HMG_Calldll( "User32.dll", DLL_OSAPI, "FindWindowA", 0, cTitle )
   ENDIF
RETURN hWnd

*+--------------------------------------------------------------------
*+
*+    Function GETDRIVETYPE()
*+
*+    Called from ( fm_func.prg )   1 - function getdrives()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GETDRIVETYPE( cDrive )

LOCAL nDriveType, cRoot := cDrive + ":\" + CHR( 0 )
   IF hb_cdpSelect() = "UTF8"
      nDriveType := HMG_Calldll( "Kernel32.DLL", DLL_OSAPI, "GetDriveTypeW", @cRoot )
   ELSE
      nDriveType := HMG_Calldll( "Kernel32.DLL", DLL_OSAPI, "GetDriveTypeA", @cRoot )
   ENDIF
RETURN nDriveType

*+--------------------------------------------------------------------
*+
*+    Function GETVOLUMEINFORMATION()
*+
*+    Called from ( fm_func.prg )   1 - function getdrives()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GETVOLUMEINFORMATION( WHATDRV )

LOCAL cDrive
LOCAL cVolName := SPACE( 256 )
LOCAL nVolLen  := 256
LOCAL nVolSer  := 0
LOCAL nCompLen := 0
LOCAL nFSFlags := 0
LOCAL cFSName  := SPACE( 32 )
LOCAL nFSLen   := 32

   IF PCOUNT() = 0
      cDrive := "C:\"
   ELSE
      cDrive := WHATDRV
   ENDIF
   IF hb_cdpSelect() = "UTF8"
      HMG_Calldll( "Kernel32.DLL", DLL_OSAPI, "GetVolumeInformationW", @cDrive, @cVolname, nVolLen, @nVolSer, @nCompLen, @nFSFlags, @cFSName, nFSLen )
   ELSE
      HMG_Calldll( "Kernel32.DLL", DLL_OSAPI, "GetVolumeInformationA", @cDrive, @cVolname, nVolLen, @nVolSer, @nCompLen, @nFSFlags, @cFSName, nFSLen )
   ENDIF
   cVolName := TRIM( cVolName )
   cVolName := STRTRAN( cVolName, CHR( 0 ), "" )

   // ? cVolName
   // ? nVolSer
   // ? nCompLen
   // ? nFSFlags
   // ? cFSName

RETURN ( cVolName )

*+--------------------------------------------------------------------
*+
*+    Function DRAGACCEPTFILES()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
FUNCTION DRAGACCEPTFILES( HWND, lOnOff )

   HMG_Calldll( "Shell32.dll", DLL_OSAPI, "DragAcceptFiles", HWND, lOnOff )
RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Function GetShortFileName()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetShortFileName( cLongName )

LOCAL cShortName := SPACE( 255 )
LOCAL nNameLen   := 1
   IF EMPTY( cLongName )
      RETURN ( '' )
   ELSE
      IF hb_cdpSelect() = "UTF8"
         nNameLen := HMG_CallDLL( "Kernel32.DLL", DLL_OSAPI, "GetShortPathNameW", cLongName, @cShortName, LEN( cShortName ) )
      ELSE
         nNameLen := HMG_CallDLL( "Kernel32.DLL", DLL_OSAPI, "GetShortPathNameA", cLongName, @cShortName, LEN( cShortName ) )
      ENDIF
   ENDIF
RETURN ( LEFT( cShortName, nNameLen ) )

*+--------------------------------------------------------------------
*+
*+    Procedure ShowProperty()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+                                   1 - static procedure dofoldersize()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE ShowProperty( nNo )

LOCAL cPath      := ""
LOCAL cFile      := ""
LOCAL cAttr      := ""
LOCAL bSaveError, oError
LOCAL lSuccess
LOCAL Retvar     := .F.
LOCAL oShell
LOCAL oFolder
LOCAL oItems
LOCAL oItem
LOCAL i, iMax
LOCAL j, jMax
LOCAL oVerbs
LOCAL oVerb
LOCAL cName      := ""

   GetPathandFile( nNo, @cPath, @cFile, @cAttr )

   bSaveError := ERRORBLOCK( { | oError | BREAK( oError ) } )
   BEGIN SEQUENCE

      IF ( ".LNK" ) $ UPPER( cFile )
         lSuccess := HMG_CallDLL( "SHELL32.DLL", DLL_OSAPI, "ShellExecute", ;
                                  GetActiveWindow(), ;
                                  "Properties", ;
                                  cPath + cFile, ;
                                  0, ;
                                  cPath, ;
                                  SW_NORMAL )
         DO CASE
            CASE lSuccess > 32
               Retvar := .T.
            OTHERWISE
               // ShellExecute fail.
               // Return False
               Retvar := .F.
         ENDCASE
      ELSE
         oShell := CreateObject( "Shell.Application" )
         IF NIL <> oShell
            oFolder := oShell:NameSpace( cPath )
            IF NIL <> oFolder
               cFile := UPPER( TRIM( cFile ) )
               oItems := oFolder:Items()

               iMax := oItems:Count
               FOR i := 1 TO iMax
                  oItem := oItems:Item( i - 1 )
                  IF oItem:IsFolder
                     IF "D" $ cAttr
                     ELSE
                        LOOP
                     ENDIF
                  ENDIF

                  IF !EMPTY( oItem )
                     cName := UPPER( TRIM( oItem:name ) )
                     IF cFile = cName
                        oVerbs := oItem:Verbs()
                        jMax := oVerbs:Count

                        // "Properties" are always last Item
                        oVerb := oVerbs:Item( jMax - 1 )
                        oVerb:DoIt()                                  // call Verb
                        Retvar := .T.
                        EXIT
                     ENDIF
                  ENDIF
               NEXT

               oFolder:destroy()
            ENDIF
            oShell:destroy()
         ENDIF

         // clean-up ActiveX
         oVerbs := NIL
         oFolder := NIL
         oShell := NIL

      ENDIF

   RECOVER
   END SEQUENCE
   ERRORBLOCK( bSaveError )

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure RunWinMsc()
*+
*+    Called from ( fmtool.prg )   1 - static procedure domymscaction()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE RunWinMsc( cAction )

LOCAL cRoot
LOCAL nPosi
LOCAL cEXE
LOCAL cPara      := ""
LOCAL oError
LOCAL bSaveError
LOCAL i, iMax
LOCAL myWinNT    := .T.

   IF .NOT. EMPTY( cAction )
      IF Is64Bit()
         HMG_CallDLL( "Kernel32.dll", DLL_OSAPI, "Wow64EnableWow64FsRedirection", FALSE )                                                   // disable bevor API Call
      ENDIF

      //       IF OS( OS_FAMILY ) == "WINNT"
      IF myWinNT = .T.
         cRoot := GETENV( "SYSTEMROOT" )

         IF ".CPL" $ UPPER( cAction )
            //   RUN ( "Shell32,Control_RunDLL " + cAction, cRoot + "\SYSTEM32\RUNDLL32.EXE", .T. )
            RUN ( cAction )

         ELSEIF ".DLL" $ UPPER( cAction )
            // ???
            IF "HOTPLUG.EXE" $ UPPER( cAction )
               RUN ( "Shell32,Control_RunDLL " + cAction, cRoot + "\SYSTEM32\RUNDLL32.EXE", .T. )
            ELSE
               RUN ( "Shell32,Control_RunDLL " + cAction, cRoot + "\SYSTEM32\RUNDLL32.EXE", .T. )
            ENDIF

         ELSEIF ".MSC" $ UPPER( cAction )
            //    RUN ( "/C START " + cAction )
            //  v1.28
            SHELLOPENFILE( "", cAction )

         ELSE
            bSaveError := ERRORBLOCK( { | e | BREAK( e ) } )
            BEGIN SEQUENCE

               IF "OSK.EXE" $ UPPER( cAction )
                  SHELLOPENFILE( "C:\WINDOWS\system32\", "osk.exe" )

               ELSEIF ".EXE" $ UPPER( cAction )

                  nPosi := AT( " ", cAction )
                  IF nPosi > 0
                     cEXE := SUBSTR( cAction, 1, nPosi - 1 )
                     cPara := SUBSTR( cAction, nPosi + 1, LEN( cAction ) - nPosi )
                     //  RUN( cPara, cRoot + "\system32\" + cEXE, .T. )
                     SHELLOPENFILE( "", cEXE, cPara )

                  ELSE
                     //  RUN( "", cRoot + "\system32\" + cAction, .T. )
                     //  RUN( "", cAction, .T. )
                     SHELLOPENFILE( "", cAction )
                  ENDIF
               ELSE
                  //  RUN( "", cAction, .T. )
                  SHELLOPENFILE( "", cAction )
               ENDIF

            RECOVER USING oError
               ERRORBLOCK( bSaveError )

               //  MSGBOX( DosErrorMessage( oError:osCode ), "Error osCode " + LTRIM( STR( oError:osCode ) ) )
               // IF oError:genCode == 40
               //    oError:description  : Betriebsystemfehler
               //    oError:filename     :
               //    oError:genCode      :         40
               //    oError:operation    : RUN
               //    oError:osCode       : DosErrorMessage()
               // ENDIF
            END SEQUENCE
            ERRORBLOCK( bSaveError )
         ENDIF

      ELSE
         IF ".CPL" $ UPPER( cAction )
            RUN ( cAction, "C:\WINDOWS\RUNDLL32.EXE", .T. )
         ELSEIF ".DLL" $ UPPER( cAction )
            RUN ( cRoot + "\system32\" + cAction, "C:\WINDOWS\RUNDLL32.EXE", .T. )
         ELSEIF ".MSC" $ UPPER( cAction )
            RUN ( "/C " + cAction,, .T. )
         ELSE
            RUN ( "/C " + cAction )
         ENDIF
      ENDIF

      IF Is64Bit()
         HMG_CallDLL( "Kernel32.dll", DLL_OSAPI, "Wow64EnableWow64FsRedirection", TRUE )                                                    // enable again
      ENDIF

   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Function SETXPARENT()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SETXPARENT( hWndChild, hWndNewParent )

   HMG_CallDLL( "USER32.DLL",, "SetParent", hWndChild, hWndNewParent )
RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Procedure DoFindWin()
*+
*+    Called from ( browser.prg )   2 - procedure browseview()
*+                                   1 - static procedure editdetail()
*+                                   1 - static procedure pre_setnewindex()
*+                                   1 - static procedure doseek()
*+                                   1 - static procedure copyresult()
*+                                   1 - static procedure doscope()
*+                                   1 - static procedure dolocate()
*+                ( hbftp.prg )   1 - function hbftp()
*+                ( viewer.prg )   1 - procedure showpdf()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE DoFindWin( cTitle )

LOCAL nWin                                                            // := FINDWINDOW( 0, cTitle )

   //    IF EMPTY( nWin )
   IF hb_cdpSelect() = "UTF8"
      nWin := HMG_CallDLL( "User32.dll", DLL_OSAPI, "FindWindowW", 0, cTitle )
   ELSE
      nWin := HMG_CallDLL( "User32.dll", DLL_OSAPI, "FindWindowA", 0, cTitle )
   ENDIF
   //    ENDIF

   IF !EMPTY( nWin )
      HMG_CallDLL( "User32.dll", DLL_OSAPI, "SetForegroundWindow", nWin )
      HMG_CallDLL( "User32.dll", DLL_OSAPI, "BringWindowToTop", nWin )
      HMG_CallDLL( "User32.dll", DLL_OSAPI, "ShowWindow", nWin, 1 )
      HMG_CallDLL( "User32.dll", DLL_OSAPI, "UpdateWindow", nWin )
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure ShowOSK()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE ShowOSK()

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
*+    Static Function FindAndCloseProcress()
*+
*+    Called from ( hmgdll.prg )   1 - procedure showosk()
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

*+ EOF: HMGDLL.PRG
