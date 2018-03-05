<!---
/**
 * Generates the NATO Phonetic string, based on the input string.
 *
 * Example on calling the NatoPhoneticAlphabet tag:
 * ---------------------------------------
 *
 *	* Method One
 *	<cfmodule template="/functions/Generate/NatoPhoneticAlphabet.cfm" Input="Abc1234">
 *
 *	* Method Two
 *	<cfimport taglib="/functions/Generate/" prefix="Generate">
 *
 *	<Generate:NatoPhoneticAlphabet Input="Abc1234">
 *	<cfoutput>#Variables.ReturnVariable#</cfoutput>
 *
 * ----------------------------------------
 * 
 * @access				Public
 * @output				Enabled
 * @param Input (String)		Required. String to convert to a NATO Phonetic string.
 * @param SkipSpecial (Boolean)		Optional. Default to True. Skips over special characters.
 * @param LSpecialQuote (String)	Optional. Default to "[". String that appears on the left of a special character.
 * @param RSpecialQuote (String)	Optional. Default to "]". String that appears on the right of a special character.
 * @param ChangeCase (Boolean)		Optional. Default to True. Changes the case of the string to distinguish between lowercase and uppercase characters.
 * @param ReturnOutput (Boolean)	Optional. Default to True. Enables the output to print the generated NATO phonetic string.
 * @return				<code>NATO Phonetic String</code>
 * 
 * @author	Dindo Liboon
 * @version	1.0, 07/29/2004
 */
  --->
<cfif IsDefined("thisTag.executionMode") and (thisTag.executionMode is "start")>
	<cfparam name="Attributes.Input" default="">
	<cfparam name="Attributes.SkipSpecial" default="True">
	<cfparam name="Attributes.LSpecialQuote" default="[">
	<cfparam name="Attributes.RSpecialQuote" default="]">
	<cfparam name="Attributes.ChangeCase" default="True">
	<cfparam name="Attributes.ReturnOutput" default="True">

	<cfinvoke component="Generate" method="NatoPhoneticAlphabet" returnvariable="Variables.szTmp">
		<cfinvokeargument name="Input" value="#Attributes.Input#">
		<cfinvokeargument name="SkipSpecial" value="#Attributes.SkipSpecial#">
		<cfinvokeargument name="LSpecialQuote" value="#Attributes.LSpecialQuote#">
		<cfinvokeargument name="RSpecialQuote" value="#Attributes.RSpecialQuote#">
		<cfinvokeargument name="ChangeCase" value="#Attributes.ChangeCase#">
	</cfinvoke>

	<cfset Caller.ReturnVariable="#Variables.szTmp#">

	<cfif Attributes.ReturnOutput eq True>
		<cfoutput>#Variables.szTmp#</cfoutput>
	</cfif>
<cfelseif IsDefined("thisTag.executionMode") and (thisTag.executionMode is "end")>
	<!--- Do nothing if the end tag exists --->
</cfif>
