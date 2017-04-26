package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;

class Obstacle extends FlxSprite{
	public var life:Int;
	public var damage:Int;

    public function new(x:Float, y:Float, sizeX:Int, sizeY:Int, life:Int, damage:Int) {
        super(x, y);
        setSize(sizeX,sizeY);
        this.life=life; 
        this.damage=damage;   
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }

    public function getHit(damage:Int){
    	life-=damage;
    }
}