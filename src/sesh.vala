class Sesh : Granite.Application {

    construct {
        program_name = "Sesh";
        build_version = "0.01";
        exec_name = "sesh";
        app_years = "2017";
        about_authors = { "Nine H <nine.gentooman@gmail.com>" };
        about_comments = "hell to write";
    }

    public override void activate () {
        var window = new SeshWindow ();
        window.show_all();
    }

    public static int main ( string [] args ) {
        var app = new Sesh ();
        Gst.init (ref args);
        return app.run (args);
    }
}
