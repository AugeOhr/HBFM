*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\SHELL32.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Function SHFolderDelete()
*+               Function SHFileDelete()
*+               Function ShellFiles()
*+
*+    Reformatted by Click! 2.05.30 on Aug-28-2020 at  1:53 am
*+
*+--------------------------------------------------------------------

// ===========================================================================
// Shell32.PRG        (c) 2004, Grigory Filatov
// ===========================================================================
//
//   Created   : 08.09.04
//   Extended  : 28.04.07
//   Section   : Shell Extensions
//
//   Windows ShellAPI provides functions to implement:
//   · The drag-drop feature
//   · Associations (used) to find and start applications
//   · Extraction of icons from executable files
//   · Explorer File operation
//
//
// ===========================================================================

#include "Shell32.ch"
#include "common.ch"

// ===========================================================================
// Function ShFolderDelete( hParentWnd, acFolder, lSilent )
//
// Purpose:
//  Use the Windows ShellAPI function to delete folder(s) with all its files and
//  subdirectories.
//  acFolder can be an Array of FolderName string, or a single FolderName string.
//  If lSilent is TRUE (default), you can not an any confirmation
//
// ===========================================================================

*+--------------------------------------------------------------------
*+
*+    Function SHFolderDelete()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SHFolderDelete( hWnd, acFolder, lSilent )

LOCAL nFlag := 0

   DEFAULT hWnd TO GetActiveWindow()

   IF lSilent == NIL .OR. lSilent
      nFlag := FOF_NOCONFIRMATION + FOF_SILENT
   ENDIF

RETURN ( ShellFiles( hWnd, acFolder,, FO_DELETE, nFlag ) == 0 )

// ===========================================================================
// Function ShFileDelete( hParentWnd, aFiles, lRecycle )
//
// Purpose:
//  Use the Windows ShellAPI function to delete file(s).
//  aFiles can be an Array of FileName strings, or a single FileName string.
//  If lRecycle is TRUE (default), deleted files are moved into the recycle Bin
//
// ===========================================================================

*+--------------------------------------------------------------------
*+
*+    Function SHFileDelete()
*+
*+--------------------------------------------------------------------
*+
FUNCTION SHFileDelete( hWnd, acFiles, lRecycle )

LOCAL nFlag := 0

   DEFAULT hWnd TO GetActiveWindow()

   IF lRecycle == NIL .OR. lRecycle
      nFlag := FOF_ALLOWUNDO
   ENDIF

RETURN ( ShellFiles( hWnd, acFiles,, FO_DELETE, nFlag ) == 0 )

// ===========================================================================
// Function ShellFile( hParentWnd, aFiles, aTarget, nFunc, nFlag )
//
// Purpose:
// Performs a copy, move, rename, or delete operation on a file system object.
// Parameters:
//   aFiles  is an Array of Source-Filenamestrings, or a single Filenamestring
//   aTarget is an Array of Target-Filenamestrings, or a single Filenamestring
//   nFunc   determines the action on the files:
//           FO_MOVE, FO_COPY, FO_DELETE, FO_RENAME
//   fFlag   Option Flag ( see the file SHELL32.CH )
//
// ===========================================================================

*+--------------------------------------------------------------------
*+
*+    Function ShellFiles()
*+
*+    Called from ( fmgrid.prg )   1 - function dosh3func()
*+                ( shell32.prg )   1 - function shfolderdelete()
*+                                   1 - function shfiledelete()
*+
*+--------------------------------------------------------------------
*+
FUNCTION ShellFiles( hWnd, acFiles, acTarget, nFunc, fFlag )

LOCAL cTemp
LOCAL cx

   // Parent Window
   //
   IF EMPTY( hWnd )
      hWnd := GetActiveWindow()
   ENDIF

   // Operation Flag
   //
   IF nFunc == NIL
      nFunc := FO_DELETE
   ENDIF

   // Options Flag
   //
   IF fFlag == NIL
      fFlag := FOF_ALLOWUNDO
   ENDIF

   // SourceFiles, convert Array to String
   //
   DEFAULT acFiles TO CHR( 0 )
   IF VALTYPE( acFiles ) == "A"
      cTemp := ""
      FOR cx := 1 TO LEN( acFiles )
         cTemp += acFiles[ cx ] + CHR( 0 )
      NEXT
      acFiles := cTemp
   ENDIF
   acFiles += CHR( 0 )

   // TargetFiles, convert Array to String
   //
   DEFAULT acTarget TO CHR( 0 )
   IF VALTYPE( acTarget ) == "A"
      cTemp := ""
      FOR cx := 1 TO LEN( acTarget )
         cTemp += acTarget[ cx ] + CHR( 0 )
      NEXT
      acTarget := cTemp
   ENDIF
   acTarget += CHR( 0 )

   // call SHFileOperation
   //
RETURN ShellFileOperation( hWnd, acFiles, acTarget, nFunc, fFlag )

*+ EOF: SHELL32.PRG
