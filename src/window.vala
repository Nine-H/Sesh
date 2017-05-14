class Window : Gtk.Window {
    private Graphics graphics;
    private FFTStreamer fft_streamer;
    private float frame_number;
    
    public Window () {
    	var headerbar = new Gtk.HeaderBar ();
    	headerbar.get_style_context().add_class("sesh-headerbar");
    	this.set_titlebar (headerbar);
        headerbar.set_title ("Sesh");
        headerbar.set_show_close_button (true);
    	this.destroy.connect (on_quit);
        
        graphics = new Graphics ();
        graphics.add_tick_callback (tick);
        this.add (graphics);
        this.show_all ();
        
        fft_streamer = new FFTStreamer ();
        fft_streamer.fft_update.connect( (data)=>{
            graphics.fft = data;
		    print ("%f".printf(data[0]));
		    for (int i = 0; i < (int)(60 + data[10]); i++) {
		        print ("*");
	        }
		    print ("\n");
	    });
		fft_streamer.play ();
    }
    
    private bool tick (Gtk.Widget widget) {
        frame_number = frame_number + 1.0f;
        graphics.frame = frame_number;
        //graphics.update_scene (frame_number);
        graphics.queue_render ();
        return true;
    }
    
    private void on_quit () {
    	fft_streamer.close_stream ();
    	Gtk.main_quit ();
    }
}
