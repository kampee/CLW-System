*************************************************************************
*  FTP Services for Visual Foxpro 5.0+                                  *
*  Written by: Robert Abram                                             *
*  Date: Sept 1998                                                      *
*                                                                       *
*  Revision 2.0.4                                                       *
*  Martina Jindrù                                                       *
*  E-mail: jindra@egservis.cz                                           *
*  JID   : gorila@dione.zcu.cz                                          *
*  CP    : 1250                                                         *
*                                                                       *
*  Updated 2006-06-05                                                   *
*   - BITOR support for VFP 5.0                                         *
*                                                                       *
*                                                                       *
*                                                                       *
*  Proxy Support                                                        *
*  Paul Culbertson                                                      *
*  http://www.foxite.com/archives/progress_bar_for_ftps_0000013728.htm  *
*                                                                       *
*                                                                       *
*  RESUME Support                                                       *
*  Zintis Petersons                                                     *
*  http://www.vbip.com/wininet/wininet-ftp-command-01.asp               *
*                                                                       *
*                                                                       *
*  Revision 1.1a                                                        *
*                                                                       *
*  wininet.dll needs to be in the windows/system                        *
*  directory.                                                           *
*                                                                       *
*  Updated 3/16/99 - Changed Date Usage to comply with                  *
*                    Strict Date handling.                              *
*														                *
*  Added 3/16/99 Functions - AutoDialInternet                           *
*                            AutoDialHangUp                             *
*                            DialInternet                               *
*                            DialHangUp                                 *
*                            GetConnectedState                          *
*                            GoOnline                                   *
*************************************************************************
*!*	<pdm_sc_yes/>
*!*	<pdm_dd_yes/>


#IFNDEF __FTP_INCLUDE
   #INCLUDE "FTP.h"
#ENDIF

EXTERNAL ARRAY lnFlag

