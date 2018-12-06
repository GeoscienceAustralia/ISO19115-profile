<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:cat="http://standards.iso.org/iso/19115/-3/cat/1.0"
    xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
    xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:gml="http://www.opengis.net/gml/3.2"
    
    exclude-result-prefixes="xsl cat lan gco xlink gml xs"
    version="1.0">
    
	<xsl:output method="xml" encoding="utf-8" version="" indent="yes" standalone="no" media-type="text/html" omit-xml-declaration="yes" />
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="//cat:CT_Codelist">
    	<delete_this_tag> <!-- A single root tag is needed by python lxml XSLT transforms - to be removed after transform by calling python routine -->
    		<a><xsl:attribute name="href"><xsl:value-of select='normalize-space(./cat:identifier/gco:ScopedName)'/></xsl:attribute></a>
			<h2><xsl:value-of select='normalize-space(./cat:identifier/gco:ScopedName)'/></h2>
	  		<b>Description: </b><xsl:value-of select='normalize-space(./cat:description/gco:CharacterString)'/><br/>
	  		<b>CodeSpace: </b><xsl:value-of select='normalize-space(./cat:identifier/gco:ScopedName/@codeSpace)'/><br/>
	  		<b>Number of items: </b><xsl:value-of select="count(./cat:codeEntry)"/>
	   		<table width="95%" border="1" cellpadding="2" cellspacing="2">
	      		<tr>
	         		<th valign="top">Entry</th>
	         		<th valign="top">Definition</th>
	      		</tr>
	      		<xsl:apply-templates select="./cat:codeEntry"/>
	   		</table>
	   		<a href="#top">top</a>
   		</delete_this_tag>

    </xsl:template>

    <xsl:template match="cat:codeEntry">
      <tr>
         <td valign="top"><xsl:value-of select='normalize-space(./cat:CT_CodelistValue/cat:name/gco:ScopedName)'/></td>
         <td valign="top"><xsl:value-of select='normalize-space(./cat:CT_CodelistValue/cat:definition/gco:CharacterString)'/></td>
      </tr>
    </xsl:template>
    
</xsl:stylesheet>