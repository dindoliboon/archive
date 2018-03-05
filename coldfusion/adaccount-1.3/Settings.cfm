<!---
/**
 * Contains all the customizable settings for the ADAccount component and tags.
 *
 * @author	Dindo Liboon
 * @version	1.0, 05/14/2004
 * @output      enabled 
 */
  --->

<cftry>
	<!--- Define default server variables --->
	<cfset Variables.szLdapUserName="domain\ServiceAccount">
	<cfset Variables.szLdapPassword="YourPassword">
	<cfset Variables.szLdapServer="server.domain.com">
	<cfset Variables.szLdapPort="389">
	<cfset Variables.szLdapStartOU="DC=domain,DC=com">

	<cfcatch type="Any">
		<cflog text="Error setting server variables - Error: #cfcatch.message#" type="Error" log="config" file="config" thread="yes" date="yes" time="yes" application="no">
	</cfcatch>
</cftry>