****************************************************
* Class Ftp_Service                                *
****************************************************
DEFINE CLASS FTP_SERVICE AS custom
   HIDDEN lDLL_Loaded,nResult_Code,nExtended_Result,cExtended_Message,;
          nInet_Handle,nConnect_Handle,lUseProxy,;
          cIPAddress,cUserName,cPassword,cPort,nCachingType,oListPE
             

   cIPAddress 	     = ""   && FTP server name  or IP address
   cUserName         = ""   && FTP User name
   cPassword         = ""   && FTP Password
   cPort			 = "21" && FTP Port (default value is 21)
		
   nInet_Handle 	 = 0   && Internal handle by connected to internet
   nConnect_Handle 	 = 0   && Internal handle by connected to FTP server
   lDLL_Loaded       = .F. && Internally flag of loaded API function
   nResult_Code	     = 0   && FTP API function's result code 
   nExtended_Result  = 0   && Extended error code
   cExtended_Message = ""  && Extended error message
   cCurrentDir		 = ""  && Current folder
		
   nCachingType      = INTERNET_FLAG_DONT_CACHE && Default caching flag

   cAgent 	         = "Visual FoxPro" + cNULL && Name of application

   nFlags            = INTERNET_FLAG_PASSIVE && The default flag for opening FTP session
   lMultiOperations  = .T. && Sign if all FTP operations use one FTP connection
   cStartupFolder    = "" && Startup folder

   cProxyProtocol=""  && Protocol for proxy
   cProxyHost=""      && Proxyhost
   cProxyport=""      && ProxyPort
   lUseProxy = .F.    && Flag of using proxy settings
 
   oListPE=.NULL.      && List parser engine
				
   ****************************************************
   PROTECTED PROCEDURE Init && Constructor of class
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      IF _DOS OR _UNIX OR _MAC
         RETURN .F.
      ENDIF
   ENDPROC	
	
   ****************************************************
   PROTECTED PROCEDURE LoadAPIFuncs && Load basic API functions
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>

      * Check to see if We have already declared functions and loaded the DLL
      IF This.lDLL_Loaded  
         RETURN ERROR_SUCCESS
      ENDIF
		   	
      * Declare a Kernel32 Functions
      DECLARE Integer GetLastError IN Kernel32

      DECLARE Integer FileTimeToSystemTime IN Kernel32 ;
              String @lpcBuffer, String @lpcBuffer
		   
      * Declare DLL functions used by Program
      DECLARE Integer InternetAutodial IN WinInet ;
              Integer nAccessType, Integer nHandle
		   		
      DECLARE Integer InternetAutodialHangup IN WinInet ;
              Integer nFlags
		   			
      DECLARE Integer InternetDial IN WinInet ;
              Integer nHandle, String @lpcDialUp, Integer nAccessType, Integer @nConnect_Handle, ;
              Integer nFlags
		   	
      DECLARE Integer InternetHangUp IN WinInet ;
              Integer nConnect_Handle, Integer nFlags
		   			
      DECLARE Integer InternetGetConnectedState IN WinInet ;
              Integer @nContext, Integer nFlags
		   			
      DECLARE Integer InternetGoOnline IN WinInet ;
              String @lpcURL, Integer nHandle, Integer nFlags
		   			
      DECLARE Integer InternetOpen IN WinInet ;
              String @lpcAgent, Integer nAccessType, String @lpcProxyName, ;
              String @lpcProxyBypass, Integer nFlags
		   			
      DECLARE Integer InternetConnect IN WinInet ;
              Integer nInet_Handle, String @lpcServer, Short nPort, String @lpcUserName, ;
              String @lpcPassword, Integer nService, Integer nFlags, Integer nContext

      DECLARE Integer InternetCloseHandle IN WinInet ;
              Integer nConnect_Handle
		   			
      * FTP Functions
      DECLARE Integer FtpCreateDirectory IN WinInet ;
              Integer nConnect_Handle, String @lpcDirectory
		   			
      DECLARE Integer FtpDeleteFile IN WinInet ;
              Integer nConnect_Handle, String @lpcFileName
		   	
      DECLARE Integer FtpFindFirstFile IN WinInet ;
              Integer nConnect_Handle, String @lpcSearchStr, String @lpcWIN32_FIND_DATA, ;
              Integer nFlags, Integer nContext

      DECLARE Integer InternetFindNextFile IN WinInet ;
              Integer nConnect_Handle, String @lpcWIN32_FIND_DATA
		   			
      DECLARE Integer FtpGetCurrentDirectory IN WinInet ;
              Integer nConnect_Handle, String @lpcDirectory, Integer @nMax_Path
		   
      DECLARE Integer FtpGetFile IN WinInet ;
              Integer nConnect_Handle, String @lpcRemoteFile, String @lpcNewFile, ;
              Integer nFailIfExists, Integer nAttributes, Integer nFlags, ;
              Integer nContext
		   			
      DECLARE Integer FtpOpenFile IN WinInet ;
              Integer nConnect_Handle, String @lpcRemoteFile, Integer nAccessType, ;
              Integer nFlags, Integer nContext
		   			
      DECLARE Integer FtpPutFile IN WinInet ;
              Integer nConnect_Handle, String @lpcNewFile, String @lpcRemoteFile, ;
              Integer nFlags, Integer nContext
		   			
      DECLARE Integer FtpRemoveDirectory IN WinInet ;
              Integer nConnect_Handle, String @lpcDirectory
		   			
      DECLARE Integer FtpRenameFile IN WinInet ;
              Integer nConnect_Handle, String @lpcRemoteFile, String @lpcNewFile
		   			
      DECLARE Integer FtpSetCurrentDirectory IN WinInet ;
              Integer nConnect_Handle, String @lpcDirectory


      DECLARE Integer FtpCommand IN WinInet ;
              Integer hConnect, Integer fExpectResponse,;
              Integer dwFlags, STRING @ lpszCommand,;
              Integer dwContext, Integer @ phFtpCommand


      DECLARE Integer InternetGetLastResponseInfo IN WinInet ;
              Integer @nError, String @lpcBuffer, Integer @nMax_Path


      DECLARE INTEGER InternetWriteFile IN WinInet ;
              INTEGER hFile, STRING @ lpBuffer,;
              INTEGER dwNumberOfBytesToWrite, INTEGER @ lpdwNumberOfBytesWritten

      DECLARE INTEGER InternetReadFile IN WinInet ;
              INTEGER hFile, STRING @ lpBuffer,;
              INTEGER dwNumberOfBytesToWrite, INTEGER @ lpdwNumberOfBytesWritten


      DECLARE InternetQueryOption  IN WinInet ;
              INTEGER hInternet,;
              INTEGER dwOption,;
              INTEGER @ lpBuffer,;
              INTEGER @ lpdwBufferLength


      This.lDLL_Loaded = .T.
		   	
      RETURN ERROR_SUCCESS	
		   		
   ENDPROC


   PROCEDURE IsGlobalOffline() && Return if is internet offline
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL liState
      liState = 0
      lnState = 4

      IF InternetQueryOption(0, INTERNET_OPTION_CONNECTED_STATE, @liState, @lnSize)
         RETURN IIF(BITTEST(liState,4)=1,0,1)
      ENDIF
      RETURN  -1
   ENDPROC
		
   ****************************************************
   PROCEDURE AutoDialInternet(INP lnType) && Automatically dial the default Internet connection
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL lnHWNDHandle, fResult
      IF This.LoadAPIFuncs() != ERROR_SUCCESS
 	      RETURN .F.
      ENDIF	
		   	  
      IF TYPE(lnType) != "N" 
         RETURN .F.
      ENDIF
		   	  
      =This.BeforeAutoDialInternet(lnType)
      lnHWNDHandle = 0	  		
      fResult = InternetAutodial(lnType, lnHWNDHandle)
      =This.GetExtendedError()
      =This.AfterAutoDialInternet(lnType,fResult)
      RETURN fResult # 0 
   ENDPROC

   ****************************************************
   PROCEDURE BeforeAutoDialInternet(INP lnType) && Raised before calling  API function InternetAutoDial()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AfterAutoDialInternet(INP lnType,INP fResult) && Raised after calling  API function InternetAutoDial()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC


   ****************************************************
   PROCEDURE AutoDialHangUp && Closes a modem connection 
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL fResult
      IF This.LoadAPIFuncs() != ERROR_SUCCESS
         RETURN .F.
      ENDIF	
	  		
      =This.BeforeAutoDialHangUp()
      fResult = InternetAutoDialHangUp(0)
      This.GetExtendedError()
      =This.AfterAutoDialHangUp(fResult)
	  		  
      RETURN fResult # 0 
   ENDPROC
	  		  
   ****************************************************
   PROCEDURE BeforeAutoDialHangUp() && Raised before calling  API function InternetAutoDialHangUp()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AfterAutoDialHangUp(INP fResult) && Raised after calling  API function InternetAutoDialHangUp()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC
	  
   ****************************************************	
   PROCEDURE DialInternet(INP lcDialUpName, INP lnFlag) && Attempts to use a preconfigured Dial Up account to connect to the internet
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL fResult, lnConnectionID, lnHWNDHandle
      IF This.LoadAPIFuncs() != ERROR_SUCCESS
         RETURN -1
      ENDIF
  	  		
      STORE 0 TO lnConnectionID,lnHWNDHandle
  	  		    	  		    	  		  
      IF TYPE("lcDialUpName") != "C" OR ;
         TYPE("lnFlag") != "N"
         RETURN -1
      ENDIF
  	  		
      IF LEN(ALLTRIM(lcDialUpName)) = 0 
         RETURN -1
      ENDIF
  	  		  
      lcDialUpName = lcDialUpName + cNULL
      =This.BeforeDialInternet(lcDialUpName, lnFlag)
      fResult = InternetDial(lnHWNDHandle, @lcDialUpName, lnFlag, @lnConnectionID, 0)
      =This.GetExtendedError()
      =This.AfterDialInternet(@lcDialUpName, lnFlag,lnConnectionID,fResult)
      RETURN lnConnectionID
   ENDPROC  

   ****************************************************
   PROCEDURE BeforeDialInternet(INPREF lcDialUpName, INP lnFlag) && Raised before calling  API function InternetDial()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AfterDialInternet(INPREF lcDialUpName, INP lnFlag, INP lnConnectionID, INP fResult) && Raised after calling  API function InternetDial()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC


   ****************************************************
   PROCEDURE DialHangUp(INP lnConnectionID) && Closes a dialup connection
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL fResult
      IF This.LoadAPIFuncs() != ERROR_SUCCESS
         RETURN .F.
      ENDIF
		   	  
      IF TYPE("lnConnectionID") != "N"
         RETURN .F.
      ENDIF
		   	  
      =This.BeforeDialHangUp(lnConnectionID)
      fResult = InternetHangUp(lnConnectionID, 0)
      This.GetExtendedError()
      =This.AfterDialHangUp(lnConnectionID,fResult)
      RETURN fResult # 0 
   ENDPROC

   ****************************************************
   PROCEDURE BeforeDialHangUp(INP lnConnectionID) && Raised before calling  API function InternetHangUp()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AfterDialHangUp(INP lnConnectionID,INP fResult) && Raised after calling  API function InternetHangUp()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

	    
	    
   ****************************************************
   PROCEDURE GetConnectedState && Returns the current type of internet connection
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL fResult, lnConnectionState
			
      IF This.LoadAPIFuncs() != ERROR_SUCCESS
         RETURN -1
      ENDIF
			
      lnConnectionState = 0
		
      =This.BeforeGetConnectedState()
      fResult = InternetGetConnectedState(@lnConnectionState, 0)
      =This.GetExtendedError()
      =This.AfterGetConnectedState(fResult,lnConnectionState)
      RETURN IIF(fResult = 0,-1,lnConnectionState)
   ENDPROC


   ****************************************************
   PROCEDURE BeforeGetConnectedState() && Raised before calling  API function InternetGetConnectedState()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AfterGetConnectedState(INP fResult, INP lnConnectionState) && Raised after calling  API function InternetGetConnectedState()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC
		
			  
   ****************************************************	
   PROCEDURE GoOnline(INP lcURL) && Brings up a dialog to the user requesting permission to go the requested URL
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL lnHWNDHandle, fResult
      IF This.LoadAPIFuncs() != ERROR_SUCCESS
         RETURN .F.
      ENDIF

      IF TYPE("lcURL") != "C"
         RETURN .F.
      ENDIF
	  			
      lcURL = lcURL + cNULL
      lnHWNDHandle = 0
      =This.BeforeGoOnline(@lcURL)
      fResult = InternetGoOnline(@lcURL, lnHWNDHandle, 0)
      =This.GetExtendedError()
      =This.AfterGoOnline(@lcURL,fResult)
      RETURN fResult # 0 
   ENDPROC	


   ****************************************************
   PROCEDURE BeforeGoOnline(INPREF lcURL) && Raised before calling  API function InternetGoOnline()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AfterGoOnline(INPREF lcURL, INP fResult) && Raised after before calling  API function InternetGoOnline()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

		
   ****************************************************
   PROCEDURE OpenInternet(INP lcUserName, INP lcPassword,INP lcIPAddress, INP lcPort, OPT_INP  lnFlag) && Attempts to open a connection to the FTP server
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL lnPCount, fResult,lnConnectHandle,liAccessType,lcProxyBypass,lcProxyName
		   
      * Check Passed Parameters
      lnPCount = PCOUNT()
		   		   
      IF lnPCount < 4
         This.nResult_Code = ERROR_INTERNET_BAD_OPTION_LENGTH
         RETURN .F.
      ENDIF
      lnFlag=IIF(lnPCount<5,0,lnFlag)
		   	
      * Make sure parameters are of the correct type
      IF (TYPE("lcUserName") != "C") OR ;
         (TYPE("lcPassword") != "C") OR ;
         (TYPE("lcIPAddress") != "C") OR ;
         (TYPE("lcPort") != "C")
         This.nResult_Code = ERROR_INVALID_PARAMETER
         RETURN .F.
      ENDIF
		   	
      * Check Parameter Values
      IF EMPTY(lcUserName) OR EMPTY(lcPassword) OR EMPTY(lcIPAddress)
         This.nResult_Code = ERROR_INVALID_PARAMETER
         RETURN .F.
      ENDIF
		   	
      IF This.LoadAPIFuncs() != ERROR_SUCCESS
         RETURN .F.
      ENDIF
		   	
		   	
      * Open Handle to Internet
      * Set Parameters
      This.cUserName = lcUserName + cNULL           && Store FTP Connection information
      This.cPassword = lcPassword + cNULL
      This.cIPAddress = lcIPAddress + cNULL
      This.cPort = lcPort


      IF EMPTY(This.cProxyHost) OR ISNULL(This.cProxyHost)
         lcProxyName = .NULL.
         lcProxyBypass=.NULL.
         liAccessType=IIF(TYPE("lnFlag("+LTRIM(STR(_FTPS_FA_AccessType,11))+")")="N",lnFlag(_FTPS_FA_AccessType),INTERNET_OPEN_TYPE_DIRECT)
         This.lUseProxy = .F.
      ELSE
         *protocol=proxyhost:proxyport
         *ftp=ftp://ftp_proxy_name:21 
         lcProxyName = This.cProxyProtocol+"="+ This.cProxyHost + ":" + ALLTRIM(This.cProxyport) + cNULL
         lcProxyBypass=This.cIPAddress
         liAccessType=INTERNET_OPEN_TYPE_PROXY
         This.lUseProxy = .T.
      ENDIF
		    		    	   		    		   
      This.nInet_Handle = InternetOpen((This.cAgent), liAccessType, @lcProxyName, @lcProxyBypass,lnFlag)
      This.GetExtendedError()
		   	
		   	
      * Unable to Get a Connection into the Internet
      IF This.nInet_Handle = 0
         This.CloseFTPConnection()
         RETURN .F.
      ENDIF
		   
	
      * This Opens the FTP site and Gets the Current Directory.  The handle to the FTP site is opened
      * and closed for each call to any function.	
      * Open FTP Site 
      fResult=This.OpenFTPConnection(This.cStartupFolder)
      =IIF(This.lMultiOperations,.T.,This.CloseFTPConnection())   && Close FTP Handle
      RETURN fResult
   ENDPROC

		
   ****************************************************
   PROCEDURE CloseInternet && Closes any open handles to the Internet
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
 
      * Handles have a Hierarchy.  Closing the Top Handle will close all child handles also.
      * (really?)
      IF This.nInet_Handle != 0
         This.CloseFTPConnection()

         InternetCloseHandle(This.nInet_Handle)
         This.nInet_Handle = 0
         This.cCurrentDir = ""
      ENDIF
   ENDPROC
      


		
   ****************************************************
   PROTECTED PROCEDURE OpenFTPConnection(OPT_INP lcCurrentFolder) && Connect to FTP server
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL nHandle, lnConnect_Handle
      IF This.nConnect_Handle>0 AND .T. && is Valid??
         RETURN .T.
      ENDIF
      * Open FTP Site 
      lnConnect_Handle = InternetConnect(This.nInet_Handle, (This.cIPAddress), VAL(This.cPort), ;
                        (This.cUserName), (This.cPassword), INTERNET_SERVICE_FTP, This.nFlags, 0)
      This.GetExtendedError()
      IF lnConnect_Handle = 0
         RETURN .F.
      ENDIF

      IF PCOUNT()=0 OR EMPTY(lcCurrentFolder)
         lcCurrentFolder = SPACE(MAX_PATH)      
         fResult = FtpGetCurrentDirectory(lnConnect_Handle, @lcCurrentFolder, MAX_PATH)
         This.GetExtendedError()
      ELSE
         fResult = FtpSetCurrentDirectory(lnConnect_Handle, @lcCurrentFolder)
      ENDIF

      IF fResult = 1
         This.cCurrentDir = RTRIM(lcCurrentFolder)
         This.nConnect_Handle = lnConnect_Handle
         RETURN .T.
      ELSE
         This.GetExtendedError()     && Only Get extended Error information when there is an error
         RETURN .F.
      ENDIF
   ENDPROC
		
   ****************************************************
   PROTECTED PROCEDURE CloseFTPConnection && Disconnect from FTP server
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      IF This.nConnect_Handle != 0
         =This.FTPCommand("QUIT",FTP_TRANSFER_TYPE_BINARY,0,.NULL.)
         =InternetCloseHandle(This.nConnect_Handle)
      ENDIF
	    	
      This.nConnect_Handle = 0
      RETURN
   ENDPROC
	    
		
   ****************************************************
   PROCEDURE SetCachingMethod(INP nCachingType) && Changes the current file caching method
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
	
      * only change caching type if we have a valid new cache type
      IF nCachingType = INTERNET_FLAG_DONT_CACHE OR ;
         nCachingType = INTERNET_FLAG_HYPERLINK OR ;
         nCachingType = INTERNET_FLAG_MUST_CACHE_REQUEST OR ;
         nCachingType = INTERNET_FLAG_NEED_FILE OR ;
         nCachingType = INTERNET_FLAG_NO_CACHE_WRITE OR ;
         nCachingType = INTERNET_FLAG_OFFLINE OR ;
         nCachingType = INTERNET_FLAG_RELOAD OR ;
         nCachingType = INTERNET_FLAG_RESYNCHRONIZE
              
         This.nCachingType = BITOR(This.nCachingType,nCachingType)
         RETURN .T.
      ENDIF

      RETURN .F.
   ENDPROC
		
   ****************************************************
   PROCEDURE GetCachingMethod && Returns the current caching method
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      RETURN This.nCachingType
   ENDPROC

   ****************************************************
   PROCEDURE ResetCachingMethod && Reset caching method
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      This.nCachingType=0
   ENDPROC

		 
   ****************************************************
   PROCEDURE GetFTPFile(INP lcRemoteFile, INP lcLocalFile, INP llFailIfExists, INP lnFlag) && Get file from the FTP Server
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL fResult, lnFail
      IF EMPTY(lcRemoteFile)
         This.SetExtendedError(_FTPS_UE_FNDEF,"lcRemoteFile")
         RETURN .F.
      ENDIF
      IF EMPTY(lcLocalFile)
         This.SetExtendedError(_FTPS_UE_FNDEF,"lcLocalFile")
         RETURN .F.
      ENDIF
      lnFlag=IIF(PCOUNT()<4,FTP_TRANSFER_TYPE_UNKNOWN,lnFlag)

      IF This.OpenFTPConnection(This.cCurrentDir)     && Open an FTP Handle
         lnFail=IIF(llFailIfExists,1,0)
		  	  	
         lcLocalFile = lcLocalFile + cNULL
         lcRemoteFile = lcRemoteFile + cNULL
		  	  
         =This.BeforeGetFTPFile(@lcRemoteFile, @lcLocalFile, llFailIfExists,lnFlag)
         fResult = FtpGetFile(This.nConnect_Handle, @lcRemoteFile, @lcLocalFile, lnFail, ;
                              FILE_ATTRIBUTE_NORMAL, BITOR(This.nCachingType,lnFlag), 0)
         =This.GetExtendedError()
         =This.AfterGetFTPFile(@lcRemoteFile, @lcLocalFile, llFailIfExists,lnFlag,fResult)
		  	  	
         =IIF(This.lMultiOperations,.T.,This.CloseFTPConnection())   && Close FTP Handle
		  	  	
         RETURN fResult = 1
      ENDIF
      RETURN .F.
   ENDPROC



   ****************************************************
   PROCEDURE BeforeGetFTPFile(INPREF lcRemoteFile, INPREF lcLocalFile, INP llFailIfExists, INP lnFlag) && Raised before calling  API function FtpGetFile()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AfterGetFTPFile(INPREF lcRemoteFile, INPREF lcLocalFile, INP llFailIfExists, INP lnFlag, INP fResult) && Raised after calling  API function FtpGetFile()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

	  	
   ****************************************************
   PROCEDURE PutFTPFile(INP lcRemoteFile, INP lcLocalFile, INP lnFlag) && Sends a file to the FTP server from some local area
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL fResult
      IF EMPTY(lcRemoteFile)
         This.SetExtendedError(_FTPS_UE_FNDEF,"lcRemoteFile")
         RETURN .F.
      ENDIF
      IF EMPTY(lcLocalFile)
         This.SetExtendedError(_FTPS_UE_FNDEF,"lcLocalFile")
         RETURN .F.
      ENDIF
      lnFlag=IIF(PCOUNT()<3,FTP_TRANSFER_TYPE_UNKNOWN,lnFlag)
      IF This.OpenFTPConnection(This.cCurrentDir)     && Open an FTP Handle
         lcRemoteFile = lcRemoteFile + cNULL
         lcLocalFile = lcLocalFile + cNULL
		  	  	  	  	
         =This.BeforePutFTPFile(@lcRemoteFile, @lclocalFile,lnFlag)
         fResult = FtpPutFile(This.nConnect_Handle, @lcLocalFile, @lcRemoteFile, ;
                              BITOR(This.nCachingType,lnFlag), 0)
         =This.GetExtendedError()
         =This.AfterPutFTPFile(@lcRemoteFile, @lclocalFile,lnFlag,fResult)

         =IIF(This.lMultiOperations,.T.,This.CloseFTPConnection())   && Close FTP Handle
	  	    	
         RETURN  fResult = 1
      ENDIF
      RETURN .F.
   ENDPROC


   ****************************************************
   PROCEDURE BeforePutFTPFile(INPREF lcRemoteFile, INPREF lclocalFile, INP lnFlag) && Raised before calling  API function FtpPutFile()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AfterPutFTPFile(INPREF lcRemoteFile, INPREF lclocalFile, INP lnFlag, INP fResult) && Raised after calling  API function FtpPutFile()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC


   ****************************************************
   PROCEDURE WriteFTPFile(INP lcRemoteFile, INP lcData,OPT_INP liData,OPT_INP liStart,OPT_INP liFlags,OPT_INP lnFlag) && Sends a file or string to the FTP server from some local area
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL fResult,lihFTP,lcBuffer,liData,liWrite,lihFile,lcAll,lcAlias,liSele,llErr,lcError
      LOCAL ARRAY laFile(1)
      lihFile=0

      liData=IIF(PCOUNT()<3,512,liData)
      liData=IIF(liData<=0,512,liData)
      
      liStart=IIF(PCOUNT()<4,0,liStart)
      liFlags=IIF(PCOUNT()<5,_FTPS_RWF_File,liFlags)
      lnFlag=IIF(PCOUNT()<6,FTP_TRANSFER_TYPE_UNKNOWN,lnFlag)
      liSele=SELECT()
      lcAlias=SYS(2015)

      IF !BITTEST(liFlags,0) && File?
         IF ADIR(laFile,lcData,"RSHA")=0 && safety than FILE()
            This.SetExtendedError(_FTPS_UE_FNEXISTS,lcData)
            RETURN .F.
         ENDIF

         CREATE CURSOR (lcAlias) (XX000 M NOCPTRANS)
         APPEND BLANK
         #IF VAL(STRTRAN(SUBS(VERSION(),LEN("Visual FoxPro ")+1,2),"0",""))>=8
          TRY
           APPEND MEMO XX000 FROM (lcData)
          CATCH
           llErr=.T.
          FINALLY
          ENDTRY
         #ELSE
           lcError=ON("ERROR") 
           ON ERROR llErr=.T.
           APPEND MEMO XX000 FROM (lcData)
         #ENDIF
         IF llErr && bug at reading file from disk
            This.SetExtendedError(_FTPS_UE_CNF,lcData)
            RETURN .F.
         ENDIF
      ELSE
         IF TYPE("lcData")#"C"
            This.SetExtendedError(11,"Function argument value, type, or count is invalid.")
            RETURN .F.
         ENDIF
