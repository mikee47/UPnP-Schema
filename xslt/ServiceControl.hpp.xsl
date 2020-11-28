<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:s="urn:schemas-upnp-org:service-1-0">
<xsl:import href="common.xsl"/>
<xsl:output method="text" />

<!--
	NOTE: Service schema do not normally contain 'serviceType', so the scanner inserts it for our convenience.
 -->

<xsl:template match="s:scpd">
<xsl:variable name="controlClass"><xsl:call-template name="control-class"/></xsl:variable>
<xsl:call-template name="file-control-hpp"/>
<xsl:call-template name="namespace-open"/>

class <xsl:value-of select="$controlClass"/>: public ServiceControl
{
public:
	<xsl:if test="s:serviceStateTable/s:stateVariable[s:allowedValueList]">
	/*
	 * Pre-defined values (from allowed value lists)
	 */
	<xsl:for-each select="s:serviceStateTable/s:stateVariable[s:allowedValueList]">
	struct <xsl:apply-templates select="." mode="name"/> {<xsl:text/>
	<xsl:for-each select="s:allowedValueList/s:allowedValue">
		DEFINE_FSTR_LOCAL(<xsl:apply-templates select="." mode="name"/>, "<xsl:value-of select="."/>")<xsl:text/>
	</xsl:for-each>
	};
	</xsl:for-each>
	</xsl:if>

	using ServiceControl::ServiceControl;

	static const ObjectClass&amp; class_;

	const ObjectClass&amp; getClass() const override
	{
		return class_;
	}

	static Object* createObject(DeviceControl* owner)
	{
		return owner ? new <xsl:value-of select="$controlClass"/>(*owner) : nullptr;
	}

	<xsl:apply-templates select="s:actionList/s:action"/>
};
<xsl:call-template name="namespace-close"/>
</xsl:template>

<xsl:template match="s:action">
	<!-- Declare a struct to contain response arguments, with an appropriate callback delegate type -->
	/**
	 * @brief Action: <xsl:value-of select="s:name"/>
	 * @{
	 */
	struct <xsl:apply-templates select="." mode="name"/> {
		DEFINE_FSTR_LOCAL(actionName, "<xsl:value-of select="s:name"/>")<xsl:text/>
		struct Arg {<xsl:text/>
			<xsl:for-each select="s:argumentList/s:argument">
			DEFINE_FSTR_LOCAL(<xsl:call-template name="varname"/>, "<xsl:value-of select="s:name"/>")<xsl:text/>
			</xsl:for-each>
		};
		class Response: public UPnP::ActionResponse
		{
		public:
			Response(const ActionRequest&amp; request): ActionResponse(request) {}
			Response(const ActionResponse&amp; response): ActionResponse(response) {}

			<xsl:for-each select="s:argumentList/s:argument[s:direction='out']">
			<xsl:apply-templates select="." mode="type"/> get<xsl:call-template name="varname"/>() const
			{
				return ActionResponse::getArg&lt;<xsl:apply-templates select="." mode="type"/>>(Arg::<xsl:call-template name="varname"/>);
			}

			void set<xsl:call-template name="varname"/>(<xsl:apply-templates select="." mode="type"><xsl:with-param name="const" select="1"/></xsl:apply-templates> value) const
			{
				ActionResponse::setArg(Arg::<xsl:call-template name="varname"/>, value);
			}
			</xsl:for-each>
			size_t printTo(Print&amp; p);
		};
		using Callback = Delegate&lt;void(Response response)>;<xsl:text/>
	};

	bool <xsl:apply-templates select="." mode="method"/>;
	/** @} */
</xsl:template>


</xsl:stylesheet>
