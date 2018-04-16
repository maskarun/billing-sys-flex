package com.arun.billingsystem.model.presentation
{
	import com.arun.billingsystem.common.Constant;
	import com.arun.billingsystem.common.ErrorConstant;
	import com.arun.billingsystem.domain.Sales;
	import com.arun.billingsystem.domain.Search;
	import com.arun.billingsystem.model.ReportModel;
	import com.arun.billingsystem.service.ReportServiceHelper;
	import com.arun.billingsystem.util.FormatUtil;
	import com.arun.billingsystem.view.ReportView;
	import com.arun.billingsystem.view.popups.ShowAlert;
	
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;

	public class ReportPresentation
	{
		[Inject(source="reportModel")]
		public var reportModel:ReportModel;
		[Inject(source="reportServiceHelper")]
		public var reportServiceHelper:ReportServiceHelper;
		
		public var reportView:ReportView;
		private var search:Search;
		
		[ViewAdded]
		public function searchViewAdded( reportView : ReportView ) : void
		{
			this.reportView = reportView;
		}
		
		[ViewRemoved]
		public function searchViewRemoved( reportView : ReportView ) : void
		{
			this.reportView = null;
		}
		
		public function search_creationCompleteHandler(isReset:Boolean, isEmployee:Boolean=false):void {
			if(isReset && reportView != null){
				var currentDate:Date = new Date();
				reportView.fromDate.selectedDate = currentDate;
				reportView.toDate.selectedDate = currentDate;
			}
			 search = new Search();
			 if(reportView != null) {
				 if(isEmployee){
					search.fromDate = showFromDate_changeHandler();
				 } else {
					 search.fromDate = fromDate_changeHandler(); 
				 }
				 search.toDate = toDate_changeHandler();
				 if(validation(search)){
					reportServiceHelper.search_handler(search);
				 }
			 }
		}
		
		public function refreshButtonClick():void{
			search = new Search();
			search.fromDate = fromDate_changeHandler();
			search.toDate = toDate_changeHandler();
			reportServiceHelper.search_handler(search);
		}
		
		[EventHandler(event="RootEvent.EVENT_REPORT")]
		public function getSearchModel():void {
			var search:Search = reportModel.search;
			var currentSales:Sales  = null;
			if(search != null){
				var tmpList:ArrayCollection = search.saleItemList;
				if(tmpList != null){
					for(var j:int = 0; j<tmpList.length;j++){
						var sales:Sales = tmpList.getItemAt(j) as Sales;
						if(sales != null && sales.date == search.fromDate){
							currentSales = sales;
							reportView.cashAmtTxt.text = FormatUtil.numberFormat(sales.cashAmt);
							reportView.cashQtyTxt.text = sales.cashQty.toString();
						}
					}
				}
				reportView.showSalesDG.dataProvider = search.saleItemList;
				
				//Cashier Grid
				if(reportView.showCashierDG != null  && search.cashierList != null){
					reportView.showCashierDG.dataProvider = search.cashierList;
					reportView.currentState = 'ShowDebit';
				}
				
				//Sales Chart
				var salesChart:ArrayCollection = new ArrayCollection();
				for(var i:int = 0; i<search.saleItemList.length;i++){
					var salesCht:Sales = search.saleItemList.getItemAt(i) as Sales;
					if(salesCht != null){
						salesChart.addItem({"date": salesCht.date, "cashAmt": salesCht.cashAmt});
					}
				}
				reportView.salesChart.dataProvider = salesChart;
				
				if(reportView.showFromDate.visible){
					reportView.employeeReport.showEmployeeReport();
				}
			}
			showStates(currentSales);
		}
		
		public function showStates(currentSales:Sales):void {
			if(currentSales != null){
				if(currentSales.cardAmt > 0){
					reportView.currentState = 'ShowCard';
					reportView.cardAmtText.text = FormatUtil.numberFormat(currentSales.cardAmt);
					reportView.cardQtyTxt.text = currentSales.cardQty.toString();
				}
				
//				if(currentSales.debitAmt > 0) {
//					reportView.currentState = 'ShowDebit';
//					reportView.debitAmtText.text = FormatUtil.numberFormat(currentSales.debitAmt);
//					reportView.debitQtyTxt.text = currentSales.debitQty.toString();
//				}
				
				if(currentSales.cardAmt > 0 && currentSales.debitAmt > 0) {
					reportView.currentState = 'ShowCardDebit';
				}
				
				if(currentSales.cardAmt <= 0 && currentSales.debitAmt <= 0) {
					reportView.currentState = 'DontShowCardDebit';
				}
			}
		}
		
		public function salesMenu_buttonBarClickHanlder():void {
			reportView.showFromDate.visible = false;
//			reportView.employeeLnkBut.selected = false;
			reportView.saleReportLnkBut.selected = true;
			reportView.reportViewStack.selectedIndex = 0;
//			reportView.fromDate.selectedDate = new Date();
		}
		
		public function employeeMenu_buttonBarClickHanlder():void {
//			reportView.employeeLnkBut.selected = true;
			reportView.saleReportLnkBut.selected = false;
			reportView.reportViewStack.selectedIndex = 1;
			reportView.showFromDate.visible = true;
//			reportView.showFromDate.selectedDate = new Date();
			if(reportView.employeeReport != null){
				reportView.employeeReport.showEmployeeReport();
			}
		}
		
		public function purchaseMenu_buttonBarClickHanlder():void {
			reportView.showFromDate.visible = false;
//			reportView.employeeLnkBut.selected = false;
			reportView.saleReportLnkBut.selected = false;
//			reportView.purchaseLnkBut.selected = true;
			reportView.reportViewStack.selectedIndex = 2;
		}
		
		public function fromDate_changeHandler():String
		{
			var date:Date = reportView.fromDate.selectedDate
			reportView.showFromDate.selectedDate = date;
			return FormatUtil.dateToString(date);
		}
		
		public function toDate_changeHandler():String
		{
			return FormatUtil.dateToString(reportView.toDate.selectedDate);
		}
		
		public function showFromDate_changeHandler():String
		{
			var date:Date = reportView.showFromDate.selectedDate;
			reportView.fromDate.selectedDate = date; 
			return FormatUtil.dateToString(date);
		}
		
		public function validation(search:Search):Boolean {
			var errMsg:String = null;
			if(search == null){
				ShowAlert.show(ErrorConstant.ERROR_125, Constant.POP_UP, Constant.SHOW_IMG_WAR);
				return false;
			}
			
			if(search.fromDate == "" || search.toDate == ""){
				ShowAlert.show(ErrorConstant.ERROR_126, Constant.POP_UP, Constant.SHOW_IMG_WAR);
				return false;
			}
			
			if(FormatUtil.compare(reportView.fromDate.selectedDate, reportView.toDate.selectedDate) == -1) {
				ShowAlert.show(ErrorConstant.ERROR_127, Constant.POP_UP, Constant.SHOW_IMG_WAR);
				return false;
			}
			return true;
		}
	}	
}