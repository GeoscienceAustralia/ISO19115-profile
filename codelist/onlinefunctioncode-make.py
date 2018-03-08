"""
Routine to retrieve content from the OnLine Function Code SKOS vocabulary, convert to
the ISO 19115-1:2014 codelist XML format, and write to the file system.

Note the CI_OnLineFunctionCode codelist is located in the ISO19115-3 file structure at
http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml.

Created on 31 October 2017

Updated 28 February 2018, A.Sedgmen
    - Added command line argument handling

@author: Vaughan Edgell
"""

from SPARQLWrapper import SPARQLWrapper
import os
import sys
import logging
import lxml.etree as ET
import argparse

# Set handler for root logger to standard output if no handler exists
if not logging.root.handlers:
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setLevel(logging.DEBUG)
    console_formatter = logging.Formatter('%(message)s')
    console_handler.setFormatter(console_formatter)
    logging.root.addHandler(console_handler)

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)  # Initial logging level for this module

def get_online_function_codes(vocab_sparql_endpoint):
    """
    Query the OnLine Function Code SKOS vocabulary SPARQL endpoint to obtain OnLine Function Code names and definitions

    :return: returns SPARQL Query Results XML document as a string
    """

    query_string = """
        PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
        SELECT ?onlineFunctionCode ?definition
        WHERE
        {
            ?onlineFunctionCode a skos:Concept.
            ?onlineFunctionCode skos:definition ?definition.
        }
    """

    sparql = SPARQLWrapper(vocab_sparql_endpoint)
    sparql.setQuery(query_string)
    sparql.setReturnFormat('xml')
    ret = sparql.query()
    online_function_codes_sparql_xml_string = ret.convert().toxml()

    logger.debug(online_function_codes_sparql_xml_string)

    return online_function_codes_sparql_xml_string


def transform_to_codelist(online_function_codes_sparql_xml_string):
    """
    Transform the input SPARQL Query Results XML document into an ISO 19115-1 codelist XML document

    :param online_function_codes_sparql_xml_string: SPARQL Query Results XML document as a string
    :return: returns ISO 19115-1 codelist XML document as a string
    """

    online_function_codes_sparql_xml_et = ET.fromstring(online_function_codes_sparql_xml_string)
    xslt = ET.parse("xslt/onlinefunctioncode_skos_to_codelist.xsl")
    transform = ET.XSLT(xslt)
    online_function_codes_iso_codelist_et = transform(online_function_codes_sparql_xml_et)

    logger.debug(ET.tostring(online_function_codes_iso_codelist_et, pretty_print=True))

    return ET.tostring(online_function_codes_iso_codelist_et, pretty_print=True)


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
            description='Retrieves content from the Online Function Code SKOS vocabulary, converts it to the ISO 19115-1:2014 codelist XML format, and writes it to the file system.')
        parser.add_argument("-v", "--vSPARQL",
                            help="Vocabulary SPARL endpoint (default is http://vocabs.ands.org.au/repository/api/sparql/ga_online-function-code_v1-0)",
                            dest="vocab_sparql_endpoint",
                            default="http://vocabs.ands.org.au/repository/api/sparql/ga_online-function_v1-0")
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
        
    # Obtain the set of online function codes from the SKOS online-function-code vocabulary in the SPARQL Query Results XML Format
    online_function_codes_sparql_xml_string = get_online_function_codes(args.vocab_sparql_endpoint)
    # Transform SPARQL Query Results XML to ISO 19115-1 codelist XML
    online_function_codes_iso_codelist_xml_string = transform_to_codelist(online_function_codes_sparql_xml_string)

    # Write ISO 19115-1 codelist to current directory
    with open("onlineFunctionCode_codelist.xml", "w") as text_file:
        text_file.write(online_function_codes_iso_codelist_xml_string)

    logger.info("Output written to {}".format(os.path.join(args.outputDir, text_file.name)))


if __name__ == "__main__":
    main()