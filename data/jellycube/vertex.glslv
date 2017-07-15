#version 330
 
layout(location = 0) in vec3 coord3d;
layout(location = 1) in vec3 v_color;
out vec3 f_color;
out vec3 warped;
uniform mat4 MVP;
uniform float frame;
uniform float fft[128];

void main() {
    //generate gnarly boximus
    /*int r = int(gl_VertexID >6);
    int i = r==1 ? 13-gl_VertexID : gl_VertexID;
    int x = int(i<3 || i==4);
    int y = r ^ int(i>0 && i<4);
    int z = r ^ int(i<2 || i>5);
    float SIZE = 2.0;*/
    
    int r = int(gl_VertexID > 6);
    int i = r==1 ? 13-gl_VertexID : gl_VertexID;
    int x = int(i <= 4);
    int y = r ^ int(i>0 && i<4);
    int z = r ^ int(i<2 || i>5);
    //render
    f_color = v_color;
    vec3 box = vec3(x,y,z)*2.0-1;
    gl_Position = MVP * vec4(box, 1.0);
}
