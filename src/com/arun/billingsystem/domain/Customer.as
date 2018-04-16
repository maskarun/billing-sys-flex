package com.arun.billingsystem.domain
{
	[Bindable]
	[RemoteClass(alias="org.arun.billingsystem.domain.Customer")]
	public class Customer
	{
		public var Id:Number;
		public var fullName:String;
		public var address1:String;
		public var address2:String;
		public var phoneNo:String;
		public var status:String;
	}
}