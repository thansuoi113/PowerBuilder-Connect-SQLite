$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type st_1 from statictext within w_main
end type
type cb_4 from commandbutton within w_main
end type
type cb_3 from commandbutton within w_main
end type
type cb_2 from commandbutton within w_main
end type
type cb_1 from commandbutton within w_main
end type
type sle_db from singlelineedit within w_main
end type
end forward

global type w_main from window
integer width = 2235
integer height = 468
boolean titlebar = true
string title = "Connect SQLite"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_1 st_1
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
sle_db sle_db
end type
global w_main w_main

on w_main.create
this.st_1=create st_1
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.sle_db=create sle_db
this.Control[]={this.st_1,&
this.cb_4,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.sle_db}
end on

on w_main.destroy
destroy(this.st_1)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.sle_db)
end on

event open;string ls_path
ls_path = GetCurrentDirectory ( )

sle_db.text = ls_path + "\wc.db"
end event

type st_1 from statictext within w_main
integer x = 41
integer y = 64
integer width = 119
integer height = 56
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "DB:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_4 from commandbutton within w_main
integer x = 1966
integer y = 48
integer width = 142
integer height = 92
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "..."
end type

event clicked;String ls_path, ls_file
Int li_rc

ls_path = sle_db.Text
li_rc = GetFileSaveName ( "Select File",   ls_path, ls_file, "*",  "All Files (*.*),*.*" )

If li_rc = 1 Then
	sle_db.Text = ls_path
End If

end event

type cb_3 from commandbutton within w_main
integer x = 1778
integer y = 200
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;Close(Parent)
end event

type cb_2 from commandbutton within w_main
integer x = 645
integer y = 192
integer width = 398
integer height = 100
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Connect JDBC"
end type

event clicked;
String ls_path, ls_classpath
Boolean lb_jvm_started, lb_debug
javavm ljvm
ls_path = GetCurrentDirectory ( )

// set classpath or you can environment variables of window
ls_classpath = ls_path +  "\sqlite-jdbc-3.32.3.2.jar"
If Not FileExists(ls_classpath) Then
	MessageBox('Warning',"driver class file not exists")
	Return
End If
If Not lb_jvm_started Then
	ljvm = Create javavm //using pbejbclientXXX.pbd
	Choose Case ljvm.createJavaVM(ls_classpath, lb_debug)
		Case 0
			lb_jvm_started = True
		Case -1
			MessageBox('Warning',"Failed to load JavaVM")
			Return
		Case -2
			MessageBox('Warning',"Failed to load EJBLocator")
			Return
	End Choose
End If


// get infor
String ls_dbSQLite

ls_dbSQLite = sle_db.Text

//connect
Transaction ltran_conn
ltran_conn = Create Transaction

ltran_conn.DBMS = "JDBC"
ltran_conn.AutoCommit = False
ltran_conn.DBParm = "Driver='org.sqlite.JDBC',URL='jdbc:sqlite:"+ls_dbSQLite+"'"

Connect Using ltran_conn ;
If ltran_conn.SQLCode = -1 Then
	MessageBox('Warning','Connect Database Error' + ltran_conn.SQLErrText)
Else
	MessageBox('Warning',"Connect Success!")
	
	Int li_count
	Select count(*) Into :li_count From ACTUAL_NODE Using ltran_conn;
	MessageBox("Warning", String(li_count))
	
End If

Disconnect Using ltran_conn ;


end event

type cb_1 from commandbutton within w_main
integer x = 169
integer y = 192
integer width = 416
integer height = 100
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Connect ODBC"
end type

event clicked;String ls_dbSQLite, ls_db

ls_dbSQLite = sle_db.Text
ls_db = "PBSQLITE"

Transaction ltran_conn
ltran_conn = Create Transaction
Disconnect Using ltran_conn ;

RegistrySet("HKEY_CURRENT_USER\SOFTWARE\ODBC\ODBC.INI\"+ls_db+"","AutoStop",RegString!,"yes")
RegistrySet("HKEY_CURRENT_USER\SOFTWARE\ODBC\ODBC.INI\"+ls_db+"" ,"Database",RegString!,ls_dbSQLite)
RegistrySet("HKEY_CURRENT_USER\SOFTWARE\ODBC\ODBC.INI\"+ls_db+"" ,"Driver",RegString!,"sqlite3odbc.dll")

// Using ODBC Connect To SQLite 
ltran_conn.DBMS = "ODBC"
ltran_conn.AutoCommit = False
ltran_conn.DBParm =  "ConnectString='DSN=" + ls_db + "'"

Connect Using ltran_conn ;
If ltran_conn.SQLCode = -1 Then
	MessageBox('Warning','Connect Database Error' + ltran_conn.SQLErrText)
Else
	MessageBox('Warning',"Connect Success!")
	
	Int li_count
	Select count(*) Into :li_count From ACTUAL_NODE Using ltran_conn;
	MessageBox("Warning", String(li_count))
	
End If

Disconnect Using ltran_conn ;





end event

type sle_db from singlelineedit within w_main
integer x = 169
integer y = 56
integer width = 1792
integer height = 80
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

