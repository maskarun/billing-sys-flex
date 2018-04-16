package com.arun.billingsystem.domain
{
	import spark.components.ComboBox;
	import spark.components.TextInput;

	[RemoteClass(alias="org.arun.billingsystem.domain.Stock")]
	public class Stock
	{
		
		[Bindable]public var isCheckBoxSelected:Boolean = false;
		
		public var id:int;
		public var itemCode:String;
		public var date:String;
		public var itemName:String;
		public var category:String;
		public var size:Number;
		public var soldPrice:Number;
		
		public var soldQuantity:int;
		public var totalAmount:Number;
		public var discount:Number;
		public var demage:Number;
		public var status:String;
		public var noOfPrint:Number;
		
		public var printer:Printer;
		public var purchasePrice:Number;
		public var purchaseName:String;
		public var purchaseDate:String;
		public var purchaseAmtSettled:Number;
		public var purchaseQty:Number;
		public var type:String;
		public var comments:String;
		
	}
}