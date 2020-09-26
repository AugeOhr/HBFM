*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\SOURCE\\h_HMG_HPDF.Prg
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Function _HMG_HPDF_INIT()
*+               Function _hmg_hpdf_setencoding()
*+               Function _hmg_hpdf_startdoc()
*+               Function _hmg_hpdf_startpage()
*+               Function _HMG_HPDF_InsertPage()
*+               Function _HMG_HPDF_GoToPage()
*+               Function _hmg_hpdf_endpage()
*+               Function HMG_HPDF_PageCount()
*+               Function HMG_HPDF_PageNo()
*+               Function _hmg_hpdf_enddoc()
*+               Function _hmg_hpdf_abortdoc()
*+               Function _HMG_HPDF_PRINT()
*+               Function _HMG_HPDF_MULTILINE_PRINT()
*+               Function _HMG_HPDF_LINE()
*+               Function _HMG_HPDF_RECTANGLE()
*+               Function _HMG_HPDF_ROUNDRECTANGLE()
*+               Function _HMG_HPDF_CIRCLE()
*+               Function _HMG_HPDF_ELLIPSE()
*+               Function _HMG_HPDF_ARC()
*+               Function _HMG_HPDF_CURVE()
*+               Function _HMG_HPDF_IMAGE()
*+               Function _HMG_HPDF_SetPassword()
*+               Function _HMG_HPDF_SetCompression()
*+               Function _HMG_HPDF_SetPermission()
*+               Function _HMG_HPDF_SetPageMode()
*+               Function _HMG_HPDF_RootOutline()
*+               Function _HMG_HPDF_PageOutline()
*+               Function _HMG_HPDF_SetTextAnnot()
*+               Function _HMG_HPDF_SetPageLink()
*+               Function _HMG_HPDF_SetURLLink()
*+               Function _HMG_HPDF_SetLineSpacing()
*+               Function _HMG_HPDF_SetInfo()
*+               Function _HMG_HPDF_GetInfo()
*+               Function _HMG_HPDF_SetPageLabel()
*+               Function _HMG_HPDF_Error()
*+               Function _HMG_HPDF_Inch2Pixel()
*+               Function _HMG_HPDF_Pixel2Inch()
*+               Function _HMG_HPDF_MM2Pixel()
*+               Function _HMG_HPDF_Pixel2MM()
*+               Function _HMG_HPDF_INIT_PAPERSIZE()
*+               Function _HMG_HPDF_SetFont()
*+               Function _HMG_HPDF_SeekHaruFonts()
*+               Function _HMG_HPDF_SeekEquivalences()
*+               Function _HMG_HPDF_ExistInLocal()
*+               Function _HMG_HPDF_SeekInLocalOptions()
*+               Function FWriteLine()
*+               Function HTML_TABLE_INI()
*+               Function HTML_TABLE_LINE()
*+               Function HTML_BOLD()
*+
*+    Reformatted by Click! 2.05.34 on Sep-22-2020 at  2:50 am
*+
*+--------------------------------------------------------------------

/*
  - by S. Rathinagiri on October 22nd, 2012

  - The adaptation of the source code of this file to support UNICODE character set and WIN64 architecture was made
    by Dr. Claudio Soto, November 2012 and June 2014 respectively.

  - Revised by Pablo César Arrascaeta on April 12th, 2014
    Implement of _HMG_HPDF_SetFont() with improvements extra functions

*/
MEMVAR _HMG_SYSDATA, nFhandle, lDoLog

#include <hmg.ch>
#include "harupdf.ch"

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_INIT()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_savepages()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_INIT( cPDFFile, nOrientation, nPaperSize, nPaperLength, nPaperWidth, lLog )

LOCAL lReturn := .f.

   DEFAULT nOrientation := 1
   DEFAULT nPaperSize := 1
   DEFAULT lLog := .f.

PUBLIC nFhandle := 0, lDoLog := lLog

   IF VALTYPE( _HMG_SYSDATA[ 150 ] ) == 'U'
      _HMG_SYSDATA[ 150 ] := { ;
                               Nil, ;                                 //  1.PDF Object
                               cPDFFile, ;                            //  2.PDF File to Save
                               0, ;                                   //  3.PDF PaperSize
                               0, ;                                   //  4.PDF PaperWidth
                               0, ;                                   //  5.PDF PaperHeight
                               nOrientation, ;                        //  6.PDF Orientation
                               Nil, ;                                 //  7.PDF Current Page
                               'Helvetica', ;                         //  8.PDF default font
                               12, ;                                  //  9.PDF default fontsize
                               "StandardEncoding", ;                  // 10.PDF default encoding
                               {}, ;                                  // 11.PDF Outlines Array
                               {}, ;                                  // 12.PDF Pages Array
                               0 ;                                    // 13.PDF Current Page Number
                               }
      _HMG_SYSDATA[ 150 ] [ 1 ] := HPDF_New()
      IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil
         _HMG_HPDF_Error( 2 )
         RETURN lReturn
      ENDIF

      IF lLog
         nFhandle := FCREATE( 'UsedFonts.htm', 0 )
         Html_Table_Ini( nFHandle, "TruType Fonts used", 1024, 3 )
         HTML_TABLE_LINE( nFHandle, { { HTML_BOLD( nFHandle, "Line (pixels)" ), "#ABABAB", .t. }, ;
                                      { HTML_BOLD( nFHandle, "Column (pixels)" ), "#ABABAB", .t. }, ;
                                      { HTML_BOLD( nFHandle, "Page" ), "#ABABAB", .t. }, ;
                                      { HTML_BOLD( nFHandle, "Given Font Name" ), "#ABABAB", .f. }, ;
                                      { HTML_BOLD( nFHandle, "Size" ), "#ABABAB", .t. }, ;
                                      { HTML_BOLD( nFHandle, "Properties" ), "#ABABAB", .f. }, ;
                                      { HTML_BOLD( nFHandle, "Reassigned Font Name" ), "#ABABAB", .f. } } )
      ENDIF

      _HMG_SYSDATA[ 150 ] [ 3 ] := nPaperSize
      IF nPaperSize == 256                                            // user size
         IF _HMG_SYSDATA[ 150 ] [ 6 ] == 1                            // orientation portrait
            _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( nPaperWidth )
            _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( nPaperLength )
         ELSE                                                         // orientation landscape
            _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( nPaperLength )
            _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( nPaperWidth )
         ENDIF
      ELSE
         _HMG_HPDF_INIT_PAPERSIZE( nPaperSize )
      ENDIF
      lReturn := .t.
   ELSE
      _HMG_HPDF_Error( 1 )
      RETURN lReturn
   ENDIF
RETURN lReturn

*+--------------------------------------------------------------------
*+
*+    Function _hmg_hpdf_setencoding()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _hmg_hpdf_setencoding( cEncoding )

   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   HPDF_SetCurrentEncoder( _HMG_SYSDATA[ 150 ] [ 1 ], cEncoding )
   _HMG_SYSDATA[ 150 ] [ 10 ] := cEncoding
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _hmg_hpdf_startdoc()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_savepages()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _hmg_hpdf_startdoc()                                         // START HPDFDOC

RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _hmg_hpdf_startpage()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_savepages()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _hmg_hpdf_startpage()

   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 7 ] == Nil                                // Page is free
      _HMG_SYSDATA[ 150 ] [ 7 ] := HPDF_AddPage( _HMG_SYSDATA[ 150 ] [ 1 ] )
      IF EMPTY( _HMG_SYSDATA[ 150, 7 ] )
         _HMG_HPDF_Error( 9, hb_HPDF_GetErrorString( _HMG_SYSDATA[ 150 ] [ 7 ] ) + " | StartPage" )
         RETURN Nil
      ELSE
         // add current page to the pages array
         AADD( _HMG_SYSDATA[ 150 ] [ 12 ], _HMG_SYSDATA[ 150 ] [ 7 ] )
         _HMG_SYSDATA[ 150 ] [ 13 ] := HMG_LEN( _HMG_SYSDATA[ 150 ] [ 12 ] )
         // set page size
         HPDF_Page_SetWidth( _HMG_SYSDATA[ 150 ] [ 7 ], _HMG_SYSDATA[ 150 ] [ 4 ] )
         HPDF_Page_SetHeight( _HMG_SYSDATA[ 150 ] [ 7 ], _HMG_SYSDATA[ 150 ] [ 5 ] )
      ENDIF
   ELSE
      _HMG_HPDF_Error( 4 )
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_InsertPage()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_InsertPage( nPage )

LOCAL oOldPage := Nil
LOCAL aPages   := ACLONE( _HMG_SYSDATA[ 150 ] [ 12 ] )

   IF nPage > HMG_LEN( aPages ) .OR. nPage < 1
      _HMG_HPDF_Error( 16 )
      RETURN Nil
   ENDIF
   oOldPage := aPages[ nPage ]
   IF EMPTY( oOldPage )
      _HMG_HPDF_Error( 16 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 7 ] == Nil                                // Page is free
      _HMG_SYSDATA[ 150 ] [ 7 ] := HPDF_InsertPage( _HMG_SYSDATA[ 150 ] [ 1 ], oOldPage )
      IF EMPTY( _HMG_SYSDATA[ 150, 7 ] )
         _HMG_HPDF_Error( 9, hb_HPDF_GetErrorString( _HMG_SYSDATA[ 150 ] [ 7 ] ) + " | InsertPage" )
         RETURN Nil
      ELSE
         // insert current page to the pages array
         ASIZE( aPages, HMG_LEN( aPages ) + 1 )
         AINS( aPages, nPage )
         aPages[ nPage ] := _HMG_SYSDATA[ 150, 7 ]
         _HMG_SYSDATA[ 150 ] [ 12 ] := ACLONE( aPages )
         _HMG_SYSDATA[ 150 ] [ 13 ] := nPage
         HPDF_Page_SetWidth( _HMG_SYSDATA[ 150 ] [ 7 ], _HMG_SYSDATA[ 150 ] [ 4 ] )
         HPDF_Page_SetHeight( _HMG_SYSDATA[ 150 ] [ 7 ], _HMG_SYSDATA[ 150 ] [ 5 ] )
      ENDIF
   ELSE
      _HMG_HPDF_Error( 4 )
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_GoToPage()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_GoToPage( nPage )

LOCAL oPage  := Nil
LOCAL aPages := ACLONE( _HMG_SYSDATA[ 150 ] [ 12 ] )

   IF nPage > HMG_LEN( aPages ) .OR. nPage < 1
      _HMG_HPDF_Error( 18 )
      RETURN Nil
   ENDIF
   oPage := aPages[ nPage ]
   IF EMPTY( oPage )
      _HMG_HPDF_Error( 18 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 7 ] == Nil                                // Page is free
      _HMG_SYSDATA[ 150 ] [ 7 ] := aPages[ nPage ]
      IF EMPTY( _HMG_SYSDATA[ 150, 7 ] )
         _HMG_HPDF_Error( 19 )
         RETURN Nil
      ENDIF
      _HMG_SYSDATA[ 150 ] [ 13 ] := nPage
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _hmg_hpdf_endpage()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_savepages()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _hmg_hpdf_endpage()

   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 7 ] == Nil                                // Page is free
      _HMG_HPDF_Error( 5 )
      RETURN Nil
   ELSE
      _HMG_SYSDATA[ 150 ] [ 7 ] := Nil
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function HMG_HPDF_PageCount()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_HPDF_PageCount()

   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
RETURN HMG_LEN( _HMG_SYSDATA[ 150 ] [ 12 ] )

*+--------------------------------------------------------------------
*+
*+    Function HMG_HPDF_PageNo()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HMG_HPDF_PageNo()

   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 7 ] == Nil                                // Page is free
      _HMG_HPDF_Error( 5 )
      RETURN Nil
   ENDIF
RETURN _HMG_SYSDATA[ 150 ] [ 13 ]

*+--------------------------------------------------------------------
*+
*+    Function _hmg_hpdf_enddoc()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_savepages()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _hmg_hpdf_enddoc()

   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   HPDF_SaveToFile( _HMG_SYSDATA[ 150 ] [ 1 ], _HMG_SYSDATA[ 150 ] [ 2 ] )
   HPDF_Free( _HMG_SYSDATA[ 150 ] [ 1 ] )
   _HMG_SYSDATA[ 150 ] := Nil

   //HTML_END(nFHandle)
   //FClose( nFhandle )
   IF lDoLog
      FWRITE( nFHandle, "</table></body></html>" + CRLF )
      FCLOSE( nFHandle )
   ENDIF

   RELEASE nFhandle, lDoLog
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _hmg_hpdf_abortdoc()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _hmg_hpdf_abortdoc()

   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   HPDF_Free( _HMG_SYSDATA[ 150 ] [ 1 ] )
   _HMG_SYSDATA[ 150 ] [ 1 ] := Nil
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_PRINT()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_PRINT( nRow, nCol, cFontName, nFontSize, nRColor, nGColor, nBColor, cText, lBold, lItalic, lUnderline, lStrikeout, lColor, lFont, lSize, cAlign )

