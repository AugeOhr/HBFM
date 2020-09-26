*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\SOURCE\\h_textbox.prg
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Function _DefineTextBox()
*+               Function _DefineMaskedTextbox()
*+               Function GetNumFromText()
*+               Function GetNumMask()
*+               Function _DefineCharMaskTextbox()
*+               Procedure ProcessCharMask()
*+               Function CharMaskTekstOK()
*+               Procedure _DataTextBoxRefresh()
*+               Procedure _DataTextBoxSave()
*+               Procedure ProcessNumText()
*+               Function GETNumFromTextSP()
*+
*+    Reformatted by Click! 2.05.34 on Sep-22-2020 at  2:52 am
*+
*+--------------------------------------------------------------------

/*----------------------------------------------------------------------------
 HMG - Harbour Windows GUI library source code

 Copyright 2002-2017 Roberto Lopez <mail.box.hmg@gmail.com>
 http://sites.google.com/site/hmgweb/

 Head of HMG project:

      2002-2012 Roberto Lopez <mail.box.hmg@gmail.com>
      http://sites.google.com/site/hmgweb/

      2012-2017 Dr. Claudio Soto <srvet@adinet.com.uy>
      http://srvet.blogspot.com

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of HMG.

 The exception is that, if you link the HMG library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 HMG library code into it.

 Parts of this project are based upon:

   "Harbour GUI framework for Win32"
   Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
   Copyright 2001 Antonio Linares <alinares@fivetech.com>
   www - http://www.harbour-project.org

   "Harbour Project"
   Copyright 1999-2008, http://www.harbour-project.org/

   "WHAT32"
   Copyright 2002 AJ Wos <andrwos@aust1.net>

   "HWGUI"
   Copyright 2001-2008 Alexander S.Kresin <alex@belacy.belgorod.su>

---------------------------------------------------------------------------*/

#include "SET_COMPILE_HMG_UNICODE.ch"

MEMVAR _HMG_SYSDATA
#include "common.ch"
#include "hmg.ch"

#define EM_REPLACESEL   194   // ok
#define WM_UNDO        772   // ok
#define EM_SETMODIFY    185   // ok
#define WM_PASTE       770   // ok
#define EM_GETLINE      196   // ok
#define EM_SETSEL       177   // ok
#define WM_CLEAR        771   // ok
#define EM_GETSEL       176   // ok
#define EM_UNDO        199    // ok
#define WM_SETTEXT     12      // ok

// --------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _DefineTextBox()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _DefineTextBox( cControlName, cParentForm, nx, ny, nWidth, nHeight, ;
                            cValue, cFontName, nFontSize, cToolTip, nMaxLength, ;
                            lUpper, lLower, lNumeric, lPassword, ;
                            uLostFocus, uGotFocus, uChange, uEnter, RIGHT, ;
                            HelpId, READONLY, bold, italic, underline, ;
                            strikeout, FIELD, backcolor, fontcolor, ;
                            invisible, notabstop, disabledbackcolor, disabledfontcolor )
   // --------------------------------------------------------*

LOCAL nParentForm    := 0
LOCAL nControlHandle := 0
LOCAL mVar
LOCAL FontHandle
LOCAL WorkArea
LOCAL k
LOCAL cParentTabName

   // Asign STANDARD values to optional params.
   DEFAULT nWidth TO 120
   DEFAULT nHeight TO 24
   DEFAULT cValue TO ""
   DEFAULT uChange TO ""
   DEFAULT uGotFocus TO ""
   DEFAULT uLostFocus TO ""
   DEFAULT nMaxLength TO 0                                            // 255
   DEFAULT lUpper TO .f.
   DEFAULT lLower TO .f.
   DEFAULT lNumeric TO .f.
   DEFAULT lPassword TO .f.
   DEFAULT uEnter TO ""

   DEFAULT READONLY TO .f.
   DEFAULT bold TO .f.
   DEFAULT italic TO .f.
   DEFAULT underline TO .f.
   DEFAULT strikeout TO .f.
   DEFAULT RIGHT TO .f.
   DEFAULT invisible TO .f.
   DEFAULT notabstop TO .f.

   IF VALTYPE( Field ) != 'U'
      IF HB_UAT( '>', Field ) == 0
         MsgHMGError( "Control: " + cControlName + " Of " + cParentForm + " : You must specify a fully qualified field name. Program Terminated" )
      ELSE
         WorkArea := HB_ULEFT( Field, HB_UAT( '>', Field ) - 2 )
         IF SELECT ( WorkArea ) != 0
            cValue := &( Field )
         ENDIF
      ENDIF
   ENDIF

   IF _HMG_SYSDATA[ 264 ] = .T.
      cParentForm := _HMG_SYSDATA[ 223 ]
      IF .NOT. EMPTY( _HMG_SYSDATA[ 224 ] ) .AND. VALTYPE( cFontName ) == "U"
         cFontName := _HMG_SYSDATA[ 224 ]
      ENDIF
      IF .NOT. EMPTY( _HMG_SYSDATA[ 182 ] ) .AND. VALTYPE( nFontSize ) == "U"
         nFontSize := _HMG_SYSDATA[ 182 ]
      ENDIF
   ENDIF

   IF _HMG_SYSDATA[ 183 ] > 0
      IF _HMG_SYSDATA[ 240 ] == .F.
         nx := nx + _HMG_SYSDATA[ 334 ] [ _HMG_SYSDATA[ 183 ] ]
         ny := ny + _HMG_SYSDATA[ 333 ] [ _HMG_SYSDATA[ 183 ] ]
         cParentForm := _HMG_SYSDATA[ 332 ] [ _HMG_SYSDATA[ 183 ] ]
         cParentTabName := _HMG_SYSDATA[ 225 ]
      ENDIF
   ENDIF

   nParentForm := GetFormHandle( cParentForm )

   // Check if the window/form is defined.
   IF ( .NOT. _IsWindowDefined( cParentForm ) )
      MsgHMGError( "Window: " + cParentForm + " is not defined. Program terminated." )
   ENDIF

   // Check if the control is already defined.
   IF ( _IsControlDefined( cControlName, cParentForm ) )
      MsgHMGError( "Control: " + cControlName + " of " + cParentForm + " already defined. Program Terminated." )
   ENDIF

   mVar := '_' + cParentForm + '_' + cControlName

   // Creates the control window.
   nControlHandle := InitTextBox( nParentForm, 0, nx, ny, nWidth, nHeight, '', 0, nMaxLength, ;
                                  lUpper, lLower, .f., lPassword, RIGHT, READONLY, invisible, notabstop )

   IF VALTYPE( cfontname ) != "U" .AND. VALTYPE( nfontsize ) != "U"
      FontHandle := _SetFont( nControlHandle, cFontName, nFontSize, bold, italic, underline, strikeout )
   ELSE
      FontHandle := _SetFont( nControlHandle, _HMG_SYSDATA[ 342 ], _HMG_SYSDATA[ 343 ], bold, italic, underline, strikeout )
   ENDIF

   IF _HMG_SYSDATA[ 265 ] = .T.
      AADD( _HMG_SYSDATA[ 142 ], nControlHandle )
   ENDIF

   // Add a tooltip if param has value.
   IF ( VALTYPE( cToolTip ) != "U" )
      SetToolTip( nControlHandle, cToolTip, GetFormToolTipHandle( cParentForm ) )
   ENDIF

   k := _GetControlFree()

