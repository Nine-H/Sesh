#version 330 core
//#extension GL_ARB_geometry_shader4 : enable

void main () {
    int i;
    vec4 vertex
    for (i = 0; i < gl_VerticesIn; i++) {
        gl_Position = gl_PositionIn[i];
        EmitVertex();
    }
    EndPrimitive();
    for (i = 0; i < gl_VerticesIn; i++) {
        vertex = gl_PositionIn[i];
        vertex.z = -vertex.z;
        gl_Position = vertex;
        EmitVertex();
    }
}
