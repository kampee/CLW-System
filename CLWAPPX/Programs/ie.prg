*************************************************************************
* Program  : INCOME & EXPENSE                                           *
* Start on : 25/09/2006                                                 *
* by       : Kampee Sridavong                                           *
*************************************************************************
*

Defi Wind ShowWind From 0,0 To Srow(),Scol() Close Panel ;
	Font 'MS Sans Serif',12 Style 'n' ;
	Title 'บันทึกรายรับรายจ่ายส่วนตัว - <F2=เพิ่ม> <F4=เลือกรหัส> <F5=ลบ> <F9=ยอดคงเหลือ> <Esc=ออก>' 

*COLOR RGB(0,255,0,0,0,0)
	
Set Excl Off

On Key Labe f2 Do addnew
On Key Labe f4 Do getet
On Key Labe f5 Do delerec
* On Key Labe f9 Do sumbal


If Not Used('ie')
	Sele 0
	Use ie
Else
	Sele ie
EndIf
set order to 1
Go Bott

Brow Wind ShowWind fields ;
	ieno :h='ลำดับ' :R,;
	iedate :h='วันที่' ,;
	etcode :h='รหัส' :R,;	
	iedesc:30 :h='รายการ' ,;
	ieinc :h='รายรับ' :P='9,999,999.99' :V=calbal(),;
	ieexp :h='รายจ่าย' :P='9,999,999.99' :V=calbal(),;
	iebal :h='คงเหลือ' :P='9,999,999.99' :R,;
	ierem:10 :h='หมายเหตุ' ,;
	ieupd :h='Y/N' :P='Y' :v=addnew() WHEN NOT ieupd
	
Flush
Clos Data 
Rele Wind ShowWind
pop menu _msysmenu
Set Func 2 To ''
Set Func 4 To ''
Set Func 5 To ''
*Set Func 9 To ''
KEYB '{alt+M}'
retu .t.
*************************************************************************
*                                addnew                                 *
*************************************************************************
Proc addnew
Set Orde To ieno
Go bott
m.ieno=ieno+1
m.iedate=date()
Appe Blan
Repl ieno With m.ieno,iedate with m.iedate
KeyBoard '{enter}'
Show Gets
Retu .t.

*************************************************************************
*                                delerec                                *
*************************************************************************
Proc delerec
KeyBoard '{ctrl+t}'
Show Gets
Retu .t.

*************************************************************************
*                                calbal                                 *
*************************************************************************
Proc calbal
wait wind 'กำลังปรับปรุงยอดคงเหลือ...' timeout 1
sele ie
m.ieno=ieno
m.ieinc=ieinc
m.ieexp=ieexp
m.etcode=etcode
m.iebal=0
m.sbal=0
sele sbal from snc where code='IEB' into array atmpx
if _tally#0
	m.iebal=atmpx(1,1)
endif
if m.etcode<>'OP'
	m.sbal=(m.iebal+m.ieinc)-m.ieexp
else
	m.sbal=m.ieinc
endif
sele ie
Repl iebal With m.sbal

wait wind 'กำลังปรับปรุงยอดคงเหลือในบานข้อมูลหลัก' timeout 1
if not used('snc')
	sele 0
	use snc
else
	sele snc
endif
set order to code
seek 'IEB'
repl sbal with m.sbal,lupdate with date(),luptime with time()

sele ie
KeyBoard '{enter}'
Show Gets

Retu .t.

