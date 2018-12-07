<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    
<!-- =========================================================================================================================
This Schematron schema applies rules that validate XML content against the codelists defined in the GA Profile of 
ISO 19115-1:2014 (see http://pid.geoscience.gov.au/dataset/ga/122551).  The GA profile codelists conform to the CAT 1.0 schema.

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
2018-12-07		0.2			Aaron Sedgmen		Inclusion of validation of node text when provided.
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
    <sch:pattern>
        <sch:title xml:lang="en">Association type code and text must have a corresponding entry in the gapDS_AssociationTypeCode codelist.</sch:title>

        <sch:rule context= "mri:associationType[mri:DS_AssociationTypeCode[text()]]">
            
            <sch:let name="URI" value="'http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/ga_profile_codelists.xml'"/>
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id='gapDS_AssociationTypeCode' ]" />
            
            <sch:let name="text-code" value="./mri:DS_AssociationTypeCode" />
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0">
                Association type text value "<sch:value-of select="normalize-space($text-code)"/>" not found in gapDS_AssociationTypeCode codelist.
            </sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0">
                Association type text value "<sch:value-of select="normalize-space($text-code)"/>" found in gapDS_AssociationTypeCode codelist.
            </sch:report>
            
        </sch:rule>
        
        <sch:rule context= "mri:DS_AssociationTypeCode[@codeListValue]">
            
            <sch:let name="URI" value="'http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/ga_profile_codelists.xml'"/>
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id='gapDS_AssociationTypeCode' ]" />
            
            <sch:let name="attr-code" value="@codeListValue" />
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]">
                Association type code "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in gapDS_AssociationTypeCode codelist.
            </sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]">
                Association type code "<sch:value-of select="normalize-space(@codeListValue)"/>" found in gapDS_AssociationTypeCode codelist.
            </sch:report>
            
        </sch:rule>
        
    </sch:pattern>


    <!-- cit:function/cit:CI_OnLineFunctionCode -->
    
    <!-- ========================================================================================================================= -->
    <!-- Assert that the metadata online function codes correspond to values in the gapCI_OnLineFunctionCode codelist.             -->
    <!--                                                                                                                           -->
    <!-- The gapCI_OnLineFunctionCode codelist is the GA Profile extension of the ISO19115-1:2014 DS_AssociationTypeCode codelist. -->
    <!-- ========================================================================================================================= -->
    <sch:pattern>
        <sch:title xml:lang="en">Online function code and text must have must have a corresponding entry in the gapCI_OnLineFunctionCode codelist.</sch:title>

        <sch:rule context= "cit:function[cit:CI_OnLineFunctionCode[text()]]">
            
            <sch:let name="URI" value="'http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/ga_profile_codelists.xml'"/>
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id='gapCI_OnLineFunctionCode' ]" />
            
            <sch:let name="text-code" value="./cit:CI_OnLineFunctionCode" />
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0">
                Online function text value "<sch:value-of select="normalize-space($text-code)"/>" not found in gapCI_OnLineFunctionCode codelist.
            </sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0">
                Online function text value "<sch:value-of select="normalize-space($text-code)"/>" found in gapCI_OnLineFunctionCode codelist.
            </sch:report>
            
        </sch:rule>
        
        <sch:rule context= "cit:CI_OnLineFunctionCode[@codeListValue]">
            
            <sch:let name="URI" value="'http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/ga_profile_codelists.xml'"/>
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id='gapCI_OnLineFunctionCode' ]" />
            
            <sch:let name="attr-code" value="@codeListValue" />
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]">
                Online function code "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in gapCI_OnLineFunctionCode codelist.
            </sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]">
                Online function code "<sch:value-of select="normalize-space(@codeListValue)"/>" found in gapCI_OnLineFunctionCode codelist.
            </sch:report>
            
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
    <sch:pattern>
        <sch:title xml:lang="en">Service type code and text must have a corresponding entry in the gapSV_ServiceTypeCode codelist.</sch:title>

        <sch:rule context= "srv:serviceType/gco:ScopedName">
            
            <sch:let name="URI" value="'http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/ga_profile_codelists.xml'"/>
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id='gapSV_ServiceTypeCode' ]" />
            
            <sch:let name="text-code" value="." />
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0">
                Service type text value "<sch:value-of select="normalize-space(.)"/>" not found in gapSV_ServiceTypeCode codelist.
            </sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0">
                Service type text value "<sch:value-of select="normalize-space(.)"/>" found in gapSV_ServiceTypeCode codelist.
            </sch:report>
            
        </sch:rule>
        
        <sch:rule context= "srv:serviceType[@codeListValue]">
            
            <sch:let name="URI" value="'http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/ga_profile_codelists.xml'"/>
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id='gapSV_ServiceTypeCode' ]" />
            
            <sch:let name="attr-code" value="@codeListValue" />
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]">
                Service type code "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in gapSV_ServiceTypeCode codelist.
            </sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]">
                Service type code "<sch:value-of select="normalize-space(@codeListValue)"/>" found in gapSV_ServiceTypeCode codelist.
            </sch:report>
            
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
    <sch:pattern>
        <sch:title xml:lang="en">Protocol type code and text must have a corresponding entry in the gapCI_ProtocolTypeCode codelist.</sch:title>
        
        <sch:rule context= "cit:protocol/gco:CharacterString">
            
            <sch:let name="URI" value="'http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/ga_profile_codelists.xml'"/>
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id='gapCI_ProtocolTypeCode' ]" />
            
            <sch:let name="text-code" value="." />
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0">
                Protocol type text value "<sch:value-of select="normalize-space(.)"/>" not found in gapCI_ProtocolTypeCode codelist.
            </sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $text-code ] or string-length(.) = 0">
                Protocol type text value "<sch:value-of select="normalize-space(.)"/>" found in gapCI_ProtocolTypeCode codelist.
            </sch:report>
            
        </sch:rule>
        
        <sch:rule context= "cit:protocol[@codeListValue]">
            
            <sch:let name="URI" value="'http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/ga_profile_codelists.xml'"/>
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="code-list" value=" $code-list-document//cat:CT_Codelist[ @id='gapCI_ProtocolTypeCode' ]" />
            
            <sch:let name="attr-code" value="@codeListValue" />
            
            <sch:assert test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]">
                Protocol type code "<sch:value-of select="normalize-space(@codeListValue)"/>" not found in gapCI_ProtocolTypeCode codelist.
            </sch:assert>
            <sch:report test="$code-list/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $attr-code ]">
                Protocol type code "<sch:value-of select="normalize-space(@codeListValue)"/>" found in gapCI_ProtocolTypeCode codelist.
            </sch:report>
            
        </sch:rule>

    </sch:pattern>
</sch:schema>