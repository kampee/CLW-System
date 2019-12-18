* Procedures and Functions in Utility.DLL

FUNCTION SetEnvironment

SET DATE TO DMY
SET DELETED ON
SET EXCLUSIVE OFF
SET HOUR TO 24
SET MULTILOCKS ON
SET SAFETY OFF
SET SECOND OFF
SET TALK OFF
SET COLLATE TO "MACHINE"
SET NULLDISPLAY TO ""
SET CENTURY ON

ENDFUNC

* Click on Vfp Windows Closebox:
FUNCTION OnShutdown
LOCAL loForm, llFormUnclosed

* Try to close all pending forms:
FOR EACH loForm IN Application.Forms
	IF TYPE("loForm") == "O" AND loForm.Baseclass == "Form"
		ACTIVATE WINDOW (loForm.Name)
		IF !loForm.QueryUnload()
			llFormUnclosed = .T.
		ELSE
			loForm.Release()
		ENDIF
	ENDIF
ENDFOR
* All forms closed ?
IF !llFormUnclosed
	ON SHUTDOWN
	CLEAR EVENTS
ENDIF

ENDFUNC


FUNCTION SetCDir
  LOCAL lcSys16, lcProgram

  lcSys16 = SYS(16)
  lcProgram = SUBSTR(lcSys16, AT(":", lcSys16) - 1)

  CD LEFT(lcProgram, RAT("\", lcProgram))

ENDFUNC
