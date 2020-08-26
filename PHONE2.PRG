*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\PHONE2.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Procedure GetDevicePath()
*+               Static Procedure GetTargetFolder()
*+               Static Procedure DoTreeAction()
*+               Static Procedure ShowItemInfo()
*+               Static Procedure BuildRoot()
*+               Static Procedure SearchDevice()
*+               Static Procedure SelectDevice()
*+               Static Procedure DoTreeRecursiv()
*+               Static Procedure ShowGrid()
*+               Static Procedure Start_CopyHere()
*+               Static Procedure DoCopyHere()
*+               Static Procedure DoCopySingle()
*+               Static Function CalcPos()
*+               Static Procedure PhoneTHUMBS()
*+               Static Procedure do_logfile()
*+               Static Function IsRealDrive()
*+
*+    Reformatted by Click! 2.05.30 on Aug-25-2020 at  5:17 am
*+
*+--------------------------------------------------------------------

#include "HMG.CH"
#include "Common.CH"

#define FOF_SIMPLEPROGRESS             0x0100a
#define LVIS_FOCUSED                   0x1
#define LVIS_SELECTED                  0x2

#DEFINE IMAGE_FOLDER_UNCHECKED         0
#DEFINE IMAGE_FOLDER_CHECKED           2
#DEFINE IMAGE_DOCUMENT_UNCHECKED       2
#DEFINE IMAGE_DOCUMENT_CHECKED         5

#define ID_Folder                      1
#define ID_Name                        2
#define ID_Level                       3
#define ID_Parent                      4
#define ID_Element                     5

STATIC nLevel   := 0
STATIC nElement := 1
STATIC aDevices := {}
STATIC aFolder  := {}
STATIC aFileSys := {}

// ***********************************************************
//
//  07.04.2020   v0.14 Start_CopyHere(), Parameter lTransfer instead of PUBLIC
//  06.04.2020   v0.13 now working with Child and Parent
//  05.04.2020   v0.10
//
// ***********************************************************

MEMVAR oShell, oFolder, oFolderItem
MEMVAR aGridfiles, _HMG_SYSDATA

// PROCEDURE MAIN

*+--------------------------------------------------------------------
*+
*+    Procedure GetDevicePath()
*+
*+    Called from ( fmgrid.prg )   1 - static procedure dodevice()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE GetDevicePath( cTarget )

LOCAL cPhone := "Apple iPhone"

PUBLIC oShell, oFolder, oFolderItem
PUBLIC aGridfiles   := {}
PUBLIC _HMG_SYSDATA

   //    SET DATE GERMAN
   //    SET EPOCH TO YEAR( DATE() )
   //    SET CENTURY ON
   //    MAIN ;

   DEFINE WINDOW IPHONE ;
              AT 0, 0 ;
              WIDTH 1024 ;
              HEIGHT 768 ;
              TITLE "Device " ;
              ICON "A1MAIN" ;
              NOSIZE ;
              NOMAXIMIZE ;
              NOMINIMIZE ;
              BACKCOLOR SP_nColor1() ;
              ON INIT BuildRoot()

      //              ON RELEASE do_logfile()

      DEFINE STATUSBAR FONT "Arial" SIZE 9
