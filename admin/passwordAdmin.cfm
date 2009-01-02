<!--- This page displays as well as processes the form for changing a user's password --->

 <!--- only users with Administrative and Write access can change passwords --->
<CFIF Client.Admin EQ 1 OR Client.Admin EQ 2>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Password Admin</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link rel=stylesheet href="style.css" type="text/css">

</head>

<body bgcolor="#FFFFFF" text="#000000">

<!--- include links to all the other admin pages --->
<CFINCLUDE TEMPLATE="nav.cfm">

<br><p><b>Password Admin</b></p>

<!--- If the user has just sent the form... --->
<CFIF IsDefined("Form.change")>
	<!--- Perform query to see if the old password they entered is correct --->
	<CFQUERY NAME="qryCheckOldPassword" DATASOURCE="#request.ds#">
		SELECT	intAgentID
		FROM	tblAgent
		WHERE	intAgentID = #Client.Employee_ID#
		AND		strPassword = '#Form.oldPassword#'
	</CFQUERY>
	<CFIF qryCheckOldPassword.recordcount>
		<!--- If the old password was correct, check to see if both new passwords
		are the same as each other --->
		<CFIF #Form.newPassword# EQ #Form.confirm#>
			<!--- If so, change the user's password --->
			<CFQUERY NAME="qryChangePassword" DATASOURCE="#request.ds#">
				UPDATE	tblAgent
				SET		strPassword = '#UCase(Form.newPassword)#'
				WHERE	intAgentID = #Client.Employee_ID#
			</CFQUERY>
			<br><br>Your password has been successfully changed.<br><br>
		<CFELSE>
			<!--- otherwise, the two new passwords they entered did not match,
			so display an error message --->
			<br><br>The confirmation password you entered did not match the first one.
			<br>Click <a class="norm" href="passwordAdmin.cfm">here</a> to try again.<br><br>
		</CFIF>
	<CFELSE>
		<!--- If the old password is incorrect, display an error message --->
		<br><br>The old password you entered is incorrect. Click <a class="norm" href="passwordAdmin.cfm">here</a> to try again.<br><br>
	</CFIF>
<CFELSE>
<!--- If the user has not just sent the form, then display the form --->
<br><br>
<FORM NAME="form1" ACTION="passwordAdmin.cfm" METHOD="POST">
<!--- hidden field to let passwordAdmin.cfm know the form is being sent --->
<INPUT TYPE="hidden" NAME="change">
<table border="0" cellpadding="2" cellspacing="0">
	<tr>
		<td align="right">Old Password:</td>
		<td><INPUT TYPE="password" NAME="oldPassword" SIZE=15 MAXLENGTH=15></td>
	</tr>
	<tr>
		<td align="right">New Password:</td>
		<td><INPUT TYPE="password" NAME="newPassword" SIZE=15 MAXLENGTH=15></td>
	</tr>
	<tr>
		<td align="right">Confirm New Password:</td>
		<td><INPUT TYPE="password" NAME="confirm" SIZE=15 MAXLENGTH=15></td>
	</tr>
	<tr>
		<td colspan=2 align="center"><br><a href="#" onClick="document.form1.submit(); return false"><img src="../images/button_submit.gif" width="65" height="25" border="0"></a></td>
	</tr>
</table>
</FORM>
</CFIF>
<br><br>
</body>
</html>

<CFELSE>
<!--- the user does not have access to this page so display a message --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Admin</title>
</head>
<body>
<br><br><p align="center"><b>Sorry, you do not have access to this part of the site.</b></p>
</body>
</CFIF>