PUBLIC &mVar. := k

   _HMG_SYSDATA[ 1 ] [ k ] := IF( lNumeric, "NUMTEXT", "TEXT" )
   _HMG_SYSDATA[ 2 ] [ k ] := cControlName
   _HMG_SYSDATA[ 3 ] [ k ] := nControlHandle
   _HMG_SYSDATA[ 4 ] [ k ] := nParentForm
   _HMG_SYSDATA[ 5 ] [ k ] := 0
   _HMG_SYSDATA[ 6 ] [ k ] := ""
   _HMG_SYSDATA[ 7 ] [ k ] := FIELD
   _HMG_SYSDATA[ 8 ] [ k ] := nil
   _HMG_SYSDATA[ 9 ] [ k ] := ""
   _HMG_SYSDATA[ 10 ] [ k ] := uLostFocus
   _HMG_SYSDATA[ 11 ] [ k ] := uGotFocus
   _HMG_SYSDATA[ 12 ] [ k ] := uChange
   _HMG_SYSDATA[ 13 ] [ k ] := .F.
   _HMG_SYSDATA[ 14 ] [ k ] := backcolor
   _HMG_SYSDATA[ 15 ] [ k ] := fontcolor
   _HMG_SYSDATA[ 16 ] [ k ] := uEnter
   _HMG_SYSDATA[ 17 ] [ k ] := {}
   _HMG_SYSDATA[ 18 ] [ k ] := ny
   _HMG_SYSDATA[ 19 ] [ k ] := nx
   _HMG_SYSDATA[ 20 ] [ k ] := nwidth
   _HMG_SYSDATA[ 21 ] [ k ] := nheight
   _HMG_SYSDATA[ 22 ] [ k ] := 0
   _HMG_SYSDATA[ 23 ] [ k ] := IIF( _HMG_SYSDATA[ 183 ] > 0, _HMG_SYSDATA[ 333 ] [ _HMG_SYSDATA[ 183 ] ], - 1 )
   _HMG_SYSDATA[ 24 ] [ k ] := IIF( _HMG_SYSDATA[ 183 ] > 0, _HMG_SYSDATA[ 334 ] [ _HMG_SYSDATA[ 183 ] ], - 1 )
   _HMG_SYSDATA[ 25 ] [ k ] := ""
   _HMG_SYSDATA[ 26 ] [ k ] := 0
   _HMG_SYSDATA[ 27 ] [ k ] := cfontname
   _HMG_SYSDATA[ 28 ] [ k ] := nfontsize
   _HMG_SYSDATA[ 29 ] [ k ] := { bold, italic, underline, strikeout }
   _HMG_SYSDATA[ 30 ] [ k ] := ctooltip
   _HMG_SYSDATA[ 31 ] [ k ] := cParentTabName
   _HMG_SYSDATA[ 32 ] [ k ] := 0
   _HMG_SYSDATA[ 33 ] [ k ] := ''
   _HMG_SYSDATA[ 34 ] [ k ] := .NOT. invisible
   _HMG_SYSDATA[ 35 ] [ k ] := HelpId
   _HMG_SYSDATA[ 36 ] [ k ] := FontHandle
   _HMG_SYSDATA[ 37 ] [ k ] := 0
   _HMG_SYSDATA[ 38 ] [ k ] := .T.
   _HMG_SYSDATA[ 39 ] [ k ] := 0
   _HMG_SYSDATA[ 40 ] [ k ] := { NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL }

   _HMG_SYSDATA[ 40 ] [ k ] [ 9 ] := DISABLEDBACKCOLOR
   _HMG_SYSDATA[ 40 ] [ k ] [ 10 ] := DISABLEDFONTCOLOR
   _HMG_SYSDATA[ 40 ] [ k ] [ 11 ] := READONLY

   // With NUMERIC clause, transform numeric value into a string.
   IF ( lNumeric )
      IF VALTYPE( cValue ) != 'C'
         cValue := ALLTRIM( STR( cValue ) )
      ENDIF
   ENDIF

   // Fill the TEXTBOX with the text given.
   IF ( HMG_LEN( cValue ) > 0 )
      SetWindowText( nControlHandle, cValue )
   ENDIF

   IF VALTYPE( Field ) != 'U'
      AADD( _HMG_SYSDATA[ 89 ] [ GetFormIndex( cParentForm ) ], k )
   ENDIF

