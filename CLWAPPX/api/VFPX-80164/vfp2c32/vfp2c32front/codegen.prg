#INCLUDE cparserh.h

&& baseclass for code generator classes
DEFINE CLASS oCodeGen AS Exception

	bBufferStruct = .F. && create struct wrapper that reads from a memory buffer?
	bArraySupport = .F. && support structure array indexing?
	nSubscripts = 1 && number of array subscripts if bArraySupport
	nCharSet = 1 && ANSI & Unicode switch
	nPragmaPack = 8 && Pragma pack option as in C(++)
	nAllocScheme = 1 && memory management scheme to use ..

	&& main entry point for code creation
	PROCEDURE CreateCode(loType)
	
	
	ENDPROC
	
	&& returns .T. if a strucuture or union has any direct embedded substructures
	PROCEDURE TypeHasSubStructs(loType)
		IF INLIST(loType.nType,TT_STRUCTHEADER,TT_UNIONHEADER)
			LOCAL xj
			FOR xj = 1 TO ALEN(loType.laMembers)
				IF THIS.TypeHasSubStructs(loType.laMembers[xj])			
					RETURN .T.
				ENDIF
			ENDFOR
			RETURN .F.
		ELSE
			RETURN loType.Typemask = TM_STRUCT AND loType.Indirect = 0
		ENDIF
	ENDPROC
	
	&& returns .T. if a type is a union or contains unions
	PROCEDURE TypeHasUnions(loType)
		IF loType.nType = TT_UNIONHEADER 
			RETURN .T.
		ENDIF

		LOCAL xj
		FOR xj = 1 TO ALEN(loType.laMembers)
			DO CASE
				CASE loType.laMembers[xj].nType = TT_STRUCTHEADER
					IF THIS.TypeHasUnions(loType.laMembers[xj])
						RETURN .T.
					ENDIF
				CASE loType.laMembers[xj].nType = TT_UNIONHEADER
					RETURN .T.
			ENDCASE			
		ENDFOR
		RETURN .F.
	ENDPROC

	&& returns .T. if a type has a member of the type passed in lnTypemask
	PROCEDURE TypeHasMember(loType,lnTypemask)
		IF INLIST(loType.nType,TT_STRUCTHEADER,TT_UNIONHEADER)
			LOCAL xj
			FOR xj = 1 TO ALEN(loType.laMembers)
				IF THIS.TypeHasMember(loType.laMembers[xj],lnTypemask)			
					RETURN .T.
				ENDIF
			ENDFOR
			RETURN .F.
		ELSE
			RETURN BITAND(loType.Typemask,lnTypemask) > 0
		ENDIF	
	ENDPROC
	
	&& returns .T. if a type has a pointer member of the type passed in lnTypemask
	PROCEDURE TypeHasPointerMember(loType,lnTypemask)
		IF INLIST(loType.nType,TT_STRUCTHEADER,TT_UNIONHEADER)
			LOCAL xj
			FOR xj = 1 TO ALEN(loType.laMembers)
				IF THIS.TypeHasPointerMember(loType.laMembers[xj],lnTypemask)
					RETURN .T.
				ENDIF
			ENDFOR
			RETURN .F.
		ELSE
			RETURN BITAND(loType.Typemask,lnTypemask) > 0 AND loType.Indirect > 0
		ENDIF	
	ENDPROC

	&& returns .T. if a type has a array member of the type passed in lnTypemask	
	PROCEDURE TypeHasArrayMember(loType,lnTypemask)
		IF INLIST(loType.nType,TT_STRUCTHEADER,TT_UNIONHEADER)
			LOCAL xj
			FOR xj = 1 TO ALEN(loType.laMembers)
				IF THIS.TypeHasArrayMember(loType.laMembers[xj],lnTypemask)
					RETURN .T.
				ENDIF
			ENDFOR
			RETURN .F.
		ELSE
			RETURN BITAND(loType.Typemask,lnTypemask) > 0 AND loType.bArray
		ENDIF	
	ENDPROC
	
	&& returns the main declarator of a type
	PROCEDURE MainDeclarator(loType)
		LOCAL xj
		FOR xj = 1 TO ALEN(loType.laDeclar)
			IF loType.laDeclar[xj].Indirect = 0 AND VARTYPE(loType.laDeclar[xj].laSubscripts[1]) = 'L'
				RETURN xj
			ENDIF
		ENDFOR
		RETURN 1
	ENDPROC
		
	&& main entry for Control C Code creation	
	PROCEDURE CreateCCode(loType)
	
		LOCAL lcCode, xj, lcName
		lcName = ""
		lcCode = IIF(THIS.nCharset=2,"#define UNICODE"+CRLF,"") + ;
		"#include <windows.h>" + CRLF + ;
		"#include <stddef.h>" + CRLF + ;
		"#include <stdio.h>" + CRLF + CRLF + ;
		"int main(int argc, char argv[])" + CRLF + ;
		"{" + CRLF + ;
		"int nInput;" + CRLF
		
		FOR xj = 1 TO ALEN(loType.laDeclar)
			IF loType.laDeclar[xj].Indirect = 0 AND VARTYPE(loType.laDeclar[xj].laSubscripts[1]) = 'L'
				IF xj = ALEN(loType.laDeclar)
					lcName = "struct " + loType.laDeclar[xj].cName
				ELSE
					lcName = loType.laDeclar[xj].cName
				ENDIF
				EXIT
			ENDIF
		ENDFOR
		
		IF EMPTY(lcName)
			lcName = loType.laDeclar[1].cName
		ENDIF
		
		FOR xj = 1 TO ALEN(loType.laMembers)
			THIS.CreateOffsetCode(loType.laMembers[xj],@lcCode,lcName,"")
		ENDFOR
		
		lcCode = lcCode + [fprintf(stdout,"Size of ] + lcName + [: %d\n",sizeof(] + ;
			lcName + [));] + CRLF
		
		lcCode = lcCode + [fprintf(stdout,"Align of ] + lcName + [: %d\n",__alignof(] + ;
			lcName + [));] + CRLF
		
		lcCode = lcCode + "nInput = _fgetchar();" + CRLF + "}"
		
		RETURN lcCode

	ENDPROC
	
	PROCEDURE CreateOffsetCode(loType,lcCode,lcStructName,lcSubStructName)
		LOCAL xj
		IF INLIST(loType.nType,TT_STRUCTHEADER,TT_UNIONHEADER)
			FOR xj = 1 TO ALEN(loType.laMembers)
				THIS.CreateOffsetCode(loType.laMembers[xj],@lcCode,lcStructName,IIF(EMPTY(loType.cName),lcSubStructName,lcSubStructName+loType.cName+"."))
			ENDFOR
		ELSE
			lcCode = lcCode + [fprintf(stdout,"Offset of ] + loType.cName + [: %d\n",offsetof(] + ;
			lcStructName + "," + lcSubStructName + loType.cName + [));] + CRLF
		ENDIF
	ENDPROC
	
	PROCEDURE CreateOffsetListing(loType)
		
		LOCAL lcCode, xj
		lcCode = ""
		
		FOR xj = 1 TO ALEN(loType.laMembers)
			THIS.CreateOffsetList(loType.laMembers[xj],@lcCode)
		ENDFOR
		
		lcCode = lcCode + "Size: " + ALLTRIM(STR(loType.SizeOf)) + CRLF
		lcCode = lcCode + "Align: " + ALLTRIM(STR(loType.AlignOf)) + CRLF

		RETURN lcCode
	ENDPROC
	
	&& Create Offset List Debug function
	PROCEDURE CreateOffsetList(loType,lcCode)
	
		IF INLIST(loType.nType,TT_STRUCTHEADER,TT_UNIONHEADER)
			LOCAL xj
			FOR xj = 1 TO ALEN(loType.laMembers)
				THIS.CreateOffsetList(loType.laMembers[xj],@lcCode)
			ENDFOR
		ELSE
			lcCode = lcCode + "Offset of " + loType.cName + ": " + ALLTRIM(STR(loType.OffsetOf)) + CRLF
		ENDIF
	
	ENDPROC	
	

ENDDEFINE


