package com.arun.billingsystem.model
{
	import com.arun.billingsystem.domain.Purchase;
	import com.arun.billingsystem.event.RootEvent;
	
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;

	public class ViewBillingModel
	{
		[Dispatcher]public var dispatch:IEventDispatcher;
		
		private var _purchaseObj:Object;
		
		[Bindable]
		public function get purchaseObj():Object
		{
			return _purchaseObj;
		}

		public function set purchaseObj(value:Object):void
		{
			if(value != null){
				_purchaseObj = value;
				dispatch.dispatchEvent(new RootEvent(RootEvent.EVENT_VIEW_BILLING));
			}
		}
		
		public function updateGrid():void {
			dispatch.dispatchEvent(new RootEvent(RootEvent.EVENT_VIEW_BILLING));
		}
	}
}