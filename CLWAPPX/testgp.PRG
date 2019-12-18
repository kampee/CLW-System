SELECT a.cpfx,a.pid,b.amt,c.cname,d.saleman ;
	FROM pinv_pr a,pinv_se b,ctype c,saleman d ;
	WHERE YEAR(a.invdate)=YEAR(DATE()) AND a.cpfx+STR(a.pid,6)=b.cpfx+STR(b.pid,6) ;
		  AND A.cancelled=.f. ;
	      AND STR(a.ctype,3)=STR(c.cid,3) AND STR(a.sale,2)=STR(d.sid,2) ;
	INTO DBF cptmp.dbf 

SELECT saleman,SUM(amt),cname FROM cptmp GROUP BY cname,saleman ORDER BY saleman,cname INTO dbf cptmp2.dbf 
SELECT SUM(amt),cname FROM cptmp GROUP BY cname ORDER BY cname INTO dbf cptmp3.dbf 

 

BROWSE


