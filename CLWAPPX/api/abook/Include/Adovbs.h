* Original files: Program Files\Common Files\System\ADO\adovbs.inc
*--------------------------------------------------------------------
* Microsoft ADO
*
* (c) 1996-1998 Microsoft Corporation.  All Rights Reserved.
*
*
*
* ADO #DEFINEs include file for VBScript
*
*--------------------------------------------------------------------

*---- CursorTypeEnum Values ----
#DEFINE adOpenForwardOnly  0
#DEFINE adOpenKeyset  1
#DEFINE adOpenDynamic  2
#DEFINE adOpenStatic  3

*---- CursorOptionEnum Values ----
#DEFINE adHoldRecords  0x00000100
#DEFINE adMovePrevious  0x00000200
#DEFINE adAddNew  0x01000400
#DEFINE adDelete  0x01000800
#DEFINE adUpdate  0x01008000
#DEFINE adBookmark  0x00002000
#DEFINE adApproxPosition  0x00004000
#DEFINE adUpdateBatch  0x00010000
#DEFINE adResync  0x00020000
#DEFINE adNotify  0x00040000
#DEFINE adFind  0x00080000
#DEFINE adSeek  0x00400000
#DEFINE adIndex  0x00800000

*---- LockTypeEnum Values ----
#DEFINE adLockReadOnly  1
#DEFINE adLockPessimistic  2
#DEFINE adLockOptimistic  3
#DEFINE adLockBatchOptimistic  4

*---- ExecuteOptionEnum Values ----
#DEFINE adRunAsync  0x00000010
#DEFINE adAsyncExecute  0x00000010
#DEFINE adAsyncFetch  0x00000020
#DEFINE adAsyncFetchNonBlocking  0x00000040
#DEFINE adExecuteNoRecords  0x00000080

*---- ConnectOptionEnum Values ----
#DEFINE adAsyncConnect  0x00000010

*---- ObjectStateEnum Values ----
#DEFINE adStateClosed  0x00000000
#DEFINE adStateOpen  0x00000001
#DEFINE adStateConnecting  0x00000002
#DEFINE adStateExecuting  0x00000004
#DEFINE adStateFetching  0x00000008

*---- CursorLocationEnum Values ----
#DEFINE adUseServer  2
#DEFINE adUseClient  3

*---- DataTypeEnum Values ----
#DEFINE adEmpty  0
#DEFINE adTinyInt  16
#DEFINE adSmallInt  2
#DEFINE adInteger  3
#DEFINE adBigInt  20
#DEFINE adUnsignedTinyInt  17
#DEFINE adUnsignedSmallInt  18
#DEFINE adUnsignedInt  19
#DEFINE adUnsignedBigInt  21
#DEFINE adSingle  4
#DEFINE adDouble  5
#DEFINE adCurrency  6
#DEFINE adDecimal  14
#DEFINE adNumeric  131
#DEFINE adBoolean  11
#DEFINE adError  10
#DEFINE adUserDefined  132
#DEFINE adVariant  12
#DEFINE adIDispatch  9
#DEFINE adIUnknown  13
#DEFINE adGUID  72
#DEFINE adDate  7
#DEFINE adDBDate  133
#DEFINE adDBTime  134
#DEFINE adDBTimeStamp  135
#DEFINE adBSTR  8
#DEFINE adChar  129
#DEFINE adVarChar  200
#DEFINE adLongVarChar  201
#DEFINE adWChar  130
#DEFINE adVarWChar  202
#DEFINE adLongVarWChar  203
#DEFINE adBinary  128
#DEFINE adVarBinary  204
#DEFINE adLongVarBinary  205
#DEFINE adChapter  136
#DEFINE adFileTime  64
#DEFINE adDBFileTime  137
#DEFINE adPropVariant  138
#DEFINE adVarNumeric  139

