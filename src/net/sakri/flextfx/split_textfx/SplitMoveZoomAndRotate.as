package net.sakri.flextfx.split_textfx{
	
	import flash.display.DisplayObject;
	import gs.TweenLite;
	
	public class SplitMoveZoomAndRotate extends SplitZoomAndRotate{
		
		[Inspectable (enumeration="Fixed,Relative")]
		public var move_point:String="Fixed";
		
		public var x_from:Number=50;
		public var y_from:Number=-50;
		
		override protected function tweenCharacter(char:DisplayObject,index:uint,tween_params:Object):void{
			tween_params.scaleX=scale_from;
			tween_params.scaleY=scale_from;
			tween_params.rotation=rotate_from;
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