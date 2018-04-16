package com.arun.billingsystem.util
{
	import flashx.textLayout.utils.CharacterUtil;
	
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;
	
	public class StringUtil
	{
		public static function replace(value:String, replace:String, replaceWith:String):String {
			var finalString:String = "";
			if(value != null && value != "") {
				var text:String = mx.utils.StringUtil.trim(value);
				for(var i:int=0; i<text.length; i++){
					var character:String = text.charAt(i);
					if(character == replace){
						finalString = finalString + replaceWith;
					} else {
						finalString = finalString + character;
					}
				}
			}
			return finalString;
		}
		
		
		public static function contains(arrayCollection:ArrayCollection, value:String):Boolean {
			var isContain:Boolean = false;
			if(arrayCollection != null && arrayCollection.length > 0){
				if(value != "" && value != null){
					for(var i:int=0; i<arrayCollection.length; i++){
						if(arrayCollection.getItemAt(i).toString() == value) {
							isContain = true;
							break;
						}
					}
				}
			}
			return isContain;
		}
	}
}