LOCAL nWidth     := _HMG_SYSDATA[ 150 ] [ 4 ]
LOCAL nHeight    := _HMG_SYSDATA[ 150 ] [ 5 ]
LOCAL nTextWidth := 0
LOCAL nxPos      := _HMG_HPDF_MM2Pixel( nCol )
LOCAL nyPos      := nHeight - _HMG_HPDF_MM2Pixel( nRow )
LOCAL oFont      := Nil
LOCAL cFont      := ''
LOCAL cTtfFnt
   DEFAULT cFontName := ''
   DEFAULT nFontSize := 12
   DEFAULT nRColor := 0
   DEFAULT nGColor := 0
   DEFAULT nBColor := 0
   DEFAULT lBold := .f.
   DEFAULT lItalic := .f.
   DEFAULT lUnderline := .f.
   DEFAULT lStrikeout := .f.
   DEFAULT lColor := .f.
   DEFAULT lFont := .f.
   DEFAULT lSize := .f.
   DEFAULT cAlign := ''

   cTtfFnt := cFontName

   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 7 ] == Nil                                // PDF Page object not found!
      _HMG_HPDF_Error( 5 )
      RETURN Nil
   ENDIF

   // set color
   IF lColor
      HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ] [ 7 ], nRColor / 255, nGColor / 255, nBColor / 255 )
   ELSE
      HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ] [ 7 ], 0.0, 0.0, 0.0 )
   ENDIF

   // set font
   IF HMG_LEN( ALLTRIM( cFontName ) ) == 0
      cFontName := _HMG_HPDF_SetFont( cFontName, lBold, lItalic )
      oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ] [ 1 ], cFontName, _HMG_SYSDATA[ 150 ] [ 10 ] )
   ELSE
      cFontName := ALLTRIM( _HMG_HPDF_SetFont( cFontName, lBold, lItalic ) )

      IF HMG_UPPER( cFileExt( cFontName ) ) == '.TTF'                 // load ttf font

         cFont := HPDF_LOADTTFONTFROMFILE( _HMG_SYSDATA[ 150 ] [ 1 ], cFontName, .t. )
         IF HMG_LEN( ALLTRIM( cFont ) ) == 0
            _HMG_HPDF_Error( 6, cFontName )
            RETURN Nil
         ENDIF
         oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ] [ 1 ], cFont, _HMG_SYSDATA[ 150 ] [ 10 ] )
      ELSE
         IF HMG_UPPER( ALLTRIM( cFontName ) ) == "SYMBOL" .OR. HMG_UPPER( ALLTRIM( cFontName ) ) == "ZAPFDINGBATS"
            oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ] [ 1 ], cFontName, Nil )
         ELSE
            oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ] [ 1 ], cFontName, _HMG_SYSDATA[ 150 ] [ 10 ] )
         ENDIF
      ENDIF
   ENDIF
   IF oFont == Nil
      _HMG_HPDF_Error( 6, cFontName )
      RETURN Nil
   ELSE
      HPDF_Page_SetFontAndSize( _HMG_SYSDATA[ 150 ] [ 7 ], oFont, nFontSize )
      nTextWidth := HPDF_Page_TextWidth( _HMG_SYSDATA[ 150 ] [ 7 ], cText )
      DO CASE
         CASE HMG_UPPER( ALLTRIM( cAlign ) ) == 'CENTER'
            nxPos := nxPos - ( nTextWidth / 2 )
         CASE HMG_UPPER( ALLTRIM( cAlign ) ) == 'RIGHT'
            nxPos := nxPos - ( nTextWidth )
      ENDCASE
      nyPos -= nFontSize
      HPDF_Page_BeginText( _HMG_SYSDATA[ 150 ] [ 7 ] )
      HPDF_PAGE_TEXTOUT( _HMG_SYSDATA[ 150 ] [ 7 ], nxPos, nyPos, cText )
      HPDF_Page_EndText( _HMG_SYSDATA[ 150 ] [ 7 ] )

      IF lDoLog
         HTML_TABLE_LINE( nFHandle, { { STRZERO( nRow, 4, 0 ) + " (" + STRZERO( nyPos, 7, 2 ) + ")", "#FFFFFF", .t. }, ;
                                      { STRZERO( nCol, 4, 0 ) + " (" + STRZERO( nxPos, 7, 2 ) + ")", "#FFFFFF", .t. }, ;
                                      { STRZERO( _HMG_SYSDATA[ 150 ] [ 13 ], 3, 0 ), "#FFFFFF", .t. }, ;
                                      { PADR( IF( EMPTY( cTtfFnt ), "<Default>", cTtfFnt ), IF( HMG_Len( cTtfFnt ) > 30, HMG_Len( cTtfFnt ), 30 ) ), "#FFFFFF", .f. }, ;
                                      { STRZERO( nFontSize, 2, 0 ), "#FFFFFF", .t. }, ;
                                      { IF( lBold, "BOLD", SPACE( 4 ) ) + IF( lItalic, " ITALIC", SPACE( 7 ) ), "#FFFFFF", .f. }, ;
                                      { cFontName, IF( IF( EMPTY( cTtfFnt ), HMG_Len( cFontName ), HMG_Len( cTtfFnt ) ) == HMG_Len( cFontName ), "#FFFFFF", "#FFFF66" ), .f. } } )
      ENDIF
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_MULTILINE_PRINT()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_MULTILINE_PRINT( nRow, nCol, nToRow, nToCol, cFontName, nFontSize, nRColor, nGColor, nBColor, cText, lBold, lItalic, lUnderline, lStrikeout, lColor, lFont, lSize, cAlign )

LOCAL nWidth     := _HMG_SYSDATA[ 150 ] [ 4 ]
LOCAL nHeight    := _HMG_SYSDATA[ 150 ] [ 5 ]
LOCAL nTextWidth := 0
LOCAL nxPos      := _HMG_HPDF_MM2Pixel( nCol )
LOCAL nyPos      := nHeight - _HMG_HPDF_MM2Pixel( nRow )
LOCAL nToxPos    := nxPos + _HMG_HPDF_MM2Pixel( nToCol - nCol )
LOCAL nToyPos    := nyPos - _HMG_HPDF_MM2Pixel( nToRow - nRow )
LOCAL oFont      := Nil
LOCAL cFont      := ''
LOCAL cTtfFnt                                                         // Pablo June, 2014

   DEFAULT cFontName := ''
   DEFAULT nFontSize := 12
   DEFAULT nRColor := 0
   DEFAULT nGColor := 0
   DEFAULT nBColor := 0
   DEFAULT lBold := .f.
   DEFAULT lItalic := .f.
   DEFAULT lUnderline := .f.
   DEFAULT lStrikeout := .f.
   DEFAULT lColor := .f.
   DEFAULT lFont := .f.
   DEFAULT lSize := .f.
   DEFAULT cAlign := ''

   cTtfFnt := cFontName                                               // Pablo June, 2014

   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 7 ] == Nil                                // PDF Page object not found!
      _HMG_HPDF_Error( 5 )
      RETURN Nil
   ENDIF

   // set color
   IF lColor
      HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ] [ 7 ], nRColor / 255, nGColor / 255, nBColor / 255 )
   ELSE
      HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ] [ 7 ], 0.0, 0.0, 0.0 )
   ENDIF

   // set font
   IF HMG_LEN( ALLTRIM( cFontName ) ) == 0
      cFontName := _HMG_HPDF_SetFont( cFontName, lBold, lItalic )
      oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ] [ 1 ], cFontName, _HMG_SYSDATA[ 150 ] [ 10 ] )
   ELSE
      // cFontName := alltrim( cFontName )
      cFontName := ALLTRIM( _HMG_HPDF_SetFont( cFontName, lBold, lItalic ) )

      IF HMG_UPPER( cFileExt( cFontName ) ) == '.TTF'                 // load ttf font

         cFont := HPDF_LOADTTFONTFROMFILE( _HMG_SYSDATA[ 150 ] [ 1 ], cFontName, .t. )
         IF HMG_LEN( ALLTRIM( cFont ) ) == 0
            _HMG_HPDF_Error( 6, cFontName )
            RETURN Nil
         ENDIF
         oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ] [ 1 ], cFont, _HMG_SYSDATA[ 150 ] [ 10 ] )
      ELSE
         IF HMG_UPPER( ALLTRIM( cFontName ) ) == "SYMBOL" .OR. HMG_UPPER( ALLTRIM( cFontName ) ) == "ZAPFDINGBATS"
            oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ] [ 1 ], cFontName, Nil )
         ELSE
            oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ] [ 1 ], cFontName, _HMG_SYSDATA[ 150 ] [ 10 ] )
         ENDIF
      ENDIF
   ENDIF
   IF oFont == Nil
      _HMG_HPDF_Error( 6, cFontName )
      RETURN Nil
   ELSE
      HPDF_Page_SetFontAndSize( _HMG_SYSDATA[ 150 ] [ 7 ], oFont, nFontSize )
      HPDF_Page_BeginText( _HMG_SYSDATA[ 150 ] [ 7 ] )
      DO CASE
         CASE HMG_UPPER( cAlign ) == 'CENTER'
            HPDF_Page_TextRect( _HMG_SYSDATA[ 150 ] [ 7 ], nxPos, nyPos, nToxPos, nToyPos, cText, HPDF_TALIGN_CENTER, Nil )
         CASE HMG_UPPER( cAlign ) == 'RIGHT'
            HPDF_Page_TextRect( _HMG_SYSDATA[ 150 ] [ 7 ], nxPos, nyPos, nToxPos, nToyPos, cText, HPDF_TALIGN_RIGHT, Nil )
         CASE HMG_UPPER( cAlign ) == 'JUSTIFY'
            HPDF_Page_TextRect( _HMG_SYSDATA[ 150 ] [ 7 ], nxPos, nyPos, nToxPos, nToyPos, cText, HPDF_TALIGN_JUSTIFY, Nil )
         OTHERWISE
            HPDF_Page_TextRect( _HMG_SYSDATA[ 150 ] [ 7 ], nxPos, nyPos, nToxPos, nToyPos, cText, HPDF_TALIGN_LEFT, Nil )
      ENDCASE
      HPDF_Page_EndText( _HMG_SYSDATA[ 150 ] [ 7 ] )

      IF lDoLog                                                       // Pablo June, 2014
         HTML_TABLE_LINE( nFHandle, { { STRZERO( nRow, 4, 0 ) + " (" + STRZERO( nyPos, 7, 2 ) + ")", "#FFFFFF", .t. }, ;
                                      { STRZERO( nCol, 4, 0 ) + " (" + STRZERO( nxPos, 7, 2 ) + ")", "#FFFFFF", .t. }, ;
                                      { STRZERO( _HMG_SYSDATA[ 150 ] [ 13 ], 3, 0 ), "#FFFFFF", .t. }, ;
                                      { PADR( IF( EMPTY( cTtfFnt ), "<Default>", cTtfFnt ), IF( HMG_Len( cTtfFnt ) > 30, HMG_Len( cTtfFnt ), 30 ) ), "#FFFFFF", .f. }, ;
                                      { STRZERO( nFontSize, 2, 0 ), "#FFFFFF", .t. }, ;
                                      { IF( lBold, "BOLD", SPACE( 4 ) ) + IF( lItalic, " ITALIC", SPACE( 7 ) ), "#FFFFFF", .f. }, ;
                                      { cFontName, IF( IF( EMPTY( cTtfFnt ), HMG_Len( cFontName ), HMG_Len( cTtfFnt ) ) == HMG_Len( cFontName ), "#FFFFFF", "#FFFF66" ), .f. } } )
      ENDIF
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_LINE()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_LINE( nRow, nCol, nToRow, nToCol, nLineWidth, nRColor, nGColor, nBColor, lWidth, lColor )

LOCAL nWidth     := _HMG_SYSDATA[ 150 ] [ 4 ]
LOCAL nHeight    := _HMG_SYSDATA[ 150 ] [ 5 ]
LOCAL nTextWidth := 0
LOCAL nxPos      := _HMG_HPDF_MM2Pixel( nCol )
LOCAL nyPos      := nHeight - _HMG_HPDF_MM2Pixel( nRow )
LOCAL nToxPos    := nxPos + _HMG_HPDF_MM2Pixel( nToCol - nCol )
LOCAL nToyPos    := nyPos - _HMG_HPDF_MM2Pixel( nToRow - nRow )
   DEFAULT nRColor := 0
   DEFAULT nGColor := 0
   DEFAULT nBColor := 0
   DEFAULT nWidth := 1
   DEFAULT lWidth := .f.
   DEFAULT lColor := .f.

   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 7 ] == Nil                                // PDF Page object not found!
      _HMG_HPDF_Error( 5 )
      RETURN Nil
   ENDIF

   // set color
   IF lColor
      HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ] [ 7 ], nRColor / 255, nGColor / 255, nBColor / 255 )
   ELSE
      HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ] [ 7 ], 0.0, 0.0, 0.0 )
   ENDIF

   IF lWidth
      HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ] [ 7 ], _HMG_HPDF_MM2Pixel( nlineWidth ) )
   ELSE
      HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ] [ 7 ], 1 )
   ENDIF
   HPDF_Page_MoveTo( _HMG_SYSDATA[ 150 ] [ 7 ], nxPos, nyPos )
   HPDF_Page_LineTo( _HMG_SYSDATA[ 150 ] [ 7 ], nToxPos, nToyPos )
   HPDF_Page_Stroke( _HMG_SYSDATA[ 150 ] [ 7 ] )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_RECTANGLE()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_RECTANGLE( nRow, nCol, nToRow, nToCol, nLineWidth, nRColor, nGColor, nBColor, lWidth, lColor, lFilled )

