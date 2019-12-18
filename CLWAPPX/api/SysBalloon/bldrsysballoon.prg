*!* ********************************************************************************
*!* Program     : BldrSysBalloon
*!* Author      : Jijo Pappachan
*!* Contact     : jijopappachan@gmail.com
*!* Date        : 12/29/09 09:44:14 AM
*!* Copyright   :
*!* Description : Main program for sysBalloon builder
*!* ********************************************************************************
Lparameters pcBldrType

Private nControls, oObject
Local Array aObjects[1]

nControls = Aselobj(aObjects)
oObject = aObjects(1)

If nControls = 0
	Return .F.
Endif

Do Case
	Case pcBldrType == "ICONTYPE"
		SeticonType()

	Case pcBldrType == "GETBELL"
		GetWavFile()

	Case pcBldrType == "BODYFONT"
		oObject.pcBalloonBodyFont = Evl(GetFontValue(oObject.pcBalloonBodyFont), oObject.pcBalloonBodyFont)

	Case pcBldrType == "ICONFILE"
		GetIconFile()

	Case pcBldrType == "CAPTIONCOLOR"
		GetCaptionColor()

	Case pcBldrType == "CAPTION"
		oObject.pcBalloonCaption = Evl(Inputbox("Caption:", "SysBalloon Builder", oObject.pcBalloonCaption), oObject.pcBalloonCaption)

	Case pcBldrType == "CAPTIONSTYLE"
		oObject.pcBalloonCaptionStyle = Evl(GetFontValue(oObject.pcBalloonCaptionStyle), oObject.pcBalloonCaptionStyle)

	Case pcBldrType == "BODYCOLOR"
		 GetBodyColor()
