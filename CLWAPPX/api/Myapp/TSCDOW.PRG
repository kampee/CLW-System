*******************************************************************
* Function Convert day of week (Thai) short
* ---โปรแกรม...... แสดงวันในสัปดาห์อย่างย่อ
* --- ตัวอย่าง...... cDAY=TSCDOW(DATE())
*******************************************************************
FUNCTION TSCDOW
PARAMETER mdtm
   mdtnm=DOW(mdtm)
   mcdm=SUBST('อาจ.อ.พ.พฤศ.ส.',2*mdtnm-1,2)
   RETURN (mcdm)
ENDFUNC
