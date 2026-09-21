### PORTNAME block ##--------------------------------------------------------------------------------------
PORTNAME=	darkmod
DISTVERSION=	g20260906
CATEGORIES=	games
MASTER_SITES=	GH
PKGNAMESUFFIX=	-dev
DIST_SUBDIR=	${PORTNAME}${PKGNAMESUFFIX}

# Maintainer block ##--------------------------------------------------------------------------------------
MAINTAINER=	nope@nothere
COMMENT=	Near-infinite-world block sandbox game
WWW=		https://upstream.com

### License block ##---------------------------------------------------------------------------------------
LICENSE=	LGPL21+
LICENSE_FILE=	${WRKSRC}/LICENSE.txt

# dependencies ##------------------------------------------------------------------------------------------
BUILD_DEPENDS=	nasm:devel/nasm \
		${LOCALBASE}/include/doctest/doctest.h:devel/doctest \
		${LOCALBASE}/lib/libTracyClient.a:devel/tracy

LIB_DEPENDS=	libzstd.so:archivers/zstd \
		libminizip.so:archivers/minizip \
		libz-ng.so:archivers/zlib-ng \
		libcurl.so:ftp/curl \
		libvorbisfile.so:audio/libvorbis \
		libvorbis.so:audio/libvorbis \
		libogg.so:audio/libogg \
		libopenal.so:audio/openal-soft \
		libavcodec.so:multimedia/ffmpeg \
		libmbedtls.so:security/mbedtls4 \
		libglfw.so:graphics/glfw \
		libpugixml.so:textproc/pugixml

#
### uses block ##------------------------------------------------------------------------------------------
USES=		cmake ninja pkgconfig python shebangfix
USE_GITHUB=	yes
GH_ACCOUNT=	stgatilov
GH_PROJECT=	darkmod_src
GH_TAGNAME=	693d138e0632095b9c1c93081ce049609542c6cb

# USES=cmake related variables ##--------------------------------------------------------------------------
#
CMAKE_ARGS+=	-DCMAKE_MODULE_PATH="${FILESDIR};${CMAKE_MODULE_PATH}" \
		-DCURL_INCLUDE_DIRS=${LOCALBASE}/include \
		-DCMAKE_PREFIX_PATH="${LOCALBASE};${LOCALBASE}/lib;${LOCALBASE}/lib/cmake/Tracy" \
		-DTDM_THIRDPARTY_ARTEFACTS=OFF \
		-DCMAKE_BUILD_TYPE="Debug" \
		-DCURL_INCLUDE_DIR="${LOCALBASE}/include" \
		-DCURL_LIBRARY="${LOCALBASE}/lib/libcurl.so" \
		-DFORCE_COLORED_OUTPUT=ON \
		-DQT_DEBUG_FIND_PACKAGE=ON \
		-DCMAKE_FIND_DEBUG_MODE=true \
		-DCMAKE_CXX_FLAGS="-isystem ${WRKSRC}/external/tracy ${CMAKE_CXX_FLAGS}" \
		-DCMAKE_C_FLAGS="-isystem ${WRKSRC}/external/tracy ${CMAKE_C_FLAGS}"
#		-DCMAKE_BUILD_TYPE="Release" \

### Make block ##------------------------------------------------------------------------------------------
#
### conflicts ##-------------------------------------------------------------------------------------------
#
### wrksrc block ##----------------------------------------------------------------------------------------
#
### packaging list block ##--------------------------------------------------------------------------------
#
### options definitions ##---------------------------------------------------------------------------------
#
### options descriptions ##--------------------------------------------------------------------------------
#
### options helpers ##-------------------------------------------------------------------------------------
#

.include <bsd.port.options.mk>

#
#----------------------------------------------------------------------
# Prefer zlib-ng and minizip-ng via compatibility symlinks
pre-configure:
	@${ECHO_MSG} "===>  Creating CMake config aliases for zlib-ng / minizip-ng"
	${MKDIR} ${WRKDIR}/cmake-aliases
# zlib-ng → ZLIB
	${LN} -sf ${LOCALBASE}/lib/cmake/zlib-ng/zlib-ng-config.cmake \
	${WRKDIR}/cmake-aliases/ZLIBConfig.cmake
	${LN} -sf ${LOCALBASE}/lib/cmake/zlib-ng/zlib-ng-config.cmake \
	${WRKDIR}/cmake-aliases/zlib-config.cmake
# minizip-ng → minizip
	${LN} -sf ${LOCALBASE}/lib/cmake/minizip-ng/minizip-ng-config.cmake \
	${WRKDIR}/cmake-aliases/minizipConfig.cmake
	${LN} -sf ${LOCALBASE}/lib/cmake/minizip-ng/minizip-ng-config.cmake \
	${WRKDIR}/cmake-aliases/minizip-config.cmake

post-extract:
	make -C /usr/ports/devel/tracy extract
	${MKDIR} ${WRKSRC}/external/tracy
	${CP} -R `make -C /usr/ports/devel/tracy -V WRKSRC`/public/* ${WRKSRC}/external/tracy
	# Place the amalgamation where #include <TracyClient.cpp> finds it
	${CP} ${WRKSRC}/external/tracy/TracyClient.cpp ${WRKSRC}/
	# Satisfy the relative #include "common/..." and "client/..." inside it
	${LN} -sfn external/tracy/common ${WRKSRC}/common
	${LN} -sfn external/tracy/client ${WRKSRC}/client
	make -C /usr/ports/devel/tracy clean

.include <bsd.port.mk>
