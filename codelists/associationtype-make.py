"""
Routine to retrieve content from the Association Type SKOS vocabulary, convert to
the ISO 19115-1:2014 codelist XML format, and write to the file system.

Note the DS_AssociationTypeCode codelist is located in the ISO19115-3 file structure at
iso19115-3/schema/standards.iso.org/iso/19115/-3/mri/1.0/codelists.xml.

Created on 24 October 2017

@author: Aaron Sedgmen
"""

from SPARQLWrapper import SPARQLWrapper
import jinja2
import os
import sys
import logging
import lxml.etree as ET


# DS_AssociationTypeCode codelist is located in the ISO19115-3 file structure at iso19115-3/schema/standards.iso.org/iso/19115/-3/mri/1.0/codelists.xml

os.environ["HTTP_PROXY"] = "http://sun-web-intdev.ga.gov.au:2710"
os.environ["HTTPS_PROXY"] = "https://sun-web-intdev.ga.gov.au:2710"
os.environ["no_proxy"] = "localhost, services.ga.gov.au, intranet.ga.gov.au, np.ga.gov.au, www.ga.gov.au"

# Set handler for root logger to standard output if no handler exists
if not logging.root.handlers:
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setLevel(logging.DEBUG)
    console_formatter = logging.Formatter('%(message)s')
    console_handler.setFormatter(console_formatter)
    logging.root.addHandler(console_handler)

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)  # Initial logging level for this module

vocab_sparql_endpoint = "http://vocabs.ands.org.au/repository/api/sparql/ga_association-type_v1-0"

def get_associationTypes():
    """
    Query the Association Type SKOS vocabulary SPARQL endpoint to obtain Association Type names and definitions
    
    :return: returns SPARQL Query Results XML document as a string
    """
    
    queryString = '''
        PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
        SELECT ?associationType ?definition
        WHERE
        {
            ?associationType a skos:Concept .
            ?associationType skos:definition ?definition .
        }
    '''
    
    sparql = SPARQLWrapper(vocab_sparql_endpoint)
    sparql.setQuery(queryString)
    sparql.setReturnFormat('xml')
    ret = sparql.query()
    associationTypes_sparql_xml_string = ret.convert().toxml()
    
    logger.debug(associationTypes_sparql_xml_string)
    
    return associationTypes_sparql_xml_string

def transform_to_codelist(associationTypes_sparql_xml_string):
    """
    Transform the input SPARQL Query Results XML document into an ISO 19115-1 codelist XML document
    
    :param associationTypes_sparql_xml_string: SPARQL Query Results XML document as a string
    :return: returns ISO 19115-1 codelist XML document as a string
    """

    associationTypes_sparql_xml_et = ET.fromstring(associationTypes_sparql_xml_string)
    xslt = ET.parse("xslt/assoctype_skos_to_codelist.xsl")
    transform = ET .XSLT(xslt)
    associationTypes_iso_codelist_et = transform(associationTypes_sparql_xml_et)
    
    logger.debug(ET.tostring(associationTypes_iso_codelist_et, pretty_print=True))
    
    return ET.tostring(associationTypes_iso_codelist_et, pretty_print=True)

def main():
    '''
    Main function
    '''
    
    # Obtain the set of association types from the SKOS association-type vocabulary in the SPARQL Query Results XML Format
    associationTypes_sparql_xml_string = get_associationTypes()
    
    # Transform SPARQL Query Results XML to ISO 19115-1 codelist XML
    associationTypes_iso_codelist_xml_string = transform_to_codelist(associationTypes_sparql_xml_string)
    
    # Write ISO 19115-1 codelist to current directory
    with open("assocType_codelist.xml", "w") as text_file:
        text_file.write(associationTypes_iso_codelist_xml_string)
    
    logger.info("Output written to {}".format(os.path.join(os.getcwd(), text_file.name)))

if __name__ == "__main__":
    main()