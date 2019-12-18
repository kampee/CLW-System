*************************************************************************
*    File:	gpImage.prg
* Version:	1.6
* Created:	12.09.2002
*Modified:	09.11.2003
*  Author:	Alexander Golovlev
* Country:	Russian Federation
*   Email:	golovlev@yandex.ru
*************************************************************************

*************************************************************************
*    File:	gpImage.prg
* Version:	1.68
* Created:	12.09.2002
*Modified:	05.22.2005 by Cesar Chalom
* Country:	Brazil
*   Email:	cchalom@hotmail.com
*
*   Notes:  Added GRAPHICS CLASS functions under the authorization of Alexander Golovlev
*			Great information about GDIPLUS can be found at
*			http://www.bobpowell.net/, from where I got valuable information
*************************************************************************

*************************************************************************
*    File:	gpImage2.prg
* Version:	1.70
* Created:	12.09.2002
*   Notes:  All changes under the authorization of Cesar Chalom
*Modified:	2010.10.25 by VFPEncoding
*           Changed the name of the class gpImage2, incompatibility using
*           FoxyPreviewer and GDIPlus.vcx class of the \FFC class library
*Modified:	2010.11.29 by VFPEncoding
*           Include #DEFINE from gdImage2.h file
*************************************************************************

***************************
*** #INCLUDE gpImage2.h ***
***************************
*-- Encoder Values
#DEFINE EncoderValueCompressionLZW			2
#DEFINE EncoderValueCompressionCCITT3		3
#DEFINE EncoderValueCompressionCCITT4		4
#DEFINE EncoderValueCompressionRle			5
#DEFINE EncoderValueCompressionNone			6
#DEFINE EncoderValueTransformRotate90		13
#DEFINE EncoderValueTransformRotate180		14
#DEFINE EncoderValueTransformRotate270		15
#DEFINE EncoderValueTransformFlipHorizontal	16
#DEFINE EncoderValueTransformFlipVertical	17
#DEFINE EncoderValueMultiFrame				18
#DEFINE EncoderValueFrameDimensionTime		21
#DEFINE EncoderValueFrameDimensionPage		23

*-- RotateFlipType
#DEFINE RotateNoneFlipNone	0
#DEFINE Rotate90FlipNone	1
#DEFINE Rotate180FlipNone	2
#DEFINE Rotate270FlipNone	3

#DEFINE RotateNoneFlipX		4
#DEFINE Rotate90FlipX		5
#DEFINE Rotate180FlipX		6
#DEFINE Rotate270FlipX		7

#DEFINE RotateNoneFlipY		Rotate180FlipX
#DEFINE Rotate90FlipY		Rotate270FlipX
#DEFINE Rotate180FlipY		RotateNoneFlipX
#DEFINE Rotate270FlipY		Rotate90FlipX

#DEFINE RotateNoneFlipXY	Rotate180FlipNone
#DEFINE Rotate90FlipXY		Rotate270FlipNone
#DEFINE Rotate180FlipXY		RotateNoneFlipNone
#DEFINE Rotate270FlipXY		Rotate90FlipNone

*-- Quality mode constants
#DEFINE QualityModeInvalid	-1
#DEFINE QualityModeDefault	0
#DEFINE QualityModeLow		1	&& Best performance
#DEFINE QualityModeHigh		2	&& Best rendering quality

*-- Interpolation modes
#DEFINE InterpolationModeInvalid			-1
#DEFINE InterpolationModeDefault			0
#DEFINE InterpolationModeLowQuality			1
#DEFINE InterpolationModeHighQuality		2
#DEFINE InterpolationModeBilinear			3
#DEFINE InterpolationModeBicubic			4
#DEFINE InterpolationModeNearestNeighbor		5
#DEFINE InterpolationModeHighQualityBilinear	6
#DEFINE InterpolationModeHighQualityBicubic		7

*** Added by Cesar Chalom
*-- FontStyle: face types and common styles
#DEFINE GDIPLUS_FontStyle_Regular     0
#DEFINE GDIPLUS_FontStyle_Bold        1
#DEFINE GDIPLUS_FontStyle_Italic      2
#DEFINE GDIPLUS_FontStyle_BoldItalic  3
#DEFINE GDIPLUS_FontStyle_Underline   4
#DEFINE GDIPLUS_FontStyle_Strikeout   8

* StringAlignment enumeration
* Applies to GpStringFormat::Alignment, GpStringFormat::LineAlignment
#DEFINE GDIPLUS_STRINGALIGNMENT_Near	0	&& in Left-To-Right locale, this is Left
#DEFINE GDIPLUS_STRINGALIGNMENT_Center	1
#DEFINE GDIPLUS_STRINGALIGNMENT_Far		2	&& in Left-To-Right locale, this is Right

* StringFormatFlags enumeration
* applies to GpStringFormat::FormatFlags
#DEFINE GDIPLUS_STRINGFORMATFLAGS_DirectionRightToLeft     1
#DEFINE GDIPLUS_STRINGFORMATFLAGS_DirectionVertical        2
#DEFINE GDIPLUS_STRINGFORMATFLAGS_NoFitBlackBox            4
#DEFINE GDIPLUS_STRINGFORMATFLAGS_DisplayFormatControl    32
#DEFINE GDIPLUS_STRINGFORMATFLAGS_NoFontFallback        1024
#DEFINE GDIPLUS_STRINGFORMATFLAGS_MeasureTrailingSpaces 2048
#DEFINE GDIPLUS_STRINGFORMATFLAGS_NoWrap                4096
#DEFINE GDIPLUS_STRINGFORMATFLAGS_LineLimit             8192
#DEFINE GDIPLUS_STRINGFORMATFLAGS_NoClip               16384

* PEN Dash style constants
#DEFINE GDIPLUS_DashStyle_Solid			0
#DEFINE GDIPLUS_DashStyle_Dash			1
#DEFINE GDIPLUS_DashStyle_Dot			2
#DEFINE GDIPLUS_DashStyle_DashDot		3
#DEFINE GDIPLUS_DashStyle_DashDotDot	4
#DEFINE GDIPLUS_DashStyle_Custom       	5

* PEN Units
#DEFINE	GDIPLUS_Unit_World      0 && World coordinate (non-physical unit)
#DEFINE	GDIPLUS_Unit_Display    1 && Variable -- for PageTransform only
#DEFINE	GDIPLUS_Unit_Pixel      2 && one device pixel.
#DEFINE	GDIPLUS_Unit_Point      3 && 1/72 inch.
#DEFINE	GDIPLUS_Unit_Inch       4 && 1 inch.
#DEFINE	GDIPLUS_Unit_Document   5 && 1/300 inch.
#DEFINE	GDIPLUS_Unit_Millimeter 6 && 1 millimeter.

* HatchBrush styles
#DEFINE	GDIPLUS_HatchStyle_Horizontal		0
#DEFINE	GDIPLUS_HatchStyle_Vertical			1
#DEFINE	GDIPLUS_HatchStyle_ForwardDiagonal	2
#DEFINE	GDIPLUS_HatchStyle_BackwardDiagonal	3
#DEFINE	GDIPLUS_HatchStyle_Cross			4
#DEFINE	GDIPLUS_HatchStyle_DiagonalCross	5
#DEFINE	GDIPLUS_HatchStyle_05Percent		6
#DEFINE	GDIPLUS_HatchStyle_10Percent		7
#DEFINE	GDIPLUS_HatchStyle_20Percent		8
#DEFINE	GDIPLUS_HatchStyle_25Percent		9
#DEFINE	GDIPLUS_HatchStyle_30Percent		10
#DEFINE	GDIPLUS_HatchStyle_40Percent		11
#DEFINE	GDIPLUS_HatchStyle_50Percent		12
#DEFINE GDIPLUS_HatchStyle_60Percent		13
#DEFINE GDIPLUS_HatchStyle_70Percent		14
#DEFINE GDIPLUS_HatchStyle_75Percent		15
#DEFINE GDIPLUS_HatchStyle_80Percent		16
#DEFINE GDIPLUS_HatchStyle_90Percent		17
#DEFINE GDIPLUS_HatchStyle_LightDownwardDiagonal 18
#DEFINE GDIPLUS_HatchStyle_LightUpwardDiagonal	19
#DEFINE GDIPLUS_HatchStyle_DarkDownwardDiagonal	20
#DEFINE GDIPLUS_HatchStyle_DarkUpwardDiagonal	21
#DEFINE GDIPLUS_HatchStyle_WideDownwardDiagonal	22
#DEFINE GDIPLUS_HatchStyle_WideUpwardDiagonal	23
#DEFINE GDIPLUS_HatchStyle_LightVertical	24
#DEFINE GDIPLUS_HatchStyle_LightHorizontal	25
#DEFINE GDIPLUS_HatchStyle_NarrowVertical	26
#DEFINE GDIPLUS_HatchStyle_NarrowHorizontal	27
#DEFINE GDIPLUS_HatchStyle_DarkVertical		28
#DEFINE GDIPLUS_HatchStyle_DarkHorizontal	29
#DEFINE GDIPLUS_HatchStyle_DashedDownwardDiagonal 30
#DEFINE GDIPLUS_HatchStyle_DashedUpwardDiagonal	31
#DEFINE GDIPLUS_HatchStyle_DashedHorizontal	32
#DEFINE GDIPLUS_HatchStyle_DashedVertical	33
#DEFINE GDIPLUS_HatchStyle_SmallConfetti	34
#DEFINE GDIPLUS_HatchStyle_LargeConfetti	35
#DEFINE GDIPLUS_HatchStyle_ZigZag			36
#DEFINE GDIPLUS_HatchStyle_Wave				37
#DEFINE GDIPLUS_HatchStyle_DiagonalBrick	38
#DEFINE GDIPLUS_HatchStyle_HorizontalBrick	39
#DEFINE GDIPLUS_HatchStyle_Weave			40
#DEFINE GDIPLUS_HatchStyle_Plaid			41
#DEFINE GDIPLUS_HatchStyle_Divot			42
#DEFINE GDIPLUS_HatchStyle_DottedGrid		43
#DEFINE GDIPLUS_HatchStyle_DottedDiamond	44
#DEFINE GDIPLUS_HatchStyle_Shingle			45
#DEFINE GDIPLUS_HatchStyle_Trellis			46
#DEFINE GDIPLUS_HatchStyle_Sphere			47
#DEFINE GDIPLUS_HatchStyle_SmallGrid		48
#DEFINE GDIPLUS_HatchStyle_SmallCheckerBoard	49
#DEFINE GDIPLUS_HatchStyle_LargeCheckerBoard	50
#DEFINE GDIPLUS_HatchStyle_OutlinedDiamond	51
#DEFINE GDIPLUS_HatchStyle_SolidDiamond		52

* Wrap mode for brushes
#DEFINE	GDIPLUS_WrapMode_Tile		0
#DEFINE	GDIPLUS_WrapMode_TileFlipX	1
#DEFINE	GDIPLUS_WrapMode_TileFlipY	2
#DEFINE	GDIPLUS_WrapMode_TileFlipXY	3
#DEFINE	GDIPLUS_WrapMode_Clamp		4

*******************************
*** END #INCLUDE gpImage2.h ***
*******************************

*-- Error messages
#DEFINE ERR_MODULE		"Cannot load a module "
#DEFINE ERR_PICTYPE		"Unsupported picture type"
#DEFINE ERR_CLIPNOTOPEN	"Cannot open the clipboard"
#DEFINE ERR_CLIPNODATA	"No bitmap data found on the clipboard"
#DEFINE ERR_CLIPSETDATA	"Cannot place data on the clipboard"

*-- Constants
#DEFINE MAX_PATH	260
#DEFINE LPTR		0x0040
#DEFINE SRCCOPY		13369376
#DEFINE CRLF		CHR(13) + CHR(10)
#DEFINE VT_DISPATCH	9
#DEFINE IID_IDispatch CHR(0x00)+CHR(0x04)+CHR(0x02)+CHR(0x00)+ ;
  REPLICATE(CHR(0x00), 4)+CHR(0xC0)+REPLICATE(CHR(0x00), 6)+CHR(0x46)

*-- Picture Types
#DEFINE PICTYPE_UNINITIALIZED	(-1)
#DEFINE PICTYPE_NONE			0
#DEFINE PICTYPE_BITMAP			1
#DEFINE PICTYPE_METAFILE		2
#DEFINE PICTYPE_ICON			3
#DEFINE PICTYPE_ENHMETAFILE		4

*-- Predefined Clipboard Formats
#DEFINE CF_BITMAP				2
#DEFINE CF_PALETTE				9
#DEFINE OBJ_BITMAP				7

*-- Encoder CLSIDs
#DEFINE CLSID_BMP				"{557CF400-1A04-11D3-9A73-0000F81EF32E}"
#DEFINE CLSID_JPEG				"{557CF401-1A04-11D3-9A73-0000F81EF32E}"
#DEFINE CLSID_GIF				"{557CF402-1A04-11D3-9A73-0000F81EF32E}"
#DEFINE CLSID_TIFF				"{557CF405-1A04-11D3-9A73-0000F81EF32E}"
#DEFINE CLSID_PNG				"{557CF406-1A04-11D3-9A73-0000F81EF32E}"

*-- Encoder parameter sets
#DEFINE GUID_Compress			"{e09d739d-ccd4-44ee-8eba-3fbf8be4fc58}"
#DEFINE GUID_ColorDepth			"{66087055-ad66-4c7c-9a18-38a2310b8337}"
#DEFINE GUID_Quality			"{1d5be4b5-fa4a-452d-9cdd-5db35105e7eb}"
#DEFINE GUID_Transform			"{8d0eb2d1-a58e-4ea8-aa14-108074b7b6f9}"
#DEFINE GUID_SaveFlag			"{292266fc-ac40-47bf-8cfc-a85b89a655de}"

*-- Predefined multi-frame dimension IDs
#DEFINE GUID_Time				"{6aedbd6d-3fb5-418a-83a6-7f45229dc872}"
#DEFINE GUID_Page				"{7462dc86-6180-4c7e-8e3f-ee7333a7a483}"

*-- Image file format identifiers
#DEFINE GUID_FormatUndefined	"{b96b3ca9-0728-11d3-9d7b-0000f81ef32e}"
#DEFINE GUID_FormatMemoryBMP	"{b96b3caa-0728-11d3-9d7b-0000f81ef32e}"
#DEFINE GUID_FormatBMP			"{b96b3cab-0728-11d3-9d7b-0000f81ef32e}"
#DEFINE GUID_FormatEMF			"{b96b3cac-0728-11d3-9d7b-0000f81ef32e}"
#DEFINE GUID_FormatWMF			"{b96b3cad-0728-11d3-9d7b-0000f81ef32e}"
#DEFINE GUID_FormatJPEG			"{b96b3cae-0728-11d3-9d7b-0000f81ef32e}"
#DEFINE GUID_FormatPNG			"{b96b3caf-0728-11d3-9d7b-0000f81ef32e}"
#DEFINE GUID_FormatGIF			"{b96b3cb0-0728-11d3-9d7b-0000f81ef32e}"
#DEFINE GUID_FormatTIFF			"{b96b3cb1-0728-11d3-9d7b-0000f81ef32e}"
#DEFINE GUID_FormatEXIF			"{b96b3cb2-0728-11d3-9d7b-0000f81ef32e}"
#DEFINE GUID_FormatIcon			"{b96b3cb5-0728-11d3-9d7b-0000f81ef32e}"

