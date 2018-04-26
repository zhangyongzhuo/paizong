
#ifndef _PLATE_OCR_H____
#define _PLATE_OCR_H____

#ifdef __cplusplus
extern "C"
{
#endif

	//************************************
	// Method:    HyInitPlateOCR
	// Returns:   int   返回0为初始化成功, 非0为失败,通常原因是模块license过期
	// Qualifier: 初始化车牌识别模块,必须且只需在使用前调用一次.
	// Parameter: void
	//************************************
	int					HyInitPlateOCR( void ); 
		//************************************
	// Method:    HyInitPlateOCROEM
	// Returns:   int   返回0为初始化成功, 非0为失败, 此为软件OEM授权，需要传入指定的授权密码。
	// Qualifier: 初始化车牌识别模块,必须且只需在使用前调用一次.
	// Parameter: const char* szLicense  授权密码   64字节
	//************************************
	int					HyInitPlateOCROEM( const char* szLicense ); 
		//************************************
	// Method:    HyGetPlateOcrLicenseVersion
	// Returns:   引擎库授权信息
	// Qualifier: 获取引擎库授权信息
	// Parameter: void
	//************************************
	const char*			HyGetPlateOcrLicenseVersion( void );
	//************************************
	// Method:    HyUninitPlateOCR
	// Returns:   int  返回0为成功.非0为失败,
	// Qualifier: 卸载车牌识别模块, 不再使用车牌识别时调用.
	// Parameter: void
	//************************************
	int 				HyUninitPlateOCR( void );
	//************************************
	// Method:    HySetProvinceOrder
	// Returns:  int  返回0为成功,返回-1为失败.
	// Qualifier: 设置优先省份(主要用于省份识别不清时)
	// Parameter: char * szProvince 省份字符串,如: “粤浙京” 最多可设置8个省份,    
	//************************************
	int					HySetProvinceOrder( char* szProvince );
	//************************************
	// Method:    HyGetPlateNoStringFromBmp
	// Returns:   char*  识别失败,返回NULL,成功则返回车牌号字符串
	// Qualifier:  从BMP图像的数据中识别车牌字串
	// Parameter: void * pImageBuf		图像数据区首地址
	// Parameter: int nBufSize			图像数据区大小
	//************************************
	char*				HyGetPlateNoStringFromBmp( void* pImageBuf,int nBufSize );		
	//************************************
	// Method:    HyGetPlateNoStringFromJpg
	// Returns:   char*  识别失败,返回NULL,成功则返回车牌号字符串
	// Qualifier: 从图像文件中识别车牌字串
	// Parameter: char * szPathFileName		图片的文件路径(可以是JPG或BMP图片)
	//************************************
	char*				HyGetPlateNoStringFromFile( char* szPathFileName );	

	//************************************
	// Method:    HyGetPlateColor
	// Returns:   PLATEOCRDLL_API char*   成功：返回车牌颜色字符串  失败：NULL
	// Qualifier:    获取车牌颜色
	// Parameter: void
	//************************************
	char*				HyGetPlateColor( void );
	//************************************
	// Method:    HySavePlateImageToFile
	// Returns:   PLATEOCRDLL_API int   成功：0  失败：-1
	// Qualifier:     获取车牌的图片（从识别图片中截取的车牌图像）,保存成JPG格式
	// Parameter: char * szPathFileName    图片的保存路径
	//************************************
	int					HySavePlateImageToFile( char* szPathFileName );
	//************************************
	// Method:    HyGetPlateImageMem
	// Returns:   PLATEOCRDLL_API int  成功：0  失败：-1
	// Qualifier:    获取车牌图片BMP格式数据（包含BITMAPFILEINFO文件头，可以直接写成图片文件），
				// 此函数使用时，须先给pImage传入NULL，根据pSize返回的值申请内存后再次调用。
	// Parameter: void * pImage      传入参数： 动态内存首地址 
	// Parameter: int * pSize       传入传出参数：  动态内存大小变量的指针
	//************************************
	int					HyGetPlateImageMem( void* pImage,int* pSize );
#ifdef __cplusplus
};
#endif
#endif