*---- FieldAttributeEnum Values ----
#DEFINE adFldMayDefer  0x00000002
#DEFINE adFldUpdatable  0x00000004
#DEFINE adFldUnknownUpdatable  0x00000008
#DEFINE adFldFixed  0x00000010
#DEFINE adFldIsNullable  0x00000020
#DEFINE adFldMayBeNull  0x00000040
#DEFINE adFldLong  0x00000080
#DEFINE adFldRowID  0x00000100
#DEFINE adFldRowVersion  0x00000200
#DEFINE adFldCacheDeferred  0x00001000
#DEFINE adFldKeyColumn  0x00008000

*---- EditModeEnum Values ----
#DEFINE adEditNone  0x0000
#DEFINE adEditInProgress  0x0001
#DEFINE adEditAdd  0x0002
#DEFINE adEditDelete  0x0004

*---- RecordStatusEnum Values ----
#DEFINE adRecOK  0x0000000
#DEFINE adRecNew  0x0000001
#DEFINE adRecModified  0x0000002
#DEFINE adRecDeleted  0x0000004
#DEFINE adRecUnmodified  0x0000008
#DEFINE adRecInvalid  0x0000010
#DEFINE adRecMultipleChanges  0x0000040
#DEFINE adRecPendingChanges  0x0000080
#DEFINE adRecCanceled  0x0000100
#DEFINE adRecCantRelease  0x0000400
#DEFINE adRecConcurrencyViolation  0x0000800
#DEFINE adRecIntegrityViolation  0x0001000
#DEFINE adRecMaxChangesExceeded  0x0002000
#DEFINE adRecObjectOpen  0x0004000
#DEFINE adRecOutOfMemory  0x0008000
#DEFINE adRecPermissionDenied  0x0010000
#DEFINE adRecSchemaViolation  0x0020000
#DEFINE adRecDBDeleted  0x0040000

*---- GetRowsOptionEnum Values ----
#DEFINE adGetRowsRest  -1

*---- PositionEnum Values ----
#DEFINE adPosUnknown  -1
#DEFINE adPosBOF  -2
#DEFINE adPosEOF  -3

*---- enum Values ----
#DEFINE adBookmarkCurrent  0
#DEFINE adBookmarkFirst  1
#DEFINE adBookmarkLast  2

*---- MarshalOptionsEnum Values ----
#DEFINE adMarshalAll  0
#DEFINE adMarshalModifiedOnly  1

*---- AffectEnum Values ----
#DEFINE adAffectCurrent  1
#DEFINE adAffectGroup  2
#DEFINE adAffectAll  3
#DEFINE adAffectAllChapters  4

*---- ResyncEnum Values ----
#DEFINE adResyncUnderlyingValues  1
#DEFINE adResyncAllValues  2

*---- CompareEnum Values ----
#DEFINE adCompareLessThan  0
#DEFINE adCompareEqual  1
#DEFINE adCompareGreaterThan  2
#DEFINE adCompareNotEqual  3
#DEFINE adCompareNotComparable  4

*---- FilterGroupEnum Values ----
#DEFINE adFilterNone  0
#DEFINE adFilterPendingRecords  1
#DEFINE adFilterAffectedRecords  2
#DEFINE adFilterFetchedRecords  3
#DEFINE adFilterPredicate  4
#DEFINE adFilterConflictingRecords  5

*---- SearchDirectionEnum Values ----
#DEFINE adSearchForward  1
#DEFINE adSearchBackward  -1

*---- PersistFormatEnum Values ----
#DEFINE adPersistADTG  0
#DEFINE adPersistXML  1

*---- StringFormatEnum Values ----
#DEFINE adStringXML  0
#DEFINE adStringHTML  1
#DEFINE adClipString  2

*---- ConnectPromptEnum Values ----
#DEFINE adPromptAlways  1
#DEFINE adPromptComplete  2
#DEFINE adPromptCompleteRequired  3
#DEFINE adPromptNever  4