RETURN nil
// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _DefineMaskedTextbox()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _DefineMaskedTextbox( ControlName, ParentForm, x, y, inputmask, width, value, fontname, fontsize, tooltip, lostfocus, gotfocus, change, height, enter, rightalign, HelpId, Format, bold, italic, underline, strikeout, field, backcolor, fontcolor, readonly, invisible, notabstop, disabledbackcolor, disabledfontcolor )

   // -----------------------------------------------------------------------------*
LOCAL i, cParentForm, c, mVar, WorkArea, k := 0
LOCAL ControlHandle
LOCAL FontHandle
LOCAL cParentTabName

   //  Unused Parameters
   RightAlign := NIL
   //
   DEFAULT READONLY TO .f.
   DEFAULT bold TO .f.
   DEFAULT italic TO .f.
   DEFAULT underline TO .f.
   DEFAULT strikeout TO .f.
   DEFAULT RightAlign TO .f.                                          // not used, but is defined as argument
   DEFAULT invisible TO .f.
   DEFAULT notabstop TO .f.

   IF VALTYPE( Field ) != 'U'
      IF HB_UAT( '>', Field ) == 0
         MsgHMGError( "Control: " + ControlName + " Of " + ParentForm + " : You must specify a fully qualified field name. Program Terminated" )
      ELSE
         WorkArea := HB_ULEFT( Field, HB_UAT( '>', Field ) - 2 )
         IF SELECT ( WorkArea ) != 0
            Value := &( Field )
         ENDIF
      ENDIF
   ENDIF

   IF VALTYPE( Format ) == "U"
      Format := ""
   ENDIF

   FOR i := 1 TO HMG_LEN( InputMask )

      c := HB_USUBSTR( InputMask, i, 1 )

      // change by Jimmy 202009
#ifdef COMPILE_HMG_UNICODE
      IF c != '9' .AND. c != '$' .AND. c != '*' .AND. c != '.' .AND. c != ',' .AND. c != ' ' .AND. c != '€' .AND. c != 'â‚¬'
         MsgHMGError( "@...TEXTBOX: Wrong InputMask Definition" )
      ENDIF
#else
      IF c != '9' .AND. c != '$' .AND. c != '*' .AND. c != '.' .AND. c != ',' .AND. c != ' ' .AND. c != '€'
         MsgHMGError( "@...TEXTBOX: Wrong InputMask Definition" )
      ENDIF
#endif

   NEXT i

   FOR i := 1 TO HMG_LEN( Format )

      c := HB_USUBSTR( Format, i, 1 )

      IF c != 'C' .AND. c != 'X' .AND. c != '(' .AND. c != 'E'
         MsgHMGError( "@...TEXTBOX: Wrong Format Definition" )
      ENDIF

   NEXT i

   IF VALTYPE( change ) == "U"
      change := ""
   ENDIF

   IF VALTYPE( gotfocus ) == "U"
      gotfocus := ""
   ENDIF

   IF VALTYPE( enter ) == "U"
      enter := ""
   ENDIF

   IF VALTYPE( lostfocus ) == "U"
      lostfocus := ""
   ENDIF

   IF VALTYPE( Width ) == "U"
      Width := 120
   ENDIF

   IF VALTYPE( height ) == "U"
      height := 24
   ENDIF

   IF VALTYPE( Value ) == "U"
      Value := ""
   ENDIF

   IF .NOT. EMPTY( Format )
      Format := '@' + ALLTRIM( Format )
   ENDIF

   InputMask := Format + ' ' + InputMask

   Value := TRANSFORM( value, InputMask )

   IF _HMG_SYSDATA[ 264 ] = .T.
      ParentForm := _HMG_SYSDATA[ 223 ]
      IF .NOT. EMPTY( _HMG_SYSDATA[ 224 ] ) .AND. VALTYPE( FontName ) == "U"
         FontName := _HMG_SYSDATA[ 224 ]
      ENDIF
      IF .NOT. EMPTY( _HMG_SYSDATA[ 182 ] ) .AND. VALTYPE( FontSize ) == "U"
         FontSize := _HMG_SYSDATA[ 182 ]
      ENDIF
   ENDIF
   IF _HMG_SYSDATA[ 183 ] > 0
      IF _HMG_SYSDATA[ 240 ] == .F.
         x := x + _HMG_SYSDATA[ 334 ] [ _HMG_SYSDATA[ 183 ] ]
         y := y + _HMG_SYSDATA[ 333 ] [ _HMG_SYSDATA[ 183 ] ]
         ParentForm := _HMG_SYSDATA[ 332 ] [ _HMG_SYSDATA[ 183 ] ]
         cParentTabName := _HMG_SYSDATA[ 225 ]
      ENDIF
   ENDIF

   IF .NOT. _IsWindowDefined( ParentForm )
      MsgHMGError( "Window: " + ParentForm + " is not defined. Program terminated" )
   ENDIF

   IF _IsControlDefined( ControlName, ParentForm )
      MsgHMGError( "Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated" )
   ENDIF

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm := ParentForm

   ParentForm = GetFormHandle( ParentForm )

   ControlHandle := InitMaskedTextBox( ParentForm, 0, x, y, width, '', 0, 255, .f., .f., height, .t., readonly, invisible, notabstop )
   IF VALTYPE( fontname ) != "U" .AND. VALTYPE( fontsize ) != "U"
      FontHandle := _SetFont( ControlHandle, FontName, FontSize, bold, italic, underline, strikeout )
   ELSE
      FontHandle := _SetFont( ControlHandle, _HMG_SYSDATA[ 342 ], _HMG_SYSDATA[ 343 ], bold, italic, underline, strikeout )
   ENDIF

   IF _HMG_SYSDATA[ 265 ] = .T.
      AADD( _HMG_SYSDATA[ 142 ], ControlHandle )
   ENDIF

   IF VALTYPE( tooltip ) != "U"
      SetToolTip( ControlHandle, tooltip, GetFormToolTipHandle( cParentForm ) )
   ENDIF

   k := _GetControlFree()

