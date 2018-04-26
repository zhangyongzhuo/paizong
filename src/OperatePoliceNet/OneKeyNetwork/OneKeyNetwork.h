#ifdef ONEKEYNETWORK_EXPORTS
#define ONEKEYNETWORK_API __declspec(dllexport)
#else
#define ONEKEYNETWORK_API __declspec(dllimport)
#endif

#ifndef __ONEKEY_NETWORK_H__
#define __ONEKEY_NETWORK_H__

#ifdef __cplusplus
extern "C"
{
#endif
	/********************************************************/
	//回调函数原型声明，
	//参数：bSuccess:是否执行成功
	//		strErrMsg:如果执行失败，返回字符串表明错误原因
	/********************************************************/
	typedef void ( *PCALLBACKFUNC)( BOOL bSuccess,LPCTSTR strErrMsg );

	/********************************************************/
	//执行一键联网操作，
	//参数：bOnline:是否联网   TRUE：联网  FALSE：断网
	//		pFunction：回调函数，操作情况由回调函数返回。
	//返回：没有意义，调用后直接返回0；
	/********************************************************/
	ONEKEYNETWORK_API int  fnOneKeyNetwork( BOOL bOnline,PCALLBACKFUNC pFunction = NULL );	
	
	/********************************************************/
	//回调函数原型声明，
	//参数：bConnect: 运营商网络（4G或3G）是否联接上 TRUE：网络连接 FALSE：网络断开
	/********************************************************/
	typedef void ( *PNETWORKCALLBACKFUNC)( BOOL bConnect );
	/********************************************************/
	//设置运营商网络发生变化的消息回调
	//参数：pFunction: 回调函数
	/********************************************************/
	ONEKEYNETWORK_API int  fnSetNetworkStatusCallback( PNETWORKCALLBACKFUNC pFunction );

	//执行一键VPN操作，
	//参数：bOnline:是否联网   TRUE：联网  FALSE：断网
	//		pFunction：回调函数，操作情况由回调函数返回。
	//返回：没有意义，调用后直接返回0；
	/********************************************************/
	ONEKEYNETWORK_API int  fnOneKeyVpn( BOOL bOnline,PCALLBACKFUNC pFunction = NULL );	
	
	// 检测是否已连运营商网络  
	ONEKEYNETWORK_API BOOL fnIsNetworkAlive( void );	
	
	// 是否连接VPN网络， 目前准确度低
	ONEKEYNETWORK_API BOOL fnIsVpnAlive( void );
	// 外网与VPN的综合， 目前准确度低
	ONEKEYNETWORK_API BOOL fnIsNetworkVpnAlive( void );

	// 是否密码已经存在
	ONEKEYNETWORK_API BOOL fnIsOneKeyPswExist( void );
	// 删除密码
	ONEKEYNETWORK_API BOOL fnDeleteOneKeyPsw( void );
	// 是否自动输入密码
	ONEKEYNETWORK_API BOOL	fnIsPswAutoInput( void );
	//设置自动输入密码
	ONEKEYNETWORK_API BOOL  fnSetOneKeyAutoInput( BOOL bAutoInput );
	//设置密码
	ONEKEYNETWORK_API BOOL  fnSetOneKeyPsw( LPCTSTR strPsw );
	//取密码
	ONEKEYNETWORK_API LPCTSTR fnGetOneKeyPsw( void );


#ifdef __cplusplus
};
#endif

#endif