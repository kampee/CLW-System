*TM2M.PRG
***************************************************************
* ---FUNCTION TM2M
* ---โปรแกรม...... แปลงค่าเดือนไทยเต็มเป็นเดือน
* ---ผู้เขียน........ Kasem K.
* ---วันแก้ไข....... 12.08.99
*-- นำไปใช้......  nMonth=TM2M('มกราคม')
***************************************************************
FUNCTION TM2M
PARAMETER cTMONTH
nMM = 0
DO CASE
CASE AT('มกราคม', cTMONTH) > 0
        nMM = 01
CASE AT('กุมภาพันธ์', cTMONTH) > 0
        nMM = 02
CASE AT('มีนาคม', cTMONTH) > 0
        nMM = 03
CASE AT('เมษายน', cTMONTH) > 0
        nMM = 04
CASE AT('พฤษภาคม', cTMONTH) > 0
        nMM = 05
CASE AT('มิถุนายน', cTMONTH) > 0
        nMM = 06
CASE AT('กรกฎาคม', cTMONTH) > 0
        nMM = 07
CASE AT('สิงหาคม', cTMONTH) > 0
        nMM = 08
CASE AT('กันยายน', cTMONTH) > 0
        nMM = 09
CASE AT('ตุลาคม', cTMONTH) > 0
        nMM = 10
CASE AT('พฤศจิกายน', cTMONTH) > 0
        nMM = 11
CASE AT('ธันวาคม', cTMONTH) > 0
        nMM = 12
ENDCASE
RETURN nMM
