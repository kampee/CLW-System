*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\PROGRAM2.PRG
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
*:   PROGRAM2
*Program2
#Define myProgram "โปรแกรมแสดงการทดสอบเงื่อนไข"
Private nVAR
myform = Createobject("TestForm")
myForm2 = Createobject("DisplayColor")
myform.Show
myForm2.Show
myForm2.BackColor = Rgb(255,0,0)
Read Events

*:******************************************************************************
*:
*: Class:Testform  BaseClass: FORM
*:
*:******************************************************************************
Define Class Testform As Form
	Caption = "myProgram"
	Top = 1
	Left = 0
	Height = 250
	Width = 300
	Add Object MyButton As CommandButton With ;
		Top = 180, Left = 36, Height = 37, Width = 73, ;
		Caption = "Exit"
	Add Object MyGroup As OptionGroup With ;
		AutoSize = .T. , ButtonCount = 5, BackStyle = 1, Value=1,;
		Height=108,Left=36,Top=48,Width=78, ;
		Option1.FontName = "CordiaUPC", Option1.FontSize=16, ;
		Option1.Caption = "สีแดง", ;
		Option1.Height = 18, Option1.Left = 5, ;
		Option1.Top = 5, Option1.Width = 68, ;
		Option2.FontName = "CordiaUPC", Option2.FontSize =16, ;
		Option2.Caption = "สีเหลือง", ;
		Option2.Height = 18, Option2.Left = 5, ;
		Option2.Top = 25, Option2.Width = 68, ;
		Option3.FontName = "CordiaUPC", Option3.FontSize =16, ;
		Option3.Caption = "สีเขียว", ;
		Option3.Height = 18, Option3.Left = 5, ;
		Option3.Top = 45, Option3.Width = 68, ;
		Option4.FontName = "CordiaUPC", Option4.FontSize =16, ;
		Option4.Caption = "สีน้ำเงิน", ;
		Option4.Height = 18, Option4.Left = 5, ;
		Option4.Top = 65, Option4.Width = 68, ;
		Option5.FontName = "CordiaUPC", Option5.FontSize =16, ;
		Option5.Caption = "สีขาว", ;
		Option5.Height = 18, Option5.Left = 5, ;
		Option5.Top = 85, Option5.Width = 68
	Add Object MyCheckBox As Checkbox With ;
		Top = 84, Left = 144, Height = 49, Width = 121, ;
		FontName = "CordiaUPC", FontSize = 16, ;
		Caption = "แสดงหน้าต่าง", Value = 1

	Procedure MyButton.Click
		Release Thisform
		Clear Events
	Endproc

	Procedure MyCheckBox.Click
		If myform.MyCheckBox.Value = 1
			myForm2.Show
		Else
			myForm2.Hide
		Endif
	Endproc

	Procedure MyGroup.Click
		Do Case
		Case myform.MyGroup.Value = 1
			myForm2.BackColor = Rgb(255,0,0)
		Case myform.MyGroup.Value = 2
			myForm2.BackColor = Rgb(255,255,0)
		Case myform.MyGroup.Value = 3
			myForm2.BackColor = Rgb(0,255,0)
		Case myform.MyGroup.Value = 4
			myForm2.BackColor = Rgb(0,0,128)
		Case myform.MyGroup.Value = 5
			myForm2.BackColor = Rgb(255,255,255)
		Otherwise
			myForm2.BackColor = Rgb(255,255,255)
		Endcase
		myForm2.Refresh
	Endproc
Enddefine
*:******************************************************************************
*:
*: Class:DisplayColor  BaseClass: FORM
*:
*:******************************************************************************
Define Class DisplayColor As Form
	Caption = myProgram
	Top = 1
	Left = 320
	Height = 250
	Width = 300
Enddefine
