#version 330 core
uniform float fft[128];

in vec3 f_color;
void main() {
    gl_FragColor = vec4(
        (f_color.x +(fft[64]+60)/20)/2,
        (fft[10]+60)/20,
        (f_color.z + (fft[64]+60)/20)/2,
        1.0
    );

}