*-- Pixel Formats
#DEFINE	PixelFormatIndexed		0x00010000	&& Indexes into a palette
#DEFINE	PixelFormatGDI			0x00020000	&& Is a GDI-supported format
#DEFINE	PixelFormatAlpha		0x00040000	&& Has an alpha component
#DEFINE	PixelFormatPAlpha		0x00080000	&& Pre-multiplied alpha
#DEFINE	PixelFormatExtended		0x00100000	&& Extended color 16 bits/channel
#DEFINE	PixelFormatCanonical	0x00200000

#DEFINE	PixelFormat1bppIndexed		( 1 + ( 1 * 256) + PixelFormatIndexed + PixelFormatGDI)
#DEFINE	PixelFormat4bppIndexed		( 2 + ( 4 * 256) + PixelFormatIndexed + PixelFormatGDI)
#DEFINE	PixelFormat8bppIndexed		( 3 + ( 8 * 256) + PixelFormatIndexed + PixelFormatGDI)
#DEFINE	PixelFormat16bppGrayScale	( 4 + (16 * 256) + PixelFormatExtended)
#DEFINE	PixelFormat16bppRGB555		( 5 + (16 * 256) + PixelFormatGDI)
#DEFINE	PixelFormat16bppRGB565		( 6 + (16 * 256) + PixelFormatGDI)
#DEFINE	PixelFormat16bppARGB1555	( 7 + (16 * 256) + PixelFormatAlpha + PixelFormatGDI)
#DEFINE	PixelFormat24bppRGB			( 8 + (24 * 256) + PixelFormatGDI)
#DEFINE	PixelFormat32bppRGB			( 9 + (32 * 256) + PixelFormatGDI)
#DEFINE	PixelFormat32bppARGB		(10 + (32 * 256) + PixelFormatAlpha + PixelFormatGDI + PixelFormatCanonical)
#DEFINE	PixelFormat32bppPARGB		(11 + (32 * 256) + PixelFormatAlpha + PixelFormatPAlpha + PixelFormatGDI)
#DEFINE	PixelFormat48bppRGB			(12 + (48 * 256) + PixelFormatExtended)
#DEFINE	PixelFormat64bppARGB		(13 + (64 * 256) + PixelFormatAlpha + PixelFormatCanonical + PixelFormatExtended)
#DEFINE	PixelFormat64bppPARGB		(14 + (64 * 256) + PixelFormatAlpha + PixelFormatPAlpha + PixelFormatExtended)

***********************************************************************
*   Class:	gpInit
***********************************************************************

DEFINE CLASS gpInit AS CUSTOM

  PROTECTED gdiplusToken
  gdiplusToken = 0

  PROTECTED PROCEDURE INIT(tcFileName)
    DECLARE LONG PathFindOnPath IN Shlwapi.DLL STRING @ pszFile, LONG ppszOtherDirs
    DECLARE LONG UuidFromString IN rpcrt4.DLL STRING StringUuid, STRING @ Uuid

    DECLARE LONG LocalAlloc IN Win32API LONG uFlags, LONG uBytes
    DECLARE LONG LocalFree IN Win32API LONG HMEM
    DECLARE LONG LoadLibrary IN Win32API STRING FileName
    DECLARE LONG FreeLibrary IN Win32API LONG hModule

    DECLARE LONG GdiplusStartup IN GDIPLUS.DLL ;
      LONG @ token, STRING @ INPUT, LONG @ OUTPUT
    DECLARE LONG GdiplusShutdown IN GDIPLUS.DLL ;
      LONG token
    DECLARE LONG GdipLoadImageFromFile IN GDIPLUS.DLL ;
      STRING FileName, LONG @ GpImage
    DECLARE LONG GdipSaveImageToFile IN GDIPLUS.DLL ;
      LONG GpImage, STRING FileName, STRING @ encoderClsid, STRING @ encoderParams
    DECLARE LONG GdipSaveAddImage IN GDIPLUS.DLL ;
      LONG GpImage, LONG newImage, STRING @ encoderParams
    DECLARE LONG GdipCreateBitmapFromScan0 IN GDIPLUS.DLL ;
      INTEGER WIDTH, INTEGER HEIGHT, INTEGER stride, LONG FORMAT, LONG scan0, LONG @ BITMAP
    DECLARE LONG GdipCreateBitmapFromResource IN GDIPLUS.DLL ;
      LONG hInstance, STRING bitmapName, LONG @ BITMAP
    DECLARE LONG GdipCreateBitmapFromHBITMAP IN GDIPLUS.DLL ;
      LONG hbm, LONG hpal, LONG @ BITMAP
    DECLARE LONG GdipCreateBitmapFromHICON IN GDIPLUS.DLL ;
      LONG hicon, LONG @ BITMAP
    DECLARE LONG GdipCreateMetafileFromWmf IN GDIPLUS.DLL ;
      LONG hWmf, LONG deleteWmf, LONG wmfPlaceableFileHeader, LONG @ metafile
    DECLARE LONG GdipCreateMetafileFromEmf IN GDIPLUS.DLL ;
      LONG hEmf, LONG deleteEmf, LONG @ metafile
    DECLARE LONG GdipCreateHBITMAPFromBitmap IN GDIPLUS.DLL ;
      LONG nativeImage, LONG @ hbmReturn, LONG argb
    DECLARE LONG GdipCreateHICONFromBitmap IN GDIPLUS.DLL ;
      LONG nativeImage, LONG @ hbmReturn
    DECLARE LONG GdipGetImageRawFormat IN GDIPLUS.DLL ;
      LONG nativeImage, STRING @ RawFormat
    DECLARE LONG GdipGetImagePixelFormat IN GDIPLUS.DLL ;
      LONG nativeImage, LONG @ PixelFormat
    DECLARE LONG GdipGetImageWidth IN GDIPLUS.DLL ;
      LONG nativeImage, LONG @ WIDTH
    DECLARE LONG GdipGetImageHeight IN GDIPLUS.DLL ;
      LONG nativeImage, LONG @ HEIGHT
    DECLARE LONG GdipGetImageThumbnail IN GDIPLUS.DLL ;
      LONG nativeImage, LONG thumbWidth, LONG thumbHeight, LONG @ thumbimage, ;
      LONG callback, LONG callbackData
    DECLARE LONG GdipDisposeImage IN GDIPLUS.DLL ;
      LONG GpImage

    DECLARE LONG GdipBitmapGetPixel IN GDIPLUS.DLL ;
      LONG nativeImage, LONG x, LONG Y, LONG @ argb
    DECLARE LONG GdipBitmapSetPixel IN GDIPLUS.DLL ;
      LONG nativeImage, LONG x, LONG Y, LONG argb
    DECLARE LONG GdipGetImageHorizontalResolution IN GDIPLUS.DLL ;
      LONG nativeImage, SINGLE @ resolution
    DECLARE LONG GdipGetImageVerticalResolution IN GDIPLUS.DLL ;
      LONG nativeImage, SINGLE @ resolution
    DECLARE LONG GdipBitmapSetResolution IN GDIPLUS.DLL ;
      LONG nativeImage, SINGLE xdpi, SINGLE ydpi
    DECLARE LONG GdipCloneImage IN GDIPLUS.DLL ;
      LONG nativeImage, LONG @ cloneBitmap
    DECLARE LONG GdipCloneBitmapAreaI IN GDIPLUS.DLL ;
      LONG x, LONG Y, LONG WIDTH, LONG HEIGHT, ;
      LONG FORMAT, LONG nativeImage, LONG @ gpdstBitmap
    DECLARE LONG GdipImageRotateFlip IN GDIPLUS.DLL ;
      LONG nativeImage, LONG rotateFlipType

    DECLARE LONG GdipGetImageGraphicsContext IN GDIPLUS.DLL ;
      LONG IMAGE, LONG @ graphics
    DECLARE LONG GdipSetInterpolationMode IN GDIPLUS.DLL ;
      LONG graphics, LONG interpolationMode
    DECLARE LONG GdipDrawImageRectI IN GDIPLUS.DLL ;
      LONG graphics, LONG IMAGE, INTEGER x, INTEGER Y, INTEGER WIDTH, INTEGER HEIGHT

    DECLARE LONG GdipImageGetFrameCount IN GDIPLUS.DLL ;
      LONG IMAGE, STRING @ dimensionID, LONG @ COUNT
    DECLARE LONG GdipImageSelectActiveFrame IN GDIPLUS.DLL ;
      LONG IMAGE, STRING @ dimensionID, LONG frameIndex

    DECLARE LONG OpenClipboard IN Win32API LONG HWND
    DECLARE LONG CloseClipboard IN Win32API
    DECLARE LONG EmptyClipboard IN Win32API
    DECLARE LONG GetClipboardData IN Win32API LONG uFormat
    DECLARE LONG SetClipboardData IN Win32API LONG uFormat, LONG HMEM
    DECLARE LONG CopyImage IN Win32API LONG hImage, LONG uType, LONG cx, LONG cy, LONG uFlags
    DECLARE LONG DeleteObject IN Win32API LONG hObject
    DECLARE LONG GetObjectType IN Win32API LONG h

    DECLARE LONG GetDesktopWindow IN Win32API
    DECLARE LONG GetWindowDC IN Win32API LONG HWND
    DECLARE LONG GetWindowRect IN Win32API LONG HWND, STRING @ lpRect
    DECLARE LONG CreateCompatibleDC IN Win32API LONG hdc
    DECLARE LONG CreateCompatibleBitmap IN Win32API LONG hdc, LONG nWidth, LONG nHeight
    DECLARE LONG SelectObject IN Win32API LONG hdc, LONG hObject
    DECLARE LONG ReleaseDC IN Win32API LONG HWND, LONG hdc
    DECLARE LONG DeleteDC IN Win32API LONG hdc
    DECLARE LONG BitBlt IN Win32API ;
      LONG hDestDC, LONG x, LONG Y, LONG nWidth, LONG nHeight, ;
      LONG hSrcDC, LONG xSrc, LONG ySrc, LONG dwRop
    DECLARE RtlMoveMemory IN Win32API AS RtlCopyLong ;
      INTEGER @ DestNum, STRING @ pVoidSource, INTEGER nLength

    *** API DECLARATIONS FOR GRAPHICS CLASS

    *!*	GRAPHICS FUNCTIONS

    DECLARE INTEGER GdipCreateFromHWND IN GDIPLUS.DLL ;
      INTEGER hWind, INTEGER @graphics

    DECLARE INTEGER GdipDeleteGraphics IN GDIPLUS.DLL ;
      INTEGER graphics

    DECLARE INTEGER GdipTranslateWorldTransform IN GDIPLUS.DLL ;
      INTEGER graphics, SINGLE dX, SINGLE dY, INTEGER nOrder

    DECLARE INTEGER GdipRotateWorldTransform IN GDIPLUS.DLL ;
      INTEGER graphics, SINGLE Angle, INTEGER nOrder

    DECLARE INTEGER GdipResetWorldTransform IN GDIPLUS.DLL ;
      INTEGER graphics

    DECLARE INTEGER GdipDrawString IN GDIPLUS.DLL;
      INTEGER graphics, STRING wchar, INTEGER LENGTH,;
      INTEGER fnt, STRING @rectangleF, INTEGER stringFormat, INTEGER brush

    DECLARE INTEGER GdipMeasureString IN GDIPLUS.DLL ;
      INTEGER Graphics, STRING wchar, INTEGER LENGTH,;
      INTEGER fnt, STRING  rectangleF, INTEGER StringFormat, STRING @boundingBoxRectF, ;
      INTEGER @nCodepointsFitted, INTEGER @nLinesFilled

    DECLARE INTEGER GdipDrawLine IN GDIPLUS.DLL ;
      INTEGER graphics, INTEGER npen, SINGLE X1, SINGLE Y1, SINGLE X2, SINGLE Y2

    DECLARE GdipDrawRectangle IN GDIPLUS.DLL;
      INTEGER graphics, INTEGER npen, SINGLE x, SINGLE Y, SINGLE w, SINGLE h

    DECLARE INTEGER GdipFillRectangle IN GDIPLUS.DLL;
      INTEGER graphics, INTEGER brush,;
      SINGLE x, SINGLE Y, SINGLE w, SINGLE h

    DECLARE INTEGER GdipDrawEllipse IN GDIPLUS.DLL ;
      INTEGER graphics, INTEGER npen, SINGLE x, SINGLE Y, SINGLE w, SINGLE h

    DECLARE INTEGER GdipFillEllipse IN GDIPLUS.DLL ;
      INTEGER graphics, INTEGER brush, SINGLE x, SINGLE Y, SINGLE w, SINGLE h

    DECLARE INTEGER GdipDrawPie IN GDIPLUS.DLL ;
      INTEGER graphics, INTEGER npen, SINGLE x, SINGLE Y, SINGLE w, ;
      SINGLE h, SINGLE StartAngle, SINGLE SweepAngle

    DECLARE INTEGER GdipFillPie IN GDIPLUS.DLL ;
      INTEGER graphics, INTEGER brush, SINGLE x, SINGLE Y, SINGLE w, SINGLE h, ;
      SINGLE StartAngle, SINGLE SweepAngle

    DECLARE INTEGER GdipDrawArc IN GDIPLUS.DLL ;
      INTEGER graphics, INTEGER nPen, SINGLE x, SINGLE Y, SINGLE w, ;
      SINGLE h, SINGLE StartAngle, SINGLE SweepAngle

    DECLARE INTEGER GdipDrawPolygon IN GDIPLUS.DLL ;
      INTEGER Graphics, INTEGER nPen, STRING PointsF, INTEGER nCount

    DECLARE INTEGER GdipFillPolygon IN GDIPLUS.DLL ;
      INTEGER Graphics, INTEGER Brush, STRING PointsF, INTEGER nCount, INTEGER FillMode

    DECLARE INTEGER GdipDrawImage IN GDIPLUS.DLL ;
      INTEGER graphics, INTEGER nImage, SINGLE X, SINGLE Y

    DECLARE INTEGER GdipDrawImageRect IN GDIPLUS.DLL ;
      INTEGER graphics, INTEGER nImage, ;
      SINGLE x, SINGLE Y, SINGLE w, SINGLE h

    DECLARE INTEGER GdipDrawImageRectRect IN GDIPLUS.DLL ;
      INTEGER Graphics, INTEGER nImage, ;
      SINGLE dstx, SINGLE dsty, SINGLE dstwidth, SINGLE dstheight, ;
      SINGLE srcx, SINGLE srcy, SINGLE srcwidth, SINGLE srcheight, ;
      INTEGER srcUnit, INTEGER imageAttributes, ;
      INTEGER Callback, INTEGER CallbackData

    *!*	IMAGE ATTRIBUTES
    DECLARE INTEGER GdipCreateImageAttributes IN GDIPLUS.DLL ;
      INTEGER @ImgAttr

    DECLARE INTEGER GdipDisposeImageAttributes IN GDIPLUS.DLL ;
      INTEGER imageattr

    DECLARE INTEGER GdipResetImageAttributes IN GDIPLUS.DLL ;
      INTEGER imageattr, INTEGER ColorAdjustType

    DECLARE INTEGER GdipSetImageAttributesColorMatrix IN GDIPLUS.DLL ;
      INTEGER imageattr, ;
      INTEGER ColorAdjustType, ;
      INTEGER enableFlag, ;
      STRING  colorMatrix, ;
      INTEGER grayMatrix, ;
      INTEGER ColorMatrixFlags

    DECLARE INTEGER GdipSetImageAttributesRemapTable IN GDIPLUS.DLL ;
      INTEGER imageattr, ;
      INTEGER ColorAdjustType, ;
      INTEGER enableFlag, ;
      INTEGER mapsize, ;
      STRING  colorMap

    *!*	FONT FUNCTIONS
    DECLARE INTEGER GdipCreateFont IN GDIPLUS.DLL;
      INTEGER fontFamily, SINGLE emSize,;
      INTEGER fntstyle, INTEGER unit, INTEGER @fnt

    DECLARE INTEGER GdipDeleteFont IN GDIPLUS.DLL ;
      INTEGER fnt

    *!*	FONTFAMILY FUNCTIONS
    DECLARE INTEGER GdipCreateFontFamilyFromName IN GDIPLUS.DLL;
      STRING familyname, INTEGER FontCollection, INTEGER @FontFamily

    DECLARE INTEGER GdipDeleteFontFamily IN GDIPLUS.DLL ;
      INTEGER FontFamily

    *!*	STRING FORMAT FUNCTIONS
    DECLARE INTEGER GdipCreateStringFormat IN GDIPLUS.DLL ;
      INTEGER formatAttributes, INTEGER LANGUAGE, INTEGER @nFormat

    DECLARE INTEGER GdipSetStringFormatAlign IN GDIPLUS.DLL ;
      INTEGER nFormat, INTEGER StringAlignment

    DECLARE INTEGER GdipSetStringFormatLineAlign IN GDIPLUS.DLL ;
      INTEGER nformat, INTEGER StringAlignment

    *!*	PEN FUNCTIONS
    DECLARE INTEGER GdipCreatePen1 IN GDIPLUS.DLL;
      INTEGER ARGBcolor, SINGLE penwidth, INTEGER unit, INTEGER @npen

    DECLARE INTEGER GdipSetPenDashStyle IN GDIPLUS.DLL ;
      INTEGER nPen, INTEGER DashStyle

    DECLARE INTEGER GdipDeletePen IN GDIPLUS.DLL ;
      INTEGER nPen

    *!*	BRUSH FUNCTIONS
    DECLARE INTEGER GdipCreateSolidFill IN GDIPLUS.DLL;
      INTEGER ARGBcolor, INTEGER @brush

    DECLARE INTEGER GdipDeleteBrush IN GDIPLUS.DLL ;
      INTEGER brush

    DECLARE INTEGER GdipCreateHatchBrush IN GDIPLUS.DLL;
      INTEGER hatchstyle, INTEGER FORECOL, INTEGER BACKCOL, INTEGER @brush

    DECLARE INTEGER GdipCreateTexture IN GDIPLUS.DLL;
      INTEGER nimage, INTEGER wrapmode, INTEGER @brushTexture

    ***

    #IF VERSION(5) >= 700
      DECLARE LONG OleCreatePictureIndirect IN oleaut32 ;
        STRING @ PicDesc, STRING @ RefIID, LONG fPictureOwnsHandle, OBJECT @ IPic
    #ELSE
      DECLARE LONG OleCreatePictureIndirect IN oleaut32 ;
        STRING @ PicDesc, STRING @ RefIID, LONG fPictureOwnsHandle, LONG @ IPic
      DECLARE LONG MultiByteToWideChar IN kernel32 ;
        LONG iCodePage, LONG dwFlags, STRING @ lpStr, LONG iMultiByte, ;
        STRING @ lpWideStr, LONG iWideChar
      DECLARE LONG OleSavePictureFile IN oleaut32 LONG IPic, LONG bstrFile
      DECLARE LONG SysAllocString IN oleaut32 STRING @ szString
      DECLARE SysFreeString IN oleaut32 LONG bstr
      DECLARE LONG VariantClear IN oleaut32 STRING @ pvarg
    #ENDIF

    LOCAL gdiplusStartupInput, lcToken
    *	struct GdiplusStartupInput
    *	{
    *		UINT32 GdiplusVersion;				// Must be 1
    *		DebugEventProc DebugEventCallback;	// Ignored on free builds
    *		BOOL SuppressBackgroundThread;		// FALSE unless you're prepared to call
    *											// the hook/unhook functions properly
    *		BOOL SuppressExternalCodecs;		// FALSE unless you want GDI+ only to use
    *											// its internal image codecs.
    *	}
    gdiplusStartupInput = CHR(1) + REPLICATE(CHR(0), 15)	&& GdiplusStartupInput structure (sizeof = 16)

    * Initialize GDI+.
    lcToken = 0
    IF GdiplusStartup(@lcToken, @gdiplusStartupInput, 0) != 0
      RETURN .F.
    ENDIF
    THIS.gdiplusToken = lcToken
  ENDPROC

  PROTECTED PROCEDURE DESTROY
    GdiplusShutdown(THIS.gdiplusToken)

    #IF VERSION(5) >= 700
      CLEAR DLLS "PathFindOnPath", "UuidFromString"
      CLEAR DLLS "LocalAlloc", "LocalFree", "LoadLibrary", "FreeLibrary"
      CLEAR DLLS "GdiplusStartup", "GdiplusShutdown", ;
        "GdipLoadImageFromFile", "GdipSaveImageToFile", "GdipSaveAddImage", ;
        "GdipCreateBitmapFromScan0", "GdipCreateBitmapFromResource", "GdipCreateBitmapFromHBITMAP", ;
        "GdipCreateBitmapFromHICON", "GdipCreateMetafileFromWmf", "GdipCreateMetafileFromEmf", ;
        "GdipCreateHBITMAPFromBitmap", "GdipCreateHICONFromBitmap"
      CLEAR DLLS "GdipGetImageRawFormat", "GdipGetImagePixelFormat", ;
        "GdipGetImageWidth", "GdipGetImageHeight", "GdipGetImageThumbnail", "GdipDisposeImage"
      CLEAR DLLS "GdipBitmapGetPixel", "GdipBitmapSetPixel", "GdipGetImageHorizontalResolution", ;
        "GdipGetImageVerticalResolution", "GdipBitmapSetResolution", "GdipCloneImage", ;
        "GdipCloneBitmapAreaI", "GdipImageRotateFlip"
      CLEAR DLLS "GdipGetImageGraphicsContext", "GdipSetInterpolationMode", "GdipDrawImageRectI"
      CLEAR DLLS "GdipImageGetFrameCount", "GdipImageSelectActiveFrame"
      CLEAR DLLS "OpenClipboard", "CloseClipboard", "EmptyClipboard", "GetClipboardData", "SetClipboardData", ;
        "CopyImage", "DeleteObject", "GetObjectType", "OleCreatePictureIndirect"
      CLEAR DLLS "GetDesktopWindow", "GetWindowDC", "GetWindowRect", "CreateCompatibleDC", ;
        "CreateCompatibleBitmap", "SelectObject", "ReleaseDC", "DeleteDC", "BitBlt", "RtlMoveMemory"

      *** Clearing DLLS used in Graphics class
      *!*	GRAPHICS
      CLEAR DLLS "GdipCreateFromHWND", "GdipDeleteGraphics", "GdipTranslateWorldTransform", ;
        "GdipRotateWorldTransform", "GdipResetWorldTransform", "GdipDrawString", ;
        "GdipMeasureString", "GdipDrawLine", "GdipDrawRectangle", "GdipFillRectangle", ;
        "GdipDrawEllipse", "GdipFillEllipse", "GdipDrawPie", "GdipFillPie", "GdipDrawArc", ;
        "GdipDrawPolygon", "GdipFillPolygon", "GdipDrawImage", "GdipDrawImageRect", ;
        "GdipDrawImageRectRect"

      *!*	FONT FUNCTIONS
      CLEAR DLLS "GdipCreateFont", "GdipDeleteFont"

      *!*	FONTFAMILY FUNCTIONS
      CLEAR DLLS "GdipCreateFontFamilyFromName", "GdipDeleteFontFamily"

      *!*	STRING FORMAT FUNCTIONS
      CLEAR DLLS "GdipCreateStringFormat", "GdipSetStringFormatAlign", "GdipSetStringFormatLineAlign"

      *!*	PEN FUNCTIONS
      CLEAR DLLS "GdipCreatePen1", "GdipSetPenDashStyle", "GdipDeletePen"

      *!*	BRUSH FUNCTIONS
      CLEAR DLLS "GdipCreateSolidFill", "GdipDeleteBrush", "GdipCreateHatchBrush", "GdipCreateTexture"

      *!*	IMAGE ATTRIBUTES
      CLEAR DLLS "GdipCreateImageAttributes", "GdipDisposeImageAttributes", ;
        "GdipSetImageAttributesColorMatrix", "GdipSetImageAttributesRemapTable", ;
        "GdipResetImageAttributes"
      ***
    #ENDIF
  ENDPROC

