# ISO19115-profile


## Description
This repository contains the files used to describe and generate Geoscience Australia's profile of the [ISO19115-1:2014 'Geographic information -- Metadata'](https://www.iso.org/standard/53798.html) standard.

This profile extends the base ISO19115-1:2014 standard in accordance with Annex C "Metadata extensions and profiles" of the [ISO19115-1:2014 'Geographic information -- Metadata'](https://www.iso.org/standard/53798.html) documentation.  Our profile is used to ensure that some elements of the standard which are normally optional are compulsory so that those elements, such as dataset lineage, are always filled out by GA staff recording metadata for datasets. Our profile also implements several new type codes for things such as AssociationType which allow us to characterise relationships between objects described with this profile in ways not possible with the un-profiled standard. These include type codes such as 'derivedFrom' which indicated that a dataset is generally derived from another dataset. This is more general than the standard's own 'revisionOf' which implies that the revised dataset is substantially the same as the original.

Some elements of this profile allow us to relate elements modelled here to other models. For example, the 'derivedFrom' relationship mentioned above can be interpreted as a 'wasDerivedFrom' relationship as used in the [PROV ontology](https://www.w3.org/TR/prov-o/) for provenance.

### Profile Extensions
##### Metadata entity set information (MD_Metadata)

| Name        | Definition          | Change from ISO 19115-1  |
| ------------- |-------------| -----|
| metadataIdentifier | unique identifier for this metadata record | Optional -> Mandatory |
| parentMetadata | identification of the parent metadata record |  Conditional -> Conditional (changed condition) |
| referenceSystemInfo | description of the spatial and temporal reference systems used in the resource | Optional -> Conditional |


### Schema

Additional Schematron schema and XML Schema have been developed by GA to implement the rules defining the GA profile.  This profile's Schematron schema and XML Schema files are stored in this code repository.

The main differences between the GA profile and the main ISO19115-1 standard are that in this profile:

* the **Lineage** field (`LI_Lineage`), describing the provenance of records, is mandatory, rather than optional
* the **Constraints** field (`MD_Constraints`), describing the licencing arrangements and security classification, is mandatory, rather than optional
* the **Maintenance** field (`MD_MaintenanceInformation`), describing the frequency of updates to the resource, is mandatory, rather than optional
* the **Format** field (`MD_Format`), describing formats for storage and distribution of the resource, is mandatory, rather than optional 
* the **Extents** field (`EX_Extent`), describing the temporal, horizontal and vertical extents of the resource, is mandatory, rather than optional
* the **Location of the data/product** field ()
* the **Association Types** field (`DS_AssociationTypeCode`), linking records to other records, uses values from an extended codelist stored in the [codelist/](codelist/) folder of this repository
* the **Function** field (`CI_OnLineFunctionCode`), describing the function performed by the online resource, uses values from an extended codelist stored in the [codelist/](codelist/) folder of this repository
* the **Service Type** field (`serviceType`), describing the service type, uses values from a new codelist stored in the [codelist/](codelist/), rather than allowing free text
* the **Protocol** field (`protocol`), describing the online resource protocol, uses values from a new codelist stored in the [codelist/](codelist/), rather than allowing free text


### Codelists

This profile extends two codelists from the ISO19115-1 standard; Association Type and Online Function, and implements two new codelists to constrain two elements that are free text datatypes in the ISO 19115-1 standard; Service Type and Protocol. The codelists are derived from authoritative [SKOS vocabularies](https://www.w3.org/2004/02/skos/) hosted by [Research Vocabularies Australia](https://vocabs.ands.org.au/) and stored here in the [codelist/](codelist/) folder as XML files conforming to the CAT 1.0 schema. The scripts used to generate the XML codelists from the vocabularies are also stored in the [codelist/](codelist/) folder.


## License
This repository is licensed under Creative Commons 4.0 International. See the [LICENSE deed](LICENSE) in this repository for details.


## Contacts
**Aaron Sedgmen**  
Geoscience Australia  
<aaron.sedgmen@ga.gov.au>