*         lcData=SUBST(lcData,liStart+1)
      ENDIF

      IF This.OpenFTPConnection(This.cCurrentDir)    && Open an FTP Handle
         lcRemoteFile = lcRemoteFile + cNULL

         =This.BeforeWriteFTPFile(@lcRemoteFile, @lcData,liData,liStart,liFlags,lnFlag)

         IF liStart>0 && Part data
            * Append file
            =This.FTPCommand("REST "+LTRIM(STR(liStart,11)), lnFlag,0,.NULL.)
            fResult=IIF(This.FTPCommand("APPE "+lcRemoteFile, lnFlag,0,@lihFTP),1,0)
         ENDIF

         STORE FtpOpenFile(This.nConnect_Handle, @lcRemoteFile, GENERIC_WRITE, ;
                           BITOR(This.nCachingType,lnFlag), 0) TO fResult,lihFTP
         =This.GetExtendedError()

         IF fResult #0 && OK, FTP file is openned
            DO CASE
               CASE !BITTEST(liFlags,0) AND liStart>=LEN(XX000) OR;
                     BITTEST(liFlags,0) AND LEN(lcData)=0 && prázdný soubor nebo prázdná data
                    lcBuffer=""
                    liData=LEN(lcBuffer)

                    liWrite=0
                    fResult = InternetWriteFile(lihFTP, @lcBuffer, liData, @liWrite)
                    =This.GetExtendedError()
                    =This.AtWriteFTPFile(@lcRemoteFile, @lcData,liData,liStart,liFlags,lnFlag,0,liWrite,fResult)
         
               CASE !BITTEST(liFlags,0) && File from string
                    lii=liStart+1
               
                    DO WHILE lii<LEN(XX000)
                       lcBuffer=SUBST(XX000,lii,liData)
                       liData=LEN(lcBuffer)

                       liWrite=0
                       fResult = InternetWriteFile(lihFTP, @lcBuffer, liData, @liWrite)
                       =This.GetExtendedError()
                       =This.AtWriteFTPFile(@lcRemoteFile, @lcData,liData,liStart,liFlags,lnFlag,lii,liWrite,fResult)
                       IF fResult#1
                          EXIT
                       ENDIF
                       lii=lii+liData
                    ENDDO

               CASE BITTEST(liFlags,0) && String data
                    lii=liStart+1
               
                    DO WHILE lii<LEN(lcData)
                       lcBuffer=SUBST(lcData,lii,liData)
                       liData=LEN(lcBuffer)

                       liWrite=0
                       fResult = InternetWriteFile(lihFTP, @lcBuffer, liData, @liWrite)
                       =This.GetExtendedError()
                       =This.AtWriteFTPFile(@lcRemoteFile, @lcData,liData,liStart,liFlags,lnFlag,lii,liWrite,fResult)
                       IF fResult#1
                          EXIT
                       ENDIF
                       lii=lii+liData
                    ENDDO

            ENDCASE

            =IIF(liStart>0,This._FTPCommand("NOOP", FTP_TRANSFER_TYPE_BINARY,0,.NULL.),.T.)
            =InternetCloseHandle(lihFTP)
         ENDIF
         IF USED(lcAlias)
            USE IN (lcAlias)
         ENDIF
         SELECT (liSele)

         =This.AfterWriteFTPFile(@lcRemoteFile, @lcData,liData,liStart,liFlags,lnFlag,fResult)
         =IIF(This.lMultiOperations,.T.,This.CloseFTPConnection())   && Close FTP Handle
         
         RETURN fResult = 1
      ENDIF
      RETURN .F.
   ENDPROC



   ****************************************************
   PROCEDURE BeforeWriteFTPFile(INPREF lcRemoteFile, INPREF lcData, INP liData, INP liStart, INP liFlags, INP lnFlag) && Raised before calling  API function FtpOpenFile()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AfterWriteFTPFile(INPREF lcRemoteFile, INPREF lcData,INP liData,INP liStart,INP liFlags, INP lnFlag, INP fResult) && Raised after last calling API InternetWriteFile()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AtWriteFTPFile(INPREF lcRemoteFile, INPREF lcData,INP liData,INP liStart,INP liFlags,INP lnFlag,INP lii,INP liWrite,INP fResult) && Raised after each calling  API function InternetWriteFile()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC



   ****************************************************
   PROCEDURE ReadFTPFile(INP lcRemoteFile,INP lcData,OPT_INP liData,OPT_INP liRStart,OPT_INP liLStart,OPT_INP liFlags,OPT_INP lnFlag) && Get file from FTP do string or local file
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL fResult,lihFTP,lcBuffer,liData,liRead,lihFile,llFast,lcAll,llAppend,liFSize,liModeFile,llErr
      lihFile=0
      liData=IIF(PCOUNT()<3,512,liData)
      liData=IIF(liData<=0,512,liData)
      
      liRStart=IIF(PCOUNT()<4,0,liRStart)
      liLStart=IIF(PCOUNT()<5,0,liLStart)
      liFlags=IIF(PCOUNT()<6,_FTPS_RWF_Resume+_FTPS_RWF_File,liFlags)
      lnFlag=IIF(PCOUNT()<7,FTP_TRANSFER_TYPE_UNKNOWN,lnFlag)

      liModeFile=IIF(TYPE("lnFlag("+LTRIM(STR(_FTPS_FA_ModeFile,11))+")")="N",lnFlag(_FTPS_FA_ModeFile),0)

      IF !BITTEST(liFlags,0) && File?
         llFast=VAL(STRTRAN(SUBS(VERSION(),LEN("Visual FoxPro ")+1,2),"0",""))>6
         IF !llFast
            lihFile=FOPEN(lcData,0)
            IF lihFile<=0
               IF liModeFile=_FTPS_FA_MF_Error
                  This.SetExtendedError(_FTPS_UE_FNEXISTS,lcData)
                  RETURN .F.
               ENDIF
               lihFile=FCREATE(lcData,0)

               DO CASE
                  CASE liModeFile=_FTPS_FA_MF_New OR IIF(BITTEST(liFlags,1),liLStart,liRStart)=0

                  CASE lihFile<=0
                       This.SetExtendedError(_FTPS_UE_CCF,lcData)
                       RETURN .F.

                  CASE liModeFile=_FTPS_FA_MF_Append
                       IF BITTEST(liFlags,1) && rewrite, skip to new position
                          =FCHSIZE(lihFile,liLStart+1)
                          =FSEEK(lihFile,liLStart,0)
                       ELSE
                          =FCHSIZE(lihFile,liRStart+1)
                          =FSEEK(lihFile,liRStart,0) && resume native mode
                       ENDIF


               ENDCASE

            ELSE
               IF lihFile<=0
                  This.SetExtendedError(_FTPS_UE_COF,lcData)
                  RETURN .F.
               ENDIF

               =IIF(BITTEST(liFlags,1),; && rewrite, skip to new position
                    FSEEK(lihFile,liLStart,0),;
                    FSEEK(lihFile,liRStart,0)) && resume native mode
            ENDIF
         ELSE
            IF LEN(SYS(2000,lcData))=0 && local file not exist
               DO CASE
                  CASE liModeFile=_FTPS_FA_MF_New OR IIF(BITTEST(liFlags,1),liLStart,liRStart)=0
                       lcAll=""

                  CASE liModeFile=_FTPS_FA_MF_Error
                       This.SetExtendedError(_FTPS_UE_FNEXISTS,lcData)
                       RETURN .F.

                  CASE liModeFile=_FTPS_FA_MF_Append
                       lcAll=IIF(BITTEST(liFlags,1),; && rewrite, skip to new position
                                 REPL(CHR(0),liLStart),REPL(CHR(0),liRStart))
                 
                  OTHERWISE

               ENDCASE
               
            ELSE
               lcAll=FILETOSTR(lcData)
               lcAll=IIF(BITTEST(liFlags,1),; && rewrite, skip to new position
                         LEFT(lcAll,liLStart),LEFT(lcAll,liRStart))
            ENDIF
 

         ENDIF
      ELSE
         IF TYPE("lcData")#"C"
            This.SetExtendedError(11,"Function argument value, type, or count is invalid.")
            RETURN .F.
         ENDIF
         lcData=IIF(BITTEST(liFlags,1),; && rewrite, skip to new position
                    LEFT(lcData,liLStart),LEFT(lcData,liRStart))
         llFast=.T.
      ENDIF

      IF This.OpenFTPConnection(This.cCurrentDir) && Open an FTP Handle
         lcRemoteFile = lcRemoteFile + cNULL

         =This.BeforeReadFTPFile(@lcRemoteFile, @lcData,liData,liRStart,liLStart,liFlags,lnFlag)
         IF liRStart>0 && Part data
            =This.FTPCommand("REST "+LTRIM(STR(liRStart,11)), FTP_TRANSFER_TYPE_BINARY,0,.NULL.)
         ENDIF

         STORE FtpOpenFile(This.nConnect_Handle, @lcRemoteFile, GENERIC_READ, ;
                           BITOR(This.nCachingType,lnFlag), 0) TO fResult,lihFTP
         =This.GetExtendedError()

         IF fResult #0 && OK, FTP file is openned
            lii=0
            STORE 1 TO fResult,liRead

            DO WHILE liRead>0
               liRead=0
               lcBuffer=SPACE(liData)
               fResult = InternetReadFile(lihFTP, @lcBuffer, liData, @liRead)
               =This.GetExtendedError()
               =This.AtReadFTPFile(@lcRemoteFile, @lcData,liData,liRStart,liLStart,liFlags,lnFlag,@lcBuffer,fResult)

               IF !BITTEST(liFlags,0) && File?
                  IF llFast AND liRead>0
                     IF LEN(lcAll)+liRead>_FTPS_MaxFileSize
                        IF STRTOFILE(lcAll,lcData,llAppend)=0
                           This.SetExtendedError(_FTPS_UE_CWF,"")
                           fResult=0
                           EXIT
                        ENDIF
                        llAppend=.T.
                        lcAll=""
                     ENDIF
                     lcAll=lcAll+LEFT(lcBuffer,liRead)
                  ELSE
                     IF liRead>0
                        IF FWRITE(lihFile,LEFT(lcBuffer,liRead),liRead)=0
                           This.SetExtendedError(_FTPS_UE_CWF,STR(FERROR()))
                           fResult=0
                           EXIT
                        ENDIF
                     ENDIF
                  ENDIF
               ELSE
                  lcData=lcData+LEFT(lcBuffer,liRead)
               ENDIF
               lii=lii+liRead
            ENDDO

            IF !BITTEST(liFlags,0)
                =IIF(llFast AND LEN(lcAll)>0,; && File?
                     STRTOFILE(lcAll,lcData,llAppend),.T.)
                =IIF(lihFile>0 AND !llFast,FCLOSE(lihFile),.T.)
            ENDIF
            =InternetCloseHandle(lihFTP)

            =IIF(liRStart>0,This._FTPCommand("NOOP", FTP_TRANSFER_TYPE_BINARY,0,.NULL.),.T.)
         ENDIF

         =This.AfterReadFTPFile(@lcRemoteFile, @lcData,liData,liRStart,liLStart,liFlags,lnFlag,fResult)
         =IIF(This.lMultiOperations,.T.,This.CloseFTPConnection())   && Close FTP Handle
         RETURN  fResult = 1
      ENDIF
      RETURN .F.
   ENDPROC



   ****************************************************
   PROCEDURE BeforeReadFTPFile(INPREF lcRemoteFile,INPREF lcData,INP liData,INP liRStart,INP liLStart,INP liFlags,INP lnFlag) && Raised before calling  API function FtpOpenFile()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AfterReadFTPFile(INPREF lcRemoteFile,INPREF lcData,INP liData,INP liRStart,INP liLStart,INP liFlags,INP lnFlag,INP fResult) && Raised after last calling API function InternetReadFile()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AtReadFTPFile(INPREF lcRemoteFile,INPREF lcData,INP liData,INP liRStart,INP liLStart,INP liFlags,INP lnFlag,INPREF lcBuffer,INP fResult) && Raised after calling API function InternetReadFile()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC


   ****************************************************
   PROTECTED PROCEDURE _FTPCommand(INP lcCommand,INP liFlags,OPT_INP liContext,OPT_CHNGREF lihFTP) && Send native FTP command to FTP server (iternal method)
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL fResult
      IF This.OpenFTPConnection(This.cCurrentDir)     && Open an FTP Handle
         liFlags=IIF(PCOUNT()<2,FTP_TRANSFER_TYPE_BINARY,liFlags)
         liContext=IIF(PCOUNT()<3,0,liContext)
         lihFTP=IIF(ISNULL(lihFTP),-1,0)

         lcCommand = lcCommand + cNULL
         fResult = FtpCommand(This.nConnect_Handle, IIF(lihFTP=-1,0,1), liFlags, @lcCommand,liContext,@lihFTP)
         =IIF(This.lMultiOperations,.T.,This.CloseFTPConnection())   && Close FTP Handle
         RETURN  fResult = 1
      ENDIF
      RETURN .F.
   ENDPROC


   ****************************************************
   PROCEDURE FTPCommand(INP lcCommand,INP liFlags,OPT_INP liContext,OPT_CHNGREF lihFTP) && Send native FTP command to FTP server
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL fResult
      IF This.OpenFTPConnection(This.cCurrentDir)     && Open an FTP Handle
         liFlags=IIF(PCOUNT()<2,FTP_TRANSFER_TYPE_BINARY,liFlags)
         liContext=IIF(PCOUNT()<3,0,liContext)
         lihFTP=IIF(ISNULL(lihFTP),-1,0)

         lcCommand = lcCommand + cNULL
         =This.BeforeFTPCommand(@lcCommand, liFlags, liContext,lihFTP)
         fResult = FtpCommand(This.nConnect_Handle, IIF(lihFTP=-1,0,1), liFlags, @lcCommand,liContext,@lihFTP)

         =This.GetExtendedError()
         =This.AfterFTPCommand(@lcCommand, liFlags, liContext,lihFTP,fResult)

         =IIF(This.lMultiOperations,.T.,This.CloseFTPConnection())   && Close FTP Handle
         RETURN  fResult = 1
      ENDIF
      RETURN .F.
   ENDPROC


   ****************************************************
   PROCEDURE BeforeFTPCommand(INPREF lcCommand,INP liFlags,INP liContext,INP lihFTP) && Raised before calling  API function FtpCommand()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AfterFTPCommand(INPREF lcCommand,INP liFlags,INP liContext,INP lihFTP,INP fResult) && Raised after calling  API function FtpCommand()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC




	  	
   ****************************************************
   PROCEDURE DeleteFTPFile(INP lcRemoteFile) && Delete file on the FTP Server
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL fResult
      IF This.OpenFTPConnection(This.cCurrentDir)     && Open an FTP Handle
         lcRemoteFile = lcRemoteFile + cNULL
		  	  		  	  	  	  	
         =This.BeforeDeleteFTPFile(@lcRemoteFile)
         fResult = FtpDeleteFile(This.nConnect_Handle, @lcRemoteFile)
         This.GetExtendedError()
         =This.AfterDeleteFTPFile(@lcRemoteFile,fResult)
         =IIF(This.lMultiOperations,.T.,This.CloseFTPConnection())   && Close FTP Handle
         RETURN fResult = 1
      ENDIF
      RETURN .F.    	  	  	
   ENDPROC

   ****************************************************
   PROCEDURE BeforeDeleteFTPFile(INPREF lcRemoteFile) && Raised before calling  API function FtpDeleteFile()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AfterDeleteFTPFile(INPREF lcRemoteFile,INP fResult) && Raised after calling  API function FtpDeleteFile()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC
		
		
   ****************************************************
   PROCEDURE RenameFTPFile(INP lcOldFile,INP lcNewFile) && Renames a file
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL fResult
      IF This.OpenFTPConnection(This.cCurrentDir)     && Open an FTP Handle
         lcOldFile = lcOldFile + cNULL
         lcNewFile = lcNewFile + cNULL
		  	  	  	  	
         =This.BeforeRenameFTPFile(@lcOldFile, @lcNewFile)
         fResult = FtpRenameFile(This.nConnect_Handle, @lcOldFile, @lcNewFile)
         =This.GetExtendedError()
         =This.AfterRenameFTPFile(@lcOldFile, @lcNewFile,fResult)
         =IIF(This.lMultiOperations,.T.,This.CloseFTPConnection())   && Close FTP Handle
         RETURN fResult = 1
      ENDIF
      RETURN .F.    	  	  	
   ENDPROC

   ****************************************************
   PROCEDURE BeforeRenameFTPFile(INPREF lcOldFile,INPREF lcNewFile) && Raised before calling  API function FtpRenameFile()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AfterRenameFTPFile(INPREF lcOldFile,INPREF lcNewFile,INP fResult) && Raised after calling  API function FtpRenameFile()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE GetFileSize(INP lcFile, CHNGREF lnSize)  && Get File Size
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL lcPom,llRet
      IF This.OpenFTPConnection(This.cCurrentDir)     && Open an FTP Handle
         lcFile = ALLTRIM(lcFile)+cNULL
		  	  	  	  	
         =This.BeforeGetFileSize(@lcFile, lnSize)
         *!* FtpGetFileSize does not work as expected for files greater then 4Gb (dwFileSizeHigh always NULL)
         *!* http://groups.google.com.ar/group/microsoft.public.windows.inetexplorer.ie5.programming.wininet/browse_thread/thread/3c118ed4c7c32269/791a868311e60a00?lnk=st&q=ftpfindfirstfile+and+large+files&rnum=2&hl=es#791a868311e60a00

         llRet=This.FTPCommand("SIZE "+lcFile,0,0,.NULL.)
         IF llRet
            lcPom=This.GetExtendedErrorMsg()
            lnSize=VAL(SUBSTR(lcPom,AT(" ",lcPom)+1))
         ENDIF

         =This.AfterGetFileSize(@lcFile,lnSize,llRet)
         =IIF(This.lMultiOperations,.T.,This.CloseFTPConnection())   && Close FTP Handle
         RETURN llRet
      ENDIF
      RETURN .F.    	  	  	
   ENDPROC

   ****************************************************
   PROCEDURE BeforeGetFileSize(INPREF lcFile, CHNGREF lnSize) && Raised before calling  API function FTPGetFileSize()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AfterGetFileSize(INPREF lcFile, CHNGREF lnSize,INP llRet) && Raised after calling  API function FTPGetFileSize()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC
		
		
   ****************************************************
   PROCEDURE CreateFTPDirectory(INP lcNewDir) && Creates a directory on the FTP Server
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL fResult
      IF This.OpenFTPConnection(This.cCurrentDir)     && Open an FTP Handle  	   		
         lcNewDir = lcNewDir + cNULL
		  	   	  	   		  	   	 
         =This.BeforeCreateFTPDirectory(@lcNewDir)
         fResult = FtpCreateDirectory(This.nConnect_Handle, @lcNewDir)
         =This.GetExtendedError()
         =This.AfterCreateFTPDirectory(@lcNewDir,fResult)
         =IIF(This.lMultiOperations,.T.,This.CloseFTPConnection())   && Close FTP Handle
		  	 	
         RETURN fResult = 1
      ENDIF
      RETURN .F.
   ENDPROC


   ****************************************************
   PROCEDURE BeforeCreateFTPDirectory(INPREF lcNewDir) && Raised before calling  API function FtpCreateDirectory()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AfterCreateFTPDirectory(INPREF lcNewDir,INP fResult) && Raised after calling  API function FtpCreateDirectory()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>

   ENDPROC

	  	
   ****************************************************
   PROCEDURE RemoveFTPDirectory(INP lcDir) && Removes a directory on the FTP Server
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL fResult
      IF This.OpenFTPConnection(This.cCurrentDir)     && Open an FTP Handle  	   		  
         lcDir = lcDir + cNULL
		  	   	  	   		  	   	 
         =This.BeforeRemoveFTPDirectory(@lcDir)
         fResult = FtpRemoveDirectory(This.nConnect_Handle, @lcDir)
         =This.GetExtendedError()
         =This.AfterRemoveFTPDirectory(@lcDir,fResult)
         =IIF(This.lMultiOperations,.T.,This.CloseFTPConnection())   && Close FTP Handle
		  	 	
         RETURN fResult = 1
      ENDIF
      RETURN .F. 
   ENDPROC


   ****************************************************
   PROCEDURE BeforeRemoveFTPDirectory(INPREF lcDir) && Raised before calling  API function FtpRemoveDirectory()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AfterRemoveFTPDirectory(INPREF lcDir,INP fResult) && Raised after calling API function FtpRemoveDirectory()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC
			 
   ****************************************************
   PROCEDURE ChangeFTPDirectory(INP lcNewDir) && Change the current directory on the FTP Server
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL fResult, lcTempDir, llResult
	  	   	  	   		  
      IF This.OpenFTPConnection(This.cCurrentDir)     && Open an FTP Handle 	   		  
         llResult = .F.	 
	  	   	  	   		  	   
         lcNewDir = lcNewDir + cNULL  
         lcTempDir = SPACE(MAX_PATH)	   		  	   	
		  	   	  	   		  	   	 
         =This.BeforeChangeFTPDirectory(@lcNewDir)
         fResult = FtpSetCurrentDirectory(This.nConnect_Handle, @lcNewDir)
         =This.GetExtendedError()
		  	 		  	 	
         IF fResult = 1
            fResult = FtpGetCurrentDirectory(This.nConnect_Handle, @lcTempDir, MAX_PATH)
            =This.GetExtendedError()
		  	 		  	 		
            IF fResult = 1
               This.cCurrentDir = RTRIM(lcTempDir)
               llResult = .T.
            ENDIF
         ENDIF
         =This.AfterChangeFTPDirectory(@lcNewDir,fResult)
		  	 	
         =IIF(This.lMultiOperations,.T.,This.CloseFTPConnection())   && Close FTP Handle
         RETURN llResult
      ENDIF	  	 
      RETURN .F. 		  	 
   ENDPROC

   ****************************************************
   PROCEDURE BeforeChangeFTPDirectory(INPREF lcNewDir) && Raised before calling  API function FtpSetCurrentDirectory()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AfterChangeFTPDirectory(INPREF lcNewDir,INP fResult) && Raised after calling API function FtpSetCurrentDirectory()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC
	  	
   ****************************************************
   PROCEDURE GetFTPDirectory(OUTREF lcDirectory) && Get current directory on the FTP Server
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL fResult, lcTempDir
      IF This.OpenFTPConnection(This.cCurrentDir)     && Open an FTP Handle
         lcTempDir = SPACE(MAX_PATH)
         =This.BeforeGetFTPDirectory(@lcDirectory)
         fResult = FtpGetCurrentDirectory(This.nConnect_Handle, @lcTempDir, MAX_PATH)
         =This.GetExtendedError()
         lcDirectory = LEFT(lcTempDir, AT(cNULL, lcTempDir) - 1)
         =This.AfterGetFTPDirectory(@lcDirectory,fResult)
         =IIF(This.lMultiOperations,.T.,This.CloseFTPConnection())   && Close FTP Handle
         RETURN fResult = 1
      ENDIF
      RETURN .F.
   ENDPROC

   ****************************************************
   PROCEDURE BeforeGetFTPDirectory(INPREF lcDirectory) && Raised before calling  API function FtpGetCurrentDirectory()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AfterGetFTPDirectory(INPREF lcDirectory,INP fResult) && Raised after calling API function FtpGetCurrentDirectory()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC
		
				
   ****************************************************
   PROCEDURE GetFTPDirectoryArray(OUTREF laDirectory, INP lcMask,OPT_INP lnFlag) && Get a list of files from the current directory on the FTP Server
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL cStruct, liResult, lnCount, fResult, lffHandle,lii,lnSize
      IF This.OpenFTPConnection(This.cCurrentDir)     && Open an FTP Handle
         lcMask = lcMask + cNULL
		      
         * Dimension the array to store the directory
         * [x, 1] = FileName
         * [x, 2] = Alternate FileName
         * [x, 3] = File Size
         * [x, 4] = File Create Date
         * [x, 5] = File Last Access Time
         * [x, 6] = File Last Write Time
         * [x, 7] = File Attributes
         DIMENSION laDirectory [1, 7]
         laDirectory [1, 1] = .F.
         lnFlag=BITOR(INTERNET_FLAG_RELOAD,IIF(PCOUNT()<3,0,lnFlag))
		    	      	
         * This is for a FoxPro Quirk.
         lcStruct = REPL(CHR(0),319)+CHR(0)   && Allocate space for the returned structure
		      	
         =This.BeforeGetFTPDirectoryArray(@laDirectory, @lcMask,lnFlag)
         * Get the first file or find out if 
         lffHandle = FtpFindFirstFile(This.nConnect_Handle, @lcMask, @lcStruct, lnFlag, 0)
         This.GetExtendedError()
		      	
         IF lffHandle = 0 OR This.nResult_Code = ERROR_NO_MORE_FILES
            This.CloseFTPConnection()   && Close FTP Handle
            RETURN .F.
         ENDIF

         * Parse out First File Information
         =This.CrackFile(lcStruct, @laDirectory)
		      	
         llResult = 1
         DO WHILE This.nResult_Code != ERROR_NO_MORE_FILES AND llResult != 0
            lcStruct = SPACE(319)
            * Get next files
            liResult = InternetFindNextFile(lffHandle, @lcStruct)
            =This.GetExtendedError()
			    		
            * If we got good information, go ahead and parse it
            IF This.nResult_Code != ERROR_NO_MORE_FILES AND llResult != 0
               =This.CrackFile(lcStruct, @laDirectory)
            ENDIF
         ENDDO
         =This.AfterGetFTPDirectoryArray(@laDirectory, @lcMask, lnFlag,liResult)
         =This.CloseFTPConnection()   && Close FTP Handle

         FOR lii=1 TO ALEN(laDirectory,1)
             IF This.GetFileSize(laDirectory(lii,1),@lnSize)
                laDirectory(lii,3)=lnSize
             ENDIF
         NEXT
      ELSE
         RETURN .F.     && Unable to get FTP Connection	
      ENDIF
      RETURN .T.
   ENDPROC

   ****************************************************
   PROCEDURE BeforeGetFTPDirectoryArray(CHNGREF laDirectory, INPREF lcMask, INP lnFlag) && Raised before calling API function FtpFindFirstFile()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AfterGetFTPDirectoryArray(CHNGREF laDirectory,INPREF lcMask, INP lnFlag,INP liResult) && Raised after last calling API function FtpFindNextFile()
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE List(OUTREF luData, INP lcMask,OPT_INP liFlags,OPT_INP lnFlag) && Get a list of files and folders from the current directory on the FTP Server
      *!*   <pdm_sc_yes/>
      *!*   <pdm_dd_yes/>
      EXTERNAL ARRAY luData
      LOCAL liResult, lihFTP,lii,lcBuffer,lcData,liData,liEnd,liCount,llRet

      liFlags=IIF(PCOUNT()<3,_FTPS_RWF_File,liFlags)
      lnFlag=IIF(PCOUNT()<4,FTP_TRANSFER_TYPE_ASCII,lnFlag)

      IF This.OpenFTPConnection(This.cCurrentDir)     && Open an FTP Handle
         IF BITTEST(liFlags,2) && Array?
            DIMENSION luData [1, 1]
            luData [1, 1] = .NULL.
         ENDIF
         lihFTP=0

         This.BeforeList(@luData,@lcMask,liFlags,lnFlag)

         liResult=IIF(This.FTPCommand("LIST "+lcMask,FTP_TRANSFER_TYPE_ASCII,0,@lihFTP),1,0)
         IF liResult #0 && OK, FTP list is openned
            llRet=.T.         
            lii=0
            liData=500
            STORE 1 TO fResult,liRead
            lcData=""

            DO WHILE liRead>0
               liRead=0
               lcBuffer=SPACE(liData)
               liResult = InternetReadFile(lihFTP, @lcBuffer, liData, @liRead)
               =This.GetExtendedError()
               This.AtList(@luData,@lcMask,liFlags,lnFlag,@lcBuffer,liResult)

               lcData=lcData+LEFT(lcBuffer,liRead)
               lii=lii+liRead
            ENDDO
            =This.CloseFTPConnection()   && Close FTP Handle

            =This.AfterList(luData,lcMask,liFlags,lnFlag,liResult)

            DO CASE
               CASE liResult=0

               CASE !BITTEST(liFlags,0) AND !BITTEST(liFlags,2) && File?
                    IF STRTOFILE(lcData,luData)=0
                       This.SetExtendedError(_FTPS_UE_CWF,"")
                       llRet=.F.
                    ENDIF

               CASE BITTEST(liFlags,0) && String?
                    luData=lcData

               CASE BITTEST(liFlags,2) && Array?
                    IF ISNULL(This.oLIstPE)
                       This.oLIstPE=CREATEOBJECT("_LIST_PARSER_ENGINE")
                    ENDIF
                    This.oLIstPE.oFTP=This
                    llRet=This.oLIstPE.Parse(@luData,@lcData)
                    This.oLIstPE.oFTP=.NULL.
            ENDCASE
         ELSE
            This.CloseFTPConnection()  && Close FTP Handle
         ENDIF
         RETURN llRet
      ELSE
         RETURN .F.     && Unable to get FTP Connection   
      ENDIF
   ENDPROC

   ****************************************************
   PROCEDURE BeforeList(CHNGREF luData, INPREF lcMask,OPT_INP liFlags,OPT_INP lnFlag) && Raised before calling API function FtpCommand
      *!*   <pdm_sc_yes/>
      *!*   <pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AfterList(CHNGREF luData, INPREF lcMask,OPT_INP liFlags,OPT_INP lnFlag,OPT_INP liResult) && Raised after closing FTP connection
      *!*   <pdm_sc_yes/>
      *!*   <pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AtList(CHNGREF luData, INPREF lcMask,OPT_INP liFlags,OPT_INP lnFlag,CHNGREF lcBuffer,OPT_INP liResult) && Raised after reading data from buffer
      *!*   <pdm_sc_yes/>
      *!*   <pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE NLST(OUTREF luData, INP lcMask,OPT_INP liFlags,OPT_INP lnFlag) && Get a list of files and folders from the current directory on the FTP Server
      *!*   <pdm_sc_yes/>
      *!*   <pdm_dd_yes/>
      EXTERNAL ARRAY luData
      LOCAL liResult, lihFTP,lii,lcBuffer,lcData,liData,liEnd,liCount,llRet

      liFlags=IIF(PCOUNT()<3,_FTPS_RWF_File,liFlags)
      lnFlag=IIF(PCOUNT()<4,FTP_TRANSFER_TYPE_ASCII,lnFlag)

      IF This.OpenFTPConnection(This.cCurrentDir)     && Open an FTP Handle
         IF BITTEST(liFlags,2) && Array?
            DIMENSION luData [1, 1]
            luData [1, 1] = .NULL.
         ENDIF
         lihFTP=0

         This.BeforeNLST(@luData,@lcMask,liFlags,lnFlag)

         liResult=IIF(This.FTPCommand("NLST "+lcMask,FTP_TRANSFER_TYPE_ASCII,0,@lihFTP),1,0)
         IF liResult #0 && OK, FTP list is openned
            llRet=.T.         
            lii=0
            liData=500
            STORE 1 TO fResult,liRead
            lcData=""

            DO WHILE liRead>0
               liRead=0
               lcBuffer=SPACE(liData)
               liResult = InternetReadFile(lihFTP, @lcBuffer, liData, @liRead)
               =This.GetExtendedError()
               This.AtNLST(@luData,@lcMask,liFlags,lnFlag,@lcBuffer,liResult)

               lcData=lcData+LEFT(lcBuffer,liRead)
               lii=lii+liRead
            ENDDO
            This.CloseFTPConnection()  && Close FTP Handle

            DO CASE
               CASE liResult=0

               CASE !BITTEST(liFlags,0) AND !BITTEST(liFlags,2) && File?
                    IF STRTOFILE(lcData,luData)=0
                       This.SetExtendedError(_FTPS_UE_CWF,"")
                       llRet=.F.
                    ENDIF

               CASE BITTEST(liFlags,0) && String?
                    luData=lcData

               CASE BITTEST(liFlags,2) && Array?
                    * parse data by CRLF
                    IF AT("\015\012",lcData)>0 && EPLF
                       lcData=STRTRAN(lcData,"\015\012",CRLF)
                    ENDIF
                    IF VAL(STRTRAN(SUBS(VERSION(),LEN("Visual FoxPro ")+1,2),"0",""))>=6
                       liCount=ALINES(luData,lcData)
                    ELSE
                       liCount=OCCURS(CRLF,lcData)
                       IF liCount>0 THEN
                          DIME luData[liCount, 1]
                          lii=1  
                          liEnd=AT(CRLF,lcData,1)
                          DO WHILE liEnd>0
                             luData[lii, 1]=LEFT(lcData,liEnd-1)
                             lcData=SUBSTR(lcData,liEnd+2)
                             liEnd=AT(CRLF,lcData,1)
                             lii=lii+1  
                          ENDDO
                       ENDIF
                    ENDIF
            ENDCASE
         ELSE
            This.CloseFTPConnection()  && Close FTP Handle
         ENDIF
         This.AfterNLST(luData,lcMask,liFlags,lnFlag,liResult)
         RETURN llRet
      ELSE
         RETURN .F.     && Unable to get FTP Connection   
      ENDIF
   ENDPROC

   ****************************************************
   PROCEDURE BeforeNLST(CHNGREF luData, INPREF lcMask,OPT_INP liFlags,OPT_INP lnFlag) && Raised before calling API function FtpCommand
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AfterNLST(CHNGREF luData, INPREF lcMask,OPT_INP liFlags,OPT_INP lnFlag,OPT_INP liResult) && Raised after closing FTP connection
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC

   ****************************************************
   PROCEDURE AtNLST(CHNGREF luData, INPREF lcMask,OPT_INP liFlags,OPT_INP lnFlag,CHNGREF lcBuffer,OPT_INP liResult) && Raised after reading data from buffer
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
   ENDPROC


		
   ****************************************************
   PROTECTED PROCEDURE CrackFile(INP lcString, CHNGREF laDirectory) && Parsing file's attributes and storing to array
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL lcFileName, lcAlterName, lnSizeHigh, lnSizeLow, lnFileSize, ;
            lcAttributes, lnArrayLen, lcTimeBuff, ;
            ldCreateDate, ldAccessDate, ldWriteDate, laNewArray, lnResult,lcPom
	      	
      IF TYPE('laDirectory[1, 1]') = 'L'	&& Array Has Not Been Filed      
         * Force Record size of 1
         DIMENSION laDirectory [1, 7]
      ELSE	
         * Expand Array
         DIMENSION laDirectory [ALEN(laDirectory, 1) + 1, 7]
      ENDIF
	        
      * Get new Array Position
      lnArrayLen = ALEN(laDirectory, 1)


