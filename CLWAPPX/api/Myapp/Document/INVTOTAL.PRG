*:******************************************************************************
*:
*: Procedure File F:\MYAPP\DOCUMENT\INVTOTAL.PRG
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
*:   INVTOTAL
Para INVNO
Set Talk Off
Calculate Sum(inv_dtl.unitprice * inv_dtl.quantity) To Amount ;
	FOR inv_dtl.inv_no = INVNO
Return NUM2THI(Amount)
