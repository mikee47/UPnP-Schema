<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:s="urn:schemas-upnp-org:service-1-0">
<xsl:import href="common.xsl"/>
<xsl:output method="text" />

<xsl:template match="s:scpd">
<xsl:variable name="controlClass"><xsl:call-template name="control-class"/>Host</xsl:variable>
<xsl:variable name="templateClass"><xsl:call-template name="template-class"/></xsl:variable>
<xsl:call-template name="file-host"/>
#include "<xsl:value-of select="$controlClass"/>.h"
namespace UPnP {
namespace <xsl:call-template name="urn-domain-cpp"/> {

class <xsl:value-of select="$controlClass"/>: public service::<xsl:value-of select="$templateClass"/>&lt;<xsl:value-of select="$controlClass"/>>
{
public:
	using <xsl:value-of select="concat($templateClass, '::', $templateClass)"/>;

	String getField(Field desc) const override
	{
		switch(desc) {
		default:
			return <xsl:value-of select="$templateClass"/>::getField(desc);
		}
	}

	<xsl:for-each select="s:actionList/s:action">
	bool <xsl:apply-templates select="." mode="method"><xsl:with-param name="result" select="'Response response'"/></xsl:apply-templates>
	{
		// todo
		return Error::ActionNotImplemented;
	}
	</xsl:for-each>
};

} // namespace <xsl:call-template name="urn-domain-cpp"/>
} // namespace UPnP
</xsl:template>

</xsl:stylesheet>
