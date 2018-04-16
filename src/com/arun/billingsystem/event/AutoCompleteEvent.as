package com.arun.billingsystem.event {
	
    import flash.events.Event;
    /**
     * <P>Custom event class.</P>
     * stores custom data in the <code>data</code> variable.
     */	
    public class AutoCompleteEvent extends Event {
		
        public static const SELECT : String = "select";
        
        public var data:Object;                
        
        public function AutoCompleteEvent(type:String, mydata:Object, bubbles:Boolean = false, cancelable:Boolean = false) {
        	super(type, bubbles,cancelable);			
        	data = mydata;
        }

    }
}