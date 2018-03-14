<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">

<!-- ===========================================================================
This Schematron validates the relevant elements in ISO 19115-3 metadata documents against all 32 official codelists 
defined in the ISO 19115-1:2014 standard.  The Schematron will also validate elements with codelists that extend the 
official ISO 19115-1:2014 codelists (i.e. a community profile).

For each element being validated, the codelist attribute is expected to contain the URL of the codelist document and 
codelist ID, seperated by a '#'.  For example: http://example.org.au/codelists.xml#codelistId  

If the codelist value does not match the expected pattern, the official codelist URL location and ID for the element
element being validated will be used by default. This assumes that when the metadata publisher has not attempted to
provide a codelist value, or provides a value that does not conform to the pattern, the official codelist is applicable.

Note that this Schematron only validates elements which are constrained by the 32 possible codelists in the base
ISO 19115-1:2014 standard (or extensions there of) - new codelists produced by constraining free text elements, 
defined by a community profile of ISO 19115-1:2014, are not accommodated in this Schematron validation.
    
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
    <sch:ns prefix="mri" uri="http://standards.iso.org/iso/19115/-3/mri/1.0"  />
    <sch:ns prefix="srv" uri="http://standards.iso.org/iso/19115/-3/srv/2.0"  />

    <!-- cit:dateType/cit:CI_DateTypeCode -->

    <!-- ========================================================================================================================== -->
    <!-- Assert that the date type codes correspond to values in the ISO 19115-1:2014 cit codelist.                                 -->
    <!-- ========================================================================================================================== -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.cit.validdatetypecode-failure-en" xml:lang="en">Date type code "<sch:value-of select="normalize-space($code)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validdatetypecode-success-en" xml:lang="en">Date type code "<sch:value-of select="normalize-space($code)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Date type code must be a value from the ISO 19115-1:2014 cit:CI_DateTypeCode codelist (or profile there of).</sch:title>
        
        <sch:rule context= "cit:dateType/cit:CI_DateTypeCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml',1,number(not(substring-before(@codeList ,'#')))*string-length('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('CI_DateTypeCode',1,number(not(substring-after(@codeList ,'#')))*string-length('CI_DateTypeCode')))" />
            
            <sch:let name="code" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $code ]"
                diagnostics="rule.cit.validdatetypecode-failure-en" >Fail.</sch:assert>
            
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $code ]"
                diagnostics="rule.cit.validdatetypecode-success-en" >Pass.</sch:report>
      
        </sch:rule>
    </sch:pattern>


    <!-- cit:function/cit:CI_OnLineFunctionCode -->
    
    <!-- ========================================================================================================================== -->
    <!-- Assert that the online function codes correspond to values in the ISO 19115-1:2014 cit codelist.                                 -->
    <!-- ========================================================================================================================== -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.cit.validonlinefunctioncode-failure-en" xml:lang="en">Online function code "<sch:value-of select="normalize-space($code)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validonlinefunctioncode-success-en" xml:lang="en">Online function code "<sch:value-of select="normalize-space($code)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Online function code must be a value from the ISO 19115-1:2014 cit:CI_OnLineFunctionCode codelist (or profile there of).</sch:title>
        
        <sch:rule context= "cit:function/cit:CI_OnLineFunctionCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml',1,number(not(substring-before(@codeList ,'#')))*string-length('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('CI_OnLineFunctionCode',1,number(not(substring-after(@codeList ,'#')))*string-length('CI_OnLineFunctionCode')))" />
            
            <sch:let name="code" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $code ]"
                diagnostics="rule.cit.validonlinefunctioncode-failure-en" >Fail.</sch:assert>
            
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $code ]"
                diagnostics="rule.cit.validonlinefunctioncode-success-en" >Pass.</sch:report>
            
        </sch:rule>
    </sch:pattern>


    <!-- cit:presentationForm/cit:CI_PresentationFormCode -->
    
    <!-- ========================================================================================================================== -->
    <!-- Assert that the presentation form codes correspond to values in the ISO 19115-1:2014 cit codelist.                                 -->
    <!-- ========================================================================================================================== -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.cit.validpresentationformcode-failure-en" xml:lang="en">Presentation form code "<sch:value-of select="normalize-space($code)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validpresentationformcode-success-en" xml:lang="en">Presentation form code "<sch:value-of select="normalize-space($code)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Presentation form code must be a value from the ISO 19115-1:2014 cit:CI_PresentationFormCode codelist (or profile there of).</sch:title>
        
        <sch:rule context= "cit:presentationForm/cit:CI_PresentationFormCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml',1,number(not(substring-before(@codeList ,'#')))*string-length('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('CI_PresentationFormCode',1,number(not(substring-after(@codeList ,'#')))*string-length('CI_PresentationFormCode')))" />
            
            <sch:let name="code" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $code ]"
                diagnostics="rule.cit.validpresentationformcode-failure-en" >Fail.</sch:assert>
            
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $code ]"
                diagnostics="rule.cit.validpresentationformcode-success-en" >Pass.</sch:report>
            
        </sch:rule>
    </sch:pattern>


    <!-- cit:role/cit:CI_RoleCode -->
    
    <!-- ========================================================================================================================== -->
    <!-- Assert that the role codes correspond to values in the ISO 19115-1:2014 cit codelist.                                 -->
    <!-- ========================================================================================================================== -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.cit.validrolecode-failure-en" xml:lang="en">Role code "<sch:value-of select="normalize-space($code)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validrolecode-success-en" xml:lang="en">Rolecode "<sch:value-of select="normalize-space($code)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Role code must be a value from the ISO 19115-1:2014 cit:CI_RoleCode codelist (or profile there of).</sch:title>
        
        <sch:rule context= "cit:role/cit:CI_RoleCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml',1,number(not(substring-before(@codeList ,'#')))*string-length('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('CI_RoleCode',1,number(not(substring-after(@codeList ,'#')))*string-length('CI_RoleCode')))" />
            
            <sch:let name="code" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $code ]"
                diagnostics="rule.cit.validrolecode-failure-en" >Fail.</sch:assert>
            
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $code ]"
                diagnostics="rule.cit.validrolecode-success-en" >Pass.</sch:report>
            
        </sch:rule>
    </sch:pattern>
    
    
    <!-- cit:numberType/cit:CI_TelephoneTypeCode -->
    
    <!-- ========================================================================================================================== -->
    <!-- Assert that the telephone type codes correspond to values in the ISO 19115-1:2014 cit codelist.                                 -->
    <!-- ========================================================================================================================== -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.cit.validtelephonetypecode-failure-en" xml:lang="en">Telephone type code "<sch:value-of select="normalize-space($code)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validtelephonetypecode-success-en" xml:lang="en">Telephone type form code "<sch:value-of select="normalize-space($code)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Telephone type code must be a value from the ISO 19115-1:2014 cit:CI_TelephoneTypeCode codelist (or profile there of).</sch:title>
        
        <sch:rule context= "cit:numberType/cit:CI_TelephoneTypeCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml',1,number(not(substring-before(@codeList ,'#')))*string-length('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('CI_TelephoneTypeCode',1,number(not(substring-after(@codeList ,'#')))*string-length('CI_TelephoneTypeCode')))" />
            
            <sch:let name="code" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $code ]"
                diagnostics="rule.cit.validtelephonetypecode-failure-en" >Fail.</sch:assert>
            
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $code ]"
                diagnostics="rule.cit.validtelephonetypecode-success-en" >Pass.</sch:report>
            
        </sch:rule>
    </sch:pattern>
    
    
    <!-- mri:associationType/mri:DS_AssociationTypeCode -->
    
    <!-- ========================================================================================================================== -->
    <!-- Assert that the association type codes correspond to values in the ISO 19115-1:2014 mri codelist.                                 -->
    <!-- ========================================================================================================================== -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.cit.validassociationtypecode-failure-en" xml:lang="en">Association type code "<sch:value-of select="normalize-space($code)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validassociationtypecode-success-en" xml:lang="en">Association type form code "<sch:value-of select="normalize-space($code)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Association type code must be a value from the ISO 19115-1:2014 mri:DS_AssociationTypeCode codelist (or profile there of).</sch:title>
        
        <sch:rule context= "mri:associationType/mri:DS_AssociationTypeCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/mri/1.0/codelists.xml',1,number(not(substring-before(@codeList ,'#')))*string-length('http://standards.iso.org/iso/19115/-3/mri/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('DS_AssociationTypeCode',1,number(not(substring-after(@codeList ,'#')))*string-length('DS_AssociationTypeCode')))" />
            
            <sch:let name="code" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $code ]"
                diagnostics="rule.cit.validassociationtypecode-failure-en" >Fail.</sch:assert>
            
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $code ]"
                diagnostics="rule.cit.validassociationtypecode-success-en" >Pass.</sch:report>
            
        </sch:rule>
    </sch:pattern>
    
</sch:schema>