package;
import flixel.math.FlxMath;
import flixel.FlxSprite;

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

	public function getHit(damage:Int):Void{
		life-=damage;
	}


}