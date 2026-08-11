### PORTNAME block ##--------------------------------------------------------------------------------------
PORTNAME=		darkmod
DISTVERSION=	g20260802
CATEGORIES=		games
MASTER_SITES=	GH
PKGNAMESUFFIX=	-dev
DIST_SUBDIR=	${PORTNAME}${PKGNAMESUFFIX}

# Maintainer block ##--------------------------------------------------------------------------------------
MAINTAINER=	nope@nothere
COMMENT=	Near-infinite-world block sandbox game
WWW=		https://upstream.com

### License block ##---------------------------------------------------------------------------------------
LICENSE=		LGPL21+
LICENSE_FILE=	${WRKSRC}/LICENSE.txt

# dependencies ##------------------------------------------------------------------------------------------
BUILD_DEPENDS=	conan:sysutils/conan \
				${LOCALBASE}/include/doctest/doctest.h:devel/doctest \
				tracy>0:devel/tracy 
# devel/py-yaml is a dependency of sysutils/conan
LIB_DEPENDS=	libzstd.so:archivers/zstd \
				libminizip-ng.so:archivers/minizip-ng \
				libz-ng.so:archivers/zlib-ng \
				libcurl.so:ftp/curl \
				libvorbisfile.so:audio/libvorbis \
				libvorbis.so:audio/libvorbis \
				libogg.so:audio/libogg \
				libavcodec.so:multimedia/ffmpeg \
				libmbedtls.so:security/mbedtls4 \
				libglfw.so:graphics/glfw
#
### uses block ##------------------------------------------------------------------------------------------
USES=		cmake ninja pkgconfig shebangfix python
USE_GITHUB=	yes
GH_ACCOUNT=	stgatilov
GH_PROJECT=	darkmod_src
GH_TAGNAME=	6eba8ced56fb3630e0bb6adbbf95727f64f2364d

# USES=cmake related variables ##--------------------------------------------------------------------------
#
# Directory where Conan will drop the generated CMake configs + libs
#CONAN_OF=	${WRKSRC}/ThirdParty/artefacts/freebsd_${ARCH}
CONAN_OF=	${WRKSRC}/ThirdParty/artefacts/freebsd_${ARCH:S/amd64/x86_64/}
CONAN_HOME=	${WRKDIR}/.conan2
MAKE_ENV+=	CONAN_HOME=${CONAN_HOME}
#
CMAKE_ARGS+=    -DCMAKE_PREFIX_PATH=${PREFIX} \
				-DCMAKE_PREFIX_PATH=${LOCALBASE}/lib \
				-DCMAKE_PREFIX_PATH=${LOCALBASE}/lib/cmake \
				-DCMAKE_ENABLE_TRACY=OFF \
				-DENABLE_TRACY=OFF \
				-DFORCE_COLORED_OUTPUT=ON \
				-DASAN=ON \
				-DTDM_THIRDPARTY_ARTEFACTS=ON \
				-DCMAKE_FIND_DEBUG_MODE=true \
				-DCMAKE_INSTALL_PREFIX="${LOCALBASE}" \
				--debug-output \
				-DCURL_INCLUDE_DIRS=${LOCALBASE}/include \
				-DCMAKE_BUILD_TYPE="Release" \
				-DCMAKE_PREFIX_PATH=${CONAN_OF}

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
pre-configure:	# or post-patch
	@${ECHO_MSG} "===>  Building third-party dependencies with Conan"
	${MKDIR} ${CONAN_HOME}
	# 1. Export the custom recipes that live under ThirdParty/custom/
	cd ${WRKSRC}/ThirdParty && \
		${SETENV} ${MAKE_ENV} ${PYTHON_CMD} 1_export_custom.py --unattended
	# 2. Install / build the packages for FreeBSD
	#    (auto-detect profile is usually fine; add -pr / -s if you need more control)
	cd ${WRKSRC}/ThirdParty && \
		${SETENV} ${MAKE_ENV} conan install . \
			-of ${CONAN_OF} \
			-s thedarkmod/*:build_type=Release \
			-b missing 


.include <bsd.port.mk>
