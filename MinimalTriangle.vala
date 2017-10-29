// MinimalTriangle.vala
// Holy hell this is gonna be a trip.
// valac --vapidir=. --pkg gtk+-3.0 --pkg glepoxy --Xcc=-lepoxy minimaltriangle.vala
// FIXME: blank screen

class Demo : Gtk.GLArea {

    private GL.GLuint[] vao = {0};
    private GL.GLuint[] vbo = {0};
    private GL.GLfloat[] data = {
        -1.0f, -1.0f, 0.0f,
        1.0f, -1.0f, 0.0f,
        0.0f, 1.0f, 0.0f
    };
    
    public Demo () {
        set_size_request (512, 512);
        has_depth_buffer = true;
        render.connect (on_render);
    }
    
    private void load_shaders () {
        
    }
    
    private void demo_init () {
        // vao
        GL.glGenVertexArrays(1, vao);
        GL.glBindVertexArray(vao[0]);
        
        // vbo
        GL.glGenBuffers (1, vbo);
        GL.glBindBuffer (GL.GL_ARRAY_BUFFER, vbo[0]);
        GL.glBufferData (
            GL.GL_ARRAY_BUFFER,
            data.length * sizeof (GL.GLfloat),
            (GL.GLvoid[]) data,
            GL.GL_STATIC_DRAW
        );
    }

    private bool on_render () {
        demo_init ();
        // draw
        
        GL.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);
        GL.glClearColor(0.4f, 0.6f, 0.5f, 1.0f);
        
        GL.glEnableVertexAttribArray (0);
        GL.glBindBuffer (GL.GL_ARRAY_BUFFER, vbo[0]);
        GL.glVertexAttribPointer (
            0,
            3,
            GL.GL_FLOAT,
            (GL.GLboolean) GL.GL_FALSE,
            0,
            null
        );
        
        GL.glDrawArrays ((GL.GLenum)GL.GL_TRIANGLES, 0, 3);
        GL.glDisableVertexAttribArray (0);
        
        GL.glFlush();
        return true;
    }
}

public static int main ( string [] args ) {
    Gtk.init (ref args);
    var window = new Gtk.Window ();
    window.title = ("MinimalTriangle.vala");
    window.destroy.connect (Gtk.main_quit);
    
    var demo = new Demo ();
    demo.add_tick_callback (()=>{
        demo.queue_render();
        return true;
    });
    window.add (demo);
    
    window.show_all ();
    Gtk.main ();
    return 0;
}
