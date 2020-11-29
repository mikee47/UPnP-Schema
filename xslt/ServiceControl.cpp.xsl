<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:s="urn:schemas-upnp-org:service-1-0">
<xsl:import href="common.xsl"/>
<xsl:output method="text"/>

<xsl:template match="s:scpd">
<xsl:variable name="controlClass"><xsl:call-template name="control-class"/></xsl:variable>
<xsl:call-template name="file-cpp"/>
<xsl:call-template name="namespace-open"/>

<xsl:for-each select="s:actionList/s:action">

<xsl:if test="s:argumentList/s:argument[s:direction='out']">
size_t <xsl:value-of select="$controlClass"/>::<xsl:apply-templates select="." mode="name"/>::Response::printTo(Print&amp; p)
{
	size_t n{0};
	<xsl:for-each select="s:argumentList/s:argument[s:direction='out']">
	n += p.print(Arg::<xsl:call-template name="varname"/>);
	n += p.print(" = ");
	n += p.println(get<xsl:call-template name="varname"/>());
	</xsl:for-each>
	return n;
}
</xsl:if>


bool <xsl:value-of select="$controlClass"/>::<xsl:apply-templates select="." mode="method"/>
{
	<!-- Build request and send it, using a lambda wrapper for response handling -->
	<xsl:variable name="action"><xsl:apply-templates select="." mode="name"/></xsl:variable>
	ActionRequestControl request(*this, <xsl:value-of select="$action"/>::actionName);
	<xsl:for-each select="s:argumentList/s:argument[s:direction='in']">
	request.setArg(<xsl:value-of select="$action"/>::Arg::<xsl:call-template name="varname"/>, <xsl:call-template name="varname-cpp"/>);<xsl:text/>
	</xsl:for-each>
	return request.send(callback ? [callback](ActionResponse response) { callback(response); } : ActionRequestControl::Callback());
}
</xsl:for-each>

<xsl:call-template name="namespace-close"/>

</xsl:template>



</xsl:stylesheet>
