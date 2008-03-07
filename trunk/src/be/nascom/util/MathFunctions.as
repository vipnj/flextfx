package be.nascom.util{
	
	
	
	public class MathFunctions{

		public static function radiansToDegrees(rad:Number):Number{
			return rad*180/Math.PI;
		}
		public static function degreesToRadians(degree:Number):Number{
			return degree*Math.PI/180;
		}
		
		public static function getRandomNumberInRange(min:Number,max:Number):Number{
			return min+Math.random()*(max-min);
		}
		
		public static function getRandomIntInRange(min:int,max:int):int{
			return Math.round(min+Math.random()*(max-min));
		}
		
		public static function getRandomUintInRange(min:uint,max:uint):uint{
			return uint(Math.round(min+Math.random()*(max-min)));
		}
		
	}
}