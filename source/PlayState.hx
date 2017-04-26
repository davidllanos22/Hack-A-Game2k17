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
import flixel.util.FlxTimer;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;
import flixel.system.FlxSound;

class PlayState extends FlxState{
	public var text:FlxText;
	public var position:FlxPoint = new FlxPoint();
	public var t:Float = 0;
	public var player:Player;
	public var zombis:FlxSpriteGroup;
	public var obstacles:FlxSpriteGroup;
	public var bullets:FlxSpriteGroup;
	public var bars:FlxSpriteGroup;
	public var family:Family;
	public var analog:FlxAnalog;
	public var button1:Button;
	public var button2:Button;
	public var waveNumber:Int;
	public var greenBar:FlxBar;
	public var yellowBar:FlxBar;
	

	private static inline var SPEED:Float = 2;

	override public function create():Void{
		super.create();

		analog = new FlxAnalog(60, 180, 50, 0);
		button1 = new Button(240, 200, 20);
		button2 = new Button(280, 160, 20);

		analog.scrollFactor.set(0,0);
		button1.scrollFactor.set(0,0);
		button2.scrollFactor.set(0,0);

		analog.alpha = 0.5;
		button1.alpha = 0.5;
		button2.alpha = 0.5;

		// analog.scale.x = 0.5;
		// analog.scale.y = 0.5;

		zombis = new FlxSpriteGroup();
		obstacles = new FlxSpriteGroup();
		bullets = new FlxSpriteGroup();
		bars = new FlxSpriteGroup();

		family = new Family(0, 0, 10, 1);
		player = new Player(0, 0, this, 5, 5);

		add(new FlxSprite(0, 0, AssetPaths.bg__png));
		
		add(zombis);
		add(obstacles);
		add(bullets);

		add(analog);
		add(button1);
		add(button2);
		add(family);
		add(player);
		add(player.aim);
		add(bars);
		waveNumber = 1;
		spawnZombie(24,24);

		spawnZombie(24,24);

		FlxG.camera.follow(player.aim, TOPDOWN, 1);
		FlxG.camera.followLerp = 5 / FlxG.updateFramerate;


	}

	override public function update(elapsed:Float):Void{
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
					trace("hit");
					hitBulletZombie(cast(b,Bullet),cast(z,Zombie));
					break;
				}
				if(b.x<0 || 1080<b.x || b.y<0 || 720<b.y){
					b.kill();
					bullets.remove(b);
				}
			}
		}

		for(z in zombis){
			for(o in obstacles){
				if(FlxG.pixelPerfectOverlap(o,z)){
					hitObstacleZombie(cast(o,Obstacle),cast(z,Zombie));
					break;
				}
			}
		}

		for(z in zombis){
			if(FlxG.pixelPerfectOverlap(z, player)){
				hitPlayerZombi(cast(z,Zombie));
				break;
			}
		}

		/*t += 0.1;
		position.add(SPEED, 0);
		if(position.x > FlxG.camera.width) position.x = - 120;
		text.setPosition(position.x, position.y + Math.cos(t) * 10);*/
	}

	private function hitBulletZombie(b:Bullet,z:Zombie):Void{
		bullets.remove(b);
		b.kill();
		trace("disparo colisiona");
		z.getHit(b.damage);
		if(z.life<=0){
			zombis.remove(z);
			z.kill();
		}
	}

	private function hitObstacleZombie(o:Obstacle,z:Zombie):Void{
		if(Type.getClassName(Type.getClass(z))=="ZombieCreeper"){
			hitCreeper(cast(z,ZombieCreeper));
		}else{
			o.getHit(z.damage);
			if(o.life<=0){
				obstacles.remove(o);
				o.kill();
			}
			z.getHit(o.damage);
			if(z.life<=0){
				zombis.remove(z);
				z.kill();
			}
		}
	}

	private function hitPlayerZombi(z:Zombie):Void{
		if(Type.getClassName(Type.getClass(z))=="ZombieCreeper"){
			hitCreeper(cast(z,ZombieCreeper));
		}else{
			player.getHit(z.damage);
			if(player.life<=0){
				FlxG.switchState(new DefeatState(waveNumber));
			}
		}
	}

	//Fórmula Zombies normales: (sin(x) + x) · sqrt(x)
	private function spawnZombie(c1:Float,c2:Float):Void{
		var x = FlxG.width/2;
		var y = FlxG.height/2;
		

		var timer = new FlxTimer().start(2, function myCallback(Timer:FlxTimer):Void{

			var random = new FlxRandom();
			var op = random.int(0, 3);

			switch op{

				case 0: zombis.add(new Zombie(  -(x+c1)   ,   -(y+c2) + random.float(0,1)*(2*(y+c2)), this , 10, 10, 128, 10  ));
				case 1: zombis.add(new Zombie(  -(x+c1) + random.float(0,1)*(2*(x+c1))    ,   y+c2, this , 10 , 10 , 128 , 10  ));
				case 2: zombis.add(new Zombie(    x+c1    ,   -(y+c2) + random.float(0,1)*(2*(y+c2)), this, 10, 10, 128 ,10 ));
				case 3: zombis.add(new Zombie(  -(x+c1) + random.float(0,1)*(2*(x+c1))   ,   -(y+c2),  this,  10, 10, 128 , 10	));

			}

		}, Math.round((Math.sin(waveNumber) + waveNumber)*Math.sqrt(waveNumber)));
	}



	private function spawnObject(x:Float,y:Float):Void{

	}



	private function hitCreeper(c:ZombieCreeper){
		if(c.alive)c.allahuAkbar();
		for (x in obstacles){
			if (c.rad <= FlxMath.distanceBetween(c, x)){
				obstacles.remove(x);
			}
		}

		if(c.rad <= FlxMath.distanceBetween(player,c)){
			player.getHit(c.damage);
			if(player.life<=0){
				FlxG.switchState(new DefeatState(waveNumber));
			}
		}
		zombis.remove(c);
	}

	private function waveCompleted() {
		
	}

}