ENDDEFINE


***********************************************************************
*   Class:	gpImage2
***********************************************************************

DEFINE CLASS gpImage2 AS CUSTOM
  PROTECTED STAT
  PROTECTED nativeImage

  nativeImage = 0
  ImageFormat = ""
  PixelFormat = ""
  ImageWidth = 0
  ImageHeight = 0
  HorizontalResolution = 0.0
  VerticalResolution = 0.0
  PixelRed   = 0
  PixelGreen = 0
  PixelBlue  = 0

  PROTECTED PROCEDURE INIT(tcFileName)
    IF !EMPTY(tcFileName)
      * Create Image object from handle
      IF VARTYPE(tcFileName) = 'N'
        THIS.nativeImage = tcFileName
        RETURN
      ENDIF

      * Create Image object from file
      IF (VARTYPE(tcFileName) != 'C') OR !FILE(tcFileName)
        RETURN .F.
      ENDIF

      LOCAL lnImage
      lnImage = 0
      THIS.STAT = GdipLoadImageFromFile(THIS.WideStr(tcFileName), @lnImage)
      IF THIS.STAT = 0
        THIS.nativeImage = lnImage
      ENDIF
    ENDIF
  ENDPROC

  PROCEDURE CreateFromGraphics(tnGraphics)
    DECLARE INTEGER GdipGetClipBounds IN GDIPLUS.DLL ;
      INTEGER nGraphics, STRING @ pRectF
    LOCAL lcRectF, lnImage
    lcRectF = REPLICATE(CHR(0),16)
    THIS.STAT = GdipGetClipBounds (tnGraphics, @lcRectF )
    W = float2int(buf2dword(SUBSTR(m.lcRectF,9,4)))
    H = float2int(buf2dword(SUBSTR(m.lcRectF,13,4)))
    DECLARE INTEGER GdipCreateBitmapFromGraphics IN GDIPLUS.DLL ;
      INTEGER nWidth, INTEGER nHeight, INTEGER nGraphics, INTEGER @ nImage
    *STORE 100 TO w, h
    *!*	this.Destroy()
    lnImage = 0
    THIS.STAT = GdipCreateBitmapFromGraphics(m.W, m.H, tnGraphics, @lnImage)
    THIS.NativeImage = lnImage
  ENDPROC

  PROTECTED PROCEDURE DESTROY
    IF THIS.nativeImage != 0
      GdipDisposeImage(THIS.nativeImage)
    ENDIF
  ENDPROC

  PROCEDURE CREATE(tnWidth, tnHeight, tcPixelFormat)
    IF VARTYPE(tcPIxelFormat) == "L"
      tcPixelFormat = "32bppARGB"
    ENDIF

    IF (VARTYPE(tnWidth) != 'N') OR (VARTYPE(tnHeight) != 'N')
      ERROR 11
    ENDIF

    LOCAL newImage, lnFormat
    newImage = 0
    lnFormat = THIS.StrToPixelFormat(tcPixelFormat)

    THIS.STAT = GdipCreateBitmapFromScan0(tnWidth, tnHeight, 0, lnFormat, 0, @newImage)
    IF THIS.STAT = 0
      GdipDisposeImage(THIS.nativeImage)
      THIS.nativeImage = newImage
    ENDIF
  ENDPROC

  PROCEDURE LOAD(tcFileName)
    IF VARTYPE(tcFileName) != 'C'
      ERROR 11
    ENDIF
    IF !FILE(tcFileName)
      ERROR 1, tcFileName
    ENDIF

    LOCAL lnImage
    IF THIS.nativeImage != 0
      GdipDisposeImage(THIS.nativeImage)
    ENDIF
    THIS.nativeImage = 0

    * Create Image from file
    lnImage = 0
    THIS.STAT = GdipLoadImageFromFile(THIS.WideStr(tcFileName), @lnImage)
    IF THIS.STAT = 0
      THIS.nativeImage = lnImage
    ENDIF
  ENDPROC

  PROCEDURE FromHBITMAP(thBitmap, thPalette)
    IF VARTYPE(thBitmap) != 'N'
      ERROR 11
    ENDIF
    IF !EMPTY(thPalette) AND (VARTYPE(thPalette) != 'N')
      ERROR 11
    ENDIF
    IF EMPTY(thPalette)
      thPalette = 0
    ENDIF

    LOCAL newImage
    IF THIS.nativeImage != 0
      GdipDisposeImage(THIS.nativeImage)
    ENDIF
    THIS.nativeImage = 0

    newImage = 0
    THIS.STAT = GdipCreateBitmapFromHBITMAP(thBitmap, thPalette, @newImage)
    IF THIS.STAT = 0
      THIS.nativeImage = newImage
    ENDIF
  ENDPROC

  PROCEDURE FromHICON(thIcon)
    IF VARTYPE(thIcon) != 'N'
      ERROR 11
    ENDIF

    LOCAL newImage
    IF THIS.nativeImage != 0
      GdipDisposeImage(THIS.nativeImage)
    ENDIF
    THIS.nativeImage = 0

    newImage = 0
    THIS.STAT = GdipCreateBitmapFromHICON(thIcon, @newImage)
    IF THIS.STAT = 0
      THIS.nativeImage = newImage
    ENDIF
  ENDPROC

  PROCEDURE GetHBITMAP(tnColor)
    IF !EMPTY(tnColor) AND (VARTYPE(tnColor) != 'N')
      ERROR 11
    ENDIF
    IF EMPTY(tnColor)
      tnColor = 0x00FFFFFF
    ENDIF

    LOCAL hBmp, argb
    hBmp = 0
    argb = MakeARGB(tnColor, 255)
    THIS.STAT = GdipCreateHBITMAPFromBitmap(THIS.nativeImage, @hBmp, argb)
    RETURN hBmp
  ENDPROC

  PROCEDURE GetHICON
    LOCAL hIcon
    hIcon = 0
    THIS.STAT = GdipCreateHICONFromBitmap(THIS.nativeImage, @hIcon)
    RETURN hIcon
  ENDPROC

  PROCEDURE FromResource(tcFileName, tcBitmapName)
    IF (VARTYPE(tcFileName) != 'C') OR (VARTYPE(tcBitmapName) != 'C')
      ERROR 11
    ENDIF
    * first parameter is used to return a full qualified path name
    IF PathFindOnPath(PADR(tcFileName, MAX_PATH, CHR(0)), 0) = 0
      ERROR 1, tcFileName
    ENDIF

    LOCAL hInstance, bmp
    IF THIS.nativeImage != 0
      GdipDisposeImage(THIS.nativeImage)
    ENDIF
    THIS.nativeImage = 0

    hInstance = LoadLibrary(tcFileName)
    IF hInstance = 0
      ERROR ERR_MODULE + tcFileName
    ENDIF
    bmp = 0
    THIS.STAT = GdipCreateBitmapFromResource(hInstance, THIS.WideStr(tcBitmapName), @bmp)
    IF THIS.STAT = 0
      THIS.nativeImage = bmp
    ENDIF
    FreeLibrary(hInstance)
  ENDPROC

  PROCEDURE FromPicture(toPicture)
    IF (VARTYPE(toPicture) != 'O') OR (COMCLASSINFO(toPicture, 5) != '3')
      ERROR 11
    ENDIF

    LOCAL newImage
    IF THIS.nativeImage != 0
      GdipDisposeImage(THIS.nativeImage)
    ENDIF
    THIS.nativeImage = 0

    newImage = 0
    DO CASE
      CASE toPicture.TYPE = PICTYPE_BITMAP
        THIS.STAT = GdipCreateBitmapFromHBITMAP(toPicture.Handle, toPicture.hPal, @newImage)
      CASE toPicture.TYPE = PICTYPE_METAFILE
        THIS.STAT = GdipCreateMetafileFromWmf(toPicture.Handle, 0, 0, @newImage)
      CASE toPicture.TYPE = PICTYPE_ICON
        THIS.STAT = GdipCreateBitmapFromHICON(toPicture.Handle, @newImage)
      CASE toPicture.TYPE = PICTYPE_ENHMETAFILE
        THIS.STAT = GdipCreateMetafileFromEmf(toPicture.Handle, 0, @newImage)
      OTHERWISE
        ERROR ERR_PICTYPE
    ENDCASE
    IF THIS.STAT = 0
      THIS.nativeImage = newImage
    ENDIF
  ENDPROC

  FUNCTION GetPicture()
    LOCAL hBmp, PictDesc, IPic
    hBmp = 0
    THIS.STAT = GdipCreateHBITMAPFromBitmap(THIS.nativeImage, @hBmp, 0xFFFFFFFF)
    IF THIS.STAT = 0
      * Create Picture object according to PICTDESC structure
      PictDesc = DWord(16) ;				&& Size of PICTDESC structure
      + DWord(PICTYPE_BITMAP) ;	&& Type of picture
      + DWord(hBmp) ;			&& HBITMAP
      + DWord(0)					&& HPALETTE
      iid = IID_IDispatch
      IPic = 0
      OleCreatePictureIndirect(@PictDesc, @iid, 1, @IPic)
      #IF VERSION(5) >= 700
        RETURN IPic
      #ELSE
        LOCAL lcTmpFile, lnBstr, lcVar, loPic
        lcTmpFile = "tmp.bmp"
        lnBstr = SysAllocString(THIS.WideStr(lcTmpFile))
        OleSavePictureFile(IPic, lnBstr)
        SysFreeString(lnBstr)
        * IPicture->Release()
        lcVar = CHR(VT_DISPATCH) + REPLICATE(CHR(0), 7) + DWord(IPic)
        VariantClear(@lcVar)
        loPic = LOADPICTURE(lcTmpFile)
        ERASE (lcTmpFile)
        RETURN loPic
      #ENDIF
    ENDIF
  ENDPROC

  PROCEDURE FromClipboard()
    LOCAL hBmp, hPal, bmp
    IF THIS.nativeImage != 0
      GdipDisposeImage(THIS.nativeImage)
    ENDIF
    THIS.nativeImage = 0

    hBmp = 0
    hPal = 0
    IF OpenClipboard(0) != 0
      hBmp = GetClipboardData(CF_BITMAP)
      hPal = GetClipboardData(CF_PALETTE)
      CloseClipboard()
    ELSE
      ERROR ERR_CLIPNOTOPEN
    ENDIF
    IF hBmp = 0 OR GetObjectType(hBmp) <> OBJ_BITMAP
      ERROR ERR_CLIPNODATA
    ENDIF

    bmp = 0
    THIS.STAT = GdipCreateBitmapFromHBITMAP(hBmp, hPal, @bmp)
    IF THIS.STAT = 0
      THIS.nativeImage = bmp
    ENDIF
    DeleteObject(hBmp)
  ENDPROC

  PROCEDURE ToClipboard()
    LOCAL hBmp, hReturnBmp, hndl
    hReturnBmp = 0
    THIS.STAT = GdipCreateHBITMAPFromBitmap(THIS.nativeImage, @hReturnBmp, 0xFFFFFFFF)
    hBmp = CopyImage(hReturnBmp, 0, 0, 0, 0)
    DeleteObject(hReturnBmp)
    IF THIS.STAT = 0
      IF OpenClipboard(0) != 0
        EmptyClipboard()
        hndl = SetClipboardData(CF_BITMAP, hBmp)
        CloseClipboard()
        IF hndl = 0
          ERROR ERR_CLIPSETDATA
        ENDIF
      ELSE
        ERROR ERR_CLIPNOTOPEN
      ENDIF
    ENDIF
  ENDPROC

  PROCEDURE CLONE
    LOCAL cloneImage
    cloneBitmap = 0
    THIS.STAT = GdipCloneImage(THIS.nativeImage, @cloneImage)
    RETURN CREATEOBJECT("gpImage2", cloneImage)
  ENDPROC

  PROCEDURE CloneArea(x, Y, tnWidth, tnHeight, tcPixelFormat)
    IF (VARTYPE(x) != 'N') OR (VARTYPE(Y) != 'N')
      ERROR 11
    ENDIF
    IF (VARTYPE(tnWidth) != 'N') OR (VARTYPE(tnHeight) != 'N')
      ERROR 11
    ENDIF
    IF !EMPTY(tcPixelFormat) AND (VARTYPE(tcPixelFormat) != 'C')
      ERROR 11
    ENDIF

    LOCAL lnFormat, gpdstBitmap
    lnFormat = 0
    IF EMPTY(tcPixelFormat)
      THIS.STAT = GdipGetImagePixelFormat(THIS.nativeImage, @lnFormat)
    ELSE
      lnFormat = THIS.StrToPixelFormat(tcPixelFormat)
    ENDIF

    gpdstBitmap = 0
    THIS.STAT = GdipCloneBitmapAreaI(x, Y, tnWidth, tnHeight, ;
      lnFormat, THIS.nativeImage, @gpdstBitmap)
    RETURN CREATEOBJECT("gpImage2", gpdstBitmap)
  ENDPROC

  PROCEDURE Thumbnail(tnWidth, tnHeight)
    IF (VARTYPE(tnWidth) != 'N') OR (VARTYPE(tnHeight) != 'N')
      ERROR 11
    ENDIF

    LOCAL thumbImage
    thumbImage = 0
    THIS.STAT = GdipGetImageThumbnail(THIS.nativeImage, tnWidth, tnHeight, @thumbImage, 0, 0)
    IF THIS.STAT = 0
      GdipDisposeImage(THIS.nativeImage)
      THIS.nativeImage = thumbImage
    ENDIF
  ENDPROC

  PROCEDURE SaveAsBMP(tcFileName)
    IF VARTYPE(tcFileName) != 'C'
      ERROR 11
    ENDIF

    LOCAL encoderClsid, lcFile
    lcFile = DEFAULTEXT(tcFileName, "bmp")
    ERASE (lcFile)
    encoderClsid = THIS.StrToGuid(CLSID_BMP)
    THIS.STAT = GdipSaveImageToFile(THIS.nativeImage, THIS.WideStr(lcFile), @encoderClsid, NULL)
  ENDPROC

  * tnQuality - quality of JPEG compression, 0-100, optional
  *			0 - highest compression, 100 - highest quality, default value - 75.
  * tnTransform - type of transformation without loss of information,
  *			any of EncoderValueTransform values, optional.
  PROCEDURE SaveAsJPEG(tcFileName, tnQuality, tnTransform)
    IF VARTYPE(tcFileName) != 'C'
      ERROR 11
    ENDIF
    IF !EMPTY(tnQuality) AND (VARTYPE(tnQuality) != 'N')
      ERROR 11
    ENDIF
    IF !EMPTY(tnTransform) AND (VARTYPE(tnTransform) != 'N')
      ERROR 11
    ENDIF

    LOCAL encoderClsid, lcFile, encoderParams, loQuality, loTransform, paramCnt
    lcFile = DEFAULTEXT(tcFileName, "jpg")
    ERASE (lcFile)
    encoderClsid = THIS.StrToGuid(CLSID_JPEG)

    paramCnt = 0
    encoderParams = ""
    IF VARTYPE(tnQuality) = 'N'
      loQuality = CREATEOBJECT("EncoderParameter", THIS.StrToGuid(GUID_Quality), tnQuality)
      encoderParams = encoderParams + loQuality.GetString()
      paramCnt = paramCnt + 1
    ENDIF
    IF VARTYPE(tnTransform) = 'N'
      loTransform = CREATEOBJECT("EncoderParameter", THIS.StrToGuid(GUID_Transform), tnTransform)
      encoderParams = encoderParams + loTransform.GetString()
      paramCnt = paramCnt + 1
    ENDIF

    IF paramCnt > 0
      *	class EncoderParameters
      *	{
      *	public:
      *		UINT Count;						// Number of parameters in this structure
      *		EncoderParameter Parameter[1];	// Parameter values
      *	}
      encoderParams = DWord(paramCnt) + encoderParams
      THIS.STAT = GdipSaveImageToFile(THIS.nativeImage, THIS.WideStr(lcFile), @encoderClsid, @encoderParams)
    ELSE
      THIS.STAT = GdipSaveImageToFile(THIS.nativeImage, THIS.WideStr(lcFile), @encoderClsid, NULL)
    ENDIF
  ENDPROC

  PROCEDURE SaveAsGIF(tcFileName)
    IF VARTYPE(tcFileName) != 'C'
      ERROR 11
    ENDIF

    LOCAL encoderClsid, lcFile
    lcFile = DEFAULTEXT(tcFileName, "gif")
    ERASE (lcFile)
    encoderClsid = THIS.StrToGuid(CLSID_GIF)
    THIS.STAT = GdipSaveImageToFile(THIS.nativeImage, THIS.WideStr(lcFile), @encoderClsid, NULL)
  ENDPROC

  * tnCompress - type of compression, any of EncoderValueCompression values, optional.
  * tnColorDepth - number of colors in bits per pixel (1,4,8,16,24,32,48,64), optional.
  PROCEDURE SaveAsTIFF(tcFileName, tnCompress, tnColorDepth)
    IF VARTYPE(tcFileName) != 'C'
      ERROR 11
    ENDIF
    IF !EMPTY(tnCompress) AND (VARTYPE(tnCompress) != 'N')
      ERROR 11
    ENDIF
    IF !EMPTY(tnColorDepth) AND (VARTYPE(tnColorDepth) != 'N')
      ERROR 11
    ENDIF

    LOCAL encoderClsid, lcFile, encoderParams, loQuality, loTransform, paramCnt
    lcFile = DEFAULTEXT(tcFileName, "tif")
    ERASE (lcFile)
    encoderClsid = THIS.StrToGuid(CLSID_TIFF)

    paramCnt = 0
    encoderParams = ""
    IF VARTYPE(tnCompress) = 'N'
      loCompress = CREATEOBJECT("EncoderParameter", THIS.StrToGuid(GUID_Compress), tnCompress)
      encoderParams = encoderParams + loCompress.GetString()
      paramCnt = paramCnt + 1
    ENDIF
    IF VARTYPE(tnColorDepth) = 'N'
      loColorDepth = CREATEOBJECT("EncoderParameter", THIS.StrToGuid(GUID_ColorDepth), tnColorDepth)
      encoderParams = encoderParams + loColorDepth.GetString()
      paramCnt = paramCnt + 1
    ENDIF

    IF paramCnt > 0
      *	class EncoderParameters
      *	{
      *	public:
      *		UINT Count;						// Number of parameters in this structure
      *		EncoderParameter Parameter[1];	// Parameter values
      *	}
      encoderParams = DWord(paramCnt) + encoderParams
      THIS.STAT = GdipSaveImageToFile(THIS.nativeImage, THIS.WideStr(lcFile), @encoderClsid, @encoderParams)
    ELSE
      THIS.STAT = GdipSaveImageToFile(THIS.nativeImage, THIS.WideStr(lcFile), @encoderClsid, NULL)
    ENDIF
  ENDPROC

  * tnCompress - type of compression, any of EncoderValueCompression values, optional.
  * tnColorDepth - number of colors in bits per pixel (1,4,8,16,24,32,48,64), optional.
  PROCEDURE SaveAsMultipageTIFF(tcFileName, tnCompress, tnColorDepth)
    IF VARTYPE(tcFileName) != 'C'
      ERROR 11
    ENDIF
    IF !EMPTY(tnCompress) AND (VARTYPE(tnCompress) != 'N')
      ERROR 11
    ENDIF
    IF !EMPTY(tnColorDepth) AND (VARTYPE(tnColorDepth) != 'N')
      ERROR 11
    ENDIF

    LOCAL encoderClsid, lcFile, encoderParams, loQuality, loTransform, paramCnt
    lcFile = DEFAULTEXT(tcFileName, "tif")
    ERASE (lcFile)
    encoderClsid = THIS.StrToGuid(CLSID_TIFF)

    loCompress = CREATEOBJECT("EncoderParameter", THIS.StrToGuid(GUID_SaveFlag), EncoderValueMultiFrame)
    encoderParams = loCompress.GetString()
    paramCnt = 1

    IF VARTYPE(tnCompress) = 'N'
      loCompress = CREATEOBJECT("EncoderParameter", THIS.StrToGuid(GUID_Compress), tnCompress)
      encoderParams = encoderParams + loCompress.GetString()
      paramCnt = paramCnt + 1
    ENDIF
    IF VARTYPE(tnColorDepth) = 'N'
      loColorDepth = CREATEOBJECT("EncoderParameter", THIS.StrToGuid(GUID_ColorDepth), tnColorDepth)
      encoderParams = encoderParams + loColorDepth.GetString()
      paramCnt = paramCnt + 1
    ENDIF

    encoderParams = DWord(paramCnt) + encoderParams
    THIS.STAT = GdipSaveImageToFile(THIS.nativeImage, THIS.WideStr(lcFile), @encoderClsid, @encoderParams)
  ENDPROC

  FUNCTION GetImage
    RETURN THIS.nativeImage
  ENDFUNC

  PROCEDURE SaveAddPage(tnImage)
    IF EMPTY(tnImage) AND (VARTYPE(tnImage) != 'N')
      ERROR 11
    ENDIF

    LOCAL encoderParams, paramCnt
    loCompress = CREATEOBJECT("EncoderParameter", THIS.StrToGuid(GUID_SaveFlag), EncoderValueFrameDimensionPage)
    encoderParams = loCompress.GetString()
    paramCnt = 1

    encoderParams = DWord(paramCnt) + encoderParams
    THIS.STAT = GdipSaveAddImage(THIS.nativeImage, tnImage, @encoderParams)
  ENDPROC

  PROCEDURE SaveAsPNG(tcFileName)
    IF VARTYPE(tcFileName) != 'C'
      ERROR 11
    ENDIF

    LOCAL encoderClsid, lcFile
    lcFile = DEFAULTEXT(tcFileName, "png")
    ERASE (lcFile)
    encoderClsid = THIS.StrToGuid(CLSID_PNG)
    THIS.STAT = GdipSaveImageToFile(THIS.nativeImage, THIS.WideStr(lcFile), @encoderClsid, NULL)
  ENDPROC

  PROCEDURE ImageFormat_Access
    LOCAL lcFormat
    lcFormat = THIS.StrToGuid(GUID_FormatUndefined)
    THIS.STAT = GdipGetImageRawFormat(THIS.nativeImage, @lcFormat)
    DO CASE
      CASE lcFormat = THIS.StrToGuid(GUID_FormatMemoryBMP) OR lcFormat = THIS.StrToGuid(GUID_FormatBMP)
        RETURN "BMP"
      CASE lcFormat = THIS.StrToGuid(GUID_FormatEMF)
        RETURN "EMF"
      CASE lcFormat = THIS.StrToGuid(GUID_FormatWMF)
        RETURN "WMF"
      CASE lcFormat = THIS.StrToGuid(GUID_FormatJPEG)
        RETURN "JPEG"
      CASE lcFormat = THIS.StrToGuid(GUID_FormatPNG)
        RETURN "PNG"
      CASE lcFormat = THIS.StrToGuid(GUID_FormatGIF)
        RETURN "GIF"
      CASE lcFormat = THIS.StrToGuid(GUID_FormatTIFF)
        RETURN "TIFF"
      CASE lcFormat = THIS.StrToGuid(GUID_FormatEXIF)
        RETURN "EXIF"
      CASE lcFormat = THIS.StrToGuid(GUID_FormatIcon)
        RETURN "ICON"
      OTHERWISE
        RETURN "UNDEFINED"
    ENDCASE
  ENDPROC

  PROCEDURE PixelFormat_Access
    LOCAL lnFormat
    lnFormat = 0
    THIS.STAT = GdipGetImagePixelFormat(THIS.nativeImage, @lnFormat)
    DO CASE
      CASE lnFormat = PixelFormat1bppIndexed
        RETURN "1bppIndexed"
      CASE lnFormat = PixelFormat4bppIndexed
        RETURN "4bppIndexed"
      CASE lnFormat = PixelFormat8bppIndexed
        RETURN "8bppIndexed"
      CASE lnFormat = PixelFormat16bppGrayScale
        RETURN "16bppGrayScale"
      CASE lnFormat = PixelFormat16bppRGB555
        RETURN "16bppRGB555"
      CASE lnFormat = PixelFormat16bppRGB565
        RETURN "16bppRGB565"
      CASE lnFormat = PixelFormat16bppARGB1555
        RETURN "16bppARGB1555"
      CASE lnFormat = PixelFormat24bppRGB
        RETURN "24bppRGB"
      CASE lnFormat = PixelFormat32bppRGB
        RETURN "32bppRGB"
      CASE lnFormat = PixelFormat32bppARGB
        RETURN "32bppARGB"
      CASE lnFormat = PixelFormat32bppPARGB
        RETURN "32bppPARGB"
      CASE lnFormat = PixelFormat48bppRGB
        RETURN "48bppRGB"
      CASE lnFormat = PixelFormat64bppARGB
        RETURN "64bppARGB"
      CASE lnFormat = PixelFormat64bppPARGB
        RETURN "64bppPARGB"
      OTHERWISE
        RETURN "Undefined"
    ENDCASE
  ENDPROC

  PROCEDURE PixelFormat_Assign(tcFormat)
    IF VARTYPE(tcFormat) != 'C'
      ERROR 11
    ENDIF

    LOCAL lnFormat, lnWidth, lnHeight, gpdstBitmap
    lnFormat = THIS.StrToPixelFormat(tcFormat)

    lnWidth = 0
    THIS.STAT = GdipGetImageWidth(THIS.nativeImage, @lnWidth)
    lnHeight = 0
    THIS.STAT = GdipGetImageHeight(THIS.nativeImage, @lnHeight)
    gpdstBitmap = 0
    THIS.STAT = GdipCloneBitmapAreaI(0, 0, lnWidth, lnHeight, ;
      lnFormat, THIS.nativeImage, @gpdstBitmap)
    IF THIS.STAT = 0
      GdipDisposeImage(THIS.nativeImage)
      THIS.nativeImage = gpdstBitmap
    ENDIF
  ENDPROC

  PROCEDURE ImageWidth_Access
    LOCAL lnWidth
    lnWidth = 0
    THIS.STAT = GdipGetImageWidth(THIS.nativeImage, @lnWidth)
    RETURN lnWidth
  ENDPROC

  PROCEDURE ImageHeight_Access
    LOCAL lnHeight
    lnHeight = 0
    THIS.STAT = GdipGetImageHeight(THIS.nativeImage, @lnHeight)
    RETURN lnHeight
  ENDPROC

  PROCEDURE HorizontalResolution_Access
    LOCAL lnResolution
    lnResolution = 0
    THIS.STAT = GdipGetImageHorizontalResolution(THIS.nativeImage, @lnResolution)
    RETURN lnResolution
  ENDPROC

  PROCEDURE VerticalResolution_Access
    LOCAL lnResolution
    lnResolution = 0
    THIS.STAT = GdipGetImageVerticalResolution(THIS.nativeImage, @lnResolution)
    RETURN lnResolution
  ENDPROC

  PROCEDURE HorizontalResolution_Assign(tnResolution)
    IF VARTYPE(tnResolution) != 'N'
      ERROR 11
    ENDIF
    LOCAL lnVertRes
    lnVertRes = 0
    THIS.STAT = GdipGetImageVerticalResolution(THIS.nativeImage, @lnVertRes)
    THIS.STAT = GdipBitmapSetResolution(THIS.nativeImage, tnResolution, lnVertRes)
  ENDPROC

  PROCEDURE VerticalResolution_Assign(tnResolution)
    IF VARTYPE(tnResolution) != 'N'
      ERROR 11
    ENDIF
    LOCAL lnHorRes
    lnHorRes = 0
    THIS.STAT = GdipGetImageHorizontalResolution(THIS.nativeImage, @lnHorRes)
    THIS.STAT = GdipBitmapSetResolution(THIS.nativeImage, lnHorRes, tnResolution)
  ENDPROC

  PROCEDURE GetPixelColor(x, Y)
    IF (VARTYPE(x) != 'N') OR (VARTYPE(Y) != 'N')
      ERROR 11
    ENDIF
    LOCAL argb, red, green, blue
    argb = 0
    THIS.STAT = GdipBitmapGetPixel(THIS.nativeImage, x, Y, @argb)
    red = BITRSHIFT(BITAND(argb, 0x00FF0000), 16)
    green = BITRSHIFT(BITAND(argb, 0x0000FF00), 8)
    blue = BITAND(argb, 0x000000FF)
    THIS.PixelRed   = Red
    THIS.PixelGreen = Green
    THIS.PixelBlue  = Blue
    RETURN red + BITLSHIFT(green, 8) + BITLSHIFT(blue, 16)
  ENDPROC

  PROCEDURE GetPixelAlpha(x, Y)
    IF (VARTYPE(x) != 'N') OR (VARTYPE(Y) != 'N')
      ERROR 11
    ENDIF
    LOCAL argb
    argb = 0
    THIS.STAT = GdipBitmapGetPixel(THIS.nativeImage, x, Y, @argb)
    RETURN BITRSHIFT(argb, 24)
  ENDPROC

  PROCEDURE SetPixel(x, Y, tnColor, tnAlpha)
    IF (VARTYPE(x) != 'N') OR (VARTYPE(Y) != 'N') OR (VARTYPE(tnColor) != 'N')
      ERROR 11
    ENDIF
    IF !EMPTY(tnAlpha) AND (VARTYPE(tnAlpha) != 'N')
      ERROR 11
    ENDIF
    LOCAL argb
    argb = MakeARGB(tnColor, tnAlpha)
    THIS.STAT = GdipBitmapSetPixel(THIS.nativeImage, x, Y, argb)
  ENDPROC

  PROCEDURE Crop(x, Y, tnWidth, tnHeight)
    IF (VARTYPE(x) != 'N') OR (VARTYPE(Y) != 'N')
      ERROR 11
    ENDIF
    IF (VARTYPE(tnWidth) != 'N') OR (VARTYPE(tnHeight) != 'N')
      ERROR 11
    ENDIF
    LOCAL lnFormat, gpdstBitmap
    lnFormat = 0
    THIS.STAT = GdipGetImagePixelFormat(THIS.nativeImage, @lnFormat)
    gpdstBitmap = 0
    THIS.STAT = GdipCloneBitmapAreaI(x, Y, tnWidth, tnHeight, ;
      lnFormat, THIS.nativeImage, @gpdstBitmap)
    IF THIS.STAT = 0
      GdipDisposeImage(THIS.nativeImage)
      THIS.nativeImage = gpdstBitmap
    ENDIF
  ENDPROC

  PROCEDURE ROTATEFLIP(rotateFlipType)
    IF VARTYPE(rotateFlipType) != 'N'
      ERROR 11
    ENDIF
    THIS.STAT = GdipImageRotateFlip(THIS.nativeImage, rotateFlipType)
  ENDPROC

  PROCEDURE RESIZE(tnWidth, tnHeight, tnInterpolationMode)
    IF (VARTYPE(tnWidth) != 'N') OR (VARTYPE(tnHeight) != 'N')
      ERROR 11
    ENDIF
    IF !EMPTY(tnInterpolationMode) AND (VARTYPE(tnInterpolationMode) != 'N')
      ERROR 11
    ENDIF
    IF VARTYPE(tnInterpolationMode) != 'N'
      tnInterpolationMode = InterpolationModeDefault
    ENDIF

    LOCAL lnFormat, graphics, resizedImage
    lnFormat = 0
    graphics = 0
    resizedImage = 0

    THIS.STAT = GdipGetImagePixelFormat(THIS.nativeImage, @lnFormat)
    THIS.STAT = GdipCreateBitmapFromScan0(tnWidth, tnHeight, 0, lnFormat, 0, @resizedImage)
    IF THIS.STAT != 0
      RETURN
    ENDIF
    THIS.STAT = GdipGetImageGraphicsContext(resizedImage, @graphics)
    IF THIS.STAT != 0
      RETURN
    ENDIF
    THIS.STAT = GdipSetInterpolationMode(graphics, tnInterpolationMode)
    THIS.STAT = GdipDrawImageRectI(graphics, THIS.nativeImage, 0, 0, tnWidth, tnHeight)
    IF THIS.STAT = 0
      GdipDisposeImage(THIS.nativeImage)
      THIS.nativeImage = resizedImage
    ENDIF
  ENDPROC

  FUNCTION GetPageCount()
    LOCAL dimensionID, COUNT
    dimensionID = THIS.StrToGuid(GUID_Page)
    COUNT = 0
    GdipImageGetFrameCount(THIS.nativeImage, @dimensionID, @COUNT)
    RETURN COUNT
  ENDFUNC

  PROCEDURE SelectPage(tnPage)
    IF (VARTYPE(tnPage) != 'N')
      ERROR 11
    ENDIF
    LOCAL dimensionID
    dimensionID = THIS.StrToGuid(GUID_Page)
    GdipImageSelectActiveFrame(THIS.nativeImage, @dimensionID, tnPage)
  ENDPROC

  FUNCTION GetFrameCount()
    LOCAL dimensionID, COUNT
    dimensionID = THIS.StrToGuid(GUID_Time)
    COUNT = 0
    GdipImageGetFrameCount(THIS.nativeImage, @dimensionID, @COUNT)
    RETURN COUNT
  ENDFUNC

  PROCEDURE SelectFrame(tnFrame)
    IF (VARTYPE(tnFrame) != 'N')
      ERROR 11
    ENDIF
    LOCAL dimensionID
    dimensionID = THIS.StrToGuid(GUID_Time)
    GdipImageSelectActiveFrame(THIS.nativeImage, @dimensionID, tnFrame)
  ENDPROC

  PROCEDURE Capture(thWnd)
    IF VARTYPE(thWnd) != 'N'
      ERROR 11
    ENDIF
    IF THIS.nativeImage != 0
      GdipDisposeImage(THIS.nativeImage)
    ENDIF
    THIS.nativeImage = 0
    LOCAL bmp
    LOCAL lhDC, lhMemDC, lhOldBmp, lhMemBmp
    LOCAL lnWidth, lnHeight

    IF EMPTY(thWnd)
      thWnd = GetDesktopWindow()
    ENDIF
    lhDC = GetWindowDC(thWnd)
    = THIS.GetWinRect(thWnd, @lnWidth, @lnHeight)

    lhMemDC = CreateCompatibleDC(lhDC)
    lhMemBmp = CreateCompatibleBitmap(lhDC, lnWidth, lnHeight)

    lhOldBmp = SelectObject(lhMemDC, lhMemBmp)
    = BitBlt(lhMemDC, 0, 0, lnWidth, lnHeight, lhDC, 0, 0, SRCCOPY)
    = SelectObject(lhMemDC, lhOldBmp)

    = DeleteDC(lhMemDC)
    = ReleaseDC(thWnd, lhDC)

    bmp = 0
    THIS.STAT = GdipCreateBitmapFromHBITMAP(lhMemBmp, 0, @bmp)
    IF THIS.STAT = 0
      THIS.nativeImage = bmp
    ENDIF
    DeleteObject(lhMemBmp)
  ENDPROC


  ***********************************************************************
  * Protected functions
  ***********************************************************************

  *!*		Protected Procedure PrintHDC(thDC)
  *!*		EndProc

  PROTECTED PROCEDURE GetWinRect(HWND, lnWidth, lnHeight)
    * Returns width and height of window, passed by handle
    LOCAL lpRect, lnLeft, lnTop, lnRight, lnBottom
    lpRect = REPLICATE(CHR(0), 16)
    = GetWindowRect(HWND, @lpRect)

    lnLeft   = THIS.LongToNum(SUBSTR(lpRect,  1, 4))
    lnTop    = THIS.LongToNum(SUBSTR(lpRect,  5, 4))
    lnRight  = THIS.LongToNum(SUBSTR(lpRect,  9, 4))
    lnBottom = THIS.LongToNum(SUBSTR(lpRect, 13, 4))

    lnWidth  = lnRight - lnLeft
    lnHeight = lnBottom - lnTop
  ENDPROC

  PROTECTED FUNCTION LongToNum(tcLong)
    * Converts a signed long value to a VFP numeric
    LOCAL nNum
    nNum = 0
    RtlCopyLong(@nNum, tcLong, 4)
    RETURN nNum
  ENDFUNC

  PROTECTED FUNCTION StrToPixelFormat(tcFormat)
    tcFormat = UPPER(tcFormat)
    DO CASE
      CASE tcFormat = "1BPPINDEXED"
        RETURN PixelFormat1bppIndexed
      CASE tcFormat = "4BPPINDEXED"
        RETURN PixelFormat4bppIndexed
      CASE tcFormat = "8BPPINDEXED"
        RETURN PixelFormat8bppIndexed
      CASE tcFormat = "16BPPGRAYSCALE"
        RETURN PixelFormat16bppGrayScale
      CASE tcFormat = "16BPPRGB555"
        RETURN PixelFormat16bppRGB555
      CASE tcFormat = "16BPPRGB565"
        RETURN PixelFormat16bppRGB565
      CASE tcFormat = "16BPPARGB1555"
        RETURN PixelFormat16bppARGB1555
      CASE tcFormat = "24BPPRGB"
        RETURN PixelFormat24bppRGB
      CASE tcFormat = "32BPPRGB"
        RETURN PixelFormat32bppRGB
      CASE tcFormat = "32BPPARGB"
        RETURN PixelFormat32bppARGB
      CASE tcFormat = "32BPPPARGB"
        RETURN PixelFormat32bppPARGB
      CASE tcFormat = "48BPPRGB"
        RETURN PixelFormat48bppRGB
      CASE tcFormat = "64BPPARGB"
        RETURN PixelFormat64bppARGB
      CASE tcFormat = "64BPPPARGB"
        RETURN PixelFormat64bppPARGB
      OTHERWISE
        ERROR 11
    ENDCASE
  ENDFUNC

  PROTECTED FUNCTION StrToGuid(s)
    LOCAL guid
    guid = SPACE(16)
    s = CHRTRAN(s, "{}", "")
    UuidFromString(s, @guid)
    RETURN guid
  ENDFUNC

  PROTECTED FUNCTION WideStr(tcStr)
    #IF VERSION(5) >= 700
      RETURN STRCONV(tcStr + CHR(0), 5)
    #ELSE
      LOCAL lnLen, lcWideStr
      lnLen = 2 * (LEN(tcStr) + 1)
      lcWideStr = REPLICATE(CHR(0), lnLen)
      MultiByteToWideChar(0, 0, @tcStr, LEN(tcStr), @lcWideStr, lnLen)
      RETURN lcWideStr
    #ENDIF
  ENDFUNC

  PROTECTED PROCEDURE stat_Assign(tnStatus)
    *!*			If tnStatus != 0
    *!*				Local res
    *!*				res = MessageBox("GDI+ error in " + Program(Program(-1) - 1) + CRLF;
    *!*					+ "Error code : " + Transform(tnStatus) + CRLF ;
    *!*					+ "Description: " + ErrorInfo(tnStatus) + CRLF + CRLF;
    *!*					+ "Press 'Retry' to debug the application.", 16 + 2, "Error")
    *!*				If res = 3
    *!*					Cancel
    *!*				EndIf
    *!*				If res = 4
    *!*					Suspend
    *!*				EndIf
    *!*			EndIf
    THIS.STAT = tnStatus
  ENDPROC

