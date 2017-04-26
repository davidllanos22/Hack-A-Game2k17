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
import flixel.system.scaleModes.RatioScaleMode;
import Inventory;

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
	public var zombiesLeft:Int;
	public var announcementText:FlxText;
	public var greenBar:FlxBar;
	public var yellowBar:FlxBar;
	public var inventory:Inventory;

	private static inline var SPEED:Float = 2;

	override public function create():Void{
		super.create();

		analog = new FlxAnalog(60, FlxG.height - 60, 50, 0);
		button1 = new Button(FlxG.width - 90, FlxG.height - 50, 20);
		button2 = new Button(FlxG.width - 50, FlxG.height - 90, 20);
		inventory = new Inventory();

		analog.scrollFactor.set(0,0);
		button1.scrollFactor.set(0,0);
		button2.scrollFactor.set(0,0);

		analog.alpha = 0.5;
		button1.alpha = 0.5;
		button2.alpha = 0.5;
		
		inventory.addItem(Item.ALCOHOL);

		FlxG.scaleMode = new RatioScaleMode(false);

		// analog.scale.x = 0.5;
		// analog.scale.y = 0.5;

		zombis = new FlxSpriteGroup();
		obstacles = new FlxSpriteGroup();
		bullets = new FlxSpriteGroup();
		bars = new FlxSpriteGroup();

		family = new Family(0, 0, 10, 1);
		player = new Player(0, 0, this, 5, 5);

		add(new FlxSprite(0, 0, AssetPaths.bg__png));
		
		obstacles.add(new Obstacle(100,100,50,50,10,0));

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

		startWave();

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
				if(FlxMath.distanceBetween(z,o) < 55){
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

		if(zombiesLeft == 0) {
			waveCompleted();
		}

		/*t += 0.1;
		position.add(SPEED, 0);
		if(position.x > FlxG.camera.width) position.x = - 120;
		text.setPosition(position.x, position.y + Math.cos(t) * 10);*/
	}

	private function hitBulletZombie(b:Bullet, z:Zombie):Void{
		bullets.remove(b);
		b.kill();
		z.getHit(b.damage);
		if(z.life<=0){
			zombis.remove(z);
			z.kill();
			z.greenBar.kill();
			zombiesLeft = zombiesLeft - 1;
		}
	}

	private function hitObstacleZombie(o:Obstacle,z:Zombie):Void{
		if(Type.getClassName(Type.getClass(z))=="ZombieCreeper"){
			hitCreeper(cast(z,ZombieCreeper));
		}
		else {
			if (z.attackWaitTime == 0) {
				o.getHit(z.damage);
				if(o.life<=0){
					obstacles.remove(o);
					o.kill();
				}

				z.getHit(o.damage);
				if(z.life<=0){
					zombis.remove(z);
					z.kill();
					zombiesLeft = zombiesLeft - 1;
				}
				z.attackWaitTime = z.attackCooldown;
			}
		}
	}

	private function hitPlayerZombi(z:Zombie):Void{
		if(Type.getClassName(Type.getClass(z))=="ZombieCreeper"){
			hitCreeper(cast(z,ZombieCreeper));
		}
		else {
			if(z.attackWaitTime == 0) {
				player.getHit(z.damage);
				z.attackWaitTime = z.attackCooldown;
				if(player.life<=0){
				FlxG.switchState(new DefeatState(waveNumber));
				}
			}
		}
	}

	//Fórmula Zombies normales: (sin(x) + x) · sqrt(x)
	private function spawnZombie(c1:Float,c2:Float):Void{

		var timer = new FlxTimer().start(2, function myCallback(Timer:FlxTimer):Void{

			var random = new FlxRandom();
			var op = random.int(0, 3);

			switch op{
				case 0: zombis.add(new Zombie(  -(c1)   ,   -c2 + random.float(0,1)*((720+ (2*c2))), this , 100, 10, 128, 10, 60));
				case 1: zombis.add(new Zombie(  -(c1) + random.float(0,1)*((1080+ (2*c1)))    ,   -c2, this , 100 , 10 , 128 , 10, 60));
				case 2: zombis.add(new Zombie(1080+c1, -c2 + random.float(0,1) * (720 + (2 * c2)), this, 100, 10, 128 ,10, 60));
				case 3: zombis.add(new Zombie(  -(c1) + random.float(0,1)*((1080+(2*c1)))   ,   720+c2,  this,  100, 10, 128 , 10,	60));
			}

		}, Math.round((Math.sin(waveNumber) + waveNumber)*Math.sqrt(waveNumber)));

		zombiesLeft = Math.round((Math.sin(waveNumber) + waveNumber)*Math.sqrt(waveNumber));

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

	private function waveCompleted():Void {
		waveNumber = waveNumber + 1;
		zombiesLeft = -1;
		announcementText = new FlxText(0, 0, 0, "Wave Completed", 16);
		announcementText.screenCenter();
		announcementText.scrollFactor.set(0, 0);
		add(announcementText);
		var timer1 = new FlxTimer().start(8, function myCallback(Timer:FlxTimer):Void {
			remove(announcementText);
		}, 1);
		var timer2 = new FlxTimer().start(10, function myCallback(Timer:FlxTimer):Void {
			startWave();
		}, 1);
	}

	private function startWave():Void {
		announcementText = new FlxText(0, 0, 0, "Wave " + Std.string(waveNumber), 16);
		announcementText.screenCenter();
		announcementText.scrollFactor.set(0, 0);
		add(announcementText);
		var timer = new FlxTimer().start(5, function myCallback(Timer:FlxTimer):Void {
			remove(announcementText);
		}, 1);
		spawnZombie(24,24);
	}

}
