*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\HBFM.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Init Procedure MainInit()
*+               Function Main()
*+               Static Function LoadSetup()
*+               Static Function C_FMSETUP()
*+               Static Procedure CheckDBFversion()
*+               Static Procedure DoShowBug()
*+
*+       Tables: USE (cAppData+"\"+cFile) VIA "DBFCDX" EXCLUSIVE
*+               USE (cAppData+"\"+cFile) VIA "DBFCDX" EXCLUSIVE
*+               USE (cAppData+"\"+cFile) VIA "DBFCDX" EXCLUSIVE
*+
*+    Reformatted by Click! 2.05.30 on Aug-28-2020 at  1:52 am
*+
*+--------------------------------------------------------------------

#include "HMG.CH"
#include "hbdyn.ch"

REQUEST DBFCDX
REQUEST DBFNTX

REQUEST HB_LANG_ES
REQUEST HB_LANG_EN
REQUEST HB_LANG_FR
REQUEST HB_LANG_PT
REQUEST HB_LANG_DEWIN
REQUEST HB_LANG_RUWIN
REQUEST HB_LANG_IT
REQUEST HB_LANG_PLWIN
REQUEST HB_LANG_EU
REQUEST HB_LANG_HR852
REQUEST HB_LANG_SLWIN
REQUEST HB_LANG_CSWIN

REQUEST HB_CODEPAGE_ESWIN
REQUEST HB_CODEPAGE_BGWIN
REQUEST HB_CODEPAGE_DEWIN
REQUEST HB_CODEPAGE_ELWIN
REQUEST HB_CODEPAGE_HUWIN
REQUEST HB_CODEPAGE_PLWIN
REQUEST HB_CODEPAGE_PT850
REQUEST HB_CODEPAGE_RU1251
REQUEST HB_CODEPAGE_SRWIN
REQUEST HB_CODEPAGE_SLWIN

STATIC cVersion     := "v1.18"
MEMVAR _HMG_SYSDATA

*+--------------------------------------------------------------------
*+
*+    Init Procedure MainInit()
*+
*+--------------------------------------------------------------------
*+
INIT PROCEDURE MainInit()

   // better than :  SET MULTIPLE OFF WARNING
LOCAL cTitle  := 'HBFM ' + cVersion
LOCAL hWndDlg := FindWindowEx(,,, cTitle )
   IF !( hWndDlg == 0 )
      SetForegroundWindow( hWndDlg )
      BringWindowToTop( hWndDlg )
      ShowWindow( hWndDlg, 1 )
      UpdateWindow( hWndDlg )
      QUIT                                                            // It is a second instance. Bye Bye
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Function Main()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Main

LOCAL i, iMax := PCOUNT()
LOCAL aPara    := {}
LOCAL aPos     := { 0, 0 }
LOCAL aSize    := { 0, 0 }
LOCAL nCountry := HB_bitAND( GETKEYBOARDLAYOUT(), 0xFFFF )
LOCAL xValue, cPara, luseParameter := .F.
LOCAL cAppData := GETENV( "APPDATA" ) + "\HMG"
LOCAL cFile    := "FMSETUP.DBF"

   IF !hb_mtvm()
      MSGSTOP( "There is no support for multi-threading" )
      QUIT
   ENDIF

   SET MULTIPLE OFF                                                   // only 1 Instance
   SET BROWSESYNC ON                                                  // sync BROWSE with DBF ?
   SET AUTOSCROLL ON                                                  // virtual dimensioned windows scrollbars
   //    SET NAVIGATION EXTENDED                                      // ENTER -> TAB

   SET EPOCH TO YEAR( DATE() ) - 50
   SET CENTURY ON

   IF nCountry = 1031
      SET LANGUAGE TO GERMAN
      SET CODEPAGE TO GERMAN
      SET DATE GERMAN
   ELSE
      SET LANGUAGE TO ENGLISH
      SET CODEPAGE TO ENGLISH
      SET DATE AMERICAN
   ENDIF

   IF !isdir( cAppData )
      DIRMAKE( cAppData )
   ENDIF

   // init SP_* Stack
   SP_INIT()

   LoadSetup( aPos, aSize, cAppData )

   FOR i := 1 TO iMax
      xValue := UPPER( PValue( i ) )
      AADD( aPara, xValue )
      luseParameter := .T.

      DO CASE
         CASE SUBSTR( xValue, 1, 2 ) = "/L"
            cPara := EndwithSlash( SUBSTR( xValue, 3 ) )
            IF "#" $ cPara
               MoreParaLeft( cPara )
            ELSE
               SP_LWTextLeft( cPara )
            ENDIF

         CASE SUBSTR( xValue, 1, 2 ) = "/R"
            cPara := EndwithSlash( SUBSTR( xValue, 3 ) )
            IF "#" $ cPara
               MoreParaRight( cPara )
            ELSE
               SP_LWTextRight( cPara )
            ENDIF

            // ***************************************************
            // CASE SUBSTR( xValue, 1, 2 ) = "/M"
            //    cPara := SUBSTR( xValue, 3 )
            //    IF VAL( cPara ) > 1
            //       lOneMonitor := .F.
            //    ENDIF
            //
            // CASE SUBSTR( xValue, 1, 2 ) = "/T"
            //    SP_lCheckView( .T. )
            //
            // ***************************************************
      ENDCASE
   NEXT

   //  DoShowBug()

   IF FILE( 'FreeImage.Dll' ) .OR. FILE( 'FreeImage64.Dll' )
      SP_lFreeImage( .T. )
   ENDIF

   // CreateScreenSplash( "DualGrid", aPos, aSize, cVersion, luseParameter )
   DualGrid( aPos, aSize, cVersion, luseParameter )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Static Function LoadSetup()
*+
*+    Called from ( hbfm.prg )   1 - function main()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION LoadSetup( aPos, aSize, cAppData )

LOCAL cFile   := "FMSETUP.DBF"
LOCAL aColPos := {}

   CheckDBFversion( cAppData, cFile )
   IF !FILE( cAppData + "\" + cFile )
      C_FMSETUP( cAppData, cFile )
   ENDIF

   USE (cAppData+"\"+cFile) VIA "DBFCDX" EXCLUSIVE
   aPos[ 1 ] := FMSETUP->XPOS
   aPos[ 2 ] := FMSETUP->YPOS
   aSize[ 1 ] := FMSETUP->XSIZE
   aSize[ 2 ] := FMSETUP->YSIZE
   IF aPos[ 1 ] < 0
      aPos[ 1 ] := 0
   ENDIF
   IF aPos[ 2 ] < 0
      aPos[ 2 ] := 0
   ENDIF

   // fill Stack function

   aColPos := {}
   AADD( aColPos, FMSETUP->LWLCOL1 )
   AADD( aColPos, FMSETUP->LWLCOL2 )
   AADD( aColPos, FMSETUP->LWLCOL3 )
   AADD( aColPos, FMSETUP->LWLCOL4 )
   AADD( aColPos, FMSETUP->LWLCOL5 )
   // AADD( aColPos, FMSETUP->LWLCOL6 )
   SP_aColLeft( ACLONE( aColPos ) )

   aColPos := {}
   AADD( aColPos, FMSETUP->LWRCOL1 )
   AADD( aColPos, FMSETUP->LWRCOL2 )
   AADD( aColPos, FMSETUP->LWRCOL3 )
   AADD( aColPos, FMSETUP->LWRCOL4 )
   AADD( aColPos, FMSETUP->LWRCOL5 )
   // AADD( aColPos, FMSETUP->LWRCOL6 )
   SP_aColRight( ACLONE( aColPos ) )

   SP_LWTextLeft( TRIM( FMSETUP->LWLPATH ) )
   SP_LWTextRight( TRIM( FMSETUP->LWRPATH ) )

   SP_nColor1( NumColor2RGB( FMSETUP->COLOR1 ) )
   SP_nColor2( NumColor2RGB( FMSETUP->COLOR2 ) )
   SP_nColor3( NumColor2RGB( FMSETUP->COLOR3 ) )
   SP_nColor4( NumColor2RGB( FMSETUP->COLOR4 ) )
   SP_nColor5( NumColor2RGB( FMSETUP->COLOR5 ) )
   SP_nColor6( NumColor2RGB( FMSETUP->COLOR6 ) )
   SP_nColor7( NumColor2RGB( FMSETUP->COLOR7 ) )
   SP_nColor8( NumColor2RGB( FMSETUP->COLOR8 ) )
   SP_nColor9( NumColor2RGB( FMSETUP->COLOR9 ) )
   SP_nColor10( NumColor2RGB( FMSETUP->COLOR10 ) )
   SP_nColor11( NumColor2RGB( FMSETUP->COLOR11 ) )
   SP_nColor12( NumColor2RGB( FMSETUP->COLOR12 ) )
   SP_nColor13( NumColor2RGB( FMSETUP->COLOR13 ) )
   SP_nColor14( NumColor2RGB( FMSETUP->COLOR14 ) )

   SP_DarkMode( FMSETUP->DARKMODE )
   SP_lColResize( FMSETUP->COLRESIZE )
   SP_UseImage( FMSETUP->USEIMAGE )

   SP_cFontName( TRIM( FMSETUP->FONTNAME ) )
   SP_nFontSize( FMSETUP->FONTSIZE )
   SP_nFontlarge( FMSETUP->FONTHEIGH )
   SP_nFontsmall( FMSETUP->FONTWIDTH )

   SP_TabLeft( HB_Deserialize( FMSETUP->TabLeft ) )
   SP_TabRight( HB_Deserialize( FMSETUP->TabRight ) )

   SP_ViewLeft( FMSETUP->LWLVIEW )
   SP_ViewRight( FMSETUP->LWRVIEW )

   SP_nWinTans( Fmsetup->WINTANS )

   CLOSE

RETURN nil

*+--------------------------------------------------------------------
*+
*+    Static Function C_FMSETUP()
*+
*+    Called from ( hbfm.prg )   1 - static function loadsetup()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION C_FMSETUP( cAppData, cFile, alias, id )

LOCAL p, field_list := {}
   IF VALTYPE( cFile ) != "C"
      cFile = "FMSETUP.DBF"
   ENDIF
   IF VALTYPE( alias ) != "C"
      p = AT( ".", cFile )
      alias = IF( p > 0, SUBSTR( cFile, 1, p - 1 ), cFile )
   ENDIF
   IF VALTYPE( id ) != "N"
      id = 0
   ENDIF
   SELECT ( id )

   IF !FILE( cAppData + "\" + cFile )
      AADD( field_list, { "XPOS", "N", 4, 0 } )
      AADD( field_list, { "YPOS", "N", 4, 0 } )
      AADD( field_list, { "XSIZE", "N", 4, 0 } )
      AADD( field_list, { "YSIZE", "N", 4, 0 } )
      AADD( field_list, { "LWNO", "N", 1, 0 } )
      AADD( field_list, { "PROZ", "N", 5, 2 } )
      AADD( field_list, { "LWLSORT", "N", 1, 0 } )
      AADD( field_list, { "LWRSORT", "N", 1, 0 } )
      AADD( field_list, { "LWLVIEW", "N", 1, 0 } )
      AADD( field_list, { "LWRVIEW", "N", 1, 0 } )
      //       AADD( field_list, { "THUMBHIGH", "N", 3, 0 } )
      //       AADD( field_list, { "THUMBWIDE", "N", 3, 0 } )
      AADD( field_list, { "SKINPATH", "C", 250, 0 } )
      AADD( field_list, { "LWLPATH", "C", 250, 0 } )
      AADD( field_list, { "LWRPATH", "C", 250, 0 } )
      AADD( field_list, { "EDITTEXT", "C", 250, 0 } )
      AADD( field_list, { "EDITDBF", "C", 250, 0 } )
      AADD( field_list, { "FONTNAME", "C", 50, 0 } )
      AADD( field_list, { "FONTHEIGH", "N", 10, 0 } )
      AADD( field_list, { "FONTWIDTH", "N", 10, 0 } )
      AADD( field_list, { "FONTSIZE", "N", 10, 0 } )
      AADD( field_list, { "LWLCOL1", "N", 4, 0 } )
      AADD( field_list, { "LWLCOL2", "N", 4, 0 } )
      AADD( field_list, { "LWLCOL3", "N", 4, 0 } )
      AADD( field_list, { "LWLCOL4", "N", 4, 0 } )
      AADD( field_list, { "LWLCOL5", "N", 4, 0 } )
      AADD( field_list, { "LWLCOL6", "N", 4, 0 } )
      AADD( field_list, { "LWRCOL1", "N", 4, 0 } )
      AADD( field_list, { "LWRCOL2", "N", 4, 0 } )
      AADD( field_list, { "LWRCOL3", "N", 4, 0 } )
      AADD( field_list, { "LWRCOL4", "N", 4, 0 } )
      AADD( field_list, { "LWRCOL5", "N", 4, 0 } )
      AADD( field_list, { "LWRCOL6", "N", 4, 0 } )
      AADD( field_list, { "COLOR1", "N", 9, 0 } )
      AADD( field_list, { "COLOR2", "N", 9, 0 } )
      AADD( field_list, { "COLOR3", "N", 9, 0 } )
      AADD( field_list, { "COLOR4", "N", 9, 0 } )
      AADD( field_list, { "COLOR5", "N", 9, 0 } )
      AADD( field_list, { "COLOR6", "N", 9, 0 } )
      AADD( field_list, { "COLOR7", "N", 9, 0 } )
      AADD( field_list, { "COLOR8", "N", 9, 0 } )
      AADD( field_list, { "COLOR9", "N", 9, 0 } )
      AADD( field_list, { "COLOR10", "N", 9, 0 } )
      AADD( field_list, { "COLOR11", "N", 9, 0 } )
      AADD( field_list, { "COLOR12", "N", 9, 0 } )
      AADD( field_list, { "COLOR13", "N", 9, 0 } )
      AADD( field_list, { "COLOR14", "N", 9, 0 } )
      AADD( field_list, { "DARKMODE", "L", 1, 0 } )
      //       AADD( field_list, { "LASTLEFT", "N", 2, 0 } )
      //       AADD( field_list, { "LASTRIGHT", "N", 2, 0 } )
      AADD( field_list, { "USEIMAGE", "L", 1, 0 } )
      AADD( field_list, { "COLRESIZE", "L", 1, 0 } )
      AADD( field_list, { "WINTANS", "N", 3, 0 } )
      AADD( field_list, { "TABLEFT", "V", 10, 0 } )
      AADD( field_list, { "TABRIGHT", "V", 10, 0 } )

      DBCREATE( cAppData + "\" + cFile, field_list, "DBFCDX" )
   ENDIF

   USE (cAppData+"\"+cFile) VIA "DBFCDX" EXCLUSIVE
   IF FILE( "OLDSETUP.DBF" )
      APPEND FROM ( "OLDSETUP.DBF" ) VIA "DBFCDX"
      REPLACE WINTANS WITH 255
   ELSE

      APPEND BLANK
      REPLACE XPOS WITH 0
      REPLACE YPOS WITH 0
      REPLACE XSIZE WITH 1280
      REPLACE YSIZE WITH 1024
      REPLACE LWNO WITH 2
      REPLACE PROZ WITH 50

      REPLACE LWLSORT WITH 1
      REPLACE LWRSORT WITH 1

      REPLACE LWLVIEW WITH 1
      REPLACE LWRVIEW WITH 1

      REPLACE EDITTEXT WITH "NOTEPAD.EXE"
      REPLACE EDITDBF WITH "DBU.EXE"

      REPLACE FONTNAME WITH "ARIAL"
      REPLACE FONTHEIGH WITH 11
      REPLACE FONTWIDTH WITH 9
      REPLACE FONTSIZE WITH 10

      REPLACE LWLCOL1 WITH 310
      REPLACE LWLCOL2 WITH 80
      REPLACE LWLCOL3 WITH 84
      REPLACE LWLCOL4 WITH 68
      REPLACE LWLCOL5 WITH 60
      REPLACE LWLCOL6 WITH 20

      REPLACE LWRCOL1 WITH 310
      REPLACE LWRCOL2 WITH 80
      REPLACE LWRCOL3 WITH 84
      REPLACE LWRCOL4 WITH 68
      REPLACE LWRCOL5 WITH 60
      REPLACE LWRCOL6 WITH 20

      REPLACE LWLPATH WITH "C:\"
      REPLACE LWRPATH WITH "C:\"

      REPLACE COLOR1 WITH RGB2Num( SP_nColor1() )
      REPLACE COLOR2 WITH RGB2Num( SP_nColor2() )
      REPLACE COLOR3 WITH RGB2Num( SP_nColor3() )
      REPLACE COLOR4 WITH RGB2Num( SP_nColor4() )
      REPLACE COLOR5 WITH RGB2Num( SP_nColor5() )
      REPLACE COLOR6 WITH RGB2Num( SP_nColor6() )
      REPLACE COLOR7 WITH RGB2Num( SP_nColor7() )
      REPLACE COLOR8 WITH RGB2Num( SP_nColor8() )
      REPLACE COLOR9 WITH RGB2Num( SP_nColor9() )
      REPLACE COLOR10 WITH RGB2Num( SP_nColor10() )
      REPLACE COLOR11 WITH RGB2Num( SP_nColor11() )
      REPLACE COLOR12 WITH RGB2Num( SP_nColor12() )
      REPLACE COLOR13 WITH RGB2Num( SP_nColor13() )
      REPLACE COLOR14 WITH RGB2Num( SP_nColor14() )

      REPLACE DARKMODE WITH .F.
      REPLACE COLRESIZE WITH .F.
      REPLACE USEIMAGE WITH .T.
      REPLACE WINTANS WITH 255

   ENDIF

   COMMIT
   CLOSE

   IF FILE( "OLDSETUP.DBF" )
      hb_idleSleep( 1.0 )
      FERASE( "OLDSETUP.DBF" )
      FERASE( "OLDSETUP.FPT" )
   ENDIF

RETURN ( .t. )

*+--------------------------------------------------------------------
*+
*+    Static Procedure CheckDBFversion()
*+
*+    Called from ( hbfm.prg )   1 - static function loadsetup()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE CheckDBFversion( cAppData, cFile )

LOCAL aStructure

   IF FILE( cAppData + "\" + cFile )
      USE (cAppData+"\"+cFile) VIA "DBFCDX" EXCLUSIVE
      aStructure := DBSTRUCT()
      CLOSE ALL
      IF LEN( aStructure ) <> 51
         IF FILE( "OLDSETUP.DBF" )
            FERASE( "OLDSETUP.DBF" )
            FERASE( "OLDSETUP.FPT" )
         ENDIF
         hb_idleSleep( 1.0 )
         RENAME( cAppData + "\" + "FMSETUP.DBF" ) TO ( "OLDSETUP.DBF" )
         RENAME( cAppData + "\" + "FMSETUP.FPT" ) TO ( "OLDSETUP.FPT" )
      ENDIF
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoShowBug()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoShowBug()

LOCAL aDir := DIRECTORY( "C:\*.SYS", "D" )
LOCAL nLen := LEN( aDir )

   msgInfo( LTRIM( STR( nLen ) ) + " Items" )

RETURN

// ***************************************************************
//  v.1.18 27.08.2020 BUG : Thumbs virtual height / HBFTP
//  v.1.17 24.08.2020 GETICOINDEX() instead of BT_DirectoryInfo()
//  v.1.16 23.08.2020 BT_DirectoryInfo() without Thread.
//  v.1.15 17.08.2020 XLSX -> Export -> DBF
//  v.1.14 15.08.2020 Inactive Windows Transparancy / Setup / new FIELD
//  v.1.13 13.08.2020 FMREGDB.PRG 3th. Parameter wrong (  CURDIR() )
//  v.1.12 05.08.2020 HbFTP : Error new Site or when connect from Detail
//  v.1.11 01.08.2020 ADO write XLSx with INSERT INTO Excel Date
//
//  v.1.10 31.07.2020 ADO write XLSx with RecordSet
//  v.1.09 27.07.2020 HbFTP : AppFolder() -> cPath+"Sites.DBF"
//  v.1.08 25.07.2020 DBF Browse : Append / Delete -> Statusbar
//                    Thumbs full Screen
//  v.1.07 10.07.2020 include HbFTP (incl 64 Bit)
//  v.1.06 07.07.2020 cleanup HB_FUNC for 64 Bit
//  v.1.05 01.07.2020 FreeImage -> Thumbs -> Pop-Up Menu -> rotate
//
//  v.1.04 20.06.2020 try using FreeImage.DLL without Import LIB
//  v.1.03 10.06.2020 fix WatchDirLeft() / WatchDirRight() empty Path
//  v.1.02 03.06.2020 HbFilter more validation
//  v.1.01 02.06.2020 HbFilter
//
//  v.1.00 29.05.2020 INIT PROC before MAIN
//  v.0.99 27.05.2020 Export : DBF, XLSx, SDF
//  v.0.98 26.05.2020 PickList()
//  v.0.97 24.05.2020 working DirWatch ... FILE_NOTIFY_CHANGE_FILE_NAME -> FILE_NOTIFY_CHANGE_NAME
//  v.0.96 21.05.2020 Problem with (many) DirWatch and TAB > 1 - aWatchThread
//  v.0.95 17.05.2020 search in ZIP
//  v.0.94 15.05.2020 NetConnect()
//  v.0.93 10.05.2020 without FreeImage.DLL
//  v.0.92 08.05.2020 Thumbs using FREE_Save() 2 x faster than BT function
//  v.0.91 07.05.2020 Thumbs using FreeImage.DLL
//  v.0.90 06.05.2020 Thumbs using MouseWheel
//  v.0.89 04.05.2020 try FreeImage.DLL
//
//  v.0.88 25.04.2020 fixed Thumbs STRZERO(n,3) -> STRZERO(n,5), sort Name
//  v.0.87 21.04.2020 ALT-F5 ZIP ( COMPRESS )
//  v.0.86 18.04.2020 VK_MULTIPLY : reverse selection
//  v.0.85 17.04.2020 ALT-F7 search in File
//  v.0.84 15.04.2020 Splash Intro
//  v.0.83 16.04.2020 DirWatch ( wapi_WaitForSingleObject )
//
//  v.0.82 14.04.2020 COPYHERE() or MOVEHERE() limited to Device only
//  v.0.81 14.04.2020 Progressbar (in Titlebar) while loading Thumbs
//  v.0.80 13.04.2020 Thumbs-Select-Grid
//  v.0.79 12.04.2020 Thumbs-Progressbar-Thread
//  v.0.78 11.04.2020 Phone2.PRG, THUMBS.PRG
//
//  v.0.77 29.03.2020 IPHONE GetDevicePath()
//  v.0.76 27.03.2020 Slideshow() , SetLV_View()
//  v.0.75 25.03.2020 ON MOUSEMOVE / ON MOUSEDRAG on wrong Parent
//  v.0.74 22.03.2020 BT_DirectoryInfo() with Thread. Add MenuItem : Attribut
//  v.0.73 21.03.2020 BT_DirectoryInfo() working
//  v.0.72 21.03.2020 ALT-F7 TextBox Path + Mask
//  v.0.71 20.03.2020 ALT-F7 "normal" recursiv
//  v.0.70 17.03.2020 FindAndCloseProcress(), ChangeFAttr()
//  v.0.69 17.03.2020 OSK.EXE
//  v.0.68 13.03.2020 run with Parameter
//  v.0.67 11.03.2020 RunByExtsion() with *.LNK
//            multi Tab OK ?
//  v.0.66 01.03.2020 ItemMark ala HMG
//
//  v.0.65 29.02.2020
//  v.0.64 28.02.2020 more Icons
//  v.0.63 28.02.2020 Grid with Image
//  v.0.62 28.02.2020 Codepage
//  v.0.61 26.02.2020 Close Tab 2 of 3 and add TAB 3 OK
//  v.0.60 26.02.2020 HBINPUT.PRG
//  v.0.59 25.02.2020 Fx-Key using Stack, F9 History (aBack_* Array)
//  v.0.58 25.02.2020 BROWSE -> GRID
//  v.0.57 24.02.2020 OEM Problem ... Byte 30 nicht 850 ?
//  v.0.56 24.02.2020 multi Browser F6 / F7 / F9 und F1 Info
//  v.0.55 23.02.2020 multi Browser WITHOUT Thread
//  v.0.54 23.02.2020 Sumatra PDF ohne SET_COMPILE_HMG_UNICODE
//  v.0.53 22.02.2020 Sumatra PDF
//  v.0.52 22.02.2020 multi Browser with Thread und Macro
//  v.0.51 22.02.2020 all transfer frim MAIN to FMGrid.PRG
//  v.0.50 21.02.2020 SP_xFont()
//  v.0.49 20.02.2020 "DELETE" right side fixed
//  v.0.48 20.02.2020 Context Menu add sort, tree
//  v.0.47 20.02.2020 CMDBox working
//  v.0.46 20.02.2020 FMSETUP : COLRESIZE
//  v.0.45 19.02.2020 PathInfo, CMDBox, GridGotFocus, RootUpDirPath()
//  v.0.44 19.02.2020 BUG aStart "unmark"
//  v.0.43 19.02.2020 hbmk.hbm : -w3 -es2
//  v.0.42a
//  v.0.42 18.02.2020 Release
//  v.0.41 17.02.2020 Verbs SHOW_FILEPROPERTIES()
//  v.0.40 15.02.2020 FMREGDB.PRG
//  v.0.39 15.02.2020 DoReSizeMain() auf 214 mit Grid_XX Name
//  v.0.38 14.02.2020 Tab-Grid-Control.Release
//  v.0.37 13.02.2020 Context Menu mit "MY_BMP" Resourcen !
//  v.0.36 12.02.2020 ErrorSys ADD o:Args / UpDirPath() und RootUpDirPath()
//  v.0.35 11.02.2020 Setup Fehler Color1 ( war ein Array )
//  v.0.34 11.02.2020 Everyhing
//  v.0.33 10.02.2020 USB_Detect() funktioniert
//  v.0.32 03.02.2020 SET INDEX TO &cIndex ADDITIVE
//   search DoGridKey1/2
//  v.0.31 02.02.2020 Scope
//  v.0.30 02.02.2020 Index SEEK
//  v.0.29 02.02.2020 Viewer TXT, RTF, Image
//  v.0.28 02.02.2020 SP_Color aktiv
//  v.0.27 01.02.2020 FMSETUP.PRG mot GetColor() "Dialog"
//
//  v.0.26 31.01.2020 FMCOLOR.PRG / SP_Color Function aber noch nicht aktive
//  v.0.25 31.01.2020 DBF Browse EditDetail()
//  v.0.24 30.01.2020 Re-Size with "ChangeFontSize" / LISTVIEW_SETCOLUMNWIDTH()
//  v.0.23 30.01.2020 always VIRTUAL
//  v.0.22 30.01.2020 CRTL-U change left / right GRID
//   F3-F4 BROWSE
//   FMSETUP / SP_ Function
//  v.0.21 29.01.2020 FMTOOL.PRG : F2 Sysfolder , F12 MSC / CPL Folder
//  v.0.20 28.01.2020 AUSWAHL()
//  v.0.19 28.01.2020 CheckOtherSide()
//  v.0.18 28.01.2020 CompareDir()
//  v.0.17 27.01.2020 multi TAB with Problem TAB > 1
//  v.0.14 26.01.2020 Use_Virtual
//  v.0.13 26.01.2020 TAB multi l„uft ... aber > 1 x TAB ...
//  v.0.11 25.01.2020 Header-Sort; AddTab ...
//  v.0.10 23.01.2020 Alpha 1 Release F5 F7 F8 - DragDrop
// ***************************************************************

*+ EOF: HBFM.PRG
