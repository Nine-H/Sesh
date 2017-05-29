#version 330 core
layout(location = 0) in vec3 coord3d;
layout(location = 1) in vec3 v_color;
out vec3 f_color;
out vec3 warped;
uniform mat4 MVP;
uniform float frame;
uniform float fft[20];

void main() {
    f_color = v_color;
    warped = vec3(
        coord3d.x,
        coord3d.y,
        coord3d.z
    );
    gl_Position = MVP * vec4(coord3d, 1.0);
}
