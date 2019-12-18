FUNCTION EANCheckDigit
* Generate Check Digit for -> EAN.UCC-8, UCC-12, EAN.UCC-13, EAN.UCC-14, SSCC
* Example -> ?EanCheckDigit('940101115849') && 9
PARAMETERS cDigit 
LOCAL nSum
nSum = 0
cDigitReverse = ""
FOR ni = LEN(ALLTRIM(cDigit)) TO 1 STEP -1 
cDigitReverse = cDigitReverse + SUBSTR(cDigit, ni, 1)
NEXT ni
FOR ni = 1 TO LEN(ALLTRIM(cDigitReverse)) 
nSum = nSum + (VAL(SUBSTR(ALLTRIM(cDigitReverse),ni,1)) * IIF(MOD(ni,2)=1,3,1))
ENDFOR
nDIV = MOD(nSum,10)
RETURN IIF(nDiv > 0,PADL(10 - nDiv,1,'0'),'0')
ENDFUNC

FUNCTION ChkDig
* For EAN.UCC-8, UCC-12, EAN.UCC-13, EAN.UCC-14, SSCC
PARAMETERS bc
IF ! (TYPE('bc')= 'C' ;	&& ?????
	AND CHRTRAN(bc, '0123456789','') == '' ; && ???????
	AND INLIST (LEN(bc), 7, 11, 12, 13, 17))	 && ???????
	RETURN '*'
ENDIF
cS = 0
FOR I = LEN(bc) TO 1 STEP -2 
	cS = cS + VAL(SUBSTR(bc, I, 1))*3 + VAL(SUBSTR(bc, I-1, 1))
ENDFOR
RETURN RIGHT(STR(10 - MOD(cS, 10)),1)




PROCEDURE getCCD 
WAIT WINDOW 'SELECT CLIENT NAME: '+TRIM(THISFORM.sGrid.COLumn1.Text1.Value) NOWAIT
xCCode = thisform.sgrid.column1.text1.Value
RELEASE thisform 


proc getCustID

xClientCode = thisform.pageframe1.page1.grid1.column1.text1.Value

WAIT WINDOW 'EDIT/VIEW CUSTOMER ID : '+ALLTRIM(STR(xClientCode)) NOWAIT 
thisform.pageframe1.page1.Refresh


IF xClientCode>1 

thisform.pageframe1.page2.Enabled = .t.
thisform.pageframe1.ActivePage = 2

IF !EMPTY(ALLTRIM(thisform.pageframe1.page2.txtcuscd.Value))
	thisform.pageframe1.page2.txtcuscd.Enabled = .f. 
ELSE
	thisform.pageframe1.page2.txtcuscd.Enabled = .t. 	
ENDIF

thisform.pageframe1.page2.Refresh

ENDIF 


************************************************************
*                         TCDOW                            *
************************************************************
FUNCTION TCDOW
PARAMETER dDATE
   nDay=DOW(dDATE)
   DO CASE
   CASE nDAY=1
     RETURN 'อาทิตย์'
   CASE nDAY=2
     RETURN 'จันทร์'
   CASE nDAY=3
     RETURN 'อังคาร'
   CASE nDAY=4
     RETURN 'พุธ'
   CASE nDAY=5
     RETURN 'พฤหัสบดี'
   CASE nDAY=6
     RETURN 'ศุกร์'
   CASE nDAY=7
     RETURN 'เสาร์'
   OTHERWISE
     RETURN ''
   ENDCASE
ENDFUNC

************************************************************
*                         TSCDOW                           *
************************************************************
FUNCTION TSCDOW
PARAMETER mdtm
   mdtnm=DOW(mdtm)
   mcdm=SUBST('อาจ.อ.พ.พฤศ.ส.',2*mdtnm-1,2)
   RETURN (mcdm)
ENDFUNC

************************************************************
*                         BC2BE                            *
************************************************************
FUNC BC2BE 
PARA BCDATE && ค.ศ. 
IF TYPE('BCDATE')#'D'
    RETURN ''
ENDIF
LOCAL cDD,cMM
cDD = ALLT(STR(DAY(BCDATE),2))
cDD = IIF(LEN(cDD)=1,"0"+cDD,cDD)
cMM = ALLT(STR(MONTH(BCDATE),2))
cMM = IIF(LEN(cMM)=1,"0"+cMM,cMM)
RETU cDD+'/'+cMM+'/'+STR(YEAR(BCDATE)+543,4)

