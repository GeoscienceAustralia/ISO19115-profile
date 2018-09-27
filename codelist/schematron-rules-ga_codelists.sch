<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    
<!-- =========================================================================================================================
This Schematron schema applies rules that validate XML content against the codelists defined in the GA Profile of 
ISO 19115-1:2014.  All GA profile codelists conform to the CAT 1.0 schema.

These rules apply in addition to:
[1] XML Schema Validation using the ISO ISO19115-3 schema
[2] the additional conformance rules implemented as Schematron schema schematron-rules-iso.sch provided by ISO19115-3
[3] the additional conformance rules implemented as Schematron schema schematron-rules-ga.sch that apply GA Profile extensions

This script was developed by Geoscience Australia in March 2018.
==============================================================================================================================
History:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DATE			VERSION		AUTHOR				DESCRIPTION
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2018-03-01		0.1			Aaron Sedgmen		Initial Version.
==============================================================================================================================
-->
    
    <sch:title>Geoscience Australia profile Schematron schema for checking that codes in ISO 19115-1:2014 metadata documents correspond to the respective GA profile codelists</sch:title>
    
    <sch:ns prefix="cat" uri="http://standards.iso.org/iso/19115/-3/cat/1.0"  />
    <sch:ns prefix="cit" uri="http://standards.iso.org/iso/19115/-3/cit/1.0"  />
    <sch:ns prefix="gco" uri="http://standards.iso.org/iso/19115/-3/gco/1.0"  />
    <sch:ns prefix="mri" uri="http://standards.iso.org/iso/19115/-3/mri/1.0"  />
    <sch:ns prefix="srv" uri="http://standards.iso.org/iso/19115/-3/srv/2.0"  />

    
    <!-- mri:associationType/mri:DS_AssociationTypeCode -->
    
    <!-- ========================================================================================================================== -->
    <!-- Assert that the metadata association type codes correspond to values in the gapDS_AssociationTypeCode codelist.            -->
    <!--                                                                                                                            -->
    <!-- The gapDS_AssociationTypeCode codelist is the GA Profile extension of the ISO19115-1:2014 DS_AssociationTypeCode codelist. -->
    <!-- ========================================================================================================================== -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.ga.cit.validassoctypecode-failure-en" xml:lang="en">Association type code "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in gapDS_AssociationTypeCode codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.ga.cit.validassoctypecode-success-en" xml:lang="en">Association type code "<sch:value-of select="normalize-space(@codeListValue)"/>" found in gapDS_AssociationTypeCode codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Association type code in the metadata must have a corresponding entry in the gapDS_AssociationTypeCode codelist.</sch:title>
        
        <sch:rule context= "mri:associationType/mri:DS_AssociationTypeCode"  >
            
            <sch:let name="assocTypeCode" value="concat('gapDS_AssociationTypeCode_', @codeListValue)" />
            
            <sch:let name="URI" value= "'http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/assocTypeCode_codelist.xml'" />

            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="assocTypeCodeList" value=" $code-list-document//cat:CT_Codelist[ @id='gapDS_AssociationTypeCode' ]" />
            
            <sch:assert test="$assocTypeCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $assocTypeCode ]"
                diagnostics="rule.ga.cit.validassoctypecode-failure-en" >Fail mri:associationType/mri:DS_AssociationTypeCode.</sch:assert>
            
            <sch:report test="$assocTypeCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $assocTypeCode ]"
                diagnostics="rule.ga.cit.validassoctypecode-success-en" >Pass mri:associationType/mri:DS_AssociationTypeCode.</sch:report>
            
        </sch:rule>
    </sch:pattern>


    <!-- cit:function/cit:CI_OnLineFunctionCode -->
    
    <!-- ========================================================================================================================= -->
    <!-- Assert that the metadata online function codes correspond to values in the gapCI_OnLineFunctionCode codelist.             -->
    <!--                                                                                                                           -->
    <!-- The gapCI_OnLineFunctionCode codelist is the GA Profile extension of the ISO19115-1:2014 DS_AssociationTypeCode codelist. -->
    <!-- ========================================================================================================================= -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.ga.cit.validfunctioncode-failure-en" xml:lang="en">Online function code "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in gapCI_OnLineFunctionCode codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.ga.cit.validfunctioncode-success-en" xml:lang="en">Online function code "<sch:value-of select="normalize-space(@codeListValue)"/>" found in gapCI_OnLineFunctionCode codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Online function code in the metadata must have a corresponding entry in the gapCI_OnLineFunctionCode codelist.</sch:title>
        
        <sch:rule context= "cit:function/cit:CI_OnLineFunctionCode"  >
            
            <sch:let name="functionCode" value="concat('gapCI_OnLineFunctionCode_', @codeListValue)"/>
            
            <sch:let name="URI" value= "'http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/onlineFunctionCode_codelist.xml'" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="functionCodeList" value=" $code-list-document//cat:CT_Codelist[ @id='gapCI_OnLineFunctionCode' ]" />

            <sch:assert test="$functionCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $functionCode ]"
                diagnostics="rule.ga.cit.validfunctioncode-failure-en">Fail cit:function/cit:CI_OnLineFunctionCode.</sch:assert>
            
            <sch:report test="$functionCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $functionCode ]"
                diagnostics="rule.ga.cit.validfunctioncode-success-en">Pass cit:function/cit:CI_OnLineFunctionCode.</sch:report>

        </sch:rule>
    </sch:pattern>

    
    <!-- srv:serviceType -->
    
    <!-- ====================================================================================================== -->
    <!-- Assert that the metadata service type codes are present and correspond to values in the                -->
    <!-- gapSV_ServiceTypeCode codelist                                                                         -->
    <!--                                                                                                        -->
    <!-- The gapSV_ServiceTypeCode codelist in the GA Profile is an addition to the ISO19115-1:2014 standard,   -->
    <!-- for constraining the srv:serviceType free text element.                                                -->
    <!-- ====================================================================================================== -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.ga.srv.servicetypecodepresent-failure-en" xml:lang="en">@codeList and/or @codeListValue attributes are not present in service type.</sch:diagnostic>
        <sch:diagnostic id="rule.ga.srv.servicetypecodepresent-success-en" xml:lang="en">@codeList and/or @codeListValue attributes are present in service type.</sch:diagnostic>
        
        <sch:diagnostic id="rule.ga.srv.validservicetypecode-attr-failure-en" xml:lang="en">Service type code "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in gapSV_ServiceTypeCode codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.ga.srv.validservicetypecode-attr-success-en" xml:lang="en">Service type code "<sch:value-of select="normalize-space(@codeListValue)"/>" found in gapSV_ServiceTypeCode codelist.</sch:diagnostic>
        
        <sch:diagnostic id="rule.ga.srv.validservicetypecode-text-failure-en" xml:lang="en">Service type text value "<sch:value-of select="normalize-space(./gco:ScopedName)"/>" not found in gapSV_ServiceTypeCode codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.ga.srv.validservicetypecode-text-success-en" xml:lang="en">Service type text value "<sch:value-of select="normalize-space(./gco:ScopedName)"/>" found in gapSV_ServiceTypeCode codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Service type code and text must be present and have a corresponding entry in the gapSV_ServiceTypeCode codelist.</sch:title>
        
        <sch:rule context= "srv:serviceType[@codeList and @codeListValue]">
            
            <sch:let name="default_codelist_uri" value="'http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/serviceTypeCode_codelist.xml'"/>
            
            <sch:let name="URI" value= "concat(replace(substring-before(@codeList ,'#'), 'codeListLocation', '' ),
                substring($default_codelist_uri,1,number(substring-before(@codeList ,'#') = 'codeListLocation')*string-length($default_codelist_uri)),
                substring($default_codelist_uri,1,number(not(string-length(@codeList) > 0))*string-length($default_codelist_uri)))"/>
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id='gapSV_ServiceTypeCode' ]" />
            
            <sch:let name="attr-code" value="concat('gapSV_ServiceTypeCode_', @codeListValue)" />
            
            <sch:let name="text-code" value="concat('gapSV_ServiceTypeCode_', ./gco:ScopedName)" />
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.ga.srv.validservicetypecode-attr-failure-en">Fail srv:serviceType[@codeList and @codeListValue]./></sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.ga.srv.validservicetypecode-attr-success-en">Pass srv:serviceType[@codeList and @codeListValue]./></sch:report>
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.ga.srv.validservicetypecode-text-failure-en" >Fail srv:serviceType/gco:ScopedName.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.ga.srv.validservicetypecode-text-success-en" >Pass srv:serviceType/gco:ScopedName.</sch:report>
            
        </sch:rule>
        
        <sch:rule context="srv:serviceType">
            <sch:assert test="@codeList and @codeListValue"
                diagnostics="rule.ga.srv.servicetypecodepresent-failure-en">Fail srv:serviceType.</sch:assert>
            <sch:report test="@codeList and @codeListValue"
                diagnostics="rule.ga.srv.servicetypecodepresent-success-en">Pass srv:serviceType.</sch:report>            
        </sch:rule>
        
    </sch:pattern>


    <!-- cit:protocol -->
    
    <!-- ========================================================================================================= -->
    <!-- Assert that the metadata protocol type codes are present and correspond to values in the                  -->
    <!-- gapCI_ProtocolTypeCode codelist.                                                                          -->
    <!--                                                                                                           -->
    <!-- The gapCI_ProtocolTypeCode codelist in the GA Profile is an addition to the ISO19115-1:2014 standard,     -->
    <!-- for constraining the cit:protocol free text element.                                                      -->
    <!-- ========================================================================================================= -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.ga.cit.protocoltypecodepresent-failure-en" xml:lang="en">@codeList and/or @codeListValue attributes are not present in protocol.</sch:diagnostic>
        <sch:diagnostic id="rule.ga.cit.protocoltypecodepresent-success-en" xml:lang="en">@codeList and/or @codeListValue attributes are present in protocol.</sch:diagnostic>

        <sch:diagnostic id="rule.ga.cit.validprotocoltypecode-attr-failure-en" xml:lang="en">Protocol type code "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in gapCI_ProtocolTypeCode codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.ga.cit.validprotocoltypecode-attr-success-en" xml:lang="en">Protocol type code "<sch:value-of select="normalize-space(@codeListValue)"/>" found in gapCI_ProtocolTypeCode codelist.</sch:diagnostic>

        <sch:diagnostic id="rule.ga.cit.validprotocoltypecode-text-failure-en" xml:lang="en">Protocol type text value "<sch:value-of select="normalize-space(./gco:CharacterString)"/>" not found in gapCI_ProtocolTypeCode codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.ga.cit.validprotocoltypecode-text-success-en" xml:lang="en">Protocol type text value "<sch:value-of select="normalize-space(./gco:CharacterString)"/>" found in gapCI_ProtocolTypeCode codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Protocol type code and text must be present and have a corresponding entry in the gapCI_ProtocolTypeCode codelist.</sch:title>
        
        <sch:rule context= "cit:protocol[@codeList and @codeListValue]">
            
            <sch:let name="default_codelist_uri" value="'http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/protocolTypeCode_codelist.xml'"/>
            
            <sch:let name="URI" value= "concat(replace(substring-before(@codeList ,'#'), 'codeListLocation', '' ),
                substring($default_codelist_uri,1,number(substring-before(@codeList ,'#') = 'codeListLocation')*string-length($default_codelist_uri)),
                substring($default_codelist_uri,1,number(not(string-length(@codeList) > 0))*string-length($default_codelist_uri)))"/>
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id='gapCI_ProtocolTypeCode' ]" />
            
            <sch:let name="attr-code" value="concat('gapCI_ProtocolTypeCode_', @codeListValue)" />

            <sch:let name="text-code" value="concat('gapCI_ProtocolTypeCode_', ./gco:CharacterString)" />
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.ga.cit.validprotocoltypecode-attr-failure-en">Fail cit:protocol[@codeList and @codeListValue]./></sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]"
                diagnostics="rule.ga.cit.validprotocoltypecode-attr-success-en">Pass cit:protocol[@codeList and @codeListValue]./></sch:report>
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.ga.cit.validprotocoltypecode-text-failure-en" >Fail cit:protocol/gco:CharacterString.</sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0"
                diagnostics="rule.ga.cit.validprotocoltypecode-text-success-en" >Pass cit:protocol/gco:CharacterString.</sch:report>

        </sch:rule>

        <sch:rule context="cit:protocol">
            <sch:assert test="@codeList and @codeListValue"
                diagnostics="rule.ga.cit.protocoltypecodepresent-failure-en">Fail cit:protocol.</sch:assert>
            <sch:report test="@codeList and @codeListValue"
                diagnostics="rule.ga.cit.protocoltypecodepresent-success-en">Pass cit:protocol.</sch:report>            
        </sch:rule>

    </sch:pattern>
</sch:schema>