DEFINE CLASS oVFPCodeGen AS oCodeGen

	cBaseClass = "Exception" && Baseclass for structure wrapper classes
	cBase = "THIS.Address" && holds either 'THIS.Address' or 'THIS.Offset' (if bArraySupport is .T.), for code generation 
	bAsserts = .T.	&& generate ASSERT functions?
	bReadOnly = .F. && only generate Access Methods / no Assign methods .. 
	nAllocator = 1 && 1 = FLL memory functions, 2 FLL wrappers around GlobalAlloc
	bEnumUCase = .F. && convert enum names to uppercase?
	bEnumHexa = .F. && define enum values as hexadecimal constant's?
	
	PROCEDURE bArraySupport_Assign(bSupport)
		THIS.bArraySupport = bSupport
		THIS.cBase = IIF(bSupport,"THIS.Offset","THIS.Address")
	ENDPROC
	
	&& main entry point for code creation
	PROCEDURE CreateCode(loType)

		LOCAL lcCode, xj, lnMainDeclar

		lcCode = ""
		
		IF loType.nType = TT_ENUMHEADER
			THIS.CreateEnumCode(loType,@lcCode)
			RETURN lcCode
		ENDIF
		SET STEP ON
		lnMainDeclar = THIS.MainDeclarator(loType)
			
		THIS.CreateClassHeader(loType,@lcCode,lnMainDeclar)
		THIS.CreateMemberHeader(loType,@lcCode)
		THIS.CreateClassProcs(loType,@lcCode,lnMainDeclar)
		THIS.CreateMemberProcs(loType,@lcCode)
		THIS.CreateClassFooter(@lcCode)

		RETURN lcCode
	ENDPROC
	
	PROCEDURE CreateClassHeader(loType,lcCode,lnIndex)
		lcCode = lcCode + "DEFINE CLASS " + loType.laDeclar[lnIndex].cName + " AS " + THIS.cBaseClass + CRLF + CRLF
		lcCode = lcCode + OFFSET1 + "Address = 0" + CRLF
		lcCode = lcCode + OFFSET1 + "SizeOf = " + ALLTRIM(STR(loType.laDeclar[lnIndex].SizeOf)) + CRLF
		IF THIS.nAllocator = 2 && GlobalAlloc?
			lcCode = lcCode + OFFSET1 + "hGlobal = 0" + CRLF
			lcCode = lcCode + OFFSET1 + "Locked = .F." + CRLF
		ENDIF
		IF THIS.bArraySupport
			IF !THIS.bBufferStruct
				IF THIS.nSubscripts = 1
					lcCode = lcCode + OFFSET1 + "Rows = 1" + CRLF
				ELSE
					lcCode = lcCode + OFFSET1 + "Rows = 1" + CRLF
					lcCode = lcCode + OFFSET1 + "Dims = 1" + CRLF
					lcCode = lcCode + OFFSET1 + "RowSize = 0" + CRLF
				ENDIF
			ENDIF
			lcCode = lcCode + OFFSET1 + "Offset = 0" + CRLF
		ENDIF
		IF THIS.bBufferStruct
			lcCode = lcCode + OFFSET1 + "BufferSize = 0" + CRLF
		ENDIF
		IF THIS.nAllocScheme = 3 && mixed embedding
			lcCode = lcCode + OFFSET1 + "PROTECTED Embedded" + CRLF
			lcCode = lcCode + OFFSET1 + "Embedded = .F." + CRLF			
		EndIf
		lcCode = lcCode + OFFSET1 + 'Name = "' + loType.laDeclar[lnIndex].cName + '"' + CRLF
		lcCode = lcCode + OFFSET1 + "&" + "& " + "structure fields" + CRLF
	ENDPROC
	
	PROCEDURE CreateMemberHeader(loType,lcCode)
		
		IF INLIST(loType.nType,TT_STRUCTHEADER,TT_UNIONHEADER)
			LOCAL xj
			FOR xj = 1 TO ALEN(loType.laMembers)
				THIS.CreateMemberHeader(loType.laMembers[xj],@lcCode)
			ENDFOR
			RETURN
		ENDIF
		
		DO CASE
			CASE loType.Typemask = TM_STRUCT AND !loType.bArray
				lcCode = lcCode + OFFSET1 + loType.cName + " = .NULL." + CRLF

			CASE loType.bArray AND BITAND(loType.Typemask,TM_CHAR+TM_WCHAR+TM_BYTE) > 0
				DO CASE
					CASE ALEN(loType.laSubscripts) = 1
						lcCode = lcCode + OFFSET1 + loType.cName + " = .F." + CRLF
					CASE ALEN(loType.laSubscripts) = 2
						lcCode = lcCode + OFFSET1 + "DIMENSION " + loType.cName + "[1]" + CRLF
					OTHERWISE
						lcCode = lcCode + OFFSET1 + loType.cName + " = .F." + ;
						" &" + "& " + "more than 2 dimensions not supported natively" + CRLF
				ENDCASE
				
			CASE loType.bArray
				DO CASE
					CASE ALEN(loType.laSubscripts) = 1
						lcCode = lcCode + OFFSET1 + "DIMENSION " + loType.cName + "[1]" + CRLF
					CASE ALEN(loType.laSubscripts) = 1
						lcCode = lcCode + OFFSET1 + "DIMENSION " + loType.cName + "[1,2]" + CRLF					
					OTHERWISE
						lcCode = lcCode + OFFSET1 + loType.cName + " = .F." + ;
						" &" + "& " + "more than 2 dimensions not supported natively" + CRLF
				ENDCASE

			OTHERWISE
				lcCode = lcCode + OFFSET1 + loType.cName + " = .F." + CRLF

		ENDCASE
		
	ENDPROC
	
	PROCEDURE CreateClassProcs(loType,lcCode,lnIndex)
		
		LOCAL lcInitCode, lcDestCode
		
		lcInitCode = ""
		lcDestCode = ""

		lcCode = lcCode + IIF(RIGHT(lcCode,4)=CRLF+CRLF,"",CRLF)

		&& Init Event				
		DO CASE
			CASE THIS.nAllocScheme = 1 && standalone
	
				DO CASE
					CASE !THIS.bBufferStruct AND !THIS.bArraySupport

						lcCode = lcCode + OFFSET1 + "PROCEDURE Init()" + CRLF
						IF THIS.nAllocator = 1
							lcCode = lcCode + OFFSET2 + "THIS.Address = AllocMem(THIS.SizeOf)" + CRLF
							lcCode = lcCode + OFFSET2 + "IF THIS.Address = 0" + CRLF
						ELSE
							lcCode = lcCode + OFFSET2 + "THIS.hGlobal = AllocHGlobal(THIS.SizeOf)" + CRLF
							lcCode = lcCode + OFFSET2 + "IF THIS.hGlobal = 0" + CRLF
						ENDIF
						lcCode = lcCode + OFFSET3 + "ERROR(43)" + CRLF
						lcCode = lcCode + OFFSET3 + "RETURN .F." + CRLF
						lcCode = lcCode + OFFSET2 + "ENDIF" + CRLF
						
						lcInitCode = THIS.CreateMemberInitProc(loType)
						IF !EMPTY(lcInitCode)
							lcCode = lcCode + OFFSET2 + "IF !THIS.AllocMembers()" + " &" + "& " + "Member allocation successful?" + CRLF
							lcCode = lcCode + OFFSET3 + "THIS.FreeMembers()" + CRLF
							IF THIS.nAllocator = 1				
								lcCode = lcCode + OFFSET3 + "FreeMem(THIS.Address)" + CRLF
							ELSE	
								lcCode = lcCode + OFFSET3 + "FreeHGlobal(THIS.hGlobal)" + CRLF	
							ENDIF
							lcCode = lcCode + OFFSET3 + "RETURN .F." + CRLF
							lcCode = lcCode + OFFSET2 + "ENDIF" + CRLF
						ENDIF

						THIS.CreateEmbeddedStructs(loType,@lcCode,2,.T.)
						lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
						
					OTHERWISE
						lcCode = lcCode + OFFSET1 + "PROCEDURE Init()" + CRLF
						THIS.CreateEmbeddedStructs(loType,@lcCode,2,.F.)
						lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
				
				ENDCASE

			CASE THIS.nAllocScheme = 2 && embedded (not responsible for memory allocation/deallocation)

				lcCode = lcCode + OFFSET1 + "PROCEDURE Init(lnAddress)" + CRLF
				IF THIS.bAsserts
					lcCode = lcCode + OFFSET2 + "ASSERT TYPE('lnAddress') = 'N' AND lnAddress != 0 MESSAGE 'Invalid structure address!'" + CRLF
				ENDIF
				lcCode = lcCode + OFFSET2 + "THIS.Address = lnAddress" + CRLF
				lcInitCode = THIS.CreateMemberInitProc(loType)
				IF !EMPTY(lcInitCode)
					lcCode = lcCode + OFFSET2 + "IF !THIS.AllocMembers()" + " &" + "& " + "Member allocation successful?" + CRLF
					lcCode = lcCode + OFFSET3 + "THIS.FreeMembers()" + CRLF
					lcCode = lcCode + OFFSET3 + "RETURN .F." + CRLF
					lcCode = lcCode + OFFSET2 + "ENDIF" + CRLF
				ENDIF
				THIS.CreateEmbeddedStructs(loType,@lcCode,2,.T.)
				lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF

			CASE THIS.nAllocScheme = 3 && mixed

				lcCode = lcCode + OFFSET1 + "PROCEDURE Init(lnAddress)" + CRLF
				lcCode = lcCode + OFFSET2 + "IF PCOUNT() = 0" + CRLF
				
				lcCode = lcCode + OFFSET3 + "THIS.Address = AllocMem(THIS.SizeOf)" + CRLF
				lcCode = lcCode + OFFSET3 + "IF THIS.Address = 0" + CRLF
				lcCode = lcCode + OFFSET4 + "ERROR(43)" + CRLF
				lcCode = lcCode + OFFSET4 + "RETURN .F." + CRLF
				lcCode = lcCode + OFFSET3 + "ENDIF" + CRLF

				lcInitCode = THIS.CreateMemberInitProc(loType)
				IF !EMPTY(lcInitCode)
					lcCode = lcCode + OFFSET3 + "IF !THIS.AllocMembers()" + " &" + "& " + "Member allocation successful?" + CRLF
					lcCode = lcCode + OFFSET4 + "THIS.FreeMembers()" + CRLF
					lcCode = lcCode + OFFSET4 + "FreeMem(THIS.Address)" + CRLF
					lcCode = lcCode + OFFSET4 + "RETURN .F." + CRLF
					lcCode = lcCode + OFFSET3 + "ENDIF" + CRLF
				ENDIF
				lcCode = lcCode + OFFSET2 + "ELSE" + CRLF
				IF THIS.bAsserts
					lcCode = lcCode + OFFSET3 + "ASSERT TYPE('lnAddress') = 'N' AND lnAddress != 0 MESSAGE 'Invalid structure address!'" + CRLF
				ENDIF
				lcCode = lcCode + OFFSET3 + "THIS.Address = lnAddress" + CRLF
				lcCode = lcCode + OFFSET3 + "THIS.Embedded = .T." + CRLF			
				IF !EMPTY(lcInitCode)
					lcCode = lcCode + OFFSET3 + "IF !THIS.AllocMembers()" + " &" + "& " + "Member allocation successful?" + CRLF
					lcCode = lcCode + OFFSET4 + "THIS.FreeMembers()" + CRLF
					lcCode = lcCode + OFFSET4 + "RETURN .F." + CRLF
					lcCode = lcCode + OFFSET3 + "ENDIF" + CRLF
				ENDIF
				lcCode = lcCode + OFFSET2 + "ENDIF" + CRLF
				THIS.CreateEmbeddedStructs(loType,@lcCode,2,.T.)			
				lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF				
				
		ENDCASE
		
		lcCode = lcCode + IIF(RIGHT(lcCode,4)=CRLF+CRLF,"",CRLF)

		&& Destroy Event
		DO CASE
			CASE THIS.nAllocScheme = 1 && standalone
				lcCode = lcCode + OFFSET1 + "PROCEDURE Destroy()" + CRLF
				
				lcDestCode = THIS.CreateMemberDestroyProc(loType)

				DO CASE
					CASE !EMPTY(lcDestCode) AND !THIS.bBufferStruct AND THIS.bArraySupport
						lcCode = lcCode + OFFSET2 + "LOCAL " + IIF(THIS.nSubscripts=1,"lnRows","lnRows,lnDims") + CRLF
						IF THIS.nSubscripts = 1
							lcCode = lcCode + OFFSET2 + "FOR lnRows = 1 TO THIS.Rows" + CRLF
							lcCode = lcCode + OFFSET3 + "THIS.AIndex(lnRows)" + CRLF
							lcCode = lcCode + OFFSET3 + "THIS.FreeMembers()" + CRLF
							lcCode = lcCode + OFFSET2 + "ENDFOR" + CRLF
						ELSE
							lcCode = lcCode + OFFSET2 + "FOR lnDims = 1 TO THIS.Dims" + CRLF
							lcCode = lcCode + OFFSET3 + "FOR lnRows = 1 TO THIS.Rows" + CRLF
							lcCode = lcCode + OFFSET4 + "THIS.AIndex(lnRows,lnDims)" + CRLF
							lcCode = lcCode + OFFSET4 + "THIS.FreeMembers()" + CRLF
							lcCode = lcCode + OFFSET3 + "ENDFOR" + CRLF
							lcCode = lcCode + OFFSET2 + "ENDFOR" + CRLF
						ENDIF
						THIS.DestroyEmbeddedStructs(loType,@lcCode)
					
					CASE !EMPTY(lcDestCode)
						THIS.DestroyEmbeddedStructs(loType,@lcCode)
						lcCode = lcCode + OFFSET2 + "THIS.FreeMembers()" + CRLF
						
				ENDCASE
				
				IF THIS.nAllocator = 1
					lcCode = lcCode + OFFSET2 + "FreeMem(THIS.Address)" + CRLF
				ELSE
					lcCode = lcCode + OFFSET2 + "ASSERT !THIS.Locked MESSAGE 'Unlock memory first!'" + CRLF
					lcCode = lcCode + OFFSET2 + "FreeHGlobal(THIS.hGlobal)" + CRLF
				ENDIF
				lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
			
			CASE THIS.nAllocScheme = 2 && not responsible for memory
			
			CASE THIS.nAllocScheme = 3 && mixed
			
				lcCode = lcCode + OFFSET1 + "PROCEDURE Destroy()" + CRLF			
				THIS.DestroyEmbeddedStructs(loType,@lcCode)
				lcCode = lcCode + OFFSET2 + "IF !THIS.Embedded" + CRLF
				lcDestCode = THIS.CreateMemberDestroyProc(loType)
				IF !EMPTY(lcDestCode)
					lcCode = lcCode + OFFSET3 + "THIS.FreeMembers()" + CRLF
				ENDIF
				lcCode = lcCode + OFFSET3 + "FreeMem(THIS.Address)" + CRLF
				lcCode = lcCode + OFFSET2 + "ENDIF" + CRLF
				lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF				
				
		ENDCASE

		IF !EMPTY(lcInitCode)
			lcCode = lcCode + lcInitCode
		ENDIF
		
		IF !EMPTY(lcDestCode)
			lcCode = lcCode + lcDestCode
		ENDIF

		&& Dimension Method		
		IF THIS.bArraySupport AND !THIS.bBufferStruct
			lcCode = lcCode + OFFSET1 + "PROCEDURE Dimension(" + IIF(THIS.nSubscripts=1,"lnRows","lnRows,lnDims") + ")" + CRLF
			IF THIS.bAsserts
				lcCode = lcCode + OFFSET2 + "ASSERT TYPE('lnRows') = 'N' AND lnRows > 0 MESSAGE 'Invalid row subscript!'" + CRLF
				IF THIS.nSubscripts = 2
					lcCode = lcCode + OFFSET2 + "ASSERT TYPE('lnDims') = 'N' AND lnDims > 0 MESSAGE 'Invalid dimension subscript!'" + CRLF
				ENDIF
			ENDIF
			IF THIS.nAllocator = 1
				lcCode = lcCode + OFFSET2 + "IF THIS.Address != 0"
			ELSE
				lcCode = lcCode + OFFSET2 + "IF THIS.hGlobal != 0"
			ENDIF
			lcCode = lcCode + " &" + "& " + "Redimensioning not supported natively" + CRLF
			lcCode = lcCode + OFFSET3 + "RETURN .F." + CRLF
			lcCode = lcCode + OFFSET2 + "ENDIF" + CRLF
			IF THIS.nSubscripts = 1
				IF THIS.nAllocator = 1
					lcCode = lcCode + OFFSET2 + "THIS.Address = AllocMem(THIS.SizeOf*lnRows)" + CRLF
					lcCode = lcCode + OFFSET2 + "IF THIS.Address = 0" + CRLF
				ELSE
					lcCode = lcCode + OFFSET2 + "THIS.hGlobal = AllocHGlobal(THIS.SizeOf*lnRows)" + CRLF
					lcCode = lcCode + OFFSET2 + "IF THIS.hGlobal = 0" + CRLF
				ENDIF
				lcCode = lcCode + OFFSET3 + "ERROR(43)" + CRLF
				lcCode = lcCode + OFFSET3 + "RETURN .F." + CRLF
				lcCode = lcCode + OFFSET2 + "ENDIF" + CRLF
				lcCode = lcCode + OFFSET2 + "THIS.Rows = lnRows" + CRLF
			ELSE
				IF THIS.nAllocator = 1
					lcCode = lcCode + OFFSET2 + "THIS.Address = AllocMem(THIS.SizeOf*lnRows*lnDims)" + CRLF
					lcCode = lcCode + OFFSET2 + "IF THIS.Address = 0" + CRLF
				ELSE
					lcCode = lcCode + OFFSET2 + "THIS.hGlobal = AllocHGlobal(THIS.SizeOf*lnRows*lnDims)" + CRLF
					lcCode = lcCode + OFFSET2 + "IF THIS.hGlobal = 0" + CRLF
				ENDIF
				lcCode = lcCode + OFFSET3 + "ERROR(43)" + CRLF
				lcCode = lcCode + OFFSET3 + "RETURN .F." + CRLF
				lcCode = lcCode + OFFSET2 + "ENDIF" + CRLF
				lcCode = lcCode + OFFSET2 + "THIS.Rows = lnRows" + CRLF
				lcCode = lcCode + OFFSET2 + "THIS.Dims = lnDims" + CRLF
				lcCode = lcCode + OFFSET2 + "THIS.RowSize = THIS.SizeOf * lnRows" + CRLF
			ENDIF
			IF THIS.nAllocator = 1 AND !THIS.TypeHasSubStructs(loType)
				lcCode = lcCode + OFFSET2 + "THIS.Offset = THIS.Address" + CRLF
			ENDIF
			lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
		ENDIF

		&& Lock & Unlock when Allocator is GlobalAlloc		
		IF THIS.nAllocator = 2
			lcCode = lcCode + OFFSET1 + "PROCEDURE Lock()" + CRLF
			lcCode = lcCode + OFFSET2 + "ASSERT !THIS.Locked MESSAGE 'Memory handle already locked!'" + CRLF
			lcCode = lcCode + OFFSET2 + "THIS.Address = LockHGlobal(THIS.hGlobal)" + CRLF
			lcCode = lcCode + OFFSET2 + "IF THIS.Address != 0" + CRLF
			lcCode = lcCode + OFFSET3 + "THIS.Locked = .T." + CRLF
			lcCode = lcCode + OFFSET2 + "ENDIF" + CRLF
			lcCode = lcCode + OFFSET2 + "RETURN THIS.Locked" + CRLF
			lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
			
			lcCode = lcCode + OFFSET1 + "PROCEDURE Unlock()" + CRLF
			lcCode = lcCode + OFFSET2 + "ASSERT THIS.Locked MESSAGE 'Memory handle not locked!'" + CRLF
			lcCode = lcCode + OFFSET2 + "IF UnlockHGlobal(THIS.hGlobal) >= 0" + CRLF
			lcCode = lcCode + OFFSET3 + "THIS.Locked = .F." + CRLF
			lcCode = lcCode + OFFSET2 + "ENDIF" + CRLF
			lcCode = lcCode + OFFSET2 + "RETURN !THIS.Locked" + CRLF
			lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
		ENDIF
		
		&& AIndex if arraysupport
		IF THIS.bArraySupport
			IF THIS.nSubscripts = 1
				lcCode = lcCode + OFFSET1 + "PROCEDURE AIndex(lnRow)" + CRLF
				IF THIS.bAsserts
					IF THIS.bBufferStruct
						lcCode = lcCode + OFFSET2 + "ASSERT TYPE('lnRow') = 'N' AND lnRow > 0 MESSAGE 'Row subscript invalid!'" + CRLF
					ELSE
						lcCode = lcCode + OFFSET2 + "ASSERT TYPE('lnRow') = 'N' AND BETWEEN(lnRow,1,THIS.Rows) MESSAGE 'Row subscript not numeric or out of range!'" + CRLF
					ENDIF
				ENDIF
				lcCode = lcCode + OFFSET2 + "THIS.Offset = THIS.Address+THIS.SizeOf*(lnRow-1)" + CRLF
			ELSE
				lcCode = lcCode + OFFSET1 + "PROCEDURE AIndex(lnRow,lnDim)" + CRLF
				IF THIS.bAsserts
					IF THIS.bBufferStruct
						lcCode = lcCode + OFFSET2 + "ASSERT TYPE('lnRow') = 'N' AND lnRow > 0 MESSAGE 'Row subscript invalid!'" + CRLF
						lcCode = lcCode + OFFSET2 + "ASSERT TYPE('lnDim') = 'N' AND lnDim > 0 MESSAGE 'Dimension subscript invalid!'" + CRLF
					ELSE
						lcCode = lcCode + OFFSET2 + "ASSERT TYPE('lnRow') = 'N' AND BETWEEN(lnRow,1,THIS.Rows) MESSAGE 'Row subscript not numeric or out of range!'" + CRLF
						lcCode = lcCode + OFFSET2 + "ASSERT TYPE('lnDim') = 'N' AND BETWEEN(lnDim,1,THIS.Dims) MESSAGE 'Dimension subscript not numeric or out of range!'" + CRLF
					ENDIF
				ENDIF
				lcCode = lcCode + OFFSET2 + "THIS.Offset = THIS.Address+(lnDim-1)*THIS.RowSize+(lnRow-1)*THIS.SizeOf" + CRLF
			ENDIF
			lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
		ENDIF
		
		&& Address_Assign if struct has substructures
		IF THIS.TypeHasSubStructs(loType)
			DO CASE
				CASE !THIS.bArraySupport AND !THIS.bBufferStruct
					lcCode = lcCode + OFFSET1 + "PROCEDURE " + "Address_Assign(lnAddress)" + CRLF
					lcCode = lcCode + OFFSET2 + "DO CASE" + CRLF
					lcCode = lcCode + OFFSET3 + "CASE THIS.Address = 0" + CRLF
					lcCode = lcCode + OFFSET4 + "THIS.Address = lnAddress" + CRLF
					lcCode = lcCode + OFFSET3 + "CASE THIS.Address = lnAddress" + CRLF
					lcCode = lcCode + OFFSET3 + "OTHERWISE" + CRLF
					lcCode = lcCode + OFFSET4 + "THIS.Address = lnAddress" + CRLF
					THIS.CreateAddressAssignCode(loType,@lcCode,4)
					lcCode = lcCode + OFFSET2 + "ENDCASE" + CRLF
					lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
			
				CASE THIS.bArraySupport
					lcCode = lcCode + OFFSET1 + "PROCEDURE " + "Address_Assign(lnAddress)" + CRLF
					lcCode = lcCode + OFFSET2 + "THIS.Address = lnAddress" + CRLF
					lcCode = lcCode + OFFSET2 + "THIS.Offset = lnAddress" + CRLF
					lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF

					lcCode = lcCode + OFFSET1 + "PROCEDURE " + "Offset_Assign(lnAddress)" + CRLF
					lcCode = lcCode + OFFSET2 + "THIS.Offset = lnAddress" + CRLF
					THIS.CreateAddressAssignCode(loType,@lcCode,2)
					lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
					
				CASE !THIS.bArraySupport AND THIS.bBufferStruct
					lcCode = lcCode + OFFSET1 + "PROCEDURE " + "Address_Assign(lnAddress)" + CRLF
					lcCode = lcCode + OFFSET2 + "THIS.Address = lnAddress" + CRLF
					THIS.CreateAddressAssignCode(loType,@lcCode,2)
					lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
					
			ENDCASE
		ENDIF
		
		&& BufferSize_Assign 
		IF THIS.bBufferStruct
			IF THIS.nAllocator = 1
				lcCode = lcCode + OFFSET1 + "PROCEDURE BufferSize_Assign(lnBufferSize)" + CRLF
				lcCode = lcCode + OFFSET2 + "LOCAL lnAddress" + CRLF
				lcCode = lcCode + OFFSET2 + "lnAddress = ReAllocMem(THIS.Address,lnBufferSize)" + CRLF
				lcCode = lcCode + OFFSET2 + "IF lnAddress != 0" + CRLF
				lcCode = lcCode + OFFSET3 + "THIS.Address = lnAddress" + CRLF
				lcCode = lcCode + OFFSET3 + "THIS.BufferSize = lnBufferSize" + CRLF
				lcCode = lcCode + OFFSET2 +	"ELSE" + CRLF
				lcCode = lcCode + OFFSET3 + "ERROR(43)" + CRLF
				lcCode = lcCode + OFFSET2 +	"ENDIF" + CRLF
				lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
			ELSE
				lcCode = lcCode + OFFSET1 + "PROCEDURE BufferSize_Assign(lnBufferSize)" + CRLF
				lcCode = lcCode + OFFSET2 + "LOCAL lnHGlobal" + CRLF
				lcCode = lcCode + OFFSET2 + "lnHGlobal = ReAllocHGlobal(THIS.hGlobal,lnBufferSize)" + CRLF
				lcCode = lcCode + OFFSET2 + "IF lnHGlobal != 0" + CRLF
				lcCode = lcCode + OFFSET3 + "THIS.hGlobal = lnHGlobal" + CRLF
				lcCode = lcCode + OFFSET3 + "THIS.BufferSize = lnBufferSize" + CRLF
				lcCode = lcCode + OFFSET2 +	"ELSE" + CRLF
				lcCode = lcCode + OFFSET3 + "ERROR(43)" + CRLF
				lcCode = lcCode + OFFSET2 +	"ENDIF" + CRLF
				lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
			ENDIF
		ENDIF

	ENDPROC
	
	PROCEDURE CreateMemberInitProc(loType)

		LOCAL xj, lcInitCode, lbAddress
		lcInitCode = ""

		FOR xj = 1 TO ALEN(loType.laMembers)
			THIS.CreateMemberAllocCode(loType.laMembers[xj],@lcInitCode)
		ENDFOR

		IF !EMPTY(lcInitCode)
			lbAddress = AT("lnAddress",lcInitCode) > 0 
			lcInitCode = OFFSET1 + "PROCEDURE AllocMembers()" + CRLF + ;
			IIF(lbAddress,OFFSET2 + "LOCAL lnAddress" + CRLF,"") + lcInitCode 
			lcInitCode = lcInitCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
		ENDIF
		
		RETURN lcInitCode
		
	ENDPROC
	
	PROCEDURE CreateMemberAllocCode(loType,lcInitCode)
		IF INLIST(loType.nType,TT_STRUCTHEADER,TT_UNIONHEADER)
			LOCAL xj
			FOR xj = 1 TO ALEN(loType.laMembers)
				THIS.CreateMemberAllocCode(loType.laMembers[xj],@lcInitCode)			
			ENDFOR
			RETURN
		ENDIF
		
		&& allocate pointer members to basic types
		IF (loType.Indirect = 1 AND BITAND(loType.Typemask,TM_INT8+TM_SHORT+TM_INT+TM_LONG+TM_FLOAT+TM_DOUBLE+TM_INT64) > 0) ;
			OR (loType.Indirect = 2 AND BITAND(loType.Typemask,TM_VOID) > 0)
				lcInitCode = lcInitCode + OFFSET2 + "lnAddress = AllocMemTo(THIS.Address" + ;
				IIF(loType.OffsetOf>0,"+"+ALLTRIM(STR(loType.OffsetOf)),"") + "," + ;
				IIF(loType.bArray,ALLTRIM(STR(loType.SizeOf)),ALLTRIM(STR(loType.BaseSize))) + ") &" + "& allocate memory for " + loType.cName + CRLF
				lcInitCode = lcInitCode + OFFSET2 + "IF lnAddress = 0" + CRLF
				lcInitCode = lcInitCode + OFFSET3 + "RETURN .F." + CRLF
				lcInitCode = lcInitCode + OFFSET2 + "ENDIF" + CRLF
		ENDIF
	ENDPROC
	
	PROCEDURE CreateMemberDestroyProc(loType)
	
		LOCAL xj, lcDestCode
		lcDestCode = ""

		FOR xj = 1 TO ALEN(loType.laMembers)
			THIS.CreateMemberFreeCode(loType.laMembers[xj],@lcDestCode)
		ENDFOR

		IF !EMPTY(lcDestCode)
			lcDestCode = OFFSET1 + "PROCEDURE FreeMembers()" + CRLF + lcDestCode
			lcDestCode = lcDestCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
		ENDIF
		
		RETURN lcDestCode
	
	ENDPROC
	
	PROCEDURE CreateMemberFreeCode(loType,lcDestCode)
	
		IF INLIST(loType.nType,TT_STRUCTHEADER,TT_UNIONHEADER)
			LOCAL xj
			FOR xj = 1 TO ALEN(loType.laMembers)
				THIS.CreateMemberFreeCode(loType.laMembers[xj],@lcDestCode)			
			ENDFOR
			RETURN
		ENDIF
	
		IF (loType.Indirect = 1 AND BITAND(loType.Typemask,TM_INT8+TM_CHAR+TM_WCHAR+TM_SHORT+TM_INT+TM_LONG+TM_FLOAT+TM_DOUBLE+TM_INT64) > 0) ;
			OR (loType.Indirect = 2 AND BITAND(loType.Typemask,TM_VOID) > 0)
			lcDestCode= lcDestCode+ OFFSET2 + "FreePMem(" + THIS.cBase + ;
			IIF(loType.OffsetOf>0,"+"+ALLTRIM(STR(loType.OffsetOf)),"") + ")" + CRLF
		ENDIF
		
	ENDPROC
	
	PROCEDURE CreateEmbeddedStructs(loType,lcCode,lnOffset,lbAddress)
		IF INLIST(loType.nType,TT_STRUCTHEADER,TT_UNIONHEADER)
			LOCAL xj
			FOR xj = 1 TO ALEN(loType.laMembers)
				THIS.CreateEmbeddedStructs(loType.laMembers[xj],@lcCode,lnOffset,lbAddress)			
			ENDFOR
			RETURN
		ENDIF
		
		IF loType.Typemask = TM_STRUCT AND loType.Indirect = 0
			lcCode = lcCode + REPLICATE(CHR(9),lnOffset) + "THIS." + loType.cName + ;
			IIF(loType.bArray,"[1]","") + " = CREATEOBJECT('" + loType.VFPClass + "',"
			IF lbAddress
				lcCode = lcCode + "THIS.Address" + IIF(loType.OffsetOf>0,"+"+ALLTRIM(STR(loType.OffsetOf)),"") + ")" + CRLF
			ELSE
				lcCode = lcCode + "0)" + CRLF
			ENDIF				
		ENDIF
	ENDPROC
	
	PROCEDURE DestroyEmbeddedStructs(loType,lcCode)
		IF INLIST(loType.nType,TT_STRUCTHEADER,TT_UNIONHEADER)
			LOCAL xj
			FOR xj = 1 TO ALEN(loType.laMembers)
				THIS.DestroyEmbeddedStructs(loType.laMembers[xj],@lcCode)			
			ENDFOR
			RETURN
		ENDIF
		
		IF loType.Typemask = TM_STRUCT AND loType.Indirect = 0
			lcCode = lcCode + OFFSET2 + "THIS." + loType.cName + ;
			IIF(loType.bArray,"[1]","") + " = .NULL." + CRLF
		ENDIF
	ENDPROC
	
	PROCEDURE CreateAddressAssignCode(loType,lcCode,lnOffset)
		IF INLIST(loType.nType,TT_STRUCTHEADER,TT_UNIONHEADER)
			LOCAL xj
			FOR xj = 1 TO ALEN(loType.laMembers)
				THIS.CreateAddressAssignCode(loType.laMembers[xj],@lcCode,lnOffset)			
			ENDFOR
			RETURN
		ENDIF
		
		IF loType.Typemask = TM_STRUCT AND loType.Indirect = 0
			lcCode = lcCode + REPLICATE(CHR(9),lnOffset) + "THIS." + loType.cName + ;
			IIF(loType.bArray,"[1]","") + ".Address = lnAddress"
			lcCode = lcCode + IIF(loType.OffsetOf>0,"+"+ALLTRIM(STR(loType.OffsetOf)),"") + CRLF
		ENDIF
	
	ENDPROC
	
	PROCEDURE CreateMemberProcs(loType,lcCode)
	
		IF INLIST(loType.nType,TT_STRUCTHEADER,TT_UNIONHEADER)
			LOCAL xj
			FOR xj = 1 TO ALEN(loType.laMembers)
				THIS.CreateMemberProcs(loType.laMembers[xj],@lcCode)
			ENDFOR
			RETURN
		ENDIF

		&& Access Method
		DO CASE
			&& embedded structure array
			CASE loType.Typemask = TM_STRUCT AND loType.Indirect = 0 AND loType.bArray 
				DO CASE
					CASE ALEN(loType.laSubscripts) = 1
						lcCode = lcCode + OFFSET1 + "PROCEDURE " + loType.cName + "_Access(lnRow)" + CRLF
						IF THIS.bAsserts
							lcCode = lcCode + OFFSET2 + "ASSERT TYPE('lnRow') = 'N' AND BETWEEN(lnRow,1," + ;
							ALLTRIM(STR(loType.laSubscripts[1])) + ") MESSAGE 'Invalid row subscript!'" + CRLF
						ENDIF
						lcCode = lcCode + OFFSET2 + "THIS." + loType.cName + "[1].Address = " + THIS.cBase
						lcCode = lcCode + IIF(loType.OffsetOf>0,"+"+ALLTRIM(STR(loType.OffsetOf)),"")
						lcCode = lcCode + "+(lnRow-1)*" + ALLTRIM(STR(loType.BaseSize)) + CRLF
						lcCode = lcCode + OFFSET2 + "RETURN THIS." + loType.cName + "[1]" + CRLF
						lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
			
					CASE ALEN(loType.laSubscripts) = 2
						lcCode = lcCode + OFFSET1 + "PROCEDURE " + loType.cName + "_Access(lnRow,lnDim)" + CRLF
						IF THIS.bAsserts
							lcCode = lcCode + OFFSET2 + "ASSERT TYPE('lnRow') = 'N' AND BETWEEN(lnRow,1," + ;
							ALLTRIM(STR(loType.laSubscripts[1])) + ") MESSAGE 'Invalid row subscript!'" + CRLF
							lcCode = lcCode + OFFSET2 + "ASSERT TYPE('lnDim') = 'N' AND BETWEEN(lnDim,1," + ;
							ALLTRIM(STR(loType.laSubscripts[2])) + ") MESSAGE 'Invalid dimension subscript!'" + CRLF						
						ENDIF
						lcCode = lcCode + OFFSET2 + "THIS." + loType.cName + "[1].Address = " + THIS.cBase
						lcCode = lcCode + IIF(loType.OffsetOf>0,"+"+ALLTRIM(STR(loType.OffsetOf)),"")
						lcCode = lcCode + "+" + ALLTRIM(STR(loType.BaseSize*loType.laSubscripts[1])) + "*(lnDim-1)+"
						lcCode = lcCode + "*(lnRow-1)" + ALLTRIM(STR(loType.BaseSize)) + CRLF
						lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
											
					OTHERWISE
						lcCode = lcCode + OFFSET1 + "PROCEDURE " + "Get" + loType.cName + "()" + CRLF
						lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
		
				ENDCASE
			
			&& don't create code for normal embedded structures
			CASE loType.Typemask = TM_STRUCT AND loType.Indirect = 0
			
			&& pointer to another structure
			CASE loType.Typemask = TM_STRUCT AND loType.Indirect = 1
				lcCode = lcCode + OFFSET1 + "PROCEDURE " + loType.cName + "_Access()" + CRLF
				lcCode = lcCode + OFFSET2 + "RETURN " + loType.ReadFunc + "(" + THIS.cBase
				lcCode = lcCode + IIF(loType.OffsetOf>0,"+"+ALLTRIM(STR(loType.OffsetOf)),"") + ")" + CRLF
				lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
			
			&& basetype array?
			CASE loType.bArray
				&& array of character type?
				IF BITAND(loType.Typemask,TM_CHAR+TM_WCHAR+TM_BYTE) > 0
		
					DO CASE
						CASE ALEN(loType.laSubscripts) = 1
							lcCode = lcCode + OFFSET1 + "PROCEDURE " + loType.cName + "_Access()" + CRLF
							lcCode = lcCode + OFFSET2 + "RETURN " + loType.ReadFunc + "(" + THIS.cBase
							lcCode = lcCode + IIF(loType.OffsetOf>0,"+"+ALLTRIM(STR(loType.OffsetOf)),"") + ","
							lcCode = lcCode + ALLTRIM(STR(loType.laSubscripts[1])) + ")" + CRLF
							lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF

						CASE ALEN(loType.laSubscripts) = 2
							lcCode = lcCode + OFFSET1 + "PROCEDURE " + loType.cName + "_Access(lnDim)" + CRLF
							IF THIS.bAsserts						
								lcCode = lcCode + OFFSET2 + "ASSERT TYPE('lnDim') = 'N' AND BETWEEN(lnDim,1," + ;
								ALLTRIM(STR(loType.laSubscripts[2])) + ") MESSAGE 'Invalid dimension subscript!'" + CRLF				
							ENDIF
							lcCode = lcCode + OFFSET2 + "RETURN " + loType.ReadFunc + "(" + THIS.cBase
							lcCode = lcCode + IIF(loType.OffsetOf>0,"+"+ALLTRIM(STR(loType.OffsetOf)),"")
							lcCode = lcCode + "+(lnDim-1)*" + ALLTRIM(STR(loType.BaseSize * loType.laSubscripts[1]))
							lcCode = lcCode + "," + ALLTRIM(STR(loType.laSubscripts[1])) + ")" + CRLF
							lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF

						OTHERWISE
							lcCode = lcCode + OFFSET1 + "PROCEDURE " + "Get" + loType.cName + "()" + CRLF
							lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
					ENDCASE
		
				ELSE && else array of some numerical type
				
					DO CASE
						CASE ALEN(loType.laSubscripts) = 1
							lcCode = lcCode + OFFSET1 + "PROCEDURE " + loType.cName + "_Access(lnRow)" + CRLF

							IF THIS.bAsserts					
								lcCode = lcCode + OFFSET2 + "ASSERT TYPE('lnRow') = 'N' AND BETWEEN(lnRow,1," + ;
								ALLTRIM(STR(loType.laSubscripts[1])) + ") MESSAGE 'Invalid row subscript!'" + CRLF
							ENDIF

							lcCode = lcCode + OFFSET2 + "RETURN " + loType.ReadFunc + "(" + THIS.cBase
							lcCode = lcCode + IIF(loType.OffsetOf>0,"+"+ALLTRIM(STR(loType.OffsetOf)),"")							
							lcCode = lcCode + "+(lnRow-1)*" + ALLTRIM(STR(loType.BaseSize)) + ")" + CRLF				
							lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
						
						CASE ALEN(loType.laSubscripts) = 2
							lcCode = lcCode + OFFSET1 + "PROCEDURE " + loType.cName + "_Access(lnRow,lnDim)" + CRLF

							IF THIS.bAsserts					
								lcCode = lcCode + OFFSET2 + "ASSERT TYPE('lnRow') = 'N' AND BETWEEN(lnRow,1," + ;
								ALLTRIM(STR(loType.laSubscripts[1])) + ") MESSAGE 'Invalid row subscript!'" + CRLF
								lcCode = lcCode + OFFSET2 + "ASSERT TYPE('lnDim') = 'N' AND BETWEEN(lnDim,1," + ;
								ALLTRIM(STR(loType.laSubscripts[2])) + ") MESSAGE 'Invalid dimension subscript!'" + CRLF
							ENDIF
							
							lcCode = lcCode + OFFSET2 + "RETURN " + loType.ReadFunc + "(" + THIS.cBase
							lcCode = lcCode + IIF(loType.OffsetOf>0,"+"+ALLTRIM(STR(loType.OffsetOf)),"")							
							lcCode = lcCode + "+(lnDim-1)*" + ALLTRIM(STR(loType.laSubscripts[1] * loType.BaseSize)) + ;
							"+(lnRow-1)*" + ALLTRIM(STR(loType.BaseSize)) + ")" + CRLF
							lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
							
						OTHERWISE
							lcCode = lcCode + OFFSET1 + "PROCEDURE " + "Get" + loType.cName + "()" + CRLF
							lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF

					ENDCASE
					
				ENDIF
				
			&& a normal basetype				
			OTHERWISE
			
				lcCode = lcCode + OFFSET1 + "PROCEDURE " + loType.cName + "_Access()" + CRLF
				lcCode = lcCode + OFFSET2 + "RETURN " + loType.Readfunc + "(" + THIS.cBase + ;
				IIF(loType.OffsetOf>0,"+"+ALLTRIM(STR(loType.OffsetOf)),"") + ")" + CRLF
				lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
				
		ENDCASE
		
		IF THIS.bReadOnly
			RETURN
		ENDIF
		
		DO CASE
			&& embedded structure
			CASE loType.Typemask = TM_STRUCT AND loType.Indirect = 0
			CASE loType.Typemask = TM_STRUCT AND loType.Indirect > 1
						
			&& pointer to another structure	
			CASE loType.Typemask = TM_STRUCT AND loType.Indirect = 1
				lcCode = lcCode + OFFSET1 + "PROCEDURE " + loType.cName + "_Assign(lnNewVal)" + CRLF
				IF THIS.bAsserts AND !EMPTY(loType.Assertion)
					lcCode = lcCode + OFFSET2 + loType.Assertion + " MESSAGE 'Wrong datatype or value out of range!'" + CRLF
				ENDIF
				lcCode = lcCode + OFFSET2 + loType.Writefunc + "(" + THIS.cBase + ;
				IIF(loType.OffsetOf>0,"+"+ALLTRIM(STR(loType.OffsetOf)),"") + ",lnNewVal)" + CRLF
				lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF

			&& array of some kind?
			CASE loType.bArray
						
				IF BITAND(loType.Typemask,TM_CHAR+TM_WCHAR+TM_BYTE) > 0
				
					DO CASE
						CASE ALEN(loType.laSubscripts) = 1
							lcCode = lcCode + OFFSET1 + "PROCEDURE " + loType.cName + "_Assign(lnNewVal)" + CRLF
							IF THIS.bAsserts AND !EMPTY(loType.Assertion)
								lcCode = lcCode + OFFSET2 + loType.Assertion + " MESSAGE 'Wrong datatype or value out of range!'" + CRLF
							ENDIF
							lcCode = lcCode + OFFSET2 + loType.WriteFunc + "(" + THIS.cBase
							lcCode = lcCode + IIF(loType.OffsetOf>0,"+"+ALLTRIM(STR(loType.OffsetOf)),"") + ",lnNewVal,"
							lcCode = lcCode + ALLTRIM(STR(loType.laSubscripts[1])) + ")" + CRLF
							lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF

						CASE ALEN(loType.laSubscripts) = 2
							lcCode = lcCode + OFFSET1 + "PROCEDURE " + loType.cName + "_Assign(lnDim)" + CRLF
						
							IF THIS.bAsserts						
								lcCode = lcCode + OFFSET2 + "ASSERT TYPE('lnDim') = 'N' AND BETWEEN(lnDim,1," + ;
								ALLTRIM(STR(loType.laSubscripts[2])) + ") MESSAGE 'Invalid dimension subscript!'" + CRLF				
							ENDIF
						
							IF THIS.bAsserts AND !EMPTY(loType.Assertion)
								lcCode = lcCode + OFFSET2 + loType.Assertion + " MESSAGE 'Wrong datatype or value out of range!'" + CRLF
							ENDIF
							
							lcCode = lcCode + OFFSET2 + loType.WriteFunc + "(" + THIS.cBase
							lcCode = lcCode + IIF(loType.OffsetOf>0,"+"+ALLTRIM(STR(loType.OffsetOf)),"")							
							lcCode = lcCode + "+(lnDim-1)*" + ALLTRIM(STR(loType.BaseSize * loType.laSubscripts[1]))
							lcCode = lcCode + "," + ALLTRIM(STR(loType.laSubscripts[1])) + ")" + CRLF					
							lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF

						OTHERWISE
							lcCode = lcCode + OFFSET1 + "PROCEDURE " + "Set" + loType.cName + "()" + CRLF
							lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
					ENDCASE
					
				ELSE
				
					DO CASE
						CASE ALEN(loType.laSubscripts) = 1
							lcCode = lcCode + OFFSET1 + "PROCEDURE " + loType.cName + "_Assign(lnRow,lnNewVal)" + CRLF
							IF THIS.bAsserts
								lcCode = lcCode + OFFSET2 + "ASSERT TYPE('lnRow') = 'N' AND BETWEEN(lnRow,1," + ;
								ALLTRIM(STR(loType.laSubscripts[1])) + ") MESSAGE 'Invalid row subscript!'" + CRLF
								IF !EMPTY(loType.Assertion)
									lcCode = lcCode + OFFSET2 + loType.Assertion + " MESSAGE 'Wrong datatype or value out of range!'" + CRLF								
								ENDIF
							ENDIF
							
							lcCode = lcCode + OFFSET2 + loType.WriteFunc + "(" + THIS.cBase
							lcCode = lcCode + IIF(loType.OffsetOf>0,"+"+ALLTRIM(STR(loType.OffsetOf)),"")							
							lcCode = lcCode + "+(lnRow-1)*" + ALLTRIM(STR(loType.BaseSize)) + ",lnNewVal)" + CRLF
							lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
							
						CASE ALEN(loType.laSubscripts) = 2
							lcCode = lcCode + OFFSET1 + "PROCEDURE " + loType.cName + "_Assign(lnRow,lnDim,lnNewVal)" + CRLF
							IF THIS.bAsserts
								lcCode = lcCode + OFFSET2 + "ASSERT TYPE('lnRow') = 'N' AND BETWEEN(lnRow,1," + ;
								ALLTRIM(STR(loType.laSubscripts[1])) + ") MESSAGE 'Invalid row subscript!'" + CRLF
								lcCode = lcCode + OFFSET2 + "ASSERT TYPE('lnDim') = 'N' AND BETWEEN(lnDim,1," + ;
								ALLTRIM(STR(loType.laSubscripts[2])) + ") MESSAGE 'Invalid dimension subscript!'" + CRLF
								IF !EMPTY(loType.Assertion)
									lcCode = lcCode + OFFSET2 + loType.Assertion + " MESSAGE 'Wrong datatype or value out of range!'" + CRLF
								ENDIF
							ENDIF
							
							lcCode = lcCode + OFFSET2 + loType.WriteFunc + "(" + THIS.cBase
							lcCode = lcCode + IIF(loType.OffsetOf>0,"+"+ALLTRIM(STR(loType.OffsetOf)),"")							
							lcCode = lcCode + "+(lnDim-1)*" + ALLTRIM(STR(loType.laSubscripts[1] * loType.BaseSize)) + ;
							"+(lnRow-1)*" + ALLTRIM(STR(loType.BaseSize)) + ",lnNewVal)" + CRLF
							lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
							
						OTHERWISE
							lcCode = lcCode + OFFSET1 + "PROCEDURE " + "Set" + loType.cName + "()" + CRLF
							lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
							
					ENDCASE
					
				ENDIF
				
			&& some basic type
			OTHERWISE
				lcCode = lcCode + OFFSET1 + "PROCEDURE " + loType.cName + "_Assign(lnNewVal)" + CRLF
				IF THIS.bAsserts AND !EMPTY(loType.Assertion)
					lcCode = lcCode + OFFSET2 + loType.Assertion + " MESSAGE 'Wrong datatype or value out of range!'" + CRLF
				ENDIF
				lcCode = lcCode + OFFSET2 + loType.Writefunc + "(" + THIS.cBase + ;
				IIF(loType.OffsetOf>0,"+"+ALLTRIM(STR(loType.OffsetOf)),"") + ",lnNewVal)" + CRLF
				lcCode = lcCode + OFFSET1 + "ENDPROC" + CRLF + CRLF
				
		ENDCASE
		
	ENDPROC
	
	PROCEDURE CreateClassFooter(lcCode)
		lcCode = lcCode + "ENDDEFINE" + CRLF + CRLF		
	ENDPROC
	
	PROCEDURE CreateEnumCode(loType,lcCode)
		
		LOCAL xj
		FOR xj = 1 TO ALEN(loType.laMembers)
			lcCode = lcCode + "#DEFINE "
			IF THIS.bEnumUCase
				lcCode = lcCode + UPPER(loType.laMembers[xj].cName)
			ELSE
				lcCode = lcCode + loType.laMembers[xj].cName
			ENDIF
			IF THIS.bEnumHexa
				lcCode = lcCode + OFFSET1 + TRANSFORM(loType.laMembers[xj].ValueOf,'@0') + CRLF
			ELSE
				lcCode = lcCode + OFFSET1 + ALLTRIM(STR(loType.laMembers[xj].ValueOf)) + CRLF
			ENDIF
		ENDFOR
	
	ENDPROC
	
