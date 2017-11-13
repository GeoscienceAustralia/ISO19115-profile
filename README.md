# ISO19115-profile


## Description
This repository contains the files used to describe and generate Geoscience Australia's profile of the [ISO19115-1:2014 'Geographic information -- Metadata'](https://www.iso.org/standard/53798.html) standard.

This profile is used to ensure that some elements of the standard which are normally optional are compulsory so that those elements, such as dataset lineage, are always filled out by GA staff recording metadata for datasets. Our profile also implements several new type codes for things such as AssociationType which allow us to characterise relationships between objects described with this profile in ways not possible with the un-profiled standard. These include type codes such as 'derivedFrom' which indicated that a sataset is generally derived from another dataset. This is more general than the standard's own 'revisionOf' whihc implies that the revised dataset is substantially the same as the original. 

Some elements of this profile allow us to relate elements modelled here to other models. For example, the 'derivedFrom' relationship mentioned above can be interpreted as a 'wasDerivedFrom' relationship as used in the [PROV ontology](https://www.w3.org/TR/prov-o/) for provenance.

### Schema

This profile's schema file is stored in this code repository. The main differences between this schema and the main ISO19115-1's are that in this profile:

* the **Lineage** field (`LI_Lineage`), describing the provenance of records, is compulsory, rather than optional
* the **Association Types** (`DS_AssociationTypeCode`), linking records to other records, uses values from an extended codelist stored in the [codelists/](codelists/) folder of this repository
* the **Protocol** field (++++) uses values from a codelist, rather than allowing free text
* the **Service Type** field (++++) uses values from a codelist, rather than allowing free text


### Codelists

This profile extends one codelist from the ISO19115-1 standard, Association Type, and implements two other codelists in place of two of the standard's free text fields: Web Service type and Protocol. The codelists are generated from [SKOS vocabularies](https://www.w3.org/2004/02/skos/) that contain the codelist terms and stored here in the [codelists/](codelists/) folder as XML files. The scripts used to generate the codelists are also stored in the folder.


## License
This repository is licensed under Creative Commons 4.0 International. See the [LICENSE deed](LICENSE) in this repository for details.


## Contacts
**Nicholas Car**  
*Data Architect*  
Geoscience Australia  
<nicholas.car@ga.gov.au>  
<http://orcid.org/0000-0002-8742-7730>