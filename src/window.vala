class SeshWindow : Gtk.Window {

    public float frame { get; set; }
    
    private Graphics graphics;
    private FFTStreamer fft_streamer;
    
    public SeshWindow () {
        
    }
    
    construct {
        var new_preset = new Gtk.Button.from_icon_name ("document-new", Gtk.IconSize.LARGE_TOOLBAR);
        new_preset.clicked.connect (()=>{
            print ("new preset");
        });
        
        var demo_switcher = new DemoSwitcher();
        demo_switcher.demo_changed.connect ((path) => {graphics.demo_path = path;});
        
        var edit_button = new Gtk.Button.from_icon_name ("accessories-text-editor-symbolic", Gtk.IconSize.SMALL_TOOLBAR);

        edit_button.clicked.connect (() => {
            new PresetSettings().show_all();
        });
        
        var settings_button = new Gtk.Button.from_icon_name("open-menu", Gtk.IconSize.LARGE_TOOLBAR);
        
        var headerbar = new Gtk.HeaderBar ();
        headerbar.set_title ("Sesh");
        headerbar.set_show_close_button (true);
        headerbar.pack_start(new_preset);
        headerbar.pack_start(demo_switcher);
        headerbar.pack_start(edit_button);
        headerbar.pack_end(settings_button);
        
        graphics = new Graphics ();
        graphics.add_tick_callback (tick);
        graphics.demo_path = "../data/";
        graphics.gl_error.connect ((error, message) => {
            if (error) {
                headerbar.set_title("Error!");
                headerbar.subtitle = message;
            } else {
                headerbar.set_title("Sesh");
                headerbar.subtitle = null;
            }
        });
        
        this.destroy.connect (on_quit);
        this.set_titlebar (headerbar);
        this.add (graphics);
        
        fft_streamer = new FFTStreamer ();
        fft_streamer.bind_property ("magnitude", graphics, "fft", BindingFlags.DEFAULT);
        fft_streamer.play ();
        
        //this.bind_property("frame", graphics, "frame", BindingFlags.DEFAULT);
        
        this.show_all ();
        Gtk.main();
    }
    
    private bool tick (Gtk.Widget widget) {
        frame = frame + 1;
        graphics.queue_render ();
        return true;
    }
    
    private void on_resize () {
        int height;
        int width;
        this.get_size (out width, out height);
        graphics.width = width;
        graphics.height = height;
    }
    
    private void on_quit () {
        fft_streamer.close_stream ();
        Gtk.main_quit ();
    }
}
