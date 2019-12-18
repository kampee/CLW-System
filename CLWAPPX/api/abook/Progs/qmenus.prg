*---------------------------------------------------------------
DEFINE CLASS qTimer AS tmMouse
*---------------------------------------------------------------
* This timer class will capture qButton only !
* Note: THIS.oControl is qButton.lblOption or qButton.shpBox

	PROCEDURE onMouseOver
		WITH THIS.oControl.PARENT
			.lblOption.ForeColor = .nOptionOnColor
			.shpBox.BackColor = .nBoxOnColor
		ENDWITH
	ENDPROC
	
	PROCEDURE onMouseOut
		WITH THIS.oControl.PARENT
			.lblOption.ForeColor = .nOptionOffColor
			.shpBox.BackColor = .nBoxOffColor
		ENDWITH
	ENDPROC
	
ENDDEFINE

*---------------------------------------------------------------
DEFINE CLASS qMenus AS Container
*---------------------------------------------------------------

	BorderWidth = 0
	BackColor = RGB(255,255,255)
	
	* (+) Add new properties
	oSelectedOption = .F.

	ADD OBJECT qImage AS Image WITH ;
		Picture = "graphics\sofetone.bmp", ;
		BorderStyle = 1, ;
		Stretch = 2, ;
		Height = 96, ;
		Left = 12, ;
		Top = 24, ;
		Width = 100

	ADD OBJECT qBtnSearch AS qButton WITH ;
		Top = 144, ;
		lblOption.Caption = "ค้นหา"

	ADD OBJECT qBtnAbout AS qButton WITH ;
		Top = 180, ;
		lblOption.Caption = "About"

	ADD OBJECT qBtnQuit AS qButton WITH ;
		Top = 216, ;
		lblOption.Caption = "เลิกงาน"

	* (+) Capture qButton mouse in/out
	ADD OBJECT qMouseCapture AS qTimer

	PROCEDURE Init
		PUBLIC goTbQuickMenu		
		* This toolbar variable is always turn on while application running

		goTbQuickMenu = CreateObject('tbMenus', THIS)
		WITH THIS
		   .Width = 130
		   .Height= SYSMETRIC(2)
			 .SetAll("nBoxOnColor",14778368,"qButton")
		   .Visible = .T.		&& Auto-show after object created
		ENDWITH
	ENDPROC

	PROCEDURE RightClick
	LOCAL lnChoice, luTemp

		DEFINE POPUP ScreenPopup SHORTCUT RELATIVE FROM MROW(),MCOL()
		DEFINE BAR 1 OF ScreenPopup PROMPT "ค้นหา"
		DEFINE BAR 2 OF ScreenPopup PROMPT "About"
		DEFINE BAR 9 OF ScreenPopup PROMPT "เลิกงาน"
		DEFINE BAR 10 OF ScreenPopup PROMPT "\-"
		DEFINE BAR 11 OF ScreenPopup PROMPT "Toolbar"		
		ON SELECTION POPUP ScreenPopup DoQuickMenu(BAR())
		* Determine Menu Toolbar exist/on/off
		luTemp = IsToolbarOn(goTbQuickMenu)
		IF TYPE('luTemp')="L"
			SET MARK OF BAR 11 OF ScreenPopup TO luTemp
		ELSE
			SET SKIP OF BAR 11 OF ScreenPopup .F.
		ENDIF
		ACTIVATE POPUP ScreenPopup
		RELEASE POPUP ScreenPopup
	ENDPROC
	
	PROCEDURE Destroy
		RELEASE goTbQuickMenu
	ENDPROC
	
	PROCEDURE qBtnSearch.DoOption
		=DoQuickMenu(1)
	ENDPROC

	PROCEDURE qBtnAbout.DoOption
		=DoQuickMenu(2)
	ENDPROC

	PROCEDURE qBtnQuit.DoOption
		=DoQuickMenu(9)
	ENDPROC

ENDDEFINE


