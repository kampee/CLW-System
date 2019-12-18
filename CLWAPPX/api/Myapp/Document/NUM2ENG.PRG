*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\NUM2ENG.PRG
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
*:   NUM2ENG
*:   NUM2ENG
*******************************************************************
* Function Convert Numeric to English Baht
* ---โปรแกรม...... เปลี่ยนตัวเลขเป็นตัวอักษร (9,999,999,999.99)
* --- ตัวอย่าง...... cSTRING=NUM2THI(9999999999.99)
*******************************************************************
*!******************************************************************************
*!
*! Procedure NUM2ENG
*!
*!******************************************************************************
Function NUM2ENG
	Parameter numAmt
	Private numAmt, chrAmt, cDNums, wordAmt, cDvar
	If numAmt > 999999999.99 Or numAmt <= 0
		Return ''
	Endif
	chrAmt=Right('000000000'+Ltrim(Str(numAmt,12,2)),12)
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
	Store '' To wordAmt, StrangAmt
	IsHundred = .F.
	checkMillion =.T.
	For Counter = 1 To 3
		Do Case
		Case Counter = 1
			cDNums = Substr(chrAmt,1,3)
		Case Counter = 2
			cDNums = Substr(chrAmt,4,3)
		Case Counter = 3
			cDNums = Substr(chrAmt,7,3)
		Endcase
		If Left(cDNums, 1) > '0'
			cDvar = 'Baht'+Left(cDNums,1)
			wordAmt = wordAmt + Eval(cDvar)+Space(1)+ ;
				'HUNDRED'+Space(1)
			IsHundred = .T.
			If Counter = 2
				checkMillion = .T.
			Endif
		Endif
		Dtens = Val(Substr(cDNums,2,2))
		If Dtens > 0
			If Dtens > 20
				cDvar = 'Baht'+Substr(cDNums,2,1)+'0'
				wordAmt = wordAmt + Eval(cDvar)
				If Substr(cDNums,3,1) > '0'
					cDvar = 'Baht'+Substr(cDNums,3,1)
					wordAmt = wordAmt + '-'+ Eval(cDvar) + Space(1)
				Else
					wordAmt = wordAmt + Space(1)
				Endif
			Else
				cDvar = 'Baht'+Ltrim(Str(Dtens))
				wordAmt = wordAmt + Eval(cDvar) + Space(1)
			Endif
			IsHundred = .F.
			If Counter = 2
				checkMillion = .T.
			Endif
		Endif
		If numAmt > 999999.99 .And. Counter = 1
			wordAmt = wordAmt + Space(1)+'MILLION'+Space(1)
			checkMillion = .F.
		Endif
		If checkMillion
			If numAmt > 999.99 .And. Counter = 2
				If Dtens > 0
					wordAmt=wordAmt+Space(1)+'THOUSAND'+Space(1)
				Endif
				If IsHundred
					wordAmt=wordAmt+Space(1)+'THOUSAND'+Space(1)
				Endif
			Endif
		Endif
	Endfor
	Dtens = Val(Right(chrAmt,2))
	cStrang = Right(chrAmt,2)
	If Dtens > 0
		If Dtens > 20
			cDvar = 'Baht'+Left(cStrang,1)+'0'
			StrangAmt = StrangAmt + Eval(cDvar)
			If Right(cStrang,1) > '0'
				cDvar = 'Baht'+Right(cStrang,1)
				StrangAmt = StrangAmt + '-'+ Eval(cDvar)+Space(1)
			Else
				StrangAmt = StrangAmt + Space(1)
			Endif
		Else
			cDvar = 'Baht'+Ltrim(Str(Dtens))
			StrangAmt = StrangAmt + Eval(cDvar) + Space(1)
		Endif
	Endif
	wordAmt = Iif(numAmt<=0, '', wordAmt + ;
		IIF(Right(chrAmt,2)>'00', ;
		IIF (numAmt > 1,'BAHT AND'+Space(1),'') + ;
		StrangAmt+Space(1)+'SATANG',  ;
		'BAHT ONLY'))
	Return wordAmt
Endfunc