*!* 4	  DWORD    dwFileAttributes; 
*!* 8	  FILETIME ftCreationTime; 
*!*	8	  FILETIME ftLastAccessTime; 
*!* 8	  FILETIME ftLastWriteTime; 
*!* 4	  DWORD    nFileSizeHigh; 
*!* 4	  DWORD    nFileSizeLow; 
*!* 4	  DWORD    dwReserved0; 
*!* 4	  DWORD    dwReserved1; 
*!* 4	  TCHAR    cFileName[ MAX_PATH ]; 
*!*	  TCHAR    cAlternateFileName[ 14 ]; 


*!*	typedef struct _FILETIME { 
*!*	    DWORD dwLowDateTime; 
*!*	    DWORD dwHighDateTime; 
*!*	} FILETIME, *PFILETIME; 



      lcFileName = SUBSTR(lcString, 45, MAX_PATH)
      lcAlterName = RIGHT(lcString, 14)
	      	
      lcFileName = LEFT(lcFileName, AT(cNull, lcFileName) - 1)  && Copy out just the File Name Text
      lcAlterName = LEFT(lcAlterName, AT(cNull, lcAlterName) - 1)
	      	
      * Convert File Size DWORDs
      lnSizeHigh = (ASC(SUBSTR(lcString, 29, 1)) * BYTE_1) + ;
                   (ASC(SUBSTR(lcString, 30, 1)) * BYTE_2) + ;
                   (ASC(SUBSTR(lcString, 31, 1)) * BYTE_3) + ;
                   (ASC(SUBSTR(lcString, 32, 1)) * BYTE_4) 
	      				 
      lnSizeLow =  (ASC(SUBSTR(lcString, 33, 1)) * BYTE_1) + ;
                   (ASC(SUBSTR(lcString, 34, 1)) * BYTE_2) + ;
                   (ASC(SUBSTR(lcString, 35, 1)) * BYTE_3) + ;
                   (ASC(SUBSTR(lcString, 36, 1)) * BYTE_4) 
	      				 
      * Build File Size
      lnFileSize = (lnSizeHigh * MAXDWORD) + lnSizeLow

      *!* FtpGetFileSize does not work as expected for files greater then 4Gb (dwFileSizeHigh always NULL)
      *!* http://groups.google.com.ar/group/microsoft.public.windows.inetexplorer.ie5.programming.wininet/browse_thread/thread/3c118ed4c7c32269/791a868311e60a00?lnk=st&q=ftpfindfirstfile+and+large+files&rnum=2&hl=es#791a868311e60a00

      * Convert File Date
	       
      * Get File Create DateTime
      lcTimeBuff = SUBSTR(lcString, 5, 8)
      ldCreateDate = This.CrackDate(lcTimeBuff)
	        
      * Get File Last Access DateTime
      lcTimeBuff = SUBSTR(lcString, 13, 8)
      ldAccessDate = This.CrackDate(lcTimeBuff)
	        
      * Get File Last Write DateTime
      lcTimeBuff = SUBSTR(lcString, 21, 8)
      ldWriteDate = This.CrackDate(lcTimeBuff)
	        
      * Get File Attributes
      lcAttributes = This.CrackAttributes(LEFT(lcString, 4))
	        
      laDirectory[lnArrayLen, 1] = ALLTRIM(lcFileName)
      laDirectory[lnArrayLen, 2] = ALLTRIM(lcAlterName)
      laDirectory[lnArrayLen, 3] = lnFileSize
      laDirectory[lnArrayLen, 4] = ldCreateDate
      laDirectory[lnArrayLen, 5] = ldAccessDate
      laDirectory[lnArrayLen, 6] = ldWriteDate
      laDirectory[lnArrayLen, 7] = lcAttributes
  	 
      RETURN 
   ENDPROC
	    
   ****************************************************
   PROTECTED PROCEDURE CrackDate(INP lcOutBuffer) && Converting file system structure to system date
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL lcInBuffer, fResult, lcBuild, ;
            lnDay, lnMonth, lnYear, lnHour, lnMinute, lnSecond
		
      lcInBuffer = SPACE(16)
		
      fResult = FileTimeToSystemTime(@lcOutBuffer, @lcInBuffer)
      This.GetExtendedError()
			
      IF fResult = 0   && Failed
         RETURN {^1901/01/01 00:00:01}
      ENDIF

      lnYear = ASC(SUBSTR(lcInBuffer, 1, 1)) + (ASC(SUBSTR(lcInBuffer, 2, 1)) * BYTE_2)
      lnMonth = ASC(SUBSTR(lcInBuffer, 3, 1)) + (ASC(SUBSTR(lcInBuffer, 4, 1)) * BYTE_2)
      lnDay = ASC(SUBSTR(lcInBuffer, 7, 1)) + (ASC(SUBSTR(lcInBuffer, 8, 1)) * BYTE_2)
      lnHour = ASC(SUBSTR(lcInBuffer, 9, 1)) + (ASC(SUBSTR(lcInBuffer, 10, 1)) * BYTE_2)
      lnMinute = ASC(SUBSTR(lcInBuffer, 11, 1)) + (ASC(SUBSTR(lcInBuffer, 12, 1)) * BYTE_2)
      lnSecond = ASC(SUBSTR(lcInBuffer, 13, 1)) + (ASC(SUBSTR(lcInBuffer, 13, 1)) * BYTE_2)
			
      lcBuild = "^" + ALLTRIM(STR(lnYear)) + '-' + ALLTRIM(STR(lnMonth)) + '-' + ALLTRIM(STR(lnDay)) + ' ' + ;
                ALLTRIM(STR(lnHour)) + ':' + ALLTRIM(STR(lnMinute)) + ':' + ALLTRIM(STR(lnSecond))
				      
      RETURN CTOT(lcBuild)
   ENDPROC
		  
   ****************************************************
   PROTECTED PROCEDURE CrackAttributes(INP lcBuffer) && Converting file's attributes to human's format
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL lcAttributes, lnValue
      lcAttributes = ''
	 		 		
      lnValue = (ASC(SUBSTR(lcBuffer, 1, 1)) * BYTE_1) + ;
                (ASC(SUBSTR(lcBuffer, 2, 1)) * BYTE_2) + ;
                (ASC(SUBSTR(lcBuffer, 3, 1)) * BYTE_3) + ;
                (ASC(SUBSTR(lcBuffer, 4, 1)) * BYTE_4) 
					  
      DO CASE
         CASE BITTEST(lnValue, BIT_ATTRIBUTE_READONLY) 
              lcAttributes = lcAttributes + 'R'

         CASE BITTEST(lnValue, BIT_ATTRIBUTE_HIDDEN) 
              lcAttributes = lcAttributes + 'H'

         CASE BITTEST(lnValue, BIT_ATTRIBUTE_SYSTEM) 
              lcAttributes = lcAttributes + 'S'

         CASE BITTEST(lnValue, BIT_ATTRIBUTE_DIRECTORY) 
              lcAttributes = lcAttributes + 'D'

         CASE BITTEST(lnValue, BIT_ATTRIBUTE_ARCHIVE) 
              lcAttributes = lcAttributes + 'A'

         CASE BITTEST(lnValue, BIT_ATTRIBUTE_NORMAL) 
              lcAttributes = lcAttributes + 'N'

         CASE BITTEST(lnValue, BIT_ATTRIBUTE_TEMPORARY) 
              lcAttributes = lcAttributes + 'T'

         CASE BITTEST(lnValue, BIT_ATTRIBUTE_COMPRESSED) 
              lcAttributes = lcAttributes + 'C'
   
         CASE BITTEST(lnValue, BIT_ATTRIBUTE_OFFLINE) 
              lcAttributes = lcAttributes + 'O'
      ENDCASE
						
      RETURN lcAttributes
   ENDPROC
		



   ****************************************************
   PROCEDURE GetErrorCode(INP llShowMessage) && Watch dog of this FTP Service
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL lcMessage
      IF llShowMessage = .T.
         * Build Error Message Here
         lcMessage = "Error (" + ALLTRIM(STR(This.nResult_Code)) + ")  -  " + ;
                     This.GetErrorText(This.nResult_Code)
         IF !EMPTY(This.cExtended_Message)
            lcMessage = lcMessage + CHR(13) + CHR(13) + "Extended Error Info - (" + ;
                        ALLTRIM(STR(This.nExtended_Result)) + ;
                        ") - " + This.cExtended_Message
         ENDIF
         =MESSAGEBOX(lcMessage, 48, "FTP Error Message")
      ENDIF
      RETURN This.nResult_Code
   ENDPROC
	 	
   ****************************************************
   PROCEDURE GetExtendedErrorCode && Returns the extended error code that was generated during the last function call
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      RETURN This.nExtended_Result
   ENDPROC
	 	
	 	
   ****************************************************
   PROCEDURE GetExtendedErrorMsg && Returns the extended error message generated during a function call
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      RETURN This.cExtended_Message
   ENDPROC

   ****************************************************
   PROTECTED PROCEDURE GetExtendedError && Fill Extended error by WININET
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL lcMessage, lnError, lcBuffer
      This.nResult_Code = GetLastError()
	        
      lnError = 0
      lcBuffer = SPACE(MAX_PATH)
	        
      =InternetGetLastResponseInfo(lnError, @lcBuffer, MAX_PATH)
		    
      This.nExtended_Result = lnError
      This.cExtended_Message = LEFT(lcBuffer, AT(cNULL, lcBuffer) - 1)
      RETURN 
   ENDPROC

   ****************************************************
   PROTECTED PROCEDURE SetExtendedError(liError,lcError) && Set user extended error...
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      This.nResult_Code = 0
      This.nExtended_Result = liError
      This.cExtended_Message = lcError
      RETURN 
   ENDPROC
				
   ****************************************************
   PROCEDURE GetErrorText(INP lnError) && Get error text
      *!*	<pdm_sc_yes/>
      *!*	<pdm_dd_yes/>
      LOCAL lcMessage
      DO CASE
         CASE lnError =  ERROR_INTERNET_OUT_OF_HANDLES                
              lcMessage = "ERROR_INTERNET_OUT_OF_HANDLES"

         CASE lnError =  ERROR_INTERNET_TIMEOUT                       
              lcMessage = "ERROR_INTERNET_TIMEOUT"

         CASE lnError =  ERROR_INTERNET_EXTENDED_ERROR                
              lcMessage = "ERROR_INTERNET_EXTENDED_ERROR"

         CASE lnError =  ERROR_INTERNET_INTERNAL_ERROR                
              lcMessage = "ERROR_INTERNET_INTERNAL_ERROR"

         CASE lnError =  ERROR_INTERNET_INVALID_URL                   
              lcMessage = "ERROR_INTERNET_INVALID_URL"

         CASE lnError =  ERROR_INTERNET_UNRECOGNIZED_SCHEME           
              lcMessage = "ERROR_INTERNET_UNRECOGNIZED_SCHEME"

         CASE lnError =  ERROR_INTERNET_NAME_NOT_RESOLVED             
              lcMessage = "ERROR_INTERNET_NAME_NOT_RESOLVED"

         CASE lnError =  ERROR_INTERNET_PROTOCOL_NOT_FOUND            
              lcMessage = "ERROR_INTERNET_PROTOCOL_NOT_FOUND"

         CASE lnError =  ERROR_INTERNET_INVALID_OPTION                
              lcMessage = "ERROR_INTERNET_INVALID_OPTION"

         CASE lnError =  ERROR_INTERNET_BAD_OPTION_LENGTH             
              lcMessage = "ERROR_INTERNET_BAD_OPTION_LENGTH"

         CASE lnError =  ERROR_INTERNET_OPTION_NOT_SETTABLE           
              lcMessage = "ERROR_INTERNET_OPTION_NOT_SETTABLE"

         CASE lnError =  ERROR_INTERNET_SHUTDOWN                      
              lcMessage = "ERROR_INTERNET_SHUTDOWN"

         CASE lnError =  ERROR_INTERNET_INCORRECT_USER_NAME           
              lcMessage = "ERROR_INTERNET_INCORRECT_USER_NAME"

         CASE lnError =  ERROR_INTERNET_INCORRECT_PASSWORD            
              lcMessage = "ERROR_INTERNET_INCORRECT_PASSWORD"

         CASE lnError =  ERROR_INTERNET_LOGIN_FAILURE                 
              lcMessage = "ERROR_INTERNET_LOGIN_FAILURE"

         CASE lnError =  ERROR_INTERNET_INVALID_OPERATION             
              lcMessage = "ERROR_INTERNET_INVALID_OPERATION"

         CASE lnError =  ERROR_INTERNET_OPERATION_CANCELLED           
              lcMessage = "ERROR_INTERNET_OPERATION_CANCELLED"

         CASE lnError =  ERROR_INTERNET_INCORRECT_HANDLE_TYPE         
              lcMessage = "ERROR_INTERNET_INCORRECT_HANDLE_TYPE"

         CASE lnError =  ERROR_INTERNET_INCORRECT_HANDLE_STATE        
              lcMessage = "ERROR_INTERNET_INCORRECT_HANDLE_STATE"

         CASE lnError =  ERROR_INTERNET_NOT_PROXY_REQUEST             
              lcMessage = "ERROR_INTERNET_NOT_PROXY_REQUEST"

         CASE lnError =  ERROR_INTERNET_REGISTRY_VALUE_NOT_FOUND      
              lcMessage = "ERROR_INTERNET_REGISTRY_VALUE_NOT_FOUND"

         CASE lnError =  ERROR_INTERNET_BAD_REGISTRY_PARAMETER        
              lcMessage = "ERROR_INTERNET_BAD_REGISTRY_PARAMETER"

         CASE lnError =  ERROR_INTERNET_NO_DIRECT_ACCESS              
              lcMessage = "ERROR_INTERNET_NO_DIRECT_ACCESS"

         CASE lnError =  ERROR_INTERNET_NO_CONTEXT                    
              lcMessage = "ERROR_INTERNET_NO_CONTEXT"

         CASE lnError =  ERROR_INTERNET_NO_CALLBACK                   
              lcMessage = "ERROR_INTERNET_NO_CALLBACK"

         CASE lnError =  ERROR_INTERNET_REQUEST_PENDING               
              lcMessage = "ERROR_INTERNET_REQUEST_PENDING"

         CASE lnError =  ERROR_INTERNET_INCORRECT_FORMAT              
              lcMessage = "ERROR_INTERNET_INCORRECT_FORMAT"

         CASE lnError =  ERROR_INTERNET_ITEM_NOT_FOUND                
              lcMessage = "ERROR_INTERNET_ITEM_NOT_FOUND"

         CASE lnError =  ERROR_INTERNET_CANNOT_CONNECT                
              lcMessage = "ERROR_INTERNET_CANNOT_CONNECT"

         CASE lnError =  ERROR_INTERNET_CONNECTION_ABORTED            
              lcMessage = "ERROR_INTERNET_CONNECTION_ABORTED"

         CASE lnError =  ERROR_INTERNET_CONNECTION_RESET              
              lcMessage = "ERROR_INTERNET_CONNECTION_RESET"

         CASE lnError =  ERROR_INTERNET_FORCE_RETRY                   
              lcMessage = "ERROR_INTERNET_FORCE_RETRY"

         CASE lnError =  ERROR_INTERNET_INVALID_PROXY_REQUEST         
              lcMessage = "ERROR_INTERNET_INVALID_PROXY_REQUEST"

         CASE lnError =  ERROR_INTERNET_NEED_UI                       
              lcMessage = "ERROR_INTERNET_NEED_UI"

         CASE lnError =  ERROR_INTERNET_HANDLE_EXISTS                 
              lcMessage = "ERROR_INTERNET_HANDLE_EXISTS"

         CASE lnError =  ERROR_INTERNET_SEC_CERT_DATE_INVALID         
              lcMessage = "ERROR_INTERNET_SEC_CERT_DATE_INVALID"

         CASE lnError =  ERROR_INTERNET_SEC_CERT_CN_INVALID           
              lcMessage = "ERROR_INTERNET_SEC_CERT_CN_INVALID"

         CASE lnError =  ERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR        
              lcMessage = "ERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR"

         CASE lnError =  ERROR_INTERNET_HTTPS_TO_HTTP_ON_REDIR        
              lcMessage = "ERROR_INTERNET_HTTPS_TO_HTTP_ON_REDIR"

         CASE lnError =  ERROR_INTERNET_MIXED_SECURITY                
              lcMessage = "ERROR_INTERNET_MIXED_SECURITY"

         CASE lnError =  ERROR_INTERNET_CHG_POST_IS_NON_SECURE        
              lcMessage = "ERROR_INTERNET_CHG_POST_IS_NON_SECURE"

         CASE lnError =  ERROR_INTERNET_POST_IS_NON_SECURE            
              lcMessage = "ERROR_INTERNET_POST_IS_NON_SECURE"

         CASE lnError =  ERROR_INTERNET_CLIENT_AUTH_CERT_NEEDED       
              lcMessage = "ERROR_INTERNET_CLIENT_AUTH_CERT_NEEDED"

         CASE lnError =  ERROR_INTERNET_INVALID_CA                    
              lcMessage = "ERROR_INTERNET_INVALID_CA"

         CASE lnError =  ERROR_INTERNET_CLIENT_AUTH_NOT_SETUP         
              lcMessage = "ERROR_INTERNET_CLIENT_AUTH_NOT_SETUP"

         CASE lnError =  ERROR_INTERNET_ASYNC_THREAD_FAILED           
              lcMessage = "ERROR_INTERNET_ASYNC_THREAD_FAILED"

         CASE lnError =  ERROR_INTERNET_REDIRECT_SCHEME_CHANGE        
              lcMessage = "ERROR_INTERNET_REDIRECT_SCHEME_CHANGE"

         CASE lnError =  ERROR_INTERNET_DIALOG_PENDING                
              lcMessage = "ERROR_INTERNET_DIALOG_PENDING"

         CASE lnError =  ERROR_INTERNET_RETRY_DIALOG                  
              lcMessage = "ERROR_INTERNET_RETRY_DIALOG"

         CASE lnError =  ERROR_INTERNET_HTTPS_HTTP_SUBMIT_REDIR       
              lcMessage = "ERROR_INTERNET_HTTPS_HTTP_SUBMIT_REDIR"

         CASE lnError =  ERROR_INTERNET_INSERT_CDROM                  
              lcMessage = "ERROR_INTERNET_INSERT_CDROM"

         CASE lnError =  FTP_TRANSFER_IN_PROGRESS            	     
              lcMessage = "FTP_TRANSFER_IN_PROGRESS"

         CASE lnError =  FTP_DROPPED                         	     
              lcMessage = "FTP_DROPPED"

         CASE lnError =  FTP_NO_PASSIVE_MODE                          
              lcMessage = "FTP_NO_PASSIVE_MODE"

         CASE lnError =  ERROR_INTERNET_SECURITY_CHANNEL_ERROR        
              lcMessage = "ERROR_INTERNET_SECURITY_CHANNEL_ERROR"

         CASE lnError =  ERROR_INTERNET_UNABLE_TO_CACHE_FILE          
              lcMessage = "ERROR_INTERNET_UNABLE_TO_CACHE_FILE"

         CASE lnError =  ERROR_INTERNET_TCPIP_NOT_INSTALLED           
              lcMessage = "ERROR_INTERNET_TCPIP_NOT_INSTALLED"

         CASE lnError =  ERROR_INTERNET_DISCONNECTED                  
              lcMessage = "ERROR_INTERNET_DISCONNECTED"

         CASE lnError =  ERROR_INTERNET_SERVER_UNREACHABLE            
              lcMessage = "ERROR_INTERNET_SERVER_UNREACHABLE"

         CASE lnError =  ERROR_INTERNET_PROXY_SERVER_UNREACHABLE      
              lcMessage = "ERROR_INTERNET_PROXY_SERVER_UNREACHABLE"

         CASE lnError =  ERROR_INTERNET_BAD_AUTO_PROXY_SCRIPT         
              lcMessage = "ERROR_INTERNET_BAD_AUTO_PROXY_SCRIPT"

         CASE lnError =  ERROR_INTERNET_UNABLE_TO_DOWNLOAD_SCRIPT     
              lcMessage = "ERROR_INTERNET_UNABLE_TO_DOWNLOAD_SCRIPT"

         CASE lnError =  ERROR_INTERNET_SEC_INVALID_CERT    		     
              lcMessage = "ERROR_INTERNET_SEC_INVALID_CERT"

         CASE lnError =  ERROR_INTERNET_SEC_CERT_REVOKED    		     
              lcMessage = "ERROR_INTERNET_SEC_CERT_REVOKED"

         CASE lnError =  ERROR_NO_MORE_FILES
              lcMessage = "ERROR_NO_MORE_FILES"

         CASE lnError =  ERROR_INVALID_HANDLE
              lcMessage = "ERROR_INVALID_HANDLE"

         CASE lnError =  ERROR_FILE_NOT_FOUND
              lcMessage = "ERROR_FILE_NOT_FOUND"

         CASE lnError =  ERROR_PATH_NOT_FOUND
              lcMessage = "ERROR_PATH_NOT_FOUND"

         CASE lnError =  ERROR_ACCESS_DENIED
              lcMessage = "ERROR_ACCESS_DENIED"

         CASE lnError =  ERROR_FILE_EXISTS
              lcMessage = "ERROR_FILE_EXISTS"

         CASE lnError =  ERROR_INVALID_PARAMETER
              lcMessage = "ERROR_INVALID_PARAMETER"

         OTHERWISE	
              lcMessage = "Unknown Error Message"
      ENDCASE
      RETURN lcMessage
   ENDPROC


   ****************************************************
   PROTECTED PROCEDURE GetSystemOption(INP liOption) && Return any system option
      *!*   <pdm_sc_yes/>
      *!*   <pdm_dd_yes/>

      DO CASE
         CASE liOption=_FTPS_Option_CurrentDir
              RETURN This.cCurrentDir

         CASE liOption=_FTPS_Option_DLL_Loaded
              RETURN This.lDLL_Loaded

         CASE liOption=_FTPS_Option_Inet_Handle
              RETURN This.nInet_Handle

         CASE liOption=_FTPS_Option_Connect_Handle
              RETURN This.nConnect_Handle

         CASE liOption=_FTPS_Option_IPAddress
              RETURN This.cIPAddress

         CASE liOption=_FTPS_Option_UserName
              RETURN This.cUserName

         CASE liOption=_FTPS_Option_Password
              RETURN This.cPassword

         CASE liOption=_FTPS_Option_Port
              RETURN This.cPort

         CASE liOption=_FTPS_Option_UseProxy
              RETURN This.lUseProxy

         OTHERWISE
              RETURN .NULL.
      ENDCASE
   ENDPROC



