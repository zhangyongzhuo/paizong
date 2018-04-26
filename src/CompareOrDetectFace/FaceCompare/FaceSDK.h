#ifdef SFACE_EXPORTS
#define SFACE_API __declspec(dllexport)
#else
#define SFACE_API __declspec(dllimport)
#include <windef.h>
#endif




 SFACE_API BOOL WINAPI FaceSDK_Start(int nPort, int nTimeout);
 SFACE_API float WINAPI FaceSDK_CMP(char *pName1, char *pName2);
 SFACE_API DWORD WINAPI FaceSDK_GetError();
 SFACE_API void WINAPI FaceSDK_Stop();




