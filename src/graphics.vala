class Graphics : Gtk.GLArea {

    public signal void gl_error (bool error, string message);

    private GL.GLuint[] vao = {0};
    private GL.GLuint glprogram = 0;
    private GL.GLuint fragment_shader = 0;
    private GL.GLuint vertex_shader = 0;
    private GL.GLuint vbo;
    private GL.GLfloat data [3000];
    private GL.GLfloat frame_uniform;
    private GL.GLfloat[] fft_uniform;
    private bool loaded = false;

    public int width { get; set; }
    public int height { get; set; }
    public float frame { get; set; }
    public Value fft { get; set; }
    private string _demo_path;
    public string demo_path {
        get {return _demo_path;}
        set {
            _demo_path = value;
            loaded = false;
        }
    }

    public Graphics () {
        set_size_request (512, 512);
        has_depth_buffer = true;
        render.connect (on_render);
        print ("%i, %i\n".printf(height, width));
    }
    
    private bool load_demo () {
        GL.glGenVertexArrays(1, vao);
        GL.glBindVertexArray(vao[0]);
        
        try {
            uint8[] vsh_contents;
            File.new_for_path (_demo_path + "vertex.glslv").load_contents (null, out vsh_contents, null);
            var v_shader = GL.glCreateShader (GL.GL_VERTEX_SHADER);
            string[] vshArray = { (string)vsh_contents, null };
            GL.glShaderSource (v_shader, 1, vshArray, null);
            GL.glCompileShader (v_shader);
            vertex_shader = v_shader;
        } catch {print ("bad vertex shader\n");}
        try {
            uint8[] fsh_contents;
            File.new_for_path (_demo_path + "fragment.glslf").load_contents (null, out fsh_contents, null);
            var f_shader = GL.glCreateShader (GL.GL_FRAGMENT_SHADER);
            string[] fshArray = { (string)fsh_contents, null };
            GL.glShaderSource (f_shader, 1, fshArray, null);
            GL.glCompileShader (f_shader);
            fragment_shader = f_shader;
        } catch {print ("bad frag shader\n");}

        glprogram = GL.glCreateProgram ();

        GL.glAttachShader (glprogram, vertex_shader);
        GL.glAttachShader (glprogram, fragment_shader);
        GL.glLinkProgram (glprogram);

        //vbo
        GL.GLuint vbo_array[1];
        GL.glGenBuffers (1, vbo_array);
        vbo = vbo_array[0];
        GL.glBindBuffer (GL.GL_ARRAY_BUFFER, vbo);
        GL.glBufferData (
            GL.GL_ARRAY_BUFFER,
            data.length * sizeof(GL.GLfloat),
            (GL.GLvoid[]) data,
            GL.GL_STATIC_DRAW
        );
        GL.glBindBuffer (GL.GL_ARRAY_BUFFER, 0);
        return true;
    }
    
    private bool on_render () {
        if (!loaded) {
            loaded = load_demo();
        }
        
        //custom uniform variables
        frame_uniform = frame;
        GL.glUniform1f (GL.glGetUniformLocation(glprogram, "frame"), frame_uniform);
        
        //FIXME: value_dump() sucks, and frequently gstreamer doesn't have
        //any data for us.
        fft_uniform = value_dump (fft);
        GL.glUniform1fv (GL.glGetUniformLocation(glprogram, "fft"), 128, fft_uniform);
        
        // start the draw
        GL.glClear(GL.GL_COLOR_BUFFER_BIT| GL.GL_DEPTH_BUFFER_BIT);
        GL.glClearColor(0.4f, 0.6f, 0.5f, 1.0f);
        
        // vbo some more
        GL.glEnableVertexAttribArray(0);
        GL.glBindBuffer(GL.GL_ARRAY_BUFFER, vbo);
        GL.glVertexAttribPointer (
            0,
            3,
            GL.GL_FLOAT,
            (GL.GLboolean) GL.GL_FALSE,
            0,
            null
        );
        
        //get_opengl_error ();
        GL.glUseProgram (glprogram);
        //print (get_opengl_error ());
        GL.glDrawArrays (
            GL.GL_TRIANGLES,
            0,
            data.length
        );
        GL.glFlush();
        return true;
    }
    
    //NOTE: currently a debug function that should be unused in release builds
    private string get_opengl_error () {
        switch (GL.glGetError()) {
            case 1280 : {
                return "GL_INVALID_ENUM\n";
            }
            case 1281 : {
                return "GL_INVALID_VALUE\n";
            }
            case 1282 : {
                return "GL_INVALID_OPERATION\n";
            }
            case 1283 : {
                return "GL_STACK_OVERFLOW\n";
            }
            case 1284 : {
                return "GL_STACK_UNDERFLOW\n";
            }
            case 1285 : {
                return "GL_OUT_OF_MEMORY\n";
            }
            case 1286 : {
                return "GL_INVALID_FRAMEBUFFER_OPERATION\n";
            }
            default: {
                return "GL_NO_ERROR\n";
            }
        }
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
