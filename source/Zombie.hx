package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;
import flixel.FlxG;

class Zombie extends FlxSprite{
    
    public var speed:Float;
    public var life:Float;
    public var ps:PlayState;
    public var tolerance:Float;
    public var damage:Int;
    private var dPlayer:Float;
    private var xx:Float;
    private var yy:Float;
    private var player:Player;
    private var target:FlxSprite;
    public var attackCooldown:Int;
    public var attackWaitTime:Int;
    private var greenBar:FlxBar;

    public static inline var WIDTHBAR = 16;
    public static inline var HEIGHBAR = 4;

	public function new(x:Float, y:Float, ps:PlayState, life:Float, speed:Float, tolerance:Float,damage:Int, attackCooldown:Int) {
        super(x, y);
        trace("spawn");
        setSize(32, 32);
        this.ps = ps;
        this.life = life;
        this.speed = speed;
        this.tolerance = tolerance;
        this.player = ps.player;
        this.damage = damage;

        target = ps.family;

        loadGraphic(AssetPaths.sprites__png, true, 32, 32);
        animation.add("zombie_walk", [0,1,0,2], 8);
        animation.play("zombie_walk");

        xx = speed * (- x / Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2)));
        yy = speed * (- y / Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2)));
        velocity = new FlxPoint(xx, yy);

        greenBar = new FlxBar(-145, -105, LEFT_TO_RIGHT, WIDTHBAR, HEIGHBAR);
        greenBar.createFilledBar(FlxColor.RED, FlxColor.GREEN, true, FlxColor.TRANSPARENT);
        greenBar.numDivisions = 5000;
        greenBar.value = 100;

        ps.bars.add(greenBar);


    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        this.dPlayer = FlxMath.distanceBetween(this,player);
        movement();
        if(attackWaitTime > 0) {attackWaitTime = attackWaitTime - 1;}
    }
    
    public function getHit(q:Float):Void{
        life -= q;
        greenBar.value-=q;
    }

    private function movement():Void{
        
        var px = player.x;
        var py = player.y;
        var zx = this.x;
        var zy = this.y;

        if(dPlayer<tolerance){
            xx = speed*( (px - zx)/ Math.sqrt( Math.pow(px - zx,2) + Math.pow(py - zy,2) ) );
            yy = speed*( (py - zy)/ Math.sqrt( Math.pow(px - zx,2) + Math.pow(py - zy,2) ) );
            target = player;
        }else{
            xx = speed * (- x / Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2)));
            yy = speed * (- y / Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2)));
            target = ps.family;
        }

        angle = getPosition().angleBetween(target.getPosition());
        if(FlxG.collide(this,ps.obstacles)){
            velocity.set(0,0);
        }else{
            velocity = new FlxPoint(xx,yy);
        }

        greenBar.x = this.x + 8;
        greenBar.y = this .y - 6;
    }

}