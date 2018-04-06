<?xml version="1.0" encoding="UTF-8"?><sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">

<!-- ================================================================================================================
This Schematron provides validation of constraints imposed by the Geoscience Australia Profile of ISO 19115-1:2014.
    
This script was developed by Geoscience Australia in March 2018.
=====================================================================================================================
History:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DATE			VERSION		AUTHOR				DESCRIPTION
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2018-03-30		0.1			Aaron Sedgmen		Initial Version.
=====================================================================================================================
-->
	
	
	<sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="en">Schematron validation of Geoscience Australia profile of ISO 19115-1:2014 standard</sch:title>

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
    <sch:ns prefix="geonet" uri="http://www.fao.org/geonetwork"/>
    <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
    <sch:ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema"/>


	<!-- ============================================================================================================ -->
    <!-- Assert that metadataIdentifier (at least one) is present -->
    <!-- ============================================================================================================ -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.ga.mdb.metadataidentifierpresent-failure-en" xml:lang="en">The metadata identifier is not present.</sch:diagnostic>
        <sch:diagnostic id="rule.ga.mdb.metadataidentifierpresent-success-en" xml:lang="en">The metadata identifier is present - "<sch:value-of select="normalize-space($mdid)"/>".</sch:diagnostic>
    </sch:diagnostics>

    <sch:pattern id="rule.ga.mdb.metadataidentifierpresent">
        <sch:title xml:lang="en">Metadata identifier is mandatory.</sch:title>
      
    	<sch:rule context="/mdb:MD_Metadata">

    		<sch:let name="mdid" value="mdb:metadataIdentifier/mcc:MD_Identifier/mcc:code/gco:CharacterString"/>
            <sch:let name="hasMdid" value="normalize-space($mdid) != ''"/>

    		<sch:assert test="$hasMdid" diagnostics="rule.ga.mdb.metadataidentifierpresent-failure-en">Fail mdb:metadataIdentifier.</sch:assert>
    		<sch:report test="$hasMdid" diagnostics="rule.ga.mdb.metadataidentifierpresent-success-en">Pass mdb:metadataIdentifier.</sch:report>

        </sch:rule>
    </sch:pattern>

	
	<!-- ============================================================================================================ -->
	<!-- Assert that parentMetadata is conditionally present if MD_MetadataScope.resourceScope is one of              -->
	<!-- “feature”, “featureType”, “attribute” or “attributeType”                                                        -->
	<!-- ============================================================================================================ -->
	<sch:diagnostics>
		<sch:diagnostic id="rule.ga.mdb.metadataparentpresent-failure-en" xml:lang="en">Metadata parent information must be present.</sch:diagnostic>
		<sch:diagnostic id="rule.ga.mdb.metadataparentpresent-success-en" xml:lang="en">Metadata parent information is present.</sch:diagnostic>
	</sch:diagnostics>
	
	<sch:pattern id="rule.ga.mdb.metadataparentpresent">
		<sch:title xml:lang="en">Metadata parent information is mandatory if resource scope is one of 'feature', 'featureType', 'attribute' or 'attributeType'.</sch:title>
		
		<sch:rule context="/mdb:MD_Metadata[mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode[@codeListValue='feature' or @codeListValue='featureType' or @codeListValue='attribute' or @codeListValue='attributeType']]">
			
			<sch:assert test="count(mdb:parentMetadata/cit:CI_Citation/*)>0" diagnostics="rule.ga.mdb.metadataparentpresent-failure-en">Fail mdb:parentMetadata.</sch:assert>
			<sch:report test="count(mdb:parentMetadata/cit:CI_Citation/*)>0" diagnostics="rule.ga.mdb.metadataparentpresent-success-en">Pass mdb:parentMetadata.</sch:report>
		</sch:rule>
	</sch:pattern>

	
	<!-- ============================================================================================================ -->
	<!-- Assert that identifier is present for all parentMetadata elements                                                -->
	<!-- ============================================================================================================ -->
	<sch:diagnostics>
		<sch:diagnostic id="rule.ga.mdb.metadataparentidentifierpresent-failure-en" xml:lang="en">The metadata parent identifier must be present.</sch:diagnostic>
		<sch:diagnostic id="rule.ga.mdb.metadataparentidentifierpresent-success-en" xml:lang="en">The metadata parent identifier is present - "<sch:value-of select="normalize-space($parentId)"/>".</sch:diagnostic>
	</sch:diagnostics>
	
	<sch:pattern id="rule.ga.mdb.metadataparentidentifierpresent">
		<sch:title xml:lang="en">Metadata parent identifier is mandatory.</sch:title>
		
		<sch:rule context="/mdb:MD_Metadata/mdb:parentMetadata">
			
			<sch:let name="parentId" value="cit:CI_Citation/cit:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString"/>
			<sch:let name="hasParentid" value="normalize-space($parentId) != ''"/>
			
			<sch:assert test="$hasParentid" diagnostics="rule.ga.mdb.metadataparentidentifierpresent-failure-en">Fail mdb:parentMetadata/cit:CI_Citation/cit:identifier.</sch:assert>
			<sch:report test="$hasParentid" diagnostics="rule.ga.mdb.metadataparentidentifierpresent-success-en">Pass mdb:parentMetadata/cit:CI_Citation/cit:identifier.</sch:report>
			
		</sch:rule>
	</sch:pattern>
	
	
    <!-- ============================================================================================================ -->
    <!-- Assert that at least one resource identifier is present -->
    <!-- ============================================================================================================ -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.ga.mdb.resourceidentifierpresent-failure-en" xml:lang="en">One or more resource identifiers must be present.</sch:diagnostic>
    	<sch:diagnostic id="rule.ga.mdb.resourceidentifierpresent-success-en" xml:lang="en">One or more resource identifiers are present - "<sch:value-of select="$resourceIdentifiers"/>".</sch:diagnostic>
    </sch:diagnostics>

    <sch:pattern id="rule.ga.mdb.resourceidentifierpresent">
        <sch:title xml:lang="en">Resource identifier is mandatory.</sch:title>

        <sch:rule context="//mdb:identificationInfo">
        	
        	<sch:let name="resourceIdentifiers" value="//mri:citation/cit:CI_Citation/cit:identifier/mcc:MD_Identifier/mcc:code[normalize-space(gco:CharacterString) != '']"/>
        	<sch:let name="hasResourceid" value="count($resourceIdentifiers) > 0"/>

        	<sch:assert test="$hasResourceid" diagnostics="rule.ga.mdb.resourceidentifierpresent-failure-en">Fail mdb:identificationInfo/mri:citation/cit:CI_Citation/cit:identifier.</sch:assert>
        	<sch:report test="$hasResourceid" diagnostics="rule.ga.mdb.resourceidentifierpresent-success-en">Pass mdb:identificationInfo/mri:citation/cit:CI_Citation/cit:identifier.</sch:report>
        </sch:rule>
    </sch:pattern>
	
	
	<!-- ============================================================================================================ -->
	<!-- Assert that the Reference System Information is conditionally present -->
	<!-- ============================================================================================================ -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.ga.mdb.referencesysteminfopresent-failure-en" xml:lang="en">Reference system information is not present for record with metadataScope of 'dataset'.</sch:diagnostic>
    	<sch:diagnostic id="rule.ga.mdb.referencesysteminfopresent-success-en" xml:lang="en">Reference system information is present for record with metadataScope of 'dataset'.</sch:diagnostic>
    </sch:diagnostics>
	
    <sch:pattern id="rule.ga.mdb.referencesysteminfopresent">
        <sch:title xml:lang="en">Reference system information must be present and correctly filled out if metadataScope is 'dataset'.</sch:title>

    	<sch:rule context="/mdb:MD_Metadata[mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode[@codeListValue='dataset']]">
    		<sch:assert test="count(mdb:referenceSystemInfo/mrs:MD_ReferenceSystem/*)>0" diagnostics="rule.ga.mdb.referencesysteminfopresent-failure-en">Fail mdb:referenceSystemInfo.</sch:assert>
    		<sch:report test="count(mdb:referenceSystemInfo/mrs:MD_ReferenceSystem/*)>0" diagnostics="rule.ga.mdb.referencesysteminfopresent-success-en">Pass mdb:referenceSystemInfo.</sch:report>
        </sch:rule>
    </sch:pattern>
	
		
	<!-- ======================================================================================================================================= -->
	<!-- Assert that reference property is present in MD_LegalConstraints and MD_SecurityConstraints -->
	<!-- ======================================================================================================================================= -->
	<sch:diagnostics>
		<sch:diagnostic id="rule.ga.mco.referencepresent-failure-en" xml:lang="en">The reference property must be present in "<sch:value-of select="normalize-space($parentClass)"/>".</sch:diagnostic>
		<sch:diagnostic id="rule.ga.mco.referencepresent-success-en" xml:lang="en">The reference property is present in "<sch:value-of select="normalize-space($parentClass)"/>".</sch:diagnostic>
	</sch:diagnostics>
	
	<sch:pattern id="rule.ga.mco.referencepresent">
		<sch:title xml:lang="en">The reference property is mandatory in constraint information.</sch:title>
		
		<sch:rule context="//*[name()='mco:MD_SecurityConstraints' or name()='mco:MD_LegalConstraints']">
			<sch:let name="parentClass" value="name(.)"/>
			
			<sch:assert test="count(mco:reference/cit:CI_Citation/*)>0" diagnostics="rule.ga.mco.referencepresent-failure-en">Fail <sch:value-of select="normalize-space($parentClass)"/>/mco:reference/cit:CI_Citation.</sch:assert>
			<sch:report test="count(mco:reference/cit:CI_Citation/*)>0" diagnostics="rule.ga.mco.referencepresent-success-en">Pass <sch:value-of select="normalize-space($parentClass)"/>/mco:reference/cit:CI_Citation.</sch:report>
		</sch:rule>
	</sch:pattern>


    <!-- ================================================================================================================================== -->
    <!-- Assert that the required constraint information is present:                                                                        -->
	<!--    - /mdb:MD_Metadata/mdb:metadataConstraints/mco:MD_SecurityConstraints is mandatory                                              -->
	<!--    - /mdb:MD_Metadata/mdb:identificationInfo/*/mri:resourceConstraints/mco:MD_SecurityConstraints is mandatory                     -->
    <!--    - /mdb:MD_Metadata/mdb:identificationInfo/*/mri:resourceConstraints/mco:MD_LegalConstraints is mandatory                        -->
	<!--    - /mdb:MD_Metadata/mdb:identificationInfo/*/mri:resourceConstraints/mco:MD_LegalConstraints/mco:accessConstraints is mandatory  -->
	<!--    - /mdb:MD_Metadata/mdb:identificationInfo/*/mri:resourceConstraints/mco:MD_LegalConstraints/mco:useConstraints is mandatory     -->
	<!--    - reference property is mandatory in the MD_Constraints class and the MD_LegalConstraints and MD_SecurityConstraints subclasses -->
    <!-- ================================================================================================================================== -->
	<sch:diagnostics>
		<sch:diagnostic id="rule.ga.mco.metadatasecurityconstraintspresent-failure-en" xml:lang="en">Metadata security constraint information is not present.</sch:diagnostic>
		<sch:diagnostic id="rule.ga.mco.metadatasecurityconstraintspresent-success-en" xml:lang="en">Metadata security constraint information is present.</sch:diagnostic>

		<sch:diagnostic id="rule.ga.mco.resourcesecurityconstraintspresent-failure-en" xml:lang="en">Resource security constraint information is not present.</sch:diagnostic>
		<sch:diagnostic id="rule.ga.mco.resourcesecurityconstraintspresent-success-en" xml:lang="en">Resource security constraint information is present.</sch:diagnostic>
		
		<sch:diagnostic id="rule.ga.mco.resourcelegalconstraintspresent-failure-en" xml:lang="en">Resource legal constraint information is not present.</sch:diagnostic>
		<sch:diagnostic id="rule.ga.mco.resourcelegalconstraintspresent-success-en" xml:lang="en">Resource legal constraint information is present.</sch:diagnostic>

		<sch:diagnostic id="rule.ga.mco.accessconstraintspresent-failure-en" xml:lang="en">Access constraint in resource legal constraint is not present or missing code list values.</sch:diagnostic>
		<sch:diagnostic id="rule.ga.mco.accessconstraintspresent-success-en" xml:lang="en">Access constraint in resource legal constraint is present.</sch:diagnostic>
		
		<sch:diagnostic id="rule.ga.mco.useconstraintspresent-failure-en" xml:lang="en">Use constraint in resource legal constraint is not present or missing code list values.</sch:diagnostic>
		<sch:diagnostic id="rule.ga.mco.useconstraintspresent-success-en" xml:lang="en">Use constraint in resource legal constraint is present.</sch:diagnostic>
	</sch:diagnostics>
	<sch:pattern id="rule.ga.mco.constraints">
		<sch:title>Constraint information must be present and correctly filled out.</sch:title>

		<sch:rule context="/mdb:MD_Metadata">
			<sch:assert test="count(mdb:metadataConstraints/mco:MD_SecurityConstraints/*)>0" diagnostics="rule.ga.mco.metadatasecurityconstraintspresent-failure-en">Fail mdb:metadataConstraints/mco:MD_SecurityConstraints.</sch:assert>
			<sch:report test="count(mdb:metadataConstraints/mco:MD_SecurityConstraints/*)>0" diagnostics="rule.ga.mco.metadatasecurityconstraintspresent-success-en">Pass mdb:metadataConstraints/mco:MD_SecurityConstraints.</sch:report>
			
			<sch:assert test="count(//mri:resourceConstraints/mco:MD_SecurityConstraints/*)>0" diagnostics="rule.ga.mco.resourcesecurityconstraintspresent-failure-en">Fail mri:resourceConstraints/mco:MD_SecurityConstraints.</sch:assert>
			<sch:report test="count(//mri:resourceConstraints/mco:MD_SecurityConstraints/*)>0" diagnostics="rule.ga.mco.resourcesecurityconstraintspresent-success-en">Pass mri:resourceConstraints/mco:MD_SecurityConstraints.</sch:report>

			<sch:assert test="count(//mri:resourceConstraints/mco:MD_LegalConstraints/*)>0" diagnostics="rule.ga.mco.resourcesecurityconstraintspresent-failure-en">Fail mri:resourceConstraints/mco:MD_LegalConstraints.</sch:assert>
			<sch:report test="count(//mri:resourceConstraints/mco:MD_LegalConstraints/*)>0" diagnostics="rule.ga.mco.resourcesecurityconstraintspresent-success-en">Pass mri:resourceConstraints/mco:MD_LegalConstraints.</sch:report>
		</sch:rule>
		
		<sch:rule context="//mri:resourceConstraints/mco:MD_LegalConstraints">
            <sch:assert test="normalize-space(mco:accessConstraints/mco:MD_RestrictionCode/@codeList) and normalize-space(mco:accessConstraints/mco:MD_RestrictionCode/@codeListValue)" diagnostics="rule.ga.mco.accessconstraintspresent-failure-en">Fail mri:resourceConstraints/mco:MD_LegalConstraints/mco:accessConstraints/mco:MD_RestrictionCode.</sch:assert>
            <sch:report test="normalize-space(mco:accessConstraints/mco:MD_RestrictionCode/@codeList) and normalize-space(mco:accessConstraints/mco:MD_RestrictionCode/@codeListValue)" diagnostics="rule.ga.mco.accessconstraintspresent-success-en">Pass mri:resourceConstraints/mco:MD_LegalConstraints/mco:accessConstraints/mco:MD_RestrictionCode.</sch:report>
			<sch:assert test="normalize-space(mco:useConstraints/mco:MD_RestrictionCode/@codeList) and normalize-space(mco:useConstraints/mco:MD_RestrictionCode/@codeListValue)" diagnostics="rule.ga.mco.accessconstraintspresent-failure-en">Fail mri:resourceConstraints/mco:MD_LegalConstraints/mco:useConstraints/mco:MD_RestrictionCode.</sch:assert>
			<sch:report test="normalize-space(mco:useConstraints/mco:MD_RestrictionCode/@codeList) and normalize-space(mco:useConstraints/mco:MD_RestrictionCode/@codeListValue)" diagnostics="rule.ga.mco.accessconstraintspresent-success-en">Pass mri:resourceConstraints/mco:MD_LegalConstraints/mco:useConstraints/mco:MD_RestrictionCode.</sch:report>
		</sch:rule>
		
    </sch:pattern>
	

	<!-- ============================================================================================================ -->
	<!-- Assert that the resource point of contact is present                       -->
	<!-- ============================================================================================================ -->
	<sch:diagnostics>
		<sch:diagnostic id="rule.ga.mri.pointofcontactpresent-failure-en" xml:lang="en">Resource point of contact information not present.</sch:diagnostic>
		<sch:diagnostic id="rule.ga.mri.pointofcontactpresent-success-en" xml:lang="en">Resource point of contact information is present.</sch:diagnostic>
	</sch:diagnostics>	
	
	<sch:pattern id="rule.ga.mri.pointofcontact">
		<sch:title>Point of contact must be present in the resource identification information.</sch:title>
		
		<sch:rule context="//*[name()='mri:MD_DataIdentification' or name()='srv:SV_ServiceIdentification']">
			<sch:let name="parentClass" value="name(.)"/>
			
			<sch:assert test="count(mri:pointOfContact/cit:CI_Responsibility/*)>0" diagnostics="rule.ga.mri.pointofcontactpresent-failure-en">Fail <sch:value-of select="normalize-space($parentClass)"/>/mri:pointOfContact/cit:CI_Responsibility.</sch:assert>
			<sch:report test="count(mri:pointOfContact/cit:CI_Responsibility/*)>0" diagnostics="rule.ga.mri.pointofcontactpresent-success-en">Pass <sch:value-of select="normalize-space($parentClass)"/>/mri:pointOfContact/cit:CI_Responsibility.</sch:report>
		</sch:rule>
	</sch:pattern>		


	<!-- ============================================================================================================ -->
	<!-- Assert that maintenance information is present -->
	<!-- ============================================================================================================ -->
	<sch:diagnostics>
		<sch:diagnostic id="rule.ga.mmi.maintenanceinformationpresent-failure-en" xml:lang="en">Resource maintenance information not present.</sch:diagnostic>
		<sch:diagnostic id="rule.ga.mmi.maintenanceinformationpresent-success-en" xml:lang="en">Resource maintenance information is present.</sch:diagnostic>
		
		<sch:diagnostic id="rule.ga.mmi.maintenanceupdatefrequencypresent-failure-en" xml:lang="en">Resource maintenance update frequency not present or missing code list values.</sch:diagnostic>
		<sch:diagnostic id="rule.ga.mmi.maintenanceupdatefrequencypresent-success-en" xml:lang="en">Resource maintenance update frequency is present.</sch:diagnostic>
	</sch:diagnostics>	
	
	<sch:pattern id="rule.ga.mmi.maintenanceinformation">
		<sch:title>Maintenance information must be present and correctly filled out.</sch:title>
		
		<sch:rule context="//*[name()='mri:MD_DataIdentification' or name()='srv:SV_ServiceIdentification']">
			<sch:let name="parentClass" value="name(.)"/>

			<sch:assert test="count(mri:resourceMaintenance/mmi:MD_MaintenanceInformation/*)>0" diagnostics="rule.ga.mmi.maintenanceupdatefrequencypresent-failure-en">Fail <sch:value-of select="normalize-space($parentClass)"/>/mri:resourceMaintenance/mmi:MD_MaintenanceInformation.</sch:assert>
			<sch:report test="count(mri:resourceMaintenance/mmi:MD_MaintenanceInformation/*)>0" diagnostics="rule.ga.mmi.maintenanceupdatefrequencypresent-success-en">Pass <sch:value-of select="normalize-space($parentClass)"/>/mri:resourceMaintenance/mmi:MD_MaintenanceInformation.</sch:report>
		</sch:rule>
		<sch:rule context="//*[name()='mri:MD_DataIdentification' or name()='srv:SV_ServiceIdentification']/mri:resourceMaintenance/mmi:MD_MaintenanceInformation">
			<sch:let name="parentClass" value="name(../../.)"/>

			<sch:assert test="normalize-space(mmi:maintenanceAndUpdateFrequency/mmi:MD_MaintenanceFrequencyCode/@codeList) and normalize-space(mmi:maintenanceAndUpdateFrequency/mmi:MD_MaintenanceFrequencyCode/@codeListValue)" diagnostics="rule.ga.mmi.maintenanceupdatefrequencypresent-failure-en">Fail <sch:value-of select="normalize-space($parentClass)"/>/mri:resourceMaintenance/mmi:MD_MaintenanceInformation/mmi:maintenanceAndUpdateFrequency/mmi:MD_MaintenanceFrequencyCode.</sch:assert>
			<sch:report test="normalize-space(mmi:maintenanceAndUpdateFrequency/mmi:MD_MaintenanceFrequencyCode/@codeList) and normalize-space(mmi:maintenanceAndUpdateFrequency/mmi:MD_MaintenanceFrequencyCode/@codeListValue)" diagnostics="rule.ga.mmi.maintenanceupdatefrequencypresent-success-en">Pass <sch:value-of select="normalize-space($parentClass)"/>/mri:resourceMaintenance/mmi:MD_MaintenanceInformation/mmi:maintenanceAndUpdateFrequency/mmi:MD_MaintenanceFrequencyCode.</sch:report>
		</sch:rule>
	</sch:pattern>


	<!-- ============================================================================================================ -->
	<!-- Assert that resource format is present -->
	<!-- ============================================================================================================ -->
	<sch:diagnostics>
		<sch:diagnostic id="rule.ga.mri.resourceformatpresent-failure-en" xml:lang="en">Resource format not present.</sch:diagnostic>
		<sch:diagnostic id="rule.ga.mri.resourceformatpresent-success-en" xml:lang="en">Resource format is present.</sch:diagnostic>
	</sch:diagnostics>	
	
	<sch:pattern id="rule.ga.mri.resourceformat">
		<sch:title>Resource format must be present.</sch:title>
		
		<sch:rule context="//*[name()='mri:MD_DataIdentification' or name()='srv:SV_ServiceIdentification']">
			<sch:let name="parentClass" value="name(.)"/>
			
			<sch:assert test="count(mri:resourceFormat/mrd:MD_Format/*)>0" diagnostics="rule.ga.mri.resourceformatpresent-failure-en">Fail <sch:value-of select="normalize-space($parentClass)"/>/mri:resourceFormat/mrd:MD_Format.</sch:assert>
			<sch:report test="count(mri:resourceFormat/mrd:MD_Format/*)>0" diagnostics="rule.ga.mri.resourceformatpresent-success-en">Pass <sch:value-of select="normalize-space($parentClass)"/>/mri:resourceFormat/mrd:MD_Format.</sch:report>
		</sch:rule>
	</sch:pattern>


	<!-- ============================================================================================================ -->
	<!-- Assert that the resource topic category is present -->
	<!-- ============================================================================================================ -->
	<sch:diagnostics>
		<sch:diagnostic id="rule.ga.mri.topiccategorypresent-failure-en" xml:lang="en">Resource topic category not present or is empty.</sch:diagnostic>
		<sch:diagnostic id="rule.ga.mri.topiccategorypresent-success-en" xml:lang="en">Resource topic category is present.</sch:diagnostic>
	</sch:diagnostics>	
	
	<sch:pattern id="rule.ga.mri.topiccategory">
		<sch:title>Resource identification information must be present and correctly filled out.</sch:title>
		
		<sch:rule context="//*[name()='mri:MD_DataIdentification' or name()='srv:SV_ServiceIdentification']">
			<sch:let name="parentClass" value="name(.)"/>
			
			<sch:assert test="mri:topicCategory/mri:MD_TopicCategoryCode" diagnostics="rule.ga.mri.topiccategorypresent-failure-en">Fail <sch:value-of select="normalize-space($parentClass)"/>/mri:topicCategory/mri:MD_TopicCategoryCode.</sch:assert>
			<sch:report test="mri:topicCategory/mri:MD_TopicCategoryCode" diagnostics="rule.ga.mri.topiccategorypresent-success-en">Pass <sch:value-of select="normalize-space($parentClass)"/>/mri:topicCategory/mri:MD_TopicCategoryCode.</sch:report>
		</sch:rule>
	</sch:pattern>


	<!-- ============================================================================================================ -->
    <!-- Assert that descriptive keywords is present.                                                   -->
    <!-- ============================================================================================================ -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.ga.mri.descriptivekeywordspresent-failure-en" xml:lang="en">Resource descriptive keywords not present.</sch:diagnostic>
        <sch:diagnostic id="rule.ga.mri.descriptivekeywordspresent-success-en" xml:lang="en">Resource descriptive keywords are present.</sch:diagnostic>
    </sch:diagnostics>	
	
    <sch:pattern id="rule.ga.mri.descriptivekeywords">
        <sch:title>Resource descriptive keywords must be present.</sch:title>

        <sch:rule context="//*[name()='mri:MD_DataIdentification' or name()='srv:SV_ServiceIdentification']">
        	<sch:let name="parentClass" value="name(.)"/>

        	<sch:assert test="count(mri:descriptiveKeywords/mri:MD_Keywords/*)>0" diagnostics="rule.ga.mri.descriptivekeywordspresent-failure-en">Fail <sch:value-of select="normalize-space($parentClass)"/>/mri:descriptiveKeywords/mri:MD_Keywords.</sch:assert>
        	<sch:report test="count(mri:descriptiveKeywords/mri:MD_Keywords/*)>0" diagnostics="rule.ga.mri.descriptivekeywordspresent-success-en">Pass <sch:value-of select="normalize-space($parentClass)"/>/mri:descriptiveKeywords/mri:MD_Keywords.</sch:report>
        </sch:rule>
    </sch:pattern>
	
	
    <!-- ============================================================================================================ -->
    <!-- Assert that Distribution information has the distributionFormat element                                      -->
    <!-- ============================================================================================================ -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.ga.mrd.distributionformatpresent-failure-en" xml:lang="en">Distribution format is not present.</sch:diagnostic>
        <sch:diagnostic id="rule.ga.mrd.distributionformatpresent-success-en" xml:lang="en">Distribution format is present.</sch:diagnostic>
    </sch:diagnostics>

    <sch:pattern id="rule.ga.mrd.distributionformat">
        <sch:title>Distribution format must be present in the distribution information.</sch:title>

        <sch:rule context="//mrd:MD_Distribution">
        	<sch:assert test="count(mrd:distributionFormat/mrd:MD_Format)>0" diagnostics="rule.ga.mrd.distributionformatpresent-failure-en">Fail mrd:distributionFormat/mrd:MD_Format.</sch:assert>
        	<sch:report test="count(mrd:distributionFormat/mrd:MD_Format)>0" diagnostics="rule.ga.mrd.distributionformatpresent-success-en">Pass mrd:distributionFormat/mrd:MD_Format.</sch:report>
        </sch:rule>
    </sch:pattern>
	

	<!-- ============================================================================================================ -->
	<!-- Assert that Data Identification has extent element if scope is 'dataset'                                     -->
	<!-- ============================================================================================================ -->
	<sch:diagnostics>
		<sch:diagnostic id="rule.ga.gex.extentinformationpresent-failure-en" xml:lang="en">Extent information in dataset indentification is not present.</sch:diagnostic>
		<sch:diagnostic id="rule.ga.gex.extentinformationpresent-success-en" xml:lang="en">Extent information in dataset indentification is present.</sch:diagnostic>
	</sch:diagnostics>
	
	<sch:pattern id="rule.ga.gex.identificationinformation">
		<sch:title>Identification information must have at least one of “geographicElement“ or “temporalElement“ or “verticalElement“ extent types if metadataScope is dataset.</sch:title>

		<sch:rule context="//mdb:MD_Metadata[mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode[@codeListValue='dataset' or @codeListValue='']]/mdb:identificationInfo/*">

			<sch:let name="extentCount" value="count(//mri:extent/gex:EX_Extent/gex:geographicElement/*) + count(//mri:extent/gex:EX_Extent/gex:temporalElement/*) + count(//mri:extent/gex:EX_Extent/gex:verticalElement/*)"/>

			<sch:assert test="$extentCount>0" diagnostics="rule.ga.gex.extentinformationpresent-failure-en">Fail mri:extent/gex:EX_Extent.</sch:assert>
			<sch:report test="$extentCount>0" diagnostics="rule.ga.gex.extentinformationpresent-success-en">Pass mri:extent/gex:EX_Extent.</sch:report>
		</sch:rule>
	</sch:pattern>
	
			
    <!-- ============================================================================================================ -->
    <!-- Assert that the Lineage Information is present and has required mandatory descendent elements                -->
    <!-- ============================================================================================================ -->
    <sch:diagnostics>
        <sch:diagnostic id="rule.ga.mrl.resourcelineagepresent-failure-en" xml:lang="en">Resource Lineage information is not present.</sch:diagnostic>
        <sch:diagnostic id="rule.ga.mrl.resourcelineagepresent-success-en" xml:lang="en">Resource lineage information is present.</sch:diagnostic>
        <sch:diagnostic id="rule.ga.mrl.resourcelineagestatementpresent-failure-en" xml:lang="en">Resource lineage statement is not present.</sch:diagnostic>
        <sch:diagnostic id="rule.ga.mrl.resourcelineagestatementpresent-success-en" xml:lang="en">Resource lineage statement is present.</sch:diagnostic>
    	<sch:diagnostic id="rule.ga.mrl.lineagesourcedescpresent-failure-en" xml:lang="en">Lineage source description not present.</sch:diagnostic>
    	<sch:diagnostic id="rule.ga.mrl.lineagesourcedescpresent-success-en" xml:lang="en">Lineage source description is present.</sch:diagnostic>
    	<sch:diagnostic id="rule.ga.mrl.lineagesourcecitationpresent-failure-en" xml:lang="en">Lineage source citation not present.</sch:diagnostic>
    	<sch:diagnostic id="rule.ga.mrl.lineagesourcecitationpresent-success-en" xml:lang="en">Lineage source citation is present.</sch:diagnostic>
    </sch:diagnostics>

    <sch:pattern id="rule.ga.mrl.resourcelineagepresent">
        <sch:title xml:lang="en">Resource lineage information must be present and correctly filled out.</sch:title>

        <sch:rule context="/mdb:MD_Metadata">
        	<sch:assert test="count(mdb:resourceLineage/mrl:LI_Lineage/*)>0" diagnostics="rule.ga.mrl.resourcelineagepresent-failure-en">Fail mdb:resourceLineage/mrl:LI_Lineage.</sch:assert>
        	<sch:report test="count(mdb:resourceLineage/mrl:LI_Lineage/*)>0" diagnostics="rule.ga.mrl.resourcelineagepresent-success-en">Pass mdb:resourceLineage/mrl:LI_Lineage.</sch:report>
        </sch:rule>

        <sch:rule context="//mdb:resourceLineage/mrl:LI_Lineage">
        	<sch:assert test="normalize-space(mrl:statement)" diagnostics="rule.ga.mrl.resourcelineagestatementpresent-failure-en">Fail mdb:resourceLineage/mrl:LI_Lineage/mrl:statement.</sch:assert>
        	<sch:report test="normalize-space(mrl:statement)" diagnostics="rule.ga.mrl.resourcelineagestatementpresent-success-en">Pass mdb:resourceLineage/mrl:LI_Lineage/mrl:statement.</sch:report>
        </sch:rule>
    	
    	<sch:rule context="//mrl:source/mrl:LI_Source">
    		<sch:assert test="normalize-space(mrl:description/gco:CharacterString) != ''" diagnostics="rule.ga.mrl.lineagesourcedescpresent-failure-en">Fail mdb:resourceLineage/mrl:LI_Lineage/mrl:description.</sch:assert>
    		<sch:report test="normalize-space(mrl:description/gco:CharacterString) != ''" diagnostics="rule.ga.mrl.lineagesourcedescpresent-success-en">Pass mdb:resourceLineage/mrl:LI_Lineage/mrl:description.</sch:report>

    		<sch:assert test="count(mrl:sourceCitation/cit:CI_Citation/*)>0" diagnostics="rule.ga.mrl.lineagesourcecitationpresent-failure-en">Fail mdb:resourceLineage/mrl:LI_Lineage/mrl:sourceCitation.</sch:assert>
    		<sch:report test="count(mrl:sourceCitation/cit:CI_Citation/*)>0" diagnostics="rule.ga.mrl.lineagesourcecitationpresent-success-en">Pass mdb:resourceLineage/mrl:LI_Lineage/mrl:sourceCitation.</sch:report>
    	</sch:rule>
    </sch:pattern>
	
	
	<!-- ================================================================================================================== -->
	<!-- Assert that the Source element in Lineage Information is present if scope is 'dataset' or 'non-geographic dataset' -->
	<!-- ================================================================================================================== -->
	<sch:diagnostics>
		<sch:diagnostic id="rule.ga.mrl.lineagesourcepresent-failure-en" xml:lang="en">Lineage source information is not present.</sch:diagnostic>
		<sch:diagnostic id="rule.ga.mrl.lineagesourcepresent-success-en" xml:lang="en">Lineage source information is present.</sch:diagnostic>
	</sch:diagnostics>
	
	<sch:pattern id="rule.ga.mrl.lineagesourcepresent">
		<sch:title xml:lang="en">Lineage source information must be present if scope is 'dataset' or 'non-geographic dataset'.</sch:title>
		
		<sch:rule context="/mdb:MD_Metadata[mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode[@codeListValue='dataset' or @codeListValue='']]/mdb:resourceLineage/mrl:LI_Lineage">
			<sch:assert test="count(mrl:source/mrl:LI_Source/*)>0" diagnostics="rule.ga.mrl.lineagesourcepresent-failure-en">Fail mdb:resourceLineage/mrl:LI_Lineage/mrl:source/mrl:LI_Source.</sch:assert>
			<sch:report test="count(mrl:source/mrl:LI_Source/*)>0" diagnostics="rule.ga.mrl.lineagesourcepresent-success-en">Pass mdb:resourceLineage/mrl:LI_Lineage/mrl:source/mrl:LI_Source.</sch:report>
		</sch:rule>
	</sch:pattern>
</sch:schema>