STATUSITEM "" WIDTH 100
         KEYBOARD WIDTH 100
         DATE WIDTH 100
         CLOCK WIDTH 100
      END STATUSBAR

      DEFINE TREE Tree_1 ;
                 AT 20, 10 ;
                 WIDTH 200 ;
                 HEIGHT 600 ;
                 VALUE 0 ;
                 FONT "Arial" ;
                 SIZE 9 ;
                 ON DBLCLICK DoTreeAction( This.Value ) ;
                 ON CHANGE ShowItemInfo( This.Value ) ;
                 NODEIMAGES { "MYFOLDER16", "MYEXE16" } ;
                 ITEMIMAGES { "MYFILE16", "MYFILE16" } ;
                 BACKCOLOR SP_nColor9() ;
                 FONTCOLOR SP_nColor10() ;
                 ITEMIDS
      END TREE

      DEFINE GRID Grid_1
         ROW 20
         COL 220
         WIDTH 780
         HEIGHT 600
         ITEMS {}
         VALUE Nil
         WIDTHS { 370, 80, 80, 30, 170, 50 }
         HEADERS { 'Name', 'Size', 'Date', 'Attr', 'Type', 'L' }
         FONTNAME "Arial"
         FONTSIZE 9
         DYNAMICBACKCOLOR Nil
         DYNAMICFORECOLOR Nil
         BACKCOLOR SP_nColor9( )
         FONTCOLOR SP_nColor10()
         SHOWHEADERS .T.
         CELLNAVIGATION .F.
      END GRID

      DEFINE BUTTON Button_Target
         ROW 624
         COL 10
         WIDTH 200
         HEIGHT 30
         ACTION GetTargetFolder()
         CAPTION "&Target Folder"
         FONTNAME "Arial"
         FONTSIZE 9
         TABSTOP .T.
         VISIBLE .T.
      END BUTTON

      DEFINE TEXTBOX TargetDir
         ROW 624
         COL 220
         WIDTH 780
         HEIGHT 30
         FONTNAME "Arial"
         FONTSIZE 9
         BACKCOLOR SP_nColor5()
         FONTCOLOR SP_nColor6()
         TABSTOP .T.
         VISIBLE .T.
         VALUE ""
      END TEXTBOX

      DEFINE BUTTON Button_CopyHere
         ROW 660
         COL 10
         WIDTH 100
         HEIGHT 30
         ACTION Start_CopyHere( .F. )
         CAPTION "&CopyHere"
         FONTNAME "Arial"
         FONTSIZE 9
         TABSTOP .T.
         VISIBLE .T.
      END BUTTON

      DEFINE BUTTON Button_MoveHere
         ROW 660
         COL 110
         WIDTH 100
         HEIGHT 30
         ACTION Start_CopyHere( .T. )
         CAPTION "&MoveHere"
         FONTNAME "Arial"
         FONTSIZE 9
         TABSTOP .T.
         VISIBLE .T.
      END BUTTON

      DEFINE PROGRESSBAR ProgressBar_1
         ROW 660
         COL 220
         WIDTH 780
         HEIGHT 30
         RANGEMIN 1
         RANGEMAX 100
         VALUE 0
         VISIBLE .T.
      END PROGRESSBAR

   END WINDOW

   IPHONE.ProgressBar_1.Value := 0
   IPHONE.Grid_1.CheckBoxEnabled := .T.
   IPHONE.TargetDir.Value := cTarget
   IPHONE.Button_CopyHere.hide()
   IPHONE.Button_MoveHere.hide()

   TBL_SETVALUE( ThisWindow.Handle, 0, 100 )

   ON KEY ESCAPE OF IPHONE ACTION IPHONE.Release
   ON KEY F9 OF IPHONE ACTION PhoneTHUMBS( ACLONE( aGridfiles ), "IPHONE", "ProgressBar_1" )

   CENTER WINDOW IPHONE
   IPHONE.Tree_1.setfocus()
   ACTIVATE WINDOW IPHONE

   oFolder := NIL
   oShell := NIL

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure GetTargetFolder()
*+
*+    Called from ( phone2.prg )   1 - procedure getdevicepath()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE GetTargetFolder()

LOCAL cFolder := GETFOLDER( "Get Target Folder", IPHONE.TargetDir.Value,, .T. )

   IF !EMPTY( cFolder )
      IPHONE.TargetDir.Value := cFolder + "\"
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoTreeAction()
*+
*+    Called from ( phone2.prg )   1 - procedure getdevicepath()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoTreeAction( nValue )

