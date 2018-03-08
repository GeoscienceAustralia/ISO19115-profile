<?xml version="1.0" encoding="UTF-8"?><sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
   <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="en">Schematron validation for Version 2.0 of Geoscience Australia profile of ISO 19115-1:2014 standard</sch:title>
   
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

	 <!-- Taken from GA profile version 1.0 schematrons and converted to ISO19115-1:2014 and ISO19115-3:2015 -->
	      
	 <!-- ============================================================================================================ -->
	 <!-- Assert that metadataIdentifier (at least one) is present -->
	 <!-- ============================================================================================================ -->
   <sch:diagnostics>
      <sch:diagnostic id="rule.ga.mdb.metadataidentifierpresent-failure-en" xml:lang="en">The metadata identifier is not present.</sch:diagnostic>
      
    
      <sch:diagnostic id="rule.ga.mdb.metadataidentifierpresent-success-en" xml:lang="en">The metadata identifier is present
      "<sch:value-of select="normalize-space($mdid)"/>"
      .</sch:diagnostic>
      
  </sch:diagnostics>
   <sch:pattern id="rule.ga.mdb.metadataidentifierpresent">
      <sch:title xml:lang="en">Metadata identifier must be present.</sch:title>
      
    
      <sch:rule context="//mdb:metadataIdentifier[1]/mcc:MD_Identifier">
      
         <sch:let name="mdid" value="mcc:code/gco:CharacterString"/>
         <sch:let name="hasMdid" value="normalize-space($mdid) != ''"/>
      
         <sch:assert test="$hasMdid" diagnostics="rule.ga.mdb.metadataidentifierpresent-failure-en"/>
      
         <sch:report test="$hasMdid" diagnostics="rule.ga.mdb.metadataidentifierpresent-success-en"/>
      </sch:rule>
  </sch:pattern>

	 <!-- mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue -->

	 <!-- mdb:parentMetadata/cit:CI_Citation/cit:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString -->

	 <!-- ============================================================================================================ -->
	 <!-- Assert that parentIdentifier is conditionally present -->
	 <!-- ============================================================================================================ -->
   <sch:diagnostics>
      <sch:diagnostic id="rule.ga.mdb.metadataparentidentifierpresent-failure-en" xml:lang="en">The metadata parent identifier must be present if metadataScope is one of ('feature','featureType','attribute','attributeType').</sch:diagnostic>
      
    
      <sch:diagnostic id="rule.ga.mdb.metadataparentidentifierpresent-success-en" xml:lang="en">The metadata parent identifier is present "<sch:value-of select="normalize-space($parentId)"/>" and metadataScope "<sch:value-of select="normalize-space($scopeCode)"/>" is one of ('feature','featureType','attribute','attributeType').</sch:diagnostic>
      
  </sch:diagnostics>

   <sch:pattern id="rule.ga.mdb.metadataparentidentifierpresent">
      <sch:title xml:lang="en">Metadata parent identifier must be present if metadataScope is one of ('feature','featureType','attribute','attributeType').</sch:title>
      
    
      <sch:rule context="/mdb:MD_Metadata">
      
         <sch:let name="scopeCode" value="mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue"/>
         <sch:let name="parentId" value="mdb:parentMetadata/cit:CI_Citation/cit:identifier/mcc:MD_Identifier/mcc:code/gco:CharacterString"/>
         <sch:let name="hasParent" value="normalize-space($parentId) and $scopeCode = ('feature','featureType','attribute','attributeType')"/>
      
         <sch:assert test="not($hasParent)" diagnostics="rule.ga.mdb.metadataparentidentifierpresent-failure-en"/>
      
         <sch:report test="not($hasParent)" diagnostics="rule.ga.mdb.metadataparentidentifierpresent-success-en"/>
      </sch:rule>
  </sch:pattern>
	 <!-- ============================================================================================================ -->
	 <!-- Assert that dataSetURI (now an identifier in the identificationInfo//citation) is conditionally present -->
	 <!-- ============================================================================================================ -->
   <sch:diagnostics>
      <sch:diagnostic id="rule.ga.mdb.dataseturipresent-failure-en" xml:lang="en">The dataSetURI identifier must be present if metadataScope is one of ('dataset','').</sch:diagnostic>
      
    
      <sch:diagnostic id="rule.ga.mdb.dataseturipresent-success-en" xml:lang="en">The dataSetURI identifier is present "<sch:value-of select="normalize-space($dataseturi)"/>" and metadataScope is "<sch:value-of select="normalize-space($scopeCode)"/>".</sch:diagnostic>
  </sch:diagnostics>

   <sch:pattern id="rule.ga.mdb.dataseturipresent">
      <sch:title xml:lang="en">Dataset URI must be present if metadataScope is one of ('dataset','').</sch:title>
      
    
      <sch:rule context="/mdb:MD_Metadata[mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue=('dataset', '')]">
      
         <sch:let name="scopeCode" value="mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue"/>
         <sch:let name="dataseturi" value="mdb:identificationInfo/*/mri:citation/*/cit:identifier/mcc:MD_Identifier[mcc:codeSpace/gco:CharacterString='ga-dataSetURI']/mcc:code/gco:CharacterString"/>
         <sch:let name="hasDataseturi" value="normalize-space($dataseturi) and $scopeCode = ('dataset', '')"/>
      
         <sch:assert test="$hasDataseturi" diagnostics="rule.ga.mdb.dataseturipresent-failure-en"/>
      
         <sch:report test="$hasDataseturi" diagnostics="rule.ga.mdb.dataseturipresent-success-en"/>
      </sch:rule>
  </sch:pattern>
	 <!-- ============================================================================================================ -->
	 <!-- Assert that metadataProfile with title and edition for GA profile are present -->
	 <!-- ============================================================================================================ -->
   <sch:diagnostics>
      <sch:diagnostic id="rule.ga.mdb.metadataprofilepresent-failure-en" xml:lang="en">The metadata profile information (mdb:metadataProfile) is not present or may be incorrect - looking for title: 'Geoscience Australia Community Metadata Profile of ISO 19115-1:2014' and edition/version: 'Version 2.0, April 2015'.</sch:diagnostic>
      
    
      <sch:diagnostic id="rule.ga.mdb.metadataprofilepresent-success-en" xml:lang="en">The metadata profile information is present: "<sch:value-of select="normalize-space($title)"/>" with "<sch:value-of select="normalize-space($edition)"/>".</sch:diagnostic>
      
  </sch:diagnostics>
   <sch:pattern id="rule.ga.mdb.metadataprofilepresent">
      <sch:title xml:lang="en">Metadata profile information must be present and correctly filled out.</sch:title>
      
    
      <sch:rule context="//mdb:metadataProfile/cit:CI_Citation">
      
         <sch:let name="title" value="cit:title/gco:CharacterString"/>
         <sch:let name="hasTitle" value="normalize-space($title) = 'Geoscience Australia Community Metadata Profile of ISO 19115-1:2014'"/>
         <sch:let name="edition" value="cit:edition/gco:CharacterString"/>
         <sch:let name="hasEdition" value="normalize-space($edition) = 'Version 2.0, April 2015'"/>
      
         <sch:assert test="$hasTitle and $hasEdition" diagnostics="rule.ga.mdb.metadataprofilepresent-failure-en"/>
      
         <sch:report test="$hasTitle and $hasEdition" diagnostics="rule.ga.mdb.metadataprofilepresent-success-en"/>
      </sch:rule>
  </sch:pattern>
	 <!-- ============================================================================================================ -->
	 <!-- Assert that the Reference System Information is conditionally present -->
	 <!-- ============================================================================================================ -->
	 <!-- Actually, no - doesn't seem like we want this rule after all....... Disabled by request of
	      Martin - October 21, 2015
   <sch:diagnostics>
      <sch:diagnostic id="rule.ga.mdb.referencesysteminfopresent-failure-en" xml:lang="en">The reference system information (mdb:referenceSystemInfo) is not present if metadataScope is one of ('dataset','').</sch:diagnostic>
      
    
      <sch:diagnostic id="rule.ga.mdb.referencesysteminfopresent-success-en" xml:lang="en">The reference system information  (mdb:referenceSystemInfo) is present and metadataScope is "<sch:value-of select="normalize-space($scopeCode)"/>"..</sch:diagnostic>
      
  </sch:diagnostics>
   <sch:pattern id="rule.ga.mdb.referencesysteminfopresent">
      <sch:title xml:lang="en">Reference system information must be present and correctly filled out if metadataScope is one of ('dataset','').</sch:title>
      
    
      <sch:rule context="//mdb:MD_Metadata[mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue=('dataset','')]">
         <sch:let name="scopeCode" value="mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue"/>
         <sch:let name="hasReferenceSystemInfo" value="count(mdb:referenceSystemInfo)>0 and $scopeCode = ('dataset', '')"/>

         <sch:assert test="$hasReferenceSystemInfo" diagnostics="rule.ga.mdb.referencesysteminfopresent-failure-en"/>
      
         <sch:report test="$hasReferenceSystemInfo" diagnostics="rule.ga.mdb.referencesysteminfopresent-success-en"/>
      </sch:rule>
  </sch:pattern>
	-->
	 <!-- ============================================================================================================ -->
	 <!-- Assert that the Data Quality Information is present and has required mandatory descendent elements -->
	 <!-- ============================================================================================================ -->
	 <!-- Disabled by request of Irina and Martin - August 17, 2015
   <sch:diagnostics>
	 		<sch:diagnostic id="rule.ga.mdq.dataqualityinfopresent-failure-en" xml:lang="en">Data Quality elements not present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mdq.dataqualityinfopresent-success-en" xml:lang="en">Data Quality elements are present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mdq.dataqualityinfoscopepresent-failure-en" xml:lang="en">DQ_DataQuality/scope/DQ_Scope not present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mdq.dataqualityinfoscopepresent-success-en" xml:lang="en">DQ_DataQuality/scope/DQ_Scope is present.</sch:diagnostic>
  </sch:diagnostics>
   <sch:pattern id="rule.ga.mdq.dataqualityinfopresent">
	 		<sch:title xml:lang="en">Data Quality Information must be present and correctly filled out if metadataScope is one of ('dataset','').</sch:title>

	 		<sch:rule context="//mdb:MD_Metadata[mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue=('dataset','')]">
				<sch:assert test="mdb:dataQualityInfo/mdq:DQ_DataQuality" diagnostics="rule.ga.mdq.dataqualityinfopresent-failure-en"/>
				<sch:report test="mdb:dataQualityInfo/mdq:DQ_DataQuality" diagnostics="rule.ga.mdq.dataqualityinfopresent-success-en"/>
			</sch:rule>
	 		<sch:rule context="//mdb:dataQualityInfo/mdq:DQ_DataQuality">
				<sch:assert test="mdq:scope/mdq:DQ_Scope" diagnostics="rule.ga.mdq.dataqualityinfoscopepresent-failure-en"/>
				<sch:report test="mdq:scope/mdq:DQ_Scope" diagnostics="rule.ga.mdq.dataqualityinfoscopepresent-success-en"/>
			</sch:rule>
  </sch:pattern>
	-->
	 <!-- ============================================================================================================ -->
	 <!-- Assert that the Lineage Information is present and has required mandatory descendent elements -->
	 <!-- ============================================================================================================ -->
   <sch:diagnostics>
	 		<sch:diagnostic id="rule.ga.mrl.resourcelineagepresent-failure-en" xml:lang="en">Resource Lineage elements not present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mrl.resourcelineagepresent-success-en" xml:lang="en">Resource Lineage elements are present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mrl.resourcelineagestatementpresent-failure-en" xml:lang="en">Resource Lineage statement not present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mrl.resourcelineagestatementpresent-success-en" xml:lang="en">Resource Lineage statement is present.</sch:diagnostic>
  </sch:diagnostics>
   <sch:pattern id="rule.ga.mrl.resourcelineagepresent">
	 		<sch:title xml:lang="en">Resource Lineage must be present and correctly filled out.</sch:title>

	 		<sch:rule context="//mdb:MD_Metadata">
				<sch:assert test="mdb:resourceLineage/mrl:LI_Lineage" diagnostics="rule.ga.mrl.resourcelineagepresent-failure-en"/>
				<sch:report test="mdb:resourceLineage/mrl:LI_Lineage" diagnostics="rule.ga.mrl.resourcelineagepresent-success-en"/>
			</sch:rule>
	 		<sch:rule context="//mdb:resourceLineage/mrl:LI_Lineage">
				<sch:assert test="normalize-space(mrl:statement)" diagnostics="rule.ga.mrl.resourcelineagestatementpresent-failure-en"/>
				<sch:report test="normalize-space(mrl:statement)" diagnostics="rule.ga.mrl.resourcelineagestatementpresent-success-en"/>
			</sch:rule>
  </sch:pattern>
	 <!-- ============================================================================================================ -->
	 <!-- Assert that the Constraint Information is present -->
	 <!-- ============================================================================================================ -->
   <sch:diagnostics>
	 		<sch:diagnostic id="rule.ga.mco.metadataconstraintspresent-failure-en" xml:lang="en">Metadata Constraint elements not present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mco.metadataconstraintspresent-success-en" xml:lang="en">Metadata Constraint elements are present.</sch:diagnostic>


	 		<sch:diagnostic id="rule.ga.mco.metadatasecurityconstraintspresent-failure-en" xml:lang="en">Metadata Security Constraint elements not present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mco.metadatasecurityconstraintspresent-success-en" xml:lang="en">Metadata Security Constraint elements are present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mco.securityconstraintsclassificationpresent-failure-en" xml:lang="en">Classification code not present in Security Constraints.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mco.securityconstraintsclassificationpresent-success-en" xml:lang="en">Classification code is present in Security Constraints.</sch:diagnostic>
   </sch:diagnostics>
   <sch:pattern id="rule.ga.mco.securityconstraints">
	 		<sch:title>Constraint Information must be present and correctly filled out.</sch:title>
			<sch:rule context="//mdb:MD_Metadata">
				<sch:assert test="mdb:metadataConstraints/*" diagnostics="rule.ga.mco.metadataconstraintspresent-failure-en"/>
				<sch:report test="mdb:metadataConstraints/*" diagnostics="rule.ga.mco.metadataconstraintspresent-success-en"/>

				<sch:assert test="mdb:metadataConstraints/mco:MD_SecurityConstraints" diagnostics="rule.ga.mco.metadatasecurityconstraintspresent-failure-en"/>
				<sch:report test="mdb:metadataConstraints/mco:MD_SecurityConstraints" diagnostics="rule.ga.mco.metadatasecurityconstraintspresent-success-en"/>
			</sch:rule>
			<sch:rule context="//mco:MD_SecurityConstraints/mco:classification">
				<sch:assert test="normalize-space(mco:MD_ClassificationCode/@codeList) and normalize-space(mco:MD_ClassificationCode/@codeListValue)" diagnostics="rule.ga.mco.securityconstraintsclassificationpresent-failure-en"/>
				<sch:report test="normalize-space(mco:MD_ClassificationCode/@codeList) and normalize-space(mco:MD_ClassificationCode/@codeListValue)" diagnostics="rule.ga.mco.securityconstraintsclassificationpresent-success-en"/>
			</sch:rule>
  </sch:pattern>
	 <!-- ============================================================================================================ -->
	 <!-- Assert that the Data Identification Information is present -->
	 <!-- ============================================================================================================ -->
   <sch:diagnostics>
	 		<sch:diagnostic id="rule.ga.mri.identificationinformationpresent-failure-en" xml:lang="en">Data Identification Information element not present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mri.identificationinformationpresent-success-en" xml:lang="en">Data Identification Information element is present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mri.pointofcontactpresent-failure-en" xml:lang="en">MD_DataIdentification/pointOfContact information not present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mri.pointofcontactpresent-success-en" xml:lang="en">MD_DataIdentification/pointOfContact information is present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mri.maintenanceinformationpresent-failure-en" xml:lang="en">MD_DataIdentification/ resourceMaintenance/ MD_MaintenanceInformation not present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mri.maintenanceinformationpresent-success-en" xml:lang="en">MD_DataIdentification/ resourceMaintenance/ MD_MaintenanceInformation is present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mri.resourceformatpresent-failure-en" xml:lang="en">MD_DataIdentification/ resourceFormat/ MD_Format not present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mri.resourceformatpresent-success-en" xml:lang="en">MD_DataIdentification/ resourceFormat/ MD_Format is present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mri.resourceconstraintspresent-failure-en" xml:lang="en">MD_DataIdentification/ resourceConstraints information not present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mri.resourceconstraintspresent-success-en" xml:lang="en">MD_DataIdentification/ resourceConstraints information is present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mri.topiccategorypresent-failure-en" xml:lang="en">MD_DataIdentification/ topicCategory not present or empty.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mri.topiccategorypresent-success-en" xml:lang="en">MD_DataIdentification/ topicCategory is present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mri.securityconstraintspresent-failure-en" xml:lang="en">MD_DataIdentification/ resourceConstraints/ MD_SecurityConstraints not present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mri.securityconstraintspresent-success-en" xml:lang="en">MD_DataIdentification/ resourceConstraints/ MD_SecurityConstraints is present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mri.legalconstraintspresent-failure-en" xml:lang="en">MD_DataIdentification/ resourceConstraints/ MD_LegalConstraints not present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.mri.legalconstraintspresent-success-en" xml:lang="en">MD_DataIdentification/ resourceConstraints/ MD_LegalConstraints is present.</sch:diagnostic>
   </sch:diagnostics>
   <sch:pattern id="rule.ga.mri.identificationinformation">
	 		<sch:title>Identification Information must be present and correctly filled out.</sch:title>
			<sch:rule context="//mdb:MD_Metadata[descendant::mri:MD_DataIdentification]">
				<sch:assert test="mdb:identificationInfo/mri:MD_DataIdentification" diagnostics="rule.ga.mri.identificationinformationpresent-failure-en"/>
				<sch:report test="mdb:identificationInfo/mri:MD_DataIdentification" diagnostics="rule.ga.mri.identificationinformationpresent-success-en"/>
			</sch:rule>
			<sch:rule context="//mri:MD_DataIdentification[parent::mdb:identificationInfo[parent::mdb:MD_Metadata]]">
      	<sch:assert test="count(mri:pointOfContact[descendant::text()])>0" diagnostics="rule.ga.mri.pointofcontactpresent-failure-en"/>
      	<sch:report test="count(mri:pointOfContact[descendant::text()])>0" diagnostics="rule.ga.mri.pointofcontactpresent-success-en"/>

      	<sch:assert test="mri:resourceMaintenance/mmi:MD_MaintenanceInformation" diagnostics="rule.ga.mri.maintenanceinformationpresent-failure-en"/> 
      	<sch:report test="mri:resourceMaintenance/mmi:MD_MaintenanceInformation" diagnostics="rule.ga.mri.maintenanceinformationpresent-success-en"/> 

      	<sch:assert test="mri:resourceFormat/mrd:MD_Format" 										 diagnostics="rule.ga.mri.resourceformatpresent-failure-en"/>
      	<sch:report test="mri:resourceFormat/mrd:MD_Format" 										 diagnostics="rule.ga.mri.resourceformatpresent-success-en"/>

      	<sch:assert test="mri:resourceConstraints/*"														 diagnostics="rule.ga.mri.resourceconstraintspresent-failure-en"/>
      	<sch:report test="mri:resourceConstraints/*"														 diagnostics="rule.ga.mri.resourceconstraintspresent-success-en"/>

      	<sch:assert test="normalize-space(mri:topicCategory)"		diagnostics="rule.ga.mri.topiccategorypresent-failure-en"/>
      	<sch:report test="normalize-space(mri:topicCategory)"		diagnostics="rule.ga.mri.topiccategorypresent-success-en"/>

      	<sch:assert test="mri:resourceConstraints/mco:MD_SecurityConstraints"	diagnostics="rule.ga.mri.securityconstraintspresent-failure-en"/>
      	<sch:report test="mri:resourceConstraints/mco:MD_SecurityConstraints"	diagnostics="rule.ga.mri.securityconstraintspresent-success-en"/>

      	<sch:assert test="mri:resourceConstraints/mco:MD_LegalConstraints"    diagnostics="rule.ga.mri.legalconstraintspresent-failure-en"/>
      	<sch:report test="mri:resourceConstraints/mco:MD_LegalConstraints"    diagnostics="rule.ga.mri.legalconstraintspresent-success-en"/>
    </sch:rule>
  </sch:pattern>
	<!-- ============================================================================================================ -->
  <!-- Assert that Data Identification has extent element if scope is 'dataset'  -->
	<!-- ============================================================================================================ -->
  <sch:diagnostics>
	 		<sch:diagnostic id="rule.ga.gex.extentinformationpresent-failure-en" xml:lang="en">MD_DataIdentification/ extent information not present.</sch:diagnostic>
	 		<sch:diagnostic id="rule.ga.gex.extentinformationpresent-success-en" xml:lang="en">MD_DataIdentification/ extent information is present.</sch:diagnostic>
  </sch:diagnostics>
  <sch:pattern id="rule.ga.gex.identificationinformation">
	 	<sch:title>Identification Information must have an extent if metadataScope is dataset.</sch:title>
		<sch:rule context="//mdb:MD_Metadata[mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue=('dataset','')]">
      	<sch:assert test="count(mdb:identificationInfo/*/mri:extent/gex:EX_Extent/*)>0"		diagnostics="rule.ga.gex.extentinformationpresent-failure-en"/>
      	<sch:report test="count(mdb:identificationInfo/*/mri:extent/gex:EX_Extent/*)>0"		diagnostics="rule.ga.gex.extentinformationpresent-success-en"/>
    </sch:rule>
  </sch:pattern>
	<!-- ============================================================================================================ -->
  <!-- Assert that Legal Constraints has required mandatory descendent elements  -->
	<!-- ============================================================================================================ -->
  <sch:diagnostics>
	 	<sch:diagnostic id="rule.ga.mco.accessconstraintspresent-failure-en" xml:lang="en">MD_DataIdentification/ resourceConstraints/ MD_LegalConstraints/ accessConstraints not present.</sch:diagnostic>
	 	<sch:diagnostic id="rule.ga.mco.accessconstraintspresent-success-en" xml:lang="en">MD_DataIdentification/ resourceConstraints/ MD_LegalConstraints/ accessConstraints is present.</sch:diagnostic>
	 	<sch:diagnostic id="rule.ga.mco.useconstraintspresent-failure-en" xml:lang="en">MD_DataIdentification/ resourceConstraints/MD_LegalConstraints/useConstraints not present.</sch:diagnostic>
	 	<sch:diagnostic id="rule.ga.mco.useconstraintspresent-success-en" xml:lang="en">MD_DataIdentification/ resourceConstraints/MD_LegalConstraints/useConstraints is present.</sch:diagnostic>
	 	<sch:diagnostic id="rule.ga.mco.accessconstraintscodepresent-failure-en" xml:lang="en">MD_LegalConstraints/ accessConstraints/ MD_RestrictionCode not present or missing code list values.</sch:diagnostic>
	 	<sch:diagnostic id="rule.ga.mco.accessconstraintscodepresent-success-en" xml:lang="en">MD_LegalConstraints/ accessConstraints/ MD_RestrictionCode is present.</sch:diagnostic>
	 	<sch:diagnostic id="rule.ga.mco.useconstraintscodepresent-failure-en" xml:lang="en">MD_LegalConstraints/ useConstraints/ MD_RestrictionCode not present or missing code list values.</sch:diagnostic>
	 	<sch:diagnostic id="rule.ga.mco.useconstraintscodepresent-success-en" xml:lang="en">MD_LegalConstraints/ useConstraints/ MD_RestrictionCode is present.</sch:diagnostic>
  </sch:diagnostics>
  <sch:pattern rule="rule.ga.mco.legalconstraints">
    <sch:title>Legal Constraints has required/mandatory descendent elements.</sch:title>
    <sch:rule context="//mri:MD_DataIdentification">
      <sch:assert test="mri:resourceConstraints/mco:MD_LegalConstraints/mco:accessConstraints" diagnostics="rule.ga.mco.accessconstraintspresent-failure-en"/>
      <sch:report test="mri:resourceConstraints/mco:MD_LegalConstraints/mco:accessConstraints" diagnostics="rule.ga.mco.accessconstraintspresent-success-en"/>

      <sch:assert test="mri:resourceConstraints/mco:MD_LegalConstraints/mco:useConstraints"    diagnostics="rule.ga.mco.useconstraintspresent-failure-en"/>
      <sch:report test="mri:resourceConstraints/mco:MD_LegalConstraints/mco:useConstraints"    diagnostics="rule.ga.mco.useconstraintspresent-success-en"/>

    </sch:rule>
    <sch:rule context="//mco:MD_LegalConstraints/mco:accessConstraints">
      <sch:assert test="normalize-space(mco:MD_RestrictionCode/@codeList) and normalize-space(mco:MD_RestrictionCode/@codeListValue)" diagnostics="rule.ga.mco.accessconstraintscodepresent-failure-en"/>
      <sch:report test="normalize-space(mco:MD_RestrictionCode/@codeList) and normalize-space(mco:MD_RestrictionCode/@codeListValue)" diagnostics="rule.ga.mco.accessconstraintscodepresent-success-en"/>
    </sch:rule>
    <sch:rule context="//mco:MD_LegalConstraints/mco:useConstraints">
      <sch:assert test="normalize-space(mco:MD_RestrictionCode/@codeList) and normalize-space(mco:MD_RestrictionCode/@codeListValue)" diagnostics="rule.ga.mco.useconstraintscodepresent-failure-en"/>
      <sch:report test="normalize-space(mco:MD_RestrictionCode/@codeList) and normalize-space(mco:MD_RestrictionCode/@codeListValue)" diagnostics="rule.ga.mco.useconstraintscodepresent-success-en"/>
    </sch:rule>
  </sch:pattern>
	<!-- ============================================================================================================ -->
  <!-- Assert that Security Constraints has required mandatory descendent elements  -->
	<!-- ============================================================================================================ -->
  <sch:diagnostics>
	 	<sch:diagnostic id="rule.ga.mco.securityconstraintspresent-failure-en" xml:lang="en">MD_ClassificationCode not present or missing code list values.</sch:diagnostic>
	 	<sch:diagnostic id="rule.ga.mco.securityconstraintspresent-success-en" xml:lang="en">MD_ClassificationCode is present.</sch:diagnostic>
  </sch:diagnostics>
  <sch:pattern rule="rule.ga.mco.securityconstraints">
    <sch:title>Security Constraints has required/mandatory descendent elements.</sch:title>
    <sch:rule context="//mco:MD_SecurityConstraints/mco:classification">
      <sch:assert test="normalize-space(mco:MD_ClassificationCode/@codeList) and normalize-space(mco:MD_ClassificationCode/@codeListValue)" diagnostics="rule.ga.mco.securityconstraintspresent-failure-en"/>
      <sch:report test="normalize-space(mco:MD_ClassificationCode/@codeList) and normalize-space(mco:MD_ClassificationCode/@codeListValue)" diagnostics="rule.ga.mco.securityconstraintspresent-success-en"/>
    </sch:rule>
  </sch:pattern>
	<!-- ============================================================================================================ -->
  <!-- Assert that Resource Format has required mandatory descendent elements  -->
	<!-- ============================================================================================================ -->
  <sch:diagnostics>
	 	<sch:diagnostic id="rule.ga.mrd.resourceformatnamepresent-failure-en" xml:lang="en">resourceFormat/ MD_Format/ formatSpecificationCitation/ */ title (format name) not present or empty.</sch:diagnostic>
	 	<sch:diagnostic id="rule.ga.mrd.resourceformatnamepresent-success-en" xml:lang="en">resourceFormat/ MD_Format/ formatSpecificationCitation/ */ title (format name) is present.</sch:diagnostic>
	 	<sch:diagnostic id="rule.ga.mrd.resourceformatversionpresent-failure-en" xml:lang="en">resourceFormat/ MD_Format/ formatSpecificationCitation/ */ edition (format version) not present or empty.</sch:diagnostic>
	 	<sch:diagnostic id="rule.ga.mrd.resourceformatversionpresent-success-en" xml:lang="en">resourceFormat/ MD_Format/ formatSpecificationCitation/ */ edition (format version) is present.</sch:diagnostic>
  </sch:diagnostics>
  <sch:pattern rule="rule.ga.mrd.resourceformat">
    <sch:title>Resource Format has required/mandatory descendent elements.</sch:title>
    <sch:rule context="//mrd:MD_Format[parent::mri:resourceFormat]">
			<sch:assert test="normalize-space(mrd:formatSpecificationCitation/cit:CI_Citation/cit:title/gco:CharacterString)" diagnostics="rule.ga.mrd.resourceformatnamepresent-failure-en"/>
			<sch:report test="normalize-space(mrd:formatSpecificationCitation/cit:CI_Citation/cit:title/gco:CharacterString)" diagnostics="rule.ga.mrd.resourceformatnamepresent-success-en"/>
			<sch:assert test="normalize-space(mrd:formatSpecificationCitation/cit:CI_Citation/cit:edition/gco:CharacterString)" diagnostics="rule.ga.mrd.resourceformatversionpresent-failure-en"/>
			<sch:report test="normalize-space(mrd:formatSpecificationCitation/cit:CI_Citation/cit:edition/gco:CharacterString)" diagnostics="rule.ga.mrd.resourceformatversionpresent-success-en"/>
		</sch:rule>
  </sch:pattern>	
	<!-- ============================================================================================================ -->
  <!-- Assert that Maintenance Information has required mandatory descendent elements  -->
	<!-- ============================================================================================================ -->
  <sch:diagnostics>
	 	<sch:diagnostic id="rule.ga.mmi.resourcemaintenancecodelistpresent-failure-en" xml:lang="en">resourceMaintenance/ maintenanceAndUpdateFrequency/ MD_MaintenanceFrequencyCode not present or missing code list values.</sch:diagnostic>
	 	<sch:diagnostic id="rule.ga.mmi.resourcemaintenancecodelistpresent-success-en" xml:lang="en">resourceMaintenance/ maintenanceAndUpdateFrequency/ MD_MaintenanceFrequencyCode is present.</sch:diagnostic>
  </sch:diagnostics>
  <sch:pattern rule="rule.ga.mmi.resourcemaintenancecodelist">
		<sch:title>Maintenance Information has required/mandatory descendent elements.</sch:title>
		<sch:rule context="//mmi:maintenanceAndUpdateFrequency[ancestor::mri:resourceMaintenance]">
			<sch:assert test="normalize-space(mmi:MD_MaintenanceFrequencyCode/@codeList) and normalize-space(mmi:MD_MaintenanceFrequencyCode/@codeListValue)" diagnostics="rule.ga.mmi.resourcemaintenancecodelistpresent-failure-en"/>
			<sch:report test="normalize-space(mmi:MD_MaintenanceFrequencyCode/@codeList) and normalize-space(mmi:MD_MaintenanceFrequencyCode/@codeListValue)" diagnostics="rule.ga.mmi.resourcemaintenancecodelistpresent-success-en"/>
		</sch:rule>
	</sch:pattern>
	<!-- ============================================================================================================ -->
	<!-- Assert that Distribution Information has required mandatory descendent elements   -->
	<!-- ============================================================================================================ -->
  <sch:diagnostics>
	 	<sch:diagnostic id="rule.ga.mrd.distributionformatpresent-failure-en" xml:lang="en">distributionInfo/ MD_Distribution/ distributionFormat/ MD_Format not present.</sch:diagnostic>
	 	<sch:diagnostic id="rule.ga.mrd.distributionformatpresent-success-en" xml:lang="en">distributionInfo/ MD_Distribution/ distributionFormat/ MD_Format is present.</sch:diagnostic>
	 	<sch:diagnostic id="rule.ga.mrd.distributionformatnamepresent-failure-en" xml:lang="en">distributionFormat/ MD_Format/ formatSpecificationCitation/ */ title (format name) not present or empty.</sch:diagnostic>
	 	<sch:diagnostic id="rule.ga.mrd.distributionformatnamepresent-success-en" xml:lang="en">distributionFormat/ MD_Format/ formatSpecificationCitation/ */ title (format name) is present.</sch:diagnostic>
	 	<sch:diagnostic id="rule.ga.mrd.distributionformatversionpresent-failure-en" xml:lang="en">distributionFormat/ MD_Format/ formatSpecificationCitation/ */ edition (format version) not present or empty.</sch:diagnostic>
	 	<sch:diagnostic id="rule.ga.mrd.distributionformatversionpresent-success-en" xml:lang="en">distributionFormat/ MD_Format/ formatSpecificationCitation/ */ edition (format version) is present.</sch:diagnostic>
  </sch:diagnostics>
	<sch:pattern rule="ga.rule.mrd.distribution">
		<sch:title>Distribution Information has required/mandatory descendent elements.</sch:title>
		<sch:rule context="//mrd:MD_Distribution[parent::mdb:distributionInfo]">
			<sch:assert test="mrd:distributionFormat/mrd:MD_Format" diagnostic="rule.ga.mrd.distributionformatpresent-failure-en"/>
			<sch:report test="mrd:distributionFormat/mrd:MD_Format" diagnostic="rule.ga.mrd.distributionformatpresent-success-en"/>
		</sch:rule>
    <sch:rule context="//mrd:MD_Format[parent::mrd:distributionFormat]">
			<sch:assert test="normalize-space(mrd:formatSpecificationCitation/cit:CI_Citation/cit:title/gco:CharacterString)" diagnostics="rule.ga.mrd.distributionformatnamepresent-failure-en"/>
			<sch:report test="normalize-space(mrd:formatSpecificationCitation/cit:CI_Citation/cit:title/gco:CharacterString)" diagnostics="rule.ga.mrd.distributionformatnamepresent-success-en"/>
			<sch:assert test="normalize-space(mrd:formatSpecificationCitation/cit:CI_Citation/cit:edition/gco:CharacterString)" diagnostics="rule.ga.mrd.distributionformatversionpresent-failure-en"/>
			<sch:report test="normalize-space(mrd:formatSpecificationCitation/cit:CI_Citation/cit:edition/gco:CharacterString)" diagnostics="rule.ga.mrd.distributionformatversionpresent-success-en"/>
		</sch:rule>
	</sch:pattern>
</sch:schema>
