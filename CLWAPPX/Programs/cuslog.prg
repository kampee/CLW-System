*************************************************************************
* Program  : Contact Log                                                *
* Start on : 06/09/2006        
* Convert  : Convert from Fox 2.6 to VFox 9                             *
* by       : Kampee Sridavong                                           *
*************************************************************************
*

Defi Wind ShowWind From 0,0 To Srow(),Scol() Close Panel ;
	Font 'MS Sans Serif',10 Style 'n' ;
	Title '�������մ��õԴ����١��� -  <F2=add> <F4=Get Cust> <F5=delete> <Esc=quit>'

Set Excl Off

On Key Labe f2 Do addnew
On Key Labe f4 Do getcus
On Key Labe f5 Do delerec


If !Used('cuslog')
	Sele 0
	Use cuslog
Else
	Sele cuslog
EndIf
Go Bott

Brow Wind ShowWind fields ;
	log_id :h='�ӴѺ��' :r,;
	log_date :h='�ѹ���' :v=repdate(),;
	log_cust:6 :h='�١���' :r,;
	log_desc :h='��������´',;
	log_type :h='��' :w=showcon(),;
	log_sdate :h='�ѹ�Դ���',;
	log_stime :h='���ҵԴ���',;
	log_edate :h='�ѹ�������',;
	log_etime :h='���ҷ������' :v=caltlog(),;
	log_ctime :h='������ҷ����' :r,;
	log_rem :H='����',;
	log_upd :h='#' :P='Y' :v=addnew() WHEN not LOG_UPD
	
Flush
Clos Data 
Rele Wind ShowWind
Set Func 2 To ''
Set Func 4 To ''
Set Func 5 To ''
KEYB '{alt+M}'

*************************************************************************
*                                addnew                                 *
*************************************************************************
Proc addnew
Set Orde To logid
Go bott
m.log_id=log_id+1
m.log_date=date()
Appe Blan
Repl log_id With m.log_id,log_date with m.log_date
repl log_sdate with m.log_date, log_edate with m.log_date
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
*                                repdate                                *
*************************************************************************
proc repdate
m.log_date=log_date
repl log_sdate with m.log_date, log_edate with m.log_date
retu



*************************************************************************
*                                caltlog                                *
*************************************************************************
proc caltlog
repl log_ctime with caltime(log_stime,log_etime)
retu


*************************************************************************
*                                getcus                                 *
*************************************************************************
proc getcus
if !used('cus')
	sele 0
	use cus
else
	sele cus
endif
set order to custid
mtitle='�ʴ���ª����١���'
defi wind showcus from 5,15 to srow()-5,scol()-15 font 'ms sans serif',8 style 'b' ;
	close grow float title mtitle color +W/GB+
brow wind showcus fields ;
		cuscd :h='�����١���',;
		contact:30 :h='���ͼ��Դ���',;
		company:40 :h='���ͺ���ѷ',;
		city:15 :h='�ѧ��Ѵ' ;
		noed noap node nome
rele wind showcus
m.cuscd=cuscd
sele cuslog
m.log_upd=log_upd
if m.log_upd=.t.
	do errmess with 'This record has been disable for update!'
else
	repl log_cust with m.cuscd	
endif
show gets
retu

********************************************
*                  showcon                  *
********************************************
proc showcon
	wait wind '�Դ����١����� '+chr(13)+;
			  'O = On site'+chr(13)+;
			  'P = Phone'+chr(13)+;
			  'E = e-Mail'+chr(13)+;
			  'M = MSN/AIM'+chr(13)+'' nowa
retu