LOCAL nWidth     := _HMG_SYSDATA[ 150 ] [ 4 ]
LOCAL nHeight    := _HMG_SYSDATA[ 150 ] [ 5 ]
LOCAL nTextWidth := 0
LOCAL nxPos      := _HMG_HPDF_MM2Pixel( nCol )
LOCAL nyPos      := nHeight - _HMG_HPDF_MM2Pixel( nRow )
LOCAL nToxPos    := nxPos + _HMG_HPDF_MM2Pixel( nToCol - nCol )
LOCAL nToyPos    := nyPos - _HMG_HPDF_MM2Pixel( nToRow - nRow )
   DEFAULT nRColor := 0
   DEFAULT nGColor := 0
   DEFAULT nBColor := 0
   DEFAULT nWidth := 1
   DEFAULT lWidth := .f.
   DEFAULT lColor := .f.
   DEFAULT lFilled := .f.

   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 7 ] == Nil                                // PDF Page object not found!
      _HMG_HPDF_Error( 5 )
      RETURN Nil
   ENDIF

   // set color
   IF lColor
      HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ] [ 7 ], nRColor / 255, nGColor / 255, nBColor / 255 )
      IF lFilled
         HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ] [ 7 ], nRColor / 255, nGColor / 255, nBColor / 255 )
      ENDIF
   ELSE
      HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ] [ 7 ], 0.0, 0.0, 0.0 )
   ENDIF

   IF lWidth
      HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ] [ 7 ], _HMG_HPDF_MM2Pixel( nlineWidth ) )
   ELSE
      HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ] [ 7 ], 1 )
   ENDIF
   HPDF_Page_Rectangle( _HMG_SYSDATA[ 150 ] [ 7 ], nxPos, nyPos - _HMG_HPDF_MM2Pixel( nToRow - nRow ), _HMG_HPDF_MM2Pixel( nToCol - nCol ), _HMG_HPDF_MM2Pixel( nToRow - nRow ) )
   IF lFilled
      HPDF_Page_FillStroke( _HMG_SYSDATA[ 150 ] [ 7 ] )
   ELSE
      HPDF_Page_Stroke( _HMG_SYSDATA[ 150 ] [ 7 ] )
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_ROUNDRECTANGLE()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_ROUNDRECTANGLE( nRow, nCol, nToRow, nToCol, nLineWidth, nRColor, nGColor, nBColor, lWidth, lColor, lFilled, nRoundness )

LOCAL nWidth      := _HMG_SYSDATA[ 150 ] [ 4 ]
LOCAL nHeight     := _HMG_SYSDATA[ 150 ] [ 5 ]
LOCAL nTextWidth  := 0
LOCAL nxPos       := _HMG_HPDF_MM2Pixel( nCol )
LOCAL nyPos       := nHeight - _HMG_HPDF_MM2Pixel( nRow )
LOCAL nToxPos     := nxPos + _HMG_HPDF_MM2Pixel( nToCol - nCol )
LOCAL nToyPos     := nyPos - _HMG_HPDF_MM2Pixel( nToRow - nRow )
LOCAL nRectWidth  := nToCol - nCol
LOCAL nRectHeight := nToRow - nRow
   DEFAULT nRColor := 0
   DEFAULT nGColor := 0
   DEFAULT nBColor := 0
   DEFAULT nWidth := 1
   DEFAULT lWidth := .f.
   DEFAULT lColor := .f.
   DEFAULT lFilled := .f.
   DEFAULT nRoundness := 0
   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 7 ] == Nil                                // PDF Page object not found!
      _HMG_HPDF_Error( 5 )
      RETURN Nil
   ENDIF
   // set color
   IF lColor
      HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ] [ 7 ], nRColor / 255, nGColor / 255, nBColor / 255 )
      IF lFilled
         HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ] [ 7 ], nRColor / 255, nGColor / 255, nBColor / 255 )
      ENDIF
   ELSE
      HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ] [ 7 ], 0.0, 0.0, 0.0 )
   ENDIF
   // set line Width
   IF lWidth
      HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ] [ 7 ], _HMG_HPDF_MM2Pixel( nlineWidth ) )
   ELSE
      HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ] [ 7 ], 1 )
   ENDIF
   IF nRoundness == 0
      nRoundness := INT( MIN( nRectWidth, nRectHeight ) * 10 / 100 )
   ELSE
      IF nRoundness > INT( MIN( nRectWidth, nRectHeight ) / 2 )
         _HMG_HPDF_Error( 8 )
         RETURN Nil
      ENDIF
   ENDIF

   nRoundness := _HMG_HPDF_MM2Pixel( nRoundness )

   // start rounded rectangle path
   HPDF_Page_MoveTo( _HMG_SYSDATA[ 150 ] [ 7 ], nxPos + nRoundness, nyPos )                                                                 // top line left position
   HPDF_Page_LineTo( _HMG_SYSDATA[ 150 ] [ 7 ], nToxPos - nRoundness, nyPos )                                                               // draw top line
   HPDF_Page_CurveTo2( _HMG_SYSDATA[ 150 ] [ 7 ], nToxPos, nyPos, nToxPos, nyPos - nRoundness )                                             // draw top right curve
   HPDF_Page_LineTo( _HMG_SYSDATA[ 150 ] [ 7 ], nToxPos, nToyPos + nRoundness )                                                             // draw right line
   HPDF_Page_CurveTo2( _HMG_SYSDATA[ 150 ] [ 7 ], nToxPos, nToyPos, nToxPos - nRoundness, nToyPos )                                         // draw bottom right curve
   HPDF_Page_LineTo( _HMG_SYSDATA[ 150 ] [ 7 ], nxPos + nRoundness, nToyPos )                                                               // draw bottom line
   HPDF_Page_CurveTo2( _HMG_SYSDATA[ 150 ] [ 7 ], nxPos, nToyPos, nxPos, nToyPos + nRoundness )                                             // draw bottom left curve
   HPDF_Page_LineTo( _HMG_SYSDATA[ 150 ] [ 7 ], nxPos, nyPos - nRoundness )                                                                 // draw left line
   HPDF_Page_CurveTo2( _HMG_SYSDATA[ 150 ] [ 7 ], nxPos, nyPos, nxPos + nRoundness, nyPos )                                                 // draw top left curve

   // now start and finish drawing along the path
   IF lFilled
      HPDF_Page_FillStroke( _HMG_SYSDATA[ 150 ] [ 7 ] )
   ELSE
      HPDF_Page_Stroke( _HMG_SYSDATA[ 150 ] [ 7 ] )
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_CIRCLE()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_CIRCLE( nRow, nCol, nR, nLineWidth, nRColor, nGColor, nBColor, lWidth, lColor, lFilled )

LOCAL nWidth  := _HMG_SYSDATA[ 150 ] [ 4 ]
LOCAL nHeight := _HMG_SYSDATA[ 150 ] [ 5 ]
LOCAL nxPos   := _HMG_HPDF_MM2Pixel( nCol )
LOCAL nyPos   := nHeight - _HMG_HPDF_MM2Pixel( nRow )
   DEFAULT nWidth := 1
   DEFAULT lWidth := .f.
   DEFAULT lColor := .f.
   DEFAULT lFilled := .f.
   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 7 ] == Nil                                // PDF Page object not found!
      _HMG_HPDF_Error( 5 )
      RETURN Nil
   ENDIF

   // set color
   IF lColor
      HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ] [ 7 ], nRColor / 255, nGColor / 255, nBColor / 255 )
      IF lFilled
         HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ] [ 7 ], nRColor / 255, nGColor / 255, nBColor / 255 )
      ENDIF
   ELSE
      HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ] [ 7 ], 0.0, 0.0, 0.0 )
   ENDIF
   // set line Width
   IF lWidth
      HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ] [ 7 ], _HMG_HPDF_MM2Pixel( nlineWidth ) )
   ELSE
      HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ] [ 7 ], 1 )
   ENDIF
   HPDF_Page_Circle( _HMG_SYSDATA[ 150 ] [ 7 ], nxPos, nyPos, _HMG_HPDF_MM2Pixel( nR ) )
   IF lFilled
      HPDF_Page_FillStroke( _HMG_SYSDATA[ 150 ] [ 7 ] )
   ELSE
      HPDF_Page_Stroke( _HMG_SYSDATA[ 150 ] [ 7 ] )
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_ELLIPSE()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_ELLIPSE( nRow, nCol, nHR, nVR, nLineWidth, nRColor, nGColor, nBColor, lWidth, lColor, lFilled )

LOCAL nWidth  := _HMG_SYSDATA[ 150 ] [ 4 ]
LOCAL nHeight := _HMG_SYSDATA[ 150 ] [ 5 ]
LOCAL nxPos   := _HMG_HPDF_MM2Pixel( nCol )
LOCAL nyPos   := nHeight - _HMG_HPDF_MM2Pixel( nRow )
   DEFAULT nWidth := 1
   DEFAULT lWidth := .f.
   DEFAULT lColor := .f.
   DEFAULT lFilled := .f.
   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 7 ] == Nil                                // PDF Page object not found!
      _HMG_HPDF_Error( 5 )
      RETURN Nil
   ENDIF

   // set color
   IF lColor
      HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ] [ 7 ], nRColor / 255, nGColor / 255, nBColor / 255 )
      IF lFilled
         HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ] [ 7 ], nRColor / 255, nGColor / 255, nBColor / 255 )
      ENDIF
   ELSE
      HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ] [ 7 ], 0.0, 0.0, 0.0 )
   ENDIF
   // set line Width
   IF lWidth
      HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ] [ 7 ], _HMG_HPDF_MM2Pixel( nlineWidth ) )
   ELSE
      HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ] [ 7 ], 1 )
   ENDIF
   HPDF_Page_Ellipse( _HMG_SYSDATA[ 150 ] [ 7 ], nxPos, nyPos, _HMG_HPDF_MM2Pixel( nHR ), _HMG_HPDF_MM2Pixel( nVR ) )
   IF lFilled
      HPDF_Page_FillStroke( _HMG_SYSDATA[ 150 ] [ 7 ] )
   ELSE
      HPDF_Page_Stroke( _HMG_SYSDATA[ 150 ] [ 7 ] )
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_ARC()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_ARC( nRow, nCol, nR, nFromAngle, nToAngle, nLineWidth, nRColor, nGColor, nBColor, lWidth, lColor )

LOCAL nWidth  := _HMG_SYSDATA[ 150 ] [ 4 ]
LOCAL nHeight := _HMG_SYSDATA[ 150 ] [ 5 ]
LOCAL nxPos   := _HMG_HPDF_MM2Pixel( nCol )
LOCAL nyPos   := nHeight - _HMG_HPDF_MM2Pixel( nRow )
   DEFAULT nWidth := 1
   DEFAULT lWidth := .f.
   DEFAULT lColor := .f.
   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 7 ] == Nil                                // PDF Page object not found!
      _HMG_HPDF_Error( 5 )
      RETURN Nil
   ENDIF

   // set color
   IF lColor
      HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ] [ 7 ], nRColor / 255, nGColor / 255, nBColor / 255 )
   ELSE
      HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ] [ 7 ], 0.0, 0.0, 0.0 )
   ENDIF
   // set line Width
   IF lWidth
      HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ] [ 7 ], _HMG_HPDF_MM2Pixel( nlineWidth ) )
   ELSE
      HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ] [ 7 ], 1 )
   ENDIF
   HPDF_Page_Arc( _HMG_SYSDATA[ 150 ] [ 7 ], nxPos, nyPos, _HMG_HPDF_MM2Pixel( nR ), nFromAngle, nToAngle )
   HPDF_Page_Stroke( _HMG_SYSDATA[ 150 ] [ 7 ] )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_CURVE()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_CURVE( nRow, nCol, nFromRow, nFromCol, nToRow, nToCol, nLineWidth, nRColor, nGColor, nBColor, lWidth, lColor )

LOCAL nWidth     := _HMG_SYSDATA[ 150 ] [ 4 ]
LOCAL nHeight    := _HMG_SYSDATA[ 150 ] [ 5 ]
LOCAL nTextWidth := 0
LOCAL nxPos      := _HMG_HPDF_MM2Pixel( nCol )
LOCAL nyPos      := nHeight - _HMG_HPDF_MM2Pixel( nRow )
LOCAL nToxPos    := nxPos + _HMG_HPDF_MM2Pixel( nToCol - nCol )
LOCAL nToyPos    := nyPos - _HMG_HPDF_MM2Pixel( nToRow - nRow )
LOCAL nFromxPos  := _HMG_HPDF_MM2Pixel( nFromCol )
LOCAL nFromyPos  := nHeight - _HMG_HPDF_MM2Pixel( nFromRow )
   DEFAULT nRColor := 0
   DEFAULT nGColor := 0
   DEFAULT nBColor := 0
   DEFAULT nWidth := 1
   DEFAULT lWidth := .f.
   DEFAULT lColor := .f.

   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 7 ] == Nil                                // PDF Page object not found!
      _HMG_HPDF_Error( 5 )
      RETURN Nil
   ENDIF

   // set color
   IF lColor
      HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ] [ 7 ], nRColor / 255, nGColor / 255, nBColor / 255 )
   ELSE
      HPDF_Page_SetRGBSTROKE( _HMG_SYSDATA[ 150 ] [ 7 ], 0.0, 0.0, 0.0 )
   ENDIF

   IF lWidth
      HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ] [ 7 ], _HMG_HPDF_MM2Pixel( nlineWidth ) )
   ELSE
      HPDF_Page_SetLineWidth( _HMG_SYSDATA[ 150 ] [ 7 ], 1 )
   ENDIF
   HPDF_Page_MoveTo( _HMG_SYSDATA[ 150 ] [ 7 ], nxPos, nyPos )
   HPDF_Page_CurveTo2( _HMG_SYSDATA[ 150 ] [ 7 ], nFromxPos, nFromyPos, nToxPos, nToyPos )
   HPDF_Page_Stroke( _HMG_SYSDATA[ 150 ] [ 7 ] )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_IMAGE()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_savepages()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_IMAGE( cImage, nRow, nCol, nImageheight, nImageWidth, lStretch, cImageType )

