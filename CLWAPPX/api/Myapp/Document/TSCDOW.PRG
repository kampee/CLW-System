*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\TSCDOW.PRG
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
*:   TSCDOW
*:   TSCDOW
*******************************************************************
* Function Convert day of week (Thai) short
* ---โปรแกรม...... แสดงวันในสัปดาห์อย่างย่อ
* --- ตัวอย่าง...... cDAY=TSCDOW(DATE())
*******************************************************************
*!******************************************************************************
*!
*! Procedure TSCDOW
*!
*!******************************************************************************
Function TSCDOW
	Parameter mdtm
	mdtnm=Dow(mdtm)
	mcdm=Subst('อาจ.อ.พ.พฤศ.ส.',2*mdtnm-1,2)
	Return (mcdm)
Endfunc
