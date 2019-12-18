*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\THERMO.PRG
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
*:   THERMO
Do Form thermometer Name THERMO
For i = 1 To 300
	THERMO.shape1.Width =    THERMO.shape1.Width + 1
	=Inkey(0.1,"H")
Endfor
THERMO.Release
