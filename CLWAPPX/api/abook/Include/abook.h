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
#DEFINE MSG_NOTFOUND        "��辺������"
#DEFINE MSG_DUPLICATE       "�����ū�� "
#DEFINE MSG_CANCEL          "¡��ԡ�������¹�ŧ"
#DEFINE MSG_ERROR           "�������Դ��Ҵ"
#DEFINE MSG_WARNING					"����͹"
#DEFINE MSG_SAVE            "�ѹ�֡������"
#DEFINE MSG_ADD             "����������"
#DEFINE MSG_CHANGE          "��䢢�����"
#DEFINE MSG_DELETE          "ź������"
#DEFINE MSG_PRINT 	        "������͡���-��§ҹ"
#DEFINE MSG_SAVEQUIT        "�ѹ�֡�������¹�ŧ"
#DEFINE MSG_CONFIRM         "�׹�ѹ�ա����"
#DEFINE MSG_ENTER           "�ô�к�"
#DEFINE MSG_X_VALID         "����ҹ"
#DEFINE MSG_X_CHANGE        "���͹حҵ�������"
#DEFINE MSG_X_DELETE        "���͹حҵ����ź������"
#DEFINE MSG_X_CLOSE         "���͹حҵ����Դ�ҹ"
#DEFINE MSG_INCORRECT		  	"���١��ͧ"
#DEFINE MSG_X_LOCK					"�ռ����蹡��ѧ��䢢��������ǡѹ ... �ô�ͧ�ա����"
#DEFINE MSG_UNAPPROVED			"*** �ѧ������Ѻ���͹��ѵ� ***"
#DEFINE MSG_UNAUTHORIZED		"*** ������Է�����ҹ ***"
#DEFINE MSG_UNPRINT					"*** �͡����ѧ������� ***"
#DEFINE MSG_QUIT						"��ԡ�ҹ"

*-- Table Data Control
#DEFINE TBDATA_CITY						"01"
#DEFINE TBDATA_OCCUPATION			"02"
#DEFINE TBDATA_COMPANY_TYPE		"03"

*-- Security Level
#DEFINE SECLEV_USER			1
#DEFINE SECLEV_ADMIN		9
