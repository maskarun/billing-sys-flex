package com.arun.billingsystem.service
{
	import com.arun.billingsystem.common.Constant;
	import com.arun.billingsystem.common.ErrorConstant;
	import com.arun.billingsystem.domain.Purchase;
	import com.arun.billingsystem.model.TabBillingModel;
	import com.arun.billingsystem.model.UserModel;
	import com.arun.billingsystem.model.ViewBillingModel;
	import com.arun.billingsystem.model.presentation.HomePresentation;
	import com.arun.billingsystem.model.presentation.TabBillingPresentation;
	import com.arun.billingsystem.model.presentation.ViewBillingPresentation;
	import com.arun.billingsystem.util.ResourceUtil;
	import com.arun.billingsystem.view.popups.ReturnBillingPopUp;
	import com.arun.billingsystem.view.popups.ShowAlert;
	import com.arun.billingsystem.view.popups.ViewBillingPopUp;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import org.swizframework.utils.services.ServiceHelper;

	public class TabBillingServiceHelper extends ServiceHelper
	{
		[Inject(source="tabBillingModel")]
		public var tabBillingModel:TabBillingModel;
		[Inject(source="viewBillingModel")]
		public var viewBillingModel:ViewBillingModel;
		[Inject(source="tabBillingPresentation")]
		public var tabBillingPresentation:TabBillingPresentation;
		[Inject(source="homePresentation")]
		public var homePresentation:HomePresentation;
		[Inject(source="userModel")]
		public var userModel:UserModel;
		
		private var isPrint:Boolean = false;
		private var billingRemoteObject:RemoteObject = ResourceUtil.getRemoteService("billingController");
		
		/**
		 * Save Bill 
		 * @param purchase
		 * 
		 */
		public function saveBill_handler(print:Boolean, purchase:Purchase):void
		{
			if(purchase != null){
				homePresentation.enableDisable(false);
				isPrint = print;
				executeServiceCall(billingRemoteObject.saveBill(print, userModel.hostName, purchase), saveBillResultHandler, saveBillFaultHandler);
				if(isPrint) {
					ShowAlert.show(ErrorConstant.ERROR_103, Constant.POP_UP_PRINT, Constant.SHOW_IMG_SUC);
				}
			}
		}
		
		public function saveBillResultHandler(result:ResultEvent):void {
			homePresentation.enableDisable(true);
			var saveComplete:Boolean = result.result as Boolean;
			if(saveComplete){
				tabBillingModel.purchase = new Purchase();
				ShowAlert.remove();
			}
		}
		
		public function saveBillFaultHandler(fault:FaultEvent):void {
			homePresentation.enableDisable(true);
			ShowAlert.remove();
			ShowAlert.show(fault.fault.faultString, Constant.POP_UP, Constant.SHOW_IMG_WAR);
		}
		
		/**
		 * Print Bill 
		 * @param purchase
		 * 
		 */
		public function printBill_handler(purchase:Purchase):void
		{
			if(purchase != null) {
				homePresentation.enableDisable(false);
				executeServiceCall(billingRemoteObject.printBill(purchase), printBillResultHandler, printBillFaultHandler);
				ShowAlert.show(ErrorConstant.ERROR_103, Constant.POP_UP_PRINT, Constant.SHOW_IMG_SUC);
			}
		}
		
		public function printBillResultHandler(result:ResultEvent):void {
			homePresentation.enableDisable(true);
			var isPrint:Boolean = result.result as Boolean;
			if(isPrint){
				ShowAlert.remove();
			}
		}
		
		public function printBillFaultHandler(fault:FaultEvent):void {
			homePresentation.enableDisable(true);
			ShowAlert.remove();
			ShowAlert.show(fault.fault.faultString, Constant.POP_UP, Constant.SHOW_IMG_WAR);
		}
		
		/**
		 * Today's Bill List 
		 * @param purchase
		 * 
		 */
		public function todaysBill_handler(date:String):void
		{
			homePresentation.enableDisable(false);
			executeServiceCall(billingRemoteObject.todaysBill(date), todaysBillResultHandler, todaysBillFaultHandler);
		}
		
		public function todaysBillResultHandler(result:ResultEvent):void {
			homePresentation.enableDisable(true);
			var purchaseObj:Object = result.result as Object;
			if(purchaseObj != null){
				viewBillingModel.purchaseObj = purchaseObj;
			} else {
				ShowAlert.show(ErrorConstant.ERROR_130, Constant.POP_UP, Constant.SHOW_IMG_WAR);
			}
		}
		
		public function todaysBillFaultHandler(fault:FaultEvent):void {
			homePresentation.enableDisable(true);
			ShowAlert.show(fault.fault.faultString, Constant.POP_UP, Constant.SHOW_IMG_WAR);
		}
		
		/**
		 * Print Sales Bill List 
		 * @param purchase
		 * 
		 */
		public function printSales_handler(date:String):void
		{
			homePresentation.enableDisable(false);
			executeServiceCall(billingRemoteObject.printSales(date), printSalesResultHandler, printSalesFaultHandler);
		}
		
		public function printSalesResultHandler(result:ResultEvent):void {
			homePresentation.enableDisable(true);
		}
		
		public function printSalesFaultHandler(fault:FaultEvent):void {
			homePresentation.enableDisable(true);
			ShowAlert.show(fault.fault.faultString, Constant.POP_UP, Constant.SHOW_IMG_WAR);
		}
		
		
		/**
		 * Open Bill 
		 * @param billNo
		 * 
		 */
		public function openBill_handler(billNo:String):void
		{
			homePresentation.enableDisable(false);
			executeServiceCall(billingRemoteObject.openBill(billNo), openBillResultHandler, openBillFaultHandler);
		}
		
		public function openBillResultHandler(result:ResultEvent):void {
			homePresentation.enableDisable(true);
			var purchase:Purchase = result.result as Purchase;
			if(purchase != null){
				//Open Billing in popupwindow
				purchase.stockDetailList = userModel.stockDetail;
				ReturnBillingPopUp.purchase = purchase;
//				viewBillingModel.purchase = purchase;
			} else {
				ShowAlert.show(ErrorConstant.ERROR_117, Constant.POP_UP, Constant.SHOW_IMG_WAR);
			}
		}
		
		public function openBillFaultHandler(fault:FaultEvent):void {
			homePresentation.enableDisable(true);
			ShowAlert.show(fault.fault.faultString, Constant.POP_UP, Constant.SHOW_IMG_WAR);
		}
		
		/**
		 * Cancel Bill 
		 * @param billNo
		 * 
		 */
		public var updatePurchase:Purchase;
		public function cancelBill_handler(purchase:Purchase):void
		{
			if(purchase.billNo != null && purchase.billNo != ""){
				updatePurchase = purchase;
				homePresentation.enableDisable(false);
				executeServiceCall(billingRemoteObject.cancelBill(purchase.billNo), cancelBillResultHandler, cancelBillFaultHandler);
			}
		}
		
		public function cancelBillResultHandler(result:ResultEvent):void {
			homePresentation.enableDisable(true);
			var cancel:Boolean = result.result as Boolean;
			if(cancel){
				updateGrid(updatePurchase);
				ShowAlert.show(ErrorConstant.ERROR_118, Constant.POP_UP, Constant.SHOW_IMG_SUC);
			}
		}
		
		public function cancelBillFaultHandler(fault:FaultEvent):void {
			homePresentation.enableDisable(true);
			ShowAlert.show(fault.fault.faultString, Constant.POP_UP, Constant.SHOW_IMG_WAR);
		}
		
		/**
		 * Update Bill 
		 * @param billNo
		 * 
		 */
		
		public function updateBill_handler(purchase:Purchase):void
		{
			if(purchase != null){
				updatePurchase = purchase;
				homePresentation.enableDisable(false);
				executeServiceCall(billingRemoteObject.updateBill(purchase), updateBillResultHandler, updateBillFaultHandler);
			}
		}
		
		public function updateBillResultHandler(result:ResultEvent):void {
			homePresentation.enableDisable(true);
			var update:Boolean = result.result as Boolean;
			if(update){
				updateGrid(updatePurchase);
				ShowAlert.show(ErrorConstant.ERROR_133, Constant.POP_UP, Constant.SHOW_IMG_SUC);
				
			}
		}
		
		public function updateBillFaultHandler(fault:FaultEvent):void {
			homePresentation.enableDisable(true);
			ShowAlert.show(fault.fault.faultString, Constant.POP_UP, Constant.SHOW_IMG_WAR);
		}
		
		public function updateGrid(purchase:Purchase):void {
			var purchaseObj:Object = viewBillingModel.purchaseObj;
			if(purchaseObj != null && updatePurchase != null){
				if(purchaseObj[updatePurchase.billNo] != null){
					purchaseObj[updatePurchase.billNo] = updatePurchase;
					viewBillingModel.updateGrid();
				}
			}
			ViewBillingPopUp.removePopup();
		}
		
		/**
		 * Return Bill 
		 * @param purchase
		 * 
		 */
		public function returnBill_handler(purchase:Purchase):void
		{
			if(purchase != null){
				homePresentation.enableDisable(false);
				executeServiceCall(billingRemoteObject.returnBill(purchase), returnBillResultHandler, returnBillFaultHandler);
			}
		}
		
		public function returnBillResultHandler(result:ResultEvent):void {
			homePresentation.enableDisable(true);
			var returnBill:Boolean = result.result as Boolean;
			if(returnBill){
				tabBillingPresentation.return_closeHandler();
//				ShowAlert.show(ErrorConstant.ERROR_133, Constant.POP_UP, Constant.SHOW_IMG_SUC);
			}
		}
		
		public function returnBillFaultHandler(fault:FaultEvent):void {
			homePresentation.enableDisable(true);
			ShowAlert.show(fault.fault.faultString, Constant.POP_UP, Constant.SHOW_IMG_WAR);
		}
	}
}