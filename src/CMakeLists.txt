# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2023 Erick Muuo <hearteric57@gmail.com>

add_executable(citam
    main.cpp
    app.cpp
    resources.qrc
    controller.h controller.cpp
    controllers/logincontroller.h controllers/logincontroller.cpp
    models/user.h models/user.cpp
    services/service.h services/service.cpp
    constants/constants.h
    services/userservice.h services/userservice.cpp)

target_link_libraries(citam
    Qt5::Core
    Qt5::Gui
    Qt5::Qml
    Qt5::Quick
    Qt5::QuickControls2
    Qt5::Svg
    KF5::I18n
    KF5::CoreAddons
    KF5::ConfigCore
    KF5::ConfigGui)

if (ANDROID)
    kirigami_package_breeze_icons(ICONS
        list-add
        help-about
        application-exit
        applications-graphics
    )
endif()

kconfig_add_kcfg_files(citam GENERATE_MOC citamconfig.kcfgc)
install(TARGETS citam ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
