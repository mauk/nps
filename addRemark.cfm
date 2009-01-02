<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Add First Nations Consultations Remark</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<CFQUERY NAME="qryBandNames" DATASOURCE="#request.ds#">
	SELECT	intBandID,
			strBandName
	FROM	tblBand
	WHERE	intProjectID = #URL.projectID#
	ORDER BY strBandName
</CFQUERY>
<CFQUERY NAME="qryAgent" DATASOURCE="#request.ds#">
	SELECT		intAgentID,
				strFirstName,
				strLastName
	FROM 		tblAgent
	WHERE		intAgentID = #Client.Employee_ID#
</CFQUERY>

<!--- Include header.cfm which displays the top navigation menu as well as
some javascript function and CSS --->
<CFINCLUDE TEMPLATE="header.cfm">

<CFOUTPUT><FORM NAME="form1" ACTION="disposals.cfm?projectID=#URL.projectID#&view=firstNations" METHOD="POST"></CFOUTPUT>
<INPUT TYPE="hidden" NAME="bandID_required" VALUE="You must select a band.">
<INPUT TYPE="hidden" NAME="remark_required" VALUE="You must enter a remark.">
<INPUT TYPE="hidden" NAME="remarkAdd" VALUE="yes"><!--- tells disposals.cfm to run query --->
<INPUT TYPE="hidden" NAME="remarkDate" VALUE=<CFOUTPUT>"#DateFormat(Now(), "yyyy/m/d")#</CFOUTPUT>">
<INPUT TYPE="hidden" NAME="agentID" VALUE="<CFOUTPUT QUERY="qryAgent">#intAgentID#</CFOUTPUT>">
<H2>&nbsp;Add Remark</H2>

<table border="0" cellspacing="0" cellpadding="5" width="650"> 
	<tr>
		<td align="right" width="90">Band Name:</td>
		<td>
			<SELECT NAME="bandID">
				<CFOUTPUT QUERY="qryBandNames">
				<OPTION VALUE=#intBandID#<CFIF #intBandID# EQ #URL.bandID#> SELECTED</CFIF>>#strBandName#</OPTION>
				</CFOUTPUT>
			</SELECT>
		</td>
	</tr>
	<tr>
		<td align="right" width="90">Date:</td>
		<td><CFOUTPUT>#DateFormat(Now(), "yyyy/m/d")#</CFOUTPUT></td>
	</tr>
	<tr>
		<td align="right" width="90">By:</td>
		<td><CFOUTPUT QUERY="qryAgent">#strFirstName# #strLastName#</CFOUTPUT>
	</tr>
	<tr>
		<td align="right" width="90" valign="top">Remark:</td>
		<td><TEXTAREA NAME="remark" ROWS=4 <CFIF browser EQ "MSIE">COLS=70<CFELSE>COLS=40</CFIF> WRAP="VIRTUAL"<CFIF browser EQ "MSIE"> style="font-size: 9pt; font-family: arial; color:#000000;"</CFIF>></TEXTAREA></td>
	</tr>
	<tr>
		<td colspan="2" align="center"><br>
		<a href="nowhere.cfm" onClick="if (confirm('Are you sure you want to add this remark?\nYou will not be able to edit or delete it.')) {document.form1.submit();} return false"><img src="images/button_submit.gif" width="65" hight="25" border="0"></a>&nbsp;<a href="disposals.cfm?projectID=<CFOUTPUT>#URL.projectID#</CFOUTPUT>&view=firstNations"><img src="images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
	</tr>
</table>
</FORM>
</body>
</html>
