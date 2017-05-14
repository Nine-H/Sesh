class FFTStreamer : Object {
    public signal void fft_update (float[] data);
    
    private Gst.Pipeline pipeline;
	private MainLoop loop = new MainLoop ();
    
	public void play () {
		pipeline = new Gst.Pipeline ("pipeline");

		var source = Gst.ElementFactory.make ("pulsesrc", "source");
        source.set_property ("client-name", "SESH");
        //FIXME: pulling fucking mic audio like a fucking shit. how the fuck do I get a specific client?
        
        var spectrum = Gst.ElementFactory.make ("spectrum", "spectrum");
        spectrum.set_property ("multi-channel", true);
        spectrum.set_property ("interval", 10000000);
        spectrum.set_property ("bands", 20);
        spectrum.set_property ("post-messages", true);
        spectrum.set_property ("message-magnitude", true);
        
        var sink = Gst.ElementFactory.make ("fakesink", "sink");
        
        pipeline.add_many (source, spectrum, sink);
        source.link (spectrum);
        spectrum.link (sink);
        
        Gst.Bus bus = pipeline.get_bus ();
        bus.add_watch (0, bus_callback);
        
        pipeline.set_state (Gst.State.PLAYING);
        
        loop.run ();
	}
	
	public void close_stream () {
	    pipeline.set_state (Gst.State.NULL);
		loop.quit ();
	}
	
	private bool bus_callback (Gst.Bus bus, Gst.Message message) {
		switch (message.type) {
		    case Gst.MessageType.ELEMENT:
		        GLib.Value magnitude = message.get_structure ().copy ().get_value ("magnitude");
		        float fft_array[20];
		        for ( int i = 0; i < 20; i++) {
		            fft_array[i] = (float)Gst.ValueArray.get_value(Gst.ValueArray.get_value(magnitude, 0), i);
	            }
	            fft_update(fft_array);
		        break;
			case Gst.MessageType.ERROR:
				GLib.Error err;
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
