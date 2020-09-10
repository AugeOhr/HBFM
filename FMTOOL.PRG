*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\FMTOOL.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Procedure GodMode()
*+               Static Function GetGUIDData()
*+               Static Function GetWinMsc()
*+               Function WinSysFolder()
*+               Procedure FuncSysFolder()
*+               Static Procedure FillSysFolder()
*+               Static Procedure DoMySysAction()
*+               Static Function GetLongFileName()
*+               Static Function c_StartMenue()
*+               Static Function c_PinToTaskbar()
*+               Procedure FuncMSCFolder()
*+               Static Procedure DoMyMSCAction()
*+               Static Procedure RunWinMsc()
*+               Procedure ShowProperty()
*+               Procedure SendToDeskTop()
*+               Procedure SendToStartup()
*+               Static Function DXE_CreateLink()
*+               Function DXE_ResolveLink()
*+               Function Userfolder()
*+
*+    Reformatted by Click! 2.05.32 on Sep-10-2020 at  2:10 am
*+
*+--------------------------------------------------------------------

#include "HMG.CH"
#include "DLL.CH"
#include "Directry.ch"
#include "common.ch"
#include "fileio.ch"

#include "HBFM.CH"

MEMVAR LACTIVEMAIN
MEMVAR _HMG_SYSDATA

*+--------------------------------------------------------------------
*+
*+    Procedure GodMode()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE GodMode()

LOCAL cText
LOCAL oWSHShell
LOCAL bError    := ERRORBLOCK( { | oErr | BREAK( oErr ) } )

   cText := GETENV( "windir" )
   //   cText += "\explorer.exe God mode.{ED7BA470-8E54-465E-825C-99712043E01C}"
   cText += "\explorer.exe shell:::{ED7BA470-8E54-465E-825C-99712043E01C}"

   BEGIN SEQUENCE
      oWSHShell := createobject( "wscript.shell" )
      oWSHShell:run( cText )

      oWSHShell:Destroy()
   END SEQUENCE
   ERRORBLOCK( bError )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function GetGUIDData()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GetGUIDData()

LOCAL aText := {}

   AADD( aText, { "GOD Mode               ", "shell:::{ED7BA470-8E54-465E-825C-99712043E01C}" } )
   AADD( aText, { "Location Settings      ", "shell:::{00C6D95F-329C-409a-81D7-C46C66EA7F33}" } )
   AADD( aText, { "Biometric Settings     ", "shell:::{0142e4d0-fb7a-11dc-ba4a-000ffe7ab428}" } )
   AADD( aText, { "Power Settings         ", "shell:::{025A5937-A6BE-4686-A844-36FE4BEC8B6D}" } )
   AADD( aText, { "Icons And Notifications", "shell:::{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9}" } )
   AADD( aText, { "Credentials and Logins ", "shell:::{1206F5F1-0569-412C-8FEC-3204630DFB70}" } )
   AADD( aText, { "Programs and Features  ", "shell:::{15eae92e-f17a-4431-9f28-805e482dafd4}" } )
   AADD( aText, { "Default Programs       ", "shell:::{17cd9488-1228-4b2f-88ce-4298e93e0966}" } )
   AADD( aText, { "All NET Frameworks and COM Libraries", "shell:::{1D2680C9-0E2A-469d-B787-065558BC7D43}" } )
   AADD( aText, { "All Networks For Current Connection ", "shell:::{1FA9085F-25A2-489B-85D4-86326EEDCD87}" } )
   AADD( aText, { "Network                ", "shell:::{208D2C60-3AEA-1069-A2D7-08002B30309D}" } )
   AADD( aText, { "My Computer            ", "shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}" } )
   AADD( aText, { "Printers               ", "shell:::{2227A280-3AEA-1069-A2DE-08002B30309D}" } )
   AADD( aText, { "Application Connections", "shell:::{241D7C96-F8BF-4F85-B01F-E2B043341A4B}" } )
   AADD( aText, { "Firewall and Security  ", "shell:::{4026492F-2F69-46B8-B9BF-5654FC07E423}" } )
   AADD( aText, { "Performance            ", "shell:::{78F3955E-3B90-4184-BD14-5397C15F1EFC}" } )

   AADD( aText, { "Local Pictures         ", "shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" } )
   AADD( aText, { "My Videos              ", "shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{A0953C92-50DC-43BF-BE83-3742FED03C9C}" } )
   AADD( aText, { "AppsFolder             ", "shell:::{4234d49b-0245-4df3-b780-3893943456e1}" } )
   AADD( aText, { "My Pictures            ", "shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{3ADD1653-EB32-4CB0-BBD7-DFA0ABB5ACCA}" } )
   AADD( aText, { "Local Videos           ", "shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" } )
   AADD( aText, { "Downloads              ", "shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{374DE290-123F-4565-9164-39C4925E467B}" } )
   AADD( aText, { "My Music               ", "shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{1CF1260C-4DD0-4EBB-811F-33C572699FDE}" } )
   AADD( aText, { "Desktop                ", "shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" } )
   AADD( aText, { "Local Download         ", "shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{088e3905-0323-4b02-9826-5d99428e115f}" } )
   AADD( aText, { "MAPIfolder             ", "shell:::{89D83576-6BD1-4C86-9454-BEB04E94C819}\*" } )
   AADD( aText, { "Local Music            ", "shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" } )
   AADD( aText, { "OneDrive               ", "shell:::{018D5C66-4533-4307-9B53-224DE2ED1FE6}" } )
   AADD( aText, { "AddNewProgramsFolder   ", "shell:::{26EE0668-A00A-44D7-9371-BEB064C98683}\0\::{15eae92e-f17a-4431-9f28-805e482dafd4}" } )
   AADD( aText, { "CSCFolder              ", "shell:::{BD7A2E7B-21CB-41b2-A086-B309680C6B7E}\*" } )
   AADD( aText, { "Local Documents        ", "shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{d3162b92-9365-467a-956b-92703aca08af}" } )
   AADD( aText, { "Personal               ", "shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" } )

   //   RunShell( "shell:::{ED7BA470-8E54-465E-825C-99712043E01C}","EXPLORER.EXE",.T.,.F.)

