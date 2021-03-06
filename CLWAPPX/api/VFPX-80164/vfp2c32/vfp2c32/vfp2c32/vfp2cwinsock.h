#ifndef _VFP2CWINSOCK_H__
#define _VFP2CWINSOCK_H__

#define SAVEWINSOCKERROR(cFunc) SaveWinsockError(#cFunc)
#define DEFAULT_WINSOCK_TIMEOUT 4000
#define VFP2C_MAX_IP_LEN	16

#ifdef __cplusplus
extern "C" {
#endif

void _stdcall SaveWinsockError(char *pFunction);
bool _stdcall VFP2C_Init_Winsock();
void _stdcall VFP2C_Destroy_Winsock();

void _fastcall AIPAddresses(ParamBlk *parm);
void _fastcall ResolveHostToIp(ParamBlk *parm);

extern DWORD gnDefaultWinsockTimeOut;

#ifdef __cplusplus
}
#endif

#endif // _VFP2CWINSOCK_H__