#version 330 core
in vec3 f_color;
void main() {
    gl_FragColor = vec4(f_color.x, f_color.y, f_color.z, 1.0);
    //glFragColor = vec4(frame*0.01, 1.0)
}