PUBLIC &mVar. := k

   _HMG_SYSDATA[ 1 ] [ k ] := "MASKEDTEXT"
   _HMG_SYSDATA[ 2 ] [ k ] := ControlName
   _HMG_SYSDATA[ 3 ] [ k ] := ControlHandle
   _HMG_SYSDATA[ 4 ] [ k ] := ParentForm
   _HMG_SYSDATA[ 5 ] [ k ] := 0
   _HMG_SYSDATA[ 6 ] [ k ] := ""
   _HMG_SYSDATA[ 7 ] [ k ] := InputMask
   _HMG_SYSDATA[ 8 ] [ k ] := Nil
   _HMG_SYSDATA[ 9 ] [ k ] := GetNumMask( InputMask )
   _HMG_SYSDATA[ 10 ] [ k ] := lostfocus
   _HMG_SYSDATA[ 11 ] [ k ] := gotfocus
   _HMG_SYSDATA[ 12 ] [ k ] := Change
   _HMG_SYSDATA[ 13 ] [ k ] := .F.
   _HMG_SYSDATA[ 14 ] [ k ] := backcolor
   _HMG_SYSDATA[ 15 ] [ k ] := fontcolor
   _HMG_SYSDATA[ 16 ] [ k ] := enter
   _HMG_SYSDATA[ 17 ] [ k ] := FIELD
   _HMG_SYSDATA[ 18 ] [ k ] := y
   _HMG_SYSDATA[ 19 ] [ k ] := x
   _HMG_SYSDATA[ 20 ] [ k ] := width
   _HMG_SYSDATA[ 21 ] [ k ] := height
   _HMG_SYSDATA[ 22 ] [ k ] := .F.
   _HMG_SYSDATA[ 23 ] [ k ] := IIF( _HMG_SYSDATA[ 183 ] > 0, _HMG_SYSDATA[ 333 ] [ _HMG_SYSDATA[ 183 ] ], - 1 )
   _HMG_SYSDATA[ 24 ] [ k ] := IIF( _HMG_SYSDATA[ 183 ] > 0, _HMG_SYSDATA[ 334 ] [ _HMG_SYSDATA[ 183 ] ], - 1 )
   _HMG_SYSDATA[ 25 ] [ k ] := ""
   _HMG_SYSDATA[ 26 ] [ k ] := 0
   _HMG_SYSDATA[ 27 ] [ k ] := fontname
   _HMG_SYSDATA[ 28 ] [ k ] := fontsize
   _HMG_SYSDATA[ 29 ] [ k ] := { bold, italic, underline, strikeout }
   _HMG_SYSDATA[ 30 ] [ k ] := tooltip
   _HMG_SYSDATA[ 31 ] [ k ] := cParentTabName
   _HMG_SYSDATA[ 32 ] [ k ] := 0
   _HMG_SYSDATA[ 33 ] [ k ] := ''
   _HMG_SYSDATA[ 34 ] [ k ] := .NOT. invisible
   _HMG_SYSDATA[ 35 ] [ k ] := HelpId
   _HMG_SYSDATA[ 36 ] [ k ] := FontHandle
   _HMG_SYSDATA[ 37 ] [ k ] := 0
   _HMG_SYSDATA[ 38 ] [ k ] := .T.
   _HMG_SYSDATA[ 39 ] [ k ] := 0
   _HMG_SYSDATA[ 40 ] [ k ] := { NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL }

   _HMG_SYSDATA[ 40 ] [ k ] [ 9 ] := DISABLEDBACKCOLOR
   _HMG_SYSDATA[ 40 ] [ k ] [ 10 ] := DISABLEDFONTCOLOR
   _HMG_SYSDATA[ 40 ] [ k ] [ 11 ] := READONLY

   SetWindowText( ControlHandle, value )

   IF VALTYPE( Field ) != 'U'
      AADD( _HMG_SYSDATA[ 89 ] [ GetFormIndex( cParentForm ) ], k )
   ENDIF

RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function GetNumFromText()
*+
*+    Called from ( h_controlmisc.prg )   4 - function _getvalue()
*+                ( h_textbox.prg )   2 - procedure processcharmask()
*+                ( h_windows.prg )   8 - function events()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetNumFromText( Text, i )

LOCAL x, c, s

   s := ''

   FOR x := 1 TO HMG_LEN( Text )

      c := HB_USUBSTR( Text, x, 1 )

      IF c = '0' .OR. c = '1' .OR. c = '2' .OR. c = '3' .OR. c = '4' .OR. c = '5' .OR. c = '6' .OR. c = '7' .OR. c = '8' .OR. c = '9' .OR. c = '.' .OR. c = '-'
         s := s + c
      ENDIF

   NEXT x

   IF HB_ULEFT( ALLTRIM( Text ), 1 ) == '(' .OR. HB_URIGHT( ALLTRIM( Text ), 2 ) == 'DB'
      s := '-' + s
   ENDIF

   s := TRANSFORM( VAL( s ), _HMG_SYSDATA[ 9 ] [ i ] )

RETURN VAL( s )

*+--------------------------------------------------------------------
*+
*+    Function GetNumMask()
*+
*+    Called from ( h_textbox.prg )   1 - function _definemaskedtextbox()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GetNumMask( Text )

LOCAL i, c, s

   s := ''

   FOR i := 1 TO HMG_LEN( Text )

      c := HB_USUBSTR( Text, i, 1 )

      IF c = '9' .OR. c = '.'
         s := s + c
      ENDIF

      IF c = '$' .OR. c = '*'
         s := s + '9'
      ENDIF

   NEXT i

