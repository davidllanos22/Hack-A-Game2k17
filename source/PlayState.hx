package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.math.FlxPoint;

class PlayState extends FlxState{
	private var text:FlxText;
	private var position:FlxPoint = new FlxPoint();
	private var t:Float = 0;

	private static inline var SPEED:Float = 2;

	override public function create():Void{
		super.create();
		text = new FlxText(0, 0, 0, "Hello World", 16);
		text.screenCenter();
		text.getPosition().copyTo(position);
		add(text);
	}

	override public function update(elapsed:Float):Void{
		super.update(elapsed);
		t += 0.1;
		position.add(SPEED, 0);
		if(position.x > FlxG.camera.width) position.x = - 120;
		text.setPosition(position.x, position.y + Math.cos(t) * 10);
	}
}
