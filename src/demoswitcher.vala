//  /$$$$$$  /$$$$$$$$  /$$$$$$  /$$   /$$
// /$$__  $$| $$_____/ /$$__  $$| $$  | $$
//| $$  \__/| $$      | $$  \__/| $$  | $$
//|  $$$$$$ | $$$$$   |  $$$$$$ | $$$$$$$$
// \____  $$| $$__/    \____  $$| $$__  $$
// /$$  \ $$| $$       /$$  \ $$| $$  | $$
//|  $$$$$$/| $$$$$$$$|  $$$$$$/| $$  | $$
// \______/ |________/ \______/ |__/  |__/
// sesh.vala       Nine-H GPL3+ 2016.06.15

class DemoSwitcher : Gtk.ComboBox {

    public signal void demo_changed (string path);
    //FIXME: hardcoded
    private string base_path = "/home/nine/Projects/sesh/data";
    private Gtk.ListStore demo_list;
    private Gtk.TreeIter iter;
    
    public DemoSwitcher () {
        demo_list = new Gtk.ListStore(1, typeof(string));
        
        try {
            var directory = File.new_for_path(base_path);
            var enumerator = directory.enumerate_children(FileAttribute.STANDARD_NAME, 0);
            FileInfo file_info;
            while ((file_info = enumerator.next_file()) != null) {
                if (file_info.get_file_type () == FileType.DIRECTORY) {
                    demo_list.append(out iter);
                    demo_list.set(iter, 0, file_info.get_name());
                }
            }
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }
        
        Gtk.CellRendererText renderer = new Gtk.CellRendererText ();
        
        this.pack_start (renderer, true);
        this.add_attribute (renderer, "text", 0);
        this.active = 0;
        this.model = demo_list;
        this.changed.connect (change_demo);
    }
    
    public void change_demo () {
        Value demo;
        this.get_active_iter (out iter);
        demo_list.get_value (iter, 0, out demo);
        demo_changed("%s/%s/".printf(base_path, demo.get_string()));
    }
}