RETURN aText

*+--------------------------------------------------------------------
*+
*+    Static Function GetWinMsc()
*+
*+    Called from ( fmtool.prg )   1 - procedure funcmscfolder()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GetWinMsc()

LOCAL aArray := {}

   AADD( aArray, { "compmgmt.msc               ", "Computer Verwaltung           ", "Computer administration       ", "ALL" } )
   AADD( aArray, { "devmgmt.msc                ", "GerÑte Manager                ", "Device Management             ", "ALL" } )
   AADD( aArray, { "diskmgmt.msc               ", "Festplatten Verwaltung        ", "Disk management               ", "ALL" } )
   AADD( aArray, { "eventvwr.msc               ", "Ereigniss Anzeige             ", "Event display                 ", "ALL" } )
   AADD( aArray, { "services.msc               ", "Dienste                       ", "Services                      ", "ALL" } )
   AADD( aArray, { "wf.msc                     ", "Firewall                      ", "Firewall                      ", "ALL" } )
   AADD( aArray, { "fsmgmt.msc                 ", "Freigaben                     ", "Shared Folders                ", "ALL" } )
   AADD( aArray, { "printmanagement.msc        ", "Druck Verwaltung              ", "Print management              ", "W7" } )
   AADD( aArray, { "lusrmgr.msc                ", "Lokale Benutzer und Gruppen   ", "Local users and groups        ", "W7" } )
   AADD( aArray, { "perfmon.msc                ", "LeistungsÅberwachung          ", "Performance Monitor           ", "W7" } )
   AADD( aArray, { "taskschd.msc               ", "Aufgabenplanung               ", "Task Scheduler                ", "W7" } )
   AADD( aArray, { "gpedit.msc                 ", "Groupmanager                  ", "Group Manager                 ", "W7" } )
   AADD( aArray, { "secpol.msc                 ", "Lokale Sicherheitsrichtlinien ", "Local security policies       ", "ALL" } )
   AADD( aArray, { "appwiz.cpl                 ", "Software Verwaltung           ", "Software management           ", "ALL" } )
   AADD( aArray, { "desk.cpl                   ", "Eigenschaften Anzeige         ", "Properties display            ", "ALL" } )
   AADD( aArray, { "main.cpl                   ", "Maus Eigenschaften            ", "Mouse, Fonts, Keyboard        ", "ALL" } )
   AADD( aArray, { "mmsys.cpl                  ", "Sound Eigenschaften           ", "Multimedia properties         ", "ALL" } )
   AADD( aArray, { "ncpa.cpl                   ", "Netzwerk VerbindungsÅbersicht ", "Network connection overview   ", "ALL" } )
   AADD( aArray, { "telefon.cpl                ", "Telefon / Modem Einstellungen ", "Telephone / modem settings    ", "ALL" } )
   AADD( aArray, { "timedate.cpl               ", "Datum / Uhrzeit Einstellungen ", "Date/Time properties          ", "ALL" } )
   AADD( aArray, { "powercfg.cpl               ", "Energieeinstellungen          ", "Power settings                ", "ALL" } )
   AADD( aArray, { "Firewall.cpl               ", "Windows Firewall              ", "Windows Firewall              ", "ALL" } )
   AADD( aArray, { "inetcpl.cpl                ", "Eigenschaften von Internet    ", "Internet properties           ", "ALL" } )
   AADD( aArray, { "intl.cpl                   ", "Region und Sprache            ", "Region and Language           ", "ALL" } )
   AADD( aArray, { "sysdm.cpl                  ", "Systemeigenschaften           ", "System / Hardware wizard      ", "ALL" } )
   AADD( aArray, { "wscui.cpl                  ", "Sicherheits / Wartungs Center ", "Security / maintenance center ", "ALL" } )
   AADD( aArray, { "osk.exe                    ", "Bildschirmtastatur            ", "On Screen keyboard            ", "ALL" } )
   AADD( aArray, { "utilman.exe                ", "Hilfsprogramm Manager         ", "Utility manager               ", "ALL" } )
   AADD( aArray, { "perfmon.exe /res           ", "Ressourcenmonitor             ", "resource monitor              ", "ALL" } )
   AADD( aArray, { "charmap.exe                ", "Sonderzeichen                 ", "Character Map                 ", "ALL" } )
   AADD( aArray, { "shrpubw.exe                ", "Ordner freigeben              ", "Shared folder wizard          ", "ALL" } )
   AADD( aArray, { "magnify.exe                ", "Vergrî·erungsglas             ", "Magnifying glass              ", "ALL" } )
   AADD( aArray, { "dccw.exe                   ", "Farbdarstellung               ", "Display Color Calibration     ", "ALL" } )
   AADD( aArray, { "explorer.exe               ", "Explorer                      ", "Explorer                      ", "ALL" } )
   AADD( aArray, { "notepad.exe                ", "Notepad                       ", "Notepad                       ", "ALL" } )
   AADD( aArray, { "calc.exe                   ", "Calculator                    ", "Calculator                    ", "ALL" } )
   AADD( aArray, { "cleanmgr.exe /lowdisk      ", "Disk Cleanup                  ", "Disk Cleanup                  ", "ALL" } )
   AADD( aArray, { "cmd.exe                    ", "Command shell/window          ", "Command shell/window          ", "ALL" } )
   AADD( aArray, { "ipconfig.exe               ", "IPConfig-find your IP details ", "IPConfig-find your IP details ", "ALL" } )
   AADD( aArray, { "magnify.exe                ", "Screen Magnifier              ", "Screen Magnifier              ", "ALL" } )
   AADD( aArray, { "mspaint.exe                ", "Paintbrush                    ", "Paintbrush                    ", "ALL" } )
   AADD( aArray, { "narrator.exe               ", "Windows Sprachausgabe         ", "Windows speech                ", "ALL" } )
   AADD( aArray, { "taskmgr.exe                ", "Task Manager                  ", "Task Manager                  ", "ALL" } )
   AADD( aArray, { "wordpad.exe                ", "Wordpad                       ", "Wordpad                       ", "ALL" } )
   AADD( aArray, { "stikynot.exe               ", "Notizzettel                   ", "Sticky Notes                  ", "W7" } )
   AADD( aArray, { "computerdefaults.exe       ", "Standard-Software wÑhlen      ", "Select standard software      ", "W7" } )
   AADD( aArray, { "psr.exe                    ", "Windows-Probleme aufzeichnen  ", "Record Windows problems       ", "W7" } )
   AADD( aArray, { "iexpress.exe               ", "Selbstentpackendes Archiv     ", "Self-extracting archive       ", "W7" } )
   AADD( aArray, { "control.exe                ", "Systemsteuerrung              ", "Control Panel                 ", "ALL" } )
   AADD( aArray, { "control.exe folders        ", "Ordner Optionen               ", "Options folder                ", "ALL" } )
   AADD( aArray, { "control.exe fonts          ", "Font Manager                  ", "Font Manager                  ", "ALL" } )
   AADD( aArray, { "control.exe keyboard       ", "Keyboard Eigenschaften        ", "Keyboard properties           ", "ALL" } )
   AADD( aArray, { "control.exe userpasswords2 ", "Benutzer Konten Verwaltung    ", "User accounts management      ", "ALL" } )
   AADD( aArray, { "control.exe printers       ", "GerÑte und Drucker            ", "Devices and printers          ", "W7" } )
   AADD( aArray, { "control.exe keyboard       ", "Tastatur Eigenschaften        ", "Keyboard properties           ", "W7" } )

