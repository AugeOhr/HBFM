*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\PICKLIST.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Procedure PickList()
*+               Static Procedure FillLeftBox()
*+               Static Procedure SelectLeftAll()
*+               Static Procedure DelItemLeft()
*+               Static Procedure SelectLeftThis()
*+               Static Procedure SelectRightAll()
*+               Static Procedure DelItemRight()
*+               Static Procedure SelectRightThis()
*+               Static Procedure GetRightesult()
*+
*+    Reformatted by Click! 2.05.30 on Aug-25-2020 at  5:17 am
*+
*+--------------------------------------------------------------------

#include "HMG.CH"
#include "COMMON.CH"
#INCLUDE "Dbstruct.ch"

MEMVAR _HMG_SYSDATA

*+--------------------------------------------------------------------
*+
*+    Procedure PickList()
*+
*+    Called from ( browser.prg )   1 - procedure browseview()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE PickList( aIn )

   SP_aDbfStruct( aIn )

   DEFINE WINDOW PickList ;
              AT 420, 509 ;
              WIDTH 550 ;
              HEIGHT 350 ;
              TITLE "Picklist" ;
              ICON NIL ;
              NOMAXIMIZE ;
              NOMINIMIZE ;
              NOSIZE ;
              ON INIT FillLeftBox( aIn ) ;
              ON RELEASE Nil ;
              ON PAINT Nil ;
              BACKCOLOR SP_nColor1()

      DEFINE LISTBOX List_Left
         ROW 20
         COL 10
         WIDTH 200
         HEIGHT 260
         ITEMS {}
         VALUE 0
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         BACKCOLOR SP_nColor9()
         FONTCOLOR SP_nColor10()
         ONDBLCLICK Nil
         TABSTOP .T.
         VISIBLE .T.
         SORT .F.
         MULTISELECT .T.
         DRAGITEMS .F.
      END LISTBOX

      DEFINE LISTBOX List_Right
         ROW 20
         COL 320
         WIDTH 200
         HEIGHT 260
         ITEMS {}
         VALUE 0
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         BACKCOLOR SP_nColor9()
         FONTCOLOR SP_nColor10()
         ONDBLCLICK Nil
         TABSTOP .T.
         VISIBLE .T.
         SORT .F.
         MULTISELECT .T.
         DRAGITEMS .F.
      END LISTBOX

      DEFINE BUTTON Button_LeftThis
         ROW 20
         COL 230
         WIDTH 60
         HEIGHT 28
         ACTION SelectLeftThis()
         CAPTION ">"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
         PICTURE Nil
         PICTALIGNMENT TOP
      END BUTTON

      DEFINE BUTTON Button_LeftAll
         ROW 60
         COL 230
         WIDTH 60
         HEIGHT 28
         ACTION SelectLeftAll( aIn )
         CAPTION ">>"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
         PICTURE Nil
         PICTALIGNMENT TOP
      END BUTTON

      DEFINE BUTTON Button_RightAll
         ROW 100
         COL 230
         WIDTH 60
         HEIGHT 28
         ACTION SelectRightAll( aIn )
         CAPTION "<<"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
         PICTURE Nil
         PICTALIGNMENT TOP
      END BUTTON

      DEFINE BUTTON Button_RightThis
         ROW 140
         COL 230
         WIDTH 60
         HEIGHT 28
         ACTION SelectRightThis()
         CAPTION "<"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
         PICTURE Nil
         PICTALIGNMENT TOP
      END BUTTON

      DEFINE BUTTON Button_Cancel
         ROW 180
         COL 230
         WIDTH 60
         HEIGHT 28
         ACTION PickList.Release
         CAPTION "&Cancel"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
         PICTURE Nil
         PICTALIGNMENT TOP
      END BUTTON

      DEFINE BUTTON Button_OK
         ROW 220
         COL 230
         WIDTH 64
         HEIGHT 64
         ACTION GetRightesult( aIn )
         CAPTION "&OK"
         FONTNAME SP_cFontName()
         FONTSIZE SP_nFontSize()
         TABSTOP .T.
         VISIBLE .T.
         TRANSPARENT .F.
         PICTURE Nil
         PICTALIGNMENT TOP
      END BUTTON

   END WINDOW

   ON KEY ESCAPE OF PickList ACTION PickList.Release
   CENTER WINDOW PickList
   ACTIVATE WINDOW PickList

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure FillLeftBox()
*+
*+    Called from ( picklist.prg )   1 - procedure picklist()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE FillLeftBox( aIn )

