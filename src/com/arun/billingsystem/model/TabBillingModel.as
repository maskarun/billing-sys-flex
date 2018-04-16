package com.arun.billingsystem.model
{
	import com.arun.billingsystem.domain.Purchase;
	import com.arun.billingsystem.event.RootEvent;
	
	import flash.events.IEventDispatcher;

	public class TabBillingModel
	{
		[Dispatcher]public var dispatch:IEventDispatcher;
		
		private var _purchase:Purchase;
		
		[Bindable]
		public function get purchase():Purchase
		{
			return _purchase;
		}
		
		public function set purchase(value:Purchase):void
		{
			if(value != null){
				_purchase = value;
				dispatch.dispatchEvent(new RootEvent(RootEvent.EVENT_PURCHASE));
			}
		}
	}
}