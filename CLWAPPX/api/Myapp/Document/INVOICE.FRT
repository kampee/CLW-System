   �   @                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              �DRIVER=winspool
DEVICE=EPSON LQ-2080 ESC/P 2
OUTPUT=LPT1:
ORIENTATION=0
PAPERSIZE=9
PAPERLENGTH=2794
PAPERWIDTH=2286
DEFAULTSOURCE=4
PRINTQUALITY=180
YRESOLUTION=180
TTOPTION=1
                                                                  @  '  winspool EPSON LQ-2080 ESC/P 2 LPT1:                                                                                  �EPSON LQ-2080 ESC/P 2            � @ f  	 �
�    �   �                                                                                  @ MSUDEPSON LQ-2080 ESC/P 2           �               d                                               	CordiaUPC                                                     INT(nLine / 10)                                               inv_head.inv_no                                                                                                             	CordiaUPC                                                     inv_head.inv_date                                             "@E"                                                                                                                        	CordiaUPC                                                     inv_head.term_day                                             	CordiaUPC                                                     "����Թ���"                                                 	CordiaUPC                                                     customer.company                                              	CordiaUPC                                                     customer.contact                                              	CordiaUPC                                                     customer.address1                                             	CordiaUPC                                                     customer.address2                                             	CordiaUPC                                                     "ABC"                                                         Coronet                                                                                                                     "����ѷ �ͺի� �ӡѴ"                                         	CordiaUPC                                                     "ABC COMPANY LIMITED"                                         	CordiaUPC                                                     "���� / ������� "                                             	CordiaUPC                                                     	"INVOICE"                                                     	CordiaUPC                                                     "˹��"                                                        	CordiaUPC                                                     0trans(_pageno,'999'),'/',trans(_pagetotal,'999')              "@Z 99,999"                                                                                                                 	CordiaUPC                                                     "�Ţ�������Թ���"                                           	CordiaUPC                                                     "�ѹ���"                                                      	CordiaUPC                                                     "�ѹ�Թ����"                                                 	CordiaUPC                                                     "�ѹ�ú��˹�����"                                             	CordiaUPC                                                     &inv_head.inv_date +  inv_head.term_day                        "@E"                                                                                                                        	CordiaUPC                                                     inv_dtl.prod_id                                                                                                             	CordiaUPC                                                     inv_dtl.quantity                                              "@Z 999,999"                                                                                                                	CordiaUPC                                                     inv_dtl.unitprice                                             "@z 999,999.99"                                                                                                             	CordiaUPC                                                     product.prod_name                                                                                                           	CordiaUPC                                                     
product.um                                                                                                                  	CordiaUPC                                                     %inv_dtl.quantity *  inv_dtl.unitprice                         "@Z 999,999,999.99"                                                                                                         	CordiaUPC                                                     "�����Թ���"                                                  	CordiaUPC                                                     "��¡��"                                                      	CordiaUPC                                                     "�ӹǹ"                                                       	CordiaUPC                                                     "�Ҥҵ��˹���"                                                	CordiaUPC                                                     "�ӹǹ�Թ"                                                   	CordiaUPC                                                     "CODE"                                                        	CordiaUPC                                                     "DESCRIPTION"                                                 	CordiaUPC                                                     "QTY"                                                         	CordiaUPC                                                     "UNIT PRICE"                                                  	CordiaUPC                                                     "AMOUNT"                                                      	CordiaUPC                                                     "����繼���Ѻ�ͧ"                                            	CordiaUPC                                                     "�ѹ���"                                                      	CordiaUPC                                                     "����繼���觢ͧ"                                            	CordiaUPC                                                     "�ѹ���"                                                      	CordiaUPC                                                     "����ӹǹ�Թ������"                                                                                                      	CordiaUPC                                                     _pageno = _pagetotal                                          %inv_dtl.quantity *  inv_dtl.unitprice                         "@Z 999,999,999.99"                                                                                                         	CordiaUPC                                                     _pageno = _pagetotal                                                                                                        _pageno = _pagetotal                                                                                                        _pageno = _pagetotal                                          &'('+ALLT(INVTOTAL(INV_DTL.INV_NO))+')'                                                                                      	CordiaUPC                                                     _pageno = _pagetotal                                          nLine                                                         0                                                             0                                                             	CordiaUPC                                                     	CordiaUPC                                                     Coronet                                                       	CordiaUPC                                                     dataenvironment                                               mLeft = 226
Top = 0
Width = 495
Height = 265
InitialSelectedAlias = "inv_head"
Name = "Dataenvironment"
                 cursor                                                        �Left = 129
Top = 17
Width = 90
Height = 134
Alias = "inv_head"
Order = "inv_no"
Database = mydatabase.dbc
CursorSource = "inv_head"
Name = "Cursor1"
                                cursor                                                        �Left = 243
Top = 18
Width = 90
Height = 132
Alias = "inv_dtl"
Order = "inv_no"
Database = mydatabase.dbc
CursorSource = "inv_dtl"
Name = "Cursor2"
                                  cursor                                                        �Left = 15
Top = 18
Width = 90
Height = 212
Alias = "customer"
Order = "cust_id"
Database = mydatabase.dbc
CursorSource = "customer"
Name = "Cursor3"
                                cursor                                                        �Left = 357
Top = 18
Width = 90
Height = 116
Alias = "product"
Order = "prod_id"
Database = mydatabase.dbc
CursorSource = "product"
Name = "Cursor4"
                                 relation                                                      �ParentAlias = "inv_head"
RelationalExpr = "inv_no"
ChildAlias = "inv_dtl"
ChildOrder = "inv_no"
OneToMany = .T.
Name = "Relation1"
                                                     relation                                                      yParentAlias = "inv_dtl"
RelationalExpr = "prod_id"
ChildAlias = "product"
ChildOrder = "prod_id"
Name = "Relation2"
                                                                     relation                                                      {ParentAlias = "inv_head"
RelationalExpr = "cust_id"
ChildAlias = "customer"
ChildOrder = "cust_id"
Name = "Relation3"
                                                             