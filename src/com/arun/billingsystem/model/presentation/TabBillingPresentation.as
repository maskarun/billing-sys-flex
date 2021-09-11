package com.arun.billingsystem.model.presentation
{
	import com.arun.billingsystem.common.Constant;
	import com.arun.billingsystem.common.ErrorConstant;
	import com.arun.billingsystem.domain.Purchase;
	import com.arun.billingsystem.domain.Stock;
	import com.arun.billingsystem.model.TabBillingModel;
	import com.arun.billingsystem.model.UserModel;
	import com.arun.billingsystem.model.ViewBillingModel;
	import com.arun.billingsystem.service.TabBillingServiceHelper;
	import com.arun.billingsystem.util.FormatUtil;
	import com.arun.billingsystem.view.Billing;
	import com.arun.billingsystem.view.TabBilling;
	import com.arun.billingsystem.view.popups.AmtRecivedPopUp;
	import com.arun.billingsystem.view.popups.ReturnBillingPopUp;
	import com.arun.billingsystem.view.popups.ShowAlert;

	public class TabBillingPresentation
	{
		
		[Inject(source="tabBillingPresentation")]
		public var tabBillingPresentation:TabBillingPresentation;
		[Inject(source="tabBillingModel")]
		public var tabBillingModel:TabBillingModel;
		[Inject(source="userModel")]
		public var userModel:UserModel;
		[Inject(source="tabBillingServiceHelper")]
		public var tabBillingServiceHelper:TabBillingServiceHelper;
		[Inject(source="homePresentation")]
		public var homePresentation:HomePresentation;
		
		[Embed(source="/images/icon/deleteTab_12.png")]
		public var deleteTabImg:Class;
		
		public var tabBilling:TabBilling;
		private var tabCount:int = 1;
		
		[ViewAdded]
		public function tabBillingViewAdded( tabBilling:TabBilling ) : void
		{
			this.tabBilling = tabBilling;
		}
		
		[ViewRemoved]
		public function tabBillingViewRemoved( tabBilling:TabBilling ) : void
		{
			this.tabBilling = null;
		}
		
//		public function tabBilling_creationComplete():void {
//			tabBillingServiceHelper.newBill_handler(userModel.hostName);
//		}
		
//		public function billTypeRBGroup_changeHandler():void
//		{
//			var selectedValue:String = tabBilling.billTypeRBGroup.selectedValue.toString();
//			if(selectedValue != 'CASH'){
//				tabBilling.currentState = "ShowName";
//			} else {
//				tabBilling.currentState = "DontShowName";
//			}
//		}
		
		[EventHandler(event="RootEvent.EVENT_PURCHASE")]
		public function getPurchaseObject():void {
			var purchase:Purchase = tabBillingModel.purchase;
			if(purchase != null){
//				tabBilling.billNoTxt.text = purchase.billNo;
//				tabBilling.dateTxt.text = FormatUtil.stringDateFormat(purchase.date);
//				tabBilling.timeTxt.text = purchase.time;
//				tabBilling.status.text = purchase.status;
				removeTabBilling();
				if(tabBilling.tabNavigator.numChildren == 0){
					addTabBilling();
				}
			}
		}
		
		public function addTabBilling():void {
			var numChild:int = tabBilling.tabNavigator.numChildren;
			if(numChild < 5){
				var purchase:Purchase = new Purchase();
				purchase.categoryList = userModel.categoryList;
				purchase.itemNameList = userModel.itemNameList;
				purchase.stockDetailList = userModel.stockDetail;
				var billing:Billing = new Billing();
//				billing.icon = deleteTabImg;
				billing.label = "Bill No - " + tabCount;
				billing.purchase = purchase;
				billing.loadApp = userModel.loadApp;
				billing.tabBillingPresentation = this;
				setFocus_TabBilling();
				tabBilling.tabNavigator.addChild(billing);
				tabBilling.tabNavigator.selectedChild = billing;
				tabCount ++;
			}
		}
		
		public function activeTabBilling():Purchase {
			var purchase:Purchase = null;
			if(tabBilling.tabNavigator.selectedChild != null){
				var billing:Billing = Billing(tabBilling.tabNavigator.selectedChild);
				purchase = billing.billingPresentation.getBillingData();
				purchase.printer = userModel.loadApp.printer;
				setFocus_TabBilling();
			}
			return purchase;
		}
		
		public function removeTabBilling():void {
			var billing:Billing = Billing(tabBilling.tabNavigator.selectedChild);
			if(billing != null){
				tabBilling.tabNavigator.removeChild(billing);
			}
			setFocus_TabBilling();
		}
		
		public function setFocus_TabBilling():void {
			if(tabBilling.tabNavigator.selectedChild != null){
				var billing:Billing = Billing(tabBilling.tabNavigator.selectedChild);
//				if(userModel.loadApp.showItemCode){
//					billing.rateTxtInput != null ? billing.rateTxtInput.setFocus() : '';
//				} else {
					billing.itemCodeTxtInput != null ? billing.itemCodeTxtInput.setFocus() : '';
//				}
			}
		}
		
		public function shortcut_F1():void {
			if(tabBilling != null && tabBilling.tabNavigator.selectedChild != null){
				var billing:Billing = Billing(tabBilling.tabNavigator.selectedChild);
				if(billing != null){
//					var showItemCode:Boolean = billing.itemCodeTxtInput.enabled; 
//					billing.billingPresentation.setItemCodeView(userModel.loadApp.showItemCode, userModel.loadApp.showItemCodeNo);
					billing.itemCodeTxtInput.setFocus();
				}
			}
		}
		
		public function shortcut_removeTabBilling():void {
			var index:int = tabBilling.tabNavigator.numChildren;
			var billing:Billing = Billing(tabBilling.tabNavigator.selectedChild);
			if(billing != null && index > 1){
				clearStoredObject();
				tabBilling.tabNavigator.removeChild(billing);
			}
			setFocus_TabBilling();
		}
		
		public function shortcut_changeTabBilling():void {
			var index:int = tabBilling.tabNavigator.selectedIndex;
			var numChild:int = tabBilling.tabNavigator.numChildren - 1;
			
			if(index == numChild) {
				tabBilling.tabNavigator.selectedIndex = 0;
			} else if((index+1) <= numChild){
				tabBilling.tabNavigator.selectedIndex = (index + 1);
			}
		}
		
		private function checkComplusoryField(purchase:Purchase):Boolean {
			var billNo:String = purchase.billNo;
			var totalQty:Number = Number(purchase.totalQty);
			var isSuccess:Boolean = false;
			if(billNo != null && billNo != "" && totalQty > 0){
				isSuccess = true;
			}
			return isSuccess;
		}
		
		private function clearStoredObject():void {
			var purchase:Purchase = activeTabBilling();
			if(purchase != null && checkComplusoryField(purchase)){
				purchase.status = Constant.BILL_STATUS_CLEAR;
				purchase.time = FormatUtil.currentTime();
				userModel.addClearPurchase(purchase);
			}
		}
		
		public function tabNavigator_changeHandler():void
		{
			if(tabBilling.tabNavigator.selectedChild != null) {
				var billing:Billing = Billing(tabBilling.tabNavigator.selectedChild);
//				billing.itemCodeTxtInput.setFocus();
				setFocus_TabBilling();
			}
		}
		
		public function newBill_clickHandler():void
		{
			addTabBilling();
		}

		public function setItemCodeValue_clickHandler(itemCode:int):void
		{
			if(tabBilling.tabNavigator.selectedChild != null) {
				var billing:Billing = Billing(tabBilling.tabNavigator.selectedChild);
				var stock:Stock = userModel.getItemCodeDetial(itemCode);
				if(stock != null) {
					billing.itemCodeTxtInput.selectedItem = stock;
					billing.billingPresentation.setStockDetail();
					billing.rateTxtInput.setFocus();
				}
			}
		}
		
		public function setDiscount_focusHandler():void
		{
			if(tabBilling.tabNavigator.selectedChild != null) {
				var billing:Billing = Billing(tabBilling.tabNavigator.selectedChild);
				billing.discountTxtInput.setFocus();
			}
		}
		
		public function clear_clickHandler():void
		{
			clearStoredObject();
			if(tabBilling.tabNavigator.selectedChild != null) {
				var billing:Billing = Billing(tabBilling.tabNavigator.selectedChild);
				billing.billingPresentation.billing_reset();
//				billing.itemCodeTxtInput.setFocus();
			}
			setFocus_TabBilling();
		}
		
		public var returnBillingPopUp:ReturnBillingPopUp = null;
		public function return_clickHandler():void
		{
			returnBillingPopUp = ReturnBillingPopUp.show();
		}
		
		public function return_closeHandler():void
		{
			returnBillingPopUp.remove();
		}
		
		public function printBill_clickHandler():void
		{
			var purchase:Purchase = activeTabBilling();
			if(purchase != null && checkComplusoryField(purchase)){
				tabBillingServiceHelper.printBill_handler(purchase);
			} else {
				ShowAlert.show(ErrorConstant.ERROR_111, Constant.POP_UP, Constant.SHOW_IMG_WAR);
			}
		}
		
		public function saveBill_clickHandler(status:String):void
		{
			var purchase:Purchase = activeTabBilling();
			if(purchase != null && purchase.purchaseList != null && purchase.purchaseList.length > 0){
				purchase.status =  status;
				homePresentation.enableDisable(false);
				homePresentation.setBusyCursor(false);
				AmtRecivedPopUp.show(userModel.employerList, purchase, userModel.loadApp);
//				tabBillingServiceHelper.saveBill_handler(true, purchase);
			} else {
				ShowAlert.show(ErrorConstant.ERROR_112, Constant.POP_UP, Constant.SHOW_IMG_WAR);
			}
		}
		
		[EventHandler(event="RootEvent.EVENT_CONFIRMATION", properties="popUpType, purchase")]
		public function updateCancelBill(popUpType:String, purchase:Purchase):void {
			if(purchase != null){
				if(popUpType == Constant.BILL_SAVE){
					tabBillingServiceHelper.saveBill_handler(false, purchase);
				} else if(popUpType == Constant.BILL_PRINT){
					tabBillingServiceHelper.saveBill_handler(true, purchase);
				} else if(popUpType == Constant.BILL_UPDATE){
					tabBillingServiceHelper.updateBill_handler(purchase);
				} else if(popUpType == Constant.BILL_CANCEL){
					tabBillingServiceHelper.cancelBill_handler(purchase);
				} else if(popUpType == Constant.BILL_OPEN){
					tabBillingServiceHelper.openBill_handler(purchase.billNo);
				} else if(popUpType == Constant.BILL_RETURN){
					tabBillingServiceHelper.returnBill_handler(purchase);
				} 
			}
			//For Amount Recived popup to enable the screen on click of close button
			if(popUpType == Constant.BILL_CLOSE){
				homePresentation.enableDisable(true);
			}
		}
	}
}