LOCAL nWidth  := _HMG_SYSDATA[ 150 ] [ 4 ]
LOCAL nHeight := _HMG_SYSDATA[ 150 ] [ 5 ]
LOCAL nxPos   := _HMG_HPDF_MM2Pixel( nCol )
LOCAL nyPos   := nHeight - _HMG_HPDF_MM2Pixel( nRow )
LOCAL oImage  := Nil
   DEFAULT lStretch := .f.
   DEFAULT cImageType := "PNG"

   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 7 ] == Nil                                // PDF Page object not found!
      _HMG_HPDF_Error( 5 )
      RETURN Nil
   ENDIF

   DO CASE
      CASE HMG_UPPER( ALLTRIM( cImageType ) ) = "PNG"
         oImage := _HPDF_LOAD_PNG( _HMG_SYSDATA[ 150 ] [ 1 ], cImage )
      CASE HMG_UPPER( ALLTRIM( cImageType ) ) = "JPG"
         oImage := _HPDF_LOAD_JPG( _HMG_SYSDATA[ 150 ] [ 1 ], cImage )
      OTHERWISE
         _HMG_HPDF_Error( 20 )
   ENDCASE

   IF oImage = Nil
      _HMG_HPDF_Error( 7 )
      RETURN Nil
   ENDIF

   IF EMPTY( oImage )
      _HMG_HPDF_Error( 7 )
      RETURN Nil
   ENDIF
   HPDF_Page_DrawImage( _HMG_SYSDATA[ 150 ] [ 7 ], oImage, nxPos, nyPos - _HMG_HPDF_MM2Pixel( nImageHeight ), _HMG_HPDF_MM2Pixel( nImageWidth ), _HMG_HPDF_MM2Pixel( nImageHeight ) )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_SetPassword()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_SetPassword( cOwnerPass, cUserPass )

   DEFAULT cUserPass := ''
   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   HPDF_SetPassword( _HMG_SYSDATA[ 150 ] [ 1 ], cOwnerPass, cUserPass )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_SetCompression()
*+
*+    Called from ( h_controlmisc.prg )   1 - function _hmg_printer_savepages()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_SetCompression( cMode )

   DEFAULT cMode := ''
   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   cMode := HMG_UPPER( cMode )
   DO CASE
      CASE cMode == 'NONE'
         HPDF_SetCompressionMode( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_COMP_NONE )
      CASE cMode == 'TEXT'
         HPDF_SetCompressionMode( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_COMP_TEXT )
      CASE cMode == 'IMAGE'
         HPDF_SetCompressionMode( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_COMP_IMAGE )
      CASE cMode == 'METADATA'
         HPDF_SetCompressionMode( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_COMP_METADATA )
      CASE cMode == 'ALL'
         HPDF_SetCompressionMode( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_COMP_ALL )
      OTHERWISE
         HPDF_SetCompressionMode( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_COMP_NONE )
   ENDCASE
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_SetPermission()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_SetPermission( cMode )

   DEFAULT cMode := ''
   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   cMode := HMG_UPPER( cMode )
   DO CASE
      CASE cMode == 'READ'
         HPDF_SetPermission( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_ENABLE_READ )
      CASE cMode == 'PRINT'
         HPDF_SetPermission( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_ENABLE_PRINT )
      CASE cMode == 'COPY'
         HPDF_SetPermission( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_ENABLE_COPY )
      CASE cMode == 'EDIT'
         HPDF_SetPermission( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_ENABLE_EDIT )
      CASE cMode == 'EDIT_ALL'
         HPDF_SetPermission( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_ENABLE_EDIT_ALL )
   ENDCASE
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_SetPageMode()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_SetPageMode( cMode )

   DEFAULT cMode := ''
   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   cMode := HMG_UPPER( cMode )
   DO CASE
      CASE cMode == 'OUTLINE'
         HPDF_SetPageMode( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_PAGE_MODE_USE_OUTLINE )
      CASE cMode == 'NONE'
         HPDF_SetPageMode( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_PAGE_MODE_USE_NONE )
      CASE cMode == 'THUMBS'
         HPDF_SetPageMode( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_PAGE_MODE_USE_THUMBS )
      CASE cMode == 'FULL_SCREEN'
         HPDF_SetPageMode( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_PAGE_MODE_FULL_SCREEN )
      CASE cMode == 'EOF'
         HPDF_SetPageMode( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_PAGE_MODE_EOF )
   ENDCASE
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_RootOutline()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_RootOutline( cTitle, cName, cParent )

LOCAL aOutlines := {}
LOCAL oOutline  := Nil
LOCAL i
   DEFAULT cParent := ''
   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   IF HMG_LEN( ALLTRIM( cTitle ) ) == 0
      _HMG_HPDF_Error( 11 )
      RETURN Nil
   ENDIF
   IF HMG_LEN( ALLTRIM( cName ) ) == 0
      _HMG_HPDF_Error( 12 )
      RETURN Nil
   ENDIF
   IF HMG_LEN( ALLTRIM( cParent ) ) == 0                              // make this a root outline
      oOutline := HPDF_CreateOutline( _HMG_SYSDATA[ 150 ] [ 1 ], Nil, cTitle, HPDF_GetCurrentEncoder() )
      IF EMPTY( oOutLine )
         _HMG_HPDF_Error( 10 )
         RETURN Nil
      ELSE
         AADD( _HMG_SYSDATA[ 150 ] [ 11 ], { oOutline, cName } )
      ENDIF
   ELSE
      aOutLines := ACLONE( _HMG_SYSDATA[ 150 ] [ 11 ] )
      FOR i := 1 TO HMG_LEN( aOutLines )
         IF HMG_UPPER( ALLTRIM( aOutLines[ i, 2 ] ) ) == HMG_UPPER( ALLTRIM( cParent ) )
            oOutline := HPDF_CreateOutline( _HMG_SYSDATA[ 150 ] [ 1 ], aOutLines[ i, 1 ], cTitle, HPDF_GetCurrentEncoder() )
            IF EMPTY( oOutLine )
               _HMG_HPDF_Error( 10 )
               RETURN Nil
            ELSE
               AADD( _HMG_SYSDATA[ 150 ] [ 11 ], { oOutline, cName } )
            ENDIF
            EXIT
         ENDIF
      NEXT i
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_PageOutline()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_PageOutline( cTitle, cParent, cName )

LOCAL aOutlines    := {}
LOCAL oOutline     := Nil
LOCAL oDestination := Nil
LOCAL i
   DEFAULT cParent := ''
   DEFAULT cName := ''
   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 7 ] == Nil                                // PDF Page object not found!
      _HMG_HPDF_Error( 5 )
      RETURN Nil
   ENDIF
   oDestination := HPDF_Page_CreateDestination( _HMG_SYSDATA[ 150 ] [ 7 ] )
   IF EMPTY( oDestination )
      _HMG_HPDF_Error( 13 )
      RETURN Nil
   ENDIF
   IF HMG_LEN( ALLTRIM( cParent ) ) == 0                              // No parent make this page root element
      oOutline := HPDF_CreateOutline( _HMG_SYSDATA[ 150 ] [ 1 ], Nil, cTitle, HPDF_GetCurrentEncoder() )
      IF EMPTY( oOutline )
         _HMG_HPDF_Error( 13 )
         RETURN Nil
      ENDIF
   ELSE
      aOutlines := ACLONE( _HMG_SYSDATA[ 150 ] [ 11 ] )
      FOR i := 1 TO HMG_LEN( aOutlines )
         IF HMG_UPPER( ALLTRIM( aOutlines[ i, 2 ] ) ) == HMG_UPPER( ALLTRIM( cParent ) )
            oOutline := HPDF_CreateOutline( _HMG_SYSDATA[ 150 ] [ 1 ], aOutlines[ i, 1 ], cTitle, HPDF_GetCurrentEncoder() )
            EXIT
         ENDIF
      NEXT i
      IF EMPTY( oOutline )
         _HMG_HPDF_Error( 14 )
         RETURN Nil
      ENDIF
   ENDIF
   IF HMG_LEN( ALLTRIM( cName ) ) > 0
      AADD( _HMG_SYSDATA[ 150 ] [ 11 ], { oOutline, cName } )
   ENDIF
   HPDF_Outline_SetDestination( oOutline, oDestination )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_SetTextAnnot()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_SetTextAnnot( nRow, nCol, cToolTip, cIcon )

LOCAL nWidth  := _HMG_SYSDATA[ 150 ] [ 4 ]
LOCAL nHeight := _HMG_SYSDATA[ 150 ] [ 5 ]
LOCAL nToRow  := nRow + 5
LOCAL nToCol  := nCol + 5
LOCAL nxPos   := _HMG_HPDF_MM2Pixel( nCol )
LOCAL nyPos   := nHeight - _HMG_HPDF_MM2Pixel( nRow )
LOCAL nToxPos := nxPos + _HMG_HPDF_MM2Pixel( nToCol - nCol )
LOCAL nToyPos := nyPos - _HMG_HPDF_MM2Pixel( nToRow - nRow )
LOCAL aRect   := { nxPos, nyPos, nToxPos, nToyPos }
LOCAL oAnnot  := Nil
   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 7 ] == Nil                                // PDF Page object not found!
      _HMG_HPDF_Error( 5 )
      RETURN Nil
   ENDIF
   oAnnot := HPDF_Page_CreateTextAnnot( _HMG_SYSDATA[ 150 ] [ 7 ], aRect, cTooltip, HPDF_GetCurrentEncoder() )
   IF EMPTY( oAnnot )
      _HMG_HPDF_Error( 15 )
      RETURN Nil
   ENDIF
   DO CASE
      CASE HMG_UPPER( ALLTRIM( cIcon ) ) == "COMMENT"
         HPDF_TextAnnot_SetIcon( oAnnot, HPDF_ANNOT_ICON_COMMENT )
      CASE HMG_UPPER( ALLTRIM( cIcon ) ) == "KEY"
         HPDF_TextAnnot_SetIcon( oAnnot, HPDF_ANNOT_ICON_KEY )
      CASE HMG_UPPER( ALLTRIM( cIcon ) ) == "NOTE"
         HPDF_TextAnnot_SetIcon( oAnnot, HPDF_ANNOT_ICON_NOTE )
      CASE HMG_UPPER( ALLTRIM( cIcon ) ) == "HELP"
         HPDF_TextAnnot_SetIcon( oAnnot, HPDF_ANNOT_ICON_HELP )
      CASE HMG_UPPER( ALLTRIM( cIcon ) ) == "NEW_PARAGRAPH"
         HPDF_TextAnnot_SetIcon( oAnnot, HPDF_ANNOT_ICON_NEW_PARAGRAPH )
      CASE HMG_UPPER( ALLTRIM( cIcon ) ) == "PARAGRAPH"
         HPDF_TextAnnot_SetIcon( oAnnot, HPDF_ANNOT_ICON_PARAGRAPH )
      CASE HMG_UPPER( ALLTRIM( cIcon ) ) == "INSERT"
         HPDF_TextAnnot_SetIcon( oAnnot, HPDF_ANNOT_ICON_INSERT )
   ENDCASE
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_SetPageLink()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_SetPageLink( nRow, nCol, cText, nPage, cFontName, nFontSize, nRColor, nGColor, nBColor, cAlign, lColor, lFont, lSize, lBorder, lWidth, nBorderWidth )

