//  /$$$$$$  /$$$$$$$$  /$$$$$$  /$$   /$$
// /$$__  $$| $$_____/ /$$__  $$| $$  | $$
//| $$  \__/| $$      | $$  \__/| $$  | $$
//|  $$$$$$ | $$$$$   |  $$$$$$ | $$$$$$$$
// \____  $$| $$__/    \____  $$| $$__  $$
// /$$  \ $$| $$       /$$  \ $$| $$  | $$
//|  $$$$$$/| $$$$$$$$|  $$$$$$/| $$  | $$
// \______/ |________/ \______/ |__/  |__/
// sesh.vala       Nine-H GPL3+ 2016.06.15

using Gtk;

class Sesh : Granite.Application {
    private Gtk.Window window;
    
    construct {
        program_name = "//S E S H";
        exec_name = "sesh";
        app_years = "2017";
        about_authors = { "Nine H <nine.gentooman@gmail.com>" };
        about_comments = "The Sesh OpenGL music vizualizer.\n\n"
                        +"a trippy music visualiser for elementary OS\n"
                        +"send bitcoin to ########\n";
    }
    
    public override void activate () {
        window = new Window ();
    }
    
    public static int main ( string [] args ) {
        Gst.init (ref args);
        Gtk.init (ref args);
        var app = new Sesh ();
        return app.run (args);
        Gtk.main ();
    }
}  
