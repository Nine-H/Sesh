
//  /$$$$$$  /$$$$$$$$  /$$$$$$  /$$   /$$
// /$$__  $$| $$_____/ /$$__  $$| $$  | $$
//| $$  \__/| $$      | $$  \__/| $$  | $$
//|  $$$$$$ | $$$$$   |  $$$$$$ | $$$$$$$$
// \____  $$| $$__/    \____  $$| $$__  $$
// /$$  \ $$| $$       /$$  \ $$| $$  | $$
//|  $$$$$$/| $$$$$$$$|  $$$$$$/| $$  | $$
// \______/ |________/ \______/ |__/  |__/
// sesh.vala    (c)Nine-H GPL3+ 2016.06.15

class SeshWindow : Gtk.Window {

    public float frame { get; set; }
    
    private Graphics graphics;
    private FFTStreamer fft_streamer;
    
    public SeshWindow () {
        var headerbar = new Gtk.HeaderBar ();
        this.set_titlebar (headerbar);
        headerbar.set_title ("Sesh");
        headerbar.set_show_close_button (true);
        this.destroy.connect (on_quit);
        
        graphics = new Graphics ();
        graphics.add_tick_callback (tick);
        graphics.demo_path = "/home/nine/Projects/sesh/data/";
        graphics.gl_error.connect ((error, message) => {
            if (error) {
                headerbar.set_title("Error!");
                headerbar.subtitle = message;
            } else {
                headerbar.set_title("Sesh");
                headerbar.subtitle = null;
            }
        });
        this.add (graphics);
        
        var demo_switcher = new DemoSwitcher();
        headerbar.pack_start(demo_switcher);
        demo_switcher.demo_changed.connect ((path) => {graphics.demo_path = path;});
        
        var settings_button = new Gtk.Button.from_icon_name("open-menu", Gtk.IconSize.LARGE_TOOLBAR);
        headerbar.pack_end(settings_button);

        fft_streamer = new FFTStreamer ();
        fft_streamer.bind_property ("magnitude", graphics, "fft", BindingFlags.DEFAULT);
        fft_streamer.play ();
        
        this.bind_property("frame", graphics, "frame", BindingFlags.DEFAULT);

        this.show_all ();
        Gtk.main();
    }
    
    private bool tick (Gtk.Widget widget) {
        frame = frame + 1;
        graphics.queue_render ();
        return true;
    }
    
    private void on_quit () {
        fft_streamer.close_stream ();
        Gtk.main_quit ();
    }
}
