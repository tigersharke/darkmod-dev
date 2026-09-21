# FindOgg.cmake – minimal pkg-config based module that provides Ogg::ogg
# Compatible with upstream TheDarkMod which does target_link_libraries(... Ogg::ogg)

find_package(PkgConfig QUIET)
if(PkgConfig_FOUND)
    pkg_check_modules(PC_OGG QUIET ogg)
endif()

find_path(OGG_INCLUDE_DIR
    NAMES ogg/ogg.h
    HINTS ${PC_OGG_INCLUDEDIR} ${PC_OGG_INCLUDE_DIRS}
    PATH_SUFFIXES include
)

find_library(OGG_LIBRARY
    NAMES ogg
    HINTS ${PC_OGG_LIBDIR} ${PC_OGG_LIBRARY_DIRS}
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Ogg
    REQUIRED_VARS OGG_LIBRARY OGG_INCLUDE_DIR
    VERSION_VAR PC_OGG_VERSION
)

if(Ogg_FOUND AND NOT TARGET Ogg::ogg)
    add_library(Ogg::ogg UNKNOWN IMPORTED)
    set_target_properties(Ogg::ogg PROPERTIES
        IMPORTED_LOCATION "${OGG_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${OGG_INCLUDE_DIR}"
    )
    if(PC_OGG_CFLAGS_OTHER)
        set_property(TARGET Ogg::ogg PROPERTY
            INTERFACE_COMPILE_OPTIONS "${PC_OGG_CFLAGS_OTHER}")
    endif()
endif()

mark_as_advanced(OGG_INCLUDE_DIR OGG_LIBRARY)
