package;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxMath;

class ZombieCreeper extends Zombie{
	public var rad:Float;

	public function new(x:Float, y:Float, ps:PlayState, life:Float, speed:Float, tolerance:Float, player:PLayer, damage:Float, r:Float) {
		super(x, y, ps, life, speed, tolerance, player, damage);
		rad = r;
		setSize(16, 16);
		makeGraphic(16, 16, FlxColor.GREEN);


		xx = speed * (- x / Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2)));
        yy = speed * (- y / Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2)));
        velocity = new FlxPoint(xx, yy);
	}

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        dPLayer = distanceBetween(this,ps.player);
        if (dPlayer < rad){
        	allahuAkbar();
        }
        movement(d,tolerance);
    }

    public function allahuAkbar():Void {
    	life = 0;
    	this.kill();
    }
}