************************************************************
*                         BE2BC                            *
************************************************************
FUNC BE2BC 
PARA     BEDATE && DD/MM/YYYY พ.ศ. 
LOCAL    nDD,nMM,nYYYY
IF TYPE('BEDATE')#'C'
    RETURN ''
ENDIF
nDD = VAL(SUBST(BEDATE,1,2))
nMM = VAL(SUBST(BEDATE,4,2))
nYYYY = VAL(SUBST(BEDATE,7,4))-543
RETURN DATE(nYYYY,nMM,nDD)

************************************************************
*                         ENCRYPT_IT                       *
************************************************************
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

************************************************************
*                         DECRYPT_IT                       *
************************************************************
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

************************************************************
*                         NUM2THI                          *
************************************************************
FUNCTION NUM2THI
PARAMETER mNUM 
DIMENSION mTCH(9),mTDEC(10)
   IF mNUM > 9999999999.99 .OR. Mnum <= 0
      RETURN ''
   ENDIF
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
   mSTNUM=STR(mNUM*100,12)
   mSTTHAI=''
   mCNT=1
   DO WHIL mCNT<=10
      mCHNUM=SUBSTR(mSTNUM,mCNT,1)
      IF mCHNUM=' '
         mSTTHAI=mSTTHAI+''
      ELSE
         IF mCHNUM='0'
            mSTTHAI=IIF(mCNT=4,mSTTHAI+'ล้าน',mSTTHAI+'')
         ELSE
            IF mCHNUM='1'
              IF (mCNT=4.AND.LEN(LTRIM(mSTNUM))#9).OR.  ;
                  (mCNT=10.AND.LEN(LTRIM(mSTNUM))#3)
                  mSTTHAI=mSTTHAI+'เอ็ด'
              ELSE
                  IF .NOT.(mCNT=3.OR.mCNT=9)
                     mSTTHAI=mSTTHAI+mTCH(VAL(mCHNUM))
                 ENDIF
               ENDIF
            ELSE
               IF mCHNUM='2'.AND.(mCNT=3.OR.mCNT=9)
                  mSTTHAI=mSTTHAI+'ยี่'
               ELSE
                  mSTTHAI=mSTTHAI+mTCH(VAL(mCHNUM))
               ENDIF
            ENDIF
            mSTTHAI=mSTTHAI+mTDEC(mCNT)
         ENDIF
      ENDIF
      mCNT=mCNT+1
   ENDDO
   mSTTHAI=mSTTHAI+'บาท'
   IF SUBSTR(mSTNUM,11,2)='00'
      mSTTHAI=mSTTHAI+'ถ้วน'
   ELSE
      mCHNUM=SUBSTR(mSTNUM,11,1)
      IF mCHNUM#'0'
         IF mCHNUM#'1'
            IF mCHNUM='2'
               mSTTHAI=mSTTHAI+'ยี่'
            ELSE
               mSTTHAI=mSTTHAI+mTCH(VAL(mCHNUM))
            ENDIF
         ENDIF
         mSTTHAI=mSTTHAI+mTDEC(9)
      ENDIF
      mCHNUM=SUBSTR(mSTNUM,12,1)
      IF mCHNUM#'0'
         IF mCHNUM='1'.AND.SUBSTR(mSTNUM,11,1)#'0'
            mSTTHAI=mSTTHAI+'เอ็ด'
         ELSE
            mSTTHAI=mSTTHAI+mTCH(VAL(mCHNUM))
         ENDIF
      ENDIF
      mSTTHAI=mSTTHAI+'สตางค์'
   ENDIF
   RETU mSTTHAI
ENDFUNC



************************************************************
*                         NUM2ENG                          *
************************************************************
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

************************************************************
*                         UNZAP                           *
************************************************************
FUNCTION UNZAP
* use test.db 
* zap 
* =unzap(50)
PARAMETER Y
   IF Y>0 .AND. USED()
      IF RECCOUNT()=0
         FILENAME=DBF()
         USE
         HANDLE=FOPEN(FILENAME,2)
         IF HANDLE>0
            BYTE=FREAD(HANDLE,32)
            BKUP_BYTE=BYTE
            FIELD_SIZE=ASC(SUBSTR(BYTE,11,1))+(ASC(SUBSTR(BYTE,12,1))*256)
            FILE_SIZE=FSEEK(HANDLE,0,2)
            BYTE8=CHR(INT(Y/(256*256*256)))
            BYTE7=CHR(INT(Y/(256*256)))                        
            BYTE6=CHR(INT(Y/256)-IIF(Y/256>256,(INT(INT(Y/256)/256)*256),0))
            BYTE5=CHR(MOD(Y,256))
            BYTE=SUBSTR(BYTE,1,4)+BYTE5+BYTE6+BYTE7+BYTE8+SUBSTR(BYTE,9)
            =FSEEK(HANDLE,0)
            =FWRITE(HANDLE,BYTE)
            =FCHSIZE(HANDLE,FILE_SIZE+(FIELD_SIZE*Y))
            =FCLOSE(HANDLE)
         ENDIF
         USE &FILENAME
      ENDIF
   ENDIF


************************************************************
*                         THERMO                           *
************************************************************
proc thermo
parameter mphase,totrecords,mmessage
set curs off
do case 
	case mphase='S'
		public mthermcnt,mint,nrecs
		nrecs=totrecords
		mtopbox=(srow()-6)/2
			defin wind thermo from 10,8 to 21,77 ;																
								double shadow noclose ;
								font 'arial',10 style 'b' ;
								colo RGB(255,255,255,0,0,255)
			move wind thermo cent
			acti wind thermo
			@ 1,2 say mmessage FONT 'arial',10 style 'b'
			@ 3,2 to 6.5,90
			@ 4,3 say repl(' ',83)
			@ 4,3 say ' '
		mthermcnt=0
		mint=int(totrecords/83)
		if mint=0
			mint=1
		endif
	case mphase='U'
		if mthermcnt%mint=0 and col()<= 88 
				@ 4,col() say chr(152) FONT 'FoxPro Window Font',20 COLOR RGB(255,255,255,255,255,255)
		endif
		mthermcnt=mthermcnt+1
		if mthermcnt=nrecs
				@ 5,3 say repl(chr(219),83)
		endif
	case mphase='C'
		rele wind thermo
		?? chr(7)
		wait wind ltrim(str(mthermcnt))+' '+mmessage time 1
		rele mthermcnt,mint,nrecs
		set curs on
endcase
retu


*****************************************************************
*                          CALTIME                              *
*****************************************************************
proc caltime
para timein,timeout

priv hours,mins,sec
p1time = timein
t2 = timeout

timein  =3600*val(substr(timein ,1,2))+60*val(substr(timein ,4,2))+val(substr(timein ,7,2))
timeout =3600*val(substr(timeout,1,2))+60*val(substr(timeout,4,2))+val(substr(timeout,7,2))

if timeout>timein
	start = timeout - timein
else
	start= timeout+86400-timein
endif

stor 0 to hours,mins,sec

sec = mod(start,60)
mins = int(start/60)
if mins >= 60
	hours = int(mins/60)
	mins = mod(mins,60)
endif

retu padl(alltrim(str(hours)),2,'0')+':'+padl(alltrim(str(mins)),2,'0')+;
				':'+padl(alltrim(str(sec)),2,'0')

********************************************************************
*                             LOGST                                *
********************************************************************
PROC LOGST
if !used('ulog')
	sele 0
	use ulog
else
	sele ulog
endif
set order to logid
GO BOTTOM 
mlids=logid+1
append blank 
repl logid with mlids
repl uid with nUserid
repl mid with sys(0)
repl login_date with date()
repl login_time with time()
RETU

********************************************************************
*                             LOGEN                                *
********************************************************************
PROC LOGEN
if !used('ulog')
	sele 0
	use ulog
else
	sele ulog
endif
set order to logid
seek str(mlids,10)
if found()
	repl logof_date with date()
	repl logof_time with time()
	repl durat_date with date()
	repl durat_time with caltime(login_time,logof_time)
	repl complete with .t.
else
	wait wind 'Session record not found...' timeout 1
endif
RETURN

****************************************************************
*                          errmess.prg                         *
****************************************************************
* errmess.prg module to print error message on screen.
proc errmess
para message
	do case
		case right(alltrim(message),1)='!'
			=messagebox(message,'CLW',48)
		case right(alltrim(message),1)='?'
			=messagebox(message,'CLW',32)
		case right(alltrim(message),1)='i'
			=messagebox(left(message,len(message)-1),'CLW',64)
		othe
			=messagebox(left(message,len(message)),'CLW',16)
	endcase
retu .t.

********************************************************************
*                                YESNO                             *
********************************************************************
PROC YESNO
PARAMETERS manswer,mquestion
	retval=.f.
	reply=messagebox(mquestion+' ?','CLW',iif(manswer,512+32+4,256+32+4))
	if reply=6
		retval=.t.
	else
		retval=.f.
	endif
	retu retval
retu


