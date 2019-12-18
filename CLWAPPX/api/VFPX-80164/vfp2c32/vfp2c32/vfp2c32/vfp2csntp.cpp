#include <winsock2.h>
#include <math.h>

#include "pro_ext.h"
#include "vfp2c32.h"
#include "vfp2ccppapi.h"
#include "vfp2cwinsock.h"
#include "vfp2csntp.h"
#include "vfp2cutil.h"
#include "vfpmacros.h"

void _fastcall SyncToSNTPServer(ParamBlk *parm)
{
	SOCKET sSock = INVALID_SOCKET;
	SOCKADDR_IN sockAddr;
	SNTPPACKET sPacket;
	SNTPRESPONSE sResponse;
	SNTPTIME sReplyTime, sCorrectedTime;
	LPHOSTENT lphost;
	SYSTEMTIME sTime;
	DWORD dwTimeout;
	TIMEVAL sTimeout;
	double dClockOffset, dNewTime, dRequestSend, dRequestReceived, dReplySend, dReplyReceived;
	int nApiRet, nErrorRet = -1;
	fd_set fSockets;
	char *pServer;

	if (!NullTerminateValue(p1))
		RaiseError(E_INSUFMEMORY);

	LockHandle(p1);
	pServer = HandleToPtr(p1);

	dwTimeout = (PCOUNT() >= 3 && p3.ev_long) ? p3.ev_long : gnDefaultWinsockTimeOut;
	sTimeout.tv_sec = dwTimeout / 1000;
	sTimeout.tv_usec = dwTimeout % 1000;
	FD_ZERO(&fSockets);

	ZeroMemory(&sockAddr,sizeof(sockAddr));
	ZeroMemory(&sPacket,sizeof(sPacket));
	
	if (PCOUNT() >= 4 && p4.ev_long)
		sPacket.LiVnMode = (BYTE)SNTP_SET_VERSION(p4.ev_long) | SNTP_MODE_CLIENT;
	else
		sPacket.LiVnMode = SNTP_SET_VERSION(2) | SNTP_MODE_CLIENT;

	sockAddr.sin_family = AF_INET;
	sockAddr.sin_port = htons((PCOUNT() >= 2 && p2.ev_long) ? (unsigned short)p2.ev_long : SNTP_PORT);
	sockAddr.sin_addr.s_addr = inet_addr(pServer);

	if (sockAddr.sin_addr.s_addr == INADDR_NONE)
	{
		lphost = gethostbyname(pServer);
		if (lphost != NULL)
			sockAddr.sin_addr.s_addr = ((LPIN_ADDR)lphost->h_addr)->s_addr;
		else
		{
			SAVECUSTOMERROR("gethostbyname","Host not found.");
			goto ErrorOut;
		}
	}

	sSock = socket(AF_INET,SOCK_DGRAM,0);
	if (sSock == INVALID_SOCKET)
	{
		SAVECUSTOMERROREX("socket","Winsock last error: %I",WSAGetLastError());
		goto ErrorOut;
	}

	FD_SET(sSock,&fSockets);

	nApiRet = connect(sSock,(SOCKADDR*)&sockAddr,sizeof(sockAddr));
	if (nApiRet == SOCKET_ERROR)
	{
		SAVECUSTOMERROREX("connect","Winsock last error: %I",WSAGetLastError());
		goto ErrorOut;
	}

	// get current time
	GetSystemTime(&sTime);
	// convert into SNTP time format
	SystemTimeToSNTPTime(&sTime,&sPacket.OriginateTime);
	// convert into network byte order
	SNTPTimeToPacket(&sPacket.OriginateTime);

	nApiRet = send(sSock,(char*)&sPacket,sizeof(sPacket),0);
	if (nApiRet == SOCKET_ERROR)
	{
		SAVECUSTOMERROREX("send","Function failed. Winsock last error: %I",WSAGetLastError());
		goto ErrorOut;		
	}

	// wait till socket received reply or timed out
	nApiRet = select(0,&fSockets,0,0,&sTimeout);
	GetSystemTime(&sTime); // call this directly after to increase acuracy

	if (nApiRet == SOCKET_ERROR)
	{
		SAVECUSTOMERROREX("select","Function failed. Winsock last error %I",WSAGetLastError());
		goto ErrorOut;		
	}
	if (!nApiRet) // timed out
	{
		SAVECUSTOMERROR("select","SNTP request time out.");
		goto ErrorOut;
	}

	nApiRet = recv(sSock,(char*)&sResponse,sizeof(sResponse),0);
	if (nApiRet == SOCKET_ERROR)
	{
		SAVECUSTOMERROREX("recv","Function failed with Errorcode %I",WSAGetLastError());
		goto ErrorOut;
	}

	nApiRet = closesocket(sSock);
	if (nApiRet == SOCKET_ERROR)
	{
		SAVECUSTOMERROREX("closesocket","Function failed with errorcode %I",WSAGetLastError());
		goto ErrorOut;
	}
	sSock = INVALID_SOCKET; // set to INVALID_SOCKET .. so if an error occurs later on the socket is not closed again in the ErrorOut path

	// check SNTP response from server
	if (SNTP_GET_LEAP(sResponse.LiVnMode) == 3)
	{
		SAVECUSTOMERROR("SyncToSNTPServer","Response from SNTP server had warning leap indicator.");
		nErrorRet = -2;
		goto ErrorOut;
	}
	else if (!(sResponse.Stratum >= 1 && sResponse.Stratum <= 15))
	{

		SAVECUSTOMERROR("SyncToSNTPServer","Response from SNTP server had illegal stratum field.");
		nErrorRet = -3;
		goto ErrorOut;
	}
	else if (sResponse.TransmitTime.dwSeconds == 0)
	{
		SAVECUSTOMERROR("SyncToSNTPServer","Response from SNTP server had no valid time.");
		nErrorRet = -4;
		goto ErrorOut;
	}

	// convert times from network to host byte order
	PacketToSNTPTime(&sPacket.OriginateTime);
	PacketToSNTPTime(&sResponse.ReceiveTime);
	PacketToSNTPTime(&sResponse.TransmitTime);
	SystemTimeToSNTPTime(&sTime,&sReplyTime);

	dRequestSend = SNTPTimeToDouble(&sPacket.OriginateTime);
	dRequestReceived = SNTPTimeToDouble(&sResponse.ReceiveTime);
	dReplySend = SNTPTimeToDouble(&sResponse.TransmitTime);
	dReplyReceived = SNTPTimeToDouble(&sReplyTime);

	dClockOffset = ((dRequestReceived - dRequestSend) + (dReplySend - dReplyReceived)) / 2;
	dNewTime = dReplyReceived + dClockOffset;

	DoubleToSNTPTime(dNewTime,&sCorrectedTime);
	SNTPTimeToSystemTime(&sCorrectedTime,&sTime);

	if (!SetSystemTime(&sTime))
	{
		SAVEWIN32ERROR(SetSystemTime,GetLastError());
		goto ErrorOut;
	}

	UnlockHandle(p1);
	Return(1);
	return;

	ErrorOut:
		UnlockHandle(p1);
		if (sSock != INVALID_SOCKET)
			closesocket(sSock);
        Return(nErrorRet);
}

