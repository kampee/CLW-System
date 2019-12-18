*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\TCDOW.PRG
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
*:   TCDOW
*:   TCDOW
*******************************************************************
* Function Convert day of week (Thai)
* ---โปรแกรม...... แสดงวันในสัปดาห์
* --- ตัวอย่าง...... cDAY=TCDOW(DATE())
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
		Return 'อาทิตย์'
	Case nDay=2
		Return 'จันทร์'
	Case nDay=3
		Return 'อังคาร'
	Case nDay=4
		Return 'พุธ'
	Case nDay=5
		Return 'พฤหัสบดี'
	Case nDay=6
		Return 'ศุกร์'
	Case nDay=7
		Return 'เสาร์'
	Otherwise
		Return ''
	Endcase
Endfunc
