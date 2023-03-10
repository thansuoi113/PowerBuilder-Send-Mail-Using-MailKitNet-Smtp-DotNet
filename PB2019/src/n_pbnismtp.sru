$PBExportHeader$n_pbnismtp.sru
forward
global type n_pbnismtp from nonvisualobject
end type
end forward

global type n_pbnismtp from nonvisualobject
end type
global n_pbnismtp n_pbnismtp

type variables
// Connection Type
Constant Integer None =	0						//No SSL or TLS encryption should be used.
Constant Integer Auto	 = 1						//Allow the IMailService to decide which SSL or TLS options to use (default). If the server does not support SSL or TLS, then the connection will continue without any encryption.
Constant Integer SslOnConnect	 = 2			//The connection should use SSL or TLS encryption immediately.
Constant Integer StartTls = 3					//Elevates the connection to use TLS encryption immediately after reading the greeting and capabilities of the server. If the server does not support the STARTTLS extension, then the connection will fail and a NotSupportedException will be thrown.
Constant Integer StartTlsWhenAvailable =4 //Elevates the connection to use TLS encryption immediately after reading the greeting and capabilities of the server, but only if the server supports the STARTTLS extension.


//* I have not found how to configure these parameters ...

// Authentication Method
Constant Integer AUTH_NONE = 0
Constant Integer AUTH_CRAM_MD5 = 1
Constant Integer AUTH_LOGIN = 2
Constant Integer AUTH_PLAIN = 3
Constant Integer AUTH_NTLM = 4
Constant Integer AUTH_AUTO = 5
Constant Integer AUTH_XOAUTH2 = 6

// Priority
Constant Integer NoPriority = 0
Constant Integer LowPriority = 1
Constant Integer NormalPriority = 2
Constant Integer HighPriority = 3

// Character Set Values
// windows-1256	Arabic (Windows)
// windows-1257	Baltic (Windows)
// iso-8859-2		Central European (ISO)
// windows-1250	Central European (Windows)
// gb2312			Chinese Simplified (GB2312)
// hz-gb-2312		Chinese Simplified (HZ)
// big5				Chinese Traditional (Big5)
// koi8-r			Cyrilic (KOI8-R)
// windows-1251	Cyrillic (Windows)
// windows-1253	Greek (Windows)
// windows-1255	Hebrew (Windows)
// iso-2022-jp		Japanese (JIS)
// ks_c_5601		Korean
// euc-kr			Korean (EUC)
// iso-8859-15		Latin 9 (ISO)
// windows-874		Thai (Windows)
// windows-1254	Turkish (Windows)
// utf-7				Unicode (UTF-7)
// utf-8				Unicode (UTF-8)
// windows-1258	Vietnamese (Windows)
// iso-8859-1		Western European (ISO)
// windows-1252	Western European (Windows)
nvo_mailkitsmptrsr in_smtp


end variables

forward prototypes
public function long of_parse (readonly string as_string, readonly string as_separator, ref string as_outarray[])
public function boolean of_validemail (string as_email, ref string as_errormsg)
public subroutine of_addtostring (ref string as_outputstring, string as_newstring)
public subroutine  of_setmessage(string as_pbmessage) throws exception
public subroutine  of_setmessage(string as_pbmessage,boolean abln_pbhtml) throws exception
public subroutine  of_setrecipientemail(string as_pbrecipientname,string as_pbrecipientmail) throws exception
public subroutine  of_setccrecipientemail(string as_pbccrecipientname,string as_pbccrecipientmail) throws exception
public subroutine  of_setbccrecipientemail(string as_pbbccrecipientname,string as_pbbccrecipientmail) throws exception
public subroutine  of_setreplytoemail(string as_pbreplytoname,string as_pbreplytomail) throws exception
public subroutine  of_setsenderemail(string as_pbsendername,string as_pbsendermail) throws exception
public subroutine  of_setsmtpserver(string as_pbsmtpserver) throws exception
public subroutine  of_setsubject(string as_pbsubject) throws exception
public subroutine  of_setattachment(string as_pbattachment) throws exception
public subroutine  of_setcharset(string as_pbcharset) throws exception
public subroutine  of_setusernamepassword(string as_pbusername,string as_pbpassword) throws exception
public subroutine  of_setport(long al_pbport) throws exception
public subroutine  of_setauthmethod(long al_pbauthmethod) throws exception
public subroutine  of_setconnectiontype(long al_pbconnecttype) throws exception
public function string of_getlasterrormessage ()
public subroutine  of_setmailername(string as_pbmailername) throws exception
public subroutine  of_setpriority(long al_pbpriority) throws exception
public subroutine  of_setprioritynone() throws exception
public subroutine  of_setprioritylow() throws exception
public subroutine  of_setprioritynormal() throws exception
public subroutine  of_setpriorityhigh() throws exception
public subroutine  of_setreadreceiptrequested(boolean abln_pbreadreceipt) throws exception
public function long of_smtpconnect() throws exception
public function long of_smtpsend() throws exception
public function long of_smtpdisconnect() throws exception
public function exception of_get_exception (string as_message)
public function long of_send () throws exception
end prototypes

