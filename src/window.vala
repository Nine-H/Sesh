//  /$$$$$$  /$$$$$$$$  /$$$$$$  /$$   /$$
// /$$__  $$| $$_____/ /$$__  $$| $$  | $$
//| $$  \__/| $$      | $$  \__/| $$  | $$
//|  $$$$$$ | $$$$$   |  $$$$$$ | $$$$$$$$
// \____  $$| $$__/    \____  $$| $$__  $$
// /$$  \ $$| $$       /$$  \ $$| $$  | $$
//|  $$$$$$/| $$$$$$$$|  $$$$$$/| $$  | $$
// \______/ |________/ \______/ |__/  |__/
// sesh.vala    (c)Nine-H GPL3+ 2016.06.15

class MainWindow : Gtk.Window {

    public float frame { get; set; }
    private Graphics graphics;
    private FFTStreamer fft_streamer;
    private Gtk.HeaderBar headerbar;
    
    public MainWindow () {
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
        
        var demo_switcher = new DemoSwitcher();
        demo_switcher.demo_changed.connect ((path) => {graphics.demo_path = path;});
        demo_switcher.change_demo();
        
        fft_streamer = new FFTStreamer ();
        fft_streamer.bind_property ("magnitude", graphics, "fft", BindingFlags.DEFAULT);
        fft_streamer.play ();
        
        headerbar = new Gtk.HeaderBar ();
        headerbar.set_title ("Sesh");
        headerbar.set_show_close_button (true);
        headerbar.pack_end(demo_switcher);
        
        this.set_titlebar (headerbar);
        this.destroy.connect (on_quit);
        this.add (graphics);
        this.bind_property("frame", graphics, "frame", BindingFlags.DEFAULT);
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
