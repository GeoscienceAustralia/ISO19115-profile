<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">

<!-- ================================================================================================================
This Schematron provides validation of constraints imposed by the Geoscience Australia Profile of ISO 19115-1:2014
(see http://pid.geoscience.gov.au/dataset/ga/122551).
    
This script was developed by Geoscience Australia, initial version March 2018.
=====================================================================================================================
History:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DATE            VERSION     AUTHOR              DESCRIPTION
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2018-03-30      0.1         Aaron Sedgmen       Initial Version.
2018-09-26      1.0         Aaron Sedgmen       Revision based on finalisation of the GA Profile
2018-11-07      1.1         Aaron Sedgmen       Implemented rules for protocol and service type codelist extensions
2018-12-21      1.2         Aaron Sedgmen       Revision of rules for protocol and service type codelist extensions
2019-03-06      1.3         Aaron Sedgmen       Inclusion of top level title
===================================================================================================================== -->
    
    <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="en">Schematron validation for Geoscience Australia Profile of ISO 19115-1:2014</sch:title>
	
    <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2"/>
    <sch:ns prefix="srv" uri="http://standards.iso.org/iso/19115/-3/srv/2.0"/>
    <sch:ns prefix="cit" uri="http://standards.iso.org/iso/19115/-3/cit/1.0"/>
    <sch:ns prefix="gex" uri="http://standards.iso.org/iso/19115/-3/gex/1.0"/>
    <sch:ns prefix="mco" uri="http://standards.iso.org/iso/19115/-3/mco/1.0"/>
    <sch:ns prefix="mdb" uri="http://standards.iso.org/iso/19115/-3/mdb/1.0"/>
    <sch:ns prefix="mex" uri="http://standards.iso.org/iso/19115/-3/mex/1.0"/>
    <sch:ns prefix="mmi" uri="http://standards.iso.org/iso/19115/-3/mmi/1.0"/>
    <sch:ns prefix="mrc" uri="http://standards.iso.org/iso/19115/-3/mrc/1.0"/>
    <sch:ns prefix="mrd" uri="http://standards.iso.org/iso/19115/-3/mrd/1.0"/>
    <sch:ns prefix="mri" uri="http://standards.iso.org/iso/19115/-3/mri/1.0"/>
    <sch:ns prefix="mrl" uri="http://standards.iso.org/iso/19115/-3/mrl/1.0"/>
    <sch:ns prefix="mrs" uri="http://standards.iso.org/iso/19115/-3/mrs/1.0"/>
    <sch:ns prefix="mcc" uri="http://standards.iso.org/iso/19115/-3/mcc/1.0"/>
    <sch:ns prefix="lan" uri="http://standards.iso.org/iso/19115/-3/lan/1.0"/>
    <sch:ns prefix="gco" uri="http://standards.iso.org/iso/19115/-3/gco/1.0"/>
    <sch:ns prefix="mdq" uri="http://standards.iso.org/iso/19157/-2/mdq/1.0"/>
    <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
    <sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema"/>


    <!-- ======================================================================================================================= -->
    <!-- Assert that metadataIdentifier is present                                                                               -->
    <!-- See section 2.7.1 'Metadata Extension for "metadataIdentifier"' of the Geoscience Australia Profile of ISO 19115-1:2014 -->
    <!-- ======================================================================================================================= -->
    <sch:pattern id="rule.ga.mdb.metadataidentifierpresent">
    	<sch:title>Metadata record must have an identifier.</sch:title>
      
    	<sch:rule context="/mdb:MD_Metadata">

    		<sch:let name="mdid" value="mdb:metadataIdentifier/mcc:MD_Identifier/mcc:code/gco:CharacterString"/>
            <sch:let name="hasMdid" value="normalize-space($mdid) != ''"/>

    		<sch:assert test="$hasMdid">The metadata record does not have an identifier.</sch:assert>
    	    <sch:report test="$hasMdid">The metadata record has identifier '<sch:value-of select="normalize-space($mdid)"/>'.</sch:report>

        </sch:rule>
    </sch:pattern>
	
    <!-- =================================================================================================================== -->
    <!-- Assert that parentMetadata element is conditionally present if MD_MetadataScope/resourceScope is one of             -->
    <!-- "feature", "featureType", "attribute" or "attributeType"                                                            -->
    <!-- See section 2.7.2 'Metadata Extension for "parentMetadata"' of the Geoscience Australia Profile of ISO 19115-1:2014 -->
    <!-- =================================================================================================================== -->
    <sch:pattern id="rule.ga.mdb.metadataparentpresent">
        <sch:title>Metadata record must have a metadata parent if resource scope is one of 'feature', 'featureType', 'attribute' or 'attributeType'.</sch:title>

        <sch:rule context="/mdb:MD_Metadata[mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode[@codeListValue='feature' or @codeListValue='featureType' or @codeListValue='attribute' or @codeListValue='attributeType']]">
            <sch:let name="scopeCode" value="mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue"/>

            <sch:assert test="count(mdb:parentMetadata/cit:CI_Citation/*)>0">The metadata record does not have metadata parent information, required when resource scope is '<sch:value-of select="normalize-space($scopeCode)"/>'.</sch:assert>
            <sch:report test="count(mdb:parentMetadata/cit:CI_Citation/*)>0">The metadata record has metadata parent information.</sch:report>
        </sch:rule>
    </sch:pattern>

    <!-- ============================================================================================================================= -->
    <!-- Assert that Parent Metadata has the required descendent identifier element.                                                   -->
    <!-- See section 2.7.3 'Metadata extension for "identifier" (parent)' of the Geoscience Australia Profile of ISO 19115-1:2014      -->
    <!-- ============================================================================================================================= -->
    <sch:pattern id="rule.ga.mdb.metadataparentidentifierpresent">
        <sch:title>Metadata parent must have an identifier.</sch:title>
        
        <sch:rule context="/mdb:MD_Metadata/mdb:parentMetadata">
            
            <sch:let name="parentId" value="cit:CI_Citation/cit:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString"/>
            <sch:let name="hasParentid" value="normalize-space($parentId) != ''"/>
            
            <sch:assert test="$hasParentid">Metadata parent identifier is not present.</sch:assert>
            <sch:report test="$hasParentid">Metadata parent identifier is present - "<sch:value-of select="normalize-space($parentId)"/>".</sch:report>
            
        </sch:rule>
    </sch:pattern>

    <!-- =============================================================================================================================== -->
    <!-- Assert that Resource Identification has the required descendant identifier element.                                             -->
    <!-- See section 2.7.4 'Metadata extension for "identifier" (resource)' of the Geoscience Australia Profile of ISO 19115-1:2014      -->
    <!-- =============================================================================================================================== -->
    <sch:pattern id="rule.ga.mdb.resourceidentifierpresent">
        <sch:title>Resource identification information must have an identifier.</sch:title>
        
        <sch:rule context="//*[name()='mri:MD_DataIdentification' or name()='srv:SV_ServiceIdentification']">
            <sch:let name="resourceIdentifiers" value="//mri:citation/cit:CI_Citation/cit:identifier/mcc:MD_Identifier/mcc:code[normalize-space(gco:CharacterString) != '']"/>
            <sch:let name="hasResourceid" value="count($resourceIdentifiers) > 0"/>
        	
            <sch:assert test="$hasResourceid">Resource identification information does not have an identifier.</sch:assert>
            <sch:report test="$hasResourceid">Resource identification information has identifier "<sch:value-of select="normalize-space($resourceIdentifiers)"/>".</sch:report>
        </sch:rule>
    </sch:pattern>

    <!-- =============================================================================================================================== -->
    <!-- Assert that Constraints (MD_Constraints element, and its MD_SecurityConstraint and MD_LegalConstraint specialisations), for     -->
    <!-- both the Resource Identification and Metadata, have the required descendent reference element.                                  -->
    <!-- See section 2.7.5 'Metadata extension for "reference"' of the Geoscience Australia Profile of ISO 19115-1:2014                  -->
    <!-- =============================================================================================================================== -->
    <sch:pattern id="rule.ga.mdb.constraintreferencepresent">
        <sch:title>Reference information is mandatory for constraints, including security constraints and legal constraints.</sch:title>
        
        <sch:rule context="//*[name()='mco:MD_SecurityConstraints' or name()='mco:MD_LegalConstraints' or name()='mco:MD_Constraints']">
            <sch:let name="parentClass" value="name(.)"/>
 
            <sch:assert test="count(mco:reference/cit:CI_Citation/*)>0">The constraint "<sch:value-of select="normalize-space($parentClass)"/>" does not have reference information.</sch:assert>
            <sch:report test="count(mco:reference/cit:CI_Citation/*)>0">The constraint "<sch:value-of select="normalize-space($parentClass)"/>" contains reference information.</sch:report>
        </sch:rule>
    </sch:pattern>

    <!-- =============================================================================================================================== -->
    <!-- Assert that Metadata has the required descendant MD_SecurityConstraints element.                                                -->
    <!-- See section 2.7.6 'Metadata extension for "metadataConstraints"' of the Geoscience Australia Profile of ISO 19115-1:2014        -->
    <!-- =============================================================================================================================== -->
    <sch:pattern id="rule.ga.mdb.metadatasecurityconstraintpresent">
        <sch:title>Metadata record must have a security constraint.</sch:title>
        
        <sch:rule context="/mdb:MD_Metadata">
            <sch:assert test="count(mdb:metadataConstraints/mco:MD_SecurityConstraints)>0">The metadata record does not have a security constraint.</sch:assert>
            <sch:report test="count(mdb:metadataConstraints/mco:MD_SecurityConstraints)>0">The metadata record has a security constraint.</sch:report>
        </sch:rule>
    </sch:pattern>

    <!-- ========================================================================================================================== -->
    <!-- Assert that Resource Identification has the required descendant pointOfContact element.                                    -->
    <!-- See section 2.7.7 'Metadata extension for "pointOfContact"' of the Geoscience Australia Profile of ISO 19115-1:2014        -->
    <!-- ========================================================================================================================== -->
    <sch:pattern id="rule.ga.mri.pointofcontact">
        <sch:title>Resource identification information must have a point of contact.</sch:title>
        
        <sch:rule context="//*[name()='mri:MD_DataIdentification' or name()='srv:SV_ServiceIdentification']">
            
            <sch:assert test="count(mri:pointOfContact/cit:CI_Responsibility/*)>0">Resource identification information does not have a point of contact.</sch:assert>
            <sch:report test="count(mri:pointOfContact/cit:CI_Responsibility/*)>0">Resource identification information has a point of contact.</sch:report>
        </sch:rule>
    </sch:pattern>		

    <!-- =========================================================================================================================== -->
    <!-- Assert that Resource Identification has the required descendant resourceMaintenance element.                                -->
    <!-- See section 2.7.8 'Metadata extension for "resourceMaintenance"' of the Geoscience Australia Profile of ISO 19115-1:2014    -->
    <!-- =========================================================================================================================== -->
    <sch:pattern id="rule.ga.mmi.maintenanceinformation">
        <sch:title>Resource identification information must have maintenance information.</sch:title>
        
        <sch:rule context="//*[name()='mri:MD_DataIdentification' or name()='srv:SV_ServiceIdentification']">
            
            <sch:assert test="count(mri:resourceMaintenance/mmi:MD_MaintenanceInformation)>0">Resource identification information does not have maintenance information.</sch:assert>
            <sch:report test="count(mri:resourceMaintenance/mmi:MD_MaintenanceInformation)>0">Resource identification information has maintenance information.</sch:report>
        </sch:rule>
    </sch:pattern>

    <!-- ===================================================================================================================================== -->
    <!-- Assert that Resource Identification Maintenance Information has the required maintenanceAndUpdateFrequency element.                   -->
    <!-- See section 2.7.9 'Metadata extension for "maintenanceAndUpdateFrequency"' of the Geoscience Australia Profile of ISO 19115-1:2014    -->
    <!-- ===================================================================================================================================== -->
    <sch:pattern id="rule.ga.mmi.maintenanceupdatefrequency">
        <sch:title>Maintenance information in the resource identification must have a maintenance and update frequency.</sch:title>
        
        <sch:rule context="//*[name()='mri:MD_DataIdentification' or name()='srv:SV_ServiceIdentification']/mri:resourceMaintenance/mmi:MD_MaintenanceInformation">
            
            <sch:assert test="normalize-space(mmi:maintenanceAndUpdateFrequency/mmi:MD_MaintenanceFrequencyCode/@codeList) and normalize-space(mmi:maintenanceAndUpdateFrequency/mmi:MD_MaintenanceFrequencyCode/@codeListValue)">Maintenance information in the resource identification does not have a maintenance and update frequency.</sch:assert>
            <sch:report test="normalize-space(mmi:maintenanceAndUpdateFrequency/mmi:MD_MaintenanceFrequencyCode/@codeList) and normalize-space(mmi:maintenanceAndUpdateFrequency/mmi:MD_MaintenanceFrequencyCode/@codeListValue)">Maintenance information in the resource identification has a maintenance and update frequency.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <!-- =============================================================================================================================== -->
    <!-- Assert that Resource Identification has the required descendant MD_LegalConstraints and MD_SecurityConstraints elements.        -->
    <!-- See section 2.7.10 'Metadata extension for "metadataConstraints"' of the Geoscience Australia Profile of ISO 19115-1:2014       -->
    <!-- =============================================================================================================================== -->
    <sch:pattern id="rule.ga.mri.resourcesecurityconstraintpresent">
        <sch:title>Resource identification information must have a security constraint.</sch:title>
        
        <sch:rule context="//*[name()='mri:MD_DataIdentification' or name()='srv:SV_ServiceIdentification']">
            
            <sch:assert test="count(mri:resourceConstraints/mco:MD_SecurityConstraints)>0">Resource identification information does not have a security constraint.</sch:assert>
            <sch:report test="count(mri:resourceConstraints/mco:MD_SecurityConstraints)>0">Resource identification information has a security constraint.</sch:report>
        </sch:rule>
    </sch:pattern>
    <sch:pattern id="rule.ga.mri.resourcelegalconstraintpresent">
        <sch:title>Resource identification information must have a legal constraint.</sch:title>
        
        <sch:rule context="//*[name()='mri:MD_DataIdentification' or name()='srv:SV_ServiceIdentification']">
            <sch:let name="parentClass" value="name(.)"/>
            
            <sch:assert test="count(mri:resourceConstraints/mco:MD_LegalConstraints)>0">Resource identification information does not have a legal constraint.</sch:assert>
            <sch:report test="count(mri:resourceConstraints/mco:MD_LegalConstraints)>0">Resource identification information has a legal constraint.</sch:report>
        </sch:rule>
    </sch:pattern>

    <!-- ================================================================================================================================== -->
    <!-- Assert that Resource Identification Legal Constraints has the required descendant accessConstraints element.                       -->
    <!-- See section 2.7.11 'Metadata extension for "accessConstraints"' of the Geoscience Australia Profile of ISO 19115-1:2014            -->
    <!-- ================================================================================================================================== -->
    <sch:pattern id="rule.ga.mco.resourcelegalaccesconstraintpresent">
        <sch:title>Legal constraint in the resource identification information must have an access constraint.</sch:title>
        
        <sch:rule context="//mri:resourceConstraints/mco:MD_LegalConstraints">
                
            <sch:assert test="normalize-space(mco:accessConstraints/mco:MD_RestrictionCode/@codeList) and normalize-space(mco:accessConstraints/mco:MD_RestrictionCode/@codeListValue)">The legal constraint in resource identification information does not have an access constraint.</sch:assert>
            <sch:report test="normalize-space(mco:accessConstraints/mco:MD_RestrictionCode/@codeList) and normalize-space(mco:accessConstraints/mco:MD_RestrictionCode/@codeListValue)">The legal constraint in resource identification information has an access constraint.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <!-- ================================================================================================================================== -->
    <!-- Assert that Resource Identification Legal Constraints has the required descendant useConstraints element.                          -->
    <!-- See section 2.7.12 'Metadata extension for "useConstraints"' of the Geoscience Australia Profile of ISO 19115-1:2014               -->
    <!-- ================================================================================================================================== -->
    <sch:pattern id="rule.ga.mco.resourcelegaluseconstraintpresent">
        <sch:title>Legal constraint in the resource identification information must have a use constraint.</sch:title>
        
        <sch:rule context="//mri:resourceConstraints/mco:MD_LegalConstraints">
            <sch:assert test="normalize-space(mco:useConstraints/mco:MD_RestrictionCode/@codeList) and normalize-space(mco:useConstraints/mco:MD_RestrictionCode/@codeListValue)">The legal constraint in resource identification information does not have a use constraint.</sch:assert>
            <sch:report test="normalize-space(mco:useConstraints/mco:MD_RestrictionCode/@codeList) and normalize-space(mco:useConstraints/mco:MD_RestrictionCode/@codeListValue)">The legal constraint in resource identification information has a use constraint.</sch:report>
        </sch:rule>
    </sch:pattern>

    <!-- ===================================================================================================================== -->
    <!-- Assert that Resource Identification has the required descendant topicCategory element.                                -->
    <!-- See section 2.7.13 'Metadata extension for "topicCategory"' of the Geoscience Australia Profile of ISO 19115-1:2014   -->
    <!-- ===================================================================================================================== -->
    <sch:pattern id="rule.ga.mri.topiccategorypresent">
        <sch:title>Resource identification information must have a topic category.</sch:title>
        
        <sch:rule context="//*[name()='mri:MD_DataIdentification' or name()='srv:SV_ServiceIdentification']">
            <sch:assert test="normalize-space(mri:topicCategory/mri:MD_TopicCategoryCode) != ''">Resource identification information does not have a topic category or it is empty.</sch:assert>
            <sch:report test="normalize-space(mri:topicCategory/mri:MD_TopicCategoryCode) != ''">Resource identification information has a topic category.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <!-- ======================================================================================================================== -->
    <!-- Assert that Resource Identification has at least one of "geographicExtent", "temporalExtent" or "verticalExtent"         -->
    <!-- extent types if resource scope is 'dataset'.                                                                             -->
    <!-- See section 2.7.14 'Metadata extension for "extent"' of the Geoscience Australia Profile of ISO 19115-1:2014             -->
    <!-- ======================================================================================================================== -->
    <sch:pattern id="rule.ga.gex.extentpresent">
        <sch:title>Resource identification information must have at least one of 'geographicExtent', 'temporalExtent' or 'verticalExtent' extent types if metadataScope is 'dataset'.</sch:title>
        
        <sch:rule context="//mdb:MD_Metadata[mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode[@codeListValue='dataset' or @codeListValue='']]/mdb:identificationInfo/*">
            
            <sch:let name="extentCount" value="count(//mri:extent/gex:EX_Extent/gex:geographicElement/*) + count(//mri:extent/gex:EX_Extent/gex:temporalElement/*) + count(//mri:extent/gex:EX_Extent/gex:verticalElement/*)"/>
            
            <sch:assert test="$extentCount>0">Resource identification information does not have extent information, required when metadataScope is 'dataset'.</sch:assert>
            <sch:report test="$extentCount>0">Resource identification information has extent information.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <!-- ========================================================================================================================= -->
    <!-- Assert that Resource Identification has Reference System Information if resource scope is 'dataset'.                      -->
    <!-- See section 2.7.15 'Metadata extension for "referenceSystemInfo"' of the Geoscience Australia Profile of ISO 19115-1:2014 -->
    <!-- ========================================================================================================================= -->
    <sch:pattern id="rule.ga.mdb.referencesysteminfopresent">
        <sch:title>Metadata record must have reference system information if resourceScope is 'dataset'.</sch:title>
        
        <sch:rule context="/mdb:MD_Metadata[mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode[@codeListValue='dataset']]">
            <sch:let name="scopeCode" value="mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue"/>
            <sch:let name="hasReferenceSystemInfo" value="count(mdb:referenceSystemInfo)>0 and $scopeCode ='dataset'"/>
            
            <sch:assert test="$hasReferenceSystemInfo">The metadata record does not have reference system information, required when resourceScope is 'dataset'.</sch:assert>
            <sch:report test="$hasReferenceSystemInfo">The metadata record has reference system information.</sch:report>
        </sch:rule>
    </sch:pattern>

    <!-- ========================================================================================================================= -->
    <!-- Assert that Resource Identification has at least one descriptive keyword.                                                 -->
    <!-- See section 2.7.16 'Metadata extension for "descriptiveKeywords"' of the Geoscience Australia Profile of ISO 19115-1:2014 -->
    <!-- ========================================================================================================================= -->
    <sch:pattern id="rule.ga.mri.descriptivekeywordpresent">
        <sch:title>Resource identification information must have at least one descriptive keyword.</sch:title>
        
        <sch:rule context="//*[name()='mri:MD_DataIdentification' or name()='srv:SV_ServiceIdentification']">
            
            <sch:assert test="normalize-space(mri:descriptiveKeywords/mri:MD_Keywords/mri:keyword/gco:CharacterString) != ''">Resource identification information does not have any descriptive keywords or keyword text is missing.</sch:assert>
            <sch:report test="normalize-space(mri:descriptiveKeywords/mri:MD_Keywords/mri:keyword/gco:CharacterString) != ''">Resource identification information has one or more descriptive keywords.</sch:report>
        </sch:rule>
    </sch:pattern>

    <!-- ========================================================================================================================= -->
    <!-- Assert that Resource Lineage information is present.                                                                      -->
    <!-- See section 2.7.17 'Metadata extension for "resourceLineage"' of the Geoscience Australia Profile of ISO 19115-1:2014     -->
    <!-- ========================================================================================================================= -->
    <sch:pattern id="rule.ga.mrl.resourcelineagepresent">
        <sch:title>Metadata record must have resource lineage information.</sch:title>
        
        <sch:rule context="/mdb:MD_Metadata">
            <sch:assert test="count(mdb:resourceLineage/mrl:LI_Lineage/*)>0">The metadata record does not have resource lineage information.</sch:assert>
            <sch:report test="count(mdb:resourceLineage/mrl:LI_Lineage/*)>0">The metadata record has resource lineage information.</sch:report>
        </sch:rule>
    </sch:pattern>

    <!-- =================================================================================================================== -->
    <!-- Assert that Resource Lineage has the required descendant statement element.                                         -->
    <!-- See section 2.7.18 'Metadata extension for "statement"' of the Geoscience Australia Profile of ISO 19115-1:2014     -->
    <!-- =================================================================================================================== -->
    <sch:pattern id="rule.ga.mrl.resourcelineagestatementpresent">
        <sch:title>Resource lineage information must include a statement.</sch:title>
        
        <sch:rule context="//mdb:resourceLineage/mrl:LI_Lineage">
            <sch:assert test="normalize-space(mrl:statement)">The resource lineage information does not have a statement or contains no text.</sch:assert>
            <sch:report test="normalize-space(mrl:statement)">The resource lineage information has a statement.</sch:report>
        </sch:rule>
    </sch:pattern>

    <!-- ===================================================================================================================== -->
    <!-- Assert that at least one of Resource Format or Distribution Format is present.                                        -->
    <!-- See following sections of the Geoscience Australia Profile of ISO 19115-1:2014:                                       -->
    <!--        2.7.19 'Metadata extension for "resourceFormat"'                                                               -->
    <!--        2.7.20 'Metadata extension for "distributionFormat"'                                                           -->
    <!-- ===================================================================================================================== -->
    <sch:pattern id="rule.ga.mri.resourceanddistributionformat">
        <sch:title>At least one of resource format in resource identification information, or distribution format in distribution information must exist.</sch:title>
        
        <sch:rule context="/mdb:MD_Metadata">
            <sch:assert test="count(//mri:resourceFormat)>0 or count(//mrd:distributionFormat)>0">Resource format and distribution format are not present, at least one is required.</sch:assert>
            <sch:report test="count(//mri:resourceFormat)>0 or count(//mrd:distributionFormat)>0">One of, or both resource format and distribution format are present.</sch:report>
        </sch:rule>
    </sch:pattern>

    <!-- ===================================================================================================================== -->
    <!-- Assert that the GA Profile protocolTypeCode codelist is applied to the protocol term.                                 -->
    <!-- the element to a codelist.                                                                                            -->
    <!-- See section B.3.9 'ProtocolType <<CodeList>>'                                                                         -->
    <!-- ===================================================================================================================== -->
    <sch:pattern id="rule.ga.cit.protocolextendedforcodelist">
        <sch:title>The online resource protocol element's character string element must indicate that the GA Profile protocolTypeCode codelist applies to the protocol term.</sch:title>
        
        <sch:rule context="//cit:CI_OnlineResource/cit:protocol/gco:CharacterString">
            
            <sch:let name="hasTypeExtension" value="count (@*[local-name()='type' and namespace-uri()='http://www.w3.org/2001/XMLSchema-instance' and .='gco:CodeType']) and
                                                    count (@*['codeSpace' and .='http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/ga_profile_codelists.xml#gapCI_ProtocolTypeCode'])"/>

            <sch:assert test="$hasTypeExtension">The online resource protocol element's character string element does not indicate that the GA Profile protocolTypeCode codelist applies to the protocol term.</sch:assert>
            <sch:report test="$hasTypeExtension">The online resource protocol element's character string element indicates that the GA Profile protocolTypeCode codelist applies to the protocol term.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <!-- ================================================================================================================================== -->
    <!-- Assert that the GA Profile serviceTypeCode codelist is applied to the service type term.                                           -->
    <!-- See section B.3.11 'ServiceType <<CodeList>>'                                                                                      -->
    <!-- ================================================================================================================================== -->
    <sch:pattern id="rule.ga.srv.servicetypeextendedforcodelist">
        <sch:title>The service type element's scoped name element must indicate that the GA Profile serviceTypeCode codelist applies to the service type term.</sch:title>
        
        <sch:rule context="/mdb:MD_Metadata/mdb:identificationInfo/srv:SV_ServiceIdentification/srv:serviceType/gco:ScopedName">

            <sch:let name="hasTypeExtension" value="count (@*['codeSpace' and .='http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/ga_profile_codelists.xml#gapSV_ServiceTypeCode'])"/>
            
            <sch:assert test="$hasTypeExtension">The service type element's scoped name element does not indicate that the GA Profile serviceTypeCode codelist applies to the service type term.</sch:assert>
            <sch:report test="$hasTypeExtension">The service type element's scoped name element indicates that the GA Profile serviceTypeCode codelist applies to the service type term.</sch:report>
        </sch:rule>
    </sch:pattern>
    
</sch:schema>
