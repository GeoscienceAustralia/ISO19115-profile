'''
Created on 18/06/2020

@author: asedgmen
'''

import lxml.etree as ET
from lxml import isoschematron
import unittest
import logging
import os


rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
#xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'all_rules_pass.xml'), 'r', encoding="utf-8")
xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.1_metadataIdentifier_fail_v2.0.xml'), 'r', encoding="utf-8")
 
# Parse schema
sct_doc = ET.parse(rules)
schematron = isoschematron.Schematron(sct_doc, store_report= True)

# Parse xml
doc = ET.parse(xml)

# Validate against schema
validationResult = schematron.validate(doc)
report = schematron.validation_report

print(report)

failed_asserts = report.findall('.//{http://purl.oclc.org/dsdl/svrl}failed-assert')
for failed_assert in failed_asserts:
    print(failed_assert.find('.//{http://purl.oclc.org/dsdl/svrl}text').text)

        