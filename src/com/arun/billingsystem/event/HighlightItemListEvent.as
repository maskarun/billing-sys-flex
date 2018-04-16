package com.arun.billingsystem.event {
	
    import flash.events.Event;
    	
    public class HighlightItemListEvent extends Event {
		
        public static const ITEM_CLICK : String = "itemClick";
        
        public static const LOOKUP_VALUE_CHANGE : String = "lookupValueChange";
                
        public function HighlightItemListEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
        	super(type, bubbles, cancelable);			        
        }

    }
}