package;
import flixel.math.FlxMath;

class Family extends FlxSprite{
	public var rad:Float;
	public var life:Int;

	override public function new(x:Int, y:Int, r:Float, l:Int):Void{
		super(x, y);
		//setSize(2, 2); --> Set size al tamaño que más os apetezca.
		rad = r;
		life = l;
	}

	override public function update(elapsed:Float):Void{

	}

	public function isHit(enemy:FlxSprite):Void{
		var d = FlxMath.distanceBetween(this, zombie);
		if d<=r{
			life -= 10;
			zombie.kill();
		}
	}


}