<!--- calendar.cfm is called in a pop-up window, and allows the user to click on 
a date and have that date entered into a form field. The hyperlinks that request 
calendar.cfm pass it querystring parameters that tell it which field to put the 
date into. --->

<!--- First, we need to obtain the current date passed through the QueryString. --->
<CFIF IsDefined("URL.date")>
	<CFSET dbCurrentDate = CreateDate(Left(URL.date, 4), Right(URL.date, 2), 1)>
<CFELSE>
	<CFSET dbCurrentDate = Now()>
</CFIF>

<!--- We will create an array that will store the 42 possible days of the month. --->
<CFSET aCalendarDays = ArrayNew(1)>
<!--- Into aCalendarDays, we will place the days of the current
	  month.  We will use the DatePart function to determine
      when the first day of the month is --->
<CFSET iCurrentMonth = Month(dbCurrentDate)>
<CFSET iCurrentYear = Year(dbCurrentDate)>
<CFSET iFirstWeekDay = DatePart("w", CreateDate(iCurrentYear, iCurrentMonth, 1)) - 1>

<!--- First we want to loop through the days in the array, that
      are before the first day of the month and populate them with 0 --->
<CFSET iDaysInMonth = DaysInMonth(dbCurrentDate)>
<CFLOOP INDEX="iLoop" FROM="1" TO="#iFirstWeekDay#">
	<CFSET temp = ArrayAppend(aCalendarDays, 0)>
</CFLOOP>
<!--- Now, we want to loop from 1 to the number of days in the 
      current month, appending iLoop to the array aCalendaDays --->
<CFLOOP INDEX="iLoop" FROM="1" TO=#iDaysInMonth#>
	<CFSET temp = ArrayAppend(aCalendarDays, iLoop)>
</CFLOOP>
<!--- Now we want to loop through the rest of the days that are
      after the last day of the month up to 42 and populate them with 0 --->
<CFSET iExtra = 42 - ArrayLen(aCalendarDays)>
<CFLOOP INDEX="iLoop" FROM="1" TO=#iExtra#>
	<CFSET temp = ArrayAppend(aCalendarDays, 0)>
</CFLOOP>

<!--- Now that we have our populated array, we need to display the
      array in calendar form. We will create a table of 7 columns,
      one for each day of the week.  The number of rows we will use
      will be 6  (the total number of possible rows) minus 42 (the upper
      bound of the aCalendarDays array) minus the last array position
      used (iFirstWeekday + iDaysInMonth) divided by seven (the number of
      days in the week). --->
<CFSET iColumns = 7>
<CFSET iRows = 6 - Int((42 - (iFirstWeekDay + iDaysInMonth)) / 7)>

<!--- We want to create the QueryString value that will be used to find
      the next and previous months.  These are in the format "yyyymm" --->
<CFSET strPrevMonth = DatePart("m", DateAdd("m", -1, dbCurrentDate))>
<!--- make sure the month is 2 digits --->
<CFIF Len(strPrevMonth) EQ 1>
	<CFSET strPrevMonth = "0" & strPrevMonth>
</CFIF>
<CFSET strPrevDate = DatePart("yyyy", DateAdd("m", -1, dbCurrentDate)) & strPrevMonth>

<CFSET strNextMonth = DatePart("m", DateAdd("m", 1, dbCurrentDate))>
<!--- make sure the month is 2 digits --->
<CFIF Len(strNextMonth) EQ 1>
	<CFSET strNextMonth = "0" & strNextMonth>
</CFIF>
<CFSET strNextDate = DatePart("yyyy", DateAdd("m", 1, dbCurrentDate)) & strNextMonth>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"> 
<html>
<HEAD>
<TITLE>Calendar</TITLE>

<SCRIPT LANGUAGE="JavaScript">
<!--

function newImage(arg) {
// function is used by preloadImages()
	if (document.images) {
		rslt = new Image();
		rslt.src = arg;
		return rslt;
	}
}

function changeImages() {
// function is used to swap images for rollover images
	if (document.images && (preloadFlag == true)) {
		for (var i=0; i<changeImages.arguments.length; i+=2) {
			document[changeImages.arguments[i]].src = changeImages.arguments[i+1];
		}
	}
}