LOCAL cThis, nPosi, xValue, aValue, lisFileSys := .F.
LOCAL aSelect, xFolder, xName, xLevel, xParent, xElement
LOCAL nParent, aPath
   // LOCAL a2,a3,a4,a5

   xValue := IPHONE.Tree_1.CARGO( nValue )

   IF !EMPTY( xValue )
      cThis := IPHONE.Tree_1.CARGO( nValue ) [ 1 ]
      xLevel := IPHONE.Tree_1.CARGO( nValue ) [ 2 ]
      nLevel := xLevel

      nParent := IPHONE.Tree_1.ParentValue( nValue )

      aPath := IPHONE.Tree_1.GetPathValue( nValue )
      nPosi := ASCAN( aFileSys, { | e | e = aPath[ 2 ] } )
      ALTD()
      IF nPosi > 0
         // lisFileSys := IPHONE.Tree_1.CARGO( nValue ) [ 3 ]
         lisFileSys := .T.
      ELSE
         lisFileSys := .F.
      ENDIF

      //  a2 := IPHONE.Tree_1.ChildValue      ( nValue )
      //  a4 := IPHONE.Tree_1.GetPathName     ( nValue )
      //  a5 := IPHONE.Tree_1.GetDisplayLevel ( nValue )
   ENDIF

   Domethod( "IPHONE", "Grid_1", "DeleteAllItems" )
   aGridfiles := {}
   DO EVENTS

   DO CASE
      CASE nLevel = 0
         BuildRoot()
      CASE nLevel = 1
         SearchDevice()
      CASE nLevel = 2
         SelectDevice()

      OTHERWISE

         IF !EMPTY( aFolder ) .AND. !EMPTY( cThis )
            nPosi := ASCAN( aFolder, { | e | e[ ID_Name ] = UPPER( cThis ) .AND. e[ ID_Parent ] = nParent } )
            IF nPosi > 0
               aSelect := aFolder[ nPosi ]
               xFolder := aSelect[ ID_Folder ]
               xName := aSelect[ ID_Name ]
               xLevel := aSelect[ ID_Level ]
               xParent := aSelect[ ID_Parent ]
               xElement := aSelect[ ID_Element ]

               IPHONE.Button_CopyHere.hide()
               IPHONE.Button_MoveHere.hide()

               DoTreeRecursiv( xFolder, xLevel + 1, nValue, .F., .T., .F., .F., lisFileSys )
               ShowGrid( lisFileSys )
            ENDIF
         ENDIF
   ENDCASE
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure ShowItemInfo()
*+
*+    Called from ( phone2.prg )   1 - procedure getdevicepath()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ShowItemInfo( nValue )

LOCAL aPath := IPHONE.Tree_1.GetPathName( nValue )
LOCAL i, cText := ""
LOCAL iMax  := LEN( aPath )

   FOR i := 1 TO iMax
      cText += aPath[ i ]
      cText += "\"
   NEXT
   IPHONE.STATUSBAR.ITEM( 1 ) := cText

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure BuildRoot()
*+
*+    Called from ( phone2.prg )   1 - procedure getdevicepath()
*+                                   1 - static procedure dotreeaction()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE BuildRoot()

   IPHONE.Tree_1.DeleteAllItems
   IPHONE.Tree_1.AddItem( "This PC", 0, 1 )
   IPHONE.Tree_1.CARGO( 1 ) := { "ROOT", 2 }                          // next Level Action
   nLevel := 1
   aDevices := {}
   aFolder := {}
   aFileSys := {}
   AADD( aFolder, { NIL, "This PC", 1, 0, nElement } )

   // now include at Start
   SearchDevice()
   IPHONE.Tree_1.Expand( 1 )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SearchDevice()
*+
*+    Called from ( phone2.prg )   1 - static procedure dotreeaction()
*+                                   1 - static procedure buildroot()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SearchDevice()

