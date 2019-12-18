* ADOVFP.h
*
*--------------------------------------------------------------------
* Microsoft ADO
*
* (c) 1998 Microsoft Corporation.  All Rights Reserved.
*
*
*
* ADO constants include file for Visual FoxPro
*
*--------------------------------------------------------------------

*---- CursorTypeEnum Values ----
#DEFINE ADOPENFORWARDONLY		0
#DEFINE ADOPENKEYSET			1
#DEFINE ADOPENDYNAMIC			2
#DEFINE ADOPENSTATIC			3

*---- CursorOptionEnum Values ----
#DEFINE ADHOLDRECORDS		0x00000100
#DEFINE ADMOVEPREVIOUS		0x00000200
#DEFINE ADADDNEW			0x01000400
#DEFINE ADDELETE			0x01000800
#DEFINE ADUPDATE			0x01008000
#DEFINE ADBOOKMARK			0x00002000
#DEFINE ADAPPROXPOSITION	0x00004000
#DEFINE ADUPDATEBATCH		0x00010000
#DEFINE ADRESYNC			0x00020000
#DEFINE ADNOTIFY			0x00040000

*---- LockTypeEnum Values ----
#DEFINE ADLOCKREADONLY			1
#DEFINE ADLOCKPESSIMISTIC		2
#DEFINE ADLOCKOPTIMISTIC		3
#DEFINE ADLOCKBATCHOPTIMISTIC	4

*---- ExecuteOptionEnum Values ----
#DEFINE ADRUNASYNC		0x00000010

*---- ObjectStateEnum Values ----
#DEFINE ADSTATECLOSED		0x00000000
#DEFINE ADSTATEOPEN			0x00000001
#DEFINE ADSTATECONNECTING	0x00000002
#DEFINE ADSTATEEXECUTING	0x00000004

*---- CursorLocationEnum Values ----
#DEFINE ADUSESERVER		2
#DEFINE ADUSECLIENT		3

*---- DataTypeEnum Values ----
#DEFINE ADEMPTY					0
#DEFINE ADTINYINT				16
#DEFINE ADSMALLINT				2
#DEFINE ADINTEGER				3
#DEFINE ADBIGINT				20
#DEFINE ADUNSIGNEDTINYINT		17
#DEFINE ADUNSIGNEDSMALLINT		18
#DEFINE ADUNSIGNEDINT			19
#DEFINE ADUNSIGNEDBIGINT		21
#DEFINE ADSINGLE				4
#DEFINE ADDOUBLE				5
#DEFINE ADCURRENCY				6
#DEFINE ADDECIMAL				14
#DEFINE ADNUMERIC				131
#DEFINE ADBOOLEAN				11
#DEFINE ADERROR					10
#DEFINE ADUSERDEFINED			132
#DEFINE ADVARIANT				12
#DEFINE ADIDISPATCH				9
#DEFINE ADIUNKNOWN				13
#DEFINE ADGUID					72
#DEFINE ADDATE					7
#DEFINE ADDBDATE				133
#DEFINE ADDBTIME				134
#DEFINE ADDBTIMESTAMP			135
#DEFINE ADBSTR					8
#DEFINE ADCHAR					129
#DEFINE ADVARCHAR				200
#DEFINE ADLONGVARCHAR			201
#DEFINE ADWCHAR					130
#DEFINE ADVARWCHAR				202
#DEFINE ADLONGVARWCHAR			203
#DEFINE ADBINARY				128
#DEFINE ADVARBINARY				204
#DEFINE ADLONGVARBINARY			205
#DEFINE ADCHAPTER				136

*---- FieldAttributeEnum Values ----
#DEFINE ADFLDMAYDEFER			0x00000002
#DEFINE ADFLDUPDATABLE			0x00000004
#DEFINE ADFLDUNKNOWNUPDATABLE	0x00000008
#DEFINE ADFLDFIXED				0x00000010
#DEFINE ADFLDISNULLABLE			0x00000020
#DEFINE ADFLDMAYBENULL			0x00000040
#DEFINE ADFLDLONG				0x00000080
#DEFINE ADFLDROWID				0x00000100
#DEFINE ADFLDROWVERSION			0x00000200
#DEFINE ADFLDCACHEDEFERRED		0x00001000

*---- EditModeEnum Values ----
#DEFINE ADEDITNONE				0x0000
#DEFINE ADEDITINPROGRESS		0x0001
#DEFINE ADEDITADD				0x0002
#DEFINE ADEDITDELETE			0x0004