*---- ConnectModeEnum Values ----
#DEFINE adModeUnknown  0
#DEFINE adModeRead  1
#DEFINE adModeWrite  2
#DEFINE adModeReadWrite  3
#DEFINE adModeShareDenyRead  4
#DEFINE adModeShareDenyWrite  8
#DEFINE adModeShareExclusive  0xc
#DEFINE adModeShareDenyNone  0x10

*---- IsolationLevelEnum Values ----
#DEFINE adXactUnspecified  0xffffffff
#DEFINE adXactChaos  0x00000010
#DEFINE adXactReadUncommitted  0x00000100
#DEFINE adXactBrowse  0x00000100
#DEFINE adXactCursorStability  0x00001000
#DEFINE adXactReadCommitted  0x00001000
#DEFINE adXactRepeatableRead  0x00010000
#DEFINE adXactSerializable  0x00100000
#DEFINE adXactIsolated  0x00100000

*---- XactAttributeEnum Values ----
#DEFINE adXactCommitRetaining  0x00020000
#DEFINE adXactAbortRetaining  0x00040000

*---- PropertyAttributesEnum Values ----
#DEFINE adPropNotSupported  0x0000
#DEFINE adPropRequired  0x0001
#DEFINE adPropOptional  0x0002
#DEFINE adPropRead  0x0200
#DEFINE adPropWrite  0x0400

*---- ErrorValueEnum Values ----
#DEFINE adErrInvalidArgument  0xbb9
#DEFINE adErrNoCurrentRecord  0xbcd
#DEFINE adErrIllegalOperation  0xc93
#DEFINE adErrInTransaction  0xcae
#DEFINE adErrFeatureNotAvailable  0xcb3
#DEFINE adErrItemNotFound  0xcc1
#DEFINE adErrObjectInCollection  0xd27
#DEFINE adErrObjectNotSet  0xd5c
#DEFINE adErrDataConversion  0xd5d
#DEFINE adErrObjectClosed  0xe78
#DEFINE adErrObjectOpen  0xe79
#DEFINE adErrProviderNotFound  0xe7a
#DEFINE adErrBoundToCommand  0xe7b
#DEFINE adErrInvalidParamInfo  0xe7c
#DEFINE adErrInvalidConnection  0xe7d
#DEFINE adErrNotReentrant  0xe7e
#DEFINE adErrStillExecuting  0xe7f
#DEFINE adErrOperationCancelled  0xe80
#DEFINE adErrStillConnecting  0xe81
#DEFINE adErrNotExecuting  0xe83
#DEFINE adErrUnsafeOperation  0xe84

*---- ParameterAttributesEnum Values ----
#DEFINE adParamSigned  0x0010
#DEFINE adParamNullable  0x0040
#DEFINE adParamLong  0x0080

*---- ParameterDirectionEnum Values ----
#DEFINE adParamUnknown  0x0000
#DEFINE adParamInput  0x0001
#DEFINE adParamOutput  0x0002
#DEFINE adParamInputOutput  0x0003
#DEFINE adParamReturnValue  0x0004

*---- CommandTypeEnum Values ----
#DEFINE adCmdUnknown  0x0008
#DEFINE adCmdText  0x0001
#DEFINE adCmdTable  0x0002
#DEFINE adCmdStoredProc  0x0004
#DEFINE adCmdFile  0x0100
#DEFINE adCmdTableDirect  0x0200

*---- EventStatusEnum Values ----
#DEFINE adStatusOK  0x0000001
#DEFINE adStatusErrorsOccurred  0x0000002
#DEFINE adStatusCantDeny  0x0000003
#DEFINE adStatusCancel  0x0000004
#DEFINE adStatusUnwantedEvent  0x0000005

