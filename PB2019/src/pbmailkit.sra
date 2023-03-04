$PBExportHeader$pbmailkit.sra
$PBExportComments$Generated Application Object
forward
global type pbmailkit from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type pbmailkit from application
string appname = "pbmailkit"
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 21.0\IDE\theme"
string themename = "Do Not Use Themes"
boolean nativepdfvalid = false
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 2
long richtexteditx64type = 3
long richtexteditversion = 3
string richtexteditkey = ""
string appicon = "chicken.ico"
string appruntimeversion = "19.2.0.2703"
end type
global pbmailkit pbmailkit

on pbmailkit.create
appname="pbmailkit"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on pbmailkit.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;Open(w_main)

end event

