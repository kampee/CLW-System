PUBLIC _Pagetotal
_pagetotal = 0
REPORT FORM invoice FOR inv_head.inv_no = 2 NOCONSOLE 
_pagetotal = _pageno
REPORT FORM invoice FOR inv_head.inv_no = 2 PREVIEW 