ENDDEFINE

***********************************************************************
*   Class:	Graphics
***********************************************************************

DEFINE CLASS Graphics AS CUSTOM
  PROTECTED STAT
  PROTECTED nativeGraphics
  PROTECTED nativeImage

  nativeImage = 0
  nativeGraphics = 0
  brush    = 0
  PEN      = 0
  rectf    = 0
  nalign   = 0
  StringMeasure = .T.
  StringW  = 0 && Gets Width  from MeasureString
  StringH  = 0 && Gets Height from MeasureString
  StringChars = 0
  StringLines = 0
  PageScale   = 0
  ImgAttribs  = 0

  PROTECTED PROCEDURE INIT(tnNImage,tcMODE)
    IF PCOUNT() = 0
      RETURN
    ENDIF

    IF !(VARTYPE(m.tnNImage) == "N")
      ERROR 11
    ENDIF

    IF PCOUNT() = 1
      tcMode = "IMG"
    ENDIF

    THIS.NativeImage    = tnNImage
    DO CASE
      CASE UPPER(tcMode) = "IMG"
        THIS.CreateFromImage(m.tnNImage)
      CASE UPPER(tcMode) = "HWND"
        THIS.CreateFromHWND(tnNImage)
      CASE UPPER(tcMode) = "HDC"

    ENDCASE
  ENDPROC

  FUNCTION CreateFromImage(tnImage)
    LOCAL graphics
    graphics = 0
    THIS.STAT = GdipGetImageGraphicsContext(m.tnImage, @graphics)
    THIS.NativeImage = tnImage
    THIS.NativeGraphics = m.graphics
    RETURN m.graphics
  ENDFUNC

  PROCEDURE CreateFromHWND(tnHWND)
    LOCAL graphics
    graphics = 0
    THIS.STAT = GdipCreateFromHWND(m.tnHWND, @graphics)
    THIS.NativeGraphics = m.graphics
    RETURN m.graphics
  ENDPROC

  PROTECTED PROCEDURE DESTROY
    IF THIS.PEN <> 0
      =GdipDeletePen(THIS.PEN)
    ENDIF

    IF THIS.Brush <> 0
      =GdipDeleteBrush(THIS.Brush)
    ENDIF

    IF THIS.nativeGraphics != 0
      =GdipDeleteGraphics(THIS.nativeGraphics)
    ENDIF
  ENDPROC

  PROTECTED PROCEDURE stat_Assign(tnStatus)
    IF tnStatus != 0
      LOCAL res
      res = MESSAGEBOX("GDI+ error in " + PROGRAM(PROGRAM(-1) - 1) + CRLF;
        + "Error code : " + TRANSFORM(tnStatus) + CRLF ;
        + "Description: " + ErrorInfo(tnStatus) + CRLF + CRLF;
        + "Press 'Retry' to debug the application.", 16 + 2, "Error")
      IF res = 3
        CANCEL
      ENDIF
      IF res = 4
        SUSPEND
      ENDIF
    ENDIF
    THIS.STAT = tnStatus
  ENDPROC

  *!*	PEN FUNCTIONS

  PROCEDURE SetPen(tnColor,tnWidth,tnUnit,tnDashStyle)
    IF VARTYPE(tnColor) <> 'N'
      ERROR 11	&& function argument
    ENDIF
    IF VARTYPE(tnWidth) == 'L'
      tnWidth = 1.0
    ENDIF
    IF VARTYPE(tnUnit) == 'L'
      tnUnit = 0
    ENDIF

    IF THIS.PEN <> 0
      THIS.DeletePen(THIS.PEN)
    ENDIF
    gdipen = 0
    lnARGB = makeargb(tncolor)
    THIS.STAT = GdipCreatePen1(lnARGB, tnWidth, tnUnit, @gdipen)
    THIS.PEN  = GdiPen
  ENDPROC

  PROCEDURE SetPenDash(tnDashStyle)
    IF PCOUNT() = 0 && Reset DashStyle to Solid
      tnDashStyle = 0
    ENDIF
    IF VARTYPE(tnDashStyle) <> 'N'
      ERROR 11	&& function argument
    ENDIF
    THIS.STAT = GdipSetPenDashStyle(THIS.PEN, m.tnDashStyle)
  ENDPROC

  PROCEDURE DeletePen(tnPen)
    THIS.STAT = GdipDeletePen(m.tnPen)
    THIS.PEN  = 0
  ENDPROC

  *!*	BRUSH FUNCTIONS

  PROCEDURE SetBrush(tnColor, tnAlpha)
    IF PCOUNT() = 1
      STORE 255 TO tnAlpha && Opaque
    ENDIF
    IF VARTYPE(tnColor) != 'N' OR VARTYPE(tnColor) != 'N'
      ERROR 11	&& function argument
    ENDIF

    IF THIS.Brush <> 0
      THIS.DeleteBrush(THIS.Brush)
    ENDIF
    gdibrush = 0
    THIS.STAT  = GdipCreateSolidFill(makeARGB(tnColor,tnAlpha), @gdiBrush)
    THIS.Brush = GdiBrush
  ENDPROC

  PROCEDURE SetHatchBrush(tnHatchStyle, tnBackCol, tnBackAlpha, tnForeCol, tnForeAlpha)
    IF VARTYPE(tnHatchStyle) + VARTYPE(tnBackCol) + VARTYPE(tnBackAlpha) <> "NNN"
      ERROR 11	&& function argument
    ENDIF

    IF VARTYPE(tnForeCol) = "L"
      tnForeCol = 0 && Black
    ENDIF

    IF VARTYPE(tnForeAlpha) = "L"
      tnBackCol = 255 && Opaque
    ENDIF

    IF THIS.Brush <> 0
      THIS.DeleteBrush(THIS.Brush)
    ENDIF
    gdibrush = 0
    THIS.STAT  = GdipCreateHatchBrush(tnHatchStyle, ;
      makeARGB(tnForeCol,tnForeAlpha), makeARGB(tnBackCol, tnBackAlpha), @gdiBrush)
    THIS.Brush = GdiBrush
  ENDPROC

  PROCEDURE SetTextureBrush(tcFileName, tnWrapMode)
    IF NOT VARTYPE(m.tcFileName) $ "CN"
      ERROR 11 && function argument
    ENDIF

    IF VARTYPE(m.tnWrapMode) = "L"
      tnWrapMode = 0 && WrapModeTile - Default
    ENDIF

    LOCAL lnPasteImage
    IF VARTYPE(m.tcFileName) = "C"  && Image file to load
      lnPasteImage = 0
      THIS.STAT = GdipLoadImageFromFile(THIS.WideStr(tcFileName), @lnPasteImage)
    ELSE && Use other image handle
      lnPasteImage = tcFileName
    ENDIF
    IF THIS.Brush <> 0
      THIS.DeleteBrush(THIS.Brush)
    ENDIF
    gdibrush = 0

    THIS.STAT = GdipCreateTexture(lnPasteImage, tnWrapMode, @gdiBrush)
    IF lnPasteImage <> THIS.NativeImage
      THIS.STAT = GdipDisposeImage(lnPasteImage)
    ENDIF
    THIS.Brush = GdiBrush
  ENDPROC

  PROCEDURE DeleteBrush(tnBrush)
    THIS.STAT = GdipDeleteBrush(m.tnBrush)
    THIS.Brush = 0
  ENDPROC

  *!*	GRAPHICS FUNCTIONS

  PROCEDURE TranslateTransform(tndX, tndY)
    IF VARTYPE(m.tndX) + VARTYPE(m.tndY) <> 'NN'
      ERROR 11 && function argument
    ENDIF
    THIS.STAT = GdipTranslateWorldTransform(THIS.GetGraphics(), tndX, tndY, 0)
  ENDPROC

  PROCEDURE RotateTransform(tnAngle)
    IF VARTYPE(m.tnAngle) <> 'N'
      ERROR 11 && function argument
    ENDIF
    THIS.STAT = GdipRotateWorldTransform(THIS.getgraphics(), tnAngle, 0)
  ENDPROC

  PROCEDURE ResetTransform
    THIS.STAT = GdipResetWorldTransform(THIS.getGraphics())
  ENDPROC

  *!*	STRING FUNCTIONS

  PROCEDURE DrawString(tcText, tcFontName, tnSize, tcFontStyle, tlMeasure)
    IF !(VARTYPE(tcText) + VARTYPE(tcFontName) + VARTYPE(tnSize) + ;
        VARTYPE(tcFontStyle) + VARTYPE(tlMeasure) == 'CCNCL')
      ERROR 11	&& function argument
    ENDIF

    lnFontStyle = GDIPLUS_FontStyle_Regular && 0
    tcFontStyle = UPPER(tcFontStyle)
    IF "B" $ tcFontStyle
      lnFontStyle = lnFontStyle + GDIPLUS_FontStyle_Bold && 1
    ENDIF
    IF "I" $ tcFontStyle
      lnFontStyle = lnFontStyle + GDIPLUS_FontStyle_Italic && 2
    ENDIF
    IF "U" $ tcFontStyle
      lnFontStyle = lnFontStyle + GDIPLUS_FontStyle_Underline && 4
    ENDIF
    IF "S" $ tcFontStyle
      lnFontStyle = lnFontStyle + GDIPLUS_FontStyle_Strikeout && 8
    ENDIF

    LOCAL lnFontFamily, lnFont, lcText, lcFontName, lcRectangleF
    STORE 0 TO lnFontFamily, lnFont && handles for FontFamily & FontName

    lcText       = THIS.Widestr(tcText)
    lcFontName   = THIS.Widestr(tcFontName)
    lcRectangleF = THIS.Rectf

    THIS.STAT = GdipCreateFontFamilyFromName(lcFontName, 0, @lnFontFamily)
    THIS.STAT = GdipCreateFont(lnFontFamily, tnSize, lnFontStyle, 3, @lnFont)

    THIS.STAT = GdipDrawString(THIS.getgraphics(), lcText, LEN(tcText), lnFont, ;
      @lcRectangleF, THIS.nAlign, THIS.Brush)

    IF tlMeasure = .T. OR THIS.StringMeasure = .T.
      THIS.GetMeasures(lcText, lnFont)
    ENDIF

    *** Clearing Font Handles
    THIS.STAT = GdipDeleteFont(lnFont)
    THIS.STAT = GdipDeleteFontFamily(lnFontFamily)
  ENDPROC

  PROTECTED PROCEDURE GetMeasures(tcText, tnFontHandle)
    LOCAL lcBoundingBox, lnCodePointsFitted, lnLines, lcRectangleF

    lcRectangleF = REPLICATE(CHR(0),16)
    lcBoundingBox = REPLICATE(CHR(0),16)
    lnChars = 0
    lnLines = 0

    THIS.STAT = GdipMeasureString(THIS.getgraphics(), m.tcText, -1, ;
      m.tnFontHandle, m.lcRectangleF, THIS.nAlign, @lcBoundingBox, @lnChars, @lnLines)

    THIS.GetRectfBounds(RIGHT(m.lcBoundingBox,8))

    THIS.StringChars = lnChars
    THIS.StringLines = lnLines
  ENDPROC

  PROTECTED FUNCTION GetRectfBounds(tcBoxf)
    THIS.StringW = float2int(buf2dword(SUBSTR(m.tcBoxF,1,4)))
    THIS.StringH = float2int(buf2dword(SUBSTR(m.tcBoxF,5,4)))
  ENDFUNC

  PROCEDURE MeasureString(tcText, tcFontName, tnSize, tcFontStyle)
    IF !(VARTYPE(tcText) + VARTYPE(tcFontName) + VARTYPE(tnSize) + VARTYPE(tcFontStyle) == 'CCNC')
      ERROR 11	&& function argument
    ENDIF

    lnFontStyle = GDIPLUS_FontStyle_Regular && 0
    tcFontStyle = UPPER(tcFontStyle)
    IF "B" $ tcFontStyle
      lnFontStyle = lnFontStyle + GDIPLUS_FontStyle_Bold && 1
    ENDIF
    IF "I" $ tcFontStyle
      lnFontStyle = lnFontStyle + GDIPLUS_FontStyle_Italic && 2
    ENDIF
    IF "U" $ tcFontStyle
      lnFontStyle = lnFontStyle + GDIPLUS_FontStyle_Underline && 4
    ENDIF
    IF "S" $ tcFontStyle
      lnFontStyle = lnFontStyle + GDIPLUS_FontStyle_Strikeout && 8
    ENDIF

    LOCAL lnFontFamilyHandle, lnRectf, lnFontHandle
    STORE 0 TO lnFontFamily, lnFont && handles for FontFamily & FontName

    lcText     = THIS.Widestr(tcText)
    lcFontName = THIS.Widestr(tcFontName)
    lnRectf    = THIS.Rectf

    THIS.STAT = GdipCreateFontFamilyFromName(lcFontName, 0, @lnFontFamilyHandle)
    THIS.STAT = GdipCreateFont(lnFontFamilyHandle, tnSize, lnFontStyle, 3, @lnFontHandle)

    LOCAL lcBoundingBox, lnCodePointsFitted, lnLines, lcRectangleF

    lcRectangleF  = REPLICATE(CHR(0),16)
    lcBoundingBox = REPLICATE(CHR(0),16)
    lnChars = 0
    lnLines = 0

    THIS.STAT = GdipMeasureString(THIS.getgraphics(), lcText, -1, ;
      lnFontHandle, m.lcRectangleF, THIS.nAlign, @lcBoundingBox, @lnChars, ;
      @lnLines)

    THIS.GetRectfBounds(RIGHT(m.lcBoundingBox,8))

    *** Clearing Font Handles
    THIS.STAT = GdipDeleteFont(lnFontHandle)
    THIS.STAT = GdipDeleteFontFamily(lnFontFamilyHandle)
  ENDPROC

  PROCEDURE SetRect(x, Y, tnWidth, tnHeight)
    IF PCOUNT() = 2
      STORE 0 TO tnWidth, tnHeight
    ENDIF

    IF !(VARTYPE(m.x) + VARTYPE(m.y) + VARTYPE(tnWidth) + VARTYPE(tnHeight) == 'NNNN')
      ERROR 11	&& function argument
    ENDIF
    THIS.Rectf = rectf(m.x, m.y, tnWidth, tnHeight)
  ENDPROC

  PROCEDURE SetAlignment(thAlignment,tvAlignment,tFlags) && Horizontal - Vertical - Flags
    IF PCOUNT() = 1
      STORE 0 TO tvAlignment, tFlags
    ENDIF
    IF PCOUNT() = 2
      STORE 0 TO tFlags
    ENDIF
    IF !(VARTYPE(m.thAlignment) + VARTYPE(m.tvAlignment) + VARTYPE(m.tFlags) == 'NNN')
      ERROR 11	&& function argument
    ENDIF
    lnFormatHandle = 0
    THIS.STAT = GdipCreateStringFormat(tFlags, 0, @lnFormatHandle )
    THIS.STAT = GdipSetStringFormatAlign(lnFormatHandle, m.thAlignment)
    THIS.STAT = GdipSetStringFormatLineAlign(lnFormatHandle, m.tvAlignment)
    THIS.nAlign = lnFormatHandle
  ENDPROC

  *!*	DRAWING SHAPES FUNCTIONS

  PROCEDURE DrawLine(tnX1, tnY1, tnX2, tnY2)
    IF VARTYPE(m.tnx1) + VARTYPE(m.tny1) + VARTYPE(m.tnx2) + VARTYPE(m.tny2) <> 'NNNN'
      ERROR 11	&& function argument
    ENDIF
    THIS.STAT = GdipDrawLine(THIS.getgraphics(), THIS.PEN, tnx1, tny1, tnx2, tny2)
  ENDPROC

  PROCEDURE DrawRect(tnx, tny, tnWidth, tnHeight)
    IF VARTYPE(m.tnx) + VARTYPE(m.tny) + VARTYPE(m.tnWidth) + VARTYPE(m.tnHeight) <> 'NNNN'
      ERROR 11	&& function argument
    ENDIF
    = GdipDrawRectangle(THIS.getgraphics(), THIS.PEN, m.tnx, m.tny, m.tnWidth, m.tnHeight)
  ENDPROC

  PROCEDURE FillRect(tnx, tny, tnWidth, tnHeight)
    IF VARTYPE(m.tnx) + VARTYPE(m.tny) + VARTYPE(tnWidth) + VARTYPE(tnHeight) <> 'NNNN'
      ERROR 11	&& function argument
    ENDIF
    THIS.STAT = GdipFillRectangle(THIS.GetGraphics(), THIS.Brush, m.tnx, m.tny, tnWidth, tnHeight)
  ENDPROC

  PROCEDURE DrawEllipse(tnX, tnY, tnW, tnH)
    IF VARTYPE(m.tnX) + VARTYPE(m.tnY) + VARTYPE(m.tnW) + VARTYPE(m.tnH) <> 'NNNN'
      ERROR 11 && function argument
    ENDIF
    THIS.STAT = GdipDrawEllipse(THIS.getGraphics(), THIS.PEN, m.tnX, m.tnY, m.tnW, m.tnH)
  ENDPROC

  PROCEDURE FillEllipse(tnX, tnY, tnW, tnH)
    IF VARTYPE(m.tnX) + VARTYPE(m.tnY) + VARTYPE(m.tnW) + VARTYPE(m.tnH) <> 'NNNN'
      ERROR 11 && function argument
    ENDIF
    THIS.STAT = GdipFillEllipse(THIS.getgraphics(), THIS.Brush, m.tnX, m.tnY, m.tnW, m.tnH)
  ENDPROC

  PROCEDURE DrawPie(tnx, tny, tnw, tnh, tnStartAngle, tnSweepAngle)
    IF VARTYPE(m.tnX) + VARTYPE(m.tnY) + VARTYPE(m.tnW) + VARTYPE(m.tnH) + ;
        VARTYPE(m.tnStartAngle) + VARTYPE(m.tnSweepAngle) <> 'NNNNNN'
      ERROR 11 && function argument
    ENDIF
    THIS.STAT = GdipDrawPie(THIS.GetGraphics(), THIS.PEN, m.tnX, m.tnY, ;
      m.tnW, m.tnH, m.tnStartAngle, m.tnSweepAngle)
  ENDPROC

  PROCEDURE FillPie(tnx, tny, tnw, tnh, tnStartAngle, tnSweepAngle)
    IF VARTYPE(m.tnX) + VARTYPE(m.tnY) + VARTYPE(m.tnW) + VARTYPE(m.tnH) + ;
        VARTYPE(m.tnStartAngle) + VARTYPE(m.tnSweepAngle) <> 'NNNNNN'
      ERROR 11 && function argument
    ENDIF
    THIS.STAT = GdipFillPie(THIS.GetGraphics(), THIS.Brush, m.tnX, m.tnY, ;
      m.tnW, m.tnH, m.tnStartAngle, m.tnSweepAngle)
  ENDPROC

  PROCEDURE DrawArc(tnx, tny, tnw, tnh, tnStartAngle, tnSweepAngle)
    IF VARTYPE(m.tnX) + VARTYPE(m.tnY) + VARTYPE(m.tnW) + VARTYPE(m.tnH) + ;
        VARTYPE(m.tnStartAngle) + VARTYPE(m.tnSweepAngle) <> 'NNNNNN'
      ERROR 11 && function argument
    ENDIF
    THIS.STAT = GdipDrawArc(THIS.GetGraphics(), THIS.PEN, m.tnX, m.tnY, ;
      m.tnW, m.tnH, m.tnStartAngle, m.tnSweepAngle)
  ENDPROC

  PROCEDURE DrawPolygon(taPoints)
    LOCAL lcPoints
    lcPoints = MakePointsFSequence(@taPoints)
    THIS.STAT = GdipDrawPolygon(THIS.GetGraphics(), THIS.PEN, ;
      m.lcPoints, ALEN(taPoints,1))
  ENDPROC

  PROCEDURE FillPolygon(taPoints)
    LOCAL lcPoints
    lcPoints = MakePointsFSequence(@taPoints)
    THIS.STAT = GdipFillPolygon( THIS.GetGraphics(), THIS.Brush, ;
      m.lcPoints, ALEN(taPoints,1), 0 )
  ENDPROC

  *!*	DRAWING IMAGES FUNCTIONS

  PROCEDURE DrawImage(tcFileName, tnX, tnY, tnWidth, tnHeight)&&)
    IF PCOUNT() = 5 && Draw Image Scaled
      THIS.DrawImageScaled(tcFileName, tnX, tnY, tnWidth, tnHeight)
      RETURN
    ENDIF
    IF VARTYPE(m.tnX) + VARTYPE(m.tnY) <> 'NN' OR NOT VARTYPE(m.tcFileName) $ "CN"
      ERROR 11 && function argument
    ENDIF
    LOCAL lnPasteImage
    IF VARTYPE(m.tcFileName) = "C"  && Image file to load
      lnPasteImage = 0
      THIS.STAT = GdipLoadImageFromFile(THIS.WideStr(tcFileName), @lnPasteImage)
    ELSE && Use other image handle
      lnPasteImage = tcFileName
    ENDIF
    THIS.STAT = GdipDrawImage(THIS.getgraphics(), lnPasteImage, m.tnX, m.tnY)
    IF lnPasteImage <> THIS.NativeImage AND VARTYPE(m.tcFileName) = "C"  && Image file
      THIS.STAT = GdipDisposeImage(lnPasteImage)
    ENDIF
  ENDPROC

  PROCEDURE DrawImageScaled(tcFileName, tnX, tnY, tnWidth, tnHeight)
    IF VARTYPE(m.tnX) + VARTYPE(m.tnY) + VARTYPE(m.tnWidth) + VARTYPE(m.tnHeight) <> 'NNNN' ;
        OR NOT VARTYPE(m.tcFileName) $ "CN"
      ERROR 11 && function argument
    ENDIF
    IF VARTYPE(m.tcFileName) = "C"  && Image file to load
      lnPasteImage = 0
      THIS.STAT = GdipLoadImageFromFile(THIS.WideStr(tcFileName), @lnPasteImage)
    ELSE && Use other image handle
      lnPasteImage = tcFileName
    ENDIF
    THIS.STAT = GdipDrawImageRect(THIS.getgraphics(), lnPasteImage, m.tnX, m.tnY, m.tnWidth, m.tnHeight)
    IF lnPasteImage <> THIS.NativeImage AND VARTYPE(m.tcFileName) = "C"  && Image file
      THIS.STAT = GdipDisposeImage(lnPasteImage)
    ENDIF
  ENDPROC

  PROCEDURE DrawImageRectRect(tcFileName, ;
      dstx, dsty, dstwidth, dstheight, ;
      srcx, srcy, srcwidth, srcheight)

    IF VARTYPE(m.dstX) + VARTYPE(m.dstY) + VARTYPE(m.dstWidth) + VARTYPE(m.dstHeight) + ;
        VARTYPE(m.srcX) + VARTYPE(m.srcY) + VARTYPE(m.srcWidth) + VARTYPE(m.srcHeight) <> 'NNNNNNNN' ;
        OR NOT VARTYPE(m.tcFileName) $ "CN"
      ERROR 11 && function argument
    ENDIF

    LOCAL lnPasteImage, nScrUnit, imageattribs
    IF VARTYPE(m.tcFileName) = "C"  && Image file to load
      lnPasteImage = 0
      THIS.STAT = GdipLoadImageFromFile(THIS.WideStr(tcFileName), @lnPasteImage)
    ELSE && Use other image handle
      lnPasteImage = tcFileName
    ENDIF

    imageAttribs = THIS.ImgAttribs
    SrcUnit = 2 && GraphicsUnit:Pixel
    THIS.STAT = GdipDrawImageRectRect(THIS.GetGraphics(), lnPasteImage, ;
      m.dstx, m.dsty, m.dstwidth, m.dstheight, ;
      m.srcx, m.srcy, m.srcwidth, m.srcheight, ;
      m.srcUnit, m.imageAttribs, 0, 0)

    IF lnPasteImage <> THIS.NativeImage AND VARTYPE(m.tcFileName) = "C"  && Image file
      THIS.STAT = GdipDisposeImage(lnPasteImage)
    ENDIF

  ENDPROC

  *!*	IMAGE ATTRIBUTES

  PROCEDURE SetColorMatrix(taColMatrix)
    *!*	The enableFlag parameter in the flat function is a Boolean value
    *!*	that specifies whether a separate color adjustment is enabled for
    *!*	the category specified by the type parameter. SetColorMatrix sets
    *!*	enableFlag to TRUE, and ClearColorMatrix sets enableFlag to FALSE.

    *!*	The grayMatrix parameter specifies a matrix to be used for adjusting
    *!*	gray shades when the value of the flags parameter is ColorMatrixFlagsAltGray.

    LOCAL lcColorMatrix
    lcColorMatrix = MakeColorMatrix(@taColMatrix)
    IF THIS.ImgAttribs <> 0
      THIS.DisposeImageAttributes(THIS.ImgAttribs)
    ENDIF
    imageattr = 0
    THIS.STAT = GdipCreateImageAttributes(@imageattr)
    THIS.ImgAttribs = imageAttr

    THIS.STAT = GdipSetImageAttributesColorMatrix(ImageAttr, ;
      0, ;
      1, ;
      lcColorMatrix, ;
      0, ;
      0)
  ENDPROC

  PROCEDURE RemapTable(tnOldColor, tnNewColor, tnOldAlpha, tnNewAlpha)
    LOCAL argbOld, argbNew, lcColorMap, imageattr

    IF PCOUNT() = 1 AND VARTYPE(tnOldColor) = "N" && Array of Colors is expected
      lcColorMap = MakeColorMap(@tnOldColor)
    ELSE
      IF PCOUNT() = 2 && Ignore Alpha = 255 - opaque
        tnOldAlpha = 255
        tnNewAlpha = 255
      ENDIF
      IF VARTYPE(tnOldColor) + VARTYPE(tnNewColor) <> "NN"
        ERROR 11
      ENDIF

      argbOld = MakeARGB(tnOldColor, tnOldAlpha)
      argbNew = MakeARGB(tnNewColor, tnNewAlpha)
      lcColorMap = dword(argbOld) + dword(argbNew)
    ENDIF

    IF THIS.ImgAttribs <> 0
      THIS.DisposeImageAttributes(THIS.ImgAttribs)
    ENDIF

    imageattr = 0
    THIS.STAT = GdipCreateImageAttributes(@imageattr)
    THIS.ImgAttribs = imageAttr
    THIS.STAT = GdipSetImageAttributesRemapTable(imageattr, 0 ,1, (LEN(lcColorMap)/4), lcColorMap)
  ENDPROC

  PROCEDURE DisposeImageAttributes(tnImgAttributes)
    THIS.STAT = GdipDisposeImageAttributes(tnImgAttributes)
    THIS.ImgAttribs = 0
  ENDPROC

  PROCEDURE ResetImageAttributes(tnImgAttributes)
    THIS.STAT = GdipResetImageAttributes(tnImgAttributes, 0)
    THIS.ImgAttribs = 0
  ENDPROC

  PROCEDURE ChangeColors(tnRed, tnGreen, tnBlue, tnAlpha)
    IF PCOUNT() = 1
      IF VARTYPE(tnRed) <> "N"
        ERROR 11
      ENDIF
    ELSE
      IF (VARTYPE(tnRed) + VARTYPE(tnGreen) + VARTYPE(tnBlue) <> "NNN") ;
          OR (NOT VARTYPE(tnAlpha) $ "NL")
        ERROR 11
      ENDIF
    ENDIF

    IF VARTYPE(tnAlpha) = "L"
      tnAlpha = 0
    ENDIF

    LOCAL lnWidth, lnHeight
    lnWidth  = 0
    lnHeight = 0
    THIS.STAT = GdipGetImageWidth(THIS.nativeImage, @lnWidth)
    THIS.STAT = GdipGetImageHeight(THIS.nativeImage, @lnHeight)

    IF PCOUNT() = 1
      THIS.SetPredefColorMatrix(tnRed)
    ELSE
      THIS.SetPredefColorMatrix(tnRed, tnGreen, tnBlue, tnAlpha)
    ENDIF

    THIS.DrawImageRectRect(THIS.NativeImage,0,0,lnWidth,lnHeight,0,0,lnWidth,lnHeight)
  ENDPROC

  PROCEDURE SetPredefColorMatrix(tnRed, tnGreen, tnBlue, tnAlpha)
    *!*	Great information about COLOR MATRICES can be found at
    *!*	http://www.bobpowell.net/
    *!*	There I found all information I needed about COLOR MATRICES

    IF PCOUNT() = 1 && Predefined

      IF tnRed = 1 && BW
        *!*	BLACK AND WHITE IMAGE
        DIMENSION taBW(5,5)
        taBW(1,1) = 0.299
        taBW(1,2) = 0.299
        taBW(1,3) = 0.299
        taBW(1,4) = 0
        taBW(1,5) = 0

        taBW(2,1) = 0.587
        taBW(2,2) = 0.587
        taBW(2,3) = 0.587
        taBW(2,4) = 0
        taBW(2,5) = 0

        taBW(3,1) = 0.114
        taBW(3,2) = 0.114
        taBW(3,3) = 0.114
        taBW(3,4) = 0
        taBW(3,5) = 0

        taBW(4,1) = 0
        taBW(4,2) = 0
        taBW(4,3) = 0
        taBW(4,4) = 1
        taBW(4,5) = 0

        taBW(5,1) = 0
        taBW(5,2) = 0
        taBW(5,3) = 0
        taBW(5,4) = 0
        taBW(5,5) = 1
        THIS.SetColorMatrix(@taBW)
      ENDIF

      IF tnRed = 2 && Negative
        *!*	NEGATIVE IMAGE
        DIMENSION taNEGATIVE(5,5)
        taNEGATIVE(1,1) = -1
        taNEGATIVE(1,2) = 0
        taNEGATIVE(1,3) = 0
        taNEGATIVE(1,4) = 0
        taNEGATIVE(1,5) = 0

        taNEGATIVE(2,1) = 0
        taNEGATIVE(2,2) = -1
        taNEGATIVE(2,3) = 0
        taNEGATIVE(2,4) = 0
        taNEGATIVE(2,5) = 0

        taNEGATIVE(3,1) = 0
        taNEGATIVE(3,2) = 0
        taNEGATIVE(3,3) = -1
        taNEGATIVE(3,4) = 0
        taNEGATIVE(3,5) = 0

        taNEGATIVE(4,1) = 0
        taNEGATIVE(4,2) = 0
        taNEGATIVE(4,3) = 0
        taNEGATIVE(4,4) = 1
        taNEGATIVE(4,5) = 0

        taNEGATIVE(5,1) = 0
        taNEGATIVE(5,2) = 0
        taNEGATIVE(5,3) = 0
        taNEGATIVE(5,4) = 0
        taNEGATIVE(5,5) = 1
        THIS.SetColorMatrix(@taNEGATIVE)
      ENDIF

    ELSE

      *!*	CHANGE COLORS
      sr = tnRed / 100
      sg = tnGreen / 100
      sb = tnBlue / 100
      sa = tnAlpha / 100

      ** create the color matrix
      DIMENSION taCUSTOM(5,5)
      taCUSTOM(1,1) = 1
      taCUSTOM(1,2) = 0
      taCUSTOM(1,3) = 0
      taCUSTOM(1,4) = 0
      taCUSTOM(1,5) = 0

      taCUSTOM(2,1) = 0
      taCUSTOM(2,2) = 1
      taCUSTOM(2,3) = 0
      taCUSTOM(2,4) = 0
      taCUSTOM(2,5) = 0

      taCUSTOM(3,1) = 0
      taCUSTOM(3,2) = 0
      taCUSTOM(3,3) = 1
      taCUSTOM(3,4) = 0
      taCUSTOM(3,5) = 0

      taCUSTOM(4,1) = 0
      taCUSTOM(4,2) = 0
      taCUSTOM(4,3) = 0
      taCUSTOM(4,4) = 1
      taCUSTOM(4,5) = 0

      taCUSTOM(5,1) = sr
      taCUSTOM(5,2) = sg
      taCUSTOM(5,3) = sb
      taCUSTOM(5,4) = sa
      taCUSTOM(5,5) = 1
      THIS.SetColorMatrix(@taCUSTOM)
    ENDIF
  ENDPROC

  PROCEDURE CreateFromGraphics(tnGraphics)
    DECLARE INTEGER GdipGetClipBounds IN GDIPLUS.DLL ;
      INTEGER nGraphics, STRING @ pRectF
    LOCAL lcRectF, nImage
    lcRectF = REPLICATE(CHR(0),16)
    THIS.STAT = GdipGetClipBounds (tnGraphics, @lcRectF )
    W = float2int(buf2dword(SUBSTR(m.lcRectF,9,4)))
    H = float2int(buf2dword(SUBSTR(m.lcRectF,13,4)))
    DECLARE INTEGER GdipCreateBitmapFromGraphics IN GDIPLUS.DLL ;
      INTEGER nWidth, INTEGER nHeight, INTEGER nGraphics, INTEGER @ nImage

    *!*	this.Destroy()
    nImage = 0
    THIS.STAT = GdipCreateBitmapFromGraphics(m.W, m.H, tnGraphics, @nImage)
  ENDPROC

  FUNCTION GetImage
    RETURN THIS.nativeImage
  ENDFUNC

  FUNCTION GetGraphics
    RETURN THIS.nativeGraphics
  ENDFUNC

  PROTECTED FUNCTION WideStr(tcStr)
    #IF VERSION(5) >= 700
      RETURN STRCONV(tcStr + CHR(0), 5)
    #ELSE
      LOCAL lnLen, lcWideStr
      lnLen = 2 * (LEN(tcStr) + 1)
      lcWideStr = REPLICATE(CHR(0), lnLen)
      MultiByteToWideChar(0, 0, @tcStr, LEN(tcStr), @lcWideStr, lnLen)
      RETURN lcWideStr
    #ENDIF
  ENDFUNC

  *!*	FUNCTIONS TO DEVELOP

  PROCEDURE FillRegion
    *!*			DECLARE INTEGER GdipCreateRegion IN GdiPlus.dll ;
    *!*				INTEGER @GpRegion
    *!*			This.Stat = GdipCreateRegion(@region)

    DECLARE INTEGER GdipCreateRegionRect IN GDIPLUS.DLL ;
      STRING cLayoutRect, INTEGER @GpRegion

    DECLARE INTEGER GdipFillRegion IN GDIPLUS.DLL ;
      INTEGER graphics, INTEGER nBrush, INTEGER GpRegion

    REGION = 0
    THIS.STAT = GdipCreateRegionRect(THIS.RectF, @REGION)
    THIS.STAT = GdipFillRegion(THIS.GetGraphics(), THIS.Brush, REGION)
  ENDPROC

  PROCEDURE fillpath
    DECLARE INTEGER GdipCreatePath IN GDIPLUS.DLL ;
      INTEGER PathMode, INTEGER @GpRegion
    nPath = 0
    THIS.STAT = GdipCreatePath(1,@nPath)

    DECLARE INTEGER GdipFillPath IN GDIPLUS.DLL ;
      INTEGER graphics, INTEGER nBrush, INTEGER nPath
    THIS.STAT = GdipFillPath(THIS.GetGraphics(), THIS.Brush, nPath)
  ENDPROC

