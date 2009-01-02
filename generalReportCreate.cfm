<!---
this page is used to let the user choose the sort for 
the General Report, as well as indicate whether or not SSA Amount 
and Expenditures to Date information should be included in the report. 
When the user is done they can click "Submit" to view the formatted 
General Report and print it, or they can click "Cancel" to return to 
the Search Results.
--->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Create General Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!--- Include header.cfm which displays the top navigation menu as well as
some javascript function and CSS --->
<CFINCLUDE TEMPLATE="header.cfm">

<BR><h2>&nbsp;Create General Report</h2>
<FORM NAME="form1" ACTION="generalReport.cfm" METHOD="POST">
<table border="0" cellpadding="5" cellspacing="0">
	<tr>
		<td align="right">SSA Amount:</td>
		<td><INPUT TYPE="text" NAME="SSA" SIZE="20"></td>
	</tr>
	<tr>
		<td align="right">YTD Expenditures:</td>
		<td><INPUT TYPE="text" NAME="expenditures" SIZE="20"></td>
	</tr>
	<tr>
		<td align="right">Include SSA Amount and <br>Expenditures to Date?:</td>
		<td valign="bottom"><INPUT TYPE="checkbox" NAME="include" VALUE="yes" CHECKED></td>
	</tr>
	<tr>
		<td align="right">Sort:</td>
		<td>
			<SELECT NAME="sort">
				<OPTION VALUE="location" SELECTED>Location</OPTION>
				<OPTION VALUE="clientContact">Area Chief</OPTION>			
				<OPTION VALUE="agent">Advisor</OPTION>
			</SELECT>
		</td>
	</tr>
	<tr>
		<td align="center" colspan="2"><br><a href="nowhere.cfm" onClick="document.form1.submit(); alert('When printing, please ensure that the printer settings are \nset to Landscape orientation and Legal paper size. \n\nClick \'\'Menu\'\' and then \'\'Help\'\' for more information.'); return false"><img src="images/button_submit.gif" width="65" hight="25" border="0"></a>&nbsp;<a href="projectList.cfm"><img src="images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
	</tr>
</table>
</FORM>
</body>
</html>
