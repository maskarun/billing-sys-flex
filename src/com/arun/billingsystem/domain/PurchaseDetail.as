package com.arun.billingsystem.domain
{
	[Bindable][RemoteClass(alias="org.arun.billingsystem.domain.PurchaseDetail")]
	public class PurchaseDetail
	{
		public var quantityEditable:Boolean = false;
		public var sno:int;
		public var itemCode:String;
		public var itemName:String;
		public var category:String;
		public var quantity:Number;
		public var soldPrice:Number;
		public var purchasePrice:Number;
		public var totalAmount:Number;
		public var status:String;
		public var returnType:String;
	}
}