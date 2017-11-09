<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:sp="http://www.w3.org/2005/sparql-results#"

    exclude-result-prefixes="xs"
    version="1.0">

    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/sp:sparql">

        <cat:CT_CodelistCatalogue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:cat="http://standards.iso.org/iso/19115/-3/cat/1.0"
           xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
           xsi:schemaLocation="http://standards.iso.org/iso/19115/-3/cat/1.0 http://standards.iso.org/iso/19115/-3/cat/1.0/cat.xsd">
           <!--=====Catalogue description=====-->

           <!--============================= Codelists =======================================-->
           <!-- GA_ServiceType  -->
           <cat:codelistItem>
              <cat:CT_Codelist id="GA_ServiceType">
                 <cat:identifier>
                    <gco:ScopedName>GA_ServiceType</gco:ScopedName>
                 </cat:identifier>
                 <cat:name>
                    <gco:ScopedName>GA_ServiceType</gco:ScopedName>
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
           <!--=== EOF ===-->
        </cat:CT_CodelistCatalogue>

    </xsl:template>

    <xsl:template match="sp:result">

        <xsl:variable name="serviceTypeName">GA_ServiceType_<xsl:call-template name="substring-after-last">
                <xsl:with-param name="string" select="./sp:binding[@name='serviceType']/sp:uri"/>
                <xsl:with-param name="char" select="'/'"/>
            </xsl:call-template>
        </xsl:variable>

        <cat:codeEntry xmlns:cat="http://standards.iso.org/iso/19115/-3/cat/1.0"
            xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0">
            <cat:CT_CodelistValue id="{$serviceTypeName}">
                <cat:identifier>
                    <gco:ScopedName><xsl:value-of select="$serviceTypeName"/></gco:ScopedName>
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