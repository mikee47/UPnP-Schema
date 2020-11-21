COMPONENT_DEPENDS := UPnP

UPNP_SCHEMA := $(COMPONENT_PATH)/schema
UPNP_INCDIR := $(COMPONENT_BUILD_BASE)/src/Network/UPnP

COMPONENT_INCDIRS := $(COMPONENT_BUILD_BASE)/src
COMPONENT_SRCDIRS := $(call ListAllSubDirs,$(COMPONENT_BUILD_BASE)/src)

ifneq (,$(COMPONENT_RULE))
# Create targets for library schema source generation
$(eval $(call upnp_generate,$(COMPONENT_PATH)/schema,$(UPNP_INCDIR)))

COMPONENT_PREREQUISITES	:= upnp_schema_prerequisites 

.PHONY: upnp_prerequisites
upnp_schema_prerequisites: $(UPNP_SRCFILES) $(UPNP_INCFILES)

endif
