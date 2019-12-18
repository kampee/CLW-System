*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\TESTPRN.PRG
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
*:   TESTPRN
Public _Pagetotal
_Pagetotal = 0
Report Form invoice For inv_head.inv_no = 2 Noconsole
_Pagetotal = _Pageno
Report Form invoice For inv_head.inv_no = 2 Preview
