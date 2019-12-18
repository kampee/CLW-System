*TD2BE.PRG
***************************************************************
* ---FUNCTION TD2BE
* ---โปรแกรม...... แปลงค่าวันที่ไทยเต็มเป็นวันที่ไทย
*-- นำไปใช้...... cTdate=TD2BE('12 มกราคม 2543')
***************************************************************
FUNC TD2BE
PARA cTDATE 
LOCAL cMM,nMM
STOR SPACE(2) TO nMM
IF TYPE('cTDATE')#'C'
RETURN ''
ENDIF
DO CASE
CASE AT('มกราคม', cTDATE) > 0
cMM = 'มกราคม'
nMM = '01'
CASE AT('กุมภาพันธ์', cTDATE) > 0
cMM = 'กุมภาพันธ์'
nMM = '02'
CASE AT('มีนาคม', cTDATE) > 0
cMM = 'มีนาคม'
nMM = '03'
CASE AT('เมษายน', cTDATE) > 0
cMM ='เมษายน'
nMM = '04'
CASE AT('พฤษภาคม', cTDATE) > 0
cMM = 'พฤษภาคม'
nMM = '05'
CASE AT('มิถุนายน', cTDATE) > 0
cMM = 'มิถุนายน'
nMM = '06'
CASE AT('กรกฎาคม', cTDATE) > 0
cMM = 'กรกฎาคม'
nMM = '07'
CASE AT('สิงหาคม', cTDATE) > 0
cMM = 'สิงหาคม'
nMM = '08'
CASE AT('กันยายน', cTDATE) > 0
cMM = 'กันยายน'
nMM = '09'
CASE AT('ตุลาคม', cTDATE) > 0
cMM = 'ตุลาคม'
nMM = '10'
CASE AT('พฤศจิกายน', cTDATE) > 0
cMM = 'พฤศจิกายน'
nMM = '11'
CASE AT('ธันวาคม', cTDATE) > 0
cMM = 'ธันวาคม'
nMM = '12'
ENDCASE
IF !EMPTY(nMM)
RETURN ALLT(LEFT(cTDATE,ATC(cMM,cTDATE)-1))+ ;
'/'+nMM+'/' + RIGHT(cTDATE,LEN(cTDATE)- ;
(ATC(cMM,cTDATE)+LEN(cMM)))
ENDIF
RETURN ''

