*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\HBDEVICE.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Function MainEventHandler()
*+               Function USB_Detect()
*+               Function Drop_Detect()
*+               Function OnMouseHover()
*+               Procedure Wait4Action()
*+               Procedure DoNothing()
*+               Static Function GetChange2Drive()
*+
*+    Reformatted by Click! 2.05.30 on Aug-25-2020 at  5:17 am
*+
*+--------------------------------------------------------------------

#include "HMG.CH"
#include "HBFM.CH"

#define WM_DROPFILES                0x0233
#define CRLF                        CHR(13)+CHR(10)

#define TME_HOVER 0x00000001
#define TME_LEAVE 0x00000002

STATIC aAction   := { "", "", "" }
STATIC cDropForm := ""
STATIC cDropCont := ""

MEMVAR Win_1

*+--------------------------------------------------------------------
*+
*+    Function MainEventHandler()
*+
*+--------------------------------------------------------------------
*+
FUNCTION MainEventHandler( nHWnd, nMsg, nWParam, nLParam )

STATIC snHFocusMenu
LOCAL cPanel
LOCAL nHWndFrom
LOCAL nRow, nCol
LOCAL nMask, cDevice := ""
LOCAL aFiles, nLen
LOCAL lTracking     := .F.
LOCAL nMainhWnd     := GetMainWindowHandle()

   IF nHWnd == nMainhWnd

      DO CASE

            // CASE lThreatRet .AND. hb_isArray ( xRet )
            //     //return message from Wait4Action thread
            //     Msginfo( xRet[1], STR( xRet[2] ) )
            //     FillCombo(.T.)

         CASE nMsg == WM_DEVICECHANGE
            DO CASE
               CASE nWParam == DBT_DEVICEARRIVAL
                  nMask := DeviceChangeInfo( nWParam, nLParam )
                  IF !EMPTY( nMask ) .AND. nMask > 0
                     cDevice := GetChange2Drive( nMask )
                  ENDIF
                  // send job
                  // hb_mutexNotify( s_mtxUSB, { "INSERT", cDevice, nMask, nHWnd } )
                  aAction := { "INSERT", cDevice, nMask }
                  // lDevice := .T.
                  SP_Device( .T. )

               CASE nWParam == DBT_DEVICEREMOVECOMPLETE
                  nMask := DeviceChangeInfo( nWParam, nLParam )
                  IF !EMPTY( nMask ) .AND. nMask > 0
                     cDevice := GetChange2Drive( nMask )
                  ENDIF
                  //send job
                  // hb_mutexNotify( s_mtxUSB, { "REMOVE", cDevice, nMask, nHWnd } )
                  aAction := { "REMOVE", cDevice, nMask }
                  // lDevice := .T.
                  SP_Device( .T. )

            END CASE

         CASE nMsg == WM_MOUSEHOVER
            OnMouseHover()

         CASE nMsg == WM_MOUSELEAVE
            TrackMouseEvent( nHWnd, TME_LEAVE )

         CASE nMsg == WM_NCMOUSEHOVER
            OnMouseHover()

         CASE nMsg == WM_NCMOUSELEAVE
            TrackMouseEvent( nHWnd, TME_LEAVE )

         CASE nMsg == WM_MOUSEMOVE
            lTracking := TrackMouseEvent( nHWnd )

         CASE nMsg == WM_DROPFILES
            SP_lDropfiles( .T. )
            //  MSGINFO( "WM_DROPFILES" )
            ALTD()
            IF !EMPTY( cDropForm ) .AND. !EMPTY( cDropCont )
               //  SetProperty( cDropForm, cDropCont, "Value", "" )

               aFiles := DragQueryFileS( nWParam )
               nLen := LEN( aFiles )
               IF nLen > 0
                  AddFile2Grid( cDropForm, cDropCont, ACLONE( aFiles ) )
               ENDIF
            ENDIF

      END CASE
   ENDIF

RETURN cDevice

*+--------------------------------------------------------------------
*+
*+    Function USB_Detect()
*+
*+--------------------------------------------------------------------
*+
FUNCTION USB_Detect()

