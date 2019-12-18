*--------------------------------------------------------------------------------------
* FoxBarcode.prg
*--------------------------------------------------------------------------------------
* FoxBarcode is a application free software and offers a Barcode tool for
* the Visual FoxPro Community.
* This software is provided "as is" without express or implied warranty.
* Use it at your own risk
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

*--------------------------------------------------------------------------------------
* Note   : This application use GPIMAGE2 (http://sites.google.com/site/gpimage2)
*          of Alexander Golovlev (Russian Federation) and Cesar Chalom (Brazil)
*          All changes under the authorization of Cesar Chalom
*Modified: 2010.10.25 by VFPEncoding
*          Changed the name of the class gpImage2, incompatibility using
*          FoxyPreviewer and GDIPlus.vcx class of the \FFC class library
*Modified: 2010.11.28 by VFPEncoding
*          Include #DEFINE from gdImage2.h file
*--------------------------------------------------------------------------------------

*--------------------------------------------------------------------------------------
* FoxBarcode Class Definition
*--------------------------------------------------------------------------------------
DEFINE CLASS FoxBarcode AS CUSTOM

  *--- Internal use
  PROTECTED cPattern, nLenPattern, nTextHeight, nFontHeight, cFontStyle
  PROTECTED nBarWidth, nQuietZone
  PROTECTED nImageWidth
  PROTECTED cCheckDigit, cTextValue
  PROTECTED oGdi, oImg, oGra

  *-- Properties
  cText = "" && Text to encode
  cTextValue = "" && Value of the text ready for encoding.

  *-- Barcode symbologies
  nBarcodeType = 110 && Barcode type. See "Bar Code List"
  nFactor = 1 && Barcode size [1..9]
  nQuietZone = 10 && Quit zone in pixels
  nBarWidth = 0
  nMargin = 0 && Margin around the barcode

  *-- Only some barcode specific symbologies
  nRatio = 3 && Ratio between the narrow bar and the wide bar
  lAddCheckDigit = .T. && Calculate check digit
  cSet128 = "B" && Set Code 128
  nBearerBar = 1 && 0=None, 1=Rectangle, 2=Top and Bottom - Only ITF-14
  nBearerBarWidth = 0 && In pixels
  cSupplementalText = "" && EAN and UPC code supplemental text
  lUseAppId = .T. && Use Application Identifiers. Only EAN/UCC/GS1 128

  *-- Barcode image
  nImageHeight = 100 && in pixels
  nImageWidth = 0 && in pixels
  nRotation = 0 && Image rotation [0=0°, 1=90°, 2=180°, 3=270°]
  nResolution = 300 && Dpi
  cImageType = "JPG"  && Image type ["JPG", "GIF", "PNG", "BMP", "TIF"]
  cImageFile = "" && Image file name, if empty autogenerate file name

  *-- Human-readable text
  cHumanReadableText = "" && Human-readable text to display
  cCheckDigit = "" && Check digit in human readable
  lShowCheckDigit = .T. && Show check digit in human readable text
  lShowStartStopChars = .T. && Show start and stop characters in human readable text
  lShowHumanReadableText = .T. && Shows the human-readable text
  nAlignText = 1 && [0=Left, 1=Center, 2=Right]
  nTextHeight = 14.500  && Text height
  nFontSize = 8.500 && Real font size
  nFontHeight = 2.833  && Size according to factor
  cFontName = "Arial" && Font name
  cFontStyle = "N" && Font Style
  lFontBold = .F. && Font bold
  lFontItalic = .F. && Fon italic

  *-- Colours
  nBackColor = RGB(255,255,255) && Background color image (recommend White)
  nBarsColor = RGB(0,0,0) && Bars Colors (recommend Black)
  nFontColor = RGB(0,0,0) && Font color (recommend Black)

  *-- Internal use
  cPattern = "" && Encoded string
  nLenPattern = 0 && Encoded string Lenght
  cMsgError = "" && Error message
  cTempPath = "" && Windows temp folder + SYS(2015)

  *--- gpImage object
  oGdi = NULL && Object Gdi
  oImg = NULL && Object Image
  oGra = NULL && Object Graphic

  *------------------------------------------------------
  * PROCEDURE BarcodePattern()
  *------------------------------------------------------
  * Generates the barcode pattern according to the type
  *------------------------------------------------------
  PROCEDURE BarcodePattern()

    *------------------------------------------------------
    * Bar Code List
    *------------------------------------------------------
    * Bar Code List 1D
    *------------------------------------------------------
    * 110 = Code 128 (Sets A, B and C)
    *
    * 120 = Code 39
    * 121 = Code 39 Extended or Full ASCII
    * 122 = Code 93
    * 123 = Code 93 Extended
    *
    * 131 = Standard 2 of 5
    * 132 = Interleaved 2 of 5
    *
    * 150 = EAN-8
    * 151 = EAN-13
    * 152 = ITF-14
    * 159 = EAN-128
    *
    * 160 = UPC-E
    * 161 = UPC-A
    *
    * 170 = Codabar
    * 171 = Code 11
    * 172 = MSI/Plessey
    * 173 = Telepen
    *
    * 180 = PostNet
    *
    *------------------------------------------------------

    *------------------------------------------------------
    * Bar Code List 2D (Coming Soon...)
    *------------------------------------------------------
    * 210 = PDF 417 
    *
    *------------------------------------------------------

    THIS.cMsgError = ""

    *-- Validates that the font and style are permitted by GDI+
    IF THIS.lShowHumanReadableText AND ;
        NOT THIS.IsGdipFont(THIS.cFontName, THIS.cFontStyle)
      THIS.cMsgError = "Font or style is not allowed in GDI +"
      THIS.cPattern = NULL
      RETURN THIS.cPattern
    ENDIF

    IF NOT EMPTY(THIS.cTextValue)

      DO CASE
        CASE THIS.nBarcodeType = 110 && Code 128
          THIS.cPattern = THIS.Cod_128()

        CASE THIS.nBarcodeType = 120 && Code 39
          THIS.cPattern = THIS.Cod_39()

        CASE THIS.nBarcodeType = 121 && Code 39 Estended or ASCII Full
          THIS.cPattern = THIS.Cod_39Ext()

        CASE THIS.nBarcodeType = 122 && Code 93
          THIS.cPattern = THIS.Cod_93()

        CASE THIS.nBarcodeType = 123 && Code 93 Extended or Full ASCII
          THIS.cPattern = THIS.Cod_93Ext()

        CASE THIS.nBarcodeType = 131 && Standard or Industrial 2 of 5
          THIS.cPattern = THIS.Cod_S2of5()

        CASE THIS.nBarcodeType = 132 && Interleaved 2 of 5
          THIS.cPattern = THIS.Cod_I2of5()

        CASE THIS.nBarcodeType = 152 && ITF-14
          THIS.cPattern = THIS.Cod_Itf14()

        CASE THIS.nBarcodeType = 151 && EAN-13
          THIS.cPattern = THIS.Cod_Ean13()

        CASE THIS.nBarcodeType = 150 && EAN-8
          THIS.cPattern = THIS.Cod_Ean8()

        CASE THIS.nBarcodeType = 159 && EAN-128
          THIS.cPattern = THIS.Cod_Ean128()

        CASE THIS.nBarcodeType = 161 && UPC-A
          THIS.cPattern = THIS.Cod_UpcA()

        CASE THIS.nBarcodeType = 160 && UPC-E
          THIS.cPattern = THIS.Cod_UpcE()

        CASE THIS.nBarcodeType = 170 && Codabar
          THIS.cPattern = THIS.Cod_Codabar()

        CASE THIS.nBarcodeType = 171 && Code 11
          THIS.cPattern = THIS.Cod_11()

        CASE THIS.nBarcodeType = 172 && MSI / Plessey
          THIS.cPattern = THIS.Cod_MSIPlessey()

        CASE THIS.nBarcodeType = 173 && Telepen
          THIS.cPattern = THIS.Cod_Telepen()

        CASE THIS.nBarcodeType = 180 && PostNet
          THIS.cPattern = THIS.Cod_PostNet()

        OTHERWISE
          THIS.cPattern = NULL
          THIS.cMsgError = "Barcode symbology not implemented."
      ENDCASE

    ELSE && NOT EMPTY(THIS.cTextValue)

      THIS.cPattern = NULL
      THIS.cMsgError = "The text encoding is blank."

    ENDIF && NOT EMPTY(THIS.cTextValue)

    IF ISNULL(THIS.cPattern)
      *-- Not generated the Pattern string
      RETURN THIS.cPattern
    ENDIF && ISNULL(THIS.cPattern)

  ENDPROC

  *------------------------------------------------------
  * PROCEDURE BarcodeImage(tcValue, tcImageFile)
  *------------------------------------------------------
  * Generated barcode image with GPIMAGE class
  *------------------------------------------------------
  PROCEDURE BarcodeImage(tcValue, tcImageFile, tcSuperPro)

    LOCAL ARRAY laSuperPro(1)
    LOCAL lcProper, lnCon

    *-- Properties in 3rd. parameter
    IF NOT EMPTY(tcSuperPro)
      THIS.ResetProperties()
      tcSuperPro = ALLTRIM(CHRTRAN(tcSuperPro, ",", CHR(13)))
      ALINES(laSuperPro, tcSuperPro)
      FOR lnCon = 1 TO ALEN(laSuperPro)
        lcProper = "THIS."+SUBSTR(laSuperPro(lnCon), 1, AT("=", laSuperPro[lnCon]) - 1)
        IF TYPE(lcProper) # "U"
          laSuperPro(lnCon) = "THIS."+laSuperPro(lnCon)
          &laSuperPro[lnCon]
        ENDIF
      ENDFOR
      IF NOT EMPTY(THIS.cText)
        tcValue = THIS.cText
      ENDIF
    ENDIF

    IF EMPTY(tcValue)
      tcValue = THIS.cText
    ENDIF

    STORE tcValue TO THIS.cTextValue, THIS.cHumanReadableText

    *--- Generates the pattern
    THIS.BarcodePattern()

    *-- GPIMAGE
    THIS.oGdi = CREATEOBJECT("gpInit")
    THIS.oImg = CREATEOBJECT("gpImage2")

    *--- Invalid Propeties / Code / Font / Style
    IF ISNULL(THIS.cPattern)

      LOCAL lnFontHeight
      *-- Create an error message image
      THIS.nImageWidth = THIS.nImageHeight * 2  && 1.5
      THIS.oImg.CREATE(THIS.nImageWidth, THIS.nImageHeight)
      THIS.oImg.HorizontalResolution = THIS.nResolution
      THIS.oImg.VerticalResolution = THIS.nResolution
      THIS.oGra = CREATEOBJECT("Graphics",THIS.oImg.GetImage())
      THIS.oGra.SetBrush(THIS.nBackColor)
      THIS.oGra.SetRect(0,0,THIS.nImageWidth, THIS.nImageHeight)
      THIS.oGra.FillRect(0,0,THIS.nImageWidth, THIS.nImageHeight)
      THIS.oGra.SetAlignment(1,1,0)
      THIS.oGra.SetBrush(THIS.nFontColor)
      lnFontHeight = (THIS.nFontSize * 1.25) / THIS.nResolution * 100
      *-- Use Font = _Screen.FontName and Style = [N]ormal
      THIS.oGra.DrawString(THIS.cMsgError, _SCREEN.FONTNAME, lnFontHeight, "N")
      THIS.oGra.SetPen(THIS.nBarsColor, 1)
      THIS.oGra.DrawRect(0, 0, THIS.nImageWidth - 1, THIS.nImageHeight - 1)

    ELSE && ISNULL(THIS.cPattern)

      *-- Barcode + BearerBar + Human Readable + QuietZone + Supplemental
      THIS.nBearerBarWidth = IIF(THIS.nBarcodeType = 152 AND THIS.nBearerBar # 0, CEILING(THIS.nQuietZone / 4 * THIS.nFactor) , 0) && Bearer Bar Width
      THIS.cPattern = REPLICATE( "@", THIS.nBearerBarWidth * 2) + REPLICATE( "@", THIS.nQuietZone) + THIS.cPattern + REPLICATE( "@", THIS.nQuietZone) + REPLICATE( "@", THIS.nBearerBarWidth * 2)
      THIS.nLenPattern = LEN(THIS.cPattern)

      *-- Image Size
      THIS.nImageWidth = (THIS.nMargin * 2 ) + (THIS.nLenPattern * THIS.nFactor)

      *-- Create image
      THIS.oImg.CREATE(THIS.nImageWidth,THIS.nImageHeight)
      THIS.oImg.HorizontalResolution = THIS.nResolution
      THIS.oImg.VerticalResolution = THIS.nResolution
      THIS.oGra = CREATEOBJECT("Graphics",THIS.oImg.GetImage())
      THIS.oGra.SetBrush(THIS.nBackColor)
      THIS.oGra.FillRect(0,0,THIS.nImageWidth,THIS.nImageHeight)
      THIS.oGra.SetPen(THIS.nBarsColor, THIS.nFactor)

      LOCAL ln, lnCol

      *-- Barcode types
      DO CASE
        CASE THIS.nBarcodeType = 180 && PostNet
          FOR ln = 1 TO THIS.nLenPattern
            lnCol = ln - 1
            DO CASE
              CASE SUBSTR(THIS.cPattern, ln, 1) == "2"
                THIS.oGra.DrawLine(lnCol * THIS.nFactor  + THIS.nMargin,  THIS.nMargin, lnCol * THIS.nFactor  + THIS.nMargin, THIS.nImageHeight - THIS.nMargin )
              CASE SUBSTR(THIS.cPattern, ln, 1) == "1"
                THIS.oGra.DrawLine(lnCol * THIS.nFactor + THIS.nMargin, THIS.nImageHeight/1.90, lnCol * THIS.nFactor + THIS.nMargin, CEILING(THIS.nImageHeight - THIS.nMargin))
            ENDCASE
          ENDFOR

        OTHERWISE && Rest of bar codes
          FOR ln = 1 TO THIS.nLenPattern
            lnCol = ln - 1
            IF SUBSTR(THIS.cPattern, ln, 1) == "1"
              THIS.oGra.DrawLine(lnCol * THIS.nFactor + THIS.nMargin, THIS.nMargin, lnCol * THIS.nFactor + THIS.nMargin, THIS.nImageHeight - THIS.nMargin - IIF(THIS.nFactor = 1, 1, 0))
            ENDIF
          ENDFOR
      ENDCASE

      IF THIS.lShowHumanReadableText

        LOCAL lnLeft, lnRigth, lnTextMargin, lcBin
        *-- Without Human readable
        IF THIS.nBarcodeType = 180 && PostNet
          *-- No clear zone
        ELSE
          *-- Clear zone
          lnTextMargin = (THIS.nBearerBarWidth + THIS.nQuietZone - 2) * THIS.nFactor + THIS.nMargin
          THIS.oGra.SetBrush(THIS.nBackColor)
          THIS.oGra.SetRect(lnTextMargin, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, THIS.nImageWidth - lnTextMargin * 2, THIS.nTextHeight)
          THIS.oGra.FillRect(lnTextMargin, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, THIS.nImageWidth - lnTextMargin * 2, THIS.nTextHeight)
        ENDIF

        DO CASE
          CASE THIS.nBarcodeType = 151 && EAN-13
            *-- 1st. digit
            lnLeft = THIS.nMargin - (2 * THIS.nFactor)
            lnRight = (THIS.nQuietZone * THIS.nFactor)
            THIS.oGra.SetBrush(THIS.nBackColor)
            THIS.oGra.SetRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.FillRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.SetAlignment(1 , 1, 0)
            THIS.oGra.SetBrush(THIS.nFontColor)
            THIS.oGra.DrawString(SUBSTR(THIS.cHumanReadableText,1,1), THIS.cFontName, THIS.nFontHeight, THIS.cFontStyle)
            *-- 2nd to 7th digit
            lnLeft = THIS.nQuietZone * THIS.nFactor + THIS.nMargin
            lnRight = 48 * THIS.nFactor
            THIS.oGra.SetBrush(THIS.nBackColor)
            THIS.oGra.SetRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.FillRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.SetAlignment(1 , 1, 0)
            THIS.oGra.SetBrush(THIS.nFontColor)
            THIS.oGra.DrawString(SUBSTR(THIS.cHumanReadableText,2,6), THIS.cFontName, THIS.nFontHeight, THIS.cFontStyle)
            *-- 8th to 13th digit
            lnLeft = ((THIS.nQuietZone + 46) * THIS.nFactor) + THIS.nMargin
            lnRight = 48 * THIS.nFactor
            THIS.oGra.SetBrush(THIS.nBackColor)
            THIS.oGra.SetRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.FillRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.SetAlignment(1 , 1, 0)
            THIS.oGra.SetBrush(THIS.nFontColor)
            THIS.oGra.DrawString(SUBSTR(THIS.cHumanReadableText,8,6), THIS.cFontName, THIS.nFontHeight, THIS.cFontStyle)

            *-- Supplemental
            IF NOT EMPTY(THIS.cSupplementalText)
              lnLeft = (((2 * THIS.nQuietZone) + 91) * THIS.nFactor) + THIS.nMargin
              lnRight = (LEN(THIS.cSupplementalText) + 1) * 9 * THIS.nFactor
              THIS.oGra.SetBrush(THIS.nBackColor)
              THIS.oGra.SetRect(lnLeft, THIS.nMargin, lnRight, THIS.nTextHeight)
              THIS.oGra.FillRect(lnLeft, THIS.nMargin, lnRight, THIS.nTextHeight)
              THIS.oGra.SetAlignment(1 , 1, 0)
              THIS.oGra.SetBrush(THIS.nFontColor)
              THIS.oGra.DrawString(THIS.cSupplementalText, THIS.cFontName, THIS.nFontHeight, THIS.cFontStyle)
            ENDIF

            *-- Redraw lines
            lcBin = REPLICATE( "0", THIS.nQuietZone) + "101" + REPLICATE("0", 6*7) + "01010" +  REPLICATE("0", 6*7) + "101" + REPLICATE( "0", THIS.nQuietZone)
            FOR ln = 1 TO LEN(lcBin)
              lnCol = ln - 1
              IF SUBSTR(lcBin, ln, 1) = "1"
                THIS.oGra.DrawLine(lnCol * THIS.nFactor + THIS.nMargin, THIS.nImageHeight- THIS.nTextHeight - THIS.nMargin, lnCol * THIS.nFactor + THIS.nMargin, THIS.nImageHeight- THIS.nTextHeight/2 - THIS.nMargin - 2)
              ENDIF
            ENDFOR

          CASE THIS.nBarcodeType = 150 && EAN-8
            *-- 1st to 4th digit
            lnLeft = THIS.nQuietZone * THIS.nFactor + THIS.nMargin
            lnRight = 34 * THIS.nFactor
            THIS.oGra.SetBrush(THIS.nBackColor)
            THIS.oGra.SetRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.FillRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.SetAlignment(1 , 1, 0)
            THIS.oGra.SetBrush(THIS.nFontColor)
            THIS.oGra.DrawString(SUBSTR(THIS.cHumanReadableText,1,4), THIS.cFontName, THIS.nFontHeight, THIS.cFontStyle)
            *-- 5th to 8th digit
            lnLeft = ((THIS.nQuietZone + 32) * THIS.nFactor) + THIS.nMargin + 1
            lnRight = 34 * THIS.nFactor
            THIS.oGra.SetBrush(THIS.nBackColor)
            THIS.oGra.SetRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.FillRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.SetAlignment(1 , 1, 0)
            THIS.oGra.SetBrush(THIS.nFontColor)
            THIS.oGra.DrawString(SUBSTR(THIS.cHumanReadableText,5,4), THIS.cFontName, THIS.nFontHeight, THIS.cFontStyle)

            *-- Supplemental
            IF NOT EMPTY(THIS.cSupplementalText)
              lnLeft = (((2 * THIS.nQuietZone) + 64) * THIS.nFactor) + THIS.nMargin
              lnRight = (LEN(THIS.cSupplementalText) + 1) * 9 * THIS.nFactor
              THIS.oGra.SetBrush(THIS.nBackColor)
              THIS.oGra.SetRect(lnLeft, THIS.nMargin, lnRight, THIS.nTextHeight)
              THIS.oGra.FillRect(lnLeft, THIS.nMargin, lnRight, THIS.nTextHeight)
              THIS.oGra.SetAlignment(1 , 1, 0)
              THIS.oGra.SetBrush(THIS.nFontColor)
              THIS.oGra.DrawString(THIS.cSupplementalText, THIS.cFontName, THIS.nFontHeight, THIS.cFontStyle)
            ENDIF

            *-- Redraw lines
            lcBin = REPLICATE( "0", THIS.nQuietZone) + "101" + REPLICATE("0", 4*7) + "01010" +  REPLICATE("0", 4*7) + "101" + REPLICATE( "0", THIS.nQuietZone)
            FOR ln = 1 TO LEN(lcBin)
              lnCol = ln - 1
              IF SUBSTR(lcBin, ln, 1) = "1"
                THIS.oGra.DrawLine(lnCol * THIS.nFactor + THIS.nMargin, THIS.nImageHeight- THIS.nTextHeight - THIS.nMargin, lnCol * THIS.nFactor + THIS.nMargin, THIS.nImageHeight- THIS.nTextHeight/2 - THIS.nMargin - 2)
              ENDIF
            ENDFOR

          CASE THIS.nBarcodeType = 161 && UPC-A
            *-- 1st. digit
            lnLeft = THIS.nMargin
            lnRight = (THIS.nQuietZone * THIS.nFactor)
            THIS.oGra.SetBrush(THIS.nBackColor)
            THIS.oGra.SetRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.FillRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.SetAlignment(1 , 1, 0)
            THIS.oGra.SetBrush(THIS.nFontColor)
            THIS.oGra.DrawString(SUBSTR(THIS.cHumanReadableText,1,1), THIS.cFontName, THIS.nFontHeight * 0.85, THIS.cFontStyle)
            *-- 2nd to 6th digit
            lnLeft = (THIS.nQuietZone + 5) * THIS.nFactor + THIS.nMargin
            lnRight = (44) * THIS.nFactor
            THIS.oGra.SetBrush(THIS.nBackColor)
            THIS.oGra.SetRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.FillRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.SetAlignment(1 , 1, 0)
            THIS.oGra.SetBrush(THIS.nFontColor)
            THIS.oGra.DrawString(SUBSTR(THIS.cHumanReadableText,2,5), THIS.cFontName, THIS.nFontHeight, THIS.cFontStyle)
            *-- 7th to 12th digit
            lnLeft = ((THIS.nQuietZone + 45) * THIS.nFactor) + THIS.nMargin
            lnRight = 44 * THIS.nFactor
            THIS.oGra.SetBrush(THIS.nBackColor)
            THIS.oGra.SetRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.FillRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.SetAlignment(1 , 1, 0)
            THIS.oGra.SetBrush(THIS.nFontColor)
            THIS.oGra.DrawString(SUBSTR(THIS.cHumanReadableText,7,5), THIS.cFontName, THIS.nFontHeight, THIS.cFontStyle)
            *-- 12st. digit
            lnLeft = (103 * THIS.nFactor) + THIS.nMargin
            lnRight = THIS.nQuietZone * THIS.nFactor + (4 * THIS.nFactor)
            THIS.oGra.SetBrush(THIS.nBackColor)
            THIS.oGra.SetRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.FillRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.SetAlignment(1 , 1, 0)
            THIS.oGra.SetBrush(THIS.nFontColor)
            THIS.oGra.DrawString(SUBSTR(THIS.cHumanReadableText,12,1), THIS.cFontName, THIS.nFontHeight * 0.85, THIS.cFontStyle)

            *-- Supplemental
            IF NOT EMPTY(THIS.cSupplementalText)
              lnLeft = (((2 * THIS.nQuietZone) + 92) * THIS.nFactor) + THIS.nMargin
              lnRight = (LEN(THIS.cSupplementalText) + 1) * 9 * THIS.nFactor
              THIS.oGra.SetBrush(THIS.nBackColor)
              THIS.oGra.SetRect(lnLeft, THIS.nMargin, lnRight, THIS.nTextHeight)
              THIS.oGra.FillRect(lnLeft, THIS.nMargin, lnRight, THIS.nTextHeight)
              THIS.oGra.SetAlignment(1 , 1, 0)
              THIS.oGra.SetBrush(THIS.nFontColor)
              THIS.oGra.DrawString(THIS.cSupplementalText, THIS.cFontName, THIS.nFontHeight, THIS.cFontStyle)
            ENDIF

            *-- Redraw lines
            lcBin = LEFT(THIS.cPattern, THIS.nQuietZone + 3 + 7) + REPLICATE("0", 5 * 7) + "01010" +  REPLICATE("0", 5 * 7) + SUBSTR(THIS.cPattern, THIS.nQuietZone + 3 + 5 + (11 * 7) + 1, 7 + 3 + 1)
            FOR ln = 1 TO LEN(lcBin)
              lnCol = ln - 1
              IF SUBSTR(lcBin, ln, 1) = "1"
                THIS.oGra.DrawLine(lnCol * THIS.nFactor + THIS.nMargin, THIS.nImageHeight- THIS.nTextHeight - THIS.nMargin, lnCol * THIS.nFactor + THIS.nMargin, THIS.nImageHeight- THIS.nTextHeight/2 - THIS.nMargin - 2)
              ENDIF
            ENDFOR

          CASE THIS.nBarcodeType = 160 && UPC-E
            *-- 1st. digit
            lnLeft = THIS.nMargin
            lnRight = (THIS.nQuietZone * THIS.nFactor)
            THIS.oGra.SetBrush(THIS.nBackColor)
            THIS.oGra.SetRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.FillRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.SetAlignment(1 , 1, 0)
            THIS.oGra.SetBrush(THIS.nFontColor)
            THIS.oGra.DrawString(SUBSTR(THIS.cHumanReadableText,1,1), THIS.cFontName, THIS.nFontHeight * 0.85, THIS.cFontStyle)
            *-- 2nd to 6th digit
            lnLeft = ((THIS.nQuietZone) * THIS.nFactor) + THIS.nMargin - 1
            lnRight = 48 * THIS.nFactor
            THIS.oGra.SetBrush(THIS.nBackColor)
            THIS.oGra.SetRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.FillRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.SetAlignment(1 , 1, 0)
            THIS.oGra.SetBrush(THIS.nFontColor)
            THIS.oGra.DrawString(SUBSTR(THIS.cHumanReadableText,2,6), THIS.cFontName, THIS.nFontHeight, THIS.cFontStyle)
            *-- 8th. digit
            lnLeft = (60 * THIS.nFactor) + THIS.nMargin - (1 * THIS.nFactor)
            lnRight = (THIS.nQuietZone * THIS.nFactor) + (4 * THIS.nFactor)
            THIS.oGra.SetBrush(THIS.nBackColor)
            THIS.oGra.SetRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.FillRect(lnLeft, THIS.nImageHeight - THIS.nTextHeight - THIS.nMargin, lnRight, THIS.nTextHeight)
            THIS.oGra.SetAlignment(1 , 1, 0)
            THIS.oGra.SetBrush(THIS.nFontColor)
            THIS.oGra.DrawString(SUBSTR(THIS.cHumanReadableText,8,1), THIS.cFontName, THIS.nFontHeight * 0.85, THIS.cFontStyle)

            *-- Supplemental
            IF NOT EMPTY(THIS.cSupplementalText)
              lnLeft = (((2 * THIS.nQuietZone) + 48) * THIS.nFactor) + THIS.nMargin
              lnRight = (LEN(THIS.cSupplementalText) + 1) * 9 * THIS.nFactor
              THIS.oGra.SetBrush(THIS.nBackColor)
              THIS.oGra.SetRect(lnLeft, THIS.nMargin, lnRight, THIS.nTextHeight)
              THIS.oGra.FillRect(lnLeft, THIS.nMargin, lnRight, THIS.nTextHeight)
              THIS.oGra.SetAlignment(1 , 1, 0)
              THIS.oGra.SetBrush(THIS.nFontColor)
              THIS.oGra.DrawString(THIS.cSupplementalText, THIS.cFontName, THIS.nFontHeight, THIS.cFontStyle)
            ENDIF

            *-- Redraw lines
            lcBin = LEFT(THIS.cPattern, THIS.nQuietZone + 4 ) + REPLICATE("0", 6 * 7)  + "10101"
            FOR ln = 1 TO LEN(lcBin)
              lnCol = ln - 1
              IF SUBSTR(lcBin, ln, 1) = "1"
                THIS.oGra.DrawLine(lnCol * THIS.nFactor + THIS.nMargin, THIS.nImageHeight- THIS.nTextHeight - THIS.nMargin, lnCol * THIS.nFactor + THIS.nMargin, THIS.nImageHeight - THIS.nTextHeight/2 - THIS.nMargin - 2)
              ENDIF
            ENDFOR

          CASE THIS.nBarcodeType = 180 && PostNet
            *--
            *-- Without human readable
            *--
          OTHERWISE  && The rest of the bar code
            THIS.oGra.SetAlignment(THIS.nAlignText , 1, 0)
            THIS.oGra.SetBrush(THIS.nFontColor)
            THIS.oGra.DrawString(THIS.cHumanReadableText, THIS.cFontName, THIS.nFontHeight, THIS.cFontStyle)
        ENDCASE
      ENDIF

      *-- Only the bar code ITF-14 can be Bearer Bar
      IF THIS.nBarcodeType = 152 AND THIS.nBearerBar # 0
        THIS.oGra.SetPen(THIS.nBarsColor, THIS.nBearerBarWidth)
        DO CASE
          CASE THIS.nBearerBar = 2 && Top and Bottom
            *-- Top
            THIS.oGra.DrawLine(THIS.nMargin , FLOOR(THIS.nMargin + THIS.nBearerBarWidth/2), THIS.nImageWidth - THIS.nMargin, FLOOR(THIS.nMargin + THIS.nBearerBarWidth/2))
            *-- Bottom
            IF THIS.lShowHumanReadableText
              THIS.oGra.DrawLine(THIS.nMargin, FLOOR(THIS.nImageHeight - THIS.nMargin - THIS.nTextHeight- THIS.nBearerBarWidth/2), THIS.nImageWidth - THIS.nMargin, FLOOR(THIS.nImageHeight - THIS.nMargin - THIS.nTextHeight - THIS.nBearerBarWidth/2))
            ELSE
              THIS.oGra.DrawLine(THIS.nMargin, FLOOR(THIS.nImageHeight - THIS.nMargin - THIS.nBearerBarWidth/2), THIS.nImageWidth - THIS.nMargin, FLOOR(THIS.nImageHeight - THIS.nMargin - THIS.nBearerBarWidth/2))
            ENDIF

          OTHERWISE && Box
            IF THIS.lShowHumanReadableText
              THIS.oGra.DrawRect( FLOOR(THIS.nBearerBarWidth/2 + THIS.nMargin), FLOOR(THIS.nMargin + THIS.nBearerBarWidth/2), THIS.nImageWidth - THIS.nBearerBarWidth - THIS.nMargin * 2, CEILING(THIS.nImageHeight - THIS.nMargin * 2 - THIS.nBearerBarWidth - THIS.nTextHeight))
            ELSE
              THIS.oGra.DrawRect( FLOOR(THIS.nBearerBarWidth/2 + THIS.nMargin), FLOOR(THIS.nMargin + THIS.nBearerBarWidth/2), THIS.nImageWidth - THIS.nBearerBarWidth - THIS.nMargin * 2, CEILING(THIS.nImageHeight - THIS.nMargin * 2 - THIS.nBearerBarWidth))
            ENDIF
        ENDCASE
      ENDIF

      *-- Rotation of image
      THIS.oImg.ROTATEFLIP(THIS.nRotation)
    ENDIF && ISNULL(THIS.cPattern)

    *--- Comment this line, only to examples
    *    THIS.oImg.ToClipboard()

    *-- Save the image
    LOCAL lcFolder
    IF EMPTY(tcImageFile)
      lcFolder = ADDBS(THIS.cTempPath)
      IF NOT DIRECTORY(lcFolder)
        MD (lcFolder)
      ENDIF
      tcImageFile = FORCEEXT(lcFolder + SYS(2015), THIS.cImageType)
    ELSE
      lcFolder = JUSTPATH(tcImageFile)
      IF NOT DIRECTORY(lcFolder)
        MD (lcFolder)
      ENDIF
      tcImageFile = FORCEEXT(tcImageFile, THIS.cImageType)
    ENDIF
    DO CASE
      CASE THIS.cImageType = "JPG"
        THIS.oImg.SaveAsJPEG(tcImageFile,100)
      CASE THIS.cImageType = "BMP"
        THIS.oImg.SaveAsBMP(tcImageFile)
      CASE THIS.cImageType = "GIF"
        THIS.oImg.SaveAsGIF(tcImageFile)
      CASE THIS.cImageType = "PNG"
        THIS.oImg.SaveAsPNG(tcImageFile)
      CASE THIS.cImageType = "TIF"
        THIS.oImg.SaveAsTIFF(tcImageFile)
      OTHERWISE
        THIS.cImageType = "JPG"
        THIS.oImg.SaveAsJPEG(FORCEEXT(tcImageFile, THIS.cImageType),100)
    ENDCASE

    THIS.oGra = NULL
    THIS.oImg = NULL
    THIS.oGdi = NULL

    THIS.cImageFile = tcImageFile
    CLEAR RESOURCES (tcImageFile)
    RETURN tcImageFile

  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Cod_I2of5()
  *------------------------------------------------------
  * Generate bar code Interleaved 2 of 5
  *------------------------------------------------------
  PROCEDURE Cod_I2of5()

    LOCAL lcValid, lnI, lnJ, lcRet, lcStart, lcStop, lnLen

    *-- Numbers only
    lcValid = "1234567890"
    IF NOT CHRTRAN(THIS.cTextValue,CHRTRAN(THIS.cTextValue,lcValid,""),"") == THIS.cTextValue
      *-- Chars not valid
      THIS.cMsgError = "The Interleaved 2 of 5 code accepts only numeric characters."
      RETURN NULL
    ENDIF

    *-- Calculate and add the check digit
    IF THIS.lAddCheckDigit
      THIS.cTextValue = THIS.cTextValue + THIS.CheckDigitEan(THIS.cTextValue)
      IF THIS.lShowCheckDigit
        THIS.cHumanReadableText = THIS.cTextValue
      ENDIF
    ENDIF

    lnLen = LEN(THIS.cTextValue)

    *--- Length must be even
    IF MOD(lnLen,2) # 0
      THIS.cTextValue = "0" + THIS.cTextValue
      lnLen = LEN(THIS.cTextValue)
      THIS.cHumanReadableText = THIS.cTextValue
    ENDIF

    LOCAL ARRAY la(10)
    *-- Coding of each character
    la[1] = "NNWWN" && 0
    la[2] = "WNNNW" && 1
    la[3] = "NWNNW" && 2
    la[4] = "WWNNN" && 3
    la[5] = "NNWNW" && 4
    la[6] = "WNWNN" && 5
    la[7] = "NWWNN" && 6
    la[8] = "NNNWW" && 7
    la[9] = "WNNWN" && 8
    la[10] = "NWNWN" && 9
    lcStart = "1010"  && Start
    lcStop = "B01"  && "1101" Stop

    *-- Encode 0s and 1s
    lcRet = ""
    FOR lnJ = 1 TO lnLen STEP 2
      lcPar = SUBSTR(THIS.cTextValue,lnJ,2)
      *-- Interlace each pair
      FOR lnI = 1 TO 5
        lcRet = lcRet + IIF(SUBSTR(la[VAL(LEFT(lcPar,1))+1],lnI,1) = "N", "1", "B") + IIF(SUBSTR(la[VAL(RIGHT(lcPar,1))+1],lnI,1) = "N", "0", "S")
      ENDFOR
    ENDFOR

    *-- Add Start and Stop and apply ratio
    RETURN THIS.ApplyRatio(lcStart + lcRet + lcStop, THIS.nRatio)

  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Cod_S2of5()
  *------------------------------------------------------
  * Generate bar code Standard 2 of 5
  *------------------------------------------------------
  PROCEDURE Cod_S2of5()

    LOCAL lnI, lnJ, lcRet, lcStart, lcStop, lnLen, lcValid, lnSum, lnCon

    *-- Numbers only
    lcValid = "1234567890"
    IF NOT CHRTRAN(THIS.cTextValue,CHRTRAN(THIS.cTextValue,lcValid,""),"") == THIS.cTextValue
      *-- Chars not valid
      THIS.cMsgError = "The Standard 2 of 5 code accepts only numeric characters."
      RETURN NULL
    ENDIF
    lnLen = LEN(THIS.cTextValue)

    *-- Calculate and add the check digit
    IF THIS.lAddCheckDigit
      lnSum = 0
      lnCon = 1
      FOR lnI = lnLen TO 1 STEP -1
        lnSum = lnSum + VAL(SUBSTR(THIS.cTextValue, lnI, 1)) * IIF(MOD(lnCon,2) = 0, 1, 3)
        lnCon = lnCon + 1
      ENDFOR
      THIS.cTextValue = THIS.cTextValue + TRANSFORM(MOD((10 - MOD(lnSum,10)),10))
      IF THIS.lShowCheckDigit
        THIS.cHumanReadableText = THIS.cTextValue
      ENDIF
      lnLen = LEN(THIS.cTextValue)
    ENDIF

    LOCAL ARRAY la[10]
    *-- Coding of character
    la[1]="1010B0B010" && 0
    la[2]="B0101010B0" && 1
    la[3]="10B01010B0" && 2
    la[4]="B0B0101010" && 3
    la[5]="1010B010B0" && 4
    la[6]="B010B01010" && 5
    la[7]="10B0B01010" && 6
    la[8]="101010B0B0" && 7
    la[9]="B01010B010" && 8
    la[10]="10B010B010" && 9
    lcStart = "B0B010"  && Start
    lcStop = "B010B0"  && Stop

    *-- Encode 0s and 1s
    lcRet = ""
    FOR lnI = 1 TO lnLen
      lcRet = lcRet + la(VAL(SUBSTR(THIS.cTextValue, lnI, 1)) + 1)
    ENDFOR

    *-- Add Start and Stop and apply ratio
    RETURN THIS.ApplyRatio(lcStart + lcRet + lcStop, THIS.nRatio)

  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Cod_Codabar()
  *------------------------------------------------------
  * Generate Codabar bar code
  *------------------------------------------------------
  PROCEDURE Cod_Codabar()

    LOCAL lcRet, lcValid, lcChar, ln

    THIS.cTextValue = ALLTRIM(UPPER(THIS.cTextValue))

    *-- Start char
    IF NOT LEFT(THIS.cTextValue, 1) $ "ABCDTN*E"
      THIS.cTextValue = "A" + THIS.cTextValue
    ENDIF

    *-- Stop char
    IF NOT RIGHT(THIS.cTextValue, 1) $ "ABCDTN*E"
      THIS.cTextValue = THIS.cTextValue + "B"
    ENDIF

    *-- Chars valid only
    lcValid = "0123456789-$:/.+"
    IF NOT EMPTY(CHRTRAN(SUBSTR(THIS.cTextValue, 2, LEN(THIS.cTextValue) - 2), lcValid, ""))
      *-- Chars not valid
      THIS.cMsgError = "Codabar code only accepts the following characters: 0123456789-$:/.+"
      RETURN NULL
    ENDIF

    lcRet = ""
    FOR ln = 1 TO LEN(THIS.cTextValue)
      lcChar = SUBST(THIS.cTextValue, ln, 1)
      DO CASE
        CASE lcChar = "0"
          lcRet = lcRet + "101010001110"
        CASE lcChar = "1"
          lcRet = lcRet + "101011100010"
        CASE lcChar = "2"
          lcRet = lcRet + "101000101110"
        CASE lcChar = "3"
          lcRet = lcRet + "111000101010"
        CASE lcChar = "4"
          lcRet = lcRet + "101110100010"
        CASE lcChar = "5"
          lcRet = lcRet + "111010100010"
        CASE lcChar = "6"
          lcRet = lcRet + "100010101110"
        CASE lcChar = "7"
          lcRet = lcRet + "100010111010"
        CASE lcChar = "8"
          lcRet = lcRet + "100011101010"
        CASE lcChar = "9"
          lcRet = lcRet + "111010001010"
        CASE lcChar = "-"
          lcRet = lcRet + "101000111010"
        CASE lcChar = "$"
          lcRet = lcRet + "101110001010"
        CASE lcChar = ":"
          lcRet = lcRet + "11101011101110"
        CASE lcChar = "/"
          lcRet = lcRet + "11101110101110"
        CASE lcChar = "."
          lcRet = lcRet + "11101110111010"
        CASE lcChar = "+"
          lcRet = lcRet + "10111011101110"
        CASE lcChar = "A"
          lcRet = lcRet + "10111000100010" && Start/Stop A
        CASE lcChar = "B"
          lcRet = lcRet + "10100010001110" && Start/Stop B
        CASE lcChar = "C"
          lcRet = lcRet + "10001000101110" && Start/Stop C
        CASE lcChar = "D"
          lcRet = lcRet + "10100011100010" && Start/Stop D
        CASE lcChar = "T"
          lcRet = lcRet + "10111000100010" && Start/Stop T
        CASE lcChar = "N"
          lcRet = lcRet + "10001000101110" && Start/Stop N
        CASE lcChar = "*"
          lcRet = lcRet + "10100010001110" && Start/Stop *
        CASE lcChar = "E"
          lcRet = lcRet + "10100011100010" && Start/Stop E
      ENDCASE

    ENDFOR

    IF THIS.lShowStartStopChars
      THIS.cHumanReadableText = THIS.cTextValue
    ELSE
      THIS.cHumanReadableText = SUBSTR(THIS.cTextValue, 2, LEN(THIS.cTextValue) - 2)
    ENDIF
    THIS.cHumanReadableText = THIS.AddSpace(THIS.cHumanReadableText)

    *--  Apply ratio
    RETURN lcRet

  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Cod_128()
  *------------------------------------------------------
  * Generate Code128 bar code (Sets A, B and C)
  *------------------------------------------------------
  PROCEDURE Cod_128()

    LOCAL lnSum, lnLen, lc, ln, lcStart, lcStop, lcRet

    *-- Valid chars
    * Set A = [CHR(0)..CHR(95)]
    * Set B = [CHR(32)..CHR(127)]
    * Set C = [CHR(48)..CHR(57)] -> [0..9]

    DO CASE
      CASE UPPER(THIS.cSet128) = "A"
        IF NOT THIS.ValidAscii(THIS.cTextValue,0,95)
          *-- Chars not valid
          THIS.cMsgError = "Invalid characters for Code 128 Set A"
          RETURN NULL
        ENDIF
        lnSum = 103

      CASE UPPER(THIS.cSet128) = "B"
        IF NOT THIS.ValidAscii(THIS.cTextValue,32,127)
          *-- Chars not valid
          THIS.cMsgError = "Invalid characters for Code 128 Set B"
          RETURN NULL
        ENDIF
        lnSum = 104

      CASE UPPER(THIS.cSet128) = "C"
        IF NOT THIS.ValidAscii(THIS.cTextValue,48,57)
          *-- Chars not valid
          THIS.cMsgError = "The Code 128 Set C accepts only numeric characters."
          RETURN NULL
        ENDIF

        *--- Length must be even
        IF MOD(LEN(THIS.cTextValue),2) # 0
          THIS.cTextValue = "0" + THIS.cTextValue
          THIS.cHumanReadableText = THIS.cTextValue
        ENDIF

        THIS.cTextValue = THIS.Pair2Char(THIS.cTextValue)
        lnSum = 105

    ENDCASE

    LOCAL ARRAY laCod128[106]
    laCod128[1] = "11011001100"
    laCod128[2] = "11001101100"
    laCod128[3] = "11001100110"
    laCod128[4] = "10010011000"
    laCod128[5] = "10010001100"
    laCod128[6] = "10001001100"
    laCod128[7] = "10011001000"
    laCod128[8] = "10011000100"
    laCod128[9] = "10001100100"
    laCod128[10] = "11001001000"
    laCod128[11] = "11001000100"
    laCod128[12] = "11000100100"
    laCod128[13] = "10110011100"
    laCod128[14] = "10011011100"
    laCod128[15] = "10011001110"
    laCod128[16] = "10111001100"
    laCod128[17] = "10011101100"
    laCod128[18] = "10011100110"
    laCod128[19] = "11001110010"
    laCod128[20] = "11001011100"
    laCod128[21] = "11001001110"
    laCod128[22] = "11011100100"
    laCod128[23] = "11001110100"
    laCod128[24] = "11101101110"
    laCod128[25] = "11101001100"
    laCod128[26] = "11100101100"
    laCod128[27] = "11100100110"
    laCod128[28] = "11101100100"
    laCod128[29] = "11100110100"
    laCod128[30] = "11100110010"
    laCod128[31] = "11011011000"
    laCod128[32] = "11011000110"
    laCod128[33] = "11000110110"
    laCod128[34] = "10100011000"
    laCod128[35] = "10001011000"
    laCod128[36] = "10001000110"
    laCod128[37] = "10110001000"
    laCod128[38] = "10001101000"
    laCod128[39] = "10001100010"
    laCod128[40] = "11010001000"
    laCod128[41] = "11000101000"
    laCod128[42] = "11000100010"
    laCod128[43] = "10110111000"
    laCod128[44] = "10110001110"
    laCod128[45] = "10001101110"
    laCod128[46] = "10111011000"
    laCod128[47] = "10111000110"
    laCod128[48] = "10001110110"
    laCod128[49] = "11101110110"
    laCod128[50] = "11010001110"
    laCod128[51] = "11000101110"
    laCod128[52] = "11011101000"
    laCod128[53] = "11011100010"
    laCod128[54] = "11011101110"
    laCod128[55] = "11101011000"
    laCod128[56] = "11101000110"
    laCod128[57] = "11100010110"
    laCod128[58] = "11101101000"
    laCod128[59] = "11101100010"
    laCod128[60] = "11100011010"
    laCod128[61] = "11101111010"
    laCod128[62] = "11001000010"
    laCod128[63] = "11110001010"
    laCod128[64] = "10100110000"
    laCod128[65] = "10100001100"
    laCod128[66] = "10010110000"
    laCod128[67] = "10010000110"
    laCod128[68] = "10000101100"
    laCod128[69] = "10000100110"
    laCod128[70] = "10110010000"
    laCod128[71] = "10110000100"
    laCod128[72] = "10011010000"
    laCod128[73] = "10011000010"
    laCod128[74] = "10000110100"
    laCod128[75] = "10000110010"
    laCod128[76] = "11000010010"
    laCod128[77] = "11001010000"
    laCod128[78] = "11110111010"
    laCod128[79] = "11000010100"
    laCod128[80] = "10001111010"
    laCod128[81] = "10100111100"
    laCod128[82] = "10010111100"
    laCod128[83] = "10010011110"
    laCod128[84] = "10111100100"
    laCod128[85] = "10011110100"
    laCod128[86] = "10011110010"
    laCod128[87] = "11110100100"
    laCod128[88] = "11110010100"
    laCod128[89] = "11110010010"
    laCod128[90] = "11011011110"
    laCod128[91] = "11011110110"
    laCod128[92] = "11110110110"
    laCod128[93] = "10101111000"
    laCod128[94] = "10100011110"
    laCod128[95] = "10001011110"
    laCod128[96] = "10111101000"
    laCod128[97] = "10111100010" && FNC3
    laCod128[98] = "11110101000" && FNC2
    laCod128[99] = "11110100010" && Shift
    laCod128[100] = "10111011110"
    laCod128[101] = "10111101110" && FNC4
    laCod128[102] = "11101011110"
    laCod128[103] = "11110101110" && FNC1
    laCod128[104] = "11010000100" && Start A
    laCod128[105] = "11010010000" && Start B
    laCod128[106] = "11010011100" && Start C

    lcStart = laCod128(lnSum + 1)
    lcStop = "1100011101011" && Stop

    *-- Always calculates the check digit
    FOR ln = 1 TO LEN(THIS.cTextValue)
      lnSum = lnSum + (ASC(SUBSTR(THIS.cTextValue, ln, 1)) - 32) * ln
    ENDFOR
    THIS.cTextValue = THIS.cTextValue + CHR(MOD(lnSum,103) + 32)
    lnLen = LEN(THIS.cTextValue)

    *-- Encode 0s and 1s
    lcRet = ""
    FOR ln = 1 TO lnLen
      lcRet = lcRet + laCod128(ASC(SUBSTR(THIS.cTextValue, ln, 1)) - 32 + 1)
    ENDFOR

    *-- Add Start and Stop
    RETURN lcStart + lcRet + lcStop

  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Cod_39Ext()
  *------------------------------------------------------
  * Generate Code 39 Extended bar code
  *------------------------------------------------------
  PROCEDURE Cod_39Ext()

    LOCAL lcRet, lnLen, lnSum, lnAsc, lcStart, lcStop

    IF NOT THIS.ValidAscii(THIS.cTextValue,0,127)
      *-- Chars not valid
      THIS.cMsgError = "Invalid character for Code 39 Full ASCII."
      RETURN NULL
    ENDIF

    lnLen = LEN(THIS.cTextValue)

    LOCAL ARRAY laCod39Ext[128]
    laCod39Ext(1) = "%U"
    laCod39Ext(2) = "$A"
    laCod39Ext(3) = "$B"
    laCod39Ext(4) = "$C"
    laCod39Ext(5) = "$D"
    laCod39Ext(6) = "$E"
    laCod39Ext(7) = "$F"
    laCod39Ext(8) = "$G"
    laCod39Ext(9) = "$H"
    laCod39Ext(10) = "$I"
    laCod39Ext(11) = "$J"
    laCod39Ext(12) = "$K"
    laCod39Ext(13) = "$L"
    laCod39Ext(14) = "$M"
    laCod39Ext(15) = "$N"
    laCod39Ext(16) = "$O"
    laCod39Ext(17) = "$P"
    laCod39Ext(18) = "$Q"
    laCod39Ext(19) = "$R"
    laCod39Ext(20) = "$S"
    laCod39Ext(21) = "$T"
    laCod39Ext(22) = "$U"
    laCod39Ext(23) = "$V"
    laCod39Ext(24) = "$W"
    laCod39Ext(25) = "$X"
    laCod39Ext(26) = "$Y"
    laCod39Ext(27) = "$Z"
    laCod39Ext(28) = "%A"
    laCod39Ext(29) = "%B"
    laCod39Ext(30) = "%C"
    laCod39Ext(31) = "%D"
    laCod39Ext(32) = "%E"
    laCod39Ext(33) = SPACE(1)
    laCod39Ext(34) = "/A"
    laCod39Ext(35) = "/B"
    laCod39Ext(36) = "/C"
    laCod39Ext(37) = "/D"
    laCod39Ext(38) = "/E"
    laCod39Ext(39) = "/F"
    laCod39Ext(40) = "/G"
    laCod39Ext(41) = "/H"
    laCod39Ext(42) = "/I"
    laCod39Ext(43) = "/J"
    laCod39Ext(44) = "/K"
    laCod39Ext(45) = "/L"
    laCod39Ext(46) = "-"
    laCod39Ext(47) = "."
    laCod39Ext(48) = "/O"
    laCod39Ext(49) = "0"
    laCod39Ext(50) = "1"
    laCod39Ext(51) = "2"
    laCod39Ext(52) = "3"
    laCod39Ext(53) = "4"
    laCod39Ext(54) = "5"
    laCod39Ext(55) = "6"
    laCod39Ext(56) = "7"
    laCod39Ext(57) = "8"
    laCod39Ext(58) = "9"
    laCod39Ext(59) = "/Z"
    laCod39Ext(60) = "%F"
    laCod39Ext(61) = "%G"
    laCod39Ext(62) = "%H"
    laCod39Ext(63) = "%I"
    laCod39Ext(64) = "%J"
    laCod39Ext(65) = "%V"
    laCod39Ext(66) = "A"
    laCod39Ext(67) = "B"
    laCod39Ext(68) = "C"
    laCod39Ext(69) = "D"
    laCod39Ext(70) = "E"
    laCod39Ext(71) = "F"
    laCod39Ext(72) = "G"
    laCod39Ext(73) = "H"
    laCod39Ext(74) = "I"
    laCod39Ext(75) = "J"
    laCod39Ext(76) = "K"
    laCod39Ext(77) = "L"
    laCod39Ext(78) = "M"
    laCod39Ext(79) = "N"
    laCod39Ext(80) = "O"
    laCod39Ext(81) = "P"
    laCod39Ext(82) = "Q"
    laCod39Ext(83) = "R"
    laCod39Ext(84) = "S"
    laCod39Ext(85) = "T"
    laCod39Ext(86) = "U"
    laCod39Ext(87) = "V"
    laCod39Ext(88) = "W"
    laCod39Ext(89) = "X"
    laCod39Ext(90) = "Y"
    laCod39Ext(91) = "Z"
    laCod39Ext(92) = "%K"
    laCod39Ext(93) = "%L"
    laCod39Ext(94) = "%M"
    laCod39Ext(95) = "%N"
    laCod39Ext(96) = "%O"
    laCod39Ext(97) = "%W"
    laCod39Ext(98) = "+A"
    laCod39Ext(99) = "+B"
    laCod39Ext(100) = "+C"
    laCod39Ext(101) = "+D"
    laCod39Ext(102) = "+E"
    laCod39Ext(103) = "+F"
    laCod39Ext(104) = "+G"
    laCod39Ext(105) = "H"
    laCod39Ext(106) = "+I"
    laCod39Ext(107) = "+J"
    laCod39Ext(108) = "+K"
    laCod39Ext(109) = "+L"
    laCod39Ext(110) = "+M"
    laCod39Ext(111) = "+N"
    laCod39Ext(112) = "+O"
    laCod39Ext(113) = "+P"
    laCod39Ext(114) = "+Q"
    laCod39Ext(115) = "+R"
    laCod39Ext(116) = "+S"
    laCod39Ext(117) = "+T"
    laCod39Ext(118) = "+U"
    laCod39Ext(119) = "+V"
    laCod39Ext(120) = "+W"
    laCod39Ext(121) = "+X"
    laCod39Ext(122) = "+Y"
    laCod39Ext(123) = "+Z"
    laCod39Ext(124) = "%P"
    laCod39Ext(125) = "%Q"
    laCod39Ext(126) = "%R"
    laCod39Ext(127) = "%S"
    laCod39Ext(128) = "%T"

    *-- Expanding Characters
    lcTag = ""
    FOR ln = 1 TO lnLen
      lcTag = lcTag + laCod39Ext(ASC(SUBSTR(THIS.cTextValue,ln,1))+1)
    ENDFOR
    THIS.TAG = THIS.cTextValue
    THIS.cTextValue = lcTag
    lcRet = THIS.Cod_39()
    THIS.cTextValue = THIS.TAG

    THIS.cHumanReadableText = IIF(THIS.lShowStartStopChars, "*", "") + THIS.cTextValue + IIF(THIS.lAddCheckDigit AND THIS.lShowCheckDigit, THIS.cCheckDigit, "") + IIF(THIS.lShowStartStopChars, "*", "")
    THIS.cHumanReadableText = THIS.AddSpace(THIS.cHumanReadableText)

    RETURN lcRet

  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Cod_39()
  *------------------------------------------------------
  * Generate Code 39 bar code
  *------------------------------------------------------
  PROCEDURE Cod_39()

    LOCAL lcRet, lcValid, lnLen, lnSum, lnPos

    THIS.cTextValue = UPPER(THIS.cTextValue)
    lcValid = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%"

    IF NOT EMPTY(CHRTRAN(THIS.cTextValue, lcValid, ""))
      *-- Chars not valid
      THIS.cMsgError = "Invalid characters for Code 39."
      RETURN NULL
    ENDIF

    lnLen = LEN(THIS.cTextValue)

    LOCAL ARRAY laCod39[43]
    laCod39[1]="101SB0B010"   && 0
    laCod39[2]="B01S1010B0"   && 1
    laCod39[3]="10BS1010B0"   && 2
    laCod39[4]="B0BS101010"   && 3
    laCod39[5]="101SB010B0"   && 4
    laCod39[6]="B01SB01010"   && 5
    laCod39[7]="10BSB01010"   && 6
    laCod39[8]="101S10B0B0"   && 7
    laCod39[9]="B01S10B010"   && 8
    laCod39[10]="10BS10B010"   && 9
    laCod39[11]="B0101S10B0"   && A
    laCod39[12]="10B01S10B0"   && B
    laCod39[13]="B0B01S1010"   && C
    laCod39[14]="1010BS10B0"   && D
    laCod39[15]="B010BS1010"   && E
    laCod39[16]="10B0BS1010"   && F
    laCod39[17]="10101SB0B0"   && G
    laCod39[18]="B0101SB010"   && H
    laCod39[19]="10B01SB010"   && I
    laCod39[20]="1010BSB010"   && J
    laCod39[21]="B010101SB0"   && K
    laCod39[22]="10B0101SB0"   && L
    laCod39[23]="B0B0101S10"   && M
    laCod39[24]="1010B01SB0"   && N
    laCod39[25]="B010B01S10"   && O
    laCod39[26]="10B0B01S10"   && P
    laCod39[27]="101010BSB0"   && Q
    laCod39[28]="B01010BS10"   && R
    laCod39[29]="10B010BS10"   && S
    laCod39[30]="1010B0BS10"   && T
    laCod39[31]="BS101010B0"   && U
    laCod39[32]="1SB01010B0"   && V
    laCod39[33]="BSB0101010"   && W
    laCod39[34]="1S10B010B0"   && X
    laCod39[35]="BS10B01010"   && Y
    laCod39[36]="1SB0B01010"   && Z
    laCod39[37]="1S1010B0B0"   && -
    laCod39[38]="BS1010B010"   && .
    laCod39[39]="1SB010B010"   && SPACE
    laCod39[40]="1S1S1S1010"   && $
    laCod39[41]="1S1S101S10"   && /
    laCod39[42]="1S101S1S10"   && +
    laCod39[43]="101S1S1S10"   && %

    lcStart = "1S10B0B010"   && * Start
    lcStop = "1S10B0B01"   && * Stop

    *-- Encode 0s and 1s
    lcRet = ""
    lnSum = 0
    FOR ln = 1 TO lnLen
      lnPos = AT(SUBSTR(THIS.cTextValue, ln, 1),lcValid)
      lcRet = lcRet + laCod39(lnPos)
      lnSum = lnSum + lnPos - 1
    ENDFOR

    IF THIS.lAddCheckDigit
      THIS.cCheckDigit = SUBSTR(lcValid, MOD(lnSum,43)+1, 1)
      lcRet = lcRet + laCod39(MOD(lnSum,43)+1)
    ENDIF

    THIS.cHumanReadableText = IIF(THIS.lShowStartStopChars, "*", "") + THIS.cTextValue + IIF(THIS.lAddCheckDigit AND THIS.lShowCheckDigit, THIS.cCheckDigit, "") + IIF(THIS.lShowStartStopChars, "*", "")
    THIS.cHumanReadableText = THIS.AddSpace(THIS.cHumanReadableText)

    *-- Add Start and Stop and apply ratio
    RETURN THIS.ApplyRatio(lcStart + lcRet + lcStop, THIS.nRatio)

  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Cod_93Ext()
  *------------------------------------------------------
  * Generate Code 93 Extended bar code
  *------------------------------------------------------
  PROCEDURE Cod_93Ext()

    LOCAL lcRet, lnLen, lnSum, lnAsc, lcStart, lcStop

    IF NOT THIS.ValidAscii(THIS.cTextValue,0,127)
      *-- Chars not valid
      THIS.cMsgError = "Invalid character for Code 93 Full ASCII."
      RETURN NULL
    ENDIF

    lnLen = LEN(THIS.cTextValue)

    LOCAL ARRAY laCod93Ext[128]
    laCod93Ext(1) = "#U"
    laCod93Ext(2) = "=A"
    laCod93Ext(3) = "=B"
    laCod93Ext(4) = "=C"
    laCod93Ext(5) = "=D"
    laCod93Ext(6) = "=E"
    laCod93Ext(7) = "=F"
    laCod93Ext(8) = "=G"
    laCod93Ext(9) = "=H"
    laCod93Ext(10) = "=I"
    laCod93Ext(11) = "=J"
    laCod93Ext(12) = "=K"
    laCod93Ext(13) = "=L"
    laCod93Ext(14) = "=M"
    laCod93Ext(15) = "=N"
    laCod93Ext(16) = "=O"
    laCod93Ext(17) = "=P"
    laCod93Ext(18) = "=Q"
    laCod93Ext(19) = "=R"
    laCod93Ext(20) = "=S"
    laCod93Ext(21) = "=T"
    laCod93Ext(22) = "=U"
    laCod93Ext(23) = "=V"
    laCod93Ext(24) = "=W"
    laCod93Ext(25) = "=X"
    laCod93Ext(26) = "=Y"
    laCod93Ext(27) = "=Z"
    laCod93Ext(28) = "#A"
    laCod93Ext(29) = "#B"
    laCod93Ext(30) = "#C"
    laCod93Ext(31) = "#D"
    laCod93Ext(32) = "#E"
    laCod93Ext(33) = SPACE(1)
    laCod93Ext(34) = "&A"
    laCod93Ext(35) = "&B"
    laCod93Ext(36) = "&C"
    laCod93Ext(37) = "$" && "&D"
    laCod93Ext(38) = "%" && "&E"
    laCod93Ext(39) = "&F"
    laCod93Ext(40) = "&G"
    laCod93Ext(41) = "&H"
    laCod93Ext(42) = "&I"
    laCod93Ext(43) = "&J"
    laCod93Ext(44) = "+" && "&K"
    laCod93Ext(45) = "&L"
    laCod93Ext(46) = "-" && "&M"
    laCod93Ext(47) = "." && "&N"
    laCod93Ext(48) = "/" && "&O"
    laCod93Ext(49) = "0"
    laCod93Ext(50) = "1"
    laCod93Ext(51) = "2"
    laCod93Ext(52) = "3"
    laCod93Ext(53) = "4"
    laCod93Ext(54) = "5"
    laCod93Ext(55) = "6"
    laCod93Ext(56) = "7"
    laCod93Ext(57) = "8"
    laCod93Ext(58) = "9"
    laCod93Ext(59) = "&Z"
    laCod93Ext(60) = "#F"
    laCod93Ext(61) = "#G"
    laCod93Ext(62) = "#H"
    laCod93Ext(63) = "#I"
    laCod93Ext(64) = "#J"
    laCod93Ext(65) = "#V"
    laCod93Ext(66) = "A"
    laCod93Ext(67) = "B"
    laCod93Ext(68) = "C"
    laCod93Ext(69) = "D"
    laCod93Ext(70) = "E"
    laCod93Ext(71) = "F"
    laCod93Ext(72) = "G"
    laCod93Ext(73) = "H"
    laCod93Ext(74) = "I"
    laCod93Ext(75) = "J"
    laCod93Ext(76) = "K"
    laCod93Ext(77) = "L"
    laCod93Ext(78) = "M"
    laCod93Ext(79) = "N"
    laCod93Ext(80) = "O"
    laCod93Ext(81) = "P"
    laCod93Ext(82) = "Q"
    laCod93Ext(83) = "R"
    laCod93Ext(84) = "S"
    laCod93Ext(85) = "T"
    laCod93Ext(86) = "U"
    laCod93Ext(87) = "V"
    laCod93Ext(88) = "W"
    laCod93Ext(89) = "X"
    laCod93Ext(90) = "Y"
    laCod93Ext(91) = "Z"
    laCod93Ext(92) = "#K"
    laCod93Ext(93) = "#L"
    laCod93Ext(94) = "#M"
    laCod93Ext(95) = "#N"
    laCod93Ext(96) = "#O"
    laCod93Ext(97) = "#W"
    laCod93Ext(98) = "@A"
    laCod93Ext(99) = "@B"
    laCod93Ext(100) = "@C"
    laCod93Ext(101) = "@D"
    laCod93Ext(102) = "@E"
    laCod93Ext(103) = "@F"
    laCod93Ext(104) = "@G"
    laCod93Ext(105) = "H"
    laCod93Ext(106) = "@I"
    laCod93Ext(107) = "@J"
    laCod93Ext(108) = "@K"
    laCod93Ext(109) = "@L"
    laCod93Ext(110) = "@M"
    laCod93Ext(111) = "@N"
    laCod93Ext(112) = "@O"
    laCod93Ext(113) = "@P"
    laCod93Ext(114) = "@Q"
    laCod93Ext(115) = "@R"
    laCod93Ext(116) = "@S"
    laCod93Ext(117) = "@T"
    laCod93Ext(118) = "@U"
    laCod93Ext(119) = "@V"
    laCod93Ext(120) = "@W"
    laCod93Ext(121) = "@X"
    laCod93Ext(122) = "@Y"
    laCod93Ext(123) = "@Z"
    laCod93Ext(124) = "#P"
    laCod93Ext(125) = "#Q"
    laCod93Ext(126) = "#R"
    laCod93Ext(127) = "#S"
    laCod93Ext(128) = "#T"

    *-- Expanding Characters
    lcTag = ""
    FOR ln = 1 TO lnLen
      lcTag = lcTag + laCod93Ext(ASC(SUBSTR(THIS.cTextValue,ln,1))+1)
    ENDFOR

    THIS.TAG = THIS.cTextValue
    THIS.cTextValue = lcTag
    lcRet = THIS.Cod_93()
    THIS.cTextValue = THIS.TAG

    THIS.cHumanReadableText = THIS.cTextValue + IIF(THIS.lShowCheckDigit, THIS.cCheckDigit, "")

    RETURN lcRet

  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Cod_93()
  *------------------------------------------------------
  * Generate Code 93 bar code
  *------------------------------------------------------
  PROCEDURE Cod_93()

    LOCAL lcRet, lcValid, lnLen, lnSum, lnPos

    THIS.cTextValue = UPPER(THIS.cTextValue)

    lcValid = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%=#&@"
    IF NOT EMPTY(CHRTRAN(THIS.cTextValue, lcValid, ""))
      *-- Chars not valid
      THIS.cMsgError = "Invalid characters for Code 93."
      RETURN NULL
    ENDIF

    lnLen = LEN(THIS.cTextValue)

    LOCAL ARRAY laCod93[47]
    laCod93(1) = "100010100"  &&  0
    laCod93(2) = "101001000"  &&  1
    laCod93(3) = "101000100"  &&  2
    laCod93(4) = "101000010"  &&  3
    laCod93(5) = "100101000"  &&  4
    laCod93(6) = "100100100"  &&  5
    laCod93(7) = "100100010"  &&  6
    laCod93(8) = "101010000"  &&  7
    laCod93(9) = "100010010"  &&  8
    laCod93(10) = "100001010"  &&  9
    laCod93(11) = "110101000"  &&  A
    laCod93(12) = "110100100"  &&  B
    laCod93(13) = "110100010"  &&  C
    laCod93(14) = "110010100"  &&  D
    laCod93(15) = "110010010"  &&  E
    laCod93(16) = "110001010"  &&  F
    laCod93(17) = "101101000"  &&  G
    laCod93(18) = "101100100"  &&  H
    laCod93(19) = "101100010"  &&  I
    laCod93(20) = "100110100"  &&  J
    laCod93(21) = "100011010"  &&  K
    laCod93(22) = "101011000"  &&  L
    laCod93(23) = "101001100"  &&  M
    laCod93(24) = "101000110"  &&  N
    laCod93(25) = "100101100"  &&  O
    laCod93(26) = "100010110"  &&  P
    laCod93(27) = "110110100"  &&  Q
    laCod93(28) = "110110010"  &&  R
    laCod93(29) = "110101100"  &&  S
    laCod93(30) = "110100110"  &&  T
    laCod93(31) = "110010110"  &&  U
    laCod93(32) = "110011010"  &&  V
    laCod93(33) = "101101100"  &&  W
    laCod93(34) = "101100110"  &&  X
    laCod93(35) = "100110110"  &&  Y
    laCod93(36) = "100111010"  &&  Z
    laCod93(37) = "100101110"  &&  -
    laCod93(38) = "111010100"  &&  .
    laCod93(39) = "111010010"  &&  SPACE
    laCod93(40) = "111001010"  &&  $
    laCod93(41) = "101101110"  &&  /
    laCod93(42) = "101110110"  &&  +
    laCod93(43) = "110101110"  &&   %
    laCod93(44) = "100100110"  &&  ($) =
    laCod93(45) = "111011010"  &&  (%) #   /
    laCod93(46) = "111010110"  &&  (/) &   +
    laCod93(47) = "100110010"  &&  (+) @   %

    lcStart = "101011110"  &&  Start
    lcStop = "1010111101"  &&  Stop with termination bar

    lcTag = THIS.cTextValue

    *-- Encode 0s and 1s
    lcRet = ""
    FOR ln = 1 TO lnLen
      lnPos = AT(SUBSTR(lcTag, ln, 1),lcValid)
      lcRet = lcRet + laCod93(lnPos)
    ENDFOR

    *-- Always with two Check Digit
    *-- First Check Digit
    lnSum = 0
    lnCon = 1
    FOR ln = lnLen TO 1 STEP -1
      lnPos = AT(SUBSTR(lcTag, ln, 1), lcValid)
      lnSum = lnSum + ((lnPos - 1) * lnCon)
      lnCon = lnCon + 1
      IF lnCon > 20
        lnCon = 1
      ENDIF
    ENDFOR
    lnCheckDigit = MOD(lnSum,47)
    lcCheckDigit = SUBSTR(lcValid, lnCheckDigit + 1, 1)
    lcRet = lcRet + laCod93(lnCheckDigit + 1)
    lcTag = lcTag + lcCheckDigit
    lnLen = LEN(lcTag)
    THIS.cCheckDigit = lcCheckDigit

    *-- Second Check Digit
    lnSum = 0
    lnCon = 1
    FOR ln = lnLen TO 1 STEP -1
      lnPos = AT(SUBSTR(lcTag, ln, 1),lcValid)
      lnSum = lnSum + ((lnPos - 1) * lnCon)
      lnCon = lnCon + 1
      IF lnCon > 15
        lnCon = 1
      ENDIF
    ENDFOR
    lnCheckDigit = MOD(lnSum,47)
    lcCheckDigit = SUBSTR(lcValid, lnCheckDigit + 1, 1)
    lcRet = lcRet + laCod93(lnCheckDigit+1)
    lcTag = lcTag + lcCheckDigit
    lnLen = LEN(lcTag)

    THIS.cCheckDigit = THIS.cCheckDigit + lcCheckDigit
    THIS.cCheckDigit = CHRTRAN(THIS.cCheckDigit, "=#&@", "$%/+")

    THIS.cHumanReadableText =  THIS.cTextValue + IIF(THIS.lShowCheckDigit, THIS.cCheckDigit, "")
    *THIS.cHumanReadableText = THIS.AddSpace(THIS.cHumanReadableText)

    *-- Add Start and Stop
    RETURN lcStart + lcRet + lcStop

  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Cod_Itf14()
  *------------------------------------------------------
  * Generate EAN-14 or ITF-14 bar code
  *------------------------------------------------------
  PROCEDURE Cod_Itf14()

    LOCAL lcValid

    lcValid = "1234567890"
    IF NOT CHRTRAN(THIS.cTextValue,CHRTRAN(THIS.cTextValue,lcValid,""),"") == THIS.cTextValue
      *-- Chars or lenght not valid
      THIS.cMsgError = "The ITF-14 code accepts only numeric characters."
      RETURN NULL
    ENDIF

    IF NOT BETWEEN(LEN(THIS.cTextValue),13,14)
      *-- Chars or lenght not valid
      THIS.cMsgError = "ITF-14: The length of the string must be 13 or 14"
      RETURN NULL
    ENDIF

    IF LEN(THIS.cTextValue) = 14
      *-- Check digit not valid
      lcCheckDigit = THIS.CheckDigitEan(LEFT(THIS.cTextValue,13))
      IF lcCheckDigit <> RIGHT(THIS.cTextValue,1)
        THIS.cMsgError = "ITF-14: The correct check digit is " + lcCheckDigit
        RETURN NULL
      ELSE
        THIS.cTextValue = LEFT(THIS.cTextValue,13)
      ENDIF
    ENDIF

    *-- Ok
    RETURN THIS.Cod_I2of5()

  ENDPROC
  *------------------------------------------------------
  * PROCEDURE Cod_Ean13()
  *------------------------------------------------------
  * Generate EAN-13 bar code
  *------------------------------------------------------
  PROCEDURE Cod_Ean13()

    LOCAL lcValid, lcRet, lc, lcStartStop, lcCenter

    lcValid = "1234567890"
    IF NOT CHRTRAN(THIS.cTextValue,CHRTRAN(THIS.cTextValue,lcValid,""),"") == THIS.cTextValue
      *-- Chars or lenght not valid
      THIS.cMsgError = "The EAN-13 code accepts only numeric characters."
      RETURN NULL
    ENDIF

    IF NOT BETWEEN(LEN(THIS.cTextValue),12,18)
      *-- Chars or lenght not valid
      THIS.cMsgError = "The length of the string must be 12 or 13. With supplement between 14 and 18."
      RETURN NULL
    ENDIF

    IF LEN(THIS.cTextValue) = 13
      *-- Check digit not valid
      lcCheckDigit = THIS.CheckDigitEan(LEFT(THIS.cTextValue,12))
      IF lcCheckDigit <> RIGHT(THIS.cTextValue,1)
        THIS.cMsgError = "EAN-13: The correct check digit is " + lcCheckDigit
        RETURN NULL
      ELSE
        THIS.cTextValue = LEFT(THIS.cTextValue,12)
      ENDIF
    ENDIF

    IF LEN(THIS.cTextValue) > 13 && with supplemental
      THIS.cSupplementalText = SUBSTR(THIS.cTextValue,14)
      THIS.cTextValue = LEFT(THIS.cTextValue,12)
    ELSE
      THIS.cSupplementalText = ""
    ENDIF

    LOCAL ARRAY laSet(10), laA(10), laB(10), laC(10)
    *--- Characters set table
    *--- As "lnPri" (¡DO NOT CHANGE!)
    laSet(1) = "AAAAAACCCCCC"   && 0
    laSet(2) = "AABABBCCCCCC"   && 1
    laSet(3) = "AABBABCCCCCC"   && 2
    laSet(4) = "AABBBACCCCCC"   && 3
    laSet(5) = "ABAABBCCCCCC"   && 4
    laSet(6) = "ABBAABCCCCCC"   && 5
    laSet(7) = "ABBBAACCCCCC"   && 6
    laSet(8) = "ABABABCCCCCC"   && 7
    laSet(9) = "ABABBACCCCCC"   && 8
    laSet(10) = "ABBABACCCCCC"   && 9

    *-- Left Set A
    laA(1) = "0001101"
    laA(2) = "0011001"
    laA(3) = "0010011"
    laA(4) = "0111101"
    laA(5) = "0100011"
    laA(6) = "0110001"
    laA(7) = "0101111"
    laA(8) = "0111011"
    laA(9) = "0110111"
    laA(10) = "0001011"

    *-- Left Set B
    laB(1) = "0100111"
    laB(2) = "0110011"
    laB(3) = "0011011"
    laB(4) = "0100001"
    laB(5) = "0011101"
    laB(6) = "0111001"
    laB(7) = "0000101"
    laB(8) = "0010001"
    laB(9) = "0001001"
    laB(10) = "0010111"

    *-- Right Set
    laC(1) = "1110010"
    laC(2) = "1100110"
    laC(3) = "1101100"
    laC(4) = "1000010"
    laC(5) = "1011100"
    laC(6) = "1001110"
    laC(7) = "1010000"
    laC(8) = "1000100"
    laC(9) = "1001000"
    laC(10) = "1110100"

    lcStartStop = "101"
    lcCenter = "01010"

    *-- Check digit EAN
    THIS.cTextValue = THIS.cTextValue + THIS.CheckDigitEan(THIS.cTextValue)
    THIS.cHumanReadableText = THIS.cTextValue

    lcRet = lcStartStop

    *-- 1st char
    lcSet = laSet(VAL(SUBS(THIS.cTextValue,1,1))+1)

    FOR lnI = 2 TO 7
      lc = "la" + SUBSTR(lcSet,lnI-1,1)
      lcRet = lcRet + &lc(VAL(SUBS(THIS.cTextValue,lnI,1))+1)
    ENDFOR

    lcRet = lcRet + lcCenter

    FOR lnI = 8 TO 13
      lcRet = lcRet + laC(VAL(SUBS(THIS.cTextValue,lnI,1))+1)
    ENDFOR

    lcRet = lcRet + lcStartStop

    *-- Supplemental
    IF NOT EMPTY(THIS.cSupplementalText)
      IF BETWEEN(LEN(THIS.cSupplementalText),1,2)
        lcRet = lcRet + REPLICATE("@", THIS.nQuietZone) + THIS.Cod_Sup2()
      ELSE
        lcRet = lcRet + REPLICATE("@", THIS.nQuietZone) + THIS.Cod_Sup5()
      ENDIF
    ENDIF

    RETURN lcRet
  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Cod_Ean8()
  *------------------------------------------------------
  * Generate EAN-8 bar code
  *------------------------------------------------------
  FUNCTION Cod_Ean8()
    LOCAL lcValid, lcStartStop, lcCenter, lcRet

    lcValid = "1234567890"
    IF NOT CHRTRAN(THIS.cTextValue,CHRTRAN(THIS.cTextValue,lcValid,""),"") == THIS.cTextValue
      *-- Chars or lenght not valid
      THIS.cMsgError = "The EAN-8 code accepts only numeric characters."
      RETURN NULL
    ENDIF

    IF NOT BETWEEN(LEN(THIS.cTextValue),7,13)
      *-- Chars or lenght not valid
      THIS.cMsgError = "EAN-8: The length of the string must be 7 or 8. With supplement between 9 and 13."
      RETURN NULL
    ENDIF

    IF LEN(THIS.cTextValue) = 8
      *-- Check digit not valid
      lcCheckDigit = THIS.CheckDigitEan(LEFT(THIS.cTextValue,7))
      IF lcCheckDigit <> RIGHT(THIS.cTextValue,1)
        THIS.cMsgError = "EAN-8: The correct check digit is " + lcCheckDigit
        RETURN NULL
      ELSE
        THIS.cTextValue = LEFT(THIS.cTextValue,7)
      ENDIF
    ENDIF

    IF LEN(THIS.cTextValue) > 8 && with supplemental
      THIS.cSupplementalText = SUBSTR(THIS.cTextValue,9)
      THIS.cTextValue = LEFT(THIS.cTextValue,7)
    ELSE
      THIS.cSupplementalText = ""
    ENDIF

    *-- Check digit EAN
    THIS.cTextValue = THIS.cTextValue + THIS.CheckDigitEan(THIS.cTextValue)
    THIS.cHumanReadableText = THIS.cTextValue

    LOCAL ARRAY laA(10), laC(10)
    *-- Left Set
    laA[1] ="0001101"   && 0
    laA[2] ="0011001"   && 1
    laA[3] ="0010011"   && 2
    laA[4] ="0111101"   && 3
    laA[5] ="0100011"   && 4
    laA[6] ="0110001"   && 5
    laA[7] ="0101111"   && 6
    laA[8] ="0111011"   && 7
    laA[9] ="0110111"   && 8
    laA[10]="0001011"   && 9

    *-- Right Set
    laC[1] ="1110010"   && 0
    laC[2] ="1100110"   && 1
    laC[3] ="1101100"   && 2
    laC[4] ="1000010"   && 3
    laC[5] ="1011100"   && 4
    laC[6] ="1001110"   && 5
    laC[7] ="1010000"   && 6
    laC[8] ="1000100"   && 7
    laC[9] ="1001000"   && 8
    laC[10]="1110100"   && 9

    lcStartStop = "101"
    lcCenter = "01010"

    lcRet = lcStartStop

    FOR lnI = 1 TO 4
      lcRet = lcRet + laA(VAL(SUBS(THIS.cTextValue,lnI,1))+1)
    ENDFOR

    lcRet = lcRet + lcCenter

    FOR lnI = 5 TO 8
      lcRet = lcRet + laC(VAL(SUBS(THIS.cTextValue,lnI,1))+1)
    ENDFOR

    lcRet = lcRet + lcStartStop

    *-- Supplemental
    IF NOT EMPTY(THIS.cSupplementalText)
      IF BETWEEN(LEN(THIS.cSupplementalText),1,2)
        lcRet = lcRet + REPLICATE("@", THIS.nQuietZone) + THIS.Cod_Sup2()
      ELSE
        lcRet = lcRet + REPLICATE("@", THIS.nQuietZone) + THIS.Cod_Sup5()
      ENDIF
    ENDIF

    RETURN lcRet

  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Cod_UpcA()
  *------------------------------------------------------
  * Generate UPC-A bar code
  *------------------------------------------------------
  FUNCTION Cod_UpcA()
    LOCAL lcValid, lcStartStop, lcCenter

    lcValid = "1234567890"
    IF NOT CHRTRAN(THIS.cTextValue,CHRTRAN(THIS.cTextValue,lcValid,""),"") == THIS.cTextValue
      *-- Chars or lenght not valid
      THIS.cMsgError = "The UPC-A code accepts only numeric characters."
      RETURN NULL
    ENDIF

    IF NOT BETWEEN(LEN(THIS.cTextValue),11,17)
      *-- Chars or lenght not valid
      THIS.cMsgError = "UPC-A: The length of the string must be 11 or 12. With supplement between 13 and 17."
      RETURN NULL
    ENDIF

    IF LEN(THIS.cTextValue) = 12
      *-- Check digit not valid
      lcCheckDigit = THIS.CheckDigitEan(LEFT(THIS.cTextValue,11))
      IF lcCheckDigit <> RIGHT(THIS.cTextValue,1)
        THIS.cMsgError = "UPC-A: The correct check digit is " + lcCheckDigit
        RETURN NULL
      ELSE
        THIS.cTextValue = LEFT(THIS.cTextValue,11)
      ENDIF
    ENDIF

    IF LEN(THIS.cTextValue) > 12 && with supplemental
      THIS.cSupplementalText = SUBSTR(THIS.cTextValue,13)
      THIS.cTextValue = LEFT(THIS.cTextValue,11)
    ELSE
      THIS.cSupplementalText = ""
    ENDIF

    *-- Check digit UPC
    THIS.cTextValue = THIS.cTextValue + THIS.CheckDigitEan(THIS.cTextValue)
    THIS.cHumanReadableText = THIS.cTextValue

    LOCAL ARRAY laA(10), laC(10)
    *-- Left Set
    laA(1) = "0001101"
    laA(2) = "0011001"
    laA(3) = "0010011"
    laA(4) = "0111101"
    laA(5) = "0100011"
    laA(6) = "0110001"
    laA(7) = "0101111"
    laA(8) = "0111011"
    laA(9) = "0110111"
    laA(10) = "0001011"

    *-- Right Set
    laC(1) = "1110010"
    laC(2) = "1100110"
    laC(3) = "1101100"
    laC(4) = "1000010"
    laC(5) = "1011100"
    laC(6) = "1001110"
    laC(7) = "1010000"
    laC(8) = "1000100"
    laC(9) = "1001000"
    laC(10) = "1110100"

    lcStartStop = "101"
    lcCenter = "01010"

    lcRet = lcStartStop

    FOR lnI = 1 TO 6
      lcRet = lcRet + laA(VAL(SUBS(THIS.cTextValue,lnI,1))+1)
    ENDFOR

    lcRet = lcRet + lcCenter

    FOR lnI = 7 TO 12
      lcRet = lcRet + laC(VAL(SUBS(THIS.cTextValue,lnI,1))+1)
    ENDFOR

    lcRet = lcRet + lcStartStop

    *-- Supplemental
    IF NOT EMPTY(THIS.cSupplementalText)
      IF BETWEEN(LEN(THIS.cSupplementalText),1,2)
        lcRet = lcRet + REPLICATE("@", THIS.nQuietZone) + THIS.Cod_Sup2()
      ELSE
        lcRet = lcRet + REPLICATE("@", THIS.nQuietZone) + THIS.Cod_Sup5()
      ENDIF
    ENDIF

    RETURN lcRet

  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Cod_UpcE()
  *------------------------------------------------------
  * Generate UPC-E bar code
  *------------------------------------------------------

  FUNCTION Cod_UpcE()
    LOCAL lcValid, lcUpcA, lcStart, lcStop, lcRet, lcParity

    lcUpcA = "0"

    lcValid = "1234567890"
    IF NOT CHRTRAN(THIS.cTextValue,CHRTRAN(THIS.cTextValue,lcValid,""),"") == THIS.cTextValue
      *-- Chars or lenght not valid
      THIS.cMsgError = "The UPC-E code accepts only numeric characters."
      RETURN NULL
    ENDIF

    IF NOT BETWEEN(LEN(THIS.cTextValue),6,12)
      *-- Chars or lenght not valid
      THIS.cMsgError = "UPC-E: The length of the string must be 6 or 7. With supplement between 8 and 12."
      RETURN NULL
    ENDIF

    IF LEN(THIS.cTextValue) = 7
      *-- Check digit not valid
      lcCheckDigit = THIS.CheckDigitEan(LEFT(THIS.cTextValue,6))
      IF lcCheckDigit <> RIGHT(THIS.cTextValue,1)
        THIS.cMsgError = "UPC-E: The correct check digit is " + lcCheckDigit
        RETURN NULL
      ELSE
        THIS.cTextValue = LEFT(THIS.cTextValue,6)
      ENDIF
    ENDIF

    IF LEN(THIS.cTextValue) > 7 && with supplemental
      THIS.cSupplementalText = SUBSTR(THIS.cTextValue,8)
      THIS.cTextValue = LEFT(THIS.cTextValue,6)
    ELSE
      THIS.cSupplementalText = ""
    ENDIF

    *-- UPC-E to UPC-A
    DO CASE
      CASE RIGHT(THIS.cTextValue, 1)= "0" OR RIGHT(THIS.cTextValue ,1) = "1" OR RIGHT(THIS.cTextValue ,1) = "2"
        lcUpcA = lcUpcA + LEFT(THIS.cTextValue, 2) + RIGHT(THIS.cTextValue, 1) + "0000" +  SUBSTR(THIS.cTextValue, 3, 3)
      CASE RIGHT(THIS.cTextValue, 1)= "3"
        lcUpcA = lcUpcA + LEFT(THIS.cTextValue, 3) + "00000" +  SUBSTR(THIS.cTextValue, 4, 2)
      CASE RIGHT(THIS.cTextValue, 1)= "4"
        lcUpcA = lcUpcA + LEFT(THIS.cTextValue, 4) + "00000" +  SUBSTR(THIS.cTextValue, 5, 1)
      OTHERWISE
        lcUpcA = lcUpcA + LEFT(THIS.cTextValue, 5) + "0000" + RIGHT(THIS.cTextValue, 1)
    ENDCASE
    lcUpcA = THIS.CheckDigitEan(lcUpcA)

    THIS.cHumanReadableText = "0" + THIS.cTextValue + lcUpcA

    LOCAL ARRAY  laB(10), laC(10), laA(10)
    *-- UPC-E PARITY ENCODING TABLE
    laA(1) = "EEEOOO"  &&,"OOOEEE"
    laA(2) = "EEOEOO"  &&,"OOEOEE"
    laA(3) = "EEOOEO"  &&,"OOEEOE"
    laA(4) = "EEOOOE"  &&,"OOEEEO"
    laA(5) = "EOEEOO"  &&,"OEOOEE"
    laA(6) = "EOOEEO"  &&,"OEEOOE"
    laA(7) = "EOOOEE"  &&,"OEEEOO"
    laA(8) = "EOEOEO"  &&,"OEOEOE"
    laA(9) = "EOEOOE"  &&,"OEOEEO"
    laA(10) = "EOOEOE"  &&,"OEEOEO"

    laB(1) = "0001101"
    laB(2) = "0011001"
    laB(3) = "0010011"
    laB(4) = "0111101"
    laB(5) = "0100011"
    laB(6) = "0110001"
    laB(7) = "0101111"
    laB(8) = "0111011"
    laB(9) = "0110111"
    laB(10) = "0001011"

    laC(1) = "0100111"
    laC(2) = "0110011"
    laC(3) = "0011011"
    laC(4) = "0100001"
    laC(5) = "0011101"
    laC(6) = "0111001"
    laC(7) = "0000101"
    laC(8) = "0010001"
    laC(9) = "0001001"
    laC(10) = "0010111"

    lcStart = "101"
    lcStop = "010101"

    lcRet = ""

    lcParity = laA(VAL(lcUpcA) + 1)
    FOR lnI = 1 TO 6
      IF SUBS(lcParity,lnI,1) = "O"
        lcRet = lcRet + laB(VAL(SUBS(THIS.cTextValue,lnI,1))+1)
      ELSE
        lcRet = lcRet + laC(VAL(SUBS(THIS.cTextValue,lnI,1))+1)
      ENDIF
    ENDFOR

    lcRet = lcStart + lcRet + lcStop

    *-- Supplemental
    IF NOT EMPTY(THIS.cSupplementalText)
      IF BETWEEN(LEN(THIS.cSupplementalText),1,2)
        lcRet = lcRet + REPLICATE("@", THIS.nQuietZone) + THIS.Cod_Sup2()
      ELSE
        lcRet = lcRet + REPLICATE("@", THIS.nQuietZone) + THIS.Cod_Sup5()
      ENDIF
    ENDIF

    RETURN lcRet

  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Cod_MSIPlessey()
  *------------------------------------------------------
  * Generate bar code MSI/Plessey.
  *------------------------------------------------------
  PROCEDURE Cod_MSIPlessey()

    LOCAL lnI, lnJ, lcRet, lcStart, lcStop, lnLen, lcValid, lcSum1, lcSum2, lnSum3, lnSum4, lnCon

    *-- Numbers only
    lcValid = "1234567890"
    IF NOT CHRTRAN(THIS.cTextValue,CHRTRAN(THIS.cTextValue,lcValid,""),"") == THIS.cTextValue
      *-- Chars not valid
      THIS.cMsgError = "The MSI/Plessey code accepts only numeric characters."
      RETURN NULL
    ENDIF
    lnLen = LEN(THIS.cTextValue)

    *-- Calculate and add the check digit
    IF THIS.lAddCheckDigit
      lcSum1 = ""
      lcSum2 = ""
      lnSum3 = 0
      lnSum4 = 0
      FOR lnI = 1 TO lnLen
        IF MOD(lnI, 2) = 0
          lcSum1 = lcSum1 + SUBSTR(THIS.cTextValue, lnI, 1)
        ELSE
          lcSum2 = lcSum2 + SUBSTR(THIS.cTextValue, lnI, 1)
        ENDIF
      ENDFOR
      IF MOD(lnLen,2) = 0
        lnCon = VAL(lcSum1) * 2
        FOR lnI = 1 TO LEN(TRANSFORM(lnCon))
          lnSum3 = lnSum3 + VAL(SUBSTR(TRANSFORM(lnCon), lnI, 1))
        ENDFOR
        FOR lnI = 1 TO LEN(lcSum2)
          lnSum4 = lnSum4 + VAL(SUBSTR(TRANSFORM(lcSum2), lnI, 1))
        ENDFOR
      ELSE
        lnCon = VAL(lcSum2) * 2
        FOR lnI = 1 TO LEN(TRANSFORM(lnCon))
          lnSum3 = lnSum3 + VAL(SUBSTR(TRANSFORM(lnCon), lnI, 1))
        ENDFOR
        FOR lnI = 1 TO LEN(lcSum1)
          lnSum4 = lnSum4 + VAL(SUBSTR(TRANSFORM(lcSum1), lnI, 1))
        ENDFOR
      ENDIF

      THIS.cTextValue = THIS.cTextValue + TRANSFORM(10 - (MOD(lnSum3 + lnSum4, 10)))

      IF THIS.lShowCheckDigit
        THIS.cHumanReadableText = THIS.cTextValue
      ENDIF
      lnLen = LEN(THIS.cTextValue)
    ENDIF

    LOCAL ARRAY  la[10]
    *-- Coding of each character
    la[1]="1S1S1S1S" && 0
    la[2]="1S1S1SB0" && 1
    la[3]="1S1SB01S" && 2
    la[4]="1S1SB0B0" && 3
    la[5]="1SB01S1S" && 4
    la[6]="1SB01SB0" && 5
    la[7]="1SB0B01S" && 6
    la[8]="1SB0B0B0" && 7
    la[9]="B01S1S1S" && 8
    la[10]="B01S1SB0" && 9
    lcStart = "B0"  && Start
    lcStop = "1S1"  && Stop

    *-- Encode 0s and 1s
    lcRet = ""
    FOR lnI = 1 TO lnLen
      lcRet = lcRet + la(VAL(SUBSTR(THIS.cTextValue, lnI, 1)) + 1)
    ENDFOR
    *-- Add Start and Stop and apply ratio
    RETURN THIS.ApplyRatio(lcStart + lcRet + lcStop, THIS.nRatio)

  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Cod_11
  *------------------------------------------------------
  * Generate bar code 11
  *------------------------------------------------------
  PROCEDURE Cod_11()

    LOCAL lnI, lnJ, lcRet, lcStart, lcStop, lnLen, lcValid, lnSum, lnCon

    *-- Numbers only
    lcValid = "1234567890-"
    IF NOT CHRTRAN(THIS.cTextValue,CHRTRAN(THIS.cTextValue,lcValid,""),"") == THIS.cTextValue
      *-- Chars not valid
      THIS.cMsgError = "The Code 11 accepts only numeric characters and - (Dash)."
      RETURN NULL
    ENDIF
    lnLen = LEN(THIS.cTextValue)

    *-- Calculate and add the check digit (C)
    IF THIS.lAddCheckDigit
      lnSum = 0
      lnCon = 1
      FOR lnI = lnLen TO 1 STEP -1
        IF ISDIGIT(SUBSTR(THIS.cTextValue, lnI, 1))
          lnSum = lnSum + VAL(SUBSTR(THIS.cTextValue, lnI, 1)) * lnCon
        ELSE
          lnSum = lnSum + (10 * lnCon)
        ENDIF
        lnCon = lnCon + 1
        IF lnCon > 10
          lnCon = 1
        ENDIF
      ENDFOR

      THIS.cTextValue = THIS.cTextValue + IIF(TRANSFORM(MOD(lnSum, 11)) = "10", "-", TRANSFORM(MOD(lnSum, 11)))
      lnLen = LEN(THIS.cTextValue)

      *-- Second check digit (K)
      IF lnLen > 10
        lnSum = 0
        lnCon = 1
        FOR lnI = lnLen TO 1 STEP -1
          IF ISDIGIT(SUBSTR(THIS.cTextValue, lnI, 1))
            lnSum = lnSum + VAL(SUBSTR(THIS.cTextValue, lnI, 1)) * lnCon
          ELSE
            lnSum = lnSum + (10 * lnCon)
          ENDIF
          lnCon = lnCon + 1
          IF lnCon > 9
            lnCon = 1
          ENDIF
        ENDFOR

        THIS.cTextValue = THIS.cTextValue + IIF(TRANSFORM(MOD(lnSum, 11)) = "10", "-", TRANSFORM(MOD(lnSum, 11)))
        lnLen = LEN(THIS.cTextValue)

      ENDIF
      IF THIS.lShowCheckDigit
        THIS.cHumanReadableText = THIS.cTextValue
      ENDIF
      lnLen = LEN(THIS.cTextValue)
    ENDIF

    LOCAL ARRAY la[11]
    *-- Coding of each character
    la[1] = "1010110" && 0
    la[2] = "11010110" && 1
    la[3] = "10010110" && 2
    la[4] = "11001010" && 3
    la[5] = "10110110" && 4
    la[6] = "11011010" && 5
    la[7] = "10011010" && 6
    la[8] = "10100110" && 7
    la[9] = "11010010" && 8
    la[10] = "1101010" && 9
    la[11] = "1011010" && -
    lcStart = "10110010"  && Start
    lcStop = "1011001"  && Stop

    *-- Encode 0s and 1s
    lcRet = ""
    FOR lnI = 1 TO lnLen
      IF ISDIGIT(SUBSTR(THIS.cTextValue, lnI, 1))
        lcRet = lcRet + la(VAL(SUBSTR(THIS.cTextValue, lnI, 1)) + 1)
      ELSE
        lcRet = lcRet + la[11]  && -
      ENDIF
    ENDFOR
    *-- Add Start and Stop
    RETURN lcStart + lcRet + lcStop

  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Cod_PostNet()
  *------------------------------------------------------
  * Generate PostNet barcode
  *------------------------------------------------------
  FUNCTION Cod_PostNet()
    LOCAL lnI, lcValid, lcRet, lnControl, lcCheck

    lcValid = "1234567890"
    IF NOT CHRTRAN(THIS.cTextValue,CHRTRAN(THIS.cTextValue,lcValid,""),"") == THIS.cTextValue
      *-- Chars or lenght not valid
      THIS.cMsgError = "The PostNet code accepts only numeric characters."
      RETURN NULL
    ENDIF

    IF LEN(THIS.cTextValue) # 5 AND LEN(THIS.cTextValue) # 9 AND LEN(THIS.cTextValue) # 11
      *-- Chars or lenght not valid
      THIS.cMsgError = "PostNet: The length of the string must be 5,9,11"
      RETURN NULL
    ENDIF

    lnControl = 0
    FOR lnI = 1 TO LEN(THIS.cTextValue)
      lnControl = lnControl + VAL(SUBSTR(THIS.cTextValue, lnI, 1))
    ENDFOR

    lcCheck = TRANSFORM(MOD(10 - MOD(lnControl, 10), 10))

    *--
    THIS.cTextValue = THIS.cTextValue + lcCheck
    THIS.cHumanReadableText = ""

    LOCAL ARRAY laA(10)
    *-- Left Set
    laA[1] ="2020101010"   && 0
    laA[2] ="1010102020"   && 1
    laA[3] ="1010201020"   && 2
    laA[4] ="1010202010"   && 3
    laA[5] ="1020101020"   && 4
    laA[6] ="1020102010"   && 5
    laA[7] ="1020201010"   && 6
    laA[8] ="2010101020"   && 7
    laA[9] ="2010102010"   && 8
    laA[10]="2010201010"   && 9

    lcRet = "20"

    FOR lnI = 1 TO LEN(THIS.cTextValue)
      lcRet = lcRet + laA(VAL(SUBSTR(THIS.cTextValue, lnI, 1 )) + 1)
    ENDFOR

    RETURN lcRet + "2"

  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Cod_Telepen()
  *------------------------------------------------------
  * Generate Code Telepen
  *------------------------------------------------------
  PROCEDURE Cod_Telepen()

    LOCAL lcRet, lnLen, lnSum, lnAsc, lcStart, lcStop, laTelepen, nlControl, lcDigit

    IF NOT THIS.ValidAscii(THIS.cTextValue,0,127)
      *-- Chars not valid
      THIS.cMsgError = "Invalid character for Telepen code."
      RETURN NULL
    ENDIF

    lnLen = LEN(THIS.cTextValue)

    lcDigit = "1234567890"
    IF CHRTRAN(THIS.cTextValue,CHRTRAN(THIS.cTextValue,lcDigit,""),"") == THIS.cTextValue AND MOD(lnLen, 2) = 0
      lcDigit = .T.
    ELSE
      lcDigit = .F.
    ENDIF

    LOCAL ARRAY laTelepen[128]
    laTelepen(1) = "B0B0B0B0"
    laTelepen(2) = "10B0B0B010"
    laTelepen(3) = "BSB0B010"
    laTelepen(4) = "1010B0B0B0"
    laTelepen(5) = "B010B0B010"
    laTelepen(6) = "10BSB0B0"
    laTelepen(7) = "1S1SB0B0"
    laTelepen(8) = "101010B0B010"
    laTelepen(9) = "B0BSB010"
    laTelepen(10) = "10B010B0B0"
    laTelepen(11) = "BS10B0B0"
    laTelepen(12) = "1010BSB010"
    laTelepen(13) = "B01010B0B0"
    laTelepen(14) = "101S1SB010"
    laTelepen(15) = "1S101SB010"
    laTelepen(16) = "10101010B0B0"
    laTelepen(17) = "B0B010B010"
    laTelepen(18) = "10B0BSB0"
    laTelepen(19) = "BSBSB0"
    laTelepen(20) = "1010B010B010"
    laTelepen(21) = "B010BSB0"
    laTelepen(22) = "10BS10B010"
    laTelepen(23) = "1S1S10B010"
    laTelepen(24) = "101010BSB0"
    laTelepen(25) = "B01S1SB0"
    laTelepen(26) = "10B01010B010"
    laTelepen(27) = "BS1010B010"
    laTelepen(28) = "10101S1SB0"
    laTelepen(29) = "B0101010B010"
    laTelepen(30) = "101S101SB0"
    laTelepen(31) = "1S10101SB0"
    laTelepen(32) = "1010101010B010"
    laTelepen(33) = "B0B0BS10"
    laTelepen(34) = "10B0B010B0"
    laTelepen(35) = "BSB010B0"
    laTelepen(36) = "1010B0BS10"
    laTelepen(37) = "B010B010B0"
    laTelepen(38) = "10BSBS10"
    laTelepen(39) = "1S1SBS10"
    laTelepen(40) = "101010B010B0"
    laTelepen(41) = "B0BS10B0"
    laTelepen(42) = "10B010BS10"
    laTelepen(43) = "BS10BS10"
    laTelepen(44) = "1010BS10B0"
    laTelepen(45) = "B01010BS10"
    laTelepen(46) = "101S1S10B0"
    laTelepen(47) = "1S101S10B0"
    laTelepen(48) = "10101010BS10"
    laTelepen(49) = "B0B01010B0"
    laTelepen(50) = "10B01S1S10"
    laTelepen(51) = "BS1S1S10"
    laTelepen(52) = "1010B01010B0"
    laTelepen(53) = "B0101S1S10"
    laTelepen(54) = "10BS1010B0"
    laTelepen(55) = "1S1S1010B0"
    laTelepen(56) = "1010101S1S10"
    laTelepen(57) = "B01S101S10"
    laTelepen(58) = "10B0101010B0"
    laTelepen(59) = "BS101010B0"
    laTelepen(60) = "10101S101S10"
    laTelepen(61) = "B010101010B0"
    laTelepen(62) = "101S10101S10"
    laTelepen(63) = "1S1010101S10"
    laTelepen(64) = "101010101010B0"
    laTelepen(65) = "B0B0B01010"
    laTelepen(66) = "10B0B0BS"
    laTelepen(67) = "BSB0BS"
    laTelepen(68) = "1010B0B01010"
    laTelepen(69) = "B010B0BS"
    laTelepen(70) = "10BSB01010"
    laTelepen(71) = "1S1SB01010"
    laTelepen(72) = "101010B0BS"
    laTelepen(73) = "B0BSBS"
    laTelepen(74) = "10B010B01010"
    laTelepen(75) = "BS10B01010"
    laTelepen(76) = "1010BSBS"
    laTelepen(77) = "B01010B01010"
    laTelepen(78) = "101S1SBS"
    laTelepen(79) = "1S101SBS"
    laTelepen(80) = "10101010B01010"
    laTelepen(81) = "B0B010BS"
    laTelepen(82) = "10B0BS1010"
    laTelepen(83) = "BSBS1010"
    laTelepen(84) = "1010B010BS"
    laTelepen(85) = "B010BS1010"
    laTelepen(86) = "10BS10BS"
    laTelepen(87) = "1S1S10BS"
    laTelepen(88) = "101010BS1010"
    laTelepen(89) = "B01S1S1010"
    laTelepen(90) = "10B01010BS"
    laTelepen(91) = "BS1010BS"
    laTelepen(92) = "10101S1S1010"
    laTelepen(93) = "B0101010BS"
    laTelepen(94) = "101S101S1010"
    laTelepen(95) = "1S10101S1010"
    laTelepen(96) = "1010101010BS"
    laTelepen(97) = "B0B01S1S"
    laTelepen(98) = "10B0B0101010"
    laTelepen(99) = "BSB0101010"
    laTelepen(100) = "1010B01S1S"
    laTelepen(101) = "B010B0101010"
    laTelepen(102) = "10BS1S1S"
    laTelepen(103) = "1S1S1S1S"
    laTelepen(104) = "101010B0101010"
    laTelepen(105) = "B0BS101010"
    laTelepen(106) = "10B0101S1S"
    laTelepen(107) = "BS101S1S"
    laTelepen(108) = "1010BS101010"
    laTelepen(109) = "B010101S1S"
    laTelepen(110) = "101S1S101010"
    laTelepen(111) = "1S101S101010"
    laTelepen(112) = "101010101S1S"
    laTelepen(113) = "B0B010101010"
    laTelepen(114) = "10B01S101S"
    laTelepen(115) = "BS1S101S"
    laTelepen(116) = "1010B010101010"
    laTelepen(117) = "B0101S101S"
    laTelepen(118) = "10BS10101010"
    laTelepen(119) = "1S1S10101010"
    laTelepen(120) = "1010101S101S"
    laTelepen(121) = "B01S10101S"
    laTelepen(122) = "10B01010101010"
    laTelepen(123) = "BS1010101010"
    laTelepen(124) = "10101S10101S"
    laTelepen(125) = "B0101010101010"
    laTelepen(126) = "101S1010101S"
    laTelepen(127) = "1S101010101S"
    laTelepen(128) = "1010101010101010"    && DEL

    lnLen = LEN(THIS.cTextValue)

    *-- Always calculates the check digit
    lnSum = 0
    IF lcDigit
      FOR ln = 1 TO lnLen STEP 2
        lnSum = lnSum + (VAL(SUBSTR(THIS.cTextValue, ln, 2)) + 27)
      ENDFOR
    ELSE
      FOR ln = 1 TO lnLen
        lnSum = lnSum + (ASC(SUBSTR(THIS.cTextValue, ln, 1)))
      ENDFOR
    ENDIF

    lnControl = IIF(MOD(lnSum, 127) > 0, MOD(lnSum, 127), MOD(lnSum, 127) * -1)

    lnLen = LEN(THIS.cTextValue)

    *-- Encode 0s and 1s
    lcRet = ""
    IF lcDigit
      lcStart = "1010101011101000"  && Según GBG
      lcStop =  "1110100010101010"  && Según GBG
      FOR ln = 1 TO lnLen STEP 2
        lcRet = lcRet + laTelepen(VAL(SUBSTR(THIS.cTextValue, ln, 2)) + 27 + 1)
      ENDFOR
      lcRet = lcRet + laTelepen(127 - lnControl + 1)
    ELSE
      lcStart = laTelepen(ASC("_") + 1)
      lcStop = SUBSTR(laTelepen(ASC("z") + 1), 1, 15)
      THIS.cTextValue = THIS.cTextValue + CHR(127 - lnControl)
      lnLen = LEN(THIS.cTextValue)
      FOR ln = 1 TO lnLen
        lcRet = lcRet + laTelepen(ASC(SUBSTR(THIS.cTextValue, ln, 1)) + 1)
      ENDFOR
    ENDIF

    *-- Add Start and Stop and apply ratio
    RETURN THIS.ApplyRatio(lcStart + lcRet + lcStop, THIS.nRatio)

  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Cod_Sup5()
  *------------------------------------------------------
  * Generate UPC/EAN Supplemental 5
  *------------------------------------------------------
  FUNCTION Cod_Sup5()
    LOCAL lnI, lcValid, lcStart, lcRet, lcControl

    lcValid = "1234567890"
    IF NOT CHRTRAN(THIS.cSupplementalText,CHRTRAN(THIS.cSupplementalText,lcValid,""),"") == THIS.cSupplementalText
      *-- Chars or lenght not valid
      THIS.cMsgError = "The Supplemental 5 code accepts only numeric characters."
      RETURN NULL
    ENDIF

    *--
    THIS.cSupplementalText = PADL(THIS.cSupplementalText, 5, "0")
    * THIS.cHumanReadableText = THIS.cSupplementalText

    LOCAL ARRAY laA(10), laB(10), laParity(10)
    laParity(1) ="EEOOO"
    laParity(2) ="EOEOO"
    laParity(3) ="EOOEO"
    laParity(4) ="EOOOE"
    laParity(5) ="OEEOO"
    laParity(6) ="OOEEO"
    laParity(7) ="OOOEE"
    laParity(8) ="OEOEO"
    laParity(9) ="OEOOE"
    laParity(10)="OOEOE"

    lcControl = RIGHT(STR(VAL(SUBSTR( THIS.cSupplementalText, 1, 1 )) * 3 + VAL(SUBSTR(THIS.cSupplementalText, 3, 1 )) * 3 + ;
      VAL(SUBSTR(THIS.cSupplementalText, 5, 1 )) * 3 + VAL(SUBSTR(THIS.cSupplementalText, 2, 1 )) * 9 + ;
      VAL(SUBSTR(THIS.cSupplementalText, 4, 1 )) * 9, 5, 0 ), 1 )

    lcControl = laParity(VAL(lcControl) + 1)

    *-- Left Set
    laA[1] ="0001101"   && 0
    laA[2] ="0011001"   && 1
    laA[3] ="0010011"   && 2
    laA[4] ="0111101"   && 3
    laA[5] ="0100011"   && 4
    laA[6] ="0110001"   && 5
    laA[7] ="0101111"   && 6
    laA[8] ="0111011"   && 7
    laA[9] ="0110111"   && 8
    laA[10]="0001011"   && 9

    *-- Right Set
    laB[1] ="0100111"   && 0
    laB[2] ="0110011"   && 1
    laB[3] ="0011011"   && 2
    laB[4] ="0100001"   && 3
    laB[5] ="0011101"   && 4
    laB[6] ="0111001"   && 5
    laB[7] ="0000101"   && 6
    laB[8] ="0010001"   && 7
    laB[9] ="0001001"   && 8
    laB[10]="0010111"   && 9

    lcStart = "1011"

    lcRet = lcStart

    FOR lnI = 1 TO 5
      IF SUBSTR(lcControl, lnI, 1 ) = "O"
        lcRet = lcRet + laA(VAL(SUBSTR(THIS.cSupplementalText, lnI, 1 )) + 1)
      ELSE
        lcRet = lcRet + laB(VAL(SUBSTR(THIS.cSupplementalText, lnI, 1 )) + 1)
      ENDIF
      IF lnI < 5
        lcRet = lcRet + "01"
      ENDIF
    ENDFOR

    RETURN lcRet

  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Cod_Sup2()
  *------------------------------------------------------
  * Generate UPC/EAN Supplemental 2
  *------------------------------------------------------
  FUNCTION Cod_Sup2()
    LOCAL lnI, lcValid, lcStart, lcRet, lcControl

    lcValid = "1234567890"
    IF NOT CHRTRAN(THIS.cSupplementalText,CHRTRAN(THIS.cSupplementalText,lcValid,""),"") == THIS.cSupplementalText
      *-- Chars or lenght not valid
      THIS.cMsgError = "The Supplemental 2 code accepts only numeric characters."
      RETURN NULL
    ENDIF

    *--
    THIS.cSupplementalText = PADL(THIS.cSupplementalText, 2, "0")
    *  THIS.cHumanReadableText = THIS.cTextValue

    LOCAL ARRAY laA(10), laB(10), laParity(4)
    laParity(1) = "OO"
    laParity(2) = "OE"
    laParity(3) = "EO"
    laParity(4) = "EE"

    lcControl = laParity(MOD(VAL(THIS.cSupplementalText), 4) + 1)

    *-- Left Set
    laA[1] ="0001101"   && 0
    laA[2] ="0011001"   && 1
    laA[3] ="0010011"   && 2
    laA[4] ="0111101"   && 3
    laA[5] ="0100011"   && 4
    laA[6] ="0110001"   && 5
    laA[7] ="0101111"   && 6
    laA[8] ="0111011"   && 7
    laA[9] ="0110111"   && 8
    laA[10]="0001011"   && 9

    *-- Right Set
    laB[1] ="0100111"   && 0
    laB[2] ="0110011"   && 1
    laB[3] ="0011011"   && 2
    laB[4] ="0100001"   && 3
    laB[5] ="0011101"   && 4
    laB[6] ="0111001"   && 5
    laB[7] ="0000101"   && 6
    laB[8] ="0010001"   && 7
    laB[9] ="0001001"   && 8
    laB[10]="0010111"   && 9

    lcStart = "1011"
    lcRet = lcStart

    FOR lnI = 1 TO 2
      IF SUBSTR(lcControl, lnI, 1 ) = "O"
        lcRet = lcRet + laA(VAL(SUBSTR(THIS.cSupplementalText, lnI, 1 )) + 1)
      ELSE
        lcRet = lcRet + laB(VAL(SUBSTR(THIS.cSupplementalText, lnI, 1 )) + 1)
      ENDIF
      IF lnI = 1
        lcRet = lcRet + "01"
      ENDIF
    ENDFOR

    RETURN lcRet

  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Cod_Ean128()
  *------------------------------------------------------
  * Generate EAN/UCC/GS1 128 bar code
  *------------------------------------------------------
  PROCEDURE Cod_Ean128()

    IF NOT THIS.ValidAscii(THIS.cTextValue,0,127)
      *-- Chars not valid
      THIS.cMsgError = "Invalid characters for EAN/UCC 128."
      RETURN NULL
    ENDIF

    *-- Special characters
    #DEFINE FBC_SHIFT CHR(98 + 32)
    #DEFINE FBC_CODEC CHR(99 + 32)
    #DEFINE FBC_CODEB CHR(100 + 32)
    #DEFINE FBC_CODEA CHR(101 + 32)
    #DEFINE FBC_FNC1 CHR(102 + 32)

    *-- Use Application Identifiers. Ex (15)101130
    IF THIS.lUseAppId
      *-- Replacement parentheses
      THIS.cTextValue = CHRTRAN(THIS.cTextValue, "()", FBC_FNC1 )
    ENDIF

    *-- Add FNC1 if necessary
    IF LEFT(THIS.cTextValue,1) <> FBC_FNC1
      THIS.cTextValue = FBC_FNC1 + THIS.cTextValue
    ENDIF

    *-- Current Set
    LOCAL lnSum, lcStart, lcStop, lnLen, lcRet
    IF THIS.IsNumeric(SUBSTR(THIS.cTextValue,2,4))
      lcCurrentSet = "C"
      lnSum = 105 && C
    ELSE
      IF THIS.ValidAscii(THIS.cTextValue,32,134)
        lcCurrentSet = "B"
        lnSum = 104 && B
      ELSE
        lcCurrentSet = "A"
        lnSum = 103 && A
      ENDIF
    ENDIF

    *-- Check all string
    LOCAL lcPar, lcStr, ln
    STORE "" TO lcStr, lcPar
    FOR ln = 1 TO LEN(THIS.cTextValue)
      lcPar = lcPar + SUBSTR(THIS.cTextValue,ln,1)
      IF LEN(lcPar) = 1
        IF INLIST(lcPar, FBC_FNC1, FBC_SHIFT, FBC_CODEC, FBC_CODEB, FBC_CODEA)
          *-- Control code
          lcStr = lcStr + lcPar
        ELSE  && INLIST(...
          IF ISDIGIT(lcPar) AND ln < LEN(THIS.cTextValue)
            LOOP
          ELSE && ISDIGIT(lcPar)
            IF lcCurrentSet = "C"
              IF THIS.ValidAscii(SUBSTR(THIS.cTextValue,ln),32,134) && The rest
                lcCurrentSet = "B"
                lcStr = lcStr + FBC_CODEB + lcPar
              ELSE && THIS.ValidAscii(
                lcCurrentSet = "A"
                lcStr = lcStr + FBC_CODEA + lcPar
              ENDIF && THIS.ValidAscii(
            ELSE && lcCurrentSet = "C"
              lcStr = lcStr + lcPar
            ENDIF && lcCurrentSet = "C"
          ENDIF && ISDIGIT(lcPar)
        ENDIF  && INLIST(...
      ELSE && LEN(lcPar) = 1
        IF THIS.IsNumeric(lcPar)
          IF lcCurrentSet = "C"
            lcStr = lcStr + THIS.Pair2Char(lcPar)
          ELSE && lcCurrentSet = "C"
            lcCurrentSet = "C"
            lcStr = lcStr + FBC_CODEC + THIS.Pair2Char(lcPar)
          ENDIF && lcCurrentSet = "C"
        ELSE && THIS.IsNumeric(lcPar)
          *-- 1st. is digit
          IF lcCurrentSet = "C"
            IF THIS.ValidAscii(SUBSTR(THIS.cTextValue,ln),32,134) && The rest
              lcCurrentSet = "B"
              lcStr = lcStr + FBC_CODEB + lcPar
            ELSE && THIS.ValidAscii(
              lcCurrentSet = "A"
              lcStr = lcStr + FBC_CODEA + lcPar
            ENDIF && THIS.ValidAscii(
          ELSE && lcCurrentSet = "C"
            lcStr = lcStr + lcPar
          ENDIF && lcCurrentSet = "C"
        ENDIF &&  && THIS.IsNumeric(lcPar)
      ENDIF && LEN(lcPar) = 1
      lcPar = ""
    ENDFOR

    THIS.cTextValue = lcStr

    LOCAL ARRAY laEan128[106]
    laEan128[1] = "11011001100"
    laEan128[2] = "11001101100"
    laEan128[3] = "11001100110"
    laEan128[4] = "10010011000"
    laEan128[5] = "10010001100"
    laEan128[6] = "10001001100"
    laEan128[7] = "10011001000"
    laEan128[8] = "10011000100"
    laEan128[9] = "10001100100"
    laEan128[10] = "11001001000"
    laEan128[11] = "11001000100"
    laEan128[12] = "11000100100"
    laEan128[13] = "10110011100"
    laEan128[14] = "10011011100"
    laEan128[15] = "10011001110"
    laEan128[16] = "10111001100"
    laEan128[17] = "10011101100"
    laEan128[18] = "10011100110"
    laEan128[19] = "11001110010"
    laEan128[20] = "11001011100"
    laEan128[21] = "11001001110"
    laEan128[22] = "11011100100"
    laEan128[23] = "11001110100"
    laEan128[24] = "11101101110"
    laEan128[25] = "11101001100"
    laEan128[26] = "11100101100"
    laEan128[27] = "11100100110"
    laEan128[28] = "11101100100"
    laEan128[29] = "11100110100"
    laEan128[30] = "11100110010"
    laEan128[31] = "11011011000"
    laEan128[32] = "11011000110"
    laEan128[33] = "11000110110"
    laEan128[34] = "10100011000"
    laEan128[35] = "10001011000"
    laEan128[36] = "10001000110"
    laEan128[37] = "10110001000"
    laEan128[38] = "10001101000"
    laEan128[39] = "10001100010"
    laEan128[40] = "11010001000"
    laEan128[41] = "11000101000"
    laEan128[42] = "11000100010"
    laEan128[43] = "10110111000"
    laEan128[44] = "10110001110"
    laEan128[45] = "10001101110"
    laEan128[46] = "10111011000"
    laEan128[47] = "10111000110"
    laEan128[48] = "10001110110"
    laEan128[49] = "11101110110"
    laEan128[50] = "11010001110"
    laEan128[51] = "11000101110"
    laEan128[52] = "11011101000"
    laEan128[53] = "11011100010"
    laEan128[54] = "11011101110"
    laEan128[55] = "11101011000"
    laEan128[56] = "11101000110"
    laEan128[57] = "11100010110"
    laEan128[58] = "11101101000"
    laEan128[59] = "11101100010"
    laEan128[60] = "11100011010"
    laEan128[61] = "11101111010"
    laEan128[62] = "11001000010"
    laEan128[63] = "11110001010"
    laEan128[64] = "10100110000"
    laEan128[65] = "10100001100"
    laEan128[66] = "10010110000"
    laEan128[67] = "10010000110"
    laEan128[68] = "10000101100"
    laEan128[69] = "10000100110"
    laEan128[70] = "10110010000"
    laEan128[71] = "10110000100"
    laEan128[72] = "10011010000"
    laEan128[73] = "10011000010"
    laEan128[74] = "10000110100"
    laEan128[75] = "10000110010"
    laEan128[76] = "11000010010"
    laEan128[77] = "11001010000"
    laEan128[78] = "11110111010"
    laEan128[79] = "11000010100"
    laEan128[80] = "10001111010"
    laEan128[81] = "10100111100"
    laEan128[82] = "10010111100"
    laEan128[83] = "10010011110"
    laEan128[84] = "10111100100"
    laEan128[85] = "10011110100"
    laEan128[86] = "10011110010"
    laEan128[87] = "11110100100"
    laEan128[88] = "11110010100"
    laEan128[89] = "11110010010"
    laEan128[90] = "11011011110"
    laEan128[91] = "11011110110"
    laEan128[92] = "11110110110"
    laEan128[93] = "10101111000"
    laEan128[94] = "10100011110"
    laEan128[95] = "10001011110"
    laEan128[96] = "10111101000" && DEL
    laEan128[97] = "10111100010" && FNC3
    laEan128[98] = "11110101000" && FNC2
    laEan128[99] = "11110100010" && Shift
    laEan128[100] = "10111011110" &&      / Code C
    laEan128[101] = "10111101110" && FNC4 / Code B
    laEan128[102] = "11101011110" &&      / Code A
    laEan128[103] = "11110101110" && FNC1
    laEan128[104] = "11010000100" && Start A
    laEan128[105] = "11010010000" && Start B
    laEan128[106] = "11010011100" && Start C

    lcStart = laEan128(lnSum + 1)
    lcStop = "1100011101011" && Stop

    *-- Always calculates the check digit
    FOR ln = 1 TO LEN(THIS.cTextValue)
      lnSum = lnSum + (ASC(SUBSTR(THIS.cTextValue, ln, 1)) - 32) * ln
    ENDFOR
    THIS.cTextValue = THIS.cTextValue + CHR(MOD(lnSum,103) + 32)
    lnLen = LEN(THIS.cTextValue)

    *-- Encode 0s and 1s
    lcRet = ""
    FOR ln = 1 TO lnLen
      lcRet = lcRet + laEan128(ASC(SUBSTR(THIS.cTextValue, ln, 1)) - 32 + 1)
    ENDFOR

    *-- Add Start and Stop
    RETURN lcStart + lcRet + lcStop

  ENDPROC

  *------------------------------------------------------
  * PROCEDURE nFactor_Assign
  *------------------------------------------------------
  * Assign method
  *------------------------------------------------------
  PROCEDURE nFactor_Assign(tnValue)
    THIS.nFactor = tnValue
    THIS.nFontHeight = THIS.nFactor * (THIS.nFontSize / THIS.nResolution) * 100
    THIS.nTextHeight = (THIS.nFontSize + 6 ) * THIS.nFactor
  ENDPROC

  *------------------------------------------------------
  * PROCEDURE nResolution_Assign
  *------------------------------------------------------
  * Assign method
  *------------------------------------------------------
  PROCEDURE nResolution_Assign(tnValue)
    THIS.nResolution = tnValue
    THIS.nFontHeight = THIS.nFactor * (THIS.nFontSize / THIS.nResolution) * 100
    THIS.nTextHeight = (THIS.nFontSize + 6 ) * THIS.nFactor
  ENDPROC

  *------------------------------------------------------
  * PROCEDURE nFontSize_Assign(tnValue)
  *------------------------------------------------------
  * Assign method
  *------------------------------------------------------
  PROCEDURE nFontSize_Assign(tnValue)
    THIS.nFontSize = tnValue
    THIS.nFontHeight = THIS.nFactor * (THIS.nFontSize / THIS.nResolution) * 100
    THIS.nTextHeight = (THIS.nFontSize + 6 ) * THIS.nFactor
  ENDPROC

  *------------------------------------------------------
  * PROCEDURE lFontBold_Assign(tlValue)
  *------------------------------------------------------
  * Assign method
  *------------------------------------------------------
  PROCEDURE lFontBold_Assign(tlValue)
    THIS.lFontBold = tlValue
    THIS.cFontStyle = IIF(THIS.lFontBold, "B", "N") + IIF(THIS.lFontItalic, "I", "")
  ENDPROC

  *------------------------------------------------------
  * PROCEDURE lFontItalic_Assign(tlValue)
  *------------------------------------------------------
  * Assign method
  *------------------------------------------------------
  PROCEDURE lFontItalic_Assign(tlValue)
    THIS.lFontItalic = tlValue
    THIS.cFontStyle = IIF(THIS.lFontBold, "B", "N") + IIF(THIS.lFontItalic, "I", "")
  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Init()
  *------------------------------------------------------
  PROCEDURE INIT()
    THIS.cTempPath = ADDBS(THIS.TempPath() + SYS(2015))
  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Destroy()
  *------------------------------------------------------
  PROCEDURE DESTROY()
    THIS.EmptyFolder(THIS.cTempPath)
    IF DIRECTORY(THIS.cTempPath)
      RD (THIS.cTempPath)
    ENDIF
  ENDPROC

  *---------------------------------------------------------
  * PROCEDURE ResetProperties()
  *---------------------------------------------------------
  * Reset to default properties
  *---------------------------------------------------------
  PROCEDURE ResetProperties()
    LOCAL lo, ln, la(1), lcProp
    lo = CREATEOBJECT("FoxBarcode")
    FOR ln = 1 TO AMEMBERS(la, lo)
      lcProp = "This." + la(ln)
      IF PEMSTATUS(lo,la(ln),4) AND ;
          PEMSTATUS(lo,la(ln),3) = "Property" AND ;
          NOT PEMSTATUS(lo,la(ln),2) AND ;
          TYPE(lcProp) $ "NLC" AND ;
          NOT INLIST(UPPER(la(ln)),"CTEMPPATH") && ,"CIMAGEFILE")
        &lcProp = EVALUATE("lo." + la(ln))
      ENDIF
    ENDFOR
    lo = NULL
  ENDPROC

  *---------------------------------------------------------
  * PROCEDURE BarcodeCopyToClipboard()
  *---------------------------------------------------------
  * Copy barcode image to clipboard
  *---------------------------------------------------------
  PROCEDURE BarcodeCopyToClipboard()
    LOCAL loGDIP, loImageCopy
    loGDIP = CREATEOBJECT("gpInit")
    loImgCopy = CREATEOBJECT("gpImage2")
    loImgCopy.LOAD(THIS.cImageFile)
    loImgCopy.ToClipboard()
    RETURN IIF(FILE(THIS.cImageFile), .T., .F.)
  ENDPROC

  *------------------------------------------------------

  **********************
  *** Common methods ***
  **********************

  *------------------------------------------------------
  * PROCEDURE CheckDigitEan(tcText)
  *------------------------------------------------------
  * Calculates check digit for EAN, UPC and I2of5
  *------------------------------------------------------
  PROCEDURE CheckDigitEan(tcText)
    LOCAL lnSum, lnI, lnJ
    STORE 0 TO lnSum, lnJ
    FOR lnI = LEN(tcText) TO 1 STEP -1
      lnJ = lnJ + 1
      lnSum = lnSum + (VAL(SUBSTR(tcText, lnI, 1)) * IIF(MOD(lnJ, 2) = 0, 1, 3))
    ENDFOR
    RETURN TRANSFORM(MOD(10 - MOD(lnSum, 10), 10))
  ENDPROC

  *------------------------------------------------------
  * PROCEDURE AddSpace(tcText, tnSpaces)
  *------------------------------------------------------
  * Add n spaces between each character
  *------------------------------------------------------
  PROCEDURE AddSpace(tcText, tnSpaces)
    LOCAL lc, ln, lnLen
    IF EMPTY(tnSpaces)
      tnSpaces = 1
    ENDIF
    lc = ""
    lnLen = LEN(tcText)
    FOR ln = 1 TO lnLen
      lc = lc + SUBSTR(tcText, ln, 1) + IIF(ln = lnLen, SPACE(0), SPACE(tnSpaces))
    ENDFOR
    RETURN lc
  ENDPROC

  *------------------------------------------------------
  * PROCEDURE ValidAscii(tcText, tn1, tn2)
  *------------------------------------------------------
  * Valid each character Ascii
  *------------------------------------------------------
  PROCEDURE ValidAscii(tcText, tn1, tn2)
    LOCAL lnI, lnRet
    lnRet = .T.
    FOR lnI = 1 TO LEN(tcText)
      IF NOT BETWEEN(ASC(SUBSTR(tcText,lnI,1)),tn1,tn2)
        lnRet = .F.
        EXIT
      ENDIF
    ENDFOR
    RETURN lnRet
  ENDPROC

  *------------------------------------------------------
  * PROCEDURE ApplyRatio(tcEncoded, tnRatio)
  *------------------------------------------------------
  * Apply ratio between bar
  *------------------------------------------------------
  PROCEDURE ApplyRatio(tcEncoded, tnRatio)
    LOCAL lcRet
    tcEncoded = STRTRAN(tcEncoded, "B", REPLICATE("1", tnRatio))
    tcEncoded = STRTRAN(tcEncoded, "S", REPLICATE("0", tnRatio))
    RETURN tcEncoded
  ENDPROC

  *------------------------------------------------------
  * PROCEDURE EmptyFolder(tcFolder)
  *------------------------------------------------------
  * Empty temporary image folder
  *------------------------------------------------------
  PROCEDURE EmptyFolder(tcFolder)
    LOCAL loFso AS OBJECT
    DO CASE
      CASE EMPTY(tcFolder)
        RETURN .F.
      CASE NOT DIRECTORY(tcFolder)
        RETURN .F.
    ENDCASE
    loFso  = CREATEOBJECT("Scripting.FileSystemObject")
    lcMask = ADDBS(tcFolder)+"*.*"
    loFso.DeleteFile(lcMask, .T.)
    RETURN  .T.
  ENDPROC

  *---------------------------------------------------------
  * PROCEDURE DeleteFolder(pcFolder)
  *---------------------------------------------------------
  PROCEDURE DeleteFolder(pcFolder)
    LOCAL loFso AS OBJECT
    DO CASE
      CASE EMPTY(pcFolder)
        RETURN .F.
      CASE NOT DIRECTORY(pcFolder)
        RETURN .F.
    ENDCASE
    loFso  = CREATEOBJECT("Scripting.FileSystemObject")
    RETURN loFso.DeleteFolder(pcFolder)
  ENDPROC

  *---------------------------------------------------------
  * PROCEDURE TempPath()
  *---------------------------------------------------------
  * Returns the path for temporary files
  *---------------------------------------------------------
  PROCEDURE TempPath()
    LOCAL lcPath, lnRet
    lcPath = SPACE(255)
    lnSize = 255
    DECLARE INTEGER GetTempPath IN WIN32API ;
      INTEGER nBufSize, ;
      STRING @cPathName
    lnRet = GetTempPath(lnSize, @lcPath)
    IF lnRet <= 0
      lcPath = ADDBS(FULLPATH("TEMP"))
    ELSE
      lcPath = ADDBS(SUBSTR(lcPath, 1, lnRet))
    ENDIF
    RETURN lcPath
  ENDPROC

  *---------------------------------------------------------
  * PROCEDURE Pair2Char(tcPair)
  *---------------------------------------------------------
  * Convert the pairs of numbers to char
  *---------------------------------------------------------
  PROCEDURE Pair2Char(tcPair)
    LOCAL lcRet, ln
    lcRet = ""
    FOR ln = 1 TO LEN(tcPair) STEP 2
      lcRet = lcRet + CHR(VAL(SUBS(tcPair, ln, 2)) + 32)
    ENDFOR
    RETURN lcRet
  ENDPROC

  *---------------------------------------------------------
  * PROCEDURE IsNumeric(tcString)
  *---------------------------------------------------------
  * Valid all chars are numerics
  *---------------------------------------------------------
  PROCEDURE IsNumeric(tcString)
    RETURN EMPTY(CHRTRAN(tcString,"1234567890",""))
  ENDPROC

  *---------------------------------------------------------
  * PROCEDURE IsFontTrueType(tcFontName)
  *---------------------------------------------------------
  * Validates that the font is TrueType
  * Thanks to Koen Piller (Netherlands)
  *---------------------------------------------------------
  PROCEDURE IsFontTrueType(tcFontName)
    LOCAL lnPitchFamily, lnFP
    lnPitchFamily = FONTMETRIC(16,ALLTRIM(tcFontName),10)
    lnFP = BITAND(lnPitchFamily,0x0F)
    RETURN BITAND(lnFP,0x04) <> 0
  ENDPROC

  *---------------------------------------------------------
  * PROCEDURE IsGdipFont(tcFontName, tcFontStyle)
  *---------------------------------------------------------
  * Validates that the font and style are permitted by GDI+
  * Thanks to Cesar Chalom (Brazil)
  *---------------------------------------------------------
  PROCEDURE IsGdipFont(tcFontName, tcFontStyle)
    * The Gdi+ API declarations were "Aliased" to avoid problems
    * with other possible Gdi+ classes working at the same time

    * GDI+ Initialization and Shutdown
    DECLARE LONG GdiplusStartup IN GDIPLUS.DLL ;
      AS FBC_GdiplusStartup ;
      LONG @ token, STRING @ INPUT, LONG @ OUTPUT

    DECLARE LONG GdiplusShutdown IN GDIPLUS.DLL ;
      AS FBC_GdiplusShutdown ;
      LONG token

    * FontFamily functions
    DECLARE INTEGER GdipCreateFontFamilyFromName IN GDIPLUS.DLL ;
      AS FBC_GdipCreateFontFamilyFromName ;
      STRING FamilyName, INTEGER FontCollection, INTEGER @FontFamily

    DECLARE INTEGER GdipDeleteFontFamily IN GDIPLUS.DLL ;
      AS FBC_GdipDeleteFontFamily ;
      INTEGER FontFamily

    LOCAL lcStartupInput, lcGdipToken
    lcStartupInput = CHR(1) + REPLICATE(CHR(0), 15)	&& GdiplusStartupInput structure (sizeof = 16)
    * Initialize GDI+
    lcGdipToken = 0
    IF FBC_GdiplusStartup(@lcGdipToken, @lcStartupInput, 0) <> 0
      RETURN .F. && Could not initialize Gdi+
    ENDIF

    LOCAL lnStatus, lhFontFamily, llCanUse, lcFontName
    lhFontFamily = 0
    lcFontName   = THIS.Widestr(tcFontName)
    lnStatus = FBC_GdipCreateFontFamilyFromName(lcFontName, 0, @lhFontFamily)

    DECLARE INTEGER GdipIsStyleAvailable IN GDIPLUS.DLL ;
      AS FBC_GdipIsStyleAvailable ;
      INTEGER nFontFamily, INTEGER nStyle, INTEGER @bIsAvailable

    LOCAL lnAvailable, lnFontStyle
    lnAvailable = 0
    lnFontStyle = 0 + IIF("B" $ tcFontStyle, 1, 0) + IIF("I" $ tcFontStyle, 2, 0)

    *-- Add by VFPEncoding
    lnStatus = FBC_GdipIsStyleAvailable(lhFontFamily, lnFontStyle, @lnAvailable )

    llCanUse = lnAvailable <> 0
    IF llCanUse
      * Clear the Gdi+ FontFamily created
      lnStatus = FBC_GdipDeleteFontFamily(lhFontFamily)
    ENDIF
    * Clear the Gdi+ handle
    lnStatus = FBC_GdiplusShutdown(lcGdipToken)
    RETURN llCanUse
  ENDPROC

  *---------------------------------------------------------
  * PROTECTED FUNCTION WideStr(tcStr)
  *---------------------------------------------------------
  PROTECTED FUNCTION WideStr(tcStr)
    IF VERSION(5) >= 700
      RETURN STRCONV(tcStr + CHR(0), 5)
    ELSE
      LOCAL lnLen, lcWideStr
      lnLen = 2 * (LEN(tcStr) + 1)
      lcWideStr = REPLICATE(CHR(0), lnLen)
      DECLARE LONG MultiByteToWideChar IN kernel32 ;
        LONG iCodePage, LONG dwFlags, STRING @ lpStr, LONG iMultiByte, ;
        STRING @ lpWideStr, LONG iWideChar
      MultiByteToWideChar(0, 0, @tcStr, LEN(tcStr), @lcWideStr, lnLen)
      RETURN lcWideStr
    ENDIF
  ENDFUNC

  *---------------------------------------------------------

ENDDEFINE && FoxBarcode

*--------------------------------------------------------------------------------------
* END DEFINE FoxBarcode Class
*--------------------------------------------------------------------------------------
