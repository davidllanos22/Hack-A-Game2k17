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
	public var button1:FlxButton;
	public var button2:FlxButton;
	public var waveNumber:Int;
	public var zombiesLeft:Int;
	public var announcementText:FlxText;
	public var greenBar:FlxBar;
	public var yellowBar:FlxBar;
	public var inventory:Inventory;
	public var sub:CraftMenu;
	private var sndVictory:FlxSound;
	private var sndDeath:FlxSound;
	private var sndGrunt:FlxSound;

	private static inline var SPEED:Float = 2;

	override public function create():Void{
		super.create();

		inventory = new Inventory();
		var sub = new CraftMenu(inventory, this, FlxColor.GRAY);
		//openSubState(sub);

		if (FlxG.sound.music == null){
			FlxG.sound.playMusic(AssetPaths.battle__wav, 0.5, true);
		}
		analog = new FlxAnalog(60, FlxG.height - 60, 50, 0);
		//button1 = new Button(FlxG.width - 90, FlxG.height - 50, 20, this);
		button1 = new FlxButton(FlxG.width - 90, FlxG.height - 50,"1");
		button1.loadGraphic("assets/images/button.png");
		button1.setSize(50,50);
		//button2 = new Button(FlxG.width - 50, FlxG.height - 90, 20, this);
		button2 = new FlxButton(FlxG.width - 50, FlxG.height - 90,"2");
		button2.loadGraphic("assets/images/button.png");
		button2.setSize(50,50);
		inventory = new Inventory();

		analog.scrollFactor.set(0,0);
		button1.scrollFactor.set(0,0);
		button2.scrollFactor.set(0,0);

		analog.alpha = 0.5;
		button1.alpha = 0.5;
		button2.alpha = 0.5;
		
		FlxG.scaleMode = new RatioScaleMode(false);

		// analog.scale.x = 0.5;
		// analog.scale.y = 0.5;

		inventory.addItem(Item.WOOD);
		inventory.addItem(Item.WOOD);

		trace("cancreate: " + inventory.canCreate(Item.WOOD_WALL));

		inventory.createItem(Item.WOOD_WALL);

        sndVictory = FlxG.sound.load(AssetPaths.waveEnd__wav);
		zombis = new FlxSpriteGroup();
		obstacles = new FlxSpriteGroup();
		bullets = new FlxSpriteGroup();
		bars = new FlxSpriteGroup();

		family = new Family(125, 50, 10, 1);
		player = new Player(144, 122, this, 2.5, 5);
        sndGrunt = FlxG.sound.load(AssetPaths.zombieGrunt__wav);
        sndDeath = FlxG.sound.load(AssetPaths.enemyDeath__wav);


		add(new FlxSprite(0, 0, AssetPaths.bg__png));

		createBuilding(80,27);
		createBuilding(400,27);
		createBuilding(80,267);
		createBuilding(400,267);

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

		var sub = new CraftMenu(inventory, this, FlxColor.GRAY);

	}

	override public function update(elapsed:Float):Void{
		super.update(elapsed);

		FlxG.camera.maxScrollX = 640;
		FlxG.camera.minScrollX = 0;
		FlxG.camera.maxScrollY = 480;
		FlxG.camera.minScrollY = 0;

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
				if(b.x<0 || 640<b.x || b.y<0 || 480<b.y){
					b.kill();
					bullets.remove(b);
				}
			}
		}

		for(z in zombis){
			for(o in obstacles){
				if(FlxMath.distanceBetween(z,o) < 10){
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

		for(z in zombis){
			if(FlxG.pixelPerfectOverlap(z, family)){
				family.getHit(cast(z,Zombie).damage);
				if(family.life<=0){
					FlxG.switchState(new DefeatState(waveNumber));
				}
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
			sndDeath.play();
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
				case 0: zombis.add(new Zombie(  -(c1)   ,   -c2 + random.float(0,1)*((480+ (2*c2))), this , 100, 10, 128, 10, 60));
				case 1: zombis.add(new Zombie(  -(c1) + random.float(0,1)*((640+ (2*c1)))    ,   -c2, this , 100 , 10 , 128 , 10, 60));
				case 2: zombis.add(new Zombie(640+c1, -c2 + random.float(0,1) * (720 + (2 * c2)), this, 100, 10, 128 ,10, 60));
				case 3: zombis.add(new Zombie(  -(c1) + random.float(0,1)*((640+(2*c1)))   ,   480+c2,  this,  100, 10, 128 , 10,	60));
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
		FlxG.sound.pause();
		sndVictory.play();
		sndVictory.onComplete = playBattle;
		waveNumber = waveNumber + 1;
		zombiesLeft = -1;
		announcementText = new FlxText(0, 0, 0, "Wave Completed", 16);
		announcementText.screenCenter();
		announcementText.scrollFactor.set(0, 0);
		add(announcementText);
		var timer1 = new FlxTimer().start(5, function myCallback(Timer:FlxTimer):Void {
			remove(announcementText);
			openSubState(sub);
			FlxG.sound.playMusic (AssetPaths.craft__wav, 0.5, true);
		}, 1);
	}

	public function startWave():Void {
		announcementText = new FlxText(0, 0, 0, "Wave " + Std.string(waveNumber), 16);
		announcementText.screenCenter();
		announcementText.scrollFactor.set(0, 0);
		add(announcementText);
		var timer = new FlxTimer().start(5, function myCallback(Timer:FlxTimer):Void {
			remove(announcementText);
		}, 1);
		spawnZombie(24,24);
		sndGrunt.play();
	}

	private function playBattle(){
		FlxG.sound.playMusic(AssetPaths.battle__wav, 0.5, true);
	}

	private function createBuilding(x:Int, y:Int){
		var i:Int;
		for(i in 0...8){
			obstacles.add(new Obstacle(x+i*16,y,16,5,10,0));//UP
			if(i!=3 && i!=4)obstacles.add(new Obstacle(x+i*16,5+y+4*16,16,5,10,0));//DOWN
		}
		for(i in 0...4){
			obstacles.add(new Obstacle(x,5+y+i*16,5,16,10,0));//LEFT
			obstacles.add(new Obstacle(x-5+16*8,5+y+i*16,5,16,10,0));//RIGHT
		}
		
	}

}