LOCAL nHWnd   := EventHWND()
LOCAL nMsg    := EventMSG()
LOCAL nWParam := EventWPARAM()
LOCAL nLParam := EventLPARAM()
LOCAL nMask, cDevice := ""
LOCAL aFiles, nLen, i

   // Local xRet
   // Local lThreatRet := hb_mutexSubscribe( s_mtxReturn, 0.00000001, @xRet )
   // Local lThreatRet := hb_mutexSubscribe( s_mtxReturn, 0.00001, @xRet )

   DO CASE

         // CASE lThreatRet .AND. hb_isArray ( xRet )
         //     //return message from Wait4Action thread
         //     Msginfo( xRet[1], STR( xRet[2] ) )
         //     FillCombo(.T.)

      CASE nMsg == WM_DEVICECHANGE
         DO CASE
            CASE nWParam == DBT_DEVICEARRIVAL
               nMask := DeviceChangeInfo( nWParam, nLParam )
               IF !EMPTY( nMask ) .AND. nMask > 0
                  cDevice := GetChange2Drive( nMask )
               ENDIF
               // send job
               // hb_mutexNotify( s_mtxUSB, { "INSERT", cDevice, nMask, nHWnd } )
               aAction := { "INSERT", cDevice, nMask }
               // lDevice := .T.
               SP_Device( .T. )

            CASE nWParam == DBT_DEVICEREMOVECOMPLETE
               nMask := DeviceChangeInfo( nWParam, nLParam )
               IF !EMPTY( nMask ) .AND. nMask > 0
                  cDevice := GetChange2Drive( nMask )
               ENDIF
               //send job
               // hb_mutexNotify( s_mtxUSB, { "REMOVE", cDevice, nMask, nHWnd } )
               aAction := { "REMOVE", cDevice, nMask }
               // lDevice := .T.
               SP_Device( .T. )

         END CASE

         //  CASE nMsg == WM_MOUSEMOVE
         //     msginfo("WM_MOUSEMOVE")
         //     OnMouseHover()
         //  CASE nMsg == WM_MOUSEHOVER
         //     msginfo("WM_MOUSEHOVER")
         //     OnMouseHover()
         //  CASE nMsg == WM_NCMOUSEHOVER
         //     msginfo("WM_NCMOUSEHOVER")
         //     OnMouseHover()

      CASE nMsg == WM_DROPFILES
         SP_lDropfiles( .T. )
         //  MSGINFO( "WM_DROPFILES" )
         ALTD()
         OnMouseHover()
         IF !EMPTY( cDropForm ) .AND. !EMPTY( cDropCont )
            //  SetProperty( cDropForm, cDropCont, "Value", "" )

            aFiles := DragQueryFileS( nWParam )
            nLen := LEN( aFiles )
            IF nLen > 0
               AddFile2Grid( cDropForm, cDropCont, ACLONE( aFiles ) )
            ENDIF
         ENDIF

   END CASE

RETURN cDevice

*+--------------------------------------------------------------------
*+
*+    Function Drop_Detect()
*+
*+--------------------------------------------------------------------
*+
FUNCTION Drop_Detect()

LOCAL nHWnd   := EventHWND()
LOCAL nMsg    := EventMSG()
LOCAL nWParam := EventWPARAM()
LOCAL nLParam := EventLPARAM()
LOCAL aFiles, nLen, i

   DO CASE
      CASE nMsg == WM_MOUSEHOVER .OR. nMsg == WM_NCMOUSEHOVER
         MSGINFO( "WM_MOUSEHOVER" )

      CASE nMsg == WM_DROPFILES
         MSGINFO( "WM_DROPFILES" )

         IF !EMPTY( cDropForm ) .AND. !EMPTY( cDropCont )
            //  SetProperty( cDropForm, cDropCont, "Value", "" )

            aFiles := DragQueryFileS( nWParam )
            nLen := LEN( aFiles )
            IF nLen > 0
               AddFile2Grid( cDropForm, cDropCont, ACLONE( aFiles ) )
            ENDIF
         ENDIF

   ENDCASE

RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function OnMouseHover()
*+
*+    Called from ( hbdevice.prg )   2 - function maineventhandler()
*+                                   1 - function usb_detect()
*+
*+--------------------------------------------------------------------
*+
FUNCTION OnMouseHover()

