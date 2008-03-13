package be.nascom.flex.components{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import be.nascom.flash.graphics.AbstractAnimationTracer;

	public class AbstractFlexAnimationTracer extends UIComponent{

		protected var _tracer:AbstractAnimationTracer;
		protected var _target:DisplayObject;
		protected var _auto_update:Boolean=false;

		public function set target(t:DisplayObject):void{
			_target=t;
			if(_tracer!=null)_tracer.target=t;
		}
		public function get target():DisplayObject{
			return _target;
		}
		
		public function set auto_update(b:Boolean):void{
			_auto_update=b;
			if(_tracer!=null)_tracer.auto_update=b;
		}
		public function get auto_update():Boolean{
			return _auto_update;
		}
		
		public function AbstractFlexAnimationTracer(){
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE,init);
		}
		
		protected function init(e:Event=null):void{
			_tracer.target=_target;
			_tracer.auto_update=_auto_update;
		}
		
		public function update(e:Event=null):void{
			if(_tracer!=null)_tracer.update();
		}
		
	}
}