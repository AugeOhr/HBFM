*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\SOURCE\\h_UNICODE.prg
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Function MsgInfoUnicode()
*+               Function MsgDebugUnicode()
*+
*+    Reformatted by Click! 2.05.34 on Sep-22-2020 at  2:50 am
*+
*+--------------------------------------------------------------------

/*----------------------------------------------------------------------------
 HMG Source File --> h_UNICODE.prg  

 Copyright 2012-2017 by Dr. Claudio Soto (from Uruguay). 

 mail: <srvet@adinet.com.uy>
 blog: http://srvet.blogspot.com

 Permission to use, copy, modify, distribute and sell this software
 and its documentation for any purpose is hereby granted without fee,
 provided that the above copyright notice appear in all copies and
 that both that copyright notice and this permission notice appear
 in supporting documentation.
 It is provided "as is" without express or implied warranty.

 ----------------------------------------------------------------------------*/

// All functions this file always compile in Unicode

MEMVAR _HMG_SYSDATA
#include "common.ch"
#include "hmg.ch"

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function MsgInfoUnicode()
*+
*+--------------------------------------------------------------------
*+
FUNCTION MsgInfoUnicode( Message, Title )

   // -----------------------------------------------------------------------------*
   DEFAULT Message TO ''
   DEFAULT Title TO ''
   HMG_MsgInfoUnicode( HMG_ValToStr( Message ), HB_VALTOSTR( Title ) )
RETURN Nil

// -----------------------------------------------------------------------------*

*+--------------------------------------------------------------------
*+
*+    Function MsgDebugUnicode()
*+
*+--------------------------------------------------------------------
*+
FUNCTION MsgDebugUnicode

   // -----------------------------------------------------------------------------*
LOCAL i, cMsg
#define CRLF CHR(13)+CHR(10) 
   cMsg := "Called from: " + PROCNAME( 1 ) + "(" + LTRIM( STR( PROCLINE( 1 ) ) ) + ") --> " + PROCFILE( 1 ) + CRLF + CRLF
   FOR i = 1 TO PCOUNT()
      cMsg := cMsg + HB_VALTOEXP( PVALUE( i ) ) + IIF( i < PCOUNT(), ", ", "" )
   NEXT
   HMG_MsgInfoUnicode( cMsg, "DEBUG Unicode INFO" )
RETURN cMsg

*+ EOF: h_UNICODE.prg

