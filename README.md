# ISO19115-profile


## Description
[This repository](https://github.com/GeoscienceAustralia/ISO19115-profile) contains the files used to describe and generate Geoscience Australia's profile of the [ISO19115-1:2014 'Geographic information -- Metadata'](https://www.iso.org/standard/53798.html) standard.  This is the development area for the GA profile - the production release is deployed to GA's Schemas Register at http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016.  The formal definition of the GA profile is available at http://pid.geoscience.gov.au/dataset/ga/122551.

This profile extends the base ISO19115-1:2014 standard in accordance with Annex C "Metadata extensions and profiles" of the [ISO19115-1:2014 'Geographic information -- Metadata'](https://www.iso.org/standard/53798.html) documentation.  Our profile is used to ensure that some elements of the standard which are normally optional are compulsory so that those elements, such as dataset lineage, are always filled out by GA staff recording metadata for datasets. Our profile also implements several new type codes for things such as AssociationType which allow us to characterise relationships between objects described with this profile in ways not possible with the un-profiled standard. These include type codes such as 'derivedFrom' which indicated that a dataset is generally derived from another dataset. This is more general than the standard's own 'revisionOf' which implies that the revised dataset is substantially the same as the original.

Some elements of this profile allow us to relate elements modelled here to other models. For example, the 'derivedFrom' relationship mentioned above can be interpreted as a 'wasDerivedFrom' relationship as used in the [PROV ontology](https://www.w3.org/TR/prov-o/) for provenance.

### Profile Extensions
Following are the ISO 19115-1:2014 elements that have been extended by the GA profile.

##### Metadata entity set information (MD_Metadata)

| Name | Definition | Change from ISO 19115-1 |
| --- | --- | --- |
| metadataIdentifier | unique identifier for this metadata record | Optional -> Mandatory |
| parentMetadata | identification of the parent metadata record |  Conditional -> Conditional (changed condition) |
| referenceSystemInfo | description of the spatial and temporal reference systems used in the resource | Optional -> Conditional |
| metadataConstraints | restrictions on the access and use of metadata | Optional -> Mandatory |
| resourceLineage | information about the provenance, source(s), and/or the production process(es) applied to the resource | Optional -> Mandatory |

##### Identification information (MD_Identification)
| Name | Definition | Change from ISO 19115-1 |
| --- | --- | --- |
| (CI_Citation) identifier | value uniquely identifying an object within a namespace | Optional -> Mandatory |
| pointOfContact | identification of, and means of communication with, person(s) and organization(s) associated with the resource(s) | Optional -> Mandatory |
| topicCategory | main theme(s) of the resource | Conditional -> Mandatory |
| resourceMaintenance | information about the frequency of resource updates, and the scope of those updates | Optional -> Mandatory |
| resourceFormat | a description of the format of the resource(s) | Optional -> Mandatory |
| resourceConstraints | information about constraints which apply to the resource(s) | Optional -> Mandatory |
| descriptiveKeywords | category keywords, their type, and reference source | Optional -> Mandatory |

##### Constraint information (MD_Constraints)
| Name | Definition | Change from ISO 19115-1 |
| --- | --- | --- |
| reference | citation for the limitation or constraint, example: Copyright statement, licence agreement, etc. | Optional -> Mandatory |
| (MD_LegalConstraints) accessConstraints | access constraints applied to assure the protection of privacy or intellectual property, and any special restrictions or limitations on obtaining the resource or metadata | Conditional -> Conditional (changed condition) |
| (MD_LegalConstraints) useConstraints | constraints applied to assure the protection of privacy or intellectual property, and any special restrictions or limitations or warnings on using the resource or metadata | Conditional -> Conditional (changed condition) |

##### Lineage information (LI_Lineage)
| Name | Definition | Change from ISO 19115-1 |
| --- | --- | --- |
| statement | general explanation of the data producer’s knowledge about the lineage of a dataset | Optional -> Mandatory |

##### Distribution information (MD_Distribution)
| Name | Definition | Change from ISO 19115-1 |
| --- | --- | --- |
| distributionFormat | provides a description of the format of the data to be distributed | Optional -> Mandatory |

#### Codelists
This profile extends two ISO 19115-1 codelists:
* **Association Type (DS_AssociationTypeCode)**
* **Online Function (CI_OnLineFunctionCode)**

##### The codeList attribute on ISO 19115-3 element instances of the above ISO 19115-1 codelists points to the GA Profile extended codelist:
| ISO 19115-3 codelist element | GA Profile extended codelist |
| --- | --- |
| mri:DS_AssociationTypeCode | http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/ga_profile_codelists.xml#gapDS_AssociationTypeCode |
| cit:CI_OnLineFunctionCode | http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/ga_profile_codelists.xml#gapCI_OnLineFunctionCode |

ISO 19115-3 element text values, and values provided in the element's codeListValue attribute, must conform to the identifiers in the GA Profile extended codelist.


Two new codelists have been implemented by this profile to constrain the following ISO 19115-1 metadata elements:
* **Service Type (serviceType)**
* **Protocol (protocol)**

The srv:serviceType/gco:ScopedName element in ISO 19115-3 instance documents must include the codeScope attribute indicating the GA Profile gapSV_ServiceTypeCode codelist.  Text values for the element must conform to the identifiers in the gapSV_ServiceTypeCode codelist. For Example:
``` xml
  <srv:serviceType>
    <gco:ScopedName codeSpace="http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/ga_profile_codelists.xml#gapSV_ServiceTypeCode">OGC:WMS</gco:ScopedName>
  </srv:serviceType>
```

The cit:protocol/gco:CharacterString element in ISO 19115-3 instance documents must be soft-typed to the gco:CodeType type so that the codeSpace attribute can be included.  The codeScope attribute must then be set to indicate the GA Profile gapCI_ProtocolTypeCode codelist, and text values for the element must conform to the identifiers in the gapCI_ProtocolTypeCode codelist.  For Example:
``` xml
  <cit:protocol>
   <gco:CharacterString xsi:type="gco:CodeType" codeSpace="http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016/codelist/ga_profile_codelists.xml#gapCI_ProtocolTypeCode">OGC:WMS</gco:CharacterString>
  </cit:protocol>
```

The authoritative values in the above codelists are maintained in [SKOS vocabularies](https://www.w3.org/2004/02/skos/) hosted by [Research Vocabularies Australia](https://vocabs.ands.org.au/).  The codelists are extracted from the vocabularies and written to an XML codelist catalog file conforming to the ISO 19115-3 CAT 1.0 schema.  The resulting codelist catalog, as well as the scripts used to generate the codelists are stored in the [codelist/](codelist/) folder.


### Schema

Schematron schema have been developed to validate the extensions defined by the GA profile.
##### Schematron schema
| Name | Purpose |
| --- | --- |
| schematron-rules-ga.sch | validation of constraints imposed on ISO 19115-1 elements by the GA profile |
| schematron-rules-ga_codelists.sch | validation of codelist values for elements that have new or extended codelists imposed by the GA profile |
| schematron-rules-all_codelists.sch | validation of codelist values for all elements that are constrained by a codelist (ISO 19115-1 or a profile extension) |

The Schematron schema files are stored in the root directory of [This code repository](https://github.com/GeoscienceAustralia/ISO19115-profile).



## License
[This repository](https://github.com/GeoscienceAustralia/ISO19115-profile) is licensed under Creative Commons 4.0 International. See the [LICENSE deed](LICENSE) in this repository for details.


## Contacts
**Aaron Sedgmen**  
Geoscience Australia  
<aaron.sedgmen@ga.gov.au>
