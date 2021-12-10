########### install files ###############
# Disabling categories as they don't exist
# For adding categories add them to set()
# Disabled categories "animations applets apps categories preferences devices emblems mimetypes places status"

set(icon_dirs actions)

set(ICONS_INSTALL_DIR ${KDE_INSTALL_FULL_ICONDIR}/mycroftmark2)


if(NOT SKIP_INSTALL_ICONS)
    install(DIRECTORY ${icon_dirs} DESTINATION ${ICONS_INSTALL_DIR})
    install(FILES index.theme DESTINATION ${ICONS_INSTALL_DIR})
endif()


