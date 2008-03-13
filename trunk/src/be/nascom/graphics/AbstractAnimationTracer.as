package be.nascom.graphics{
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import be.nascom.component.FlexSimpleTraceBox;
	
	public class AbstractAnimationTracer extends Sprite{
		
		protected var _target:DisplayObject;
		public function set target(t:DisplayObject):void{
			_target=t;
		}
		public function get target():DisplayObject{
			return _target;
		}
		
		protected var _auto_update:Boolean=false;
		public function set auto_update(b:Boolean):void{
			FlexSimpleTraceBox.trace("AbstractAnimationTracer.auto_update : "+b);
			_auto_update=b;
			if(_auto_update){
				startAutoUpdate();
			}else{
				stopAutoUpdate();
			}
		}
		public function get auto_update():Boolean{
			return _auto_update;
		}	
		
		public function AbstractAnimationTracer(target:DisplayObject=null){
			super();
		}
		
		public function update(e:Event=null):void{
			if(_target!=null)render();
		}
		public function startAutoUpdate():void{
			addEventListener(Event.ENTER_FRAME,update);
		}
		public function stopAutoUpdate():void{
			removeEventListener(Event.ENTER_FRAME,update);
		}
		
		protected function render():void{
			//throw error?!
		}

	}
}