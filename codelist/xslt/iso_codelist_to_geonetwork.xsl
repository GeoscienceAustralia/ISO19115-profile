<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cat="http://standards.iso.org/iso/19115/-3/cat/1.0"
    xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="cat gco xs"
    version="1.0">
    
    <!-- ================================================================================================================
    This template transforms Geoscience Australia Profile of ISO 19115-1:2014 codelists from the ISO CAT 1.0 XML 
    format to GeoNetwork specific XML formats that enable the codelists to be implemented as pick lists in the GeoNetwork
    metadata entry forms.
    
    The template generates four different outputs, one for each of the four codelists extended or introduced by the GA 
    Profile.  Outputs for the extended codelists (gapDS_AssociationTypeCode, gapCI_OnLineFunctionCode) comprise XML 
    fragments to replace the corresponding codelist entries in the codelists.xml file within the GN application.  Outputs 
    for codelists introduced by the GA Profile (gapCI_ProtocolTypeCode, gapSV_ServiceTypeCode) comprise XML fragments to 
    be appended to the labels.xml file within the GN application.  
        
    This script was developed by Geoscience Australia, initial version December 2018.
    =====================================================================================================================
    History:
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    DATE            VERSION     AUTHOR              DESCRIPTION
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    2018-12-20      0.1         Aaron Sedgmen       Initial Version.
    ===================================================================================================================== -->
    
    <xsl:output method="xml" encoding="utf-8" version="" indent="yes" standalone="no" media-type="text/html" omit-xml-declaration="yes" />
    <xsl:strip-space elements="*"/>
    
    <xsl:param name="codelistName"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select=".//cat:codelistItem"/>
    </xsl:template>
    
    <xsl:template match="cat:codelistItem">
        <xsl:choose>
            <xsl:when test="$codelistName='gapCI_ProtocolTypeCode'">
                <xsl:apply-templates select="cat:CT_Codelist[@id='gapCI_ProtocolTypeCode']"/>
            </xsl:when>
            <xsl:when test="$codelistName='gapSV_ServiceTypeCode'">
                <xsl:apply-templates select="cat:CT_Codelist[@id='gapSV_ServiceTypeCode']"/>
            </xsl:when>
            <xsl:when test="$codelistName='gapDS_AssociationTypeCode'">
                <xsl:apply-templates select="cat:CT_Codelist[@id='gapDS_AssociationTypeCode']"/>
            </xsl:when>
            <xsl:when test="$codelistName='gapCI_OnLineFunctionCode'">
                <xsl:apply-templates select="cat:CT_Codelist[@id='gapCI_OnLineFunctionCode']"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="cat:CT_Codelist[@id='gapCI_ProtocolTypeCode']">
        
        <!-- Set first letter of description to uppercase -->
        <xsl:variable name="firstChar" select="substring(cat:description/gco:CharacterString,1,1)"/>
        <xsl:variable name="description">
            <xsl:value-of select="translate($firstChar,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/><xsl:value-of select="substring-after(cat:description/gco:CharacterString,$firstChar)"/>
        </xsl:variable>
        
        <element name="cit:protocol" context="/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:transferOptions/mrd:MD_DigitalTransferOptions/mrd:onLine/cit:CI_OnlineResource/cit:protocol">
            <label>Protocol</label>
            <description><xsl:value-of select="$description"/></description>
            <helper>
                <xsl:apply-templates select="cat:codeEntry">
                    <xsl:with-param name="output">labels</xsl:with-param>
                </xsl:apply-templates>
            </helper>
        </element>
    </xsl:template>

    <xsl:template match="cat:CT_Codelist[@id='gapSV_ServiceTypeCode']">
        
        <!-- Set first letter of description to uppercase -->
        <xsl:variable name="firstChar" select="substring(cat:description/gco:CharacterString,1,1)"/>
        <xsl:variable name="description">
            <xsl:value-of select="translate($firstChar,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/><xsl:value-of select="substring-after(cat:description/gco:CharacterString,$firstChar)"/>
        </xsl:variable>
        
        <element name="srv:serviceType" context="srv:SV_ServiceIdentification">
            <label>Service Type</label>
            <description><xsl:value-of select="$description"/></description>
            <helper>
                <xsl:apply-templates select="cat:codeEntry">
                    <xsl:with-param name="output">labels</xsl:with-param>
                </xsl:apply-templates>
            </helper>
        </element>
    </xsl:template>

    <xsl:template match="cat:CT_Codelist[@id='gapDS_AssociationTypeCode']">
        
        <codelist name="mri:DS_AssociationTypeCode">
            <xsl:apply-templates select="cat:codeEntry">
                <xsl:with-param name="output">codelists</xsl:with-param>
            </xsl:apply-templates>
        </codelist>
        
    </xsl:template>

    <xsl:template match="cat:CT_Codelist[@id='gapCI_OnLineFunctionCode']">
        
        <codelist name="cit:CI_OnLineFunctionCode">
            <xsl:apply-templates select="cat:codeEntry">
                <xsl:with-param name="output">codelists</xsl:with-param>
            </xsl:apply-templates>
        </codelist>
        
    </xsl:template>
    
    <xsl:template match="cat:codeEntry">
        <xsl:param name="output"/>
        
        <!-- Set first letter of description to uppercase -->
        <xsl:variable name="firstChar" select="substring(cat:CT_CodelistValue/cat:description/gco:CharacterString,1,1)"/>
        <xsl:variable name="description">
            <xsl:value-of select="translate($firstChar,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/><xsl:value-of select="substring-after(cat:CT_CodelistValue/cat:description/gco:CharacterString,$firstChar)"/>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$output='labels'">
                <option value="{cat:CT_CodelistValue/cat:identifier/gco:ScopedName}"><xsl:value-of select="$description"/></option>
            </xsl:when>
            <xsl:otherwise>
                <entry>
                    <code><xsl:value-of select='cat:CT_CodelistValue/cat:identifier/gco:ScopedName'/></code>
                    
                    <!-- Convert name, to be used in the label, from camelcase to spaced -->
                    <xsl:variable name="label_preliminary">
                        <xsl:call-template name="SplitCamelCase">
                            <xsl:with-param name="text" select="./cat:CT_CodelistValue/cat:name/gco:ScopedName"/>
                        </xsl:call-template>
                    </xsl:variable>
                    
                    <!-- Set first letter of label to uppercase -->
                    <xsl:variable name="labelFirstChar" select="substring($label_preliminary,1,1)"/>
                    <xsl:variable name="label">
                        <xsl:value-of select="translate($labelFirstChar,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/><xsl:value-of select="substring-after($label_preliminary,$labelFirstChar)"/>
                    </xsl:variable>
                    
                    <label><xsl:value-of select='$label'/></label>
                    <description><xsl:value-of select='$description'/></description>
                </entry>
            </xsl:otherwise>
        </xsl:choose>
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