<HTML>
<HEAD>
<TITLE>Referential Integrity Error</TITLE>
</HEAD>

<CFIF #getfilefrompath(getbasetemplatepath())# EQ "projectAdmin.cfm">
<BODY>
<HR>
<H3>Cannot Delete Project</H3>
The project that you have attempted to delete has First Nations Consultation information and, therefore, cannot be deleted.<br><br>
Use the <I>Back</I> button on your web browser to return to the Project Admin page.
<P>
<HR>
</BODY>
<CFELSE>
<BODY>
<HR>
<H3>Cannot Delete Item</H3>
The item that you have attempted to delete is in use by one or more projects and, therefore, cannot be deleted.<br><br>
Use the <I>Back</I> button on your web browser to return to the previous page.
<P>
<HR>
</BODY>
</CFIF>
</HTML>