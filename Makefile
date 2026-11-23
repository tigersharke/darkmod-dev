### PORTNAME block ##--------------------------------------------------------------------------------------
PORTNAME=	darkmod
DISTVERSION=	2.14
CATEGORIES=     games
MASTER_SITES=	https://www.thedarkmod.com/sources/
DISTNAME=	thedarkmod.${DISTVERSION}.src
PKGNAMESUFFIX=	-dev
DIST_SUBDIR=	${PORTNAME}

# Maintainer block ##--------------------------------------------------------------------------------------
MAINTAINER=	nope@nothere
COMMENT=	Stealth game inspired by the Thief series (engine)
WWW=		https://www.thedarkmod.com/

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
		libpugixml.so:textproc/pugixml \
		libpng16.so:graphics/png

#NO_WRKSUBDIR=	yes
WRKSRC=		${WRKDIR}
#
### uses block ##------------------------------------------------------------------------------------------
#USES=		cmake ninja pkgconfig python shebangfix
USES=		cmake ninja pkgconfig python shebangfix gl localbase:ldflags xorg jpeg 7z
#USES=		cmake ninja pkgconfig python shebangfix compiler:c++17-lang gl localbase:ldflags xorg
#USES=		cmake compiler:c++17-lang gl localbase:ldflags pkgconfig xorg
USE_XORG=	x11 xext xxf86vm
USE_GL=		gl
#USE_GITHUB=	yes
#GH_ACCOUNT=	stgatilov
#GH_PROJECT=	darkmod_src
#GH_TAGNAME=	c1ab71003d544dbedcbcfce7d2bfc4af7cf7a650

# USES=cmake related variables ##--------------------------------------------------------------------------
#
CMAKE_ARGS+=	\
		-DCMAKE_MODULE_PATH="${FILESDIR};${CMAKE_MODULE_PATH}" \
		-DCURL_INCLUDE_DIRS=${LOCALBASE}/include \
		-DCMAKE_PREFIX_PATH="${LOCALBASE}/lib;${LOCALBASE}/lib/cmake/Tracy" \
		-DTDM_THIRDPARTY_ARTEFACTS=OFF \
		-DCMAKE_BUILD_TYPE="Debug" \
		-DCURL_INCLUDE_DIR="${LOCALBASE}/include" \
		-DCURL_LIBRARY="${LOCALBASE}/lib/libcurl.so" \
		-DFORCE_COLORED_OUTPUT=ON \
		-DQT_DEBUG_FIND_PACKAGE=ON \
		-DCMAKE_FIND_DEBUG_MODE=true \
		-DCMAKE_CXX_FLAGS="-isystem ${WRKSRC}/external/tracy ${CMAKE_CXX_FLAGS}" \
		-DCMAKE_C_FLAGS="-isystem ${WRKSRC}/external/tracy ${CMAKE_C_FLAGS}" \
		-DTRACY_ENABLE=ON \
		-DENABLE_TRACY=ON \
		-DCMAKE_CXX_FLAGS="-DTRACY_DELAYED_INIT -DTRACY_MANUAL_LIFETIME ${CMAKE_CXX_FLAGS}" \
		-DCMAKE_C_FLAGS="-DTRACY_DELAYED_INIT -DTRACY_MANUAL_LIFETIME ${CMAKE_C_FLAGS}" \
		-DCOPY_EXE=OFF
#		-DCMAKE_BUILD_TYPE="Release" \

SUB_FILES=	thedarkmod
SUB_LIST=	DATADIR="${DATADIR}"

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
#

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

post-patch:
	@${ECHO_MSG} "===>  Tracy RecreateQueries workaround (Tracy 0.13+)"
	@${REINPLACE_CMD} \
		-e 's/tracy::GetGpuCtx().ptr->RecreateQueries();/\/\* RecreateQueries removed in Tracy 0.13+ \*\//' \
		${WRKSRC}/framework/Tracing.cpp

	@${ECHO_MSG} "===>  Link libvorbisfile (missing from upstream CMake)"
	@${REINPLACE_CMD} \
		-e '/vorbis::vorbis[^f]/s|vorbis::vorbis|vorbis::vorbis\n\t\tvorbis::vorbisfile|' \
		${WRKSRC}/CMakeLists.txt

	@${REINPLACE_CMD} \
		-e 's/ALIGN( tri.numVerts \* 2 \* sizeof( shadowCache_t ), 16 )/ID_ALIGN( tri.numVerts * 2 * sizeof( shadowCache_t ), 16 )/' \
		${WRKSRC}/renderer/frontend/tr_trisurf.cpp
	@${ECHO_MSG} "===>  Remove Linux-only stdc++fs (bare name)"
	@${REINPLACE_CMD} -e 's/[ 	]stdc++fs//g' \
		-e 's/stdc++fs//g' \
		-e 's|-lX11|-L${LOCALBASE}/lib -lX11|g' \
		-e 's|-lXext|-lXext|g' \
		-e 's|-lXxf86vm|-lXxf86vm|g' \
		${WRKSRC}/CMakeLists.txt
	${FIND} ${WRKSRC} -type f \( -name '*.h' -o -name '*.hpp' -o -name '*.cpp' -o -name '*.c' \) \
	-print0 | ${XARGS} -0 ${REINPLACE_CMD} \
	-e 's/idMath::INFINITY/idMath::INF/g'



	@${ECHO_MSG} "===>  Stub RoQFileEncode_f (roqvq excluded)"
	@${REINPLACE_CMD} \
		-e '/RoQFileEncode_f/s/^/\/\* FreeBSD port: RoQ encoder excluded *\/ /' \
		${WRKSRC}/framework/Common.cpp

	@${ECHO_MSG} "===>  Disable RoQ encoder command (roqvq tools excluded)"
	@${REINPLACE_CMD} -e 's|cmdSystem->AddCommand( "roq", RoQFileEncode_f, CMD_FL_TOOL, "encodes a roq file" );|// cmdSystem->AddCommand( "roq", RoQFileEncode_f, CMD_FL_TOOL, "encodes a roq file" );|' \
		${WRKSRC}/framework/Common.cpp


# Upstream provides no CMake install() rules
INSTALL_TARGET=

do-install:
	${MKDIR} ${STAGEDIR}${DATADIR}
	${INSTALL_PROGRAM} ${BUILD_WRKSRC}/thedarkmod.x64 \
		${STAGEDIR}${DATADIR}/thedarkmod
	cd ${WRKSRC} && ${COPYTREE_SHARE} glprogs ${STAGEDIR}${DATADIR}
	${MKDIR} ${STAGEDIR}${DATADIR}/fms
	${CHMOD} 1777 ${STAGEDIR}${DATADIR}/fms
	${INSTALL_SCRIPT} ${WRKDIR}/thedarkmod \
		${STAGEDIR}${PREFIX}/bin/thedarkmod

.include <bsd.port.mk>
