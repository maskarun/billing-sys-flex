package com.arun.billingsystem.model
{
	import com.arun.billingsystem.common.Constant;
	import com.arun.billingsystem.domain.LoadApp;
	import com.arun.billingsystem.domain.Purchase;
	import com.arun.billingsystem.domain.Stock;
	import com.arun.billingsystem.util.FormatUtil;
	
	import flash.net.SharedObject;
	
	import mx.collections.ArrayCollection;

	public class UserModel
	{
		public var loadApp:LoadApp;
		public var fullName:String;
		public var hostName:String;
		
		public var displayScreen:ArrayCollection;
		public var categoryList:ArrayCollection;
		public var itemNameList:ArrayCollection;
		public var purchaseNameList:ArrayCollection;
		
		public var sizeList:ArrayCollection;
		public var userList:ArrayCollection;
		public var employerList:ArrayCollection;
		private var _stockDetail:ArrayCollection;
		
		public var shareObject:SharedObject;
		public var clearPurchaseArr:ArrayCollection = new ArrayCollection();

		public function get stockDetail():ArrayCollection
		{
			return _stockDetail;
		}

		public function set stockDetail(value:ArrayCollection):void
		{
			if(value != null){
				_stockDetail = value;
				itemNameList = FormatUtil.sortFieldCol(getUniqueItemName(value), true);
				purchaseNameList = FormatUtil.sortFieldCol(getUniquePurchaseName(value), false);
			}
		}
		
		private function getUniqueItemName(totalArrColl:ArrayCollection):ArrayCollection {
			var unique:Object = {};
			var value:String;
			var array:Array = totalArrColl.toArray();
			var result:Array = [];
			var n:int = array.length;
			for (var i:int = 0; i < array.length; i++)
			{
				value = array[i].itemName;
				if (!unique[value])
				{
					unique[value] = true;
					result.push(value);
				}
				
			}
			return new ArrayCollection(result);
		}
		
		private function getUniquePurchaseName(stockArr:ArrayCollection):ArrayCollection {
			var array:Array = stockArr.toArray();
			var unique:Object = {};
			var value:String;
			var result:Array = [];
			var n:int = array.length;
			for (var i:int = 0; i < array.length; i++)
			{
				value = array[i].purchaseName;
				if (!unique[value])
				{
					unique[value] = true;
					result.push(value);
				}
				
			}
			return new ArrayCollection(result);
		}
		
		public function getItemCodeDetial(itemCode:int):Stock {
			var stock:Stock = null;
			var stockDet:ArrayCollection = stockDetail;
			if(stockDet != null && stockDet.length > 0){
				for(var i:int=0;i<stockDet.length;i++){
					var stk:Stock = stockDet.getItemAt(i) as Stock;
					if(int(stk.itemCode) == itemCode){
						stock = stk;
						break;
					}
				}
			}
			return stock;
		}
		
		private function getSharedObject():SharedObject {
			if(shareObject == null){
				shareObject = SharedObject.getLocal("clearPurchaseData");
			}
			return shareObject;
		}
		/**
		 * Add the Clear purchase information to cache array for that day
		 */
		public function addClearPurchase(purchase:Purchase):void {
			shareObject = getSharedObject();
			if(clearPurchaseArr != null && shareObject != null) {
				var shareDate:String = shareObject.data.currentDate;
				var currentDate:String = FormatUtil.dateToString(new Date());
				if(shareDate == currentDate) {
					clearPurchaseArr = shareObject.data.clearPurchaseArr as ArrayCollection;
					clearPurchaseArr.addItem(purchase);
					shareObject.data.clearPurchaseArr = clearPurchaseArr;
				} else {
					shareObject.clear();
					shareObject.data.currentDate = currentDate;
					clearPurchaseArr.addItem(purchase);
					shareObject.data.clearPurchaseArr = clearPurchaseArr;
				}
			}
		}
		
		public function get clearPurchase():ArrayCollection {
			shareObject = getSharedObject();
			if(shareObject != null) {
				return shareObject.data.clearPurchaseArr as ArrayCollection;
			}
			return null;
		}
	}
}