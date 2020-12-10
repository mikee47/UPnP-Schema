<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:d="urn:schemas-upnp-org:device-1-0"
	xmlns:s="urn:schemas-upnp-org:service-1-0">
<xsl:import href="common.xsl"/>
<xsl:output method="text" />

<xsl:template match="root">

<xsl:variable name="domain">
<xsl:for-each select="(s:scpd | d:device)[position()=1]"><xsl:call-template name="urn-domain"/></xsl:for-each>
</xsl:variable>

<xsl:variable name="domain-cpp">
<xsl:for-each select="(s:scpd | d:device)[position()=1]"><xsl:call-template name="urn-domain-cpp"/></xsl:for-each>
</xsl:variable>

/**
 * @brief Class information for "<xsl:value-of select="$domain"/>"
 *
 * @note This file is auto-generated ** DO NOT EDIT **
 */

#include "ClassGroup.h"
#include &lt;Network/UPnP/ControlPoint.h>

namespace UPnP {
namespace <xsl:value-of select="$domain-cpp"/> {

DEFINE_FSTR_LOCAL(domain_, "<xsl:value-of select="$domain"/>");

const FlashString&amp; domain()
{
	return domain_;
}


<xsl:for-each select="s:scpd | d:device">
<xsl:variable name="urnKind"><xsl:call-template name="urn-kind"/></xsl:variable>
<xsl:variable name="controlClass"><xsl:call-template name="control-class"/></xsl:variable>
namespace <xsl:value-of select="$urnKind"/> {
namespace <xsl:value-of select="concat($controlClass, 'ClassInfo')"/> {
DEFINE_FSTR_LOCAL(type_, "<xsl:call-template name="urn-type"/>");

<xsl:if test="$urnKind = 'service'">
DEFINE_FSTR_LOCAL(serviceId_, "<xsl:value-of select="s:serviceId"/>");
IMPORT_FSTR_LOCAL(<xsl:value-of select="concat($controlClass, 'Schema')"/>, "<xsl:value-of select="@schema"/>")
constexpr ObjectClass::Service service_ PROGMEM = {
	.serviceId = &amp;serviceId_,
	.schema = &amp;<xsl:value-of select="concat($controlClass, 'Schema')"/>,
};
static_assert(std::is_pod&lt;decltype(service_)>::value, "ObjectClass::Service structure not POD");                                       
</xsl:if>

<xsl:if test="$urnKind = 'device'">
DEFINE_FSTR_LOCAL(friendlyName_, "<xsl:value-of select="d:friendlyName"/>");
DEFINE_FSTR_LOCAL(manufacturer_, "<xsl:value-of select="d:manufacturer"/>");
DEFINE_FSTR_LOCAL(manufacturerURL_, "<xsl:value-of select="d:manufacturerURL"/>");
DEFINE_FSTR_LOCAL(modelDescription_, "<xsl:value-of select="d:modelDescription"/>");
DEFINE_FSTR_LOCAL(modelName_, "<xsl:value-of select="d:modelName"/>");
DEFINE_FSTR_LOCAL(modelNumber_, "<xsl:value-of select="d:modelNumber"/>");
DEFINE_FSTR_LOCAL(modelURL_, "<xsl:value-of select="d:modelURL"/>");
DEFINE_FSTR_LOCAL(serialNumber_, "<xsl:value-of select="d:serialNumber"/>");
DEFINE_FSTR_LOCAL(UDN_, "<xsl:value-of select="d:UDN"/>");
constexpr ObjectClass::Device device_ PROGMEM = {
	.friendlyName = &amp;friendlyName_,
	.manufacturer = &amp;manufacturer_,
	.manufacturerURL = &amp;manufacturerURL_,
	.modelDescription = &amp;modelDescription_,
	.modelName = &amp;modelName_,
	.modelNumber = &amp;modelNumber_,
	.modelURL = &amp;modelURL_,
	.serialNumber = &amp;serialNumber_,
	.UDN = &amp;UDN_,
};
</xsl:if>

} // namespace <xsl:value-of select="concat($controlClass, 'ClassInfo')"/>

constexpr ObjectClass <xsl:value-of select="concat($controlClass, '::class_')"/> PROGMEM = {
	.kind_ = Urn::Kind::<xsl:value-of select="$urnKind"/>,
	.version_ = <xsl:call-template name="urn-version"/>,
	.domain_ = &amp;domain_,
	.type_ = &amp;<xsl:value-of select="concat($controlClass, 'ClassInfo')"/>::type_,
	.createObject_ = <xsl:value-of select="concat($controlClass, '::createObject')"/>,
	<xsl:if test="$urnKind = 'service'">
	{.service_ = &amp;<xsl:value-of select="concat($controlClass, 'ClassInfo')"/>::service_}
	</xsl:if>
	<xsl:if test="$urnKind = 'device'">
	{.device_ = &amp;<xsl:value-of select="concat($controlClass, 'ClassInfo')"/>::device_}
	</xsl:if>
};

static_assert(std::is_pod&lt;decltype(<xsl:value-of select="concat($controlClass, '::class_')"/>)>::value, "ObjectClass structure not POD");                                       

} // namespace <xsl:value-of select="$urnKind"/>


</xsl:for-each>

DEFINE_FSTR_VECTOR_LOCAL(classes, ObjectClass,
	<xsl:for-each select="s:scpd | d:device">&amp;<xsl:call-template name="urn-kind"/>::<xsl:call-template name="control-class"/>::class_,
	</xsl:for-each>)

void registerClasses()
{
	ControlPoint::registerClasses(domain_, classes);
}

} // namespace <xsl:value-of select="$domain-cpp"/>
} // namespace UPnP

</xsl:template>

</xsl:stylesheet>
