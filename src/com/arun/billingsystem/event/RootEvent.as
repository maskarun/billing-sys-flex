package com.arun.billingsystem.event
{
	import com.arun.billingsystem.domain.LoadApp;
	import com.arun.billingsystem.domain.Purchase;
	import com.arun.billingsystem.domain.Stock;
	import com.arun.billingsystem.domain.User;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	public class RootEvent extends Event
	{
		public static const EVENT_LOGIN:String = "LoginEvent";
		public static const EVENT_LOGOUT:String = "LogOutEvent";
		public static const EVENT_PURCHASE:String = "PurchaseEvent";
		
		public static const EVENT_STOCK:String = "StockEvent";
		
		public static const EVENT_REPORT:String = "ReportEvent";
		public static const EVENT_REPORT_PURCHASE:String = "ReportPurchaseEvent";
		
		public static const EVENT_SETTING:String = "SettingEvent";
		public static const EVENT_CONFIRMATION:String = "ConfirmationEvent";
		public static const EVENT_STOCK_CONFIRMATION:String = "StockConfirmationEvent";
		
		public static const EVENT_VIEW_BILLING:String = "ViewBillingEvent";
		
		public var loadApp:LoadApp;
		public var popUpType:String;
		public var isPrint:Boolean;
		public var stockArr:ArrayCollection;
		public var stock:Stock;
		public var purchase:Purchase;
		
		public function RootEvent(type:String)
		{
			super(type, true, false);
		}
	}
}