########### install files ###############

set(icon_dirs
    actions animations applets apps categories preferences devices emblems
    mimetypes places status)

set(ICONS_INSTALL_DIR ${KDE_INSTALL_FULL_ICONDIR}/mycroftmark2)


if(NOT SKIP_INSTALL_ICONS)
    install(DIRECTORY ${icon_dirs} DESTINATION ${ICONS_INSTALL_DIR})
    install(FILES index.theme DESTINATION ${ICONS_INSTALL_DIR})
endif()