RETURN s

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function _DefineCharMaskTextbox()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _DefineCharMaskTextbox( ControlName, ParentForm, x, y, inputmask, width, value, fontname, fontsize, tooltip, lostfocus, gotfocus, change, height, enter, rightalign, HelpId, bold, italic, underline, strikeout, field, backcolor, fontcolor, date, readonly, invisible, notabstop, disabledbackcolor, disabledfontcolor )

   // -----------------------------------------------------------------------------*
LOCAL cParentForm, mVar, WorkArea, dateformat, k := 0
LOCAL ControlHandle
LOCAL FontHandle
LOCAL cParentTabName

   DEFAULT invisible TO .F.

   IF VALTYPE( Field ) != 'U'
      IF HB_UAT( '>', Field ) == 0
         MsgHMGError( "Control: " + ControlName + " Of " + ParentForm + " : You must specify a fully qualified field name. Program Terminated" )
      ELSE
         WorkArea := HB_ULEFT( Field, HB_UAT( '>', Field ) - 2 )
         IF SELECT ( WorkArea ) != 0
            Value := &( Field )
         ENDIF
      ENDIF
   ENDIF

   IF VALTYPE( date ) == "U"
      date := .F.
   ENDIF

   IF VALTYPE( change ) == "U"
      change := ""
   ENDIF

   IF VALTYPE( gotfocus ) == "U"
      gotfocus := ""
   ENDIF

   IF VALTYPE( enter ) == "U"
      enter := ""
   ENDIF

   IF VALTYPE( lostfocus ) == "U"
      lostfocus := ""
   ENDIF

   IF VALTYPE( Width ) == "U"
      Width := 120
   ENDIF

   IF VALTYPE( height ) == "U"
      height := 24
   ENDIF

   IF VALTYPE( Value ) == "U"
      IF date == .F.
         Value := ""
      ELSE
         Value := CTOD( '  /  /  ' )
      ENDIF
   ENDIF

   dateformat := SET( _SET_DATEFORMAT )

   IF date == .t.
      IF HMG_LOWER( HB_ULEFT( dateformat, 4 ) ) == "yyyy"

         IF '/' $ dateformat
            Inputmask := '9999/99/99'
         ELSEIF '.' $ dateformat
            Inputmask := '9999.99.99'
         ELSEIF '-' $ dateformat
            Inputmask := '9999-99-99'
         ENDIF

      ELSEIF HMG_LOWER( HB_URIGHT( dateformat, 4 ) ) == "yyyy"

         IF '/' $ dateformat
            Inputmask := '99/99/9999'
         ELSEIF '.' $ dateformat
            Inputmask := '99.99.9999'
         ELSEIF '-' $ dateformat
            Inputmask := '99-99-9999'
         ENDIF

      ELSE

         IF '/' $ dateformat
            Inputmask := '99/99/99'
         ELSEIF '.' $ dateformat
            Inputmask := '99.99.99'
         ELSEIF '-' $ dateformat
            Inputmask := '99-99-99'
         ENDIF

      ENDIF
   ENDIF

   IF _HMG_SYSDATA[ 264 ] = .T.
      ParentForm := _HMG_SYSDATA[ 223 ]
      IF .NOT. EMPTY( _HMG_SYSDATA[ 224 ] ) .AND. VALTYPE( FontName ) == "U"
         FontName := _HMG_SYSDATA[ 224 ]
      ENDIF
      IF .NOT. EMPTY( _HMG_SYSDATA[ 182 ] ) .AND. VALTYPE( FontSize ) == "U"
         FontSize := _HMG_SYSDATA[ 182 ]
      ENDIF
   ENDIF
   IF _HMG_SYSDATA[ 183 ] > 0
      IF _HMG_SYSDATA[ 240 ] == .F.
         x := x + _HMG_SYSDATA[ 334 ] [ _HMG_SYSDATA[ 183 ] ]
         y := y + _HMG_SYSDATA[ 333 ] [ _HMG_SYSDATA[ 183 ] ]
         ParentForm := _HMG_SYSDATA[ 332 ] [ _HMG_SYSDATA[ 183 ] ]
         cParentTabName := _HMG_SYSDATA[ 225 ]
      ENDIF
   ENDIF

   IF .NOT. _IsWindowDefined( ParentForm )
      MsgHMGError( "Window: " + ParentForm + " is not defined. Program terminated" )
   ENDIF

   IF _IsControlDefined( ControlName, ParentForm )
      MsgHMGError( "Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated" )
   ENDIF

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm := ParentForm

   ParentForm = GetFormHandle( ParentForm )

   ControlHandle := InitCharMaskTextBox( ParentForm, 0, x, y, width, '', 0, 255, .f., .f., height, rightalign, readonly, invisible, notabstop )
   IF VALTYPE( fontname ) != "U" .AND. VALTYPE( fontsize ) != "U"
      FontHandle := _SetFont( ControlHandle, FontName, FontSize, bold, italic, underline, strikeout )
   ELSE
      FontHandle := _SetFont( ControlHandle, _HMG_SYSDATA[ 342 ], _HMG_SYSDATA[ 343 ], bold, italic, underline, strikeout )
   ENDIF

   IF _HMG_SYSDATA[ 265 ] = .T.
      AADD( _HMG_SYSDATA[ 142 ], ControlHandle )
   ENDIF

   IF VALTYPE( tooltip ) != "U"
      SetToolTip( ControlHandle, tooltip, GetFormToolTipHandle( cParentForm ) )
   ENDIF

   k := _GetControlFree()

