package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.touch.FlxTouch;
import flixel.util.FlxColor;
import Math;

class Button extends FlxSprite {

	public var radius:Float;
	public var pressed:Bool;
	private var playState: PlayState;

	public function new(x:Float, y:Float, radius:Float, playState:PlayState) {
		super(x, y);
		this.playState = playState;

		makeGraphic(32, 32, FlxColor.BLUE);
		//loadGraphic(AssetPaths.sprites__png, true, 16, 16);
        //animation.add("spaceship", [1], 5);
        //animation.play("spaceship");

		this.radius = radius;
		this.pressed = false;
	}

	override public function update(elapsed:Float):Void {
		pressed = false;
		var str = "camera: " + FlxG.camera.scroll;
		str += "\nposition: " + getPosition();
		#if mobile
			for (touch in FlxG.touches.list) {
		   	 	if (touch.pressed) {
		   	 		var xx = touch.x + FlxG.camera.scroll.x * (FlxG.stage.stageWidth / FlxG.stage.stageHeight);
		   	 		var yy = touch.y + FlxG.camera.scroll.y * (FlxG.stage.stageWidth / FlxG.stage.stageHeight);
		   	 		str += "touch: (" + xx + ", " + yy +")";

		   	 		if(Math.pow(xx - x - radius, 2) + Math.pow(yy - y - radius, 2) <= Math.pow(radius, 2)) {
		   	 			pressed = true;
		   	 		}

		   	 	}
			}	
		#else
			str += "mouse: " + FlxG.mouse.getScreenPosition();
			if(Math.pow(FlxG.mouse.screenX - x - radius, 2) + Math.pow(FlxG.mouse.screenY - y - radius, 2) <= Math.pow(radius, 2) && FlxG.mouse.pressed) {
				pressed = true;
			}
		#end
		str += "pressed: " + pressed;
		playState.debugText.text = str;

	}
}