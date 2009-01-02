<!--- band update is called by disposalSave.cfm via disposals.cfm when a 
user clicks on "Add New Band" or "Edit Band Info". If the user is editing 
a band, the form on bandUpdate.cfm will be filled with data from tblBand. 
Otherwise, the form will be blank. When the user is done they can click 
"Submit" or "Cancel" to return to disposals.cfm. --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Band Update</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<CFIF IsDefined("URL.bandID")>
	<!--- then user is editing a band so retrieve the band data --->
	<CFQUERY NAME="qryBand" DATASOURCE="#request.ds#">
		SELECT	*
		FROM	tblBand
		WHERE	intBandID = #URL.bandID#	
	</CFQUERY>	
</CFIF>

<!--- Include header.cfm which displays the top navigation menu as well as
some javascript function and CSS --->
<CFINCLUDE TEMPLATE="header.cfm">

<CFOUTPUT><FORM NAME="form1" ACTION="disposals.cfm?projectID=#URL.projectID#&view=firstNations" METHOD="POST"></CFOUTPUT>
<CFIF IsDefined("URL.add")>
	<!--- user is adding a new band so define hidden field to
	tell disposals.cfm that we are adding a band --->
	<INPUT TYPE="hidden" NAME="bandAdd" VALUE="yes">
	<INPUT TYPE="hidden" NAME="bandName_required" VALUE="You must enter a band name.">
	<H2>&nbsp;Add Band</H2>
<CFELSE>
	<!--- user is editing a new band so define hidden field to
	tell disposals.cfm that we are editing a band --->
	<INPUT TYPE="hidden" NAME="bandUpdate" VALUE="yes">
	<INPUT TYPE="hidden" NAME="bandID" VALUE=<CFOUTPUT>#URL.bandID#</CFOUTPUT>>
	<H2>&nbsp;Edit Band</H2>
</CFIF>
<table border="0" cellspacing="0" cellpadding="5" width="650"> 
	<tr>
		<td align="right" width="90">Band Name:</td>
		<td><CFIF IsDefined("URL.bandID")><CFOUTPUT QUERY="qryBand">#strBandName#</CFOUTPUT><CFELSE><INPUT TYPE="text" NAME="bandName" SIZE=20></CFIF></td>
	</tr>
	<tr>
		<td align="right" width="90">Chief Name:</td>
		<td><INPUT TYPE="text" NAME="chiefName" SIZE=30<CFIF IsDefined("URL.bandID")><CFOUTPUT QUERY="qryBand"> VALUE="#strChiefName#"</CFOUTPUT></CFIF>></td>
	</tr>
	<tr>
		<td align="right" width="90">Contact Name:</td>
		<td><INPUT TYPE="text" NAME="contact" SIZE=30<CFIF IsDefined("URL.bandID")><CFOUTPUT QUERY="qryBand"> VALUE="#strContact#"</CFOUTPUT></CFIF>></td>
	</tr>
	<tr>
		<td align="right" width="90">Address:</td>
		<td><INPUT TYPE="text" NAME="address" SIZE=30<CFIF IsDefined("URL.bandID")><CFOUTPUT QUERY="qryBand"> VALUE="#strAddress#"</CFOUTPUT></CFIF>></td>
	</tr>
	<tr>
		<td align="right" width="90">Phone Number:</td>
		<td><INPUT TYPE="text" NAME="phone" SIZE=20<CFIF IsDefined("URL.bandID")><CFOUTPUT QUERY="qryBand"> VALUE="#strPhone#"</CFOUTPUT></CFIF>></td>
	</tr>
	<tr>
		<td align="right" width="90">Fax Number:</td>
		<td><INPUT TYPE="text" NAME="fax" SIZE=20<CFIF IsDefined("URL.bandID")><CFOUTPUT QUERY="qryBand"> VALUE="#strFax#"</CFOUTPUT></CFIF>></td>
	</tr>
	<tr>
		<td align="right" width="90">E-mail:</td>
		<td><INPUT TYPE="text" NAME="email" SIZE=20<CFIF IsDefined("URL.bandID")><CFOUTPUT QUERY="qryBand"> VALUE="#strEmail#"</CFOUTPUT></CFIF>></td>
	</tr>
	<tr>
		<td colspan="2" align="center"><br>
		<a href="nowhere.cfm" onClick="document.form1.submit(); return false"><img src="images/button_submit.gif" width="65" hight="25" border="0"></a>&nbsp;<a href="disposals.cfm?projectID=<CFOUTPUT>#URL.projectID#</CFOUTPUT>&view=firstNations"><img src="images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
	</tr>
</table>
</FORM>
</body>
</html>
