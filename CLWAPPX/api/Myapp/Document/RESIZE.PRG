*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\RESIZE.PRG
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
*:   RESIZE
_Screen.Left = 0
_Screen.Top = 0
_Screen.Width = 1
_Screen.Height = 1
_Screen.Visible = .T.
For i = 1 To Sysmetric(2) Step 3
	_Screen.Width = i
	_Screen.Height = i
Endfor
For J = i To Sysmetric(1) Step 3
	_Screen.Width = J
Endfor
