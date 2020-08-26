*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\FMCOLOR.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Function ColorDialog()
*+               Function NumColor2RGB()
*+               Function SysColor2Num()
*+               Function RGB2Num()
*+               Function RGB2BGR()
*+               Function ResetColor()
*+
*+    Reformatted by Click! 2.05.30 on Aug-25-2020 at  5:16 am
*+
*+--------------------------------------------------------------------

MEMVAR _HMG_SYSDATA
MEMVAR _HMG_FindReplaceOnAction

#include 'hmg.ch'
#include "common.ch"
#include "COLOR.CH" 

// #define COLOR_BTNFACE   15    // ok

*+--------------------------------------------------------------------
*+
*+    Function ColorDialog()
*+
*+--------------------------------------------------------------------
*+
FUNCTION ColorDialog( aDefaultColor, aCustomColors, lFullOpenBox )

   // -----------------------------------------------------------------------------*
LOCAL i, aRetVal, nColor, nInitColor

   IF VALTYPE( aDefaultColor ) == "A"
      nInitColor := RGB( aDefaultColor[ 1 ], aDefaultColor[ 2 ], aDefaultColor[ 3 ] )
   ENDIF

   IF VALTYPE( aCustomColors ) == "A"
      ASIZE( aCustomColors, 16 )
      FOR i = 1 TO 16
         IF VALTYPE( aCustomColors[ i ] ) == "A"
            aCustomColors[ i ] := RGB( aCustomColors[ i ] [ 1 ], aCustomColors[ i ] [ 2 ], aCustomColors[ i ] [ 3 ] )
         ELSEIF VALTYPE( aCustomColors[ i ] ) <> "N"
            aCustomColors[ i ] := GetSysColor( COLOR_BTNFACE )
         ENDIF
      NEXT
   ENDIF

   IF VALTYPE( lFullOpenBox ) <> "L"
      lFullOpenBox := .T.
   ENDIF

   nColor := ChooseColor( NIL, nInitColor, @aCustomColors, lFullOpenBox )

RETURN nColor

*+--------------------------------------------------------------------
*+
*+    Function NumColor2RGB()
*+
*+    Called from ( fmstack.prg )   1 - function sp_ncolor1()
*+                                   1 - function sp_ncolor2()
*+                                   1 - function sp_ncolor3()
*+                                   1 - function sp_ncolor4()
*+                                   1 - function sp_ncolor5()
*+                                   1 - function sp_ncolor6()
*+                                   1 - function sp_ncolor7()
*+                                   1 - function sp_ncolor8()
*+                                   1 - function sp_ncolor9()
*+                                   1 - function sp_ncolor10()
*+                                   1 - function sp_ncolor11()
*+                                   1 - function sp_ncolor12()
*+                                   1 - function sp_ncolor13()
*+                                   1 - function sp_ncolor14()
*+                ( hbfm.prg )  14 - static function loadsetup()
*+
*+--------------------------------------------------------------------
*+
FUNCTION NumColor2RGB( nColor )

LOCAL aRetVal

   DEFAULT nColor TO - 1

   IF nColor == - 1
      aRetVal := { NIL, NIL, NIL }
   ELSE
      aRetVal := { GetRed( nColor ), GetGreen( nColor ), GetBlue( nColor ) }
   ENDIF

RETURN aRetVal

*+--------------------------------------------------------------------
*+
*+    Function SysColor2Num()
*+
*+    Called from ( fmcolor.prg )  14 - function resetcolor()
*+                ( fmstack.prg )  14 - function sp_init()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SysColor2Num( nColor )

RETURN GetSysColor( nColor )

// FUNCTION NumColor2Array(nColor)
// RETURN nRGB2Arr (nColor)

*+--------------------------------------------------------------------
*+
*+    Function RGB2Num()
*+
*+    Called from ( fmgrid.prg )  14 - static procedure savesetup()
*+                ( fmsetup.prg )  14 - static procedure preresetcolor()
*+                ( hbfm.prg )  14 - static function c_fmsetup()
*+
*+--------------------------------------------------------------------
*+
FUNCTION RGB2Num( aColor )

RETURN RGB( aColor[ 1 ], aColor[ 2 ], aColor[ 3 ] )

*+--------------------------------------------------------------------
*+
*+    Function RGB2BGR()
*+
*+--------------------------------------------------------------------
*+
FUNCTION RGB2BGR( aColor )

RETURN { aColor[ 3 ], aColor[ 2 ], aColor[ 1 ] }

*+--------------------------------------------------------------------
*+
*+    Function ResetColor()
*+
*+    Called from ( fmsetup.prg )   1 - static procedure preresetcolor()
*+
*+--------------------------------------------------------------------
*+
FUNCTION ResetColor()

LOCAL nColor
   ALTD()

   IF SP_DarkMode()
      nColor := RGB( 001, 001, 001 )
      SP_nColor1( nColor )
      nColor := RGB( 076, 254, 254 )
      SP_nColor2( nColor )
      nColor := RGB( 001, 128, 255 )
      SP_nColor3( nColor )
      nColor := RGB( 254, 254, 254 )
      SP_nColor4( nColor )
      nColor := RGB( 200, 200, 200 )
      SP_nColor5( nColor )
      nColor := RGB( 001, 001, 001 )
      SP_nColor6( nColor )
      nColor := RGB( 056, 056, 056 )
      SP_nColor7( nColor )
      nColor := RGB( 192, 192, 192 )
      SP_nColor8( nColor )
      nColor := RGB( 001, 001, 001 )
      SP_nColor9( nColor )
      nColor := RGB( 076, 254, 254 )
      SP_nColor10( nColor )
      nColor := RGB( 001, 128, 255 )
      SP_nColor11( nColor )
      nColor := RGB( 255, 255, 255 )
      SP_nColor12( nColor )
      nColor := RGB( 056, 056, 056 )
      SP_nColor13( nColor )
      nColor := RGB( 076, 254, 254 )
      SP_nColor14( nColor )
   ELSE
      SP_nColor1( SysColor2Num( COLOR_BTNFACE ) )
      SP_nColor2( SysColor2Num( COLOR_WINDOWTEXT ) + 1 )
      SP_nColor3( SysColor2Num( COLOR_HIGHLIGHT ) )
      SP_nColor4( SysColor2Num( COLOR_HIGHLIGHTTEXT ) )
      SP_nColor5( SysColor2Num( COLOR_WINDOW ) )
      SP_nColor6( SysColor2Num( COLOR_WINDOWTEXT ) + 1 )
      SP_nColor7( SysColor2Num( COLOR_BTNTEXT ) + 1 )
      SP_nColor8( SysColor2Num( COLOR_WINDOWTEXT ) + 1 )
      SP_nColor9( SysColor2Num( COLOR_BTNFACE ) )
      SP_nColor10( SysColor2Num( COLOR_WINDOWTEXT ) + 1 )
      SP_nColor11( SysColor2Num( COLOR_HIGHLIGHT ) )
      SP_nColor12( SysColor2Num( COLOR_HIGHLIGHTTEXT ) )
      SP_nColor13( SysColor2Num( COLOR_GRAYTEXT ) )
      SP_nColor14( SysColor2Num( COLOR_WINDOWTEXT ) + 1 )
   ENDIF
RETURN NIL

*+ EOF: FMCOLOR.PRG
