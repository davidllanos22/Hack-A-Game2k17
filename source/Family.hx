package;
import flixel.math.FlxMath;
import flixel.FlxSprite;

class Family extends FlxSprite{
	public var rad:Float;
	public var life:Int;

	override public function new(x:Int, y:Int, r:Float, l:Int):Void{
		super(x, y);
		setSize(32, 32);
		loadGraphic(AssetPaths.sprites__png, true, 32, 32);
        animation.add("family", [16], 8);
        animation.play("family");
		rad = r;
		life = l;
	}

	override public function update(elapsed:Float):Void{

	}

	public function getHit(damage:Int):Void{
		life-=damage;
	}


}