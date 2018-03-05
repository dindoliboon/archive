<!---
/**
 * Generates a random password based on a format mask. The mask is as follows:
 *
 * <ul>
 * 	<li><strong>a</strong> for alphabets, upper-case and lower-case</li>
 * 	<li><strong>l</strong> for lower-case alphabets</li>
 * 	<li><strong>u</strong> for upper-case alphabets</li>
 * 	<li><strong>n</strong> for numbers</li>
 * 	<li><strong>o</strong> for other characters</li>
 * 	<li><strong>\</strong> before a character escapes it</li>
 * </ul>
 *
 * If the attributes Length or SpecialChars is specified, then the Mask
 * attribute is not used.
 *
 * Example on calling the RndPassword tag:
 * ---------------------------------------
 *
 *	* Method One
 *	<cfmodule template="/functions/Generate/RndPassword.cfm" Length="10">
 *
 *	* Method Two
 *	<cfimport taglib="/functions/Generate/" prefix="Generate">
 *
 *	<Generate:RndPassword Mask="nnnnn">
 *	<cfoutput>#Variables.ReturnVariable#</cfoutput>
 *
 * ----------------------------------------
 * 
 * @access				Public
 * @output				Enabled
 * @param Length (Numeric)		Optional. Default to 8. Length of the password.
 * @param SpecialChars (String)		Optional. Default to False. Allows passwords to contain special characters.
 * @param Mask (String)			Optional. Default to "lnnuln". Determines what type of random character to generate.
 * @param ReturnOutput (Boolean)	Optional. Default to True. Enables the output to print the generated password.
 * @return				<code>Random Password</code>
 * 
 * @author	Dindo Liboon
 * @version	1.0, 07/14/2004
 */
  --->
<cfif IsDefined("thisTag.executionMode") and (thisTag.executionMode is "start")>
	<cfparam name="Attributes.ReturnOutput" type="Boolean" default="True">

	<cfif IsDefined("Attributes.length") or IsDefined("Attributes.SpecialChars")>
		<cfparam name="Attributes.Length" type="Numeric" default="8">
		<cfparam name="Attributes.SpecialChars" type="Boolean" default="False">

		<cfinvoke component="Generate" method="RndPassword" returnvariable="Variables.szTmp">
			<cfinvokeargument name="Length" value="#Attributes.Length#">
			<cfinvokeargument name="SpecialChars" value="#Attributes.SpecialChars#">
		</cfinvoke>
	<cfelse>
		<cfparam name="Attributes.Mask" type="String" default="lnnuln">

		<cfinvoke component="Generate" method="RndPasswordMask" returnvariable="Variables.szTmp">
			<cfinvokeargument name="Mask" value="#Attributes.mask#">
		</cfinvoke>
	</cfif>

	<cfset Caller.ReturnVariable = "#Variables.szTmp#">

	<cfif Attributes.ReturnOutput eq True>
		<cfoutput>#Variables.szTmp#</cfoutput>
	</cfif>
<cfelseif IsDefined("thisTag.executionMode") and (thisTag.executionMode is "end")>
	<!--- Do nothing if the end tag exists --->
</cfif>
