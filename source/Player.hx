package;

import Math;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;

class Player extends FlxSprite {
	
	public var playState:PlayState;

	public var baseSpeed:Float;
	public var speedMultiplier:Float;

	public var baseFirerate:Float;
	public var firerateMultiplier:Float;
	public var fireWaitTime:Float;

	public var aim:flixel.FlxSprite;

	public function new(x:Float, y:Float, playState:PlayState, baseSpeed:Float, baseFirerate:Float) {
		super(x, y);

		makeGraphic(16, 16, FlxColor.ORANGE);
		//loadGraphic(AssetPaths.sprites__png, true, 16, 16);
        //animation.add("spaceship", [1], 5);
        //animation.play("spaceship");

		this.playState = playState;

		this.baseSpeed = baseSpeed;
		this.speedMultiplier = 1;

		this.baseFirerate = baseFirerate;
		this.firerateMultiplier = 1;
		this.fireWaitTime = 0;

		aim = new flixel.FlxSprite(x + 50,y);
		aim.makeGraphic(2, 2, FlxColor.RED);
	}

	override public function update(elapsed:Float) {
		movement();

		if(fireWaitTime != 0) {fireWaitTime = fireWaitTime - (1 / 60);}
		if(fireWaitTime <= 0) {
			gunShoot();
			fireWaitTime = fireWaitTime + (1 / (baseFirerate * firerateMultiplier));
		}

		super.update(elapsed);
	}

	public function movement():Void {
		var analog = playState.analog;
		var button1 = playState.button1;
		var button2 = playState.button2;

		if(button1.pressed) {}
		else {
			angle = analog.getAngle();
			var p=FlxAngle.getCartesianCoords(50, angle);
			aim.x=p.x;
			aim.y=p.y;
		}
		
		if(Math.pow(analog.acceleration.x, 2) + Math.pow(analog.acceleration.y, 2) > 441) {
			x = x + (analog.acceleration.x * baseSpeed * speedMultiplier / 42);
			y = y + (analog.acceleration.y * baseSpeed * speedMultiplier / 42);
		}
	}

	public function gunShoot():Void {
		var bullet = new Bullet(x, y, angle);
		playState.add(bullet);
	}

}