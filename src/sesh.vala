//  /$$$$$$  /$$$$$$$$  /$$$$$$  /$$   /$$
// /$$__  $$| $$_____/ /$$__  $$| $$  | $$
//| $$  \__/| $$      | $$  \__/| $$  | $$
//|  $$$$$$ | $$$$$   |  $$$$$$ | $$$$$$$$
// \____  $$| $$__/    \____  $$| $$__  $$
// /$$  \ $$| $$       /$$  \ $$| $$  | $$
//|  $$$$$$/| $$$$$$$$|  $$$$$$/| $$  | $$
// \______/ |________/ \______/ |__/  |__/
// sesh.vala       Nine-H GPL3+ 2016.06.15

class Sesh : Granite.Application {
    private Gtk.Window window;
    
    construct {
        program_name = "S E S H 🜛";
        build_version = "0.0001a";
        exec_name = "sesh";
        app_years = "2017";
        about_authors = { "Nine H <nine.gentooman@gmail.com>" };
        about_comments = "f e a t u r e s\n"
                        +"high level microphone emulation\n"
                        +"a e s t h e t i c  music visualizer\n"
                        +"send bitcoin to ########\n";
    }
    
    public override void activate () {
        window = new Window ();
    }
    
    public static int main ( string [] args ) {
        var app = new Sesh ();
        Gst.init (ref args);
        return app.run (args);
    }
}
