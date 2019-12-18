*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\CHKSKIP.PRG
*:
*:	Kasem Kamolchaipisit
*:	thai_vfp@hotmail.com
*:	http://members.xoom.com/thai_vfp
*:	
*:	
*:	
*:	
*:	
*:	
*:	
*:	
*:	
*:	
*:
*: Documented using Visual FoxPro Formatting wizard version  .05
*:******************************************************************************
*:   CHKSKIP
*:   CHKSKIP
*******************************************************************
* Function Check Skip Menu Item
*******************************************************************
*!******************************************************************************
*!
*! Procedure CHKSKIP
*!
*!******************************************************************************
Function CHKSKIP
	Para cFormname
	With _Screen.Formset
		nScreen= .FormCount
		For i = 1 To nScreen
			If Upper(Allt(.Forms(i).Name)) = Upper(Allt(cFormname))
				Return .T.
			Endif
		Endfor
	Endwith
	Return .F.

