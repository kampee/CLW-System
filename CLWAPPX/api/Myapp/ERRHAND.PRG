*******************************************************************
* Procedure OnError 
* ---โปรแกรม...... แสดงข้อผิดพลาดที่เกิดขึ้น
* --- ตัวอย่าง......  ON ERROR DO ERRHAND WITH ERROR( ),MESSAGE( ),MESSAGE(1),PROGRAM( ),LINENO( )
*******************************************************************
PROCEDURE ERRHAND
PARAMETER merror, mess, mess1, mprog, mlineno
     messagebox('หมายเลขข้อผิดพลาด: ' + LTRIM(STR(merror)) + CHR(13) +  ;
                             'ข้อผิดพลาด: ' + mess + CHR(13) +  ;
                             'บรรทัดข้อผิดพลาด: ' + mess1 + CHR(13) +  ;
                             'บรรทัดที่ผิดพลาด: ' + LTRIM(STR(mlineno)) + CHR(13) + ;
                             'โปรแกรม: ' + mprog + CHR(13) + ;
                             'Please contact your Vendor '+ CHR(13) + ;
                             'ถ้าคุณเปิด Visual FoxPro อยู่ก่อนแล้วให้ปิดแล้วเรียกโปรแกรมอีกครั้ง' , 288,"")
     ON SHUTDOWN
     QUIT
ENDPROC
