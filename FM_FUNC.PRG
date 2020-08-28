*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\FM_FUNC.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Function CompareFile()
*+               Function FindName()
*+               Function FindExt()
*+               Function HMS2Sec()
*+               Function FT_MKDIR()
*+               Function GetDesktopArea()
*+               Procedure RunByExtension()
*+               Function SHELLOPENFILE()
*+               Function GetTabName()
*+               Function GetDrives()
*+               Function UpPath()
*+               Function VolInfo()
*+               Function Is64Bit()
*+               Function VAR2CHAR()
*+               Function EndwithSlash()
*+               Procedure DiffCompare()
*+               Function SetAttr()
*+               Function Pathonly()
*+               Function fileonly()
*+               Function ListView_GETSELECTEDCOUNT()
*+               Function ListView_GETSELECTIONMARK()
*+               Function ListView_GETNEXTITEM()
*+               Function Findwindow()
*+               Function Comboboxshowlist()
*+               Function DRAGACCEPTFILES()
*+               Function GETDRIVETYPE()
*+               Function GETVOLUMEINFORMATION()
*+               Function DLL6432()
*+               Function ColumnIndexToColumnLetter()
*+               Function AppFolder()
*+               Function FT_ORIGIN()
*+               Procedure WinTans()
*+
*+    Reformatted by Click! 2.05.30 on Aug-28-2020 at  1:52 am
*+
*+--------------------------------------------------------------------

#include "HMG.CH"
#include "common.ch"
#include "Shell32.ch"
#include "dll.ch"
#include "Directry.ch"
#include "fileio.ch"

#include "HBFM.CH"
#include "SHFILE.CH"

#define LVM_FIRST             0x1000
#define LVM_GETSELECTEDCOUNT  (LVM_FIRST+50)
#define LVM_GETSELECTIONMARK  (LVM_FIRST+66)
#define LVM_GETNEXTITEM       (LVM_FIRST+12)

#define CB_SHOWDROPDOWN       0x014F

#define IMAGE_FILE_MACHINE_I386  0x14c
#define IMAGE_FILE_MACHINE_IA64  0x200
#define IMAGE_FILE_MACHINE_AMD64 0x8664

MEMVAR _HMG_SYSDATA

*+--------------------------------------------------------------------
*+
*+    Function CompareFile()
*+
*+    Called from ( fmgrid.prg )   2 - static function gridsortdir()
*+
*+--------------------------------------------------------------------
*+
FUNCTION CompareFile( aX, aY, lUp )

LOCAL cName1, cName2
LOCAL lRet

   DEFAULT lUp TO .T.

   cName1 := LOWER( FindExt( aX ) + FindName( aX ) )
   cName2 := LOWER( FindExt( aY ) + FindName( aY ) )

   IF lUp = .T.
      lRet := cName1 < cName2
   ELSE
      lRet := cName1 > cName2
   ENDIF

RETURN ( lRet )

*+--------------------------------------------------------------------
*+
*+    Function FindName()
*+
*+    Called from ( fmtool.prg )   1 - procedure sendtodesktop()
*+                                   1 - procedure sendtostartup()
*+                ( fm_func.prg )   2 - function comparefile()
*+
*+--------------------------------------------------------------------
*+
FUNCTION FindName( filename )

LOCAL nPosi := RAT( ".", filename )
RETURN SUBSTR( filename, 1, nPosi - 1 )

*+--------------------------------------------------------------------
*+
*+    Function FindExt()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure dataviewer()
*+                                   1 - static procedure slideshow()
*+                ( fm_func.prg )   2 - function comparefile()
*+
*+--------------------------------------------------------------------
*+
FUNCTION FindExt( filename )

LOCAL nPosi := RAT( ".", filename )
RETURN UPPER( SUBSTR( filename, nPosi + 1, LEN( filename ) ) )

*+--------------------------------------------------------------------
*+
*+    Function HMS2Sec()
*+
*+    Called from ( fmgrid.prg )   4 - static procedure comparedir()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMS2Sec( cHHMMSS )

LOCAL nSec := 0
LOCAL nHH  := 0
LOCAL nMM  := 0
LOCAL nSS  := 0

   nHH := VAL( SUBSTR( cHHMMSS, 1, 2 ) ) * 60 * 60
   nMM := VAL( SUBSTR( cHHMMSS, 4, 5 ) ) * 60
   nSS := VAL( SUBSTR( cHHMMSS, 7, 8 ) )

   nSec = nHH + nMM + nSS