RETURN aArray

*+--------------------------------------------------------------------
*+
*+    Function WinSysFolder()
*+
*+    Called from ( fmtool.prg )   1 - procedure funcsysfolder()
*+                                   1 - function userfolder()
*+
*+--------------------------------------------------------------------
*+
FUNCTION WinSysFolder()

LOCAL aRet := {}
   AADD( aRet, { "Desktop           ", .T., "<desktop>                                                       ", CSIDL_DESKTOP } )
   AADD( aRet, { "Programs          ", .T., "Start Menu\Programs                                             ", CSIDL_PROGRAMS } )
   AADD( aRet, { "Personal          ", .T., "My Documents                                                    ", CSIDL_PERSONAL } )
   AADD( aRet, { "Favorites         ", .T., "<user name>\Favorites                                           ", CSIDL_FAVORITES } )
   AADD( aRet, { "Startup           ", .T., "Start Menu\Programs\Startup                                     ", CSIDL_STARTUP } )
   AADD( aRet, { "Recent            ", .T., "<user name>\Recent                                              ", CSIDL_RECENT } )
   AADD( aRet, { "SendTo            ", .T., "<user name>\SendTo                                              ", CSIDL_SENDTO } )
   AADD( aRet, { "StartMenu         ", .T., "<user name>\Start Menu                                          ", CSIDL_STARTMENU } )
   AADD( aRet, { "MyDocuments       ", .T., "logical 'My Documents' desktop icon                             ", CSIDL_MYDOCUMENTS } )
   AADD( aRet, { "MyMusic           ", .T., "'My Music' folder                                               ", CSIDL_MYMUSIC } )
   AADD( aRet, { "MyVideo           ", .T., "'My Videos' folder                                              ", CSIDL_MYVIDEO } )
   AADD( aRet, { "DesktopDir        ", .T., "<user name>\Desktop                                             ", CSIDL_DESKTOPDIRECTORY } )
   AADD( aRet, { "Nethood           ", .T., "<user name>\nethood                                             ", CSIDL_NETHOOD } )
   AADD( aRet, { "Fonts             ", .T., "windows\fonts                                                   ", CSIDL_FONTS } )
   AADD( aRet, { "Templates         ", .T., "                                                                ", CSIDL_TEMPLATES } )
   AADD( aRet, { "cmStartMenu       ", .T., "All Users\Start Menu                                            ", CSIDL_COMMON_STARTMENU } )
   AADD( aRet, { "cmPrograms        ", .T., "All Users\Start Menu\Programs                                   ", CSIDL_COMMON_PROGRAMS } )
   AADD( aRet, { "cmStartup         ", .T., "All Users\Startup                                               ", CSIDL_COMMON_STARTUP } )
   AADD( aRet, { "cmDesktop         ", .T., "All Users\Desktop                                               ", CSIDL_COMMON_DESKTOPDIRECTORY } )
   AADD( aRet, { "Appdata           ", .T., "<user name>\Application Data                                    ", CSIDL_APPDATA } )
   AADD( aRet, { "Printhood         ", .T., "<user name>\PrintHood                                           ", CSIDL_PRINTHOOD } )
   AADD( aRet, { "LocalAppData      ", .T., "<user name>\Local Settings\Applicaiton Data (non roaming)       ", CSIDL_LOCAL_APPDATA } )
   AADD( aRet, { "Altstartup        ", .T., "non localized startup                                           ", CSIDL_ALTSTARTUP } )
   AADD( aRet, { "cmAltStartup      ", .T., "non localized common startup                                    ", CSIDL_COMMON_ALTSTARTUP } )
   AADD( aRet, { "cmFavorites       ", .T., "                                                                ", CSIDL_COMMON_FAVORITES } )
   AADD( aRet, { "InternetCache     ", .T., "                                                                ", CSIDL_INTERNET_CACHE } )
   AADD( aRet, { "Cookies           ", .T., "                                                                ", CSIDL_COOKIES } )
   AADD( aRet, { "History           ", .T., "                                                                ", CSIDL_HISTORY } )
   AADD( aRet, { "cmAppdata         ", .T., "All Users\Application Data                                      ", CSIDL_COMMON_APPDATA } )
   AADD( aRet, { "Windows           ", .T., "GetWindowsDirectory()                                           ", CSIDL_WINDOWS } )
   AADD( aRet, { "System            ", .T., "GetSystemDirectory()                                            ", CSIDL_SYSTEM } )
   AADD( aRet, { "ProgramFiles      ", .T., "C:\Program Files                                                ", CSIDL_PROGRAM_FILES } )
   AADD( aRet, { "MyPictures        ", .T., "C:\Program Files\My Pictures                                    ", CSIDL_MYPICTURES } )
   AADD( aRet, { "Profile           ", .T., "USERPROFILE                                                     ", CSIDL_PROFILE } )
   AADD( aRet, { "cmProgramFiles    ", .T., "C:\Program Files\Common                                         ", CSIDL_PROGRAM_FILES_COMMON } )
   AADD( aRet, { "cmTemplates       ", .T., "All Users\Templates                                             ", CSIDL_COMMON_TEMPLATES } )
   AADD( aRet, { "cmDocuments       ", .T., "All Users\Documents                                             ", CSIDL_COMMON_DOCUMENTS } )
   AADD( aRet, { "cmAdminTools      ", .T., "All Users\Start Menu\Programs\Administrative Tools              ", CSIDL_COMMON_ADMINTOOLS } )
   AADD( aRet, { "AdminTools        ", .T., "<user name>\Start Menu\Programs\Administrative Tools            ", CSIDL_ADMINTOOLS } )
   AADD( aRet, { "cmMusic           ", .T., "All Users\My Music                                              ", CSIDL_COMMON_MUSIC } )
   AADD( aRet, { "cmPictures        ", .T., "All Users\My Pictures                                           ", CSIDL_COMMON_PICTURES } )
   AADD( aRet, { "cmVideo           ", .T., "All Users\My Video                                              ", CSIDL_COMMON_VIDEO } )
   AADD( aRet, { "Resources         ", .T., "Resource Direcotry                                              ", CSIDL_RESOURCES } )
   AADD( aRet, { "ResourcesLocalized", .T., "Localized Resource Direcotry                                    ", CSIDL_RESOURCES_LOCALIZED } )
   AADD( aRet, { "cmOemLinks        ", .T., "Links to All Users OEM specific apps                            ", CSIDL_COMMON_OEM_LINKS } )
   AADD( aRet, { "CdBurnArea        ", .T., "USERPROFILE\Local Settings\Application Data\Microsoft\CD Burning", CSIDL_CDBURN_AREA } )

   //    AADD( aRet, { "_StartMenue       ", .T., "\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\StartMenu" } )
   //    AADD( aRet, { "_PinToTaskbar     ", .T., "\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" } )