var preloadFlag = false;
function doPreload() {
// build the array of images to preload
   var the_images = new Array('calendar/calendar_b_1.gif',
                              'calendar/calendar_b_2.gif',
                              'calendar/calendar_b_3.gif',
                              'calendar/calendar_b_4.gif',
                              'calendar/calendar_b_5.gif',
                              'calendar/calendar_b_6.gif',
                              'calendar/calendar_b_7.gif',
                              'calendar/calendar_b_8.gif',
                              'calendar/calendar_b_9.gif',
                              'calendar/calendar_b_10.gif',
                              'calendar/calendar_b_11.gif',
                              'calendar/calendar_b_12.gif',
                              'calendar/calendar_b_13.gif',
                              'calendar/calendar_b_14.gif',
                              'calendar/calendar_b_15.gif',
                              'calendar/calendar_b_16.gif',
                              'calendar/calendar_b_17.gif',
                              'calendar/calendar_b_18.gif',
                              'calendar/calendar_b_19.gif',
                              'calendar/calendar_b_20.gif',
                              'calendar/calendar_b_21.gif',
                              'calendar/calendar_b_22.gif',
                              'calendar/calendar_b_23.gif',
                              'calendar/calendar_b_24.gif',
                              'calendar/calendar_b_25.gif',
                              'calendar/calendar_b_26.gif',
                              'calendar/calendar_b_27.gif',
                              'calendar/calendar_b_28.gif',
                              'calendar/calendar_b_29.gif',
                              'calendar/calendar_b_30.gif',
                              'calendar/calendar_b_31.gif');
   preloadImages(the_images);
   preloadFlag = true;
}

function preloadImages(the_images_array) {
// loop through the array built in doPreload() and
// create a new image for each using newImage().
   for(var loop = 0; loop < the_images_array.length; loop++)
	
   {
 	var an_image = newImage(the_images_array[loop]);
   }
}

// -->
</SCRIPT>

<!--- find browser version --->
<cfparam name="attributes.user_agent" default="#cgi.http_user_agent#">
<cfscript>
	attributes.browserName="Unknown";
	attributes.browserVersion="0";
	if (Len(attributes.user_agent)) {
		if (Find("MSIE",attributes.user_agent)) { // it's a Microsoft browser
			attributes.browserName="MSIE";
			attributes.browserVersion=Val(RemoveChars(attributes.user_agent,1,Find("MSIE",attributes.user_agent)+4));
		}
		else {
			if (Find("Mozilla",attributes.user_agent)) { // it's a Netscape compatible browser
				if (not Find("compatible",attributes.user_agent)) { // its probably a Netscape browser
					attributes.browserName="Netscape";
					attributes.browserVersion=Val(RemoveChars(attributes.user_agent,1,Find("/",attributes.user_agent)));
				}
				else {
					attributes.browserName="compatible"; // not Netscape
				}
			}
			if (Find("ColdFusion",attributes.user_agent)) { // Customisation sample - detection of Colf Fusion Scheduler or CFHTTP tag
				attributes.browserName="ColdFusion";
			}
		}
	}
	// for using as tag or module
	caller.browserName=attributes.browserName;
	caller.browserVersion=attributes.browserVersion;
</cfscript>

<!--- set browser version and name variables --->
<cfset browser = "#caller.browserName#">
<cfset version = "#caller.browserVersion#">

</HEAD>
<BODY  topmargin="0" leftmargin="0" marginheight="0" marginwidth="0" ONLOAD="doPreload();">

