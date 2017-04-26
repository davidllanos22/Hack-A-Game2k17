package;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import Math;

class Bullet extends FlxSprite{
	public var _speed:Float = 400;
	public var _dmg:Float = 1;
	public var _rAngle:Float;

	public function new (x: Float, y: Float, angle: Float){
		super(x, y);
		this._rAngle = angle;
		//Cargar sprite y animación.
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