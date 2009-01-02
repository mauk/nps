<!--- 
This page is at the top of almost every page in the system.  It displays the 
a title and top navigation menu's.  It also sets some CSS properties that are used
throughout the site and sets some browser detection variables.
--->

<!--- check browser version --->
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

<!--- set datLastVisit field in the agent table --->
<CFIF Client.LoggedIn EQ "Yes">
	<CFQUERY NAME="qryLastVisit" DATASOURCE="#request.ds#">
		UPDATE	tblAgent
		SET		datLastVisit = ###DateFormat(Now(), "yyyy/m/d")###
		WHERE	intAgentID = #Client.Employee_ID#
	</CFQUERY>
</CFIF>

<STYLE TYPE="text/css">
<!--- If the browser is IE, leave out the line-height property as it does not display well --->
<CFIF browser EQ "MSIE">
A.menuLink:link {font-family: Helvetica, sans-serif; font-size: 9pt; color: #0066CC; text-decoration: underline;}
A.menuLink:visited {font-family: Helvetica, sans-serif; font-size: 9pt; color: #0066CC; text-decoration: underline;}
A.menuLink:hover {font-family: Helvetica, sans-serif; font-size: 9pt; color: #ff9900; text-decoration: underline;}
A.menuLink:active {font-family: Helvetica, sans-serif; font-size: 9pt; color: #ff9900; text-decoration: underline;}
<CFELSE>
A.menuLink:link {font-family: Helvetica, sans-serif; font-size: 9pt; line-height: 13pt; color: #0066CC; text-decoration: underline;}
A.menuLink:visited {font-family: Helvetica, sans-serif; font-size: 9pt; line-height: 13pt; color: #0066CC; text-decoration: underline;}
A.menuLink:hover {font-family: Helvetica, sans-serif; font-size: 9pt; line-height: 13pt; color: #ff9900; text-decoration: underline;}
A.menuLink:active {font-family: Helvetica, sans-serif; font-size: 9pt; line-height: 13pt; color: #ff9900; text-decoration: underline;}
</CFIF>
A.norm:link {color: #0066CC; text-decoration: underline;}
A.norm:visited {color: #0066CC; text-decoration: underline;}
A.norm:hover {color: #ff9900; text-decoration: underline;}
A.norm:active {color: #ff9900; text-decoration: underline;}

BODY {font-family: Helvetica; font-size: 9pt;}
P {font-family: Helvetica; font-size: 9pt;}
TABLE, TR, TD {font-family: Helvetica; font-size: 9pt;}
H2 {font-family: Helvetica; font-size: 16pt; font-weight: bold;}

.text1 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; line-height: 14pt;}
<!--- Define classes for the menu's.  The positions of menus 2 & 3 depend
	  on whether menu 1 and 2 are availble. ---> 
.menu1 {width: 105px; visibility: hidden; layer-background-color:white; background-color: white; position: absolute; left: 2; top: 60; z-index: 90;}
.menu2 {width: 105px; visibility: hidden; layer-background-color:white; background-color: white; position: absolute; left: 50; top: 60; z-index: 90;}
.menu3 {width: 105px; visibility: hidden; layer-background-color:white; background-color: white; position: absolute; left: <CFIF #getfilefrompath(getbasetemplatepath())# EQ "projectList.cfm" OR #getfilefrompath(getbasetemplatepath())# EQ "acquisitions.cfm"OR #getfilefrompath(getbasetemplatepath())# EQ "disposals.cfm"OR #getfilefrompath(getbasetemplatepath())# EQ "consulting.cfm">98<CFELSE>50</CFIF>; top: 60; z-index: 90;}
</style>

<script language="Javascript">

// make code cross browser compatible by setting
// variables for use when setting the visibility of objects.
if (document.layers) { // browser is Netscape
	visible = 'show';
	hidden = 'hide';
} else if (document.all) { // browser is IE
	visible = 'visible';
	hidden = 'hidden';
}

var lastMenu;

function menuToggle(menu) {
// This function is used to toggle the menu's on and off

	if (document.layers) { // browser is Netscape
		daMenu = document.layers[menu];
	} 
	else if (document.all) { // browser is IE
		daMenu = document.all(menu).style;
	} 

	// if the last menu is not the current menu
	// then hide it
	if (lastMenu && lastMenu != daMenu) {
		lastMenu.visibility = hidden;
	}

	// if the current menu is visible then
	// hide it
	if (daMenu.visibility == visible) {
		daMenu.visibility = hidden;
		lastMenu = null;
	}
	// otherwise show it
	else {
		daMenu.visibility = visible;
		lastMenu = daMenu;
	}
}

function changeImages() {
// function used to swap images for rollover buttons
	if (document.images && (preloadFlag == true)) {
		for (var i=0; i<changeImages.arguments.length; i+=2) {
			document[changeImages.arguments[i]].src = changeImages.arguments[i+1];
		}
	}
}

function newImage(arg) {
// function used to create new image objects by preloadImages()
	if (document.images) {
		rslt = new Image();
		rslt.src = arg;
		return rslt;
	}
}

var preloadFlag = false;
function preloadImages() {
// preload images for fast rollovers
	if (document.images) {
		menuOver = newImage("images/button_menu_over.gif");
		printOver = newImage("images/button_print_over.gif");
		adminOver = newImage("images/button_admin_over.gif");
		linksOver = newImage("images/button_links_over.gif");
	<!--- preload the tab images for fast loading --->
	<CFIF #getfilefrompath(getbasetemplatepath())# EQ "disposals.cfm">
		project = newImage("imges/tab_project.gif");
		property = newImage("images/tab_property_on.gif");
		HQ = newImage("images/tab_HQ_on.gif");
		status = newImage("images/tab_status_on.gif");
		factSheet = newImage("images/tab_factSheet_on.gif");
		firstNations = newImage("images/tab_firstNations_on.gif");
	<CFELSEIF #getfilefrompath(getbasetemplatepath())# EQ "acquisition.cfm">
		project = newImage("images/tab_project.gif");
		property = newImage("images/tab_property_on.gif");
		purchase = newImage("images/tab_purchase_on.gif");
		status = newImage("images/tab_status_on.gif");
	<CFELSEIF #getfilefrompath(getbasetemplatepath())# EQ "consulting.cfm">
		project = newImage("images/tab_project.gif");
		status = newImage("images/tab_status_on.gif");
	</CFIF>
		preloadFlag = true;
	}
}

</script>

</head>
<body bgcolor="#FFFFFF" text="#000000" link="#0066ff" vlink="#0066ff" alink="#999999" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0" onLoad="preloadImages();">

<!--- Layer for "Menu" menu --->
<div id="menu1" class="menu1">
<table width="105" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="images/transparent.gif" width="2" height="1" border="0"></td>
    <td><img src="images/transparent.gif" width="101" height="1" border="0"></td>
    <td><img src="images/transparent.gif" width="2" height="1" border="0"></td>
    <td><img src="images/transparent.gif" width="1" height="1" border="0"></td>
  </tr>
  <tr>
    <td colspan="3"><img src="images/menu_top.gif" width="105" height="8" border="0"></td>
    <td><img src="images/transparent.gif" width="1" height="1" border="0"></td>
  </tr>
  <tr>
    <td width="2" background="images/blue_background.gif"><img src="images/transparent.gif" height="1" width="2"></td>
<!--- Create context sensitive links --->
<CFOUTPUT>
	<td valign="top" width="101" class="text1">
	<CFIF #getfilefrompath(getbasetemplatepath())# EQ "acquisitionSummary.cfm">
		&nbsp;<a class="menuLink" href="acquisitions.cfm?projectID=#URL.projectID#">Back to Project</a><br>
	</CFIF>
	<CFIF #getfilefrompath(getbasetemplatepath())# EQ "disposalSummary.cfm">
		&nbsp;<a class="menuLink" href="disposals.cfm?projectID=#URL.projectID#">Back to Project</a><br>
	</CFIF>
    <CFIF #getfilefrompath(getbasetemplatepath())# EQ "login.cfm"
		OR #getfilefrompath(getbasetemplatepath())# EQ "newProject.cfm"
		OR #getfilefrompath(getbasetemplatepath())# EQ "projectList.cfm"
		OR #getfilefrompath(getbasetemplatepath())# EQ "SCHReportCreate.cfm"
		OR #getfilefrompath(getbasetemplatepath())# EQ "GeneralReportCreate.cfm">
	 	&nbsp;<a class="menuLink" href="projectSearch.cfm">New Search</a><br>
	</CFIF>
	<CFIF #getfilefrompath(getbasetemplatepath())# EQ "SCHReportCreate.cfm"
		OR #getfilefrompath(getbasetemplatepath())# EQ "generalReportCreate.cfm"
		OR #getfilefrompath(getbasetemplatepath())# EQ "newProject.cfm">
	 	&nbsp;<a class="menuLink" href="projectList.cfm">Search Results</a><br>
	</CFIF>
	<CFIF (#getfilefrompath(getbasetemplatepath())# EQ "projectList.cfm" 
		OR #getfilefrompath(getbasetemplatepath())# EQ "projectSearch.cfm")
		AND Client.LoggedIn EQ "Yes">
	 	&nbsp;<a class="menuLink" href="newProject.cfm">New Project</a><br>
	</CFIF>
	<CFIF Client.LoggedIn EQ "Yes"
		AND (#getfilefrompath(getbasetemplatepath())# EQ "projectList.cfm"
		OR #getfilefrompath(getbasetemplatepath())# EQ "projectSearch.cfm"
		OR #getfilefrompath(getbasetemplatepath())# EQ "newProject.cfm"
		OR #getfilefrompath(getbasetemplatepath())# EQ "SCHReportCreate.cfm"
		OR #getfilefrompath(getbasetemplatepath())# EQ "generalReportCreate.cfm")>
	 	&nbsp;<a class="menuLink" href="projectSearch.cfm?Logout=yes">Logout</a><br>
    <CFELSEIF Client.LoggedIn EQ "No">
	 	&nbsp;<a class="menuLink" href="login.cfm">Login</a><br>
	</CFIF>
		&nbsp;<a class="menuLink" href="##" onClick="menuToggle('menu1'); newWin=window.open('help.html','newWin','width=500,height=400,toolbar=no,status=no,scrollbars=yes'); return false;">Help</a><br>
    </td>
</CFOUTPUT>
    <td width="2" background="images/blue_background.gif"><img src="images/transparent.gif" height="1" width="2"></td>
    <td><img src="images/transparent.gif" width="1" height="1" border="0"></td>
  </tr>
  <tr>
    <td width="2"><img src="images/blue_background.gif" width="2" height="12" border="0"></td>
    <td width="101" background="images/white.gif"><a href="#" onClick="menuToggle('menu1'); return false;"><img src="images/clsMenu.gif" width="14" height="11" align="right" border="0"></a></td>
    <td width="2"><img src="images/blue_background.gif" width="2" height="12" border="0"></td>
    <td><img src="images/transparent.gif" width="1" height="1" border="0"></td>
  </tr>
  <tr>
    <td colspan="3"><img src="images/menu_bottom.gif" width="105" height="8" border="0"></td>
    <td><img src="images/transparent.gif" width="1" height="1" border="0"></td>
  </tr>
</table>
</div>

<!--- Later for "Print" menu --->
<div id="menu2" class="menu2">
  <table width="132" border="0" cellpadding="0" cellspacing="0">
    <tr>
    <td><img src="images/transparent.gif" width="2" height="1" border="0"></td>
    <td><img src="images/transparent.gif" width="128" height="1" border="0"></td>
    <td><img src="images/transparent.gif" width="2" height="1" border="0"></td>
    <td><img src="images/transparent.gif" width="1" height="1" border="0"></td>
  </tr>
  <tr>
    <td colspan="3"><img src="images/menu_top2.gif" width="132" height="9" border="0"></td>
    <td><img src="images/transparent.gif" width="1" height="1" border="0"></td>
  </tr>
  <tr>
      <td width="2" background="images/blue_background.gif"><img src="images/transparent.gif" height="1" width="2"></td>
<!--- Create context sensitive links --->
<CFOUTPUT>
	<td valign="top" with="128" class="text1">	
    <CFIF #getfilefrompath(getbasetemplatepath())# EQ "acquisitions.cfm" OR #getfilefrompath(getbasetemplatepath())# EQ "disposals.cfm" OR #getfilefrompath(getbasetemplatepath())# EQ "consulting.cfm">
		&nbsp;<a class="menuLink" href="##" onClick="sendForm('statusPrint.cfm?projectID=#URL.projectID#'); return false;">Status Journal</a><br>
	</CFIF>
	<CFIF #getfilefrompath(getbasetemplatepath())# EQ "acquisitions.cfm">
		&nbsp;<a class="menuLink" href="##" onClick="sendForm('acquisitionSummary.cfm?projectID=#URL.projectID#'); return false;">Acquisition Summary</a><br>
	<CFELSEIF #getfilefrompath(getbasetemplatepath())# EQ "disposals.cfm">
		&nbsp;<a class="menuLink" href="##" onClick="sendForm('disposalSummary.cfm?projectID=#URL.projectID#'); return false;">Disposal Summary</a><br>
	</CFIF>
	<CFIF #getfilefrompath(getbasetemplatepath())# EQ "projectList.cfm">
		&nbsp;<a class="menuLink" href="SCHReportCreate.cfm">SCH Report</a><br>
		&nbsp;<a class="menuLink" href="generalReportCreate.cfm">General Report</a><br>
		&nbsp;<a class="menuLink" onClick="alert('When printing, please ensure that the printer settings are \nset to Landscape orientation and Legal paper size. \n\nClick \'\'Menu\'\' and then \'\'Help\'\' for more information.')" href="projectSummaryReport.cfm">Project Summary</a><br>
	</CFIF>
	<CFIF #getfilefrompath(getbasetemplatepath())# EQ "disposals.cfm">
		&nbsp;<a class="menuLink" href="##" onClick="sendForm('factSheet.cfm?projectID=#URL.projectID#'); return false;">Fact Sheet</a><br>
	</CFIF>
	<CFIF #getfilefrompath(getbasetemplatepath())# EQ "disposals.cfm">
		&nbsp;<a class="menuLink" href="##" onClick="sendForm('firstNationsPrint.cfm?projectID=#URL.projectID#'); return false;">First Nations</a><br>&nbsp;&nbsp;&nbsp<a class="menuLink" href="##" onClick="sendForm('firstNationsPrint.cfm?projectID=#URL.projectID#'); return false;">Consultations</a><br>
	</CFIF>
    </td>
</CFOUTPUT>
    <td width="2" background="images/blue_background.gif"><img src="images/transparent.gif" height="1" width="2"></td>
    <td><img src="images/transparent.gif" width="1" height="1" border="0"></td>
  </tr>
  <tr>
    <td width="2"><img src="images/blue_background.gif" width="2" height="12" border="0"></td>
    <td width="128" background="images/white.gif"><a href="#" onClick="menuToggle('menu2'); return false;"><img src="images/clsMenu.gif" width="14" height="11" align="right" border="0"></a></td>
    <td width="2"><img src="images/blue_background.gif" width="2" height="12" border="0"></td>
    <td><img src="images/transparent.gif" width="1" height="1" border="0"></td>
  </tr>
  <tr>
    <td colspan="3"><img src="images/menu_bottom2.gif" width="132" height="8" border="0"></td>
    <td><img src="images/transparent.gif" width="1" height="1" border="0"></td>
  </tr>
</table>
</div>

<!--- Layer for "Links" menu --->
<div id="menu3" class="menu3">
<table width="105" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td><img src="images/transparent.gif" width="2" height="1" border="0"></td>
    <td><img src="images/transparent.gif" width="101" height="1" border="0"></td>
    <td><img src="images/transparent.gif" width="2" height="1" border="0"></td>
    <td><img src="images/transparent.gif" width="1" height="1" border="0"></td>
  </tr>
  <tr>
    <td colspan="3"><img src="images/menu_top.gif" width="105" height="8" border="0"></td>
    <td><img src="images/transparent.gif" width="1" height="1" border="0"></td>
  </tr>
  <tr>
    <td width="2" background="images/blue_background.gif"><img src="images/transparent.gif" height="1" width="2"></td>
	<td valign="top" with="101" class="text1">
		<CFIF browser IS "MSIE">	
<!---     	&nbsp;<a class="menuLink"  href="#" onClick="newWin=window.open('http://monster/AIP/index.cfm','newWin',''); menuToggle('menu3'); return false;">AIP</a><br>--->
		&nbsp;<a class="menuLink" href="#" onClick="newWin=window.open('http://www.tbs-sct.gc.ca/dfrp-rbif/introduction.asp?Language=EN','newWin',''); menuToggle('menu3'); return false;">DFRP</a><br>
    	<CFELSE>
<!---		&nbsp;<a class="menuLink"  href="#" onClick="newWin=window.open('http://monster/AIP/index.cfm','newWin','directories=yes,location=yes,menubar=yes,toolbar=yes,status=yes,scrollbars=yes,resizable=yes'); menuToggle('menu3'); return false;">AIP</a><br>--->
		&nbsp;<a class="menuLink" href="#" onClick="newWin=window.open('http://www.tbs-sct.gc.ca/dfrp-rbif/introduction.asp?Language=EN','newWin','directories=yes,location=yes,menubar=yes,toolbar=yes,status=yes,scrollbars=yes,resizable=yes'); menuToggle('menu3'); return false;">DFRP</a><br>
		</CFIF>
	</td>
    <td width="2" background="images/blue_background.gif"><img src="images/transparent.gif" height="1" width="2"></td>
    <td><img src="images/transparent.gif" width="1" height="1" border="0"></td>
  </tr>
  <tr>
    <td width="2"><img src="images/blue_background.gif" width="2" height="12" border="0"></td>
    <td width="101" background="images/white.gif"><a href="#" onClick="menuToggle('menu3'); return false;"><img src="images/clsMenu.gif" width="14" height="11" align="right" border="0"></a></td>
    <td width="2"><img src="images/blue_background.gif" width="2" height="12" border="0"></td>
    <td><img src="images/transparent.gif" width="1" height="1" border="0"></td>
  </tr>
  <tr>
    <td colspan="3"><img src="images/menu_bottom.gif" width="105" height="8" border="0"></td>
    <td><img src="images/transparent.gif" width="1" height="1" border="0"></td>
  </tr>
</table>
</div>

<!--- table that actually holds the title and top menu buttons --->
<table border="0" width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td bgcolor="#006699" valign="top">
			<img src="images/header_title.gif" width="202" height="33" border="0" align="left"><img src="images/transparent.gif" width="1" height="37" align="left">
			
		</td>
	</tr>
	<tr>	
    	<td valign="bottom" bgcolor="#006699" align="left" width="192">
			<!--- context sensitive buttons, only displayed on certain pages --->
			<a href="nowhere.asp" 
				onMouseOver="changeImages('menuButton', 'images/button_menu_over.gif'); return true;" 
				onMouseOut="changeImages('menuButton', 'images/button_menu.gif'); return true;"	
				onClick="menuToggle('menu1'); return false;"><img name="menuButton" src="images/button_menu.gif" width="48" height="19" border="0"></a><CFIF #getfilefrompath(getbasetemplatepath())# EQ "projectList.cfm" 
		   OR #getfilefrompath(getbasetemplatepath())# EQ "acquisitions.cfm" 
		   OR #getfilefrompath(getbasetemplatepath())# EQ "disposals.cfm" 
		   OR #getfilefrompath(getbasetemplatepath())# EQ "consulting.cfm"><a href="nowhere.asp" 
				onMouseOver="changeImages('printButton', 'images/button_print_over.gif'); return true;" 
				onMouseOut="changeImages('printButton', 'images/button_print.gif'); return true;"	
				onClick="menuToggle('menu2'); return false;"><img name="printButton" src="images/button_print.gif" width="48" height="19" border="0"></a></CFIF><a href="nowhere.asp" 
				onMouseOver="changeImages('linksButton', 'images/button_links_over.gif'); return true;" 
				onMouseOut="changeImages('linksButton', 'images/button_links.gif'); return true;"	
				onClick="menuToggle('menu3'); return false;"><img name="linksButton" src="images/button_links.gif" width="48" height="19" border="0"></a><CFIF Client.Admin EQ "1" OR Client.Admin EQ "2"><a href="admin/index.cfm" 
				onMouseOver="changeImages('adminButton', 'images/button_admin_over.gif'); return true;" 
				onMouseOut="changeImages('adminButton', 'images/button_admin.gif'); return true;"><img name="adminButton" src="images/button_admin.gif" width="48" height="19" border="0"></a>
		</CFIF>
		</td>
	</tr>
</table>