PUBLIC &mVar. := k

   _HMG_SYSDATA[ 1 ] [ k ] := "CHARMASKTEXT"
   _HMG_SYSDATA[ 2 ] [ k ] := ControlName
   _HMG_SYSDATA[ 3 ] [ k ] := ControlHandle
   _HMG_SYSDATA[ 4 ] [ k ] := ParentForm
   _HMG_SYSDATA[ 5 ] [ k ] := 0
   _HMG_SYSDATA[ 6 ] [ k ] := ""
   _HMG_SYSDATA[ 7 ] [ k ] := FIELD
   _HMG_SYSDATA[ 8 ] [ k ] := Nil
   _HMG_SYSDATA[ 9 ] [ k ] := InputMask
   _HMG_SYSDATA[ 10 ] [ k ] := lostfocus
   _HMG_SYSDATA[ 11 ] [ k ] := gotfocus
   _HMG_SYSDATA[ 12 ] [ k ] := Change
   _HMG_SYSDATA[ 13 ] [ k ] := .F.
   _HMG_SYSDATA[ 14 ] [ k ] := backcolor
   _HMG_SYSDATA[ 15 ] [ k ] := fontcolor
   _HMG_SYSDATA[ 16 ] [ k ] := enter
   _HMG_SYSDATA[ 17 ] [ k ] := date
   _HMG_SYSDATA[ 18 ] [ k ] := y
   _HMG_SYSDATA[ 19 ] [ k ] := x
   _HMG_SYSDATA[ 20 ] [ k ] := width
   _HMG_SYSDATA[ 21 ] [ k ] := height
   _HMG_SYSDATA[ 22 ] [ k ] := 0
   _HMG_SYSDATA[ 23 ] [ k ] := IIF( _HMG_SYSDATA[ 183 ] > 0, _HMG_SYSDATA[ 333 ] [ _HMG_SYSDATA[ 183 ] ], - 1 )
   _HMG_SYSDATA[ 24 ] [ k ] := IIF( _HMG_SYSDATA[ 183 ] > 0, _HMG_SYSDATA[ 334 ] [ _HMG_SYSDATA[ 183 ] ], - 1 )
   _HMG_SYSDATA[ 25 ] [ k ] := ""
   _HMG_SYSDATA[ 26 ] [ k ] := 0
   _HMG_SYSDATA[ 27 ] [ k ] := fontname
   _HMG_SYSDATA[ 28 ] [ k ] := fontsize
   _HMG_SYSDATA[ 29 ] [ k ] := { bold, italic, underline, strikeout }
   _HMG_SYSDATA[ 30 ] [ k ] := tooltip
   _HMG_SYSDATA[ 31 ] [ k ] := cParentTabName
   _HMG_SYSDATA[ 32 ] [ k ] := 0
   _HMG_SYSDATA[ 33 ] [ k ] := ''
   _HMG_SYSDATA[ 34 ] [ k ] := .NOT. invisible
   _HMG_SYSDATA[ 35 ] [ k ] := HelpId
   _HMG_SYSDATA[ 36 ] [ k ] := FontHandle
   _HMG_SYSDATA[ 37 ] [ k ] := 0
   _HMG_SYSDATA[ 38 ] [ k ] := .T.
   _HMG_SYSDATA[ 39 ] [ k ] := 0
   _HMG_SYSDATA[ 40 ] [ k ] := { NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL }

   _HMG_SYSDATA[ 40 ] [ k ] [ 9 ] := DISABLEDBACKCOLOR
   _HMG_SYSDATA[ 40 ] [ k ] [ 10 ] := DISABLEDFONTCOLOR
   _HMG_SYSDATA[ 40 ] [ k ] [ 11 ] := READONLY

   IF date == .F.
      SetWindowText( ControlHandle, Value )
   ELSE
      SetWindowText( ControlHandle, DTOC( Value ) )
   ENDIF

   IF VALTYPE( Field ) != 'U'
      AADD( _HMG_SYSDATA[ 89 ] [ GetFormIndex( cParentForm ) ], k )
   ENDIF

RETURN Nil

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Procedure ProcessCharMask()
*+
*+    Called from ( h_windows.prg )   2 - function events()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE ProcessCharMask( i, d )

   // ------------------------------------------------------------------------------*
