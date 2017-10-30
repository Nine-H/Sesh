#version 330 core
layout (location = 0) in vec3 verts;
uniform float frame;
uniform float fft[128];
out int index;
void main() {
    //generate gnarly boximus
    /*int r = int(gl_VertexID >6);
    int i = r==1 ? 13-gl_VertexID : gl_VertexID;
    int x = int(i<3 || i==4);
    int y = r ^ int(i>0 && i<4);
    int z = r ^ int(i<2 || i>5);
    float SIZE = 2.0;*/
    
    //float rotation = frame * 0.0001;
    //float butts = 30.0;

    
    float butts = frame * 0.01;
    
    const mat4 projection = mat4(
        vec4(3.0/4.0, 0.0, 0.0, 0.0),
        vec4(    0.0, 1.0, 0.0, 0.0),
        vec4(    0.0, 0.0, 0.5, 0.5),
        vec4(    0.0, 0.0, 0.0, 1.0)
    );
    
    mat4 rotation = mat4(
        vec4(1.0,         0.0,         0.0, 0.0),
        vec4(0.0,  cos(butts),  sin(butts), 0.0),
        vec4(0.0, -sin(butts),  cos(butts), 0.0),
        vec4(0.0, 0.0,  0.0, 1.0)
    );
    
    const vec4 positions[6] = vec4[6](
        vec4( 1.0,  1.0, 0.0, 1.0),
        vec4( 1.0,  0.0, 0.0, 1.0),
        vec4( 0.0,  1.0, 0.0, 1.0),
        vec4(-1.0, -1.0, 0.0, 1.0),
        vec4( 1.0, -1.0, 0.0, 1.0),
        vec4(-1.0,  1.0, 0.0, 1.0)
    );

    gl_Position = projection * rotation * positions[gl_VertexID];
}