*---- EventReasonEnum Values ----
#DEFINE adRsnAddNew  1
#DEFINE adRsnDelete  2
#DEFINE adRsnUpdate  3
#DEFINE adRsnUndoUpdate  4
#DEFINE adRsnUndoAddNew  5
#DEFINE adRsnUndoDelete  6
#DEFINE adRsnRequery  7
#DEFINE adRsnResynch  8
#DEFINE adRsnClose  9
#DEFINE adRsnMove  10
#DEFINE adRsnFirstChange  11
#DEFINE adRsnMoveFirst  12
#DEFINE adRsnMoveNext  13
#DEFINE adRsnMovePrevious  14
#DEFINE adRsnMoveLast  15

*---- SchemaEnum Values ----
#DEFINE adSchemaProviderSpecific  -1
#DEFINE adSchemaAsserts  0
#DEFINE adSchemaCatalogs  1
#DEFINE adSchemaCharacterSets  2
#DEFINE adSchemaCollations  3
#DEFINE adSchemaColumns  4
#DEFINE adSchemaCheckConstraints  5
#DEFINE adSchemaConstraintColumnUsage  6
#DEFINE adSchemaConstraintTableUsage  7
#DEFINE adSchemaKeyColumnUsage  8
#DEFINE  adSchemaReferentialConstraints  9
#DEFINE adSchemaTableConstraints  10
#DEFINE adSchemaColumnsDomainUsage  11
#DEFINE adSchemaIndexes  12
#DEFINE adSchemaColumnPrivileges  13
#DEFINE adSchemaTablePrivileges  14
#DEFINE adSchemaUsagePrivileges  15
#DEFINE adSchemaProcedures  16
#DEFINE adSchemaSchemata  17
#DEFINE adSchemaSQLLanguages  18
#DEFINE adSchemaStatistics  19
#DEFINE adSchemaTables  20
#DEFINE adSchemaTranslations  21
#DEFINE adSchemaProviderTypes  22
#DEFINE adSchemaViews  23
#DEFINE adSchemaViewColumnUsage  24
#DEFINE adSchemaViewTableUsage  25
#DEFINE adSchemaProcedureParameters  26
#DEFINE adSchemaForeignKeys  27
#DEFINE adSchemaPrimaryKeys  28
#DEFINE adSchemaProcedureColumns  29
#DEFINE adSchemaDBInfoKeywords  30
#DEFINE adSchemaDBInfoLiterals  31
#DEFINE adSchemaCubes  32
#DEFINE adSchemaDimensions  33
#DEFINE adSchemaHierarchies  34
#DEFINE adSchemaLevels  35
#DEFINE adSchemaMeasures  36
#DEFINE adSchemaProperties  37
#DEFINE adSchemaMembers  38

*---- SeekEnum Values ----
#DEFINE adSeekFirstEQ  0x1
#DEFINE adSeekLastEQ  0x2
#DEFINE adSeekAfterEQ  0x4
#DEFINE adSeekAfter  0x8
#DEFINE adSeekBeforeEQ  0x10
#DEFINE adSeekBefore  0x20

*---- ADCPROP_UPDATECRITERIA_ENUM Values ----
#DEFINE adCriteriaKey  0
#DEFINE adCriteriaAllCols  1
#DEFINE adCriteriaUpdCols  2
#DEFINE adCriteriaTimeStamp  3

*---- ADCPROP_ASYNCTHREADPRIORITY_ENUM Values ----
#DEFINE adPriorityLowest  1
#DEFINE adPriorityBelowNormal  2
#DEFINE adPriorityNormal  3
#DEFINE adPriorityAboveNormal  4
#DEFINE adPriorityHighest  5

*---- CEResyncEnum Values ----
#DEFINE adResyncNone  0
#DEFINE adResyncAutoIncrement  1
#DEFINE adResyncConflicts  2
#DEFINE adResyncUpdates  4
#DEFINE adResyncInserts  8
#DEFINE adResyncAll  15

*---- ADCPROP_AUTORECALC_ENUM Values ----
#DEFINE adRecalcUpFront  0
#DEFINE adRecalcAlways  1

