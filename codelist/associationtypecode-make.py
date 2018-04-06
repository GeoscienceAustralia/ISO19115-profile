"""
Routine to retrieve content from the Association Type SKOS vocabulary, convert to
the ISO 19115-1:2014 codelist XML format, and write to the file system.

Note the DS_AssociationTypeCode codelist is located in the ISO19115-3 file structure at
iso19115-3/schema/standards.iso.org/iso/19115/-3/mri/1.0/codelists.xml.

Created on 24 October 2017

Updated 28 February 2018, A.Sedgmen
    - Added command line argument handling

Updated 21 March 2018, A.Sedgmen
    - Addded HTML codelist output

@author: Aaron Sedgmen
"""

from SPARQLWrapper import SPARQLWrapper
import os
import sys
import logging
import lxml.etree as ET
import argparse
from bs4 import BeautifulSoup

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

def get_associationTypes(vocab_sparql_endpoint):
    """
    Query the Association Type SKOS vocabulary SPARQL endpoint to obtain Association Type names and definitions
    
    :param Vocabulary SPARQL endpoint
    :return: returns SPARQL Query Results XML document as a string
    """
    
    queryString = '''
        PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
        PREFIX perl: <http://purl.org/dc/terms/>
        SELECT ?associationType ?source ?definition
        WHERE
        {
            ?associationType a skos:Concept .
            OPTIONAL {?associationType perl:source ?source} .
            ?associationType skos:definition ?definition .
        }
        ORDER BY DESC(?source) ?associationType
    '''
    
    sparql = SPARQLWrapper(vocab_sparql_endpoint)
    sparql.setQuery(queryString)
    sparql.setReturnFormat('xml')
    ret = sparql.query()
    associationTypes_sparql_xml_string = ret.convert().toxml()
    
    logger.debug(associationTypes_sparql_xml_string)
    
    return associationTypes_sparql_xml_string

def transform_to_xml_codelist(associationTypes_sparql_xml_string):
    """
    Transform the input SPARQL Query Results XML document into an ISO 19115-1 codelist XML document
    
    :param associationTypes_sparql_xml_string: SPARQL Query Results XML document as a string
    :return: returns ISO 19115-1 codelist XML document as a string
    """

    associationTypes_sparql_xml_et = ET.fromstring(associationTypes_sparql_xml_string)
    xslt = ET.parse("xslt/assoctypecode_skos_to_xml_codelist.xsl")
    transform = ET.XSLT(xslt)
    associationTypes_iso_codelist_et = transform(associationTypes_sparql_xml_et)
    
    logger.debug(ET.tostring(associationTypes_iso_codelist_et, pretty_print=True))
    
    return ET.tostring(associationTypes_iso_codelist_et, pretty_print=True)

def transform_to_html_codelist(associationTypes_sparql_xml_string):
    """
    Transform the input SPARQL Query Results XML document into an ISO 19115-1 codelist HTML document
    
    :param associationTypes_sparql_xml_string: SPARQL Query Results XML document as a string
    :return: returns ISO 19115-1 codelist HTML document as a string
    """

    associationTypes_sparql_xml_et = ET.fromstring(associationTypes_sparql_xml_string)
    xslt = ET.parse("xslt/assoctypecode_skos_to_html_codelist.xsl")
    transform = ET.XSLT(xslt)
    associationTypes_iso_codelist_et = transform(associationTypes_sparql_xml_et)
    
    soup=BeautifulSoup(ET.tostring(associationTypes_iso_codelist_et), 'html.parser')
    prettyHTML=soup.prettify()
    
    logger.debug(prettyHTML)
    
    return prettyHTML

def main():
    '''
    Main function
    '''
    def get_args():
        """
        Handles all the arguments that are passed into the script

        :return: Returns a parsed version of the arguments.
        """
        parser = argparse.ArgumentParser(
            description='Retrieves content from the Association Type SKOS vocabulary, converts it to the ISO 19115-1:2014 codelist XML format, and writes it to the file system.')
        parser.add_argument("-v", "--vSPARQL",
                            help="Vocabulary SPARL endpoint (default is http://vocabs.ands.org.au/repository/api/sparql/ga_association-type_v1-1)",
                            dest="vocab_sparql_endpoint",
                            default="http://vocabs.ands.org.au/repository/api/sparql/ga_association-type_v1-1")
        parser.add_argument("-o", "--outputDir",
                            help="Output directory for generated ISO 19115-1:2014 codelist XML file (default is current working directory)",
                            dest="outputDir",
                            default=os.getcwd())
        parser.add_argument("-l", "--loggingLevel",
                            help="Logging level (ERROR, WARNING, INFO, DEBUG)",
                            dest="logging_level",
                            default="INFO")
        parser.add_argument("-p", "--proxy",
                            help="Proxy server and port for HTTP and HTTPS requests, e.g. proxy.net.au:8080",
                            dest="proxy",
                            default=None)
        parser.add_argument("-n", "--noProxy",
                            help="Domains not to be accessed by a proxy (comma delimited list)",
                            dest="noProxy",
                            default="services.ga.gov.au, intranet.ga.gov.au, intranet-test.ga.gov.au, np.ga.gov.au, www.ga.gov.au")
        return parser.parse_args()

    args = get_args()
    
    # Set logging level    
    logger.setLevel(args.logging_level)
    
    # Set proxy if provided
    if args.proxy != None:
        os.environ["HTTP_PROXY"] = "http://{}".format(args.proxy)
        os.environ["HTTPS_PROXY"] = "https://{}".format(args.proxy)
        os.environ["no_proxy"] = args.noProxy
        
    # Obtain the set of association types from the SKOS association-type vocabulary in the SPARQL Query Results XML Format
    associationTypes_sparql_xml_string = get_associationTypes(args.vocab_sparql_endpoint)
    logger.debug(associationTypes_sparql_xml_string)
    
    # Transform SPARQL Query Results XML to ISO 19115-1 codelist XML
    associationTypes_iso_codelist_xml_string = transform_to_xml_codelist(associationTypes_sparql_xml_string)

    # Transform SPARQL Query Results XML to ISO 19115-1 codelist HTML
    associationTypes_iso_codelist_html_string = transform_to_html_codelist(associationTypes_sparql_xml_string)
    
    # Write ISO 19115-1 codelist
    with open(os.path.join(args.outputDir, "assocTypeCode_codelist.xml"), "w") as text_file:
        text_file.write(associationTypes_iso_codelist_xml_string)
    logger.info("Output written to {}".format(os.path.join(args.outputDir, text_file.name)))
    with open(os.path.join(args.outputDir, "assocTypeCode_codelist.html"), "w") as text_file:
        text_file.write(associationTypes_iso_codelist_html_string)
    logger.info("Output written to {}".format(os.path.join(args.outputDir, text_file.name)))
    
if __name__ == "__main__":
    main()