ENDDEFINE


DEFINE CLASS _LIST_PARSER AS CUSTOM
   oFTP=.NULL. && FTPClass instance
   cMonths=",jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec,"

   PROCEDURE FindDT(INPREF lcData)
      *!*   <pdm_sc_yes/>
      *!*   <pdm_dd_yes/>
      LOCAL liAT,liy,liz,lcPom,liCnt,lcRow
      lcRow=LOWER(lcData)
      liCnt =OCCURS(",",This.cMonths)-1
      liAT=0
      FOR liy=1 TO liCnt
          liz=AT(",",This.cMonths,liy)
          lcMonth=SUBSTR(This.cMonths,liz+1,AT(",",This.cMonths,liy+1)-liz-1)

          FOR liz=1 TO OCCURS(lcMonth,lcRow)
              liAT=RAT(lcMonth,lcRow,liz)
              IF liAT=0
                 LOOP
              ENDIF
              lcPom=SUBSTR(lcData,liAT) && datetime info
              IF (SUBSTR(lcPom,4,1)=" " AND SUBSTR(lcPom,7,1)=" " AND VAL(SUBSTR(lcPom,5,2))>0 AND ;
                  VAL(SUBSTR(lcPom,8,2))>0 AND SUBSTR(lcPom,10,1)=":" AND VAL(SUBSTR(lcPom,11,2))>0) OR;
                 (SUBSTR(lcPom,4,1)=" " AND SUBSTR(lcPom,7,2)=" " AND VAL(SUBSTR(lcPom,5,2))>0 AND ;
                  VAL(SUBSTR(lcPom,9,4))>0)
                 EXIT
              ENDIF
              liAT=0
          NEXT
          IF liAT>0
             EXIT
          ENDIF
      NEXT
      RETURN liAT && Fail at parsing file
   ENDPROC

   PROCEDURE FormatDT(INPREF lcDT)
      *!*   <pdm_sc_yes/>
      *!*   <pdm_dd_yes/>
      LOCAL liMonth,lcRet
      liMonth=ATC(","+LEFT(lcDT,3)+",",This.cMonths)
      liMonth=OCCURS(",",LEFT(This.cMonths,liMonth))

      IF AT(":",lcDT)>0 && Time 
         lcRet=EVALUATE("{^"+STR(YEAR(DATE()))+"-"+;
               LTRIM(STR(liMonth,2))+;
               "-"+LTRIM(SUBSTR(lcDT,5,2))+" "+SUBSTR(lcDT,8,5)+":00}")
      ELSE
         lcRet=EVALUATE("{^"+SUBSTR(lcDT,9,4)+"-"+;
               LTRIM(STR(liMonth,2))+;
               "-"+LTRIM(SUBSTR(lcDT,5,2))+" 00:00:00}")
      ENDIF
      RETURN lcRet
   ENDPROC

