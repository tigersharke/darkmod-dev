# Findpugixml.cmake – provides pugixml::pugixml

find_package(PkgConfig QUIET)
if(PkgConfig_FOUND)
    pkg_check_modules(PC_PUGIXML QUIET pugixml)
endif()

find_path(PUGIXML_INCLUDE_DIR
    NAMES pugixml.hpp
    HINTS ${PC_PUGIXML_INCLUDEDIR} ${PC_PUGIXML_INCLUDE_DIRS}
)

find_library(PUGIXML_LIBRARY
    NAMES pugixml
    HINTS ${PC_PUGIXML_LIBDIR} ${PC_PUGIXML_LIBRARY_DIRS}
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(pugixml
    REQUIRED_VARS PUGIXML_LIBRARY PUGIXML_INCLUDE_DIR
)

if(pugixml_FOUND AND NOT TARGET pugixml::pugixml)
    add_library(pugixml::pugixml UNKNOWN IMPORTED)
    set_target_properties(pugixml::pugixml PROPERTIES
        IMPORTED_LOCATION "${PUGIXML_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${PUGIXML_INCLUDE_DIR}"
    )
endif()

mark_as_advanced(PUGIXML_INCLUDE_DIR PUGIXML_LIBRARY)
