package;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import Math;

class Bullet extends FlxSprite{
	public var _speed:Float = 400;
	public var damage:Float = 1;
	public var _rAngle:Float;

	public function new (x: Float, y: Float, a: Float){
		super(x, y);
		setSize(8, 8);
		this._rAngle = a;
		angle = a + 90;
		loadGraphic(AssetPaths.tiles__png, true, 16, 16);
        animation.add("bullet", [32], 8);
        animation.play("bullet");
	}

	private function movement():Void{
		velocity.set(_speed, 0);
		velocity.rotate(FlxPoint.weak(0, 0), _rAngle);
	}

	override public function update(elapsed:Float):Void{
		movement();
		super.update(elapsed);	
		
	}
}