RETURN aRet

*+--------------------------------------------------------------------
*+
*+    Procedure FuncSysFolder()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure prefuncsysfolder()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE FuncSysFolder()

LOCAL aFolder := WinSysFolder()
LOCAL a2List  := {}
LOCAL i, iMax := LEN( aFolder )

   lActiveMain := .F.

   FOR i := 1 TO iMax
      AADD( a2List, aFolder[ i ] [ 1 ] )
   NEXT

   DEFINE WINDOW ListSysFolder ;
              AT 348, 589 ;
              WIDTH 224 ;
              HEIGHT 755 ;
              TITLE "" ;
              ICON "A1MAIN" ;
              TOPMOST ;
              NOMINIMIZE ;
              NOMAXIMIZE ;
              NOSIZE ;
              BACKCOLOR SP_nColor1()

      DEFINE LISTBOX List_SysFolder
         PARENT ListSysFolder
         ROW 10
         COL 10
         WIDTH 200
         HEIGHT 700
         ITEMS a2List
         VALUE 1
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontLarge()
         TOOLTIP ""
         BACKCOLOR SP_nColor9( )
         FONTCOLOR SP_nColor10()
         ONDBLCLICK DoMySysAction( aFolder )
         TABSTOP .T.
         VISIBLE .T.
         SORT .F.
         MULTISELECT .F.
         DRAGITEMS .F.
      END LISTBOX

   END WINDOW

   ON KEY ESCAPE OF ListSysFolder ACTION ListSysFolder.Release
   CENTER WINDOW ListSysFolder
   ListSysFolder.List_SysFolder.setfocus()
   ACTIVATE WINDOW ListSysFolder

   lActiveMain := .T.

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure FillSysFolder()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE FillSysFolder( aFolder )