RETURN nSec

*+--------------------------------------------------------------------
*+
*+    Function FT_MKDIR()
*+
*+    Called from ( fmgrid.prg )   2 - static procedure createnewfolder()
*+
*+--------------------------------------------------------------------
*+
FUNCTION FT_MKDIR( cdir )

LOCAL nErr := 0

   nErr := DIRMAKE( cdir )
   IF !EMPTY( nErr )
      MSGInfo( "failed to create directory " + cdir + " with error code " + STR( nErr, 4, 0 ) )
      RETURN nErr
   ENDIF

RETURN 0

*+--------------------------------------------------------------------
*+
*+    Function GetDesktopArea()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetDesktopArea()

LOCAL aDesk := { 0, 0, 0, 0 }
   aDesk[ 3 ] := GetDesktopWidth()
   aDesk[ 4 ] := GetDesktopHeight()
RETURN aDesk

*+--------------------------------------------------------------------
*+
*+    Procedure RunByExtension()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure doit()
*+                ( viewer.prg )   1 - procedure showpdf()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE RunByExtension( cPath, cName )

LOCAL nPosi, cPara, cFull

   ALTD()

   IF ".LNK" $ UPPER( cName )

      cFull := DXE_ResolveLink( cPath + cName )
      nPosi := AT( CHR( 0 ), cFull )
      IF nPosi > 0
         cPara := SUBSTR( cFull, nPosi + 1 )
         cFull := SUBSTR( cFull, 1, nPosi - 1 )
         SHELLOPENFILE( cFull,, cPara )
      ELSE
         SHELLOPENFILE( cFull )
      ENDIF
   ELSE
      SHELLOPENFILE( cPath, cName )
   ENDIF

RETURN

