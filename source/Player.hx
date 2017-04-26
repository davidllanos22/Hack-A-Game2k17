package;

import Math;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.FlxG;

class Player extends FlxSprite {
	
	public var playState:PlayState;

	public var baseSpeed:Float;
	public var speedMultiplier:Float;

	public var baseFirerate:Float;
	public var firerateMultiplier:Float;
	public var fireWaitTime:Float;

	public var aim:flixel.FlxSprite;
	public var life:Int;

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

		super.update(elapsed);
	}

	public function movement():Void {
		var analog = playState.analog;
		var button1 = playState.button1;
		var button2 = playState.button2;

			if(!button1.pressed && !FlxG.keys.pressed.SPACE && !analog.justReleased) angle = analog.getAngle() + 90;

			var p = FlxAngle.getCartesianCoords(100, angle - 90);
			aim.x = p.x + this.x + 16;
			aim.y = p.y + this.y + 16;
			
			if(Math.pow(analog.acceleration.x, 2) + Math.pow(analog.acceleration.y, 2) > 441) {
				x = x + (analog.acceleration.x * baseSpeed * speedMultiplier / 42);
				y = y + (analog.acceleration.y * baseSpeed * speedMultiplier / 42);
			}
	}

	public function gunShoot():Void {
		var shotOffset = FlxAngle.getCartesianCoords(Math.sqrt(281), angle - 110);
		var bullet = new Bullet(x + shotOffset.x + 8, y + shotOffset.y + 8, angle - 90);
		playState.bullets.add(bullet);
	}

	public function getHit(damage:Int){
		life -= damage;
	}
}