ENDDEFINE


***********************************************************************
*   Class:	EncoderParameter
***********************************************************************

DEFINE CLASS EncoderParameter AS CUSTOM
  *	class EncoderParameter
  *	{
  *	public:
  *		GUID    Guid;				// GUID of the parameter
  *		ULONG   NumberOfValues;		// Number of the parameter values
  *		ULONG   Type;				// Value type, like ValueTypeLONG  etc.
  *		VOID*   Value;				// A pointer to the parameter values
  *	}

  PROTECTED ValuePtr
  PROTECTED encoderParam

  PROCEDURE INIT(lcGuid, lnValue)
    IF (VARTYPE(lcGuid) != 'C') OR (VARTYPE(lnValue) != 'N')
      ERROR 11
    ENDIF

    THIS.ValuePtr = LocalAlloc(LPTR, 4)
    IF THIS.ValuePtr = 0
      ERROR 1149
    ENDIF
    *		Sys(2600, This.ValuePtr, 4, DWord(lnValue))
    DECLARE RtlMoveMemory IN Win32API AS RtlCopyData ;
      LONG DestNum, LONG @ pVoidSource, INTEGER nLength
    RtlCopyData(THIS.ValuePtr, lnValue, 4)

    THIS.encoderParam = lcGuid + DWord(1) + DWord(4)
    THIS.encoderParam = THIS.encoderParam + DWord(THIS.ValuePtr)
  ENDFUNC

  PROCEDURE DESTROY
    LocalFree(THIS.ValuePtr)
  ENDFUNC

  FUNCTION GetString
    RETURN THIS.encoderParam
  ENDFUNC

