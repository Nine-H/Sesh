class Window : Gtk.Window {
    private Graphics graphics;
    private FFTStreamer fft_streamer;
    private float frame_number;
    
    public Window () {
    	var headerbar = new Gtk.HeaderBar ();
    	this.set_titlebar (headerbar);
        headerbar.set_title ("Sesh");
        headerbar.set_show_close_button (true);
    	this.destroy.connect (on_quit);
        
        graphics = new Graphics ();
        graphics.add_tick_callback (tick);
        this.add (graphics);
        
        var demo_switcher = new DemoSwitcher();
        headerbar.pack_end(demo_switcher);
        demo_switcher.demo_changed.connect ((path) => {print(path);});
        
        this.show_all ();

        fft_streamer = new FFTStreamer ();
        fft_streamer.fft_update.connect( (data)=>{
            graphics.fft = data;
            //FIXME: delete this when fft data structure is finalised.
		    //print ("%f".printf(data[0]));
		    //for (int i = 0; i < (int)(60 + data[10]); i++) {
		    //   print ("*");
	        //}
		    //print ("\n");
	    });
		fft_streamer.play ();
    }
    
    private bool tick (Gtk.Widget widget) {
        frame_number = frame_number + 1.0f;
        graphics.frame = frame_number;
        graphics.queue_render ();
        return true;
    }
    
    private void on_quit () {
    	fft_streamer.close_stream ();
    	Gtk.main_quit ();
    }
}
