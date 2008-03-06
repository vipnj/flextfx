package net.sakri.text_lib{
	
	import flash.display.DisplayObject;
	import gs.TweenLite;
	
	public class SplitMoveZoomAndRotate extends SplitZoomAndRotate{
		
		public var x_from:Number=50;
		public var y_from:Number=-50;
		
		public function SplitMoveZoomAndRotate(){
			super();
		}
		
		override protected function tweenCharacter(char:DisplayObject,index:uint,tween_params:Object):void{
			tween_params.scaleX=scale_from;
			tween_params.scaleY=scale_from;
			tween_params.rotation=rotate_from;
			tween_params.x=x_from;
			tween_params.y=y_from;
			TweenLite.from(char,character_anim_duration,tween_params);
		}
		
	}
}