double _stdcall SNTPTimeToDouble(LPSNTPTIME pSntpTime)
{
	return ((double)pSntpTime->dwSeconds) + ((double)pSntpTime->dwFraction) * FRACTION_TO_MS / 1000;
}

void _stdcall DoubleToSNTPTime(double nTime, LPSNTPTIME pSntpTime)
{
	double dFractional, dSecs;
	dFractional = modf(nTime,&dSecs);
	pSntpTime->dwSeconds = static_cast<DWORD>(dSecs);
	pSntpTime->dwFraction = static_cast<DWORD>(ceil(dFractional * ((double)0xFFFFFFFF)));
}

void _stdcall SNTPTimeToPacket(LPSNTPTIME pSntpTime)
{
	pSntpTime->dwSeconds = htonl(pSntpTime->dwSeconds);
	pSntpTime->dwFraction = htonl(pSntpTime->dwFraction);
}

void _stdcall PacketToSNTPTime(LPSNTPTIME pSntpTime)
{
	pSntpTime->dwSeconds = ntohl(pSntpTime->dwSeconds);
	pSntpTime->dwFraction = ntohl(pSntpTime->dwFraction);
}

void _stdcall SystemTimeToSNTPTime(LPSYSTEMTIME pSysTime, LPSNTPTIME pSntpTime)
{
	long JulianDay;
	unsigned __int64 nSecs;

	JulianDay = CalcJulianDay(pSysTime->wYear,pSysTime->wMonth,pSysTime->wDay);
	JulianDay -= JAN_1ST_1900;
	
	nSecs = JulianDay;
	nSecs = (nSecs * 24) + pSysTime->wHour;
	nSecs = (nSecs * 60) + pSysTime->wMinute;
	nSecs = (nSecs * 60) + pSysTime->wSecond;

	pSntpTime->dwSeconds = static_cast<DWORD>(nSecs);
	pSntpTime->dwFraction = static_cast<DWORD>(ceil(pSysTime->wMilliseconds * MS_TO_FRACTION));
}

void _stdcall SNTPTimeToSystemTime(LPSNTPTIME pSntpTime, LPSYSTEMTIME pSysTime)
{
	long JulianDay;
	DWORD nSecs = pSntpTime->dwSeconds;
	pSysTime->wSecond = (WORD)(nSecs % 60);
	nSecs /= 60;
	pSysTime->wMinute = (WORD)(nSecs % 60);
	nSecs /= 60;
	pSysTime->wHour = (WORD)(nSecs % 24);
	nSecs /= 24;
	JulianDay = nSecs + JAN_1ST_1900;
	pSysTime->wDayOfWeek = (WORD)((JulianDay + 1) % 7);
	GetGregorianDate(JulianDay,&pSysTime->wYear,&pSysTime->wMonth,&pSysTime->wDay);
	pSysTime->wMilliseconds = (WORD)(((double)pSntpTime->dwFraction) * FRACTION_TO_MS + 0.5);
}