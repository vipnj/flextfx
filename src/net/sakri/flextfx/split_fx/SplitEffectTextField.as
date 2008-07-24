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

package net.sakri.flextfx.split_fx{
	
	import be.nascom.flex.components.FlexSimpleTraceBox;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import gs.TweenLite;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.effects.easing.*;
	
	import net.sakri.flextfx.AbstractEffectTextField;
	import net.sakri.flextfx.split_fx.util.DisplayObjectRegistrationPointHelper;
	
	/**
	 * The SplitFlexTextEffect has the same api as the AbstractFlexText Effect.
	 * SplitFlexTextEffect splits a string of text into individually animated characters.
	 * SplitFlexTextEffect accepts both embedded and non-embedded fonts. This component
	 * detects wether a font is embedded or not automagically.  Non embedded fonts
	 * are rendered as bitmaps, which has the side effect of appearing "pixelated"
	 * whenever x or y scale is greater than 1.
	 * 
	 * @author Sakri Rosenstrom
	 * @email sakri.rosenstrom@gmail.com
	 * 	 
	 */
	 
	public class SplitEffectTextField extends AbstractEffectTextField{

	    /**
	     *  Constructor.
	     */
	    public function SplitEffectTextField(){
	        super();
	    }
       		
       	//WHY IS THIS NOT IN AbstractxEffectTextField?!
       		
		protected var split_clip_registration:DisplayObjectRegistrationPointHelper=new DisplayObjectRegistrationPointHelper();
		
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
		
		protected var _capture_field:UITextField;
		protected var _characters_holder:UIComponent;//can't add movieclips to Canvas...
		protected var _characters:Array;
			
		/**
		 * Duration of individual characters 
		 * @default 1
		 */
		public var character_anim_duration:Number=1;//getter setter?!
		/**
		 * Delay between the start of animation for individual characters 
		 * @default .5
		 */		
		public var character_anim_delay:Number=.5;//getter setter?!
		
		override protected function createChildren():void{
			super.createChildren();
			FlexSimpleTraceBox.trace("SplitFlexTextEffect.createChildren()");
			_capture_field=new UITextField();
			addChild(_capture_field);
			_characters_holder=new UIComponent();
			addChild(_characters_holder);
			_characters_holder.visible=false;
		}
		override protected function commitProperties():void{
			var local_text_changed:Boolean=_text_changed;
			super.commitProperties();
			if(local_text_changed){
				FlexSimpleTraceBox.trace("SplitFlexTextEffect.commitProperties(), Text changed:"+_default_text.text);
				createSplitCharacters();
			}
		}
		
		override public function set filters(value:Array):void{
			super.filters=value;
			_capture_field.filters=value;
		}
		
		protected function tweenCharacter(char:DisplayObject,index:uint,tween_params:Object):void{
			TweenLite.from(char,character_anim_duration,tween_params);
		}
		
		public function start():void{
			FlexSimpleTraceBox.trace("SplitFlexTextEffect.start()");
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
			FlexSimpleTraceBox.trace("SplitFlexTextEffect.end()");
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
			FlexSimpleTraceBox.trace("SplitFlextTextEffect.createSplitCharacters()");
			_characters=new Array();
			if(Application.application.systemManager.isFontFaceEmbedded(_default_text.getTextFormat())){
				createEmbeddedSplitCharacters();
			}else{
				createBitmapSplitCharacters();
			}
		}

		override protected function updateDisplayList(unscaled_width:Number, unscaled_height:Number):void{
			FlexSimpleTraceBox.trace("SplitFlextTextEffect.updateDisplayList()");
			_characters_holder.x=_default_text.x=unscaled_width/2-_default_text.width/2;
			_characters_holder.y=_default_text.y=unscaled_height/2-_default_text.height/2;	
		}

		protected function createEmbeddedSplitCharacters():void{
			FlexSimpleTraceBox.trace("SplitFlextTextEffect.createEmbeddedSplitCharacters()");
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
			FlexSimpleTraceBox.trace("SplitFlextTextEffect.createSplitCharacters()");
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