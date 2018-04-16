package com.arun.billingsystem.model.presentation
{
	import com.arun.billingsystem.common.Constant;
	import com.arun.billingsystem.common.ErrorConstant;
	import com.arun.billingsystem.domain.LoadApp;
	import com.arun.billingsystem.domain.Purchase;
	import com.arun.billingsystem.domain.PurchaseDetail;
	import com.arun.billingsystem.domain.Stock;
	import com.arun.billingsystem.model.BillingModel;
	import com.arun.billingsystem.model.UserModel;
	import com.arun.billingsystem.util.FormatUtil;
	import com.arun.billingsystem.util.StringUtil;
	import com.arun.billingsystem.view.Billing;
	import com.arun.billingsystem.view.popups.ShowAlert;
	
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	import mx.utils.ObjectUtil;

	public class BillingPresentation
	{
		public var billingModel:BillingModel = new BillingModel();
		public var billing:Billing;
		
		private var defaultQty:Number = 1;
		
		public function billingViewAdded( billing:Billing ) : void {
			this.billing = billing;
		}
				
		public function setBillingData(purchase:Purchase, loadApp:LoadApp):void {
			if(purchase != null){
				billing.categoryCmbBox.dataProvider = purchase.categoryList;
				billing.itemNameCmbBox.dataProvider = purchase.itemNameList;
				var stockDetails:ArrayCollection = ObjectUtil.copy(purchase.stockDetailList) as ArrayCollection;
				billing.itemCodeTxtInput.dataProvider = stockDetails;
				billing.categoryCmbBox.selectedIndex = 0;
				billing.itemNameCmbBox.selectedIndex = 0;
				billing.itemCodeTxtInput.setFocus();
//				setItemCodeView(loadApp.showItemCode, loadApp.showItemCodeNo);
				
				if(purchase.purchaseList != null){
					billingModel.billingArrColl = purchase.purchaseList;
					bindDataGridValue();
					updateTotal();
					enableDisable(false);
				}
			}
		}
		
		public function setItemCodeView(showItemCode:Boolean, showItemCodeNo:String):void{
//			if(showItemCode){
//				var stock:Stock = billing.getItemCodeDetial(Number(showItemCodeNo));
//				if(stock != null) {
//					billing.itemCodeTxtInput.selectedItem = stock;
//					billing.rateTxtInput.setFocus();
//				}
//				billing.itemCodeTxtInput.enabled = false;
//			} else {
//				billing.itemCodeTxtInput.enabled = true;
//				billing.itemCodeTxtInput.inputTxt.text = '';
//				billing.itemCodeTxtInput.setFocus();
//			}
		}
		
		public function getBillingData():Purchase {
			var purchase:Purchase = new Purchase();
			purchase.totalQty = Number(StringUtil.replace(billing.totalQuantityTxt.text, ",",""));
			purchase.returnQty = Number(StringUtil.replace(billing.totalReturnQtyTxt.text, ",",""));
			purchase.amountRecived = Number(StringUtil.replace(billing.subTotalTxtInput.text, ",",""));
			purchase.subTotal = Number(StringUtil.replace(billing.subTotalTxtInput.text, ",",""));
			purchase.discount = Number(StringUtil.replace(billing.discountTxtInput.text, ",",""));
			purchase.grandTotal = Number(StringUtil.replace(billing.grandTotalTxtInput.text, ",",""));
//			if(purchase.grandTotal > 0 && purchase.subTotal > 0){
			purchase.purchaseList = billingModel.billingArrColl;
//			} else {
//				ShowAlert.show(ErrorConstant.ERROR_107, Constant.POP_UP, Constant.SHOW_IMG_WAR);
//			}
			return purchase;
		}
		
		public function billing_reset():void {
			clearPurchaseDetail();
			clearTotal();
		}
		
		public function itemCodeTxtInput_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.TAB || event.keyCode == Keyboard.ENTER){
//			if(event.keyCode == Keyboard.ENTER){
				setStockDetail();
			}
		}

		public function enter_keyDownHandler():void {
			if(Number(billing.rateTxtInput.text) == 0){
				billing.discountTxtInput.setFocus();
			} else {
				billing.quantityTxtInput.text = "1";
				billing.quantityTxtInput.setFocus();
			}
		}
		
		public function setStockDetail():Boolean {
			var stock:Stock = Stock(billing.itemCodeTxtInput.selectedItem);
			if(stock != null){
				billing.categoryCmbBox.selectedItem = stock.category;
				billing.itemNameCmbBox.selectedItem = stock.itemName;
				billing.quantityTxtInput.text = defaultQty.toString();
				billing.rateTxtInput.text = stock.soldPrice.toString();
				billing.quantityTxtInput.setFocus();
				return true;
			} else {
				billing.discountTxtInput.setFocus();
				return false;
			}
		}
		
		public function addPurchaseDetail():void {
			var stock:Stock = billing.itemCodeTxtInput.selectedItem as Stock;
			if(stock != null) {
				var quantity:Number = Number(billing.quantityTxtInput.text);
				var rate:Number = Number(billing.rateTxtInput.text);
					if(quantity != 0 && rate > 0){
						var purchaseDetail:PurchaseDetail = new PurchaseDetail();
						purchaseDetail.category = stock.category;
						purchaseDetail.itemCode = stock.itemCode;
						purchaseDetail.itemName = stock.itemName;
						if(stock.discount != 0){
							rate = stock.soldPrice - (stock.soldPrice * (stock.discount / 100 ));
						}
						purchaseDetail.quantity = quantity;
						purchaseDetail.soldPrice = rate;
						purchaseDetail.totalAmount  = (quantity * rate);
						purchaseDetail.status = Constant.BILL_STATUS_CLOSED;
						billingModel.addPurchaseDetail(purchaseDetail);
						
						bindDataGridValue();
						
						updateTotal();
						
						clearPurchaseDetail();
						
//						if(!billing.loadApp.showItemCode){
//							billing.itemCodeTxtInput.setFocus();
//						} else {
//							billing.rateTxtInput.setFocus();
//						}
						
					} else {
						ShowAlert.show(ErrorConstant.ERROR_107, Constant.POP_UP, Constant.SHOW_IMG_WAR);
					}
			} else {
				ShowAlert.show(ErrorConstant.ERROR_108, Constant.POP_UP, Constant.SHOW_IMG_WAR);
			}
		}
		
		private function bindDataGridValue():void {
			var tempArrColl:ArrayCollection = billingModel.billingArrColl;
			billing.billingGrid.dataProvider = tempArrColl;
			billingModel.billingArrColl.refresh();
		}
				
		private function setValue():void {
			var subTotalAmount:String = FormatUtil.numberFormat(billingModel.getSubTotalAmount());
			billing.subTotalTxtInput.text = subTotalAmount;
			if(Number(billing.discountTxtInput.text) > 0) {
				discountTxtInput_focusOutHandler();
			} else {
				billing.grandTotalTxtInput.text = subTotalAmount;
				billing.grandTotalTxt.text = subTotalAmount;
			}
		}
		
		public function deletePurchaseDetail():void {
			if(billing.billingGrid.selectedIndex >= 0){
				billing.discountTxtInput.text = '0';
				var purchaseDetail:PurchaseDetail = billing.billingGrid.selectedItem as PurchaseDetail;
				var index:int = billingModel.billingArrColl.getItemIndex(purchaseDetail);
				billingModel.billingArrColl.removeItemAt(index);
				bindDataGridValue();
				updateTotal();
				billing.itemCodeTxtInput.setFocus();
			}
		}
				
		public function categoryCmbBox_focusOutHandler():void
		{
			var category:String = billing.categoryCmbBox.selectedItem;
			if(billing.purchase.categoryList != null && !StringUtil.contains(billing.purchase.categoryList, category)){
				billing.categoryCmbBox.selectedIndex = 0;
				ShowAlert.show(ErrorConstant.ERROR_105, Constant.POP_UP, Constant.SHOW_IMG_WAR);
			}
		}
		
		public function itemNameCmbBox_focusOutHandler():void
		{
			var itemName:String = billing.itemNameCmbBox.selectedItem;
			if(billing.purchase.itemNameList != null && !StringUtil.contains(billing.purchase.itemNameList, itemName)){
				billing.itemNameCmbBox.selectedIndex = 0;
				ShowAlert.show(ErrorConstant.ERROR_104, Constant.POP_UP, Constant.SHOW_IMG_WAR);
			}
		}
		
		public function discountTxtInput_focusOutHandler():void
		{
			var totalAmount:Number = billingModel.getDiscount(billing.subTotalTxtInput.text, billing.discountTxtInput.text);
//			if(totalAmount > 0 ){
				billing.grandTotalTxtInput.text = FormatUtil.numberFormat(totalAmount);
				billing.grandTotalTxt.text = FormatUtil.numberFormat(totalAmount);
//			} else {
//				billing.discountTxtInput.text = "";
//			}
		}
		
		public function doneBtn_buttonHandler():void {
			var total:Number = Number(billing.grandTotalTxtInput.text); 
			if(total == 0){
				ShowAlert.show(ErrorConstant.ERROR_111, Constant.POP_UP, Constant.SHOW_IMG_WAR);
			} else {
				billing.tabBillingPresentation.saveBill_clickHandler(Constant.BILL_STATUS_CLOSED);
			}
		}
		
		public function grandTotalTxtInput_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ENTER){
				doneBtn_buttonHandler();
			}
		}
		
		public function clearPurchaseDetail():void {
//			if(!billing.loadApp.showItemCode){		
				billing.categoryCmbBox.selectedIndex = 0;
				billing.itemNameCmbBox.selectedIndex = 0;
				billing.itemCodeTxtInput.inputTxt.text = '';
				billing.itemCodeTxtInput.selectedItem = null;
				billing.itemCodeTxtInput.setFocus();
//			}
			billing.quantityTxtInput.text = '0';
			billing.rateTxtInput.text = '0';
		}
		
		public function clearTotal():void {
			if(billingModel.billingArrColl != null){
				billingModel.billingArrColl = null;
				billing.billingGrid.dataProvider = billingModel.billingArrColl;
				billing.billingGrid.rowCount = 1;
			}
			billing.subTotalTxtInput.text = '0';
			billing.totalQuantityTxt.text = '0';
			billing.discountTxtInput.text = '0';
			billing.grandTotalTxt.text = '0';
			billing.grandTotalTxtInput.text = '0';
		}
		
		public function updateTotal():void {
			var subTotalAmount:String = FormatUtil.numberFormat(billingModel.getSubTotalAmount());
			billing.subTotalTxtInput.text = subTotalAmount;
			var arrQty:Array = billingModel.getTotalQuantity().split('&');
			billing.totalQuantityTxt.text = arrQty[0].toString();
			billing.totalReturnQtyTxt.text = arrQty[1].toString();
			if(Number(billing.discountTxtInput.text) > 0) {
				discountTxtInput_focusOutHandler();
			} else {
				billing.grandTotalTxtInput.text = subTotalAmount;
				billing.grandTotalTxt.text = subTotalAmount;
			}
		}
		
		public function enableDisable(isEnabled:Boolean):void {
			billing.itemCodeTxtInput.enabled = isEnabled;
			billing.quantityTxtInput.enabled = isEnabled;
			billing.rateTxtInput.enabled = isEnabled;
			billing.discountTxtInput.enabled = isEnabled;
			billing.grandTotalTxt.enabled = isEnabled;
			billing.grandTotalTxtInput.enabled = isEnabled;
			billing.categoryCmbBox.enabled = isEnabled;
			billing.itemNameCmbBox.enabled = isEnabled;
			billing.billingGrid.enabled = isEnabled;
//			billing.doneBtn.enabled = isEnabled;
			billing.itemCodeTxtInput.setFocus();
		}
		
		public function disableEnable(enable:Boolean):void {
			billing.enabled = enable;
		}
	}
}