package;

import Math;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

class Player extends FlxSprite {
	
	public var playState:PlayState;

	public var baseSpeed:Float;
	public var speedMultiplier:Float;

	public var baseFirerate:Float;
	public var firerateMultiplier:Float;
	public var fireWaitTime:Float;

	public var aim:flixel.FlxSprite;
	public var life:Int;

	public var greenBar:FlxBar;
	public var yellowBar:FlxBar;

	public static inline var WIDTHBAR = 16;
	public static inline var HEIGHBAR = 4;

	public function new(x:Float, y:Float, playState:PlayState, baseSpeed:Float, baseFirerate:Float) {
		super(x, y);

		loadGraphic(AssetPaths.sprites__png, true, 32, 32);
        animation.add("player_walk", [8,9,8,10], 8);
        animation.play("player_walk");

		this.playState = playState;

		this.baseSpeed = baseSpeed;
		this.speedMultiplier = 1;

		this.baseFirerate = baseFirerate;
		this.firerateMultiplier = 1;
		this.fireWaitTime = 0;

		aim = new flixel.FlxSprite(x + 50,y);
		aim.makeGraphic(2, 2, FlxColor.RED);

		life=100;

		greenBar = new FlxBar(-145, -105, LEFT_TO_RIGHT, WIDTHBAR, HEIGHBAR);
		greenBar.createFilledBar(FlxColor.TRANSPARENT, FlxColor.GREEN, true, FlxColor.TRANSPARENT);
		greenBar.numDivisions = 5000;
		greenBar.value = 100;

		yellowBar = new FlxBar(-145,-105, LEFT_TO_RIGHT, WIDTHBAR, HEIGHBAR);
		yellowBar.createFilledBar(FlxColor.RED, FlxColor.YELLOW, true, FlxColor.TRANSPARENT);
		yellowBar.numDivisions = 5000;
		yellowBar.value = 100;

		playState.bars.add(yellowBar);
		playState.bars.add(greenBar);


	}

	override public function update(elapsed:Float) {
		movement();

		#if mobile

			if(fireWaitTime != 0) {fireWaitTime = fireWaitTime - ( 1 / 60);}
			if(playState.button1.pressed && fireWaitTime <= 0) {
				gunShoot();
				fireWaitTime = fireWaitTime + (1 / (baseFirerate * firerateMultiplier));
			}

			if(!playState.button1.pressed && fireWaitTime < 0) {fireWaitTime = 0;}

		#else

			if(fireWaitTime != 0) {fireWaitTime = fireWaitTime - ( 1 / 60);}
			if(FlxG.keys.pressed.SPACE && fireWaitTime <= 0) {
				gunShoot();
				fireWaitTime = fireWaitTime + (1 / (baseFirerate * firerateMultiplier));
			}
			if(!FlxG.keys.pressed.SPACE && fireWaitTime < 0) {fireWaitTime = 0;}

		#end

		greenBar.x = x + 8;
		greenBar.y = y - 6;
		yellowBar.x = x + 8;
		yellowBar.y = y - 6;

		if(greenBar.value < yellowBar.value){
			greenBar.value-=0.1;
		}

		super.update(elapsed);
	}

	public function movement():Void {
		var analog = playState.analog;
		var button1 = playState.button1;
		var button2 = playState.button2;
		#if mobile
			if(!button1.pressed) angle = analog.getAngle() + 90;

			var p = FlxAngle.getCartesianCoords(100, angle - 90);
			aim.x = p.x + this.x + 16;
			aim.y = p.y + this.y + 16;
			
			if(Math.pow(analog.acceleration.x, 2) + Math.pow(analog.acceleration.y, 2) > 441) {
				x = x + (analog.acceleration.x * baseSpeed * speedMultiplier / 42);
				y = y + (analog.acceleration.y * baseSpeed * speedMultiplier / 42);
			}
		#else
			if(!button1.pressed && !FlxG.keys.pressed.SPACE) angle = analog.getAngle() + 90;

			var p = FlxAngle.getCartesianCoords(100, angle - 90);
			aim.x = p.x + this.x + 16;
			aim.y = p.y + this.y + 16;
			
			if(Math.pow(analog.acceleration.x, 2) + Math.pow(analog.acceleration.y, 2) > 441) {
				x = x + (analog.acceleration.x * baseSpeed * speedMultiplier / 42);
				y = y + (analog.acceleration.y * baseSpeed * speedMultiplier / 42);
			}
		#end
	}

	public function gunShoot():Void {
		var shotOffset = FlxAngle.getCartesianCoords(Math.sqrt(281), angle - 110);
		var bullet = new Bullet(x + shotOffset.x + 8, y + shotOffset.y + 8, angle - 90);
		playState.bullets.add(bullet);
	}

	public function getHit(damage:Int){
		life -= damage;
		greenBar.value-= damage;
	}
}