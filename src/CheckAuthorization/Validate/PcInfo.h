
#ifdef PCINFO_EXPORTS
#define PCINFO_API __declspec(dllexport)
#else
#define PCINFO_API __declspec(dllimport)
#endif

#ifndef __HYLINK_PCINFO_H__
#define __HYLINK_PCINFO_H__

#ifdef __cplusplus
extern "C"
{
#endif

	//************************************
	// Method:    IsHylinkProduct			是否深圳海邻科产品
	// Returns:   int						返回0: 为海邻科X3系列平板; 返回1:为海邻科其它系列产品; 返回-1:其它公司产品
	// Parameter: void						无参数
	//************************************
	PCINFO_API int IsHylinkProduct( void );

	//************************************
	// Method:    GetHylinkDeviceId
	// Returns:   PCINFO_API char*			ansi字符串,成功返回字符串, 失败或非海邻科产品，则返回ERROR字符串
	// Parameter: void
	//************************************
	PCINFO_API char* GetHylinkDeviceId( void );

#ifdef __cplusplus
}
#endif

#endif