<TABLE BORDER=0 CELLSPACING=0 WIDTH=141 ALIGN="center">
	<TR>
		<TD WIDTH="18"><img src="calendar/spacer.gif" width="18" height="1"></TD>
		<TD WIDTH="105"><img src="calendar/spacer.gif" width="105" height="1"></TD>
		<TD WIDTH="18"><img src="calendar/spacer.gif" width="18" height="1"></TD>      
	</TR>
	<TR> 
		<TD WIDTH="18" ALIGN="center" VALIGN="middle">
			<!--- link to last month consists of URL.tab (if it exists), URL.form, URL.field, and strPrevDate --->
			<A HREF="calendar.cfm?<CFOUTPUT><CFIF IsDefined("URL.tab")>tab=#URL.tab#&</CFIF>form=#URL.form#&field=#URL.field#&Date=#strPrevDate#</CFOUTPUT>"><IMG SRC="calendar/leftArrow.gif" WIDTH=15 HEIGHT=15 BORDER=0></A>
		</TD>
		<TD ALIGN="center" WIDTH="105">
			<FONT SIZE=2 FACE="ARIAL"><B>
			<CFOUTPUT>
				#MonthAsString(iCurrentMonth)# #iCurrentYear#
			</CFOUTPUT>
			</B></FONT>
		</TD> 
		<TD WIDTH="18" ALIGN="center" VALIGN="middle">
			<!--- link to last month consists of URL.tab (if it exists), URL.form, URL.field, and strPrevDate --->
			<A HREF="calendar.cfm?<CFOUTPUT><CFIF IsDefined("URL.tab")>tab=#URL.tab#&</CFIF>form=#URL.form#&field=#URL.field#&Date=#strNextDate#</CFOUTPUT>"><IMG SRC="calendar/rightArrow.gif" WIDTH=15 HEIGHT=15 BORDER=0></A>
		</TD>
	</TR>
	<TR>
		<TD COLSPAN="3">
			<TABLE border="0" cellpadding="0" cellspacing="0" width="141" algin="center">
				<tr>
					<td colspan="8"><img src="calendar/top.gif" width="140" height="20" border="0"></td>
				</tr>
				<TR>
					<td bgcolor="#999999"><img src="calendar/spacer.gif" width="1" height="1" border="0"></td>
					<td bgcolor="#999999"><img src="calendar/spacer.gif" width="20" height="1" border="0"></td>
					<td bgcolor="#999999"><img src="calendar/spacer.gif" width="20" height="1" border="0"></td>
					<td bgcolor="#999999"><img src="calendar/spacer.gif" width="20" height="1" border="0"></td>
					<td bgcolor="#999999"><img src="calendar/spacer.gif" width="20" height="1" border="0"></td>
					<td bgcolor="#999999"><img src="calendar/spacer.gif" width="20" height="1" border="0"></td>
					<td bgcolor="#999999"><img src="calendar/spacer.gif" width="20" height="1" border="0"></td>
					<td bgcolor="#999999"><img src="calendar/spacer.gif" width="20" height="1" border="0"></td>
				</TR>
