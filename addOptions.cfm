<!--- When a user is adding a new project there are three buttons that allow
them to add new locations, client/departments, and client contacts to the 
drop-down lists. When they click on one of these buttons, the form from 
newProject.cfm is sent to this page so that when the user returns to 
newProject.cfm, this page can send the values back, and they will not be lost. --->

<!--- When the user clicks on one of the "Add New..." buttons on newProject.cfm,
the Form.optionType field is filled in to indicate what type of option is being added --->
<CFIF #Form.optionType# EQ "location">
	<!--- Display the form for adding a location --->
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
	<head>
	<title>Add Location</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">	

	<SCRIPT LANGUAGE="Javascript">
			
		// this function is called when a user clicks on the 
		// "Cancel" button.  It fills in the locName field with
		// a "*" because the locName field is required to have
		// something in it.
		function cancel() {
			document.form1.optionType.value = "cancel";
			document.form1.locName.value= "*";
			document.form1.submit();
		}
			
	</SCRIPT>
	
	<!--- Include header.cfm which displays the top navigation menu as well as
	some javascript function and CSS --->
	<CFINCLUDE TEMPLATE="header.cfm">
	
	<FORM NAME="form1" ACTION="newProject.cfm" METHOD="POST">
	<CFOUTPUT>
		<!-- all of these hidden fields are filled with the data from
		the form from newProject.cfm except option type which is "location" --->
		<INPUT TYPE="hidden" NAME="optionType" VALUE="location">
		<INPUT TYPE="hidden" NAME="projectType" VALUE="#Form.projectType#">
		<INPUT TYPE="hidden" NAME="province" VALUE="#Form.province#">
		<INPUT TYPE="hidden" NAME="location" VALUE="#Form.location#">
		<INPUT TYPE="hidden" NAME="description" VALUE="#Form.description#">
		<INPUT TYPE="hidden" NAME="department" VALUE="#Form.department#">
		<INPUT TYPE="hidden" NAME="secondDept" VALUE="#Form.secondDept#">
		<INPUT TYPE="hidden" NAME="clientContact" VALUE="#Form.clientContact#">
		<INPUT TYPE="hidden" NAME="agent" VALUE="#Form.agent#">
		<INPUT TYPE="hidden" NAME="startDate" VALUE="#Form.startDate#">
	</CFOUTPUT>
	<INPUT TYPE="hidden" NAME="locName_required" VALUE="You must enter a location name.">
	<H2>&nbsp;Add a Location</H2>
	<table border="0" cellspacing="0" cellpadding="5" width="650"> 
		<tr>
			<td align="right" width="90">Location Name:</td>
			<td><INPUT TYPE="text" NAME="locName" MAXLENGTH=50 SIZE=35></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><br>
			<a href="#" onClick="document.form1.submit(); return false"><img src="images/button_submit.gif" width="65" hight="25" border="0"></a>&nbsp;
			<a href="#" onClick="cancel(); return false;"><img src="images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
		</tr>
	</table>
	</FORM>
	</body>
	</html>

<CFELSEIF #Form.optionType# EQ "dept">
	<!--- Display the form for adding a department --->
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
	<head>
	<title>Add Department</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">	

	<SCRIPT LANGUAGE="Javascript">
			
		// this function is called when a user clicks on the 
		// "Cancel" button.  It fills in the locName field with
		// a "*" because the locName field is required to have
		// something in it.
		function cancel() {
			document.form1.optionType.value = "cancel";
			document.form1.deptName.value= "*";
			document.form1.deptAbbrev.value= "*";
			document.form1.submit();
		}
			
	</SCRIPT>
	
	<!--- Include header.cfm which displays the top navigation menu as well as
	some javascript function and CSS --->
	<CFINCLUDE TEMPLATE="header.cfm">
	
	<FORM NAME="form1" ACTION="newProject.cfm" METHOD="POST">
	<CFOUTPUT>
		<!-- all of these hidden fields are filled with the data from
		the form from newProject.cfm except option type which is "dept" --->
		<INPUT TYPE="hidden" NAME="optionType" VALUE="dept">
		<INPUT TYPE="hidden" NAME="projectType" VALUE="#Form.projectType#">
		<INPUT TYPE="hidden" NAME="province" VALUE="#Form.province#">
		<INPUT TYPE="hidden" NAME="location" VALUE="#Form.location#">
		<INPUT TYPE="hidden" NAME="description" VALUE="#Form.description#">
		<INPUT TYPE="hidden" NAME="department" VALUE="#Form.department#">
		<INPUT TYPE="hidden" NAME="secondDept" VALUE="#Form.secondDept#">
		<INPUT TYPE="hidden" NAME="clientContact" VALUE="#Form.clientContact#">
		<INPUT TYPE="hidden" NAME="agent" VALUE="#Form.agent#">
		<INPUT TYPE="hidden" NAME="startDate" VALUE="#Form.startDate#">
	</CFOUTPUT>
	<INPUT TYPE="hidden" NAME="deptName_required" VALUE="You must enter a department name.">
	<INPUT TYPE="hidden" NAME="deptAbbrev_required" VALUE="You must enter a department abbreviation.">
	<H2>&nbsp;Add a Department</H2>
	<table border="0" cellspacing="0" cellpadding="5" width="650"> 
		<tr>
			<td align="right">Department Name:</td>
			<td><INPUT TYPE="text" NAME="deptName" MAXLENGTH=75 SIZE=45></td>
		</tr>
		<tr>
			<td align="right">Department Abbreviation:</td>
			<td><INPUT TYPE="text" NAME="deptAbbrev" MAXLENGTH=12 SIZE=10></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><br>
			<a href="#" onClick="document.form1.submit(); return false"><img src="images/button_submit.gif" width="65" hight="25" border="0"></a>&nbsp;
			<a href="#" onClick="cancel(); return false;"><img src="images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
		</tr>
	</table>
	</FORM>
	</body>
	</html>

