*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\PROGRAM3.PRG
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
*:   PROGRAM3
* Program3
* Test will hold references to 5 forms
Public Array oTest(1)
Dimension oTest(5)
Store 1 To nCount
Do Whil nCount <= 20
	? 'Display Loop ====>  ' + Alltrim(Str(nCount))
	nCount = nCount + 1
Enddo
Wait Window 'Press any key to continue.'
* Clear the screen
_Screen.Cls
* Fill the array with forms
For nCount = 1 To 5
	oTest(nCount) = Createobject("testform")
Endfor
* Ask the user if they want to see the forms
nAnswer = Messagebox("Do you want to see the forms?", ;
	36, "Multiple Instances - Arrays")
If nAnswer = 6 && yes
	For nCount = 1 To 5
		If Type("oTest(nCount)") = "O"   && "O" = Object
			oTest(nCount).Show
			oTest(nCount).Top = 30*nCount
			oTest(nCount).Left = 50*nCount
			_Screen.ActiveForm.BackColor= ;
				RGB(51*nCount,255,255)
			* less than or equal to  255
		Endif
	Endfor
Endif
*:******************************************************************************
*:
*: Class:Testform  BaseClass: Form
*:
*:******************************************************************************
Define Class Testform As Form
	Add Object CmdExit As CommandButton With ;
		Caption = "E\<xit", Top = 100, Left = 140, ;
		Height = 29, Width = 94, Visible = .T.
	Procedure CmdExit.Click
		Release Thisform
	Endproc
Enddefine