ENDDEFINE

DEFINE CLASS _LIST_PARSER_1 AS _LIST_PARSER && UNIX list parser
*!*       /* "         10        20        30        40        50        60
*!*       /* "1234567890123456789012345678901234567890123456789012345678901234567890"
*!*       /* UNIX-style listing, without inum and without blocks */
*!*       /* "-rw-r--r--   1 root     other        531 Jan 29 03:26 README" */
*!*       /* "dr-xr-xr-x   2 root     other        512 Apr  8  1994 etc" */
*!*       /* "dr-xr-xr-x   2 root                  512 Apr  8  1994 etc" */
*!*       /* "lrwxrwxrwx   1 root     other          7 Jan 25 00:17 bin -> usr/bin" */

*!*       /* "-rwxrwx---   1 gorila   www-data       49 May 27  2006 dbc.css
*!*       /* "-rwxrwx---   1 gorila   www-data      620 May 27  2006 dbc.html
*!*       /* "-rwxrwx---   1 gorila   www-data       33 May 27  2006 devcon.css
*!*       /* "-rwxrwx---   1 gorila   www-data      806 May 27  2006 devcon.html
*!*       /* "-rwxrwx---   1 gorila   www-data       37 May 27  2006 dumpfll.css
*!*       /* "-rwxrwx---   1 gorila   www-data      853 May 27  2006 dumpfll.html
*!*       /* "drwxrwx---   2 gorila   www-data     4096 Jan 10  2007 bw
*!*       /* "drwxr-xr-x   2 gorila   www-data     4096 Aug 30 07:27 canal

*!*       /* Also NetPresenz for the Mac: */
*!*       /* "-------r--         326  1391972  1392298 Nov 22  1995 MegaPhone.sit" */
*!*       /* "drwxrwxr-x               folder        2 May 10  1996 network" */

