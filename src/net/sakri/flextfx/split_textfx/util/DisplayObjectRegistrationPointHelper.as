package net.sakri.flextfx.split_textfx.util{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class DisplayObjectRegistrationPointHelper{
		
		public static const LEFT:String="left";
		public static const CENTER:String="center";
		public static const RIGHT:String="right";
		
		public static const TOP:String="top";
		public static const BOTTOM:String="top";
		
		public static const CUSTOM:String="custom";

		private var _vertical_registration:String=TOP;
		public function set vertical_registration(s:String):void{
			if(s==TOP || s==CENTER || s==BOTTOM || s==CUSTOM){
				_vertical_registration=s;
			}else{
				_vertical_registration=TOP;
			}
		}
		public function get vertical_registration():String{return _vertical_registration;}
		
		private var _horizontal_registration:String=LEFT;
		public function set horizontal_registration(s:String):void{
			if(s==LEFT || s==CENTER || s==RIGHT || s==CUSTOM){
				_horizontal_registration=s;
			}else{
				_horizontal_registration=LEFT;
			}
		}
		public function get horizontal_registration():String{return _horizontal_registration;}
		
		public var x:Number=0;
		public var y:Number=0;

		public function DisplayObjectRegistrationPointHelper():void{}

		public function nestDisplayObjectToSprite(d_o:DisplayObject,w:Number,h:Number):Sprite{
			var s:Sprite=new Sprite();
			s.x=d_o.x;
			s.y=d_o.y;
			switch(_horizontal_registration){
				case LEFT:
					d_o.x=0;
					break;
				case CENTER:
					d_o.x=-w/2;
					s.x+=w/2;
					break;
				case RIGHT:
					d_o.x=-w;
					s.x+=w;
					break;
				case CUSTOM:
					d_o.x=-x;
					s.x+=x;
					break;
			}
			switch(_vertical_registration){
				case TOP:
					d_o.y=0;
					break;
				case CENTER:
					d_o.y=-h/2;
					s.y+=h/2;
					break;
				case BOTTOM:
					d_o.y=-d_o.height;
					s.y+=h;
					break;
				case CUSTOM:
					d_o.y=-y;
					s.y+=y;
					break;
			}
			s.addChild(d_o);
			return s;
		}
		
		public function toString():String{
			return "DisplayObjectRegistrationPointHelper{\n\tvertical_registration:"+_vertical_registration+",\n\thorizontal_registration:"+_horizontal_registration+"\n}";
		}

	}
}