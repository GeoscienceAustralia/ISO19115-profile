<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" >
    
    <sch:title>Geoscience Australia profile Schematron schema for checking that codes in ISO 19115-1:2014 instance documents are drawn from the standard codelists</sch:title>
    
    <sch:ns prefix="cat" uri="http://standards.iso.org/iso/19115/-3/cat/1.0"  />
    <sch:ns prefix="cit" uri="http://standards.iso.org/iso/19115/-3/cit/1.0"  />
    <sch:ns prefix="gco" uri="http://standards.iso.org/iso/19115/-3/gco/1.0"  />
    <sch:ns prefix="mri" uri="http://standards.iso.org/iso/19115/-3/mri/1.0"  />
    
    <!-- mri:associationType/mri:DS_AssociationTypeCode -->
    
    <!-- ============================================================================================================ -->
    <!-- Assert that the metadata association type codes correspond to values in the DS_AssociationTypeCode codelist -->
    <!-- ============================================================================================================ -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.ga.cit.validassoctypecode-failure-en" xml:lang="en">Association type code "<sch:value-of select="normalize-space($assocTypeCode)"/>" not found in DS_AssociationTypeCode codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.ga.cit.validassoctypecode-success-en" xml:lang="en">Association type code "<sch:value-of select="normalize-space($assocTypeCode)"/>" found in DS_AssociationTypeCode codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Association type code in the metadata must have a corresponding entry in the DS_AssociationTypeCode codelist.</sch:title>
        
        <sch:rule context= "mri:associationType/mri:DS_AssociationTypeCode"  >
            
            <sch:let name="assocTypeCode" value="concat('DS_AssociationTypeCode_', @codeListValue)" />
            
            <!--<sch:let name="URI" value= "'assocType_codelist.xml'" />--> <!-- the codelist document is expected to be in the same directory as this schematron file -->
            
<!--            <sch:let name="URI" value= "'http://standards.iso.org/iso/19115/-3/mri/1.0/codelists.xml'" />
-->            
            <sch:let name="URI" value= "@codeList" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="assocTypeCodeList" value=" $code-list-document//cat:CT_Codelist[ @id='DS_AssociationTypeCode' ]" />
            
            <sch:assert test="$assocTypeCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $assocTypeCode ]"
                diagnostics="rule.ga.cit.validassoctypecode-failure-en" >fail <sch:value-of select="normalize-space($assocTypeCode)"/></sch:assert>
            
            <sch:report test="$assocTypeCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $assocTypeCode ]"
                diagnostics="rule.ga.cit.validassoctypecode-success-en" >pass <sch:value-of select="normalize-space($assocTypeCode)"/></sch:report>
            
        </sch:rule>
    </sch:pattern>

    <!-- cit:function/cit:CI_OnLineFunctionCode -->
    
    <!-- ============================================================================================================ -->
    <!-- Assert that the metadata online function codes correspond to values in the CI_OnLineFunctionCode codelist -->
    <!-- ============================================================================================================ -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.ga.cit.validfunctioncode-failure-en" xml:lang="en">Online function code "<sch:value-of select="normalize-space($functionCode)"/>" not found in CI_OnLineFunctionCode codelist.</sch:diagnostic>
        <sch:diagnostic id="rule.ga.cit.validfunctioncode-success-en" xml:lang="en">Online function code "<sch:value-of select="normalize-space($functionCode)"/>" found in CI_OnLineFunctionCode codelist.</sch:diagnostic>
    </sch:diagnostics>
    
    <sch:pattern>
        <sch:title xml:lang="en">Online function code in the metadata must have a corresponding entry in the CI_OnLineFunctionCode codelist.</sch:title>
        
        <sch:rule context= "cit:function/cit:CI_OnLineFunctionCode"  >
            
            <sch:let name="functionCode" value="concat('CI_OnLineFunctionCode_', @codeListValue)"/>
            
            <!--<sch:let name="URI" value= "'onlineFunction_codelist.xml'" />--> <!-- the codelist document is expected to be in the same directory as this schematron file -->
            
            <sch:let name="URI" value= "'http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml'" />
            
            <sch:let name="code-list-document" value="document( $URI )"/>
            
            <sch:let name="functionCodeList" value=" $code-list-document//cat:CT_Codelist[ @id='CI_OnLineFunctionCode' ]" />

            <sch:assert test="$functionCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $functionCode ]"
                diagnostics="rule.ga.cit.validfunctioncode-failure-en">fail <sch:value-of select="normalize-space($functionCode)"/></sch:assert>
            
            <sch:report test="$functionCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $functionCode ]"
                diagnostics="rule.ga.cit.validfunctioncode-success-en">pass <sch:value-of select="normalize-space($functionCode)"/></sch:report>

        </sch:rule>
    </sch:pattern>
    
</sch:schema>