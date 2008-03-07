package net.sakri.flextfx{
	
	import flash.display.DisplayObject;
	
	import gs.TweenLite;

	public class SplitMove extends SplitFlexTextEffect{
		
		public function SplitMove(){
			super();
		}
		
		[Inspectable (enumeration="Fixed,Relative")]
		public var move_point:String="Fixed";
		
		public var x_from:Number=50;
		public var y_from:Number=-50;
		
		
		/**
		* Typical sets tween parameters particular to this effect
		*
		* @param param1 Individual character, either a textfield (for embedded fonts), or a bitmap for non-embedded fonts.
		 * Note that unless character creation scripts are overridden, both flavours are nested inside sprites 
		 * (see <code>net.sakri.flextfx.util.DisplayObjectRegistrationPointHelper<code>)
		* @param param2 The charAt index of the passed character
		* @param param3 template parameters, common parameters passed to all subclasses of <code>SplitFlexTextEffect.</code>
		 * To customize functionality, override character creation scripts.
		*
		*/
		override protected function tweenCharacter(char:DisplayObject,index:uint,tween_params:Object):void{
			if(move_point=="Fixed"){
				tween_params.x=x_from;
				tween_params.y=y_from;			
			}else{
				tween_params.x=char.x+x_from;
				tween_params.y=char.y+y_from;
			}
			TweenLite.from(char,character_anim_duration,tween_params);
		}
		
	}
}