**********************************************************************************************
* CLW SYSTEM X 2016-2017 
* DEVELOPER KAMPEE
* EMAIL KAMPEE@GMAIL.COM 
* MOBILE 0811029286 
*
* DBF FOXPRO 2.6 FOR WINDOWS F:\CLWDATA 
*
* 29/01/2019 - FOLLOW THIS VERSION FOR DEV CLW SYSTEM APP START BY FIRST MODULE SOF (STOCK ORDER FORM) 
*
**********************************************************************************************

CLOSE ALL

* Global Variables 
RELEASE mlids,nUserid,cUser,cPass,cCpfx,cDept
PUBLIC mlids,nUserid,cUser,cPass,cCpfx,cDept

*SET PROCEDURE TO UTILITY
ON SHUTDOWN DO SHUT_DOWN
ON ERROR DO errhand WITH ;
ERROR( ), MESSAGE( ), MESSAGE(1),;
PROGRAM( ), LINENO( )

SET PROCEDURE TO Util
SET SYSMENU OFF
=SetEnvir() && SET ENVIRONMENT
on key label shift+f12 cancel

SET CURSOR OFF
mappfile="f:\clwx.app"
mbuildapp = ":: Build on#"+dtoc(fdate(mappfile))+" "+ftime(mappfile)
SET CURSOR ON

WITH _SCREEN
	.Caption = 'CLW System X '+mbuildapp
	.Backcolor = rgb(255,255,255)
	.Controlbox = .T. 
	.Closable = .T. 
	.MaxButton = .t.
	.MinButton = .t. 
	.WINDOWSTATE = 2
	.FONTSIZE = 10
	.FONTNAME = 'MS SANS SERIF'
	.FORECOLOR = RGB(255,255,255)
	*_SCREEN.Height =  SYSMETRIC(2) 
	.ICON = 'clw_glo4.ico'
	CLEAR 

	@ 0,0 say 'clwglo_x.jpg' bitmap center
	*.PICTURE = 'clwglo_x.jpg'
	.SHOW() 
	nSystemName = LEN('SWAP SYSTEM')
	nVersion = LEN('Version 2.0a')
	*@SROWS()-2,1 Say 'Build Update 10/09/2008' FONT 'MS Sans Serif',8 COLOR B+/b
	do menustart.mpr
	do form userlogin
ENDWITH 
_screen.Caption = _screen.Caption+" :: "+PROPER(ALLTRIM(cUser))+" Online"

*DO FORM ulog

Do clw.mpr
Keyboard '{ALT+M}'
READ EVENT

CLOSE DATABASES ALL

*******************************************************************
* Procedure OnError 
*******************************************************************
PROCEDURE errhand
PARAMETER merror, mess, mess1, mprog, mlineno
ON SHUTDOWN
messagebox('Error Code Number: ' + LTRIM(STR(merror)) + CHR(13) + ;
'Error Name: ' + mess + CHR(13) + ;
'Error Message: ' + mess1 + CHR(13) + ;
'Error Line No: ' + LTRIM(STR(mlineno)) + CHR(13) + ;
'Program Name: ' + mprog + CHR(13) + ;
'Please contact to K.Kampee - kampee@clwglobal.com or call.081-102-9186'+ CHR(13) + ;
'Please exit program' , 288,"")
IF ALLTRIM(cUser)=="admin"
	on shutdown quit
	Set SysMenu To Default
	Cancel
	Clear All
	Close All
ELSE
	QUIT
ENDIF
ENDPROC

*******************************************************************
* Procedure ShutDown 
*******************************************************************
PROCEDURE Shut_Down
LOCAL nAnswer
*nAnswer = messagebox("Do you want to exit",292,"")
*IF nAnswer = 6
    QUIT
*ENDIF    
ENDPROC

*******************************************************************
* FUNCTION SetEnvir
*******************************************************************
FUNCTION SetEnvir
Set Clock Status On
Set Status Bar On
SET DATE DMY
SET DELETED ON
set cpdialog off
SET EXCLUSIVE OFF
SET HOURS TO 24
SET MULTILOCKS ON
SET SAFETY OFF
SET SECONDS OFF
SET TALK OFF
SET COLLATE TO "MACHINE"
SET NULLDISPLAY TO ""
SET CENTURY ON
SET CONFIRM ON
SET REPROCESS TO 2
SET ESCAPE ON
on key labe shift+f12 susp
on key labe shift+f11 do form ulog
on key labe shift+f10 quit
RETURN
