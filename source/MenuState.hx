package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.system.FlxSound;

class MenuState extends FlxState{
	private var _btnPlay:FlxButton;

	override public function create():Void{
		if (FlxG.sound.music == null){
			FlxG.sound.playMusic(AssetPaths.menu__wav, 0.5, true);
		}
		var text = new flixel.text.FlxText(0, 0, 0, "ZombieCraft", 48);
		text.screenCenter(X);
		add(text);
		_btnPlay = new FlxButton(0, 0, "Play", clickPlay);
		_btnPlay.screenCenter();
		_btnPlay.onUp.sound = FlxG.sound.load(AssetPaths.button__wav);
		add(_btnPlay);
		super.create();
	}

	override public function update(elapsed:Float):Void{
		super.update(elapsed);
	}

	private function clickPlay():Void{
		FlxG.sound.playMusic(AssetPaths.battle__wav, 0.5, true);
		FlxG.switchState(new PlayState());
	}
}
