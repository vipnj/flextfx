/*
Copyright (c) 2007 FlexLib Contributors.  See:
    http://code.google.com/p/flexlib/wiki/ProjectContributors

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
package net.sakri.flextfx{
	
	import mx.containers.Canvas;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.effects.easing.*;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import net.sakri.IInOutTextEffect;
	
	/**
	 * Fired when the text effect animation starts (either "enter" or "exit" animation);
	 * @eventType flash.events.Event
	 */
	[Event(name="start",type="flash.events.Event")]
	
	/**
	 * Fired when the "enter" text effect animation starts
	 * @eventType flash.events.Event
	 */
	[Event(name="enter_effect",type="flash.events.Event")]
	
	/**
	 * Fired when the "exit" text effect animation starts
	 * @eventType flash.events.Event
	 */
	[Event(name="exit_effect",type="flash.events.Event")]
	
	/**
	 * Fired when the text effect animation pauses 
	 * @eventType flash.events.Event
	 */
	[Event(name="pause",type="flash.events.Event")]
	
	/**
	 * Fired when the text effect has run it's full course and ends (either "enter" or "exit" animation);
	 * @eventType flash.events.Event 
	 */
	[Event(name="end",type="flash.events.Event")]

	/**
	 * The AbstractTextEffect 
	 * 
	 * @author Sakri Rosenstrom
	 * @email sakri.rosenstrom@gmail.com
	 * extends canvas in order to take advantage of CSS
	 */

	public class AbstractEffectTextField extends Canvas implements IInOutTextEffect{
		
		
	    /**
	     *  Constructor.
	     */
		public function AbstractEffectTextField(){
			super();
	        verticalScrollPolicy="off";
	        horizontalScrollPolicy="off";
	        clipContent=false;
		}
		
		/**
		 * @private
		 */
		protected var _text_changed:Boolean=false;
		
		/**
		 * @private
		 */
		protected var _text:String;
		public function get text():String{
			return _text;
		}
		/**
		 * @private
		 */
		public function set text(s:String):void{
			_text=s;
			_text_changed=true;
			invalidateProperties();
		}
			
		protected var _easing_function:Class;
		protected var _easing_function_name:String="";
		protected var _easing_function_names:Array=new Array("Linear","Bounce","Circular","Cubic","Elastic","Exponential","Quadratic","Quartic","Quintic","Sine");
		protected var _easing_functions:Array=new Array(	mx.effects.easing.Linear,
														mx.effects.easing.Bounce,
														mx.effects.easing.Circular,
														mx.effects.easing.Cubic,
														mx.effects.easing.Elastic,
														mx.effects.easing.Exponential,
														mx.effects.easing.Quadratic,
														mx.effects.easing.Quartic,
														mx.effects.easing.Quintic,
														mx.effects.easing.Sine
														);

		[Inspectable (enumeration="Linear,Bounce,Circular,Cubic,Elastic,Exponential,Quadratic,Quartic,Quintic,Sine")]
		public function set easing_function(ef:String):void{
			for(var i:uint=0;i<_easing_function_names.length;i++){
				if(_easing_function_names[i]==ef){
					_easing_function_name=ef;
					_easing_function=_easing_functions[i];
				}
			}
		}
		public function get easing_function():String{
			return _easing_function_name;
		}
		
		protected var _easing_style:String="easeIn";
		[Inspectable (enumeration="easeNone,easeIn,easeOut,easeInOut")]
		public function set easing_style(es:String):void{
			_easing_style=es;
		}
		public function get easing_style():String{
			return _easing_style;
		}
		
		protected function getEasingFunction():Function{
			if(_easing_function[_easing_style]==null){
				throw new Error(easing_function+"."+_easing_style+" not found in Flex, please use a different easing function ");
				return Linear.easeNone;
			}else{
				return _easing_function[_easing_style];
			}
		}
		
		
		protected var _default_text:UITextField;
		
		
		
		
		
		
		
		override protected function createChildren():void{
			super.createChildren();
			trace("AbstractFlexTextEffect.createChildren()");
			_default_text=new UITextField();
			_default_text.autoSize=TextFieldAutoSize.LEFT;
			addChild(_default_text);
		}
		override protected function commitProperties():void{
			super.commitProperties();
			if(_text_changed){
				_default_text.text=_text;
				_text_changed=false;
				trace("AbstractFlexTextEffect.commitProperties(), text changed:"+_default_text.text);
				invalidateDisplayList();
			}
		}
		
		override public function set filters(value:Array):void{
			_default_text.filters=value;
		}
		override public function get filters():Array{
			return _default_text.filters;
		}
		

		
		//subclasses must override 
		public function enter():void{
		}
		
		public function exit():void{
		}
		
		public function stop():void{
		}
		
		public function playTextEffect(times:int=-1):void{
		}
		
		public function set auto_play(b:Boolean):void{
		}
		
		public function get auto_play():Boolean{
			return false;
		}
		
		public function set auto_play_interval(interval:Number):void{
		}
		
		public function get auto_play_interval():Number{
			return 0;
		}
		
	}
}