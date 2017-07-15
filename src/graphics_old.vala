class Graphics : Gtk.GLArea {
    public signal void gl_error (bool error, string message);

    public float frame { get; set; }
    public Value fft { get; set; }
    public string demo_path { get; set; }
    public bool compile_succes { get; private set; }
    
    private GL.GLuint[] vertex_array_object = {0};
    private ValaGL.Core.GLProgram gl_program;
    private ValaGL.Core.VBO coord_vbo;
    private ValaGL.Core.VBO color_vbo;
    private ValaGL.Core.IBO element_ibo;
    private GL.GLint mvp_location;
    private GL.GLfloat frame_uniform;
    private GL.GLfloat[] fft_uniform;
    
    /*private GL.GLfloat[] cube_vertices = {
		// front
		-1, -1,  1,
		 1, -1,  1,
		 1,  1,  1,
		-1,  1,  1,
		// back
		-1, -1, -1,
		 1, -1, -1,
		 1,  1, -1,
		-1,  1, -1,
		0,0,0,
		0,0,0,
		0,0,0
	};*/
	private GL.GLfloat cube_vertices[1000];
	
	private GL.GLfloat[] cube_colors = {
		// front colors
		1, 0, 0,
		0, 1, 0,
		0, 0, 1,
		1, 1, 1,
		// back colors
		1, 0, 0,
		0, 1, 0,
		0, 0, 1,
		1, 1, 1
	};
	//private GL.GLfloat cube_colors [1000];

    private GL.GLushort[] cube_elements = {
		    // front
		    0, 1, 2,
		    2, 3, 0,
		    // top
		    1, 5, 6,
		    6, 2, 1,
		    // back
		    7, 6, 5,
		    5, 4, 7,
		    // bottom
		    4, 0, 3,
		    3, 7, 4,
		    // left
		    4, 5, 1,
		    1, 0, 4,
		    // right
		    3, 2, 6,
		    6, 7, 3
    };
    
    public Graphics () {
        set_size_request ( 512, 512 );
        has_depth_buffer = true;
        render.connect ( on_render );
    }
    
    private bool on_render ( ) {
		GL.glGenVertexArrays(1, vertex_array_object);
		GL.glBindVertexArray(vertex_array_object[0]);
		
        try {
            gl_program = new ValaGL.Core.GLProgram(
                demo_path + "vertex.glslv",
                demo_path + "fragment.glslf"
            );
            coord_vbo = new ValaGL.Core.VBO(cube_vertices);
			color_vbo = new ValaGL.Core.VBO(cube_colors);
			element_ibo = new ValaGL.Core.IBO(cube_elements);
			frame_uniform = frame;
			fft_uniform = value_dump(fft);
			gl_error(false, "");
        } catch (ValaGL.Core.CoreError e) {
            //stdout.printf("CoreError: %s\n", e.message);
            gl_error(true, e.message);
        }

        mvp_location = gl_program.get_uniform_location("MVP");
		
		GL.glEnableVertexAttribArray(0);
		coord_vbo.apply_as_vertex_array(0, 3);
		GL.glEnableVertexAttribArray(1);
		color_vbo.apply_as_vertex_array(1, 3);
		

		GL.glBindVertexArray(0);

		/// set context
		GL.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);
		GL.glClearColor(0.9f, 0.9f, 0.9f, 1.0f);

		var camera = new ValaGL.Core.Camera ();
		camera.set_perspective_projection (70.0f, 5.0f/4.0f, 0.01f, 100.0f);

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
		GL.glUniform1fv ( gl_program.get_uniform_location("fft"), 128, fft_uniform );//FIXME
		
		camera.apply (mvp_location, ref model_matrix);
		
		//draw calls
		GL.glBindVertexArray(vertex_array_object[0]);
		GL.glDrawElements(
		    (GL.GLenum)GL.GL_TRIANGLES,
		    1000 /*cube_elements.length*/,
		    GL.GL_UNSIGNED_SHORT,
		    null
		);

		GL.glBindVertexArray (0);
		GL.glUseProgram (0);

		GL.glFlush();

		return true;
    }
    
    private float[] value_dump (Value in) {
    	float[] this_dump = new float[128];
        for (int i = 0; i < 128; i++) {
        	print ("what's happening?");
            this_dump[i] = (float)Gst.ValueArray.get_value(Gst.ValueArray.get_value(in, 0), i);
        }
        return this_dump;
    }
}