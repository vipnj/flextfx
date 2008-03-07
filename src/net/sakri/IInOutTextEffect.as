package net.sakri{
	
	public interface IInOutTextEffect{

		function enter():void
		
		function exit():void
		
		function stop():void
		
		function set auto_play(b:Boolean):void
		
		function get auto_play():Boolean
		
		function set auto_play_interval(interval:Number):void
		
		function get auto_play_interval():Number
		
	}
}