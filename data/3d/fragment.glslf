#version 330 core
//uniform float fft[128];
//in vec3 f_color;
int index;
void main() {
    /*gl_FragColor = vec4(
        (f_color.x +(fft[64]+60)/20)/2,
        (fft[10]+60)/20,
        (f_color.z + (fft[64]+60)/20)/2,
        1.0
    );*/
    /*
    gl_FragColor = vec4(
        f_color.x,
        f_color.y,
        f_color.z, 0
    );*/

    gl_FragColor = vec4(0.8,0.3,0.3,0.0);
}
