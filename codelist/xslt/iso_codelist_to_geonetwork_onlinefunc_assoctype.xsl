<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cat="http://standards.iso.org/iso/19115/-3/cat/1.0"
    xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="1.0">
    
    <xsl:output method="xml" encoding="utf-8" version="" indent="yes" standalone="no" media-type="text/html" omit-xml-declaration="yes" />
    <xsl:strip-space elements="*"/>
  
    <xsl:template match="/">
        
        <codelists xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:cat="http://standards.iso.org/iso/19115/-3/cat/1.0"
            xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/1.0"
            xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
            xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
            xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
            xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.0"
            xmlns:mas="http://standards.iso.org/iso/19115/-3/mas/1.0"
            xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
            xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
            xmlns:mda="http://standards.iso.org/iso/19115/-3/mda/1.0"
            xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/1.0"
            xmlns:mds="http://standards.iso.org/iso/19115/-3/mds/1.0"
            xmlns:reg="http://standards.iso.org/iso/19135/-2/reg/1.0"
            xmlns:mdt="http://standards.iso.org/iso/19115/-3/mdt/1.0"
            xmlns:mex="http://standards.iso.org/iso/19115/-3/mex/1.0"
            xmlns:mmi="http://standards.iso.org/iso/19115/-3/mmi/1.0"
            xmlns:mpc="http://standards.iso.org/iso/19115/-3/mpc/1.0"
            xmlns:mrc="http://standards.iso.org/iso/19115/-3/mrc/1.0"
            xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
            xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
            xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/1.0"
            xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
            xmlns:msr="http://standards.iso.org/iso/19115/-3/msr/1.0"
            xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
            xmlns:mac="http://standards.iso.org/iso/19115/-3/mac/1.0"
            xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
            xmlns:gml="http://www.opengis.net/gml/3.2"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xsi:noNamespaceSchemaLocation="../../../../../../../schema-labels.xsd">
            
            <xsl:apply-templates select=".//cat:codelistItem"/>
            
        </codelists>
        
    </xsl:template>
    
    <xsl:template match="cat:codelistItem">
        
        <codelist name="{cat:CT_Codelist/@id}">
            <xsl:apply-templates select=".//cat:codeEntry"/>
        </codelist>
        
    </xsl:template>

    <xsl:template match="cat:codeEntry">
        
        <entry>
            <code><xsl:value-of select='./cat:CT_CodelistValue/cat:identifier/gco:ScopedName'/></code>
        
            <xsl:choose>
                <xsl:when test="(../@id='gapDS_AssociationTypeCode') or (../@id='gapCI_OnLineFunctionCode')">
                    <!-- Convert name, to be used in the label, from camelcase to spaced -->
                    <xsl:variable name="label_preliminary">
                        <xsl:call-template name="SplitCamelCase">
                            <xsl:with-param name="text" select="./cat:CT_CodelistValue/cat:name/gco:ScopedName"/>
                        </xsl:call-template>
                    </xsl:variable>
                    
                    <!-- Set first letter of label to uppercase -->
                    <xsl:variable name="firstChar" select="substring($label_preliminary,1,1)"/>
                    <xsl:variable name="label">
                        <xsl:value-of select="translate($firstChar,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/><xsl:value-of select="substring-after($label_preliminary,$firstChar)"/>
                    </xsl:variable>
                    
                        <label><xsl:value-of select='$label'/></label>
                    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="label" select='./cat:CT_CodelistValue/cat:name/gco:ScopedName'/>
                    
                        <label><xsl:value-of select='$label'/></label>
                    
                </xsl:otherwise>
            </xsl:choose>

            <!-- Set first letter of description to uppercase -->
            <xsl:variable name="firstChar" select="substring(./cat:CT_CodelistValue/cat:description/gco:CharacterString,1,1)"/>
            <xsl:variable name="description">
                <xsl:value-of select="translate($firstChar,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/><xsl:value-of select="substring-after(./cat:CT_CodelistValue/cat:description/gco:CharacterString,$firstChar)"/>
            </xsl:variable>
        
            <description><xsl:value-of select='$description'/></description>
        </entry>
        
    </xsl:template>

    <xsl:template name="SplitCamelCase">
        <xsl:param name="text" />
        <xsl:param name="digitsMode" select="0" />
        <xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
        <xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
        <xsl:variable name="digits">0123456789</xsl:variable>
        
        <xsl:if test="$text != ''">
            <xsl:variable name="letter" select="substring($text, 1, 1)" />
            <xsl:choose>
                <xsl:when test="contains($upper, $letter)">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="translate($letter, $upper, $lower)" />
                </xsl:when>
                <xsl:when test="contains($digits, $letter)">
                    <xsl:choose>
                        <xsl:when test="$digitsMode != 1">
                            <xsl:text> </xsl:text>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:value-of select="$letter" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$letter"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="SplitCamelCase">
                <xsl:with-param name="text" select="substring-after($text, $letter)" />
                <xsl:with-param name="digitsMode" select="contains($digits, $letter)" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>