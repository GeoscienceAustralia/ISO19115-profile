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
        
        <labels xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
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
            
            <xsl:apply-templates select=".//cat:CT_Codelist[@id='gapCI_ProtocolTypeCode']"/>

            <xsl:apply-templates select=".//cat:CT_Codelist[@id='gapSV_ServiceTypeCode']"/>
            
        </labels>
   
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
                <xsl:apply-templates select="cat:codeEntry"/>
            </helper>
        </element>
    </xsl:template>

    <xsl:template match="cat:CT_Codelist[@id='gapSV_ServiceTypeCode']">
        
        <!-- Set first letter of description to uppercase -->
        <xsl:variable name="firstChar" select="substring(cat:description/gco:CharacterString,1,1)"/>
        <xsl:variable name="description">
            <xsl:value-of select="translate($firstChar,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/><xsl:value-of select="substring-after(cat:description/gco:CharacterString,$firstChar)"/>
        </xsl:variable>
        
        <element name="cit:serviceType" context="/mdb:MD_Metadata/mdb:distributionInfo/mrd:MD_Distribution/mrd:transferOptions/mrd:MD_DigitalTransferOptions/mrd:onLine/cit:CI_OnlineResource/cit:protocol">
            <label>Service Type</label>
            <description><xsl:value-of select="$description"/></description>
            <helper>
                <xsl:apply-templates select="cat:codeEntry"/>
            </helper>
        </element>
    </xsl:template>
    
    <xsl:template match="cat:codeEntry">
        <!-- Set first letter of description to uppercase -->
        <xsl:variable name="firstChar" select="substring(cat:CT_CodelistValue/cat:description/gco:CharacterString,1,1)"/>
        <xsl:variable name="description">
            <xsl:value-of select="translate($firstChar,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/><xsl:value-of select="substring-after(cat:CT_CodelistValue/cat:description/gco:CharacterString,$firstChar)"/>
        </xsl:variable>
        
        <option value="{cat:CT_CodelistValue/cat:identifier/gco:ScopedName}"><xsl:value-of select="$description"/></option>
    </xsl:template>
    
</xsl:stylesheet>