ENDDEFINE

***********************************************************************
* Global functions
***********************************************************************

FUNCTION DWord(lnValue)
  * Creates a DWORD (unsigned 32-bit) 4 byte STRING from a number
  LOCAL byte(4)
  IF lnValue < 0
    lnValue = lnValue + 4294967296
  ENDIF
  byte(1) = lnValue % 256
  byte(2) = BITRSHIFT(lnValue, 8) % 256
  byte(3) = BITRSHIFT(lnValue, 16) % 256
  byte(4) = BITRSHIFT(lnValue, 24) % 256
  RETURN CHR(byte(1))+CHR(byte(2))+CHR(byte(3))+CHR(byte(4))
ENDFUNC

FUNCTION ErrorInfo(tnStatus)
  DO CASE
    CASE tnStatus = 0
      RETURN "Ok"
    CASE tnStatus = 1
      RETURN "Generic Error"
    CASE tnStatus = 2
      RETURN "Invalid Parameter"
    CASE tnStatus = 3
      RETURN "Out Of Memory"
    CASE tnStatus = 4
      RETURN "Object Busy"
    CASE tnStatus = 5
      RETURN "Insufficient Buffer"
    CASE tnStatus = 6
      RETURN "Not Implemented"
    CASE tnStatus = 7
      RETURN "Win32 Error"
    CASE tnStatus = 8
      RETURN "Wrong State"
    CASE tnStatus = 9
      RETURN "Aborted"
    CASE tnStatus = 10
      RETURN "File Not Found"
    CASE tnStatus = 11
      RETURN "Value Overflow"
    CASE tnStatus = 12
      RETURN "Access Denied"
    CASE tnStatus = 13
      RETURN "Unknown Image Format"
    CASE tnStatus = 14
      RETURN "Font Family Not Found"
    CASE tnStatus = 15
      RETURN "Font Style Not Found"
    CASE tnStatus = 16
      RETURN "Not True Type Font"
    CASE tnStatus = 17
      RETURN "Unsupported Gdiplus Version"
    CASE tnStatus = 18
      RETURN "Gdiplus Not Initialized"
    CASE tnStatus = 19
      RETURN "Property Not Found"
    CASE tnStatus = 20
      RETURN "Property Not Supported"
    OTHERWISE
      RETURN "Unknown Error"
  ENDCASE
