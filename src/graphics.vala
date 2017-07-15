
//  /$$$$$$  /$$$$$$$$  /$$$$$$  /$$   /$$
// /$$__  $$| $$_____/ /$$__  $$| $$  | $$
//| $$  \__/| $$      | $$  \__/| $$  | $$
//|  $$$$$$ | $$$$$   |  $$$$$$ | $$$$$$$$
// \____  $$| $$__/    \____  $$| $$__  $$
// /$$  \ $$| $$       /$$  \ $$| $$  | $$
//|  $$$$$$/| $$$$$$$$|  $$$$$$/| $$  | $$
// \______/ |________/ \______/ |__/  |__/
// sesh.vala    (c)Nine-H GPL3+ 2016.06.15

class Graphics : Gtk.GLArea {

    public signal void gl_error (bool error, string message);

    public float frame { get; set; }
    public Value fft { get; set; }
    public string demo_path { get; set; }
    
    private GL.GLuint[] vertex_array_object = {0};
    private ValaGL.Core.GLProgram gl_program;
    private ValaGL.Core.VBO verts_vbo;
    private ValaGL.Core.VBO colors_vbo;
    //private ValaGL.Core.IBO element_ibo;
    private GL.GLint mvp_location;
    private GL.GLfloat frame_uniform;
    private GL.GLfloat[] fft_uniform;

    private GL.GLfloat vis_verts[1000];
    private GL.GLfloat vis_colors[1000];
    //private GL.GLushort vis_elements[1000];

    public Graphics () {
        set_size_request (512, 512);
        has_depth_buffer = true;
        render.connect (on_render);
    }

    private void demo_change () {
        try {
            gl_program = new ValaGL.Core.GLProgram(
                demo_path + "vertex.glslv",
                demo_path + "fragment.glslf"
            );
            verts_vbo = new ValaGL.Core.VBO(vis_verts);
            colors_vbo = new ValaGL.Core.VBO(vis_colors);
            //element_ibo = new ValaGL.Core.IBO(vis_elements);
            gl_error (false, "");
        } catch (ValaGL.Core.CoreError e) {
            gl_error (true, e.message);
        }
    }
    
    private bool on_render ( ) {

        //print ("%s\n".printf(fft.strdup_contents()));
        //print ("%f\n".printf(frame));
        GL.glGenVertexArrays (1, vertex_array_object);
        GL.glBindVertexArray (vertex_array_object[0]);
        
        fft_uniform = value_dump (fft);

        demo_change ();

        mvp_location = gl_program.get_uniform_location("MVP");

        GL.glEnableVertexAttribArray (0);
        verts_vbo.apply_as_vertex_array (0, 3);
        GL.glEnableVertexAttribArray (1);
        colors_vbo.apply_as_vertex_array (1, 3);


        GL.glBindVertexArray (0);

        /// clear screen
        GL.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);
        GL.glClearColor (0.9f, 0.9f, 0.9f, 1.0f);

        //do I need a camera?
        var camera = new ValaGL.Core.Camera ();
        camera.set_perspective_projection (70.0f, 5.0f/4.0f, 0.01f, 100.0f);

        //valaGL.Core stuff needs to go.
        var eye = ValaGL.Core.Vec3.from_data (0, 2, 0);
        var center = ValaGL.Core.Vec3.from_data (0, 0, -2);
        var up = ValaGL.Core.Vec3.from_data (0, 1, 0);
        camera.look_at (ref eye, ref center, ref up);

        var model_matrix = ValaGL.Core.Mat4.identity ();
        ValaGL.Core.Vec3 translation = ValaGL.Core.Vec3.from_data (0, 0, -4);
        ValaGL.Core.GeometryUtil.translate (ref model_matrix, ref translation);
        ValaGL.Core.Vec3 rotation = ValaGL.Core.Vec3.from_data (0, 1, 0);
        ValaGL.Core.GeometryUtil.rotate (ref model_matrix, frame, ref rotation);

        gl_program.make_current();

        //custom uniform variables
        GL.glUniform1f ( gl_program.get_uniform_location("frame"), frame_uniform );
        GL.glUniform1fv ( gl_program.get_uniform_location("fft"), 128, fft_uniform );
        //FIXME

        camera.apply (mvp_location, ref model_matrix);

        //draw calls
        GL.glBindVertexArray (vertex_array_object[0]);
        GL.glDrawElements (
            (GL.GLenum)GL.GL_TRIANGLES,
            1000 /*vis_elements.length*/,
            GL.GL_UNSIGNED_SHORT,null
        );

        GL.glBindVertexArray (0);
        GL.glUseProgram (0);

        GL.glFlush();

        return true;
    }
    
    //FIXME: possible race condition.
    private float[] value_dump (Value value_in) {
        float[] this_dump = new float[128];
        for (int i = 0; i < 128; i++) {
            this_dump[i] = (float)Gst.ValueArray.get_value(Gst.ValueArray.get_value(value_in, 0), i);
        }
        return this_dump;
    }
}
