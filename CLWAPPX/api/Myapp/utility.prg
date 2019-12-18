*******************************************************************
* Function Convert Numeric to Thai Baht
* ---�����...... ����¹����Ţ�繵���ѡ�� (9,999,999,999.99)
* --- ������ҧ...... cSTRING=NUM2THI(9999999999.99)
*******************************************************************
FUNCTION NUM2THI
PARAMETER mNUM 
DIMENSION mTCH(9),mTDEC(10)
   IF mNUM > 9999999999.99 .OR. Mnum <= 0
      RETURN ''
   ENDIF
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
   mSTNUM=STR(mNUM*100,12)
   mSTTHAI=''
   mCNT=1
   DO WHIL mCNT<=10
      mCHNUM=SUBSTR(mSTNUM,mCNT,1)
      IF mCHNUM=' '
         mSTTHAI=mSTTHAI+''
      ELSE
         IF mCHNUM='0'
            mSTTHAI=IIF(mCNT=4,mSTTHAI+'��ҹ',mSTTHAI+'')
         ELSE
            IF mCHNUM='1'
              IF (mCNT=4.AND.LEN(LTRIM(mSTNUM))#9).OR.  ;
                  (mCNT=10.AND.LEN(LTRIM(mSTNUM))#3)
                  mSTTHAI=mSTTHAI+'���'
              ELSE
                  IF .NOT.(mCNT=3.OR.mCNT=9)
                     mSTTHAI=mSTTHAI+mTCH(VAL(mCHNUM))
                 ENDIF
               ENDIF
            ELSE
               IF mCHNUM='2'.AND.(mCNT=3.OR.mCNT=9)
                  mSTTHAI=mSTTHAI+'���'
               ELSE
                  mSTTHAI=mSTTHAI+mTCH(VAL(mCHNUM))
               ENDIF
            ENDIF
            mSTTHAI=mSTTHAI+mTDEC(mCNT)
         ENDIF
      ENDIF
      mCNT=mCNT+1
   ENDDO
   mSTTHAI=mSTTHAI+'�ҷ'
   IF SUBSTR(mSTNUM,11,2)='00'
      mSTTHAI=mSTTHAI+'��ǹ'
   ELSE
      mCHNUM=SUBSTR(mSTNUM,11,1)
      IF mCHNUM#'0'
         IF mCHNUM#'1'
            IF mCHNUM='2'
               mSTTHAI=mSTTHAI+'���'
            ELSE
               mSTTHAI=mSTTHAI+mTCH(VAL(mCHNUM))
            ENDIF
         ENDIF
         mSTTHAI=mSTTHAI+mTDEC(9)
      ENDIF
      mCHNUM=SUBSTR(mSTNUM,12,1)
      IF mCHNUM#'0'
         IF mCHNUM='1'.AND.SUBSTR(mSTNUM,11,1)#'0'
            mSTTHAI=mSTTHAI+'���'
         ELSE
            mSTTHAI=mSTTHAI+mTCH(VAL(mCHNUM))
         ENDIF
      ENDIF
      mSTTHAI=mSTTHAI+'ʵҧ��'
   ENDIF
   RETU mSTTHAI
ENDFUNC

*******************************************************************
* Function Convert Numeric to English Baht
* ---�����...... ����¹����Ţ�繵���ѡ�� (9,999,999,999.99)
* --- ������ҧ...... cSTRING=NUM2THI(9999999999.99)
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
   STORE '' TO wordAmt, SatangAmt
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
cSatang = RIGHT(chrAmt,2)
IF Dtens > 0
   IF Dtens > 20
       cDvar = 'Baht'+LEFT(cSatang,1)+'0'
      SatangAmt = SatangAmt + EVAL(cDvar)
      IF RIGHT(cSatang,1) > '0'
         cDvar = 'Baht'+RIGHT(cSatang,1)
         SatangAmt = SatangAmt + '-'+ EVAL(cDvar)+SPACE(1)
      ELSE
         SatangAmt = SatangAmt + SPACE(1)
      ENDIF
   ELSE
      cDvar = 'Baht'+LTRIM(STR(Dtens))
      SatangAmt = SatangAmt + EVAL(cDvar) + SPACE(1)
   ENDIF
ENDIF
wordAmt = IIF(numAmt<=0, '', wordAmt + ;
                        IIF(RIGHT(chrAmt,2)>'00', ;
                          IIF (numAmt > 1,'BAHT AND'+SPACE(1),'') + ;
                                 SatangAmt+SPACE(1)+'SATANG',  ;
                                 'BAHT ONLY'))
RETURN wordAmt
ENDFUNC

*******************************************************************
* Function Convert day of week (Thai)
* ---�����...... �ʴ��ѹ��ѻ���� 
* --- ������ҧ...... cDAY=TCDOW(DATE())
*******************************************************************
FUNCTION TCDOW
PARAMETER dDATE
   nDay=DOW(dDATE)
   DO CASE
   CASE nDAY=1
     RETURN '�ҷԵ��'
   CASE nDAY=2
     RETURN '�ѹ���'
   CASE nDAY=3
     RETURN '�ѧ���'
   CASE nDAY=4
     RETURN '�ظ'
   CASE nDAY=5
     RETURN '����ʺ��'
   CASE nDAY=6
     RETURN '�ء��'
   CASE nDAY=7
     RETURN '�����'
   OTHERWISE
     RETURN ''
   ENDCASE
ENDFUNC

*******************************************************************
* Function Convert day of week (Thai) short
* ---�����...... �ʴ��ѹ��ѻ�������ҧ���
* --- ������ҧ...... cDAY=TSCDOW(DATE())
*******************************************************************
FUNCTION TSCDOW
PARAMETER mdtm
   mdtnm=DOW(mdtm)
   mcdm=SUBST('�Ҩ.�.�.���.�.',2*mdtnm-1,2)
   RETURN (mcdm)
ENDFUNC

***************************************************************
* Function Convert date from BC to BE
* ---�����...... �ŧ����ѹ���ҡ �.�. �� �.�.
* ---������ҧ...... cTDATE=BC2BE(DATE())
***************************************************************
FUNC BC2BE 
PARA BCDATE && �.�. 
IF TYPE('BCDATE')#'D'
    RETURN ''
ENDIF
LOCAL cDD,cMM
cDD = ALLT(STR(DAY(BCDATE),2))
cDD = IIF(LEN(cDD)=1,"0"+cDD,cDD)
cMM = ALLT(STR(MONTH(BCDATE),2))
cMM = IIF(LEN(cMM)=1,"0"+cMM,cMM)
RETU cDD+'/'+cMM+'/'+STR(YEAR(BCDATE)+543,4)

***************************************************************
* Function Convert date from BE to BC
* ---�����...... �ŧ����ѹ���ҡ �.�. �� �.�.
*-- �����...... dEDATE=BE2BC('25/03/2543')
***************************************************************
FUNC BE2BC 
PARA     BEDATE && DD/MM/YYYY �.�. 
LOCAL    nDD,nMM,nYYYY
IF TYPE('BEDATE')#'C'
    RETURN ''
ENDIF
nDD = VAL(SUBST(BEDATE,1,2))
nMM = VAL(SUBST(BEDATE,4,2))
nYYYY = VAL(SUBST(BEDATE,7,4))-543
RETURN DATE(nYYYY,nMM,nDD)

*******************************************************************
* Function Encryption 
* ---�����...... ������� 
* --- ������ҧ...... cEncrypt = ENCRYPT_IT("KASEM")
*******************************************************************
 FUNCTION ENCRYPT_IT     && Call this to encrypt password
      PARAMETERS cPassword
      cEncrypted_password = ''
      FOR i = 1 TO LEN(cPassword)
         cLetter = SUBSTR(cPassword, i, 1)
         cEncrypted_password = cEncrypted_password + ;
            CHR(MOD(ASC(cLetter)+100,255))      && Encryption formula
      NEXT i
 RETURN cEncrypted_password
 ENDFUNC

*******************************************************************
* Function Decryption 
* ---�����...... ��Ҷʹ����
* --- ������ҧ...... cDecrypt = DECRYPT_IT(ENCRYPT_IT("KASEM"))
*******************************************************************
FUNCTION  DECRYPT_IT     && Call this to Decrypt password
      PARAMETERS cPassword
      cUnencrypted_password = ''
      FOR i = 1 TO LEN(cPassword)
         cLetter = SUBSTR(cPassword, i, 1)
         cUnencrypted_password = cUnencrypted_password + ;
            CHR(MOD(ASC(cLetter)-100,255))    && Reverse of encryption formula
      NEXT i
RETURN cUnencrypted_password
ENDFUNC

*******************************************************************
* Procedure ShutDown 
* ---�����...... �׹�ѹ����͡�ҡ����� 
* --- ������ҧ......  ON SHUTDOWN DO SHUT_DOWN
*******************************************************************
PROCEDURE SHUT_DOWN
LOCAL nAnswer
  nAnswer = messagebox("��ͧ����͡�ҡ�����",292,"")
  IF nAnswer = 6
	  QUIT
   ENDIF	  
ENDPROC

*******************************************************************
* Procedure OnError 
* ---�����...... �ʴ���ͼԴ��Ҵ����Դ���
* --- ������ҧ......  ON ERROR DO ERRHAND WITH ERROR( ),MESSAGE( ),MESSAGE(1),PROGRAM( ),LINENO( )
*******************************************************************
PROCEDURE ERRHAND
PARAMETER merror, mess, mess1, mprog, mlineno
     messagebox('�����Ţ��ͼԴ��Ҵ: ' + LTRIM(STR(merror)) + CHR(13) +  ;
                             '��ͼԴ��Ҵ: ' + mess + CHR(13) +  ;
                             '��÷Ѵ��ͼԴ��Ҵ: ' + mess1 + CHR(13) +  ;
                             '��÷Ѵ���Դ��Ҵ: ' + LTRIM(STR(mlineno)) + CHR(13) + ;
                             '�����: ' + mprog + CHR(13) + ;
                             'Please contact your Vendor '+ CHR(13) + ;
                             '��Ҥس�Դ Visual FoxPro �����͹�������Դ�������¡������ա����' , 288,"")
     ON SHUTDOWN
*     QUIT
ENDPROC

*** End of  Program ***