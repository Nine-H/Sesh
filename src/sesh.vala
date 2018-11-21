//  /$$$$$$  /$$$$$$$$  /$$$$$$  /$$   /$$
// /$$__  $$| $$_____/ /$$__  $$| $$  | $$
//| $$  \__/| $$      | $$  \__/| $$  | $$
//|  $$$$$$ | $$$$$   |  $$$$$$ | $$$$$$$$
// \____  $$| $$__/    \____  $$| $$__  $$
// /$$  \ $$| $$       /$$  \ $$| $$  | $$
//|  $$$$$$/| $$$$$$$$|  $$$$$$/| $$  | $$
// \______/ |________/ \______/ |__/  |__/
// sesh.vala    (c)Nine-H GPL3+ 2016.06.15

class Sesh : Gtk.Application {

    public override void activate () {
        var window = new MainWindow ();
        window.show_all();
    }

    public static int main ( string [] args ) {
        var app = new Sesh ();
        Gst.init (ref args);
        return app.run (args);
    }
}
