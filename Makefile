### PORTNAME block ##--------------------------------------------------------------------------------------
PORTNAME=		darkmod
DISTVERSION=	g20260726
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
BUILD_DEPENDS=	${LOCALBASE}/include/doctest/doctest.h:devel/doctest \
				tracy>0:devel/tracy 
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
USES=		cmake ninja pkgconfig
USE_GITHUB=	yes
GH_ACCOUNT=	stgatilov
GH_PROJECT=	darkmod_src
GH_TAGNAME=	1b6b495cc92232a1a49170da3f339b3693a024a6

# USES=cmake related variables ##--------------------------------------------------------------------------
#
CMAKE_ARGS+=    -DCMAKE_BUILD_TYPE="Release" \
				-DCMAKE_PREFIX_PATH=${PREFIX} \
				-DCMAKE_PREFIX_PATH=${LOCALBASE}/lib \
				-DCMAKE_PREFIX_PATH=${LOCALBASE}/lib/cmake \
				-CURL_INCLUDE_DIRS=${LOCALBASE}/include \
				-DCMAKE_ENABLE_TRACY=OFF \
				-DENABLE_TRACY=OFF \
				-DFORCE_COLORED_OUTPUT=ON \
				-DASAN=ON \
				-DCMAKE_TDM_THIRDPARTY_ARTEFACTS=OFF \
				-DTDM_THIRDPARTY_ARTEFACTS=OFF \
				-DCMAKE_INSTALL_PREFIX="${LOCALBASE}"
#				-DCMAKE_FIND_DEBUG_MODE=true \
#				--debug-output \

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

.include <bsd.port.mk>
