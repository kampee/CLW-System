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
* ---โปรแกรม...... เปลี่ยนตัวเลขเป็นตัวอักษร (9,999,999,999.99)
* --- ตัวอย่าง...... cSTRING=NUM2THI(9999999999.99)
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
	mTCH(1)='หนึ่ง'
	mTCH(2)='สอง'
	mTCH(3)='สาม'
	mTCH(4)='สี่'
	mTCH(5)='ห้า'
	mTCH(6)='หก'
	mTCH(7)='เจ็ด'
	mTCH(8)='แปด'
	mTCH(9)='เก้า'
	mTDEC(1) ='พัน'
	mTDEC(2) ='ร้อย'
	mTDEC(3) ='สิบ'
	mTDEC(4) ='ล้าน'
	mTDEC(5) ='แสน'
	mTDEC(6) ='หมื่น'
	mTDEC(7) ='พัน'
	mTDEC(8) ='ร้อย'
	mTDEC(9) ='สิบ'
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
				mSTTHAI=Iif(mCNT=4,mSTTHAI+'ล้าน',mSTTHAI+'')
			Else
				If mCHNUM='1'
					If (mCNT=4.And.Len(Ltrim(mSTNUM))#9).Or.  ;
							(mCNT=10.And.Len(Ltrim(mSTNUM))#3)
						mSTTHAI=mSTTHAI+'เอ็ด'
					Else
						If .Not.(mCNT=3.Or.mCNT=9)
							mSTTHAI=mSTTHAI+mTCH(Val(mCHNUM))
						Endif
					Endif
				Else
					If mCHNUM='2'.And.(mCNT=3.Or.mCNT=9)
						mSTTHAI=mSTTHAI+'ยี่'
					Else
						mSTTHAI=mSTTHAI+mTCH(Val(mCHNUM))
					Endif
				Endif
				mSTTHAI=mSTTHAI+mTDEC(mCNT)
			Endif
		Endif
		mCNT=mCNT+1
	Enddo
	mSTTHAI=mSTTHAI+'บาท'
	If Substr(mSTNUM,11,2)='00'
		mSTTHAI=mSTTHAI+'ถ้วน'
	Else
		mCHNUM=Substr(mSTNUM,11,1)
		If mCHNUM#'0'
			If mCHNUM#'1'
				If mCHNUM='2'
					mSTTHAI=mSTTHAI+'ยี่'
				Else
					mSTTHAI=mSTTHAI+mTCH(Val(mCHNUM))
				Endif
			Endif
			mSTTHAI=mSTTHAI+mTDEC(9)
		Endif
		mCHNUM=Substr(mSTNUM,12,1)
		If mCHNUM#'0'
			If mCHNUM='1'.And.Substr(mSTNUM,11,1)#'0'
				mSTTHAI=mSTTHAI+'เอ็ด'
			Else
				mSTTHAI=mSTTHAI+mTCH(Val(mCHNUM))
			Endif
		Endif
		mSTTHAI=mSTTHAI+'สตางค์'
	Endif
	Retu mSTTHAI
Endfunc
