package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxMath;

class Zombie extends FlxSprite{
	
    public var speed:Float;
    public var life:Float;
    public var ps:PlayState;
    public var tolerance:Float;
    public var damage:Float;
    private var dPLayer:Float;
    private var xx:Float;
    private var yy:Float;
    private var player:Player;

	public function new(x:Float, y:Float, ps:PlayState, life:Float, speed:Float, tolerance:Float, player:PLayer,damage:Float) {
        super(x, y);
        setSize(16, 16);
        makeGraphic(16, 16, FlxColor.RED);
        this.ps = ps;
        this.life = life;
        this.speed = speed;
        this.tolerance = tolerance;
        this.player = ps.PLayer;

        /*loadGraphic(AssetPaths.sprites__png, true, 16, 16);
        animation.add("zombie", [0], 5);
        animation.play("zombie");*/
        
        xx = speed * (- x / Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2)));
        yy = speed * (- y / Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2)));
        velocity = new FlxPoint(xx, yy);
   
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        dPLayer = distanceBetween(this,ps.player);
        movement(d,tolerance);
    }
    
    public function getHit(q:Float):Void{
        life-=q;
    }

    private function movement(d:Float,tolerance:Float):Void{
        
        var px = player.x;
        var py = player.y;
        var zx = this.x;
        var zy = this.y;

        if(dPLayer<tolerance){
            xx = speed*( (px - zx)/ Math.sqrt( Math.pow(px - zx,2) + Math.pow(py - zy,2) ) );
            yy = speed*( (py - zy)/ Math.sqrt( Math.pow(px - zx,2) + Math.pow(py - zy,2) ) );
        }else{
            xx = speed * (- x / Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2)));
            yy = speed * (- y / Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2)));
        }

        velocity = new FlxPoint(xx,yy);
    }

}