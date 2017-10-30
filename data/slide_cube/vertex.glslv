#version 330 core
layout (location = 0) in vec3 verts;
uniform float fft[128];
void main(){

    /*float spectrum_x;
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
    }*/
    
    float test_x;
    float test_y;
    if (gl_VertexID < 128) {
        test_x = (fft[gl_VertexID]+60)/60;
        test_y = (fft[gl_VertexID+1]+60)/60;
    } else if (gl_VertexID < 128 * 2) {
        test_x = (fft[gl_VertexID-128]+60)/60 * -1.0;
        test_y = (fft[gl_VertexID-127]+60)/60;
    }
    
    //pack into vector and convert to gl coords
    vec3 spectrum = vec3(
        test_x,
        test_y,
        0.0
    );
    gl_Position = vec4(spectrum, 1.0);
}
