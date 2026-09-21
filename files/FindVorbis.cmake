# FindVorbis.cmake – provides vorbis::vorbis (and friends) for TheDarkMod

find_package(Ogg REQUIRED)   # Vorbis depends on Ogg

find_package(PkgConfig QUIET)
if(PkgConfig_FOUND)
    pkg_check_modules(PC_VORBIS QUIET vorbis)
    pkg_check_modules(PC_VORBISFILE QUIET vorbisfile)
    pkg_check_modules(PC_VORBISENC QUIET vorbisenc)
endif()

find_path(VORBIS_INCLUDE_DIR
    NAMES vorbis/codec.h
    HINTS ${PC_VORBIS_INCLUDEDIR} ${PC_VORBIS_INCLUDE_DIRS}
)

find_library(VORBIS_LIBRARY NAMES vorbis
    HINTS ${PC_VORBIS_LIBDIR} ${PC_VORBIS_LIBRARY_DIRS})
find_library(VORBISFILE_LIBRARY NAMES vorbisfile
    HINTS ${PC_VORBISFILE_LIBDIR} ${PC_VORBISFILE_LIBRARY_DIRS})
find_library(VORBISENC_LIBRARY NAMES vorbisenc
    HINTS ${PC_VORBISENC_LIBDIR} ${PC_VORBISENC_LIBRARY_DIRS})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Vorbis
    REQUIRED_VARS VORBIS_LIBRARY VORBIS_INCLUDE_DIR
)

if(Vorbis_FOUND AND NOT TARGET vorbis::vorbis)
    add_library(vorbis::vorbis UNKNOWN IMPORTED)
    set_target_properties(vorbis::vorbis PROPERTIES
        IMPORTED_LOCATION "${VORBIS_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${VORBIS_INCLUDE_DIR}"
        INTERFACE_LINK_LIBRARIES "Ogg::ogg"
    )

    if(VORBISFILE_LIBRARY AND NOT TARGET vorbis::vorbisfile)
        add_library(vorbis::vorbisfile UNKNOWN IMPORTED)
        set_target_properties(vorbis::vorbisfile PROPERTIES
            IMPORTED_LOCATION "${VORBISFILE_LIBRARY}"
            INTERFACE_LINK_LIBRARIES "vorbis::vorbis"
        )
    endif()
endif()

mark_as_advanced(VORBIS_INCLUDE_DIR VORBIS_LIBRARY VORBISFILE_LIBRARY VORBISENC_LIBRARY)
