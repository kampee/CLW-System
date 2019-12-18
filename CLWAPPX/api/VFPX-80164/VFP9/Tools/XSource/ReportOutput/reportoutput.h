* REPORTOUTPUT.APP constants

#INCLUDE FOXPRO_REPORTING.H

#INCLUDE REPORTOUTPUT_LOCS.H

* --- report output user-tunable settings

#DEFINE LISTENER_TYPE_DEBUG  999
#DEFINE LISTENER_TYPE_XML     4
#DEFINE LISTENER_TYPE_HTML    5

#DEFINE OUTPUTAPP_OBJTYPE_LISTENER    100
#DEFINE OUTPUTAPP_OBJTYPE_CONFIG      110 
#DEFINE OUTPUTAPP_OBJCODE_FILTER        1

#DEFINE OUTPUTAPP_ASSIGN_TYPE    .T.

#DEFINE OUTPUTAPP_ASSIGN_OUTPUTTYPE .T.

#DEFINE OUTPUTAPP_DEFAULTCONFIG_AFTER_CONFIGTABLEFAILURE .F.

#DEFINE OUTPUTAPP_XBASELISTENERS_FOR_BASETYPES .T.

#DEFINE OUTPUTAPP_INTERNALDBF   "_ReportOutputConfig"
#DEFINE OUTPUTAPP_EXTERNALDBF   "OutputConfig"

#DEFINE OUTPUTAPP_REFVAR        _oReportOutput
#DEFINE OUTPUTAPP_REFVARCLASS  "Collection"

#DEFINE OUTPUTAPP_CONFIGTOKEN_WRITETABLE  -100
#DEFINE OUTPUTAPP_CONFIGTOKEN_SETTABLE    -200

#DEFINE OUTPUTAPP_BASELISTENER_CLASSLIB "Listener.VCX" 

*&* Sedna:
* #DEFINE OUTPUTAPP_CLASS_PRINTLISTENER    "UpdateListener"
* #DEFINE OUTPUTAPP_CLASS_PREVIEWLISTENER  "UpdateListener"
#DEFINE OUTPUTAPP_CLASS_PRINTLISTENER    "FXListener"
#DEFINE OUTPUTAPP_CLASS_PREVIEWLISTENER  "FXListener"
#DEFINE OUTPUTAPP_CLASS_DEBUGLISTENER    "DebugListener"
#DEFINE OUTPUTAPP_CLASS_UTILITYLISTENER  "UtilityReportListener"
#DEFINE OUTPUTAPP_CLASS_HTMLLISTENER     "HTMLListener"
#DEFINE OUTPUTAPP_CLASS_XMLLISTENER      "XMLListener"

#DEFINE VFP_DEFAULT_DATASESSION 1

#DEFINE OUTPUTAPP_LOADTYPE_DEFAULT 0
#DEFINE OUTPUTAPP_LOADTYPE_UNLOAD 1
#DEFINE OUTPUTAPP_LOADTYPE_RELOAD 2 
* NB any value above 1 is actually reload instruction




  

