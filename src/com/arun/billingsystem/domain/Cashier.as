package com.arun.billingsystem.domain
{
	[Bindable]
	[RemoteClass(alias="org.arun.billingsystem.domain.Cashier")]
	public class Employer
	{
		public var Id:Number;
		public var fullName:String;
		public var salesTotal:Number = 0;
		public var totalQty:Number = 0;
	}
}