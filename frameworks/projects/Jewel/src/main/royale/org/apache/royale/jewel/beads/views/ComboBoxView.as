////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.royale.jewel.beads.views
{
	COMPILE::SWF
	{
		import flash.utils.setTimeout;
    }
	import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.StyledUIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.jewel.TextInput;
	import org.apache.royale.jewel.Button;
	import org.apache.royale.jewel.List;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.Event;
	import org.apache.royale.core.IComboBoxModel;
	import org.apache.royale.utils.UIUtils;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.geom.Point;
	import org.apache.royale.jewel.beads.controls.combobox.IComboBoxView;
	import org.apache.royale.jewel.supportClasses.util.getLabelFromData;
	import org.apache.royale.jewel.supportClasses.combobox.ComboBoxList;
	import org.apache.royale.jewel.supportClasses.ResponsiveSizes;
	
	/**
	 *  The ComboBoxView class creates the visual elements of the org.apache.royale.jewel.ComboBox 
	 *  component. The job of the view bead is to put together the parts of the ComboBox such as the TextInput
	 *  control and org.apache.royale.jewel.Button to trigger the pop-up.
	 *  
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class ComboBoxView extends BeadViewBase implements IComboBoxView
	{
		public function ComboBoxView()
		{
			super();
		}
		
		private var _textinput:TextInput;
		/**
		 *  The TextInput component of the ComboBox.
		 * 
		 *  @copy org.apache.royale.html.beads.IComboBoxView#text
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get textinput():Object
		{
			return _textinput;
		}
		
		private var _button:Button;
		/**
		 *  The Button component of the ComboBox.
		 * 
		 *  @copy org.apache.royale.html.beads.IComboBoxView#text
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get button():Object
		{
			return _button;
		}
		
		private var _combolist:ComboBoxList;
		private var _list:List;
		
		/**
		 *  The pop-up list component of the ComboBox.
		 * 
		 *  @copy org.apache.royale.html.beads.IComboBoxView#text
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get popup():Object
		{
			return _combolist;
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 * @royaleignorecoercion org.apache.royale.core.StyledUIBase
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			var host:StyledUIBase = _strand as StyledUIBase;

			_textinput = new TextInput();
			
			_button = new Button();
			_button.text = '\u25BC';
			
			_button.width = 39;

			if(host.width == 0 || host.width < 89)
			{
				var w:Number = host.width == 0 ? 200 : 89;
				_textinput.width = w - _button.width;
				host.width = _textinput.width + _button.width;
			} else
			{
				_textinput.width = host.width - _button.width;
			}

			
			host.addElement(_textinput);
			host.addElement(_button);
			//host.width = _textinput.width + _button.width;
			
			var model:IComboBoxModel = _strand.getBeadByType(IComboBoxModel) as IComboBoxModel;
			model.addEventListener("selectedIndexChanged", handleItemChange);
			model.addEventListener("selectedItemChanged", handleItemChange);
			
			IEventDispatcher(_strand).addEventListener("sizeChanged", handleSizeChange);
			
			// set initial value and positions using default sizes
			itemChangeAction();
			sizeChangeAction();
		}
		
		/**
		 *  Returns whether or not the pop-up is visible.
		 * 
		 *  @copy org.apache.royale.html.beads.IComboBoxView#text
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get popUpVisible():Boolean
		{
			return _combolist == null ? false : true;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IComboBoxModel
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		public function set popUpVisible(value:Boolean):void
		{
			if (value) {
				var popUpClass:Class = ValuesManager.valuesImpl.getValue(_strand, "iPopUp") as Class;
				_combolist = new popUpClass() as ComboBoxList;
				
				var model:IComboBoxModel = _strand.getBeadByType(IComboBoxModel) as IComboBoxModel;
				_combolist.model = model;
				_combolist.list.model = _combolist.model;

				var popupHost:IPopUpHost = UIUtils.findPopUpHost(_strand as IUIBase);
				popupHost.popUpParent.addElement(_combolist);
				
				// popup is ComboBoxList that fills 100% of browser window-> We want the internal List inside to adjust height
				_list = _combolist.list;
				
				setTimeout(prepareForPopUp,  300);

				COMPILE::JS
				{
				window.addEventListener('resize', autoResizeHandler, false);
				}

				autoResizeHandler();
			}
			else if(_combolist != null) {
				UIUtils.removePopUp(_combolist);
				COMPILE::JS
				{
				document.body.classList.remove("viewport");
				window.removeEventListener('resize', autoResizeHandler, false);
				}
				_combolist = null;
			}
		}

		private function prepareForPopUp():void
        {
			COMPILE::JS
			{
				_combolist.element.classList.add("open");
				//avoid scroll in html
				document.body.classList.add("viewport");
			}
		}

		/**
		 * @private
		 */
		protected function handleSizeChange(event:Event):void
		{
			sizeChangeAction();
		}
		
		/**
		 * @private
		 */
		protected function handleItemChange(event:Event):void
		{
			itemChangeAction();

			IEventDispatcher(_strand).dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.IComboBoxModel
		 */
		protected function itemChangeAction():void
		{
			var model:IComboBoxModel = _strand.getBeadByType(IComboBoxModel) as IComboBoxModel;
			_textinput.text = getLabelFromData(model, model.selectedItem);
		}
		
		/**
		 * reposition list dataGroup in desktop and widescreen screens
		 * 
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.StyledUIBase
		 */
		protected function sizeChangeAction():void
		{
			// var host:StyledUIBase = _strand as StyledUIBase;

			// _textinput.width = host.width - _button.width;
			// host.width = _textinput.width + _button.width;
			
			// textinput.width = host.width - button.width;
			// host.width = textinput.width + button.width;

			// dispatchEvent(new Event("layoutNeeded"));

			// input.x = 0;
			// input.y = 0;
			// if (host.isWidthSizedToContent()) {
			// 	input.width = 100;
			// } else {
			// 	input.width = host.width - 20;
			// }
			
			// button.x = input.width;
			// button.y = 0;
			// button.width = 20;
			// button.height = input.height;
			
			// COMPILE::JS {
			// 	input.element.style.position = "absolute";
			// 	button.element.style.position = "absolute";
			// }
				
			// if (host.isHeightSizedToContent()) {
			// 	host.height = input.height;
			// }
			// if (host.isWidthSizedToContent()) {
			// 	host.width = input.width + button.width;
			// }
		}

		private var comboList:ComboBoxList;
		/**
		 *  When set to "auto" this resize handler monitors the width of the app window
		 *  and switch between fixed and float modes.
		 * 
		 *  Note:This could be done with media queries, but since it handles open/close
		 *  maybe this is the right way
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		private function autoResizeHandler(event:Event = null):void
        {
			COMPILE::JS
			{
				var outerWidth:Number = window.outerWidth;
				var top:Number = (window.pageYOffset || document.documentElement.scrollTop)  - (document.documentElement.clientTop || 0);
				
				// Desktop width size
				if(outerWidth > ResponsiveSizes.DESKTOP_BREAKPOINT)
				{
					var origin:Point = new Point(0, button.y + button.height - top);
					var relocated:Point = PointUtils.localToGlobal(origin,_strand);
					// comboList.x = relocated.x;
					// comboList.y = relocated.y;
					_list.positioner.style["left"] = relocated.x + "px";
					_list.positioner.style["top"] = relocated.y + "px";
					_list.width = _textinput.width + _button.width;
				}
				else
				{
					_list.positioner.style["left"] = "50%";
					_list.positioner.style["top"] = "calc(100% - 10px)";
					// _list.positioner.style["width"] = "initial"; 
				}
			}
		}
	}
}