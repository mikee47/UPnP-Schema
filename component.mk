COMPONENT_DEPENDS := UPnP
COMPONENT_PYTHON_REQUIREMENTS := requirements.txt

COMPONENT_VARS += UPNP_SCHEMA
ifneq (,$(COMPONENT_RULE))
UPNP_SCHEMA := $(wildcard $(addsuffix /schema,$(PROJECT_DIR) $(ALL_COMPONENT_DIRS)))
endif

include $(COMPONENT_PATH)/common.mk

# Create targets for application schema
UPNP_INCDIR			:= $(COMPONENT_BUILD_BASE)/src
COMPONENT_INCDIRS	:= $(UPNP_INCDIR)
UPNP_INCDIR			:= $(UPNP_INCDIR)/Network/UPnP
UPNP_DESCRIPTIONS	:= $(call ListAllFiles,$(UPNP_SCHEMA),*.xml)
UPNP_DESCRIPTIONS	:= $(foreach c,$(UPNP_DESCRIPTIONS),$(call upnp_schema_relpath,$c)) 
UPNP_DIRS			:= $(sort $(call dirx,$(UPNP_DESCRIPTIONS)))
UPNP_GROUPS			:= $(sort $(call dirx,$(UPNP_DIRS)))

COMPONENT_SRCDIRS	:= $(addprefix $(UPNP_INCDIR)/,$(UPNP_GROUPS) $(UPNP_DIRS))

export UPNP_SCHEMA_PATH := $(COMPONENT_PATH)
export UPNP_SCHEMA		:= $(sort $(UPNP_SCHEMA))
UPNP_SCHEMA_BUILD_BASE	:= $(COMPONENT_BUILD_BASE)

COMPONENT_PREREQUISITES := upnp_schema_generate

upnp_schema_generate: | $(UPNP_SCHEMA_BUILD_BASE)
	$(Q) $(MAKE) -C $(UPNP_SCHEMA_BUILD_BASE) -f $(UPNP_SCHEMA_PATH)/generate.mk all

$(UPNP_SCHEMA_BUILD_BASE):
	mkdir -p $@
