"""
Routine to retrieve ISO 19115-1:2014 GA Profile content from SKOS vocabularies, convert to
the ISO 19115-1:2014 CAT 1.0 XML format, and write to the file system.

Created on 5 December 2018

@author: Aaron Sedgmen
"""

from SPARQLWrapper import SPARQLWrapper
import os
import sys
import logging
import lxml.etree as ET
import argparse
from bs4 import BeautifulSoup
import datetime
import re
from io import StringIO

# Set the global variables

#os.environ["HTTP_PROXY"] = "http://sun-web-intdev.ga.gov.au:2710"
#os.environ["HTTPS_PROXY"] = "https://sun-web-intdev.ga.gov.au:2710"
#os.environ["no_proxy"] = "localhost, services.ga.gov.au, intranet.ga.gov.au, np.ga.gov.au, www.ga.gov.au"

associationType_vocab_sparql_endpoint = "http://vocabs.ands.org.au/repository/api/sparql/ga_association-type_v1-2"
onlineFunction_vocab_sparql_endpoint = "http://vocabs.ands.org.au/repository/api/sparql/ga_online-function_v1-0"
protocolType_vocab_sparql_endpoint = "http://vocabs.ands.org.au/repository/api/sparql/ga_protocol-type_v1-2"
serviceType_vocab_sparql_endpoint = "http://vocabs.ands.org.au/repository/api/sparql/ga_service-type_v1-1"

codelist_catalogue_xml_template = '''<cat:CT_CodelistCatalogue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:cat="http://standards.iso.org/iso/19115/-3/cat/1.0"
  xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
  xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:gml="http://www.opengis.net/gml/3.2"
  xsi:schemaLocation="http://standards.iso.org/iso/19115/-3/cat/1.0 http://standards.iso.org/iso/19115/-3/cat/1.0/cat.xsd">
  <!--=====Catalogue description=====-->
  <cat:name>
      <gco:CharacterString>Codelists from the Geoscience Australia profile of the ISO 19115-1:2014</gco:CharacterString>
  </cat:name>
  <cat:scope>
      <gco:CharacterString>Codelists from the Geoscience Australia profile of the ISO 19115-1:2014</gco:CharacterString>
  </cat:scope>
  <cat:fieldOfApplication>
      <gco:CharacterString>ISO TC211 Metadata Standards</gco:CharacterString>
  </cat:fieldOfApplication>
  <cat:versionNumber>
      <gco:CharacterString>see repository version (https://github.com/GeoscienceAustralia/ISO19115-profile)</gco:CharacterString>
  </cat:versionNumber>
  <cat:versionDate>
      <gco:Date>{}</gco:Date>
  </cat:versionDate>
  <cat:locale>
      <lan:PT_Locale>
          <lan:language>
              <lan:LanguageCode codeList="http://standards.iso.org/iso/19115/resources/Codelist/cat/codelists.xml#LanguageCode" codeListValue="eng">eng</lan:LanguageCode>
          </lan:language>
          <lan:characterEncoding>
              <lan:MD_CharacterSetCode codeList="http://standards.iso.org/iso/19115/resources/Codelist/cat/codelists.xml#MD_CharacterSetCode"
                  codeListValue="UTF-8">UTF-8</lan:MD_CharacterSetCode>
          </lan:characterEncoding>
      </lan:PT_Locale>
  </cat:locale>
  <!--============================= Codelists =======================================-->
  {}
  {}
  {}
  {}
</cat:CT_CodelistCatalogue>'''

codelist_catalogue_html_template = '''<html lang="en">
   <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
      <title>Geoscience Australia profile of ISO 19115-1:2014 Codelist Catalog</title>
   </head>
   <body>
      <a id="top"></a>
      <h1>Geoscience Australia profile of ISO 19115-1:2014 Codelist Catalog</h1>
      <p>This report describes the catalog of ISO TC211 codelists extended by the Geoscience Australia profile of ISO 19115-1:2014, the codelists it contains,
         and the values and definitions of the codes.</p>
      <h2>Catalog</h2>
      <b>Name: </b>Codelists from the Geoscience Australia profile of ISO 19115-1:2014<br/>
      <b>Scope: </b>Codelists related to the Geoscience Australia profile of ISO 19115-1:2014<br/>
      <b>Field of application: </b>ISO TC211 Metadata Standards<br/>
      <b>Version: </b>see repository version (https://github.com/GeoscienceAustralia/ISO19115-profile)<br/>
      <b>Date: </b>{}<br/>
      <b>Number of CodeLists: </b>{}<br/>
      <b>Number of items: </b>{}
      <hr/>
      <h2>Codelists</h2>
      {}
      {}
      {}
      {}
    </body>
</html>'''

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

