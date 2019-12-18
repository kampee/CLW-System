*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\GBACKGND.PRG
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
*:   GBACKGND
*:   GBACKGND
*!******************************************************************************
*!
*! Procedure GBACKGND
*!
*!******************************************************************************
Procedure GBACKGND
	Parameter oForm
	If Type('oForm')#'O' And oForm.BaseClass#'Form'
		Return .F.
	Endif
	Local lnfstep,loLine,loLine1,lnDeltaRGB,lnBandCount

	lnBandCount = Iif(oForm.Height>255,255,oForm.Height)
	lnfstep = Ceiling(oForm.Height/lnBandCount)
	lnDeltaRGB = Int(255/lnBandCount)
	lnDeltaRGB = Iif(lnDeltaRGB = 0,1,lnDeltaRGB)
	oForm.LockScreen = .T.
	For i = 0 To lnBandCount
		loLine = [Line]+Alltr(Str(i))
		loLine1=[oForm.]+loLine
		If Type(loLine1) =[U]
			oForm.AddObject(loLine,[Line])
			&loLine1..Left =0
			&loLine1..Height = 0
			&loLine1..ZOrder(1)
			&loLine1..Visible = .T.
		Endif
		&loLine1..BorderWidth = lnfstep
		&loLine1..Top = &loLine1..BorderWidth*i
		&loLine1..Width  = oForm.Width
		&loLine1..BorderColor = Rgb(0, 0,(255-i*lnDeltaRGB))
	Endfor
	oForm.LockScreen = .F.

Endproc
