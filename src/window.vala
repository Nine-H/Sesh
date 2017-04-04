using Gtk;

class Window : Gtk.Window {
    private Graphics graphics;
    private FFTStreamer fft_streamer;
    private float frame_number;
    
    public Window () {
    	var headerbar = new Gtk.HeaderBar ();
    	this.set_titlebar (headerbar);
        headerbar.set_title ("Sesh");
        //FIXME: this is a waste of time till I have gem shaders, fft (the guts basically)
        //headerbar.set_subtitle ("shaders compiled: true | fps: 60 | frame: 240 | shaders 3");
        headerbar.set_show_close_button (true);
    	this.destroy.connect (on_quit);
    	
        graphics = new Graphics ();
        graphics.add_tick_callback (tick);
        this.add (graphics);
        
        this.show_all ();
        
        fft_streamer = new FFTStreamer ();
		fft_streamer.play ("benis");
    }
    
    private bool tick (Widget widget) {
        frame_number = frame_number + 1.0f;
        //stdout.printf ("frame\n");
        graphics.update_scene (frame_number);
        graphics.queue_render ();
		
        return true;
    }
    
    private void on_quit () {
    	Gtk.main_quit ();
    	fft_streamer.close_stream ();
    }
}