LOCAL ii, iMax

   iMax := LEN( aIn )
   FOR ii := 1 TO iMax
      PickList.List_Left.AddItem( aIn[ ii ] [ DBS_NAME ] )
   NEXT
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SelectLeftAll()
*+
*+    Called from ( picklist.prg )   1 - procedure picklist()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SelectLeftAll( aIn )

LOCAL ii, iMax

   PickList.List_Right.DeleteAllItems

   iMax := LEN( aIn )
   FOR ii := 1 TO iMax
      PickList.List_Right.AddItem( aIn[ ii ] [ DBS_NAME ] )
      DelItemLeft( aIn[ ii ] [ DBS_NAME ] )
   NEXT
   DO EVENTS

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DelItemLeft()
*+
*+    Called from ( picklist.prg )   1 - static procedure selectleftall()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DelItemLeft( cName )

LOCAL ii, iMax := PickList.List_Left.ItemCount
LOCAL cItem

   FOR ii := 1 TO iMax
      cItem := PickList.List_Left.Item( ii )
      IF cItem = cName
         PickList.List_Left.DeleteItem( ii )
         EXIT
      ENDIF
   NEXT
   DO EVENTS

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SelectLeftThis()
*+
*+    Called from ( picklist.prg )   1 - procedure picklist()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SelectLeftThis()

LOCAL ii, iMax
LOCAL cItem
LOCAL aSelect := PickList.List_Left.Value

   iMax := LEN( aSelect )
   FOR ii := 1 TO iMax
      cItem := PickList.List_Left.Item( aSelect[ ii ] )
      PickList.List_Right.AddItem( cItem )
   NEXT

   FOR ii := iMax TO 1 STEP - 1
      PickList.List_Left.DeleteItem( aSelect[ ii ] )
   NEXT
   DO EVENTS

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SelectRightAll()
*+
*+    Called from ( picklist.prg )   1 - procedure picklist()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SelectRightAll( aIn )

LOCAL ii, iMax

   PickList.List_Left.DeleteAllItems

   iMax := LEN( aIn )
   FOR ii := 1 TO iMax
      PickList.List_Left.AddItem( aIn[ ii ] [ DBS_NAME ] )
      DelItemRight( aIn[ ii ] [ DBS_NAME ] )
   NEXT
   DO EVENTS

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure DelItemRight()
*+
*+    Called from ( picklist.prg )   1 - static procedure selectrightall()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE DelItemRight( cName )

LOCAL ii, iMax := PickList.List_Right.ItemCount
LOCAL cItem

   FOR ii := 1 TO iMax
      cItem := PickList.List_Right.Item( ii )
      IF cItem = cName
         PickList.List_Right.DeleteItem( ii )
         EXIT
      ENDIF
   NEXT
   DO EVENTS

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure SelectRightThis()
*+
*+    Called from ( picklist.prg )   1 - procedure picklist()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE SelectRightThis()

LOCAL ii, iMax
LOCAL cItem
LOCAL aSelect := PickList.List_Right.Value

   iMax := LEN( aSelect )
   FOR ii := 1 TO iMax
      cItem := PickList.List_Right.Item( aSelect[ ii ] )
      PickList.List_Left.AddItem( cItem )
   NEXT

   FOR ii := iMax TO 1 STEP - 1
      PickList.List_Right.DeleteItem( aSelect[ ii ] )
   NEXT
   DO EVENTS

RETURN

*+--------------------------------------------------------------------
*+
*+    Static Procedure GetRightesult()
*+
*+    Called from ( picklist.prg )   1 - procedure picklist()
*+
*+--------------------------------------------------------------------
*+
STATIC PROCEDURE GetRightesult( aIn )

LOCAL ii, iMax, nPosi
LOCAL cItem, aResult := {}

   iMax := PickList.List_Right.ItemCount

   FOR ii := 1 TO iMax
      cItem := PickList.List_Right.Item( ii )
      nPosi := ASCAN( aIn, { | e | e[ DBS_NAME ] = cItem } )
      IF nPosi > 0
         AADD( aResult, aIn[ nPosi ] )
      ENDIF
   NEXT

   SP_aDbfStruct( aResult )
   DO EVENTS

   PickList.Release

RETURN

*+ EOF: PICKLIST.PRG
