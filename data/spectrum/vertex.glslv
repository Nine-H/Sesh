#version 330 core
layout (location = 0) in vec3 verts;
uniform float fft[128];
void main(){

    float spectrum_x;
    float spectrum_y;
    if (gl_VertexID <= 128) {
        spectrum_x = gl_VertexID/128.0;
        if ((gl_VertexID%3)%2 == 1) {
            spectrum_y = (fft[gl_VertexID] + 60) * 0.2;
        } else {
            spectrum_y = 0.0;
        }
    } else {
        return;
    }
    
    //pack into vector and convert to gl coords
    vec3 spectrum = vec3(
        spectrum_x * 2.0 - 1.0,
        spectrum_y * 0.3 - 1.0,
        0.0
    );
    gl_Position = vec4(spectrum, 1.0);
}

