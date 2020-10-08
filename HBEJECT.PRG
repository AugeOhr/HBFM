*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\HBEJECT.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Procedure HBEJECT()
*+               Function EjectMedia()
*+               Static Function CreateVolHandle()
*+               Static Function LockVolume()
*+               Static Function DismountVolume()
*+               Static Function AutoEjectVolume()
*+               Static Function UnlockVolume()
*+               Static Function CloseVolume()
*+               Static Function PreventRemovalOfVolume()
*+               Static Function USB_DeviceColor()
*+               Static Function DO_DeviceImage()
*+               Static Function Do_DeviceAction()
*+               Static Function FillDeviceGrid()
*+               Static Procedure SayInfo()
*+
*+    Reformatted by Click! 2.05.35 on Oct-8-2020 at  3:10 am
*+
*+--------------------------------------------------------------------

#include "HMG.ch"

#include "common.ch"
//  #include "os.ch"
#include "dll.ch"

#include "EJECTDLL.CH"
#include "HBFM.CH"

#define FILE_SHARE_READ                   0x00000001
#define FILE_SHARE_WRITE                  0x00000002
#define FILE_SHARE_DELETE                 0x00000004
#define FILE_SHARE_VALID_FLAGS            0x00000007

#define GENERIC_READ                      0x80000000
#define GENERIC_WRITE                     0x40000000
#define GENERIC_EXECUTE                   0x20000000
#define GENERIC_ALL                       0x10000000

#define OPEN_EXISTING                     3
#define CRLF                              CHR(13)+CHR(10)

STATIC caItems := {}                                                  // for GRID
STATIC acImage := {}
STATIC aDrives
STATIC cInfo   := ""

MEMVAR bColorUSB
MEMVAR _HMG_SYSDATA

*+--------------------------------------------------------------------
*+
*+    Procedure HBEJECT()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE HBEJECT()

LOCAL nIndex, nStart
PUBLIC bColorUSB := { || IF( USB_DeviceColor(), SP_nColor2(), SP_nColor13() ) }

   IF SP_RunEject() = .T.
      RETURN
   ENDIF
   SP_RunEject( .T. )

   FillDeviceGrid()

   DEFINE WINDOW Win_Device ;
         AT 317, 574 ;
         WIDTH 442 ;
         HEIGHT 479 ;
         TITLE "Eject Device" ;
         ICON "ICOUSB" ;
         NOMAXIMIZE ;
         NOMINIMIZE ;
         BACKCOLOR SP_nColor1()

      DEFINE GRID Grid_Device
         ROW 20
         COL 20
         WIDTH 300
         HEIGHT 400
         ITEMS caItems
         VALUE Nil
         WIDTHS { 280, 10 }
         HEADERS { '', '' }
         FONTNAME SP_cFontName()
         FONTSIZE 24
         TOOLTIP ""
         ONCHANGE Nil
         ONDBLCLICK Do_DeviceAction()
         DYNAMICBACKCOLOR Nil
         DYNAMICFORECOLOR { bColorUSB, bColorUSB }
         SHOWHEADERS .F.
         NOLINES .T.
         ITEMCOUNT LEN( aDrives )
         BACKCOLOR SP_nColor9()
         FONTCOLOR SP_nColor10()
      END GRID

      DEFINE BUTTON Button_OK
         ROW 20
         COL 330
         WIDTH 80
         HEIGHT 198
         ACTION Do_DeviceAction()
         CAPTION "&OK"
         FONTNAME SP_cFontName()
         FONTSIZE 20
         TOOLTIP ""
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
         MULTILINE .F.
         PICTURE Nil
         PICTALIGNMENT TOP
      END BUTTON

      DEFINE BUTTON Button_Abort
         ROW 222
         COL 330
         WIDTH 80
         HEIGHT 198
         ACTION Win_Device.Release
         CAPTION "&Abort"
         FONTNAME SP_cFontName()
         FONTSIZE 20
         TOOLTIP ""
         FLAT .F.
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
         MULTILINE .F.
         PICTURE Nil
         PICTALIGNMENT TOP
      END BUTTON

      DEFINE LABEL Win_Label
         ROW 20
         COL 20
         WIDTH 420
         HEIGHT 450
         FONTNAME SP_cFontName()
         FONTSIZE 20
         BACKCOLOR SP_nColor1()
         FONTCOLOR SP_nColor2()
         VISIBLE .F.
      END LABEL

   END WINDOW

   DO_DeviceImage()

   CENTER WINDOW Win_Device
   Win_Device.Grid_Device.SetFocus

   ON KEY ESCAPE OF Win_Device ACTION Win_Device.Release

   Win_Device.Activate

   SP_RunEject( .F. )