LOCAL cName, oItems
LOCAL i, iMax
LOCAL xParent

   nLevel := 1
   xParent := nLevel

   oShell := CreateObject( "shell.application" )
   IF NIL <> oShell
      oFolder := oShell:NameSpace( CSIDL_DRIVES )                     // 0x0011 // My Computer
      IF NIL <> oFolder
         oItems := oFolder:Items()
         iMax := oItems:Count
         FOR i := 1 TO iMax
            oFolderItem := oItems:Item( i - 1 )
            IF !EMPTY( oFolderItem )
               cName := UPPER( oFolderItem:name )
               IF cName = "DESKTOP"
                  LOOP
               ENDIF
               IF ASCAN( aFolder, { | e | e[ ID_Name ] = cName .AND. e[ ID_Level ] = nLevel } ) > 0
               ELSE
                  nElement ++
                  IPHONE.Tree_1.AddItem( cName, nLevel, nElement )    // nLevel := 1
                  IPHONE.Tree_1.CARGO( nElement ) := { cName, nLevel + 1 }                                                                  // next Level Action
                  IPHONE.Tree_1.NodeFlag( nElement ) := .T.
                  //  IPHONE.Tree_1.ImageIndex ( nElement ) := { IMAGE_FOLDER_UNCHECKED, IMAGE_FOLDER_UNCHECKED }
                  IPHONE.Tree_1.ImageIndex( nElement ) := IsRealDrive( oFolderItem )
                  AADD( aFolder, { oFolderItem, cName, nLevel + 1, xParent, nElement } )
                  AADD( aDevices, oFolderItem )

                  IF .NOT. oFolderItem:isFileSystem
                     AADD( aFileSys, i )
                  ENDIF
               ENDIF
            ENDIF
         NEXT
      ENDIF
   ENDIF
   DO EVENTS

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SelectDevice()
*+
*+    Called from ( phone2.prg )   1 - static procedure dotreeaction()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SelectDevice()

LOCAL cThis, oItems
LOCAL i, iMax, xParent := 0
LOCAL nItem  := IPHONE.Tree_1.Value
LOCAL cPhone := TRIM( IPHONE.Tree_1.Item( nItem ) )

   nLevel := 2
   IF NIL <> oFolder
      oItems := oFolder:Items()
      iMax := oItems:Count
      FOR i := 1 TO iMax
         oFolderItem := oItems:Item( i - 1 )
         IF !EMPTY( oFolderItem )
            cThis := UPPER( oFolderItem:name )
            IF cThis = UPPER( cPhone )                                // this Device "APPLE IPHONE"
               IPHONE.Tree_1.Value := nItem
               xParent := nItem
               DoTreeRecursiv( oFolderItem, nLevel + 1, xParent, .F., .F., .F., .F., oFolderItem:isFileSystem )
               // EXIT here
               EXIT
            ENDIF
         ENDIF
      NEXT
   ENDIF
   DO EVENTS

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoTreeRecursiv()
*+
*+    Called from ( phone2.prg )   1 - static procedure dotreeaction()
*+                                   1 - static procedure selectdevice()
*+                                   1 - static procedure dotreerecursiv()
*+                                   1 - static procedure start_copyhere()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoTreeRecursiv( xFolder, xLevel, xParent, xRecursiv, lProgress, lTransfer, lMove, lisFileSys )

LOCAL xThis, xItems
LOCAL i, iMax, xFolderItem
LOCAL c_Name, c_Size, c_Date, c_Attr, c_Type
LOCAL cTarget := IPHONE.TargetDir.Value

   DEFAULT lProgress TO .F.
   DEFAULT lTransfer TO .F.
   DEFAULT lMove TO .F.
   DEFAULT lisFileSys TO .F.

   IF lProgress = .T.
      IPHONE.ProgressBar_1.Value := 0
      TBL_SETVALUE( ThisWindow.Handle, 0, 100 )
   ENDIF

   IF NIL <> xFolder
      xItems := xFolder:GetFolder:Items()

      IF lTransfer = .T.
         DoCopySingle( xItems, cTarget, lMove )
      ELSE

         iMax := xItems:Count
         FOR i := 1 TO iMax
            IF lProgress = .T.
               IPHONE.ProgressBar_1.Value := CalcPos( i, iMax )
               TBL_SETVALUE( ThisWindow.Handle, CalcPos( i, iMax ), 100 )
               DO EVENTS
            ENDIF

            xFolderItem := xItems:Item( i - 1 )
            IF !EMPTY( xFolderItem )
               IF xFolderItem:IsLink
                  LOOP
               ENDIF

               IF xFolderItem:IsFolder                                // is it a folder
                  xThis := UPPER( xFolderItem:name )

                  // search for Child and its Parent
                  IF ASCAN( aFolder, { | e | e[ ID_Name ] = xThis .AND. e[ ID_Parent ] = xParent } ) > 0

                  ELSE
                     nElement ++
                     IPHONE.Tree_1.AddItem( xThis, xParent, nElement )
                     IPHONE.Tree_1.NodeFlag( nElement ) := .T.
                     IPHONE.Tree_1.CARGO( nElement ) := { xThis, xLevel }                                                                   // next Level Action
                     //  IPHONE.Tree_1.ImageIndex( nElement ) := { IMAGE_FOLDER_UNCHECKED, IMAGE_FOLDER_UNCHECKED }
                     IPHONE.Tree_1.ImageIndex( nElement ) := IsRealDrive( xFolderItem )
                     AADD( aFolder, { xFolderItem, xThis, xLevel, xParent, nElement } )

                     // not used here
                     IF xRecursiv = .T.
                        DoTreeRecursiv( xFolderItem, xLevel + 1, xParent + i, xRecursiv, lProgress, lMove, lisFileSys )
                     ENDIF
                  ENDIF
               ELSE
                  c_Name := xFolderItem:name
                  c_Size := xFolderItem:Size
                  c_Date := xFolderItem:ModifyDate
                  c_Type := xFolderItem:Type
                  c_Attr := ""

                  AADD( aGridfiles, { c_Name, c_Size, c_Date, c_Attr, c_Type, LTRIM( STR( xLevel + 1 ) ) } )
               ENDIF
            ENDIF
         NEXT
         IF lProgress = .T.
            hb_idleSleep( 0.5 )
            IPHONE.ProgressBar_1.Value := 0
            TBL_SETVALUE( ThisWindow.Handle, 0, 100 )
         ENDIF
      ENDIF
   ENDIF
   IF IPHONE.Tree_1.IsExpand( xParent ) = .T.
      IPHONE.Tree_1.Expand( xParent )
   ENDIF
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure ShowGrid()
*+
*+    Called from ( phone2.prg )   1 - static procedure dotreeaction()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE ShowGrid( lisFileSys )

