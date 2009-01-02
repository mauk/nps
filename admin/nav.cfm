<p>
<a class="link" href="../projectSearch.cfm">Back to Project Search</a><br><br>
<CFIF Client.Admin EQ 1>
	<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "deptAdmin.cfm"><a class="link" href="deptAdmin.cfm"></CFIF>Client/Dept<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "deptAdmin.cfm"></a></CFIF> |
	<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "locationAdmin.cfm"><a class="link" href="locationAdmin.cfm"></CFIF>Locations<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "locationAdmin.cfm"></a></CFIF> |
	<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "clientContactAdmin.cfm"><a class="link" href="clientContactAdmin.cfm"></CFIF>Client Contact<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "clientContactAdmin.cfm"></a></CFIF> |
	<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "passwordAdmin.cfm"><a class="link" href="passwordAdmin.cfm"></CFIF>Change Password<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "passwordAdmin.cfm"></a></CFIF> |
	<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "asciiDownload.cfm"><a class="link" href="asciiDownload.cfm"></CFIF>Table Download<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "asciiDownload.cfm"></a></CFIF> |<br>
	<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "agentAdmin.cfm"><a class="link" href="agentAdmin.cfm"></CFIF>Advisors<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "agentAdmin.cfm"></a></CFIF> |
	<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "propertyTypeAdmin.cfm"><a class="link" href="propertyTypeAdmin.cfm"></CFIF>Property Types<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "propertyTypeAdmin.cfm"></a></CFIF> |
	<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "interestSoldAdmin.cfm"><a class="link" href="interestSoldAdmin.cfm"></CFIF>Interest Sold Types<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "interestSoldAdmin.cfm"></a></CFIF> |
	<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "disposalMethodAdmin.cfm"><a class="link" href="disposalMethodAdmin.cfm"></CFIF>Disposal Methods<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "disposalMethodAdmin.cfm"></a></CFIF> |
	<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "purchaserTypeAdmin.cfm"><a class="link" href="purchaserTypeAdmin.cfm"></CFIF>Purchaser Types<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "purchaserTypeAdmin.cfm"></a></CFIF> |
	<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "projectAdmin.cfm"><a class="link" href="projectAdmin.cfm"></CFIF>Projects<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "projectAdmin.cfm"></a></CFIF>
<CFELSEIF Client.Admin EQ 2>
	<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "deptAdmin.cfm"><a class="link" href="deptAdmin.cfm"></CFIF>Client/Dept<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "deptAdmin.cfm"></a></CFIF> |
	<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "locationAdmin.cfm"><a class="link" href="locationAdmin.cfm"></CFIF>Locations<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "locationAdmin.cfm"></a></CFIF> |
	<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "clientContactAdmin.cfm"><a class="link" href="clientContactAdmin.cfm"></CFIF>Client Contact<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "clientContactAdmin.cfm"></a></CFIF> |
	<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "passwordAdmin.cfm"><a class="link" href="passwordAdmin.cfm"></CFIF>Change Password<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "passwordAdmin.cfm"></a></CFIF> |
	<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "asciiDownload.cfm"><a class="link" href="asciiDownload.cfm"></CFIF>Table Download<CFIF #getfilefrompath(getbasetemplatepath())# NEQ "asciiDownload.cfm"></a></CFIF>
</CFIF>
</p>