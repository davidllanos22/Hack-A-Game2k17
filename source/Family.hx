package;
import flixel.math.FlxMath;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.system.FlxSound;

class Family extends FlxSprite{
	public var life:Int;
	private var sndDeath:FlxSound;

	override public function new(x:Int, y:Int, r:Float, l:Int):Void{
		super(x, y);
		sndDeath = FlxG.sound.load(AssetPaths.familyHurt__wav);
		setSize(32, 32);
		loadGraphic(AssetPaths.sprites__png, true, 32, 32);
        animation.add("family", [16], 8);
        animation.play("family");
		life = l;
	}

	override public function update(elapsed:Float):Void{

	}

	public function getHit(damage:Int):Void{
		life-=damage;
		sndDeath.play();

	}


}