public function long of_parse (readonly string as_string, readonly string as_separator, ref string as_outarray[]);// -----------------------------------------------------------------------------
// SCRIPT:     of_Parse
//
// PURPOSE:    This function parses a string into an array.
//
// ARGUMENTS:  as_string		- The string to be separated
//					as_separator	- The separator characters
//					as_outarray		- By ref output array
//
//	RETURN:		The number of items in the array
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 08/12/2017  RolandS		Initial creation
// -----------------------------------------------------------------------------

Long ll_PosEnd, ll_PosStart = 1, ll_SeparatorLen, ll_Counter = 1

If UpperBound(as_OutArray) > 0 Then as_OutArray = {""}

ll_SeparatorLen = Len(as_Separator)

ll_PosEnd = Pos(as_String, as_Separator, 1)

Do While ll_PosEnd > 0
	as_OutArray[ll_Counter] = Mid(as_String, ll_PosStart, ll_PosEnd - ll_PosStart)
	ll_PosStart = ll_PosEnd + ll_SeparatorLen
	ll_PosEnd = Pos(as_String, as_Separator, ll_PosStart)
	ll_Counter++
Loop

as_OutArray[ll_Counter] = Right(as_String, Len(as_String) - ll_PosStart + 1)

Return ll_Counter

end function

public function boolean of_validemail (string as_email, ref string as_errormsg);// -----------------------------------------------------------------------------
// SCRIPT:     ValidEmail
//
// PURPOSE:    This function determines if the email address is valid syntax.
//
// ARGUMENTS:  as_email		- Email address to analyze
//					as_errormsg	- Error message describing the problem
//
// RETURN:     True = Valid syntax, False = Invalid Syntax
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/12/2017  RolandS		Initial creation
// -----------------------------------------------------------------------------

String ls_localpart, ls_domain, ls_domainpart[]
Integer li_pos, li_idx, li_max, li_asc

If Len(as_email) > 254 Then
	as_errormsg = "Email address cannot be more than 254 characters!"
	Return False
End If

li_pos = Pos(as_email, "@")
If li_pos < 2 Then
	as_errormsg = "Email address must have an @ character!"
	Return False
End If

If LastPos(as_email, "@") > Pos(as_email, "@") Then
	as_errormsg = "Email address cannot have more than one @ character!"
	Return False
End If

li_pos = Pos(as_email, " ")
If li_pos > 0 Then
	as_errormsg = "Email address cannot have any spaces!"
	Return False
End If

// split local & domain
li_pos = Pos(as_email, "@")
ls_localpart = Left(as_email, li_pos - 1)
ls_domain    = Mid(as_email, li_pos + 1)

If Len(ls_localpart) > 64 Then
	as_errormsg = "The mailbox part of the email address cannot be more than 64 characters!"
	Return False
End If

If Len(ls_domain) > 253 Then
	as_errormsg = "The domain part of the email address cannot be more than 253 characters!"
	Return False
