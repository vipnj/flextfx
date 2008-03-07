package net.sakri.flextfx{
	
	import flash.display.DisplayObject;
	
	public class SplitZoom extends SplitFlexTextEffect{
		
		import gs.TweenLite;
		
		public var scale_from:Number=.1;

		override protected function tweenCharacter(char:DisplayObject,index:uint,tween_params:Object):void{
			tween_params.scaleX=scale_from;
			tween_params.scaleY=scale_from;
			tween_params.x=char.x+char.width/2;
			tween_params.y=char.y+char.height/2;
			TweenLite.from(char,character_anim_duration,tween_params);
		}
		
	}
}