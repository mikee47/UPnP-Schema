# Get base schema directory. For example:
#	/home/user/Sming/Sming/Libraries/UPnP/schema/schemas-upnp-org/device/MediaServer1.xml
# gives:
#	/home/user/Sming/Sming/Libraries/UPnP/schema/
upnp_schema_dir = $(call dirx,$(call dirx,$(call dirx,$1)))

# Get schema relative to base schema directory. For example:
#	/home/user/Sming/Sming/Libraries/UPnP/schema/schemas-upnp-org/device/MediaServer1.xml
# gives:
#	schemas-upnp-org/device/MediaServer1.xml
upnp_schema_relpath = $(patsubst $(call upnp_schema_dir,$1)/%,%,$1)

