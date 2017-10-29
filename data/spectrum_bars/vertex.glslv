#version 330
 
layout(location = 0) in vec3 coord3d;
layout(location = 1) in vec3 v_color;
out vec3 f_color;
out vec3 warped;
uniform mat4 MVP;
uniform float frame;
uniform float fft[128];

void main() {
    f_color = v_color;
    float spectrum_x;
    float spectrum_y;
    if (gl_VertexID < 128) {
        spectrum_x = (gl_VertexID);
        if (gl_VertexID % 2 == 0) {
            spectrum_y = (fft[gl_VertexID] + 60) * 0.3;
        } else {
            spectrum_y = 0;
        }
    } else {
        return;
    }
    
    vec3 spectrum = vec3(spectrum_x,spectrum_y,0.0);
    gl_Position = MVP * vec4(spectrum, 1.0);
}
