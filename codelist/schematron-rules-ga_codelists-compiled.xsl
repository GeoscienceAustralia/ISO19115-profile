<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:sch="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:cat="http://standards.iso.org/iso/19115/-3/cat/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/1.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                version="1.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. The name or details of 
    this mode may change during 1Q 2007.-->


<!--PHASES-->


<!--PROLOG-->
   <xsl:output method="xml"/>

   <!--KEYS-->


   <!--DEFAULT RULES-->


   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@sch:schema</xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:choose>
         <xsl:when test="count(. | ../namespace::*) = count(../namespace::*)">
            <xsl:value-of select="concat('.namespace::-',1+count(namespace::*),'-')"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>

   <!--SCHEMA METADATA-->
   <xsl:template match="/">
      <xsl:apply-templates select="/" mode="M6"/>
      <xsl:apply-templates select="/" mode="M8"/>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->


   <!--PATTERN Association type code in the metadata must have a corresponding entry in the DS_AssociationTypeCode codelist.-->


	  <!--RULE -->
   <xsl:template match="mri:associationType/mri:DS_AssociationTypeCode"
                 priority="3999"
                 mode="M6">
      <xsl:variable name="assocTypeCode"
                    select="concat('DS_AssociationTypeCode_', @codeListValue)"/>
      <xsl:variable name="URI"
                    select="'http://standards.iso.org/iso/19115/-3/mri/1.0/codelists.xml'"/>
      <xsl:variable name="code-list-document" select="document( $URI )"/>
      <xsl:variable name="assocTypeCodeList"
                    select=" $code-list-document//cat:CT_Codelist[ @id='DS_AssociationTypeCode' ]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$assocTypeCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $assocTypeCode ]"/>
         <xsl:otherwise>
            <xsl:message>fail <xsl:text/>
               <xsl:value-of select="normalize-space($assocTypeCode)"/>
               <xsl:text/>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$assocTypeCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $assocTypeCode ]">
         <xsl:message>pass <xsl:text/>
            <xsl:value-of select="normalize-space($assocTypeCode)"/>
            <xsl:text/>
         </xsl:message>
      </xsl:if>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:choose><!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
         <xsl:when test="not(@*)">
            <xsl:apply-templates select="node()" mode="M6"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="@*|node()" mode="M6"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--PATTERN Online function code in the metadata must have a corresponding entry in the CI_OnLineFunctionCode codelist.-->


	  <!--RULE -->
   <xsl:template match="cit:function/cit:CI_OnLineFunctionCode"
                 priority="3999"
                 mode="M8">
      <xsl:variable name="functionCode"
                    select="concat('CI_OnLineFunctionCode_', @codeListValue)"/>
      <xsl:variable name="URI"
                    select="'http://standards.iso.org/iso/19115/-3/cit/1.0/codelists.xml'"/>
      <xsl:variable name="code-list-document" select="document( $URI )"/>
      <xsl:variable name="functionCodeList"
                    select=" $code-list-document//cat:CT_Codelist[ @id='CI_OnLineFunctionCode' ]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$functionCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $functionCode ]"/>
         <xsl:otherwise>
            <xsl:message>fail <xsl:text/>
               <xsl:value-of select="normalize-space($functionCode)"/>
               <xsl:text/>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--REPORT -->
      <xsl:if test="$functionCodeList/cat:codeEntry/cat:CT_CodelistValue/cat:identifier[ gco:ScopedName = $functionCode ]">
         <xsl:message>pass <xsl:text/>
            <xsl:value-of select="normalize-space($functionCode)"/>
            <xsl:text/>
         </xsl:message>
      </xsl:if>
      <xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:choose><!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
         <xsl:when test="not(@*)">
            <xsl:apply-templates select="node()" mode="M8"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="@*|node()" mode="M8"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>
