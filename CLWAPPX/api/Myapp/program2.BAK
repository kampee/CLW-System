*Program2 
#DEFINE myProgram "โปรแกรมแสดงการทดสอบเงื่อนไข" 
PRIVATE nVAR 
myForm = CREATEOBJECT("TestForm") 
myForm2 = CREATEOBJECT("DisplayColor") 
myForm.Show 
myForm2.Show
myForm2.BackColor = RGB(255,0,0)
READ EVENTS 

DEFINE CLASS TestForm AS FORM
   Caption = "myProgram"
   Top = 1 
   Left = 0 
   Height = 250 
   Width = 300 
ADD OBJECT MyButton AS CommandButton WITH ;
   Top = 180, Left = 36, Height = 37, Width = 73, ;
   Caption = "Exit"
ADD OBJECT MyGroup AS OptionGroup WITH ;
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
ADD OBJECT MyCheckBox AS CheckBox WITH ;
   Top = 84, Left = 144, Height = 49, Width = 121, ;
   FontName = "CordiaUPC", FontSize = 16, ;
   Caption = "แสดงหน้าต่าง", Value = 1

PROCEDURE myButton.Click
   RELEASE THISFORM
   CLEAR EVENTS
ENDPROC

PROCEDURE myCheckBox.Click
   IF myForm.myCheckBox.Value = 1
      myForm2.Show
   ELSE
      myForm2.Hide
   ENDIF
ENDPROC

PROCEDURE myGroup.Click
   DO CASE
   CASE myForm.myGroup.Value = 1
      myForm2.BackColor = RGB(255,0,0)
   CASE myForm.myGroup.Value = 2
      myForm2.BackColor = RGB(255,255,0)
   CASE myForm.myGroup.Value = 3
      myForm2.BackColor = RGB(0,255,0)
   CASE myForm.myGroup.Value = 4
      myForm2.BackColor = RGB(0,0,128)
   CASE myForm.myGroup.Value = 5
      myForm2.BackColor = RGB(255,255,255)
   OTHERWISE
      myForm2.BackColor = RGB(255,255,255)
   ENDCASE
   myForm2.Refresh
ENDPROC
ENDDEFINE
DEFINE CLASS DisplayColor AS FORM
   Caption = myProgram
   Top = 1
   Left = 320
   Height = 250
   Width = 300
ENDDEFINE
