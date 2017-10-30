class PresetSettings : Gtk.Dialog {
    public PresetSettings () {
    }
        
    construct {
        var background_color = new Gtk.ColorButton();
        var verts = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 3, 100000, 1);
        var style = new Gtk.ComboBox ();
        
        var layout = new Gtk.Grid ();
        layout.margin = 12;
        layout.hexpand = true;
        layout.column_spacing = 6;
        layout.attach (new Gtk.Label("Background Color:"), 0, 0);
        layout.attach (background_color, 1, 0);
        layout.attach (new Gtk.Label("no. of Verts:"), 0, 1);
        layout.attach (verts, 1, 1);
        layout.attach (new Gtk.Label("Style:"), 0, 2);
        layout.attach (style, 1, 2);
        
        var labels = new List<weak Gtk.Label>();
        foreach (Gtk.Label label in labels) { 
            label.halign = Gtk.Align.END;
        }
        
        Gtk.Box content = this.get_content_area() as Gtk.Box;
        content.add (layout);
        content.expand = true;
        
    }
}
