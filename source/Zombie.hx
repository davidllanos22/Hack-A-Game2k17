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
    public var greenBar:FlxBar;
    private var maxlife:Float;

    public static inline var WIDTHBAR = 16;
    public static inline var HEIGHBAR = 4;

	public function new(x:Float, y:Float, ps:PlayState, life:Float, speed:Float, tolerance:Float,damage:Int, attackCooldown:Int) {
        super(x, y);
        trace("spawn");
        this.ps = ps;
        this.life = life;
        this.speed = speed;
        this.tolerance = tolerance;
        this.player = ps.player;
        this.damage = damage;
        this.maxlife = life;

        target = ps.family;

        loadGraphic(AssetPaths.sprites__png, true, 32, 32);
        animation.add("zombie_walk", [0,1,0,2], 8);
        animation.play("zombie_walk");

        setSize(12, 12);
        offset.set(10,10);

        xx = speed * (- x / Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2)));
        yy = speed * (- y / Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2)));
        velocity = new FlxPoint(xx, yy);

        greenBar = new FlxBar(-145, -105, LEFT_TO_RIGHT, WIDTHBAR, HEIGHBAR);
        greenBar.createFilledBar(FlxColor.RED, FlxColor.GREEN, true, FlxColor.TRANSPARENT);
        greenBar.numDivisions = 5000;
        greenBar.value = 100;

        ps.bars.add(greenBar);

        attackWaitTime = 0;
        this.attackCooldown = attackCooldown;
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        this.dPlayer = FlxMath.distanceBetween(this,player);
        movement();
        if(attackWaitTime > 0) {attackWaitTime = attackWaitTime - 1;}
    }
    
    public function getHit(q:Float):Void{
        life -= q;
        greenBar.value = life * 100 / maxlife;
    }

    private function movement():Void{

        var zx = this.x;
        var zy = this.y;

        if(dPlayer<tolerance){
            target = player;
        }else{
            target = ps.family;
        }

        angle = getPosition().angleBetween(target.getPosition());
        if(FlxG.collide(this,ps.obstacles)){
            velocity.set(0,0);
        }else{
            xx = speed * ( (target.x-zx) / Math.sqrt(Math.pow((target.x-zx), 2) + Math.pow((target.y-zy), 2)));
            yy = speed * ( (target.y-zy) / Math.sqrt(Math.pow((target.x-zx), 2) + Math.pow((target.y-zy), 2)));
            velocity = new FlxPoint(xx,yy);
        }

        greenBar.x = this.x;
        greenBar.y = this .y - 12;
    }

}