#ifndef _VFP2CNETAPI_H__
#define _VFP2CNETAPI_H__

#include <Lm.h>

#define NETAPI_INFO_SIZE		1024
#define NETAPI_BUFFER_SIZE		8192

// typedef's for runtime dynamic linking
typedef NET_API_STATUS (_stdcall *PNETAPIBUFFERALLOCATE)(DWORD,LPVOID*); // NetApiBufferAllocate
typedef NET_API_STATUS (_stdcall *PNETAPIBUFFERFREE)(LPVOID); // NetApiBufferFree
typedef NET_API_STATUS (_stdcall *PNETAPIBUFFERREALLOCATE)(LPVOID,DWORD,LPVOID*); // NetApiBufferReallocate
typedef NET_API_STATUS (_stdcall *PNETAPIBUFFERSIZE)(LPVOID,LPDWORD); // NetApiBufferSize
typedef NET_API_STATUS (_stdcall *PNETFILEENUM)(LPWSTR,LPWSTR,LPWSTR,DWORD,LPBYTE*,DWORD,LPDWORD,LPDWORD,PDWORD_PTR); // NetFileEnum
typedef NET_API_STATUS (_stdcall *PNETREMOTETOD)(LPCWSTR,LPBYTE*); // NetRemoteTOD
typedef NET_API_STATUS (_stdcall *PNETSERVERENUM)(LPCWSTR, DWORD, LPBYTE *, DWORD, LPDWORD, LPDWORD, DWORD, LPCWSTR, LPDWORD); // NetServerEnum


class NetApiBuffer
{
public:
	NetApiBuffer() : m_Buffer(0) {}
	~NetApiBuffer();

	operator LPBYTE() { return m_Buffer; }
	operator LPBYTE*() { return &m_Buffer; }
	operator LPTIME_OF_DAY_INFO() { return reinterpret_cast<LPTIME_OF_DAY_INFO>(m_Buffer); }

private:
	LPBYTE m_Buffer;
};

#ifdef __cplusplus
extern "C" {
#endif

// function forward definitions
bool _stdcall VFP2C_Init_Netapi();
void _stdcall VFP2C_Destroy_Netapi();

void _fastcall ANetUsers(ParamBlk *parm);
void _fastcall ANetFiles(ParamBlk *parm);
void _fastcall ANetServers(ParamBlk *parm);
void _fastcall GetServerTime(ParamBlk *parm);
void _fastcall SyncToServerTime(ParamBlk *parm);

#ifdef __cplusplus
}
#endif // end of extern "C"

#endif // _VFP2CNETAPI_H__