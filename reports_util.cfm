<cffunction name="printReportHeaders" output="yes">
	<cfargument name="arrHeaders" type="array">
	<tr>
		<cfloop from="1" to="#ArrayLen(arrHeaders)#" index="loopCount">
			<td><img src="images/transparent.gif" border="0" width="#arrHeaders[loopCount][1]#" height="1" /></td>
		</cfloop>
	</tr>
	<tr style="background:##09C; color: white;">
		<cfloop from="1" to="#ArrayLen(arrHeaders)#" index="loopCount">
			<td>#arrHeaders[loopCount][2]#</td>
		</cfloop>
	</tr>
</cffunction>