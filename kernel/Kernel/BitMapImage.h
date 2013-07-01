#ifndef __BITMAPIMAGE_H_
#define __BITMAPIMAGE_H_

typedef struct {
	char mSignature[2]; // BM -> windows
	int mSize;
	char mReserved1[2]; // these depend on application
	char mReserved2[2];
	int mAddressOfPixelArray;
} bmpHeader;

typedef struct {
	int mHeaderSize; // must be 40!
	signed int mWidth;
	signed int mHeight;
	short mColorPlanes; // must be set to 1 !
	short mColorDepth;
	int mCompression;
	int mImageSize; // size of the PIXEL ARRAY NOT FILE
	int mPixelPerMeterHoriz;
	int mPixelPerMeterVert;
	int mNumberOfColorsInPalette;
	int mNumberOfImportantColors; // generally ignored
} bmpInfoHeader;

typedef struct {
	char B;
	char G;
	char R;
	char RES;
} bmpColor;

#endif