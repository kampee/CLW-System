*******************************************************************
* Function Convert day of week (Thai)
* ---โปรแกรม...... แสดงวันในสัปดาห์ 
* --- ตัวอย่าง...... cDAY=TCDOW(DATE())
*******************************************************************
FUNCTION TCDOW
PARAMETER dDATE
   nDay=DOW(dDATE)
   DO CASE
   CASE nDAY=1
     RETURN 'อาทิตย์'
   CASE nDAY=2
     RETURN 'จันทร์'
   CASE nDAY=3
     RETURN 'อังคาร'
   CASE nDAY=4
     RETURN 'พุธ'
   CASE nDAY=5
     RETURN 'พฤหัสบดี'
   CASE nDAY=6
     RETURN 'ศุกร์'
   CASE nDAY=7
     RETURN 'เสาร์'
   OTHERWISE
     RETURN ''
   ENDCASE
ENDFUNC