def get_online_function_codes(vocab_sparql_endpoint):
    """
    Query the OnLine Function Code SKOS vocabulary SPARQL endpoint to obtain OnLine Function Code names and definitions

    :return: returns SPARQL Query Results XML document as a string
    """

    query_string = """
        PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
        PREFIX perl: <http://purl.org/dc/terms/>
        SELECT ?onlineFunctionCode ?source ?definition
        WHERE
        {
            ?onlineFunctionCode a skos:Concept .
            OPTIONAL {?onlineFunctionCode perl:source ?source} .
            ?onlineFunctionCode skos:definition ?definition .
        }
        ORDER BY DESC(?source) ?onlineFunctionCode
    """

    sparql = SPARQLWrapper(vocab_sparql_endpoint)
    sparql.setQuery(query_string)
    sparql.setReturnFormat('xml')
    ret = sparql.query()
    online_function_codes_sparql_xml_string = ret.convert().toxml()

    logger.debug(online_function_codes_sparql_xml_string)

    return online_function_codes_sparql_xml_string

def get_protocol_types(vocab_sparql_endpoint):
    """
    Query the Protocol Type SKOS vocabulary SPARQL endpoint to obtain Protocol Type names and definitions

    :return: returns SPARQL Query Results XML document as a string
    """

    query_string = """
        PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
        PREFIX perl: <http://purl.org/dc/terms/>
        SELECT ?altLabel ?source ?definition
        WHERE
        {
            ?protocolType a skos:Concept ;
                          skos:altLabel ?altLabel .
            OPTIONAL {?protocolType perl:source ?source} .
            OPTIONAL {?protocolType skos:definition ?definition}
        }
        ORDER BY ?altLabel
    """

    sparql = SPARQLWrapper(vocab_sparql_endpoint)
    sparql.setQuery(query_string)
    sparql.setReturnFormat('xml')
    ret = sparql.query()
    protocol_types_sparql_xml_string = ret.convert().toxml()

    logger.debug(protocol_types_sparql_xml_string)

    return protocol_types_sparql_xml_string

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
        ORDER BY ?altLabel
    """

    sparql = SPARQLWrapper(vocab_sparql_endpoint)
    sparql.setQuery(query_string)
    sparql.setReturnFormat('xml')
    ret = sparql.query()
    service_types_sparql_xml_string = ret.convert().toxml()

    logger.debug(service_types_sparql_xml_string)

    return service_types_sparql_xml_string

def transform_to_xml_codelist(sparql_xml_string, xsl_file_location):
    """
    Transform the input SPARQL Query Results XML document into an ISO 19115-1 codelist XML document
    
    :param sparql_xml_string: SPARQL Query Results XML document as a string
    :param xsl_file_location: location of XSLT file with which to perform the transform
    :return: returns ISO 19115-1 codelist XML document as a string
    """

    sparql_xml_et = ET.fromstring(sparql_xml_string)
    xslt = ET.parse(xsl_file_location)
    transform = ET.XSLT(xslt)
    codelist_et = transform(sparql_xml_et)
    
    # logger.debug(ET.tostring(codelist_et, pretty_print=True).decode('utf-8'))
    
    return ET.tostring(codelist_et, pretty_print=True)

def transform_to_html_codelist(codelist_xml_string):
    """
    Transform the input ISO 19115-1 codelist XML fragment into an equivalent ISO 19115-1 codelist HTML fragment
    
    :param codelist_xml_string: ISO 19115-1 codelist XML fragment as a string
    :return: returns ISO 19115-1 codelist catalog HTML fragment as a string
    """

    codelist_xml_et = ET.fromstring(codelist_xml_string)
    xslt = ET.parse('xslt/ga_profile_skos_vocabs_to_html_codelists.xsl')
    transform = ET.XSLT(xslt)
    codelist_html_et = transform(codelist_xml_et)
    
#     soup=BeautifulSoup(ET.tostring(codelist_html_et), 'html.parser')
#     prettyHTML=soup.prettify()
    
    # logger.debug(ET.tostring(codelist_html_et, pretty_print=True).decode('utf-8'))
    
    return ET.tostring(codelist_html_et).decode("utf-8")

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
            description='Retrieves content from the GA Profile of ISO 19115-1:2014 SKOS vocabularies, converts them to the ISO 19115-1:2014 codelist XML format, and writes to the file system.')
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
        
    # Obtain the SPARQL Query Results from the SKOS vocabularies for each codelist
    associationTypes_sparql_xml_string = get_associationTypes(associationType_vocab_sparql_endpoint)
    #logger.debug(associationTypes_sparql_xml_string)
    onlineFunctions_sparql_xml_string = get_online_function_codes(onlineFunction_vocab_sparql_endpoint)
    #logger.debug(onlineFunctions_sparql_xml_string)
    protocolTypes_sparql_xml_string = get_protocol_types(protocolType_vocab_sparql_endpoint)
    #logger.debug(protocolTypes_sparql_xml_string)
    serviceTypes_sparql_xml_string = get_service_types(serviceType_vocab_sparql_endpoint)
    #logger.debug(serviceTypes_sparql_xml_string)

    # Transform the SPARQL Query Results XML into ISO 19115-1 codelist XML fragments, to be combined in a single codelist catalogue XMl document
    associationTypes_codelist_xml_fragment = transform_to_xml_codelist(associationTypes_sparql_xml_string, 'xslt/assoctypecode_skos_to_xml_codelist.xsl')
    onlineFunctions_codelist_xml_fragment = transform_to_xml_codelist(onlineFunctions_sparql_xml_string, 'xslt/onlinefunctioncode_skos_to_xml_codelist.xsl')
    protocolTypes_codelist_xml_fragment = transform_to_xml_codelist(protocolTypes_sparql_xml_string, 'xslt/protocoltypecode_skos_to_xml_codelist.xsl')
    serviceTypes_codelist_xml_fragment = transform_to_xml_codelist(serviceTypes_sparql_xml_string, 'xslt/servicetypecode_skos_to_xml_codelist.xsl')
    
    # Insert the xml fragments for each codelist into the codelist catalogue xml document
    output_xml = codelist_catalogue_xml_template.format(datetime.datetime.today().strftime('%Y-%m-%d'), 
                                                        associationTypes_codelist_xml_fragment.decode("utf-8"), 
                                                        onlineFunctions_codelist_xml_fragment.decode("utf-8"), 
                                                        protocolTypes_codelist_xml_fragment.decode("utf-8"), 
                                                        serviceTypes_codelist_xml_fragment.decode("utf-8"))
    
    # Strip out superfluous namespace declarations (introduced by inserting XSLT generated XML within a static XML template already containing the namespace declarations)
    output_xml = re.sub(r"<cat:codelistItem [\s\S].*>", "<cat:codelistItem>", output_xml)
    
    # get codelist counts
    output_xml_et = ET.fromstring(output_xml)
    codelist_count = len(output_xml_et.findall("./cat:codelistItem", namespaces=output_xml_et.nsmap))
    codelist_item_count = len(output_xml_et.findall(".//cat:codeEntry", namespaces=output_xml_et.nsmap))
    
    # Transform the codelist XML fragments into ISO 19115-1 codelist HTML fragments, to be combined in a single codelist catalogue HTML report
    associationTypes_codelist_html_fragment = transform_to_html_codelist(associationTypes_codelist_xml_fragment)
    onlineFunctions_codelist_html_fragment = transform_to_html_codelist(onlineFunctions_codelist_xml_fragment)
    protocolTypes_codelist_html_fragment = transform_to_html_codelist(protocolTypes_codelist_xml_fragment)
    serviceTypes_codelist_html_fragment = transform_to_html_codelist(serviceTypes_codelist_xml_fragment)
    
    # Remove the temporary tags that needed to be included in the HTML fragments by the XSLT transform due to python lxml XSLT not able to handle multiple root elements 
    associationTypes_codelist_html_fragment = re.sub(r"<delete_this_tag>", "", associationTypes_codelist_html_fragment)
    associationTypes_codelist_html_fragment = re.sub(r"</delete_this_tag>", "", associationTypes_codelist_html_fragment)
    onlineFunctions_codelist_html_fragment = re.sub(r"<delete_this_tag>", "", onlineFunctions_codelist_html_fragment)
    onlineFunctions_codelist_html_fragment = re.sub(r"</delete_this_tag>", "", onlineFunctions_codelist_html_fragment)
    protocolTypes_codelist_html_fragment = re.sub(r"<delete_this_tag>", "", protocolTypes_codelist_html_fragment)
    protocolTypes_codelist_html_fragment = re.sub(r"</delete_this_tag>", "", protocolTypes_codelist_html_fragment)
    serviceTypes_codelist_html_fragment = re.sub(r"<delete_this_tag>", "", serviceTypes_codelist_html_fragment)
    serviceTypes_codelist_html_fragment = re.sub(r"</delete_this_tag>", "", serviceTypes_codelist_html_fragment)

    # Insert the html fragments for each codelist into the codelist catalogue html report
    output_html = codelist_catalogue_html_template.format(datetime.datetime.today().strftime('%Y-%m-%d'), 
                                                          codelist_count,
                                                          codelist_item_count,
                                                          associationTypes_codelist_html_fragment, 
                                                          onlineFunctions_codelist_html_fragment, 
                                                          protocolTypes_codelist_html_fragment, 
                                                          serviceTypes_codelist_html_fragment)

    # "Prettify" the html document
    soup=BeautifulSoup(output_html, 'html.parser')
    output_html=soup.prettify()

    # Remove the source element from the codelist xml document, which was needed for the HTML generated from the xml
    output_xml = re.sub(r"<source>[\s\S].*</source>", "", output_xml)
    # "Prettify" the xml document - have to reparse string into etree object with no indentation, then reserialise as a string with pretty_print
    parser = ET.XMLParser(remove_blank_text=True)
    output_xml_et = ET.parse(StringIO(output_xml), parser)
    output_xml = ET.tostring(output_xml_et, pretty_print=True)

     # Write ISO 19115-1 codelist
    with open(os.path.join(args.outputDir, "ga_profile_codelists.xml"), "wb") as text_file:
        text_file.write(output_xml)
    logger.info("XML formatted codelists written to {}".format(os.path.join(args.outputDir, text_file.name)))
    with open(os.path.join(args.outputDir, "ga_profile_codelists.html"), "w") as text_file:
        text_file.write(output_html)
    logger.info("HTML formatted codelists written to {}".format(os.path.join(args.outputDir, text_file.name)))
    
if __name__ == "__main__":
    main()