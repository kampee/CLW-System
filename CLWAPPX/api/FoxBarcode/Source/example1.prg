*--------------------------------------------------------------------------------------
* Example1.prg
*--------------------------------------------------------------------------------------
* Version: 0.12 Beta
* Date   : 2010-11-29
* Author : VFPEncoding
* Email  : vfpencoding@gmail.com
*
* Note   : VFPEncoding are 
*          Guillermo Carrero (Barcelona, Spain) and 
*          Luis Maria Guayan (Tucuman, Argentina)
*--------------------------------------------------------------------------------------

SET PROCEDURE TO SOURCE\FoxBarcode, SOURCE\gpImage2 ADDITIVE

*--- Create FoxBarcode Object
loFbc = CREATEOBJECT("FoxBarcode")

*!*	*-- Set properties
*!*	loFbc.nBarcodeType = 110 &&  Barcode type
*!*	loFbc.nFactor = 2
*!*	loFbc.nRatio = 3
*!*	loFbc.nImageHeight = 100
*!*	loFbc.lAddCheckDigit = .T.
*!*	loFbc.lShowHumanReadableText = .T.
*!*	loFbc.lShowCheckDigit = .T.
*!*	loFbc.lShowStartStopChars = .T.
*!*	loFbc.cImageType = "JPG"
*!*	loFbc.nMargin = 5
*!*	loFbc.nAlignText = 0
*!*	loFbc.cSet128 = "B"    &&   Only Code 128

*!*	lcImage = loFbc.BarcodeImage("1234567890")

*-- Generate the image with the new 3 rd parameter
lcImage = loFbc.BarcodeImage("","",[nBarcodeType=159, cText="(01)01234567890128(15)101231(10)123X", nImageHeight=100, nFactor=2, nMargin=10])

*-- Create form
LOCAL loForm AS FORM
loForm = CREATEOBJECT("Form")
loForm.CAPTION = "FoxBarcode example"
loForm.WIDTH = 800
loForm.HEIGHT = 400
loForm.AUTOCENTER = .T.
loForm.ADDOBJECT("Image1", "Image")
loForm.Image1.PICTURE = lcImage
loForm.Image1.VISIBLE = .T.
loForm.SHOW(1)
loForm = NULL
loFbc = NULL

RETURN

*--------------------------------------------------------------------------------------


