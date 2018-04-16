package com.arun.billingsystem.model
{
	import com.arun.billingsystem.domain.Search;
	import com.arun.billingsystem.domain.Stock;
	import com.arun.billingsystem.event.RootEvent;
	
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;

	public class ReportModel
	{
		[Dispatcher]public var dispatch:IEventDispatcher;
		
		private var _search:Search;
		private var _stkPurchaserList:ArrayCollection;
		
		[Bindable]
		public function get stkPurchaserList():ArrayCollection
		{
			return _stkPurchaserList;
		}

		public function set stkPurchaserList(value:ArrayCollection):void
		{
			if(value != null){
				_stkPurchaserList = value;
				dispatch.dispatchEvent(new RootEvent(RootEvent.EVENT_REPORT_PURCHASE));
			}
		}
		
		public function addstkPurchaserList(stock:Stock):void
		{
			if(stock != null){
				_stkPurchaserList.addItem(stock);
				dispatch.dispatchEvent(new RootEvent(RootEvent.EVENT_REPORT_PURCHASE));
			}
		}

		[Bindable]
		public function get search():Search
		{
			return _search;
		}
		
		public function set search(value:Search):void
		{
			if(value != null){
				_search = value;
				dispatch.dispatchEvent(new RootEvent(RootEvent.EVENT_REPORT));
			}
			
		}
		
		
	}
}