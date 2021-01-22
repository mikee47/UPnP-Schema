include $(SMING_HOME)/build.mk
include $(UPNP_SCHEMA_PATH)/common.mk

UPNP_GENERATE := $(PYTHON) $(UPNP_SCHEMA_PATH)/tools/gen.py
UPNP_XSLT := $(UPNP_SCHEMA_PATH)/xslt

# Generate header or source for a device or service schema
# $< -> Source .xml file path
# $@ -> Output file
# $1 -> Template kind (hpp or cpp)
define upnp_generate_template
	$$(info UPnP generate $$(<F) -> $$(@F))
	$(Q) $(UPNP_GENERATE) -t $(UPNP_XSLT)/$$(if $$(findstring /device/,$$<),Device,Service)$1.xsl -i $$< -o $$@
endef

# Internal function to generate source creation targets
# $1 -> Name of .xml schema, no path
# $2 -> Directory for schema
# $3 -> Directory for output source code
define upnp_generate_target
UPNP_INCFILES += $3$(1:.xml=Template.h)
$3$(1:.xml=Template.h): $2$1
	$(call upnp_generate_template,Template)

UPNP_INCFILES += $3$(1:.xml=Host.h)
$3$(1:.xml=Host.h): $2$1
	$(call upnp_generate_template,Host)

UPNP_INCFILES += $3$(1:.xml=.h)
$3$(1:.xml=.h): $2$1
	$(call upnp_generate_template,Control.hpp)

UPNP_SRCFILES += $3$(1:.xml=.cpp)
$3$(1:.xml=.cpp): $2$1
	$(call upnp_generate_template,Control.cpp)
endef

# Generate group class info target
# $1 -> Path to domain schema directory
# $2 -> Directory for output
define upnp_generate_group_target
UPNP_INCFILES += $2/ClassGroup.h
$2/ClassGroup.h:
	$$(info UPnP generate $$@)
	$(Q) $$(UPNP_GENERATE) -t $$(UPNP_XSLT)/ClassGroup.hpp.xsl -i $1 -o $$@

UPNP_SRCFILES += $2/ClassGroup.cpp
$2/ClassGroup.cpp:
	$(Q) $$(UPNP_GENERATE) -t $$(UPNP_XSLT)/ClassGroup.cpp.xsl -i $1 -o $$@
endef

# Create targets for application schema
UPNP_INCDIR			:= src
UPNP_INCDIR			:= $(UPNP_INCDIR)/Network/UPnP
UPNP_SRCFILES		:=
UPNP_INCFILES		:=
UPNP_DESCRIPTIONS	:= $(call ListAllFiles,$(UPNP_SCHEMA),*.xml)
UPNP_GROUPS			:= $(sort $(call dirx,$(call dirx,$(UPNP_DESCRIPTIONS))))
$(foreach c,$(UPNP_DESCRIPTIONS),$(eval $(call upnp_generate_target,$(notdir $c),$(dir $c),$(UPNP_INCDIR)/$(call upnp_schema_relpath,$(dir $c)))))
$(foreach d,$(UPNP_GROUPS),$(eval $(call upnp_generate_group_target,$d,$(UPNP_INCDIR)/$(notdir $d))))

.PHONY: all
all: $(UPNP_SRCFILES) $(UPNP_INCFILES)