LOCAL i, iMax := LEN( aFolder )

   Domethod( "ListSysFolder", "List_SysFolder", "DeleteAllItems" )
   FOR i := 1 TO iMax
      Domethod( "ListSysFolder", "List_SysFolder", "AddItem", aFolder[ i ] [ 1 ] )
   NEXT
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoMySysAction()
*+
*+    Called from ( fmtool.prg )   1 - procedure funcsysfolder()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoMySysAction( aFolder )

LOCAL nRow, cFunc, nPosi
LOCAL cShortName
LOCAL lPath      := .T.
LOCAL cNewFolder, cRet

   nRow := GetProperty( "ListSysFolder", "List_SysFolder", "Value" )
   IF EMPTY( nRow )
      ListSysFolder.Release
      RETURN
   ENDIF

   ListSysFolder.hide()

   cRet := aFolder[ nRow ] [ 4 ]
   cShortName := C_GETSPECIALFOLDER( cRet )
   //      cNewFolder := GetLongFileName( cShortName, lPath ) + "\"
   cNewFolder := TRIM( cShortName ) + "\"

   SP_NewPath( cNewFolder )
   //    ENDIF
   ListSysFolder.Release
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function GetLongFileName()
*+
*+    Called from ( fmtool.prg )   1 - static function getlongfilename()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GetLongFileName( cShortName, lPath )

