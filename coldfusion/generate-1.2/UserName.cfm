<!---
/**
 * Generates a user name based on a person's first name, last name, and
 * middle initials. If the user name exists, it will continue to loop
 * until a unique name has been found. If a unique name could not be
 * found, an empty string is returned.
 *
 * Example on calling the UserName tag:
 * ---------------------------------------
 *
 *	* Method One
 *	<cfmodule template="/functions/Generate/UserName.cfm" FirstName="John" LastName="Doe">
 *
 *	* Method Two
 *	<cfimport taglib="/functions/Generate/" prefix="Generate">
 *
 *	<Generate:UserName FirstName="John" LastName="Doe">
 *	<cfoutput>#Variables.ReturnVariable#</cfoutput>
 *
 * ----------------------------------------
 * 
 * @access				Public
 * @output				Enabled
 * @param FirstName (String)		Required. User's first name.
 * @param LastName (String)		Required. User's last name.
 * @param MiddleInitials (String)	Optional. User's middle initials.
 * @param UserName (String)		Optional. User name to check uniqueness against.
 * @param ReturnOutput (Boolean)	Optional. Default to True. Enables the output to print the generated user name.
 * @return				<code>User Name</code> if a unique user name was found;
 *					<code>Null</code> otherwise.
 * 
 * @author	Dindo Liboon
 * @version	1.1, 07/29/2004
 *		Changed argument name MiddleInitial to MiddleInitials.
 *		Changed UserName generating algorithm.
 *
 * @since	1.0, 07/14/2004
 */
  --->
<cfif IsDefined("thisTag.executionMode") and (thisTag.executionMode is "start")>
	<cfparam name="Attributes.FirstName" type="String" default="">
	<cfparam name="Attributes.LastName" type="String" default="">
	<cfparam name="Attributes.MiddleInitials" type="String" default="">
	<cfparam name="Attributes.UserName" type="String" default="">
	<cfparam name="Attributes.ReturnOutput" type="Boolean" default="True">

	<cfinvoke component="Generate" method="UserName" returnvariable="Variables.szGenUserName">
		<cfinvokeargument name="FirstName" value="#Attributes.FirstName#">
		<cfinvokeargument name="MiddleInitials" value="#Attributes.MiddleInitials#">
		<cfinvokeargument name="LastName" value="#Attributes.LastName#">
		<cfinvokeargument name="UserName" value="#Attributes.UserName#">
	</cfinvoke>

	<cfset Caller.ReturnVariable="#Variables.szGenUserName#">

	<cfif Attributes.ReturnOutput eq True>
		<cfoutput>#Variables.szGenUserName#</cfoutput>
	</cfif>
<cfelseif IsDefined("thisTag.executionMode") and (thisTag.executionMode is "end")>
	<!--- Do nothing if the end tag exists --->
</cfif>
