package com.arun.billingsystem.domain
{
	import mx.collections.ArrayCollection;

	[RemoteClass(alias="org.arun.billingsystem.domain.Purchase")]
	public class Purchase
	{
		public var billNo:String;
		public var date:String;
		public var time:String;
		public var status:String;
		public var billType:String;
				
		public var amountRecived:Number;
		public var subTotal:Number;
		public var totalQty:Number;
		public var discount:Number;
		public var grandTotal:Number;

		public var returnQty:Number;
		public var returnDateTime:String;
		
		public var cashier:String;
		public var salesPerson:String;
		public var employer:Employer;
		public var printer:Printer;
		public var customer:Customer;
		
		public var billTypeList:ArrayCollection;
		public var purchaseList:ArrayCollection;
		[Bindable]public var customerList:ArrayCollection;
		[Bindable]public var stockDetailList:ArrayCollection;
		[Bindable]public var categoryList:ArrayCollection;
		[Bindable]public var itemNameList:ArrayCollection;
	}
}