LOCAL nWidth     := _HMG_SYSDATA[ 150 ] [ 4 ]
LOCAL nHeight    := _HMG_SYSDATA[ 150 ] [ 5 ]
LOCAL nTextWidth := 0
LOCAL nxPos      := _HMG_HPDF_MM2Pixel( nCol )
LOCAL nyPos      := nHeight - _HMG_HPDF_MM2Pixel( nRow )
LOCAL oFont      := Nil
LOCAL cFont      := ''
LOCAL aRect      := { }
LOCAL aCurXY     := {}
LOCAL oAnnot     := Nil
LOCAL oDest      := Nil
LOCAL aPages     := {}
LOCAL oLinkPage  := Nil
   DEFAULT cFontName := ''
   DEFAULT nFontSize := 12
   DEFAULT nRColor := 0
   DEFAULT nGColor := 0
   DEFAULT nBColor := 0
   DEFAULT lColor := .f.
   DEFAULT lFont := .f.
   DEFAULT lSize := .f.
   DEFAULT cAlign := ''
   DEFAULT lBorder := .f.
   DEFAULT lWidth := .f.
   DEFAULT nBorderWidth := 0

   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 7 ] == Nil                                // PDF Page object not found!
      _HMG_HPDF_Error( 5 )
      RETURN Nil
   ENDIF

   aPages := ACLONE( _HMG_SYSDATA[ 150 ] [ 12 ] )
   IF nPage > HMG_LEN( aPages ) .OR. nPage < 1
      _HMG_HPDF_Error( 17 )
      RETURN Nil
   ENDIF

   oLinkPage := aPages[ nPage ]
   IF EMPTY( oLinkPage )
      _HMG_HPDF_Error( 17 )
      RETURN Nil
   ENDIF
   oDest := HPDF_Page_CreateDestination( oLinkPage )
   IF EMPTY( oDest )
      _HMG_HPDF_Error( 17 )
      RETURN Nil
   ENDIF

   // set color
   IF lColor
      HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ] [ 7 ], nRColor / 255, nGColor / 255, nBColor / 255 )
   ELSE
      HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ] [ 7 ], 0.0, 0.0, 0.0 )
   ENDIF

   // set font
   IF HMG_LEN( ALLTRIM( cFontName ) ) == 0
      cFontName := _HMG_HPDF_SetFont( cFontName )
      oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ] [ 1 ], cFontName, _HMG_SYSDATA[ 150 ] [ 10 ] )
   ELSE
      // cFontName := alltrim( cFontName )
      cFontName := ALLTRIM( _HMG_HPDF_SetFont( cFontName ) )

      IF HMG_UPPER( cFileExt( cFontName ) ) == '.TTF'                 // load ttf font

         cFont := HPDF_LOADTTFONTFROMFILE( _HMG_SYSDATA[ 150 ] [ 1 ], cFontName, .t. )
         IF HMG_LEN( ALLTRIM( cFont ) ) == 0
            _HMG_HPDF_Error( 6, cFontName )
            RETURN Nil
         ENDIF
         oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ] [ 1 ], cFont, _HMG_SYSDATA[ 150 ] [ 10 ] )
      ELSE
         IF HMG_UPPER( ALLTRIM( cFontName ) ) == "SYMBOL" .OR. HMG_UPPER( ALLTRIM( cFontName ) ) == "ZAPFDINGBATS"
            oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ] [ 1 ], cFontName, Nil )
         ELSE
            oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ] [ 1 ], cFontName, _HMG_SYSDATA[ 150 ] [ 10 ] )
         ENDIF
      ENDIF
   ENDIF
   IF oFont == Nil
      _HMG_HPDF_Error( 6, cFontName )
      RETURN Nil
   ELSE
      HPDF_Page_SetFontAndSize( _HMG_SYSDATA[ 150 ] [ 7 ], oFont, nFontSize )
      nTextWidth := HPDF_Page_TextWidth( _HMG_SYSDATA[ 150 ] [ 7 ], cText )
      DO CASE
         CASE HMG_UPPER( ALLTRIM( cAlign ) ) == 'CENTER'
            nxPos := nxPos - ( nTextWidth / 2 )
         CASE HMG_UPPER( ALLTRIM( cAlign ) ) == 'RIGHT'
            nxPos := nxPos - ( nTextWidth )
      ENDCASE
      HPDF_Page_BeginText( _HMG_SYSDATA[ 150 ] [ 7 ] )
      HPDF_PAGE_TEXTOUT( _HMG_SYSDATA[ 150 ] [ 7 ], nxPos, nyPos, cText )
      aRect := { nxPos - 4, nyPos + nFontsize + 4, nxPos + nTextWidth + 4, nyPos - 4 }
      oAnnot := HPDF_Page_CreateLinkAnnot( _HMG_SYSDATA[ 150 ] [ 7 ], aRect, oDest )
      IF lBorder
         IF nBorderWidth == 0
            nBorderWidth := 1
         ELSE
            nBorderWidth := _HMG_HPDF_MM2Pixel( nBorderWidth )
         ENDIF
         HPDF_LinkAnnot_SetBorderStyle( oAnnot, nBorderWidth, 0, 0 )
      ELSE
         HPDF_LinkAnnot_SetBorderStyle( oAnnot, 0, 0, 0 )
      ENDIF
      HPDF_Page_EndText( _HMG_SYSDATA[ 150 ] [ 7 ] )
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_SetURLLink()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_SetURLLink( nRow, nCol, cText, cLink, cFontName, nFontSize, nRColor, nGColor, nBColor, cAlign, lColor, lFont, lSize, lBold, lItalic )

LOCAL nWidth     := _HMG_SYSDATA[ 150 ] [ 4 ]
LOCAL nHeight    := _HMG_SYSDATA[ 150 ] [ 5 ]
LOCAL nTextWidth := 0
LOCAL nxPos      := _HMG_HPDF_MM2Pixel( nCol )
LOCAL nyPos      := nHeight - _HMG_HPDF_MM2Pixel( nRow )
LOCAL oFont      := Nil
LOCAL cFont      := ''
LOCAL aRect      := { }
LOCAL aCurXY     := {}
LOCAL oAnnot     := Nil
   DEFAULT cFontName := ''
   DEFAULT nFontSize := 12
   DEFAULT nRColor := 0
   DEFAULT nGColor := 0
   DEFAULT nBColor := 0
   DEFAULT lColor := .f.
   DEFAULT lFont := .f.
   DEFAULT lSize := .f.
   DEFAULT lBold := .f.
   DEFAULT lItalic := .f.
   DEFAULT cAlign := ''

   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 7 ] == Nil                                // PDF Page object not found!
      _HMG_HPDF_Error( 5 )
      RETURN Nil
   ENDIF

   // set color
   IF lColor
      HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ] [ 7 ], nRColor / 255, nGColor / 255, nBColor / 255 )
   ELSE
      HPDF_Page_SetRGBFill( _HMG_SYSDATA[ 150 ] [ 7 ], 0.0, 0.0, 0.0 )
   ENDIF

   // set font
   IF HMG_LEN( ALLTRIM( cFontName ) ) == 0
      cFontName := _HMG_HPDF_SetFont( cFontName )
      oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ] [ 1 ], cFontName, _HMG_SYSDATA[ 150 ] [ 10 ] )
   ELSE
      // cFontName := alltrim( cFontName )
      cFontName := ALLTRIM( _HMG_HPDF_SetFont( cFontName, lBold, lItalic ) )

      IF HMG_UPPER( cFileExt( cFontName ) ) == '.TTF'                 // load ttf font

         cFont := HPDF_LOADTTFONTFROMFILE( _HMG_SYSDATA[ 150 ] [ 1 ], cFontName, .t. )
         IF HMG_LEN( ALLTRIM( cFont ) ) == 0
            _HMG_HPDF_Error( 6, cFontName )
            RETURN Nil
         ENDIF
         oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ] [ 1 ], cFont, _HMG_SYSDATA[ 150 ] [ 10 ] )
      ELSE
         IF HMG_UPPER( ALLTRIM( cFontName ) ) == "SYMBOL" .OR. HMG_UPPER( ALLTRIM( cFontName ) ) == "ZAPFDINGBATS"
            oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ] [ 1 ], cFontName, Nil )
         ELSE
            oFont := HPDF_GetFont( _HMG_SYSDATA[ 150 ] [ 1 ], cFontName, _HMG_SYSDATA[ 150 ] [ 10 ] )
         ENDIF
      ENDIF
   ENDIF
   IF oFont == Nil
      _HMG_HPDF_Error( 6, cFontName )
      RETURN Nil
   ELSE
      HPDF_Page_SetFontAndSize( _HMG_SYSDATA[ 150 ] [ 7 ], oFont, nFontSize )
      nTextWidth := HPDF_Page_TextWidth( _HMG_SYSDATA[ 150 ] [ 7 ], cText )
      DO CASE
         CASE HMG_UPPER( ALLTRIM( cAlign ) ) == 'CENTER'
            nxPos := nxPos - ( nTextWidth / 2 )
         CASE HMG_UPPER( ALLTRIM( cAlign ) ) == 'RIGHT'
            nxPos := nxPos - ( nTextWidth )
      ENDCASE
      HPDF_Page_BeginText( _HMG_SYSDATA[ 150 ] [ 7 ] )
      HPDF_PAGE_TEXTOUT( _HMG_SYSDATA[ 150 ] [ 7 ], nxPos, nyPos, cText )
      aRect := { nxPos - 4, nyPos + nFontsize + 4, nxPos + nTextWidth + 4, nyPos - 4 }
      HPDF_Page_CreateURILinkAnnot( _HMG_SYSDATA[ 150 ] [ 7 ], aRect, cLink )
      HPDF_Page_EndText( _HMG_SYSDATA[ 150 ] [ 7 ] )
   ENDIF
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_SetLineSpacing()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_SetLineSpacing( nSpacing )

   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   IF _HMG_SYSDATA[ 150 ] [ 7 ] == Nil                                // PDF Page object not found!
      _HMG_HPDF_Error( 5 )
      RETURN Nil
   ENDIF
   HPDF_Page_SetTextLeading( _HMG_SYSDATA[ 150 ] [ 7 ], _HMG_HPDF_MM2Pixel( nSpacing ) )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_SetInfo()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_SetInfo( cAttrib, xValue, cTime )

LOCAL cValue   := ''
LOCAL dValue   := ''
LOCAL nHours   := 0
LOCAL nMinutes := 0
LOCAL nSeconds := 0
   DEFAULT cTime := ''
   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   DO CASE
      CASE VALTYPE( xValue ) == 'D'
         dValue := xValue
      OTHERWISE
         cValue := xValue
   ENDCASE
   DO CASE
      CASE HMG_UPPER( ALLTRIM( cAttrib ) ) == "AUTHOR"
         HPDF_SetInfoAttr( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_INFO_AUTHOR, cValue )
      CASE HMG_UPPER( ALLTRIM( cAttrib ) ) == "CREATOR"
         HPDF_SetInfoAttr( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_INFO_CREATOR, cValue )
      CASE HMG_UPPER( ALLTRIM( cAttrib ) ) == "TITLE"
         HPDF_SetInfoAttr( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_INFO_TITLE, cValue )
      CASE HMG_UPPER( ALLTRIM( cAttrib ) ) == "SUBJECT"
         HPDF_SetInfoAttr( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_INFO_SUBJECT, cValue )
      CASE HMG_UPPER( ALLTRIM( cAttrib ) ) == "KEYWORDS"
         HPDF_SetInfoAttr( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_INFO_KEYWORDS, cValue )
      CASE HMG_UPPER( ALLTRIM( cAttrib ) ) == "DATECREATED"
         IF HMG_LEN( ALLTRIM( cTime ) ) > 0
            nHours := VAL( HB_USUBSTR( cTime, 1, 2 ) )
            nMinutes := VAL( HB_USUBSTR( cTime, 4, 2 ) )
            nSeconds := VAL( HB_USUBSTR( cTime, 7, 2 ) )
         ENDIF
         HPDF_SetInfoDateAttr( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_INFO_CREATION_DATE, { YEAR( dValue ), MONTH( dVAlue ), DAY( dValue ), nHours, nMinutes, nSeconds } )
      CASE HMG_UPPER( ALLTRIM( cAttrib ) ) == "DATEMODIFIED"
         IF HMG_LEN( ALLTRIM( cTime ) ) > 0
            nHours := VAL( HB_USUBSTR( cTime, 1, 2 ) )
            nMinutes := VAL( HB_USUBSTR( cTime, 4, 2 ) )
            nSeconds := VAL( HB_USUBSTR( cTime, 7, 2 ) )
         ENDIF
         HPDF_SetInfoDateAttr( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_INFO_MOD_DATE, { YEAR( dValue ), MONTH( dVAlue ), DAY( dValue ), nHours, nMinutes, nSeconds } )
   ENDCASE
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_GetInfo()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_GetInfo( cAttrib )

LOCAL cRetValue := ''
   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   DO CASE
      CASE HMG_UPPER( ALLTRIM( cAttrib ) ) == "AUTHOR"
         cRetValue := HPDF_GetInfoAttr( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_INFO_AUTHOR )
      CASE HMG_UPPER( ALLTRIM( cAttrib ) ) == "CREATOR"
         cRetValue := HPDF_GetInfoAttr( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_INFO_CREATOR )
      CASE HMG_UPPER( ALLTRIM( cAttrib ) ) == "TITLE"
         cRetValue := HPDF_GetInfoAttr( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_INFO_TITLE )
      CASE HMG_UPPER( ALLTRIM( cAttrib ) ) == "SUBJECT"
         cRetValue := HPDF_GetInfoAttr( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_INFO_SUBJECT )
      CASE HMG_UPPER( ALLTRIM( cAttrib ) ) == "KEYWORDS"
         cRetValue := HPDF_GetInfoAttr( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_INFO_KEYWORDS )
      CASE HMG_UPPER( ALLTRIM( cAttrib ) ) == "DATECREATED"
         cRetValue := HPDF_GetInfoAttr( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_INFO_CREATION_DATE )
      CASE HMG_UPPER( ALLTRIM( cAttrib ) ) == "DATEMODIFIED"
         cRetValue := HPDF_GetInfoAttr( _HMG_SYSDATA[ 150 ] [ 1 ], HPDF_INFO_MOD_DATE )
   ENDCASE
