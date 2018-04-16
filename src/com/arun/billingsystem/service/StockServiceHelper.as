package com.arun.billingsystem.service
{
	import com.arun.billingsystem.common.Constant;
	import com.arun.billingsystem.common.ErrorConstant;
	import com.arun.billingsystem.domain.Stock;
	import com.arun.billingsystem.model.StockModel;
	import com.arun.billingsystem.model.UserModel;
	import com.arun.billingsystem.model.presentation.HomePresentation;
	import com.arun.billingsystem.model.presentation.StockPresentation;
	import com.arun.billingsystem.util.ResourceUtil;
	import com.arun.billingsystem.view.popups.ShowAlert;
	import com.arun.billingsystem.view.popups.StockAddPopUp;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import org.osmf.events.TimeEvent;
	import org.swizframework.utils.services.ServiceHelper;

	public class StockServiceHelper extends ServiceHelper
	{
		[Inject(source="stockModel")]
		public var stockModel:StockModel;
		[Inject(source="userModel")]
		public var userModel:UserModel;
		[Inject(source="homePresentation")]
		public var homePresentation:HomePresentation;
		[Inject(source="stockPresentation")]
		public var stockPresentation:StockPresentation;
		
		private var deleteArrColl:ArrayCollection;
		
		private var stockRemoteObject:RemoteObject = ResourceUtil.getRemoteService("stockController");
		
		public function showStockDetail():void {
			if(stockModel.stockArrColl == null){
				homePresentation.enableDisable(false);
				executeServiceCall(stockRemoteObject.showStockDetail(),saveStockDetailResultHandler, saveStockDetailFaultHandler);
			}
		}
		
		public function showStockDetailResultHandler(result:ResultEvent):void {
			homePresentation.enableDisable(true);
			var stockList:ArrayCollection = result.result as ArrayCollection;
			if(stockList != null && stockList.length > 0){
				stockModel.stockArrColl = stockList;
//				ShowAlert.show(ErrorConstant.ERROR_119, Constant.POP_UP, Constant.SHOW_IMG_SUC);
			} else {
				ShowAlert.show(ErrorConstant.ERROR_120, Constant.POP_UP, Constant.SHOW_IMG_WAR);
			}
		}
		
		public function showStockDetailFaultHandler(fault:FaultEvent):void {
			homePresentation.enableDisable(true);
			ShowAlert.show(fault.fault.faultString, Constant.POP_UP, Constant.SHOW_IMG_WAR);
		}
		
		public function saveStockDetail(stockArr:ArrayCollection):void {
			if(stockArr != null){
				executeServiceCall(stockRemoteObject.saveStockDetail(stockArr), saveStockDetailResultHandler, saveStockDetailFaultHandler);
				ShowAlert.show(ErrorConstant.ERROR_103, Constant.POP_UP_PRINT, Constant.SHOW_IMG_SUC);
			}
		}
		
		public function saveStockDetailResultHandler(result:ResultEvent):void {
			homePresentation.enableDisable(true);
			ShowAlert.remove();
			var stockList:ArrayCollection = result.result as ArrayCollection;
			if(stockList){
				var addStockList:ArrayCollection = stockModel.stockArrColl;
				addStockList.addAll(stockList);
				stockModel.stockArrColl = addStockList;
				userModel.stockDetail = addStockList;
				ShowAlert.show(ErrorConstant.ERROR_119, Constant.POP_UP, Constant.SHOW_IMG_SUC);
			} else {
				ShowAlert.show(ErrorConstant.ERROR_120, Constant.POP_UP, Constant.SHOW_IMG_WAR);
			}
		}
		
		public function saveStockDetailFaultHandler(fault:FaultEvent):void {
			homePresentation.enableDisable(true);
			ShowAlert.remove();
			ShowAlert.show(fault.fault.faultString, Constant.POP_UP, Constant.SHOW_IMG_WAR);
		}
		
		
		public function updateStockDetail(stock:Stock):void {
			if(stock != null){
				executeServiceCall(stockRemoteObject.updateStockDetail(stock), updateStockDetailResultHandler, updateStockDetailFaultHandler);
				ShowAlert.show(ErrorConstant.ERROR_103, Constant.POP_UP_PRINT, Constant.SHOW_IMG_SUC);
			}
		}
		
		public function updateStockDetailResultHandler(result:ResultEvent):void {
			ShowAlert.remove();
			homePresentation.enableDisable(true);
			var isUpdate:Boolean = result.result as Boolean;
			if(isUpdate){
				ShowAlert.show(ErrorConstant.ERROR_134, Constant.POP_UP, Constant.SHOW_IMG_SUC);
			}
		}
		
		public function updateStockDetailFaultHandler(fault:FaultEvent):void {
			ShowAlert.remove();
			homePresentation.enableDisable(true);
			ShowAlert.show(fault.fault.faultString, Constant.POP_UP, Constant.SHOW_IMG_WAR);
		}
		
		
		public function deleteStockDetail(deleteArr:ArrayCollection):void {
			if(deleteArr != null){
				homePresentation.enableDisable(false);
				this.deleteArrColl = deleteArr;
				executeServiceCall(stockRemoteObject.deleteStockDetail(deleteArr), deleteStockDetailResultHandler, deleteStockDetailFaultHandler);
			}
		}
		
		public function deleteStockDetailResultHandler(result:ResultEvent):void {
			homePresentation.enableDisable(true);
			var isDelete:Boolean = result.result as Boolean;
			if(isDelete){
				for(var i:int=0; i<deleteArrColl.length; i++) {
					var itemCode:int = deleteArrColl.getItemAt(i) as int;
					var stockarr:ArrayCollection = stockModel.stockArrColl;
					for(var j:int=0; j<stockarr.length; j++) {
						var stock:Stock = stockarr.getItemAt(j) as Stock;
						if(itemCode == int(stock.itemCode)){
							stockModel.stockArrColl.removeItemAt(j);
							break;
						}
					}
				}
			}
		}
		
		public function deleteStockDetailFaultHandler(fault:FaultEvent):void {
			homePresentation.enableDisable(true);
			ShowAlert.show(fault.fault.faultString, Constant.POP_UP, Constant.SHOW_IMG_WAR);
		}
		
		
	}
}