package com.arun.billingsystem.service
{
	import com.arun.billingsystem.common.Constant;
	import com.arun.billingsystem.common.ErrorConstant;
	import com.arun.billingsystem.domain.Search;
	import com.arun.billingsystem.domain.Stock;
	import com.arun.billingsystem.model.ReportModel;
	import com.arun.billingsystem.model.presentation.HomePresentation;
	import com.arun.billingsystem.model.presentation.ReportPresentation;
	import com.arun.billingsystem.util.ResourceUtil;
	import com.arun.billingsystem.view.popups.ShowAlert;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import org.swizframework.utils.services.ServiceHelper;

	public class ReportServiceHelper extends ServiceHelper
	{
		
		[Inject(source="reportModel")]
		public var reportModel:ReportModel;
		[Inject(source="reportPresentation")]
		public var reportPresentation:ReportPresentation;
		[Inject(source="homePresentation")]
		public var homePresentation:HomePresentation;
		
		private var searchRemoteObject:RemoteObject = ResourceUtil.getRemoteService("searchController");
		
		/**
		 * Search 
		 * 
		 */
		public function search_handler(search:Search):void 
		{
			if(search != null) {
				homePresentation.enableDisable(false);
				executeServiceCall(searchRemoteObject.getSearchDetail(search),searchResultHandler, searchFaultHandler);
			} else {
				ShowAlert.show(ErrorConstant.ERROR_125, Constant.POP_UP, Constant.SHOW_IMG_WAR);
			}
		}
		
		public function searchResultHandler(result:ResultEvent):void {
			homePresentation.enableDisable(true);
			var search:Search = result.result as Search;
			if(search != null){
				reportModel.search = search;
			} else {
				ShowAlert.show(ErrorConstant.ERROR_123, Constant.POP_UP, Constant.SHOW_IMG_WAR);
			}
		}
		
		public function searchFaultHandler(fault:FaultEvent):void {
			homePresentation.enableDisable(true);
			ShowAlert.show(fault.fault.faultString, Constant.POP_UP, Constant.SHOW_IMG_WAR);
		}
		
		
		public function stock_Purchase(purchaserName:String):void 
		{
			if(purchaserName != null && purchaserName != "") {
				homePresentation.enableDisable(false);
				executeServiceCall(searchRemoteObject.getStockPurchaserDetail(purchaserName),stockPurchaseResultHandler, stockPurchaseFaultHandler);
			} else {
				ShowAlert.show(ErrorConstant.ERROR_124, Constant.POP_UP, Constant.SHOW_IMG_WAR);
			}
		}
		
		public function stockPurchaseResultHandler(result:ResultEvent):void {
			homePresentation.enableDisable(true);
			var stckPurchaserList:ArrayCollection = result.result as ArrayCollection;
			if(stckPurchaserList != null){
				reportModel.stkPurchaserList = stckPurchaserList;
			} else {
				ShowAlert.show(ErrorConstant.ERROR_123, Constant.POP_UP, Constant.SHOW_IMG_WAR);
			}
		}
		
		public function stockPurchaseFaultHandler(fault:FaultEvent):void {
			homePresentation.enableDisable(true);
			ShowAlert.show(fault.fault.faultString, Constant.POP_UP, Constant.SHOW_IMG_WAR);
		}
		
		public function stock_addPurchase(stock:Stock):void {
			if(stock != null) {
				homePresentation.enableDisable(false);
				executeServiceCall(searchRemoteObject.getStockAddPurchaserDetail(stock),stockAddPurchaseResultHandler, stockPurchaseFaultHandler);
			} else {
				ShowAlert.show(ErrorConstant.ERROR_124, Constant.POP_UP, Constant.SHOW_IMG_WAR);
			}
		}
		
		public function stockAddPurchaseResultHandler(resultEvt:ResultEvent):void {
			homePresentation.enableDisable(true);
			var stck:Stock = resultEvt.result as Stock;
			if(stck != null){
				if(stck.type == Constant.STOCK_ADD) {
					reportModel.addstkPurchaserList(stck);
				}
			} else {
				ShowAlert.show(ErrorConstant.ERROR_123, Constant.POP_UP, Constant.SHOW_IMG_WAR);
			}
		}
		
	}
}