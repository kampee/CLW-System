*TCMONTH.PRG
***************************************************************
* ---FUNCTION TCMONTH
* ---โปรแกรม...... แปลงค่าเดือนเป็นภาษาไทย
*-- นำไปใช้...... mMONTH=TCMONTH(DATE())
***************************************************************
FUNC TCMONTH 
PARA  dDATE
IF TYPE('dDATE')#'D'
    RETURN ''
ENDIF
DO CASE 
CASE MONTH(dDATE)=1
	RETURN 'มกราคม'
CASE MONTH(dDATE)=2
	RETURN 'กุมภาพันธ์'
CASE MONTH(dDATE)=3
	RETURN 'มีนาคม'
CASE MONTH(dDATE)=4
	RETURN 'เมษายน'
CASE MONTH(dDATE)=5
	RETURN 'พฤษภาคม'
CASE MONTH(dDATE)=6
	RETURN 'มิถุนายน'
CASE MONTH(dDATE)=7
	RETURN 'กรกฎาคม'
CASE MONTH(dDATE)=8
	RETURN 'สิงหาคม'
CASE MONTH(dDATE)=9
	RETURN 'กันยายน'
CASE MONTH(dDATE)=10
	RETURN 'ตุลาคม'
CASE MONTH(dDATE)=11
	RETURN 'พฤศจิกายน'
CASE MONTH(dDATE)=12
	RETURN 'ธันวาคม'
ENDCASE
RETURN ''

