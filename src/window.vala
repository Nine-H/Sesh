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
        graphics.demo_path = "/home/nine/Projects/sesh/data/";
        this.add (graphics);
        
        var demo_switcher = new DemoSwitcher();
        headerbar.set_custom_title(demo_switcher);
        demo_switcher.demo_changed.connect ((path) => {graphics.demo_path = path;});
        
        var settings_button = new Gtk.Button.from_icon_name("open-menu", Gtk.IconSize.LARGE_TOOLBAR);
        headerbar.pack_end(settings_button);
        
        this.show_all ();

        fft_streamer = new FFTStreamer ();
        fft_streamer.fft_update.connect( (data)=>{
            graphics.fft = data;
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
