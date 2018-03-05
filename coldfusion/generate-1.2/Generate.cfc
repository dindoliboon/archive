<!---
/**
 * The Generate component allows you to perform the following tasks:
 *
 * <ul>
 * 	<li>Create random passwords of any length</li>
 * 	<li>Create random passwords that use special characters</li>
 * 	<li>Create unique user names, based on a provided user name</li>
 * 	<li>Display strings using the NATO Phonetic Alphabet</li>
 * </ul>
 *
 * @author	Dindo Liboon
 * @version	1.2, 08/13/2004
 * @output      enabled 
 */
  --->
<cfcomponent output="No" displayName="Generate" hint="Generates user names, random passwords, or prints strings in the NATO Phonetic Alphabet.">
	<!---
	/**
	 * Generates a user name based on a person's first name, last name, and
	 * middle initials. If the user name exists, it will continue to loop
	 * until a unique name has been found. If a unique name could not be
	 * found, an empty string is returned.
	 *
	 * Example on calling the UserName method:
	 * ---------------------------------------
	 * 
	 *	<cfinvoke component="Generate" method="UserName" returnvariable="Variables.szGenUserName">
	 *		<cfinvokeargument name="FirstName" value="John">
	 *		<cfinvokeargument name="LastName" value="Doe">
	 *	</cfinvoke>
	 *
	 *	<cfoutput>#Variables.szGenUserName#</cfoutput>
	 *
	 * ----------------------------------------
	 * 
	 * @access				Public
	 * @output				Suppressed
	 * @param FirstName (String)		Required. User's first name.
	 * @param LastName (String)		Required. User's last name.
	 * @param MiddleInitials (String)	Optional. User's middle initials.
	 * @param UserName (String)		Optional. User name to check uniqueness against.
	 * @return				<code>User Name</code> if a unique user name was found;
	 *					<code>Null</code> otherwise.
	 *
	 * @version				1.1, 07/29/2004
	 *					Changed argument name First_Name to FirstName.
	 *					Changed argument name Last_Name to LastName.
	 *					Changed argument name MiddleInitial to MiddleInitials.
	 *					Changed UserName generating algorithm.
	 *
	 * @since				1.0, 05/14/2004
	 */
	  --->
	<cffunction name="UserName" returnType="String" access="Public" hint="Generates a user name based on a person's first name, last name, and middle initials. If the user name exists, it will continue to loop until a unique name has been found. If a unique name could not be found, an empty string is returned.">
		<cfargument name="FirstName" type="String" required="True" default="" hint="User's first name.">
		<cfargument name="LastName" type="String" required="True" default="" hint="User's last name.">
		<cfargument name="MiddleInitials" type="String" required="False" default="" hint="User's middle initials.">
		<cfargument name="UserName" type="String" required="False" default="" hint="User name to check uniqueness against.">

		<cfif Arguments.UserName eq "">
			<!--- Create standard user name --->
			<cfreturn LCase(Left(Arguments.FirstName, 1) & Arguments.LastName)>
		<cfelse>
			<cfset Variables.szGenUserName="">

			<!--- Case 1: Try (FirstName-Initial) + (LastName) --->
			<cfset Variables.szGenUserName = LCase(Left(Arguments.FirstName, 1) & Arguments.LastName)>

			<cfif (Variables.szGenUserName eq LCase(Arguments.UserName)) or (Len(Arguments.UserName) gt Len(Variables.szGenUserName))>
				<cfset Variables.lIndex=1>

				<!--- Case 2: Try (FirstName-Initial) + (MiddleInitials) + (LastName) --->
				<cfloop condition="Variables.lIndex lte Len(Arguments.MiddleInitials)">
					<cfset Variables.szGenUserName = LCase(Left(Arguments.FirstName, 1) & Left(Arguments.MiddleInitials, Variables.lIndex) & Arguments.LastName)>
					<cfset Variables.lIndex = Variables.lIndex + 1>

					<cfif (Variables.szGenUserName neq LCase(Arguments.UserName)) and (Len(Variables.szGenUserName) gt Len(Arguments.UserName))>
						<cfbreak>
					</cfif>
				</cfloop>

				<cfif (Variables.szGenUserName eq LCase(Arguments.UserName)) or (Len(Arguments.UserName) gt Len(Variables.szGenUserName))>
					<cfset Variables.lIndex=1>

					<!--- Case 3: Try (FirstName-Initials) + (MiddleInitials) + (LastName) --->
					<cfloop condition="Variables.lIndex lte Len(Arguments.FirstName)">
						<cfset Variables.szGenUserName = LCase(Left(Arguments.FirstName, Variables.lIndex) & Arguments.MiddleInitials & Arguments.LastName)>
						<cfset Variables.lIndex = Variables.lIndex + 1>

						<cfif (Variables.szGenUserName neq LCase(Arguments.UserName)) and (Len(Variables.szGenUserName) gt Len(Arguments.UserName))>
							<cfbreak>
						</cfif>
					</cfloop>

					<!--- Unique user name was not found --->
					<cfif Variables.szGenUserName eq LCase(Arguments.UserName)>
						<cfset Variables.szGenUserName="">
					</cfif>
				</cfif>
			</cfif>

			<cfreturn Variables.szGenUserName>
		</cfif>
	</cffunction>


	<!---
	/**
	 * Generates a random password. The default length of the password is eight
	 * characters. By default, the password consists of alpha-numeric characters.
	 *
	 * Example on calling the RndPassword method:
	 * ---------------------------------------
	 * 
	 *	<cfinvoke component="Generate" method="RndPassword" returnvariable="Variables.szPassword">
	 *		<cfinvokeargument name="Length" value="10">
	 *	</cfinvoke>
	 *
	 *	<cfoutput>#Variables.szPassword#</cfoutput>
	 *
	 * ----------------------------------------
	 *
	 * @access				Public
	 * @output				Suppressed
	 * @param Length (Numeric)		Optional. Default to 8. Length of the password.
	 * @param SpecialChars (String)		Optional. Default to False. Allows passwords to contain special characters.
	 * @return				<code>Random Password</code>
	 *
	 * @since				1.0, 05/14/2004
	 */
	  --->
	<cffunction name="RndPassword" returnType="String" hint="Generates a random password. The default length of the password is 8 characters. By default, the password consists of alpha-numeric characters. To allow special characters, set SpecialChars to True.">
		<cfargument name="Length" type="numeric" required="False" default="8" hint="Length of the password.">
		<cfargument name="SpecialChars" type="boolean" required="False" default="False" hint="Allows passwords to contain special characters.">

		<!--- Generate the random password --->
		<cfset Variables.szPassword = "">
		<cfloop index="Variables.lIndex" from="1" to="#Arguments.Length#">
			<!--- Set range of generated characters --->
			<cfif Arguments.SpecialChars eq True>
				<cfset Variables.lRange = RandRange(1, 94)>
			<cfelse>
				<cfset Variables.lRange = RandRange(1, 62)>
			</cfif>

			<!--- Lower-Case Letters --->
			<cfif (Variables.lRange gte 1)  and (Variables.lRange lte 26)><cfset Variables.szPassword = Variables.szPassword & chr((26-Variables.lRange) + 97)></cfif>

			<!--- Upper-Case Letters --->
			<cfif (Variables.lRange gte 27) and (Variables.lRange lte 52)><cfset Variables.szPassword = Variables.szPassword & chr((52-Variables.lRange) + 65)></cfif>

			<!--- Numbers --->
			<cfif (Variables.lRange gte 53) and (Variables.lRange lte 62)><cfset Variables.szPassword = Variables.szPassword & chr((62-Variables.lRange) + 48)></cfif>

			<!--- Other Characters: Set 1 --->
			<cfif (Variables.lRange gte 63) and (Variables.lRange lte 77)><cfset Variables.szPassword = Variables.szPassword & chr((78-Variables.lRange) + 33)></cfif>

			<!--- Other Characters: Set 2 --->
			<cfif (Variables.lRange gte 78) and (Variables.lRange lte 84)><cfset Variables.szPassword = Variables.szPassword & chr((84-Variables.lRange) + 58)></cfif>

			<!--- Other Characters: Set 3 --->
			<cfif (Variables.lRange gte 85) and (Variables.lRange lte 90)><cfset Variables.szPassword = Variables.szPassword & chr((90-Variables.lRange) + 91)></cfif>

			<!--- Other Characters: Set 4 --->
			<cfif (Variables.lRange gte 91) and (Variables.lRange lte 94)><cfset Variables.szPassword = Variables.szPassword & chr((94-Variables.lRange) + 123)></cfif>
		</cfloop>

		<!--- Return the generated password --->
		<cfreturn Variables.szPassword>
	</cffunction>


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
	 * Example on calling the RndPasswordMask method:
	 * ---------------------------------------
	 * 
	 *	<cfinvoke component="Generate" method="RndPasswordMask" returnvariable="Variables.szPassword">
	 *		<cfinvokeargument name="Mask" value="nnnnn">
	 *	</cfinvoke>
	 *
	 *	<cfoutput>#Variables.szPassword#</cfoutput>
	 *
	 * ----------------------------------------
	 *
	 * @access				Public
	 * @output				Suppressed
	 * @param Mask (String)			Optional. Default to "lnnuln". Determines what type of random character to generate.
	 * @return				<code>Random Password</code>
	 *
	 * @since				1.0, 05/14/2004
	 */
	  --->
	<cffunction name="RndPasswordMask" returnType="String" hint="Generates a random password based on a format mask. The default mask is lnnuln. (a) stands for alphabets, upper-case and lower-case, (l) stands for lower-case alphabets, (u) stands for upper-case alphabets, (n) stands for numbers, and (o) stands for other characters. To print out a character, add a backslash (\) before the character you want to print.">
		<cfargument name="Mask" type="string" required="false" default="lnnuln" hint="Determines what type of random character to generate.">

		<!--- Generate the random password --->
		<cfset Variables.szPassword = "">
		<cfset Variables.bSkipThis = False>
		<cfloop index="Variables.lIndex" from="1" to="#Len(Arguments.Mask)#">
			<cfif Variables.bSkipThis eq True>
				<!--- Print out the current character --->
				<cfset Variables.szPassword = Variables.szPassword & Mid(#Arguments.Mask#, Variables.lIndex, 1)>
				<cfset Variables.bSkipThis = False>
			<cfelse>
				<!--- Retrieve the mask charcter --->
				<cfset Variables.chMask = LCase(Mid(#Arguments.Mask#, #Variables.lIndex#, 1))>

				<!--- Check if user wants to print out character --->
				<cfif Variables.chMask eq "\">
					<cfset Variables.bSkipThis = True>
				<cfelse>
					<!--- Generate ranges based on format mask --->
					<cfif     Variables.chMask eq "a"><cfset Variables.lRange = RandRange(1,  52)>
					<cfelseif Variables.chMask eq "l"><cfset Variables.lRange = RandRange(1,  26)>
					<cfelseif Variables.chMask eq "u"><cfset Variables.lRange = RandRange(27, 52)>
					<cfelseif Variables.chMask eq "n"><cfset Variables.lRange = RandRange(53, 62)>
					<cfelseif Variables.chMask eq "o"><cfset Variables.lRange = RandRange(63, 94)></cfif>

					<!--- Lower-Case Letters --->
					<cfif (Variables.lRange gte 1)  and (Variables.lRange lte 26)><cfset Variables.szPassword = Variables.szPassword & chr((26-Variables.lRange) + 97)></cfif>

					<!--- Upper-Case Letters --->
					<cfif (Variables.lRange gte 27) and (Variables.lRange lte 52)><cfset Variables.szPassword = Variables.szPassword & chr((52-Variables.lRange) + 65)></cfif>

					<!--- Numbers --->
					<cfif (Variables.lRange gte 53) and (Variables.lRange lte 62)><cfset Variables.szPassword = Variables.szPassword & chr((62-Variables.lRange) + 48)></cfif>

					<!--- Other Characters: Set 1 --->
					<cfif (Variables.lRange gte 63) and (Variables.lRange lte 77)><cfset Variables.szPassword = Variables.szPassword & chr((77-Variables.lRange) + 33)></cfif>

					<!--- Other Characters: Set 2 --->
					<cfif (Variables.lRange gte 78) and (Variables.lRange lte 84)><cfset Variables.szPassword = Variables.szPassword & chr((84-Variables.lRange) + 58)></cfif>

					<!--- Other Characters: Set 3 --->
					<cfif (Variables.lRange gte 85) and (Variables.lRange lte 90)><cfset Variables.szPassword = Variables.szPassword & chr((90-Variables.lRange) + 91)></cfif>

					<!--- Other Characters: Set 4 --->
					<cfif (Variables.lRange gte 91) and (Variables.lRange lte 94)><cfset Variables.szPassword = Variables.szPassword & chr((94-Variables.lRange) + 123)></cfif>
				</cfif>
			</cfif>
		</cfloop>

		<!--- Return the generated password --->
		<cfreturn Variables.szPassword>
	</cffunction>


	<!---
	/**
	 * Generates the NATO Phonetic string, based on the input string.
	 *
	 * Example on calling the NatoPhoneticAlphabet method:
	 * ---------------------------------------
	 * 
	 *	<cfinvoke component="Generate" method="NatoPhoneticAlphabet" returnvariable="Variables.szPhonetics">
	 *		<cfinvokeargument name="Input" value="AaBbCc">
	 *	</cfinvoke>
	 *
	 *	<cfoutput>#Variables.szPhonetics#</cfoutput>
	 *
	 * ----------------------------------------
	 *
	 * @access				Public
	 * @output				Suppressed
	 * @param Input (String)		Required. String to convert to a NATO Phonetic string.
	 * @param SkipSpecial (Boolean)		Optional. Default to True. Skips over special characters.
	 * @param LSpecialQuote (String)	Optional. Default to "[". String that appears on the left of a special character.
	 * @param RSpecialQuote (String)	Optional. Default to "]". String that appears on the right of a special character.
	 * @param ChangeCase (Boolean)		Optional. Default to True. Changes the case of the string to distinguish between lowercase and uppercase characters.
	 * @return				<code>NATO Phonetic String</code>
	 *
	 * @since				1.1, 07/29/2004
	 */
	  --->
	<cffunction name="NatoPhoneticAlphabet" returnType="String" hint="Generates the NATO Phonetic Alpha-numeric string, based on the input string.">
		<cfargument name="Input" type="string" required="True" default="" hint="String to convert to a NATO Phonetic string.">
		<cfargument name="SkipSpecial" type="boolean" required="False" default="True" hint="Skips over special characters.">
		<cfargument name="LSpecialQuote" type="string" required="False" default="[" hint="String that appears on the left of a special character.">
		<cfargument name="RSpecialQuote" type="string" required="False" default="]" hint="String that appears on the right of a special character.">
		<cfargument name="ChangeCase" type="boolean" required="False" default="True" hint="Changes the case of the string to distinguish between lowercase and uppercase characters.">

		<cfset Variables.szAlphabet = "Alpha,Bravo,Charlie,Delta,Echo,Foxtrot,Golf,Hotel,India,Juliet,Kilo,Lima,Mike,November,Oscar,Papa,Quebec,Romeo,Sierra,Tango,Uniform,Victor,Whiskey,Xray,Yankee,Zulu">
		<cfset Variables.szNumeric  = "Zero,Wun,Too,Tree,Fower,Fife,Six,Seven,Ait,Niner">
		<cfset Variables.szTmp      = "">

		<cfloop index="Variables.lIndex" from="1" to="#Len(Arguments.Input)#">
			<cfset Variables.iAsc = Asc(Mid(Arguments.Input, Variables.lIndex, 1))>

			<!--- Lower-Case Letters --->
			<cfif (Variables.iAsc gte 97) and (Variables.iAsc lte 122)><cfset Variables.szTmp = Variables.szTmp & IIf(Arguments.ChangeCase eq True, De(LCase(ListGetAt(Variables.szAlphabet, Variables.iAsc - 96))), De(ListGetAt(Variables.szAlphabet, Variables.iAsc - 96))) & " ">

			<!--- Upper-Case Letters --->
			<cfelseif (Variables.iAsc gte 65) and (Variables.iAsc lte 90)><cfset Variables.szTmp = Variables.szTmp & IIf(Arguments.ChangeCase eq True, De(UCase(ListGetAt(Variables.szAlphabet, Variables.iAsc - 64))), De(ListGetAt(Variables.szAlphabet, Variables.iAsc - 64))) & " ">

			<!--- Numbers --->
			<cfelseif (Variables.iAsc gte 48) and (Variables.iAsc lte 57)><cfset Variables.szTmp = Variables.szTmp & ListGetAt(Variables.szNumeric, Variables.iAsc - 47) & " ">

			<!--- Non Alpha-Numeric Characters --->
			<cfelse>
				<cfif Arguments.SkipSpecial eq False>
					<cfset Variables.szTmp = Variables.szTmp & Arguments.LSpecialQuote & Chr(Variables.iAsc) & Arguments.RSpecialQuote & " ">
				</cfif>
			</cfif>
		</cfloop>

		<!--- Return the generated string --->
		<cfreturn Trim(Variables.szTmp)>
	</cffunction>


	<!---
	/**
	 * Removes non-alphanumeric characters from a string.
	 *
	 * Example on calling the StripCharacters method:
	 * ---------------------------------------
	 * 
	 *	<cfinvoke component="Generate" method="StripCharacters" returnvariable="Variables.szClean">
	 *		<cfinvokeargument name="Input" value="AaB---bCc">
	 *	</cfinvoke>
	 *
	 *	<cfoutput>#Variables.szClean#</cfoutput>
	 *
	 * ----------------------------------------
	 *
	 * @access				Public
	 * @output				Suppressed
	 * @param Input (String)		Required. String to remove characters from.
	 * @param Allow (String)		Optional. Contains characters to allow.
	 * @return				<code>String without non-alphanumeric characters</code>
	 *
	 * @since				1.2, 08/13/2004
	 */
	  --->	<cffunction name="StripCharacters" returnType="String" hint="Removes non-alphanumeric characters from a string.">
		<cfargument name="Input" type="string" required="True" default="" hint="String to remove characters from.">
		<cfargument name="Allow" type="string" required="False" default="" hint="Contains characters to allow.">

		<!-- Remove any non-alphanumeric characters --->
		<cfset Variables.szTemp = "">
		<cfloop index="Variables.lIndex" from="1" to="#Len(Arguments.Input)#">
			<cfset Variables.chTemp = Asc(Mid(Arguments.Input, Variables.lIndex, 1))>

			<!--- Lower-Case Letters --->
			<cfif Variables.chTemp gte Asc("a") and Variables.chTemp lte Asc("z")>
				<cfset Variables.szTemp = Variables.szTemp & Chr(Variables.chTemp)>

			<!--- Upper-Case Letters --->
			<cfelseif Variables.chTemp gte Asc("A") and Variables.chTemp lte Asc("Z")>
				<cfset Variables.szTemp = Variables.szTemp & Chr(Variables.chTemp)>

			<!--- Numbers --->
			<cfelseif Variables.chTemp gte Asc("0") and Variables.chTemp lte Asc("9")>
				<cfset Variables.szTemp = Variables.szTemp & Chr(Variables.chTemp)>

			<!--- Other characters --->
			<cfelse>
				<cfset Variables.Search = Find(Chr(Variables.chTemp), Arguments.Allow)>

				<!--- Allow the character if found in mask --->
				<cfif Variables.Search gt 0>
					<cfset Variables.szTemp = Variables.szTemp & Chr(Variables.chTemp)>
				</cfif>
			</cfif>
		</cfloop>

		<cfreturn Variables.szTemp>
	</cffunction>
</cfcomponent>