RETURN

*+--------------------------------------------------------------------
*+
*+    Function EjectMedia()
*+
*+    Called from ( hbeject.prg )   1 - static function do_deviceaction()
*+
*+--------------------------------------------------------------------
*+
FUNCTION EjectMedia( cDrive, UseCDdrives )

   /****************************************************************
*
* USBeject based on https://support.microsoft.com/en-us/kb/165721
*
* will eject CD / DVD and "flush Buffer" if USB Drive
*
****************************************************************/

LOCAL hVolRead  := - 1                                                // "CreateFileA"
LOCAL nLock     := 0                                                  // "DeviceIoControl",hVolRead, FSCTL_LOCK_VOLUME
LOCAL nDisMount := 0                                                  // "DeviceIoControl",hVolRead, FSCTL_DISMOUNT_VOLUME
LOCAL nEject    := 0                                                  // "DeviceIoControl",hVolRead, IOCTL_STORAGE_EJECT_MEDIA
LOCAL nAccess   := 0
LOCAL nType     := 0
LOCAL cMsg      := ""
LOCAL nRemove   := 0
LOCAL lRet      := .T.
LOCAL cAction   := GETENV( "SYSTEMROOT" ) + "\SYSTEM32\HOTPLUG.DLL"
LOCAL cRoot     := "RUNDLL32.EXE "
LOCAL cPath     := GETENV( "TEMP" ) + "\"
   // LOCAL nVersion  := VAL( STRTRAN( OS(), "Windows NT ", "" ) )
