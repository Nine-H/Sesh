#version 330 core
layout(location = 0) in vec3 coord3d;
layout(location = 1) in vec3 v_color;
out vec3 f_color;
out vec3 warped;
uniform mat4 MVP;
uniform float frame;
uniform float fft[128];

void main() {
    f_color = v_color;
    warped = vec3 (coord3d);
    warped = vec3 (
        coord3d.x * (60+fft[64]) * 0.1,
        //coord3d.x * 2 * sin (frame * 0.1),
        //coord3d.y * 2 * sin (frame * 0.1),
        (coord3d.y * (60+fft[32]) * 0.1) - 3,
        coord3d.z * (60+fft[96]) * 0.1
        //coord3d.z + 4 * sin (frame * 0.1)
    );
    gl_Position = MVP * vec4(warped, 1.0);
}