LOCAL i, iMax

   IF !EMPTY( aGridfiles )
      Domethod( "IPHONE", "Grid_1", "DisableUpdate" )
      Domethod( "IPHONE", "Grid_1", "DeleteAllItems" )

      iMax := LEN( aGridfiles )
      FOR i := 1 TO iMax
         Domethod( "IPHONE", "Grid_1", "addItem", aGridfiles[ i ] )
      NEXT

      IPHONE.Grid_1.CheckBoxAllItems := .T.

      Domethod( "IPHONE", "Grid_1", "EnableUpdate" )
      Domethod( "IPHONE", "Grid_1", "Refresh" )
      //  Domethod( "IPHONE", "Grid_1", "SetFocus" )

      IF lisFileSys = .T.
         IPHONE.Button_CopyHere.Show()
         IPHONE.Button_MoveHere.Show()
      ENDIF
   ELSE
      IPHONE.Button_CopyHere.hide()
      IPHONE.Button_MoveHere.hide()
   ENDIF
   DO EVENTS

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure Start_CopyHere()
*+
*+    Called from ( phone2.prg )   2 - procedure getdevicepath()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE Start_CopyHere( lMove )

LOCAL nPosi
LOCAL nItem   := IPHONE.Tree_1.Value
LOCAL cThis   := TRIM( IPHONE.Tree_1.Item( nItem ) )
LOCAL aSelect, xFolder, xName, xLevel, xParent, xElement

   IF !EMPTY( aGridfiles )
      IF nItem > 0
         aSelect := aFolder[ nItem ]
         xFolder := aSelect[ ID_Folder ]
         xName := aSelect[ ID_Name ]
         xLevel := aSelect[ ID_Level ]
         xParent := aSelect[ ID_Parent ]
         xElement := aSelect[ ID_Element ]

         DoTreeRecursiv( xFolder, xLevel, xParent, .F., .T., .T., lMove )
      ENDIF
   ENDIF
   DO EVENTS

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoCopyHere()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoCopyHere( oAppleFile, cTarget )

LOCAL oNewSH  := CreateObject( "Shell.Application" )
LOCAL oTarget := oNewSH:NameSpace( cTarget )
   oTarget:CopyHere( oAppleFile )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DoCopySingle()
*+
*+    Called from ( phone2.prg )   1 - static procedure dotreerecursiv()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DoCopySingle( oDirFolder, cTarget, lMove )

