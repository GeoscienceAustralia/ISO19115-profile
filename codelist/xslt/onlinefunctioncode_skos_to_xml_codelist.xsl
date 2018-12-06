<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:sp="http://www.w3.org/2005/sparql-results#"
    xmlns:cat="http://standards.iso.org/iso/19115/-3/cat/1.0"
    xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
    xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:gml="http://www.opengis.net/gml/3.2"
    
    exclude-result-prefixes="xs sp"
    version="1.0">
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/sp:sparql">
        
           <cat:codelistItem>
              <cat:CT_Codelist id="gapCI_OnLineFunctionCode">
                 <cat:identifier>
                    <gco:ScopedName codeSpace="http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016">gapCI_OnLineFunctionCode</gco:ScopedName>
                 </cat:identifier>
                 <cat:name>
                    <gco:ScopedName codeSpace="http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016">gapCI_OnLineFunctionCode</gco:ScopedName>
                 </cat:name>
                 <cat:definition>
                    <gco:CharacterString>function performed by the resource</gco:CharacterString>
                 </cat:definition>
                 <cat:description>
                    <gco:CharacterString>function performed by the resource</gco:CharacterString>
                 </cat:description>
                 <xsl:apply-templates select=".//sp:result"/>
              </cat:CT_Codelist>
           </cat:codelistItem>

    </xsl:template>

    <xsl:template match="sp:result">
        
        <xsl:variable name="onlineFunctionCodeName"><xsl:call-template name="substring-after-last">
                <xsl:with-param name="string" select="./sp:binding[@name='onlineFunctionCode']/sp:uri"/>
                <xsl:with-param name="char" select="'/'"/>
            </xsl:call-template>            
        </xsl:variable>

        <cat:codeEntry xmlns:cat="http://standards.iso.org/iso/19115/-3/cat/1.0"
            xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0">
            <cat:CT_CodelistValue id="gapCI_OnLineFunctionCode_{$onlineFunctionCodeName}">
                <cat:identifier>
                    <gco:ScopedName codeSpace="http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016"><xsl:value-of select="$onlineFunctionCodeName"/></gco:ScopedName>
                </cat:identifier>
                <cat:name>
                    <gco:ScopedName codeSpace="http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016"><xsl:value-of select="$onlineFunctionCodeName"/></gco:ScopedName>
                </cat:name>
                <cat:definition>
                    <gco:CharacterString><xsl:value-of select=".//sp:binding[@name='definition']/sp:literal"/></gco:CharacterString>
                </cat:definition>
                <cat:description>
                    <gco:CharacterString><xsl:value-of select=".//sp:binding[@name='definition']/sp:literal"/></gco:CharacterString>
                </cat:description>
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