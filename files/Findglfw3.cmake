# Findglfw3.cmake – provides glfw (upstream links against plain “glfw”)

find_package(PkgConfig QUIET)
if(PkgConfig_FOUND)
    pkg_check_modules(PC_GLFW3 QUIET glfw3)
endif()

find_path(GLFW3_INCLUDE_DIR
    NAMES GLFW/glfw3.h
    HINTS ${PC_GLFW3_INCLUDEDIR} ${PC_GLFW3_INCLUDE_DIRS}
)

find_library(GLFW3_LIBRARY
    NAMES glfw glfw3
    HINTS ${PC_GLFW3_LIBDIR} ${PC_GLFW3_LIBRARY_DIRS}
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(glfw3
    REQUIRED_VARS GLFW3_LIBRARY GLFW3_INCLUDE_DIR
)

if(glfw3_FOUND)
    if(NOT TARGET glfw)
        add_library(glfw UNKNOWN IMPORTED)
        set_target_properties(glfw PROPERTIES
            IMPORTED_LOCATION "${GLFW3_LIBRARY}"
            INTERFACE_INCLUDE_DIRECTORIES "${GLFW3_INCLUDE_DIR}"
        )
    endif()
    # Also provide the more modern name some projects look for
    if(NOT TARGET glfw3::glfw)
        add_library(glfw3::glfw ALIAS glfw)
    endif()
endif()

mark_as_advanced(GLFW3_INCLUDE_DIR GLFW3_LIBRARY)