ENDDEFINE


DEFINE CLASS oCSharpCodeGen AS oCodeGen

	nMarshalType = 1 && 1 = struct, 2 = class, 3 = class with manual marshaling
	bOffsets = .F. && output explicit field offsets
	cMemberScope = "public"
	cStringType = "Ansi"
	
	&& main entry point for code creation
	PROCEDURE CreateCode(loType)

		LOCAL lcCode, xj, lnMainDeclar

		lcCode = ""
		
		IF loType.nType = TT_ENUMHEADER
			&&THIS.CreateEnumCode(loType,@lcCode)
			RETURN lcCode
		ENDIF

		SET STEP ON

		THIS.bOffsets = THIS.TypeHasUnions(loType)
		
		lnMainDeclar = THIS.MainDeclarator(loType)
		
		THIS.CreateClassHeader(loType,@lcCode,lnMainDeclar)

		DO CASE
			CASE INLIST(THIS.nMarshalType,1,2)
				THIS.CreateMembers(loType,@lcCode)
			CASE THIS.nMarshalType = 3
				THIS.CreateClassMethods(loType,@lcCode,lnMainDeclar)
				THIS.CreateMembersMarshal(loType,@lcCode)
			CASE THIS.nMarshalType = 4
				THIS.CreateMembersUnsafe(loType,@lcCode)
		ENDCASE

		THIS.CreateClassFooter(@lcCode)

		RETURN lcCode
	ENDPROC

	PROCEDURE CreateClassHeader(loType,lcCode,lnIndex)

		IF INLIST(THIS.nMarshalType,1,2)

			IF THIS.bOffsets
				lcCode = "[StructLayout(LayoutKind.Explicit, Size = " + ALLTRIM(STR(loType.laDeclar[lnIndex].SizeOf))
			ELSE
				lcCode = "[StructLayout(LayoutKind.Sequential, Pack = " + ALLTRIM(STR(THIS.nPragmaPack))
			ENDIF

			IF THIS.TypeHasPointerMember(loType,TM_CHAR+TM_WCHAR) OR ;
				THIS.TypeHasArrayMember(loType,TM_CHAR+TM_WCHAR)
				lcCode = lcCode + ", CharSet = CharSet."
				DO CASE
					CASE THIS.nCharSet = 1
						lcCode = lcCode + "Ansi"
					CASE THIS.nCharSet = 2
						lcCode = lcCode + "Unicode"
					OTHERWISE
						lcCode = lcCode + "Auto"
				ENDCASE
			ENDIF
			
			lcCode = lcCode + ")]" + CRLF
			
		ENDIF
		
		IF THIS.nMarshalType = 1
			lcCode = lcCode + "public struct " + loType.laDeclar[lnIndex].cName + CRLF + "{" + CRLF
		ELSE
			lcCode = lcCode + "public class " + loType.laDeclar[lnIndex].cName + CRLF + "{" + CRLF
		ENDIF
			
	ENDPROC
	
	PROCEDURE CreateClassFooter(lcCode)
		lcCode = lcCode + "}" + CRLF + CRLF		
	ENDPROC
	
	PROCEDURE CreateClassMethods(loType,lcCode,lnIndex)
	
		lcCode = lcCode + OFFSET1 + "IntPtr Address;" + CRLF		
		IF THIS.bArraySupport 
			lcCode = lcCode + OFFSET1 + "IntPtr Offset;" + CRLF
		ENDIF
		lcCode = lcCode + OFFSET1 + "public int SizeOf = " + ALLTRIM(STR(loType.SizeOf)) + ";" + CRLF + CRLF

		&& cast operator from IntPtr overload
		lcCode = lcCode + OFFSET1 + "public static implicit operator " + loType.laDeclar[lnIndex].cName + "(IntPtr pAddress)" + CRLF
		lcCode = lcCode + OFFSET1 + "{" + CRLF
		lcCode = lcCode + OFFSET2 + "return new " + loType.laDeclar[lnIndex].cName + "(pAddress);" + CRLF
		lcCode = lcCode + OFFSET1 + "}" + CRLF + CRLF

		&& cast operator to IntPtr overload
		lcCode = lcCode + OFFSET1 + "public static implicit operator IntPtr(" + loType.laDeclar[lnIndex].cName + " oObject)" + CRLF
		lcCode = lcCode + OFFSET1 + "{" + CRLF
		IF !THIS.bArraySupport
			lcCode = lcCode + OFFSET2 + "return oObject.Address;" + CRLF
		ELSE
			lcCode = lcCode +OFFSET2 + "return oObject.Offset;" + CRLF
		ENDIF
		lcCode = lcCode + OFFSET1 + "}" + CRLF + CRLF
		
		&& cast operator IntPtr + 
		lcCode = lcCode + OFFSET1 + "public static IntPtr operator +(" + loType.laDeclar[lnIndex].cName + " oObject, int ofs)" + CRLF
		lcCode = lcCode + OFFSET1 + "{" + CRLF
		lcCode = lcCode + OFFSET2 + "return (IntPtr)((long)oObject.Address+ofs);" + CRLF
		lcCode = lcCode + OFFSET1 + "}" + CRLF + CRLF
		
		DO CASE
		
			CASE THIS.nAllocScheme = 1 && responsible for memory management
		
				DO CASE
				
					CASE !THIS.bBufferStruct AND !THIS.bArraySupport
				
						&& Constructor
						lcCode = lcCode + OFFSET1 + "public " + loType.laDeclar[lnIndex].cName + "()" + CRLF
						lcCode = lcCode + OFFSET1 + "{" + CRLF
						lcCode = lcCode + OFFSET2 + "this.Address = Marshal.AllocHGlobal(this.SizeOf);" + CRLF
						lcCode = lcCode + OFFSET2 + "MarshalEx.ZeroMemory(this,this.SizeOf);" + CRLF
						lcCode = lcCode + OFFSET1 + "}" + CRLF + CRLF
						
						&& Destructor
						lcCode = lcCode + OFFSET1 + "public ~" + loType.laDeclar[lnIndex].cName + "()" + CRLF
						lcCode = lcCode + OFFSET1 + "{" + CRLF
						lcCode = lcCode + OFFSET2 + "if (this.Address != IntPtr.Zero)" + CRLF
						lcCode = lcCode + OFFSET3 + "Marshal.FreeHGlobal(this);" + CRLF
						lcCode = lcCode + OFFSET1 + "}" + CRLF + CRLF

					CASE THIS.bBufferStruct OR !THIS.bArraySupport
					
						&& Destructor
						lcCode = lcCode + OFFSET1 + "public ~" + loType.laDeclar[lnIndex].cName + "()" + CRLF
						lcCode = lcCode + OFFSET1 + "{" + CRLF
						lcCode = lcCode + OFFSET2 + "if (this.Address != IntPtr.Zero)" + CRLF
						lcCode = lcCode + OFFSET3 + "Marshal.FreeHGlobal(this);" + CRLF
						lcCode = lcCode + OFFSET1 + "}" + CRLF + CRLF

						&& BufferSize member
						lcCode = lcCode + OFFSET1 + "public int BufferSize" + CRLF
						lcCode = lcCode + OFFSET1 + "{" + CRLF
						lcCode = lcCode + OFFSET2 + "set" + CRLF
						lcCode = lcCode + OFFSET2 + "{" + CRLF
						lcCode = lcCode + OFFSET3 + "if (this.Address == IntPtr.Zero)" + CRLF
						lcCode = lcCode + OFFSET4 + "this.Address = Marshal.AllocHGlobal(value);" + CRLF
						lcCode = lcCode + OFFSET3 + "else" + CRLF
						lcCode = lcCode + OFFSET4 + "this.Address = Marshal.ReAllocHGlobal(this,value);" + CRLF
						lcCode = lcCode + OFFSET2 + "}" + CRLF
						lcCode = lcCode + OFFSET1 + "}" + CRLF
						
				CASE !THIS.bBufferStruct OR THIS.bArraySupport

