PROCEDURE GBackgnd 
PARAMETER oForm 
IF TYPE('oForm')#'O' AND oForm.BaseClass#'Form' 
   RETURN .F. 
ENDIF 
LOCAL lnfstep,loLine,loLine1,lnDeltaRGB,lnBandCount 

lnBandCount = IIF(oForm.Height>255,255,oForm.Height) 
lnfstep = CEILING(oForm.Height/lnBandcount) 
lnDeltaRGB = INT(255/lnBandCount) 
lnDeltaRGB = IIF(lnDeltaRGB = 0,1,lnDeltaRGB) 
oForm.LockScreen = .T. 
FOR i = 0 TO lnBandCount 
  loLine = [Line]+ALLTR(STR(i)) 
  loLine1=[oForm.]+loLine 
  IF TYPE(loline1) =[U] 
     oForm.Addobject(loLine,[Line]) 
     &loLine1..Left =0 
     &loLine1..Height = 0 
     &loLine1..Zorder(1) 
     &loLine1..Visible = .T. 
  ENDIF   
  &loLine1..BorderWidth = lnfstep 
  &loLine1..Top = &loLine1..BorderWidth*i 
  &loLine1..Width  = oForm.width 
  &loLine1..Bordercolor = RGB(0, 0,(255-i*lnDeltaRGB)) 
ENDFOR 
oForm.LockScreen = .F. 

ENDPROC 