<!--- loop through the number of rows --->				
<CFLOOP INDEX="iRowsLoop" FROM="1" TO=#iRows#>
				<tr>
					<td bgcolor="#999999"><img src="calendar/spacer.gif" width="1" height="20" border="0"></td>
	<!--- for each row, loop through the number of columns --->
	<CFLOOP INDEX="iColumnsLoop" FROM="1" TO=#iColumns#>
		<!--- set the iDay to the current day of the month --->
		<CFSET iDay = aCalendarDays[(iRowsLoop - 1)*7 + iColumnsLoop]>
		<CFIF iDay GT 0>
			<!--- iDay is not 0 so this is a real day --->
			<CFIF iDay EQ DatePart("d", Now()) AND (DatePart("m", dbCurrentDate) EQ DatePart("m", Now())) AND (DatePart("yyyy", dbCurrentDate) EQ DatePart("yyyy", Now()))>
				<!--- iDay equals today's date so the cell is orange --->
					<td>
						<!--- 
							If the browser is MSIE, the field can be referenced like so:
								"window.opener.document.formName.fieldName.value"
							Otherwise the field must be referenced like so (if the form is on a layer):
								"window.opener.document.layerName.document.formName.fieldName.value" 
						--->
						<CFIF browser EQ "MSIE">
							<a href="#"
								ONMOUSEOVER="changeImages('calendar_o_<CFOUTPUT>#iDay#</CFOUTPUT>', 'calendar/calendar_b_<CFOUTPUT>#iDay#</CFOUTPUT>.gif');"
								ONMOUSEOUT="changeImages('calendar_o_<CFOUTPUT>#iDay#</CFOUTPUT>', 'calendar/calendar_o_<CFOUTPUT>#iDay#</CFOUTPUT>.gif');"
								ONCLICK="window.opener.document.<CFOUTPUT>#URL.form#.#URL.field#</CFOUTPUT>.value='<CFOUTPUT><CFIF IsDefined("URL.asText")>#MonthAsString(iCurrentMonth)# #iDay#, #iCurrentYear#<CFELSE>#iCurrentYear#/#iCurrentMonth#/#iDay#</CFIF></CFOUTPUT>'; window.close(); return false;">
						<CFELSE>
							<a href="#"
								ONMOUSEOVER="changeImages('calendar_o_<CFOUTPUT>#iDay#</CFOUTPUT>', 'calendar/calendar_b_<CFOUTPUT>#iDay#</CFOUTPUT>.gif');"
								ONMOUSEOUT="changeImages('calendar_o_<CFOUTPUT>#iDay#</CFOUTPUT>', 'calendar/calendar_o_<CFOUTPUT>#iDay#</CFOUTPUT>.gif');"
								ONCLICK="window.opener.<CFOUTPUT><CFIF IsDefined("URL.tab")>document.#URL.tab#.</CFIF>document.#URL.form#.#URL.field#</CFOUTPUT>.value='<CFOUTPUT><CFIF IsDefined("URL.asText")>#MonthAsString(iCurrentMonth)# #iDay#, #iCurrentYear#<CFELSE>#iCurrentYear#/#iCurrentMonth#/#iDay#</CFIF></CFOUTPUT>'; window.close(); return false;">
						</CFIF>
							<img name="calendar_o_<CFOUTPUT>#iDay#</CFOUTPUT>" src="calendar/calendar_o_<CFOUTPUT>#iDay#</CFOUTPUT>.gif" width="20" height="20" border="0"></A></TD>
			<CFELSE>
				<!--- iDay equals a date other than today's so the cell is white --->
					<td>
						<!--- 
							If the browser is MSIE, the field can be referenced like so:
								"window.opener.document.formName.fieldName.value"
							Otherwise the field must be referenced like so (if the form is on a layer):
								"window.opener.document.layerName.document.formName.fieldName.value" 
						--->
						<CFIF browser EQ "MSIE">
							<a href="#"
								ONMOUSEOVER="changeImages('calendar_w_<CFOUTPUT>#iDay#</CFOUTPUT>', 'calendar/calendar_b_<CFOUTPUT>#iDay#</CFOUTPUT>.gif');"
								ONMOUSEOUT="changeImages('calendar_w_<CFOUTPUT>#iDay#</CFOUTPUT>', 'calendar/calendar_w_<CFOUTPUT>#iDay#</CFOUTPUT>.gif');"
								ONCLICK="window.opener.document.<CFOUTPUT>#URL.form#.#URL.field#</CFOUTPUT>.value='<CFOUTPUT><CFIF IsDefined("URL.asText")>#MonthAsString(iCurrentMonth)# #iDay#, #iCurrentYear#<CFELSE>#iCurrentYear#/#iCurrentMonth#/#iDay#</CFIF></CFOUTPUT>'; window.close(); return false;">
						<CFELSE>
							<a href="#"
								ONMOUSEOVER="changeImages('calendar_w_<CFOUTPUT>#iDay#</CFOUTPUT>', 'calendar/calendar_b_<CFOUTPUT>#iDay#</CFOUTPUT>.gif');"
								ONMOUSEOUT="changeImages('calendar_w_<CFOUTPUT>#iDay#</CFOUTPUT>', 'calendar/calendar_w_<CFOUTPUT>#iDay#</CFOUTPUT>.gif');"
								ONCLICK="window.opener.<CFOUTPUT><CFIF IsDefined("URL.tab")>document.#URL.tab#.</CFIF>document.#URL.form#.#URL.field#</CFOUTPUT>.value='<CFOUTPUT><CFIF IsDefined("URL.asText")>#MonthAsString(iCurrentMonth)# #iDay#, #iCurrentYear#<CFELSE>#iCurrentYear#/#iCurrentMonth#/#iDay#</CFIF></CFOUTPUT>'; window.close(); return false;">
						</CFIF>
							<img name="calendar_w_<CFOUTPUT>#iDay#</CFOUTPUT>" src="calendar/calendar_w_<CFOUTPUT>#iDay#</CFOUTPUT>.gif" width="20" height="20" border="0"></A></TD>
			</CFIF>
		<CFELSE>
			<!--- iDay equals 0 so this cell should be black --->
					<td><img name="calendar_black" src="calendar/calendar_black.gif" width="20" height="20" border="0"></TD>
		</CFIF>
	</CFLOOP>
				</tr>
</CFLOOP>


			</TABLE>
		</TD>
	</TR>
</TABLE>
</BODY>
</HTML>

