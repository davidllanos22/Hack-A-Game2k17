package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup;
import flixel.FlxCamera;
import flixel.ui.FlxAnalog;

class PlayState extends FlxState{
	public var text:FlxText;
	public var position:FlxPoint = new FlxPoint();
	public var t:Float = 0;
	public var player:Player;
	public var zombis:FlxSpriteGroup;
	public var obstacles:FlxSpriteGroup;
	public var bullets:FlxSpriteGroup;
	public var family:Family;
	public var analog:FlxAnalog;
	public var button1:Button;
	public var button2:Button;

	private static inline var SPEED:Float = 2;

	override public function create():Void{
		super.create();

		analog = new FlxAnalog(60, 180, 50, 0);
		button1 = new Button(20, 20, 10);
		button2 = new Button(60, 60, 10);
		zombis = new FlxSpriteGroup();
		obstacles = new FlxSpriteGroup();
		
		bullets = new FlxSpriteGroup();
		family = new Family(0,0,10,1);
		add(analog);
		add(button1);
		add(button2);

		FlxG.camera.follow(player, TOPDOWN, 1);
	}

	override public function update(elapsed:Float):Void{
		trace(analog.acceleration);

		super.update(elapsed);

		for(o in obstacles){
			for(b in bullets){
				if(FlxG.pixelPerfectOverlap(o,b)){
					b.kill();
					bullets.remove(b);
				}
			}
		}

		for(z in zombis){
			for(b in bullets){
				if(FlxG.pixelPerfectOverlap(b,z)){
					hitBulletZombi(b,z);
					break;
				}
			}
		}

		for(z in zombis){
			for(o in obstacles){
				if(FlxG.pixelPerfectOverlap(o,z)){
					hitObstacleZombie(o,z);
					break;
				}
			}
		}

		FlxG.pixelPerfectOverlap(bullets,zombis,hitBulletZombi);
		FlxG.pixelPerfectOverlap(obstacles,zombis,hitObstacleZombi);
		/*t += 0.1;
		position.add(SPEED, 0);
		if(position.x > FlxG.camera.width) position.x = - 120;
		text.setPosition(position.x, position.y + Math.cos(t) * 10);*/
	}

	private function hitBulletZombie(b:Bullet,z:Zombie){
		bullets.remove(b);
		b.kill();

		z.getHit(b.damage);
		if(z.life<=0){
			zombis.remove(z);
			z.kill();
		}
	}

	private function hitObstacleZombie(o:Obstacle,z:Zombie){
		o.getHit(z.damage);
		if(o.life<=0){
			obstacles.remove(o);
			o.kill();
		}
		if(Type.typeof(z)=="ZombieCreeper"){
			hitObstacleCreeper(z);
		}else{
			z.getHit(o.damage);
			if(z.life<=0){
				zombis.remove(z);
				z.kill();
			}
		}
	}

	private function hitPlayerZombi(z:Zombie){
		player.getHit(z.damage);
		if(player.life<=0){
			FlxG.switchState(new DefeatState());
		}
	}

	private function spawnZombie(x:Float,y:Float):Void{
		var x = FlxG.width/2;
		var y = FlxG.height/2;

		timer = new FlxTimer().start(t, function myCallback(Timer:FlxTimer):Void{
			var random = new FlxRandom();
			var op = random.int(0, 3);
			switch op{
				case 0: obstacleGroup.add(new Enemy(  -(x+c1)   ,   -(y+c2) + random.float(0,1)*(2*(y+c2))    ));
				case 1: obstacleGroup.add(new Enemy(  -(x+c1) + random.float(0,1)*(2*(x+c1))    ,   y+c2   ));
				case 2: obstacleGroup.add(new Enemy(    x+c1    ,   -(y+c2) + random.float(0,1)*(2*(y+c2))    ));
				case 3: obstacleGroup.add(new Enemy(  -(x+c1) + random.float(0,1)*(2*(x+c1))   ,   -(y+c2)    ));
			}
			
		}, 0);
	}

	private function spawnObject(x:Float,y:Float):Void{

	}


	private function hitObstacleCreeper(c:ZombieCreeper){
		c.allahuAkbar();
		for (x in obstacles){
			if (c.rad > distanceBetween(c, x)){
				obstacles.remove(x);
			}
		}
		zombis.remove(c);
	}
}
