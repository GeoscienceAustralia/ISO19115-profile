<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">

<!-- ===========================================================================
This Schematron validates the relevant elements in ISO 19115-3 metadata documents against all 32 official codelists 
defined in the ISO 19115-1:2014 standard.  The Schematron will also validate elements with codelists that extend the 
official ISO 19115-1:2014 codelists (i.e. a community profile).

For each element being validated, the codelist attribute is expected to contain the URL of the codelist document and 
codelist ID, seperated by a hash (#).  For example: http://example.org.au/codelists.xml#codelistId  

If the codelist attribute value does not match the expected pattern, the validation will fail.  When the codelist 
attribute is empty, the official ISO 19115-3 codelist URL location and ID for that element is applied.

The code attribute and text value of the element being validated is checked against the relevant codelist. To 
conform with the naming convention of codes in ISO 19115-1:2014 codelists, the codelist ID is prepended to the code, 
seperated by an underscore (_), to form the string that is checked against the codelist.

Note that this Schematron only validates elements which are constrained by the ?? possible codelists in the base
ISO 19115-1:2014 standard (or extensions there of) - new codelists produced by constraining free text elements, 
defined by a community profile of ISO 19115-1:2014, are not validated by this Schematron.
    
This script was developed by Geoscience Australia in March 2018.
================================================================================
History:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DATE			VERSION		AUTHOR				DESCRIPTION
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2018-03-09		0.1			Aaron Sedgmen		Initial Version.
================================================================================
-->

    <sch:title>Schematron schema for checking that codes in ISO 19115-1:2014 metadata documents correspond to the ISO 19115-1:2014 codelists</sch:title>
    
    <sch:ns prefix="cat" uri="http://standards.iso.org/iso/19115/-3/cat/1.0"  />
    <sch:ns prefix="cit" uri="http://standards.iso.org/iso/19115/-3/cit/1.0"  />
    <sch:ns prefix="gco" uri="http://standards.iso.org/iso/19115/-3/gco/1.0"  />
    <sch:ns prefix="mcc" uri="http://standards.iso.org/iso/19115/-3/mcc/1.0"  />
    <sch:ns prefix="mrd" uri="http://standards.iso.org/iso/19115/-3/mrd/1.0"  />
    <sch:ns prefix="mri" uri="http://standards.iso.org/iso/19115/-3/mri/1.0"  />
    <sch:ns prefix="mrs" uri="http://standards.iso.org/iso/19115/-3/mrs/1.0"  />
    <sch:ns prefix="srv" uri="http://standards.iso.org/iso/19115/-3/srv/2.0"  />
    <sch:ns prefix="msr" uri="http://standards.iso.org/iso/19115/-3/msr/1.0"  />
    <sch:ns prefix="mco" uri="http://standards.iso.org/iso/19115/-3/mco/1.0"  />
    <sch:ns prefix="mrc" uri="http://standards.iso.org/iso/19115/-3/mrc/1.0"  />
    <sch:ns prefix="mex" uri="http://standards.iso.org/iso/19115/-3/mex/1.0"  />
    <sch:ns prefix="mmi" uri="http://standards.iso.org/iso/19115/-3/mmi/1.0"  />
    <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2"  />

<!--    <!-\- cit:dateType/cit:CI_DateTypeCode -\->

    <!-\- ========================================================================================================================== -\->
    <!-\- Assert that the date type codes correspond to values in the ISO 19115-1:2014 cit codelist.                                 -\->
    <!-\- ========================================================================================================================== -\->
    <sch:diagnostics>
        <sch:diagnostic id="rule.cit.validdatetypecodelist-failure-en" xml:lang="en">Invalid CI_DateTypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Unable to obtain codelist URI and/or codelist name.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validdatetypecodelist-success-en" xml:lang="en">Valid CI_DateTypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Codelist URI is "<sch:value-of select="$URI"/>" and codelist name is "<sch:value-of select="$code-list-name"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.cit.datetypecodelisturiresolves-failure-en" xml:lang="en">Unable to resolve date type codelist URI "<sch:value-of select="$URI"/>" to a document.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.datetypecodelisturiresolves-success-en" xml:lang="en">Successfully resolved date type codelist URI "<sch:value-of select="$URI"/>".</sch:diagnostic>

        <sch:diagnostic id="rule.cit.datetypecodelistnamefound-failure-en" xml:lang="en">Unable to find date type codelist name "<sch:value-of select="$code-list-name"/>" in codelist document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        <sch:diagnostic id="rule.cit.datetypecodelistnamefound-success-en" xml:lang="en">Date type code list name "<sch:value-of select="$code-list-name"/>" found in code list document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.cit.validdatetypecode-attr-failure-en" xml:lang="en">CI_DateTypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validdatetypecode-attr-success-en" xml:lang="en">CI_DateTypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" for date type code found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>

        <sch:diagnostic id="rule.cit.validdatetypecode-text-failure-en" xml:lang="en">CI_DateTypeCode text value "<sch:value-of select="normalize-space(.)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validdatetypecode-text-success-en" xml:lang="en">CI_DateTypeCode text value "<sch:value-of select="normalize-space(.)"/>" exists in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Date type element must specify a valid ISO 19115-1:2014 cit:CI_DateTypeCode codelist URI and codelist name (or profile there of), and the code value provided must occur in the specified codelist.</sch:title>
        
        <sch:rule context= "cit:dateType/cit:CI_DateTypeCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml',1,number(not(string-length(@codeList) > 0))*string-length('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('CI_DateTypeCode',1,number(not(string-length(@codeList) > 0))*string-length('CI_DateTypeCode')))" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
                        
            <sch:let name="attr-code" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="text-code" value="concat($code-list-name, '_', .)" />
            
            <sch:assert test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.cit.validdatetypecodelist-failure-en" >Fail.</sch:assert>
            <sch:report test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.cit.validdatetypecodelist-success-en" >Pass.</sch:report>            

            <sch:assert test="count($code-list-document//*) > 0"
                diagnostics="rule.cit.datetypecodelisturiresolves-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list-document//*) > 0"
                diagnostics="rule.cit.datetypecodelisturiresolves-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list//*) > 0"
                diagnostics="rule.cit.datetypecodelistnamefound-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list//*) > 0"
                diagnostics="rule.cit.datetypecodelistnamefound-success-en" >Pass.</sch:report>            
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.cit.validdatetypecode-attr-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.cit.validdatetypecode-attr-success-en" >Pass.</sch:report>

            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.cit.validdatetypecode-text-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.cit.validdatetypecode-text-success-en" >Pass.</sch:report>
            
        </sch:rule>
    </sch:pattern>


    <!-\- cit:function/cit:CI_OnLineFunctionCode -\->
    
    <!-\- ========================================================================================================================== -\->
    <!-\- Assert that the online function codes correspond to values in the ISO 19115-1:2014 cit codelist.                                 -\->
    <!-\- ========================================================================================================================== -\->
    <sch:diagnostics>
        <sch:diagnostic id="rule.cit.validonlinefunctioncodelist-failure-en" xml:lang="en">Invalid CI_OnLineFunctionCode@codelist attribute "<sch:value-of select="@codeList"/>".  Unable to obtain codelist URI and/or codelist name.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validonlinefunctioncodelist-success-en" xml:lang="en">Valid CI_OnLineFunctionCode@codelist attribute "<sch:value-of select="@codeList"/>".  Codelist URI is "<sch:value-of select="$URI"/>" and codelist name is "<sch:value-of select="$code-list-name"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.cit.onlinefunctioncodelisturiresolves-failure-en" xml:lang="en">Unable to resolve online function codelist URI "<sch:value-of select="$URI"/>" to a document.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.onlinefunctioncodelisturiresolves-success-en" xml:lang="en">Successfully resolved online function codelist URI "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.cit.onlinefunctioncodelistnamefound-failure-en" xml:lang="en">Unable to find online function codelist name "<sch:value-of select="$code-list-name"/>" in codelist document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        <sch:diagnostic id="rule.cit.onlinefunctioncodelistnamefound-success-en" xml:lang="en">Online function code list name "<sch:value-of select="$code-list-name"/>" found in code list document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.cit.validonlinefunctioncode-attr-failure-en" xml:lang="en">CI_OnLineFunctionCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validonlinefunctioncode-attr-success-en" xml:lang="en">CI_OnLineFunctionCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>

        <sch:diagnostic id="rule.cit.validonlinefunctioncode-text-failure-en" xml:lang="en">CI_OnLineFunctionCode text value "<sch:value-of select="normalize-space(.)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validonlinefunctioncode-text-success-en" xml:lang="en">CI_OnLineFunctionCode text value "<sch:value-of select="normalize-space(.)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Online function element must specify a valid ISO 19115-1:2014 cit:CI_OnLineFunctionCode codelist URI and codelist name (or profile there of), and the code value provided must occur in the specified codelist.</sch:title>
        
        <sch:rule context= "cit:function/cit:CI_OnLineFunctionCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml',1,number(not(string-length(@codeList) > 0))*string-length('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('CI_OnLineFunctionCode',1,number(not(string-length(@codeList) > 0))*string-length('CI_OnLineFunctionCode')))" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:let name="attr-code" value="concat($code-list-name, '_', @codeListValue)" />

            <sch:let name="text-code" value="concat($code-list-name, '_', .)" />
            
            <sch:assert test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.cit.validonlinefunctioncodelist-failure-en" >Fail.</sch:assert>
            <sch:report test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.cit.validonlinefunctioncodelist-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list-document//*) > 0"
                diagnostics="rule.cit.onlinefunctioncodelisturiresolves-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list-document//*) > 0"
                diagnostics="rule.cit.onlinefunctioncodelisturiresolves-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list//*) > 0"
                diagnostics="rule.cit.onlinefunctioncodelistnamefound-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list//*) > 0"
                diagnostics="rule.cit.onlinefunctioncodelistnamefound-success-en" >Pass.</sch:report>            
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.cit.validonlinefunctioncode-attr-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.cit.validonlinefunctioncode-attr-success-en" >Pass.</sch:report>
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.cit.validonlinefunctioncode-text-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.cit.validonlinefunctioncode-text-success-en" >Pass.</sch:report>
        </sch:rule>
    </sch:pattern>


    <!-\- cit:presentationForm/cit:CI_PresentationFormCode -\->
    
    <!-\- ========================================================================================================================== -\->
    <!-\- Assert that the presentation form codes correspond to values in the ISO 19115-1:2014 cit codelist.                                 -\->
    <!-\- ========================================================================================================================== -\->
    <sch:diagnostics>
        <sch:diagnostic id="rule.cit.validpresentationformcodelist-failure-en" xml:lang="en">Invalid CI_PresentationFormCode@codelist attribute "<sch:value-of select="@codeList"/>".  Unable to obtain codelist URI and/or codelist name.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validpresentationformcodelist-success-en" xml:lang="en">Valid CI_PresentationFormCode@codelist attribute "<sch:value-of select="@codeList"/>".  Codelist URI is "<sch:value-of select="$URI"/>" and codelist name is "<sch:value-of select="$code-list-name"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.cit.presentationformcodelisturiresolves-failure-en" xml:lang="en">Unable to resolve presentation form codelist URI "<sch:value-of select="$URI"/>" to a document.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.presentationformcodelisturiresolves-success-en" xml:lang="en">Successfully resolved presentation form codelist URI "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.cit.presentationformcodelistnamefound-failure-en" xml:lang="en">Unable to find presentation form codelist name "<sch:value-of select="$code-list-name"/>" in codelist document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        <sch:diagnostic id="rule.cit.presentationformcodelistnamefound-success-en" xml:lang="en">Presentation form code list name "<sch:value-of select="$code-list-name"/>" found in code list document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.cit.validpresentationformcode-attr-failure-en" xml:lang="en">CI_PresentationFormCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validpresentationformcode-attr-success-en" xml:lang="en">CI_PresentationFormCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>

        <sch:diagnostic id="rule.cit.validpresentationformcode-text-failure-en" xml:lang="en">CI_PresentationFormCode text value "<sch:value-of select="normalize-space(.)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validpresentationformcode-text-success-en" xml:lang="en">CI_PresentationFormCode text value "<sch:value-of select="normalize-space(.)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Presentation form element must specify a valid ISO 19115-1:2014 cit:CI_PresentationFormCode codelist URI and codelist name (or profile there of), and the code value provided must occur in the specified codelist.</sch:title>
        
        <sch:rule context= "cit:presentationForm/cit:CI_PresentationFormCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml',1,number(not(string-length(@codeList) > 0))*string-length('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('CI_PresentationFormCode',1,number(not(string-length(@codeList) > 0))*string-length('CI_PresentationFormCode')))" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:let name="attr-code" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="text-code" value="concat($code-list-name, '_', .)" />
            
            <sch:assert test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.cit.validpresentationformcodelist-failure-en" >Fail.</sch:assert>
            <sch:report test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.cit.validpresentationformcodelist-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list-document//*) > 0"
                diagnostics="rule.cit.presentationformcodelisturiresolves-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list-document//*) > 0"
                diagnostics="rule.cit.presentationformcodelisturiresolves-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list//*) > 0"
                diagnostics="rule.cit.presentationformcodelistnamefound-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list//*) > 0"
                diagnostics="rule.cit.presentationformcodelistnamefound-success-en" >Pass.</sch:report>            
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.cit.validpresentationformcode-attr-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.cit.validpresentationformcode-attr-success-en" >Pass.</sch:report>
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.cit.validpresentationformcode-text-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.cit.validpresentationformcode-text-success-en" >Pass.</sch:report>
        </sch:rule>
    </sch:pattern>


    <!-\- cit:role/cit:CI_RoleCode -\->
    
    <!-\- ========================================================================================================================== -\->
    <!-\- Assert that the role codes correspond to values in the ISO 19115-1:2014 cit codelist.                                 -\->
    <!-\- ========================================================================================================================== -\->
    <sch:diagnostics>
        <sch:diagnostic id="rule.cit.validrolecodelist-failure-en" xml:lang="en">Invalid CI_RoleCode@codelist attribute "<sch:value-of select="@codeList"/>".  Unable to obtain codelist URI and/or codelist name.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validrolecodelist-success-en" xml:lang="en">Valid CI_RoleCode@codelist attribute "<sch:value-of select="@codeList"/>".  Codelist URI is "<sch:value-of select="$URI"/>" and codelist name is "<sch:value-of select="$code-list-name"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.cit.rolecodelisturiresolves-failure-en" xml:lang="en">Unable to resolve role codelist URI "<sch:value-of select="$URI"/>" to a document.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.rolecodelisturiresolves-success-en" xml:lang="en">Successfully resolved role codelist URI "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.cit.rolecodelistnamefound-failure-en" xml:lang="en">Unable to find role codelist name "<sch:value-of select="$code-list-name"/>" in codelist document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        <sch:diagnostic id="rule.cit.rolecodelistnamefound-success-en" xml:lang="en">Role code list name "<sch:value-of select="$code-list-name"/>" found in code list document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.cit.validrolecode-attr-failure-en" xml:lang="en">CI_RoleCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validrolecode-attr-success-en" xml:lang="en">CI_RoleCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        
        <sch:diagnostic id="rule.cit.validrolecode-text-failure-en" xml:lang="en">CI_RoleCode text value "<sch:value-of select="normalize-space(.)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validrolecode-text-success-en" xml:lang="en">CI_RoleCode text value "<sch:value-of select="normalize-space(.)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Role element must specify a valid ISO 19115-1:2014 cit:CI_RoleCode codelist URI and codelist name (or profile there of), and the code value provided must occur in the specified codelist.</sch:title>
        
        <sch:rule context= "cit:role/cit:CI_RoleCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml',1,number(not(string-length(@codeList) > 0))*string-length('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('CI_RoleCode',1,number(not(string-length(@codeList) > 0))*string-length('CI_RoleCode')))" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:let name="attr-code" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="text-code" value="concat($code-list-name, '_', .)" />
            
            <sch:assert test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.cit.validrolecodelist-failure-en" >Fail.</sch:assert>
            <sch:report test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.cit.validrolecodelist-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list-document//*) > 0"
                diagnostics="rule.cit.rolecodelisturiresolves-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list-document//*) > 0"
                diagnostics="rule.cit.rolecodelisturiresolves-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list//*) > 0"
                diagnostics="rule.cit.rolecodelistnamefound-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list//*) > 0"
                diagnostics="rule.cit.rolecodelistnamefound-success-en" >Pass.</sch:report>            
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.cit.validrolecode-attr-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.cit.validrolecode-attr-success-en" >Pass.</sch:report>
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.cit.validrolecode-text-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.cit.validrolecode-text-success-en" >Pass.</sch:report>
        </sch:rule>
    </sch:pattern>

   
    <!-\- cit:numberType/cit:CI_TelephoneTypeCode -\->
    
    <!-\- ========================================================================================================================== -\->
    <!-\- Assert that the telephone type codes correspond to values in the ISO 19115-1:2014 cit codelist.                                 -\->
    <!-\- ========================================================================================================================== -\->
    <sch:diagnostics>
        <sch:diagnostic id="rule.cit.validtelephonetypecodelist-failure-en" xml:lang="en">Invalid CI_TelephoneTypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Unable to obtain codelist URI and/or codelist name.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validtelephonetypecodelist-success-en" xml:lang="en">Valid CI_TelephoneTypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Codelist URI is "<sch:value-of select="$URI"/>" and codelist name is "<sch:value-of select="$code-list-name"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.cit.telephonetypecodelisturiresolves-failure-en" xml:lang="en">Unable to resolve telephone type codelist URI "<sch:value-of select="$URI"/>" to a document.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.telephonetypecodelisturiresolves-success-en" xml:lang="en">Successfully resolved telephone type codelist URI "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.cit.telephonetypecodelistnamefound-failure-en" xml:lang="en">Unable to find telephone type codelist name "<sch:value-of select="$code-list-name"/>" in codelist document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        <sch:diagnostic id="rule.cit.telephonetypecodelistnamefound-success-en" xml:lang="en">Telephone type code list name "<sch:value-of select="$code-list-name"/>" found in code list document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.cit.validtelephonetypecode-attr-failure-en" xml:lang="en">CI_TelephoneTypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validtelephonetypecode-attr-success-en" xml:lang="en">CI_TelephoneTypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        
        <sch:diagnostic id="rule.cit.validtelephonetypecode-text-failure-en" xml:lang="en">CI_TelephoneTypeCode text value "<sch:value-of select="normalize-space(.)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validtelephonetypecode-text-success-en" xml:lang="en">CI_TelephoneTypeCode text value "<sch:value-of select="normalize-space(.)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Telephone type element must specify a valid ISO 19115-1:2014 cit:CI_TelephoneTypeCode codelist URI and codelist name (or profile there of), and the code value provided must occur in the specified codelist.</sch:title>
        
        <sch:rule context= "cit:numberType/cit:CI_TelephoneTypeCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml',1,number(not(string-length(@codeList) > 0))*string-length('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('CI_TelephoneTypeCode',1,number(not(string-length(@codeList) > 0))*string-length('CI_TelephoneTypeCode')))" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:let name="attr-code" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="text-code" value="concat($code-list-name, '_', .)" />
            
            <sch:assert test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.cit.validtelephonetypecodelist-failure-en" >Fail.</sch:assert>
            <sch:report test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.cit.validtelephonetypecodelist-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list-document//*) > 0"
                diagnostics="rule.cit.telephonetypecodelisturiresolves-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list-document//*) > 0"
                diagnostics="rule.cit.telephonetypecodelisturiresolves-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list//*) > 0"
                diagnostics="rule.cit.telephonetypecodelistnamefound-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list//*) > 0"
                diagnostics="rule.cit.telephonetypecodelistnamefound-success-en" >Pass.</sch:report>            
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.cit.validtelephonetypecode-attr-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.cit.validtelephonetypecode-attr-success-en" >Pass.</sch:report>
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.cit.validtelephonetypecode-text-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.cit.validtelephonetypecode-text-success-en" >Pass.</sch:report>
            
        </sch:rule>
    </sch:pattern>
    
    
    <!-\- mri:associationType/mri:DS_AssociationTypeCode -\->
    
    <!-\- ========================================================================================================================== -\->
    <!-\- Assert that the association type codes correspond to values in the ISO 19115-1:2014 mri codelist.                                 -\->
    <!-\- ========================================================================================================================== -\->
    <sch:diagnostics>
        <sch:diagnostic id="rule.mri.validassociationtypecodelist-failure-en" xml:lang="en">Invalid DS_AssociationTypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Unable to obtain codelist URI and/or codelist name.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.validassociationtypecodelist-success-en" xml:lang="en">Valid DS_AssociationTypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Codelist URI is "<sch:value-of select="$URI"/>" and codelist name is "<sch:value-of select="$code-list-name"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.associationtypecodelisturiresolves-failure-en" xml:lang="en">Unable to resolve association type codelist URI "<sch:value-of select="$URI"/>" to a document.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.associationtypecodelisturiresolves-success-en" xml:lang="en">Successfully resolved association type codelist URI "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.associationtypecodelistnamefound-failure-en" xml:lang="en">Unable to find association type codelist name "<sch:value-of select="$code-list-name"/>" in codelist document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        <sch:diagnostic id="rule.mri.associationtypecodelistnamefound-success-en" xml:lang="en">Association type code list name "<sch:value-of select="$code-list-name"/>" found in code list document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.associationtypecode-attr-failure-en" xml:lang="en">DS_AssociationTypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.associationtypecode-attr-success-en" xml:lang="en">DS_AssociationTypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.associationtypecode-text-failure-en" xml:lang="en">DS_AssociationTypeCode text value "<sch:value-of select="normalize-space(.)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.associationtypecode-text-success-en" xml:lang="en">DS_AssociationTypeCode text value "<sch:value-of select="normalize-space(.)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Association type element must specify a valid ISO 19115-1:2014 mri:DS_AssociationTypeCode codelist URI and codelist name (or profile there of), and the code value provided must occur in the specified codelist.</sch:title>
        
        <sch:rule context= "mri:associationType/mri:DS_AssociationTypeCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/mri/1.0/codelists.xml',1,number(not(string-length(@codeList) > 0))*string-length('http://standards.iso.org/iso/19115/-3/mri/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('DS_AssociationTypeCode',1,number(not(string-length(@codeList) > 0))*string-length('DS_AssociationTypeCode')))" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:let name="attr-code" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="text-code" value="concat($code-list-name, '_', .)" />
            
            <sch:assert test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mri.validassociationtypecodelist-failure-en" >Fail.</sch:assert>
            <sch:report test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mri.validassociationtypecodelist-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list-document//*) > 0"
                diagnostics="rule.mri.associationtypecodelisturiresolves-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list-document//*) > 0"
                diagnostics="rule.mri.associationtypecodelisturiresolves-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list//*) > 0"
                diagnostics="rule.mri.associationtypecodelistnamefound-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list//*) > 0"
                diagnostics="rule.mri.associationtypecodelistnamefound-success-en" >Pass.</sch:report>            
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mri.associationtypecode-attr-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mri.associationtypecode-attr-success-en" >Pass.</sch:report>
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mri.associationtypecode-text-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mri.associationtypecode-text-success-en" >Pass.</sch:report>
       </sch:rule>
    </sch:pattern>
    

    <!-\- mri:initiativeType/mri:DS_InitiativeTypeCode -\->
    
    <!-\- ========================================================================================================================== -\->
    <!-\- Assert that the initiative type codes correspond to values in the ISO 19115-1:2014 mri codelist.                                 -\->
    <!-\- ========================================================================================================================== -\->
    <sch:diagnostics>
        <sch:diagnostic id="rule.mri.validinitiativetypecodelist-failure-en" xml:lang="en">Invalid DS_InitiativeTypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Unable to obtain codelist URI and/or codelist name.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.validinitiativetypecodelist-success-en" xml:lang="en">Valid DS_InitiativeTypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Codelist URI is "<sch:value-of select="$URI"/>" and codelist name is "<sch:value-of select="$code-list-name"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.initiativetypecodelisturiresolves-failure-en" xml:lang="en">Unable to resolve initiative type codelist URI "<sch:value-of select="$URI"/>" to a document.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.initiativetypecodelisturiresolves-success-en" xml:lang="en">Successfully resolved initiative type codelist URI "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.initiativetypecodelistnamefound-failure-en" xml:lang="en">Unable to find initiative type codelist name "<sch:value-of select="$code-list-name"/>" in codelist document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        <sch:diagnostic id="rule.mri.initiativetypecodelistnamefound-success-en" xml:lang="en">Initiative type code list name "<sch:value-of select="$code-list-name"/>" found in code list document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.initiativetypecode-attr-failure-en" xml:lang="en">DS_InitiativeTypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.initiativetypecode-attr-success-en" xml:lang="en">DS_InitiativeTypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.initiativetypecode-text-failure-en" xml:lang="en">DS_InitiativeTypeCode text value "<sch:value-of select="normalize-space(.)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.initiativetypecode-text-success-en" xml:lang="en">DS_InitiativeTypeCode text value "<sch:value-of select="normalize-space(.)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Initiative type element must specify a valid ISO 19115-1:2014 mri:DS_InitiativeTypeCode codelist URI and codelist name (or profile there of), and the code value provided must occur in the specified codelist.</sch:title>
        
        <sch:rule context= "mri:initiativeType/mri:DS_InitiativeTypeCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/mri/1.0/codelists.xml',1,number(not(string-length(@codeList) > 0))*string-length('http://standards.iso.org/iso/19115/-3/mri/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('DS_InitiativeTypeCode',1,number(not(string-length(@codeList) > 0))*string-length('DS_InitiativeTypeCode')))" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:let name="attr-code" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="text-code" value="concat($code-list-name, '_', .)" />
            
            <sch:assert test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mri.validinitiativetypecodelist-failure-en" >Fail.</sch:assert>
            <sch:report test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mri.validinitiativetypecodelist-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list-document//*) > 0"
                diagnostics="rule.mri.initiativetypecodelisturiresolves-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list-document//*) > 0"
                diagnostics="rule.mri.initiativetypecodelisturiresolves-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list//*) > 0"
                diagnostics="rule.mri.initiativetypecodelistnamefound-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list//*) > 0"
                diagnostics="rule.mri.initiativetypecodelistnamefound-success-en" >Pass.</sch:report>            
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mri.initiativetypecode-attr-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mri.initiativetypecode-attr-success-en" >Pass.</sch:report>
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mri.initiativetypecode-text-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mri.initiativetypecode-text-success-en" >Pass.</sch:report>
        </sch:rule>
    </sch:pattern>


    <!-\- msr:cellGeometry/msr:MD_CellGeometryCode -\->
    
    <!-\- ========================================================================================================================== -\->
    <!-\- Assert that the cell geometry codes correspond to values in the ISO 19139 gmx codelist.                                    -\->
    <!-\-                                                                                                                            -\->
    <!-\- Note that this codelist is not available in ISO 19115-3, and the ISO 19139 codelist at                                     -\->
    <!-\- http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml will be used until an ISO 19115-3 version is published.   -\->
    <!-\- The ISO 19139 version of the codelist has less values than the newer codelist defined in ISO 19115-1:2014, and the XML     -\->
    <!-\- structure of the codelist is different to the structure used in ISO 19115-3 codelists.                                     -\->
    <!-\- ========================================================================================================================== -\->
    <sch:diagnostics>
        <sch:diagnostic id="rule.mri.validcellgeomcodelist-failure-en" xml:lang="en">Invalid MD_CellGeometryCode@codelist attribute "<sch:value-of select="@codeList"/>".  Unable to obtain codelist URI and/or codelist name.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.validcellgeomcodelist-success-en" xml:lang="en">Valid MD_CellGeometryCode@codelist attribute "<sch:value-of select="@codeList"/>".  Codelist URI is "<sch:value-of select="$URI"/>" and codelist name is "<sch:value-of select="$code-list-name"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.cellgeomcodelisturiresolves-failure-en" xml:lang="en">Unable to resolve cell geometry codelist URI "<sch:value-of select="$URI"/>" to a document.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.cellgeomcodelisturiresolves-success-en" xml:lang="en">Successfully resolved cell geometry codelist URI "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.cellgeomcodelistnamefound-failure-en" xml:lang="en">Unable to find cell geometry codelist name "<sch:value-of select="$code-list-name"/>" in codelist document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        <sch:diagnostic id="rule.mri.cellgeomcodelistnamefound-success-en" xml:lang="en">Cell geometry code list name "<sch:value-of select="$code-list-name"/>" found in code list document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.cellgeomcode-attr-failure-en" xml:lang="en">MD_CellGeometryCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.cellgeomcode-attr-success-en" xml:lang="en">MD_CellGeometryCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.cellgeomcode-text-failure-en" xml:lang="en">MD_CellGeometryCode text value "<sch:value-of select="normalize-space(.)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.cellgeomcode-text-success-en" xml:lang="en">MD_CellGeometryCode text value "<sch:value-of select="normalize-space(.)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Cell geometry element must specify a valid ISO 19115-1:2014 mri:MD_CellGeometryCode codelist URI and codelist name (or profile there of), and the code value provided must occur in the specified codelist.</sch:title>
        
        <sch:rule context= "msr:cellGeometry/msr:MD_CellGeometryCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml',1,number(not(string-length(@codeList) > 0))*string-length('http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('MD_CellGeometryCode',1,number(not(string-length(@codeList) > 0))*string-length('MD_CellGeometryCode')))" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//*[local-name()='CodeListDictionary'][@*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='id' ]=$code-list-name]" />
            
            <sch:assert test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mri.validcellgeomcodelist-failure-en" >Fail.</sch:assert>
            <sch:report test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mri.validcellgeomcodelist-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list-document//*) > 0"
                diagnostics="rule.mri.cellgeomcodelisturiresolves-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list-document//*) > 0"
                diagnostics="rule.mri.cellgeomcodelisturiresolves-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list//*) > 0"
                diagnostics="rule.mri.cellgeomcodelistnamefound-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list//*) > 0"
                diagnostics="rule.mri.cellgeomcodelistnamefound-success-en" >Pass.</sch:report>            
            
            <sch:assert test="$code-list/*[local-name()='codeEntry']/*[local-name()='CodeDefinition']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='identifier' ] = @codeListValue "
                diagnostics="rule.mri.cellgeomcode-attr-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/*[local-name()='codeEntry']/*[local-name()='CodeDefinition']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='identifier' ] = @codeListValue "
                diagnostics="rule.mri.cellgeomcode-attr-success-en" >Pass.</sch:report>
            
            <sch:assert test="$code-list/*[local-name()='codeEntry']/*[local-name()='CodeDefinition']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='identifier' ] = normalize-space(.) or string-length(normalize-space(.)) = 0"
                diagnostics="rule.mri.cellgeomcode-text-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/*[local-name()='codeEntry']/*[local-name()='CodeDefinition']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='identifier' ] = normalize-space(.) or string-length(normalize-space(.)) = 0"
                diagnostics="rule.mri.cellgeomcode-text-success-en" >Pass.</sch:report>
        </sch:rule>
    </sch:pattern>


    <!-\- mco:classification/mco:MD_ClassificationCode -\->
    
    <!-\- ========================================================================================================================== -\->
    <!-\- Assert that classification codes correspond to values in the ISO 19115-1:2014 mco codelist.                                 -\->
    <!-\- ========================================================================================================================== -\->
    <sch:diagnostics>
        <sch:diagnostic id="rule.mco.validclassificationcodelist-failure-en" xml:lang="en">Invalid MD_ClassificationCode@codelist attribute "<sch:value-of select="@codeList"/>".  Unable to obtain codelist URI and/or codelist name.</sch:diagnostic>
        <sch:diagnostic id="rule.mco.validclassificationcodelist-success-en" xml:lang="en">Valid MD_ClassificationCode@codelist attribute "<sch:value-of select="@codeList"/>".  Codelist URI is "<sch:value-of select="$URI"/>" and codelist name is "<sch:value-of select="$code-list-name"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mco.classificationcodelisturiresolves-failure-en" xml:lang="en">Unable to resolve classification codelist URI "<sch:value-of select="$URI"/>" to a document.</sch:diagnostic>
        <sch:diagnostic id="rule.mco.classificationcodelisturiresolves-success-en" xml:lang="en">Successfully resolved classification codelist URI "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mco.classificationcodelistnamefound-failure-en" xml:lang="en">Unable to find classification codelist name "<sch:value-of select="$code-list-name"/>" in codelist document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        <sch:diagnostic id="rule.mco.classificationcodelistnamefound-success-en" xml:lang="en">Classification code list name "<sch:value-of select="$code-list-name"/>" found in code list document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mco.classificationcode-attr-failure-en" xml:lang="en">MD_ClassificationCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mco.classificationcode-attr-success-en" xml:lang="en">MD_ClassificationCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        
        <sch:diagnostic id="rule.mco.classificationcode-text-failure-en" xml:lang="en">MD_ClassificationCode text value "<sch:value-of select="normalize-space(.)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mco.classificationcode-text-success-en" xml:lang="en">MD_ClassificationCode text value "<sch:value-of select="normalize-space(.)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Classification element must specify a valid ISO 19115-1:2014 mco:MD_ClassificationCode codelist URI and codelist name (or profile there of), and the code value provided must occur in the specified codelist.</sch:title>
        
        <sch:rule context= "mco:classification/mco:MD_ClassificationCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/mco/1.0/codelists.xml',1,number(not(string-length(@codeList) > 0))*string-length('http://standards.iso.org/iso/19115/-3/mco/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('MD_ClassificationCode',1,number(not(string-length(@codeList) > 0))*string-length('MD_ClassificationCode')))" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:let name="attr-code" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="text-code" value="concat($code-list-name, '_', .)" />
            
            <sch:assert test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mco.validclassificationcodelist-failure-en" >Fail.</sch:assert>
            <sch:report test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mco.validclassificationcodelist-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list-document//*) > 0"
                diagnostics="rule.mco.classificationcodelisturiresolves-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list-document//*) > 0"
                diagnostics="rule.mco.classificationcodelisturiresolves-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list//*) > 0"
                diagnostics="rule.mco.classificationcodelistnamefound-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list//*) > 0"
                diagnostics="rule.mco.classificationcodelistnamefound-success-en" >Pass.</sch:report>            
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mco.classificationcode-attr-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mco.classificationcode-attr-success-en" >Pass.</sch:report>
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mco.classificationcode-text-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mco.classificationcode-text-success-en" >Pass.</sch:report>
        </sch:rule>
    </sch:pattern>


    <!-\- mrc:contentType/mrc:MD_CoverageContentTypeCode -\->
    
    <!-\- ========================================================================================================================== -\->
    <!-\- Assert that coverage content type codes correspond to values in the ISO 19115-1:2014 mrc codelist.                                 -\->
    <!-\- ========================================================================================================================== -\->
    <sch:diagnostics>
        <sch:diagnostic id="rule.mrc.validcoveragecontenttypecodelist-failure-en" xml:lang="en">Invalid MD_CoverageContentTypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Unable to obtain codelist URI and/or codelist name.</sch:diagnostic>
        <sch:diagnostic id="rule.mrc.validcoveragecontenttypecodelist-success-en" xml:lang="en">Valid MD_CoverageContentTypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Codelist URI is "<sch:value-of select="$URI"/>" and codelist name is "<sch:value-of select="$code-list-name"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mrc.coveragecontenttypecodelisturiresolves-failure-en" xml:lang="en">Unable to resolve coverage content type codelist URI "<sch:value-of select="$URI"/>" to a document.</sch:diagnostic>
        <sch:diagnostic id="rule.mrc.coveragecontenttypecodelisturiresolves-success-en" xml:lang="en">Successfully resolved coverage content type codelist URI "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mrc.coveragecontenttypecodelistnamefound-failure-en" xml:lang="en">Unable to find coverage content type codelist name "<sch:value-of select="$code-list-name"/>" in codelist document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        <sch:diagnostic id="rule.mrc.coveragecontenttypecodelistnamefound-success-en" xml:lang="en">Coverage content type code list name "<sch:value-of select="$code-list-name"/>" found in code list document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mrc.coveragecontenttypecode-attr-failure-en" xml:lang="en">MD_CoverageContentTypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mrc.coveragecontenttypecode-attr-success-en" xml:lang="en">MD_CoverageContentTypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        
        <sch:diagnostic id="rule.mrc.coveragecontenttypecode-text-failure-en" xml:lang="en">MD_CoverageContentTypeCode text value "<sch:value-of select="normalize-space(.)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mrc.coveragecontenttypecode-text-success-en" xml:lang="en">MD_CoverageContentTypeCode text value "<sch:value-of select="normalize-space(.)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Coverage content type element must specify a valid ISO 19115-1:2014 mrc:MD_CoverageContentTypeCode codelist URI and codelist name (or profile there of), and the code value provided must occur in the specified codelist.</sch:title>
        
        <sch:rule context= "mrc:contentType/mrc:MD_CoverageContentTypeCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/mrc/1.0/codelists.xml',1,number(not(string-length(@codeList) > 0))*string-length('http://standards.iso.org/iso/19115/-3/mrc/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('MD_CoverageContentTypeCode',1,number(not(string-length(@codeList) > 0))*string-length('MD_CoverageContentTypeCode')))" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:let name="attr-code" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="text-code" value="concat($code-list-name, '_', .)" />
            
            <sch:assert test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mrc.validcoveragecontenttypecodelist-failure-en" >Fail.</sch:assert>
            <sch:report test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mrc.validcoveragecontenttypecodelist-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list-document//*) > 0"
                diagnostics="rule.mrc.coveragecontenttypecodelisturiresolves-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list-document//*) > 0"
                diagnostics="rule.mrc.coveragecontenttypecodelisturiresolves-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list//*) > 0"
                diagnostics="rule.mrc.coveragecontenttypecodelistnamefound-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list//*) > 0"
                diagnostics="rule.mrc.coveragecontenttypecodelistnamefound-success-en" >Pass.</sch:report>            
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mrc.coveragecontenttypecode-attr-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mrc.coveragecontenttypecode-attr-success-en" >Pass.</sch:report>
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mrc.coveragecontenttypecode-text-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mrc.coveragecontenttypecode-text-success-en" >Pass.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    
    <!-\- mex:dataType/mex:MD_DatatypeCode -\->
    
    <!-\- ========================================================================================================================== -\->
    <!-\- Assert that datatype codes correspond to values in the ISO 19115-1:2014 mex codelist.                                 -\->
    <!-\- ========================================================================================================================== -\->
    <sch:diagnostics>
        <sch:diagnostic id="rule.mex.validdatatypecodelist-failure-en" xml:lang="en">Invalid MD_DatatypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Unable to obtain codelist URI and/or codelist name.</sch:diagnostic>
        <sch:diagnostic id="rule.mex.validdatatypecodelist-success-en" xml:lang="en">Valid MD_DatatypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Codelist URI is "<sch:value-of select="$URI"/>" and codelist name is "<sch:value-of select="$code-list-name"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mex.datatypecodelisturiresolves-failure-en" xml:lang="en">Unable to resolve datatype codelist URI "<sch:value-of select="$URI"/>" to a document.</sch:diagnostic>
        <sch:diagnostic id="rule.mex.datatypecodelisturiresolves-success-en" xml:lang="en">Successfully resolved datatype codelist URI "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mex.datatypecodelistnamefound-failure-en" xml:lang="en">Unable to find datatype codelist name "<sch:value-of select="$code-list-name"/>" in codelist document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        <sch:diagnostic id="rule.mex.datatypecodelistnamefound-success-en" xml:lang="en">Datatype code list name "<sch:value-of select="$code-list-name"/>" found in code list document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mex.datatypecode-attr-failure-en" xml:lang="en">MD_DatatypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mex.datatypecode-attr-success-en" xml:lang="en">MD_DatatypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        
        <sch:diagnostic id="rule.mex.datatypecode-text-failure-en" xml:lang="en">MD_DatatypeCode text value "<sch:value-of select="normalize-space(.)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mex.datatypecode-text-success-en" xml:lang="en">MD_DatatypeCode text value "<sch:value-of select="normalize-space(.)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Datatype element must specify a valid ISO 19115-1:2014 mex:MD_DatatypeCode codelist URI and codelist name (or profile there of), and the code value provided must occur in the specified codelist.</sch:title>
        
        <sch:rule context= "mex:dataType/mex:MD_DatatypeCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/mex/1.0/codelists.xml',1,number(not(string-length(@codeList) > 0))*string-length('http://standards.iso.org/iso/19115/-3/mex/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('MD_DatatypeCode',1,number(not(string-length(@codeList) > 0))*string-length('MD_DatatypeCode')))" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:let name="attr-code" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="text-code" value="concat($code-list-name, '_', .)" />
            
            <sch:assert test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mex.validdatatypecodelist-failure-en" >Fail.</sch:assert>
            <sch:report test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mex.validdatatypecodelist-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list-document//*) > 0"
                diagnostics="rule.mex.datatypecodelisturiresolves-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list-document//*) > 0"
                diagnostics="rule.mex.datatypecodelisturiresolves-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list//*) > 0"
                diagnostics="rule.mex.datatypecodelistnamefound-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list//*) > 0"
                diagnostics="rule.mex.datatypecodelistnamefound-success-en" >Pass.</sch:report>            
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mex.datatypecode-attr-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mex.datatypecode-attr-success-en" >Pass.</sch:report>
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mex.datatypecode-text-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mex.datatypecode-text-success-en" >Pass.</sch:report>
        </sch:rule>
    </sch:pattern>-->
    

<!--    <!-\- msr:dimensionName/msr:MD_DimensionNameTypeCode -\->
    
    <!-\- ========================================================================================================================== -\->
    <!-\- Assert that the dimension name codes correspond to values in the ISO 19139 gmx codelist.                                    -\->
                                                                                                                                
    <!-\- Note that this codelist is not available in ISO 19115-3, and the ISO 19139 codelist at                                     -\->
    <!-\- http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml will be used until an ISO 19115-3 version is published.   -\->
    <!-\- The XML structure of the ISO 19139 codelist version is different to the structure used in ISO 19115-3 codelists.           -\->
    <!-\- ========================================================================================================================== -\->
    <sch:diagnostics>
        <sch:diagnostic id="rule.mri.validdimensionnamecodelist-failure-en" xml:lang="en">Invalid MD_DimensionNameTypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Unable to obtain codelist URI and/or codelist name.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.validdimensionnamecodelist-success-en" xml:lang="en">Valid MD_DimensionNameTypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Codelist URI is "<sch:value-of select="$URI"/>" and codelist name is "<sch:value-of select="$code-list-name"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.dimensionnamecodelisturiresolves-failure-en" xml:lang="en">Unable to resolve dimension name codelist URI "<sch:value-of select="$URI"/>" to a document.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.dimensionnamecodelisturiresolves-success-en" xml:lang="en">Successfully resolved dimension name codelist URI "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.dimensionnamecodelistnamefound-failure-en" xml:lang="en">Unable to find dimension name codelist name "<sch:value-of select="$code-list-name"/>" in codelist document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        <sch:diagnostic id="rule.mri.dimensionnamecodelistnamefound-success-en" xml:lang="en">Dimension name code list name "<sch:value-of select="$code-list-name"/>" found in code list document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.dimensionnamecode-attr-failure-en" xml:lang="en">MD_DimensionNameTypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.dimensionnamecode-attr-success-en" xml:lang="en">MD_DimensionNameTypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.dimensionnamecode-text-failure-en" xml:lang="en">MD_DimensionNameTypeCode text value "<sch:value-of select="normalize-space(.)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.dimensionnamecode-text-success-en" xml:lang="en">MD_DimensionNameTypeCode text value "<sch:value-of select="normalize-space(.)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Dimension name element must specify a valid ISO 19115-1:2014 msr:MD_DimensionNameTypeCode codelist URI and codelist name (or profile there of), and the code value provided must occur in the specified codelist.</sch:title>
        
        <sch:rule context= "msr:dimensionName/msr:MD_DimensionNameTypeCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml',1,number(not(string-length(@codeList) > 0))*string-length('http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('MD_DimensionNameTypeCode',1,number(not(string-length(@codeList) > 0))*string-length('MD_DimensionNameTypeCode')))" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//*[local-name()='CodeListDictionary'][@*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='id' ]=$code-list-name]" />
            
            <sch:assert test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mri.validdimensionnamecodelist-failure-en" >Fail.</sch:assert>
            <sch:report test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mri.validdimensionnamecodelist-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list-document//*) > 0"
                diagnostics="rule.mri.dimensionnamecodelisturiresolves-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list-document//*) > 0"
                diagnostics="rule.mri.dimensionnamecodelisturiresolves-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list//*) > 0"
                diagnostics="rule.mri.dimensionnamecodelistnamefound-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list//*) > 0"
                diagnostics="rule.mri.dimensionnamecodelistnamefound-success-en" >Pass.</sch:report>            
            
            <sch:assert test="$code-list/*[local-name()='codeEntry']/*[local-name()='CodeDefinition']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='identifier' ] = @codeListValue "
                diagnostics="rule.mri.dimensionnamecode-attr-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/*[local-name()='codeEntry']/*[local-name()='CodeDefinition']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='identifier' ] = @codeListValue "
                diagnostics="rule.mri.dimensionnamecode-attr-success-en" >Pass.</sch:report>
            
            <sch:assert test="$code-list/*[local-name()='codeEntry']/*[local-name()='CodeDefinition']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='identifier' ] = normalize-space(.) or string-length(normalize-space(.)) = 0"
                diagnostics="rule.mri.dimensionnamecode-text-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/*[local-name()='codeEntry']/*[local-name()='CodeDefinition']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='identifier' ] = normalize-space(.) or string-length(normalize-space(.)) = 0"
                diagnostics="rule.mri.dimensionnamecode-text-success-en" >Pass.</sch:report>
        </sch:rule>
    </sch:pattern>-->
    
    
<!--    <!-\- msr:geometricObjectType/msr:MD_GeometricObjectTypeCode -\->
    
    <!-\- ========================================================================================================================== -\->
    <!-\- Assert that the geometric obejct type codes correspond to values in the ISO 19139 gmx codelist.                            -\->
    <!-\-                                                                                                                            -\->
    <!-\- Note that this codelist is not available in ISO 19115-3, and the ISO 19139 codelist at                                     -\->
    <!-\- http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml will be used until an ISO 19115-3 version is published.   -\->
    <!-\- The XML structure of the ISO 19139 codelist version is different to the structure used in ISO 19115-3 codelists.           -\->
    <!-\- ========================================================================================================================== -\->
    <sch:diagnostics>
        <sch:diagnostic id="rule.mri.validgeomobjecttypecodelist-failure-en" xml:lang="en">Invalid MD_GeometricObjectTypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Unable to obtain codelist URI and/or codelist name.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.validgeomobjecttypecodelist-success-en" xml:lang="en">Valid MD_GeometricObjectTypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Codelist URI is "<sch:value-of select="$URI"/>" and codelist name is "<sch:value-of select="$code-list-name"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.geomobjecttypecodelisturiresolves-failure-en" xml:lang="en">Unable to resolve geometric object type codelist URI "<sch:value-of select="$URI"/>" to a document.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.geomobjecttypecodelisturiresolves-success-en" xml:lang="en">Successfully resolved geometric object type codelist URI "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.geomobjecttypecodelistnamefound-failure-en" xml:lang="en">Unable to find geometric object type codelist name "<sch:value-of select="$code-list-name"/>" in codelist document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        <sch:diagnostic id="rule.mri.geomobjecttypecodelistnamefound-success-en" xml:lang="en">Geometric object type code list name "<sch:value-of select="$code-list-name"/>" found in code list document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.geomobjecttypecode-attr-failure-en" xml:lang="en">MD_GeometricObjectTypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.geomobjecttypecode-attr-success-en" xml:lang="en">MD_GeometricObjectTypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.geomobjecttypecode-text-failure-en" xml:lang="en">MD_GeometricObjectTypeCode text value "<sch:value-of select="normalize-space(.)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.geomobjecttypecode-text-success-en" xml:lang="en">MD_GeometricObjectTypeCode text value "<sch:value-of select="normalize-space(.)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Geometric object type element must specify a valid ISO 19115-1:2014 msr:MD_GeometricObjectTypeCode codelist URI and codelist name (or profile there of), and the code value provided must occur in the specified codelist.</sch:title>
        
        <sch:rule context= "msr:geometricObjectType/msr:MD_GeometricObjectTypeCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml',1,number(not(string-length(@codeList) > 0))*string-length('http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('MD_GeometricObjectTypeCode',1,number(not(string-length(@codeList) > 0))*string-length('MD_GeometricObjectTypeCode')))" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//*[local-name()='CodeListDictionary'][@*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='id' ]=$code-list-name]" />
            
            <sch:assert test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mri.validgeomobjecttypecodelist-failure-en" >Fail.</sch:assert>
            <sch:report test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mri.validgeomobjecttypecodelist-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list-document//*) > 0"
                diagnostics="rule.mri.geomobjecttypecodelisturiresolves-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list-document//*) > 0"
                diagnostics="rule.mri.geomobjecttypecodelisturiresolves-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list//*) > 0"
                diagnostics="rule.mri.geomobjecttypecodelistnamefound-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list//*) > 0"
                diagnostics="rule.mri.geomobjecttypecodelistnamefound-success-en" >Pass.</sch:report>            
            
            <sch:assert test="$code-list/*[local-name()='codeEntry']/*[local-name()='CodeDefinition']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='identifier' ] = @codeListValue "
                diagnostics="rule.mri.geomobjecttypecode-attr-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/*[local-name()='codeEntry']/*[local-name()='CodeDefinition']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='identifier' ] = @codeListValue "
                diagnostics="rule.mri.geomobjecttypecode-attr-success-en" >Pass.</sch:report>
            
            <sch:assert test="$code-list/*[local-name()='codeEntry']/*[local-name()='CodeDefinition']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='identifier' ] = normalize-space(.) or string-length(normalize-space(.)) = 0"
                diagnostics="rule.mri.geomobjecttypecode-text-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/*[local-name()='codeEntry']/*[local-name()='CodeDefinition']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='identifier' ] = normalize-space(.) or string-length(normalize-space(.)) = 0"
                diagnostics="rule.mri.geomobjecttypecode-text-success-en" >Pass.</sch:report>
        </sch:rule>
    </sch:pattern>-->
    
    
<!--    <!-\- mrc:imagingCondition/mrc:MD_ImagingConditionCode -\->
    
    <!-\- ========================================================================================================================== -\->
    <!-\- Assert that image condition codes correspond to values in the ISO 19115-1:2014 mrc codelist.                         -\->
    <!-\- ========================================================================================================================== -\->
    <sch:diagnostics>
        <sch:diagnostic id="rule.mrc.validimageconditioncodelist-failure-en" xml:lang="en">Invalid MD_ImagingConditionCode@codelist attribute "<sch:value-of select="@codeList"/>".  Unable to obtain codelist URI and/or codelist name.</sch:diagnostic>
        <sch:diagnostic id="rule.mrc.validimageconditioncodelist-success-en" xml:lang="en">Valid MD_ImagingConditionCode@codelist attribute "<sch:value-of select="@codeList"/>".  Codelist URI is "<sch:value-of select="$URI"/>" and codelist name is "<sch:value-of select="$code-list-name"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mrc.imageconditioncodelisturiresolves-failure-en" xml:lang="en">Unable to resolve image condition codelist URI "<sch:value-of select="$URI"/>" to a document.</sch:diagnostic>
        <sch:diagnostic id="rule.mrc.imageconditioncodelisturiresolves-success-en" xml:lang="en">Successfully resolved image condition codelist URI "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mrc.imageconditioncodelistnamefound-failure-en" xml:lang="en">Unable to find image condition codelist name "<sch:value-of select="$code-list-name"/>" in codelist document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        <sch:diagnostic id="rule.mrc.imageconditioncodelistnamefound-success-en" xml:lang="en">Image condition code list name "<sch:value-of select="$code-list-name"/>" found in code list document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mrc.imageconditioncode-attr-failure-en" xml:lang="en">MD_ImagingConditionCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mrc.imageconditioncode-attr-success-en" xml:lang="en">MD_ImagingConditionCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        
        <sch:diagnostic id="rule.mrc.imageconditioncode-text-failure-en" xml:lang="en">MD_ImagingConditionCode text value "<sch:value-of select="normalize-space(.)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mrc.imageconditioncode-text-success-en" xml:lang="en">MD_ImagingConditionCode text value "<sch:value-of select="normalize-space(.)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Image condition element must specify a valid ISO 19115-1:2014 mrc:MD_ImagingConditionCode codelist URI and codelist name (or profile there of), and the code value provided must occur in the specified codelist.</sch:title>
        
        <sch:rule context= "mrc:imagingCondition/mrc:MD_ImagingConditionCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/mrc/1.0/codelists.xml',1,number(not(string-length(@codeList) > 0))*string-length('http://standards.iso.org/iso/19115/-3/mrc/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('MD_ImagingConditionCode',1,number(not(string-length(@codeList) > 0))*string-length('MD_ImagingConditionCode')))" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:let name="attr-code" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="text-code" value="concat($code-list-name, '_', .)" />
            
            <sch:assert test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mrc.validimageconditioncodelist-failure-en" >Fail.</sch:assert>
            <sch:report test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mrc.validimageconditioncodelist-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list-document//*) > 0"
                diagnostics="rule.mrc.imageconditioncodelisturiresolves-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list-document//*) > 0"
                diagnostics="rule.mrc.imageconditioncodelisturiresolves-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list//*) > 0"
                diagnostics="rule.mrc.imageconditioncodelistnamefound-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list//*) > 0"
                diagnostics="rule.mrc.imageconditioncodelistnamefound-success-en" >Pass.</sch:report>            
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mrc.imageconditioncode-attr-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mrc.imageconditioncode-attr-success-en" >Pass.</sch:report>
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mrc.imageconditioncode-text-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mrc.imageconditioncode-text-success-en" >Pass.</sch:report>
        </sch:rule>
    </sch:pattern>-->
    
    
<!--    <!-\- mri:type/mri:MD_KeywordTypeCode -\->
    
    <!-\- ========================================================================================================================== -\->
    <!-\- Assert that keyword type codes correspond to values in the ISO 19115-1:2014 mri codelist.                         -\->
    <!-\- ========================================================================================================================== -\->
    <sch:diagnostics>
        <sch:diagnostic id="rule.mri.validkeywordtypecodelist-failure-en" xml:lang="en">Invalid MD_KeywordTypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Unable to obtain codelist URI and/or codelist name.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.validkeywordtypecodelist-success-en" xml:lang="en">Valid MD_KeywordTypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Codelist URI is "<sch:value-of select="$URI"/>" and codelist name is "<sch:value-of select="$code-list-name"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.keywordtypecodelisturiresolves-failure-en" xml:lang="en">Unable to resolve keyword type codelist URI "<sch:value-of select="$URI"/>" to a document.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.keywordtypecodelisturiresolves-success-en" xml:lang="en">Successfully resolved keyword type codelist URI "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.keywordtypecodelistnamefound-failure-en" xml:lang="en">Unable to find keyword type codelist name "<sch:value-of select="$code-list-name"/>" in codelist document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        <sch:diagnostic id="rule.mri.keywordtypecodelistnamefound-success-en" xml:lang="en">Keyword type code list name "<sch:value-of select="$code-list-name"/>" found in code list document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.keywordtypecode-attr-failure-en" xml:lang="en">MD_KeywordTypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.keywordtypecode-attr-success-en" xml:lang="en">MD_KeywordTypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.keywordtypecode-text-failure-en" xml:lang="en">MD_KeywordTypeCode text value "<sch:value-of select="normalize-space(.)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.keywordtypecode-text-success-en" xml:lang="en">MD_KeywordTypeCode text value "<sch:value-of select="normalize-space(.)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Keyword type element must specify a valid ISO 19115-1:2014 mri:MD_KeywordTypeCode codelist URI and codelist name (or profile there of), and the code value provided must occur in the specified codelist.</sch:title>
        
        <sch:rule context= "mri:type/mri:MD_KeywordTypeCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/mri/1.0/codelists.xml',1,number(not(string-length(@codeList) > 0))*string-length('http://standards.iso.org/iso/19115/-3/mri/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('MD_KeywordTypeCode',1,number(not(string-length(@codeList) > 0))*string-length('MD_KeywordTypeCode')))" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:let name="attr-code" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="text-code" value="concat($code-list-name, '_', .)" />
            
            <sch:assert test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mri.validkeywordtypecodelist-failure-en" >Fail.</sch:assert>
            <sch:report test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mri.validkeywordtypecodelist-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list-document//*) > 0"
                diagnostics="rule.mri.keywordtypecodelisturiresolves-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list-document//*) > 0"
                diagnostics="rule.mri.keywordtypecodelisturiresolves-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list//*) > 0"
                diagnostics="rule.mri.keywordtypecodelistnamefound-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list//*) > 0"
                diagnostics="rule.mri.keywordtypecodelistnamefound-success-en" >Pass.</sch:report>            
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mri.keywordtypecode-attr-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mri.keywordtypecode-attr-success-en" >Pass.</sch:report>
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mri.keywordtypecode-text-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mri.keywordtypecode-text-success-en" >Pass.</sch:report>
        </sch:rule>
    </sch:pattern>-->
    
    
<!--    <!-\- mmi:maintenanceAndUpdateFrequency/mmi:MD_MaintenanceFrequencyCode -\->
    
    <!-\- ========================================================================================================================== -\->
    <!-\- Assert that maintenance frequency codes correspond to values in the ISO 19115-1:2014 mmi codelist.                         -\->
    <!-\- ========================================================================================================================== -\->
    <sch:diagnostics>
        <sch:diagnostic id="rule.mmi.validmaintenancefrequencycodelist-failure-en" xml:lang="en">Invalid MD_KeywordTypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Unable to obtain codelist URI and/or codelist name.</sch:diagnostic>
        <sch:diagnostic id="rule.mmi.validmaintenancefrequencycodelist-success-en" xml:lang="en">Valid MD_KeywordTypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Codelist URI is "<sch:value-of select="$URI"/>" and codelist name is "<sch:value-of select="$code-list-name"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mmi.maintenancefrequencycodelisturiresolves-failure-en" xml:lang="en">Unable to resolve maintenance frequency codelist URI "<sch:value-of select="$URI"/>" to a document.</sch:diagnostic>
        <sch:diagnostic id="rule.mmi.maintenancefrequencycodelisturiresolves-success-en" xml:lang="en">Successfully resolved maintenance frequency codelist URI "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mmi.maintenancefrequencycodelistnamefound-failure-en" xml:lang="en">Unable to find maintenance frequency codelist name "<sch:value-of select="$code-list-name"/>" in codelist document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        <sch:diagnostic id="rule.mmi.maintenancefrequencycodelistnamefound-success-en" xml:lang="en">Maintenance frequency code list name "<sch:value-of select="$code-list-name"/>" found in code list document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mmi.maintenancefrequencycode-attr-failure-en" xml:lang="en">MD_KeywordTypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mmi.maintenancefrequencycode-attr-success-en" xml:lang="en">MD_KeywordTypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        
        <sch:diagnostic id="rule.mmi.maintenancefrequencycode-text-failure-en" xml:lang="en">MD_KeywordTypeCode text value "<sch:value-of select="normalize-space(.)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mmi.maintenancefrequencycode-text-success-en" xml:lang="en">MD_KeywordTypeCode text value "<sch:value-of select="normalize-space(.)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Maintenance frequency element must specify a valid ISO 19115-1:2014 mmi:MD_MaintenanceFrequencyCode codelist URI and codelist name (or profile there of), and the code value provided must occur in the specified codelist.</sch:title>
        
        <sch:rule context= "mmi:maintenanceAndUpdateFrequency/mmi:MD_MaintenanceFrequencyCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/mmi/1.0/codelists.xml',1,number(not(string-length(@codeList) > 0))*string-length('http://standards.iso.org/iso/19115/-3/mmi/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('MD_KeywordTypeCode',1,number(not(string-length(@codeList) > 0))*string-length('MD_KeywordTypeCode')))" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:let name="attr-code" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="text-code" value="concat($code-list-name, '_', .)" />
            
            <sch:assert test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mmi.validmaintenancefrequencycodelist-failure-en" >Fail.</sch:assert>
            <sch:report test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mmi.validmaintenancefrequencycodelist-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list-document//*) > 0"
                diagnostics="rule.mmi.maintenancefrequencycodelisturiresolves-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list-document//*) > 0"
                diagnostics="rule.mmi.maintenancefrequencycodelisturiresolves-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list//*) > 0"
                diagnostics="rule.mmi.maintenancefrequencycodelistnamefound-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list//*) > 0"
                diagnostics="rule.mmi.maintenancefrequencycodelistnamefound-success-en" >Pass.</sch:report>            
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mmi.maintenancefrequencycode-attr-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mmi.maintenancefrequencycode-attr-success-en" >Pass.</sch:report>
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mmi.maintenancefrequencycode-text-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mmi.maintenancefrequencycode-text-success-en" >Pass.</sch:report>
        </sch:rule>
    </sch:pattern>-->
    
    
<!--    <!-\- mrd:mediumFormat/mrd:MD_MediumFormatCode -\->
    
    <!-\- ========================================================================================================================== -\->
    <!-\- Assert that medium format codes correspond to values in the ISO 19115-1:2014 mrd codelist.                                 -\->
    <!-\- ========================================================================================================================== -\->
    <sch:diagnostics>
        <sch:diagnostic id="rule.mrd.validmediumformatcodelist-failure-en" xml:lang="en">Invalid MD_MediumFormatCode@codelist attribute "<sch:value-of select="@codeList"/>".  Unable to obtain codelist URI and/or codelist name.</sch:diagnostic>
        <sch:diagnostic id="rule.mrd.validmediumformatcodelist-success-en" xml:lang="en">Valid MD_MediumFormatCode@codelist attribute "<sch:value-of select="@codeList"/>".  Codelist URI is "<sch:value-of select="$URI"/>" and codelist name is "<sch:value-of select="$code-list-name"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mrd.mediumformatcodelisturiresolves-failure-en" xml:lang="en">Unable to resolve medium format codelist URI "<sch:value-of select="$URI"/>" to a document.</sch:diagnostic>
        <sch:diagnostic id="rule.mrd.mediumformatcodelisturiresolves-success-en" xml:lang="en">Successfully resolved medium format codelist URI "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mrd.mediumformatcodelistnamefound-failure-en" xml:lang="en">Unable to find medium format codelist name "<sch:value-of select="$code-list-name"/>" in codelist document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        <sch:diagnostic id="rule.mrd.mediumformatcodelistnamefound-success-en" xml:lang="en">Medium format code list name "<sch:value-of select="$code-list-name"/>" found in code list document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mrd.mediumformatcode-attr-failure-en" xml:lang="en">MD_MediumFormatCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mrd.mediumformatcode-attr-success-en" xml:lang="en">MD_MediumFormatCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        
        <sch:diagnostic id="rule.mrd.mediumformatcode-text-failure-en" xml:lang="en">MD_MediumFormatCode text value "<sch:value-of select="normalize-space(.)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mrd.mediumformatcode-text-success-en" xml:lang="en">MD_MediumFormatCode text value "<sch:value-of select="normalize-space(.)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Medium format element must specify a valid ISO 19115-1:2014 mrd:MD_MediumFormatCode codelist URI and codelist name (or profile there of), and the code value provided must occur in the specified codelist.</sch:title>
        
        <sch:rule context= "mrd:mediumFormat/mrd:MD_MediumFormatCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/mrd/1.0/codelists.xml',1,number(not(string-length(@codeList) > 0))*string-length('http://standards.iso.org/iso/19115/-3/mrd/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('MD_MediumFormatCode',1,number(not(string-length(@codeList) > 0))*string-length('MD_MediumFormatCode')))" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:let name="attr-code" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="text-code" value="concat($code-list-name, '_', .)" />
            
            <sch:assert test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mrd.validmediumformatcodelist-failure-en" >Fail.</sch:assert>
            <sch:report test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mrd.validmediumformatcodelist-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list-document//*) > 0"
                diagnostics="rule.mrd.mediumformatcodelisturiresolves-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list-document//*) > 0"
                diagnostics="rule.mrd.mediumformatcodelisturiresolves-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list//*) > 0"
                diagnostics="rule.mrd.mediumformatcodelistnamefound-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list//*) > 0"
                diagnostics="rule.mrd.mediumformatcodelistnamefound-success-en" >Pass.</sch:report>            
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mrd.mediumformatcode-attr-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mrd.mediumformatcode-attr-success-en" >Pass.</sch:report>
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mrd.mediumformatcode-text-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mrd.mediumformatcode-text-success-en" >Pass.</sch:report>
        </sch:rule>
    </sch:pattern>-->
    
    
<!--    <!-\- mri:status/mcc:MD_ProgressCode -\->
    
    <!-\- ========================================================================================================================== -\->
    <!-\- Assert that the progress codes correspond to values in the ISO 19139 mcc codelist.                                    -\->
    <!-\-                                                                                                                            -\->
    <!-\- Note that this codelist is not available in ISO 19115-3, and the ISO 19139 codelist at                                     -\->
    <!-\- http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml will be used until an ISO 19115-3 version is published.   -\->
    <!-\- The ISO 19139 version of the codelist has less values than the newer codelist defined in ISO 19115-1:2014, and the XML     -\->
    <!-\- structure of the codelist is different to the structure used in ISO 19115-3 codelists.                                     -\->
    <!-\- ========================================================================================================================== -\->
    <sch:diagnostics>
        <sch:diagnostic id="rule.mri.validprogresscodelist-failure-en" xml:lang="en">Invalid MD_ProgressCode@codelist attribute "<sch:value-of select="@codeList"/>".  Unable to obtain codelist URI and/or codelist name.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.validprogresscodelist-success-en" xml:lang="en">Valid MD_ProgressCode@codelist attribute "<sch:value-of select="@codeList"/>".  Codelist URI is "<sch:value-of select="$URI"/>" and codelist name is "<sch:value-of select="$code-list-name"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.progresscodelisturiresolves-failure-en" xml:lang="en">Unable to resolve progress codelist URI "<sch:value-of select="$URI"/>" to a document.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.progresscodelisturiresolves-success-en" xml:lang="en">Successfully resolved progress codelist URI "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.progresscodelistnamefound-failure-en" xml:lang="en">Unable to find progress codelist name "<sch:value-of select="$code-list-name"/>" in codelist document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        <sch:diagnostic id="rule.mri.progresscodelistnamefound-success-en" xml:lang="en">Progress code list name "<sch:value-of select="$code-list-name"/>" found in code list document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.progresscode-attr-failure-en" xml:lang="en">MD_ProgressCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.progresscode-attr-success-en" xml:lang="en">MD_ProgressCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        
        <sch:diagnostic id="rule.mri.progresscode-text-failure-en" xml:lang="en">MD_ProgressCode text value "<sch:value-of select="normalize-space(.)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mri.progresscode-text-success-en" xml:lang="en">MD_ProgressCode text value "<sch:value-of select="normalize-space(.)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Progress element must specify a valid ISO 19115-1:2014 mcc:MD_ProgressCode codelist URI and codelist name (or profile there of), and the code value provided must occur in the specified codelist.</sch:title>
        
        <sch:rule context= "mri:status/mcc:MD_ProgressCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml',1,number(not(string-length(@codeList) > 0))*string-length('http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('MD_ProgressCode',1,number(not(string-length(@codeList) > 0))*string-length('MD_ProgressCode')))" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//*[local-name()='CodeListDictionary'][@*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='id' ]=$code-list-name]" />
            
            <sch:assert test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mri.validprogresscodelist-failure-en" >Fail.</sch:assert>
            <sch:report test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mri.validprogresscodelist-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list-document//*) > 0"
                diagnostics="rule.mri.progresscodelisturiresolves-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list-document//*) > 0"
                diagnostics="rule.mri.progresscodelisturiresolves-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list//*) > 0"
                diagnostics="rule.mri.progresscodelistnamefound-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list//*) > 0"
                diagnostics="rule.mri.progresscodelistnamefound-success-en" >Pass.</sch:report>            
            
            <sch:assert test="$code-list/*[local-name()='codeEntry']/*[local-name()='CodeDefinition']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='identifier' ] = @codeListValue "
                diagnostics="rule.mri.progresscode-attr-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/*[local-name()='codeEntry']/*[local-name()='CodeDefinition']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='identifier' ] = @codeListValue "
                diagnostics="rule.mri.progresscode-attr-success-en" >Pass.</sch:report>
            
            <sch:assert test="$code-list/*[local-name()='codeEntry']/*[local-name()='CodeDefinition']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='identifier' ] = normalize-space(.) or string-length(normalize-space(.)) = 0"
                diagnostics="rule.mri.progresscode-text-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/*[local-name()='codeEntry']/*[local-name()='CodeDefinition']/*[namespace-uri()='http://www.opengis.net/gml/3.2' and local-name()='identifier' ] = normalize-space(.) or string-length(normalize-space(.)) = 0"
                diagnostics="rule.mri.progresscode-text-success-en" >Pass.</sch:report>
        </sch:rule>
    </sch:pattern> -->
    
    
<!--    <!-\- mrs:referenceSystemType/mrs:MD_ReferenceSystemTypeCode -\->
    
    <!-\- ========================================================================================================================== -\->
    <!-\- Assert that reference system type codes correspond to values in the ISO 19115-1:2014 mrs codelist.                         -\->
    <!-\- ========================================================================================================================== -\->
    <sch:diagnostics>
        <sch:diagnostic id="rule.mrs.validrefsystypecodelist-failure-en" xml:lang="en">Invalid MD_ReferenceSystemTypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Unable to obtain codelist URI and/or codelist name.</sch:diagnostic>
        <sch:diagnostic id="rule.mrs.validrefsystypecodelist-success-en" xml:lang="en">Valid MD_ReferenceSystemTypeCode@codelist attribute "<sch:value-of select="@codeList"/>".  Codelist URI is "<sch:value-of select="$URI"/>" and codelist name is "<sch:value-of select="$code-list-name"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mrs.refsystypecodelisturiresolves-failure-en" xml:lang="en">Unable to resolve reference system type codelist URI "<sch:value-of select="$URI"/>" to a document.</sch:diagnostic>
        <sch:diagnostic id="rule.mrs.refsystypecodelisturiresolves-success-en" xml:lang="en">Successfully resolved reference system type codelist URI "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mrs.refsystypecodelistnamefound-failure-en" xml:lang="en">Unable to find reference system type codelist name "<sch:value-of select="$code-list-name"/>" in codelist document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        <sch:diagnostic id="rule.mrs.refsystypecodelistnamefound-success-en" xml:lang="en">Reference system type code list name "<sch:value-of select="$code-list-name"/>" found in code list document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mrs.refsystypecode-attr-failure-en" xml:lang="en">MD_ReferenceSystemTypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mrs.refsystypecode-attr-success-en" xml:lang="en">MD_ReferenceSystemTypeCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        
        <sch:diagnostic id="rule.mrs.refsystypecode-text-failure-en" xml:lang="en">MD_ReferenceSystemTypeCode text value "<sch:value-of select="normalize-space(.)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mrs.refsystypecode-text-success-en" xml:lang="en">MD_ReferenceSystemTypeCode text value "<sch:value-of select="normalize-space(.)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Reference system type element must specify a valid ISO 19115-1:2014 mrs:MD_ReferenceSystemTypeCode codelist URI and codelist name (or profile there of), and the code value provided must occur in the specified codelist.</sch:title>
        
        <sch:rule context= "mrs:referenceSystemType/mrs:MD_ReferenceSystemTypeCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/mrs/1.0/codelists.xml',1,number(not(string-length(@codeList) > 0))*string-length('http://standards.iso.org/iso/19115/-3/mrs/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('MD_ReferenceSystemTypeCode',1,number(not(string-length(@codeList) > 0))*string-length('MD_ReferenceSystemTypeCode')))" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:let name="attr-code" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="text-code" value="concat($code-list-name, '_', .)" />
            
            <sch:assert test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mrs.validrefsystypecodelist-failure-en" >Fail.</sch:assert>
            <sch:report test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mrs.validrefsystypecodelist-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list-document//*) > 0"
                diagnostics="rule.mrs.refsystypecodelisturiresolves-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list-document//*) > 0"
                diagnostics="rule.mrs.refsystypecodelisturiresolves-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list//*) > 0"
                diagnostics="rule.mrs.refsystypecodelistnamefound-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list//*) > 0"
                diagnostics="rule.mrs.refsystypecodelistnamefound-success-en" >Pass.</sch:report>            
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mrs.refsystypecode-attr-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mrs.refsystypecode-attr-success-en" >Pass.</sch:report>
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mrs.refsystypecode-text-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mrs.refsystypecode-text-success-en" >Pass.</sch:report>
        </sch:rule>
    </sch:pattern>-->
    
    
    <!-- mco:MD_RestrictionCode -->
    
    <!-- ========================================================================================================================== -->
    <!-- Assert that restriction codes correspond to values in the ISO 19115-1:2014 mrs codelist.                         -->
    <!-- ========================================================================================================================== -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.mrs.validrestrictioncodelist-failure-en" xml:lang="en">Invalid MD_RestrictionCode@codelist attribute "<sch:value-of select="@codeList"/>".  Unable to obtain codelist URI and/or codelist name.</sch:diagnostic>
        <sch:diagnostic id="rule.mrs.validrestrictioncodelist-success-en" xml:lang="en">Valid MD_RestrictionCode@codelist attribute "<sch:value-of select="@codeList"/>".  Codelist URI is "<sch:value-of select="$URI"/>" and codelist name is "<sch:value-of select="$code-list-name"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mrs.restrictioncodelisturiresolves-failure-en" xml:lang="en">Unable to resolve restriction codelist URI "<sch:value-of select="$URI"/>" to a document.</sch:diagnostic>
        <sch:diagnostic id="rule.mrs.restrictioncodelisturiresolves-success-en" xml:lang="en">Successfully resolved restriction codelist URI "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mrs.restrictioncodelistnamefound-failure-en" xml:lang="en">Unable to find restriction codelist name "<sch:value-of select="$code-list-name"/>" in codelist document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        <sch:diagnostic id="rule.mrs.restrictioncodelistnamefound-success-en" xml:lang="en">Restriction code list name "<sch:value-of select="$code-list-name"/>" found in code list document at "<sch:value-of select="$URI"/>".</sch:diagnostic>
        
        <sch:diagnostic id="rule.mrs.restrictioncode-attr-failure-en" xml:lang="en">MD_RestrictionCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mrs.restrictioncode-attr-success-en" xml:lang="en">MD_RestrictionCode@codeListValue attribute "<sch:value-of select="normalize-space(@codeListValue)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        
        <sch:diagnostic id="rule.mrs.restrictioncode-text-failure-en" xml:lang="en">MD_RestrictionCode text value "<sch:value-of select="normalize-space(.)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.mrs.restrictioncode-text-success-en" xml:lang="en">MD_RestrictionCode text value "<sch:value-of select="normalize-space(.)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Restriction element must specify a valid ISO 19115-1:2014 mco:MD_RestrictionCode codelist URI and codelist name (or profile there of), and the code value provided must occur in the specified codelist.</sch:title>
        
        <sch:rule context= "mco:MD_RestrictionCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/mco/1.0/codelists.xml',1,number(not(string-length(@codeList) > 0))*string-length('http://standards.iso.org/iso/19115/-3/mco/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('MD_RestrictionCode',1,number(not(string-length(@codeList) > 0))*string-length('MD_RestrictionCode')))" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:let name="attr-code" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="text-code" value="concat($code-list-name, '_', .)" />
            
            <sch:assert test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mrs.validrestrictioncodelist-failure-en" >Fail.</sch:assert>
            <sch:report test="string-length($URI) > 0 and string-length($code-list-name) > 0"
                diagnostics="rule.mrs.validrestrictioncodelist-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list-document//*) > 0"
                diagnostics="rule.mrs.restrictioncodelisturiresolves-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list-document//*) > 0"
                diagnostics="rule.mrs.restrictioncodelisturiresolves-success-en" >Pass.</sch:report>            
            
            <sch:assert test="count($code-list//*) > 0"
                diagnostics="rule.mrs.restrictioncodelistnamefound-failure-en" >Fail.</sch:assert>
            <sch:report test="count($code-list//*) > 0"
                diagnostics="rule.mrs.restrictioncodelistnamefound-success-en" >Pass.</sch:report>            
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mrs.restrictioncode-attr-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.mrs.restrictioncode-attr-success-en" >Pass.</sch:report>
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mrs.restrictioncode-text-failure-en" >Fail.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.mrs.restrictioncode-text-success-en" >Pass.</sch:report>
        </sch:rule>
    </sch:pattern>
</sch:schema>