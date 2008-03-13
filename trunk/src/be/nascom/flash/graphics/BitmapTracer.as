package be.nascom.flash.graphics{
	import be.nascom.component.FlexSimpleTraceBox;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class BitmapTracer extends AbstractAnimationTracer{
		
		protected var _alpha_increment:Number=1/5;
		protected var _num_tracers:uint=5;
		public function set num_tracers(nt:uint):void{
			if(nt==_num_tracers)return;
			if(nt<_num_tracers){
				for(var i:uint=0;i<_num_tracers-nt;i++){
					if(numChildren)removeChildAt(0);
				}
			}
			_num_tracers=nt;
			_alpha_increment=1/_num_tracers;
		}
		public function get num_tracers():uint{return _num_tracers;}
		
		public function BitmapTracer(){
			super();
		}
		
		protected var _stopping_auto_update:Boolean=false;
		protected var _is_auto_updating:Boolean=false;
		override public function startAutoUpdate():void{
			if(!_is_auto_updating){
				addEventListener(Event.ENTER_FRAME,update);
				_is_auto_updating=true;
			}
			_stopping_auto_update=false;
		}
		override public function stopAutoUpdate():void{
			//removeEventListener(Event.ENTER_FRAME,update);
			_stopping_auto_update=true;
		}
		
		override protected function render():void{
			if(_stopping_auto_update){
				renderExiting();
				return;
			}
			if(this.numChildren>_num_tracers)removeChildAt(0);
			var bmd:BitmapData=new BitmapData(_target.width,_target.height,true,0);
			bmd.draw(_target);//no smoothing, as the bitmaps are all transparent anyway...
			var bm:Bitmap=new Bitmap(bmd);
			addChild(bm);
			for(var i:uint=0;i<numChildren;i++){
				this.getChildAt(i).alpha=i*_alpha_increment;
			}
		}
		
		protected function renderExiting():void{
			if(!numChildren){
				_stopping_auto_update=false;
				_auto_update=false;
				_is_auto_updating=false;
				removeEventListener(Event.ENTER_FRAME,update);
				return;
			}
			removeChildAt(0);
		}
		
	}
}