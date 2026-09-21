# Findffmpeg.cmake – provides ffmpeg::ffmpeg for TheDarkMod

find_package(PkgConfig QUIET)
if(PkgConfig_FOUND)
    pkg_check_modules(PC_AVCODEC   QUIET libavcodec)
    pkg_check_modules(PC_AVFORMAT  QUIET libavformat)
    pkg_check_modules(PC_AVUTIL    QUIET libavutil)
    pkg_check_modules(PC_SWSCALE   QUIET libswscale)
    pkg_check_modules(PC_SWRESAMPLE QUIET libswresample)
endif()

find_path(FFMPEG_INCLUDE_DIR
    NAMES libavcodec/avcodec.h
    HINTS ${PC_AVCODEC_INCLUDEDIR} ${PC_AVCODEC_INCLUDE_DIRS}
)

find_library(AVCODEC_LIBRARY   NAMES avcodec   HINTS ${PC_AVCODEC_LIBDIR})
find_library(AVFORMAT_LIBRARY  NAMES avformat  HINTS ${PC_AVFORMAT_LIBDIR})
find_library(AVUTIL_LIBRARY    NAMES avutil    HINTS ${PC_AVUTIL_LIBDIR})
find_library(SWSCALE_LIBRARY   NAMES swscale   HINTS ${PC_SWSCALE_LIBDIR})
find_library(SWRESAMPLE_LIBRARY NAMES swresample HINTS ${PC_SWRESAMPLE_LIBDIR})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ffmpeg
    REQUIRED_VARS AVCODEC_LIBRARY AVFORMAT_LIBRARY AVUTIL_LIBRARY FFMPEG_INCLUDE_DIR
)

if(ffmpeg_FOUND AND NOT TARGET ffmpeg::ffmpeg)
    add_library(ffmpeg::ffmpeg INTERFACE IMPORTED)
    set_target_properties(ffmpeg::ffmpeg PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${FFMPEG_INCLUDE_DIR}"
        INTERFACE_LINK_LIBRARIES
            "${AVCODEC_LIBRARY};${AVFORMAT_LIBRARY};${AVUTIL_LIBRARY};${SWSCALE_LIBRARY};${SWRESAMPLE_LIBRARY}"
    )
endif()

mark_as_advanced(FFMPEG_INCLUDE_DIR AVCODEC_LIBRARY AVFORMAT_LIBRARY AVUTIL_LIBRARY SWSCALE_LIBRARY SWRESAMPLE_LIBRARY)