LOCAL InBuffer, OutBuffer := '', icp, x, CB, CM, BadEntry := .F., InBufferLeft, InBufferRight, Mask, OldChar, BackInbuffer
LOCAL pc           := 0
LOCAL fnb          := 0
LOCAL dc           := 0
LOCAL pFlag        := .F.
LOCAL ncp          := 0
LOCAL NegativeZero := .F.
LOCAL Output       := ''
LOCAL ol           := 0

   //  Unused Parameters
   d := Nil
   //

   IF VALTYPE( _HMG_SYSDATA[ 22 ] [ i ] ) == 'L'
      IF _HMG_SYSDATA[ 22 ] [ i ] == .F.
         RETURN
      ENDIF
   ENDIF

   Mask := _HMG_SYSDATA[ 9 ] [ i ]

   // Store Initial CaretPos

   icp := HiWord( SendMessage( _HMG_SYSDATA[ 3 ] [ i ], EM_GETSEL, 0, 0 ) )

   // Get Current Content

   InBuffer := GetWindowText( _HMG_SYSDATA[ 3 ] [ i ] )

   // RL 104

   IF HB_ULEFT( ALLTRIM( InBuffer ), 1 ) == '-' .AND. VAL( InBuffer ) == 0
      // Tone (1000,1)
      NegativeZero := .T.
   ENDIF

   //

   IF PCOUNT() > 1

      // Point Count For Numeric InputMask

      FOR x := 1 TO HMG_LEN( InBuffer )
         CB := HB_USUBSTR( InBuffer, x, 1 )
         IF CB == '.' .OR. ;
                    CB == ","                                         // MOL, April 2016
            pc ++
         ENDIF
      NEXT x

      // RL 89
      IF HB_ULEFT( InbuFfer, 1 ) == '.' .OR. ;
                   HB_ULEFT( InbuFfer, 1 ) == ','                     // MOL, April 2016
         pFlag := .T.
      ENDIF
      //

      // Find First Non-Blank Position

      FOR x := 1 TO HMG_LEN( InBuffer )
         CB := HB_USUBSTR( InBuffer, x, 1 )
         IF CB != ' '
            fnb := x
            EXIT
         ENDIF
      NEXT x

   ENDIF

   //

   BackInBuffer := InBuffer

   OldChar := HB_USUBSTR( InBuffer, icp + 1, 1 )

   IF HMG_LEN( InBuffer ) < HMG_LEN( Mask )

      InBufferLeft := HB_ULEFT( InBuffer, icp )

      InBufferRight := HB_URIGHT( InBuffer, HMG_LEN( InBuffer ) - icp )

      // JK

      IF CharMaskTekstOK( InBufferLeft + ' ' + InBufferRight, Mask ) .AND. CharMaskTekstOK( InBufferLeft + InBufferRight, Mask ) == .f.
         InBuffer := InBufferLeft + ' ' + InBufferRight
      ELSE
         InBuffer := InBufferLeft + InBufferRight
      ENDIF

   ENDIF

   IF HMG_LEN( InBuffer ) > HMG_LEN( Mask )

      InBufferLeft := HB_ULEFT( InBuffer, icp )

      InBufferRight := HB_URIGHT( InBuffer, HMG_LEN( InBuffer ) - icp - 1 )

      InBuffer := InBufferLeft + InBufferRight

   ENDIF

   // Process Mask

   FOR x := 1 TO HMG_LEN( Mask )

      CB := HB_USUBSTR( InBuffer, x, 1 )
      CM := HB_USUBSTR( Mask, x, 1 )

      DO CASE

         CASE ( CM ) == '!'

            OutBuffer := OutBuffer + HMG_UPPER( CB )

         CASE ( CM ) == 'A'

            IF HMG_ISALPHA( CB ) .OR. CB == ' '

               OutBuffer := OutBuffer + CB

            ELSE

               IF x == icp
                  BadEntry := .T.
                  OutBuffer := OutBuffer + OldChar
               ELSE
                  OutBuffer := OutBuffer + ' '
               ENDIF

            ENDIF

         CASE CM == '9'

            IF HMG_ISDIGIT( CB ) .OR. CB == ' ' .OR. ( CB == '-' .AND. x == fnb .AND. PCOUNT() > 1 )

               OutBuffer := OutBuffer + CB

            ELSE

               IF x == icp
                  BadEntry := .T.
                  OutBuffer := OutBuffer + OldChar
               ELSE
                  OutBuffer := OutBuffer + ' '
               ENDIF

            ENDIF

         CASE CM == ' '

            IF CB == ' '

               OutBuffer := OutBuffer + CB

            ELSE

               IF x == icp
                  BadEntry := .T.
                  OutBuffer := OutBuffer + OldChar
               ELSE
                  OutBuffer := OutBuffer + ' '
               ENDIF

            ENDIF

         OTHERWISE

            OutBuffer := OutBuffer + CM

      END CASE

   NEXT x

   // Replace Content

   IF !( BackInBuffer == OutBuffer )
      SetWindowText( _HMG_SYSDATA[ 3 ] [ i ], OutBuffer )
   ENDIF

   IF pc > 1

      IF NegativeZero == .T.

         Output := TRANSFORM( GetNumFromText( GetWindowText( _HMG_SYSDATA[ 3 ] [ i ] ), i ), Mask )

         Output := HB_URIGHT( Output, ol - 1 )

         Output := '-' + Output

         // Replace Text

         SetWindowText( _HMG_SYSDATA[ 3 ] [ i ], Output )
         SendMessage( _HMG_SYSDATA[ 3 ] [ i ], EM_SETSEL, HB_UAT( '.', OutBuffer ) + dc, HB_UAT( '.', OutBuffer ) + dc )

      ELSE

         SetWindowText( _HMG_SYSDATA[ 3 ] [ i ], TRANSFORM( GetNumFromText( GetWindowText( _HMG_SYSDATA[ 3 ] [ i ] ), i ), Mask ) )
         SendMessage( _HMG_SYSDATA[ 3 ] [ i ], EM_SETSEL, HB_UAT( '.', OutBuffer ) + dc, HB_UAT( '.', OutBuffer ) + dc )

      ENDIF

   ELSE

      IF pFlag == .T.
         ncp := HB_UAT( '.', GetWindowText( _HMG_SYSDATA[ 3 ] [ i ] ) )
         SendMessage( _HMG_SYSDATA[ 3 ] [ i ], EM_SETSEL, ncp, ncp )

      ELSE

         // Restore Initial CaretPos

         IF BadEntry
            icp --
         ENDIF

         SendMessage( _HMG_SYSDATA[ 3 ] [ i ], EM_SETSEL, icp, icp )

         // Skip Protected Characters

         FOR x := 1 TO HMG_LEN( OutBuffer )

            CB := HB_USUBSTR( OutBuffer, icp + x, 1 )
            CM := HB_USUBSTR( Mask, icp + x, 1 )

            IF ( .NOT. HMG_ISDIGIT( CB ) ) .AND. ( .NOT. HMG_ISALPHA( CB ) ) .AND. ( ( .NOT. CB = ' ' ) .OR. ( CB == ' ' .AND. CM == ' ' ) )
               SendMessage( _HMG_SYSDATA[ 3 ] [ i ], EM_SETSEL, icp + x, icp + x )
            ELSE
               EXIT
            ENDIF

         NEXT x

      ENDIF

   ENDIF

RETURN
// JK

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function CharMaskTekstOK()
*+
*+    Called from ( h_textbox.prg )   2 - procedure processcharmask()
*+
*+--------------------------------------------------------------------
*+
FUNCTION CharMaskTekstOK( cString, cMask )

   // ------------------------------------------------------------------------------*

