<!--- Projects of all types can have many status updates. When the user 
clicks on the "Add New" or "Edit" buttons on status section of the project 
pages, they are taken to this page (via acquisitionSave.cfm, 
disposalSave.cfm, or consultingSave.cfm) where they fill out a simple form 
and click either "Submit" or "Cancel". The form is sent to the page 
specified in URL.type (either acquisitions.cfm, disposals.cfm.cfm or 
consulting.cfm). --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<head>
<title>Status Update</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<CFIF IsDefined("URL.statusID")>
<!--- then the user is editing a status so retrieve the status data --->
	<CFQUERY NAME="qryStatus" DATASOURCE="#request.ds#">
		SELECT	datUpdate,
				memStatus
		FROM	tblStatus
		WHERE	intStatusID = #URL.statusID#	
	</CFQUERY>	
</CFIF>

<!--- Include header.cfm which displays the top navigation menu as well as
some javascript functions and CSS --->
<CFINCLUDE TEMPLATE="header.cfm">

<CFOUTPUT><FORM NAME="form1" ACTION="#URL.type#.cfm?projectID=#URL.projectID#&view=status" METHOD="POST"></CFOUTPUT>
<INPUT TYPE="hidden" NAME="status_required" VALUE="You must enter a status memo.">
<INPUT TYPE="hidden" NAME="date_required" VALUE="You must enter a date.">
<INPUT TYPE="hidden" NAME="date_date" VALUE="The value you entered for <B>Date</B> is not a valid date (yyyy/m/d).">
<CFIF IsDefined("URL.add")>
<!--- then user is adding a new status update so include statusAdd field--->
	<INPUT TYPE="hidden" NAME="statusAdd" VALUE="yes">
	<H2>&nbsp;Add Status Update</H2>
<CFELSE>
<!--- then user is editing an old status so include statusUpdate and statusID fields --->
	<INPUT TYPE="hidden" NAME="statusUpdate" VALUE="yes">
	<INPUT TYPE="hidden" NAME="statusID" VALUE=<CFOUTPUT>#URL.statusID#</CFOUTPUT>>
	<H2>&nbsp;Edit Status Update</H2>
</CFIF>

<table border="0" cellspacing="0" cellpadding="5" width="650"> 
	<tr>
		<td align="right" width="90">Date:</td>
		<td><INPUT TYPE="text" NAME="date" SIZE=20<CFIF IsDefined("URL.statusID")><CFOUTPUT QUERY="qryStatus"> VALUE="#DateFormat(datUpdate, "yyyy/m/d")#"</CFOUTPUT><CFELSE><CFOUTPUT> VALUE="#DateFormat(Now(), "yyyy/m/d")#"</CFOUTPUT></CFIF>> <a class="norm" href="#" onClick="calendarWin=window.open('calendar.cfm?form=form1&field=date','calendarWin','width=165,height=175,toolbar=no,status=no,scrollbars=no'); return false;">pick a date</a></td>
	</tr>
	<tr>
		<td align="right" valign="top">Status:</td>
		<td><TEXTAREA NAME="status" ROWS=8 <CFIF browser EQ "MSIE">COLS=75<CFELSE>COLS=40</CFIF> WRAP="VIRTUAL"<CFIF browser EQ "MSIE"> style="font-size: 9pt; font-family: arial; color:#000000;"</CFIF>><CFIF IsDefined("URL.statusID")><CFOUTPUT QUERY="qryStatus">#memStatus#</CFOUTPUT></CFIF></TEXTAREA>
		</td>
	</tr>
	<tr>
		<td colspan="2" align="center"><br>
		<a href="nowhere.cfm" onClick="document.form1.submit(); return false"><img src="images/button_submit.gif" width="65" hight="25" border="0"></a>&nbsp;<a href="<CFOUTPUT>#URL.type#.cfm?projectID=#URL.projectID#&view=status</CFOUTPUT>"><img src="images/button_cancel.gif" width="65" hight="25" border="0"></a></td>
	</tr>
</table>
</FORM>
</body>
</html>
