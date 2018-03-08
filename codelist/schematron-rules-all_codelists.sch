<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">

    <sch:title>Schematron schema for checking that codes in ISO 19115-1:2014 metadata documents correspond to the ISO 19115-1:2014 codelists</sch:title>
    
    <sch:ns prefix="cat" uri="http://standards.iso.org/iso/19115/-3/cat/1.0"  />
    <sch:ns prefix="cit" uri="http://standards.iso.org/iso/19115/-3/cit/1.0"  />
    <sch:ns prefix="gco" uri="http://standards.iso.org/iso/19115/-3/gco/1.0"  />
    <sch:ns prefix="mri" uri="http://standards.iso.org/iso/19115/-3/mri/1.0"  />
    <sch:ns prefix="srv" uri="http://standards.iso.org/iso/19115/-3/srv/2.0"  />

    <!-- cit:dateType/cit:CI_DateTypeCode -->

    <!-- ========================================================================================================================== -->
    <!-- Assert that the date type codes correspond to values in the ISO 19115-1:2014 cit codelist.                                                  -->
    <!-- ========================================================================================================================== -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.cit.validdatetypecode-failure-en" xml:lang="en">Date type code "<sch:value-of select="normalize-space($dateTypeCode)"/>" not found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.cit.validdatetypecode-success-en" xml:lang="en">Date type code "<sch:value-of select="normalize-space($dateTypeCode)"/>" found in "<sch:value-of select="normalize-space($URI)"/>" codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Date type code must be a value from the ISO 19115-1:2014 cit:CI_DateTypeCode codelist (or profile there of).</sch:title>
        
        <sch:rule context= "cit:dateType/cit:CI_DateTypeCode"  >
            
            <sch:let name="URI" value= "concat(substring-before(@codeList ,'#'),substring('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml',1,number(not(substring-before(@codeList ,'#')))*string-length('http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml')))"/>
            
            <sch:let name="code-list-name" value= "concat(substring-after(@codeList ,'#'),substring('CI_DateTypeCode',1,number(not(substring-after(@codeList ,'#')))*string-length('CI_DateTypeCode')))" />
            
            <sch:let name="dateTypeCode" value="concat($code-list-name, '_', @codeListValue)" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="dateTypeCodeList" value=" $code-list-document//cat:CT_Codelist[ @id=$code-list-name ]" />
            
            <sch:assert test="$dateTypeCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $dateTypeCode ]"
                diagnostics="rule.cit.validdatetypecode-failure-en" >Fail.</sch:assert>
            
            <sch:report test="$dateTypeCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $dateTypeCode ]"
                diagnostics="rule.cit.validdatetypecode-success-en" >Pass.</sch:report>
      
        </sch:rule>
    </sch:pattern>

</sch:schema>