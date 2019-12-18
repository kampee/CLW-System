* Program3 
* Test will hold references to 5 forms 
PUBLIC ARRAY oTest(1) 
DIMENSION oTest(5) 
STORE 1 TO nCount 
DO WHIL nCount <= 20 
   ? 'Display Loop ====>  ' + ALLTRIM(STR(nCount)) 
   nCount = nCount + 1 
ENDDO 
WAIT WINDOW 'Press any key to continue.' 
* Clear the screen 
_SCREEN.CLS 
* Fill the array with forms 
FOR nCount = 1 TO 5 
   oTest(nCount) = CREATEOBJECT("testform") 
ENDFOR 
* Ask the user if they want to see the forms 
nAnswer = MESSAGEBOX("Do you want to see the forms?", ; 
               36, "Multiple Instances - Arrays") 
IF nAnswer = 6 && yes 
   FOR nCount = 1 TO 5 
      IF TYPE("oTest(nCount)") = "O"   && "O" = Object 
         oTest(nCount).Show 
         oTest(nCount).Top = 30*nCount 
         oTest(nCount).Left = 50*nCount 
         _SCREEN.ActiveForm.BackColor= ;
                                                     RGB(51*ncount,255,255) 
         * less than or equal to  255
      ENDIF 
   ENDFOR 
ENDIF 
DEFINE CLASS testform AS Form 
   ADD OBJECT cmdExit As CommandButton WITH ; 
      Caption = "E\<xit", Top = 100, Left = 140, ; 
      Height = 29, Width = 94, Visible = .T. 
PROCEDURE cmdExit.Click 
   RELEASE ThisForm 
ENDPROC 
ENDDEFINE 
