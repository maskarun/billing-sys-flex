package com.arun.billingsystem.domain
{
	import mx.collections.ArrayCollection;

	[RemoteClass(alias="org.arun.billingsystem.domain.Printer")]
	public class Printer
	{
		public var name:String;
		public var address1:String;
		public var address2:String;
		public var phone:String;
		public var printerName:String;
		public var labelPrinterName:String;
		public var rateIncludeGST:Boolean;
		public var gstRateSlab:Number;
		public var gstTin:String;
		public var printGST:Boolean;
		public var igst:String;
		public var cgst:String;
		public var sgst:String;
		public var gst:String;
		public var includeGSTAmt:Boolean;
	}
}