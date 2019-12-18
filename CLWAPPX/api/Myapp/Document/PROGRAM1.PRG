*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\PROGRAM1.PRG
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
*:   PROGRAM1
* Program1 *
#Define myProgram "โปรแกรมของฉัน"
Private nVAR
myform = Createobject("TestForm")
myform.Show
Store 1 To nVAR
Do While nVAR <= 300
	myform.Height = nVAR
	myform.Width = nVAR
	nVAR = nVAR + 1
Enddo
For nVAR = 4 To 400 Step 4
	myform.Left = nVAR
	myform.Top = nVAR / 4
Endfor && NEXT
Read Events
*:******************************************************************************
*:
*: Class:Testform  BaseClass: FORM
*:
*:******************************************************************************
Define Class Testform As Form
	Caption = myProgram
	Left = 1
	Top = 1
	Height = 1
	Width = 1
	Add Object MyButton As CommandButton With ;
		Caption = "Cancel", ForeColor = Rgb(255,0,0), ;
		Left = 100, Top = 120, Height = 30, Width = 100

	Procedure MyButton.Click
		Release Thisform
		Clear Events
	Endproc
Enddefine
