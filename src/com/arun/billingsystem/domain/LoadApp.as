package com.arun.billingsystem.domain
{
	import mx.collections.ArrayCollection;
	
	[RemoteClass(alias="org.arun.billingsystem.domain.LoadApp")]
	public class LoadApp
	{
		public var username:String;
		public var password:String;
		public var userType:String;
		public var hostName:String;
		public var name:String;
		public var fullName:String;
		public var showMachineName:Boolean;
		public var showAmountReceived:Boolean;
		public var machineName:String;
		public var showEmployee:Boolean;
		public var showCustomer:Boolean;
		public var showSize:Boolean;
		[Bindable]public var showItemCodeNo:String;
		public var showGST:Boolean;
		public var printer:Printer;
		public var userList:ArrayCollection;
		public var deleteUserList:ArrayCollection;
		public var employerList:ArrayCollection;
		public var deleteEmployerList:ArrayCollection;
		public var sizeList:ArrayCollection;
		public var displayScreen:ArrayCollection;
		public var stockDetail:ArrayCollection;
		public var categorys:ArrayCollection;
	}
}