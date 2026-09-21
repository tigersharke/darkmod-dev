# Findminizip.cmake – provide minizip::minizip from minizip-ng

find_package(PkgConfig QUIET)
if(PkgConfig_FOUND)
    pkg_check_modules(PC_MINIZIP QUIET minizip-ng)
endif()

find_path(MINIZIP_INCLUDE_DIR
    NAMES minizip-ng/mz.h mz.h minizip/zip.h zip.h
    HINTS ${PC_MINIZIP_INCLUDEDIR} ${PC_MINIZIP_INCLUDE_DIRS}
    PATH_SUFFIXES minizip-ng minizip
)

find_library(MINIZIP_LIBRARY
    NAMES minizip-ng minizip
    HINTS ${PC_MINIZIP_LIBDIR} ${PC_MINIZIP_LIBRARY_DIRS}
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(minizip
    REQUIRED_VARS MINIZIP_LIBRARY MINIZIP_INCLUDE_DIR
)

if(minizip_FOUND AND NOT TARGET minizip::minizip)
    add_library(minizip::minizip UNKNOWN IMPORTED)
    set_target_properties(minizip::minizip PROPERTIES
        IMPORTED_LOCATION "${MINIZIP_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${MINIZIP_INCLUDE_DIR}"
    )
endif()

mark_as_advanced(MINIZIP_INCLUDE_DIR MINIZIP_LIBRARY)
