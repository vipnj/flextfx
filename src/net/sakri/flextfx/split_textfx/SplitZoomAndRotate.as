package net.sakri.flextfx.split_textfx{
	
	import flash.display.DisplayObject;
	import gs.TweenLite;
	import net.sakri.flextfx.util.DisplayObjectRegistrationPointHelper;

	public class SplitZoomAndRotate extends SplitZoom{
		
		public var rotate_from:Number=180;
		
		public function SplitZoomAndRotate(){
			vertical_registration=DisplayObjectRegistrationPointHelper.CENTER;
			horizontal_registration=DisplayObjectRegistrationPointHelper.CENTER;
		}
				
		override protected function tweenCharacter(char:DisplayObject,index:uint,tween_params:Object):void{
			tween_params.scaleX=scale_from;
			tween_params.scaleY=scale_from;
			tween_params.rotation=rotate_from;
			TweenLite.from(char,character_anim_duration,tween_params);
		}
		
		
	}
}