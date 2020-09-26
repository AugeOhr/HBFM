change in HMG \Source Code

---

modify c:\hmg.3.4.4\SOURCE\H_BROWSE.PRG and h_controlmisc.prg for Type "I", "T" and "@"
search for comment "by Jimmy"

---

i have extract C-Code (still in Source) from

C:\hmg.3.4.4\SOURCE\h_controlmisc.prg
C:\hmg.3.4.4\SOURCE\h_HMG_HPDF.Prg
C:\hmg.3.4.4\SOURCE\h_HMG_HPDF_UNICODE.prg

and Build HB_FUNC.PRG (for CLICK) with C-Code
new hmg32.hbp and hmg64.hbp include HB_FUNC.PRG

---

modify for CLICK this Syntax in H_GRID.PRG

   IF AEC = 'EDITBOX'
      DEFINE WINDOW
   ELSE
      DEFINE WINDOW
   ENDIF

---

change Code in c:\hmg.3.4.4\SOURCE\0\h_textbox.prg for CLICK Syntax

#ifdef COMPILE_HMG_UNICODE
      if c != '9' .and.  c != '$' .and. c != '*' .and. c !='.' .and. c != ','  .and. c != ' ' .and. c != 'Ђ' .and. c != 'в‚¬'
#else
      if c != '9' .and.  c != '$' .and. c != '*' .and. c !='.' .and. c != ','  .and. c != ' ' .and. c != 'Ђ'
#endif
         MsgHMGError("@...TEXTBOX: Wrong InputMask Definition" )
      EndIf

---

change Code in c:\hmg.3.4.4\SOURCE\h_HMG_HPDF_UNICODE.prg
   DrawText (hDC, cText, -1, &rect, DT_NOCLIP | DT_WORDBREAK | /*DT_EXTERNALLEADING |*/ DT_NOPREFIX | nAlign);

---

after run CLICK there is a Error in

FUNCTION HMG_CallDLL( cLibName, nRetType, cFuncName, ... )
STATIC s_hDLL   := { = > }

must be

STATIC s_hDLL   := { => }

i do upload to Github HBFM under \Source
backup your \Source Folder befor replace with include files

have fun
Jimmy
26.09.2020

