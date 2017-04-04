using GL;
using ValaGL.Core;

class Graphics : Gtk.GLArea {
    private GLuint[] vertex_array_object = {0};
    private GLProgram gl_program;
    private VBO coord_vbo;
    private VBO color_vbo;
    private IBO element_ibo;
    private GLint mvp_location;
    private float frame;
    private GLfloat frame_uniform;
    
    
    private GLfloat[] cube_vertices = {
		// front
		-1, -1,  1,
		 1, -1,  1,
		 1,  1,  1,
		-1,  1,  1,
		// back
		-1, -1, -1,
		 1, -1, -1,
		 1,  1, -1,
		-1,  1, -1
	};
	
	private GLfloat[] cube_colors = {
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
	
    private GLushort[] cube_elements = {
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
        //stdout.printf ("render\n");

		glGenVertexArrays(1, vertex_array_object);
		glBindVertexArray(vertex_array_object[0]);
		
        try {
            gl_program = new GLProgram( //FIXME: hardcoded paths, no geom, not arbitrary length of program.
                "/home/nine/Projects/sesh/data/vertex.glsl",
                "/home/nine/Projects/sesh/data/fragment.glsl"
            );
            coord_vbo = new VBO(cube_vertices);
			color_vbo = new VBO(cube_colors);
			element_ibo = new IBO(cube_elements);
			frame_uniform = frame;
            //stdout.printf("shaders compiled :D\n");
        } catch (ValaGL.Core.CoreError e) {
            stdout.printf("CoreError: %s\n", e.message);
        }

        mvp_location = gl_program.get_uniform_location("MVP");
		
		glEnableVertexAttribArray(0);
		coord_vbo.apply_as_vertex_array(0, 3);
		glEnableVertexAttribArray(1);
		color_vbo.apply_as_vertex_array(1, 3);
		

		glBindVertexArray(0);

		/// render
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		glClearColor(0.0f, 0.5f, 1.0f, 0.0f);

		var camera = new Camera ();
		camera.set_perspective_projection (70.0f, 5.0f/4.0f, 0.01f, 100.0f);

		var eye = Vec3.from_data (0, 2, 0);
		var center = Vec3.from_data (0, 0, -2);
		var up = Vec3.from_data (0, 1, 0);
		camera.look_at (ref eye, ref center, ref up);

		var model_matrix = Mat4.identity ();
		Vec3 translation = Vec3.from_data (0, 0, -4);
		GeometryUtil.translate (ref model_matrix, ref translation);
		Vec3 rotation = Vec3.from_data (0, 1, 0);
		GeometryUtil.rotate (ref model_matrix, frame, ref rotation);

		gl_program.make_current();
		
		glUniform1f ( gl_program.get_uniform_location("frame"), frame_uniform );
		
		camera.apply (mvp_location, ref model_matrix);

		glBindVertexArray(vertex_array_object[0]);
		glDrawElements((GLenum)GL_TRIANGLES, cube_elements.length, GL_UNSIGNED_SHORT, null);

		glBindVertexArray (0);
		glUseProgram (0);

		glFlush();

		return true;
    }
    
    public void update_scene (float framenumber) {
    	frame = framenumber;
    	
    }
}