RETURN cRetValue

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_SetPageLabel()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_SetPageLabel( nPage, cStyle, cCase, cPrefix )

   DEFAULT cCase := ""
   DEFAULT cStyle := "DECIMAL"
   DEFAULT nPage := 1
   DEFAULT cPrefix := ""
   IF _HMG_SYSDATA[ 150 ] [ 1 ] == Nil                                // PDF object not found!
      _HMG_HPDF_Error( 3 )
      RETURN Nil
   ENDIF
   DO CASE
      CASE HMG_UPPER( ALLTRIM( cStyle ) ) == "DECIMAL"
         HPDF_AddPageLabel( _HMG_SYSDATA[ 150 ] [ 1 ], nPage, HPDF_PAGE_NUM_STYLE_DECIMAL, nPage, cPrefix )
      CASE HMG_UPPER( ALLTRIM( cStyle ) ) == "ROMAN"
         IF HMG_UPPER( ALLTRIM( cCase ) ) == "LOWER"
            HPDF_AddPageLabel( _HMG_SYSDATA[ 150 ] [ 1 ], nPage, HPDF_PAGE_NUM_STYLE_LOWER_ROMAN, nPage, cPrefix )
         ELSE
            HPDF_AddPageLabel( _HMG_SYSDATA[ 150 ] [ 1 ], nPage, HPDF_PAGE_NUM_STYLE_UPPER_ROMAN, nPage, cPrefix )
         ENDIF
      CASE HMG_UPPER( ALLTRIM( cStyle ) ) == "LETTERS"
         IF HMG_UPPER( ALLTRIM( cCase ) ) == "LOWER"
            HPDF_AddPageLabel( _HMG_SYSDATA[ 150 ] [ 1 ], nPage, HPDF_PAGE_NUM_STYLE_LOWER_LETTERS, nPage, cPrefix )
         ELSE
            HPDF_AddPageLabel( _HMG_SYSDATA[ 150 ] [ 1 ], nPage, HPDF_PAGE_NUM_STYLE_UPPER_LETTERS, nPage, cPrefix )
         ENDIF
   ENDCASE
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_Error()
*+
*+    Called from ( h_hmg_hpdf.prg )   2 - function _hmg_hpdf_init()
*+                                   1 - function _hmg_hpdf_setencoding()
*+                                   3 - function _hmg_hpdf_startpage()
*+                                   5 - function _hmg_hpdf_insertpage()
*+                                   4 - function _hmg_hpdf_gotopage()
*+                                   2 - function _hmg_hpdf_endpage()
*+                                   1 - function hmg_hpdf_pagecount()
*+                                   2 - function hmg_hpdf_pageno()
*+                                   1 - function _hmg_hpdf_enddoc()
*+                                   1 - function _hmg_hpdf_abortdoc()
*+                                   4 - function _hmg_hpdf_print()
*+                                   4 - function _hmg_hpdf_multiline_print()
*+                                   2 - function _hmg_hpdf_line()
*+                                   2 - function _hmg_hpdf_rectangle()
*+                                   3 - function _hmg_hpdf_roundrectangle()
*+                                   2 - function _hmg_hpdf_circle()
*+                                   2 - function _hmg_hpdf_ellipse()
*+                                   2 - function _hmg_hpdf_arc()
*+                                   2 - function _hmg_hpdf_curve()
*+                                   5 - function _hmg_hpdf_image()
*+                                   1 - function _hmg_hpdf_setpassword()
*+                                   1 - function _hmg_hpdf_setcompression()
*+                                   1 - function _hmg_hpdf_setpermission()
*+                                   1 - function _hmg_hpdf_setpagemode()
*+                                   5 - function _hmg_hpdf_rootoutline()
*+                                   5 - function _hmg_hpdf_pageoutline()
*+                                   3 - function _hmg_hpdf_settextannot()
*+                                   7 - function _hmg_hpdf_setpagelink()
*+                                   4 - function _hmg_hpdf_seturllink()
*+                                   2 - function _hmg_hpdf_setlinespacing()
*+                                   1 - function _hmg_hpdf_setinfo()
*+                                   1 - function _hmg_hpdf_getinfo()
*+                                   1 - function _hmg_hpdf_setpagelabel()
*+                ( h_hmg_hpdf_unicode.prg )   2 - function _hmg_hpdf_multiline_print_unicode()
*+                                   4 - function _hmg_hpdf_drawimageraw()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_Error( nErr, ctxt )

LOCAL cErr := ''

   DEFAULT ctxt := ""
   DO CASE
      CASE nErr == 1
         cErr := 'A PDF document is already initiated.'
      CASE nErr == 2
         cErr := 'PDF document cannot be initialized.'
      CASE nErr == 3
         cErr := 'PDF PAGE cannot be added. PDF document cannot be found.'
      CASE nErr == 4
         cErr := 'A PDF PAGE is already inititated.'
      CASE nErr == 5
         cErr := 'PDF PAGE cannot be found.'
      CASE nErr == 6
         cErr := 'Font cannot be loaded.' + " | " + ctxt
      CASE nErr == 7
         cErr := 'Image cannot be loaded.'
      CASE nErr == 8
         cErr := 'Round curve can not be longer than half of the width/height.'
      CASE nErr == 9
         cErr := 'Can not start new page.' + " | " + ctxt
      CASE nErr == 10
         cErr := 'Can not create new parent outline.'
      CASE nErr == 11
         cErr := 'Outline Title is not valid.'
      CASE nErr == 12
         cErr := 'Outline Name is not valid.'
      CASE nErr == 13
         cErr := 'Can not create Page Outline.'
      CASE nErr == 14
         cErr := 'Can not find Parent Node.'
      CASE nErr == 15
         cErr := 'Tooltip creation error!'
      CASE nErr == 16
         cErr := 'Page not found. New page can not be inserted.'
      CASE nErr == 17
         cErr := 'Link Page not found.'
      CASE nErr == 18
         cErr := 'Selected Page can not be found.'
      CASE nErr == 19
         cErr := 'Page Selection error!'
      CASE nErr == 20
         cErr := 'Invalid Image Type!'
   ENDCASE
   MsgStop( cErr )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_Inch2Pixel()
*+
*+    Called from ( h_hmg_hpdf.prg )  68 - function _hmg_hpdf_init_papersize()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_Inch2Pixel( nInches )

RETURN ( nInches * 72 )

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_Pixel2Inch()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_Pixel2Inch( nPixels )

RETURN ( nPixels / 72 )

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_MM2Pixel()
*+
*+    Called from ( h_hmg_hpdf.prg )   4 - function _hmg_hpdf_init()
*+                                   2 - function _hmg_hpdf_print()
*+                                   4 - function _hmg_hpdf_multiline_print()
*+                                   5 - function _hmg_hpdf_line()
*+                                   8 - function _hmg_hpdf_rectangle()
*+                                   6 - function _hmg_hpdf_roundrectangle()
*+                                   4 - function _hmg_hpdf_circle()
*+                                   5 - function _hmg_hpdf_ellipse()
*+                                   4 - function _hmg_hpdf_arc()
*+                                   7 - function _hmg_hpdf_curve()
*+                                   5 - function _hmg_hpdf_image()
*+                                   4 - function _hmg_hpdf_settextannot()
*+                                   3 - function _hmg_hpdf_setpagelink()
*+                                   2 - function _hmg_hpdf_seturllink()
*+                                   1 - function _hmg_hpdf_setlinespacing()
*+                                 164 - function _hmg_hpdf_init_papersize()
*+                ( h_hmg_hpdf_unicode.prg )   2 - function _hmg_hpdf_multiline_print_unicode()
*+                                   5 - function _hmg_hpdf_drawimageraw()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_MM2Pixel( nMM )

RETURN ( ( nMM / 25.4 ) * 72 )

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_Pixel2MM()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_Pixel2MM( nPixel )

RETURN ( ( nPixel / 72 ) * 25.4 )

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_INIT_PAPERSIZE()
*+
*+    Called from ( h_hmg_hpdf.prg )   1 - function _hmg_hpdf_init()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_INIT_PAPERSIZE( nPaperSize )

