*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\UTILITY.PRG
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
*:   UTILITY
*:   NUM2THI
*:   NUM2ENG
*:   TCDOW
*:   TSCDOW
*:   BC2BE
*:   BE2BC
*:   ENCRYPT_IT
*:   DECRYPT_IT
*:   SHUT_DOWN
*:   errhand
*******************************************************************
* Function Convert Numeric to Thai Baht
* ---�����...... ����¹����Ţ�繵���ѡ�� (9,999,999,999.99)
* --- ������ҧ...... cSTRING=NUM2THI(9999999999.99)
*******************************************************************
*!******************************************************************************
*!
*! Procedure NUM2THI
*!
*!******************************************************************************
Function NUM2THI
	Parameter mNUM
	Dimension mTCH(9),mTDEC(10)
	If mNUM > 9999999999.99 .Or. mNUM <= 0
		Return ''
	Endif
	mTCH(1)='˹��'
	mTCH(2)='�ͧ'
	mTCH(3)='���'
	mTCH(4)='���'
	mTCH(5)='���'
	mTCH(6)='ˡ'
	mTCH(7)='��'
	mTCH(8)='Ỵ'
	mTCH(9)='���'
	mTDEC(1) ='�ѹ'
	mTDEC(2) ='����'
	mTDEC(3) ='�Ժ'
	mTDEC(4) ='��ҹ'
	mTDEC(5) ='�ʹ'
	mTDEC(6) ='����'
	mTDEC(7) ='�ѹ'
	mTDEC(8) ='����'
	mTDEC(9) ='�Ժ'
	mTDEC(10)=''
	mSTNUM=Str(mNUM*100,12)
	mSTTHAI=''
	mCNT=1
	Do Whil mCNT<=10
		mCHNUM=Substr(mSTNUM,mCNT,1)
		If mCHNUM=' '
			mSTTHAI=mSTTHAI+''
		Else
			If mCHNUM='0'
				mSTTHAI=Iif(mCNT=4,mSTTHAI+'��ҹ',mSTTHAI+'')
			Else
				If mCHNUM='1'
					If (mCNT=4.And.Len(Ltrim(mSTNUM))#9).Or.  ;
							(mCNT=10.And.Len(Ltrim(mSTNUM))#3)
						mSTTHAI=mSTTHAI+'���'
					Else
						If .Not.(mCNT=3.Or.mCNT=9)
							mSTTHAI=mSTTHAI+mTCH(Val(mCHNUM))
						Endif
					Endif
				Else
					If mCHNUM='2'.And.(mCNT=3.Or.mCNT=9)
						mSTTHAI=mSTTHAI+'���'
					Else
						mSTTHAI=mSTTHAI+mTCH(Val(mCHNUM))
					Endif
				Endif
				mSTTHAI=mSTTHAI+mTDEC(mCNT)
			Endif
		Endif
		mCNT=mCNT+1
	Enddo
	mSTTHAI=mSTTHAI+'�ҷ'
	If Substr(mSTNUM,11,2)='00'
		mSTTHAI=mSTTHAI+'��ǹ'
	Else
		mCHNUM=Substr(mSTNUM,11,1)
		If mCHNUM#'0'
			If mCHNUM#'1'
				If mCHNUM='2'
					mSTTHAI=mSTTHAI+'���'
				Else
					mSTTHAI=mSTTHAI+mTCH(Val(mCHNUM))
				Endif
			Endif
			mSTTHAI=mSTTHAI+mTDEC(9)
		Endif
		mCHNUM=Substr(mSTNUM,12,1)
		If mCHNUM#'0'
			If mCHNUM='1'.And.Substr(mSTNUM,11,1)#'0'
				mSTTHAI=mSTTHAI+'���'
			Else
				mSTTHAI=mSTTHAI+mTCH(Val(mCHNUM))
			Endif
		Endif
		mSTTHAI=mSTTHAI+'ʵҧ��'
	Endif
	Retu mSTTHAI
Endfunc

*******************************************************************
* Function Convert Numeric to English Baht
* ---�����...... ����¹����Ţ�繵���ѡ�� (9,999,999,999.99)
* --- ������ҧ...... cSTRING=NUM2THI(9999999999.99)
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
	Store '' To wordAmt, SatangAmt
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
	cSatang = Right(chrAmt,2)
	If Dtens > 0
		If Dtens > 20
			cDvar = 'Baht'+Left(cSatang,1)+'0'
			SatangAmt = SatangAmt + Eval(cDvar)
			If Right(cSatang,1) > '0'
				cDvar = 'Baht'+Right(cSatang,1)
				SatangAmt = SatangAmt + '-'+ Eval(cDvar)+Space(1)
			Else
				SatangAmt = SatangAmt + Space(1)
			Endif
		Else
			cDvar = 'Baht'+Ltrim(Str(Dtens))
			SatangAmt = SatangAmt + Eval(cDvar) + Space(1)
		Endif
	Endif
	wordAmt = Iif(numAmt<=0, '', wordAmt + ;
		IIF(Right(chrAmt,2)>'00', ;
		IIF (numAmt > 1,'BAHT AND'+Space(1),'') + ;
		SatangAmt+Space(1)+'SATANG',  ;
		'BAHT ONLY'))
	Return wordAmt
Endfunc

*******************************************************************
* Function Convert day of week (Thai)
* ---�����...... �ʴ��ѹ��ѻ����
* --- ������ҧ...... cDAY=TCDOW(DATE())
*******************************************************************
*!******************************************************************************
*!
*! Procedure TCDOW
*!
*!******************************************************************************
Function TCDOW
	Parameter dDATE
	nDay=Dow(dDATE)
	Do Case
	Case nDay=1
		Return '�ҷԵ��'
	Case nDay=2
		Return '�ѹ���'
	Case nDay=3
		Return '�ѧ���'
	Case nDay=4
		Return '�ظ'
	Case nDay=5
		Return '����ʺ��'
	Case nDay=6
		Return '�ء��'
	Case nDay=7
		Return '�����'
	Otherwise
		Return ''
	Endcase
Endfunc

*******************************************************************
* Function Convert day of week (Thai) short
* ---�����...... �ʴ��ѹ��ѻ�������ҧ���
* --- ������ҧ...... cDAY=TSCDOW(DATE())
*******************************************************************
*!******************************************************************************
*!
*! Procedure TSCDOW
*!
*!******************************************************************************
Function TSCDOW
	Parameter mdtm
	mdtnm=Dow(mdtm)
	mcdm=Subst('�Ҩ.�.�.���.�.',2*mdtnm-1,2)
	Return (mcdm)
Endfunc

***************************************************************
* Function Convert date from BC to BE
* ---�����...... �ŧ����ѹ���ҡ �.�. �� �.�.
* ---������ҧ...... cTDATE=BC2BE(DATE())
***************************************************************
*!******************************************************************************
*!
*! Procedure BC2BE
*!
*!******************************************************************************
Func BC2BE
	Para BCDATE && �.�.
	If Type('BCDATE')#'D'
		Return ''
	Endif
	Local cDD,cMM
	cDD = Allt(Str(Day(BCDATE),2))
	cDD = Iif(Len(cDD)=1,"0"+cDD,cDD)
	cMM = Allt(Str(Month(BCDATE),2))
	cMM = Iif(Len(cMM)=1,"0"+cMM,cMM)
	Retu cDD+'/'+cMM+'/'+Str(Year(BCDATE)+543,4)

	***************************************************************
	* Function Convert date from BE to BC
	* ---�����...... �ŧ����ѹ���ҡ �.�. �� �.�.
	*-- �����...... dEDATE=BE2BC('25/03/2543')
	***************************************************************
*!******************************************************************************
*!
*! Procedure BE2BC
*!
*!******************************************************************************
Func BE2BC
	Para     BEDATE && DD/MM/YYYY �.�.
	Local    nDD,nMM,nYYYY
	If Type('BEDATE')#'C'
		Return ''
	Endif
	nDD = Val(Subst(BEDATE,1,2))
	nMM = Val(Subst(BEDATE,4,2))
	nYYYY = Val(Subst(BEDATE,7,4))-543
	Return Date(nYYYY,nMM,nDD)

	*******************************************************************
	* Function Encryption
	* ---�����...... �������
	* --- ������ҧ...... cEncrypt = ENCRYPT_IT("KASEM")
	*******************************************************************
*!******************************************************************************
*!
*! Procedure ENCRYPT_IT
*!
*!******************************************************************************
Function ENCRYPT_IT     && Call this to encrypt password
	Parameters cPassword
	cEncrypted_password = ''
	For i = 1 To Len(cPassword)
		cLetter = Substr(cPassword, i, 1)
		cEncrypted_password = cEncrypted_password + ;
			CHR(Mod(Asc(cLetter)+100,255))      && Encryption formula
	Next i
	Return cEncrypted_password
Endfunc

*******************************************************************
* Function Decryption
* ---�����...... ��Ҷʹ����
* --- ������ҧ...... cDecrypt = DECRYPT_IT(ENCRYPT_IT("KASEM"))
*******************************************************************
*!******************************************************************************
*!
*! Procedure DECRYPT_IT
*!
*!******************************************************************************
Function  DECRYPT_IT     && Call this to Decrypt password
	Parameters cPassword
	cUnencrypted_password = ''
	For i = 1 To Len(cPassword)
		cLetter = Substr(cPassword, i, 1)
		cUnencrypted_password = cUnencrypted_password + ;
			CHR(Mod(Asc(cLetter)-100,255))    && Reverse of encryption formula
	Next i
	Return cUnencrypted_password
Endfunc

*******************************************************************
* Procedure ShutDown
* ---�����...... �׹�ѹ����͡�ҡ�����
* --- ������ҧ......  ON SHUTDOWN DO SHUT_DOWN
*******************************************************************
*!******************************************************************************
*!
*! Procedure SHUT_DOWN
*!
*!******************************************************************************
Procedure SHUT_DOWN
	Local nAnswer
	nAnswer = Messagebox("��ͧ����͡�ҡ�����",292,"")
	If nAnswer = 6
		Quit
	Endif
Endproc

*******************************************************************
* Procedure OnError
* ---�����...... �ʴ���ͼԴ��Ҵ����Դ���
* --- ������ҧ......  ON ERROR DO ERRHAND WITH ERROR( ),MESSAGE( ),MESSAGE(1),PROGRAM( ),LINENO( )
*******************************************************************
*!******************************************************************************
*!
*! Procedure ERRHAND
*!
*!******************************************************************************
Procedure errhand
	Parameter merror, Mess, mess1, mprog, mlineno
	Messagebox('�����Ţ��ͼԴ��Ҵ: ' + Ltrim(Str(merror)) + Chr(13) +  ;
		'��ͼԴ��Ҵ: ' + Mess + Chr(13) +  ;
		'��÷Ѵ��ͼԴ��Ҵ: ' + mess1 + Chr(13) +  ;
		'��÷Ѵ���Դ��Ҵ: ' + Ltrim(Str(mlineno)) + Chr(13) + ;
		'�����: ' + mprog + Chr(13) + ;
		'Please contact your Vendor '+ Chr(13) + ;
		'��Ҥس�Դ Visual FoxPro �����͹�������Դ�������¡������ա����' , 288,"")
	On Shutdown
	*     QUIT
Endproc

*** End of  Program ***