*!*       /* Also produced by Microsoft's FTP servers for Windows: */
*!*       /* "----------   1 owner    group   .     1803128 Jul 10 10:18 ls-lR.Z" */
*!*       /* "d---------   1 owner    group               0 May  9 19:45 Softlib" */
*!*       /* Also WFTPD for MSDOS: */
*!*       /* "-rwxrwxrwx   1 noone    nogroup           322 Aug 19  1996 message.ftp" */

         * [x, 1] = File Attributes - 1
         * [x, 2] = Links count     - 2
         * [x, 3] = Owner           - 3
         * [x, 4] = Group           - 4
         * [x, 5] = File Size       - 5
         * [x, 6] = File Last Write Time () - 6+7+8
         * [x, 7] = File Name       - 9

   PROCEDURE Parse(CHNGREF laFiles,INP loEngine)
      *!*   <pdm_sc_yes/>
      *!*   <pdm_dd_yes/>
      EXTERNAL ARRAY laFiles
      LOCAL liEnd,lcData,lii,liAT,liy,liz,lcPom,lnFileSize
      DIMENSION laFiles(100,7)
      liEnd=AT(CRLF,loEngine.cData,1)
      lii=0
      DO WHILE liEnd>0
         lcData=LEFT(loEngine.cData,liEnd-1)
         loEngine.cData=SUBSTR(loEngine.cData,liEnd+2)
         liEnd=AT(CRLF,loEngine.cData,1)
        
         lii=lii+1
         IF lii>ALEN(laFiles,1)
            DIMENSION laFiles(lii+100,7)
         ENDIF            
         * Row processing
         laFiles(lii,1)=SUBSTR(lcData,1,10)
         laFiles(lii,2)=VAL(SUBSTR(lcData,12,3))

         * Check where is: "Mon Da HH:MM" or "Mon Da  YYYY"
         liAT=This.FindDT(@lcData)
         IF liAT=0 && Fail at parsing file
            This.oFTP.SetExtendedError(_FTPS_UE_PLF,lcRow)
            RETURN .F.
         ENDIF

         * Date last modify
         laFiles(lii,6)=This.FormatDT(SUBSTR(lcData,liAT,12))

         * File name
         laFiles(lii,7)=SUBSTR(lcData,liAT+13)

         * from 16. char to liAT-2 are three columns
         lcPom=ALLTRIM(SUBSTR(lcData,16,liAT-16-1))
         liy=AT(" ",lcPom)
         liz=RAT(" ",lcPom)
         laFiles(lii,3)=ALLTRIM(LEFT(lcPom,liy-1))      && Owner
         laFiles(lii,4)=ALLTRIM(SUBSTR(lcPom,liy+1,liz-1-liy))      && Group