LOCAL lPassed := .f., CB, CM, x

   FOR x := 1 TO MIN( HMG_LEN( cString ), HMG_LEN( cMask ) )

      CB := HB_USUBSTR( cString, x, 1 )
      CM := HB_USUBSTR( cMask, x, 1 )

      DO CASE

         CASE ( CM ) == '!'

            IF HMG_ISUPPER( CB ) .OR. CB == ' '
               lPassed := .t.
            ENDIF

         CASE ( CM ) == 'A'

            IF HMG_ISALPHA( CB ) .OR. CB == ' '
               lPassed := .t.
            ELSE
               lPassed := .f.
               RETURN lPassed
            ENDIF

         CASE CM == '9'

            IF HMG_ISDIGIT( CB ) .OR. CB == ' '
               lPassed := .t.
            ELSE
               lPassed := .f.
               RETURN lPassed
            ENDIF

         CASE CM == ' '

            IF CB == ' '
               lPassed := .t.
            ELSE
               lPassed := .f.
               RETURN lPassed
            ENDIF

         OTHERWISE

            lPassed := .t.

      END CASE

   NEXT i

RETURN lPassed
// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Procedure _DataTextBoxRefresh()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _refresh()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE _DataTextBoxRefresh( i )

   // ------------------------------------------------------------------------------*
LOCAL FIELD

   IF _HMG_SYSDATA[ 1 ] [ i ] == "MASKEDTEXT"
      FIELD := _HMG_SYSDATA[ 17 ] [ i ]
   ELSE
      FIELD := _HMG_SYSDATA[ 7 ] [ i ]
   ENDIF

   IF TYPE( Field ) == 'C'
      _SetValue( '', '', RTRIM( &( Field ) ), i )
   ELSE
      _SetValue( '', '', &( Field ), i )
   ENDIF

RETURN
// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Procedure _DataTextBoxSave()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _savedata()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE _DataTextBoxSave( ControlName, ParentForm )

   // ------------------------------------------------------------------------------*
LOCAL FIELD, i

   i := GetControlIndex( ControlName, ParentForm )

   IF _HMG_SYSDATA[ 1 ] [ i ] == "MASKEDTEXT"
      FIELD := _HMG_SYSDATA[ 17 ] [ i ]
   ELSE
      FIELD := _HMG_SYSDATA[ 7 ] [ i ]
   ENDIF

   &( Field ) := _GetValue( Controlname, ParentForm )

RETURN
// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Procedure ProcessNumText()
*+
*+    Called from ( h_windows.prg )   1 - function events()
*+
*+--------------------------------------------------------------------
*+
PROCEDURE ProcessNumText( i )

   // ------------------------------------------------------------------------------*
LOCAL InBuffer, OutBuffer := '', icp, x, CB, BackInBuffer, BadEntry := .F., fnb

   // Store Initial CaretPos
   icp := HiWord( SendMessage( _HMG_SYSDATA[ 3 ] [ i ], EM_GETSEL, 0, 0 ) )

   // Get Current Content

   InBuffer := GetWindowText( _HMG_SYSDATA[ 3 ] [ i ] )

   BackInBuffer := InBuffer

   // Find First Non-Blank Position

   FOR x := 1 TO HMG_LEN( InBuffer )
      CB := HB_USUBSTR( InBuffer, x, 1 )
      IF CB != ' '
         fnb := x
         EXIT
      ENDIF
   NEXT x

   // Process Mask

   FOR x := 1 TO HMG_LEN( InBuffer )

      CB := HB_USUBSTR( InBuffer, x, 1 )

      IF HMG_ISDIGIT( CB ) .OR. ( CB == '-' .AND. x == fnb ) .OR. ( CB == '.' .AND. HB_UAT( CB, OutBuffer ) == 0 ) .OR. ;
                      ( CB == ',' .AND. HB_UAT( '.', OutBuffer ) == 0 )                                                                     // MOL, April 2016

         OutBuffer := OutBuffer + CB
      ELSE
         BadEntry := .t.
      ENDIF

   NEXT x

   IF BadEntry
      icp --
   ENDIF

   // JK Replace Content

   IF !( BackInBuffer == OutBuffer )
      SetWindowText( _HMG_SYSDATA[ 3 ] [ i ], OutBuffer )
   ENDIF

   // Restore Initial CaretPos

   SendMessage( _HMG_SYSDATA[ 3 ] [ i ], EM_SETSEL, icp, icp )

RETURN

// ------------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function GETNumFromTextSP()
*+
*+    Called from ( h_controlmisc.prg )   2 - function _getvalue()
*+                ( h_windows.prg )   4 - function events()
*+
*+--------------------------------------------------------------------
*+
FUNCTION GETNumFromTextSP( Text, i )

   // ------------------------------------------------------------------------------*
LOCAL x, c, s

   s := ''

   FOR x := 1 TO HMG_LEN( Text )

      c := HB_USUBSTR( Text, x, 1 )

      IF c = '0' .OR. c = '1' .OR. c = '2' .OR. c = '3' .OR. c = '4' .OR. c = '5' .OR. c = '6' .OR. c = '7' .OR. c = '8' .OR. c = '9' .OR. c = ',' .OR. c = '-' .OR. c = '.'

         IF c == '.'
            c := ''
         ENDIF

         IF C == ','
            C := '.'
         ENDIF

         s := s + c

      ENDIF

   NEXT x

   IF HB_ULEFT( ALLTRIM( Text ), 1 ) == '(' .OR. HB_URIGHT( ALLTRIM( Text ), 2 ) == 'DB'
      s := '-' + s
   ENDIF

   s := TRANSFORM( VAL( s ), _HMG_SYSDATA[ 9 ] [ i ] )

RETURN VAL( s )

*+ EOF: h_textbox.prg

