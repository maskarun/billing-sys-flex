package com.arun.billingsystem.domain
{
	import mx.collections.ArrayCollection;

	[RemoteClass(alias="org.arun.billingsystem.domain.User")]
	public class User
	{
		public var id:Number;
		public var fullName:String;
		public var username:String;
		public var password:String;
		public var userType:String;
		public var date:String;
		public var isNew:Boolean = false;
	}
}