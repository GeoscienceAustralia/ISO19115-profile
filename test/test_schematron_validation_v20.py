'''
Created on 18 June 2020

Unit tests for GA Profile schematron with ISO 19115-3 v2.0 namespaces

@author: A.Sedgmen
'''

import lxml.etree as ET
from lxml import isoschematron
import unittest
import logging
import os

def schematron_validator(rules, xml):
        # Parse schema
        sct_doc = ET.parse(rules)
        schematron = isoschematron.Schematron(sct_doc, store_report= True)
        
        # Parse xml
        doc = ET.parse(xml)
        
        # Validate against schema
        validationResult = schematron.validate(doc)
        report = schematron.validation_report
        
        return (validationResult, report)
    
def fail_assert_exist(svrl_doc, active_pattern_id):
    '''
    Check if a Schematron svrl document contains a given fail assertion 
    '''
    failed_asserts = svrl_doc.findall('.//{http://purl.oclc.org/dsdl/svrl}failed-assert')
    for failed_assert in failed_asserts:
        for sib in failed_assert.itersiblings(preceding=True):
            if 'active-pattern' in sib.tag:
                if sib.get('id') == active_pattern_id:
                    return True
                break
    return False

class SchematronValidationTestCase(unittest.TestCase):
    '''
    Unittests for Schematron in the GA Profile of ISO 19115-1:2014
    '''

    def test_metadataIdentifier_pass(self):
        '''
        Test to check that schematron 2.7.1 metadataIdentifier rule passes when metadataIdentifier element exists
        '''
        logging.info("metadataIdentifier pass test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'all_rules_pass_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.mdb.metadataidentifierpresent'),
                         msg="schematron 2.7.1 metadataIdentifier rule did not pass when validating a record with a metadataIdentifier element")

    def test_metadataIdentifier_fail(self):
        '''
        Test to check that schematron 2.7.1 metadataIdentifier rule fails when metadataIdentifier element does not exist
        '''
        logging.info("metadataIdentifier fail test")
          
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.1_metadataIdentifier_fail_v2.0.xml'), 'r', encoding="utf-8")
          
        results = schematron_validator(rules, xml)
          
        self.assertFalse(results[0], msg="schematron 2.7.1 metadataIdentifier rule did not fail when validating a record with out a metadataIdentifier element")
          
        # Make sure the failed assert is a result of this rule
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.mdb.metadataidentifierpresent'),
                        msg="schematron 2.7.1 metadataIdentifier rule did not fail when validating a record with out a metadataIdentifier element")


    def test_parentMetadata_pass_1(self):
        '''
        Test 2 checks that schematron 2.7.2 parentMetadata rule passes when parentMetadata element is missing and resource scope is NOT one of 'feature', 
        'featureType', 'attribute' or 'attributeType'.
        '''
        logging.info("parentMetadata pass test 1")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'all_rules_pass_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.mdb.metadataparentpresent'),
                         msg="schematron 2.7.2 parentMetadata rule did not pass when validating a record without a parentMetadata element and resource scope other than 'feature', 'featureType', 'attribute' or 'attributeType'.")

    def test_parentMetadata_pass_2(self):
        '''
        Test 1 checks that schematron 2.7.2 parentMetadata rule passes when parentMetadata element exists and resource scope is one of 'feature', 'featureType', 
        'attribute' or 'attributeType'.
        '''
        logging.info("parentMetadata pass test 2")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.2_parentMetadata_pass2_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.mdb.metadataparentpresent'),
                         msg="schematron 2.7.2 parentMetadata rule did not pass when validating a record with a parentMetadata element and resource scope of 'feature', 'featureType', 'attribute' or 'attributeType'.")

    def test_parentMetadata_fail(self):
        '''
        Test to check that schematron 2.7.2 parentMetadata rule fails when parentMetadata element is missing and resource scope is one of 'feature', 
        'featureType', 'attribute' or 'attributeType'.
        '''
        logging.info("parentMetadata fail test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.2_parentMetadata_fail_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        # Make sure the failed assert occurred for this rule
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.mdb.metadataparentpresent'),
                        msg="schematron 2.7.2 parentMetadata rule did not fail when validating a record with out a parentMetadata element and resource scope one of 'feature', 'featureType', 'attribute' or 'attributeType'.")
           
    def test_parentMetadata_identifier_pass(self):
        '''
        Test to check that schematron 2.7.3 parentMetadata identifier rule passes when parentMetadata identifier exists.
        '''
        logging.info("parentMetadata identifier pass test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.2_parentMetadata_pass2_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.mdb.metadataparentidentifierpresent'),
                        msg="schematron 2.7.3 parentMetadata identifier rule did not pass when validating a record with a parentMetadata element having an identifier element.")

    def test_parentMetadata_identifier_fail(self):
        '''
        Test to check that schematron 2.7.3 parentMetadata identifier rule fails when when parentMetadata identifier does not exist.
        '''
        logging.info("parentMetadata identifier fail test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.3_parentMetadata_identifier_fail_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        # Make sure the failed assert occurred for this rule
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.mdb.metadataparentidentifierpresent'),
                        msg="schematron 2.7.3 parentMetadata identifier rule did not fail when validating a record with a parentMetadata element missing an identifier element.")
        
    def test_resource_identifier_pass(self):
        '''
        Test to check that schematron 2.7.4 resource identifier rule passes when resource identifier exists.
        '''
        logging.info("resource identifier pass test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'all_rules_pass_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.mdb.resourceidentifierpresent'),
                        msg="schematron 2.7.4 resource identifier rule did not pass when validating a record with a resource element having an identifier element.")

    def test_resource_identifier_fail(self):
        '''
        Test to check that schematron 2.7.4 resource identifier rule fails when resource identifier does not exist.
        '''
        logging.info("resource identifier fail test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.4_resource_identifier_fail_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        # Make sure the failed assert occurred for this rule
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.mdb.resourceidentifierpresent'),
                        msg="schematron 2.7.4 resource identifier rule did not fail when validating a record with a resource element missing an identifier element.")

    def test_constraint_reference_pass(self):
        '''
        Test to check that schematron 2.7.5 constraint reference rule passes when constraint reference exists.
        '''
        logging.info("constraint reference pass test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'all_rules_pass_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.mdb.constraintreferencepresent'),
                         msg="schematron 2.7.5 constraint reference rule did not pass when validating a record with constraint elements having reference properties.")

    def test_constraint_reference_fail(self):
        '''
        Test to check that schematron 2.7.5 constraint reference rule fails when constraint reference does not exist.
        '''
        logging.info("constraint reference fail test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.5_constraint_reference_fail_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        # Make sure the failed assert occurred for this rule
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.mdb.constraintreferencepresent'),
                        msg="schematron 2.7.5 constraint reference rule did not fail when validating a record with a constraint element missing a resource property.")

    def test_metadata_security_constraint_pass(self):
        '''
        Test to check that schematron 2.7.6 metadata security constraint rule passes when a metadata security constraint element exists.
        '''
        logging.info("metadata security constraint pass test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'all_rules_pass_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.mdb.metadatasecurityconstraintpresent'),
                         msg="schematron 2.7.6 metadata security constraint rule did not pass when validating a record with a metadata security constraint element.")

    def test_metadata_security_constraint_fail(self):
        '''
        Test to check that schematron 2.7.6 metadata security constraint rule fails when a metadata security constraint element is not present.
        '''
        logging.info("metadata security constraint fail test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.6_metadata_security_constraint_fail_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        # Make sure the failed assert occurred for this rule
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.mdb.metadatasecurityconstraintpresent'),
                        msg="schematron 2.7.6 metadata security constraint rule did not fail when validating a record without a metadata security constraint element.")

    def test_resource_pointofcontact_pass(self):
        '''
        Test to check that schematron 2.7.7 resource point of contact rule passes when a resource point of contact element exists.
        '''
        logging.info("resource point of contact pass test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'all_rules_pass_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.mri.pointofcontact'),
                         msg="schematron 2.7.7 resource point of contact rule did not pass when validating a record with a resource point of contact element.")

    def test_resource_pointofcontact_fail(self):
        '''
        Test to check that schematron 2.7.7 resource point of contact rule fails when a resource point of contact element does not exist.
        '''
        logging.info("resource point of contact fail test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.7_resource_pointofcontact_fail_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        # Make sure the failed assert occurred for this rule
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.mri.pointofcontact'),
                        msg="schematron 2.7.7 resource point of contact rule did not fail when validating a record without a resource point of contact element.")

    def test_resource_maintenance_pass(self):
        '''
        Test to check that schematron 2.7.8 resource maintenance rule passes when a resource maintenance element exists.
        '''
        logging.info("resource maintenance pass test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'all_rules_pass_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.mmi.maintenanceinformation'),
                         msg="schematron 2.7.8 resource maintenance did not pass when validating a record with a resource maintenance element.")

    def test_resource_maintenance_fail(self):
        '''
        Test to check that schematron 2.7.8 resource maintenance rule fails when a resource maintenance element does not exist.
        '''
        logging.info("resource maintenance fail test")
         
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.8_resource_maintenance_fail_v2.0.xml'), 'r', encoding="utf-8")
         
        results = schematron_validator(rules, xml)
         
        # Make sure the failed assert occurred for this rule
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.mmi.maintenanceinformation'),
                        msg="schematron 2.7.8 resource maintenance did not fail when validating a record without a resource maintenance element.")

    def test_resource_maintenance_update_frequency_pass(self):
        '''
        Test to check that schematron 2.7.9 resource maintenance update frequency rule passes when a resource maintenance update frequency element and code value exists.
        '''
        logging.info("resource maintenance update frequency pass test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'all_rules_pass_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.mmi.maintenanceupdatefrequency'),
                         msg="schematron 2.7.9 resource maintenance update frequency did not pass when validating a record with a resource maintenance update frequency element.")

    def test_resource_maintenance_update_frequency_fail(self):
        '''
        Test to check that schematron 2.7.9 resource maintenance update frequency rule fails when a resource maintenance update frequency element or code attribute does not exist.
        '''
        logging.info("resource maintenance update frequency fail test")
         
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.9_resource_maintenance_update_frequency_fail_v2.0.xml'), 'r', encoding="utf-8")
         
        results = schematron_validator(rules, xml)
         
        # Make sure the failed assert occurred for this rule
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.mmi.maintenanceupdatefrequency'),
                        msg="schematron 2.7.9 resource maintenance update frequency did not fail when validating a record without a resource maintenance update frequency element or code attribute.")

    def test_resource_constraint_pass(self):
        '''
        Test to check that schematron 2.7.10 resource constraint rule passes when a resource security constraint element and resource legal constraint element exists.
        '''
        logging.info("resource constraint pass test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'all_rules_pass_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.mri.resourcesecurityconstraintpresent'),
                         msg="schematron 2.7.10 resource constraint did not pass when validating a record with a resource security constraint element.")
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.mri.resourcelegalconstraintpresent'),
                         msg="schematron 2.7.10 resource constraint did not pass when validating a record with a resource legal constraint element.")

    def test_resource_constraint_fail(self):
        '''
        Test to check that schematron 2.7.10 resource constraint rule fails when a resource security constraint element or a resource legal constraint element do not exist.
        '''
        logging.info("resource constraint fail test")
         
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.10_resource_constraint_fail_v2.0.xml'), 'r', encoding="utf-8")
         
        results = schematron_validator(rules, xml)
         
        # Make sure the failed assert occurred for this rule
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.mri.resourcesecurityconstraintpresent'),
                        msg="schematron 2.7.10 resource constraint did not fail when validating a record without a resource security constraint element.")
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.mri.resourcelegalconstraintpresent'),
                        msg="schematron 2.7.10 resource constraint did not fail when validating a record without a resource legal constraint element.")

    def test_resource_legal_access_constraint_pass(self):
        '''
        Test to check that schematron 2.7.11 resource legal access constraint rule passes when a resource legal constraint element contains an access constraint element.
        '''
        logging.info("resource legal access constraint pass test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'all_rules_pass_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.mri.resourcelegalaccesconstraintpresent'),
                         msg="schematron 2.7.11 resource legal access constraint did not pass when validating a record with a resource legal access constraint element.")

    def test_resource_legal_access_constraint_fail(self):
        '''
        Test to check that schematron 2.7.11 resource legal access constraint rule passes when a resource legal constraint element does not contain an access constraint element.
        '''
        logging.info("resource legal access constraint fail test")
         
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.11_resource_legal_access_constraint_fail_v2.0.xml'), 'r', encoding="utf-8")
         
        results = schematron_validator(rules, xml)
         
        # Make sure the failed assert occurred for this rule
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.mco.resourcelegalaccesconstraintpresent'),
                        msg="schematron 2.7.11 resource legal access constraint did not fail when validating a record without a resource legal access constraint element.")

    def test_resource_legal_use_constraint_pass(self):
        '''
        Test to check that schematron 2.7.12 resource legal use constraint rule passes when a resource legal constraint element contains a use constraint element.
        '''
        logging.info("resource legal use constraint pass test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'all_rules_pass_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.mco.resourcelegaluseconstraintpresent'),
                         msg="schematron 2.7.12 resource legal use constraint did not pass when validating a record with a resource legal use constraint element.")

    def test_resource_legal_use_constraint_fail(self):
        '''
        Test to check that schematron 2.7.12 resource legal use constraint rule fails when a resource legal constraint element does not contain a use constraint element.
        '''
        logging.info("resource legal use constraint fail test")
         
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.12_resource_legal_use_constraint_fail_v2.0.xml'), 'r', encoding="utf-8")
         
        results = schematron_validator(rules, xml)
         
        # Make sure the failed assert occurred for this rule
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.mco.resourcelegaluseconstraintpresent'),
                        msg="schematron 2.7.12 resource legal use constraint did not fail when validating a record without a resource legal use constraint element.")

    def test_topic_category_pass(self):
        '''
        Test to check that schematron 2.7.13 topic category rule passes when a topic category element exists.
        '''
        logging.info("topic category pass test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'all_rules_pass_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.mri.topiccategorypresent'),
                         msg="schematron 2.7.13 topic category did not pass when validating a record with a topic category element.")

    def test_topic_category_fail(self):
        '''
        Test to check that schematron 2.7.13 topic category rule fails when a topic category element does not exist.
        '''
        logging.info("topic category fail test")
         
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.13_topic_category_fail_v2.0.xml'), 'r', encoding="utf-8")
         
        results = schematron_validator(rules, xml)
         
        # Make sure the failed assert occurred for this rule
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.mri.topiccategorypresent'),
                        msg="schematron 2.7.13 topic category did not fail when validating a record without a topic category element.")

    def test_extent_pass(self):
        '''
        Test to check that schematron 2.7.14 extent rule passes when at least one of "geographicExtent", "temporalExtent" or "verticalExtent" elements exist.
        '''
        logging.info("extent pass test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'all_rules_pass_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.gex.extentpresent'),
                         msg='schematron 2.7.14 extent rule did not pass when validating a record with at least one of "geographicExtent", "temporalExtent" or "verticalExtent" elements.')


    def test_extent_fail(self):
        '''
        Test to check that schematron 2.7.14 extent rule fails when "geographicExtent", "temporalExtent" and "verticalExtent" elements do not exist.
        '''
        logging.info("extent fail test")
         
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.14_extent_fail_v2.0.xml'), 'r', encoding="utf-8")
         
        results = schematron_validator(rules, xml)
         
        # Make sure the failed assert occurred for this rule
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.gex.extentpresent'),
                        msg='schematron 2.7.14 extent rule did not fail when validating a record with missing "geographicExtent", "temporalExtent" and "verticalExtent" elements.')

    def test_reference_system_pass(self):
        '''
        Test to check that schematron 2.7.15 reference system info rule passes when a referenceSystemInfo element exists.
        '''
        logging.info("reference system info pass test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'all_rules_pass_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.mdb.referencesysteminfopresent'),
                         msg='schematron 2.7.15 reference system info rule did not pass when validating a record with a referenceSystemInfo element.')

    def test_reference_system_fail(self):
        '''
        Test to check that schematron 2.7.15 reference system info rule fails when a referenceSystemInfo element does not exist.
        '''
        logging.info("reference system info fail test")
         
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.15_reference_system_info_fail_v2.0.xml'), 'r', encoding="utf-8")
         
        results = schematron_validator(rules, xml)
         
        # Make sure the failed assert occurred for this rule
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.mdb.referencesysteminfopresent'),
                        msg='schematron 2.7.15 reference system info rule did not fail when validating a record with a missing referenceSystemInfo element.')

    def test_descriptive_keywords_pass(self):
        '''
        Test to check that schematron 2.7.16 descriptive keyword rule passes when one or more descriptive keyword elements exist.
        '''
        logging.info("descriptive keywords pass test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'all_rules_pass_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.mri.descriptivekeywordpresent'),
                         msg='schematron 2.7.16 descriptive keyword rule did not pass when validating a record with a keyword element.')

    def test_descriptive_keywords_fail(self):
        '''
        Test to check that schematron 2.7.16 descriptive keyword rule fails when no descriptive keyword elements exist.
        '''
        logging.info("descriptive keywords fail test")
         
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.16_descriptive_keywords_fail_v2.0.xml'), 'r', encoding="utf-8")
         
        results = schematron_validator(rules, xml)
         
        # Make sure the failed assert occurred for this rule
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.mri.descriptivekeywordpresent'),
                         msg='schematron 2.7.16 descriptive keyword rule did not fail when validating a record without a keyword element.')


    def test_resource_lineage_pass(self):
        '''
        Test to check that schematron 2.7.17 resource lineage rule passes when resource lineage element exists.
        '''
        logging.info("resource lineage pass test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'all_rules_pass_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.mrl.resourcelineagepresent'),
                         msg='schematron 2.7.17 resource lineage rule did not pass when validating a record with a resource lineage element.')

    def test_resource_lineage_fail(self):
        '''
        Test to check that schematron 2.7.17 resource lineage rule fails when resource lineage element does not exist.
        '''
        logging.info("resource lineage fail test")
         
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.17_resource_lineage_fail_v2.0.xml'), 'r', encoding="utf-8")
         
        results = schematron_validator(rules, xml)
         
        # Make sure the failed assert occurred for this rule
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.mrl.resourcelineagepresent'),
                         msg='schematron 2.7.17 resource lineage rule did not fail when validating a record without a resource lineage element.')

    def test_resource_lineage_statement_pass(self):
        '''
        Test to check that schematron 2.7.18 resource lineage statement rule passes when resource lineage statement element exists.
        '''
        logging.info("resource lineage statement pass test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'all_rules_pass_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.mrl.resourcelineagestatementpresent'),
                         msg='schematron 2.7.18 resource lineage statement rule did not pass when validating a record with a resource lineage statement element.')

    def test_resource_lineage_statement_fail(self):
        '''
        Test to check that schematron 2.7.18 resource lineage statement rule fails when resource lineage statement element does not exist or has no text.
        '''
        logging.info("resource lineage statement fail test")
         
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.18_resource_lineage_statement_fail_v2.0.xml'), 'r', encoding="utf-8")
         
        results = schematron_validator(rules, xml)
         
        # Make sure the failed assert occurred for this rule
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.mrl.resourcelineagestatementpresent'),
                         msg='schematron 2.7.18 resource lineage statement rule did not fail when validating a record without a resource lineage statement element.')

    def test_resource_and_distribution_format_pass(self):
        '''
        Test to check that schematron 2.7.19 resource format rule and schematron 2.7.20 distribution format rule pass when validating a record with a
        resource format element and distribution format element.
        '''
        logging.info("resource format and distribution format pass test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'all_rules_pass_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.mri.resourceanddistributionformat'),
                         msg='schematron 2.7.19 resource format rule and schematron 2.7.20 distribution format rules did not pass when validating a record with a resource format element and distribution format element.')

    def test_resource_and_distribution_format_fail(self):
        '''
        Test to check that schematron 2.7.19 resource format rule and schematron 2.7.20 distribution format rule fails when validating a record with out a
        resource format element or distribution format element.
        '''
        logging.info("resource format and distribution format fail test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_2.7.19_resource_format_and_rule_2.7.20_distribution_format_fail_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.mri.resourceanddistributionformat'),
                         msg='schematron 2.7.19 resource format rule and schematron 2.7.20 distribution format rules did not fail when validating a record with out a resource format element or distribution format element.')

    def test_protocolcodelist_extension_pass(self):
        '''
        Test to check that the online resource protocol codelist extension rule (B.3.9 'ProtocolType <<CodeList>>') passes when validating a record with an
        online resource protocol element that has been extended by the GA Profile schema to be constrained to a codelist.
        '''
        logging.info("online resource protocol codelist extension pass test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_B.3.9_protocol_correct_codelist_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.cit.protocolextendedforcodelist'),
                         msg='online resource protocol codelist extension rule did not pass when validating a record with an online resource protocol element that has been extended by the GA Profile to be constrained by a codelist.')

    def test_protocolcodelist_extension_fail(self):
        '''
        Test to check that the online resource protocol codelist extension rule (B.3.9 'ProtocolType <<CodeList>>') fails when validating a record with an
        online resource protocol element that has not been extended by the GA Profile schema to be constrained to a codelist.
        '''
        logging.info("online resource protocol codelist extension fail test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_B.3.9_protocol_codelist_extension_fail_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.cit.protocolextendedforcodelist'),
                         msg='online resource protocol codelist extension rule did not fail when validating a record with an online resource protocol element that has not been extended by the GA Profile to be constrained by a codelist.')

    def test_servicetypecodelist_extension_pass(self):
        '''
        Test to check that the service type codelist extension rule (B.3.11 'ServiceType <<CodeList>>') passes when validating a record with a
        service type element that has been extended by the GA Profile schema to be constrained to a codelist.
        '''
        logging.info("service type codelist extension pass test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_B.3.11_servicetype_correct_codelist_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertFalse(fail_assert_exist(results[1], 'rule.ga.srv.servicetypeextendedforcodelist'),
                         msg='service type codelist extension rule did not pass when validating a record with a service type element that has been extended by the GA Profile to be constrained by a codelist.')

    def test_servicetypecodelist_extension_fail(self):
        '''
        Test to check that the service type codelist extension rule (B.3.11 'ServiceType <<CodeList>>') fails when validating a record with a
        service type element that has not been extended by the GA Profile schema to be constrained to a codelist.
        '''
        logging.info("service type codelist extension fail test")
        
        # Open files
        rules = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'schematron-rules-ga_v2.0.sch'), 'r', encoding="utf-8")
        xml = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),'test_data', 'rule_B.3.11_servicetype_codelist_extension_fail_v2.0.xml'), 'r', encoding="utf-8")
        
        results = schematron_validator(rules, xml)
        
        self.assertTrue(fail_assert_exist(results[1], 'rule.ga.srv.servicetypeextendedforcodelist'),
                         msg='service type codelist extension rule did not fail when validating a record with a service type element that has not been extended by the GA Profile to be constrained by a codelist.')

if __name__ == '__main__':
    unittest.main()
