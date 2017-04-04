using Gst;

class FFTStreamer {
    public signal void fft_update ();    
    
    private Gst.Pipeline pipeline;
    private Gst.Element source;
    private Gst.Element spectrum;
    private Gst.Element sink;
	private MainLoop loop = new MainLoop ();
    
	public void play (string stream) {
		pipeline = new Gst.Pipeline ("pipeline");

		source = Gst.ElementFactory.make ("pulsesrc", "source");
        //FIXME: all the properties for the source are available online at
        //https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-plugins-good-plugins/html/gst-plugins-good-plugins-pulsesrc.html
        source.set_property ("client-name", "noise");
        
        spectrum = Gst.ElementFactory.make ("spectrum", "spectrum");
        //FIXME: all the properties for this sink are available online at:
        //https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-plugins-good-plugins/html/gst-plugins-good-plugins-spectrum.html
        spectrum.set_property ("multi-channel", true);
        spectrum.set_property ("interval", 100000000);
        spectrum.set_property ("bands", 20);
        spectrum.set_property ("post-messages", true);
        spectrum.set_property ("message-magnitude", true);
        
        sink = Gst.ElementFactory.make ("fakesink", "sink");
        
        pipeline.add_many (source, spectrum, sink);
        source.link (spectrum);
        spectrum.link (sink);
        
        Gst.Bus bus = pipeline.get_bus ();
        bus.add_watch (0, bus_callback);
        
        pipeline.set_state (State.PLAYING);
        
        loop.run ();
	}
	
	public void close_stream () {
		loop.quit ();
	}
	
	
	public void change_source () {
	    //write me :D
	}
	
	private bool bus_callback (Gst.Bus bus, Gst.Message message) {
		switch (message.type) {
		    case Gst.MessageType.ELEMENT:
		        GLib.Value magnitude = message.get_structure ().copy ().get_value ("magnitude");
		        /*
		        float[] spectrum = {};
		        for (int i = 0; i < magnitude.get_size(); i++) {
		            spectrum.append(magnitude.get_value(0).get_value(i));
		            //FIXME: this ain't how to add shit to arrays in vala.
		        }*/
		        stdout.printf ("%s\n\n", magnitude.strdup_contents ());
		        print (magnitude.type().name());
		        break;
		    case Gst.MessageType.STATE_CHANGED:
		        //stdout.printf ("hummm");
		        break;
			case Gst.MessageType.ERROR:
				GLib.Error err;
				string debug;
				message.parse_error (out err, out debug);
				warning (err.message);
				break;
			case Gst.MessageType.EOS:
				//FIXME: stream ends here, maybe start dumping in sinewaves or perlin noise to keep rendering nice.
				break;
       		default:
       			break;
		}
		
		return true;
	}
}