*!*		oObject.pcBalloonMessage = Evl(Inputbox("Message:", "SysBalloon Builder", oObject.pcBalloonMessage)

	Otherwise

Endcase

********************************************************************************
*!* Procedure : seticonType
*!* Comment   : Procedure to display/set available values for pcIconType property
********************************************************************************
Procedure SeticonType
	Local loForm As Form
	Private laValues, lnSelectedIndex
	Local lcReturn As String

	Dimension laValues[6, 2]

	lnSelectedIndex = 1

	laValues[1, 1] = [Custom]
	laValues[1, 2] = [CUSTOM]
	laValues[2, 1] = [Information]
	laValues[2, 2] = [INFO]
	laValues[3, 1] = [Warning]
	laValues[3, 2] = [WARN]
	laValues[4, 1] = [Stop]
	laValues[4, 2] = [HAND]
	laValues[5, 1] = [Question]
	laValues[5, 2] = [QUEST]
	laValues[6, 1] = [None]
	laValues[6, 2] = [NONE]

	lnSelectedIndex = Ascan(laValues, Alltrim(Upper(oObject.pcBalloonIconType)),1, Alen(laValues, 1), 2, 8)

	loForm = Createobject("frmGetvalues")
	loForm.Show(1)

	If Between(lnSelectedIndex, 1, 6)
		oObject.pcBalloonIconType = laValues[lnSelectedIndex, 2]
	Endif

Endproc

********************************************************************************
*!* Procedure : GetWavFile
*!* Comment   : Procedure to set value for pcBalloonBell property
********************************************************************************
Procedure GetWavFile
	lcWavFile = Getfile("Sounds:wav")

	If Not Empty(lcWavFile)
		oObject.pcBalloonBell = lcWavFile
	Endif
Endproc

********************************************************************************
*!* Procedure : GetFontValue
*!* Comment   :
********************************************************************************
Procedure GetFontValue(pcCurrentFont)
	Local lcFont As String
	Local lcCurrentFont As String
	Local lcFontName As String
	Local lnFontsize As Number
	Local lcFontStyle As String

	lcFontName = Evl(Getwordnum(pcCurrentFont, 1, ","), "Tahoma")
	lnFontsize = Evl(Val(Getwordnum(pcCurrentFont, 2, ",")), 8)
	lcFontStyle = Evl(Getwordnum(pcCurrentFont, 3, ","), "N")

	lcFont = Getfont(lcFontName, lnFontsize, lcFontStyle)

	Return lcFont
Endproc

********************************************************************************
*!* Procedure : GetIconFile
*!* Comment   :
********************************************************************************
Procedure GetIconFile()
	Local lcReturn As String

	lcReturn = Getpict()
	If Not Empty(lcReturn)
		oObject.pcBalloonIconFile = lcReturn
	Endif

Endproc

********************************************************************************
*!* Procedure : GetCaptionColor
*!* Comment   :
********************************************************************************
Procedure GetCaptionColor()
	Local lnReturn As Long

	lnReturn = Getcolor(oObject.pnBalloonCaptionColor)
	If lnReturn > -1
		oObject.pnBalloonCaptionColor= lnReturn
	Endif

Endproc

********************************************************************************
*!* Procedure : GetBodyColor
*!* Comment   :
********************************************************************************
Procedure GetBodyColor()
	Local lnReturn As Long

	lnReturn = Getcolor(oObject.pnBalloonBodyColor)
	If lnReturn > -1
		oObject.pnBalloonBodyColor = lnReturn
	Endif

Endproc

********************************************************************************
*!*                            END OF PROCEDURES
********************************************************************************
Define Class frmGetvalues As Form
	Add Object cmdOk As cmd
	Add Object cmdCancel As cmd
	Caption = "Select type"
	MaxButton = .F.
	MinButton = .F.
	BorderStyle = 2

	Procedure Init
		This.AddObject("lblCaption", "Label")
		This.AddObject("cboValues", "ComboBox")
		This.AddObject("shpBorder", "shp")

		This.lblCaption.Visible = .T.
		This.lblCaption.Caption = "Icon type:"
		This.lblCaption.AutoSize = .T.
		This.lblCaption.FontName = "Tahoma"
		This.lblCaption.FontSize = 8
		This.lblCaption.Top = 25
		This.lblCaption.Left = 25

		This.cboValues.Visible = .T.
		This.cboValues.RowSource = "laValues"
		This.cboValues.RowSourceType = 5
		This.cboValues.FontName = "Tahoma"
		This.cboValues.FontSize = 8
		This.cboValues.Top = 15
		This.cboValues.Width = 150
		This.cboValues.Left = This.lblCaption.Left + This.lblCaption.Width + 10
		This.cboValues.Style = 2
		This.cboValues.ListIndex = lnSelectedIndex

		This.cmdCancel.Caption = "\<Cancel"
		This.cmdCancel.Width = 70
		This.cmdCancel.Left = (This.cboValues.Left + This.cboValues.Width) - This.cmdCancel.Width
		This.cmdCancel.Top = This.cboValues.Top + This.cboValues.Height + 20

		This.cmdOk.Caption = "\<OK"
		This.cmdOk.Width = 70
		This.cmdOk.Left = This.cmdCancel.Left - (This.cmdOk.Width + 5)
		This.cmdOk.Top = This.cmdCancel.Top

		This.Width = This.cmdCancel.Left + This.cmdCancel.Width + 20
		This.Height = This.cmdCancel.Top + This.cmdCancel.Height + 20
		This.shpBorder.Left = 5
		This.shpBorder.Top = 5
		This.shpBorder.Width = This.Width - This.shpBorder.Left*2
		This.shpBorder.Height = This.Height - This.shpBorder.Left*2
		This.shpBorder.ZOrder(1)

	Procedure cmdOk.Click
		lnSelectedIndex = Thisform.cboValues.ListIndex
		DoDefault()
	Endproc
	Procedure cmdCancel.Click
		lnSelectedIndex = 0
		DoDefault()
	Endproc
Enddefine

Define Class cmd As CommandButton

	Visible = .T.
	FontName = "Tahoma"
	FontSize = 8
	AutoSize = .F.
	Visible = .T.
	Height = 25
	Procedure Click
		Thisform.Release()
	Endproc
Enddefine

Define Class shp As Shape
	SpecialEffect = 0
	Style = 3
	Visible = .T.
Enddefine
