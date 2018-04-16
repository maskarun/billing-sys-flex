package com.arun.billingsystem.domain
{
	[RemoteClass(alias="org.arun.billingsystem.domain.Sales")]
	public class Sales
	{
		public var date:String = "";
		public var cashQty:int = 0;
		public var cardQty:int = 0;
		public var debitQty:int = 0;
		public var totalQty:int = 0;
		public var cashAmt:Number = 0;
		public var cardAmt:Number = 0;
		public var debitAmt:Number = 0;
		public var grandTotal:Number = 0;
	}
}