End If

If Left(ls_localpart, 1) = "." Then
	as_errormsg = "The mailbox part of the email address cannot start with a period!"
	Return False
End If

If Right(ls_localpart, 1) = "." Then
	as_errormsg = "The mailbox part of the email address cannot end with a period!"
	Return False
End If

If Pos(ls_localpart, "..") > 0 Then
	as_errormsg = "The mailbox part of the email address cannot have more than one period in a row!"
	Return False
End If

// check local for allowed characters
li_max = Len(ls_localpart)
For li_idx = 1 To li_max
	li_asc = Asc(Mid(ls_localpart, li_idx, 1))
	choose case li_asc
		case 65 to 90
			// Lower case a-z
		case 97 to 122
			// Upper case A-Z
		case 48 to 57
			// Digits 0-9
		case 33, 35 to 39, 42, 43, 45, 47, 61, 63, 94 to 96, 123 to 126
			// Characters !#$%&'*+-/=?^_`{|}~
		case 46
			// Period
		case else
			as_errormsg = "The mailbox part of the email address contains invalid characters!"
			Return False
	end choose
Next

If Left(ls_domain, 1) = "." Then
	as_errormsg = "The domain part of the email address cannot start with a period!"
	Return False
End If

If Right(ls_domain, 1) = "." Then
	as_errormsg = "The domain part of the email address cannot end with a period!"
	Return False
End If

li_pos = Pos(ls_domain, ".")
If li_pos = 0 Then
	as_errormsg = "The domain part of the email address must have at least one period!"
	Return False
End If

// check domain for allowed characters
li_max = Len(ls_domain)
For li_idx = 1 To li_max
	li_asc = Asc(Mid(ls_domain, li_idx, 1))
	choose case li_asc
		case 65 to 90
			// Lower case a-z
		case 97 to 122
			// Upper case A-Z
		case 48 to 57
			// Digits 0-9
		case 45
			// Hyphen
		case 46
			// Period
		case else
			as_errormsg = "The domain part of the email address contains invalid characters!"
			Return False
	end choose
Next

// break domain into parts
li_max = of_Parse(ls_domain, ".", ls_domainpart)

If li_max > 127 Then
	as_errormsg = "The domain part of the email address contains too many periods!"
	Return False
End If

For li_idx = 1 To li_max
	If Left(ls_domainpart[li_idx], 1) = "-" Then
		as_errormsg = "The domain part of the email address cannot have a hyphen and a period next to one another!"
		Return False
	End If
	If Right(ls_domainpart[li_idx], 1) = "-" Then
		as_errormsg = "The domain part of the email address cannot have a hyphen and a period next to one another!"
		Return False
	End If
Next

Return True

end function

public subroutine of_addtostring (ref string as_outputstring, string as_newstring);// -----------------------------------------------------------------------------
// SCRIPT:		AddToString
//
// PURPOSE:		This function adds an item to a semi-colon separated string.
//
// ARGUMENTS:  as_outputstring	- The string to update
//					as_newstring		- The string to add to as_outputstring
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 08/12/2017  RolandS		Initial creation
// -----------------------------------------------------------------------------

If Len(as_outputstring) = 0 Then
	as_outputstring = Trim(as_newstring)
Else
	as_outputstring = as_outputstring + ";" + Trim(as_newstring)
End If

end subroutine

