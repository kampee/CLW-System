cSource = GETFILE('FRX')
lCreateTempReport = .F.
lAutoNameOutput = .T. 
cOutFile = ''
nGenOutPut = 2
LOCAL lcSource,lcReport,lcSafety

lcSource = cSource
IF VARTYPE(lcSource)#"C" OR !FILE(lcSource)
	lcSource = GETFILE("FRX")
	IF !FILE(lcSource)
		RETURN .F.
	ENDIF
ENDIF

cSource = lcSource

IF UPPER(JUSTEXT(lcSource))="DBF" 
	IF lCreateTempReport
		lcSafety = SET("SAFETY")
		SET SAFETY OFF
		lcReport = SYS(2023)+"\"+ JUSTFNAME(FORCEEXT(lcSource,"FRX"))
		CREATE REPORT (lcReport) FROM (lcSource)
		SET SAFETY &lcSafety
		cSource = lcReport
	ELSE
		RETURN .F.
	ENDIF
ENDIF

IF VARTYPE(lAutoNameOutput)="L" AND; 
	lAutoNameOutput
	cOutFile = FORCEEXT(lcSource,"HTM")
ENDIF
DO (_GENHTML) WITH (cOutFile),(cSource),(nGenOutput),"" ,"","" &&(this.cStyle),(this.cScope)
