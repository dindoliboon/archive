<!---
/**
 * The ADAccount component allows you query an Active Directory server for a
 * specific object. These objects can be groups or users.
 *
 * @author	Dindo Liboon
 * @version	1.1, 07/31/2004
 * @output      enabled 
 */
  --->
<cfcomponent output="Yes" displayName="ADAccount" hint="The ADAccount component allows you query an Active Directory server for a specific object. These objects can be groups or users.">
	<!--- Include all settings --->
	<cfinclude template="Settings.cfm">


	<!---
	/**
	 * Retrieves attributes about a particular object.
	 *
	 * Example on calling the GetAttributes method:
	 * ---------------------------------------
	 * 
	 *	<cfinvoke component="ADAccount" method="GetAttributes" returnvariable="Variables.qryUser">
	 *		<cfinvokeargument name="ObjectName" value="SomeUser">
	 *		<cfinvokeargument name="Attributes" value="distinguishedName">
	 *	</cfinvoke>
	 *
	 *	<cfoutput>#Variables.qryUser.distinguishedName#</cfoutput>
	 *
	 * ----------------------------------------
	 * 
	 * @access				Public
	 * @output				Suppressed
	 * @param ObjectName (String)		Required. Name of the object that you want to retrieve.
	 * @param Attributes (String)		Required. Attributes of the object that you want returned.
	 * @param Filter (String)		Optional. Default to (sAMAccountName=#Arguments.ObjectName#). LDAP search criteria.
	 * @param MaxRows (Numeric)		Optional. Default to 1. Maximum number of entries returned.
	 * @return				<code>Query Attributes</code> if the object and attributes exist;
	 *					<code>Null Query</code> otherwise.
	 *
	 * @version				1.1, 07/31/2004
	 *					Changed function name GetAttribute to GetAttributes.
	 *					Changed argument name UserName to ObjectName.
	 *					Added argument Filter.
	 *					Added argument MaxRows.
	 *					Correctly returns an empty query on error.
	 *
	 * @since				1.0, 05/14/2004
	 */
	  --->
	<cffunction name="GetAttributes" access="Public" returnType="Query" hint="Retrieves attributes about a particular object.">
		<cfargument name="ObjectName" type="String" required="True" default="" hint="Name of the object that you want to retrieve.">
		<cfargument name="Attributes" type="String" required="True" default="" hint="Attributes of the object that you want returned.">
		<cfargument name="Filter" type="String" required="False" default="(sAMAccountName=#Arguments.ObjectName#)" hint="LDAP search criteria.">
		<cfargument name="StartOU" type="String" required="False" default="#Variables.szLdapStartOU#" hint="Starting search location.">
		<cfargument name="MaxRows" type="Numeric" required="False" default="1" hint="Maximum number of entries returned.">

		<!--- Search the Active Directory --->
		<cftry>
			<cfldap action="query"
				name="qryLdapAttributes"
				attributes="#Arguments.Attributes#"
				start="#Arguments.StartOU#"
				scope="subtree"
				startrow="1" 
				maxRows="#Arguments.MaxRows#"
				filter="#Arguments.Filter#"
				server="#Variables.szLdapServer#"
				port="#Variables.szLdapPort#"
				username="#Variables.szLdapUserName#"
				password="#Variables.szLdapPassword#">

		<cfcatch type="Any">
				<!--- Return nothing on any error --->
			<cfreturn QueryNew("")>
			</cfcatch>
		</cftry>

		<!--- Return the query --->
		<cfif qryLdapAttributes.RecordCount eq 1>
			<cfreturn qryLdapAttributes>
		<cfelse>
			<cfreturn QueryNew("")>
		</cfif>
	</cffunction>


	<!---
	/**
	 * Returns the distinguished name of an object.
	 *
	 * Example on calling the FindDN method:
	 * ---------------------------------------
	 * 
	 *	<cfinvoke component="ADAccount" method="FindDN" returnvariable="Variables.szUserDN">
	 *		<cfinvokeargument name="ObjectName" value="SomeUser">
	 *		<cfinvokeargument name="ClassName" value="User">
	 *	</cfinvoke>
	 *
	 *	<cfoutput>#Variables.szUserDN#</cfoutput>
	 *
	 * ----------------------------------------
	 * 
	 * @access				Public
	 * @output				Suppressed
	 * @param ObjectName (String)		Required. Name of the object that you want to retrieve.
	 * @param ClassName (String)		Required. Name of the class type to match.
	 * @return				<code>distinguishedName</code> if the object exists;
	 *					<code>Null Query</code> otherwise.
	 *
	 * @version				1.1, 07/31/2004
	 *					Changed argument name Name to ObjectName.
	 *					Changed argument name Class to ClassName.
	 *					Removed argument Attributes.
	 *					Changed return type from Query to String.
	 *
	 * @since				1.0, 05/14/2004
	 */
	  --->
	<cffunction name="FindDN" access="Public" returnType="String" hint="Returns the distinguished name of an object.">
		<cfargument name="ObjectName" type="String" required="True" default="" hint="Name of the object that you want to retrieve.">
		<cfargument name="ClassName" type="String" required="True" default="" hint="Name of the class type to match.">

		<cfinvoke component="ADAccount" method="GetAttributes" returnvariable="Variables.qryObject">
			<cfinvokeargument name="ObjectName" value="#Arguments.ObjectName#">
			<cfinvokeargument name="Attributes" value="distinguishedName">
			<cfinvokeargument name="Filter" value="(&(sAMAccountName=#Arguments.ObjectName#)(objectClass=#Arguments.ClassName#))">
		</cfinvoke>

		<cfif IsDefined("Variables.qryObject.distinguishedName") eq "Yes">
			<cfreturn Variables.qryObject.distinguishedName>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>


	<!---
	/**
	 * Attempts to authenticate the user against the Active Directory.
	 *
	 * Example on calling the IsValidUser method:
	 * ---------------------------------------
	 * 
	 *	<cfinvoke component="ADAccount" method="IsValidUser" returnvariable="Variables.bIsValidUser">
	 *		<cfinvokeargument name="UserName" value="SomeUser">
	 *		<cfinvokeargument name="Password" value="YourPassword">
	 *	</cfinvoke>
	 *
	 *	<cfoutput>#Variables.bIsValidUser#</cfoutput>
	 *
	 * ----------------------------------------
	 * 
	 * @access				Public
	 * @output				Suppressed
	 * @param UserName (String)		Required. User name to authenticate.
	 * @param Password (String)		Required. Password of user.
	 * @return				<code>True</code> if the UserName and Password is correct;
	 *					<code>False</code> otherwise.
	 *
	 * @version				1.1, 07/31/2004
	 *					Checks if the UserName is part of the user class.
	 *					Logs an error if a catch error occurs.
	 *
	 * @since				1.0, 05/14/2004
	 */
	  --->
	<cffunction name="IsValidUser" access="Public" returnType="Boolean" hint="Attempts to authenticate the user against the Active Directory.">
		<cfargument name="UserName" type="String" required="True" default="" hint="User name to authenticate.">
		<cfargument name="Password" type="String" required="True" default="" hint="Password of user.">

		<cftry>
			<!--- Find the distinguishedName of the user --->
			<cfinvoke component="ADAccount" method="FindDN" returnvariable="Variables.szUserDN">
				<cfinvokeargument name="ObjectName" value="#Arguments.UserName#">
				<cfinvokeargument name="ClassName" value="user">
			</cfinvoke>

			<cfif Variables.szUserDN neq "">
				<!--- Search the Active Directory --->
				<cfldap action="query"
					name="qryLdapUser"
					attributes="sAMAccountName"
					start="#Variables.szLdapStartOU#"
					scope="subtree"
					startrow="1" 
					filter="(&(sAMAccountName=#Arguments.UserName#)(objectClass=user))"
					maxRows="1"
					server="#Variables.szLdapServer#"
					port="#Variables.szLdapPort#"
					username="#Variables.szUserDN#"
					password="#Arguments.Password#">
			<cfelse>
				<cfreturn False>
			</cfif>

			<cfcatch type="Any">
				<cflog text="Error in ADAccount.cfc method IsValidUser - Error: #cfcatch.message#" type="Error" log="authentication" file="authentication" thread="yes" date="yes" time="yes" application="no"> 
				<cfreturn False>
			</cfcatch>
		</cftry>

		<cfif qryLdapUser.RecordCount eq 1>
			<cfreturn True>
		<cfelse>
			<cfreturn False>
		</cfif>
	</cffunction>


	<!---
	/**
	 * Determines if an account is part of a certain group. Note, groups such as
	 * Domain Users do not have a memberOf property.
	 *
	 * Example on calling the IsMemberOfPrev method:
	 * ---------------------------------------
	 * 
	 *	<cfinvoke component="ADAccount" method="IsMemberOfPrev" returnvariable="Variables.bIsMemberOf">
	 *		<cfinvokeargument name="UserName" value="SomeUser">
	 *		<cfinvokeargument name="GroupName" value="DomainAdministrators">
	 *	</cfinvoke>
	 *
	 *	<cfoutput>#Variables.bIsMemberOf#</cfoutput>
	 *
	 * ----------------------------------------
	 * 
	 * @access				Private
	 * @output				Suppressed
	 * @param UserName (String)		Required. Account name to search for in the group.
	 * @param GroupName (String)		Required. Name of the group to search for.
	 * @return				<code>True</code> if UserName belongs to GroupName;
	 *					<code>False</code> otherwise.
	 *
	 * @version				1.1, 07/31/2004
	 *					Changed argument name Group to GroupNames.
	 *					Changed the function access Public to Private.
	 *					Added argument MaxRows.
	 *					Checks if the GroupName is part of the group class.
	 *					Checks if the UserName is a member of the group using an LDAP filter.
	 *
	 * @since				1.0, 05/14/2004
	 */
	  --->
	<cffunction name="IsMemberOfPrev" access="Public" returnType="Boolean" hint="Determines if an account is part of a certain group. Note, groups such as Domain Users do not have a memberOf property.">
		<cfargument name="UserName" type="String" required="True" default="" hint="Account name to search for in the group.">
		<cfargument name="GroupName" type="String" required="True" default="" hint="Name of the group to search for.">

		<!--- Find the distinguishedName of the group --->
		<cfinvoke component="ADAccount" method="FindDN" returnvariable="Variables.szGroupDN">
			<cfinvokeargument name="ObjectName" value="#Arguments.GroupName#">
			<cfinvokeargument name="ClassName" value="group">
		</cfinvoke>

		<cfif Variables.szGroupDN neq "">
			<!--- Search the Active Directory --->
			<cfinvoke component="ADAccount" method="GetAttributes" returnvariable="Variables.qryLdapIsMemberOf">
				<cfinvokeargument name="ObjectName" value="#Arguments.GroupName#">
				<cfinvokeargument name="Attributes" value="sAMAccountName,memberof">
				<cfinvokeargument name="Filter" value="(&(memberOf=#Variables.szGroupDN#)(sAMAccountName=#Arguments.UserName#))">
			</cfinvoke>

			<cfif IsDefined("Variables.qryLdapIsMemberOf.memberOf") eq "Yes">
				<cfreturn True>
			<cfelse>
				<cfreturn False>
			</cfif>
		<cfelse>
			<cfreturn False>
		</cfif>
	</cffunction>


	<!---
	/**
	 * Determines if an account is part of a certain group. Has the ability to
	 * search for multiple groups.
	 *
	 * Example on calling the IsMemberOf method:
	 * ---------------------------------------
	 * 
	 *	<cfinvoke component="ADAccount" method="IsMemberOf" returnvariable="Variables.bIsMemberOf">
	 *		<cfinvokeargument name="UserName" value="SomeUser">
	 *		<cfinvokeargument name="GroupNames" value="DomainAdministrators">
	 *	</cfinvoke>
	 *
	 *	<cfoutput>#Variables.bIsMemberOf#</cfoutput>
	 *
	 * ----------------------------------------
	 * 
	 * @access				Public
	 * @output				Suppressed
	 * @param UserName (String)		Required. Account name to search for in the group.
	 * @param GroupNames (String)		Required. Name of the groups to search for.
	 * @param MatchOne (Boolean)		Optional. Default to True. Checks if UserName exists in one or all of the groups specified.
	 * @return				<code>True</code> if UserName belongs to GroupName;
	 *					<code>False</code> otherwise.
	 *
	 * @version				1.1, 07/31/2004
	 *					Changed argument name Group to GroupNames.
	 *					Added argument MatchOne.
	 *
	 * @since				1.0, 05/14/2004
	 */
	  --->
	<cffunction name="IsMemberOf" access="Public" returnType="Boolean" hint="Determines if an account is part of a certain group. Has the ability to search for multiple groups.">
		<cfargument name="UserName" type="String" required="True" default="" hint="Account name to search for in the group.">
		<cfargument name="GroupNames" type="String" required="True" default="" hint="Name of the group to search for.">
		<cfargument name="MatchOne" type="Boolean" required="False" default="True" hint="Checks if UserName exists in one or all of the groups specified.">

		<cfset Variables.lListLength = ListLen(Arguments.GroupNames, ";")>

		<cfloop condition="Variables.lListLength gt 0">
			<cfinvoke component="ADAccount" method="IsMemberOfPrev" returnvariable="Variables.bIsMemberOf">
				<cfinvokeargument name="UserName" value="#Arguments.UserName#">
				<cfinvokeargument name="GroupName" value="#Trim(ListGetAt(Arguments.GroupNames, Variables.lListLength, ";"))#">
			</cfinvoke>

			<cfif Arguments.MatchOne eq True>
				<cfif Variables.bIsMemberOf eq True>
					<cfreturn True>
				</cfif>
			<cfelse>
				<cfif Variables.bIsMemberOf eq False>
					<cfreturn False>
				</cfif>
			</cfif>

			<cfset Variables.lListLength = Variables.lListLength - 1>
		</cfloop>

		<cfif Arguments.MatchOne eq True>
			<cfreturn False>
		<cfelse>
			<cfreturn True>
		</cfif>
	</cffunction>


	<!---
	/**
	 * Determines if an account is contained within a specific organizational unit.
	 *
	 * Example on calling the IsInUnit method:
	 * ---------------------------------------
	 * 
	 *	<cfinvoke component="ADAccount" method="IsInUnit" returnvariable="Variables.bIsInUnit">
	 *		<cfinvokeargument name="UserName" value="SomeUser">
	 *		<cfinvokeargument name="OUName" value="DomainAdministrators">
	 *	</cfinvoke>
	 *
	 *	<cfoutput>#Variables.bIsInUnit#</cfoutput>
	 *
	 * ----------------------------------------
	 * 
	 * @access				Public
	 * @output				Suppressed
	 * @param UserName (String)		Required. Account name to search for in the organizational unit.
	 * @param OUName (String)		Required. Name of the organizational unit to search for.
	 * @return				<code>True</code> if UserName belongs to OUName;
	 *					<code>False</code> otherwise.
	 *
	 * @version				1.1, 07/31/2004
	 *					Changed argument name OU to OUName.
	 *					Checks if the UserName is part of the user class.
	 *					Checks if the OUName is part of the organizationalUnit class.
	 *					Checks if the organizational unit exists.
	 *
	 * @since				1.0, 05/14/2004
	 */
	  --->
	<cffunction name="IsInUnit" access="Public" returnType="Boolean" hint="Determines if an account is contained within a specific organizational unit.">
		<cfargument name="UserName" type="String" required="True" default="" hint="Account name to search for in the organizational unit.">
		<cfargument name="OUName" type="String" required="True" default="" hint=" Name of the organizational unit to search for.">

		<!--- Find the distinguishedName of the user --->
		<cfinvoke component="ADAccount" method="FindDN" returnvariable="Variables.szUserDN">
			<cfinvokeargument name="ObjectName" value="#Arguments.UserName#">
			<cfinvokeargument name="ClassName" value="user">
		</cfinvoke>

		<!--- Check if the OU's DN exists in the user's DN --->
		<cfif Variables.szUserDN neq "" and FindNoCase("ou=#Arguments.OUName#,", Variables.szUserDN) gt 0>
			<cfreturn True>
		<cfelse>
			<cfreturn False>
		</cfif>
	</cffunction>


	<!---
	/**
	 * Checks the Active Directory if a user exists.
	 *
	 * Example on calling the UserExists method:
	 * ---------------------------------------
	 * 
	 *	<cfinvoke component="ADAccount" method="UserExists" returnvariable="Variables.bUserExists">
	 *		<cfinvokeargument name="UserName" value="SomeUser">
	 *	</cfinvoke>
	 *
	 *	<cfoutput>#Variables.bUserExists#</cfoutput>
	 *
	 * ----------------------------------------
	 * 
	 * @access				Public
	 * @output				Suppressed
	 * @param UserName (String)		Required. User name to search for.
	 * @return				<code>True</code> if user name was found;
	 *					<code>False</code> otherwise.
	 *
	 * @version				1.1, 07/31/2004
	 *					Checks if the UserName is part of the user class.
	 *
	 * @since				1.0, 05/14/2004
	 */
	  --->
	<cffunction name="UserExists" access="Public" returnType="Boolean" hint="Checks the Active Directory if a user exists.">
		<cfargument name="UserName" type="String" required="True" default="" hint="User name to search for.">

		<!--- Find the distinguishedName of the user --->
		<cfinvoke component="ADAccount" method="FindDN" returnvariable="Variables.szUserDN">
			<cfinvokeargument name="ObjectName" value="#Arguments.UserName#">
			<cfinvokeargument name="ClassName" value="user">
		</cfinvoke>

		<!--- Return True if our attribute exists --->
		<cfif Variables.szUserDN neq "">
			<cfreturn True>
		<cfelse>
			<cfreturn False>
		</cfif>
	</cffunction>
</cfcomponent>