LOCAL hGrid   := GetControlHandle( "Grid_1", "IPHONE" )
LOCAL oNewSH  := CreateObject( "Shell.Application" )
LOCAL oTarget := oNewSH:NameSpace( cTarget )
LOCAL xFlag   := FOF_SIMPLEPROGRESS
LOCAL aFiles  := {}
LOCAL oFile, cFile, xCount, nCount
LOCAL i, iMax, nSkip := 0
LOCAL nState  := hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )
LOCAL nMask   := hb_BitOr( LVIS_SELECTED, LVIS_FOCUSED )

   DEFAULT lMove TO .F.

   IPHONE.ProgressBar_1.Value := 0
   TBL_SETVALUE( ThisWindow.Handle, 0, 100 )

   iMax := oDirFolder:Count
   FOR i := 1 TO iMax

      IPHONE.ProgressBar_1.Value := CalcPos( i, iMax )
      TBL_SETVALUE( ThisWindow.Handle, CalcPos( i, iMax ), 100 )

      DO EVENTS

      // if Checkbox is marked
      IF IPHONE.Grid_1.CheckBoxItem( i ) = .T.

         // get Item Object
         oFile := oDirFolder:Item( i - 1 )

         IF lMove = .T.
            // move single Object file
            oTarget:MoveHere( oFile, xFlag )
         ELSE
            // copy single Object file
            oTarget:CopyHere( oFile, xFlag )
         ENDIF

         // wait until all files are written
         xCount := 0
         DO WHILE .T.
            // compare if file is written
            nCount := oTarget:items() :Count()
            IF nCount + nSkip >= i
               EXIT
            ENDIF
            hb_idleSleep( 0.1 )
            xCount ++
            IF xCount > 50
               EXIT
            ENDIF
         ENDDO

         // this Syntax give Error ?
         // IPHONE.Grid_1.CheckBoxItem( i ) = .F.
         // so use this Syntax
         SetProperty( "IPHONE", "Grid_1", "CheckBoxItem", i, .F. )

         // scroll GRID if need
         LISTVIEW_SETITEMSTATE( hGrid, i, nState, nMask )
         ListView_EnsureVisible( hGrid, i )
      ELSE
         // Skip un-maked
         nSkip ++
      ENDIF
   NEXT
   // clean up
   hb_idleSleep( 0.5 )
   IPHONE.ProgressBar_1.Value := 0
   TBL_SETVALUE( ThisWindow.Handle, 0, 100 )
   oTarget := NIL
   oNewSH := NIL
   DO EVENTS

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function CalcPos()
*+
*+    Called from ( phone2.prg )   2 - static procedure dotreerecursiv()
*+                                   2 - static procedure docopysingle()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION CalcPos( nValue, iMax )

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
*+    Static Procedure PhoneTHUMBS()
*+
*+    Called from ( phone2.prg )   1 - procedure getdevicepath()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE PhoneTHUMBS()

   MsgInfo( "under Construction ..." )
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure do_logfile()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE do_logfile()

LOCAL i, iMax
LOCAL aSelect, xFolder, xName, xLevel, xParent, xElement

   SET ALTER TO .\LOGA.TXT
   SET ALTER ON

   iMax := LEN( aFolder )
   FOR i := 1 TO iMax
      aSelect := aFolder[ i ]
      xFolder := aSelect[ ID_Folder ]
      xName := aSelect[ ID_Name ]
      xLevel := aSelect[ ID_Level ]
      xParent := aSelect[ ID_Parent ]
      xElement := aSelect[ ID_Element ]

      ? xElement, xLevel, xParent, xName
   NEXT

   SET ALTER OFF
   SET ALTER TO
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function IsRealDrive()
*+
*+    Called from ( phone2.prg )   1 - static procedure searchdevice()
*+                                   1 - static procedure dotreerecursiv()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION IsRealDrive( oFolderItem )

LOCAL cBlock

   IF oFolderItem:isFileSystem
      cBlock := { IMAGE_FOLDER_CHECKED, IMAGE_FOLDER_CHECKED }
   ELSE
      cBlock := { IMAGE_FOLDER_UNCHECKED, IMAGE_FOLDER_UNCHECKED }
   ENDIF

RETURN cBlock

*+ EOF: PHONE2.PRG
