all:
	valac --vapidir=./vapi --pkg gtk+-3.0 --pkg granite --pkg gdk-3.0 --pkg glepoxy -X -lepoxy --pkg gstreamer-1.0 -X -lm src/sesh.vala src/window.vala src/graphics.vala src/fft_streamer.vala ValaGL.Core/Camera.vala ValaGL.Core/MatrixMath.vala ValaGL.Core/GeometryUtil.vala ValaGL.Core/GLProgram.vala ValaGL.Core/VBO.vala ValaGL.Core/IBO.vala ValaGL.Core/CoreError.vala #ValaGL.Core/Util.vala
