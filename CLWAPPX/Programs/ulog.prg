*************************************************************************
* Program  : User Logs                                                  * 
* Start on : 24/09/2002                                                 *
* by       : Kampee Sridavong                                           *
* Update   : 24/09/2002 - make program                                  *
*************************************************************************
*

Defi Wind ShowUlog From 0,10 To Srow(),Scol()-10 close panel ;
	Font 'Courier New',8 Style 'n' ;
	Title '>> USER SESSION LOGS <<'

sele *,space(10) as uname from ulog where str(uid,2)=str(nUserid,2) into dbf xtmp.dbf 

sele xtmp
go top 

set talk off
do thermo with 'S',recc(),'Computing Records,Press ESC to Exit'

do while not eof()
	mlogid=logid
	muid=uid
	muname=''
	if not used('user')
		sele 0
		use user
	else
		sele user
	endif
	set order to userid
	seek str(muid,2)
	if found()
		muname=user
	endif
	
	if Inkey()=27
		wait wind 'CANCELLED!!!' nowa		
		exit
	endif			
	sele xtmp
	repl uname with muname
	do thermo with 'U'
	skip
enddo

do thermo with 'C',0,'RECORDS COMPUTED !'

set talk on 

Brow Wind ShowUlog noed noap node nome nolgrid 

Clos Data 
erase xtmp.dbf
Rele Wind ShowUser
KEYB '{alt+M}'

