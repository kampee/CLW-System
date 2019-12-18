Defi Wind Showwin From 0,0 To Srow(),Scol() close panel ;
	Font 'ms sans serif',8 Style 'n' ;
	Title 'COMPUTED PERSONAL BALANCES'

USE IE 

set talk off
do thermo with 'S',recc(),'Computing Records,Press ESC to Exit'

mcals=0
do while not eof()
	m.ieno=ieno
	m.ettype=''
	m.etcode=etcode
	m.ieinc=ieinc
	m.ieexp=ieexp
	m.iebal=iebal
	m.iebalcal=0
	m.iebaldiff=0
	m.ieupd=ieupd
	mcals=mcals

	if not used('et')
		sele 0
		use et
	else
		sele et
	endif
	set order to etcode
	seek m.etcode
	if found()
		m.ettype=ettype
	else
		m.ettype=''
	endif
	
	if m.etcode<>"OP"
		m.iebalcal=m.ieinc-m.ieexp+mcals
	else
		m.iebalcal=m.ieinc-m.ieexp
	endif
		
	if Inkey()=27
		wait wind 'CANCELLED!!!' nowa		
		exit
	endif		
	if m.ieupd=.t.	
		sele ie
		repl iebalcal with m.iebalcal
		repl iebaldiff with (m.iebal-m.iebalcal)
		repl ettype with m.ettype		
	endif
	do thermo with 'U'
	sele ie
	mcals=m.iebalcal
	skip
enddo

do thermo with 'C',0,'RECORDS COMPUTED !'

set talk on 

Brow Wind Showwin noed noap node nome

Clos Data 
Rele Wind Showwin
KEYB '{alt+M}'