LOCAL nTemp := 0
   DO CASE
      CASE nPaperSize == 1 .OR. nPaperSize == - 999                   // HPDF_PAPER_LETTER or default
         _HMG_SYSDATA[ 150 ] [ 4 ] := 612
         _HMG_SYSDATA[ 150 ] [ 5 ] := 792
      CASE nPaperSize == 2                                            // HPDF_PAPER_LETTERSMALL
         _HMG_SYSDATA[ 150 ] [ 4 ] := 612
         _HMG_SYSDATA[ 150 ] [ 5 ] := 792
      CASE nPaperSize == 3                                            // HPDF_PAPER_TABLOID
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 11 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 17 )
      CASE nPaperSize == 4                                            // HPDF_PAPER_LEDGER
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 17 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 11 )
      CASE nPaperSize == 5                                            // HPDF_PAPER_LEGAL
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 8.5 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 14 )
      CASE nPaperSize == 6                                            // HPDF_PAPER_STATEMENT
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 5.5 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 8.5 )
      CASE nPaperSize == 7                                            // HPDF_PAPER_EXECUTIVE
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 5.5 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 8.5 )
      CASE nPaperSize == 8                                            // HPDF_PAPER_A3
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 297 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 420 )
      CASE nPaperSize == 9                                            // HPDF_PAPER_A4
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 210 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 297 )
      CASE nPaperSize == 10                                           // HPDF_PAPER_A4SMALL
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 210 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 297 )
      CASE nPaperSize == 11                                           // HPDF_PAPER_A5
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 148 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 210 )
      CASE nPaperSize == 12                                           // HPDF_PAPER_B4
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 250 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 354 )
      CASE nPaperSize == 13                                           // HPDF_PAPER_B5
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 185 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 257 )
      CASE nPaperSize == 14                                           // HPDF_PAPER_FOLIO
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 8.5 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 13 )
      CASE nPaperSize == 15                                           // HPDF_PAPER_QUARTO
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 215 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 275 )
      CASE nPaperSize == 16                                           // HPDF_PAPER_10X14
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 10 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 140 )
      CASE nPaperSize == 17                                           // HPDF_PAPER_11X17
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 11 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 17 )
      CASE nPaperSize == 18                                           // HPDF_PAPER_NOTE
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 8.5 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 11 )
      CASE nPaperSize == 19                                           // HPDF_PAPER_ENV_9
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 3 + ( 7 / 8 ) )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 8 + ( 7 / 8 ) )
      CASE nPaperSize == 20                                           // HPDF_PAPER_ENV_10
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 4 + ( 1 / 8 ) )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 9.5 )
      CASE nPaperSize == 21                                           // HPDF_PAPER_ENV_11
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 4.5 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 10 + ( 3 / 8 ) )
      CASE nPaperSize == 22                                           // HPDF_PAPER_ENV_12
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 4.75 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 11 )
      CASE nPaperSize == 23                                           // HPDF_PAPER_ENV_14
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 5 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 11.5 )
      CASE nPaperSize == 24                                           // HPDF_PAPER_CSHEET
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 17 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 22 )
      CASE nPaperSize == 25                                           // HPDF_PAPER_DSHEET
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 22 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 34 )
      CASE nPaperSize == 26                                           // HPDF_PAPER_ESHEET
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 34 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 44 )
      CASE nPaperSize == 27                                           // HPDF_PAPER_ENV_DL
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 110 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 220 )
      CASE nPaperSize == 28                                           // HPDF_PAPER_ENV_C5
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 162 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 229 )
      CASE nPaperSize == 29                                           // HPDF_PAPER_ENV_C3
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 324 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 458 )
      CASE nPaperSize == 30                                           // HPDF_PAPER_ENV_C4
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 229 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 324 )
      CASE nPaperSize == 31                                           // HPDF_PAPER_ENV_C6
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 114 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 162 )
      CASE nPaperSize == 32                                           // HPDF_PAPER_ENV_C65
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 114 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 229 )
      CASE nPaperSize == 33                                           // HPDF_PAPER_ENV_B4
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 250 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 353 )
      CASE nPaperSize == 34                                           // HPDF_PAPER_ENV_B5
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 176 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 250 )
      CASE nPaperSize == 35                                           // HPDF_PAPER_ENV_B6
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 176 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 125 )
      CASE nPaperSize == 36                                           // HPDF_PAPER_ENV_ITALY
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 110 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 230 )
      CASE nPaperSize == 37                                           // HPDF_PAPER_ENV_MONARCH
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 3.875 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 7.5 )
      CASE nPaperSize == 38                                           // HPDF_PAPER_ENV_PERSONAL
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 3 + ( 5 / 8 ) )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 6.5 )
      CASE nPaperSize == 39                                           // HPDF_PAPER_FANFOLD_US
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 14 + ( 7 / 8 ) )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 11 )
      CASE nPaperSize == 40                                           // HPDF_PAPER_FANFOLD_STD_GERMAN
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 8.5 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 12 )
      CASE nPaperSize == 41                                           // HPDF_PAPER_FANFOLD_LGL_GERMAN
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 8.5 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 13 )
      CASE nPaperSize == 42                                           // HPDF_PAPER_ISO_B4
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 250 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 353 )
      CASE nPaperSize == 43                                           // HPDF_PAPER_JAPANESE_POSTCARD
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 100 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 148 )
      CASE nPaperSize == 44                                           // HPDF_PAPER_9X11
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 9 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 11 )
      CASE nPaperSize == 45                                           // HPDF_PAPER_10X11
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 10 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 11 )
      CASE nPaperSize == 46                                           // HPDF_PAPER_15X11
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 15 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 11 )
      CASE nPaperSize == 47                                           // HPDF_PAPER_ENV_INVITE
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 220 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 220 )
      CASE nPaperSize == 48                                           // HPDF_PAPER_RESERVED_48
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 210 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 297 )
      CASE nPaperSize == 49                                           // HPDF_PAPER_RESERVED_49
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 210 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 297 )
      CASE nPaperSize == 50                                           // HPDF_PAPER_LETTER_EXTRA
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 9.5 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 12 )
      CASE nPaperSize == 51                                           // HPDF_PAPER_LEGAL_EXTRA
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 9.5 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 15 )
      CASE nPaperSize == 52                                           // HPDF_PAPER_TABLOID_EXTRA
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 11.69 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 18 )
      CASE nPaperSize == 53                                           // HPDF_PAPER_A4_EXTRA
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 9.27 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 12.69 )
      CASE nPaperSize == 54                                           // HPDF_PAPER_LETTER_TRANSVERSE
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 8.5 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 11 )
      CASE nPaperSize == 55                                           // HPDF_PAPER_A4_TRANSVERSE
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 210 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 297 )
      CASE nPaperSize == 56                                           // HPDF_PAPER_LETTER_EXTRA_TRANSVERSE
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 9.5 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 12 )
      CASE nPaperSize == 57                                           // HPDF_PAPER_A_PLUS
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 227 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 356 )
      CASE nPaperSize == 58                                           // HPDF_PAPER_B_PLUS
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 305 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 487 )
      CASE nPaperSize == 59                                           // HPDF_PAPER_LETTER_PLUS
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 8.5 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 12.69 )
      CASE nPaperSize == 60                                           // HPDF_PAPER_A4_PLUS
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 210 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 330 )
      CASE nPaperSize == 61                                           // HPDF_PAPER_A5_TRANSVERSE
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 148 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 210 )
      CASE nPaperSize == 62                                           // HPDF_PAPER_B5_TRANSVERSE
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 182 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 257 )
      CASE nPaperSize == 63                                           // HPDF_PAPER_A3_EXTRA
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 322 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 445 )
      CASE nPaperSize == 64                                           // HPDF_PAPER_A5_EXTRA
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 174 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 235 )
      CASE nPaperSize == 65                                           // HPDF_PAPER_B5_EXTRA
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 201 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 276 )
      CASE nPaperSize == 66                                           // HPDF_PAPER_A2
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 420 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 594 )
      CASE nPaperSize == 67                                           // HPDF_PAPER_A3_TRANSVERSE
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 297 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 420 )
      CASE nPaperSize == 68                                           // HPDF_PAPER_A3_EXTRA_TRANSVERSE
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 322 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 445 )
      CASE nPaperSize == 69                                           // HPDF_PAPER_DBL_JAPANESE_POSTCARD
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 200 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 148 )
      CASE nPaperSize == 70                                           // HPDF_PAPER_A6
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 105 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 148 )
      CASE nPaperSize == 71                                           // HPDF_PAPER_JENV_KAKU2
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 240 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 332 )
      CASE nPaperSize == 72                                           // HPDF_PAPER_JENV_KAKU2
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 216 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 277 )
      CASE nPaperSize == 73                                           // HPDF_PAPER_JENV_CHOU3
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 120 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 235 )
      CASE nPaperSize == 74                                           // HPDF_PAPER_JENV_CHOU4
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 90 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 205 )
      CASE nPaperSize == 75                                           // HPDF_PAPER_LETTER_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 11 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 8.5 )
      CASE nPaperSize == 76                                           // HPDF_PAPER_A3_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 420 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 297 )
      CASE nPaperSize == 77                                           // HPDF_PAPER_A4_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 297 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 210 )
      CASE nPaperSize == 78                                           // HPDF_PAPER_A5_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 210 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 148 )
      CASE nPaperSize == 79                                           // HPDF_PAPER_B4_JIS_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 364 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 257 )
      CASE nPaperSize == 80                                           // HPDF_PAPER_B5_JIS_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 257 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 182 )
      CASE nPaperSize == 81                                           // HPDF_PAPER_B5_JAPANESE_POSTCARD_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 148 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 100 )
      CASE nPaperSize == 82                                           // HPDF_PAPER_B5_DBL_JAPANESE_POSTCARD_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 148 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 200 )
      CASE nPaperSize == 83                                           // HPDF_PAPER_A6_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 148 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 105 )
      CASE nPaperSize == 84                                           // HPDF_PAPER_JENV_KAKU2_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 332 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 240 )
      CASE nPaperSize == 85                                           // HPDF_PAPER_JENV_KAKU3_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 277 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 216 )
      CASE nPaperSize == 86                                           // HPDF_PAPER_JENV_CHOU3_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 235 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 120 )
      CASE nPaperSize == 87                                           // HPDF_PAPER_JENV_CHOU4_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 205 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 90 )
      CASE nPaperSize == 88                                           // HPDF_PAPER_B6_JIS
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 128 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 182 )
      CASE nPaperSize == 89                                           // HPDF_PAPER_B6_JIS_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 182 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 128 )
      CASE nPaperSize == 90                                           // HPDF_PAPER_12X11
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_Inch2Pixel( 12 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_Inch2Pixel( 11 )
      CASE nPaperSize == 91                                           // HPDF_PAPER_JENV_YOU4
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 235 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 105 )
      CASE nPaperSize == 92                                           // HPDF_PAPER_JENV_YOU4_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 105 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 235 )
      CASE nPaperSize == 93                                           // HPDF_PAPER_P16K
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 146 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 215 )
      CASE nPaperSize == 94                                           // HPDF_PAPER_P32K
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 97 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 151 )
      CASE nPaperSize == 95                                           // HPDF_PAPER_P32KBIG
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 97 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 151 )
      CASE nPaperSize == 96                                           // HPDF_PAPER_PENV_1
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 102 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 165 )
      CASE nPaperSize == 97                                           // HPDF_PAPER_PENV_2
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 102 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 176 )
      CASE nPaperSize == 98                                           // HPDF_PAPER_PENV_3
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 125 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 176 )
      CASE nPaperSize == 99                                           // HPDF_PAPER_PENV_4
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 110 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 208 )
      CASE nPaperSize == 100                                          // HPDF_PAPER_PENV_5
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 110 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 220 )
      CASE nPaperSize == 101                                          // HPDF_PAPER_PENV_6
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 120 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 230 )
      CASE nPaperSize == 102                                          // HPDF_PAPER_PENV_7
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 160 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 230 )
      CASE nPaperSize == 103                                          // HPDF_PAPER_PENV_8
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 120 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 208 )
      CASE nPaperSize == 104                                          // HPDF_PAPER_PENV_9
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 229 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 324 )
      CASE nPaperSize == 105                                          // HPDF_PAPER_PENV_10
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 324 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 458 )
      CASE nPaperSize == 106                                          // HPDF_PAPER_P16K_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 215 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 146 )
      CASE nPaperSize == 107                                          // HPDF_PAPER_P32K_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 151 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 97 )
      CASE nPaperSize == 108                                          // HPDF_PAPER_P32KBIG_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 151 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 97 )
      CASE nPaperSize == 109                                          // HPDF_PAPER_PENV_1_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 165 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 102 )
      CASE nPaperSize == 110                                          // HPDF_PAPER_PENV_2_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 176 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 102 )
      CASE nPaperSize == 111                                          // HPDF_PAPER_PENV_3_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 176 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 125 )
      CASE nPaperSize == 112                                          // HPDF_PAPER_PENV_4_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 208 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 110 )
      CASE nPaperSize == 113                                          // HPDF_PAPER_PENV_5_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 220 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 110 )
      CASE nPaperSize == 114                                          // HPDF_PAPER_PENV_6_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 230 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 120 )
      CASE nPaperSize == 115                                          // HPDF_PAPER_PENV_7_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 230 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 160 )
      CASE nPaperSize == 116                                          // HPDF_PAPER_PENV_8_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 309 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 120 )
      CASE nPaperSize == 117                                          // HPDF_PAPER_PENV_9_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 324 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 229 )
      CASE nPaperSize == 118                                          // HPDF_PAPER_PENV_10_ROTATED
         _HMG_SYSDATA[ 150 ] [ 4 ] := _HMG_HPDF_MM2Pixel( 458 )
         _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_HPDF_MM2Pixel( 324 )
   ENDCASE
   IF _HMG_SYSDATA[ 150 ] [ 6 ] == 2                                  // landscape
      nTemp := _HMG_SYSDATA[ 150 ] [ 5 ]
      _HMG_SYSDATA[ 150 ] [ 5 ] := _HMG_SYSDATA[ 150 ] [ 4 ]
      _HMG_SYSDATA[ 150 ] [ 4 ] := nTemp
   ENDIF
RETURN Nil

// ------------------------------------------------------------------------------
// -12th April, 2014
// -Author: Pablo César Arrascaeta
// -_HMG_HPDF validation/selection fonts
// ------------------------------------------------------------------------------

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_SetFont()
*+
*+    Called from ( h_hmg_hpdf.prg )   2 - function _hmg_hpdf_print()
*+                                   2 - function _hmg_hpdf_multiline_print()
*+                                   2 - function _hmg_hpdf_setpagelink()
*+                                   2 - function _hmg_hpdf_seturllink()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_SetFont( cFntName, lBold, lItalic )

LOCAL cFntTmp := "", cFnt := "", cFntNoExt

   DEFAULT lBold := .f., lItalic := .f.

   IF HMG_Len( ALLTRIM( cFntName ) ) == 0
      cFnt := _HMG_SYSDATA[ 150 ] [ 8 ]
      IF lBold .AND. lItalic
         cFnt += '-BoldOblique'
      ELSEIF lBold
         cFnt += '-Bold'
      ELSEIF lItalic
         cFnt += '-Oblique'
      ENDIF
      RETURN cFnt
   ENDIF

   IF HMG_UPPER( cFileExt( cFntName ) ) == '.TTF'                     // load ttf font
      cFnt := _HMG_HPDF_ExistInLocal( cFntName )
      IF !EMPTY( cFnt )
         RETURN cFnt
      ENDIF
   ENDIF

   cFntTmp := cFileNoExt( cFntName )
   cFntNoExt := cFntTmp
   cFnt := _HMG_HPDF_SeekHaruFonts( cFntTmp, lBold, lItalic )
   IF !EMPTY( cFnt )
      RETURN cFnt
   ENDIF

   cFnt := _HMG_HPDF_SeekEquivalences( cFntNoExt, lBold, lItalic )
   IF !EMPTY( cFnt )
      RETURN cFnt
   ENDIF

   cFnt := _HMG_HPDF_SeekInLocalOptions( cFntNoExt, lBold, lItalic )
   IF !EMPTY( cFnt )
      cFntTmp := _HMG_HPDF_ExistInLocal( cFnt )
      IF !EMPTY( cFntTmp )
         RETURN cFntTmp
      ENDIF
   ENDIF
RETURN "Helvetica"

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_SeekHaruFonts()
*+
*+    Called from ( h_hmg_hpdf.prg )   1 - function _hmg_hpdf_setfont()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_SeekHaruFonts( cFontName, lBold, lItalic )

LOCAL aHpdf_Font := { "Courier", ;
                         "Courier-Bold", ;
                         "Courier-Oblique", ;
                         "Courier-BoldOblique", ;
                         "Helvetica", ;
                         "Helvetica-Bold", ;
                         "Helvetica-Oblique", ;
                         "Helvetica-BoldOblique", ;
                         "Times-Roman", ;
                         "Times-Bold", ;
                         "Times-Italic", ;
                         "Times-BoldItalic", ;
                         "Symbol", ;
                         "ZapfDingbats" }
LOCAL nPos, cFnt, cFont, cFntHaru

   IF ( nPos := ASCAN( aHpdf_Font, { | cFnt | HMG_Upper( cFnt ) == HMG_Upper( cFontName ) } ) ) > 0
      cFont := aHpdf_Font[ nPos ]
      DO CASE
         CASE "SYMBOL" $ HMG_Upper( cFont )
            cFntHaru := "Symbol"
         CASE "ZAPFDINGBATS" $ HMG_Upper( cFont )
            cFntHaru := "ZapfDingbats"
         CASE HMG_Upper( HB_USubStr( cFont, 1, 5 ) ) == 'TIMES'
            cFnt := "Times"
            IF lBold .AND. lItalic
               cFntHaru := cFnt + '-BoldItalic'
            ELSEIF lBold
               cFntHaru := cFnt + '-Bold'
            ELSEIF lItalic
               cFntHaru := cFnt + '-Italic'
            ELSE
               cFntHaru := cFnt + '-Roman'
            ENDIF
         OTHERWISE
            IF ( nPos := HB_UAt( '-', cFont ) ) > 0
               cFnt := HB_USubStr( cFont, 1, nPos - 1 )
            ENDIF
            IF lBold .AND. lItalic
               cFntHaru := cFnt + '-BoldOblique'
            ELSEIF lBold
               cFntHaru := cFnt + '-Bold'
            ELSEIF lItalic
               cFntHaru := cFnt + '-Oblique'
            ENDIF
      ENDCASE
      IF lBold .OR. lItalic
         RETURN cFntHaru
      ELSE
         RETURN cFont
      ENDIF
   ENDIF
RETURN ""

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_SeekEquivalences()
*+
*+    Called from ( h_hmg_hpdf.prg )   1 - function _hmg_hpdf_setfont()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_SeekEquivalences( FontName, lBold, lItalic )

