<!--- Acquisition and disposal projects can both have many PIN/PID's. 
When they click on the "Add New" PIN/PID button on either acquisitions.cfm 
or disposals.cfm, they are taken to this page (via acquisitionSave.cfm 
or disposalSave.cfm) where they fill out a simple form and click either 
"Submit" or "Cancel". The form is sent to the page specified in URL.type 
(either acquisitions.cfm or dipsosals.cfm). --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Add PIN/PID</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script language="JavaScript">


// this function removes all -'s from string entered
// and then makes sure it is the appropriate length
// (9 for PID's and 7 for PIN's)
function validateForm(){
	var re = /-/gi;
	var pinpid = document.form1.pinpid.value;
	var newPinpid = pinpid.replace(re, "");
	document.form1.pinpid.value = newPinpid;
	
	var checkedButton = ""
	// loop through the radio buttons to find out which
	// on is checked and set the checkedButton variable
	//for (var i in document.form1.isPINorPID) {
	for (var i = 0; i < 2; i++) {
		if (document.form1.isPINorPID[i].checked=="1") {
			checkedButton=document.form1.isPINorPID[i].value
		}
	}
	
	// If the PIN or PID is not the appropriate length 
	// display a message. If the length is correct, send the form.
	if (newPinpid.length != 9 && checkedButton == "pid") {
		alert('PID\'s must have 9 digits');
	}
	else if (newPinpid.length != 7 && checkedButton == "pin") {
		alert('PIN\'s must have 7 digits');
	}
	else if (isNaN(newPinpid)) {
		alert('The PIN/PID must consist of numeric digits and dashes (-), only.');
	}
	else {
		//alert(checkedButton);
		document.form1.submit();
	}
}

</script>

<!--- Include header.cfm which displays the top navigation menu as well as
some javascript function and CSS --->
<CFINCLUDE TEMPLATE="header.cfm">

<CFOUTPUT><FORM NAME="form1" ACTION="#URL.type#.cfm?projectID=#URL.projectID#&view=property" METHOD="POST"></CFOUTPUT>
<INPUT TYPE="hidden" NAME="pinpid_required" VALUE="You must enter a PIN/PID number.">
<INPUT TYPE="hidden" NAME="isPINorPID_required" VALUE="Please indicate whether this is a PIN or PID.">
<INPUT TYPE="hidden" NAME="pinpidAdd" VALUE="yes">
<H2>&nbsp;Add PIN/PID</H2>

<table border="0" cellspacing="0" cellpadding="5" width="400"> 
	<tr>
		<td align="right">PIN/PID:</td>
		<td><INPUT TYPE="text" NAME="pinpid" SIZE=10 MAXLENGTH=15></td>
	</tr>
	<tr>
		<td align="right" valign="top">Is This A PIN or PID?:</td>
		<td>PIN <INPUT TYPE="radio" NAME="isPINorPID" VALUE="pin">&nbsp;&nbsp;&nbsp;PID <INPUT TYPE="radio" NAME="isPINorPID" VALUE="pid" CHECKED></td>
	</tr>
	<tr>
		<td colspan="2" align="center"><br>
		<a href="nowhere.cfm" onClick="validateForm(); return false;"><img src="images/button_submit.gif" width="65" hight="25" border="0"></a>&nbsp;<a href="<CFOUTPUT>#URL.type#.cfm?projectID=#URL.projectID#&view=property</CFOUTPUT>"><img src="images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
	</tr>
</table>
</FORM>
</body>
</html>