*+--------------------------------------------------------------------
*+
*+    Function SHELLOPENFILE()
*+
*+    Called from ( fmtool.prg )   4 - static procedure runwinmsc()
*+                ( fm_func.prg )   3 - procedure runbyextension()
*+                ( hbeject.prg )   1 - function ejectmedia()
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

         HMG_CallDLL( "shell32", DLL_OSAPI, "OpenAs_RunDLL", 0, ;
                      0, ;
                      cPath + cFile, ;
                      0, ;
                      cPara, ;
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

RETURN Retvar

*+--------------------------------------------------------------------
*+
*+    Function GetTabName()
*+
*+    Called from ( fmgrid.prg )   2 - static procedure doit()
*+                                   2 - static function gridchangepath()
*+                                   1 - static procedure fillwithdir()
*+                                   2 - static procedure newtab()
*+                                   1 - static procedure rootupdirpath()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetTabName( cPath )

LOCAL cRet := cPath
LOCAL nLen, nPosi

   nLen := LEN( cPath )
   nPosi := RAT( "\", cPath )
   IF nLen = nPosi
      cRet := SUBSTR( cPath, 1, nLen - 1 )
   ENDIF

   nPosi := RAT( "\", cRet )
   IF nPosi > 0
      cRet := SUBSTR( cRet, nPosi + 1 )
   ENDIF

RETURN cRet

*+--------------------------------------------------------------------
*+
*+    Function GetDrives()
*+
*+    Called from ( fmgrid.prg )   1 - procedure fillcombo()
*+                                   1 - static procedure changeleftright()
*+                                   1 - procedure checktabview()
*+                ( fm_func.prg )   1 - function volinfo()
*+                ( hbeject.prg )   1 - static function do_deviceimage()
*+                                   1 - static function filldevicegrid()
*+                ( hbftp.prg )   1 - static procedure filllocalcombo()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetDrives()

LOCAL n, cDrv, nDrv, cVolume := "", aDrive := {}

   FOR n := 1 TO 26
      cDrv := CHR( 64 + n )
      nDrv := GetDriveType( cDrv + ":\" + CHR( 0 ) )
      IF nDrv > 1
         IF nDrv == 2 .AND. UPPER( cDrv ) == "A"
            cVolume := [3 1/2"]
         ELSE
            cVolume := GetVolumeInformation( cDrv + ":\" )
         ENDIF
         AADD( aDrive, { IF( n = 1, 1, nDrv ), cDrv, IF( EMPTY( cVolume ), "none", cVolume ) } )
      ENDIF
   NEXT
RETURN aDrive

*+--------------------------------------------------------------------
*+
*+    Function UpPath()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure doit()
*+                                   1 - static procedure updirpath()
*+                                   1 - static procedure rootupdirpath()
*+
*+--------------------------------------------------------------------
*+
FUNCTION UpPath( cFull )

LOCAL cRet   := ""
LOCAL nPosi
LOCAL nStart

   nStart := RAT( "\", cFull )
   IF nStart > 0
      cRet := SUBSTR( cFull, 1, nStart - 1 )
      nPosi := RAT( "\", cRet )
      cRet := SUBSTR( cRet, 1, nPosi )
   ENDIF

RETURN cRet

*+--------------------------------------------------------------------
*+
*+    Function VolInfo()
*+
*+    Called from ( hbeject.prg )   1 - function ejectmedia()
*+
*+--------------------------------------------------------------------
*+
FUNCTION VolInfo( cIn )

LOCAL aDrives := GetDrives()
LOCAL nPosi, cVolume := ""
LOCAL cDrive  := UPPER( SUBSTR( cIn, 1, 1 ) )

   nPosi := ASCAN( aDrives, { | e | e[ 2 ] } )
   IF nPosi > 0
      cVolume := aDrives[ nPosi ] [ 3 ]
   ENDIF
RETURN cVolume

*+--------------------------------------------------------------------
*+
*+    Function Is64Bit()
*+
*+    Called from ( fmgrid.prg )   2 - static procedure showosk()
*+                ( fmregdb.prg )   2 - static function setstartnode()
*+                ( fmtool.prg )   2 - static procedure runwinmsc()
*+                ( fm_func.prg )   2 - function shellopenfile()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Is64Bit()

RETURN IF( FILE( "C:\WINDOWS\SysWOW64\Format.COM" ), .T., .F. )

*+--------------------------------------------------------------------
*+
*+    Function VAR2CHAR()
*+
*+    Called from ( browser.prg )   1 - function use_mydbf()
*+                                   1 - static procedure querytest()
*+                ( export.prg )   2 - static function mywritesdf()
*+                ( fmgrid.prg )   2 - function ondummy()
*+                ( fm_func.prg )   2 - procedure diffcompare()
*+                ( hbeject.prg )   3 - function ejectmedia()
*+                ( hbftp.prg )   2 - static function ondummy()
*+                ( modistru.prg )   1 - static procedure maxitemlen()
*+                                   2 - static function writeado2sdf()
*+
*+--------------------------------------------------------------------
*+
FUNCTION VAR2CHAR( cIn )

LOCAL cOut := hb_valToExp( cIn )
RETURN STRTRAN( cOut, '"', '' )

*+--------------------------------------------------------------------
*+
*+    Function EndwithSlash()
*+
*+    Called from ( hbevery.prg )   1 - static function domore()
*+                ( hbfm.prg )   2 - function main()
*+
*+--------------------------------------------------------------------
*+
FUNCTION EndwithSlash( cString )

LOCAL nPosi

   IF !EMPTY( cString )
      nPosi := RAT( "\", cString )
      IF nPosi = LEN( cString )
      ELSE
         cString += "\"
      ENDIF
      cString := STRTRAN( cString, "\\", "\" )
   ENDIF

RETURN cString

*+--------------------------------------------------------------------
*+
*+    Procedure DiffCompare()
*+
*+    Called from ( fmgrid.prg )   2 - static procedure comparedir()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE DiffCompare()

LOCAL iMax   := PCOUNT()
LOCAL i
LOCAL cText  := ""
LOCAL xValue

   FOR i := 1 TO iMax - 1
      cText += Var2Char( PValue( i ) ) + CHR( 9 )
   NEXT
   cText += Var2Char( PValue( iMax ) )

   MsgInfo( cText )

RETURN

*+--------------------------------------------------------------------
*+
*+    Function SetAttr()
*+
*+    Called from ( fmgrid.prg )   1 - static function changefattr()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SetAttr( cFileName, lArchive, lReadOnly, lHidden, lSystem, lChangeDT, cDate, cTime )

   // --------------------------------------------------------*
LOCAL nAttribute := 0, nError, dDate := CTOD( cDate )

   IF lArchive
      nAttribute += FILE_ATTRIBUTE_ARCHIVE
   ELSEIF lReadOnly
      nAttribute += FILE_ATTRIBUTE_READONLY
   ELSEIF lHidden
      nAttribute += FILE_ATTRIBUTE_HIDDEN
   ELSEIF lSystem
      nAttribute += FILE_ATTRIBUTE_SYSTEM
   ENDIF

   IF lChangeDT
      IF !hb_FSetDateTime( cFileName, dDate, cTime )
         MsgInfo( "Invalid date/time for " + cFileName )
      ENDIF

      //  ReReadFolder()
   ENDIF

   nError := SetFAttr( cFileName, nAttribute )
   IF nError = - 5
      MsgInfo( "Access denied to file " + cFileName )
   ENDIF

RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function Pathonly()
*+
*+    Called from ( fmgrid.prg )   1 - procedure addfile2grid()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Pathonly( cFull )

LOCAL cRet  := ""
LOCAL nPosi

   nPosi := RAT( "\", cFull )
   IF nPosi > 0
      cRet := SUBSTR( cFull, 1, nPosi )
   ENDIF

RETURN cRet

*+--------------------------------------------------------------------
*+
*+    Function fileonly()
*+
*+    Called from ( fmgrid.prg )   1 - procedure addfile2grid()
*+                ( modistru.prg )   1 - static procedure exportxls()
*+
*+--------------------------------------------------------------------
*+
FUNCTION fileonly( cFull )

LOCAL cRet  := ""
LOCAL nPosi

   nPosi := RAT( "\", cFull )
   IF nPosi > 0
      cRet := SUBSTR( cFull, nPosi + 1 )
   ENDIF

RETURN cRet

*+--------------------------------------------------------------------
*+
*+    Function ListView_GETSELECTEDCOUNT()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure unmarkall()
*+
*+--------------------------------------------------------------------
*+
FUNCTION ListView_GETSELECTEDCOUNT( hwndLV )

LOCAL nRet := 0
   nRet := SendMessage( hwndLV, LVM_GETSELECTEDCOUNT, 0, 0 )
RETURN nRet

*+--------------------------------------------------------------------
*+
*+    Function ListView_GETSELECTIONMARK()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure unmarkall()
*+
*+--------------------------------------------------------------------
*+
FUNCTION ListView_GETSELECTIONMARK( hwndLV )

LOCAL nRet := 0
   nRet := SendMessage( hwndLV, LVM_GETSELECTIONMARK, 0, 0 )
RETURN nRet

*+--------------------------------------------------------------------
*+
*+    Function ListView_GETNEXTITEM()
*+
*+    Called from ( fmgrid.prg )   2 - static procedure unmarkall()
*+
*+--------------------------------------------------------------------
*+
FUNCTION ListView_GETNEXTITEM( hwndLV, nIndex )

LOCAL nRet := 0
   nRet := SendMessage( hwndLV, nIndex, LVNI_SELECTED, 0 )
RETURN nRet

*+--------------------------------------------------------------------
*+
*+    Function Findwindow()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Findwindow( cTitle )

LOCAL hWnd := HMG_Calldll( "User32.dll", DLL_OSAPI, "FindWindowA", 0, cTitle )
RETURN hWnd

*+--------------------------------------------------------------------
*+
*+    Function Comboboxshowlist()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Comboboxshowlist( HWND )

LOCAL nRet := 0
   nRet := SendMessage( HWND, CB_SHOWDROPDOWN, 1, 0 )
RETURN nRet

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
*+    Function GETDRIVETYPE()
*+
*+    Called from ( fm_func.prg )   1 - function getdrives()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GETDRIVETYPE( cDrive )

LOCAL nDriveType, cRoot := cDrive + ":\" + CHR( 0 )
   nDriveType := HMG_Calldll( "Kernel32.DLL", DLL_OSAPI, "GetDriveTypeA", @cRoot )
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

   HMG_Calldll( "Kernel32.DLL", DLL_OSAPI, "GetVolumeInformationA", @cDrive, @cVolname, nVolLen, @nVolSer, @nCompLen, @nFSFlags, @cFSName, nFSLen )
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
*+    Function DLL6432()
*+
*+--------------------------------------------------------------------
*+
FUNCTION DLL6432( cDLL )

LOCAL cBuffer, nHandle, nBytes, nPointer
LOCAL cMachineType
LOCAL hHex
LOCAL cText        := ""

   IF !FILE( cDLL )
      MSGINFO( "Dll Name missing" )
      RETURN ""
   ENDIF

   nHandle := FOPEN( cDLL, FO_READ )
   cBuffer := SPACE( 512 )
   nBytes := FREAD( nHandle, @cBuffer, 512 )                          // Ergebnis: 512
   FCLOSE( nHandle )

   nPointer := AT( "PE" + CHR( 0 ) + CHR( 0 ), cBuffer )
   IF nPointer > 0
      cMachineType := ( SUBSTR( cBuffer, nPointer + 4, 2 ) )

      //      hHex := PeekWord(cMachineType)
      hHex := BIN2W( cMachineType )
      DO CASE
         CASE hHex = IMAGE_FILE_MACHINE_I386
            cText := "for 32bit Machine"

         CASE hHex = IMAGE_FILE_MACHINE_IA64 .OR. ;
                    hHex = IMAGE_FILE_MACHINE_AMD64
            cText := "for 64bit Machine"

         OTHERWISE
            cText := "unknown Machine"
      ENDCASE
   ENDIF

   //  MSGINFO(cText)
RETURN cText

*+--------------------------------------------------------------------
*+
*+    Function ColumnIndexToColumnLetter()
*+
*+--------------------------------------------------------------------
*+
FUNCTION ColumnIndexToColumnLetter( colIndex )

LOCAL div       := colIndex
LOCAL colLetter := ""
LOCAL modnum    := 0
   WHILE div > 0
      modnum := MOD( ( div - 1 ), 26 )
      colLetter := CHR( 65 + modnum ) + colLetter
      div := INT( ( div - modnum ) / 26 )
   END
RETURN colLetter

*+--------------------------------------------------------------------
*+
*+    Function AppFolder()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+                ( fmregdb.prg )   1 - procedure regdbform()
*+
*+--------------------------------------------------------------------
*+
FUNCTION AppFolder()

LOCAL cFile := FT_ORIGIN()
RETURN STRTRAN( cFile, "HBFM.EXE", "" )

*+--------------------------------------------------------------------
*+
*+    Function FT_ORIGIN()
*+
*+    Called from ( fm_func.prg )   1 - function appfolder()
*+
*+--------------------------------------------------------------------
*+
FUNCTION FT_ORIGIN()

LOCAL cOSCRLF := HB_OSNEWLINE()
LOCAL dirsep, drivesep, cFullPath
LOCAL cDisk   := DISKNAME()

   IF CHR( 13 ) + CHR( 10 ) = cOSCRLF                                 //must be ms based
      dirsep := '\'
      drivesep := DISKNAME() + ':'
   ELSE                                                               //must be linux,chr(10) or mac chr(13)
      dirsep := '/'
      drivesep := ''
      //  SET PATH '.;/home/paul/click')
   ENDIF
   cFullPath := drivesep + dirsep + CURDIR( drivesep ) + dirsep       //10/03 local copy in startup directory

   // Problem with "c:\hmg.3.4.4\" and function RootName( FILE_NAME )
   // add like Xbase++
   cFullPath += "HBFM.EXE"

RETURN cFullPath

*+--------------------------------------------------------------------
*+
*+    Procedure WinTans()
*+
*+    Called from ( ado.prg )   2 - procedure ado_view()
*+                ( browser.prg )   1 - procedure browseview()
*+                                   1 - static procedure dofindself()
*+                ( fmgrid.prg )   1 - procedure dualgrid()
*+                                   1 - static procedure readydrag()
*+                ( modistru.prg )   2 - function showarraystru()
*+                                   2 - static procedure exportxls()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE WinTans( cForm, lOnOff )

LOCAL hWnd
LOCAL bError := ERRORBLOCK( { | oErr | BREAK( oErr ) } )

   DEFAULT lOnOff TO .F.

   IF !EMPTY( cForm )
      BEGIN SEQUENCE
         hWnd := GetFormHandle( cForm )

         // nAlphaBlend = 0 to 255 (completely transparent = 0, opaque = 255)
         IF lOnOff = .T.
            SetLayeredWindowAttributes( hWnd, 0, 255, LWA_ALPHA )
         ELSE
            SetLayeredWindowAttributes( hWnd, 0, SP_nWinTans(), LWA_ALPHA )                                                                 // nAlphaBlend = 0 to 255 (completely transparent = 0, opaque = 255)
         ENDIF

      END SEQUENCE
      ERRORBLOCK( bError )

   ENDIF
RETURN

*+ EOF: FM_FUNC.PRG