********************************************
*                  sumbal                 *
********************************************
proc sumbal
	set talk off
	sele ie
	
	ms_date=iedate
		
	***********************************
	* Summary all income and expenses *
	***********************************
	sum ieinc to m_sinc
	sum ieexp to m_sexp
	m_sbal=0
	sele max(ieno),iebal from ie where ieupd=.t. into array atmp4
	if _tally#0
		m_sbal=atmp4(1,2)
	endif
	m_sincs=(m_sinc)
	m_sexps=(m_sexp)
	m_sbals=(m_sbal)
	
	*******************************
	* Summary for this month only *
	*******************************
	m_mopn=0
	m_minc=0
	m_mexp=0
	m_mbal=0	
	sele sum(ieinc) from ie where month(iedate)=month(date()) and year(iedate)=year(date()) and ieupd=.t. into array atmp5
	if _tally#0
		m_minc=atmp5(1,1)
	endif

	sele sum(ieexp) from ie where month(iedate)=month(date()) and year(iedate)=year(date()) and ieupd=.t. into array atmp6
	if _tally#0
		m_mexp=atmp6(1,1)
	endif

	sele sum(ieinc) from ie where month(iedate)=month(date()) and year(iedate)=year(date()) and etcode='OP' and ieupd=.t. into array atmp7
	if _tally#0
		m_mopn=atmp7(1,1)
	endif
	m_mbal=(m_minc-m_mexp)-m_mopn
	m_mopns=(m_mopn)
	m_mincs=(m_minc)
	m_mexps=(m_mexp)
	m_mbals=(m_mbal)
	
	**************************
	* Summary for today only *
	**************************
	m_dinc=0
	m_dexp=0
	m_dbal=0
	sele sum(ieinc) from ie where iedate=date() and ieupd=.t. into array atmp8
	if _tally#0
		m_dinc=atmp8(1,1)
	endif

	sele sum(ieexp) from ie where iedate=date() and ieupd=.t. into array atmp9
	if _tally#0
		m_dexp=atmp9(1,1)
	endif		
	m_dincs=(m_dinc)
	m_dexps=(m_dexp)
	m_dbals=m_dinc-m_dexp
	
	******************************
	* Summary for this year only *
	******************************
	m_yinc=0
	m_yexp=0
	m_ybal=0	
	m_yopn=0
	sele sum(ieinc) from ie where year(iedate)=year(date()) and ieupd=.t. into array atmp10
	if _tally#0
		m_yinc=atmp10(1,1)
	endif

	sele sum(ieexp) from ie where year(iedate)=year(date()) and ieupd=.t. into array atmp11
	if _tally#0
		m_yexp=atmp11(1,1)
	endif
	sele sum(ieinc) from ie where year(iedate)=year(date()) and etcode='OP' and ieupd=.t. into array atmp12
	if _tally#0
		m_yopn=atmp12(1,1)
	endif
	m_ybal=(m_yinc-m_yexp)-m_yopn
	m_yincs=(m_yinc)
	m_yexps=(m_yexp)
	m_ybals=(m_ybal)

	*********************************
	* Summary for select today only *
	*********************************
	ms_dinc=0
	ms_dexp=0
	ms_dbal=0
	sele sum(ieinc) from ie where day(iedate)=day(ms_date) and month(iedate)=month(ms_date) and ;
		year(iedate)=year(ms_date) and ieupd=.t. ;
		into array atmp13
	if _tally#0
		ms_dinc=atmp13(1,1)
	endif

	sele sum(ieexp) from ie where day(iedate)=day(ms_date) and month(iedate)=month(ms_date) and ;
		year(iedate)=year(ms_date) and ieupd=.t. into array atmp14
	if _tally#0
		ms_dexp=atmp14(1,1)
	endif		
	ms_dincs=(ms_dinc)
	ms_dexps=(ms_dexp)
	ms_dbals=ms_dinc-ms_dexp

	**************************************
	* Summary for this select month only *
	**************************************
	ms_mopn=0
	ms_minc=0
	ms_mexp=0
	ms_mbal=0	
	sele sum(ieinc) from ie where month(iedate)=month(ms_date) and year(iedate)=year(ms_date) ;
		and ieupd=.t. into array atmp15
	if _tally#0
		ms_minc=atmp15(1,1)
	endif

	sele sum(ieexp) from ie where month(iedate)=month(ms_date) and year(iedate)=year(ms_date) ;
		 and ieupd=.t. into array atmp16
	if _tally#0
		ms_mexp=atmp16(1,1)
	endif

	sele sum(ieinc) from ie where month(iedate)=month(ms_date) and year(iedate)=year(ms_date) ;
		and etcode='OP' and ieupd=.t. into array atmp17
	if _tally#0
		ms_mopn=atmp17(1,1)
	endif
	ms_mbal=(ms_minc-ms_mexp)-ms_mopn
	ms_mopns=(ms_mopn)
	ms_mincs=(ms_minc)
	ms_mexps=(ms_mexp)
	ms_mbals=(ms_mbal)
		
	*do iesum.spr
	set talk on	
retu


*************************************************************************
*                                getet                                 *
*************************************************************************
proc getet
if not used('et')
	sele 0
	use et
else
	sele et
endif
set order to et
mtitle='แสดงรหัสรายรับ รายจ่าย'

defi wind showet from 5,15 to srow()-5,scol()-15 font 'ms sans serif',8 style 'b' ;
	close grow float title mtitle color +W/GB+

brow wind showet fields ;
		et=iif(ettype='I','รายรับ','รายจ่าย') :h='ประเภท รจ.',;
		etcode :h='รหัส',;
		etname :h='ชื่อ' ;
		noed noap node nome
rele wind showet
m.etcode=etcode
m.etname=etname
sele ie
m.ieupd=ieupd
if m.ieupd=.t.
	do errmess with 'ไม่สามารถปรับปรุงรายการนี้ได้!'
else
	repl etcode with m.etcode,iedesc with m.etname
endif
show gets
retu
