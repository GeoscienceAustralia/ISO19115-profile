"""
Routine to add the ISO 19115-1:2014 GA Profile codelists in the ISO 19115-1:2014 CAT 1.0 XML format
to the geonetwork formatted ISO 19115-1:2014 codelists.

Created on 10 December 2018

@author: Aaron Sedgmen
"""

from SPARQLWrapper import SPARQLWrapper
import os
import sys
import logging
import lxml.etree as ET
import argparse
import datetime
import re
from io import StringIO

# Set the global variables


# Set handler for root logger to standard output if no handler exists
if not logging.root.handlers:
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setLevel(logging.DEBUG)
    console_formatter = logging.Formatter('%(message)s')
    console_handler.setFormatter(console_formatter)
    logging.root.addHandler(console_handler)

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)  # Initial logging level for this module


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
            description='Adds ISO 19115-1:2014 GA Profile codelists in the ISO 19115-1:2014 CAT 1.0 XML format to the geoneGeoNetwork formatted ISO 19115-1:2014 codelists.')
        parser.add_argument("gnCodelists",
                            help="Original GeoNetwork codelists file to be modified")
        parser.add_argument("gnLabels",
                            help="Original GeoNetwork labels file to be modified")
        parser.add_argument("-g", "--gaProfileCodelists",
                            help="GA Profile codelists with which to modify the GeoNetwork codelists (default is ga_profile_codelists.xml in current working directory)",
                            dest="gaProfileCodelists",
                            default="ga_profile_codelists.xml")
        parser.add_argument("-o", "--outputDir",
                            help="Output directory for updated GeoNetwork codelist XML file (default is current working directory)",
                            dest="outputDir",
                            default=os.getcwd())
        parser.add_argument("-l", "--loggingLevel",
                            help="Logging level (ERROR, WARNING, INFO, DEBUG)",
                            dest="logging_level",
                            default="INFO")
        return parser.parse_args()

    args = get_args()
    
    # Set logging level    
    logger.setLevel(args.logging_level)
    
    # Ensure the files provided exist
    assert os.path.isfile(args.gaProfileCodelists),"File provided for GA Profile codelists %r does not exist!" % args.gaProfileCodelists
    assert os.path.isfile(args.gnCodelists),"File provided for GeoNetwork codelists %r does not exist!" % args.gnCodelists
    assert os.path.isfile(args.gnLabels),"File provided for GeoNetwork labels %r does not exist!" % args.gnLabels
    
    # Convert each of the GA Profile codelists from ISO 19115-1 CAT 1.0 format to the GeoNetwork format
    
    # Read the ISO codelists file insto a string
    with open(args.gaProfileCodelists, 'r') as ga_profile_codelist_file:
        ga_iso_codelists_string = ga_profile_codelist_file.read().replace('\n', '')
    
    ga_iso_codelists_et = ET.fromstring(ga_iso_codelists_string)

    # Convert the online function and association type ISO codelists to XML fragments compatible with the GeoNetwork codelists.xml file 
    xslt = ET.parse("xslt/iso_codelist_to_geonetwork.xsl")
    transform = ET.XSLT(xslt)
    gapCI_OnLineFunctionCode_codelist_et = transform(ga_iso_codelists_et, codelistName=ET.XSLT.strparam("gapCI_OnLineFunctionCode"))
    gapDS_AssociationTypeCode_codelist_et = transform(ga_iso_codelists_et, codelistName=ET.XSLT.strparam("gapDS_AssociationTypeCode"))
    
    # print(ET.tostring(gapCI_OnLineFunctionCode_codelist_et, pretty_print=True).decode('utf-8'))

    # Convert the service type and protocol ISO codelists to XML fragments compatible with the GeoNetwork labels.xml file
    gapSV_ServiceTypeCode_codelist_et = transform(ga_iso_codelists_et, codelistName=ET.XSLT.strparam("gapSV_ServiceTypeCode"))
    gapCI_ProtocolTypeCode_codelist_et = transform(ga_iso_codelists_et, codelistName=ET.XSLT.strparam("gapCI_ProtocolTypeCode"))

    # print(ET.tostring(gapSV_ServiceTypeCode_codelist_et, pretty_print=True).decode('utf-8'))
    
    # Load the gn codelists.xml and labels.xml files into strings
    with open(args.gnCodelists, "r", encoding="utf8") as gn_codelists_file:
        gn_codelists_string = gn_codelists_file.read()
    with open(args.gnLabels, "r", encoding="utf8") as gn_labels_file:
        gn_labels_string = gn_labels_file.read()
        
    # Add the gapm namespace declaration
    gn_codelists_string2 = gn_codelists_string.replace('xmlns:gml="http://www.opengis.net/gml/3.2"', 'xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:gapm="http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016"')

    # Load modified gn codelists string into xml object
    gn_codelists_et = ET.fromstring(gn_codelists_string2.encode('utf-8'))
    
    # Load gn labels string into xml object
    gn_labels_et = ET.fromstring(gn_labels_string.encode('utf-8'))

    # Remove the DS_AssociationTypeCode codelist from the gn codelists document
    DS_AssociationTypeCode_node = gn_codelists_et.find(".//codelist[@name='mri:DS_AssociationTypeCode']")
    parent = DS_AssociationTypeCode_node.getparent()
    index = parent.index(DS_AssociationTypeCode_node)
    parent.remove(DS_AssociationTypeCode_node)
    
    # Insert the gapDS_AssociationTypeCode codelist into the gn codelists document
    gapDS_AssociationTypeCode_codelist_et.find('.').set('name', 'mri:DS_AssociationTypeCode')
    parent.insert(index, gapDS_AssociationTypeCode_codelist_et.find('.'))
    
    # Remove the CI_OnLineFunctionCode codelist from the gn codelists.xml document
    CI_OnLineFunctionCode_node = gn_codelists_et.find(".//codelist[@name='cit:CI_OnLineFunctionCode']")
    parent = CI_OnLineFunctionCode_node.getparent()
    index = parent.index(CI_OnLineFunctionCode_node)
    parent.remove(CI_OnLineFunctionCode_node)
    
    # Insert the gapCI_OnLineFunctionCode codelist into the gn codelists.xml document
    gapCI_OnLineFunctionCode_codelist_et.find('.').set('name', 'cit:CI_OnLineFunctionCode')
    parent.insert(index, gapCI_OnLineFunctionCode_codelist_et.find('.'))
    
    # Append the gapCI_ProtocolTypeCode codelist into the gn labels.xml document
    gn_labels_et.append(gapCI_ProtocolTypeCode_codelist_et.find('.'))

    # Append the gapSV_ServiceTypeCode codelist into the gn labels.xml document
    gn_labels_et.append(gapSV_ServiceTypeCode_codelist_et.find('.'))
    
    # Write the updated GeoNetwork codelists file to the file system (have to write then read using parser and rewrite to force pretty print)
    with open(os.path.join(args.outputDir, "codelists_geonetwork_ga_profile.xml"), "w") as text_file:
        text_file.write(ET.tostring(gn_codelists_et).decode('utf-8'))
    parser = ET.XMLParser(remove_blank_text=True)        
    output_xml_et = ET.parse(os.path.join(args.outputDir, "codelists_geonetwork_ga_profile.xml"), parser)
    output_xml = ET.tostring(output_xml_et, pretty_print=True).decode('utf-8')
    with open(os.path.join(args.outputDir, "codelists_geonetwork_ga_profile.xml"), "w") as text_file:
        text_file.write(output_xml)

    # Write the updated GeoNetwork labels file to the file system (have to write then read using parser and rewrite to force pretty print)
    with open(os.path.join(args.outputDir, "labels_geonetwork_ga_profile.xml"), "w") as text_file:
        text_file.write(ET.tostring(gn_labels_et).decode('utf-8'))
    parser = ET.XMLParser(remove_blank_text=True)        
    output_xml_et = ET.parse(os.path.join(args.outputDir, "labels_geonetwork_ga_profile.xml"), parser)
    output_xml = ET.tostring(output_xml_et, pretty_print=True).decode('utf-8')
    with open(os.path.join(args.outputDir, "labels_geonetwork_ga_profile.xml"), "w") as text_file:
        text_file.write(output_xml)
   
    
if __name__ == "__main__":
    main()