package com.arun.billingsystem.controller
{
	import com.arun.billingsystem.common.Constant;
	import com.arun.billingsystem.domain.LoadApp;
	import com.arun.billingsystem.domain.Purchase;
	import com.arun.billingsystem.model.presentation.TabBillingPresentation;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.Alert;

	public class ShortCutController
	{
		[Inject(source="tabBillingPresentation")]
		public var tabBillingPresentation:TabBillingPresentation;
		
		public function keyUpHandler(event:KeyboardEvent):void
		{
			var control:Boolean = event.ctrlKey;
			//Open New Tab
			if(event.keyCode == Keyboard.F1){
				tabBillingPresentation.addTabBilling();
			}
			//Clear Tab details
			else if(event.keyCode == Keyboard.F2){
				tabBillingPresentation.clear_clickHandler();
			}
			//Close Tab
			else if(event.keyCode == Keyboard.F3) {
				tabBillingPresentation.shortcut_removeTabBilling();
			}
			//Print & Save the Bill
			else if(event.keyCode == Keyboard.F4){
				tabBillingPresentation.saveBill_clickHandler(Constant.BILL_STATUS_CLOSED);
			}
			
			if(control){
				//Change Tab
				if(event.keyCode == Keyboard.TAB){
					tabBillingPresentation.shortcut_changeTabBilling();
				}
				else if(event.keyCode == Keyboard.D){
					tabBillingPresentation.setDiscount_focusHandler();
				} 
			}
		}
	}
}