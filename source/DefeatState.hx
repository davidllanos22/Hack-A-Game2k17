package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class DefeatState extends FlxState{

	private var _wave:Int;
	private var _txtTitle:FlxText;
	private var _txtScore:FlxText;
	private var _score:FlxText;
	private var _btnMenu:FlxButton; 
	private var _btnPlay:FlxButton;

	public function new(wave:Int):Void{
		_wave=wave;
		super();
	}

	override public function create():Void{
		_txtTitle = new FlxText (0, 20, 0, "GAME OVER", 32);
		_txtTitle.alignment = CENTER;
		_txtTitle.screenCenter(X);
		add(_txtTitle);

		_txtScore = new FlxText (0, 60, 0, "WAVE:"+_wave, 32);
		_txtScore.alignment = CENTER;
		_txtScore.screenCenter(X);
		add(_txtScore);

		_btnPlay = new FlxButton (0, 0, "Play", clickPlay);
		_btnPlay.x = (FlxG.width / 2) - _btnPlay.width -10;
		_btnPlay.y = FlxG.height - _btnPlay.height - 10;
		add (_btnPlay);

		_btnMenu = new FlxButton (0, 0, "Menu", clickMenu);
		_btnMenu.x = (FlxG.width / 2) + 10;
		_btnMenu.y = FlxG.height - _btnMenu.height - 10;
		add (_btnMenu);
	}

	override public function update(elapsed:Float):Void{
		super.update(elapsed);
	}

	private function clickPlay():Void{
		FlxG.switchState (new PlayState());
	}

	private function clickMenu():Void{
		FlxG.switchState (new MenuState());
	}
}