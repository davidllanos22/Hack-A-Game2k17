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

class PlayState extends FlxState{
	private var text:FlxText;
	private var position:FlxPoint = new FlxPoint();
	private var t:Float = 0;
	private var player:Player;
	private var zombis:FlxSpriteGroup;
	private var obstacles:FlxSpriteGroup;
	private var bullets:FlxSpriteGroup;

	private static inline var SPEED:Float = 2;

	override public function create():Void{
		super.create();
		text = new FlxText(0, 0, 0, "Hello World", 16);
		text.screenCenter();
		text.getPosition().copyTo(position);
		add(text);
		FlxG.camera.follow(player, TOPDOWN, 1);
	}

	override public function update(elapsed:Float):Void{
		super.update(elapsed);
		FlxG.pixelPerfectOverlap(bullets,zombis,hitBulletZombi);
		FlxG.pixelPerfectOverlap(obstacles,zombis,hitObstacleZombi);
		/*t += 0.1;
		position.add(SPEED, 0);
		if(position.x > FlxG.camera.width) position.x = - 120;
		text.setPosition(position.x, position.y + Math.cos(t) * 10);*/
	}

	private function hitBulletZombi(b:Bullet,z:Zombie){
		bullets.remove(b);
		b.kill();

		z.getHit(b.damage);
		if(z.life<=0){
			zombis.remove(z);
			z.kill();
		}
	}

	private function hitObstacleZombi(o:Obstacle,z:Zombie){
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

	private function hitPlayerZombi(z:Zombie){
		player.getHit(z.damage);
		if(player.life<=0){
			FlxG.switchState(new DefeatState());
		}
	}
}