LOCAL nVersion := WINMAJORVERSIONNUMBER()

   DEFAULT UseCDdrives TO .F.

   IF PCOUNT() = 0
      MsgInfo( "need Drive Letter" )
      RETURN .F.
   ENDIF

   //   IF nVersion < VERSION_VISTA
   IF .NOT. HMG_IsWinVistaOrLater()
      cAction := "hotplug.dll"
      cRoot := GETENV( "SYSTEMROOT" )
      RUN ( "Shell32,Control_RunDLL " + cAction, cRoot + "\SYSTEM32\RUNDLL32.EXE" )

   ELSE
      // cAction += ",HotPlugSafeRemovalDriveNotification Removeable Disk ("

      cAction += ",HotPlugSafeRemovalDriveNotification "
      cAction += VOLINFO( cDrive + ":\" )
      cAction += " ("
      cAction += cDrive + ":)"
   ENDIF

   nType := DriveType( cDrive )
   DO CASE
      CASE nType = DRIVE_UNKNOWN
      CASE nType = DRIVE_NO_ROOT_DIR
      CASE nType = DRIVE_REMOVABLE                                    //  Floppy
         nAccess := GENERIC_READ + GENERIC_WRITE
      CASE nType = DRIVE_FIXED
      CASE nType = DRIVE_REMOTE
      CASE nType = DRIVE_CDROM
         IF UseCDdrives = .T.
            nAccess := GENERIC_READ
         ENDIF
      CASE nType = DRIVE_RAMDISK
      OTHERWISE
         MsgInfo( "can not use Type " + STR( nType ) )
   ENDCASE

   IF EMPTY( nAccess )
      RETURN .F.
   ENDIF

   cInfo := ""                                                        // reset STATIC for SayInfo()
   SayInfo( "waiting for Drive " + cDrive + CRLF )
   hVolRead := CreateVolHandle( @cMsg, nType, nAccess, cDrive )

   IF hVolRead = - 1
      MsgInfo( "Unable to open drive " + cDrive )
      lRet := .F.
   ELSE

      // *********************************************************
      //
      //  https://msdn.microsoft.com/en-us/library/Aa363216.aspx
      //
      //  BOOL WINAPI DeviceIoControl(
      //    _In_        HANDLE       hDevice,
      //    _In_        DWORD        dwIoControlCode,
      //    _In_opt_    LPVOID       lpInBuffer,
      //    _In_        DWORD        nInBufferSize,
      //    _Out_opt_   LPVOID       lpOutBuffer,
      //    _In_        DWORD        nOutBufferSize,
      //    _Out_opt_   LPDWORD      lpBytesReturned,
      //    _Inout_opt_ LPOVERLAPPED lpOverlapped
      //  );
      //
      // *********************************************************

      nLock := LockVolume( hVolRead )
      IF nLock <> 0
         cMsg := "LockVolume()" + CRLF
         SayInfo( cMsg )

         nDisMount := DismountVolume( hVolRead )
         IF nDisMount <> 0
            cMsg := "DismountVolume()" + CRLF
            SayInfo( cMsg )

            // nRemove := PreventRemovalOfVolume( hVolRead, .F. )
            nRemove := 1
            IF nRemove <> 0
               cMsg := "PreventRemovalOfVolume()" + CRLF
               SayInfo( cMsg )

               nEject := AutoEjectVolume( hVolRead )
               //     IF nEject = 0
               cMsg := "AutoEjectVolume()" + CRLF
               SayInfo( cMsg )

               //     ELSE
               //         cMsg := "Error : can not AutoEjectVolume() "+VAR2CHAR(nEject))
               //         lRet := .F.
               //     ENDIF
            ELSE
               cMsg := "Error : can not PreventRemovalOfVolume() " + VAR2CHAR( nRemove )
               lRet := .F.
               SayInfo( cMsg )
            ENDIF
         ELSE
            cMsg := "Error : can not DismountVolume() " + VAR2CHAR( nDisMount )
            lRet := .F.
            SayInfo( cMsg )
         ENDIF
      ELSE
         cMsg := "Error : can not LockVolume() " + VAR2CHAR( nLock )
         lRet := .F.
         SayInfo( cMsg )
      ENDIF
   ENDIF

   CloseVolume( hVolRead )

   IF lRet = .F.
      Msginfo( cMsg )
   ELSE
      SayInfo( "remove your USE-Stick now" )
      hb_IdleSleep( 2.0 )
      IF nType <> DRIVE_CDROM                                         // will eject
         MEMOWRIT( cPath + "ShowMsg.BAT", cRoot + cAction )
         ShellOpenFile( cPath, "ShowMsg.BAT" )
         hb_IdleSleep( 2.0 )
         FERASE( cPath + "ShowMsg.BAT" )
      ENDIF
   ENDIF

RETURN lRet

*+--------------------------------------------------------------------
*+
*+    Static Function CreateVolHandle()
*+
*+    Called from ( hbeject.prg )   1 - function ejectmedia()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION CreateVolHandle( cMsg, nType, nAccess, cDrive )

LOCAL hVolWrite
LOCAL hVolRead
LOCAL nFlush    := 0                                                  // "FlushFileBuffers"
LOCAL cPath     := ""
LOCAL nShare    := FILE_SHARE_READ + FILE_SHARE_WRITE
LOCAL nDispo    := OPEN_EXISTING
LOCAL nAttrib   := 0                                                  // FILE_FLAG_OVERLAPPED + FILE_FLAG_BACKUP_SEMANTICS

   /**********************************************************
   *
   * https://msdn.microsoft.com/en-us/library/aa363858.aspx
   *
   * HANDLE WINAPI CreateFile(
   *   _In_     LPCTSTR               lpFileName,
   *   _In_     DWORD                 dwDesiredAccess,
   *   _In_     DWORD                 dwShareMode,
   *   _In_opt_ LPSECURITY_ATTRIBUTES lpSecurityAttributes,
   *   _In_     DWORD                 dwCreationDisposition,
   *   _In_     DWORD                 dwFlagsAndAttributes,
   *   _In_opt_ HANDLE                hTemplateFile
   * );
   *
   **********************************************************/

   cPath := "\\.\"
   cPath += cDrive
   cPath += ":"

   // Kernel32
   IF hb_cdpSelect() = "UTF8"
      hVolWrite := HMG_CallDLL( "Kernel32.dll", DLL_OSAPI, "CreateFileW", cPath, ;                                                          // lpFileName
                                nAccess, ;                            // dwDesiredAccess
                                nShare, ;                             // dwShareMode
                                NULL, ;                               // lpSecurityAttributes
                                nDispo, ;                             // dwCreationDisposition
                                nAttrib, ;                            // dwFlagsAndAttributes
                                NULL )                                // hTemplateFile
   ELSE
      hVolWrite := HMG_CallDLL( "Kernel32.dll", DLL_OSAPI, "CreateFile", cPath, ;                                                           // lpFileName
                                nAccess, ;                            // dwDesiredAccess
                                nShare, ;                             // dwShareMode
                                NULL, ;                               // lpSecurityAttributes
                                nDispo, ;                             // dwCreationDisposition
                                nAttrib, ;                            // dwFlagsAndAttributes
                                NULL )                                // hTemplateFile
   ENDIF

   IF hVolWrite = - 1
      RETURN hVolWrite
   ELSE
      // flush buffer
      //
      IF nType <> DRIVE_CDROM
         // Kernel32
         nFlush := HMG_CallDLL( "Kernel32.dll", DLL_OSAPI, "FlushFileBuffers", hVolWrite )
         cMsg := "FlushFile()" + CRLF
      ENDIF
   ENDIF

   // Kernel32
   HMG_CallDLL( "Kernel32.dll", DLL_OSAPI, "CloseHandle", hVolWrite )

   // open again RO
   //
   nAccess := GENERIC_READ

   // Kernel32
   IF hb_cdpSelect() = "UTF8"
      hVolRead := HMG_CallDLL( "Kernel32.dll", DLL_OSAPI, "CreateFileW", cPath, ;                                                           // lpFileName
                               nAccess, ;                             // dwDesiredAccess
                               nShare, ;                              // dwShareMode
                               NULL, ;                                // lpSecurityAttributes
                               nDispo, ;                              // dwCreationDisposition
                               nAttrib, ;                             // dwFlagsAndAttributes
                               NULL )                                 // hTemplateFile
   ELSE
      hVolRead := HMG_CallDLL( "Kernel32.dll", DLL_OSAPI, "CreateFile", cPath, ;                                                            // lpFileName
                               nAccess, ;                             // dwDesiredAccess
                               nShare, ;                              // dwShareMode
                               NULL, ;                                // lpSecurityAttributes
                               nDispo, ;                              // dwCreationDisposition
                               nAttrib, ;                             // dwFlagsAndAttributes
                               NULL )                                 // hTemplateFile
   ENDIF

RETURN hVolRead

*+--------------------------------------------------------------------
*+
*+    Static Function LockVolume()
*+
*+    Called from ( hbeject.prg )   1 - function ejectmedia()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION LockVolume( hVolRead )

LOCAL nBytes := 0
LOCAL nLock

   // Kernel32
   nLock := HMG_CallDLL( "Kernel32.dll", DLL_OSAPI, "DeviceIoControl", hVolRead, ;
                         FSCTL_LOCK_VOLUME, NULL, 0, NULL, 0, @nBytes, NULL )

RETURN nLock

*+--------------------------------------------------------------------
*+
*+    Static Function DismountVolume()
*+
*+    Called from ( hbeject.prg )   1 - function ejectmedia()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION DismountVolume( hVolRead )

LOCAL nBytes    := 0
LOCAL nDisMount

   // Kernel32
   nDisMount := HMG_CallDLL( "Kernel32.dll", DLL_OSAPI, "DeviceIoControl", hVolRead, ;
                             FSCTL_DISMOUNT_VOLUME, NULL, 0, NULL, 0, @nBytes, NULL )

RETURN nDisMount

*+--------------------------------------------------------------------
*+
*+    Static Function AutoEjectVolume()
*+
*+    Called from ( hbeject.prg )   1 - function ejectmedia()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION AutoEjectVolume( hVolRead )

LOCAL nBytes := 0
LOCAL nEject

   // Kernel32
   nEject := HMG_CallDLL( "Kernel32.dll", DLL_OSAPI, "DeviceIoControl", hVolRead, ;
                          IOCTL_STORAGE_EJECT_MEDIA, NULL, 0, NULL, 0, @nBytes, NULL )

RETURN nEject

*+--------------------------------------------------------------------
*+
*+    Static Function UnlockVolume()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION UnlockVolume( hVolRead )

LOCAL nBytes  := 0
LOCAL nUnlock

   // Kernel32
   nUnlock := HMG_CallDLL( "Kernel32.dll", DLL_OSAPI, "DeviceIoControl", hVolRead, ;
                           FSCTL_UNLOCK_VOLUME, NULL, 0, NULL, 0, @nBytes, NULL )

RETURN nUnlock

*+--------------------------------------------------------------------
*+
*+    Static Function CloseVolume()
*+
*+    Called from ( hbeject.prg )   1 - function ejectmedia()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION CloseVolume( hVolRead )

LOCAL lClose
   // Kernel32
   IF hb_cdpSelect() = "UTF8"
      lClose := HMG_CallDLL( "Kernel32.dll", DLL_OSAPI, "CloseHandleW", hVolRead )
   ELSE
      lClose := HMG_CallDLL( "Kernel32.dll", DLL_OSAPI, "CloseHandleA", hVolRead )
   ENDIF
RETURN lClose

*+--------------------------------------------------------------------
*+
*+    Static Function PreventRemovalOfVolume()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION PreventRemovalOfVolume( hVolRead, fPreventRemoval )

LOCAL nBytes  := 0
LOCAL nRemove
LOCAL pmr     := 1                                                    // PREVENT_MEDIA_REMOVAL():New()
LOCAL nSize   := pmr:_sizeof_()

   pmr:PreventMediaRemoval := fPreventRemoval
   nSize := 1
   // Kernel32
   nRemove := HMG_CallDLL( "Kernel32.dll", DLL_OSAPI, "DeviceIoControl", hVolRead, ;
                           IOCTL_STORAGE_MEDIA_REMOVAL, @pmr, nSize, NULL, 0, @nBytes, NULL )

RETURN nRemove

//  -------------------------------------------------------------------------- *
// howto create a Windows Structure under harbour
// BEGIN STRUCTURE PREVENT_MEDIA_REMOVAL
//    MEMBER BOOL PreventMediaRemoval
// END STRUCTURE

*+--------------------------------------------------------------------
*+
*+    Static Function USB_DeviceColor()
*+
*+    Called from ( hbeject.prg )   1 - procedure hbeject()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION USB_DeviceColor()

LOCAL lRet  := .F.
LOCAL nType := VAL( Win_Device.Grid_Device.CellEx( This.CellRowIndex, 2 ) )

   IF nType = DRIVE_REMOVABLE .OR. nType = DRIVE_CDROM
      lRet := .T.
   ENDIF
RETURN lRet

*+--------------------------------------------------------------------
*+
*+    Static Function DO_DeviceImage()
*+
*+    Called from ( hbeject.prg )   1 - procedure hbeject()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION DO_DeviceImage( lRefresh )

LOCAL nStart, i, ii, iiMax

   DEFAULT lRefresh TO .F.

   IF lRefresh = .T.
      Win_Device.Grid_Device.hide()
      Win_Device.Grid_Device.DisableUpdate()
      Win_Device.Grid_Device.DeleteAllItems()

      iiMax := LEN( caItems )
      FOR ii := 1 TO iiMax
         Win_Device.Grid_Device.AddItem( caItems[ ii ] )
      NEXT
   ENDIF

   aDrives := GetDrives()
   Win_Device.Grid_Device.ItemCount := LEN( aDrives )

   Win_Device.Grid_Device.Image( .T. ) := acImage
   FOR i = 1 TO Win_Device.Grid_Device.ItemCount
      Win_Device.Grid_Device.ImageIndex( i, 1 ) := i - 1
   NEXT

   nStart := ASCAN( caItems, { | e | e[ 2 ] = 2 .OR. e[ 2 ] = 5 } )
   Win_Device.Grid_Device.Value := nStart

   IF lRefresh = .T.
      Win_Device.Grid_Device.EnableUpdate()
      Win_Device.Grid_Device.Refresh()
      Win_Device.Grid_Device.show()
   ENDIF

RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Static Function Do_DeviceAction()
*+
*+    Called from ( hbeject.prg )   2 - procedure hbeject()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION Do_DeviceAction()

LOCAL nRow   := This.CellRowIndex
LOCAL nType  := VAL( Win_Device.Grid_Device.CellEx( This.CellRowIndex, 2 ) )
LOCAL cDrive := aDrives[ nRow ] [ 2 ]

   IF nType = DRIVE_REMOVABLE .OR. nType = DRIVE_CDROM
      Win_Device.Grid_Device.hide()
      Win_Device.Button_OK.hide()
      Win_Device.Button_Abort.hide()
      Win_Device.Win_Label.show()
      Win_Device.Win_Label.setfocus()

      IF EjectMedia( cDrive, .T. )
         Win_Device.Release
      ELSE
         Win_Device.Win_Label.hide()
         cInfo := ""                                                  // reset STATIC for SayInfo()
         Win_Device.Grid_Device.show()
         Win_Device.Button_OK.show()
         Win_Device.Button_Abort.show()
         Win_Device.Grid_Device.setfocus()
      ENDIF
   ELSE
      MsgInfo( "not removeable Drive " + cDrive )
   ENDIF
RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Static Function FillDeviceGrid()
*+
*+    Called from ( hbeject.prg )   1 - procedure hbeject()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION FillDeviceGrid()

LOCAL cDrive, cVolume, nType, i

   aDrives := GetDrives()
   acImage := {}
   caItems := {}

   FOR i := 1 TO LEN( aDrives )
      nType := aDrives[ i ] [ 1 ]
      cDrive := aDrives[ i ] [ 2 ]
      cVolume := aDrives[ i ] [ 3 ]

      DO CASE
         CASE nType = DRIVE_UNKNOWN
            AADD( acImage, "MYUNKNOWN" )
            AADD( caItems, { " " + cDrive + SPACE( 3 ) + cVolume, nType } )
         CASE nType = DRIVE_NO_ROOT_DIR
            AADD( acImage, "MYFIXDRIVE" )
            AADD( caItems, { " " + cDrive + SPACE( 3 ) + cVolume, nType } )
         CASE nType = DRIVE_REMOVABLE                                 // removeable
            AADD( acImage, "MYUSBSTICK" )
            AADD( caItems, { " " + cDrive + SPACE( 3 ) + cVolume, nType } )
         CASE nType = DRIVE_FIXED
            IF cDrive = "C"
               AADD( acImage, "MYSYSDRIVE" )
               AADD( caItems, { " " + cDrive + SPACE( 3 ) + cVolume, nType } )
            ELSE
               AADD( acImage, "MYFIXDRIVE" )
               AADD( caItems, { " " + cDrive + SPACE( 3 ) + cVolume, nType } )
            ENDIF
         CASE nType = DRIVE_REMOTE
            AADD( acImage, "MYNETDRIVE" )
            AADD( caItems, { " " + cDrive + SPACE( 3 ) + cVolume, nType } )
         CASE nType = DRIVE_CDROM
            AADD( acImage, "MYCDROM" )
            AADD( caItems, { " " + cDrive + SPACE( 3 ) + cVolume, nType } )
         CASE nType = DRIVE_RAMDISK
            AADD( acImage, "MYRAMDISK" )
            AADD( caItems, { " " + cDrive + SPACE( 3 ) + cVolume, nType } )
         OTHERWISE
            AADD( acImage, "MYUNKNOWN" )
            AADD( caItems, { " " + cDrive + SPACE( 3 ) + cVolume, nType } )
      ENDCASE

   NEXT

RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Static Procedure SayInfo()
*+
*+    Called from ( hbeject.prg )   9 - function ejectmedia()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SayInfo( cText )

LOCAL cNew

   cInfo += cText + CRLF
   Win_Device.Win_Label.Value := cInfo
   hb_IdleSleep( 0.5 )

RETURN

//
//
//

*+ EOF: HBEJECT.PRG
