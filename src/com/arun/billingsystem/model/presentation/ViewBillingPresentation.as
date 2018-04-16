package com.arun.billingsystem.model.presentation
{
	import com.arun.billingsystem.common.Constant;
	import com.arun.billingsystem.common.ErrorConstant;
	import com.arun.billingsystem.domain.Purchase;
	import com.arun.billingsystem.model.UserModel;
	import com.arun.billingsystem.model.ViewBillingModel;
	import com.arun.billingsystem.service.TabBillingServiceHelper;
	import com.arun.billingsystem.util.FormatUtil;
	import com.arun.billingsystem.view.ViewBilling;
	import com.arun.billingsystem.view.popups.OpenPopUp;
	import com.arun.billingsystem.view.popups.ShowAlert;
	import com.arun.billingsystem.view.popups.ViewBillingPopUp;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;

	public class ViewBillingPresentation
	{
		
		[Inject(source="tabBillingServiceHelper")]
		public var tabBillingServiceHelper:TabBillingServiceHelper;
		[Inject(source="viewBillingModel")]
		public var viewBillingModel:ViewBillingModel;
		[Inject(source="userModel")]
		public var userModel:UserModel;
		
		public var viewBilling:ViewBilling;
		
		
		[ViewAdded]
		public function tabBillingViewAdded( viewBilling:ViewBilling ) : void
		{
			this.viewBilling = viewBilling;
		}
		
		[ViewRemoved]
		public function tabBillingViewRemoved( viewBilling:ViewBilling ) : void
		{
			this.viewBilling = null;
		}
		
		public function viewBilling_creationCompleteHandler():void {
			if(viewBilling != null){
				tabBillingServiceHelper.todaysBill_handler(FormatUtil.dateToString(viewBilling.viewDate.selectedDate));
			}
		}
		
		public function viewBilling_Click():void {
			viewBilling.viewDate.enabled = true;
			viewBilling.printSaleBtn.enabled = true;
			viewBilling.statusVBox.visible = true;
			viewBilling_creationCompleteHandler();
		}
		
		public function clearBilling_Click():void {
			viewBilling.viewDate.enabled = false;
			viewBilling.printSaleBtn.enabled = false;
			viewBilling.statusVBox.visible = false;
			viewBilling.todaysDataGrid.dataProvider = userModel.clearPurchase;
		}
		
		[EventHandler(event="RootEvent.EVENT_VIEW_BILLING")]
		public function getPurchaseObject():void {
			var purchaseObj:Object = viewBillingModel.purchaseObj;
			if(purchaseObj != null){
				var purchaseList:ArrayCollection = new ArrayCollection();
				var grandTotal:Number = 0; var discount:Number = 0;
				var subTotal:Number = 0; var pics:Number = 0;
				for(var key:String in purchaseObj){
					var purchase:Purchase = purchaseObj[key] as Purchase;
					if(purchase.status != Constant.BILL_STATUS_CANCELLED){
						pics = pics + purchase.totalQty;
						subTotal = subTotal + purchase.subTotal;
						discount = discount + purchase.discount;
						grandTotal = grandTotal + purchase.grandTotal;
					}
					purchaseList.addItem(purchase);
				}
				viewBilling.todaysDataGrid.dataProvider = purchaseList;
				viewBilling.noOfTranscation.text = String(purchaseList.length);
				viewBilling.totalQty.text = String(pics);
				viewBilling.subTotal.text = String(subTotal);
				viewBilling.totalDiscount.text = String(discount);
				viewBilling.grandTotalText.text = FormatUtil.numberFormat(grandTotal);
				
			}
		}
		
		public function todaysDataGrid_itemClickHandler(event:ListEvent):void
		{
			var purchase:Purchase = event.target.selectedItem as Purchase;
			if(purchase != null){
				ViewBillingPopUp.show(purchase);
			}
		}
				
		public function printSale_clickHandler():void {
			tabBillingServiceHelper.printSales_handler(FormatUtil.dateToString(viewBilling.viewDate.selectedDate));
		}
	}
}