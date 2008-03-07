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
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;

	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.effects.easing.*;
	import mx.core.UITextField;

	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import be.nascom.component.FlexSimpleTraceBox2;
	
	import net.sakri.flextfx.util.DisplayObjectRegistrationPointHelper;
	import be.nascom.component.FlexSimpleTraceBox2;
	import gs.TweenLite;
	
	/**
	 * Fired when the text effect animation starts
	 * @eventType flash.events.Event
	 */
	[Event(name="start",type="flash.events.Event")]
	
	/**
	 * Fired when the text effect animation pauses 
	 * @eventType flash.events.Event
	 */
	[Event(name="pause",type="flash.events.Event")]
	
	/**
	 * Fired when the text effect has run it's full course and ends
	 * @eventType flash.events.Event 
	 */
	[Event(name="end",type="flash.events.Event")]

	/**
	 * The SplitFlexTextEffect splits a string of text into individually animated characters.
	 * SplitFlexTextEffect accepts both embedded and non-embedded fonts. This component
	 * detects wether a font is embedded or not automagically.  Non embedded fonts
	 * are rendered as bitmaps, which has the side effect of appearing "pixelated"
	 * whenever x or y scale is greater than 1.
	 * 
	 * @author Sakri Rosenstrom
	 * @email sakri.rosenstrom@gmail.com
	 * 	 
	 */
	 
	public class SplitFlexTextEffect extends Canvas{

	    /**
	     *  Constructor.
	     */
	    public function SplitFlexTextEffect(){
	        super();
	        verticalScrollPolicy="off";
	        horizontalScrollPolicy="off";
	        clipContent=false;
	    }
       
		/**
		 * @private
		 */
		private var _text_changed:Boolean=false;
		
		/**
		 * @private
		 */
		private var _text:String;
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
		private var _easing_function_names:Array=new Array("Linear","Bounce","Circular","Cubic","Elastic","Exponential","Quadratic","Quartic","Quintic","Sine");
		private var _easing_functions:Array=new Array(	mx.effects.easing.Linear,
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
		
		private var split_clip_registration:DisplayObjectRegistrationPointHelper=new DisplayObjectRegistrationPointHelper();
		
		[Inspectable (enumeration="left,center,right")]
		public function set horizontal_registration(s:String):void{
			split_clip_registration.horizontal_registration=s;
		}
		public function get horizontal_registration():String{
			return split_clip_registration.horizontal_registration;
		}

		[Inspectable (enumeration="top,center,bottom")]
		public function set vertical_registration(s:String):void{
			split_clip_registration.vertical_registration=s;
		}
		public function get vertical_registration():String{
			return split_clip_registration.vertical_registration;
		}
		
		protected var _default_text:UITextField;
		protected var _capture_field:UITextField;
		protected var _characters_holder:UIComponent;//can't add movieclips to Canvas...
		protected var _characters:Array;
			
		/**
		 * Duration of individual characters 
		 * @default 1
		 */
		public var character_anim_duration:Number=1;
		/**
		 * Delay between the start of animation for individual characters 
		 * @default .5
		 */		
		public var character_anim_delay:Number=.5;
		
		override protected function createChildren():void{
			super.createChildren();
			FlexSimpleTraceBox2.trace("SplitFlexTextEffect.createChildren()");
			_default_text=new UITextField();
			_default_text.autoSize=TextFieldAutoSize.LEFT;
			addChild(_default_text);
			_capture_field=new UITextField();
			addChild(_capture_field);
			_characters_holder=new UIComponent();
			addChild(_characters_holder);
			_characters_holder.visible=false;
		}
		override protected function commitProperties():void{
			super.commitProperties();
			if(_text_changed){
				_default_text.text=_text;
				_text_changed=false;
				FlexSimpleTraceBox2.trace("SplitFlexTextEffect.commitProperties(), text changed:"+_default_text.text);
				createSplitCharacters();
				invalidateDisplayList();
			}
		}
		
		override public function set filters(value:Array):void{
			_default_text.filters=value;
			_capture_field.filters=value;
		}
		override public function get filters():Array{
			return _default_text.filters;
		}
		
		protected function tweenCharacter(char:DisplayObject,index:uint,tween_params:Object):void{
			TweenLite.from(char,character_anim_duration,tween_params);
		}
		
		public function start():void{
			FlexSimpleTraceBox2.trace("SplitFlexTextEffect.start()");
			_default_text.visible=false;
			_characters_holder.visible=true;
			var tween_params:Object;
			for(var i:uint=0;i<_characters.length;i++){
				tween_params={ease:getEasingFunction(),autoAlpha:0,delay:i*character_anim_delay};
				if(i==_characters.length-1)tween_params.onComplete=end;
				tweenCharacter(DisplayObject(_characters[i]),i,tween_params);//IMPLEMENT BY SUBCLASSES
			}
			dispatchEvent(new Event("start"));
		}
		public function pause():void{
			for(var i:uint=0;i<_characters.length;i++){
				TweenLite.killTweensOf(_characters[i]);
			}
			dispatchEvent(new Event("pause"));
		}
		//skips to end and stops animation
		public function end():void{
			pause();
			_default_text.visible=true;
			_characters_holder.visible=false;
			FlexSimpleTraceBox2.trace("SplitFlexTextEffect.end()");
			dispatchEvent(new Event("end"));
		}
		
		/**
		 * Checks wether this.getStyle("fontFamily") (ie. fontface set in mxml tag attributes of 
		 * current instance) is embedded.  Embedded fonts will be rendered as TextFields 
		 * as they are vectors and will render at any size.  Non Embedded fonts will be rendered
		 * as bitmaps. The reason for this is that non-embedded fonts do not support all features af animation
		 * such as rotation, alpha etc.  The obvious drawback is that the bitmaps will look like crap 
		 * if scaled bigger than 1.
		 */
		protected function createSplitCharacters():void{
			_characters=new Array();
			if(Application.application.systemManager.isFontFaceEmbedded(_default_text.getTextFormat())){
				createEmbeddedSplitCharacters();
			}else{
				createBitmapSplitCharacters();
			}
		}


		protected function createEmbeddedSplitCharacters():void{
			FlexSimpleTraceBox2.trace("SplitFlextTextEffect.createEmbeddedSplitCharacters()");
			//FlexSimpleTraceBox.trace("SplitFlextTextEffect.createSplitCharacters()split_clip_registration:"+split_clip_registration.toString());
			var char_bounds:Rectangle;
			var character:TextField;
			var tf:TextFormat=_default_text.getTextFormat();
			var extension_hack:Number=_default_text.height*.1;//using getCharBoundaries().width doesn't capture dropshadows etc.
			var x_offset:Number=_default_text.getCharBoundaries(0).x;
			var character_holder:Sprite;
			for(var i:uint=0;i<_default_text.text.length;i++){
				if(_default_text.text.charAt(i)==" ")continue;
				character=new TextField();
				char_bounds=_default_text.getCharBoundaries(i);
				character.width=char_bounds.width+extension_hack;
				character.height=char_bounds.height;
				character.text=_default_text.text.charAt(i);
				character.embedFonts=true;
				character.setTextFormat(tf);
				character.filters=_default_text.filters;
				character_holder=split_clip_registration.nestDisplayObjectToSprite(character,char_bounds.width+extension_hack,char_bounds.height);
				character_holder.x+=char_bounds.x-x_offset;
				_characters.push(character_holder);
				_characters_holder.addChild(character_holder);
			}
		}
		
		protected function createBitmapSplitCharacters():void{
			FlexSimpleTraceBox2.trace("SplitFlextTextEffect.createSplitCharacters()");
			//FlexSimpleTraceBox.trace("SplitFlextTextEffect.createSplitCharacters()split_clip_registration:"+split_clip_registration.toString());
			var char_bounds:Rectangle;
			var character:Bitmap;
			var bmd:BitmapData;
			var m:Matrix;
			var extension_hack:Number=_default_text.height*.1;//using getCharBoundaries().width doesn't capture dropshadows etc.
			var x_offset:Number=_default_text.getCharBoundaries(0).x;
			var character_holder:Sprite;
			for(var i:uint=0;i<_default_text.text.length;i++){
				if(_default_text.text.charAt(i)==" ")continue;
				_capture_field.text=_default_text.text.charAt(i);
				
				char_bounds=_default_text.getCharBoundaries(i);
				bmd=new BitmapData(char_bounds.width+extension_hack,char_bounds.height,true,0);
				bmd.draw(_capture_field,null,null,null,null,true);
				character=new Bitmap(bmd,"auto",true);

				character_holder=split_clip_registration.nestDisplayObjectToSprite(character,char_bounds.width+extension_hack,char_bounds.height);
				character_holder.x+=char_bounds.x-x_offset;
				_characters.push(character_holder);
				_characters_holder.addChild(character_holder);
			}
			_capture_field.text="";
		}
		
	}
}