#pragma execution_character_set("utf-8")

/************************************************************************
* CopyRight (c) 2015,深圳市海邻科信息技术有限公司     
* All rights reserved.
*
* 文件名：			FaceLib.h
* 摘要：			人脸裁切API接口头文件
* 当前版本：		1.0
* 作者：			张军杰
* 完成日期：		2015年10月13日
************************************************************************/
#ifdef FACELIB_EXPORTS
#define FACELIB_API __declspec(dllexport)
#else
#define FACELIB_API __declspec(dllimport)
#endif


extern "C"
{
	//***************************************************************************************************
	// Method:    InitFaceRecognition
	// Returns:   int	(0 = Successful -1 = Failed 已存在实例 )
	// Parameter: void
	// description:初始化人脸抓取模块实例
	//***************************************************************************************************
	FACELIB_API int	InitFaceRecognition( void );

	//***************************************************************************************************
	// Method:    ImportFaceImgByPath
	// Returns:   int	(0 = Successful -1 = Failed 实例不存在)
	// Parameter: char *pstrPath 
	// description:导入识别图片支持jpg、png，bmp格式
	//***************************************************************************************************
	FACELIB_API int ImportFaceImgByPath( char *pstrPath );

	//***************************************************************************************************
	// Method:    SetSnapFaceRange
	// Returns:   int	(0 = Successful -1 = Failed 实例不存在)
	// Parameter: float fScale缩放因子（如缩放比率为1只抓脸， float fRatio（高宽比）
	// description:设置抓取人脸缩放因子（默认1.0）
	//***************************************************************************************************	
	FACELIB_API int SetSnapFaceRange( float fScale, float fRatio);

	//***************************************************************************************************
	// Method:    StartFaceRecog
	// Returns:   int	(1 = Successful  0 = Error加载识别资源/图片无效  -1 = Failed实例不存在)
	// Parameter: void
	// description:启动人像抓取
	//***************************************************************************************************
	FACELIB_API int StartFaceRecog( void );

	//***************************************************************************************************
	// Method:    GetSnapImgPath
	// Returns:   char* 返回抓取的图片路径（为当前应用路径）
	// Parameter: void
	// description:返回抓取图片路径
	//***************************************************************************************************
	FACELIB_API char* GetSnapImgPath( void );

	//***************************************************************************************************
	// Method:    ReleaseResource
	// Returns:   int	(0 = Successful -1 = Failed 实例为空)
	// Parameter: void
	// description:释放人脸抓取模块资源
	//***************************************************************************************************
	FACELIB_API int ReleaseResource();
};
