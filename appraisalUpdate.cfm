<!--- appraisalUpdate.cfm is called when the user clicks on the "Add New" 
or "Edit" buttons located in the Appraisal Info section on acquisitions.cfm. 
It checks the querystring parameters to see if the user is adding or editing 
an Appraisal. When the user fills out the form they can click "Submit" or 
"Cancel" to return to acquisitions.cfm where a query will add a new appraisal 
or edit an existing one. --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Appraisal Update</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<CFIF IsDefined("URL.appraisalID")>
	<!--- then user is editing an appraisal so retrieve the data --->
	<CFQUERY NAME="qryAppraisal" DATASOURCE="#request.ds#">
		SELECT	datApprDate,
				curApprAmount,
				strApprName,
				strAppraisalNo
		FROM	tblAppraisals
		WHERE	intApprID = #URL.appraisalID#	
	</CFQUERY>	
</CFIF>

<!--- Include header.cfm which displays the top navigation menu as well as
some javascript function and CSS --->
<CFINCLUDE TEMPLATE="header.cfm">

<!--- #URL.type# is not necessary as only acquisitions currently have appraisals,
but if this changes, then #URL.type# will be necessary --->
<!--- <CFOUTPUT><FORM NAME="form1" <CFIF #URL.type# EQ "acquisitions">ACTION="#URL.type#.cfm?projectID=#URL.projectID#&view=purchase"
							 <CFELSE>ACTION="#URL.type#.cfm?projectID=#URL.projectID#&view=purchase"</CFIF>
			METHOD="POST">
</CFOUTPUT> --->
<!--- <CFOUTPUT><FORM NAME="form1" ACTION="#URL.type#.cfm?projectID=#URL.projectID#&view=<CFIF #URL.type# EQ "acquisitions">purchase"<CFELSE>hq"</CFIF></CFOUTPUT> ---> 
<!--- <CFOUTPUT><FORM NAME="form1" ACTION="#URL.type#.cfm?projectID=#URL.projectID#&view=purchase" METHOD="POST"></CFOUTPUT> --->
<cfif #URL.type# EQ "acquisitions">
	<CFOUTPUT><FORM NAME="form1" ACTION="#URL.type#.cfm?projectID=#URL.projectID#&view=purchase" METHOD="POST"></CFOUTPUT>
<cfelse>
	<CFOUTPUT><FORM NAME="form1" ACTION="#URL.type#.cfm?projectID=#URL.projectID#&view=hq" METHOD="POST"></CFOUTPUT>
</cfif>
<INPUT TYPE="hidden" NAME="value_required" VALUE="You must enter an Appraised Value.">
<INPUT TYPE="hidden" NAME="date_date" VALUE="You must enter a proper date (yyyy/m/d) in the Appraisal Date field.">
<INPUT TYPE="hidden" NAME="date_required" VALUE="You must enter an Appraisal Date.">
<CFIF IsDefined("URL.add")>
	<!--- user is adding a new appraisal so define hidden field to
	tell acquisitions.cfm that we are adding an appraisal --->
	<INPUT TYPE="hidden" NAME="appraisalAdd" VALUE="yes">
	<H2>&nbsp;Add Appraisal</H2>
<CFELSE>
	<!--- user is editing an appraisal so define hidden field to
	tell acquisitions.cfm that we are editing an appraisal --->
	<INPUT TYPE="hidden" NAME="appraisalUpdate" VALUE="yes">
	<INPUT TYPE="hidden" NAME="appraisalID" VALUE=<CFOUTPUT>#URL.appraisalID#</CFOUTPUT>>
	<H2>&nbsp;Edit Appraisal</H2>
</CFIF>

<!--- added this 
The URL type is.... <CFOUTPUT>#URL.type#</CFOUTPUT>
<CFIF #URL.type# EQ "acquisitions">Cool...this works<CFELSE>Boo..this doesn't work</CFIF>--->

<table border="0" cellspacing="0" cellpadding="5" width="650"> 
	<tr>
		<td align="right">Date:</td>
		<td><INPUT TYPE="text" NAME="date" SIZE=20<CFIF IsDefined("URL.appraisalID")><CFOUTPUT QUERY="qryAppraisal"> VALUE="#DateFormat(datApprDate, "yyyy/m/d")#"</CFOUTPUT><CFELSE><CFOUTPUT> VALUE="#DateFormat(Now(), "yyyy/m/d")#"</CFOUTPUT></CFIF>> <a class="norm" href="#" onClick="calendarWin=window.open('calendar.cfm?form=form1&field=date','calendarWin','width=165,height=175,toolbar=no,status=no,scrollbars=no'); return false;">pick a date</a></td>
	</tr>
	<tr>
		<td align="right">Value:</td>
		<td><INPUT TYPE="text" NAME="value" SIZE=20<CFIF IsDefined("URL.appraisalID")><CFOUTPUT QUERY="qryAppraisal"> VALUE="#DollarFormat(curApprAmount)#"</CFOUTPUT></CFIF>>
		</td>
	</tr>
	<tr>
		<td align="right">Appraiser Name:</td>
		<td><INPUT TYPE="text" NAME="apprName" SIZE=20 MAXLENGTH=50<CFIF IsDefined("URL.appraisalID")><CFOUTPUT QUERY="qryAppraisal"> VALUE="#strApprName#"</CFOUTPUT></CFIF>></td>
	</tr>
	<tr>
		<td align="right">Appraisal Number:</td>
		<td><INPUT TYPE="text" NAME="apprNo" SIZE=20 MAXLENGTH=40<CFIF IsDefined("URL.appraisalID")><CFOUTPUT QUERY="qryAppraisal"> VALUE="#strAppraisalNo#"</CFOUTPUT></CFIF>></td>
	</tr>
	<tr>
		<td colspan="2" align="center"><br>
		<a href="nowhere.cfm" onClick="document.form1.submit(); return false"><img src="images/button_submit.gif" width="65" hight="25" border="0"></a>&nbsp;<a href="<CFOUTPUT>#URL.type#.cfm?projectID=#URL.projectID#&view=purchase</CFOUTPUT>"><img src="images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
	</tr>
</table>
</FORM>
</body>
</html>
