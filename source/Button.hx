package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.touch.FlxTouch;
import flixel.util.FlxColor;
import Math;

class Button extends FlxSprite {

	public var radius:Float;
	public var pressed:Bool;

	public function new(x:Float, y:Float, radius:Float) {
		super(x, y);

		makeGraphic(32, 32, FlxColor.BLUE);
		//loadGraphic(AssetPaths.sprites__png, true, 16, 16);
        //animation.add("spaceship", [1], 5);
        //animation.play("spaceship");

		this.radius = radius;
		this.pressed = false;
	}

	override public function update(elapsed:Float):Void {
		pressed = false;

		#if mobile
			for (touch in FlxG.touches.list) {
		   	 	if (touch.pressed) {
		   	 		if(Math.pow(touch.x - x + radius, 2) + Math.pow(touch.y - y, 2) <= Math.pow(radius, 2)) {
		   	 			pressed = true;
		   	 		}
		   	 	}
			}	
		#else
			if(Math.pow(FlxG.mouse.screenX - x + radius, 2) + Math.pow(FlxG.mouse.screenY - y, 2) <= Math.pow(radius, 2) && FlxG.mouse.pressed) {pressed = true;}
		#end
	}
}