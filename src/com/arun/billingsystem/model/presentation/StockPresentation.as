package com.arun.billingsystem.model.presentation
{
	import com.arun.billingsystem.common.Constant;
	import com.arun.billingsystem.common.ErrorConstant;
	import com.arun.billingsystem.domain.Stock;
	import com.arun.billingsystem.model.StockModel;
	import com.arun.billingsystem.model.UserModel;
	import com.arun.billingsystem.service.StockServiceHelper;
	import com.arun.billingsystem.util.StringUtil;
	import com.arun.billingsystem.view.StockView;
	import com.arun.billingsystem.view.popups.ShowAlert;
	import com.arun.billingsystem.view.popups.StockAddPopUp;
	import com.arun.billingsystem.view.popups.StockSalesAddPopUp;
	import com.arun.billingsystem.view.popups.StockUpdatePopUp;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.events.CloseEvent;
	import mx.events.ListEvent;
	
	import spark.components.VGroup;

	public class StockPresentation
	{
		
		[Inject(source="stockModel")]
		public var stockModel:StockModel;
		[Inject(source="userModel")]
		public var userModel:UserModel;
		[Inject(source="stockServiceHelper")]
		public var stockServiceHelper:StockServiceHelper;
		[Inject(source="homePresentation")]
		public var homePresentation:HomePresentation;
		
		public var stockView:StockView;
		private var stockArrColl:ArrayCollection;
		private var deleteArrColl:ArrayCollection;
		
		[ViewAdded]
		public function stockViewViewAdded( stockView : StockView ) : void
		{
			this.stockView = stockView;
		}
		
		[ViewRemoved]
		public function stockViewViewRemoved( stockView : StockView ) : void
		{
			this.stockView = null;
		}

		public function stockView_creationCompleteHandler():void {
			if(stockView != null) {
				stockView.currentState = 'dontShowFilter';
				stockModel.stockArrColl = userModel.stockDetail;
				if(stockView.categoryCmbBox != null) {
					stockView.categoryCmbBox.dataProvider = userModel.categoryList;
				}
			}
		}
		
		public function stockViewSearch_hander():void {
			(stockView.currentState=='showFilter') ? stockView.currentState='dontShowFilter' : stockView.currentState='showFilter'; 
			if(stockView.categoryCmbBox != null) {
				stockView.categoryCmbBox.dataProvider = userModel.categoryList;
			}
			reset();
		}
		
		public function stockViewFilter_hander():void {
			if(stockView.itemCodeTxtInput.text != '' || stockView.categoryCmbBox.selectedItem != 'Select' 
				|| stockView.purchaseNameTxtInput.text != '' || stockView.itemNameTxtInput.text != ''){
				filter();
			} else {
				reset();
			}
		}
		
		public function filter():void {
			if(stockView.purchaseNameTxtInput.text != ""){
				stockView.itemCodeTxtInput.text = "";
				stockView.itemNameTxtInput.text = "";
				stockView.categoryCmbBox.selectedIndex = 0;
				stockArrColl.filterFunction = purchaseNamefilterValue;
			}
			if(stockView.itemNameTxtInput.text != ""){
				stockView.itemCodeTxtInput.text = "";
				stockView.purchaseNameTxtInput.text = "";
				stockView.categoryCmbBox.selectedIndex = 0;
				stockArrColl.filterFunction = itemNamefilterValue;
			} 
			if(stockView.itemCodeTxtInput.text != ""){
				stockView.purchaseNameTxtInput.text = "";
				stockView.itemNameTxtInput.text = "";
				stockView.categoryCmbBox.selectedIndex = 0;
				stockArrColl.filterFunction = itemfilterValue;
			}
			if(stockView.categoryCmbBox.selectedIndex != 0) {
				stockView.purchaseNameTxtInput.text = "";
				stockView.itemNameTxtInput.text = "";
				stockView.itemCodeTxtInput.text = "";
				stockArrColl.filterFunction = categoryfilterValue;
			}
			stockArrColl.refresh();
			setStatusFunction(stockArrColl);
		}
		
		public function reset():void {
			stockView.categoryCmbBox.selectedIndex = 0;
			stockView.itemCodeTxtInput.text = "";
			stockView.purchaseNameTxtInput.text = "";
			stockView.itemNameTxtInput.text = "";
			stockArrColl.filterFunction = null;
			stockArrColl.refresh();
//			stockView.addVgroup.numElements == 0 ? '' : stockView.addVgroup.removeAllElements();
			filter();
		}
		
		private function itemfilterValue(item:Object):Boolean {
			return item.itemCode.match(new RegExp("^" + stockView.itemCodeTxtInput.text, 'i'));
		}
		
		private function purchaseNamefilterValue(item:Object):Boolean {
			return item.purchaseName.match(new RegExp("^" + stockView.purchaseNameTxtInput.text, 'i'));
		}
		
		private function itemNamefilterValue(item:Object):Boolean {
			return item.itemName.match(new RegExp("^" + stockView.itemNameTxtInput.text, 'i'));
		}
		
		private function categoryfilterValue(item:Object):Boolean {
			return item.category.match(new RegExp("^" + String(stockView.categoryCmbBox.selectedItem), 'i'));
		}
		
		private function setStatusFunction(stockArrColl:ArrayCollection):void{
			if(stockArrColl != null){
				var purchaseQty:int = 0; var soldQty:int = 0; var demage:int = 0;
				for(var i:int=0;i<stockArrColl.length; i++){
					var stock:Stock = stockArrColl.getItemAt(i) as Stock;
					purchaseQty = purchaseQty + stock.purchaseQty;
					soldQty = soldQty + stock.soldQuantity;
					demage = demage + stock.demage;
				}
//				if(isPurchase){
//					addNameGroup(true, "Purchase Name :", purchaseName);
//				} else if(isItemName){
//					addNameGroup(true, "Item Name :", itemName);
//				} else if(isItemCode){
//					addNameGroup(true, "Item Code :", itemCode);
//				}
				stockView.purchaseQtyTxt.text = String(purchaseQty);
				stockView.soldQtyTxt.text = String(soldQty);
				stockView.demageTxt.text = String(demage);
			}
		}
				
//		private function addNameGroup(isRemove:Boolean, name:String, text:String):void {
//			var label:Label = new Label();
//			label.text = name;
//			label.styleName = "FormlabelStyle";
//			
//			var textStr:Text = new Text();
//			textStr.text = text;
//			textStr.styleName = "ViewStatusStyle";
//			
//			if(isRemove){
//				stockView.addVgroup.numElements == 0 ? '' : stockView.addVgroup.removeAllElements();
//			}
//			
//			stockView.addVgroup.addElement(label);
//			stockView.addVgroup.addElement(textStr);
//		}
				
		[EventHandler(event="RootEvent.EVENT_STOCK")]
		public function getStockModel():void {
			stockArrColl = stockModel.stockArrColl;
			if(stockArrColl != null && stockArrColl.length > 0){
				stockView.stockDataGrid.dataProvider = stockArrColl;
				if(stockArrColl.length > 20){
					stockView.stockDataGrid.rowCount = 20;
					stockView.stockDataGrid.verticalScrollPolicy = 'on';
				} else {
					stockView.stockDataGrid.rowCount = stockArrColl.length;
					stockView.stockDataGrid.verticalScrollPolicy = 'off';
				}
			}
		}
		
//		public function checkComplusoryField():Boolean {
//			var isSuccess:Boolean = false;
//			var itemName:String = stockView.itemNameTxtInput.text;
//			var category:String = stockView.categoryCmbBox.selectedItem;
//			var size:String = stockView.sizeCmbBox.selectedItem;
//			var purchaseRate:Number = Number(stockView.purchaseRateTxtInput.text);
//			var soldRate:Number = Number(stockView.soldRateTxtInput.text);
//			var totalQty:Number = Number(stockView.totalQtyTxtInput.text);
//			
//			if(itemName == "" && itemName == null){
//				ShowAlert.show(ErrorConstant.ERROR_121, Constant.POP_UP, Constant.SHOW_IMG_WAR);
//				return isSuccess;
//			}
//			
//			if((category == "" && category == null) || (size == "" && size == null)){
//				ShowAlert.show(ErrorConstant.ERROR_122, Constant.POP_UP, Constant.SHOW_IMG_WAR);
//				return isSuccess;
//			}
//			
//			if(purchaseRate == 0 || soldRate == 0 || totalQty == 0){
//				ShowAlert.show(ErrorConstant.ERROR_124, Constant.POP_UP, Constant.SHOW_IMG_WAR);
//				return isSuccess;
//			}
//			
//			return isSuccess = true;
//		}
		
//		public function addStockBtn_clickHandler():void {
//			if(checkComplusoryField()){
//				var stock:Stock = new Stock();
//				stock.category = stockView.categoryCmbBox.selectedItem;
//				stock.itemName = stockView.itemNameTxtInput.text;
//				stock.size = Number(stockView.sizeCmbBox.selectedItem);
//				stock.soldPrice = Number(stockView.soldRateTxtInput.text);
//				stock.purchasePrice = Number(stockView.purchaseRateTxtInput.text);
//				stock.totalQuantity = Number(stockView.totalQtyTxtInput.text);
//				stock.totalAmount = (stock.totalQuantity * stock.purchasePrice);
//				stockServiceHelper.saveStockDetail(stock);
//			}
//		}
		
//		public function categoryCmbBox_focusOutHandler():void
//		{
//			var category:String = stockView.categoryCmbBox.selectedItem;
//			if(userModel.categoryList != null && !StringUtil.contains(userModel.categoryList, category)){
//				stockView.categoryCmbBox.selectedIndex = 0;
//				ShowAlert.show(ErrorConstant.ERROR_105, Constant.POP_UP, Constant.SHOW_IMG_WAR);
//			}
//		}
		
//		public function sizeCmbBox_focusOutHandler():void
//		{
//			var size:String = stockView.sizeCmbBox.selectedItem;
//			if(userModel.sizeList != null && !StringUtil.contains(userModel.sizeList, size)){
//				stockView.sizeCmbBox.selectedIndex = 0;
//				ShowAlert.show(ErrorConstant.ERROR_102, Constant.POP_UP, Constant.SHOW_IMG_WAR);
//			}
//		}
		
		public function stockAdd_clickHandler():void
		{
			if(userModel != null) {
				homePresentation.enableDisable(false);
				homePresentation.setBusyCursor(false);
				if(userModel.loadApp.showSize){
					StockAddPopUp.show(userModel);
				} else {
					StockSalesAddPopUp.show(userModel);
				}
			}
		}
		
		public function stockDataGrid_itemClickHandler(event:ListEvent):void
		{
			var selectedStock:Stock = event.target.selectedItem as Stock;
			if(selectedStock != null) {
				homePresentation.enableDisable(false);
				homePresentation.setBusyCursor(false);
				StockUpdatePopUp.show(selectedStock);
			}
		}
		
		private function updateStock_clickHandler(stock:Stock):void {
			if(stock != null){
				var stockList:ArrayCollection = userModel.stockDetail;
				for(var i:int=0; i<stockList.length; i++){
					var stockStr:Stock = stockList.getItemAt(i) as Stock;
					if(stockStr.itemCode == stock.itemCode){
						stockStr.discount = stock.discount;
						stockStr.demage = stock.demage;
						stockStr.status = stock.status;
						break;
					}
				}
				stockServiceHelper.updateStockDetail(stock);
				stockView.stockDataGrid.dataProvider = userModel.stockDetail;
			}
		}
		
//		public function deleteStock_clickHandler():void
//		{
//			var tempArr:ArrayCollection = stockModel.stockArrColl;
//			var deleteArr:ArrayCollection = new ArrayCollection();
//			
//			if(tempArr != null && tempArr.length > 0){
//				for(var i:int=0; i<tempArr.length; i++){
//					var stock:Stock = tempArr.getItemAt(i) as Stock;
//					if(stock.isCheckBoxSelected){
//						deleteArr.addItem(stock.itemCode);
//					}
//				}
//				
//				if(deleteArr.length > 0){
//					this.deleteArrColl = deleteArr;
//					ShowAlert.show("Are you sure you want to update "+deleteArr.length+" stock detail(s)?", Constant.STOCK_DELETE, Constant.SHOW_IMG_WAR);
//				}
//			}
//		}
		
		[EventHandler(event="RootEvent.EVENT_STOCK_CONFIRMATION", properties="popUpType, stock, stockArr")]
		public function deleteStock(popUpType:String, stock:Stock, stockArr:ArrayCollection):void {
//			if(popUpType != null && popUpType == Constant.STOCK_DELETE){
//				stockServiceHelper.deleteStockDetail(deleteArrColl);
//			} else 
			if(popUpType != null && popUpType == Constant.STOCK_ADD){
				stockServiceHelper.saveStockDetail(stockArr);
			} else if(popUpType != null && popUpType == Constant.STOCK_UPDATE){
				updateStock_clickHandler(stock);
			}
			
			if(popUpType == Constant.STOCK_CLOSED){
				homePresentation.enableDisable(true);
			}
		}
	}
}