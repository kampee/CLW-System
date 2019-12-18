VERSION 5.00
Begin VB.Form abFriend 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "N-Tier Friend"
   ClientHeight    =   2610
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2610
   ScaleWidth      =   4680
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox txtFriend 
      ForeColor       =   &H00FF0000&
      Height          =   345
      Index           =   2
      Left            =   1260
      TabIndex        =   11
      Text            =   "txtFriend"
      Top             =   1275
      Width           =   3015
   End
   Begin VB.TextBox txtFriend 
      ForeColor       =   &H00FF0000&
      Height          =   345
      Index           =   1
      Left            =   1260
      TabIndex        =   10
      Text            =   "txtFriend"
      Top             =   795
      Width           =   2235
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "Save"
      Height          =   315
      Left            =   3300
      TabIndex        =   6
      TabStop         =   0   'False
      Top             =   2025
      Width           =   975
   End
   Begin VB.CommandButton cmdRevert 
      Caption         =   "Revert"
      Height          =   315
      Left            =   2280
      TabIndex        =   5
      TabStop         =   0   'False
      Top             =   2025
      Width           =   975
   End
   Begin VB.CommandButton cmdRecord 
      Caption         =   ">|"
      Height          =   315
      Index           =   3
      Left            =   1620
      TabIndex        =   4
      TabStop         =   0   'False
      Top             =   2025
      Width           =   330
   End
   Begin VB.CommandButton cmdRecord 
      Caption         =   ">"
      Height          =   315
      Index           =   2
      Left            =   1260
      TabIndex        =   3
      TabStop         =   0   'False
      Top             =   2025
      Width           =   330
   End
   Begin VB.CommandButton cmdRecord 
      Caption         =   "<"
      Height          =   315
      Index           =   1
      Left            =   900
      TabIndex        =   2
      TabStop         =   0   'False
      Top             =   2025
      Width           =   330
   End
   Begin VB.CommandButton cmdRecord 
      Caption         =   "|<"
      Height          =   315
      Index           =   0
      Left            =   540
      TabIndex        =   1
      TabStop         =   0   'False
      Top             =   2025
      Width           =   330
   End
   Begin VB.TextBox txtFriend 
      ForeColor       =   &H00000000&
      Height          =   345
      Index           =   0
      Left            =   1260
      TabIndex        =   0
      TabStop         =   0   'False
      Text            =   "txtFriend"
      Top             =   315
      Width           =   3015
   End
   Begin VB.Label lblEmail 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "อีเมล์"
      Height          =   315
      Left            =   360
      TabIndex        =   9
      Top             =   1335
      Width           =   675
   End
   Begin VB.Label lblPhone 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "เบอร์โทร"
      Height          =   315
      Left            =   360
      TabIndex        =   8
      Top             =   855
      Width           =   675
   End
   Begin VB.Label lblLname 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "ชื่อ"
      Height          =   315
      Left            =   360
      TabIndex        =   7
      Top             =   375
      Width           =   675
   End
End
Attribute VB_Name = "abFriend"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Const MAX_FIELDS = 2
Dim rs As Object
Dim aFields(MAX_FIELDS) As String

Private Sub DataRefresh()
Dim i As Integer

For i = 0 To MAX_FIELDS
  txtFriend(i).Text = rs.GetValue(aFields(i))
Next i

End Sub

Private Sub cmdRecord_Click(Index As Integer)

Select Case Index
 Case 0
   rs.MoveFirst
 Case 1
   rs.MovePrev
 Case 2
   rs.MoveNext
 Case 3
   rs.MoveLast
End Select
DataRefresh

End Sub

Private Sub cmdRevert_Click()
  
  rs.RevertChanges
  DataRefresh

End Sub

Private Sub cmdSave_Click()

  rs.SaveChanges
  DataRefresh

End Sub

Private Sub Form_Load()

Set rs = CreateObject("ABCOM.Friend")
If rs Is Nothing Then
  Unload Me
  Exit Sub
End If

' txtFriend(0).Locked = True
' Caption = Caption & " with ADO Version " & rs.oConn.Version

rs.SortBy "lname"
aFields(0) = "lname"
aFields(1) = "phone"
aFields(2) = "email"
DataRefresh

End Sub

Private Sub Form_Unload(Cancel As Integer)

  If Not rs Is Nothing Then rs.Release

End Sub

Private Sub txtFriend_LostFocus(Index As Integer)

  If Not rs.SetValue(aFields(Index), txtFriend(Index).Text) Then
    txtFriend(Index).Text = rs.GetOldValue(aFields(Index))
  End If
  
End Sub
