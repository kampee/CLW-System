*BE2TD.PRG
***************************************************************
* ---FUNCTION BE2TD
* ---โปรแกรม...... แปลงค่าวันที่ไทยเป็นแบบภาษาไทยเต็มยศ
*-- นำไปใช้...... cTdate=BE2TD('12/01/2543')
***************************************************************
FUNC BE2TD
PARA cTDATE 
IF TYPE('cTDATE')#'C'
RETURN ''
ENDIF
RETURN SUBST(cTDATE,1,2) + ' ' + ;
TCMONTH(BE2BC(cTDATE)) + ' ' + ;
SUBST(cTDATE,7,4)