*---- RecordStatusEnum Values ----
#DEFINE ADRECOK						0x0000000
#DEFINE ADRECNEW					0x0000001
#DEFINE ADRECMODIFIED				0x0000002
#DEFINE ADRECDELETED				0x0000004
#DEFINE ADRECUNMODIFIED				0x0000008
#DEFINE ADRECINVALID				0x0000010
#DEFINE ADRECMULTIPLECHANGES		0x0000040
#DEFINE ADRECPENDINGCHANGES			0x0000080
#DEFINE ADRECCANCELED				0x0000100
#DEFINE ADRECCANTRELEASE			0x0000400
#DEFINE ADRECCONCURRENCYVIOLATION	0x0000800
#DEFINE ADRECINTEGRITYVIOLATION		0x0001000
#DEFINE ADRECMAXCHANGESEXCEEDED		0x0002000
#DEFINE ADRECOBJECTOPEN				0x0004000
#DEFINE ADRECOUTOFMEMORY			0x0008000
#DEFINE ADRECPERMISSIONDENIED		0x0010000
#DEFINE ADRECSCHEMAVIOLATION		0x0020000
#DEFINE ADRECDBDELETED				0x0040000

*---- GetRowsOptionEnum Values ----
#DEFINE ADGETROWSREST		-1

*---- PositionEnum Values ----
#DEFINE ADPOSUNKNOWN	-1
#DEFINE ADPOSBOF		-2
#DEFINE ADPOSEOF		-3

*---- BookmarkConstants Values ----
#DEFINE ADBOOKMARKCURRENT	0.0
#DEFINE ADBOOKMARKFIRST		1.0
#DEFINE ADBOOKMARKLAST		2.0

*---- MarshalOptionsEnum Values ----
#DEFINE ADMARSHALALL			0
#DEFINE ADMARSHALMODIFIEDONLY	1

*---- AffectEnum Values ----
#DEFINE ADAFFECTCURRENT		1
#DEFINE ADAFFECTGROUP		2
#DEFINE ADAFFECTALL			3

*---- FilterGroupEnum Values ----
#DEFINE ADFILTERNONE				0
#DEFINE ADFILTERPENDINGRECORDS		1
#DEFINE ADFILTERAFFECTEDRECORDS		2
#DEFINE ADFILTERFETCHEDRECORDS		3
#DEFINE ADFILTERPREDICATE			4

*---- SearchDirectionEnum Values ----
#DEFINE ADSEARCHFORWARD		1
#DEFINE ADSEARCHBACKWARD	-1

*---- PersistFormatEnum Values ----
#DEFINE ADPERSISTADTG		0
#DEFINE ADPERSISTXML		1
#DEFINE ADPERSISTHTML		2

*---- SaveOptionEnum Values ----
#DEFINE ADSAVEOVERWRITE		0
#DEFINE ADSAVEFAILIFEXIST		

*---- ConnectPromptEnum Values ----
#DEFINE ADPROMPTALWAYS				1
#DEFINE ADPROMPTCOMPLETE			2
#DEFINE ADPROMPTCOMPLETEREQUIRED	3
#DEFINE ADPROMPTNEVER				4

*---- ConnectModeEnum Values ----
#DEFINE ADMODEUNKNOWN			0
#DEFINE ADMODEREAD				1
#DEFINE ADMODEWRITE				2
#DEFINE ADMODEREADWRITE			3
#DEFINE ADMODESHAREDENYREAD		4
#DEFINE ADMODESHAREDENYWRITE	8
#DEFINE ADMODESHAREEXCLUSIVE	0xC
#DEFINE ADMODESHAREDENYNONE		0x10

*---- IsolationLevelEnum Values ----
#DEFINE ADXACTUNSPECIFIED		0xFFFFFFFF
#DEFINE ADXACTCHAOS				0x00000010
#DEFINE ADXACTREADUNCOMMITTED	0x00000100
#DEFINE ADXACTBROWSE			0x00000100
#DEFINE ADXACTCURSORSTABILITY	0x00001000
#DEFINE ADXACTREADCOMMITTED		0x00001000
#DEFINE ADXACTREPEATABLEREAD	0x00010000
#DEFINE ADXACTSERIALIZABLE		0x00100000
#DEFINE ADXACTISOLATED			0x00100000

*---- XactAttributeEnum Values ----
#DEFINE ADXACTCOMMITRETAINING	0x00020000
#DEFINE ADXACTABORTRETAINING	0x00040000

*---- PropertyAttributesEnum Values ----
#DEFINE ADPROPNOTSUPPORTED		0x0000
#DEFINE ADPROPREQUIRED			0x0001
#DEFINE ADPROPOPTIONAL			0x0002
#DEFINE ADPROPREAD				0x0200
#DEFINE ADPROPWRITE				0x0400

*---- ErrorValueEnum Values ----
#DEFINE ADERRINVALIDARGUMENT		0xBB9
#DEFINE ADERRNOCURRENTRECORD		0xBCD
#DEFINE ADERRILLEGALOPERATION		0xC93
#DEFINE ADERRINTRANSACTION			0xCAE
#DEFINE ADERRFEATURENOTAVAILABLE	0xCB3
#DEFINE ADERRITEMNOTFOUND			0xCC1
#DEFINE ADERROBJECTINCOLLECTION		0xD27
#DEFINE ADERROBJECTNOTSET			0xD5C
#DEFINE ADERRDATACONVERSION			0xD5D
#DEFINE ADERROBJECTCLOSED			0xE78
#DEFINE ADERROBJECTOPEN				0xE79
#DEFINE ADERRPROVIDERNOTFOUND		0xE7A
#DEFINE ADERRBOUNDTOCOMMAND			0xE7B
#DEFINE ADERRINVALIDPARAMINFO		0xE7C
#DEFINE ADERRINVALIDCONNECTION		0xE7D
#DEFINE ADERRNOTREENTRANT			0xE7E
#DEFINE ADERRSTILLEXECUTING			0xE7F
#DEFINE ADERROPERATIONCANCELLED		0xE80
#DEFINE ADERRSTILLCONNECTING		0xE81
#DEFINE ADERRINVALIDTRANSACTION		0xE82

