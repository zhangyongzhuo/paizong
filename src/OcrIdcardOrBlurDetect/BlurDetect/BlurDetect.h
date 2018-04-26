#pragma once

#ifdef BLURDETECT_EXPORTS
#define BLURDETECT_API __declspec(dllexport)
#else
#define BLURDETECT_API __declspec(dllimport)
#endif

/************************************************************************
 *使用说明：根据自身对图片清晰度要求选择一个临界值，判断图片是否可用
************************************************************************/
extern "C"
{
	//************************************
	// Method:    ImageBlurDetect
	// Returns:   返回值范围：0^10,值越大表示图片越模糊
	// Qualifier: 通过指定的图片路径检测图片模糊度
	// Parameter: char * pstrPath:图片路径
	//************************************
	BLURDETECT_API int ImageBlurDetect(char *pstrPath);
	//************************************
	// Method:    ImageBufBlurDetect
	// Returns:   返回值范围：0^10,值越大表示图片越模糊
	// Qualifier: 通过图片数据检测图片模糊度
	// Parameter: BYTE * data:图片数据
	// Parameter: int width:图片像素宽度
	// Parameter: int height:图片像素高度
	//************************************
	BLURDETECT_API int ImageBufBlurDetect(unsigned char* imgData, int width, int height);
}
