"""
Routine to retrieve content from the Service Type SKOS vocabulary, convert to
the ISO 19115-1:2014 codelist XML format, and write to the file system.

Created on 8 November 2017

Updated 1 March 2018, A.Sedgmen
    - Added command line argument handling

Updated 21 March 2018, A.Sedgmen
    - Revised SPARQL query to retrieve altLabel values
    - Addded HTML codelist output
    
@author: Vaughan Edgell
"""

from SPARQLWrapper import SPARQLWrapper
import os
import sys
import logging
import lxml.etree as ET
import argparse
from bs4 import BeautifulSoup

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

def get_service_types(vocab_sparql_endpoint):
    """
    Query the Service Type SKOS vocabulary SPARQL endpoint to obtain Service Type names and definitions

    :return: returns SPARQL Query Results XML document as a string
    """

    query_string = """
        PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
        PREFIX perl: <http://purl.org/dc/terms/>
        SELECT ?altLabel ?source ?definition
        WHERE
        {
            ?serviceType a skos:Concept ;
                          skos:altLabel ?altLabel .
            OPTIONAL {?serviceType perl:source ?source} .
            OPTIONAL {?serviceType skos:definition ?definition} .
        }
    """

    sparql = SPARQLWrapper(vocab_sparql_endpoint)
    sparql.setQuery(query_string)
    sparql.setReturnFormat('xml')
    ret = sparql.query()
    service_types_sparql_xml_string = ret.convert().toxml()

    logger.debug(service_types_sparql_xml_string)

    return service_types_sparql_xml_string


def transform_to_xml_codelist(service_types_sparql_xml_string):
    """
    Transform the input SPARQL Query Results XML document into an ISO 19115-1 codelist XML document

    :param service_types_sparql_xml_string: SPARQL Query Results XML document as a string
    :return: returns ISO 19115-1 codelist XML document as a string
    """

    service_types_sparql_xml_et = ET.fromstring(service_types_sparql_xml_string)
    xslt = ET.parse("xslt/servicetypecode_skos_to_xml_codelist.xsl")
    transform = ET.XSLT(xslt)
    service_types_iso_codelist_et = transform(service_types_sparql_xml_et)

    logger.debug(ET.tostring(service_types_iso_codelist_et, pretty_print=True))

    return ET.tostring(service_types_iso_codelist_et, pretty_print=True)

def transform_to_html_codelist(service_types_sparql_xml_string):
    """
    Transform the input SPARQL Query Results XML document into an ISO 19115-1 codelist HTML document

    :param service_types_sparql_xml_string: SPARQL Query Results XML document as a string
    :return: returns ISO 19115-1 codelist XML document as a string
    """

    service_types_sparql_xml_et = ET.fromstring(service_types_sparql_xml_string)
    xslt = ET.parse("xslt/servicetypecode_skos_to_html_codelist.xsl")
    transform = ET.XSLT(xslt)
    service_types_iso_codelist_et = transform(service_types_sparql_xml_et)

    soup=BeautifulSoup(ET.tostring(service_types_iso_codelist_et), 'html.parser')
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
            description='Retrieves content from the Service Type SKOS vocabulary, converts it to the ISO 19115-1:2014 codelist XML format, and writes it to the file system.')
        parser.add_argument("-v", "--vSPARQL",
                            help="Vocabulary SPARQL endpoint (default is http://vocabs.ands.org.au/repository/api/sparql/ga_service-type_v1-1)",
                            dest="vocab_sparql_endpoint",
                            default="http://vocabs.ands.org.au/repository/api/sparql/ga_service-type_v1-1")
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
        
    # Obtain the set of service types from the SKOS service-type vocabulary in the SPARQL Query Results XML Format
    service_types_sparql_xml_string = get_service_types(args.vocab_sparql_endpoint)
    logger.debug(service_types_sparql_xml_string)
    
    # Transform SPARQL Query Results XML to ISO 19115-1 codelist XML
    service_types_iso_codelist_xml_string = transform_to_xml_codelist(service_types_sparql_xml_string)

    # Transform SPARQL Query Results XML to ISO 19115-1 codelist HTML
    service_types_iso_codelist_html_string = transform_to_html_codelist(service_types_sparql_xml_string)

    # Write ISO 19115-1 codelist to current directory
    with open("serviceTypeCode_codelist.xml", "w") as text_file:
        text_file.write(service_types_iso_codelist_xml_string)
    logger.info("Output written to {}".format(os.path.join(os.getcwd(), text_file.name)))
    with open("serviceTypeCode_codelist.html", "w") as text_file:
        text_file.write(service_types_iso_codelist_html_string)
    logger.info("Output written to {}".format(os.path.join(os.getcwd(), text_file.name)))


if __name__ == "__main__":
    main()