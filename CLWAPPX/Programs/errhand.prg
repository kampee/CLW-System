PARAMETER merror, mess, mess1, mprog, mlineno
ON SHUTDOWN
messagebox('Error Code Number: ' + LTRIM(STR(merror)) + CHR(13) + ;
'Error Name: ' + mess + CHR(13) + ;
'Error Message: ' + mess1 + CHR(13) + ;
'Error Line No: ' + LTRIM(STR(mlineno)) + CHR(13) + ;
'Program Name: ' + mprog + CHR(13) + ;
'Please contact to K.Kampee - kampee@clwglobal.com or call.084-7107552'+ CHR(13) + ;
'Please exit program' , 288,"")
QUIT