package com.arun.billingsystem.model.presentation
{
	import com.arun.billingsystem.common.Constant;
	import com.arun.billingsystem.common.ErrorConstant;
	import com.arun.billingsystem.controller.LoginController;
	import com.arun.billingsystem.controller.ShortCutController;
	import com.arun.billingsystem.domain.LoadApp;
	import com.arun.billingsystem.event.RootEvent;
	import com.arun.billingsystem.model.UserModel;
	import com.arun.billingsystem.util.ResourceUtil;
	import com.arun.billingsystem.view.Home;
	import com.arun.billingsystem.view.Login;
	import com.arun.billingsystem.view.popups.SettingPopUp;
	import com.arun.billingsystem.view.popups.ShowAlert;
	
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	
	import mx.managers.CursorManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import org.swizframework.controller.AbstractController;

	public class HomePresentation extends AbstractController
	{
		
		[Inject(source="userModel")]
		public var userModel:UserModel;
		[Inject(source="reportPresentation")]
		public var reportPresentation:ReportPresentation;
		[Inject(source="stockPresentation")]
		public var stockPresentation:StockPresentation;
		[Inject(source="tabBillingPresentation")]
		public var tabBillingPresentation:TabBillingPresentation;
		[Inject(source="viewBillingPresentation")]
		public var viewBillingPresentation:ViewBillingPresentation;
		[Inject(source="shortCutController")]
		public var shortCutController:ShortCutController;
		
		[Dispatcher]public var dispatch:IEventDispatcher;
		
		private var loginRemoteObject:RemoteObject = ResourceUtil.getRemoteService("loginController");
		
		
		public var home:Home;
		
		[ViewAdded]
		public function homeViewAdded( home : Home ) : void
		{
			this.home = home;
		}
		
		[ViewRemoved]
		public function homeViewRemoved( home : Home) : void
		{
			this.home = null;
		}

		public function home_creationCompleteHandler():void
		{
			if(userModel.displayScreen != null){
				if(home != null){
					home.mainMenuBar.dataProvider = userModel.displayScreen;
					home.fullNameText.text = userModel.fullName;
					var type:String = userModel.loadApp.userType.toLowerCase();
					home.setting.visible = (type == 'admin'|| type == 'systemadmin') ? true : false;
					home.mainMenuBar.selectedIndex = 0;
					mainMenuBar_clickHandler();
					home.addEventListener(KeyboardEvent.KEY_DOWN, shortCutController.keyUpHandler);
				}
			} else {
				LoginController.loginView = 0;
				ShowAlert.show(ErrorConstant.ERROR_100, Constant.POP_UP, Constant.SHOW_IMG_WAR);
			}
		}
		
		public function mainMenuBar_clickHandler():void
		{
			var selectedName:String = home.mainMenuBar.selectedItem;
			if(selectedName == Constant.MENU_BILLING){
				home.homeViewStack.selectedIndex = 0;
				tabBillingPresentation.setFocus_TabBilling();
			} else if(selectedName == Constant.MENU_VIEW_BILLING) {
				home.homeViewStack.selectedIndex = 1;
				viewBillingPresentation.viewBilling_creationCompleteHandler();
			} else if(selectedName == Constant.MENU_STOCK){
				home.homeViewStack.selectedIndex = 2;
				stockPresentation.stockView_creationCompleteHandler();
			} else if(selectedName == Constant.MENU_REPORT){
				home.homeViewStack.selectedIndex = 3;
				reportPresentation.search_creationCompleteHandler(true);
			} else if(selectedName == Constant.MENU_VIDEO) {
				home.homeViewStack.selectedIndex = 4;
			}
		}
		
		public function logOut_clickHandler():void
		{
			userModel.displayScreen = null;
			userModel.fullName = null;
			userModel.categoryList = null;
			LoginController.loginView = 0;
			var rootEvent:RootEvent = new RootEvent(RootEvent.EVENT_LOGOUT);
			rootEvent.loadApp = userModel.loadApp;
			dispatch.dispatchEvent(rootEvent);
		}
		
		public function enableDisable(isEnable:Boolean):void {
			if(home != null) {
				home.enabled = isEnable;
			}
			if(isEnable) {
				CursorManager.removeBusyCursor();
			} else {
				CursorManager.setBusyCursor();
			}
		}
		
		public function setBusyCursor(isCursor:Boolean):void {
			if(isCursor) {
				CursorManager.setBusyCursor();
			} else {
				CursorManager.removeBusyCursor();
			}
		}
		
		[EventHandler(event="RootEvent.EVENT_SETTING", properties="loadApp")]
		public function updateSetting(loadApp:LoadApp):void {
			if(loadApp != null){
				enableDisable(true);
				userModel.loadApp = loadApp;
				tabBillingPresentation.shortcut_F1();
				executeServiceCall(loginRemoteObject.updateLoadApp(loadApp), settingResultHandler, settingFaultHandler);
			}
		}
		
		public function settingResultHandler(result:ResultEvent):void {
			enableDisable(true);
			var saveComplete:Boolean = result.result as Boolean;
			if(saveComplete){
				SettingPopUp.remove();
			}
		}
		
		public function settingFaultHandler(fault:FaultEvent):void {
			enableDisable(true);
			ShowAlert.show(fault.fault.faultString, Constant.POP_UP, Constant.SHOW_IMG_WAR);
		}
	}
}