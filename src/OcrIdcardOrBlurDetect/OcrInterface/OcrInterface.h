
#ifdef OCRINTERFACE_EXPORTS
#define OCRINTERFACE_API __declspec(dllexport)
#else
#define OCRINTERFACE_API __declspec(dllimport)
#endif

#ifndef __OCR_INTERFACE_H__
#define __OCR_INTERFACE_H__

typedef enum _en_section
{
	SEC_NAME     = 0,/* 姓名*/
	SEC_SEX      = 1,/* 性别*/
	SEC_FOLK     = 2,/* 民族*/
	SEC_BIRTHDAY = 3,/* 出生日期*/
	SEC_ADDRESS  = 4,/* 地址*/
	SEC_NUM      = 5,/* 号码*/
	SEC_ISSUE    = 6,/* 签发机关*/
	SEC_PERIOD   = 7/* 有效期限*/
}EnOcrSection;

#ifdef __cplusplus
extern "C"
{
#endif

	//************************************
	// Method:    HyInitOcr
	// Returns:   int   返回0为成功; 返回-1:引擎过期   返回-2: 引擎初始化失败
	// Qualifier: OCR模块初始化
	// Parameter: void
	//************************************
	OCRINTERFACE_API int			HyInitOcr( void );
	//************************************
	// Method:    HyInitOcrVolumeLicense
	// Returns:   int   返回0为成功; 返回-1:引擎过期   返回-2: 引擎初始化失败
	// Qualifier: 软件OEM授权版　OCR模块初始化
	// Parameter: const char* szLicense   //授权密码　　　//64字节密码
	//************************************
	OCRINTERFACE_API int			HyInitOcrOEM( const char* szLicense );
		//************************************
	// Method:    HyGetOcrLicenseVersion
	// Returns:   引擎库授权信息
	// Qualifier: 获取引擎库授权信息
	// Parameter: void
	//************************************
	OCRINTERFACE_API const char*	HyGetOcrLicenseVersion( void );
	//************************************
	// Method:    HyUnInitOcr
	// Returns:   int 返回0为成功; 返回非0为失败
	// Qualifier: OCR模块的卸载 及清理内存空间 
	// Parameter: void
	//************************************
	OCRINTERFACE_API int			HyUnInitOcr( void );	
	//************************************
	// Method:    HyOcr
	// Returns:   int   int 返回0为成功; 返回非0为失败
	// Qualifier:  对内存中bmp图片数据进行识别
	// Parameter: void * pImage   图片数据首地址
	// Parameter: int nBufSize   数据区块的大小
	//************************************
	OCRINTERFACE_API int			HyOcrImageMem( void* pImage,int nBufSize);
	//************************************
	// Method:    HyOcr
	// Returns:   int		返回0为成功; 返回非0为失败
	// Qualifier:	对图片文件进行识别
	// Parameter: char * szFilePathName   图片文件的路径
	//************************************
	OCRINTERFACE_API int			HyOcrImageFile( char* szFilePathName );
	//************************************
	// Method:    HyGetAllOcrStr
	// Returns:   char*  对图片识别得到的字符串
	// Qualifier:  输出对图片识别出的所有字符串
	// Parameter: void
	//************************************
	OCRINTERFACE_API char*			HyGetAllOcrStr( void );
	//************************************
	// Method:    HyGetOcrSectionStr
	// Returns:   char*	   对图片识别得到的 指定区域的字符串
	// Qualifier:	输出识别图片的 指定区域的字符串
	// Parameter: EnOcrSection enSection   身份证区域枚举变量
	//************************************
	OCRINTERFACE_API char*			HyGetOcrSectionStr( EnOcrSection enSection );
	//************************************
	// Method:    HyGetOcrHeadImage
	// Returns:   int   返回0为成功; 返回非0为失败
	// Qualifier: 获取识别图片中的人头像,保存到文件中
	// Parameter: char * szSaveFileName    人像的保存路径
	//************************************
	OCRINTERFACE_API int			HyGetOcrHeadImage( char* szSaveFileName );

	
#ifdef __cplusplus
};
#endif

#endif