*---- ParameterAttributesEnum Values ----
#DEFINE ADPARAMSIGNED		0x0010
#DEFINE ADPARAMNULLABLE		0x0040
#DEFINE ADPARAMLONG			0x0080

*---- ParameterDirectionEnum Values ----
#DEFINE ADPARAMUNKNOWN		0x0000
#DEFINE ADPARAMINPUT		0x0001
#DEFINE ADPARAMOUTPUT		0x0002
#DEFINE ADPARAMINPUTOUTPUT	0x0003
#DEFINE ADPARAMRETURNVALUE	0x0004

*---- CommandTypeEnum Values ----
#DEFINE ADCMDUNKNOWN		0x0008
#DEFINE ADCMDTEXT			0x0001
#DEFINE ADCMDTABLE			0x0002
#DEFINE ADCMDSTOREDPROC		0x0004
#DEFINE ADCMDFILE			0x0020

*---- EventStatusEnum Values ----
#DEFINE ADSTATUSOK				0x0000001
#DEFINE ADSTATUSERRORSOCCURRED	0x0000002
#DEFINE ADSTATUSCANTDENY		0x0000003
#DEFINE ADSTATUSCANCEL			0x0000004
#DEFINE ADSTATUSUNWANTEDEVENT	0x0000005

*---- EventReasonEnum Values ----
#DEFINE ADRSNADDNEW			1
#DEFINE ADRSNDELETE			2
#DEFINE ADRSNUPDATE			3
#DEFINE ADRSNUNDOUPDATE		4
#DEFINE ADRSNUNDOADDNEW		5
#DEFINE ADRSNUNDODELETE		6
#DEFINE ADRSNREQUERY		7
#DEFINE ADRSNRESYNCH		8
#DEFINE ADRSNCLOSE			9
#DEFINE ADRSNMOVE			10
#DEFINE ADRSNFIRSTCHANGE	11
#DEFINE ADRSNMOVEFIRST		12
#DEFINE ADRSNMOVENEXT		13
#DEFINE ADRSNMOVEPREVIOUS	14
#DEFINE ADRSNMOVELAST		15

*---- SchemaEnum Values ----
#DEFINE ADSCHEMAPROVIDERSPECIFIC		-1
#DEFINE ADSCHEMAASSERTS					0
#DEFINE ADSCHEMACATALOGS				1
#DEFINE ADSCHEMACHARACTERSETS			2
#DEFINE ADSCHEMACOLLATIONS				3
#DEFINE ADSCHEMACOLUMNS					4
#DEFINE ADSCHEMACHECKCONSTRAINTS		5
#DEFINE ADSCHEMACONSTRAINTCOLUMNUSAGE	6
#DEFINE ADSCHEMACONSTRAINTTABLEUSAGE	7
#DEFINE ADSCHEMAKEYCOLUMNUSAGE			8
#DEFINE ADSCHEMAREFERENTIALCONTRAINTS	9
#DEFINE ADSCHEMATABLECONSTRAINTS		10
#DEFINE ADSCHEMACOLUMNSDOMAINUSAGE		11
#DEFINE ADSCHEMAINDEXES					12
#DEFINE ADSCHEMACOLUMNPRIVILEGES		13
#DEFINE ADSCHEMATABLEPRIVILEGES			14
#DEFINE ADSCHEMAUSAGEPRIVILEGES			15
#DEFINE ADSCHEMAPROCEDURES				16
#DEFINE ADSCHEMASCHEMATA				17
#DEFINE ADSCHEMASQLLANGUAGES			18
#DEFINE ADSCHEMASTATISTICS				19
#DEFINE ADSCHEMATABLES					20
#DEFINE ADSCHEMATRANSLATIONS			21
#DEFINE ADSCHEMAPROVIDERTYPES			22
#DEFINE ADSCHEMAVIEWS					23
#DEFINE ADSCHEMAVIEWCOLUMNUSAGE			24
#DEFINE ADSCHEMAVIEWTABLEUSAGE			25
#DEFINE ADSCHEMAPROCEDUREPARAMETERS		26
#DEFINE ADSCHEMAFOREIGNKEYS				27
#DEFINE ADSCHEMAPRIMARYKEYS				28
#DEFINE ADSCHEMAPROCEDURECOLUMNS		29
#DEFINE ADSCHEMADBINFOKEYWORDS			30
#DEFINE ADSCHEMADBINFOLITERALS			31
