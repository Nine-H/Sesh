project (sesh)
cmake_minimum_required (VERSION 2.6)

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/src)

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")

set (PKGDATADIR "${DATADIR}/sesh")

set (EXEC_NAME "sesh")
set (RELEASE_NAME "Pre-Function Alpha")
set (VERSION "0.1")
set (VERSION_INFO "trash_fire")

find_package(PkgConfig)

pkg_check_modules(DEPS REQUIRED
    gtk+-3.0
    granite
    gdk-3.0
    gstreamer-1.0
)

add_definitions(${DEPS_CFLAGS})
link_libraries(${DEPS_LIBRARIES} -lm -lepoxy)
link_directories(${DEPS_LIBRARY_DIRS})

find_package(Vala REQUIRED)
include(ValaVersion)
ensure_vala_version("0.16" MINIMUM)

include(ValaPrecompile)
vala_precompile(VALA_C ${EXEC_NAME}
    ValaGL.Core/Camera.vala
    ValaGL.Core/MatrixMath.vala
    ValaGL.Core/GeometryUtil.vala
    ValaGL.Core/GLProgram.vala
    ValaGL.Core/VBO.vala
    ValaGL.Core/IBO.vala
    ValaGL.Core/CoreError.vala
    #ValaGL.Core/Util.vala
    src/demoswitcher.vala
    src/fft_streamer.vala
    src/graphics.vala
    src/window.vala
    src/sesh.vala
    
PACKAGES
    granite
    gtk+-3.0
    gdk-3.0
    glepoxy
    gstreamer-1.0

OPTIONS
    --vapidir=${CMAKE_SOURCE_DIR}/vapi
)

add_executable(${EXEC_NAME} ${VALA_C})
