# files/Findtracy.cmake
# Provides tracy::tracy for TheDarkMod.
# FreeBSD devel/tracy installs:
#   headers under include/tracy/
#   libTracyClient.a
#   lib/cmake/Tracy/TracyConfig.cmake  (capital T)

# Prefer the official Config package if present
find_package(Tracy CONFIG QUIET)

if(Tracy_FOUND)
    if(TARGET Tracy::TracyClient AND NOT TARGET tracy::tracy)
        add_library(tracy::tracy ALIAS Tracy::TracyClient)
    elseif(TARGET tracy::Tracy AND NOT TARGET tracy::tracy)
        add_library(tracy::tracy ALIAS tracy::Tracy)
    elseif(TARGET Tracy::Tracy AND NOT TARGET tracy::tracy)
        add_library(tracy::tracy ALIAS Tracy::Tracy)
    elseif(TARGET Tracy::tracy AND NOT TARGET tracy::tracy)
        add_library(tracy::tracy ALIAS Tracy::tracy)
    endif()
    set(tracy_FOUND TRUE)
    return()
endif()

# Manual fallback if the Config package is missing
find_path(TRACY_INCLUDE_DIR
    NAMES tracy/Tracy.hpp Tracy.hpp
    PATHS
        ${LOCALBASE}/include
        ${LOCALBASE}/include/tracy
)

find_library(TRACY_LIBRARY
    NAMES TracyClient tracy
    PATHS ${LOCALBASE}/lib
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(tracy
    REQUIRED_VARS TRACY_INCLUDE_DIR
)

if(tracy_FOUND AND NOT TARGET tracy::tracy)
    if(TRACY_LIBRARY)
        add_library(tracy::tracy UNKNOWN IMPORTED)
        set_target_properties(tracy::tracy PROPERTIES
            IMPORTED_LOCATION "${TRACY_LIBRARY}"
            INTERFACE_INCLUDE_DIRECTORIES "${TRACY_INCLUDE_DIR}"
        )
    else()
        add_library(tracy::tracy INTERFACE IMPORTED)
        set_target_properties(tracy::tracy PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${TRACY_INCLUDE_DIR}"
        )
    endif()
endif()

mark_as_advanced(TRACY_INCLUDE_DIR TRACY_LIBRARY)
