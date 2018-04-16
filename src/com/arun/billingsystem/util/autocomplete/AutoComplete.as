package com.arun.billingsystem.util.autocomplete {

	import com.arun.billingsystem.domain.Stock;
	import com.arun.billingsystem.event.AutoCompleteEvent;
	import com.arun.billingsystem.event.HighlightItemListEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	import mx.events.FlexMouseEvent;
	import mx.managers.SystemManager;
	
	import spark.components.PopUpAnchor;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.TextOperationEvent;
	import spark.utils.LabelUtil;
	
	[Event (name="select", type="com.arun.billingsystem.event.AutoCompleteEvent")]		
	public class AutoComplete extends SkinnableComponent {
		
        public function AutoComplete() {
        	super();            
        	this.mouseEnabled = true;            
        }
                
        [Bindable]
        public var maxRows : Number = 6;
        
        public var minChars : Number = 1;                       
        
        public var requireSelection : Boolean = false;
        
        public var forceOpen : Boolean = true;
        
		public var defaultCode:String;
		
		public var defaultLabelField:String;
		
		public var design:String;
		
        public var enumClass : Class;
		        
        [SkinPart(required="true",type="spark.components.PopUpAnchor")]
		public var popUp : PopUpAnchor;
        
        [SkinPart(required="true",type="odyssey.common.component.HighlightItemList")]
        public var list : HighlightItemList;
        
        [SkinPart(required="true",type="spark.components.TextInput")]
        public var inputTxt : TextInput;
		
        [Bindable]
        public function set dataProvider(value:Object) : void {
            if (value is Array) {
        		_collection = new ArrayCollection(value as Array);
            }
        	else if (value is ArrayCollection) {
        		_collection = value as ArrayCollection;                
        	}
                            	
            _dataProviderChanged = true;
            invalidateProperties(); 
        }
		
        public function get dataProvider() : Object {
            return _collection; 
        }		                
		
        public function set labelField(field:String) : void {
			_labelField = field; 
			if (list) {
                list.labelField = field;   
            } 
		}
		
        public function get labelField() : String { 
            return _labelField;
        };
        
        public function set searchMode(searchMode : String) : void {            
            _searchMode = searchMode; 
            if (list) {
                list.searchMode = searchMode;   
            } 
        }
                
        public function get searchMode() : String { 
            return _searchMode;
        };
		
        public function set labelFunction(func:Function) : void {
        	_labelFunction = func; 
        	if (list) {
                list.labelFunction = func;   
            } 
        }
        
        public function get labelFunction() : Function	 { 
            return _labelFunction; 
        }                		       
        
        public function get selectedItem() : Object { 
            return _selectedItem; 
        }
        
        public function set selectedItem(item : Object) : void {
            _selectedItem = item;
            _previouslyEnteredText = enteredText = returnFunction(_selectedItem);
			
            _selectedItemChanged = true;
            invalidateProperties();
        }                
		
        // filter function         
        public function filterFunction(item : Object) : Boolean {
//        	var itemLabel : String = itemToLabel(item).toLowerCase();
        	// prefix search mode
        	if (searchMode == SearchModes.PREFIX_SEARCH) {
//                if (itemToPrice(item).toLowerCase().substr(0, enteredText.length) == enteredText.toLowerCase()) {
//					return true;
//				}
				return itemToSearch(item);
        	}
        	// infix search mode
        	else {
//        		if (itemToPrice(item).toLowerCase().search(enteredText.toLowerCase()) != -1) {
//                    return true;   
//                }
				return itemToSearch(item);
        	}
        }
		
		//Default filter function         
		public function defaultFilterFunction(item : Object) : Boolean {
			if (itemDefaultSearch(item).toLowerCase().search(defaultCode.toLowerCase()) != -1) {
				return true;
			}
			return false;
		}
		
		public function itemToSearch(item : Object) : Boolean {
			var isMatch:Boolean = false;
			var labelArr:Array = splitLabelField();
			if(labelArr != null){
				for(var i:int=0;i<labelArr.length;i++){
					var value:String = LabelUtil.itemToLabel(item, labelArr[i], labelFunction);
					if (value.toLowerCase() == enteredText.toLowerCase()) {
						isMatch = true;   
					}
				}
			}
			return isMatch;
		}
		
        public function itemDefaultSearch(item : Object) : String {
            return LabelUtil.itemToLabel(item, defaultLabelField, labelFunction);
        }
		
		public function splitLabelField():Array {
			var str:Array = new Array();
			var labelFieldStr:String = labelField;
			if(labelField.indexOf(',') > 0){
				str = labelField.split(",");
			} else {
				str[0] = labelFieldStr;
			}
			return str;
		}
        
        override public function set enabled(value:Boolean) : void {
            super.enabled = value;
            if (inputTxt) {
                inputTxt.enabled = value;   
            }
        }
        
        
        override public function setFocus() : void {            
            if (inputTxt) {
                inputTxt.setFocus();
            }
        }
        
        protected function set enteredText(t : String) : void {
			_enteredText = t;
            if (inputTxt) {
                inputTxt.text = t;
            }

            if (list) {
			    list.lookupValue = _enteredText;
            }
        }
        
        protected function get enteredText() : String {
            return _enteredText;
        }
        
        protected function acceptCompletion() : void {                        
            if (_collection.length > 0 && list.selectedIndex >= 0) {
                _completionAccepted = true;                
                selectedItem = _collection.getItemAt(list.selectedIndex);
                hidePopUp();
            }
            else {
				_completionAccepted = false;
				selectedItem = null;
				//todo: add default itemcode when collection is not found
				if(defaultCode != null && !isNaN(Number(valueText))){
					_collection.filterFunction = defaultFilterFunction;
					_collection.refresh();
					
					if(_collection.length > 0 && valueText.length > 0){
						_collection.getItemAt(0).soldPrice = Number(valueText);
						selectedItem = _collection.getItemAt(0);
					} else {
						selectedItem = null;
					}
				}
                restoreEnteredTextAndHidePopUp(!_completionAccepted);
            }
			valueText = "";
            var e:AutoCompleteEvent = new AutoCompleteEvent(AutoCompleteEvent.SELECT, _selectedItem);
            dispatchEvent(e);                         			
        }
        
        protected function filterData() : void {            
            _collection.filterFunction = filterFunction;                        	
            _collection.refresh();        	
                        
            if (_collection.length == 0) {                
                hidePopUp();
            } else if (!isDropDownOpen) {
                if (forceOpen || enteredText.length > 0) {
                    showPopUp();        
                }                
            }
        }
        
        override protected function partAdded(partName : String, instance : Object) : void {
            super.partAdded(partName, instance)
            
            if (instance == inputTxt) {
                inputTxt.text = _enteredText;
                inputTxt.restrict = "[0-9].";
                inputTxt.addEventListener(FocusEvent.FOCUS_OUT, onInputFieldFocusOut);
                inputTxt.addEventListener(FocusEvent.FOCUS_IN, onInputFieldFocusIn);
                inputTxt.addEventListener(TextOperationEvent.CHANGE, onInputFieldChange);
                inputTxt.addEventListener(KeyboardEvent.KEY_DOWN, onInputFieldKeyDown);
            }
            
            if (instance == list) {
                list.dataProvider = _collection;
//                list.labelField = "itemCode";//labelField;
                list.labelFunction = labelDisplay;//labelFunction;
                list.searchMode = searchMode;
                list.requireSelection = requireSelection;
                
                list.addEventListener(HighlightItemListEvent.ITEM_CLICK, onListItemClick);
            }                        
        }  
		
		
		protected function labelDisplay(item:Object):String {
			if(item == null){
				return "";
			}
			return item["category"] + " - " + item["itemCode"] +" - "+ item["soldPrice"];
//			return design;
		}
        
        override protected function commitProperties():void {            
            
            if (_dataProviderChanged) {                
                _dataProviderChanged = false;                
                list.dataProvider = _collection;                                 
            }
            
            if (_selectedItemChanged) {
                var selectedIndex : int = _collection.getItemIndex(selectedItem);                
                list.selectedIndex = _collection.getItemIndex(selectedItem);
                _selectedItemChanged = false;
            }
            
            // Should be last statement.
            // Don't move it up.
            super.commitProperties();                        
        }
        
        private function returnFunction(item : Object) : String {
            if (item == null) {
                return "";   
            }
			
            if (defaultLabelField) {
           		return item[defaultLabelField];
            } 
			return "";
        }                
        
        private function onInputFieldChange(event : TextOperationEvent = null) : void {
            _completionAccepted = false;
            enteredText = inputTxt.text;
			valueText = inputTxt.text;
            filterData();            
        }
        
        private function onInputFieldKeyDown(event: KeyboardEvent) : void {        	            
            switch (event.keyCode) {
                case Keyboard.UP:
                case Keyboard.DOWN:
                case Keyboard.END:
                case Keyboard.HOME:
                case Keyboard.PAGE_UP:
                case Keyboard.PAGE_DOWN: 
                    list.focusListUponKeyboardNavigation(event);                                     			
                    break;                   
                case Keyboard.ENTER:
					acceptCompletion();
//					_enteredText;
                    break;
                case Keyboard.TAB:
					acceptCompletion();
					break;
                case Keyboard.ESCAPE:
                    restoreEnteredTextAndHidePopUp(!_completionAccepted);
                    break;
            }            
        }
		
        private function showPopUp() : void {            
            popUp.displayPopUp = true;
            
            if (requireSelection) {
                list.selectedIndex = 0;
            }
            else {
                list.selectedIndex = -1;
            }
            
            list.dataGroup.verticalScrollPosition = 0;
            list.dataGroup.horizontalScrollPosition = 0;
            
            popUp.popUp.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, onMouseDownOutside);
        }
		
        private function restoreEnteredTextAndHidePopUp(restoreEnteredText : Boolean) : void {
//            if (restoreEnteredText) {
//                enteredText = _previouslyEnteredText;
//            }
            hidePopUp();
        }
        
        private function hidePopUp() : void {
            popUp.popUp.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, onMouseDownOutside);
            popUp.displayPopUp = false;            
        }
        
        private function get isDropDownOpen() : Boolean {
            return popUp.displayPopUp;
        }
                
        private function onInputFieldFocusIn(event : FocusEvent) : void {            
            if (forceOpen) {
            	filterData();
            }
            
            _previouslyEnteredText = enteredText;
        }
        
        private function onInputFieldFocusOut(event : FocusEvent) : void {
            restoreEnteredTextAndHidePopUp(!_completionAccepted);
        }		        				
                
        private function onListItemClick(event : HighlightItemListEvent) : void {                        
            acceptCompletion();            
            event.stopPropagation();
        }
        
        private function onMouseDownOutside(event:FlexMouseEvent) : void {            
            
            var mouseDownInsideComponent : Boolean = false;            
            var clickedObject : DisplayObjectContainer = event.relatedObject as DisplayObjectContainer;
                                   
            while (!(clickedObject.parent is SystemManager)) {                
                if (clickedObject == this) {
                    mouseDownInsideComponent = true;
                    break;
                }
                
                clickedObject = clickedObject.parent;
            }
                        
            if (!mouseDownInsideComponent) {                
                restoreEnteredTextAndHidePopUp(!_completionAccepted);
            }
        }
                    
                
        private var _collection : ArrayCollection = new ArrayCollection();
    
        private var _dataProviderChanged : Boolean;
        
        private var _completionAccepted : Boolean;
        
        private var _selectedItemChanged : Boolean;
        
        private var _enteredText : String = "";
		
		private static var valueText:String = "";
        
        private var _previouslyEnteredText : String = "";
        
        private var _labelField : String;
        
        private var _labelFunction : Function;
        
        private var _selectedItem : Object;
        
        private var _searchMode : String = SearchModes.INFIX_SEARCH;
    }
		
}