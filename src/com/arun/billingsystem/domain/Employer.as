package com.arun.billingsystem.domain
{
	[Bindable]
	[RemoteClass(alias="org.arun.billingsystem.domain.Employer")]
	public class Employer
	{
		public var empId:Number;
		public var fullName:String;
		public var joiningDate:String;
		public var salary:Number;
		public var phoneNo:String;
		public var salesTotal:Number = 0;
		public var isNew:Boolean = false;
	}
}