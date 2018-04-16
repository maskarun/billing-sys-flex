package com.arun.billingsystem.util
{
	import com.arun.billingsystem.common.Constant;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.DateField;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.formatters.DateFormatter;
	import mx.formatters.NumberBaseRoundType;
	import mx.formatters.NumberFormatter;
	
	import spark.formatters.DateTimeFormatter;

	public class FormatUtil
	{
		public static const DATE_FORMAT:String = "YYYY-MM-DD";
		public static const DATE_FORMAT_STR:String = "DD MMM YYYY";
		public static const DATE_PICKER_FORMAT:String = "DD-MM-YYYY";
		public static const TIME_FORMAT:String = "KK:NN:SS";
		
		private static var numberFormatter:NumberFormatter;
		private static var formatter:NumberFormatter;
		
		private static function getNumberFormat():NumberFormatter
		{
			if(numberFormatter == null){
				numberFormatter = new NumberFormatter();
				numberFormatter.decimalSeparatorFrom = ".";
				numberFormatter.decimalSeparatorTo = ".";
				numberFormatter.precision = "2";
				numberFormatter.rounding = NumberBaseRoundType.UP;
				numberFormatter.thousandsSeparatorFrom = ",";
				numberFormatter.thousandsSeparatorTo = ",";
				numberFormatter.useNegativeSign = "true";
				numberFormatter.useThousandsSeparator = "true";
			}
			return numberFormatter;
		}
		
		private static function getNumberFormatter():NumberFormatter
		{
			if(formatter == null){
				formatter = new NumberFormatter();
				formatter.precision = "2";
				formatter.rounding = NumberBaseRoundType.NEAREST;
			}
			return numberFormatter;
		}
		
		public static function numberNearest(value:Number):Number {
			return Number(getNumberFormatter().format(value));
		}
		
		public static function numberFormat(value:Object):String {
			return getNumberFormat().format(value);
		}
		
		public static function myLabelFunction(item:Object, column:DataGridColumn):String {    
			return numberFormat(item[column.dataField]);
		}
		
		public static function myDateFunction(item:Object, column:DataGridColumn):String {
			return stringDateFormat(item[column.dataField]);
		}
		
		public static function stringDateFormat(value:String):String {
			var dateformatter:DateFormatter = new DateFormatter();
			dateformatter.formatString = DATE_FORMAT_STR;
			return dateformatter.format(stringToDate(value));
		}
		
		public static function stringToDate(value:String):Date {
			return DateField.stringToDate(value, DATE_FORMAT);
		}
		
		public static function mySQLDateFormat(value:String):String {
			var dateformatter:DateFormatter = new DateFormatter();
			dateformatter.formatString = DATE_FORMAT;
			return dateformatter.format(value);
		}
		
		public static function dateToString(value:Date):String {
			return DateField.dateToString(value, DATE_FORMAT);
		}
		
		public static function currentTime():String {
			var timeFormater:DateFormatter = new DateFormatter();
			timeFormater.formatString = TIME_FORMAT;
			return timeFormater.format(new Date()).toString()
		}
		
		public static function compare(date1:Date, date2:Date):Number
		{
			var result : Number = -1;
			
			if(date1.fullYear <= date2.fullYear){
				if(date1.month < date2.month){
					result = 0;
				} else if(date1.month == date2.month){
					if(date1.date <= date2.date){
						result = 0;
					}
				}
			} 		
			
			return result;
		}
		
		public static function sortFieldCol(arrayColl:ArrayCollection, isSelect:Boolean):ArrayCollection {
			if(arrayColl != null){
				if(isSelect) {
					arrayColl.addItemAt(Constant.SELECT, 0);
				}
				
				var s:Sort = new Sort();
				s.fields = [new SortField("value")];
				s.compareFunction = myCompare;
								
				arrayColl.sort = s;
				arrayColl.refresh();	
			}
			return arrayColl;
		}
		
		private static function myCompare(a:Object, b:Object, fields:Array = null):int
		{
			if(String(a) == Constant.SELECT)
			{
				return -1;
			}
			else if(String(b) == Constant.SELECT)
			{
				return 1;
			}
			
			// NEED to return default comparison results here?
			var s:Sort = new Sort();
			s.fields = fields;
			var f:Function = s.compareFunction;
			return f.call(null,a,b,fields);
		}
	}
}