package com.arun.billingsystem.model
{
	import com.arun.billingsystem.event.RootEvent;
	
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;

	public class StockModel
	{
		[Dispatcher]public var dispatch:IEventDispatcher;
		
		private var _stockArrColl:ArrayCollection;
		
		[Bindable]
		public function get stockArrColl():ArrayCollection
		{
			return _stockArrColl;
		}

		public function set stockArrColl(value:ArrayCollection):void
		{
			if(value != null){
				_stockArrColl = value;
				dispatch.dispatchEvent(new RootEvent(RootEvent.EVENT_STOCK));
			}

		}
	}
}