*         laFiles(lii,5)=VAL(SUBSTR(lcPom,liz+1)) && Size
         IF This.oFTP.GetFileSize(laFiles(lii,7),@lnFileSize)
            laFiles(lii,5)=lnFileSize
         ENDIF

      ENDDO
      IF lii>0 AND lii<>ALEN(laFiles,1)
         DIMENSION laFiles(lii,7)
      ENDIF
      RETURN .T.
   ENDPROC
ENDDEFINE

DEFINE CLASS _LIST_PARSER_2 AS _LIST_PARSER_1 && WIN List Parser
ENDDEFINE

DEFINE CLASS _LIST_PARSER_3 AS _LIST_PARSER_1 && DOS List Parser
ENDDEFINE


DEFINE CLASS _LIST_PARSER_5 AS _LIST_PARSER_1 && Mac List Parser
ENDDEFINE



DEFINE CLASS _LIST_PARSER_4 AS _LIST_PARSER && NOVELL list parser
*!*       /* "         10        20        30        40        50        60
*!*       /* "1234567890123456789012345678901234567890123456789012345678901234567890"
*!*       /* Also NetWare: */
*!*       /* "d [R----F--] supervisor            512       Jan 16 18:53    login" */
*!*       /* "- [R----F--] rhesus             214059       Oct 20 15:27    cx.exe" */

         * [x, 1] = File Attributes - 1
         * [x, 2] = Links count     - 2
         * [x, 3] = Owner           - 3
         * [x, 4] = Group           - 4
         * [x, 5] = File Size       - 5
         * [x, 6] = File Last Write Time () - 6+7+8
         * [x, 7] = File Name       - 9

   PROCEDURE Parse(CHNGREF laFiles,INP loEngine)
      *!*   <pdm_sc_yes/>
      *!*   <pdm_dd_yes/>
      EXTERNAL ARRAY laFiles
      LOCAL liEnd,lcData,lii,liAT,liy,liz,lcPom,lnFileSize
      DIMENSION laFiles(100,7)
      liEnd=AT(CRLF,loEngine.cData,1)
      lii=0

      DO WHILE liEnd>0
         lcData=LEFT(loEngine.cData,liEnd-1)
         loEngine.cData=SUBSTR(loEngine.cData,liEnd+2)
         liEnd=AT(CRLF,loEngine.cData,1)
        
         lii=lii+1
         IF lii>ALEN(laFiles,1)
            DIMENSION laFiles(lii+100,7)
         ENDIF            
         * Row processing
         laFiles(lii,1)=LEFT(lcData,1)+SUBSTR(lcData,4,8)
         laFiles(lii,2)=0

         * Check where is: "Mon Da HH:MM" or "Mon Da  YYYY"
         liAT=This.FindDT(@lcData)
         IF liAT=0 && Fail at parsing file
            This.oFTP.SetExtendedError(_FTPS_UE_PLF,lcRow)
            RETURN .F.
         ENDIF

         * Date last modify
         laFiles(lii,6)=This.FormatDT(SUBSTR(lcData,liAT,12))

         * File name
         laFiles(lii,7)=RTRIM(SUBSTR(lcData,liAT+13))

         * from 16. char to liAT-2 are two columns
         lcPom=ALLTRIM(SUBSTR(lcData,14,liAT-14-1))
         liy=AT(" ",lcPom)
         laFiles(lii,3)=ALLTRIM(LEFT(lcPom,liy-1))      && Owner
         laFiles(lii,4)=""     && Group
*         laFiles(lii,5)=VAL(ALLT(SUBSTR(lcPom,liy+1))) && Size
         IF This.oFTP.GetFileSize(laFiles(lii,7),@lnFileSize)
            laFiles(lii,5)=lnFileSize
         ENDIF

      ENDDO
      IF lii>0 AND lii<>ALEN(laFiles,1)
         DIMENSION laFiles(lii,7)
      ENDIF
      RETURN .T.
   ENDPROC
ENDDEFINE


DEFINE CLASS _LIST_PARSER_0 AS _LIST_PARSER && EPFL list parser
*!*       /* "         10        20        30        40        50        60
*!*       /* "1234567890123456789012345678901234567890123456789012345678901234567890"
*!*       /* Also EPFL: */
*!*       /* "+i8388621.29609,m824255902,/,\tdev" */
*!*       /* "+i8388621.44468,m839956783,r,s10376,\tRFCEPLF" */

             * http://cr.yp.to/ftp/list/eplf.html

         * [x, 1] = File Attributes - 1
         * [x, 2] = Links count     - 2
         * [x, 3] = Owner           - 3
         * [x, 4] = Group           - 4
         * [x, 5] = File Size       - 5
         * [x, 6] = File Last Write Time () - 6+7+8
         * [x, 7] = File Name       - 9

   PROCEDURE Parse(CHNGREF laFiles,INP loEngine)
      *!*   <pdm_sc_yes/>
      *!*   <pdm_dd_yes/>
      EXTERNAL ARRAY laFiles
      LOCAL liEnd,lcData,lii,liy,liz,lcPom,lnFileSize,liAT,liATE
      DIMENSION laFiles(100,7)
      liEnd=AT("\015\012",loEngine.cData,1)
      lii=0

      DO WHILE liEnd>0
         lcData=SUBSTR(loEngine.cData,2,liEnd-2)
         loEngine.cData=SUBSTR(loEngine.cData,liEnd+2)
         liEnd=AT("\015\012",loEngine.cData,1)
        
         lii=lii+1
         IF lii>ALEN(laFiles,1)
            DIMENSION laFiles(lii+100,7)
         ENDIF            

         liy=OCCURS(",",lcData)+1
         * Row processing

         FOR liz=1 TO liy
             liAT=IIF(liz=1,1,AT(",",lcData,liz-1)+1)
             liATE=IIF(liz<liy-1,AT(",",lcData,liz)-1,LEN(lcData))
             lcPom=SUBSTR(lcData,liAT,liATE-liAT)

             DO CASE
                CASE LEFT(lcPom,1)='i'

                CASE LEFT(lcPom,1)='m'
                    * Date last modify
                    laFiles(lii,6)={^1970-01-01 00:00:00}+VAL(SUBSTR(lcPom,2))

                CASE LEFT(lcPom,1)='r' OR LEFT(lcPom,1)='/'
                     laFiles(lii,1)=lcPom

                CASE LEFT(lcPom,1)='s'
                     laFiles(lii,5)=VAL(ALLT(SUBSTR(lcPom,2))) && Size
*!*	                     IF This.oFTP.GetFileSize(laFiles(lii,7),@lnFileSize)
*!*	                        laFiles(lii,5)=lnFileSize
*!*	                     ENDIF

                OTHERWISE
                    * Name of file
                    laFiles(lii,7)=STRTRAN(lcPom,"\t","")

             ENDCASE
         NEXT

         laFiles(lii,2)=0
      ENDDO
      IF lii>0 AND lii<>ALEN(laFiles,1)
         DIMENSION laFiles(lii,7)
      ENDIF
      RETURN .T.
   ENDPROC
ENDDEFINE

DEFINE CLASS _LIST_PARSER_ENGINE AS _LIST_PARSER

   cData="" && Data for parsing

   PROCEDURE Parse(CHNGREF laFiles,INPREF lcData)
      *!*   <pdm_sc_yes/>
      *!*   <pdm_dd_yes/>
      LOCAL liFormat,loParser,llRet
      This.cData=lcData
      lcData="" && freeze
    
      liFormat=This.CheckFormat()
      
      IF !PEMSTATUS(This,"PL"+STR(liFormat,1),5)
         This.AddObject("PL"+STR(liFormat,1),"_LIST_PARSER_"+STR(liFormat,1))
      ENDIF
      loParser=EVALUATE("This.PL"+STR(liFormat,1))
      loParser.oFTP=This.oFTP
      llRet=loParser.Parse(@laFiles,This)
      loParser.oFTP=.NULL.
      RETURN llRet
   ENDPROC

   PROCEDURE CheckFormat
      *!*   <pdm_sc_yes/>
      *!*   <pdm_dd_yes/>
      IF AT("\015\012",This.cData)>0 OR LEFT(This.cData,1)="+"
         RETURN _FTPC_PL_EPLF
      ENDIF

      IF SUBST(This.cData,2,1)=" "
         RETURN _FTPC_PL_NWL
      ENDIF

      RETURN _FTPC_PL_UNIX && _FTPC_PL_MSWIN,_FTPC_PL_DOC, _FTPC_PL_MAC
      * fòuk, fnuk, I'm lazy : http://cr.yp.to/ftpparse/ftpparse.c
ENDDEFINE