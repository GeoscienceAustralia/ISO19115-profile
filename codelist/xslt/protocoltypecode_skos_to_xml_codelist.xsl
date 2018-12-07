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
              <cat:CT_Codelist id="gapCI_ProtocolTypeCode">
                 <cat:identifier>
                    <gco:ScopedName codeSpace="http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016">gapCI_ProtocolTypeCode</gco:ScopedName>
                 </cat:identifier>
                 <cat:name>
                    <gco:ScopedName codeSpace="http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016">gapCI_ProtocolTypeCode</gco:ScopedName>
                 </cat:name>
                 <cat:definition>
                    <gco:CharacterString>connection protocol to be used</gco:CharacterString>
                 </cat:definition>
                 <cat:description>
                    <gco:CharacterString>connection protocol to be used</gco:CharacterString>
                 </cat:description>
                 <xsl:apply-templates select=".//sp:result"/>
              </cat:CT_Codelist>
           </cat:codelistItem>

    </xsl:template>

    <xsl:template match="sp:result">

        <xsl:variable name="protocolTypeName"><xsl:call-template name="substring-after-last">
                <xsl:with-param name="string" select="normalize-space(./sp:binding[@name='altLabel']/sp:literal)"/>
                <xsl:with-param name="char" select="'/'"/>
            </xsl:call-template>
        </xsl:variable>

        <cat:codeEntry xmlns:cat="http://standards.iso.org/iso/19115/-3/cat/1.0"
            xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0">
            <cat:CT_CodelistValue id="gapCI_ProtocolTypeCode_{translate($protocolTypeName, ':', '-')}">
                <cat:identifier>
                    <gco:ScopedName codeSpace="http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016"><xsl:value-of select="$protocolTypeName"/></gco:ScopedName>
                </cat:identifier>
                <cat:name>
                    <gco:ScopedName codeSpace="http://pid.geoscience.gov.au/def/schema/ga/ISO19115-3-2016"><xsl:value-of select="$protocolTypeName"/></gco:ScopedName>
                </cat:name>
                <cat:definition>
                    <gco:CharacterString><xsl:value-of select="normalize-space(.//sp:binding[@name='definition']/sp:literal)"/></gco:CharacterString>
                </cat:definition>
                <cat:description>
                    <gco:CharacterString><xsl:value-of select="normalize-space(.//sp:binding[@name='definition']/sp:literal)"/></gco:CharacterString>
                </cat:description>
                <source><xsl:value-of select="normalize-space(.//sp:binding[@name='source']/sp:literal)"/></source>
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