ENDFUNC

***
*** Functions added
***

FUNCTION POINTF(X,Y) && adapted from RECTF found in www.news2news.com
  RETURN dword(Int2Float(X)) + dword(Int2Float(Y))
ENDFUNC

FUNCTION RECTF(X,Y,WIDTH,HEIGHT) && found in www.news2news.com
  RETURN dword(Int2Float(X)) + dword(Int2Float(Y)) +;
    dword(Int2Float(WIDTH)) + dword(Int2Float(HEIGHT))
ENDFUNC

FUNCTION Int2Float(num) && By Anatoly Mogylevets - found in www.fox.wikis.com
  * converts FoxPro numeric to 32-bit float form
  #DEFINE REAL_BIAS 127
  #DEFINE REAL_MANTISSA_SIZE 23
  #DEFINE REAL_NEGATIVE 0x80000000
  #DEFINE EXPONENT_MASK 0x7F800000
  #DEFINE MANTISSA_MASK 0x7FFFFF
  LOCAL sgn, exponent, mantissa
  DO CASE
    CASE num < 0
      sgn = REAL_NEGATIVE
      num = -num
    CASE num > 0
      sgn = 0
    OTHERWISE
      RETURN 0
  ENDCASE
  exponent = FLOOR(LOG(num)/LOG(2))
  mantissa = (num - 2^exponent)* 2^(REAL_MANTISSA_SIZE - exponent)
  exponent = BITLSHIFT(exponent+REAL_BIAS, REAL_MANTISSA_SIZE)

  RETURN BITOR(BITOR(sgn, exponent), mantissa)
  *  RETURN BITOR(sgn, exponent, mantissa)
