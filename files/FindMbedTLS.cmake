# FindMbedTLS.cmake – provides MbedTLS::mbedtls for TheDarkMod
# FreeBSD security/mbedtls4 installs a combined libmbedtls

find_package(PkgConfig QUIET)
if(PkgConfig_FOUND)
    pkg_check_modules(PC_MBEDTLS QUIET mbedtls)
endif()

find_path(MBEDTLS_INCLUDE_DIR
    NAMES mbedtls/ssl.h
    HINTS ${PC_MBEDTLS_INCLUDEDIR} ${PC_MBEDTLS_INCLUDE_DIRS}
    PATHS ${LOCALBASE}/include
)

find_library(MBEDTLS_LIBRARY
    NAMES mbedtls
    HINTS ${PC_MBEDTLS_LIBDIR} ${PC_MBEDTLS_LIBRARY_DIRS}
    PATHS ${LOCALBASE}/lib
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MbedTLS
    REQUIRED_VARS MBEDTLS_LIBRARY MBEDTLS_INCLUDE_DIR
    VERSION_VAR PC_MBEDTLS_VERSION
)

if(MbedTLS_FOUND AND NOT TARGET MbedTLS::mbedtls)
    add_library(MbedTLS::mbedtls UNKNOWN IMPORTED)
    set_target_properties(MbedTLS::mbedtls PROPERTIES
        IMPORTED_LOCATION "${MBEDTLS_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${MBEDTLS_INCLUDE_DIR}"
    )
endif()

mark_as_advanced(MBEDTLS_INCLUDE_DIR MBEDTLS_LIBRARY)
