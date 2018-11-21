//  /$$$$$$  /$$$$$$$$  /$$$$$$  /$$   /$$
// /$$__  $$| $$_____/ /$$__  $$| $$  | $$
//| $$  \__/| $$      | $$  \__/| $$  | $$
//|  $$$$$$ | $$$$$   |  $$$$$$ | $$$$$$$$
// \____  $$| $$__/    \____  $$| $$__  $$
// /$$  \ $$| $$       /$$  \ $$| $$  | $$
//|  $$$$$$/| $$$$$$$$|  $$$$$$/| $$  | $$
// \______/ |________/ \______/ |__/  |__/
// sesh.vala    (c)Nine-H GPL3+ 2016.06.15

class FFTStreamer : GLib.Object {

    public Value magnitude { get; set; }
    private Gst.Pipeline pipeline;
    
    public void play () {
        //FIXME: just use alsa mane
        dynamic Gst.Element source = Gst.ElementFactory.make ("pulsesrc", "source");
        source.client_name = "Sesh";
        //source.device = "alsa_output.pci-0000_00_1b.0.analog-stereo.monitor";
        source.device = "alsa_output.pci-0000_00_1f.3.analog-stereo.monitor";
        //FIXME: figure out some way to unmute monitor of built in stereo from the app.
        
        dynamic Gst.Element spectrum = Gst.ElementFactory.make ("spectrum", "spectrum");
        spectrum.multi_channel = true;
        spectrum.interval = 10000000;
        spectrum.bands = 128;
        spectrum.post_messages = true;
        spectrum.message_magnitude = true;
        
        var sink = Gst.ElementFactory.make ("fakesink", "sink");
        
        pipeline = new Gst.Pipeline ("pipeline");
        pipeline.add_many (source, spectrum, sink);
        source.link (spectrum);
        spectrum.link (sink);
        
        Gst.Bus bus = pipeline.get_bus ();
        bus.add_watch (0, bus_callback);
        
        pipeline.set_state (Gst.State.PLAYING);
    }
    
    public void close_stream () {
        pipeline.set_state (Gst.State.NULL);
    }
    
    private bool bus_callback (Gst.Bus bus, Gst.Message message) {
        switch (message.type) {
            case Gst.MessageType.ELEMENT:
                magnitude = message.get_structure().copy().get_value("magnitude");
                break;
            case Gst.MessageType.ERROR:
                Error err;
                string debug;
                message.parse_error (out err, out debug);
                warning (err.message);
                break;
            default:
                break;
        }
        return true;
    }
}
