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

		<html lang="en">
			
		   <head>
		      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		      <title> GA Profile codelist for protocol element in the Citation (cit) Namespace </title>
		   </head>
		   <body><a name="top"></a><h1>ISO 19115-3 Codelist Report</h1>
		      <h2> Geoscience Australia Profile codelist for protocol element in the Citation (cit) Namespace </h2>
		      <table>
		         <tr>
		            <b>
		               <td>Scope</td></b>
		            <td> Codelist applied to the cit:protocol element by the GA Profile </td>
		         </tr>
		         <tr>
		            <b>
		               <td>Field of Application</td></b>
		            <td> ISO TC211 Metadata Standards </td>
		         </tr>
		         <tr>
		            <b>
		               <td>Version (Date)</td></b>
		            <td> see repository version (<xsl:value-of select="date:year()"/>-<xsl:value-of select="format-number(date:month-in-year(),'00')"/>-<xsl:value-of select="format-number(date:day-in-month(),'00')"/>) </td>
		         </tr>
		      </table>
		      
		      <h2> gapCI_ProtocolTypeCode ( gapCI_ProtocolTypeCode ): </h2>
		      <b>Description: </b> connection protocol to be used
		      <table width="95%" border="1" cellpadding="2" cellspacing="2">
		      	<tr>
            		<th valign="top">Entry</th>
            		<th valign="top">Source</th>
            		<th valign="top">Definition</th>
         		</tr>
		      
		      	<xsl:apply-templates select=".//sp:result"/>
		      	
		      </table>
			</body>
		</html>
    </xsl:template>

    <xsl:template match="sp:result">
        
        <!-- Obtain string in last part of URI path -->
        <xsl:variable name="protocolTypeName">gapCI_ProtocolTypeCode_<xsl:call-template name="substring-after-last">
                <xsl:with-param name="string" select="normalize-space(./sp:binding[@name='altLabel']/sp:literal)"/>
                <xsl:with-param name="char" select="'/'"/>
            </xsl:call-template>
        </xsl:variable>
        
        <tr>
            <td valign="top"> <xsl:value-of select="$protocolTypeName"/> </td>
            <td valign="top"> <xsl:value-of select="normalize-space(.//sp:binding[@name='source']/sp:literal)"/> </td>
            <td valign="top"> <xsl:value-of select="normalize-space(.//sp:binding[@name='definition']/sp:literal)"/> </td>
        </tr>

    </xsl:template>
    
    <!-- Routine to obtain substring after last occurrence of a separator -->
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