LOCAL cFldWindows := GetSpecialFolder( CSIDL_FONTS )
LOCAL cRet        := ""

   DEFAULT lBold := .f., lItalic := .f.

   DO CASE
      CASE "COUR" $ HMG_Upper( FontName )
         cRet := "cour"
      CASE "TIMES" $ HMG_Upper( FontName )
         cRet := "times"
      CASE "ARIAL" $ HMG_Upper( FontName )
         cRet := "arial"
      CASE "VERDANA" $ HMG_Upper( FontName )
         cRet := "verdana"
   ENDCASE
   IF !EMPTY( cRet )
      cRet := cFldWindows + "\" + cRet
      IF lBold .AND. lItalic
         cRet := cRet + 'bi.ttf'
      ELSEIF lBold
         cRet := cRet + 'bd.ttf'
      ELSEIF lItalic
         cRet := cRet + 'i.ttf'
      ELSE
         cRet := cRet + '.ttf'
      ENDIF
      cRet := _HMG_HPDF_ExistInLocal( cRet )
   ENDIF
RETURN cRet

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_ExistInLocal()
*+
*+    Called from ( h_hmg_hpdf.prg )   2 - function _hmg_hpdf_setfont()
*+                                   1 - function _hmg_hpdf_seekequivalences()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_ExistInLocal( FontName )

LOCAL cFldWindows := GetSpecialFolder( CSIDL_FONTS )
LOCAL cFileTTF    := cFileNoExt( FontName ) + ".ttf"
LOCAL cFldLocal   := GetCurrentFolder()
LOCAL cFntTmp     := ""

   IF FILE( FontName )
      RETURN FontName
   ENDIF
   IF FILE( cFldWindows + "\" + cFileTTF )
      cFntTmp := cFldWindows + "\" + cFileTTF
   ENDIF
   IF FILE( cFldLocal + "\" + cFileTTF )
      cFntTmp := cFldLocal + "\" + cFileTTF
   ENDIF
RETURN cFntTmp

*+--------------------------------------------------------------------
*+
*+    Function _HMG_HPDF_SeekInLocalOptions()
*+
*+    Called from ( h_hmg_hpdf.prg )   1 - function _hmg_hpdf_setfont()
*+
*+--------------------------------------------------------------------
*+
FUNCTION _HMG_HPDF_SeekInLocalOptions( FontName, lBold, lItalic )

LOCAL aDirFnts    := {}, cRet := ""
LOCAL cFldWindows, cFileTTF

   DEFAULT lBold := .f., lItalic := .f.

   cFldWindows := GetSpecialFolder( CSIDL_FONTS )
   cFileTTF := cFileNoExt( FontName )
   aDirFnts := ASORT( DIRECTORY( cFldWindows + "\" + HB_USubStr( cFileTTF, 1, 4 ) + "*.ttf" ),,, { | x, y | HMG_Len( x[ 1 ] ) < HMG_Len( y[ 1 ] ) } )
   IF LEN( aDirFnts ) > 0
      cRet := cFldWindows + "\" + cFileNoExt( aDirFnts[ 1, 1 ] )
      IF lBold .AND. lItalic
         cRet := cRet + 'bi.ttf'
      ELSEIF lBold
         cRet := cRet + 'bd.ttf'
      ELSEIF lItalic
         cRet := cRet + 'i.ttf'
      ELSE
         cRet := cRet + '.ttf'
      ENDIF
   ENDIF
RETURN cRet

*+--------------------------------------------------------------------
*+
*+    Function FWriteLine()
*+
*+    Called from ( h_hmg_hpdf.prg )   1 - function html_table_ini()
*+                                   1 - function html_table_line()
*+
*+--------------------------------------------------------------------
*+
FUNCTION FWriteLine( nFHandle, cString )

   IF nFHandle > 3
      FWRITE( nFHandle, cString )
      FWRITE( nFHandle, CHR( 13 ) )
      FWRITE( nFHandle, CHR( 10 ) )
   ENDIF
RETURN Nil

// ------------------------------------------------------------------------------
// -12th April, 2014
// -Author: Pablo César Arrascaeta
// -HTML Table
// ------------------------------------------------------------------------------

*+--------------------------------------------------------------------
*+
*+    Function HTML_TABLE_INI()
*+
*+    Called from ( h_hmg_hpdf.prg )   1 - function _hmg_hpdf_init()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HTML_TABLE_INI( nFHandle, cTit, nWidth, nPading )

LOCAL cStyle

   DEFAULT nPading := 3
   DEFAULT nWidth := 1024

   cStyle := '<html><head>' + CRLF + ;
             '<style>' + CRLF + ;
             'table,th,td' + CRLF + ;
             '{' + CRLF + ;
             'border:1px solid black;' + CRLF + ;
             'border-collapse:collapse;' + CRLF + ;
             '}' + CRLF + ;
             '</style>' + CRLF + ;
             '</head>' + CRLF + ;
             '<body>' + CRLF + ;
             '<table style=' + CHR( 34 ) + 'width:' + STRZERO( nWidth, 4, 0 ) + 'px' + CHR( 34 ) + ' cellpadding=' + CHR( 34 ) + STR( nPading, 1, 0 ) + CHR( 34 ) + '>'
   cTit := ALLTRIM( cTit )
   FWriteLine( nFHandle, cStyle )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function HTML_TABLE_LINE()
*+
*+    Called from ( h_hmg_hpdf.prg )   1 - function _hmg_hpdf_init()
*+                                   1 - function _hmg_hpdf_print()
*+                                   1 - function _hmg_hpdf_multiline_print()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HTML_TABLE_LINE( nFHandle, aLin )

LOCAL i, nLen := LEN( aLin ), cLin := "<tr>"

   FOR i = 1 TO nLen
      cLin := cLin + CRLF + '<td ' + IF( aLin[ i, 3 ], ' align="center" valign="middle" ', "" ) + 'bgcolor=' + CHR( 34 ) + aLin[ i, 2 ] + CHR( 34 ) + '>' + aLin[ i, 1 ] + '</td>'
   NEXT
   FWriteLine( nFHandle, cLin + CRLF + "</tr>" )
RETURN Nil

*+--------------------------------------------------------------------
*+
*+    Function HTML_BOLD()
*+
*+    Called from ( h_hmg_hpdf.prg )   7 - function _hmg_hpdf_init()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HTML_BOLD( nFHandle, cText )

   nFHandle := nFHandle
   RETURN ( "<b>" + cText + "</b>" )

   /***** change to HB_FUNC.PRG ************************

#pragma BEGINDUMP

#include "SET_COMPILE_HMG_UNICODE.ch"

#ifdef COMPILE_HMG_UNICODE
   #undef COMPILE_HMG_UNICODE   // Force to compile only for ANSI character set
#endif

#include "HMG_UNICODE.h"

#include <windows.h>
#include <tchar.h>
#include "hbapi.h"
#include "hpdf.h"

*-------------------------------------------------------------------------
*   The following Functions are taken from the graphics library Bos Taurus.
*   Bos Taurus, (c) 2012 by Dr. Claudio Soto <srvet@adinet.com.uy>
*---------------------------------------------------------------------------

//*********************************************************************************************************************
// _bt_LoadFileFromResources (FileName, TypeResource) ---> Return hGlobalAlloc
//*********************************************************************************************************************
HGLOBAL _bt_HPDF_LoadFileFromResources (TCHAR * FileName, TCHAR * TypeResource)
{
   HRSRC     hResourceData;
   HGLOBAL   hGlobalAlloc,  hGlobalResource;
   LPVOID    lpGlobalAlloc, lpGlobalResource;
   DWORD     nFileSize;

   hResourceData = FindResource (NULL, FileName, TypeResource);
   if (hResourceData == NULL)
       return NULL;

   hGlobalResource = LoadResource (NULL, hResourceData);
   if (hGlobalResource == NULL)
       return NULL;

   lpGlobalResource  = LockResource (hGlobalResource);
   if (lpGlobalResource == NULL)
       return NULL;

   nFileSize = SizeofResource (NULL, hResourceData);

   hGlobalAlloc = GlobalAlloc (GHND, nFileSize);
   if (hGlobalAlloc == NULL)
   {   FreeResource (hGlobalResource);
       return NULL;
   }

   lpGlobalAlloc = GlobalLock (hGlobalAlloc);
   memcpy (lpGlobalAlloc, lpGlobalResource, nFileSize);
   GlobalUnlock (hGlobalAlloc);

   FreeResource (hGlobalResource);

   return hGlobalAlloc;
}

//*********************************************************************************************************************
// _bt_LoadFileFromDisk (FileName) ---> Return hGlobalAlloc
//*********************************************************************************************************************
HGLOBAL _bt_HPDF_LoadFileFromDisk (TCHAR * FileName)
{
   HGLOBAL   hGlobalAlloc;
   LPVOID    lpGlobalAlloc;
   HANDLE    hFile;
   DWORD     nFileSize;
   DWORD     nReadByte;

   hFile = CreateFile (FileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
   if (hFile == INVALID_HANDLE_VALUE)
       return NULL;

   nFileSize = GetFileSize (hFile, NULL);
   if (nFileSize == INVALID_FILE_SIZE)
   {   CloseHandle (hFile);
       return NULL;
   }

   hGlobalAlloc = GlobalAlloc (GHND, nFileSize);
   if (hGlobalAlloc == NULL)
   {   CloseHandle (hFile);
       return NULL;
   }
   lpGlobalAlloc = GlobalLock (hGlobalAlloc);
   ReadFile (hFile, lpGlobalAlloc, nFileSize, &nReadByte, NULL);
   GlobalUnlock (hGlobalAlloc);

   CloseHandle (hFile);

   return hGlobalAlloc;
}

//*******************************************************************************************************
//* _HPDF_LOAD_PNG (hPDF_Doc, cFileName) ---> return Pointer   // load PNG image from Resourse or Disk
//*******************************************************************************************************

*
* typedef void*         HPDF_HANDLE;
* typedef HPDF_HANDLE   HPDF_Image;   // void* ptr
* typedef HPDF_HANDLE   HPDF_Doc;     // void* ptr
* HPDF_LoadPngImageFromFile () ---> return image = void* ptr
* HPDF_LoadPngImageFromMem  () ---> return image = void* ptr
*

extern HPDF_Doc hb_HPDF_Doc_par (int);

HB_FUNC (_HPDF_LOAD_PNG)
{
    TCHAR       *FileName;
    HGLOBAL     hGlobalAlloc;
    LPVOID      lpGlobalAlloc;
    UINT        nSizeGlobalAlloc;
    HPDF_Doc    hpdf_Doc;
    HPDF_Image  image;

    hpdf_Doc  = (HPDF_Doc) hb_HPDF_Doc_par (1);
    FileName  = (TCHAR *)  HMG_parc (2);

    hGlobalAlloc = _bt_HPDF_LoadFileFromResources (FileName, _TEXT("PNG"));

 // if fail: find in disk
    if (hGlobalAlloc == NULL)
        hGlobalAlloc = _bt_HPDF_LoadFileFromDisk (FileName);

    if (hGlobalAlloc == NULL)
    {    hb_ret();  // return Nil
         return;
    }

    nSizeGlobalAlloc = (UINT) GlobalSize(hGlobalAlloc);
    lpGlobalAlloc = GlobalLock (hGlobalAlloc);
        image = HPDF_LoadPngImageFromMem  (hpdf_Doc, (BYTE*)lpGlobalAlloc, nSizeGlobalAlloc);
    GlobalUnlock (hGlobalAlloc);
    GlobalFree (hGlobalAlloc);

    if (image == NULL)
    {   hb_ret();  // return Nil
        return;
    }

    hb_retptr ((void *) image); // return image (void* ptr)
}

//*******************************************************************************************************
//* _HPDF_LOAD_JPG (hPDF_Doc, cFileName) ---> return Pointer   // load PNG image from Resourse or Disk
//*******************************************************************************************************

HB_FUNC (_HPDF_LOAD_JPG)
{
    TCHAR       *FileName;
    HGLOBAL     hGlobalAlloc;
    LPVOID      lpGlobalAlloc;
    UINT        nSizeGlobalAlloc;
    HPDF_Doc    hpdf_Doc;
    HPDF_Image  image;

    hpdf_Doc  = (HPDF_Doc) hb_HPDF_Doc_par (1);
    FileName  = (TCHAR *)  HMG_parc (2);

    hGlobalAlloc = _bt_HPDF_LoadFileFromResources (FileName, _TEXT("JPG"));

 // if fail: find in disk
    if (hGlobalAlloc == NULL)
        hGlobalAlloc = _bt_HPDF_LoadFileFromDisk (FileName);

    if (hGlobalAlloc == NULL)
    {    hb_ret();  // return Nil
         return;
    }

    nSizeGlobalAlloc = (UINT) GlobalSize(hGlobalAlloc);
    lpGlobalAlloc = GlobalLock (hGlobalAlloc);
        image = HPDF_LoadJpegImageFromMem (hpdf_Doc, (BYTE*)lpGlobalAlloc, nSizeGlobalAlloc);
    GlobalUnlock (hGlobalAlloc);
    GlobalFree (hGlobalAlloc);

    if (image == NULL)
    {   hb_ret();  // return Nil
        return;
    }

    hb_retptr ((void *) image); // return image (void* ptr)
}

#pragma ENDDUMP

**********************************/

*+ EOF: h_HMG_HPDF.Prg

