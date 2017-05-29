class FFTStreamer {
    public signal void fft_update (Value data);
    
    private Gst.Pipeline pipeline;
    
	public void play () {
		pipeline = new Gst.Pipeline ("pipeline");

		var source = Gst.ElementFactory.make ("pulsesrc", "source");
        source.set_property ("client-name", "SESH");
        //source.set_property ("device", "alsa_output.pci-0000_00_1b.0.analog-stereo.monitor");
        //source.set_property ("device", "alsa_output.pci-0000_80_01.0.analog-stereo.monitor");
        //FIXME: pulling fucking mic audio like a fucking shit. how the fuck do I get a specific client?
        
        var spectrum = Gst.ElementFactory.make ("spectrum", "spectrum");
        spectrum.set_property ("multi-channel", true);
        spectrum.set_property ("interval", 10000000);
        spectrum.set_property ("bands", 128);
        spectrum.set_property ("post-messages", true);
        spectrum.set_property ("message-magnitude", true);
        
        var sink = Gst.ElementFactory.make ("fakesink", "sink");
        
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
		        Value magnitude = message.get_structure ().copy ().get_value ("magnitude");
	            fft_update(magnitude);
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
