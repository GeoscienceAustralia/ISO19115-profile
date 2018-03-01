<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:sp="http://www.w3.org/2005/sparql-results#"
    xmlns:date="http://exslt.org/dates-and-times"

    exclude-result-prefixes="xs"
    version="1.0">

    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/sp:sparql">

        <cat:CT_CodelistCatalogue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:cat="http://standards.iso.org/iso/19115/-3/cat/1.0"
           xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
           xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
           xmlns:xlink="http://www.w3.org/1999/xlink"
           xmlns:gml="http://www.opengis.net/gml/3.2"
           xsi:schemaLocation="http://standards.iso.org/iso/19115/-3/cat/1.0 http://standards.iso.org/iso/19115/-3/cat/1.0/cat.xsd">
           <!--=====Catalogue description=====-->
           <cat:name>
              <gco:CharacterString>Geoscience Australia profile codelist that constrains the ISO 19115-1:2014 srv:serviceType free text metadata element</gco:CharacterString>
           </cat:name>
           <cat:scope>
              <gco:CharacterString>Version 1.0 of Geoscience Australia profile of ISO 19115-1:2014 standard</gco:CharacterString>
           </cat:scope>
           <cat:fieldOfApplication>
              <gco:CharacterString>ISO TC211 Metadata Standards</gco:CharacterString>
           </cat:fieldOfApplication>
           <cat:versionNumber>
              <gco:CharacterString>see repository version</gco:CharacterString>
           </cat:versionNumber>
           <cat:versionDate>
               <gco:Date><xsl:value-of select="date:year()"/>-<xsl:value-of select="format-number(date:month-in-year(),'00')"/>-<xsl:value-of select="format-number(date:day-in-month(),'00')"/></gco:Date>
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
           <!-- gapSV_ServiceTypeCode  -->
           <cat:codelistItem>
              <cat:CT_Codelist id="gapSV_ServiceTypeCode">
                 <cat:identifier>
                    <gco:ScopedName codeSpace="http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016">gapSV_ServiceTypeCode</gco:ScopedName>
                 </cat:identifier>
                 <cat:name>
                    <gco:ScopedName codeSpace="http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016">gapSV_ServiceTypeCode</gco:ScopedName>
                 </cat:name>
                 <cat:definition>
                    <gco:CharacterString>type of service</gco:CharacterString>
                 </cat:definition>
                 <cat:description>
                    <gco:CharacterString>type of service</gco:CharacterString>
                 </cat:description>
                 <xsl:apply-templates select=".//sp:result"/>
              </cat:CT_Codelist>
           </cat:codelistItem>
           <!--=== EOF ===-->
        </cat:CT_CodelistCatalogue>

    </xsl:template>

    <xsl:template match="sp:result">

        <xsl:variable name="serviceTypeName">gapSV_ServiceTypeCode_<xsl:call-template name="substring-after-last">
                <xsl:with-param name="string" select="./sp:binding[@name='serviceType']/sp:uri"/>
                <xsl:with-param name="char" select="'/'"/>
            </xsl:call-template>
        </xsl:variable>

        <cat:codeEntry xmlns:cat="http://standards.iso.org/iso/19115/-3/cat/1.0"
            xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0">
            <cat:CT_CodelistValue id="{$serviceTypeName}">
                <cat:identifier>
                    <gco:ScopedName codeSpace="http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016"><xsl:value-of select="$serviceTypeName"/></gco:ScopedName>
                </cat:identifier>
                <cat:definition>
                    <gco:CharacterString><xsl:value-of select=".//sp:binding[@name='definition']/sp:literal"/></gco:CharacterString>
                </cat:definition>
            </cat:CT_CodelistValue>
        </cat:codeEntry>

    </xsl:template>

    <xsl:template name="substring-after-last">
        <xsl:param name="string"/>
        <xsl:param name="char"/>

        <xsl:choose>
            <xsl:when test="contains($string, $char)">
                <xsl:call-template name="substring-after-last">
                    <xsl:with-param name="string" select="substring-after($string, $char)"/>
                    <xsl:with-param name="char" select="$char"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$string"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>