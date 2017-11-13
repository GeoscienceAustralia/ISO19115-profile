"""
Routine to retrieve content from the Protocol Type SKOS vocabulary, convert to
the ISO 19115-1:2014 codelist XML format, and write to the file system.

Created on 13 November 2017

@author: Vaughan Edgell
"""

from SPARQLWrapper import SPARQLWrapper
import jinja2
import os
import sys
import logging
import lxml.etree as ET

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

vocab_sparql_endpoint = "http://vocabs.ands.org.au/repository/api/sparql/ga_protocol-type_v1-0"


def get_protocol_types():
    """
    Query the Protocol Type SKOS vocabulary SPARQL endpoint to obtain Protocol Type names and definitions

    :return: returns SPARQL Query Results XML document as a string
    """

    query_string = """
        PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
        SELECT ?protocolType ?definition
        WHERE
        {
            ?protocolType a skos:Concept.
            ?protocolType skos:definition ?definition.
        }
    """

    sparql = SPARQLWrapper(vocab_sparql_endpoint)
    sparql.setQuery(query_string)
    sparql.setReturnFormat('xml')
    ret = sparql.query()
    protocol_types_sparql_xml_string = ret.convert().toxml()

    logger.debug(protocol_types_sparql_xml_string)

    return protocol_types_sparql_xml_string


def transform_to_codelist(protocol_types_sparql_xml_string):
    """
    Transform the input SPARQL Query Results XML document into an ISO 19115-1 codelist XML document

    :param protocol_types_sparql_xml_string: SPARQL Query Results XML document as a string
    :return: returns ISO 19115-1 codelist XML document as a string
    """

    protocol_types_sparql_xml_et = ET.fromstring(protocol_types_sparql_xml_string)
    xslt = ET.parse("xslt/protocoltype_skos_to_codelist.xsl")
    transform = ET.XSLT(xslt)
    protocol_types_iso_codelist_et = transform(protocol_types_sparql_xml_et)

    logger.debug(ET.tostring(protocol_types_iso_codelist_et, pretty_print=True))

    return ET.tostring(protocol_types_iso_codelist_et, pretty_print=True)


def main():
    """
    Main function
    """

    # Obtain the set of protocol types from the SKOS protocol-type vocabulary in the SPARQL Query Results XML Format
    protocol_types_sparql_xml_string = get_protocol_types()
    # Transform SPARQL Query Results XML to ISO 19115-1 codelist XML
    protocol_types_iso_codelist_xml_string = transform_to_codelist(protocol_types_sparql_xml_string)

    # Write ISO 19115-1 codelist to current directory
    with open("protocolType_codelist.xml", "w") as text_file:
        text_file.write(protocol_types_iso_codelist_xml_string)

    logger.info("Output written to {}".format(os.path.join(os.getcwd(), text_file.name)))


if __name__ == "__main__":
    main()