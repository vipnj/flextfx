package be.nascom.util{
	
	public class HexColorUtil{
		
		private static var red:uint=0x0;
		private static var green:uint=0x0;
		private static var blue:uint=0x0;
		
		private static var color_components:Array=new Array(red,green,blue);
		
		/*
		public static function checkColorBounds(color:uint):uint{
			if(color<=0x0 || cur>0xFF){
				cur= cur<0x0 ? 0x0 : 0xFF ;
			}
		}
		*/
		
		//public static function getColorComponents
		
		public static function alterColorBy(color:uint,by:int):uint{
			red=((color>>16) & 0xFF)+by;
			green=((color>>8) & 0xFF)+by;
			blue=(color & 0xFF)+by;
			var cur:uint;
			for(var i:uint=0;i<3;i++){
				cur=color_components[i];
				if(cur<=0x0 || cur>0xFF){
					cur= cur<0x0 ? 0x0 : 0xFF ;
				}			
			}
			//return color;
			return red<<16 | green<<8 | blue;
		}
		public static function alterColorBy32(color:uint,by:int):uint{
			return 0;
		}
		
		public static function getInbetweenColorByPercent(
													color1:uint,
													color2:uint,
													percent:Number
														):uint{
			
			return 0;
		}
		
		/*
		public static function getInbetweenColorByPercent32(color1:uint,color2:uint;percent:Number):uint{
			return 0;
		}
		*/
		
	}
}

class ColorComponent{
	public var red:uint;
	public var green:uint;
	public var blue:uint;

	public function ColorComponent(r:uint,g:uint,b:uint){
		red=r;
		green=g;
		blue=b;
	}
	
	public function validate():void{}
	
	public function toHex():uint{
		return red<<16 | green<<8 | blue;
	}
	
	public function toValidHex():uint{
		validate();
		return toHex();
	}
}

class ColorComponent32 extends ColorComponent{
	public var alpha:Number;
	public function ColorComponent32(r:uint,g:uint,b:uint,a:Number=1){
		super(r,g,b);
		alpha=a;
	}
	
	override public function toHex():uint{
		return red<<16 | green<<8 | blue;
	}

}