LOCAL lFullPath := IIF( lPath == NIL, .f., lPath )
LOCAL cFileName := IIF( cShortName == NIL, '', ALLTRIM( cShortName ) )
LOCAL lEndSlash := RIGHT( cFileName, 1 ) == '\'
LOCAL cLongName := IIF( lEndSlash, LEFT( cFileName, LEN( cFileName ) - 1 ), cFileName )
LOCAL cPathName := LEFT( cLongName, RAT( '\', cLongName ) )
LOCAL aDir      := DIRECTORY( cLongName, 'DHS' )
   DO CASE
      CASE RIGHT( cLongName, 1 ) == ':'
         RETURN ( UPPER( cLongName ) + IIF( lEndSlash, '\', '' ) )
      CASE LEN( aDir ) == 1
         cLongName := ALLTRIM( aDir[ 1, F_NAME ] )
      OTHERWISE
         RETURN ( IIF( lEndSlash, '\', '' ) )
   ENDCASE
   IF lFullPath
      RETURN ( GetLongFileName( cPathName, ( '\' $ cPathName ) ) + cLongName + IIF( lEndSlash, '\', '' ) )
   ENDIF
RETURN ( cLongName )

*+--------------------------------------------------------------------
*+
*+    Static Function c_StartMenue()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION c_StartMenue

LOCAL cUser := GETENV( "USERPROFILE" )
RETURN cUser + "\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\StartMenu\"

*+--------------------------------------------------------------------
*+
*+    Static Function c_PinToTaskbar()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION c_PinToTaskbar

LOCAL cUser := GETENV( "USERPROFILE" )
RETURN cUser + "\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\"

*+--------------------------------------------------------------------
*+
*+    Procedure FuncMSCFolder()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure prefuncmscfolder()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE FuncMSCFolder()

LOCAL aFolder  := GetWinMsc()
LOCAL a2List   := {}
LOCAL i, iMax
LOCAL aSort
LOCAL nCountry := HB_bitAND( GETKEYBOARDLAYOUT(), 0xFFFF )

   lActiveMain := .F.

   IF nCountry = 1031                                                 // German
      aSort := ASORT( aFolder,,, { | x, y | x[ 2 ] < y[ 2 ] } )
   ELSE
      aSort := ASORT( aFolder,,, { | x, y | x[ 3 ] < y[ 3 ] } )
   ENDIF

   ALTD()
   iMax := LEN( aSort )
   FOR i := 1 TO iMax
      IF nCountry = 1031                                              // German
         AADD( a2List, aSort[ i ] [ 2 ] )
      ELSE
         AADD( a2List, aSort[ i ] [ 3 ] )
      ENDIF
   NEXT
   //   a2List := ASORT(a2List,{|x,y| x < y })

   DEFINE WINDOW ListMSCFolder ;
              AT 348, 589 ;
              WIDTH 324 ;
              HEIGHT 755 ;
              TITLE "" ;
              ICON "A1MAIN" ;
              TOPMOST ;
              NOMINIMIZE ;
              NOMAXIMIZE ;
              NOSIZE ;
              BACKCOLOR SP_nColor1()

      DEFINE LISTBOX List_MSCFolder
         PARENT ListMSCFolder
         ROW 10
         COL 10
         WIDTH 300
         HEIGHT 700
         ITEMS a2List
         VALUE 1
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontLarge()
         TOOLTIP ""
         BACKCOLOR SP_nColor9( )
         FONTCOLOR SP_nColor10()
         ONDBLCLICK DoMyMSCAction( aSort )
         TABSTOP .T.
         VISIBLE .T.
         SORT .F.
         MULTISELECT .F.
         DRAGITEMS .F.
      END LISTBOX

   END WINDOW

   ON KEY ESCAPE OF ListMSCFolder ACTION ListMSCFolder.Release
   CENTER WINDOW ListMSCFolder
   ListMSCFolder.List_MSCFolder.setfocus()
   ACTIVATE WINDOW ListMSCFolder

   lActiveMain := .T.

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoMyMSCAction()
*+
*+    Called from ( fmtool.prg )   1 - procedure funcmscfolder()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoMyMSCAction( aFolder )

LOCAL nRow, cRet

   nRow := GetProperty( "ListMSCFolder", "List_MSCFolder", "Value" )
   IF EMPTY( nRow )
      ListMSCFolder.Release
      RETURN
   ENDIF

   ListMSCFolder.hide()
   cRet := TRIM( aFolder[ nRow ] [ 1 ] )
   SP_GetWahl( cRet )
   IF !EMPTY( cRet )
      RunWinMsc( cRet )
   ENDIF
   ListMSCFolder.Release
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure RunWinMsc()
*+
*+    Called from ( fmtool.prg )   1 - static procedure domymscaction()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE RunWinMsc( cAction )

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
            RUN ( "Shell32,Control_RunDLL " + cAction, cRoot + "\SYSTEM32\RUNDLL32.EXE", .T. )

         ELSEIF ".DLL" $ UPPER( cAction )
            // ???
            IF "HOTPLUG.EXE" $ UPPER( cAction )
               RUN ( "Shell32,Control_RunDLL " + cAction, cRoot + "\SYSTEM32\RUNDLL32.EXE", .T. )
            ELSE
               RUN ( "Shell32,Control_RunDLL " + cAction, cRoot + "\SYSTEM32\RUNDLL32.EXE", .T. )
            ENDIF

         ELSEIF ".MSC" $ UPPER( cAction )
            RUN ( "/C START " + cAction )

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
*+    Procedure ShowProperty()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE ShowProperty( nNo )

LOCAL cPath := ""
LOCAL cFile := ""
LOCAL cAttr := ""

   //    GetPathandFile( nNo, @cPath, @cFile, @cAttr )
   //    SHOW_FILEPROPERTIES( cPath, cFile, cAttr )
   //
   // RETURN
   //
   // STATIC PROCEDURE SHOW_FILEPROPERTIES( cPath, cFile , cAttr )
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

   //    DEFAULT cFile TO ""

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
*+    Procedure SendToDeskTop()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE SendToDeskTop( nNo )

LOCAL cUser       := GETENV( "USERPROFILE" )
LOCAL cStart      := cUser + "\Desktop\"
LOCAL cLinkTarget := ""
LOCAL cLinkFile   := ""
LOCAL cWorkingDir := C_GETSPECIALFOLDER( CSIDL_COMMON_DESKTOPDIRECTORY ) + "\"
LOCAL cDescr      := ""
LOCAL cPath       := ""
LOCAL cFile       := ""
LOCAL cAttr       := ""
LOCAL cCmdArgs

   GetPathandFile( nNo, @cPath, @cFile, @cAttr )

   // ** dazu ***

   cLinkTarget := cPath + cFile
   cLinkFile := cStart + FindName( cFile ) + ".lnk"
   cWorkingDir := cPath

   DXE_CreateLink( cLinkTarget, cLinkFile, cWorkingDir, cCmdArgs, cDescr )

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure SendToStartup()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE SendToStartup( nNo )

LOCAL cUser       := GETENV( "USERPROFILE" )
LOCAL cStart      := cUser + "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"
LOCAL cLinkTarget := ""
LOCAL cLinkFile   := ""
LOCAL cWorkingDir := ""
LOCAL cDescr      := ""
LOCAL cPath       := ""
LOCAL cFile       := ""
LOCAL cAttr       := ""
LOCAL cCmdArgs

   GetPathandFile( nNo, @cPath, @cFile, @cAttr )

   // ** dazu ***

   cLinkTarget := cPath + cFile
   cLinkFile := cStart + FindName( cFile ) + ".lnk"
   cWorkingDir := cPath

   DXE_CreateLink( cLinkTarget, cLinkFile, cWorkingDir, cCmdArgs, cDescr )

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function DXE_CreateLink()
*+
*+    Called from ( fmtool.prg )   1 - procedure sendtodesktop()
*+                                   1 - procedure sendtostartup()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION DXE_CreateLink( cLinkTarget, cLinkFile, cWorkingDir, cCmdArgs, cDescr, aHotKey, aIcon )

LOCAL lSuccess       := .F.
LOCAL nPosi          := 0
LOCAL cPath          := ""
LOCAL cFile          := ""
LOCAL cName          := ""
LOCAL oShell
LOCAL oFolder
LOCAL oStorageFolder
LOCAL oShellLink
LOCAL nHandle
LOCAL i, iMax
LOCAL nLoByte
LOCAL nHiByte

   DEFAULT cWorkingDir TO ""
   DEFAULT cCmdArgs TO ""
   DEFAULT cDescr TO ""
   DEFAULT aHotKey TO {}
   DEFAULT aIcon TO {}

   IF !EMPTY( cLinkTarget )
      nPosi := RAT( "\", cLinkFile )
      IF nPosi > 0
         cPath := SUBSTR( cLinkFile, 1, nPosi - 1 )
         cFile := SUBSTR( cLinkFile, nPosi + 1 )
      ENDIF

      // create empty file with 0 (zero) byte
      nHandle := FCREATE( cLinkFile, FC_NORMAL )
      FCLOSE( nHandle )
   ENDIF

   IF !EMPTY( cPath ) .AND. !EMPTY( cFile ) .AND. FILE( cLinkFile )
      oShell := CreateObject( "shell.application" )
      oFolder := oShell:NameSpace( cPath )
      oStorageFolder := oFolder:ParseName( cFile )

      IF !EMPTY( oStorageFolder )
         oShellLink := oStorageFolder:GetLink
         IF !EMPTY( oShellLink )
            // set Property
            oShellLink:Path := cLinkTarget
            oShellLink:WorkingDirectory := cWorkingDir
            oShellLink:Arguments := cCmdArgs
            oShellLink:Description := cDescr
            oShellLink:ShowCommand := 1

            // Shortcut Hotkey
            IF !EMPTY( aHotKey ) .AND. VALTYPE( aHotKey ) = "A"
               IF LEN( aHotKey ) = 2
                  nLoByte := aHotKey[ 1 ]
                  nHiByte := aHotKey[ 2 ]
                  //  oShellLink:Hotkey := MakeWord( nLoByte , nHiByte )
               ENDIF
            ENDIF

            // Icon need Method
            IF !EMPTY( aIcon ) .AND. VALTYPE( aIcon ) = "A"
               IF LEN( aIcon ) = 2
                  oShellLink:SetIconLocation( aIcon[ 1 ], aIcon[ 2 ] )
               ENDIF
            ENDIF

            // now save
            oShellLink:Save( cLinkFile )

            lSuccess := .T.
         ENDIF
      ENDIF

      //       IF !EMPTY(oShellLink)
      //          oShellLink  :destroy()
      //       ENDIF
      //       IF !EMPTY(oStorageFolder)
      //          oStorageFolder :destroy()
      //       ENDIF
      //       IF !EMPTY(oFolder)
      //          oFolder     :destroy()
      //       ENDIF
      //        IF !EMPTY(oShell)
      //           oShell      :destroy()
      //        ENDIF

      oShellLink := NIL
      oStorageFolder := NIL
      oFolder := NIL
      oShell := NIL

   ENDIF

RETURN lSuccess

*+--------------------------------------------------------------------
*+
*+    Function DXE_ResolveLink()
*+
*+    Called from ( fm_func.prg )   1 - procedure runbyextension()
*+
*+--------------------------------------------------------------------
*+
FUNCTION DXE_ResolveLink( cFull )

LOCAL oShell
LOCAL oFolder
LOCAL oStorageFolder
LOCAL oShellLink
LOCAL cPath          := ""
LOCAL cItem          := ""
LOCAL nPosi          := 0
LOCAL cTarget        := ""
LOCAL cPara          := ""

   IF !EMPTY( cFull )
      nPosi := RAT( "\", cFull )
      IF nPosi > 0
         cPath := SUBSTR( cFull, 1, nPosi )
         cItem := SUBSTR( cFull, nPosi + 1 )

         oShell := CreateObject( "shell.application" )
         oFolder := oShell:NameSpace( cPath )
         oStorageFolder := oFolder:ParseName( cItem )

         IF !EMPTY( oStorageFolder )
            oShellLink := oStorageFolder:GetLink
            IF !EMPTY( oShellLink )
               cTarget := oShellLink:Path
               cPara := oShellLink:Arguments
            ENDIF
         ENDIF

         // IF !EMPTY(oStorageFolder)
         //    oStorageFolder :destroy()
         // ENDIF
         // IF !EMPTY(oFolder)
         //    oFolder     :destroy()
         // ENDIF
         // IF !EMPTY(oShell)
         //    oShell      :destroy()
         // ENDIF

         oStorageFolder := NIL
         oFolder := NIL
         oShell := NIL
      ENDIF
   ENDIF

RETURN cTarget + IF( EMPTY( cPara ), "", CHR( 0 ) + cPara )

*+--------------------------------------------------------------------
*+
*+    Function Userfolder()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Userfolder( cNewPath )

LOCAL i, iMax, nLen
LOCAL cPath, nCSIDL, nPosi, cStrip
LOCAL cRet    := ""
LOCAL aFolder := WinSysFolder()
LOCAL aPath   := {}
LOCAL cUser   := GETENV( "USERPROFILE" )

   iMax := LEN( aFolder )
   FOR i := 1 TO iMax
      nCSIDL := cRet := aFolder[ i ] [ 4 ]
      cPath := C_GETSPECIALFOLDER( cRet )
      //      cNewFolder := GetLongFileName( cShortName, lPath ) + "\"
      AADD( aPath, { UPPER( TRIM( cPath ) ), nCSIDL } )
   NEXT

   cStrip := STRTRAN( cNewPath, cUser, "" )
   cStrip := UPPER( SUBSTR( cStrip, 1, 4 ) )
   IF cStrip = "\DOK"
      cStrip := "\DOC"
   ENDIF
   nLen := LEN( cUser ) + LEN( cStrip )

   nPosi := ASCAN( aPath, { | e | SUBSTR( e[ 1 ], 1, nLen ) = UPPER( cUser + cStrip ) } )
   IF nPosi > 0
      cNewPath := aPath[ nPosi ] [ 1 ]
   ENDIF
RETURN cPath

*+ EOF: FMTOOL.PRG
