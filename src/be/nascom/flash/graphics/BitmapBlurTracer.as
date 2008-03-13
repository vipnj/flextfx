package be.nascom.flash.graphics{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import be.nascom.component.FlexSimpleTraceBox;
	
	public class BitmapBlurTracer extends AbstractAnimationTracer{
		
		protected var _blur_x:Number=5;
		public function set blur_x(b:Number):void{
			_blur_x=b;
		}
		public function get blur_x():Number{
			return _blur_x;
		}
		
		protected var _blur_y:Number=5;
		public function set blur_y(b:Number):void{
			_blur_y=b;
		}
		public function get blur_y():Number{
			return _blur_y;
		}
			

		protected var _end_delay:uint=30;//amount of frames rendered before tracing stops
		public function set end_delay(e:Number):void{
			_end_delay=e;
		}
		public function get end_delayblur_y():Number{
			return _end_delay;
		}		
		
		protected var _fade_rate:int=-10;
		public function set fade_rate(fr:int):void{
			if(fr>-255 && fr<0)_fade_rate=fr;
		}
		public function get fade_rate():int{
			return _fade_rate;
		}
			
		public function BitmapBlurTracer(){
			super();
		}
		
		protected var _stopping_auto_update:Boolean=false;
		protected var _is_auto_updating:Boolean=false;
		protected var _tracer_bm:Bitmap;
		protected var _exit_count:uint=0;
		override public function startAutoUpdate():void{
			//FlexSimpleTraceBox.trace("BitmapBlurTracer.startAutoUpdate()");
			if(_tracer_bm==null){
				var bmd:BitmapData=new BitmapData(_target.width,_target.height,true,0);
				_tracer_bm=new Bitmap(bmd);
				addChild(_tracer_bm);
			}
			_tracer_bm.alpha=1;
			if(!_is_auto_updating){
				addEventListener(Event.ENTER_FRAME,update);
				_is_auto_updating=true;
			}
			_stopping_auto_update=false;
		}
		override public function stopAutoUpdate():void{
			FlexSimpleTraceBox.trace("BitmapBlurTracer.stopAutoUpdate()");
			//removeEventListener(Event.ENTER_FRAME,update);
			_exit_count=0;
			_stopping_auto_update=true;
		}
		
		override protected function render():void{
			var temp_bmd:BitmapData=new BitmapData(_target.width,_target.height,true,0);
			var ct:ColorTransform=new ColorTransform();
			ct.alphaOffset=_fade_rate;
			temp_bmd.draw(_tracer_bm,null,ct);
			if(!_stopping_auto_update)temp_bmd.draw(_target);//no smoothing, as the bitmaps are all transparent anyway...
			temp_bmd.applyFilter(temp_bmd,new Rectangle(0,0,_target.width,_target.height),new Point(0,0),new BlurFilter(this.blur_x,this.blur_y));
			_tracer_bm.bitmapData=temp_bmd;
			if(_stopping_auto_update)renderExiting();
		}

		protected function renderExiting():void{
			if(++_exit_count>=_end_delay){
				_stopping_auto_update=false;
				_auto_update=false;
				_is_auto_updating=false;
				_exit_count=0;
				_tracer_bm.bitmapData=new BitmapData(_target.width,_target.height,true,0);
				removeEventListener(Event.ENTER_FRAME,update);
				FlexSimpleTraceBox.trace("BitmapBlurTracer.renderExiting() SEQUENCE FINISHED");
			}
		}
	}

}