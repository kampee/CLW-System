* Program1 *
#DEFINE myProgram "โปรแกรมของฉัน" 
PRIVATE nVAR 
myForm = CREATEOBJECT("TestForm") 
myForm.Show 
STORE 1 TO nVAR 
DO WHILE nVAR <= 300 
   myForm.Height = nVAR 
   myForm.Width = nVAR 
   nVAR = nVAR + 1 
ENDDO 
FOR nVAR = 4 to 400 STEP 4 
   myForm.left = nVAR 
   myForm.top = nVAR / 4 
ENDFOR && NEXT 
READ EVENTS 
DEFINE CLASS Testform AS FORM 
   Caption = myProgram 
   Left = 1 
   Top = 1 
   Height = 1 
   Width = 1 
   ADD OBJECT MyButton AS CommandButton WITH ; 
      Caption = "Cancel", Forecolor = RGB(255,0,0), ; 
      Left = 100, Top = 120, Height = 30, Width = 100 

   PROCEDURE myButton.Click 
      RELEASE THISFORM 
      CLEAR EVENTS 
   ENDPROC 
ENDDEFINE
