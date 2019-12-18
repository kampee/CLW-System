*-- APPS OWNER USER
#DEFINE USER_APPS	 "ABOOK"

*-- MessageBox parameters
#DEFINE MB_OK                      0       && OK button only
#DEFINE MB_OKCANCEL                1       && OK and Cancel buttons
#DEFINE MB_ABORTRETRYIGNORE        2       && Abort, Retry, and Ignore buttons
#DEFINE MB_YESNOCANCEL             3       && Yes, No, and Cancel buttons
#DEFINE MB_YESNO                   4       && Yes and No buttons
#DEFINE MB_RETRYCANCEL             5       && Retry and Cancel buttons

#DEFINE MB_ICONSTOP                16      && Critical message
#DEFINE MB_ICONQUESTION            32      && Warning query
#DEFINE MB_ICONEXCLAMATION         48      && Warning message
#DEFINE MB_ICONINFORMATION         64      && Information message

#DEFINE MB_DEFBUTTON1              0       && First button is default
#DEFINE MB_DEFBUTTON2              256     && Second button is default
#DEFINE MB_DEFBUTTON3              512     && Third button is default

*-- MsgBox return values
#DEFINE IDOK                       1       && OK button pressed
#DEFINE IDCANCEL                   2       && Cancel button pressed
#DEFINE IDABORT                    3       && Abort button pressed
#DEFINE IDRETRY                    4       && Retry button pressed
#DEFINE IDIGNORE                   5       && Ignore button pressed
#DEFINE IDYES                      6       && Yes button pressed
#DEFINE IDNO                       7       && No button pressed

*-- Messagebox Messages
#DEFINE MSG_NOTFOUND        "ไม่พบข้อมูล"
#DEFINE MSG_DUPLICATE       "ข้อมูลซ้ำ "
#DEFINE MSG_CANCEL          "ยกเลิกการเปลี่ยนแปลง"
#DEFINE MSG_ERROR           "พบความผิดพลาด"
#DEFINE MSG_WARNING					"คำเตือน"
#DEFINE MSG_SAVE            "บันทึกข้อมูล"
#DEFINE MSG_ADD             "เพิ่มข้อมูล"
#DEFINE MSG_CHANGE          "แก้ไขข้อมูล"
#DEFINE MSG_DELETE          "ลบข้อมูล"
#DEFINE MSG_PRINT 	        "พิมพ์เอกสาร-รายงาน"
#DEFINE MSG_SAVEQUIT        "บันทึกการเปลี่ยนแปลง"
#DEFINE MSG_CONFIRM         "ยืนยันอีกครั้ง"
#DEFINE MSG_ENTER           "โปรดระบุ"
#DEFINE MSG_X_VALID         "ไม่ผ่าน"
#DEFINE MSG_X_CHANGE        "ไม่อนุญาติให้แก้ไข"
#DEFINE MSG_X_DELETE        "ไม่อนุญาติให้ลบข้อมูล"
#DEFINE MSG_X_CLOSE         "ไม่อนุญาติให้ปิดงาน"
#DEFINE MSG_INCORRECT		  	"ไม่ถูกต้อง"
#DEFINE MSG_X_LOCK					"มีผู้อื่นกำลังแก้ไขข้อมูลเดียวกัน ... โปรดลองอีกครั้ง"
#DEFINE MSG_UNAPPROVED			"*** ยังไม่ได้รับการอนุมัติ ***"
#DEFINE MSG_UNAUTHORIZED		"*** ไม่มีสิทธิ์ใช้งาน ***"
#DEFINE MSG_UNPRINT					"*** เอกสารยังไม่พิมพ์ ***"
#DEFINE MSG_QUIT						"เลิกงาน"

*-- Table Data Control
#DEFINE TBDATA_CITY						"01"
#DEFINE TBDATA_OCCUPATION			"02"
#DEFINE TBDATA_COMPANY_TYPE		"03"

*-- Security Level
#DEFINE SECLEV_USER			1
#DEFINE SECLEV_ADMIN		9
