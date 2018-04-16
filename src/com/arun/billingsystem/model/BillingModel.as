package com.arun.billingsystem.model
{
	import com.arun.billingsystem.domain.Purchase;
	import com.arun.billingsystem.domain.PurchaseDetail;
	import com.arun.billingsystem.domain.Stock;
	import com.arun.billingsystem.event.RootEvent;
	import com.arun.billingsystem.util.FormatUtil;
	import com.arun.billingsystem.util.StringUtil;
	
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;

	public class BillingModel
	{
//		[Dispatcher]public var dispatch:IEventDispatcher;
		[Bindable]public var billingArrColl:ArrayCollection;
		
//		private var _billingPurchase:Purchase;
//		
//		[Bindable]
//		public function get billingPurchase():Purchase
//		{
//			return _billingPurchase;
//		}
//
//		public function set billingPurchase(value:Purchase):void
//		{
//			if(value != null){
//				_billingPurchase = value;
//				dispatch.dispatchEvent(new RootEvent(RootEvent.EVENT_PURCHASE));
//			}
//		}
		
		public function getItemCodeDetial(stockDetail:ArrayCollection, itemCode:int):Stock {
			var stock:Stock = null;
			if(stockDetail != null && stockDetail.length > 0){
				for(var i:int=0;i<stockDetail.length;i++){
					var stk:Stock = stockDetail.getItemAt(i) as Stock;
					if(int(stk.itemCode) == itemCode){
						stock = stk;
						//For discount update the sold price
						if(stk.discount != 0){
							stock.soldPrice = stk.soldPrice - (stk.soldPrice * (stk.discount / 100 ));
						}
						break;
					}
				}
			}
			return stock;
		}
		
		public function addPurchaseDetail(purchaseDetail:PurchaseDetail):void {
			var isAdd:Boolean = false;
			if(billingArrColl != null && billingArrColl.length > 0){
				for(var i:int=0; i<billingArrColl.length; i++){
					var purDetail:PurchaseDetail = billingArrColl.getItemAt(i) as PurchaseDetail;
					if(purDetail.itemCode == purchaseDetail.itemCode && purDetail.soldPrice == purchaseDetail.soldPrice) {
						if(purchaseDetail.quantity > 0 && purDetail.quantity > 0){
							purDetail.quantity = FormatUtil.numberNearest(purchaseDetail.quantity + purDetail.quantity);
							purDetail.totalAmount = purDetail.quantity * purDetail.soldPrice;
							isAdd = false;
							break;
						} else {
							isAdd = true;
						}
					} else {
						isAdd = true;
					}
				}
				if(isAdd){
					purchaseDetail.sno = billingArrColl.length + 1;
					billingArrColl.addItem(purchaseDetail);
				}
			} else {
				billingArrColl = new ArrayCollection();
				purchaseDetail.sno = 1;
				billingArrColl.addItem(purchaseDetail);
			}
		}
		
		public function getSubTotalAmount():Number {
			var subtotal:Number = 0;
			if(billingArrColl != null && billingArrColl.length > 0){
				for(var i:int=0; i<billingArrColl.length; i++){
					var purchaseDetail:PurchaseDetail = billingArrColl.getItemAt(i) as PurchaseDetail;
//					if(purchaseDetail.totalAmount > 0){
						subtotal = subtotal + purchaseDetail.totalAmount;
//					}
				}
			}
			return subtotal;
		}
		
		public function getTotalQuantity():String {
			var totalQty:Number = 0; var returnQty:Number = 0;
			if(billingArrColl != null && billingArrColl.length > 0){
				for(var i:int=0; i<billingArrColl.length; i++){
					var purchaseDetail:PurchaseDetail = billingArrColl.getItemAt(i) as PurchaseDetail;
					if(purchaseDetail.quantity < 0){
						returnQty = returnQty + purchaseDetail.quantity;
					} else {
						totalQty =  FormatUtil.numberNearest(totalQty + purchaseDetail.quantity);
					}
				}
			}
			return totalQty + '&' + returnQty;
		}
		
		public function getDiscount(subTotalStr:String, discountStr:String):Number {
			var totalAmount:Number = 0;
			var subTotal:Number = Number(StringUtil.replace(subTotalStr, ",", ""));
			var discount:Number = Number(StringUtil.replace(discountStr, ",", ""));
//			if(subTotal > 0){
				totalAmount = subTotal - (discount);
//			} 
//			if(discount == 0) {
//				totalAmount = subTotal;
//			}
			return totalAmount;
		}
	}
}