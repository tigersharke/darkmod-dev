# Findtracy.cmake
# Provides the imported target tracy::tracy that TheDarkMod expects.
# Works with FreeBSD's devel/tracy (headers under include/tracy/, libTracyClient.a,
# and an optional CMake package in lib/cmake/Tracy/).

# Prefer the official Config package if present
find_package(Tracy CONFIG QUIET)

if(Tracy_FOUND)
    # Upstream TDM links against the lowercase name
    if(TARGET Tracy::TracyClient AND NOT TARGET tracy::tracy)
        add_library(tracy::tracy ALIAS Tracy::TracyClient)
    elseif(TARGET Tracy::Tracy AND NOT TARGET tracy::tracy)
        add_library(tracy::tracy ALIAS Tracy::Tracy)
    endif()
    set(tracy_FOUND TRUE)
else()
    # Manual fallback (pkg-config + classic find_*)
    find_package(PkgConfig QUIET)
    if(PkgConfig_FOUND)
        pkg_check_modules(PC_TRACY QUIET tracy)
    endif()

    find_path(TRACY_INCLUDE_DIR
        NAMES
            tracy/Tracy.hpp
            tracy/tracy/Tracy.hpp
            Tracy.hpp
        HINTS
            ${PC_TRACY_INCLUDEDIR}
            ${PC_TRACY_INCLUDE_DIRS}
        PATHS
            ${LOCALBASE}/include
            ${LOCALBASE}/include/tracy
        PATH_SUFFIXES
            tracy
    )

    find_library(TRACY_LIBRARY
        NAMES
	    TracyConfig
            TracyClient
            tracy
        HINTS
            ${PC_TRACY_LIBDIR}
            ${PC_TRACY_LIBRARY_DIRS}
        PATHS
            ${LOCALBASE}/lib
            ${LOCALBASE}/lib/cmake
            ${LOCALBASE}/lib/cmake/Tracy
    )

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(tracy
        REQUIRED_VARS TRACY_INCLUDE_DIR
        # library is optional – Tracy can be used header-only
    )

    if(tracy_FOUND AND NOT TARGET tracy::tracy)
        if(TRACY_LIBRARY)
            add_library(tracy::tracy UNKNOWN IMPORTED)
            set_target_properties(tracy::tracy PROPERTIES
                IMPORTED_LOCATION "${TRACY_LIBRARY}"
                INTERFACE_INCLUDE_DIRECTORIES "${TRACY_INCLUDE_DIR}"
            )
        else()
            # header-only fallback
            add_library(tracy::tracy INTERFACE IMPORTED)
            set_target_properties(tracy::tracy PROPERTIES
                INTERFACE_INCLUDE_DIRECTORIES "${TRACY_INCLUDE_DIR}"
            )
        endif()
    endif()
endif()

mark_as_advanced(TRACY_INCLUDE_DIR TRACY_LIBRARY)
