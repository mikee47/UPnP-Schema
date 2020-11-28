<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:d="urn:schemas-upnp-org:device-1-0">
<xsl:import href="common.xsl"/>
<xsl:output method="text" />

<xsl:template match="d:device">
<xsl:variable name="domainCpp"><xsl:call-template name="urn-domain-cpp"/></xsl:variable>
<xsl:variable name="controlClass"><xsl:call-template name="control-class"/>Host</xsl:variable>
<xsl:variable name="templateClass"><xsl:call-template name="template-class"/></xsl:variable>
<xsl:call-template name="file-host"/>
#include &lt;Network/UPnP/<xsl:value-of select="$domainCpp"/>/ClassGroup.h>

namespace UPnP {
namespace <xsl:value-of select="$domainCpp"/> {

class <xsl:value-of select="$controlClass"/>: public device::<xsl:value-of select="$templateClass"/>&lt;<xsl:value-of select="$controlClass"/>>
{
public:
	<xsl:value-of select="$controlClass"/>()
	{
		// TODO: These are your implemented concrete classes, amend as required
		<xsl:for-each select="d:serviceList/d:service">addService(new <xsl:call-template name="control-class-full"/>Host(*this));
		</xsl:for-each>
	}

	String getField(Field desc) const override
	{
		switch(desc) {
		default:
			return <xsl:value-of select="$templateClass"/>::getField(desc);
		}
	}
};

} // namespace <xsl:value-of select="$domainCpp"/>
} // namespace UPnP
</xsl:template>

</xsl:stylesheet>
