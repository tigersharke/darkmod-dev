# Finddoctest.cmake – header-only

find_path(DOCTEST_INCLUDE_DIR
    NAMES doctest/doctest.h
    PATHS ${LOCALBASE}/include
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(doctest
    REQUIRED_VARS DOCTEST_INCLUDE_DIR
)

if(doctest_FOUND AND NOT TARGET doctest::doctest)
    add_library(doctest::doctest INTERFACE IMPORTED)
    set_target_properties(doctest::doctest PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${DOCTEST_INCLUDE_DIR}"
    )
endif()

mark_as_advanced(DOCTEST_INCLUDE_DIR)
