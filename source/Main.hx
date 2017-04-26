package;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;

class Main extends Sprite{
	public function new(){
		super();
		addChild(new FlxGame(432, 243, PlayState)); 
		addChild(new FlxGame(432, 243, PlayState));
	}
}
