*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\NUM2THI.PRG
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
*:   NUM2THI
*:   NUM2THI
*******************************************************************
* Function Convert Numeric to Thai Baht
* ---�����...... ����¹����Ţ�繵���ѡ�� (9,999,999,999.99)
* --- ������ҧ...... cSTRING=NUM2THI(9999999999.99)
*******************************************************************
*!******************************************************************************
*!
*! Procedure NUM2THI
*!
*!  Calls
*!      mTCH
*!      mTDEC
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
