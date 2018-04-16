package com.arun.billingsystem.controller
{
	import com.arun.billingsystem.common.Constant;
	import com.arun.billingsystem.domain.LoadApp;
	import com.arun.billingsystem.domain.User;
	import com.arun.billingsystem.model.UserModel;
	import com.arun.billingsystem.model.presentation.HomePresentation;
	import com.arun.billingsystem.util.FormatUtil;
	import com.arun.billingsystem.util.ResourceUtil;
	import com.arun.billingsystem.view.popups.ShowAlert;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	import mx.utils.ObjectUtil;
	
	import org.swizframework.controller.AbstractController;

	public class LoginController extends AbstractController
	{
		[Inject(source="userModel")]
		public var userModel:UserModel;
		[Inject(source="homePresentation")]
		public var homePresentation:HomePresentation;
		[Bindable]public static var loginView:int = 0;
		[Bindable]public static var machineNameArr:ArrayCollection;
		
		private var loginRemoteObject:RemoteObject = ResourceUtil.getRemoteService("loginController");
		
		[EventHandler(event="RootEvent.EVENT_LOGIN", properties="loadApp")]
		public function login_handler(loadApp:LoadApp):void
		{
			var error:String = validate(loadApp); 
			if(error == null) {
				userModel.loadApp = loadApp;
				executeServiceCall(loginRemoteObject.login(loadApp), loginResultHandler, loginFaultHandler);
			} else {
				ShowAlert.show(error, Constant.POP_UP, Constant.SHOW_IMG_WAR);
			}
		}
		
		public function loginResultHandler(result:ResultEvent):void {
			var loadApp:LoadApp = result.result as LoadApp;
			if(loadApp != null){
				userModel.fullName = loadApp.fullName;
				userModel.hostName = loadApp.hostName;
				userModel.userList = loadApp.userList;
				userModel.stockDetail = loadApp.stockDetail;
				userModel.displayScreen = loadApp.displayScreen;
				userModel.userList = loadApp.userList;
				userModel.employerList = loadApp.employerList;
				userModel.sizeList = FormatUtil.sortFieldCol(ObjectUtil.copy(loadApp.sizeList) as ArrayCollection, true);
				userModel.categoryList = FormatUtil.sortFieldCol(ObjectUtil.copy(loadApp.categorys) as ArrayCollection, true);
				userModel.loadApp = loadApp;
				loginView = 1;
				homePresentation.home_creationCompleteHandler();
			}
		}
		
		public function loginFaultHandler(fault:FaultEvent):void {
			ShowAlert.show(fault.fault.faultString, Constant.POP_UP, Constant.SHOW_IMG_WAR);
		}
		
		private function validate(loadApp:LoadApp):String {
			var error:String = null;
			if(loadApp == null){
				error = "User Object is NULL";
				return error;
			}
			
			if(loadApp.username == "" || loadApp.username == null) {
				error = "User Name is NULL";
				return error;
			}
			
			if(loadApp.password == "" || loadApp.password == null){
				error = "Password is NULL";
				return error;
			}
			return error;
		}
		
	}
}