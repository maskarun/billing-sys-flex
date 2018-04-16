package com.arun.billingsystem.common
{
	import mx.collections.ArrayCollection;

	public class Constant
	{
		
		public static const VIEW_PACKAGE:String = "com.arun.billingsystem.view.*";
		
		public static const EVENT_PACKAGE:String = "com.arun.billingsystem.event.*";
		
		public static const MENU_BILLING:String = "BILLING";
		public static const MENU_STOCK:String = "STOCK";
		public static const MENU_REPORT:String = "REPORT";
		public static const MENU_VIDEO:String = "VIDEO";
		public static const MENU_REPORT_Report:String = "Report";
		public static const MENU_REPORT_Sales:String = "Sales";
		public static const MENU_VIEW_BILLING:String = "SALES";
		
//		public static const BILL_TYPE_CASH:String = "CASH";
		
		public static const BILL_STATUS_NEW:String = "NEW BILL";
		public static const BILL_STATUS_SAVED:String = "SAVED";
		public static const BILL_STATUS_CANCELLED:String = "CANCELLED";
		public static const BILL_STATUS_CLOSED:String = "CLOSED";
		public static const BILL_STATUS_CLEAR:String = "CLEAR BILL";
		public static const BILL_STATUS_RETURN:String = "RETURN";
		
		public static const RETURN_TYPE_ADD:String = "ADD";
		public static const RETURN_TYPE_UPDATE:String = "UPDATE";
		
		public static const SELECT:String = "Select";
		
		public static const POP_UP:String = "POPUP";
		public static const POP_UP_CONF:String = "CONF";
		public static const POP_UP_PRINT:String = "PRINT";
		
		public static const BILL_SAVE:String = "Bill Save";
		public static const BILL_PRINT:String = "Bill Print";
		public static const BILL_OPEN:String = "Bill Open";
		public static const BILL_CANCEL:String = "Bill Cancel";
		public static const BILL_UPDATE:String = "Bill Update";
		public static const BILL_RETURN:String = "Bill Return";
		public static const BILL_CLOSE:String = "Bill Close";
		
		public static const STOCK_ADD:String = "Stock Add";
		public static const STOCK_UPDATE:String = "Stock Update";
		public static const STOCK_DELETE:String = "Stock Delete";
		public static const STOCK_CLOSED:String = "Stock Closed";
		
		public static const SHOW_IMG_SUC:String = "Success";
		public static const SHOW_IMG_WAR:String = "Warning";
		
		public static const BILL_STATUS_ARR:ArrayCollection = new ArrayCollection(['Saved','Cancelled','Closed']);
		public static const STOCK_STATUS_ARR:ArrayCollection = new ArrayCollection(['OPEN','CLOSED']);
		public static const BILL_TYPE_ARR:ArrayCollection = new ArrayCollection(['CASH','DEBIT']);
		public static const VIEW_BILL_TYPE:ArrayCollection = new ArrayCollection(["View Billing","Clear Billing"]);
		public static const REPORT_MENU_TYPE:ArrayCollection = new ArrayCollection(["Report","Sales"]);
	}
}