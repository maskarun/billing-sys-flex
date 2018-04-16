package com.arun.billingsystem.util
{
	import mx.messaging.Channel;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	import mx.rpc.remoting.RemoteObject;

	public class ResourceUtil
	{
		private static var remoteObject:RemoteObject;
		private static var channelSet:ChannelSet;
		
		public static function getRemoteService(destinationName:String):RemoteObject {
			remoteObject = new RemoteObject();
			remoteObject.destination = destinationName;
			remoteObject.channelSet = getChannelSet();
			return remoteObject;
		}
		
		public static function getChannelSet():ChannelSet {
			if(channelSet == null){
				channelSet = new ChannelSet();
				var customChannal:Channel = new AMFChannel();
				customChannal.url = "http://localhost:8080/BillingSystem/messagebroker/amf";
				channelSet.addChannel(customChannal);
			}
			return channelSet;
		}
	}
}