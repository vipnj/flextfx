package net.sakri.flextfx{
	
	import mx.containers.Canvas;
	import net.sakri.IInOutTextEffect;

	public class TextEffect extends Canvas implements IInOutTextEffect{
		
		public function TextEffect(){
			super();
		}
		
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