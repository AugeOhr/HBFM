*+--------------------------------------------------------------------
*+
*+ Source Module => c:\hmg.3.4.4\0\HBFM\\HELPFILE.PRG
*+
*+    Copyright(C) 1983-2020 by Auge & Ohr
*+
*+    Functions: Function HelpFile()
*+
*+    Reformatted by Click! 2.05.32 on Sep-10-2020 at  2:10 am
*+
*+--------------------------------------------------------------------

#include "HMG.CH"

*+--------------------------------------------------------------------
*+
*+    Function HelpFile()
*+
*+    Called from ( fmgrid.prg )   2 - procedure dualgrid()
*+                                   1 - static procedure dogridkey1()
*+                                   1 - static procedure dogridkey2()
*+
*+--------------------------------------------------------------------
*+
FUNCTION HelpFile()

LOCAL cText := ""

   //    cText += "Syntax : XCM.EXE [/I] [/O] [/C] [/T] [/L] [/R]" + CRLF
   //    cText += "" + CRLF
   //    cText += "/I     Icon from OS()" + CRLF
   //    cText += "/O   Ownerdraw (build-in)" + CRLF
   //    cText += "/C   Customdraw (build-in)" + CRLF
   //    cText += "" + CRLF
   //    cText += "/T   use Thread Check View" + CRLF
   //    cText += "" + CRLF
   //    cText += "/L    override Start Folder left" + CRLF
   //    cText += "/R    override Start Folder right" + CRLF
   //    cText += "use # as Delimiter e.g. /Lc:\#d:\ /Re:\#f:\" + CRLF
   //    cText += "" + CRLF
   //    cText += "/M2  when start on 2nd Screen" + CRLF
   //    cText += "" + CRLF
   cText += "Syntax : HBFM.EXE [/L] [/R]" + CRLF
   cText += "" + CRLF
   cText += "/L    override Start Folder left" + CRLF
   cText += "/R    override Start Folder right" + CRLF
   cText += "use # as Delimiter e.g. /Lc:\#d:\ /Re:\#f:\" + CRLF
   cText += "" + CRLF
   cText += "F1   this Help" + CRLF
   cText += "F2   Sys Folder" + CRLF
   cText += "F3   Viewer DBF" + CRLF
   cText += "F4   Edit DBF" + CRLF
   cText += "F5   Copy Files" + CRLF
   cText += "F6   Move Files" + CRLF
   cText += "F7   new Directory" + CRLF
   cText += "F8   Delete Files" + CRLF
   cText += "F9   History Folder" + CRLF
   cText += "F10  Device SmartPhone / Digi-CAM" + CRLF
   cText += "F11  Tools" + CRLF
   cText += "F12  not working" + CRLF
   cText += "" + CRLF
   cText += "TAB  switch Window left/right" + CRLF
   cText += "" + CRLF
   cText += "Num +            select Files" + CRLF
   cText += "Num -         unselect Files" + CRLF
   cText += "Num *   reverse selection" + CRLF

   cText += "" + CRLF
   //    cText += "with SHIFT (press SHIFT 1st)"   +CRLF
   //    cText += "----------------------------"   +CRLF
   //    cText += "SHIFT_F1    Xbase++ DLL Info" + CRLF
   cText += "SHIFT_F2    Compare Dir    " + CRLF
   cText += "SHIFT_F3    Thumbs / Slideshow" + CRLF
   cText += "SHIFT_F4    create new DBF" + CRLF
   cText += "" + CRLF
   //    cText += "with CTRL  (press CTRL 1st) "   +CRLF
   //    cText += "----------------------------"   +CRLF

   cText += "CTRL_F1     God Mode       " + CRLF
   cText += "CTRL_F3     sort Name      " + CRLF
   cText += "CTRL_F4     sort Extension " + CRLF
   cText += "CTRL_F5     sort Date      " + CRLF
   cText += "CTRL_F6     sort Size      " + CRLF
   cText += "CTRL_F7     Unsort         " + CRLF
   cText += "CTRL_F8     TreeFolder (opposite Window)" + CRLF
   cText += "" + CRLF
   cText += "CTRL_E       eject USB Media" + CRLF
   //    cText += "" + CRLF
   cText += "CTRL_S       Setup" + CRLF
   //    cText += "" + CRLF
   cText += "CTRL_T       new Tab in Window" + CRLF
   cText += "CTRL_U      switch Tab Window left / right" + CRLF
   cText += "CTRL_W      close active Tab" + CRLF
   cText += "" + CRLF
   cText += "CTRL_TAB         next Tab in Window" + CRLF
   cText += "SH_CTRL_TAB  back Tab in Window" + CRLF
   cText += "" + CRLF
   //    cText += "with ALT   (press ALT 1st)"      +CRLF
   //    cText += "----------------------------"    +CRLF
   cText += "ALT_F1      left   Drive Combobox" + CRLF
   cText += "ALT_F2      right Drive Combobox" + CRLF
   cText += "ALT_F5      ZIP files" + CRLF
   cText += "ALT_F7      Search using Everything" + CRLF
   cText += "ALT_F10    TreeFolder (select Window)" + CRLF
   cText += "" + CRLF

   //    cText += "Caption       : " + GetSysFont( 'CaptionFont' ) + CRLF
   //    cText += "SmCaption : " + GetSysFont( 'SmCaptionFont' ) + CRLF
   //    cText += "Icon             : " + GetSysFont( 'IconFont' ) + CRLF
   //    cText += "Menu          : " + GetSysFont( 'MenuFont' ) + CRLF
   //    cText += "Message     : " + GetSysFont( 'MessageFont' ) + CRLF
   //    cText += "Status          : " + GetSysFont( 'StatusFont' ) + CRLF

   MSGInfo( cText, "Help ... under construction" )

RETURN NIL

*+ EOF: HELPFILE.PRG
