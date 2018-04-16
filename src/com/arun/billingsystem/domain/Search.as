package com.arun.billingsystem.domain
{
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="org.arun.billingsystem.domain.Search")]
	public class Search
	{
		public var fromDate:String;
		public var toDate:String;
		public var status:String;
		public var grandTotalAmt:Number = 0;
		public var grandTotalQty:Number = 0;
		
		public var soldItemList:ArrayCollection;
		public var saleItemList:ArrayCollection;
		public var employerSalesList:ArrayCollection;
		public var cashierList:ArrayCollection;
		public var stockPurchaser:Stock;
	}
}