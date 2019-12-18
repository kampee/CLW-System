*******************************************************************
* Function Convert Numeric to English Baht
* ---โปรแกรม...... เปลี่ยนตัวเลขเป็นตัวอักษร (9,999,999,999.99)
* --- ตัวอย่าง...... cSTRING=NUM2THI(9999999999.99)
*******************************************************************
Function NUM2ENG
PARAMETER numAmt
PRIVATE numAmt, chrAmt, cDNums, wordAmt, cDvar
IF numAmt > 999999999.99 OR numAmt <= 0
	RETURN ''
ENDIF
chrAmt=RIGHT('000000000'+LTRIM(STR(numAmt,12,2)),12)
   Baht1 = 'ONE'
   Baht2 = 'TWO'
   Baht3 = 'THREE'
   Baht4 = 'FOUR'
   Baht5 = 'FIVE'
   Baht6 = 'SIX'
   Baht7 = 'SEVEN'
   Baht8 = 'EIGHT'
   Baht9 = 'NINE'
   Baht10 = 'TEN'
   Baht11 = 'ELEVEN'
   Baht12 = 'TWELVE'
   Baht13 = 'THIRTEEN'
   Baht14 = 'FOURTEEN'
   Baht15 = 'FIFTEEN'
   Baht16 = 'SIXTEEN'
   Baht17 = 'SEVENTEEN'
   Baht18 = 'EIGHTEEN'
   Baht19 = 'NINETEEN'
   Baht20 = 'TWENTY'
   Baht30 = 'THIRTY'
   Baht40 = 'FORTY'
   Baht50 = 'FIFTY'
   Baht60 = 'SIXTY'
   Baht70 = 'SEVENTY'
   Baht80 = 'EIGHTY'
   Baht90 = 'NINETY'
   STORE '' TO wordAmt, StrangAmt
   IsHundred = .F.
   checkMillion =.T.
FOR Counter = 1 TO 3
DO CASE
   CASE Counter = 1
      cDNums = SUBSTR(chrAmt,1,3)
   CASE Counter = 2
      cDNums = SUBSTR(chrAmt,4,3)
   CASE Counter = 3
      cDnums = SUBSTR(chrAmt,7,3)
ENDCASE
IF LEFT(cDNums, 1) > '0'
   cDvar = 'Baht'+LEFT(cDNums,1)
   wordAmt = wordAmt + EVAL(cDvar)+SPACE(1)+ ;
                     'HUNDRED'+SPACE(1)
   IsHundred = .T.
   IF Counter = 2
      CheckMillion = .T.
   ENDIF
ENDIF
Dtens = VAL(SUBSTR(cDNums,2,2))
IF Dtens > 0
   IF Dtens > 20
      cDvar = 'Baht'+SUBSTR(cDNums,2,1)+'0'
      wordAmt = wordAmt + EVAL(cDvar)
      IF SUBSTR(cDNums,3,1) > '0'
         cDvar = 'Baht'+SUBSTR(cDNums,3,1)
         wordAmt = wordAmt + '-'+ EVAL(cDvar) + SPACE(1)
      ELSE
         wordAmt = wordAmt + SPACE(1)
      ENDIF
   ELSE
      cDvar = 'Baht'+LTRIM(STR(Dtens))
      wordAmt = wordAmt + EVAL(cDvar) + SPACE(1)
   ENDIF
   IsHundred = .F.
   IF Counter = 2
      CheckMillion = .T.
   ENDIF
ENDIF
IF numAmt > 999999.99 .AND. Counter = 1
   wordAmt = wordAmt + SPACE(1)+'MILLION'+SPACE(1)
   CheckMillion = .F.
ENDIF
IF CheckMillion
   IF numAmt > 999.99 .AND. Counter = 2
      IF Dtens > 0
         wordAmt=wordAmt+SPACE(1)+'THOUSAND'+SPACE(1)
      ENDIF
      IF IsHundred
         wordAmt=wordAmt+SPACE(1)+'THOUSAND'+SPACE(1)
      ENDIF
   ENDIF
ENDIF
ENDFOR
Dtens = VAL(RIGHT(chrAmt,2)) 
cStrang = RIGHT(chrAmt,2)
IF Dtens > 0
   IF Dtens > 20
       cDvar = 'Baht'+LEFT(cStrang,1)+'0'
      StrangAmt = StrangAmt + EVAL(cDvar)
      IF RIGHT(cStrang,1) > '0'
         cDvar = 'Baht'+RIGHT(cStrang,1)
         StrangAmt = StrangAmt + '-'+ EVAL(cDvar)+SPACE(1)
      ELSE
         StrangAmt = StrangAmt + SPACE(1)
      ENDIF
   ELSE
      cDvar = 'Baht'+LTRIM(STR(Dtens))
      StrangAmt = StrangAmt + EVAL(cDvar) + SPACE(1)
   ENDIF
ENDIF
wordAmt = IIF(numAmt<=0, '', wordAmt + ;
                        IIF(RIGHT(chrAmt,2)>'00', ;
                          IIF (numAmt > 1,'BAHT AND'+SPACE(1),'') + ;
                                 StrangAmt+SPACE(1)+'SATANG',  ;
                                 'BAHT ONLY'))
RETURN wordAmt
ENDFUNC
