**************************************************
* Compile Project as ABCOM.DLL (Middle-Tier)
**************************************************
*
*-- Class:        friend
*-- ParentClass:  form
*-- BaseClass:    form
*-- Friend Business Object : N-Tier Example
*
*  (UI) Vfp,Vb,Excel <--> (Business Logic) Abcom.DLL <--> (Database) mssql,oracle,...

#INCLUDE "constant.h"

* ABCOM.Friend:
DEFINE CLASS friend AS Form OLEPUBLIC

	DataSession = 2
 	Name = "friend"
	Caption = "friend"
	cFields = ""
	cReadOnlyFields = ""
	oConn = .F.
	oRDS = .F.

	HIDDEN cFields
	HIDDEN oRDS
	PROTECTED cReadOnlyFields

	PROCEDURE Init

		* create ADO Connection:
		THIS.oConn = CREATEOBJECT("ADODB.Connection")
		IF TYPE("THIS.oConn") <> "O" OR ISNULL(THIS.oConn)
		  RETURN .F.
		ENDIF
		WITH THIS.oConn
		  * OLE DB provider for ODBC:
			*	.ConnectionString = "DSN=abook"	&& - OR -
			.ConnectionString = "Provider=MSDASQL;Data Source=abook;"
			.Open
	  	* Success ? .State = 0-fail, 1-success
		ENDWITH
		
		* create ADO Recordset:
		THIS.oRDS = CREATEOBJECT("ADODB.RecordSet")
		IF TYPE("THIS.oRDS") <> "O" OR ISNULL(THIS.oRDS)
		  RETURN .F.
		ENDIF
		WITH THIS.oRDS
			.ActiveConnection = THIS.oConn
	  	.CursorType = adOpenKeyset
	  	.CursorLocation = adUseClient
		  .LockType = adLockBatchOptimistic
		  .Source = "SELECT * FROM friend"
	  	.Open
	  	* Success ?	.State = 0-fail, 1-success
			* kept cursor field name list:
			*	LOCAL lo
			*	FOR EACH lo IN .Fields
			*		THIS.cFields = THIS.cFields + LOWER(lo.Name) + " "  
			*	ENDFOR
			LOCAL i
			FOR i=0 TO .Fields.Count-1
	  		THIS.cFields = THIS.cFields + LOWER(.Fields(i).Name) + " "  				
			ENDFOR			
	  	* Force-Readonly fields:
			THIS.cReadOnlyFields = "sname lname"
		ENDWITH

	ENDPROC

	
	PROCEDURE GetValue
		LPARAMETERS cField

		IF NOT EMPTY(cField) AND TYPE("cField")="C"
			IF LOWER(cField) $ THIS.cFields

*        RETURN THIS.oRDS.Fields(cField).Value

				LOCAL luRetval
  			WITH THIS.oRDS.Fields(cField)
					luRetval = .Value
		      IF ISNULL(luRetval) THEN
		      	DO CASE 
		      	CASE INLIST(.Type,adChar,adVarChar)
			       luRetval = ""
			      ENDCASE
		      ENDIF
			  ENDWITH  
		    RETURN luRetval

		  ENDIF
		ENDIF
		RETURN .NULL.

	ENDPROC


	PROCEDURE SetValue
		LPARAMETERS cField, uValue

		IF NOT EMPTY(cField) AND TYPE("cField")="C"
			cField = LOWER(cField)
			* 1 ReadOnlyFields - Readonly
			IF NOT (cField $ THIS.cReadOnlyFields) AND (cField $ THIS.cFields)
			* 2 All Fields - Read/Write
			* IF (cField $ THIS.cFields)
		    IF TYPE("uValue")="C"
		       uValue = ALLTRIM(uValue)
		    ENDIF		 
				THIS.oRDS.Fields(cField).Value = uValue
			  RETURN .T.
		  ENDIF
		ENDIF
		RETURN .F.

	ENDPROC


	PROCEDURE MoveFirst

		THIS.oRDS.MoveFirst()
		RETURN 1

	ENDPROC


	PROCEDURE MovePrev
		LOCAL lnRet

		lnRet = 1
		THIS.oRDS.MovePrevious()
		IF THIS.oRDS.BOF THEN
			lnRet = -1
		 	THIS.oRDS.MoveFirst()
		ENDIF
		RETURN lnRet

	ENDPROC


	PROCEDURE MoveNext
		LOCAL lnRet

		lnRet = 1
		THIS.oRDS.MoveNext()
		IF THIS.oRDS.EOF
			lnRet = -1
		  THIS.oRDS.MoveLast()
		ENDIF
		RETURN lnRet

	ENDPROC


	PROCEDURE MoveLast

		THIS.oRDS.MoveLast()
		RETURN 1

	ENDPROC


	PROCEDURE RevertChanges

		THIS.oRDS.CancelBatch adAffectAll

	ENDPROC


	PROCEDURE SaveChanges
		LOCAL lo, lnOldrecno

		* Force-Revert Readonly Fields?
		WITH THIS.oRDS
			lnOldrecno = .BookMark
			.Filter = adFilterPendingRecords
			IF .RecordCount > 0
		    .MoveFirst()
		    DO WHILE NOT .EOF
					FOR EACH lo IN .Fields
		  			IF LOWER(lo.Name) $ THIS.cReadOnlyFields
							IF NOT lo.Value==lo.OriginalValue
								lo.Value = lo.OriginalValue
							ENDIF
						ENDIF
					ENDFOR
		    	.MoveNext()
		    ENDDO
			ENDIF
			.Filter = adFilterNone
			.BookMark = lnOldrecno
		ENDWITH

		THIS.oRDS.UpdateBatch adAffectAll

	ENDPROC


	PROCEDURE SortBy
		LPARAMETER cField

		IF NOT EMPTY(cField) AND TYPE("cField")="C"
			IF LOWER(cField) $ THIS.cFields
				THIS.oRDS.Sort = cField
		  ENDIF
		ENDIF

	ENDPROC


	PROCEDURE GetOldValue
		LPARAMETERS cField

		IF NOT EMPTY(cField) AND TYPE("cField")="C"
			IF LOWER(cField) $ THIS.cFields

*				RETURN THIS.oRDS.Fields(cField).OriginalValue

				LOCAL luRetval
  			WITH THIS.oRDS.Fields(cField)
					luRetval = .OriginalValue
		      IF ISNULL(luRetval) THEN
		      	DO CASE 
		      	CASE INLIST(.Type,adChar,adVarChar)
			       luRetval = ""
			      ENDCASE
		      ENDIF
			  ENDWITH  
		    RETURN luRetval

		  ENDIF
		ENDIF
		RETURN .NULL.

	ENDPROC


	PROCEDURE Release

*		if state=1 then close
*		THIS.oConn.Close
		STORE .F. TO THIS.oRDS, THIS.oConn

	ENDPROC


ENDDEFINE

*-- EndDefine: friend
**************************************************