ENDFUNC

FUNCTION MAKEARGB(tnColor, tnAlpha)  && Alexander GolovLev
  LOCAL argb, red, green, blue
  blue = BITRSHIFT(BITAND(tnColor, 0x00FF0000), 16)
  green = BITRSHIFT(BITAND(tnColor, 0x0000FF00), 8)
  red = BITAND(tnColor, 0x000000FF)
  argb = blue + BITLSHIFT(green, 8) + BITLSHIFT(red, 16)
  IF VARTYPE(tnAlpha) = 'N'
    argb = argb + BITLSHIFT(BITAND(tnAlpha, 0xFF), 24)
  ELSE
    argb = argb + BITLSHIFT(255, 24)
  ENDIF
  RETURN ARGB
ENDFUNC

FUNCTION GetRed(tnColor)
  RETURN BITAND(tnColor, 0x000000FF)
ENDFUNC

FUNCTION GetGreen(tnColor)
  RETURN BITRSHIFT(BITAND(tnColor, 0x0000FF00), 8)
ENDFUNC

FUNCTION GetBlue(tnColor)
  RETURN BITRSHIFT(BITAND(tnColor, 0x00FF0000), 16)
ENDFUNC

FUNCTION Float2Int(num) && By Anatoly Mogylevets - found in www.fox.wikis.com
  * converts 32-bit float form to FoxPro numeric
  LOCAL sgn, exponent, mantissa
  sgn = IIF(BITTEST(num,31), -1,1)
  exponent = BITRSHIFT(BITAND(num, EXPONENT_MASK),;
    REAL_MANTISSA_SIZE) - REAL_BIAS
  mantissa = BITAND(num,;
    MANTISSA_MASK) / 2^(REAL_MANTISSA_SIZE-exponent)
  RETURN (2^exponent + mantissa) * sgn

FUNCTION buf2dword(lcBuffer)  && found in www.fox.wikis.com
  RETURN ASC(SUBSTR(lcBuffer, 1,1)) + ;
    ASC(SUBSTR(lcBuffer, 2,1)) * 256 +;
    ASC(SUBSTR(lcBuffer, 3,1)) * 65536 +;
    ASC(SUBSTR(lcBuffer, 4,1)) * 16777216
ENDFUNC

FUNCTION MakePointsFSequence(taIntPoints)
  *** Creates a String containing all PointsF of the received array
  EXTERNAL ARRAY taIntPoints
  LOCAL lcPointsFSequence, lcPointF, N
  lcPointsFSequence = ""
  FOR N = 1 TO ALEN(taIntPoints,1)
    lcPointF = PointF(taIntPoints(N,1), taIntPoints(N,2))
    lcPointsFSequence = lcPointsFSequence + lcPointF
  ENDFOR
  RETURN lcPointsFSequence
ENDFUNC

FUNCTION MakeColorMatrix(taColMatrix)
  *** Creates a String containing ColorMatrix from the 5x5 received array
  EXTERNAL ARRAY taColMatrix
  LOCAL lcColorMatrix, nRow, nCol
  lcMatrix = ""
  FOR nRow = 1 TO 5
    FOR nCol = 1 TO 5
      lcMatrix = lcMatrix + dword(Int2Float(taColMatrix(nRow, nCol)))
    ENDFOR
  ENDFOR
  RETURN lcMatrix
ENDFUNC

FUNCTION MakeColorMap(taColorMap)
  *** Creates a String containing ColorMapt from the 4 column Array
  EXTERNAL ARRAY taColorMatrix
  LOCAL lcColorMap, N, lnArgbOld, lnArgbNew
  lcColorMap = ""
  *!*		FOR n = 1 TO ALEN(taColorMap,1)
  *!*			lnargbOld = MakeARGB(taColorMap(n,1), taColorMap(n,3))
  *!*			lnargbNew = MakeARGB(taColorMap(n,2), taColorMap(n,4))
  *!*			lcColorMap = lcColorMap + dword(lnargbOld) + dword(lnargbNew)
  *!*		ENDFOR
  RETURN lcColorMap
ENDFUNC

*************************************************************************