LOCAL cControl  := ""
LOCAL cForm     := ""
LOCAL nCol, nRow, hWnd
LOCAL nIndex
LOCAL cCtrlType

   GetCursorPos( @nCol, @nRow )
   hWnd := WindowFromPoint( nCol, nRow )
   nIndex := GetControlIndexByHandle( hWnd )
   IF nIndex > 0
      cCtrlType := IF( nIndex > 0, GetControlTypeByIndex( nIndex ), "" )
      //  msginfo(cCtrlType)
      IF cCtrlType = "MULTIGRID"
         GetControlNameByHandle( hWnd, @cControl, @cForm )
         IF !EMPTY( cControl )
            cDropCont := cControl                                     // field-wide STATIC
            cDropForm := cForm                                        // field-wide STATIC
            //  msginfo(cDropForm+"."+cDropCont)
            SbarText( cDropForm + "." + cDropCont, "ONFLY" )
         ENDIF
      ELSE
         cDropCont := ""
         cDropForm := ""
      ENDIF
   ELSE
      cDropCont := ""
      cDropForm := ""
   ENDIF
RETURN NIL

*+--------------------------------------------------------------------
*+
*+    Procedure Wait4Action()
*+
*+    Called from ( fmgrid.prg )   1 - procedure dualgrid()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE Wait4Action()

LOCAL cAction := ""
LOCAL cDevice := ""
LOCAL cInfo   := ""
LOCAL cText   := ""
LOCAL nInfo   := 0
LOCAL lExit   := .F.
LOCAL nLen, i

   // LOCAL xUSB
   // LOCAL ParrentHWnd

   DO WHILE !lExit
      // hb_mutexSubscribe( s_mtxUSB,, @xUSB )     //wait for job with params
      // IF xUSB == NIL
      //    lExit := .T.
      // ENDIF
      // IF hb_IsArray (xUSB)

      hb_idleSleep( .5 )

      // IF lDevice = .T.
      //    lDevice = .F.

      IF SP_Device()
         SP_Device( .F. )
         cAction := aAction[ 1 ]
         cDevice := aAction[ 2 ]
         nInfo := aAction[ 3 ]

         IF !EMPTY( cAction ) .AND. !EMPTY( cDevice )
            cText := cAction + " " + cDevice + CRLF
            // Msginfo( cText, STR( nInfo ) )

            FillCombo( .T. )
            DoComboImage( .T. )
            CheckTabView()
         ENDIF
         aAction := { "", "", "" }

         // cAction     := xUSB[1]
         // cDevice     := xUSB[2]
         // nInfo       := xUSB[3]
         // ParrentHWnd := xUSB[4]
         // cInfo   := WMI_Info(cDevice)
         // IF !EMPTY(cAction) .AND. !EMPTY(cDevice)
         //    cText := cAction + " " + cDevice + CRLF
         //    cText += "S/N " + IF(cInfo = "N/A","???",cInfo)
         //    //send return message
         //    hb_mutexNotify( s_mtxReturn, { cText, nInfo } )
         //    SendMessage (ParrentHWnd, 0x0000, 0, 0)   //force event
         // ENDIF

      ENDIF

      IF SP_lDropfiles() = .T.
         SP_lDropfiles( .F. )
      ENDIF

   ENDDO

RETURN

*+--------------------------------------------------------------------
*+
*+    Procedure DoNothing()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE DoNothing()

   DO WHILE .T.
      hb_idleSleep( .5 )
   ENDDO
RETURN

*+--------------------------------------------------------------------
*+
*+    Static Function GetChange2Drive()
*+
*+    Called from ( hbdevice.prg )   2 - function maineventhandler()
*+                                   2 - function usb_detect()
*+
*+--------------------------------------------------------------------
*+
STATIC FUNCTION GetChange2Drive( nMask )

LOCAL cBin := NToC( nMask, 2 )
LOCAL nBit := LEN( cBin ) - hb_At( '1', cBin )
RETURN CHR( nBit + 65 ) + ":"

//
//
//

*+ EOF: HBDEVICE.PRG
