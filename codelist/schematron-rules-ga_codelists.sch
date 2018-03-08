<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" >
    
<!-- ===========================================================================
This Schematron schema applies rules that validate XML content against the 
codelists defined in the GA Profile of ISO 19115-1:2014.
These rules apply in addition to:
[1] XML Schema Validation using the ISO ISO19115-3 schema
[2] the additional conformance rules implemented as Schematron schema schematron-rules-iso.sch provided by ISO19115-3
[3] the additional conformance rules implemented as Schematron schema schematron-rules-ga.sch that apply GA Profile extensions

This script was developed by Geoscience Australia in March 2018.
================================================================================
History:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DATE			VERSION		AUTHOR				DESCRIPTION
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2018-03-01		0.1			Aaron Sedgmen		Initial Version.
================================================================================
-->
    
    <sch:title>Geoscience Australia profile Schematron schema for checking that codes in ISO 19115-1:2014 instance documents are drawn from the standard codelists</sch:title>
    
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
        <sch:diagnostic id="rule.ga.cit.validassoctypecode-failure-en" xml:lang="en">Association type code "<sch:value-of select="normalize-space($assocTypeCode)"/>" not found in gapDS_AssociationTypeCode codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.ga.cit.validassoctypecode-success-en" xml:lang="en">Association type code "<sch:value-of select="normalize-space($assocTypeCode)"/>" found in gapDS_AssociationTypeCode codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Association type code in the metadata must have a corresponding entry in the gapDS_AssociationTypeCode codelist.</sch:title>
        
        <sch:rule context= "mri:associationType/mri:DS_AssociationTypeCode"  >
            
            <sch:let name="assocTypeCode" value="concat('gapDS_AssociationTypeCode_', @codeListValue)" />
            
            <sch:let name="URI" value= "'http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/assocTypeCode_codelist.xml'" />

            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="assocTypeCodeList" value=" $code-list-document//cat:CT_Codelist[ @id='gapDS_AssociationTypeCode' ]" />
            
            <sch:assert test="$assocTypeCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $assocTypeCode ]"
                diagnostics="rule.ga.cit.validassoctypecode-failure-en" >fail <sch:value-of select="normalize-space($assocTypeCode)"/></sch:assert>
            
            <sch:report test="$assocTypeCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $assocTypeCode ]"
                diagnostics="rule.ga.cit.validassoctypecode-success-en" >pass <sch:value-of select="normalize-space($assocTypeCode)"/></sch:report>
            
        </sch:rule>
    </sch:pattern>

    <!-- cit:function/cit:CI_OnLineFunctionCode -->
    
    <!-- ========================================================================================================================= -->
    <!-- Assert that the metadata online function codes correspond to values in the gapCI_OnLineFunctionCode codelist.             -->
    <!--                                                                                                                           -->
    <!-- The gapCI_OnLineFunctionCode codelist is the GA Profile extension of the ISO19115-1:2014 DS_AssociationTypeCode codelist. -->
    <!-- ========================================================================================================================= -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.ga.cit.validfunctioncode-failure-en" xml:lang="en">Online function code "<sch:value-of select="normalize-space($functionCode)"/>" not found in gapCI_OnLineFunctionCode codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.ga.cit.validfunctioncode-success-en" xml:lang="en">Online function code "<sch:value-of select="normalize-space($functionCode)"/>" found in gapCI_OnLineFunctionCode codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Online function code in the metadata must have a corresponding entry in the gapCI_OnLineFunctionCode codelist.</sch:title>
        
        <sch:rule context= "cit:function/cit:CI_OnLineFunctionCode"  >
            
            <sch:let name="functionCode" value="concat('gapCI_OnLineFunctionCode_', @codeListValue)"/>
            
            <sch:let name="URI" value= "'http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/onlineFunctionCode_codelist.xml'" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="functionCodeList" value=" $code-list-document//cat:CT_Codelist[ @id='gapCI_OnLineFunctionCode' ]" />

            <sch:assert test="$functionCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $functionCode ]"
                diagnostics="rule.ga.cit.validfunctioncode-failure-en">fail <sch:value-of select="normalize-space($functionCode)"/></sch:assert>
            
            <sch:report test="$functionCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $functionCode ]"
                diagnostics="rule.ga.cit.validfunctioncode-success-en">pass <sch:value-of select="normalize-space($functionCode)"/></sch:report>

        </sch:rule>
    </sch:pattern>
    
    <!-- srv:serviceType -->
    
    <!-- ====================================================================================================== -->
    <!-- Assert that the metadata service type codes correspond to values in the gapSV_ServiceTypeCode codelist -->
    <!--                                                                                                        -->
    <!-- The gapSV_ServiceTypeCode codelist in the GA Profile is an addition to the ISO19115-1:2014 standard,   -->
    <!-- for constraining the srv:serviceType free text element.                                                -->
    <!-- ====================================================================================================== -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.ga.cit.validservicetypecode-failure-en" xml:lang="en">Service type code "<sch:value-of select="normalize-space($serviceTypeCode)"/>" not found in gapSV_ServiceTypeCode codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.ga.cit.validservicetypecode-success-en" xml:lang="en">Service type code "<sch:value-of select="normalize-space($serviceTypeCode)"/>" found in gapSV_ServiceTypeCode codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Service type code in the metadata must have a corresponding entry in the gapSV_ServiceTypeCode codelist.</sch:title>
        
        <sch:rule context= "srv:serviceType"  >
            
            <sch:let name="serviceTypeCode" value="concat('gapSV_ServiceTypeCode_', @codeListValue)"/>
            
            <sch:let name="URI" value= "'http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/serviceTypeCode_codelist.xml'" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="serviceTypeCodeList" value=" $code-list-document//cat:CT_Codelist[ @id='gapSV_ServiceTypeCode' ]" />
            
            <sch:assert test="$serviceTypeCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $serviceTypeCode ]"
                diagnostics="rule.ga.cit.validservicetypecode-failure-en">fail <sch:value-of select="normalize-space($serviceTypeCode)"/></sch:assert>
            
            <sch:report test="$serviceTypeCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $serviceTypeCode ]"
                diagnostics="rule.ga.cit.validservicetypecode-success-en">pass <sch:value-of select="normalize-space($serviceTypeCode)"/></sch:report>
            
        </sch:rule>
    </sch:pattern>

    <!-- cit:protocol -->
    
    <!-- ========================================================================================================= -->
    <!-- Assert that the metadata protocol type codes correspond to values in the gapCI_ProtocolTypeCode codelist. -->
    <!--                                                                                                           -->
    <!-- The gapCI_ProtocolTypeCode codelist in the GA Profile is an addition to the ISO19115-1:2014 standard,     -->
    <!-- for constraining the cit:protocol free text element.                                                      -->
    <!-- ========================================================================================================= -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.ga.cit.validprotocoltypecode-failure-en" xml:lang="en">Service type code "<sch:value-of select="normalize-space($protocolTypeCode)"/>" not found in gapCI_ProtocolTypeCode codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.ga.cit.validprotocoltypecode-success-en" xml:lang="en">Service type code "<sch:value-of select="normalize-space($protocolTypeCode)"/>" found in gapCI_ProtocolTypeCode codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Protocol type code in the metadata must have a corresponding entry in the gapCI_ProtocolTypeCode codelist.</sch:title>
        
        <sch:rule context= "cit:protocol"  >
            
            <sch:let name="protocolTypeCode" value="concat('gapCI_ProtocolTypeCode_', @codeListValue)"/>
            
            <sch:let name="URI" value= "'http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/protocolTypeCode_codelist.xml'" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="protocolTypeCodeList" value=" $code-list-document//cat:CT_Codelist[ @id='gapCI_ProtocolTypeCode' ]" />
            
            <sch:assert test="$protocolTypeCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $protocolTypeCode ]"
                diagnostics="rule.ga.cit.validprotocoltypecode-failure-en">fail <sch:value-of select="normalize-space($protocolTypeCode)"/></sch:assert>
            
            <sch:report test="$protocolTypeCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $protocolTypeCode ]"
                diagnostics="rule.ga.cit.validprotocoltypecode-success-en">pass <sch:value-of select="normalize-space($protocolTypeCode)"/></sch:report>
            
        </sch:rule>
    </sch:pattern>

</sch:schema>