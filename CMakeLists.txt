cmake_minimum_required(VERSION 3.20)

project(asteroid-wifi
	VERSION 1.0.0
	DESCRIPTION "Manage Wi-Fi connection status")

find_package(ECM REQUIRED NO_MODULE)
find_package(AsteroidApp REQUIRED)

set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ASTEROID_MODULE_PATH})

include(FeatureSummary)
include(GNUInstallDirs)
include(ECMFindQmlModule)
include(AsteroidCMakeSettings)
include(AsteroidTranslations)

add_subdirectory(src)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/runscript.in
	${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}
	@ONLY)

install(PROGRAMS ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}
	DESTINATION ${CMAKE_INSTALL_BINDIR})

generate_desktop(${CMAKE_SOURCE_DIR} ${CMAKE_PROJECT_NAME})

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)

set(CMAKE_INSTALL_SO_NO_EXE 0 CACHE INTERNAL "Install .so files with execute permission.")
set(CPACK_GENERATOR "DEB")
string(TOLOWER "${CMAKE_PROJECT_NAME}" lcproject_name)
set(CPACK_DEBIAN_FILE_NAME "${lcproject_name}-${CMAKE_PROJECT_VERSION}.ipk")
set(CPACK_STRIP_FILES TRUE)
if ($ENV{OECORE_TARGET_ARCH} MATCHES "i686")
    set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "qemux86")
else()
    set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "armv7vehf-neon")
endif()
if (NOT CPACK_PACKAGE_CONTACT) 
    set(CPACK_PACKAGE_CONTACT bogus@example.org)
    message(WARNING "No package contact specified: using ${CPACK_PACKAGE_CONTACT}")
endif()
include(CPack)
