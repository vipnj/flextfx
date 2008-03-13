package be.nascom.graphics{
	
	import flash.events.Event;
	import mx.events.FlexEvent;

	public class FlexBitmapTracer extends AbstractFlexAnimationTracer{
		
		protected var _num_tracers:uint=5;
		
		public function FlexBitmapTracer(){
			super();
		}
		
		override protected function createChildren():void{
			_tracer=new BitmapTracer();
			addChild(_tracer);
		}
		
		override protected function init(e:Event=null):void{
			super.init();
			BitmapTracer(_tracer).num_tracers=_num_tracers;
		}

		public function set num_tracers(nt:uint):void{
			_num_tracers=nt;
			if(_tracer!=null)BitmapTracer(_tracer).num_tracers=nt;
		}
		public function get num_tracers():uint{return BitmapTracer(_tracer).num_tracers;}
		
		
	}
}