*---------------------------------------------------------------
DEFINE CLASS qButton AS Container
*---------------------------------------------------------------
	#DEFINE _GRANDPA THIS.PARENT.PARENT
	
	Width = 100
	Height = 25
	Left = 12
	BackStyle = 0
	BorderWidth = 0
	
	* (+) Add New Properties
	HIDDEN cOnClickSound
	nOptionOffColor = .F.
	nBoxOffColor = .F.
	nOptionOnColor = .F.
	nBoxOnColor = .F.
	cOnClickSound = "sounds\click.wav"
	
	ADD OBJECT shpBox AS Shape WITH ;
		Curvature = 10, ;
		BackColor = RGB(0,64,128)

	ADD OBJECT lblOption AS Label WITH ;
		AutoSize = .T., ;
		FontBold = .T., ;
		FontName = "MS Sans Serif", ;
		Alignment = 2, ;
		BackStyle = 0, ;
		Caption = "Option", ;
		ForeColor = RGB(255,255,255)
		
	PROCEDURE Init
		WITH THIS
			IF EMPTY(.nOptionOnColor)
				.nOptionOnColor = .lblOption.ForeColor
			ENDIF
			IF EMPTY(.nBoxOnColor)
				.nBoxOnColor = .shpBox.BackColor
			ENDIF
			.nOptionOffColor = .lblOption.ForeColor
			.nBoxOffColor = .shpBox.BackColor
			WITH .shpBox
				.Width = THIS.Width
				.Height = THIS.Height
			ENDWITH
			WITH .lblOption
				.Left = (THIS.Width - .Width) / 2
				.Top = (THIS.Height - .Height) / 2
			ENDWITH
		  .SetAll("MousePointer",99)
		  .SetAll("MouseIcon","graphics\h_point.cur")
		ENDWITH
	ENDPROC

	PROCEDURE Click
		* Play Sound on Click
		IF !EMPTY(THIS.cOnClickSound) AND FILE(THIS.cOnClickSound)
			SET BELL TO (THIS.cOnClickSound), 0
			??CHR(7)
			SET BELL TO
		ENDIF
		THIS.DoOption()
	ENDPROC

	* (+) Add new method
	PROCEDURE DoOption
		* Write program in qMenus Class
	ENDPROC

	PROCEDURE shpBox.Click
		THIS.PARENT.Click()
	ENDPROC

	PROCEDURE shpBox.MouseMove
	LPARAMETERS nButton, nShift, nXCoord, nYCoord

		_GRANDPA.qMouseCapture.MouseOver(THIS)
	ENDPROC

	PROCEDURE lblOption.Click
		THIS.PARENT.Click()
	ENDPROC

	PROCEDURE lblOption.MouseMove
	LPARAMETERS nButton, nShift, nXCoord, nYCoord

		_GRANDPA.qMouseCapture.MouseOver(THIS)
	ENDPROC

ENDDEFINE


*---------------------------------------------------------------
DEFINE CLASS tbMenus AS Toolbar
*---------------------------------------------------------------
	
	Left = 0
	Top = 0
	Caption = "QuickMenu"
	ControlBox = .F.

	* Winbtn Class in Win98btn.VCX
  * Gavrikov Denis, email: marka@aha.ru	
  
	ADD OBJECT cmdQuit AS Winbtn WITH ;
		Width = 33, ;
		Height = 31, ;
		Picture_Default = "exit.bmp", ;
		ToolTipText = "Exit"

	ADD OBJECT cmdSearch AS Winbtn WITH ;
		Width = 33, ;
		Height = 31, ;
		Picture_Default = "locate.bmp", ;
		ToolTipText = "ค้นหา"

	ADD OBJECT cmdAbout AS Winbtn WITH ;
		Width = 33, ;
		Height = 31, ;
		Picture_Default = "mycomp.bmp", ;
		ToolTipText = "About"

	* (+) Add new properties
	oQuickMenu = .F.		&& Kept qMenus Object	
	
	PROCEDURE Init
	LPARAMETER oQMenus
		
		IF PCOUNT()=0
			RETURN .F.
		ENDIF
		WITH THIS
			.SetAll("Caption", "", "Winbtn")
			.Dock(2)
			.Visible = .T.
			.oQuickMenu = oQMenus
		ENDWITH
	ENDPROC

	PROCEDURE cmdSearch.Click
		THIS.PARENT.oQuickMenu.qBtnSearch.Click()
	ENDPROC

	PROCEDURE cmdAbout.Click
		THIS.PARENT.oQuickMenu.qBtnAbout.Click()
	ENDPROC

	PROCEDURE cmdQuit.Click
		THIS.PARENT.oQuickMenu.qBtnQuit.Click()
	ENDPROC

ENDDEFINE


*---------------------------------------------------------------
* Procedures and Functions
*---------------------------------------------------------------

PROCEDURE DoQuickMenu
LPARAMETER nChoice

	DO CASE
	CASE nChoice=1
		IF WEXIST("ab101")
			ACTIVATE WINDOW ab101
		ELSE
			DO FORM ab101
		ENDIF	
	CASE nChoice=2
		LOCAL loAbout

		* About is a Class in Utility.VCX
		loAbout = CreateObject("frmAbout")
		IF TYPE("loAbout")="O"
			loAbout.imgAbout.Picture = "graphics\myapp.bmp"
			loAbout.Show(1)		&& Modal for LOCAL variable
		ENDIF	
	CASE nChoice=9
		DO onShutdown	&& in main.prg
	CASE nChoice=11
		LOCAL luTemp
		
		luTemp = IsToolbarOn(goTbQuickMenu)
		IF TYPE('luTemp')="L"
			IF luTemp
				goTbQuickMenu.Hide()
			ELSE
				goTbQuickMenu.Show()			
			ENDIF
		ENDIF
	ENDCASE
	
ENDPROC


PROCEDURE IsToolbarOn
LPARAMETER oToolbar
	
	IF TYPE("oToolbar")#"O"
		RETURN .NULL.
	ELSE
		RETURN oToolbar.Visible
	ENDIF
	
ENDPROC
