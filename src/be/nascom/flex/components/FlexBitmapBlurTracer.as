package be.nascom.flex.components{
	
	import flash.events.Event;
	import mx.events.FlexEvent;

	import be.nascom.flash.graphics.AbstractAnimationTracer;
	import be.nascom.flash.graphics.BitmapBlurTracer;

	public class FlexBitmapBlurTracer extends AbstractFlexAnimationTracer{
		
		protected var _blur_x:Number=5;
		public function set blur_x(b:Number):void{
			_blur_x=b;
			if(this._tracer!=null)BitmapBlurTracer(_tracer).blur_x=_blur_x;
		}
		public function get blur_x():Number{
			return _blur_x;
		}
		
		protected var _blur_y:Number=5;
		public function set blur_y(b:Number):void{
			_blur_y=b;
			if(this._tracer!=null)BitmapBlurTracer(_tracer).blur_y=_blur_y;
		}
		public function get blur_y():Number{
			return _blur_y;
		}
			
		protected var _end_delay:uint=50;//amount of frames rendered before tracing stops
		public function set end_delay(e:Number):void{
			_end_delay=e;
			if(this._tracer!=null)BitmapBlurTracer(_tracer).end_delay=_end_delay;
		}
		public function get end_delayblur_y():Number{
			return _end_delay;
		}	
		
		public function FlexBitmapBlurTracer(){
			super();
		}
		
		override protected function createChildren():void{
			_tracer=new BitmapBlurTracer();
			addChild(_tracer);
		}
		
		override protected function init(e:Event=null):void{
			super.init();
			BitmapBlurTracer(_tracer).blur_x=_blur_x;
			BitmapBlurTracer(_tracer).blur_y=_blur_y;
			BitmapBlurTracer(_tracer).end_delay=_end_delay;
		}

		
		
	}
}