*!*							&& Indexer
*!*							lcCode = lcCode + OFFSET1 + "public " + loType.laDeclar[lnIndex].cName + " this["

			ENDCASE
			
				

*!*		~POINT()
*!*		{
*!*			if (!this.Embedded && this.Address != IntPtr.Zero)
*!*				Marshal.FreeHGlobal(this.Address);
*!*		}
		
*!*		public POINT()
*!*		{
*!*			this.Address = Marshal.AllocHGlobal(this.SizeOf);
*!*			MarshalEx.ZeroMemory(this.Address,this.SizeOf);
*!*		}

*!*		public POINT(IntPtr pAddress)
*!*		{
*!*			this.Address = pAddress;
*!*			this.Embedded = true;
*!*		}

*!*		public POINT(IntPtr pAddress, int ofs)
*!*		{
*!*			this.Address = (IntPtr)((long)pAddress+ofs);
*!*			this.Embedded = true;
*!*		}


			
			CASE THIS.nAllocScheme = 2 && not responsible for memory management
			
			
			
			CASE THIS.nAllocScheme = 3 && context dependent
			*!*		bool Embedded = false;
				
		
		ENDCASE
	
	
	
	
	ENDPROC
	
	PROCEDURE CreateMembers(loType,lcCode)
		
		IF INLIST(loType.nType,TT_STRUCTHEADER,TT_UNIONHEADER)
			LOCAL xj
			FOR xj = 1 TO ALEN(loType.laMembers)
				THIS.CreateMembers(loType.laMembers[xj],@lcCode)
			ENDFOR
			RETURN
		ENDIF
		
		DO CASE
			CASE BITAND(loType.Typemask,TM_CHAR+TM_WCHAR) > 0

				IF loType.bArray
					IF ALEN(loType.laSubscripts) = 1
						lcCode = lcCode + OFFSET1 + "[MarshalAs(UnmanagedType.ByValTStr, SizeConst = " + ALLTRIM(STR(loType.laSubscripts[1])) + ")]" + CRLF
					ELSE
						lcCode = lcCode + OFFSET1 + "[.NET MARSHALING NOT AVAILABLE - use custom marshaling!]" + CRLF
					ENDIF
				ENDIF

			CASE BITAND(loType.Typemask,TM_INT8+TM_SHORT+TM_INT+TM_INT64+TM_LONG+TM_FLOAT+TM_DOUBLE+TM_VOID) > 0

				IF loType.bArray
					DO CASE
						CASE ALEN(loType.laSubscripts) = 1
							lcCode = lcCode + OFFSET1 + "[MarshalAs(UnmanagedType.ByValArray, SizeConst = " + ALLTRIM(STR(loType.laSubscripts[1])) + ")]" + CRLF
						CASE ALEN(loType.laSubscripts) = 2
							lcCode = lcCode + OFFSET1 + "[MarshalAs(UnmanagedType.ByValArray, SizeConst = " + ALLTRIM(STR(loType.laSubscripts[1]*loType.laSubscripts[2])) + ")]" + CRLF
						OTHERWISE
							lcCode = lcCode + OFFSET1 + "[.NET MARSHALING NOT AVAILABLE - use custom marshaling!]" + CRLF
					ENDCASE
				ENDIF

			CASE loType.Typemask = TM_STRUCT
				IF loType.Indirect = 1
					lcCode = lcCode + OFFSET1 + "[MarshalAs(UnmanagedType.LPStruct)]" + CRLF
				ENDIF			
			
		ENDCASE
		
		lcCode = lcCode + OFFSET1
		IF THIS.bOffsets
			lcCode = lcCode + "[FieldOffset(" + ALLTRIM(STR(loType.OffsetOf)) + ")] "
		ENDIF

		lcCode = lcCode + THIS.cMemberScope + " " + loType.CSharpType + " " + loType.cName + ";" + CRLF
	
	ENDPROC		

	PROCEDURE CreateMembersMarshal(loType,lcCode)
	
		IF INLIST(loType.nType,TT_STRUCTHEADER,TT_UNIONHEADER)
			LOCAL xj
			FOR xj = 1 TO ALEN(loType.laMembers)
				THIS.CreateMembersMarshal(loType.laMembers[xj],@lcCode)
			ENDFOR
			RETURN
		ENDIF

		&& get & set methods
		DO CASE
			CASE BITAND(loType.Typemask,TM_CHAR+TM_WCHAR) > 0
				
				DO CASE
					CASE loType.Indirect = 0
					
						DO CASE
							CASE loType.bArray AND ALEN(loType.laSubscripts) = 1

								lcCode = lcCode + OFFSET1 + "public " + loType.CSharpType + " " + loType.cName + CRLF + OFFSET1 + "{" + CRLF
								&& GET method
								lcCode = lcCode + OFFSET2 + "get { return MarshalEx." + loType.MarshalGet
								IF loType.OffsetOf > 0
									lcCode = lcCode + "this+" + ALLTRIM(STR(loType.OffsetOf)) + "); }" + CRLF
								ELSE
									lcCode = lcCode + "(this); }" + CRLF
								ENDIF

								&& SET method
								lcCode = lcCode + OFFSET2 + "set { MarshalEx." + loType.MarshalSet + "(this"
								IF loType.OffsetOf > 0
									lcCode = lcCode + "," + ALLTRIM(STR(loType.OffsetOf))
								ENDIF

								lcCode = lcCode + ",value," + ALLTRIM(STR(loType.laSubscripts[1])) + "); }" + CRLF
								lcCode = lcCode + OFFSET1 + "}" + CRLF
							
							CASE loType.bArray AND ALEN(loType.laSubscripts) = 2
							
							
							

							OTHERWISE
							
							
						ENDCASE

					CASE loType.Indirect = 1
					
						&& if string pointer type we need an IntPtr to store memory allocation
						lcCode = lcCode + OFFSET1 + "IntPtr _" + loType.cName + " = IntPtr.Zero;" + CRLF
						&& marshaling string pointer? handle specific types (ansi, unicode, auto ..)
						lcCode = lcCode + THIS.StringType(loType)
						IF loType.OffsetOf = 0
							lcCode = lcCode + "(this)" 
						ELSE
							lcCode = lcCode + "(this+" + ALLTRIM(STR(loType.OffsetOf)) + ")"
						ENDIF
						lcCode = lcCode + "; }" + CRLF
						
						
					OTHERWISE
					
					
					
				
				ENDCASE

			CASE BITAND(loType.Typemask,TM_INT8+TM_SHORT+TM_INT+TM_INT64+TM_LONG+TM_FLOAT+TM_DOUBLE+TM_VOID+TM_BYTE) > 0
			
				lcCode = lcCode + OFFSET1 + "public " + loType.CSharpType + " " + loType.cName + CRLF + OFFSET1 + "{" + CRLF
				&& GET method			
				lcCode = lcCode + OFFSET2 + "get { return "
				&& cast needed?
				IF BITAND(loType.Typemask,TM_UNSIGNED) > 0
					lcCode = lcCode + "(" + loType.CSharpType + ")"
				ENDIF
				lcCode = lcCode + "Marshal." + loType.MarshalGet + "(this"
				lcCode = lcCode + IIF(loType.OffsetOf=0, "" , "," + ALLTRIM(STR(loType.OffsetOf)))
				lcCode = lcCode + "); }" + CRLF


				&& SET method
				lcCode = lcCode + OFFSET2 + "set { Marshal." + loType.MarshalSet
				lcCode = lcCode + "(this" + IIF(loType.OffsetOf=0, "," , "," + ALLTRIM(STR(loType.OffsetOf)) + ",")
			
				&& cast needed
				IF BITAND(loType.Typemask,TM_UNSIGNED) > 0
					lcCode = lcCode + "(" + SUBSTR(loType.CSharpType,2) + ")"
				ENDIF
				lcCode = lcCode + "value); }" + CRLF + OFFSET1 + "}" + CRLF
		

			CASE loType.Typemask = TM_STRUCT
	
				lcCode = lcCode + OFFSET1 + "public " + loType.CSharpType + " " + loType.cName + ";" + CRLF
		
		ENDCASE
		

	ENDPROC
	
	PROCEDURE CreateMembersUnsafe(loType,lcCode)
	
		IF INLIST(loType.nType,TT_STRUCTHEADER,TT_UNIONHEADER)
			LOCAL xj
			FOR xj = 1 TO ALEN(loType.laMembers)
				THIS.CreateMembersUnsafe(loType.laMembers[xj],@lcCode)
			ENDFOR
			RETURN
		ENDIF
		
	ENDPROC
	
	PROCEDURE StringType(loType)
		DO CASE
			CASE BITAND(loType.Typemask,TM_CHAR) > 0
				RETURN "Ansi"
			CASE BITAND(loType.Typemask,TM_WCHAR) > 0
				RETURN "Uni"
			OTHERWISE
				RETURN "Auto"
		ENDCASE
	ENDPROC

ENDDEFINE