public subroutine  of_setmessage(string as_pbmessage) throws exception;
in_smtp. of_setmessage(as_pbmessage)
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public subroutine  of_setmessage(string as_pbmessage,boolean abln_pbhtml) throws exception;
in_smtp.of_setmessage(as_pbmessage, abln_pbhtml) 
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public subroutine  of_setrecipientemail(string as_pbrecipientname,string as_pbrecipientmail) throws exception;
in_smtp.of_setrecipientemail(as_pbrecipientname,as_pbrecipientmail)
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public subroutine  of_setccrecipientemail(string as_pbccrecipientname,string as_pbccrecipientmail) throws exception;
in_smtp.of_setccrecipientemail(as_pbccrecipientname, as_pbccrecipientmail)
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public subroutine  of_setbccrecipientemail(string as_pbbccrecipientname,string as_pbbccrecipientmail) throws exception;
in_smtp.of_setbccrecipientemail(as_pbbccrecipientname, as_pbbccrecipientmail)
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public subroutine  of_setreplytoemail(string as_pbreplytoname,string as_pbreplytomail) throws exception;
in_smtp.of_setreplytoemail(as_pbreplytoname, as_pbreplytomail)
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public subroutine  of_setsenderemail(string as_pbsendername,string as_pbsendermail) throws exception;
in_smtp.of_setsenderemail( as_pbsendername, as_pbsendermail)
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public subroutine  of_setsmtpserver(string as_pbsmtpserver) throws exception;
in_smtp.of_setsmtpserver(as_pbsmtpserver) 
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public subroutine  of_setsubject(string as_pbsubject) throws exception;
in_smtp.of_setsubject(as_pbsubject)
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public subroutine  of_setattachment(string as_pbattachment) throws exception;
in_smtp.of_setattachment(as_pbattachment)
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public subroutine  of_setcharset(string as_pbcharset) throws exception;
in_smtp.of_setcharset(as_pbcharset)
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public subroutine  of_setusernamepassword(string as_pbusername,string as_pbpassword) throws exception;
in_smtp.of_setusernamepassword( as_pbusername, as_pbpassword)
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public subroutine  of_setport(long al_pbport) throws exception;
in_smtp.of_setport(al_pbport)
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public subroutine  of_setauthmethod(long al_pbauthmethod) throws exception;
in_smtp.of_setauthmethod(al_pbauthmethod)
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public subroutine  of_setconnectiontype(long al_pbconnecttype) throws exception;
in_smtp.of_setconnectiontype(al_pbconnecttype)
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public function string of_getlasterrormessage ();String ls_ErrorText

ls_ErrorText = in_smtp.of_getlasterrormessage()

IF trim(ls_ErrorText)=""  then Setnull(ls_ErrorText)

RETURN ls_ErrorText
end function

public subroutine  of_setmailername(string as_pbmailername) throws exception;
in_smtp.of_setmailername(as_pbmailername)
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public subroutine  of_setpriority(long al_pbpriority) throws exception;
in_smtp.of_setpriority(al_pbpriority)
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public subroutine  of_setprioritynone() throws exception;
in_smtp.of_setprioritynone()
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public subroutine  of_setprioritylow() throws exception;
in_smtp.of_setprioritylow()
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public subroutine  of_setprioritynormal() throws exception;
in_smtp. of_setprioritynormal()
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public subroutine  of_setpriorityhigh() throws exception;
in_smtp.of_setpriorityhigh()
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public subroutine  of_setreadreceiptrequested(boolean abln_pbreadreceipt) throws exception;
in_smtp.of_setreadreceiptrequested(abln_pbreadreceipt)
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
end subroutine

public function long of_smtpconnect() throws exception;long ll_result
ll_result = in_smtp.of_smtpconnect()
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
RETURN ll_result
end  function

public function long of_smtpsend() throws exception;Long ll_result
ll_result = in_smtp.of_smtpsend()
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
RETURN ll_result
end  function

public function long of_smtpdisconnect() throws exception;Long ll_result
ll_result = in_smtp.of_smtpsend()
//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF
RETURN ll_result
end  function

public function exception of_get_exception (string as_message);exception lu_exception
lu_exception = create exception
lu_exception.setmessage(as_message)
return lu_exception
end function

public function long of_send () throws exception;Long ll_result

ll_result = in_smtp.of_send()

//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  throw of_get_exception(in_smtp.is_ErrorText)
END IF

return ll_result


end function

on n_pbnismtp.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_pbnismtp.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;in_smtp = CREATE nvo_mailkitsmptrsr 

//Checks the result
IF in_smtp.il_ErrorType < 0 THEN
  messagebox("Failed", in_smtp.is_ErrorText)
  RETURN
END IF
end event

event destructor;Destroy in_smtp 
end event