<CFELSEIF #Form.optionType# EQ "clientContact">
	<!--- Display the form for adding a client contact --->
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
	<head>
	<title>Add Client Contact</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">	

	<SCRIPT LANGUAGE="Javascript">
			
		// this function is called when a user clicks on the 
		// "Cancel" button.  It fills in the locName field with
		// a "*" because the locName field is required to have
		// something in it.
		function cancel() {
			document.form1.optionType.value = "cancel";
			document.form1.firstName.value= "*";
			document.form1.lastName.value= "*";
			document.form1.area.value= "*";
			document.form1.submit();
		}
			
	</SCRIPT>
	
	<!--- Include header.cfm which displays the top navigation menu as well as
	some javascript function and CSS --->
	<CFINCLUDE TEMPLATE="header.cfm">
	
	<FORM NAME="form1" ACTION="newProject.cfm" METHOD="POST">
	<CFOUTPUT>
		<!-- all of these hidden fields are filled with the data from
		the form from newProject.cfm except option type which is "clientContact" --->
		<INPUT TYPE="hidden" NAME="optionType" VALUE="clientContact">
		<INPUT TYPE="hidden" NAME="projectType" VALUE="#Form.projectType#">
		<INPUT TYPE="hidden" NAME="province" VALUE="#Form.province#">
		<INPUT TYPE="hidden" NAME="location" VALUE="#Form.location#">
		<INPUT TYPE="hidden" NAME="description" VALUE="#Form.description#">
		<INPUT TYPE="hidden" NAME="department" VALUE="#Form.department#">
		<INPUT TYPE="hidden" NAME="secondDept" VALUE="#Form.secondDept#">
		<INPUT TYPE="hidden" NAME="clientContact" VALUE="#Form.clientContact#">
		<INPUT TYPE="hidden" NAME="agent" VALUE="#Form.agent#">
		<INPUT TYPE="hidden" NAME="startDate" VALUE="#Form.startDate#">
	</CFOUTPUT>
	<INPUT TYPE="hidden" NAME="firstName_required" VALUE="You must enter a first name.">
	<INPUT TYPE="hidden" NAME="lastName_required" VALUE="You must enter a last name.">
	<H2>&nbsp;Add a Client Contact</H2>
	<table border="0" cellspacing="0" cellpadding="5" width="650"> 
		<tr>
			<td align="right" width="90">First Name:</td>
			<td><INPUT TYPE="text" NAME="firstName" MAXLENGTH=30 SIZE=30></td>
		</tr>
		<tr>
			<td align="right">Last Name:</td>
			<td><INPUT TYPE="text" NAME="lastName" MAXLENGTH=30 SIZE=30></td>
		</tr>
		<tr>
			<td align="right">Area:</td>
			<td><INPUT TYPE="text" NAME="area" MAXLENGTH=50 SIZE=40></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><br>
			<a href="#" onClick="document.form1.submit(); return false"><img src="images/button_submit.gif" width="65" hight="25" border="0"></a>&nbsp;
			<a href="#" onClick="cancel(); return false;"><img src="images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
		</tr>
	</table>
	</FORM>
	</body>
	</html>



</CFIF>
