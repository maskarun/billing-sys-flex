package com.arun.billingsystem.domain
{
	import spark.components.ComboBox;
	import spark.components.TextInput;

	public class StockAdd
	{
		public var stock:Stock;		
		public var sizeCmb:ComboBox;
		public var categoryCmb:ComboBox;
		public var soldTxt:TextInput;
		public var printTxt:TextInput;
		public var itemNameTxt:TextInput;
	}
}